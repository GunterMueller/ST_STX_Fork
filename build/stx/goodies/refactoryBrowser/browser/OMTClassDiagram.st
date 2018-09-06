"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

CompositePart subclass:#OMTClassDiagram
	instanceVariableNames:'classes navigator'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-OMT-Diagram'
!

OMTClassDiagram comment:'OMTClassDiagram is a VisualComponent that contains all the individual OMTClassView objects. It''s mainly used for laying out the classes.

Instance Variables:
	classes <Collection of: Behavior>       which classes are being displayed
	navigator       <BrowserNavigator>      the navigator we''re connected to'
!


!OMTClassDiagram class methodsFor:'instance creation'!

classes: aCollection in: aBrowser
	^self new classes: aCollection in: aBrowser
! !

!OMTClassDiagram methodsFor:'initialize-release'!

classes: aCollection in: aNavigator
	classes := aCollection.
	navigator := aNavigator.
	self layoutClasses
!

scrollOffsetHolder: aValueHolder 
	aValueHolder grid: 25 @ 25
! !

!OMTClassDiagram methodsFor:'private'!

findRootOfHierarchy
	^classes detect: [:each | (classes includes: each superclass) not]
!

horizontalSpacing
	^10
!

layout: rootClass at: aPoint 
	| subclasses xLocation rootClassView bounds top subclassPositions |
	subclasses := rootClass subclasses select: [:each | classes includes: each].
	rootClassView := OMTClassView viewFor: rootClass in: navigator.
	bounds := rootClassView preferredBounds translatedBy: aPoint.
	top := bounds bottom + self verticalSpacing.
	xLocation := aPoint x.
	subclassPositions := subclasses
				collect: 
					[:each | 
					| subclassBounds |
					subclassBounds := self layout: each at: xLocation @ top.
					bounds := bounds merge: subclassBounds.
					xLocation := bounds right + self horizontalSpacing.
					subclassBounds topCenter].
	rootClassView := (BorderedWrapper on: rootClassView at: bounds extent x - rootClassView preferredBounds extent x // 2 @ 0 + aPoint)
				border: BeveledBorder raised; yourself.
	self add: rootClassView.
	subclasses isEmpty ifFalse: [self subclassLinesAt: rootClassView preferredBounds bottomCenter to: subclassPositions].
	^bounds
!

layoutClasses
	| rootClass |
	rootClass := self findRootOfHierarchy.
	self layout: rootClass at: self horizontalSpacing @ 10
!

subclassLinesAt: aPoint to: pointCollection 
	| vertices interval bottom |
	bottom := aPoint y + 28.
	vertices := Array new: 5.
	vertices at: 1 put: aPoint.
	vertices at: 5 put: (vertices at: 2 put: aPoint + (0 @ 13)).
	vertices at: 3 put: aPoint x + 15 @ bottom.
	vertices at: 4 put: aPoint x - 15 @ bottom.
	self add: (StrokingWrapper on: (Polyline vertices: vertices)).
	pointCollection do: [:each | self add: (StrokingWrapper on: (LineSegment from: each to: each x @ bottom))].
	interval := pointCollection inject: (aPoint x to: aPoint x)
				into: [:int :each | (int first min: each x)
						to: (int last max: each x)].
	(aPoint x - 13 > interval first or: [aPoint x + 13 < interval last])
		ifTrue: [self add: (StrokingWrapper on: (LineSegment from: interval first @ bottom to: interval last @ bottom))]
!

verticalSpacing
	^50
! !

!OMTClassDiagram class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/OMTClassDiagram.st,v 1.6 2003-09-23 10:44:26 cg Exp $'
! !
