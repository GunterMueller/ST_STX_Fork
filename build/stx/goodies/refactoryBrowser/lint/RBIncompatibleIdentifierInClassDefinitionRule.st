"
 Copyright (C) 2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

RBBlockLintRule subclass:#RBIncompatibleIdentifierInClassDefinitionRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Squeak'
!

!RBIncompatibleIdentifierInClassDefinitionRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

!RBIncompatibleIdentifierInClassDefinitionRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^ #( 
        portability     "/ code is not portable
        squeak pharo    "/ code is squeak/pharo specific
    )

    "Created: / 10-01-2013 / 11:13:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-10-2014 / 12:13:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBIncompatibleIdentifierInClassDefinitionRule methodsFor:'accessing'!

group
        ^ 'Portability Issues'
!

name
        ^ 'Contains class- or instance variable with underline which is not allowed in Squeak/Pharo'
!

rationale
        ^ 'Checks for class- and instance variable names to be compatible with Squeak/Pharo.
<br>Currently, identifiers with an underline-character are illegal in Squeak.
<P>
Notice, that this rule only makes sense, if the code is to be kept compatible with Squeak/Pharo.
<BR>In Smalltalk/X it is legal and quite common, to use underline-characters in variable names.'

    "Modified: / 01-03-2012 / 21:35:06 / cg"
!

resultClass
    "I will return the set of failing classes"

    ^ ClassEnvironment
! !

!RBIncompatibleIdentifierInClassDefinitionRule methodsFor:'running'!

checkClass: aContext
        |cls meta nonMeta|

        cls := aContext selectedClass.
        nonMeta := cls theNonMetaclass.
        meta := nonMeta class.
        ((nonMeta instVarNames contains:[:nm | nm includes:$_])
        or:[ (nonMeta classVarNames contains:[:nm | nm includes:$_]) 
        or:[ (meta instVarNames contains:[:nm | nm includes:$_]) ]]) ifTrue:[
            result addClass: cls 
        ]
! !

!RBIncompatibleIdentifierInClassDefinitionRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

