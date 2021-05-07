#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import FTPServer  # <-
from pyftpdlib.authorizers import DummyAuthorizer
from pyftpdlib.ioloop import IOLoop
from pyftpdlib.handlers import TLS_FTPHandler
from pyftpdlib.filesystems import AbstractedFS

movie_path = 'D:\\Movies'
pic_path = 'D:\\pic_from_camera'
anonymous_port = 13393
secure_port = 13392
passive_ports_range = range(60000, 65535)

class CustomFS(AbstractedFS):
    def __init__(self, root, cmd_channel):
        AbstractedFS.__init__(self, root, cmd_channel)

    def validpath(self, path):
        # validpath was used to check symlinks escaping user home
        # directory; this is no longer necessary.
        return True

def StartAnonymousServer(ioloop):
    authorizer = DummyAuthorizer()
    authorizer.add_anonymous(movie_path)
    handler = FTPHandler
    handler.authorizer = authorizer
    handler.passive_ports = passive_ports_range
    FTPServer(('::0', anonymous_port), handler, ioloop)
    FTPServer(('0.0.0.0', anonymous_port), handler, ioloop)

def StartSecureServer(ioloop):
    authorizer = DummyAuthorizer()
    authorizer.add_user('s', 'aaa123', 'root', perm="elradfmwMT")
    handler = TLS_FTPHandler
    handler.authorizer = authorizer
    handler.passive_ports = passive_ports_range
    handler.certfile = 'server.pem'
    handler.abstracted_fs = CustomFS
    FTPServer(('::0', secure_port), handler, ioloop)
    FTPServer(('0.0.0.0', secure_port), handler, ioloop)

def main():
    ioloop = IOLoop()
    StartAnonymousServer(ioloop)
    StartSecureServer(ioloop)
    ioloop.loop(1.0, True)

if __name__ == "__main__":
    main()
