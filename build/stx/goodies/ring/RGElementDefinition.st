"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGDefinition subclass:#RGElementDefinition
	instanceVariableNames:'parent'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGElementDefinition comment:'RGElementDefinition is the abstract class for representing elements of a class-alike definition (i.e., methods, variables, comment).parent holds the RGClassDefinition or RGMetaclassDefinition defining this element.		Now a RingEntityDefinition offers two APIs: one that is generic and works for all the source code entities and this is the one we just presented: parent, parentName and realParent. Having such interface is important to build generic tools that could manipulate any entities in a polymorphic way (yes no isKindOf: everywhere).In addition, a ring method definition offers a specific interface that should only be used when you know that you are solely manipulatespecific entity such as class element: method definition, class comment, and variables. Here is the equivalence table	realParent 				realClass	parent					ringClass	parentName			className	For example for a methodDefinition we will have the following:GENERIC API------------------* To access the ring class definition name, use parentName	aRGMethodDefinition parentName	Example:	(Point>>#dist:) asRingDefinition parentName		->  #Point		* If you have a complete model where classes and methods are ring definition, to access the ring class definition , use parent	aRGMethodDefinition parent	Example:	aRGMethodDefinition(Point>>#dist:) parent		->  aRGClassDefinition(Point)		* If you want to access the smalltalk class that contains the compiledMethod that is represented by a ringMethodDefinition, use realParent	aRGMethodDefinition realParent	Example:	(Point>>#dist:) asRingDefinition realParent		->  Point		CLASS Element specific API------------------------------------------* The message class returns the class of the object :). Yes as you see we could not use class and className because class is already used to refer to the class of the object.Example:	(Point>>#dist:) asRingDefinition class		->  RingMethodDefinition		* The message className returns the name of the ring class defining the reingMethodDefinition.Example:	(Point>>#dist:) asRingDefinition className		->  #Point				* If you have a complete model where classes and methods are ring definition, to access the ring class definition , use parent	aRGMethodDefinition ringClass	Example:	aRGMethodDefinition(Point>>#dist:) ringClass		->  aRGClassDefinition(Point)				* If you want to access the smalltalk class that contains the compiledMethod that is represented by a ringMethodDefinition, use realClass	aRGMethodDefinition realClass	Example:	(Point>>#dist:) asRingDefinition realClass		->  Point'
!

!RGElementDefinition class methodsFor:'class initialization'!

class: aRGBehaviorDefinition
    "The argument is a ring object and serves as the parent of a method, variable or class comment"

    ^self new
        parent: aRGBehaviorDefinition;
        yourself
!

realClass: aClass
    "The argument is a Smalltalk class and the parent of a method, variable, class comment.
    However it is not set as parent but only its name and scope (instance/class)"

    ^self new
        parent: aClass asRingDefinition;
        yourself
! !

!RGElementDefinition class methodsFor:'elements-annotations'!

classNameKey

    ^#className
!

isMetaSideKey

    ^#isMetaSide
!

sourcePointerKey 

    ^#sourcePointer
!

statusKey

    ^#statusKey
! !

!RGElementDefinition class methodsFor:'parsing stamp'!

basicParseAuthorAliasFrom: aString
    "Parse an alias/name of the author from a string that is extracted from a source file. If there is no alias/name we return emtpy string."

    | tokens dateStartIndex unknown |
    "The following timestamp strings are supported (source: squeak sources archeological survey):
        <authorname><date><time>. 
        <authorname><date>
        <date><time>
        <date><time><authorname>
        <date><authorname>
        <historical>
    All fields can be separated by spaces or line ends but a separator between author alias/name and date can be missing as well"
    "unknown:= 'unknown'."
    unknown := nil.
    aString isEmptyOrNil
        ifTrue: [ ^ unknown ].
    dateStartIndex := (aString indexOf: $/) - 1.	"If there is no / character in the timestamp, no author alias/name exists"
    dateStartIndex = -1
        ifTrue: [ ^ unknown ].
    ^ [ 
    "Go the start of the date string (there can be 1 or 2 digits and a space separator can be missing at the front!!!!)"
    (dateStartIndex >= 2 and: [ (aString at: dateStartIndex - 1) isDigit ])
        ifTrue: [ dateStartIndex := dateStartIndex - 1 ].	"Extract only those tokens that do not possible represent date or time - meaning that authorname may be at the end"
    tokens := (aString copyFrom: dateStartIndex to: aString size) substrings
        reject: [ :token | (token occurrencesOf: $/) = 2 or: [ (token occurrencesOf: $:) = 1 ] ].	"only one token should be left if author name/alias exists"
    ^ tokens isEmpty
        ifTrue: [ 
            "if dateStartIndex is not 1 then the authorname may be at the beginning"
            dateStartIndex > 1
                ifTrue: [ (aString copyFrom: 1 to: dateStartIndex - 1) trimBoth ]
                ifFalse: [ unknown ] ]
        ifFalse: [ tokens first ] ]
        on: Exception
        do: [ :e | unknown ]
!

parseAuthorAliasFrom: aString
    "Allows other applications  to treat a different empty alias by overriding this method"
    
    ^self basicParseAuthorAliasFrom: aString
!

parseTimestampFrom: aString
    
    ^self parseTimestampFrom: aString default: nil
!

parseTimestampFrom: aString default: anObject
    "Parse a date-time from a timestamp-string that is extracted from a source file. If there is no timestamp, or we cannot make sense of it, we return the default value."

    | tokens dateStartIndex unknown |
    "The following timestamp strings are supported (source: squeak sources archeological survey):
        <authorname><date><time>. 
        <authorname><date>
        <date><time>
        <date><time><authorname>
        <date><authorname>
        <historical>
    All fields can be separated by spaces or line ends but a separator between authorname and date can be missing as well"
    unknown := anObject.
    aString isEmptyOrNil
        ifTrue: [ ^ unknown ].
    dateStartIndex := (aString indexOf: $/) - 1.	"If there is no / character in the timestamp, we cannot parse a date and return the epoch"
    dateStartIndex = -1
        ifTrue: [ ^ unknown ].
    ^ [ 
    "Go the start of the date string (there can be 1 or 2 digits and a space separator can be missing at the front!!!!)"
    (dateStartIndex >= 2 and: [ (aString at: dateStartIndex - 1) isDigit ])
        ifTrue: [ dateStartIndex := dateStartIndex - 1 ].	"Extract only those tokens that possibly represent date or time"
    tokens := (aString copyFrom: dateStartIndex to: aString size) substrings
        select: [ :token | (token occurrencesOf: $/) = 2 or: [ (token occurrencesOf: $:) = 1 ] ].	"2 tokens is a datetime"
    tokens size = 2
        ifTrue: [ (tokens joinUsing: Character space) asDateAndTime ]
        ifFalse: [ tokens first asDate asDateAndTime ] ]
        on: Exception
        do: [ :e | unknown ]
! !

!RGElementDefinition methodsFor:'accessing'!

fullName: aString

    ^ self annotationNamed: self class fullNameKey put: aString asSymbol
!

isMetaSide
    "Even thought several class elements do not define this property (ie. class variables, pool variables) they understand it"
    "This is a derived property from the class definining the receiver and thus its value is kept as an annotation"
    "Default value is false"

    ^self annotationNamed: self class isMetaSideKey ifAbsentPut: [ false ]
!

isMetaSide: aBoolean

    self annotationNamed: self class isMetaSideKey put: aBoolean
!

package
    ^self parent package 
! !

!RGElementDefinition methodsFor:'backward compatibility'!

actualClass
    "returns the Smalltalk class of the receiver"
    
    ^ self realClass
! !

!RGElementDefinition methodsFor:'class element specific api'!

className
    
    ^ self parentName
!

className: aName
    
    ^ self parentName: aName
!

realClass
    "Retrieves the Class/Trait/.. object in the System corresponding to the class of the this element."
    
    ^ self realParent
!

ringClass
    "Return the ring definition of the class containing the receiver."
    
    ^ self parent
!

theNonMetaClassName

    ^self theNonMetaParentName 
! !

!RGElementDefinition methodsFor:'comparing'!

= aRGElementDefinition
    "This method look for equality of the properties of the receiver"
    "Verifies the class and the parentName of the receiver"

    ^self class = aRGElementDefinition class
        and:[ self parentName == aRGElementDefinition parentName 
            and:[ self isMetaSide = aRGElementDefinition isMetaSide ] ]
!

hash
    "Hash is re-implemented because #= is re-implemented"
    
    ^self class hash bitXor: (self parentName hash bitXor: self isMetaSide hash)
! !

!RGElementDefinition methodsFor:'generic parent api'!

parent
    "The parent of a class definition element: method, comment and variable is the class definition. This method retrieves the class that defines such element"
    
    ^ parent
!

parent: aRGBehaviorDefinition
    "Set the class associated to the receiver"

    parent := aRGBehaviorDefinition.
    self setParentInfo: aRGBehaviorDefinition.
!

parentName
    "Retrieves the name of the class defining the receiver. Its value is kept as an annotation"

    ^ self annotationNamed: self class classNameKey
!

parentName: aString

    self annotationNamed: self class classNameKey put: aString asSymbol
!

realParent
    "Retrieves the Class/Trait/.. object in the System corresponding to the class of the this element."
    
    ^self parent notNil
        ifTrue: [ self parent realClass ]
        ifFalse: [ self rootEnvironment classNamed: self parentName ]
!

theNonMetaParentName
    "Rejects the prefix ' class' or ' classTrait' of the parentName"
    | index |
    
    index := self parentName
                indexOfSubCollection: ' class'
                startingAt: 1
                ifAbsent: [ ^self parentName ].

    ^(self parentName 
        copyFrom: 1
        to: index - 1) asSymbol
! !

!RGElementDefinition methodsFor:'private'!

setParentInfo: anObject
    "anObject is aRGBehaviorDefinition or aClass/aTrait"

    self parentName: anObject name. 
    self isMetaSide: anObject isMeta
! !

!RGElementDefinition methodsFor:'testing'!

isDefined
    "isDefined when the receiver has its realClass defined in the system"

    ^self realClass notNil
!

isSameRevisionAs: aRGElementDefinition
    "This method look for equality of the properties of the receiver"
    "Verifies the class and the parentName of the receiver"

    ^self class = aRGElementDefinition class
        and:[ self parentName == aRGElementDefinition parentName ]
! !

