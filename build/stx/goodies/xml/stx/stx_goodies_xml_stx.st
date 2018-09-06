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
"{ Package: 'stx:goodies/xml/stx' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_xml_stx
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_xml_stx class methodsFor:'documentation'!

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

    Contains dialect specific changes for the VW-XML Parser to work under ST/X.
    Loading this will pull in the vw parts as well

    [author:]
        cg

    [primary maintainer:]
        cg, sv
"
! !

!stx_goodies_xml_stx class methodsFor:'description'!

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
        #'stx:goodies/xml/vw'    "XML::XMLSignal - superclass of XMLChangedInstanceLayoutException "
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_xml_stx "
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
        #'stx:libbasic2'    "Base64Coder - referenced by XMLStandardDecoder::Base64Converter>>convertText: "
    )
! !

!stx_goodies_xml_stx class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBXMLSTX_BASE
LIB_BASE=$(LIBXMLSTX_BASE)
'
!

localIncludes_unix
    ^ '-I../vw'

    "Created: / 23-08-2006 / 11:06:17 / cg"
!

localIncludes_win32
    ^ '-I..\vw'

    "Created: / 23-08-2006 / 11:06:17 / cg"
! !

!stx_goodies_xml_stx class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'XML::FastSAXDriver'
        XMLChangedInstanceLayoutException
        XMLCoder
        XMLStandardDecoder
        #'stx_goodies_xml_stx'
        XMLStandardCoder
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are pairwise elements, consisting of class-name and selector."

    ^ #(
        Collection asXMLElementNamed:
        Dictionary asXMLDocument
        Dictionary asXMLElementNamed:
        Object asXMLAttributeNamed:
        Object asXMLElementNamed:
    )
! !

!stx_goodies_xml_stx class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X XML Framework (STX)'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright eXept Software AG 2011'

    "Modified: / 01-02-2011 / 11:55:07 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_xml_stx class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/stx_goodies_xml_stx.st,v 1.29 2018-05-03 23:40:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/stx_goodies_xml_stx.st,v 1.29 2018-05-03 23:40:26 cg Exp $'
! !

