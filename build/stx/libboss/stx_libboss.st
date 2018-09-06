"
 COPYRIGHT (c) 1993 by Claus Gittinger / eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libboss' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libboss
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libboss class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger / eXept Software AG
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

    This library contains binary object storage (BOS) reader and writer.

    BOS allows for arbitrary object graphs to be serialized and deserialized for communication
    with other ST/X systems or to make objects persistent in a file or database.

    The marshalling format is not standardized, so only ST/X programs will be able to read/write
    these objects. However, the format is simple enough, and well documented in the BinaryObjectReader 
    class, so it could be reimplemented easily in another Smalltalk or even non-Smalltalk system.

    Notice that ST/X supports other (more standardized) formats to talk to other systems. 
    For example, JSON, SOAP, XML-RPC, Sun-RPC, BER, etc. 
    These are found in various other packages, usually under the stx:goodies hierarchy.
    (although some might have limitations, such as not being able to store arbitrary objects,
     cyclic references or numeric value ranges) 

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libboss class methodsFor:'description'!

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
        #'stx:libbasic'    "Unicode16String - extended "
        #'stx:libbasic2'    "FourByteString - extended "
        #'stx:libview'    "FontDescription - extended "
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

!stx_libboss class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBBOSS_BASE
LIB_BASE=$(LIBBOSS_BASE)
'
!

stcOptimizationOptions
    ^ '+optinline'

    "Created: / 23-08-2006 / 11:27:43 / cg"
! !

!stx_libboss class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        BinaryIOManager
        BinaryInputManager
        BinaryObjectStorage
        BinaryOutputManager
        ObsoleteObject
        #'stx_libboss'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are pairwise elements, consisting of class-name and selector."

    ^ #(
        Float storeBinaryDefinitionOn:manager:
        Object storeBinaryOn:
        'String class' binaryDefinitionFrom:manager:
        Color storeBinaryDefinitionBodyOn:manager:
        Object readBinaryContentsFrom:manager:
        Font readBinaryContentsFrom:manager:
        Class storeBinaryDefinitionOn:manager:
        Behavior storeBinaryDefinitionOn:manager:
        Image storeBinaryDefinitionOn:manager:
        Class addGlobalsForBinaryStorageTo:
        'MethodDictionary class' binaryFullDefinitionFrom:manager:
        'Float class' binaryDefinitionFrom:manager:
        Object hasSpecialBinaryRepresentation
        ExecutableFunction readBinaryContentsFrom:manager:
        Symbol storeBinaryDefinitionOn:manager:
        'ByteArray class' binaryDefinitionFrom:manager:
        Method readBinaryContentsFrom:manager:
        Class storeBinaryDefinitionOf:on:manager:
        False storeBinaryOn:manager:
        String storeBinaryDefinitionOn:manager:
        'Method class' binaryDefinitionFrom:manager:
        Image readBinaryContentsFrom:manager:
        Character hasSpecialBinaryRepresentation
        Behavior fromBinaryStoreBytes:
        UndefinedObject storeBinaryOn:manager:
        ByteArray storeBinaryDefinitionOn:manager:
        Behavior readBinaryFrom:
        Form readBinaryContentsFrom:manager:
        Object binaryStoreBytes
        MethodDictionary storeFullBinaryDefinitionOn:manager:
        'Smalltalk class' addGlobalsForBinaryStorageTo:
        Color readBinaryContentsFrom:manager:
        Object storeBinaryDefinitionBodyOn:manager:
        Boolean hasSpecialBinaryRepresentation
        Unicode16String storeBinaryElementsOn:
        Object storeBinaryDefinitionOn:manager:
        Object storeBinaryOn:manager:
        Character storeBinaryOn:manager:
        Behavior readBinaryFrom:onError:
        Method storeFullBinaryDefinitionOn:manager:
        True storeBinaryOn:manager:
        Set readBinaryContentsFrom:manager:
        Object representBinaryOn:
        'Smalltalk class' storeBinaryDefinitionOf:on:manager:
        Unicode32String storeBinaryElementsOn:
        Class binaryClassDefinitionFrom:manager:
        Block storeBinaryDefinitionOn:manager:
        'Method class' binaryFullDefinitionFrom:manager:
        Behavior binaryDefinitionFrom:manager:
        ByteArray storeBinaryElementsOn:
        Form storeBinaryDefinitionOn:manager:
        Method storeBinaryDefinitionOn:manager:
        'Symbol class' binaryDefinitionFrom:manager:
        Class storeBinaryClassOn:manager:
        DisplaySurface readBinaryContentsFrom:manager:
        Object readBinaryContentsFromData:manager:
        Character identityHashForBinaryStore
        SmallInteger identityHashForBinaryStore
        Symbol identityHashForBinaryStore
        UndefinedObject identityHashForBinaryStore
        CharacterArray storeBinaryDefinitionOn:manager:
        CharacterArray storeBinaryElementsOn:
        'SharedPool class' addGlobalsForBinaryStorageTo:
        'SharedPool class' storeBinaryDefinitionOf:on:manager:
    )
! !

!stx_libboss class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:31 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Binary Object Storage'
!

legalCopyright
    "Return copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1989\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:17:48 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libboss class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libboss/stx_libboss.st,v 1.55 2016-11-18 11:20:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libboss/stx_libboss.st,v 1.55 2016-11-18 11:20:38 cg Exp $'
! !

