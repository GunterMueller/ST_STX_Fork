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

SCMAbstractRevisionInfo subclass:#HGRevisionInfo
	instanceVariableNames:'className changesetId changeset'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX'
!

SCMAbstractRevisionInfo subclass:#RevisionInfoNotExpanded
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGRevisionInfo
!

!HGRevisionInfo class methodsFor:'documentation'!

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
    A Mercurial-specific VersionInfo.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [see also:]
        VersionInfo
        CVSVersionInfo
"
! !

!HGRevisionInfo class methodsFor:'instance creation'!

readFrom: aStringOrStream onError: aBlock
    | s id |

    s := aStringOrStream readStream.
    s skipSeparators.
    "/ Hack for revision strings like:
    "/    'Path: stx/goodies/petitparser/compiler/tests/extras/PPCSmalltalkGrammarTests.st, Version: 1.0, User: jv, Time: 2015-07-30T06:59:45.505+01'
    s peek == $P ifTrue:[
        (s next: 4) = 'Path' ifTrue:[ 
            ^ RevisionInfoNotExpanded new.
        ].
    ].
    s peek ~~ $$ ifTrue:[^aBlock value].
    s next.
    s skipSeparators.
    s peek == $H ifTrue:[
        "Some rubbish $Header$?"
        (s next: 6) ~= 'Header' ifTrue:[ ^aBlock value ].
        id := HGChangesetId null.
    ] ifFalse:[
    s peek == $I ifTrue:[  
        "Some rubbish $Id$?"
        (s next: 2) ~= 'Id' ifTrue:[ ^aBlock value ].
        id := HGChangesetId null.
    ] ifFalse:[ 
        (s next: 10) ~= 'Changeset:' ifTrue:[ ^aBlock value ].
        s skipSeparators.
        s peek == $< ifTrue:[
            (s next: 14) ~= '<not expanded>' ifTrue:[ ^ aBlock value ].
            ^ RevisionInfoNotExpanded new.
        ] ifFalse:[
            id := HGChangesetId fromHexString: (s next: 40).    
        ].
    ]].
    ^self new changesetId: id

    "Created: / 20-11-2012 / 00:33:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-07-2015 / 07:03:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionInfo methodsFor:'accessing'!

changeset
    changeset isNil ifTrue:[ 
        | class wc repo |

        class := Smalltalk at: className asSymbol.
        class isNil ifTrue:[ ^ nil ].
        [
            wc := HGPackageWorkingCopy named: class package.
            wc notNil ifTrue:[
                repo := wc repository.
                changeset := repo @ changesetId.
            ].
        ] on: HGCommandError do:[
            "/ When there's any error, return a 'fake' changeset. There are cases 
            "/ when this may happen. for example when running St/X from a build 
            "/ tree on a machine which has no Mercurial installed.
            changeset := HGChangeset null copy.
            changeset setId: changesetId
        ].
    ].
    ^ changeset

    "Created: / 02-11-2015 / 17:15:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-06-2016 / 11:25:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetId
    ^ changesetId
!

changesetId:anHGNodeId
    changesetId := anHGNodeId.
!

className
    ^ className
!

className:something
    className := something.
! !

!HGRevisionInfo methodsFor:'accessing-properties'!

author
    ^ self user

    "Created: / 21-12-2011 / 23:09:54 / cg"
!

binaryRevision
    ^ changesetId printString

    "Modified: / 20-11-2012 / 10:26:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

binaryRevision: aString

    "Created: / 20-11-2012 / 10:15:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

date
    | cs |

    cs := self changeset.
    cs notNil ifTrue:[ ^ cs timestamp printStringFormat:'%y/%m/%d' ].
    ^ nil

    "Modified: / 02-11-2015 / 18:55:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileName
    | cls fn |

    className isNil ifTrue:[ ^ nil ].
    cls := Smalltalk at: className.
    cls notNil ifTrue:[
        fn := className , '.' , (cls programmingLanguage sourceFileSuffix)
    ] ifFalse:[
        fn := className , '.st'
    ].
    (fn includes: $:) ifTrue:[fn replaceAll:$: with:$_].
    ^fn.

    "Modified: / 04-12-2012 / 12:03:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryPathName

    ^ self fileName

    "Modified: / 20-11-2012 / 10:03:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision
    ^ changesetId printString

    "Modified: / 20-11-2012 / 10:15:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

symbolicVersionName
    ^ self revision

    "Created: / 01-12-2014 / 00:05:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

time
    | cs |

    cs := self changeset.
    cs notNil ifTrue:[ ^ cs timestamp printStringFormat:'%h:%m:%s' ].
    ^ nil

    "Modified: / 02-11-2015 / 18:56:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timezone
    "raise an error: must be redefined in concrete subclass(es)"

    ^ nil "Not known"

    "Modified: / 23-11-2011 / 13:54:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

user
    | cs |

    cs := self changeset.
    cs notNil ifTrue:[ ^ cs author ].
    ^ nil

    "Modified: / 02-11-2015 / 18:46:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionInfo methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'['.
    className printOn:aStream.
    aStream space.
    changesetId printOn:aStream.
    aStream nextPutAll:']'.

    "Modified: / 30-11-2012 / 22:13:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionInfo methodsFor:'private'!

properties
    ^ #(
        revision
        binaryRevision
        user
        date
        time
        fileName
        repositoryPathName
    )

    "Created: / 20-11-2012 / 10:01:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionInfo methodsFor:'queries'!

isNotExpanded
    ^ true

    "Created: / 01-05-2014 / 16:32:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionInfo::RevisionInfoNotExpanded class methodsFor:'documentation'!

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
    A Mercurial-specific revision info object representing
    Mercurial revision string placeholder:

    '$Changeset: <not expanded> $' 

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGRevisionInfo::RevisionInfoNotExpanded class methodsFor:'instance creation'!

readFrom: aStringOrStream onError: aBlock
    ^ HGRevisionInfo readFrom: aStringOrStream onError: aBlock

    "Created: / 20-11-2012 / 00:33:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-05-2014 / 16:28:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionInfo::RevisionInfoNotExpanded methodsFor:'queries'!

isNotExpanded
    ^ true

    "Created: / 01-05-2014 / 16:32:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionInfo class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

