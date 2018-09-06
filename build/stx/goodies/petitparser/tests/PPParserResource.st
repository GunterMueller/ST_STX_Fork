"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

TestResource subclass:#PPParserResource
	instanceVariableNames:'parsers'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Core'
!


!PPParserResource methodsFor:'accessing'!

parserAt: aParserClass
	"Answer a cached instance of aParserClass."
	
	^ parsers at: aParserClass name ifAbsentPut: [ aParserClass new ]
! !

!PPParserResource methodsFor:'running'!

setUp
	super setUp.
	parsers := Dictionary new
! !

!PPParserResource class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPParserResource.st,v 1.3 2012-05-04 22:09:18 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPParserResource.st,v 1.3 2012-05-04 22:09:18 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: PPParserResource.st 4 2010-12-18 17:02:23Z kursjan §'
! !

