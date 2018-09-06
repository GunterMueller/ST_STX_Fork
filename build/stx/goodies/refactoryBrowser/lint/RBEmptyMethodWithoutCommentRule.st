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

RBParseTreeLintRule subclass:#RBEmptyMethodWithoutCommentRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBEmptyMethodWithoutCommentRule class methodsFor:'documentation'!

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

!RBEmptyMethodWithoutCommentRule class methodsFor:'accessing'!

tagsBasic
    ^#( #'guidelines' ) "public ST/X and internal eXept code must honor the guidelines"
! !

!RBEmptyMethodWithoutCommentRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Check for empty method'
!

rationale
        ^ 'Checks for a completely empty method, without any comment.
<P>
As it is not clear, if this is unfinished leftover code,
or done by purpose (eg. a fallback noop to be redefined in subclasses),
at least a comment stating this should be present.
If nothing else, write a comment such as "intentionally left blank" or "can be redefined in subclasses".
<P>
As a transformation, when applied, this rule will add such a comment,
but you should check if it is valid.
<P>
Notice: for methods which should be redefined in subclasses, 
an empty method is wrong: it should at least send a #subclassResponsibility message.'
!

severity
        ^ SeverityInformation
! !

!RBEmptyMethodWithoutCommentRule methodsFor:'initialization'!

initialize
    super initialize.
    
"/    self rewriteRule
"/            replaceMethod: '`@method: `@args' 
"/            with: '`@method: `@args
"/    "intentionally left blank ???"
"/';
"/
"/            replaceMethod: '`@method: `@args ^ self' 
"/            with: '`@method: `@args
"/    "intentionally left blank ???"
"/    
"/     ^ self
"/'
! !

!RBEmptyMethodWithoutCommentRule methodsFor:'running'!

checkMethod: aContext
    |mthd lits tree body firstStatement isEmpty|

    "/ skip parsing if possible
    mthd := aContext compiledMethod.
    mthd notNil ifTrue:[
        mthd isCompiledMethod ifFalse:[
            mthd := mthd method
        ]. 
        mthd notNil ifTrue:[
            lits := mthd literals.

            (lits isEmptyOrNil or:[(lits contains:[:el | el notNil]) not]) ifTrue:[
                mthd comment isEmptyOrNil ifTrue:[
                    isEmpty := false.
                    tree := aContext parseTree.
                    (body := tree body) hasStatements ifFalse:[
                        isEmpty := true.
                    ] ifTrue:[
                        (firstStatement := tree body statements first) isReturn ifTrue:[
                            firstStatement value isSelf ifTrue:[
                                isEmpty := true
                            ].    
                        ].        
                    ].        
                    isEmpty ifTrue:[
                        result addClass:(aContext selectedClass) selector:(aContext selector) 
                    ]
                ].
            ].
        ].
    ].
! !

!RBEmptyMethodWithoutCommentRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

