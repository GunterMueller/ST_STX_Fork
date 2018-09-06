"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

CodeTool subclass:#OMTClassTool
	instanceVariableNames:'view'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-OMT-Diagram'
!

OMTClassTool comment:'OMTClassTool is the CodeTool for an OMT diagram.

Instance Variables:
	view    <OMTClassDiagram>       the diagram view'
!


!OMTClassTool class methodsFor:'interface specs'!

windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#FullSpec
		#window:
		#(#WindowSpec
			#label: 'Unlabeled Canvas'
			#bounds: #(#Rectangle 197 105 775 568 ) )
		#component:
		#(#SpecCollection
			#collection: #(
				#(#ArbitraryComponentSpec
					#layout: #(#LayoutFrame 0 0 0 0 0 1 0 1 )
					#name: #omtDiagram
					#flags: 11
					#component: #omtDiagram ) ) ) )
! !

!OMTClassTool methodsFor:'accessing'!

omtDiagram
	^view
! !

!OMTClassTool methodsFor:'initialize-release'!

codeModel: aCodeModel 
	| selectedClass |
	super codeModel: aCodeModel.
	selectedClass := self selectedClass.
	view := selectedClass isNil
				ifTrue: [CompositePart new]
				ifFalse: 
					[OMTClassDiagram
						classes: selectedClass withAllSuperclasses , selectedClass allSubclasses
						in: aCodeModel navigator]
! !

!OMTClassTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/OMTClassTool.st,v 1.6 2003-09-23 10:43:26 cg Exp $'
! !
