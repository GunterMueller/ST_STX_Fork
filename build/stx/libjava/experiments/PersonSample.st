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
"{ Package: 'stx:libjava/experiments' }"

Object subclass:#PersonSample
	instanceVariableNames:'name age'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Experiments-Tests'
!

!PersonSample class methodsFor:'documentation'!

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


!PersonSample methodsFor:'* uncommented (%1) *'!

doesNotUnderstand:aMessage

    | method  selector class args|
    selector := aMessage selector.
    args := aMessage arguments.
    class := self class.

    JavaLookup isNil ifTrue:[
        (Smalltalk loadPackage: 'stx:libjava/experiments') ifFalse:[
            self error: 'You should load package stx:libjava/experiments if you want some interop - still experimental' mayProceed: true.
            ^nil                        
        ]        
    ].

    method := JavaLookup instance lookupMethodForSelector: selector
                directedTo: class
                for: self
                withArguments: args
                from: thisContext sender sender
                ilc: nil.

    method isNil ifTrue:[
        ^super doesNotUnderstand:aMessage
    ] ifFalse:[
        ^ method valueWithReceiver: self arguments: args
    ].

    "Created: / 06-09-2011 / 22:16:26 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 15-12-2011 / 23:42:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PersonSample methodsFor:'Java protocol'!

getAge

    <javaselector: #'getAge()Ljava/lang/Integer;'>

    ^ self age

    "Created: / 06-09-2011 / 22:22:24 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified (format): / 16-12-2011 / 19:42:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getName
    ^ self name

    "Created: / 06-09-2011 / 22:22:16 / Jan Kurs <kursjan@fit.cvut.cz>"
! !

!PersonSample methodsFor:'accessing'!

age
    ^ age
!

age:something
    age := something.
!

name
    ^ name
!

name:something
    name := something.
! !

!PersonSample class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/experiments/PersonSample.st,v 1.5 2015-03-20 13:29:44 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

