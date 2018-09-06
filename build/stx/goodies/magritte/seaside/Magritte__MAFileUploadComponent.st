"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAElementComponent subclass:#MAFileUploadComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MAFileUploadComponent comment:'I''m the MAFileDescription seaside component. With me user can upload files to the server. I provide a button for the user to browse their computer for files.'
!


!MAFileUploadComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAFileUploadComponent methodsFor:'actions'!

remove
	self value ifNotNil: [ self value finalize ].
	self value: nil
!

upload: aFile
	self value: (aFile isNil ifFalse: [
		self description kind new
			mimetype: aFile contentType;
			filename: aFile fileName;
			contents: aFile contents;
			yourself ])
! !

!MAFileUploadComponent methodsFor:'rendering'!

renderEditorOn: html
	self isMultipart
		ifTrue: [ self renderUploadOn: html ]
		ifFalse: [ self renderRemoveOn: html ]
!

renderRemoveOn: html
	html render: self value.
	html text: ' ('; render: self value filesize asFileSize; text: ') '.
	html submitButton on: #remove of: self
!

renderUploadOn: html
	html fileUpload
		id: self labelId;
		on: #upload of: self.
	html submitButton
		text: 'upload'
!

renderViewerOn: html
	html render: self value
! !

!MAFileUploadComponent methodsFor:'testing'!

hasLabelId
	^ self isReadonly not and: [ self isMultipart ]
!

isMultipart
	^ self value isNil or: [ self value isEmpty ]
! !

!MAFileUploadComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAFileUploadComponent.st,v 1.2 2009-08-14 20:25:44 cg Exp $'
! !
