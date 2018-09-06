"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaZipDeflater
	instanceVariableNames:'vm z_stream'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Native'
!

!JavaZipDeflater primitiveDefinitions!
%{

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "zlib.h"

#define MIN2(x, y)  ((x) < (y) ? (x) : (y))

#define DEF_MEM_LEVEL 8
#define __zStreamVal(x) ((z_stream *)(__ExternalBytesInstPtr(x)->e_address))

%}
! !

!JavaZipDeflater class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaZipDeflater methodsFor:'* As yet uncategorized *'!

> aSmallInteger
    ^(z_stream address ? 0) > aSmallInteger

    "Created: / 20-07-2012 / 22:21:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaZipDeflater methodsFor:'accessing'!

vm: javaVM

    vm := javaVM.

    "Created: / 30-08-2011 / 09:05:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaZipDeflater methodsFor:'deflater methods'!

adler

%{
        RETURN ( __MKEXTERNALADDRESS ( __zStreamVal(__INST(z_stream))->adler ) );
%}

    "Modified: / 25-07-2014 / 00:47:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bytesRead

%{
	RETURN ( __MKSMALLINT( __zStreamVal(__INST(z_stream))->total_in));
%}


"
OpenJDK 7 Implementation:

JNIEXPORT jlong JNICALL
Java_java_util_zip_Deflater_getBytesRead(JNIEnv *env, jclass cls, jlong addr)
{
    return ((z_stream *)jlong_to_ptr(addr))->total_in;
}
"

    "Created: / 31-08-2011 / 09:30:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bytesWritten

%{
	RETURN ( __MKSMALLINT( __zStreamVal(__INST(z_stream))->total_out));
%}


"
OpenJDK 7 Implementation:

JNIEXPORT jlong JNICALL
Java_java_util_zip_Deflater_getBytesWritten(JNIEnv *env, jclass cls, jlong addr)
{
    return ((z_stream *)jlong_to_ptr(addr))->total_out;
}
"

    "Created: / 31-08-2011 / 09:30:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deflate:"byte[]" out_buf offset: "int" out_off length: "int" out_len flush: flush deflater: deflater

	| in_buf in_off in_len setParams level strategy finish finished ret errorType errorMsg|
	in_buf := deflater instVarNamed:#buf.
	in_off := deflater instVarNamed:#off.
	in_len := deflater instVarNamed:#len.
	setParams := deflater instVarNamed:#setParams.
	level := deflater instVarNamed:#level.
	strategy := deflater instVarNamed:#strategy.
	finish := deflater instVarNamed:#finish.
%{
#define strm (__zStreamVal(__INST(z_stream)))
    int code;
    int consumed;

    strm->next_in = (Bytef *)(__ByteArrayInstPtr(in_buf)->ba_element+__intVal(in_off));
    strm->next_out = (Bytef *)(__ByteArrayInstPtr(out_buf)->ba_element+__intVal(out_off));
    strm->avail_in = __intVal(in_len);
    strm->avail_out = __intVal(out_len);

    if (__intVal(setParams)) {
	code = deflateParams(strm, __intVal(level), __intVal(strategy));
	switch (code) {
	    case Z_OK:
		setParams = __intVal(0);
		consumed = __intVal(in_len) - strm->avail_in;

		in_off = __MKSMALLINT(__intVal(in_off) + consumed);
		in_len = __MKSMALLINT(__intVal(in_len) - consumed);
		ret = __MKSMALLINT(__intVal(out_len) - strm->avail_out);
		break;
	    case Z_BUF_ERROR:
		setParams = __intVal(0);
		ret = __MKSMALLINT(0);
		break;
	    default:
		errorMsg = __MKSTRING(__zStreamVal(__INST(z_stream))->msg);
		errorType = @symbol(InternalError);
		break;
       }
    } else {
	code = deflate(strm, __intVal(finish) ? Z_FINISH : __intVal(flush));
	switch (code) {
	    case Z_STREAM_END:
		finished = __MKSMALLINT(1);
		/* fall through */
	    case Z_OK:
		consumed = __intVal(in_len) - strm->avail_in;
		in_off = __MKSMALLINT(__intVal(in_off) + consumed);
		in_len = __MKSMALLINT(__intVal(in_len) - consumed);
		ret = __MKSMALLINT(__intVal(out_len) - strm->avail_in);
		break;
	    case Z_BUF_ERROR:
		ret = __MKSMALLINT(0);
		break;
	    default:
		errorMsg = __MKSTRING(__zStreamVal(__INST(z_stream))->msg);
		errorType = @symbol(InternalError);
		break;
       }
    }
#undef strm
%}.
    errorType == #OutOfMemoryError ifTrue:[
	vm throwOutOfMemoryError.
	^0.
    ].
    errorType == #InternalError ifTrue:[
	vm internalError: errorMsg.
	^0.
    ].

    deflater instVarNamed:#off put: in_off.
    deflater instVarNamed:#len put: in_len.
    deflater instVarNamed:#finished put: finished.
    deflater instVarNamed:#setParams put: setParams.


    ^ret

"
OpenJDK 7 Implementation

JNIEXPORT jint JNICALL
Java_java_util_zip_Deflater_deflateBytes(JNIEnv *env, jobject this, jlong addr,
					 jarray b, jint off, jint len, jint flush)
{
    z_stream *strm = jlong_to_ptr(addr);

    jarray this_buf = (*env)->GetObjectField(env, this, bufID);
    jint this_off = (*env)->GetIntField(env, this, offID);
    jint this_len = (*env)->GetIntField(env, this, lenID);
    jbyte *in_buf;
    jbyte *out_buf;
    int res;
    if ((*env)->GetBooleanField(env, this, setParamsID)) {
	int level = (*env)->GetIntField(env, this, levelID);
	int strategy = (*env)->GetIntField(env, this, strategyID);

	in_buf = (jbyte *) malloc(this_len);
	if (in_buf == 0) {
	    JNU_ThrowOutOfMemoryError(env, 0);
	    return 0;
	}
	(*env)->GetByteArrayRegion(env, this_buf, this_off, this_len, in_buf);
	out_buf = (jbyte *) malloc(len);
	if (out_buf == 0) {
	    free(in_buf);
	    JNU_ThrowOutOfMemoryError(env, 0);
	    return 0;
	}

	strm->next_in = (Bytef *) in_buf;
	strm->next_out = (Bytef *) out_buf;
	strm->avail_in = this_len;
	strm->avail_out = len;
	res = deflateParams(strm, level, strategy);

	if (res == Z_OK) {
	    (*env)->SetByteArrayRegion(env, b, off, len - strm->avail_out, out_buf);
	}
	free(out_buf);
	free(in_buf);

	switch (res) {
	case Z_OK:
	    (*env)->SetBooleanField(env, this, setParamsID, JNI_FALSE);
	    this_off += this_len - strm->avail_in;
	    (*env)->SetIntField(env, this, offID, this_off);
	    (*env)->SetIntField(env, this, lenID, strm->avail_in);
	    return len - strm->avail_out;
	case Z_BUF_ERROR:
	    (*env)->SetBooleanField(env, this, setParamsID, JNI_FALSE);
	    return 0;
	default:
	    JNU_ThrowInternalError(env, strm->msg);
	    return 0;
	}
    } else {
	jboolean finish = (*env)->GetBooleanField(env, this, finishID);
	in_buf = (jbyte *) malloc(this_len);
	if (in_buf == 0) {
	    JNU_ThrowOutOfMemoryError(env, 0);
	    return 0;
	}
	(*env)->GetByteArrayRegion(env, this_buf, this_off, this_len, in_buf);

	out_buf = (jbyte *) malloc(len);
	if (out_buf == 0) {
	    free(in_buf);
	    JNU_ThrowOutOfMemoryError(env, 0);
	    return 0;
	}

	strm->next_in = (Bytef *) in_buf;
	strm->next_out = (Bytef *) out_buf;
	strm->avail_in = this_len;
	strm->avail_out = len;
	res = deflate(strm, finish ? Z_FINISH : flush);

	if (res == Z_STREAM_END || res == Z_OK) {
	    (*env)->SetByteArrayRegion(env, b, off, len - strm->avail_out, out_buf);
	}
	free(out_buf);
	free(in_buf);

	switch (res) {
	case Z_STREAM_END:
	    (*env)->SetBooleanField(env, this, finishedID, JNI_TRUE);
	    /* fall through */
	case Z_OK:
	    this_off += this_len - strm->avail_in;
	    (*env)->SetIntField(env, this, offID, this_off);
	    (*env)->SetIntField(env, this, lenID, strm->avail_in);
	    return len - strm->avail_out;
	case Z_BUF_ERROR:
	    return 0;
	    default:
	    JNU_ThrowInternalError(env, strm->msg);
	    return 0;
	}
    }
}
"

    "Created: / 20-07-2012 / 17:55:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

end

    | ok |

    ok := true.
%{
    if (deflateEnd(__zStreamVal(__INST(z_stream))) == Z_STREAM_ERROR) {
	ok = false;
    }
%}.
    z_stream free.
    ok ifFalse:[
       vm internalError: 'deflateEnd() failed!!'.
    ].

"
OpenJDK 7 Implementation:

JNIEXPORT void JNICALL
Java_java_util_zip_Deflater_end(JNIEnv *env, jclass cls, jlong addr)
{
    if (deflateEnd((z_stream *)jlong_to_ptr(addr)) == Z_STREAM_ERROR) {
	JNU_ThrowInternalError(env, 0);
    } else {
	free((z_stream *)jlong_to_ptr(addr));
    }
}
"

    "Created: / 30-08-2011 / 20:50:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

init: strategy level: level nowrap: nowrap

    | z_stream_size errorType errorMsg |

%{  z_stream_size = __MKSMALLINT(sizeof(z_stream)); %}.
    z_stream := ExternalBytes unprotectedNew: z_stream_size.
    z_stream address == 0 ifTrue:[
	vm throwOutOfMemoryError
    ].

%{
    switch (deflateInit2(__zStreamVal(__INST(z_stream)),
			 __intVal(level),
			 Z_DEFLATED,
			 (nowrap ? -MAX_WBITS : MAX_WBITS),
			 DEF_MEM_LEVEL,
			 __intVal(strategy) )) {
	case Z_OK:
	    break;
	case Z_MEM_ERROR:
	    errorType = @symbol(OutOfMemoryError);
	    break;
	case Z_STREAM_ERROR:
	    errorType = @symbol(StreamError);
	    break;
	default:
	    errorMsg = __MKSTRING(__zStreamVal(__INST(z_stream))->msg);
	    errorType = @symbol(InternalError);
	    break;
    }
%}.

    errorType isNil ifTrue:[
"/        self registerForFinalization.
	^self
    ].

    z_stream free.
    errorType == #OutOfMemoryError ifTrue:[
	vm throwOutOfMemoryError.
	^self.
    ].
    errorType == #StreamError ifTrue:[
	vm throwIllegalArgumentException:
	    'Z_STREAM_ERROR returned from inflateInit2'.
	^self.
    ].
    errorType == #InternalError ifTrue:[
	vm internalError: errorMsg.
	^self.
    ].

    vm internalError: 'Unknown error: ', errorMsg asString.



    "
OpenJDK 7 Implementation:

JNIEXPORT jlong JNICALL
Java_java_util_zip_Deflater_init(JNIEnv *env, jclass cls, jint level,
				 jint strategy, jboolean nowrap)
{
    z_stream *strm = calloc(1, sizeof(z_stream));

    if (strm == 0) {
	JNU_ThrowOutOfMemoryError(env, 0);
	return jlong_zero;
    } else {
	char *msg;
	switch (deflateInit2(strm, level, Z_DEFLATED,
			     nowrap ? -MAX_WBITS : MAX_WBITS,
			     DEF_MEM_LEVEL, strategy)) {
	  case Z_OK:
	    return ptr_to_jlong(strm);
	  case Z_MEM_ERROR:
	    free(strm);
	    JNU_ThrowOutOfMemoryError(env, 0);
	    return jlong_zero;
	  case Z_STREAM_ERROR:
	    free(strm);
	    JNU_ThrowIllegalArgumentException(env, 0);
	    return jlong_zero;
	  default:
	    msg = strm->msg;
	    free(strm);
	    JNU_ThrowInternalError(env, msg);
	    return jlong_zero;
	}
    }
    "

    "Created: / 29-08-2011 / 17:22:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-10-2012 / 20:27:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reset

%{
    if (deflateReset(__zStreamVal(__INST(z_stream))) == Z_OK) {
	RETURN ( self );
    }
%}.

	vm internalError: 'Cannot reset inflater'.

"
OpenJDK 7 Implementation:

JNIEXPORT void JNICALL
Java_java_util_zip_Deflater_reset(JNIEnv *env, jclass cls, jlong addr)
{
    if (deflateReset((z_stream *)jlong_to_ptr(addr)) !!= Z_OK) {
	JNU_ThrowInternalError(env, 0);
    }
}
"

    "Created: / 30-08-2011 / 12:45:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaZipDeflater methodsFor:'initialization & release'!

finalize

    (z_stream notNil and:[z_stream isValid]) ifTrue:[self end].

    "Created: / 20-07-2012 / 21:50:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaZipDeflater class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

