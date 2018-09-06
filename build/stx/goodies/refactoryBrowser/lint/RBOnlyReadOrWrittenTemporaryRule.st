"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

RBParseTreeLintRule subclass:#RBOnlyReadOrWrittenTemporaryRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBOnlyReadOrWrittenTemporaryRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

!RBOnlyReadOrWrittenTemporaryRule class methodsFor:'accessing'!

isVisible
    ^ (self name ~= #RBOnlyReadOrWrittenTemporaryRule) and:[self isBroken not]
!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    "/ cg: I made this obsolete, because I added two new rules which check
    "/ for the two situations checked here, but give individual rationales.
    "/ this looks better in the report and smallLint notifier.
    "/ (i.e. "temp only read" or "temp only written" instead of "temp not read AND written", which is somewhat cryptic to beginners)

    ^#( 
        obsolete
    )
! !

!RBOnlyReadOrWrittenTemporaryRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name
        ^ 'Temporary variables not is not both read AND written'
!

rationale
        ^ 'Checks that all temporary variables are both read and written. 
If a temporary variable is only read, you can replace all of the reads with nil, 
since it couldn''t have been assigned a value. 
If the variable is only written, then we don''t need to store the result since we never use it.'
!

severity
        ^ SeverityInformation
! !

!RBOnlyReadOrWrittenTemporaryRule methodsFor:'checking'!

checkMethod: aContext
    "redefined to also look into primitive code, 
     which might write to a temporary"

    |src|

    src := aContext compiledMethod source.
    "/ if there is primitive C code, don't apply this rule.
    "/ (to avoid false positives, if var is accessed inside the unparsed C code)
    (src includesString:'%{') ifFalse:[ 
        super checkMethod:aContext
    ].
! !

!RBOnlyReadOrWrittenTemporaryRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
        matches:'`{:n|n isTemporary}'
        do:[:temp :answer |
            answer isNil ifTrue:[
                (temp isRead and:[temp isWritten]) not ifTrue:[
                    temp
                ] ifFalse:[
                    nil
                ].
            ] ifFalse:[
                answer
            ].
        ]

    "Modified: / 06-09-2012 / 17:23:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize_old
        super initialize.
        self matcher
                matches: '| `@temps | ``@.stmts'
                do: [ :sequence :answer |
                        answer isNil
                                ifFalse: [ answer ]
                                ifTrue: [
                                        sequence temporaries
                                                detect: [ :temp |
                                                        | isRead isWritten |
                                                        isRead := false.
                                                        isWritten := false.
                                                        sequence statements do: [ :statement | 
                                                                statement nodesDo: [ :node |
                                                                        (node isVariable and: [ node name = temp name ]) ifTrue: [
                                                                                isRead := isRead or: [ node isUsed ].
                                                                                isWritten := isWritten or: [ node isWrite ] ] ] ].
                                                        (isRead and: [ isWritten ]) not 
                                                        ]
                                                ifNone: [ nil ] ] ]

    "Created: / 06-09-2012 / 16:35:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBOnlyReadOrWrittenTemporaryRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

