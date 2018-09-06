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

Object subclass:#CacheEntry
	instanceVariableNames:'getter value timestamp'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private'
!

!CacheEntry class methodsFor:'documentation'!

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

!CacheEntry class methodsFor:'instance creation'!

getter: getter

    ^self new getter: getter
!

receiver: receiver selector: selector

    ^self getter:
        (MessageSend receiver: receiver selector: selector)
!

receiver: receiver selector: selector argument: argument

    ^self getter:
        (MessageSend receiver: receiver selector: selector argument: argument)
! !

!CacheEntry class methodsFor:'accessing'!

timeout

    ^900"sec"
! !

!CacheEntry class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!CacheEntry methodsFor:'accessing'!

getter:anObject
    getter := anObject.
!

timeout

    ^self class timeout
!

value

    (value isNil and:[timestamp isNil or:[(Timestamp now - timestamp) > self timeout]])
        ifTrue:[self computeValue].
    ^value

    "Modified: / 23-12-2009 / 07:54:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CacheEntry methodsFor:'private'!

computeValue

    value := getter value.
    timestamp := Timestamp now.
! !

!CacheEntry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__CacheEntry.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
