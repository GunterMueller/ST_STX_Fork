"{ Package: 'stx:goodies/ring' }"!

!Behavior methodsFor:'*Ring-Core-Kernel'!

methodNamed: aSelector

    ^ self methodDict at: aSelector

    "Created: / 28-08-2015 / 09:37:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Behavior methodsFor:'*Ring-Core-Kernel'!

protocols

    ^ self organization categories copy

    "Created: / 28-08-2015 / 09:37:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'*Ring-Core-Kernel'!

asFullRingDefinition
    "A behavior is converted to a ring class including its variables, methods, direct superclass, direct subclasses and the package in which is loaded.
    Active methods are generated and each knows its package as well.
    Note that for its direct superclass and subclasses no full definitions are requested. If you need to traverse hierarchies use #asRingDefinitionWithMethods:withSuperclasses:withSubclasses:withPackages:"

    | rgClass rgSuper rgSub rgMethod packageKeys |
    rgClass:= self asRingDefinition.
    rgClass package: (RGContainer packageOfClass: rgClass).

    self superclass notNil 
        ifTrue: [ 
            rgSuper := self superclass asRingDefinition.
            rgClass superclass: rgSuper ]
        ifFalse: [  
            self isTrait ifTrue: [ 
                rgSuper := Trait asRingDefinition.
                rgClass superclass: rgSuper. ]
            ].

    self subclasses do:[ :each |
        rgSub := each asRingDefinition.
        rgSub superclass: rgClass ].

    packageKeys := RGContainer packageKeys.
    self methodsDo:[ :mth|  
            rgMethod := mth asActiveRingDefinition.
            rgClass addMethod: rgMethod.
            rgMethod package: (RGContainer packageOfMethod: rgMethod using: packageKeys) ].
    self theMetaClass methodsDo:[ :mth|  
            rgMethod := mth asActiveRingDefinition.
            rgClass theMetaClass addMethod: rgMethod.
            rgMethod package: (RGContainer packageOfMethod: rgMethod using: packageKeys) ].

    ^ rgClass

    "Created: / 28-08-2015 / 09:36:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'*Ring-Core-Kernel'!

asRingDefinition
    "A behavior is converted to a ring class. Only the receiver and its variables (instance, class, pools) are converted.
    Methods, superclasses, subclasses are not generated"
    
    | ring |
    ring := (RGClassDefinition named: self name)
        category: self category;
        superclassName: self superclass name;  
        traitCompositionSource: self traitCompositionString;
        addInstanceVariables: self instVarNames;
        addClassVariables: self classVarNames;
        addSharedPools: self sharedPoolNames;
        comment: self organization classComment;
        stamp: self organization commentStamp;
        definitionSource: self definition;
        package: (RGPackage named: self package);
        withMetaclass.
    ring theMetaClass 
        traitCompositionSource: self theMetaClass traitCompositionString;
        definitionSource: self theMetaClass definition;
        addInstanceVariables: self theMetaClass instVarNames.  
    ^ ring

    "Modified: / 28-08-2015 / 18:27:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'*Ring-Core-Kernel'!

asRingDefinitionWithMethods: methodsBoolean withSuperclasses: supersBoolean withSubclasses: subsBoolean withPackageKeys: packageKeys in: aRGSlice
    | rgClass rgMethod rgSuper rgSub subs |
    rgClass := self asRingDefinition.
    aRGSlice loadClass: rgClass using: packageKeys.
    methodsBoolean
        ifTrue: [ 
            self
                methodsDo: [ :mth | 
                    rgMethod := mth asActiveRingDefinition.
                    aRGSlice loadMethod: rgMethod inClass: rgClass using: packageKeys ].
            self theMetaClass
                methodsDo: [ :mth | 
                    rgMethod := mth asActiveRingDefinition.
                    aRGSlice loadMethod: rgMethod inClass: rgClass theMetaClass using: packageKeys ] ].
    supersBoolean
        ifTrue: [ 
            self superclass
                ifNotNil: [ 
                    rgSuper := aRGSlice classNamed: self superclass name.
                    rgSuper
                        ifNil: [ 
                            rgSuper := self superclass
                                asRingDefinitionWithMethods: methodsBoolean
                                withSuperclasses: supersBoolean
                                withSubclasses: subsBoolean
                                withPackageKeys: packageKeys
                                in: aRGSlice ].
                    rgClass superclass: rgSuper ] ].
    subsBoolean
        ifTrue: [ 
            subs := self subclasses reject: [ :sub | sub isMeta ].
            rgClass name = #Trait
                ifTrue: [ subs := aRGSlice environment allTraits ].
            subs
                do: [ :each | 
                    rgSub := aRGSlice classNamed: each name.
                    rgSub
                        ifNil: [ 
                            rgSub := each
                                asRingDefinitionWithMethods: methodsBoolean
                                withSuperclasses: supersBoolean
                                withSubclasses: subsBoolean
                                withPackageKeys: packageKeys
                                in: aRGSlice ].
                    rgSub superclass: rgClass ] ].
    ^ rgClass
! !

!Class methodsFor:'*Ring-Core-Kernel'!

asRingDefinitionWithMethods: methodsBoolean withSuperclasses: supersBoolean withSubclasses: subsBoolean withPackages: packsBoolean
    "Retrieves a ring class/trait based on the receiver.
    The data loaded in the class/trait (active methods, superclasses, subclasses and packages) is requested by the users.
    As it may need to traverse hierarchies for retrieving super and subclasses a ring slice is created as the container for every class, method and package.
    To retrieve the slice:  aRGClass environment "
    | rgClass rgSlice  rgPackageKeys |

    rgSlice := RGSlice named: #fromImage.
    packsBoolean ifTrue: [ 
        rgPackageKeys := rgSlice loadPackagesFromImage ].
    rgClass := self asRingDefinitionWithMethods: methodsBoolean withSuperclasses: supersBoolean withSubclasses: subsBoolean withPackageKeys: rgPackageKeys in: rgSlice.
    rgSlice cleanEmptyPackages.
    rgSlice loadTraitUsers.

    ^ rgClass

    "Created: / 28-08-2015 / 09:36:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'*Ring-Core-Kernel'!

asActiveRingDefinition
    "Retrieves an active RGMethodDefinition object based on the data of the receiver.
    Source, protocol and stamp are retrieved from the compiled method"
    
    ^ RGMethodDefinition new 
            name: self selector;
            parentName: self methodClass name;
            isMetaSide: self methodClass isMeta;
            asActive.
! !

!Method methodsFor:'*Ring-Core-Kernel'!

asFullRingDefinition

    "Retrieves an active RGMethodDefinition which knows its parent <class>.
    Note that the full conversion does not happen at the level of the class. If you need that request asFullRingDefinition to the class"
    | rgClass rgMethod |
    rgClass := self realClass asRingDefinition.
    rgMethod := self asActiveRingDefinition.
    rgClass addMethod: rgMethod.
    rgMethod package: (RGContainer packageOfMethod: rgMethod).
    ^ rgMethod
! !

!Method methodsFor:'*Ring-Core-Kernel'!

asHistoricalRingDefinition

    "Retrieves a historical RGMethodDefinition object based on the data of the receiver.
    Source, protocol and stamp are retrieved from the source file method"
    | ring |
    ring := (RGMethodDefinition named: self selector)
                parentName: self methodClass name;
                isMetaSide: self methodClass isMeta.

    self sourceCode isNil
        ifTrue: [ "this should not happen but sometimes the system looks corrupted"
            ring protocol: self category;
                sourceCode: self sourceCode;
                stamp: self timeStamp ]
        ifFalse: [ 
            ring sourceCode: self sourceCode ].
    ring asHistorical.    
    ^ ring

    "Modified: / 29-08-2015 / 08:01:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'*Ring-Core-Kernel'!

asPassiveRingDefinition
    "Retrieves a passive RGMethodDefinition object based on the data of the receiver.
    Source, protocol and stamp are retrieved from value assigned in creation"
    
    ^RGMethodDefinition new 
         	name: self selector;
            parentName: self methodClass name;
            isMetaSide: self methodClass isMeta;
            protocol: self category;
            sourceCode: self sourceCode;
            stamp: self timeStamp;
            asPassive.
! !

!Method methodsFor:'*Ring-Core-Kernel'!

asRingDefinition
    "Retrieves an active RGMethodDefinition object based on the receiver.
    Note that its class is not converted."
    
    ^ self asActiveRingDefinition
! !

!Method methodsFor:'*Ring-Core-Kernel'!

methodReference

    | class selector |
    class := self methodClass ifNil: [^nil].
    selector := self selector ifNil: [^nil].
    ^RGMethodDefinition realClass: class selector: selector.
    
! !

!Method methodsFor:'*Ring-Core-Kernel'!

realClass
    "answer the class that I am installed in"
    
    ^ self methodClass
! !

!Object methodsFor:'*Ring-Core-Kernel'!

isRingObject

    ^false
! !

!stx_goodies_ring class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
