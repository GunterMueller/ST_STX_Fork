"{ NameSpace: TDV }"

Object subclass:#TDVObject
	instanceVariableNames:''
	classVariableNames:'OptimizeMessages'
	poolDictionaries:''
	category:'TDV-Extensions'
!


!TDVObject class methodsFor:'initialization'!

initialize
"setup default values"

    OptimizeMessages := false.


! !

!TDVObject methodsFor:'optimize message'!

optimizePoint: aString
"prints optimize messages, if the class variable for printing is true

<return: self>
"

    OptimizeMessages ifTrue:[
	Transcript show: 'optimize point in: '; showCR: self printString;
		   show: Character tab; showCR: aString
	]

    "Modified: / 9.3.1999 / 19:24:37 / ps"
! !

!TDVObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/TDVObject.st,v 1.3 1999-04-23 15:22:58 cg Exp $'
! !
TDVObject initialize!
