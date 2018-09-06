"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCDoItParser
	instanceVariableNames:'source'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Chunk Format'
!


!MCDoItParser class methodsFor:'as yet unclassified'!

concreteSubclasses
	^ self allSubclasses reject: [:c | c isAbstract]
!

forDoit: aString	
	| c |
	^ (c := self subclassForDoit: aString) ifNotNil: [c new source: aString]
!

isAbstract
	^ self pattern isNil
!

pattern
	^ nil
!

subclassForDoit: aString
	^ self concreteSubclasses detect: [:ea | ea pattern match: aString] ifNone: []
! !

!MCDoItParser methodsFor:'as yet unclassified'!

addDefinitionsTo: aCollection
	self subclassResponsibility 
!

source
	^ source
!

source: aString
	source := aString
! !

!MCDoItParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDoItParser.st,v 1.4 2012-09-11 21:21:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDoItParser.st,v 1.4 2012-09-11 21:21:47 cg Exp $'
!

version_SVN
    ^ '§Id: MCDoItParser.st 17 2010-10-13 12:07:52Z vranyj1 §'
! !
