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

HGTagOrBookmark subclass:#HGTag
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

!HGTag class methodsFor:'documentation'!

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

!HGTag methodsFor:'accessing-presentation'!

color
    "Return a color that should be maybe when displaying branch
     visual guide."     

    color isNil ifTrue:[ 
        color := Color gray lighter
    ].
    ^ color

    "Created: / 24-03-2014 / 09:30:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTag methodsFor:'testing'!

isTag
    ^ true
! !

!HGTag class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

