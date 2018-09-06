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

ProxyMethodConditionNode subclass:#ProxyMethodAndNode
	instanceVariableNames:'left right'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Interop'
!

!ProxyMethodAndNode class methodsFor:'documentation'!

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

!ProxyMethodAndNode methodsFor:'accessing'!

left
    ^ left
!

left:something
    left := something.
!

right
    ^ right
!

right:something
    right := something.
! !

!ProxyMethodAndNode methodsFor:'evaluation'!

evaluateWithReceiver: receiver arguments: arguments

    ^(left evaluateWithReceiver: receiver arguments: arguments)
        and: [right evaluateWithReceiver: receiver arguments: arguments].

    "Created: / 06-12-2011 / 21:26:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodAndNode methodsFor:'generating'!

generate: compiler
    "Generate a ParseNode that evaluate myself. Used for
     byte-compiling the proxies"

    ^ MessageNode 
            receiver: (left generate: compiler)
            selector: #and:
            arg: (BlockNode withExpression: (right generate: compiler) in: nil)

    "Created: / 22-12-2011 / 09:26:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodAndNode methodsFor:'testing'!

isProxyMethodAndNode
    ^ true
! !

!ProxyMethodAndNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/ProxyMethodAndNode.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

