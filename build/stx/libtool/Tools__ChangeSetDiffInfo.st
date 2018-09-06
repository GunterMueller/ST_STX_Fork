"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Object subclass:#ChangeSetDiffInfo
	instanceVariableNames:'specBase specA specB specMerge diffset same'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Diff'
!

!ChangeSetDiffInfo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ChangeSetDiffInfo class methodsFor:'instance creation'!

specA: specA specB: specB

    ^self specA: specA specB: specB specBase: nil

    "Created: / 20-03-2012 / 11:17:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

specA: specA specB: specB specBase: specBase

    ^self specA: specA specB: specB specBase: specBase specMerge: nil

    "Created: / 20-03-2012 / 11:19:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

specA: specA specB: specB specBase: specBase specMerge: specMerge

    ^self new 
        specA: specA; 
        specB: specB; 
        specBase: specBase;
        specMerge: specMerge

    "Created: / 20-03-2012 / 11:19:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffInfo methodsFor:'accessing'!

diffset
    ^ diffset
!

same
    ^ same
!

specA
    ^ specA
!

specA:something
    specA := something.
!

specB
    ^ specB
!

specB:something
    specB := something.
!

specBase
    ^ specBase
!

specBase:something
    specBase := something.
!

specMerge
    ^ specMerge
!

specMerge:something
    specMerge := something.
!

specMergeFile
    ^ specMerge file

    "Created: / 20-03-2012 / 15:04:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffInfo methodsFor:'queries'!

isDiff2

    ^specBase isNil

    "Created: / 20-03-2012 / 10:22:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDiff3

    ^specBase notNil

    "Created: / 20-03-2012 / 10:23:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMerge

    ^
"/    specBase notNil and:[
        specMerge notNil
"/    ]

    "Created: / 20-03-2012 / 10:23:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffInfo methodsFor:'read / write'!

read
    "Reads changesets and generates diffset and 'same' change list"

    | diff csA csB csBase |
    diff := ChangeSetDiff new.
    ProgressNotification notify: 'Reading changes...'  progress: nil.
    csA := specA changeSet.
    csB := specB changeSet.
    csBase := (specBase notNil ifTrue:[specBase changeSet] ifFalse:[nil]).
    ProgressNotification notify: 'Diffing...'  progress: nil.
    diff
        versionA: csA
        versionB: csB
        versionBase: csBase.
    diffset := diff diffset.
    same := diff same.

    "Created: / 19-03-2012 / 22:10:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-11-2013 / 11:59:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__ChangeSetDiffInfo.st,v 1.1 2014-02-05 18:58:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__ChangeSetDiffInfo.st,v 1.1 2014-02-05 18:58:15 cg Exp $'
! !

