"{ Package: 'stx:goodies/communication/ssdp' }"

"{ NameSpace: Smalltalk }"

LinkedList subclass:#SSDPCache
	instanceVariableNames:'serviceType accessMutex entrySemaphore'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SSDP-Client'
!

SSDPCache comment:'SSDPCache holds Services ordered by expiry time, so the next expiring service can always be queried using #first.

updateServiceFor: and removeServiceFor:  constitute the public API used to keep cache current with availability/unavailability notifications, while removeService: is used for timing-based expiry.


'
!


!SSDPCache class methodsFor:'as yet unclassified'!

for: aServiceType
	^self new initializeType: aServiceType
! !

!SSDPCache methodsFor:'accessing'!

first
	"This method blocks until an entry is available"
	entrySemaphore wait.
	^[super first] ensure: [entrySemaphore signal ]
!

removeService: aService
	"Used to prune inactive processes from cache"

	^ accessMutex
		critical: [
			|removedService|
			removedService := (self remove: aService ifAbsent: [ nil ]).
			removedService
				ifNotNil: [
					entrySemaphore wait.
					removedService ] ]
!

removeServiceFor: aNotification
	"Used to remove services we are being told explicitly will no longer be available"
	| currentLink |
	accessMutex
		critical:
			[ currentLink := firstLink.
			firstLink ifNil: [^nil ].
			(aNotification relatedTo: currentLink value)
				ifTrue: [ entrySemaphore wait.
					firstLink := currentLink nextLink.
					 ]
				ifFalse:
					[ | ourLink |
					[ currentLink nextLink == nil
						or: [ aNotification relatedTo: currentLink nextLink value ] ]
						whileFalse: [ currentLink := currentLink nextLink ].
					ourLink := currentLink nextLink.
					ourLink
						ifNotNil:
							[ entrySemaphore wait.
							currentLink nextLink: ourLink nextLink.
							ourLink == lastLink
								ifTrue: [ lastLink := currentLink ] ].
					currentLink := ourLink ] ].
	^ currentLink == nil
		ifFalse: [ currentLink value ]
!

serviceType
	^serviceType
!

updateServiceFor: aNotification
	"Check matching type, and if absent, add and return new service then add if absent, or move according to updated timeout value"
	| currentLink newService|
	(self matchesType: aNotification)
		ifFalse: [ ^ nil ].
	currentLink := self
		linkOfServiceRelatedTo: aNotification
		ifAbsent: [ newService := aNotification asService.
				[self addFirst: (ValueLink value: newService)] ensure: [
				entrySemaphore signal]
				 ].
	accessMutex
		critical:
			[
	currentLink value merge: aNotification.
	self updateServicePosition: currentLink].
	^ newService
! !

!SSDPCache methodsFor:'initialize - release'!

initialize
        "EntrySemaphore excessSignals is a counter of current items in the cache, used to block on #first sends until entries are available."
        entrySemaphore := Semaphore new.
        "Since both discovery and automatic expulsion processes can end up removing services, we protect add and remove operations by this mutex."
        accessMutex := (Mutex ? RecursionLock) new.
!

initializeType: aType
	serviceType := aType
! !

!SSDPCache methodsFor:'private'!

linkOfServiceRelatedTo: aNotification ifAbsent: errorBlock
	"Find the link containing service with same uniqueServiceName"
		| aLink |
	aLink := firstLink.
	[aLink == nil ] whileFalse:
		[(aNotification relatedTo: aLink value) ifTrue: [ ^aLink ].
		aLink := aLink nextLink].
	^errorBlock value
!

matchesType: aNotification
	^ serviceType = 'ssdp:all'
		or: [ serviceType = aNotification serviceType ]
!

updateServicePosition: startLink
	| currentLink actualService nextLink|
	"Move startLink to new location in cache, after its cacheExpiry has been increased"
	currentLink := startLink.
	actualService := currentLink value.
	[
	nextLink := currentLink nextLink.
	(nextLink notNil and: [ nextLink value cacheExpiry < actualService cacheExpiry ])]
		whileTrue: [ currentLink value: nextLink value.
			nextLink value: actualService.
			currentLink := nextLink ]
! !

!SSDPCache class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPCache.st,v 1.4 2018-05-14 20:26:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPCache.st,v 1.4 2018-05-14 20:26:49 cg Exp $'
! !

