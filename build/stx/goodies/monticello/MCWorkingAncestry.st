"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCAncestry subclass:#MCWorkingAncestry
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!

MCWorkingAncestry comment:'The interim record of ancestry for a working copy, gets merged version added to the ancestry, and is used to create the VersionInfo when the working copy becomes a version. '
!


!MCWorkingAncestry methodsFor:'accessing'!

ancestors:aCollection
    ancestors := aCollection.
! !

!MCWorkingAncestry methodsFor:'as yet unclassified'!

addAncestor: aNode
	ancestors _ (self ancestors reject: [:each | aNode hasAncestor: each])
		copyWith: aNode
!

addStepChild: aVersionInfo
	stepChildren _ stepChildren copyWith: aVersionInfo
!

date
	^ Date today
!

infoWithName: nameString message: messageString
        ^ MCVersionInfo
                name: nameString
                id: UUID new
                message: messageString
                date: Date today
                time: Time now
                author: ((OperatingSystem getFullUserNameFromID: OperatingSystem getUserID) reject:[:c|c isSeparator])
                ancestors: ancestors asArray
                stepChildren: self stepChildren asArray

    "Modified: / 23-08-2011 / 07:43:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
	^ '<working copy>'
!

summary
	^ 'Ancestors: ', self ancestorString
! !

!MCWorkingAncestry class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCWorkingAncestry.st,v 1.3 2012-09-11 21:31:23 cg Exp $'
! !

