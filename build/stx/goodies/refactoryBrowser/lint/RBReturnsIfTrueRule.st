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

RBParseTreeLintRule subclass:#RBReturnsIfTrueRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBReturnsIfTrueRule class methodsFor:'documentation'!

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

!RBReturnsIfTrueRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
        ^ 'Returns value of "ifTrue:/ifFalse:" without "ifFalse:/ifTrue:" block'

    "Modified: / 01-03-2012 / 12:21:25 / cg"
!

rationale
        ^ 'Check for methods that return the value of an "<code>ifTrue:</code>" 
or "<code>ifFalse:</code>" message. 
These statements return nil when the conditional block is not executed,
which may not be the author''s intention.
<P>
Please check the code.
To make your intention explicit, add an alternative to the if-expression.'

    "Modified: / 19-11-2016 / 12:20:03 / cg"
! !

!RBReturnsIfTrueRule methodsFor:'initialization'!

initialize
	super initialize.
	self matcher 
		matchesAnyOf: #(
			'^`@condition ifTrue: [| `@temps | `@.statements]'
			'^`@condition ifFalse: [| `@temps | `@.statements]' )
		do: [ :node :answer | node ]
! !

!RBReturnsIfTrueRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

