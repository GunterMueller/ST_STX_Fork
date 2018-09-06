"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

StandardSystemView subclass:#MemoryUsageView
	instanceVariableNames:'rawInfo info list sortBlock titleLabel prevRawInfo
		autoUpdateProcess autoUpdateInterval filter infoLabel'
	classVariableNames:'LastSearchString'
	poolDictionaries:''
	category:'Monitors-ST/X'
!

Object subclass:#StatisticEntry
	instanceVariableNames:'classNameOrSymbol overallByteSize minByteSize maxByteSize
		averageSize instanceCount instanceAllocationRate
		memoryAllocationRate'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MemoryUsageView
!

!MemoryUsageView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    this view shows an overview over the memory usage of the system.
    usage:
        MemoryUsageView new open

    Since scanning all memory takes some time, this is not done
    automatically, but upon request. See the middlebuttonmenu-'update'
    function.

    This is a very old application - definitely needs some pimping to look better...
    ... any maybe a nice menu, graphical display etc.
"
! !

!MemoryUsageView class methodsFor:'startup'!

isVisualStartable
    ^ true

    "Created: / 10.8.1998 / 16:02:59 / cg"
! !

!MemoryUsageView methodsFor:'auto update'!

autoUpdate
    self pushEvent:#update

    "Created: / 05-05-2011 / 17:20:52 / cg"
!

autoUpdateInterval
    ^ autoUpdateInterval ? 30 seconds

    "Created: / 05-05-2011 / 17:20:49 / cg"
!

autoUpdateLoop
    [true] whileTrue:[
        self autoUpdate.
        Delay waitFor:self autoUpdateInterval
    ].

    "Created: / 05-05-2011 / 17:20:44 / cg"
!

openAutoUpdateIntervalDialog
    |s|

    s := Dialog request:'Update interval [smh]:' initialAnswer:self autoUpdateInterval printString.
    s isEmptyOrNil ifTrue:[^ self].

    autoUpdateInterval := TimeDuration readFrom:s.

    "Created: / 05-05-2011 / 17:24:48 / cg"
!

startAutoUpdateProcess
    autoUpdateProcess notNil ifTrue:[
        self stopAutoUpdateProcess.
    ].
    autoUpdateProcess :=
        [
            self autoUpdateLoop
        ] fork

    "Created: / 05-05-2011 / 17:19:00 / cg"
!

stopAutoUpdateProcess
    |p|

    (p := autoUpdateProcess) notNil ifTrue:[
        autoUpdateProcess := nil.
        p terminate.
    ].

    "Created: / 05-05-2011 / 17:19:03 / cg"
! !

!MemoryUsageView methodsFor:'initialization'!

initialize
    |helpView headLine|

    super initialize.
    self label:'Memory Usage'.

    headLine := ' Class' paddedTo:47 with:Character space.
    headLine := headLine , '  # of Insts       Bytes   Avg sz   Max sz   %Mem  %Accum. +Insts    +Bytes'.

    titleLabel := Label in:self.
    titleLabel origin:(0.0 @ 0.0) corner:(1.0 @ titleLabel preferredHeight).
    titleLabel borderWidth:0.
    titleLabel label:headLine.
    titleLabel adjust:#left.

    infoLabel := Label in:self.
    infoLabel geometryLayout:(LayoutFrame 
                                leftFraction:0 offset:0
                                rightFraction:1.0 offset:0
                                topFraction:1.0 offset:infoLabel preferredHeight negated
                                bottomFraction:1.0 offset:0).
    infoLabel borderWidth:0.
    infoLabel label:''.
    infoLabel adjust:#left.
    infoLabel level:-1.

    helpView := ScrollableView for:SelectionInListView in:self.
    helpView geometryLayout:(LayoutFrame 
                                leftFraction:0 offset:0
                                rightFraction:1.0 offset:0
                                topFraction:0 offset:titleLabel height
                                bottomFraction:1.0 offset:infoLabel height negated).

    list := helpView scrolledView.

    titleLabel origin:(list originRelativeTo:self) x @ 0.0.

    list font:(EditTextView defaultFont).
    titleLabel font:(EditTextView defaultFont).
    list menuHolder:self; menuPerformer:self; menuMessage:#usageMenu.

    self extent:((list font widthOf:headLine) + ( device horizontalPixelPerMillimeter * 15) rounded) @ self height.

    "
     MemoryUsageView open
    "

    "Modified: / 08-05-2011 / 12:45:06 / cg"
    "Modified: / 26-11-2014 / 16:00:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    self stopAutoUpdateProcess.
    super release.

    "Created: / 05-05-2011 / 17:26:24 / cg"
! !

!MemoryUsageView methodsFor:'menu-actions'!

browseClass
    |class|

    (class := self selectedClass) isNil ifTrue:[ ^ self ].
    class browserClass openInClass:class.

    "Modified: / 11-05-2011 / 14:34:38 / cg"
!

collectGarbageAndUpdate
    self withWaitCursorDo:[
	ObjectMemory tenure.
	ObjectMemory compressingGarbageCollect.
    ].
    self update.

    "Created: 14.10.1997 / 21:36:38 / cg"
    "Modified: 14.10.1997 / 21:41:11 / cg"
!

displayGlobalRefChainsToInsts
    |class|

    (class := self selectedClassOrClassSymbol) isNil ifTrue:[ ^ self ].

    self withCursor:(Cursor questionMark) do:[
        |insts numInsts limit answer tooMany|

        "
         special kludge
        "
        class isSymbol ifTrue:[
            class == #NameSpace ifFalse:[
                self information:'classes are directly refered to by Smalltalk'.
                ^ self.
            ].
            class := (Smalltalk at:class) class.
            insts := class allSubInstances.
            insts remove:class soleInstance ifAbsent:nil
        ] ifFalse:[
            tooMany := false.
            Error handle:[:ex |
                tooMany := true.
            ] do:[
                insts := class allInstances.
                numInsts := insts size
            ].
            tooMany ifTrue:[
                numInsts := class instanceCount.
            ].
        ].
        numInsts > 10 ifTrue:[
            answer := Dialog 
                request:('There are ' , numInsts printString , ' instances.\Do you really want to follow them all ?\\(Give number to follow or cancel)' withCRs)
                initialAnswer:(numInsts min:10) printString.

            limit := Integer readFrom:answer onError:nil.
            limit isNil ifTrue:[^ self].
            insts isNil ifTrue:[
                [:exit |
                    insts := OrderedCollection new.
                    class allInstancesDo:[:inst |
                        insts add:inst.
                        insts size == limit ifTrue:[ exit value:nil ].
                    ]
                ] valueWithExit.
            ] ifFalse:[
                insts := (insts asArray copyTo:limit)
            ]
        ].
        insts := insts asArray.
        ObjectMemory displayRefChainToAny:insts limitNumberOfSearchedReferences:(limit ? 1000).
    ]

    "Created: / 03-02-1998 / 00:03:22 / cg"
    "Modified: / 11-05-2011 / 14:33:04 / cg"
    "Modified: / 16-06-2011 / 16:14:40 / az"
!

inspectInstances
    self withCursor:(Cursor questionMark) do:[
        self withInstancesOfSelectedClassDo:[:insts |
            |answer|

            answer := true.
            insts size > 500 ifTrue:[
                answer := OptionBox
                            request:('there are ' , insts size printString , ' instances.\\Do you really want to see them all ?' withCRs)
                            buttonLabels:#('No' 'Show me any 500' 'Yes' )
                            values:#( false #some true )
                            default:true.
            ].
            answer ~~ false ifTrue:[
                answer == #some ifTrue:[
                    (insts copyTo:500) inspect.
                ] ifFalse:[
                    insts inspect
                ]
            ].
        ]
    ]

    "Modified: / 11-05-2011 / 14:36:44 / cg"
    "Modified: / 16-06-2011 / 15:57:52 / az"
!

inspectInstancesWithSearch
    |filterString filterBlock|

    list selection isNil ifTrue:[^ self].

    filterString := LastSearchString ? '[:inst | "<some condition for inst>" ]'.
    [filterBlock isNil] whileTrue:[
        filterString := Dialog request:'filter block:' initialAnswer:filterString.
        filterString size == 0 ifTrue:[^ self].

        filterBlock := Compiler evaluate:filterString.
        filterBlock isBlock ifFalse:[
            self information:'bad syntax in block'.
            filterBlock := nil.
        ].
    ].

    LastSearchString := filterString.

    self withCursor:(Cursor questionMark) do:[
        self withInstancesOfSelectedClassDo:[:insts |
            |filteredInsts|

            filteredInsts := insts select:filterBlock.
            filteredInsts size > 500 ifTrue:[
                (self confirm:'there are ' , filteredInsts size printString , ' instances.\\Do you really want to see them all ?' withCRs)
                ifFalse:[^ self]
            ].
            filteredInsts inspect
        ]
    ]

    "Modified: / 11-05-2011 / 14:38:12 / cg"
!

inspectLargestInstances
    |tenBiggest smallestOfThe10|

    tenBiggest := SortedCollection new:20.
    tenBiggest sortBlock:[:a :b | a size > b size].
    smallestOfThe10 := nil.

    self withCursor:(Cursor questionMark) do:[
        self withInstancesOfSelectedClassDo:[:insts |
            insts do:[:each |
                smallestOfThe10 isNil ifTrue:[
                    smallestOfThe10 := each size.
                    tenBiggest add:each.
                ] ifFalse:[
                    each basicSize > smallestOfThe10 ifTrue:[
                        tenBiggest add:each.
                        tenBiggest size > 10 ifTrue:[
                            tenBiggest removeLast.
                            smallestOfThe10 := tenBiggest last size.
                        ]
                    ]
                ].
            ].
            tenBiggest inspect
        ]
    ]

    "Modified: / 11-05-2011 / 14:36:44 / cg"
    "Modified: / 16-06-2011 / 15:57:52 / az"
!

inspectOwners
    |class inspector|

    (class := self selectedClass) isNil ifTrue:[ ^ self ].

    self withCursor:(Cursor questionMark) do:[
        |owners dict|

        owners := (ObjectMemory whoReferencesInstancesOf:class).
        owners isEmptyOrNil ifTrue:[
            self information:'No owners found - next GC should remove it'.
            ^ self
        ].
        owners := owners asOrderedCollection.
        owners size > 500 ifTrue:[
            (self confirm:'there are ' , owners size printString , ' owners.\\Do you really want to see them all ?' withCRs)
            ifFalse:[^ self]
        ].
        dict := IdentityDictionary new.
        owners do:[:owner |
            |set names oClass s nMore|

            "
             skip weakArrays ... (they don't count)
            "
            (owner isMemberOf:WeakArray) ifFalse:[
                nMore := nil.    
                set := Set new.
                owner == Smalltalk ifTrue:[
                    owner keysAndValuesDo:[:key :val |
                        (val isMemberOf:class) ifTrue:[
                            set add:key
                        ]
                    ]
                ] ifFalse:[
                    names := owner class allInstVarNames.
                    oClass := owner class.
                    1 to:oClass instSize do:[:i |
                        ((owner instVarAt:i) isMemberOf:class) ifTrue:[
                            set add:(names at:i).
                        ].
                    ].
                    oClass isVariable ifTrue:[
                        oClass isPointers ifTrue:[
                            1 to:owner basicSize do:[:i |
                                ((owner basicAt:i) isMemberOf:class) ifTrue:[
                                    nMore isNil ifTrue:[    
                                        set add:i.
                                        set size > 500 ifTrue:[
                                            nMore := 0.
                                        ]
                                    ] ifFalse:[
                                        nMore := nMore + 1.
                                    ]
                                ]
                            ]
                        ]
                    ].
                ].
                "
                 put a describing string into the dictionary
                "
                s := WriteStream on:''.    
                s nextPutAll:'references in: '.
                set do:[:name | 
                     name isString ifTrue:[
                         s nextPutAll:name; nextPutAll:' '
                     ] ifFalse:[
                         s nextPutAll:'[';  nextPutAll:name printString;  nextPutAll:'] '
                     ]
                ].
                nMore notNil ifTrue:[
                    s nextPutAll:'... (', nMore printString,' more)'
                ].
                dict at:owner put:(s contents).
"/                            dict at:owner put:set
            ]
        ].
        inspector := DictionaryInspectorView openOn:dict.
        inspector listView doubleClickAction:[:lineNr | inspector doInspectKey].
    ]

    "Modified: / 11-05-2011 / 14:39:30 / cg"
!

nilInstances
    |class|

    (class := self selectedClass) isNil ifTrue:[ ^ self ].

    self withCursor:(Cursor questionMark) do:[
        |insts|

        insts := class allInstances.
        insts notEmpty ifTrue:[    
            (self confirm:'there are ' , insts size printString , ' instances.\\Do you really want to nil them all ?' withCRs)
            ifTrue:[
                insts do:[:each |
                    each becomeNil
                ]
            ]
        ].
    ]

    "Modified: / 11-05-2011 / 14:39:33 / cg"
!

openInheritanceFilterDialog
    "only show instances which inherit from a set of classes"

    |names classes classToCheck|

    names := Dialog requestClassName:'Filter Instances by Inheritance:' initialAnswer:''.
    names isEmptyOrNil ifTrue:[^ self].

    classes := (names asCollectionOfSubstringsSeparatedByAny:' ;,')
                collect:[:each | Smalltalk classNamed:each ]
                thenSelect:[:cls |cls notNil].
    classes isEmpty ifTrue:[^ self].

    classes size == 1 ifTrue:[
        classToCheck := classes first.
        filter := [:inst :class | class includesBehavior:classToCheck ].
    ] ifFalse:[
        classes := classes asArray.
        filter := [:inst :class | classes contains:[:cls | class includesBehavior:cls]].
    ].
    prevRawInfo := nil.
    self update.

    infoLabel label:'Filtered by Inheritance: ',names.

    "Created: / 08-05-2011 / 12:18:21 / cg"
!

openNamespaceFilterDialog
    "only show instances for classes from a number of namespaces"

    |names nameSpaces ns|

    names := Dialog requestNameSpace:'Filter Instances by Namespace:' initialAnswer:''.
    names isEmptyOrNil ifTrue:[^ self].

    nameSpaces := (names asCollectionOfSubstringsSeparatedByAny:' ;,')
                collect:[:each | Smalltalk classNamed:each ]
                thenSelect:[:cls | cls notNil].
    nameSpaces isEmpty ifTrue:[^ self].

    nameSpaces size == 1 ifTrue:[
        ns := nameSpaces first.
        filter := [:inst :class | class topNameSpace == ns ].
    ] ifFalse:[
        nameSpaces := nameSpaces asArray.
        filter := [:inst :class | nameSpaces includesIdentical:(class topNameSpace) ].
    ].

    prevRawInfo := nil.
    self update.

    infoLabel label:'Filtered by Namespace: ',names.

    "Created: / 08-05-2011 / 12:18:21 / cg"
!

removeFilter
    filter := nil.
    prevRawInfo := nil.
    self update.

    infoLabel label:'No Filter.'.

    "Created: / 08-05-2011 / 12:16:43 / cg"
!

showSizeHistogram
    |class|

    (class := self selectedClass) isNil ifTrue:[ ^ self ].
    self showSizeHistogrammForClass:class
!

showSizeHistogrammForClass:class
    |sizeBag minSize maxSize numBags|

    numBags := 20.

    sizeBag := Bag new.
    class allInstancesDo:[:i |
        |sz|

        sz := i size.
        sizeBag add:sz.
        minSize := (minSize ? sz) min:sz.
        maxSize := (maxSize ? sz) max:sz.
    ].

    sizeBag isEmpty ifTrue:[
        Dialog warn:'No instances'.
        ^ self.
    ].  
    sizeBag inspect.
!

update
    self updateInfo.
    self updateDisplay
!

usageMenu
    <resource: #programMenu>

    |m|

    m := PopUpMenu
                itemList:#(
                     ('Filter by Namespace...'          openNamespaceFilterDialog               )
                     ('Filter by Inheritance...'        openInheritanceFilterDialog               )
                     ('No Filter'                       removeFilter                            )
                     ('-')
                     ('Sort by Class Name'              sortByClass                             )
                     ('Sort by Classes Basename'        sortByClassNameWithoutPrefix            )
                     ('Sort by Inst Count'              sortByInstCount                         )
                     ('Sort by Memory Usage'            sortByMemoryUsage                       )
                     ('Sort by Average Size'            sortByAverageSize                       )
                     ('Sort by Maximum Size'            sortByMaxSize                           )
                     ('Sort by Inst Allocation Rate'    sortByInstanceAllocationRate            )
                     ('Sort by Byte Allocation Rate'    sortByMemoryAllocationRate              )
                     ('-')
                     ('Inspect Instances'               inspectInstances                        )
                     ('Inspect Largest Instances'       inspectLargestInstances                        )
                     ('Inspect with Search'             inspectInstancesWithSearch              )
                     ('Inspect Owners'                  inspectOwners                           )
                     ('-')
                     ('Ref Chains'                      displayGlobalRefChainsToInsts           )
                     ('Clear (nil) Instances'           nilInstances                            )
                     ('-')
                     ('Browse Class'                    browseClass                             )
                     ('Size Histogram'                  showSizeHistogram                             )
                     ('-')
                     ('Collect Garbage & Update'        collectGarbageAndUpdate                 )
                     ('Start Autoupdate'                startAutoUpdateProcess                  )
                     ('Autoupdate Interval...'          openAutoUpdateIntervalDialog            )
                     ('Update'                          update                                  )
                 )
                resources:resources.

    (list hasSelection not or:[list selection < 3]) ifTrue:[
        m disableAll:#(inspectInstances inspectInstancesWithSearch
                       inspectOwners 
                       displayGlobalRefChainsToInsts
                       nilInstances browseClass).
    ].
    autoUpdateProcess notNil ifTrue:[
        m labelAt:#startAutoUpdateProcess put:'Stop Autoupdate'.
        m selectorAt:#startAutoUpdateProcess put:#stopAutoUpdateProcess
    ].

    filter isNil ifTrue:[
        m disableAll:#(removeFilter)
    ].
    ^ m

    "Modified: / 08-05-2011 / 12:38:47 / cg"
!

withInstancesOfSelectedClassDo:aBlock
    |class insts|

    (class := self selectedClassOrClassSymbol) isNil ifTrue:[ ^ self ].

    "
     special kludge
    "
    class isSymbol ifTrue:[
        class == #NameSpace ifTrue:[
            class := (Smalltalk at:class) class.
            insts := class allSubInstances.
            insts remove:class soleInstance ifAbsent:nil
        ] ifFalse:[
            class == #Metaclass ifTrue:[
                insts := Metaclass allSubInstances.
            ] ifFalse:[
                class == #Class ifTrue:[
                    insts := Class allSubInstances.
                ] ifFalse:[
                    ^ self.
                ].
            ]
        ].
        aBlock value:insts
    ] ifFalse:[
        aBlock value:(class allInstances).
    ].

    "Created: / 11-05-2011 / 14:36:00 / cg"
! !

!MemoryUsageView methodsFor:'menu-sorting'!

sortByAverageSize
    self label:'Memory usage; by average size'.

    sortBlock := [:a :b | 
        |n1 n2 m1 m2|

       n1 := a averageSize.
       n2 := b averageSize.
       n1 > n2 
            or:[n1 == n2 
                and:[a classNameOrSymbol displayString < b classNameOrSymbol displayString]]
    ].
    self updateDisplay

    "Modified: / 05-05-2011 / 16:11:24 / cg"
!

sortByClass
    self label:'Memory usage; by class'.

    sortBlock := [:a :b | 
        |c1 c2 s1 s2|

        c1 := a classNameOrSymbol.
        c2 := b classNameOrSymbol.

        s1 := c1 isBehavior ifTrue:[ c1 name] ifFalse:[ c1 displayString ].
        s2 := c2 isBehavior ifTrue:[ c2 name ] ifFalse:[ c2 displayString ].
        s1 < s2
    ].
    self updateDisplay

    "Modified: / 05-05-2011 / 16:11:53 / cg"
!

sortByClassNameWithoutPrefix
    self label:'Memory usage; by className without prefix'.

    sortBlock := [:a :b | 
        |c1 c2 s1 s2|

        c1 := a classNameOrSymbol.
        c2 := b classNameOrSymbol.

        s1 := c1 isBehavior ifTrue:[ c1 nameWithoutPrefix ] ifFalse:[ c1 displayString ].
        s2 := c2 isBehavior ifTrue:[ c2 nameWithoutPrefix ] ifFalse:[ c2 displayString ].
        s1 < s2
    ].
    self updateDisplay

    "Modified: / 05-05-2011 / 16:12:10 / cg"
!

sortByInstCount
    self label:'Memory usage; by instance count'.

    sortBlock := [:a :b | 
        |n1 n2|
        n1 := a instanceCount.
        n2 := b instanceCount.
        n1 > n2 
        or:[n1 == n2
            and:[(a classNameOrSymbol) displayString < (b classNameOrSymbol) displayString]]
    ].
    self updateDisplay

    "Modified: / 05-05-2011 / 16:47:26 / cg"
!

sortByInstanceAllocationRate
    self label:'Memory usage; by inst allocation rate'.

    sortBlock := [:a :b | 
        |n1 n2 m1 m2|

       n1 := a instanceAllocationRate.
       n2 := b instanceAllocationRate.
       n1 > n2 
            or:[n1 == n2 
                and:[a classNameOrSymbol displayString < b classNameOrSymbol displayString]]
    ].
    self updateDisplay

    "Created: / 05-05-2011 / 16:14:56 / cg"
!

sortByMaxSize
    self label:'Memory usage; by maximum size'.

    sortBlock := [:a :b | 
        |n1 n2 m1 m2|

         n1 := a maxByteSize.
         n2 := b maxByteSize.
         n1 > n2 
         or:[n1 == n2
             and:[(a classNameOrSymbol) displayString < (b classNameOrSymbol) displayString]]
    ].
    self updateDisplay

    "Modified: / 05-05-2011 / 16:13:20 / cg"
!

sortByMemoryAllocationRate
    self label:'Memory usage; by inst allocation rate'.

    sortBlock := [:a :b | 
        |n1 n2 m1 m2|

       n1 := a memoryAllocationRate.
       n2 := b memoryAllocationRate.
       n1 > n2 
            or:[n1 == n2 
                and:[a classNameOrSymbol displayString < b classNameOrSymbol displayString]]
    ].
    self updateDisplay

    "Created: / 05-05-2011 / 16:15:17 / cg"
!

sortByMemoryUsage
    self label:'Memory usage; by memory usage'.

    sortBlock := [:a :b | 
        |n1 n2|

        n1 := a overallByteSize.
        n2 := b overallByteSize.
        n1 > n2 
        or:[n1 == n2
            and:[(a classNameOrSymbol) displayString < (b classNameOrSymbol) displayString]]
    ].
    self updateDisplay

    "Modified: / 05-05-2011 / 16:13:58 / cg"
! !

!MemoryUsageView methodsFor:'private'!

selectedClass
    |classOrSymbol|

    (classOrSymbol := self selectedClassOrClassSymbol) notNil ifTrue:[
        classOrSymbol isSymbol ifFalse:[
            ^ classOrSymbol
        ]
    ].
    ^ nil
!

selectedClassOrClassSymbol
    |selIdx|

    (selIdx := list selection) notNil ifTrue:[
        ^ (info at:selIdx) classNameOrSymbol.
    ].
    ^ nil
!

updateDisplay
    "update the displayed list"

    |nameLen countLen bytesUsedSize avgSizeLen maxSizeLen accumMemoryUseLen|

    rawInfo isNil ifTrue:[^ self].

    nameLen := 50.
    countLen := 9.
    bytesUsedSize := 12.
    avgSizeLen := 10.
    maxSizeLen := 8.
    accumMemoryUseLen := 7.

    windowGroup withCursor:Cursor wait do:[
        |classNames counts sumSizes maxSizes percents avgSizes 
         l line allMemory 
         overAllCount overAllAvgSize overAllMaxSize 
         lastP sumPercent|

        prevRawInfo notNil ifTrue:[
            rawInfo keysAndValuesDo:[:key :entry |
                |prevEntry deltaInstCount deltaInstBytes prevInstCount prevInstBytes| 

                prevEntry := prevRawInfo at:key ifAbsent:nil.
                prevInstCount :=  prevEntry notNil ifTrue:[prevEntry instanceCount] ifFalse:[0].
                prevInstBytes :=  prevEntry notNil ifTrue:[prevEntry overallByteSize] ifFalse:0.
                deltaInstCount := entry instanceCount - prevInstCount.
                deltaInstBytes := entry overallByteSize - prevInstBytes.

                entry instanceAllocationRate:deltaInstCount.
                entry memoryAllocationRate:deltaInstBytes.
            ].
        ].
        
        info := (OrderedCollection withAll:rawInfo) sort:sortBlock.

        sumSizes := info collect:[:infoEntry | infoEntry overallByteSize ].
        allMemory := sumSizes sum.
        percents := sumSizes collect:[:sz | (sz asFloat / allMemory * 100)].
        sumPercent := 0.

        overAllMaxSize := overAllCount := 0.

        l := OrderedCollection new.
        info doWithIndex:[:entry :i |
            |line avgSz avgSzString maxSz instCount percent allocRate memRate s1 s2|

            maxSz := entry maxByteSize.
            avgSz := entry averageSize asFixedPoint:1.
            avgSz = maxSz ifTrue:[
                avgSzString := avgSz asInteger printString , '  '.
            ] ifFalse:[
                avgSzString := avgSz printString.
            ].
            instCount := entry instanceCount.

            line := entry classNameStringInList printStringPaddedTo:nameLen.
            line := line contractTo:nameLen.

            line := line , (instCount printStringLeftPaddedTo:countLen).
            line := line , (entry overallByteSize printStringLeftPaddedTo:bytesUsedSize).
            line := line , (avgSzString leftPaddedTo:avgSizeLen).
            line := line , (maxSz printStringLeftPaddedTo:maxSizeLen).
            percent := (percents at:i).
"/ percent < 0.0 ifTrue:[self halt].
            line := line , ((percent asFixedPoint:1) printStringLeftPaddedTo:accumMemoryUseLen).
            lastP := sumPercent := ((sumPercent + percent) min:100.0).
            line := line , ((sumPercent asFixedPoint:1) printStringLeftPaddedTo:accumMemoryUseLen).

            allocRate := entry instanceAllocationRate.
            memRate := entry memoryAllocationRate.
            s1 := allocRate printString.
            s2 := memRate printString.
            allocRate > 0 ifTrue:[
                s1 := s1 withColor:#red.
                s2 := s2 withColor:#red.
            ] ifFalse:[
                allocRate < 0 ifTrue:[
                    s1 := s1 withColor:(Color green darkened).
                    s2 := s2 withColor:(Color green darkened).
                ]
            ].
            line := line , (s1 leftPaddedTo:countLen).
            line := line , (s2 leftPaddedTo:bytesUsedSize).

            l add:line.

            overAllMaxSize := overAllMaxSize max:entry maxByteSize.
            overAllCount := overAllCount + instCount.
        ].
"/ (((lastP asFixedPoint:1) printStringLeftPaddedTo:7) startsWith:'99.') ifTrue:[self halt].
        "add summary line"
        overAllAvgSize := 0.
        overAllCount == 0 ifFalse:[
            overAllAvgSize := ((allMemory / overAllCount) * 10) rounded / 10.0.
        ].

        l addFirst:''.
        line := 'all objects' printStringPaddedTo:nameLen.
        line := line , (overAllCount printStringLeftPaddedTo:countLen).
        line := line , (allMemory printStringLeftPaddedTo:bytesUsedSize).
        line := line , (overAllAvgSize printStringLeftPaddedTo:avgSizeLen).
        line := line , (overAllMaxSize printStringLeftPaddedTo:maxSizeLen).
        line := line , (100.0 printStringLeftPaddedTo:accumMemoryUseLen).
        l addFirst:line.

        info addFirst:nil; addFirst:nil.

        list list:l.
    ]

    "Created: / 19-09-1995 / 15:30:47 / claus"
    "Modified: / 11-05-2011 / 14:47:52 / cg"
!

updateInfo
    "scan all memory and collect the information"

    windowGroup withCursor:Cursor questionMark do:[
        |myProcess myPriority|

        "find all objects, collect stuff in info"

        "
         this is a time consuming operation; therefore lower my priority ...
        "
        myProcess := Processor activeProcess.
        myPriority := myProcess priority.
        myProcess priority:(Processor userBackgroundPriority).
        prevRawInfo := rawInfo.

        rawInfo := IdentityDictionary new:600.

        [   |behaviorFlag|

            behaviorFlag := Behavior flagBehavior.

            ObjectMemory allObjectsDo:[:o |
                |infoEntry class flags skip|

                skip := false.

"/              o isBehavior ifTrue:[
                class := o class.
                flags := class flags.
                (flags notNil and:[flags class == SmallInteger]) ifTrue:[
                    (filter isNil or:[ filter value:o value:class ]) ifTrue:[
                        (flags bitAnd:behaviorFlag) ~~ 0 ifTrue:[
                            Error 
                                handle:[:ex |] 
                                do:[    
                                    o isObsolete ifTrue:[
                                        class := #ObsoleteClass
                                    ] ifFalse:[
                                        o isMeta ifTrue:[
                                            o isPrivate ifTrue:[
                                                class := #PrivateMetaclass
                                            ] ifFalse:[
                                                class := #Metaclass
                                            ]
                                        ] ifFalse:[
                                            o isPrivate ifTrue:[
                                                class := #PrivateClass
                                            ] ifFalse:[
                                                (o isNameSpace
                                                and:[o ~~ NameSpace
                                                and:[o ~~ Smalltalk]])
                                                ifTrue:[
                                                    class := #NameSpace
                                                ] ifFalse:[
                                                    class := #Class
                                                ]
                                            ]    
                                        ]
                                    ]
                                ]
                        ]
                    ] ifFalse:[
                        skip := true
                    ].
                ].
                skip ifFalse:[
                    infoEntry := rawInfo at:class ifAbsent:nil.
                    infoEntry isNil ifTrue:[
                        infoEntry := StatisticEntry new.
                        rawInfo at:class put:infoEntry. 
                    ].
                    infoEntry addStatisticForInstance:o class:class.
                ] ifTrue:[
"/ self halt
                ].
            ].
        ] ensure:[
            myProcess priority:myPriority.
        ].
    ]

    "Modified: / 19-09-1995 / 15:29:10 / claus"
    "Modified: / 08-05-2011 / 12:35:11 / cg"
! !

!MemoryUsageView methodsFor:'realization'!

realize
    super realize.
    titleLabel origin:(list originRelativeTo:self) x @ 0.0.
    self updateInfo.

    "/ self sortByClass.
    self sortByMemoryUsage.

    "/ self updateDisplay.

    "Modified: 14.10.1997 / 21:03:52 / cg"
! !

!MemoryUsageView::StatisticEntry methodsFor:'accessing'!

averageSize
    averageSize isNil ifTrue:[
        averageSize := overallByteSize / instanceCount
    ].
    ^ averageSize.

    "Created: / 05-05-2011 / 16:09:35 / cg"
!

classNameOrSymbol
    ^ classNameOrSymbol
!

classNameStringInList
    classNameOrSymbol == #Class ifTrue:[
        ^ '<all classes>'
    ].
    classNameOrSymbol == #Metaclass ifTrue:[
        ^ '<all metaclasses>'
    ].
    classNameOrSymbol == #PrivateMetaclass ifTrue:[
        ^ '<all private meta classes>'
    ].
    classNameOrSymbol == #PrivateClass ifTrue:[
        ^ '<all private classes>'
    ].
    classNameOrSymbol == #ObsoleteClass ifTrue:[
        ^ '<all obsolete classes>'
    ].
    classNameOrSymbol == #NameSpace ifTrue:[
        ^ '<all namespaces>'
    ].
    classNameOrSymbol isJavaClass ifTrue:[
        ^ classNameOrSymbol fullName asString copyReplaceAll:$/ with:$.
    ].
    classNameOrSymbol isObsolete ifTrue:[
        ^ classNameOrSymbol name , ' (obsolete)'
    ].
    ^ classNameOrSymbol "displayString" name

    "Created: / 05-05-2011 / 16:32:58 / cg"
!

instanceAllocationRate
    ^ instanceAllocationRate ? 0

    "Modified: / 05-05-2011 / 17:10:50 / cg"
!

instanceAllocationRate:something
    instanceAllocationRate := something.
!

instanceCount
    ^ instanceCount
!

maxByteSize
    ^ maxByteSize
!

memoryAllocationRate
    ^ memoryAllocationRate ? 0

    "Modified: / 05-05-2011 / 17:10:56 / cg"
!

memoryAllocationRate:something
    memoryAllocationRate := something.
!

minByteSize
    ^ minByteSize
!

overallByteSize
    ^ overallByteSize
! !

!MemoryUsageView::StatisticEntry methodsFor:'updating'!

addStatisticForInstance:o class:classNameOrSymbolArg
    |bytes|

    bytes := ObjectMemory sizeOf:o.
    instanceCount isNil ifTrue:[
        classNameOrSymbol := classNameOrSymbolArg.
        overallByteSize := bytes.
        minByteSize := maxByteSize := bytes.
        instanceCount := 1.
    ] ifFalse:[
        overallByteSize := overallByteSize + bytes.
        minByteSize := minByteSize min:bytes.
        maxByteSize := maxByteSize max:bytes.
        instanceCount := instanceCount + 1.
    ].
    averageSize := nil.

    "Created: / 05-05-2011 / 16:04:42 / cg"
! !

!MemoryUsageView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

