"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPUser
	instanceVariableNames:'username password'
	classVariableNames:'Users'
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!


!SptHTTPUser class methodsFor:'instance creation'!

username: aUsernameString password: aPasswordString
	^self new username: aUsernameString password: aPasswordString
! !

!SptHTTPUser class methodsFor:'accessing'!

addRealm: aString host: aHostName username: aUsernameString password: aPasswordString
	self assert: [aString first ~= $" and: [aString last ~= $"]].
	self assert: [(aHostName beginsWith: 'http://') not].
	Users at: (Array with: aString with: aHostName)
		put: (self username: aUsernameString password: aPasswordString)
!

userFor: aString host: aHostName
	self assert: [(aHostName beginsWith: 'http://') not].
	^Users at: (Array with: aString with: aHostName) ifAbsent: []
!

users
	^Users
!

users: aLookupTable
	Users := aLookupTable
! !

!SptHTTPUser class methodsFor:'initializing'!

initialize
	"
	self initialize
	"

	
	Users := LookupTable new
!

uninitialize
	Users := nil
! !

!SptHTTPUser methodsFor:'accessing'!

password
	^password
!

username
	^username
!

username: aUsernameString password: aPasswordString
	username := aUsernameString.
	password := aPasswordString
! !

!SptHTTPUser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPUser.st,v 1.2 2011-09-23 18:55:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPUser.st,v 1.2 2011-09-23 18:55:14 cg Exp $'
! !

SptHTTPUser initialize!
