"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCClassBuilder
	instanceVariableNames:'compiledClass compiledClassName constants instvars
		methodDictionary compiledSuperclass'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Core'
!


!PPCClassBuilder class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPCClassBuilder methodsFor:'accessing'!

compiledClass
    ^ compiledClass
!

compiledClassName
    ^ compiledClassName
!

compiledClassName: anObject
    compiledClassName := anObject asSymbol
!

compiledSuperclass
    ^ compiledSuperclass
!

compiledSuperclass: anObject
    compiledSuperclass := anObject
!

constants
    ^ constants
!

constants: anObject
    constants := anObject
!

instvars
    ^ instvars
!

instvars: anObject
    instvars := anObject
!

methodDictionary
    ^ methodDictionary
!

methodDictionary: anObject
    methodDictionary := anObject
! !

!PPCClassBuilder methodsFor:'cleaning'!

clean
    Smalltalk at: compiledClassName ifPresent: [  :e |
        compiledClass := e.
        self cleanGeneratedMethods.
    ]
!

cleanGeneratedMethods
    (compiledClass methodDictionary size == 0) ifTrue: [ ^ self ].

    "this is hack, but might help the performance..."
    (compiledClass methodDictionary values allSatisfy: [:m | m category beginsWith: 'generated']) ifTrue: [
        compiledClass removeFromSystem.
        compiledClass := nil.
        ^ self
    ].


    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[
        compiledClass methodsDo: [ :mthd |
            (mthd category beginsWith: 'generated') ifTrue:[
                compiledClass removeSelector: mthd selector.
            ]
        ]
    ] ifFalse: [ 
"               compiledClass methodsDo: [ :mthd |
            (mthd category beginsWith: 'generated') ifTrue:[
                compiledClass removeSelector: mthd selector.
            ]
        ]
"
"               Too slow, but more stable :("
        (compiledClass allProtocolsUpTo: compiledClass) do: [ :protocol |
            (protocol beginsWith: 'generated') ifTrue: [ 
                compiledClass removeProtocol: protocol.
            ]           
        ]
    ]

    "Modified: / 17-08-2015 / 13:55:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCClassBuilder methodsFor:'compiling'!

compileClass
    self clean.

    self installVariables.
    self installMethods.
    self setConstants.

    ^ compiledClass
!

installMethods
    methodDictionary values do: [ :method |
        (compiledClass methodDictionary includesKey: method methodName) ifFalse: [ 
            compiledClass compileSilently: method source classified: method category.
        ]
    ]

    "Modified: / 24-07-2015 / 19:45:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

installVariables
    | instvarString classvarString |
    instvarString := instvars inject: '' into: [:r :e | r, ' ', e  ].
    classvarString := constants keys inject: '' into: [:r :e | r, ' ', e  ].

    ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
        [
            compiledSuperclass 
                subclass: compiledClassName  
                instanceVariableNames: instvarString 
                classVariableNames: classvarString 
                poolDictionaries: '' 
                category: 'PetitCompiler-Generated'.
        ] on: ClassBuildWarning do:[:ex | ex proceed ].
    ] ifFalse:[
        compiledSuperclass 
            subclass: compiledClassName  
            instanceVariableNames: instvarString 
            classVariableNames: classvarString 
            poolDictionaries: '' 
            category: 'PetitCompiler-Generated'.
    ].

    compiledClass := Smalltalk at: compiledClassName.

    "Modified: / 17-08-2015 / 14:44:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

registerPackages
    ((Smalltalk respondsTo:#isSmalltalkX) and:[ Smalltalk isSmalltalkX ]) ifTrue:[
        | rPackageOrganizer |
        rPackageOrganizer := Smalltalk at: #RPackageOrganizer.
        rPackageOrganizer notNil ifTrue:[
            rPackageOrganizer default registerPackageNamed: 'PetitCompiler-Generated'.
        ].
    ] ifFalse: [ 
        RPackageOrganizer default registerPackageNamed: 'PetitCompiler-Generated'.
    ].
!

setClassVars
    constants keysAndValuesDo: [ :key :value |
        compiledClass classVarNamed: key put: value
    ]
!

setConstants
    constants keysAndValuesDo: [ :key :value |
        compiledClass classVarNamed: key put: value
    ]
! !

!PPCClassBuilder methodsFor:'initialization'!

initialize
    super initialize.
    
    methodDictionary := IdentityDictionary new.
    constants := IdentityDictionary new.
    instvars := IdentitySet new.
    
    self registerPackages.
! !

!PPCClassBuilder class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

