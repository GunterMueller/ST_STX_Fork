"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

BrowserEnvironment subclass:#LimitedEnvironment
	instanceVariableNames:'environment'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

LimitedEnvironment comment:'LimitedEnvironment is a wrapper for BrowserEnvironments that limits what is shown. While it does not have any #subclassResponsibility methods, it is an abstract class since it doesn''t provide any useful behavior by itself

Instance Variables:
	environment	<BrowserEnvironment>	the environment we''re wrapping'
!


!LimitedEnvironment class methodsFor:'instance creation'!

new
	^self onEnvironment: BrowserEnvironment new
!

onEnvironment: anEnvironment
	^(self basicNew) initialize; onEnvironment: anEnvironment; yourself
! !

!LimitedEnvironment methodsFor:'accessing'!

whichCategoryIncludes: aClassName
	^environment whichCategoryIncludes: aClassName
! !

!LimitedEnvironment methodsFor:'accessing-classes'!

classesDo: aBlock
    cachedClasses notNil ifTrue:[
        cachedClasses do:aBlock
    ] ifFalse:[ 
        self classNames
                do:
                        [:each |
                        | class |
                        class := self at: each ifAbsent: [nil].
                        class notNil
                                ifTrue:
                                        [(self includesClass: class)
                                                ifTrue: [aBlock value: class].
                                        (self includesClass: class class)
                                                ifTrue: [aBlock value: class class]]]
    ]
! !

!LimitedEnvironment methodsFor:'initialize-release'!

onEnvironment: anEnvironment
	environment := anEnvironment
! !

!LimitedEnvironment methodsFor:'testing'!

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

isSystem
	^false
! !

!LimitedEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

