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

JavaNativeMethodImpl_OpenJDK6 subclass:#JavaNativeMethodImpl_SunJDK6
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Java 6'
!

!JavaNativeMethodImpl_SunJDK6 class methodsFor:'documentation'!

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

!JavaNativeMethodImpl_SunJDK6 class methodsFor:'native - com.sun.tools.jdi'!

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

!JavaNativeMethodImpl_SunJDK6 class methodsFor:'native - java.lang'!

_java_lang_ClassLoader_defineClass0: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 

    <javanative: 'java/lang/ClassLoader' name: 'defineClass0(Ljava/lang/String;[BIILjava/security/ProtectionDomain;Z)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ClassLoader_defineClass2: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 

    <javanative: 'java/lang/ClassLoader' name: 'defineClass2(Ljava/lang/String;Ljava/nio/ByteBuffer;IILjava/security/ProtectionDomain;Ljava/lang/String;Z)Ljava/lang/Class;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ProcessImpl_close: this 

    <javanative: 'java/lang/ProcessImpl' name: 'close()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ProcessImpl_create: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 

    <javanative: 'java/lang/ProcessImpl' name: 'create(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/io/FileDescriptor;Ljava/io/FileDescriptor;Ljava/io/FileDescriptor;)J'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ProcessImpl_destroy: this 

    <javanative: 'java/lang/ProcessImpl' name: 'destroy()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ProcessImpl_exitValue: this 

    <javanative: 'java/lang/ProcessImpl' name: 'exitValue()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_java_lang_ProcessImpl_waitFor: this 

    <javanative: 'java/lang/ProcessImpl' name: 'waitFor()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_SunJDK6 class methodsFor:'native - java.util.zip'!

_java_util_zip_ZipFile_open: this _: a1 _: a2 _: a3 _: a4 _: usemmap 

    <javanative: 'java/util/zip/ZipFile' name: 'open(Ljava/lang/String;IJZ)J'>

    "No mmap support for zip files yet, use Open JDK 6 implementation"

    ^self _java_util_zip_ZipFile_open: this _: a1 _: a2 _: a3 _: a4

    "Modified: / 06-02-2013 / 13:24:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMethodImpl_SunJDK6 class methodsFor:'native - sun.jkernel'!

_sun_jkernel_DownloadManager_addToTotalDownloadSize: this _: a1 

    <javanative: 'sun/jkernel/DownloadManager' name: 'addToTotalDownloadSize(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_askUserToRetryDownloadOrQuit: this _: a1 

    <javanative: 'sun/jkernel/DownloadManager' name: 'askUserToRetryDownloadOrQuit(I)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_bundleInstallComplete: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'bundleInstallComplete()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_bundleInstallStart: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'bundleInstallStart()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_displayError: this _: a1 _: a2 

    <javanative: 'sun/jkernel/DownloadManager' name: 'displayError(ILjava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_downloadFromURLImpl: this _: a1 _: a2 _: a3 _: a4 

    <javanative: 'sun/jkernel/DownloadManager' name: 'downloadFromURLImpl(Ljava/lang/String;Ljava/io/File;Ljava/lang/String;Z)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_getCurrentProcessId: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'getCurrentProcessId()I'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_getDebugKey: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'getDebugKey()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_getUrlFromRegistry: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'getUrlFromRegistry()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_getVisitorId0: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'getVisitorId0()Ljava/lang/String;'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_isIEProtectedMode: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'isIEProtectedMode()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_isJBrokerRunning: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'isJBrokerRunning()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_isWindowsVista: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'isWindowsVista()Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_launchJBroker: this _: a1 

    <javanative: 'sun/jkernel/DownloadManager' name: 'launchJBroker(Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_moveDirWithBrokerImpl: this _: a1 _: a2 

    <javanative: 'sun/jkernel/DownloadManager' name: 'moveDirWithBrokerImpl(Ljava/lang/String;Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_moveFileWithBrokerImpl: this _: a1 _: a2 

    <javanative: 'sun/jkernel/DownloadManager' name: 'moveFileWithBrokerImpl(Ljava/lang/String;Ljava/lang/String;)Z'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_postDownloadComplete: this 

    <javanative: 'sun/jkernel/DownloadManager' name: 'postDownloadComplete()V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_postDownloadError: this _: a1 

    <javanative: 'sun/jkernel/DownloadManager' name: 'postDownloadError(I)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
!

_sun_jkernel_DownloadManager_startBackgroundDownloadWithBrokerImpl: this _: a1 

    <javanative: 'sun/jkernel/DownloadManager' name: 'startBackgroundDownloadWithBrokerImpl(Ljava/lang/String;)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_SunJDK6 class methodsFor:'native - sun.misc'!

_sun_misc_Unsafe_copyMemory: this _: a1 _: a2 _: a3 _: a4 _: a5 _: a6 _: a7 _: a8 

    <javanative: 'sun/misc/Unsafe' name: 'copyMemory(Ljava/lang/Object;JLjava/lang/Object;JJ)V'>

    ^ JavaVM unimplementedNativeMethodSignal raise
! !

!JavaNativeMethodImpl_SunJDK6 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaNativeMethodImpl_SunJDK6.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

