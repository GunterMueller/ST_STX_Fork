"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

Collection subclass:#PrerequisiteCollection
	instanceVariableNames:'collection'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Prerequisite'
!

!PrerequisiteCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!PrerequisiteCollection class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!PrerequisiteCollection methodsFor:'adding & removing'!

add:anObject 
    ^ collection add:anObject
!

addFirst:anObject 
    ^ collection addFirst:anObject
!

remove:anObject ifAbsent:aBlock 
    ^ collection remove:anObject ifAbsent:aBlock 
!

removeIdentical:arg1 ifAbsent:aBlock 
    ^ collection removeIdentical:arg1 ifAbsent:aBlock 
!

removeLast
    ^ collection removeLast
! !

!PrerequisiteCollection methodsFor:'enumerating'!

do:aOneArgBlock 
    ^ collection do:aOneArgBlock
!

reverseDo:aOneArgBlock 
    ^ collection reverseDo:aOneArgBlock
! !

!PrerequisiteCollection methodsFor:'evaluation'!

evaluate
    self do:[:aPrerequisite |
        aPrerequisite evaluate.
    ].

! !

!PrerequisiteCollection methodsFor:'growing'!

grow:anInteger 
    ^ collection grow:anInteger 
! !

!PrerequisiteCollection methodsFor:'initialize'!

initialize
    collection := OrderedCollection new.
! !

!PrerequisiteCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/PrerequisiteCollection.st,v 1.2 2006/01/10 09:25:29 cg Exp $'
! !