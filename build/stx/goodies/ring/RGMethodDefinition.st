"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGElementDefinition subclass:#RGMethodDefinition
	instanceVariableNames:'protocol sourceCode stamp package'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGMethodDefinition comment:'RGMethodDefinition is a concrete representation of methods. It can be used to build browser for methods that are not in the image. It is polymorphic with CompiledMethod. 

* We can ask a RGMethodDefinition for its selector using the selector message.
Example:
	(Point>>#dist:) asRingDefinition selector
		-> #dist

We can also ask the ring object representation of its class or the Smalltalk class actually implementing the corresponding compiledMethod. 

* To access the ring class definition name, use parentName
	aRGMethodDefinition parentName
	
Example:
	(Point>>#dist:) asRingDefinition parentName
		->  #Point
		
* If you have a complete model where classes and methods are ring definition, to access the ring class definition , use parent
	aRGMethodDefinition parent
	
Example:
	aRGMethodDefinition(Point>>#dist:) parent
		->  aRGClassDefinition(Point)
		
* If you want to access the smalltalk class that contains the compiledMethod that is represented by a ringMethodDefinition, use realParent
	aRGMethodDefinition realParent
	
Example:
	(Point>>#dist:) asRingDefinition realParent
		->  Point
		

Now a RingEntityDefinition offers two APIs: one that is generic and works for all the source code entities and this is the one we just 
presented: parent, parentName and realParent. Having such interface is important to build generic tools that could manipulate 
any entities in a polymorphic way (yes no isKindOf: everywhere).

In addition, a ring method definition offers a specific interface that should only be used when you know that you are solely manipulate
specific entity such as class element: method definition, class comment, and variables. 

Here is the equivalence table

	realParent 				realClass
	parent					ringClass
	parentName			className


* The message class returns the class of the object :).

Example:
	(Point>>#dist:) asRingDefinition class
		->  RingMethodDefinition
		
* The message className returns the name of the ring class defining the reingMethodDefinition.

Example:
	(Point>>#dist:) asRingDefinition className
		->  #Point		
		
* If you have a complete model where classes and methods are ring definition, to access the ring class definition , use parent
	aRGMethodDefinition ringClass
	
Example:
	aRGMethodDefinition(Point>>#dist:) ringClass
		->  aRGClassDefinition(Point)
		
		
* If you want to access the smalltalk class that contains the compiledMethod that is represented by a ringMethodDefinition, use realClass
	aRGMethodDefinition realClass
	
Example:
	(Point>>#dist:) asRingDefinition realClass
		->  Point

'
!

!RGMethodDefinition class methodsFor:'instance creation'!

class: aRGBehaviorDefinition selector: aString
    "Create a ring method definition from a ring class and a selector"

    ^(self class: aRGBehaviorDefinition)
        selector: aString asSymbol;
        yourself
!

className: aString selector: aSelector isMetaSide: aBoolean

    ^ (self class: (RGClassDefinition named: aString) selector: aSelector) isMetaSide: aBoolean; yourself
!

realClass: aClass selector: aString
    "Creates a ring method definition from a Smalltalk class and a selector <compiledMethod>"

    ^(aClass >> aString asSymbol) asActiveRingDefinition

    "Modified (format): / 29-08-2015 / 10:25:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RGMethodDefinition class methodsFor:'categories'!

unclassifiedProtocolName
    "Return the string labeling the unclassified protocol."

    ^ 'as yet unclassified'
! !

!RGMethodDefinition class methodsFor:'elements-annotations'!

isExtensionKey 

    ^#isExtension
! !

!RGMethodDefinition methodsFor:'accessing'!

ast
    ^ self parseTree

    "Modified: / 29-08-2015 / 11:20:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

category
    ^ self protocol

    "Modified (format): / 31-08-2015 / 16:38:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

category: anObject
    self protocol: anObject

    "Created: / 31-08-2015 / 16:37:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compiledMethod
    "Retrieves the compiled method of this definition if exists"
    
    | rClass |
    (rClass := self realClass) notNil
        ifTrue: [ (rClass includesSelector: self selector)
            ifTrue: [ ^rClass >> self selector ] ].
            
    ^nil
!

fullName
    "Keeps a unique description for the receiver. As annotation to avoid converting each time is invoked"
    
    ^self annotationNamed: self class fullNameKey
        ifAbsentPut: [ (self parentName, '>>', self selector) asSymbol ]
!

isExtension
    "The receiver is an extension when is defined in a different package to the one of its parent.
    Ring allows to set this property. If not assigned tries to find its value "
    
    ^self 
        annotationNamed: self class isExtensionKey
        ifAbsent: [  
            (self parent notNil and:[ self package notNil ]) ifTrue: [ 
                | value |

                value :=  self parent package ~= self package.
                self annotationNamed: self class isExtensionKey put: value.
                value 
            ] ifFalse: [ 
                self isActive ifTrue:[ 
                    | cm |

                    cm := self compiledMethod.
                    cm isExtension.
                ] ifFalse:[ 
                    false
                ].
            ]
        ]

    "Modified: / 29-08-2015 / 10:23:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isExtension: aBoolean
    "Explicitily set that the receiver is an extension"
    
    self annotationNamed: self class isExtensionKey put: aBoolean 
!

origin
    "Return the real oring of this method."
    | mthd |

    ^ (mthd := self compiledMethod)
        ifNil: [ self methodClass ]
        ifNotNil: [ mthd origin ]
!

package
    "Retrieves the package in which this class is contained, if exists"
    
    ^package
!

package: aRGPackage

    package:= aRGPackage
!

parseTree
    "raise an error: this method should be implemented (TODO)"

    ^ RBParser parseMethod: self sourceCode

    "Created: / 29-08-2015 / 11:20:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

protocol

    self isActive 
        ifTrue: [ ^ self compiledMethod ifNil: [ protocol ] ifNotNil: [ self compiledMethod category ]].
    self isHistorical
        ifTrue: [ ^ self protocolAtPointer ifNil: [ | cm | (cm := self compiledMethod) ifNil: [ protocol ] ifNotNil:[ cm category ] ] ].
    ^ protocol

    "Modified: / 29-08-2015 / 08:20:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

protocol: anObject

    protocol := anObject
!

selector
    "Retrieves the name of the method"

    name isNil ifTrue:[ 
        | src |    

        src := self sourceCode.
        src notNil ifTrue:[ 
            name := RBParser parseMethodPattern: src.  
        ].
    ].
    ^ name

    "Modified: / 29-08-2015 / 11:37:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector: aSymbol
    "The name of a method is known as #selector"

    name := aSymbol
!

source
    ^self sourceCode

    "Created: / 29-08-2015 / 11:19:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source: aString
    self sourceCode: aString

    "Created: / 29-08-2015 / 11:34:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceCode

    self isActive 
        ifTrue: [ ^ self compiledMethod ifNil:[ sourceCode ] ifNotNil: [ self compiledMethod sourceCode ]].
    ^ sourceCode

    "Modified: / 29-08-2015 / 08:03:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceCode: anObject

    sourceCode := anObject
!

stamp

    self isActive 
        ifTrue: [ ^ self compiledMethod timeStamp ].
    ^ stamp

    "Modified: / 29-08-2015 / 08:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stamp: anObject
    "stores an author alias and a timestamp"
    
    stamp := anObject
! !

!RGMethodDefinition methodsFor:'backward compatibility'!

messages

    ^ self method messages
!

method

    ^self compiledMethod
!

methodClass
    "Return the class to which the receiver belongs to."
    
    ^ self realClass
!

symbolic

    ^ self method symbolic
! !

!RGMethodDefinition methodsFor:'comparing'!

<= aRGMethodDefinition
    "Sort method definitions according to: 1. class name - 2. class comment - 3. method selector - 4. timestamp"

    self parentName < aRGMethodDefinition parentName ifTrue: [^true].
    self parentName > aRGMethodDefinition parentName ifTrue: [^false].

    self flag: 'This ugly test is needed right now because the old system is used to represent 
    class comment as method with Comment selector. And to mix comment and methods'.
    aRGMethodDefinition isComment ifTrue: [^false].
    
    ^(self selector < aRGMethodDefinition selector) 
 		  or: [ (self selector == aRGMethodDefinition selector) and: [
    			  self timeStamp <= aRGMethodDefinition timeStamp ]]
!

= aRGMethodDefinition
    "This method look for equality of the key properties of the receiver"


    ^(super = aRGMethodDefinition)
        and: [ self selector == aRGMethodDefinition selector]
!

hash

    ^super hash bitXor: self selector hash
! !

!RGMethodDefinition methodsFor:'managing container'!

addInContainer: aRGContainer

    aRGContainer addMethod: self
    
!

isIncludedInContainer: aRGContainer

    ^aRGContainer includesMethod: self
!

removeFromContainer: aRGContainer

    aRGContainer removeMethod: self
! !

!RGMethodDefinition methodsFor:'metrics'!

numberOfLinesOfCode

    ^ self annotationNamed: #numberOfLinesOfCode ifAbsentPut: [ self sourceCode lineCount ]
! !

!RGMethodDefinition methodsFor:'operations'!

recompile
    self method recompile
! !

!RGMethodDefinition methodsFor:'printing'!

printOn: aStream 

    self parentName ifNotNil: [
        aStream nextPutAll: self parentName;
                  nextPutAll: '>>' ].
    aStream print: self selector
! !

!RGMethodDefinition methodsFor:'source pointers'!

getPreambleFrom: aFileStream at: position
    ^ SourceFiles getPreambleFrom: aFileStream at: position
!

protocolAtPointer
    "A RGMethodDefinition that was set as historical will retrieve the protocol using the sourcePointer"

    self shouldNotImplement. "/ No source pointers in Smalltalk/X    
"/    ^ self sourcePointer notNil
"/        ifTrue: [ SourceFiles protocolAt: self sourcePointer ]
"/        ifFalse:[ nil ]

    "Modified: / 29-08-2015 / 08:02:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceCodeAtPointer
    "A RGMethodDefinition that was set as historical will retrieve the sourceCode using the sourcePointer"

    self shouldNotImplement. "/ No source pointers in Smalltalk/X
"/    ^ self sourcePointer notNil
"/        ifTrue: [ SourceFiles sourceCodeAt: self sourcePointer ]
"/        ifFalse:[ nil ]

    "Modified: / 29-08-2015 / 08:02:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePointer
    "Retrieves the sourcePointer for this definition if exists"

    self shouldNotImplement. "/ No source pointers in Smalltalk/X    
"/    ^self annotationNamed:  self class sourcePointerKey

    "Modified: / 29-08-2015 / 08:02:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePointer: aNumber

    self shouldNotImplement. "/ No source pointers in Smalltalk/X
"/    self annotationNamed:  self class sourcePointerKey put: aNumber

    "Modified: / 29-08-2015 / 08:02:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stampAtPointer  
    "A RGMethodDefinition that was set as historical will retrieve the stamp using the sourcePointer"

    self shouldNotImplement. "/ No source pointers in Smalltalk/X
"/    ^ self sourcePointer notNil
"/        ifTrue: [ SourceFiles timeStampAt: self sourcePointer ]
"/        ifFalse:[ nil ]

    "Modified: / 29-08-2015 / 08:03:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RGMethodDefinition methodsFor:'stamp values'!

author 

    ^self 
        annotationNamed: self class authorKey
        ifAbsentPut: [ self class parseAuthorAliasFrom: self stamp ]
!

author: aString 

    self annotationNamed: self class authorKey put: aString 
!

timeStamp 

    ^self annotationNamed: self class timeStampKey 
        ifAbsentPut: [ self class 
                            parseTimestampFrom: self stamp 
                            default: (Timestamp epoch) ]

    "Modified: / 25-09-2015 / 19:05:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timeStamp: aTimestamp 

    self annotationNamed: self class timeStampKey put: aTimestamp 
! !

!RGMethodDefinition methodsFor:'testing'!

hasStamp

    ^stamp isEmptyOrNil not
!

isAbstract
    ^ self compiledMethod isAbstract
!

isDefined
    "Answer whether the receiver exists in the environment"
    
    | rClass |
    self selector isDoIt ifTrue:[ ^false ].
    rClass := self realClass.
    ^rClass notNil and: [ rClass includesSelector: self selector ]
!

isFromTrait

    "Return true for methods that have been included from Traits"
    ^ self origin isTrait and: [ self origin ~= self methodClass ]
!

isLocalSelector
    "Answer whether the receiver exists in the environment as a local implementation"
    
    | rClass |
    rClass:= self realClass.
    ^rClass notNil and: [ rClass includesLocalSelector: self selector ]
!

isMethod

    ^true
!

isOverridden
    ^ self compiledMethod isOverridden
!

isSameRevisionAs: aRGMethodDefinition
    "This method look for equality of the properties of the receiver"
    "Stamp is ignored as in many cases a method is saved without containing any change. However it appears as changed due to a different stamp"
    self flag: 'needs to be evaluated'.

    ^(super isSameRevisionAs: aRGMethodDefinition)
        and: [ self selector = aRGMethodDefinition selector 
            and: [ self protocol = aRGMethodDefinition protocol
                and: [ self sourceCode = aRGMethodDefinition sourceCode ] ] ]
! !

!RGMethodDefinition methodsFor:'to remove as soon as possible'!

classIsMeta

    ^self isMetaSide
!

isValid
    "verifies that the receiver is locally defined in the class and that is not a DoIt"

    ^self isDefined
! !

!RGMethodDefinition methodsFor:'traits'!

argumentNames
    "Return an array with the argument names of the method's selector"

    ^ self compiledMethod argumentNames
!

isBinarySelector
    ^self selector
        allSatisfy: [:each | each isSpecial]
! !

!RGMethodDefinition methodsFor:'type of methods'!

asActive

    "Sets the receiver as active object, which will allow itself to retrieve its data from the compiled method"
    self annotationNamed: self class statusKey put: #active
!

asHistorical
    "Sets the receiver as historical object, which will allow itself to retrieve its data using the sourcePointer"
    self annotationNamed: self class statusKey put: #historical.
    sourceCode isNil ifTrue:[
        | compiledMethod |
        compiledMethod := self compiledMethod.
        compiledMethod notNil ifTrue: [
            sourceCode := compiledMethod sourceCode 
        ].
    ]

    "Modified: / 29-08-2015 / 08:00:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asPassive

    "Sets the receiver as passive object, which will allow itself to retrieve its data that was assigned in its creation"
    self annotationNamed: self class statusKey put: #passive
!

fromActiveToHistorical
    "If the receiver was generated as an active method, it can be converted to a historical one by reading the data of the compiled method (if exists)"
    
    self isActive ifTrue: [
        self asHistorical ]
!

fromActiveToPassive
    "If the receiver was generated as an active method, it can be converted to a passive one by reading the data of the compiled method (if exists)"

    | compiledMethod |
    self isActive
        ifFalse: [ ^ self ].
    compiledMethod := self compiledMethod.
    compiledMethod notNil
        ifTrue: [ 
            self protocol: compiledMethod category.
            self sourceCode: compiledMethod sourceCode.
            self stamp: compiledMethod timeStamp ].
    self asPassive
!

isActive

    "A ring method isActive when it needs to access the compiledMethod for retrieving its data"

    | status |

    ^(status := self annotationNamed: self class statusKey) isNil
        ifTrue:[ false ] 
        ifFalse:[ status == #active ]
!

isHistorical
    "A ring method can be used to point an old version of the receiver, in this case it will use the sourcePointer to retrieve its information"
   
    | status |

    ^(status := self annotationNamed: self class statusKey) isNil
        ifTrue:[ false ] 
        ifFalse:[ status == #historical ]
!

isPassive
    "A ring method isPassive when it retrieves the data that was assigned in its creation.
    By default is passive"

   | status |

    ^(status := self annotationNamed: self class statusKey) isNil
        ifTrue:[ false ] 
        ifFalse:[ status == #passive ]
! !


