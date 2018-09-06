"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MADescriptionBuilder subclass:#MANamedBuilder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!

MANamedBuilder comment:'I dynamically build container descriptions from class-side methods using a simple naming convention for the selector names:
# The method ==#defaultContainer== is called to retrieve the container instance.
# All the unary methods starting with the selector ==#description== are called and should return a valid description to be added to the container.
# All the keyword messages with one argument having a prefix of a method selected in step 2 will be called with the original description to further refine its definition.'
!


!MANamedBuilder methodsFor:'configuration'!

containerSelector
	^ #descriptionContainer
! !

!MANamedBuilder methodsFor:'private'!

build: anObject
	| selectors container description |
	selectors := anObject class allSelectors select: [ :each | each isDescriptionSelector ].
	container := self build: anObject for: self containerSelector in: selectors.
	^ (selectors select: [ :each | each isDescriptionDefinition ])
		inject: (cache at: anObject put: container)
		into: [ :result :each |
			self containerSelector = each ifFalse: [
				description := self build: anObject for: each in: selectors.
				description isDescription
					ifTrue: [ result add: description ] ].
			result ]
!

build: anObject for: aSelector in: aCollection
	^ (aCollection select: [ :each | each isDescriptionExtension: aSelector ])
		inject: (anObject perform: aSelector)
		into: [ :result :each | 
			result isNil 
				ifFalse: [ anObject perform: each with: result ] ]
! !

!MANamedBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MANamedBuilder.st,v 1.1 2009-07-29 14:47:21 cg Exp $'
! !
