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

RBParseTreeLintRule subclass:#RBLiteralArrayByteValuesRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBLiteralArrayByteValuesRule class methodsFor:'documentation'!

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
!

documentation
"
    cg: checks for bytearray valued arrays
"
! !

!RBLiteralArrayByteValuesRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Literal array contains only byte valued integers'

    "Modified: / 04-08-2011 / 21:01:06 / cg"
!

rationale
    ^ 'If a literal array contains only small byte valued integers (0..255), 
it could possibly be replaced by a ByteArray literal (which requires less memory for storage).
<P>
Of course, this is not true, if the array is ever copied and the copy then modified
using "at:put:" and non-byte values are stored then.'

    "Created: / 04-08-2011 / 21:00:24 / cg"
! !

!RBLiteralArrayByteValuesRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matches: '`#literal'
                do: [ :node :answer | 
                        answer isNil 
                                ifTrue: [
                                        (node value isArray and: [ self isArrayOfBytes: node value ]) 
                                                ifTrue: [ node ]
                                                ifFalse: [ nil ] ]
                                ifFalse: [ answer ] ]

    "Modified: / 04-08-2011 / 21:05:44 / cg"
! !

!RBLiteralArrayByteValuesRule methodsFor:'private'!

isArrayOfBytes: anArray 
    anArray isEmpty ifTrue: [^false].
    ^ anArray conform:[:each | each class == SmallInteger and:[each between:0 and:255]].

    "Created: / 04-08-2011 / 21:02:50 / cg"
! !

!RBLiteralArrayByteValuesRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

