"
 Copyright (C) 2014 Claus Gittinger
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBBlockLintRule subclass:#RBSentNotImplementedInVSERule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-VSE'
!

!RBSentNotImplementedInVSERule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2014 Claus Gittinger
"
! !

!RBSentNotImplementedInVSERule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( vse )
! !

!RBSentNotImplementedInVSERule methodsFor:'accessing'!

group
        ^ 'VSE Portability Issues'
!

name
        ^ 'Messages known to be not implemented in VSE'
!

rationale
        ^ 'Checks for messages that are sent by a method, but known to be not implemented in VSE Smalltalk.
<P>
This is a special rule useful only in projects which contain code which must be 
portable to VSE Smalltalk.
Currently, there is one eXept customer project, for which this is relevant.
Regular users should leave this rule disabled.'
!

severity
        ^ #warning
! !

!RBSentNotImplementedInVSERule methodsFor:'running'!

checkMethod: aContext 
    | messages messagesKnownToMakeProblems checkedSelectors|

    checkedSelectors := 
        #(
            #'?'
            #'nextPutLine:'
            #'copyTo:'
            #'copyLast:'
            #'copyFrom:'
            #'answer:do:'
            #'ignoreIn:'
            #'loop'
        ).

    messages := aContext messages.
    messagesKnownToMakeProblems := messages select:[:selector | checkedSelectors includes:selector ].

    messagesKnownToMakeProblems notEmptyOrNil ifTrue:[
        messagesKnownToMakeProblems do:[:each |
            result addSearchString: each.
        ].
        result 
            addClass: aContext selectedClass
            selector: aContext selector 
    ]
! !

!RBSentNotImplementedInVSERule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

