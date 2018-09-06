"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MethodReference
	instanceVariableNames:'classSymbol classIsMeta methodSymbol stringVersion category'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Tools'
!

MethodReference comment:'A MethodReference is is a lightweight proxy for a CompiledMethod.  Has methods for pointed to the CompileMethod''s source statements, byte codes. Is heavily used my Tools.

Instance Variables
	classIsMeta:		     Boolean class vs. instance
	classSymbol:		Symbol for method''s class (without class keyword if meta)
	methodSymbol:		Symbol for method''s selector
	stringVersion:		''Class>>selector:'' format

'
!


!MethodReference class methodsFor:'instance creation'!

class: aClass selector: aSelector
	^ self new setStandardClass: aClass methodSymbol: aSelector
! !

!MethodReference methodsFor:'*Kernel-Traits'!

actualClass 

	| actualClass |

	actualClass := Smalltalk at: classSymbol ifAbsent: [^nil].
	classIsMeta ifTrue: [^actualClass classSide].
	^actualClass

! !

!MethodReference methodsFor:'*OB-Standard'!

asNode
	^ OBMethodNode on: self
! !

!MethodReference methodsFor:'*fixunderscores'!

fixLFInvisible
	"Replace invisible with space. Answer true if fixed or no fix necessary, false if manual fix required"

	| src ts |
	"Check if we do need to do anything"
	src := self actualClass sourceCodeAt: methodSymbol.
	(src includes: Character lf) ifFalse: [^true].

	"Chicken out if there is a literal underscore"
	"cm := self actualClass compiledMethodAt: methodSymbol.
	(cm hasLiteralSuchThat: [:lit | 
		lit = Character lf or: [lit isString and: [lit includes: Character lf]]]) ifTrue: [^false]."

	"Otherwise, replace underscores with :="
	src := src copyReplaceAll: Character lf asString with: Character space asString, Character cr asString.
	ts := self timeStamp.
	ts = '' ifTrue: [ts := nil].
	self actualClass 
		compile: src
		classified: ClassOrganizer default
		withStamp: ts 
		notifying: nil.

	^true
!

fixUnderscores
	"Replace underscores with :=. Answer true if fixed or no fix necessary, false if manual fix required"

	| src cm ts |
	"Check if we do need to do anything"
	src := self actualClass sourceCodeAt: methodSymbol.
	(src includes: $_) ifFalse: [^true].

	"Chicken out if there is a literal underscore"
	cm := self actualClass compiledMethodAt: methodSymbol.
	(cm hasLiteralSuchThat: [:lit | 
		lit = $_ or: [lit isString and: [lit includes: $_]]]) ifTrue: [^false].

	"Otherwise, replace underscores with :="
	src := src copyReplaceAll: '_' with: ':='.
	ts := self timeStamp.
	ts = '' ifTrue: [ts := nil].
	self actualClass 
		compile: src
		classified: ClassOrganizer default
		withStamp: ts 
		notifying: nil.

	^true
! !

!MethodReference methodsFor:'*monticello'!

asMethodDefinition
	^ MCMethodDefinition forMethodReference: self
!

compiledMethod
	^ self actualClass compiledMethodAt: methodSymbol
!

isLocalSelector
        ^self actualClass
                "/ includesLocalSelector: self methodSymbol
                implements: self methodSymbol
!

source
        ^ (self actualClass sourceCodeAt: methodSymbol) asString asStringWithSqueakLineEndings

    "Modified: / 12-09-2010 / 16:06:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timeStamp
	^ self compiledMethod timeStamp
! !

!MethodReference methodsFor:'*packageinfo-base'!

sourceCode
	^ self actualClass sourceCodeAt: methodSymbol
! !

!MethodReference methodsFor:'comparisons'!

<= anotherMethodReference

	classSymbol < anotherMethodReference classSymbol ifTrue: [^true].
	classSymbol > anotherMethodReference classSymbol ifTrue: [^false].
	classIsMeta = anotherMethodReference classIsMeta ifFalse: [^classIsMeta not].
	^methodSymbol <= anotherMethodReference methodSymbol
!

= anotherMethodReference 
	"Answer whether the receiver and the argument represent the 
	same object."
	^ self species == anotherMethodReference species
		and: [self classSymbol = anotherMethodReference classSymbol]
		and: [self classIsMeta = anotherMethodReference classIsMeta]
		and: [self methodSymbol = anotherMethodReference methodSymbol]
!

hash
	"Answer a SmallInteger whose value is related to the receiver's  
	identity."
	^ (self species hash bitXor: self classSymbol hash)
		bitXor: self methodSymbol hash
! !

!MethodReference methodsFor:'queries'!

asStringOrText

	^stringVersion
!

category
	^ category ifNil: [category := self actualClass organization categoryOfElement: methodSymbol]
!

classIsMeta

	^classIsMeta
!

classSymbol

	^classSymbol
!

isValid
	"Answer whether the receiver represents a current selector or Comment"

	| aClass |
	methodSymbol isDoIt ifTrue: [^ false].
	(aClass := self actualClass) ifNil: [^ false].
	^ (aClass includesSelector: methodSymbol) or:
		[methodSymbol == #Comment]
!

methodSymbol

	^methodSymbol
!

printOn: aStream
        "Print the receiver on a stream"

        "super printOn: aStream."
        aStream nextPutAll: '"REF" ', self actualClass name, ' >> #', methodSymbol

    "Modified: / 12-09-2010 / 19:03:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceString
	^ (self actualClass sourceCodeAt: self methodSymbol) asString
! !

!MethodReference methodsFor:'setting'!

setClass: aClass methodSymbol: methodSym stringVersion: aString 

	classSymbol := aClass theNonMetaClass name.
	classIsMeta := aClass isMeta.
	methodSymbol := methodSym.
	stringVersion := aString.
!

setClassAndSelectorIn: csBlock

	^csBlock value: self actualClass value: methodSymbol
!

setClassSymbol: classSym classIsMeta: isMeta methodSymbol: methodSym stringVersion: aString 

	classSymbol := classSym.
	classIsMeta := isMeta.
	methodSymbol := methodSym.
	stringVersion := aString.
!

setStandardClass: aClass methodSymbol: methodSym

	classSymbol := aClass theNonMetaClass name.
	classIsMeta := aClass isMeta.
	methodSymbol := methodSym.
	stringVersion := aClass name , ' ' , methodSym.
! !

!MethodReference methodsFor:'string version'!

category: aString
	
	 category := aString
!

stringVersion

	^stringVersion
!

stringVersion: aString

	stringVersion := aString
! !

!MethodReference class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MethodReference.st,v 1.2 2014-12-21 13:08:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MethodReference.st,v 1.2 2014-12-21 13:08:18 cg Exp $'
!

version_SVN
    ^ '$Id: MethodReference.st,v 1.2 2014-12-21 13:08:18 cg Exp $'
! !

