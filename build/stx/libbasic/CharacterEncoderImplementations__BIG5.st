"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic' }"

"{ NameSpace: CharacterEncoderImplementations }"

TwoByteEncoder subclass:#BIG5
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!BIG5 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!BIG5 class methodsFor:'mapping'!

mapFileURL1_relativePathName
    ^ 'OBSOLETE/EASTASIA/OTHER/BIG5.TXT'
! !

!BIG5 methodsFor:'private'!

newString:size
    ^ BIG5EncodedString new:size
! !

!BIG5 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/CharacterEncoderImplementations__BIG5.st,v 1.3 2004/03/09 21:59:35 cg Exp $'
! !



