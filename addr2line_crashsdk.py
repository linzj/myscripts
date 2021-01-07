#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys, re, subprocess

class Calculator:
    def __init__(self, file_name):
        self.addr_re_ = re.compile('pc ([0-9a-fA-F]+) ')
        self.read_elf_re_ = re.compile('LOAD\s+0x[0-9a-fA-F]+\s+0x([0-9a-fA-F]+).*R E')
        self.exe_load_bias_ = 0
        self.page_size = 4096
        self.page_mask = ~(self.page_size - 1)
        self.file_name_ = file_name

    def FindFromElf(self):
        completed = subprocess.run(["readelf", "-e", self.file_name_], capture_output=True, encoding='utf-8', text=True)
        for line in completed.stdout.split('\n'):
            m = self.read_elf_re_.search(line)
            if not m:
                continue
            self.exe_load_bias_ = int(m.group(1), 16) & self.page_mask
            break

    def LoadFromStdin(self):
        self.FindFromElf()
        addr_set = []
        line_set = []
        while True:
            line = sys.stdin.readline()
            if not line:
                break
            m = self.addr_re_.search(line)
            if not m:
                continue
            addr = int(m.group(1), 16)
            actual_addr = addr + self.exe_load_bias_
            line_set.append(line.strip())
            addr_set.append(actual_addr)
        addr2line_comm = ['/home/linzj/src/binutils-gdb/building-aarch64/built/usr/local/bin/aarch64-linux-android-addr2line', '-apiCf', '-e', self.file_name_] + [ hex(num) for num in addr_set]
        subprocess.run(addr2line_comm)

def PrintUsage():
    print('needs a elf file name!', file=sys.stderr)
    sys.exit(1)

def Main():
    if len(sys.argv) != 2:
        PrintUsage()
    Calculator(sys.argv[1]).LoadFromStdin()

if __name__ == '__main__':
    Main()
