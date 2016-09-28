#!/usr/bin/python
import sys,re,multiprocessing,subprocess,shlex,traceback
import os.path
hexRe = re.compile('([0-9a-fA-F]{8})')

class AddressData(object):
    def __init__(self):
        self.soPath = None
        self.soName = None
        self.funcName = None
        self.lineInfo = None
        self.relativeAddress = None
    def __str__(self):
        return str((self.soName,self.funcName,self.lineInfo))
    def __repr__(self):
        return str(self)


class MapEntry(object):
    def __init__(self,r1,r2,soName,path):
        self.r1 = r1
        self.r2 = r2
        self.soName = soName
        self.path = path
    def __cmp__(self,num):
        if not isinstance( num, (int,long) ):
            print num
            raise ValueError()
        if self.r1 > num:
            return 1
        elif self.r1 <= num and self.r2 >= num:
            return 0
        else:
            return -1
    def __str__(self):
        return '({0:08x}, {1:08x}, {2})'.format(self.r1, self.r2, self.soName)

class SoJobEntry(object):
    def __init__(self,soName,shouldInitAdress = True):
        self.soName = soName
        if shouldInitAdress:
            self.addresses = []
        self.offset = 0

    def append(self,addr):
        self.addresses.append(addr)

    def relativeAddresses(self):
        return [ addr - self.offset for addr in self.addresses] 

    def sort(self):
        self.addresses.sort()

    def size(self):
        return len(self.addresses)

    def split(self,jobSize):
        _size = self.size()
        jobs = []
        offset = 0
        while _size > 0:
            _jobEntry = SoJobEntry(self.soName,shouldInitAdress = False)
            addressSize = 0
            if _size > jobSize:
                addressSize = jobSize
            else:
                addressSize = _size
            _jobEntry.addresses = self.addresses[offset:offset + addressSize]
            _jobEntry.offset = self.offset
            offset = offset + jobSize
            _size = _size - jobSize
            jobs.append(_jobEntry)
        return jobs

def parseMap(fileName):
    mapEnties = []
    with open(fileName,'r') as f:
        while True:
            line = f.readline()
            if not line:
                break
            # try:
            #     if line[20] != 'x':
            #         continue
            # except Exception as e:
            #     print e
            #     print line
            #     sys.exit(1)

            r1 = int(line[0:8],16)
            r2 = int(line[9:17],16)
            path = line[49:].rstrip()
            try:
                lastSlash = path.rindex('/')
            except ValueError:
                lastSlash = -1
                pass
            if lastSlash != -1:
                directory = path[0:lastSlash]
                soName = path[lastSlash + 1:]
            if len(mapEnties) > 0:
                lastEntry = mapEnties[-1]
                if lastEntry.r2 == r1:
                    if (lastSlash == -1 and not path) or (lastSlash != -1 and directory == lastEntry.path and soName == lastEntry.soName):
                        lastEntry.r2 = r2
                        continue
                if path and lastSlash != -1:
                    if r1 < lastEntry.r2 or r2 < lastEntry.r2:
                        print "error intercept: r1: {0:08x}, r2: {1:08x}, lastEntry.r1: {2:08x}, lastEntry.r2: {3:08x}, lastEntry.soName: {4}".format(r1, r2, lastEntry.r1, lastEntry.r2, lastEntry.soName);
                    mapEnties.append(MapEntry(r1, r2, soName, directory))
            else:
                if path and lastSlash != -1:
                    mapEnties.append(MapEntry(r1, r2, soName, directory))

    # print ' '.join(str(m) for m in mapEnties)
    return mapEnties
        
def binary_search(a, val, lo=0, hi=None):
    if hi is None:
        hi = len(a)
    while lo < hi:
        mid = (lo+hi)//2
        midval = a[mid]
        if midval < val:
            #printDebug("midval {0:08x}:{1:08x} < val {2:08x}".format(midval.r1,midval.r2,val))
            lo = mid+1
        elif midval > val: 
            #printDebug("midval {0:08x}:{1:08x} > val {2:08x}".format(midval.r1,midval.r2,val))
            hi = mid
        else:
            #printDebug("midval {0:08x}:{1:08x} = val {2:08x}".format(midval.r1,midval.r2,val))
            return mid
    return -1

def getUniqueNumbers(content):
    numbers = hexRe.findall(content)
    numberDict = {}
    for number in numbers:
        number = int(number,16)
        if number != 0:
            if number not in numberDict:
                numberDict[number] = None
    return numberDict.keys()

def generateMapEntryNumberPair(number,mapEnties):
    for number in numbers:
        index = binary_search(mapEnties,number)
        # print "{0:08x}, {1}".format(number, index)
        if index != -1:
            #printDebug("index = {0},number = {1:08X}".format(index,number))
            #printDebug("r1 = {0:08X},r2 = {1:08X},soName = {2}".format(mapEnties[index].r1,mapEnties[index].r2,mapEnties[index].soName))
            mapEntry = mapEnties[index]
            yield (mapEntry,number)
    

def updateSoJobs(number,mapEntry,SoJob):
    if mapEntry.soName in SoJob:
        SoJob[mapEntry.soName].append(number)
    else:
        jobEntry = SoJobEntry(mapEntry.soName)
        jobEntry.offset = mapEntry.r1
        jobEntry.append(number)
        SoJob[mapEntry.soName] = jobEntry
    return SoJob

def updateNumberDict(number,mapEntry,numberDict):
    if number in numberDict:
        numberDict[number].soName = mapEntry.soName
    elif number > mapEntry.r1:
        addrData = AddressData()
        addrData.soName = mapEntry.soName
        addrData.soPath = mapEntry.path
        addrData.relativeAddress = number - mapEntry.r1
        numberDict[number] = addrData

class Addr2LineParser(object):
    def __init__(self,sema):
        self.sema_ = sema

    def parse(self,line):
        InlineLine = self.parseInlineStatment(line)
        if InlineLine:
            myTuple = self.tryParseAtStatment(InlineLine)
            if not myTuple:
                self.sema_.onUnknowParse()
                return
            self.sema_.onInlineStatement(myTuple[0],myTuple[1])
            return

        myTuple = self.tryParseAtStatment(line)
        if myTuple:
            self.sema_.onAtStatement(myTuple[0],myTuple[1])
        else:
            self.sema_.onUnknowParse()

    def tryParseAtStatment(self,line):
        rindex = line.rfind(' at ')
        if rindex == -1:
            return None
        return (line[:rindex],line[rindex + 4 :])

    def parseInlineStatment(self,line):
        index = line.find('(inlined by) ')
        if index == -1:
            return None
        return line[index + 13:]

class WrongSemanticError(Exception):
    pass

class MySema(object):

    def __init__(self,callBack):
        self.funcName_ = None
        self.line_ = None
        self.callBack_ = callBack

    def onAtStatement(self,funcName,line):
        if self.funcName_:
            self.onFind()
        self.funcName_ = funcName
        self.line_ = line

    def onInlineStatement(self,funcName,line):
        self.funcName_ = funcName
        self.line_ = line

    def onUnknowParse(self):
        self.callBack_(True)

    def onFind(self):
        self.callBack_(False)
        self.funcName_ = None

    def onEnd(self):
        self.funcName_ = None
        self.callBack_(False)




def handleJob(job,full_path):
    jobNumbers = job.relativeAddresses()
    command_line = "addr2line -piCfe " + full_path + " " + " ".join([ "{0:08x} ".format(num) for num in jobNumbers ])
    p = subprocess.Popen(shlex.split(command_line),stdout=subprocess.PIPE)
    jobNumberIter = iter(jobNumbers)
    ret = []
    sema = None
    def callBack(shouldSkip):
        if shouldSkip:
            jobNumber = jobNumberIter.next()
            return

        jobNumber = jobNumberIter.next()
        ret.append((jobNumber + job.offset,(sema.funcName_,sema.line_)))
    sema = MySema(callBack)
        
    parser = Addr2LineParser(sema)
    #Count = 0
    while True:
        line = p.stdout.readline()
        if not line:
            break
        line = line.rstrip()
        try:
            parser.parse(line)
        except Exception as e:
            traceback.print_exc(file=sys.stderr)
            raise e

    callBack(False)
    return ret

def findInSearchPath(search_path,jobName):
    try:
        search_path.index(':') 
    except ValueError:
        full_path = search_path + '/' + jobName
        if os.path.isfile(full_path):
            return full_path
        return None
        
    for search_path_ in search_path.split(':'):
        full_path = search_path + '/' + jobName
        if os.path.isfile(full_path):
            return full_path
    return None
        


def handleJobs(numberDict,SoJob,search_path):
    pool_num = 3
    pool = multiprocessing.Pool(pool_num)
    results = []
    for job in SoJob:
        fullpath = findInSearchPath(search_path,job[0])
        if fullpath:
            jobEntry = job[1]
            if pool_num > 1:
                splitSize = (jobEntry.size() / pool_num ) + 1
                jobEntries = jobEntry.split(splitSize)
                for _jobEntry in jobEntries:
                    results.append(pool.apply_async(handleJob,(_jobEntry,fullpath)))
            else:
                results.append(pool.apply_async(handleJob,(jobEntry,fullpath)))
    for result in results:
        r = result.get()
        for element in r:
            number = element[0]
            if number in numberDict:
                funcName = element[1][0]
                lineInfo = element[1][1]
                addrData = numberDict[number]
                addrData.funcName = funcName
                addrData.lineInfo = lineInfo

def printContent(content,numberDict,f):
    findit = hexRe.finditer(content)
    offset = 0
    for match in findit:
        address = int(match.group(1),16)
        if address in numberDict:
            end = match.end()
            start = match.start()
            addrData = numberDict[address]
            f.write(content[offset:start])
            f.write("{4:08x} {2} at {1}".format(addrData.soPath,addrData.soName,addrData.funcName,addrData.lineInfo,addrData.relativeAddress))
            offset = end
    f.write(content[offset:])

if __name__ == '__main__':
    if len(sys.argv) != 3:
        #printError('<maps file> <search path>')
        print >>sys.stderr, '<maps file> <search path>'
        sys.exit(1)
    content = sys.stdin.read()

    mapEnties = parseMap(sys.argv[1])
    numbers = getUniqueNumbers(content)
    numberDict = {}
    SoJob =  {}
    for pair in generateMapEntryNumberPair(numbers,mapEnties):
        updateSoJobs(pair[1],pair[0],SoJob)
        updateNumberDict(pair[1],pair[0],numberDict)
    handleJobs(numberDict,SoJob.items(),sys.argv[2])
    printContent(content,numberDict,sys.stdout)
