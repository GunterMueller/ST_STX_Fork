"
 COPYRIGHT (c) 1999 by Claus Gittinger / eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#TextStyle
	instanceVariableNames:'fontArray fontFamilySize lineGrid baseline alignment firstIndent
		restIndent rightIndent tabsArray marginTabsArray leading'
	classVariableNames:'DefaultTextStyle'
	poolDictionaries:''
	category:'Graphics-Support'
!

TextStyle comment:''
!

!TextStyle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by Claus Gittinger / eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    ST-80 compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    This is currently not used by ST/X itself.
"
! !

!TextStyle class methodsFor:'instance creation'!

changeDefaultFontSizeBy: delta      "TextStyle changeDefaultFontSizeBy: 1"
	"This sample method recreates the default textStyle, with font 1 being a size
	larger than the smallest.  It then initializes most references in the system
	as well, although most windows will have to beclosed and reopened to get the effect."
	| allFonts |
	allFonts _ TextStyle default fontArray asSortedCollection: [:a :b | a height < b height].
	TextConstants at: #DefaultTextStyle put:
		(TextStyle fontArray: ((1 to: allFonts size) collect: [:i | allFonts atWrap: i+delta])).
	PopUpMenu initialize.  "Change this method for difft menu font"
	ListParagraph initialize.  "Change this method for difft ListPane font"
	StandardSystemView initialize.  "Change this method for difft Window label font"
!

fontArray: anArray 
	"Answer an instance of me with fonts those in the argument, anArray."

	^self new newFontArray: anArray
!

initDefaultFontsAndStyle
        "This provides the system with 10 and 12-pt basal fonts.
        Bold and italic versions will be automatically generated as needed"
        | fontArray |   
        fontArray _ Array new: 2.
        Smalltalk isSmalltalkX ifTrue:[
            fontArray at: 1 put: ((Font family:'Courier' size:10) onDevice:Screen current).
            fontArray at: 2 put: ((Font family:'Courier' size:12) onDevice:Screen current).
            DefaultTextStyle := (TextStyle fontArray: fontArray).
        ] ifFalse:[
            fontArray at: 1 put: (StrikeFont new readFromStrike2: 'NewYork10.sf2').
            fontArray at: 2 put: (StrikeFont new readFromStrike2: 'NewYork12.sf2').
            TextConstants at: #DefaultTextStyle put:
                    (TextStyle fontArray: fontArray).
        ]

        "TextStyle initDefaultFontsAndStyle."
!

new
	^ super new leading: 2
! !

!TextStyle class methodsFor:'constants'!

default
        "Answer the system default text style."
        DefaultTextStyle isNil ifTrue:[
            self initDefaultFontsAndStyle
        ].
        ^DefaultTextStyle
!

defaultFont
    ^ View defaultFont

    "Created: / 11-09-2011 / 16:16:02 / cg"
!

named: familyName
	^ TextConstants at: familyName asSymbol ifAbsent: [nil]
! !

!TextStyle methodsFor:'Disk I/O'!

storeDataOn: aDataStream
        "Store myself on a DataStream. This is a low-level DataStream/ReferenceStream method. See also objectToStoreOnDataStream.  Need this to share tabsArray and marginTabsArray.  Fonts will take care of themselves.  "
        | cntInstVars cntIndexedVars instVars ti tm |

        cntInstVars _ self class instSize.
        cntIndexedVars _ self basicSize.
        instVars _ self class allInstVarNames.
        ti _ (instVars indexOf: 'tabsArray').
        tm _ (instVars indexOf: 'marginTabsArray').
        (((ti = 0) or:[ tm = 0 ]) or:[ ti > tm ]) ifTrue: [self error: 'this method is out of date'].
        aDataStream
                beginInstance: self class
                size: cntInstVars + cntIndexedVars.
        1 to: ti-1 do:
                [:i | aDataStream nextPut: (self instVarAt: i)].
        tabsArray == DefaultTabsArray 
                ifTrue: [aDataStream nextPut: (DiskProxy global: #TextConstants selector: #at: 
                                                args: #(DefaultTabsArray))]
                ifFalse: [aDataStream nextPut: tabsArray].
        ti+1 to: tm-1 do:
                [:i | aDataStream nextPut: (self instVarAt: i)].
        marginTabsArray == DefaultMarginTabsArray
                ifTrue: [aDataStream nextPut: (DiskProxy global: #TextConstants selector: #at: 
                                                args: #(DefaultMarginTabsArray))]
                ifFalse: [aDataStream nextPut: marginTabsArray].
        tm+1 to: cntInstVars do:
                [:i | aDataStream nextPut: (self instVarAt: i)].
        1 to: cntIndexedVars do:
                [:i | aDataStream nextPut: (self basicAt: i)]
!

veryDeepCopyWith: deepCopier
	"All inst vars are meant to be shared"

	#veryDeepCopyWith:.	"to satisfy checkVariables"
	^ deepCopier references at: self ifAbsent: [
		deepCopier references at: self put: self clone].	"remember"
! !

!TextStyle methodsFor:'accessing'!

= other
	other class == self class ifFalse: [^ false].
	1 to: self class instSize do:
		[:i | (self instVarAt: i) == (other instVarAt: i) ifFalse: [^ false]].
	^ true
!

alignment
	"Answer the code for the current setting of the alignment."

	^alignment
!

alignment: anInteger 
	"Set the current setting of the alignment to be anInteger:
	0=left flush, 1=centered, 2=right flush, 3=justified."

	alignment _ anInteger \\ (Justified + 1)
!

baseline
	"Answer the distance from the top of the line to the bottom of most of the 
	characters (by convention, bottom of the letter 'A')."

	^baseline
!

baseline: anInteger 
	"Set the distance from the top of the line to the bottom of most of the 
	characters."

	baseline _ anInteger
!

centered
	alignment _ 2
!

defaultFont
	"Answer the first font in the font family."

	^fontArray at: 1
!

firstIndent
	"Answer the horizontal indenting of the first line of a paragraph in the 
	style of the receiver."

	^firstIndent
!

firstIndent: anInteger 
	"Set the horizontal indenting of the first line of a paragraph in the style 
	of the receiver to be the argument, anInteger."

	firstIndent _ anInteger
!

fontNamed: fontName  "TextStyle default fontNamed: 'TimesRoman10'"
	^ fontArray detect: [:x | x name sameAs: fontName]
!

fontNames  "TextStyle default fontNames"
	^ fontArray collect: [:x | x name]
!

fontNamesAndSizes  "TextStyle default fontNames"
	^ fontArray collect: [:x | x name, ' ', x height printString]
!

justified
	alignment _ 3
!

leading
	"Leading (from typographers historical use of extra lead (type metal))
	is the extra spacing above and beyond that needed just to accomodate
	the various font heights in the set."
	^ leading
!

leading: yDelta

	leading _ yDelta
!

leftFlush
	alignment _ 0
!

lineGrid
	"Answer the relative space between lines of a paragraph in the style of 
	the receiver."

	^lineGrid
!

lineGrid: anInteger 
	"Set the relative space between lines of a paragraph in the style of the 
	receiver to be the argument, anInteger."

	lineGrid _ anInteger
!

printOn: aStream
	super printOn: aStream.
	aStream space; nextPutAll: self defaultFont familySizeFace first
!

restIndent
	"Answer the indent for all but the first line of a paragraph in the style 
	of the receiver."

	^restIndent
!

restIndent: anInteger 
	"Set the indent for all but the first line of a paragraph in the style of the 
	receiver to be the argument, anInteger."

	restIndent _ anInteger
!

rightFlush
	alignment _ 1
!

rightIndent
	"Answer the right margin indent for the lines of a paragraph in the style 
	of the receiver."

	^rightIndent
!

rightIndent: anInteger 
	"Answer the right margin indent for the lines of a paragraph in the style 
	of the receiver to be the argument, anInteger."

	rightIndent _ anInteger
! !

!TextStyle methodsFor:'fonts and font indexes'!

collectionFromFileNamed: fileName
	"Read the file.  It is an TextStyle whose StrikeFonts are to be added to the system.  (Written by fooling SmartRefStream, so it won't write a DiskProxy!!)  These fonts will be added to the master TextSytle for this font family.  
	To write out fonts: 
		| ff | ff _ ReferenceStream fileNamed: 'new fonts'.
		TextConstants at: #forceFontWriting put: true.
		ff nextPut: (TextConstants at: #AFontName).
			'do not mix font families in the TextStyle written out'.
		TextConstants at: #forceFontWriting put: false.
		ff close.
	To read: (TextStyle default collectionFromFileNamed: 'new fonts')
*** Do not remove this method *** "

	| ff this newName style heights |
	ff _ ReferenceStream fileNamed: fileName.
	this _ ff nextAndClose.	"Only works if file created by special code above"
	newName _ this fontArray first name.
	this fontArray do: [:aFont | aFont name = newName ifFalse: [
		self error: 'All must be same family']].
	style _ TextConstants at: newName asSymbol ifAbsent: [
		^ TextConstants at: newName asSymbol put: this].		"new family"
	this fontArray do: [:aFont | "add new fonts"
		heights _ style fontArray collect: [:bFont | bFont height].
		(heights includes: aFont height) ifFalse: [
			style fontAt: style fontArray size + 1 put: aFont]].
!

flushFonts
        "Clean out the fonts, an aid when snapshotting claims too many are 
        holding onto Display."

        (self confirm: 
'flushFonts is very dangerous.
Are you foolish or clever enough to proceed?')
                ifTrue: [1 to: fontArray size do: [:index | fontArray at: index put: nil]]
                ifFalse: [Transcript cr; show: 'flushFonts canceled']

        "TextStyle default flushFonts"

    "Modified: / 24-08-2017 / 15:04:23 / cg"
!

fontIndexOfSize: desiredHeight
	"Returns an index in fontArray of the font with height <= desiredHeight"
	"Leading is not inluded in the comparison"
	| bestMatch bestIndex d |
	bestMatch _ 9999.  bestIndex _ 1.
	1 to: fontArray size do:
		[:i | d _ desiredHeight - (fontArray at: i) height.
		d = 0 ifTrue: [^ i].
		(d > 0 and: [d < bestMatch]) ifTrue: [bestIndex _ i. bestMatch _ d]].
	^ bestIndex
!

fontOfSize: aHeight
	"See fontIndexOfSize.
	Returns the actual font.  Leading not considered."

	^ fontArray at: (self fontIndexOfSize: aHeight)
! !

!TextStyle methodsFor:'private'!

consolidate
	"If this style includes any fonts that are also in the default style,
	then replace them with references to the default ones."
"
	TextStyle allInstancesDo: [:s | s == TextStyle default ifFalse: [s consolidate]]
"
	| defFonts font |
	defFonts _ TextStyle default fontArray.
	1 to: fontArray size do:
		[:i | font _ fontArray at: i.
		1 to: defFonts size do:
			[:j | (font name asUppercase copyWithout: $ )
			= ((defFonts at: j) name asUppercase copyWithout: $ )
			ifTrue: [fontArray at: i put: (defFonts at: j)]]]
!

fontArray
	"Only for writing out fonts, etc.  8/16/96 tk"
	^ fontArray
!

fontAt: index 
	"This is private because no object outside TextStyle should depend on the 
	representation of the font family in fontArray."

	^ fontArray atPin: index
!

fontAt: index put: font
	"Automatically grow the array.  8/20/96 tk"
	index > fontArray size ifTrue: [
		fontArray _ fontArray, (Array new: index - fontArray size)].
	fontArray at: index put: font
!

gridForFont: fontIndex withLead: leadInteger 
	"Force whole style to suit one of its fonts. Assumes only one font referred
	to by runs."
	| font |
	font _ self fontAt: fontIndex.
	self lineGrid: font height + leadInteger.
	self baseline: font ascent.
	self leading: leadInteger
!

marginTabAt: marginIndex side: sideIndex 
	"The marginTabsArray is an Array of tuples.  The Array is indexed
	according to the marginIndex, the 'nesting' level of the requestor.
	sideIndex is 1 for left, 2 for right."

	(marginIndex > 0 and: [marginIndex < marginTabsArray size])
		ifTrue: [^(marginTabsArray at: marginIndex) at: sideIndex]
		ifFalse: [^0]
!

newFontArray: anArray
	"Currently there is no supporting protocol for changing these arrays. If an editor wishes to implement margin setting, then a copy of the default should be stored with these instance variables.  
	, Make size depend on first font."

	fontArray _ anArray.
	lineGrid _ (fontArray at: 1) height + leading.	"For whole family"
	baseline _ (fontArray at: 1) ascent + leading.
	alignment _ 0.
	firstIndent _ 0.
	restIndent _ 0.
	rightIndent _ 0.
	tabsArray _ DefaultTabsArray.
	marginTabsArray _ DefaultMarginTabsArray
"
TextStyle allInstancesDo: [:ts | ts newFontArray: TextStyle default fontArray].
"
! !

!TextStyle methodsFor:'tabs and margins'!

clearIndents
	"Reset all the margin (index) settings to be 0."

	self firstIndent: 0.
	self restIndent: 0.
	self rightIndent: 0
!

leftMarginTabAt: marginIndex 
	"Set the 'nesting' level of left margin indents of the paragraph in the 
	style of the receiver to be the argument, marginIndex."

	(marginIndex > 0 and: [marginIndex < marginTabsArray size])
		ifTrue: [^(marginTabsArray at: marginIndex) at: 1]
		ifFalse: [^0]	
	"The marginTabsArray is an Array of tuples.  The Array is indexed according 
	to the marginIndex, the 'nesting' level of the requestor."
!

nextTabXFrom: anX leftMargin: leftMargin rightMargin: rightMargin 
	"Tab stops are distances from the left margin. Set the distance into the 
	argument, anX, normalized for the paragraph's left margin."

	| normalizedX tabX |
	normalizedX _ anX - leftMargin.
	1 to: tabsArray size do: 
		[:i | (tabX _ tabsArray at: i) > normalizedX 
				ifTrue: [^leftMargin + tabX min: rightMargin]].
	^rightMargin
!

rightMarginTabAt: marginIndex 
	"Set the 'nesting' level of right margin indents of the paragraph in the 
	style of the receiver to be marginIndex."

	(marginIndex > 0 and: [marginIndex < marginTabsArray size])
		ifTrue: [^(marginTabsArray at: marginIndex) at: 2]
		ifFalse: [^0]
	"The marginTabsArray is an Array of tuples.  The Array is indexed according 
	to the marginIndex, the 'nesting' level of the requestor."
!

tabWidth
	"Answer the width of a tab."

	^DefaultTab
! !

!TextStyle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/TextStyle.st,v 1.10 2017-08-24 16:03:34 cg Exp $'
!

version_SVN
    ^ '$Id: TextStyle.st,v 1.10 2017-08-24 16:03:34 cg Exp $'
! !

