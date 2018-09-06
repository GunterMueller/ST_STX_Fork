"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

"{ NameSpace: Smalltalk }"

RefactoryChange subclass:#MethodRefactoryChange
	instanceVariableNames:'source selector protocol'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Support'
!

MethodRefactoryChange comment:'MethodRefactoryChange is a RefactoryChange that represents compiling a method.

Instance Variables:
	protocol	<Symbol>	the protocol for the new method
	selector	<Symbol>	the method name (generated from the source)
	source	<String>	the source to compile'
!


!MethodRefactoryChange methodsFor:'accessing'!

doIt
    package notNil ifTrue:[
        Class packageQuerySignal 
            answer:package
            do:[
                self theClass 
                        compile: source
                        classified: self protocol
                        notifying: nil
            ]
    ].
        self theClass 
                compile: source
                classified: self protocol
                notifying: nil

    "Modified: / 17-08-2006 / 19:17:43 / cg"
!

imageSource
    "return the source for the in-image version of the method.
     For compatibility with Change"

    ^ self methodSourceFor: selector.

    "Created: / 19-07-2011 / 13:26:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-07-2012 / 17:38:31 / cg"
!

protocol
	^protocol
!

selector
        selector isNil ifTrue: 
                        [selector := RBParser parseMethodPattern: source.
                        selector isNil ifTrue: [selector := #unknown]].
        ^selector
! !

!MethodRefactoryChange methodsFor:'initialize-release'!

class: aClass protocol: aCategory source: aString 
        package := Class packageQuerySignal query.
        class := aClass.
        protocol := aCategory.
        source := aString

    "Modified: / 17-08-2006 / 19:15:08 / cg"
!

class: aClass source: aString 
	class := aClass.
	source := aString.
	protocol := BrowserEnvironment new whichProtocolIncludes: self selector
				in: aClass.
	protocol isNil ifTrue: [protocol := #accessing]
! !

!MethodRefactoryChange methodsFor:'printing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    super displayOn:aGCOrStream.
    aGCOrStream nextPutAll:'>>'.
    self selector printOn:aGCOrStream.
!

printOn: aStream 
	aStream nextPut: $!!;
		print: class;
		nextPutAll: ' methodsFor: ''';
		nextPutAll: protocol;
		nextPutAll: '''!!';
		cr;
		cr;
		nextPutAll: source;
		nextPutAll: '!! !!'
! !

!MethodRefactoryChange class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

