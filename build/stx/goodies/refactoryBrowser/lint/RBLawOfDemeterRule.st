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

RBParseTreeLintRule subclass:#RBLawOfDemeterRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBLawOfDemeterRule class methodsFor:'documentation'!

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

!RBLawOfDemeterRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( 
        broken "/ A lot of false-positive, hard to fix
    )

    "Created: / 06-09-2012 / 14:16:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLawOfDemeterRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
	^ 'Law of demeter'
!

rationale
    ^ 'The Law of Demeter is a design guideline for developing software and can be succinctly summarized as 
"Only talk to your immediate friends". 
The fundamental notion is that a given object should assume as little as possible 
about the structure or properties of anything else. 
If long method chains are used a lot of system knowledge is hardcoded into a single method 
and might make reusability difficult.
<P>
Instead of "<code>foo bar baz</code>", better add a forwarding "<code>baz</code>"-method to foo''s class and
replace by "<code>foo baz</code>". So the knowledge that there is a bar-object in between
is now limited to foo''s class. This avoids a need to change all senders,
whenever the substructure of foo (or any along the chain) changes in the future.'

    "Modified: / 01-03-2012 / 12:46:48 / cg"
! !

!RBLawOfDemeterRule methodsFor:'initialization'!

initialize
        "only look for unary-selector chains"

        super initialize.
        self matcher 
                "/ matches: '(((`@reciver `@msg1: `@arg1) `@msg2: `@arg2) `@msg3: `@arg3)  `@msg4: `@arg4'
                matches: '((`@reciver `@msg1: `@arg1) `@msg2: `@arg2) `@msg3: `@arg3 '
                do: [ :node :answer | 
                    node selector isUnarySelector 
                        ifTrue:[ node ]
                        ifFalse:[ nil ]
                ]

    "Modified: / 08-03-2012 / 03:20:25 / cg"
! !

!RBLawOfDemeterRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

