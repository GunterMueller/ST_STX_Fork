"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

ApplicationModel subclass:#SystemBrowser
	instanceVariableNames:''
	classVariableNames:'CheckForInstancesWhenRemovingClasses ClassHistory
		EmphasisForDifferentPackage EmphasisForModifiedBuffer
		EmphasisForObsoleteCode EmphasisForReadVariable
		EmphasisForWrittenVariable EmphasisForChangedCode
		LastSearchPatterns LastClassSearchBoxShowedFullName'
	poolDictionaries:''
	category:'Interface-Browsers'
!

Object subclass:#BrowserHistoryEntry
	instanceVariableNames:'className meta selector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SystemBrowser
!

!SystemBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Notice: SystemBrowser has been completely rewritten to be an instance
    of ApplicationModel. This rewritten version is found under Tools::NewSystemBrowser.
    Because the class protocol here was used by many others, it is left here
    as an instance-less functionality provider only.

    written winter 89 by claus.

    [author:]
        Claus Gittinger

"
! !

!SystemBrowser class methodsFor:'initialization'!

initialize
    "Browser configuration;
     (values can be changed from your private startup file)"

"/    self classResources.

    "
     setting this to false, the removeClass function will remove
     classes WITHOUT checking for instances. Otherwise,
     it will check and let you confirm in case there are instances.
     Checking for instances may be a bit time consuming, though.
     The default is true - therefore, it will check
    "
    CheckForInstancesWhenRemovingClasses := true

    "
     CheckForInstancesWhenRemovingClasses := true
     CheckForInstancesWhenRemovingClasses := false

     SystemBrowser initialize
    "
! !

!SystemBrowser class methodsFor:'instance creation'!

open
    "launch a standard browser"

    self == SystemBrowser ifFalse:[
        ^ super open
    ].

    ^ self openOnDevice:(Screen current) 

    "
     SystemBrowser default open
     SystemBrowser open
    "
!

openInClass:aClass
    "launch a standard browser which immediately switches
     to aClass"

    ^ self openInClass:aClass selector:nil

    "
     SystemBrowser default openInClass:Object
     SystemBrowser openInClass:Object
    "

    "Created: 30.4.1996 / 14:43:45 / cg"
!

openInClass:aClass selector:aSelector
    "launch a standard browser which immediately switches
     to aClass » aSelector. Returns the browser"

    |brwsr classesName|

    brwsr := self openOnDevice:(Screen current).
    brwsr waitUntilVisible.

    aClass notNil ifTrue:[
"/        cls := aClass.
"/        cls isMeta ifTrue:[
"/            cls := aClass soleInstance
"/        ].
        aClass isMeta ifTrue:[
            brwsr instanceProtocol:false
        ].
        aClass isJavaClass ifTrue:[
            classesName := aClass fullName. 
        ] ifFalse:[
            classesName := aClass name. 
        ].
        brwsr switchToClassNamed:classesName.
        brwsr classSelectionChanged.
        aSelector notNil ifTrue:[
            brwsr switchToMethodNamed:aSelector.
        ]
    ].
    ^ brwsr

    "
     SystemBrowser openInClass:Object selector:#at:put:
     SystemBrowser openInClass:Object selector:nil
     SystemBrowser openInClass:nil selector:nil
    "

    "Created: / 22.11.1995 / 21:04:50 / cg"
    "Modified: / 5.11.2001 / 16:51:02 / cg"
!

openOn:anEnvironment
    ^ self
        openOn:anEnvironment
        label:(self classResources string:'System Browser')

    "
     SystemBrowser default openOn:Smalltalk
     SystemBrowser default openOn:Demos

     SystemBrowser openOn:Smalltalk
     SystemBrowser openOn:Demos
    "
!

openOn:aClassEnvironment label:title
    ^ self
        openOn:aClassEnvironment 
        label:title 
        onDevice:(Screen current)
!

openOn:aClassEnvironment label:title onDevice:aDisplayDevice
    |browser|

    browser := self 
                newWithLabel:title
                setupBlock:[:browser | browser environment:aClassEnvironment.
                                       browser setupForAll]
                onDevice:aDisplayDevice.
    ^ browser
!

openOnDevice:aDisplay
    "launch a standard browser on another display."

    self == SystemBrowser ifFalse:[
        ^ super openOnDevice:aDisplay
    ].

    ^ self 
        openOn:Smalltalk
        label:(self classResources string:'System Browser')
        onDevice:aDisplay

    "|d|

     d := XWorkstation new initializeFor:'porty:0'.
     d startDispatch.
     SystemBrowser openOnDevice:d
    "
!

openOnRemoteImageOnHost:aHostName port:portOrNil
    |environment|

    environment := RemoteImage onHost:aHostName port:portOrNil.
    ^ self
        openOn:environment 
        label:(self classResources string:'RemoteImage Browser - %1' with:aHostName)

    "
     SystemBrowser openOnRemoteImageOnHost:'funkfix' port:nil
     SystemBrowser openOnRemoteImageOnHost:'192.168.8.1' port:nil
    "
!

openOnSnapShotImage:anImageFileName
    |environment|

    environment := SnapShotImage for:anImageFileName.
    ^ self
        openOn:environment 
        label:(self classResources string:'Image Browser - %1' with:anImageFileName asFilename baseName)

    "
     SystemBrowser openOnSnapShotImage:('/tmp/stmeas.img')
    "
! !

!SystemBrowser class methodsFor:'Compatibility-ST80'!

newOnClass:aClass
    ^ self browseClass:aClass

    "Created: / 27.10.1997 / 20:10:39 / cg"
! !

!SystemBrowser class methodsFor:'accessing-history'!

addToHistory:aClass selector:aSelectorOrNil
    |newEntry oldEntry classHistory|

    (newEntry := self historyEntryForClass:aClass selector:aSelectorOrNil) isNil ifTrue:[^ self].
    classHistory := self classHistory.

    oldEntry := classHistory detect:[:entry | (entry className = newEntry className) 
                                              "and:[entry selector = newEntry selector]"] ifNone:nil.
    oldEntry notNil ifTrue:[
        classHistory removeIdentical:oldEntry.
    ].
    classHistory addFirst:newEntry.
    classHistory size > self visitedHistoryMaxSize ifTrue:[
        classHistory removeLast
    ].
    SystemBrowser changed:#visitedClassHistory with:classHistory.

    "Modified: / 05-07-2011 / 16:49:57 / cg"
!

checkClassHistory
    "checks the class history for non-existing classes"

    "/ reverse, since we might modify while enumerating
    self classHistory reverseDo:[:histEntry|
        (Smalltalk at: (histEntry className) asSymbol) isBehavior
        ifFalse:[
            self classHistory removeIdentical: histEntry
        ]
    ]

    "Modified: / 20-07-2011 / 11:59:22 / cg"
!

classHistory
    ClassHistory isNil ifTrue:[
        ClassHistory := List new
    ].
    ^ ClassHistory 
!

classHistory:newCollection
    ClassHistory := newCollection
!

emptyClassHistory
    "removes all class history entries"

    |classHistory|

    classHistory := self classHistory.
    classHistory removeAll.
    SystemBrowser changed:#visitedClassHistory with:classHistory.

    "Modified: / 20-11-2006 / 12:29:42 / cg"
!

historyEntryForClass:aClass selector:aSelectorOrNil
    |newEntry meta cls|

    aClass isBehavior ifFalse:[^ nil].

    (meta := aClass isMeta) ifTrue:[
        cls := aClass theNonMetaclass.
    ] ifFalse:[
        cls := aClass
    ].
    newEntry := BrowserHistoryEntry new.
    newEntry 
        className:cls name
        meta:meta
        selector:aSelectorOrNil.
    ^ newEntry

    "Modified: / 24.2.2000 / 18:03:52 / cg"
!

lastSearchPatterns
    ^ LastSearchPatterns
!

rememberSearchPattern:aString
    LastSearchPatterns isNil ifTrue:[
        LastSearchPatterns := OrderedCollection new.
    ].
    (LastSearchPatterns includes:aString) ifTrue:[
        LastSearchPatterns remove:aString.
    ] ifFalse:[
        LastSearchPatterns size > 20 ifTrue:[
            LastSearchPatterns removeFirst
        ]
    ].
    LastSearchPatterns addFirst:aString.

    "Modified: / 24-11-2010 / 12:51:31 / cg"
    "Created: / 14-02-2012 / 14:00:24 / cg"
!

visitedClassNamesHistory
    ^ self classHistory
        collect:[:e | e className]
        thenSelect:[:nm | nm notEmptyOrNil]

    "
     Tools::NewSystemBrowser visitedClassNamesHistory
    "
! !

!SystemBrowser class methodsFor:'defaults'!

classHistoryMaxLevels
    ^ 3
!

classHistoryMaxSize
    "returns maximum size of the visited class history"

    Screen current height < 768 ifTrue:[
        ^ 15
    ].
    ^ 20 "/ 15

    "Modified: / 10.2.2000 / 14:07:07 / cg"
!

default
    "convenient getter for the user's preference.
     Returns his choice of browser class"

    ^ UserPreferences systemBrowserClass

    "   
     SystemBrowser default open
    "
!

largeLabelFont
    ^ Label defaultFont scaled:1.2.
!

methodTemplate
    "return a method definition template string or nil"

    ^ SmalltalkLanguage instance methodTemplate
!

visitedHistoryMaxSize
    "the maximum number of remembered visited-class-history entries"

    ^ 15
! !

!SystemBrowser class methodsFor:'defaults-presentation'!

emphasisForChangedCode
    ^ UserPreferences current emphasisForChangedCode.

    "
     EmphasisForChangedCode := #underwave
     EmphasisForChangedCode := #color->Color blue
     EmphasisForChangedCode := #color->Color red lightened lightened lightened
    "

    "Created: / 31.10.2001 / 10:15:33 / cg"
!

emphasisForChangedCode:anEmphasis
    EmphasisForChangedCode := anEmphasis

    "
     self emphasisForChangedCode:#underwave
     self emphasisForChangedCode:(#color->Color red lightened lightened lightened)
    "

    "Created: / 31.10.2001 / 10:15:44 / cg"
!

emphasisForDifferentPackage
    ^ UserPreferences current emphasisForDifferentPackage.

    "
     EmphasisForDifferentPackage := nil.
     EmphasisForDifferentPackage := #underwave
     EmphasisForDifferentPackage := #color->Color red lightened lightened lightened
    "

    "Modified: / 31.10.2001 / 10:47:25 / cg"
!

emphasisForDifferentPackage:anEmphasis
    EmphasisForDifferentPackage := anEmphasis

    "
     self emphasisForDifferentPackage:#underwave
     self emphasisForDifferentPackage:(#color->Color red lightened lightened lightened)
    "
!

emphasisForModifiedBuffer
    ^ UserPreferences current emphasisForModifiedBuffer.
!

emphasisForModifiedBuffer:anEmphasis
    EmphasisForModifiedBuffer := anEmphasis
!

emphasisForObsoleteCode
    ^ UserPreferences current emphasisForObsoleteCode.
!

emphasisForObsoleteCode:anEmphasis
    EmphasisForObsoleteCode := anEmphasis
!

emphasisForReadVariable
    ^ UserPreferences current emphasisForReadVariable.

    "
     EmphasisForReadVariable := #underline
     EmphasisForReadVariable := Array with:#underline with:#underlineColor->Color yellow
    "
!

emphasisForReadVariable:anEmphasis
    EmphasisForReadVariable := anEmphasis

    "
     self emphasisForReadVariable:#underline
     self emphasisForReadVariable:(Array with:#underline with:#underlineColor->Color yellow)
    "
!

emphasisForWrittenVariable
    ^ UserPreferences current emphasisForWrittenVariable.

    "
     EmphasisForWrittenVariable := #underline
     EmphasisForWrittenVariable := Array with:#underline with:#underlineColor->Color red lightened
    "
!

emphasisForWrittenVariable:anEmphasis
    EmphasisForWrittenVariable := anEmphasis

    "
     self emphasisForWrittenVariable:#underline
     self emphasisForWrittenVariable:(Array with:#underline with:#underlineColor->Color red lightened)
    "
!

iconForClass:aClass
    "ask the class for its browser symbol; 
     that's a key/selector in the ToolbarIconLibrary"

    aClass withAllSuperclassesDo:[:eachCls |
        |icon iconSymbol |

        icon := [ eachCls toolListIcon ] on:Error do:[].
        icon notNil ifTrue:[^ icon ].

        iconSymbol := eachCls iconInBrowserSymbol.
        iconSymbol notNil ifTrue:[
            ^ ToolbarIconLibrary perform:iconSymbol
        ].
    ].
    (aClass isUtilityClass) ifTrue:[
        ^ ToolbarIconLibrary utilityClassIcon
    ].
    (aClass isAbstract) ifTrue:[
        ^ ToolbarIconLibrary abstractClassIcon
    ].

    ^ nil

    "Created: / 17-08-2006 / 09:11:27 / cg"
    "Modified: / 20-07-2007 / 09:01:43 / cg"
!

resourceIconForMethod:aMethod
    |resources|

    (resources := aMethod resources) isNil ifTrue:[^ nil].

    (resources includesKey:#obsolete) ifTrue:[
        ^ self deprecatedMethodIcon
    ].
    (resources includesKey:#canvas) ifTrue:[
        ^ self canvasIcon
    ].
    (resources includesKey:#menu) ifTrue:[
        ^ self menuIcon
    ].
    (resources includesKey:#image) ifTrue:[
        ^ self imageIcon
    ].
    (resources includesKey:#fileImage) ifTrue:[
        ^ self fileImageIcon
    ].
    (resources includesKey:#programImage) ifTrue:[
        ^ self programImageIcon
    ].
    (resources includesKey:#help) ifTrue:[
        ^ self helpIcon
    ].
    (resources includesKey:#programMenu) ifTrue:[
        ^ self programMenuIcon
    ].
    (resources includesKey:#tableColumns) ifTrue:[
        ^ self tableColumnsIcon 
    ].
    (resources includesKey:#tabList) ifTrue:[
        ^ self tabListIcon 
    ].
    (resources includesKey:#hierarchicalList) ifTrue:[
        ^ self hierarchicalListIcon 
    ].
    (resources includesKey:#programImage) ifTrue:[
        ^ self programImageIcon 
    ].
    ^ nil

    "Created: / 17-08-2006 / 09:08:11 / cg"
! !

!SystemBrowser class methodsFor:'dialogs'!

askForClassNameMatching:matchStringArg inEnvironment:anEnvironmentOrClassOrNil for:aBrowserOrNil
    "open a dialog to ask for a class name.
     env is either a nameSpace or a class (to ask for a private class)"

    |classNames caselessMatchingNames
     substringMatchingNames caselessSubstringMatchingNames
     caselessWithoutPrefixSubstringMatchingNames
     lcMatchString subMatch lcSubMatch box className
     needSearch cls env searchBlock searchBlock2
     idx pref aMatchString allNames sortedBySpellingDistance msg resources|

    resources := self classResources.
    env := anEnvironmentOrClassOrNil ? Smalltalk.

    aMatchString := matchStringArg.

    "/ try to limit search to a namespace (but only if nameSpace is not a matchCharacter)

    (aMatchString includesString:'::') ifTrue:[
        "/ pref := aMatchString upTo:$:.
        idx := aMatchString lastIndexOf:$:.
        pref := aMatchString copyTo:idx-2.
        pref includesMatchCharacters ifTrue:[
            "/ search all in Smalltalk
        ] ifFalse:[
            cls := Smalltalk at:pref asSymbol ifAbsent:nil.
            (cls notNil and:[cls isBehavior]) ifTrue:[
                env := cls.
                aMatchString := aMatchString copyFrom:pref size + 1 + 2.
            ].
        ].
    ].

    classNames := Set new.
    caselessMatchingNames := Set new.
    substringMatchingNames := Set new.
    caselessSubstringMatchingNames := Set new.
    caselessWithoutPrefixSubstringMatchingNames := Set new.

    lcMatchString := aMatchString asLowercase.
    needSearch := true.
    aMatchString includesMatchCharacters ifFalse:[
        subMatch := '*' , aMatchString , '*'.
        lcSubMatch := subMatch asLowercase.

        "/ if the name is already a good one, avoid the expensive search
        className := aMatchString asSymbolIfInterned.
        className notNil ifTrue:[
            env isNameSpace ifTrue:[
                cls := env at:className ifAbsent:nil.
            ] ifFalse:[
                cls := env privateClassesAt:className.
            ].
            (cls notNil and:[cls isBehavior]) ifTrue:[
                needSearch := false.
            ]
        ]
    ].

    needSearch ifTrue:[
        searchBlock := [:aClass |
            |thisName|

            "/ use dotted names for java
            aClass isJavaClass ifTrue:[
                thisName := aClass displayString. "/ fullName copyReplaceAll:$/ with:$.
            ] ifFalse:[
                thisName := aClass name
            ].
            (lcMatchString match:aClass name asLowercase) ifTrue:[
                caselessWithoutPrefixSubstringMatchingNames add:thisName
            ].
            aClass nameWithoutPrefix ~= aClass name ifTrue:[
                (lcMatchString match:aClass nameWithoutPrefix asLowercase) ifTrue:[
                    caselessWithoutPrefixSubstringMatchingNames add:thisName
                ].
            ].

            (aMatchString match:thisName) ifTrue:[
                classNames add:thisName
            ] ifFalse:[
                (lcMatchString match:thisName asLowercase) ifTrue:[
                    caselessMatchingNames add:thisName
                ] ifFalse:[
                    subMatch notNil ifTrue:[
                        (subMatch match:thisName) ifTrue:[
                            substringMatchingNames add:thisName
                        ] ifFalse:[
                            (lcSubMatch match:thisName asLowercase) ifTrue:[
                                caselessSubstringMatchingNames add:thisName
                            ]
                        ]
                    ]
                ]
            ]
        ].

        (env == Smalltalk or:[env isNameSpace]) ifTrue:[
            env allClassesDo:searchBlock
        ] ifFalse:[
            env allPrivateClasses do:searchBlock
        ].

        sortedBySpellingDistance := false.
        "/ if nothing matched - try caseless matches
        classNames size == 0 ifTrue:[
            classNames := caselessMatchingNames.

            "/ if nothing matched - try substring matches
            classNames size == 0 ifTrue:[
                aMatchString isUppercaseFirst ifTrue:[
                    classNames := substringMatchingNames.
                ].
                "/ if nothing matched - try caseless substring matches
                classNames size == 0 ifTrue:[
                    classNames := caselessSubstringMatchingNames.

                    "/ if nothing matched - try best fitting
                    classNames size == 0 ifTrue:[
                        aMatchString includesMatchCharacters ifFalse:[
                            allNames := SortedCollection sortBlock:[:a :b | a value > b value].
                            searchBlock2 :=
                                [:aClass |
                                    |thisName dist|

                                    aClass isJavaClass ifTrue:[
                                        thisName := aClass displayString. "/ fullName copyReplaceAll:$/ with:$.
                                    ] ifFalse:[
                                        thisName := aClass name
                                    ].
                                    dist := thisName asLowercase spellAgainst:lcMatchString.
                                    (thisName asLowercase startsWith:lcMatchString) ifTrue:[
                                        dist := dist + (thisName size * 10).
                                    ].
                                    allNames add:(thisName -> dist).
                                ].
                            (env == Smalltalk or:[env isNameSpace]) ifTrue:[
                                env allClassesDo:searchBlock2
                            ] ifFalse:[
                                env allPrivateClasses do:searchBlock2
                            ].
                            classNames := (allNames copyTo:(allNames size min:40)) collect:[:each | each key].
                            sortedBySpellingDistance := true.
                        ]
                    ]
                ]
            ]
        ].

        (classNames size == 0) ifTrue:[^ nil].
        (classNames size == 1) ifTrue:[
            className := classNames first
        ] ifFalse:[
            |browseButton|

            sortedBySpellingDistance ifFalse:[
                classNames := classNames asArray sort.
            ].

            aMatchString includesMatchCharacters ifTrue:[
                msg := 'Classes matching or similar to "%1"\\Select or enter name of class to switch to:'
            ] ifFalse:[
                msg := 'Classes containing or similar to "%1"\\Select or enter name of class to switch to:'
            ].

            box := self listBoxTitle:(resources string:msg with:matchStringArg) withCRs
                              okText:'OK'
                                list:classNames.
            caselessWithoutPrefixSubstringMatchingNames notEmpty ifTrue:[
                box initialText:(caselessWithoutPrefixSubstringMatchingNames first).
            ].
            box action:[:aString | className := aString].

            browseButton := Button label:(resources string:'Browse All').
            browseButton action:[
                            |classes title|

                            title := resources string:'Classes Matching or Similar to "%1"' with:matchStringArg.
                            classes := classNames collect:[:nm | Smalltalk classNamed:nm].
                            aBrowserOrNil isNil ifTrue:[
                                SystemBrowser
                                    browseClasses:classes 
                                    label:title. 
                            ] ifFalse:[
                                aBrowserOrNil
                                    spawnClassBrowserFor:classes 
                                    label:title 
                                    in:#newBrowser 
                                    select:false.
                            ].
                            box hide.
                            box closeRequest
                         ].
            box addButton:browseButton before:box okButton.

            aMatchString isLowercaseFirst ifTrue:[
                |browseImplementorsButton|

                browseImplementorsButton := Button label:(resources string:'Implementors').
                browseImplementorsButton 
                    action:[
                        aBrowserOrNil isNil ifTrue:[
                            SystemBrowser browseImplementorsMatching:aMatchString
                        ] ifFalse:[
                            aBrowserOrNil
                                spawnMethodImplementorsBrowserFor:{ aMatchString } match:true in:#newBrowser.
                        ].
                        box hide.
                        box closeRequest
                     ].
                box addButton:browseImplementorsButton before:box okButton.
            ].

            box minExtent:300@250.

            box open.
            (box accepted not or:[className isNil]) ifTrue:[ "/ cancel
                ^ nil
            ]
        ].
    ].

    className notNil ifTrue:[
        "/ use slashed javaName for search.
        className := className copyReplaceAll:$. with:$/ ifNone:className.
    ].

"/    pref notNil ifTrue:[
"/        ^ pref , '::' , className
"/    ].
    ^ className

    "Modified: / 16-10-2006 / 11:36:20 / cg"
!

listBoxTitle:title okText:okText list:aList
    "convenient method: setup a listBox & return it"

    |box resources|

    resources := self classResources.

    box := ListSelectionBox
                title:(resources string:title)
                okText:(resources string:okText)
                action:nil.
    box list:aList.
    ^ box

    "
     (self listBoxTitle:'hello world' okText:'aaa' list:#(1 2 3 4)) open
    "
! !

!SystemBrowser class methodsFor:'image specs'!

abstractMethodIcon
    <resource: #programImage>

    ^ self padLockGrayMiniIcon
!

addBreakPointIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self addBreakPointIcon inspect
     ImageEditor openOnClass:self andSelector:#addBreakPointIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SystemBrowser class addBreakPointIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@8@C @N@@8@A@@@@@P@C @D@@@@@@@@@@@@b');
                colorMapFromArray:#[ 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'@@@O8A?0O?!!??G?<_?1??G?<_?1??C?8G?@O8@@@@@@b');
                            yourself);
                yourself
        ]
!

addBreakPointIcon2
    ^ XPToolbarIconLibrary addBreakPointIcon2
!

autoloadedClassIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary autoloadedClassBrowserIcon

    "Modified: / 20-07-2007 / 09:15:37 / cg"
!

breakPointedIcon
    <resource: #obsolete>

    ^ self lineBreakPointedIcon
    "/ ^ self breakPointedIcon2

    "Modified: / 05-03-2014 / 10:26:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canvasIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#canvasIcon"
    
    ^ Icon constantNamed:'SystemBrowser class canvasIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@.;.;.;.0@@@@@@@@@@C.;/C.;/@@9&XP9&XP@NY&DNY&D@C&Y!!C&Y!!@@9&XP9&XP@NY&DNY&D@C1DQC1DQ@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'??#?>O?8??#?>O?8??#?>O?8??#?>@@a');
                            yourself);
                yourself
        ]
!

containerClassIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary containerClassBrowserIcon

    "Modified: / 20-07-2007 / 09:14:54 / cg"
!

defaultIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon"
    
    ^ Icon constantNamed:'SystemBrowser class defaultIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@FY&Y&Y&X0@@@@@@@@@@YDQDQDQB@@@@@@@@@@A$QDQDQDH@@@@@@@@@@CH"H"H"H @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H@@@
@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@B@@@@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@@@@@@@@@A&Y&Y&Y#@@@@@F@"H"HFDQDQDQH@@@@@@@@@@@L"H"H"
H @@@@@ @@@@@@@@@@@@@@@@@B@@@@@@@@@@@@@@@@@@H@@@@@@@@@@@@@@@@@@@@@@@A&Y&Y&Y#@@@@@F@"H"HFUUUUUUH@@@@@@@@@@@L"H"H"H @@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@H@@@@B@B@ @@H@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@H@@@@@@@@@H@@ @@@@Hb');
                colorMapFromArray:#[ 0 0 0 0 255 0 127 127 127 170 170 170 255 0 0 255 255 0 255 255 255 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
??0@@O?<@@C??@@@??0@@O?<@@C??@@@@ @@@@H@@@@B@@@@@ O?8@\C?>@G??? A0O?8@HC?>@B@@@@@ O?8@\C?>@G??? A0O?8@@C?>@@@@@@9O\7\IRT
QDBD%DQ@!!OH''HHRQEABT$QPP99]7\@@a');
                            yourself);
                yourself
        ]
!

deprecatedMethodIcon
    ^ self doNotEnterIcon
!

disabledBreakpointIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary breakpointDisabled9x9
!

doNotEnterIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self doNotEnterIcon inspect
     ImageEditor openOnClass:self andSelector:#doNotEnterIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SystemBrowser class doNotEnterIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'??C0<NA00CB@EY>P''9B@DL@08GC0<@@a');
                colorMapFromArray:#[ 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@O@A>@O<A?8G? _>A?8C?@G8@O@@@a');
                            yourself);
                yourself
        ]
!

emptyIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self emptyIcon inspect
     ImageEditor openOnClass:self andSelector:#emptyIcon"
    
    ^ Icon constantNamed:'SystemBrowser class emptyIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]

    "Created: / 5.11.2001 / 09:39:54 / cg"
!

errorClassIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary errorClassBrowserIcon

    "Modified: / 20-07-2007 / 09:14:06 / cg"
!

exceptionClassIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self exceptionClassIcon inspect
     ImageEditor openOnClass:self andSelector:#exceptionClassIcon
     Icon flushCachedIcons
    "

    <resource: #programImage>

    ^ ToolbarIconLibrary exceptionClassBrowserIcon

    "Modified: / 20-07-2007 / 09:13:18 / cg"
!

fileImageIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self fileImageIcon inspect
     ImageEditor openOnClass:self andSelector:#fileImageIcon"
    
    ^ Icon constantNamed:'SystemBrowser class fileImageIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@H"H"H"@@@BQBH!!D"@@@$P"HQH"@@H"H"DQH @BH"HQDRH@@"H"DQH"@@L3L3DSL0@CL3L1D3L@@3L3L3L3@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 51 153 153 51 255 255 255 153 0 255 255 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'?<C?8O?0??#?>O?8??#?>O?8??#?>@@a');
                            yourself);
                yourself
        ]
!

fullBreakPointedIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary fullBreakPoint9x9Icon
    "/ ^ self fullBreakPointedIcon2

    "Created: / 05-03-2014 / 10:27:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fullBreakPointedIcon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self stopIcon1 inspect
     ImageEditor openOnClass:self andSelector:#stopIcon1
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SystemBrowser stopIcon1'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'DQH"H!!DQDAD!!DAD!!DQ@RDP@AD!!DPHQD@@QD!!DBDQ@@DQHQ@!!DQ@QDRDZHQDQDQD!!FBDQDADQHQ@RDP@AD!!DPDRDPDRDQDADRH"HQDQ@b');
                colorMapFromArray:#[ 255 255 255 255 0 0 128 0 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'G0@? G?@?>C?8O? ?>C?8G?@O8@_@@@a');
                            yourself);
                yourself
        ]
!

fullBreakPointedIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self stopIcon2 inspect
     ImageEditor openOnClass:self andSelector:#stopIcon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SystemBrowser stopIcon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'DQH"H!!DQDAD!!DQD!!DQ@RDQDQD!!DPHQDQDQD!!DBDSL3LQHQ@!!D@@@DRDZHQL3L1D!!FBDQDQDQHQ@RDQDQD!!DPDRDQDRDQDADRH"HQDQ@b');
                colorMapFromArray:#[ 255 255 255 255 0 0 128 0 0 255 163 163 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'G0@? G?@?>C?8O? ?>C?8G?@O8@_@@@a');
                            yourself);
                yourself
        ]
!

greenCheckIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self greenCheckIcon inspect
     ImageEditor openOnClass:self andSelector:#greenCheckIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SystemBrowser class greenCheckIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@H @@@@@@@"@@@@@@@@H@@@@@@ @"@@@@@@H H@@@@@@@H"@@@@@@@@H@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 0 127 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@C@@X@A@AL@F @N@@P@@@@@@@@a');
                            yourself);
                yourself
        ]
!

greenLockIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self greenLockIcon inspect
     ImageEditor openOnClass:self andSelector:#greenLockIcon
    "

    <resource: #programImage>

    ^ self padLockGreenMiniIcon

    "Modified: / 5.11.2001 / 09:40:12 / cg"
!

greenThumbUpIcon
    ^ ToolbarIconLibrary greenThumbUpIcon

    "Modified: / 17-07-2011 / 10:03:34 / cg"
!

greenThumbUpSmallIcon
    ^ ToolbarIconLibrary greenThumbUpSmallIcon

    "Modified: / 17-07-2011 / 10:03:43 / cg"
!

greyCheckIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self greyCheckIcon inspect
     ImageEditor openOnClass:self andSelector:#greyCheckIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SystemBrowser class greyCheckIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@H @@@@@@@"@@@@@@@@H@@@@@@ @"@@@@@@H H@@@@@@@H"@@@@@@@@H@@@@@@@@@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@C@@X@A@AL@F @N@@P@@@@@@@@a');
                            yourself);
                yourself
        ]
!

greyThumbUpIcon
    ^ ToolbarIconLibrary greyThumbUpIcon

    "Modified: / 17-07-2011 / 10:04:06 / cg"
!

helpIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self helpIcon inspect
     ImageEditor openOnClass:self andSelector:#helpIcon"
    
    ^ Icon constantNamed:'SystemBrowser class helpIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@A?<G#0]7A?\G;0__A?<G72_?@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'??#?>O?8??#?>O?8??#?>O?8??#?>@@a');
                            yourself);
                yourself
        ]
!

hierarchicalListIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#hierarchicalListIcon"
    
    ^ Icon constantNamed:'SystemBrowser class hierarchicalListIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@NAUUU0@R??8@GO?>@A0@C @\??88G@@N@A3?? @^@@8@N***@@@@@C b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'??#?>O?8??#?>O?8??#?>O?8??#?>@@a');
                            yourself);
                yourself
        ]
!

ignoredMethodIcon
    <resource: #programImage>

    ^ self padLockBlackMiniIcon
!

imageIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self imageIcon inspect
     ImageEditor openOnClass:self andSelector:#imageIcon"
    
    ^ Icon constantNamed:'SystemBrowser class imageIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@H"H"H"H @BQBH!!D"H@@$P"HQH"@@H"H"DQH @BH"HQDRH@@"H"DQH"@@L3L3DSL0@CL3L1D3L@@3L3L3L3@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 51 153 153 51 255 255 255 153 0 255 255 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'??#?>O?8??#?>O?8??#?>O?8??#?>@@a');
                            yourself);
                yourself
        ]
!

instVarOverlayXmlSpec
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self instVarOverlayXmlSpec inspect
     ImageEditor openOnClass:self andSelector:#instVarOverlayXmlSpec
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SystemBrowser class instVarOverlayXmlSpec'
        ifAbsentPut:[
            (Depth2Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 2 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BDP@@BID@@@"Q@@@BDP@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 84 84 84 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@@@@@BA@XFC@L[>[O8<=#[7X0CA XBA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

instrumentationIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary pipette16x16Icon
!

lineBreakPointedIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary lineBreakPoint9x9Icon
    "/ ^ self lineBreakPointedIcon2

    "Created: / 05-03-2014 / 10:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineBreakPointedIcon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self breakPointedIcon1 inspect
     ImageEditor openOnClass:self andSelector:#breakPointedIcon1
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SystemBrowser breakPointedIcon1'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@P@@L3@@@@$@L@@@L@@H@@@C@@@@APL@DQ@C@@@C@1DS@0@B@0@QD@L@@@@@@0@@@@@@L@@@L@@@@@@3L@@@@ @@@@@@@@ b');
                colorMapFromArray:#[ 255 0 0 255 255 255 0 0 0 255 199 199 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@N@C>@O8A?0G?@_<@? C>@C @@@@@a');
                            yourself);
                yourself
        ]
!

lineBreakPointedIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self breakPointedIcon2 inspect
     ImageEditor openOnClass:self andSelector:#breakPointedIcon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'SystemBrowser breakPointedIcon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'DQH"H!!DQDAD!!DQD!!DQ@RDQDQD!!DPHQDQDQD!!DBDQDQDQHQ@!!DQDQDRDZHQDQDQD!!FBDQDQDQHQ@RDQDQD!!DPDRDQDRDQDADRH"HQDQ@b');
                colorMapFromArray:#[ 255 255 255 255 0 0 128 0 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'G0@? G?@?>C?8O? ?>C?8G?@O8@_@@@a');
                            yourself);
                yourself
        ]
!

lineTracePointedIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary lineTracePoint9x9Icon
!

medium_methodEmptyInheritedIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self medium_methodEmptyInheritedIcon inspect
     ImageEditor openOnClass:self andSelector:#medium_methodEmptyInheritedIcon"
    
    ^ Icon 
        constantNamed:'SystemBrowser class medium_methodEmptyInheritedIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:9;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:9;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

medium_methodInheritedFromAboveAndRedefinedBelowIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self medium_methodInheritedFromAboveAndRedefinedBelowIcon inspect
     ImageEditor openOnClass:self andSelector:#medium_methodInheritedFromAboveAndRedefinedBelowIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'SystemBrowser class medium_methodInheritedFromAboveAndRedefinedBelowIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:9;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@B()@B(@A@ @A@ @A@ (EP@HEP@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 127 255 127 127 ];
                mask:((ImageMask new)
                            width:9;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@/ B>@K8A7@G\@]0C:@O(@> @@@@@a');
                            yourself);
                yourself
        ]
!

medium_methodInheritedFromAboveIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self medium_methodInheritedFromAboveIcon inspect
     ImageEditor openOnClass:self andSelector:#medium_methodInheritedFromAboveIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'SystemBrowser class medium_methodInheritedFromAboveIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:9;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@@@@@@A@@@ @B@@HA=0LG@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 127 ];
                mask:((ImageMask new)
                            width:9;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@ @B@@H@A0@G@@\@C8@O @>@@@@@@a');
                            yourself);
                yourself
        ]
!

medium_methodRedefinedBelowIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self medium_methodRedefinedBelowIcon inspect
     ImageEditor openOnClass:self andSelector:#medium_methodRedefinedBelowIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'SystemBrowser class medium_methodRedefinedBelowIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:9;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@ED@L@\@A0@B@@H@@"8@P@@@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 127 127 ];
                mask:((ImageMask new)
                            width:9;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@O @>@C8@G@@\@A0@B@@H@@ @@@@@a');
                            yourself);
                yourself
        ]
!

menuIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuIcon inspect
     ImageEditor openOnClass:self andSelector:#menuIcon"
    
    ^ Icon constantNamed:'SystemBrowser class menuIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@B***P@%UUT@@@@@@B***P@%UUT@@@@@@B***P@%UUT@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'??#?>O?8??#?>O?8??#?>O?8?? @@@@a');
                            yourself);
                yourself
        ]
!

methodEmptyInheritedIcon
    ^ self small_methodEmptyInheritedIcon
!

methodInheritedFromAboveAndRedefinedBelowIcon
    ^ self small_methodInheritedFromAboveAndRedefinedBelowIcon
!

methodInheritedFromAboveIcon
    ^ self small_methodInheritedFromAboveIcon
!

methodIsSubclassResponsibilityAndRedefinedBelowIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self methodIsSubclassResponsibilityAndRedefinedBelowIcon inspect
     ImageEditor openOnClass:self andSelector:#methodIsSubclassResponsibilityAndRedefinedBelowIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'SystemBrowser class methodIsSubclassResponsibilityAndRedefinedBelowIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:5;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:' @D@@H@@@@@B@@@@@@4UBHR@A@@"@@@a');
                colorMapFromArray:#[ 0 0 0 255 127 127 127 127 127 ];
                mask:((ImageMask new)
                            width:5;
                            height:11;
                            bits:(ByteArray fromPackedString:'<HC DO@@>O#8\G@b');
                            yourself);
                yourself
        ]
!

methodIsSubclassResponsibilityIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self methodIsSubclassResponsibilityIcon inspect
     ImageEditor openOnClass:self andSelector:#methodIsSubclassResponsibilityIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'SystemBrowser class methodIsSubclassResponsibilityIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:5;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:' @D@@H@@@@@B@@@@@ 4@B@H@@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 127 127 127 127 127 ];
                mask:((ImageMask new)
                            width:5;
                            height:11;
                            bits:(ByteArray fromPackedString:'<HC DO@@<IC0(I@b');
                            yourself);
                yourself
        ]
!

methodRedefinedBelowIcon
    ^ self small_methodRedefinedBelowIcon
!

nameSpaceIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary nameSpaceBrowserIcon

    "Modified: / 20-07-2007 / 09:12:26 / cg"
!

notificationClassIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary notificationClassBrowserIcon

    "Modified: / 20-07-2007 / 09:11:21 / cg"
!

packageIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary smallYellowPackageIcon
!

packageIconGraySmall
    <resource: #programImage>

    ^ ToolbarIconLibrary smallGrayPackageIcon
!

packageIconGreenSmall
    <resource: #programImage>

    ^ ToolbarIconLibrary smallGreenPackageIcon
!

packageIconOrangeSmall
    <resource: #programImage>

    ^ ToolbarIconLibrary smallOrangePackageIcon
!

packageIconSmall
    <resource: #programImage>

    ^ ToolbarIconLibrary smallYellowPackageIcon
!

padLockBlackMiniIcon
    <resource: #programImage>

    ^ XPToolbarIconLibrary padLockBlackMiniIcon
!

padLockBlueMiniIcon
    <resource: #programImage>

    ^ XPToolbarIconLibrary padLockBlueMiniIcon
!

padLockGrayMiniIcon
    <resource: #programImage>

    ^ GenericToolbarIconLibrary padLockGrayMiniIcon
!

padLockGreenMiniIcon
    <resource: #programImage>

    ^ GenericToolbarIconLibrary padLockGreenMiniIcon
!

padLockRedMiniIcon
    <resource: #programImage>

    ^ GenericToolbarIconLibrary padLockRedMiniIcon
!

privateMethodIcon
    <resource: #programImage>

    ^ self padLockRedMiniIcon
!

programImageIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self programImageIcon inspect
     ImageEditor openOnClass:self andSelector:#programImageIcon"
    
    ^ Icon constantNamed:#'SystemBrowser class programImageIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@H"H"H"H @BQBH!!D"H@@$P"HQH"@@H"H"DQH @BH"HQDRH@@"H"DQH"@@L3L3DSL0@CL3L1D3L@@3L3L3L3@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 25 77 77 51 255 255 128 128 0 128 77 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'??#?>O?8??#?>O?8??#?>O?8??#?>@@a');
                            yourself);
                yourself
        ]
!

programMenuIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self programMenuIcon inspect
     ImageEditor openOnClass:self andSelector:#programMenuIcon"
    
    ^ Icon constantNamed:#'SystemBrowser class programMenuIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@A?<G?0@@A?<G?0@@A?<G?3@@@@@@@a');
                colorMapFromArray:#[ 0 0 0 170 170 170 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'??#?>O?8??#?>O?8??#?>O?8?? @@@@a');
                            yourself);
                yourself
        ]
!

protectedMethodIcon
    <resource: #programImage>

    ^ self padLockGreenMiniIcon
!

queryClassIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary queryClassBrowserIcon

    "Modified: / 20-07-2007 / 09:10:32 / cg"
!

redCheckIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self redCheckIcon inspect
     ImageEditor openOnClass:self andSelector:#redCheckIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'SystemBrowser class redCheckIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@"@@@@@@@BH@@@@ @@H @@@BH @"@@@@@BH"H @@@@@BH"@@@@@@@BH @@@@@@@B@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@A @L@!! GL@O0@^@@8@A@@@@@@a');
                            yourself);
                yourself
        ]
!

redLockIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self redLockIcon inspect
     ImageEditor openOnClass:self andSelector:#redLockIcon"
    
    ^ Icon constantNamed:#'SystemBrowser class redLockIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:9;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@T@@AA@@AA@@EUP@EUP@EQP@EQP@EQP@EAP@AU@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 0 0 ];
                mask:((ImageMask new)
                            width:9;
                            height:11;
                            bits:(ByteArray fromPackedString:'F@@$@BP@_ A>@G8@_ A>@G8@O@@@@@@a');
                            yourself);
                yourself
        ]
!

redThumbDownIcon
    ^ ToolbarIconLibrary redThumbDownIcon

    "Modified: / 17-07-2011 / 10:04:37 / cg"
!

redThumbDownSmallIcon
    ^ ToolbarIconLibrary redThumbDownSmallIcon

    "Modified: / 17-07-2011 / 10:05:09 / cg"
!

removeBreakPointIcon2
    UserPreferences current useColorsForColorBlindness ifTrue:[
        ^ ToolbarIconLibrary removeBreakPointBlueIcon2
    ].
    ^ ToolbarIconLibrary removeBreakPointIcon2
!

small_methodEmptyInheritedIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self small_methodEmptyInheritedIcon inspect
     ImageEditor openOnClass:self andSelector:#small_methodEmptyInheritedIcon"
    
    ^ Icon 
        constantNamed:#'SystemBrowser class small_methodEmptyInheritedIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:5;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 ];
                mask:((ImageMask new)
                            width:5;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@b');
                            yourself);
                yourself
        ]
!

small_methodInheritedFromAboveAndRedefinedBelowIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self small_methodInheritedFromAboveAndRedefinedBelowIcon inspect
     ImageEditor openOnClass:self andSelector:#small_methodInheritedFromAboveAndRedefinedBelowIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'SystemBrowser class small_methodInheritedFromAboveAndRedefinedBelowIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:5;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'L1@DLLS,ES@@@@@0@@@*@L#@B@@3@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 127 255 127 127 127 127 127 ];
                mask:((ImageMask new)
                            width:5;
                            height:11;
                            bits:(ByteArray fromPackedString:'\GC8>O @>O#8\G@b');
                            yourself);
                yourself
        ]
!

small_methodInheritedFromAboveIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self small_methodInheritedFromAboveIcon inspect
     ImageEditor openOnClass:self andSelector:#small_methodInheritedFromAboveIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'SystemBrowser class small_methodInheritedFromAboveIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:5;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'H#HDLHR@EP@@@@@@@BD@IP@!!@B@@IP@a');
                colorMapFromArray:#[ 0 0 0 255 255 127 127 127 127 ];
                mask:((ImageMask new)
                            width:5;
                            height:11;
                            bits:(ByteArray fromPackedString:'\GC8>O @@@@@@@@b');
                            yourself);
                yourself
        ]
!

small_methodRedefinedBelowIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self small_methodRedefinedBelowIcon inspect
     ImageEditor openOnClass:self andSelector:#small_methodRedefinedBelowIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'SystemBrowser class small_methodRedefinedBelowIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:5;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@D@@@@@@@@@@@@@@@4UBHR@A@@"@@@a');
                colorMapFromArray:#[ 0 0 0 255 127 127 127 127 127 ];
                mask:((ImageMask new)
                            width:5;
                            height:11;
                            bits:(ByteArray fromPackedString:'@@@@@@@@>O#8\G@b');
                            yourself);
                yourself
        ]
!

startableClassIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary startableClassBrowserIcon

    "Created: / 05-11-2001 / 09:50:16 / cg"
    "Modified: / 20-07-2007 / 09:09:40 / cg"
!

startableVisualAppIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary visualStartableClassBrowserIcon

    "Created: / 05-11-2001 / 09:49:00 / cg"
    "Modified: / 20-07-2007 / 09:08:34 / cg"
!

stopIcon
    <resource: #obsolete>

    ^ self fullBreakPointedIcon

    "Modified: / 05-03-2014 / 10:27:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tabListIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self tabListIcon inspect
     ImageEditor openOnClass:self andSelector:#tabListIcon"
    
    ^ Icon constantNamed:#'SystemBrowser class tabListIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@D3!!QP@@8TT@@N@@J@C***P@:**$AN**)@C***P@:**$@IUUUB @@@@@b');
                colorMapFromArray:#[ 0 0 0 127 127 127 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'?8C?0O?0??#?>O?8??#?>O?8??#?>@@a');
                            yourself);
                yourself
        ]
!

tableColumnsIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self tableColumnsIcon inspect
     ImageEditor openOnClass:self andSelector:#tableColumnsIcon"
    
    ^ Icon constantNamed:#'SystemBrowser class tableColumnsIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@C??? @8(($@L@@AHC"""R@0@@D@NJJI@C@@@P@8(($@IUUU@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 127 127 127 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'??#?>O?8??#?>O?8??#?>O?8??#?>@@a');
                            yourself);
                yourself
        ]
!

testCaseClassIcon
    <resource: #programImage>

    "/ only left here for backward compatibility...
    ^ ToolbarIconLibrary testCaseClassIcon
!

testCaseClassIconFor:cls
    <resource: #programImage>

    "/ decision moved to TestCase - see there.
    "/ only left here for backward compatibility...

    |lastResult|

    lastResult := cls lastTestRunResultOrNil.
    lastResult notNil ifTrue:[
        lastResult == TestResult statePass ifTrue:[
            ^ self testCasePassedIcon
        ].
        lastResult == TestResult stateFail ifTrue:[
            ^ self testCaseFailedIcon
        ].
        lastResult == TestResult stateError ifTrue:[
            ^ self testCaseErrorIcon
        ].
    ].
    ^ self testCaseUnknownResultIcon

    "Modified: / 06-08-2006 / 11:14:12 / cg"
!

testCaseErrorIcon
    <resource: #programImage>

    "/ only left here for backward compatibility...
    ^ ToolbarIconLibrary testCaseErrorIcon
!

testCaseFailedIcon
    <resource: #programImage>

    "/ only left here for backward compatibility...
    ^ ToolbarIconLibrary testCaseFailedIcon
!

testCasePassedIcon
    <resource: #programImage>

    "/ only left here for backward compatibility...
    ^ ToolbarIconLibrary testCasePassedIcon
!

testCaseSkippedIcon
    <resource: #programImage>

    "/ only left here for backward compatibility...
    ^ ToolbarIconLibrary testCaseSkippedIcon
!

testCaseUnknownResultIcon
    <resource: #programImage>

    "/ only left here for backward compatibility...
    ^ ToolbarIconLibrary testCaseClassIcon
!

timeIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self timeIcon inspect
     ImageEditor openOnClass:self andSelector:#timeIcon"
    
    ^ Icon constantNamed:#'SystemBrowser class timeIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@@G@A7@G\@=8C0 O>@_0A?@A0@@@@@a');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'A0@_0C? O>A?<G?0_?@?8C? G<@G@@@a');
                            yourself);
                yourself
        ]
!

traceIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self traceIcon inspect
     ImageEditor openOnClass:self andSelector:#traceIcon"
    
    ^ Icon constantNamed:#'SystemBrowser class traceIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'@@@@@@>@C8@G@@\@@ @B@@@@@@@@@@@a');
                colorMapFromArray:#[ 255 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'_?A?<C? O>@_0A?@C8@O @\@A0@B@@@a');
                            yourself);
                yourself
        ]
!

visualStartableClassIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self visualStartableClassIcon inspect
     ImageEditor openOnClass:self andSelector:#visualStartableClassIcon"
    
    ^ Icon constantNamed:#'SystemBrowser class visualStartableClassIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'**J*NJ*"*#"*!!J(@*!!T*@J(DJ B*DR(@*!!T*NJ(*J B*O2(@*+.*@J*** @b');
                colorMapFromArray:#[ 0 0 0 127 127 127 255 0 0 255 255 0 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'@ @B@@\@C8@O @>@C8@H @>@A0@G@@@a');
                            yourself);
                yourself
        ]

    "Modified: / 5.11.2001 / 09:49:30 / cg"
!

warningClassIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary warningClassBrowserIcon

    "Modified: / 20-07-2007 / 09:04:39 / cg"
!

watchIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self watchIcon inspect
     ImageEditor openOnClass:self andSelector:#watchIcon"
    
    ^ Icon constantNamed:#'SystemBrowser class watchIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@X@@@X@@@@AE XQY @@XALCDFD@@AD0@CDV@@XAL@@1A @AD0@P@1D@XBI!!DVH A QUPQEEU@@%"EDAVHT@IX]R@%!!5@FQUH@@%U@A&H$@@P"X@');
                colorMapFromArray:#[ 0 0 51 0 0 60 0 51 102 51 102 153 71 102 145 128 213 221 153 153 204 153 255 255 255 255 255 ];
                mask:((ImageMask new)
                            width:13;
                            height:12;
                            bits:(ByteArray fromPackedString:'FL@]0C7 O>A?<G?0??#=>O78?_#8>GA0');
                            yourself);
                yourself
        ]
!

windowClassIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary windowClassBrowserIcon

    "Modified: / 20-07-2007 / 09:05:57 / cg"
!

windowIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self windowIcon inspect
     ImageEditor openOnClass:self andSelector:#windowIcon"
    
    ^ Icon constantNamed:#'SystemBrowser class windowIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:13;
                height:11;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@.;.;.;.0@@@@@@@@@@C.;.;.;/@@9&Y&Y&XP@NY&Y&Y&D@C&Y&Y&Y!!@@9&Y&Y&XP@NY&Y&Y&D@C1DQDQDQ@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:13;
                            height:11;
                            bits:(ByteArray fromPackedString:'??#?>O?8??#?>O?8??#?>O?8??#?>@@a');
                            yourself);
                yourself
        ]

    "Created: / 5.11.2001 / 09:39:03 / cg"
! !

!SystemBrowser class methodsFor:'interface specs'!

metaSpec
        "UIPainter new openOnClass: self andSelector: #metaSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Unlabeled Canvas' 
                        #bounds: #(#Rectangle 27 249 325 334 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 0 0 4 0 -1 0.575 20 0 ) 
                                        #name: #instanceSwitch 
                                        #model: #metaHolder 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'instance' 
                                        #select: false ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 1 0.575 4 0 -1 1 20 0 ) 
                                        #name: #classSwitch 
                                        #model: #metaHolder 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'class' 
                                        #select: true ) ) ) )

    "Created: / 30.10.1997 / 19:07:29 / cg"
!

methodMoveDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SystemBrowser andSelector:#methodMoveDialogSpec
     SystemBrowser new openInterface:#methodMoveDialogSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: methodMoveDialogSpec
       window: 
      (WindowSpec
         label: 'move method'
         name: 'move method'
         bounds: (Rectangle 0 0 387 118)
       )
       component: 
      (SpecCollection
         collection: (
          (HorizontalPanelViewSpec
             name: 'horizontalPanelView'
             layout: (LayoutFrame 0 0.0 -35 1.0 0 1.0 -2 1.0)
             level: 0
             horizontalLayout: fitSpace
             verticalLayout: center
             horizontalSpace: 4
             verticalSpace: 4
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'cancel'
                   name: 'actionButton2'
                   translateLabel: true
                   tabable: true
                   model: cancel
                   extent: (Point 187 27)
                 )
                (ActionButtonSpec
                   label: 'move'
                   name: 'actionButton1'
                   translateLabel: true
                   tabable: true
                   model: accept
                   isDefault: true
                   extent: (Point 188 27)
                 )
                )
              
             )
           )
          (LabelSpec
             label: 'move current method to which class:'
             name: 'label'
             layout: (LayoutFrame 2 0 2 0 -2 1.0 25 0)
             style: largeLabelFont
             foregroundColor: (Color 0.0 0.0 0.0)
             backgroundColor: (Color 67.0 67.0 67.0)
             translateLabel: true
             adjust: left
           )
          (ComboBoxSpec
             name: 'comboBox1'
             layout: (LayoutFrame 2 0 29 0 -2 1.0 51 0)
             tabable: true
             model: className
             comboList: classList
           )
          )
        
       )
     )
! !

!SystemBrowser class methodsFor:'private-helpers'!

askForPackageChangeFrom:oldPkg to:newPkg
    |answer box notAgain chk|

    box := OptionBox 
                title:
('You are about to change a method from another (system-) package.
The methods original packageID was ''%1''. 
If you proceed, the new method will be marked as belonging
to the ''%2'' package (and this warning will not be shown again).
If you proceed with ''keep'', the new method will be installed
but the old packageID will be preserved.
Otherwise, hit ''cancel'' to leave the code unchanged.

PS: if you disable this check here, it can be reenabled it in the launchers settings-compilation dialog.' 
                        bindWith:(oldPkg allBold)
                            with:(newPkg allBold))
                numberOfOptions:3.

    box buttonTitles:#('Cancel' 'Keep' 'Continue').
    box defaultButtonIndex:3. 
    box action:[:n | answer := #(#cancel #keep #continue) at:n].
    box label:'Method redefinition'; image:(WarningBox iconBitmap).
    box yPosition:(box formLabel bottom max:box textLabel bottom).
    box addVerticalSpace:10.
    chk := box addCheckBoxAtBottom:'Don''t show this dialog again (never keep)' on:(notAgain := false asValue).
    box preferredExtent:(box preferredExtent + (0 @ chk preferredHeight) + (0@10)).
    box resize.
    box showAtPointer.
    box destroy.

    (answer ~~ #cancel) ifTrue:[
        notAgain value ifTrue:[
            Class catchMethodRedefinitions:false.
        ].
    ].
    ^ answer.

    "Modified: / 28-02-2012 / 10:41:52 / cg"
!

showNoneFound
    self warn:(self classResources string:'None found.').
!

showNoneFound:what
    |rs|

    rs := self classResources.
    self information:((rs string:what) , (rs string:'...\\... none found.')) withCRs.
! !

!SystemBrowser class methodsFor:'private-instance creation'!

newWithLabel:aString setupBlock:aBlock
    "common helper method for all creation methods"

    ^ self newWithLabel:aString setupBlock:aBlock onDevice:Screen current
!

newWithLabel:aString setupBlock:aBlock onDevice:aWorkstation
    "common helper method for all creation methods"

    |newBrowser|

    newBrowser := BrowserView onDevice:aWorkstation.
    newBrowser title:aString.
    aBlock value:newBrowser.

    newBrowser open.
    ^ newBrowser
!

newWithLabel:aString setupSelector:aSymbol arg:arg
    "common helper method for all creation methods"

    ^ self newWithLabel:aString setupSelector:aSymbol arg:arg onDevice:Screen current 
!

newWithLabel:aString setupSelector:aSymbol arg:arg onDevice:aWorkstation
    "common helper method for all creation methods"

    |newBrowser|

    newBrowser := BrowserView onDevice:aWorkstation.
    newBrowser title:aString.
    newBrowser perform:aSymbol with:arg.
    newBrowser open.
    ^ newBrowser
! !

!SystemBrowser class methodsFor:'special search startup'!

allCallsOn:aSelectorString
    "return a collection of methods which send aSelector.
     This takes some time, because source code is parsed to see
     if there is really a message send inside (and not just a symbol reference)"

    ^ self 
        allCallsOn:aSelectorString 
        in:(Smalltalk allClasses) 
        ignoreCase:false 
        match:false

    "
     Time millisecondsToRun:[
         SystemBrowser allCallsOn:#at:put:
     ].            
    "

    "Created: 24.1.1997 / 19:42:57 / cg"
!

allCallsOn:aSelectorString in:aCollectionOfClasses
    "return a collection of methods which send aSelector.
     Methods from classes in aCollectionOfClasses are searched only."

    ^ self 
        allCallsOn:aSelectorString 
        in:aCollectionOfClasses 
        ignoreCase:false 
        match:false
!

allCallsOn:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase
    "return a collection of methods which send aSelector.
     Methods from classes in aCollectionOfClasses are searched only."

    ^ self 
        allCallsOn:aSelectorString 
        in:aCollectionOfClasses 
        ignoreCase:ignoreCase 
        match:true

    "
     SystemBrowser allCallsOn:#at:put: in:(Smalltalk allClasses)
    "

    "Modified: 18.4.1997 / 10:32:50 / cg"
!

allCallsOn:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatchArg
    "return a collection of methods which send aSelector.
     Methods from classes in aCollectionOfClasses are searched only."

    |doMatch sel searchBlock classesSearched|

    doMatch := doMatchArg.
    (doMatch and:[aSelectorString includesMatchCharacters not]) ifTrue:[
        doMatch := false.
    ].    
        
    aSelectorString size == 0 ifTrue:[ ^ #() ].
    (doMatch or:[ignoreCase]) ifFalse:[
        "/ no need to search, if there is no such symbol in the system
        sel := aSelectorString asSymbolIfInterned.
        sel isNil ifTrue:[ ^ #() ].   "/ none (no such selector)
    ]. 

    classesSearched := aCollectionOfClasses.
    doMatch ifFalse:[
        "/ exclude all javaClasses, if the selector cannot be a valid java-selector
        (aSelectorString includes:$() ifFalse:[
            classesSearched := classesSearched reject:[:eachClass | eachClass theNonMetaclass isJavaClass ].
        ].
    ].

    searchBlock := self searchBlockForAllCallsOn:aSelectorString ignoreCase:ignoreCase match:doMatch.
    searchBlock isNil ifTrue:[
        ^ #()    "/ none (no such selector)
    ].
    ^ self allMethodsIn:classesSearched where:searchBlock

    "
     SystemBrowser allCallsOn:#at:put: in:(Smalltalk allClasses)
    "

    "Modified: 18.4.1997 / 10:32:50 / cg"
!

allMethodsIn:aCollectionOfClasses inst:wantInst class:wantClass where:aBlock
    "return a collection of methods which pass the given test.
     wantInst/wantClass control if instMethods and/or classMethods are to be
     considered.
     Only classes in aCollectionOfClasses are inspected in the search"

    |list activePriority|

    "
     since this may take a long time, lower my priority ...
    "
    activePriority := Processor activePriority.
    Processor activeProcess 
        withPriority:activePriority-1 to:activePriority
    do:[
        |checkedClasses checkBlock detectedMethods|

        checkedClasses := IdentitySet new.
        list := OrderedCollection new.
        detectedMethods := IdentitySet new.

        checkBlock := [:cls |
            (checkedClasses includes:cls) ifFalse:[
                (cls isObsolete and:[cls isLoaded]) ifTrue:[
                    Transcript showCR:'Browser method search: skipping obsolete class: ' , cls displayString
                ] ifFalse:[
                    cls methodDictionary keysAndValuesDo:[:sel :method |
                        (aBlock value:cls value:method value:sel) ifTrue:[
                            "/ care for methods being in multiple classes (should not happen)
                            (detectedMethods includes:method) ifFalse:[
                                list add:method.
                                detectedMethods add:method
                            ]
                        ]
                    ].
                    checkedClasses add:cls.
                ]
            ]
        ].

        aCollectionOfClasses do:[:aClass |
            "
             output disabled - it slows down things too much (when searching for
             implementors or senders)
            "
            wantInst ifTrue:[
"/                Transcript show:'searching '; show:aClass name; showCR:' ...'; endEntry.
                checkBlock value:aClass
            ].
            wantClass ifTrue:[
"/                Transcript show:'searching '; show:aClass class name; showCR:' ...'; endEntry.
                checkBlock value:(aClass class)
            ].
            Processor yield
        ]
    ].
    ^ list

    "Created: / 24.1.1997 / 19:41:12 / cg"
    "Modified: / 14.12.1999 / 14:59:02 / cg"
!

allMethodsIn:aCollectionOfClasses where:aBlock
    "return a collection of methods which pass the given test.
     Only classes in aCollectionOfClasses are inspected in the search"

    ^ self
        allMethodsIn:aCollectionOfClasses 
        inst:true 
        class:true
        where:aBlock

    "Created: 24.1.1997 / 19:41:49 / cg"
!

aproposSearch:aString
    "browse all methods, which have aString in their selector."

    ^ self aproposSearch:aString in:(Smalltalk allClasses)

!

aproposSearch:aString in:aCollectionOfClasses
    "browse all methods, which have aString.
     This is relatively slow, since all source must be processed."

    |matchString list s searchBlock browser|

    matchString := '*' , aString , '*'.

    list := OrderedCollection new.

    (aString includesMatchCharacters) ifTrue:[
        s := '*' , aString asLowercase , '*'.
        "a matchString"
        searchBlock := [:text | (text asCollectionOfLinesfindFirst:[:line | s match:line]) ~~ 0].
    ] ifFalse:[
        searchBlock := [:source | (source findString:aString asLowercase) ~~ 0]
    ].

    browser := self browseMethodsIn:aCollectionOfClasses 
                     where:[:class :method :sel |
                                |comment|

                                (searchBlock value:sel asLowercase)
                           ]
                     title:(self classResources string:'selectors containing: %1' with:aString).

    browser notNil ifTrue:[
        browser autoSearch:aString 
    ].
    ^ browser

    "
     SystemBrowser aproposSearch:'append' in:(Collection withAllSubclasses)
     SystemBrowser aproposSearch:'add'    in:(Collection withAllSubclasses)
     SystemBrowser aproposSearch:'sort'   in:(Collection withAllSubclasses)
     SystemBrowser aproposSearch:'[Aa]bsent' in:(Collection withAllSubclasses)
    "

    "Created: 9.12.1995 / 18:02:36 / cg"
!

browseAllCallsOn:aSelectorString
    "launch a browser for all senders of aSelector.
     Notice: better go via Smalltalk browseAllCallsOn:, which honors the tool-preferences"

    ^ self 
        browseAllCallsOn:aSelectorString 
        in:(Smalltalk allClasses)

    "
     SystemBrowser browseAllCallsOn:#+
    "

    "Created: 9.12.1995 / 18:00:41 / cg"
    "Modified: 10.7.1996 / 10:26:15 / cg"
!

browseAllCallsOn:aSelectorString in:aSetOfClasses
    "launch a browser for all senders of aSelector"

    ^ self
        browseAllCallsOn:aSelectorString 
        in:aSetOfClasses
        title:(self classResources string:'Senders of: %1' with:aSelectorString)

    "
     SystemBrowser browseAllCallsOn:#+ in:(Number withAllSubclasses)
    "

    "Created: 10.7.1996 / 10:25:49 / cg"
    "Modified: 24.1.1997 / 19:49:34 / cg"
!

browseAllCallsOn:aSelectorString in:aSetOfClasses ignoreCase:ignoreCase
    "launch a browser for all senders of aSelector"

    ^ self
        browseAllCallsOn:aSelectorString 
        in:aSetOfClasses
        ignoreCase:ignoreCase
        title:(self classResources string:'Senders of: %1' with:aSelectorString)

    "
     SystemBrowser browseAllCallsOn:#+ in:(Number withAllSubclasses)
    "

    "Created: 10.7.1996 / 10:25:49 / cg"
    "Modified: 24.1.1997 / 19:49:34 / cg"
!

browseAllCallsOn:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase match:match title:titleArg
    "launch a browser for all senders of aSelector in aCollectionOfClasses"

    |list list2 browser selWithColon title rs|

    title := titleArg.

    list := self allCallsOn:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase match:true.
    list isEmpty ifTrue:[
        aSelectorString numArgs == 0 ifTrue:[
            selWithColon := aSelectorString , ':'.
            selWithColon knownAsSymbol ifTrue:[
                list2 := self allCallsOn:selWithColon in:aCollectionOfClasses ignoreCase:ignoreCase match:true.
            ].            
        ].
        list2 size == 0 ifTrue:[
            self showNoneFound:title.
            ^ nil
        ].
        rs := self classResources.
        (Dialog confirm:((rs string:title) , 
                         (rs string:'...\\... none found.') ,
                         (rs string:'\\But I found %1 sends of the "%2" message (with colon).\\Browse those ?'
                             with:list2 size
                             with:selWithColon allBold)) withCRs) ifFalse:[
            ^ nil
        ].
        list := list2.
        title := title , ':'.
    ].

    browser := self browseMethods:list title:title.
    browser notNil ifTrue:[
        |s|

"/        "
"/         kludge for now, if its a multipart selector,
"/         no easy search is (as yet) possible
"/        "
"/        s := aSelectorString.
"/        (s includes:$:) ifTrue:[
"/            s := s copyTo:(s indexOf:$:)
"/        ].
"/        browser autoSearch:s 
        browser setSearchSelector:aSelectorString ignoreCase:ignoreCase doMatch:true.
    ].
    ^ browser

    "
     SystemBrowser
        browseAllCallsOn:#+ 
        in:(Number withAllSubclasses) 
        title:'just a test'
    "

    "Modified: / 24-01-1997 / 19:48:54 / cg"
    "Created: / 14-02-2012 / 14:19:51 / cg"
!

browseAllCallsOn:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase title:titleArg
    "launch a browser for all senders of aSelector in aCollectionOfClasses"

    ^ self 
        browseAllCallsOn:aSelectorString 
        in:aCollectionOfClasses 
        ignoreCase:ignoreCase 
        match:true 
        title:titleArg

    "
     SystemBrowser
        browseAllCallsOn:#+ 
        in:(Number withAllSubclasses) 
        title:'just a test'
    "

    "Modified: / 14-02-2012 / 14:20:17 / cg"
!

browseAllCallsOn:aSelectorString in:aCollectionOfClasses title:title
    "launch a browser for all senders of aSelector in aCollectionOfClasses"

    ^ self
        browseAllCallsOn:aSelectorString 
        in:aCollectionOfClasses 
        ignoreCase:false 
        title:title

    "
     SystemBrowser
        browseAllCallsOn:#+ 
        in:(Number withAllSubclasses) 
        title:'just a test'
    "

    "Modified: 24.1.1997 / 19:48:54 / cg"
!

browseCallsOn:aSelectorString under:aClass
    "launch a browser for all senders of aSelector in aClass and subclasses"

    ^ self 
        browseAllCallsOn:aSelectorString
                      in:(aClass withAllSubclasses)
                   title:(self classResources 
                                string:'Senders of: %1 (in and below %2)'
                                with:aSelectorString 
                                with:aClass name)

    "
     SystemBrowser browseCallsOn:#+ under:Number
    "

    "Created: 9.12.1995 / 17:59:57 / cg"
    "Modified: 24.1.1997 / 19:50:33 / cg"
!

browseClassRefsTo:aString in:aCollectionOfClasses modificationsOnly:modsOnly
    "launch a browser for all methods in aClass where the classVar named
     aString is referenced; if modsOnly is true, browse only methods where the
     classvar is modified"

    ^ self browseRefsTo:aString classVars:true in:aCollectionOfClasses modificationsOnly:modsOnly
!

browseClassRefsTo:varName in:aCollectionOfClasses modificationsOnly:modsOnly title:title
    "launch a browser for all methods in aCollectionOfClasses,
     where the classVar named aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    ^ self browseRefsTo:varName classVars:true in:aCollectionOfClasses modificationsOnly:modsOnly title:title
!

browseClassRefsTo:aString under:aClass modificationsOnly:modsOnly
    "launch a browser for all methods in aClass and subclasses
     where the classVar named aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    ^ self browseClassRefsTo:aString in:(aClass withAllSubclasses) modificationsOnly:modsOnly

!

browseForResource:aResourceSymbol containing:item in:aCollectionOfClasses title:title
    "launch a browser for all methods which have a particular (or any, ifNil)
     resource in aCollectionOfClasses.
     If aKey is nonNil, only methods which have aKey in the (any) resourceSpec
     are parsed.
     I.e. to find all methods, which access the styleSheets, use:
        browseForResource:#style containing:nil in:... title:...
     to find methods which access the 'arrowButtonDownForm' styleSheet entry, use:
        browseForResource:#style containing:'arrowButtonDownForm' in:... title:..."

    |browser searchBlock|

    "/ search for any resource can be done without looking
    "/ at the source ...
    (aResourceSymbol isNil and:[item isNil]) ifTrue:[
        searchBlock := [:class :method :s | method hasResource]
    ] ifFalse:[
        searchBlock := [:class :method :s |
                            |rsrc val found|

                            found := false.
                            method hasResource ifTrue:[
                                rsrc := method resources.
                                rsrc notNil ifTrue:[
                                    aResourceSymbol isNil ifTrue:[
                                        item isNil ifTrue:[
                                            found := true
                                        ] ifFalse:[
                                            rsrc isCollection ifTrue:[
                                                rsrc keysAndValuesDo:[:rsrc :val |
                                                    val isCollection ifTrue:[
                                                        val do:[:v |
                                                            found := item match:v printString 
                                                        ]
                                                    ] ifFalse:[
                                                        found := item match:val printString 
                                                    ]
                                                ]
                                            ] ifFalse:[
                                                found := item match:rsrc printString
                                            ]
                                        ]
                                    ] ifFalse:[
                                        (rsrc includesKey:aResourceSymbol) ifTrue:[
                                            item isNil ifTrue:[
                                                found := true
                                            ] ifFalse:[
                                                rsrc isCollection ifTrue:[
                                                    val := rsrc at:aResourceSymbol.
                                                    val isCollection ifTrue:[
                                                        val do:[:v |
                                                            found := item match:v printString 
                                                        ]
                                                    ] ifFalse:[
                                                        found := item match:val printString 
                                                    ]
                                                ] ifFalse:[
                                                    found := item match:rsrc printString
                                                ]
                                            ]
                                        ]
                                    ]
                                ].
                            ].
                            found
                       ].
    ].

    browser := self browseMethodsIn:aCollectionOfClasses
                              where:searchBlock
                              title:title.
    browser notNil ifTrue:[
        browser autoSearch:'resource:' 
    ].
    ^ browser

    "
     SystemBrowser
        browseForResource:nil
        in:Smalltalk allClasses
        title:'methods with a resource'
    "
    "
     SystemBrowser
        browseForResource:#style
        containing:nil
        in:Smalltalk allClasses
        title:'methods with a #style resource'
    "
    "
     SystemBrowser
        browseForResource:#style
        containing:'arrowButton*'
        in:Smalltalk allClasses
        title:'methods with a #style resource'
    "

    "Modified: / 22.4.1998 / 10:29:20 / cg"
!

browseForResource:aResourceSymbol in:aCollectionOfClasses title:title
    "launch a browser for all methods which have a particular (or any, ifNil)
     resource in aCollectionOfClasses"

    ^ self
        browseForResource:aResourceSymbol
        containing:nil
        in:aCollectionOfClasses 
        title:title

    "
     SystemBrowser
        browseForResource:#style
        in:Smalltalk allClasses
        title:'methods accessing styleSheet values'
    "
    "
     SystemBrowser
        browseForResource:#keyboard
        in:Smalltalk allClasses
        title:'methods handling keyboard events'
    "
    "
     SystemBrowser
        browseForResource:nil
        in:Smalltalk allClasses
        title:'methods with a resource'
    "

    "Modified: 9.1.1997 / 12:44:38 / cg"
!

browseForString:aString
    <resource: #obsolete>
    "launch a browser for all methods containing a string in their source.
     This may be slow, since source-code has to be scanned."

    ^ self browseForString:aString in:(Smalltalk allClasses) ignoreCase:false

    "Modified: / 18.6.1998 / 16:42:39 / cg"
!

browseForString:aString in:aCollectionOfClasses
    <resource: #obsolete>
    "launch a browser for all methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."

    ^ self
        browseForString:aString 
        in:aCollectionOfClasses 
        ignoreCase:false

    "
     SystemBrowser browseForString:'all'      in:(Array with:Object)
     SystemBrowser browseForString:'should'   in:(Array with:Object)
     SystemBrowser browseForString:'[eE]rror' in:(Array with:Object)
    "

    "Created: / 9.12.1995 / 18:03:12 / cg"
    "Modified: / 18.6.1998 / 16:43:27 / cg"
!

browseForString:aString in:aCollectionOfClasses ignoreCase:ignoreCase
    <resource: #obsolete>
    "launch a browser for all methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."

    |browser searchBlock title s|

    title := self classResources string:'Methods containing: %1' with:aString displayString.

    (aString includesMatchCharacters
    or:[ignoreCase]) ifTrue:[
        s := '*' , aString , '*'.
        "a matchString"
        searchBlock := [:c :m :sel | 
                            |src|       
                            src := m source.
                            src isNil ifTrue:[
                                ('Browser [info]: no source for ' , m printString) infoPrintCR.
                                false
                            ] ifFalse:[
                                s match:src caseSensitive:ignoreCase not
                            ]
                       ]
    ] ifFalse:[
        searchBlock := [:c :m :sel | 
                            |src|

                            src := m source.
                            src isNil ifTrue:[
                                ('Browser [info]: no source for ' , m printString) infoPrintCR.
                                false
                            ] ifFalse:[
                                (src findString:aString) ~~ 0
                            ]
                       ]
    ].
    browser := self browseMethodsIn:aCollectionOfClasses where:searchBlock title:title.

    browser notNil ifTrue:[
        browser autoSearch:aString ignoreCase:ignoreCase
    ].
    ^ browser

    "
     SystemBrowser browseForString:'all'      in:(Array with:Object)
     SystemBrowser browseForString:'should'   in:(Array with:Object)
     SystemBrowser browseForString:'[eE]rror' in:(Array with:Object)
    "

    "Created: / 18.6.1998 / 16:42:50 / cg"
    "Modified: / 18.6.1998 / 16:51:25 / cg"
!

browseForSymbol:aSymbol
    "launch a browser for all methods referencing aSymbol"

    ^ self 
        browseForSymbol:aSymbol 
        title:(self classResources string:'Users of: %1' with:aSymbol) 
        warnIfNone:true

    "Created: 9.12.1995 / 18:04:34 / cg"
    "Modified: 10.7.1996 / 10:35:34 / cg"
!

browseForSymbol:aSymbol in:aSetOfClasses title:title warnIfNone:doWarn
    "launch a browser for all methods referencing aSymbol"

    ^ self
        browseForSymbol:aSymbol 
        in:aSetOfClasses 
        title:title 
        warnIfNone:doWarn
        searchFor:aSymbol
!

browseForSymbol:aSymbol in:aSetOfClasses title:title warnIfNone:doWarn searchFor:searchString
    "launch a browser for all methods referencing aSymbol"

    |browser searchBlock sym|

    (aSymbol includesMatchCharacters) ifTrue:[
        "a matchString"
        searchBlock := [:c :m :s |
                            (m literalsDetect:[:aLiteral|
                                (aLiteral isMemberOf:Symbol) 
                                  and:[aSymbol match:aLiteral]
                            ] ifNone:nil) notNil
                       ].
    ] ifFalse:[
        "
         can do a faster search
        "
        sym := aSymbol asSymbolIfInterned.
        sym isNil ifTrue:[
            self showNoneFound:title.
            ^ nil
        ].

        searchBlock := [:c :m :s |
                            (m literalsDetect:[:aLiteral|
                                (sym == aLiteral) 
                            ] ifNone:nil) notNil
                       ].
    ].
    doWarn ifFalse:[
        WarningSignal ignoreIn:[
            browser := self browseMethodsIn:aSetOfClasses where:searchBlock title:title.
        ]
    ] ifTrue:[
        browser := self browseMethodsIn:aSetOfClasses where:searchBlock title:title.
    ].

    (browser notNil 
    and:[searchString notNil]) ifTrue:[
        browser autoSearch:searchString
    ].
    ^ browser

    "Modified: 24.6.1996 / 14:39:07 / stefan"
    "Modified: 30.6.1996 / 16:45:25 / cg"
    "Created: 31.10.1996 / 14:57:30 / cg"
!

browseForSymbol:aSymbol title:title ifNone:actionIfNoneFound searchFor:searchString
    "launch a browser for all methods referencing aSymbol"

    |browser searchBlock|

    searchBlock := self searchBlockForSymbol:aSymbol.
    searchBlock == false ifTrue:[
        actionIfNoneFound value.
        ^ nil
    ].

    WarningSignal ignoreIn:[
        InformationSignal ignoreIn:[
            browser := self browseMethodsWhere:searchBlock title:title.
        ]
    ].
    browser isNil ifTrue:[
        actionIfNoneFound value.
        ^ nil
    ].

    (browser notNil and:[searchString notNil]) ifTrue:[
        browser autoSearch:searchString
    ].
    ^ browser

    "Modified: / 24-06-1996 / 14:39:07 / stefan"
    "Created: / 31-10-1996 / 14:45:08 / cg"
    "Modified: / 22-03-2012 / 06:58:07 / cg"
!

browseForSymbol:aSymbol title:title warnIfNone:doWarn
    "launch a browser for all methods referencing aSymbol"

    ^ self
        browseForSymbol:aSymbol 
        title:title 
        warnIfNone:doWarn 
        searchFor:aSymbol

    "Modified: 31.10.1996 / 14:45:38 / cg"
!

browseForSymbol:aSymbol title:title warnIfNone:doWarn searchFor:searchString
    "launch a browser for all methods referencing aSymbol"

    |b|

    doWarn ifTrue: [
        b := [self showNoneFound:title]
    ].
    ^ self
        browseForSymbol:aSymbol 
        title:title 
        ifNone:b
        searchFor:searchString
!

browseImplementorsMatching:aSelectorString
    "launch a browser for all implementors of aSelector"

    ^ self 
        browseImplementorsMatching:aSelectorString 
        in:(Smalltalk allClasses)

    "
     SystemBrowser browseImplementorsOf:#+
     NewSystemBrowser browseImplementorsOf:#+
    "

    "Created: / 9.12.1995 / 18:01:18 / cg"
    "Modified: / 5.11.2001 / 17:31:11 / cg"
!

browseImplementorsMatching:aSelectorString in:aSetOfClasses
    "launch a browser for all implementors of aSelector"

    ^ self 
        browseImplementorsMatching:aSelectorString
        in:aSetOfClasses
        title:(self classResources string:'implementors of: %1' with:aSelectorString)

    "
     SystemBrowser browseImplementorsOf:#+ in:(Number withAllSubclasses)
     NewSystemBrowser browseImplementorsOf:#+ in:(Number withAllSubclasses)
    "

    "Created: / 10.7.1996 / 10:20:59 / cg"
    "Modified: / 5.11.2001 / 17:30:57 / cg"
!

browseImplementorsMatching:aSelectorString in:aSetOfClasses ignoreCase:ignoreCase
    "launch a browser for all implementors of aSelector"

    ^ self 
        browseImplementorsMatching:aSelectorString
        in:aSetOfClasses
        ignoreCase:ignoreCase
        title:(self classResources string:'implementors of: %1' with:aSelectorString)

    "
     SystemBrowser browseImplementorsOf:#+ in:(Number withAllSubclasses)
     NewSystemBrowser browseImplementorsOf:#+ in:(Number withAllSubclasses)
    "

    "Created: / 10.7.1996 / 10:20:59 / cg"
    "Modified: / 5.11.2001 / 17:30:43 / cg"
!

browseImplementorsMatching:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase title:title
    "launch a browser for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses"

    |list|

    list := self 
                findImplementorsMatching:aSelectorString 
                in:aCollectionOfClasses 
                ignoreCase:ignoreCase.

    list size == 0 ifTrue:[
        self showNoneFound:title.
        ^ nil
    ].

    ^ self browseMethods:list asOrderedCollection title:title

    "
     SystemBrowser browseImplementorsOf:#+
                                     in:(Array with:Number
                                               with:Float
                                               with:SmallInteger)
                                  title:'some implementors of +'

     NewSystemBrowser browseImplementorsOf:#+
                                     in:(Array with:Number
                                               with:Float
                                               with:SmallInteger)
                                  title:'some implementors of +'
    "

    "Modified: / 4.9.1995 / 17:33:39 / claus"
    "Modified: / 19.6.1996 / 14:19:02 / stefan"
    "Modified: / 5.11.2001 / 17:30:38 / cg"
!

browseImplementorsMatching:aSelectorString in:aCollectionOfClasses title:title
    "launch a browser for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses"

    ^ self
        browseImplementorsMatching:aSelectorString 
        in:aCollectionOfClasses 
        ignoreCase:false
        title:title
!

browseImplementorsMatching:aSelectorString under:aClass
    "launch a browser for all implementors of aSelector in aClass
     and its subclasses"

    ^ self 
        browseImplementorsMatching:aSelectorString
        in:(aClass withAllSubclasses)
        title:(self classResources 
                string:'implementors of: %1 (in and below %2)' 
                with:aSelectorString
                with:aClass name)

    "
     SystemBrowser browseImplementorsOf:#+ under:Integer
     NewSystemBrowser browseImplementorsOf:#+ under:Integer
    "

    "Created: / 9.12.1995 / 18:06:09 / cg"
    "Modified: / 5.11.2001 / 17:30:15 / cg"
!

browseImplementorsOf:aSelectorString
    "launch a browser for all implementors of aSelector"

    ^ self 
        browseImplementorsOf:aSelectorString 
        in:(Smalltalk allClasses)

    "
     SystemBrowser browseImplementorsOf:#+
     NewSystemBrowser browseImplementorsOf:#+
    "

    "Created: / 9.12.1995 / 18:01:18 / cg"
    "Modified: / 5.11.2001 / 17:31:11 / cg"
!

browseImplementorsOf:aSelectorString in:aSetOfClasses
    "launch a browser for all implementors of aSelector"

    ^ self 
        browseImplementorsOf:aSelectorString
        in:aSetOfClasses
        title:(self classResources string:'Implementors of: %1' with:aSelectorString allBold)

    "
     SystemBrowser browseImplementorsOf:#+ in:(Number withAllSubclasses)
     NewSystemBrowser browseImplementorsOf:#+ in:(Number withAllSubclasses)
    "

    "Created: / 10.7.1996 / 10:20:59 / cg"
    "Modified: / 5.11.2001 / 17:30:57 / cg"
!

browseImplementorsOf:aSelectorString in:aSetOfClasses ignoreCase:ignoreCase
    "launch a browser for all implementors of aSelector"

    ^ self 
        browseImplementorsOf:aSelectorString
        in:aSetOfClasses
        ignoreCase:ignoreCase
        title:(self classResources string:'Implementors of: %1' with:aSelectorString)

    "
     SystemBrowser browseImplementorsOf:#+ in:(Number withAllSubclasses)
     NewSystemBrowser browseImplementorsOf:#+ in:(Number withAllSubclasses)
    "

    "Created: / 10.7.1996 / 10:20:59 / cg"
    "Modified: / 5.11.2001 / 17:30:43 / cg"
!

browseImplementorsOf:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch title:titleArg
    "launch a browser for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses"

    doMatch ifTrue:[
        self browseImplementorsOf:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase title:titleArg
    ] ifFalse:[
        self browseImplementorsMatching:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase title:titleArg
    ].

    "Created: / 14-02-2012 / 13:55:23 / cg"
!

browseImplementorsOf:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase title:titleArg
    "launch a browser for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses"

    |list list2 rs selWithColon title top20 allSelectors choice but globalClass global globalName lcSelector|

    title := titleArg.
    list := self 
                findImplementors:aSelectorString 
                in:aCollectionOfClasses 
                ignoreCase:ignoreCase
                match:(aSelectorString includesMatchCharacters and:[aSelectorString ~= '*']).

    list size == 0 ifTrue:[
        aSelectorString numArgs == 0 ifTrue:[
            selWithColon := aSelectorString , ':'.
            selWithColon knownAsSymbol ifTrue:[
                list2 := self findImplementorsOf:selWithColon in:aCollectionOfClasses ignoreCase:ignoreCase.
            ].            
        ].
        list2 size == 0 ifTrue:[
            "/ self showNoneFound:title.
            "/ ^ self
            lcSelector := aSelectorString asLowercase.
            
            allSelectors := Set new.
            top20 := SortedCollection new.
            top20 
                sortBlock:[:a :b | 
                    |isPrefixOfA isPrefixOfB aDist bDist|

                    isPrefixOfA := (a asLowercase startsWith:lcSelector).
                    isPrefixOfB := (b asLowercase startsWith:lcSelector).
                    (isPrefixOfA and:[isPrefixOfB not])
                    or:[ 
                        aDist := (a spellAgainst:aSelectorString).
                        bDist := (b spellAgainst:aSelectorString).
                        (isPrefixOfA and:[isPrefixOfB and:[aDist > bDist]])     
                        or:[ isPrefixOfB not and:[ aDist > bDist ]]]
                ].
            Smalltalk allMethodsWithSelectorDo:[:eachMethod :eachSelector |
                ((eachSelector asLowercase startsWith:lcSelector) or:[(eachSelector spellAgainst:aSelectorString) > 50]) ifTrue:[    
                    (allSelectors includes:eachSelector) ifFalse:[
                        allSelectors add:eachSelector.
                        top20 add:eachSelector.
                        top20 size > 20 ifTrue:[ top20 removeLast. allSelectors := top20 asSet ].
                    ]
                ]
            ].
            top20 isEmpty ifTrue:[
                Smalltalk allMethodsWithSelectorDo:[:eachMethod :eachSelector |
                    (eachSelector asLowercase spellAgainst:lcSelector) > 50 ifTrue:[    
                        (allSelectors includes:eachSelector) ifFalse:[
                            allSelectors add:eachSelector.
                            top20 add:eachSelector.
                            top20 size > 20 ifTrue:[ top20 removeLast. allSelectors := top20 asSet ].
                        ]
                    ]
                ].
            ].

            "/ for your convenience: look for a global class by that name, and offer browsing the class
            but := ''.
            (globalClass := Smalltalk classNamed:aSelectorString) notNil ifTrue:[
                top20 := (OrderedCollection withAll:top20) addFirst:('>> Browse class ',aSelectorString,' <<'); yourself.
                but := '\But there exists a class by that name.'.
            ] ifFalse:[
                (aSelectorString knownAsSymbol 
                and:[ (global := Smalltalk at:aSelectorString asSymbol) notNil ])
                ifTrue:[
                    global isBehavior ifTrue:[ 
                        top20 := (OrderedCollection withAll:top20) addFirst:('>> Browse alias ',aSelectorString,' <<'); yourself.
                        but := '\But there exists a global alias by that name.'.
                        globalClass := global
                    ] ifFalse:[
                        top20 := (OrderedCollection withAll:top20) addFirst:('>> Browse class of ',aSelectorString,' <<'); yourself.
                        but := '\But there exists a global by that name.'.
                        globalClass := global class.
                    ]
                ].
            ].
            "/ for your convenience: look for any namespace class by that name, and offer browsing the class
            but isEmpty ifTrue:[
                globalName := Smalltalk keys  
                                detect:[:nm | (nm includesString:'::')
                                               and:[ (nm includesString:aSelectorString) 
                                               and:[ (nm endsWith:('::',aSelectorString)) ]]] 
                                ifNone:nil. 
                globalName notNil ifTrue:[
                    globalClass := Smalltalk at:globalName.
                    globalClass isBehavior ifTrue:[
                        top20 := (OrderedCollection withAll:top20) addFirst:('>> Browse class ',globalClass name,' <<'); yourself.
                        but := '\But there exists a class in some namespace by that name.'.
                    ].
                ].
            ].

            choice := Dialog 
                choose:(title,(' - none found.',but,'\\Browse implementors of a similar selector or cancel:') withCRs)
                fromList:top20 
                lines:10.

            choice notEmptyOrNil ifTrue:[
                (choice startsWith:'>>') ifTrue:[
                    self openInClass:globalClass selector:nil.
                ] ifFalse:[
                    self browseImplementorsOf:choice in:aCollectionOfClasses ignoreCase:ignoreCase title:'Implementors of ',choice.
                ]
            ].
            ^ nil
        ].
        rs := self classResources.
        (Dialog confirm:((rs string:title) , 
                         (rs string:'...\\... none found.') ,
                         (rs string:'\\But I found %1 implementor(s) of the "%2" message (with colon).\\Browse those ?'
                             with:list2 size
                             with:selWithColon allBold)) withCRs) ifFalse:[
            ^ nil
        ].
        list := list2.
        title := title , ':'.

    ].

    ^ self browseMethods:list asOrderedCollection title:title

    "
     SystemBrowser browseImplementorsOf:#+
                                     in:(Array with:Number
                                               with:Float
                                               with:SmallInteger)
                                  title:'some implementors of +'

     NewSystemBrowser browseImplementorsOf:#+
                                     in:(Array with:Number
                                               with:Float
                                               with:SmallInteger)
                                  title:'some implementors of +'
    "

    "Modified: / 04-09-1995 / 17:33:39 / claus"
    "Modified: / 19-06-1996 / 14:19:02 / stefan"
    "Modified: / 15-01-2011 / 14:35:56 / cg"
!

browseImplementorsOf:aSelectorString in:aCollectionOfClasses title:title
    "launch a browser for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses"

    ^ self
        browseImplementorsOf:aSelectorString 
        in:aCollectionOfClasses 
        ignoreCase:false
        title:title
!

browseImplementorsOf:aSelectorString under:aClass
    "launch a browser for all implementors of aSelector in aClass
     and its subclasses"

    ^ self 
        browseImplementorsOf:aSelectorString
        in:(aClass withAllSubclasses)
        title:(self classResources 
                string:'Implementors of: %1 (in and below %2)' 
                with:aSelectorString
                with:aClass name)

    "
     SystemBrowser browseImplementorsOf:#+ under:Integer
     NewSystemBrowser browseImplementorsOf:#+ under:Integer
    "

    "Created: / 9.12.1995 / 18:06:09 / cg"
    "Modified: / 5.11.2001 / 17:30:15 / cg"
!

browseImplementorsOfAny:setOfSelectors 
    "launch a browser for all implementors of aSelector"

    ^ self 
        browseImplementorsOfAny:setOfSelectors
        in:(Smalltalk allClasses)

    "
     SystemBrowser browseImplementorsOfAny:#( #+ #- )
     NewSystemBrowser browseImplementorsOfAny:#( #+ #- )
    "

    "Created: / 9.12.1995 / 18:01:18 / cg"
    "Modified: / 5.11.2001 / 17:31:11 / cg"
!

browseImplementorsOfAny:setOfSelectors in:aSetOfClasses
    "launch a browser for all implementors of aSelector"

    |title|

    setOfSelectors size == 1 ifTrue:[
        title := self classResources 
                string:'Implementors of %1' 
                with:(setOfSelectors asOrderedCollection first).
    ] ifFalse:[
        setOfSelectors size == 2 ifTrue:[
            title := self classResources 
                    string:'Implementors of %1 or %2' 
                    with:(setOfSelectors asOrderedCollection first)
                    with:(setOfSelectors asOrderedCollection second).
        ] ifFalse:[
            title := self classResources string:'Implementors of some'.
        ].
    ].

    ^ self 
        browseImplementorsOfAny:setOfSelectors
        in:aSetOfClasses
        title:title

    "
     SystemBrowser browseImplementorsOf:#+ in:(Number withAllSubclasses)
     NewSystemBrowser browseImplementorsOf:#+ in:(Number withAllSubclasses)
    "

    "Created: / 10.7.1996 / 10:20:59 / cg"
    "Modified: / 5.11.2001 / 17:30:57 / cg"
!

browseImplementorsOfAny:setOfSelectors in:aCollectionOfClasses ignoreCase:ignoreCase title:title
    "launch a browser for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses"

    |list|

    list := self 
                findImplementorsOfAny:setOfSelectors 
                in:aCollectionOfClasses 
                ignoreCase:ignoreCase.

    list size == 0 ifTrue:[
        self showNoneFound:title.
        ^ nil
    ].

    ^ self browseMethods:list asOrderedCollection title:title

    "
     SystemBrowser browseImplementorsOf:#+
                                     in:(Array with:Number
                                               with:Float
                                               with:SmallInteger)
                                  title:'some implementors of +'

     NewSystemBrowser browseImplementorsOf:#+
                                     in:(Array with:Number
                                               with:Float
                                               with:SmallInteger)
                                  title:'some implementors of +'
    "

    "Modified: / 4.9.1995 / 17:33:39 / claus"
    "Modified: / 19.6.1996 / 14:19:02 / stefan"
    "Modified: / 5.11.2001 / 17:30:38 / cg"
!

browseImplementorsOfAny:setOfSelectors in:aCollectionOfClasses title:title
    "launch a browser for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses"

    ^ self
        browseImplementorsOfAny:setOfSelectors 
        in:aCollectionOfClasses 
        ignoreCase:false
        title:title
!

browseInstRefsTo:aString in:aCollectionOfClasses modificationsOnly:modsOnly
    "launch a browser for all methods in aClass where the instVar named
     aString is referenced; if modsOnly is true, browse only methods where the
     instvar is modified"

    ^ self browseRefsTo:aString classVars:false in:aCollectionOfClasses modificationsOnly:modsOnly
!

browseInstRefsTo:varName in:aCollectionOfClasses modificationsOnly:modsOnly title:title
    "launch a browser for all methods in aClass where the instVar named
     varName is referenced; if modsOnly is true, browse only methods where the
     instvar is modified"

    ^ self browseRefsTo:varName classVars:false in:aCollectionOfClasses modificationsOnly:modsOnly title:title
!

browseInstRefsTo:aString under:aClass modificationsOnly:modsOnly
    "launch a browser for all methods in aClass and subclasses
     where the instVar named aString is referenced; 
     if modsOnly is true, browse only methods where the instvar is modified"

    ^ self browseInstRefsTo:aString in:(aClass withAllSubclasses) modificationsOnly:modsOnly
!

browseReferendsOf:aGlobalName
    "launch a browser for all methods referencing a global
     named aGlobalName. The argument may be a symbol, a string or
     a matchPattern.
    "

    ^ self browseReferendsOf:aGlobalName warnIfNone:true 

   "
    UserPreferences current systemBrowserClass browseReferendsOf:#Transcript
    UserPreferences current systemBrowserClass browseReferendsOf:'Tr*'
   "

    "Modified: / 30.10.1997 / 23:45:52 / cg"
!

browseReferendsOf:aGlobalName ifNone:actionIfNone
    "launch a browser for all methods referencing a global
     named aGlobalName.
    "

    ^ self
        browseReferendsOf:aGlobalName 
        title:(self classResources string:'Users of: %1' with:aGlobalName)
        ifNone:actionIfNone

    "Modified: / 31.10.1997 / 15:42:05 / cg"
!

browseReferendsOf:aGlobalName in:aSetOfClasses
    "launch a browser for all methods referencing a global
     named aGlobalName.
    "

    ^ self browseReferendsOf:aGlobalName in:aSetOfClasses warnIfNone:true 

   "
    Browser browseReferendsOf:#Transcript
   "

    "Created: 10.7.1996 / 10:37:30 / cg"
!

browseReferendsOf:aGlobalName in:aSetOfClasses warnIfNone:doWarn
    "launch a browser for all methods referencing a global
     named aGlobalName.
    "

    |globalsPlainName idx|

    globalsPlainName := aGlobalName.
    (idx := globalsPlainName lastIndexOf:$:) ~~ 0 ifTrue:[
        globalsPlainName := globalsPlainName copyFrom:idx+1
    ].

    ^ self browseForSymbol:aGlobalName
                        in:aSetOfClasses
                     title:(self classResources string:'Users of: %1' with:aGlobalName) 
                warnIfNone:doWarn
                 searchFor:globalsPlainName

    "Created: 10.7.1996 / 10:37:02 / cg"
    "Modified: 31.10.1996 / 14:56:38 / cg"
!

browseReferendsOf:aGlobalName title:title ifNone:actionIfNone
    "launch a browser for all methods referencing a global named aGlobalName."

    |searchBlock browser|

    searchBlock := self searchBlockForReferendsOf:aGlobalName.
    browser := self 
                browseMethodsWhere:searchBlock 
                title:title 
                ifNone:[
                    actionIfNone value. 
                    ^ nil
                ].

    browser isNil ifTrue:[
        actionIfNone value
    ] ifFalse:[
        browser autoSearchVariable:aGlobalName.
    ].
    ^ browser

    "
     Tools::NewSystemBrowser browseReferendsOf:'SortedCollection' title:'foo' ifNone:[ self halt ]
    "
!

browseReferendsOf:aGlobalName title:title warnIfNone:doWarn
    "launch a browser for all methods referencing a global
     named aGlobalName.
    "

    |b|

    doWarn ifTrue: [
        b := [self showNoneFound:title]
    ].

    ^ self
        browseReferendsOf:aGlobalName 
        title:title 
        ifNone:b

!

browseReferendsOf:aGlobalName warnIfNone:doWarn
    "launch a browser for all methods referencing a global
     named aGlobalName.
    "

    ^ self
        browseReferendsOf:aGlobalName 
        title:(self classResources string:'Users of: %1' with:aGlobalName)
        warnIfNone:doWarn

    "Modified: / 31.10.1997 / 15:42:05 / cg"
!

browseReferendsOfUnboundGlobalsWithTitle:title ifNone:actionIfNone
    "launch a browser for all methods referencing an unbound global."

    |searchBlock browser|

    searchBlock := [:cls :mthd :sel | 

                    |mSource globals potentialNames|

                    "/ kludge: Lazy methods do not include symbols in the literal array - sigh
                    mthd isLazyMethod ifTrue:[
                        mSource := mthd source.
                        mSource notNil ifTrue:[
                            globals := mthd usedGlobals.
                        ].
                    ] ifFalse:[
                        "/ try hard to avoid the usedGlobals - its expensive
                        potentialNames := mthd literals select:[:lit | lit isSymbol and:[lit size > 0 and:[lit isUppercaseFirst]]].
                        potentialNames notEmpty ifTrue:[
                            potentialNames := potentialNames select:[:lit | (Smalltalk at:lit) isNil].
                            potentialNames notEmpty ifTrue:[
                                globals := mthd usedGlobals.
                            ]
                        ]
                    ].
                    globals notNil ifTrue:[
                        globals contains:[:aGlobalKey | (Smalltalk at:aGlobalKey asSymbol) isNil].
                    ] ifFalse:[
                        false
                    ]
                  ].

    browser := self browseMethodsWhere:searchBlock title:title ifNone:[actionIfNone value. ^ nil].
    browser isNil ifTrue:[
        actionIfNone value
    ].
    ^ browser
!

browseReferendsOfUnboundGlobalsWithTitle:title warnIfNone:doWarn
    "launch a browser for all methods referencing an unbound global.
    "

    |b|

    doWarn ifTrue: [
        b := [self showNoneFound:title]
    ].

    ^ self
        browseReferendsOfUnboundGlobalsWithTitle:title 
        ifNone:b
!

browseRefsTo:aString classVars:classVars in:aCollectionOfClasses modificationsOnly:modsOnly
    "launch a browser for all methods in aClass where the instVar/classVar named
     aString is referenced; if modsOnly is true, browse only methods where the
     instvar is modified"

    |title|

    modsOnly ifTrue:[
        title := 'Modifications of: %1'
    ] ifFalse:[
        title := 'References to: %1 '
    ].
    ^ self 
        browseRefsTo:aString 
        classVars:classVars 
        in:aCollectionOfClasses 
        modificationsOnly:modsOnly 
        title:(self classResources string:title with:aString)

    "Created: 9.12.1995 / 18:07:05 / cg"
    "Modified: 9.12.1995 / 18:11:49 / cg"
!

browseRefsTo:varName classVars:classVars in:aCollectionOfClasses modificationsOnly:modsOnly title:title
    "launch a browser for all methods in aClass where the instVar/classVar named
     varName is referenced; if modsOnly is true, browse only methods where the
     instvar is modified"

    |filter browser pattern|

    filter := self filterToSearchRefsTo:varName classVars:classVars modificationsOnly:modsOnly.
    browser := self browseMethodsIn:aCollectionOfClasses inst:true class:classVars where:filter title:title.

    browser notNil ifTrue:[
        modsOnly ifTrue:[
            pattern := varName , ' :='
        ] ifFalse:[
            pattern := varName
        ].
        browser autoSearch:pattern 
    ].
    ^ browser
!

browseSendersOf:aSelectorString
    "launch a browser for all senders of aSelector"

    ^ self browseAllCallsOn:aSelectorString

    "
     SystemBrowser browseSendersOf:#+
     UserPreferences current systemBrowserClass browseSendersOf:#+
    "

    "Modified: / 10.7.1996 / 10:26:15 / cg"
    "Created: / 13.11.2001 / 13:52:12 / cg"
!

browseSuperCallsIn:aCollectionOfClasses title:title
    "launch a browser for all super sends in aCollectionOfClasses"

    |browser searchBlock|

    searchBlock := [:class :method :s | 
        |src parser|

        src := method source.
        (src notNil and:[ (src findString:'super') ~~ 0 ])  ifTrue:[
             parser := Parser 
                        parseMethod:src 
                        in:class 
                        ignoreErrors:true 
                        ignoreWarnings:true.

            (parser notNil and:[parser ~~ #Error and:[parser usesSuper]])
        ] ifFalse:[
            false
        ]
    ].

    browser := self browseMethodsIn:aCollectionOfClasses
                              where:searchBlock
                              title:title.

    browser notNil ifTrue:[
        browser autoSearch:'super' 
    ].
    ^ browser

    "
     SystemBrowser
         browseSuperCallsIn:(Array with:SortedCollection)
                      title:'superSends in SortedCollection'
    "

    "Created: / 23-11-1995 / 14:08:55 / cg"
    "Modified: / 06-03-2007 / 14:00:12 / cg"
!

browseSuperCallsUnder:aClass
    "launch a browser for all supersends in aClass and subclasses"

    ^ self browseSuperCallsIn:(aClass withAllSubclasses)
                        title:(self classResources string:'Supersends (in and below %1)' with:aClass name)

    "
     SystemBrowser browseSuperCallsUnder:Number
    "

    "Created: 23.11.1995 / 12:06:06 / cg"
    "Modified: 9.12.1995 / 18:11:59 / cg"
!

browseUsesOf:aClass
    |dict owners offsets
     sz  "{ Class: SmallInteger }"
     n   "{ Class: SmallInteger }"
     removeSet newDict|

    owners := ObjectMemory whoReferencesInstancesOf:aClass.

    "
     collect set of offsets in dict; key is class
    "
    dict := IdentityDictionary new.
    owners do:[:someObject |
        |cls create|

        someObject isContext ifFalse:[
            "
             someObject refers to an instance of aClass;
             find out, which instVar(s)
            "
            cls := someObject class.
            cls ~~ Array ifTrue:[
                n := cls instSize.
                create := [|s| s := Set new. dict at:cls put:s. s].

                1 to:n do:[:i |
                    |ref|

                    ref := someObject instVarAt:i.
                    (ref isMemberOf:aClass) ifTrue:[
                        offsets := dict at:cls ifAbsent:create.
                        offsets add:i.
                    ]
                ].
                cls isVariable ifTrue:[
                    cls isPointers ifTrue:[
                        | idx "{ Class: SmallInteger }" |

                        sz := someObject basicSize.
                        idx := 1.
                        [idx <= sz] whileTrue:[
                            |ref|

                            ref := someObject basicAt:idx.
                            (ref isMemberOf:aClass) ifTrue:[
                                offsets := dict at:cls ifAbsent:create.
                                offsets add:0.
                                idx := sz
                            ].
                            idx := idx + 1
                        ]
                    ]        
                ]
            ]
        ]
    ].

    "
     merge with superclass refs
    "
    dict keysAndValuesDo:[:cls :set |
        cls allSuperclasses do:[:aSuperclass |
            |superSet|

            superSet := dict at:aSuperclass ifAbsent:[].
            superSet notNil ifTrue:[
                superSet := dict at:aSuperclass.
                removeSet := Set new.
                set do:[:offset |
                    (superSet includes:offset) ifTrue:[
                        removeSet add:offset
                    ]
                ].
                set removeAll:removeSet
            ]
        ]
    ].

    "
     remove empty ones
    "
    removeSet := Set new.
    dict keysAndValuesDo:[:cls :set |
        set isEmpty ifTrue:[
            removeSet add:cls
        ]
    ].
    dict removeAllKeys:removeSet.

    "
     replace the indices by real names
    "
    newDict := IdentityDictionary new.
    dict keysAndValuesDo:[:cls :set |
        |newSet names|

        names := cls allInstVarNames.
        newSet := set collect:[:index | 
                index == 0 ifTrue:['*indexed*'] ifFalse:[names at:index].
        ].
        newDict at:cls put:newSet
    ].

    newDict inspect
!

filterToSearchRefsTo:varName classVars:classVars access:accessType
    "return a searchblock for variable references (obsolete)"

    ^ self
        filterToSearchRefsTo:varName 
        instVars:(classVars not) 
        classVars:classVars 
        globals:false
        poolVars:false 
        access:accessType
!

filterToSearchRefsTo:varName classVars:classVars modificationsOnly:modsOnly
    "return a searchblock for variable references"

    ^ self
        filterToSearchRefsTo:varName 
        classVars:classVars 
        access:(modsOnly ifTrue:#write ifFalse:#readWrite)
!

filterToSearchRefsTo:varName instVars:doInstVars classVars:doClassVars globals:doGlobals access:accessType
    "return a searchblock for variable references"

    ^ self
        filterToSearchRefsTo:varName instVars:doInstVars classVars:doClassVars globals:doGlobals 
        poolVars:false access:accessType
!

filterToSearchRefsTo:varName instVars:doInstVars classVars:doClassVars globals:doGlobals poolVars:doPoolVars access:accessType
    "return a searchblock for variable references"

    |searchBlock needMatch baseVarName|

    needMatch := varName includesMatchCharacters.
    (varName includes:$:) ifTrue:[
        baseVarName := varName copyFrom:(varName lastIndexOf:$:)+1
    ] ifFalse:[
        baseVarName := varName
    ].

    searchBlock := [:c :m :s |
        |src result parser vars instVars classVars poolVars globals|

        result := false.

        "/ JV Following code is bad. It assumes that method is a Smalltalk method.
        "/ But it may not, it could be JavaScript method, Java method or whatever fancy language 
        "/ method. Should be actually delegated to the method itself.

        m programmingLanguage isSmalltalk ifTrue:[
            "/ For Smalltalk, use parser...
            src := m source.
            src notNil ifTrue:[
                needMatch ifFalse:[
                    "
                     before doing a slow parse, quickly scan the
                     method's source for the variable's name ...
                    "
                    result := (src findString:baseVarName) ~~ 0.
                ] ifTrue:[
                    result := true.
                ].
                result ifTrue:[
                    result := false.
                    parser := Parser
                                    parseMethod:src 
                                    in:c 
                                    ignoreErrors:true 
                                    ignoreWarnings:true.

                    (parser notNil and:[parser ~~ #Error]) ifTrue:[
                        vars := Set new.    
                        doInstVars ifTrue:[
                            accessType == #read ifTrue:[
                                instVars := parser readInstVars
                            ] ifFalse:[
                                accessType == #write ifTrue:[
                                    instVars := parser modifiedInstVars
                                ] ifFalse:[
                                    instVars := parser usedInstVars
                                ]
                            ].
                            vars addAll:instVars.
                        ].
                        doClassVars ifTrue:[
                            accessType == #read ifTrue:[
                                classVars := parser readClassVars
                            ] ifFalse:[
                                accessType == #write ifTrue:[
                                    classVars := parser modifiedClassVars
                                ] ifFalse:[
                                    classVars := parser usedClassVars
                                ]
                            ].
                            vars addAll:classVars.
                        ].
                        doPoolVars ifTrue:[
                            accessType == #read ifTrue:[
                                poolVars := parser readPoolVars
                            ] ifFalse:[
                                accessType == #write ifTrue:[
                                    poolVars := parser modifiedPoolVars
                                ] ifFalse:[
                                    poolVars := parser usedPoolVars
                                ]
                            ].
                            vars addAll:poolVars.
                        ].
                        doGlobals ifTrue:[
                            accessType == #read ifTrue:[
                                globals := parser readGlobals
                            ] ifFalse:[
                                accessType == #write ifTrue:[
                                    globals := parser modifiedGlobals
                                ] ifFalse:[
                                    globals := parser usedGlobals
                                ]
                            ].
                            vars addAll:globals.
                        ].
                        vars size > 0 ifTrue:[
                            needMatch ifTrue:[
                                result := vars contains:[:cv | (varName match:cv)]
                            ] ifFalse:[
                                result := vars includes:varName
                            ]
                        ]
                    ].
                ].
            ].
        ] ifFalse:[
            "/ For all other languages, ask method.
            vars := Set new.
            doInstVars ifTrue:[
                accessType == #read ifTrue:[
                    instVars := m readInstVars
                ] ifFalse:[
                    accessType == #write ifTrue:[
                        instVars := m modifiedInstVars
                    ] ifFalse:[
                        instVars := m usedInstVars
                    ]
                ].
                vars addAll:instVars.
            ].
            doClassVars ifTrue:[
                accessType == #read ifTrue:[
                    classVars := m readClassVars
                ] ifFalse:[
                    accessType == #write ifTrue:[
                        classVars := m modifiedClassVars
                    ] ifFalse:[
                        classVars := m usedClassVars
                    ]
                ].
                vars addAll:classVars.
            ].
            doPoolVars ifTrue:[
                accessType == #read ifTrue:[
                    poolVars := m readPoolVars
                ] ifFalse:[
                    accessType == #write ifTrue:[
                        poolVars := m modifiedPoolVars
                    ] ifFalse:[
                        poolVars := m usedPoolVars
                    ]
                ].
                vars addAll:poolVars.
            ].
            doGlobals ifTrue:[
                accessType == #read ifTrue:[
                    globals := m readGlobals
                ] ifFalse:[
                    accessType == #write ifTrue:[
                        globals := m modifiedGlobals
                    ] ifFalse:[
                        globals := m usedGlobals
                    ]
                ].
                vars addAll:globals.
            ].
            vars size > 0 ifTrue:[
                needMatch ifTrue:[
                    result := vars contains:[:cv | (varName match:cv)]
                ] ifFalse:[
                    result := vars includes:varName
                ]
            ]
        ].
        Processor yield.
        result
    ].
    ^ searchBlock

    "Modified: / 19-06-1997 / 18:27:57 / cg"
    "Modified (format): / 25-11-2011 / 14:00:44 / cg"
    "Modified: / 06-09-2013 / 18:02:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

findAnyResourceIn:aCollectionOfClasses 
    "return a collection of all methods in aCollectionOfClasses containing any resource."

    ^ self findMethodsIn:aCollectionOfClasses where:[:c :m :sel | m hasResource ].

    "
     SystemBrowser findAnyResourceIn:(ApplicationModel withAllSubclasses)
    "
!

findClassRefsTo:aString in:aCollectionOfClasses access:accessType
    "return all methods in aCollectionOfClasses where the classVar named
     aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    ^ self findRefsTo:aString classVars:true in:aCollectionOfClasses access:accessType
!

findClassRefsTo:aString in:aCollectionOfClasses modificationsOnly:modsOnly
    "return all methods in aCollectionOfClasses where the classVar named
     aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    ^ self findRefsTo:aString classVars:true in:aCollectionOfClasses modificationsOnly:modsOnly
!

findClassRefsTo:aString inClass:aClass access:accessType
    "return all methods in aClass where the classVar named
     aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    ^ self findRefsTo:aString classVars:true in:(Array with:aClass) access:accessType
!

findClassRefsTo:aString inClass:aClass modificationsOnly:modsOnly
    "return all methods in aClass where the classVar named
     aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    ^ self findRefsTo:aString classVars:true in:(Array with:aClass) modificationsOnly:modsOnly
!

findClassRefsTo:aString under:aClass access:accessType
    "return all methods in aClass and subclasses
     where the classVar named aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    ^ self findClassRefsTo:aString in:(aClass withAllSubclasses) access:accessType
!

findClassRefsTo:aString under:aClass modificationsOnly:modsOnly
    "return all methods in aClass and subclasses
     where the classVar named aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    ^ self findClassRefsTo:aString in:(aClass withAllSubclasses) modificationsOnly:modsOnly

!

findCode:aCodeString in:aCollectionOfClasses isMethod:isMethod 
    "return a collection of all methods in aCollectionOfClasses  
     containing a matching piece of code.
     This may be slow, since source-code has to be scanned."

    |searchBlock|

    searchBlock := self searchBlockForCode:aCodeString in:aCollectionOfClasses isMethod:isMethod.
    searchBlock isNil ifTrue:[ ^ nil].
    ^ self findMethodsIn:aCollectionOfClasses where:searchBlock.

    "Modified: / 02-05-2011 / 13:25:15 / sr"
!

findCode:aCodeString inMethods:aCollectionOfMethods isMethod:isMethod 
    "return a collection of all methods in aCollectionOfMethods  
     containing a matching piece of code."

    |searchBlock|

    searchBlock := self searchBlockForCode:aCodeString in:(aCollectionOfMethods collect:[:each | each mclass]) isMethod:isMethod.
    searchBlock isNil ifTrue:[ ^ nil].
    ^ aCollectionOfMethods select:[:m | searchBlock value:m mclass value:m value:m selector].

    "Modified: / 02-05-2011 / 13:25:39 / sr"
!

findExceptionHandlersIn:aCollectionOfClasses
    "return a collection of all methods in aCollectionOfClasses  
     containing an exception raiser.
     This may be slow, since source-code has to be scanned."

    ^ self findUsingParseTreeSearcher:(ParseTreeSearcher handlesException) in:aCollectionOfClasses

    "Modified: / 11-05-2010 / 16:18:55 / cg"
!

findExceptionHandlersInMethods:aCollectionOfMethods
    "return a collection of all methods in aCollectionOfClasses  
     containing an exception raiser.
     This may be slow, since source-code has to be scanned."

    ^ self findUsingParseTreeSearcher:(ParseTreeSearcher handlesException) inMethods:aCollectionOfMethods

    "Created: / 11-05-2010 / 16:20:48 / cg"
!

findExceptionRaisersIn:aCollectionOfClasses
    "return a collection of all methods in aCollectionOfClasses  
     containing an exception raiser.
     This may be slow, since source-code has to be scanned."

    ^ self findUsingParseTreeSearcher:(ParseTreeSearcher raisesException) in:aCollectionOfClasses

    "Modified: / 11-05-2010 / 16:18:48 / cg"
!

findExceptionRaisersInMethods:aCollectionOfMethods
    "return a collection of all methods in aCollectionOfClasses  
     containing an exception raiser.
     This may be slow, since source-code has to be scanned."

    ^ self findUsingParseTreeSearcher:(ParseTreeSearcher raisesException) inMethods:aCollectionOfMethods

    "Created: / 11-05-2010 / 16:20:36 / cg"
!

findHelpSpecMethodsWithString:aString in:aCollectionOfClasses ignoreCase:ignoreCase 
    "return a collection of all help-spec methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."
    
    ^ self 
        findSpecMethodsFor:#help
        withString:aString
        in:aCollectionOfClasses
        ignoreCase:ignoreCase
!

findHelpSpecMethodsWithString:aString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch
    "return a collection of all help-spec methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."
    
    ^ self 
        findSpecMethodsFor:#help
        withString:aString
        in:aCollectionOfClasses
        ignoreCase:ignoreCase
        match:doMatch
!

findImplementors:aSelectorMatchString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch
    "search for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses.
     Return a collection of methods"

    |lcSelector list compare testST testJava srchBlockST srchBlockJava collectionOfClasses|

    list := IdentitySet new.
    aSelectorMatchString size == 0 ifTrue:[ ^ list ].

    (doMatch and:[aSelectorMatchString includesMatchCharacters]) ifTrue:[
        compare := [:sel :search | sel match:search].
    ] ifFalse:[
        compare := [:sel :search | sel = search].
    ].

    ignoreCase == true ifTrue:[
        lcSelector := aSelectorMatchString asLowercase.

        testST := [:mthdSelector :aMethod | (compare value:lcSelector value:mthdSelector asLowercase) ].
        testJava := [:mthdSelector :aMethod | (compare value:lcSelector value:aMethod name asLowercase) ].
    ] ifFalse:[
        testST := [:mthdSelector :aMethod | (compare value:aSelectorMatchString value:mthdSelector) ].
        testJava := [:mthdSelector :aMethod | (compare value:aSelectorMatchString value:aMethod name) ].
    ].

    srchBlockST := [:mthdSelector :mthd | (testST value:mthdSelector value:mthd) ifTrue:[ list add:mthd]].
    srchBlockJava := [:mthdSelector :mthd | (testJava value:mthdSelector value:mthd) ifTrue:[ list add:mthd]].

    (collectionOfClasses := aCollectionOfClasses) isNil ifTrue:[
        collectionOfClasses := Smalltalk allClasses
    ].    
    collectionOfClasses do:[:aClass |
        |srchBlock|

        aClass isObsolete ifFalse:[
            srchBlock := aClass isJavaClass 
                            ifTrue:[ srchBlockJava ]
                            ifFalse:[ srchBlockST ].

            aClass methodDictionary keysAndValuesDo:srchBlock.
            aClass isMeta ifFalse:[
                aClass class methodDictionary keysAndValuesDo:srchBlock
            ]
        ]
    ].

    ^ list

    "
     SystemBrowser 
        findImplementorsOf:#+
        in: { Number . Float . SmallInteger }
        ignoreCase: false

     Time millisecondsToRun:[    
         SystemBrowser 
            findImplementorsOf:#add:
            in: (Smalltalk allClasses)
            ignoreCase: false
     ]
    "

    "Modified (format): / 22-03-2012 / 07:28:50 / cg"
!

findImplementors:aSelectorMatchString inMethods:aCollectionOfMethods ignoreCase:ignoreCase match:doMatch
    "search for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses.
     Return a collection of methods"

    |list compare testST testJava lcSelector|

    list := IdentitySet new.
    aSelectorMatchString size == 0 ifTrue:[ ^ list ].

    doMatch ifTrue:[
        compare := [:sel :search | sel match:search].
    ] ifFalse:[
        compare := [:sel :search | sel = search].
    ].

    ignoreCase == true ifTrue:[
        lcSelector := aSelectorMatchString asLowercase.

        testST := [:mthdSelector :aMethod | (compare value:lcSelector value:mthdSelector asLowercase) ].
        testJava := [:mthdSelector :aMethod | (compare value:lcSelector value:aMethod name asLowercase) ].
    ] ifFalse:[
        testST := [:mthdSelector :aMethod | (compare value:aSelectorMatchString value:mthdSelector) ].
        testJava := [:mthdSelector :aMethod | (compare value:aSelectorMatchString value:aMethod name) ].
    ].

    aCollectionOfMethods do:[:eachMethod |
        |cls sel testBlock|

        cls := eachMethod mclass.
        (cls isNil or:[cls isObsolete]) ifFalse:[
            cls isJavaClass ifTrue:[
                testBlock := testJava
            ] ifFalse:[
                testBlock := testST
            ].
            sel := eachMethod selector.    
            (testBlock value:sel value:eachMethod) ifTrue:[
                list add:eachMethod
            ].
        ]
    ].

    ^ list

    "Modified: / 29-08-2006 / 14:33:42 / cg"
!

findImplementorsMatching:aSelectorMatchString in:aCollectionOfClasses ignoreCase:ignoreCase
    "search for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses.
     Return a collection of methods"

    ^ self 
        findImplementors:aSelectorMatchString 
        in:aCollectionOfClasses 
        ignoreCase:ignoreCase 
        match:true

    "
     SystemBrowser 
        findImplementorsOf:#+
        in:{ Number . Float . SmallInteger }
        ignoreCase:false
    "

    "Modified (comment): / 22-03-2012 / 07:20:42 / cg"
!

findImplementorsMatchingAny:aCollectionOfSelectors in:aCollectionOfClasses ignoreCase:ignoreCase
    "search for all implementors of any in aCollectionOfSelectors in
     the classes contained in aCollectionOfClasses and their metaclasses.
     Return a collection of methods.
     CAVEAT: searches multiple times (could be tuned alot if heavily used)"

    ^ aCollectionOfSelectors 
        collectAll:[:eachSelector |
            self findImplementorsMatching:eachSelector 
                 in:aCollectionOfClasses 
                 ignoreCase:ignoreCase.
        ].

"/    |implementors|
"/
"/    implementors := IdentitySet new.
"/    aCollectionOfSelectors do:[:eachSelector |
"/        implementors addAll:(self findImplementorsMatching:eachSelector in:aCollectionOfClasses ignoreCase:ignoreCase).
"/    ].
"/    ^ implementors

    "
     self
        findImplementorsMatchingAny:#( 'at*:' '*size')
        in:(Smalltalk allClasses) 
        ignoreCase:true
    "
!

findImplementorsOf:aSelectorMatchString in:aCollectionOfClasses ignoreCase:ignoreCase
    "search for all implementors of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses.
     Return a collection of methods"

    ^ self 
        findImplementors:aSelectorMatchString 
        in:aCollectionOfClasses 
        ignoreCase:ignoreCase 
        match:false

    "
     SystemBrowser findImplementorsOf:#+
                                   in:(Array with:Number
                                             with:Float
                                             with:SmallInteger)
    "
!

findImplementorsOfAny:aCollectionOfSelectors in:aCollectionOfClasses ignoreCase:ignoreCase
    "search for all implementors of any in aCollectionOfSelectors in
     the classes contained in aCollectionOfClasses and their metaclasses.
     Return a collection of methods.
     CAVEAT: searches multiple times (could be tuned alot if heavily used)"

    ^ aCollectionOfSelectors 
        collectAll:[:eachSelector |
            self findImplementorsOf:eachSelector 
                 in:aCollectionOfClasses 
                 ignoreCase:ignoreCase.
        ].

"/    |implementors|
"/
"/    implementors := IdentitySet new.
"/    aCollectionOfSelectors do:[:eachSelector |
"/        implementors addAll:(self findImplementorsOf:eachSelector in:aCollectionOfClasses ignoreCase:ignoreCase).
"/    ].
"/    ^ implementors
!

findInstRefsTo:aString in:aCollectionOfClasses access:accessType
    "return all methods in aCollectionOfClasses where the instVar named
     aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    ^ self findRefsTo:aString classVars:false in:aCollectionOfClasses access:accessType
!

findInstRefsTo:aString in:aCollectionOfClasses modificationsOnly:modsOnly
    "return all methods in aCollectionOfClasses where the instVar named
     aString is referenced; if modsOnly is true, browse only methods where the
     instvar is modified"

    ^ self findRefsTo:aString classVars:false in:aCollectionOfClasses modificationsOnly:modsOnly
!

findInstRefsTo:aString inClass:aClass access:accessType
    "return all methods in aClass where the instVar named
     aString is referenced; if modsOnly is true, browse only methods where the
     instvar is modified"

    ^ self findRefsTo:aString classVars:false in:(Array with:aClass) access:accessType
!

findInstRefsTo:aString inClass:aClass modificationsOnly:modsOnly
    "return all methods in aClass where the instVar named
     aString is referenced; if modsOnly is true, browse only methods where the
     instvar is modified"

    ^ self findRefsTo:aString classVars:false in:(Array with:aClass) modificationsOnly:modsOnly
!

findInstRefsTo:aString under:aClass access:accessType
    "return all methods in aClass and subclasses
     where the classVar named aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    ^ self findInstRefsTo:aString in:(aClass withAllSubclasses) access:accessType
!

findInstRefsTo:aString under:aClass modificationsOnly:modsOnly
    "return all methods in aClass and subclasses
     where the instVar named aString is referenced; 
     if modsOnly is true, browse only methods where the instvar is modified"

    ^ self findInstRefsTo:aString in:(aClass withAllSubclasses) modificationsOnly:modsOnly
!

findMenuSpecMethodsWithString:aString in:aCollectionOfClasses ignoreCase:ignoreCase 
    "return a collection of all menu-spec methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."
    
    ^ self 
        findSpecMethodsFor:#menu
        withString:aString
        in:aCollectionOfClasses
        ignoreCase:ignoreCase
!

findMenuSpecMethodsWithString:aString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch
    "return a collection of all menu-spec methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."
    
    ^ self 
        findSpecMethodsFor:#menu
        withString:aString
        in:aCollectionOfClasses
        ignoreCase:ignoreCase
        match:doMatch
!

findPoolVarRefsTo:aString inClass:aClass access:accessType
    "return all methods in aClass where the pool variable named aString is referenced; 
     if modsOnly is true, browse only methods where the classvar is modified"

    |filter|

    filter := self 
                filterToSearchRefsTo:aString 
                instVars:false classVars:false globals:false poolVars:true 
                access:accessType.

    ^ self findMethodsIn:(Array with:aClass) inst:true class:true where:filter.
!

findRefsTo:varName classVars:classVars in:aCollectionOfClasses access:accessType
    "return a list of all methods in aCollectionOfClasses where the instVar/classVar named
     varName is referenced; 
     if modsOnly is true, browse only methods where the instvar is modified"

    |filter|

    filter := self filterToSearchRefsTo:varName classVars:classVars access:accessType.
    ^ self findMethodsIn:aCollectionOfClasses inst:true class:classVars where:filter.

    "
     self
        findRefsTo:'x'
        classVars:false
        in:(Array with:Point)
        modificationsOnly:true
    "
!

findRefsTo:varName classVars:classVars in:aCollectionOfClasses modificationsOnly:modsOnly
    "return a list of all methods in aCollectionOfClasses where the instVar/classVar named
     varName is referenced; 
     if modsOnly is true, browse only methods where the instvar is modified"

    |filter|

    filter := self filterToSearchRefsTo:varName classVars:classVars modificationsOnly:modsOnly.
    ^ self findMethodsIn:aCollectionOfClasses inst:true class:classVars where:filter.

    "
     self
        findRefsTo:'x'
        classVars:false
        in:(Array with:Point)
        modificationsOnly:true
    "
!

findResource:aResourceSymbolOrCollectionOfSymbols in:aCollectionOfClasses 
    "return a collection of all methods in aCollectionOfClasses  
     containing a resource."

    |searchBlock|

    aResourceSymbolOrCollectionOfSymbols isSymbol ifTrue:[
        searchBlock := [:c :m :sel | |resources|
                            (resources := m resources) size > 0
                            and:[resources includesKey:aResourceSymbolOrCollectionOfSymbols]
                       ].
    ] ifFalse:[
        searchBlock := [:c :m :sel | |resources|
                            (resources := m resources) size > 0
                            and:[resources keys includesAny:aResourceSymbolOrCollectionOfSymbols]
                       ].
    ].

    ^ self findMethodsIn:aCollectionOfClasses where:searchBlock.

    "
     SystemBrowser findResource:#image in:(ApplicationModel withAllSubclasses)
     SystemBrowser findResource:#menu in:(ApplicationModel withAllSubclasses)
     SystemBrowser findResource:#(menu programMenu) in:(ApplicationModel withAllSubclasses)
    "
!

findResource:aStringOrEmpty match:doMatch ignoreCase:ignoreCase in:aCollectionOfClasses 
    "return a collection of all methods in aCollectionOfClasses containing a matching resource."

    |matchCheck lcSearchString|

    aStringOrEmpty isEmptyOrNil ifTrue:[
        matchCheck := [:aResourceName | true ]
    ] ifFalse:[
        doMatch ifTrue:[
            matchCheck := [:aResourceName | aStringOrEmpty match:aResourceName caseSensitive:ignoreCase not]
        ] ifFalse:[
            ignoreCase ifTrue:[
                lcSearchString := aStringOrEmpty asLowercase.
                matchCheck := [:aResourceName | aResourceName asLowercase = lcSearchString]
            ] ifFalse:[
                matchCheck := [:aResourceName | aResourceName = aStringOrEmpty ]
            ]
        ].
    ].

    ^ self 
        findMethodsIn:aCollectionOfClasses 
        where:[:c :m :sel | 
            m hasResource
            and:[m resources notNil and:[m resources keys contains:matchCheck]]
        ].

    "
     SystemBrowser findResource:'*debug*' match:true ignoreCase:true in:(GenericException withAllSubclasses)
    "

    "Created: / 06-07-2011 / 12:14:24 / cg"
!

findRespondersOfAll:aCollectionOfSelectors in:aCollectionOfClasses ignoreCase:ignoreCase
    "search for all classes which respond to all of the selectors in aCollectionOfSelectors.
     Search within the classes contained in aCollectionOfClasses and their metaclasses.
     This will skip over unloaded classes.
     Return a collection of classes."

    ^ Smalltalk allClasses 
        select:[:cls |
            cls isLoaded 
            and:[ aCollectionOfSelectors conform:[:sel | cls canUnderstand:sel]]].

    "
     to find classes which respond to both indexOf: and replaceFromIndex:toIndex:,
     use:
        SystemBrowser 
            findRespondersOfAll:#( indexOf: removeFromIndex:toIndex: ) 
            in:nil 
            ignoreCase:false
    "
!

findSendersOf:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase
    "search for all senders of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses.
     Return a collection of methods"

    ^ self allCallsOn:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase match:true

    "
     SystemBrowser findSendersOf:#+
                   in:(Array with:Number
                             with:Float
                             with:SmallInteger)
                   ignoreCase:false
    "
!

findSendersOf:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch
    "search for all senders of aSelector in
     the classes contained in aCollectionOfClasses and their metaclasses.
     Return a collection of methods"

    ^ self allCallsOn:aSelectorString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch

    "
     SystemBrowser findSendersOf:#+
                   in:(Array with:Number
                             with:Float
                             with:SmallInteger)
                   ignoreCase:false
    "
!

findSendersOf:aSelectorString inMethods:aCollectionOfMethods ignoreCase:ignoreCase
    "search for all senders of aSelector in aCollectionOfMethods.
     Return a collection of methods"

    |searchBlock|

    searchBlock := self searchBlockForAllCallsOn:aSelectorString ignoreCase:ignoreCase.
    searchBlock isNil ifTrue:[^ #() ].
    ^ aCollectionOfMethods select:[:m | searchBlock value:m mclass value:m value:m selector].
!

findSendersOf:aSelectorString inMethods:aCollectionOfMethods ignoreCase:ignoreCase match:doMatch
    "search for all senders of aSelector in aCollectionOfMethods.
     Return a collection of methods"

    |searchBlock|

    searchBlock := self searchBlockForAllCallsOn:aSelectorString ignoreCase:ignoreCase match:doMatch.
    searchBlock isNil ifTrue:[^ #() ].
    ^ aCollectionOfMethods select:[:m | searchBlock value:m mclass value:m value:m selector].
!

findSendersOfAny:aCollectionOfSelectors in:aCollectionOfClasses ignoreCase:ignoreCase
    "search for all senders of any selector in aCollectionOfSelectors in
     the classes contained in aCollectionOfClasses and their metaclasses.
     Return a collection of methods.
     CAVEAT: searches multiple times (could be tuned alot if heavily used)"

    ^ aCollectionOfSelectors 
        collectAll:[:eachSelector |
            (self allCallsOn:eachSelector 
                 in:aCollectionOfClasses 
                 ignoreCase:ignoreCase
                 match:false) asSet.
        ].

"/    |allSenders|
"/
"/    allSenders := IdentitySet new.
"/    aCollectionOfSelectors do:[:eachSelector |
"/        allSenders addAll:(self allCallsOn:eachSelector in:aCollectionOfClasses ignoreCase:ignoreCase match:true)
"/    ].
"/    ^ allSenders

    "
     SystemBrowser findSendersOfAny:#(#'+' #'-')
                   in:(Array with:Number
                             with:Float
                             with:SmallInteger)
                   ignoreCase:false  
    "
!

findSpecMethodsFor:specSymbol withString:aString in:aCollectionOfClasses ignoreCase:ignoreCase
    "return a collection of all specSymbol-spec methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."

    self 
        findSpecMethodsFor:specSymbol 
        withString:aString 
        in:aCollectionOfClasses 
        ignoreCase:ignoreCase
        match:true
!

findSpecMethodsFor:specSymbol withString:aString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch
    "return a collection of all specSymbol-spec methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."

    |searchBlock innerSearchBlock|

    innerSearchBlock := self searchBlockForString:aString ignoreCase:ignoreCase match:doMatch.

    searchBlock := [:c :m :sel | 
                            |resources| 

                            ((resources := m resources) size > 0
                            and:[resources includesKey:specSymbol]) ifTrue:[
                                innerSearchBlock value:c value:m value:sel
                            ]
                       ].

    ^ self findMethodsIn:aCollectionOfClasses where:searchBlock.
!

findString:aString in:aCollectionOfClasses ignoreCase:ignoreCase 
    "return a collection of all methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."
    
    ^ self 
        findString:aString
        in:aCollectionOfClasses
        ignoreCase:ignoreCase
        match:true

    "
     SystemBrowser findString:'should' in:(Array with:Object) ignoreCase:false
    "
!

findString:aString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch
    "return a collection of all methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."

    ^ self findString:aString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch fullWordsOnly:false

    "
     SystemBrowser 
        findString:'should'   
        in:(Array with:Object) 
        ignoreCase:false
    "
!

findString:aString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch fullWordsOnly:fullWordsOnly
    "return a collection of all methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."

    |searchBlock|

    searchBlock := 
        self 
            searchBlockForString:aString 
            ignoreCase:ignoreCase 
            match:doMatch
            fullWordsOnly:fullWordsOnly.
    ^ self findMethodsIn:aCollectionOfClasses where:searchBlock.

    "
     SystemBrowser findString:'should'   in:(Array with:Object) ignoreCase:false
    "
!

findString:aString inMethods:aCollectionOfMethods ignoreCase:ignoreCase match:doMatch
    "return a collection of all methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."

    ^ self findString:aString inMethods:aCollectionOfMethods ignoreCase:ignoreCase match:doMatch fullWordsOnly:false
!

findString:aString inMethods:aCollectionOfMethods ignoreCase:ignoreCase match:doMatch fullWordsOnly:fullWordsOnly
    "return a collection of all methods in aCollectionOfClasses  
     containing a string in their source.
     This may be slow, since source-code has to be scanned."

    |searchBlock|

    searchBlock := self searchBlockForString:aString ignoreCase:ignoreCase match:doMatch fullWordsOnly:fullWordsOnly.
    ^ aCollectionOfMethods select:[:m | searchBlock value:m mclass value:m value:m selector].
!

findStringLiteral:aString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch
    "return a collection of all methods in aCollectionOfClasses  
     containing a string in any of their string-literals."

    ^ self 
        findStringLiteral:aString in:aCollectionOfClasses 
        ignoreCase:ignoreCase match:doMatch fullWordsOnly:false

    "
     SystemBrowser findStringLiteral:'error' in:(Array with:Object) ignoreCase:true match:false
    "
!

findStringLiteral:aString in:aCollectionOfClasses ignoreCase:ignoreCase match:doMatch fullWordsOnly:fullWordsOnly
    "return a collection of all methods in aCollectionOfClasses  
     containing a string in any of their string-literals."

    |searchBlock|

    searchBlock := self searchBlockForStringLiteral:aString ignoreCase:ignoreCase match:doMatch fullWordsOnly:fullWordsOnly.
    ^ self findMethodsIn:aCollectionOfClasses where:searchBlock.

    "
     SystemBrowser findStringLiteral:'error' in:(Array with:Object) ignoreCase:true match:false
    "
!

findStringLiteral:aString inMethods:aCollectionOfMethods ignoreCase:ignoreCase match:doMatch
    "return a collection of all methods in aCollectionOfClasses  
     containing a string in any of their string-literals."

    ^ self
        findStringLiteral:aString inMethods:aCollectionOfMethods
        ignoreCase:ignoreCase match:doMatch fullWordsOnly:false
!

findStringLiteral:aString inMethods:aCollectionOfMethods ignoreCase:ignoreCase match:doMatch fullWordsOnly:fullWordsOnly
    "return a collection of all methods in aCollectionOfClasses  
     containing a string in any of their string-literals."

    |searchBlock|

    searchBlock := self searchBlockForStringLiteral:aString ignoreCase:ignoreCase match:doMatch fullWordsOnly:fullWordsOnly.
    ^ aCollectionOfMethods select:[:m | searchBlock value:m mclass value:m value:m selector].
!

findUsingParseTreeSearcher:searcher in:aCollectionOfClasses
    "return a collection of all methods in aCollectionOfClasses  
     containing an exception raiser.
     This may be slow, since source-code has to be scanned."

    |searchBlock|

    searchBlock := self searchBlockForParseTreeSearcher:searcher isMethod:false.
    searchBlock isNil ifTrue:[ ^ nil].
    ^ self findMethodsIn:aCollectionOfClasses where:searchBlock.

    "Created: / 11-05-2010 / 16:18:36 / cg"
!

findUsingParseTreeSearcher:searcher inMethods:aCollectionOfMethods
    "return a collection of all methods in aCollectionOfClasses  
     containing an exception raiser.
     This may be slow, since source-code has to be scanned."

    |searchBlock|

    searchBlock := self searchBlockForParseTreeSearcher:searcher isMethod:false.
    searchBlock isNil ifTrue:[ ^ nil].
    ^ aCollectionOfMethods select:[:m | searchBlock value:m mclass value:m value:m selector].

    "Created: / 11-05-2010 / 16:20:12 / cg"
!

searchBlockForAllCallsOn:aSelectorString ignoreCase:ignoreCase
    ^ self searchBlockForAllCallsOn:aSelectorString ignoreCase:ignoreCase match:true
!

searchBlockForAllCallsOn:aSelectorString ignoreCase:ignoreCase match:doMatchArg
    "return an optimized search block for the senders search.
     Because this highly affects the speed of the senders-search in the browser,
     specialized blocks are returned, depending on whether a selector-match or casesensitive
     search is wanted 
     (these operations are executed a zillion times in an inner loop,
      therefore, the speedup is noticable)"
     
    |doMatch sel quickSearch idx|

    doMatch := doMatchArg.
    (doMatch and:[aSelectorString = '*']) ifTrue:[
        "a trivial block, which matches everything"
        ^ [:class :method :s | true].
    ].    

    aSelectorString includesMatchCharacters ifFalse:[
        doMatch := false
    ].
    
    (doMatch or:[ignoreCase]) ifTrue:[
        "/ a matchString or ignoreCase - need string matching procedure

        quickSearch := aSelectorString.
        (quickSearch startsWith:'*') ifTrue:[
            quickSearch := quickSearch copyButFirst
        ].
        (quickSearch endsWith:'*') ifTrue:[
            quickSearch := quickSearch copyButLast
        ].
        
        "/ for keyword selector searches, only look for the first KW-part in the quicksearch
        "/ for matches, only look for substrings up to the first match character
        (idx := quickSearch indexOfAny:'*#[:') ~~ 0 ifTrue:[
            quickSearch := quickSearch copyTo:idx-1.
        ].
        
        (ignoreCase and:[quickSearch includesMatchCharacters not]) ifTrue:[
            doMatch ifFalse:[
                ^ [:class :methodArg :s |
                    |method src inLiterals skip|

                    inLiterals := skip := false.
                    method := methodArg originalMethodIfWrapped.
                    method isLazyMethod ifTrue:[
                        src := method source.
                        (src notNil and:[src includesString:aSelectorString caseSensitive:false]) ifTrue:[
                            method makeRealMethod.
                        ] ifFalse:[
                            skip := true
                        ].    
                    ].
                    skip ifFalse:[
                        inLiterals := 
                            (method 
                                literalsDetect:[:aLiteral|
                                    (aLiteral isMemberOf:Symbol) 
                                    and:[(aLiteral sameAs:aSelectorString)]] 
                                ifNone:nil) notNil
                    ].

                    inLiterals 
                    and:[
                        method messagesSent contains:[:msg | msg sameAs:aSelectorString ]
                    ]
               ].
            ].
            
            ^ [:class :methodArg :s |
                |method src inLiterals skip|

                inLiterals := skip := false.
                method := methodArg originalMethodIfWrapped.
                method isLazyMethod ifTrue:[
                    src := method source.
                    (src notNil and:[src includesString:quickSearch caseSensitive:false]) ifTrue:[
                        method makeRealMethod.
                    ] ifFalse:[
                        skip := true
                    ].
                ].    
                skip ifFalse:[
                    inLiterals := 
                        (method 
                            literalsDetect:[:aLiteral|
                                (aLiteral isMemberOf:Symbol) 
                                and:[(aLiteral includesString:quickSearch caseSensitive:false)
                                and:[(aSelectorString match:aLiteral caseSensitive:false)]]] 
                            ifNone:nil) notNil
                ].
      
                inLiterals 
                and:[
                    method messagesSent 
                        contains:[:sel | aSelectorString match:aSelectorString caseSensitive:false]
                ]
           ].
        ].
        
        (ignoreCase or:[quickSearch includesMatchCharacters]) ifFalse:[
            ^ [:class :methodArg :s |
                |method src inLiterals skip|

                inLiterals := skip := false.
                method := methodArg originalMethodIfWrapped.
                method isLazyMethod ifTrue:[
                    src := method source.
                    (src notNil and:[src includesString:quickSearch]) ifTrue:[
                        method makeRealMethod.
                    ] ifFalse:[
                        skip := true
                    ].    
                ].    
                skip ifFalse:[
                    inLiterals := 
                        (method 
                            literalsDetect:[:aLiteral|
                                (aLiteral isMemberOf:Symbol) 
                                and:[(aLiteral includesString:quickSearch)
                                and:[(aSelectorString match:aLiteral)]]] 
                            ifNone:nil) notNil
                ].
                inLiterals and:[ method messagesSent includes:aSelectorString]
           ].
        ]. 
        ^ [:class :methodArg :s |
            |method src inLiterals skip|

            method := methodArg originalMethodIfWrapped.
            "/ expensive search
            inLiterals := skip := false.
            method isLazyMethod ifTrue:[
                src := method source.
                (src notNil and:[src includesMatchString:aSelectorString]) ifTrue:[
                    method makeRealMethod.
                ] ifFalse:[
                    skip := true.
                ].
            ].    
            skip ifFalse:[
                inLiterals := 
                    (method literalsDetect:[:aLiteral|
                        (aLiteral isMemberOf:Symbol) 
                        and:[ aSelectorString match:aLiteral asLowercase caseSensitive:ignoreCase not]
                    ] ifNone:nil) notNil
            ].
            inLiterals 
            and:[ 
                method messagesSent 
                    contains:[:anySelector | 
                        aSelectorString match:anySelector caseSensitive:ignoreCase not
                    ] 
            ]
       ].
    ].
    
    "/ no matchString and not ignoring case - can do it much faster
    sel := aSelectorString asSymbolIfInterned.
    sel isNil ifTrue:[
        ^ nil     "/ none
    ].

    quickSearch := sel.
    "/ for keyword selector searches, only look for the first KW-part in the quicksearch
    (idx := quickSearch indexOf:$:) ~~ 0 ifTrue:[
        quickSearch := quickSearch copyTo:idx-1.
    ].
    
    ^ [:class :methodArg :s |
        |method src|

        method := methodArg originalMethodIfWrapped.
        method isLazyMethod ifTrue:[
            src := method source.
            (src notNil and:[src includesString:quickSearch]) ifTrue:[
                method makeRealMethod.
                method referencesLiteral: "sends:" sel.
            ] ifFalse:[
                false
            ]
        ] ifFalse:[
            method sends:sel
        ]
    ].

    "Modified: / 28-07-2011 / 10:52:51 / cg"
!

searchBlockForCode:aCodeString in:aCollectionOfClasses isMethod:isMethod
    "return a block to search for a piece of code.
     intelligent search: because parsing and the parseTree-match is a relatively
     expensive operation, we try hard to reduce the amount of searched methods by:
        - extracting sent messages from the pattern, and limiting the search to
          methods which also send all those messages,
        - extracting accessed globals from the pattern, and limiting the search to
          methods which also refer to those globals"

    |errAction searchTree searcher globalVariablesUsed usedSymbols usedStrings
     sentMessages searchBlock foundMatch numMethodArgs methodSelector nameSpacesForGlobals|

"/self halt.
"/rule := ParseTreeLintRule 
"/    createParseTreeRule: (Array with: aCodeString)
"/    method: isMethod
"/    name: 'Search for: ' , aCodeString.
"/self halt.
"/
"/    searchBlock := [:c :m :sel | 
"/        rslt := SmalllintChecker
"/            runRule:rule
"/            onEnvironment: (ClassEnvironment onEnvironment:(BrowserEnvironment new) classes:(Array with:c)).
"/        
"/        self halt.
"/    ].
"/^ searchBlock.

    errAction := 
        [:errMsg :pos | 
            Dialog warn:('Error during pattern parse: %1 (position %2)'
                            bindWith:errMsg with:pos).
           ^ nil
        ].

    isMethod ifTrue:[
        searchTree := RBParser 
                    parseRewriteMethod:aCodeString 
                    onError: errAction.
        numMethodArgs := searchTree arguments size.
        methodSelector := searchTree selector.
    ] ifFalse:[
        searchTree := RBParser 
                    parseRewriteExpression:aCodeString 
                    onError: errAction.
    ].
    
    "/ extract messages sent by the pattern
    Error handle:[:ex |
        self halt:'check this, please'.
    ] do:[
        sentMessages := searchTree sentMessages.         
    ].

    nameSpacesForGlobals := Set with:Smalltalk.
    aCollectionOfClasses do:[:eachClass |
        nameSpacesForGlobals add:eachClass topNameSpace
    ].

    "/ extract globals used by the pattern
    globalVariablesUsed := OrderedCollection new.
    searchTree referencedVariables do:[:node |
        |nm ns alternatives|

        node isPatternNode ifFalse:[
            nm := node name.
            ns := nameSpacesForGlobals detect:[:ns | ns includesKey: nm asSymbol] ifNone:nil.
            ns notNil ifTrue:[
                alternatives := OrderedCollection new.
                nm asSymbolIfInterned notNil ifTrue:[ alternatives add: nm asSymbol ].
                ('Smalltalk::',nm) asSymbolIfInterned notNil ifTrue:[ alternatives add: ('Smalltalk::',nm) asSymbol ].
                (ns name,'::',nm) asSymbolIfInterned notNil ifTrue:[ alternatives add: (ns name,'::',nm) asSymbol ].
                nm asSymbolIfInterned notNil ifTrue:[ alternatives add: nm asSymbol ].
                globalVariablesUsed add:alternatives
            ].
        ]
    ].

    "/ sorry: 
    "/      cannot use literals to speedup the search, because stc does not store
    "/      constants in the literal-array. However, we can do a string search on
    "/      them, to avoid parsing.
    usedSymbols := searchTree usedSymbols.
    usedStrings := searchTree usedLiterals select:[:lit | lit isString].

    searcher := ParseTreeSearcher new.
    isMethod ifTrue:[
        searcher 
            matchesMethod:aCodeString
            do:[:aNode :answer | foundMatch := true].
    ] ifFalse:[
        searcher 
            matchesTree:searchTree
            do:[:aNode :answer | foundMatch := true].
    ].
    searcher computeQuickSearchStrings.

    searchBlock := 
        [:c :m :sel | 
            |isSTCCompiled allSelectorsInLiteralArray allMessagesSent 
             allGlobalsReferenced allUsedSymbolsInLiteralArray allStringsInLiteralArray
             allSent src rslt parseTree
             literalsInMethod|       

            foundMatch := false.

            "/ can speedup the search, by filtering for number of message-args first...
            (isMethod not 
            or:[ numMethodArgs isNil
            or:[ numMethodArgs == m numArgs ]]) ifTrue:[
                m isLazyMethod ifTrue:[
                    src := m source.
                    src notNil ifTrue:[
                        m makeRealMethod.
                    ].
                ].
                "/ can speedup the search, by quickly filtering for sent messages...
                literalsInMethod := m literals.
                allSelectorsInLiteralArray := sentMessages isEmptyOrNil or:[ literalsInMethod includesAll:sentMessages ].
                allSelectorsInLiteralArray ifTrue:[
                    "/ and used symbols/globals first...
                    allUsedSymbolsInLiteralArray := usedSymbols isEmptyOrNil or:[ literalsInMethod includesAll:usedSymbols ].
                    allUsedSymbolsInLiteralArray ifTrue:[
                        "/ if ANY string is in match, ANY string must be in method (not true, but I am lazy)
                        "/ that does not work for stc compiled code, because it does not put strings into the literal array
                        isSTCCompiled := m byteCode isNil.
                        isSTCCompiled ifTrue:[
                            allStringsInLiteralArray := true.   "/ stc-compiled: don't know    
                        ] ifFalse:[
                            allStringsInLiteralArray := usedStrings isEmptyOrNil
                                                        or:[ literalsInMethod includesAll:usedStrings "literalsInMethod contains:[:lit | lit isString]" ].
                        ].
                        allStringsInLiteralArray ifTrue:[
                            allGlobalsReferenced := globalVariablesUsed conform:[:varNames | varNames contains:[:varName | m referencesGlobal:varName]].
                            allGlobalsReferenced ifTrue:[
                                allMessagesSent := sentMessages isEmptyOrNil 
                                                   or:[ m messagesSent includesAll:sentMessages ].
                                allMessagesSent ifTrue:[
                                    src := m source.
                                    src isNil ifTrue:[
                                        ('Browser [info]: no source for ' , m printString) infoPrintCR.
                                    ] ifFalse:[
                                        isSTCCompiled ifTrue:[
                                            usedStrings notEmptyOrNil ifTrue:[
                                                "/ now that we have the source, scan the source for the literal strings,
                                                "/ before doing a slow parse
                                                allStringsInLiteralArray := usedStrings conform:[:eachString | src includesString:eachString].
                                            ]
                                        ].
                                        allStringsInLiteralArray ifTrue:[
                                            (searcher canQuicklyReject:src) ifTrue:[
                                                "/ Transcript show:'qReject: '; showCR:m whoString.
                                            ] ifFalse:[
                                                "/ the rest is done by the slower RB-match process...
                                                parseTree := 
                                                    RBParser 
                                                        parseSearchMethod:src 
                                                        onError: [:str :pos | 
                                                            "/ self halt.
                                                            Transcript show:'Error during search in '; showCR:m. 
                                                            Transcript showCR:str. 
                                                            Transcript showCR:pos. 
                                                            nil
                                                        ].

                                                parseTree notNil ifTrue:[
                                                    searcher executeTree:parseTree.
                                                    "/ notice: searcher sets foundMatch !!
                                                ].
                                            ].
                                        ].
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ].
            foundMatch.
       ].
    ^ searchBlock.

    "Created: / 02-05-2011 / 13:25:01 / sr"
    "Modified: / 20-07-2012 / 19:07:36 / cg"
!

searchBlockForCode:aCodeString isMethod:isMethod
    "return a block to search for a piece of code (intelligent search)."

    ^ self searchBlockForCode:aCodeString in:#() isMethod:isMethod

    "Modified: / 02-05-2011 / 13:26:18 / sr"
!

searchBlockForParseTreeSearcher:searcher isMethod:isMethod
    "return a block to search for a piece of code (intelligent search)."

    |errAction searchBlock foundMatch|

    errAction := [:str :pos | 
                    Dialog warn:'Error during parse: ' , str , ' (position ' , pos printString , ')'.
                    ^ nil
                 ].

    searchBlock := [:c :m :sel | 
                        |src parseTree|       

                        foundMatch := false.

                        m isLazyMethod ifTrue:[
                            src := m source.
                            src notNil ifTrue:[
                                m makeRealMethod.
                            ].
                        ].

                        src := m source.
                        src isNil ifTrue:[
                            ('Browser [info]: no source for ' , m printString) infoPrintCR.
                        ] ifFalse:[
                            parseTree := RBParser 
                                            parseSearchMethod:src 
                                            onError: [:str :pos | 
                                                Transcript show:'Error in '; showCR:m. 
                                                Transcript showCR:str. 
                                                Transcript showCR:pos. 
                                                nil].

                            parseTree notNil ifTrue:[
                                foundMatch := searcher executeTree:parseTree initialAnswer:false.
                            ]
                        ].
                        foundMatch.
                   ].

    ^ searchBlock.

    "Created: / 11-05-2010 / 16:14:25 / cg"
    "Modified: / 11-05-2010 / 22:05:09 / cg"
!

searchBlockForReferendsOf:aGlobalName
    "return a block which searches for all methods which reference a global named aGlobalName,
     which may be a matchpattern"

    |globalsPlainName idx sym1 sym2|

    globalsPlainName := aGlobalName.
    (idx := globalsPlainName lastIndexOf:$:) ~~ 0 ifTrue:[
        globalsPlainName := globalsPlainName copyFrom:idx+1.
        (globalsPlainName size == 0 or:[globalsPlainName = '*']) ifTrue:[
            globalsPlainName := aGlobalName
        ]
    ].

    "/ matchingGlobalNames := OrderedCollection new.

    aGlobalName includesMatchCharacters ifFalse:[
        sym1 := aGlobalName asSymbolIfInterned. 
        sym2 := globalsPlainName asSymbolIfInterned.
        (sym1 isNil and:[ sym2 isNil ]) ifTrue:[
            ^ [:cls :mthd :sel | false ].
        ].
        "/ if any is nil, search for the same
        sym1 := sym1 ? sym2.
        sym2 := sym2 ? sym1.

        ^ [:cls :mthd :sel |
            |mSource ok m usedGlobals|

            ok := false.
            "/ kludge: Lazy methods do not include symbols in the literal array - sigh
            mthd isLazyMethod ifTrue:[
                mSource := mthd source.
                (mSource notNil) ifTrue:[
                    (mSource includesString:(sym2)) ifTrue:[
                        usedGlobals := mthd usedGlobals.
                        (usedGlobals includes:sym1) ifTrue:[
                            ok := true
                        ] ifFalse:[
                            (sym1 ~= sym2 and:[usedGlobals includes:sym2]) ifTrue:[
                                ok := true
                            ]
                        ]
                    ]
                ]
            ] ifFalse:[
                m := mthd originalMethodIfWrapped.
                ((m refersToLiteral:sym1) or:[ sym1 ~= sym2 and:[m refersToLiteral:sym2] ]) ifTrue:[
                    usedGlobals := m usedGlobals.
                    ok := (usedGlobals includes:sym1) or:[ sym1 ~= sym2 and:[usedGlobals includes:sym2] ]
                ].
            ].
            ok
        ].
    ].

    ^ [:cls :mthd :sel | 
        |mSource usedGlobals global m|

        "/ kludge: Lazy methods do not include symbols in the literal array - sigh
        mthd isLazyMethod ifTrue:[
            mSource := mthd source.
            mSource notNil ifTrue:[
                usedGlobals := mthd usedGlobals
            ]
        ] ifFalse:[
            m := mthd originalMethodIfWrapped.
            (m literals contains:[:lit | (aGlobalName match:lit) or:[globalsPlainName match:lit]]) ifTrue:[
                usedGlobals := m usedGlobals
            ].
        ].
        usedGlobals notNil ifTrue:[
            global := usedGlobals detect:[:lit | aGlobalName match:lit] ifNone:nil.
            global isNil ifTrue:[
                global := usedGlobals detect:[:lit | globalsPlainName match:lit] ifNone:nil.
            ].
"/            global notNil ifTrue:[
"/                matchingGlobalNames add:global.
"/            ]
        ].
        global notNil
    ].

    "Modified: / 24-07-2011 / 09:50:30 / cg"
!

searchBlockForString:aString ignoreCase:ignoreCase match:doMatchArg
    "return a block to search for a string."

    ^ self 
        searchBlockForString:aString 
        ignoreCase:ignoreCase 
        match:doMatchArg 
        fullWordsOnly:false

    "
     SystemBrowser 
        findString:'should'   
        in:(Array with:Object) 
        ignoreCase:false
    "
!

searchBlockForString:aString ignoreCase:ignoreCase match:doMatchArg fullWordsOnly:fullWordsOnly
    "return a block to search for a string."

    |checkBlock lineCheckBlock pattern doMatch
     quickCheckString firstMatchIndex lastMatchIndex|

    doMatch := doMatchArg.
    aString includesMatchCharacters ifFalse:[
        doMatch := false.
    ].    
    doMatch ifTrue:[
        "a matchString"
        pattern := aString.

        firstMatchIndex := aString indexOfAny:'*#['.
        lastMatchIndex := aString lastIndexOfAny:'*#['.
        "/ which is longer - left or right part
        firstMatchIndex-1 "nleft" > (aString size-lastMatchIndex) "nright" ifTrue:[
            "/ use left part as quickSearch
            quickCheckString := aString copyTo:firstMatchIndex-1
        ] ifFalse:[
            "/ use right part as quickSearch
            quickCheckString := aString copyFrom:lastMatchIndex+1            
        ].    

        aString first == $* ifFalse:[
            pattern := '*',pattern
        ].    
        aString last == $* ifFalse:[
            pattern := pattern,'*'
        ].
        "/ when doing a match, be careful to not match acrosss lines
        lineCheckBlock := [:line | pattern match:line caseSensitive:ignoreCase not].
        quickCheckString size > 1 ifTrue:[
            checkBlock := [:src | 
                            (src includesString:quickCheckString caseSensitive:ignoreCase not)
                            and:[ (lineCheckBlock value:src)
                            and:[ src asStringCollection contains:lineCheckBlock ]]].
        ] ifFalse:[    
            checkBlock := [:src | 
                            (lineCheckBlock value:src)
                            and:[ src asStringCollection contains:lineCheckBlock ]].
        ].
    ] ifFalse:[
        checkBlock := [:src | src includesString:aString caseSensitive:ignoreCase not]
    ].
    
    ^ [:cls :mthd :sel | 
        |src found idx1 reallyFound ch1 ch2|

        found := false.
        src := mthd source.
        src isNil ifTrue:[
            ('Browser [info]: no source for ' , mthd printString) infoPrintCR.
        ] ifFalse:[
            found := checkBlock value:src.
            (fullWordsOnly and:[found]) ifTrue:[
                self halt.
                doMatch ifTrue:[
                    
                ] ifFalse:[
                    reallyFound := false.
                    idx1 := 0.
                    [ 
                        reallyFound not
                        and:[
                            idx1 := src indexOfSubCollection:aString startingAt:idx1+1 ifAbsent:0 caseSensitive:ignoreCase not.
                            idx1 ~~ 0]
                    ] whileTrue:[
                        "/ see if it is a free-standing word
                        reallyFound := true.
                        idx1 > 1 ifTrue:[
                            ch1 := src at:idx1-1.
                            (ch1 isLetter or:[ch1 == $_]) ifTrue:[ reallyFound := false].
                        ].
                        (idx1+aString size-1) < src size ifTrue:[
                            ch2 := src at:idx1+aString size.
                            (ch2 isLetter or:[ch2 == $_]) ifTrue:[ reallyFound := false].
                        ].
                    ].
                    found := reallyFound
                ].                
            ].                
        ].
        found
      ]

    "
     SystemBrowser findString:'should'   in:(Array with:Object) ignoreCase:false
    "
!

searchBlockForStringLiteral:aString ignoreCase:ignoreCase match:doMatchArg
    "return a block to search for a string-literal."

    ^ self
        searchBlockForStringLiteral:aString ignoreCase:ignoreCase match:doMatchArg
        fullWordsOnly:false

    "
     SystemBrowser findStringLiteral:'error' in:(Array with:Object) ignoreCase:true match:true
     SystemBrowser findStringLiteral:'error' in:(Array with:Object) ignoreCase:true match:false
     SystemBrowser findStringLiteral:'error' in:(Array with:Object) ignoreCase:false match:true
     SystemBrowser findStringLiteral:'error' in:(Array with:Object) ignoreCase:false match:false
    "
!

searchBlockForStringLiteral:aString ignoreCase:ignoreCase match:doMatchArg fullWordsOnly:fullWordsOnly
    "return a block to search for a string-literal."

    |pattern doMatch checkLiteral checkSource 
     quickCheckString firstMatchIndex lastMatchIndex|

    aString isEmpty ifTrue:[^ [:cls :mthd :sel | true ]].
    
    doMatch := doMatchArg.
    (aString includesMatchCharacters) ifFalse:[
        doMatch := false
    ].
    doMatch ifTrue:[
        "a matchString"
        pattern := aString.    
        aString first == $* ifFalse:[
            pattern := '*',pattern
        ].    
        aString last == $* ifFalse:[
            pattern := pattern,'*'
        ].
        checkLiteral := [:lit | pattern match:lit caseSensitive:ignoreCase not].
        firstMatchIndex := aString indexOfAny:'*#['.
        lastMatchIndex := aString lastIndexOfAny:'*#['.
        "/ which is longer - left or right part?
        firstMatchIndex-1 "nleft" > (aString size-lastMatchIndex) "nright" ifTrue:[
            "/ use left part as quickSearch
            quickCheckString := aString copyTo:firstMatchIndex-1
        ] ifFalse:[
            "/ use right part as quickSearch
            quickCheckString := aString copyFrom:lastMatchIndex+1            
        ].    
        quickCheckString size > 1 ifTrue:[
            checkSource := [:src | src includesString:quickCheckString caseSensitive:ignoreCase not]
        ] ifFalse:[
            checkSource := [:src | true]. "/ not worth the effort
        ].    
    ] ifFalse:[
        ignoreCase ifTrue:[
            checkLiteral := [:lit | lit includesString:aString caseSensitive:true].
            checkSource := [:src | src includesString:aString caseSensitive:true].
        ] ifFalse:[
            checkLiteral := [:lit | lit includesString:aString].
            checkSource := [:src | src includesString:aString].
        ].    
    ].
        
    ^ [:cls :methodArg :sel | 
        "/ sorry: the following does not work, because stc does not place string-constants
        "/ into the literals.
        "/        (mthd literalsDetect:[:lit |
        "/            lit isString
        "/            and:[ lit isSymbol not
        "/            and:[ checkLiteral value:lit ]]
        "/        ] ifNone:[nil]) 
        "/            notNil
        "/ so we must parse here (sigh)
        
        |method src skip tree found|

        skip := found := false.
        method := methodArg originalMethodIfWrapped.
        method isLazyMethod ifTrue:[
            src := method source.
            (src notNil) ifTrue:[
                method makeRealMethod.
            ] ifFalse:[
                skip := true
            ].    
        ].
        skip ifFalse:[
            src := method source.
            src isNil ifTrue:[
                ('SystemBrowser: [warning]: no source for method: ',methodArg printString) errorPrintCR.
            ].    
            (src notNil and:[src includes:$']) ifTrue:[ "/ eliminates many
                (checkSource value:src) ifTrue:[
                    tree := cls parseTreeFor:sel.
                    "/ walk
                    found :=
                        tree usedLiterals contains:[:lit |
                            lit isString
                            and:[ lit isSymbol not
                            and:[ checkLiteral value:lit ]]]
                ].        
            ].        
        ].
        found
      ]

    "
     SystemBrowser findStringLiteral:'error' in:(Array with:Object) ignoreCase:true match:true
     SystemBrowser findStringLiteral:'error' in:(Array with:Object) ignoreCase:true match:false
     SystemBrowser findStringLiteral:'error' in:(Array with:Object) ignoreCase:false match:true
     SystemBrowser findStringLiteral:'error' in:(Array with:Object) ignoreCase:false match:false
    "
!

searchBlockForSymbol:aSymbol 
    "return a matchblock to search for all methods referencing aSymbol.
     false if no such symbol exists"

    (aSymbol includesMatchCharacters) ifTrue:[
        "a matchString"
        ^ [:c :m :s |
                (m literalsDetect:[:aLiteral|
                        (aLiteral isMemberOf:Symbol) 
                        and:[aSymbol match:aLiteral]
                    ] 
                    ifNone:nil
                ) notNil
           ].
    ] ifFalse:[
        aSymbol asSymbolIfInterned isNil ifTrue:[
            ^ false
        ].
        ^ [:c :m :s |
                (m literalsDetect:[:aLiteral|
                    (aSymbol == aLiteral) 
                    ] 
                    ifNone:nil
                ) notNil
           ].
    ].

    "Created: / 22-03-2012 / 06:56:51 / cg"
! !

!SystemBrowser class methodsFor:'startup'!

browseAllSelect:aBlock
    "launch a browser for all methods where aBlock returns true.
     The block is called with 3 arguments, class, method and selector."

    ^ self 
        browseMethodsWhere:aBlock 
        title:'selected messages'

    "
     SystemBrowser browseAllSelect:[:aClass :aMethod :selector | selector numArgs == 3]
    "

    "Modified: 24.1.1997 / 19:45:05 / cg"
!

browseClass:aClass
    "launch a browser for aClass.
     Notice: better go via Smalltalk browseClass:, which honors the tool-preferences"

    ^ self 
        newWithLabel:aClass name
        setupSelector:#setupForClass:
        arg:aClass

    "
     SystemBrowser browseClass:Object
    "

    "Modified: 24.1.1997 / 19:45:16 / cg"
!

browseClass:aClass methodCategory:aCategory
    "launch a browser for all methods under aCategory in aClass"

    ^ self newWithLabel:(aClass name , ' ' , aCategory)
          setupBlock:[:browser | browser setupForClass:aClass methodCategory:aCategory]

    "
     SystemBrowser browseClass:String methodCategory:'copying'
    "

    "Modified: 24.1.1997 / 19:45:23 / cg"
!

browseClass:aClass selector:selector
    "launch a browser for the method at selector in aClass."

    ^ self 
        newWithLabel:(aClass name , ' ' , selector , ' ' , selector)
        setupBlock:[:newBrowser | newBrowser setupForClass:aClass selector:selector]

    "
     SystemBrowser browseClass:Object selector:#printString
     Tools::NewSystemBrowser openInClass:Object selector:#printString
    "
!

browseClassCategory:aClassCategory
    "launch a browser for all classes under aCategory"

    ^ self 
        newWithLabel:aClassCategory
        setupSelector:#setupForClassCategory:
        arg:aClassCategory

    "
     SystemBrowser browseClassCategory:'Kernel-Objects'
    "

    "Modified: 24.1.1997 / 19:45:32 / cg"
!

browseClassHierarchy:aClass
    "launch a browser for aClass and all its superclasses.
     this is different from the fullProtocol browser."

    ^ self 
        newWithLabel:(aClass name , '-' , 'hierarchy')
        setupSelector:#setupForClassHierarchy:
        arg:aClass

    "
     SystemBrowser browseClassHierarchy:Number
    "
!

browseClasses:aList label:title
    "launch a browser for all classes in aList"

    ^ self 
        newWithLabel:title
        setupBlock:[:b | b setupForClassList:aList sort:true]

    "
     SystemBrowser browseClasses:(Array with:Object
                                        with:Float)
                           title:'two classes'
    "

    "Modified: 28.5.1996 / 13:52:25 / cg"
!

browseClasses:aList label:title sort:doSort
    "launch a browser for all classes in aList"

    ^ self 
        newWithLabel:title
        setupBlock:[:b | b setupForClassList:aList sort:doSort]

    "
     SystemBrowser browseClasses:(Array with:Object
                                        with:Float)
                           title:'two classes'
    "

    "Created: 28.5.1996 / 13:52:09 / cg"
!

browseClasses:aList title:title
    <resource: #obsolete>
    "launch a browser for all classes in aList"

    self obsoleteMethodWarning.
    ^ self browseClasses:aList label:title
!

browseClasses:aList title:title sort:doSort
    <resource: #obsolete>
    "launch a browser for all classes in aList"

    self obsoleteMethodWarning.
    ^ self browseClasses:aList label:title sort:doSort

    "Created: 28.5.1996 / 13:52:09 / cg"
!

browseFullClassProtocol:aClass
    "launch a browser for aClasses full protocol.
     This is different from hierarchy browsing."

    ^ self 
        newWithLabel:(aClass name , '-' , 'full protocol')
        setupSelector:#setupForFullClassProtocol:
        arg:aClass

    "
     SystemBrowser browseFullClassProtocol:Number
    "
!

browseFullClasses
    "launch a browser showing all methods at once"

    ^ self 
        newWithLabel:'Full Class Browser'
        setupBlock:[:newBrowser | newBrowser setupForFullClass]

    "SystemBrowser browseFullClasses"
!

browseInstMethodsFrom:aClass where:aBlock title:title
    "launch a browser for all instance methods in aClass and all subclasses
     where aBlock evaluates to true"

    ^ self      
        browseMethodsIn:(aClass withAllSubclasses) 
        inst:true 
        class:false 
        where:aBlock 
        title:title

    "Modified: 24.1.1997 / 19:44:45 / cg"
!

browseInstMethodsIn:aCollectionOfClasses where:aBlock title:title
    "launch a browser for all instance methods of all classes in
     aCollectionOfClasses where aBlock evaluates to true"

    ^ self 
        browseMethodsIn:aCollectionOfClasses 
        inst:true class:false 
        where:aBlock title:title

    "Modified: 24.1.1997 / 19:43:41 / cg"
!

browseInstMethodsOf:aClass where:aBlock title:title
    "launch a browser for all instance methods in aClass
     where aBlock evaluates to true"

    ^ self 
        browseMethodsIn:(Array with:aClass) 
        inst:true 
        class:false 
        where:aBlock title:title

    "Modified: 24.1.1997 / 19:43:50 / cg"
!

browseMethod:aMethod
    "launch a single-method browser."

    ^ self browseMethods:{ aMethod }

    "
     self browseMethod:(Array compiledMethodAt:#at:)
     Tools::NewSystemBrowser browseMethod:(Array compiledMethodAt:#at:)
    "
!

browseMethodCategory:aCategory
    "launch a browser for all methods where category = aCategory"

    |searchBlock|

    aCategory includesMatchCharacters ifTrue:[
        searchBlock := [:c :m :s | aCategory match:m category].
    ] ifFalse:[
        searchBlock := [:c :m :s | m category = aCategory]
    ].

    ^ self browseMethodsWhere:searchBlock title:('all methods with category of ' , aCategory)

    "
     SystemBrowser browseMethodCategory:'printing & storing'
     SystemBrowser browseMethodCategory:'print*'
    "
!

browseMethods:aListOfMethods
    "launch a multi-method browser."

    |title|
    
    aListOfMethods size == 1 ifTrue:[
        title := aListOfMethods first whoString
    ] ifFalse:[
        title := 'some methods'
    ].    
    ^ self browseMethods:aListOfMethods title:title

    "
     self 
        browseMethods:(Array with:(Array compiledMethodAt:#at:))

     self 
        browseMethods:(Array with:(Array compiledMethodAt:#at:)
                             with:(OrderedCollection compiledMethodAt:#at:))

     self 
        browseMethods:(Array with:(Array compiledMethodAt:#at:)
                             with:(Array compiledMethodAt:#at:put:))
    "
!

browseMethods:aList title:aString
    "launch a browser for an explicit list of class/selectors.
     Each entry in the list can be either a method, or a string
     consisting of the classes name and the selector, separated by spaces. 
     For class methods, the string ' class' must be appended to the classname."

    ^ self
        browseMethods:aList
        title:aString
        sort:true


    "
     SystemBrowser 
        browseMethods:#('Object printOn:' 'Collection add:')
        title:'some methods'

     SystemBrowser 
        browseMethods:#('Behavior new:' 'Setclass new:')
        title:'some new: methods'

     SystemBrowser 
        browseMethods:(Array with:(Object compiledMethodAt:#printOn:)
                             with:(Collection compiledMethodAt:#add:)
                             with:(Object class compiledMethodAt:#initialize))
        title:'some methods'

    "

    "Modified: 1.11.1996 / 16:30:17 / cg"
!

browseMethods:aList title:aString sort:doSort
    "launch a browser for an explicit list of class/selectors.
     Each entry in the list can be either a method, or a string
     consisting of the classes name and the selector, separated by spaces. 
     For class methods, the string ' class' must be appended to the classname."

    |l|

    (aList size == 0) ifTrue:[
        self showNoneFound:aString.
        ^ nil
    ].
    l := aList asOrderedCollection.
    l := l collect:[:entry |
        |cls clsName|

        entry isString ifTrue:[
            entry
        ] ifFalse:[
            cls := entry mclass.
            cls isNil ifTrue:[
                '??? unbound'
            ] ifFalse:[
                cls isJavaClass ifTrue:[
                    clsName := 'JAVA::' , cls fullName 
                ] ifFalse:[
                    clsName := cls name
                ].
                (cls selectorAtMethod:entry) isNil ifTrue:[
                    clsName
                    , ' ' 
                    , '???' 
                ] ifFalse:[
                    clsName
                    , ' ' 
                    , (entry printStringForBrowserWithSelector:(cls selectorAtMethod:entry) inClass:cls)
                ]
            ]
        ]
      ].
        
    doSort ifTrue:[l sort].

    ^ self 
        newWithLabel:aString
        setupSelector:#setupForList:
        arg:l 

    "
     SystemBrowser 
        browseMethods:#('Object printOn:' 'Collection add:')
        title:'some methods'

     SystemBrowser 
        browseMethods:#('Behavior new:' 'Setclass new:')
        title:'some new: methods'

     SystemBrowser 
        browseMethods:(Array with:(Object compiledMethodAt:#printOn:)
                             with:(Collection compiledMethodAt:#add:)
                             with:(Object class compiledMethodAt:#initialize))
        title:'some methods'

    "

    "Modified: / 17-06-1996 / 17:07:46 / stefan"
    "Modified: / 05-03-2007 / 16:25:25 / cg"
!

browseMethodsFrom:aClass where:aBlock title:title
    "launch a browser for all instance- and classmethods in aClass
     and all its subclasses where aBlock evaluates to true.
     The block is called with 3 arguments, class, method and seelctor."

    ^ self 
        browseMethodsIn:(aClass withAllSubclasses) 
        where:aBlock 
        title:title

    "Modified: 24.1.1997 / 19:44:00 / cg"
!

browseMethodsIn:aCollectionOfClasses inst:wantInst class:wantClass where:aBlock title:title
    "launch a browser for all instance- (if wantInst is true) and/or
     classmethods (if wantClass is true) from classes in aCollectionOfClasses,
     where aBlock evaluates to true.
     The block is called with 3 arguments, class, method and selector."

    |list|

    "
     since this may take a long time, lower my priority ...
    "
    Processor activeProcess 
        withPriority:Processor activePriority-1 to:Processor activePriority
    do:[
        list := self findMethodsIn:aCollectionOfClasses inst:wantInst class:wantClass where:aBlock
    ].
    ^ self browseMethods:list title:title
!

browseMethodsIn:aCollectionOfClasses inst:wantInst class:wantClass where:aBlock title:title ifNone:warnBlock
    "launch a browser for all instance- (if wantInst is true) and/or
     classmethods (if wantClass is true) from classes in aCollectionOfClasses,
     where aBlock evaluates to true.
     The block is called with 3 arguments, class, method and selector."

    |list|

    "
     since this may take a long time, lower my priority ...
    "
    Processor activeProcess 
        withPriority:Processor activePriority-1 to:Processor activePriority
    do:[
        list := self findMethodsIn:aCollectionOfClasses inst:wantInst class:wantClass where:aBlock.
        list size == 0 ifTrue:[warnBlock value].
    ].
    ^ self browseMethods:list title:title
!

browseMethodsIn:aCollectionOfClasses where:aBlock title:title
    "launch a browser for all instance- and classmethods from 
     all classes in aCollectionOfClasses where aBlock evaluates to true.
     The block is called with 3 arguments, class, method and seelctor."

    ^ self 
        browseMethodsIn:aCollectionOfClasses 
        inst:true 
        class:true 
        where:aBlock 
        title:title

    "Modified: 24.1.1997 / 19:44:17 / cg"
!

browseMethodsIn:aCollectionOfClasses where:aBlock title:title ifNone:warnBlock
    "launch a browser for all instance- and classmethods from 
     all classes in aCollectionOfClasses where aBlock evaluates to true.
     The block is called with 3 arguments, class, method and seelctor."

    ^ self 
        browseMethodsIn:aCollectionOfClasses 
        inst:true 
        class:true 
        where:aBlock 
        title:title
        ifNone:warnBlock

    "Modified: 24.1.1997 / 19:44:17 / cg"
!

browseMethodsOf:aClass where:aBlock title:title
    "launch a browser for all instance- and classmethods in aClass 
     where aBlock evaluates to true.
     The block is called with 3 arguments, class, method and seelctor."

    ^ self browseMethodsIn:(Array with:aClass) where:aBlock title:title
!

browseMethodsWhere:aBlock title:title
    "launch a browser for all methods where aBlock returns true.
     The block is called with 3 arguments, class, method and seelctor."

    ^ self 
        browseMethodsIn:(Smalltalk allClasses) 
        where:aBlock 
        title:title

    "Modified: 24.1.1997 / 19:44:30 / cg"
!

browseMethodsWhere:aBlock title:title ifNone:warnBlock
    "launch a browser for all methods where aBlock returns true.
     The block is called with 3 arguments, class, method and seelctor."

    ^ self 
        browseMethodsIn:(Smalltalk allClasses) 
        where:aBlock 
        title:title
        ifNone:warnBlock

    "Modified: 24.1.1997 / 19:44:30 / cg"
!

findMethodsIn:aCollectionOfClasses inst:wantInst class:wantClass where:aBlock
    "return all instance- (if wantInst is true) and/or classmethods (if wantClass is true) 
     from classes in aCollectionOfClasses, where aBlock evaluates to true."

    |list checkedClasses checkBlock nClasses 
     nClassesDone oldPercentage newPercentage nClassesSinceLastPercentage bulkSize|

    checkedClasses := IdentitySet new.
    list := OrderedCollection new.

    checkBlock := [:cls |
        (checkedClasses includes:cls) ifFalse:[
            (cls isObsolete and:[cls isLoaded]) ifTrue:[
                Transcript showCR:'Browser method search: skipping obsolete class: ' , cls displayString
            ] ifFalse:[
                aBlock numArgs == 1 ifTrue:[
                    cls methodDictionary keysAndValuesDo:[:sel :method |
                        (aBlock value:method) ifTrue:[
                            list add:method "/ (cls name , ' ' , sel)
                        ]
                    ].
                ] ifFalse:[
                    cls methodDictionary keysAndValuesDo:[:sel :method |
                        (aBlock value:cls value:method value:sel) ifTrue:[
                            list add:method "/ (cls name , ' ' , sel)
                        ]
                    ].
                ].
                checkedClasses add:cls.
            ]
        ]
    ].

    nClasses := aCollectionOfClasses size.
    nClassesDone := 0.
    oldPercentage := 0.
    nClassesSinceLastPercentage := 0.
    bulkSize := (nClasses // 30) max:10. "/ roughly every 3%.
    
    aCollectionOfClasses do:[:aClass |
        (aClass notNil and:[aClass isObsolete not]) ifTrue:[
            nClassesSinceLastPercentage := nClassesSinceLastPercentage + 1.
            
            "
             output disabled - it slows down things too much (when searching for
             implementors or senders)
            "
            wantInst ifTrue:[
"/                Transcript show:'searching '; show:aClass name; showCR:' ...'; endEntry.
                checkBlock value:aClass
            ].
            wantClass ifTrue:[
"/                Transcript show:'searching '; show:aClass class name; showCR:' ...'; endEntry.
                checkBlock value:(aClass class)
            ].
            nClassesSinceLastPercentage > bulkSize ifTrue:[
                "/ Processor yield
                newPercentage := nClassesDone * 100 // nClasses.
                newPercentage ~= oldPercentage ifTrue:[
                    ProgressNotification progressPercentage:newPercentage.
                    oldPercentage := newPercentage.
                ].
                nClassesSinceLastPercentage := 0.
            ].
        ].
        nClassesDone := nClassesDone + 1.
    ].
    ^ list

    "Modified: / 15-05-2012 / 10:36:44 / cg"
!

findMethodsIn:aCollectionOfClasses where:aBlock
    "return all instance- and classmethods 
     from classes in aCollectionOfClasses, where aBlock evaluates to true."

    ^ self
        findMethodsIn:aCollectionOfClasses 
        inst:true
        class:true      
        where:aBlock
! !

!SystemBrowser class methodsFor:'startup with query'!

askThenBrowseClass
    self getClassThenPerform:#browseClass:

    "
     SystemBrowser askThenBrowseClass
     Tools::NewSystemBrowser askThenBrowseClass
    "
!

askThenBrowseClassHierarchy
    self getClassThenPerform:#browseClassHierarchy:

    "
     SystemBrowser askThenBrowseClassHierarchy
     Tools::NewSystemBrowser askThenBrowseClassHierarchy
    "
!

askThenBrowseFullClassProtocol
    self getClassThenPerform:#browseFullClassProtocol:

    "
     SystemBrowser askThenBrowseFullClassProtocol
     Tools::NewSystemBrowser askThenBrowseFullClassProtocol
    "
! !

!SystemBrowser class methodsFor:'utilities'!

askForClass
    ^ self askForClassWithFilter:nil

    "
     Tools::NewSystemBrowser askForClass   
    "
!

askForClassName
    ^ self askForClassNameWithFilter:nil

    "
     Tools::NewSystemBrowser askForClassName   
    "
!

askForClassNameWithFilter:filterOrNil
    self
        askForClassToSearch:nil
        single:true
        msgTail:''
        resources:(self classResources)
        filter:filterOrNil
        forBrowser:nil
        thenDo:[:className :single :doWhat |
            ^ className
        ].
    ^ nil

    "
     Tools::NewSystemBrowser askForClassName   
    "
!

askForClassToSearch:doWhatByDefault single:singleClass msgTail:msgTail resources:resourcesOrNil filter:filterOrNil forBrowser:aBrowserOrNil thenDo:aBlock
    "utility common code for both opening a new browser on a class and
     to search for a class in an existing browser.
     If singleClass is true, a single class will be asked for and browsed,
     otherwise, a match pattern is allowed and a multi-class browser is opened.
     Moved from instance protocol for better reusability."

    |box boxLabel title okText className canFind doWhat classNameHolder updateList
     allClasses classNamesInChangeSet
     allNames allFullNames initialShortNames initialFullNames
     colorizedFullNames colorizedShortNames
     resources check showingWhatLabel showFullNameHolder genShortNameListEntry|

    resources := resourcesOrNil ? self classResources.
    showFullNameHolder := (LastClassSearchBoxShowedFullName ? false) asValue.

    doWhat := doWhatByDefault.
    canFind := false.

    title := ''.
    boxLabel := (resources string:'Select a class').
    okText := 'OK'.

    genShortNameListEntry :=
        [:cls |
            |ns|

            cls isNil ifTrue:[
                nil
            ] ifFalse:[
                (filterOrNil notNil and:[ (filterOrNil value:cls) not]) ifTrue:[
                    nil
                ] ifFalse:[
                    ns := cls topNameSpace name.
                    ns = 'Smalltalk'
                        ifTrue:[ ns := '' ]
                        ifFalse:[ns := ' (in ',ns,')'].
                    cls nameWithoutNameSpacePrefix,ns
                ]
            ].
        ].

    classNamesInChangeSet := ChangeSet current changedClasses
                                select: (filterOrNil ? [:cls | true])
                                thenCollect:[:each | each theNonMetaclass name].

    initialFullNames := self visitedClassNamesHistory.
    (filterOrNil notNil) ifTrue:[
        initialFullNames := initialFullNames select:[:nm | filterOrNil value:(Smalltalk at:nm)].
    ].
    initialShortNames := initialFullNames collect:[:nm | genShortNameListEntry value:(Smalltalk at:nm)] thenSelect:[:nm | nm notNil].

    colorizedFullNames := initialFullNames collect:[:clsName | 
                                (classNamesInChangeSet includes:clsName) ifTrue:[
                                    clsName asText emphasisAllAdd:(UserPreferences current emphasisForChangedCode)
                                ] ifFalse:[
                                    clsName
                                ].
                            ].

    colorizedShortNames := initialShortNames with:initialFullNames collect:[:shortName :clsName | 
                                (classNamesInChangeSet includes:clsName) ifTrue:[
                                    shortName asText emphasisAllAdd:(UserPreferences current emphasisForChangedCode)
                                ] ifFalse:[
                                    shortName
                                ].
                            ].

    title := (resources string:title) , msgTail , '.\' , (resources string:'(TAB to complete; matchPattern allowed - "*" for all):').

    box := self
                enterBoxForClassWithCodeSelectionTitle:title withCRs
                withList:(showFullNameHolder value ifTrue:[colorizedFullNames] ifFalse:[colorizedShortNames])
                okText:okText
                forBrowser:nil.

    box label:boxLabel.

    allClasses := Smalltalk allClasses copyAsOrderedCollection.
    filterOrNil notNil ifTrue:[
        allClasses := allClasses select: filterOrNil
    ].

    allNames := (allClasses
                    collect:[:cls |
                        |ns nm|

                        ns := cls topNameSpace name.
                        ns = 'Smalltalk'
                            ifTrue:[ ns := '' ]
                            ifFalse:[ns := ' (in ',ns,')'].
                        cls isNameSpace ifTrue:[
                            nm := cls nameWithoutNameSpacePrefix,ns,' (Namespace)'
                        ] ifFalse:[
                            nm := cls nameWithoutNameSpacePrefix,ns
                        ].
                        (classNamesInChangeSet includes:cls name) ifTrue:[
                            nm asText emphasisAllAdd:(UserPreferences current emphasisForChangedCode)
                        ] ifFalse:[
                            nm
                        ].
                    ]) sortWith:allClasses; yourself.

    allFullNames := (allClasses 
                    collect:[:cls | 
                        |nm|

                        nm := cls name.
                        (classNamesInChangeSet includes:cls name) ifTrue:[
                            nm asText emphasisAllAdd:(UserPreferences current emphasisForChangedCode)
                        ] ifFalse:[
                            nm
                        ].
                    ]) sortWith:allClasses; yourself.

    updateList := [
            |nameToSearch list namesStarting namesIncluding lcName nameList|

            (nameToSearch := classNameHolder value withoutSeparators) isEmpty ifTrue:[
                showingWhatLabel label:(resources string:'Recently visited:').
                list := (showFullNameHolder value ifTrue:[colorizedFullNames] ifFalse:[colorizedShortNames]).
            ] ifFalse:[
                showingWhatLabel label:(resources string:'Matching classes:').
                nameList := showFullNameHolder value
                                ifTrue:[ allFullNames ]
                                ifFalse:[ allNames ].

                lcName := nameToSearch asLowercase.
                (lcName includesString:'::') ifTrue:[
                    list := OrderedCollection new.
                    allClasses doWithIndex:[:cls :idx |
                        |isIncluded|

                        (nameToSearch includesMatchCharacters) ifTrue:[
                            isIncluded := (lcName match:cls name asLowercase)
                        ] ifFalse:[
                            isIncluded := (cls name includesString:lcName caseSensitive:false)
                        ].
                        isIncluded ifTrue:[
                            list add:(nameList at:idx)
                        ].
                    ].
                ] ifFalse:[
                    (nameToSearch includesMatchCharacters) ifTrue:[
                        list := nameList select:[:nm | lcName match:nm asLowercase]
                    ] ifFalse:[
                        namesIncluding := nameList
                                            select:[:nm |
                                                "/ nm asLowercase startsWith:lcName
                                                nm asLowercase includesString:lcName caseSensitive:false
                                            ].
                        namesStarting := namesIncluding select:[:nm | nm asLowercase startsWith:lcName].
                        list := namesStarting , {nil} , (namesIncluding \ namesStarting).
                    ]
                ]
            ].
            box listView
                list:list;
                scrollToLine:((list findFirst:[:line | (line ? '') startsWith:lcName]) max:1)
        ].

    classNameHolder := '' asValue.
    box enterField
        model:classNameHolder;
        immediateAccept:true.
    classNameHolder onChangeEvaluate:updateList.

    box entryCompletionBlock:(DoWhatIMeanSupport classNameEntryCompletionBlock).
    box action:[:aString | className := aString].

    box panelView
        addSubView:(showingWhatLabel := (Label label:(resources string:'Recently visited:')) adjust:#left) before:nil;
        addSubView:(check := CheckBox label:(resources string:'Show Full Name (do not strip off Namespace)') model:showFullNameHolder) before:nil.
    showFullNameHolder onChangeEvaluate:updateList.
    box enterField origin:(0 @ check corner y).
    box listView origin:(0 @ check corner y).

    box extent:(400 @ 350).
    box open.

    className isEmptyOrNil ifTrue:[^ nil "cancel"].

    LastClassSearchBoxShowedFullName := showFullNameHolder value.

    (className endsWith:$) ) ifTrue:[
        (className indexOfSubCollection:'(in ') == 0 ifTrue:[
            "/ a namespace
            className := (className copyTo:(className indexOfSubCollection:'(Name')-1) withoutSeparators
        ] ifFalse:[
            className := ((className copyFrom:(className indexOfSubCollection:'(in ')+4)
                            copyButLast:1)
                         , '::' , className asCollectionOfWords first
        ].
    ].

    aBlock notNil ifTrue:[aBlock value:className optionalArgument:singleClass and:doWhat].
    ^ className

    "Modified: / 23-07-2012 / 11:00:22 / cg"
!

askForClassWithFilter:filterOrNil
    |className|

    className := self askForClassNameWithFilter:filterOrNil.
    className notEmptyOrNil ifTrue:[
        ^ Smalltalk classNamed:className
    ].
    ^ nil

    "
     Tools::NewSystemBrowser askForClass   
    "
!

classWithNameSimilarTo:className
    "helper for class-name entry; finds a class by name tolerant w.r.t. case"

    |allMatchingClasses|

    allMatchingClasses := self classesWithNameSimilarTo:className.
    ^ allMatchingClasses firstIfEmpty:nil
!

classesWithNameSimilarTo:className
    "helper for class-name entry; finds a class by name tolerant w.r.t. case"

    ^ self classesWithNameSimilarTo:className from:nil

    "Modified: / 22-08-2006 / 13:22:41 / cg"
!

classesWithNameSimilarTo:className from:aNameSpaceOrNil
    "helper for class-name entry; finds classes with a name similar to the argument, className"

    |nm lcName class allClasses triedDetectors triedMatchers allMatchingClasses
     prefNameSpaceOrNil prefLcNameSpace|

    prefNameSpaceOrNil := (aNameSpaceOrNil == Smalltalk) ifTrue:[ nil ] ifFalse:[aNameSpaceOrNil].

    nm := className withoutPrefix:'Smalltalk::'.

    prefNameSpaceOrNil notNil ifTrue:[
        class := prefNameSpaceOrNil at:nm asSymbol.
        class isBehavior ifTrue:[^ Array with:class].      "/ a direct hit
        prefLcNameSpace := prefNameSpaceOrNil name asLowercase.
    ].
    class := Smalltalk at:nm asSymbol.
    class isBehavior ifTrue:[^ Array with:class].      "/ a direct hit

    lcName := className asLowercase.

    allClasses := Smalltalk allClasses.

    triedDetectors := OrderedCollection new.
    triedDetectors add:[:cls | cls name asLowercase = lcName].

    triedDetectors do:[:eachTry |
        |class|

        class := allClasses detect:eachTry ifNone:nil.
        class notNil ifTrue:[^ Array with:class].
    ].

    triedMatchers := OrderedCollection new.
    triedMatchers add:[:cls | cls nameWithoutPrefix asLowercase = lcName].      
    triedMatchers add:[:cls | cls nameWithoutNameSpacePrefix asLowercase = lcName].      

    triedMatchers add:[:cls | cls name asLowercase startsWith:lcName].      
    triedMatchers add:[:cls | cls nameWithoutNameSpacePrefix asLowercase startsWith:lcName].      
    triedMatchers add:[:cls | cls nameWithoutPrefix asLowercase startsWith:lcName].      
    triedMatchers add:[:cls | cls nameWithoutPrefix asLowercase includesString:lcName].      
    triedMatchers add:[:cls | cls name asLowercase includesString:lcName].

    allMatchingClasses := IdentitySet new.
    triedMatchers do:[:eachTry |
        |matchingClasses|

        matchingClasses := allClasses select:eachTry.
"/        matchingClasses size == 1 ifTrue:[^ matchingClasses].
        allMatchingClasses addAll:matchingClasses.
    ].
    allMatchingClasses isEmpty ifTrue:[^ #()].

    allMatchingClasses := allMatchingClasses asOrderedCollection.
    allMatchingClasses 
        sort:[:a :b | 
            |lcNameA lcNameB da db distA distB |

            lcNameA := a name asLowercase.
            lcNameB := b name asLowercase.
            prefNameSpaceOrNil notNil ifTrue:[
                a nameSpace == prefNameSpaceOrNil ifTrue:[
                    lcNameA := a nameWithoutNameSpacePrefix asLowercase.
                ].
                b nameSpace == prefNameSpaceOrNil ifTrue:[
                    lcNameB := b nameWithoutNameSpacePrefix asLowercase.
                ].
            ].

            distA := da := lcName levenshteinTo:lcNameA.
            distB := db := lcName levenshteinTo:lcNameB.
            "prefer prefixes (i.e. classes whose name starts with what we search for)"

            (lcNameA startsWith:lcName) ifTrue:[
                distB := distB * 2
            ].
            (lcNameB startsWith:lcName) ifTrue:[
                distA := distA * 2
            ].
            distA < distB
        ].
    ^ allMatchingClasses.

    "
     self classesWithNameSimilarTo:'NewSystemBrowser'
     self classesWithNameSimilarTo:'Moose::MSEAbstractOperator'
    "

    "Created: / 22-08-2006 / 13:22:48 / cg"
    "Modified: / 22-08-2006 / 14:53:38 / cg"
!

enterBoxForClassWithCodeSelectionTitle:title withList:listOrNil okText:okText forBrowser:aBrowserOrNil
    "convenient method: setup an enterBox with initial text taken
     from the codeviews selection."

    |sel box initialText superclass currentClass
     methods someMethod offeredClass anyClose closeName s usedGlobals list|

    list := listOrNil.

    aBrowserOrNil notNil ifTrue:[    
        currentClass := aBrowserOrNil theSingleSelectedClass.

        sel := aBrowserOrNil selectionInCodeView.
        sel notNil ifTrue:[
            aBrowserOrNil selectedNamespacesValue doWithExit:[:eachNs :exit |
                s := eachNs , '::' , sel asSymbol.
                (s knownAsSymbol
                and:[(Smalltalk at:s asSymbol) isBehavior]) ifTrue:[
                    "/ a private class of current ...
                    sel := eachNs , '::' , sel asSymbol.
                    exit value:nil.
                ].
            ].
            (sel knownAsSymbol and:[currentClass notNil
            and:[(currentClass theNonMetaclass privateClassesAt:sel asSymbol) notNil]]) ifTrue:[
                "/ a private class of current ...
                sel := (currentClass theNonMetaclass privateClassesAt:sel asSymbol) name
            ] ifFalse:[
                (sel knownAsSymbol and:[(Smalltalk at:sel asSymbol) isBehavior]) ifFalse:[
                    "/ ignore it, if there is no class-name which comes close.
                    anyClose := false.
                    Smalltalk keysAndValuesDo:[:aGlobalName :aGlobal|
                        aGlobal isBehavior ifTrue:[
                            aGlobal isMeta ifFalse:[
                                aGlobal name == aGlobalName ifTrue:[
                                    ((aGlobalName startsWith:sel)
                                    or:[(sel startsWith:aGlobalName)]) ifTrue:[
                                        closeName isNil ifTrue:[closeName := aGlobalName].
                                        anyClose := true.
                                    ]
                                ]
                            ]
                        ]
                    ].
                    anyClose ifFalse:[
                        sel := nil
                    ] ifTrue:[
                        sel := closeName
                    ]
                ]
            ]
        ].

        sel notNil ifTrue:[
            initialText := sel asString withoutSeparators
        ] ifFalse:[
            aBrowserOrNil codeAspect == SyntaxHighlighter codeAspectMethod ifTrue:[
                methods := aBrowserOrNil selectedMethodsValue.
                methods size > 0 ifTrue:[
                    someMethod := methods first.
                    usedGlobals := someMethod usedGlobals collect:[:eachVar | eachVar asSymbol].
                    usedGlobals := usedGlobals select:[:eachVar | (Smalltalk at:eachVar) isBehavior].
                    usedGlobals size > 0 ifTrue:[
                        list := list reject:[:each | usedGlobals includes:each ].
                        list := usedGlobals asOrderedCollection sort , list.
                        offeredClass := Smalltalk at:usedGlobals first
                    ] ifFalse:[
                        offeredClass := someMethod mclass
                    ]
                ]
            ] ifFalse:[
                (aBrowserOrNil navigationState isVersionDiffBrowser
                or:[aBrowserOrNil navigationState isClassDocumentationBrowser]) ifTrue:[
                    offeredClass := currentClass.
                    (offeredClass notNil and:[offeredClass isPrivate]) ifTrue:[
                        offeredClass := offeredClass owningClass
                    ]
                ] ifFalse:[
                    (currentClass notNil
                    and:[(superclass := currentClass superclass) notNil]) ifTrue:[
                        offeredClass := superclass
                    ]
                ]
            ].
            offeredClass notNil ifTrue:[
                initialText := offeredClass theNonMetaclass name
            ]
        ].
    ].

    box := self
                enterBoxTitle:(self classResources string:title)
                withList:list
                okText:(self classResources string:okText).

    initialText notNil ifTrue:[
        box initialText:initialText
    ].
    ^ box

    "Created: / 13-02-2000 / 20:56:18 / cg"
    "Modified: / 27-07-2012 / 22:18:34 / cg"
!

enterBoxTitle:title withList:aListOrNil okText:okText
    "convenient method: setup enterBox"

    |box rsrcs|

    aListOrNil notNil ifTrue:[
        box := ListSelectionBox new.
        "/ box := EnterBoxWithList new.
        box list:aListOrNil.
    ] ifFalse:[
        box := EnterBox new.
    ].
    rsrcs := self classResources.
    box title:(rsrcs string:title) okText:(rsrcs string:okText).
    ^ box

    "
     self enterBoxTitle:'bla' withList:#('a' 'b' 'c') okText:'gaga'
    "

    "Created: / 13.2.2000 / 20:53:53 / cg"
    "Modified: / 1.3.2000 / 11:15:09 / cg"
!

extractClassAndSelectorFrom:aString into:aBlock
    "given a string which can be either 'class>>sel' or
     'class sel', extract className and selector, and call aBlock with
     the result.
     Useful to open browser on a method as selected in some documentation."

    |sel clsName isMeta sep s|

    sel := aString.
    sel notNil ifTrue:[
        sel := sel asString withoutSeparators.
        ('*>>*' match:sel) ifTrue:[
            sep := $>
        ] ifFalse:[
            ('*»*' match:sel) ifTrue:[
                sep := $»
            ] ifFalse:[
                ('* *' match:sel) ifTrue:[
                    sep := Character space
                ]
            ].
        ].
        sep notNil ifTrue:[
            "
             extract class/sel from selection
            "
            s := ReadStream on:sel.
            clsName := (s upTo:sep) withoutSeparators.
            [s peek == sep] whileTrue:[s next].
            sel := (s upToEnd) withoutSeparators.

            (clsName endsWith:' class') ifTrue:[
                isMeta := true.
                clsName := clsName copyButLast:6 "copyTo:(clsName size - 5)"
            ] ifFalse:[
                isMeta := false
            ].
        ]
    ].
    aBlock value:clsName value:sel value:isMeta

    "Modified: / 17.6.1996 / 16:52:14 / stefan"
    "Created: / 6.2.2000 / 00:51:51 / cg"
    "Modified: / 6.2.2000 / 00:56:43 / cg"
!

extractSelectorFrom:aString
    "given an arbitrary string, try to extract a useful selector.
     Useful to open browser on a selected code fragment."

    |s sel sel2 t idx|

    aString isEmptyOrNil ifTrue:[^ nil].

    (idx := aString indexOf:$») ~~ 0 ifTrue:[
        s := (aString copyFrom:idx+1) withoutSeparators.
        s isEmpty ifTrue:[^ nil]. 
    ] ifFalse:[    
        s := aString asString string withoutSeparators.
    ].
    sel := s asSymbolIfInterned.
    sel isNil ifTrue:[
        sel := s.
    ] ifFalse:[
        (sel endsWith:$:) ifTrue:[
            ^ sel.     
        ].
    ].

    t := Parser selectorInExpression:sel.
    t notNil ifTrue:[
        sel := t
    ].
    (sel = s or:[sel isNil or:[t == #'>>']]) ifTrue:[
        "oops - that's probably not what we want here ..."
        self extractClassAndSelectorFrom:s into:[:c :s :m |
            sel := s
        ]
    ].
    s := sel asSymbolIfInterned.
    s notNil ifTrue:[
        ^ s.
    ].

    (sel startsWith:$#) ifTrue:[
        sel2 := sel copyFrom:2.
        ((sel2 startsWith:$') and:[(sel2 endsWith:$')]) ifTrue:[
            sel2 := (sel2 copyFrom:2) copyButLast:1
        ].
        (sel2 := sel2 asSymbolIfInterned) notNil ifTrue:[
            ^ sel2.
        ].
    ].

    ^ sel

    "
     self extractSelectorFrom:'at:put:'      
     self extractSelectorFrom:'#at:put:'                       
     self extractSelectorFrom:'#''at:put:'''                       
     self extractSelectorFrom:'at:something put:someValue'     
     self extractSelectorFrom:'self at:something put:someValue'
     self extractSelectorFrom:'(self at:something put:someValue)' 
     self extractSelectorFrom:'[self at:something put:someValue] value' 
     self extractSelectorFrom:'Array » at:put:' 
     self extractSelectorFrom:'Array>>at:put:' 
     self extractSelectorFrom:'Array>>#at:put:' 
     self extractSelectorFrom:'Array>>#''at:put:''' 
    "

    "Created: / 6.2.2000 / 00:49:44 / cg"
    "Modified: / 6.2.2000 / 00:57:08 / cg"
!

getClassThenPerform:aSelector
    |classNameEntered classEntered enterBox resources|

    "/ new Code:
    classNameEntered := self askForClassName.

    "/ old Code:
"/    resources := self classResources.
"/
"/    enterBox := EnterBox title:(self classResources stringWithCRs:'Browse which class:').
"/    enterBox okText:(resources string:'Browse').
"/    enterBox entryCompletionBlock:(DoWhatIMeanSupport classNameEntryCompletionBlock).
"/    enterBox action:[:className | classNameEntered := className].
"/    enterBox showAtPointer.
"/
    classNameEntered notEmptyOrNil ifTrue:[   
        classEntered := Smalltalk classNamed:classNameEntered.
        classEntered isNil ifTrue:[
            self warn:(resources string:'No such class').
        ] ifFalse:[
            self perform:aSelector with:classEntered  
        ]
    ].

    "
     SystemBrowser getClassThenPerform:#browseClass:
    "

    "Modified: / 10-08-2006 / 12:54:20 / cg"
!

resourceEditorClassFor:aResource 
    "resources are from a methods resource-info;
     return an appropriate editor class."

    (aResource == #canvas) ifTrue:[
        ^ UIPainter
    ].
    (aResource == #menu) ifTrue:[
        ^ MenuEditor
    ].
    ((aResource == #image) or:[aResource == #fileImage]) ifTrue:[
        ^ ImageEditor
    ].
    (aResource == #help) ifTrue:[
        ^ UIHelpTool
    ].
    (aResource == #tableColumns) ifTrue:[
        ^ DataSetBuilder
    ].
    (aResource == #tabList) ifTrue:[
        ^ TabListEditor
    ].
    (aResource == #hierarchicalList) ifTrue:[
        ^ HierarchicalListEditor
    ].
    ^ nil
!

resourceEditorClassForResources:resources
    "resources are from a methods resource-info;
     return an appropriate editor class."

    resources keysDo:[:eachResource |
        |editor|

        editor := self resourceEditorClassFor:eachResource.
        editor notNil ifTrue:[ ^ editor].
    ].
    ^ nil
! !

!SystemBrowser::BrowserHistoryEntry methodsFor:'accessing'!

className
    "return the value of the instance variable 'className' (automatically generated)"

    ^ className ? '*anonymous*'
!

className:something
    "set the value of the instance variable 'className' (automatically generated)"

    className := something.
!

className:classNameArg meta:metaArg selector:selectorArg
    className := classNameArg.
    meta := metaArg.
    selector := selectorArg.
!

icon

    ^nil

    "Created: / 05-05-2011 / 23:57:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    ^self displayString

    "Created: / 05-05-2011 / 23:57:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

meta
    "return the value of the instance variable 'meta' (automatically generated)"

    ^ meta
!

meta:something
    "set the value of the instance variable 'meta' (automatically generated)"

    meta := something.
!

selector
    "return the value of the instance variable 'selector' (automatically generated)"

    ^ selector
!

selector:something
    "set the value of the instance variable 'selector' (automatically generated)"

    selector := something.
!

theClass
    ^ Smalltalk at:className asSymbol
! !

!SystemBrowser::BrowserHistoryEntry methodsFor:'comparing'!

= anEntry
    ^ className = anEntry className
      and:[meta = anEntry meta
      and:[selector = anEntry selector]]
! !

!SystemBrowser::BrowserHistoryEntry methodsFor:'displaying'!

displayOn:aGCOrStream
    | cls name |

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    cls := self theClass.
    name := cls notNil ifTrue:[cls nameInBrowser] ifFalse:[className].
    name printOn:aGCOrStream.
    meta ifTrue:[
        "/ aGCOrStream emphasis:#bold.
        aGCOrStream nextPutAll:' class'.
        "/ aGCOrStream emphasis:nil.
    ].
    selector notNil ifTrue:[ 
        aGCOrStream
            nextPutAll:' » ';
            emphasis:#bold;
            nextPutAll:selector;
            emphasis:nil.
    ].

    "Created: / 15-04-2010 / 13:47:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2011 / 13:44:32 / cg"
    "Modified: / 14-10-2013 / 12:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SystemBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


SystemBrowser initialize!
