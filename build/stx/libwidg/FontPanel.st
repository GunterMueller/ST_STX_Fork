"
 COPYRIGHT (c) 1991 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

DialogBox subclass:#FontPanel
	instanceVariableNames:'previewField listOfEncodings allFonts fontsPerFamily familyList
		faceList sizeList revertButton currentFamily currentFace
		currentStyle currentFaceAndStyle currentSize sizeUnit
		currentEncoding initialFont selectedFont nameLabel encodingFilter
		encodingFilterField encodingLabel combinedFilter encoding
		sizeLabelHolder pixelPointSwitch xftFontsOnlyHolder
		changeFontInAllViewsHolder withChangeFontInAllViewsCheckBox
		withChangeFontInAllViewsCheckBoxVisibleHolder
		decorativeOnlyHolder nonDecorativeOnlyHolder monospacedOnlyHolder
		nonMonospacedOnlyHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!FontPanel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    this class implements the font chooser.

    Notice: 
        this is a very old dialog; 
        it was written before the UI-framework was available and the UI is completely
        programmed manually (see initialize method).
        Therefore, it desperately asks to be rewritten using the UIPainter...

    [author:]
        Claus Gittinger

    [see also:]
        Font FontDescription
        View Dialog
"
!

examples
"
    very simple:
                                                                        [exBegin]
        |font|
        
        font := FontPanel fontFromUser.
        Transcript showCR:font
                                                                        [exEnd]


    with initial font:
                                                                        [exBegin]
        |font|

        font := FontPanel 
                    fontFromUserInitial:(Font 
                                            family:'courier'
                                            size:12).
        Transcript showCR:font
                                                                        [exEnd]


    with initial font & title:
                                                                        [exBegin]
        |font|

        font := FontPanel 
                    fontFromUserInitial:(Font 
                                            family:'courier'
                                            size:12)
                                  title:'select a fooBar font'.
        Transcript showCR:font
                                                                        [exEnd]


    full setup; setting a filter to only present iso fonts
    and callBack action:
                                                                        [exBegin]

        |panel|

        panel := FontPanel new.
        panel label:'hi there - which iso font ?'.
        panel filter:[:fd | fd encoding notNil
                            and:[fd encoding startsWith:'iso']].
        panel action:[:family :face :style :size | 
                        Transcript showCR:'family:' , family.
                        Transcript showCR:'face:' , face.
                        Transcript showCR:'style:' , style.
                        Transcript showCR:'size:' , size printString.
                     ].
        panel open
                                                                        [exEnd]
"
! !

!FontPanel class methodsFor:'defaults'!

defaultAsciiSampleString
    ^ (self sampleStringWithAllLetters) , '

ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz
1234567890    !!@#$%^&*(){}[]:"~;,./<>?
'
!

defaultExtent
    "return the default extent of my instances.
     The value returned here is usually ignored, and
     the value from preferredExtent taken instead."

    ^ (Screen current pixelPerMillimeter * (200 @ 150)) rounded

    "Modified: 22.4.1996 / 23:36:19 / cg"
!

defaultJIS0201SampleString
    "return the sample jis preview text"

    ^ (self defaultLatin1SampleString).
!

defaultJISSampleString
    "return the sample jis preview text"

    ^ 
'The quick brown fox
jumps over the lazy dog.

' , #(16r65E5 16r672C 16r8A9E) asUnicodeString
!

defaultLatin1SampleString
    "return the sample latin1 preview text"

    ^ (self defaultAsciiSampleString) , ''
!

defaultSampleStringForEncoding:enc
    |string lines|

    enc notNil ifTrue:[    
        ((enc startsWith:'unicode') or:[enc startsWith:'iso10646-']) ifTrue:[
            ^ self defaultUnicodeSampleString.
        ].
        (enc startsWith:'ms-ansi') ifTrue:[
            ^ self defaultUnicodeSampleString.
        ].

        (enc startsWith:'jis') ifTrue:[
            (enc includesString:'0201') ifTrue:[
                string := self defaultJIS0201SampleString    
            ] ifFalse:[
                string := self defaultJISSampleString
            ]
        ] ifFalse:[
        ]
    ].
    string isNil ifTrue:[
        string := self defaultLatin1SampleString.
    ].
    lines := string asStringCollection.
    [
        lines := lines encodeFrom:#unicode into:enc
    ] on:CharacterEncoderError do:[:ex|
        "substitute a default value for codes that cannot be represented
         in the new character set"
        ex proceedWith:ex defaultValue.
    ].

    ^ lines.
!

defaultUnicodeSampleString
    "return the sample unicode preview text"

    |t|

    t := (self defaultAsciiSampleString) , '
diaresis: 
accent: 
special: ' ,  #(16r20AC) asUnicodeString , '
math: ' ,  #(16r2200 16r2203 16r221E 16r2208 16r2209) asUnicodeString , '
cyrillic: ' ,  #(16r440 16r443 16r441 16r441 16r43A 16r438 16r439 16r20 16r44F 16r437 16r44B 16r43A) asUnicodeString , '
greek: ' , #(16r395 16r3BB 16r3BB 16r3B7 16r3BD 16r3B9 16r3BA 16r3AC) asUnicodeString , '
japanese: ' , #(16r65E5 16r672C 16r8A9E) asUnicodeString , '
chinese: ' ,
#(16r4F60 16r597D 16r3002) asUnicodeString , ' ' ,
#(16r6211 16r4E0D 16r8BF4 16r4E2D 16r6587) asUnicodeString , '
korean: ' , #( 50504 45397 54616 49464 50836 ) asUnicodeString , '
' ", 'hebrew: ' , #( 16r5E9 16r5dc 16r5d5 16r5dd 16r20 16r5e2 16r5d5 16r5dc 16r5dd ) asUnicodeString , ' (sorry: right-to-left writing is not supported)
' ", ''.
    ^ t

    "Modified: / 10-08-2010 / 16:05:16 / cg"
!

sampleStringWithAllLetters
    ^ (self classResources 
        at:'CHARSET_TEST_SENTENCE' 
        ifAbsent:'The quick brown fox jumps over the lazy dog') withCRs
! !

!FontPanel class methodsFor:'help'!

flyByHelpSpec
    <resource: #help>

    ^ Dictionary new 
        addPairsFrom:#(

#fontName
'Shows the full name of the selected font.' 

#fontEncodingFilter
'Filter fonts by encodings.\Almost any can be used for Latin1 languages (English, German, French, Italian etc.).\For other European languages, it should be a Latin-X or Unicode font;\For most middle and far east languages, a Unicode font is required.\\Notice that although ISO10646 is Unicode, many fonts only contain a subset of the required characters.\Check the preview above.' 

#fontsEncoding
'Shows the selected font''s encoding.' 

#xftFontsOnlyHolder
'Filter to only show the nicer looking xft fonts and ignore the ugly X fonts (Linux/OSX only).\\Be aware that if X is used with remote windows via a slow communication line,\it may be preferrable to avoid xft fonts, as they require much more network bandwidth.'

#pixelPointSwitch
'Switch between point and pixels in the size list.\A point is defined as 1/72th of an inch, and a common unit in typesetting.\Not to confuse with pixels, which are dots on your screen.\It is usually not a good idea, to specify font sizes by pixels.' 

#flushCachedListOfFonts
'Flush the cached list of fonts, and rescan the system for available fonts.\This may take a long time in some systems,\and is only needed if you install new fonts while ST/X is running.'

#changeInAllTextViews
'If checked, your font choice is applied to all text views (in ST/X),\and will also be the default for new windows.\Otherwise, it will only affect the current textview.\\To make your choice persistent across sessions, go to the settings dialog and save the settings into your preferences file.'
)
! !

!FontPanel class methodsFor:'menu specs'!

previewMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:FontPanel andSelector:#previewMenu
     (Menu new fromLiteralArrayEncoding:(FontPanel previewMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Copy'
            itemValue: previewCopySelection
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Show Character Set'
            itemValue: previewShowCharacterSet
            translateLabel: true
            isVisible: characterSetViewClassAvailable
          )
         (MenuItem
            label: 'Show Character Set (Using xfd)'
            itemValue: previewShowCharacterSetUsingXFD
            translateLabel: true
            isVisible: osIsUNIXAndXfdIsAvailable
            enabled: xfdCanBeUsed
          )
         (MenuItem
            label: '-'
            isVisible: characterSetViewClassAvailableOrOSIsUNIX
          )
         (MenuItem
            label: 'Inspect Font'
            itemValue: previewInspectFont
            translateLabel: true
          )
         (MenuItem
            label: 'Copy Fontname'
            itemValue: copyFontName
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Modified: / 11-10-2006 / 21:51:02 / cg"
! !

!FontPanel class methodsFor:'startup'!

fontFromUser
    "open a fontPanel and return the selected font, 
     or nil if abort is pressed"

    ^ self new fontFromUser

    "
     FontPanel fontFromUser
    "

    "Modified: 27.2.1996 / 00:51:59 / cg"
!

fontFromUserInitial:aFont
    "open a fontPanel showing aFont initially,
     and return the selected font, or nil if abort is pressed"

    ^ self new fontFromUserInitial:aFont

    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12)
     FontPanel fontFromUserInitial:MenuPanel defaultFont
    "
!

fontFromUserInitial:aFont title:someTitle
    "open a fontPanel with title and return the selected font, 
     or nil if abort is pressed"

    ^ self new 
        fontFromUserInitial:aFont title:someTitle

    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'
    "

    "Created: 27.2.1996 / 00:59:46 / cg"
    "Modified: 29.4.1996 / 09:45:34 / cg"
!

fontFromUserInitial:initialFont title:someTitle filter:aFilterBlock
    "open a fontPanel with title and font-filter
     and return the selected font, or nil if abort is pressed"

    ^ self new 
        fontFromUserInitial:initialFont title:someTitle 
        filter:aFilterBlock

    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'
    "

    "Created: 27.2.1996 / 00:59:46 / cg"
    "Modified: 10.4.1997 / 09:53:03 / cg"
!

fontFromUserInitial:initialFont title:someTitle filter:aFilterBlock encoding:encoding
    "open a fontPanel with title and font-filter
     and return the selected font, or nil if abort is pressed"

    ^ self new 
        fontFromUserInitial:initialFont title:someTitle 
        filter:aFilterBlock encoding:encoding

    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'
    "
!

fontFromUserInitial:initialFont title:someTitle filter:aFilterBlock encoding:encoding enabled:enabled
    "open a fontPanel with title and font-filter
     and return the selected font, or nil if abort is pressed"

    ^ self new
        fontFromUserInitial:initialFont title:someTitle 
        filter:aFilterBlock encoding:encoding 
        enabled:enabled

    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'
    "

    "Created: 27.2.1996 / 00:59:46 / cg"
    "Modified: 10.4.1997 / 09:53:03 / cg"
!

fontFromUserInitial:initialFont title:someTitle filter:aFilterBlock encoding:encoding enabled:enabled onChangeAll:actionToChangeAll
    "open a fontPanel with title and font-filter
     and return the selected font, or nil if abort is pressed"

    ^ self new
        fontFromUserInitial:initialFont title:someTitle 
        filter:aFilterBlock encoding:encoding 
        enabled:enabled
        onChangeAll:actionToChangeAll

    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'
    "

    "Created: 27.2.1996 / 00:59:46 / cg"
    "Modified: 10.4.1997 / 09:53:03 / cg"
!

openOn:aFont
    "open a fontPanel showing aFont initially.
     This panel is for information only - no font selection is possible."

    ^ self 
        fontFromUserInitial:aFont 
        title:(aFont userFriendlyName)
        filter:nil
        encoding:nil
        enabled:false

    "
     FontPanel openOn:(Font family:'courier' size:12)
     FontPanel openOn:MenuPanel defaultFont
     FontPanel fontFromUser
    "
! !

!FontPanel methodsFor:'accessing'!

action:aFourArgBlock
    "set the action to be evaluated on ok.
     The block will be evaluated with family, face, style, size and encoding."

    okAction := aFourArgBlock

    "Modified: 10.4.1997 / 09:49:58 / cg"
!

changeFontInAllViews
    "valid after closing"
    
    ^ self changeFontInAllViewsHolder value    
!

changeFontInAllViewsHolder
    changeFontInAllViewsHolder isNil ifTrue:[
        changeFontInAllViewsHolder := false asValue
    ].
    ^ changeFontInAllViewsHolder
!

decorativeOnlyHolder
    decorativeOnlyHolder isNil ifTrue:[
        decorativeOnlyHolder := false asValue
    ].
    ^ decorativeOnlyHolder
!

encoding:aPattern
    "set the encoding goal"

    ((aPattern = #'iso8859-1')
    or:[ (aPattern = #'iso10646-1') ]) ifFalse:[
        encoding := aPattern
    ] ifTrue:[
        encoding := #'*'
    ].    

    encodingFilterField contents:encoding.

    self encodingFilterSelected:encoding.
    shown ifTrue:[
        self updateFamilyList
    ].

    "Created: 29.2.1996 / 04:05:31 / cg"
    "Modified: 29.4.1996 / 09:40:18 / cg"
!

encodingFilter:aOneArgBlockOrNil
    "set a filter"

    encodingFilter := aOneArgBlockOrNil.
    self filterChanged

    "Created: 27.2.1996 / 01:40:08 / cg"
    "Modified: 29.4.1996 / 09:40:49 / cg"
!

filter:aOneArgBlockOrNil
    <resource: #obsolete>
    "set a filter; if non-nil, only fonts for which the filterBlock
     returns true will be offered"

    self obsoleteMethodWarning:'use encodingFilter:'.
    self encodingFilter:aOneArgBlockOrNil.
!

filterChanged
    "construct a combined a filter"

    |filter1 filter2 filter3|
    
    encodingFilter isNil ifTrue:[
        xftFontsOnlyHolder value 
            ifTrue:[ filter1 := [:fd | fd isXftFont] ]
            ifFalse:[ filter1 := [:fd | true] ]                                     
    ] ifFalse:[
        xftFontsOnlyHolder value 
            ifTrue:[ filter1 := [:fd | fd isXftFont and:[encodingFilter value:fd]] ]
            ifFalse:[ filter1 := encodingFilter ]
    ].
    filter2 := filter1.
    
    self decorativeOnlyHolder value ifTrue:[
        self nonDecorativeOnlyHolder value:false withoutNotifying:self.
        filter2 := [:fd | fd isDecorativeFont and:[filter1 value:fd]]
    ] ifFalse:[
        self nonDecorativeOnlyHolder value ifTrue:[    
            filter2 := [:fd | fd isDecorativeFont not and:[filter1 value:fd]]
        ].    
    ].    
    filter3 := filter2.
    
    self monospacedOnlyHolder value ifTrue:[
        self nonMonospacedOnlyHolder value:false withoutNotifying:self.
        filter3 := [:fd | fd isFixedWidth and:[filter2 value:fd]]
    ] ifFalse:[
        self nonMonospacedOnlyHolder value ifTrue:[    
            filter3 := [:fd | fd isFixedWidth not and:[filter2 value:fd]]
        ].    
    ].    
    combinedFilter := filter3.
    self refreshFamilyList
!

initialFont:aFont
    "set the font to be selected initially"

    |fontEncoding|

    initialFont := selectedFont := aFont.
    currentFamily := aFont family.
    currentFace := aFont face.
    currentStyle := aFont style.
    currentFaceAndStyle := currentFace,'-',currentStyle.

"/    self xftFontsOnlyHolder value:(aFont isXftFont).
    fontEncoding := aFont encoding.    
    sizeUnit := aFont sizeUnit.
    sizeUnit = #px ifTrue:[
        currentSize := aFont pixelSize asString , 'px'.
    ] ifFalse:[
        currentSize := aFont size asString.
    ].

"/ self halt.
    self encoding:fontEncoding. 
    "/    encodingFilter contents:fontEncoding.
    "/    self encodingFilterSelected:fontEncoding.
    self showSelectedFont.

    "Modified: 23.2.1996 / 00:51:32 / cg"
!

monospacedOnlyHolder
    monospacedOnlyHolder isNil ifTrue:[
        monospacedOnlyHolder := false asValue
    ].
    ^ monospacedOnlyHolder
!

nonDecorativeOnlyHolder
    nonDecorativeOnlyHolder isNil ifTrue:[
        nonDecorativeOnlyHolder := false asValue
    ].
    ^ nonDecorativeOnlyHolder
!

nonMonospacedOnlyHolder
    nonMonospacedOnlyHolder isNil ifTrue:[
        nonMonospacedOnlyHolder := false asValue
    ].
    ^ nonMonospacedOnlyHolder
!

refreshFamilyList
    familyList list:nil.
    shown ifTrue:[
        self updateFamilyList
    ].
!

withChangeFontInAllViewsCheckBoxVisibleHolder
    withChangeFontInAllViewsCheckBoxVisibleHolder isNil ifTrue:[
        withChangeFontInAllViewsCheckBoxVisibleHolder := false asValue
    ].
    ^ withChangeFontInAllViewsCheckBoxVisibleHolder
!

withChangeFontInViewsAllCheckBox:aBoolean
    "to make that check box visible;
     call before opening"
     
    self withChangeFontInAllViewsCheckBoxVisibleHolder value:true
!

xftFontsOnlyHolder
    xftFontsOnlyHolder isNil ifTrue:[
        xftFontsOnlyHolder := true asValue
    ].
    ^ xftFontsOnlyHolder
! !

!FontPanel methodsFor:'initialization'!

createFontSelectionBrowserIn:aView
    |topSelectionBox fontLabelAndSizeSelectionBox
     l hLabel v1 v2 v3 familyLabel faceLabel sizeLabel fH mm|

    mm := ViewSpacing.
    hLabel := 30.
    
    l := (0@0 corner:1@1) asFractionalLayout.
    l bottomInset:hLabel.
    topSelectionBox := (View in:aView) layout:l.

    l := (0@1 corner:1@1) asFractionalLayout.
    l topOffset:hLabel negated.
    l rightInset:mm.
    
    fontLabelAndSizeSelectionBox := (HorizontalPanelView in:aView) layout:l. 
    fontLabelAndSizeSelectionBox horizontalLayout:#rightFit.
    
    v1 := View origin:0.0@0.0 corner:0.3@1.0 in:topSelectionBox.

    familyLabel := Label label:(resources string:'Family') in:v1.
    familyLabel borderWidth:0.
    familyLabel origin:(0.0 @ 0.0) extent:(1.0 @ nil).
    fH := familyLabel preferredHeight.

    familyList := ScrollableView for:SelectionInListView in:v1.
    familyList origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    familyList inset:mm.
    familyList topInset:fH.

    familyList := familyList scrolledView.
    self makeTabable:familyList.

    v2 := View origin:0.3@0.0 corner:0.8@1.0 in:topSelectionBox.

    faceLabel := Label label:(resources string:'Typeface') in:v2.
    faceLabel borderWidth:0.
    faceLabel origin:(0.0 @ 0.0) extent:(1.0 @ nil).

    faceList := ScrollableView for:SelectionInListView in:v2.
    faceList origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    faceList inset:mm.
    faceList topInset:fH.
    faceList := faceList scrolledView.
    self makeTabable:faceList.

    v3 := View origin:0.8@0.0 corner:1.0@1.0 in:topSelectionBox.

    sizeLabelHolder := (resources string:'Size') asValue.
    sizeLabel := Label in:v3.
    sizeLabel labelChannel:sizeLabelHolder.
    sizeLabel borderWidth:0.
    sizeLabel origin:(0.0 @ 0.0)extent:(1.0 @ nil).

    sizeList := ScrollableView for:SelectionInListView in:v3.
    sizeList origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    sizeList inset:mm.
    sizeList topInset:fH.
    sizeList := sizeList scrolledView.
    self makeTabable:sizeList.

    familyList action:[:lineNr | self familySelected:(familyList selectionValue)].
    faceList action:[:lineNr | self faceSelected:(faceList selectionValue)].
    sizeList action:[:lineNr | self sizeSelected:(sizeList selectionValue)].

    nameLabel := Label label:'' in:fontLabelAndSizeSelectionBox.
    nameLabel level:0; adjust:#left.
    nameLabel helpKey:#fontName.
    
    pixelPointSwitch := ComboListView in:fontLabelAndSizeSelectionBox.
    pixelPointSwitch level:-1.
    pixelPointSwitch contents:'pt'.
    pixelPointSwitch list:#(#pt #px).
    pixelPointSwitch action:[:sizeUnit | self sizeUnitSelected:sizeUnit].
    pixelPointSwitch helpKey:#pixelPointSwitch.
!

enabled:aBoolean
    familyList enabled:aBoolean.
    faceList enabled:aBoolean.
    sizeList enabled:aBoolean.
    encodingFilterField notNil ifTrue:[
        encodingFilterField enabled:aBoolean.
    ].
    aBoolean ifTrue:[
        self abortButton label:(resources string:'Cancel').
        self okButton beVisible.        
    ] ifFalse:[
        self abortButton label:(resources string:'Close').
        self okButton beInvisible.
    ].

    "
     FontPanel openOn:(Font family:'courier' size:12)
     FontPanel openOn:MenuPanel defaultFont
     FontPanel fontFromUser
    "
!

initialize
    "sigh: hand-crafted box creation; TODO: rewrite using UI painter"
    
    |everythingExceptOkCancelButtonsPanel fontBrowserView mm l encodingAndXFTOnlyBox box3 box4 xftCheckBox 
     previewAndFontSelectionPanel filterBox changeInAllCheckBox updateHeight
     xftFlushFontList decorativeCheckBox nonDecorativeCheckBox monospacedCheckBox nonMonospacedCheckBox|

    super initialize.

    label := resources string:'Font dialog'.
    sizeUnit := #pt.
    mm := ViewSpacing.

    self addAbortAndOkButtons.

    everythingExceptOkCancelButtonsPanel := View origin:0.0@0.0 corner:1.0@1.0 in:self.
    everythingExceptOkCancelButtonsPanel bottomInset:(buttonPanel preferredHeight + (mm)). 

    previewAndFontSelectionPanel := VariableVerticalPanel in:everythingExceptOkCancelButtonsPanel.
    previewAndFontSelectionPanel layout:(LayoutFrame
                    leftFraction:0 offset:0
                    rightFraction:1 offset:0
                    topFraction:0 offset:0
                    bottomFraction:1 offset:-160).
       
    filterBox  := VerticalPanelView in:everythingExceptOkCancelButtonsPanel.  
    filterBox layout:(LayoutFrame
                    leftFraction:0 offset:0
                    rightFraction:1 offset:0
                    topFraction:1 offset:-150
                    bottomFraction:1 offset:0).
    filterBox horizontalLayout:#fit verticalLayout:#top.

    previewField := HVScrollableView for:TextView in:previewAndFontSelectionPanel.
    previewField menuHolder:self previewMenu.
    previewField autoHideScrollBars:true.
    previewField := previewField scrolledView.
"/    previewField inset:mm.
"/    self is3D ifTrue:[
"/        previewField level:-1.
"/    ] ifFalse:[
"/        previewField borderWidth:1.
"/    ].

    fontBrowserView := View in:previewAndFontSelectionPanel.
    self createFontSelectionBrowserIn:fontBrowserView.

    encodingAndXFTOnlyBox := HorizontalPanelView in:filterBox.
    encodingAndXFTOnlyBox height:32.
    encodingAndXFTOnlyBox horizontalLayout:#leftSpace.

    l := Label label:(resources string:'Encoding:') in:encodingAndXFTOnlyBox.
    l borderWidth:0.
    l adjust:#left.
    l helpKey:#fontEncodingFilter.

    encodingFilterField := ComboBoxView in:encodingAndXFTOnlyBox.
    encodingFilterField level:-1.
    encodingFilterField contents:'*'.
    encodingFilterField list:(self listOfEncodingsInFilterCombo).
    encodingFilterField action:[:pattern | self encodingFilterSelected:pattern].
    encodingFilterField immediateAccept:true.
    encodingFilterField helpKey:#fontEncodingFilter.

    
        "/    encodingFilterField acceptOnReturn:true.
        "/    encodingFilterField acceptOnTab:true.
        "/    encodingFilterField acceptOnLeave:true.
        "/    encodingFilterField acceptOnLostFocus:true.
        "/    encodingFilterField acceptOnPointerLeave:true.

    encodingLabel := Label label:' ' in:encodingAndXFTOnlyBox.
    encodingLabel level:0; adjust:#left.
    encodingLabel adjust:#right.
    encodingLabel helpKey:#fontsEncoding.
    
    self showEncodingFilter ifFalse:[
        encodingFilterField beInvisible.
        encodingLabel beInvisible
    ].

    device supportsXftFonts ifTrue:[
        self xftFontsOnlyHolder value: (UserPreferences current useXftFontsOnly).
        xftCheckBox := CheckBox label:(resources string:'XFT Fonts Only') in:encodingAndXFTOnlyBox.
        xftCheckBox model:xftFontsOnlyHolder.
        xftCheckBox helpKey:#xftFontsOnlyHolder.
        xftFontsOnlyHolder onChangeEvaluate:[ self xftFontsOnlyChanged ].

        xftFlushFontList := Button label:(resources string:'Flush Cached List of Fonts') in:encodingAndXFTOnlyBox.
        xftFlushFontList action:[ self flushListOfAvailableFonts].
        xftFlushFontList helpKey:#flushCachedListOfFonts.

    ].

false ifTrue:[
    decorativeCheckBox := CheckBox label:(resources string:'Decorative Fonts Only').
    box3 := View new height:(decorativeCheckBox preferredHeight).
    filterBox add:box3.
    
    decorativeCheckBox origin:0.0@0.0 corner:0.5@1.0.
    box3 add:decorativeCheckBox.
    decorativeCheckBox model:self decorativeOnlyHolder.
    self decorativeOnlyHolder onChangeEvaluate:[ self filterChanged ].

    nonDecorativeCheckBox := CheckBox label:(resources string:'Non Decorative Fonts Only') in:box3.
    nonDecorativeCheckBox origin:0.5@0.0 corner:1.0@1.0.
    nonDecorativeCheckBox model:self nonDecorativeOnlyHolder.
    self nonDecorativeOnlyHolder onChangeEvaluate:[ self filterChanged ].

    monospacedCheckBox := CheckBox label:(resources string:'Monospaced Fonts Only').
    box4 := View new height:(monospacedCheckBox preferredHeight).
    filterBox add:box4.

    monospacedCheckBox origin:0.0@0.0 corner:0.5@1.0.
    box4 add:monospacedCheckBox.
    monospacedCheckBox model:self monospacedOnlyHolder.
    self monospacedOnlyHolder onChangeEvaluate:[ self filterChanged ].

    nonMonospacedCheckBox := CheckBox label:(resources string:'Non Monospaced Fonts Only') in:box4.
    nonMonospacedCheckBox origin:0.5@0.0 corner:1.0@1.0.
    nonMonospacedCheckBox model:self nonMonospacedOnlyHolder.
    self nonMonospacedOnlyHolder onChangeEvaluate:[ self filterChanged ].
].

    changeInAllCheckBox := CheckBox label:(resources string:'Change all Textviews and Default for New Views') in:filterBox.
    changeInAllCheckBox model:self changeFontInAllViewsHolder.
    changeInAllCheckBox visibilityChannel:self withChangeFontInAllViewsCheckBoxVisibleHolder.
    changeInAllCheckBox helpKey:#changeInAllTextViews.
    
    updateHeight :=
        [
            self sensor 
                pushUserEvent:#value 
                for:[
                    |filterBoxHeight|

                    filterBoxHeight := filterBox preferredHeight.
                    previewAndFontSelectionPanel layout bottomOffset:(filterBoxHeight negated - 10).
                    filterBox layout topOffset:(filterBoxHeight negated).

                    previewAndFontSelectionPanel layoutChanged.
                    filterBox layoutChanged.
                ]
        ].
        
"/    updateHeight value.
    self withChangeFontInAllViewsCheckBoxVisibleHolder 
            onChangeEvaluate:updateHeight.
    
    "
     FontPanel new showAtPointer
     FontPanel fontFromUser
    "

    "Modified: 31.5.1996 / 22:01:45 / cg"
!

listOfEncodingsInFilterCombo
    |availableEncodings listPresentedToUser|

    listOfEncodings := OrderedCollection new.
    device isWindowsPlatform ifTrue:[
        listOfEncodings
            addAll:
                #(
                    '*'
                    nil
                ).
    ] ifFalse:[
        listOfEncodings
            addAll:
                #(
                    '*'
                    #'iso8859-1'
                    #'iso10646-1'
                    'jis*'
                    nil
                ).
    ].

    availableEncodings := Set new.
    device listOfAvailableFonts do:[:f | availableEncodings add:(f encoding ? '?')].
    availableEncodings := availableEncodings asSortedCollection.
    listOfEncodings addAll:availableEncodings.

    listPresentedToUser := listOfEncodings collect:[:enc |
                            |encoder userFriendlyName|

"/
"/ disabled to avoid autoloading of encoders.
"/                            (enc notNil and:[enc ~= '*']) ifTrue:[
"/                                encoder := CharacterEncoder encoderFor:enc ifAbsent:nil.
"/                                encoder notNil ifTrue:[
"/                                    userFriendlyName := encoder userFriendlyNameOfEncoding.
"/                                ].
"/                            ].
                            (userFriendlyName notNil and:[(userFriendlyName sameAs: enc) not]) ifTrue:[
                                enc , ' (' , userFriendlyName , ')'
                            ] ifFalse:[
                                enc
                            ]
                          ].
    ^ listPresentedToUser.
!

postRealize
    "kludge for sco - xlsfont fails sometimes - try again here"

    self updateFamilyList.
    super postRealize

    "Modified: 27.2.1996 / 01:40:47 / cg"
    "Created: 24.7.1997 / 18:12:42 / cg"
!

previewMenu
    <resource: #programMenu >

    |menu|

    menu :=  Menu decodeFromLiteralArray:(self class previewMenu).
    menu findGuiResourcesIn:self.
    ^ menu

    "Modified: / 27-03-2007 / 11:15:53 / cg"
!

showEncodingFilter
    ^ true
! !

!FontPanel methodsFor:'private'!

clearPreview
    "clear the preview subview"

    shown ifTrue:[
        previewField contents:nil.
        encodingLabel notNil ifTrue:[ 
            encodingLabel label:''.
        ].
    ].

    "Created: 17.4.1996 / 15:19:16 / cg"
    "Modified: 11.8.1997 / 03:01:42 / cg"
!

extractFaceAndStyleFrom:aString
    "given a string, extract currentFace and currentStyle"

    |index|

    index := aString indexOf:$-.
    currentFaceAndStyle := aString.
    (index ~~ 0) ifTrue:[
        currentFace := aString copyTo:(index - 1).
        currentStyle := aString copyFrom:(index + 1)
    ] ifFalse:[
        currentFace := aString.
        currentStyle := nil.
    ].

    "Modified: 29.4.1996 / 09:41:47 / cg"
!

flyByHelpSpec
    ^ self class flyByHelpSpec
!

fontForPreview
    "get the preview font"

    |fontShown familyFonts fonts sz szUnitUsed|

    currentSize isNil ifTrue:[
        ^ nil.
    ].
    sz := Number readFrom:currentSize.
    szUnitUsed := sizeUnit.
    (currentSize endsWith:#px) ifTrue:[
        szUnitUsed := #px.
    ].

    familyFonts := fontsPerFamily at:currentFamily ifAbsent:nil.
    familyFonts isNil ifTrue:[
        familyFonts := fontsPerFamily at:currentFamily asUppercaseFirst ifAbsent:nil.
        familyFonts isNil ifTrue:[
            ^ nil
        ].
    ].
    fonts := familyFonts
                select:[:fntDescr |
                    fntDescr face = currentFace
                    and:[fntDescr style = currentStyle
                    and:[fntDescr isScaledFont
                            or:[sz = (szUnitUsed == #px  
                                        ifTrue:[fntDescr pixelSize] ifFalse:[fntDescr size])]]]
                ].

    fonts isEmpty ifTrue:[
        ^ nil
    ].

    fonts size > 1 ifTrue:[
        'FontPanel [info]: huh - multiple entries: ' infoPrint. fonts infoPrintCR.
        "/ self halt.
    ].
    fontShown := fonts first.
    fontShown isScaledFont ifTrue:[
        szUnitUsed == #px ifTrue:[
            fontShown := fontShown asPixelSize:sz
        ] ifFalse:[
            fontShown := fontShown asSize:sz
        ].
    ].
    ^ fontShown onDevice:device

"/    fontShown :=
"/        ((Screen current supportsXFTFonts and:[selectedFont isXftFont "self xftFontsOnlyHolder value" ])
"/            ifTrue:[XftFontDescription]
"/            ifFalse:[Font])
"/              family:currentFamily 
"/              face:currentFace 
"/              style:currentStyle
"/              size:currentSize      
"/              sizeUnit:sizeUnit
"/              encoding:encoding.
"/    
"/    fontShown notNil ifTrue:[^ fontShown].
"/
"/    allFonts := device 
"/                    fontsInFamily:(currentFamily ? '*')
"/                    face:(currentFace ? '*')
"/                    style:(currentStyle ? '*')
"/                    filtering:combinedFilter.
"/
"/    sizeUnit == #px ifTrue:[
"/        fonts := allFonts select:[:f | f pixelSize = currentSize].
"/    ] ifFalse:[
"/        fonts := allFonts select:[:f | f size = currentSize].
"/    ].
"/    fonts notEmpty ifTrue:[
"/        fontShown := fonts anElement.
"/    ] ifFalse:[
"/        "/ mhmh:
"/        "/   size=0 is returned for scalable fonts. 
"/        "/   Any size is possible.
"/        "/
"/        fonts := allFonts select:[:f | f size = 0].
"/        fonts notEmpty ifTrue:[
"/            fontShown := Font family:currentFamily 
"/                      face:currentFace 
"/                      style:currentStyle
"/                      size:currentSize      
"/                      sizeUnit:sizeUnit
"/                      encoding:(fonts anElement encoding).
"/        ]    
"/    ].
"/    ^ fontShown
!

getFacesForFamily:aFamilyName filtering:filter
    "the list of font faces for a given family"

    |familyFonts|

    familyFonts := fontsPerFamily at:aFamilyName ifAbsent:nil.
    familyFonts isEmptyOrNil ifTrue:[^ nil].

    ^ familyFonts 
        select:[:fntDescr |
            (filter isNil or:[filter value:fntDescr])
        ]
        thenCollect:[:fntDescr |
            fntDescr face.
        ]

"/    ^ device facesInFamily:aFamilyName filtering:filter.
!

getFamilyList 
    "the list of font families"

    |d sav_useXftFontsOnly sav_useXFontsOnly|

    sav_useXftFontsOnly := UserPreferences current useXftFontsOnly.
    sav_useXFontsOnly := UserPreferences current useXFontsOnly.
    [
        UserPreferences current useXftFontsOnly:(xftFontsOnlyHolder value).            
        UserPreferences current useXFontsOnly:false.            
        allFonts := device listOfAvailableFonts.
    ] ensure:[
        UserPreferences current useXftFontsOnly:sav_useXftFontsOnly.            
        UserPreferences current useXFontsOnly:sav_useXFontsOnly.            
    ].    
    allFonts isNil ifTrue:[^ nil].

    d := Dictionary new.
    allFonts do:[:fntDescr |
        |family|

        (combinedFilter isNil or:[combinedFilter value:fntDescr]) ifTrue:[
            family := fntDescr family.
            family isNil ifTrue:[
                family := fntDescr name ? 'unnamed'
            ].
            (d at:family ifAbsentPut:[Set new]) add:fntDescr
        ]
    ].
    fontsPerFamily := d.
    ^ d keys asOrderedCollection sort
"/
"/    ^ device fontFamiliesFiltering:combinedFilter.
!

getSizesInFamily:aFamilyName face:face style:style filtering:filter
    |familyFonts faceAndStyleFonts sizes hasScalableFont|

    familyFonts := fontsPerFamily at:aFamilyName ifAbsent:nil.
    familyFonts isEmptyOrNil ifTrue:[^ nil].

    hasScalableFont := false.

    faceAndStyleFonts := 
        familyFonts 
            select:[:fntDescr |
                (filter isNil or:[filter value:fntDescr])
                and:[ fntDescr face = face 
                and:[ fntDescr style = style ]]
            ].

    sizes := 
        faceAndStyleFonts
            collect:[:fntDescr |
                fntDescr isScaledFont ifTrue:[
                    hasScalableFont := true.
                ].
                sizeUnit == #px 
                    ifTrue:[ fntDescr pixelSize ]
                    ifFalse:[ fntDescr size ]
            ].

    hasScalableFont ifTrue:[
        sizeUnit == #px ifTrue:[
            ^ #(10 16 20 24 28 32 48 56 64 72 80 92 128)
        ].
        ^ #(4 5 6 7 8 9 10 11 12 14 16 18 20 22 24 28 32 48 64 72 96 144 192 288)
    ].
    (sizes size == 1 and:[sizes first == 0]) ifTrue:[
        "/ some font may only be available in certain pixel sizes...
        sizeUnit == #pt ifTrue:[
            ^ (faceAndStyleFonts collect:[:fontDescr | fontDescr pixelSize]) asOrderedCollection
                sort collect:[:sz | sz asString , 'px' ].
        ].
        ^ (faceAndStyleFonts collect:[:fontDescr | fontDescr size]) asOrderedCollection
                sort collect:[:sz | sz asString , 'pt' ].
    ].

    ^ sizes asOrderedCollection sort.

"/    sizeUnit == #px ifTrue:[
"/        ^ device 
"/             pixelSizesInFamily:(currentFamily ? '*')
"/             face:(currentFace ? '*')
"/             style:(currentStyle ? '*')
"/             filtering:filter.
"/    ] ifFalse:[
"/        ^ device 
"/             sizesInFamily:(currentFamily ? '*')
"/             face:(currentFace ? '*')
"/             style:(currentStyle ? '*')
"/             filtering:filter.
"/    ].
!

getStylesInFamily:aFamilyName face:aFace filtering:filter
    "the list of font styles for a given family-face"

    |familyFonts|

    familyFonts := fontsPerFamily at:aFamilyName ifAbsent:nil.
    familyFonts isEmptyOrNil ifTrue:[^ nil].

    ^ familyFonts 
        select:[:fntDescr |
            (filter isNil or:[filter value:fntDescr])
            and:[fntDescr face = aFace]
        ]
        thenCollect:[:fntDescr |
            fntDescr style.
        ]

"/    ^ device stylesInFamily:aFamilyName face:aFace filtering:filter.
!

showPreview
    "show the preview text"

    |font deviceFont enc fontName|

    "
     show a wait cursor: for some fonts (kanji etc) the
     X-server needs quite some time to load the font
    "
    self withWaitCursorDo:[
        font := self fontForPreview.
        font notNil ifTrue:[
            deviceFont := font onDevice:device.
            enc := deviceFont encoding.
            enc isNil ifTrue:[enc := #'fontspecific'].

            previewField font:deviceFont.
            previewField characterEncoding:enc.

            encodingLabel label:enc.
            currentEncoding := enc.
            fontName := deviceFont fullName.
            font isXftFont ifTrue:[fontName := fontName,' (xft)'].
            previewField contents:(font userFriendlyName,'\\' withCRs,(self class defaultSampleStringForEncoding:enc) asString).
        ] ifFalse:[
            previewField contents:nil.
            encodingLabel label:nil.
            currentEncoding := nil.
            fontName := nil.
        ].
        selectedFont := font.
        nameLabel notNil ifTrue:[nameLabel label:fontName].
    ]

    "Modified: 30.6.1997 / 17:26:22 / cg"
!

showSelectedFont
    |fam face faceAndStyle style sz font|

    font := (selectedFont ? initialFont).
    
    fam := font family.
    currentEncoding := font encoding.

    fontsPerFamily isNil ifTrue:[
        self updateFamilyList
        "/ self getFamilyList
    ].

    self familySelected:fam showPreview:false.
    fam notNil ifTrue:[
        face := font face.
        (face notNil and:[(style := font style) notNil]) ifTrue:[
            faceAndStyle := face , '-' , style.
        ].
        self faceSelected:faceAndStyle showPreview:false.
        faceAndStyle notNil ifTrue:[
            sz := sizeUnit == #px ifTrue:[font pixelSize asString,'px'] ifFalse:[font size asString].
            pixelPointSwitch contents:sizeUnit.
            self sizeSelected:sz showPreview:false. 
        ]
    ].

    self showPreview
!

updateFamilyList 
    "update the list of font families"

    |families|

    familyList list isNil ifTrue:[
        families := self getFamilyList.
        families notNil ifTrue:[
            families := families asNewOrderedCollection sort
        ].
        familyList list:families
    ].
    selectedFont notNil ifTrue:[
        self showSelectedFont
    ].

    "Modified: 27.2.1996 / 01:39:42 / cg"
    "Created: 27.2.1996 / 01:40:37 / cg"
!

updateSizeList
    |sizes sizeStrings oldSize newSize|

    sizes := self 
            getSizesInFamily:(currentFamily ? '*')
            face:(currentFace ? '*')
            style:(currentStyle ? '*')
            filtering:combinedFilter.

    (sizes isEmptyOrNil) ifTrue:[
        sizeList list:nil.
        currentSize := nil.
"/ self halt.
        ^ self
    ].

    sizes := sizes asOrderedCollection.
    selectedFont notNil ifTrue:[
        oldSize := currentSize.
        newSize := (selectedFont sizeUnit == #px)
                         ifTrue:[ selectedFont pixelSize ]
                         ifFalse:[ selectedFont size ].
        newSize == 0 ifTrue:[
            currentSize := oldSize 
        ] ifFalse:[
            currentSize := newSize asString.
            (selectedFont sizeUnit == #px) ifTrue:[
                currentSize := currentSize , 'px'
            ]
        ].
"/        currentSize notNil ifTrue:[
"/            (sizes includes:currentSize) ifFalse:[
"/                sizes add:currentSize
"/            ].
"/        ].
    ].
    "/ sizes sort.

    sizeStrings := sizes collect:[:entry | entry asString].
    sizeList list:sizeStrings.
    currentSize notNil ifTrue:[
        (sizeStrings includes:(currentSize asString)) ifTrue:[
            sizeList setSelectElement:currentSize asString.
        ] ifFalse:[
            sizeStrings notEmpty ifTrue:[
                sizeList setSelectElement:sizeStrings first.
                currentSize := sizeStrings first.
            ] ifFalse:[
                currentSize := nil
            ].
        ].
    ].
!

xftFontsOnlyChanged
    self filterChanged. "/ will update combinedFilter
! !

!FontPanel methodsFor:'queries'!

characterSetViewClassAvailable
    ^ CharacterSetView notNil

    "Created: / 11-10-2006 / 21:27:51 / cg"
!

characterSetViewClassAvailableOrOSIsUNIX
    ^ self characterSetViewClassAvailable or:[self osIsUNIX]

    "Created: / 11-10-2006 / 21:29:20 / cg"
!

osIsUNIX
    ^ OperatingSystem isUNIXlike

    "Modified: / 11-10-2006 / 21:28:59 / cg"
!

osIsUNIXAndXfdIsAvailable
    ^ self osIsUNIX and:[ (OperatingSystem canExecuteCommand:'xfd')]

    "Modified: / 11-10-2006 / 21:28:59 / cg"
!

preferredExtent
    "return the boxes preferredExtent"

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    "/ ^ 450@350
    ^ self class defaultExtent.

    "Modified: 19.7.1996 / 20:44:08 / cg"
!

xfdCanBeUsed
    ^ self osIsUNIXAndXfdIsAvailable 
        and:[ selectedFont notNil
        and:[ selectedFont isXftFont not  ]]
! !

!FontPanel methodsFor:'startup'!

fontFromUser
    "open this fontPanel and return the selected font, 
     or nil if abort is pressed"

    ^ self 
        fontFromUserInitial:nil
        title:nil
        filter:nil
        encoding:nil
        enabled:true
        withChangeAllOption:false

    "
     FontPanel fontFromUser

     FontPanel new
        withChangeFontInViewsAllCheckBox:true;
        fontFromUser
    "

    "Modified: 27.2.1996 / 00:51:59 / cg"
!

fontFromUserInitial:aFont
    "open this fontPanel showing aFont initially,
     and return the selected font, or nil if abort is pressed"

    ^ self 
        fontFromUserInitial:aFont 
        title:nil
        filter:nil
        encoding:nil
        enabled:true
        withChangeAllOption:false
        
    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12)
     FontPanel fontFromUserInitial:MenuPanel defaultFont
    "
!

fontFromUserInitial:aFont title:someTitle
    "open this fontPanel with title and return the selected font, 
     or nil if abort is pressed"

    ^ self 
        fontFromUserInitial:aFont 
        title:someTitle 
        filter:nil
        encoding:nil
        enabled:true
        withChangeAllOption:false
        
    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'
    "

    "Created: 27.2.1996 / 00:59:46 / cg"
    "Modified: 29.4.1996 / 09:45:34 / cg"
!

fontFromUserInitial:initialFont title:someTitle filter:aFilterBlock
    "open this fontPanel with title and font-filter
     and return the selected font, or nil if abort is pressed"

    ^ self 
        fontFromUserInitial:initialFont 
        title:someTitle 
        filter:aFilterBlock 
        encoding:nil
        enabled:true
        withChangeAllOption:false
        
    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'
    "

    "Created: 27.2.1996 / 00:59:46 / cg"
    "Modified: 10.4.1997 / 09:53:03 / cg"
!

fontFromUserInitial:initialFont title:someTitle filter:aFilterBlock encoding:encoding
    "open this fontPanel with title and font-filter
     and return the selected font, or nil if abort is pressed"

    ^ self
        fontFromUserInitial:initialFont 
        title:someTitle 
        filter:aFilterBlock 
        encoding:encoding 
        enabled:true
        withChangeAllOption:false
        
    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'
    "
!

fontFromUserInitial:initialFont title:someTitle filter:aFilterBlock encoding:encoding enabled:enabled
    "open this fontPanel with title and font-filter
     and return the selected font, or nil if abort is pressed"

    ^ self 
        fontFromUserInitial:initialFont title:someTitle filter:aFilterBlock encoding:encoding enabled:enabled
        withChangeAllOption:false

    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'.
     
     FontPanel new
        withChangeFontInViewsAllCheckBox:true;
        fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'
    "

    "Created: 27.2.1996 / 00:59:46 / cg"
    "Modified: 10.4.1997 / 09:53:03 / cg"
!

fontFromUserInitial:initialFont title:someTitle filter:aFilterBlock encoding:encoding enabled:enabled withChangeAllOption:changeAllBoolean
    "open this fontPanel with title and font-filter
     and return the selected font, or nil if abort is pressed"

    |selectedFont initialFontsEncoding|

    self encodingFilter:aFilterBlock.
    someTitle notNil ifTrue:[
        self label:someTitle
    ].
    self action:[:aFontDescription | selectedFont := aFontDescription].
    initialFont notNil ifTrue:[
        self initialFont:initialFont.
    ].
    encoding notNil ifTrue:[
        self encoding:encoding.
    ] ifFalse:[
        initialFont notNil ifTrue:[
            initialFontsEncoding := initialFont encoding.
            ((initialFontsEncoding = #'iso8859-1')
            or:[ (initialFontsEncoding = #'iso10646-1') ]) ifFalse:[
                self encoding:initialFontsEncoding
            ].
        ].
    ].
    self enabled:enabled.
    
    self withChangeFontInAllViewsCheckBoxVisibleHolder 
            setValue:(enabled and:[changeAllBoolean]);
            changed.
    self showAtPointer.

    self destroy.
    ^ selectedFont

    "
     FontPanel fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'.
     
     FontPanel new
        withChangeFontInViewsAllCheckBox:true;
        fontFromUserInitial:(Font family:'courier' size:12) title:'select some font'
    "

    "Created: 27.2.1996 / 00:59:46 / cg"
    "Modified: 10.4.1997 / 09:53:03 / cg"
! !

!FontPanel methodsFor:'user interaction'!

copyFontName
    self setClipboardText:(previewField font storeString).
!

encodingFilterSelected:anEncodingPattern
    "another encoding was selected; find available fonts and update lists"

    |pattern|

    anEncodingPattern isNil ifTrue:[
        self encodingFilter:nil.
        ^ self.
    ].

    pattern := (anEncodingPattern upTo:$( ) withoutSeparators.

    pattern = '?' ifTrue:[
        pattern := ''
    ] ifFalse:[
        pattern := (pattern isEmptyOrNil ifTrue:'*' ifFalse:pattern).
    ].
    self 
        encodingFilter:
            [:f | 
                |doesMatch encoding|

                "/ k&d hack for mswindows names...
                "/ Transcript showCR:f encoding.
                encoding := f encoding ? ''.
                doesMatch := (pattern match:encoding).
                doesMatch ifFalse:[
                    encoding = 'ms-ansi' ifTrue:[
                       doesMatch := (pattern = 'iso8859-1') 
                                    or:[ (pattern = 'iso10646-1')
                                    or:[ (pattern = 'unicode') ]]
                    ].
                    (encoding = 'iso8859-1' 
                    or:[encoding = 'iso10646-1' 
                    or:[encoding = 'unicode']]) ifTrue:[
                       doesMatch := (pattern = 'ms-ansi').
                       "/ unicode can show all iso charas as well...
                       doesMatch := doesMatch or:[ pattern = 'iso8859-1' ].
                       doesMatch := doesMatch or:[ pattern = 'ascii' ].
                    ].
                ].
                doesMatch
            ].
!

faceSelected:aFaceAndStyleName
    "a fonts face was selected; find available sizes and update lists"

    self faceSelected:aFaceAndStyleName showPreview:true
!

faceSelected:aFaceAndStyleName showPreview:showPreview
    "a fonts face was selected; find available sizes and update lists"

    |sizes sizeStrings didShow|

    aFaceAndStyleName notNil ifTrue:[    
        self extractFaceAndStyleFrom:aFaceAndStyleName.
    ].
    self updateSizeList.
    showPreview ifTrue:[
        self showPreview.
    ].
    ^ self.
"/
"/    sizes := self 
"/                getSizesInFamily:(currentFamily ? '*')
"/                face:(currentFace ? '*')
"/                style:(currentStyle ? '*')
"/                filtering:combinedFilter.
"/
"/    (sizes isEmptyOrNil) ifTrue:[
"/        sizeList list:nil.
"/        currentSize := nil.
"/        self breakPoint:#cg.
"/        showPreview ifTrue:[
"/            self showPreview.
"/        ].
"/        ^ self
"/    ].
"/
"/    didShow := false.
"/
"/    sizes := sizes asOrderedCollection.
"/    selectedFont notNil ifTrue:[
"/        (sizes includes:selectedFont size) ifFalse:[
"/            sizes add:selectedFont size
"/        ].
"/    ].
"/    sizes sort.
"/
"/    sizeStrings := sizes collect:[:entry | entry printString].
"/    sizeList list:sizeStrings.
"/    currentSize notNil ifTrue:[
"/        (sizeStrings includes:(currentSize printString)) ifTrue:[
"/            sizeList setSelectElement:currentSize printString.
"/            showPreview ifTrue:[
"/                self showPreview.
"/                didShow := true.
"/            ]
"/        ]
"/    ].
"/    didShow ifFalse:[
"/        self clearPreview
"/    ].
"/
    "Modified: 30.6.1997 / 17:25:46 / cg"
!

familySelected:aFamilyName
    "a fonts family was selected; find available faces and update lists"

    self familySelected:aFamilyName showPreview:true
!

familySelected:aFamilyName showPreview:showPreview
    "a fonts family was selected; find available faces and update lists"

    |familyNameUsed faces styles list idx|

    familyNameUsed := aFamilyName.
    
    familyList setSelectElement:familyNameUsed.
    familyList selection isNil ifTrue:[
        "/ mhm - maybe lowercase...
        idx := familyList list indexOf:(familyNameUsed := aFamilyName asUppercaseFirst).
        idx == 0 ifTrue:[
            idx := familyList list indexOf:(familyNameUsed := aFamilyName asLowercaseFirst).
        ].
        idx ~~ 0 ifTrue:[
            familyList selection:idx.
        ].
    ].
    
    currentFamily := familyNameUsed.
    faces := self getFacesForFamily:currentFamily filtering:combinedFilter.
    faces isEmptyOrNil ifTrue:[
        currentFace := currentStyle := currentFaceAndStyle := nil.
        faceList list:nil.
        self faceSelected:nil showPreview:showPreview.
        ^ self.
    ].

    list := SortedCollection new.
    faces do:[:aFace |
        styles := (self getStylesInFamily:currentFamily face:aFace filtering:combinedFilter) ? #().
        styles do:[:aStyle |
            aFace isEmptyOrNil ifTrue:[
                list add:(aStyle)
            ] ifFalse:[
                list add:(aFace , '-' , aStyle)
            ]
        ]
    ].

    faceList list:list.
    currentFaceAndStyle notNil ifTrue:[
        (list includes:currentFaceAndStyle) ifFalse:[
            currentFaceAndStyle = 'normal-roman' ifTrue:[
                (list includes:'regular-roman') ifTrue:[
                    currentFaceAndStyle := 'regular-roman'.
                    currentFace := 'regular'.
                    currentStyle := 'roman'.
                ].
                (list includes:'medium-roman') ifTrue:[
                    currentFaceAndStyle := 'medium-roman'.
                    currentFace := 'medium'.
                    currentStyle := 'roman'.
                ].
            ].
        ].
        (list includes:currentFaceAndStyle) ifTrue:[
            faceList setSelectElement:currentFaceAndStyle.
            self faceSelected:currentFaceAndStyle showPreview:showPreview.
            ^ self
        ]
    ].
    list notEmptyOrNil ifTrue:[
        "/ faceList setSelectElement:(list first).
        faceList selectElement:(list first).
        self faceSelected:(list first) showPreview:showPreview.
        self updateSizeList.
        ^ self
    ].

    sizeList list:nil.
    self clearPreview.

    "Modified: 26.5.1996 / 15:04:29 / cg"
!

flushListOfAvailableFonts
    self withWaitCursorDo:[
        "this may take some time, especially with X11 XFT fonts"
        device 
            flushListOfAvailableFonts;
            listOfAvailableFonts.

        familyList list:nil.
        self updateFamilyList.
    ].
!

fontAttributeFilterChanged
    "a filter toggled (decorative/monospaced etc.)"

^ self.
!

okPressed
    "ok was pressed; hide myself and evaluate the okAction, passing
     family, face, style and size as arguments"

    |sz szUnitUsed|

    szUnitUsed := (sizeUnit ? #pt).
    sz := Number readFrom:currentSize.
    (currentSize endsWith:#px) ifTrue:[
        szUnitUsed := #px
    ].

    self hide.
    okAction notNil ifTrue:[
        currentFamily notNil ifTrue:[
            okAction value:
                (((device supportsXftFonts and:[self xftFontsOnlyHolder value])
                        ifTrue:[XftFontDescription]
                        ifFalse:[FontDescription])
                      family:currentFamily 
                      face:currentFace 
                      style:currentStyle
                      size:sz      
                      sizeUnit:szUnitUsed
                      encoding:(currentEncoding ? encoding)).
        ]
    ]

    "Modified: 10.4.1997 / 09:51:31 / cg"
!

previewCopySelection
    previewField copySelection.
!

previewInspectFont
    previewField font inspect.
!

previewShowCharacterSet
    CharacterSetView openOn:(previewField font)
!

previewShowCharacterSetUsingXFD
    |fullName|

    (fullName := selectedFont fullName) isNil ifTrue:[
        self warn:('Sorry could not figure out the X-font (aka file) name of: ', selectedFont printString).
        ^ self.
    ].
    
    [
        OperatingSystem executeCommand:'xfd -fn ' , fullName.
    ] fork.
!

sizeSelected:aNumberOrString
    "a size was selected; update preview"

    self sizeSelected:aNumberOrString showPreview:true.
!

sizeSelected:aNumberOrString showPreview:showPreview
    "a size was selected; update preview"

    currentSize := aNumberOrString.
"/    aNumberOrString isNumber ifFalse:[
"/        currentSize := Number readFromString:aNumberOrString onError:nil
"/    ].
    showPreview ifTrue:[self showPreview]

    "Modified: 29.4.1996 / 09:43:23 / cg"
!

sizeUnitSelected:unitSymbol
    sizeUnit := unitSymbol.
    sizeLabelHolder value:(resources 
                            string:(sizeUnit == #px 
                                        ifTrue:'Size (px)' 
                                        ifFalse:'Size')).

    self showPreview
! !

!FontPanel class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

