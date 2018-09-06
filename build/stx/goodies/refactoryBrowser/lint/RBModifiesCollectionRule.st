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

RBParseTreeLintRule subclass:#RBModifiesCollectionRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBModifiesCollectionRule class methodsFor:'documentation'!

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

!RBModifiesCollectionRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
	^ 'Modifies collection while iterating over it'
!

rationale
        ^ 'Checks for modifications ("<code>remove:</code>" of elements and others)
inside of collection iteration methods such as "<code>do:</code>".
These can cause the "<code>do:</code>" method to break since it may walk off the end of the collection. 
<p>The common fix for this problem is to either copy the collection before iterating over it,
or to remember elements which are to be removed inside the loop and to remove them en-block
using "<code>removeAll:</code>" afterwards.'

    "Modified: / 01-03-2012 / 12:13:36 / cg"
! !

!RBModifiesCollectionRule methodsFor:'initialization'!

initialize
	super initialize.
	self matcher 
		matchesAnyOf: #(
			'`@object do: [:`each | | `@temps | ``@.Statements]' 
			'`@object collect: [:`each | | `@temps | ``@.Statements]' 
			'`@object select: [:`each | | `@temps | ``@.Statements]' 
			'`@object reject: [:`each | | `@temps | ``@.Statements]' 
			'`@object inject: `@value into: [:`sum :`each | | `@temps | ``@.Statements]')
		do: [ :node :answer | 
			answer isNil 
				ifTrue: [
					(self modifiesTree: node receiver in: node arguments last) 
						ifTrue: [ node ]
						ifFalse: [ nil ] ]
				ifFalse: [ answer ] ]
! !

!RBModifiesCollectionRule methodsFor:'private'!

modifiesTree:aCollectionTree in:aParseTree 
    |notifier args|

    notifier := ParseTreeSearcher new.
    args := Array with:(RBPatternVariableNode named:'`@object').
    notifier matchesAnyTreeOf:(#( #add: #addAll: #remove: #removeAll: ) 
                collect:[:each | 
                    RBMessageNode 
                        receiver:aCollectionTree
                        selector:each
                        arguments:args
                ])
        do:[:aNode :answer | true ].
    ^ notifier executeTree:aParseTree initialAnswer:false
! !

!RBModifiesCollectionRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

