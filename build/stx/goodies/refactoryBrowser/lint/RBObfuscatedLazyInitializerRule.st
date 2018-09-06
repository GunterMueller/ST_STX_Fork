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

RBParseTreeLintRule subclass:#RBObfuscatedLazyInitializerRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBObfuscatedLazyInitializerRule class methodsFor:'documentation'!

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

!RBObfuscatedLazyInitializerRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Obfuscated lazy initialization'

    "Modified: / 13-02-2012 / 11:23:33 / cg"
!

rationale
        ^ 'Checks for lazy initialization, written in an unclear way.
Notice that the definition of "unclear" is very subjective. 
Some proclaim exactly this style as being "elegant",
whereas others believe it takes extra reading to understand it. 
The general distinction is between functional style:
<CODE><PRE>
    ^ foo isNil ifTrue:[ foo := initExpr ] ifFalse:[ foo ]
</PRE></CODE>
and guarding clause style:
<CODE><PRE>
    foo isNil ifTrue:[ foo := initExpr ].
    ^ foo
</PRE></CODE>
The author of this rule will argue, that the side effect in the functional style is too easily overlooked. 
In that in fact, the code is completely non-functional.
And, that it is better to guide the reader to this side effect, 
by giving it an exposed look in the code,
instead of giving the false impression of being functional.
'

    "Modified: / 01-03-2012 / 11:22:57 / cg"
! !

!RBObfuscatedLazyInitializerRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyMethodOf: #(
                        '`@methodName
                                ^ `@methodName isNil 
                                    ifTrue: [ `@methodName := `@initExpression ] 
                                    ifFalse: [ `@methodName ]' 
                )
                do: [ :node :answer | node ]

    "Modified: / 13-02-2012 / 11:23:09 / cg"
! !

!RBObfuscatedLazyInitializerRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

