"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

BrowserEnvironmentWrapper subclass:#ClassEnvironment
	instanceVariableNames:'classes metaClasses'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

ClassEnvironment comment:''
!


!ClassEnvironment class methodsFor:'instance creation'!

onEnvironment: anEnvironment classes: aCollection
	^(self onEnvironment: anEnvironment)
		classes: aCollection; yourself
! !

!ClassEnvironment methodsFor:'accessing'!

classesInto:aCollection
    classes do:[:className |
	aCollection add:(Smalltalk at:className)
    ].
    metaClasses do:[:className |
	aCollection add:(Smalltalk at:className)
    ].

    "Created: / 14-01-2009 / 00:41:02 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 15-01-2009 / 10:21:10 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 26-10-2009 / 16:34:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodsInto:aCollection
    ^ aCollection

    "Created: / 14-01-2009 / 00:35:21 / Jiri Bazant <bazanj2@fel.cvut.cz>"
!

navigatorClass
	^self categories size = 1
		ifTrue: [BrowserNavigator]
		ifFalse: [SystemNavigator]
!

problemCount
	^self numberClasses
! !

!ClassEnvironment methodsFor:'accessing-classes'!

classNames
	^(Set withAll: classes) addAll: metaClasses;
		yourself
!

classesDo: aBlock
    cachedClasses notNil ifTrue:[
        cachedClasses do:aBlock
    ] ifFalse:[ 
        classes
                do:
                        [:each |
                        | class |
                        class := Smalltalk at: each ifAbsent: [nil].
                        (class notNil and: [environment includesClass: class])
                                ifTrue: [aBlock value: class]].
        metaClasses
                do:
                        [:each |
                        | class |
                        class := Smalltalk at: each ifAbsent: [nil].
                        (class notNil and: [environment includesClass: class class])
                                ifTrue: [aBlock value: class class]]
    ].
! !

!ClassEnvironment methodsFor:'adding'!

addClass: aClass
	aClass isMeta
		ifTrue: [metaClasses add: aClass soleInstance name]
		ifFalse: [classes add: aClass name]
! !

!ClassEnvironment methodsFor:'copying'!

postCopy
	classes := classes copy.
	metaClasses := metaClasses copy.
	^super postCopy
! !

!ClassEnvironment methodsFor:'initialize-release'!

classes: aCollection
	aCollection do: [:each | self addClass: each]
!

initialize
	super initialize.
	classes := Set new.
	metaClasses := Set new
! !

!ClassEnvironment methodsFor:'printing'!

storeOn: aStream
	aStream nextPut: $(.
	super storeOn: aStream.
	aStream nextPutAll: ' classes: (('.
	classes asArray storeOn: aStream.
	aStream nextPutAll: ' inject: OrderedCollection new into: [:sum :each |
				| class |
				class := Smalltalk at: each ifAbsent: [nil].
				class notNil ifTrue: [sum add: class].
				sum]) , ('.
	metaClasses asArray storeOn: aStream.
	aStream nextPutAll: ' inject: OrderedCollection new into: [:sum :each |
				| class |
				class := Smalltalk at: each ifAbsent: [nil].
				class notNil ifTrue: [sum add: class class].
				sum])))'
! !

!ClassEnvironment methodsFor:'private'!

defaultLabel
        | stream |
        classes size > 3 ifTrue:[^classes size printString , ' classes'].
        stream := '' writeStream.
        classes do:
                        [:each |
                        stream nextPutAll: each;
                                nextPut: $ ].
        ^stream contents

    "Modified: / 13-04-2011 / 20:00:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassEnvironment methodsFor:'removing'!

removeClass: aClass
	aClass isMeta
		ifTrue: [metaClasses remove: aClass soleInstance name ifAbsent: []]
		ifFalse: [classes remove: aClass name ifAbsent: []]
! !

!ClassEnvironment methodsFor:'testing'!

includesCategory: aCategory
	^(super includesCategory: aCategory)
		and: [(environment classNamesFor: aCategory)
				inject: false into: [:bool :each | bool
					or:
						[| class |
						class := Smalltalk at: each ifAbsent: [nil].
						class notNil and: [(self includesClass: class)
								or: [self includesClass: class class]]]]]
!

includesClass: aClass
	^(aClass isMeta
		ifTrue: [metaClasses includes: aClass soleInstance name]
		ifFalse: [classes includes: aClass name])
			and: [super includesClass: aClass]
!

isClassEnvironment
	^true
!

isEmpty
	^classes isEmpty and: [metaClasses isEmpty]
! !

!ClassEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

