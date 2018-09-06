"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

"{ NameSpace: Smalltalk }"

RefactoryClassChange subclass:#AddMethodChange
	instanceVariableNames:'source selector protocols'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!AddMethodChange class methodsFor:'instance creation'!

compile: aString in: aClass 
	^self new class: aClass source: aString
!

compile: aString in: aBehavior classified: aProtocol 
	^self new 
		class: aBehavior
		protocol: aProtocol
		source: aString
! !

!AddMethodChange methodsFor:'accessing'!

changeForClass: aSymbol selector: aSelector 
	^(isMeta not and: [self selector = aSelector and: [className = aSymbol]])
		ifTrue: [self]
		ifFalse: [nil]
!

changeForMetaclass: aSymbol selector: aSelector 
	^(isMeta and: [self selector = aSelector and: [className = aSymbol]])
		ifTrue: [self]
		ifFalse: [nil]
!

imageSource
    "return the source for the in-image version of the method"

    ^self methodSourceFor: selector.

    "Created: / 19-07-2011 / 13:26:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-07-2012 / 17:36:45 / cg"
!

package
        ^package

    "Created: / 17-08-2006 / 19:11:15 / cg"
!

protocol
	^self protocols first
!

protocols
	^protocols
!

selector
	selector isNil 
		ifTrue: 
			[selector := RBParser parseMethodPattern: source.
			selector isNil ifTrue: [selector := #unknown]].
	^selector
!

source
    ^ source
! !

!AddMethodChange methodsFor:'comparing'!

= anAddMethodChange 
	super = anAddMethodChange ifFalse: [^false].
	^self parseTree = anAddMethodChange parseTree
!

hash
	^self parseTree hash
! !

!AddMethodChange methodsFor:'converting'!

asUndoOperation
        ^(self changeClass includesSelector: self selector) 
                ifTrue: 
                        [| oldProtocol oldPackage |
                        oldProtocol := BrowserEnvironment new whichProtocolIncludes: self selector
                                                in: self changeClass.
                        oldProtocol isNil ifTrue: [oldProtocol := #accessing].
                        oldPackage := (self changeClass compiledMethodAt: self selector) package.
                        (AddMethodChange 
                                compile: (self methodSourceFor: self selector)
                                in: self changeClass
                                classified: oldProtocol) 
                                package: oldPackage;
                                yourself]
                ifFalse: [RemoveMethodChange remove: selector from: self changeClass]

    "Modified: / 16-11-2014 / 17:13:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!AddMethodChange methodsFor:'initialization & release'!

class: aClass protocol: aProtocol source: aString 
        package := Class packageQuerySignal query.
        self changeClass: aClass.
        self protocols: aProtocol.
        source := aString

    "Modified: / 17-08-2006 / 19:15:16 / cg"
!

class: aClass source: aString 
	self changeClass: aClass.
	source := aString.
	self protocols: (BrowserEnvironment new whichProtocolIncludes: self selector in: aClass)
!

protocols: aCollection 
	protocols := aCollection isString 
				ifTrue: [Array with: aCollection]
				ifFalse: [aCollection].
	protocols isNil ifTrue: [protocols := #(#accessing)]
!

source: aString 

    source := aString.
! !

!AddMethodChange methodsFor:'printing'!

changeString
        ^self displayClassName , '>>' , self selector allBold
!

printOn: aStream 
	aStream
		nextPut: $!!;
		nextPutAll: self displayClassName;
		nextPutAll: ' methodsFor: ''';
		nextPutAll: self protocol;
		nextPutAll: '''!!!!';
		cr;
		cr;
		nextPutAll: source;
		nextPutAll: '!! !!'
! !

!AddMethodChange methodsFor:'private'!

controller
	^nil
!

parseTree
	^RBParser parseMethod: source onError: [:str :pos | ^nil]
!

primitiveExecute
    package notNil ifTrue:[
        Class packageQuerySignal 
            answer:package
            do:[
                ^ self changeClass 
                        compile: source
                        classified: self protocol
                        notifying: self controller
            ]
    ].

    ^self changeClass 
            compile: source
            classified: self protocol
            notifying: self controller

    "Modified: / 17-08-2006 / 19:12:14 / cg"
! !

!AddMethodChange methodsFor:'testing'!

isMethodCodeChange

    ^true
! !

!AddMethodChange class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !


