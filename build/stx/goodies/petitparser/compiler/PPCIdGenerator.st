"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCIdGenerator
	instanceVariableNames:'idCache numericIdCache'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Compiler-Codegen'
!

!PPCIdGenerator class methodsFor:'as yet unclassified'!

new
    ^ self basicNew initialize
! !

!PPCIdGenerator methodsFor:'accessing'!

ids
    ^ idCache keys
!

numericIdCache
    ^ numericIdCache
!

numericIds
    ^ numericIdCache keys
! !

!PPCIdGenerator methodsFor:'as yet unclassified'!

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

cachedSuchThat: block ifNone: noneBlock
    | key |
    key := idCache keys detect: block ifNone: [ nil ].
    key isNil ifTrue: [ ^ noneBlock value ].
    
    ^ idCache at: key
!

generateIdFor: object defaultName: defaultName prefix: prefix suffix: suffix  
    | name count |
    object canHavePPCId ifTrue: [ 
        name := object hasName ifTrue: [ object name ] ifFalse: [ object defaultName ].
        name := self asSelector: name asString.
        
        "JK: I am not sure, if prefix and suffix should be applied to the name or not..."
        suffix isNil ifFalse: [ 
            name := name, '_', suffix.		
        ].
    
        prefix isNil ifFalse: [ 
            name := prefix , '_', name.		
        ].	
        
        "(idCache contains: [ :e | e = name ]) ifTrue: [  self error: 'Duplicit names?' ]."
    ] ifFalse: [ 
        name := defaultName.

        prefix isNil ifFalse: [ 
            name := prefix , '_', name.		
        ].

        suffix isNil ifFalse: [ 
            name := name, '_', suffix.		
        ].

        name := self asSelector: name asString.
        
    ].

    (idCache contains: [ :e | e = name ]) ifTrue: [  
        count := 2. 
        
        [	| tmpName |	
            tmpName := (name, '_', count asString).
            idCache contains: [:e | e = tmpName ]
        ] whileTrue: [ count := count + 1 ].

        name := name, '_', count asString
    ].
    
    ^ name asSymbol
!

idFor: object
    self assert: object canHavePPCId.
    ^ self idFor: object defaultName: object defaultName prefix: object prefix suffix: object suffix
!

idFor: object defaultName: defaultName
    ^ self idFor: object defaultName: defaultName prefix: nil suffix: nil
!

idFor: object defaultName: defaultName prefix: prefix
    ^ self idFor: object defaultName: defaultName prefix: prefix suffix: ''
!

idFor: object defaultName: defaultName prefix: prefix suffix: suffix
    ^ idCache at: object ifAbsentPut: [ 
        self generateIdFor: object defaultName: defaultName prefix: prefix suffix: suffix
    ]
!

isCachedSuchThat: block
    ^ idCache keys contains: block
!

isCachedSuchThat: block ifTrue: trueBlock ifFalse: falseBlock
    ^ (idCache keys contains: block) ifTrue: [trueBlock value] ifFalse: [falseBlock value]
!

numericIdFor: object
    self assert: object isSymbol.
    ^ numericIdCache at: object ifAbsentPut: [ numericIdCache size + 1 ]

    "Modified: / 17-08-2015 / 22:55:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCIdGenerator methodsFor:'initialization'!

initialize
    super initialize.
    idCache := IdentityDictionary new.
    numericIdCache := IdentityDictionary new.
! !

