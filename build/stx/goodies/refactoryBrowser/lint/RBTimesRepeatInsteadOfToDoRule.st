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

RBParseTreeLintRule subclass:#RBTimesRepeatInsteadOfToDoRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBTimesRepeatInsteadOfToDoRule class methodsFor:'documentation'!

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
!

documentation
"
    checks for manual index handling in a timesRepeat loop
    i.e.
        idx := start.
        count timesRepeat:[
            someCodeUsing idx.
            idx := idx + 1
        ]
    can be rewritted as:
        start to:(start + count - 1) do:[:idx |
            someCodeUsingIdx
        ]

"
! !

!RBTimesRepeatInsteadOfToDoRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Uses "timesRepeat:" instead of "to:do:"'
!

rationale
    ^ 'Checks for the code fragment: 
<code><pre>    idx := start.
    count timesRepeat: [
        ...code using idx...
        idx := idx + 1.
    ]</pre></code>. 
<p>this can be simplified to 
<code><pre>    start to:(start+count-1) do:[:idx |
        ...code using idx...
    ]</pre></code>. 
<p>Not only is the "to:do:" variant shorter (and possibly faster), 
it also better signifies what the code is doing.'
! !

!RBTimesRepeatInsteadOfToDoRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '`idx := `@start. `@count timesRepeat:[ `@.Statements. `idx := `idx + `#n]'
                        '`idx := `@start. `@count timesRepeat:[ `@.Statements. `idx := `idx - `#n]'
                        '`idx := `@start. [`idx < `@stop] whileTrue:[ `@.Statements. `idx := `idx + `#n]'
                        '`idx := `@start. [`idx <= `@stop] whileTrue:[ `@.Statements. `idx := `idx + `#n]'
                        '`idx := `@start. [`idx > `@stop] whileTrue:[ `@.Statements. `idx := `idx - `#n]'
                        '`idx := `@start. [`idx >= `@stop] whileTrue:[ `@.Statements. `idx := `idx - `#n]'
                )
                do: [ :node :answer | node ]
! !

!RBTimesRepeatInsteadOfToDoRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

