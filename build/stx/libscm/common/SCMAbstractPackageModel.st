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

Object subclass:#SCMAbstractPackageModel
	instanceVariableNames:'name parent children repository repositoryRoot virtual'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX'
!

!SCMAbstractPackageModel class methodsFor:'documentation'!

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
    A model of a Smalltalk/X package in repository. It can
    answer a changeset containing package code and diffs against
    another package model.

    == Hierarchy ==

    Package models forms a hiearchy that copies package hiearchy. The root
    has no parent and represent a package which is located in the root
    of the repository. Examples:

    stx:libscm           ---> parent = nil,         repository = /home/.../build/stx/libscm, repositoryPath = '.'
    stx:libscm/common    ---> parent = stx:libscm,  repository = /home/.../build/stx/libscm, repositoryPath = 'common'
    stx:libscm/mercurial ---> parent = stx:libscm,  repository = /home/.../build/stx/libscm, repositoryPath = 'mercurial'

    In this case, the (HG)Repository object is shared by all three package models. See
    #chilren, #parent and #root.

    == Virtual packages ==

    Package is 'virtual' if there's actually no code in the package. Virtual packages
    are therefore just containers for nested packages. For example, package 'stx' would
    be a 'virtual' package, since there's no code packages in 'stx' - all is in one of
    its nested sub-packages - stx:libbasic, stx:libscm.

    See #isVirtual.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SCMAbstractPackageModel class methodsFor:'instance creation'!

named: package
    self subclassResponsibility

    "Created: / 16-11-2012 / 19:52:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SCMAbstractPackageModel class methodsFor:'testing'!

isAbstract
    ^ self == SCMAbstractPackageModel

    "Created: / 13-11-2012 / 23:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2014 / 22:38:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageModel methodsFor:'accessing'!

abbrevs
    "Returns a Dictionary mapping class name to an abbrev entry object.
     This object should at least respond to #fileName"

    ^ self subclassResponsibility

    "Created: / 14-03-2014 / 22:02:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

construct: aString
    "Create a package model for subpackage named aString"

    | normalizedName components package |

    normalizedName := (aString includes: $:) ifTrue:[aString copyReplaceAll:$: with:$/] ifFalse:[aString].
    ( normalizedName includes: $/) ifFalse:[
        ^self childNamed: normalizedName.
    ].

    components := normalizedName tokensBasedOn: $/.
    package := self.
    components do:[:each|package := package childNamed: each].
    ^package

    "Created: / 16-11-2012 / 23:47:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2012 / 14:04:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

definition
    "Returns a sort of project definition object.
     It has to at least understand #classNamesAndAttributes and
     #xtensionMethodNames."

    ^ self subclassResponsibility

    "Created: / 14-03-2014 / 21:57:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name
!

repositoryRoot
    "Returns relative path within the repository root where the package
     content is located. Example: let's assume:

     <repo>/.hg
     <repo>/mercurial/...
     <repo>/mercurial/tests/...
     <repo>/common/..

     then

     (HGPackageModelRegistry packageNamed: 'stx:libscm/mercurial/tests') path
        == 'mercurial/tests'
    "

    self assert: repositoryRoot notNil.

    ^repositoryRoot

    "Created: / 01-12-2012 / 02:03:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision
    "Return a logical revision package model"

    ^ self subclassResponsibility

    "Created: / 05-03-2014 / 23:16:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageModel methodsFor:'accessing-containers'!

containerFor: aString
    "Return a container as Filename with given name"    

    ^ self containerFor: aString ifAbsent: [ self error: 'No container named ', aString ]

    "Modified: / 14-03-2014 / 22:15:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerFor: aString ifAbsent: aBlock
    "Return a container as Filename with given name. If there's no such
     container, evaluates a block"    

    ^ self subclassResponsibility

    "Created: / 14-03-2014 / 22:15:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerForProjectDefinition
    ^ self containerFor: (ProjectDefinition initialClassNameForDefinitionOf: name) , '.st'

    "Created: / 13-03-2014 / 23:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2014 / 22:00:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerNameForClass:cls
    | clsName |

    clsName := cls isJavaClass ifTrue:[ cls theNonMetaClass binaryName ] ifFalse:[ cls theNonMetaclass fullName ].
    ^ self
        containerNameForClassNamed: clsName
        language: cls programmingLanguage

    "Created: / 07-10-2012 / 10:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2014 / 08:39:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerNameForClassNamed: nm language: lang
    ^String streamContents:[:s|
        "/ Sigh, special case for Java classes. Their code
        "/ is in java/src subdirectory.
        lang isJavaLike ifTrue:[ 
            s nextPutAll: 'java'.
            s nextPut: Filename separator.
            s nextPutAll: 'src'.
            s nextPut: Filename separator.      
            s nextPutAll: (nm copyReplaceAll: $/ with: Filename separator).
        ] ifFalse:[ 
            | xlated |

            "/ Here, consult abbreviation file...
            lang isSmalltalk ifTrue:[
                | abbrev |

                abbrev := self abbrevs at: nm ifAbsent:[ nil ].
                abbrev notNil ifTrue:[ 
                    xlated := abbrev fileName.
                ].
            ].
            xlated isNil ifTrue:[ 
                xlated := (nm copyReplaceAll:$: with: $_).
            ].
            s nextPutAll: (nm copyReplaceAll:$: with: $_). "/ Q: should't this be nextPutAll: xlated here? See issue #48.
        ].
        s nextPut: $..
        s nextPutAll: lang sourceFileSuffix.
    ]

    "Created: / 15-11-2012 / 00:45:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 31-07-2014 / 08:54:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerNameForExtensions
    ^self containerNameForExtensions: SmalltalkLanguage instance

    "Created: / 07-10-2012 / 10:37:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerNameForExtensions: aProgrammingLanguage
    ^'extensions.' , aProgrammingLanguage sourceFileSuffix

    "Created: / 07-10-2012 / 10:38:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerNameForExtensions: aProgrammingLanguage javaClass: aJavaClass
    | class classBinaryName comps |

    class := aJavaClass theNonMetaClass.
    "Sigh, make it compatible with old and new naming of Java classes

    old -> aJavaClass name == #'java/lang/Object'
    new -> aJavaClass name == JAVA::java::lang::Object
           aJavaClass binaryName == #'java/lang/Object'
    "
    classBinaryName := (class respondsTo: #binaryName)
                            ifTrue:[ class binaryName ]
                            ifFalse:[ class name ].
    self assert: (classBinaryName includes: $:) not.

    ^ String streamContents:[:s|
        s nextPutAll: 'java/extensions'.
        comps := classBinaryName tokensBasedOn: $/.
        comps do:[:each| s nextPut: $/; nextPutAll: each ].
        s nextPut: $.; nextPutAll: aProgrammingLanguage sourceFileSuffix.
    ].

    "Created: / 24-09-2013 / 11:31:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-10-2013 / 08:56:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containerSuffixes

    ^ProgrammingLanguage all collect:[:each|each sourceFileSuffix]

    "Created: / 23-03-2009 / 18:53:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 18:15:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containers
    ^ self subclassResponsibility

    "Created: / 05-03-2014 / 23:36:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageModel methodsFor:'accessing-hierarchy'!

children
    "Returns all my immediate children."       

    ^ self subclassResponsibility

    "Created: / 05-03-2014 / 23:18:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

childrenDo: aBlock
    "Evaluate a block for all immediate children of the receiver.
     Does NOT recurse."

    self children do: aBlock

    "Created: / 19-02-2014 / 23:47:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent
    "Returns the parent model. See class documentation for details on parents"

    ^parent

    "Created: / 01-12-2012 / 17:56:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

root
    "Returns the root of this package model hierarchy, i.e., grand-parent which itself has no parent.
     See class documentation for details on parents"

    | p |

    p := self.
    [ p parent notNil ] whileTrue:[
        p := p parent.
    ].
    ^ p

    "Created: / 19-02-2014 / 23:30:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

siblings
    "Returns all my siblings"

    parent notNil
        ifTrue:[ ^ self parent children copy remove: self; yourself]
        ifFalse:[ ^ #() ]

    "
    (HGPackageWorkingCopyRegistry packageNamed: 'stx:libscm') siblings
    (HGPackageWorkingCopyRegistry packageNamed: 'stx:libscm/common') siblings
    "

    "Created: / 20-02-2014 / 00:22:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2014 / 14:21:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

yourselfAndAllChildrenDo: aBlock
    "Evaluate a block for receiver and all its children, recursively."

    aBlock value: self.
    self children do:[:each | each yourselfAndAllChildrenDo: aBlock ]

    "Created: / 19-02-2014 / 23:49:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageModel methodsFor:'accessing-private'!

childNamed: aString
    "Returns a child name aString. If no such child
     exist, create one"     

    ^ self subclassResponsibility

    "Created: / 05-03-2014 / 23:19:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageModel methodsFor:'initialization'!

setParent: aSCMAbstractPackageModel
    parent := aSCMAbstractPackageModel

    "Modified: / 08-03-2014 / 10:05:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageModel methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

     super printOn:aStream.
    aStream nextPut:$(.
    name printOn: aStream.
    aStream nextPutAll: ' @ '.
    self revision printOn: aStream.
    aStream nextPut:$).

    "Modified: / 08-03-2014 / 10:01:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageModel methodsFor:'testing'!

isChildOf: anotherPackageModel
    ^ anotherPackageModel isParentOf: self.

    "Created: / 25-02-2014 / 22:51:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isParentOf: anotherPackageModel    
    | anotherName |

    anotherName := anotherPackageModel name.
    ^ (anotherName size) > (name size + 1)
        and:[ (anotherName startsWith: name)
            and:[ ':/' includes: (anotherName at: name size + 1) ]].

    "Created: / 25-02-2014 / 22:50:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isVirtual
    "Return true, if the package is virtual, i.e., there's no code in
     the package. False otherwise.

     Virtual packages serves merely as containers for nested packages"       

    ^ self subclassResponsibility

    "Modified (comment): / 07-03-2014 / 22:58:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageModel class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

