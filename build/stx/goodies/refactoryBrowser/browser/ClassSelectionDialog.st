"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserDialog subclass:#ClassSelectionDialog
	instanceVariableNames:'environmentEditor'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

ClassSelectionDialog comment:'ClassSelectionDialog is a dialog interface for selecting classes to perform some action on (e.g., rewrite tool, browsing, etc.).

Instance Variables:
	environmentEditor       <EnvironmentEditor>     the part that is actually selecting the classes'
!


!ClassSelectionDialog class methodsFor:'instance creation'!

onEnvironment: anEnvironment 
	| dialog |
	dialog := self new.
	dialog environmentEditor selectedEnvironment: anEnvironment copy.
	^dialog
! !

!ClassSelectionDialog class methodsFor:'interface specs'!

selectorWindowSpec
	"UIPainter new openOnClass: self andSelector: #selectorWindowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Method Selection' 
			#min: #(#Point 40 20 ) 
			#bounds: #(#Rectangle 232 631 668 953 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#SubCanvasSpec 
					#layout: #(#LayoutFrame 0 0 0 0 0 1 -40 1 ) 
					#name: #environmentEditor 
					#flags: 0 
					#majorKey: #EnvironmentEditor 
					#minorKey: #windowSpec 
					#clientKey: #environmentEditor ) 
				#(#ActionButtonSpec 
					#layout: #(#AlignmentOrigin 0 0.666666 -5 1 0.5 1 ) 
					#name: #cancel 
					#model: #cancel 
					#label: 'Cancel' 
					#defaultable: true ) 
				#(#ActionButtonSpec 
					#layout: #(#AlignmentOrigin 0 0.333333 -5 1 0.5 1 ) 
					#name: #accept 
					#model: #accept 
					#label: 'OK' 
					#defaultable: true ) ) ) )
!

windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Class Selection' 
			#bounds: #(#Rectangle 286 176 722 413 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#SubCanvasSpec 
					#layout: #(#LayoutFrame 0 0 0 0 0 1 -40 1 ) 
					#name: #environmentEditor 
					#flags: 0 
					#majorKey: #EnvironmentEditor 
					#minorKey: #classWindowSpec 
					#clientKey: #environmentEditor ) 
				#(#ActionButtonSpec 
					#layout: #(#AlignmentOrigin 0 0.666666 -5 1 0.5 1 ) 
					#name: #cancel 
					#model: #cancel 
					#label: 'Cancel' 
					#defaultable: true ) 
				#(#ActionButtonSpec 
					#layout: #(#AlignmentOrigin 0 0.333333 -5 1 0.5 1 ) 
					#name: #accept 
					#model: #accept 
					#label: 'OK' 
					#defaultable: true ) ) ) )
! !

!ClassSelectionDialog methodsFor:'accessing'!

environmentEditor
	environmentEditor isNil 
		ifTrue: 
			[environmentEditor := EnvironmentEditor new.
			environmentEditor selectedEnvironment: ClassEnvironment new].
	^environmentEditor
!

selectedEnvironment
	^self environmentEditor selectedEnvironment
! !

!ClassSelectionDialog methodsFor:'interface opening'!

openInterface
	^self openInterface: (self selectedEnvironment isSelector
				ifTrue: [#selectorWindowSpec]
				ifFalse: [#windowSpec])
! !

!ClassSelectionDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/ClassSelectionDialog.st,v 1.6 2003-09-23 10:44:12 cg Exp $'
! !
