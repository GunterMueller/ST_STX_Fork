"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Error subclass:#SptHTTPNotAuthorized
	instanceVariableNames:'target challenge site'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Exceptions'
!


!SptHTTPNotAuthorized class methodsFor:'instance creation'!

newForRealm: aString absoluteUri: aUrlString
	^(self new)
		challenge: (SptHTTPChallenge newBasicChallengeRealm: aString absoluteUri: aUrlString);
		site: aUrlString;
		yourself
! !

!SptHTTPNotAuthorized methodsFor:'accessing'!

challenge
	^challenge
!

challenge: aSptHTTPChallenge
	challenge := aSptHTTPChallenge
!

realm
	^challenge realm
!

site
	^site
!

site: aString
	site := aString
!

target
	^target
!

target: anObject
	target := anObject
! !

!SptHTTPNotAuthorized methodsFor:'displaying'!

_descriptionArguments
        "Answer the set of arguments to be substitued into the receiver's descriptionFormat
        String."

        ^super _descriptionArguments , (Array with: site asString "displayString")

    "Modified: / 23-09-2011 / 22:16:17 / cg"
!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'HTTP Not Authorized for %3'
! !

!SptHTTPNotAuthorized methodsFor:'operations'!

removeCredentials
	target notNil ifTrue: [target credentials: nil]
!

username: aString password: aString2
	target notNil 
		ifTrue: [target credentials: (challenge credentialsForUsername: aString password: aString2)]
! !

!SptHTTPNotAuthorized class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPNotAuthorized.st,v 1.3 2011-09-23 20:22:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPNotAuthorized.st,v 1.3 2011-09-23 20:22:15 cg Exp $'
! !
