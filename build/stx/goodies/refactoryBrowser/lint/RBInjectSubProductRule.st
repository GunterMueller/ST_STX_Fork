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

RBParseTreeLintRule subclass:#RBInjectSubProductRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBInjectSubProductRule class methodsFor:'documentation'!

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

!RBInjectSubProductRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Uses "inject:" instead of "sum" or "product"'
!

rationale
        ^ 'Checks for uses of the "<code>inject:</code>"-method,
 to sum or multiply all elements of a collection.
 Better use the 
<A INFO="Click to browse this method"
   ACTION="doit: SystemBrowser default browseImplementorsOf:#sum">
"<CODE>sum</CODE>"
</A> /
<A INFO="Click to browse this method"
   ACTION="doit: SystemBrowser default browseImplementorsOf:#product">
"<CODE>product</CODE>"
</A> for plain elements,
 or the
<A INFO="Click to browse this method"
   ACTION="doit: SystemBrowser default browseImplementorsOf:#sum:">
"<CODE>sum:</CODE>"
</A> method to add expressions based on the elements.
 For those, optimized versions may be present (or added), depending on the type of collection (especially for Integer- or FloatArrays).'
! !

!RBInjectSubProductRule methodsFor:'checking'!

checkMethod:aContext
    |sel|

    sel := aContext selector.
    "/ do not check their implementations (i.e. in collection hierarchy)
    sel == #sum ifTrue:[ ^ self].
    sel == #product ifTrue:[ ^ self].
    sel == #sum: ifTrue:[ ^ self].
    sel == #product: ifTrue:[ ^ self].
    super checkMethod:aContext.
! !

!RBInjectSubProductRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
        matchesAnyOf:#( 
             '`@collection inject:0 into:[:`accu :`each | 
                                `accu + `@expr]' 
             '`@collection inject:1 into:[:`accu :`each | 
                                `accu * `each]' )
        do:[:node :answer | node ]
! !

!RBInjectSubProductRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

