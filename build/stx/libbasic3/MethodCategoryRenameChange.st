"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

ClassChange subclass:#MethodCategoryRenameChange
	instanceVariableNames:'oldCategoryName newCategoryName'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!MethodCategoryRenameChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

!

documentation
"
    instances represent method-category-was-renamed changes (as done in the browser). 
"
! !

!MethodCategoryRenameChange methodsFor:'accessing'!

oldCategoryName:oldCatString newCategoryName:newCatString
    oldCategoryName := oldCatString.
    newCategoryName := newCatString.

    "Created: / 16.2.1998 / 13:10:20 / cg"
!

source
    ^ className , ' renameCategory:'  
                , oldCategoryName storeString , ' to:'
                , newCategoryName storeString

    "Modified: / 6.2.2000 / 02:34:25 / cg"
! !

!MethodCategoryRenameChange methodsFor:'printing & storing'!

printOn:aStream
    aStream 
        nextPutAll:className; 
        nextPutAll:' renameCategory:'; 
        nextPutAll:oldCategoryName asString storeString; 
        nextPutAll:' to:'; 
        nextPutAll:newCategoryName asString storeString

    "Modified: / 16.2.1998 / 13:36:28 / cg"
! !

!MethodCategoryRenameChange methodsFor:'testing'!

isMethodCategoryRenameChange
    ^ true
! !

!MethodCategoryRenameChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/MethodCategoryRenameChange.st,v 1.7 2014-02-19 13:05:31 cg Exp $'
! !

