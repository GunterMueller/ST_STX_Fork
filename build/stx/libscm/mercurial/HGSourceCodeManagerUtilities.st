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

SCMCommonSourceCodeManagerUtilities subclass:#HGSourceCodeManagerUtilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX'
!

!HGSourceCodeManagerUtilities class methodsFor:'documentation'!

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

!HGSourceCodeManagerUtilities methodsFor:'utilities - user interaction'!

askForExistingRevision:boxText title:title class:clsOrNil manager:aSourceCodeManager module:module package:directory fileName:fileName
    | package wc path revset dialog |

    package := PackageId module: module directory: directory.
    wc := HGPackageWorkingCopy named: package asString.
    path := wc repositoryRoot , '/' , fileName.
    revset := HGRevset fromString: ('file(%1)' bindWith: path).
    dialog := HGChangesetDialog new.
    dialog repository: wc repository.
    dialog revset: revset.
    ^ dialog open 
        ifTrue:[ dialog changeset id printString ] 
        ifFalse:[ nil ].

    "Created: / 24-03-2014 / 14:33:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManagerUtilities class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

