"
 COPYRIGHT (c) 1999 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

OSFileHandle subclass:#UnixFileDescriptorHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Unix'
!

!UnixFileDescriptorHandle primitiveDefinitions!
%{
#include <stdio.h>
#include <errno.h>
%}

! !

!UnixFileDescriptorHandle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!UnixFileDescriptorHandle methodsFor:'input/output'!

readBytes:count into:aByteBuffer startingAt:firstIndex
    "read count bytes into a byte-buffer;
     Return the number of bytes read (negative on error)"

%{
    unsigned char *extPtr;
    int nRead = -1;
    INT fd = (INT)(__externalAddressVal(self));
    INT cnt, offs;
    int nInstBytes, objSize;

    if (! __bothSmallInteger(count, firstIndex)) {
        goto bad;
    }
    cnt = __smallIntegerVal(count);
    offs = __smallIntegerVal(firstIndex) - 1;

    if (fd < 0) {
        goto bad;
    }
    if (__isExternalBytesLike(aByteBuffer)) {
        OBJ sz;

        nInstBytes = 0;
        extPtr = (char *)(__externalBytesAddress(aByteBuffer));
        if (extPtr == NULL) goto bad;
        sz = __externalBytesSize(aByteBuffer);
        if (__isSmallInteger(sz)) {
            objSize = __smallIntegerVal(sz);
        } else {
            objSize = -1; /* unknown */
        }
    } else {
        OBJ oClass = __Class(aByteBuffer);
        int nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);

        nInstBytes = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
        switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
            case BYTEARRAY:
            case WORDARRAY:
            case LONGARRAY:
            case SWORDARRAY:
            case SLONGARRAY:
            case FLOATARRAY:
                break;
            case DOUBLEARRAY:
#ifdef __NEED_DOUBLE_ALIGN
                nInstBytes = (nInstBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
#endif
                break;
            case LONGLONGARRAY:
            case SLONGLONGARRAY:
#ifdef __NEED_LONGLONG_ALIGN
                nInstBytes = (nInstBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
#endif
                break;
            default:
                goto bad;
        }
        extPtr = (char *)0;
        objSize = __Size(aByteBuffer) - nInstBytes;
    }
    if ((offs >= 0)
     && (cnt >= 0)
     && ((objSize == -1) || (objSize >= (cnt + offs)))) {
        nRead = 0;

        do {
            int n;

            if (extPtr) {
                n = read(fd, extPtr+offs, cnt);
            } else {
                char *bp;

                /*
                 * on interrupt, anObject may be moved to another location.
                 * So we recompute the byte-address here.
                 */
                bp = __ByteArrayInstPtr(aByteBuffer)->ba_element + nInstBytes;

                n = read(fd, bp + offs, cnt);
            }
            if (n > 0) {
                cnt -= n;
                offs += n;
                nRead += n;
            } else {
                if (n < 0) {
                    if (errno == EINTR) {
                        continue;
                    }
                    break;
                }
            }
        } while (cnt > 0);

        RETURN (__mkSmallInteger(nRead));
    }
bad: ;
%}.
    ^ self primitiveFailed

    "
     |h buff n|

     h := self basicNew.
     h setFileDescriptor:0.
     buff := ByteArray new:10. buff inspect.
     n := h readBytes:10 into:buff startingAt:1.
     Transcript show:n; space; showCR:buff.
    "
!

writeBytes:count from:aByteBuffer startingAt:firstIndex
    "write count bytes from a byte-buffer;
     Return the number of bytes written (negative on error)"

%{
    unsigned char *extPtr;
    int nWritten = -1;
    INT fd = (INT)(__externalAddressVal(self));
    INT cnt, offs;
    int nInstBytes, objSize;

    if (! __bothSmallInteger(count, firstIndex)) {
        goto bad;
    }
    cnt = __smallIntegerVal(count);
    offs = __smallIntegerVal(firstIndex) - 1;

    if (fd < 0) {
        goto bad;
    }
    if (__isExternalBytesLike(aByteBuffer)) {
        OBJ sz;

        nInstBytes = 0;
        extPtr = (char *)(__externalBytesAddress(aByteBuffer));
        if (extPtr == NULL) goto bad;
        sz = __externalBytesSize(aByteBuffer);
        if (__isSmallInteger(sz)) {
            objSize = __smallIntegerVal(sz);
        } else {
            objSize = -1; /* unknown */
        }
    } else {
        OBJ oClass = __Class(aByteBuffer);
        int nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);

        nInstBytes = OHDR_SIZE + __OBJS2BYTES__(nInstVars);
        switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
            case BYTEARRAY:
            case WORDARRAY:
            case LONGARRAY:
            case SWORDARRAY:
            case SLONGARRAY:
            case FLOATARRAY:
                break;
            case DOUBLEARRAY:
#ifdef __NEED_DOUBLE_ALIGN
                nInstBytes = (nInstBytes-1+__DOUBLE_ALIGN) &~ (__DOUBLE_ALIGN-1);
#endif
                break;
            case LONGLONGARRAY:
            case SLONGLONGARRAY:
#ifdef __NEED_LONGLONG_ALIGN
                nInstBytes = (nInstBytes-1+__LONGLONG_ALIGN) &~ (__LONGLONG_ALIGN-1);
#endif
                break;
            default:
                goto bad;
        }
        extPtr = (char *)0;
        objSize = __Size(aByteBuffer) - nInstBytes;
    }
    if ((offs >= 0)
     && (cnt >= 0)
     && ((objSize == -1) || (objSize >= (cnt + offs)))) {
        nWritten = 0;

        do {
            int n;

            if (extPtr) {
                n = write(fd, extPtr+offs, cnt);
            } else {
                char *bp;

                /*
                 * on interrupt, anObject may be moved to another location.
                 * So we recompute the byte-address here.
                 */
                bp = __ByteArrayInstPtr(aByteBuffer)->ba_element + nInstBytes;

                n = write(fd, bp + offs, cnt);
            }
            if (n > 0) {
                cnt -= n;
                offs += n;
                nWritten += n;
            } else {
                if (n < 0) {
                    if (errno == EINTR) {
                        continue;
                    }
                    break;
                }
            }
        } while (cnt > 0);

        RETURN (__mkSmallInteger(nWritten));
    }
bad: ;
%}.
    ^ self primitiveFailed

    "
     |h buff n|

     h := self basicNew.
     h setFileDescriptor:1.
     buff := '12345678901234567890'.
     n := h writeBytes:10 from:buff startingAt:1.
    "
! !

!UnixFileDescriptorHandle methodsFor:'private-accessing'!

setFileDescriptor:anInteger

%{
    if (__isSmallInteger(anInteger)) {
	__externalAddressVal(self) = (OBJ)(__smallIntegerVal(anInteger));
    }
%}


! !

!UnixFileDescriptorHandle methodsFor:'release'!

closeFile
    "close the underlying file"

%{
    INT fd = (INT)(__externalAddressVal(self));

    if (fd > 0) {
	__externalAddressVal(self) = (OBJ)-1;
	close(fd);
    }
%}.

! !

!UnixFileDescriptorHandle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/UnixFileDescriptorHandle.st,v 1.12 2014-02-12 14:38:07 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/UnixFileDescriptorHandle.st,v 1.12 2014-02-12 14:38:07 stefan Exp $'
! !

