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

BrowserList subclass:#ClassGeneratorList
	instanceVariableNames:'organizerList categoryList namespaceList namespaceNameList
		projectList selectedCategories selectedNamespaces
		selectedProjects selectedClasses'
	classVariableNames:'AdditionalEmptyCategories AdditionalEmptyProjects'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!ClassGeneratorList class methodsFor:'documentation'!

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
    embeddable application displaying the class-categories.
    Provides an outputGenerator, which enumerates the classes in
    the selected categories.

    [author:]
	Claus Gittinger (cg@exept.de)
"
! !

!ClassGeneratorList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ClassGeneratorList andSelector:#windowSpec
     ClassGeneratorList new openInterface:#windowSpec
     ClassGeneratorList open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'OrganizerList'
          #name: 'OrganizerList'
          #min: #(#Point 0 0)
          #bounds: #(#Rectangle 12 22 312 322)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SequenceViewSpec
              #name: 'List'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #tabable: true
              #model: #organizerSelection
              #menu: #menuHolder
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #valueChangeSelector: #selectionChangedByClick
              #useIndex: true
              #sequenceList: #organizerList
              #doubleClickChannel: #doubleClickChannel
            )
           )
         
        )
      )

    "Modified: / 18.8.2000 / 20:12:20 / cg"
! !

!ClassGeneratorList methodsFor:'aspects'!

categoryList
    categoryList isNil ifTrue:[
	categoryList := ValueHolder new.
    ].
    ^ categoryList


!

nameSpaceList
    namespaceList isNil ifTrue:[
	namespaceList := ValueHolder new
    ].
    ^ namespaceList

    "Created: / 18.2.2000 / 00:59:01 / cg"
!

projectList
    projectList isNil ifTrue:[
	projectList := ValueHolder new
    ].
    ^ projectList

    "Created: / 17.2.2000 / 23:39:32 / cg"

!

selectedCategories
    selectedCategories isNil ifTrue:[
	selectedCategories := ValueHolder new.
	selectedCategories addDependent:self
    ].
    ^ selectedCategories.

!

selectedCategories:aValueHolder
    |prevSelection|

    prevSelection := selectedCategories value ? #().

    selectedCategories notNil ifTrue:[
	selectedCategories removeDependent:self
    ].
    selectedCategories := aValueHolder.
    selectedCategories notNil ifTrue:[
	selectedCategories addDependent:self
    ].
    (selectedCategories value ? #()) ~= prevSelection ifTrue:[
	"/ update
	self update:#value with:nil from:selectedCategories
    ].



!

selectedClasses
    "bad name- it's a holder, baby"

    selectedClasses isNil ifTrue:[
        selectedClasses := ValueHolder new.
    ].
    ^ selectedClasses.
!

selectedClasses:aValueHolder
"/    selectedClasses notNil ifTrue:[
"/        selectedClasses removeDependent:self
"/    ].
    selectedClasses := aValueHolder.
"/    selectedClasses notNil ifTrue:[
"/        selectedClasses addDependent:self
"/    ].
!

selectedNamespaces
    selectedNamespaces isNil ifTrue:[
	selectedNamespaces := ValueHolder new.
	selectedNamespaces addDependent:self
    ].
    ^ selectedNamespaces.

!

selectedNamespaces:aValueHolder
    |prevSelection|

    prevSelection := selectedNamespaces value ? #().

    selectedNamespaces notNil ifTrue:[
	selectedNamespaces removeDependent:self
    ].
    selectedNamespaces := aValueHolder.
    selectedNamespaces notNil ifTrue:[
	selectedNamespaces addDependent:self
    ].
    (selectedNamespaces value ? #()) ~= prevSelection ifTrue:[
	"/ update
	self update:#value with:nil from:selectedNamespaces
    ].



!

selectedProjects
    selectedProjects isNil ifTrue:[
	selectedProjects := ValueHolder new.
	selectedProjects addDependent:self
    ].
    ^ selectedProjects.

!

selectedProjects:aValueHolder
    |prevSelection|

    prevSelection := selectedProjects value ? #().

    selectedProjects notNil ifTrue:[
	selectedProjects removeDependent:self
    ].
    selectedProjects := aValueHolder.
    selectedProjects notNil ifTrue:[
	selectedProjects addDependent:self
    ].
    (selectedProjects value ? #()) ~= prevSelection ifTrue:[
	"/ update
	self update:#value with:nil from:selectedProjects
    ].



! !

!ClassGeneratorList methodsFor:'aspects-private'!

organizerList
    organizerList isNil ifTrue:[
	organizerList := ValueHolder new.
    ].
    ^ organizerList


! !

!ClassGeneratorList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    |cls sel pkg mthd orgMode|

    changedObject == environment ifTrue:[
        orgMode := organizerMode value.

        orgMode == OrganizerCanvas organizerModeCategory ifTrue:[
            (something == #organization 
             or:[something == #newClass]) ifTrue:[
                self updateList.
                ^ self
            ].
            something == #methodInClass ifTrue:[ ^ self ].
"/ self halt:'debug halt'.
            ^ self.
        ].
        orgMode == OrganizerCanvas organizerModeNamespace ifTrue:[
            (something == #newClass 
            or:[something == #classRemove]) ifTrue:[
                aParameter isNameSpace ifTrue:[
                    self updateList
                ].
                ^ self
            ].
"/ self halt:'debug halt'.
            ^ self
        ].
        orgMode == OrganizerCanvas organizerModeProject ifTrue:[
            something == #projectOrganization ifTrue:[
                self updateList.
                ^ self
            ].
            something == #methodInClass ifTrue:[
                cls := aParameter at:1.
                sel := aParameter at:2.
                mthd := cls compiledMethodAt:sel.
                pkg := mthd package.
                (projectList value includes:pkg) ifFalse:[
                    self halt:'debug-halt. remove when known to work'.
                    self updateList.
                    ^ self
                ].
                ^ self
            ].
            (something == #classDefinition
            or:[something == #newClass]) ifTrue:[
                cls := aParameter.
                pkg := cls package.
                (projectList value includes:pkg) ifFalse:[
                    self halt:'debug-halt. remove when known to work'.
                    self updateList.
                    ^ self
                ].
                ^ self
            ].
"/    self halt.
            ^ self
        ].
        ^ self
    ].
    super delayedUpdate:something with:aParameter from:changedObject

    "Created: / 25.2.2000 / 21:32:03 / cg"
    "Modified: / 25.2.2000 / 21:35:23 / cg"
! !

!ClassGeneratorList methodsFor:'private'!

listFromInGenerator
    |generator theList|

    theList := Set new.
    generator := inGeneratorHolder value.
    generator isNil ifTrue:[^ #() ].
    generator do:[:prj | theList add:prj].
    theList := theList asOrderedCollection sort.
    theList addFirst:(self class nameListEntryForALL allItalic).
    ^ theList

    "Created: / 25.2.2000 / 21:24:26 / cg"
!

listOfCategories
    |categories hideUnloadedClasses|

    inGeneratorHolder notNil ifTrue:[
        ^ self listFromInGenerator
    ].

    hideUnloadedClasses := self hideUnloadedClasses value.

    categories := Set new.
    environment allClassesDo:[:cls |
        (hideUnloadedClasses not or:[cls isLoaded])
        ifTrue:[
            categories add:cls category.
        ]
    ].

    "/ those are simulated - in ST/X, empty categories do not
    "/ really exist; however, during browsing, it makes sense.
    AdditionalEmptyCategories size > 0 ifTrue:[
        "/ remove those that are present ...
        AdditionalEmptyCategories := AdditionalEmptyCategories reject:[:cat | (categories includes:cat)].
        categories addAll:AdditionalEmptyCategories.
    ].
    categories := categories asOrderedCollection.
    categories sort.
    categories addFirst:(self class nameListEntryForALL allItalic).
    ^ categories

    "Created: / 5.2.2000 / 13:42:12 / cg"
    "Modified: / 25.2.2000 / 21:26:04 / cg"
!

listOfNamespaces
    |allNamespaces showAllNamespaces|

    inGeneratorHolder notNil ifTrue:[
        ^ self listFromInGenerator
    ].

showAllNamespaces := true.

    allNamespaces := IdentitySet new.

    (self hideUnloadedClasses value) ifTrue:[
        environment allClassesDo:[:eachClass |
            eachClass isLoaded ifTrue:[
                allNamespaces add:(eachClass theNonMetaclass topNameSpace)
            ].
        ]
    ] ifFalse:[
        allNamespaces := NameSpace allNameSpaces.
    ].

    showAllNamespaces ifFalse:[
        "/ only topLevel namespaces are shown
        "/ i.e. ignore subspaces 

        allNamespaces := allNamespaces select:[:ns | ns isTopLevelNameSpace].
    ].
    allNamespaces := allNamespaces collect:[:ns | ns name].
    allNamespaces := allNamespaces asOrderedCollection.
    allNamespaces sort.
    allNamespaces addFirst:(self class nameListEntryForALL allItalic).
    ^ allNamespaces

    "Created: / 25.2.2000 / 21:21:14 / cg"
    "Modified: / 25.2.2000 / 21:26:41 / cg"
!

listOfProjects
    |allProjects|

    inGeneratorHolder notNil ifTrue:[
        ^ self listFromInGenerator
    ].

    allProjects := IdentitySet new.

    (self hideUnloadedClasses value) ifTrue:[
        allProjects := environment allLoadedPackageIDs.
    ] ifFalse:[
        allProjects := environment allPackageIDs.
    ].

    "/ those are simulated - in ST/X, empty projects do not
    "/ really exist; however, during browsing, it makes sense.
    AdditionalEmptyProjects size > 0 ifTrue:[
        "/ remove those that are present ...
        AdditionalEmptyProjects := AdditionalEmptyProjects reject:[:pkg | (allProjects includes:pkg)].
        allProjects addAll:AdditionalEmptyProjects.
    ].
    allProjects sort.
    allProjects addFirst:(self class nameListEntryForALL allItalic).
    ^ allProjects

    "Created: / 25.2.2000 / 21:22:06 / cg"
    "Modified: / 25.2.2000 / 21:27:27 / cg"
!

makeDependent
    environment addDependent:self

!

makeIndependent
    environment removeDependent:self.

!

release
    super release.

    selectedCategories removeDependent:self.
    selectedNamespaces removeDependent:self.
    selectedProjects removeDependent:self.
!

updateCategoryList
    |newList|

    newList := self listOfCategories.
    newList ~= self categoryList value ifTrue:[
	categoryList value:newList.
	self organizerList value:newList.
    ].

    "Created: / 25.2.2000 / 21:12:32 / cg"
!

updateList
    |orgMode|

    orgMode := self organizerMode value.
    orgMode == OrganizerCanvas organizerModeCategory ifTrue:[
        self updateCategoryList.
        ^ self
    ].
    orgMode == OrganizerCanvas organizerModeProject ifTrue:[
        self updateProjectList.
        ^ self
    ].
    orgMode == OrganizerCanvas organizerModeNamespace ifTrue:[
        self updateNamespaceList.
        ^ self
    ].
    self halt:'unexpected value'.

    "Created: / 5.2.2000 / 13:42:13 / cg"
    "Modified: / 25.2.2000 / 21:14:19 / cg"
!

updateNamespaceList
    |newList|

    newList := self listOfNamespaces.
    newList ~= self nameSpaceList value ifTrue:[
	namespaceList value:newList.
	self organizerList value:newList.
    ].

    "Created: / 25.2.2000 / 21:13:16 / cg"
!

updateProjectList
    |newList|

    newList := self listOfProjects.
    newList ~= self projectList value ifTrue:[
	projectList value:newList.
	self organizerList value:newList.
    ].

    "Created: / 25.2.2000 / 21:12:57 / cg"
! !

!ClassGeneratorList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__ClassGeneratorList.st 8083 2013-01-14 11:48:37Z vranyj1 $'
! !

