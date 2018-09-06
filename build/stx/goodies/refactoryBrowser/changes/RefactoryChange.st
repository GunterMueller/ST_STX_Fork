"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RefactoryChange
	instanceVariableNames:'name class package'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!

RefactoryChange comment:'RefactoryChange is an abstract class that represent some change to a class or method. They are used in combination with RefactoryBuilders to give transaction-like behavior.

Subclasses must implement the following messages:
	accessing
		doIt

Instance Variables:
	class   <Behavior>      the class that is to be changed'
!


!RefactoryChange class methodsFor:'instance creation'!

new
        ^self basicNew initialize
! !

!RefactoryChange methodsFor:'accessing'!

changeClass
    ^ self theClass.
    "/ ^ class

    "Modified: / 16-11-2016 / 20:49:01 / cg"
!

changeForClass: aRBClass selector: aSelector 
	^nil
!

changeForMetaclass: aSymbol selector: aSelector 
	^nil
!

changeLanguage

    ^SmalltalkLanguage instance

    "Created: / 02-02-2010 / 10:54:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSource

    "Compatibility with Change (from libbasic3)"

    ^self source

    "Created: / 19-07-2011 / 12:51:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changes
	^Array with: self
!

changesSize
	^1
!

delta
    "/ obsolete: please use deltaDetail

    "Returns a delta to current state as symbol:
        #+ .....the subject is to be added to the image (new)
        #- .....the subject is to be removed from the image (old)
        #= .....the image is up to date
        #~ .....change version and image version differ
        #? .....delta is unknown or N/A for this kind of change
    "

    ^#? "We don't know how to compute delta for generic change"

    "Modified (comment): / 31-08-2011 / 10:30:00 / cg"
!

deltaDetail
    "Returns a delta to the current state as a ChangeDelta object"

    ^ ChangeDeltaInformation unknown   "We don't know how to compute delta for generic change"

    "Created: / 31-08-2011 / 10:29:11 / cg"
!

doIt
	^self subclassResponsibility
!

imageSource
    "Compatibility with Change (from libbasic3)"

    ^nil

    "Created: / 19-07-2011 / 12:51:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-07-2012 / 17:38:40 / cg"
!

name
	^name isNil ifTrue: [self changeString] ifFalse: [name]
!

removed

    ^(self objectAttributeAt: #removed) ? false

    "Created: / 24-10-2009 / 21:10:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removed: aBoolean

    ^self objectAttributeAt: #removed put: aBoolean

    "Created: / 24-10-2009 / 21:11:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

renameChangesForClass: aClassName to: newClassName 
	"We're in the middle of performing a rename operation. If we stored 
	the class name, we need to change the class name to the new 
	name to perform the compiles."

	self subclassResponsibility
!

source

    
    ^self printString
!

theClass
    class notNil ifTrue:[
        RBParser isSmalltalkX ifTrue:[
            " kludge: since in ST/X, a class object                     "
            " changes its identity, when instvars are added/removed     "
            " we refetch it here (by name).                             "
            " (make all accesses to class via this method)              "
            class isMeta ifTrue:[
                class := (Smalltalk at:class theNonMetaclass name) class
            ] ifFalse:[
                class := Smalltalk at:class name
            ]
        ].
    ].
    ^ class

    "Modified: / 16-11-2016 / 20:49:33 / cg"
!

timeOfChangeIfKnown
    "Return nil, for compatibility with Change"

    ^nil

    "Created: / 04-04-2012 / 13:51:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RefactoryChange methodsFor:'enumerating'!

do: aBlock
    "Enumerates all changes evaluation aBlock for each"

    aBlock value: self.

    "Created: / 04-02-2012 / 21:18:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RefactoryChange methodsFor:'initialization & release'!

name: aString
	name := aString
! !

!RefactoryChange methodsFor:'inspecting'!

inspector2TabBrowser

    ^self newInspector2Tab
        label: 'Changes';    
        priority: 35;
        application: (Tools::ChangeSetBrowser on: (ChangeSet with:self))

    "Modified: / 13-09-2011 / 11:56:16 / cg"
!

inspector2Tabs
    ^ super inspector2Tabs , #( inspector2TabBrowser )

    "Created: / 05-07-2011 / 13:40:36 / cg"
    "Modified: / 13-02-2015 / 21:02:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RefactoryChange methodsFor:'performing-changes'!

apply

    "Added for compatibility with stx's Change classes"

    ^RefactoryChangeManager performChange: self

    "Created: / 26-11-2008 / 11:26:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

execute
	^self executeNotifying: []
!

executeWithMessage: aString 
	| tally controller model done |
	model := 0 asValue.
	done := 0.
	tally := self changesSize.
	controller := aString isNil 
				ifTrue: [nil]
				ifFalse: [ProgressWidgetView progressOpenOn: model label: aString].
	model value: 0.
	^
	[self executeNotifying: 
			[done := done + 1.
			model value: done asFloat / tally]] 
			ensure: [controller notNil ifTrue: [controller closeAndUnschedule]]
! !

!RefactoryChange methodsFor:'printing'!

changeString
	^self class name
!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    aGCOrStream nextPutAll:(name isNil ifTrue:[self changeString] ifFalse:[name])
!

printOn: aStream
	aStream print: class name
! !

!RefactoryChange methodsFor:'private'!

executeNotifying: aBlock 
	self subclassResponsibility
!

flattenOnto: aCollection 
	aCollection add: self
!

flattenedChanges
	| changes |
	changes := OrderedCollection new.
	self flattenOnto: changes.
	^changes
! !

!RefactoryChange methodsFor:'queries'!

shouldBeConfirmed
    "Return true, if the refactoring change should be confirmed
     before applying. Used to suppress confirming *trivial* changes
     but only iff `UserPreferences current confirmRefactorings` is true."

    ^false

    "Created: / 04-04-2012 / 14:09:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-08-2013 / 12:03:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RefactoryChange methodsFor:'testing'!

isClassChange

    ^false
!

isClassDefinitionChange

    ^false

    "Created: / 29-10-2010 / 13:34:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isComplexRefactoryChange
    ^ false

    "Created: / 26-11-2008 / 11:56:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isCompositeChange
    ^ false

    "Created: / 26-11-2008 / 11:34:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isCompositeRefactoryChange
    ^ false

    "Created: / 26-11-2008 / 11:34:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isConflict
    "true if this change is different than what is already in the image
     (i.e. it overwrites some existing code)"

    ^true

    "Created: / 24-04-2013 / 14:45:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMethodCodeChange
    ^false

    "Modified (format): / 04-04-2012 / 15:21:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isOrContainsClassDefinitionChange
    ^ false

    "Created: / 21-02-2014 / 22:44:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isRefactoryChange
    ^ true
!

isRemoveMethodChange
    ^ false
! !

!RefactoryChange methodsFor:'user interface'!

inspect

    ^super inspect

   "
        ^((CompositeRefactoryChange new)
                changes: (Array with: self);
                yourself) inspect

   "
! !

!RefactoryChange class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

