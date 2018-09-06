"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

BrowserEnvironment subclass:#BrowserEnvironmentWrapper
	instanceVariableNames:'environment'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

BrowserEnvironmentWrapper comment:'BrowserEnvironmentWrapper is a wrapper for BrowserEnvironments that limits what is shown. While it does not have any #subclassResponsibility methods, it is an abstract class since it doesn''t provide any useful behavior by itself

Instance Variables:
	environment     <BrowserEnvironment>    the environment we''re wrapping'
!


!BrowserEnvironmentWrapper class methodsFor:'instance creation'!

new
	^self onEnvironment: BrowserEnvironment new
!

onEnvironment: anEnvironment 
	^(self basicNew)
		initialize;
		onEnvironment: anEnvironment;
		yourself
! !

!BrowserEnvironmentWrapper class methodsFor:'queries'!

isAbstract
    ^ self == BrowserEnvironmentWrapper
! !

!BrowserEnvironmentWrapper methodsFor:'accessing'!

selectionIntervalFor: aString 
	| interval |
	interval := super selectionIntervalFor: aString.
	^interval notNil 
		ifTrue: [interval]
		ifFalse: [environment selectionIntervalFor: aString]
! !

!BrowserEnvironmentWrapper methodsFor:'initialize-release'!

onEnvironment: anEnvironment
	environment := anEnvironment
! !

!BrowserEnvironmentWrapper methodsFor:'printing'!

storeOn: aStream 
	aStream
		nextPutAll: '(';
		nextPutAll: self class name;
		nextPutAll: ' onEnvironment: '.
	environment storeOn: aStream.
	aStream nextPut: $)
! !

!BrowserEnvironmentWrapper methodsFor:'private'!

environment
	^environment
! !

!BrowserEnvironmentWrapper methodsFor:'testing'!

includesCategory: aCategory
	^environment includesCategory: aCategory
!

includesClass: aClass
	^environment includesClass: aClass
!

includesProtocol: aProtocol in: aClass
	^(self includesClass: aClass)
		and: [environment includesProtocol: aProtocol in: aClass]
!

includesSelector: aSelector in: aClass
	^(self includesClass: aClass)
		and: [environment includesSelector: aSelector in: aClass]
!

isEmpty
	self classesDo: [:each | ^false].
	^true
!

isSystem
	^false
! !

!BrowserEnvironmentWrapper class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

