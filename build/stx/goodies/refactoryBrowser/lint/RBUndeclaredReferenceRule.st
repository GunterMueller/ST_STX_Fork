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

RBBlockLintRule subclass:#RBUndeclaredReferenceRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBUndeclaredReferenceRule class methodsFor:'documentation'!

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

!RBUndeclaredReferenceRule class methodsFor:'queries'!

tagsBasic
    ^ #( notSTX )
! !

!RBUndeclaredReferenceRule methodsFor:'accessing'!

group
	^ 'Bugs'
!

name
	^ 'References an undeclared variable'
!

rationale
        ^ 'Checks for references to a variable in the Undeclared dictionary. 
If you remove a variable from a class that is accessed by a method, 
you will create an undeclared variable reference for those methods that accessed the variable.'

    "Modified: / 09-09-2011 / 05:07:17 / cg"
!

severity
        ^ SeverityError
! !

!RBUndeclaredReferenceRule methodsFor:'running'!

checkMethod: aContext 
    | undeclared globals |        

    Smalltalk isSmalltalkX ifTrue:[
        |any undeclaredPrefix|

        any := false.
        undeclaredPrefix := Smalltalk undeclaredPrefix.
        "/ global refs are implemented different
        aContext compiledMethod literalsDo:[:lit |
            (lit isSymbol and:[lit startsWith:undeclaredPrefix]) ifTrue:[
                |globalName|
                globalName := lit copyFrom:undeclaredPrefix size+1.
                result addSearchString:globalName.
                any := true.
            ].  
        ].
        any ifTrue:[
            result 
                addClass: aContext selectedClass
                selector: aContext selector.
        ].
        ^ self.
    ].

    undeclared := Undeclared ? #() 
            detect: [ :each |
                    (aContext uses: each)
                    and: [ (aContext compiledMethod refersToLiteral: each)
                    and: [ globals isNil ifTrue:[
                            globals := aContext compiledMethod usedGlobals.
                           ].
                           globals includes:each  ]] ]
            ifNone: [ nil ].

    undeclared notNil ifTrue: [ 
            result addSearchString: undeclared.
            result 
                    addClass: aContext selectedClass
                    selector: aContext selector ]

    "Modified: / 05-08-2011 / 13:38:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-09-2011 / 05:12:06 / cg"
! !

!RBUndeclaredReferenceRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

