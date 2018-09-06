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

HGTagOrBookmark subclass:#HGBookmark
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

!HGBookmark class methodsFor:'documentation'!

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

!HGBookmark methodsFor:'accessing-presentation'!

color
    "Return a color that should be maybe when displaying branch
     visual guide."     

    color isNil ifTrue:[ 
        "/ Should ask color library...
        color := Color orange lighter
    ].
    ^ color

    "Created: / 24-03-2014 / 09:29:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGBookmark methodsFor:'actionns'!

remove
    repository bookmarkDelete: self.
    repository := nil.
    name := '** invalid bookmark **'.
    changeset := nil.

    "Created: / 21-03-2014 / 01:17:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGBookmark methodsFor:'testing'!

isActive
    ^ repository bookmark == self.

    "Created: / 20-03-2014 / 01:50:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2014 / 17:35:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isBookmark
    ^ true
! !

