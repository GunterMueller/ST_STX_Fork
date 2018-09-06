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

RBBlockLintRule subclass:#RBMissingSuperSendsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBMissingSuperSendsRule class methodsFor:'documentation'!

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

!RBMissingSuperSendsRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
	^ 'Missing super sends in selected methods.'
!

rationale
        ^ 'Checks that some methods contain a "<code>super</code>" message send. 
<p>Some methods should always contain a super message send. 
For example, the "<code>postCopy</code>" method should always contain a 
"<code>super postCopy</code>". 
<p>
The list of methods that should contain super message sends is defined in 
<A ACTION="RBMissingSuperSendsRule browse:#superMessages">RBMissingSuperSendsRule>>superMessages</A>.'

    "Modified: / 01-03-2012 / 12:23:11 / cg"
! !

!RBMissingSuperSendsRule methodsFor:'private'!

superMessages
    "implementors of one of those should send super xxx.
     TODO: methods which think they should be called via super
     should be marked as such with an annotation, and the list below
     be constructed dynamically from that."

    ^ #( 
        #release 
        #postCopy 
        #postBuildWith: 
        #preBuildWith: 
        #postOpenWith: 
        #noticeOfWindowClose: 
        #initialize 
        #commonPostOpen
        #closeDownViews
    )

    "Modified (format): / 01-03-2012 / 12:16:48 / cg"
! !

!RBMissingSuperSendsRule methodsFor:'running'!

checkMethod: aContext 
    | class selector definer superMethod isReturnSelf|

    class := aContext selectedClass.
    selector := aContext selector.

    (class isMeta not and: [ self superMessages includes: selector ]) ifTrue:[ 
        definer := class superclass ifNotNilDo: [ :sc | sc whichClassIncludesSelector: selector ].
        definer notNil ifTrue:[ 
            "super defines same method"
            (aContext superMessages includes: selector) ifFalse:[  
                "but I don't call it"
                superMethod := definer compiledMethodAt: selector ifAbsent: [  ].

                "FIXME: Look into Squeak code how #isReturnSelf is implemented"
                Smalltalk isSmalltalkX ifTrue:[
                    |tree statements last|

                    tree := RBParser
                        parseMethod:superMethod source ? ''
                        onError: [:aString :position | nil "ignore any error"].

                    isReturnSelf := tree notNil
                                        and:[(tree := tree body) notNil
                                        and:[(statements := tree statements) isEmpty 
                                             or:[statements size == 1
                                                 and:[(last := statements last) isReturn 
                                                 and:[last value isSelf]]]
                                        ]].
                ] ifFalse:[
                    isReturnSelf := superMethod isReturnSelf.
                ].
                ( isReturnSelf 
                or: [ superMethod sendsAnySelector: #( #subclassResponsibility #subclassResponsibility:)]
                ) ifFalse:[  
                    result addClass: class selector: selector 
                ] 
            ] 
        ] 
    ]

    "Modified: / 05-08-2011 / 13:46:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 06-03-2012 / 15:48:38 / cg"
    "Modified: / 30-01-2017 / 16:10:00 / stefan"
! !

!RBMissingSuperSendsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

