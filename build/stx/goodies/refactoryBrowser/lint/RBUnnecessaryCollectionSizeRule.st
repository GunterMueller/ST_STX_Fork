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

RBParseTreeLintRule subclass:#RBUnnecessaryCollectionSizeRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBUnnecessaryCollectionSizeRule class methodsFor:'documentation'!

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

!RBUnnecessaryCollectionSizeRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Unnecessary size computations when copying collection'
!

rationale
        ^ 'Checks for unnecessary collection size computations when copying collections.
<br>Instead of:
<code><pre>    foo copyFrom:n to:(foo size)</pre></code> 
you can use: 
<code><pre>    foo copyFrom:n</pre></code>.
<P>
And instead of:
<code><pre>    foo copyFrom:1 to:(foo size)</pre></code>
use:
<code><pre>    foo copy</pre></code>.
<P>
This rule may not apply to some code inside the collection protocol iself, 
where the implementor wanted to avoid the extra message send for performance reasons'.
! !

!RBUnnecessaryCollectionSizeRule methodsFor:'checking'!

checkMethod: aContext 
    aContext selectedClass name == #SequenceableCollection ifTrue:[
        ^ self
    ].

    super checkMethod:aContext
! !

!RBUnnecessaryCollectionSizeRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
            matchesAnyOf: 
                #(
                    '(`@coll copyFrom:1 to:(`@coll size))'

                    '(`@coll copyFrom:`@n1 to:(`@coll size))'

                    '(`@coll copyFrom:(`@coll size - `@n1) to:(`@coll size))'

                    '(`@coll copyTo:(`@coll size))'

                    '(`@coll from:1 to:(`@coll size))'

                    "/ '(`@coll copyFrom:(`@idx + 1))'
                )
            do: [ :node :answer | node ]
! !

!RBUnnecessaryCollectionSizeRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

