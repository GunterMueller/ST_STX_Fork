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

Object subclass:#PackagesInstalled
	instanceVariableNames:'collection workingPackage'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-helpers'
!

!PackagesInstalled class methodsFor:'documentation'!

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

!PackagesInstalled class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
!

workingPackage:aPackage
    ^ self new workingPackage:aPackage
! !

!PackagesInstalled methodsFor:'* As yet uncategorized *'!

allPackages
    ^ collection copy at:#workinPackage put:workingPackage; yourself.
!

select:aBlock 
    ^ self allPackages values select:aBlock
! !

!PackagesInstalled methodsFor:'accessing'!

workingPackage
    "return the value of the instance variable 'currentPackage' (automatically generated)"

    ^ workingPackage
!

workingPackage:something
    "set the value of the instance variable 'currentPackage' (automatically generated)"

    workingPackage := something.
! !

!PackagesInstalled methodsFor:'adding & removing'!

atKey:aSymbol 
    
    ^ collection at:aSymbol
!

pop
    collection removeKey:collection last key
!

pop:aNumber 

    aNumber timesRepeat:[ self pop].
!

popAt:aKey 
    collection removeKey:aKey.
!

popAt:aKey ifAbsent:aBlock
    collection removeKey:aKey ifAbsent:aBlock.
!

pull
    ^ self pop
!

pull:aNumber
    | col |
    col :=  collection last:aNumber.
    self pop:aNumber.
    ^ col
!

pullAt:aKey 
    ^ collection removeKey:aKey.
!

pullAt:aKey ifAbsent:aBlock
    ^ collection removeKey:aKey ifAbsent:aBlock.
!

push:aPackage 
    
    ^ collection at:aPackage name put:aPackage
!

removeKey:aSymbol 
    
    ^ collection removeKey:aSymbol
!

top
    ^ collection last value
! !

!PackagesInstalled methodsFor:'enumerating'!

do:aBlock 
    "goes through all the objects in the collection"
    aBlock value:workingPackage.
    collection reverseDo:[:anAssociation | aBlock value:anAssociation value]
! !

!PackagesInstalled methodsFor:'initialization'!

initialize
    collection := OrderedDictionary new.
! !

!PackagesInstalled methodsFor:'queries'!

includes:aPackage
    ^ (aPackage == workingPackage or:[(collection includesValue:aPackage)]).
!

includesKey:aKey
    ^ (collection includesKey:aKey)
!

isEmpty
    ^ collection isEmpty
! !

!PackagesInstalled class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/PackagesInstalled.st,v 1.2 2006-01-10 09:32:15 cg Exp $'
! !
