"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#InlineObject
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Programming-Support'
!

!InlineObject class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    WARNING: InlineObjects are an experimental feature.

    InlineObjects are written as literals of the form:

    #{ 
        filedName1: value1.
        filedName2: value2.
        ...
        filedNameN: valueN.
    }

    For example:

    #{ 
        firstName: 'Peter'.
        lastName: 'Miller'.
        age: 25.
    }
        
    All inlineObjects will be instances of an anonymous subclass of me,
    and provide getter protocol for their fields (eg. firstName, lastName and age in the above example.
    InlineObjects are immutable (no setters).
"
! !

!InlineObject methodsFor:'printing & storing'!

storeOn:aStream
    aStream nextPutAll:'#{'.
    self class allInstVarNames keysAndValuesDo:[:i :nm |
        aStream nextPutAll:nm; nextPutAll:':'.
        (self instVarAt:i) storeOn:aStream.
        aStream nextPutAll:'. '.
    ].
    aStream nextPutAll:'}'.
! !

!InlineObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/InlineObject.st,v 1.4 2015-06-08 00:24:48 cg Exp $'
! !

