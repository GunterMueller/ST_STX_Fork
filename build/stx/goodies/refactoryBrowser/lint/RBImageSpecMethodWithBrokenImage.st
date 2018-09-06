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

RBParseTreeLintRule subclass:#RBImageSpecMethodWithBrokenImage
	instanceVariableNames:'currentMethod'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBImageSpecMethodWithBrokenImage class methodsFor:'documentation'!

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
!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( stx excludedByDefault )
! !

!RBImageSpecMethodWithBrokenImage methodsFor:'accessing'!

group
        ^ 'Bugs'
!

name
    ^ 'Image spec method with broken packed bytearray'
!

rationale
        ^ 'Checks for image resource methods which have a packed pixel array with wrong size. 
Such methods seem to have been created in the past by a 
(probably temporarily) broken pack method in ByteArray.
<P>
To fix, double click on the method to open an image editor, then save the image back.'
! !

!RBImageSpecMethodWithBrokenImage methodsFor:'initialization'!

checkNode:node forBrokenImageAnswer:answer
    "extracted out of block, so I can change it without going through a full
     RBRuleSet reinitialization sequence..."

    answer notNil ifTrue:[^ answer].

    HaltInterrupt,Error handle:[:ex |
        ^ node
    ] do:[
        |image|

        image := currentMethod valueWithReceiver:nil arguments:nil.
    ].
    ^ answer
!

initialize
        super initialize.
        self matcher 
                matches: 'Icon constantNamed:`@iconKey ifAbsentPut:`@expr'
                do: [ :node :answer | self checkNode:node forBrokenImageAnswer:answer ]
! !

!RBImageSpecMethodWithBrokenImage methodsFor:'matching'!

checkMethod: aContext
    "/ only interested in image resource methods
    ((currentMethod := aContext compiledMethod) hasResource:#image) ifTrue:[
        super checkMethod: aContext
    ].
! !

!RBImageSpecMethodWithBrokenImage class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

