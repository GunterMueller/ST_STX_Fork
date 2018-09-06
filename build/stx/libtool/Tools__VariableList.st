"
 COPYRIGHT (c) 2000 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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

BrowserList subclass:#VariableList
	instanceVariableNames:'classHolder groupVariablesByInheritance selectedVariableEntries
		showClassVars showWarningAboutMissingEntryInXmlSpec
		sortVariablesByName variableList'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

Object subclass:#VariableEntry
	instanceVariableNames:'label application class name type icon sortingByNameHolder
		classShown groupByInheritanceHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:VariableList
!

!VariableList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    I implement the variable list (below class list) in the new system browser
"
! !

!VariableList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::VariableList andSelector:#windowSpec
     Tools::VariableList new openInterface:#windowSpec
     Tools::VariableList open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'VariableList'
          name: 'VariableList'
          min: (Point 0 0)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SequenceViewSpec
              name: 'List'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              tabable: true
              model: selectedVariableEntries
              menu: menuHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              isMultiSelect: true
              valueChangeSelector: selectionChangedByClick
              useIndex: false
              sequenceList: variableList
              doubleClickChannel: doubleClickChannel
            )
           )
         
        )
      )
! !

!VariableList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        environmentHolder
        #(#doubleClickChannel #action )
        #classHolder
        #forceGeneratorTrigger
        #immediateUpdate
        #inGeneratorHolder
        #menuHolder
        #outGeneratorHolder
        #packageFilter
        #selectedVariables
        #selectionChangeCondition
        #updateTrigger
        #showClassVarsInVariableList
        #slaveMode
        #sortVariablesByName
        #groupVariablesByInheritance
      ).

    "Modified: / 24-02-2014 / 10:37:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableList methodsFor:'aspects'!

classHolder
    classHolder isNil ifTrue:[
	classHolder := #() asValue.
	classHolder addDependent:self
    ].
    ^ classHolder
!

classHolder:aValueHolder
    classHolder notNil ifTrue:[
        classHolder removeDependent:self
    ].
    classHolder := aValueHolder.
    classHolder notNil ifTrue:[
        classHolder isBehavior ifTrue:[self error:'should not happen'].
        classHolder addDependent:self
    ].

    "Modified: / 11-07-2011 / 17:04:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultSlaveModeValue
    ^ false.
!

groupVariablesByInheritance
    "/ groupVariablesByInheritance and sortVariablesByName form a 3-state value
    "/      groupVariablesByInheritance sortVariablesByName
    "/                  T                   T                   - sort within each defining class
    "/                  T                   F                   - by inst-order grouped by defining class
    "/                  F                   T                   - show all of them in one big sorted list
    "/                  F                   F                   - useless - show all of them by inst-order
    groupVariablesByInheritance isNil ifTrue:[
        groupVariablesByInheritance := true asValue.
        groupVariablesByInheritance addDependent:self
    ].
    ^ groupVariablesByInheritance
!

groupVariablesByInheritance:aValueHolder
    "/ self assert:(aValueHolder value isBoolean).

    groupVariablesByInheritance notNil ifTrue:[
        groupVariablesByInheritance removeDependent:self
    ].
    groupVariablesByInheritance := aValueHolder.
    groupVariablesByInheritance notNil ifTrue:[
        groupVariablesByInheritance addDependent:self
    ].
!

selectedVariableEntries
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    selectedVariableEntries isNil ifTrue:[
        selectedVariableEntries := #() asValue.
        selectedVariableEntries addDependent:self.
    ].
    ^ selectedVariableEntries.

    "Modified: / 12-04-2011 / 15:49:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedVariables
    ^ self selectionHolder

!

selectedVariables:aValueHolder
    ^ self selectionHolder:aValueHolder

!

showClassVarsInVariableList
    showClassVars isNil ifTrue:[
	showClassVars := false asValue.
	showClassVars addDependent:self
    ].
    ^ showClassVars
!

showClassVarsInVariableList:aValueHolder
    showClassVars notNil ifTrue:[
	showClassVars removeDependent:self
    ].
    showClassVars := aValueHolder.
    showClassVars notNil ifTrue:[
	showClassVars addDependent:self
    ].
!

showingInheritedClassVars
    ^ false
    "/ ^ true
!

sortVariablesByName
    "/ groupVariablesByInheritance and sortVariablesByName form a 3-state value
    "/      groupVariablesByInheritance sortVariablesByName
    "/                  T                   T                   - sort within each defining class
    "/                  T                   F                   - by inst-order grouped by defining class
    "/                  F                   T                   - show all of them in one big sorted list
    "/                  F                   F                   - useless - show all of them by inst-order
    sortVariablesByName isNil ifTrue:[
        sortVariablesByName := false asValue.
        sortVariablesByName addDependent:self
    ].
    ^ sortVariablesByName
!

sortVariablesByName:aValueHolder
    "/ self assert:(aValueHolder value isBoolean).

    sortVariablesByName notNil ifTrue:[
        sortVariablesByName removeDependent:self
    ].
    sortVariablesByName := aValueHolder.
    sortVariablesByName notNil ifTrue:[
        sortVariablesByName addDependent:self
    ].
!

variableList
    variableList isNil ifTrue:[
	variableList := ValueHolder new
    ].
    ^ variableList


! !

!VariableList methodsFor:'change & update'!

delayedUpdate:something with:aParameter from:changedObject
    |selectedClasses changedClass anyChange|

    self inSlaveModeOrInvisible ifTrue:[self invalidateList. ^ self].

    changedObject == slaveMode ifTrue:[
        listValid ~~ true ifTrue:[
            self enqueueDelayedUpdateList
        ].
        "/ self invalidateList.
        ^  self
    ].

    changedObject == classHolder ifTrue:[
        self invalidateList.
        ^  self
    ].
    changedObject == showClassVars ifTrue:[
        self invalidateList.
        ^ self.
    ].
    changedObject == sortVariablesByName ifTrue:[
        self invalidateList.
        ^ self.
    ].
    changedObject == groupVariablesByInheritance ifTrue:[
        self invalidateList.
        ^ self.
    ].
    changedObject == environment ifTrue:[
        (something == #projectOrganization) ifTrue:[^ self].
        (something == #currentChangeSet) ifTrue:[^ self].
        (something == #aboutToAutoloadClass) ifTrue:[^ self].

        (something == #classDefinition
        or:[ (something == #newClass)
        or:[ something == #classVariables and:[showClassVars value == true]]])
        ifTrue:[
            changedClass := aParameter.
            selectedClasses := classHolder value.
            selectedClasses notNil ifTrue:[
                selectedClasses isSequenceable ifFalse:[
                    selectedClasses := selectedClasses asOrderedCollection
                ].
                selectedClasses keysAndValuesDo:[:idx :cls | |nm|
                    cls notNil ifTrue:[
                        cls isObsolete ifTrue:[
                            cls isMeta ifTrue:[
                                nm := cls theNonMetaclass name.
                                selectedClasses at:idx put:(environment at:nm) class.
                            ] ifFalse:[
                                nm := cls name.
                                selectedClasses at:idx put:(environment at:nm).
                            ].
                            anyChange := true.
                        ] ifFalse:[
                            (cls == aParameter 
                            or:[something == #classVariables 
                                and:[showClassVars value == true
                                and:[cls theNonMetaclass == aParameter theNonMetaclass]]]) ifTrue:[
                                anyChange := true.
                            ]
                        ]
                    ]
                ].
                (selectedClasses includes:nil) ifTrue:[
                    "/ can happen, if a selected class is removed...
                    "/ self halt:'should this happen ?'.
                    "/ fix it ...
                    selectedClasses := selectedClasses select:[:each | each notNil].
                    classHolder value:selectedClasses.
                    anyChange := true.
                ].
                anyChange == true ifTrue:[
                    self invalidateList.
                    ^  self
                ].
            ].
            ^  self
        ].
    ] ifFalse:[
        changedObject isBehavior ifTrue:[
            anyChange := false.
            selectedClasses := classHolder value.
            selectedClasses notNil ifTrue:[
                selectedClasses keysAndValuesDo:[:idx :cls | |nm|
                    cls isObsolete ifTrue:[
                        nm := cls name.
                        selectedClasses at:idx put:(environment at:nm).
                        anyChange := true.
                    ]
                ].
                anyChange == true ifTrue:[
                    self invalidateList.
                    ^  self
                ].

                (selectedClasses includesIdentical:something) ifTrue:[    
                    self invalidateList.
                    ^  self
                ].
            ].
            ^  self
        ].
    ].
    super delayedUpdate:something with:aParameter from:changedObject

    "Modified: / 01-03-2012 / 09:18:11 / cg"
!

makeDependent
    environment addDependent:self

!

makeIndependent
    environment removeDependent:self

!

selectionChangedByClick
    "we are not interested in that - get another notification
     via the changed valueHolder"


!

update:something with:aParameter from:changedObject
    "/ ^ self delayedUpdate:something with:aParameter from:changedObject.

    changedObject == environment ifTrue:[
        something == #methodDictionary ifTrue:[
            ^ self 
        ].
        something == #methodTrap ifTrue:[
            ^ self
        ].
        something == #methodCoverageInfo ifTrue:[
            ^ self
        ].
        something == #methodInClass ifTrue:[
            ^ self
        ].
        something == #methodInClassRemoved ifTrue:[
            ^ self
        ].
        something == #classComment ifTrue:[
            ^ self.
        ].
        something == #lastTestRunResult ifTrue:[
            ^ self
        ].
        something isNil ifTrue:[
            ^ self
        ].
    ].
"/    self window sensor isNil ifTrue:[
"/        "/ I am not visible ...
"/        self invalidateList.
"/        ^ self
"/    ].
    changedObject == selectedVariableEntries ifTrue:[
        self selectedVariables value:
            ((selectedVariableEntries value ? #())
                select:[:e| e isString not]         "filter out class name header strings"
                thenCollect:[:e|e name]).
        ^self.
    ].


    super update:something with:aParameter from:changedObject

    "Modified: / 12-04-2011 / 15:54:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-07-2011 / 18:52:44 / cg"
! !

!VariableList methodsFor:'generators'!

makeGenerator



! !

!VariableList methodsFor:'private'!

commonPostBuild
    |list|

    super commonPostBuild.

    list := builder componentAt:#List.
    list notNil ifTrue:[
        list selectConditionBlock:[:item | self selectionChangeAllowed:item].
        list ignoreReselect:false.
    ].
!

commonSubClassIn:classes
    "return true if there is a common subclass"

    |theCommonSubClass "classesByInheritance"|

    theCommonSubClass := nil.
    classes do:[:eachClass |
	theCommonSubClass isNil ifTrue:[
	    theCommonSubClass := eachClass
	] ifFalse:[
	    (eachClass isSubclassOf:theCommonSubClass) ifTrue:[
		theCommonSubClass := eachClass    
	    ] ifFalse:[
		(theCommonSubClass isSubclassOf:eachClass) ifFalse:[
		    ^ nil
		]
	    ]
	]
    ].
    ^ theCommonSubClass.

"/    classesByInheritance := classes topologicalSort:[:a :b | a isSubclassOf:b].
"/    classesByInheritance keysAndValuesDo:[:index :eachClass |
"/        "/ all classes after that one must be superclasses ...
"/        classesByInheritance from:index+1 to:classesByInheritance size do:[:otherClass |
"/            (eachClass isSubclassOf:otherClass) ifFalse:[
"/                ^ nil.
"/            ]
"/        ].
"/    ].
"/    ^ classesByInheritance first
!

iconInBrowserForVariable:varName in:aClass
    "variables for which an entry is found in the xml-spec (if any) are marked
     with an <xml>-icon."

    (Expecco::ExpeccoXMLDecoder notNil 
    and:[aClass canUnderstand: #xmlSpecForObject:]) ifTrue:[
        Error handle:[:ex |
        ] do:[
            (Expecco::ExpeccoXMLDecoder xmlSpecForObject:aClass basicNew)
                do:[:spec | spec getter = varName ifTrue:[
                                ^ SystemBrowser instVarOverlayXmlSpec
                            ]
                ].
        ].
    ].
    ^ nil

    "Created: / 12-04-2011 / 19:58:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-07-2011 / 18:32:47 / cg"
    "Modified: / 22-06-2012 / 13:17:28 / sr"
!

listEntryForClass: cls name:name
    ^ self listEntryForClass: cls name:name info:nil
!

listEntryForClass: cls name:name info: classInfoOrNil
    | entry |

    entry := Tools::VariableList::VariableEntry application: self class: cls name: name.
    entry sortingByNameHolder:sortVariablesByName.
    entry groupByInheritanceHolder:groupVariablesByInheritance.
    classInfoOrNil notNil ifTrue:[
        entry type: (classInfoOrNil infoForInstvarOrNil: name).
    ].
    ^entry

    "Created: / 27-11-2011 / 17:17:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-10-2013 / 08:28:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listOfVariables

    |nameList numClasses classes class commonSubclass showingClassVars
     sortByName groupByInheritance classesAlreadyProcessed hasSmallSense smallSenseManager info |

    classHolder isNil ifTrue:[
        "/ testing
        ^ #()
    ].

    hasSmallSense := (ConfigurableFeatures includesFeature:'SmallSenseEnabled')
                        and:[(Smalltalk at: #'SmallSense::Manager') notNil].
    hasSmallSense ifTrue:[
        smallSenseManager := (Smalltalk at: #'SmallSense::Manager') instance.
    ].

    showingClassVars := self showClassVarsInVariableList value == true.
    sortByName := self sortVariablesByName value.
    groupByInheritance := self groupVariablesByInheritance value.
    self assert:(sortByName isBoolean).
    self assert:(groupByInheritance isBoolean).

    classes := classHolder value.
    (numClasses := classes size) == 0 ifTrue:[^ #() ].
    numClasses > 1 ifTrue:[
        "/ multiple classes - see if there is a common subclass ...
        commonSubclass := self commonSubClassIn:classes.
        commonSubclass notNil ifTrue:[
            "/ yes - treat like a single class
            classes := Array with:(commonSubclass).
            numClasses := 1.
        ].
"/        commonSuperclass := Behavior commonSuperclassOf:classes.
"/        commonSuperclass notNil ifTrue:[
"/            "/ yes - treat like a single class
"/            classes := Array with:(commonSuperclass).
"/            numClasses := 1.
"/        ].
    ].

    numClasses > 1 ifTrue:[
        "/ multiple classes - sort alphabetically ...
        "/ unless there is a common subclass ...
        nameList := Set new.
        classesAlreadyProcessed := IdentitySet new.
        classes do:[:eachClass |
            |class|

           class := eachClass.
"/            showingClassVars ifTrue:[
"/                class := class theNonMetaclass 
"/            ].

            hasSmallSense ifTrue:[
                info := smallSenseManager infoForClassOrNil: class.
            ].                            

            (classesAlreadyProcessed includes:class) ifFalse:[
                showingClassVars ifTrue:[
                    self showingInheritedClassVars ifTrue:[
                        class theNonMetaclass withAllSuperclassesDo:[:cls|
                            hasSmallSense ifTrue:[
                                info := smallSenseManager infoForClassOrNil: cls.
                            ].                            

                            (classesAlreadyProcessed includes:cls) ifFalse:[
                                "/ Must check whether environment contains the class and filter it out,
                                "/ if not. Think of limited environment to Java classes which should not
                                "/ show Object & JavaObject even if they are real superclasses of any Java
                                "/ class.
                                "/ Q: Should we rather ignore all superclasses after first class which is not
                                "/ in environment?                       

                                (environment at: cls name ifAbsent:[nil]) notNil ifTrue:[
                                    nameList addAll:
                                       (cls classVarNames collect:[:nm|self listEntryForClass: cls name: nm info: info]).
                                ].
                                classesAlreadyProcessed add:cls.
                            ]
                        ]
                    ] ifFalse:[
                        nameList addAll:
                            (class classVarNames collect:[:nm|self listEntryForClass: class name: nm info: info ])                            
                    ]
                ] ifFalse:[
                    class withAllSuperclassesDo:[:cls|
                        (classesAlreadyProcessed includes:cls) ifFalse:[
                            "/ Must check whether environment contains the class and filter it out,
                            "/ if not. Think of limited environment to Java classes which should not
                            "/ show Object & JavaObject even if they are real superclasses of any Java
                            "/ class.
                            "/ Q: Should we rather ignore all superclasses after first class which is not
                            "/ in environment?                       

                            (environment at: cls theNonMetaclass name ifAbsent:[nil]) notNil ifTrue:[    
                                nameList addAll:
                                        (cls instVarNames collect:[:nm|self listEntryForClass: cls name: nm info: info ]).                            
                            ].
                            classesAlreadyProcessed add:cls.
                        ]
                    ]
                ]
            ]
        ].
        nameList := nameList asOrderedCollection.
    ] ifFalse:[
        "/ only a single class - sort by inheritance
        class := classes first.

        nameList := OrderedCollection new.
        class notNil ifTrue:[
            showingClassVars ifTrue:[
                class := class theNonMetaclass 
            ].
            class withAllSuperclassesDo:[:cls|
                "/ Must check whether environment contains the class and filter it out,
                "/ if not. Think of limited environment to Java classes which should not
                "/ show Object & JavaObject even if they are real superclasses of any Java
                "/ class.
                "/ Q: Should we rather ignore all superclasses after first class which is not
                "/ in environment?                       

                (environment at: cls theNonMetaclass name ifAbsent:[nil]) notNil ifTrue:[
                    |varNames classShown|

                    (hasSmallSense and:[showingClassVars not]) ifTrue:[
                        info := smallSenseManager infoForClassOrNil: cls.
                    ].                            
                    varNames := showingClassVars ifTrue:[ cls classVarNames ] ifFalse:[ cls instVarNames ].
                    classShown := (cls ~~ class). "/ only append the class in the shown name, if the var is inherited
                    sortByName ifTrue:[
                        varNames := varNames copy sort.
                    ].    
                    varNames reversed do:[:varName|
                        |entry|
                        nameList addFirst: (entry := self listEntryForClass: cls name: varName info: info).
                        classShown ifFalse:[ entry classShown:classShown ].
                    ].
                    groupByInheritance ifTrue:[
                        nameList addFirst:(("'----- ' , "cls nameInBrowser" , ' -----'") withColor: Color gray).
                    ]
                ].
            ].
        ].
    ].

    (numClasses > 1 or:[sortByName and:[groupByInheritance not]]) ifTrue:[
        nameList := nameList asSortedCollection:[:a :b|a name < b name].
    ].
    ^ nameList

    "Created: / 05-02-2000 / 13:42:11 / cg"
    "Modified: / 08-08-2011 / 16:20:58 / cg"
    "Modified: / 28-10-2014 / 11:42:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildWith:aBuilder
    |listView|

    (listView := aBuilder componentAt:#List) notNil ifTrue:[
	listView scrollWhenUpdating:#end
    ].
    super postBuildWith:aBuilder

!

release
    super release.

    classHolder removeDependent:self.
    showClassVars removeDependent:self.
!

selectionChangeAllowed:index

    | entry |
    ^((entry := variableList value at:index) isString" and:[entry startsWith:'---']") not.

    "Modified: / 28-04-2011 / 13:18:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    | prevSelection newSelection newList oldList selectedVariablesHolder|

    oldList := self variableList value copy.
    showWarningAboutMissingEntryInXmlSpec := false.
    newList := self listOfVariables.

    newList ~= variableList value ifTrue:[
        selectedVariablesHolder := self selectedVariableEntries.
        prevSelection := (self selectedVariables value "selectedVariablesHolder value" copy) ? #().
        variableList value:newList.

        newSelection := newList select:[:item | prevSelection includes:item string].
"/         newSelection := prevSelection select:[:item | newList includes:item].

        newSelection size > 0 ifTrue:[
            "/ force change (for dependents)
            "/ selectedVariablesHolder value:nil.
            selectedVariablesHolder 
                setValue:newSelection;
                removeDependent:self;
                changed;
                addDependent:self.
        ] ifFalse:[
            prevSelection := selectedVariablesHolder value.
            selectedVariablesHolder value:nil.
        ].
        (prevSelection size > 0 or:[newSelection size > 0
        "and:[ prevSelection ~= newSelection]"]) ifTrue:[
            self updateOutputGenerator.
        ].
    ].
    (showWarningAboutMissingEntryInXmlSpec and:[self topApplication respondsTo: #showMessage:]) 
        ifTrue:
            [
            self topApplication showMessage: 
                'One or more instance variables are not listed in #xmlSpecFor:'.
            ].
    showWarningAboutMissingEntryInXmlSpec := false.
    self setListValid:true.

    "Modified: / 05-08-2011 / 12:34:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-03-2012 / 15:55:47 / cg"
! !

!VariableList::VariableEntry class methodsFor:'instance creation'!

application: app class: aClass name: aString

    ^self new application: app; class: aClass; name: aString

    "Created: / 12-04-2011 / 19:53:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

class: aClass name: aString

    ^self new class: aClass; name: aString

    "Created: / 12-04-2011 / 15:39:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableList::VariableEntry methodsFor:'accessing'!

application: anObject

    application := anObject

    "Created: / 12-04-2011 / 19:55:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asString

    ^self name

    "Created: / 11-07-2011 / 17:03:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

class:aClass
    class := aClass.
!

classShown:aBoolean
    classShown := aBoolean.
!

groupByInheritanceHolder:aValueHolder
    "/ is there a need for a valueHolder?
    groupByInheritanceHolder := aValueHolder.
!

icon
    icon isNil ifTrue:[
        icon := application iconInBrowserForVariable: name in: class.
        icon isNil ifTrue:[icon := #NOICON].        
    ].
    ^icon

    "Created: / 12-04-2011 / 15:54:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-04-2011 / 19:58:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 15:05:18 / cg"
!

klass
    ^ class

    "Created: / 12-04-2011 / 19:54:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    label isNil ifTrue:[
        label := name.
        type notNil ifTrue:[
            label := (label , ' ' ,  (type displayString withColor: Color brown))
        ] ifFalse:[
            "/ Hack for Java classes to display field type
            class theNonMetaclass isJavaClass ifTrue:[
                | field |
                field := class theNonMetaclass lookupFieldFor:name static: (class isMetaclass).
                field notNil ifTrue:[
                    label := label asText , 
                            ' ' , 
                                (('< ' , (JavaMethod fieldTypeFromStream: (field descriptor readStream) in: class theNonMetaclass javaPackage) , ' >')
                                        withColor: Color brown).
                ].
            ].    
        ].
    ].
    ^label

    "Created: / 16-12-2011 / 00:54:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2016 / 21:29:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelWithClass
    |l|

    l := self label.
    class notNil ifTrue:[
        ^ label,' (' ,(class nameWithoutPrefix withColor: Color gray),')' 
    ].
    ^label
!

name
    ^ name
!

name:aString
    name := aString.
!

sortingByNameHolder:aValueHolder
    "/ is there a need for a valueHolder?
    sortingByNameHolder := aValueHolder.
!

string

    ^name

    "Created: / 12-04-2011 / 15:45:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    "Return a SmallSense inferred type"

    ^ type

    "Modified (format): / 16-12-2011 / 00:41:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type:aSmallSenseType
    "Sets a SmallSense inferred type"

    type := aSmallSenseType.

    "Modified (format): / 16-12-2011 / 00:41:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableList::VariableEntry methodsFor:'displaying'!

displayOn:aGC x:x y:y opaque:opaque
    | icn shownLabel |

    icn := self icon.
    icn ~~ #NOICON ifTrue:[
        icn displayOn:aGC x:x + 1 y:y - icn height.
    ].

    shownLabel := ((classShown ? true) and:[sortingByNameHolder value and:[groupByInheritanceHolder value not]]) 
                    ifTrue:[ self labelWithClass ]
                    ifFalse: [ self label ].

    shownLabel displayOn:aGC x:x + 20 y:y opaque: opaque

    "Created: / 12-04-2011 / 15:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableList::VariableEntry methodsFor:'queries'!

widthOn:aGC

    ^20"space for icon, see displayOn:..."
        + (self label widthOn:aGC)

    "Created: / 16-12-2011 / 01:04:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VariableList class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

