"{ Package: 'stx:goodies/refactoryBrowser/lint/spelling' }"

RBSpellingRule subclass:#RBMethodCommentsSpellingRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Spelling'
!


!RBMethodCommentsSpellingRule methodsFor:'accessing'!

name
	^ 'Method comments'
!

rationale
    ^ 'Check spelling errors in method comments'

    "Created: / 04-09-2011 / 20:20:38 / cg"
! !

!RBMethodCommentsSpellingRule methodsFor:'private'!

ignore: aString in: aContext
    Smalltalk isSmalltalkX ifTrue:[
        (aContext selectedClass classVarNames includes: aString) ifTrue:[^ true].
    ] ifFalse:[
        (aContext selectedClass bindingOf: aString) notNil ifTrue:[^ true].
    ].
        (aContext selectedClass instVarNames includes: aString) ifTrue:[^ true].
        (aContext parseTree allDefinedVariables includes: aString) ifTrue:[^ true].
        (aContext literals includes: aString asSymbol) ifTrue:[^ true].
        ^ false
! !

!RBMethodCommentsSpellingRule methodsFor:'running'!

checkMethod: aContext 
        aContext parseTree nodesDo: [ :node | 
                node comments do: [ :interval | 
                        | source |

                        interval isEOLComment ifTrue:[
                            source := aContext sourceCode asString 
                                        copyFrom: interval first + 2
                                        to: interval last.
                        ] ifFalse:[
                            source := aContext sourceCode asString 
                                        copyFrom: interval first + 1
                                        to: interval last - 1.
                        ].
                        (source startsWith:'Created:') ifFalse:[        "/ ignore history comments
                            (source startsWith:'Modified:') ifFalse:[   "/ ignore history comments
                            (self check: source) do: [ :each |
                                    (self ignore: each in: aContext) ifFalse: [
                                            result
                                                    addSearchString: each;
                                                    addClass: aContext selectedClass selector: aContext selector ] ] ] ] ] ]
! !

!RBMethodCommentsSpellingRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBMethodCommentsSpellingRule.st,v 1.5 2014-02-25 08:35:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/spelling/RBMethodCommentsSpellingRule.st,v 1.5 2014-02-25 08:35:39 cg Exp $'
! !

