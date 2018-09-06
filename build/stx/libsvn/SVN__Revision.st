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

Object subclass:#Revision
	instanceVariableNames:''
	classVariableNames:'Head Base'
	poolDictionaries:''
	category:'SVN-Core'
!

!Revision class methodsFor:'documentation'!

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

!Revision class methodsFor:'instance creation'!

base

    Base ifNil:[Base := SVN::RevisionBase new].
    ^Base

    "Created: / 15-03-2008 / 23:27:16 / janfrog"
    "Modified: / 16-03-2008 / 08:56:14 / janfrog"
    "Modified: / 24-03-2009 / 15:18:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 10-02-2012 / 09:54:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

date: aDate

    ^SVN::RevisionDate new date: aDate

    "Created: / 15-03-2008 / 23:27:05 / janfrog"
    "Modified: / 16-03-2008 / 08:56:23 / janfrog"
    "Modified: / 03-02-2011 / 20:41:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

head

    Head ifNil:[Head := SVN::RevisionHead new].
    ^Head

    "Created: / 15-03-2008 / 23:27:16 / janfrog"
    "Modified: / 16-03-2008 / 08:56:14 / janfrog"
    "Modified: / 24-03-2009 / 15:18:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

number: aNumberOrString

    ^SVN::RevisionNumber new number: aNumberOrString asNumber

    "Modified: / 16-03-2008 / 08:56:27 / janfrog"
    "Created: / 18-08-2009 / 13:50:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-02-2011 / 20:41:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFrom: aStringOrStream onError: aBlock

    | revString |
    revString := aStringOrStream isStream
                    ifTrue:[aStringOrStream contents asString]
                    ifFalse:[aStringOrStream asString].

    revString = 'HEAD' ifTrue:[^Revision head].
    revString = '0' ifTrue:[^Revision head]."kludge"
    ((revString first = ${) and:[revString last = $}]) ifTrue:
        [^Revision date: 
            (Date readFrom: (revString copyFrom: 2 to: revString size - 1)
                  onError: aBlock)].
    (revString allSatisfy:[:e|e isDigit]) ifTrue:
        [^Revision number:(Integer readFrom: revString onError: aBlock)].
    "invalid revision string"
    ^aBlock value

    "
        SVN::Revision readFrom:'234' 
        SVN::Revision readFrom:'HEAD'   
        SVN::Revision readFrom:'{2010-01-02}' 
        SVN::Revision readFrom:'{Malformed'
    "

    "Created: / 02-01-2010 / 12:00:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision: aNumberOrString

    <resource: #obsolete>
    self obsoleteMethodWarning: 'Use #number: instead'.
    ^self number: aNumberOrString

    "Created: / 15-03-2008 / 23:26:51 / janfrog"
    "Modified: / 16-03-2008 / 08:56:27 / janfrog"
    "Modified: / 18-08-2009 / 13:51:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Revision class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Revision methodsFor:'accessing'!

number
    ^nil

    "Created: / 14-11-2012 / 20:07:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Revision methodsFor:'instance creation'!

to: rev2

    ^RevisionRange from: self to: rev2

    "Created: / 15-10-2011 / 17:15:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Revision methodsFor:'printing & storing'!

printOn: stream

    self subclassResponsibility

    "Created: / 15-03-2008 / 23:21:59 / janfrog"
! !

!Revision class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__Revision.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
