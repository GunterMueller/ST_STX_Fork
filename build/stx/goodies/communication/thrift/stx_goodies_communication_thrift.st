"{ Package: 'stx:goodies/communication/thrift' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_communication_thrift
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_communication_thrift class methodsFor:'documentation'!

documentation
"
    Package documentation:

    This package contains a framework for communication based on the thrift protocol and
    protocol specification. For concrete uses, see libdb/nosql/cassandra, which is pased on it.
"
! !

!stx_goodies_communication_thrift class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
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
        #'stx:libbasic'    "GenericException - superclass of TTransportError "
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
    )
! !

!stx_goodies_communication_thrift class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        TClient
        TError
        TField
        TMessage
        TProtocol
        TResult
        TSizedObject
        TStruct
        TTransport
        TType
        #'stx_goodies_communication_thrift'
        TBinaryProtocol
        TCallMessage
        TList
        TMap
        TProtocolError
        TTransportError
        TSet
        TTransportClosedError
        TConstants
        (TCompactProtocol autoload)
        (TSimpleTransport autoload)
        TFramedTransport
        (ThriftOutputFixup autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_goodies_communication_thrift class methodsFor:'description - project information'!

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

    ^ 'Copyright Claus Gittinger 1988-2013\nCopyright eXept Software AG 1998-2013'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_communication_thrift class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/stx_goodies_communication_thrift.st,v 1.6 2015-02-09 14:08:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/stx_goodies_communication_thrift.st,v 1.6 2015-02-09 14:08:26 cg Exp $'
! !

