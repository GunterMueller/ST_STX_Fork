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

"{ NameSpace: Smalltalk }"

HGChangesetLabel subclass:#HGTagOrBookmark
	instanceVariableNames:'changeset'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Internal'
!

!HGTagOrBookmark class methodsFor:'documentation'!

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

!HGTagOrBookmark class methodsFor:'testing'!

isAbstract
    ^ self == HGTagOrBookmark
! !

!HGTagOrBookmark methodsFor:'accessing'!

changeset
    "Return changeset labeled by receiver"

    changeset class == HGChangesetId ifTrue:[
        changeset := repository changesetWithId: changeset
    ].
    ^changeset

    "Modified (comment): / 20-03-2014 / 01:48:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetId
    "Return id of changeset labeled by receiver"

    changeset class == HGChangesetId ifTrue:[
        ^ changeset 
    ].
    ^changeset id

    "Created: / 20-03-2014 / 01:48:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTagOrBookmark methodsFor:'initialization'!

setChangesetId: anHGChangesetId
    changeset := anHGChangesetId

    "Created: / 20-03-2014 / 01:47:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTagOrBookmark class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

