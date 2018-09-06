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

RBParseTreeLintRule subclass:#RBEmptyExceptionHandlerRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBEmptyExceptionHandlerRule class methodsFor:'documentation'!

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

!RBEmptyExceptionHandlerRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
        ^ 'Empty exception handler'

    "Modified: / 04-08-2011 / 19:47:11 / cg"
!

rationale
    ^ 'Empty exception handler blocks hide potential bugs. 
The situation should usually either be handled in a more robust way
or at least, the error should be reported on the Transcript, Stderr or (best) using a Logger.
<BR>
If you really really want to ignore errors (for example, in a tooltip string generator), 
rewrite as <code><pre>Error catch:[ ... ]</pre></code> to make your intention explicit.'

    "Modified: / 05-05-2012 / 10:56:10 / cg"
! !

!RBEmptyExceptionHandlerRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
            matchesAnyOf: #(
                '`@block 
                    on: `{ :node |
                            | class |  
                            node isVariable 
                                    and: [ (class := Smalltalk classNamed: node name) notNil
                                    and: [ (class includesBehavior: Exception)
                                    and: [ (class includesBehavior: Notification) not ] ] ] }
                    do: [ :`@err | | `@temps | ]'

                '`{ :node |
                            | class |   
                            node isVariable 
                                    and: [ (class := Smalltalk classNamed: node name) notNil
                                    and: [ (class includesBehavior: Exception)
                                    and: [ (class includesBehavior: Notification) not ] ] ] }
                  handle:[ :`@err | | `@temps | ]
                  do:`@block'
            )
            do: [ :node :answer | node ]

    "Modified: / 04-08-2011 / 20:51:35 / cg"
! !

!RBEmptyExceptionHandlerRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

