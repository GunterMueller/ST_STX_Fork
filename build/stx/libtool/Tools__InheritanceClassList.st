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

HierarchicalClassList subclass:#InheritanceClassList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!InheritanceClassList class methodsFor:'documentation'!

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
    Like a HierarchicalClassList, but shows class inheritance.
    For non-meta classes, this is the same as would be shown in
    the hierarchy list;
    For metaclasses, the tree is extented through the class-behavior
    hierarchy.

    embeddable application displaying the classes as listed by
    the inputGenerator.
    Provides an outputGenerator, which enumerates the classes and
    their protocols (method-categories) in the selected classes.

    [author:]
	Claus Gittinger (cg@exept.de)
"


! !

!InheritanceClassList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    |top oldSelection newSelection showMeta|

    self inSlaveModeOrInvisible ifTrue:[^ self].
"/    (self slaveMode value == true) ifTrue:[^ self].

    changedObject == slaveMode ifTrue:[
	listValid ~~ true ifTrue:[
	    self enqueueDelayedUpdateList
	].
	"/ self invalidateList.
	^  self
    ].

    changedObject == meta ifTrue:[
	oldSelection := self selectedClasses value ? #().
	showMeta := meta value.

	newSelection := oldSelection collect:[:cls | showMeta ifTrue:[cls theMetaclass] ifFalse:[cls theNonMetaclass]].
	newSelection := newSelection asOrderedCollection.

	top := self topClassHolder value.
	top notNil ifTrue:[
	    top := showMeta ifTrue:[top theMetaclass] ifFalse:[top theNonMetaclass].
	    self topClassHolder value:top.
	].
	self invalidateList.

(newSelection includes:nil) ifTrue:[self halt:'should not happen'].

	self selectedClasses value:newSelection.
	^ self.
    ].
    super delayedUpdate:something with:aParameter from:changedObject

    "Modified: / 24.2.2000 / 15:29:21 / cg"
!

getSelectedClassIndicesFromClasses
    |classes selectedClasses selectedIndices|

    selectedClasses := self selectedClasses value.
    selectedClasses size == 0 ifTrue:[^ #() ].

    classes := self classList value.
    selectedIndices := 
        selectedClasses 
            collect:[:aSelectedClass |
                classes identityIndexOf:aSelectedClass]
            thenSelect:[:idx | idx ~~ 0].
    selectedIndices size == 0 ifTrue:[
"/        meta value == true ifTrue:[
"/self halt.
"/        ] ifFalse:[
"/self halt.
"/        ]
    ].

    ^ selectedIndices

    "Created: / 24.2.2000 / 19:48:05 / cg"
    "Modified: / 24.2.2000 / 23:30:22 / cg"
!

getSelectedClassesFromIndices
    |selected classes allSelected|

    allSelected := false.

    classes := classList value.
    selected := self selectedClassNameIndices value collect:[:idx |
	|cls|

	cls := classes at:idx.
"/        cls == AllEntry ifTrue:[
"/            allSelected := true.
"/            cls.
"/        ] ifFalse:[
"/            cls notNil ifTrue:[
"/                meta value ifTrue:[
"/                    cls := cls theMetaclass
"/                ] ifFalse:[
"/                    cls := cls theNonMetaclass
"/                ].
"/            ].
"/            cls
"/        ]
    ].

"/    allSelected ifTrue:[
"/        selected := classList value select:[:cls | cls ~~ AllEntry].
"/    ].

    selected := selected select:[:cls | cls notNil].
    ^selected.

    "Created: / 24.2.2000 / 19:45:04 / cg"
! !

!InheritanceClassList methodsFor:'private'!

defaultSlaveModeValue
    |mode|

    mode := self topApplication perform:#initialOrganizerMode ifNotUnderstood:nil.
    mode == OrganizerCanvas organizerModeClassInheritance ifTrue:[^ false].
    mode isNil ifTrue:[^ false].

    self organizerMode value == OrganizerCanvas organizerModeCategory ifTrue:[^ true].
    ^ false
!

listOfClasses
    |top classes|

    (top := self topClassHolder value) isNil ifTrue:[
        ^ super listOfClasses
    ].

    classes := top withAllSuperclasses reversed.
    "/ Must check whether environment contains the class and filter it out,
    "/ if not. Think of limited environment to Java classes which should not
    "/ show Object & JavaObject even if they are real superclasses of any Java
    "/ class.
    "/ Q: Should we rather ignore all superclasses after first class which is not
    "/ in environment?
    classes := classes select:[:class | (environment at: class name ifAbsent:[nil]) notNil ].             
"/    classes addFirst:InheritedEntry.
    ^ classes

    "Modified: / 26-02-2000 / 00:38:48 / cg"
    "Modified: / 27-04-2014 / 20:48:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!InheritanceClassList class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

