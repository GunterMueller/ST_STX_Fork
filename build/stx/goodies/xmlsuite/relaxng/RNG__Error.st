"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Smalltalk::Error subclass:#Error
	instanceVariableNames:'errorLine errorCol'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Exceptions'
!


!Error methodsFor:'accessing'!

errorCol
    ^ errorCol

    "Created: / 14-05-2005 / 10:46:26 / janfrog"
!

errorCol:anInteger
    errorCol := anInteger.

    "Created: / 14-05-2005 / 10:46:26 / janfrog"
!

errorLine
    ^ errorLine

    "Created: / 14-05-2005 / 10:46:26 / janfrog"
!

errorLine:anInteger
    errorLine := anInteger.

    "Created: / 14-05-2005 / 10:46:26 / janfrog"
! !

!Error methodsFor:'printing'!

description

    ^errorLine ifNotNil:[
        errorCol ifNotNil:[
            '[',errorLine printString,':',errorCol printString,'] ',self messageText
        ] ifNil:[
            '[',errorLine printString,'] ',self messageText
        ]
    ] ifNil:[
        self messageText
    ]

    "Created: / 14-05-2005 / 11:27:06 / janfrog"
    "Modified: / 14-05-2005 / 22:00:06 / janfrog"
! !

!Error class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__Error.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
