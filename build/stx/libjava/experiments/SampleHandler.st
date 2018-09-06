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

Object subclass:#SampleHandler
	instanceVariableNames:'events'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Experiments-Tests'
!

!SampleHandler class methodsFor:'documentation'!

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

!SampleHandler class methodsFor:'instance creation'!

new
    ^ self basicNew initialize

    "Created: / 29-08-2011 / 22:51:35 / Jan Kurs <kursjan@fit.cvut.cz>"
! !

!SampleHandler methodsFor:'* As yet uncategorized *'!

addArgumentOfType: type
    events add: (Array with: #addArgumentOfType with: type).

    "Created: / 29-08-2011 / 22:56:11 / Jan Kurs <kursjan@fit.cvut.cz>"
! !

!SampleHandler methodsFor:'accessing'!

events
    ^ events
! !

!SampleHandler methodsFor:'handling'!

name:aString
    events add: (Array with: #name with: aString).

    "Created: / 29-08-2011 / 22:46:38 / Jan Kurs <kursjan@fit.cvut.cz>"
!

returnType:aString
    events add: (Array with: #returnType with: aString).

    "Created: / 29-08-2011 / 22:52:04 / Jan Kurs <kursjan@fit.cvut.cz>"
! !

!SampleHandler methodsFor:'initialization'!

initialize
    events := OrderedCollection new.

    "Created: / 29-08-2011 / 22:42:08 / Jan Kurs <kursjan@fit.cvut.cz>"
! !

!SampleHandler class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/experiments/SampleHandler.st,v 1.5 2015-03-20 13:29:44 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

