"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAObject subclass:#MADescription
	instanceVariableNames:'accessor'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MADescription comment:'I am the root of the description hierarchy in Magritte and I provide most of the basic properties available to all descriptions. If you would like to annotate your model with a description have a look at the different subclasses of myself.
!!Example
If your model has an instance variable called ==title== that should be used to store the title of the object, you could add the following description to your class:
=Document class>>descriptionTitle
=	^ MAStringDescription new
=		autoAccessor: #title;
=		label: ''Title'';
=		priority: 20;
=		beRequired;
=		yourself.
The selector ==#title== is the name of the accessor method used by Magritte to retrieve the value from the model. In the above case Magritte creates the accessor method and the instance variable automatically, if necessary. The label is used to give the field a name and will be printed next to the input box if a visual GUI is created from this description.
The write-accessor is automatically deduced by adding a colon to the read-selector, in this example ==#title:==. You can specify your own accessor strategy using one of the subclasses of ==*MAAccessor*==. If you have multiple description within the same object, the ==#priority:== field is used to order them. Assign a low priority to have descriptions traversed first.'
!




!MADescription class methodsFor:'*magritte-seaside-defaults'!

defaultComponentClass
	^ self defaultComponentClasses isEmpty
		ifTrue: [ MAUndefinedComponent ]
		ifFalse: [ self defaultComponentClasses first ]
!

defaultCssClasses
	^ OrderedCollection new
!

defaultReportColumnClass
	^ self defaultReportColumnClasses notEmpty
		ifTrue: [ self defaultReportColumnClasses first ]
! !

!MADescription class methodsFor:'*magritte-seaside-description'!

descriptionComponentClass
	^ MASingleOptionDescription new
		accessor: #componentClass;
		label: 'Component Class';
		reference: MAClassDescription new;
		options: self defaultComponentClasses;
		default: self defaultComponentClass;
		priority: 1000;
		yourself
!

descriptionReportColumnClass
	^ MASingleOptionDescription new
		accessor: #reportColumnClass;
		label: 'Report Column Class';
		priority: 1010;
		reference: MAClassDescription new;
		options: self defaultReportColumnClasses;
		default: self defaultReportColumnClass;
		yourself
! !

!MADescription class methodsFor:'*magritte-seaside-examples'!

grouping
	^MADescriptionHolder groupOf: self
! !

!MADescription class methodsFor:'accessing-defaults'!

defaultAccessor
	^ MANullAccessor new
!

defaultComment
	^ nil
!

defaultConditions
	^ Array new
!

defaultDefault
	^ nil
!

defaultGroup
	^ nil
!

defaultLabel
	^ String new
!

defaultPersistent
	^ true
!

defaultPriority
	^ 0
!

defaultReadonly
	^ false
!

defaultRequired
	^ false
!

defaultStringReader
	^ MAStringReader
!

defaultStringWriter
	^ MAStringWriter
!

defaultUndefined
	^ String new
!

defaultValidator
	^ MAValidatorVisitor
!

defaultVisible
	^ true
! !

!MADescription class methodsFor:'accessing-description'!

descriptionComment
	^ MAMemoDescription new
		accessor: #comment;
		label: 'Comment';
		priority: 110;
		default: self defaultComment;
		yourself
!

descriptionDefault
	^ self isAbstract ifFalse: 
		[ self new
			accessor: #default;
			label: 'Default';
			priority: 130;
			default: self defaultDefault;
			yourself ]
!

descriptionGroup
	^ MAStringDescription new
		accessor: #group;
		default: self defaultGroup;
		label: 'Group';
		priority: 105;
		yourself
!

descriptionLabel
	^ MAStringDescription new
		accessor: #label;
		label: 'Label';
		priority: 100;
		default: self defaultLabel;
		yourself
!

descriptionName
	^ MAStringDescription new
		accessor: #name;
		label: 'Kind';
		priority: 0;
		beReadonly;
		yourself
!

descriptionPriority
	^ MANumberDescription new
		accessor: #priority;
		label: 'Priority';
		priority: 130;
		default: self defaultPriority;
		beRequired;
		yourself
!

descriptionReadonly
	^ MABooleanDescription new
		accessor: #readonly;
		label: 'Readonly';
		priority: 200;
		default: self defaultReadonly;
		yourself
!

descriptionRequired
	^ MABooleanDescription new
		accessor: #required;
		label: 'Required';
		priority: 220;
		default: self defaultRequired;
		yourself
!

descriptionStringReader
	^ MASingleOptionDescription new
		accessor: #stringReader;
		label: 'String Reader';
		priority: 300;
		default: self defaultStringReader;
		options: [ self defaultStringReader withAllSubclasses ] asDynamicObject;
		reference: MAClassDescription new;
		yourself
!

descriptionStringWriter
	^ MASingleOptionDescription new
		accessor: #stringWriter;
		label: 'String Writer';
		priority: 310;
		default: self defaultStringWriter;
		options: [ self defaultStringWriter withAllSubclasses ] asDynamicObject;
		reference: MAClassDescription new;
		yourself
!

descriptionUndefined
	^ MAStringDescription new
		accessor: #undefined;
		label: 'Undefined String';
		priority: 140;
		default: self defaultUndefined;
		yourself
!

descriptionValidator
	^ MASingleOptionDescription new
		accessor: #validator;
		label: 'Validator';
		priority: 250;
		default: self defaultValidator;
		options: [ self defaultValidator withAllSubclasses ] asDynamicObject;
		reference: MAClassDescription new;
		yourself
!

descriptionVisible
	^ MABooleanDescription new
		accessor: #visible;
		label: 'Visible';
		priority: 210;
		default: self defaultVisible;
		yourself
! !


!MADescription methodsFor:'*magritte-seaside-accessing'!

componentClass
	^ self propertyAt: #componentClass ifAbsent: [ self class defaultComponentClass ]
!

componentClass: aClass
	self propertyAt: #componentClass put: aClass
!

cssClass: aString
	(self propertyAt: #cssClasses ifAbsentPut: [ self class defaultCssClasses ])
		add: aString
!

cssClasses
	^ self propertyAt: #cssClasses ifAbsent: [ self class defaultCssClasses ]
!

cssClasses: aCollection
	self propertyAt: #cssClasses put: aCollection
!

reportColumnClass
	^ self propertyAt: #reportColumnClass ifAbsent: [ self class defaultReportColumnClass ]
!

reportColumnClass: aClass
	self propertyAt: #reportColumnClass put: aClass
! !

!MADescription methodsFor:'accessing'!

accessor
	"Answer the access-strategy of the model-value described by the receiver."

	^ accessor ifNil: [ accessor := self class defaultAccessor ]
!

accessor: anObject
	accessor := anObject asAccessor
!

default
	^ nil
!

default: anObject
! !

!MADescription methodsFor:'accessing-configuration'!

kind
	"Answer the base-class (type) the receiver is describing. The default implementation answers the most generic class: Object, the root of the Smalltalk class hierarchy. Subclasses might refine this choice."

	^ Object
!

name
	"Answer the name of the description, a human-readable string describing the type."

	^ self class label
! !

!MADescription methodsFor:'accessing-messages'!

conflictErrorMessage
	^ self propertyAt: #conflictErrorMessage ifAbsent: [ 'Input is conflicting with concurrent modification' ]
!

conflictErrorMessage: aString
	self propertyAt: #conflictErrorMessage put: aString
!

kindErrorMessage
	^ self propertyAt: #kindErrorMessage ifAbsent: [ 'Invalid input given' ]
!

kindErrorMessage: aString
	self propertyAt: #kindErrorMessage put: aString
!

multipleErrorsMessage
	^ self propertyAt: #multipleErrorsMessage ifAbsent: [ 'Multiple errors' ]
!

multipleErrorsMessage: aString
	self propertyAt: #multipleErrorsMessage put: aString
!

requiredErrorMessage
	^ self propertyAt: #requiredErrorMessage ifAbsent: [ 'Input is required but no input given' ]
!

requiredErrorMessage: aString
	self propertyAt: #requiredErrorMessage put: aString
! !

!MADescription methodsFor:'accessing-properties'!

comment
	"Answer a comment or help-text giving a hint what this description is used for. GUIs that are built from this description might display it as a tool-tip."

	^ self propertyAt: #comment ifAbsent: [ self class defaultComment ]
!

comment: aString
	self propertyAt: #comment put: aString
!

conditions
	"Answer a collection of additional conditions that need to be fulfilled so that the described model is valid. Internally the collection associates conditions with an error string."

	^ self propertyAt: #conditions ifAbsent: [ self class defaultConditions ]
!

conditions: anArray
	self propertyAt: #conditions put: anArray
!

group
	"Answer the group of the receiving description. The group is a string used to categorize and group descriptions. Certain display interpreters with be able to use this information to improve the usability."

	^ self propertyAt: #group ifAbsent: [ self class defaultGroup ]
!

group: aString
	"Answer the group of the receiving description. The group is a string used to categorize and group descriptions. Certain display interpreters with be able to use this information to improve the usability."

	self propertyAt: #group put: aString
!

label
	"Answer the label of the receiving description. The label is mostly used as an identifier that is printed next to the input field when building a GUI from the receiver."

	^ self propertyAt: #label ifAbsent: [ self class defaultLabel ]
!

label: aString
	self propertyAt: #label put: aString
!

priority
	"Answer a number that is the priority of the receiving description. Priorities are used to give descriptions an explicit order by sorting them according to this number."

	^ self propertyAt: #priority ifAbsent: [ self class defaultPriority ]
!

priority: aNumber
	self propertyAt: #priority put: aNumber
!

readonly
	"Answer ==true== if the model described by the receiver is read-only."

	^ self propertyAt: #readonly ifAbsent: [ self class defaultReadonly ]
!

readonly: aBoolean
	self propertyAt: #readonly put: aBoolean
!

required
	"Answer ==true== if the model described by the receiver is required, this is it cannot be ==nil==."

	^ self propertyAt: #required ifAbsent: [ self class defaultRequired ]
!

required: aBoolean
	self propertyAt: #required put: aBoolean
!

validator
	"Answer a Visitor that can be used to validate the model described by the receiver."

	^ self propertyAt: #validator ifAbsent: [ self class defaultValidator ]
!

validator: aClass
	self propertyAt: #validator put: aClass
!

visible
	"Answer ==true== if the model described by the receiver is visible, as an opposite to hidden."

	^ self propertyAt: #visible ifAbsent: [ self class defaultVisible ]
!

visible: aBoolean
	self propertyAt: #visible put: aBoolean
! !

!MADescription methodsFor:'accessing-strings'!

stringReader
	"Answer a Visitor that can be used to parse the model described by the receiver from a string."

	^ self propertyAt: #stringReader ifAbsent: [ self class defaultStringReader ]
!

stringReader: aClass
	self propertyAt: #stringReader put: aClass
!

stringWriter
	"Answer a Visitor that can be used to convert the model described by the receiver to a string."

	^ self propertyAt: #stringWriter ifAbsent: [ self class defaultStringWriter ]
!

stringWriter: aClass
	self propertyAt: #stringWriter put: aClass
!

undefined
	"Answer a string that is printed whenever the model described by the receiver is ==nil==."

	^ (self propertyAt: #undefined ifAbsent: [ self class defaultUndefined ])
		ifNil: [ self class defaultUndefined ]
!

undefined: aString
	self propertyAt: #undefined put: aString
! !

!MADescription methodsFor:'accessors'!

chainAccessor: anArray
	"Uses ==anArray== of selectors to read from the model."

	self accessor: (MAChainAccessor accessors: anArray)
!

propertyAccessor: aSelector
	"Uses ==aSelector== to read from the property dictionary of the model."

	self accessor: ((MAChainAccessor on: #properties) 
		accessor: (MADictionaryAccessor key: aSelector))
!

selectorAccessor: aSelector
	"Uses ==aSelector== to read from the model."

	self accessor: (MASelectorAccessor selector: aSelector)
! !

!MADescription methodsFor:'actions'!

beHidden
	self visible: false
!

beOptional
	self required: false
!

beReadonly
	self readonly: true
!

beRequired
	self required: true
!

beVisible
	self visible: true
!

beWriteable
	self readonly: false
! !

!MADescription methodsFor:'comparing'!

= anObject
	^ super = anObject
		and: [ self accessor = anObject accessor ]
!

hash
	^ super hash bitXor: self accessor hash
! !

!MADescription methodsFor:'converting'!

asContainer
	"Answer a description container of the receiver."

	self subclassResponsibility
! !

!MADescription methodsFor:'copying'!

postCopy
	super postCopy.
	accessor := accessor copy
! !

!MADescription methodsFor:'operators'!

, aDescription
	"Concatenate the receiver and ==aDescription== to one composed description. Answer a description container containing both descriptions."

	^ self asContainer copy
		addAll: aDescription asContainer;
		yourself
!

< anObject
        "Answer whether the receiver should precede ==anObject== in a priority container."

        ^ self priority < anObject priority
!

<= anObject
	"Answer whether the receiver should precede ==anObject== in a priority container."

	^ self priority <= anObject priority
! !

!MADescription methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: ' label: '; print: self label.
	aStream nextPutAll: ' comment: '; print: self comment
! !

!MADescription methodsFor:'strings'!

fromString: aString
	"Answer an object being parsed from ==aString==."

	^ self fromString: aString reader: self stringReader
!

fromString: aString reader: aParser
	"Answer an object being parsed from ==aString== using ==aParser==."

	^ aParser read: aString readStream description: self
!

fromStringCollection: aCollection
	"Answer a collection of objects being parsed from ==aCollection== of strings."

	^ self fromStringCollection: aCollection reader: self stringReader
!

fromStringCollection: aCollection reader: aParser
	"Answer a collection of objects being parsed from ==aCollection== of strings using ==aParser==."

	^ aCollection collect: [ :each | self fromString: each reader: aParser ]
!

toString: anObject
	"Answer a string being formatted from ==anObject==."

	^ self toString: anObject writer: self stringWriter
!

toString: anObject writer: aFormatter
	"Answer a string being formatted from ==anObject== using ==aFormatter==."

	^ aFormatter write: anObject description: self
!

toStringCollection: aCollection
	"Answer a collection of strings being formatted from ==aCollection==."

	^ self toStringCollection: aCollection writer: self stringWriter
!

toStringCollection: aCollection writer: aFormatter
	"Answer a collection of strings being formatted from ==aCollection== using ==aFormatter==."

	^ aCollection collect: [ :each | self toString: each writer: aFormatter ]
! !

!MADescription methodsFor:'testing'!

hasChildren
	"Answer ==true== if the receiver has any child-descriptions. A description container usually has children."

	^ false
!

hasComment
	"Answer ==true== if the the receiver has got a non empty comment."

	^ self comment notNil and: [ self comment isEmpty not ]
!

hasLabel
	"Answer ==true== if the the receiver has got a non empty label."

	^ self label notNil and: [ self label isEmpty not ]
!

isContainer
	"Answer ==true== if the receiver is a description container."

	^ false
!

isDescription
	"Answer ==true== if the receiver is a description."

	^ true
!

isGrouped
	^ false
!

isReadonly
	^ self readonly
!

isRequired
	^ self required
!

isSortable
	"Answer ==true== if the described object can be trivially sorted, e.g. it answers to #<=."

	^ false
!

isVisible
	^ self visible
! !

!MADescription methodsFor:'validation'!

addCondition: aCondition
	self addCondition: aCondition labelled: aCondition asString
!

addCondition: aCondition labelled: aString
	"Add ==aCondition== as an additional validation condition to the receiver and give it the label ==aString==. The first argument is either a block-context or any other object that responds to ==#value:== with ==true== or ==false==."

	self conditions: (self conditions
		copyWith: (Association
			key: aCondition
			value: aString))
!

isSatisfiedBy: anObject
	"Answer ==true== if ==anObject== is a valid instance of the receiver's description."

	[ self validate: anObject ]
		on: MAValidationError
		do: [ :err | ^ false ].
	^ true
!

validate: anObject
	"Validate ==anObject== in the context of the describing-receiver, raises an error in case of a problem. If ==anObject== is ==nil== and not required, most tests will be skipped. Do not override this message, instead have a look at ==#validateSpecific:== what is usually a better place to define the behaviour your description requires."

	self validator on: anObject description: self
! !

!MADescription methodsFor:'validation-private'!

validateConditions: anObject
	"Validate ==anObject== to satisfy all its custom conditions."

	self conditions do: [ :each |
		(each key value: anObject)
			ifFalse: [ MAConditionError description: self signal: each value ] ]
!

validateKind: anObject
	"Validate ==anObject== to be of the right kind."

	(anObject isKindOf: self kind)
		ifFalse: [ MAKindError description: self signal: self kindErrorMessage ]
!

validateRequired: anObject
	"Validate ==anObject== not to be ==nil== if it is required."

	(self isRequired and: [ anObject isNil ])
		ifTrue: [ MARequiredError description: self signal: self requiredErrorMessage ]
!

validateSpecific: anObject
	"Validate ==anObject== to satisfy its descriptions specific validation rules. Subclasses mostly want to override this method."
! !

!MADescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitDescription: self
! !

!MADescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MADescription.st,v 1.7 2009-08-14 20:08:47 cg Exp $'
! !
