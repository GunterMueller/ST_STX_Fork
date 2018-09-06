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

RBParseTreeLintRule subclass:#RBIncompatibleLocalIdentifierRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Squeak'
!

!RBIncompatibleLocalIdentifierRule class methodsFor:'documentation'!

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

!RBIncompatibleLocalIdentifierRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^ #( 
        portability     "/ code is not portable
        squeak pharo    "/ code is squeak/pharo specific
    )

    "Created: / 10-01-2013 / 11:13:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-10-2014 / 12:13:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBIncompatibleLocalIdentifierRule methodsFor:'accessing'!

group
        ^ 'Portability Issues'
!

name
        ^ 'Contains local variable with underline'
!

rationale
        ^ 'Checks for local variable and arguments names to be compatible with Squeak/Pharo.
Currently, identifiers with an underline-character are illegal in Squeak.
<P>
Notice, that this rule only makes sense, if the code is to be kept compatible with Squeak/Pharo.
<BR>In Smalltalk/X it is legal and quite common, to use underline-characters in variable names.'
!

severity
        ^ SeverityWarning
! !

!RBIncompatibleLocalIdentifierRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '`{ :node |

        ((node isMethod or:[ node isBlock ]) 
            and:[ ((node arguments contains:[:arg | arg name includes:$_ ])
                  or:[ node body temporaries contains:[:var | var name includes:$_ ] ]) ]).
}'
                )
                do: [ :node :answer | node ]
! !

!RBIncompatibleLocalIdentifierRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

