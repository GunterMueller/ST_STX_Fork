"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

CodeTool subclass:#CanvasViewer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Code Tools'
!

CanvasViewer comment:'CanvasViewer is a class to view canvases graphically instead of textually. This is used when you are viewing a canvas method.'
!


!CanvasViewer class methodsFor:'interface specs'!

windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#FullSpec
		#window:
		#(#WindowSpec
			#label: 'Unlabeled Canvas'
			#bounds: #(#Rectangle 492 279 895 651 ) )
		#component:
		#(#SpecCollection
			#collection: #(
				#(#SubCanvasSpec
					#layout: #(#LayoutFrame 0 0 0 0 0 1 0 1 )
					#name: #subcanvas
					#flags: 43 ) ) ) )
! !

!CanvasViewer methodsFor:'private'!

disableSpec: aFullSpec 
	aFullSpec component collection do: [:each | (each isKindOf: NamedSpec)
			ifTrue: [each initiallyDisabled: true]]
!

spec
	| class selector method specArray spec |
	class := self selectedClass.
	selector := self selector.
	selector notNil
				ifTrue: 
					[method := class compiledMethodAt: selector ifAbsent: [nil].
					(method notNil and: [method resourceType == #canvas])
						ifTrue: [self errorSignal handle: [:ex | ex returnWith: self class emptySpec]
								do: [specArray := self nonMetaClass perform: selector]]
						ifFalse: [specArray := self class emptySpec]
					]
				ifFalse: [specArray := self class emptySpec].
	spec := specArray decodeAsLiteralArray.
	spec isNil ifTrue: [^nil].
	self disableSpec: spec.
	^spec
! !

!CanvasViewer methodsFor:'updating'!

updateContents
	self updateDisplay
!

updateDisplay
	"Update the subcanvas with the current spec. Use a builder that is editing so that the canvas can be 
	built properly."

	|b|

	builder notNil ifTrue: [
	    b := (UIBuilder new) isEditing: true; yourself.
	    (builder componentAt: #subcanvas) widget
			client: self
			spec: self spec
			builder: b
	].
	super updateDisplay
! !

!CanvasViewer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/CanvasViewer.st,v 1.5 2003-09-23 10:47:36 cg Exp $'
! !
