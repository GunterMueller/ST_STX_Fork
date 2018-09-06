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

Object subclass:#ProxyMethodCompiler
	instanceVariableNames:'tree args selector'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Interop'
!

!ProxyMethodCompiler class methodsFor:'documentation'!

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
!

documentation
"
    A compiler that takes a ProxyMethodNode tree and
    compiles a ProxyMethod

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ProxyMethodCompiler class methodsFor:'compiling'!

compile: tree arguments: numArgs selector: selector
    "For given tree, compile and return a ProxyMethod.
     numArgs is the number of (physical) arguments the method
     accepts"

     ^self new compile: tree arguments: numArgs selector: selector

    "Created: / 23-12-2011 / 13:38:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodCompiler methodsFor:'accessing'!

args
    ^ args
!

argsArray
    "Return a parse tree node representing an array of arguments"

    self args size > 8 ifTrue:[
        self error:'More that 8 arguments not supported (yet)'.
    ].

    self args size == 0 ifTrue:[
        ^ConstantNode value: #().
    ] ifFalse:[
		| sel |
        sel := #(   with:
                    with:with:
                    with:with:with:
                    with:with:with:with:
                    with:with:with:with:with:
                    with:with:with:with:with:with:
                    with:with:with:with:with:with:with:
                    with:with:with:with:with:with:with:with: ) at: self args size.
        ^MessageNode
            receiver: (ConstantNode value: Array)
            selector: sel
            args: self args.
    ]

    "Created: / 03-01-2012 / 21:15:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tree
    ^ tree
! !

!ProxyMethodCompiler methodsFor:'compiling'!

compile: proxyMethodNode arguments: numArgs selector: proxySelector
    "For given tree, compile and return a ProxyMethod.
     numArgs is the number of (physical) arguments the method
     accepts"

    tree := proxyMethodNode.
    args := (1 to: numArgs) collect:[:i|
                (VariableNode methodArgumentNamed: ('arg_' , i printString))
                    index: i.
    ].
    selector := proxySelector.
    ^self compile

    "Created: / 23-12-2011 / 13:38:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodCompiler methodsFor:'compiling-private'!

compile
    "Actually creates and compiles the method"

    | compiler proxy |

    compiler := ByteCodeCompiler new.
    compiler methodClass: ProxyMethod.
    proxy := compiler 
                compileTree: self generate 
                forClass: UndefinedObject
                ifFail:[self error: 'Failed to generate proxy'].

    proxy body: tree.
    ^proxy

    "Created: / 22-12-2011 / 14:07:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generate
    "Generate MethodNode for tree ProxyMethodNode tree"

    | method body stmts |

    method := MethodNode new.
    method arguments: args.
    method selector: selector.
    tree isProxyMethodGuardNode ifFalse:[
        body := ReturnNode expression: (tree generate: self)
    ] ifTrue:[
        body := tree generate: self.
    ].
    body isStatementNode ifTrue:[
        | stmt |

        stmts := OrderedCollection new.
        stmt := body.
        [ stmt notNil ] whileTrue:[
            stmts add: stmt.
            stmt := stmt nextStatement.
        ]
    ] ifFalse:[
        stmts := { body }
    ].
    method statements: stmts.
    ^method

    "Created: / 23-12-2011 / 13:40:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2012 / 19:24:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodCompiler methodsFor:'node creation'!

newGuard

    ^ProxyMethodGuardNode new

    "Created: / 14-12-2011 / 21:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newJavaBlockInvocation: aBlock

    ^ProxyMethodBlockInvocationNode new block: aBlock

    "Created: / 14-12-2011 / 21:32:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newJavaFieldGetter: field

    ^ProxyMethodJavaFieldGetter new field: field.

    "Created: / 17-03-2012 / 17:24:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newJavaFieldSetter: field

    ^ProxyMethodJavaFieldSetter new field: field.

    "Created: / 17-03-2012 / 17:24:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newJavaMethodInvocation: aJavaMethod

    ^ProxyMethodJavaMethodInvocationNode new method: aJavaMethod

    "Created: / 14-12-2011 / 21:26:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newTypeCheck: type argument: argument

    ^ProxyMethodTypeCheckNode new type: type; argument: argument

    "Created: / 14-12-2011 / 21:27:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodCompiler class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/ProxyMethodCompiler.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

