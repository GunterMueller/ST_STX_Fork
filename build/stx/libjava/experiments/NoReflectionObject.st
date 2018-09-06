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

Object subclass:#NoReflectionObject
	instanceVariableNames:''
	classVariableNames:'Instance'
	poolDictionaries:''
	category:'Languages-Java-Experiments-Lookup'
!

!NoReflectionObject class methodsFor:'documentation'!

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
    Null Object for JavaObjectDictionary - RENAME, the name is stupid!!

    [author:]
        kursjan

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!NoReflectionObject class methodsFor:'instance creation'!

instance
    Instance isNil ifTrue:[
        Instance := self basicNew
    ].
    ^ Instance.

    "Created: / 09-01-2011 / 21:33:55 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 04-08-2014 / 15:55:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    ^ self instance.

    "Created: / 09-01-2011 / 21:33:55 / Jan Kurs <kurs.jan@post.cz>"
! !

!NoReflectionObject methodsFor:'queries'!

ifNil: block
    ^ block value.

    "Created: / 17-01-2011 / 19:10:24 / kursjan <kursjan@fit.cvut.cz>"
!

includesBehavior: aClass
    ^ false.

    "Created: / 09-01-2011 / 21:05:56 / Jan Kurs <kurs.jan@post.cz>"
!

isNil
    ^ true

    "Created: / 17-01-2011 / 19:10:11 / kursjan <kursjan@fit.cvut.cz>"
!

methodDictionary
    ^ MethodDictionary withAll: Dictionary new.

    "Created: / 17-01-2011 / 10:52:44 / kursjan <kursjan@fit.cvut.cz>"
!

superclass
    ^ nil

    "Created: / 17-01-2011 / 10:53:15 / kursjan <kursjan@fit.cvut.cz>"
! !

!NoReflectionObject class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/experiments/NoReflectionObject.st,v 1.6 2015-03-20 13:29:44 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

