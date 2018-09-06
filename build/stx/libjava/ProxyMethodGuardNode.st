"
 Copyright (c) 2010-2011 Jan Vrany, Jan Kurs & Marcel Hlopko,
                         SWING Research Group, Czech Technical University 
                         in Prague

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libjava' }"

ProxyMethodNode subclass:#ProxyMethodGuardNode
	instanceVariableNames:'condition action fallback'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Interop'
!

!ProxyMethodGuardNode class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2010-2011 Jan Vrany, Jan Kurs & Marcel Hlopko,
                         SWING Research Group, Czech Technical University 
                         in Prague

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
! !

!ProxyMethodGuardNode methodsFor:'accessing'!

action
    ^ action
!

action:something
    action := something.
!

condition
    ^ condition
!

condition:something
    condition := something.
!

fallback
    ^ fallback
!

fallback:something
    fallback := something.
! !

!ProxyMethodGuardNode methodsFor:'evaluating'!

evaluateWithReceiver: receiver arguments: arguments

    ^(condition evaluateWithReceiver: receiver arguments: arguments) ifTrue:[
        action evaluateWithReceiver: receiver arguments: arguments
    ] ifFalse:[
        fallback evaluateWithReceiver: receiver arguments: arguments
    ]

    "Created: / 06-12-2011 / 21:25:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodGuardNode methodsFor:'generating'!

generate: compiler
    "Generate a ParseNode that evaluate myself. Used for
     byte-compiling the proxies"

    | first next  |

    first := StatementNode new.
    first expression:
        (MessageNode
            receiver: (condition generate: compiler)
            selector: #ifTrue:
            arg: (BlockNode withExpression: (ReturnNode expression:(action generate: compiler)) in: nil)).
    next := fallback generate: compiler.
    fallback isProxyMethodGuardNode ifFalse:[
        next := ReturnNode expression: next.
    ].
    next isStatementNode ifFalse:[
        next := StatementNode new expression: next.
    ].
    first nextStatement: next.
    ^first.

    "
    ^(condition evaluateWithReceiver: receiver arguments: arguments) ifTrue:[
        action evaluateWithReceiver: receiver arguments: arguments
    ] ifFalse:[
        fallback evaluateWithReceiver: receiver arguments: arguments
    ]

    "

    "Created: / 22-12-2011 / 09:26:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2012 / 19:12:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodGuardNode methodsFor:'testing'!

isProxyMethodGuardNode
    ^ true
! !

!ProxyMethodGuardNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/ProxyMethodGuardNode.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

