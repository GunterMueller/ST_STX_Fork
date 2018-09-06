"{ Package: 'stx:goodies/monticello' }"

MCWriteOnlyRepository subclass:#MCSmtpRepository
	instanceVariableNames:'email'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!


!MCSmtpRepository class methodsFor:'as yet unclassified'!

morphicConfigure
	| address |
	address := UIManager default request: 'Email address:' translated.
	^ address isEmpty ifFalse: [self new emailAddress: address]
! !

!MCSmtpRepository class methodsFor:'queries'!

description
	^ 'SMTP'
! !

!MCSmtpRepository methodsFor:'accessing'!

description
	^ 'mailto://', email
! !

!MCSmtpRepository methodsFor:'as yet unclassified'!

bodyForVersion: aVersion
	^ String streamContents:
		[ :s |
		s nextPutAll: 'from version info:'; cr; cr.
		s nextPutAll:  aVersion info summary]
!

emailAddress: aString
	email := aString	
!

messageForVersion: aVersion
	| message data |
	message := MailMessage empty.
	message setField: 'from' toString: MailSender userName.
	message setField: 'to' toString: email.
	message setField: 'subject' toString: (self subjectForVersion: aVersion). 

	message body:
		(MIMEDocument
			contentType: 'text/plain'
			content: (self bodyForVersion: aVersion)).

	"Prepare the gzipped data"
	data := RWBinaryOrTextStream on: String new.
	aVersion fileOutOn: data.
	message addAttachmentFrom: data reset withName: aVersion fileName.
	^ message
! !

!MCSmtpRepository methodsFor:'printing & storing'!

basicStoreVersion: aVersion
	MailSender sendMessage: (self messageForVersion: aVersion)
! !

!MCSmtpRepository methodsFor:'queries'!

subjectForVersion: aVersion
	^ '[Package] ', aVersion info name
! !

!MCSmtpRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSmtpRepository.st,v 1.5 2014-02-12 14:53:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSmtpRepository.st,v 1.5 2014-02-12 14:53:31 cg Exp $'
!

version_SVN
    ^ '$Id: MCSmtpRepository.st,v 1.5 2014-02-12 14:53:31 cg Exp $'
! !

