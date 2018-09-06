"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserTextTool subclass:#ClassCommentTool
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Code Tools'
!

ClassCommentTool comment:'ClassCommentTool is the CodeTool that edits class comments.'
!


!ClassCommentTool class methodsFor:'resources'!

menu
	"MenuEditor new openOnClass: self andSelector: #menu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: '&find...' 
				#value: #find ) 
			#(#MenuItem 
				#rawLabel: '&replace...' 
				#value: #replace ) 
			#(#MenuItem 
				#rawLabel: '&undo' 
				#value: #undo ) 
			#(#MenuItem 
				#rawLabel: '&copy' 
				#value: #copySelection ) 
			#(#MenuItem 
				#rawLabel: 'cu&t' 
				#value: #cut ) 
			#(#MenuItem 
				#rawLabel: '&paste' 
				#value: #paste ) 
			#(#MenuItem 
				#rawLabel: '&do it' 
				#value: #doIt ) 
			#(#MenuItem 
				#rawLabel: 'pri&nt it' 
				#value: #printIt ) 
			#(#MenuItem 
				#rawLabel: '&inspect it' 
				#value: #inspectIt ) 
			#(#MenuItem 
				#rawLabel: '&accept' 
				#value: 
				#accept:from: ) 
			#(#MenuItem 
				#rawLabel: 'cancel' 
				#value: #cancelText ) 
			#(#MenuItem 
				#rawLabel: 'default co&mment' 
				#value: #generateDefaultComment ) 
			#(#MenuItem 
				#rawLabel: '&hardcopy' 
				#value: #hardcopy ) ) #(2 1 3 3 2 1 1 ) nil ) decodeAsLiteralArray
! !

!ClassCommentTool methodsFor:'accepting'!

accept: aText from: aController 
	self nonMetaClass comment: aText string.
	self text: aText
! !

!ClassCommentTool methodsFor:'private'!

defaultComment
	| commentStream class vars typer |
	class := self nonMetaClass.
	typer := (RefactoryTyper new)
				runOn: class;
				yourself.
	commentStream := WriteStream on: String new.
	commentStream
		emphasis: #bold;
		nextPutAll: class name;
		nextPutAll: ' has not been commented.';
		emphasis: nil;
		nextPutAll: '  The comment should state the purpose of the class and also explain any unobvious aspects of the implementation.';
		cr;
		cr.
	self printSubclassResponsibilitiesFor: class on: commentStream.
	vars := class instVarNames.
	vars isEmpty 
		ifFalse: 
			[commentStream
				nextPutAll: 'Instance Variables:';
				cr.
			self 
				printVariables: vars
				types: typer
				on: commentStream].
	vars := class classVarNames.
	vars isEmpty 
		ifFalse: 
			[commentStream
				nextPutAll: 'Class Variables:';
				cr.
			self 
				printVariables: vars
				types: typer
				on: commentStream].
	^commentStream contents
!

generateDefaultComment
	self textNoChange: self defaultComment
!

printSubclassResponsibilitiesFor: class on: commentStream 
	| protocols selectors |
	selectors := class whichSelectorsReferTo: 'subclassResponsibility' asSymbol.
	selectors isEmpty ifTrue: [^self].
	commentStream
		nextPutAll: 'Subclasses must implement the following messages:';
		cr.
	protocols := (selectors
				collect: [:each | BrowserEnvironment new whichProtocolIncludes: each in: class])
					asSet asSortedCollection.
	selectors := selectors asSortedCollection.
	protocols do: 
			[:protocol | 
			commentStream tab;
				nextPutAll: protocol;
				cr.
			selectors do: 
					[:sel | 
					protocol == (BrowserEnvironment new whichProtocolIncludes: sel in: class)
						ifTrue: 
							[commentStream tab;
								tab;
								nextPutAll: sel;
								cr]]].
	commentStream cr
!

printVariables: vars types: aRefactoryTyper on: commentStream 
	vars asSortedCollection do: 
			[:each | 
			commentStream
				tab;
				nextPutAll: each;
				tab;
				nextPut: $<.
			aRefactoryTyper printTypeFor: each on: commentStream.
			commentStream
				nextPutAll: '>	description of ';
				nextPutAll: each;
				cr].
	commentStream cr
! !

!ClassCommentTool methodsFor:'testing'!

isEnabled
	^self nonMetaClass notNil
! !

!ClassCommentTool methodsFor:'updating'!

updateContents
        | tmp |
        self className isNil ifTrue: [^self text: '' asText].
        Smalltalk isSmalltalkX ifTrue:[
            " but should be ok for others as well "
            tmp := (self nonMetaClass comment ? '') asText.
        ] ifFalse:[
            tmp := self nonMetaClass comment asText.
        ].
        tmp isEmpty ifFalse: [^self text: tmp].
        self text: self defaultComment
! !

!ClassCommentTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/ClassCommentTool.st,v 1.7 2003-09-23 10:46:35 cg Exp $'
! !
