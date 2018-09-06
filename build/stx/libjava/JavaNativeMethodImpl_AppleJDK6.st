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

JavaNativeMethodImpl_OpenJDK6 subclass:#JavaNativeMethodImpl_AppleJDK6
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Java 6'
!

!JavaNativeMethodImpl_AppleJDK6 class methodsFor:'documentation'!

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

!JavaNativeMethodImpl_AppleJDK6 class methodsFor:'native - com.apple.java'!

_com_apple_java_AppleSystemLog_initASLNative: this 

    <javanative: 'com/apple/java/AppleSystemLog' name: 'initASLNative()Z'>

    ^ 0 "/ false
"/    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_apple_java_AppleSystemLog_logToASLNative: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 

    <javanative: 'com/apple/java/AppleSystemLog' name: 'logToASLNative(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_AppleJDK6 class methodsFor:'native - java.util.zip'!

_java_util_zip_ZipFile_open: this _: a1 _: a2 _: a3 _: a4 _: a5 

    <javanative: 'java/util/zip/ZipFile' name: 'open(Ljava/lang/String;IJZ)J'>

    ^ self _java_util_zip_ZipFile_open: this _: a1 _: a2 _: a3 _: a4 
! !

!JavaNativeMethodImpl_AppleJDK6 class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

