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

ProxyMethodMethodInvocationNode subclass:#ProxyMethodJavaMethodInvocationNode
	instanceVariableNames:'descriptor'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Interop'
!

!ProxyMethodJavaMethodInvocationNode class methodsFor:'documentation'!

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

!ProxyMethodJavaMethodInvocationNode methodsFor:'accessing'!

descriptor
    ^ descriptor
!

descriptor:aJavaMethodDescriptor
    descriptor := aJavaMethodDescriptor.
!

method:aMethod

    super method: aMethod.
    method isJavaMethod ifTrue:[
        descriptor := method descriptor
    ].

    "Created: / 16-12-2011 / 00:26:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unwrappedArg: arg descriptor: pdescriptor
    | argJClass |

    argJClass := pdescriptor javaClass.
    ^MessageNode 
            receiver: (ConstantNode value: argJClass)
            selector: #javaUnwrap:
            arg: arg .

    "Created: / 12-05-2012 / 21:10:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unwrappedArgs: args
    "Return an array of arguments nodes that will be passed
     to a Smalltalk method. Java values are possibly converted
     into Smalltalk values"
    | unwrappedArgs argIndex |

    self assert: method numArgs = descriptor parameters size.

    unwrappedArgs := OrderedCollection new.
    argIndex := 1.
    descriptor parameters do:[:pdescriptor|
        | arg |

        arg := args at: argIndex. argIndex := argIndex + pdescriptor slots.
        unwrappedArgs add: (self unwrappedArg: arg descriptor: pdescriptor).
    ].
    ^unwrappedArgs

    "Created: / 24-02-2012 / 20:41:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wrappedArg: arg descriptor: adescriptor
    | argJClass |

    argJClass := adescriptor javaClass.
    ^argJClass javaWrapRequired ifTrue:[
        MessageNode 
                receiver: (ConstantNode value: argJClass)
                selector: #javaWrap:
                arg: arg
    ] ifFalse:[
        arg.
    ]

    "Created: / 12-05-2012 / 20:45:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-11-2012 / 23:41:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wrappedArgs: args
    "Return an array of arguments nodes that will be passed
     to a java method. Smalltalk values are possibly converted
     into Java values"

    | wrappedArgs argIndex |

    wrappedArgs := OrderedCollection new.
    argIndex := 1.
    descriptor parameters do:[:pdescriptor|
        | arg |

        arg := args at: argIndex. argIndex := argIndex + 1.
        wrappedArgs add:(self wrappedArg: arg descriptor: pdescriptor).
        pdescriptor slots == 2 ifTrue:[
            wrappedArgs add: (ConstantNode value: nil).
        ].
    ].
    ^wrappedArgs

    "Created: / 28-02-2012 / 10:56:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wrappedArgsArray: args
    | wargs |

    wargs := self wrappedArgs: args.

    wargs size > 8 ifTrue:[
        self error:'More that 8 arguments not supported (yet)'.
    ].

    wargs size == 0 ifTrue:[
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
                    with:with:with:with:with:with:with:with: ) at: wargs size.
        ^MessageNode
            receiver: (ConstantNode value: Array)
            selector: sel
            args: wargs.
    ]

    "Created: / 28-02-2012 / 10:59:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodJavaMethodInvocationNode methodsFor:'evaluation'!

evaluateWithReceiver: receiver arguments:args

    | retval |
    args size == descriptor numPhysicalArgs ifTrue:[
        retval := super evaluateWithReceiver: receiver arguments:args.
    ] ifFalse:[
        self error:'Not yet implemented, should care about doubles and longs'.
        ^nil
    ].

    ^descriptor return javaClass javaUnwrap: retval

    "Created: / 10-12-2011 / 19:46:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generate: compiler

    | invocation |

    compiler args size == descriptor numPhysicalArgs ifFalse:[
        self error:'Not yet implemented, should care about doubles and longs'.
        ^nil
    ].

    method programmingLanguage isJavaLike ifTrue:[    
        | returnType |

        returnType := descriptor return javaClass.

        method isStatic ifFalse:[
            "Instance method..."    
            invocation := MessageNode
                            receiver: SelfNode new
                            selector: method selector
                            args: (self wrappedArgs: compiler args).
        ] ifTrue:[
            "Static method, user invokeWithReceiver:arguments"
            invocation := MessageNode
                            receiver: (ConstantNode value: method)
                            selector: #valueWithReceiver:arguments:selector:
                            args: { ConstantNode value: method javaClass . 
                                    (self wrappedArgsArray: compiler args) .
                                    ConstantNode value: method selector }
        ].

        returnType isJavaWrapperClass ifTrue:[
            invocation := MessageNode
                receiver: (ConstantNode value: returnType)
                selector: #javaUnwrap:
                arg: invocation
        ] ifFalse:[returnType == Boolean ifTrue:[
            "Special hack for booleans, as they are represented as
             int in {0,1}"
             invocation := MessageNode
                receiver: invocation
                selector: #==
                arg: (ConstantNode value: 1).
        ]].

        ^invocation
    ].
    method programmingLanguage isSmalltalk ifTrue:[
        invocation :=
            MessageNode
                receiver: (ConstantNode value: descriptor return javaClass)
                selector: #javaWrap:
                arg: (MessageNode
                        receiver: SelfNode new
                        selector: method selector
                        args: (self unwrappedArgs: compiler args)). 
        ^invocation
    ].
    ^self error:'Unknown programming language'.
    




    "
    | retval |
    args size == descriptor numPhysicalArgs ifTrue:[
        retval := super evaluateWithReceiver: receiver arguments:args.
    ] ifFalse:[
        self error:'Not yet implemented, should care about doubles and longs'.
        ^nil
    ].

    ^descriptor return javaClass javaUnwrap: retval
    "

    "Created: / 22-12-2011 / 09:27:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-12-2011 / 15:20:08 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 09-08-2013 / 01:39:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodJavaMethodInvocationNode methodsFor:'testing'!

isProxyMethodJavaMethodInvocationNode
    ^ true
! !

!ProxyMethodJavaMethodInvocationNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/ProxyMethodJavaMethodInvocationNode.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

