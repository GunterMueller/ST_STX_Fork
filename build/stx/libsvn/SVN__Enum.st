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

Object subclass:#Enum
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private'
!

Enum class instanceVariableNames:'instance'

"
 No other class instance variables are inherited by this class.
"
!

!Enum class methodsFor:'documentation'!

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

!Enum class methodsFor:'instance creation'!

withName: aString

    self allSubclasses do:[:cls|
        cls instance name = aString ifTrue:[^ cls instance]
    ].
    self flushSubclasses.   "/stupid workaround...
    self allSubclasses do:[:cls|
        cls instance name = aString ifTrue:[^ cls instance]
    ].
    
    ^self error: 'No ',(self name copyFrom: 6),' with name ', aString.

    "Created: / 18-08-2009 / 12:52:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 08:58:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-06-2010 / 22:20:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 06-12-2011 / 16:07:26 / cg"
! !

!Enum class methodsFor:'accessing'!

instance

    instance ifNil:[instance := self basicNew].
    ^instance

    "Created: / 18-08-2009 / 12:50:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Enum class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Enum methodsFor:'accessing'!

name

    "Answers a human-readable name of enum value"

    ^self subclassResponsibility

    "Created: / 19-08-2009 / 08:59:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Enum class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '�Id: SVN__Enum.st 363 2011-08-08 13:49:48Z vranyj1 �'
! !
