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

RBBlockLintRule subclass:#RBSentNotImplementedRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBSentNotImplementedRule class methodsFor:'documentation'!

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

!RBSentNotImplementedRule methodsFor:'accessing'!

group
	^ 'Bugs'
!

name
	^ 'Messages sent but not implemented'
!

rationale
        ^ 'Checks for messages that are sent by a method, but no class in the system implements such a message. 
Further checks if messages sent to "<I>self</I>" or "<I>super</I>" exist in the hierarchy, since these can be statically typed. 
Reported methods will certainly cause a <I>doesNotUnderstand:</I>-message when they are executed.
<P>
Sometimes, this is reported for messages to methods which are loaded as package extensions,
or to classes which are not yet loaded. If this is the case, make sure that the code is prepared
for those being absent. Also, check if the receiver class does not redefine the doesNotUnderstand: method,
which may interpret such missing messages arbitrarily.'
!

severity
        ^ SeverityError
! !

!RBSentNotImplementedRule methodsFor:'running'!

checkMethod: aContext 
        | message |

        "/ cg: huh - what is checked here.
        "/      (aContext implements: each) not
        "/ checks if message is implemented inside the context,
        "/ but I think, it should check if it is implemented ANYWHERE.

"/        message := aContext messages 
"/            detect: [ :each | (aContext implements: each) not ]
"/            ifNone: [ 
"/                aContext superMessages 
"/                    detect:[ :each | 
"/                        aContext selectedClass superclass isNil or: [ (aContext selectedClass superclass canUnderstand: each) not ] ]
"/                    ifNone:[ 
"/                        aContext selfMessages 
"/                            detect: [ :each | (aContext selectedClass canUnderstand: each) not ]
"/                            ifNone: [ nil ] 
"/                    ] 
"/            ].

        message := aContext selfMessages 
            detect: [ :each | (aContext selectedClass canUnderstand: each) not ]
            ifNone: [ 
                aContext superMessages 
                    detect:[ :each | 
                        aContext selectedClass superclass isNil or: [ (aContext selectedClass superclass canUnderstand: each) not ] ]
                    ifNone: [ nil ] 
            ].

        message notNil ifTrue:[
            message keywords do:[ :e | result addSearchString: e ].
            result 
                addClass: aContext selectedClass
                selector: aContext selector 
        ]

    "Modified: / 13-09-2015 / 05:32:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBSentNotImplementedRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

