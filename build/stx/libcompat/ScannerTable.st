"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Array variableSubclass:#ScannerTable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler ST-80-compatibility'
!


!ScannerTable methodsFor:'setup'!

atAll:coll put:something
    coll do:[:char |
        self at:(char codePoint) put:something.
    ].
!

atAllDigitsPut:something
    self atAll:'0123456789' put:something.
!

atAllLettersPut:something
    self atAll:'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' put:something
!

atAllSeparatorsPut:something
    self at:(Character space codePoint) put:something.
    self at:(Character tab codePoint) put:something.
    self at:(Character return codePoint) put:something.
    self at:(Character nl codePoint) put:something.
! !

!ScannerTable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/ScannerTable.st,v 1.2 2016-05-30 16:55:18 cg Exp $'
! !

