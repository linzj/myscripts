rem buildcscope.bat
rem Attention: if -q is not working,please copy the sort.exe to current working directory instead of system32
SET PATH=D:\msys\1.0\bin;%PATH;
dir *.cpp *.h *.hpp *.c /s /B >tmp.lst
C:\windows\SysWOW64\cscope.exe -bqk -i tmp.lst
del tmp.lst
