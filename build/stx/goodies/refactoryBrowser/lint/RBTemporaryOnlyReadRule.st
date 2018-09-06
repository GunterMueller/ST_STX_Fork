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

RBParseTreeLintRule subclass:#RBTemporaryOnlyReadRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBTemporaryOnlyReadRule class methodsFor:'documentation'!

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

!RBTemporaryOnlyReadRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name
        ^ 'Temporary variables not written (always nil)'
!

rationale
        ^ 'Checks that temporary variables are written. 
If a temporary variable is only read, you can replace all of the reads with nil, 
since it couldn''t have been assigned a value.'
!

severity
        ^ SeverityInformation
! !

!RBTemporaryOnlyReadRule methodsFor:'checking'!

checkMethod: aContext
    "redefined to skip check for methods with inline primitive C code. 
     (need better analyzer to check if it might access a temporary"

    |src|

    src := aContext sourceCode.
    "a quick rejector, to avoid many parses (because parsing is very slow)"
    (src includes:$|) ifFalse:[^ self].
    
    "/ if there is primitive C code, don't apply this rule.
    "/ (to avoid false positives, if var is accessed inside the unparsed C code)
    (src includesString:'%{') ifFalse:[ 
        super checkMethod:aContext
    ].
! !

!RBTemporaryOnlyReadRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
        matches:'`{:n|n isTemporary}'
        do:[:temp :answer |
            answer isNil ifTrue:[
                (temp isWritten not and:[temp isRead]) ifTrue:[
                    |maybeWrittenInPrimitive|

                    maybeWrittenInPrimitive := false.
                    temp methodScope isPrimitive ifTrue:[
                        maybeWrittenInPrimitive := temp methodScope source includesString:temp name.
                    ].
                    maybeWrittenInPrimitive 
                        ifTrue:[ nil ]
                        ifFalse:[ temp ]
                ] ifFalse:[
                    nil
                ].
            ] ifFalse:[
                answer
            ].
        ]

    "Modified: / 06-09-2012 / 17:23:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBTemporaryOnlyReadRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

