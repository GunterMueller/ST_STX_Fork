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

Object subclass:#JavaZipInflater
	instanceVariableNames:'vm z_stream'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Native'
!

!JavaZipInflater primitiveDefinitions!
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

!JavaZipInflater class methodsFor:'documentation'!

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

!JavaZipInflater methodsFor:'* As yet uncategorized *'!

> aSmallInteger
    ^z_stream address > 0

    "Created: / 23-07-2012 / 21:06:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaZipInflater methodsFor:'accessing'!

vm: javaVM

    vm := javaVM.

    "Created: / 30-08-2011 / 09:05:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaZipInflater methodsFor:'inflater methods'!

adler

%{
	RETURN ( __MKEXTERNALADDRESS ( __zStreamVal(__INST(z_stream))->adler ) );
%}

"
OpenJDK 7 Implementation:

JNIEXPORT jint JNICALL
Java_java_util_zip_Inflater_getAdler(JNIEnv *env, jclass cls, jlong addr)
{
    return ((z_stream *)jlong_to_ptr(addr))->adler;
}
"

    "Created: / 31-08-2011 / 09:30:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bytesRead

%{
	RETURN ( __MKSMALLINT( __zStreamVal(__INST(z_stream))->total_in));
%}


"
OpenJDK 7 Implementation:

JNIEXPORT jlong JNICALL
Java_java_util_zip_Inflater_getBytesRead(JNIEnv *env, jclass cls, jlong addr)
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
Java_java_util_zip_Inflater_getBytesWritten(JNIEnv *env, jclass cls, jlong addr)
{
    return ((z_stream *)jlong_to_ptr(addr))->total_out;
}
"

    "Created: / 31-08-2011 / 09:30:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

end

	| ok |

	ok := true.

%{
    if (inflateEnd(__zStreamVal(__INST(z_stream))) == Z_STREAM_ERROR) {
		ok = false;
	}
%}.
	z_stream free.
	ok ifFalse:[
	vm internalError: 'Cannot call inflateEnd()'.
	].

"
OpenJDK 7 Implementation:

JNIEXPORT void JNICALL
Java_java_util_zip_Inflater_end(JNIEnv *env, jclass cls, jlong addr)
{
    if (inflateEnd(jlong_to_ptr(addr)) == Z_STREAM_ERROR) {
	JNU_ThrowInternalError(env, 0);
    } else {
	free(jlong_to_ptr(addr));
    }
}

"

    "Created: / 30-08-2011 / 20:50:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inflate:"byte[]" out_buf offset: "int" out_off length: "int" out_len inflater: jinflater

	| in_buf in_off in_len finished needDict errorType errorMsg ret |
	in_buf := jinflater instVarNamed:#buf.
	in_off := jinflater instVarNamed:#off.
	in_len := jinflater instVarNamed:#len.

	finished := needDict := 0.

%{
#define strm (__zStreamVal(__INST(z_stream)))
	int code, consumed;

	strm->next_in = (Bytef *) (__ByteArrayInstPtr(in_buf)->ba_element + __intVal(in_off));
	strm->next_out = (Bytef *) (__ByteArrayInstPtr(out_buf)->ba_element + __intVal(out_off));
	strm->avail_in = __intVal(in_len);
	strm->avail_out = __intVal(out_len);


	code = inflate(strm, Z_PARTIAL_FLUSH);

	switch (code) {
		case Z_STREAM_END:
			finished = __MKSMALLINT(1);
			/* fall through */
		case Z_OK:
			consumed = __intVal(in_len) - strm->avail_in;
			in_off = __MKSMALLINT(__intVal(in_off) + consumed);
			in_len = __MKSMALLINT(__intVal(in_len) - consumed);
			ret = __MKSMALLINT(__intVal(out_len) - strm->avail_out);
			break;
		case Z_NEED_DICT:
			needDict = __MKSMALLINT(1);
			/* Might have consumed some input here! */
			consumed = __intVal(in_len) - strm->avail_in;
			in_off = __MKSMALLINT(__intVal(in_off) + consumed);
			in_len = __MKSMALLINT(__intVal(in_len) - consumed);
			ret = __MKSMALLINT(0);
			break;
		case Z_BUF_ERROR:
			ret = __MKSMALLINT(0);
			break;
		case Z_DATA_ERROR:
	    errorMsg = __MKSTRING(__zStreamVal(__INST(z_stream))->msg);
	    errorType = @symbol(DataFormatException);

			break;
		case Z_MEM_ERROR:
	    errorType = @symbol(OutOfMemoryError);
			break;
		default:
	    errorMsg = __MKSTRING(__zStreamVal(__INST(z_stream))->msg);
	    errorType = @symbol(InternalError);
			break;
    }
#undef strm
%}.
    errorType == #DataFormatException ifTrue:[
	vm throwDataFormatException: errorMsg.
	^0.
    ].
    errorType == #OutOfMemoryError ifTrue:[
	vm throwOutOfMemoryError.
	^0.
    ].
    errorType == #InternalError ifTrue:[
	vm internalError: errorMsg.
	^0.
    ].

	jinflater instVarNamed:#off put: in_off.
	jinflater instVarNamed:#len put: in_len.
	jinflater instVarNamed:#finished put: finished.
	jinflater instVarNamed:#needDict put: needDict.
	^ret

"
OpenJDK 7 Implementation

JNIEXPORT jint JNICALL
Java_java_util_zip_Inflater_inflateBytes(JNIEnv *env, jobject this, jlong addr,
					 jarray b, jint off, jint len)
{
    z_stream *strm = jlong_to_ptr(addr);

    jarray this_buf = (jarray)(*env)->GetObjectField(env, this, bufID);
    jint this_off = (*env)->GetIntField(env, this, offID);
    jint this_len = (*env)->GetIntField(env, this, lenID);
    jbyte *in_buf;
    jbyte *out_buf;
    int ret;
    /*
     * Avoid excess copying.
     *   zlib stream usually has a few bytes of overhead for header info
     *   (depends on the underlying data)
     *
     *   (a) 5 bytes per 16KB
     *   (b) 6 bytes for entire stream
     *   (c) 4 bytes for gzip header
     *   (d) 2 bytes for crc
     *
     * Use 20 bytes as the 'safe cutoff' number.
     */
    jint in_len = MIN2(this_len, len + 20);
    jint consumed;

    in_buf = (jbyte *) malloc(in_len);
    if (in_buf == 0) {
	JNU_ThrowOutOfMemoryError(env, 0);
	return 0;
    }
    (*env)->GetByteArrayRegion(env, this_buf, this_off, in_len, in_buf);

    out_buf = (jbyte *) malloc(len);
    if (out_buf == 0) {
	free(in_buf);
	JNU_ThrowOutOfMemoryError(env, 0);
	return 0;
    }

    strm->next_in  = (Bytef *) in_buf;
    strm->next_out = (Bytef *) out_buf;
    strm->avail_in  = in_len;
    strm->avail_out = len;
    ret = inflate(strm, Z_PARTIAL_FLUSH);

    if (ret == Z_STREAM_END || ret == Z_OK) {
	(*env)->SetByteArrayRegion(env, b, off, len - strm->avail_out, out_buf);
    }
    free(out_buf);
    free(in_buf);

    switch (ret) {
    case Z_STREAM_END:
	(*env)->SetBooleanField(env, this, finishedID, JNI_TRUE);
	/* fall through */
    case Z_OK:
	consumed = in_len - strm->avail_in;
	(*env)->SetIntField(env, this, offID, this_off + consumed);
	(*env)->SetIntField(env, this, lenID, this_len - consumed);
	return len - strm->avail_out;
    case Z_NEED_DICT:
	(*env)->SetBooleanField(env, this, needDictID, JNI_TRUE);
	/* Might have consumed some input here!! */
	consumed = in_len - strm->avail_in;
	(*env)->SetIntField(env, this, offID, this_off + consumed);
	(*env)->SetIntField(env, this, lenID, this_len - consumed);
	return 0;
    case Z_BUF_ERROR:
	return 0;
    case Z_DATA_ERROR:
	ThrowDataFormatException(env, strm->msg);
	return 0;
    case Z_MEM_ERROR:
	JNU_ThrowOutOfMemoryError(env, 0);
	return 0;
    default:
	JNU_ThrowInternalError(env, strm->msg);
	return 0;
    }
}

"

    "Created: / 30-08-2011 / 09:31:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

init: nowrap

    | z_stream_size errorType errorMsg |

%{  z_stream_size = __MKSMALLINT(sizeof(z_stream)); %}.

    z_stream := ExternalBytes unprotectedNew: z_stream_size.


%{
    switch (inflateInit2(__zStreamVal(__INST(z_stream)), nowrap ? -MAX_WBITS : MAX_WBITS)) {
	case Z_OK:
	    break;
	case Z_MEM_ERROR:
	    errorType = @symbol(OutOfMemoryError);
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
    errorType == #InternalError ifTrue:[
	vm internalError: errorMsg.
	^self.
    ].



    "
OpenJDK 7 Implementation:
JNIEXPORT jlong JNICALL
Java_java_util_zip_Inflater_init(JNIEnv *env, jclass cls, jboolean nowrap)
{
    z_stream *strm = calloc(1, sizeof(z_stream));

    if (strm == 0) {
	JNU_ThrowOutOfMemoryError(env, 0);
	return jlong_zero;
    } else {
	char *msg;
	switch (inflateInit2(strm, nowrap ? -MAX_WBITS : MAX_WBITS)) {
	  case Z_OK:
	    return ptr_to_jlong(strm);
	  case Z_MEM_ERROR:
	    free(strm);
	    JNU_ThrowOutOfMemoryError(env, 0);
	    return jlong_zero;
	  default:
	    msg = strm->msg;
	    free(strm);
	    JNU_ThrowInternalError(env, msg);
	    return jlong_zero;
	}
    }
}

    "

    "Created: / 29-08-2011 / 17:22:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-10-2012 / 20:28:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reset

%{
	if (inflateReset(__zStreamVal(__INST(z_stream))) == Z_OK) {
		RETURN ( self );
	}
%}.

	vm internalError: 'Cannot reset inflater'.

"
OpenJDK 7 Implementation:

JNIEXPORT void JNICALL
Java_java_util_zip_Inflater_reset(JNIEnv *env, jclass cls, jlong addr)
{
    if (inflateReset(jlong_to_ptr(addr)) !!= Z_OK) {
	JNU_ThrowInternalError(env, 0);
    }
}

"

    "Created: / 30-08-2011 / 12:45:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaZipInflater methodsFor:'initialization & release'!

finalize

    (z_stream notNil and:[z_stream isValid]) ifTrue:[self end].

    "Created: / 20-07-2012 / 21:50:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

