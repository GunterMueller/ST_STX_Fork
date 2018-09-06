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

MethodList subclass:#ImplementingClassList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!ImplementingClassList class methodsFor:'documentation'!

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

!ImplementingClassList methodsFor:'private'!

listOfMethodNames
    |methods entries newNameList 
     allCategories classUses allSelectors generator 
     "theMethod"|

    generator := inGeneratorHolder value.
    generator isNil ifTrue:[^ #() ].

    classUses := Bag identityNew.
    allSelectors := IdentitySet new.
    allCategories := Set new.
    entries := OrderedCollection new.

    "/ generator generates nil-selector entries
    "/ to pass multiple-class and multiple-protocol info
    generator do:[:cls :cat :sel :mthd | 
			sel notNil ifTrue:[
			    entries add:(Array with:cls with:sel with:mthd).
			    classUses add:cls.
			    allSelectors add:sel.
			    allCategories add:mthd category.
			]
		 ].

    entries sort:[:a :b | |clsNmA clsNmB|
			   clsNmA := (a at:1) name.
			   clsNmB := (b at:1) name.
			   clsNmA < clsNmB
		 ].

    newNameList := entries collect:[:entry | 
					|class nm|

					class := (entry at:1).
					nm := class name.
					((allSelectors size > 1)
					or:[(classUses occurrencesOf:class) > 1]) ifTrue:[
					    nm := nm , ' ' , (entry at:2)
					].
					allCategories size > 1 ifTrue:[
					    nm := nm , ' {' , (entry at:3) category , '}'
					].
"/                                        class name , ' ' , (entry at:2)
					nm
				   ].
    methods := entries collect:[:entry | (entry at:3)].
    methodList := methods.
"/    methods size == 1 ifTrue:[
"/        theMethod := methods first.
"/        self methodLabelHolder value:(theMethod mclass name , ' ' , theMethod selector).
"/    ].
    ^ newNameList.

    "Created: / 5.2.2000 / 22:43:40 / cg"
    "Modified: / 1.3.2000 / 21:00:26 / cg"
! !

!ImplementingClassList class methodsFor:'documentation'!

version
    ^ '$Id: Tools__ImplementingClassList.st 8083 2013-01-14 11:48:37Z vranyj1 $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__ImplementingClassList.st 8083 2013-01-14 11:48:37Z vranyj1 $'
! !

