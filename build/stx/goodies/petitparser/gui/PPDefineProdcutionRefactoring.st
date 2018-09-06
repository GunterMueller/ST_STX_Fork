"{ Package: 'stx:goodies/petitparser/gui' }"

Refactoring subclass:#PPDefineProdcutionRefactoring
	instanceVariableNames:'class source protocols method'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Refactoring'
!


!PPDefineProdcutionRefactoring class methodsFor:'instance creation'!

onClass: aClass source: aString protocols: anArray
	^ self new
		setClass: aClass;
		setSource: aString;
		setProtocols: anArray;
		yourself
! !

!PPDefineProdcutionRefactoring methodsFor:'accessing'!

selector
	^ method selector
! !

!PPDefineProdcutionRefactoring methodsFor:'initialization'!

setClass: aClass
	class := self classObjectFor: aClass
!

setProtocols: anArray
	protocols := anArray
!

setSource: aString
	source := aString
! !

!PPDefineProdcutionRefactoring methodsFor:'preconditions'!

preconditions
	^ (self checkCompositeParser: class)
		& (RBCondition withBlock: [ self checkSource ] errorString: 'Unable to parse source code')
! !

!PPDefineProdcutionRefactoring methodsFor:'private'!

checkSource
	| rewriter |
	method := RBParser
		parseMethod: source
		onError: [ :string :position | ^ false ].
	rewriter := self sourceRewriter.
	[ rewriter executeTree: method ]
		whileTrue: [ method := rewriter tree ].
	^ method selector isUnary
!

sourceRewriter
        ^ ParseTreeRewriter new
                replace: '`#literal' with: '`#literal asParser' when: [ :node |
                        (node isLiteralNode and: [ node value isString or: [ node value isCharacter ] ])
                                and: [ (node parent isNil or: [ node parent isMessage not or: [ node parent selector ~= #asParser ] ])
                                and: [ (node parents noneSatisfy: [ :each | each isBlock ]) ] ] ];
                replaceMethod: '`@method: `@args | `@temps | ``@.statements. ``.statement `{ :node | node isReturn not }' 
                        with: '`@method: `@args | `@temps | ``@.statements. ^ ``.statement';
                yourself
! !

!PPDefineProdcutionRefactoring methodsFor:'transforming'!

transform
	(class definesInstanceVariable: method selector asString)
		ifFalse: [ class addInstanceVariable: method selector asString ].
	class compile: method newSource classified: protocols
! !

!PPDefineProdcutionRefactoring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPDefineProdcutionRefactoring.st,v 1.1 2014-03-04 21:15:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPDefineProdcutionRefactoring.st,v 1.1 2014-03-04 21:15:26 cg Exp $'
! !

