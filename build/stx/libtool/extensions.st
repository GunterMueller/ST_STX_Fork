"{ Package: 'stx:libtool' }"!

!AbstractSyntaxHighlighter class methodsFor:'api highlighting'!

formatExpression:aString in:aClass elementsInto:elementsCollection

    ^self formatExpression:aString in:aClass

    "Created: / 25-07-2010 / 08:57:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-10-2011 / 19:47:20 / cg"
! !

!AbstractSyntaxHighlighter class methodsFor:'api highlighting'!

formatMethod:aString in:aClass using:preferencesOrNil elementsInto: elements

    ^self formatMethod:aString in:aClass using:preferencesOrNil

    "Created: / 25-07-2010 / 08:58:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSyntaxHighlighter class methodsFor:'api highlighting'!

formatStatements:aString in:aClass elementsInto: aCollection
    "Format (recolor) a list of statements with optional temporaries in a given class.
     Return the text containing font changes and color information."
    ^ self formatStatements:aString in:aClass

    "Created: / 22-02-2016 / 20:59:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractTime class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    ^ #timeClassBrowserIcon
! !

!ApplicationModel methodsFor:'debugging'!

inspectorExtraAttributes
    |atts nameDict bindingDict|

    atts := super inspectorExtraAttributes.
    builder notNil ifTrue:[
        (nameDict := builder namedComponents) notNil ifTrue:[
            nameDict keysAndValuesDo:[:eachName :eachWidget |
                atts add:('-[: ',eachName,' :]') -> [ nameDict at:eachName ].
            ].
        ].
        (bindingDict := builder bindings) notNil ifTrue:[
            bindingDict keysAndValuesDo:[:eachName :eachAspect |
                atts add:('-~> ',eachName) -> [ bindingDict at:eachName ].
            ].
        ].
    ].
    ^ atts
! !

!Array methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    self size == 0 ifTrue:[
        ^ '#()'
    ].
    ^ super inspectorValueStringInListFor:anInspector
! !

!ArrayedCollection methodsFor:'inspecting'!

inspector2TabForHexDump
    "a tab, showing a hex dump; defined here, so that both byteArrays and other bulk data
     containers can define it in their inspector2Tabs methods."

    |wrapper myByteSize v genDump baseAddress|

    myByteSize := self size * self class elementByteSize.

    wrapper := Plug new.
    wrapper respondTo:#size with:[ myByteSize ].
    wrapper respondTo:#at: with:[:byteIdx | self byteAt:byteIdx ].
    wrapper respondTo:#do: with:[:aBlock | 1 to:myByteSize 
                                            do:[:i |
                                                aBlock value:(self byteAt:i) 
                                            ].
                                ].

    baseAddress := 0.
    genDump := [
                    |dump|

                    v topView withWaitCursorDo:[
                        dump := AbstractFileBrowser 
                            contentsOfBytesAsHexDump:wrapper 
                            numberOfAddressDigits:(myByteSize hexPrintString size) 
                            addressStart:baseAddress.
                        v list:dump expandTabs:false scanForNonStrings:false includesNonStrings:false.
                    ].
               ].

    v := ScrollableView for:TextView. 
    genDump value.

    v scrolledView 
        menuHolder:
            [    
                |m| 

                m := v scrolledView editMenu.
                m addLabel:'-' selector:nil.
                m addLabel:'Change Base Address...' selector:#changeBase.
                m actionAt:#changeBase 
                    put:[ 
                        |s b|

                        s := Dialog request:'Base address (hex):' initialAnswer:(baseAddress printStringRadix:16).
                        s notEmptyOrNil ifTrue:[
                            b := Integer readFrom:s radix:16 onError:nil.
                            b notNil ifTrue:[
                                baseAddress := b. genDump value
                            ].
                        ].
                    ].
                m.
            ];
        menuMessage: #value.

    ^ Tools::Inspector2Tab new
            priority: 40;
            label:'Hexdump';
            view: v;
            yourself

    "Created: / 13-02-2012 / 15:08:42 / cg"
! !

!Autoload class methodsFor:'message catching'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ #()
! !

!Bag methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ super inspectorExtraAttributes
        add:('-histogram' -> [ (self sortedCounts collect:[:e| e displayString]) asStringCollection asString ]);
        yourself
! !

!Behavior methodsFor:'misc ui support'!

iconInBrowserSymbol
    "can be redefined for a private icon in the browser (for me and my subclasses).
     The returned symbol must be a selector of the ToolbarIconLibrary.
     The browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    self isLoaded ifFalse:[
        ^ #autoloadedClassBrowserIcon
    ].
    (self isBrowserStartable) ifTrue:[
        self isVisualStartable ifTrue:[
            ^ #visualStartableClassBrowserIcon
        ].
        ^ #startableClassBrowserIcon
    ].

    "/ give ruby and other special metaclasses a chance to provide their own icon...
    ^ self class iconInBrowserSymbol

    "Created: / 20-07-2007 / 08:52:17 / cg"
! !

!Behavior methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ super inspectorExtraAttributes
        add:(self isMeta
                ifFalse:[ '-meta' -> [ self theMetaclass ] ]
                ifTrue:[ '-nonMeta' -> [ self theNonMetaclass ] ]);
        add:( '-project definition class' -> [ self theNonMetaclass projectDefinitionClass ] );
        yourself
! !

!Behavior methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    |nm|

    (nm := self name) notEmptyOrNil ifTrue:[
        ^ nm
    ].
    ^ super inspectorValueStringInListFor:anInspector
! !

!Behavior methodsFor:'queries'!

methodsCount
    "Return a number of methods or nil if number of methods
     is not known (such as for lazy-loaded classes)"

    ^ methodDictionary size

    "Created: / 25-02-2015 / 16:14:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Block methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    |d|

    d := super inspectorExtraAttributes.

    self homeMethod isNil ifTrue:[
        d
            add:'-code' -> 'no home method';
            add:'-source' -> 'no home method'.
    ] ifFalse:[
        d    
            add:'-code' -> [ String streamContents:[:s | self homeMethod decompileTo:s]];
            add:'-source' -> [ self homeMethod source].
    ].
    ^ d

    "Created: / 15-11-2011 / 14:24:10 / cg"
! !

!Boolean methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self printString
! !

!Breakpoint methodsFor:'accessing'!

icon

    ^description icon

    "Created: / 11-07-2011 / 18:21:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BreakpointDescription methodsFor:'accessing'!

icon
    "do not use abbreviations like bpnt or brp or similar;
     when I do not know the exact name, I tend to search for implementors/senders
     of '*break*' or '*disabled*'.
     I will not find anything useful and have to single step if methods are named
     cryptically."

    icon notNil ifTrue:[^ icon].

    condition isNil ifTrue:[
        state == #enabled ifTrue:[^ ToolbarIconLibrary breakpointRedEnabled].
        state == #disabled ifTrue:[^ ToolbarIconLibrary breakpointRedDisabled].
        state == #tracing ifTrue:[^ ToolbarIconLibrary tracepointBlue].
    ] ifFalse:[
        state == #enabled ifTrue:[^ ToolbarIconLibrary breakpointBlueEnabled].
        state == #disabled ifTrue:[^ ToolbarIconLibrary breakpointBlueDisabled].
    ].

    ^nil

    "Created: / 28-06-2011 / 08:29:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-01-2012 / 13:46:23 / cg"
! !

!ByteArray methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    |basePrinter|

    basePrinter := 
        [:arr :b |
            String
                streamContents:[:s |
                    arr class isWords ifTrue:[
                        arr asWordArray printOn:s base:b showRadix:true
                    ] ifFalse:[
                        arr class isLongs ifTrue:[
                            arr asLongIntegerArray printOn:s base:b showRadix:true
                        ] ifFalse:[
                            arr asByteArray printOn:s base:b showRadix:true
                        ]
                    ]
                ]
        ].

    ^ super inspectorExtraAttributes
        add:'-hexstring' -> [ self hexPrintString "WithSeparator:Character space" ];
        add:'-hexadecimal' -> [ basePrinter value:self value:16 ];
        add:'-binary' -> [ basePrinter value:self value:2 ];
        add:'-asciiString' -> [ self asString ];
        yourself
! !

!Change methodsFor:'private'!

flattenOnto: aCollection 
	aCollection add: self
! !

!Change methodsFor:'private'!

flattenedChanges
	| changes |
	changes := OrderedCollection new.
	self flattenOnto: changes.
	^changes
! !

!Change methodsFor:'accessing'!

removed

    ^(self objectAttributeAt: #removed) ? false

    "Created: / 24-10-2009 / 21:10:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Change methodsFor:'accessing'!

removed: aBoolean

    ^self objectAttributeAt: #removed put: aBoolean

    "Created: / 24-10-2009 / 21:11:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet methodsFor:'utilities'!

condenseChangesForRemoved
    "remove all changes which have been removed 
     (marked for removal by aChange removed: true)"

    |changesToRemove|

    changesToRemove := 
        self select:[:aChange | 
            aChange isCompositeChange ifTrue:[
                aChange condenseChangesForRemoved
            ].        
            aChange removed
        ].

    self condenseChanges:changesToRemove

    "Created: / 05-11-2001 / 14:21:17 / cg"
    "Modified: / 12-10-2006 / 16:51:27 / cg"
! !

!ChangeSet methodsFor:'private'!

flattenOnto: aCollection

    self do:[:change|change flattenOnto: aCollection]
! !

!ChangeSet methodsFor:'private'!

flattenedChanges
	| changes |
	changes := OrderedCollection new.
	self flattenOnto: changes.
	^changes
! !

!ChangeSet methodsFor:'inspecting'!

inspector2TabBrowser

    ^self newInspector2Tab
	label: 'Changes';
	priority: 35;
	"JV@2011-08-06: Cannot do 'UserPreferences current changeSetBrowserClass'
	 here since ChangeSetBrowser has no #on: and it is not an application model.
	 Thus, enforce Tools::ChangeSetBrowser2 here..."
	application: ((Tools::ChangeSetBrowser2 on: self) beOneColumn; yourself)

    "Modified: / 25-07-2011 / 12:22:07 / sr"
    "Modified: / 06-08-2011 / 21:22:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-09-2011 / 11:55:53 / cg"
! !

!ChangeSet methodsFor:'inspecting'!

inspector2Tabs
    ^ super inspector2Tabs , #( inspector2TabBrowser )

    "Created: / 05-07-2011 / 13:40:19 / cg"
    "Modified: / 13-02-2015 / 21:03:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Character methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    |atts|

    atts := super inspectorExtraAttributes.
    atts
        add:'-hexValue' -> [ self codePoint radixPrintStringRadix:16 ];
        add:'-string' -> [ self stringSpecies with:self ];
        add:'-utf8String' -> [ self utf8Encoded ];
        add:'-utf8' -> [ self utf8Encoded asByteArray hexPrintStringWithSeparator:Character space ].

    HTMLUtilities notNil ifTrue:[
        atts add:'-html' -> [ HTMLUtilities escapeCharacterEntities:self asString ]
    ].
    ^ atts

    "
     $a inspect
     $> inspect
     (Character value:16r3124) inspect
    "

    "Created: / 22-10-2006 / 03:52:20 / cg"
! !

!Character methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    (asciivalue <= 16r7f) ifTrue:[
        ^ self storeString,(' "16r%1 %2"' bindWith:(asciivalue hexPrintString) with:asciivalue)
    ].
    ^ self storeString,(' "%1"' bindWith:asciivalue)
! !

!CharacterArray methodsFor:'inspecting'!

inspector2TabBytes
    |bytesShown|
    
    "/ ouch - ever tried to inspect a 5Mb string?
    self size < 10000 ifTrue:[
        bytesShown := self asByteArray hexPrintStringWithSeparator:Character space
    ] ifFalse:[
        bytesShown := ((self copyTo:10000) asByteArray hexPrintStringWithSeparator:Character space),
                      Character cr,
                      '... (only the first 10000 bytes are shown)'
    ].
    
    ^ self newInspector2Tab
        label: 'Bytes';
        priority: 39;
        view: ((HVScrollableView for:EditTextView) 
                autoHideVerticalScrollBar:true;        
                contents:bytesShown; 
                yourself);
        yourself        

    "
     (String new:100000) inspect
    "

    "Created: / 17-02-2008 / 10:10:50 / janfrog"
    "Created: / 20-07-2011 / 16:36:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 07:32:57 / cg"
! !

!CharacterArray methodsFor:'inspecting'!

inspector2TabDiff
    | diffApp |

    diffApp := Tools::TextDiff2Tool new.
    diffApp labelA: 'self'; textA: self.
    diffApp labelB: 'pasted'; textB: 'Paste some text here'.
    diffApp diffView leftTextView readOnly: true.
    diffApp diffView rightTextView 
        acceptAction:[:contents |
            diffApp textBHolder value: contents asString.
            diffApp updateViews.   
        ].

    ^self newInspector2Tab
        label: 'Diff';
        priority: 33;
        application: diffApp;
        yourself

    "Created: / 27-02-2014 / 16:05:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'inspecting'!

inspector2TabHTML
    |lcString|
    
    "/ use Smalltalk >> at:, to prevent HTMLDocumentView becoming a prereq of libbasic
    (Smalltalk at:#HTMLDocumentView) notNil ifTrue:[
        lcString := self asLowercase.
        ((lcString startsWith:'<!!doctype html' ) or:[ (lcString startsWith:'<html>') ]) ifTrue:[
            ^self newInspector2Tab
                label: 'HTML';
                priority: 35;
                view: ((ScrollableView for:(Smalltalk at:#HTMLDocumentView)) setText: self; yourself);
                yourself
        ].
    ].
    "/ If nil is returned, the HTML tab is not shown...
    ^ nil

    "Created: / 17-02-2008 / 10:10:50 / janfrog"
    "Created: / 07-11-2011 / 12:35:15 / cg"
    "Modified: / 27-02-2014 / 16:08:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'inspecting'!

inspector2TabText

    ^ self newInspector2Tab
        label: 'String';
        priority: 50;
        view: ((ScrollableView for:EditTextView) 
                    autoHideVerticalScrollBar:true;        
                    contents: self; 
                    yourself);
        yourself            

    "Created: / 17-02-2008 / 10:10:50 / janfrog"
    "Modified: / 21-08-2011 / 08:02:57 / cg"
! !

!CharacterArray methodsFor:'inspecting'!

inspector2TabXMLTree
    "extra tab to be shown in an inspector2."

    |tabClass tab sub xmlInspectorClass xmlParserClass|

    (self asLowercase startsWith:'<?xml') ifFalse:[^ nil].
    
    "return an extra XML-dom tab to be used inside an inspector"

    "/ avoid generating a dependency here
    (tabClass := Smalltalk at: #'Tools::Inspector2Tab') isNil ifTrue:[^ nil].
    tab := tabClass new.

    "/ to prevent the dependcy walker from adding libtool2 to the package:
    (xmlInspectorClass := Smalltalk at:#'XML::XMLInspector') isNil ifTrue:[^ nil ].
    (xmlParserClass := Smalltalk at:#'XML::XMLParser') isNil ifTrue:[^ nil ].

    sub := xmlInspectorClass embeddableInspectorApplicationFor:(xmlParserClass parse:self).

    ^ tab
        label: 'XML DOM';
        priority: 45;
        view: sub;
        yourself
! !

!CharacterArray methodsFor:'inspecting'!

inspector2Tabs
    ^ super inspector2Tabs 
        , #( 
            inspector2TabText 
            inspector2TabBytes 
            inspector2TabDiff 
            inspector2TabHTML
            inspector2TabXMLTree
           )

    "Created: / 05-07-2011 / 13:40:27 / cg"
    "Modified: / 13-02-2015 / 21:03:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    |d|

    d := super inspectorExtraAttributes
        add:'-hex' -> [ self asByteArray hexPrintStringWithSeparator:Character space ];
        add:'-bytes' -> [ self asByteArray ];
        add:'-utf8String' -> [ self utf8Encoded ];
        add:'-utf8Bytes' -> [ self utf8Encoded asByteArray ];
        add:'-utf8' -> [ self utf8Encoded asByteArray hexPrintStringWithSeparator:Character space ];
        yourself.

    HTMLUtilities notNil ifTrue:[
        d add:'-html' -> [ HTMLUtilities escapeCharacterEntities:self ].
    ].
    ^ d

    "
     'aou' inspect
    "

    "Created: / 22-10-2006 / 03:52:20 / cg"
! !

!CharacterArray methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self basicStoreString contractTo:30.
! !

!Class methodsFor:'misc ui support'!

inspectorClass
    "redefined to launch a ClassInspector, which knows about classVariables
     (instead of the default InspectorView)."

    ClassInspectorView notNil ifTrue:[
        ^ ClassInspectorView
    ].
    ^ super inspectorClass
! !

!ClassDescription methodsFor:'misc ui support'!

iconInBrowserForVariableNamed: varName
    "variables for which an entry is found in the xml-spec (if any) are marked
     with an <xml>-icon. 
     For now, this is expecco-specific, but should be somehow lifted to the base system"

    (Expecco::ExpeccoXMLDecoder notNil 
    and:[self canUnderstand: #xmlSpecFor:]) ifTrue:[
        Error handle:[:ex |
        ] do:[
            (Expecco::ExpeccoXMLDecoder xmlSpecForObject:self basicNew)
                do:[:spec | 
                    spec getter = varName ifTrue:[
                        ^ SystemBrowser instVarOverlayXmlSpec
                    ]
                ].
        ].
    ].
    ^ nil

    "Created: / 12-04-2011 / 16:04:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-07-2011 / 15:31:38 / cg"
! !

!Collection methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    |sz|

    (sz := self size) == 0 ifTrue:[
        ^ 'empty ' , self className
    ].
    ^ (super inspectorValueStringInListFor:anInspector),' size=',sz printString
! !

!Collection class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"
    
    <resource: #programImage>

    self isAbstract ifTrue:[
        ^ #abstractContainerClassBrowserIcon
    ].    
    ^ #containerClassBrowserIcon
! !

!Color methodsFor:'misc ui support'!

inspectorClass
    "return the class of an appropriate inspector.
     ST/X has a specialized ColorInspectorView for that"

    ^ ColorInspectorView

    "Modified: 23.4.1996 / 13:39:50 / cg"
! !

!Color methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ super inspectorExtraAttributes
        add:'-rgb' -> [ self rgbValue hexPrintString ];
        add:'-html' -> [ self htmlPrintString ];
        yourself

    "
     Color red inspect
    "
! !

!Color methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self htmlPrintString
! !

!CompositeChange methodsFor:'utilities'!

condenseChangesForRemoved

    self changes condenseChangesForRemoved
! !

!CompositeChange methodsFor:'private'!

flattenOnto: aCollection

    changes do:[:change|change flattenOnto: aCollection]
! !

!CompositeChange methodsFor:'accessing'!

removed

    ^changes allSatisfy: [:e|e removed]
! !

!CompositeChange methodsFor:'accessing'!

removed: aBoolean

    changes do:[:e|e removed: aBoolean]
! !

!Date methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ super inspectorExtraAttributes
        add:'-day' -> [ self day printString ];
        add:'-month' -> [ self month printString ];
        add:'-year' -> [ self year printString ];
        add:'-dayInWeek' -> [ self dayInWeek printString , ' "', self dayOfWeekName , '"' ];
        add:'-dayInYear' -> [ self dayInYear ];
        add:'-daysInMonth' -> [ self daysInMonth ];
        add:'-monthName' -> [ self monthName ];
        add:'-weekNr' -> [  self weekInYear ];
        add:'-leapYear' -> [ self isLeapYear ];
        add:'-iso8601(utc)' -> [ self asUtcTimestamp printStringIso8601 ];
        yourself

    "
     Date today inspect
    "

    "Created: / 20-01-2011 / 12:19:05 / cg"
! !

!Date methodsFor:'printing & storing'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self printString
! !

!Date class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    ^ #timeClassBrowserIcon
! !

!Dictionary methodsFor:'inspecting'!

inspector2TabLabel
    ^ 'Dictionary'

    "Created: / 14-07-2011 / 11:57:18 / cg"
! !

!Dictionary methodsFor:'misc ui support'!

inspectorClass
    "redefined to use DictionaryInspector
     (instead of the default Inspector)."

    ^ DictionaryInspectorView
! !

!EditTextView methodsFor:'accessing-dimensions'!

absoluteXOfPosition:positionInText 
    |accumulatedX container|

    accumulatedX := 0.
    container := self.
    [ container notNil ] whileTrue:[
        accumulatedX := accumulatedX + container origin x.
        container := container isTopView ifFalse:[
                    container container
                ] ifTrue:[ nil ].
    ].
    ^ (self xOfPosition:positionInText) + accumulatedX

    "Created: / 16-02-2010 / 10:05:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditTextView methodsFor:'accessing-dimensions'!

absoluteYOfCursor
    | accumulatedY container |

    accumulatedY := 0.
    container := self.
    [ container notNil ] whileTrue:[
        accumulatedY := accumulatedY + container origin y.
        container := container isTopView 
            ifFalse:[container container]
            ifTrue:[nil].
    ].
    ^ (self yOfCursor) + accumulatedY

    "Created: / 27-05-2005 / 07:45:53 / janfrog"
    "Modified: / 27-05-2005 / 23:03:40 / janfrog"
! !

!EditTextView methodsFor:'accessing-dimensions'!

xOfPosition: positionInText

    | line col |
    line := self lineOfCharacterPosition: positionInText.
    col  := positionInText - (self characterPositionOfLine:line col:1) + 1.
    ^
        (self xOfCol:col inVisibleLine:(self listLineToVisibleLine: line))
            - viewOrigin x.

    "Created: / 16-02-2010 / 10:04:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditTextView methodsFor:'accessing-dimensions'!

yOfCursor

    ^self yOfVisibleLine:cursorVisibleLine.

    "Created: / 27-05-2005 / 07:43:41 / janfrog"
! !

!EditTextView methodsFor:'accessing-dimensions'!

yOfPosition: positionInText

    | line |
    line := self lineOfCharacterPosition: positionInText.
    ^self yOfVisibleLine:(self listLineToVisibleLine: line)

    "Created: / 16-02-2010 / 10:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Error class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    ^ #errorClassBrowserIcon
! !

!ExecutableFunction methodsFor:'printing & storing'!

printStringForBrowserWithSelector:selector
    "return a printString to represent myself to the user in a browser."

    ^ self printStringForBrowserWithSelector:selector inClass:nil
! !

!ExternalLibraryFunction methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    |atts|

    atts := super inspectorExtraAttributes.
    atts
        add:'-callType' -> [ self isCallTypeAPI 
                                ifTrue:[ 'API' ]
                                ifFalse:[ 'normal' ] 
                           ];
        add:'-virtual' -> [ self isVirtualCPP ].

    ^ atts

    "Modified: / 12-11-2016 / 11:38:35 / cg"
! !

!FileStream methodsFor:'inspecting'!

inspectorExtraMenuOperations
    "extra operation-menu entries to be shown in an inspector.
     Answers a collection of pairs contining aString and action aBlock.
     aString is the label of the menu item.
     aBlock is evaluated when the menu item is selected.
     To be redefined in objects which think that it makes sense to offer
     often used operations in an inspector.
     See SerialPort as an example."

    |superItems|

    superItems := super inspectorExtraMenuOperations.
    ^ superItems , 
            {
                { 'Close File' . [self close] }
            }.
! !

!Filename methodsFor:'debugging'!

inspector2TabContentsView
    <inspector2Tab>      
    
    "provide an additional tab, which presents the file's contents.
        '.' asFilename inspect
        'smalltalk.rc' asFilename inspect
    "

    | mimetype |

    self isDirectory ifTrue:[ 
        | tab |    

        ^ (tab := Tools::Inspector2Tab new)
            label: 'Contents';
            priority: 50;
            applicationHolder: [   
                | browser |

                browser := DirectoryContentsBrowser new.
                browser
                    initializeAspects;
                    aspectFor:#currentFileNameHolder put:((OrderedCollection with:self) asValue);
                    updateCurrentFileNameHolderWhenSelectionChanges:false.
                browser viewDirsInContentsBrowser value:true.
                browser enterActionBlock:[:item|
                    | app |                        
                    app := tab view topView application.
                    app notNil ifTrue:[
                        app inspect: item fileName.
                    ].
                ].
                browser
            ];
            yourself
    ].
    mimetype := self mimeTypeFromName.
    (mimetype notNil and:[mimetype isTextType or:[ mimetype endsWith: '-source']]) ifTrue:[ 
        ^ Tools::Inspector2Tab new
            label: 'Contents';
            priority: 50;
            viewHolder: [   
                | view model |

                self exists ifTrue:[
                    model := self contents asValue.
                ] ifFalse:[
                    model := 'File does not (no longer?) exist' asValue.
                ].
                view := Tools::CodeView2 new.
                view model: model.
                view acceptAction:[ :contents |
                    self writingFileDo:[:s|
                        contents do:[:line | s nextPutLine: line ].
                    ].
                    model value: contents.
                ].
                view
            ];
            yourself
    ].


    ^ nil

    "Created: / 13-02-2015 / 15:08:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2015 / 20:57:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Form methodsFor:'misc ui support'!

inspectorClass
    "redefined to launch an ImageInspector
     (instead of the default InspectorView)."

    ^ ImageInspectorView
! !

!GenericException class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    ^ #exceptionClassBrowserIcon
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-22x22'!

bookmarks22x22
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bookmarks22x22 inspect
     ImageEditor openOnClass:self andSelector:#bookmarks22x22
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class bookmarks22x22'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
????????????????????????????????????????????????????????????????????????LT;??????????????????????????6BAD/??????????????
?????????16L''"+???????????????????????<7''95Y????????????????????????YI2[_!!C?????????????????????GXZZ&Y\0????????????I$YF
Q$YFQUBX%)VRZ%YAO34=OR????=T#9RT$9FP#(6K"(VB_718]U0%????FC)9"X"G!!HN@_W]4\V=)YT@E????????J&Y;^''Y3\''A-ZFI_UR8A??????????<Q
SF9,Z6]#WU!!SQBW??????????????1YWXU9ZTT5IP2K???????????????<)V5IOR$\>NS (????????????????M$-HP#,3KB\ZE07?????????????GST<
MB4$GATNB0(]?????????????142J18[@O<RC0XCD?????????????<!!H1$G?????1@T@ $H????????????G2@D?????????14L????????????????????
?????????????????????????????????????????????0@a') ; colorMapFromArray:#[143 162 38 146 165 38 153 167 24 155 168 21 149 168 39 149 169 39 156 169 21 151 170 40 151 171 40 156 171 30 159 173 22 160 174 20 156 174 34 154 175 41 162 176 20 159 176 32 156 176 41 156 177 41 157 177 41 159 178 37 159 178 38 163 179 26 158 179 42 163 180 27 159 180 42 162 180 35 166 181 20 160 181 40 161 181 39 160 181 42 165 181 28 162 181 37 161 181 40 162 181 38 161 181 41 168 181 23 162 182 36 161 182 41 161 182 43 168 183 20 163 183 35 162 183 41 162 183 42 170 184 22 169 185 20 169 185 23 164 185 38 164 185 40 164 185 42 164 185 43 171 186 24 171 187 21 172 187 22 170 187 29 168 187 35 165 187 44 171 188 19 173 190 19 168 189 44 174 190 21 174 190 22 170 192 37 176 192 20 170 192 38 171 193 33 171 193 38 177 193 21 176 194 19 174 194 26 172 193 47 172 193 48 178 195 20 179 195 21 179 197 19 180 197 20 180 197 21 176 197 38 181 199 19 177 199 46 183 201 20 179 200 50 184 202 19 185 202 21 184 203 18 180 201 50 183 204 21 181 203 37 184 204 27 185 205 18 181 204 45 187 205 19 187 205 21 183 206 27 187 208 18 189 208 20 189 210 17 186 208 51 191 210 20 190 211 17 190 211 19 187 209 53 191 213 17 190 211 43 193 213 19 193 214 17 194 216 16 192 215 38 195 216 20 196 217 25 196 218 18 196 217 28 196 219 17 198 220 18 199 221 17 200 222 23 201 222 28 201 224 17 200 225 16 203 223 33 203 225 20 202 226 16 202 223 51 204 224 38 204 224 41 203 227 16 204 226 26 203 226 47 204 229 16 206 227 34 203 227 53 206 230 21 207 228 39 208 228 43 207 231 26 207 228 60 209 229 48 209 229 51 210 229 52 209 232 33 210 232 39 209 231 58 211 233 46 212 234 52 213 233 63 213 234 56 214 235 59 214 237 41 215 235 62 215 235 64 215 238 49 217 238 55 217 240 46 218 239 61 219 242 53 220 242 59 222 245 56 223 245 62 224 248 57 224 248 58 224 248 64 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@C@@@C @@G @@G @@G0@@O0@_??8O??8O??0C?? A?>@@?<@@?<@@?>@A?>@A>>@A8_@A0F@@@@@@@@@') ; yourself); yourself]

    "Modified: / 05-05-2011 / 12:45:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-16x16'!

bug16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bug16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#bug16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class bug16x16Icon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
???????????????????????????????????????????????????3R/??????????????????O"_???????????????????7=?#J1???????????=???=IBP$
?_????????????7=W5=_W5?=O/7???????>L?PLC@0LC?_????????7=/4S[7S 8TY/=?VC?????L#L.>JI3I+A%H#[?????GA3_]U*/M3_;BPRLD_????7=
?_B@M>DE-04>?U/??????2_=HEXYQ7:R<Q_???????4>G2$%Q9QEL?5_??????????<=?\;M??????????????????=-H????????0@a') ; colorMapFromArray:#[205 205 205 227 35 35 106 106 106 98 98 98 135 135 135 163 34 34 101 5 5 124 124 124 48 2 2 227 11 11 173 173 173 218 54 54 241 241 241 235 19 19 225 225 225 219 18 18 245 58 58 214 214 214 249 46 46 90 90 90 254 61 61 36 36 36 176 176 176 233 233 233 114 114 114 255 78 78 212 33 33 230 57 57 61 61 61 94 94 94 76 76 76 19 19 19 255 57 57 161 161 161 83 83 83 217 217 217 249 249 249 255 65 65 139 2 2 27 27 27 169 169 169 253 53 53 210 28 28 251 251 251 154 154 154 117 117 117 195 1 1 245 245 245 145 145 145 218 5 5 230 230 230 69 2 2 181 181 181 11 11 11 141 141 141 249 61 61 205 21 21 165 165 165 157 157 157 241 28 28 223 223 223 109 109 109 2 2 2 245 45 45 146 0 0 69 69 69 137 137 137 140 40 40 188 1 1 206 24 24 219 33 33 255 76 76 249 49 49 249 56 56 236 236 236 121 121 121 248 53 53 171 1 1 111 40 40 237 41 41 178 21 21 205 16 16 129 129 129 163 1 1 155 18 18 85 4 4 243 68 68 73 73 73 45 45 45 202 51 51 241 40 40 86 86 86 114 1 1 210 4 4 246 41 41 148 148 148 189 189 189 209 209 209 210 17 17 158 28 28 213 5 5 205 1 1 53 53 53 217 9 9 69 40 40 187 10 10 255 74 74 218 28 28 146 11 11 65 65 65 232 37 37 101 101 101 196 26 26 245 53 53 188 26 26 213 10 10 184 184 184 206 5 5 249 65 65 172 21 21 206 34 34 195 195 195 237 32 32 131 12 12 233 29 29 179 36 36 241 37 37 139 13 13 245 49 49 180 1 1 168 37 37 198 198 198 202 202 202 228 21 21 206 10 10 206 29 29 229 30 30 255 80 80 188 20 20 245 37 37 57 57 57 252 50 50 87 42 42 172 10 10 209 13 13 155 4 4 164 11 11 242 44 44 255 70 70 225 25 25 222 14 14 237 24 24 240 49 49 205 13 13 202 44 44 201 0 0 225 17 17 186 42 42 255 72 72 122 1 1 40 40 40 157 10 10 209 8 8 222 8 8 195 41 41 223 21 21 180 11 11 255 68 68 162 28 28 194 11 11 232 25 25 131 1 1 241 32 32 246 246 246 49 49 49 224 44 44 208 2 2 227 227 227 239 239 239 239 46 46 162 20 20 245 33 33 219 219 219 238 29 29 237 37 37 171 29 29 36 46 46 250 68 68 147 16 16 182 26 26 187 187 187 24 1 1 185 32 32 229 24 24 232 33 33 150 150 150 122 12 12 229 17 17 204 27 27 242 52 52 213 2 2 200 15 15 191 191 191 217 43 43 217 12 12 115 10 10 140 16 16 200 28 28 202 6 6 215 13 13 182 41 41 57 46 46 40 46 46 233 40 40 252 70 70 173 40 40 226 28 28 46 54 54 202 22 22 203 18 18 245 72 72 191 17 17 200 37 37 10 0 0 50 52 52 252 74 74 252 72 72 247 38 38 160 40 40 231 14 14 252 68 68 200 10 10 15 15 15 211 47 47 254 254 254 253 76 76 23 23 23 237 69 69 7 7 7 144 7 7 196 8 7 32 32 32 59 59 59 90 93 93 67 67 67 70 28 28 50 56 56 232 15 16 208 4 4 237 35 35 220 12 11 232 20 20 223 62 62 0 0 0 255 255 255 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@L@@0@C8AO C?0O<C?>G?0??#?>C?0_?@O@@L@b') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-24x24'!

bug24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bug24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#bug24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary bug24x24Icon'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
??????????????????????????????????????????????????<@???????????????????????1??????<@<???????????????????????<4+????3????
????????????????????O"_???> ??????????????????????????5/[3;.?????????????????????????V<$?#K=,_????????????????7???=/[2P$
IBP$?_?????=????????MV?=???=L&<2L&<2?_7?XQW.??????????=/?_7=XVE!!XVE!!W?7=O#[?????????????[?4''@0L8NC C@?7=????????????????
?_6[NC 8NC 8NI/=?????????????_7=/4R[6=48NC!!"TY-M?_7=XO???????3H0L29%>JK/\2Z",FUDH#YJ????????????L9-$3N>%%ZW/YL!!D????????
????GA1W77W7V*<7M3\R>0%DAH0\D_???????SC=?_@M C_W8PTP-05MO/7=V???????@@@4MX>WRW7WFPVZ"?//?1XV??????????<XI?7]HEXYFT]Y_)K=
<Q_??????????3PXO!!?DJRU*Q9P%QSL5?U<@?????????3T5???=F$  EB@?L37?[3;=?????????6??????O_7D3,7=????@@A/??????????????????<(
JB#?????????????????????????????????????????????') ; colorMapFromArray:#[205 205 205 227 35 35 106 106 106 98 98 98 135 135 135 163 34 34 101 5 5 124 124 124 48 2 2 227 11 11 173 173 173 218 54 54 241 241 241 235 19 19 225 225 225 219 18 18 245 58 58 214 214 214 249 46 46 90 90 90 254 61 61 36 36 36 176 176 176 233 233 233 114 114 114 255 78 78 212 33 33 230 57 57 61 61 61 94 94 94 76 76 76 19 19 19 255 57 57 161 161 161 83 83 83 217 217 217 249 249 249 255 65 65 139 2 2 27 27 27 169 169 169 253 53 53 210 28 28 251 251 251 154 154 154 117 117 117 195 1 1 245 245 245 145 145 145 218 5 5 230 230 230 69 2 2 181 181 181 11 11 11 141 141 141 249 61 61 205 21 21 165 165 165 157 157 157 241 28 28 223 223 223 109 109 109 2 2 2 245 45 45 146 0 0 69 69 69 137 137 137 140 40 40 188 1 1 206 24 24 219 33 33 255 76 76 249 49 49 249 56 56 236 236 236 121 121 121 248 53 53 171 1 1 111 40 40 237 41 41 178 21 21 205 16 16 129 129 129 163 1 1 155 18 18 85 4 4 243 68 68 73 73 73 45 45 45 202 51 51 241 40 40 86 86 86 114 1 1 210 4 4 246 41 41 148 148 148 189 189 189 209 209 209 210 17 17 158 28 28 213 5 5 205 1 1 53 53 53 217 9 9 69 40 40 187 10 10 255 74 74 218 28 28 146 11 11 65 65 65 232 37 37 101 101 101 196 26 26 245 53 53 188 26 26 213 10 10 184 184 184 206 5 5 249 65 65 172 21 21 206 34 34 195 195 195 237 32 32 131 12 12 233 29 29 179 36 36 241 37 37 139 13 13 245 49 49 180 1 1 168 37 37 198 198 198 202 202 202 228 21 21 206 10 10 206 29 29 229 30 30 255 80 80 188 20 20 245 37 37 57 57 57 252 50 50 87 42 42 172 10 10 209 13 13 155 4 4 164 11 11 242 44 44 255 70 70 225 25 25 222 14 14 237 24 24 240 49 49 205 13 13 202 44 44 201 0 0 225 17 17 186 42 42 255 72 72 122 1 1 40 40 40 157 10 10 209 8 8 222 8 8 195 41 41 223 21 21 180 11 11 255 68 68 162 28 28 194 11 11 232 25 25 131 1 1 241 32 32 246 246 246 49 49 49 224 44 44 208 2 2 227 227 227 239 239 239 239 46 46 162 20 20 245 33 33 219 219 219 238 29 29 237 37 37 171 29 29 36 46 46 250 68 68 147 16 16 182 26 26 187 187 187 24 1 1 185 32 32 229 24 24 232 33 33 150 150 150 122 12 12 229 17 17 204 27 27 242 52 52 213 2 2 200 15 15 191 191 191 217 43 43 217 12 12 115 10 10 140 16 16 200 28 28 202 6 6 215 13 13 182 41 41 57 46 46 40 46 46 233 40 40 252 70 70 173 40 40 226 28 28 46 54 54 202 22 22 203 18 18 245 72 72 191 17 17 200 37 37 10 0 0 50 52 52 252 74 74 252 72 72 247 38 38 160 40 40 231 14 14 252 68 68 200 10 10 15 15 15 211 47 47 254 254 254 253 76 76 23 23 23 237 69 69 7 7 7 144 7 7 196 8 7 32 32 32 59 59 59 90 93 93 67 67 67 70 28 28 50 56 56 232 15 16 208 4 4 237 35 35 220 12 11 232 20 20 223 62 62 0 0 0 255 255 255 255 255 255]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@HD@@FH@@FH@@C8@@G<@BO<HGO>8A??0@??@@??@G??<C??8@??@G??<G??<A??XA??0C??0CO>8BG8H@A0@@@@@') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-32x32'!

bug32x32Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self bug3232Icon inspect
     ImageEditor openOnClass:self andSelector:#bug3232Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'GenericToolbarIconLibrary class bug32x32Icon'
        ifAbsentPut:[
            (Depth8Image new)
                width:32;
                height:32;
                photometric:(#palette);
                bitsPerSample:(#( 8 ));
                samplesPerPixel:((1));
                bits:(ByteArray 
                            fromPackedString:'
??????????????????????????????????????????????????????????????????>6@/?????????????????????????????1H_????????4-????????
???????????????????????=?_??????O!!???????????????????????????????3W3R/?????=I????????????????????????????????38''?????:C?
??????????????????????????????????7.??<>;/???????????????????????????????????_7=?_7=????????????????????????????????[?7=
IO;>L/7=,_?????????????????????=?????6?=?RP$IBP$IO7=???????=????????????MX3=?????_42L#H2L#H2L/7=??=!!E^8Q????????????O.9K
?_7=@G%9^W%9^W%9JO7=O%K=O/???????????????_7=?_5_W5=_W5=_W5=_?_7=O/7??????????????????83=I0LC@0LC@0LC@0O=?SK?????????????
?????????_6 PTEAPTEAPTEAPSW=M_??????????????JC(SI?7= S#WP49(ZF"NS$N$]UO=?QU/@6G???????<-?_7=?[=D&5G[7S 8NC!!"65F[S_7=?_4U
XO??????????L#C4L29%,O"";7M3I*K8,FUD?RH6R/????????????????<3&6Q''3N>%%YV%;6]$2DS=????????????????????(@#8(92*/KN3,4=T0YZ#
K/40?????????????0P\GE]X77W7*%*/M3\7M1K9>0%D?PRLGB\Q????????<_7=?S;=<@5> C_W8^DEDC>7CT7=O/7=<U/?????????B!!X4?3VO%59I_]\Y
FPVZSH/;;8O?E!!Y9????????????????I<SAD#^BFX&IFVMI86H3H/??????????????????FB4''?]5^HEXY"Q%GVR%>$/4^<Q_???????????????4X?S8_
1DX)IV)GQ9P%D$T3MS;=W27?????????????MST!!???=1A)HHBTTHC?FL37??1<>?_?????????????????????=A''KUO9M.]0# ?????1_?????????????
??????????<=?\SN3,7=H???????????????????????????????????JFY-H???????????????????????????????????????????????????????????
?????????????????????????????????????????????0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@');
                colorMapFromArray:#[ 205 205 205 227 35 35 106 106 106 98 98 98 135 135 135 163 34 34 101 5 5 124 124 124 48 2 2 227 11 11 173 173 173 218 54 54 241 241 241 235 19 19 225 225 225 219 18 18 245 58 58 214 214 214 249 46 46 90 90 90 254 61 61 36 36 36 176 176 176 233 233 233 114 114 114 255 78 78 212 33 33 230 57 57 61 61 61 94 94 94 76 76 76 19 19 19 255 57 57 161 161 161 83 83 83 217 217 217 249 249 249 255 65 65 139 2 2 27 27 27 169 169 169 253 53 53 210 28 28 251 251 251 154 154 154 117 117 117 195 1 1 245 245 245 145 145 145 218 5 5 230 230 230 69 2 2 181 181 181 11 11 11 141 141 141 249 61 61 205 21 21 165 165 165 157 157 157 241 28 28 223 223 223 109 109 109 2 2 2 245 45 45 146 0 0 69 69 69 137 137 137 140 40 40 188 1 1 206 24 24 219 33 33 255 76 76 249 49 49 249 56 56 236 236 236 121 121 121 248 53 53 171 1 1 111 40 40 237 41 41 178 21 21 205 16 16 129 129 129 163 1 1 155 18 18 85 4 4 243 68 68 73 73 73 45 45 45 202 51 51 241 40 40 86 86 86 114 1 1 210 4 4 246 41 41 148 148 148 189 189 189 209 209 209 210 17 17 158 28 28 213 5 5 205 1 1 53 53 53 217 9 9 69 40 40 187 10 10 255 74 74 218 28 28 146 11 11 65 65 65 232 37 37 101 101 101 196 26 26 245 53 53 188 26 26 213 10 10 184 184 184 206 5 5 249 65 65 172 21 21 206 34 34 195 195 195 237 32 32 131 12 12 233 29 29 179 36 36 241 37 37 139 13 13 245 49 49 180 1 1 168 37 37 198 198 198 202 202 202 228 21 21 206 10 10 206 29 29 229 30 30 255 80 80 188 20 20 245 37 37 57 57 57 252 50 50 87 42 42 172 10 10 209 13 13 155 4 4 164 11 11 242 44 44 255 70 70 225 25 25 222 14 14 237 24 24 240 49 49 205 13 13 202 44 44 201 0 0 225 17 17 186 42 42 255 72 72 122 1 1 40 40 40 157 10 10 209 8 8 222 8 8 195 41 41 223 21 21 180 11 11 255 68 68 162 28 28 194 11 11 232 25 25 131 1 1 241 32 32 246 246 246 49 49 49 224 44 44 208 2 2 227 227 227 239 239 239 239 46 46 162 20 20 245 33 33 219 219 219 238 29 29 237 37 37 171 29 29 36 46 46 250 68 68 147 16 16 182 26 26 187 187 187 24 1 1 185 32 32 229 24 24 232 33 33 150 150 150 122 12 12 229 17 17 204 27 27 242 52 52 213 2 2 200 15 15 191 191 191 217 43 43 217 12 12 115 10 10 140 16 16 200 28 28 202 6 6 215 13 13 182 41 41 57 46 46 40 46 46 233 40 40 252 70 70 173 40 40 226 28 28 46 54 54 202 22 22 203 18 18 245 72 72 191 17 17 200 37 37 10 0 0 50 52 52 252 74 74 252 72 72 247 38 38 160 40 40 231 14 14 252 68 68 200 10 10 15 15 15 211 47 47 254 254 254 253 76 76 23 23 23 237 69 69 7 7 7 144 7 7 196 8 7 32 32 32 59 59 59 90 93 93 67 67 67 70 28 28 50 56 56 232 15 16 208 4 4 237 35 35 220 12 11 232 20 20 223 62 62 0 0 0 255 255 255 255 255 255 ];
                mask:((ImageMask new)
                            width:32;
                            height:32;
                            photometric:(#blackIs0);
                            bitsPerSample:(#[ 1 ]);
                            samplesPerPixel:((1));
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@L@@@LC@@@A 0@@@\L@@@CB@@@@Y @@@G8@@@G? @AC?8H@8??O@G??? @???0@C??0@@??<@G???>A???? G??? @O??@@G??8@_???8G???>@;?
?7@@??<@@???0@_??>@GO?3 @A?8P@@O<@@@@<@@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-16x16'!

lint16x16Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self lint16x16Icon inspect
     ImageEditor openOnClass:self andSelector:#lint16x16Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class lint16x16Icon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
??????????????????????????????????????????????????<4[_??????????????????A4W??????????????????2<A()BG??????????<A??<A1_;>
@XS??????????3<)-;^76.Z5A0O???????<P@W!!8>-3J<0+??????0\JI1,;7^?57-[;''T????<JS0P"PN3'':-V>8L??????V5@''G57.1,!!#X-''R_O???1(R
@RMW:Y*KY6+7*RW??????3P*ZU[;.:#!!/:7???????<A@6AV2?S:9+>5??????????< BC &?????;?Z??????????<XU_?????X<P@a') ; colorMapFromArray:#[0 1 0 0 2 0 1 4 0 3 6 2 30 1 0 6 9 5 34 2 2 10 12 8 43 4 2 13 15 12 15 17 13 77 0 0 16 18 15 35 14 12 17 19 16 67 6 1 19 20 18 75 7 10 21 23 20 86 9 4 25 27 24 111 4 7 103 7 10 96 10 12 32 29 28 29 30 28 31 33 30 153 2 0 33 35 33 35 36 34 110 16 16 173 0 1 36 38 35 41 37 36 165 4 0 155 7 7 128 15 14 39 41 39 157 12 16 51 42 42 207 0 4 43 45 42 58 41 39 141 19 15 199 4 0 210 3 0 221 1 4 48 49 47 231 0 12 211 7 8 172 19 10 172 19 18 52 54 51 53 55 53 234 5 23 59 54 53 176 24 21 56 57 55 57 59 56 204 19 22 195 22 24 103 47 48 227 16 9 60 61 59 198 25 19 216 20 21 61 63 60 119 48 45 228 20 20 63 65 62 211 30 27 68 69 67 69 71 68 212 32 34 242 25 29 72 74 71 74 76 74 191 45 50 245 31 38 76 78 75 77 79 76 79 80 78 138 66 66 248 36 40 240 41 43 83 85 82 216 50 52 241 43 50 195 58 61 86 88 85 244 46 46 87 89 86 89 91 88 214 58 58 193 65 67 92 93 91 248 51 49 109 90 87 185 68 87 194 67 80 87 95 125 250 54 57 173 74 96 202 67 84 159 78 103 253 56 52 188 72 90 87 99 135 129 89 121 99 101 98 73 104 148 255 59 60 159 83 106 175 81 94 94 102 132 187 78 98 215 71 85 255 61 67 169 84 104 251 66 66 104 106 103 90 106 147 151 92 119 200 81 93 107 108 106 140 99 131 162 94 119 255 72 76 144 100 128 96 112 153 228 80 83 159 97 120 111 113 110 191 90 111 206 87 104 113 115 112 87 118 163 115 117 114 83 122 166 179 100 117 118 120 117 199 99 101 231 91 88 138 113 147 120 122 119 196 101 119 123 125 122 115 123 167 213 100 113 119 123 162 180 109 128 127 129 126 208 108 109 115 131 173 185 115 140 158 122 154 173 119 144 131 133 130 130 130 163 178 122 124 181 119 147 106 139 178 136 138 135 120 139 175 126 138 175 204 121 132 132 139 172 113 146 186 136 143 176 144 146 143 121 149 184 153 142 173 135 150 181 148 150 147 125 153 188 130 153 182 179 140 167 150 152 149 205 136 148 181 145 146 136 159 189 155 157 154 140 163 193 159 161 158 161 163 160 143 166 196 162 164 161 148 167 192 164 166 163 165 165 187 197 159 173 167 169 166 152 171 196 191 163 180 157 172 191 169 171 168 216 159 166 171 173 170 208 163 179 187 169 190 217 162 175 174 176 173 159 178 203 186 173 174 207 167 175 163 178 198 213 166 176 179 181 178 198 176 192 169 185 204 183 185 182 216 175 184 209 177 189 212 180 192 204 183 198 208 183 193 188 190 187 180 192 206 194 196 193 215 191 201 187 199 213 204 198 197 211 196 210 199 201 198 190 202 216 191 203 217 201 202 212 202 204 201 208 203 201 219 201 210 205 207 203 217 203 217 206 208 205 213 207 206 223 205 214 203 211 220 211 213 210 211 212 222 214 216 213 221 215 227 217 219 216 219 221 218 228 218 224 217 222 225 221 223 220 231 221 227 216 225 233 220 226 228 224 226 223 221 229 238 231 233 230 228 234 236 233 235 232 235 238 234 249 251 248 255 255 255]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@L@@0@C8AO0C?0O>C?>O?0??#?>C?0O?@OC@LLb') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-24x24'!

lint24x24Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self lint24x24Icon inspect
     ImageEditor openOnClass:self andSelector:#lint24x24Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary lint24x24Icon'
        ifAbsentPut:[(Depth8Image new) width:24; height:24; bits:(ByteArray fromPackedString:'
??????????????????????????????????????????????????????????????????????????=_W?????>-@:7?????????????????????MF7???<4+_??
????????????????????+TW???<L?????????????????????????2AG?4HY????????????????????????K65[()A-!!????????????????:7?????[\W>
?/;0[XS???<ZR???????JZ6-??=-0?3<?O3<F&7??0*-??????????<GO:5-6-+Z6-+,9+U-A:4@????????????+PE-^G!!<>-262/O1[_??????????????
+V4PR4/I):+J+8+Q,_??????????+P(]I1,,N=7J;?W27-ZO>94NS4??????B @@[RH(PN2#9>+%5[:@8L>D????????????[Q<-S_BU6=/W3)Y:.]??????
????@@AEI1<>W^:$1,"2X6I(6]IP_@C?????+QHN[RL0U>&6&(-1Y6)(=:$@@D??????N @@[QUDXKO;(HM6^7M,<G @@@AO????????MB(2ZUZX>;.&*NG:
/:6D??????????<)+V4SXEY?2?S<>.Y-/;V-?????????1&-??=-RU)/]8JMT&7?@K>5#O???????:7?????[RX+NBX&[_????>:/;T@?????????????65-
[V5-????????6OF5????????????????????????????@MK?') ; colorMapFromArray:#[0 1 0 0 2 0 1 4 0 3 6 2 30 1 0 6 9 5 34 2 2 10 12 8 43 4 2 13 15 12 15 17 13 77 0 0 16 18 15 35 14 12 17 19 16 67 6 1 19 20 18 75 7 10 21 23 20 86 9 4 25 27 24 111 4 7 103 7 10 96 10 12 32 29 28 29 30 28 31 33 30 153 2 0 33 35 33 35 36 34 110 16 16 173 0 1 36 38 35 41 37 36 165 4 0 155 7 7 128 15 14 39 41 39 157 12 16 51 42 42 207 0 4 43 45 42 58 41 39 141 19 15 199 4 0 210 3 0 221 1 4 48 49 47 231 0 12 211 7 8 172 19 10 172 19 18 52 54 51 53 55 53 234 5 23 59 54 53 176 24 21 56 57 55 57 59 56 204 19 22 195 22 24 103 47 48 227 16 9 60 61 59 198 25 19 216 20 21 61 63 60 119 48 45 228 20 20 63 65 62 211 30 27 68 69 67 69 71 68 212 32 34 242 25 29 72 74 71 74 76 74 191 45 50 245 31 38 76 78 75 77 79 76 79 80 78 138 66 66 248 36 40 240 41 43 83 85 82 216 50 52 241 43 50 195 58 61 86 88 85 244 46 46 87 89 86 89 91 88 214 58 58 193 65 67 92 93 91 248 51 49 109 90 87 185 68 87 194 67 80 87 95 125 250 54 57 173 74 96 202 67 84 159 78 103 253 56 52 188 72 90 87 99 135 129 89 121 99 101 98 73 104 148 255 59 60 159 83 106 175 81 94 94 102 132 187 78 98 215 71 85 255 61 67 169 84 104 251 66 66 104 106 103 90 106 147 151 92 119 200 81 93 107 108 106 140 99 131 162 94 119 255 72 76 144 100 128 96 112 153 228 80 83 159 97 120 111 113 110 191 90 111 206 87 104 113 115 112 87 118 163 115 117 114 83 122 166 179 100 117 118 120 117 199 99 101 231 91 88 138 113 147 120 122 119 196 101 119 123 125 122 115 123 167 213 100 113 119 123 162 180 109 128 127 129 126 208 108 109 115 131 173 185 115 140 158 122 154 173 119 144 131 133 130 130 130 163 178 122 124 181 119 147 106 139 178 136 138 135 120 139 175 126 138 175 204 121 132 132 139 172 113 146 186 136 143 176 144 146 143 121 149 184 153 142 173 135 150 181 148 150 147 125 153 188 130 153 182 179 140 167 150 152 149 205 136 148 181 145 146 136 159 189 155 157 154 140 163 193 159 161 158 161 163 160 143 166 196 162 164 161 148 167 192 164 166 163 165 165 187 197 159 173 167 169 166 152 171 196 191 163 180 157 172 191 169 171 168 216 159 166 171 173 170 208 163 179 187 169 190 217 162 175 174 176 173 159 178 203 186 173 174 207 167 175 163 178 198 213 166 176 179 181 178 198 176 192 169 185 204 183 185 182 216 175 184 209 177 189 212 180 192 204 183 198 208 183 193 188 190 187 180 192 206 194 196 193 215 191 201 187 199 213 204 198 197 211 196 210 199 201 198 190 202 216 191 203 217 201 202 212 202 204 201 208 203 201 219 201 210 205 207 203 217 203 217 206 208 205 213 207 206 223 205 214 203 211 220 211 213 210 211 212 222 214 216 213 221 215 227 217 219 216 219 221 218 228 218 224 217 222 225 221 223 220 231 221 227 216 225 233 220 226 228 224 226 223 221 229 238 231 233 230 228 234 236 233 235 232 235 238 234 249 251 248 255 255 255]; mask:((ImageMask new) width:24; height:24; bits:(ByteArray fromPackedString:'@@@@@@@@@LN@@FL@@FH@@CX@@G<@BG>LGO>XA??0@?? @?? G??>D??8@??0A??<G??2D??1@??8A??8CO>\BG<N@C8G@@@B') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-32x32'!

lint32x32Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self lint32x32Icon inspect
     ImageEditor openOnClass:self andSelector:#lint32x32Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary class lint32x32Icon'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
????????????????????????????????????????????????????????????????????!!O????????????????????????????=_JU???????2@4@???????
??????????????????????<AT_??????@Q*??????????????????????????????4H4[_????<4O????????????????????????????????0]E?????01K
?????????????????????????????????2AG??=BFX_?????????????????????????????????QQ$A@PDR?????????????????????????????????2<A
V96"$@(C!!?????????????????????<A??????<R@\W>?/;><CPA!!O????<Z????????????JUEK????K0GC?O3<?O3<>A(A????B$"G????????????@SQG
V0(ARNO#8>O#8>O_+PD9NS(%@P_?????????????A0\?JPFW-;^7-;_Z;OG&-Q5EA0MU????????????????QQ@AA718^G2?>-26+,+3<W0J????????????
????????@PDPR4-K2_^''*,+M+8+Q>+G??????????????4IHUV4)B19COVG:(\K9=.7"/XGY;E=HQZ''???????=\A0(]P"\[KC,;7\*+;?W2:-;V#8#;''P8%
S?????????<JS5D)ABH(LTC,(<_'':.W[5[:@^^CO!!@G???????????????<FG241S_BU4M/[5=ON%'')2.]???????????????????0P_K"9^=IOA5MOL1JU&
\FR47?????????????=[TDT:I1<>M%7.)KCF2KJTX6I(Z=''RTD-<????????EA(RC DAH3AJU>&6&9*K\WQ''Z&!!.=:$RMBW?????????N%%\C LUQD9 ,?.Y
(HM6!!''-3[LC0^E%_#O??????????????!!@=AS&UX9N.Y''G:Q!!W6,?]"L?????????????????4,4J#INZUZX9/.;)):(8_+0/:6D??????????????<)GPDC
D4Y U''>N2?S<?_+&[\N?-Z6I????????????FPD)??<GE$%Z[7U7 (6_T"_??;>?-Z6L????????????Q?????<AE31TXFAZRRPM?????;2<.J6R????????
??????????< BB,3NBXQM????????;*</=*L????????????????????NRDXUU???????????;#X<[W??????????????????????????????????????;WR
?????????????????????????????????????????????0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@') ; colorMapFromArray:#[0 1 0 0 2 0 1 4 0 3 6 2 30 1 0 6 9 5 34 2 2 10 12 8 43 4 2 13 15 12 15 17 13 77 0 0 16 18 15 35 14 12 17 19 16 67 6 1 19 20 18 75 7 10 21 23 20 86 9 4 25 27 24 111 4 7 103 7 10 96 10 12 32 29 28 29 30 28 31 33 30 153 2 0 33 35 33 35 36 34 110 16 16 173 0 1 36 38 35 41 37 36 165 4 0 155 7 7 128 15 14 39 41 39 157 12 16 51 42 42 207 0 4 43 45 42 58 41 39 141 19 15 199 4 0 210 3 0 221 1 4 48 49 47 231 0 12 211 7 8 172 19 10 172 19 18 52 54 51 53 55 53 234 5 23 59 54 53 176 24 21 56 57 55 57 59 56 204 19 22 195 22 24 103 47 48 227 16 9 60 61 59 198 25 19 216 20 21 61 63 60 119 48 45 228 20 20 63 65 62 211 30 27 68 69 67 69 71 68 212 32 34 242 25 29 72 74 71 74 76 74 191 45 50 245 31 38 76 78 75 77 79 76 79 80 78 138 66 66 248 36 40 240 41 43 83 85 82 216 50 52 241 43 50 195 58 61 86 88 85 244 46 46 87 89 86 89 91 88 214 58 58 193 65 67 92 93 91 248 51 49 109 90 87 185 68 87 194 67 80 87 95 125 250 54 57 173 74 96 202 67 84 159 78 103 253 56 52 188 72 90 87 99 135 129 89 121 99 101 98 73 104 148 255 59 60 159 83 106 175 81 94 94 102 132 187 78 98 215 71 85 255 61 67 169 84 104 251 66 66 104 106 103 90 106 147 151 92 119 200 81 93 107 108 106 140 99 131 162 94 119 255 72 76 144 100 128 96 112 153 228 80 83 159 97 120 111 113 110 191 90 111 206 87 104 113 115 112 87 118 163 115 117 114 83 122 166 179 100 117 118 120 117 199 99 101 231 91 88 138 113 147 120 122 119 196 101 119 123 125 122 115 123 167 213 100 113 119 123 162 180 109 128 127 129 126 208 108 109 115 131 173 185 115 140 158 122 154 173 119 144 131 133 130 130 130 163 178 122 124 181 119 147 106 139 178 136 138 135 120 139 175 126 138 175 204 121 132 132 139 172 113 146 186 136 143 176 144 146 143 121 149 184 153 142 173 135 150 181 148 150 147 125 153 188 130 153 182 179 140 167 150 152 149 205 136 148 181 145 146 136 159 189 155 157 154 140 163 193 159 161 158 161 163 160 143 166 196 162 164 161 148 167 192 164 166 163 165 165 187 197 159 173 167 169 166 152 171 196 191 163 180 157 172 191 169 171 168 216 159 166 171 173 170 208 163 179 187 169 190 217 162 175 174 176 173 159 178 203 186 173 174 207 167 175 163 178 198 213 166 176 179 181 178 198 176 192 169 185 204 183 185 182 216 175 184 209 177 189 212 180 192 204 183 198 208 183 193 188 190 187 180 192 206 194 196 193 215 191 201 187 199 213 204 198 197 211 196 210 199 201 198 190 202 216 191 203 217 201 202 212 202 204 201 208 203 201 219 201 210 205 207 203 217 203 217 206 208 205 213 207 206 223 205 214 203 211 220 211 213 210 211 212 222 214 216 213 221 215 227 217 219 216 219 221 218 228 218 224 217 222 225 221 223 220 231 221 227 216 225 233 220 226 228 224 226 223 221 229 238 231 233 230 228 234 236 233 235 232 235 238 234 249 251 248 255 255 255]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@D@@@NC @@A 8@@@\L@@@CC@@@@Y0@@@G8@@@C? @AA?<H@8??G@G???0@???8@G??8@@??>@C???>A???? O???0@O??0@C??<@O???8G???>@??
?? @???@@_??8@O???@GO?38@!!?8_@@O<C8@@>@^@@@@C@@@@@@b') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-16x16'!

smalllintWarning16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self smalllintWarning16x16 inspect
     ImageEditor openOnClass:self andSelector:#smalllintWarning16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GenericToolbarIconLibrary smalllintWarning16x16'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@DA@PDA@@@@@@@@@@@@@@DB@0PC@ D@@@@@@@@@@@DBAPXFA TE@P@@@@@@@@@AA0XHA  FA0D@@@@@@@@@@P$JB0,KA 0A
@PD@@@@@@@DIB 4NCP(IC1@Q@P@@@@@@D!!LT@QPSD!!@UD@D@@@@@@@DVE0DXE <YF!!$O@P@@@@@@@Q,\GPDPFQ(YD@D@@@@@@@D^@Q< HQ$"FRD @P@@@@@A
H2P%DA$&F"XYD@D@@@@@@R\(JR(+KB4,J2(A@@@@@@@A@PD.J"(*J"(.@@@@@@@@@@@@@PDA@PDA@P@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 255 248 248 240 184 96 239 168 56 239 168 64 240 192 96 255 232 176 239 176 56 255 232 168 240 184 56 255 240 176 255 240 200 239 184 56 255 248 240 255 248 224 239 192 136 224 160 88 239 200 160 255 216 136 240 200 64 255 240 184 255 248 208 255 224 128 255 208 96 255 200 88 255 216 128 80 40 0 191 168 120 207 208 240 176 168 120 128 168 208 80 104 136 224 176 120 239 192 96 208 152 56 128 160 184 176 176 184 95 112 136 239 192 120 176 192 200 79 96 120 207 200 208 207 128 48 255 224 144 240 216 136 176 144 80 224 200 160]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@_@C>@_<A?0G?0_? ?>C?<G?0_?!!?>G?8O?@G<@@@b') ; yourself); yourself]
! !

!GenericToolbarIconLibrary class methodsFor:'image specs-versions'!

versionMerged24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self versionMerged24x24 inspect
     ImageEditor openOnClass:self andSelector:#versionMerged24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:'GenericToolbarIconLibrary class versionMerged24x24'
	ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@!!LNDADQE!!XVF!!0_H2D$H2@ H18"H!!8AO=SZ6]''\7^C"8.[&9.#*;N?2;_W6>]HXU^''.;.;.<OS4=OS4=?_8>O#;?O;=?>\RTMOM3L3K2<3M3<?Q5=/^8^W)
9.[1:=T]Q<N:.[&8.K?A/\GA1LSG1<+J5-#$7<8VR*:.,+N6-+&9.[2<0LC@0LC@0<#B4L$ON:J*****+:.+*;N1-[V5-;.;0LB=1+8VN*J\)JF!!)JR#*J"+
*:6-,[V5-+&9/;@MNIBQ$)JY$)JY''):^(:N#*J"/)+J/-I4LNXNK#H.N!!)JT$)JR%).[&Y.&)*J&*YLTM6&H"H"H"H.N#(:N#9BP$IZV&*JZ&8(UMU5,\8E9
 V=2^XRH"8.K"8:O#9*V%''4UMT%HV6I1\WE1\W9/^XNC (NH"H.K#G@YM$EAP45_W&11[7E1^GM8\7M: (M3"VLULDMCRDMAP45[V6I"X&I"[F1,X''91_5 K
LDMQUEEMRDMCPUQTW6!!+]&I,[HE5[D0KLU)ST5M(W5)TTT5MTUEQUE)SW6-SYC4JL65ST5MST5MST5MSS$9NS$9HQD9DRC8JLVI1[FI"X&I WE1ST5M[ZF!!_
UEQNS30GLFI,\V11\W!!,X&I"Y&I!!W%9^T5MSWS0HLH]:^&93[798[G9/\V1,X&I!!WFA\Y30EMIF,%9RK_G%9\&=/[6=1[&91[GV@]DHDJ9>6+)2P"8"A!!7=?
_7=?_7=?\7Q.^4@CA"X-I2\''I2</JR$)JR (JB (K"4,J"T@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[28 1 19 26 0 23 36 0 35 57 0 48 55 1 50 58 0 51 61 0 54 57 3 52 56 0 54 63 0 57 64 0 58 63 0 62 67 3 66 66 0 68 69 5 67 70 6 68 70 0 72 71 0 73 57 15 60 65 17 63 72 9 70 79 0 77 70 0 74 72 0 75 61 25 59 81 2 79 74 13 71 74 1 77 76 4 79 70 15 72 66 23 68 78 7 81 75 19 76 81 12 83 61 25 67 75 21 77 78 23 79 91 5 94 114 6 111 122 0 119 124 0 121 130 0 123 118 0 120 110 25 104 119 0 122 119 17 114 120 0 123 125 20 115 129 2 127 135 0 131 137 0 134 139 0 136 125 26 118 138 1 141 137 22 130 142 9 143 138 16 142 139 31 136 142 22 145 145 26 147 147 16 155 154 0 166 159 22 161 128 73 126 148 48 147 186 0 187 155 40 156 187 0 189 196 0 193 188 0 190 188 0 191 156 31 162 189 0 192 180 0 187 157 32 163 198 0 197 164 20 172 191 4 193 200 0 200 182 3 189 156 57 155 193 9 194 202 0 202 203 0 204 196 13 195 152 66 152 194 0 199 205 0 206 164 41 168 206 0 207 197 17 195 195 0 201 207 0 208 188 16 192 196 0 202 198 20 195 207 0 209 196 0 203 197 0 204 167 45 171 199 23 196 198 0 205 208 0 211 192 23 194 200 26 196 189 0 201 199 2 206 201 29 196 203 7 208 202 31 197 192 5 203 200 0 210 173 52 176 206 13 209 201 0 211 195 11 204 199 33 198 214 18 211 204 36 198 201 0 212 208 17 210 202 0 213 197 15 205 190 33 195 203 0 214 184 47 187 210 21 211 202 39 200 208 41 201 211 24 212 200 22 207 202 25 208 214 28 214 204 28 209 198 1 216 207 47 203 207 31 211 200 45 202 185 65 187 208 33 212 198 32 208 209 35 213 210 38 214 212 40 215 213 42 216 207 55 208 202 40 211 193 73 194 214 44 217 205 42 213 216 46 218 213 28 223 206 44 214 208 47 215 220 49 221 214 62 214 221 51 222 192 87 193 210 50 217 206 83 201 215 64 215 211 51 218 224 55 224 213 53 219 217 67 217 227 58 226 218 68 218 215 56 221 218 58 223 213 80 212 220 71 220 219 60 224 229 62 229 220 61 225 231 64 230 223 74 222 201 96 202 222 63 226 224 75 223 225 76 224 218 85 217 224 65 228 226 78 224 224 67 229 218 77 222 228 80 226 229 82 227 226 70 231 230 83 228 223 81 226 211 105 211 225 92 223 233 85 230 226 93 224 224 84 228 231 75 235 227 95 225 234 87 232 219 94 223 230 98 228 228 89 232 217 106 222 234 102 232 225 100 229 226 101 230 228 104 232 213 116 219 229 105 233 231 107 235 224 114 229 199 149 203 242 102 244 216 137 220 205 135 215 237 113 241 234 128 234 238 114 242 223 126 229 226 134 228 236 130 236 225 128 231 229 131 234 240 134 239 233 117 242 230 133 236 239 128 243 236 143 238 238 145 239 238 123 247 243 133 247 238 146 240 215 161 223 241 148 243 250 144 249 235 156 239 225 155 235 237 158 241 229 163 235 249 142 255 242 161 245 247 149 252 238 154 246 246 170 245 249 151 254 249 153 255 238 170 243 230 176 238 245 161 253 247 163 255 236 181 244 245 166 255 243 172 253 245 190 253 243 184 254 246 193 255 238 193 253]; yourself]
! !

!Image methodsFor:'inspecting'!

inspector2TabImage
    "an extra tab showing the image;
     Q: is this needed? (the displayObject tab already shows this)"
    
    ^ self newInspector2Tab
        label: 'Image';
        priority: 50;
        view: ((HVScrollableView for:ImageView) image: self; yourself)

    "Created: / 11-10-2011 / 17:12:01 / cg"
! !

!Image methodsFor:'inspecting'!

inspector2TabImageCreatorClass
    <inspector2Tab>

    |name className s ownerClass ownerSelector |
    
    (name := Icon nameIfKnownIcon:self) isNil ifTrue:[^ nil].

    s := name readStream.
    className := s upToSeparator.
    (ownerClass := Smalltalk classNamed: className) isNil ifTrue:[^ nil].
    s skipSeparators.
    ownerSelector := s upToSeparator.
    ownerSelector = 'class' ifTrue:[
        ownerClass := ownerClass theMetaclass.
        ownerSelector := ''.
        s skipSeparators.
    ].    
    ownerSelector := ownerSelector , s upToEnd.
    ownerSelector knownAsSymbol ifFalse:[^ nil].
    ownerSelector := ownerSelector asSymbol.
    
    (ownerClass implements:ownerSelector) ifFalse:[
        ownerClass := ownerClass isMeta ifTrue:[ ownerClass theNonMetaclass] ifFalse:[ ownerClass theMetaclass ].
        (ownerClass implements:ownerSelector) ifFalse:[
            ^ nil
        ].
    ].

    ^ Tools::Inspector2Tab 
        toBrowseClass:ownerClass selector:ownerSelector label:'Image Creator'

    "
     ToolbarIconLibrary systemBrowserIcon inspect
    "
! !

!Image methodsFor:'inspecting'!

inspector2Tabs
    |tabs|
    
    tabs := super inspector2Tabs.
    tabs := tabs copyWithout:#inspector2TabDisplayObject.
    ^ tabs copyWith:#inspector2TabImage

    "Created: / 11-10-2011 / 17:11:21 / cg"
    "Modified: / 13-02-2015 / 21:02:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Image methodsFor:'misc ui support'!

inspectorClass
    "redefined to launch an ImageInspector
     (instead of the default InspectorView)."

    (width notNil and:[height notNil]) ifTrue:[
	^ ImageInspectorView
    ].
    ^ super inspectorClass

    "Modified: 10.6.1996 / 18:23:55 / cg"
! !

!Image methodsFor:'inspecting'!

inspectorExtraAttributes
    |d name|

    d := super inspectorExtraAttributes.
    (name := Icon nameIfKnownIcon:self) notNil ifTrue:[
        d add:'-origin (comes from)' -> [ name ]
    ].    
    ^ d

    "
     ToolbarIconLibrary systemBrowserIcon inspect
    "
! !

!Image methodsFor:'inspecting'!

inspectorExtraMenuOperations
    ^ super inspectorExtraMenuOperations,
    {
        { 'Edit Image' . [ ImageEditor openOnImage:self ] } .
        { '-' . nil } .
        { 'Save As...' . [ 
                            Dialog  
                                ask:[ Dialog requestFileNameForSave:'Save image as?' default:'newImage.png' ] 
                                ifNotNilOrEmptyDo:[:file | self saveOn: file ]
                         ] }
    }
! !

!ImmutableArray methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    self size == 0 ifTrue:[
        ^ '#() immutable'
    ].
    ^ super inspectorValueStringInListFor:anInspector
! !

!Integer methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    |attr highBit|

    attr := super inspectorExtraAttributes.
    attr
        add:'-hexadecimal' -> [ self radixPrintStringRadix:16 ];
        add:'-octal' -> [ self radixPrintStringRadix:8 ];
        add:'-binary' -> [ self radixPrintStringRadix:2 ].

    highBit := self highBit.
    (#(8 16 32 64) includes:highBit) ifTrue:[
        attr
            add:('-signed i%1' bindWith:highBit)
                -> [ highBit == 8 ifTrue:[self signExtendedByteValue]
                     ifFalse:[ highBit == 16 ifTrue:[self signExtendedShortValue]
                     ifFalse:[ highBit == 32 ifTrue:[self signExtendedLongValue]
                     ifFalse:[ self signExtendedLongLongValue]]]].
    ].    
    ^ attr    

    "
     123 inspect
     128 inspect
     16r8000 inspect
     16r80000000 inspect
     16r8000000000000000 inspect
     16rAFFEAFFEAFFEAFFE inspect
    "

    "Created: / 18-09-2006 / 21:22:46 / cg"
    "Modified: / 26-02-2016 / 19:36:15 / cg"
! !

!Interval methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self printString
! !

!Iterator methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list. 
     Redefined to avoid calling the iterator"

    ^ self classNameWithArticle
! !

!LibraryDefinition class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    self theNonMetaclass isLibraryDefinition ifTrue:[^ #libraryDefinitionClassIcon ].
    ^ super iconInBrowserSymbol

"/        (c == LibraryDefinition) ifTrue:[
"/            aClass ~~ LibraryDefinition ifTrue:[
"/                ^ self packageIconSmall
"/            ].
"/        ].
! !

!LimitedPrecisionReal methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ super inspectorExtraAttributes
        add:'-binary' ->
            [
                String
                    streamContents:[:s |
                        self byteSize to:1 by:-1 do:[:i |
                            (((self basicAt:i) printStringRadix:2) paddedTo:8 with:$0)
                                printOn:s.
                            s space.    
                        ]
                    ]
            ];
        add:'-hex' ->
            [
                String
                    streamContents:[:s |
                        self byteSize to:1 by:-1 do:[:i |
                            (((self basicAt:i) printStringRadix:16) paddedTo:2 with:$0)
                                printOn:s
                        ]
                    ]
            ];
        yourself

    "Created: / 20-03-2012 / 22:34:46 / cg"
! !

!MenuView methodsFor:'accessing-behavior'!

shortKeys
    ^ shortKeys

    "Created: / 18-10-2008 / 19:16:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Method methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ super inspectorExtraAttributes
        add:'-code' -> [ String streamContents:[:s | self decompileTo:s] ];
        add:'-source' -> [ self source ];
        yourself

    "
     (Method compiledMethodAt:#inspectorExtraAttributes) inspect
    "

    "Created: / 18-09-2006 / 21:34:01 / cg"
    "Modified: / 06-10-2006 / 13:57:33 / cg"
! !

!Method methodsFor:'printing & storing'!

printStringForBrowserWithSelector:selector inClass:aClass
    "return a printString to represent myself to the user in a browser.
     Defined here to allow for browsers to deal with nonStandard pseudoMethods"

    |s privInfo moreInfo p info n cls ns currentChangeSet isInChangeSet mthdPackage
     userPreferences shownSelector suppressPackage timeRounded shadowsOrNot overAllCount|

    moreInfo := ''.
    privInfo := ''.
    userPreferences := UserPreferences current.

    ns := self nameSpace.
    (ns notNil and:[ns isNameSpace]) ifTrue:[
        moreInfo := moreInfo , 
            ((' < %1 >' bindWith: ns name) asText emphasisAllAdd:
                userPreferences emphasisForNamespacedCode)

    ].

    self isWrapped ifTrue:[
        (MessageTracer isCounting:self) ifTrue:[
            (MessageTracer isCountingByReceiverClass:self) ifTrue:[
                overAllCount := (MessageTracer executionCountOfMethod:self).
                moreInfo := moreInfo , (' (cnt: %1' bindWith:overAllCount printString allBold).
                overAllCount ~~ 0 ifTrue:[
                    (MessageTracer executionCountsByReceiverClassOfMethod:self) keysAndValuesDo:[:cls :cnt |
                        |clsName percentage|

                        clsName := cls name.
                        percentage := ((cnt / overAllCount) * 100) rounded.
                        moreInfo := moreInfo , ('; %1->%2%%' bindWith:clsName with:percentage).
                    ].
                ].
                moreInfo := moreInfo , ')'.
            ] ifFalse:[
                (MessageTracer isCountingMemoryUsage:self) ifTrue:[
                    moreInfo := moreInfo , (' (mem: %1 bytes avg)' bindWith:(MessageTracer memoryUsageOfMethod:self) printString allBold).
                ] ifFalse:[
                    moreInfo := moreInfo , (' (cnt: %1)' bindWith:(MessageTracer executionCountOfMethod:self) printString allBold).
                ]
            ].
        ] ifFalse:[
            (MessageTracer isTiming:self) ifTrue:[
                info := MessageTracer executionTimesOfMethod:self.
                ((n := info count) == 0) ifTrue:[
                    moreInfo := moreInfo , (' (cnt: %1)' bindWith:n)
                ] ifFalse:[
                    timeRounded := [:millis |
                        |rnd|
                        rnd := (millis > 100)
                                 ifTrue:[ 1 ]
                                 ifFalse:[
                                     (millis > 10)
                                        ifTrue:[ 0.1 ]
                                        ifFalse:[
                                            (millis > 1)
                                                ifTrue:[ 0.01 ]
                                                ifFalse:[ 0.001 ]]].
                        millis roundTo:rnd
                    ].

                    (n == 1 or:[ info avgTimeRounded = info minTimeRounded  ]) ifTrue:[
                        moreInfo := moreInfo ,
                                    (' (t: %1ms cnt: %2)'
                                        bindWith:((timeRounded value:info avgTimeRounded) printString allBold)
                                        with:n)
                    ] ifFalse:[
                        moreInfo := moreInfo ,
                                    (' (avg: %1ms min: %2 max: %3 cnt: %4)'
                                        bindWith:((timeRounded value:info avgTimeRounded) printString allBold)
                                        with:((timeRounded value:info minTimeRounded) printString)
                                        with:((timeRounded value:info maxTimeRounded) printString)
                                        with:n)
                    ].
                ].
            ] ifFalse:[
                moreInfo := ' !!'
            ]
        ].
    ].
    p := self privacy.

    p ~~ #public ifTrue:[
        privInfo := (' (* ' , p , ' *)') allItalic.
    ].

"/    self isInvalid ifTrue:[
"/        moreInfo := ' (** not executable **)'.
"/    ].

    (self isLazyMethod not and:[self isUnloaded]) ifTrue:[
        moreInfo := ' (** unloaded **)'
    ].

    privInfo size ~~ 0 ifTrue:[
        moreInfo := privInfo , ' ' , moreInfo
    ].

    s := shownSelector := (self selectorPrintStringInBrowserFor:selector class:aClass).

    (cls := aClass) isNil ifTrue:[
        cls := self containingClass
    ].

    currentChangeSet := ChangeSet current.
    isInChangeSet := currentChangeSet includesChangeForClass:cls selector:selector.

    isInChangeSet ifTrue:[
        s := s asText emphasisAllAdd:(userPreferences emphasisForChangedCode)
    ].

    (cls isNil or:[(mthdPackage := self package) ~= cls package]) ifTrue:[
        suppressPackage := false.
        mthdPackage = PackageId noProjectID ifTrue:[
            mthdPackage := '?'.
            "/ suppressPackage := true
        ].
        suppressPackage ifFalse:[
            shadowsOrNot := (self isShadowingExtension)
                                ifTrue:[' shadowed' ]
                                ifFalse:[ '' ].
            p := ' [' , (((mthdPackage ? '?'), shadowsOrNot allBold),' ') allItalic , '] '.
            p := p asText emphasisAllAdd:(userPreferences emphasisForDifferentPackage).
            s := s , ' ' , p
        ].
    ].

    moreInfo size == 0 ifTrue:[^ s].

    s := shownSelector , moreInfo.

    self isInvalid ifTrue:[
        s := s asText emphasizeAllWith:(userPreferences emphasisForObsoleteCode).
    ].
    ^ s

    "Modified: / 23-01-1998 / 13:15:15 / stefan"
    "Created: / 05-02-2000 / 22:55:56 / cg"
    "Modified: / 05-03-2007 / 16:18:53 / cg"
    "Modified: / 20-07-2010 / 15:39:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'printing & storing'!

selectorPrintStringInBrowserFor:selector
    ^ selector
! !

!Method methodsFor:'printing & storing'!

selectorPrintStringInBrowserFor:selector class:aClass
    |selPart idx|

    (selector isSymbol and:[selector isNameSpaceSelector]) ifFalse:[^ selector].

    idx := selector indexOf:$: startingAt:3.
    "
    nsPart := selector copyFrom:2 to:idx-1.
    ns := Smalltalk at:nsPart asSymbol.
    "
    selPart := selector copyFrom:idx+2.
    ^ selPart ", ' {',nsPart,'}'."

    "Modified: / 20-07-2010 / 10:33:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodDictionary methodsFor:'misc ui support'!

inspectorClass
    "redefined to use DictionaryInspector
     (instead of the default Inspector)."

    ^ DictionaryInspectorView

    "Created: 12.6.1996 / 12:29:13 / stefan"
! !

!MultiImage methodsFor:'misc ui support'!

inspectorClass
    "redefined to launch an ImageInspector
     (instead of the default InspectorView)."

    (self width notNil and:[self height notNil]) ifTrue:[
        ^ ImageInspectorView
    ].
    ^ super inspectorClass
! !

!NameSpace class methodsFor:'misc ui support'!

inspectorClass
    "{ Pragma: +optSpace }"

    "redefined to launch a DictionaryInspector
     (instead of the default Inspector)."

    ^ DictionaryInspectorView


! !

!NonPositionableExternalStream methodsFor:'inspecting'!

inspectorExtraMenuOperations
    "extra operation-menu entries to be shown in an inspector.
     Answers a collection of pairs contining aString and action aBlock.
     aString is the label of the menu item.
     aBlock is evaluated when the menu item is selected.
     To be redefined in objects which think that it makes sense to offer
     often used operations in an inspector.
     See SerialPort as an example."

    |superItems|
    
    superItems := super inspectorExtraMenuOperations.
    (self == Stdin or:[self == Stdout or:[self == Stderr]]) ifTrue:[        
        ^ superItems
    ].
    ^ superItems , 
            {
                { 'Close Stream' . [self close] }
            }.
! !

!Notification class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    ^ #notificationClassBrowserIcon
! !

!Object methodsFor:'inspecting'!

inspector2TabClass
    <inspector2Tab>

    ^ Tools::Inspector2Tab toBrowseClass:self class theNonMetaclass selector:nil label:'Class'
    
"/    |makeView|
"/
"/    makeView := [
"/        |spec view browser navigationState cls canvas|
"/
"/
"/        view isNil ifTrue:[
"/            "/ spec := #singleClassBrowserSpec.
"/            spec := #multipleClassBrowserSpec.
"/
"/            browser := Tools::NewSystemBrowser new
"/                           isEmbeddedBrowser:true;
"/                           createBuilder.
"/
"/            navigationState := browser navigationState.
"/            navigationState canvasType:spec.
"/            browser browserCanvasType:spec.
"/
"/            canvas := browser browserCanvas value.
"/            canvas builder:(browser builder).
"/            navigationState canvas:canvas.
"/            "/ browser switchToClassHierarchyView.
"/            "/ browser showInheritedMethods.
"/
"/            cls := self class theNonMetaclass.
"/            browser classListGenerator value:(cls withAllSuperclasses).
"/            browser sortByNameAndInheritance value:true.
"/            browser
"/                selectClass:cls;
"/                selectProtocol: (Tools::BrowserList nameListEntryForALL).  
"/            view := ApplicationSubView new client: browser spec: spec.
"/            navigationState classListApplication addOwnerClasses value:false.
"/        ].
"/        view
"/    ].
"/
"/    ^  Tools::Inspector2Tab new
"/            priority: 0;
"/            label:'Class';
"/            viewHolder: makeView;
"/            yourself

    "Created: / 03-02-2015 / 11:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'inspecting'!

inspector2TabCommon
    "a tab, showing the old inspector"

    ^ self inspector2TabForInspectorClass

    "Created: / 24-05-2011 / 14:56:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 14:06:28 / cg"
! !

!Object methodsFor:'inspecting'!

inspector2TabDisplayObject
    ^ self newInspector2Tab
        label: 'DisplayObject';
        priority: 50;
        view: ((HVScrollableView for:DisplayObjectView) model: self; yourself)

    "Created: / 11-10-2011 / 17:12:01 / cg"
! !

!Object methodsFor:'inspecting'!

inspector2TabForBasicInspect
    "a tab, showing the old basic inspector"

    ^ Tools::Inspector2Tab new
            priority: 90;
            label:'Basic';
            view: (InspectorView new inspect:self);
            yourself

    "Created: / 05-07-2011 / 13:59:59 / cg"
! !

!Object methodsFor:'inspecting'!

inspector2TabForInspectorClass
    "a tab, showing the old inspector"

    ^ Tools::Inspector2Tab new
            priority: 100;
            label:(self inspector2TabLabel);
            view: (self inspectorClass new inspect:self);
            yourself

    "Created: / 05-07-2011 / 14:06:16 / cg"
! !

!Object methodsFor:'inspecting'!

inspector2TabLabel
    "label of the main tab"

    ^ 'Object'

    "Created: / 14-07-2011 / 11:56:23 / cg"
! !

!Object methodsFor:'inspecting'!

inspector2Tabs
    | tabs |

    tabs := self inspectorClass ~~ Inspector 
                ifTrue:[#( inspector2TabCommon inspector2TabForBasicInspect )]
                ifFalse:[#( inspector2TabCommon )].

    (self isString not
     and:[ (self class whichClassIncludesSelector:#displayOn:x:y:) ~~ Object
           or:[(self class whichClassIncludesSelector:#displayOn:x:y:opaque:) ~~ Object
           or:[(self class whichClassIncludesSelector:#displayOpaqueOn:x:y:) ~~ Object]]]) ifTrue:[
        tabs := tabs copyWith:#inspector2TabDisplayObject.
    ].

    "/ Workaround for stc bug
    ((self class lookupMethodFor: #inspector2TabClass) annotationAt: #inspector2Tab) isNil ifTrue:[ 
        tabs := tabs copyWith:#inspector2TabClass
    ].
    ^ tabs

    "
    1 inspect
    self inspect
    "

    "Created: / 05-07-2011 / 13:39:24 / cg"
    "Modified: / 04-02-2015 / 15:12:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector.
     Answers a dictionary of aString -> aBlock.
     aString is name of extra attribute and MUST start with minus ($-).
     aBlock returns the object representing extra attribute."

    ^ Dictionary new.

    " Try to uncomment following and inspect any object "

"/    ^ Dictionary new
"/        add:'-now' -> ['Now: ' , Time now printString];
"/        yourself

    "Created: / 16-08-2005 / 20:43:33 / janfrog"
    "Modified: / 02-09-2005 / 19:00:01 / janfrog"
    "Modified: / 04-10-2006 / 14:33:34 / cg"
! !

!Object methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list.
     Only to be redefined where it is guaranteed, that the returned string is short."

    ^ self classNameWithArticle

    "Created: / 13-06-2012 / 12:50:26 / cg"
! !

!Object methodsFor:'testing'!

isTestCaseLike

    ^false

    "Created: / 28-02-2011 / 21:30:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'debugging'!

newInspector2Tab
    "return an extra tab to be used inside an inspector"

    "Use Smalltalk>>at: to trick the dependency detector"
     ^ (Smalltalk at: #'Tools::Inspector2Tab') new.
! !

!OrderedCollection methodsFor:'misc ui support'!

inspectorClass
    "redefined to launch an OrderedCollectionInspector
     (instead of the default InspectorView)."

    ^ OrderedCollectionInspectorView

    "
     (OrderedCollection withAll:#(3 2 1)) inspect
     (OrderedCollection withAll:#(3 2 1)) removeFirst; yourself; inspect
     #(0 8 15 3 99 2) asSortedCollection inspect
    "
! !

!Point methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self printString
! !

!PopUpMenu methodsFor:'converting'!

asMenu
    "convert myself into a newStyle Menu instance, from which a MenuPanel is created.
     The old PopUpMenu and MenuView is going to be obsoleted (but still supported
     for backward compatibility)"

    | menu  |

    menu := Menu new receiver: menuView receiver.
    1 to: self numberOfItems do:[:i| 
        | menuItem subMenu lbl checkHolder|

        lbl := (self labels at: i).
        (lbl includesString:'\c') ifTrue:[
            lbl := lbl copyReplaceString:'\c' withString:''.
            checkHolder := ValueHolder with:(menuView checkToggleAt:i).
        ].

        menuItem := MenuItem new
                        label: lbl
                        itemValue: (menuView selectors at: i)
                        enabled: (menuView isEnabled: i).
        menuItem shortcutKey: (menuView shortKeys at: i).

        (subMenu := self subMenuAt: i) notNil ifTrue:[
            menuItem submenu: subMenu asMenu
        ].
        checkHolder notNil ifTrue:[
            checkHolder onChangeEvaluate:[ 
                menuView receiver perform:(menuView selectors at: i) with:checkHolder value 
            ].
            menuItem indication:checkHolder.
            menuItem hideMenuOnActivated:false.
        ].
        menu addItem: menuItem.
    ].
    ^ menu.

    "Created: / 18-10-2008 / 19:01:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-09-2012 / 13:10:25 / cg"
! !

!ProfileTree methodsFor:'accessing'!

method

    class ifNil:[^nil].
    ^class >> selector

    "Created: / 01-12-2007 / 22:50:16 / janfrog"
    "Modified: / 07-11-2008 / 08:40:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProfileTree methodsFor:'accessing'!

package

    self method ifNil:[^nil].
    ^self method package

    "Created: / 01-12-2007 / 22:50:28 / janfrog"
    "Modified: / 07-11-2008 / 08:40:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'displaying'!

displayString
    ^ self name

    "Created: / 26-10-2013 / 00:52:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'accessing'!

toolbox
    "Answer a toolbox for receiver. A toolbox is used by language-agnostic tools (such as
     class browser) to perform language-specific tasks (search for implementors,
     build implementor menu and so on. If nil is returned, no toolbox available"

    ^ self toolboxClass new.

    "Created: / 31-08-2013 / 10:15:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-02-2014 / 16:32:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'accessing-classes'!

toolboxClass
    "Answer a 'toolbox class'. A toolbox is used by language-agnostic tools (such as
     class browser) to perform language-specific tasks (search for implementors,
     build implementor menu and so on. If nil is returned, no toolbox available"

    ^ Tools::GenericToolbox

    "Created: / 31-08-2013 / 10:07:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-02-2014 / 16:32:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    self theNonMetaclass isApplicationDefinition ifTrue:[
        self theNonMetaclass isGUIApplication ifTrue:[
            ^ #guiApplicationDefinitionClassIcon
        ].
        ^ #applicationDefinitionClassIcon
    ].
    ^ super iconInBrowserSymbol
! !

!Query class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    ^ #queryClassBrowserIcon
! !

!Rectangle methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self origin printString,'->',self corner printString
! !

!RunArray methodsFor:'misc ui support'!

inspectorClass
    "Re-reimplemented so that we don't get an ordered collection inspector
     which would get very confused when confronted with a runArray."

    ^ InspectorView

    "Modified: / 30.10.1997 / 14:28:20 / cg"
! !

!SelectionInListModelView methodsFor:'accessing'!

textStartLeft
    ^ textStartLeft
! !

!SelectionInListModelView methodsFor:'accessing'!

textStartLeft:something
    textStartLeft := something.
! !

!Set methodsFor:'misc ui support'!

inspectorClass
    "redefined to use SetInspector
     (instead of the default Inspector)."

    ^ SetInspectorView
! !

!SharedPool class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    self == SharedPool ifTrue:[^ super iconInBrowserSymbol].
    ^ #sharedPoolBrowserIcon

    "Created: / 14-10-2010 / 12:04:32 / cg"
! !

!SimpleView methodsFor:'inspecting'!

inspectorExtraAttributes
    ^ super inspectorExtraAttributes
        add:'-windowGroup' -> [ self instVarNamed:#windowGroup ];
        add:'-sensor' -> [ self instVarNamed:#sensor ];
        add:'-parent' -> [ self instVarNamed:#container ];
        add:'-hidden' -> [ self isHiddenOnRealize ];
        add:'-enabled' -> [ self enabled ];
        
        yourself
! !

!SimpleView methodsFor:'testing'!

isCodeView2
    "codeview2 seems to require some extra hacks"

    ^ false

    "Created: / 20-07-2010 / 15:42:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    self isAbstract ifTrue:[
        ^ #abstractWindowClassBrowserIcon
    ].    
    ^ #windowClassBrowserIcon
! !

!SmallInteger methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    |extra int |
    
    int := self.
    extra := super inspectorExtraAttributes.
    self < 0 ifTrue:[
        extra     
            add:'-hexadecimal (unsigned)' -> [ int asUnsignedInt radixPrintStringRadix:16 ].
    ].
    ^ extra

    "
     123 inspect
     -123 inspect
    "

    "Created: / 18-09-2006 / 21:22:46 / cg"
    "Modified: / 06-10-2006 / 13:57:28 / cg"
! !

!Smalltalk class methodsFor:'misc ui support'!

inspectorClass
    "redefined to use DictionaryInspector
     (instead of the default Inspector)."

    ^ DictionaryInspectorView
! !

!SmalltalkLanguage methodsFor:'accessing-classes'!

compilerClassForInteractiveTools
    "Answer a compiler class suitable for usage in interactive tools. 
     Such class may better integrate into the IDE and register for undo/redo
     and/or do more checks and so on. Defaults to #compilerClass"

    ^ SmalltalkCodeGeneratorTool

    "Created: / 05-08-2014 / 16:01:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SocketAddress methodsFor:'printing & storing'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self printString
! !

!StandaloneStartup class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    false "self isAbstract" ifFalse:[
        self isHeadless ifTrue:[
            ^ #standaloneStartupHeadlessIcon 
        ].
        ^ #standaloneStartupIcon 
    ].
    ^ super iconInBrowserSymbol
! !

!StringCollection methodsFor:'inspecting'!

inspector2TabText

    ^self newInspector2Tab
        label: 'String';
        priority: 25;
        view: ((ScrollableView for:TextView) contents: self asString; yourself)

    "Created: / 17-02-2008 / 10:13:07 / janfrog"
! !

!StringCollection methodsFor:'inspecting'!

inspector2Tabs
    ^ super inspector2Tabs , #( inspector2TabText )

    "Created: / 05-07-2011 / 13:40:43 / cg"
    "Modified: / 13-02-2015 / 21:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Symbol methodsFor:'accessing'!

formattedCode
    "private helper for the CodeGenerator"

    ^self

    "Created: / 07-07-2009 / 20:03:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Symbol methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self storeString
! !

!Text methodsFor:'inspecting'!

inspector2TabText

    ^self newInspector2Tab
        label: 'Text';
        priority: 50;
        view: ((ScrollableView for:EditTextView) contents: self; yourself)

    "Created: / 17-02-2008 / 09:03:36 / janfrog"
    "Modified: / 17-02-2008 / 10:28:33 / janfrog"
    "Modified: / 21-08-2011 / 08:02:46 / cg"
! !

!Text methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ super inspectorExtraAttributes
        add:'-text' -> [ self ];
        yourself

    "
     'hello' allBold inspect
    "

    "Created: / 18-09-2006 / 21:25:52 / cg"
    "Modified: / 06-10-2006 / 13:57:38 / cg"
! !

!Time methodsFor:'printing & storing'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self printString
! !

!Timestamp methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ super inspectorExtraAttributes
        add:'-dayInWeek' -> [ self dayInWeek printString , ' "', self asDate dayOfWeekName , '"' ];
        add:'-dayInYear' -> [ self dayInYear ];
        add:'-daysInMonth' -> [ self asDate daysInMonth ];
        add:'-monthName' -> [ self asDate monthName ];
        add:'-weekNr' -> [ self asDate weekInYear ];
        add:'-leapYear' -> [ self asDate isLeapYear ];
        add:'-iso8601(utc)' -> [ self asUtcTimestamp printStringIso8601 ];
        yourself

    "
     Timestamp now inspect
    "

    "Created: / 20-01-2011 / 12:19:05 / cg"
! !

!Timestamp methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self printString
! !

!UUID methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ self printString
! !

!UndefinedObject methodsFor:'inspecting'!

inspectorValueStringInListFor:anInspector
    "returns a string to be shown in the inspector's list"

    ^ 'nil'
! !

!UninterpretedBytes methodsFor:'inspecting'!

inspector2Tabs
    ^ super inspector2Tabs , #( inspector2TabForHexDump )

    "Created: / 27-02-2012 / 21:51:36 / cg"
    "Modified: / 13-02-2015 / 21:03:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

alwaysOpenNewTabWhenCtrlClick

    "
        UserPreferences current alwaysOpenNewTabWhenCtrlClick 
    "


    ^ self at:#alwaysOpenNewTabWhenCtrlClick ifAbsent:false.

    "Created: / 19-10-2008 / 08:00:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-02-2010 / 19:37:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

alwaysOpenNewTabWhenCtrlClick: aBoolean

    self at:#alwaysOpenNewTabWhenCtrlClick put: aBoolean

    "Created: / 19-10-2008 / 08:01:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-pref''d tools'!

changesBrowserClassName

    ^ self
	at: #changesBrowserClassName
	ifAbsent:[self changesBrowserClass name]."/Backward comparibility

    "Created: / 03-04-2012 / 11:02:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'obsolete'!

codeView2AutoIndent
    <resource: #obsolete>

    ^self at:#codeView2AutoIndent ifAbsent: false

    "
     UserPreferences current codeView2AutoIndent 
     UserPreferences current codeView2AutoIndent:true 
     UserPreferences current codeView2AutoIndent:false"

    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 07-08-2011 / 12:46:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'obsolete'!

codeView2AutoIndent: aBoolean
    <resource: #obsolete>

    ^self at:#codeView2AutoIndent put: aBoolean

    "
     UserPreferences current codeView2AutoIndent 
     UserPreferences current codeView2AutoIndent:true 
     UserPreferences current codeView2AutoIndent:false"

    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 07-08-2011 / 12:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

codeView2ShowAcceptCancel
    "this is a little confusing: the codeview2 has its own accept/cancel bar
     (why reinvent the wheel?).
     So if this is enabled, the outer accept/cancel bar will be suppressed,
     if this is on"
    ^self at:#codeView2ShowAcceptCancel ifAbsent: false

    "
     UserPreferences current codeView2ShowAcceptCancel 
     UserPreferences current codeView2ShowAcceptCancel:true 
     UserPreferences current codeView2ShowAcceptCancel:false"

    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 10-10-2011 / 16:41:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

codeView2ShowAcceptCancel: aBoolean
    "this is a little confusing: the codeview2 has its own accept/cancel bar
     (why reinvent the wheel?).
     So if this is enabled, the outer accept/cancel bar will be suppressed,
     if this is on"

    ^self at:#codeView2ShowAcceptCancel put: aBoolean

    "
     UserPreferences current codeView2ShowAcceptCancel 
     UserPreferences current codeView2ShowAcceptCancel:true 
     UserPreferences current codeView2ShowAcceptCancel:false"

    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 10-10-2011 / 16:40:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

confirmRefactorings
    "If set, each refactoring must be confirmed before accepted.
     A programmer may select which changes to apply and which not
     and/or alter the change.

     See RefactoryChange>>shouldBeConfirmed
     "

    ^ self at:#confirmRefactorings ifAbsent:[false].

    "
     UserPreferences current confirmRefactorings
     UserPreferences current confirmRefactorings:true
     UserPreferences current confirmRefactorings:false
    "

    "Created: / 04-04-2012 / 14:02:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

confirmRefactorings:aBoolean
    "If set, each refactoring must be confirmed before accepted.
     A programmer may select which changes to apply and which not
     and/or alter the change.

     See RefactoryChange>>shouldBeConfirmed
     "

    ^ self at:#confirmRefactorings put:aBoolean

    "
     UserPreferences current confirmRefactorings
     UserPreferences current confirmRefactorings:true
     UserPreferences current confirmRefactorings:false
    "

    "Created: / 04-04-2012 / 14:02:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-pref''d tools'!

fileBrowserClass
    | class className |

    className := self at: #fileBrowserClassName ifAbsent:[nil].
    className notNil ifTrue:[
	class := Smalltalk at: className asSymbol.
	class notNil ifTrue:[ ^ class ].
    ].

    "/ Old code
    self useNewFileBrowser ifTrue:[
	^ (FileBrowserV2 ? FileBrowser)
    ].
    ^ FileBrowser

    "Modified: / 03-04-2012 / 10:59:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-pref''d tools'!

fileBrowserClass: aClass

    self at: #fileBrowserClassName put: aClass name.

    "
	UserPreferences current fileBrowserClass
	UserPreferences current fileBrowserClass: FileBrowser.
	UserPreferences current fileBrowserClass: FileBrowserV2.
    "

    "Created: / 03-04-2012 / 10:57:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-pref''d tools'!

fileBrowserClassName

    ^ self
	at: #fileBrowserClassName
	ifAbsent:[self fileBrowserClass name]."/Backward comparibility

    "Created: / 03-04-2012 / 11:01:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

showBookmarkBar
    "experimental."

    ^ self at:#showBookmarkBar ifAbsent: false "true".

    "
     UserPreferences current showBookmarkBar
     UserPreferences current showBookmarkBar:true
     UserPreferences current showBookmarkBar:false
    "

    "Created: / 18-05-2011 / 16:48:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-06-2011 / 11:01:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

showBookmarkBar: aBoolean
    "experimental."

    ^ self at:#showBookmarkBar put: aBoolean

    "
     UserPreferences current showBookmarkBar
     UserPreferences current showBookmarkBar:true
     UserPreferences current showBookmarkBar:false
    "

    "Created: / 18-05-2011 / 17:28:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

showEmbeddedTestRunnerInBrowser
    "experimental."

    ^ self at:#showEmbeddedTestRunnerInBrowser ifAbsent:true

    "
     UserPreferences current showEmbeddedTestRunnerInBrowser
     UserPreferences current showEmbeddedTestRunnerInBrowser:true
     UserPreferences current showEmbeddedTestRunnerInBrowser:false
    "

    "Created: / 11-03-2010 / 10:11:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

showEmbeddedTestRunnerInBrowser:aBoolean
    "experimental."

    ^ self at:#showEmbeddedTestRunnerInBrowser put:aBoolean

    "
     UserPreferences current showEmbeddedTestRunnerInBrowser:true
     UserPreferences current showEmbeddedTestRunnerInBrowser:false
    "

    "Created: / 11-03-2010 / 10:11:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

showGlobalHistory
    "Whether to show global history in the browser"

    ^ self at:#showGlobalHistory ifAbsent: true.

    "
     UserPreferences current showGlobalHistory
     UserPreferences current showGlobalHistory:true
     UserPreferences current showGlobalHistory:false
    "

    "Created: / 07-07-2011 / 00:03:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-07-2012 / 16:35:54 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

showGlobalHistory: aBoolean
    "Whether to show global history in the browser"

    ^ self at:#showGlobalHistory put: aBoolean

    "
     UserPreferences current showGlobalHistory
     UserPreferences current showGlobalHistory:true
     UserPreferences current showGlobalHistory:false
    "

    "Created: / 07-07-2011 / 00:02:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-07-2012 / 16:35:57 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

showLocalHistory
    "Whether to show local (per tab) history in the browser"

    ^ self at:#showLocalHistory ifAbsent: true.

    "
     UserPreferences current showLocalHistory
     UserPreferences current showLocalHistory:true
     UserPreferences current showLocalHistory:false
    "

    "Created: / 07-07-2011 / 00:02:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-07-2012 / 16:35:31 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

showLocalHistory: aBoolean
    "Whether to show local (per tab) history in the browser"

    ^ self at:#showLocalHistory put: aBoolean

    "
     UserPreferences current showLocalHistory
     UserPreferences current showLocalHistory:true
     UserPreferences current showLocalHistory:false
    "

    "Created: / 07-07-2011 / 00:02:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-07-2012 / 16:35:41 / cg"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

showMethodTemplate
    "experimental."

    ^ self at:#showMethodTemplate ifAbsent:true

    "
     UserPreferences current showMethodTemplate
     UserPreferences current showMethodTemplate:true
     UserPreferences current showMethodTemplate:false
    "

    "Created: / 12-02-2010 / 12:06:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

showMethodTemplate:aBoolean
    "experimental."

    ^ self at:#showMethodTemplate put:aBoolean

    "
     UserPreferences current showMethodTemplate:true
     UserPreferences current showMethodTemplate:false
    "

    "Created: / 12-02-2010 / 12:05:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

sortAndIndentClassesByInheritance

    ^ self at:#sortAndIndentClassesByInheritance ifAbsent: false

    "
     UserPreferences current sortAndIndentClassesByInheritance
     UserPreferences current sortAndIndentClassesByInheritance:true
     UserPreferences current sortAndIndentClassesByInheritance:false
    "

    "Created: / 06-07-2011 / 19:09:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

sortAndIndentClassesByInheritance: aBoolean

    ^ self at:#sortAndIndentClassesByInheritance put: aBoolean

    "
     UserPreferences current sortAndIndentClassesByInheritance
     UserPreferences current sortAndIndentClassesByInheritance:true
     UserPreferences current sortAndIndentClassesByInheritance:false
    "

    "Created: / 06-07-2011 / 19:09:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

sourceCodeManagementMenuLayout

    "Defines the layout of source code management menus in 
     NewSystemBrowser. Can be one of:
        #old        - old style as of 2011-10-06
        #compact    - only one Repository menu, SCM specific menus underneath
        #inline     - Repository and then SCM specific menus inlined
    "

    ^ self at:#sourceCodeManagementMenuLayout ifAbsent: #inline "/ #old

    "
     UserPreferences current sourceCodeManagementMenuLayout
     UserPreferences current sourceCodeManagementMenuLayout: #inline
     UserPreferences current sourceCodeManagementMenuLayout: #compact
     UserPreferences current sourceCodeManagementMenuLayout: #old
    "

    "Created: / 06-10-2011 / 18:42:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

sourceCodeManagementMenuLayout: aSymbol

    "Defines the layout of source code management menus in 
     NewSystemBrowser. Can be one of:
        #old        - old style as of 2011-10-06
        #compact    - only one Repository menu, SCM specific menus underneath
        #inline     - Repository and then SCM specific menus inlined
    "
    self assert: (#(old compact inline) includes: aSymbol).

    ^ self at:#sourceCodeManagementMenuLayout put: aSymbol

    "
     UserPreferences current sourceCodeManagementMenuLayout
     UserPreferences current sourceCodeManagementMenuLayout: #inline
     UserPreferences current sourceCodeManagementMenuLayout: #compact
     UserPreferences current sourceCodeManagementMenuLayout: #old
    "

    "Created: / 06-10-2011 / 18:44:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

useCodeView2In: appSymbol
    "no longer used - will vanish.
     Now the use of the codeView2 is globally enabled/disabled by useCodeView2InTools"

    ^self useCodeView2InTools "/ or:[self perform: ('useCodeView2In' , appSymbol) asSymbol]. 


    "
    UserPreferences current useCodeView2In: #Browser 
    UserPreferences current useCodeView2InBrowser:true 
    UserPreferences current useCodeView2InBrowser:false

    UserPreferences current useCodeView2InTools:true
    UserPreferences current useCodeView2InTools:false
    "

    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-07-2011 / 10:26:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

useCodeView2InBrowser
    "no longer used - will vanish.
     Now the use of the codeView2 is globally enabled/disabled by useCodeView2InTools"

    <resource: #obsolete>
    ^self at:#useCodeView2InBrowser ifAbsent: false

    "
     UserPreferences current useCodeView2InBrowser 
     UserPreferences current useCodeView2InBrowser:true 
     UserPreferences current useCodeView2InBrowser:false"

    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-07-2011 / 10:22:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

useCodeView2InBrowser: aBoolean
    "no longer used - will vanish.
     Now the use of the codeView2 is globally enabled/disabled by useCodeView2InTools"

    <resource: #obsolete>
    ^self at:#useCodeView2InBrowser put: aBoolean

    "
     UserPreferences current useCodeView2InBrowser 
     UserPreferences current useCodeView2InBrowser:true 
     UserPreferences current useCodeView2InBrowser:false"

    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-07-2011 / 10:21:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

useCodeView2InDebugger
    "no longer used - will vanish.
     Now the use of the codeView2 is globally enabled/disabled by useCodeView2InTools"

    <resource: #obsolete>
    ^self at:#useCodeView2InDebugger ifAbsent: false

    "
     UserPreferences current useCodeView2InDebugger 
     UserPreferences current useCodeView2InDebugger:true 
     UserPreferences current useCodeView2InDebugger:false
    "

    "Created: / 26-07-2011 / 10:22:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

useCodeView2InDebugger: aBoolean
    "no longer used - will vanish.
     Now the use of the codeView2 is globally enabled/disabled by useCodeView2InTools"

    <resource: #obsolete>
    ^self at:#useCodeView2InDebugger put: aBoolean

    "
     UserPreferences current useCodeView2InDebugger 
     UserPreferences current useCodeView2InDebugger:true 
     UserPreferences current useCodeView2InDebugger:false"

    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-07-2011 / 10:22:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

useCodeView2InTools
    ^self at:#useCodeView2InTools ifAbsent:true "false"

    "
     UserPreferences current useCodeView2InTools 
     UserPreferences current useCodeView2InTools:true 
     UserPreferences current useCodeView2InTools:false"

    "Created: / 12-02-2010 / 12:13:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-02-2010 / 09:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

useCodeView2InTools:aBoolean 
    ^self at:#useCodeView2InTools put:aBoolean

    "
     UserPreferences current useCodeView2InBrowser:true
     UserPreferences current useCodeView2InBrowser:false"
    "Created: / 12-02-2010 / 12:14:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

useCodeView2InWorkspace
    "no longer used - will vanish.
     Now the use of the codeView2 is globally enabled/disabled by useCodeView2InTools"

    <resource: #obsolete>
    ^self at:#useCodeView2InWorkspace ifAbsent: false

    "
     UserPreferences current useCodeView2InWorkspace 
     UserPreferences current useCodeView2InWorkspace:true 
     UserPreferences current useCodeView2InWorkspace:false
    "

    "Created: / 26-07-2011 / 10:23:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

useCodeView2InWorkspace: aBoolean
    "no longer used - will vanish.
     Now the use of the codeView2 is globally enabled/disabled by useCodeView2InTools"

    <resource: #obsolete>
    ^self at:#useCodeView2InWorkspace put: aBoolean

    "
     UserPreferences current useCodeView2InWorkspace 
     UserPreferences current useCodeView2InWorkspace:true 
     UserPreferences current useCodeView2InWorkspace:false
    "

    "Created: / 26-07-2011 / 10:22:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

useInPlaceSearchInBrowserLists

    ^ self at:#useInPlaceSearchInBrowserLists ifAbsent: false

    "
     UserPreferences current useInPlaceSearchInBrowserLists
     UserPreferences current useInPlaceSearchInBrowserLists:true
     UserPreferences current useInPlaceSearchInBrowserLists:false
    "

    "Created: / 28-07-2011 / 09:34:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

useInPlaceSearchInBrowserLists: aBoolean

    ^ self at:#useInPlaceSearchInBrowserLists put: aBoolean

    "
     UserPreferences current useInPlaceSearchInBrowserLists
     UserPreferences current useInPlaceSearchInBrowserLists:true
     UserPreferences current useInPlaceSearchInBrowserLists:false
    "

    "Created: / 28-07-2011 / 09:35:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

webBrowserLikeLayout
    "experimental."

    ^ self at:#webBrowserLikeLayout ifAbsent: false

    "
     UserPreferences current webBrowserLikeLayout
     UserPreferences current webBrowserLikeLayout:true
     UserPreferences current webBrowserLikeLayout:false
    "

    "Created: / 07-06-2011 / 14:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-browser'!

webBrowserLikeLayout: aBoolean
    "experimental."

    ^ self at:#webBrowserLikeLayout put: aBoolean

    "
     UserPreferences current webBrowserLikeLayout
     UserPreferences current webBrowserLikeLayout:true
     UserPreferences current webBrowserLikeLayout:false
    "

    "Created: / 07-06-2011 / 14:31:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Warning class methodsFor:'misc ui support'!

iconInBrowserSymbol
    "the browser will use this as index into the toolbariconlibrary"

    <resource: #programImage>

    ^ #warningClassBrowserIcon
! !

!stx_libtool class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header$'
! !

