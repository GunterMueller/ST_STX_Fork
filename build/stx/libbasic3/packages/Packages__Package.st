"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

AbstractPackage subclass:#Package
	instanceVariableNames:'packageHandler packagedClasses packagedMethods packageComment
		prerequisites scripts isDirty isInstalled packageVersion
		overriddenClassChanges overriddenMethodChanges blockedMethods'
	classVariableNames:''
	poolDictionaries:''
	category:'Package'
!

Package class instanceVariableNames:'CurrentPackage'

"
 No other class instance variables are inherited by this class.
"
!

Object subclass:#PackagedClass
	instanceVariableNames:'name package instanceDefinition classDefinition
		instanceVariableNames classVariableNames
		classInstanceVariableNames poolDictionaries category'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Package
!

Object subclass:#ClassSide
	instanceVariableNames:'instanceSide'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Package::PackagedClass
!

Object subclass:#PackagedMethod
	instanceVariableNames:'name package category source ownedClassName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Package
!

Object subclass:#PackagedScript
	instanceVariableNames:'string receiver'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Package
!

!Package class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    documentation to be added.

    [author:]
	 (james@miraculix)

    [instance variables:]

	blockedMethods                <Dictionary>
					    A reference of methods that the receiver is NOT responsible for
					    but the receiver is responsible for the method's class. It usage is
					    the same as a filter would be.

	overriddenChanges                <Dictionary1><Dictionary2><Dictionary3>
					    This variable helps the receiver keep its original state. When a
					    method changes it is held here so we can get the original. So the package
					    is still responsible for the overridden changes.

					    There are two way items can become added to overriddenChanges:
						1) through loading packages - too many of these may not be desirable.
						2) through editing a package - default package 'overrides it!!'

					    DESIGN: it is designed with dictionaries containing dictionaries as - for the
						time being - to cope with different types of change. At the moment being
						methodChanges (and soon classChanges). It is easier to search for changes
						by using this hierarchy of dictionaries, and - i think - it is quite
						extendable.
						The only problem i can see with it is lingering dictionaries which are not deleted
						when they contain nothing.





    [class variables:]

    [see also:]

"
!

examples
"

   more  examples to be added:
								[exBegin]
    ... add code fragment for
    ... executable example here ...
								[exEnd]
"
!

history
    "Created: / 31.3.2003 / 16:45:04 / james"
! !

!Package class methodsFor:'instance creation'!

named:aString
    "create a new package named aString "
    ^ self named:aString asSymbol addToManager:nil.    "or 'self defaultPackageManager'"
!

named:aString addToManager:aManager
    ^ self named:aString withClasses:nil withMethods:nil addToManager:aManager
!

named:aString withClasses:classes
    ^ self named:aString withClasses:classes withMethods:nil addToManager:nil
!

named:aString withClasses:classes withMethods:methods addToManager:aManager
    "create a new package named aString "
    |anInstance |
    anInstance := self new name:aString.
    classes ifNotNil:[
	anInstance addedClasses:classes.
    ].
    methods ifNotNil:[
	anInstance addedMethods:methods.
    ].

    aManager ifNotNil:[
	aManager addPackage:anInstance.
    ].
    ^ anInstance
!

named:aString withMethods:methods
    ^ self named:aString withClasses:nil withMethods:methods addToManager:nil
! !

!Package class methodsFor:'defaults'!

defaultBlockedMethodsCollection
    ^ Dictionary new
!

defaultOverriddenChangesCollection
    "a dictionary of sets. The keys are the classes and
    the sets are a collection of selectors!!"
    ^ Dictionary new
!

defaultPackagedClassesCollection
    ^ Dictionary new
!

defaultPackagedMethodsCollection
    ^ Dictionary new
!

defaultPrerequisiteCollection
    ^ PrerequisiteCollection new
!

defaultScriptsCollection
    ^ IdentityDictionary new
!

newDefaultPackage
    ^ self named:(Project noProjectID).
!

packageManager
    ^ self packageManagerClass smalltalkPackageManager.
!

packageManagerClass
    ^ PackageManager.
! !

!Package class methodsFor:'private - instance creation'!

new
    "creates a new package and initialize's"
    | anInstance |
    anInstance := self basicNew initialize.
    ^ anInstance
! !

!Package methodsFor:'accessing'!

blockedMethods
    "return the value of the instance variable 'blockedMethods' (automatically generated)"

    ^ blockedMethods
!

blockedMethods:something
    "set the value of the instance variable 'blockedMethods' (automatically generated)"

    blockedMethods := something.
!

blockedMethodsAtClassNamed:arg
    ^ (blockedMethods at:arg ifAbsent:[nil])
!

blockedMethodsAtClassNamed:aClassName ifAbsentPut:anObject
    ^ blockedMethods at:aClassName ifAbsentPut:anObject
!

blockedMethodsRemoveAtClassNamed:arg ifAbsent:aBlock
    ^ (blockedMethods removeKey:arg ifAbsent:aBlock)
!

classNames
    ^ self packagedClasses values collect:[:aPackagedClass |
	aPackagedClass name
    ].
!

classPrerequisites
    ^ prerequisites select:[:aPre |
	aPre isClassPrerequisite
    ].

!

filename
    "return the value of the instance variable 'filename' (automatically generated)"

    ^ packageHandler filename
!

getInterestedMethodsFromClass:aClass
    | aClassName |
    aClassName := aClass name.
    ^ aClass methodDictionary copy values select:[:aMethod |
	self definesSelector:aMethod name forClassNamed:aClassName
    ]
!

getInterestedPackagedMethodsFromClass:aClass
    | aClassName aPackagedClass|

    aClassName := aClass name.
    (aPackagedClass := self packagedClassNamed:aClassName) ifNotNil:[
	^ aPackagedClass packagedMethods
    ].

    ^ (packagedMethods at:aClassName ifAbsent:[^ OrderedCollection new ]) values
"/    ^ aClass methodDictionary copy values collectAndselect:[:aMethod |
"/        self definesSelector:aMethod name forClassNamed:aClassName
"/    ]
"/

!

isDirty
   "has the receiver been changed by adding scripts or added classes since the
    time it is loaded. This instance variable is NOT affected by changes in the image!!
    but it could be worked out by looking at the receivers variables!!"

   ^ isDirty "? true" "not needed because set by initialize"
!

isDirty:aBoolean
    isDirty := aBoolean
!

isInstalled
    "return the value of the instance variable 'isInstalled' (automatically generated)"

    ^ isInstalled
!

isInstalled:something
    "set the value of the instance variable 'isInstalled' (automatically generated)"

    isInstalled := something.
!

looseMethodAtClass:aClassName atMethodName:aMethodName
    self looseMethods do:[:aLooseMethod |
	((aLooseMethod name == aMethodName) and:[
	    aLooseMethod className == aClassName]) ifTrue:[
		^ aLooseMethod
	].

    ].
    ^ nil
!

looseMethods
    | col mthdInImage |
    col := OrderedCollection new.
    self packagedMethods keysAndValuesDo:[:key :aDic | | looseMethodsInKey|

	looseMethodsInKey := aDic keysAndValuesDo:[:selector :aPackagedMethod  | |collectValue|
	    aPackagedMethod isLoose ifTrue:[
		mthdInImage := aPackagedMethod methodInImage.
		   col add:aPackagedMethod.
	    ].
	].

    ].

    ^ col.
!

packageComment
    "return the value of the instance variable 'packageComment' (automatically generated)"

    ^ packageComment
!

packageComment:something
    "set the value of the instance variable 'packageComment' (automatically generated)"

    packageComment := something.
!

packageHandler
    "return the value of the instance variable 'packageHandler' (automatically generated)"

    packageHandler isNil ifTrue:[
	packageHandler := PackageHandler forPackage:self.
    ].
    ^ packageHandler
!

packageHandler:something
    "set the value of the instance variable 'packageHandler' (automatically generated)"

    packageHandler := something.
!

packagePrerequisites
    ^ prerequisites select:[:aPre |
	aPre isPackagePrerequisite
    ].

!

packageType
    ^ 'STX Package' copy.
!

packageVersion
    "return the value of the instance variable 'packageVersion' (automatically generated)"

    ^ packageVersion
!

packageVersion:something
    "set the value of the instance variable 'packageVersion' (automatically generated)"

    packageVersion := something.
!

packagedClasses
    "return the value of the instance variable 'packagedClasses' (automatically generated)"

    ^ packagedClasses
!

packagedMethods
    "return the value of the instance variable 'packagedMethods' (automatically generated)"

    ^ packagedMethods
!

packagedMethodsAtClassName:arg ifAbsent:aBlock
    ^ (packagedMethods at:arg ifAbsent:aBlock)
!

packagedMethodsAtClassNamed:arg
    ^ (self packagedMethodsAtClassNamed:arg ifAbsent:[])
!

packagedMethodsAtClassNamed:arg ifAbsent:aBlock
    ^ (packagedMethods at:arg ifAbsent:aBlock)
!

packagedMethodsAtClassNamed:arg ifAbsentPut:aBlock
    ^ (packagedMethods at:arg ifAbsentPut:aBlock)
!

packagedMethodsForClass:arg ifAbsent:aBlock
    ^ (packagedMethods at:arg ifAbsent:aBlock)
!

prerequisites
    "return the value of the instance variable 'prerequisites' (automatically generated)"

    ^ prerequisites
!

scripts
    "return the value of the instance variable 'scripts' (automatically generated)"

    ^ scripts
! !

!Package methodsFor:'adding & removing'!

addBlockedMethodNamed:aMethodName forClassNamed:aClassName
    ^ (self blockedMethodsAtClassNamed:aClassName ifAbsentPut:[Set new]) add:aMethodName.
!

addOverriddenClassChange:aPackagedClass byPackageNamed:byPackageName
    "add an overridden method. under #package -> #className -> #classChangeNamespace -> aPackagedClass"
    | className |
    self assert:(byPackageName isSymbol).
    className := aPackagedClass name.

    ((overriddenClassChanges at:byPackageName ifAbsentPut:[Set new])
	add:className)
!

addOverriddenMethodChange:aPackagedMethod byPackageNamed:byPackageNamed
    "add an overridden method. under #package -> #methodClassName -> #packagedMethod"
    | methodClassName |
    methodClassName := aPackagedMethod ownedClassName.
    "so that we have this method stored"
    self addPackagedMethod:aPackagedMethod.

    (((overriddenMethodChanges at:byPackageNamed ifAbsentPut:[Dictionary new])
	at:methodClassName ifAbsentPut:[Set new]) add:aPackagedMethod name)
!

addPackagedClass:aPackagedClass
    "adds a class to the receiver.
     NOTE: Does not mark the receiver as dirty.
     That is the responsibility of the called of this method!!"
    aPackagedClass isClass ifTrue:[
	self error:'I am expected a PackagedClass not a Class'.
    ].
    self packagedClasses at:aPackagedClass name put:(aPackagedClass).
    ^ aPackagedClass
!

addPackagedMethod:aPackagedMethod
    "add or replace aPackagedMethod from the receiver"
    | aPackagedMethodsOwnedClass |
    aPackagedMethodsOwnedClass := aPackagedMethod ownedClassName.
    ^ (self packagedMethodsAtClassNamed:aPackagedMethodsOwnedClass ifAbsentPut:[Dictionary new])
		at:aPackagedMethod name put:aPackagedMethod.
!

addPackagedMethods:somePackageMethods

    somePackageMethods do:[:aPackageMethod |
	self addPackagedMethod:aPackageMethod copy.
    ].
    ^ somePackageMethods
!

addPrerequisite:aPrerequisite
    prerequisites add:aPrerequisite
!

addedPackagedClasses:somePackagedClasses
    somePackagedClasses do:[:each |
	self addedPackagedClass:each
    ].
    ^ somePackagedClasses
!

packagedClassesRemoveAtClassName:aKey ifAbsent:aBlock
    ^ self packagedClasses removeKey:aKey ifAbsent:aBlock
!

removeBlockedMethodNamed:aMethodName forClassNamed:aClassName
    ^ (self blockedMethodsAtClassNamed:aClassName) remove:aMethodName.
!

removeBlockedMethodsForClassNamed:aClassName ifAbsent:aBlock
    ^ (blockedMethods removeKey:aClassName ifAbsent:aBlock).
!

removeOverriddenMethodNamed:aMethodName forClassNamed:aClassName
    ^ self
	removeOverriddenMethodNamed:aMethodName
	forClassNamed:aClassName
	ifAbsent:[self error:'trying to remove a method that does not exist!!'"should i keep this?"]
!

removeOverriddenMethodNamed:aMethodName forClassNamed:aClassName ifAbsent:aBlock

    | dictionaryOfMethodNamesAndPackagedMethods removedPackagedMethod|

    overriddenMethodChanges values do:[:aDictionaryOfClassNamesAndPackagedMethods |
	(dictionaryOfMethodNamesAndPackagedMethods :=
	    aDictionaryOfClassNamesAndPackagedMethods at:aClassName ifAbsent:[nil]).
	dictionaryOfMethodNamesAndPackagedMethods ifNotNil:[
	    removedPackagedMethod := (dictionaryOfMethodNamesAndPackagedMethods remove:aMethodName ifAbsent:[nil]).
	    removedPackagedMethod ifNotNil:[  "once found it can just exit as there should not be any more here!!"
		^ self
	    ].
	].

    ].
!

scriptAt:aSymbol
    ^ scripts at:aSymbol ifAbsent:[PackagedScript string:(String new) receiver:self]
!

scriptAt:aSymbol put:aString
    scripts at:aSymbol put:aString
! !

!Package methodsFor:'adding & removing - basic'!

basicAddedClass:aClass
    "add a representation of a class (PackagedClass) to the receiver.
    Look in aClass to see if we need to add any blocked methods - this could
    be done by the manager but is done locally to avoid too many message sends"
    | newPackagedClass |
    self assert:(aClass isMeta not).
    newPackagedClass := (self newPackagedClass:aClass).
    self basicAddedPackagedClass:newPackagedClass.

    (aClass methodDictionary copy) keysAndValuesDo:[:aMethodName :aMethod |
	(aMethod package == self name) ifFalse:[
	    newPackagedClass addBlockedMethodNamed:aMethodName.
	].
    ].
    ^ aClass


!

basicAddedMethod:aMethod
    "needed for as it does not have a change notification and does not mark the receiver
    as dirty"
    | aPackagedMethod aMethodName aMethodClassName|

    aMethodClassName :=  aMethod mclass name asSymbol.
    aMethodName := aMethod name.

    (self includesPackagedClassNamed:aMethodClassName) ifTrue:[
	^ (self packagedClassNamed:aMethodClassName) addMethodNamed:aMethodName
    ].

    aPackagedMethod := (self newPackagedMethodSelector:aMethodName className:aMethodClassName source:aMethod source).

    self addPackagedMethod:aPackagedMethod.

    ^ aPackagedMethod "if nil, the method is still to be installed. Could use a dummy here instead??"
!

basicAddedPackagedClass:aPackagedClass
    "Add a class to a package. Return the aClass.
    This only works when 'aClass package == name' if not and error will occur.
    This method is called only AFTER the class package has changed!! This class
    is NOT responsible for changing values in classes!!
    "
    | aPackagedClassName |
    aPackagedClassName := aPackagedClass name.
    self assert:(aPackagedClassName isSymbol).
    (aPackagedClass package == self) ifFalse:[
	self error:'Cannot add ', aPackagedClassName, ' to package ''', name,
	    ''' as the class ',  aPackagedClassName, Character cr asString,
	    ' belongs in the package''', aPackagedClass package name asString,''''.
    ].
    (self includesPackagedClassNamed:aPackagedClass name) ifTrue:[
	(self overriddenClassChangesIncludesClassNamed:aPackagedClass name) ifFalse:[
	    PackageError raiseAddedClassFailedNamed:aPackagedClass name toPackage:self.
	].
    ].

    self removeOverriddenClassNamed:aPackagedClassName ifAbsent:[nil].
    self removeBlockedMethodsForClassNamed:aPackagedClassName ifAbsent:[nil].
    self packagedClasses at:aPackagedClassName put:(aPackagedClass).
    ^ aPackagedClass
!

basicRemoveClassNamed:aSymbol

    packagedClasses removeKey:aSymbol ifAbsent:[
	"how much information do i need to recover from this error?"
	PackageError raiseCannotRemoveClassNamed:aSymbol fromPackage:self
	"'Cannot remove packagedClass ', aSymbol asString,
	    ' from package: ', name string."
    ].
    self blockedMethodsRemoveAtClassNamed:aSymbol ifAbsent:[nil "a blocked method is not always there!!"].
    self removeOverriddenClassNamed:aSymbol ifAbsent:[nil "a overridden class is not always there!!"].
    ^ aSymbol
!

basicRemoveMethodNamed:aMethodName forClassNamed:aClassName ifAbsent:aBlock
    "remove method named aMethodName from the receiver. If it is in loose methods, remove it,
    if the receiver just owns the class, add it to the blockedMethods if teh blockedMethods already have it,
    evaluate aBlock"
    | aPackagedMethod |
    (self includesPackagedClassNamed:aClassName) ifTrue:[
	^ (self packagedClassNamed:aClassName) basicRemoveMethodNamed:aMethodName ifAbsent:aBlock
    ].

    (self packagedMethodsAtClassName:aClassName ifAbsent:aBlock)
	removeKey:aMethodName ifAbsent:aBlock.

    (self overriddenChangesIncludesMethodName:aMethodName forClassNamed:aClassName) ifTrue:[
	self removeOverriddenMethodNamed:aMethodName forClassNamed:aClassName ifAbsent:aBlock
    ].

    ^ aPackagedMethod


! !

!Package methodsFor:'api - accessing'!

changePackageOverrideFromPackage:fromPackage toPackage:toPackage forClassNamed:className
    "assumes that all the checks have been made that this className and these
    packages do exist!!"
    | overridenClassChangesHoldersForPackage |
    overridenClassChangesHoldersForPackage := (overriddenClassChanges at:fromPackage name).
    overridenClassChangesHoldersForPackage remove:className.

    self overrideClassNamed:className byPackageNamed:toPackage name.

    "cleanUp empty collections which are not needed!!"
    overriddenClassChanges size == 0 ifTrue:[
	(overriddenClassChanges removeKey:fromPackage name)
    ].
!

changeSet
    | changeSet |
    changeSet := ChangeSet new.
    packagedClasses do:[:aPackagedClass |
       changeSet addAll:aPackagedClass changeSet
    ].
    self looseMethods do:[:aPackageMethod | | aMethod aClass |
	changeSet addMethodChange:aPackageMethod method in:aPackageMethod ownedClass
    ].

    ^ changeSet
!

classCategories
    | return |
    return := Set new.  "to make sure that each category is unique"
    self packagedClassesDo:[:aPackagedClass |
	return add:aPackagedClass category.
    ].
    ^ return asOrderedCollection sort:[:x :y | x > y].
!

classesInCategory:aCategory
    | collectingClasses |
    collectingClasses := OrderedCollection new.

    self packagedClassesDo:[:aPackagedClass |
	aPackagedClass category == aCategory ifTrue:[
	    collectingClasses add: aPackagedClass.
	].
    ].
    ^ collectingClasses
!

overriddenClassNamesByPackage:aPackage
    ^ (overriddenClassChanges at:aPackage name ifAbsent:[^#() "empty"]) asOrderedCollection.
!

overriddenClassesByPackage:aPackage
    ^ (self overriddenClassNamesByPackage:aPackage) collect:[:aPackagedClassName |
	self packagedClassNamed:aPackagedClassName
    ]
!

overriddingPackageNameAtClassName:aClassName
    "returns a PackagedClass or nil"
    overriddenClassChanges keysAndValuesDo:[:packageName :aSetOfClassNames |
	(aSetOfClassNames includes:aClassName) ifTrue:[
	    ^ packageName
	].
    ].
    ^ nil.
!

packagedClassNamed:aSymbol
    ^ (self packagedClassNamed:aSymbol ifAbsent:[nil])
!

packagedClassNamed:aSymbol ifAbsent:aBlock
    | classWithoutClassEnding |
    classWithoutClassEnding := (aSymbol asString copyUpTo:Character space) asSymbol.

    (classWithoutClassEnding size < aSymbol asString size) ifTrue:[
	"here i am making a crude assumption that aSymbol is refering to the class side of a class.
	whether i should check if this is true or not is another matter..."
	^ (packagedClasses at:classWithoutClassEnding ifAbsent:[^ aBlock value]) classSide
    ].

    ^ (packagedClasses at:aSymbol "or classWithoutClassEnding" ifAbsent:[^ aBlock value])
!

packagedMethodNamed:aSymbol forClassNamed:aClassName
    ^ (self packagedMethodNamed:aSymbol forClassNamed:aClassName ifAbsent:[nil])
!

packagedMethodNamed:aMethodName forClassNamed:aClassName ifAbsent:aBlock
    | returnValue  packagedMethodsAtClassName |
    packagedMethodsAtClassName := (self packagedMethods at:aClassName ifAbsent:[nil]).
    packagedMethodsAtClassName ifNotNil:[
	returnValue := packagedMethodsAtClassName at:aMethodName ifAbsent:[nil].
    ].

    returnValue ifNil:[
	(self definesSelector:aMethodName forClassNamed:aClassName) ifTrue:[| smalltalkMethod|
	    smalltalkMethod := (Smalltalk classNamed:aClassName) compiledMethodAt:aMethodName.
	    smalltalkMethod ifNil:[^ self error:'I am in an impossible state!!'].
	    ^ self newPackagedMethodWithMethod:smalltalkMethod

	].
	aBlock value
    ].

    ^ returnValue.
!

workingPackage
    "Breaks encapsulation, but handy... may need a re-think"
    ^ Class packageQuerySignal query.
! !

!Package methodsFor:'api - adding & removing'!

addClassNamed:aClass
    "called when adding a class on startup."
    ^ self addPackagedClass:(PackagedClass name:aClass package:self)
!

addMethodNamed:aMethodName forClassNamed:aClassName
    "This is what i should sort out on MONDAY!!!!!!!!!! This is wrong!!!!!! I should be handed down the
    REAL methods which are added to me so that i can extract the source!!"
    | aPackagedMethod |

    (self includesPackagedClassNamed:aClassName) ifTrue:[
	^ (self packagedClassNamed:aClassName) addMethodNamed:aMethodName
    ].

    aPackagedMethod := (self newPackagedMethodSelector:aMethodName  className:aClassName).

    self addPackagedMethod:aPackagedMethod.

    self markDirty.
    ^ aPackagedMethod "if nil, the method is still to be installed. Could use a dummy here instead??"
!

addedClass:aClass
    "Add a class to a package. Return the aClass.
    This only works when 'aClass package == name' if not and error will occur.
    This method is called only AFTER the class package has changed!! This class
    is NOT responsible for changing values in classes!!
    "
    self basicAddedClass:aClass.
    self markDirty.
    self changed:#addedClass: with:aClass.
    ^ aClass
!

addedClasses:aClasses
    "Add a class to a package. Return the aClass"
    aClasses do:[:aClass |
	self basicAddedClass:aClass.
    ].

    self markDirty.
    self changed:#addClasses: with:aClasses.
    ^ aClasses
!

addedMethod:aMethod
    "Add a method to a package. Return the aMethod"
    self basicAddedMethod:aMethod.
    self markDirty.
    self changed:#addedMethod: with:aMethod.
    ^ aMethod
!

addedMethods:someMethods
    "Add someMethods to a package. Return the someMethods"
    someMethods do:[:aMethod |
	self basicAddedMethod:aMethod.
    ].
    self markDirty.
    self changed:#addedMethods: with:someMethods.
    ^ someMethods
!

addedPackagedClass:aPackagedClass
    "Add a class to a package. Return the aClass.
    This only works when 'aClass package == name' if not and error will occur.
    This method is called only AFTER the class package has changed!! This class
    is NOT responsible for changing values in classes!!
    "

    self basicAddedPackagedClass:aPackagedClass.
    self markDirty.
    self changed:#addedPackagedClass: with:aPackagedClass.
    ^ aPackagedClass
!

addedPackagedClass:packagedClass blockedMethods:aSetOfBlockedMethods
    "Add a class to a package. Return the aClass.
    This only works when 'aClass package == name' if not and error will occur.
    This method is called only AFTER the class package has changed!! This class
    is NOT responsible for changing values in classes!!
    "
    | blockedMethodsAtClassName |

    self addedPackagedClass:packagedClass.
    aSetOfBlockedMethods size > 0 ifTrue:[
	blockedMethodsAtClassName := (self blockedMethodsAtClassNamed:packagedClass name ifAbsentPut:[Set new]).
	blockedMethodsAtClassName addAll:aSetOfBlockedMethods.
    ].
    ^ packagedClass
!

overrideClassNamed:classBeingOverriddenName byPackageNamed:byPackageName
    | originalClassDefinition |

    self assert:(byPackageName ~= name).
    originalClassDefinition := (self packagedClassNamed: classBeingOverriddenName).
    originalClassDefinition ifNil:[
	PackageError raiseWithOverrideClassErrorClassNotFound:classBeingOverriddenName fromPackage:self
    ].

    self addOverriddenClassChange:originalClassDefinition byPackageNamed:byPackageName.
    self changed:#overrideClassNamed:byPackageNamed: with:(Array with:classBeingOverriddenName with:byPackageName)
!

overrideMethod:methodBeingOverridden byPackageNamed:byPackageName
    | originalMethodDefinition |

    originalMethodDefinition :=
	(self newPackagedMethodSelector:methodBeingOverridden name
		className:methodBeingOverridden mclass name asSymbol
		source:methodBeingOverridden source).

    originalMethodDefinition ifNil:[
	PackageError raiseWithOverrideMethodErrorMethodNotFound:methodBeingOverridden fromPackage:self
    ].

    self addOverriddenMethodChange:originalMethodDefinition byPackageNamed:byPackageName.
    self changed:#overrideMethod: with:methodBeingOverridden
!

overrideMethod:methodBeingOverridden forClassNamed:aClassName byPackageNamed:byPackageName
    | originalMethodDefinition methodName |

    self assert:(byPackageName ~= name).
    (methodBeingOverridden isKindOf:Method) ifTrue:[
	"unbound methods do not know there name so i have to do this... This could be done in Method>>selector"
	(methodName := methodBeingOverridden name) ifNil:[
	    methodName := (methodBeingOverridden source upTo:Character space) asSymbol.
	].

	originalMethodDefinition :=
	    (self newPackagedMethodSelector:methodName
		    className:aClassName
		    source:methodBeingOverridden source).

	originalMethodDefinition ifNil:[
	    PackageError raiseWithOverrideMethodErrorMethodNotFound:methodBeingOverridden fromPackage:self
	].
    ] ifFalse:[
	(methodBeingOverridden isKindOf:(Package::PackagedMethod)) ifFalse:[
	    self error:'This method needs a PackagedMethod or a Method'
	].
	originalMethodDefinition := methodBeingOverridden.
    ].

    self addOverriddenMethodChange:originalMethodDefinition byPackageNamed:byPackageName.
    self changed:#overrideMethod: with:methodBeingOverridden
!

removeFromSystem
    self packagedClassesDo:[:aPackagedClass |
	aPackagedClass removeFromSystem
    ].

    self packagedMethodsDo:[:aPackagedMethod |
	aPackagedMethod removeFromSystem
    ].
!

removeOverriddenClassNamed:aClassNameSymbol

    ^ self removeOverriddenClassNamed:aClassNameSymbol ifAbsent:[self error:'Class not found!!']
!

removeOverriddenClassNamed:aClassNameSymbol ifAbsent:aBlock

    overriddenClassChanges copy keysAndValuesDo:[:aPackageName :aSet |
	aSet remove:aClassNameSymbol ifAbsent:aBlock.
	aSet isEmpty ifTrue:[
	    overriddenClassChanges removeKey:aPackageName.
	].
    ].

    overriddenMethodChanges copy keysAndValuesDo:[:aPackageName :aDic |
	(aDic removeKey:aClassNameSymbol ifAbsent:aBlock).
	aDic isEmpty ifTrue:[
	    overriddenMethodChanges removeKey:aPackageName
	].
    ].
!

removedClassNamed:aSymbol
    self basicRemoveClassNamed:aSymbol.
    self markDirty.
    self changed:#removedClassNamed: with:aSymbol.
    ^ aSymbol
!

removedMethod:aMethod
    ^ self
	removedMethodNamed:aMethod name
	forClassNamed:aMethod mclass name.
!

removedMethodNamed:aMethodName forClassNamed:aClassName
    "note: could also create a loose method object which could be more useful"
    ^ self removedMethodNamed:aMethodName forClassNamed:aClassName ifAbsent:[self error:'I should know this method!!']
!

removedMethodNamed:aMethodName forClassNamed:aClassName ifAbsent:aBlock
    "note: could also create a loose method object which could be more useful"
    | aPackagedMethod |
    aPackagedMethod := self basicRemoveMethodNamed:aMethodName forClassNamed:aClassName ifAbsent:aBlock.
    self markDirty.
    self changed:#removedMethodNamed:forClassNamed: with:(Array with:(aMethodName)with:(aClassName)).
    ^ aPackagedMethod
! !

!Package methodsFor:'api - changes'!

classDefinitionChange:aClassDefinitionChange
    "assumes that checks to see if the receiver is affected by the change have been made.
    At present a classDefinitionChange does not result in a class changing packages!!
    If it does then this method needs to change and put this change type in overridden changes!!
    "
    self markDirty.
    self changed:#classDefinitionChange: with:aClassDefinitionChange
!

classInstVarDefinitionChange:aClassInstVarDefinitionChange
    "assumes that checks to see if the receiver is affected by the change have been made.
    At present a classInstVarDefinitionChange does not result in a class changing packages!!
    If it does then this method needs to change and put this change type in overridden changes!!
    "
    self markDirty.
    self changed:#classInstVarDefinitionChange: with:aClassInstVarDefinitionChange
!

classRemoveChange:aClassRemoveChange
    "assumes that checks to see if the receiver is affected by the change have been made.
    At the moment i store the original package information in the instance variable
    packagedClasses, and this is where i get the original class definition from!! It might be
    an idea to get this info from aClassRemoveChange like it is done in methodRemoveChange.
    Then we would not need the packageClasses themselves and just storing symbolic links
    to the classesand create the packageClasses on the fly when needed.
    "
    |classBeingRemoved  originalClassDefinition interestedMethods |

    classBeingRemoved := ClassRemoveChange::ClassBeingRemovedQuery query.
    originalClassDefinition := (self packagedClassNamed: classBeingRemoved name).
    interestedMethods := self getInterestedPackagedMethodsFromClass:classBeingRemoved.
    interestedMethods do:[:aPackagedMethod |
	self addPackagedMethod:aPackagedMethod.
	self overrideMethod:aPackagedMethod forClassNamed:classBeingRemoved name byPackageNamed:#Smalltalk
    ].
    (originalClassDefinition isNil and:[interestedMethods isEmpty]) ifTrue:[
	self error:'Oops. I should know this!! look #isDependentOnClassRemoveChange: This should be called
	    before me and should work!!)'
    ].
    originalClassDefinition ifNotNil:[
	self addOverriddenClassChange:originalClassDefinition byPackageNamed:#Smalltalk.
    ].
    self changed:#classRemoveChange:
!

classRenameChange:aClassRenameChange
    "assumes that checks to see if the receiver is affected by the change have been made.
    This action requires the receiver to change all references to the old class name to the
    new name.
    "
    | newClass newPackagedClass|
    newClass := (Smalltalk classNamed:aClassRenameChange className).
    newClass ifNil:[
	self error:'The class named ', newClass name,
	    'does not exist!! It is expected to exist from a rename action!!'
    ].

    self packagedClassesRemoveAtClassName:aClassRenameChange oldName ifAbsent:[nil].
    newPackagedClass := self newPackagedClass:newClass.
    self addedPackagedClass:newPackagedClass.
    self markDirty.
    self changed:#classRenameChange: with:aClassRenameChange
!

markClean
    self isDirty:false.
!

markDirty
    self isDirty:true
!

methodCategoryChange:aChange
    "assumes that checks to see if the receiver is affected by the change have been made.
     This is not considered a 'major change'. Therefore do nothing to the receiver to indicate that
     this method (specified by aChange) has been overriden or change. Just mark the receiver as
     dirty
    "
    self markDirty.
    self changed:#methodCategoryRenameChange: with:aChange
!

methodCategoryRenameChange:aChange
    "assumes that checks to see if the receiver is affected by the change have been made.
     This is not considered a 'major change'. Therefore do nothing to the receiver to indicate that
     this method (specified by aChange) has been overriden or change. Just mark the receiver as
     dirty
    "
    self markDirty.
    self changed:#methodCategoryRenameChange: with:aChange
!

methodChanged:aMethodChange
    "assumes that checks to see if the receiver is affected by the change have been made
    a method as changed.

    There are really two types of change that come in here. A 'new method change' and a
    'method redefinition'.

    If the receiver is dependent on the change there are two things that
    can happen depending on the change:

	1)  if the receiver owns the class but not the method
	    - to keep the package consistant - we add a blocked method to the receiver

	2)  if the receiver has a loose method defining the method
	    add an overriddenMethod change - to store the original.

    Context note:
	at present a change to a methods results ALWAYS in the default package owning the method.
	so here we assume that the current version package is NEVER the receiver!! This could be
	added functionality option later on (i have no way of testing this now).
    "
    | previousVersion aMethodName aClassName aPackagedMethod byPackageName |

    aMethodName     := aMethodChange selector.
    aClassName      := aMethodChange className asSymbol.
    previousVersion := aMethodChange previousVersion.
    aPackagedMethod := self
			newPackagedMethodSelector:aMethodName
			className:aClassName
			source:previousVersion.
    byPackageName := aPackagedMethod currentPackageOwner.

    (self includesPackagedClassNamed:aClassName) ifTrue:[
	previousVersion ifNil:[
	    "should only really happen in Default class - at least for the time being.
	    This is because as is noted in - 'Context note' - above"
	    ^ self newMethodChanged:aMethodChange
	].

	previousVersion package asSymbol == self name ifTrue:[
	    ^ self addOverriddenMethodChange:aPackagedMethod byPackageNamed:byPackageName.
	].
	Transcript nextPutAll:'i should NEVER be here.... either isDependentOnMethodChange does not
		    work correctly OR i have just gone a bit bonkers!! From Package>>#methodChanged:';cr.
    ].

    "when i am here aMethodChange is in with my packageMethods (loose method)
    the following should be true(but is it needed???):
	previousVersion package asSymbol == self name
    "

    self addOverriddenMethodChange:aPackagedMethod byPackageNamed:byPackageName.

    self changed:#methodChanged: with:aMethodChange
!

methodRemoveChange:aMethodRemoveChange
    "assumes that checks to see if the receiver is affected by the change have been made.
    A method that i am dependant on has been removed. I could be dependent on it's class
    or the method itself (then it would be a loose method).

    There is one special case where i would be dependent on the class but not the method.
    In this case i just remove the blocked method from my blocked method list!!
    Otherwise adds changes to overriddenChanges.
    "
    | aMethodName aClassName methodBeingRemoved overriddenByPackage |
    aMethodName := aMethodRemoveChange selector.
    aClassName := aMethodRemoveChange className asSymbol.
    methodBeingRemoved := aMethodRemoveChange previousVersion.

    (self blockedMethodsIncludeMethodName:aMethodName forClassNamed:aClassName) ifTrue:[
	self removeBlockedMethodNamed:aMethodName forClassNamed:aClassName.
	self changed:#methodChanged: with:aMethodRemoveChange.
	^ self.
    ].
    overriddenByPackage := self workingPackage.
    overriddenByPackage == name ifTrue:[
	overriddenByPackage := #Smalltalk
    ].
    self overrideMethod:methodBeingRemoved forClassNamed:aClassName byPackageNamed:#Smalltalk.
    self changed:#methodChanged: with:aMethodRemoveChange.
!

newMethodChanged:aMethodChange
    "a new method has been created. In this case i must be dependent on the method's class
    so i need to block this method from my 'view of the world'."
    | aMethodName aClassName |
    aMethodName := aMethodChange selector.
    aClassName := aMethodChange className.
    ^ self addBlockedMethodNamed:aMethodName forClassNamed:aClassName
! !

!Package methodsFor:'api - prerequisites'!

addClassNamePrerequisite:aClassName
    "changed sent in the following call"
    ^ self addClassNamePrerequisite:aClassName ifFailString:''.
!

addClassNamePrerequisite:aName ifFailString:aString
    |returnValue|

    returnValue := self
		addPrerequisite:(self newClassPrerequisiteNamed:aName
			ifFailString:aString).
    self changed:#addClassNamePrerequisite: with:aName.
    ^ returnValue
!

addPackageNamePrerequisite:aName
    "changed sent in the following call"
    ^ self addPackageNamePrerequisite:aName ifFailString:''.
!

addPackageNamePrerequisite:aName ifFailString:aString
    |returnValue|

    returnValue := self
		addPrerequisite:(self newPackagePrerequisiteNamed:aName
			ifFailString:aString).
    self changed:#addPackageNamePrerequisite: with:aName.
    ^ returnValue
! !

!Package methodsFor:'api - scripts'!

postInstallScript
    ^ self scriptAt:#postInstall
!

postInstallScriptString:aString
    self scriptAt:#postInstall put:(self newPackageScriptWithString:aString).
    self changed:#postInstallScriptString: with:aString.
!

postUninstallScript
    ^ self scriptAt:#postUninstall
!

postUninstallScriptString:aString
    self scriptAt:#postUninstall put:(self newPackageScriptWithString:aString).
    self changed:#postUninstallScriptString: with:aString.
!

preInstallScript
    ^ (self scriptAt:#preInstall)
!

preInstallScriptString:aString
    self scriptAt:#preInstall put:(self newPackageScriptWithString:aString).
    self changed:#preInstallScriptString: with:aString.
!

preUninstallScript
    ^ self scriptAt:#preUninstall
!

preUninstallScriptString:aString
    self scriptAt:#preUninstall put:(self newPackageScriptWithString:aString).
    self changed:#preUninstallScriptString: with:aString.
! !

!Package methodsFor:'api - uninstall'!

uninstallFromManager:aPackageManager

    self packagedClasses copy do:[:aPackagedClass |
	"i remove here from packagedClasses so a shallow copy is needed!!"
	aPackageManager
	    removeClassNamed:aPackagedClass name
	    fromPackage:self
	    moveToDefaultPackage:false.
    ].

    self checkOkToUninstall.
    self basicUninstall.
! !

!Package methodsFor:'api-moving'!

movedClassNamed:aClassName toPackage:newOwnerPackage
    "Note: all the methods of the class have also been moved to newOwnerPackage BUT
    we do not have to do anything about that here!! We also do not get any change messages
    and we - in effect - get this change for free :-) as now newOwnerPackage owns the class!!"
    | packagedClass blockedMethods|
    packagedClass := self packagedClassNamed:aClassName.
    blockedMethods := self blockedMethodsAtClassNamed:aClassName.

    packagedClass ifNil:[
	PackageError raiseCannotMoveClassNamed:aClassName toPackage:newOwnerPackage.
    ].
    packagedClass package:newOwnerPackage.

    PackageError removeClassError handle:[:ex |
	PackageError raiseCannotMoveClassNamed:aClassName toPackage:newOwnerPackage.
    ] do:[
	self removedClassNamed:aClassName.
    ].
    newOwnerPackage addedPackagedClass:packagedClass blockedMethods:blockedMethods.
    self markDirty.
    self changed:#'movedClassNamed:toPackage:'
	with:(Array with:aClassName with:newOwnerPackage).

!

movedMethod:aMethod toPackage:newOwnerPackage
    self removedMethod:aMethod.
    newOwnerPackage addedMethod:aMethod.
! !

!Package methodsFor:'checks'!

readyForInstall
    #ToDo.
!

readyForUninstall
    #ToDo.
! !

!Package methodsFor:'enumerating'!

classesInSystemDo:aBlock
    self packagedClassesDo:[:aPackage | | aClass |
	(aClass"orNil" := aPackage classInSmalltalk) ifNotNil:[
	    aBlock value:aClass
	].
    ].
!

loosePackagedMethodsDo:aBlock
    self looseMethods do:aBlock.
!

packagedClassesDo:aOneArgBlock
   ^ packagedClasses do:aOneArgBlock
!

packagedMethodsDo:aBlock
    self packagedMethods values do:[:aDicOfPackagedMethods |
	aDicOfPackagedMethods values do:aBlock
    ].



! !

!Package methodsFor:'factory'!

newClassPrerequisiteNamed:aName ifFailString:aString
    ^ ClassPrerequisite named:aName ifFailString:aString.
!

newOverriddenChangeWithChange:aChange
    ^ OverriddenChange newChange:aChange package:self.
!

newPackagePrerequisiteNamed:aName ifFailString:aString
    ^ PackagePrerequisite named:aName ifFailString:aString.
!

newPackageScriptWithString:aString
    ^ PackagedScript string:aString receiver:self
!

newPackagedClass:aClass
    ^ (PackagedClass class:aClass package:self)
!

newPackagedMethodSelector:aMethodSelector  className:aClassName
    ^ PackagedMethod new
	    name:aMethodSelector;
	    ownedClassName: aClassName;
	    package:self.
!

newPackagedMethodSelector:aMethodSelector  className:aClassName source:aSourceString
    ^ PackagedMethod
	    name:aMethodSelector
	    ownedClassName: aClassName
	    category:String new
	    package:self
	    source:aSourceString
!

newPackagedMethodWithMethod:aMethod
    ^ PackagedMethod
	    name:aMethod selector
	    ownedClassName: aMethod mclass name
	    category:aMethod category
	    package:self
	    source:aMethod source
! !

!Package methodsFor:'initialization'!

initialize

    packagedClasses := self class defaultPackagedClassesCollection.
    packagedMethods := self class defaultPackagedMethodsCollection.
    blockedMethods := self class defaultBlockedMethodsCollection.

    overriddenClassChanges := self class defaultOverriddenChangesCollection.
    overriddenMethodChanges := self class defaultOverriddenChangesCollection.

    prerequisites := self class defaultPrerequisiteCollection.
    scripts := self class defaultScriptsCollection.

    isDirty := false.
    isInstalled := false. "not sure about this..."
    super initialize.
!

initializeClasses
    self classesInSystemDo:[:aClass |
	aClass initialize.
    ].
!

initializeInstalled
    "initialize as if the receiver as if it has just been loaded"
    | myName packagedClass |
    myName := self name.
    self isDirty:false.
    self isInstalled:true.
    self classesInSystemDo:[:aClass |
	aClass setPackage:myName.
	"get initial information"
	packagedClass := (self packagedClassNamed:aClass name).
	packagedClass instanceDefinition:aClass definition
			classDefinition:aClass class definition
			category:aClass category

    ].
    "you need to set the working package to the package you are loading... maybe???"
"/    self looseMethodsDo:[:aMethod |
"/        aMethod setPackage:myName
"/    ].
!

initializeLoaded
    "initialize as if the receiver as just been loaded"
    self isDirty:false.
    self isInstalled:false.
! !

!Package methodsFor:'printing'!

printOn:aStream

    'named:', self name.
    aStream nextPutAll:self class printString.
    aStream nextPutAll:' named:'.
    aStream nextPut:$'.
    aStream nextPutAll:self name.
    aStream nextPut:$'.
! !

!Package methodsFor:'queries'!

blockedMethodsIncludeMethodName:aMethodName forClassNamed:aClassName
    | blockedMethods |
    blockedMethods := (self blockedMethodsAtClassNamed:aClassName).
    blockedMethods ifNil:[
	^ false.
    ].

    ^ blockedMethods includes:aMethodName
!

definesSelector:aMethodSymbol forClassNamed:aClassSymbol
    "checks to see if the receiver defines a method selector associated
    with a class symbol."

    | theClass dictionaryOfPackagedMethods |

    (theClass := self packagedClassNamed:aClassSymbol) ifNil:[
	dictionaryOfPackagedMethods := self packagedMethods at:aClassSymbol ifAbsent:[^ false].
	dictionaryOfPackagedMethods at:aMethodSymbol ifAbsent:[^ false]. "assumes a packagedMethod is returned"
	aMethodSymbol ifNil:[
	    ^ false.
	].
	^ true.
    ].

    "if i am here then i know the class!!"
    (self blockedMethodsIncludeMethodName:aMethodSymbol forClassNamed:aClassSymbol) ifTrue:[
	^ false.
    ].

    aMethodSymbol ifNil:[
	^ false.
    ].

    ^ true.
!

includesPackagedClassNamed:aSymbol

    ^ (self packagedClassNamed:aSymbol) notNil
!

isOverridden
    ^ ((overriddenMethodChanges notEmpty) or:[(overriddenClassChanges notEmpty)])
!

isPackage
    ^ true
!

overriddenChangesIncludesClassNamed:aClassName


    overriddenClassChanges values do:[:aSetOfClassNames |
	(aSetOfClassNames includes:aClassName) ifTrue:[
	    ^ true
	].
    ].
    overriddenMethodChanges values do:[:aColOfDics |
	(aColOfDics  keys includes:aClassName) ifTrue:[
	    ^ true
	].
    ].

    ^ false

!

overriddenChangesIncludesMethodName:aMethodName forClassNamed:aClassName
    | aSetOfPackageMethods |

    overriddenMethodChanges values do:[:aDicOfClassNamesAndMethods |
	aSetOfPackageMethods := (aDicOfClassNamesAndMethods at:aClassName ifAbsent:[nil]).
	aSetOfPackageMethods ifNotNil:[
	    (aSetOfPackageMethods includes:aMethodName) ifTrue:[
		^ true
	    ].
	].

    ].

    ^ false
!

overriddenClassChangesIncludesClassNamed:aClassName

    overriddenClassChanges isEmpty ifTrue:[
	^ false
    ].

    overriddenClassChanges values do:[:aSetOfClassNames |
	(aSetOfClassNames includes:aClassName) ifTrue:[
	    ^ true
	].
    ].

    ^ false
!

overriddenMethodChangesIncludesClassNamed:aClassName

    overriddenMethodChanges isEmpty ifTrue:[
	^ false
    ].

    overriddenClassChanges values do:[:aDic |
	(aDic keys includes:aClassName) ifTrue:[
	    ^ true
	].
    ].

    ^ false
! !

!Package methodsFor:'queries - dependents'!

hasRelationshipWithClassNamed:aClassName
    "checks to see if the receiver has got some sort of relationship with
    aClassName such as a method or a class. returns a boolean
    "
    self assert:aClassName isSymbol.

    ^ ((self includesPackagedClassNamed:aClassName) or:[
	    (self packagedMethods at:aClassName ifAbsent:[nil])notNil] )
!

isDependentOnClassNamed:aClassName
    "checks to see if the receiver is dependent on aClassName. returns a boolean
    "
    | packagedClass  classCheck methodCheck packagedMethods |
    self assert:aClassName isSymbol.
    classCheck := true.
    methodCheck := true.

    (self hasRelationshipWithClassNamed:aClassName) ifFalse:[
	^ false
    ].

    packagedClass := (self packagedClassNamed:aClassName) ifNotNil:[
	classCheck := (self overriddingPackageNameAtClassName:aClassName) isNil
    ].

    (packagedMethods := self packagedMethods at:aClassName ifAbsent:[nil]) ifNotNil:[
	packagedMethods keys do:[:aMethodSelector |
	   (self isDependentOnMethodNamed:aMethodSelector forClassNamed:aClassName) ifFalse:[
		methodCheck := false.
	    ].
	].

    ].

    ^ classCheck or:[methodCheck].
!

isDependentOnMethodNamed:aMethodSelector forClassNamed:aMethodClassName
    "If the receiver is responsible for the change return true or false."
    (self definesSelector:aMethodSelector forClassNamed:aMethodClassName) ifTrue:[
	(self includesPackagedClassNamed:aMethodClassName) ifTrue:[
	    (self blockedMethodsIncludeMethodName:aMethodSelector forClassNamed:aMethodClassName) ifTrue:[
		^ false.
	    ].
	].

	(self overriddenChangesIncludesMethodName:aMethodSelector forClassNamed:aMethodClassName) ifTrue:[
	    ^ false.
	].
	^ true.
    ].



    ^ false
! !

!Package methodsFor:'uninstall'!

basicUninstall

    self preUninstallScript evaluate.
    self uninstallDependentPackages.
    self uninstallClasses.
    self uninstallLooseMethods.
    self initializeLoaded.
    self postUninstallScript evaluate.
!

checkOkToUninstall
    #toDo.
!

uninstallClasses
    self classesInSystemDo:[:aClass |
	aClass removeFromSystem.
    ]
!

uninstallDependentPackages
    #toDo
!

uninstallLooseMethods
    self loosePackagedMethodsDo:[:aLooseMethod |
	aLooseMethod removeFromSystem.
    ].
! !

!Package::PackagedClass class methodsFor:'instance creation'!

class:aClass package:aPackage
    | anInstance|
    anInstance := (self basicNew name:aClass name package:aPackage).
    (aClass isLoaded) ifFalse:[
	"could also be dependant on Smalltalk!!"
	aClass addDependent:anInstance. "get the definition when the class is autoloaded"
	anInstance category: aClass category.
	^ anInstance.
    ].
    anInstance instanceDefinition: aClass definition
	    classDefinition: aClass class definition
	    category: aClass category.

    ^ anInstance
!

name:aClassName package:aPackage
    ^ (self basicNew name:aClassName package:aPackage).
! !

!Package::PackagedClass methodsFor:'accessing'!

category
    ^ category ifNil:['' copy].
!

category:something
    "set the value of the instance variable 'category' (automatically generated)"

    category := something.
!

classDefinition
    "return the value of the instance variable 'classDefinition' (automatically generated)"

    ^ classDefinition
!

classInstanceVariableNames
    "return the value of the instance variable 'classInstanceVariableNames' (automatically generated)"

    ^ classInstanceVariableNames
!

classVariableNames
    "return the value of the instance variable 'classVariableNames' (automatically generated)"

    ^ classVariableNames
!

instanceDefinition
    "return the value of the instance variable 'instanceDefinition' (automatically generated)"

    ^ instanceDefinition
!

instanceDefinition:instanceDefinitionArg classDefinition:classDefinitionArg category:categoryArg
    "set instance variables (automatically generated)"

    instanceDefinition := instanceDefinitionArg.
    classDefinition := classDefinitionArg.
    category := categoryArg.
!

instanceVariableNames
    "return the value of the instance variable 'instanceVariableNames' (automatically generated)"

    ^ instanceVariableNames
!

name
    "return the value of the instance variable 'name' (automatically generated)"

    ^ name
!

name:nameArg package:packageArg
    "set instance variables (automatically generated)"

    name := nameArg.
    package := packageArg.
!

package
    "return the value of the instance variable 'package' (automatically generated)"

    ^ package
!

package:aPackage
    "if the receiver IS in smalltalk change the class in smalltalk.
    I hope this wont make the functionality get a bit hairy..."

    self isInSmalltalk ifTrue:[
	self classInSmalltalk package:aPackage name
    ].
    package := aPackage.
!

privateClasses
    "borrowed implementation from Class>>privateClasses.
    This implementation looks into the receiver's package to look for
    privateClasses. IF the receiver is installed in Smalltalk then these private classes
    associated with the receiver are also its privateClasses!! Although this may not happen
    often
    "
    ^ self privateClassesOrAll:false



!

privateClassesOrAll:allOfThem
    "implementation based on Class>>privateClasesOrNil: "
    |classes myName myNamePrefix myNamePrefixLen cls|

    myName := self name.
    myNamePrefix := myName , '::'.
    myNamePrefixLen := myNamePrefix size.

    package packagedClasses keys do:[:nm |
	(nm startsWith:myNamePrefix) ifTrue:[
	    (allOfThem
	    or:[(nm indexOf:$: startingAt:myNamePrefixLen + 1) == 0]) ifTrue:[
		cls := package packagedClassNamed:nm.

		(cls notNil) ifTrue:[
		    classes isNil ifTrue:[
			classes := IdentitySet new:10.
		    ].
		    classes add:cls.
		]
	    ]
	]
    ].
    self isInSmalltalk ifTrue:[
	^ classes ? (OrderedCollection new) addAll:(self classInSmalltalk privateClasses)
    ].
    ^ classes ? #()
!

shortName
    "copied from ClassDescription>>nameWithoutPrefix "
    |nm idx|

    nm := self name.
    idx := nm lastIndexOf:$:.
    idx == 0 ifTrue:[
	^ nm
    ].
    ^ (nm copyFrom:idx+1) asSymbol. "asSymbol was added"
! !

!Package::PackagedClass methodsFor:'api'!

addBlockedMethodNamed:aMethodName
    ^ package addBlockedMethodNamed:aMethodName forClassNamed:name
!

addMethodNamed:aMethodName
    | aPackagedMethod |
    (self blockedMethodsIncludeMethodName:aMethodName) ifTrue:[
	self removeBlockedMethodNamed:aMethodName.
	self markDirty.
	^ aPackagedMethod.
    ].

    (self overriddenChangesIncludesMethodName:aMethodName) ifTrue:[
     "it should not be consider overriden anymore has the method has just been
      added to the receiver!! And we dont need to add it as an extra method either
      as i now am a 'holder for this method!!' But to show this i need to mark myself dirty"
	self markDirty.
	self removeOverriddenMethodNamed:aMethodName.
	^ aPackagedMethod.
    ].

    "if i am here the method is in effect added as the package the receiver is related to
    knows the class and does not include any blocked methods for the method aMethodName"
!

applyIntoSmalltalk

    Parser evaluate:(instanceDefinition).
    Parser evaluate:(classDefinition).

!

basicRemoveMethodNamed:aMethodName ifAbsent:aBlock
    (self blockedMethodsIncludeMethodName:aMethodName) ifTrue:[
	^ aBlock value
    ]. "the receiver does not know this method!!"

    self addBlockedMethodNamed:aMethodName.

    (self overriddenChangesIncludesMethodName:aMethodName) ifTrue:[
	self removeOverriddenMethodNamed:aMethodName
    ].
!

changeSet
    | theClass |
    (theClass := self classInSmalltalk) ifNil:[
	^ ChangeSet new
    ].

    theClass autoload.

    ^ ChangeSet forExistingClass:theClass
!

classInSmalltalk
    self isInSmalltalk ifTrue:[
	^ Smalltalk classNamed:name
    ].

    ^ nil
!

classSide
    "an interface to the class side of the receiver"
    ^ ClassSide instanceSide:self.
!

definesSelector:aSelector
    ^ package definesSelector:aSelector forClassNamed:name
!

isInSmalltalk
    "if evaluates to false, it should not be in Smalltalk."
    | classInSmalltalk|
    ((package packagedClassNamed:name) == self) ifFalse:[
	^ false.
    ].

    ^ (package isDependentOnClassNamed:name) and:[
	(classInSmalltalk := Smalltalk classNamed:name) notNil and:[
	    (classInSmalltalk package == package name)
	].
    ].
!

markDirty
    ^ package markDirty
!

overriddenChangesIncludesMethodName:aMethodName
    ^ package overriddenChangesIncludesMethodName:aMethodName forClassNamed:name
!

packagedMethods
    | isMyClassInSmalltalkGone possibleClassRemoved classInSmalltalk definedMethods packagedMethodsInClass |

    possibleClassRemoved := ClassRemoveChange::ClassBeingRemovedQuery query.
    isMyClassInSmalltalkGone := possibleClassRemoved notNil.

    isMyClassInSmalltalkGone ifTrue:[
	definedMethods := possibleClassRemoved methodDictionary copy values select:[:aMethod |
	    self definesSelector:aMethod name
	].

	^ definedMethods collect:[:aMethod |
	    package newPackagedMethodWithMethod:aMethod
	].
    ].
    packagedMethodsInClass := (package packagedMethods at:name ifAbsent:[Dictionary new]).

    (classInSmalltalk := Smalltalk classNamed: name) ifNil:[
	^ packagedMethodsInClass
    ].

    definedMethods := classInSmalltalk methodDictionary copy values select:[:aMethod |
	self definesSelector:aMethod name
    ].
    "get from package or create on the fly packaged methods"
   ^ definedMethods collect:[:aMethod |
	packagedMethodsInClass at:aMethod name ifAbsent:[
	   package newPackagedMethodWithMethod:aMethod
	].
    ].
!

removeBlockedMethodNamed:aMethodName
    ^ package removeBlockedMethodNamed:aMethodName  forClassNamed:name
!

removeFromPackage
   ^ package basicRemoveClassNamed:name
!

removeFromSystem
    | class |
    self removeFromPackage.
    (class := self classInSmalltalk) ifNotNil:[
	class removeFromSystem.
    ].
!

removeOverriddenMethodNamed:aMethodName
    ^ package removeOverriddenMethodNamed:aMethodName forClassNamed:name.
! !

!Package::PackagedClass methodsFor:'change & update'!

update:something with:aParameter from:changedObject
     | definition|
    (changedObject == self classInSmalltalk) ifTrue:[
	changedObject isLoaded ifTrue:[
	    changedObject removeDependent:self. "dont need you any more"
	    definition := changedObject definition.
	].
    ].
! !

!Package::PackagedClass methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'(PackagedClass named:#', name, ')'.
! !

!Package::PackagedClass methodsFor:'queries'!

blockedMethodsIncludeMethodName:aMethodName
    ^ package blockedMethodsIncludeMethodName:aMethodName  forClassNamed:name.
!

isLoaded
    ^ self classInSmalltalk isLoaded.
!

isPrivate
    "there may be a better way of doing this... but i cannot get this information
    out from the image as this class may not implemented!!"
    | readStream |
    self isInSmalltalk ifTrue:[
	^ self classInSmalltalk isPrivate.
    ].
    readStream := ((Parser parseExpression:instanceDefinition) selector readStream).

    [readStream atEnd] whileFalse:[
	((readStream upTo:$:) asSymbol == #privateIn:) ifTrue:[
	    ^ true
	].
    ].

    ^ false
! !

!Package::PackagedClass::ClassSide class methodsFor:'instance creation'!

instanceSide:aPackagedClass
    ^ self basicNew instanceSide:aPackagedClass
! !

!Package::PackagedClass::ClassSide methodsFor:'accessing'!

instanceSide
    "return the value of the instance variable 'instanceSide' (automatically generated)"

    ^ instanceSide
!

instanceSide:something
    "set the value of the instance variable 'instanceSide' (automatically generated)"

    instanceSide := something.
!

name
    ^ (instanceSide name, ' class') asSymbol
!

package
    ^ instanceSide package
! !

!Package::PackagedClass::ClassSide methodsFor:'api'!

addBlockedMethodNamed:aMethodName
    ^ self package addBlockedMethodNamed:aMethodName forClassNamed:self name
!

addMethodNamed:aMethodName
    | aPackagedMethod |
    (self blockedMethodsIncludeMethodName:aMethodName) ifTrue:[
	self removeBlockedMethodNamed:aMethodName.
	self markDirty.
	^ aPackagedMethod.
    ].

    (self overriddenChangesIncludesMethodName:aMethodName) ifTrue:[
     "it should not be consider overriden anymore has the method has just been
      added to the receiver!! And we dont need to add it as an extra method either
      as i now am a 'holder for this method!!' But to show this i need to mark myself dirty"
	self markDirty.
	self removeOverriddenMethodNamed:aMethodName.
	^ aPackagedMethod.
    ].

    "if i am here the method is in effect added as the package the receiver is related to
    knows the class and does not include any blocked methods for the method aMethodName"
!

basicRemoveMethodNamed:aMethodName ifAbsent:aBlock
    (self blockedMethodsIncludeMethodName:aMethodName) ifTrue:[
	^ aBlock value
    ]. "the receiver does not know this method!!"

    self addBlockedMethodNamed:aMethodName.

    (self overriddenChangesIncludesMethodName:aMethodName) ifTrue:[
	self removeOverriddenMethodNamed:aMethodName
    ].
!

blockedMethodsIncludeMethodName:aMethodName
    ^ self package blockedMethodsIncludeMethodName:aMethodName  forClassNamed:self name.
!

markDirty
    ^ self package markDirty
!

overriddenChangesIncludesMethodName:aMethodName
    ^ self package overriddenChangesIncludesMethodName:aMethodName forClassNamed:self name
!

removeBlockedMethodNamed:aMethodName
    ^ self package removeBlockedMethodNamed:aMethodName  forClassNamed:self name
!

removeOverriddenMethodNamed:aMethodName
    ^ self package removeOverriddenMethodNamed:aMethodName forClassNamed:self name.
! !

!Package::PackagedMethod class methodsFor:'instance creation'!

name:aMethodName ownedClassName: aClassName  category:aCategory package:aPackage source:source
    self assert:(aClassName isSymbol).
    self assert:(aMethodName isSymbol).
    ^ self basicNew name:aMethodName ownedClassName: aClassName category:aCategory package:aPackage source:source
! !

!Package::PackagedMethod methodsFor:'accessing'!

category
    (self isInSmalltalk) ifTrue:[
	^ self method category.
    ].
    ^ nil.
!

currentPackageOwner
    | class method |
    class := (Smalltalk classNamed:ownedClassName).
    class ifNil:[
	^ nil.
    ].
    method := class compiledMethodAt:self name.

    method ifNil:[
	^ nil
    ].

    ^ method package
!

isCommitted
    "return the value of the instance variable 'isCommitted' (automatically generated)"

    ^ isCommitted
!

methodInImage
    | myClass |
    myClass := Smalltalk classNamed:ownedClassName.
    myClass ifNil:[^ nil].

    ^ myClass compiledMethodAt:self name.
!

name
    "return the value of the instance variable 'name' (automatically generated)"

    ^ name
!

name:something
    "set the value of the instance variable 'name' (automatically generated)"

    name := something.
!

name:nameArg ownedClassName:classNameArg category:categoryArg package:packageArg source:sourceArg
    name := nameArg.
    ownedClassName := classNameArg.
    category := categoryArg.
    package := packageArg.
    source :=  sourceArg.
!

ownedClass
    ^ Compiler evaluate:ownedClassName
	in:nil
	receiver:nil
	notifying:nil
	logged:false
	ifFail:[nil]
	compile:false



"
    (self new ownedClassName:'Integer') ownedClass
"
!

ownedClassName
    "return the value of the instance variable 'className' (automatically generated)"

    ^ ownedClassName
!

ownedClassName:something
    "set the value of the instance variable 'className' (automatically generated)"
    self assert:(something isSymbol).
    ownedClassName := something.
!

ownedClassShortName
    "copied from ClassDescription>>nameWithoutPrefix "
    |nm idx|

    nm := self ownedClassName.
    idx := nm lastIndexOf:$:.
    idx == 0 ifTrue:[
	^ nm
    ].
    ^ (nm copyFrom:idx+1) asSymbol. "asSymbol was added"
!

package
    "return the value of the instance variable 'package' (automatically generated)"

    ^ package
!

package:something
    "set the value of the instance variable 'package' (automatically generated)"

    package := something.
!

source
    source isNil ifTrue:[
	self isInSmalltalk ifFalse:[
	    ^ '** no method - no source **' copy.
	].
	source := self method source.
    ].

    ^ source.
!

source:something
    "set the value of the instance variable 'source' (automatically generated)"

    source := something.
! !

!Package::PackagedMethod methodsFor:'fileIn/Out'!

fileOutOn:aWriteStream

    aWriteStream nextPut:$!!.
    aWriteStream nextPutAll:ownedClassName asString.
    aWriteStream nextPutAll:' methodsFor:'.
    aWriteStream nextPut:$'.
    aWriteStream nextPutAll:(self category).
    aWriteStream nextPut:$'.
    aWriteStream nextPut:$!!.
    aWriteStream cr.

    aWriteStream nextPutAll:self source.
    aWriteStream nextPut:$!!.
    aWriteStream cr.
! !

!Package::PackagedMethod methodsFor:'method - api'!

mclass
    ^ (Smalltalk classNamed:ownedClassName)
!

removeFromPackage
    ^ package removedMethodNamed:name forClassNamed:ownedClassName ifAbsent:[nil]
!

removeFromSystem
    | classInSmalltalk |
    self removeFromPackage.
    (self isInSmalltalk) ifTrue:[
	classInSmalltalk := Smalltalk classNamed:ownedClassName.
	classInSmalltalk ifNotNil:[
	    classInSmalltalk removeSelector:name.
	]
    ].
!

selector
    ^ name
! !

!Package::PackagedMethod methodsFor:'printing'!

printOn:aStream
    self isLoose ifTrue:[
	aStream nextPutAll:'LooseMethod:'.
    ] ifFalse:[
	aStream nextPutAll:'Method:'.
    ].

    aStream nextPutAll:self ownedClassShortName.
    aStream nextPutAll:'->', name printString.
    aStream cr.
! !

!Package::PackagedMethod methodsFor:'queries'!

isInSmalltalk
    ^ (package overriddenChangesIncludesMethodName:name forClassNamed:ownedClassName) not and:[
	(package blockedMethodsIncludeMethodName:name forClassNamed:ownedClassName) not
    ]


!

isLoose
    ^ (package includesPackagedClassNamed:ownedClassName) not
!

isTheSameAsInImage
    | myClass method|
    (myClass := (Smalltalk at:ownedClassName)) ifNotNil:[
	(method :=(myClass methodDictionary at:name ifAbsent:[nil])) ifNotNil:[
	    ^ method source = source. "there is a more efficient way but i have forgotten"
	].

    ].
    ^ false.
!

method
    | myClass|
    (myClass := self ownedClass) ifNotNil:[
	^ (myClass methodDictionary at:name ifAbsent:[nil]).
    ].
    self halt.
    ^ nil.
! !

!Package::PackagedScript class methodsFor:'instance creation'!

string:aString receiver:aPackage
    ^ self basicNew string:aString receiver:aPackage
! !

!Package::PackagedScript methodsFor:'accessing'!

getString
    ^ string
!

string:stringArg receiver:receiverArg
    "set instance variables (automatically generated)"

    string := stringArg.
    receiver := receiverArg.
! !

!Package::PackagedScript methodsFor:'evaluation'!

evaluate
    ^ Compiler evaluate:string receiver:receiver.
! !

!Package::PackagedScript methodsFor:'printing'!

printOn:aStream
      aStream nextPutAll:'Compiler evaluate:'.
      aStream nextPut:$'.
      aStream nextPutAll:string.
      aStream nextPut:$'.
      aStream nextPutAll:' receiver:('.
      aStream nextPutAll:(receiver printString).
      aStream nextPut:$).

"
    self string:'1 + 1' receiver:nil
"
! !

!Package class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/Package.st,v 1.9 2006/08/24 08:38:50 cg Exp $'
! !