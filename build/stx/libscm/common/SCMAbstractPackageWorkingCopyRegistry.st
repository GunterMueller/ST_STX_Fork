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
"{ Package: 'stx:libscm/common' }"

Object subclass:#SCMAbstractPackageWorkingCopyRegistry
	instanceVariableNames:'manager repositories wcs packages'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX'
!

SCMAbstractPackageWorkingCopyRegistry class instanceVariableNames:'Current'

"
 No other class instance variables are inherited by this class.
"
!

!SCMAbstractPackageWorkingCopyRegistry class methodsFor:'documentation'!

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
    A simple manager (registry) for package models

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SCMAbstractPackageWorkingCopyRegistry class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SCMAbstractPackageWorkingCopyRegistry class methodsFor:'accessing'!

current
    Current isNil ifTrue:[
        Current := self new
    ].
    ^Current

    "Created: / 06-10-2012 / 19:00:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flush
    Current := nil.

    "Created: / 06-10-2012 / 21:52:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2012 / 13:36:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageNamed: package
    ^self current packageNamed: package

    "Created: / 14-11-2012 / 00:14:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopyRegistry class methodsFor:'testing'!

isAbstract
    ^ self == SCMAbstractPackageWorkingCopyRegistry

    "Created: / 13-11-2012 / 23:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:59:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopyRegistry methodsFor:'accessing'!

packageNamed:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!SCMAbstractPackageWorkingCopyRegistry methodsFor:'initialization'!

flush
    self initialize

    "Created: / 06-10-2012 / 21:51:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flush: pattern
    "Flushes all cached data packages matching given name."

    self subclassResponsibility

    "Created: / 22-11-2012 / 11:37:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    repositories := Dictionary new.
    wcs := Dictionary new.
    packages := Dictionary new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 06-10-2012 / 22:26:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageWorkingCopyRegistry class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

