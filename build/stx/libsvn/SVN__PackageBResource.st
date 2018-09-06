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

PackageResource subclass:#PackageBResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tests-Resources'
!

!PackageBResource class methodsFor:'documentation'!

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

!PackageBResource class methodsFor:'accessing'!

resources

    ^Array with: SVN::PackageAResource

    "Created: / 08-12-2009 / 22:47:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageBResource methodsFor:'accessing'!

package
    "raise an error: must be redefined in concrete subclass(es)"

    ^#'stx:libsvn_mockA'

    "Modified: / 08-12-2009 / 22:46:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageBResource methodsFor:'utilities'!

createMockC

    | mockC |
    mockC := 
        MockA subclass:#MockC
            instanceVariableNames:'c'
            classVariableNames:''
            poolDictionaries:''
            category:'mockpkg'.

    self setPackageOf: mockC to: self package

    "Created: / 08-12-2009 / 22:47:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createMocks
    "raise an error: must be redefined in concrete subclass(es)"

    self createMockC

    "Modified: / 08-12-2009 / 22:48:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createPackage

    PackageAResource current createPackage.
    super createPackage

    "Created: / 08-12-2009 / 22:48:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removePackage
    PackageAResource current removePackage.
    super removePackage

    "Created: / 08-12-2009 / 22:48:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageBResource class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__PackageBResource.st 350 2011-07-07 18:42:56Z vranyj1 §'
! !

