"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

InspectorView subclass:#DictionaryInspectorView
	instanceVariableNames:'keys hideClassVars hideClasses hideUnloadedClasses hideAliases
		hideNilValues hideLiteralValues hideColorsAndImages
		hideSignalInstances'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Inspector'
!

!DictionaryInspectorView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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
    a modified Inspector for Dictionaries

    [author:]
        Claus Gittinger
"
! !

!DictionaryInspectorView methodsFor:'event handling'!

keyPress:key x:x y:y
    "handle special keys"

    <resource: #keyboard (#Delete #BackSpace #Insert)>

    (key == #Delete or:[key == #BackSpace]) ifTrue:[
        self doRemoveKey.
        ^ self.
    ].
    (key == #Insert) ifTrue:[
        self doAddKey.
        ^ self.
    ].

    super keyPress:key x:x y:y
! !

!DictionaryInspectorView methodsFor:'initialization & release'!

initialize
    super initialize.

    listView multipleSelectOk:true.

    hideClassVars := false.
    hideClasses := false.
    hideUnloadedClasses := false.
    hideAliases := false.
    hideLiteralValues := false.
    hideNilValues := false.
    hideColorsAndImages := false.
    hideSignalInstances := false.
! !

!DictionaryInspectorView methodsFor:'menu'!

fieldMenu
    <resource: #programMenu >

    |items m selIdx|

    inspectedObject isNameSpace ifTrue:[
        items := #(
                       ('Copy Key'             doCopyKey      )
                       ('-')
                       ('Inspect'              doInspect      )
                       ('Inspect Key'          doInspectKey   )
                       ('BasicInspect'         doBasicInspect )
             ).
    NewInspector::NewInspectorView notNil ifTrue:[
        items := items , #(
                       ('Inspect Hierarchical'         #doNewInspect           )
                ).
    ].
    items := items , #(
                       ('-')
                       ('Owners'               showOwners     )
                       ('Ref Chains'           showReferences )
                       ('References to Global' showKeyReferences )
                       ('-')
                       ('Browse'               browse         )
                       ('-')
                       ('Add Key...'           doAddKey       )
                       ('Remove Key'           doRemoveKey    )
                       ('-')
                   ).

        hideClassVars == true ifTrue:[
            items := items , #(
                           ('Show ClassVars'   doShowClassVars )
                       ).
        ] ifFalse:[
            items := items , #(
                           ('Hide ClassVars'   doHideClassVars )
                       ).
        ].
        hideClasses == true ifTrue:[
            items := items , #(
                           ('Show Classes'     doShowClasses )
                       ).
        ] ifFalse:[
            items := items , #(
                           ('Hide Classes'     doHideClasses )
                       ).
        ].
        hideUnloadedClasses == true ifTrue:[
            items := items , #(
                           ('Show Unloaded Classes'     doShowUnloadedClasses )
                       ).
        ] ifFalse:[
            items := items , #(
                           ('Hide UnloadedClasses'     doHideUnloadedClasses )
                       ).
        ].
        hideAliases == true ifTrue:[
            items := items , #(
                           ('Show Aliases'     doShowAliases )
                       ).
        ] ifFalse:[
            items := items , #(
                           ('Hide Aliases'     doHideAliases )
                       ).
        ].
        hideLiteralValues == true ifTrue:[
            items := items , #(
                           ('Show Literal Values'  doShowLiteralValues )
                       ).
        ] ifFalse:[
            items := items , #(
                           ('Hide Literal Values'  doHideLiteralValues )
                       ).
        ].
        hideNilValues == true ifTrue:[
            items := items , #(
                           ('Show Nil Values'  doShowNilValues )
                       ).
        ] ifFalse:[
            items := items , #(
                           ('Hide Nil Values'  doHideNilValues )
                       ).
        ].
        hideColorsAndImages == true ifTrue:[
            items := items , #(
                           ('Show Colors and Images'  doShowColorsAndImages )
                       ).
        ] ifFalse:[
            items := items , #(
                           ('Hide Colors and Images'  doHideColorsAndImages )
                       ).
        ].
        hideSignalInstances == true ifTrue:[
            items := items , #(
                           ('Show Signals'  doShowSignalInstances )
                       ).
        ] ifFalse:[
            items := items , #(
                           ('Hide Signals'  doHideSignalInstances )
                       ).
        ].
    ] ifFalse:[
        items := #(
                       ('Copy Key'             doCopyKey      )
                       ('-')
                       ('Inspect'              doInspect      )
                       ('Inspect Key'          doInspectKey   )
                       ('BasicInspect'         doBasicInspect )
                       ('Inspect Hierarchical' doNewInspect   )
                       ('-')
                       ('Owners'               showOwners     )
                       ('Ref Chains'           showReferences )
                       ('Ref Chains to Key'    showReferencesToKey )
                       ('-')
                       ('Browse'                       browse                 )
                       ('Browse Class Hierarchy'       browseClassHierarchy   )
                       ('Browse Full Class Protocol'   browseFullClassProtocol)
                       ('-')
                       ('Add Key...'           doAddKey       )
                       ('Remove Key'           doRemoveKey    )
                   ).
    ].

    (hasMore) ifTrue:[
        items := items , #(                                  
                      ('-')
                      ('Show More'                   showMore               )
                   ).
        (inspectedObject size > (nShown * 2)) ifTrue:[
            items := items , #(
                        ('Show All'                     #showAll                )
                          )
        ].
    ].
    monitorProcess isNil ifTrue:[
        items := items , #(
                       ('-')
                       ('Start Monitor'    doStartMonitor )
                          ).
    ] ifFalse:[
        items := items , #(
                       ('-')
                       ('Stop Monitor'     doStopMonitor  )
                          ).
    ].

    items := items , (self sortOrderItems).
    items := items , #(
                   ('-')
                   ('Update'     doUpdate  )
                      ).

    m := PopUpMenu itemList:items resources:resources.

    (inspectedObject isNameSpace or:[inspectedObject isSharedPool]) ifTrue:[
        m disableAll:#( doAddKey )
    ].
    (inspectedObject isSharedPool) ifTrue:[
        m disableAll:#( doRemoveKey )
    ].

    (selIdx := self theSingleSelectionIndex) isNil ifTrue:[
        m disableAll:#(doInspect doInspectKey doBasicInspect doNewInspect
                       doStartMonitor doStopMonitor doCopyKey 
                       showKeyReferences showReferences showOwners browse
                      ).
        selectionIndex isEmptyOrNil ifTrue:[
            "/ allowed for multi-select
            m disableAll:#( doRemoveKey )
        ]
    ] ifFalse:[
        (self keyIndexForLine:selIdx) isNil ifTrue:[
            m disableAll:#(doInspectKey doRemoveKey doCopyKey)
        ]
    ].
    hideLiteralValues == true ifTrue:[
        m disableAll:#( doShowNilValues doHideNilValues )
    ].

    ^ m.

    "Modified: / 26-09-2012 / 13:20:59 / cg"
! !

!DictionaryInspectorView methodsFor:'menu actions'!

browse
    |cls|

    cls := self selection class theNonMetaclass.
"/    cls isNameSpace ifTrue:[
"/        self halt.
"/    ].
    cls browserClass openInClass:cls selector:nil
!

doAddKey
    "add a key"

    |keyName key val l|

    keyName := Dialog request:'Key to add (storeString):' initialAnswer:''.
    keyName notEmptyOrNil ifTrue:[
        key := Object readFrom:keyName onError:[ self information:'Bad input.'. ^ self].
        (inspectedObject includesKey:key) ifFalse:[
            val := Dialog request:'Value to add (storeString):' initialAnswer:''.
            val notNil ifTrue:[
                val := Object readFrom:val onError:[ self information:'Bad input.'. ^ self].
            ].

            inspectedObject at:key put:val.
            selectionIndex := selectedLine := nil.
            inspectedObject changed.
            l := listView firstLineShown.
            self reinspect. "force list update"
            listView scrollToLine:l
        ]
    ]

    "Modified: / 01-07-2010 / 10:53:25 / cg"
!

doHideAliases
    hideAliases := true.
    self reinspect
!

doHideClassVars
    hideClassVars := true.
    self reinspect
!

doHideClasses
    hideClasses := true.
    self reinspect
!

doHideColorsAndImages
    hideColorsAndImages := true.
    self reinspect
!

doHideLiteralValues
    hideLiteralValues := true.
    self reinspect
!

doHideNilValues
    hideNilValues := true.
    self reinspect
!

doHideSignalInstances
    hideSignalInstances := true.
    self reinspect
!

doHideUnloadedClasses
    hideUnloadedClasses := true.
    self reinspect
!

doInspectKey
    "inspect selected items key"

    |key|

    key := self selectedKey.
    key notNil ifTrue:[
        self inspectNext:key.
    ]
!

doRemoveKey
    "remove selected item from keys"

    |l|

    listView withWaitCursorDo:[
        self selectedKeys do:[:key |
            (inspectedObject includesKey:key) ifTrue:[
                inspectedObject removeKey:key
            ]
        ].

        keys := nil.
        selectionIndex := selectedLine := nil.
        inspectedObject changed.
    ].

    l := listView firstLineShown.
    self reinspect. "force list update"
    listView scrollToLine:l.
!

doShowAliases
    hideAliases := false.
    self reinspect
!

doShowClassVars
    hideClassVars := false.
    self reinspect
!

doShowClasses
    hideClasses := false.
    self reinspect
!

doShowColorsAndImages
    hideColorsAndImages := false.
    self reinspect
!

doShowLiteralValues
    hideLiteralValues := false.
    self reinspect
!

doShowNilValues
    hideNilValues := false.
    self reinspect
!

doShowSignalInstances
    hideSignalInstances := false.
    self reinspect
!

doShowUnloadedClasses
    hideUnloadedClasses := false.
    self reinspect
!

showKeyReferences
    "show users of selected key (i.e. global).
     Only useful when inspecting smalltalk"

    |key|

    key := self selectedKey.
    key notNil ifTrue:[
        self topView withWaitCursorDo:[
            UserPreferences systemBrowserClass browseReferendsOf:(key asSymbol)
        ].
    ]
!

showReferencesToKey
    self selectedKey class hasImmediateInstances ifTrue:[
        ^ self warn:'Sorry - cannot show references to immediate objects'
    ].
    ObjectMemory displayRefChainTo:(self selectedKey)
! !

!DictionaryInspectorView methodsFor:'private'!

allNumericKeys
    inspectedObject keysDo:[:k | k isNumber ifFalse:[^ false]].
    ^ true

    "Created: / 10-05-2011 / 08:05:45 / cg"
!

baseInspectedObjectClass

    (inspectedObject isMemberOf:Dictionary) ifFalse:[
        (inspectedObject class inheritsFrom:Dictionary) ifFalse:[
            "this is true for e.g. MethodDictionary"
            ^ Object
        ]
    ].
    ^ Dictionary

    "Modified: / 23.7.1999 / 10:39:11 / stefan"


!

defaultLabel
    ^ 'Keys'

    "Created: 28.6.1996 / 19:46:51 / cg"
!

indexList
    "return a list of indexes to show in the selectionList.
     Set hasMore to true, if a '...' entry should be added."

    |sortBlockForKeys allShown|

    (inspectedObject isNameSpace 
    or:[inspectedObject isSharedPool]) ifTrue:[
        ^ self indexListForNameSpace.
    ].

    allShown := inspectedObject size <= nShown.

    inspectedObject isOrdered ifFalse:[
        (allShown and:[self allNumericKeys]) ifTrue:[
            sortBlockForKeys := [:a :b | a < b].
        ] ifFalse:[
            sortBlockForKeys := [:a :b | a displayString < b displayString].
        ].
    ].
    
    "/ do not use 'inspectedObject keys',
    "/ since Sets cannot hold nils (which are now valid keys)
    allShown ifFalse:[
        inspectedObject isOrdered ifFalse:[
            keys := (SortedCollection new:nShown) sortBlock:sortBlockForKeys.
        ] ifTrue:[
            keys := OrderedCollection new:nShown
        ].
        
        inspectedObject keysDo:[:k | 
            keys add:k.
            keys size >= nShown ifTrue:[ 
                hasMore := true.
                ^ keys
            ].
        ].
    ].

    keys := OrderedCollection new.
    inspectedObject keysDo:[:k | keys add:k].
    inspectedObject isOrdered ifFalse:[
        keys := keys asSortedCollection:sortBlockForKeys.
    ].    
    ^ keys

    "Modified: / 10-05-2011 / 08:14:59 / cg"
!

indexListForNameSpace
    "return a list of indexes to show in the selectionList.
     Set hasMore to true, if a '...' entry should be added."

    keys := SortedCollection new:1000.

    inspectedObject keysDo:[:k |
        |hidden i o|

        hidden := false.
        hideClassVars == true ifTrue:[
            (i := k lastIndexOf:$:) ~~ 0 ifTrue:[
                (i > 1 and:[(k at:i-1) ~~ $:]) ifTrue:[
                    hidden := true
                ].
            ].
        ].
        (hidden not and:[hideNilValues == true]) ifTrue:[
            o isNil ifTrue:[ 
                o := inspectedObject at:k ifAbsent:nil. 
                o isNil ifTrue:[
                    hidden := true
                ].
            ].
        ].
        (hidden not and:[hideClasses == true]) ifTrue:[
            o isNil ifTrue:[ o := inspectedObject at:k ifAbsent:nil ].
            o isBehavior ifTrue:[
                inspectedObject == Smalltalk ifTrue:[
                    o name == k ifTrue:[
                        hidden := true
                    ]
                ] ifFalse:[
                    o nameWithoutNameSpacePrefix = k ifTrue:[
                        hidden := true
                    ]
                ]
            ].
        ].
        (hidden not and:[hideAliases == true]) ifTrue:[
            o isNil ifTrue:[ o := inspectedObject at:k ifAbsent:nil ].
            o isBehavior ifTrue:[
                inspectedObject == Smalltalk ifTrue:[
                    o name ~~ k ifTrue:[
                        hidden := true
                    ]
                ] ifFalse:[
                    o nameWithoutNameSpacePrefix ~= k ifTrue:[
                        hidden := true
                    ].
                ].
            ].
        ].
        (hidden not and:[hideLiteralValues == true]) ifTrue:[
self breakPoint:#cg.
            o isNil ifTrue:[ o := inspectedObject at:k ifAbsent:nil ].
            o isLiteral ifTrue:[
                hidden := true
            ].
        ].
        (hidden not and:[hideColorsAndImages == true]) ifTrue:[
            o isNil ifTrue:[ o := inspectedObject at:k ifAbsent:nil ].
            (o isColor or:[o isImageOrForm or:[o class == Cursor]]) ifTrue:[
                hidden := true
            ].
        ].
        (hidden not and:[hideSignalInstances == true]) ifTrue:[
            o isNil ifTrue:[ o := inspectedObject at:k ifAbsent:nil ].
            (o isException or:[o isKindOf:Signal]) ifTrue:[
                hidden := true
            ].
        ].

        hidden ifFalse:[keys add:k]
    ].
    ^ keys
!

indexedFieldList 
    "return a list of indexed-variable names to show in the selectionList.
     Set hasMore to true, if a '...' entry should be added."

    |indexList keyList|

    indexList := self indexList.
    keyList := indexList 
        collect:[:k | 
            k isSymbol 
                ifTrue:[ k printString] 
                ifFalse:[
                    k isInteger 
                        ifTrue:[ self basicDisplayStringForValue:k ]
                        ifFalse:[ k displayString ]
                ]
        ].

    sortOrder == SortOrderAlphabetical ifTrue:[
        keyList sort:[:a :b | a string < b string].
    ].
    ^ keyList
        keysAndValuesCollect:[:idx :nm |
            self listEntryForName:nm value:(self indexedValueAtKey:(indexList at:idx))
        ].
    "/ ^ keyList

    "Modified: / 26-09-2012 / 13:22:08 / cg"
    "Modified: / 25-07-2014 / 09:44:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indexedValueAtKey:key
    object isWeakCollection ifTrue:[
        "keys may vanish"
        ^ object at:key ifAbsent:[].
    ].
    ^ object at:key
!

instVarIndexForLine:lineNr
    "helper - return the index for a named instVar;
     nil, if self or a keyed instvar is selected."

    (inspectedObject isNameSpace or:[inspectedObject isSharedPool]) ifTrue:[
        ^ nil
    ].
    ^ super instVarIndexForLine:lineNr
!

keyIndexForLine:lineNr
    "helper - return the index of the key-list"

    |firstRealIndex idx line|

    (inspectedObject isNameSpace or:[inspectedObject isSharedPool]) ifTrue:[
        (self hasSelfEntry
        and:[lineNr == 1 or:[lineNr isNil]]) ifTrue:[
            ^ nil "/ self selected
        ].
        firstRealIndex := 1.
        idx := lineNr.
        [line := self listEntryAt:firstRealIndex. 
         (line startsWith:'-') and:[line size < 2 or:[line second isDigit not]]] whileTrue:[
            firstRealIndex := firstRealIndex + 1.
            idx := idx - 1.
        ].

        ^ idx   
    ].
    ^ super keyIndexForLine:lineNr

    "Modified: / 16-05-2012 / 17:56:01 / cg"
!

namedFieldList 
    "return a list of instVar names to show in the selectionList."

    (inspectedObject isNameSpace or:[inspectedObject isSharedPool]) ifTrue:[
        "/ empty ...
        ^ OrderedCollection new
    ].
    ^ super namedFieldList
!

numIndexedFields
    ^ inspectedObject size
!

release 
    "release inspected object"

    keys := nil.
    super release
!

selectedKey
    "selected item's key or nil. But only if exactly one item is selected"

    |selIdx idx|

    selIdx := self theSingleSelectionIndex.
    selIdx notNil ifTrue:[
        idx := self keyIndexForLine:selIdx.
        idx notNil ifTrue:[
            ^ (keys at:idx)
        ].
    ].
    ^ nil.
!

selectedKeys
    "selected keys or empty"

    ^ (listView selection ? #()) 
        collect:[:eachSelectionIndex |
            |idx|

            idx := self keyIndexForLine:eachSelectionIndex.
            idx notNil 
                ifTrue:[ (keys at:idx) ]
                ifFalse:[ nil ]
        ]
        thenSelect:[:each | each notNil].

    "Modified: / 01-07-2010 / 10:54:31 / cg"
!

selection:lineNrCollection
    "redefined because of multiselect"

    lineNrCollection isEmptyOrNil ifTrue:[
        self showSelection:nil
    ] ifFalse:[
        self showSelection:lineNrCollection first
    ].
! !

!DictionaryInspectorView methodsFor:'queries'!

selectedKeyName
    | key |

    "/ Issue #125. Keys of a dictionary could be arbitrary objects and
    "/ their print strings may contain spaces. Therefore, the super 
    "/ implementation won't work properly as it cuts-off the string after
    "/ a space (in belief that after first space there's always a inspector-
    "/ added value detail.
    "/
    "/ See https://swing.fit.cvut.cz/projects/stx-jv/ticket/125

    key := self selectedKey.
    key notNil ifTrue:[ ^ key printString ].
    ^ super selectedKeyName

    "Created: / 12-03-2017 / 20:34:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DictionaryInspectorView methodsFor:'user interaction'!

indexedValueAtIndex:idx
    |key|

    key := keys at:idx ifAbsent:[^ nil].
    ^ inspectedObject at:key ifAbsent:nil.
!

indexedValueAtIndex:idx put:newValue
    |key|

    key := keys at:idx.
    inspectedObject at:key put:newValue.
! !

!DictionaryInspectorView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

