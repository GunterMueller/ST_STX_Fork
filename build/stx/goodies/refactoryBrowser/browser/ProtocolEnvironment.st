"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

BrowserEnvironmentWrapper subclass:#ProtocolEnvironment
	instanceVariableNames:'classes protocols'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

ProtocolEnvironment comment:'ProtocolEnvironment represents a collection of protocols in a class to be browsed.

Instance Variables:
	class   <Behavior>      the class that contains the protocols
	protocols       <Collection of: Symbol> the protocols to be browsed'
!


!ProtocolEnvironment class methodsFor:'instance creation'!

onEnvironment: anEnvironment class: aClass protocols: aCollection
	^(self onEnvironment: anEnvironment)
		class: aClass protocols: aCollection; yourself
! !

!ProtocolEnvironment methodsFor:'accessing'!

navigatorClass
	^BrowserNavigator
! !

!ProtocolEnvironment methodsFor:'copying'!

postCopy
	protocols := protocols copy.
	^super postCopy
! !

!ProtocolEnvironment methodsFor:'initialize-release'!

class: aClass protocols: aCollection
        classes := (Array with: aClass).
        protocols := aCollection

    "Modified: / 21-08-2015 / 23:41:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classes: someClasses protocols: someProtocols
        classes := someClasses.
        protocols := someProtocols

    "Created: / 21-08-2015 / 23:41:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProtocolEnvironment methodsFor:'printing'!

storeOn: aStream 
        aStream nextPut: $(.
        super storeOn: aStream.
        aStream
                nextPutAll: ' classes: ('.
        classes asArray storeOn: aStream.
        aStream
                nextPutAll: ') protocols: '.
        protocols asArray storeOn: aStream.
        aStream nextPut: $)

    "Modified: / 21-08-2015 / 23:48:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProtocolEnvironment methodsFor:'private'!

defaultLabel
    | stream |
        stream := '' writeStream.
    classes size == 1 ifTrue:[ 
        stream nextPutAll: classes anElement name.
    ] ifFalse:[ 
        classes size == 2 ifTrue:[ 
            stream 
                nextPutAll: classes first name;
                nextPutAll: ' and ';
                nextPutAll: classes second name.
        ] ifFalse:[ 
            classes size printOn: stream.
            stream nextPutAll: ' classes'.
        ].
    ].
    stream nextPutAll: label;
           nextPut: $>.
    protocols do: 
                    [:each | 
                    stream nextPutAll: each;
                            nextPut: $ ].
    ^stream contents

    "Modified (format): / 21-08-2015 / 23:52:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProtocolEnvironment methodsFor:'testing'!

includesCategory: aCategory
        ^(super includesCategory: aCategory)
                and: [(environment classNamesFor: aCategory)
                                inject: false into: [:bool :each | bool
                                        or:
                                                [| aClass |
                                                aClass := Smalltalk at: each ifAbsent: [nil].
                                                (classes includes: aClass) or: [classes includes: aClass class ]]]]

    "Modified: / 21-08-2015 / 23:42:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesClass: aClass
        ^(classes includes: aClass) and: [super includesClass: aClass]

    "Modified: / 21-08-2015 / 23:43:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesProtocol: aProtocol in: aClass
        ^(classes includes: aClass) and: [(super includesProtocol: aProtocol in: aClass)
                        and: [protocols includes: aProtocol]]

    "Modified: / 21-08-2015 / 23:43:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesSelector: aSelector in: aClass 
	^(super includesSelector: aSelector in: aClass) and: 
			[protocols 
				includes: (environment whichProtocolIncludes: aSelector in: aClass)]
!

isEmpty
	^protocols isEmpty
! !

!ProtocolEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Id$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

