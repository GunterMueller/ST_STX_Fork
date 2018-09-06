"{ Encoding: utf8 }"

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
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_communication
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_communication class methodsFor:'documentation'!

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
    Package documentation:

    This library contains utilities for various communication protocols and file formats:
    DNS, FTP client and server, HTTP client, JSON encoding,
    SunRPC, Rest client, SFTP client, SMTP and Telnet client and server.
"
! !

!stx_goodies_communication class methodsFor:'description'!

excludedFromPreRequisites
    ^ #(
	#'stx:goodies/sunit'    "TestCase - superclass of RegressionTests::FTPClientTest "
	#'exept:libcrypt/ssl'    "SSL::SSLProtocolVersion - referenced by HTTPInterface>>connectTo:port:useSSL: "
    )
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
	#'stx:libbasic'    "Query - superclass of HTTPProxyQuery "
	#'stx:libcomp'    "Scanner - superclass of SunRPC::XDRScanner "
	#'stx:libview2'    "ApplicationModel - superclass of URITransmissionServiceAppl::URIDialog "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
	#'stx:libbasic2'    "HostAddressLookupError - referenced by SunRPC::RPCServer>>handleClient: "
	#'stx:libhtml'    "URL - referenced by HTTPInterface>>doRequest "
	#'stx:libtool'    "InspectorView - referenced by SunRPC::XDRType>>inspectorClass "
	#'stx:libview'    "Color - referenced by URITransmissionServiceAppl::TransmissionRow>>rowSelBgColor "
	#'stx:libwidg'    "EnterFieldGroup - referenced by URITransmissionServiceAppl::URIDialog>>inputGroup "
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #(
        'stx:goodies/communication/thrift'
        'stx:goodies/communication/webdriver'
        'stx:goodies/communication/webdriverService'
        'stx:goodies/communication/zeromq'
        'stx:goodies/communication/ssdp'
        'stx:goodies/communication/messagePack'
    )

    "Modified: / 17-08-2006 / 19:57:46 / cg"
    "Modified: / 21-06-2018 / 18:52:31 / Claus Gittinger"
! !

!stx_goodies_communication class methodsFor:'description - compilation'!

additionalDefinitions_bc_dot_mak
    ^ '
# see stdHeader_bc for GOODIES_COMM_BASE
LIB_BASE_LD_ARG=-b:$(GOODIES_COMM_BASE)
'
! !

!stx_goodies_communication class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        AbstractTCPSession
        AbstractTCPSocketServer
        DNSMessage
        DNSQuery
        DNSRecord
        EMailContentDescription
        FTPServerException
        HTTPInterface
        HTTPProxyQuery
        HTTPProxySettings
        HTTPSimpleJSONRestClient
        JSONPrinter
        JSONReader
        NVTClient
        NameResolver
        Nfs4Constants
        RemoteImage
        SftpConstants
        #'SunRPC::RPCDefinitions'
        #'SunRPC::RPCEndPoint'
        #'SunRPC::RPCError'
        #'SunRPC::ReadMe'
        #'SunRPC::SimulatedDirectory'
        #'SunRPC::SimulatedFile'
        #'SunRPC::SimulatedFileSystem'
        #'SunRPC::XDRCoder'
        #'SunRPC::XDRItem'
        #'SunRPC::XDRParser'
        #'SunRPC::XDRScanner'
        #'SunRPC::XDRType'
        TelnetClient
        ThunderbirdComposeInterface
        URITransmission
        URITransmissionService
        URITransmissionServiceAppl
        #'stx_goodies_communication'
        AAAARecord
        ARecord
        AbstractFTPSession
        CNAMERecord
        FTPClient
        FTPServer
        HINFORecord
        MXRecord
        NSRecord
        SMTPClient
        SftpClient
        #'SunRPC::RPCClient'
        #'SunRPC::RPCOperationError'
        #'SunRPC::RPCServer'
        #'SunRPC::XDRProcedure'
        #'SunRPC::XDRProgram'
        #'SunRPC::XDRProgramVersion'
        UnrecognizedRecord
        FTPSession
        SmalltalkFTPSession
        SmalltalkShareClient
        SmalltalkShareServer
        #'SunRPC::DemoClient'
        #'SunRPC::DemoServer'
        #'SunRPC::MountClient'
        #'SunRPC::MountServer'
        #'SunRPC::NFSClient'
        #'SunRPC::NFSServer'
        #'SunRPC::PortMapperClient'
        #'SunRPC::PortMapperServer'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_goodies_communication class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Communication'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright © Claus Gittinger 1988\nCopyright eXept Software AG 2011'

    "Modified: / 18-11-2016 / 12:14:09 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_communication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/stx_goodies_communication.st,v 1.45 2018-06-21 16:53:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/stx_goodies_communication.st,v 1.45 2018-06-21 16:53:04 cg Exp $'
! !

