"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCPackageManager
	instanceVariableNames:'package modified'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!

MCPackageManager class instanceVariableNames:'registry'

"
 No other class instance variables are inherited by this class.
"
!


!MCPackageManager class methodsFor:'as yet unclassified'!

allManagers
	^ self registry values
!

forPackage: aPackage
	^ self registry at: aPackage ifAbsent:
		[|mgr|
		mgr _ self new initializeWithPackage: aPackage.
		self registry at: aPackage put: mgr.
		self changed: #allManagers.
		mgr]
!

initialize
	"Remove this later"
	Smalltalk at: #SystemChangeNotifier ifPresent:[:cls|
		(cls uniqueInstance) noMoreNotificationsFor: self.
	].
!

registry
	^ registry ifNil: [registry _ Dictionary new]
! !

!MCPackageManager class methodsFor:'system changes'!

classModified: anEvent
	self managersForClass: anEvent item do:[:mgr| mgr modified: true].
!

classMoved: anEvent
	self classModified: anEvent.
	self managersForCategory: anEvent oldCategory do:[:mgr| mgr modified: true].
!

classRemoved: anEvent
	self classModified: anEvent
!

managersForCategory: aSystemCategory do: aBlock
	"Got to be careful here - we might get method categories where capitalization is problematic."
	| cat foundOne index |
	foundOne := false.
	cat := aSystemCategory ifNil:[^nil]. "yes this happens; for example in eToy projects"
	"first ask PackageInfos, their package name might not match the category"
	self registry do: [:mgr | 
		(mgr packageInfo includesSystemCategory: aSystemCategory)	ifTrue: [
			aBlock value: mgr.
			foundOne := true.
		]
	].
	foundOne ifTrue: [^self].
	["Loop over categories until we found a matching one"
	self registry at: (MCPackage named: cat) ifPresent:[:mgr|
		aBlock value: mgr.
		foundOne := true.
	].
	index := cat lastIndexOf: $-.
	index > 0]whileTrue:[
		"Step up to next level package"
		cat := cat copyFrom: 1 to: index-1.
	].
	foundOne ifFalse:[
		"Create a new (but only top-level)"
		aBlock value: (MCWorkingCopy forPackage: (MCPackage named: (aSystemCategory upTo: $-) capitalized)).
	].
!

managersForClass: aClass category: methodCategory do: aBlock
	(methodCategory isEmptyOrNil or:[methodCategory first ~= $*]) ifTrue:[
		"Not an extension method"
		^self managersForClass: aClass do: aBlock.
	].
	self managersForCategory: methodCategory allButFirst do: aBlock.
!

managersForClass: aClass do: aBlock

	self registry do: [:mgr |
		(mgr packageInfo includesClass: aClass)
			ifTrue: [aBlock value: mgr]]
!

managersForClass: aClass selector: aSelector do: aBlock
	^self managersForClass: aClass category: (aClass organization categoryOfElement: aSelector) do: aBlock
!

methodModified: anEvent
	^self managersForClass: anEvent itemClass selector: anEvent itemSelector do:[:mgr| mgr modified: true].
!

methodMoved: anEvent
	self managersForClass: anEvent itemClass category: anEvent oldCategory do:[:mgr| mgr modified: true].
	self methodModified: anEvent.
!

methodRemoved: anEvent
	self managersForClass: anEvent itemClass category: anEvent itemProtocol do:[:mgr| mgr modified: true].
!

registerForNotifications
	Smalltalk at: #SystemChangeNotifier ifPresent:[:cls|
	(cls uniqueInstance)
		noMoreNotificationsFor: self;
		notify: self ofSystemChangesOfItem: #class change: #Added using: #classModified:;
		notify: self ofSystemChangesOfItem: #class change: #Modified using: #classModified:;
		notify: self ofSystemChangesOfItem: #class change: #Renamed using: #classModified:;
		notify: self ofSystemChangesOfItem: #class change: #Commented using: #classModified:;
		notify: self ofSystemChangesOfItem: #class change: #Recategorized using: #classMoved:;
		notify: self ofSystemChangesOfItem: #class change: #Removed using: #classRemoved:;
		notify: self ofSystemChangesOfItem: #method change: #Added using: #methodModified:;
		notify: self ofSystemChangesOfItem: #method change: #Modified using: #methodModified:;
		notify: self ofSystemChangesOfItem: #method change: #Recategorized using: #methodMoved:;
		notify: self ofSystemChangesOfItem: #method change: #Removed using: #methodRemoved:
	].
! !

!MCPackageManager methodsFor:'accessing'!

modified
	^ modified
!

modified: aBoolean
     modified = aBoolean ifTrue: [^ self].
	modified _ aBoolean.
	self changed: #modified.
	
	modified ifFalse:
		[(((Smalltalk classNamed: 'SmalltalkImage') ifNotNilDo: [:si | si current]) ifNil: [Smalltalk])
			logChange: '"', self packageName, '"'].
!

package
	^ package
!

packageInfo
	^ package packageInfo
!

packageName
	^ package name
!

packageNameWithStar
	^ modified
		ifTrue: ['* ', self packageName]
		ifFalse: [self packageName]
! !

!MCPackageManager methodsFor:'initialize-release'!

initialize
	modified _ false.
	self registerForNotifications.
!

initializeWithPackage: aPackage
	package _ aPackage.
	self initialize.
! !

!MCPackageManager methodsFor:'operations'!

unregister
	self class registry removeKey: package.
	self class changed: #allManagers
! !

!MCPackageManager methodsFor:'system changes'!

classModified: anEvent
	"obsolete - remove this later"
!

classMoved: anEvent
	"obsolete - remove this later"
!

classRemoved: anEvent
	"obsolete - remove this later"
!

methodModified: anEvent
	"obsolete - remove this later"
!

methodMoved: anEvent 
	"obsolete - remove this later"
!

methodRemoved: anEvent
	"obsolete - remove this later"
!

registerForNotifications
	"obsolete - remove this later"
!

registerForNotificationsFrom: aNotifier
	"obsolete - remove this later"
!

systemChange: anEvent
	"obsolete - remove this later"
!

update: aSymbol
	InMidstOfFileinNotification signal ifFalse: [
	[((aSymbol = #recentMethodSubmissions)
		and: [self packageInfo
				includesMethodReference: Utilities recentMethodSubmissions last])
					ifTrue: [self modified: true]]
		on: Error do: []]
! !

!MCPackageManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPackageManager.st,v 1.2 2012-09-11 21:14:07 cg Exp $'
! !

MCPackageManager initialize!
