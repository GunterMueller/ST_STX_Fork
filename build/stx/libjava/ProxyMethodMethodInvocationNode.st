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

ProxyMethodInvocationNode subclass:#ProxyMethodMethodInvocationNode
	instanceVariableNames:'method'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Interop'
!

!ProxyMethodMethodInvocationNode class methodsFor:'documentation'!

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

!ProxyMethodMethodInvocationNode class methodsFor:'instance creation'!

method: method

    ^self new method: method

    "Created: / 10-12-2011 / 19:48:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodMethodInvocationNode methodsFor:'accessing'!

method
    ^ method
!

method:aMethod
    method := aMethod.
! !

!ProxyMethodMethodInvocationNode methodsFor:'evaluating'!

evaluateWithReceiver: receiver arguments:args

    "
    ^method valueWithReceiver: receiver arguments:args
    "
    ^receiver perform: method selector withArguments: args.

    "Modified: / 23-12-2011 / 12:27:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodMethodInvocationNode methodsFor:'generating'!

generate: compiler
    "Generate a ParseNode that evaluate myself. Used for
     byte-compiling the proxies"

    ^MessageNode
        receiver: SelfNode new
        selector: method selector
        args: compiler args.

    "Created: / 22-12-2011 / 09:26:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodMethodInvocationNode methodsFor:'testing'!

isProxyMethodMethodInvocationNode
    ^ true
! !

!ProxyMethodMethodInvocationNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/ProxyMethodMethodInvocationNode.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

