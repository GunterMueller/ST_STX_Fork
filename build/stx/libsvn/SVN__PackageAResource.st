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

PackageResource subclass:#PackageAResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tests-Resources'
!

!PackageAResource class methodsFor:'documentation'!

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

!PackageAResource methodsFor:'accessing'!

package

    ^#'stx:libsvn_mockA'

    "Created: / 08-12-2009 / 22:33:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageAResource methodsFor:'private'!

createMockA

    | mockA |
    mockA := 
        Object subclass:#MockA
            instanceVariableNames:'a'
            classVariableNames:''
            poolDictionaries:''
            category:'mockpkg'.
    mockA compile:'foo ^#foo' classified:#'mock methods'.

    self setPackageOf: mockA to: self package

    "Created: / 08-12-2009 / 22:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createMockB

    | mockB |
    mockB := 
        Object subclass:#MockB
            instanceVariableNames:'b'
            classVariableNames:''
            poolDictionaries:''
            category:'mockpkg'.
    mockB compile:'bar:arg ^arg' classified:#'mock methods'.
    mockB compile:'b ^b' classified:#'mock methods'.
    mockB compile:'b:o b:=o' classified:#'mock methods'.

    self setPackageOf: mockB to: self package

    "Created: / 08-12-2009 / 22:37:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageAResource methodsFor:'utilities'!

createMocks
    self createMockA.
    self createMockB.
!

createPackage

    Class withoutUpdatingChangesDo:
        [self createMocks.
        LibraryDefinition newForPackage:self package]

    "Created: / 08-12-2009 / 22:50:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removePackage
    Class 
        withoutUpdatingChangesDo:[
            (Smalltalk allClassesInPackage:self package) do:[:class | 
                Smalltalk removeClass:class
            ]
        ]

    "Created: / 08-12-2009 / 22:49:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageAResource class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__PackageAResource.st 350 2011-07-07 18:42:56Z vranyj1 §'
! !

