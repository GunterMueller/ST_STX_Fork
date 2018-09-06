"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group,
                           Czech Technical University in Prague
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
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

ChangeSetDiffComponent subclass:#ChangeSetDiffSet
	instanceVariableNames:'name versionALabel versionBLabel versionBaseLabel diffs'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes-Diff'
!

!ChangeSetDiffSet class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group,
                           Czech Technical University in Prague
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

!ChangeSetDiffSet class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!ChangeSetDiffSet methodsFor:'accessing'!

depth
    | depth |
    depth := 0.
    diffs do:[:diff|
        depth := depth max: diff depth
    ].
    ^depth + 1

    "Created: / 15-01-2013 / 11:27:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffs
    ^ diffs
!

flattened

    | flattened s |
    flattened := self copy.
    s := (OrderedCollection new: diffs size) writeStream.
    self flattenOn: s.
    flattened setDiffs: s contents.
    ^flattened

    "Created: / 05-12-2009 / 11:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

merged

    ^diffs allSatisfy:[:e|e merged]

    "Created: / 24-11-2009 / 10:04:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name

    ^ '%1 (%2)' bindWith: (name ? '<unnamed>') with: diffs size

    "Modified: / 26-11-2009 / 16:26:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 14:15:12 / jv"
!

name:aString
    name := aString.
!

nextEntryAfter: entry suchThat: predicate
    | found |

    entry isNil ifTrue:[ 
        self do:[:each|(predicate value: each) ifTrue:[^each]].
        ^nil
    ].

    found := false.
    self do:[:each|
        each == entry ifTrue:[
            found := true
        ] ifFalse:[
            (found and:[predicate value: each]) ifTrue:[ ^ each ]
        ].
    ].
    ^nil

    "Created: / 17-01-2013 / 13:00:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-01-2013 / 16:55:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextEntryBefore: entry suchThat: predicate
    | last |

    entry isNil ifTrue:[ 
        ^nil
    ].

    self do:[:each|
        each == entry ifTrue:[ ^ last ].
        (predicate value: each) ifTrue:[last := each].
    ].
    ^nil

    "Created: / 17-01-2013 / 16:57:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolution
    | changeset |

    changeset := ChangeSet new.
    self do:[:diff|
        diff versionMerged notNil ifTrue:[
            changeset add: diff versionMerged
        ]
    ].
    ^changeset

    "Created: / 26-11-2009 / 08:44:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:25:02 / cg"
!

versionALabel
    ^ versionALabel ifNil:[parent ifNotNil:[parent versionALabel]]

    "Modified: / 21-11-2009 / 07:50:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:26:15 / cg"
!

versionALabel:aString
    versionALabel := aString.
!

versionBLabel
    ^ versionBLabel ifNil:[parent ifNotNil:[parent versionBLabel]]

    "Modified: / 21-11-2009 / 07:51:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:26:19 / cg"
!

versionBLabel:aString
    versionBLabel := aString.
!

versionBaseLabel
    ^ versionBaseLabel ifNil:[parent ifNotNil:[parent versionBaseLabel]]

    "Created: / 23-11-2009 / 22:54:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-11-2009 / 09:21:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 29-11-2011 / 11:26:37 / cg"
!

versionBaseLabel:aString
    versionBaseLabel := aString.
! !

!ChangeSetDiffSet methodsFor:'adding & removing'!

add: anObject

    anObject parent: self.
    ^diffs add: anObject

    "Created: / 09-11-2009 / 12:36:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-11-2009 / 11:26:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addAll: aCollection

    aCollection do:[:e|self add:e]

    "Created: / 10-11-2009 / 11:27:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffSet methodsFor:'enumerating'!

collect: aBlock

    ^diffs collect: aBlock

    "Created: / 10-11-2009 / 11:26:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

do: aBlock

    ^diffs do: [:each|each do:aBlock]

    "Created: / 10-11-2009 / 11:26:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2009 / 10:30:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffSet methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ name := nil.
    "/ versionALabel := nil.
    "/ versionBLabel := nil.
    diffs := OrderedCollection new:4.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 10-11-2009 / 11:25:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setDiffs: aCollection

    diffs := aCollection

    "Created: / 05-12-2009 / 11:09:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffSet methodsFor:'private'!

flattenOn: stream

    diffs do:[:diff|diff flattenOn: stream]

    "Created: / 05-12-2009 / 11:07:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sort:sortBlock
    "superclass ChangeSetDiffComponent says that I am responsible to implement this method"

    diffs sort: sortBlock.
    diffs do:[:e|e sort: sortBlock].

    "Modified: / 17-01-2013 / 14:18:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffSet methodsFor:'testing'!

isConflict
    "Return true, if there is a conflict."

    ^ self diffs anySatisfy:[:e|e isConflict].

    "Created: / 01-08-2012 / 17:10:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDiffSet
    ^ true
!

isEmpty

    ^diffs isEmpty or:[diffs allSatisfy: [:diff|diff isEmpty]]

    "Created: / 25-11-2009 / 20:37:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2009 / 17:43:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isForCopyrightMethod
    "Returns true, if this is an entry for #copyright method"

    ^diffs allSatisfy:[:each|each isForCopyrightMethod]

    "Created: / 01-08-2012 / 16:38:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isForVersionMethod
    "Returns true, if this is an entry for version method"

    ^diffs allSatisfy:[:each|each isForVersionMethod]

    "Created: / 18-04-2012 / 19:05:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMerged
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self diffs allSatisfy:[:e|e isMerged].

    "Created: / 19-03-2012 / 15:15:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffSet class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

