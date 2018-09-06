"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCVersionNotification
	instanceVariableNames:'version ancestor repository changes'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!


!MCVersionNotification class methodsFor:'as yet unclassified'!

version: aVersion repository: aRepository
	^ self basicNew initializeWithVersion: aVersion repository: aRepository
! !

!MCVersionNotification methodsFor:'as yet unclassified'!

fromAddress
	^ 'monticello@beta4.com'
!

initializeWithVersion: aVersion repository: aRepository
	version := aVersion.
	repository := aRepository.
	ancestor := repository closestAncestorVersionFor: version info ifNone: []. 
	changes := ancestor
				ifNil: [#()]
				ifNotNil: [(version snapshot patchRelativeToBase: ancestor snapshot) 							operations asSortedCollection]
!

messageText
	^ String streamContents:
		[:s |
		s nextPutAll: 'Committed to repository: ', repository description; cr; cr.
		s nextPutAll: version summary.
		changes isEmpty ifFalse:
			[s cr; cr.
			s nextPutAll: '-----------------------------------------------------'; cr.
			s nextPutAll: 'Changes since ', ancestor info name, ':'; cr.
			changes do:
			[:ea |
			s cr; nextPutAll: ea summary; cr.
			s nextPutAll: ea sourceString]]]
!

messageTo: aString
	| message |
	message := MailMessage empty.
	message setField: 'from' toString: self fromAddress.
	message setField: 'to' toString: aString.
	message setField: 'subject' toString: '[MC] ', version info name.
	message body: (MIMEDocument contentType: 'text/plain' content: self messageText).
	^ message
!

notify: aString
	| message |
	message := self messageTo: aString.
	SMTPClient
		deliverMailFrom: message from
		to: (Array with: message to)
		text: message text
		usingServer: MailSender smtpServer
! !

!MCVersionNotification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionNotification.st,v 1.4 2012-09-11 21:30:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionNotification.st,v 1.4 2012-09-11 21:30:56 cg Exp $'
!

version_SVN
    ^ '§Id: MCVersionNotification.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
