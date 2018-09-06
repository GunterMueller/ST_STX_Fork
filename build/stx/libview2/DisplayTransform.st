"{ Package: 'stx:libview2' }"

Object subclass:#DisplayTransform
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Transformations'
!

DisplayTransform comment:'This class represents a base for generic transformations of 2D points between different coordinate systems (including scaling and rotation). The transformations map objects between one coordinate system and another where it is assumed that a nested hierarchy of transformations can be defined.

It is assumed that transformations deal with Integer points. All transformations should return Integer coordinates (even though float points may be passed in as argument).

Compositions of transformations MUST work in the following order. A ''global'' transformation (the argument in #composedWithGlobal:) is defined as a transformation that takes place between the receiver (the ''local'') transformation and any ''global'' point computations, whereas a ''local'' transformation (e.g., the argument in #composedWithLocal:) takes place between the receiver (''global'') and any ''local'' points. For the transformation methods this means that combining a global and a local transformation will result in the following order:

		globalPointToLocal: globalPoint
			"globalPoint -> globalTransform -> localTransform -> locaPoint"
			^localTransform globalPointToLocal:
				(globalTransform globalPointToLocal: globalPoint)

		localPointToGlobal: localPoint
			"localPoint -> localTransform -> globalTransform -> globalPoint"
			^globalTransform localPointToGlobal:
				(localTransform localPointToGlobal: localPoint)

'
!


!DisplayTransform class methodsFor:'instance creation'!

identity
	^self new setIdentity
! !

!DisplayTransform methodsFor:'accessing'!

inverseTransformation
	"Return the inverse transformation of the receiver"
	^self subclassResponsibility
! !

!DisplayTransform methodsFor:'composing'!

composedWithGlobal: aTransformation
	"Return the composition of the receiver and the global transformation passed in.
	A 'global' transformation is defined as a transformation that takes place
	between the receiver (the 'local') transformation and any 'global' point
	computations, e.g., for the methods

		globalPointToLocal: globalPoint
			globalPoint -> globalTransform -> localTransform -> locaPoint

		localPointToGlobal: localPoint
			localPoint -> localTransform -> globalTransform -> globalPoint

		"
	^aTransformation composedWithLocal: self
!

composedWithLocal: aTransformation
	"Return the composition of the receiver and the local transformation passed in.
	A 'local' transformation is defined as a transformation that takes place
	between the receiver (the 'global') transformation and any 'local' point
	computations, e.g., for the methods

		globalPointToLocal: globalPoint
			globalPoint -> globalTransform -> localTransform -> locaPoint

		localPointToGlobal: localPoint
			localPoint -> localTransform -> globalTransform -> globalPoint

		"
	self isIdentity ifTrue:[^ aTransformation].
	aTransformation isIdentity ifTrue:[^ self].
	^ CompositeTransform new globalTransform: self
							localTransform: aTransformation
! !

!DisplayTransform methodsFor:'converting'!

asCompositeTransform
	"Represent the receiver as a composite transformation"
	^CompositeTransform new
		globalTransform: self
		localTransform: self species identity
!

asMatrixTransform2x3
	"Represent the receiver as a 2x3 matrix transformation"
	^self subclassResponsibility
! !

!DisplayTransform methodsFor:'initialize'!

setIdentity
    "Initialize the receiver to the identity transformation (e.g., not affecting points)"

    ^self subclassResponsibility
! !

!DisplayTransform methodsFor:'testing'!

isCompositeTransform
	"Return true if the receiver is a composite transformation.
	Composite transformations may have impact on the accuracy."
	^false
!

isIdentity
	"Return true if the receiver is the identity transform; that is, if applying to a point returns the point itself."
	^self subclassResponsibility
!

isMatrixTransform2x3
	"Return true if the receiver is 2x3 matrix transformation"
	^false
!

isMorphicTransform
	"Return true if the receiver is a MorphicTransform, that is specifies the transformation values explicitly."
	^false
!

isNoScale
    "return true if the identity scale is in effect (i.e. saleFactor is 1);
     return false, otherwise."

    |s|

    s := self scale.
    ^ s x = 1 and:[s y = 1]
!

isPureTranslation
	"Return true if the receiver specifies no rotation or scaling."
	^self subclassResponsibility
! !

!DisplayTransform methodsFor:'transforming points'!

applyInverseTo:aPoint
    ^ self invertPoint: aPoint
!

applyScaleX:aNumber
    ^ (self transformPoint: aNumber @ 0) x
!

applyScaleY:aNumber
    ^ (self transformPoint: 0 @ aNumber) y
!

applyTo:aPoint
    ^ self transformPoint: aPoint
!

globalPointToLocal: aPoint
	"Transform aPoint from global coordinates into local coordinates"
	^self subclassResponsibility
!

globalPointsToLocal: inArray
	"Transform all the points of inArray from global into local coordinates"
	^inArray collect:[:pt| self globalPointToLocal: pt]
!

localPointToGlobal: aPoint
	"Transform aPoint from local coordinates into global coordinates"
	^self subclassResponsibility
!

localPointsToGlobal: inArray
	"Transform all the points of inArray from local into global coordinates"
	^inArray collect:[:pt| self localPointToGlobal: pt]
! !

!DisplayTransform methodsFor:'transforming rects'!

globalBoundsToLocal: aRectangle
	"Transform aRectangle from global coordinates into local coordinates"
	^Rectangle encompassing: (self globalPointsToLocal: aRectangle corners)
!

localBoundsToGlobal: aRectangle
	"Transform aRectangle from local coordinates into global coordinates"
	^Rectangle encompassing: (self localPointsToGlobal: aRectangle corners)
! !

!DisplayTransform class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/DisplayTransform.st,v 1.3 2014-12-21 22:23:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/DisplayTransform.st,v 1.3 2014-12-21 22:23:28 cg Exp $'
! !

