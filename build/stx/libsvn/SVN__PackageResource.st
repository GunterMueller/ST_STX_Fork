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

TestResource subclass:#PackageResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tests-Resources'
!

!PackageResource class methodsFor:'documentation'!

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

!PackageResource class methodsFor:'testing'!

isAbstract

    ^self == SVN::PackageResource

    "Created: / 08-12-2009 / 22:43:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageResource methodsFor:'accessing'!

package
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!PackageResource methodsFor:'private'!

setPackageOf: class to: package

    class package: package.
    class methodDictionary 
        do:[:mth|mth package: package]

    "Created: / 08-12-2009 / 22:12:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageResource methodsFor:'utilities'!

createMocks
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

createPackage
    self createMocks.
    LibraryDefinition newForPackage:self package

    "Created: / 08-12-2009 / 22:32:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removePackage
    "Created: / 08-12-2009 / 22:32:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageResource class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__PackageResource.st 352 2011-07-07 19:06:31Z vranyj1 §'
! !

