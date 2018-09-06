"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

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
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

TestCase subclass:#PackagePatternTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tests'
!

!PackagePatternTests class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

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

!PackagePatternTests methodsFor:'tests'!

test_01

    self assert: ((PackagePattern for:'stx:goodies') matches: 'stx:goodies').
    self assert: ((PackagePattern for:'stx:goodies/xml') matches: 'stx:goodies/xml').
    self deny: ((PackagePattern for:'stx:goodies/XML') matches: 'stx:goodies').        
    self deny: ((PackagePattern for:'stx:goodies/XML') matches: 'stx:goodies/xml').

    "Created: / 12-03-2011 / 22:09:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02

    | pp d |
    pp := PackagePattern for:'stx:goodies/*'.
    d := Dictionary new.

    self assert: ( pp matches: 'stx:goodies' ).
    self assert: ( pp match: 'stx:goodies' into: d).
    self assert: ( d at: '1') = ''.

    self assert: ( pp match: 'stx:goodies/xml' into: d).
    self assert: ( d at: '1') = 'xml'.

    self assert: ( pp match: 'stx:goodies/xml/vw' into: d).
    self assert: ( d at: '1') = 'xml/vw'.

    "Created: / 13-03-2011 / 07:40:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03

    | pp d |
    pp := PackagePattern for:'*'.
    d := Dictionary new.

    self assert: ( pp matches: 'stx:goodies' ).
    self assert: ( pp match: 'stx:goodies' into: d).
    self assert: ( d at: '1') = 'stx/goodies'.

    "Created: / 13-03-2011 / 07:51:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04

    | pp d |
    pp := PackagePattern for:'stx:goodies/*/test'.
    d := Dictionary new.


    self assert: ( pp match: 'stx:goodies/xml/test' into: d).
    self assert: ( d at: '1') = 'xml'.

    "Created: / 13-03-2011 / 07:52:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05

    | pp d |
    pp := PackagePattern for:'stx:goodies/*/test/*'.
    d := Dictionary new.

    self assert: ( pp match: 'stx:goodies/xml/test/dom' into: d).
    self assert: ( d at: '1') = 'xml'.
    self assert: ( d at: '2') = 'dom'.

    d := Dictionary new.
    self assert: ( pp match: 'stx:goodies/xml/test' into: d).
    self assert: ( d at: '1') = 'xml'.
    self assert: ( d at: '2') = ''.

    "Created: / 13-03-2011 / 07:56:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackagePatternTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__PackagePatternTests.st 350 2011-07-07 18:42:56Z vranyj1 §'
! !

