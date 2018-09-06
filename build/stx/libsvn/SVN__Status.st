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

Enum subclass:#Status
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Status'
!

!Status class methodsFor:'documentation'!

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

!Status class methodsFor:'instance creation'!

new

    self error:'Status is a signleton class, use #instance instead'

    "Created: / 18-08-2009 / 12:51:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

withId: aCharacter

    self allSubclasses 
        do:[:cls|cls instance name = aCharacter ifTrue:[^cls instance]].
    ^self error: 'No status with id ', aCharacter.

    "Created: / 18-08-2009 / 12:53:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Status class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Status methodsFor:'accessing'!

icon

    ^self subclassResponsibility

    "Created: / 11-04-2008 / 11:05:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

id
    "Returns a one-char ID of status"

    ^ self subclassResponsibility

    "Modified: / 18-08-2009 / 12:43:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Status methodsFor:'printing'!

printOn: stream 
    self class name printOn: stream

    "Created: / 16-03-2008 / 08:26:35 / janfrog"
! !

!Status methodsFor:'testing'!

isAdded

    ^false

    "Created: / 19-03-2008 / 18:40:01 / janfrog"
!

isExternal

    ^false

    "Created: / 09-04-2010 / 14:18:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMissing

    ^false

    "Created: / 15-03-2008 / 22:29:10 / janfrog"
    "Created: / 07-02-2012 / 22:53:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isModified

    ^false

    "Created: / 15-03-2008 / 22:29:10 / janfrog"
    "Created: / 09-02-2012 / 14:41:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isNormal

    ^false

    "Created: / 11-04-2008 / 11:27:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isUnversioned

    ^false

    "Created: / 15-03-2008 / 22:29:10 / janfrog"
!

isUnversionedOrIgnoredOrMissing

    ^false

    "Created: / 08-02-2012 / 18:38:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Status class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__Status.st 384 2011-10-12 11:01:11Z vranyj1 §'
! !
