"{ Package: 'stx:goodies/petitparser/analyzer' }"

PPProcessor subclass:#PPRewriter
	instanceVariableNames:'changed'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitAnalyzer-Core'
!


!PPRewriter methodsFor:'accessing'!

replace: aSearchParser with: aReplaceParser
	self replace: aSearchParser with: aReplaceParser when: [ :node | true ]
!

replace: aSearchParser with: aReplaceParser when: aValidationBlock
	self addRule: (PPParserReplaceRule searchFor: aSearchParser replaceWith: aReplaceParser when: aValidationBlock)
!

replace: aSearchParser withValueFrom: aReplaceBlock
	self replace: aSearchParser withValueFrom: aReplaceBlock when: [ :node | true ]
!

replace: aSearchParser withValueFrom: aReplaceBlock when: aValidationBlock
	self addRule: (PPBlockReplaceRule searchFor: aSearchParser replaceWith: aReplaceBlock when: aValidationBlock)
! !

!PPRewriter methodsFor:'initialization'!

initialize
	super initialize.
	changed := false
! !

!PPRewriter methodsFor:'public'!

execute: aParser
	"Perform the replace rules of the receiver on aParser, answer the resulting parser."

	| previous result |
	previous := context.
	changed := false.
	context := Dictionary new.
	result := aParser transform: [ :each |
		| transformed |
		transformed := self performRulesOn: each.
		transformed isNil
			ifTrue: [ each ]
			ifFalse: [ changed := true. transformed ] ].
	context := previous.
	^ result
! !

!PPRewriter methodsFor:'testing'!

hasChanged
	"Answer if the last operation has changed anything."
	
	^ changed
! !

!PPRewriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPRewriter.st,v 1.2 2014-03-04 20:27:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPRewriter.st,v 1.2 2014-03-04 20:27:50 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

