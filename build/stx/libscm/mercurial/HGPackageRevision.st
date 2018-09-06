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

SCMAbstractPackageRevision subclass:#HGPackageRevision
	instanceVariableNames:'changeset changesetRoot'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX'
!

!HGPackageRevision class methodsFor:'documentation'!

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

!HGPackageRevision class methodsFor:'instance creation'!

changeset:anHGChangeset root:anHGChangesetFile 
    "Creates a new HGPackageRevision for given changeset and changeset file
     (assuming that changeset file is root of the package). 

     Raises an HGError when repositoru doesn't contain a Smalltalk/X package."

    ^ self new setChangeset: anHGChangeset root: anHGChangesetFile.

    "Created: / 06-03-2014 / 09:27:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2014 / 10:35:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeset:anHGChangeset root:anHGChangesetFile name: aString
    "Creates a new HGPackageRevision for given changeset,  root and name.
     (assuming that changeset file is root of the package). 

     Raises an HGError when root doesn't contain a Smalltalk/X package."

    ^ self new setChangeset: anHGChangeset root: anHGChangesetFile name: aString

    "Created: / 07-03-2014 / 12:52:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageRevision methodsFor:'accessing'!

revision
    "Return a logical revision package model"

    ^ changeset id

    "Created: / 05-03-2014 / 23:45:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageRevision methodsFor:'accessing-containers'!

containerFor: aString ifAbsent: aBlock
    "Return a container as Filename with given name. If there's no such
     container, evaluates a block"            

    ^ (changesetRoot children includesKey: aString)   
        ifTrue:[ changesetRoot / aString ]
        ifFalse:[ aBlock value ]

    "Created: / 14-03-2014 / 22:17:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageRevision methodsFor:'accessing-hierarchy'!

children
    children isNil ifTrue:[ 
        children := Dictionary new.
        changesetRoot children do:[:each | 
            each isDirectory ifTrue:[ 
                | childPackageName child |

                childPackageName := (name includes: $:) 
                        ifTrue:[ name , '/' , each baseName ] 
                        ifFalse:[ name , ':' , each baseName ].
                [ 
                    child := self class changeset: changeset root: each name: childPackageName.
                    child setParent: self.
                    children at: each baseName put: child.
                ] on: HGError do:[:ex | 
                    "/ OK, directory does not contain a package...
                ].
            ].
        ].
    ].
    ^ children values

    "Created: / 07-03-2014 / 12:47:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2014 / 14:24:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGPackageRevision methodsFor:'initialization'!

setChangeset: anHGChangeset root: anHGChangesetFile
    "Initializes a package rev for given changeset and root.
     Raises an exception, if given root does not contain
     a Smalltalk/X package"

    | make_spec |

    "/ Look for Make.spec and extract package name from there
    "/ Hmm...stupid, / raises an error when file does not exist.
    "/ Maybe I should change it...
    [
        make_spec := anHGChangesetFile / 'Make.spec'
    ] on: HGError do:[
        make_spec := nil.
    ].
    make_spec notNil ifTrue:[ 
        | module module_dir |
        make_spec readingLinesDo:[:line|
            (line startsWith:'MODULE_DIR=') ifTrue:[ 
                module_dir := line copyFrom: "'MODULE_DIR=' size"11 + 1.
            ] ifFalse:[ 
                (line startsWith:'MODULE=') ifTrue:[ 
                    module := line copyFrom: "'MODULE=' size"7 + 1.
                ]            
            ].
        ].
        (module notNil and:[ module_dir notNil ]) ifTrue:[            
            self setChangeset: anHGChangeset root: anHGChangesetFile name: (module , ':' , module_dir) virtual: false.
            ^ self.
        ].
    ].

    "/ Make.spec not found or failed to extract packagename from there.
    "/ Maybe this is a virtual package container such as stx:libscm.
    "/ Search directories, if any package is found there, derive my name
    "/ child's name.
    children := Dictionary new.
    anHGChangesetFile children do:[:each | 
        each isDirectory ifTrue:[ 
            | child |

            [ 
                child := self class changeset: anHGChangeset root: each.
                child setParent: self.
                children at: each baseName put: child.
            ] on: HGError do:[:ex | 
                "/ OK, directory does not contain a package...
            ].
        ].
    ].
    children notEmpty ifTrue:[ 
        | myName |

        myName := children anElement name asPackageId parentPackage asString.
        self setChangeset: anHGChangeset root: anHGChangesetFile name: myName virtual: true.
        ^ self.
    ].

    "/ None of my subdirectories is a valid Smalltalk/X package,
    "/ so not I'am.
    HGError raise.

    "Created: / 07-03-2014 / 10:38:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2014 / 10:06:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setChangeset: anHGChangeset root: anHGChangesetFile name: aString
    "Initializes a package rev with given changeset and root and name."

    | v |

    [
        anHGChangesetFile / 'Make.spec'.
        anHGChangesetFile / ((ProjectDefinition initialClassNameForDefinitionOf: aString) , '.' , SmalltalkLanguage instance sourceFileSuffix).
        v := false
    ] on: HGError do:[
        v := true.
    ].
    self setChangeset: anHGChangeset root: anHGChangesetFile name: aString virtual: v.

    "Created: / 07-03-2014 / 23:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setChangeset: anHGChangeset root: anHGChangesetFile name: aString virtual: aBoolean
    "Initializes a package rev with given changeset and root and name."



    name := aString.
    changeset := anHGChangeset.
    changesetRoot := anHGChangesetFile.
    repository := anHGChangeset repository.
    repositoryRoot := anHGChangesetFile pathName.
    virtual := aBoolean. 

    virtual ifFalse:[
        "/ Check, whether the project definition class really exists
        [ 
            anHGChangesetFile / ((ProjectDefinition initialClassNameForDefinitionOf: aString) , '.' , SmalltalkLanguage instance sourceFileSuffix)
        ] on: HGError do:[ 
            ^ HGError newException
                parameter: (Array with: anHGChangeset with: anHGChangesetFile with: aString);
                messageText: ('No project definition class found for %1' bindWith: aString);
                raise.
        ].
    ].

    "Created: / 07-03-2014 / 23:03:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2014 / 10:06:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

