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

Object subclass:#DictionaryStack
	instanceVariableNames:'collection'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-helpers'
!

!DictionaryStack class methodsFor:'documentation'!

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

!DictionaryStack class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!DictionaryStack methodsFor:'* As yet uncategorized *'!

collect:aBlock
    ^ collection values collect:aBlock
! !

!DictionaryStack methodsFor:'adding & removing'!

atKey:aSymbol 
    
    ^ collection at:aSymbol
!

atKey:aSymbol ifAbsent:aBlock
    
    ^ collection at:aSymbol ifAbsent:aBlock
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

!DictionaryStack methodsFor:'enumerating'!

do:aBlock 
    "goes through all the objects in the collection"
    collection reverseDo:[:anAssociation | aBlock value:anAssociation value]
!

select:aBlock 
    ^ collection values select:aBlock
! !

!DictionaryStack methodsFor:'initialization'!

initialize
    collection := OrderedDictionary new.
! !

!DictionaryStack methodsFor:'queries'!

includes:aPackage
    ^ collection includes:aPackage
!

includesKey:aKey
    ^ (collection includesKey:aKey)
!

isEmpty
    ^ collection isEmpty
!

size
    ^ collection size
! !

!DictionaryStack class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/DictionaryStack.st,v 1.2 2006/01/10 09:25:12 cg Exp $'
! !