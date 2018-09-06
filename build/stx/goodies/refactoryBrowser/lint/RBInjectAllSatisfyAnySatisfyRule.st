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

RBParseTreeLintRule subclass:#RBInjectAllSatisfyAnySatisfyRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBInjectAllSatisfyAnySatisfyRule class methodsFor:'documentation'!

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

!RBInjectAllSatisfyAnySatisfyRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Uses "inject:" instead of "anySatisfy:" or "allSatisfy:"'
!

rationale
        ^ 'Checks for uses of the "<code>inject:</code>"-method,
 to check for any or all elements satisfying a condition.
 Better use the 
<A INFO="Click to browse this method"
   ACTION="doit: SystemBrowser default browseImplementorsOf:#allSatisfy:">
"<CODE>allSatisfy:</CODE>"
</A> or
<A INFO="Click to browse this method"
   ACTION="doit: SystemBrowser default browseImplementorsOf:#anySatisfy:">
<CODE>anySatisfy:</CODE>
</A>
methods,
 because may those stop the enumeration as soon as possible, whereas inject always enumerates all elements.
<br> 
Replace "<CODE>bool or: expr</CODE>" by "<CODE>anySatisfy</CODE>" and
"<CODE>bool and: expr</CODE>" by "<CODE>allSatisfy</CODE>".
You can also use the aliases
<A INFO="Click to browse this method"
   ACTION="doit: SystemBrowser default browseImplementorsOf:#conform:">
"<CODE>conform:</CODE>"
</A> for "allSatisfy" and
<A INFO="Click to browse this method"
   ACTION="doit: SystemBrowser default browseImplementorsOf:#contains:">
<CODE>contains:</CODE>
</A> for "anySatisfy".
'
! !

!RBInjectAllSatisfyAnySatisfyRule methodsFor:'checking'!

checkMethod:aContext
    |sel|

    sel := aContext selector.
    "/ do not check their implementations (i.e. in collection hierarchy)
    sel == #allSatisfy: ifTrue:[ ^ self].
    sel == #anySatisfy: ifTrue:[ ^ self].
    super checkMethod:aContext.
! !

!RBInjectAllSatisfyAnySatisfyRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
        matchesAnyOf:#( 
             '`@collection inject:`@e into:[:`accu :`each | 
                                `accu and: `@expr]' 
             '`@collection inject:`@e into:[:`accu :`each | 
                                `accu or: `@expr]' )
        do:[:node :answer | node ]
! !

!RBInjectAllSatisfyAnySatisfyRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

