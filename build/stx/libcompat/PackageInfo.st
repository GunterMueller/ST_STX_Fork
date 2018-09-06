"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PackageInfo
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!PackageInfo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    This is a dummy, mimicry class to allow some squeak code to be filed in.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.
    ALSO: be aware, that this PackageInfo class does not know much about how ST/X
    organizes its extensions. So NEVER EVER think about using it to get pacakgeInfo
    on ST/X packages. It is only present to support porting Squeak tools, which
    read Squeak packages (i.e. code importer packages).
    One such being the monticello framework.
"
! !

!PackageInfo class methodsFor:'initialization'!

initialize
    "/ cg: the allSbclassesDo may be expensive;
    "/ I think subclasses should do it themself
    "/     self allSubclassesDo: [:ea | ea new register]
! !

!PackageInfo class methodsFor:'compatibility'!

default
	^ self allPackages detect: [:ea | ea class = self] ifNone: [self new register]
! !

!PackageInfo class methodsFor:'packages access'!

allPackages
	^PackageOrganizer default packages
!

named: aString
	^ PackageOrganizer default packageNamed: aString ifAbsent: [(self new packageName: aString) register]
!

registerPackageName: aString
	^ PackageOrganizer default registerPackageNamed: aString
! !

!PackageInfo class methodsFor:'testing'!

existPackageNamed: aString
	"
	self existPackageNamed: 'PackageInfo'
	self existPackageNamed: 'Zork'
	"
	^ (self allPackages anySatisfy: [:each | each packageName = aString])
			
! !

!PackageInfo methodsFor:'accessing'!

name:something
    name := something.
! !

!PackageInfo methodsFor:'comparing'!

= other
	^ other species = self species and: [other packageName = self packageName]
!

hash
        ^ name hash

    "Modified: / 12-09-2010 / 16:26:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackageInfo methodsFor:'dependencies'!

externalCallers
    ^ self 
        externalRefsSelect:[:literal | literal isSymbol ]
        thenCollect:[:l | l ].
!

externalClasses
        | myClasses |
        myClasses := self classesAndMetaClasses asSet.
        ^ Array streamContents:
                [:s |
                Object withAllSubclassesDo:
                        [:class |
                        (class programmingLanguage isSmalltalk not or:[myClasses includes: class]) ifFalse: [s nextPut: class]]]

    "Modified: / 26-10-2010 / 23:46:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

externalRefsSelect: selBlock thenCollect: colBlock
	| pkgMethods dependents refs extMethods otherClasses otherMethods classNames |

	classNames := self classes collect: [:c | c name].
	extMethods := self extensionMethods collect: [:mr | mr methodSymbol].
	otherClasses := self externalClasses difference: self externalSubclasses.
	otherMethods :=  otherClasses gather: [:c | c selectors].
	pkgMethods := self methods asSet collect: [:mr | mr methodSymbol].
	pkgMethods removeAllFoundIn: otherMethods.

	dependents := Set new.
	otherClasses do: [:c |
		c selectorsAndMethodsDo:
			[:sel :compiled |
			(extMethods includes: sel) ifFalse: 
				[refs := compiled literals select: selBlock thenCollect: colBlock.
				refs do: [:ea |
					((classNames includes: ea) or: [pkgMethods includes: ea])
							ifTrue: [dependents add: (self referenceForMethod: sel ofClass: c) -> ea]]]]].
	^ dependents
!

externalSubclasses
	| pkgClasses subClasses |
	pkgClasses := self classes.
	subClasses := Set new.
	pkgClasses do: [:c | subClasses addAll: (c allSubclasses)].
	^ subClasses difference: pkgClasses
!

externalUsers
	^ self 
		externalRefsSelect: [:literal | literal isVariableBinding] 
		thenCollect: [:l | l key]
! !

!PackageInfo methodsFor:'listing'!

classes

    ^(Smalltalk allClasses select:[:cls|(cls category ? '') startsWith: name])
	asArray

    "Created: / 12-09-2010 / 17:40:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classesAndMetaClasses
	| baseClasses |
	baseClasses := self classes.
	^baseClasses , (baseClasses collect: [:c | c classSide])
!

coreMethods
	^ self classesAndMetaClasses gather: [:class | self coreMethodsForClass: class]
!

extensionClasses
	^ self externalBehaviors reject: [:classOrTrait | (self extensionCategoriesForClass: classOrTrait) isEmpty]
!

extensionMethods
    
    ^ self externalBehaviors gather: [:classOrTrait | self extensionMethodsForClass: classOrTrait]

    "Modified: / 18-08-2009 / 10:36:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-09-2010 / 18:57:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foreignClasses
	| s |
	s := IdentitySet new.
	self foreignSystemCategories
		do: [:c | (SystemOrganization listAtCategoryNamed: c)
				do: [:cl | 
					| cls | 
					cls := Smalltalk at: cl. 
					s add: cls;
					  add: cls class]].
	^ s
!

foreignSystemCategories
	^ SystemOrganization categories
		reject: [:cat | self includesSystemCategory: cat] 
!

methods
    ^ (self extensionMethods, self coreMethods) select: [:method |
        (method isValid
            and: [method isLocalSelector])
            and: [method methodSymbol isDoIt not]]
!

overrideMethods
	^ self extensionMethods select: [:ea | self isOvverideMethod: ea]
!

selectors
	^ self methods collect: [:ea | ea methodSymbol]
!

systemCategories
    |cats|

    cats := Set new.
    Smalltalk allClasses do: [:cls | 
        |cat|

        ((cat := cls category ? '') startsWith: name) ifTrue:[
            cats add:cat
        ].
    ].
    ^ cats

    "Modified: / 12-09-2010 / 16:35:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-09-2011 / 08:26:20 / cg"
! !

!PackageInfo methodsFor:'modifying'!

addCoreMethod: aMethodReference
	| category |
	category := self baseCategoryOfMethod: aMethodReference.
	aMethodReference actualClass organization
		classify: aMethodReference methodSymbol
		under: category
		suppressIfDefault: false
!

addExtensionMethod: aMethodReference
	| category |
	category := self baseCategoryOfMethod: aMethodReference.
	aMethodReference actualClass organization
		classify: aMethodReference methodSymbol
		under: self methodCategoryPrefix, '-', category
!

addMethod: aMethodReference
	(self includesClass: aMethodReference class)
		ifTrue: [self addCoreMethod: aMethodReference]
		ifFalse: [self addExtensionMethod: aMethodReference]
!

baseCategoryOfMethod: aMethodReference
	| oldCat oldPrefix tokens | 
	oldCat := aMethodReference category.
	({ 'as yet unclassified'. 'all' } includes: oldCat) ifTrue: [ oldCat := '' ].
	tokens := oldCat findTokens: '*-' keep: '*'.

	"Strip off any old prefixes"
	((tokens at: 1 ifAbsent: [ '' ]) = '*') ifTrue: [
		[ ((tokens at: 1 ifAbsent: [ '' ]) = '*') ]
			whileTrue: [ tokens removeFirst ].
		oldPrefix := tokens removeFirst asLowercase.
		[ (tokens at: 1 ifAbsent: [ '' ]) asLowercase = oldPrefix ]
			whileTrue: [ tokens removeFirst ].
	].

	tokens isEmpty ifTrue: [^ 'as yet unclassified'].
	^ String streamContents:
		[ :s |
		tokens
			do: [ :tok | s nextPutAll: tok ]
			separatedBy: [ s nextPut: $- ]]
!

externalBehaviors
	^self externalClasses , self externalTraits
!

externalTraits
	| behaviors |
	
	^ Array streamContents: [:s |
		behaviors := self classesAndMetaClasses.
		Smalltalk allTraits do: [:trait |
			(behaviors includes: trait) ifFalse: [s nextPut: trait].
			(behaviors includes: trait classSide) ifFalse: [s nextPut: trait classSide]]].			
!

removeMethod: aMethodReference
! !

!PackageInfo methodsFor:'naming'!

categoryName
	|category|
	category := self class category.
	^ (category endsWith: '-Info')
		ifTrue: [category copyUpToLast: $-]
		ifFalse: [category]
!

externalName
	^ self packageName
!

methodCategoryPrefix
	"
	^ methodCategoryPrefix ifNil: [methodCategoryPrefix := '*', self packageName asLowercase]
	 "
	^ '*', self packageName asLowercase
!

packageName
	"
	^ packageName ifNil: [packageName := self categoryName]
	"
	^self categoryName
!

packageName: aString

    name := aString

    "Modified: / 11-09-2010 / 13:25:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

systemCategoryPrefix
	^ self packageName
! !

!PackageInfo methodsFor:'registering'!

register
	PackageOrganizer default registerPackage: self
! !

!PackageInfo methodsFor:'testing'!

category: categoryName matches: prefix
	^ categoryName notNil and: [categoryName = prefix or: [categoryName beginsWith: prefix, '-']]
!

coreCategoriesForClass: aClass
        ^ aClass organization categories reject: [:cat | (self isForeignClassExtension: cat) ]
!

coreMethodsForClass:aClass
    "/ sorry: that's the kind of code which is hard to understand...
"/    ^ ((aClass selectors difference: (aClass isMetaclass ifTrue:[#(#version_MC)] ifFalse:[#()]))
"/        difference:((self foreignExtensionMethodsForClass:aClass) 
"/                collect:[:r | r methodSymbol ])) 
"/            asArray collect:[:sel | self referenceForMethod:sel ofClass:aClass ]

    |selectors|

    selectors := aClass selectors.

    "/ without version methods (which is not true !!)
    false ifTrue:[
        aClass isMetaclass ifTrue:[
            selectors remove:(MCSourceCodeManager nameOfVersionMethod).
            selectors remove:(MCSourceCodeManager nameOfVersionMethodForExtensions).
        ].
    ].
    "/ without foreigh extensions
    selectors removeAll:((self foreignExtensionMethodsForClass:aClass) collect:[:r | r methodSymbol ]).
    "/ return methodRefs, not selectors
    ^ (selectors collect:[:sel | self referenceForMethod:sel ofClass:aClass ]) asArray.

    "Modified: / 14-09-2010 / 15:59:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2011 / 10:24:24 / cg"
    "Modified (comment): / 12-06-2017 / 20:59:46 / cg"
!

extensionCategoriesForClass: aClass
	^ aClass organization categories select: [:cat | self isYourClassExtension: cat]
!

extensionMethodsForClass:aClass
    | methods prefix |

    prefix := '*' , name asLowercase.
    methods := OrderedCollection new.
    "/ sigh: in squeak/pharo, extension methods are marked by their category
    "/ in ST/X, there is a separate packageID.
    "/ Q: how to map packageInfo names to packageIDs ???
    
    aClass instAndClassMethodsDo: "methodsDo:"[:mthd|
        (self methodIsInPackage:mthd)
            ifTrue:[methods add: mthd]
    ].

    ^methods collect:
                [:mthd|
                self
                    referenceForMethod: mthd selector
                    ofClass:aClass]

    "Modified: / 18-08-2009 / 10:36:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-09-2010 / 19:02:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionMethodsFromClasses: classes
	^classes
		gather: [:class | self extensionMethodsForClass: class]
!

foreignExtensionCategoriesForClass: aClass
	^ aClass organization categories select: [:cat | self isForeignClassExtension: cat]
!

foreignExtensionMethodsForClass: aClass
	^ (self foreignExtensionCategoriesForClass: aClass)
		gather: [:cat | (aClass organization listAtCategoryNamed: cat)
						  collect: [:sel | self referenceForMethod: sel ofClass: aClass]]
!

includesClass: aClass
        ^ self includesSystemCategory: aClass theNonMetaclass category
!

includesClassNamed: aClassName
	^ self includesSystemCategory: ((SystemOrganization categoryOfElement: aClassName) ifNil: [^false])
!

includesMethod: aSymbol ofClass: aClass
	aClass ifNil: [^ false].
	^ self
		includesMethodCategory: ((aClass organization categoryOfElement: aSymbol)
										ifNil: [' '])
		ofClass: aClass
!

includesMethodCategory: categoryName ofClass: aClass
	^ (self isYourClassExtension: categoryName)
		or: [(self includesClass: aClass)
				and: [(self isForeignClassExtension: categoryName) not]]
!

includesMethodCategory: categoryName ofClassNamed: aClass
	^ (self isYourClassExtension: categoryName)
		or: [(self includesClassNamed: aClass)
				and: [(self isForeignClassExtension: categoryName) not]]
!

includesMethodReference: aMethodRef
	^ self includesMethod: aMethodRef methodSymbol ofClass: aMethodRef actualClass
!

includesSystemCategory: categoryName
	^ self category: categoryName matches: self systemCategoryPrefix
!

isForeignClassExtension: categoryName
	^ categoryName first = $* and: [(self isYourClassExtension: categoryName) not]
!

isOverrideMethod: aMethodReference
	^ aMethodReference category endsWith: '-override'
!

isYourClassExtension: categoryName
	^ categoryName notNil and: [self category: categoryName asLowercase matches: self methodCategoryPrefix]
!

methodIsInPackage:aMethod
    | prefix |

    prefix := '*' , name asLowercase.
    "/ sigh: in squeak/pharo, extension methods are marked by their category
    "/ in ST/X, there is a separate packageID.
    "/ Q: how to map packageInfo names to packageIDs ???
    
    (aMethod category asLowercase startsWith: prefix) ifTrue:[^ true].
    Smalltalk isSmalltalkX ifTrue:[
        aMethod package = name asLowercase ifTrue:[^ true].
    ].
    ^ false.
!

outsideClasses
	^ProtoObject withAllSubclasses difference: self classesAndMetaClasses
!

referenceForMethod: aSymbol ofClass: aClass
	^ MethodReference new setStandardClass: aClass methodSymbol: aSymbol
! !

!PackageInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/PackageInfo.st,v 1.20 2018-03-07 19:58:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/PackageInfo.st,v 1.20 2018-03-07 19:58:59 cg Exp $'
!

version_SVN
    ^ '$Id: PackageInfo.st,v 1.20 2018-03-07 19:58:59 cg Exp $'
! !


PackageInfo initialize!
