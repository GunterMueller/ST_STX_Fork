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

Object subclass:#HGRepositoryObject
	instanceVariableNames:'repository'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Internal'
!

!HGRepositoryObject class methodsFor:'documentation'!

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
!

documentation
"
    A base abstract superclass for Mercurial repository
    objects.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGRepositoryObject class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!HGRepositoryObject methodsFor:'accessing'!

repository
    ^ repository
! !

!HGRepositoryObject methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ repository := nil.

    "/ super initialize.   -- commented since inherited method does nothing
!

setRepository: anHGRepository
    repository := anHGRepository

    "Created: / 17-10-2012 / 13:48:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepositoryObject methodsFor:'synchronized evaluation'!

synchronizationSemaphore
    ^repository synchronizationSemaphore

    "Created: / 16-12-2012 / 00:41:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

synchronizationSemaphore: aRecursionLock
    self breakPoint: #jv.
    repository synchronizationSemaphore: aRecursionLock

    "Created: / 16-12-2012 / 00:41:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRepositoryObject class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

