"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCFrontier
	instanceVariableNames:'frontier bag'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCFrontier class methodsFor:'instance creation'!

frontierOn: aVersionInfo
	^ self frontierOnAll: (Array with: aVersionInfo)
!

frontierOn: aVersionInfo and: otherVersionInfo
	^ self frontierOnAll: (Array with: aVersionInfo with: otherVersionInfo)
!

frontierOnAll: aCollection
	| remaining  allVersions |
	remaining := Bag new.
	allVersions _ (aCollection gather: [:ea | ea withBreadthFirstAncestors]) asSet.
	allVersions do: [:ea | remaining addAll: ea ancestors].
	^self new frontier: aCollection bag: remaining
! !

!MCFrontier methodsFor:'accessing'!

frontier
	^frontier
! !

!MCFrontier methodsFor:'advancing'!

remove: aVersionInfo
	frontier remove: aVersionInfo.
	aVersionInfo ancestors  do:
		[ :ancestor |
			bag remove: ancestor.
			(bag occurrencesOf: ancestor) = 0
				ifTrue: [frontier add: ancestor]].
	^aVersionInfo
!

removeAll: collection
	collection do: [ :n | self remove: n]
! !

!MCFrontier methodsFor:'initialization'!

frontier: f bag: remaining
	frontier := f asOrderedCollection.
	bag := remaining
! !

!MCFrontier class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCFrontier.st,v 1.2 2012-09-11 21:22:09 cg Exp $'
! !
