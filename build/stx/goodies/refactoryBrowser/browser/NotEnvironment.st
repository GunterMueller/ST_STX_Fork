"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

BrowserEnvironmentWrapper subclass:#NotEnvironment
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!


!NotEnvironment methodsFor:'accessing'!

navigatorClass
	environment navigatorClass == ClassSelectorNavigator 
		ifTrue: [^ClassSelectorNavigator].
	^super navigatorClass
! !

!NotEnvironment methodsFor:'environments'!

not
	^environment
! !

!NotEnvironment methodsFor:'printing'!

storeOn: aStream
	environment storeOn: aStream.
	aStream nextPutAll: ' not'
! !

!NotEnvironment methodsFor:'testing'!

includesCategory: aCategory 
	^(self classNamesFor: aCategory) isEmpty not
!

includesClass: aClass 
	(environment includesClass: aClass) ifFalse: [^true].
	aClass selectorsAndMethodsDo: 
			[:each :meth | 
			(environment includesSelector: each in: aClass) ifFalse: [^true]].
	^false
!

includesProtocol: aProtocol in: aClass 
	^(self selectorsFor: aProtocol in: aClass) isEmpty not
!

includesSelector: aSelector in: aClass
	^(environment includesSelector: aSelector in: aClass) not
! !

!NotEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

