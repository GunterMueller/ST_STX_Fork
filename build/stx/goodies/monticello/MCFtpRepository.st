"{ Package: 'stx:goodies/monticello' }"

MCFileBasedRepository subclass:#MCFtpRepository
	instanceVariableNames:'host directory user password connection'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Repositories'
!


!MCFtpRepository class methodsFor:'instance creation'!

host: host directory: directory user: user password: password
	^ self new
		host: host;
		directory: directory;
		user: user;
		password: password
! !

!MCFtpRepository class methodsFor:'queries'!

creationTemplate
	^
'MCFtpRepository
	host: ''modules.squeakfoundation.org''
	directory: ''mc''
	user: ''squeak''
	password: ''squeak'''
	
!

description
	^ 'FTP'
!

templateCreationSelector
	^ #host:directory:user:password: 
! !

!MCFtpRepository methodsFor:'accessing'!

directory: dirPath
	directory := dirPath
!

host: hostname
	host := hostname
!

password: passwordString
	password := passwordString
!

user: userString
	user := userString
! !

!MCFtpRepository methodsFor:'as yet unclassified'!

clientDo: aBlock
        | client |

        NVTClient loginFailedSignal handle:[:ex |
            | answer |

            answer := Dialog 
                requestPassword:('FTP-Login failed (',ex description,'\\Try again with password:') withCRs
                initialAnswer:password.
            answer isEmptyOrNil ifTrue:[ AbortOperationRequest raise].
            password := answer.
            ex restart
        ] do:[
            client := FTPClient openOnHostNamed: host.
            client loginUser: user password: password.
            directory isEmpty ifFalse: [client changeDirectoryTo: directory].
        ].
        ^ [aBlock value: client] ensure: [client close]
!

parseDirectoryListing: aString
	| stream files line tokens |
	stream := aString readStream.
	files := OrderedCollection new.
	[stream atEnd] whileFalse:
		[line := stream nextLine.
		tokens := line findTokens: ' '.
		tokens size > 2 ifTrue: [files add: tokens last]].
	^ files
! !

!MCFtpRepository methodsFor:'displaying'!

displayString
    ^ self description

    "Created: / 14-09-2010 / 23:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 25-11-2011 / 11:29:31 / cg"
! !

!MCFtpRepository methodsFor:'required'!

allFileNames
	^ self clientDo:
		[:client |
		self parseDirectoryListing: client getDirectory]
!

description
	^ 'ftp://', user, '@', host, '/', directory
!

readStreamForFileNamed: aString do: aBlock
	| stream |
	^ self clientDo:
		[:client |
		client binary.
		stream := RWBinaryOrTextStream on: String new.
		stream nextPutAll: (client getFileNamed: aString).
		aBlock value: stream reset]
!

writeStreamForFileNamed: aString replace: ignoreBoolean do: aBlock
	| stream |
	stream := RWBinaryOrTextStream on: String new.
	aBlock value: stream.
	self clientDo:
		[:client |
		client binary.
		client putFileStreamContents: stream reset as: aString]
! !

!MCFtpRepository class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCFtpRepository.st,v 1.7 2014-02-12 15:38:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCFtpRepository.st,v 1.7 2014-02-12 15:38:13 cg Exp $'
!

version_SVN
    ^ '$Id: MCFtpRepository.st,v 1.7 2014-02-12 15:38:13 cg Exp $'
! !

