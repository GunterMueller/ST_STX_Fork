"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCClass
	instanceVariableNames:'methodDictionary currentMethod constants idGen options
		methodStack returnVariable properties'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Compiler-Codegen'
!

!PPCClass class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPCClass methodsFor:'accessing'!

options: args
    options := args
!

constants
    ^ constants
!

currentMethod
    ^ currentMethod 
!

currentNonInlineMethod
    ^ methodStack 
        detect:[:m | m isInline not ] 
        ifNone:[ self error: 'No non-inlined method']

    "Created: / 23-04-2015 / 17:33:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentReturnVariable
    ^ currentMethod returnVariable 
!

idGen
    ^ idGen
!

idGen: anObject
    idGen := anObject
!

ids
    ^ idGen ids
!

methodDictionary
    ^ methodDictionary
!

name
    ^ self propertyAt: #name
!

name: value
    ^ self propertyAt: #name put: value
!

superclass
    ^ self propertyAt: #superclass
!

superclass: value
    ^ self propertyAt: #superclass put: value
! !

!PPCClass methodsFor:'accessing-properties'!

hasProperty: aKey
    "Test if the property aKey is present."
    
    ^ properties notNil and: [ properties includesKey: aKey ]
!

properties
    ^ properties
!

properties: aDictionary
    properties := aDictionary 
!

propertyAt: aKey 
    ^ self propertyAt: aKey  ifAbsent: [ nil ]
!

propertyAt: aKey ifAbsent: aBlock
    "Answer the property value associated with aKey or, if aKey isn't found, answer the result of evaluating aBlock."
    
    ^ properties isNil
        ifTrue: [ aBlock value ]
        ifFalse: [ properties at: aKey ifAbsent: aBlock ]
!

propertyAt: aKey ifAbsentPut: aBlock
    "Answer the property associated with aKey or, if aKey isn't found store the result of evaluating aBlock as new value."
    
    ^ self propertyAt: aKey ifAbsent: [ self propertyAt: aKey put: aBlock value ]
!

propertyAt: aKey put: anObject
    "Set the property at aKey to be anObject. If aKey is not found, create a new entry for aKey and set is value to anObject. Answer anObject."

    ^ (properties ifNil: [ properties := Dictionary new: 1 ])
        at: aKey put: anObject
! !

!PPCClass methodsFor:'constants'!

addConstant: value as: name    
    (constants includesKey: name) ifTrue:[ 
        (constants at: name) ~= value ifTrue:[ 
            self error:'Duplicate constant!!'.
        ].
        ^ self.
    ].
    constants at: name put: value

    "Modified: / 29-05-2015 / 07:22:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCClass methodsFor:'ids'!

asSelector: string
    "e.g. '234znak 43 ) 2' asLegalSelector = #v234znak432"
    
    | toUse |

    toUse := string select: [:char | char isAlphaNumeric or: [ char = $_ ] ].
    (toUse isEmpty or: [ toUse first isLetter not ])
        ifTrue: [ toUse := 'v', toUse ].
    toUse first isUppercase ifFalse:[
        toUse := toUse copy.
        toUse at: 1 put: toUse first asLowercase
    ].
    ^toUse

    "Modified: / 10-05-2015 / 07:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

idFor: anObject
    ^ idGen idFor: anObject
!

idFor: anObject defaultName: defaultName
    ^ idGen idFor: anObject defaultName: defaultName
!

numberIdFor: object
    ^ idGen numericIdFor: object
! !

!PPCClass methodsFor:'initialization'!

initialize
    super initialize.

    methodStack := Stack new.
    methodDictionary := IdentityDictionary new.
    constants := Dictionary new.
    idGen := PPCIdGenerator new.
! !

!PPCClass methodsFor:'method cache'!

cachedMethod: id
    ^ methodDictionary at: id ifAbsent: [ nil ]
!

cachedMethod: id ifPresent: aBlock
    ^ methodDictionary at: id ifPresent: aBlock
!

store: method as: id
    self assert: (method isKindOf: PPCMethod).
    methodDictionary at: id put: method.
! !

!PPCClass methodsFor:'support'!

parsedValueOf: aBlock to: aString
    | tmpVarirable method |

    self assert:aBlock isBlock.
    self assert:aString isNil not.
    tmpVarirable := returnVariable.
    returnVariable := aString.
    method := [
        aBlock value
    ] ensure:[ returnVariable := tmpVarirable ].

    self assert: (method isMethod).	
    ^ method
!

pop
    | retval |
    retval := methodStack pop.
    currentMethod := methodStack isEmpty 
        ifTrue: [ nil ]
        ifFalse: [ methodStack top ].
    ^ retval

    "Modified: / 21-11-2014 / 12:27:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

push
    methodStack push: currentMethod.
    (methodStack size > 500 )ifTrue: [ self error: 'unless it is very complex grammar, there is an error somewhere' ]

    "Modified: / 21-11-2014 / 12:27:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

returnVariable
    self error: 'Should never be called and accessed outside this class'.
    ^ returnVariable 
!

startInline
    | indentationLevel |
    indentationLevel := currentMethod indentationLevel.
    
    currentMethod := PPCInlinedMethod new.
    currentMethod returnVariable: returnVariable.
    currentMethod indentationLevel: indentationLevel.
    self push.

    "Modified: / 01-06-2015 / 21:48:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startInline: id
    | indentationLevel |
    (methodDictionary includesKey: id) ifTrue: [ self error: 'OOOUPS!!' ].
    indentationLevel := currentMethod indentationLevel.
    
    currentMethod := PPCInlinedMethod new.
    currentMethod id: id.   
    currentMethod returnVariable: returnVariable.
    currentMethod indentationLevel: indentationLevel.
    self push.

    "Modified: / 01-06-2015 / 21:48:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startMethod: id category: category
    (methodDictionary includesKey: id) ifTrue: [ self error: 'OOOUPS!!' ].

    currentMethod := PPCMethod new.
    currentMethod id: id.
    currentMethod category: category.
    
    self push.      
    self store: currentMethod as: id.

    "Modified: / 01-06-2015 / 21:19:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stopInline
    ^ self pop.

    "Modified: / 01-06-2015 / 21:37:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stopMethod
   self store: currentMethod as: currentMethod methodName.
	^ self pop.
! !

!PPCClass methodsFor:'variables'!

allocateReturnVariable    
    ^ self allocateReturnVariableNamed: 'retval'

    "Created: / 23-04-2015 / 18:03:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-06-2015 / 17:52:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allocateReturnVariableNamed: name
    "Allocate (or return previously allocated one) temporary variable used for
     storing a parser's return value (the parsed object)"                 
    ^ currentMethod allocateReturnVariableNamed: name

    "Created: / 15-06-2015 / 18:04:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allocateTemporaryVariableNamed: preferredName 
    "Allocate a new variable with (preferably) given name.
     Returns a real variable name that should be used."
    
    ^ self currentNonInlineMethod allocateTemporaryVariableNamed: preferredName

    "Created: / 23-04-2015 / 17:33:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

