"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

AbstractPackageManager subclass:#PackageManager
	instanceVariableNames:'workingPackage defaultPackage'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Managers'
!

PackageManager class instanceVariableNames:'currentPackage currentManager imageChanges'

"
 No other class instance variables are inherited by this class.
"
!

!PackageManager class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    PackageManager smalltalkPackageManager

    [author:]
	 (james@miraculix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

documentation_exceptions
"

    ClassDescription fileOutErrorSignal
	    can occur when a class within a package is autoloaded. Handle in application

    [author:]
	 (james@miraculix)

"
!

examples
"

  more examples to be added:
								[exBegin]
    ... add code fragment for
    ... executable example here ...
								[exEnd]
"
!

history
    "Created: / 27.1.2003 / 13:57:50 / james"
! !

!PackageManager class methodsFor:'instance creation'!

initialize
    "Uninitialize Singleton"
    currentManager ifNotNil:[
	currentManager uninitialize.
	currentManager := nil.
	currentPackage := nil.
    ]

"
    self initialize
"
!

newManagerOfCurrentImage
    | anInstance |
    anInstance := self new.

    self basicPackagesInImage do:[:aPackage |
	package isInstalled:true.
	anInstance addPackage:aPackage
    ].
    ^ anInstance

"
currentManager := self newManagerOfCurrentImage.
"
! !

!PackageManager class methodsFor:'* As yet uncategorized *'!

basePackageNames
    ^ (Array with:(Project noProjectID)) ,
	#(
	    #'stx:clients/AddrBook'
	    #'stx:clients/Animation'
	    #'stx:clients/Clock'
	    #'stx:clients/Demos'
	    #'stx:clients/DirView'
	    #'stx:clients/DocTool'
	    #'stx:clients/DrawTool'
	    #'stx:clients/GLdemos'
	    #'stx:clients/GuessingGame'
	    #'stx:clients/LogicTool'
	    #'stx:clients/MailTool'
	    #'stx:clients/NewsTool'
	    #'stx:clients/PingPong'
	    #'stx:clients/Tetris'
	    #'stx:clients/TicTacToe'
	    #'stx:clients/TicTacToe3D'
	    #'stx:clients/Tools'
	    #'stx:goodies'
	    #'stx:goodies/benchmarks'
	    #'stx:goodies/benchmarks/deltaBlue'
	    #'stx:goodies/benchmarks/dhrystones'
	    #'stx:goodies/benchmarks/misc'
	    #'stx:goodies/benchmarks/richards'
	    #'stx:goodies/benchmarks/self'
	    #'stx:goodies/communication'
	    #'stx:goodies/dhbNumeric'
	    #'stx:goodies/distributions'
	    #'stx:goodies/glorp'
	    #'stx:goodies/lisp'
	    #'stx:goodies/math/fibonacci'
	    #'stx:goodies/measurement'
	    #'stx:goodies/minneStore'
	    #'stx:goodies/obsolete'
	    #'stx:goodies/persistency'
	    #'stx:goodies/postscript'
	    #'stx:goodies/prolog'
	    #'stx:goodies/rdoit'
	    #'stx:goodies/refactoryBrowser'
	    #'stx:goodies/regex'
	    #'stx:goodies/remoteObjects'
	    #'stx:goodies/screenSavers'
	    #'stx:goodies/sif'
	    #'stx:goodies/smaCC'
	    #'stx:goodies/soap'
	    #'stx:goodies/soap/examples'
	    #'stx:goodies/soap/opera'
	    #'stx:goodies/soap/splash'
	    #'stx:goodies/soap/spray'
	    #'stx:goodies/soap/wsdl'
	    #'stx:goodies/soap/xe'
	    #'stx:goodies/soap/xmlsig'
	    #'stx:goodies/sound'
	    #'stx:goodies/stmath'
	    #'stx:goodies/stxInExternalWindow'
	    #'stx:goodies/sunit'
	    #'stx:goodies/swazoo'
	    #'stx:goodies/tgen'
	    #'stx:goodies/webServer'
	    #'stx:goodies/webServer/pwsSwiki'
	    #'stx:goodies/xml-indelv'
	    #'stx:goodies/xml-vw'
	    #'stx:goodies/xml-yaxo'
	    #'stx:libbasic'
	    #'stx:libbasic2'
	    #'stx:libbasic3'
	    #'stx:libboss'
	    #'stx:libcomp'
	    #'stx:libcompat'
	    #'stx:libhtml'
	    #'stx:libjava'
	    #'stx:libjava/examples'
	    #'stx:libjavascript'
	    #'stx:libodbc'
	    #'stx:libopengl'
	    #'stx:libsnmp'
	    #'stx:libtable'
	    #'stx:libtool'
	    #'stx:libtool2'
	    #'stx:libui'
	    #'stx:libview'
	    #'stx:libview2'
	    #'stx:libwidg'
	    #'stx:libwidg2'
	    #'stx:libwidg3'
    )
! !

!PackageManager class methodsFor:'accessing'!

changes
    imageChanges ifNil:[
	imageChanges := OrderedCollection new.
    ].
    ^ imageChanges
!

smalltalkPackageManager
    "/ to clear the singleton for the moment
     | workingPackage packagesInImage|

    "/    self initialize.
    currentManager
	ifNil:[
	    currentManager := self new.

	    packagesInImage := self basicPackagesInImage.
	    workingPackage := packagesInImage removeKey:(Project noProjectID).

	    currentManager addPackages:(packagesInImage).
	    currentManager defaultPackage:workingPackage.
	].
    ^ currentManager
! !

!PackageManager class methodsFor:'defaults'!

defaultPackages
    ^ DictionaryStack new.
! !

!PackageManager class methodsFor:'factory'!

defaultPackage
    ^ (Packages::Package named:#'__NoProject__')
!

packageClass
    ^ Package
! !

!PackageManager class methodsFor:'temporary'!

basicPackagesInImage
    "builds up dictionary of the packages in the system taking the information of the classes and
    methods so we have a complete picture but without the prerequisite information.
    returns the dictionary"
    | packagesInImage extentions clsPkg |

    packagesInImage := Dictionary new.
    extentions := Dictionary new.

    "collect the classes and mark where the extentions are"
    Smalltalk allClasses do:[:aClass |
	    aClass isNameSpace ifFalse:[
		clsPkg := aClass package.
		((packagesInImage at: clsPkg
				 ifAbsentPut:[clsPkg == #'__NoProject__' ifTrue:[
				    (Package named:clsPkg)
				 ] ifFalse:[(Package named:clsPkg)
				 ].         ])
		    addedClass:aClass).

"/                aClass hasExtensions ifTrue:[
		    aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
			|mthdPkg|
			mthdPkg := mthd package.
			mthdPkg ~= clsPkg ifTrue:[| methodPackage |
			    "this is found out when you add a class!!"
"/                            (packagesInImage at: clsPkg) removeMethod:mthd. "does not belong to the package"
			    methodPackage :=
				    (packagesInImage at: mthdPkg ifAbsentPut:[
					mthdPkg == #'__NoProject__' ifTrue:[
					    (Package named:mthdPkg)
					 ] ifFalse:[(Package named:mthdPkg)
					 ].
				     ]).
			     methodPackage  addedMethod:mthd

			].
"/                    ].
		]
	    ]
    ].
"/    packagesInImage removeKey:#''.    "remove namespaces"
    packagesInImage do:[:aPackage |
	aPackage initializeInstalled.
    ].
    "the following is needed in a fresh image!!"
    packagesInImage at:#'__NoProject__' ifAbsentPut:[(Package named:#'__NoProject__')].
    ^ packagesInImage
! !

!PackageManager methodsFor:'accessing'!

allClassCategories
    | allClassCategories |
    allClassCategories := SortedCollection new.

    self packagesDo:[:aPackage |
	allClassCategories addAll:aPackage classCategories
    ].

    ^ allClassCategories
!

allPackageCategories
    ^ (self packages collect:[:aPackage | aPackage category]) asSet.
!

changes
    ^ self class changes
!

defaultPackage
    "return the value of the instance variable 'defaultPackage' (automatically generated)"

    ^ defaultPackage
!

defaultPackage:something
    "set the value of the instance variable 'defaultPackage' if the current default package
    is also the working package. Change the working package "

    workingPackage == defaultPackage ifTrue:[
	workingPackage := something.
    ].

    defaultPackage := something.
!

packageNamed:anIdentifier
    ^ self packageNamed:anIdentifier ifAbsent:[nil]
!

packageNamed:anIdentifier ifAbsent:aBlock
    anIdentifier ifNil:[
	^ aBlock value
    ].
    defaultPackage name == anIdentifier ifTrue:[
	^ defaultPackage
    ].
    ^ packages atKey:anIdentifier ifAbsent:aBlock
!

packagesAtCategoryName:aCategoryName
    ^ self packages select:[:aPackage |
	(aPackage isInCategoryNamed:aCategoryName)
    ].
!

packagesNamed:aCollectionOfPackageNames

    ^ (aCollectionOfPackageNames collect:[:aName |
	self packageNamed:aName
    ]).
!

smalltalkChanges
    ^ self class changes
!

workingPackage
    "return the value of the instance variable 'workingPackage' (automatically generated)"

    ^ workingPackage
!

workingPackage:aPackage
    ((aPackage == defaultPackage) or:[self includesPackage:aPackage]) ifFalse:[
	self error:'Trying to make a package that i do not know about the workingPackage!!'
    ].

    workingPackage removeDependent:self.
    workingPackage:= aPackage.
    workingPackage addDependent:self.
! !

!PackageManager methodsFor:'adding & removing'!

addChange:aChange
    ^ self class changes add:aChange.
!

addPackage:aPackage
    "the reciever needs to be dependent on the packages just in case they change"
    aPackage addDependent:self.
    self basicAddPackage:aPackage.
    self changed:#addPackage: with:aPackage
!

addPackages:aPackages
    "the reciever needs to be dependent on the packages just in case they change"
    aPackages do:[:aPackage |
	self basicAddPackage:aPackage.
    ].
    self changed:#addPackages: with:aPackages
!

basicAddPackage:aPackage
    "the reciever needs to be dependent on the packages just in case they change"
    packages push:aPackage.
!

basicRemovePackage:aPackage
    ^ packages removeKey:aPackage name
!

removeChange:aChange
    ^ self class changes remove:aChange.
!

removePackage:aPackage
    "the reciever needs to be dependent on the packages just in case they change"
    aPackage removeDependent:self.
    self basicRemovePackage:aPackage.
    self changed:#removePackage: with:aPackage
!

removePackageNamed:aPackageName
    | aPackage |
    aPackage := (packages removeKey:aPackageName).
    aPackage removeDependent:self.
    self changed:#removePackage: with:aPackage
! !

!PackageManager methodsFor:'api'!

addClass:aClass toPackage:newPackage
    "A manager type of the method which should not be called from Smalltalk changes"
    | oldPackageName oldPackage |

    (self includesPackage:newPackage) ifFalse:[
	self error:'The package manager does not know of the package ', newPackage name.
    ].
    oldPackageName := aClass package.
    oldPackage := self packageNamed:oldPackageName.

    (oldPackageName == newPackage name) ifTrue:["error??"
	newPackage addedClass:aClass.
	^ self
    ].

    self setClass:aClass toPackage:newPackage.
    PackageError handle:[:ex |
	self setClass:aClass toPackage:oldPackage.
	ex raise.
    ] do:[
	newPackage addedClass:aClass.
	oldPackage overrideClassNamed:aClass name byPackageNamed:newPackage name.
    ].
!

addMethod:aMethod toPackage:newPackage
    | oldPackageName oldPackage|

    (self includesPackage:newPackage) ifFalse:[
	self error:'The package manager does not know of the package ', newPackage name.
    ].
"/    self moveClass:aClass toPackage:newPackage.
    oldPackageName := aMethod package.
    oldPackage := self packageNamed:oldPackageName.

    (oldPackageName == newPackage name) ifTrue:[
	newPackage addedMethod:aMethod.
	^ self  "error??"
    ].

    aMethod setPackage:newPackage name.

    newPackage addedMethod:aMethod.
    oldPackage overrideMethod:aMethod byPackageNamed:newPackage name.
!

installPackage:aPackage
    "installs a package that the receiver is aware of into the image if not raise an error
    for the sender to catch so it is able to handle it"
    (self includesPackage:aPackage) ifFalse:[
	self error:'The package manager does not know of the package ', aPackage name,' so it cannot be installed!!'
    ].
    ^ (self getPackageHandlerForPackage:aPackage) installPackageIn:self
!

loadPackageFromFile:aFilename
    "install a starter package which comes from a file. This is the
    a state where the package has not yet entered the image but it
    is a package that the receiver is aware of and has some initial
    information about. Return the installed Package"

    ^ (self getPackageReaderForFile:aFilename) loadPackageIn:self .
!

moveClass:aClass toPackage:newOwnerPackage
    "i have the responsibilty to set aClasses new variable (newOwnerPackage name) and
    all the methods in aClass with the same package name!!
    "
    | oldOwnerPackage|

    oldOwnerPackage := self packageNamed:aClass package.

    oldOwnerPackage ifNil:[
	"error handling - if a package has accidentially been removed
	and i do not know about it. Fake it and put it in the default package"
       oldOwnerPackage := defaultPackage.
       self setClass:aClass toPackage:defaultPackage.
       (defaultPackage includesPackagedClassNamed:aClass name) ifTrue:[
	   defaultPackage removedClassNamed:aClass name.
       ].
       defaultPackage addedClass:aClass.
    ].

    oldOwnerPackage == newOwnerPackage ifTrue:[
	(oldOwnerPackage includesPackagedClassNamed:aClass name) ifFalse:[
	    self setClass:aClass toPackage:newOwnerPackage.
	    oldOwnerPackage addedClass:aClass.
	].
	^ self.
    ].
    "change the value of package to the new name... not sure if this is the correct place for this"
    (oldOwnerPackage notNil
	and:[aClass package == oldOwnerPackage name]) ifTrue:[
	    self setClass:aClass toPackage:newOwnerPackage.
    ].

    self moveClassNamed:aClass name fromPackage:oldOwnerPackage toPackage:newOwnerPackage.
!

moveClassNamed:aClassName fromPackage:fromPackage toPackage:newOwnerPackage
    "i have the responsibilty to set aClasses new variable (newOwnerPackage name) and
    all the methods in aClass with the same package name!!
    "
    | oldOwnerPackage oldOwnerPackageIncludesMovingClass oldPackageMovingClass newPackagedClass |

    oldOwnerPackage := fromPackage.
    oldPackageMovingClass := (oldOwnerPackage packagedClassNamed:aClassName).
    oldOwnerPackageIncludesMovingClass := oldPackageMovingClass notNil.

    oldOwnerPackageIncludesMovingClass ifFalse:[
	self error:'Error ', fromPackage name, ' does not know this class!!'.
	^ self.
    ].

    (oldOwnerPackage == newOwnerPackage) ifTrue:[
	"Mmm interesting. There is not much to do here. oldOwnerPackage knows the class already"
	^ self
    ].
    (newPackagedClass := newOwnerPackage packagedClassNamed:aClassName) ifNotNil:[
	PackageError raiseErrorString:newOwnerPackage name,  ' already knows a class with this name. Remove this class from here first!!'.
	^ self.
    ].
    oldOwnerPackage movedClassNamed:aClassName toPackage:newOwnerPackage
!

moveMethod:aMethod toPackage:newOwnerPackage
    |oldOwnerPackage|

    aMethod mclass ifNil:[
	self error:'Cannot move a method without an owning class!!'
    ].

    oldOwnerPackage := self packageNamed:aMethod package ifAbsent:[defaultPackage].

    self setMethod:aMethod toPackage:newOwnerPackage.
    (oldOwnerPackage definesSelector:aMethod name forClassNamed:(aMethod mclass name asSymbol)) ifFalse:[
	newOwnerPackage addedMethod:aMethod.
	^ self
    ].
    oldOwnerPackage movedMethod:aMethod toPackage:newOwnerPackage
!

removeClassNamed:aClass fromPackage:fromPackage
    ^ self removeClassNamed:aClass fromPackage:fromPackage moveToDefaultPackage:true.
!

removeClassNamed:removeClassName fromPackage:fromPackage moveToDefaultPackage:moveToDefaultPackage
    "this is different from removing a class from a system. If you want to do that do
    aClass removeFromSystem and the package manager will react!!

    This is an administration remove on the packages and just moves aClass to the responsibility
    of the package manager's default class and removes all responsibilites from fromPackage.

    "
    | overriddingPackage overriddingPackageName removingPackagedClass |
    removingPackagedClass :=  (fromPackage packagedClassNamed:removeClassName).
    (self includesPackage:fromPackage) ifFalse:[
	self error:'The package manager does not know of the package ', fromPackage name.
    ].

    fromPackage == defaultPackage ifTrue:[
	"when the packaged class is in the defaultClass it is removed from the system!!!!"
	^ removingPackagedClass removeFromSystem.
    ].
    "if the fromPackage has been overridden all that needs to be done is that the
    packages that the fromPackage has overridden needs to be swapped to the package that
    the fromPackage has been overridden by. Then it can be removed from the fromPackage"
    removingPackagedClass isInSmalltalk ifFalse:[
	overriddingPackageName := (fromPackage overriddingPackageNameAtClassName:removeClassName).
	overriddingPackage := self packageNamed:overriddingPackageName.
	overriddingPackage ifNotNil:[
	    self packagesDo:[:aPackage |
		(fromPackage ~= aPackage and:[aPackage ~= defaultPackage]) ifTrue:[
		    ((aPackage overriddenClassNamesByPackage:fromPackage) includes:removeClassName) ifTrue:[
			"to keep class in smalltalk"

			aPackage changePackageOverrideFromPackage:fromPackage toPackage:overriddingPackage
			    forClassNamed:removeClassName.
		    ].
		].
	    ].
	    ^ removingPackagedClass removeFromPackage.
	].
    ].

    "when we are here the fromPackage holds the currentRepresentation of the class in Smalltalk"
    moveToDefaultPackage ifTrue:[ | return |
	self setClass:removingPackagedClass classInSmalltalk toPackage:defaultPackage.
	self packagesDo:[:aPackage |
	    ((aPackage overriddenClassNamesByPackage:fromPackage) includes:removeClassName) ifTrue:[
		"to keep class in smalltalk"
		aPackage changePackageOverrideFromPackage:fromPackage toPackage:defaultPackage
		    forClassNamed:removeClassName.
	    ].
	].
	return := removingPackagedClass removeFromPackage.
	removingPackagedClass package:defaultPackage.
	defaultPackage addedPackagedClass:removingPackagedClass.
	^ return
    ].

    ^ removingPackagedClass removeFromSystem.
!

removeMethod:aMethod fromPackage:aPackage
    "add method to a package. At this point it is determined to be a loose method or not"
    (self includesPackage:aPackage) ifFalse:[
	self error:'The package manager does not know of the package ', aPackage name.
    ].
    aPackage removedMethod:aMethod
!

savePackage:aPackage
    self savePackage:aPackage as:aPackage filename.
!

savePackage:aPackage as:aFilename
    "saves a package that the receiver is aware of if not raise an error
    for the sender to catch so it is able to handle it"
    (self includesPackage:aPackage) ifFalse:[
	self error:'This package manager is not responsible of the package ', aPackage name,' so it cannot be saved!!'
    ].

    (self getPackageHandlerForPackage:aPackage) savePackageAs:aFilename.
    ^ aPackage.
!

uninstallPackage:aPackage
    "need to include the restoration of packages aPackage has overridden!!!!!!!!"
    (self includesPackage:aPackage) ifFalse:[
	self error:'The package manager does not know of the package ', aPackage name,' so it cannot be uninstalled!!'
    ].

    (self isBasePackage:aPackage) ifTrue:[
	self error:aPackage name asString, ' is a base package and cannot be uninstalled!!'.
    ].

    aPackage uninstallFromManager:self.
!

unloadPackage:aPackage
    "unloads the package from the receiver.Does not need to
     make any checks here as it is not installed."

    (self includesPackage:aPackage) ifFalse:[
	self error:'The package manager does not know of the package ', aPackage name.
    ].

    (self isBasePackage:aPackage) ifTrue:[
	self error:aPackage name asString, ' is a base package and cannot be unloaded!!'.
    ].

    aPackage isInstalled ifTrue:[
	self uninstallPackage:aPackage.
    ].
    self removePackage:aPackage.
    aPackage removeFromSystem.
    self changed:#unloadPackage: with:aPackage.
    ^ aPackage.
!

unloadPackageNamed:aPackageName
    "unloads the package from the receiver.Does not need to
     make any checks here as it is not installed."
    | aPackage |
    (self includesPackageNamed:aPackageName) ifFalse:[
	self error:'The package manager does not know of the package ', aPackageName.
    ].
    aPackage := self packageNamed:aPackageName.
    aPackage == workingPackage ifTrue:[
	PackageNotification raiseUnloadingWorkingPackage:aPackageName.
	workingPackage := defaultPackage.
    ].

    self unloadPackage:aPackage.
! !

!PackageManager methodsFor:'basic admin'!

setClass:aClass toPackage:newOwnerPackage
    "sets the variable package in both class and methods belonging to the class
     but only with the same name as the classes old package"
    |oldOwnerPackageName newOwnerPackageName|
    newOwnerPackageName := newOwnerPackage name.
    oldOwnerPackageName := aClass package.
    aClass setPackage:newOwnerPackageName.
    aClass methodDictionary copy keysAndValuesDo:[:aMethodName :aMethod |
	aMethod package == oldOwnerPackageName ifTrue:[
	    aMethod setPackage:newOwnerPackageName
	].
    ].

    aClass class methodDictionary copy keysAndValuesDo:[:aMethodName :aMethod |
	aMethod package == oldOwnerPackageName ifTrue:[
	    aMethod setPackage:newOwnerPackageName
	].
    ].
!

setMethod:aMethod toPackage:newOwnerPackage
    "sets the variable package"
    aMethod setPackage:newOwnerPackage name.
! !

!PackageManager methodsFor:'change & update'!

changeSetChanged:something with:aChange from:changedObject
    "find out what type of change it is and send the packages the corresponding
     message to is if they are affected. If they are they should (if they are behaving)
    send me a change notification to inform me about it(see packageChanged:with:from:)!!
    "
    | classNameOfChange packageName changeClass changeMethod |
    aChange isCollection ifTrue:[
	something == #removeAll: ifTrue:[
	    "happens after checking in"
"/            self smalltalkChanges removeAll:aChange
	].
	^ self "do i need to do anything???"
    ].
    (aChange isClassChange) ifFalse:[
	self error:' What is this???'.
    ].

    (aChange isKindOf:self methodPackageChangeClass) ifTrue:[| aMethod methodOwnedClass oldPackageName |
	aMethod := aChange previousVersion.
	methodOwnedClass := aChange changeClass.
	oldPackageName := aChange oldPackageName.
	self methodPackageChange:aMethod class:methodOwnedClass oldPackageName:oldPackageName.
	^ self
    ].
    (aChange isKindOf:self classPackageChangeClass) ifTrue:[| classToMove oldPackageName |
	classToMove := aChange changeClass.
	oldPackageName := aChange oldPackageName.
	self classPackageChange:classToMove oldPackageName:oldPackageName.
	^ self
    ].

    (aChange isMethodCategoryChange) ifTrue:[
	self packagesDo:[:aPackage |
	     "(aPackage isDependentOnMethodNamed:aChange selector forClassNamed:aChange className)" false ifTrue:[
		aPackage methodCategoryChange:aChange.
	    ].
	].
	^ self
    ].

    "the following is similar to the one above"
    (aChange isMethodCategoryRenameChange) ifTrue:[
	self packagesDo:[:aPackage |
	    "(aPackage isDependentOnMethodNamed:aChange selector forClassNamed:aChange className)"  false ifTrue:[
		aPackage methodCategoryRenameChange:aChange.
	    ].
	].
	^ self
    ].

    (aChange isMethodRemoveChange) ifTrue:[
	self packagesDo:[:aPackage |
	    (aPackage isDependentOnMethodNamed:aChange selector forClassNamed:aChange className) ifTrue:[
		aChange previousVersion ifNotNil:[
		    aPackage methodRemoveChange:aChange.
		].
	    ].
	].
	^ self
    ].

    (aChange isMethodChange) ifTrue:[
	"A new created method or a modified method"
	changeMethod := aChange changeMethod.
	packageName := changeMethod package.

	self packagesDo:[:aPackage |
	    (Switch new)
		if:[(aPackage name == packageName)] then:[
		    self addMethod:changeMethod toPackage:aPackage];
		if:[(aPackage isDependentOnMethodNamed:aChange selector forClassNamed:aChange className)] then:[
		    aPackage methodChanged:aChange];
		value.
	].
	^ self
    ].

    aChange isClassChange ifTrue:[
	(aChange isClassRemoveChange) ifTrue:[
	    "results in one package being overridden by Smalltalk"
	    classNameOfChange := aChange className asSymbol.
	    self packagesDo:[:aPackage |
		(Switch new)
		    if:[(aPackage isDependentOnClassNamed:classNameOfChange)] then:[
			aPackage classRemoveChange:aChange];
		    value.
		].
	    ^ self
	].

	(aChange isClassDefinitionChange) ifTrue:[
	    "This change is not added to the working class"
	    "changes to instance variables, classVariableNames, poolDictionaries, category"

	    classNameOfChange := aChange className asSymbol.
	    changeClass := aChange changeClass.
	    packageName := changeClass package.

	    self packagesDo:[:aPackage |
		(Switch new)
		    if:[(aPackage name == packageName)] then:[
			(aPackage includesPackagedClassNamed:classNameOfChange) ifTrue:[
			     aPackage removedClassNamed:classNameOfChange.
			].
			aPackage addedClass:changeClass];
		    if:[(aPackage isDependentOnClassNamed:classNameOfChange)] then:[
			aPackage classDefinitionChange:aChange];
		    value.

	    ].
	    ^ self

	].
	(aChange isClassInstVarDefinitionChange)  ifTrue:[
	    "This change is not added to the working class"
	    "changes to instance variables, classVariableNames, poolDictionaries, category"

	    classNameOfChange := aChange className.
	    changeClass := aChange changeClass.
	    packageName := changeClass package.

	    self packagesDo:[:aPackage |
		(Switch new)
		    if:[(aPackage name == packageName) ] then:[
			aPackage addedClass:changeClass];
		    if:[(aPackage isDependentOnClassNamed:classNameOfChange) ] then:[
			aPackage classInstVarDefinitionChange:aChange].
	    ].
	    ^ self
	].
	(aChange isClassRenameChange) ifTrue:[
	    "This change is not added to the working class"
	    classNameOfChange := aChange className.
	    changeClass := aChange changeClass.
	    packageName := changeClass package.

	    self packagesDo:[:aPackage |
		(Switch new)
		    if:[(aPackage name == packageName) ] then:[
			aPackage addedClass:changeClass];
		    if:[(aPackage isDependentOnClassNamed:classNameOfChange) ] then:[
			aPackage classRenameChange:aChange];
		    value.
	    ].
	    ^ self
	].

	self breakPoint:''.
    ].
    self breakPoint:''.
!

classPackageChange:classToOverride oldPackageName:oldPackageName
    "reacts to a class package change
    Assertion:
	aClass package ~= oldPackageName
    "

    self setClass:classToOverride toPackage:(self packageNamed:oldPackageName).
    self error:'Sorry, this function is no longer available other than within the packageBrowser. ', Character cr asString,
	Character cr asString, ' This action has done nothing!!'.

"/    | newPackageName newOwnerPackage|
"/    newPackageName := classToOverride package.
"/    newOwnerPackage := self packageNamed:newPackageName ifAbsent:[self newPackageNamed:newPackageName].
"/
"/    "fake this... maybe this is a kludge..."
"/    self setClass:classToOverride toPackage:(self packageNamed:oldPackageName).
"/
"/    self addClass:classToOverride toPackage:newOwnerPackage.
!

methodPackageChange:aMethod class:methodOwnedClass oldPackageName:oldPackageName

    self setMethod:aMethod toPackage:(self packageNamed:oldPackageName).
    Transcript nextPutAll:'Sorry, this function is no longer available other than within the packageBrowser. ', Character cr asString,
	Character cr asString, ' This action has done nothing!! >>methodPackageChange:aMethod class:methodOwnedClass oldPackageName:oldPackageName'.


"/    | newPackageName oldOwnerPackage newOwnerPackage|
"/
"/    newPackageName := aMethod package.
"/    oldOwnerPackage :=(self packageNamed:oldPackageName).
"/    newOwnerPackage := (self packageNamed:newPackageName).
"/
"/    newOwnerPackage ifNil:[
"/        PackageError raiseErrorString:'The package ', newPackageName, ' is not known',
"/            ' to this packageManager', ' and so cannot realise this methodPackageChange'
"/
"/    ].
"/
"/    oldOwnerPackage ifNil:[
"/        PackageError raiseErrorString:'The package ', oldPackageName, ' is not known',
"/            ' to this packageManager', ' and so cannot realise this methodPackageChange'
"/    ].
"/
"/    oldOwnerPackage movedMethod:aMethod toPackage:newOwnerPackage
!

packageChanged:something with:aParameter from:changedObject
   "maybe send a change notification for views here???"
"/    self halt.
    self addChange:aParameter.
    self changed:#packagedChanged with:changedObject
!

update:something with:aParameter from:changedObject

    (self includesPackage:changedObject) ifTrue:[
	self packageChanged:something with:aParameter from:changedObject.
	^ self.
    ].
    (changedObject == ChangeSet current) ifTrue:[
	self changeSetChanged:something with:aParameter from:changedObject.
	^ self.
    ].
! !

!PackageManager methodsFor:'checks'!

canLoadPackage:aPackage
    ""
    (self includesPackage:aPackage) ifTrue:[
	Notification raise.
    ].
! !

!PackageManager methodsFor:'enumarating'!

packagesDo:aOneArgBlock
    "should this or should this not include the defaultPackage??? should it
    be treated seperately?"
    aOneArgBlock value:defaultPackage.
    super packagesDo:aOneArgBlock.
!

packagesSelect:aOneArgBlock
    "should this or should this not include the defaultPackage??? should it
    be treated seperately?"
    | selectedPackages |
    selectedPackages := (self packages select:aOneArgBlock).

    (aOneArgBlock value:defaultPackage) ifTrue:[
	selectedPackages add:defaultPackage.
    ].
    ^ selectedPackages
! !

!PackageManager methodsFor:'errors'!

recoveryHandlerDo:aBlock forException:packageErrorClass
    "an atomic action is about to happen. This should succeed or
    fail and return to the previous state."

    "to do - this could be done by an extra class.
    could save the state of the receiver before this action is done
    along with a 'transaction number' held in the receivers class to make
    sure we are consistant. The hard copy could then be the backup. This
    all depends on how long it takes to make the backup and how often
    we are going to do this.
    "
    packageErrorClass handle:[:ex |
	Transcript show:ex errorString.
    ] do:[
	aBlock value
    ]
! !

!PackageManager methodsFor:'factory'!

classPackageChangeClass
    ^ Smalltalk classNamed:#'Packages::ChangeFaker::ClassPackageChange'
!

getPackageSaverForPackage:aPackage
    ^ StxPackageFileWriter forPackage:aPackage
!

methodPackageChangeClass
    ^ Smalltalk classNamed:#'Packages::ChangeFaker::MethodPackageChange'
!

newPackageNamed:aString
    | newPackage |

    (self includesPackageNamed:aString) ifTrue:[
	PackageError raiseCannotAddAsPackageManagerAlreadyIncludesPackageNamed:aString
    ].

    newPackage := self packageClass named:aString addToManager:self.
    newPackage initializeInstalled.
    ^ newPackage
!

packageClass
    ^ Package
! !

!PackageManager methodsFor:'initialization'!

initialize
    defaultPackage := self class defaultPackage.
    workingPackage := defaultPackage.
    super initialize.
!

uninitialize

    self packagesDo:[:aPackage |
	self removeDependent:aPackage.
    ].
    defaultPackage removeDependent:self.

    packages := nil.
    super uninitialize.
! !

!PackageManager methodsFor:'private-opening'!

getPackageHandlerForPackage:aPackage

    | aPackageHandler |

    (aPackageHandler := aPackage packageHandler) ifNil:[
	aPackageHandler := PackageHandler forPackage:aPackage.
    ].

    ^ aPackageHandler
!

getPackageReaderForFile:aFilename
    ^ StxPackageFileReader forFilename:aFilename
! !

!PackageManager methodsFor:'queries'!

includesPackage:anObject
    ^ ((packages includes:anObject)or:[defaultPackage == anObject])
!

isBasePackage:aPackage

    ^ self class basePackageNames includes:aPackage name.
! !

!PackageManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/PackageManager.st,v 1.9 2006/08/24 08:38:42 cg Exp $'
! !

PackageManager initialize!