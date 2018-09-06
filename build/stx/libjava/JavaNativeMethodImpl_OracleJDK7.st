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

JavaNativeMethodImpl_OpenJDK7 subclass:#JavaNativeMethodImpl_OracleJDK7
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Java 7'
!

!JavaNativeMethodImpl_OracleJDK7 class methodsFor:'documentation'!

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

!JavaNativeMethodImpl_OracleJDK7 class methodsFor:'native - java.io'!

_java_io_FileInputStream_read0: this 

    <javanative: 'java/io/FileInputStream' name: 'read0()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OracleJDK7 class methodsFor:'native - sun.misc'!

_sun_misc_Unsafe_shouldBeInitialized: this _: a1 

    <javanative: 'sun/misc/Unsafe' name: 'shouldBeInitialized(Ljava/lang/Class;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_VM_latestUserDefinedLoader: this 

    <javanative: 'sun/misc/VM' name: 'latestUserDefinedLoader()Ljava/lang/ClassLoader;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OracleJDK7 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaNativeMethodImpl_OracleJDK7.st,v 1.2 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

