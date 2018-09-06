"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSAspect
	instanceVariableNames:'name getter setter objectSetName unused1 unused2'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSAspect class methodsFor:'As yet unclassified'!

Comments

"

	an Aspect contains meta-data about an ObjectSets relationship 

	to another ObjectSet.  An aspect knows how to get an aspect value

	from an object in an ObjectSet.



		For example: 

			ObjectSet named #Person has an aspect named #address which 

			holds one or many objects that are stored in ObjectSet named #Address

"
!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

newName: nameSymbol

getter: getterSymbol

setter: setterSymbol

objectSetName: osnSymbol

	"Answer a new instance of myself with everything filled in."



	^self new

		name: nameSymbol;

		getter: getterSymbol;

		setter: setterSymbol;

		objectSetName: osnSymbol;

		yourself.
! !

!MSAspect methodsFor:'As yet unclassified'!

getter



	^getter
!

getter: aSymbol



	^getter := aSymbol
!

name



	^name
!

name: aSymbol



	^name := aSymbol
!

objectSetName

	"Answer the name of the object set this aspect represents."



	^objectSetName
!

objectSetName: aSymbol

	"Setter"



	objectSetName := aSymbol
!

setReadProxyFor: anObject

with: anMSObjectSet

	"This is called after reading an object.  anMSObjectSet is the object set for the aspect, not the object."



	| proxy |

	FlavorCompatibility assert: (objectSetName == anMSObjectSet name).  FlavorCompatibility testing.

	proxy := anObject perform: getter.

	proxy == nil

		ifTrue: [^self].

	proxy isMSStorageProxy

		ifTrue:

			"Change it to a read proxy."

			[proxy := proxy asMSReadProxy.

			proxy objectSet: anMSObjectSet.

			anObject perform: setter with: proxy].

	
!

setStorageProxyFor: anObject with: anMSObjectSet

	"This is called before storing an object.  anMSObjectSet is the object set for the aspect, not the object."



	| aspectValue proxy |

	FlavorCompatibility assert: (objectSetName == anMSObjectSet name).  FlavorCompatibility testing.

	aspectValue := anObject perform: getter.

	aspectValue == nil

		ifTrue: [^self].

	aspectValue isMSStorageProxy

		ifTrue: [^self].  "This should be true only if something went wrong."

	aspectValue isMSReadProxy

		ifTrue:

			["aspectValue realObjectIsInstantiated     - Removed 98/2/22

				ifTrue: [self storeAspect: aspectValue realObject using: anMSObjectSet]."

			proxy := aspectValue asMSStorageProxy]

		ifFalse:

			["self storeAspect: aspectValue using: anMSObjectSet.   - Removed 98/2/22"

			self validateAspect: aspectValue using: anMSObjectSet.  "Added 98-2-22"

			proxy := self storageProxyClass newFor: aspectValue and: anMSObjectSet].

	anObject perform: setter with: proxy.
!

setter



	^setter
!

setter: aSymbol



	^setter := aSymbol
!

storageProxyClass



	^self implementedBySubclass
! !

!MSAspect class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSAspect.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
