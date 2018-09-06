"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

LibraryDefinition subclass:#stx_goodies_communication_dolphinHTTP
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_communication_dolphinHTTP class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

preRequisites
    "list all required packages.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies and looking for
     global variable accesses. (the browser has a menu function for that)
     Howevery, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPrerequisites method."

    ^ #(
        #'stx:libbasic'    "GenericException - superclass of SptHTTPServerError "
        #'stx:libbasic2'    "Base64Coder - referenced by SptBasicCredentials class>>makeUserIdFor:password: "
        #'stx:libcompat'    "Dolphin::DeafObject - referenced by SptHTTPResponse>>progress "
        #'stx:libview'    "DeviceGraphicsContext - superclass of SptHTTPAuthorizationDialog "
        #'stx:libview2'    "Icon - referenced by SptProxySettingDialog class>>icon "
        #'stx:libwidg'    "DialogBox - superclass of SptHTTPAuthorizationDialog "
    )
! !

!stx_goodies_communication_dolphinHTTP class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        SWSU
        SZReadWriteSocketStream
        SptCredentials
        SptHTTPAuthorizationDialog
        SptHTTPChallenge
        SptHTTPConfiguration
        SptHTTPConnection
        SptHTTPCookie
        SptHTTPCookieJar
        SptHTTPEntity
        SptHTTPError
        SptHTTPHostCache
        SptHTTPNotAuthorized
        SptHTTPProgressAbstract
        SptHTTPProxySettings
        SptHTTPRequest
        SptHTTPResponse
        SptHTTPSessionState
        SptHTTPStatus
        SptHTTPUrl
        SptHTTPUser
        (SptProxySettingDialog autoload)
        #'stx_goodies_communication_dolphinHTTP'
        SptBasicCredentials
        SptHTTPClientError
        SptHTTPProgress
        SptHTTPProgressDev
        SptHTTPSConnection
        SptHTTPServerError
        SptHTTPTestProgress
        SptHTTPTranscriptProgress
        SptHTTPTriggerProgress
        SptHTTPValueProgress
        SZLoggingSocketStream
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_goodies_communication_dolphinHTTP class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2011\nCopyright eXept Software AG 1998-2011'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_communication_dolphinHTTP class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/stx_goodies_communication_dolphinHTTP.st,v 1.2 2011-10-04 16:46:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/stx_goodies_communication_dolphinHTTP.st,v 1.2 2011-10-04 16:46:20 cg Exp $'
! !
