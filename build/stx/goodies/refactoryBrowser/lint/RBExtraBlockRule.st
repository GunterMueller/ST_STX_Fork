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

RBParseTreeLintRule subclass:#RBExtraBlockRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBExtraBlockRule class methodsFor:'documentation'!

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

!RBExtraBlockRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name
	^ 'Block immediately evaluated'
!

rationale
        ^ 'Check for blocks that are immediately evaluated. 
Since the block is immediately evaluated, there is no need for the statements to be in a block.
<P>Notice that the compilers usually inline those blocks for performance reasons.
This does not affect the semantic of the code,
except if one of the called methods reflects on the 
context chain (the list of stack frames), or if there is a "thisContext" inside the block.'
!

severity
        ^ SeverityInformation
! !

!RBExtraBlockRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matches: '`{:node | node isMessage 
                                    and: [node receiver isBlock 
                                    and: [node parent isCascade not 
                                    and: [#( #value 
                                             #value:
                                             #value:value:
                                             #value:value:value:
                                             #value:value:value:value:
                                             #value:value:value:value:value:
                                             #valueWithArguments:
                                             #valueWithArguments
                                           ) includes: node selectorString
                                         ]]]
                           }'
                do: [ :node :answer | node ]
! !

!RBExtraBlockRule methodsFor:'running'!

checkMethod: aContext
    |mthd source|
    
    mthd := aContext compiledMethod.
    
    "a quick rejector, to avoid many parses (because parsing is very slow)"
    source := mthd source.
    source isNil ifTrue:[
        ('RBExtraBlockRule [warning]: no source for ',mthd whoString) infoPrintCR.
        ^ self.
    ].    
    (source includes:$[) ifFalse:[^ self].
    (source includesString:'value') ifFalse:[^ self].

    ^ super checkMethod: aContext
! !

!RBExtraBlockRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

