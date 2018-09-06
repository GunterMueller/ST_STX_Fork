"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ClassList subclass:#HierarchicalClassList
	instanceVariableNames:'topClassHolder'
	classVariableNames:'InheritedEntry'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!HierarchicalClassList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    Like a ClassList, but shows classes hierarchical.

    If topClassHolders value is non-nil, only that classes hierarchy
    is shown.

    embeddable application displaying the classes as listed by
    the inputGenerator.
    Provides an outputGenerator, which enumerates the classes and
    their protocols (method-categories) in the selected classes.

    [author:]
	Claus Gittinger (cg@exept.de)
"


! !

!HierarchicalClassList class methodsFor:'initialization'!

initialize
    InheritedEntry := '* inheritance *'

    "Created: / 24.2.2000 / 20:19:19 / cg"
! !

!HierarchicalClassList class methodsFor:'queries-plugin'!

aspectSelectors
    ^ super aspectSelectors ,
       #(
          topClassHolder
        )

    "Modified: / 24-02-2014 / 10:38:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HierarchicalClassList methodsFor:'accessing'!

showMethodComplexity:aValueHolder

    "Created: / 05-11-2007 / 17:15:35 / cg"
!

showMethodInheritance:aValueHolder

    "Created: / 05-11-2007 / 17:15:23 / cg"
!

showMethodTypeIcon:aValueHolder

    "Created: / 05-11-2007 / 17:15:42 / cg"
! !

!HierarchicalClassList methodsFor:'aspects'!

methodVisibilityHolder:aValueHolder

    "Created: / 05-11-2007 / 17:15:48 / cg"
!

topClassHolder
    topClassHolder isNil ifTrue:[
        topClassHolder := Object asValue.
        topClassHolder addDependent:self
    ].
    ^ topClassHolder
!

topClassHolder:aValueHolder
    |oldTopClass newTopClass|

    oldTopClass := topClassHolder value.

    topClassHolder notNil ifTrue:[
        topClassHolder removeDependent:self
    ].
    topClassHolder := aValueHolder.

    topClassHolder notNil ifTrue:[
        topClassHolder isBehavior ifTrue:[self halt:'should not happen'].
        topClassHolder addDependent:self.
    ].

    newTopClass := topClassHolder value.
    newTopClass ~~ oldTopClass ifTrue:[
        self enqueueDelayedUpdateList.
    ].
! !

!HierarchicalClassList methodsFor:'change & update'!

classDefinitionChanged:aClass
    |prevTop prevSelection newSelection selectedClassesHolder|

    listValid ifFalse:[^ self].
    slaveMode value == true ifTrue:[
	self invalidateList.
	^ self.
    ].

    selectedClassesHolder := self selectedClasses.
    prevSelection := selectedClassesHolder value copy.

    prevTop := self topClassHolder value.
    prevTop notNil ifTrue:[
	(prevTop name = aClass name) ifTrue:[
	    "/ forced update
	    topClassHolder value:aClass.
	] ifFalse:[
	    (prevTop name = aClass class name) ifTrue:[
		"/ forced update
		topClassHolder value:aClass class.
	    ]   
	]
    ].

    "/ must update the list (notice, that the hierarchy might have changed..)

    self updateList.

    selectedClassesHolder value ~= prevSelection ifTrue:[
	newSelection := prevSelection collect:[:eachOldClass | environment classNamed:(eachOldClass name)].
	selectedClassesHolder value:newSelection.
    ]

    "Modified: / 26.2.2000 / 01:17:01 / cg"
!

classRemoved:aClass
    |prevTop newTop prevSel nPrevSelected selectedClassesHolder newSelection wasMeta|

    prevTop := self topClassHolder value.

    prevTop notNil ifTrue:[
	wasMeta := prevTop isMeta.
	newTop := prevTop theNonMetaclass.
	[newTop notNil and:[(environment at:newTop name) ~= newTop]] whileTrue:[
	    newTop := newTop superclass.
	].
	wasMeta ifTrue:[
	    newTop := newTop theMetaclass
	].
	newTop ~~ prevTop ifTrue:[
	    self topClassHolder value:newTop.
	].
    ].

    selectedClassesHolder := self selectedClasses.

    "/ if there is a single selection,
    "/ which is the old top, replace it.
    prevSel := selectedClassesHolder value.
    nPrevSelected := prevSel size.
    nPrevSelected > 0 ifTrue:[
	nPrevSelected == 1 ifTrue:[
	    prevSel first == aClass ifTrue:[
		newTop notNil ifTrue:[
		    newSelection := Array with:newTop.
		] ifFalse:[
		    newSelection := #().
		]
	    ].
	] ifFalse:[
	    nPrevSelected ~~ 0 ifTrue:[
		"/ clear the selection
		newSelection := #().
	    ]
	].
	newSelection notNil ifTrue:[
	    selectedClassesHolder value:newSelection
	].
    ].

    super classRemoved:aClass.
! !

!HierarchicalClassList methodsFor:'private'!

addTo:aList whereSuperclassIs:aSuperclass
    |theClasses|

    aSuperclass isNil ifTrue:[
	theClasses := environment allClasses select:[:cls | cls superclass isNil]
    ] ifFalse:[
	theClasses := aSuperclass subclasses.
    ].
    (self hideUnloadedClasses value) ifTrue:[
	theClasses := theClasses select:[:cls | cls isLoaded].
    ].

    theClasses := theClasses asOrderedCollection sort:[:a :b | (a name ? '??') < (b name ? '??')].
    theClasses do:[:aClass |
	aList add:aClass.
	self addTo:aList whereSuperclassIs:aClass
    ].        
!

defaultSlaveModeValue
    |mode|

    mode := self topApplication perform:#initialOrganizerMode ifNotUnderstood:nil.
    mode == OrganizerCanvas organizerModeClassHierarchy ifTrue:[^ false].
    mode isNil ifTrue:[^ false].

    self organizerMode value == OrganizerCanvas organizerModeCategory ifTrue:[^ true].
    ^ false
!

listOfClasses
    |classes top|

    classes := OrderedCollection new.
    (top := self topClassHolder value) notNil ifTrue:[
        top := top theNonMetaclass.
        classes addAll:(top withAllSuperclasses reversed).

        "/ Must check whether environment contains the class and filter it out,
        "/ if not. Think of limited environment to Java classes which should not
        "/ show Object & JavaObject even if they are real superclasses of any Java
        "/ class.
        "/ Q: Should we rather ignore all superclasses after first class which is not
        "/ in environment?
        classes := classes select:[:class | (environment at: class name ifAbsent:[nil]) notNil ].
    ].
    self addTo:classes whereSuperclassIs:top.
    ^ classes

    "Modified: / 24-02-2000 / 13:27:43 / cg"
    "Modified (format): / 27-04-2014 / 20:47:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameListEntryFor:aClass withNameSpace:useFullName
    |indent superClass nm|

    aClass == (self class nameListEntryForALL) ifTrue:[ ^ aClass ].
    aClass == InheritedEntry ifTrue:[ ^ aClass ].

    nm := aClass nameInBrowser.
    nm isNil ifTrue:[^ '???'].

    aClass isLoaded ifFalse:[
        "/ nm := nm,(' (?) ' colorizeAllWith:Color grey).
    ] ifTrue:[
        aClass isAbstract ifTrue:[ nm := nm allItalic ].
        nm := nm,((' (%1+%2) ' bindWith:(aClass methodsCount) with:(aClass class methodsCount)) 
                                withColor:self class pseudoEntryForegroundColor).
    ].

    indent := 0.
    superClass := aClass superclass.
    [superClass notNil] whileTrue:[
        indent := indent + 1.
        superClass := superClass superclass.
    ].

    indent == 0 ifTrue:[
        ^ nm
    ].

    indent <= 5 ifTrue:[
        indent := #(
                     ''
                     '    '
                     '        '
                     '            '
                     '                '
                     '                    '
                   ) at:indent+1.
    ] ifFalse:[
        indent := String new:indent*4 withAll:Character space.
    ].
    ^ indent , nm

    "Modified: / 24.2.2000 / 20:19:47 / cg"
!

release
    super release.

    topClassHolder removeDependent:self.
! !

!HierarchicalClassList class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


HierarchicalClassList initialize!
