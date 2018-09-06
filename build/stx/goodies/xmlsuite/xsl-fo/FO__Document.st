"{ Package: 'stx:goodies/xmlsuite/xsl-fo' }"

"{ NameSpace: FO }"

XMLv2::Document subclass:#Document
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'FO'
!


!Document class methodsFor:'accessing'!

foNamespace

    ^'http://www.w3.org/1999/XSL/Format'

    "Created: / 07-04-2007 / 09:53:48 / janfrog"
! !

!Document methodsFor:'DOM3 interface'!

createElement: localName

    ^self createElement: localName ns:self class foNamespace

    "Created: / 07-04-2007 / 10:10:34 / janfrog"
    "Modified: / 07-04-2007 / 15:01:46 / janfrog"
!

createElement: localName ns: namespaceURI

    namespaceURI ~= self class foNamespace ifTrue:
        [^super createElement: localName ns: namespaceURI].

    ^(Element allElementClasses 
        detect:[:cls|cls localName = localName]
        ifNone:[^self error:'fo:',localName, ' element not supported']) new
        setOwnerDocument:self;
        localName: localName;
        ns:self class foNamespace

    "Created: / 07-04-2007 / 15:01:28 / janfrog"
! !

!Document methodsFor:'accessing - dimensions'!

height

    ^self documentElement height

    "Created: / 08-04-2007 / 09:31:26 / janfrog"
!

width

    ^self documentElement width

    "Created: / 08-04-2007 / 09:31:31 / janfrog"
! !

!Document class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xsl-fo/FO__Document.st,v 1.1 2007-04-13 15:40:13 vranyj1 Exp $'
! !
