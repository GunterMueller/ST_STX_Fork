"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Pattern subclass:#ComplexPattern
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

ComplexPattern comment:'This class is the superclass to patterns that are modifications or compilations of other patterns. As seen from the class hiererarchy, instances of complex patterns include ChoicePattern, MixedPattern, ModifiedPattern and SequencePattern.'
!


!ComplexPattern methodsFor:'testing'!

isSimple

	^false
! !

!ComplexPattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/ComplexPattern.st,v 1.6 2003-04-23 08:44:16 cg Exp $'


! !
