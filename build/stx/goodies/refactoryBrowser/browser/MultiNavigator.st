"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

ClassSelectorNavigator subclass:#MultiNavigator
	instanceVariableNames:'environmentList'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Navigator'
!

MultiNavigator comment:'MultiNavigator is the special environment for MultiEnvironment. It''s basically a hack for the "Method defined in all subclasses, but not in superclass" lint rule.

Instance Variables:
	environmentList	<SelectionInList on: String>	the different environments we can browse'
!


!MultiNavigator class methodsFor:'interface specs'!

verticalWindowSpec
	"UIPainter new openOnClass: self andSelector: #verticalWindowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Navigator' 
			#min: #(#Point 40 20 ) 
			#bounds: #(#Rectangle 357 443 572 852 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 2 0 -2 1 -1 0.333333 ) 
					#name: #environmentList 
					#flags: 15 
					#model: #environmentList ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 1 0.333333 -2 1 26 0.333333 ) 
					#name: #categoryHolder 
					#model: #categoryHolder 
					#menu: #categoryMenu 
					#isReadOnly: true ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 28 0.333333 -2 1 -25 0.666666 ) 
					#name: #classList 
					#model: #classList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedClass 
						#requestValueChangeSelector: #changeRequest ) 
					#menu: #classMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#RadioButtonSpec 
					#layout: #(#LayoutFrame 3 0 -22 0.666666 0 0.5 -3 0.666666 ) 
					#name: #instance 
					#model: #meta 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedMeta 
						#requestValueChangeSelector: #changeRequest ) 
					#label: 'instance' 
					#select: false ) 
				#(#RadioButtonSpec 
					#layout: #(#LayoutFrame 2 0.5 -22 0.666666 -22 1 -3 0.666666 ) 
					#name: #class 
					#model: #meta 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedMeta 
						#requestValueChangeSelector: #changeRequest ) 
					#label: 'class' 
					#select: true ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 1 0.666666 -2 1 26 0.666666 ) 
					#name: #protocolHolder 
					#model: #protocolHolder 
					#menu: #protocolMenu 
					#isReadOnly: true ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 28 0.666666 -2 1 -2 1 ) 
					#name: #selectorList 
					#model: #selectorList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedSelector 
						#requestValueChangeSelector: #changeRequest ) 
					#menu: #selectorMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#GroupBoxSpec 
					#layout: #(#LayoutFrame 2 0 -23 0.666666 -2 1 -1 0.666666 ) ) 
				#(#ActionButtonSpec 
					#layout: #(#LayoutFrame -22 1 -23 0.666666 -2 1 -3 0.666666 ) 
					#name: #clearToClass 
					#model: #clearToClass 
					#label: '^' ) ) ) )
!

windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Navigator' 
			#bounds: #(#Rectangle 314 332 902 483 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 2 0 2 0 -1 0.333333 -2 1 ) 
					#name: #environmentList 
					#flags: 15 
					#model: #environmentList ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 1 0.333333 2 0 -1 0.666666 27 0 ) 
					#name: #categoryHolder 
					#model: #categoryHolder 
					#menu: #categoryMenu 
					#isReadOnly: true ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 1 0.333333 29 0 -1 0.666666 -25 1 ) 
					#name: #classList 
					#model: #classList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedClass 
						#requestValueChangeSelector: #changeRequest ) 
					#menu: #classMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#RadioButtonSpec 
					#layout: #(#LayoutFrame 3 0.333333 -22 1 0 0.5 -3 1 ) 
					#name: #instance 
					#model: #meta 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedMeta 
						#requestValueChangeSelector: #changeRequest ) 
					#label: 'instance' 
					#select: false ) 
				#(#RadioButtonSpec 
					#layout: #(#LayoutFrame 2 0.5 -22 1 -22 0.666666 -3 1 ) 
					#name: #class 
					#model: #meta 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedMeta 
						#requestValueChangeSelector: #changeRequest ) 
					#label: 'class' 
					#select: true ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 1 0.666666 2 0 -2 1 27 0 ) 
					#name: #protocolHolder 
					#model: #protocolHolder 
					#menu: #protocolMenu 
					#isReadOnly: true ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 1 0.666666 29 0 -2 1 -2 1 ) 
					#name: #selectorList 
					#model: #selectorList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedSelector 
						#requestValueChangeSelector: #changeRequest ) 
					#menu: #selectorMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#GroupBoxSpec 
					#layout: #(#LayoutFrame 2 0.333333 -23 1 -1 0.666666 -2 1 ) ) 
				#(#ActionButtonSpec 
					#layout: #(#LayoutFrame -22 0.666666 -23 1 -2 0.666666 -3 1 ) 
					#name: #clearToClass 
					#model: #clearToClass 
					#label: '^' ) ) ) )
! !

!MultiNavigator methodsFor:'accessing-browser'!

spec: verticalBoolean 
	| spec |
	spec := verticalBoolean
				ifTrue: [self class verticalWindowSpec]
				ifFalse: [self class windowSpec].
	self categoryList list: RefactoryBrowserPlatformSupport systemOrganization categories asList.
	^spec
! !

!MultiNavigator methodsFor:'aspects'!

environmentList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^environmentList isNil
		ifTrue:
			[environmentList := SelectionInList new]
		ifFalse:
			[environmentList]
! !

!MultiNavigator methodsFor:'changing'!

changedEnvironment
	self protocolHolder value: nil.
	self environment selectEnvironment: self environmentList selection.
	self setState: NavigatorState new updateClasses: true.
	self changed: #category with: self category
! !

!MultiNavigator methodsFor:'initialize-release'!

initialize
	super initialize.
	self environmentList selectionIndexHolder onChangeSend: #changedEnvironment to: self
! !

!MultiNavigator methodsFor:'interface opening'!

postBuildWith: aBuilder 
	|l|

	l := self environment environments asList.
	l sortWith: [:a :b | a displayString < b displayString].
	self environmentList list: l.
	super postBuildWith: aBuilder
! !

!MultiNavigator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/MultiNavigator.st,v 1.7 2003-09-23 10:43:23 cg Exp $'
! !
