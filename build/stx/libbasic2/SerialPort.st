"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

NonPositionableExternalStream subclass:#SerialPort
	instanceVariableNames:'portName baudRate stopBitsType parityType dataBits inFlowCtrlType
		outFlowCtrlType xOnChar xOffChar'
	classVariableNames:'DefaultPortName'
	poolDictionaries:''
	category:'Streams-External'
!

!SerialPort primitiveDefinitions!
%{

#include "stxOSDefs.h"

#ifdef __win32__

/* this is to catch uses of those - there should be none */
# undef __BEGIN_INTERRUPTABLE__
# undef __END_INTERRUPTABLE__
# ifdef __TCC__
#  define __BEGIN_INTERRUPTABLE__ xxxx
#  define __END_INTERRUPTABLE__ yyyy
# else
#  define __BEGIN_INTERRUPTABLE__ ..
#  define __END_INTERRUPTABLE__ ..
# endif

# define WRAP_STDIO

# define PORT_FROM_FD(fd)     (_get_osfhandle(fd))
# define closePort(port)      closeHandle(port)
# define SERIALPORT           HANDLE

#else /* not __win32__ */

# define PORT_FROM_FD(fd)     (fd)
# define closePort(port)      close(port)
# define SERIALPORT           int

#endif /* __win32__ */

# define PORT_FROM_FILE(f)             (PORT_FROM_FD(fileno(f)))
# define PORT_FROM_FILE_OBJECT(f)      (PORT_FROM_FILE(__FILEVal(f)))

#include <stdio.h>
#include <errno.h>

/*
 * on some systems errno is a macro ... check for it here
 */
#ifndef errno
 extern errno;
#endif

#ifdef USE_H_ERRNO
# ifndef h_errno
 extern h_errno;
# endif
#endif

#ifdef DEBUG
# define DBGPRINTF(x)    { if (__debugging__) console_printf x; }
#else
# define DBGPRINTF(x)    /* as nothing */
#endif

#ifndef TRUE
# define TRUE   1
#endif
#ifndef FALSE
# define FALSE  0
#endif
#ifndef __win32__
typedef int BOOL;
#endif


%}
! !

!SerialPort primitiveVariables!
%{
static int __debugging__ = 0;
%}
! !

!SerialPort class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    This class provides access to serial ports.

    Before opening, the port should be configured, unless the default settings
    are not correct.
    i.e.
        port := SerialPort new.
        port setBaudrate:19200
        port open.
        
    Arguments/Parameters/Instvars:

        portName                String                  device name
                                                            WIN32:  COM0, COM1, ...
                                                            Unix:   /dev/ttyS0, ...
                                                                    /dev/cua0, ...

        baudRate                Integer                 9600, 19200, ...
        stopBitsType            Symbol                  #stop1, #stop1_5 or #stop2
        parityType              Symbol                  #odd, #even or #none
        dataBits                Integer                 5, 6, 7, 8
        inFlowCtrlType          Symbol                  #xOnOff, #hardware or #none
        outFlowCtrlType         Symbol                  #xOnOff, #hardware or #none
        xOnChar                 Integer | Character
        xOffChar'               Integer | Character
"
!

examples
"
    example (get help info from an nntp server):
									[exBegin]
    |serialPort|

    serialPort := SerialPort new setPortName:(SerialPort defaultPortName).
    serialPort open.
    serialPort close.
									[exEnd]

									[exBegin]
    |serialPort|

    serialPort := SerialPort new setPortName:'COM5'.
    serialPort open.
    serialPort nextPutAll:'hello world'.
    serialPort cr.
    serialPort close.
									[exEnd]

									[exBegin]
    |serialPort|

    serialPort := SerialPort new setPortName:'COM5'.
    serialPort open.
    Transcript showCR:(serialPort nextAvailable:100).
    serialPort close.
									[exEnd]
"
! !

!SerialPort class methodsFor:'instance creation'!

portName:portName
   baudRate:baudRateOrNil stopBitsType:stopBitsTypeOrNil
   parityType:parityTypeOrNil dataBits:dataBitsOrNil
   inFlowCtrlType:inFlowCtrlTypeOrNil outFlowCtrlType:outFlowCtrlTypeOrNil
   xOnChar:xOnCharOrNil xOffChar:xOffCharOrNil

    "arguments are self describing; nil values mean: leave setting as is.
    
     baudrate is a number i.e. 9600, 19200...
     stopBitsType must be one of: #stop1, #stop1_5 or #stop2
     parityType must be one of: #odd, #even or #none
     dataBits must be 5, 6, 7 or 8
     inFlowCtrlType must be one of: #xOnOff, #hardware or #none (or nil)
     outFlowCtrlType must be one of: #xOnOff, #hardware or #none (or nil)  
     xOnChar must be nil or a character or a small byte valued integer
     xOffChar must be nil or a character or a small byte valued integer
    "

    ^ self new
        setPortName:portName
        baudRate:baudRateOrNil stopBitsType:stopBitsTypeOrNil
        parityType:parityTypeOrNil dataBits:dataBitsOrNil
        inFlowCtrlType:inFlowCtrlTypeOrNil outFlowCtrlType:outFlowCtrlTypeOrNil
        xOnChar:xOnCharOrNil xOffChar:xOffCharOrNil
! !

!SerialPort class methodsFor:'debugging'!

debug:aBoolean
    "turn on/off internal debugprints.
     This method is for ST/X debugging only and
     may  be removed in later versions"

%{  /* NOCONTEXT */

    __debugging__ = (aBoolean == true);
%}
    "
     SerialPort debug:true
     SerialPort debug:false
    "
! !

!SerialPort class methodsFor:'defaults'!

defaultPortName
    DefaultPortName notNil ifTrue:[^ DefaultPortName ].

    OperatingSystem isMSDOSlike ifTrue:[
	^ 'COM0'
    ].
    ^ '/dev/ttyS0'
!

defaultPortName:aString
    DefaultPortName := aString
! !

!SerialPort methodsFor:'accessing'!

pathName
    "answer the port name - compatibilty with FileStream"

    ^ portName
!

setBaudRate:baudRateOrNil
    "baudrate is a number i.e. 9600, 19200....
     Must be set before opening."
    
    baudRate := baudRateOrNil.
!

setDataBits:dataBitsOrNil
    "dataBits must be 5, 6, 7 or 8.
     Must be set before opening."
    
    dataBits := dataBitsOrNil.
!

setInFlowCtrlType:inFlowCtrlTypeOrNil
    "inFlowCtrlType must be one of: #xOnOff, #hardware or #none (or nil)
     Must be set before opening."
    
    inFlowCtrlType := inFlowCtrlTypeOrNil.
!

setOutFlowCtrlType:outFlowCtrlTypeOrNil
    "outFlowCtrlType must be one of: #xOnOff, #hardware or #none (or nil)
     Must be set before opening."
    
    outFlowCtrlType := outFlowCtrlTypeOrNil.
!

setParityType:parityTypeOrNil
    "parityType must be one of: #odd, #even or #none.
     Must be set before opening."
    
    parityType := parityTypeOrNil.
!

setPortName:portNameArg
    "Must be set before opening."
    
    (portNameArg startsWith:'C') ifTrue:[
        "/ add special port name to support COM ports > 9
        portName := '\\.\', portNameArg.
        ^ self
    ].
    portName := portNameArg.
!

setPortName:portNameArg
        baudRate:baudRateOrNil stopBitsType:stopBitsTypeOrNil
        parityType:parityTypeOrNil dataBits:dataBitsOrNil
        inFlowCtrlType:inFlowCtrlTypeOrNil outFlowCtrlType:outFlowCtrlTypeOrNil
        xOnChar:xOnCharOrNil xOffChar:xOffCharOrNil

    "these must be set before opening.
     baudrate is a number i.e. 9600, 19200...
     stopBitsType must be one of: #stop1, #stop1_5 or #stop2
     parityType must be one of: #odd, #even or #none
     dataBits must be 5, 6, 7 or 8
     inFlowCtrlType must be one of: #xOnOff, #hardware or #none (or nil)
     outFlowCtrlType must be one of: #xOnOff, #hardware or #none (or nil)  
     xOnChar must be nil or a character or a small byte valued integer
     xOffChar must be nil or a character or a small byte valued integer
    "
    
    self setPortName:portNameArg.
    baudRate := baudRateOrNil.
    stopBitsType := stopBitsTypeOrNil.
    parityType := parityTypeOrNil.
    dataBits := dataBitsOrNil.
    inFlowCtrlType := inFlowCtrlTypeOrNil.
    outFlowCtrlType := outFlowCtrlTypeOrNil.
    xOnChar := xOnCharOrNil.
    xOffChar := xOffCharOrNil.
!

setStopBitsType:stopBitsTypeOrNil
    "stopBitsType must be one of: #stop1, #stop1_5 or #stop2.
     Must be set before opening."
    
    stopBitsType := stopBitsTypeOrNil.
!

setXOffChar:xOffCharOrNil
    "xOffChar must be nil or a character or a small byte valued integer.
     Must be set before opening."
    
    xOnChar := xOffCharOrNil.
!

setXOnChar:xOnCharOrNil
    "xOnChar must be nil or a character or a small byte valued integer.
     Must be set before opening."
    
    xOnChar := xOnCharOrNil.
! !

!SerialPort methodsFor:'initialization'!

initialize
    super initialize.
    "/ transparent
    eolMode := nil.
! !

!SerialPort methodsFor:'inspecting'!

inspectorExtraMenuOperations
    "extra operation-menu entries to be shown in an inspector.
     Answers a collection of pairs contining aString and action aBlock.
     aString is the label of the menu item.
     aBlock is evaluated when the menu item is selected.
     To be redefined in objects which think that it makes sense to offer
     often used operations in an inspector.
     See SerialPort as an example."

    ^ super inspectorExtraMenuOperations
    , {
        { 'Close SerialPort' . [self close] }
    }
! !

!SerialPort methodsFor:'low level'!

baudRate:newRate
    "allows change of the baudrate while being open.
     Currently, only works for windows.
     Unix users should close, reconfigure and reopen."
    
    handle isNil ifTrue:[
        "not open"
        baudRate := newRate.
        ^ self
    ].
%{
    OBJ fp;

    fp = __INST(handle);
    if (__isSmallInteger(newRate)) {
        SERIALPORT port;
        int ret;

        port = PORT_FROM_FILE_OBJECT(fp);
#ifdef __win32__
        {
            DCB dcb;

            ZeroMemory(&dcb, sizeof(dcb));
            dcb.DCBlength = sizeof(dcb);
            GetCommState(port, &dcb);

            dcb.BaudRate = __intVal(newRate);

            if (! SetCommState(port, &dcb)) {
                RETURN(false);
            }
            __INST(baudRate) = newRate;
            RETURN(true);
        }
# else /* ! __win32__ */
        /* add code for unix ioctl here ... */
# endif /* __win32__ */
    }
%}.
    self primitiveFailed.
! !

!SerialPort protectedMethodsFor:'low level'!

closeFile
    "low level close"

%{
    OBJ t = __INST(handle);
    if (t != nil) {
	FILE *fp = __FILEVal(t);

	__INST(handle) = nil;

#if defined(__win32__) && defined(xxxDO_WRAP_CALLS)
	{
	    int ret;

	    do {
		__threadErrno = 0;
		ret = STX_C_CALL1("fclose", fclose, fp);
	    } while ((ret < 0) && (__threadErrno == EINTR));
	}
#else
	fclose(fp);
#endif
    }
%}

    "Modified: / 05-08-2011 / 14:13:35 / cg"
! !

!SerialPort methodsFor:'opening'!

open
    "open the OS-port.
    Notice: all parameters (baudrate, stopbits, etc.) must have been set before"
    
    |errorSymbol errorNumber|

    handle notNil ifTrue:[
        ^ self errorAlreadyOpen
    ].
%{
    FILE *fp;
    SERIALPORT port;
    char *__portName;
    int __setBaudRate = 1,
        __setDataBits = 1,
        __setXOnChar = 1,
        __setXOffChar = 1,
        __setInFlowCtrl = 1,
        __setOutFlowCtrl = 1,
        __setStopBits = 1,
        __setParityType = 1;
    int __baudRate, __dataBits;
    int __xOnChar, __xOffChar;
    int __inFlowCtrl, __outFlowCtrl;
    int __stopBits, __parityType;
#ifdef __win32__
    COMMTIMEOUTS timeouts;
    DCB dcb;
#endif /* __win32__ */

#   define FLG_FLOW_XONOFF    1
#   define FLG_FLOW_HARDWARE  2
#   define FLG_FLOW_NONE      3
#   define FLG_STOP_1         1
#   define FLG_STOP_2         2
#   define FLG_STOP_1_5       3
#   define FLG_PARITY_ODD     1
#   define FLG_PARITY_EVEN    2
#   define FLG_PARITY_NONE    3

    if (__isStringLike(__INST(portName))) {
        __portName = __stringVal(__INST(portName));
    } else {
        errorSymbol = @symbol(portName);
        goto getOutOfhere;
    }

    if (__isSmallInteger(__INST(baudRate))) {
        __baudRate = __intVal(__INST(baudRate));
    } else if (__INST(baudRate) == nil) {
        __setBaudRate = 0;
    } else {
        errorSymbol = @symbol(baudRate);
        goto getOutOfhere;
    }

    if (__isSmallInteger(__INST(dataBits))) {
        __dataBits = __intVal(__INST(dataBits));
    } else if (__INST(dataBits) == nil) {
        __setDataBits = 0;
    } else {
        errorSymbol = @symbol(dataBits);
        goto getOutOfhere;
    }

    if (__isSmallInteger(__INST(xOnChar))) {
        __xOnChar = __intVal(__INST(xOnChar));
    } else if (__isCharacter(__INST(xOnChar))) {
        __xOnChar = __intVal(__characterVal(__INST(xOnChar)));
    } else if (__INST(xOnChar) == nil) {
        __setXOnChar = 0;
    } else {
        errorSymbol = @symbol(xOnChar);
        goto getOutOfhere;
    }

    if (__isSmallInteger(__INST(xOffChar))) {
        __xOffChar = __intVal(__INST(xOffChar));
    } else if (__isCharacter(__INST(xOffChar))) {
        __xOffChar = __intVal(__characterVal(__INST(xOffChar)));
    } else if (__INST(xOffChar) == nil) {
        __setXOffChar = 0;
    } else {
        errorSymbol = @symbol(xOffChar);
        goto getOutOfhere;
    }

    if (__INST(inFlowCtrlType) == @symbol(xOnOff)) {
        __inFlowCtrl = FLG_FLOW_XONOFF;
    } else if (__INST(inFlowCtrlType) == @symbol(hardware)) {
        __inFlowCtrl = FLG_FLOW_HARDWARE;
    } else if (__INST(inFlowCtrlType) == @symbol(none)) {
        __inFlowCtrl = FLG_FLOW_NONE;
    } else if (__INST(inFlowCtrlType) == nil) {
        __setInFlowCtrl = 0;
    } else {
        errorSymbol = @symbol(inFlowCtrlType);
        goto getOutOfhere;
    }

    if (__INST(outFlowCtrlType) == @symbol(xOnOff)) {
        __outFlowCtrl = FLG_FLOW_XONOFF;
    } else if (__INST(outFlowCtrlType) == @symbol(hardware)) {
        __outFlowCtrl = FLG_FLOW_HARDWARE;
    } else if (__INST(outFlowCtrlType) == @symbol(none)) {
        __outFlowCtrl = FLG_FLOW_NONE;
    } else if (__INST(outFlowCtrlType) == nil) {
        __setOutFlowCtrl = 0;
    } else {
        errorSymbol = @symbol(outFlowCtrlType);
        goto getOutOfhere;
    }

    if (__INST(stopBitsType) == @symbol(stop1)) {
        __stopBits = FLG_STOP_1;
    } else if (__INST(stopBitsType) == @symbol(stop2)) {
        __stopBits = FLG_STOP_2;
    } else if (__INST(stopBitsType) == @symbol(stop1_5)) {
        __stopBits = FLG_STOP_1_5;
    } else if (__INST(stopBitsType) == nil) {
        __setStopBits = 0;
    } else {
        errorSymbol = @symbol(stopBitsType);
        goto getOutOfhere;
    }

    if (__INST(parityType) == @symbol(odd)) {
        __parityType = FLG_PARITY_ODD;
    } else if (__INST(parityType) == @symbol(even)) {
        __parityType = FLG_PARITY_EVEN;
    } else if (__INST(parityType) == @symbol(none)) {
        __parityType = FLG_PARITY_NONE;
    } else if (__INST(parityType) == nil) {
        __setParityType = 0;
    } else {
        errorSymbol = @symbol(parityType);
        goto getOutOfhere;
    }

#ifdef __win32__
    port = CreateFile(__portName,
              GENERIC_READ | GENERIC_WRITE,
              0,             /* comm devices must be opened with exclusive access */
              NULL,          /* no security attrs */
              OPEN_EXISTING, /* comm devices must use OPEN_EXISTING */
              0,             /* no overlapped I/O */
              NULL           /* hTemplate must be NULL for comm devices */
           );

    if (port == INVALID_HANDLE_VALUE) {
        console_fprintf(stderr, "Win32OS [info]: serial port open failed\n");
        errorNumber = __mkSmallInteger( __WIN32_ERR(GetLastError()) );
        errorSymbol = @symbol(openFailed);
        goto getOutOfhere;
    }

    /* Flush the driver */
    PurgeComm( port, PURGE_TXABORT | PURGE_RXABORT | PURGE_TXCLEAR | PURGE_RXCLEAR );

    /* Set driver buffer sizes */
    SetupComm( port, 4096 /*SERIAL_IN_QUEUE_SIZE*/, 4096 /*SERIAL_OUT_QUEUE_SIZE*/);

    /* Reset timeout constants */
    timeouts.ReadIntervalTimeout= 0xFFFFFFFF;
    timeouts.ReadTotalTimeoutMultiplier = 0;
    timeouts.ReadTotalTimeoutConstant = 0;
    timeouts.WriteTotalTimeoutMultiplier = 0;
    timeouts.WriteTotalTimeoutConstant = 0;
    SetCommTimeouts( port, &timeouts );

    /* Set communication parameters */
    ZeroMemory(&dcb, sizeof(dcb));
    dcb.DCBlength = sizeof(dcb);
    GetCommState(port, &dcb);

    if (__setBaudRate) dcb.BaudRate = __baudRate;
    if (__setDataBits) dcb.ByteSize = __dataBits;
    if (__setXOnChar)  dcb.XonChar = __xOnChar;
    if (__setXOffChar) dcb.XoffChar = __xOffChar;

    if (__setStopBits) {
        /* set stop bits */
        switch(__stopBits) {
            case FLG_STOP_1_5: dcb.StopBits = 1; break; /* 1.5 stop bits */
            case FLG_STOP_1: dcb.StopBits = 0; break; /* 1 stop bit */
            case FLG_STOP_2: dcb.StopBits = 2; break; /* 2 stop bits */
            default:
                errorSymbol = @symbol(stopBits);
                goto errExit;
        }
    }

    if (__setParityType) {
        /* set parity */
        switch(__parityType) {
            case FLG_PARITY_NONE: dcb.Parity = NOPARITY; break;
            case FLG_PARITY_ODD: dcb.Parity = ODDPARITY; break;
            case FLG_PARITY_EVEN: dcb.Parity = EVENPARITY; break;
            default:
                errorSymbol = @symbol(parityType);
                goto errExit;
        }
    }

    if (__setInFlowCtrl) {
        /* set control flow */
        dcb.fInX = FALSE;
        dcb.fDtrControl = FALSE;
        if (__inFlowCtrl == FLG_FLOW_XONOFF) dcb.fInX = TRUE;  /* XOn/XOff handshaking */
        if (__inFlowCtrl == FLG_FLOW_HARDWARE) dcb.fDtrControl = TRUE;  /* hardware handshaking */
    }
    if (__setOutFlowCtrl) {
        dcb.fOutX = FALSE;
        dcb.fOutxCtsFlow = FALSE;

        if (__outFlowCtrl == FLG_FLOW_XONOFF) dcb.fOutX = TRUE;  /* XOn/XOff handshaking */
        if (__outFlowCtrl == FLG_FLOW_HARDWARE) dcb.fOutxCtsFlow = TRUE;  /* hardware handshaking */
    }

    if (! SetCommState(port, &dcb)) {
        console_fprintf(stderr, "Win32OS [info]: serial port comm-setup failed\n");
        errorNumber = __mkSmallInteger( __WIN32_ERR(GetLastError()) );
        goto errExit;
    }

    /*
     * make it a FILE *
     */
    {
        int _fd;
        __stxWrapApiEnterCritical();
        _fd = _open_osfhandle((long)port, 0);
        fp = fdopen(_fd, "r+");
        __stxWrapApiLeaveCritical();
    }
# else /* ! __win32__ */
    fp = fopen(__portName, "r+");
    /* add code for unix ioctl here ... */
# endif /* !__win32__ */

    if (! fp) {
        console_fprintf(stderr, "SerialPort [info]: fdopen failed\n");
        errorNumber = __MKSMALLINT(errno);

    errExit: ;
# ifdef __win32__
        CloseHandle(port);
# endif
        goto getOutOfhere;
    }

    {
        OBJ t = __MKEXTERNALADDRESS(fp);
        __INST(handle) = t;
        __STORE(self, t);
    }

getOutOfhere: ;
#   undef FLG_FLOW_XONOFF
#   undef FLG_FLOW_HARDWARE
#   undef FLG_FLOW_NONE
#   undef FLG_STOP_1
#   undef FLG_STOP_2
#   undef FLG_STOP_1_5
#   undef FLG_PARITY_ODD
#   undef FLG_PARITY_EVEN
#   undef FLG_PARITY_NONE

%}.
    "all ok?"
    handle notNil ifTrue:[
        handleType := #filePointer.
        self registerForFinalization.
    ] ifFalse:[
        self openError:(errorNumber ? 'invalid argument(s)').
    ].

    "Modified: / 05-08-2011 / 14:14:08 / cg"
! !

!SerialPort methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:'SerialPort('.
    portName printOn:aStream.
    baudRate notNil ifTrue:[
	aStream nextPut:$/.
	baudRate printOn:aStream.
    ].
    aStream nextPut:$).
! !

!SerialPort methodsFor:'queries'!

getBaudrate
    "return the baudRate"

    ^ baudRate
!

getDataBits
    "return the nr. of dataBits"

    ^ dataBits
!

getInFlowCtrlType
    "return the inFlowCtrlType"

    ^ inFlowCtrlType
!

getName
    "return the name; here, we return the devices name"

    ^ portName
!

getOutFlowCtrlType
    "return the outFlowCtrlType"

    ^ outFlowCtrlType
!

getParityType
    "return the parityType"

    ^ parityType
!

getStopBitsType
    "return the stopBitsType"

    ^ stopBitsType
!

getXOffChar
    "return the xOffChar"

    ^ xOffChar
!

getXOnChar
    "return the xOnChar"

    ^ xOnChar
! !

!SerialPort class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

