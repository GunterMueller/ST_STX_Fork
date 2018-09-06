"
 COPYRIGHT (c) 1995 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


"{ Package: 'stx:libbasic2' }"

TwoByteString variableWordSubclass:#GBEncodedString
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!GBEncodedString class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    OBSOLETE
        this class will vanish - its functionality has been replaced
        by the UnicodeString classes.

    GBEncodedString represents 16bit strings encoded in GB (GuoBiao),
    (with high bit set). This encoding is Mainland China's national standard.

    [author:]
        Claus Gittinger

    [see also:]
        JISEncodedString BIG5EncodedString
        TwoByteString String CharacterArray
        StringCollection
"
! !

!GBEncodedString class methodsFor:'initialization'!

initialize
    "initialize the class - private"

    self flags:(Behavior flagWords)

    "
     GBEncodedString initialize
    "

    "Created: 27.4.1996 / 13:12:17 / cg"
! !

!GBEncodedString methodsFor:'queries'!

encoding
    "return the strings encoding as a symbol. 
     Here, the constant symbol #gb is returned."

    ^ #gb

    "Created: 17.4.1996 / 15:44:26 / cg"
    "Modified: 27.4.1996 / 13:23:09 / cg"
! !

!GBEncodedString class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/GBEncodedString.st,v 1.8 2004-03-15 14:10:53 cg Exp $'
! !

GBEncodedString initialize!
