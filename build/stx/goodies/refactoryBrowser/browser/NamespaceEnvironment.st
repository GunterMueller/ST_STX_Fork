"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

"{ NameSpace: Smalltalk }"

BrowserEnvironmentWrapper subclass:#NamespaceEnvironment
	instanceVariableNames:'namespaceNames'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

!NamespaceEnvironment class methodsFor:'documentation'!

documentation
"
    An environment representing all classes (and their methods) in given namespaces.
    Smalltalk/X specific.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!NamespaceEnvironment class methodsFor:'instance creation'!

onEnvironment: anEnvironment namespaceNames: aCollection
        ^ (self onEnvironment: anEnvironment) 
                namespaceNames: aCollection;
                yourself

    "Created: / 02-04-2014 / 11:40:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceEnvironment methodsFor:'accessing'!

asSelectorEnvironment
	| result |
	result := SelectorEnvironment onEnvironment: environment.
	self classesAndSelectorsDo: [ :class :selector | result addClass: class selector: selector ].
	^ result
!

classesAndSelectorsDo: aBlock

    environment classesAndSelectorsDo:[:cls :sel|
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

namespaceNames
    ^ namespaceNames
!

namespaceNames:something
    namespaceNames := something.
!

numberSelectors
    ^ namespaceNames sum:[:package | package methods size ]

    "Modified: / 16-03-2011 / 23:06:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceEnvironment methodsFor:'copying'!

postCopy
	super postCopy.
	namespaceNames := namespaceNames copy
! !

!NamespaceEnvironment methodsFor:'initialize-release'!

initialize
	super initialize.
	namespaceNames := Set new
! !

!NamespaceEnvironment methodsFor:'printing'!

storeOn: aStream 
        aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' onEnvironment: '.
        environment storeOn: aStream.
        aStream nextPutAll: ' namespaceNames: '.
        self namespaceNames asArray storeOn: aStream.
        aStream nextPut: $)

    "Modified: / 02-04-2014 / 11:43:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceEnvironment methodsFor:'testing'!

definesClass: aClass
        ^ (super definesClass: aClass) and: 
                [ self namespaceNames includes: aClass environment name ]

    "Modified: / 02-04-2014 / 11:44:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesCategory:aCategory

    (super includesCategory:aCategory) ifFalse:[ ^ false ].
    environment classesDo: [:cls |
        (self includesClass: cls) ifTrue:[ ^ true ].
    ].
    ^false.

    "Modified: / 02-04-2014 / 11:48:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesClass:aClass 
    |nsNames|

    (super includesClass:aClass) ifFalse:[^ false].

    nsNames := self namespaceNames.
    "used to send #environment instead of #nameSpace - but some classes redefine #environment (expecco)"
    (nsNames includes:aClass theNonMetaclass nameSpace name) ifTrue:[^ true].
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

    "Modified: / 02-04-2014 / 11:46:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

