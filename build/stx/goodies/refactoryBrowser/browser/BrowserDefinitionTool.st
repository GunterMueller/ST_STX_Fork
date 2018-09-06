"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserTextTool subclass:#BrowserDefinitionTool
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Browser-Code Tools'
!

BrowserDefinitionTool comment:'BrowserDefinitionTool is the CodeTool that edits class/namespace/shared variable definitions.'
!


!BrowserDefinitionTool class methodsFor:'resources'!

mainMenu
        "Tools.MenuEditor new openOnClass: self andSelector: #mainMenu"

        <resource: #menu>
        ^#(#Menu #(
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #_Accept 
                                        #defaultString: '&Accept' 
                                        #catalogID: #browser ) 
                                #nameKey: #Accept 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $s 
                                #shortcutModifiers: 2 ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #BrowseRe_ferencesDots 
                                        #defaultString: 'Browse Re&ferences...' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Selected Global Instance Variable References' 
                                #value: 
                                #action: ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #BrowseRea_dersDots 
                                        #defaultString: 'Browse Rea&ders...' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Selected Global Instance Variable Readers' 
                                #value: 
                                #action: ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #Browse_WritersDots 
                                        #defaultString: '&Browse Writers...' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Selected Global Instance Variable Writers' 
                                #value: 
                                #action: ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #_AddVariableDots 
                                        #defaultString: '&Add Variable...' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Add Instance Variable' 
                                #value: 
                                #action: ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #_RemoveVariableDots 
                                        #defaultString: '&Remove Variable...' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Remove Selected Instance Variable' 
                                #value: 
                                #action: ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #Refactor 
                                        #defaultString: 'Refactor' 
                                        #catalogID: #browser ) 
                                #nameKey: #refactorMenu 
                                #submenu: #(#Menu #(
                                                #(#MenuItem 
                                                        #rawLabel: 
                                                        #(#UserMessage 
                                                                #key: #Re_nameAsDots 
                                                                #defaultString: 'Re&name As...' 
                                                                #catalogID: #browser ) 
                                                        #nameKey: #'Rename Selected Instance Variable' 
                                                        #value: 
                                                        #action: 
                                                        #shortcutKeyCharacter: $N 
                                                        #shortcutModifiers: 3 ) 
                                                #(#MenuItem 
                                                        #rawLabel: 
                                                        #(#UserMessage 
                                                                #key: #Push_Up 
                                                                #defaultString: 'Push &Up' 
                                                                #catalogID: #browser ) 
                                                        #nameKey: #'Push Up Selected Instance Variable' 
                                                        #value: 
                                                        #action: ) 
                                                #(#MenuItem 
                                                        #rawLabel: 
                                                        #(#UserMessage 
                                                                #key: #Push_Down 
                                                                #defaultString: 'Push &Down' 
                                                                #catalogID: #browser ) 
                                                        #nameKey: #'Push Down Selected Instance Variable' 
                                                        #value: 
                                                        #action: ) 
                                                #(#MenuItem 
                                                        #rawLabel: 
                                                        #(#UserMessage 
                                                                #key: #CreateAccessors 
                                                                #defaultString: 'Create Accessors' 
                                                                #catalogID: #browser ) 
                                                        #nameKey: #'Create Selected Instance Variable Accessors' 
                                                        #value: 
                                                        #action: ) 
                                                #(#MenuItem 
                                                        #rawLabel: 
                                                        #(#UserMessage 
                                                                #key: #A_bstract 
                                                                #defaultString: 'A&bstract' 
                                                                #catalogID: #browser ) 
                                                        #nameKey: #'Abstract Selected Instance Variable' 
                                                        #value: 
                                                        #action: ) 
                                                #(#MenuItem 
                                                        #rawLabel: 
                                                        #(#UserMessage 
                                                                #key: #_Protect 
                                                                #defaultString: '&Protect' 
                                                                #catalogID: #browser ) 
                                                        #nameKey: #'Protect Selected Instance Variable' 
                                                        #value: 
                                                        #action: ) ) #(1 2 3 ) nil ) ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #_DoIt 
                                        #defaultString: '&Do it' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Do It' 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $d 
                                #shortcutModifiers: 2 
                                #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #doIt ) ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #Pri_ntIt 
                                        #defaultString: 'Pri&nt it' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Print It' 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $p 
                                #shortcutModifiers: 2 
                                #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #printIt ) ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #_InspectIt 
                                        #defaultString: '&Inspect it' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Inspect It' 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $q 
                                #shortcutModifiers: 2 
                                #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #inspectIt ) ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #_DebugIt 
                                        #defaultString: '&Debug it' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Debug It' 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $B 
                                #shortcutModifiers: 2 
                                #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #debugIt ) ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #Explain 
                                        #defaultString: 'Explain' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Explain Code' 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $E 
                                #shortcutModifiers: 2 ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #Cu_t 
                                        #defaultString: 'Cu&t' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Cut Selection' 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $X 
                                #shortcutModifiers: 2 
                                #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #cut ) ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #_Copy 
                                        #defaultString: '&Copy' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Copy Selection' 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $C 
                                #shortcutModifiers: 2 
                                #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #copy ) ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #_Paste 
                                        #defaultString: '&Paste' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Paste Selection' 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $V 
                                #shortcutModifiers: 2 
                                #labelImage: #(#ResourceRetriever #ToolbarIconLibrary #paste ) ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #_FindDots 
                                        #defaultString: '&Find...' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Find Text' 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $L 
                                #shortcutModifiers: 2 ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #_ReplaceDots 
                                        #defaultString: '&Replace...' 
                                        #catalogID: #browser ) 
                                #nameKey: #'Replace Text' 
                                #value: 
                                #action: 
                                #shortcutKeyCharacter: $R 
                                #shortcutModifiers: 2 ) 
                        #(#MenuItem 
                                #rawLabel: 
                                #(#UserMessage 
                                        #key: #Cancel 
                                        #defaultString: 'Cancel' 
                                        #catalogID: #browser ) 
                                #nameKey: #Cancel 
                                #value: 
                                #action: ) ) #(1 3 3 4 1 3 2 1 ) nil ) decodeAsLiteralArray
! !

!BrowserDefinitionTool methodsFor:'accepting'!

accept: aText from: aController 
	(self selectedClass notNil and: [self isMethodText: aText]) 
		ifTrue: [self compileMethodText: aText from: aController]
		ifFalse: [self compileObjectDefinitionText: aText from: aController]
! !

!BrowserDefinitionTool methodsFor:'actions'!

showBytesClassTemplate
	self text: self bytesClassTemplate
!

showClassTemplate
	self text: self classTemplate
!

showIndexedClassTemplate
	self text: self indexedClassTemplate
!

showNameSpaceTemplate
	self text: self nameSpaceTemplate
!

showSharedVariableTemplate
	self text: (self sharedVariableTemplateFor: self nameSpace)
! !

!BrowserDefinitionTool methodsFor:'tab APIs'!

isActive
	^self selectedBinding notNil
!

tabIcon
	^self binding value ifNotNil: [:object | object toolListIcon]
!

tabName
	^#Definition << #browser
! !

!BrowserDefinitionTool methodsFor:'testing'!

canDefineClassesAndNameSpaces
	^true
! !

!BrowserDefinitionTool methodsFor:'updating'!

binding
	^self selectedBinding
!

bytesClassTemplate
	^self classTemplateFor: #bytes
!

categoryForNewObject
	^self category isNil 
		ifTrue: 
			[self package isNil 
				ifTrue: 
					[self parcel isNil ifTrue: [#'Some Category'] ifFalse: [self parcel name]]
				ifFalse: [self package name]]
		ifFalse: [self category]
!

classTemplate
	^self classTemplateFor: #none
!

classTemplateFor: aSymbol 
	^'<1s> defineClass: #<2s>
	superclass: #{<3s>}
	indexedType: #<4s>
	private: false
	instanceVariableNames: ''<5s>''
	classInstanceVariableNames: ''''
	imports: ''''
	category: <6p>' 
		expandMacrosWithArguments: (OrderedCollection new
			add: self nameSpace unambiguousName;
			add: #NameOfClass << #browser >> 'NameOfClass';
			add: #NameOfSuperclass << #browser >> 'NameOfSuperclass';
			add: aSymbol;
			add: (aSymbol == #bytes
				ifTrue: ['']
				ifFalse: [(#instVarName1InstVarName2 << #browser >> 'instVarName1 instVarName2')]);
			add: '';
			yourself)
!

defaultTemplate
	^(self pundle isNil and: [self parcel isNil]) 
		ifTrue: [self nameSpace definition asText]
		ifFalse: [self template]
!

definitionOfBinding: binding 
	| ns |
	binding isForGeneral ifFalse: [^binding value definition asText].
	ns := Root whoDefinesBinding: binding.
	ns isNil ifTrue: [^''].
	^ns definitionOfStatic: binding
!

indexedClassTemplate
	^self classTemplateFor: #objects
!

nameSpaceTemplate
	^'<1s> defineNameSpace: #<2s>
	private: false
	imports: ''
			private Smalltalk.*
			''
	category: <3p>' 
		expandMacrosWith: self nameSpace unambiguousName
		with: #NameSpace << #browser >> 'NameSpace'
		with: self categoryForNewObject asString
!

sharedVariableTemplateFor: aNameSpace 

	^'<1s> defineSharedVariable: #<2s>
	private: false
	constant: false
	category: <3p>
	initializer: ''Array new: 5'''
		expandMacrosWith: aNameSpace unambiguousName
		with: #NameOfBinding << #browser >> 'NameOfBinding'
		with: (self protocol isNil 
				ifTrue: [self categoryForNewObject]
				ifFalse: [self protocol]) asString
!

template
	^self classTemplate
!

updateContents
	| binding |
	binding := self binding.
	self text: (binding isNil 
				ifTrue: [self defaultTemplate]
				ifFalse: [self definitionOfBinding: binding])
! !

!BrowserDefinitionTool class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/BrowserDefinitionTool.st,v 1.1 2009-10-02 00:42:36 cg Exp $'
! !
