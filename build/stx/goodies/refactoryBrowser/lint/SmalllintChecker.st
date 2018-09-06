"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SmalllintChecker
	instanceVariableNames:'rule environment context methodBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!


!SmalllintChecker class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
!

newWithContext
	^(self new)
		context: SmalllintContext new;
		yourself
!

runRule: aLintRule
	(self new)
		rule: aLintRule;
		run.
	^aLintRule
!

runRule: aLintRule onEnvironment: aBrowserEnvironment 
        (self new)
                rule: aLintRule;
                environment: aBrowserEnvironment;
                run.
        ^aLintRule
!

runRule: aLintRule onEnvironment: aBrowserEnvironment progressFeedBackInto:aBlockOrNil
        (self new)
                rule: aLintRule;
                environment: aBrowserEnvironment;
                runWithProgressFeedBackInto:aBlockOrNil.
        ^aLintRule
! !

!SmalllintChecker class methodsFor:'others'!

version_CVS
    ^'$Id$'
! !

!SmalllintChecker methodsFor:'accessing'!

context: aSmalllintContext 
	context := aSmalllintContext
!

environment: aBrowserEnvironment 
	environment := aBrowserEnvironment
!

methodBlock: aBlock 
	methodBlock := aBlock
!

rule: aLintRule 
	rule := aLintRule
! !

!SmalllintChecker methodsFor:'actions'!

run
    self runWithProgressFeedBackInto:nil
!

runWithProgressFeedBackInto:feedBackBlockOrNil
    rule resetResult.
    rule recursiveInitialize.

    environment classesDo: [:aClass |
        Error handle:[:ex |
            (Dialog confirm:('Error in smallLint check (%1). Skip check or Debug?' bindWith:rule class name)
                   yesLabel:'Debug' noLabel:'Skip'
            ) ifTrue:[ex reject].
            ex return.    
        ] do:[    
            feedBackBlockOrNil notNil ifTrue:[
                feedBackBlockOrNil value:aClass.
            ].
            self checkClass: aClass.
            self checkMethodsForClass: aClass
        ]
    ]
! !

!SmalllintChecker methodsFor:'initialize-release'!

initialize
	methodBlock := [].
	environment := SelectorEnvironment new.
	context := SmalllintContext newNoCache
!

release
	context release.
	super release
! !

!SmalllintChecker methodsFor:'private'!

checkClass: aClass 
    context selectedClass: aClass.

    "/ skip when doing method checks
    "/ I am not sure if this is right, but some class checks take literally hours,
    "/ even though only a single method is checked.
    environment isSelector ifTrue:[^ self].

    (environment definesClass: aClass) ifTrue: [
        rule checkClass: context
    ]

    "Modified (format): / 19-11-2016 / 19:20:11 / cg"
!

checkMethodsForClass: aClass 
    ^environment 
        selectorsForClass: aClass
        do:[:each | 
            |replacements|
            
            context selector: each.
            replacements := rule checkMethodReturningReplacements: context.
            replacements notEmptyOrNil ifTrue:[
                self breakPoint:#cg.
                rule forgetReplacements.
            ].
            methodBlock value
        ]

    "Modified: / 24-08-2010 / 21:32:39 / Jan Vrany <enter your email here>"
    "Modified (format): / 19-11-2016 / 19:19:37 / cg"
! !

!SmalllintChecker class methodsFor:'documentation'!

version
    ^'$Header$'
!

version_SVN
    ^ '$Id$'
! !

