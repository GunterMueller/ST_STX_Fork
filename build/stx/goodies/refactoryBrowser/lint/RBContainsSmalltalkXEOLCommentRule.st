"
 Copyright (C) 2013 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBBlockLintRule subclass:#RBContainsSmalltalkXEOLCommentRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBContainsSmalltalkXEOLCommentRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2013 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
! !

!RBContainsSmalltalkXEOLCommentRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^ #( 
        portability "/ code is not portable
        stx         "/ code is Smalltalk/X specific
        vse         "/ code does not work in vse
    )

    "Created: / 10-01-2013 / 11:13:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-10-2014 / 12:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBContainsSmalltalkXEOLCommentRule methodsFor:'accessing'!

changes
    | changes |

    changes := OrderedCollection new.
    result classesDo:[ :cls |
        result selectorsForClass: cls do: [ :selector |
            | method source comments |

            source := (method := cls compiledMethodAt: selector) source.
            comments := self eolAndTokenCommentsIn: source.
            comments notEmptyOrNil ifTrue:[ 
                comments reverseDo:[:comment |
                    comment isEOLComment ifTrue:[ 
                        source := 
                            (source copyTo: comment start - 1),
                            '"',
                            (comment characters copyFrom: 3),
                            '"',
                            (source copyFrom: comment last + 1)
                    ].
                ].
                changes add: (AddMethodChange compile: source in: cls classified: method category)
            ].
        ].
    ].
    ^ changes

    "Created: / 17-10-2014 / 00:19:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

group
        ^ 'Portability Issues'
!

name
        ^ 'Contains ST/X EOL- or token-comments'
!

nameOfFix
    ^ 'Change EOL comments to standard Smalltalk comments'
!

rationale
        ^ 'Checks for unportable dialect specific End-of-Line or Token delimited comments. 
These are only supported by ST/X. 
<P>You will have to change them into regular comments,
when porting this code to other Smalltalk dialects.'
!

severity
        ^ SeverityInformation
! !

!RBContainsSmalltalkXEOLCommentRule methodsFor:'private'!

eolAndTokenCommentsIn: source
    ^ OrderedCollection streamContents: [ :s | self eolAndTokenCommentsIn: source do: [ :comment | s nextPut: comment ]  ]

    "Created: / 17-10-2014 / 00:27:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

eolAndTokenCommentsIn: source do: block 
    | scanner |

    scanner := RBScanner on: source readStream.
    [ 
        | comments |

        comments := scanner getComments.
        comments notEmptyOrNil ifTrue:[ 
            comments do:[:each | 
                (each isEOLComment or:[ each isTokenComment ]) ifTrue:[ 
                    block value: each.
                ].
            ].
        ].
        scanner next isEOF
    ] whileFalse.

    "Created: / 16-10-2014 / 14:33:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBContainsSmalltalkXEOLCommentRule methodsFor:'redefinable utilities'!

resultSelectionIntervalsForSource:aString tree:aTree in: aClass do:aBlock
    self eolAndTokenCommentsIn: aString do:[:comment | 
        aBlock value: comment sourceInterval
    ]

    "Created: / 02-12-2014 / 11:14:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBContainsSmalltalkXEOLCommentRule methodsFor:'running'!

checkMethod: aContext
    | source |

    aContext isNil ifTrue:[self halt]. "/ My guess: happens when two rules are executed in parallel  

    source := aContext sourceCode.
    self eolAndTokenCommentsIn: source do:[:each | 
        self 
            addClass: aContext selectedClass 
            selector:  aContext selector 
            to: result.
        ^ self.
    ].

    "Created: / 16-10-2014 / 14:29:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBContainsSmalltalkXEOLCommentRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

