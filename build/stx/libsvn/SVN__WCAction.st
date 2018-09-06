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

Object subclass:#WCAction
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Working copy'
!

!WCAction class methodsFor:'documentation'!

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

!WCAction class methodsFor:'accessing'!

actionName

    ^self subclassResponsibility

    "Created: / 16-03-2008 / 08:48:47 / janfrog"
!

actionNamed: aString

    | cls |
    cls := self allSubclasses 
            detect:[:cls|cls actionName = aString]
            ifNone:[self error:'No such action: ', aString].
    ^cls new

    "Created: / 16-03-2008 / 08:58:24 / janfrog"
! !

!WCAction class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!WCAction methodsFor:'accessing'!

icon

    ^ nil

    "Modified: / 24-06-2009 / 15:07:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCAction methodsFor:'printing & storing'!

printOn: stream

    ^self class actionName printOn: stream

    "Created: / 16-03-2008 / 09:02:09 / janfrog"
! !

!WCAction methodsFor:'processing'!

processEntry: entry using: processor 
    "
        Double dispath to a processor, passing an entry"
    
    self subclassResponsibility

    "Created: / 27-08-2009 / 08:47:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WCAction methodsFor:'testing'!

isConflict

    ^false

    "Created: / 17-08-2009 / 19:46:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isDeleted

    ^false

    "Created: / 17-08-2009 / 19:46:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCAction class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__WCAction.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
