"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

DisplayTransform subclass:#CompositeTransform
	instanceVariableNames:'globalTransform localTransform'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Transformations'
!

CompositeTransform comment:'A composite transform provides the effect of several levels of coordinate transformations.'
!

!CompositeTransform class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!CompositeTransform methodsFor:'accessing'!

inverseTransformation
	"Return the inverse transformation of the receiver"
	^self species new
		globalTransform: localTransform inverseTransformation
		localTransform: globalTransform inverseTransformation
! !

!CompositeTransform methodsFor:'converting'!

asCompositeTransform
	^self
!

asMatrixTransform2x3
	^globalTransform asMatrixTransform2x3
		composedWithLocal: localTransform asMatrixTransform2x3
! !

!CompositeTransform methodsFor:'initialization'!

globalTransform: gt localTransform: lt
	globalTransform _ gt.
	localTransform _ lt
! !

!CompositeTransform methodsFor:'testing'!

isCompositeTransform
	^true
!

isIdentity
	^ globalTransform isIdentity and: [localTransform isIdentity]
!

isPureTranslation
	^ globalTransform isPureTranslation and: [localTransform isPureTranslation]
! !

!CompositeTransform methodsFor:'transformations'!

invert: aPoint
	^ globalTransform invert: (localTransform invert: aPoint)
!

scale
	^ localTransform scale * globalTransform scale
!

transform: aPoint
	^ localTransform transform: (globalTransform transform: aPoint)
! !

!CompositeTransform methodsFor:'transforming points'!

globalPointToLocal: aPoint
	"Transform aPoint from global coordinates into local coordinates"
	^localTransform globalPointToLocal:
		(globalTransform globalPointToLocal: aPoint)
!

localPointToGlobal: aPoint
	"Transform aPoint from global coordinates into local coordinates"
	^globalTransform localPointToGlobal:
		(localTransform localPointToGlobal: aPoint)
! !

!CompositeTransform class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/CompositeTransform.st,v 1.1 1999-10-06 22:23:08 cg Exp $'
! !

