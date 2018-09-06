"{ Package: 'stx:goodies/magritte/seaside' }"
!

!Magritte::MABooleanDescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MACheckboxComponent with: MASelectListComponent with: MARadioGroupComponent
! !

!Magritte::MAClassDescription class methodsFor:'*magritte-seaside-accessing-defaults'!

defaultComponentClasses
	^ Array with: MATextInputComponent
! !

!Magritte::MAColorDescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MAColorComponent
! !

!Magritte::MAContainer class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MAContainerComponent
! !

!Magritte::MADateDescription class methodsFor:'*magritte-seaside'!

defaultComponentClasses
	^ Array with: MADateInputComponent with: MADateSelectorComponent
! !

!Magritte::MADescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MAUndefinedComponent
! !

!Magritte::MADescription class methodsFor:'*magritte-seaside-defaults'!

defaultReportColumnClasses
	^ Array with: MADescribedColumn
! !

!Magritte::MADurationDescription class methodsFor:'*magritte-seaside'!

defaultComponentClasses
	^ Array with: MATextInputComponent
! !

!Magritte::MAExternalFileModel methodsFor:'*magritte-seaside-accessing'!

urlFor: aRenderingContext
	^ self baseUrl isNil
		ifTrue: [ super urlFor: aRenderingContext ]
		ifFalse: [ self baseUrl , '/' , (self location reduce: [ :a :b | a , '/' , b ]) , '/' , self filename ]
! !

!Magritte::MAExternalFileModel methodsFor:'*magritte-seaside-accessing'!

urlOn: html
	^ self baseUrl isNil
		ifTrue: [ super urlOn: html ]
		ifFalse: [ self baseUrl , '/' , (self location reduce: [ :a :b | a , '/' , b ]) , '/' , self filename ]
! !

!Magritte::MAFileDescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MAFileUploadComponent
! !

!Magritte::MAFileModel methodsFor:'*magritte-seaside-rendering-mimetypes'!

renderDefaultOn: html
	"/ <mimetype: #isApplication priority: 0>

	html anchor
		url: (self urlOn: html);
		with: self filename
! !

!Magritte::MAFileModel methodsFor:'*magritte-seaside-rendering-mimetypes'!

renderImageOn: html
	"/ <mimetype: #isImage priority: 0>

	html image url: (self urlOn: html)
! !

!Magritte::MAFileModel methodsFor:'*magritte-seaside-rendering-mimetypes'!

renderMediaOn: html
	"/ <mimetype: #isVideo priority: 0>
	"/ <mimetype: #isAudio priority: 0>

	| url |
	url := self urlOn: html.
	(html tag: 'object')
		attributeAt: 'data' put: url;
		attributeAt: 'type' put: self mimetype;
		with: [
			(html tag: 'param')
				attributeAt: 'name' put: 'src';
				with: url.
			(html tag: 'param')
				attributeAt: 'name' put: 'scale';
				with: 'aspect'.
			(html tag: 'param')
				attributeAt: 'name' put: 'autoplay';
				with: 'false'.
			(html tag: 'embed')
				attributeAt: 'src' put: url;
				attributeAt: 'scale' put: 'aspect';
				attributeAt: 'autoplay' put: 'false';
				attributeAt: 'type' put: self mimetype;
				with: [ self renderDefaultOn: html ] ]
! !

!Magritte::MAFileModel methodsFor:'*magritte-seaside-rendering'!

renderOn: html
	"Renders a download link of the receiver."

	html anchor
		title: (String streamContents: [ :stream |
			stream nextPutAll: self filename; nextPutAll: ' ('.
			stream nextPutAll: self filesize asFileSize; nextPutAll: ', '.
			stream nextPutAll: self mimetype; nextPut: $) ]);
		url: (self urlFor: html context);
		with: self filename
! !

!Magritte::MAFileModel methodsFor:'*magritte-seaside-rendering-mimetypes'!

renderTextOn: html
	"/ <mimetype: #isText priority: 0>

	| stream |
	stream := self contents readStream.
	html preformatted: [
		html text: (stream next: 800).
		stream atEnd
			ifFalse: [ html text: '...' ] ]
! !

!Magritte::MAFileModel methodsFor:'*magritte-seaside-accessing'!

urlFor: aRenderContext
	"Answer a link to a request handler for the given file."

	^ (aRenderContext registry
		urlForRequestHandler: (MAFileModelHandler on: self))
			displayString
! !

!Magritte::MAFileModel methodsFor:'*magritte-seaside-accessing'!

urlOn: html
	self deprecatedApi: 'Use #urlFor: with the rendering context instead.'.
	^ self urlFor: html context
! !

!Magritte::MAMemoDescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MATextAreaComponent
! !

!Magritte::MAMultipleErrors methodsFor:'*magritte-seaside-rendering'!

renderOn: html
	html unorderedList: [
		self collection
			do: [ :each | html listItem: each ] ]
! !

!Magritte::MAMultipleOptionDescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MAMultiselectListComponent with: MACheckboxGroupComponent with: MAListCompositonComponent
! !

!Magritte::MANumberDescription class methodsFor:'*magritte-seaside'!

defaultComponentClasses
	^ Array with: MATextInputComponent with: MARangeComponent
! !

!Magritte::MAPasswordDescription class methodsFor:'*magritte-seaside-default'!

defaultComponentClasses
	^ Array with: MATextPasswordComponent with: MAVerifiedPasswordComponent with: MATextInputComponent
! !

!Magritte::MASingleOptionDescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MASelectListComponent with: MARadioGroupComponent
! !

!Magritte::MAStringDescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MATextInputComponent
! !

!Magritte::MATableDescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MATableComponent
! !

!Magritte::MATimeDescription class methodsFor:'*magritte-seaside'!

defaultComponentClasses
	^ Array with: MATimeInputComponent with: MATimeSelectorComponent
! !

!Magritte::MATimeStampDescription class methodsFor:'*magritte-seaside'!

defaultComponentClasses
	^ Array with: MATimeStampInputComponent
! !

!Magritte::MAToManyRelationDescription class methodsFor:'*magritte-seaside-accessing-defaults'!

defaultComponentClasses
	^ Array with: MAOneToManyComponent
! !

!Magritte::MAToManyScalarRelationDescription class methodsFor:'*magritte-seaside-accessing-defaults'!

defaultComponentClasses
	^ Array with: MAOneToManyScalarComponent
! !

!Magritte::MAToManyScalarRelationDescription class methodsFor:'*magritte-seaside-accessing-defaults'!

defaultReportColumnClasses
	^ Array with: MADescribedScalarColumn
! !

!Magritte::MAToOneRelationDescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MAExternalEditorComponent with: MAInternalEditorComponent
! !

!Magritte::MATokenDescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClasses
	^ Array with: MATextInputComponent
! !

!WAComponent methodsFor:'as yet unclassified'!

renderOn: aRenderer
	self decorationChainDo: [:ea | ea renderWithContext: aRenderer context]
! !

!WAComponent methodsFor:'*magritte-seaside'!

isMagritteContainer
	^ false
! !
