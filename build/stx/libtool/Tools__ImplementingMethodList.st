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

MethodList subclass:#ImplementingMethodList
	instanceVariableNames:'selectorList selectedSelectors'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!ImplementingMethodList class methodsFor:'documentation'!

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

!ImplementingMethodList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
	#classHolder
	#(#doubleClickChannel #action )
	#forceGeneratorTrigger
	#immediateUpdate
	#inGeneratorHolder
	#outGeneratorHolder
	#menuHolder
	#methodCategoryHolder
	#packageFilter
	#selectedMethods
	#selectionChangeCondition
	#updateTrigger
      ).



! !

!ImplementingMethodList methodsFor:'aspects'!

selectedSelectors
    selectedSelectors isNil ifTrue:[
	selectedSelectors := ValueHolder new.
	selectedSelectors addDependent:self
    ].
    ^ selectedSelectors.


! !

!ImplementingMethodList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    changedObject == selectedMethodNameIndices ifTrue:[
"/        self selectedMethods value:(self selectedMethodNameIndices value collect:[:idx | methodList at:idx]).
"/        lastSelectedMethods := self selectedMethods value.
        
	self selectedSelectors value:(self selectedMethodNameIndices value collect:[:idx | selectorList at:idx]).
	"/ lastSelectedSelectors := self selectedSelectors value.
	^ self 
    ].
    changedObject == selectedSelectors ifTrue:[
	self updateOutputGenerator.
	^ self
    ].
    super delayedUpdate:something with:aParameter from:changedObject

    "Created: / 5.2.2000 / 13:42:14 / cg"
    "Modified: / 6.2.2000 / 00:05:26 / cg"
!

selectedMethodsChanged
    self updateOutputGenerator
!

selectionChanged
    self halt:'should not happen'
! !

!ImplementingMethodList methodsFor:'generators'!

makeGenerator
    "return a generator which enumerates the methods from the selected protocol;
     that generator generates 4-element elements (includes the class and protocol), 
     in order to make the consumers only depend on one input 
     (i.e. to pass multiple-class and multiple-protocol info
      without a need for another classHolder/protocolHolder in the methodList)."

    ^ Iterator on:[:whatToDo |
			|selectors items packages|

			items := OrderedCollection new.

			selectors := self selectedSelectors value ? #().
			selectors size > 0 ifTrue:[
			    packages := packageFilter value value.
			    selectors do:[:eachSelector |
				classes do:[:eachClass | |mthd|
				    mthd := eachClass compiledMethodAt:eachSelector.
				    mthd notNil ifTrue:[
					(packages isNil
					or:[packages includes:mthd package]) ifTrue:[
					    items add:(Array with:eachClass with:mthd category with:eachSelector with:mthd)
					]
				    ]
				]
			    ]
			].
			items sort:[:a :b |
					|nm1 nm2 sel1 sel2|

					nm1 := (a at:1) name.
					nm2 := (b at:1) name.
					nm1 < nm2 ifTrue:[ true ]
					ifFalse:[
					    nm1 = nm2 ifFalse:[ false ]
					    ifTrue:[
						sel1 := a at:3.
						sel2 := b at:3.
						sel1 < sel2
					    ]
					]
				    ].
			items do:[:eachItem | whatToDo valueWithArguments:eachItem].
		  ]



! !

!ImplementingMethodList methodsFor:'private'!

listOfMethodNames
    |entries selectorsAlready newNameList 
     newClasses allCategories allSelectors generator 
     "showCategory"  categoryOrCountPerSelector|

    generator := inGeneratorHolder value.
    generator isNil ifTrue:[^ #() ].

    newClasses := IdentitySet new.
    selectorsAlready := IdentitySet new.
    entries := OrderedCollection new.
    allCategories := Set new.
    allSelectors := Bag identityNew.
    categoryOrCountPerSelector := IdentityDictionary new.

    "/ generator generates nil-selector entries
    "/ to pass multiple-class and multiple-protocol info
    generator do:[:cls :cat :sel :mthd | 
			|catsAlready|

			sel notNil ifTrue:[
			    (selectorsAlready includes:sel) ifFalse:[
				entries add:(Array with:cls with:sel with:mthd).
				selectorsAlready add:sel
			    ].
			    newClasses add:cls.
			    allCategories add:cat.    
			    allSelectors add:sel.

			    catsAlready := categoryOrCountPerSelector at:sel ifAbsent:nil.
			    catsAlready isNil ifTrue:[
				categoryOrCountPerSelector at:sel put:cat.
			    ] ifFalse:[
				catsAlready isInteger ifTrue:[
				    categoryOrCountPerSelector at:sel put:(catsAlready + 1).
				] ifFalse:[
				    catsAlready ~= cat ifTrue:[
					categoryOrCountPerSelector at:sel put:2.
				    ]
				]
			    ]
			]
		 ].

    entries sort:[:a :b | |nmA nmB clsNmA clsNmB|
			   nmA := (a at:2).
			   nmB := (b at:2).
			   nmA = nmB ifTrue:[
			       clsNmA := (a at:1) name.
			       clsNmB := (b at:1) name.
			       clsNmA < clsNmB
			   ] ifFalse:[
			       nmA < nmB
			   ]
		 ].

    newNameList := OrderedCollection new.
    selectorList := OrderedCollection new.

    "/ showCategory := allCategories size > 1.

    entries do:[:entry |
	|cls sel mthd s catOrCounts|

	cls := entry at:1.
	sel := entry at:2.
	mthd := entry at:3.
"/        s := self 
"/                listEntryForMethod:mthd 
"/                selector:sel 
"/                class:cls 
"/                showClass:false 
"/                showCategory:showCategory
"/                classFirst:false.
"/        newNameList add:s.
        
	selectorList add:sel.
	s := sel.

	catOrCounts := categoryOrCountPerSelector at:sel.
	catOrCounts isInteger ifTrue:[
	    s := s , ' { ... }'  "/ in multiple categories
	] ifFalse:[
	    allCategories size > 1 ifTrue:[
		s := s , ' {' , catOrCounts , '}'
	    ]
	].
	newNameList add:s.
    ].

    classes := newClasses.
    ^ newNameList.

    "Created: / 5.2.2000 / 22:43:40 / cg"
    "Modified: / 1.3.2000 / 21:00:26 / cg"
!

release
    super release.

    selectedSelectors removeDependent:self.
! !

!ImplementingMethodList class methodsFor:'documentation'!

version
    ^ '$Id: Tools__ImplementingMethodList.st 8083 2013-01-14 11:48:37Z vranyj1 $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__ImplementingMethodList.st 8083 2013-01-14 11:48:37Z vranyj1 $'
! !

