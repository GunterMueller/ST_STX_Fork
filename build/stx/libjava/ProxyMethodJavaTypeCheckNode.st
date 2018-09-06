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

ProxyMethodTypeCheckNode subclass:#ProxyMethodJavaTypeCheckNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Interop'
!

!ProxyMethodJavaTypeCheckNode class methodsFor:'documentation'!

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

!ProxyMethodJavaTypeCheckNode methodsFor:'evaluating'!

evaluateWithReceiver: receiver arguments: arguments

    ^type isJavaPrimitiveType ifTrue:[
        (arguments at: argument) isKindOf: type
    ] ifFalse:[
        (arguments at: argument) isNil 
            or:[JavaVM canCast: (arguments at: argument) class to: type]
    ]

    "Created: / 06-12-2011 / 21:28:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodJavaTypeCheckNode methodsFor:'generating'!

generate: compiler

    | arg |

    arg := compiler args at: argument.

    ^type isJavaPrimitiveType ifTrue:[
        MessageNode
            receiver: arg
            selector: #isKindOf:
            arg: (ConstantNode value: type)
    ] ifFalse:[
        MessageNode 
            receiver: (MessageNode receiver: arg selector: #isNil)
            selector: #or:
            arg: (BlockNode 
                    withExpression:
                        (MessageNode
                            receiver: (ConstantNode value: JavaVM)
                            selector: #canCast:to:
                            arg1: (MessageNode receiver: arg selector: #class)
                            arg2: (ConstantNode value: type))
                    in: nil)    
    ]
    


    "
    ^type isJavaPrimitiveType ifTrue:[
        (arguments at: argument) isKindOf: type
    ] ifFalse:[
        (arguments at: argument) isNil 
            or:[JavaVM canCast: (arguments at: argument) class to: type]
    ]
    "

    "Created: / 22-12-2011 / 09:26:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodJavaTypeCheckNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/ProxyMethodJavaTypeCheckNode.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

