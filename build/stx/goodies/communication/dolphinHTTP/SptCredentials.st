"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptCredentials
	instanceVariableNames:'user challenge'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptCredentials comment:'SptCredentials

I am the credentials that supply the value of an ''Authorization'' http header.

Typically an instance is created by sending a <SptHTTPChallenge> the #credentialsFor: message.

Note: While ''Basic'' Authorization could be implemented more simply, creating the <SptCredentials> from the <SptHTTPChallenge> is necessary for ''Digest'' Authorization.

See <http://www.ietf.org/rfc/rfc2617.txt> for details on HTTP Authentication.

Instance Variables

	user		SptHTTPUser
	challenge		SptHTTPChallenge'
!


!SptCredentials class methodsFor:'public'!

forUser: aSptHTTPUser
	^self new user: aSptHTTPUser
!

icon
	^Icon fromId: 45 in: ShellLibrary default
! !

!SptCredentials methodsFor:'public'!

challenge
	^challenge
!

challenge: aSptDigestCredentials
	challenge := aSptDigestCredentials
!

httpHeaderValue
	"Answer the <String> header that authorizes the user in response to the server's challenge"

	^self subclassResponsibility
!

password
	^user password
!

realm
	^challenge realm
!

user
	^user
!

user: aSptHTTPUser
	user := aSptHTTPUser
!

username
	^user username
! !

!SptCredentials methodsFor:'testing'!

isInProtectionSpace: aUrlString
	"Answer whether it is valid to use (or reuse) these credential for aUrlString"

	^self subclassResponsibility
! !

!SptCredentials class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptCredentials.st,v 1.1 2011-09-23 13:43:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptCredentials.st,v 1.1 2011-09-23 13:43:26 cg Exp $'
! !
