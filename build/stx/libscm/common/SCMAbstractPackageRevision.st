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

SCMAbstractPackageModel subclass:#SCMAbstractPackageRevision
	instanceVariableNames:'definition classNamesAndAttributes abbrevs'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX'
!

Object subclass:#AbbrevEntry
	instanceVariableNames:'className fileName category numClassInstVars'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SCMAbstractPackageRevision
!

Object subclass:#ProjectDefinition
	instanceVariableNames:'classNamesAndAttributes extensionMethodNames'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SCMAbstractPackageRevision
!

!SCMAbstractPackageRevision class methodsFor:'documentation'!

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
    A package revision represents a package at particular revision.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        HGPackageRevision

"
! !

!SCMAbstractPackageRevision class methodsFor:'testing'!

isAbstract
    ^ self == SCMAbstractPackageRevision

    "Created: / 13-11-2012 / 23:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 22:06:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageRevision methodsFor:'accessing'!

abbrevs

    abbrevs isNil ifTrue:[
        | abbrev_stc |
        abbrevs := Dictionary new.
        abbrev_stc := self containerFor: 'abbrev.stc' ifAbsent:[ nil ].
        abbrev_stc notNil ifTrue:[
            abbrev_stc readingFileDo:[:stream |
                Smalltalk
                    withAbbreviationsFromStream:stream contents asString readStream
                    do:[:nm :fn :pkg :cat :sz|
                        abbrevs at: nm put: (AbbrevEntry new className:nm fileName:fn category:cat numClassInstVars:sz)
                    ]
            ].
        ].
    ].
    ^ abbrevs

    "Created: / 14-03-2014 / 09:57:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2014 / 22:18:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSet
    "Returns a ChangeSet representing (Smalltalk) code of this
     package. For virtual packages, return nil."

    | changeset container |

    "/ If virtual, return nil. Q: Shouldn't it be better to throw an exception?
    self isVirtual ifTrue:[ ^ nil ].

    changeset := ChangeSet new.
    "/ Add all classes...
    self definition classNamesDo:[:name |
        container := self containerNameForClassNamed: name language: SmalltalkLanguage instance.
        container := self containerFor: container ifAbsent:[ nil ].
        container notNil ifTrue:[
           container readingFileDo:[:s|
               changeset addAll: (ChangeSet fromStream: s)
           ]
        ] ifFalse:[ 
            SCMPackageModelWarning newException
                messageText: 'Missing class container for ', name;
                parameter: (Array with: self with: name);
                raiseRequest.
        ].
    ].

    "/ Add all extensions...
    container := self containerNameForExtensions.
    container := self containerFor: container ifAbsent:[ nil ].
    definition extensionMethodNames notEmpty ifTrue:[ 
        container notNil ifTrue:[
           container readingFileDo:[:s|
               changeset addAll: (ChangeSet fromStream: s)
           ]
        ] ifFalse:[ 
            SCMPackageModelWarning newException
                messageText: 'Missing container for extensions';
                parameter: (Array with: self);
                raiseRequest.
        ].
    ] ifFalse:[ 
        container notNil ifTrue:[
           container readingFileDo:[:s|
               changeset addAll: (ChangeSet fromStream: s)
           ].
           SCMPackageModelWarning newException
               messageText: 'Project definition does not specify any extensions but extension container found';
               parameter: (Array with: self);
               raiseRequest.
        ]
    ].
    ^ changeset

    "Created: / 13-03-2014 / 22:38:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2014 / 22:47:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

definition
    "Returns a kind of ProjectDefinition object that keeps some metadata
     about the package, namely class names and list of extension methods.
     For virtual packages, return nil."

    "/ If virtual, return nil. Q: Shouldn't it be better to throw an exception?
    self isVirtual ifTrue:[ ^ nil ].

    definition isNil ifTrue:[
        | changeset |

        self containerForProjectDefinition readingFileDo:[:s|  
            definition := SCMAbstractPackageRevision::ProjectDefinition fromStream: s    
        ].
    ].
    ^ definition

    "Created: / 14-03-2014 / 10:04:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageRevision methodsFor:'accessing-private'!

childNamed: aString
   ^ self children 
        at: aString 
        ifAbsent: [ HGError raiseErrorString: ('No such child: %1' bindWith: aString) ]

    "Created: / 07-03-2014 / 23:01:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageRevision methodsFor:'private'!

classNames
    ^ OrderedCollection streamContents:[:s|
        self classNamesDo:[:e | s nextPut: e ]  
    ]

    "Created: / 14-03-2014 / 09:20:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageRevision methodsFor:'testing'!

isVirtual
    "Return true, if the package is virtual, i.e., there's no code in
     the package. False otherwise.
     
     Virtual packages serves merely as containers for nested packages"

    ^ virtual

    "Created: / 07-03-2014 / 23:01:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageRevision::AbbrevEntry methodsFor:'accessing'!

category
    ^ category
!

className
    ^ className
!

className:classNameArg fileName:fileNameArg category:categoryArg numClassInstVars:numClassInstVarsArg
    className := classNameArg.
    fileName := fileNameArg.
    category := categoryArg.
    numClassInstVars := numClassInstVarsArg.

    "Created: / 18-08-2011 / 14:18:30 / cg"
!

fileName
    ^ fileName
!

numClassInstVars
    ^ numClassInstVars

    "Created: / 18-08-2011 / 14:18:37 / cg"
! !

!SCMAbstractPackageRevision::ProjectDefinition class methodsFor:'documentation'!

documentation
"
    SCMAbstractPackageRevision::ProjectDefinition is kind of light-weight
    project definition in keeping meta-data about package.

    It has, to some extent, protocol compatible with ProjectDefinition

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        ProjectDefinition

"
! !

!SCMAbstractPackageRevision::ProjectDefinition class methodsFor:'instance creation'!

fromChangeSet:aChangeSet
    "Returns new definition based on data in changeset"

    ^ self new initializeFromChangeSet: aChangeSet

    "Created: / 14-03-2014 / 10:04:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromStream:aStream
    ^ self fromChangeSet: (ChangeSet fromStream: aStream)

    "Created: / 14-03-2014 / 10:04:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageRevision::ProjectDefinition methodsFor:'accessing'!

classNamesAndAttributes
    ^ classNamesAndAttributes
!

classNamesAndAttributes:anArray
    classNamesAndAttributes := anArray.
!

extensionMethodNames
    ^ extensionMethodNames ? #()

    "Created: / 14-03-2014 / 17:40:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionMethodNames:anArray
    extensionMethodNames := anArray.

    "Created: / 14-03-2014 / 17:40:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageRevision::ProjectDefinition methodsFor:'initialization'!

initializeFromChangeSet: aChangeSet
    aChangeSet do:[:change | 
        (change isMethodCodeChange and:[ change selector = 'classNamesAndAttributes' ]) ifTrue:[ 
            classNamesAndAttributes := Compiler evaluate: (change source copyFrom: 'classNamesAndAttributes' size + 1).
        ].
        (change isMethodCodeChange and:[ change selector = 'extensionMethodNames' ]) ifTrue:[ 
            extensionMethodNames := Compiler evaluate: (change source copyFrom: 'extensionMethodNames' size + 1).
        ].
    ].

    "Created: / 14-03-2014 / 10:08:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2014 / 17:35:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractPackageRevision::ProjectDefinition methodsFor:'private'!

classNamesAndAttributesDo: aBlock
    classNamesAndAttributes do:[:entry |
        |className attributes|

        entry isArray ifFalse:[
            className := entry.
            attributes := #().
        ] ifTrue:[
            className := entry first.
            attributes := entry copyFrom:2.
        ].
        aBlock value: className value: attributes
     ].

    "Created: / 14-03-2014 / 09:19:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classNamesDo: aBlock
    self classNamesAndAttributesDo:[:name :attributes | aBlock value: name ].

    "Created: / 14-03-2014 / 09:19:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

