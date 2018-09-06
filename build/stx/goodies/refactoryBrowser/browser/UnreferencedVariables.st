"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserApplicationModel subclass:#UnreferencedVariables
	instanceVariableNames:'classVarList instVarList classList label spec classVars instVars'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!


!UnreferencedVariables class methodsFor:'instance creation'!

pullUpInstVar
	^self new spec: #pullUpInstVarSpec
!

references
	^self new spec: #notReadAndWrittenSpec
!

unreferenced
	^self new spec: #windowSpec
! !

!UnreferencedVariables class methodsFor:'interface specs'!

notReadAndWrittenSpec
	"UIPainter new openOnClass: self andSelector: #notReadAndWrittenSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Variables not read AND written' 
			#min: #(#Point 40 20 ) 
			#bounds: #(#Rectangle 311 258 896 497 ) 
			#isEventDriven: true ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 25 0 -3 0.5 -2 1 ) 
					#name: #classList 
					#model: #classList ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0.5 25 0 -2 1 -33 1 ) 
					#name: #instVarList 
					#model: #instVarList ) 
				#(#DividerSpec 
					#layout: #(#LayoutFrame -1 0.5 0 0 1 0.5 0 1 ) 
					#orientation: #vertical ) 
				#(#LabelSpec 
					#layout: #(#Point 2 2 ) 
					#label: 'Class:' ) 
				#(#LabelSpec 
					#layout: #(#LayoutOrigin 2 0.5 2 0 ) 
					#label: 'Instance Variables:' ) 
				#(#ActionButtonSpec 
					#layout: #(#LayoutFrame 2 0.5 -31 1 -2 1 -3 1 ) 
					#name: #browseInstVarRefs 
					#model: #browseInstVarRefs 
					#label: 'Browse references...' 
					#defaultable: true ) ) ) )
!

pullUpInstVarSpec
	"UIPainter new openOnClass: self andSelector: #pullUpInstVarSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Instance variables defined in all subclasses' 
			#min: #(#Point 40 20 ) 
			#bounds: #(#Rectangle 244 223 829 462 ) 
			#isEventDriven: true ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 25 0 -3 0.5 -2 1 ) 
					#name: #classList 
					#model: #classList ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0.5 25 0 -2 1 -33 1 ) 
					#name: #instVarList 
					#model: #instVarList ) 
				#(#DividerSpec 
					#layout: #(#LayoutFrame -1 0.5 0 0 1 0.5 0 1 ) 
					#orientation: #vertical ) 
				#(#LabelSpec 
					#layout: #(#Point 2 2 ) 
					#label: 'Class:' ) 
				#(#LabelSpec 
					#layout: #(#LayoutOrigin 2 0.5 2 0 ) 
					#label: 'Instance Variables:' ) 
				#(#ActionButtonSpec 
					#layout: #(#LayoutFrame 2 0.5 -31 1 -2 1 -3 1 ) 
					#name: #pullUpInstVar 
					#model: #pullUpInstVar 
					#label: 'Pull up variable' 
					#defaultable: true ) ) ) )
!

windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Unreferenced variables' 
			#bounds: #(#Rectangle 196 168 789 648 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 25 0 -3 0.5 -32 1 ) 
					#name: #classList 
					#model: #classList ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0.5 25 0 -2 1 -33 0.5 ) 
					#name: #instVarList 
					#model: #instVarList ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0.5 25 0.5 -2 1 -32 1 ) 
					#name: #classVarList 
					#model: #classVarList ) 
				#(#DividerSpec 
					#layout: #(#LayoutFrame -1 0.5 0 0 1 0.5 0 1 ) 
					#orientation: #vertical ) 
				#(#LabelSpec 
					#layout: #(#Point 2 2 ) 
					#label: 'Class:' ) 
				#(#LabelSpec 
					#layout: #(#LayoutOrigin 2 0.5 2 0 ) 
					#label: 'Instance Variables:' ) 
				#(#LabelSpec 
					#layout: #(#LayoutOrigin 2 0.5 2 0.5 ) 
					#label: 'Class Variables:' ) 
				#(#ActionButtonSpec 
					#layout: #(#LayoutFrame 2 0 -30 1 -3 0.5 -2 1 ) 
					#name: #removeAllVariables 
					#model: #removeAllVariables 
					#label: 'Remove unreferenced variables' 
					#defaultable: true ) 
				#(#ActionButtonSpec 
					#layout: #(#LayoutFrame 2 0.5 -31 0.5 -2 1 -3 0.5 ) 
					#name: #removeInstVar 
					#model: #removeInstVar 
					#label: 'Remove variable' 
					#defaultable: true ) 
				#(#DividerSpec 
					#layout: #(#LayoutFrame 0 0.5 -1 0.5 0 1 1 0.5 ) ) 
				#(#ActionButtonSpec 
					#layout: #(#LayoutFrame 2 0.5 -30 1 -2 1 -2 1 ) 
					#name: #removeClassVar 
					#model: #removeClassVar 
					#label: 'Remove variable' 
					#defaultable: true ) ) ) )
! !

!UnreferencedVariables methodsFor:'accessing'!

addClassVar: aName for: aClass 
	(classVars at: aClass ifAbsentPut: [Set new]) add: aName
!

addInstVar: aName for: aClass 
	(instVars at: aClass ifAbsentPut: [Set new]) add: aName
!

classVarCount
	^classVars inject: 0 into: [:count :each | count + each size]
!

editor
	^self
!

instVarCount
	^instVars inject: 0 into: [:count :each | count + each size]
!

label
	^label
!

label: anObject
	^label := anObject
!

openEditor
	self isEmpty ifFalse: [self editor openInterface: (spec isNil
				ifTrue: [#windowSpec]
				ifFalse: [spec])]
!

preferredSpec
	^spec isNil
		ifTrue: [super preferredSpec]
		ifFalse: [spec]
!

problemCount
	^self instVarCount + self classVarCount
! !

!UnreferencedVariables methodsFor:'actions'!

browseInstVarRefs
	RefactoringBrowser
		openOnEnvironment: (BrowserEnvironment new instVarRefsTo: self instVarList selection
				in: self classList selection)
!

pullUpInstVar
	self handleError: 
			[(PullUpInstanceVariableRefactoring variable: self instVarList selection
				class: self classList selection) execute]
!

removeAllVariables
	self removeAllClassVariables;
		removeAllInstanceVariables;
		removeVariablesForSelectedClass
!

removeClassVar
	| class variable |
	class := classList selection.
	variable := classVarList selection.
	self handleError: 
			[(RemoveClassVariableRefactoring variable: variable class: class) execute].
	(classVars at: class ifAbsent: [#()]) remove: variable ifAbsent: [].
	(classVars at: class ifAbsent: [#()]) isEmpty
		ifTrue: [classVars removeKey: class].
	self classVarList list remove: variable.
	self changedClass
!

removeInstVar
	| class variable |
	class := classList selection.
	variable := instVarList selection.
	self handleError: 
			[(RemoveInstanceVariableRefactoring variable: variable class: class) execute].
	(instVars at: class ifAbsent: [#()]) remove: variable ifAbsent: [].
	(instVars at: class ifAbsent: [#()]) isEmpty
		ifTrue: [instVars removeKey: class].
	self instVarList list remove: variable.
	self changedClass
! !

!UnreferencedVariables methodsFor:'aspects'!

classList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^classList isNil
		ifTrue:
			[classList := SelectionInList new]
		ifFalse:
			[classList]
!

classVarList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^classVarList isNil
		ifTrue:
			[classVarList := SelectionInList new]
		ifFalse:
			[classVarList]
!

instVarList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^instVarList isNil
		ifTrue:
			[instVarList := SelectionInList new]
		ifFalse:
			[instVarList]
! !

!UnreferencedVariables methodsFor:'copying'!

copyEmpty
	^self copy initialize
! !

!UnreferencedVariables methodsFor:'initialize-release'!

initialize
	super initialize.
	classList := SelectionInList new.
	classVarList := SelectionInList new.
	instVarList := SelectionInList new.
	instVars := Dictionary new.
	classVars := Dictionary new.
	classList selectionIndexHolder onChangeSend: #changedClass to: self.
	classVarList selectionIndexHolder onChangeSend: #changedClassVar to: self.
	instVarList selectionIndexHolder onChangeSend: #changedInstVar to: self
!

spec: aSymbol 
	spec := aSymbol
! !

!UnreferencedVariables methodsFor:'interface opening'!

postBuildWith: aBuilder 
	| classes |
	super postBuildWith: aBuilder.
	classes := Set withAll: instVars keys.
	classes addAll: classVars keys.
	self classList
		list: (List withAll: (classes asSortedCollection: [:a :b | a name < b name]))
!

postOpenWith: aBuilder 
	super postOpenWith: aBuilder.
	self setLabel: label
! !

!UnreferencedVariables methodsFor:'private'!

removeAllClassVariables
	| class |
	class := self classList selection.
	classVarList list do: 
			[:each | 
			self handleError: 
					[(RemoveClassVariableRefactoring variable: each class: class) execute]]
!

removeAllInstanceVariables
	| class |
	class := self classList selection.
	instVarList list do: 
			[:each | 
			self handleError: 
					[(RemoveInstanceVariableRefactoring variable: each class: class) execute]]
!

removeVariablesForSelectedClass
	| class |
	class := self classList selection.
	classVars removeKey: class ifAbsent: [].
	instVars removeKey: class ifAbsent: [].
	self classList list remove: class ifAbsent: [].
	self changedClass
!

variablesIn: aDictionary 
	| class |
	class := self classList selection.
	^class isNil
		ifTrue: [#()]
		ifFalse: [(aDictionary at: class ifAbsent: [#()]) asSortedCollection]
! !

!UnreferencedVariables methodsFor:'testing'!

isEmpty
	^classVars isEmpty & instVars isEmpty
! !

!UnreferencedVariables methodsFor:'updating'!

changedClass
	classList selection isNil
		ifTrue: [self disable: #removeAllVariables]
		ifFalse: [self enable: #removeAllVariables].
	self instVarList list: (self variablesIn: instVars).
	self classVarList list: (self variablesIn: classVars)
!

changedClassVar
	classVarList selection isNil
		ifTrue: [self disable: #removeClassVar]
		ifFalse: [self enable: #removeClassVar]
!

changedInstVar
	instVarList selection isNil
		ifTrue: [self disableAll: #(#removeInstVar #browseInstVarRefs #pullUpInstVar)]
		ifFalse: [self enableAll: #(#removeInstVar #browseInstVarRefs #pullUpInstVar)]
! !

!UnreferencedVariables class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/UnreferencedVariables.st,v 1.6 2003-09-23 10:43:21 cg Exp $'
! !
