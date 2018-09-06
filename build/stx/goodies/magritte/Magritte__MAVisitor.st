"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

Object subclass:#MAVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Visitor'
!

MAVisitor comment:'I am a visitor responsible to visit Magritte descriptions. I am an abstract class providing a default implementation for concrete visitors. The protocol I am implementing reflects the hierarchy of *MADescription* with its subclasses so that visiting a specific class automatically calls less specific implementations in case the specific implementation has been left out. The code was automatically created using code on my class-side.'
!


!MAVisitor class methodsFor:'instance creation'!

new
	^ self basicNew initialize
! !

!MAVisitor class methodsFor:'private'!

buildVisitorHierarchyForClass: aClass selector: aBlock classified: aSelector
	" self buildVisitorHierarchyForClass: MADescription selector: [ :class | 'visit' , (class name allButFirst: 2) , ':' ] classified: #'visiting-description' "

	aClass withAllSubclassesDo: [ :class |
		(class category beginsWith: 'Magritte') ifTrue: [
			self
				compile: (String streamContents: [ :stream |
					stream nextPutAll: (aBlock value: class); nextPutAll: ' anObject'; cr.
					class = aClass ifFalse: [
						stream tab; nextPutAll: 'self '; nextPutAll: (aBlock value: class superclass); nextPutAll: ' anObject.' ] ])
				classified: aSelector.
			class
				compile: (String streamContents: [ :stream |
					stream nextPutAll: 'acceptMagritte: aVisitor'; cr.
					stream tab; nextPutAll: 'aVisitor '; nextPutAll: (aBlock value: class); nextPutAll: ' self.' ])
				classified: #visiting ] ]
! !

!MAVisitor methodsFor:'initialize-release'!

initialize
! !

!MAVisitor methodsFor:'visiting'!

visit: anObject
	"Visit ==anObject== with the receiving visitor."

	anObject acceptMagritte: self
!

visitAll: aCollection
	"Visit all elements of ==aCollection== with the receiving visitor."

	aCollection do: [ :each | self visit: each ]
! !

!MAVisitor methodsFor:'visiting-description'!

visitBooleanDescription: anObject
	self visitElementDescription: anObject
!

visitClassDescription: anObject
	self visitElementDescription: anObject
!

visitColorDescription: anObject
	self visitElementDescription: anObject
!

visitContainer: anObject
	self visitDescription: anObject
!

visitDateDescription: anObject
	self visitMagnitudeDescription: anObject
!

visitDescription: anObject
!

visitDurationDescription: anObject
	self visitMagnitudeDescription: anObject
!

visitElementDescription: anObject
	self visitDescription: anObject
!

visitFileDescription: anObject
	self visitElementDescription: anObject
!

visitMagnitudeDescription: anObject
	self visitElementDescription: anObject
!

visitMemoDescription: anObject
	self visitStringDescription: anObject
!

visitMultipleOptionDescription: anObject
	self visitOptionDescription: anObject
!

visitNumberDescription: anObject
	self visitMagnitudeDescription: anObject
!

visitOptionDescription: anObject
	self visitReferenceDescription: anObject
!

visitPasswordDescription: anObject
	self visitStringDescription: anObject
!

visitPriorityContainer: anObject
	self visitContainer: anObject
!

visitReferenceDescription: anObject
	self visitElementDescription: anObject
!

visitRelationDescription: anObject
	self visitReferenceDescription: anObject
!

visitReportContainer: anObject
	self visitContainer: anObject
!

visitSingleOptionDescription: anObject
	self visitOptionDescription: anObject
!

visitStringDescription: anObject
	self visitElementDescription: anObject
!

visitSymbolDescription: anObject
	self visitStringDescription: anObject
!

visitTableDescription: anObject
	self visitReferenceDescription: anObject
!

visitTableReference: anObject
	^ self visitReferenceDescription: anObject
!

visitTimeDescription: anObject
	self visitMagnitudeDescription: anObject
!

visitTimeStampDescription: anObject
	self visitMagnitudeDescription: anObject
!

visitToManyRelationDescription: anObject
	self visitRelationDescription: anObject
!

visitToManyScalarRelationDescription: anObject
	self visitToManyRelationDescription: anObject
!

visitToOneRelationDescription: anObject
	self visitRelationDescription: anObject
!

visitTokenDescription: anObject
	self visitReferenceDescription: anObject
! !

!MAVisitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAVisitor.st,v 1.1 2009-07-29 14:55:30 cg Exp $'
! !
