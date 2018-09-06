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

SharedPool subclass:#JavaVMData
	instanceVariableNames:''
	classVariableNames:'FileIOTrace JavaWindowGroup ThreadTrace JavaMethods
		SystemClassLoader DrawOPTrace JavaEventThread AssertionsEnabled
		SocketConnectConfirmation NoAudio SimulatedLibs OpenFileTable
		ZipCache ZipCacheLastAccessed EventTrace FileOpenConfirmation
		ZipEntryCache ZipEntryCacheLock ZipEntryCacheFirstFree LibPath
		WindowOPTrace FileAccessTrace ClassRegistry WindowCreationTrace
		SimulatedNativeMemory KnownWindows PermittedHostConnects
		FullExceptionTrace SimulatedNativeLibs StartupTime FileOpenTrace
		ImageStretchCache LoadedNativeLibs JavaConsoleStream
		JavaEventQueueThread PermittedDirectories
		StdinReplacementFileQuerySignal JavaScreenUpdaterThread
		ZipInflaters LoadedLibs EnteredMonitorsPerProcess
		_java_net_DatagramPacket_CLASS _java_net_DatagramPacket_buf_ID
		_java_lang_Object_CLASS _java_lang_System_CLASS
		_java_lang_Class_CLASS _java_lang_reflect_Constructor_CLASS
		_java_lang_reflect_Method_CLASS _java_lang_reflect_Field_CLASS
		_java_net_DatagramPacket_offset_ID
		_java_net_DatagramPacket_length_ID
		_java_net_DatagramPacket_bufLength_ID
		_java_net_DatagramPacket_address_ID
		_java_net_DatagramPacket_port_ID _java_net_InetAddress_CLASS
		_java_net_InetAddress_holder_ID
		_java_net_InetAddress_canonicalHostName_ID
		_java_net_InetAddress_family_ID _java_net_InetAddress_address_ID
		_java_net_InetAddress_hostName_ID _java_net_Inet4Address_CLASS
		_java_net_PlainDatagramSocketImpl_CLASS
		_java_net_PlainDatagramSocketImpl_timeout_ID
		_java_lang_Class_classLoader_ID'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaVMData class methodsFor:'documentation'!

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
!

documentation
"
    A shared pool containing some VM data accessed by different
    parts ot the STX:LIBJAVA.
    This pool also contain references to known classes and offsets
    of their fields. The conversion is following:

    * _java_package_ClassName_CLASS (the reference to the class itself)
    * _java_package_ClassName_field_ID (offset of the field named `field`)

    Historical note: all values here used to be in JavaVM.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaVMData class methodsFor:'initialization'!

initialize

    "This is certainly a hack, but handy as there is now way how to
     suppress individual warnings per-class or per-method level.
     In stx:libjava, we assign to pool variables of JavaVMData by purpose..."
    Smalltalk isInitialized ifTrue:[
        ParserFlags allowAssignmentToPoolVariable: true
    ] ifFalse:[
        Smalltalk addStartBlock:[
            ParserFlags allowAssignmentToPoolVariable: true
        ]
    ]

    "Created: / 19-04-2013 / 09:50:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-09-2013 / 00:58:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaVMData class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaVMData.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


JavaVMData initialize!
