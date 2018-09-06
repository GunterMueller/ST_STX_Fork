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

SCMAbstractPackageWorkingCopyRegistry subclass:#HGPackageWorkingCopyRegistry
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX'
!

!HGPackageWorkingCopyRegistry class methodsFor:'documentation'!

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

!HGPackageWorkingCopyRegistry methodsFor:'accessing'!

packageNamed0:package
    "Returns a HGPackageModel for given package or nil
     if given package is not backed by Mercurial repository."

    | dir components names namei directories root rootI rootD pkg|

    packages at: package ifPresent: [ :p | ^ p ].

    components := OrderedCollection new.
    names := OrderedCollection new.

    (package includes: $:) ifFalse:[
        components := Array with: package.
        names := Array with: package.
    ] ifTrue:[
        | i1 i2 |

        i1 := 1.
        i2 := package indexOf: $:.

        components add: (package copyFrom: i1 to: i2 - 1).
        names add: (package copyFrom: 1 to: i2 - 1).

        i1 := i2 + 1.
        [ (i2 := package indexOf: $/ startingAt: i1) ~~ 0 ] whileTrue:[
            components add: (package copyFrom: i1 to: i2 - 1).
            names add: (package copyFrom: 1 to: i2 - 1).
            i1 := i2 + 1.        
        ].

        components add: (package copyFrom: i1 ).
        names add: package

    ].

    "Package might be sub-package which may not exists. Search for some
     existing packagedir along package hierarchy"
    namei := names size.
    [ dir isNil and: [ namei > 0  ] ] whileTrue:[
        dir := Smalltalk getPackageDirectoryForPackage: (names at: namei).
        dir notNil ifTrue:[
            namei + 1 to: names size do:[:i|
                dir := dir / (components at: i).
            ].
        ].
        namei := namei - 1.
    ].
    dir isNil ifTrue:[ ^ nil ].

    directories := Array new: components size.
    directories at: components size put: dir.
    directories size - 1 downTo: 1 do:[:i|
        directories at: i put: (directories at: i + 1) directory.            
    ].

    "/ search cached packages...
    1 to: names size do:[:i|
        packages at: (names at:i) ifPresent:[:p|root := p. rootI := i].
    ].
    root isNil ifTrue:[
        directories withIndexDo:[:each :eachI|
            ( each / '.hg' ) exists  ifTrue:[
                rootD := each.
                rootI := eachI.
            ].
        ].
        rootD isNil ifTrue:[ ^ nil ].
        root := HGPackageWorkingCopy new 
                    setName: (names at: rootI) 
                    repository: (HGRepository on: rootD).
        packages at: root name put: root.
    ].
    pkg := root.
    rootI + 1 to: components size do:[:each|
        pkg := pkg construct: (components at:each).
        packages at: pkg name put: pkg.        
    ].

    ^pkg

    "Created: / 18-03-2013 / 22:26:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 21:45:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageNamed:package
    "Returns a HGPackageModel for given package or nil
     if given package is not backed by Mercurial repository."

    | pkg idx |

    pkg := self packageNamed0: package.
    pkg notNil ifTrue:[ ^ pkg ].
    idx := package lastIndexOf: $/.
    idx == 0 ifTrue:[
        idx := package lastIndexOf: $:.
    ].
    idx ~~ 0 ifTrue:[
        pkg := self packageNamed0: (package copyTo: idx - 1).
        pkg notNil ifTrue:[
            pkg := pkg construct: (package copyFrom: idx + 1).
            packages at: pkg name put: pkg.        
            ^pkg.
        ]
    ].
    ^nil.

    "Created: / 14-11-2012 / 00:15:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-03-2013 / 22:41:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageWorkingCopyRegistry methodsFor:'initialization'!

flush: pattern
    "Flushes all cached data packages matching given name."
    | toFlush |
    toFlush := OrderedCollection new.
    packages valuesDo:[:package|
        (package name matches: pattern) ifTrue:[toFlush add: package]].
    toFlush do:[:package|
        | wcdir |
        repositories removeKey: package repository path ifAbsent:[nil].
        wcdir := package temporaryWorkingCopyPath.
        wcdir exists ifTrue:[
            [ wcdir recursiveRemove ] on: Error do:[
                OperatingSystem isMSWINDOWSlike ifTrue:[
                    Delay waitForSeconds: 1.
                    [ wcdir recursiveRemove ] on: Error do:[
                        "/ Sigh, just give up on this stupid system.
                    ]
                ].
            ].
        ].
        packages removeKey: package name
    ].

    "Created: / 16-11-2012 / 19:40:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-02-2013 / 09:28:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2016 / 19:52:09 / jv"
! !

!HGPackageWorkingCopyRegistry class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

