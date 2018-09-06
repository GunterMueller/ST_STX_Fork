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
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

ClassCategoryReader subclass:#ClassCategoriesReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!

!ClassCategoriesReader class methodsFor:'documentation'!

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
    This class was added to allow fileIn of Dolphin code.
    It is not required for normal operation of the system.

    [author:]
        Claus Gittinger

    [see also:]
        ClassCategoryReader
"
! !

!ClassCategoriesReader methodsFor:'fileIn'!

fileInFrom:aStream notifying:requestor passChunk:passChunk single:oneChunkOnly silent:beSilent
    "read class category-chunks from the input stream, aStream.
     Since ST/X only supports one category, only the first category is stored."

    |aString isFirst|

    isFirst := true.
    [true] whileTrue:[
        aStream atEnd ifTrue:[^self].
        aString := aStream nextChunk.
        aStream skipSeparators.
        aString size == 0 ifTrue:[^self].

        isFirst ifTrue:[
            myClass category:aString asSymbol.
            isFirst := false.
        ].
    ]

    "Modified: / 6.6.1998 / 01:57:06 / cg"
! !

!ClassCategoriesReader methodsFor:'private'!

class:aClass
    myClass := aClass.
! !

!ClassCategoriesReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__ClassCategoriesReader.st,v 1.2 2011-10-01 11:16:13 vrany Exp $'
!

version_SVN
    ^ '§Id: Dolphin__ClassCategoriesReader.st,v 1.1 2011/07/05 18:09:55 cg Exp §'
! !
