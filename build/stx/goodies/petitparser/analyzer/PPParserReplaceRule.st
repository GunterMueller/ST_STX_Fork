"{ Package: 'stx:goodies/petitparser/analyzer' }"

PPReplaceRule subclass:#PPParserReplaceRule
	instanceVariableNames:'replaceParser'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitAnalyzer-Core'
!


!PPParserReplaceRule class methodsFor:'instance creation'!

searchFor: aSearchParser replaceWith: aReplaceParser when: aVerificationBlock
	^ (self searchFor: aSearchParser) 
		setReplaceParser: aReplaceParser;
		setVerificationBlock: aVerificationBlock;
		yourself
! !

!PPParserReplaceRule methodsFor:'initialization'!

setReplaceParser: aParser
	replaceParser := aParser
! !

!PPParserReplaceRule methodsFor:'matching'!

foundMatchFor: aParser 
	^ replaceParser copyInContext: owner context
! !

!PPParserReplaceRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPParserReplaceRule.st,v 1.3 2014-03-04 20:27:46 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPParserReplaceRule.st,v 1.3 2014-03-04 20:27:46 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

