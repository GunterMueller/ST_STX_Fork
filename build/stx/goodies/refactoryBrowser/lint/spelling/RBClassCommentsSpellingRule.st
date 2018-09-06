"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBClassCommentsSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBClassCommentsSpellingRule methodsFor:'accessing'!

name
	^ 'Class comments'
!

resultClass
        ^ ClassEnvironment "/ RBClassEnvironment
! !

!RBClassCommentsSpellingRule methodsFor:'private'!

ignore: aString in: aContext
    Smalltalk isSmalltalkX ifTrue:[
        (aContext selectedClass classVarNames includes: aString) ifTrue:[^ true].
    ] ifFalse:[
        (aContext selectedClass bindingOf: aString) notNil ifTrue:[^ true].
    ].
        (aContext selectedClass instVarNames includes: aString) ifTrue:[^ true]. 
        (aContext literals includes: aString asSymbol) ifTrue:[^ true]. 
        ^ false
! !

!RBClassCommentsSpellingRule methodsFor:'running'!

checkClass: aContext 
	| comment |
	aContext selectedClass isMeta 
		ifTrue: [ ^ self ].
	comment := aContext selectedClass organization classComment asString.
	(self check: comment) do: [ :each |
		(self ignore: each in: aContext) ifFalse: [
			result
				addSearchString: each;
				addClass: aContext selectedClass;
				addClass: aContext selectedClass class ] ]
! !

!RBClassCommentsSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBClassCommentsSpellingRule.st,v 1.4 2013-08-21 00:09:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBClassCommentsSpellingRule.st,v 1.4 2013-08-21 00:09:06 cg Exp $'
! !

