"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

AbstractSAX2Handler subclass:#ErrorHandler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-SAX2'
!


!ErrorHandler methodsFor:'SAX2 interface'!

error:anSAXErrorOrString

    anSAXErrorOrString isString ifTrue:[
        SAXParseError raiseErrorString:anSAXErrorOrString
    ] ifFalse:[
        anSAXErrorOrString raise        
    ]

    "Created: / 17-04-2005 / 10:05:02 / janfrog"
    "Modified: / 25-10-2005 / 13:10:55 / janfrog"
!

fatalError:anSAXErrorOrString

    self error:anSAXErrorOrString

    "Created: / 17-04-2005 / 10:05:42 / janfrog"
    "Modified: / 25-10-2005 / 13:07:56 / janfrog"
!

warning:anSAXErrorOrString

    anSAXErrorOrString raise

    "Created: / 17-04-2005 / 10:06:09 / janfrog"
! !

!ErrorHandler class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__ErrorHandler.st,v 1.1.1.1 2005-11-01 22:05:44 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
