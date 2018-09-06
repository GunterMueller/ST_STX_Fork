"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

SptCredentials subclass:#SptBasicCredentials
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!


!SptBasicCredentials class methodsFor:'public'!

makeUserIdFor: aUsernameString password: aPasswordString
        | outStream |

        Smalltalk isSmalltalkX ifTrue:[
            ^ Base64Coder encode:(aUsernameString , ':' , aPasswordString)
        ] ifFalse:[
            outStream := String writeStream.
            Base64Encoder new 
                encode: (aUsernameString , ':' , aPasswordString) asByteArray readStream
                to: outStream.
            ^outStream contents
        ].

    "Modified: / 23-09-2011 / 14:06:10 / cg"
! !

!SptBasicCredentials methodsFor:'public'!

httpHeaderValue
	"Answer the <String> header that authorizes the user in response to the server's challenge"

	^'Basic ' , (self class makeUserIdFor: self username password: self password)
! !

!SptBasicCredentials methodsFor:'testing'!

isInProtectionSpace: aUrlString
	"Answer whether it is valid to use (or reuse) these credential for aUrlString"

	^challenge isInProtectionSpace: aUrlString
! !

!SptBasicCredentials class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptBasicCredentials.st,v 1.1 2011-09-23 13:41:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptBasicCredentials.st,v 1.1 2011-09-23 13:41:47 cg Exp $'
! !
