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
"{ Package: 'stx:libjavascript' }"

IdentityDictionary subclass:#JavaScriptObject
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptObject class methodsFor:'documentation'!

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
! !

!JavaScriptObject class methodsFor:'instance creation'!

newWith:slotNames values:slotValues
    |newObj|

    newObj := self new.
    slotNames with:slotValues do:[:k :v |
        newObj at:k put:v
    ].
    ^ newObj
! !

!JavaScriptObject methodsFor:'hashing'!

hash
    ^ self identityHash
! !

!JavaScriptObject methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'{'.
    self notEmpty ifTrue:[
        aStream cr.
        self keysAndValuesDo:[:k :v |
            aStream nextPutAll:'    '.
            k printOn:aStream.
            aStream nextPutAll:': '.
            v printOn:aStream.
            aStream cr.
        ].
    ].
    aStream nextPutAll:'}'.
! !

!JavaScriptObject methodsFor:'slot access'!

doesNotUnderstand:aMessage
    |na value|

    na := aMessage numArgs.
    na == 0 ifTrue:[
        ^ self at:(aMessage selector) ifAbsent:[super doesNotUnderstand:aMessage].
    ].
    na == 1 ifTrue:[
        aMessage selector first isLetter ifTrue:[
            value := aMessage arguments at:1.
            self at:(aMessage selector copyButLast:1) asSymbol put:value.
            ^ value
        ]
    ].
    ^ super doesNotUnderstand:aMessage
! !

!JavaScriptObject methodsFor:'special accessing'!

thisContext
    ^ thisContext sender
! !

!JavaScriptObject class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptObject.st,v 1.4 2013-04-25 13:10:19 stefan Exp $'
! !

