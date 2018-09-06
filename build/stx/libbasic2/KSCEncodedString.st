"
 COPYRIGHT (c) 1997 by eXept Software AG 
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.


"

"{ Package: 'stx:libbasic2' }"

TwoByteString variableWordSubclass:#KSCEncodedString
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!KSCEncodedString class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG 
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

    KSCEncodedString represents 16bit strings encoded in KSC.
    This encoding is used in korea.

    [author:]
        Claus Gittinger

    [see also:]
        JISEncodedString BIG5EncodedString GBEncodedString
        TwoByteString String CharacterArray
        StringCollection
"
! !

!KSCEncodedString class methodsFor:'initialization'!

initialize
    "initialize the class - private"

    self flags:(Behavior flagWords)

    "
     KSCEncodedString initialize
    "

    "Created: 30.6.1997 / 15:35:52 / cg"
! !

!KSCEncodedString methodsFor:'queries'!

encoding
    "return the strings encoding as a symbol. 
     Here, the constant symbol #ksc is returned."

    ^ #ksc

    "Modified: 30.6.1997 / 15:35:23 / cg"
! !

!KSCEncodedString class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/KSCEncodedString.st,v 1.2 2004-03-15 14:10:55 cg Exp $'
! !

KSCEncodedString initialize!
