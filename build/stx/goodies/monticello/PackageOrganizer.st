"{ Package: 'stx:goodies/monticello' }"

Object subclass:#PackageOrganizer
	instanceVariableNames:'packages'
	classVariableNames:''
	poolDictionaries:''
	category:'PackageInfo-Base'
!

PackageOrganizer class instanceVariableNames:'default'

"
 No other class instance variables are inherited by this class.
"
!


!PackageOrganizer class methodsFor:'as yet unclassified'!

default
	^ default ifNil: [default := self new]
!

new
	^ self basicNew initialize
! !

!PackageOrganizer methodsFor:'accessing'!

packageNames
	^ packages keys
!

packages
	^ packages values
! !

!PackageOrganizer methodsFor:'initializing'!

initialize
	super initialize.
	packages := Dictionary new
! !

!PackageOrganizer methodsFor:'private'!

mostSpecificPackageIn: aCollection ifNone: aBlock
	aCollection isEmpty
		ifTrue: [ ^ aBlock value ].
	^ (aCollection asArray
		sort: [ :a :b | a packageName size > b packageName size ])
		first
! !

!PackageOrganizer methodsFor:'registering'!

registerPackage: aPackageInfo
	packages at: aPackageInfo packageName put: aPackageInfo.
	self changed: #packages; changed: #packageNames.
!

registerPackageNamed: aString
	^ self registerPackage: (PackageInfo named: aString)
!

unregisterPackage: aPackageInfo
	packages removeKey: aPackageInfo packageName ifAbsent: [].	
	self changed: #packages; changed: #packageNames.
!

unregisterPackageNamed: aString
	self unregisterPackage: (self packageNamed: aString ifAbsent: [^ self])
! !

!PackageOrganizer methodsFor:'searching'!

allPackagesContainingUnimplementedCalls
	"Answer a Set of Packages that have classes which contain messages that 
	 have unimplemented calls"
	^ (SystemNavigation default allClassesWithUnimplementedCalls keys collect: [:d|
		(self packageOfClass: d) packageName
	]) .
!

mostSpecificPackageOfClass: aClass
	^ self mostSpecificPackageOfClass: aClass ifNone: [self noPackageFound]
!

mostSpecificPackageOfClass: aClass ifNone: aBlock
	
	^ self 
		mostSpecificPackageIn: (self packages select: [ :each | each includesClass: aClass ])
		ifNone: aBlock
!

mostSpecificPackageOfMethod: aMethodReference
	^ self mostSpecificPackageOfMethod: aMethodReference ifNone: [self noPackageFound]
!

mostSpecificPackageOfMethod: aMethodReference ifNone: aBlock

	^ self  
		mostSpecificPackageIn: (self packages select: [ :each | each includesMethodReference: aMethodReference ])
		ifNone: aBlock
!

noPackageFound
	self error: 'No package found'
!

packageNamed: aString ifAbsent: errorBlock
	^ packages at: aString ifAbsent: errorBlock
!

packageOfClass: aClass
	^ self packageOfClass: aClass ifNone: [self noPackageFound]
!

packageOfClass: aClass ifNone: errorBlock
	^ self packages detect: [:ea | ea includesClass: aClass] ifNone: errorBlock
!

packageOfMethod: aMethodReference
	^ self packageOfMethod: aMethodReference ifNone: [self noPackageFound]
!

packageOfMethod: aMethodReference ifNone: errorBlock
	^ self packages detect: [:ea | ea includesMethodReference: aMethodReference] ifNone: errorBlock
! !

!PackageOrganizer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/PackageOrganizer.st,v 1.1 2011-08-20 13:18:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/PackageOrganizer.st,v 1.1 2011-08-20 13:18:01 cg Exp $'
!

version_SVN
    ^ '§Id: PackageOrganizer.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
