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

RBParseTreeLintRule subclass:#RBContainsNamespaceIdentifiersRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBContainsNamespaceIdentifiersRule class methodsFor:'documentation'!

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

!RBContainsNamespaceIdentifiersRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^ #( 
        portability "/ code is not portable
        stx         "/ code is Smalltalk/X specific
        vse         "/ code does not work in vse
    )

    "Created: / 10-01-2013 / 11:13:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 28-10-2014 / 12:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBContainsNamespaceIdentifiersRule methodsFor:'accessing'!

group
        ^ 'Portability Issues'
!

name
        ^ 'Contains references to a namespace'
!

rationale
        ^ 'Checks for unportable
"<code>ns::id</code>" - Namespace identifiers. Such code is not portable to other Smalltalk dialects.
<P>
There is no easy fix, if your code is to be portable.
You will have to make the classes public, and prepend a unique prefix to the class name.
You might take the namespace and replace "::" by one or two underlines
(i.e. rename the class from "NS::ClassName" to "NS__ClassName"). 
But this does not work
with Squeak, which does not allow underlines in names.
<P>
So, a better solution is to write a special exporter,
which translates namespace class names on the fly, while filing out.
Such exporters are easy to write and one is already available and part of the system 
(for VSE export).'

    "Created: / 01-03-2012 / 12:18:31 / cg"
!

severity
    ^ SeverityWarning
! !

!RBContainsNamespaceIdentifiersRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '`{ :node | node isVariable
                                    and:[ node name includesString:''::'' ] }'
                )
                do: [ :node :answer | node ]
! !

!RBContainsNamespaceIdentifiersRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

