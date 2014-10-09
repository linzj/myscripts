import random, sys, time, socket

def gen_my_strs():
    forward_range = (1, 2, 3, 4)
    backward_range = (0, 7, 8);
    num = random.randint(0, 11) 
    if num in backward_range:
        if random.randint(0,1) == 1:
            mystr = ("press KEYCODE_BACK",)
        else:
            mystr = ("tap 120 1788",)
    elif num in forward_range:
        mystr = ("tap 363 1791",)
    elif num == 5:
        mystr = ("touch down 220 220", "touch move 220 240", "touch up 220 240",)
    elif num == 6:
        mystr = ("touch down 220 240", "touch move 220 220", "touch up 220 220",)
    else:
        mystr = ("tap %d %d" %(random.randint(10, 576), random.randint(300, 1100)),)
    return mystr

def get_connection():
    return socket.create_connection(('localhost', 1080))

def main():
    connection = get_connection()
    connection_file = connection.makefile()
    while True:
        mystrs = gen_my_strs()
        for mystr in mystrs:
            print mystr
            connection.send(mystr + "\n")
            line = connection_file.readline()
            if not line:
                break
            print line.rstrip()
        if not line:
            break
        time.sleep(0.4)

if __name__ == '__main__':
    main()
