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


"{ NameSpace: Squeak }"

ClassCategoryReader subclass:#ClassCommentReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!ClassCommentReader class methodsFor:'documentation'!

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
    This class was added to allow fileIn of Squeak code.
    It is not required for normal operation of the system.

    [author:]
        Claus Gittinger

    [see also:]
        ClassCategoryReader
"
! !

!ClassCommentReader methodsFor:'fileIn'!

fileInFrom:aStream notifying:requestor passChunk:passChunk single:oneChunkOnly silent:beSilent
    "read method-chunks from the input stream, aStream; compile them
     and add the methods to the class defined by the class-instance var;
     errors and notifications are passed to requestor.
     If passChunk is true, chunks are given to the requestor,
     via a #source: message, allowing it to open a view showing any
     erronous source code.
     If oneChunkOnly is true, the fileIn is finished after the first chunk.
     The beSilent argument controls output to the transcript, if its true or
     false. If its nil, output is controlled by the Smalltalk>>silenLoading setting."

    |aString compiler|

    aStream atEnd ifFalse:[
        aString := aStream nextChunk.
        aString size ~~ 0 ifTrue:[
            passChunk ifTrue:[
                requestor source:aString
            ].
            myClass comment:aString.
"/            compiler := myClass compilerClass.
"/            compiler evaluate:aString.
        ].
    ]

    "Modified: / 6.6.1998 / 01:57:06 / cg"
! !

!ClassCommentReader methodsFor:'private'!

class:aClass category:aCategory changeStamp:aStamp
    myClass := aClass.
    myCategory := aCategory

    "Created: / 6.6.1998 / 01:47:56 / cg"
! !

!ClassCommentReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/SQ_ClassCommentReader.st,v 1.7 1999-09-02 15:17:30 cg Exp $'
! !
