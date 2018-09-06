"{ Package: 'stx:libdb/nosql/goods/squeak' }"!

!Character methodsFor:'*goodsplatformsqueak'!

goodsWriteTaggedOn: aStream
	aStream nextPut: 5; nextInt32Put: value

! !

!Color class methodsFor:'*goodsplatformsqueak'!

goodsTransientFields
	^ #(#cachedDepth #cachedBitPattern )
! !

!Exception class methodsFor:'*goodsplatformsqueak'!

raiseSignal

	^self signal
! !

!Exception class methodsFor:'*goodsplatformsqueak'!

raiseSignal: message

	^self signal: message
! !

!KKIdentitySet methodsFor:'*goodsplatformsqueak'!

scanFor: anObject
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| finish start element |
	start := (database keyForObject: anObject) \\ array size + 1.
	finish := array size.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element := array at: index) == nil or: [element yourself == anObject yourself])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element := array at: index) == nil or: [element yourself == anObject yourself])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"
! !

!KKMetaclassDescriptor methodsFor:'*goodsplatformsqueak'!

objectFromStream: aStream forDatabase: aDatabase
	^ Smalltalk classNamed: (super objectFromStream: aStream forDatabase: aDatabase)
! !

!KKMetaclassDescriptor methodsFor:'*goodsplatformsqueak'!

writeObject: aClass onStream: aStream forDatabase: aDatabase
	super writeObject: aClass name onStream: aStream forDatabase: aDatabase
! !

!Metaclass methodsFor:'*goodsplatformsqueak'!

goodsDescriptor
	| descriptor |
	descriptor :=  KKMetaclassDescriptor new className: 'Class'.
	descriptor addField: String goodsVariableFieldDescriptor.
	^ descriptor
! !

!Object methodsFor:'*goods-override'!

= anObject
	"Answer whether the receiver and the argument represent the same
	object. If = is redefined in any subclass, consider also redefining the
	message hash."

	^self == anObject yourself
! !

!Object class methodsFor:'*goodsplatformsqueak'!

goodsVariableFieldDescriptor
	| container field |
	container := KKVariableFieldContainer new name: 'array'.
	field := self isBits
				ifFalse: [KKReferenceField new]
				ifTrue:
					[self isBytes
						ifTrue: [KKUnsignedIntegerField new size: 2]
						ifFalse: [KKUnsignedIntegerField new size: 4]].
	container fieldType: field.
	^ container
! !

!Timestamp methodsFor:'*goodsplatformsqueak'!

goodsIsImmutable
	^ true
! !

!stx_libdb_nosql_goods_squeak class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/squeak/extensions.st,v 1.6 2013-03-28 11:32:05 cg Exp $'
! !
