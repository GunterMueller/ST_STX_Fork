"{ Encoding: utf8 }"

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

RBParseTreeLintRule subclass:#RBUnoptimizedToDoRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBUnoptimizedToDoRule class methodsFor:'documentation'!

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

!RBUnoptimizedToDoRule methodsFor:'accessing'!

group
	^ 'Miscellaneous'
!

name
        ^ 'Uses "(to:)do:" instead of "to:do:"'

    "Modified: / 01-03-2012 / 11:28:51 / cg"
!

rationale
        ^ 'Check for constructs like 
<code><pre>    (b to:e) do:[...]</pre></code>
which can be replaced by:<code><pre>    b to:e do:[...]</pre></code>
<br>The later does not create a temporary intervall object and is also slightly faster
in the execution, because the loop code can often be inlined.'

    "Created: / 01-03-2012 / 11:30:40 / cg"
! !

!RBUnoptimizedToDoRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                    '(`@a to: `@b) do: `@c'
                    '(`@a to: `@b by: `@inc) do: `@c'
                    '(`@a downTo: `@b ) do: `@c'
                    '(`@a downTo: `@b by: `@inc) do: `@c'
                )
                do: [ :node :answer | node ]
! !

!RBUnoptimizedToDoRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBUnoptimizedToDoRule.st,v 1.6 2015-05-23 11:36:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBUnoptimizedToDoRule.st,v 1.6 2015-05-23 11:36:03 cg Exp $'
!

version_SVN
    ^ '$Id: RBUnoptimizedToDoRule.st,v 1.6 2015-05-23 11:36:03 cg Exp $'
! !

