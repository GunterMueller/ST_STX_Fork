"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

BrowserEnvironmentWrapper subclass:#PackageEnvironment
	instanceVariableNames:'packageNames'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

!PackageEnvironment class methodsFor:'documentation'!

documentation
"
    An environment representing all classes and extension methods in given packages.
    Smalltalk/X specific.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!PackageEnvironment class methodsFor:'instance creation'!

onEnvironment: anEnvironment packageNames: aCollection
        ^ (self onEnvironment: anEnvironment) 
                packageNames: aCollection;
                yourself

    "Modified: / 16-03-2011 / 23:06:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageEnvironment methodsFor:'accessing'!

asSelectorEnvironment
	| result |
	result := SelectorEnvironment onEnvironment: environment.
	self classesAndSelectorsDo: [ :class :selector | result addClass: class selector: selector ].
	^ result
!

classesAndSelectorsDo: aBlock

    environment classesAndSelectorsDo: [:cls :sel|
        (self includesSelector: sel in: cls) ifTrue:[
            "/ aBlock value: sel value: cls
            aBlock value: cls value: sel
        ]
    ].

    "Modified: / 16-03-2011 / 23:20:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classesDo: aBlock
    | alreadyEnumerated|

    cachedClasses notNil ifTrue:[
        cachedClasses do:aBlock
    ] ifFalse:[ 
        alreadyEnumerated := IdentitySet new.

        environment classesDo:[:cls|
            (self includesClass: cls) ifTrue:[
                (alreadyEnumerated includes: cls) ifFalse: [
                    (environment includesClass: cls) ifTrue: [ aBlock value: cls ].
                    (environment includesClass: cls class) ifTrue: [ aBlock value: cls class ].
                    alreadyEnumerated add: cls 
                ] 
            ] 
        ].
    ].

    "Modified: / 16-03-2011 / 23:19:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numberSelectors
    |count|

    count := 0.
    self classesAndSelectorsDo:[:c :sel|count := count+1].
    ^ count

"/    ^ packageNames 
"/        sum:[:package | 
"/            package isSymbol ifTrue:[
"/                |n|
"/
"/                n := 0.
"/                Smalltalk allClassesInPackage:package do:[:cls |
"/                    n := n + cls theNonMetaclass methodsCount + cls theMetaclass methodsCount
"/                ].
"/                n
"/            ] ifFalse:[
"/                package methods size 
"/            ]    
"/        ]

    "Modified: / 16-03-2011 / 23:06:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageNames
        ^ packageNames

    "Modified: / 16-03-2011 / 23:04:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageNames:aCollection
    packageNames := aCollection asSet.
!

packageNamesMatchingAny:aCollectionOfMatchPatterns
    self packageNames:
        (Smalltalk allPackageIDs select:[:p |
            aCollectionOfMatchPatterns contains:[:pattern |
                (pattern = p) or:[ pattern includesMatchCharacters and:[ pattern match:p ]]
            ]
        ])    
! !

!PackageEnvironment methodsFor:'copying'!

postCopy
        super postCopy.
        packageNames := packageNames copy.
! !

!PackageEnvironment methodsFor:'initialize-release'!

initialize
	super initialize.
	packageNames := Set new
! !

!PackageEnvironment methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' onEnvironment: '.
	environment storeOn: aStream.
	aStream nextPutAll: ' packageNames: '.
	self packageNames asArray storeOn: aStream.
	aStream nextPut: $)
! !

!PackageEnvironment methodsFor:'testing'!

definesClass: aClass
        ^ (super definesClass: aClass) 
        and: [ self packageNames includes: aClass package ]

    "Modified: / 16-03-2011 / 23:17:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesCategory:aCategory 
    ^ (super includesCategory:aCategory) 
    and: [ 
        self packageNames anySatisfy: [:package | 
            environment classes anySatisfy: [:cls|cls category = aCategory]]
    ].

    "Modified: / 16-03-2011 / 23:16:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesClass:aClass 
    |packageNames|

    (super includesClass:aClass) ifFalse:[^ false].

    packageNames := self packageNames.
    (packageNames includes:aClass package) ifTrue:[^ true].
    aClass instAndClassMethodsDo:[:m | 
        (packageNames includes:m package) ifTrue:[^ true].
    ].
    ^ false
"/ the code below creates a lot of temporary collections,
"/ and also forgot about class methods
"/
"/    ^ (super includesClass:aClass) and:
"/            [ self packageNames anySatisfy:
"/                    [:package | 
"/                    aClass package = package or:
"/                        [aClass methodDictionary values anySatisfy:
"/                            [:m|m package = package]]]].

    "Modified: / 07-10-2011 / 11:57:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesProtocol:aProtocol in:aClass 
    ^ (environment includesProtocol:aProtocol in:aClass) 
    and:[
        environment classesAndSelectorsDo: [:cls :sel| 
            | mthd |
            
            mthd := cls compiledMethodAt: sel.
            mthd category = aProtocol 
            and: [self packageNames includes: mthd package]
        ]
    ].

    "Modified: / 16-03-2011 / 23:13:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesSelector:aSelector in:aClass 
    ^ (environment includesSelector:aSelector in:aClass) 
    and: [ 
        self packageNames includes: (aClass compiledMethodAt: aSelector) package
    ]

    "Modified: / 16-03-2011 / 23:33:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPackageEnvironment
    ^ true
! !

!PackageEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

