"
 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

JavaNativeMethodImpl_OpenJDK6 subclass:#JavaNativeMethodImpl_OpenJDK7
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'JavaVMData'
	category:'Languages-Java-Support-Java 7'
!

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'native - com.sun.tools.jdi'!

_com_sun_tools_jdi_SharedMemoryTransportService_accept0: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'com/sun/tools/jdi/SharedMemoryTransportService' name: 'accept0(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_tools_jdi_SharedMemoryTransportService_attach0: this _: a1 _: a2 _: a3 

    <javanative: 'com/sun/tools/jdi/SharedMemoryTransportService' name: 'attach0(Ljava/lang/String;J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_tools_jdi_SharedMemoryTransportService_initialize: this 

    <javanative: 'com/sun/tools/jdi/SharedMemoryTransportService' name: 'initialize()V'>

    "Nothing to do"

    "Modified: / 14-11-2013 / 14:27:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_com_sun_tools_jdi_SharedMemoryTransportService_name: this _: a1 _: a2 

    <javanative: 'com/sun/tools/jdi/SharedMemoryTransportService' name: 'name(J)Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_tools_jdi_SharedMemoryTransportService_startListening0: this _: a1 

    <javanative: 'com/sun/tools/jdi/SharedMemoryTransportService' name: 'startListening0(Ljava/lang/String;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_com_sun_tools_jdi_SharedMemoryTransportService_stopListening0: this _: a1 _: a2 

    <javanative: 'com/sun/tools/jdi/SharedMemoryTransportService' name: 'stopListening0(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'native - java.io'!

_java_io_FileInputStream_read0: this 

    <javanative: 'java/io/FileInputStream' name: 'read0()I'>

    ^ self _java_io_FileInputStream_read: this

    "Modified: / 07-02-2014 / 09:31:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileOutputStream_open: this _: a1 _: a2

    <javanative: 'java/io/FileOutputStream' name: 'open(Ljava/lang/String;Z)V'>

    ^ self commonOpen: this path: a1 forAppend: a2 == 1

    "Modified: / 12-11-2013 / 22:48:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileOutputStream_write: this _: byte _: append

    <javanative: 'java/io/FileOutputStream' name: 'write(IZ)V'>
    "
    /**
     * Writes the specified byte to this file output stream.
     *
     * @param   b   the byte to be written.
     * @param   append   {@code true} if the write operation first
     *     advances the position to the end of file
     */
    "
    | fdobj fd stream b |

    "/Java byte is signed, make it integer in 0-255"
    b := byte < 0 ifTrue:[ byte + 256] ifFalse:[byte ].
    fdobj := (this instVarNamed: #fd).
    fd    := fdobj instVarNamed: #fd.
    stream := self getOpenFileAt:fd.
    [
        append == 1 ifTrue:[ stream setToEnd ].
        stream nextPut: b.
    ] on: Error do:[:ex|
        JavaVM throwIOExceptionWithMessage:ex description
    ]

    "Modified: / 13-11-2013 / 09:34:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_io_FileOutputStream_writeBytes: this _:bytes _: offset _: count _: append

    <javanative: 'java/io/FileOutputStream' name: 'writeBytes([BIIZ)V'>

    ^ self anyStream_write: this bytes: bytes offset: offset count: count append: append == 1.

    "Modified: / 08-02-2013 / 11:57:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'native - java.lang'!

_java_lang_ClassLoader_getCaller: this _: a1

    <javanative: 'java/lang/ClassLoader' name: 'getCaller(I)Ljava/lang/Class;'>

    "/ index 0: java.lang.ClassLoader.class
    "/ index 1: the immediate caller of index 0.
    "/ index 2: the immediate caller of index 1.

    | ctx |

    ctx := self nativeContext sender.
    a1 timesRepeat:[
        ctx := ctx sender
    ].
    ^JavaVM reflection javaClassObjectForClass: ctx receiver class theNonMetaclass

    "Modified: / 07-02-2013 / 23:35:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_Class_getCheckMemberAccessMethod: this _: a1 

    <javanative: 'java/lang/Class' name: 'getCheckMemberAccessMethod(Ljava/lang/Class;)Ljava/lang/reflect/Method;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Thread_setNativeName: this _: a1

    <javanative: 'java/lang/Thread' name: 'setNativeName(Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_Throwable_fillInStackTrace: this _: a1

    <javanative: 'java/lang/Throwable' name: 'fillInStackTrace(I)Ljava/lang/Throwable;'>

    | java_lang_Throwable  exceptionObject  list  con |

    java_lang_Throwable := Java classNamed: 'java/lang/Throwable'.
    exceptionObject := this.

    "/
    "/ debugging only
    "/

    (java_lang_Throwable notNil and:[(exceptionObject isKindOf: java_lang_Throwable) not]) ifTrue: [
        self error:'Thrown object is not a java.lang.Throwable'.
    ].
    con := self nativeContext sender.
    "/ Just a guess, there is no comment what the parameter means...
    a1 timesRepeat: [ con := con sender ].

    "/
    "/ we are not interrested in all intermediate Exception frames ...
    "/

    FullExceptionTrace ifFalse: [
        "/ first, skip any JavaVM contexts
        [ con receiver == exceptionObject ] whileFalse: [ con := con sender ].

        "/ then, all exception-init contexts

        [ con receiver == exceptionObject ] whileTrue: [ con := con sender ].
    ].
    list := OrderedCollection new.
    [ con notNil ] whileTrue: [
        (con isJavaContext) ifTrue: [
            "/ add a copy, in case the context continues with some
            "/ cleanup ...
            list add: con shallowCopy
        ].
        con := con sender
    ].
    exceptionObject instVarNamed: 'backtrace' put: (list asArray).
    ^ nil.

    "Modified: / 08-02-2013 / 01:28:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_lang_UNIXProcess_forkAndExec: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'java/lang/UNIXProcess' name: 'forkAndExec([B[BI[BI[B[IZ)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'native - java.net'!

_java_net_NetworkInterface_getByIndex0: this _: a1 

    <javanative: 'java/net/NetworkInterface' name: 'getByIndex0(I)Ljava/net/NetworkInterface;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_net_TwoStacksPlainSocketImpl_initProto: this 

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'initProto()V'>

    "/ Nothing to do here...
!

_java_net_TwoStacksPlainSocketImpl_socketAccept: this _: a1 

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketAccept(Ljava/net/SocketImpl;)V'>

    ^ self _java_net_PlainSocketImpl_socketAccept: this _:a1
!

_java_net_TwoStacksPlainSocketImpl_socketAvailable: this 

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketAvailable()I'>

    ^self _java_net_PlainSocketImpl_socketAvailable: this
!

_java_net_TwoStacksPlainSocketImpl_socketBind: this _: addr _: port _: boolean 

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketBind(Ljava/net/InetAddress;IZ)V'>

    | family |

    family := (addr instVarNamed: #holder) instVarNamed: #family.
    family == 2"IPv6" ifTrue:[
        JavaVM throwSocketException: 'IPv6 protocol not supported'.
        ^self.
    ].

    (this instVarNamed: #fd) isNil ifTrue:[
        JavaVM throwSocketException: 'Socket closed'.
        ^self.
    ].

    ^self _java_net_PlainSocketImpl_socketBind: this _: addr _:  port
!

_java_net_TwoStacksPlainSocketImpl_socketClose0: this _: a1 

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketClose0(Z)V'>

    self commonClose: this
!

_java_net_TwoStacksPlainSocketImpl_socketConnect: this _:jaddr _: port _: timeout

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketConnect(Ljava/net/InetAddress;II)V'>

    self _java_net_PlainSocketImpl_socketConnect: this _:jaddr _: port _: timeout
!

_java_net_TwoStacksPlainSocketImpl_socketCreate: this _: a1 

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketCreate(Z)V'>

    self _java_net_PlainSocketImpl_socketCreate: this _: a1.
    this instVarNamed: #fd1 put: nil.
!

_java_net_TwoStacksPlainSocketImpl_socketGetOption: this _: a1 _: a2 

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketGetOption(ILjava/lang/Object;)I'>

    ^ self _java_net_PlainSocketImpl_socketGetOption: this _:a1 _: a2
!

_java_net_TwoStacksPlainSocketImpl_socketListen: this _: a1 

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketListen(I)V'>

    ^self _java_net_PlainSocketImpl_socketListen: this _:a1
!

_java_net_TwoStacksPlainSocketImpl_socketNativeSetOption: this _: a1 _: a2 _: a3 

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketNativeSetOption(IZLjava/lang/Object;)V'>

    ^self _java_net_PlainSocketImpl_socketSetOption: this _:a1 _: a2 _: a3
!

_java_net_TwoStacksPlainSocketImpl_socketSendUrgentData: this _: data

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketSendUrgentData(I)V'>

    ^ self _java_net_PlainSocketImpl_socketSendUrgentData: this _: data
!

_java_net_TwoStacksPlainSocketImpl_socketShutdown: this _: what

    <javanative: 'java/net/TwoStacksPlainSocketImpl' name: 'socketShutdown(I)V'>

    ^ self _java_net_PlainSocketImpl_socketShutdown: this _: what
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'native - java.nio'!

_java_nio_MappedByteBuffer_force0: this _: a1 _: a2 _: a3 _: a4 _: a5 

    <javanative: 'java/nio/MappedByteBuffer' name: 'force0(Ljava/io/FileDescriptor;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'native - java.util.zip'!

_java_util_zip_Deflater_deflateBytes: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 

    <javanative: 'java/util/zip/Deflater' name: 'deflateBytes(J[BIII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_util_zip_ZipFile_getCommentBytes: this _: jzentry _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getCommentBytes(J)[B'>

    |  zmember |

    zmember := ZipEntryCache at: jzentry.
    ^zmember fileComment asByteArray

    "Modified: / 08-02-2013 / 09:46:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getEntry: this _: a1 _: a2 _: a3 _: a4

    <javanative: 'java/util/zip/ZipFile' name: 'getEntry(J[BZ)J'>
    "
    !!!!!!WARNING!!!!!!!!
    In Open JDK 7, it takes byte array instead of string like in Open JDK 6!!!!!!!!
    "

    | zipArchive  filename  member |

    zipArchive := self getZipArchiveAt:a1.
    filename := a3 asString.
    member := (zipArchive findMemberAllowForMissingTrailingSlash: filename).
    member isNil ifTrue: [
        ^ 0
    ] ifFalse: [
        "/^ ZipEntryCache indexOf: member ifAbsent:[
            | index |

            ZipEntryCacheLock critical:[
                ZipEntryCacheFirstFree == 0 ifTrue:[
                    ZipEntryCache add: member.
                    index := ZipEntryCache size.
                ] ifFalse:[
                    index := ZipEntryCacheFirstFree.
                    ZipEntryCacheFirstFree := ZipEntryCache at: index.
                    ZipEntryCache at: index put: member.
                ].
            ].
            "/Logger
            "/    log: 'java.util.zip.ZipFile.getEntry() called for ', index printString
            "/    severity: #debug
            "/    facility: 'JVM'.
            ^ index.
        "/].
    ]

    "Modified: / 10-12-2013 / 00:56:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getEntryBytes: this _: jzentry _: a2 _: type

    <javanative: 'java/util/zip/ZipFile' name: 'getEntryBytes(JI)[B'>

    |  zmember |

    zmember := ZipEntryCache at: jzentry.
    type == 0 "JZENTRY_NAME" ifTrue:[
        ^zmember fileNameLength == 0
            ifTrue:[nil]
            ifFalse:[zmember fileName asByteArray].
    ].
    type == 1 "JZENTRY_EXTRA" ifTrue:[
        ^zmember extraFieldLength == 0
            ifTrue:[nil]
            ifFalse:[zmember extraField asByteArray].
    ].
    type == 2 "JZENTRY_COMMENT" ifTrue:[
        ^zmember fileCommentLength == 0
            ifTrue:[nil]
            ifFalse:[zmember fileComment asByteArray].
    ].
    self breakPoint: #jv.
    JavaVM throwZipException: 'Unknown type in getEntryBytes()'.

    "Modified: / 15-11-2013 / 22:58:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getEntryCSize: this _: jzentry _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getEntryCSize(J)J'>

    |  zmember |

    zmember := ZipEntryCache at: jzentry.
    ^zmember compressedSize

    "Modified: / 08-02-2013 / 09:44:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getEntryCrc: this _: jzentry _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getEntryCrc(J)J'>

    |  zmember |

    zmember := ZipEntryCache at: jzentry.
    ^zmember crc32

    "Modified: / 08-02-2013 / 09:45:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getEntryFlag: this _: jzentry _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getEntryFlag(J)I'>

    |  zmember |

    zmember := ZipEntryCache at: jzentry.
    ^zmember generalPurposBitFlag

    "Modified: / 08-02-2013 / 09:42:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getEntryMethod: this _: jzentry _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getEntryMethod(J)I'>

    |  zmember |

    zmember := ZipEntryCache at: jzentry.
    ^zmember compressionMethod

    "Modified: / 08-02-2013 / 09:44:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getEntrySize: this _: jzentry _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getEntrySize(J)J'>

    |  zmember |

    zmember := ZipEntryCache at: jzentry.
    ^zmember uncompressedSize

    "Modified: / 08-02-2013 / 09:43:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_getEntryTime: this _: jzentry _: a2

    <javanative: 'java/util/zip/ZipFile' name: 'getEntryTime(J)J'>

    |  zmember |

    zmember := ZipEntryCache at: jzentry.
    ^zmember lastModFileTime

    "Modified: / 08-02-2013 / 09:45:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_java_util_zip_ZipFile_open: this _: a1 _: a2 _: a3 _: a4 _: usemmap

    <javanative: 'java/util/zip/ZipFile' name: 'open(Ljava/lang/String;IJZ)J'>

    "No mmap support for zip files yet, use Open JDK 6 implementation"

    ^self _java_util_zip_ZipFile_open: this _: a1 _: a2 _: a3 _: a4

    "Modified: / 23-04-2013 / 10:00:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'native - sun.misc'!

_sun_misc_Unsafe_copyMemory: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8

    <javanative: 'sun/misc/Unsafe' name: 'copyMemory(Ljava/lang/Object;JLjava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_defineAnonymousClass: this _: a1 _: a2 _: a3

    <javanative: 'sun/misc/Unsafe' name: 'defineAnonymousClass(Ljava/lang/Class;[B[Ljava/lang/Object;)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_isBigEndian0: this 

    <javanative: 'sun/misc/Unsafe' name: 'isBigEndian0()Z'>

    ^ UninterpretedBytes isBigEndian ifTrue:[1] ifFalse:[0].

    "Modified: / 08-08-2016 / 00:41:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_Unsafe_setMemory: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6

    <javanative: 'sun/misc/Unsafe' name: 'setMemory(Ljava/lang/Object;JJB)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_shouldBeInitialized: this _: a1 

    <javanative: 'sun/misc/Unsafe' name: 'shouldBeInitialized(Ljava/lang/Class;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_misc_Unsafe_unalignedAccess0: this 

    <javanative: 'sun/misc/Unsafe' name: 'unalignedAccess0()Z'>

    ^ (#(i386 x86_64) includes: OperatingSystem getCPUType) ifTrue:[ 1 ] ifFalse:[ 0 ]

    "Modified: / 08-08-2016 / 00:44:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_sun_misc_VM_latestUserDefinedLoader: this 

    <javanative: 'sun/misc/VM' name: 'latestUserDefinedLoader()Ljava/lang/ClassLoader;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'native - sun.net'!

_sun_net_PortConfig_getLower0: this 

    <javanative: 'sun/net/PortConfig' name: 'getLower0()I'>

    ^ -1 "/ meaning: use default 
!

_sun_net_PortConfig_getUpper0: this 

    <javanative: 'sun/net/PortConfig' name: 'getUpper0()I'>

    ^ -1 "/ meaning: use default 
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'native - sun.nio.fs'!

_sun_nio_fs_UnixNativeDispatcher_access0: this _: a1 _: a2 _: a3 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'access0(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_chmod0: this _: a1 _: a2 _: a3 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'chmod0(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_chown0: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'chown0(JII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_close: this _: a1 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'close(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_closedir: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'closedir(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_dup: this _: a1 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'dup(I)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_fchmod: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'fchmod(II)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_fchown: this _: a1 _: a2 _: a3 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'fchown(III)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_fclose: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'fclose(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_fdopendir: this _: a1 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'fdopendir(I)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_fopen0: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'fopen0(JJ)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_fpathconf: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'fpathconf(II)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_fstat: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'fstat(ILsun/nio/fs/UnixFileAttributes;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_fstatat0: this _: a1 _: a2 _: a3 _: a4 _: a5 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'fstatat0(IJILsun/nio/fs/UnixFileAttributes;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_futimes: this _: a1 _: a2 _: a3 _: a4 _: a5 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'futimes(IJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_getcwd: this 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'getcwd()[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_getgrgid: this _: a1 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'getgrgid(I)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_getgrnam0: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'getgrnam0(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_getpwnam0: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'getpwnam0(J)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_getpwuid: this _: a1 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'getpwuid(I)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_init: this 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'init()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_lchown0: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'lchown0(JII)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_link0: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'link0(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_lstat0: this _: a1 _: a2 _: a3 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'lstat0(JLsun/nio/fs/UnixFileAttributes;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_mkdir0: this _: a1 _: a2 _: a3 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'mkdir0(JI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_mknod0: this _: a1 _: a2 _: a3 _: a4 _: a5 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'mknod0(JIJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_open0: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'open0(JII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_openat0: this _: a1 _: a2 _: a3 _: a4 _: a5 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'openat0(IJII)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_opendir0: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'opendir0(J)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_pathconf0: this _: a1 _: a2 _: a3 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'pathconf0(JI)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_read: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'read(IJI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_readdir: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'readdir(J)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_readlink0: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'readlink0(J)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_realpath0: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'realpath0(J)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_rename0: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'rename0(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_renameat0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'renameat0(IJIJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_rmdir0: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'rmdir0(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_stat0: this _: a1 _: a2 _: a3 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'stat0(JLsun/nio/fs/UnixFileAttributes;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_statvfs0: this _: a1 _: a2 _: a3 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'statvfs0(JLsun/nio/fs/UnixFileStoreAttributes;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_strerror: this _: a1 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'strerror(I)[B'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_symlink0: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'symlink0(JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_unlink0: this _: a1 _: a2 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'unlink0(J)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_unlinkat0: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'unlinkat0(IJI)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_utimes0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'utimes0(JJJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_nio_fs_UnixNativeDispatcher_write: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/nio/fs/UnixNativeDispatcher' name: 'write(IJI)I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'native - sun.security.pkcs11'!

_sun_security_pkcs11_Secmod_nssGetModuleList: this _: a1 _: a2 _: a3 

    <javanative: 'sun/security/pkcs11/Secmod' name: 'nssGetModuleList(JLjava/lang/String;)Ljava/lang/Object;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_security_pkcs11_Secmod_nssInitialize: this _: a1 _: a2 _: a3 _: a4 _: a5 

    <javanative: 'sun/security/pkcs11/Secmod' name: 'nssInitialize(Ljava/lang/String;JLjava/lang/String;Z)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_OpenJDK7 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaNativeMethodImpl_OpenJDK7.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

