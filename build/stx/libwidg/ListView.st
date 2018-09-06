"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

View subclass:#ListView
	instanceVariableNames:'list firstLineShown nFullLinesShown nLinesShown fgColor bgColor
		partialLines leftMargin topMargin textStartLeft textStartTop
		innerWidth tabPositions lineSpacing fontHeight fontAscent
		fontIsFixedWidth fontWidth autoScroll autoScrollBlock
		autoScrollDeltaT wordCheck includesNonStrings widthOfWidestLine
		listMsg viewOrigin listChannel backgroundAlreadyClearedColor
		scrollWhenUpdating scrollLocked lineEndCRLF highlightAreas
		compareModelOnUpdate expandTabsWhenUpdating
		checkLineEndConventionWhenUpdating
		checkedLinesForWidthOfContentsComputation'
	classVariableNames:'DefaultForegroundColor DefaultBackgroundColor DefaultTabPositions
		UserDefaultTabPositions DefaultLeftMargin DefaultTopMargin'
	poolDictionaries:''
	category:'Views-Text'
!

Object subclass:#HighlightArea
	instanceVariableNames:'startLine startCol endLine endCol fgColor bgColor'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ListView
!

Object subclass:#SearchSpec
	instanceVariableNames:'pattern match ignoreCase variable fullWord forward
		atBeginOfLineOnly ignoreDiacritics regexMatch wrapAtEndOfText'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ListView
!

!ListView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    a View for (string-)lists.

    This class can only passively display collections of strings,
    text or display objects which behave line-like (i.e. all have constant height).

    Selections, editing, cursors etc. must be implemented in subclasses.
    (see SelectionInListView, TextView etc.)

    This code currently handles only fixed-height fonts correctly -
    it should be rewritten in some places to not compute the position/height from
    the view's font height, but by accumulating line heights...

    It can only scroll by full lines vertically (i.e. setting firstLineShown to ~~ 1)
    which should be changed to have this behavior optionally for smooth scroll.
        
    The text is internally kept in the 'list' instance variable, and is supposed to consist
    of a collection (Ordered-, String- or VirtualCollection) of line entries.
    Typically, individual entries are either strings/text or nil (for empty lines).
    However, ANY object which supports the displayOn: and widthIn: protocol can be
    used - see MultipleColumnListEntry as an example.
    Therefore, ListView (and all subclasses) are prepared to handle non-string entries
    (especially: attributed Text and labelAndIcon-like entities).

    The internal version of the text has tabulators expanded to blanks. 
    ListView is not prepared to deal with them. 
    When text is exchanged with an external medium (i.e. reading/writing files),
    these are expanded/compressed assuming a tab-setting of 8.
    This is done independent of the user's tab setting, which is used ONLY for positioning,
    while the text is edited.
    Thus, even if the tab setting is multiple of 4's, tabs are
    written in multiples of 8 when the text is saved. 
    Since this is the default on all ascii terminals and printers, 
    this assures that the text looks correctly indented when finally printed.

    Notice:
    -------
    ListView is one of the OLDEST widget classes in the system and definitely requires a major rewrite:

    Due to historic reasons (ListView implemented scrolling before the general
    scrolling code in View was added), this one does scrolling different from all other
    views. The general scrolling code (in View) uses the transformation for transparent scrolling
    using the viewOrigin (transparent means, that the code does not need to know - it simply draws
    as if all of the text was visible).

    Here in ListView, the transformation is not used, instead it is done again, and different,
    by keeping the firstLineShown (i.e. vertical offset) and leftOffset (horizontal offset).
    Even worse: the firstLineShown is a line-index, the most annoying consequence of this is that
    scrolling is done by lines here, whereas it is done in pixels in the View class.
    Thus, be very careful, when changing things (better: don't touch it ;-).
    Also, the viewOrigin variable is only valid for the x coordinate. The viewOrigin's y is always 0 !!

    Also, all controller functionality is completely performed by the listView
    (and subclasses) itself. It is still possible, to define and set a specialized
    controller, though. I.e. if you like to change the input behavior, define
    a corresponding controller class and intersect the keyXXX/buttonXXX messages
    there.

    This may be totally rewritten ... so don't depend on the internals; especially the scrolling
    code will be totally removed here and the inherited functionality be used in the next version.

    Also Notice:
    ------------
    because ListView was written at a time when most of the graphics was done via remote connections
    (X-window network protocol), it is highly tuned to avoid redraw operations. Thus, it can be used
    happily over a slow WLAN (say: 64kBit connection).
    In that, it performed *much* better than other widgets, especialy Java and Qt, some of which are
    hardly usable via the network.
    It may be questionable whether this is still a requirement these days, where network connections
    are usually pretty fast. 
    However, the author insists on this to remain as it is, because we do have customers
    and applications which rely on relatively good remote display performance!!
    Future underlying graphics may well become network dependent in the future, for example, when
    the display connection is implemented as an RPC into a web browser...

    Also Notice (Virtual line collections):
    ------------
    ListView shall be configurable to avoid accesses to its underlying list if required.
    Currently, it can be customized to disable lineWidth computation, tab expansion and scanning for
    non-string entries. 
    All of which is required when huge texts which are not in memory are to be displayed
    (for example: a virtual array of 10million text lines). 
    Please be careful to not reintroduce such code when adding features 
    (as happened in the past). ListView shall always be configurable to only access
    a minimum subset of the line collection (i.e. only the currently visible page),
    by customizing the tab-expansion, line-end and widthOfContents behavior.

    [Instance variables:]

      list                <aCollection>           the text strings, a collection of lines.
                                                  Nils may be used for empty lines.

      firstLineShown      <Number>                the index of the 1st visible line (1 ..)
      leftOffset          <Number>                left offset for horizontal scroll

      nFullLinesShown     <Number>                the number of unclipped lines in visible area
                                                  (internal; updated on size changes)
      nLinesShown         <Number>                the number of lines in visible area, incl. partial
                                                  (internal; updated on size changes)

      fgColor             <Color>                 color to draw characters
      bgColor             <Color>                 the background

      partialLines        <Boolean>               allow last line to be partial displayed
      leftMargin          <Number>                margin at left in pixels
      topMargin           <Number>                margin at top in pixels
      textStartLeft       <Number>                margin + leftMargin (internal)
      textStartTop        <Number>                margin + topMargin (internal)
      innerWidth          <Number>                width - margins (internal)
      tabPositions        <aCollection>           tab stops (cols)
      fontHeight          <Number>                font height in pixels (internal)
      fontAscent          <Number>                font ascent in pixels (internal)
      fontIsFixed         <Boolean>               true if its a fixed font (internal)
      fontWidth           <Number>                width of space (internal)
      lineSpacing         <Number>                pixels between lines
      lastSearchPattern   <String>                last pattern for searching
                                                  (kept to provide a default for next search)
      lastSearchIgnoredCase   <Boolean>           last search ignored case
                                                  (kept to provide a default for next search)
      wordCheck           <Block>                 rule used for check for word boundaries in word select
                                                  The default rule is to return true for alphaNumeric characters.
                                                  (can be changed to allow for underscore and other
                                                   characters to be treated as alphaCharacters)

      autoScrollBlock     <Block>                 block installed as timeoutBlock when doing an
                                                  autoScroll (internal)
      autoScrollDeltaT                            computed scroll time delta in seconds (internal)

      includesNonStrings                          cached flag if any non-strings are in list
      widthOfWidestLine                           cached width of widest line
      listMsg                                     if view has a model and listMsg is non-nil,
                                                  this is sent to the model to acquired a new contents
                                                  whenever a change of the aspect  (aspectMsg) occurs.

      viewOrigin                                  the current origin

      backgroundAlreadyClearedColor               internal; speedup by avoiding
                                                  multiple fills when drawing
                                                  internal lines

      scrollWhenUpdating
                                <Symbol>        defines how the view is scrolled if the
                                                model changes its value by some outside activity
                                                (i.e. not by user input).
                                                Can be one of:
                                                    #keep / nil     -> stay unchanged
                                                    #endOfText      -> scroll to the end
                                                    #beginOfText    -> scroll to the top
                                                The default is #beginOfText (i.e. scroll to top).

    [StyleSheet parameters:]

      textForegroundColor                         defaults to Black
      textBackgroundColor                         defaults to White
      textFont                                    defaults to defaultFont
      textTabPositions                            defaults to #(1 9 17 25 ...)

    [author:]
        Claus Gittinger

    [see also:]
        TextView EditTextView

"
!

examples
"
    ListViews alone are rarely used - its mostly an abstract superclass
    for TextView, EditTextView and SelectionInListView.

    anyway, here are a few examples:

     basic simple setup:
									[exBegin]
	|top l|

	top := StandardSystemView new.
	top extent:100@200.

	l := ListView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.
	l list:#('one' 'two' 'three').

	top open
									[exEnd]



      specifying textMargins (these have NOTHING to do with the viewInset):
									[exBegin]
	|top l|

	top := StandardSystemView new.
	top extent:100@200.

	l := ListView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.
	l list:#('one' 'two' 'three').
	l topMargin:10.
	l leftMargin:20.

	top open
									[exEnd]



      globally set the fg/bg colors:
									[exBegin]
	|top l|

	top := StandardSystemView new.
	top extent:100@200.

	l := ListView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.
	l list:#('one' 'two' 'three').
	l foregroundColor:(Color white).
	l backgroundColor:(Color blue).

	top open
									[exEnd]



      non-string (text) entries:
									[exBegin]
	|top list l|

	top := StandardSystemView new.
	top extent:100@200.

	l := ListView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.
	list := #('all' 'of' 'your' 'preferred' 'colors')
		with:#(red green blue 'orange' cyan)
		collect:[:s :clr |
			    Text string:s
				 emphasis:(Array with:#bold
						 with:(#color->(Color name:clr))) ].
	l list:list.

	top open
									[exEnd]



      generic non-string entries:
      (notice: ColoredListEntry is obsoleted by Text)
									[exBegin]
	|top list l|

	top := StandardSystemView new.
	top extent:100@200.

	l := ListView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.
	list := #('all' 'of' 'your' 'preferred' 'colors')
		with:#(red green blue 'orange' cyan)
		collect:[:s :clr | ColoredListEntry string:s color:(Color name:clr) ].
	l list:list.

	top open
									[exEnd]



      using a model (default listMessage is aspectMessage):
									[exBegin]
	|top model l theModelsText|

	model := Plug new.
	model respondTo:#modelsAspect
		   with:[ theModelsText ].

	top := StandardSystemView new.
	top extent:100@200.

	l := ListView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.
	l model:model.
	l aspect:#modelsAspect.

	top open.

	Delay waitForSeconds:3.
	theModelsText := #('foo' 'bar' 'baz').
	model changed:#modelsAspect.
									[exEnd]



      using a model with different aspects
      for two listViews:
									[exBegin]
	|top model l1 l2 plainText|

	plainText := #('').

	model := Plug new.
	model respondTo:#modelsUppercaseText
		   with:[ plainText asStringCollection
			      collect:[:l | l asUppercase]].
	model respondTo:#modelsLowercaseText
		   with:[ plainText asStringCollection
			      collect:[:l | l asLowercase]].

	top := StandardSystemView extent:200@200.

	l1 := ListView origin:0.0 @ 0.0 corner:1.0 @ 0.5 in:top.
	l1 model:model.
	l1 aspect:#modelsAspect.
	l1 listMessage:#modelsUppercaseText.

	l2 := ListView origin:0.0 @ 0.5 corner:1.0 @ 1.0 in:top.
	l2 model:model.
	l2 aspect:#modelsAspect.
	l2 listMessage:#modelsLowercaseText.

	top open.

	Delay waitForSeconds:3.
	plainText := #('foo' 'bar' 'baz').
	model changed:#modelsAspect.
									[exEnd]

      using a big list (100000 lines),
      wrapping in a ScrollableView:
									[exBegin]
	|bigList top lv|

	bigList := (1 to:100000) collect:[:lineNr | 'List line Nr. ' , lineNr printString].
	bigList at:10 put:('Some Text ' asText , 'with Bold part' allBold).
	bigList at:20 put:('Some Text ' asText , 'with Italic part' allItalic).

	top := StandardSystemView extent:200@200.

	lv := HVScrollableView for:ListView in:top.
	lv origin:0.0 @ 0.0 corner:1.0 @ 1.0.
	lv list:bigList expandTabs:false scanForNonStrings:false includesNonStrings:false.

	top open.
									[exEnd]

      using a huge virtual list (1 mio simulated lines),
      wrapping in a ScrollableView:
									[exBegin]
	|virtualList top lv|

	virtualList := Plug new.
	virtualList inheritFrom:SequenceableCollection.
	virtualList respondTo:#size with:[ 1000000 ].
	virtualList respondTo:#at:  with:[:lineNr | 'List line Nr. ' , lineNr printString ].

	top := StandardSystemView extent:200@200.

	lv := ScrollableView for:ListView in:top.
	lv origin:0.0 @ 0.0 corner:1.0 @ 1.0.
	lv list:virtualList expandTabs:false scanForNonStrings:false includesNonStrings:false.

	top open.
									[exEnd]


      using a huge virtual array (1 mio simulated lines),
      wrapping in a ScrollableView.
      To simulate an expensive computation, a delay is planted into the line generator;
      Startup and display of page full of lines should not take longer than the number of lines shown:
									[exBegin]
	|virtualList top lv|

	virtualList := VirtualArray new.
	virtualList
	    setSize:1000000;
	    generator:[:index | Transcript showCR:index.
				Delay waitForSeconds:0.5.
				'%1 -> %2' bindWith:index with:index squared].

	top := StandardSystemView extent:200@200.

	lv := ScrollableView for:ListView in:top.
	lv origin:0.0 @ 0.0 corner:1.0 @ 1.0.
	lv expandTabsWhenUpdating:false.
	lv checkLineEndConventionWhenUpdating:false.
	lv checkedLinesForWidthOfContentsComputation:-1.
	lv list:virtualList.

	top open.
									[exEnd]
"
! !

!ListView class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    "/ DefaultForegroundColor := nil.
    "/ DefaultBackgroundColor := nil.
    DefaultTabPositions := self tab4Positions.
    "/ UserDefaultTabPositions := nil.
    "/ DefaultLeftMargin := nil.
    "/ DefaultTopMargin := nil.

    "Modified: / 22-04-2016 / 20:42:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ListView class methodsFor:'accessing private classes'!

searchSpec
    ^ SearchSpec
! !

!ListView class methodsFor:'defaults'!

defaultTabPositions
    "return an array containing the styleSheets default tab positions"

    ^ DefaultTabPositions ? self tab4Positions
!

defaultTabPositions:aVector
    "set the array containing the styleSheets tab positions"

    DefaultTabPositions := aVector

    "
     ListView defaultTabPositions:(ListView tab4Positions)
    "
!

tab4Positions
    "return an array containing tab positions for 4-col tabs"

    ^ #(1 5 9 13 17 21 25 29 33 37 41 45 49 53 57 61 65 69 73 77 81
	85 89 93 97 101 105 109 113 114 121 125 129 133 137 141 145)
!

tab8Positions
    "return an array containing tab positions for 8-col tabs"

    ^ #(1 9 17 25 33 41 49 57 65 73 81 89 97 105 113 121 129 137 145)
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'text.foregroundColor' #'text.backgroundColor'
		       #'text.tabPositions'
		       #'text.font')>

    DefaultForegroundColor := StyleSheet colorAt:'text.foregroundColor' default:Color black.
    DefaultBackgroundColor := StyleSheet colorAt:'text.backgroundColor' default:Color white.
    DefaultFont := StyleSheet fontAt:'text.font'.
    "/ that's not style, but a personal setting
    "/ DefaultTabPositions := StyleSheet at:'text.tabPositions'.
    "/ DefaultTabPositions isNil ifTrue:[DefaultTabPositions := self defaultTabPositions].
    DefaultLeftMargin := 0.5.
    DefaultTopMargin := 0.5.

    "Modified: / 31-03-2016 / 10:49:45 / cg"
!

userDefaultTabPositions
    "return an array containing the users default tab positions"

    ^ UserDefaultTabPositions
!

userDefaultTabPositions:aVector
    "set the array containing the users tab positions"

    UserDefaultTabPositions := aVector

    "
     self userDefaultTabPositions:(self tab4Positions)
    "
! !

!ListView methodsFor:'accessing'!

innerHeight
    "return the number of pixels visible of the contents
     - redefined since ListView adds another margin to start the text
     somewhat to indented from the 3D border."

    ^ height - (2 * margin) - topMargin
! !

!ListView methodsFor:'accessing-behavior'!

checkLineEndConventionWhenUpdating
    "return the line-end convention check when updating behavior.
     If true (the default), the first line of the list given is checked for having a
     cr-lf line end (which is a DOS convention), and the lineEndCRLF flag is set dynamically.
     If false, the lineEndCRLF remains as specified by the user.
     You may want to disable this flag if it is very expensive to generate a line
     (although, only the very first line is checked, anyway)"

    ^ checkLineEndConventionWhenUpdating
!

checkLineEndConventionWhenUpdating:aBoolean
    "define the line-end convention check when updating behavior.
     If true (the default), the first line of the list given is checked for having a
     cr-lf line end (which is a DOS convention), and the lineEndCRLF flag is set dynamically.
     If false, the lineEndCRLF remains as specified by the user.
     You may want to disable this flag if it is very expensive to generate a line
     (although, only the very first line is checked, anyway)"

    checkLineEndConventionWhenUpdating := aBoolean
!

checkedLinesForWidthOfContentsComputation
    "return how many and which lines to consider in the widthOfContents computation,
     which is needed by the scrollBar interface.
     If nil (the default), all lines are processed and the width of the longest line is taken.
     If positive, that number of lines is checked near the start of the text,
     if negative, from the end of the text.
     If 0, the width is dynamically re adjusted, as lines are drawn.
     You may want to change this to 1 if it is guaranteed that all linesa are of the same width,
     or -1, if all are shorter than the last line.
     (useful, for example, when it is very expensive to generate all lines, and a huge number
     of same-width lines is generated through a virtual array)"

    ^ checkedLinesForWidthOfContentsComputation
!

checkedLinesForWidthOfContentsComputation:aNumberOrNil
    "set how many and which lines to consider in the widthOfContents computation,
     which is needed by the scrollBar interface.
     If nil (the default), all lines are processed and the width of the longest line is taken.
     If positive, that number of lines is checked near the start of the text,
     if negative, from the end of the text.
     If 0, the width is dynamically re adjusted, as lines are drawn.
     You may want to change this to 1 if it is guaranteed that all linesa are of the same width,
     or -1, if all are shorter than the last line.
     (useful, for example, when it is very expensive to generate all lines, and a huge number
     of same-width lines is generated through a virtual array)"

    checkedLinesForWidthOfContentsComputation := aNumberOrNil
!

compareModelWhenUpdating
    "return the compare when updating behavior.
     If true (the default), the list of lines as given due to a model update
     is processed and compared against the currently shown text.
     If they are the same, no action is taken.
     This behavior is ok in 99.99% of all applications.
     However, you may turn this off iff:
	- it is very expensive to process the list (for example, because the list
	  is defined by a virtual array, which computes the lines dynamically, on
	  the fly).
     One use where this flag should be turned off is in the hex-memory display,
     which is able to simulate texts with millions of lines, but they are actually
     simulated by generating the presented lines dynamically, as they are displayed."

    ^ compareModelOnUpdate
!

compareModelWhenUpdating:aBoolean
    "define the compare when updating behavior.
     If true (the default), the list of lines as given due to a model update
     is processed and compared against the currently shown text.
     If they are the same, no action is taken.
     This behavior is ok in 99.99% of all applications.
     However, you may turn this off iff:
	- it is very expensive to process the list (for example, because the list
	  is defined by a virtual array, which computes the lines dynamically, on
	  the fly).
     One use where this flag should be turned off is in the hex-memory display,
     which is able to simulate texts with millions of lines, but they are actually
     simulated by generating the presented lines dynamically, as they are displayed."

    compareModelOnUpdate := aBoolean
!

expandTabsWhenUpdating
    "return the tab expansion behavior.
     If true (the default), the list of lines as given via #list: or
     due to a model update is processed and lines are replaced by lines with
     tabs expanded.
     This behavior is ok in 99.99% of all applications.
     However, you may turn this off iff:
        - you are certain, that no tabs are in the passed in list
        - it is very expensive to process the list (for example, because the list
          is defined by a virtual array, which computes the lines dynamically, on the fly).
     One use where this flag should be turned off is in the hex-memory display,
     which is able to simulate texts with millions of lines, but they are actually
     simulated by generating the presented lines dynamically, as they are displayed.
     Notice, that to totally prevent scanning og the whole text, you may have to turn off
     other flags, such as checkineEndConventionWhenUpdating"

    ^ expandTabsWhenUpdating
!

expandTabsWhenUpdating:aBoolean
    "define the tab expansion behavior.
     If true (the default), the list of lines as given via #list: or
     due to a model update is processed and lines are replaced by lines with
     tabs expanded.
     This behavior is ok in 99.99% of all applications.
     However, you may turn this off iff:
        - you are certain, that no tabs are in the passed in list
        - it is very expensive to process the list (for example, because the list
          is defined by a virtual array, which computes the lines dynamically, on the fly).
     One use where this flag should be turned off is in the hex-memory display,
     which is able to simulate texts with millions of lines, but they are actually
     simulated by generating the presented lines dynamically, as they are displayed.
     Notice, that to totally prevent scanning og the whole text, you may have to turn off
     other flags, such as checkineEndConventionWhenUpdating"

    expandTabsWhenUpdating := aBoolean
!

lineEndCRLF
    "answer true, if CRLF is used for the line end.
     This is true for DOS/Windows files.
     Otherwise 'Character cr' is the line end (which is LF in unix)"

    ^ lineEndCRLF ? false

    "Created: / 04-07-2006 / 19:05:01 / fm"
!

scrollWhenUpdating
    "return the scroll behavior, when I get a new text
     (via the model or the #contents/#list)
     Possible returnValues are:
	#keep / nil     -> no change
	#endOfText      -> scroll to the end
	#beginOfText    -> scroll to the top
     The default is #keep.
     This may be useful for fields which get new values assigned from
     the program (i.e. not from the user)"

    ^ scrollWhenUpdating
!

scrollWhenUpdating:aSymbolOrNil
    "define how to scroll, when I get a new text
     (via the model or the #contents/#list)
     Allowed arguments are:
	#keep / nil     -> no change
	#endOfText      -> scroll to the end
	#beginOfText    -> scroll to the top
     The default is #keep.
     This may be useful for fields which get new values assigned from
     the program (i.e. not from the user)"

    scrollWhenUpdating := aSymbolOrNil
!

wordCheckBlock:aBlock
    "set the word-check block - this block is called with a character argument,
     when the end/beginning of a word is searched.
     It should return true, if the character belongs to the word.
     The default block is set in #initialize, and returns true for alphanumeric
     (national) characters.
     Applications may change it to include underlines, dollars or other characters.
     (a C/C++ editor would include underlines ...)"

    wordCheck := aBlock.

    "Modified: 22.5.1996 / 12:26:55 / cg"
! !

!ListView methodsFor:'accessing-contents'!

add:aString
    "add a line and redisplay"

    |fontHeightBefore|

    list isNil ifTrue:[list := OrderedCollection new].
    list add:aString.

    includesNonStrings ifFalse:[
	includesNonStrings := (aString notNil and:[(aString isSingleByteString) not]).
	includesNonStrings ifTrue:[
	    fontHeightBefore := fontHeight.
	    self getFontParameters.
	    fontHeightBefore ~~ fontHeight ifTrue:[
		self invalidate
	    ].
	].
    ].

    widthOfWidestLine notNil ifTrue:[
	self recomputeWidthOfWidestLineFor:aString old:nil.
    ].

    shown ifTrue:[
	self redrawLine:(self size).
    ].
    self enqueueDelayedContentsChangedNotification.             "recompute scrollbars"

    "Modified: / 25-07-2012 / 12:00:20 / cg"
!

add:aString beforeIndex:index
    "add a line and redisplay"

    |lastShown|

    list isNil ifTrue:[list := OrderedCollection new].
    list add:aString beforeIndex:index.

    widthOfWidestLine notNil ifTrue:[
	self recomputeWidthOfWidestLineFor:aString old:nil.
    ].

    includesNonStrings ifFalse:[
	includesNonStrings := (aString notNil and:[(aString isSingleByteString) not]).
"/        includesNonStrings ifTrue:[self getFontParameters].
    ].
    shown ifTrue:[
	lastShown := self lastLineShown.
	index <= 2 ifTrue:[
	    self invalidate
	] ifFalse:[
	    index to:lastShown do:[:eachLine |
		self invalidateLine:eachLine
	    ].
	].
    ].
    self enqueueDelayedContentsChangedNotification.  "recompute scrollbars"

    (scrollWhenUpdating == #end or:[scrollWhenUpdating == #endOfText]) ifTrue:[
	"/ self selection isNil ifTrue:[
	    self scrollToBottom.
	"/ ]
    ].

    "Modified: / 25-07-2012 / 12:00:42 / cg"
!

addAll:aCollectionOfLines beforeIndex:index
    "add a bunch of lines and redisplay"

    |lastShown|

    list isNil ifTrue:[list := OrderedCollection new].
    aCollectionOfLines do:[:eachLine |
	list addAll:aCollectionOfLines beforeIndex:index.
    ].
    includesNonStrings ifFalse:[
	includesNonStrings :=
	    aCollectionOfLines
		contains:[:someLine |
		    someLine notNil and:[(someLine isSingleByteString) not].
		]
    ].

    widthOfWidestLine notNil ifTrue:[
	aCollectionOfLines do:[:eachLine |
	    self recomputeWidthOfWidestLineFor:eachLine old:nil.
	].
    ].
"/    widthOfWidestLine := nil. "/ i.e. unknown
    self textChanged.

    shown ifTrue:[
	lastShown := self lastLineShown.
	((index-1) <= lastShown) ifTrue:[
	    index <= 2 ifTrue:[
		self invalidate
	    ] ifFalse:[
		index-1 to:lastShown do:[:eachLine |
		    self invalidateLine:eachLine
		].
		"/  self redrawFromLine:index-1.
	    ].
	].
    ].
    self enqueueDelayedContentsChangedNotification.  "recompute scrollbars"

    (scrollWhenUpdating == #end or:[scrollWhenUpdating == #endOfText]) ifTrue:[
	"/ self selection isNil ifTrue:[
	    self scrollToBottom.
	"/ ]
    ].

    "Modified: / 25-07-2012 / 12:00:54 / cg"
!

at:lineNr
    "retrieve a line; return nil if beyond end-of-text.
     this allows textViews to be used like collections in some places."

    list isNil ifTrue:[^ nil].
    (lineNr between:1 and:self size) ifFalse:[^ nil].
    ^ list at:lineNr
!

at:index put:aString
    "change a line and redisplay"

    |fontHeightBefore widthBefore|

    fontHeightBefore := fontHeight.
    widthBefore := widthOfWidestLine.
    self withoutRedrawAt:index put:aString.

    shown ifTrue:[
	fontHeightBefore ~= fontHeight ifTrue:[
	    "/ must redraw everything
	    self invalidate.
	    ^ self
	].
	self redrawLine:index.

"/ the code below is wrong - we really have to redraw everything, if the
"/ fontHeight changes (due to a labelAndIcon in the list).


"/        "/ this could have changed the font height;
"/        "/ must clear all below last line, if it became smaller
"/        fontHeightBefore > fontHeight ifTrue:[
"/            (self listLineIsVisible:(self size)) ifTrue:[
"/                self clearRectangle:(margin @ (self yOfVisibleLine:nLinesShown+1))
"/                                    corner:(width-margin) @ (height-margin).
"/            ].
"/            self redrawFromLine:index
"/        ] ifFalse:[
"/            self redrawLine:index
"/        ].

	"/ asynchronous:
"/        visibleLine := self listLineToVisibleLine:index.
"/        visibleLine notNil ifTrue:[
"/            y := self yOfVisibleLine:visibleLine.
"/            self invalidate:((margin @ y) extent:(width@fontHeight))
"/        ].

	widthBefore ~~ widthOfWidestLine ifTrue:[
	    self enqueueDelayedContentsChangedNotification
	]
    ]

    "Modified: / 25-07-2012 / 12:01:46 / cg"
!

characterAtCharacterPosition:charPos
    "return the character at a 1-based character position.
     Return a space character if nothing is there
     (i.e. beyond the end of the line or below the last line)"

    |line col|

    line := self lineOfCharacterPosition:charPos.
    col := charPos - (self characterPositionOfLine:line col:1) + 1.
    col == 0 ifTrue:[^ Character cr].
    ^ self characterAtLine:line col:col
!

characterAtLine:lineNr col:colNr
    "return the character at physical line/col.
     The lineNr and colNr arguments start at 1, for the top-left cgaracter.
     Return a space character if nothing is there
     (i.e. beyond the end of the line or below the last line)"

    |line|

    list notNil ifTrue:[
	line := self listAt:lineNr.
	line notNil ifTrue:[
	    (line size >= colNr) ifTrue:[
		^ line at:colNr
	    ]
	]
    ].
    ^ Character space

    "Created: 29.4.1996 / 12:11:00 / cg"
    "Modified: 29.4.1996 / 12:12:41 / cg"
!

contents
    "return the contents as a string, terminated by the line end character (sequence)"

    |stringCollection lineEnd|

    list isNil ifTrue:[^ ''].

    self lineEndCRLF ifTrue:[
	lineEnd := String crlf.
    ] ifFalse:[
	lineEnd := Character cr.
    ].

    stringCollection := list asStringCollection.
    ^ stringCollection
	asStringWith:lineEnd
	from:1 to:stringCollection size
	compressTabs:false
	final:lineEnd

    "Modified: / 04-07-2006 / 19:18:47 / fm"
!

contents:something
    "set the contents (either a String or a Collection of strings)
     also scroll to top. See #setContents:, which does not scroll.
     If the argument is a string, it is converted
     to a collection of line-strings here."

    |l|

    l := something.
    l notNil ifTrue:[
	l isString ifTrue:[
	    l := l asStringCollection
	]
    ].
    self list:l

    "Modified: 5.6.1997 / 11:11:54 / cg"
!

from:from to:to do:aBlock
    "evaluate aBlock on some of my lines"

    list from:from to:to do:aBlock.
!

grow:n
    "grow our list"

    ^ list grow:n.
!

lineAtY:y
    "return the lineNr for a given y-(view-)coordinate"

    |visibleLine|

    visibleLine := self visibleLineOfY:y.
    visibleLine isNil ifTrue:[^ nil].
    ^ self visibleLineToListLine:visibleLine.
!

list
    "return the contents as a collection of strings.
     This returns the view's internal list - modifying it may confuse
     the listView."

    ^ list

    "Modified: 5.6.1997 / 11:10:54 / cg"
!

list:aCollection
    "set the contents (a collection of strings or list entries)
     and scroll as specified in scrollWhenUpdating (default:top-left).
     See also #setList:, which does not scroll.
     Tabs are expanded (to spaces).
     The passed list is scanned for nonStrings
     (remembered to optimize later redraws)."

    self list:aCollection expandTabs:expandTabsWhenUpdating

    "Modified: 5.6.1997 / 11:10:45 / cg"
!

list:aCollection expandTabs:expand
    "set the contents (a collection of strings)
     and scroll as specified in scrollWhenUpdating (default:top-left).
     If expand is true, tabs are expanded (to spaces).
     The passed list is scanned for nonStrings (remembered to optimize
     later redraws)."

    self list:aCollection expandTabs:expand scanForNonStrings:true

    "Modified: 5.6.1997 / 11:09:44 / cg"
!

list:aCollection expandTabs:expand scanForNonStrings:scan
    "set the contents (a collection of strings)
     and scroll as specified in scrollWhenUpdating (default:top-left).
     If expand is true, tabs are expanded (to spaces).
     If scan is true, scan the passed list for nonStrings; otherwise,
     assume that it does contain non-strings
     (remembered to optimize later redraws)."

    self
	list:aCollection expandTabs:expand scanForNonStrings:scan includesNonStrings:nil

    "Modified: 5.6.1997 / 12:40:35 / cg"
!

list:aCollection expandTabs:expand scanForNonStrings:scan includesNonStrings:nonStringsIfNoScan
    "set the contents (a collection of strings)
     and scroll as specified in scrollWhenUpdating (default:top-left).
     If expand is true, tabs are expanded (to spaces).
     If scan is true, scan the passed list for nonStrings;
     otherwise, take the information from the nonStrings arg.
     (the nonStrings information is remembered to optimize later redraws & height computations)."

    self
	list:aCollection
	expandTabs:expand
	scanForNonStrings:scan
	includesNonStrings:nonStringsIfNoScan
	redraw:true
!

list:aCollection expandTabs:expand scanForNonStrings:scan includesNonStrings:nonStringsIfNoScan redraw:doRedraw
    "set the contents (a collection of strings)
     and scroll as specified in scrollWhenUpdating (default:top-left).
     If expand is true, tabs are expanded (to spaces).
     If scan is true, scan the passed list for nonStrings;
     otherwise, take the information from the nonStrings arg.
     (the nonStrings information is remembered to optimize later redraws & height computations)."

    |oldFirst oldLeft nonStringsBefore fontHeightBefore
     scrollToEnd scrollToTop newLeftOffset wText same firstLine|

    "/ cg: what is the point in comparing here?
    "/ I think, if there is something to optimize,
    "/ the caller should do so (moved to getListFromModel).
    "/ notice, that it may be very expensive to ask aCollection for each line
    "/ for example, iff the lines are generated on the fly by an algorithm
    false ifTrue:[
	"/ see if there is a change at all.
	"/ use to compare using =, but that's not enough in case of emphasis change.
	aCollection size == list size ifTrue:[
	    same := true.
	    aCollection size > 0 ifTrue:[
		aCollection with:list do:[:eachNewLine :eachOldLine |
		    (eachNewLine == eachOldLine)
		    ifFalse:[
			same := false.
		    ]
		]
	    ].
	    same ifTrue:[^ self].
	].
    ].

    scrollToTop := scrollWhenUpdating == #begin or:[scrollWhenUpdating == #beginOfText].
    scrollToEnd := scrollWhenUpdating == #end or:[scrollWhenUpdating == #endOfText].

    (aCollection isEmptyOrNil and:[list isEmptyOrNil]) ifTrue:[
	"no contents change"
	list := aCollection.
	scrollLocked ifFalse:[
	    scrollToTop ifTrue:[
		self scrollToTop.
	    ] ifFalse:[
		scrollToEnd ifTrue:[
		    self scrollToBottom.
		]
	    ].
	    self scrollToLeft.
	].
	^ self
    ].

    checkLineEndConventionWhenUpdating ifTrue:[
	"Check if the we use DOS/Windows line end convention with CR LF.
	 The LF has already been consumed by the conversion to a StringCollection,
	 now check for and remove the trailing left over CRs"

	lineEndCRLF := (aCollection size > 0
			and:[(firstLine := aCollection at:1) isString
			and:[firstLine notEmpty
			and:[firstLine string endsWith:Character return]]]).
    ].
    lineEndCRLF ifTrue:[
	list := aCollection
		    collect:[:eachLineWithCROrNil |
			eachLineWithCROrNil isNil
			    ifTrue:nil
			    ifFalse:[(eachLineWithCROrNil endsWith:Character return)
				     ifTrue:[eachLineWithCROrNil copyButLast:1]
				     ifFalse:[eachLineWithCROrNil]]].
    ] ifFalse:[
	list := aCollection.
    ].

    nonStringsBefore := includesNonStrings.
    fontHeightBefore := fontHeight.
    includesNonStrings := false.

    list notNil ifTrue:[
	expand ifTrue:[
	    self expandTabs
	] ifFalse:[
	    scan ifTrue:[
		includesNonStrings := list contains:[:e | e isString not].
	    ] ifFalse:[
		includesNonStrings := nonStringsIfNoScan ? nonStringsBefore
	    ]
	].
    ].
    (includesNonStrings ~~ nonStringsBefore) ifTrue:[
	self getFontParameters.
    ].

    widthOfWidestLine := nil.   "/ i.e. unknown
    oldFirst := firstLineShown.
    oldLeft := viewOrigin x.

    (includesNonStrings ~~ nonStringsBefore) ifTrue:[
	self computeNumberOfLinesShown.
    ].

    scrollLocked ifFalse:[
	newLeftOffset := viewOrigin x.
	scrollToTop ifTrue:[
	    firstLineShown := 1.
	    newLeftOffset := 0.
	] ifFalse:[
	    scrollToEnd ifTrue:[
		firstLineShown := (list size - nFullLinesShown + 1) max:1.
		newLeftOffset := 0.
	    ]
	].
	newLeftOffset > 0 ifTrue:[
	    wText := self widthOfContents.
	    (viewOrigin x + self innerWidth) > wText ifTrue:[
		newLeftOffset := (wText - self innerWidth) max:0.
	    ].
	].
	newLeftOffset ~= oldLeft ifTrue:[
	    viewOrigin := newLeftOffset @ viewOrigin y.
	].
    ].

    realized ifTrue:[
	self contentsChanged.
	scrollLocked ifFalse:[
	    "
	     don't use scroll here to avoid double redraw
	    "
	    viewOrigin := viewOrigin isNil ifTrue:[0@0] ifFalse:[(viewOrigin x) @ 0].
	    gc transformation:nil.

	    oldFirst ~~ firstLineShown ifTrue:[
		self originChanged:0 @ ((oldFirst - 1) * fontHeight negated).
	    ].
	].
	doRedraw ifTrue:[
	    shown ifTrue:[
		self invalidate.
	    ]
	]
    ]

    "Modified: / 30-08-1995 / 19:07:13 / claus"
    "Created: / 05-06-1997 / 12:40:06 / cg"
    "Modified: / 04-07-2006 / 19:12:39 / fm"
    "Modified: / 22-08-2006 / 11:59:56 / cg"
!

listAt:lineNr
    "given a lineNumber, return the corresponding string
     This is used for accessing; i.e. for non-string entries, this
     returns the corresponding string."

    |l|

    list isNil ifTrue:[^ nil].
    (lineNr between:1 and:self size) ifFalse:[^ nil].
    l := self at:lineNr.
    l isNil ifTrue:[^ l].
    ^ self visibleStringFrom:l "/ l asString

    "Modified: 7.9.1995 / 15:54:59 / claus"
!

removeFromIndex:startLineNr toIndex:endLineNr
    "delete some lines"

    |nLines widestLineRemoved|

    list isNil ifTrue:[^ self].

    widestLineRemoved := self widthOfWidestLineBetween:startLineNr and:endLineNr.
    list removeFromIndex:startLineNr toIndex:(endLineNr min:list size).

    widthOfWidestLine == widestLineRemoved ifTrue:[
	widthOfWidestLine := nil. "/ i.e. unknown
    ].
    self textChanged.

    ((startLineNr <= self lastLineShown)
    and:[endLineNr >= firstLineShown]) ifTrue:[
	startLineNr to:self lastLineShown do:[:eachLine |
	    self invalidateLine:eachLine
	].
    ].

    nLines := list size.
    (firstLineShown >= nLines) ifTrue:[
	self makeLineVisible:nLines
    ].
    self enqueueDelayedContentsChangedNotification.

    "Modified: / 25-07-2012 / 12:01:59 / cg"
!

removeIndex:lineNr
    "delete a line, redraw the view"

    |visLine w h x
     srcY "{ Class: SmallInteger }" |

    (self removeIndexWithoutRedraw:lineNr) ifFalse:[^ self].

    "
     is there a need to redraw ?
    "
    shown ifFalse:[^ self].
    visLine := self listLineToVisibleLine:lineNr.
    visLine notNil ifTrue:[
	w := self widthForScrollBetween:lineNr and:(firstLineShown + nLinesShown).
"/        x := textStartLeft.
"/ CLAUS fixes leftOver selection pixels
	w := w + leftMargin.
	x := margin.

	srcY := topMargin + (visLine * fontHeight).
"/        h := ((nLinesShown - visLine) * fontHeight).
	h := (height - margin - srcY).
	h > 0 ifTrue:[
	    self catchExpose.
	    self
		copyFrom:self
		x:x y:srcY
		toX:x y:(srcY - fontHeight)
		width:w height:h
		async:true.
	].
	self redrawVisibleLine:nFullLinesShown.
	"
	 redraw last partial line - if any
	"
	(nFullLinesShown ~~ nLinesShown) ifTrue:[
	    self redrawVisibleLine:nLinesShown
	].
	h > 0 ifTrue:[
	    self waitForExpose
	].
    ]

    "Modified: / 27.2.1998 / 12:36:59 / cg"
!

removeIndexWithoutRedraw:lineNr
    "delete a line, given its lineNr - no redraw;
     return true, if something was really deleted (so sender knows,
     if a redraw is needed)"

    (list isNil or:[lineNr > self size]) ifTrue:[^ false].
    list removeIndex:lineNr.

    lineNr < firstLineShown ifTrue:[
	firstLineShown := firstLineShown - 1
    ].
    self enqueueDelayedContentsChangedNotification.
    ^ true

    "Modified: / 25-07-2012 / 12:02:09 / cg"
!

replaceFrom:startLineNr to:endLineNr with:aCollection startingAt:replStartIndex
    "replace some lines"

    list isNil ifTrue:[
	list := OrderedCollection new.
    ].
    list replaceFrom:startLineNr to:endLineNr with:aCollection startingAt:replStartIndex.

    widthOfWidestLine := nil. "/ i.e. unknown
    self textChanged.

    ((startLineNr <= self lastLineShown)
    and:[endLineNr >= firstLineShown]) ifTrue:[
	self invalidate.
    ].

    self enqueueDelayedContentsChangedNotification.

    "Modified: / 25-07-2012 / 12:02:15 / cg"
!

setContents:something
    "set the contents (either a string or a Collection of strings)
     don't change position (i.e. do not scroll).
     This can be used to update a self-changing list
     (for example: a file list being shown, without disturbing user too much).
     Compare with #contents:, which scrolls to top."

    |l|

    l := something.
    l notNil ifTrue:[
        l isString ifTrue:[
            l := l asStringCollection
        ]
    ].
    self setList:l.

    "Modified: 18.12.1995 / 22:20:43 / stefan"
!

setList:aCollection
    "set the contents (a collection of strings);
     do not change position (i.e. do not scroll).
     This can be used to update a self-changing list
     (for example: a file list being shown, without disturbing user too much)"

    ^ self setList:aCollection expandTabs:true
!

setList:aCollection expandTabs:expandTabs
    "set the contents (a collection of strings);
     do not change position (i.e. do not scroll).
     This can be used to update a self-changing list
     (for example: a file list being shown, without disturbing the user too much)"

    self setList:aCollection expandTabs:expandTabs redraw:true

    "Modified: / 22.4.1998 / 11:12:24 / cg"
!

setList:aCollection expandTabs:expandTabs redraw:doRedraw
    "set the contents (a collection of strings);
     do not change position (i.e. do not scroll).
     This can be used to update a self-changing list
     (for example: a file list being shown, without disturbing the user too much)"

    self
	setList:aCollection expandTabs:expandTabs scanForNonStrings:true includesNonStrings:nil
	redraw:doRedraw
!

setList:aCollection expandTabs:expandTabs scanForNonStrings:scan includesNonStrings:nonStringsIfNoScan redraw:doRedraw
    "set the contents (a collection of strings);
     do not change position (i.e. do not scroll).
     This can be used to update a self-changing list
     (for example: a file list being shown, without disturbing the user too much).
    TODO: this stinks: most of the code is the same as in #list:expandTabs:...
	  needs a refactoring"

    |prev|

    prev := scrollLocked.
    [
	scrollLocked := false.
	self
	    list:aCollection
	    expandTabs:expandTabs
	    scanForNonStrings:scan
	    includesNonStrings:nonStringsIfNoScan
	    redraw:doRedraw
    ] ensure:[
	scrollLocked := prev
    ].
"/
"/
"/"/                scrollLocked ifTrue:[
"/"/                    self setList:newText expandTabs:expandTabsWhenUpdating
"/"/                ] ifFalse:[
"/                    self list:newText expandTabs:expandTabsWhenUpdating scanForNonStrings:expandTabsWhenUpdating
"/"/                ]
"/
"/    |oldFirst nonStringsBefore|
"/
"/    (aCollection isNil and:[list isNil]) ifTrue:[
"/        "no change"
"/        ^ self
"/    ].
"/
"/    list := aCollection.
"/
"/    nonStringsBefore := includesNonStrings.
"/    includesNonStrings := false.
"/
"/    list notNil ifTrue:[
"/        expandTabs ifTrue:[
"/            self expandTabs
"/        ] ifFalse:[
"/            scan ifTrue:[
"/                includesNonStrings := (list findFirst:[:e | e isString not]) ~~ 0.
"/            ] ifFalse:[
"/                includesNonStrings := nonStringsIfNoScan ? nonStringsBefore
"/            ]
"/        ].
"/    ].
"/    (includesNonStrings ~~ nonStringsBefore) ifTrue:[
"/        self getFontParameters.
"/        self computeNumberOfLinesShown.
"/    ].
"/
"/    "/ new: reposition horizontally if too big
"/    widthOfWidestLine := nil.   "/ i.e. unknown
"/    innerWidth >= self widthOfContents ifTrue:[
"/        viewOrigin := 0 @ viewOrigin y.
"/    ].
"/    self contentsChanged.
"/
"/    "/ new: reposition vertically if too big
"/    (firstLineShown + nFullLinesShown) > self size ifTrue:[
"/        oldFirst := firstLineShown.
"/        firstLineShown := self size - nFullLinesShown + 1.
"/        firstLineShown < 1 ifTrue:[firstLineShown := 1].
"/        oldFirst ~= firstLineShown ifTrue:[
"/            viewOrigin y:((firstLineShown - 1) * fontHeight).
"/            self originChanged:0 @ ((oldFirst - 1) negated * fontHeight).
"/            shown ifTrue:[
"/                self clearView.
"/            ]
"/        ]
"/    ].
"/
"/    (shown and:[doRedraw]) ifTrue:[
"/        self invalidate
"/        "/ self redrawFromVisibleLine:1 to:nLinesShown
"/    ]
"/
"/    "Modified: / 18.12.1995 / 23:27:54 / stefan"
"/    "Created: / 22.4.1998 / 11:11:51 / cg"
"/    "Modified: / 26.7.1998 / 13:46:49 / cg"
!

size
    "return the size (i.e. number of lines)
     this allows textViews to be used like collections in some places."

    ^ list size.
!

stringAtLine:lineNr from:col1 to:col2
    "return the substring starting at physical line/col1, up-to and
     including col2.
     The lineNr and colNr arguments start at 1, for the top-left character.
     Fills the string with space characters at the right.
     (i.e. beyond the end of the line or below the last line)"

    |line len s|

    len := col2 - col1 + 1.
    list notNil ifTrue:[
	line := self listAt:lineNr.
	line notNil ifTrue:[
	    (line size >= col1) ifTrue:[
		s := line copyFrom:col1.
		s size < len ifTrue:[
		    ^ s paddedTo:len
		].
		^ s copyTo:len
	    ]
	]
    ].
    ^ String new:len withAll:Character space

    "Created: 7.1.1997 / 19:58:43 / cg"
!

textFromCharacterPosition:charPos1 to:charPos2
    "return some text as a collection of (line-)strings."

    |line1 col1 line2 col2|

    line1 := self lineOfCharacterPosition:charPos1.
    col1 := charPos1 - (self characterPositionOfLine:line1 col:1) + 1.

    line2 := self lineOfCharacterPosition:charPos2.
    col2 := charPos2 - (self characterPositionOfLine:line2 col:1) + 1.

    ^ self textFromLine:line1 col:col1 toLine:line2 col:col2.
!

textFromLine:startLine col:startCol toLine:endLine col:endCol
    "return some text as a collection of (line-)strings."

    |text sz index last|

    startLine isNil ifTrue:[^ nil].
    endLine isNil ifTrue:[^ nil].

    (startLine == endLine) ifTrue:[
        "part of a line"
        ^ StringCollection with:(self listAt:startLine from:startCol to:endCol)
    ].

    sz := endLine - startLine + 1.
    sz < 1 ifTrue:[^ StringCollection new].

    text := StringCollection new:sz.

    "get 1st and last (possibly) partial lines"
    text at:1 put:(self listAt:startLine from:startCol).
    endCol == 0 ifTrue:[
        last := ''
    ] ifFalse:[
        last := self listAt:endLine to:endCol.
    ].
    text at:sz put:last.

    "get bulk of text"
    index := 2.
    (startLine + 1) to:(endLine - 1) do:[:lineNr |
        text at:index put:(self listAt:lineNr).
        index := index + 1
    ].
    ^ text

    "Created: / 22-02-2000 / 23:53:06 / cg"
!

withoutRedrawAt:index put:aString
    "change a line without redisplay and WITHOUT any sizeChange notifications.
     Somewhat dangerous, since scrollBars will not be informed about contents-changes.
     Use only if multiple lines are to be changed, and a sizeChanged is invoked by some other
     means at the end."

    |didIncludeNonStrings oldLine|

    self checkForExistingLine:index.

    oldLine := self listAt:index.
    list at:index put:aString.
    oldLine ~= aString ifTrue:[
	self textChanged
    ].

    didIncludeNonStrings := includesNonStrings.
    includesNonStrings ifFalse:[
	includesNonStrings := (aString notNil and:[(aString isSingleByteString) not]).
    ] ifTrue:[
	(aString isNil or:[(aString isSingleByteString)]) ifTrue:[
	    includesNonStrings := list contains:[:l | l notNil and:[(l isSingleByteString) not]].
	]
    ].

    includesNonStrings ~~ didIncludeNonStrings ifTrue:[
	self getFontParameters.
	self computeNumberOfLinesShown
    ].

    widthOfWidestLine notNil ifTrue:[
	self recomputeWidthOfWidestLineFor:aString old:oldLine.
    ].

    "Modified: / 26.7.1998 / 13:00:14 / cg"
! !

!ListView methodsFor:'accessing-look'!

backgroundColor
    "return the background color"

    ^ bgColor
!

backgroundColor:aColor
    "set the background color of the contents"

    bgColor ~~ aColor ifTrue:[
	bgColor := aColor.
	self viewBackground:bgColor.
	self invalidate "/ clear; redraw
    ]

    "Modified: 3.5.1997 / 10:27:40 / cg"
!

font:aFont
    "set the font for all shown text.
     Redraws everything.
     CAVEAT: with the addition of Text objects,
             this method is going to be obsoleted by a textStyle
             method, which allows specific control over
             normalFont/boldFont/italicFont parameters."

    aFont isNil ifTrue:[
        ^ self error:'nil font' mayProceed:true
    ].
    gc font ~~ aFont ifTrue:[
        preferredExtent := nil.
        widthOfWidestLine := nil. "/ i.e. unknown
        super font:aFont.
        self getFontParameters.
        realized ifTrue:[
            (gc font graphicsDevice == device) ifTrue:[
                self computeNumberOfLinesShown.
                shown ifTrue:[
                    self redrawFromVisibleLine:1 to:nLinesShown
                ]
            ].
            self enqueueDelayedContentsChangedNotification
        ]
    ]

    "Modified: / 25-07-2012 / 12:01:36 / cg"
!

fontHeight:pixels
    "set the lines height - that's the number of pixels,
     by which lines are vertically separated."

    fontHeight ~~ pixels ifTrue:[
	fontHeight := pixels.
    ]

    "Created: 17.4.1997 / 01:41:33 / cg"
!

foregroundColor
    "return the foreground color"

    ^ fgColor
!

foregroundColor:aColor
    "set the foreground color"

    fgColor ~~ aColor ifTrue:[
	fgColor := aColor.
	self invalidate
    ]

    "Modified: 29.5.1996 / 16:19:02 / cg"
!

foregroundColor:color1 backgroundColor:color2
    "set both foreground and background colors"

    ((fgColor ~~ color1) or:[bgColor ~~ color2]) ifTrue:[
	fgColor := color1.
	bgColor := color2.
	self invalidate
    ]

    "Modified: 29.5.1996 / 16:19:05 / cg"
!

innerHorizontalMargin
    "return the margin between the left border and the 1st col"

    ^ leftMargin

    "Created: 16.1.1996 / 19:28:23 / cg"
!

innerVerticalMargin
    "return the margin between the top border and the 1st line"

    ^ topMargin

    "Created: 16.1.1996 / 19:28:00 / cg"
!

leftMargin
    "return the margin to left of 1st col"

    ^ leftMargin
!

leftMargin:aNumber
    "set the margin between the left border and the 1st col"

    leftMargin := aNumber.
    textStartLeft := aNumber + margin.
    innerWidth := width - aNumber - margin

    "Modified: 28.2.1996 / 19:32:55 / cg"
!

level:aNumber
    "set the 3D level - caught here to update text-position variables
     (which avoids many computations later)"

    |newMargin|

    aNumber ~~ level ifTrue:[
	newMargin := aNumber abs.
	textStartLeft := leftMargin + newMargin.
	textStartTop := topMargin + newMargin.
	innerWidth := width - textStartLeft - newMargin.

	super level:aNumber.
    ]

    "Modified: 11.8.1997 / 02:59:15 / cg"
!

lineSpacing
    "get the lineSpacing - that's an additional number of pixels,
     by which lines are vertically separated."

    ^ lineSpacing
!

lineSpacing:pixels
    "set the lineSpacing - that's an additional number of pixels,
     by which lines are vertically separated."

    lineSpacing ~~ pixels ifTrue:[
	lineSpacing := pixels.
	self getFontParameters.
    ]

    "Modified: 22.5.1996 / 12:22:29 / cg"
!

partialLines:aBoolean
    "allow/disallow display of a last partial line"

    partialLines := aBoolean.
    self computeNumberOfLinesShown
!

topMargin:aNumber
    "set the margin between the top border and the 1st line"

    topMargin := aNumber.
    textStartTop := topMargin + margin.
!

viewBackground:aColor
    super viewBackground:aColor.
    self isTextView ifFalse:[
	self backgroundColor:aColor
    ].
! !

!ListView methodsFor:'accessing-mvc'!

addModelInterfaceTo:aDictionary
    "see comment in View>>modelInterface"

    super addModelInterfaceTo:aDictionary.
    aDictionary at:#listMessage put:listMsg
!

listMessage
    "return the listMsg selector;
     if non-nil, this is the message sent to the model (if any) to acquire
     a new text upon change of the aspect.
     This defaults to the aspect-selector."

    ^ listMsg
!

listMessage:aSymbol
    "ST-80 compatibility: set the listMsg selector;
     if non-nil, this will be sent to the model (if any) to acquire a
     new text upon change of the aspect.
     This defaults to the aspect-selector."

    listMsg := aSymbol.
!

model:aModel
    "define the receivers model, from which the text is
     to be acquired via list- or aspect-messages, whenever its aspect
     changes."

    super model:aModel.
    self getListFromModel

    "Created: 31.12.1996 / 14:56:43 / stefan"
!

on:aModel aspect:aspectSymbol
    "ST-80 compatibility"

    ^ self on:aModel aspect:aspectSymbol change:nil list:aspectSymbol menu:nil
!

on:aModel aspect:aspectSymbol change:changeSymbol
    "ST-80 compatibility"

    ^self on:aModel aspect:aspectSymbol change:changeSymbol list:aspectSymbol menu:nil
!

on:aModel aspect:aspectSymbol change:changeSymbol list:listSymbol menu:menuSymbol
    "ST-80 compatibility"

    aspectSymbol notNil ifTrue:[
	aspectMsg := aspectSymbol.
	listMsg isNil ifTrue:[
	    listMsg := aspectSymbol
	]
    ].
    listSymbol notNil ifTrue:[listMsg := listSymbol].
    changeSymbol notNil ifTrue:[changeMsg := changeSymbol].
    menuMsg := menuSymbol.
    self model:aModel.

    "Modified: 2.1.1997 / 16:11:16 / cg"
!

on:aModel aspect:aspectSymbol change:changeSymbol menu:menuSymbol
    "ST-80 compatibility"

    ^ self on:aModel aspect:aspectSymbol change:changeSymbol list:nil menu:menuSymbol
!

on:aModel aspect:aspectSymbol list:listSymbol menu:menuSymbol
    "ST-80 compatibility"

    ^ self on:aModel aspect:aspectSymbol change:nil list:listSymbol menu:menuSymbol
!

on:aModel aspect:aspectSymbol menu:menuSymbol
    "ST-80 compatibility"

    ^self on:aModel aspect:aspectSymbol change:nil list:aspectSymbol menu:menuSymbol
! !

!ListView methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    |idx|

    changedObject == model ifTrue:[
        model isList ifTrue:[
            list ~~ model ifTrue:[
                something == #at: ifTrue:[
                    idx := aParameter isCollection ifTrue:[aParameter at:1]
                                                  ifFalse:[aParameter].
                    ^ self at:aParameter put:(model at:idx).
                ].
                something == #insert: ifTrue:[
                    (list size + 1) >= aParameter ifTrue:[
                        ^ self add:(model at:aParameter) beforeIndex:aParameter
                    ].
                ].
                something == #remove: ifTrue:[
                    list size >= aParameter ifTrue:[
                        ^ self removeIndex:aParameter
                    ]
                ].
            ].
            self getListFromModel.
            ^ self
        ].

        (aspectMsg notNil
        and:[something == aspectMsg]) ifTrue:[
            self getListFromModel.
            ^ self
        ].
        something isNil ifTrue:[
            "/ model changed (not more information)
            self getListFromModel.
            ^ self
        ].
        something == #size ifTrue:[
            self getListFromModelScroll:false.
            ^ self
        ].
    ].
    changedObject == listChannel ifTrue:[
        self getListFromModel.
        ^ self
    ].

    ^ super update:something with:aParameter from:changedObject

    "Modified: / 08-11-2006 / 19:40:29 / cg"
! !

!ListView methodsFor:'drawing'!

drawFromVisibleLine:startVisLineNr to:endVisLineNr with:fg and:bg
    "draw a visible line range in fg/bg"

    |y         "{ Class: SmallInteger }"
     x         "{ Class: SmallInteger }"
     startLine "{ Class: SmallInteger }"
     endLine   "{ Class: SmallInteger }"
     listSize e sH l|

    y := self yOfVisibleLine:startVisLineNr.
    sH := lineSpacing // 2.

    backgroundAlreadyClearedColor == bg ifFalse:[
        gc paint:bg.
        gc fillRectangleX:margin y:y-sH
           width:(width - (margin * 2))
           height:(endVisLineNr - startVisLineNr + 1) * fontHeight + (lineSpacing - sH).
    ].
    list isNil ifTrue:[^ self].

    y := y + fontAscent.
    listSize := self size.

    startLine := startVisLineNr + firstLineShown - 1.
    endLine := endVisLineNr + firstLineShown - 1.
    (startLine == 0) ifTrue:[
        y := y + fontHeight.
        startLine := startLine + 1
    ].

    (endLine > listSize) ifTrue:[
        e := listSize
    ] ifFalse:[
        e := endLine
    ].

    (startLine <= e) ifTrue:[
        x := textStartLeft - viewOrigin x.
        gc paint:fg on:bg.
        "/ don't use list from:to:do:, to allow for subclasses to redefine the enumeration (TableView)
        self from:startLine to:e do:[:line |
            line notNil ifTrue:[
                "/ remove line's color emphasis, to enforce color.
                "/ otherwise blue text is not visible if selection-bg is blue
                l := self withoutColorEmphasis:line ifFg:fg andBg:bg.
                gc displayOpaqueString:l x:x y:y.
                
                checkedLinesForWidthOfContentsComputation == 0 ifTrue:[
                    self updateWidthOfWidestLineFor:l
                ].    
            ].
            y := y + fontHeight
        ]
    ]

    "Modified: / 15.12.1999 / 23:19:39 / cg"
!

drawLine:line atX:x inVisible:visLineNr with:fg and:bg
    "draw a given string at visible lines position with
     given x position in fg/bg. Clears the whole line before drawing the string.
     This is a low level entry; not meant for public use."

    |y l halfSpacing extraBelow|

    y := self yOfVisibleLine:visLineNr.
    backgroundAlreadyClearedColor == bg ifFalse:[
        gc paint:bg.
        halfSpacing := (lineSpacing//2).
        extraBelow := 0.
        self highlightLineSpacing ifTrue:[
            extraBelow := halfSpacing.
        ].
        gc fillRectangleX:margin y:y - halfSpacing
           width:(width - (2 * margin))
           height:fontHeight+extraBelow.
    ].
    line notNil ifTrue:[
        gc paint:fg on:bg.

        "/ remove lines color emphasis, to enforce color.
        "/ otherwise blue text is not visible if selection-bg is blue.
        "/ this is only done in EditTextViews and subClasses.
        self suppressEmphasisInSelection ifTrue:[
            l := self withoutColorEmphasis:line ifFg:fg andBg:bg.
        ] ifFalse:[
            l := line
        ].

        "/ in the future, we may like to have a flag setting, which highlights non-ISO8859 characters;
        "/ so we can tell, which chars make problems when saving as non-UTF8
        
        "/        l string bytesPerCharacter > 1 ifTrue:[
        "/            l do:[:each | each bytesPerCharacter > 1 ifTrue:[ self halt ]].
        "/        ].    
        gc displayOpaqueString:l x:x y:(y + fontAscent).
        
        checkedLinesForWidthOfContentsComputation == 0 ifTrue:[
            self updateWidthOfWidestLineFor:l
        ].    
    ].

    "Modified: / 15.12.1999 / 23:19:46 / cg"
!

drawLine:line fromX:x inVisible:visLineNr with:fg and:bg
    "draw a given string at visible lines position with
     given x position in fg/bg. Clears partial line before drawing the string.
     Low level entry; not meant for public use."

    |y l|

    y := self yOfVisibleLine:visLineNr.
    line notNil ifTrue:[
        gc paint:fg on:bg.

        "/ remove lines color emphasis, to enforce color.
        "/ otherwise blue text is not visible if selection-bg is blue
        l := self withoutColorEmphasis:line ifFg:fg andBg:bg.
        gc displayOpaqueString:l x:x y:(y + fontAscent).
        
        checkedLinesForWidthOfContentsComputation == 0 ifTrue:[
            self updateWidthOfWidestLineFor:l
        ].    
    ]

    "Modified: / 15.12.1999 / 23:19:55 / cg"
!

drawLine:lineStringArg inVisible:visLineNr col:col with:fg and:bg
    "draw single character at col index of visible line in fg/bg"

    |y yf x len lineString characterString w|

    lineString := lineStringArg.
    len := lineString size.

    x := (self xOfCol:col inVisibleLine:visLineNr) - viewOrigin x.
    y := self yOfVisibleLine:visLineNr.
    yf := y - (lineSpacing // 2).

    gc paint:bg.

    (lineString notNil and:[lineString isString not]) ifTrue:[
        w := lineString widthFrom:col to:(col min:len) on:self.
        w <= 0 ifTrue:[
            w := gc font width.
            gc fillRectangleX:x y:yf width:w height:fontHeight.
            gc paint:fg
        ].
        self clippedTo:(Rectangle left:x top:yf width:w height:fontHeight) do:[
            self drawVisibleLine:visLineNr with:fg and:bg
        ].
        ^ self
    ].

    (lineString isNil or:[col > len]) ifTrue:[
        gc fillRectangleX:x y:yf width:(gc font width) height:fontHeight.
        gc paint:fg
    ] ifFalse:[
        characterString := lineString copyFrom:col to:col.

        "/ remove lines color emphasis, to enforce color.
        "/ otherwise blue text is not visible if selection-bg is blue
        characterString := self withoutColorEmphasis:characterString ifFg:fg andBg:bg.
        w := characterString widthOn:self.

        gc fillRectangleX:x y:yf width:w height:fontHeight.
        gc paint:fg.
        self clippedTo:(Rectangle left:x top:yf width:w height:fontHeight) do:[
            gc displayString:characterString x:x y:(y + fontAscent)
        ].

        checkedLinesForWidthOfContentsComputation == 0 ifTrue:[
            self updateWidthOfWidestLineFor:characterString
        ].    
    ]

    "Modified: / 15.12.1999 / 23:21:12 / cg"
!

drawLine:lineStringArg inVisible:visLineNr from:startCol to:endColOrNil with:fg and:bg
    "draw part of a visible line in fg/bg"

    |y yf x lineString len characterString w endCol sCol eCol numExtraCols|

    "/ hack - please rewrite
    endCol := endColOrNil ? lineStringArg size.
    (endCol >= startCol) ifTrue:[
        sCol := startCol max:1.

        lineString := lineStringArg.

        x := (self xOfCol:sCol inVisibleLine:visLineNr) - viewOrigin x.
        y := (self yOfVisibleLine:visLineNr).
        yf := y - (lineSpacing // 2).

        len := lineString size.
        (lineString notNil and:[lineString isString not ])
        ifTrue:[
            w := lineString widthFrom:sCol to:(endCol min:len) on:self.
            endCol > len ifTrue:[
                sCol > len ifTrue:[
                    numExtraCols := (endCol - sCol + 1).
                ] ifFalse:[
                    numExtraCols := (endCol - len" + 1").
                ].
                gc paint:bg.
                gc fillRectangleX:x+w y:yf width:(numExtraCols * fontWidth) height:fontHeight.
            ].
            w > 0 ifTrue:[
                self clippedTo:(Rectangle left:x top:yf width:w height:fontHeight) do:[
                    gc drawVisibleLine:visLineNr with:fg and:bg.
                ].
                checkedLinesForWidthOfContentsComputation == 0 ifTrue:[
                    self updateWidthOfWidestLineFor:characterString
                ].    
            ].
            ^ self.
        ].

        (sCol > len) ifTrue:[
            backgroundAlreadyClearedColor == bg ifFalse:[
                len := endCol - sCol + 1.
                gc paint:bg.
                gc fillRectangleX:x y:yf
                               width:(fontWidth * len)
                              height:fontHeight
            ]
        ] ifFalse:[
            eCol := endCol.
            (endCol > len) ifTrue:[
                backgroundAlreadyClearedColor == bg ifFalse:[
                    characterString := lineString string species new:endCol.
                    characterString replaceFrom:1 to:len with:lineString startingAt:1.
                    lineString := characterString.
                ] ifTrue:[
                    eCol := len.
                ].
            ].

            "/ remove any color emphasis, to enforce drawing in fg/bg

            lineString := self withoutColorEmphasis:lineString ifFg:fg andBg:bg.

            backgroundAlreadyClearedColor == bg ifFalse:[
                (lineString isSingleByteString) ifTrue:[
                    fontIsFixedWidth ifTrue:[
                        w := (eCol - sCol + 1) * fontWidth
                    ] ifFalse:[
                        w := gc font widthOf:lineString from:sCol to:eCol
                    ]
                ] ifFalse:[
                    w := lineString widthFrom:sCol to:endCol on:self
                ].
                gc paint:bg.
                gc fillRectangleX:x y:yf width:w height:fontHeight.
            ].
            gc paint:fg on:bg.
            w notNil ifTrue:[
                "/ clip req'd for VISTAs new font rendering (which seems to shoot over the compute
                self clippedTo:(Rectangle left:x top:yf width:w height:fontHeight) do:[
                    "/ self displayOpaqueString:lineString from:sCol to:eCol x:x y:(y + fontAscent)
                    gc displayString:lineString from:sCol to:eCol x:x y:(y + fontAscent)
                ]
            ] ifFalse:[
                "/ self displayOpaqueString:lineString from:sCol to:eCol x:x y:(y + fontAscent)
                gc displayString:lineString from:sCol to:eCol x:x y:(y + fontAscent) opaque:false maxWidth:self width
            ].
            checkedLinesForWidthOfContentsComputation == 0 ifTrue:[
                self updateWidthOfWidestLineFor:lineString
            ].    
        ]
    ]

    "Modified: / 15.12.1999 / 23:21:43 / cg"
!

drawLine:lineString inVisible:visLineNr from:startCol with:fg and:bg
    "draw right part of a visible line from startCol to end of line in fg/bg"

    |y x index1 index2 lineWithoutColor|

    (startCol < 1) ifTrue:[
        index1 := 1
    ] ifFalse:[
        index1 := startCol
    ].
    y := self yOfVisibleLine:visLineNr.
    x := (self xOfCol:index1 inVisibleLine:visLineNr) - viewOrigin x.
    backgroundAlreadyClearedColor == bg ifFalse:[
        gc paint:bg.
        gc fillRectangleX:x y:y - (lineSpacing // 2)
           width:(width + viewOrigin x - x) height:fontHeight.
    ].
    lineString notNil ifTrue:[
        lineString isString ifFalse:[
            self drawLine:lineString inVisible:visLineNr from:startCol to:nil with:fg and:bg.
        ] ifTrue:[
            lineWithoutColor := self withoutColorEmphasis:lineString ifFg:fg andBg:bg.
            index2 := lineWithoutColor size.
            (index2 < index1) ifTrue:[^ self].
            (index1 <= index2) ifTrue:[
                self paint:fg on:bg.
                "/ self displayOpaqueString:lineWithoutColor from:index1 to:index2 x:x y:(y + fontAscent)
                gc displayString:lineWithoutColor from:index1 to:index2 x:x y:(y + fontAscent).

                checkedLinesForWidthOfContentsComputation == 0 ifTrue:[
                    self updateWidthOfWidestLineFor:lineWithoutColor
                ].    
            ]
        ]
    ]

    "Modified: / 15.12.1999 / 23:24:40 / cg"
!

drawLine:line inVisible:visLineNr with:fg and:bg
    "draw a given string at visible lines position in fg/bg"

    self drawLine:line atX:(textStartLeft - viewOrigin x) inVisible:visLineNr with:fg and:bg
!

drawVisibleLine:visLineNr col:col with:fg and:bg
    "draw single character at col index of visible line in fg/bg"

    self
	drawLine:(self visibleAt:visLineNr)
	inVisible:visLineNr
	col:col
	with:fg and:bg
!

drawVisibleLine:visLineNr from:startCol to:endCol with:fg and:bg
    "draw part of a visible line in fg/bg"

    self
	drawLine:(self visibleAt:visLineNr)
	inVisible:visLineNr
	from:startCol to:endCol
	with:fg and:bg
!

drawVisibleLine:visLineNr from:startCol with:fg and:bg
    "draw right part of a visible line from startCol to end of line in fg/bg"

    self
	drawLine:(self visibleAt:visLineNr)
	inVisible:visLineNr
	from:startCol
	with:fg and:bg
!

drawVisibleLine:visLineNr with:fg and:bg
    "draw a visible line in fg/bg"

    self
	drawLine:(self visibleAt:visLineNr)
	atX:(textStartLeft - viewOrigin x)
	inVisible:visLineNr
	with:fg
	and:bg

    "Modified: 28.2.1996 / 19:30:23 / cg"
!

fillRectangleX:x y:y width:w height:h
    "fill rectangle; checks whether the rectangle already is filled with
     the current paint (#redrawX:y:w:h)."

    backgroundAlreadyClearedColor ~~ self paint ifTrue:[
        super fillRectangleX:x y:y width:w height:h
    ]
!

invalidateLine:line
    "invalidate the area of a single line.
     This arranges for that line to be redrawn asynchronously (later).
     If multiple such invalidations arrive, those areas may be lumped
     together for a block update.
     The update takes place when the windowGroup process gets a chance to
     process expose events."

    |yTop visLineNr|

    visLineNr := self listLineToVisibleLine:line.
    visLineNr notNil ifTrue:[
	yTop := self yOfVisibleLine:visLineNr.
	yTop isNil ifTrue:[^ self]. "/ not visible
	(yTop + fontHeight) < 0 ifTrue:[^ self]. "/ not visible
	self
	    invalidateDeviceRectangle:(Rectangle
			    left:margin top:yTop-(lineSpacing//2)
			    width:(width - (2 * margin)) height:fontHeight)
	    repairNow:false.
    ]

    "Created: / 5.3.1998 / 01:24:19 / cg"
    "Modified: / 5.3.1998 / 13:41:31 / cg"
! !

!ListView methodsFor:'event handling'!

contentsChanged
    "size of contents changed - move origin up if possible"

    |listSize newOrigin|

    shown ifTrue:[
	list notNil ifTrue:[
	    listSize := self numberOfLines.

	    listSize == 0 ifTrue:[
		widthOfWidestLine := 0.
	    ].

	    "
	     if we are beyond the end, scroll up a bit
	    "
	    ((firstLineShown + nFullLinesShown) > listSize) ifTrue:[
		newOrigin := listSize - nFullLinesShown + 1.
		newOrigin < 1 ifTrue:[
		    newOrigin := 1
		].
		self scrollToLine: newOrigin.
	    ].
	].
    ].

    ^ super contentsChanged

    "Modified: 18.11.1996 / 19:50:07 / stefan"
    "Modified: 5.3.1997 / 15:50:46 / cg"
!

keyPress:key x:x y:y
    "a key was pressed - handle page-keys here"

    <resource: #keyboard (#PreviousPage #NextPage #HalfPageUp #HalfPageDown
                          #BeginOfText #EndOfText
                          #ScrollUp #ScrollDown 
                          )>
    |n|

    (key == #PreviousPage) ifTrue: [^ self pageUp].
    (key == #NextPage)     ifTrue: [^ self pageDown].
    (key == #HalfPageUp)   ifTrue: [^ self halfPageUp].
    (key == #HalfPageDown) ifTrue: [^ self halfPageDown].

    (key == #BeginOfText) ifTrue:[^ self scrollToTop].
    (key == #EndOfText) ifTrue:[^ self scrollToBottom].

    (key == #ScrollUp) ifTrue:[
        n := 1 + (self sensor compressKeyPressEventsWithKey:#ScrollUp).
        ^ self scrollUp:n
    ].
    (key == #ScrollDown) ifTrue:[
        n := 1 + (self sensor compressKeyPressEventsWithKey:#ScrollDown).
        ^ self scrollDown:n
    ].

    super keyPress:key x:x y:y
!

keyboardZoom:larger
    "CTRL+/- zoom action"

    self fontLargerOrSmaller:larger
!

keyboardZoom:larger inAllViews:inAllViews
    "CTRL+/- zoom action"

    inAllViews ifTrue:[
        SimpleView allSubInstancesDo:[:each |
            each keyboardZoom:larger 
        ].    
    ] ifFalse:[
        self keyboardZoom:larger 
    ].
!

mapped
    self stopAutoScroll.
    super mapped
!

mouseWheelZoom:amount
    "CTRL-wheel action"

    |oldSize newSize delta mul font|

    amount > 0 ifTrue:[
        "/ delta := 1.  mul := 1.
        delta := 0.  mul := 1.05.
    ] ifFalse:[
        "/ delta := -1. mul := 1.
        delta := 0. mul := 0.95.
    ].

    font := gc font.
    font sizeUnit ~~ #px ifTrue:[
        oldSize := font size.
        newSize := (((oldSize + delta)* mul) max:4) min:100.
        newSize ~= oldSize ifTrue:[
            self font:(font asSize:newSize).
        ]
    ].
!

redrawX:x y:y width:w height:h
    "a region must be redrawn"

    |startCol endCol line saveClip
     startLine "{ Class:SmallInteger }"
     stopLine  "{ Class:SmallInteger }"
    |

    shown ifFalse:[^ self].

    startLine := self visibleLineOfY:y.
    stopLine := self visibleLineOfY:(y + h).

    saveClip := gc clippingBoundsOrNil.
    self clippingBounds:(Rectangle left:x top:y width:w height:h).
    gc paint:bgColor.
    gc fillRectangleX:x y:y width:w height:h.
    backgroundAlreadyClearedColor := bgColor.

    (includesNonStrings or:[w > (width // 4 * 3)]) ifTrue:[
        "includes non strings or area is big enough: redraw whole lines"
        self redrawFromVisibleLine:startLine to:stopLine
    ] ifFalse:[
        line := self visibleAt:startLine.

        (fontIsFixedWidth and:[line isSingleByteString]) ifFalse:[
            "start/end col has to be computed for each line"

            startLine to:stopLine do:[:i |
                startCol := self colOfX:x inVisibleLine:i.
                endCol := self colOfX:(x + w) inVisibleLine:i.
                startCol > 0 ifTrue:[
                    endCol > 0 ifTrue:[
                        self redrawVisibleLine:i from:startCol to:endCol
                    ]
                ]
            ]
        ] ifTrue:[
            "start/end col is the same for all lines"
            startCol := self colOfX:x inVisibleLine:startLine.
            endCol := self colOfX:(x + w) inVisibleLine:startLine.
            startCol > 0 ifTrue:[
                endCol > 0 ifTrue:[
                    startLine to:stopLine do:[:i |
                        line := self visibleAt:i.
                        (line isSingleByteString) ifTrue:[
                            self redrawVisibleLine:i from:startCol to:endCol
                        ] ifFalse:[
                            self redrawVisibleLine:i
                        ]
                    ]
                ]
            ]
        ]
    ].
    backgroundAlreadyClearedColor := nil.
    self clippingBounds:saveClip.
!

sizeChanged:how
    "size changed - move origin up if possible"

    super sizeChanged:how.

    self computeNumberOfLinesShown.

    innerWidth := width - textStartLeft - margin.

"/ Makes trouble when fighting with SelListViews sizeChanged-positioning ...
"/
"/    shown ifFalse:[^ self].
"/    list isNil ifTrue:[^ self].
"/
"/    listSize := self numberOfLines.
"/    "
"/     if we are beyond the end, scroll up a bit
"/    "
"/    ((firstLineShown + nFullLinesShown) >= listSize) ifTrue:[
"/        self scrollToBottom.
"/        ^ self
"/    ].

    "Modified: / 18.11.1996 / 19:37:02 / stefan"
    "Modified: / 27.1.1998 / 14:10:04 / cg"
!

unmap
    self stopAutoScroll.
    super unmap
! !

!ListView methodsFor:'initialization'!

create
    super create.

    "I cache font parameters here - they are used so often ..."
    self getFontParameters.
    self computeNumberOfLinesShown.
    fgColor := fgColor onDevice:device.
    bgColor := bgColor onDevice:device
!

defaultControllerClass
    self class == ListView ifTrue:[^ ListViewController].
    ^ super defaultControllerClass
!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    super fetchDeviceResources.

    fgColor notNil ifTrue:[fgColor := fgColor onDevice:device].
    bgColor notNil ifTrue:[bgColor := bgColor onDevice:device].

    "Created: 14.1.1997 / 00:12:12 / cg"
!

initStyle
    "setup viewStyle specifics"

    |n|

    super initStyle.

    n := DefaultTopMargin.
    n isInteger ifFalse:[
	n := (self verticalPixelPerMillimeter:n) rounded.
    ].
    self topMargin:n.

    n := DefaultLeftMargin.
    n isInteger ifFalse:[
	n := (self verticalPixelPerMillimeter:n) rounded.
    ].
    self leftMargin:n.

    lineSpacing := 2.
    "/ q&d temporary hack.
    "/ X11 fonts are currently so ugly... add more spacing.
    device isX11Platform ifTrue:[
	lineSpacing := lineSpacing + 3.
    ].
    fgColor := DefaultForegroundColor.
    bgColor := DefaultBackgroundColor.

    "Modified (comment): / 05-10-2011 / 15:51:02 / az"
!

initialize
    super initialize.

    viewOrigin := 0@0.

    textStartTop := topMargin + margin.

    bitGravity := #NorthWest.
    list := nil.
    firstLineShown := 1.
    nFullLinesShown := 1. "just any value ..."
    nLinesShown := 1.     "just any value"
    partialLines := true.
    tabPositions := UserDefaultTabPositions ? self class defaultTabPositions.
    includesNonStrings := false.
    lineEndCRLF := false.
    checkedLinesForWidthOfContentsComputation := nil."/ i.e. all
    self getFontParameters.
    self initializeWordCheckAction.

    scrollWhenUpdating := #keep. "/ #beginOfText.
    expandTabsWhenUpdating := true.
    compareModelOnUpdate := true.
    checkLineEndConventionWhenUpdating := true.
    scrollLocked := false.
    autoScroll := true.

    "Modified: / 03-07-2006 / 17:03:59 / cg"
!

initializeWordCheckAction
    "the wordCheck is a predicate block which returns true if the given character
     belongs to the (textual) word. Used with double click to select a word.
     When editing code, typically characters which are part of an identifier
     are part of a word (underline, dollar, but no other non-letters).
     The standardWordCheck aks the current userPreferences for details."

    wordCheck := [:char | self standardWordCheck:char].

    "Created: / 03-07-2006 / 17:03:50 / cg"
!

realize
    |sz|

    self extentChangedFlag ifTrue:[
	self computeNumberOfLinesShown.
    ].

    firstLineShown ~~ 1 ifTrue:[
	sz := self size.
	firstLineShown + nLinesShown > sz ifTrue:[
	    self scrollToLine:sz - nLinesShown.
	]
    ].

    super realize.

"/ old: fetch models value on realize;
"/ new: fetch value when model is assigned.
"/
"/    model notNil ifTrue:[
"/        self getListFromModel.
"/    ]

    "Modified: 15.8.1996 / 13:08:56 / stefan"
    "Modified: 28.2.1997 / 19:44:19 / cg"
!

recreate
    "recreate after a snapin or a migration"
    |n|

    super recreate.

    "
     recompute margins and font parameters
     - display may have different resolution/font sizes.
    "
"/    topMargin := (self verticalPixelPerMillimeter:0.5) rounded.
"/    self leftMargin:(self horizontalPixelPerMillimeter:0.5) rounded.

    n := DefaultTopMargin.
    n isInteger ifFalse:[
	n := (self verticalPixelPerMillimeter:n) rounded.
    ].
    self topMargin:n.

    n := DefaultLeftMargin.
    n isInteger ifFalse:[
	n := (self verticalPixelPerMillimeter:n) rounded.
    ].
    self leftMargin:n.

    self getFontParameters

    "Modified: / 26.9.1998 / 17:09:32 / cg"
! !

!ListView methodsFor:'private'!

absoluteLineToVisibleLine:absLineNr
    "given an absolute line (1..) return visible linenr or nil"

    <resource:#obsolete>
    self obsoleteMethodWarning:'use #listLineToVisibleLine:'.
    ^ self listLineToVisibleLine:absLineNr

"/    absLineNr isNil ifTrue:[^ nil].
"/    (absLineNr < firstLineShown) ifTrue:[^ nil].
"/    (absLineNr >= (firstLineShown + nLinesShown)) ifTrue:[^ nil].
"/    ^ absLineNr - firstLineShown + 1
"/
!

checkForExistingLine:lineNr
    "check if a line for lineNr exists; if not, expand text"

    list isNil ifTrue: [
	list := StringCollection new:lineNr.
	self contentsChanged
    ] ifFalse: [
	lineNr > (list size) ifTrue:[
	    self grow:lineNr.
	    self contentsChanged
	]
    ]
!

colOfX:x inVisibleLine:visLineNr
    "given a visible lineNr and x-coordinate, return colNr"

    |lineString linePixelWidth xRel runCol posLeft posRight done
     hasEmphasis oPosRight oPosLeft|

    xRel := x - textStartLeft + viewOrigin x.
    (xRel <= 0) ifTrue:[^ 1].

    lineString := self visibleAt:visLineNr.

    "
     for fix fonts, this is easy ...
    "
    (fontIsFixedWidth
    and:[lineString isNil or:[lineString hasChangeOfEmphasis not]]) ifTrue:[
        ^ (xRel // fontWidth) + 1
    ].

    "
     for variable fonts, more work is required ...
    "
    lineString notNil ifTrue:[
        lineString := self visibleStringFrom:lineString.
        (hasEmphasis := lineString hasChangeOfEmphasis) ifTrue:[
            linePixelWidth := lineString widthOn:self
        ] ifFalse:[
            lineString := lineString string.
            linePixelWidth := gc font widthOf:lineString.
        ]
    ] ifFalse:[
        linePixelWidth := 0
    ].

    (linePixelWidth <= xRel) ifTrue:[
        fontWidth == 0 ifTrue:[
            "
             although this 'cannot happen',
             it seems that X reports this width for some strange fonts ...
            "
            ^ lineString size
        ].
        ^ lineString size + ((xRel - linePixelWidth) // fontWidth) + 1
    ].

    "/ cannot simply count individual characters,
    "/ since kerning or other non-linear effects may be involved ...
    "/ use a binary search, initialized with some guess.

    "/ a guess: take some 'average' character's width and compute an initial guess
    runCol := x // (gc font widthOf:'e').
    runCol := runCol min:lineString size.

"/    runCol := lineString size // 2.
"/    (runCol == 0) ifTrue:[runCol := 1].

    hasEmphasis ifTrue:[
        posLeft := (lineString copyFrom:1 to:(runCol - 1)) widthOn:self.
        posRight := (lineString copyFrom:1 to:runCol) widthOn:self.
    ] ifFalse:[
        posLeft := gc font widthOf:lineString from:1 to:(runCol - 1).
        posRight := gc font widthOf:lineString from:1 to:runCol.
    ].

    done := (posLeft <= xRel) and:[posRight > xRel].

    [done] whileFalse:[
        oPosRight := posRight.
        oPosLeft := posLeft.

        (posRight <= xRel) ifTrue:[
            runCol := runCol + 1.
            posLeft := posRight.
            hasEmphasis ifTrue:[
                posRight := (lineString copyFrom:1 to:runCol) widthOn:self.
            ] ifFalse:[
                posRight := gc font widthOf:lineString from:1 to:runCol
            ]
        ] ifFalse:[
            (posLeft > xRel) ifTrue:[
                runCol := runCol - 1.
                (runCol == 0) ifTrue:[^ 0].
                posRight := posLeft.
                hasEmphasis ifTrue:[
                    posLeft := (lineString copyFrom:1 to:(runCol - 1)) widthOn:self.
                ] ifFalse:[
                    posLeft := gc font widthOf:lineString from:1 to:(runCol - 1)
                ]
            ]
        ].
        done := (posLeft <= xRel) and:[posRight > xRel].
"234567890123456789012345678901234567890"
        ((oPosRight == posRight) and:[oPosLeft == posLeft]) ifTrue:[
            "/ paranoia: just in case there are unprintable characters
            "/ (avoid endless loop if the binary search does not make progress)
            done := true.
        ]
    ].
"/self paint:Color red.
"/self displayRectangleX:posLeft+textStartLeft-viewOrigin x y:(self yOfVisibleLine:visLineNr)
"/                       width:(posRight-posLeft) height:fontHeight.
"/self paint:self blackColor.
    ^ runCol

    "Modified: / 25-04-2011 / 11:26:58 / cg"
    "Modified: / 02-05-2011 / 14:08:54 / sr"
!

computeNumberOfLinesShown
    "recompute the number of visible lines"

    |innerHeight|

    innerHeight := self innerHeight.
    nFullLinesShown := (innerHeight + lineSpacing) // fontHeight.
    nLinesShown := nFullLinesShown.

    partialLines ifTrue:[
	((nLinesShown * fontHeight) < innerHeight) ifTrue:[
	    nLinesShown := nLinesShown + 1
	]
    ]

    "Modified: 29.5.1996 / 14:48:43 / cg"
!

convertRTF:aList
    <resource: #obsolete>
    "this is a q&d RTF to poor-text converter which removes any rich stuff.
     - a first shot 'til  DocumentView is finished ..."

    |newList newLine charIndex inEscape char special|

    self obsoleteMethodWarning.

    newList := StringCollection new:200.
    newList grow:0.

    newLine := ''.
    aList do:[:line |
	((line size == 0) or:[line isBlank]) ifTrue:[
	    newList add:newLine.
	    newLine := ''
	] ifFalse:[
	    special := ((line at:1) == ${) or:[(line includes:$\)].
	    special := special or:[(line at:1) == $}].
	    special ifFalse:[
		newList add:(newLine , line)
	    ] ifTrue:[
		charIndex := 1.
		[charIndex <= line size] whileTrue:[
		    char := line at:charIndex.
		    ((char == ${ ) or:[char == $} ]) ifTrue:[
			"left-brace: ignore rest of line"
			charIndex := line size + 1
		    ] ifFalse:[
			(char == $\) ifTrue:[
			    inEscape := true
			] ifFalse:[
			    inEscape ifTrue:[
				(char == Character space) ifTrue:[
				    inEscape := false
				]
			    ] ifFalse:[
				newLine := newLine copyWith:char
			    ]
			].
			charIndex := charIndex + 1
		    ]
		]
	    ]
	]
    ].
    ^ newList

    "Modified: 18.5.1996 / 14:03:16 / cg"
!

enqueueDelayedContentsChangedNotification
    "because contentschanged may be slow (recomputing width of widest line),
     we delay its execution by pushing it onto the event queue.
     This has the effect of allowing for multiple add-lines before recomputing.
     Much speeding up inserting into long lists"

    |sensor|

    sensor := self sensor.
    (sensor hasUserEvent:#contentsChanged for:self) ifFalse:[
	sensor pushUserEvent:#contentsChanged for:self
    ].
    "/ used to be syncronous:
    "/ self contentsChanged.             "recompute scrollbars"

    "Created: / 25-07-2012 / 11:59:58 / cg"
!

getFontParameters
    "get some info of the used font. They are cached since we use them often ..
     The code below uses the font's average height parameters - these
     are not OK for some oversized national characters (such as A-dieresis).
     Therefore, this method should be redefined in views which will be used
     with national characters (i.e. editTextViews)."

    |hMax newDeviceFont|

    newDeviceFont := gc deviceFont.
    hMax := newDeviceFont height.

    includesNonStrings == true ifTrue:[
        "/
        "/ find maximum height of lines
        "/
        hMax := list inject:hMax into:[:maxSoFar :thisLine |
                                        thisLine isNil ifTrue:[
                                            maxSoFar
                                        ] ifFalse:[
                                            (thisLine isSingleByteString) ifTrue:[
                                                maxSoFar
                                            ] ifFalse:[
                                                maxSoFar max:(thisLine heightOn:self)
                                            ]
                                        ]
                              ].

    ].
    fontHeight := newDeviceFont maxHeight.
    "/ fontHeight := font height.
    fontHeight := fontHeight max:(hMax + lineSpacing).
    fontAscent := newDeviceFont ascent. "/ maxAscent. -- see SelectionInListViews selection in motif style
    "/ fontAscent := font maxAscent "ascent". "/ maxAscent. -- see SelectionInListViews selection in motif style
    "/ fontAscent := (font maxAscent + font ascent) // 2. "/ maxAscent. -- see SelectionInListViews selection in motif style
    fontWidth := newDeviceFont width.
    fontWidth == 0 ifTrue:[
        "/ should not happen, but some bad fonts seem to have it
        ('ListView [info]: font says, it has zero width: ', newDeviceFont printString) infoPrintCR.
        fontWidth := 1.
    ].    
    fontIsFixedWidth := newDeviceFont isFixedWidth.

    "Modified: 3.7.1997 / 12:24:25 / cg"
!

getListFromModel
    "ask my model (if any) for the text via the listMsg.
     If there is no listMessage, try aspect for backward compatibility."

    |newText msg doCompareIfUnchanged|

    model notNil ifTrue:[
        msg := listMsg ? aspectMsg.

        msg notNil ifTrue:[
            doCompareIfUnchanged := compareModelOnUpdate.
            newText := model perform:msg.
            "/ cg: this makes many optimizations (virtualArray) useless;
            "/ I do not think that this is a good idea:
            "/     text notNil ifTrue:[
            "/ so I changed it to:
            (newText notNil and:[newText isString]) ifTrue:[
                newText := newText asStringCollection.
            ] ifFalse:[
                newText == model ifTrue:[
                    self isReadOnly ifTrue:[
                        newText := model.
                        self list:newText expandTabs:expandTabsWhenUpdating scanForNonStrings:expandTabsWhenUpdating.
                        ^ self.
                    ] .
                    "/ I must operate on a copy
                    newText := model asNewOrderedCollection.
                    "/ doCompareIfUnchanged := false.
                ].
            ].

            doCompareIfUnchanged ifTrue:[
                "/ see if there is a change at all.
                "/ use to compare using =, but that's not enough in case of emphasis change.
                newText size == list size ifTrue:[
                    |same|

                    same := true.
                    newText size > 0 ifTrue:[
                        newText ~~ list ifTrue:[
                            newText with:list do:[:eachNewLine :eachOldLine |
                                (eachNewLine == eachOldLine) ifFalse:[
                                    same := false.
                                ]
                            ]
                        ].
                    ].
                    same ifTrue:[^ self].
                ].
            ].

            "/ SV: this compare does not work, if model uses (i.e. updates)
            "/ the same stringCollection as the view!!
            true "text ~= list" ifTrue:[
                "/ changed #list to care for scrollLocked
"/                scrollLocked ifTrue:[
"/                    self setList:newText expandTabs:expandTabsWhenUpdating
"/                ] ifFalse:[
                    self list:newText expandTabs:expandTabsWhenUpdating scanForNonStrings:expandTabsWhenUpdating
"/                ]
            ].
        ].
    ].

    "Modified: 26.4.1996 / 14:09:42 / cg"
    "Modified: 19.2.1997 / 12:08:50 / stefan"
!

getListFromModelScroll:aBoolean
    "ask my model (if any) for the text via the listMsg.
     If there is no listMessage, try aspect for backward compatibility.
     If aBoolean is false, scrolling is suppressed here"

    |prev|

    prev := scrollLocked.
    scrollLocked := aBoolean not.
    [
	self getListFromModel
    ] ensure:[
	scrollLocked := prev.
    ].
!

highlightLineSpacing
    "true if the spacing between lines is to be drawn with selected color,
     false if it remains white.
     false for selection in list views; true for edit/text views"

    ^ true
!

line:line withoutEmphasis:emphasisToRemove
    (line notNil
    and:[line isString]) ifTrue:[
	^ line withoutEmphasis:emphasisToRemove.
    ].
    ^ line
!

listAt:lineNr from:startCol
    "return right substring from startCol to end of a line"

    |line|

    line := self listAt:lineNr.
    line isNil ifTrue:[^ nil].
    (startCol > line size) ifTrue:[^ nil].
    ^ line copyFrom:startCol
!

listAt:lineNr from:startCol to:endCol
    "return substring from startCol to endCol of a line"

    |line lineLen nCols|

    nCols := (endCol - startCol + 1).

    line := self listAt:lineNr.
    lineLen := line size.

    (line isNil or:[startCol > lineLen]) ifTrue:[
	(nCols > 0) ifTrue:[
	    ^ (String new:nCols)
	].
	^ nil
    ].

    (endCol > lineLen) ifTrue:[
	^ (line copyFrom:startCol to:lineLen) , (String new:(endCol-lineLen))
    ].
    ^ line copyFrom:startCol to:endCol
!

listAt:lineNr to:endCol
    "return left substring from start to endCol of a line"

    |line lineSize|

    line := self listAt:lineNr.
    line isNil ifTrue:[
	(endCol > 0) ifTrue:[
	    ^ (String new:endCol)
	].
	^ nil
    ].

    lineSize := line size.

    (endCol > lineSize) ifTrue:[
	^ (line copyTo:lineSize) , (String new:(endCol - lineSize)).
    ].
    ^ line copyTo:endCol
!

listLineIsVisible:listLineNr
    "return true,  if a particular line is visible"

    |visibleLineNr "{ Class: SmallInteger }"|

    shown ifFalse:[^ false].
    listLineNr isNil ifTrue:[^ false].
    visibleLineNr := listLineNr + 1 - firstLineShown.
    ^ (visibleLineNr between:1 and:nLinesShown)

    "Created: / 26.7.1998 / 13:24:16 / cg"
!

listLineToVisibleLine:listLineNr
    "given a list line (1..) return visible linenr or nil"

    |visibleLineNr "{ Class: SmallInteger }"|

    shown ifFalse:[^ nil].
    listLineNr isNil ifTrue:[^ nil].
    visibleLineNr := listLineNr - firstLineShown + 1.
    (visibleLineNr between:1 and:nLinesShown) ifFalse:[^ nil].
    ^ visibleLineNr
!

recomputeWidthOfWidestLineFor:aString
    <resource: #obsolete>
    self recomputeWidthOfWidestLineFor:aString old:nil
!

recomputeWidthOfWidestLineFor:newEntry old:oldEntry
    "a new line was added (oldEntry == nil) or replaced oldEntry.
     Update the widthOfWidestLine cache or flush it, if we cannot easily
     figure out the overall text width"

    |newW oldW|

    widthOfWidestLine notNil ifTrue:[
	newEntry isNil ifTrue:[
	    newW := 0
	] ifFalse:[
	    (newEntry isSingleByteString) ifTrue:[
		newW := gc font widthOf:newEntry
	    ] ifFalse:[
		newW := newEntry widthOn:self
	    ].
	].

	newW >= widthOfWidestLine ifTrue:[
	    widthOfWidestLine := newW.
	] ifFalse:[
	    oldEntry isNil ifTrue:[
		oldW := 0
	    ] ifFalse:[
		(oldEntry isSingleByteString) ifTrue:[
		    oldW := gc font widthOf:oldEntry
		] ifFalse:[
		    oldW := oldEntry widthOn:self
		].
	    ].
	    newW > oldW ifTrue:[
		"/ no change; new entries width is between this width and amx width
	    ] ifFalse:[
		"/ new entry is smaller than oldEntry; if the oldEntry was the previos max,
		"/ we don't know the new max
		oldW = widthOfWidestLine ifTrue:[
		    widthOfWidestLine := nil "/ means: unknown
		] ifFalse:[
		    "/ old line was not the widest, and new line is shorter;
		    "/ no change
		]
	    ]
	].
    ].
    ^ widthOfWidestLine
!

suppressEmphasisInSelection
    "selection is shown with original emphasis"

    ^ false
!

textChanged
    "ignored here"
!

updateWidthOfWidestLineFor:aLine
    "when set to do this dynamically
     (eg when checkedLinesForWidthOfContentsComputation == 0)"

    |w|

    w := self widthOfLineString:aLine.
    w > (widthOfWidestLine ? 0) ifTrue:[
        widthOfWidestLine := w.
        self contentsChanged.
    ].    
!

visibleAt:visibleLineNr
    "return what is visible at line (numbers start at 1).
     This is used for redrawing; i.e. for non-string entries, this
     returns the original."

    |listLineNr listsize|

    listLineNr := visibleLineNr + firstLineShown - 1.
    (listLineNr == 0) ifTrue:[^ nil].
    (list notNil) ifTrue:[
	listsize := self size
    ] ifFalse:[
	listsize := 0
    ].
    (listLineNr <= listsize) ifTrue:[^ self at:listLineNr].
    ^ ''
!

visibleLineOfY:y
    "given a y-coordinate, return the visible lineNr
     - works for fix-height fonts only"

    ^ (((y - textStartTop) // fontHeight) + 1) max:1

    "Modified: / 13.2.1998 / 20:57:26 / stefan"
!

visibleLineToAbsoluteLine:visibleLineNr
    "given a visible line (1..) return absolut linenr"

    visibleLineNr isNil ifTrue:[^ nil].
    ^ visibleLineNr + firstLineShown - 1
!

visibleLineToListLine:visibleLineNr
    "given a visible line (1..) return linenr in list or nil
     (this one returns nil if the given visibleLineNr is one of the
     separators)"

    |listLineNr  "{ Class: SmallInteger }"
     listsize    "{ Class: SmallInteger }" |

    visibleLineNr isNil ifTrue:[^ nil].
    listLineNr := visibleLineNr + firstLineShown - 1.
    (listLineNr == 0) ifTrue:[^nil].
    listsize := self size.
    (listLineNr <= listsize) ifTrue:[^ listLineNr].
    ^ nil
!

visibleStringFrom:aString
    ^ aString asString
!

widthForScrollBetween:firstLine and:lastLine
    "return the width in pixels for a scroll between firstLine and lastLine.
     - used to optimize scrolling, by limiting the scrolled area.
     Subclasses with selections or other additional visible stuff should redefine
     this method."

    ^ innerWidth

"/    "for small width, its not worth searching for
"/     longest line ...
"/    "
"/    (width < 300) ifTrue:[^ innerWidth].
"/
"/    "for large lists, search may take longer than scrolling full
"/    "
"/    self size > 2000 ifTrue:[^ innerWidth].
"/
"/    "
"/     if there is a pattern-background, we have to scroll everything
"/    "
"/    (viewBackground isColor not
"/     or:[viewBackground isDithered]) ifTrue:[
"/        ^ width
"/    ].
"/
"/    w := self widthOfWidestLineBetween:firstLine and:lastLine.
"/    (w > innerWidth) ifTrue:[^ innerWidth].
"/    ^ w

    "Modified: 17.1.1997 / 17:44:12 / cg"
!

widthOfLineString:entry
    "return the width of an entry"

    entry isNil ifTrue:[^ 0].
    (entry isSingleByteString) ifTrue:[
	^ gc font widthOf:entry
    ].
    ^ entry widthOn:self

    "Modified: 12.5.1996 / 20:09:53 / cg"
!

widthOfWidestLineBetween:firstLine and:lastLine
    "return the width in pixels of the widest line in a range
     - used to optimize scrolling, by limiting the scrolled area;
       not for scrollbar or other width related stuff which should be exact."

    |max      "{ Class: SmallInteger }"
     first    "{ Class: SmallInteger }"
     last     "{ Class: SmallInteger }"
     thisLen  "{ Class: SmallInteger }"
     listSize "{ Class: SmallInteger }" |

    includesNonStrings ifTrue:[
	^ width
    ].

    fontIsFixedWidth ifTrue:[
	^ (self lengthOfLongestLineBetween:firstLine and:lastLine) * fontWidth
    ].
    listSize := self size.
    max := 0.
    first := firstLine.
    last := lastLine.

    (first > listSize) ifTrue:[^ max].
    (last > listSize) ifTrue:[
	last := listSize
    ].

    self from:first to:last do:[:line |
	line notNil ifTrue:[
	    (line isSingleByteString) ifTrue:[
		thisLen := gc font widthOf:line
	    ] ifFalse:[
		thisLen := line widthOn:self
	    ].
	    (thisLen > max) ifTrue:[
		max := thisLen
	    ]
	]
    ].
    ^ max
!

withoutAnyColorEmphasis:line
    (line notNil and:[line isText]) ifTrue:[
	^ line withoutAnyColorEmphasis
    ].
    ^ line

    "
     'hello' asText colorizeAllWith:Color red.
     ('hello' asText colorizeAllWith:Color red) withoutForegroundColorEmphasis.
     ('hello' asText colorizeAllWith:Color red) withoutAnyColorEmphasis.
    "

    "Modified (comment): / 06-03-2012 / 18:16:41 / cg"
!

withoutBackgroundColorEmphasis:line
    (line notNil and:[line isText]) ifTrue:[
	^ line withoutBackgroundColorEmphasis
    ].
    ^ line
!

withoutColorEmphasis:line
    (line notNil and:[line isText]) ifTrue:[
	^ line withoutForegroundColorEmphasis
    ].
    ^ line
!

withoutColorEmphasis:line ifFg:fg andBg:bg
    "/ remove lines color emphasis, to enforce color.
    "/ otherwise blue text is not visible if selection-bg is blue

    (line notNil
    and:[line isText
    and:[fg ~= fgColor or:[bg ~= bgColor]]]) ifTrue:[
	^ line withoutAnyColorEmphasis
    ].
    ^ line

    "Created: / 15-12-1999 / 23:19:30 / cg"
!

xOfCol:col inVisibleLine:visLineNr
    "given a visible line- and colNr, return the x-coordinate in view"

    |line lineSize tcol lText|

    col == 1 ifTrue:[
	lText := 0
    ] ifFalse:[
	tcol := col - 1.

	line := self visibleAt:visLineNr.
	(fontIsFixedWidth
	and:[line isNil or:[line isSingleByteString]])
	ifTrue:[
	    lText := (tcol * fontWidth)
	] ifFalse:[
	    line notNil ifTrue:[
		lineSize := line string size
	    ] ifFalse:[
		lineSize := 0
	    ].
	    (lineSize == 0) ifTrue:[
		lText := (tcol * fontWidth)
	    ] ifFalse:[
		(lineSize < col) ifTrue:[
		    lText := (line widthOn:self) + (fontWidth * (tcol - lineSize))
		] ifFalse:[
		    (line isSingleByteString) ifTrue:[
			lText := (gc font widthOf:line from:1 to:tcol)
		    ] ifFalse:[
			lText := line widthFrom:1 to:tcol on:self.
		    ]
		]
	    ]
	]
    ].
    ^ lText + textStartLeft

    "Modified: / 3.9.1998 / 21:56:33 / cg"
!

yOfLine:lineNr
    "given a physical lineNr, return y-coordinate in view
     - works for fix-height fonts only"

    |visLine|

    visLine := self listLineToVisibleLine:lineNr.
    visLine isNil ifTrue:[
	^ nil
    ].
    ^ self yOfVisibleLine:visLine

    "Created: / 26.7.1998 / 13:23:16 / cg"
!

yOfVisibleLine:visLineNr
    "given a visible lineNr, return y-coordinate in view
     - works for fix-height fonts only"

    "/ care for visLineNr being nil during initialization
    ^ (((visLineNr ? 1) - 1) * fontHeight) + textStartTop
!

yVisibleToLineNr:yVisible
    |vL|

    vL := self visibleLineOfY:yVisible.
    ^ self visibleLineToListLine:vL

    "Created: / 20-09-2006 / 15:29:12 / cg"
! !

!ListView methodsFor:'queries'!

characterPositionOfLine:lineNr col:colArg
    "given a line/col position, return the character index within the contents-string,
     - used with compiler's error-positioning, which is based on character positions
     of the contents-string."

    |lineString charPos lineEndCharSize col|

    lineEndCharSize := self lineEndCRLF ifTrue:[2] ifFalse:[1].

    self checkForExistingLine:lineNr.
    charPos := 1.
    1 to:(lineNr - 1) do:[:lnr |
	lineString := self at:lnr.
	lineString notNil ifTrue:[
	    charPos := charPos + (lineString string) size
	].
	charPos := charPos + lineEndCharSize   "the return-character"
    ].

    "/ NEW: expand that line, so that characterAtCharacterPosition returns the correct character
"/ wrong: will modify!!
"/    (lineString := self at:lineNr) size < colArg ifTrue:[
"/        "/ expand this line
"/        self at:lineNr put:((lineString ? ''),(String new:colArg-lineString size)).
"/    ].

    "/ OLD: if beyond end of line, be careful to not advance into next line.
    "/ otherwise, syntaxHighlighter (and others) walk into trouble,
    "/ if clicked on a space beyond a line's end.
    col := colArg min:((self at:lineNr) size + 1).
    ^ charPos + col - 1

    "Modified: / 04-07-2006 / 19:14:25 / fm"
    "Modified: / 01-05-2016 / 15:48:24 / cg"
!

colOfCharacterPosition:charPos
    "given a character index within the contents-string,
     return the column number where the character is
     - used to find line to hilight from Compilers error-position"

    |line|

    line := self lineOfCharacterPosition:charPos.
    ^ charPos - (self characterPositionOfLine:line col:1) + 1.

!

currentLine
    "the current line (for relative gotos);
     since listViews have no cursor, the first shown line is returned here.
     Redefined in editTextView, to return the cursors line."

    ^ firstLineShown

    "Created: / 17.5.1998 / 20:07:36 / cg"
!

firstLineShown
    "return the index of the first (possibly partial) visible line"

    ^ firstLineShown
!

heightForLines:numberOfLines
    "return the height of the receiver, if numberOfLines are to be displayed"

    ^ numberOfLines * fontHeight + topMargin + gc deviceFont descent + lineSpacing + (margin * 2)

    "Created: 27.1.1996 / 16:55:39 / cg"
!

heightOfContents
    "return the height of the contents in pixels
     - used for scrollbar interface"

    |numLines|

    numLines := self numberOfLines.
    numLines == 0 ifTrue:[^ 0].

    "/
    "/ kludge for last partial line
    "/
"/    nFullLinesShown ~~ nLinesShown ifTrue:[
"/        numLines := numLines + 1
"/    ].
    ^ numLines * fontHeight "don't take font height here - think of LabelAndIcons"
"/                            + textStartTop
                            - (lineSpacing // 2)
                            + (gc deviceFont descent)
"/                            + (font descent * 2) "makes it look better"
                                .

"/    "it used to be that code - which is wrong"
"/    (nLinesShown == nFullLinesShown) ifTrue:[
"/        ^ numLines * fontHeight
"/    ].
"/    "add one - otherwise we cannot make last line
"/     fully visible since scrolling is done by full lines only"
"/
"/    ^ (numLines + 1) * fontHeight
!

lastLineShown
    "return the index of the last (possibly partial) visible line"

    ^ firstLineShown + nLinesShown
!

leftIndentOfLine:lineNr
    "return the number of spaces at the left in line, lineNr.
     returns 0 for empty lines."

    |lineString indent|

    lineString := self listAt:lineNr.
    lineString notNil ifTrue:[
	indent := lineString leftIndent.
	indent == lineString size ifTrue:[^ 0].
	^ indent.
    ].
    ^ 0

    "Modified: 20.4.1996 / 19:30:38 / cg"
!

lengthOfLongestLine
    "return the length (in characters) of the longest line"

    ^ self lengthOfLongestLineBetween:1 and:self size
!

lengthOfLongestLineBetween:firstLine and:lastLine
    "return the length (in characters) of the longest line in a line-range"

    |max      "{ Class: SmallInteger }"
     thisLen  "{ Class: SmallInteger }"
     listSize "{ Class: SmallInteger }"
     first    "{ Class: SmallInteger }"
     last     "{ Class: SmallInteger }" |

    list isNil ifTrue:[^ 0].

    listSize := self size.
    max := 0.
    first := firstLine.
    last := lastLine.

    (first > listSize) ifTrue:[^ max].
    (last > listSize) ifTrue:[
	last := listSize
    ].
    self from:first to:last do:[:lineString |
	lineString notNil ifTrue:[
	    thisLen := lineString size.
	    (thisLen > max) ifTrue:[
		max := thisLen
	    ]
	]
    ].
    ^ max

!

lineIsFullyVisible:line
    "is line fully visible?"

    (line >= firstLineShown
     and:[ line < (firstLineShown + nFullLinesShown) ]) ifTrue:[ ^ true ].
    ^ false.

    "Created: 26.4.1996 / 14:36:45 / cg"
!

lineIsVisible:line
    "is line visible?"

    (line >= firstLineShown and:[ line < (firstLineShown + nLinesShown) ]) ifTrue:[ ^ true ].
    ^ false.
!

lineOfCharacterPosition:charPos
    "given a character index within the contents-string,
     return the lineNumber where the character is
     - used to find line to hilight from compiler's error-position"

    |lineNr sum lastLine lineEndCharSize l|

    lineEndCharSize := self lineEndCRLF ifTrue:[2] ifFalse:[1].

    lineNr := 1.
    sum := 0.
    lastLine := self size.
    [(sum < charPos) and:[lineNr <= lastLine]] whileTrue:[
	l := (self at:lineNr) ? ''.
	sum := sum + (l string "withoutTrailingSeparators" size) + lineEndCharSize.
	lineNr := lineNr + 1
    ].
    sum == charPos ifTrue:[
	^ lineNr
    ].

    ^ (lineNr - 1) max:1

    "Modified: / 04-07-2006 / 19:13:32 / fm"
    "Modified: / 21-08-2011 / 10:50:12 / cg"
!

numberOfLines
    "return the number of lines the text has"

    ^ self size
!

preferredExtentForContents
    ^ (self widthOfContents @ self heightOfContents)
!

preferredExtentForLines:numLines cols:numCols
    ^ (((gc font widthOf:'x') * numCols + margin + margin)
      @
      (fontHeight * numLines + margin + margin + gc font descent + lineSpacing + topMargin)).

    "Modified: 26.5.1996 / 12:26:41 / cg"
!

supportsSyntaxElements
    "see CodeView2::TextView"

    ^ false
!

widthOfContents
    "return the width of the contents in pixels
     - used for scrollbar interface"

    |font start "{ Class: SmallInteger }"
     stop  "{ Class: SmallInteger }"
     lengthOfLongestString  "{ Class: SmallInteger }"
     lengthOfLongestLine    "{ Class: SmallInteger }"
     max   "{ Class: SmallInteger }"|

    list isEmptyOrNil ifTrue:[^ 0].
    widthOfWidestLine notNil ifTrue:[
        "/ already computed (cached); this cache is cleared when the contents is modified
        ^ widthOfWidestLine + (leftMargin * 2)
    ].

    font := gc deviceFont.
    
    checkedLinesForWidthOfContentsComputation isNil ifTrue:[
        start := 1.
        stop := list size
    ] ifFalse:[
        checkedLinesForWidthOfContentsComputation == 0 ifTrue:[
            start := firstLineShown.
            stop := (start + nLinesShown - 1) min:list size.
        ] ifFalse:[
            checkedLinesForWidthOfContentsComputation > 0 ifTrue:[
                start := 1.
                stop := (checkedLinesForWidthOfContentsComputation min:list size)
            ] ifFalse:[
                stop := list size.
                start := (list size + 1 + checkedLinesForWidthOfContentsComputation) max:1.
            ]
        ]
    ].

    includesNonStrings ifTrue:[
        max := 0.
        start to:stop do:[:lineNr |
            |entry w|

            entry := list at:lineNr.
            entry notNil ifTrue:[
                (entry isSingleByteString) ifTrue:[
                    w := font widthOf:entry
                ] ifFalse:[
                    w := entry widthOn:self
                ].
                max := max max:w.
             ].
        ].
    ] ifFalse:[
        fontIsFixedWidth ifTrue:[
            max := lengthOfLongestString := 0.
            list notNil ifTrue:[
                start to:stop do:[:lineNr |
                    |line|

                    line := list at:lineNr.
                    line notNil ifTrue:[
                        (line isSingleByteString) ifTrue:[
                            line size > lengthOfLongestString ifTrue:[
                                lengthOfLongestString := line size
                            ].
                        ] ifFalse:[
                            max := max max:(line widthOn:self)
                        ]
                    ]
                ].
                max := max max:(lengthOfLongestString * fontWidth)
            ].
        ] ifFalse:[
            max := lengthOfLongestLine := 0.
            list notNil ifTrue:[
                start to:stop do:[:lineNr |
                    |line len|

                    line := list at:lineNr ifAbsent:nil.
                    line notNil ifTrue:[
                        len := line size.
                        "/ consider this a speed hack (not exact, but fast)
                        lengthOfLongestLine := lengthOfLongestLine max:len.
                        len > (lengthOfLongestLine // 3) ifTrue:[
                            max := max max:(line widthOn:self)
                        ].
                    ]
                ].
            ].
        ].
    ].
    widthOfWidestLine := max.
    ^ max + (leftMargin * 2)

    "Modified: / 24.9.1998 / 18:21:08 / cg"
!

widthOfLine:lineNr
    "return the width of a line in pixels"

    |line|

    list isNil ifTrue:[^ 0].
    lineNr > list size ifTrue:[^ 0].
    line := list at:lineNr.
    line isNil ifTrue:[^ 0].
    ^ self widthOfLineString:line

    "Created: / 10.11.1998 / 23:59:20 / cg"
    "Modified: / 11.11.1998 / 15:25:07 / cg"
!

xOriginOfContents
    "return the horizontal origin of the contents in pixels
     - used for scrollbar interface"

    ^ viewOrigin x
!

yOriginOfContents
    "return the vertical origin of the contents in pixels
     - used for scrollbar interface"

    ^ (firstLineShown - 1) * fontHeight
! !

!ListView methodsFor:'redrawing'!

flash
    "show contents in reverse colors for a moment - to wakeup the user :-)"

    super flash.
"/    self redrawInverted.
"/    Delay waitForSeconds:0.1.
"/    self redraw

    "
     Transcript flash
     Transcript redrawInverted
     Transcript redraw
    "
!

redraw
    "redraw complete view"

    shown ifTrue:[
	self redrawFromVisibleLine:1 to:nLinesShown
    ]
!

redrawFromLine:lineNr
    "redraw starting at linrNr"

    |visibleLine first|

    shown ifTrue:[
	"if first line to redraw is above 1st visible line,
	 start redraw at 1st visible line"
	(lineNr < firstLineShown) ifTrue:[
	    first := firstLineShown
	] ifFalse:[
	    first := lineNr
	].
	visibleLine := self listLineToVisibleLine:first.
	visibleLine notNil ifTrue:[
	    self redrawFromVisibleLine:visibleLine to:nLinesShown
	]
    ]
!

redrawFromLine:startLine col:startCol toLine:endLine col:endCol
    shown ifTrue:[
	self redrawLine:startLine from:startCol.
	endLine > (startLine+1) ifTrue:[
	    self redrawFromLine:startLine+1 to:endLine-1
	].
	self redrawLine:endLine from:1 to:endCol.
    ]
!

redrawFromLine:start to:end
    "redraw lines from start to end"

    |visibleFirst visibleLast first last lastLineShown|

    shown ifTrue:[
	lastLineShown := firstLineShown + nLinesShown - 1.
	(start <= lastLineShown) ifTrue:[
	    (end >= firstLineShown) ifTrue:[

		"if first line to redraw is above 1st visible line,
		 start redraw at 1st visible line"

		(start < firstLineShown) ifTrue:[
		    first := firstLineShown
		] ifFalse:[
		    first := start
		].
		(end > lastLineShown) ifTrue:[
		    last := lastLineShown
		] ifFalse:[
		    last := end
		].
		visibleFirst := self listLineToVisibleLine:first.
		visibleLast := self listLineToVisibleLine:last.
		self redrawFromVisibleLine:visibleFirst to:visibleLast
	    ]
	]
    ]
!

redrawFromVisibleLine:startVisLineNr to:endVisLineNr
    "redraw a visible line range"

    shown ifTrue:[
	self drawFromVisibleLine:startVisLineNr to:endVisLineNr with:fgColor and:bgColor
    ]
!

redrawInverted
    "show contents in reverse colors"

    |savFg savBg|

    savFg := fgColor.
    savBg := bgColor.
    fgColor := savBg.
    bgColor := savFg.
    self redraw.
    fgColor := savFg.
    bgColor := savBg.
!

redrawLine:lineNr
    "redraw a list line"

    |visibleLine|

    visibleLine := self listLineToVisibleLine:lineNr.
    visibleLine notNil ifTrue:[
	self redrawVisibleLine:visibleLine
    ]
!

redrawLine:lineNr col:col
    "redraw a single character"

    |visibleLine|

    visibleLine := self listLineToVisibleLine:lineNr.
    visibleLine notNil ifTrue:[
	self redrawVisibleLine:visibleLine col:col
    ]
!

redrawLine:lineNr from:startCol
    "redraw a list line from startCol to end of line"

    |visibleLine|

    visibleLine := self listLineToVisibleLine:lineNr.
    visibleLine notNil ifTrue:[
	self redrawVisibleLine:visibleLine from:startCol
    ]
!

redrawLine:lineNr from:startCol to:endCol
    "redraw a list line from startCol to endCol"

    |visibleLine|

    visibleLine := self listLineToVisibleLine:lineNr.
    visibleLine notNil ifTrue:[
	self redrawVisibleLine:visibleLine from:startCol to:endCol
    ]
!

redrawVisibleLine:visLineNr
    "redraw a visible line"

    shown ifTrue:[
	self drawVisibleLine:visLineNr with:fgColor and:bgColor
    ]
!

redrawVisibleLine:visLineNr col:col
    "redraw single character at col index of visible line"

    shown ifTrue:[
	self drawVisibleLine:visLineNr col:col with:fgColor and:bgColor
    ]
!

redrawVisibleLine:visLineNr from:startCol
    "redraw right part of a visible line from startCol to end of line"

    shown ifTrue:[
	self drawVisibleLine:visLineNr from:startCol with:fgColor and:bgColor
    ]
!

redrawVisibleLine:visLineNr from:startCol to:endCol
    "redraw part of a visible line"

    shown ifTrue:[
	startCol == endCol ifTrue:[
	    self redrawVisibleLine:visLineNr col:startCol
	] ifFalse:[
	    self drawVisibleLine:visLineNr from:startCol to:endCol with:fgColor and:bgColor
	]
    ]
! !

!ListView methodsFor:'scrolling'!

gotoLine:aLineNumber
    "position to line aLineNumber; this may be redefined
     in subclasses (for example to move the cursor also)"

    ^ self scrollToLine:aLineNumber
!

halfPageDown
    "scroll down half a page"

    self scrollDown:(nFullLinesShown // 2)
!

halfPageUp
    "scroll up half a page"

    self scrollUp:(nFullLinesShown // 2)
!

horizontalScrollStep
    "return the amount to scroll when stepping up/down.
     Here, the scrolling unit is characters."

    ^ gc font width

    "Created: / 21.5.1999 / 15:55:06 / cg"
!

makeColVisible:aCol inLine:aLineNr
    "if column aCol is not visible, scroll horizontal to make it visible"

    |xWant xVis visLnr|

    (aCol isNil or:[shown not]) ifTrue:[^ self].

    visLnr := self listLineToVisibleLine:aLineNr.
    visLnr isNil ifTrue:[^ self].

    xWant := self xOfCol:aCol inVisibleLine:visLnr.
    xVis := xWant - viewOrigin x.

    "
     don't scroll, if already visible
     (but scroll, if not in inner 20%..80% of visible area)
    "
"/    ((xVis >= (width // 5)) and:[xVis <= (width * 4 // 5)]) ifTrue:[
"/        ^ self
"/    ].

    "
     no, the above does not look good, if you click / select at the
     far right - makes selecting so difficult ...
    "
    (xVis >= 0 and:[xVis < (width - gc font width)]) ifTrue:[^ self].

    self scrollHorizontalTo:(xWant - (width // 2)).
!

makeLineVisible:aListLineNr
    "if aListLineNr is not visible, scroll to make it visible.
     Numbering starts with 1 for the very first line of the text."

    |bott newTopLine|

    (aListLineNr isNil "or:[shown not]") ifTrue:[^ self].

"/  Old code follows. It is no longer used, because:
"/      1. we must maintain our viewOrigin (not maintained in this code!!)
"/      2. we must inform our dependents about originChanges.
"/
"/    shown ifFalse:[
"/        firstLineShown := (aListLineNr - 1) max:1.
"/        firstLineShown > (list size - nFullLinesShown) ifTrue:[
"/            firstLineShown := list size - nFullLinesShown
"/        ].
"/        list size <= nFullLinesShown ifTrue:[
"/            firstLineShown := 1
"/        ].
"/        ^ self
"/    ].

    (self needScrollToMakeLineVisible:aListLineNr) ifFalse:[
	^ self
    ].

    (aListLineNr < nFullLinesShown) ifTrue:[
	"/ at the very top of the list - show from top
	newTopLine := 1
    ] ifFalse:[
	(nFullLinesShown < 3) ifTrue:[
	    "/ a small view - show from that line
	    newTopLine := aListLineNr
	] ifFalse:[
	    bott := self numberOfLines - (nFullLinesShown - 1).
	    (aListLineNr > bott) ifTrue:[
		"/ at the end of the list - show the bottom of the list
		newTopLine := bott
	    ] ifFalse:[
		"/ somewhere else - place selected line into the middle of
		"/ the view
		newTopLine := (aListLineNr - (nFullLinesShown // 2) + 1)
	    ]
	]
    ].

    self scrollToLine:newTopLine.

    "Modified: / 18.12.1996 / 17:48:22 / stefan"
    "Modified: / 7.8.1998 / 15:14:12 / cg"
!

makeVisible:someString
    "if nescessary, scroll to make the (first)
     line containing someString visible."

    |index list|

    (list := self list) notNil ifTrue:[
	index := list indexOf:someString.
	index ~~ 0 ifTrue:[
	    self makeLineVisible:index
	]
    ]

    "Modified: 9.9.1997 / 10:10:13 / cg"
!

needScrollToMakeLine:aListLineNr
    "return true, if a scroll is needd to make a line visible.
     Numbering starts with 1 for the very first line of the text."

    (aListLineNr >= firstLineShown) ifTrue:[
	(aListLineNr < (firstLineShown + nFullLinesShown)) ifTrue:[
	    ^ false
	]
    ].
    ^ true

    "Created: / 7.8.1998 / 15:13:51 / cg"
    "Modified: / 7.8.1998 / 15:14:44 / cg"
!

needScrollToMakeLineVisible:aListLineNr
    "return true, if a scroll is needd to make a line visible.
     Numbering starts with 1 for the very first line of the text."

    (aListLineNr >= firstLineShown) ifTrue:[
	(aListLineNr < (firstLineShown + nFullLinesShown)) ifTrue:[
	    ^ false
	]
    ].
    ^ true

    "Created: / 7.8.1998 / 15:13:51 / cg"
    "Modified: / 7.8.1998 / 15:14:44 / cg"
!

pageDown
    "change origin to display the next page"

    "/ self scrollTo:(viewOrigin + (0 @ height))
    self scrollToLine:(self firstLineShown + nFullLinesShown)

    "Modified: / 15-12-2010 / 10:12:37 / cg"
!

pageUp
    "change origin to display the previous page"

    "/ self scrollTo:(viewOrigin - (0 @ height))
    self scrollToLine:(self firstLineShown - nFullLinesShown)

    "Modified: / 15-12-2010 / 10:12:41 / cg"
!

scrollDown:nLines
    "change origin to scroll down some lines (towards the bottom of the text)"

    nLines ~~ 0 ifTrue:[
	self scrollTo:(viewOrigin + (0 @ (fontHeight * nLines)))
	       redraw:true
    ]

    "Modified: / 21.5.1999 / 15:59:52 / cg"
!

scrollDownPixels:pix
    "change origin to scroll down some pixels
     (towards the bottom of the text)
     THIS WILL VANISH!!"

    pix > 0 ifTrue:[
	self scrollTo:(viewOrigin + (0 @ (pix abs))) redraw:true
    ]


!

scrollHorizontalTo:aPixelOffset
    "change origin to make aPixelOffset be the left col"

    |nPixel|

    nPixel := aPixelOffset - viewOrigin x.
    nPixel ~~ 0 ifTrue:[
	self scrollTo:(viewOrigin + (nPixel @ 0)) redraw:true
    ]

    "Modified: / 3.3.1999 / 22:55:20 / cg"
!

scrollLeft:nPixel
    "change origin to scroll left some cols"

    nPixel ~~ 0 ifTrue:[
	self scrollTo:(viewOrigin - (nPixel @ 0)) redraw:true
    ]

    "Modified: / 21.5.1999 / 15:59:16 / cg"
!

scrollRight:nPixel
    "change origin to scroll right some cols"

    nPixel ~~ 0 ifTrue:[
	self scrollTo:(self viewOrigin + (nPixel @ 0)) redraw:true
    ]

    "Modified: / 21.5.1999 / 15:59:21 / cg"
!

scrollSelectDown
    "just a template - I do not know anything about selections"

    ^ self subclassResponsibility
!

scrollSelectUp
    "just a template - I do not know anything about selections"

    ^ self subclassResponsibility
!

scrollToBottom
    "change origin to show end of text"

    "scrolling to the end is not really correct (i.e. should scroll to list size - nFullLinesShown),
     but scrollDown: will adjust it ..."

    self scrollToLine:(self size)
!

scrollToCol:aColNr
    "change origin to make aColNr be the left col"

    |pxlOffset leftOffset|

    leftOffset := viewOrigin x.

    aColNr == 1 ifTrue:[
        leftOffset ~~ 0 ifTrue:[
            self scrollLeft:leftOffset.
        ].
        ^ self
    ].

    pxlOffset := gc font width * (aColNr - 1).

    pxlOffset < leftOffset ifTrue:[
        self scrollLeft:(leftOffset - pxlOffset)
    ] ifFalse:[
        pxlOffset > leftOffset ifTrue:[
            self scrollRight:(pxlOffset - leftOffset)
        ]
    ]
!

scrollToLeft
    "change origin to start (left) of text"

    viewOrigin x ~~ 0 ifTrue:[
	self scrollToCol:1
    ]
!

scrollToLine:aLineNr
    "change origin to make aLineNr be the top line"

    aLineNr < firstLineShown ifTrue:[
	self scrollUp:(firstLineShown - aLineNr)
    ] ifFalse:[
	aLineNr > firstLineShown ifTrue:[
	    self scrollDown:(aLineNr - firstLineShown)
	]
    ]
!

scrollToPercent:percentOrigin
    "scroll to a position given in percent of total"

    "kludge - ListView thinks in lines"

    self scrollHorizontalToPercent:percentOrigin x.
    self scrollVerticalToPercent:percentOrigin y.
!

scrollToTop
    "change origin to start of text"

    self scrollToLine:1
!

scrollUp:nLines
    "change origin to scroll up some lines (towards the top of the text)"

    nLines ~~ 0 ifTrue:[
	self scrollTo:(viewOrigin - (0 @ (fontHeight * nLines)))
	       redraw:true
    ]

    "Modified: / 21.5.1999 / 15:59:45 / cg"
!

scrollUpPixels:pix
    "change origin to scroll up some pixels
     (towards the top of the text)
    THIS WILL VANISH!!"

    pix > 0 ifTrue:[
	self scrollTo:(viewOrigin - (0 @ pix)) redraw:true
    ]


!

scrollVerticalToPercent:percent
    "scroll to a position given in percent of total"

    |nL lineNr|

    nL := self numberOfLines.
    "/
    "/ kludge for last partial line
    "/
    nFullLinesShown ~~ nLinesShown ifTrue:[
	nL := nL + 1
    ].
    lineNr := (((nL * percent) asFloat / 100.0) + 0.5) asInteger + 1.
    self scrollToLine:lineNr
!

startAutoScrollDown:yDistance
    "setup for auto-scroll down (when button-press-moving below view)
     - timeDelta for scroll is computed from distance.
     Return true, to tell caller that scrolling is allowed (redefined in editField)"

    self
	startAutoScrollVertical:yDistance
	scrollSelector:#scrollSelectDown.
    ^ true
!

startAutoScrollHorizontal:xDistance scrollSelector:scrollSelector
    "setup for auto-scroll left/right (when button-press-moving to the right of the view)
     - timeDelta for scroll is computed from distance"

    |deltaT mm|

    autoScroll ifFalse:[^ self].

    mm := xDistance // self horizontalIntegerPixelPerMillimeter + 1.
    deltaT := 0.5 / mm.

    (deltaT = autoScrollDeltaT) ifFalse:[
	autoScrollDeltaT := deltaT.
	autoScrollBlock isNil ifTrue:[
	    autoScrollBlock := [self realized ifTrue:[self perform:scrollSelector]].
	    Processor addTimedBlock:autoScrollBlock afterSeconds:deltaT
	]
    ]
!

startAutoScrollLeft:xDistance
    "setup for auto-scroll up (when button-press-moving to the left of the view)
     - timeDelta for scroll is computed from distance"

    self
	startAutoScrollHorizontal:xDistance negated
	scrollSelector:#scrollSelectLeft.
    ^ true
!

startAutoScrollRight:xDistance
    "setup for auto-scroll down (when button-press-moving to the right of the view)
     - timeDelta for scroll is computed from distance"

    self
	startAutoScrollHorizontal:xDistance
	scrollSelector:#scrollSelectRight.
    ^ true
!

startAutoScrollUp:yDistance
    "setup for auto-scroll up (when button-press-moving below view)
     - timeDelta for scroll is computed from distance.
     Return true, to tell caller that scrolling is allowed (redefined in editField)"

    self
	startAutoScrollVertical:yDistance negated
	scrollSelector:#scrollSelectUp.
    ^ true
!

startAutoScrollVertical:yDistance scrollSelector:scrollSelector
    "setup for auto-scroll up (when button-press-moving below view)
     - timeDelta for scroll is computed from distance"

    |deltaT mm|

    autoScroll ifFalse:[^ self].

    mm := (yDistance abs // self verticalIntegerPixelPerMillimeter) + 1.
    deltaT := 0.5 / mm.

    (deltaT = autoScrollDeltaT) ifFalse:[
	autoScrollDeltaT := deltaT.
	autoScrollBlock isNil ifTrue:[
	    autoScrollBlock := [self realized ifTrue:[self perform:scrollSelector]].
	    Processor addTimedBlock:autoScrollBlock afterSeconds:deltaT
	]
    ]

    "Modified: / 08-08-2010 / 11:26:26 / cg"
!

stopAutoScroll
    "stop any auto-scroll"

    autoScrollBlock notNil ifTrue:[
	self compressMotionEvents:true.
	Processor removeTimedBlock:autoScrollBlock.
	autoScrollBlock := nil.
	autoScrollDeltaT := nil
    ].
!

verticalScrollStep
    "return the amount to scroll when stepping up/down.
     Here, the scrolling unit is lines."

    ^ 1

    "Created: / 21.5.1999 / 14:00:12 / cg"
!

viewOrigin
    "return the viewOrigin; 
     that's the coordinate of the contents which is shown topLeft in the view
     (i.e. the origin of the visible part of the contents)."

    ^ viewOrigin
! !

!ListView methodsFor:'scrolling-basic'!

additionalMarginForHorizontalScroll
    "return the number of pixels by which we may scroll more than the actual
     width of the document would allow.
     This is redefined by editable textViews, to allo for the cursor
     to be visible if it is positioned right behind the longest line of text.
     The default returned here is the width of a blank (to beautify italic text)"

    ^ gc font width
!

scrollTo:anOrigin redraw:doRedraw
    "change origin to have newOrigin be visible at the top-left.
     The argument defines the integer device coordinates of the new top-left
     point.
    "
    |dltOrg
     noLn "{ Class:SmallInteger }"
     max  "{ Class:SmallInteger }"
     tmp  "{ Class:SmallInteger }"
     h    "{ Class:SmallInteger }"
     w    "{ Class:SmallInteger }"
     y0   "{ Class:SmallInteger }"
     y1   "{ Class:SmallInteger }"
     y    "{ Class:SmallInteger }"
     x    "{ Class:SmallInteger }"
     delta newFirstLine newViewOrigin
     hBefore wBefore inv wg|

    hBefore := height.
    wBefore := width.

    dltOrg := anOrigin - viewOrigin.

"/  compute valid horizontal offset x

    (x := dltOrg x) ~~ 0 ifTrue:[
	tmp := viewOrigin x + x.

	x < 0 ifTrue:[                                          "/ scrolling left
	    tmp < 0 ifTrue:[x := 0 - viewOrigin x]
	] ifFalse:[                                             "/ scrolling right
	 "/ allows scrolling to the right of widest line
	    max := self widthOfContents + (self additionalMarginForHorizontalScroll).

	    tmp + width > max ifTrue:[
		x := (max - viewOrigin x - width) max:0
	    ]
	]
    ].

"/  compute valid vertical offset measured in lines

    (y := dltOrg y // fontHeight) ~~ 0 ifTrue:[
	tmp := firstLineShown + y.

	y < 0 ifTrue:[                                          "/ scrolling up
	    tmp < 1 ifTrue:[y := 1 - firstLineShown]
	] ifFalse:[                                             "/ scrolling down
	    max := self size.

	    tmp + nFullLinesShown > max ifTrue:[
		y := (max - firstLineShown - nFullLinesShown + 1) max:0
	    ]
	]
    ].

    (x == 0 and:[y == 0]) ifTrue:[                              "/ has viewOrigin changed ?
	^ self
    ].

    (noLn := y) ~~ 0 ifTrue:[
	y := y * fontHeight
    ].
    delta := (x @ y).

    newFirstLine := firstLineShown + noLn.
    newViewOrigin := viewOrigin + delta.

    (shown and:[doRedraw]) ifFalse:[
	self originWillChange.
	firstLineShown := newFirstLine.
	viewOrigin := newViewOrigin.
	self assert:(viewOrigin x >= 0).
	^ self originChanged:delta
    ].

"/    (self sensor notNil and: [self sensor hasExposeEventFor:self]) ifTrue:[               "/ outstanding expose events
"/        self invalidate.                                        "/ redraw all
"/        self originWillChange.
"/        ^ self originChanged:(x @ y )
"/    ].

    (     (y ~~ 0 and:[x ~~ 0])         "/ both x and y changed
      or:[(noLn abs) >= nLinesShown     "/ at least one area is
      or:[(x abs) > (width // 4 * 3)]]  "/ big enough to redraw all
    ) ifTrue:[
	self originWillChange.
	firstLineShown := newFirstLine.
	viewOrigin := newViewOrigin.
	self invalidate.
	^ self originChanged:delta
    ].

    "/ OLD:
    "/ self repairDamage.

    (wg := self windowGroup) notNil ifTrue:[
	wg processRealExposeEventsFor:self.
    ].

    self originWillChange.

    "/ make certain, that all drawing is complete
    "/ device sync.

    self catchExpose.

    x == 0 ifTrue:[
	"/ scrolling vertical

	y0 := textStartTop + (y abs).
	h  := hBefore - margin - y0.
	w  := wBefore - margin.
	y > 0 ifTrue:[                                          "/ copy down
	    "/ kludge: if the selection highlighting draws into the textStartTop area,
	    "/ the copy below leaves some selection depris in the top area.
	    "/ Therefore, clear the top area.
	    "/ (should avoid this, in case we know there cannot be anything
	    "/  there - selection is nil or >= firstLineShown).
	    self clearDeviceRectangleX:margin y:margin width:width-margin-margin height:(textStartTop-margin).
"/            self invalidateDeviceRectangle:((margin@margin) corner:(width-margin@textStartTop)) repairNow:false.

	    self copyFrom:self
			x:0 y:y0 toX:0 y:textStartTop
		    width:w height:h async:true.
	    y1 := h - 1.
	    y0 := y0 + 1.
	] ifFalse:[                                             "/ copy up
	    self copyFrom:self
			x:margin y:textStartTop toX:margin y:y0
		    width:w height:h async:true.
	    y1 := 0.
	].

	inv := (margin@y1) extent:(w@y0+margin).
    ] ifFalse:[
	"/ scrolling horizontal

	x > 0 ifTrue:[                                          "/ scrolling right
	    y0 := margin + x.
	    y1 := wBefore - y0.
	] ifFalse:[                                             "/ scrolling left
	    y0 := margin - x.
	    y1 := 0.
	].
	h := hBefore - margin - margin.
	w := wBefore - margin - y0.

	x > 0 ifTrue:[                                          "/ copy right
	    self copyFrom:self x:y0 y:margin toX:margin y:margin
		    width:w height:h async:true.
	] ifFalse:[                                             "/ copy left
	    "/ self copyFrom:self x:textStartLeft y:margin toX:y0 y:margin
"/            viewOrigin x > margin ifTrue:[
"/                self copyFrom:self x:0 y:margin toX:y0-margin y:margin
"/                        width:w height:h async:true.
"/            ] ifFalse:[
		self copyFrom:self x:margin y:margin toX:y0 y:margin
			width:w height:h async:true.
"/            ].
	].

	inv := (y1@margin) extent:(y0@h).
    ].

    firstLineShown := newFirstLine.
    viewOrigin := newViewOrigin.

    self invalidateDeviceRectangle:inv repairNow:false.
    viewOrigin x <= margin ifTrue:[
	self invalidateDeviceRectangle:((0@margin) extent:(margin@h)) repairNow:false.
    ].

    self originChanged:delta.
    self waitForExpose.

    (wg := self windowGroup) notNil ifTrue:[
	wg processRealExposeEventsFor:self.
    ].

"/    (hBefore ~= height or:[wBefore ~= width]) ifTrue:[
"/        self halt.
"/    ].

    "Modified: / 08-08-2010 / 11:14:09 / cg"
! !

!ListView methodsFor:'searching'!

findBeginOfWordAtLine:selectLine col:selectCol
    "return the col of first character of the word at given line/col.
     If the character under the initial col is a space character, return
     the first col of the blank-block."

    |beginCol thisCharacter|

    beginCol := selectCol.
    thisCharacter := self characterAtLine:selectLine col:beginCol.

    "is this acharacter within a word ?"
    (wordCheck value:thisCharacter) ifTrue:[
	[wordCheck value:thisCharacter] whileTrue:[
	    beginCol := beginCol - 1.
	    beginCol < 1 ifTrue:[
		^ 1
	    ].
	    thisCharacter := self characterAtLine:selectLine col:beginCol
	].
	beginCol := beginCol + 1.
    ] ifFalse:[
	"nope - maybe its a space"
	thisCharacter == Character space ifTrue:[
	    [beginCol > 1 and:[thisCharacter == Character space]] whileTrue:[
		beginCol := beginCol - 1.
		thisCharacter := self characterAtLine:selectLine col:beginCol
	    ].
	    thisCharacter ~~ Character space ifTrue:[
		beginCol := beginCol + 1.
	    ].
	] ifFalse:[
	    "select single character"
	]
    ].
    ^ beginCol
!

findEndOfWordAtLine:selectLine col:selectCol
    "return the col of last character of the word at given line/col.
     If the character under the initial col is a space character, return
     the last col of the blank-block.
     Return 0 if we should wrap to next line (for spaces)"

    |endCol "{ Class: SmallInteger }"
     len    "{ Class: SmallInteger }"
     thisCharacter|

    endCol := selectCol.
    endCol == 0 ifTrue:[endCol := 1].
    thisCharacter := self characterAtLine:selectLine col:endCol.

    len := (self listAt:selectLine) size.

    "is this acharacter within a word ?"
    (wordCheck value:thisCharacter) ifTrue:[
	[wordCheck value:thisCharacter] whileTrue:[
	    endCol := endCol + 1.
	    endCol > len ifTrue:[ ^ len ].
	    thisCharacter := self characterAtLine:selectLine col:endCol
	].
	endCol := endCol - 1.
    ] ifFalse:[
	"nope - maybe its a space"
	thisCharacter == Character space ifTrue:[
	    endCol > len ifTrue:[
		"select rest to end"
		endCol := 0
	    ] ifFalse:[
		thisCharacter := self characterAtLine:selectLine col:endCol.
		[endCol <= len and:[thisCharacter == Character space]] whileTrue:[
		    endCol := endCol + 1.
		    thisCharacter := self characterAtLine:selectLine col:endCol
		].
		endCol := endCol - 1.
	    ]
	] ifFalse:[
	    "select single character"
	]
    ].
    ^ endCol.
!

searchBackwardFor:pattern ignoreCase:ignCase startingAtLine:startLine col:startCol ifFound:block1 ifAbsent:block2
    "search for a pattern, if found evaluate block1 with row/col as arguments, if not
     found evaluate block2.
     Sorry, but pattern is no regular expression pattern (yet)"

    ^ self
	searchBackwardUsingSpec:(SearchSpec new
					pattern:pattern
					ignoreCase:ignCase
					match:false)
	startingAtLine:startLine col:startCol
	ifFound:block1 ifAbsent:block2
!

searchBackwardFor:pattern startingAtLine:startLine col:startCol ifFound:block1 ifAbsent:block2
    "search for a pattern, if found evaluate block1 with row/col as arguments, if not
     found evaluate block2.
     Sorry, but pattern is no regular expression pattern (yet)"

    ^ self
	searchBackwardFor:pattern
	ignoreCase:false
	startingAtLine:startLine col:startCol
	ifFound:block1
	ifAbsent:block2

    "Modified: 13.9.1997 / 01:07:36 / cg"
!

searchBackwardUsingSpec:searchSpec startingAtLine:startLine col:startCol ifFound:block1 ifAbsent:block2
    "search for a pattern, if found evaluate block1 with row/col as arguments, if not
     found evaluate block2.
     Sorry, but pattern is no regular expression pattern (yet).
     Also, wraps are not done when searching backward."

    |lineString
     pattern ignCase match fullWord atBeginOfLineOnly
     found firstChar1 firstChar2 c pc col1
     col         "{ Class: SmallInteger }"
     cc          "{ Class: SmallInteger }"
     patternSize "{ Class: SmallInteger }"
     line1       "{ Class: SmallInteger }"
     lineSize    "{ Class: SmallInteger }" |

    pattern := searchSpec pattern.
    ignCase := searchSpec ignoreCase.
    match := searchSpec match.
    match ifTrue:[ Transcript showCR:'backward matchsearch is (still) not implemented' ].
    fullWord := searchSpec fullWord.
    atBeginOfLineOnly := searchSpec atBeginOfLineOnly.

    patternSize := pattern size.
    (list notNil
    and:[startLine > 0
    and:[patternSize ~~ 0]])
    ifTrue:[
	self withCursor:Cursor questionMark do:[
	    col := startCol - 1.
	    firstChar1 := pattern at:1.
	    ignCase ifTrue:[
		firstChar1 := firstChar1 asLowercase.
		firstChar2 := firstChar1 asUppercase.
	    ] ifFalse:[
		firstChar2 := firstChar1
	    ].

	    line1 := startLine.
	    line1 > list size ifTrue:[
		line1 := list size.
		col := -999
	    ] ifFalse:[
		col > (list at:line1) size ifTrue:[
		    col := -999
		]
	    ].
	    line1 to:1 by:-1 do:[:lnr |
		lineString := list at:lnr.
		lineString notNil ifTrue:[
		    lineString := lineString asString.
		    lineString isString ifTrue:[
			"/ quick check if pattern is present
			col1 := lineString
				findString:pattern startingAt:1
				ifAbsent:0 caseSensitive: ignCase not.
			col1 ~~ 0 ifTrue:[
			    lineSize := lineString size.
			    col == -999 ifTrue:[col := lineSize - patternSize + 1].
			    [(col > 0)
			     and:[(c := lineString at:col) ~= firstChar1
			     and:[c ~= firstChar2]]] whileTrue:[
				col := col - 1
			    ].
			    [col > 0] whileTrue:[
				cc := col.
				found := true.
				1 to:patternSize do:[:cnr |
				    cc > lineSize ifTrue:[
					found := false
				    ] ifFalse:[
					pc := pattern at:cnr.
					c := lineString at:cc.
					pc ~= c ifTrue:[
					    (ignCase not or:[pc asLowercase ~= c asLowercase]) ifTrue:[
						found := false
					    ]
					]
				    ].
				    cc := cc + 1
				].
				found ifTrue:[
				    (fullWord not
					or:[ (self findBeginOfWordAtLine:lnr col:col) == col
					      and:[ (self findEndOfWordAtLine:lnr col:col) == (col + patternSize - 1) ]]
				    ) ifTrue:[
					(atBeginOfLineOnly not or:[col == 1]) ifTrue:[
					    ^ block1 value:lnr value:col optionalArgument:nil.
					]
				    ]
				].
				col := col - 1.
				[(col > 0)
				and:[(c := lineString at:col) ~= firstChar1
				and:[c ~= firstChar2]]] whileTrue:[
				    col := col - 1
				]
			    ]
			]
		    ].
		].
		col := -999.
	    ]
	]
    ].
    "not found"

    ^ block2 value

    "Created: / 13-09-1997 / 01:06:19 / cg"
    "Modified: / 05-08-2012 / 12:16:31 / cg"
!

searchForwardFor:pattern ignoreCase:ignCase match:match startingAtLine:startLine col:startCol ifFound:block1 ifAbsent:block2
    "search for a pattern, if found evaluate block1 with row/col as arguments, if not
     found evaluate block2."

    ^ self
	searchForwardUsingSpec:(SearchSpec new
				    pattern:pattern
				    ignoreCase:ignCase
				    match:match)
	startingAtLine:startLine col:startCol
	ifFound:block1 ifAbsent:block2
!

searchForwardFor:pattern ignoreCase:ignCase startingAtLine:startLine col:startCol ifFound:block1 ifAbsent:block2
    "search for a pattern, if found evaluate block1 with row/col as arguments, if not
     found evaluate block2."

    ^ self searchForwardFor:pattern ignoreCase:ignCase match: true startingAtLine:startLine col:startCol ifFound:block1 ifAbsent:block2
!

searchForwardFor:pattern startingAtLine:startLine col:startCol ifFound:block1 ifAbsent:block2
    "search for a pattern, if found evaluate block1 with row/col as arguments, if not
     found evaluate block2."

    ^ self
	searchForwardFor:pattern
	ignoreCase:false
	startingAtLine:startLine col:startCol
	ifFound:block1
	ifAbsent:block2

    "Modified: 13.9.1997 / 01:07:11 / cg"
!

searchForwardUsingSpec:searchSpec startingAtLine:startLine col:startCol ifFound:block1 ifAbsent:block2
    "search for a pattern, if found evaluate block1 with row/col as arguments,
     if not found evaluate block2.
     If the block is a three-arg block, it gets the end-col (or nil, if not known)"

    |lineString col pattern match regexMatch ignCase fullWord atBeginOfLineOnly
     wrapAtEndOfText patternSize matcher lnr   "{Class: SmallInteger}"
     line1 "{Class: SmallInteger}"
     line2 "{Class: SmallInteger}"
     p realPattern runner foundCol endCol|

    pattern := searchSpec pattern.
    match := searchSpec match.
    regexMatch := searchSpec regexMatch.
    (match and:[regexMatch not]) ifTrue:[
	pattern := pattern globPatternAsRegexPattern.
	regexMatch := true.
    ].
    ignCase := searchSpec ignoreCase.
    fullWord := searchSpec fullWord.
    atBeginOfLineOnly := searchSpec atBeginOfLineOnly.
    wrapAtEndOfText := searchSpec wrapAtEndOfText.

    patternSize := pattern size.
    (list notNil and:[patternSize ~~ 0]) ifTrue:[
	self withCursor:Cursor questionMark do:[

	    col := startCol + 1.
	    line1 := startLine.
	    line2 := list size.

	    "/ call searchBlock with lnr, col, and line. Cares for wrap
	    runner :=
		[:searchBlock |
		    |didWrap|

		    lnr := line1.
		    didWrap := false.
		    [lnr <= line2] whileTrue:[
			lineString := list at:lnr.
			lineString notNil ifTrue:[
			    lineString := lineString asString string.
			    lineString isString ifTrue:[
				searchBlock value:lnr value:col value:lineString
			    ]
			].
			col := 1.
			lnr := lnr + 1.
			lnr > line2 ifTrue:[
			    (wrapAtEndOfText and:[didWrap not]) ifTrue:[
				didWrap := true.
				lnr := 1.
				line2 := line1-1.
			    ].
			].
		   ].

		].

	    (match and:[regexMatch]) ifTrue:[
		"perform a findMatchString (regex matching)"
		Regex::RxParser isNil ifTrue:[
		    Smalltalk loadPackage:'stx:goodies/regex'
		].
		matcher := ignCase ifTrue:[pattern asRegexIgnoringCase] ifFalse:[pattern asRegex].
		runner
		    value:[:lnr :col :lineString |
			"/ first a crude check ...
			(matcher hasMatchesIn:lineString) ifTrue:[
			    "/ find which match to show
			    1 to:matcher subexpressionCount do:[:i |
				foundCol := matcher subBeginning:i.
				endCol := matcher subEnd:i.
				(foundCol notNil and: [endCol notNil]) ifTrue: [
				    foundCol := foundCol + 1. "/ regex uses 0-based indexes (sigh)
				    foundCol >= col ifTrue:[
					(atBeginOfLineOnly not or:[foundCol == 1]) ifTrue:[
					    ^ block1 value:lnr value:foundCol optionalArgument:endCol.
					]]]]]].
	    ] ifFalse:[
		(match and:[pattern includesUnescapedMatchCharacters]) ifTrue:[
		    "perform a findMatchString (glob matching)"
		    p := pattern species new:0.
		    (pattern startsWith:$*) ifFalse:[p := p , '*'].
		    p := p , pattern.
		    (pattern endsWith:$*) ifFalse:[p := p , '*'].
		    realPattern := pattern.
		    (realPattern startsWith:$*) ifTrue:[
			realPattern := realPattern copyFrom:2
		    ].
		    runner
			value:[:lnr :col :lineString |
			    (p match:lineString caseSensitive:ignCase not) ifTrue:[
				"/ ok, there it is; look at which position
				foundCol := lineString
					findMatchString:realPattern startingAt:col
					caseSensitive:ignCase not ifAbsent:0.
				foundCol ~~ 0 ifTrue:[
				    (atBeginOfLineOnly not or:[foundCol == 1]) ifTrue:[
					^ block1 value:lnr value:foundCol optionalArgument:nil.
				    ]]]].
		] ifFalse:[
		    "perform a findString (no matching)"
		    p := pattern.
		    (match and:[pattern includesMatchCharacters]) ifTrue:[
			p := pattern withoutMatchEscapes
		    ].
		    runner
			value:[:lnr :col :lineString |
			    foundCol := lineString
				    findString:p startingAt:col ifAbsent:0 caseSensitive: ignCase not.
			    foundCol ~~ 0 ifTrue:[
				(fullWord not
				    or:[ (self findBeginOfWordAtLine:lnr col:foundCol) == foundCol
					  and:[ (self findEndOfWordAtLine:lnr col:foundCol) == (foundCol + patternSize - 1) ]]
				) ifTrue:[
				    (atBeginOfLineOnly not or:[foundCol == 1]) ifTrue:[
					^ block1 value:lnr value:foundCol optionalArgument:nil.
				    ]
				]
			    ]
			].
		].
	    ].
	]
    ].
    "not found"

    ^ block2 value

    "Created: / 13-09-1997 / 01:06:31 / cg"
    "Modified: / 05-08-2012 / 12:22:42 / cg"
!

standardWordCheck:char
    "the wordCheck is a predicate which returns true if the given character
     belongs to the (textual) word. Used with double click to select a word.
     When editing code, typically characters which are part of an identifier
     are part of a word (underline, dollar, but no other non-letters).
     The standardWordCheck aks the current userPreferences for details."

    |prefs|

    (prefs := UserPreferences current) whitespaceWordSelectMode ifTrue:[
	"an extremely simple mode, where every non-space is treated as part of the word"
	^ char isSeparator not
    ].
    prefs extendedWordSelectMode ifTrue:[
	"the typical mode, useful for text and code"
	^ char isNationalAlphaNumeric or:[char == $_]
    ].
    "another typical mode, also useful for text and code"
    ^ char isNationalAlphaNumeric

    "Modified (comment): / 17-03-2012 / 19:04:13 / cg"
! !

!ListView methodsFor:'tabulators'!

expandTabs
    "go through whole text expanding tabs into spaces.
     This is meant to be called for text being imported from a file.
     Therefore, 8-col tabs are assumed - independent of any private tab setting."

    |line newLine nLines "{ Class: SmallInteger }"|

    includesNonStrings := false.
    list notNil ifTrue:[
	nLines := self size.
	1 to:nLines do:[:index |
	    line := self at:index.
	    line notNil ifTrue:[
		(line isString) ifTrue:[
		    newLine := line withTabsExpanded.
		    newLine ~~ line ifTrue:[
			list at:index put:newLine
		    ].
		] ifFalse:[
		    includesNonStrings := true.
		]
	    ]
	]
    ]

    "Modified: 30.8.1995 / 19:06:37 / claus"
    "Modified: 12.5.1996 / 12:48:03 / cg"
!

nextTabAfter:colNr
    "return the next tab position after col"

    ^ self nextTabAfter:colNr in:tabPositions.
!

nextTabAfter:colNr in:tabPositions
    "return the next tab position after col.
     The second arg, tabPositions is a collection of tabStops."

    |col      "{ Class: SmallInteger }"
     tabIndex "{ Class: SmallInteger }"
     thisTab  "{ Class: SmallInteger }"
     nTabs    "{ Class: SmallInteger }" |

    tabIndex := 1.
    col := colNr.
    thisTab := tabPositions at:tabIndex.
    nTabs := tabPositions size.
    [thisTab <= col] whileTrue:[
	(tabIndex == nTabs) ifTrue:[
	    "/ fallback to mod-8 tabs if beyond tab-list.
	    thisTab := col + 1.
	    thisTab := thisTab + (8 - (thisTab \\ 8)).
	    ^ thisTab
	].
	tabIndex := tabIndex + 1.
	thisTab := tabPositions at:tabIndex
    ].
    ^ thisTab
!

prevTabBefore:colNr
    "return the prev tab position before col"

    |col      "{ Class: SmallInteger }"
     tabIndex "{ Class: SmallInteger }"
     thisTab  "{ Class: SmallInteger }"
     nTabs    "{ Class: SmallInteger }" |

    tabIndex := 1.
    col := colNr.
    thisTab := tabPositions at:tabIndex.
    nTabs := tabPositions size.
    [thisTab < col] whileTrue:[
	(tabIndex == nTabs) ifTrue:[^ thisTab].
	tabIndex := tabIndex + 1.
	thisTab := tabPositions at:tabIndex
    ].
    (tabIndex == 1) ifTrue:[
	^ 1
    ].
    ^ tabPositions at:(tabIndex - 1)
!

setTab4
    "set 4-character tab stops"

    tabPositions := self class tab4Positions.
!

setTab8
    "set 8-character tab stops"

    tabPositions := self class tab8Positions.
!

setTabPositions:aVector
    "set tab stops"

    tabPositions := aVector.
!

withTabs:line
    "Assuming an 8-character tab,
     compress multiple leading spaces to tabs, return a new line string
     or the original line, if no tabs where created.
     good idea, to make this one a primitive, since its called
     many times when a big text is saved to a file."

    |newLine eightSpaces nTabs|

    "
     the code below is a hack, producing many garbage strings for lines
     which compress multiple tabs ... needs rewrite: saving big files
     stresses the garbage collector a bit ...
    "
    line isNil ifTrue:[^ line].
    eightSpaces := '        '.
    (line startsWith:eightSpaces) ifFalse:[^ line].

    nTabs := 1.
    newLine := line copyFrom:9.
    [newLine startsWith:eightSpaces] whileTrue:[
	newLine := newLine copyFrom:9.
	nTabs := nTabs + 1.
    ].
    ^ (line species new:nTabs withAll:Character tab) asString , newLine.

    "Modified: 23.2.1996 / 19:10:36 / cg"
!

withTabs:tabulatorTable expand:line
    "expand tabs into spaces, return a new line string,
     or original line, if no tabs are included.
     good idea, to make this one a primitive, since it is called
     many times if a big text is read from a file."

    |tmpString nString nTabs
     currentMax "{ Class: SmallInteger }"
     dstIndex   "{ Class: SmallInteger }"
     nextTab    "{ Class: SmallInteger }" |

    "
     the code below tries to avoid creating too much garbage;
     therefore, the string is scanned first for the number of
     tabs to get a rough idea of the final strings size.
     (it could be done better, by computing the exact size
      required here ...)
    "
    line isNil ifTrue:[^ line].
    nTabs := line occurrencesOf:(Character tab).
    nTabs == 0 ifTrue:[^ line].

    currentMax := line size + (nTabs * 7).
    tmpString := line species new:currentMax.
    dstIndex := 1.
    line do:[:character |
	(character == (Character tab)) ifTrue:[
	    nextTab := self nextTabAfter:dstIndex in:tabulatorTable.
	    [dstIndex < nextTab] whileTrue:[
		tmpString at:dstIndex put:(Character space).
		dstIndex := dstIndex + 1
	    ]
	] ifFalse:[
	    tmpString at:dstIndex put:character.
	    dstIndex := dstIndex + 1
	].
	(dstIndex > currentMax) ifTrue:[
	    "
	     this cannot happen with <= 8 tabs
	    "
	    currentMax := currentMax + currentMax.
	    nString := line species new:currentMax.
	    nString replaceFrom:1 to:(dstIndex - 1)
			   with:tmpString startingAt:1.
	    tmpString := nString.
	    nString := nil
	].

	"make stc-optimizer happy
	 - no need to return value of ifTrue:/ifFalse above"
	0
    ].
    dstIndex := dstIndex - 1.
    dstIndex == currentMax ifTrue:[
	^ tmpString
    ].
    ^ tmpString copyTo:dstIndex

    "Modified: 23.2.1996 / 19:11:01 / cg"
!

withTabsExpanded:line
    "expand tabs into spaces, return a new line string,
     or original line, if no tabs are included.
     good idea, to make this one a primitive"

    ^ self withTabs:tabPositions expand:line
! !

!ListView::HighlightArea methodsFor:'accessing'!

bgColor
    ^ bgColor
!

bgColor:something
    bgColor := something.
!

endCol
    ^ endCol
!

endCol:something
    endCol := something.
!

endLine
    ^ endLine
!

endLine:something
    endLine := something.
!

fgColor
    ^ fgColor
!

fgColor:something
    fgColor := something.
!

startCol
    ^ startCol
!

startCol:something
    startCol := something.
!

startLine
    ^ startLine
!

startLine:something
    startLine := something.
! !

!ListView::SearchSpec methodsFor:'accessing'!

atBeginOfLineOnly
    ^ atBeginOfLineOnly ? false
!

atBeginOfLineOnly:aBoolean
    atBeginOfLineOnly := aBoolean.
!

forward
    ^ forward ? true
!

fullWord
    ^ fullWord ? false
!

ignoreCase
    ^ ignoreCase ? false
!

ignoreDiacritics
    ^ ignoreDiacritics
!

ignoreDiacritics:something
    ignoreDiacritics := something.
!

match
    ^ match ? false
!

pattern
    ^ pattern
!

pattern:patternString
    pattern := patternString.
!

pattern:patternString ignoreCase:ignoredCaseBoolean
    pattern := patternString.
    ignoreCase := ignoredCaseBoolean.
!

pattern:patternString ignoreCase:ignoredCaseBoolean match:matchBoolean
    pattern := patternString.
    ignoreCase := ignoredCaseBoolean.
    match := matchBoolean.
!

pattern:patternString ignoreCase:ignoredCaseBoolean match:matchBoolean forward:forwardBoolean
    pattern := patternString.
    ignoreCase := ignoredCaseBoolean.
    match := matchBoolean.
    forward := forwardBoolean
!

pattern:patternString ignoreCase:ignoredCaseBoolean
	  match:matchBoolean regexMatch:regexMatchBoolean
	  variable:variableBoolen
	  fullWord:fullWordBoolen forward:forwardBoolean
	  atBeginOfLineOnly:atBeginOfLineOnlyArg
    pattern := patternString.
    ignoreCase := ignoredCaseBoolean.
    match := matchBoolean.
    regexMatch := regexMatchBoolean.
    variable := variableBoolen.
    fullWord := fullWordBoolen.
    forward := forwardBoolean.
    atBeginOfLineOnly := atBeginOfLineOnlyArg
!

pattern:patternString ignoreCase:ignoredCaseBoolean
	  match:matchBoolean regexMatch:regexMatchBoolean
	  variable:variableBoolen
	  fullWord:fullWordBoolen forward:forwardBoolean
	  atBeginOfLineOnly:atBeginOfLineOnlyArg
	  wrapAtEnd:wrapAtEndOfTextArg
    pattern := patternString.
    ignoreCase := ignoredCaseBoolean.
    match := matchBoolean.
    regexMatch := regexMatchBoolean.
    variable := variableBoolen.
    fullWord := fullWordBoolen.
    forward := forwardBoolean.
    atBeginOfLineOnly := atBeginOfLineOnlyArg.
    wrapAtEndOfText := wrapAtEndOfTextArg.
!

pattern:patternString ignoreCase:ignoredCaseBoolean match:matchBoolean variable:variableBoolen forward:forwardBoolean
    pattern := patternString.
    ignoreCase := ignoredCaseBoolean.
    match := matchBoolean.
    variable := variableBoolen.
    forward := forwardBoolean
!

pattern:patternString ignoreCase:ignoredCaseBoolean match:matchBoolean variable:variableBoolen fullWord:fullWordBoolen forward:forwardBoolean
    pattern := patternString.
    ignoreCase := ignoredCaseBoolean.
    match := matchBoolean.
    variable := variableBoolen.
    fullWord := fullWordBoolen.
    forward := forwardBoolean
!

pattern:patternString ignoreCase:ignoredCaseBoolean match:matchBoolean variable:variableBoolen
		      fullWord:fullWordBoolen forward:forwardBoolean
		      atBeginOfLineOnly:atBeginOfLineOnlyArg
    pattern := patternString.
    ignoreCase := ignoredCaseBoolean.
    match := matchBoolean.
    variable := variableBoolen.
    fullWord := fullWordBoolen.
    forward := forwardBoolean.
    atBeginOfLineOnly := atBeginOfLineOnlyArg
!

regexMatch
    ^ regexMatch ? false
!

regexMatch:aBoolean
    regexMatch := aBoolean.
!

variable
    ^ variable
!

variable:variableBoolean
    variable := variableBoolean
!

wrapAtEndOfText
    ^ wrapAtEndOfText
!

wrapAtEndOfText:aBoolean
    wrapAtEndOfText := aBoolean.
! !

!ListView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ListView initialize!
