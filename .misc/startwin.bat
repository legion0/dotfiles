@echo off
SET DISPLAY=127.0.0.1:0.0
SET CYGWIN_ROOT=C:\cygwin
SET RUN=%CYGWIN_ROOT%\bin\run -p /usr/X11R6/bin
SET PATH=%CYGWIN_ROOT%\bin;%CYGWIN_ROOT%\usr\X11R6\bin;%PATH%
SET XAPPLRESDIR=/usr/X11R6/lib/X11/app-defaults
SET XCMSDB=/usr/X11R6/lib/X11/Xcms.txt
SET XKEYSYMDB=/usr/X11R6/lib/X11/XKeysymDB
SET XNLSPATH=/usr/X11R6/lib/X11/locale

if not exist %CYGWIN_ROOT%\tmp\.X11-unix\X0 goto CLEANUP-FINISH
attrib -s %CYGWIN_ROOT%\tmp\.X11-unix\X0
del %CYGWIN_ROOT%\tmp\.X11-unix\X0
:CLEANUP-FINISH

if exist %CYGWIN_ROOT%\tmp\.X11-unix rmdir %CYGWIN_ROOT%\tmp\.X11-unix
if "%OS%" == "Windows_NT" goto OS_NT
echo startxwin.bat - Starting on Windows 95/98/Me
goto STARTUP

:OS_NT
echo startxwin.bat - Starting on Windows NT/2000/XP/2003

:STARTUP
%RUN% XWin -rootless -clipboard -silent-dup-error
%RUN% /usr/bin/openbox
%RUN% /usr/bin/urxvt-X