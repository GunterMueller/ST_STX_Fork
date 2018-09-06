"{ Package: 'stx:libdb/nosql/goods' }"!

!Behavior methodsFor:'*goods'!

goodsIsImmutable
	^ true
! !

!Boolean methodsFor:'*goods'!

goodsIsImmediateValue
	^ true
! !

!Boolean methodsFor:'*goods'!

goodsWriteTaggedOn: aStream
	aStream nextPut: 2; next: 3 put: 0; nextPut: (self ifTrue: [1] ifFalse: [0])
! !

!Boolean class methodsFor:'*goods'!

goodsDescriptor
	self error: 'Cannot store immediate values as references'
! !

!Character methodsFor:'*goods'!

goodsIsImmediateValue
	^ true
! !

!Character methodsFor:'*goodsplatformsqueak'!

goodsWriteTaggedOn: aStream
    Smalltalk isSmalltalkX ifTrue:[
        aStream 
            nextPut: 5; 
            nextPutLong:asciivalue MSB:true.
    ] ifFalse:[
        aStream 
            nextPut: 5; 
            nextInt32Put: asciivalue.
    ]
! !

!Class class methodsFor:'*goods'!

goodsDescriptorClass
	^ KKMetaclassDescriptor
! !

!Color class methodsFor:'*goodsplatformsqueak'!

goodsTransientFields
	^ #(#cachedDepth #cachedBitPattern )
! !

!Float methodsFor:'*goods'!

goodsIsImmediateValue
	^ true
! !

!Float methodsFor:'*goods'!

goodsWriteTaggedOn: aStream
    |flt|

    Smalltalk isSmalltalkX ifTrue:[
        aStream nextPut: 3.
        flt := self asShortFloat.
        ShortFloat storeBinaryIEEESingle:flt on:aStream MSB:true.
    ] ifFalse:[
        aStream nextPut: 3; uint32: self asIEEE32BitWord
    ]
! !

!Metaclass methodsFor:'*goodsplatformsqueak'!

goodsDescriptor
	| descriptor |
	descriptor :=  KKMetaclassDescriptor new className: 'Class'.
	descriptor addField: String goodsVariableFieldDescriptor.
	^ descriptor
! !

!Metaclass methodsFor:'*goods'!

visualworksName
	^self name
! !

!Object methodsFor:'*goods'!

goodsChanged
	"see goodsChanged:"
	^self goodsChanged: nil
! !

!Object methodsFor:'*goods'!

goodsChanged: payload
	"This method is part of the manual change tracking mechanism for detecting dirty objects in goods.  Objects which do 'manual' change tracking should send this message to themselves whenever the value of one of their i-vars changes.  You must also override goodsHasChangeTracking to answer true."
	KKManualWriteBarrier objectChanged: self with: payload
! !

!Object methodsFor:'*goods'!

goodsChangedAfter: aBlock
	"Evaluate aBlock then send goodsChanged to self.  Answer the result of the evaluation of aBlock"
	^aBlock ensure: [self goodsChanged]
! !

!Object methodsFor:'*goods'!

goodsHasChangeTracking
	"Subclasses that use 'manual' change tracking should override this to answer true.  See goodsChanged:."
	^false
! !

!Object methodsFor:'*goods'!

goodsIsImmediateValue
	^ false
! !

!Object methodsFor:'*goods'!

goodsIsImmutable
	^ false
! !

!Object methodsFor:'*goods'!

goodsUpdate

! !

!Object methodsFor:'*goods'!

xxxIsProxy
	^false
! !

!Object methodsFor:'*goods'!

yourClass
	^ self class
! !

!Object class methodsFor:'*goods'!

goodsDescriptor
	|descriptor|
	descriptor := self goodsDescriptorClass new.
	descriptor class: self;
				className: (KKClassMapper default nameForClass: self).
	self goodsFieldDescriptors do: [:field | descriptor addField: field].
	self isVariable ifTrue: [descriptor addField: self goodsVariableFieldDescriptor].
	^ descriptor
! !

!Object class methodsFor:'*goods'!

goodsDescriptorClass
	^ self isVariable
		ifTrue: [KKVariableClassDescriptor]
		ifFalse: [KKClassDescriptor]
! !

!Object class methodsFor:'*goods'!

goodsFieldDescriptorNamed: aName
	|selector|
	selector := (aName, 'Descriptor') asSymbol.
	^ ((self respondsTo: selector)
			ifTrue: [self perform: selector]
			ifFalse: [KKSingleFieldContainer referenceField])
		name: aName
! !

!Object class methodsFor:'*goods'!

goodsFieldDescriptors
	| fields superFields ivars |
	ivars := self instVarNames reject: [ :each | self goodsTransientFields includes: each ].
	fields := ivars collect: [ :ivar | self goodsFieldDescriptorNamed: ivar ].
	^ (self = Object or: [ self superclass = Object ])
		ifTrue: [ fields ]
		ifFalse:
			[ superFields := self superclass goodsFieldDescriptors.
			(Array with: (KKStructureContainer new
					name: (KKClassMapper default nameForClass: self superclass);
					fieldCount: superFields size)) , superFields , fields ]
! !

!Object class methodsFor:'*goods'!

goodsTransientFields
	"Answer a collection of the names of i-vars to not be stored in GOODS (transient fields)."

	^ #()
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

!OrderedCollection class methodsFor:'*GOODSPlatformSqueak'!

arrayDescriptor 
	^KKVariableFieldContainer  referenceField name: 'array'
! !

!Set class methodsFor:'*goodsplatformsqueak'!

arrayDescriptor
	^ KKVariableFieldContainer referenceField
! !

!Set class methodsFor:'*goods'!

tallyDescriptor
	^ KKSingleFieldContainer intField
! !

!SmallInteger methodsFor:'*goods'!

goodsIsImmediateValue
	^ true
! !

!SmallInteger methodsFor:'*goods'!

goodsWriteTaggedOn: aStream
    Smalltalk isSmalltalkX ifTrue:[
        aStream 
            nextPut: 1; 
            nextPutLong:self MSB:true.
    ] ifFalse:[
        aStream 
            nextPut: 1; 
            nextInt32Put: self.
    ]
! !

!SmallInteger class methodsFor:'*goods'!

goodsDescriptor
	self error: 'Cannot store immediate values as references'
! !

!String methodsFor:'*goods'!

goodsIsImmutable
	^ true
! !

!String class methodsFor:'*goods'!

goodsDescriptorClass
	^ KKStringDescriptor
! !

!Symbol class methodsFor:'*goods'!

goodsDescriptorClass
	^ KKSymbolDescriptor
! !

!Timestamp methodsFor:'*goodsplatformsqueak'!

goodsIsImmutable
	^ true
! !

!UUID methodsFor:'*goods'!

goodsIsImmutable
	^ true
! !

!UndefinedObject methodsFor:'*goods'!

goodsIsImmediateValue
	^ true
! !

!stx_libdb_nosql_goods class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/extensions.st,v 1.13 2013-03-31 21:52:26 cg Exp $'
! !
