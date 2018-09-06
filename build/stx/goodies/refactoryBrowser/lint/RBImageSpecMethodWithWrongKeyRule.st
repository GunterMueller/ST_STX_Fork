"
 Copyright (C) 2015 Claus Gittinger 

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

RBParseTreeLintRule subclass:#RBImageSpecMethodWithWrongKeyRule
	instanceVariableNames:'currentMethod'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBImageSpecMethodWithWrongKeyRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2015 Claus Gittinger 

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

!RBImageSpecMethodWithWrongKeyRule methodsFor:'accessing'!

group
        ^ 'Bugs'
!

name
        ^ 'Image returning method with wrong key for image cache'
!

rationale
        ^ 'Checks for image resource methods that use a wrong key for the image cache.
The key MUST always be a string of the form "&lt;className&gt; selector" 
(where &lt;className&gt; should be "name class" if the resource method is on the class side).
<P>
This bug is only introduced, if you manually edit image resource methods;
i.e. when such a method is copy-pasted to another class or as different selector.
Then, the key must be changed in the source code to match the method''s name. 
Otherwise, two different images could be cached under
the same name-key and the UI will show the wrong image.
<P>
To fix, double click on the method to open an image editor, then save the image back.
The image editor will always generate a correct key in the method.'
! !

!RBImageSpecMethodWithWrongKeyRule methodsFor:'initialization'!

checkParseNode:node answer:answer
    "extracted out of block, so I can change it without going through a full
     RBRuleSet reinitialization sequence..."

    |iconKey cls className nonMetaClassName methodName|

    answer notNil ifTrue:[^ answer].

    "/ node matches: 'Icon constantNamed:`@iconKey ifAbsentPut:`@expr'

    iconKey := node arguments first.
    iconKey isLiteralString ifTrue:[
        cls := currentMethod mclass.
        nonMetaClassName := cls theNonMetaclass name.
        className := nonMetaClassName,' class'.
        methodName := currentMethod selector.
        ((iconKey value = (className , ' ' , methodName))
        or:[ false "(iconKey value = (nonMetaClassName , ' ' , methodName))" ])
            ifFalse:[ 
                ^ node 
            ]
    ].
    ^ answer
!

initialize
        super initialize.
        self matcher 
                matches: 'Icon constantNamed:`@iconKey ifAbsentPut:`@expr'
                do: [ :node :answer | self checkParseNode:node answer:answer ]
! !

!RBImageSpecMethodWithWrongKeyRule methodsFor:'matching'!

checkMethod: aContext
    "/ only interested in image resource methods
    ((currentMethod := aContext compiledMethod) hasResource:#image) ifTrue:[
        super checkMethod: aContext
    ].
! !

!RBImageSpecMethodWithWrongKeyRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

