"{ Encoding: utf8 }"

"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MinimalShellInterface
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-VisualWorks'
!


!MinimalShellInterface class methodsFor:'opening'!

openFile: aFilenameString
    OperatingSystem openApplicationForDocument:(aFilenameString asFilename pathName) operation:#open

    "
     self openFile:'../../doc/onlineDoc.html'
     self openFile:'../../doc/books/PetitParser.pdf'
    "
! !

!MinimalShellInterface class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/MinimalShellInterface.st,v 1.1 2015-03-27 13:24:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/MinimalShellInterface.st,v 1.1 2015-03-27 13:24:15 cg Exp $'
! !

