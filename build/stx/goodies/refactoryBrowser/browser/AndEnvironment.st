"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

BrowserEnvironmentWrapper subclass:#AndEnvironment
	instanceVariableNames:'andedEnvironment'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!


!AndEnvironment class methodsFor:'instance creation'!

onEnvironment: anEnvironment and: anotherEnvironment 
	^(self onEnvironment: anEnvironment)
		andedEnvironment: anotherEnvironment;
		yourself
! !

!AndEnvironment methodsFor:'accessing'!

classesDo: aBlock 
    cachedClasses notNil ifTrue:[
        cachedClasses do:aBlock
    ] ifFalse:[ 
        environment 
                classesDo: [:each | (self includesClass: each) ifTrue: [aBlock value: each]]
    ].
!

navigatorClass
	environment navigatorClass == ClassSelectorNavigator 
		ifTrue: [^ClassSelectorNavigator].
	andedEnvironment navigatorClass == ClassSelectorNavigator 
		ifTrue: [^ClassSelectorNavigator].
	^super navigatorClass
!

numberSelectors
    | total |
    total := 0.
    environment classesAndSelectorsDo:[:eachClass :sel | 
        (andedEnvironment includesSelector: sel in: eachClass) ifTrue: [
            total := total + 1
        ]
    ].
    ^total
!

problemCount
	^environment isClassEnvironment 
		ifTrue: [self numberClasses]
		ifFalse: [super problemCount]
!

selectionIntervalFor: aString 
	| interval |
	interval := super selectionIntervalFor: aString.
	interval notNil ifTrue: [^interval].
	^andedEnvironment selectionIntervalFor: aString
!

selectorsForClass: aClass do: aBlock 
	environment selectorsForClass: aClass
		do: 
			[:each | 
			(andedEnvironment includesSelector: each in: aClass) 
				ifTrue: [aBlock value: each]]
! !

!AndEnvironment methodsFor:'initialize-release'!

andedEnvironment: aBrowserEnvironment 
	andedEnvironment := aBrowserEnvironment
! !

!AndEnvironment methodsFor:'printing'!

storeOn: aStream 
	aStream nextPut: $(.
	environment storeOn: aStream.
	aStream nextPutAll: ' & '.
	andedEnvironment storeOn: aStream.
	aStream nextPut: $)
! !

!AndEnvironment methodsFor:'private'!

andedEnvironment
	^andedEnvironment
! !

!AndEnvironment methodsFor:'testing'!

includesCategory: aCategory 
	^(self classNamesFor: aCategory) isEmpty not
!

includesClass: aClass 
	| doesntHaveSelectors |
	(environment includesClass: aClass) ifFalse: [^false].
	(andedEnvironment includesClass: aClass) ifFalse: [^false].
	doesntHaveSelectors := true.
	environment selectorsForClass: aClass
		do: 
			[:each | 
			doesntHaveSelectors := false.
			(andedEnvironment includesSelector: each in: aClass) ifTrue: [^true]].
	^doesntHaveSelectors
!

includesProtocol: aProtocol in: aClass 
	^(self selectorsFor: aProtocol in: aClass) isEmpty not
!

includesSelector: aSelector in: aClass 
	^(environment includesSelector: aSelector in: aClass) 
		and: [andedEnvironment includesSelector: aSelector in: aClass]
! !

!AndEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

