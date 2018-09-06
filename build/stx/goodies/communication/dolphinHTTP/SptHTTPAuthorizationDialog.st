"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

DialogBox subclass:#SptHTTPAuthorizationDialog
	instanceVariableNames:'sitePresenter realmPresenter userPresenter passPresenter
		exception'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Support'
!


!SptHTTPAuthorizationDialog class methodsFor:'instance creation'!

showOnException: aSptHTTPNotAuthorized
	"
	self showOnException: (SptHTTPNotAuthorized new challenge: (SptHTTPChallenge fromChallengeString: 'Basic realm=Foo')) 
	"

	^(self on: false)
		exception: aSptHTTPNotAuthorized;
		createView: self defaultView;
		showModal
! !

!SptHTTPAuthorizationDialog class methodsFor:'constants'!

icon
	^Icon fromId: 45 in: ShellLibrary default
! !

!SptHTTPAuthorizationDialog methodsFor:'accessing'!

answer
	"Answer the model if the receiver was confirmed (with #apply, #ok) or nil otherwise"

	^self isConfirmed
!

exception: aSptHTTPNotAuthorized
	exception := aSptHTTPNotAuthorized
! !

!SptHTTPAuthorizationDialog methodsFor:'commands'!

cancel
	super cancel.
	exception removeCredentials
!

ok
	| ans |
	ans := super ok.
	exception username: userPresenter value password: passPresenter value.
	^ans
! !

!SptHTTPAuthorizationDialog methodsFor:'event handling'!

onViewOpened
	super onViewOpened.
	realmPresenter model: exception realm.
	sitePresenter model: exception site
! !

!SptHTTPAuthorizationDialog methodsFor:'initializing'!

createComponents
	super createComponents.
	sitePresenter := self add: TextPresenter new name: 'site'.
	realmPresenter := self add: TextPresenter new name: 'realm'.
	userPresenter := self add: TextPresenter new name: 'user'.
	passPresenter := self add: TextPresenter new name: 'pass'
! !

!SptHTTPAuthorizationDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPAuthorizationDialog.st,v 1.2 2011-09-23 18:54:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPAuthorizationDialog.st,v 1.2 2011-09-23 18:54:13 cg Exp $'
! !
