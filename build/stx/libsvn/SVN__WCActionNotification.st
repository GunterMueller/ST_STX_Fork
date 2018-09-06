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

Notification subclass:#WCActionNotification
	instanceVariableNames:'action entry'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Working copy'
!

!WCActionNotification class methodsFor:'documentation'!

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

!WCActionNotification class methodsFor:'instance creation'!

readFromString: string 
    ^ self new readFromString: string

    "Created: / 16-03-2008 / 08:53:50 / janfrog"
!

readFromXml: xmlNode 
    ^ self new readFromXml: xmlNode

    "Created: / 24-06-2009 / 15:02:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCActionNotification class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!WCActionNotification methodsFor:'accessing'!

action
    ^ action

    "Created: / 31-03-2008 / 11:09:26 / janfrog"
!

action:aWCAction
    action := aWCAction.

    "Created: / 31-03-2008 / 11:09:26 / janfrog"
!

entry
    ^ entry
!

entry:aWCEntry
    entry := aWCEntry.
!

icon

    ^action icon

    "Created: / 24-06-2009 / 15:08:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

path

    ^entry path

    "Created: / 27-08-2009 / 08:45:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wc: aSVNWorkingCopy

    ^entry wc: aSVNWorkingCopy

    "Created: / 27-08-2009 / 09:50:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WCActionNotification methodsFor:'displaying'!

displayString

    | icon |
    (icon := action icon)
        ifNil:[^(LabelAndIcon string: entry path) offset: 20; yourself]
        ifNotNil:[^LabelAndIcon label: entry path icon: action icon]
! !

!WCActionNotification methodsFor:'initialization'!

readFromString: string 
    | pair path |

    pair := string tokensBasedOn: Character space.

    action := WCAction actionNamed: (string copyTo:1).
    path := pair last.
    (path first = $' and: [ path last = $' ]) 
        ifTrue: [ path := path copyFrom: 2 to: path size - 1 ].
    entry := WCEntry path: path

    "Created: / 16-03-2008 / 08:54:44 / janfrog"
    "Modified: / 16-03-2008 / 10:06:42 / janfrog"
    "Modified: / 02-11-2009 / 17:24:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFromXml: xml 

    | path |

    "
     <path
       action='M'>/trunk/extensions.st</path>"

    action := WCAction actionNamed: (xml @ 'action').
    path := xml characterData.
     "Strip branch prefix"
    (path startsWith: '/trunk/') 
        ifTrue: [ path := path "entry" copyFrom: ('/trunk/' size) + 1 ]
        ifFalse: 
            [ ((path startsWith: '/branches/') or: [ path startsWith: '/tags/' ]) 
                ifTrue: 
                    [ | idx |

                    idx := path indexOf: $/ startingAt: 2.
                    idx := path indexOf: $/ startingAt: idx + 1.
                    idx isZero ifFalse: [ path := path copyFrom: idx + 1 ] ] ].
    entry := WCEntry path: path.

    "Modified: / 16-03-2008 / 10:06:42 / janfrog"
    "Created: / 24-06-2009 / 15:00:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-08-2009 / 08:22:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-10-2009 / 16:17:58 / Felix Madrid <fm@exept.de>"
! !

!WCActionNotification methodsFor:'printing'!

printOn: stream

    action printOn: stream.
    stream tab.
    entry printOn: stream

    "Created: / 16-03-2008 / 09:01:46 / janfrog"
! !

!WCActionNotification methodsFor:'processing'!

processUsing: processor 
    ^ action processEntry: entry using: processor

    "Created: / 27-08-2009 / 08:52:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WCActionNotification class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__WCActionNotification.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
