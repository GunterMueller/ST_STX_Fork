"
 COPYRIGHT (c) 1996-2011 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2011 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SystemEnvironment
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes'
!

!SystemEnvironment class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2011 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2011 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
!

documentation
"
    SystemEnvironment is an abstract base class for 'environments'
    An 'environment' is an object that keeps track of classes and
    methods and can be asked for those.

    Its protocol is polymorph with protocol of Smalltalk and NameSpace
    classes. I.e., wherever s code uses Smalltalk or NameSpace subclass to
    get list of classes and/or methods ic can be interchanged with an 
    custom instance SystemEnvironment.

    To open a browser on given environment do

    Tools::NewSystemBrowser new
        allButOpen;
        environment: customEnvironment;
        open.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        Smalltalk
        NameSpace

"
! !

!SystemEnvironment class methodsFor:'queries'!

isAbstract
    ^ self == SystemEnvironment

    "Modified: / 13-05-2014 / 10:36:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SystemEnvironment methodsFor:'accessing'!

at: key 
    ^ self at: key ifAbsent:[nil]

    "Created: / 03-09-2013 / 17:02:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at:aString ifAbsent:aBlock
    self allClassesDo:[:cls|
        cls name = aString ifTrue:[ ^ cls ].
    ].
    ^ aBlock value

    "Created: / 03-09-2013 / 17:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2013 / 12:53:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at: key put: value
    ^ self shouldNotImplement

    "Created: / 03-09-2013 / 17:02:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2013 / 12:20:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keys
    ^ Iterator on:[ :whatToDo | self allClassesDo: [:cls | whatToDo value: cls name  ] ]

    "Created: / 22-04-2014 / 12:22:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SystemEnvironment methodsFor:'enumerating'!

allBehaviorsDo:aBlock
    "evaluate the argument, aBlock for all classes and metaclasses in the system"

    self allClassesAndMetaclassesDo:aBlock

    "
     Smalltalk allBehaviorsDo:[:aClass | aClass name printCR]
    "
!

allClassCategories
    "return a set of all class categories in the system"

    |allCategories|

    allCategories := Set new.
    self allClassesDo:[:cls |
        |category|

        category := cls category.
        category notNil ifTrue:[
            allCategories add:category.
        ].
    ].

    ^ allCategories.

    "
     Smalltalk allClassCategories
    "

    "Created: / 17-11-2001 / 12:13:09 / cg"
    "Modified: / 13-05-2014 / 10:33:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allClassesAndMetaclassesDo:aBlock
    "evaluate the argument, aBlock for all classes and metaclasses in the system."

    |already|

    already := IdentitySet new:NumberOfClassesHint*2.
    self allClassesDo:[:eachClass |
	|cls|

	cls := eachClass theNonMetaclass.
	(already includes:cls) ifFalse:[
	    aBlock value:cls.
	    already add:cls.
	].
	cls := cls class.
	(already includes:cls) ifFalse:[
	    aBlock value:cls.
	    already add:cls.
	].
    ].
!

allClassesDo:aBlock
    "evaluate the argument, aBlock for all classes in the system."

    self subclassResponsibility

    "
     Smalltalk allClassesDo:[:aClass | aClass name printCR]
    "

    "Modified: / 04-09-2013 / 12:19:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allClassesForWhich:filter
    "return a collection with all classes in the system,
     for which filter evaluates to true."

    |collectedClasses|

    collectedClasses := OrderedCollection new.
    self allClassesForWhich:filter do:[:cls |
	collectedClasses add:cls
    ].
    ^ collectedClasses

    "
     Smalltalk
	allClassesForWhich:[:cls | cls name startsWith:'Po']
    "

    "Created: / 10-08-2006 / 12:11:31 / cg"
!

allClassesForWhich:filter do:aBlock
    "evaluate the argument, aBlock for all classes in the system, for which filter evaluates to true."

    self allClassesDo:[:cls |
	(filter value:cls) ifTrue:[ aBlock value:cls ].
    ].

    "
     Smalltalk
	allClassesForWhich:[:cls | cls name startsWith:'Po']
	do:[:aClass | Transcript showCR:aClass name]
    "
!

allClassesInCategory:aCategory
    "return a collection of for all classes in aCategory;
     The order of the classes is not defined."

    ^ self allClassesForWhich:[:cls | cls category = aCategory]

    "
     Smalltalk allClassesInCategory:'Views-Basic'
    "

    "Modified: / 10-08-2006 / 12:13:32 / cg"
!

allClassesInCategory:aCategory do:aBlock
    "evaluate the argument, aBlock for all classes in the aCategory;
     The order of the classes is not defined."

    aCategory notNil ifTrue:[
	self allClassesForWhich:[:cls | cls category = aCategory] do:aBlock
    ]

    "
     Smalltalk allClassesInCategory:'Views-Basic' do:[:aClass | Transcript showCR:aClass]
    "

    "Modified: / 09-08-2006 / 17:18:50 / fm"
!

allClassesInCategory:aCategory inOrderDo:aBlock
    "evaluate the argument, aBlock for all classes in aCategory;
     superclasses come first - then subclasses"

    |classes|

    aCategory notNil ifTrue:[
	classes := OrderedCollection new.
	self allClassesInCategory:aCategory do:[:aClass |
	    classes add:aClass
	].
	classes topologicalSort:[:a :b | b isSubclassOf:a].
	classes do:aBlock
    ]

    "
     Smalltalk allClassesInCategory:'Views-Basic' inOrderDo:[:aClass | aClass name printCR]
    "

    "Modified: / 17.11.2001 / 12:18:15 / cg"
!

allClassesInOrderDo:aBlock
    "evaluate the argument, aBlock for all classes in the system;
     Evaluation order is by inheritance: superclasses come first."

    |already|

    already := IdentitySet new:NumberOfClassesHint.
    self allClassesDo:[:eachClass |
	(already includes:eachClass) ifFalse:[
	    eachClass allSuperclasses reverseDo:[:eachSuperClass |
		(already includes:eachSuperClass) ifFalse:[
		    already add:eachSuperClass.
		    aBlock value:eachSuperClass.
		].
	    ].
	    already add:eachClass.
	    aBlock value:eachClass.
	]
    ].

    "
     Smalltalk allClassesInOrderDo:[:aClass | Transcript showCR:aClass name]
    "
!

allClassesInPackage:aPackageID
    "evaluate the argument, aBlock for all classes a package;
     The order of the classes is not defined.
     The returned collection may include private classes"

    ^ self allClassesForWhich:[:cls | cls package = aPackageID]

    "
     Smalltalk allClassesInPackage:'bosch:dapasx'
    "

    "Created: / 10-08-2006 / 12:14:10 / cg"
    "Modified: / 12-10-2006 / 23:48:43 / cg"
!

allClassesInPackage:aPackageID do:aBlock
    "evaluate the argument, aBlock for all classes a package;
     The order of the classes is not defined."

    ^ self allClassesForWhich:[:cls | cls package = aPackageID] do:aBlock

    "
     Smalltalk allClassesInPackage:'bosch:dapasx' do:[:aClass | Transcript showCR:aClass]
    "

    "Created: / 09-08-2006 / 17:14:17 / fm"
!

allKeysDo:aBlock
    <resource: #obsolete>
    "evaluate the argument, aBlock for all keys in the Smalltalk dictionary"

    self obsoleteMethodWarning:'please use #keysDo:'.
    self keysDo:aBlock

    "Modified: / 20-01-2017 / 17:52:47 / stefan"
!

allMethodCategories
    "return a set of all method-categories (protocols) in the system"

    |allCategories|

    allCategories := Set new.
    self allClassesDo:[:cls |
        allCategories addAll:cls categories.
    ].

    ^ allCategories.

    "
     Smalltalk allMethodCategories
    "

    "Modified: / 13-05-2014 / 10:34:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allMethodsDo:aBlock
    "enumerate all methods in all classes"

    self allClassesDo:[:eachClass |
        eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            aBlock value:mthd
        ]
    ].

    "Modified: / 13-05-2014 / 10:34:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allMethodsForWhich:aBlock
    "return a collection of methods for which aBlock returns true"

    |coll|

    coll := OrderedCollection new.
    self allClassesDo:[:eachClass |
        eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            (aBlock value:mthd) ifTrue:[
                coll add:mthd
            ].
        ]
    ].
    ^ coll

    "Modified: / 13-05-2014 / 10:35:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allMethodsWithSelectorDo:aTwoArgBlock
    "enumerate all methods in all classes and evaluate aBlock
     with method and selector as arguments."

    self allClassesDo:[:eachClass |
        eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            aTwoArgBlock value:mthd value:sel
        ]
    ].

    "Modified: / 13-05-2014 / 10:35:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

associationsDo:aBlock
    "evaluate the argument, aBlock for all key/value pairs
     in the Smalltalk dictionary"

    self keysDo:[:aKey |
	aBlock value:(aKey -> (self at:aKey))
    ]

    "Smalltalk associationsDo:[:assoc | assoc printCR]"
!

keysAndValuesDo: block
    self allClassesDo:[:cls|
        block value: cls name value: cls
    ].

    "Smalltalk associationsDo:[:assoc | assoc printCR]"

    "Created: / 03-09-2013 / 16:54:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2013 / 12:19:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keysAndValuesSelect:selectBlockWith2Args thenCollect:collectBlockWith2Args
    |collected|

    collected := OrderedCollection new.
    self keysAndValuesDo:[:eachKey :eachValue |
	(selectBlockWith2Args value:eachKey value:eachValue) ifTrue:[
	    collected add:(collectBlockWith2Args value:eachKey value:eachValue)
	].
    ].
    ^ collected

    "
     Smalltalk
	keysAndValuesSelect:[:nm :val | (nm startsWith:'Ab') and:[val notNil]]
	thenCollect:[:nm :val | nm]
    "
!

keysDo:aBlock
    "evaluate the argument, aBlock for all keys in the Smalltalk dictionary"

    ^self keysAndValuesDo:[:key :value|
        aBlock value: key
    ]

    "Created: / 03-09-2013 / 16:55:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SystemEnvironment methodsFor:'queries'!

allClasses
    "return an unordered collection of all classes in the system.
     Only globally anchored classes are returned
     (i.e. anonymous ones have to be acquired by Behavior allSubInstances)"

    |classes|

    classes := IdentitySet new:100.
    self allClassesDo:[:cls | classes add: cls ].
    ^ classes

    "
     CachedClasses := nil.
     Smalltalk allClasses

    to get the list sorted by name:

     Smalltalk allClasses asSortedCollection:[:a :b | a name < b name]
    "

    "Modified: / 06-12-2011 / 12:41:42 / cg"
    "Modified: / 04-09-2013 / 12:18:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allClassesAndMetaclasses
    "return an unordered collection of all classes with their metaclasses in the system."

    |classes|

    classes := IdentitySet new:100.
    self allClassesDo:[:eachClass |
        classes add:(eachClass theNonMetaclass).
        classes add:(eachClass theMetaclass).
    ].
    ^ classes

    "Modified: / 04-09-2013 / 12:18:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allNameSpaces
    "return a list of all namespaces"

    ^ self allNameSpacesIn:Smalltalk
!

allNameSpacesIn:anEnvironment
    "return a list of all namespaces"

    |set|

    set := IdentitySet with:anEnvironment.
    anEnvironment allClassesDo:[:aClass |
        (aClass isRealNameSpace 
        and:[aClass ~~ anEnvironment]) ifTrue:[
            set add:aClass
        ]
    ].
    ^ set

    "Modified: / 10-11-2006 / 17:12:02 / cg"
!

allNamespaces
    "return a list of all namespaces"

    <resource: #obsolete>

    ^ self allNameSpaces
!

allNamespacesIn:anEnvironment
    "return a list of all namespaces"

    <resource: #obsolete>

    ^ self allNameSpacesIn:anEnvironment
! !

!SystemEnvironment class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

