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

RBBlockLintRule subclass:#RBExcessiveMethodsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBExcessiveMethodsRule class methodsFor:'documentation'!

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

!RBExcessiveMethodsRule methodsFor:'accessing'!

group
	^ 'Miscellaneous'
!

name
	^ 'Excessive number of methods'
!

rationale
        ^ 'Large classes are indications that the class may be trying to do too much.
<br>This smell arises when a class defines a large number of methods. 
A good design assigns one responsibility to a class. 
Large classes are often classes that have too many responsibilities. 
<br>Try to split it apart. 
Ask yourself what is the key responsibility of the class. 
<br>Using the strategy design pattern may be a solution to structure and delegate some behavior. 
An indication that a class may have too many responsibilities is when different groups of methods 
access a subpart of the instance variables. 
<p>Notice: don''t be dognatic with this rule:
<br>in a large system, having some large classes is often inevitable, especially for framework base classes or utility classes. 
It is when there are more than a couple of large classes that you should really reconsider your design. 
<p>
The (considered harmless) number of methods can be edit in RBExcessiveMethodsRule » methodsCount.'
!

resultClass
    "I will return the set of failing classes"

    ^ ClassEnvironment
! !

!RBExcessiveMethodsRule methodsFor:'private'!

methodsCount
	^ 40
! !

!RBExcessiveMethodsRule methodsFor:'running'!

checkClass: aContext
    |n|

    aContext selectedClass methodsCount >= self methodsCount ifTrue: [ 
        "/ cg: check again, ignoring resource spec methods (bitmap images and menus etc. are not counted)
        "/ also ignore documentation methodes - the more we have, the better.
        n := aContext selectedClass instAndClassMethods 
                count:[:mthd |
                    (mthd mclass isMetaclass and:[mthd category ~= 'documentation'])
                    and:[
                        mthd hasResource not
                        or:[ 
                            (#(
                                #canvas
                                #image
                                #programImage
                                #menu
                                #programMenu
                                #canvas
                            ) includes:(mthd resourceType)) not
                        ]
                    ]    
                ].
        n >= self methodsCount ifTrue:[
            result addClass: aContext selectedClass 
        ]
    ]
! !

!RBExcessiveMethodsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

