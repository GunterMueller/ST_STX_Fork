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

Object subclass:#HGPushPullInfo
	instanceVariableNames:'numChangesets numChanges numFiles numHeads'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

!HGPushPullInfo class methodsFor:'documentation'!

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

!HGPushPullInfo class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!HGPushPullInfo methodsFor:'accessing'!

numChanges
    ^ numChanges
!

numChangesets
    ^ numChangesets
!

numFiles
    ^ numFiles
!

numHeads
    ^ numHeads
! !

!HGPushPullInfo methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    numChangesets := 0.
    numChanges := 0.
    numFiles := 0.
    numHeads := 0.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 05-02-2013 / 09:39:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNumChanges: anInteger
    numChanges := anInteger

    "Created: / 04-02-2013 / 15:21:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNumChangesets: anInteger
    numChangesets := anInteger

    "Created: / 04-02-2013 / 15:21:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNumFiles: anInteger
    numFiles := anInteger

    "Created: / 04-02-2013 / 15:21:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNumHeads: anInteger
    numHeads := anInteger

    "Created: / 05-02-2013 / 09:39:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPushPullInfo methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    aStream nextPutAll: 'added '.
    numChangesets printOn: aStream.
    aStream nextPutAll: ' changesets with  '.
    numChanges printOn: aStream.
    aStream nextPutAll: ' changes to '.
    numFiles printOn: aStream.
    aStream nextPutAll: ' files'.

    "Modified: / 04-02-2013 / 15:28:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPushPullInfo class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

