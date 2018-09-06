"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

RestrictedEnvironment subclass:#ParseTreeEnvironment
	instanceVariableNames:'matcher'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!


!ParseTreeEnvironment methodsFor:'accessing'!

selectionIntervalFor: aString 
        | parseTree node |
        parseTree := RBParser parseMethod: aString
                                onError: [:error :position | ^nil].
        node := matcher asSearcher executeTree: parseTree initialAnswer: nil.
        node isBoolean ifTrue:[^nil].
        ^node isNil ifTrue: [nil] ifFalse: [node sourceInterval]

    "Modified: / 31-01-2012 / 14:45:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeEnvironment methodsFor:'enumerating'!

selectionIntervalsForSource: aString do: aBlock
    "Evaluate block for each interval in source that matches"

    | tree |
    tree := RBParser parseMethod: aString onError:[:error :pos| ^ self ].
    self selectionIntervalsForSource: aString tree: tree do: aBlock

    "Created: / 02-02-2012 / 21:02:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionIntervalsForSource: aString tree: anRBProgramNode do: aBlock 
    "Evaluate block for each interval in source and its parse tree that matches"

    self selectionIntervalsForSource: aString tree: anRBProgramNode rule:nil in:nil do: aBlock
!

selectionIntervalsForSource: aString tree: anRBProgramNode in: aClass do: aBlock 
    "Evaluate block for each interval in source and its parse tree that matches"

    self selectionIntervalsForSource: aString tree: anRBProgramNode rule:nil in:aClass do: aBlock

    "Created: / 02-12-2014 / 11:17:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionIntervalsForSource: aString tree: anRBProgramNode rule:aRuleOrNil in:aClassOrNil do: aBlock 
    "Evaluate block for each interval in source and its parse tree that matches"

    "JV@2012-02-03: Q: How it can happen that matcher is nil?"    
    matcher notNil ifTrue:[
        matcher selectionIntervalsForSource: aString tree: anRBProgramNode rule:aRuleOrNil in:aClassOrNil do: aBlock
    ]

    "Created: / 02-02-2012 / 21:05:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeEnvironment methodsFor:'initialize-release'!

matcher: aParseTreeSearcher
	matcher := aParseTreeSearcher
! !

!ParseTreeEnvironment methodsFor:'testing'!

isParseTreeEnvironment
    ^ true
! !

!ParseTreeEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

