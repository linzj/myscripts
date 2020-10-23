# -*- coding: cp1252 -*-
# <PythonProxy.py>
#
#Copyright (c) <2009> <Fábio Domingues - fnds3000 in gmail.com>
#
#Permission is hereby granted, free of charge, to any person
#obtaining a copy of this software and associated documentation
#files (the "Software"), to deal in the Software without
#restriction, including without limitation the rights to use,
#copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the
#Software is furnished to do so, subject to the following
#conditions:
#
#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#OTHER DEALINGS IN THE SOFTWARE.

"""\
Copyright (c) <2009> <Fábio Domingues - fnds3000 in gmail.com> <MIT Licence>

                  **************************************
                 *** Python Proxy - A Fast HTTP proxy ***
                  **************************************

Neste momento este proxy é um Elie Proxy.

Suporta os métodos HTTP:
 - OPTIONS;
 - GET;
 - HEAD;
 - POST;
 - PUT;
 - DELETE;
 - TRACE;
 - CONENCT.

Suporta:
 - Conexões dos cliente em IPv4 ou IPv6;
 - Conexões ao alvo em IPv4 e IPv6;
 - Conexões todo o tipo de transmissão de dados TCP (CONNECT tunneling),
     p.e. ligações SSL, como é o caso do HTTPS.

A fazer:
 - Verificar se o input vindo do cliente está correcto;
   - Enviar os devidos HTTP erros se não, ou simplesmente quebrar a ligação;
 - Criar um gestor de erros;
 - Criar ficheiro log de erros;
 - Colocar excepções nos sítios onde é previsível a ocorrência de erros,
     p.e.sockets e ficheiros;
 - Rever tudo e melhorar a estrutura do programar e colocar nomes adequados nas
     variáveis e métodos;
 - Comentar o programa decentemente;
 - Doc Strings.

Funcionalidades futuras:
 - Adiconar a funcionalidade de proxy anónimo e transparente;
 - Suportar FTP?.


(!) Atenção o que se segue só tem efeito em conexões não CONNECT, para estas o
 proxy é sempre Elite.

Qual a diferença entre um proxy Elite, Anónimo e Transparente?
 - Um proxy elite é totalmente anónimo, o servidor que o recebe não consegue ter
     conhecimento da existência do proxy e não recebe o endereço IP do cliente;
 - Quando é usado um proxy anónimo o servidor sabe que o cliente está a usar um
     proxy mas não sabe o endereço IP do cliente;
     É enviado o cabeçalho HTTP "Proxy-agent".
 - Um proxy transparente fornece ao servidor o IP do cliente e um informação que
     se está a usar um proxy.
     São enviados os cabeçalhos HTTP "Proxy-agent" e "HTTP_X_FORWARDED_FOR".

"""

import socket, thread, select, datetime, traceback, sys, os

__version__ = '0.1.0 Draft 1'
BUFLEN = 8192
VERSION = 'Python Proxy/'+__version__
HTTPVER = 'HTTP/1.1'
socket_set = set ()
socket_set_lock = thread.allocate_lock ()
# a map with key, file name
#substitution_map = {}

class byte_buffer (object):
    def __init__ (self):
        self.data_ = ""

    def append (self, data):
        self.data_ += data

    def consume (self, length):
        self.data_ = self.data_[length:]

    def dry (self):
        self.data_ = ""

    def data (self):
        return self.data_

def add_socket (s):
    global socket_set, socket_set_lock
    socket_set_lock.acquire ()
    try:
        socket_set.add (s)
    finally:
        socket_set_lock.release ()

class passempty_handler (object):
    def __init__ (self):
        pass
    def handle (self, input_buffer, path):
        input_buffer.dry ()
        return (self, "")

class substitution_handler (object):
    def __init__ (self):
        pass
    def handle (self, input_buffer, path):
        input_buffer.dry ()
        with open(substitution_map[path], 'r') as f:
            print 'substitutiond %s' % path
            return (passempty_handler (), f.read ())


class passthrough_handler (object):
    def __init__ (self):
        pass

    def handle (self, input_buffer, path):
        output_data = input_buffer.data ()
        input_buffer.dry ()
        return (self, output_data)


class header_handler (object):
    def __init__ (self):
        self.headers_ = []
        self.is_end_ = False
        pass

    def handle (self, input_buffer, path):
        while True:
            h, is_end = self.parse_header (input_buffer)
            if h:
                self.headers_.append (h)
            if is_end:
                self.filter_headers (path)
                self.is_end_ = True
                output_data = self.write_header ()
                #print "Respond headers:\n%s" % output_data
                if path and path in substitution_map:
                    return (substitution_handler (), output_data)
                else:
                    return (passthrough_handler (), output_data)
            if not h:
                return (self, None)

    def parse_header (self, input_buffer):
        input_data = input_buffer.data ()
        end_line = input_data.find ('\r\n')
        if end_line == -1:
            return (None, False)
        if end_line == 0:
            input_buffer.consume (2)
            return (None, True)
        h = self.parse_header_line (input_data[:end_line])
        input_buffer.consume (end_line + 2)
        return (h, False)

    def parse_header_line (self, line):
        comm = line.find (':')
        return (line[:comm], line[comm + 1:].lstrip ())

    def filter_out_key (self, key):
        for i in range(len(self.headers_)):
            h = self.headers_[i]
            if h[0].lower () == key:
                del self.headers_[i]
                break

    def write_header (self):
        output = "\r\n".join (["%s: %s" % (h[0], h[1]) for h in self.headers_])

        return output + "\r\n\r\n"

    def filter_headers (self, path):
        self.filter_out_key ('cache-control')
        if path and path in substitution_map:
            self.filter_out_key ('content-encoding')
        self.substitution_content_length (path)
        self.headers_.append (('Cache-Control', 'no-store, no-cache, must-validate, max-age=0',))
        self.headers_.append (('Connection', 'closed',))

    def substitution_content_length (self, path):
        if path and path in substitution_map:
            size = os.stat (substitution_map[path]).st_size
            self.filter_out_key ('content-length')
            self.filter_out_key ('transfer-encoding')
            self.headers_.append (('Content-Length', '%d' % size,))

class respond_handler (object):
    def __init__ (self):
        pass
    def handle (self, input_buffer, path):
        input_data = input_buffer.data ()
        end_line = input_data.find ('\r\n')
        if end_line == -1:
            return (this, None)
        input_buffer.consume (end_line + 2)
        r = input_data[:end_line + 2]
        print "Respond :%s" % r
        return (header_handler (), r)

class respond_filter (object):
    def __init__ (self):
        self.buffer_ = byte_buffer ()
        self.handler_ = None
        self.reset_state ()

    def reset_state (self):
        self.handler_ = respond_handler ()

    def filter (self, data, path):
        self.buffer_.append (data)
        response_data = ""
        while True:
            old_handler = self.handler_
            new_handler, _response_data = old_handler.handle (self.buffer_, path)
            self.handler_ = new_handler
            if _response_data:
                response_data += _response_data
            if new_handler is old_handler:
                """
                data exhausted or pass through
                """
                break
            if not new_handler:
                """
                session ends
                """
                break
        if not new_handler:
            self.reset_state ()
        return response_data

class ConnectionHandler:
    def __init__(self, connection, address, timeout):
        self.log_file_ = None
        self.client = connection
        self.client_buffer = ''
        self.timeout = timeout
        self.method, self.path, self.protocol = self.get_base_header()
        self.respond_filter_ = respond_filter ()
        if self.method=='CONNECT':
            self.method_CONNECT()
        elif self.method in ('OPTIONS', 'GET', 'HEAD', 'POST', 'PUT',
                             'DELETE', 'TRACE'):
            self.method_others()
        self.client.close()
        self.target.close()

    def get_base_header(self):
        while 1:
            self.client_buffer += self.client.recv(BUFLEN)
            end = self.client_buffer.find('\n')
            if end!=-1:
                break
        print '%s'%self.client_buffer[:end]#debug
        data = (self.client_buffer[:end+1]).split()
        self.client_buffer = self.client_buffer[end+1:]
        return data

    def method_CONNECT(self):
        self._connect_target(self.path)
        self.client.send(HTTPVER+' 200 Connection established\n'+
                         'Proxy-agent: %s\n\n'%VERSION)
        self.client_buffer = ''
        self._read_write()        

    def method_others(self):
        self.path = self.path[7:]
        i = self.path.find('/')
        host = self.path[:i]        
        path = self.path[i:]
        self._connect_target(host)
        self.target.send('%s %s %s\n'%(self.method, path, self.protocol)+
                         self.client_buffer)
        self.client_buffer = ''
        self._read_write()

    def _connect_target(self, host):
        i = host.find(':')
        if i!=-1:
            port = int(host[i+1:])
            host = host[:i]
        else:
            port = 80
        (soc_family, _, _, _, address) = socket.getaddrinfo(host, port)[0]
        self.target = socket.socket(soc_family)
        add_socket (self.target)
        self.target.connect(address)

    def _read_write(self):
        time_out_max = self.timeout/3
        socs = [self.client, self.target]
        count = 0
        while 1:
            count += 1
            (recv, _, error) = select.select(socs, [], socs, 3)
            if error:
                break
            if recv:
                should_filter = False
                for in_ in recv:
                    data = in_.recv(BUFLEN)
                    if in_ is self.client:
                        out = self.target
                    else:
                        out = self.client
                        should_filter = self.method in ('GET', 'POST')
                    if data:
                        if should_filter:
                            pass_path = self.path
                            question_mark = pass_path.find('?')
                            if question_mark != -1:
                                pass_path = pass_path[:question_mark]
                            data = self.respond_filter_.filter (data, pass_path)
                        if not data:
                            continue
                        out.send (data)
                        if should_filter:
                            self.save (data)
                        count = 0
            if count == time_out_max:
                break
    def save (self, data):
        return
        p = self.path
        last_slash = p.rfind ('/')
        if last_slash != -1:
            p = p[last_slash + 1:]
        query = p.find ('?')
        if query != -1:
            p = p[:query]
        if not self.log_file_:
            self.log_file_ = open (p + datetime.datetime.now ().strftime ('%Y-%m-%d-%H-%M-%S-%f'), 'w')
        self.log_file_.write (data)

def start_server(host='0', port=8080, IPv6=False, timeout=60,
                  handler=ConnectionHandler):
    if IPv6==True:
        soc_type=socket.AF_INET6
    else:
        soc_type=socket.AF_INET
    soc = socket.socket(soc_type)
    soc.setsockopt (socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    add_socket (soc)
    soc.bind((host, port))
    print "Serving on %s:%d."%(host, port)#debug
    soc.listen(0)
    while 1:
        args = soc.accept()+(timeout,)
        add_socket (args[0])
        thread.start_new_thread(handler, args)

if __name__ == '__main__':
    try:
        global substitution_map
        with open ("substitution.map", "r") as f:
            substitution_map = eval (f.read ())
    except:
        traceback.print_exc (file=sys.stderr)
    try:
        start_server()
    except Exception as e:
        traceback.print_exc (file=sys.stderr)
        socket_set_lock.acquire ()
        try:
            for cs in socket_set:
                try:
                    cs.shutdown (socket.SHUT_RDWR)
                    cs.close ()
                except:
                    traceback.print_exc (file=sys.stderr)
        finally:
            socket_set_lock.release ()

