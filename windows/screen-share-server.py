#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess, socket, select
import errno, sys
import traceback

def StartFFmpegServer():
    ffmpeg_comm = ['D:\\ffmpeg-20161218-02aa070-win64-static\\bin\\ffmpeg.exe', 
    '-thread_queue_size', '4096', '-f', 'dshow', '-i', 'video=screen-capture-recorder', '-thread_queue_size', '4096', '-f', 'dshow', '-i', 'audio=virtual-audio-capturer', '-acodec', 'aac', '-c:v', 'h264_nvenc', '-preset', 'llhq', '-profile:v', 'high', '-pix_fmt', 'yuv420p', '-listen', '1',  '-f', 'mpegts', 'tcp://127.0.0.1:5554']
    subprocess.Popen(ffmpeg_comm, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

g_socket_handler = {}
g_ffmpeg_client_handler = None

class FFmpegClientHandler:
    def __init__(self, socket):
        self.socket_ = socket
        self.clients_ = []
        global g_socket_handler
        g_socket_handler[socket] = self
        socket.setblocking(False)
        global g_ffmpeg_client_handler
        g_ffmpeg_client_handler = self

    def AddClient(self, client):
        self.clients_.append(client)

    def RemoveClient(self, client):
        self.clients_.remove(client)

    def HandleSelect(self, read_list, write_list, err_list):
        read_list.append(self.socket_)
        err_list.append(self.socket_)

    def HandleRead(self):
        data = self.socket_.recv(4 * 1024 * 1024)
        # print(f'read {len(data)} bytes data from ffmpeg')
        for client in self.clients_:
            client.AppendData(data)

    def HandleErr(self):
        raise Exception('FFmpegClientHandler has error')

class ServerHandler:
    def __init__(self, socket):
        self.socket_ = socket
        global g_socket_handler
        g_socket_handler[socket] = self
        socket.setblocking(False)

    def HandleRead(self):
        new_client, info = self.socket_.accept()
        print(f'one more new client {info}')
        client_handler = ClientHandler(new_client)
        global g_ffmpeg_client_handler
        g_ffmpeg_client_handler.AddClient(client_handler)

    def HandleSelect(self, read_list, write_list, err_list):
        read_list.append(self.socket_)
        err_list.append(self.socket_)

    def HandleErr(self):
        raise Exception('ServerHandler has error')


class ClientHandler:
    def __init__(self, socket):
        self.socket_ = socket
        global g_socket_handler
        g_socket_handler[socket] = self
        socket.setblocking(False)
        self.buffers_ = []
        self.blocking_ = False

    def HandleWrite(self):
        finished = True
        try:
            while len(self.buffers_) > 0:
                b = self.buffers_[0]
                finished = b.Send(self.socket_)
                if finished:
                    self.buffers_.pop(0)
                    continue
                return
        except Exception as e:
            print(e)
            self.HandleErr()
        if finished:
            self.blocking_ = False

    def HandleSelect(self, read_list, write_list, err_list):
        if self.blocking_:
            write_list.append(self.socket_)
            err_list.append(self.socket_)

    def HandleErr(self):
        del g_socket_handler[self.socket_]
        g_ffmpeg_client_handler.RemoveClient(self)
        self.socket_.close()

    def AppendData(self, data):
        buffer_data = BufferData(data)
        if not self.blocking_:
            try:
                finished = buffer_data.Send(self.socket_)
                if finished:
                    return
                self.blocking_ = True
            except Exception as e:
                print(e)
                self.HandleErr()
        self.buffers_.append(buffer_data)

class BufferData:
    def __init__(self, data):
        self.data_ = data

    def Send(self, socket):
        try:
            sent = socket.send(self.data_)
            self.data_ = self.data_[sent:]
        except OSError as e:
            if e.errno != errno.EAGAIN and e.errno != errno.EWOULDBLOCK:
                raise e
        return len(self.data_) == 0

def ConnectToFFmpegServer():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(('127.0.0.1', 5554))
    FFmpegClientHandler(sock)

def CreateServer():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.bind(('0.0.0.0', 5555))
    sock.listen(5)
    ServerHandler(sock)

def MainLoop():
    print('Entered MainLoop')
    while True:
        read_list = []
        write_list = []
        err_list = []
        for handler in g_socket_handler.values():
            handler.HandleSelect(read_list, write_list, err_list)
        ready_to_read, ready_to_write, in_error = select.select(read_list, write_list, err_list)
        for r in ready_to_read:
            g_socket_handler[r].HandleRead()

        for w in ready_to_write:
            g_socket_handler[w].HandleWrite()

        for e in in_error:
            g_socket_handler[e].HandleErr()

def main():
    StartFFmpegServer()
    ConnectToFFmpegServer()
    CreateServer()
    MainLoop()

if __name__ == '__main__':
    main()
