"{ Encoding: utf8 }"

"{ Package: 'stx:libview/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#FontTests
	instanceVariableNames:'testFontSize fontList testString startTimer topView textView'
	classVariableNames:''
	poolDictionaries:''
	category:'TestCases'
!

!FontTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        svestkap

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!FontTests methodsFor:'initialize / release'!

setUp

    | numberOfTestedFonts windowWidthX windowHightY |
    self skipIf: Screen current isNil description: 'No display connection'.
    
    "/init
    startTimer := Time now. 
    numberOfTestedFonts := 100.
    
    "/random font size to circumvent ascanding or descending font size bugs
    testFontSize := #(6 12 24 48 96 288) shuffled.
    
    "/pick random fonts available at system
    fontList := (Display listOfAvailableFonts) shuffled.
    fontList := ((fontList size) > numberOfTestedFonts) ifTrue: [fontList copyFrom:1 to: numberOfTestedFonts]. 

    "/Japanese characters for UTF-16 testing
    testString := Unicode16String new.
    testString := 'コーヒーアイスクリームケーキビールすしかき空'.

    "/creating a long string to be displayed at textView
    10 timesRepeat:[testString := testString,testString].  

    "/set testing window size -> large for large font testing (will probably fail for smaller)
    windowWidthX := 640.
    windowHightY := 400.

    topView := StandardSystemView new.
    topView extent:windowWidthX @ windowHightY.
    topView label:'TextOut Raster testing with different font sizes and large strings'.
    textView := EditTextView origin:0.0 @ 0.0 extent:1.0 @ 1.0 in:topView.
    "/if styles are present, make sure we have correct setup
    textView backgroundColor: Color white; 
             foregroundColor: Color black.

    topView open.
    topView waitUntilVisible.

    "Modified: / 25-04-2018 / 14:35:23 / svestkap"
!

tearDown
    "common cleanup - invoked after testing."
    | endTimer message |
    endTimer := Time now.
    
    "/left here for user overview when run manually
    "/Transcript showCR: 'FontTests time duration: '; showCR:(endTimer - startTimer) asString.
    
    message := 'FontTests time duration: ', (endTimer - startTimer) asString.
    Logger log: message severity: #info.
    
    topView isOpen ifTrue:[ topView close ].

    "Modified (format): / 25-04-2018 / 12:05:24 / svestkap"
! !

!FontTests methodsFor:'tests'!

test_issue_126_TextOut_raster_size_24bit 
    " Testing long strings display.  
      The test takes shown textView and tries to find out non-white pixels.
  
    For more visit: https://swing.fit.cvut.cz/projects/stx-jv/ticket/126"
    | imageSnapshot |
  
    self skipIf: (DeviceWorkstation current isWindowsPlatform not) description: 'Not a Windows platform'. 
    self skipIf: Screen current depth ~~ 24 description: 'Different than 24bit resulution'. 

    fontList do:[:font | 
        testFontSize do:[:preselectedFontSize |   | setFontSize fontAtSize bits |
               [   textView contents: testString.
                   (font size = 0.0) ifTrue:[setFontSize := preselectedFontSize]  "/TrueType font
                                     ifFalse:[setFontSize := font size].          "/Raster font
                   fontAtSize := (font copy asSize:setFontSize) onDevice:textView device.
                   textView font:fontAtSize.

                   imageSnapshot := Image fromView:textView grab:false.
                   self assert:(imageSnapshot photometric == #rgb).
                   self assert:(imageSnapshot isDepth24Image).

                   bits := imageSnapshot bits.
                   self assert:(bits contains:[:bit | bit ~~ 255 ]).
               ] ensure:[textView contents:nil].
        ]
    ].

    "
     FontTests run: #test_issue_126_TextOut_raster_size_24bit  
     FontTests debug: #test_issue_126_TextOut_raster_size_24bit  
    "

    "Created: / 05-04-2018 / 12:16:57 / svestkap"
    "Modified: / 25-04-2018 / 14:37:12 / svestkap"
! !

!FontTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

