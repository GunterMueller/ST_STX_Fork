"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

RBDuplicatedCodeRule subclass:#RBDuplicatedTokenRule
	instanceVariableNames:'index'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Experimental Rules'
!


!RBDuplicatedTokenRule methodsFor:'accessing'!

name
	^ super name , ' (token)'
! !

!RBDuplicatedTokenRule methodsFor:'initialization'!

initialize
	super initialize.
	index := OrderedCollection new
! !

!RBDuplicatedTokenRule methodsFor:'private'!

minimalSize
	^ 10
!

scanTokens: aContext
	| tokens scanner |
	tokens := OrderedCollection new.
	scanner := RBScanner
		on: aContext sourceCode asString readStream
		errorBlock: [ :s :p | ^ tokens ].
	[ scanner atEnd ] 
		whileFalse: [ tokens addLast: scanner next value ].
	^ tokens asArray
! !

!RBDuplicatedTokenRule methodsFor:'running'!

checkMethod: aContext
	| tokens substring |
	tokens := self scanTokens: aContext.
	1 to: tokens size - self minimalSize do: [ :i |
		i + self minimalSize to: tokens size do: [ :j |
			substring := tokens copyFrom: i to: j.
			index do: [ :assoc |
				| method source |
				method := assoc key.
				source := assoc value.
				(source indexOfSubCollection: substring startingAt: 1) = 0 
					ifFalse: [ self addDuplication: aContext compiledMethod with: method in: result ] ] ] ].
	index addLast: aContext compiledMethod -> tokens
! !

!RBDuplicatedTokenRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBDuplicatedTokenRule.st,v 1.1 2014-02-22 16:02:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBDuplicatedTokenRule.st,v 1.1 2014-02-22 16:02:21 cg Exp $'
! !

