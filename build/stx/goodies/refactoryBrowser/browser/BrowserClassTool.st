"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserTextTool subclass:#BrowserClassTool
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Code Tools'
!

BrowserClassTool comment:'BrowserClassTool is the CodeTool that edits class definitions.'
!


!BrowserClassTool class methodsFor:'resources'!

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
				#rawLabel: '&variables' 
				#submenu: #(#Menu #(
						#(#MenuItem 
							#rawLabel: 'add &instance variable...' 
							#value: #addInstVar ) 
						#(#MenuItem 
							#rawLabel: 'add &class variable...' 
							#value: #addClassVar ) 
						#(#MenuItem 
							#rawLabel: 'references...' 
							#value: #browseInstVarRefs ) 
						#(#MenuItem 
							#rawLabel: 'readers...' 
							#value: #browseInstVarReaders ) 
						#(#MenuItem 
							#rawLabel: 'writers...' 
							#value: #browseInstVarWriters ) 
						#(#MenuItem 
							#rawLabel: 'rename as...' 
							#value: #renameVariable ) 
						#(#MenuItem 
							#rawLabel: '&remove' 
							#value: #removeVariable ) 
						#(#MenuItem 
							#rawLabel: 'push &up' 
							#value: #pushUpVariable ) 
						#(#MenuItem 
							#rawLabel: 'push &down' 
							#value: #pushDownVariable ) 
						#(#MenuItem 
							#rawLabel: 'create accessors' 
							#value: #createAccessors ) 
						#(#MenuItem 
							#rawLabel: 'abstract' 
							#value: #abstractVariable ) 
						#(#MenuItem 
							#rawLabel: 'protect/concrete' 
							#value: #protectInstVar ) ) #(2 3 2 2 3 ) nil ) ) 
			#(#MenuItem 
				#rawLabel: '&hardcopy' 
				#value: #hardcopy ) ) #(2 1 3 3 2 1 1 ) nil ) decodeAsLiteralArray
! !

!BrowserClassTool methodsFor:'accepting'!

accept: aText from: aController 
	| class |
	class := self defineClass: aText from: aController.
	class isBehavior ifTrue: [codeModel setClass: class]
!

defineClass: aText from: aController 
        ^Cursor wait showWhile: 
                        [| oldClass class name |
                        oldClass := self navigator className isNil
                                                ifTrue: [Object]
                                                ifFalse: [self navigator selectedClass].
                        class := Object errorSignal handle: 
                                                        [:ex | 
                                                        ex willProceed
                                                                ifTrue: 
                                                                        [(Dialog confirm: ex description , '\Do you want to continue?' withCRs
                                                                                for: self interfaceWindow) ifTrue: [ex proceed]]
                                                                ifFalse: [Dialog warn: ex description for: self interfaceWindow].
                                                        ex returnWith: nil]
                                                do: 
                                                        [oldClass subclassDefinerClass evaluate: aText string
                                                                notifying: aController
                                                                logged: true].
                        class isBehavior
                                ifTrue: 
                                        [name := class isMeta ifTrue: [class soleInstance name] ifFalse: [class name].
                                        self navigator newClassList: (Array with: name).
                                        class]
                                ifFalse: [nil]]
! !

!BrowserClassTool methodsFor:'menu'!

noSelectionItems
	^#('do it' 'print it' 'inspect it' 'push up' 'push down' 'rename as...' 'remove' 'create accessors' 'abstract' 'protect/concrete')
!

otherMenuItems
	^(self isEditing or: [self selectedClass isNil]) 
		ifTrue: [#('variables')]
		ifFalse: 
			[self isInstVarSelected 
				ifTrue: [#()]
				ifFalse: 
					[self isClassVarSelected 
						ifTrue: [#('references...' 'readers...' 'writers...' 'protect/concrete')]
						ifFalse: 
							[#('references...' 'readers...' 'writers...' 'protect/concrete' 'rename as...' 'remove' 'push up' 'push down' 'create accessors' 'abstract')]]]
! !

!BrowserClassTool methodsFor:'refactorings'!

abstractVariable
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: [self abstractInstVar: string].
	(self isClassVar: string) ifTrue: [self abstractClassVar: string]
!

addClassVar
	self navigator addClassVarIn: self selectedClass.
	self updateContents
!

addInstVar
	self navigator addInstVarIn: self selectedClass.
	self updateContents
!

createAccessors
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: [self createAccessorsForInstVar: string].
	(self isClassVar: string) 
		ifTrue: [self createAccessorsForClassVar: string]
!

protectInstVar
	| string |
	string := self selectedText.
	self protectInstVar: string
!

pushDownVariable
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: 
			[self performRefactoring: (PushDownInstanceVariableRefactoring variable: string
						class: self selectedClass)].
	(self isClassVar: string) ifTrue: 
			[self performRefactoring: (PushDownClassVariableRefactoring variable: string asSymbol
						class: self nonMetaClass)]
!

pushUpVariable
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: [self pushUpInstVar: string].
	(self isClassVar: string) ifTrue: [self pushUpClassVar: string]
!

removeVariable
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: 
			[self performRefactoring: (RemoveInstanceVariableRefactoring variable: string class: self selectedClass)].
	(self isClassVar: string) ifTrue: 
			[self performRefactoring: (RemoveClassVariableRefactoring variable: string asSymbol
						class: self nonMetaClass)]
!

renameVariable
	| string |
	string := self selectedText.
	(self isInstVar: string) ifTrue: [self renameInstVar: string].
	(self isClassVar: string) ifTrue: [self renameClassVar: string].
	self updateContents
! !

!BrowserClassTool methodsFor:'testing'!

isClassVar: aString 
	^self isMeta not and: [self selectedClass classVarNames includes: aString asSymbol]
!

isClassVarSelected
	^self isClassVar: self selectedText
!

isEnabled
	^self category notNil
!

isInstVar: aString 
	^self selectedClass instVarNames includes: aString
!

isInstVarSelected
	^self isInstVar: self selectedText
! !

!BrowserClassTool methodsFor:'updating'!

updateContents
	self text: (self selectedClass isNil
			ifTrue: [self category isNil
					ifTrue: ['' asText]
					ifFalse: [(Class template: self category) asText]]
			ifFalse: [self selectedClass definition asText])
! !

!BrowserClassTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/BrowserClassTool.st,v 1.8 2003-09-23 10:44:45 cg Exp $'
! !
