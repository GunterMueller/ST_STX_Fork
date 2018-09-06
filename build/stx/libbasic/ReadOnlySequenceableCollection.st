"
 COPYRIGHT (c) 2001 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

SequenceableCollection subclass:#ReadOnlySequenceableCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Abstract'
!

!ReadOnlySequenceableCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    Abstract class which blocks some write access operations.

    See concrete subclasses (such as Interval).

    [author:]
        Claus Gittinger

    [see also:]
        SequenceableCollection
"
! !

!ReadOnlySequenceableCollection class methodsFor:'queries'!

isAbstract
    ^ self == ReadOnlySequenceableCollection
! !

!ReadOnlySequenceableCollection methodsFor:'blocked access'!

add:newObject
    "{ Pragma: +optSpace }"

    "catch add message - cannot add elements"

    self error:('elements cannot be added to ' , self classNameWithArticle)

    "
     (1 to:10) add:11   
     (1 to:10) addAll:#(11 12)   
     (1 to:10) remove:9    
     (1 to:10) remove:9 ifAbsent:nil   
     (1 to:10) removeAll:#(1 4)
     (1 to:10) atAllPut:1
    "
!

at:index put:anObject
    "{ Pragma: +optSpace }"

    "catch at:put: message - cannot store elements"

    self error:('you cannot store into ' , self classNameWithArticle)

    "
     (1 to:10) at:5 put:10   
     (1 to:10) atAllPut:5   
     (1 to:10) replaceFrom:1 to:4 with:#(10 20 30 40)  
    "

    "Created: / 31.10.2001 / 10:05:36 / cg"
    "Modified: / 31.10.2001 / 10:09:19 / cg"
!

remove:anObject ifAbsent:exceptionalValue
    "{ Pragma: +optSpace }"

    "catch remove message - cannot remove elements"

    self error:('elements cannot be removed from ' , self classNameWithArticle)

    "
     (1 to:10) remove:9 ifAbsent:nil  
    "
! !

!ReadOnlySequenceableCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/ReadOnlySequenceableCollection.st,v 1.4 2005/06/27 10:24:03 cg Exp $'
!

version_SVN
    ^ '$Id: ReadOnlySequenceableCollection.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !



