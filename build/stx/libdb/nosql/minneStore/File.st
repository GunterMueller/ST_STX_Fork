"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

Object subclass:#File
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-GG-Patch'
!

File comment:'English:
File is only a class for supporting MinnieStone.
VisualWorks uses the Filename class and Streams, and there isn''t something of very much similar to File class concept in VisualSmalltalk.
Italian:
File e'' una mera classe di supporto per il MinnieStone, e spero che non faccia troppo conflitto!!!!
'
!


!File class methodsFor:'services'!

Copyright
	"Copyright(c) 1997,1998  Jonathan A. Carlson"
!

createFileNamed: aString 
	"Spero vada bene... Versione precedente, che funzionava solo con l' esempio, ma non con i test:
	|fd|
	fd:=aString asFilename.
	fd newReadWriteStream close.
	^aString asFilename."

	| fd |
	fd := aString asFilename.
	"Lo apre  e lo chiude (=lo crea)"
	fd newReadWriteStream close.
	"Ora (ri)fornisce il desiderato Stream sperando bene...."
	^fd newReadWriteStream .
!

exists: aString
	^((aString asFilename) exists).
!

remove: aString 
	^aString asFilename delete
!

remove: aString ifAbsent: aBlock
	|f|
	f:=aString asFilename.
	f exists ifFalse: [^aBlock]
	ifTrue: [ ^(f delete).].
! !

!File class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/File.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
