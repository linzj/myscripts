import glob, sys, chardet

def doFile(filename):
    print 'handling file: {0}'.format(filename)
    with open(filename, 'rb') as f:
        data = f.read()
        result = chardet.detect(data)
        if not result:
            raise Exception('fail to detect encoding of file: ' + filename)
        encoding = result['encoding']
        confidence = result['confidence']
        if encoding.startswith('UTF-8'):
            print 'file: {0} is already encoded as UTF-8'.format(filename)
            return
        if confidence < 0.80:
            print 'file: {0} has been detected as {1} but confidence {2}, so get ignored'.format(filename, encoding, confidence)
            return
    data = data.decode(encoding).encode('UTF-8')
    with open(filename, 'wb') as f:
        f.write(data)


def main():
    files = glob.glob(sys.argv[1])
    for f in files:
        doFile(f)

if __name__ == '__main__':
    main()
