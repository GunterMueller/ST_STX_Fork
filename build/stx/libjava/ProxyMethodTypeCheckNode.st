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

ProxyMethodConditionNode subclass:#ProxyMethodTypeCheckNode
	instanceVariableNames:'argument type'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Interop'
!

!ProxyMethodTypeCheckNode class methodsFor:'documentation'!

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

!ProxyMethodTypeCheckNode class methodsFor:'instance creation'!

type: type argument: argIndex

    ^self new type: type; argument: argIndex

    "Created: / 23-12-2011 / 12:36:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodTypeCheckNode methodsFor:'accessing'!

argument
    ^ argument
!

argument:something
    argument := something.
!

type
    ^ type
!

type:something
    type := something.
! !

!ProxyMethodTypeCheckNode methodsFor:'evaluating'!

evaluateWithReceiver:receiver arguments:arguments

    ^(arguments at: argument) isNil or:[(arguments at: argument) class == type]

    "Modified: / 04-01-2012 / 21:19:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodTypeCheckNode methodsFor:'generating'!

generate:compiler
    "Generate a ParseNode that evaluate myself. Used for
     byte-compiling the proxies"

    | arg |

    arg := compiler args at: argument.

    ^MessageNode 
        receiver: (MessageNode receiver: arg selector: #isNil)
        selector: #or:
        arg: (BlockNode 
                withExpression:
                    (MessageNode
                        receiver: (MessageNode receiver: arg selector: #class)
                        selector: #==
                        arg: (ConstantNode value: type))
                in: nil)

    "Modified: / 04-01-2012 / 21:33:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodTypeCheckNode methodsFor:'testing'!

isProxyMethodTypeCheckNode
    ^ true
! !

!ProxyMethodTypeCheckNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/ProxyMethodTypeCheckNode.st,v 1.5 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

