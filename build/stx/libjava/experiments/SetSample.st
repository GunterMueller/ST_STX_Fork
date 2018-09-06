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

Set subclass:#SetSample
	instanceVariableNames:'name age'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Experiments-Tests'
!

!SetSample class methodsFor:'documentation'!

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

!SetSample methodsFor:'message sending'!

doesNotUnderstand:aMessage
    "This is obviously work around, we have to find out, how to call this, when Java Selector is called"

    | sender |
    sender := thisContext sender.
    ^ self class perform: aMessage onReceiver: self from: sender ifNotFound: [ ^ super doesNotUnderstand: aMessage ].

    "Created: / 06-09-2011 / 22:16:26 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 01-01-2012 / 19:51:27 / kursjan <kursjan@fit.cvut.cz>"
! !

!SetSample class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/experiments/SetSample.st,v 1.5 2015-03-20 13:29:44 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

