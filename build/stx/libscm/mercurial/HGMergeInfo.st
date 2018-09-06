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

Object subclass:#HGMergeInfo
	instanceVariableNames:'numUpdated numMerged numRemoved numUnresolved'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

!HGMergeInfo class methodsFor:'documentation'!

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

!HGMergeInfo methodsFor:'accessing'!

numMerged
    ^ numMerged
!

numRemoved
    ^ numRemoved
!

numUnresolved
    ^ numUnresolved
!

numUpdated
    ^ numUpdated
! !

!HGMergeInfo methodsFor:'initialization'!

setNumMerged:anInteger
    numMerged := anInteger.

    "Created: / 14-01-2013 / 15:44:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNumRemoved:anInteger
    numRemoved := anInteger.

    "Created: / 14-01-2013 / 15:44:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNumUnresolved:anInteger
    numUnresolved := anInteger.

    "Created: / 14-01-2013 / 15:44:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNumUpdated:anInteger
    numUpdated := anInteger.

    "Created: / 14-01-2013 / 15:44:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMergeInfo methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'numUpdated: '.
    numUpdated printOn:aStream.
    aStream nextPutAll:'numMerged: '.
    numMerged printOn:aStream.
    aStream nextPutAll:'numRemoved: '.
    numRemoved printOn:aStream.
    aStream nextPutAll:'numUnresolved: '.
    numUnresolved printOn:aStream.
! !

!HGMergeInfo class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

