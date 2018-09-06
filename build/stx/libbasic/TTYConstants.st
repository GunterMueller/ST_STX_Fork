"
Copyright (c) 2017 Jan Vrany

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MeERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

SharedPool subclass:#TTYConstants
	instanceVariableNames:''
	classVariableNames:'NCCS VINTR VQUIT VERASE VKILL VEOF VTIME VMIN VSWTC VSTART VSTOP
		VSUSP0 VEOL VREPRINT VDISCARD VWERASE VLNEXT VEOL2 IGNBRK BRKINT
		IGNPAR PARMRK INPCK ISTRIP INLCR IGNCR ICRNL IUCLC IXON IXANY
		IXOFF IMAXBEL IUTF8 OPOST OLCUC ONLCR OCRNL ONOCR ONLRET OFILL
		OFDEL NLDLY NL0 NL1 CRDLY CR0 CR1 CR2 CR3 TABDLY TAB0 TAB1 TAB2
		TAB3 XTABS BSDLY BS0 BS1 VTDLY VT0 VT1 FFDLY FF0 FF1 CBAUD B0 B50
		B75 B110 B134 B150 B200 B300 B600 B1200 B1800 B2400 B4800 B9600
		B19200 B38400 EXTA B19200 EXTB B38400 CSIZE CS5 CS6 CS7 CS8
		CSTOPB CREAD PARENB PARODD HUPCL CLOCAL CBAUDEX BOTHER B57600
		B115200 B230400 B460800 B500000 B576000 B921600 B1000000 B1152000
		B1500000 B2000000 B2500000 B3000000 B3500000 B4000000 CIBAUD
		CMSPAR CRTSCTS IBSHIFT ISIG ICANON XCASE ECHO ECHOE ECHOK ECHONL
		NOFLSH TOSTOP ECHOCTL ECHOPRT ECHOKE FLUSHO PENDIN IEXTEN EXTPROC
		TCOOFF TCOON TCIOFF TCION TCIFLUSH TCOFLUSH TCIOFLUSH TCSANOW
		TCSADRAIN TCSAFLUSH'
	poolDictionaries:''
	category:'OS-Unix'
!

!TTYConstants primitiveDefinitions!
%{
#ifdef UNIX
# include <unistd.h>
# include <termios.h>
#endif
%}
! !

!TTYConstants class methodsFor:'documentation'!

copyright
"
Copyright (c) 2017 Jan Vrany

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MeERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

"
! !

!TTYConstants class methodsFor:'initialization'!

initialize

%{
#   ifdef NCCS
    @global(TTYConstants:NCCS) = __MKSMALLINT(NCCS);
#   endif

#   ifdef VINTR
    @global(TTYConstants:VINTR) = __MKSMALLINT(VINTR);
#   endif

#   ifdef VQUIT
    @global(TTYConstants:VQUIT) = __MKSMALLINT(VQUIT);
#   endif

#   ifdef VERASE
    @global(TTYConstants:VERASE) = __MKSMALLINT(VERASE);
#   endif

#   ifdef VKILL
    @global(TTYConstants:VKILL) = __MKSMALLINT(VKILL);
#   endif

#   ifdef VEOF
    @global(TTYConstants:VEOF) = __MKSMALLINT(VEOF);
#   endif

#   ifdef VTIME
    @global(TTYConstants:VTIME) = __MKSMALLINT(VTIME);
#   endif

#   ifdef VMIN
    @global(TTYConstants:VMIN) = __MKSMALLINT(VMIN);
#   endif

#   ifdef VSWTC
    @global(TTYConstants:VSWTC) = __MKSMALLINT(VSWTC);
#   endif

#   ifdef VSTART
    @global(TTYConstants:VSTART) = __MKSMALLINT(VSTART);
#   endif

#   ifdef VSTOP
    @global(TTYConstants:VSTOP) = __MKSMALLINT(VSTOP);
#   endif

#   ifdef VSUSP0
    @global(TTYConstants:VSUSP0) = __MKSMALLINT(VSUSP0);
#   endif

#   ifdef VEOL
    @global(TTYConstants:VEOL) = __MKSMALLINT(VEOL);
#   endif

#   ifdef VREPRINT
    @global(TTYConstants:VREPRINT) = __MKSMALLINT(VREPRINT);
#   endif

#   ifdef VDISCARD
    @global(TTYConstants:VDISCARD) = __MKSMALLINT(VDISCARD);
#   endif

#   ifdef VWERASE
    @global(TTYConstants:VWERASE) = __MKSMALLINT(VWERASE);
#   endif

#   ifdef VLNEXT
    @global(TTYConstants:VLNEXT) = __MKSMALLINT(VLNEXT);
#   endif

#   ifdef VEOL2
    @global(TTYConstants:VEOL2) = __MKSMALLINT(VEOL2);
#   endif

#   ifdef IGNBRK
    @global(TTYConstants:IGNBRK) = __MKSMALLINT(IGNBRK);
#   endif

#   ifdef BRKINT
    @global(TTYConstants:BRKINT) = __MKSMALLINT(BRKINT);
#   endif

#   ifdef IGNPAR
    @global(TTYConstants:IGNPAR) = __MKSMALLINT(IGNPAR);
#   endif

#   ifdef PARMRK
    @global(TTYConstants:PARMRK) = __MKSMALLINT(PARMRK);
#   endif

#   ifdef INPCK
    @global(TTYConstants:INPCK) = __MKSMALLINT(INPCK);
#   endif

#   ifdef ISTRIP
    @global(TTYConstants:ISTRIP) = __MKSMALLINT(ISTRIP);
#   endif

#   ifdef INLCR
    @global(TTYConstants:INLCR) = __MKSMALLINT(INLCR);
#   endif

#   ifdef IGNCR
    @global(TTYConstants:IGNCR) = __MKSMALLINT(IGNCR);
#   endif

#   ifdef ICRNL
    @global(TTYConstants:ICRNL) = __MKSMALLINT(ICRNL);
#   endif

#   ifdef IUCLC
    @global(TTYConstants:IUCLC) = __MKSMALLINT(IUCLC);
#   endif

#   ifdef IXON
    @global(TTYConstants:IXON) = __MKSMALLINT(IXON);
#   endif

#   ifdef IXANY
    @global(TTYConstants:IXANY) = __MKSMALLINT(IXANY);
#   endif

#   ifdef IXOFF
    @global(TTYConstants:IXOFF) = __MKSMALLINT(IXOFF);
#   endif

#   ifdef IMAXBEL
    @global(TTYConstants:IMAXBEL) = __MKSMALLINT(IMAXBEL);
#   endif

#   ifdef IUTF8
    @global(TTYConstants:IUTF8) = __MKSMALLINT(IUTF8);
#   endif

#   ifdef OPOST
    @global(TTYConstants:OPOST) = __MKSMALLINT(OPOST);
#   endif

#   ifdef OLCUC
    @global(TTYConstants:OLCUC) = __MKSMALLINT(OLCUC);
#   endif

#   ifdef ONLCR
    @global(TTYConstants:ONLCR) = __MKSMALLINT(ONLCR);
#   endif

#   ifdef OCRNL
    @global(TTYConstants:OCRNL) = __MKSMALLINT(OCRNL);
#   endif

#   ifdef ONOCR
    @global(TTYConstants:ONOCR) = __MKSMALLINT(ONOCR);
#   endif

#   ifdef ONLRET
    @global(TTYConstants:ONLRET) = __MKSMALLINT(ONLRET);
#   endif

#   ifdef OFILL
    @global(TTYConstants:OFILL) = __MKSMALLINT(OFILL);
#   endif

#   ifdef OFDEL
    @global(TTYConstants:OFDEL) = __MKSMALLINT(OFDEL);
#   endif

#   ifdef NLDLY
    @global(TTYConstants:NLDLY) = __MKSMALLINT(NLDLY);
#   endif

#   ifdef NL0
    @global(TTYConstants:NL0) = __MKSMALLINT(NL0);
#   endif

#   ifdef NL1
    @global(TTYConstants:NL1) = __MKSMALLINT(NL1);
#   endif

#   ifdef CRDLY
    @global(TTYConstants:CRDLY) = __MKSMALLINT(CRDLY);
#   endif

#   ifdef CR0
    @global(TTYConstants:CR0) = __MKSMALLINT(CR0);
#   endif

#   ifdef CR1
    @global(TTYConstants:CR1) = __MKSMALLINT(CR1);
#   endif

#   ifdef CR2
    @global(TTYConstants:CR2) = __MKSMALLINT(CR2);
#   endif

#   ifdef CR3
    @global(TTYConstants:CR3) = __MKSMALLINT(CR3);
#   endif

#   ifdef TABDLY
    @global(TTYConstants:TABDLY) = __MKSMALLINT(TABDLY);
#   endif

#   ifdef TAB0
    @global(TTYConstants:TAB0) = __MKSMALLINT(TAB0);
#   endif

#   ifdef TAB1
    @global(TTYConstants:TAB1) = __MKSMALLINT(TAB1);
#   endif

#   ifdef TAB2
    @global(TTYConstants:TAB2) = __MKSMALLINT(TAB2);
#   endif

#   ifdef TAB3
    @global(TTYConstants:TAB3) = __MKSMALLINT(TAB3);
#   endif

#   ifdef XTABS
    @global(TTYConstants:XTABS) = __MKSMALLINT(XTABS);
#   endif

#   ifdef BSDLY
    @global(TTYConstants:BSDLY) = __MKSMALLINT(BSDLY);
#   endif

#   ifdef BS0
    @global(TTYConstants:BS0) = __MKSMALLINT(BS0);
#   endif

#   ifdef BS1
    @global(TTYConstants:BS1) = __MKSMALLINT(BS1);
#   endif

#   ifdef VTDLY
    @global(TTYConstants:VTDLY) = __MKSMALLINT(VTDLY);
#   endif

#   ifdef VT0
    @global(TTYConstants:VT0) = __MKSMALLINT(VT0);
#   endif

#   ifdef VT1
    @global(TTYConstants:VT1) = __MKSMALLINT(VT1);
#   endif

#   ifdef FFDLY
    @global(TTYConstants:FFDLY) = __MKSMALLINT(FFDLY);
#   endif

#   ifdef FF0
    @global(TTYConstants:FF0) = __MKSMALLINT(FF0);
#   endif

#   ifdef FF1
    @global(TTYConstants:FF1) = __MKSMALLINT(FF1);
#   endif

#   ifdef CBAUD
    @global(TTYConstants:CBAUD) = __MKSMALLINT(CBAUD);
#   endif

#   ifdef B0
    @global(TTYConstants:B0) = __MKSMALLINT(B0);
#   endif

#   ifdef B50
    @global(TTYConstants:B50) = __MKSMALLINT(B50);
#   endif

#   ifdef B75
    @global(TTYConstants:B75) = __MKSMALLINT(B75);
#   endif

#   ifdef B110
    @global(TTYConstants:B110) = __MKSMALLINT(B110);
#   endif

#   ifdef B134
    @global(TTYConstants:B134) = __MKSMALLINT(B134);
#   endif

#   ifdef B150
    @global(TTYConstants:B150) = __MKSMALLINT(B150);
#   endif

#   ifdef B200
    @global(TTYConstants:B200) = __MKSMALLINT(B200);
#   endif

#   ifdef B300
    @global(TTYConstants:B300) = __MKSMALLINT(B300);
#   endif

#   ifdef B600
    @global(TTYConstants:B600) = __MKSMALLINT(B600);
#   endif

#   ifdef B1200
    @global(TTYConstants:B1200) = __MKSMALLINT(B1200);
#   endif

#   ifdef B1800
    @global(TTYConstants:B1800) = __MKSMALLINT(B1800);
#   endif

#   ifdef B2400
    @global(TTYConstants:B2400) = __MKSMALLINT(B2400);
#   endif

#   ifdef B4800
    @global(TTYConstants:B4800) = __MKSMALLINT(B4800);
#   endif

#   ifdef B9600
    @global(TTYConstants:B9600) = __MKSMALLINT(B9600);
#   endif

#   ifdef B19200
    @global(TTYConstants:B19200) = __MKSMALLINT(B19200);
#   endif

#   ifdef B38400
    @global(TTYConstants:B38400) = __MKSMALLINT(B38400);
#   endif

#   ifdef EXTA
    @global(TTYConstants:EXTA) = __MKSMALLINT(EXTA);
#   endif

#   ifdef B19200
    @global(TTYConstants:B19200) = __MKSMALLINT(B19200);
#   endif

#   ifdef EXTB
    @global(TTYConstants:EXTB) = __MKSMALLINT(EXTB);
#   endif

#   ifdef B38400
    @global(TTYConstants:B38400) = __MKSMALLINT(B38400);
#   endif

#   ifdef CSIZE
    @global(TTYConstants:CSIZE) = __MKSMALLINT(CSIZE);
#   endif

#   ifdef CS5
    @global(TTYConstants:CS5) = __MKSMALLINT(CS5);
#   endif

#   ifdef CS6
    @global(TTYConstants:CS6) = __MKSMALLINT(CS6);
#   endif

#   ifdef CS7
    @global(TTYConstants:CS7) = __MKSMALLINT(CS7);
#   endif

#   ifdef CS8
    @global(TTYConstants:CS8) = __MKSMALLINT(CS8);
#   endif

#   ifdef CSTOPB
    @global(TTYConstants:CSTOPB) = __MKSMALLINT(CSTOPB);
#   endif

#   ifdef CREAD
    @global(TTYConstants:CREAD) = __MKSMALLINT(CREAD);
#   endif

#   ifdef PARENB
    @global(TTYConstants:PARENB) = __MKSMALLINT(PARENB);
#   endif

#   ifdef PARODD
    @global(TTYConstants:PARODD) = __MKSMALLINT(PARODD);
#   endif

#   ifdef HUPCL
    @global(TTYConstants:HUPCL) = __MKSMALLINT(HUPCL);
#   endif

#   ifdef CLOCAL
    @global(TTYConstants:CLOCAL) = __MKSMALLINT(CLOCAL);
#   endif

#   ifdef CBAUDEX
    @global(TTYConstants:CBAUDEX) = __MKSMALLINT(CBAUDEX);
#   endif

#   ifdef BOTHER
    @global(TTYConstants:BOTHER) = __MKSMALLINT(BOTHER);
#   endif

#   ifdef B57600
    @global(TTYConstants:B57600) = __MKSMALLINT(B57600);
#   endif

#   ifdef B115200
    @global(TTYConstants:B115200) = __MKSMALLINT(B115200);
#   endif

#   ifdef B230400
    @global(TTYConstants:B230400) = __MKSMALLINT(B230400);
#   endif

#   ifdef B460800
    @global(TTYConstants:B460800) = __MKSMALLINT(B460800);
#   endif

#   ifdef B500000
    @global(TTYConstants:B500000) = __MKSMALLINT(B500000);
#   endif

#   ifdef B576000
    @global(TTYConstants:B576000) = __MKSMALLINT(B576000);
#   endif

#   ifdef B921600
    @global(TTYConstants:B921600) = __MKSMALLINT(B921600);
#   endif

#   ifdef B1000000
    @global(TTYConstants:B1000000) = __MKSMALLINT(B1000000);
#   endif

#   ifdef B1152000
    @global(TTYConstants:B1152000) = __MKSMALLINT(B1152000);
#   endif

#   ifdef B1500000
    @global(TTYConstants:B1500000) = __MKSMALLINT(B1500000);
#   endif

#   ifdef B2000000
    @global(TTYConstants:B2000000) = __MKSMALLINT(B2000000);
#   endif

#   ifdef B2500000
    @global(TTYConstants:B2500000) = __MKSMALLINT(B2500000);
#   endif

#   ifdef B3000000
    @global(TTYConstants:B3000000) = __MKSMALLINT(B3000000);
#   endif

#   ifdef B3500000
    @global(TTYConstants:B3500000) = __MKSMALLINT(B3500000);
#   endif

#   ifdef B4000000
    @global(TTYConstants:B4000000) = __MKSMALLINT(B4000000);
#   endif

#   ifdef CIBAUD
    @global(TTYConstants:CIBAUD) = __MKSMALLINT(CIBAUD);
#   endif

#   ifdef CMSPAR
    @global(TTYConstants:CMSPAR) = __MKSMALLINT(CMSPAR);
#   endif

#   ifdef CRTSCTS
    @global(TTYConstants:CRTSCTS) = __MKSMALLINT(CRTSCTS);
#   endif

#   ifdef IBSHIFT
    @global(TTYConstants:IBSHIFT) = __MKSMALLINT(IBSHIFT);
#   endif

#   ifdef ISIG
    @global(TTYConstants:ISIG) = __MKSMALLINT(ISIG);
#   endif

#   ifdef ICANON
    @global(TTYConstants:ICANON) = __MKSMALLINT(ICANON);
#   endif

#   ifdef XCASE
    @global(TTYConstants:XCASE) = __MKSMALLINT(XCASE);
#   endif

#   ifdef ECHO
    @global(TTYConstants:ECHO) = __MKSMALLINT(ECHO);
#   endif

#   ifdef ECHOE
    @global(TTYConstants:ECHOE) = __MKSMALLINT(ECHOE);
#   endif

#   ifdef ECHOK
    @global(TTYConstants:ECHOK) = __MKSMALLINT(ECHOK);
#   endif

#   ifdef ECHONL
    @global(TTYConstants:ECHONL) = __MKSMALLINT(ECHONL);
#   endif

#   ifdef NOFLSH
    @global(TTYConstants:NOFLSH) = __MKSMALLINT(NOFLSH);
#   endif

#   ifdef OSTOP
    @global(TTYConstants:OSTOP) = __MKSMALLINT(OSTOP);
#   endif

#   ifdef ECHOCTL
    @global(TTYConstants:ECHOCTL) = __MKSMALLINT(ECHOCTL);
#   endif

#   ifdef ECHOPRT
    @global(TTYConstants:ECHOPRT) = __MKSMALLINT(ECHOPRT);
#   endif

#   ifdef ECHOKE
    @global(TTYConstants:ECHOKE) = __MKSMALLINT(ECHOKE);
#   endif

#   ifdef FLUSHO
    @global(TTYConstants:FLUSHO) = __MKSMALLINT(FLUSHO);
#   endif

#   ifdef PENDIN
    @global(TTYConstants:PENDIN) = __MKSMALLINT(PENDIN);
#   endif

#   ifdef IEXTEN
    @global(TTYConstants:IEXTEN) = __MKSMALLINT(IEXTEN);
#   endif

#   ifdef EXTPROC
    @global(TTYConstants:EXTPROC) = __MKSMALLINT(EXTPROC);
#   endif

#   ifdef TCOOFF
    @global(TTYConstants:TCOOFF) = __MKSMALLINT(TCOOFF);
#   endif

#   ifdef TCOON
    @global(TTYConstants:TCOON) = __MKSMALLINT(TCOON);
#   endif

#   ifdef TCIOFF
    @global(TTYConstants:TCIOFF) = __MKSMALLINT(TCIOFF);
#   endif

#   ifdef TCION
    @global(TTYConstants:TCION) = __MKSMALLINT(TCION);
#   endif

#   ifdef TCIFLUSH
    @global(TTYConstants:TCIFLUSH) = __MKSMALLINT(TCIFLUSH);
#   endif

#   ifdef TCOFLUSH
    @global(TTYConstants:TCOFLUSH) = __MKSMALLINT(TCOFLUSH);
#   endif

#   ifdef TCIOFLUSH
    @global(TTYConstants:TCIOFLUSH) = __MKSMALLINT(TCIOFLUSH);
#   endif

#   ifdef TCSANOW
    @global(TTYConstants:TCSANOW) = __MKSMALLINT(TCSANOW);
#   endif

#   ifdef TCSADRAIN
    @global(TTYConstants:TCSADRAIN) = __MKSMALLINT(TCSADRAIN);
#   endif

#   ifdef TCSAFLUSH
    @global(TTYConstants:TCSAFLUSH) = __MKSMALLINT(TCSAFLUSH);
#   endif

%}

    "Created: / 26-05-2017 / 21:52:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TTYConstants class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


TTYConstants initialize!
