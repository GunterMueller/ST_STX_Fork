"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#DocumentType
	instanceVariableNames:'attributeDefs elementDefs generalEntities parameterEntities
		notations declaredRoot'
	classVariableNames:'PredefinedEntities'
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

DocumentType comment:'This class represents an XML document type definition or DTD. The document type declaration can point to an external subset containing markup declarations, or can contain the markup declarations directly in an internal subset, or can do both. The DTD for a document consists of both subsets taken together.

Instance Variables:
	attributeDefs   <Dictionary>
	elementDefs     <Dictionary>
	generalEntities <Dictionary>
	parameterEntities       <Dictionary>
	notations       <Dictionary>
'
!


!DocumentType class methodsFor:'instance creation'!

new

        ^self basicNew initialize
! !

!DocumentType class methodsFor:'class initialization'!

initialize
    PredefinedEntities := Dictionary new
		    at: 'amp' put: (GeneralEntity new name: 'amp'; text: '&#38;');
		    at: 'lt' put: (GeneralEntity new name: 'lt'; text: '&#60;');
		    at: 'gt' put: (GeneralEntity new name: 'gt'; text: (String with: $>));
		    at: 'apos' put: (GeneralEntity new name: 'apos'; text: (String with: $'));
		    at: 'quot' put: (GeneralEntity new name: 'quot'; text: (String with: $"));
		    yourself

    "self initialize"

! !

!DocumentType methodsFor:'accessing'!

attributeFor: key subKey: k2

	| val |
	(val := attributeDefs at: key asString ifAbsent: []) == nil
		ifTrue: [XMLParser invalid: ('The attribute "<1s> <2s>" has not been defined'
							expandMacrosWith: key asString
							with: k2 asString)].
	^val at: k2 asString
		ifAbsent: [XMLParser invalid: ('The attribute "<1s> <2s>" has not been defined'
							expandMacrosWith: key asString
							with: k2 asString)]
!

attributeFor: key subKey: k2 put: value
        "same as parameter entities, first definition counts, do not warn because modern dtds do this
         all the time"
        | dict |
        dict := attributeDefs at: key asString ifAbsentPut: [Dictionary new].
        (dict includesKey: k2 asString)
                ifTrue: [^self].
        (value type isID and: [dict contains: [:attr | attr type isID]])
                ifTrue: [^XMLParser invalid: ('The element <1s> has two attributes typed as ID' expandMacrosWith: key asString)].
        dict at: k2 asString put: value
!

attributesFor: key

	^attributeDefs at: key asString ifAbsent: [Dictionary new]
!

declaredRoot
    ^ declaredRoot
!

declaredRoot:something
    declaredRoot := something.
!

elementDefinitions
    ^ elementDefs
!

elementFor: key
    ^ elementDefs at: key asString ifAbsent:[]
!

elementFor: key put: value

	(elementDefs includesKey: key asString)
		ifTrue: [^self warn: ('The element "<1s>" has been defined more than once'
						expandMacrosWith: key asString)].
	elementDefs at: key asString put: value
!

generalEntityAt: key
	"We do some tricks to make sure that, if the value
	is predefined in the parser, we use the predefined
	value. We could just store the predefined values
	in with the general ones, but we don't want to show
	warnings if the user (very correctly) defines them.
	An enhancement would be to let the user use his own
	values rather than the predefined ones, but we know
	that the predefined ones will be correct--we don't know
	that his will be."

	| val |
	val := PredefinedEntities at: key ifAbsent: [].
	val == nil
		ifTrue: [val := generalEntities at: key ifAbsent: []].
	^val
!

generalEntityAt: key put: value 
        (generalEntities includesKey: key) ifTrue: [ ^self ].
        generalEntities at: key put: value
!

generalEntityAt: key put: value from: anErrorReporter
    (generalEntities includesKey: key) ifTrue: [
        ^ anErrorReporter 
            warn: ((#multipleEntityDefinitions << #xml >> 'The general entity "<1s>" has been defined more than once')
                        expandMacrosWith: key)
    ].
    generalEntities at: key put: value
!

notationAt: name

	^notations at: name ifAbsent: [XMLParser invalid: 'Reference to an undeclared Notation']
!

notationAt: name ifAbsent: aBlock

	^notations at: name ifAbsent: aBlock
!

notationAt: name put: notation

	(notations includesKey: name)
		ifTrue: [XMLParser invalid: 'Duplicate definitions for a Notation'].
	notations at: name put: notation
!

parameterEntityAt: key

	^parameterEntities at: key ifAbsent: []
!

parameterEntityAt: key put: value
        "gj:            against all expectations, in a dtd, it's the first definition of a name that counts.
                         raising a warning might be argued for, though"
        (parameterEntities includesKey: key)
                ifFalse:[parameterEntities at:key put:value]
! !

!DocumentType methodsFor:'encoding'!

acceptVisitor:aCoder with:aParameter
    aCoder visitDocumentType:self with:aParameter
! !

!DocumentType methodsFor:'initialization'!

initialize

        notations := Dictionary new.
        elementDefs := OrderedDictionary new.
        attributeDefs := Dictionary new.
        generalEntities := Dictionary new.
        parameterEntities := Dictionary new.
! !

!DocumentType methodsFor:'private'!

completeValidationAgainst: aParser

	generalEntities keysAndValuesDo: [:eName :entity |
		entity completeValidationAgainst: aParser].
	attributeDefs keysAndValuesDo: [:eName :attribs |
		attribs keysAndValuesDo: [:aName :attrib |
			attrib completeValidationAgainst: aParser]]
!

warn: aString
        "Modified to unify warnings for SAX. REW"
        ^XMLParser warn: aString
! !

!DocumentType class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/DocumentType.st,v 1.21 2009-10-02 00:36:16 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/DocumentType.st,v 1.21 2009-10-02 00:36:16 cg Exp $'
! !

DocumentType initialize!
