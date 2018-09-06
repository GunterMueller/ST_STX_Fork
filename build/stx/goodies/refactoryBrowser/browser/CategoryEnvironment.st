"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

BrowserEnvironmentWrapper subclass:#CategoryEnvironment
	instanceVariableNames:'categories'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

CategoryEnvironment comment:'CategoryEnvironment represents browsing some selected categories. All methods/classes not in the categories are not shown in the browser..

Instance Variables:
	categories      <Collection of: Symbol> the category names to browse'
!


!CategoryEnvironment class methodsFor:'instance creation'!

onEnvironment: anEnvironment categories: aCollection
	^(self onEnvironment: anEnvironment)
		categories: aCollection; yourself
! !

!CategoryEnvironment methodsFor:'accessing'!

categories
	^categories select: [:each | self includesCategory: each]
!

navigatorClass
	^categories size = 1
		ifTrue: [BrowserNavigator]
		ifFalse: [SystemNavigator]
!

numberSelectors
	| total |
	total := 0.
	self 
		classesDo: [:each | self selectorsForClass: each do: [:sel | total := total + 1]].
	^total
! !

!CategoryEnvironment methodsFor:'accessing-classes'!

classNames
	^self categories inject: OrderedCollection new into: [:col :each | col addAll: (self classNamesFor: each); yourself]
!

classesInto:aCollection
    self classesDo: [:eachClass | aCollection add:eachClass]

    "Created: / 04-09-2011 / 20:06:30 / cg"
!

methodsInto:aCollection
    self classesDo: [:eachClass | 
        self selectorsForClass: eachClass do: [:sel | 
            aCollection add:(eachClass compiledMethodAt: sel).
        ]
    ]

    "Created: / 04-09-2011 / 20:08:08 / cg"
! !

!CategoryEnvironment methodsFor:'copying'!

postCopy
	categories := categories copy.
	^super postCopy
! !

!CategoryEnvironment methodsFor:'initialize-release'!

categories: aCollection
	categories := aCollection
!

initialize
	super initialize.
	categories := Set new
! !

!CategoryEnvironment methodsFor:'printing'!

storeOn: aStream
        aStream nextPut: $(.
        super storeOn: aStream.
        aStream nextPutAll: ' categories: '.
        categories asArray storeOn: aStream.
        aStream nextPut: $)
! !

!CategoryEnvironment methodsFor:'private'!

defaultLabel
        | stream |
        stream := '' writeStream.
        categories do: [:each | stream nextPutAll: each; nextPut: $ ].
        ^stream contents
! !

!CategoryEnvironment methodsFor:'testing'!

addCategory: aCategory
        categories add: aCategory

    "Created: / 04-09-2011 / 19:58:24 / cg"
!

includesCategory: aCategory
	^(categories includes: aCategory)
		and: [super includesCategory: aCategory]
!

includesClass: aClass 
	| nonMetaClass |
        (super includesClass: aClass) ifFalse:[ ^ false ]
        
        Smalltalk isSmalltalkX ifTrue:[
                ^categories includes:aClass category
        ] ifFalse:[
                
                nonMetaClass := aClass theNonMetaclass.
                ^categories 
                    includes: (environment whichCategoryIncludes: nonMetaClass name)
        ]
        
!

isEmpty
	^categories isEmpty
!

whichCategoryIncludes: aClassName
        ^environment whichCategoryIncludes: aClassName
! !

!CategoryEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

