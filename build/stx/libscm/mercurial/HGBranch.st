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

HGChangesetLabel subclass:#HGBranch
	instanceVariableNames:'active closed'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

!HGBranch class methodsFor:'documentation'!

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

!HGBranch methodsFor:'accessing'!

heads
    "Returns a list of heads (as HGChangeset) of receicer"

    ^repository heads select:[:cs|cs branches includes: self].

    "Created: / 27-11-2012 / 21:38:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGBranch methodsFor:'accessing-presentation'!

color
    "Return a color that should be maybe when displaying branch
     visual guide."

    color isNil ifTrue:[
        self isDefault ifTrue:[
            color := Color green darker
        ] ifFalse:[
            "/ Should ask color library...
            color := Color gray.
        ].
    ].
    ^ color

    "Created: / 16-03-2014 / 23:19:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-03-2014 / 10:15:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGBranch methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    active := true.
    closed := false.

    "Created: / 27-11-2012 / 19:34:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setActive: aBoolean
    active := aBoolean

    "Created: / 27-11-2012 / 19:31:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setClosed: aBoolean
    closed := aBoolean

    "Created: / 27-11-2012 / 19:31:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGBranch methodsFor:'testing'!

isActive
    ^active

    "Created: / 27-11-2012 / 19:32:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isBranch
    ^ true
!

isClosed
    ^closed

    "Created: / 27-11-2012 / 19:32:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDefault
    ^ name = 'default'

    "Created: / 16-03-2014 / 23:03:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGBranch class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

