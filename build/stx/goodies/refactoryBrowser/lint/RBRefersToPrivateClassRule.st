"{ Encoding: utf8 }"

"
 Copyright (C) 2013 Claus Gittinger 

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

RBBlockLintRule subclass:#RBRefersToPrivateClassRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBRefersToPrivateClassRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2013 Claus Gittinger 

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

!RBRefersToPrivateClassRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^ #( 
        portability "/ code is not portable
        stx         "/ code is Smalltalk/X specific
    )

    "Created: / 28-10-2014 / 12:30:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBRefersToPrivateClassRule methodsFor:'accessing'!

group
    ^ 'Bugs - Smalltalk/X'
!

name
        ^ 'Refers to another class''s private class'
!

rationale
        ^ 'Checks for references to another class''s private class.
There is usually a reason for that one being private, and you should not access
it from the outside.
<P>
Notice, that is neither impossible nor completely forbidden to access private classes, 
especially to allow for quick fixes and hacks.
However, it is considered extremely bad practice, as the owner probably made it private by
purpose and may change the internals or even remove the private class in the future.
<P>
If present, use an accessor from the owning class
(but, if there is an accessor, why is the class private?).
It is better to change the owner and make the class public.'
! !

!RBRefersToPrivateClassRule methodsFor:'running'!

checkClass:aContext 
    |cls check|

    cls := aContext selectedClass.
    check := [:cls |
        cls selectorsAndMethodsDo:[:sel :m |
            m usedGlobals do:[:glbl |
                |pClass|

                pClass := Smalltalk classNamed:glbl.
                (pClass notNil and:[pClass isPrivate and:[pClass owningClass ~= cls theNonMetaclass]]) ifTrue:[
                    self addClass:cls selector:sel to:result
                ]
            ].    
        ].
    ].
    check value:cls theNonMetaclass.
    check value:cls theMetaclass.
! !

!RBRefersToPrivateClassRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBRefersToPrivateClassRule.st,v 1.6 2015-03-02 13:02:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBRefersToPrivateClassRule.st,v 1.6 2015-03-02 13:02:12 cg Exp $'
! !

