"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

Object subclass:#HGChange
	instanceVariableNames:'changeset path'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

HGChange subclass:#Added
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGChange
!

HGChange subclass:#Copied
	instanceVariableNames:'source'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGChange
!

HGChange subclass:#Modified
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGChange
!

HGChange subclass:#Removed
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGChange
!

!HGChange class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGChange class methodsFor:'instance creation'!

newAdded
    ^Added new

    "Created: / 05-12-2012 / 17:20:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newCopied
    ^Copied new

    "Created: / 05-12-2012 / 17:20:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newModified
    ^Modified new

    "Created: / 05-12-2012 / 17:20:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newRemoved
    ^Removed new

    "Created: / 05-12-2012 / 17:20:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChange methodsFor:'accessing'!

changeset
    ^ changeset
!

entry
    ^ changeset / path

    "Modified: / 05-12-2012 / 17:17:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

icon
    ^ nil

    "Created: / 17-03-2014 / 23:54:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

path
    ^ path
! !

!HGChange methodsFor:'displaying'!

displayOn: aGC x:x y:y"baseline"
    | icon iconW iconH iconX iconY labelXOffset |

    labelXOffset := 18"magic constant".
    icon := self icon.
    icon notNil ifTrue:[
        iconW := icon width.
        iconH := icon height.
        iconX := x + ((labelXOffset - iconW) // 2).
        iconY := (y - aGC font ascent) + ((aGC font height - iconH) // 2).
        icon displayOn: aGC x: iconX y: iconY.
    ].
    self path displayOn: aGC x: x + labelXOffset y: y.

    "Created: / 18-03-2014 / 00:09:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-03-2014 / 11:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChange methodsFor:'initialization'!

setChangeset: anHGChangeset path: aString
    changeset := anHGChangeset.
    path := aString

    "Created: / 05-12-2012 / 17:18:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChange methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    changeset id printOn:aStream.
    aStream space.
    path printOn:aStream.
    aStream nextPut:$).

    "Modified: / 28-10-2014 / 13:34:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChange methodsFor:'testing'!

isAdded
    ^ false
!

isCopied
    ^ false
!

isModified
    ^ false
!

isRemoved
    ^ false
! !

!HGChange::Added methodsFor:'accessing'!

icon
    ^ HGIconLibrary fileStatusAdded

    "Created: / 17-03-2014 / 23:55:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChange::Added methodsFor:'testing'!

isAdded
    ^ true
! !

!HGChange::Copied methodsFor:'accessing'!

icon
    ^ HGIconLibrary fileStatusCopied

    "Created: / 17-03-2014 / 23:55:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source
    ^ source
! !

!HGChange::Copied methodsFor:'initialization'!

setSource: aString
    source := aString

    "Created: / 05-12-2012 / 17:19:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChange::Copied methodsFor:'testing'!

isCopied
    ^ true
! !

!HGChange::Modified methodsFor:'accessing'!

icon
    ^ HGIconLibrary fileStatusModified

    "Created: / 17-03-2014 / 23:56:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChange::Modified methodsFor:'testing'!

isModified
    ^ true
! !

!HGChange::Removed methodsFor:'accessing'!

icon
    ^ HGIconLibrary fileStatusRemoved

    "Created: / 17-03-2014 / 23:56:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChange::Removed methodsFor:'testing'!

isRemoved
    ^ true
! !

!HGChange class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

