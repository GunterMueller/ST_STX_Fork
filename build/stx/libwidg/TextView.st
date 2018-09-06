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

ListView subclass:#TextView
	instanceVariableNames:'selectionStartLine selectionStartCol selectionEndLine
		selectionEndCol clickPos clickStartLine clickStartCol clickLine
		clickCol clickCount expandingTop wordStartCol wordStartLine
		wordEndCol wordEndLine selectionFgColor selectionBgColor
		selectStyle directoryForFileDialog defaultFileNameForFileDialog
		externalEncoding contentsWasSaved searchAction lastSearchPattern
		lastSearchWasMatch lastSearchIgnoredCase lastSearchDirection
		lastSearchWasVariableSearch parenthesisSpecification dropSource
		dragIsActive saveAction st80SelectMode searchBarActionBlock'
	classVariableNames:'DefaultViewBackground DefaultSelectionForegroundColor
		DefaultSelectionBackgroundColor
		DefaultAlternativeSelectionForegroundColor
		DefaultAlternativeSelectionBackgroundColor MatchDelayTime
		WordSelectCatchesBlanks LastSearchPatterns
		NumRememberedSearchPatterns LastSearchIgnoredCase
		LastSearchWasMatch DefaultParenthesisSpecification
		LastSearchWasMatchWithRegex LastSearchWasWrapAtEndOfText
		LastSearchWasReplace LastSearchReplacedString'
	poolDictionaries:''
	category:'Views-Text'
!

!TextView class methodsFor:'documentation'!

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
    a view for readOnly text - this class adds selections to a simple list.
    The text is not editable and there is no cursor.
    Use TextViews for readonly text, EditTextView for editable text.

    Please read the historic notice in the ListView class.

    [Instance variables:]

      selectionStartLine      <Number>                the line of the selection start (or nil)
      selectionStartCol       <Number>                the col of the selection start
      selectionEndLine        <Number>                the line of the selection end
      selectionEndCol         <Number>                the col of the selection end

      clickStartLine          <Number>                temporary - remember where select operation started
      clickStartCol           <Number>                temporary
      clickLine               <Number>                temporary
      clickCol                <Number>                temporary
      clickCount              <Number>                temporary
      expandingTop            <Boolean>               temporary - for expandSelection

      selectionFgColor        <Color>                 color used to draw selections
      selectionBgColor        <Color>                 color used to draw selections

      selectStyle             <Symbol>                how words are selected

      directoryForFileDialog  <nil|pathName>          directory where save dialog should start

      contentsWasSaved        <Boolean>               set to true, whenever saved in a file

      externalEncoding        <Symbol|nil>            external encoding, used when text is saved to
                                                      a file. Usually something like
                                                      #jis7, #euc, #sjis etc.
                                                      (currently only passed down from the
                                                       fileBrowser)

      dropSource              <DropSource>            drag operation descriptor or nil (dragging disabled)
      dragIsActive            <Boolean>               true, drag operation is activated

      searchAction            <Block>                 an autosearch action; typically set by the browser.
                                                      Will be used as default when searchFwd/searchBwd is
                                                      pressed. If the searchPattern is changed, no autosearch
                                                      action will be executed.

      searchBarActionBlock    <Block>                 search action block for embedded search
                                                      panel. Used as second chance for searchFwd/bwd

    [class variables:]
        ST80Selections        <Boolean>               enables ST80 style doubleclick behavior
                                                      (right after opening parenthesis, right before
                                                       closing parenthesis, at begin of a line
                                                       at begin of text)

    [StyleSheet parameters:]

      textView.background                       defaults to viewBackground
      textView.ViewFont                         defaults to textFont

      text.st80Selections                       st80 behavior (click on char after parent or quote)

      text.selectionForegroundColor             defaults to textBackgroundColor
      text.selectionBackgroundColor             defaults to textForegroundColor

      text.alternativeSelectionForegroundColor  pasted text (i.e. paste will not replace)
                                                defaults to selectionForegroundColor
      text.alternativeSelectionBackgroundColor  pasted text (i.e. paste will not replace)
                                                defaults to selectionBackgroundColor
    [author:]
        Claus Gittinger

    [see also:]
        EditTextView CodeView Workspace
"
!

examples
"
    although textViews (and instances of subclasses) are mostly used
    as components (in the fileBrowser, the browser, the launcher etc.),
    they may also be opened as a textEditor. Notice, that usually,
    instances of one of my subclasses (EditTextView, TextCollector, Workspace)
    are actually used.

    open a (readonly) textView on some information text:
                                                        [exBegin]
        TextView
            openWith:'read this'
            title:'demonstration'
                                                        [exEnd]

    the same, but open it modal:
                                                        [exBegin]
        TextView
            openModalWith:'read this first'
            title:'demonstration'
                                                        [exEnd]


    open it modal (but editable) on some text:
    (must accept before closing)
    This is somewhat kludgy - when closed, the view has already
    nilled its link to the model. Therefore, the accept must be
    done 'manually' below.
    However, usually an applicationModel is installed as the
    editor-topViews application. This would get a closeRequest,
    where it could handle things.
                                                        [exBegin]
        |m textView|

        m := 'read this first' asValue.
        textView := EditTextView openModalOnModel:m.
        textView modified ifTrue:[
            (self confirm:'text was not accepted - do it now ?')
            ifTrue:[
                m value:textView contents
            ]
        ].

        Transcript showCR:m value.
                                                        [exEnd]


    open a textEditor on some file:
                                                        [exBegin]
        EditTextView openOn:'Makefile'
                                                        [exEnd]


    configuring the TextView to NOT expand tabs and scan for special lines
    (to avoid reading all lines, when usig a virtualArray)
                                                        [exBegin]
        |a m|

        a := VirtualArray new
                setSize:100000000;
                generator:[:lNr | Transcript show:'called for '; showCR:lNr.
                                  'this is line: ',lNr printString ].
        m := a asValue.
        (ScrollableView forView:TextView new)
            expandTabsWhenUpdating:false;
            checkLineEndConventionWhenUpdating:false;
            model:m;
            open; inspect.
                                                        [exEnd]

"
! !

!TextView class methodsFor:'instance creation'!

on:aModel aspect:aspect change:change menu:menu initialSelection:initial
    "for ST-80 compatibility"

    ^ (self new)
        on:aModel
        aspect:aspect
        list:aspect
        change:change
        menu:menu
        initialSelection:initial
!

with:someText
    ^ (self new)
        contents:someText
! !

!TextView class methodsFor:'class initialization'!

initialize
    DefaultParenthesisSpecification isNil ifTrue:[
        DefaultParenthesisSpecification := IdentityDictionary new.
        DefaultParenthesisSpecification at:#open        put:#( $( $[ ${ "$> $<") .
        DefaultParenthesisSpecification at:#close       put:#( $) $] $} "$> $<").
        DefaultParenthesisSpecification at:#ignore      put:#( $' $" '$[' '$]' '${' '$)' ).
        DefaultParenthesisSpecification at:#eolComment  put:'"/'.     "/ sigh - must be 2 characters
    ].
! !

!TextView class methodsFor:'defaults'!

defaultIcon
    "return the default icon if started as a topView"

    <resource: #programImage>
    <resource: #style (#ICON #ICON_FILE)>

    |nm i|

    i := self classResources at:'ICON' default:nil.
    i isNil ifTrue:[
        nm := ClassResources at:'ICON_FILE' default:'Editor.xbm'.
        i := Smalltalk imageFromFileNamed:nm forClass:self.
    ].
    i notNil ifTrue:[
        i := i onDevice:Display
    ].
    ^ i

    "Modified: / 17-09-2007 / 11:36:29 / cg"
!

defaultMenuMessage
    "This message is the default yo be sent to the menuHolder to get a menu"

    ^ #editMenu

    "Created: 3.1.1997 / 01:52:21 / stefan"
!

defaultParenthesisSpecification
    ^ DefaultParenthesisSpecification

    "Created: / 14-06-2011 / 14:00:59 / cg"
!

defaultSelectionBackgroundColor
    "return the default selection background color"

    ^DefaultSelectionBackgroundColor
!

defaultSelectionForegroundColor
    "return the default selection foreground color"

    ^DefaultSelectionForegroundColor
!

defaultViewBackgroundColor
    "return the default view background"

    ^DefaultViewBackground
!

lastSearchIgnoredCase
    ^ LastSearchIgnoredCase
!

lastSearchWasMatch
    ^ LastSearchWasMatch
!

st80SelectMode
    ^ UserPreferences current st80SelectMode

    "Modified: / 03-07-2006 / 16:26:44 / cg"
!

st80SelectMode:aBoolean
    UserPreferences current st80SelectMode:aBoolean

    "Created: / 07-01-1999 / 13:35:24 / cg"
    "Modified: / 03-07-2006 / 16:27:01 / cg"
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'textView.background'
                       #'text.selectionForegroundColor'
                       #'text.selectionBackgroundColor'
                       #'text.alternativeSelectionForegroundColor'
                       #'text.alternativeSelectionBackgroundColor'
                       #'textView.font'
                       #'text.wordSelectCatchesBlanks'
                       #'text.st80Selections')>

    DefaultViewBackground := StyleSheet colorAt:'textView.background' default:Color white.
    DefaultSelectionForegroundColor := StyleSheet colorAt:'text.selectionForegroundColor'.
    DefaultSelectionBackgroundColor := StyleSheet colorAt:'text.selectionBackgroundColor'.
"/    DefaultAlternativeSelectionForegroundColor := StyleSheet colorAt:'text.alternativeSelectionForegroundColor' default:DefaultSelectionForegroundColor.
"/    DefaultAlternativeSelectionBackgroundColor := StyleSheet colorAt:'text.alternativeSelectionBackgroundColor' default:DefaultSelectionBackgroundColor.
    DefaultAlternativeSelectionForegroundColor := DefaultSelectionForegroundColor.
    DefaultAlternativeSelectionBackgroundColor := DefaultSelectionBackgroundColor.
    DefaultFont := StyleSheet fontAt:'textView.font'.
    MatchDelayTime := 0.6.
    WordSelectCatchesBlanks := StyleSheet at:'text.wordSelectCatchesBlanks' default:false.

    "Modified: / 03-07-2006 / 16:29:42 / cg"
! !

!TextView class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:TextView
    "

    <resource: #help>

    ^ Dictionary new addPairsFrom:#(

#matchSearch
'Search for a pattern (GLOB) as opposed to a direct string search'

#searchCaseSensitive
'Care for case differences'

#searchFullWord
'Search only for full words (ignore occurrences in substring)'

#searchAtBeginOfLineOnly
'Search only for the string at the beginning of a line'

#searchPattern
'String or match-pattern to be searched'

#searchVariable
'Search only for that variable name (ignore occurrences in other contexts)'

#replaceText
'If checked, matching text is replaced by this'

#selectLines
'If checked, lines containing the matched string are selected.'

#replacePreserveCase
'Preserve the title case of replaced text'

#replaceAll
'Search and replace all occurrences of the searched string'

#searchWithWrap
'Wrap around at the end of the text, and continue the search from the top'

#matchWithRegex
'Use regex pattern for search (as opposed to GLOB pattern)'
)
! !

!TextView class methodsFor:'interface specs'!

searchDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TextView andSelector:#searchDialogSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: searchDialogSpec
       window: 
      (WindowSpec
	 label: 'String search'
	 name: 'String search'
	 min: (Point 10 10)
	 max: (Point 1280 1024)
         bounds: (Rectangle 0 0 475 376)
       )
       component: 
      (SpecCollection
	 collection: (
	  (LabelSpec
	     label: 'SearchPattern:'
	     name: 'label'
	     layout: (LayoutFrame 1 0.0 3 0 -1 1.0 20 0)
	     level: 0
	     translateLabel: true
	     adjust: left
	   )
	  (ComboBoxSpec
	     name: 'patternComboBox'
	     layout: (LayoutFrame 2 0.0 26 0 -2 1.0 48 0)
	     activeHelpKey: searchPattern
	     tabable: true
	     model: searchPattern
	     immediateAccept: false
	     acceptOnLeave: true
	     acceptOnReturn: true
	     acceptOnTab: true
	     acceptOnLostFocus: true
	     acceptOnPointerLeave: false
	     autoSelectInitialText: true
	     comboList: patternList
	   )
	  (VerticalPanelViewSpec
	     name: 'VerticalPanel1'
             layout: (LayoutFrame 0 0.0 52 0 0 1.0 -32 1)
	     horizontalLayout: fit
	     verticalLayout: top
	     component:
	    (SpecCollection
	       collection: (
		(CheckBoxSpec
		   label: 'Case Sensitive'
		   name: 'ignoreCaseCheckBox'
		   activeHelpKey: searchCaseSensitive
		   level: 0
		   tabable: true
		   model: caseSensitive
		   translateLabel: true
                   extent: (Point 475 24)
		 )
                (ViewSpec
                   name: 'MatchBox'
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Match (forward only)'
                         name: 'matchCheckBox'
                         layout: (LayoutFrame 0 0 0 0 260 0 0 1)
                         activeHelpKey: matchSearch
                         level: 0
                         tabable: true
                         model: match
                         translateLabel: true
                       )
                      (CheckBoxSpec
                         label: 'Regex Match'
                         name: 'CheckBox6'
                         layout: (LayoutFrame -170 1 0 0 0 1 22 0)
                         activeHelpKey: matchWithRegex
                         enableChannel: matchWithRegexVisible
                         model: matchWithRegex
                         translateLabel: true
                       )
                      )
                    
                   )
                   extent: (Point 475 24)
		 )
		(CheckBoxSpec
		   label: 'Search Full Words'
		   name: 'CheckBox2'
		   activeHelpKey: searchFullWord
		   level: 0
		   enableChannel: searchFullWordEnabled
		   tabable: true
		   model: searchFullWord
		   translateLabel: true
                   extent: (Point 475 24)
                 )
                (CheckBoxSpec
                   label: 'At Begin of Line Only'
                   name: 'CheckBox5'
                   activeHelpKey: searchAtBeginOfLineOnly
                   level: 0
                   tabable: true
                   model: searchAtBeginOfLineOnly
                   translateLabel: true
                   extent: (Point 475 24)
		 )
		(CheckBoxSpec
		   label: 'Variable Only'
		   name: 'CheckBox1'
		   activeHelpKey: searchVariable
		   level: 0
		   visibilityChannel: searchVariableVisible
		   enableChannel: searchVariableEnabled
		   tabable: true
		   model: searchVariable
		   translateLabel: true
		   labelChannel: stringWithVariableUnderCursorHolder
                   extent: (Point 475 24)
		 )
		(CheckBoxSpec
		   label: 'Select Lines'
		   name: 'CheckBox3'
		   activeHelpKey: selectLines
		   level: 0
		   initiallyInvisible: true
		   tabable: true
                   model: selectLinesHolder
		   translateLabel: true
                   extent: (Point 429 24)
		 )
                (CheckBoxSpec
                   label: 'Wrap at End of Text (forward only)'
                   name: 'CheckBox7'
                   activeHelpKey: searchWithWrap
                   level: 0
                   tabable: true
                   model: wrapAtEndOfTextHolder
                   translateLabel: true
                   extent: (Point 475 24)
                 )
                (ViewSpec
                   name: 'Box1'
                   extent: (Point 475 10)
                 )
                (HorizontalPanelViewSpec
                   name: 'HorizontalPanel1'
                   horizontalLayout: leftFit
                   verticalLayout: fit
                   ignoreInvisibleComponents: false
                   elementsChangeSize: true
		   component:
		  (SpecCollection
		     collection: (
		      (CheckBoxSpec
                         label: 'Replace By:'
			 name: 'CheckBox4'
			 activeHelpKey: replaceText
			 level: 0
			 enableChannel: replaceEnabled
			 tabable: true
			 model: replaceBoolean
			 translateLabel: true
                         resizeForLabel: true
                         useDefaultExtent: true
		       )
		      (InputFieldSpec
			 name: 'ReplaceEntryField'
			 activeHelpKey: replaceText
			 visibilityChannel: replaceBoolean
			 enableChannel: replaceBoolean
			 model: replaceTextHolder
			 acceptOnReturn: true
			 acceptOnTab: true
			 acceptOnPointerLeave: true
                         extent: (Point 318 24)
		       )
		      )
                    
		   )
                   extent: (Point 475 24)
                 )
                (CheckBoxSpec
                   label: '  Replace All (to End of Text)'
                   name: 'CheckBox8'
                   activeHelpKey: replaceAll
                   level: 0
                   enableChannel: replaceBoolean
                   tabable: true
                   model: replaceAllBoolean
                   translateLabel: true
                   extent: (Point 475 24)
                 )
                (CheckBoxSpec
                   label: '  Preserve Case'
                   name: 'CheckBox9'
                   activeHelpKey: replacePreserveCase
                   level: 0
                   enableChannel: replaceBoolean
                   tabable: true
                   model: replacePreserveCaseBoolean
                   translateLabel: true
                   extent: (Point 475 24)
		 )
		)
              
	     )
	   )
	  (HorizontalPanelViewSpec
	     name: 'horizontalPanelView'
             layout: (LayoutFrame 0 0.0 -36 1.0 -16 1.0 0 1.0)
	     level: 0
	     horizontalLayout: fitSpace
	     verticalLayout: center
	     horizontalSpace: 3
	     verticalSpace: 3
	     ignoreInvisibleComponents: true
	     reverseOrderIfOKAtLeft: true
	     component:
	    (SpecCollection
	       collection: (
		(ActionButtonSpec
		   label: 'Cancel'
		   name: 'cancelButton'
		   level: 2
		   translateLabel: true
		   tabable: true
		   model: cancel
                   useDefaultExtent: true
		 )
		(ActionButtonSpec
		   label: 'Prev'
		   name: 'prevButton'
		   level: 2
		   translateLabel: true
		   tabable: true
		   model: prevAction
                   useDefaultExtent: true
		 )
		(ActionButtonSpec
		   label: 'Next'
		   name: 'nextButton'
		   level: 2
		   borderWidth: 1
		   translateLabel: true
		   tabable: true
		   model: nextAction
		   isDefault: true
                   useDefaultExtent: true
		 )
		)
              
	     )
	     keepSpaceForOSXResizeHandleH: true
	   )
	  )
        
       )
     )
! !

!TextView class methodsFor:'startup'!

open
    "start an empty TextView"

    ^ self openWith:nil
!

openModalOnModel:aModel
    "start a textView on a model; return the textView"

    |textView|

    textView := self setupForModel:aModel.
    textView topView openModal.
    ^ textView

    "Created: 14.2.1997 / 15:24:12 / cg"
!

openModalWith:aString
    "start a textView with aString as initial contents"

    ^ self openModalWith:aString title:nil

    "
     TextView openModalWith:'some text'
     EditTextView openModalWith:'some text'
    "

    "Created: 14.2.1997 / 15:19:04 / cg"
!

openModalWith:aString title:aTitle
    "start a textView with aString as initial contents. Return the textView."

    |textView|

    textView := self setupWith:aString title:aTitle.
    textView topView openModal.
    ^ textView

    "
     TextView openModalWith:'some text' title:'testing'
     EditTextView openModalWith:'some text' title:'testing'
    "

    "Modified: 9.9.1996 / 19:32:29 / cg"
    "Created: 14.2.1997 / 15:19:18 / cg"
!

openOn:aFileName
    "start a textView on a file; return the textView"

    |textView|

    textView := self setupForFile:aFileName.
    textView topView open.
    ^ textView

    "
     TextView openOn:'../../doc/overview.doc'
     EditTextView openOn:'../../doc/overview.doc'
    "

    "Modified: 14.2.1997 / 15:21:51 / cg"
!

openOnModel:aModel
    "start a textView on a model; return the textView"

    |textView|

    textView := self setupForModel:aModel.
    textView topView open.
    ^ textView

    "Created: 14.2.1997 / 15:23:36 / cg"
!

openWith:aStringOrStringCollection
    "start a textView with aStringOrStringCollection as initial contents"

    ^ self openWith:aStringOrStringCollection selected:false

    "
     TextView openWith:'some text'
     EditTextView openWith:'some text'
     Workspace openWith:'some text'
    "

    "Created: 10.12.1995 / 17:41:32 / cg"
    "Modified: 5.3.1997 / 15:37:19 / cg"
!

openWith:aStringOrStringCollection selected:selectedBoolean
    "start a textView with aStringOrStringCollection as initial (optionally selected) contents.
     Return the textView."

    |textView|

    textView := self setupEmpty.
    textView contents:aStringOrStringCollection selected:selectedBoolean.
    textView topView open.
    ^ textView

    "
     TextView openWith:'some text' selected:true
     EditTextView openWith:'some text' selected:false
    "
!

openWith:aStringOrStringCollection title:aTitle
    "start a textView with aStringOrStringCollection as initial contents. Return the textView."

    |textView|

    textView := self setupWith:aStringOrStringCollection title:aTitle.
    textView topView open.
    ^ textView

    "
     TextView openWith:'some text' title:'testing'
     EditTextView openWith:'some text' title:'testing'
    "

    "Created: 10.12.1995 / 17:40:02 / cg"
    "Modified: 5.3.1997 / 15:37:26 / cg"
!

setupEmpty
    "create a textview in a topview, with horizontal and
     vertical scrollbars - a helper for #startWith: and #startOn:"

    |top frame label|

    label := 'unnamed'.
    top := StandardSystemView label:label icon:self defaultIcon.

    frame := HVScrollableView
                for:self
                miniScrollerH:true miniScrollerV:false
                in:top.
    frame origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    ^ frame scrolledView

    "Modified: 23.5.1965 / 14:12:32 / cg"
!

setupForFile:aFileName
    "setup a textView on a file; return the textView"

    |textView|

    textView := self setupEmpty.
    aFileName notNil ifTrue:[
        textView setupForFile:aFileName.
    ].

    ^ textView

    "Created: / 14-02-1997 / 15:21:43 / cg"
    "Modified: / 25-10-2006 / 14:46:54 / cg"
!

setupForModel:aModel
    "setup a textView on a model; return the textView"

    |textView|

    textView := self setupEmpty.
    textView model:aModel.
    ^ textView

    "Created: 14.2.1997 / 15:22:42 / cg"
!

setupWith:aStringOrStringCollection title:aTitle
    "setup a textView with aStringOrStringCollection as initial contents in a topView"

    |top textView|

    textView := self setupEmpty.
    top := textView topView.
    aTitle notNil ifTrue:[top label:aTitle].

    aStringOrStringCollection notNil ifTrue:[
        textView contents:aStringOrStringCollection
    ].

    ^ textView

    "Created: 9.9.1996 / 19:31:22 / cg"
    "Modified: 5.3.1997 / 15:37:37 / cg"
! !

!TextView methodsFor:'Compatibility-ST80'!

displaySelection:aBoolean
    "ST-80 compatibility: ignored here."

!

editText:someText
    "ST-80 compatibility: set the edited text."

    self contents:someText

    "Created: / 5.2.2000 / 17:06:18 / cg"
!

selectAndScroll
    "ST-80 compatibility: ignored here."

!

selectFrom:startPos to:endPos
    "change the selection given two character positions."

    self selectFromCharacterPosition:startPos to:endPos
!

selectionStartIndex
    "ST-80 compatibility: return the selections start character position."

    ^ self characterPositionOfSelection

    "Created: / 19.6.1998 / 00:21:44 / cg"
!

selectionStopIndex
    "ST-80 compatibility: return the character position of
     the character right after the selection."

    |idx|

    idx := self characterPositionOfSelectionEnd.
    idx == 0 ifTrue:[^ 0].
    ^ idx + 1

    "Created: / 19.6.1998 / 00:22:08 / cg"
! !

!TextView methodsFor:'accessing'!

characterPositionOfSelection
    "return the character index of the first character in the selection.
     Returns 0 if there is no selection."

    selectionStartLine isNil ifTrue:[^ 0].
    ^ self characterPositionOfLine:selectionStartLine
                               col:selectionStartCol

    "Modified: 14.8.1997 / 16:35:37 / cg"
!

characterPositionOfSelectionEnd
    "return the character index of the last character in the selection.
     Returns 0 if there is no selection."

    selectionStartLine isNil ifTrue:[^ 0].
    ^ self characterPositionOfLine:selectionEndLine
                               col:selectionEndCol

    "Created: 14.8.1997 / 16:35:24 / cg"
    "Modified: 14.8.1997 / 16:35:45 / cg"
!

contentsWasSaved
    "return true, if the contents was saved (by a save action),
     false if not (or was modified again after the last save)."

    ^ contentsWasSaved
!

contentsWasSaved:aBoolean
    contentsWasSaved := aBoolean
!

defaultFileNameForFileDialog
    "return the default fileName to use for the save-box"

    ^ defaultFileNameForFileDialog
!

defaultFileNameForFileDialog:aBaseName
    "define the default fileName to use for the save-box"

    defaultFileNameForFileDialog := aBaseName

    "Created: 13.2.1997 / 18:29:53 / cg"
!

directoryForFileDialog:aDirectory
    "define the default directory to use for save-box"

    directoryForFileDialog := aDirectory

    "Modified: 13.2.1997 / 18:30:01 / cg"
!

externalEncoding
    "return the encoding used when the contents is saved via the 'save / save as' dialog.
     This is (currently only) passed down from the fileBrowser,
     and required when  utf8/japanese/chinese/korean text is edited.
     (encoding is something like #utf8 #'iso8859-5' #euc, #sjis, #jis7, #gb, #big5 or #ksc).
     Notice: this only affects the external representation of the text."

    ^ externalEncoding
!

externalEncoding:encodingSymOrNil
    "define how the contents should be encoded when saved
     via the 'save / save as' dialog.
     This is (currently only) passed down from the fileBrowser,
     and required when  utf8/japanese/chinese/korean text is edited.
     (encoding is something like #utf8 #'iso8859-5' #euc, #sjis, #jis7, #gb, #big5 or #ksc).
     Notice: this only affects the external representation of the text."

    externalEncoding := encodingSymOrNil
!

parenthesisSpecification
    "return the value of the instance variable 'parenthesisSpecification' (automatically generated)"

    ^ parenthesisSpecification
!

parenthesisSpecification:aDictionary
    "set the dictionary which specifies which characters are opening, which are closing
     and which are ignored characters w.r.t. parenthesis matching.
     See the classes initialize method for a useful value."

    parenthesisSpecification := aDictionary
!

saveAction:something
    saveAction := something.
!

searchBarActionBlock
    ^ searchBarActionBlock
!

searchBarActionBlock:something
    searchBarActionBlock := something.
!

textView
    "added to allow sending textView in any context, where either
     a TextView or a CodeView2 can be encountered. 
     Sigh - all of this because CodeView2 wraps a textView, and does not forward
     all messages. 
     Thus, the codeView2 framework always sends codeView2 textView doSomething"
     
    ^ self
! !

!TextView methodsFor:'accessing-behavior'!

isReadOnly
    "return true, if the text is readonly."

    ^ true
!

readOnly:aBoolean
    "for protocol compatibility with editTextViews,
     but actually ignored"
! !

!TextView methodsFor:'accessing-contents'!

contents:newContents selected:selectedBoolean
    self contents:newContents.
    selectedBoolean ifTrue:[
        list size == 1 ifTrue:[
            self selectFromLine:1 col:1 toLine:1 col:(list at:1) size
        ] ifFalse:[
            self selectAll
        ]
    ]

    "
     |w|

     w := Workspace new open.
     w contents:'Hello world' selected:true.
    "
!

fromFile:aFileName
    "take contents from a named file"
    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ self loadTextFile:aFileName.

    "Modified: / 25-10-2006 / 14:47:35 / cg"
!

list:aCollection expandTabs:expand scanForNonStrings:scan includesNonStrings:nonStringsIfNoScan redraw:doRedraw
    "set the displayed contents (a collection of strings) with redraw.
     Redefined since changing the contents implies deselect"

    self unselect.
    super list:aCollection expandTabs:expand scanForNonStrings:scan includesNonStrings:nonStringsIfNoScan redraw:doRedraw
!

loadTextFile:aFileName
    "take contents from a named file"

    |f|

    f := aFileName asFilename.
    self directoryForFileDialog:(f directoryName).
    self contents:(f contents)

    "Created: / 25-10-2006 / 14:44:01 / cg"
!

setContents:something
    "set the contents (either a string or a Collection of strings)
     don't change the position (i.e. do not scroll) or the selection."

    |selStartLine selStartCol selEndLine selEndCol selStyle|

    selStartLine := selectionStartLine.
    selStartCol := selectionStartCol.
    selEndLine := selectionEndLine.
    selEndCol := selectionEndCol.
    selStyle := selectStyle.

    super setContents:something.

    selStartLine notNil ifTrue:[
        self
            selectFromLine:selStartLine col:selStartCol
            toLine:selEndLine col:selEndCol.
        selectStyle := selStyle
    ].


    "Modified: / 31.3.1998 / 23:33:21 / cg"
!

setList:something
    "set the displayed contents (a collection of strings)
     without redraw.
     Redefined since changing contents implies deselect"

    self unselect.
    super setList:something
!

setupForFile:aFileName
    "take contents from a named file"

    |baseName|

    self loadTextFile:aFileName.
    aFileName notNil ifTrue:[
        baseName := aFileName asFilename baseName.
        self topView label:baseName.
        self defaultFileNameForFileDialog:baseName.
    ].

    "Created: / 25-10-2006 / 14:47:13 / cg"
!

text
    "for ST80 compatibility"

    ^ self contents

    "Created: / 19.4.1998 / 12:53:10 / cg"
!

wordAtLine:selectLine col:selectCol do:aFiveArgBlock
    "find word boundaries, evaluate the block argument with those.
     A helper for nextWord and selectWord functions."

    |beginCol endCol endLine thisCharacter flag|

    flag := #word.
    beginCol := selectCol.
    endCol := selectCol.
    endLine := selectLine.
    thisCharacter := self characterAtLine:selectLine col:beginCol.

    beginCol := self findBeginOfWordAtLine:selectLine col:selectCol.
    endCol := self findEndOfWordAtLine:selectLine col:selectCol.
    endCol == 0 ifTrue:[
        endLine := selectLine + 1
    ].

    "is the initial character within a word ?"
    (wordCheck value:thisCharacter) ifTrue:[
        "
         try to catch a blank ...
        "

        WordSelectCatchesBlanks ifTrue:[
            ((beginCol == 1)
            or:[(self characterAtLine:selectLine col:(beginCol - 1))
                 ~~ Character space]) ifTrue:[
                ((self characterAtLine:selectLine col:(endCol + 1))
                  == Character space) ifTrue:[
                    endCol := endCol + 1.
                    flag := #wordRight
                ]
            ] ifFalse:[
                beginCol := beginCol - 1.
                flag := #wordLeft
            ].
        ].
    ].
    aFiveArgBlock value:selectLine
                  value:beginCol
                  value:endLine
                  value:endCol
                  value:flag

    "Modified: 18.3.1996 / 17:31:04 / cg"
! !

!TextView methodsFor:'accessing-look'!

selectionBackgroundColor
    "return the selection-background color."

    ^ selectionBgColor
!

selectionBackgroundColor:aColor
    "set the selection-background color.
     The default is defined by the styleSheet;
     typically black-on-green for color displays and white-on-black for b&w displays."

    selectionBgColor := aColor onDevice:device.
    self hasSelection ifTrue:[
        self invalidate
    ]
!

selectionForegroundColor
    "return the selection-foreground color."

    ^ selectionFgColor
!

selectionForegroundColor:aColor
    "set the selection-foreground color.
     The default is defined by the styleSheet;
     typically black-on-green for color displays and white-on-black for b&w displays."

    selectionFgColor := aColor onDevice:device.
    self hasSelection ifTrue:[
        self invalidate
    ]
!

selectionForegroundColor:color1 backgroundColor:color2
    "set both the selection-foreground and cursor background colors.
     The default is defined by the styleSheet;
     typically black-on-green for color displays and white-on-black for b&w displays."

    selectionFgColor := color1 onDevice:device.
    selectionBgColor := color2 onDevice:device.
    self hasSelection ifTrue:[
        self invalidate
    ]

    "Modified: 29.5.1996 / 16:22:15 / cg"
! !

!TextView methodsFor:'accessing-mvc'!

on:aModel aspect:aspectSym list:listSym change:changeSym menu:menuSym initialSelection:initial
    "set all of model, aspect, listMessage, changeSymbol, menySymbol
     and selection. Added for ST-80 compatibility"

    aspectSym notNil ifTrue:[aspectMsg := aspectSym.
                             listMsg isNil ifTrue:[listMsg := aspectSym]].
    changeSym notNil ifTrue:[changeMsg := changeSym].
    listSym notNil ifTrue:[listMsg := listSym].
    menuSym notNil ifTrue:[menuMsg := menuSym].
"/    initial notNil ifTrue:[initialSelectionMsg := initial].
    self model:aModel.

    "Modified: 15.8.1996 / 12:52:54 / stefan"
    "Modified: 2.1.1997 / 16:11:28 / cg"
! !

!TextView methodsFor:'drag & drop'!

allowDrag:aBoolean
    "enable/disable dragging support
    "
    aBoolean ifFalse:[
        dropSource := nil.
    ] ifTrue:[
        dropSource isNil ifTrue:[
            dropSource := DropSource
                            receiver:self
                            argument:nil
                            dropObjectSelector:#collectionOfDragObjects
                            displayObjectSelector:nil
        ]
    ].
!

canDrag
    "returns true if dragging is enabled"

    ^ dropSource notNil and:[ self hasSelection ]

    "Modified (comment): / 12-02-2012 / 08:37:21 / cg"
!

collectionOfDragObjects
    "returns collection of dragable objects assigned to selection
     Here, by default, a collection of text-dragObjects is generated;
     however, if a dragObjectConverter is defined, that one gets a chance
     to convert as appropriate.
    "
    |selection|

    selection := self selection.

    selection size == 0 ifTrue:[^ nil].
    ^ Array with:(DropObject newText:selection).
!

dropSource
    "returns the dropSource or nil"

    ^ dropSource
!

dropSource:aDropSourceOrNil
    "set the dropSource or nil"

    dropSource := aDropSourceOrNil.
! !

!TextView methodsFor:'encoding'!

validateFontEncodingFor:newEncoding ask:ask
    "if required, query user if he/she wants to change to another font,
     which is able to display text encoded as specified by newEncoding"

    |fontsEncoding msg filter f defaultFont pref matchingFonts
     matchingFamilyFonts matchingFamilyFaceFonts matchingFamilyFaceStyleFonts
     matchingFamilyFaceStyleSizeFonts font|

    font := gc font.
    fontsEncoding := font encoding.

    pref := FontDescription preferredFontEncodingFor:newEncoding.

    (pref match:fontsEncoding) ifTrue:[
        ^ self
    ].
    (fontsEncoding notNil and:[CharacterEncoder isEncoding:pref subSetOf:fontsEncoding]) ifTrue:[
        ^ self
    ].

    filter := [:f | |coding|
                    (coding := f encoding) notNil
                    and:[pref match:coding]].

    device flushListOfAvailableFonts.
    matchingFonts := device listOfAvailableFonts select:filter.
    matchingFamilyFonts := matchingFonts select:[:f | f family = gc font family].
    matchingFamilyFaceFonts := matchingFamilyFonts select:[:f | f face = gc font face].
    matchingFamilyFaceStyleFonts := matchingFamilyFaceFonts select:[:f | f style = gc font style].
    matchingFamilyFaceStyleSizeFonts := matchingFamilyFaceStyleFonts select:[:f | f size = gc font size].
    matchingFamilyFonts := matchingFonts select:[:f | f family = font family].
    matchingFamilyFaceFonts := matchingFamilyFonts select:[:f | f face = font face].
    matchingFamilyFaceStyleFonts := matchingFamilyFaceFonts select:[:f | f style = font style].
    matchingFamilyFaceStyleSizeFonts := matchingFamilyFaceStyleFonts select:[:f | f size = font size].
    matchingFamilyFaceStyleSizeFonts size > 0 ifTrue:[
        defaultFont := matchingFamilyFaceStyleSizeFonts first
    ] ifFalse:[
        matchingFamilyFaceStyleFonts size > 0 ifTrue:[
            defaultFont := matchingFamilyFaceStyleFonts first
        ] ifFalse:[
            matchingFamilyFaceFonts size > 0 ifTrue:[
                defaultFont := matchingFamilyFaceFonts first
            ] ifFalse:[
                matchingFamilyFonts size > 0 ifTrue:[
                    defaultFont := matchingFamilyFonts first
                ] ifFalse:[
                    matchingFonts size > 0 ifTrue:[
                        defaultFont := matchingFonts first
                    ].
                ].
            ].
        ].
    ].

    defaultFont isNil ifTrue:[
        defaultFont isNil ifTrue:[
            self warn:'Your display does not seem to provide any ' , newEncoding allBold , ' encoded font.\\Please select an appropriate font (iso10646-Unicode recommended)'.
            pref := #'iso10646-1'.
        ]
    ].

    msg := 'Switch to a %1 encoded font ?'.
    (ask not or:[self confirm:(resources stringWithCRs:msg with:pref)])
    ifTrue:[
        self withWaitCursorDo:[
            f := FontPanel
                    fontFromUserInitial:defaultFont
                    title:(resources string:'Font selection')
                    filter:filter
                    encoding:pref.

            f notNil ifTrue:[
                self font:f.
            ]
        ]
    ]

    "Created: 26.10.1996 / 12:06:54 / cg"
    "Modified: 30.6.1997 / 17:46:46 / cg"
! !

!TextView methodsFor:'event handling'!

buttonMotion:buttonState x:x y:y
    "mouse-move while button was pressed - handle selection changes"

    (clickLine isNil or:[clickPos isNil]) ifTrue:[
	dragIsActive := false.
	^ self
    ].

    dragIsActive ifTrue:[
	(clickPos dist:(x@y)) >= 5.0 ifTrue:[
	    dragIsActive := false.

	    self hasSelection ifTrue:[
		dropSource startDragIn:self at:(x@y)
	    ]
	].
	^ self
    ].

    "is it the select or 1-button ?"
    buttonState == 0 ifTrue:[^ self].
    self sensor leftButtonPressed ifFalse:[
	"/ self setPrimarySelection.
	"/ self selectionChanged.
	^ self
    ].
"/    (device buttonMotionMask:buttonState includesButton:#select) ifFalse:[
"/        (device buttonMotionMask:buttonState includesButton:1) ifFalse:[
"/            ^ self
"/        ].
"/    ].

    "if moved outside of view, start autoscroll"

    ((y < 0) and:[firstLineShown ~~ 0]) ifTrue:[
	self compressMotionEvents:false.
        (self startAutoScrollUp:y negated) ifTrue:[
            ^ self
        ].
    ].
    (y > height) ifTrue:[
	self compressMotionEvents:false.
        (self startAutoScrollDown:(y - height)) ifTrue:[
            ^ self
        ].
    ].
    ((x < 0) and:[viewOrigin x ~~ 0]) ifTrue:[
	self compressMotionEvents:false.
        (self startAutoScrollLeft:x) ifTrue:[
            ^ self
        ].
    ].
    (x > width) ifTrue:[
	self compressMotionEvents:false.
        (self startAutoScrollRight:(x - width)) ifTrue:[
            ^ self
        ].
    ].

    "move inside - stop autoscroll if any"
    autoScrollBlock notNil ifTrue:[
	self stopScrollSelect
    ].

    self extendSelectionToX:x y:y setPrimarySelection:false.

    "Modified: / 08-08-2010 / 11:20:54 / cg"
!

buttonMultiPress:button x:x y:y
    "multi-mouse-click - select word under pointer"

    (button == 1) ifTrue:[
        clickPos := x @ y.

        "/ The searchAction is mantained until a cut/replace or a search with a user selection is done
"/        self clearSearchAction.

        clickCount notNil ifTrue:[
            clickCount := clickCount + 1.
            (clickCount == 2) ifTrue:[
                self doubleClickX:x y:y
            ] ifFalse:[
                (clickCount == 3) ifTrue:[
                    self tripleClickX:x y:y
                ] ifFalse:[
                    (clickCount == 4) ifTrue:[
                        self quadClickX:x y:y
                    ]
                ]
            ]
        ]
    ] ifFalse:[
        super buttonMultiPress:button x:x y:y
    ]

    "Modified: 11.9.1997 / 04:15:35 / cg"
!

buttonPress:button x:x y:y
    "mouse-click - prepare for selection change"

    |sensor clickVisibleLine|

    dragIsActive := false.
    sensor       := self sensor.

    (button == 1) ifTrue:[
        sensor shiftDown ifTrue:[
            "mouse-click with shift - adding to selection"
            self extendSelectionToX:x y:y.
            ^ self
        ].

        clickVisibleLine := self visibleLineOfY:y.
        clickPos := x @ y.
        clickCol := self colOfX:x inVisibleLine:clickVisibleLine.
        clickLine := self visibleLineToAbsoluteLine:clickVisibleLine.
        clickStartLine := clickLine.
        clickStartCol := clickCol.

        (self canDrag
        and:[(self isInSelection:clickLine col:clickCol)
        and:[UserPreferences current startTextDragWithControl not
             or:[sensor ctrlDown]]]) ifTrue:[
            dragIsActive := true
        ] ifFalse:[
            self unselect.
        ].
        clickCount := 1
    ] ifFalse:[
        super buttonPress:button x:x y:y
    ]

    "Modified: / 20.5.1999 / 17:02:45 / cg"
!

buttonRelease:button x:x y:y
    "mouse- button release - turn off autoScroll if any"

    (button == 1) ifTrue:[
	self hasSelection ifTrue:[
	    self setPrimarySelection.
	    self selectionChanged.
	].

	autoScrollBlock notNil ifTrue:[
	    self stopScrollSelect
	].
	dragIsActive ifTrue:[
	    self unselect
	].
	clickPos := nil.
    ] ifFalse:[
	super buttonRelease:button x:x y:y
    ].
    dragIsActive := false.

    "/ clickPos := clickLine := clickCol := nil.

    "Modified: / 20.5.1999 / 17:14:23 / cg"
!

doubleClickX:x y:y
    "double-click - select word under pointer"

    |sel ch scanCh matchCol scanCol fwdScan fwdSelect|

    self selectWordAtX:x y:y.

    "
     special - if clicked on a parenthesis, select to matching
     (must de before doing the ST80 stuff below)
    "
    ((sel := self selection) size == 1
    and:[(sel := sel at:1) size == 1]) ifTrue:[
	ch := sel at:1.

	((self isOpeningParenthesis:ch)
	or:[ (self isClosingParenthesis:ch) ]) ifTrue:[
	    self
		searchForMatchingParenthesisFromLine:selectionStartLine col:selectionStartCol
		ifFound:[:line :col |
			      |prevLine prevCol moveBack pos1|

			      prevLine := firstLineShown.
			      prevCol := viewOrigin x.
			      self selectFromLine:selectionStartLine col:selectionStartCol
					   toLine:line col:col.

			      self sensor ctrlDown ifFalse:[
				  "/ undo scroll operation ...
				  self withCursor:Cursor eye do:[
				      |delayCount|

				      moveBack := false.
				      (self isClosingParenthesis:ch) ifTrue:[
					   (firstLineShown ~~ prevLine or:[prevCol ~~ viewOrigin x]) ifTrue:[
					       moveBack := true
					   ]
				      ] ifFalse:[
					   selectionEndLine > (firstLineShown + nFullLinesShown) ifTrue:[
					       self makeLineVisible:selectionEndLine.
					       moveBack := true
					   ]
				      ].
				      moveBack ifTrue:[
					   delayCount  := 0.
					   pos1 := x@y.
					   self invalidateRepairNow:true.
					   Delay waitForSeconds:MatchDelayTime.
					   delayCount := delayCount + MatchDelayTime.
					   [self sensor hasUserEventFor:self] whileFalse:[
						Delay waitForSeconds:MatchDelayTime / 2.
						delayCount := delayCount + (MatchDelayTime / 2).
						delayCount > 2 ifTrue:[
						    self cursor:Cursor eyeClosed.
						].
						delayCount >= 2.3 ifTrue:[
						    self cursor:Cursor eye.
						    delayCount := 0.
						]
					   ].
					   self scrollToLine:prevLine; scrollToCol:prevCol.
				      ].
				  ]
			      ].
			      ^ self.
			  ]
		ifNotFound:[self showNotFound]
		onError:[self beep]
		openingCharacters:((parenthesisSpecification at:#open) ", '([{'")
		closingCharacters:((parenthesisSpecification at:#close) ", ')]}'").
	    selectStyle := nil
	]
    ].

    (self st80SelectMode or:[ self sensor ctrlDown]) ifTrue:[
	"/ st80 selects:
	"/   - if clicked right after a parenthesis -> select to matching parenthesis
	"/   - if clicked right after a quote -> select to matching quote (unless escaped ;-)
	"/   - if clicked at beginning of the line  -> select that line
	"/   - if clicked at the top of the text    -> select all
	"/ however, do none of the above, if clicked on a parenthesis
	clickCol == 1 ifTrue:[
	    clickLine == 1 ifTrue:[
		self selectAll.
		^ self.
	    ].
	    self selectLineAtY:y.
	    selectStyle := #line.
	    ^ self
	].

	matchCol := nil.
	"/ see what is to the left of that character ...
	clickCol > 1 ifTrue:[
	    ch := self characterAtLine:clickLine col:clickCol-1.
	    (self isOpeningParenthesis:ch) ifTrue:[
		matchCol := clickCol - 1
	    ] ifFalse:[
		('"''|' includes:ch) ifTrue:[
		    scanCol := clickCol - 1.
		    fwdScan := true.
		    scanCh := ch.
		]
	    ]
	].
	fwdSelect := true.
	(matchCol isNil and:[scanCol isNil]) ifTrue:[
	    clickCol < (self listAt:clickLine) size ifTrue:[
		ch := self characterAtLine:clickLine col:clickCol+1.
		(self isClosingParenthesis:ch) ifTrue:[
		    matchCol := clickCol + 1.
		    fwdSelect := false.
		] ifFalse:[
		    ('"''|' includes:ch) ifTrue:[
			scanCol := clickCol + 1.
			fwdScan := false.
			scanCh := ch.
		    ]
		]
	    ].
	].
	matchCol notNil ifTrue:[
	    self
		searchForMatchingParenthesisFromLine:clickLine col:matchCol
		ifFound:[:line :col |
			  self selectFromLine:clickLine col:matchCol+(fwdSelect ifTrue:1 ifFalse:-1)
				       toLine:line col:col-(fwdSelect ifTrue:1 ifFalse:-1)]
		ifNotFound:[self showNotFound]
		onError:[self beep]
		openingCharacters:((parenthesisSpecification at:#open) , '([{')
		closingCharacters:((parenthesisSpecification at:#close) , ')]}').
	    ^ self
	].
	scanCol notNil ifTrue:[
	    "/ if its an EOL comment, do it differently
	    ch := self characterAtLine:clickLine col:clickCol.
	    ch == $/ ifTrue:[
		self selectFromLine:clickLine col:clickCol+1 toLine:clickLine+1 col:0.
		^ self
	    ].

	    self
		scanFor:scanCh fromLine:clickLine col:scanCol forward:fwdScan
		ifFound:[:line :col |
			    |selStart selEnd|

			    fwdScan ifTrue:[
				selStart := scanCol+1.
				selEnd := col-1.
			    ] ifFalse:[
				selStart := scanCol-1.
				selEnd := col+1.
			    ].
			    self selectFromLine:clickLine col:selStart
				 toLine:line col:selEnd.
			    ^ self
			   ]
		ifNotFound:[self showNotFound].
	    ^ self
	]
    ].

    "
     remember words position in case of a drag following
    "
    wordStartLine := selectionStartLine.
    wordEndLine := selectionEndLine.
    selectStyle == #wordLeft ifTrue:[
	wordStartCol := selectionStartCol + 1
    ] ifFalse:[
	wordStartCol := selectionStartCol.
    ].
    selectStyle == #wordRight ifTrue:[
	wordEndCol := selectionEndCol - 1
    ] ifFalse:[
	wordEndCol := selectionEndCol
    ]

    "Created: / 11-09-1997 / 04:12:55 / cg"
    "Modified: / 14-06-2011 / 14:04:59 / cg"
!

extendSelectionToX:x y:y
    "mouse-move while button was pressed - handle selection changes"

    self extendSelectionToX:x y:y setPrimarySelection:true
!

extendSelectionToX:x y:y setPrimarySelection:aBoolean
    "mouse-move while button was pressed - handle selection changes"

    |movedVisibleLine movedLine movedCol
     movedUp
     oldStartLine oldEndLine oldStartCol oldEndCol|

    movedVisibleLine := self visibleLineOfY:y.
    movedLine := self visibleLineToAbsoluteLine:movedVisibleLine.

    (x < leftMargin) ifTrue:[
	movedCol := 0
    ] ifFalse:[
	movedCol := self colOfX:x inVisibleLine:movedVisibleLine
    ].
    y < 0 ifTrue:[
	movedCol := 0
    ].
    ((movedLine == clickLine) and:[movedCol == clickCol]) ifTrue:[
	selectionStartLine notNil ifTrue:[
	    ^ self
	].
	(clickPos isNil
	or:[(clickPos x - x) abs < 3
	    and:[(clickPos y - y) abs < 3]]) ifTrue:[
	    ^ self
	].
	selectionStartLine := clickLine.
	selectionStartCol := clickCol.
	selectionEndLine := selectionStartLine.
	selectionEndCol := selectionStartCol.

	oldStartLine := selectionStartLine.
	oldEndLine := selectionEndLine.
	oldStartCol := selectionStartCol.
	oldEndCol := selectionEndCol-1.
    ] ifFalse:[
	selectionStartLine isNil ifTrue:[
	    selectionStartLine := selectionEndLine := clickLine.
	    selectionStartCol := selectionEndCol := clickCol.
	].
	oldStartLine := selectionStartLine.
	oldEndLine := selectionEndLine.
	oldStartCol := selectionStartCol.
	oldEndCol := selectionEndCol.
    ].
    oldEndLine isNil ifTrue:[
	oldEndLine := selectionEndLine ? clickLine ? movedLine.
    ].
    oldEndCol isNil ifTrue:[
	oldEndCol := selectionEndCol ? clickCol.
    ].

    "find out if we are before or after initial click"
    movedUp := false.
    clickStartLine isNil ifTrue:[
	clickStartLine := movedLine.
    ].
    clickStartCol isNil ifTrue:[
	clickStartCol := movedCol.
    ].

    (movedLine < clickStartLine) ifTrue:[
	movedUp := true
    ] ifFalse:[
	(movedLine == clickStartLine) ifTrue:[
	    (movedCol < clickStartCol) ifTrue:[
		movedUp := true
	    ]
	]
    ].

    movedUp ifTrue:[
	"change selectionStart"
	selectionStartCol := movedCol.
	selectionStartLine := movedLine.
	selectionEndCol := clickStartCol.
	selectionEndLine := clickStartLine.
	selectStyle notNil ifTrue:[
	    selectionEndCol := wordEndCol.
	    selectionEndLine := wordEndLine.
	]
    ] ifFalse:[
	"change selectionEnd"
	selectionEndCol := movedCol.
	selectionEndLine := movedLine.
	selectionStartCol := clickStartCol.
	selectionStartLine := clickStartLine.
	selectStyle notNil ifTrue:[
	    selectionStartCol := wordStartCol.
	    selectionStartLine := wordStartLine.
	]
    ].

    selectionStartLine isNil ifTrue:[^ self].

    (selectionStartCol == 0) ifTrue:[
	selectionStartCol := 1
    ].

    "
     if in word-select, just catch the rest of the word
    "
    (selectStyle notNil and:[selectStyle startsWith:'word']) ifTrue:[
	movedUp ifTrue:[
	    selectionStartCol := self findBeginOfWordAtLine:selectionStartLine col:selectionStartCol
	] ifFalse:[
	    selectionEndCol := self findEndOfWordAtLine:selectionEndLine col:selectionEndCol.
	    selectionEndCol == 0 ifTrue:[
		selectionEndLine := selectionEndLine + 1
	    ]
	].
    ].

    selectStyle == #line ifTrue:[
	movedUp ifTrue:[
	    selectionStartCol := 1.
	] ifFalse:[
	    selectionEndCol := 0.
	    selectionEndLine := selectionEndLine + 1
	]
    ].

    self validateNewSelection.
    aBoolean ifTrue:[
	self setPrimarySelection.
	self selectionChanged.
    ].

    "/ The searchAction is mantained until a cut/replace or a search with a user selection is done
"/    self clearSearchAction.

    (oldStartLine == selectionStartLine) ifTrue:[
	(oldStartCol ~~ selectionStartCol) ifTrue:[
	    self
		redrawLine:oldStartLine
		      from:((selectionStartCol min:oldStartCol) max:1)
			to:((selectionStartCol max:oldStartCol) max:1)
	]
    ] ifFalse:[
	self
	    redrawFromLine:(oldStartLine?selectionStartLine min:selectionStartLine)
			to:(oldStartLine?selectionStartLine max:selectionStartLine)
    ].

    (oldEndLine == selectionEndLine) ifTrue:[
	(oldEndCol notNil and:[oldEndCol ~~ selectionEndCol]) ifTrue:[
	    self redrawLine:oldEndLine
		       from:((selectionEndCol min:oldEndCol) max:1)
			 to:((selectionEndCol max:oldEndCol) max:1)
	]
    ] ifFalse:[
	selectionEndLine isNil ifTrue:[
	    selectionStartLine := nil.
	    self redraw.
	] ifFalse:[
	    (selectionStartLine notNil) ifTrue:[
		self redrawFromLine:(oldEndLine min:selectionEndLine)
				 to:(oldEndLine max:selectionEndLine)
	    ]
	]
    ].
    clickLine := movedLine.
    clickCol := movedCol

    "Modified: / 05-04-2011 / 17:13:35 / cg"
    "Modified: / 17-04-2012 / 21:00:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:key x:x y:y
    "handle some keyboard input (there is not much to be done here)"

    <resource: #keyboard (#Find #Copy #FindNext #FindPrev #FindAgain
                          #GotoLine #SelectAll #SaveAs #Print
                          #'F*' #'f*')>

    (key == #Find) ifTrue:[self search. ^self].
    (key == #Copy) ifTrue:[self copySelection. ^self].
    (key == #GotoLine) ifTrue:[self gotoLine. ^self].

    (key == #FindNext) ifTrue:[self searchFwd. ^self].
    (key == #FindPrev) ifTrue:[self searchBwd. ^self].
    (key == #FindAgain) ifTrue:[self searchAgainInSameDirection. ^self].

    (key == #SelectAll) ifTrue:[self selectAll. ^self].

    (key == #SaveAs)    ifTrue:[self save.    ^self].
    (key == #Print)     ifTrue:[self doPrint. ^self].

    "
     shift-Fn defines a key-sequence
     Fn       pastes that sequence
     cmd-Fn   performs a 'doIt' on the sequence (Workspaces only)

     (see EditTextView>>keyPress:x:y and Workspace>>keyPress:x:y)
    "
    (key size > 1 and:[(key at:1) asLowercase == $f]) ifTrue:[
        (('[fF][0-9]' match:key)
        or:['[fF][0-9][0-9]' match:key]) ifTrue:[
            self sensor shiftDown ifTrue:[
                UserPreferences current functionKeySequences
                    at:key put:(self selection)
            ].
            ^ self
        ].
    ].

    super keyPress:key x:x y:y

    "Modified: / 18-04-1997 / 12:12:27 / stefan"
    "Modified: / 10-03-2012 / 09:40:01 / cg"
!

mapped
    super mapped.
    selectionFgColor := selectionFgColor onDevice:device.
    selectionBgColor := selectionBgColor onDevice:device.
!

quadClickX:x y:y
    "quadrupleClick-click - select all"

    self selectAll

    "Created: / 11.9.1997 / 04:15:24 / cg"
    "Modified: / 31.3.1998 / 14:21:13 / cg"
!

tripleClickX:x y:y
    "triple-click - select line under pointer"

    self selectLineAtY:y.
    selectStyle := #line

    "Created: 11.9.1997 / 04:13:37 / cg"
! !

!TextView methodsFor:'initialization & release'!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    super fetchDeviceResources.

    selectionFgColor notNil ifTrue:[selectionFgColor := selectionFgColor onDevice:device].
    selectionBgColor notNil ifTrue:[selectionBgColor := selectionBgColor onDevice:device].

    "Created: 14.1.1997 / 00:14:33 / cg"
!

initStyle
    "setup viewStyle specifics"

    super initStyle.

    viewBackground := DefaultViewBackground.
    selectionFgColor := DefaultSelectionForegroundColor.
    selectionFgColor isNil ifTrue:[selectionFgColor := bgColor].
    selectionBgColor := DefaultSelectionBackgroundColor.
    selectionBgColor isNil ifTrue:[
	device hasColors ifTrue:[
            DefaultSelectionForegroundColor isNil ifTrue:[
                selectionFgColor := fgColor
            ].
            selectionBgColor := Color green
        ] ifFalse:[
	    device hasGrayscales ifTrue:[
                DefaultSelectionForegroundColor isNil ifTrue:[
                    selectionFgColor := fgColor
                ].
                selectionBgColor := Color gray
            ] ifFalse:[
                selectionBgColor := fgColor
            ]
        ]
    ].

    "Modified: / 22-01-1997 / 11:57:53 / cg"
    "Modified (comment): / 05-10-2011 / 15:50:45 / az"
!

initialize
    super initialize.
    self initializeSaveAction.
    contentsWasSaved := false.
    dragIsActive     := false.
    lastSearchWasMatch := lastSearchWasVariableSearch := false.
    lastSearchIgnoredCase := true.

    parenthesisSpecification isNil ifTrue:[
	parenthesisSpecification := DefaultParenthesisSpecification.
    ].

    "I handle menus myself"
    menuHolder := menuPerformer := self.

    "/ on default allow drag
    self allowDrag:true.
!

initializeSaveAction
    saveAction := [ self openSaveDialog ]
! !

!TextView methodsFor:'menu & menu actions'!

appendTo:aFileName
    "append contents to a file named fileName"

    |aStream msg filename|

    filename := aFileName asFilename.

    (FileStream userInitiatedFileSaveQuerySignal queryWith:filename) ifFalse:[
        msg := resources string:'Refused to append to file ''%1'' !!' with:filename name.
        self warn:(msg , '\\(ST/X internal permission check)' ) withCRs.
        ^ self
    ].

    [
        aStream := filename appendingWriteStream.
        [
            self fileOutContentsOn:aStream compressTabs:true encoding:externalEncoding.
        ] ensure:[
            aStream close.
        ].
        contentsWasSaved := true
    ] on:FileStream openErrorSignal do:[:ex|
        msg := resources string:'cannot append to file %1 !!' with:filename name.
        self warn:(msg , '\\(' , FileStream lastErrorString , ')' ) withCRs
    ]

    "Modified: / 27-07-2012 / 09:41:18 / cg"
!

changeFont
    "pop up a fontPanel to change font"

    |newFont fp userPrefs fontPrefs newFontPrefs|

    self withWaitCursorDo:[
        fp := FontPanel new.
        newFont := 
            fp  fontFromUserInitial:gc font 
                    title:nil
                    filter:nil
                    encoding:nil
                    enabled:true
                    withChangeAllOption:true.
    ].
    newFont notNil ifTrue:[
	self font:newFont.
        fp changeFontInAllViews ifTrue:[
            "/ user checked this box - change the defaults,
            "/ and update all other textviews now.
            userPrefs := UserPreferences current.
            fontPrefs := userPrefs fontPreferences.
            fontPrefs isNil ifTrue:[ fontPrefs := newFontPrefs := Dictionary new ].

            fontPrefs at:#Text put:(newFont storeString).
            newFontPrefs notNil ifTrue:[ userPrefs fontPreferences:newFontPrefs ].
            userPrefs beModified.
            "/ DebugView newDebugger.
            TextView allSubInstances do:[:v |
                v class defaultFont:newFont.
                v font:newFont
            ].
        ].
    ]

    "Modified: 27.2.1996 / 00:53:51 / cg"
!

copySelection
    "copy contents into smalltalk copybuffer"

    |text|

    text := self selection.
    text notNil ifTrue:[
        self unselect.

        "/ forget any emphasis ...
        text := text collect:[:l | l isNil ifTrue:[l] ifFalse:[l string]].
        self setClipboardText:text.
    ]

    "Modified: 17.5.1996 / 08:57:54 / cg"
!

defaultForGotoLine
    "return a default value to show in the gotoLine box"

    ^ selectionStartLine

    "Modified: 1.3.1996 / 18:44:36 / cg"
!

doPrint
    "print the contents on the printer"

    |printStream|

    list isNil ifTrue:[^ self].

    self withWaitCursorDo:[
        printStream := Printer new.
        printStream supportsContext ifTrue:[
            printStream printerContext font:(self font).
        ].

        Printer writeErrorSignal handle:[:ex |
            self warn:('error while printing:\\'
                        , ex description
                        , '\\(printing with: ' , (Printer printCommand) , ')') withCRs
        ] do:[
            self fileOutContentsOn:printStream.
        ].
        printStream close
    ].

    "Created: / 06-05-1996 / 16:11:26 / cg"
    "Modified: / 31-01-2012 / 18:16:39 / cg"
!

editMenu
    "return my popUpMenu"

    <resource: #keyboard (#Copy #Find #GotoLine #SaveAs #Print)>
    <resource: #programMenu>

    |items m|

    items := #(
                        ('Copy'          copySelection  Copy)
                        ('-'             nil            )
                        ('Search...'     search         Find)
                        ('Goto Line...'  gotoLine       GotoLine)
                        ('-'             nil            )
                        ('Font...'       changeFont     )
                        ('-'             nil            )
                        ('Save As...'    save           SaveAs)
                        ('Print'         doPrint        Print)
                ).

    m := PopUpMenu itemList:items resources:resources.

    self hasSelectionForCopy ifFalse:[
        m disable:#copySelection.
    ].
    ^ m

    "Modified: / 12.11.2001 / 13:43:56 / cg"
!

find
    "same as search - for VW compatibility"

    self search

    "Created: 31.7.1997 / 19:13:58 / cg"
!

gotoLine
    "show a box to enter lineNumber for positioning;
     The entered number may be prefixed by a + or -;
     in this case, the linenumber is taken relative to the current position."

    |l lineNumberBox input lineToGo relative|

    lineNumberBox :=
        EnterBox
           title:(resources string:'Line number (or +/- relativeNr):')
           okText:(resources string:'Goto')
           abortText:(resources string:'Cancel')
           action:[:l | input := l].

    l := self defaultForGotoLine.
    l notNil ifTrue:[
        l := l printString
    ].
    lineNumberBox initialText:l .
    lineNumberBox label:(resources string:'Goto Line').
    lineNumberBox showAtPointer.

    input size > 0 ifTrue:[
        input := input withoutSpaces.
        input size > 0 ifTrue:[
            (input startsWith:$+) ifTrue:[
                relative := 1.
            ] ifFalse:[
                (input startsWith:$-) ifTrue:[
                    relative := -1.
                ].
            ].
            relative notNil ifTrue:[
                input := input copyFrom:2.
            ].
            lineToGo := Integer readFromString:input onError:nil.
            lineToGo notNil ifTrue:[
                relative notNil ifTrue:[
                    lineToGo := self currentLine + (lineToGo * relative)
                ].
                self gotoLine:lineToGo
            ]
        ]
    ].

    "Modified: / 17.5.1998 / 20:07:59 / cg"
!

openSaveDialog
    "Ask user for filename using a fileSelectionBox
     and save contents into that file."

    Dialog
        requestSaveFileName:(resources string:'Save contents in:')
        default:defaultFileNameForFileDialog
        fromDirectory:directoryForFileDialog
        action:[:fileName | self saveAs:fileName]
        appendAction:[:fileName | self appendTo:fileName]
!

openSearchBoxAndSearch
    "search for a string - show a box to enter searchpattern.
     TODO: this started as an ad-hoc box, which is manually constructed.
     over time, it got more and more functions, so a separate appModel class
     would no be appropriate..."

    "
     Q: is it a good idea to preserve the last searchstring between views?
     cg: yes - turns out to be useful and less confusing than keeping last per view
    "
    |searchBox patternHolder caseHolder matchHolder matchWithRegexHolder wrapAtEndHolder
     fwd ign match initialString
     bindings bldr doSearch modal searchVariableHolder selectedVariable searchFullWordHolder selectLinesHolder
     replaceBooleanEnabledHolder replaceBooleanHolder replaceTextHolder
     replaceAllBooleanHolder replacePreserveCaseBooleanHolder
     searchAtBeginOfLineOnlyHolder updateReturnKeyBehavior|

    searchBarActionBlock notNil ifTrue:[
	self resetVariablesBeforeNewSearch.
	searchBarActionBlock value:#search value:self.
	^ self
    ].

    modal := (UserPreferences current searchDialogIsModal).   "/ that's experimental

    (searchBox := self objectAttributeAt:#currentModelessSearchBox) notNil ifTrue:[
        (modal not
        and:[ searchBox window realized ]) ifTrue:[
            "/ reuse it.
            searchBox window
                raiseDeiconified;
                requestFocus;
                assignKeyboardFocusToFirstKeyboardConsumer.
            ^ self.
        ].
        searchBox closeRequest.
    ].

    ign := lastSearchIgnoredCase "? LastSearchIgnoredCase " ? true.
    caseHolder := ign not asValue.

    match := lastSearchWasMatch ? LastSearchWasMatch ? false.
    matchHolder := match asValue.
    matchWithRegexHolder := (LastSearchWasMatchWithRegex ? false) asValue.
    wrapAtEndHolder := (LastSearchWasWrapAtEndOfText ? false) asValue.
    searchVariableHolder := (lastSearchWasVariableSearch ? false) asValue.
    searchFullWordHolder := false asValue.
    searchAtBeginOfLineOnlyHolder := false asValue.
    selectLinesHolder := false asValue.
    replaceBooleanHolder := ("LastSearchWasReplace ?" false) asValue.
    replaceAllBooleanHolder := false asValue.
    replacePreserveCaseBooleanHolder := false asValue.
    replaceTextHolder := (LastSearchReplacedString ? '') asValue.
    replaceBooleanEnabledHolder := self isReadOnly not asValue.

    patternHolder := '' asValue.

    self setSearchPatternWithMatchEscapes: match.

    lastSearchPattern notNil ifTrue:[
	initialString := lastSearchPattern.
    ].
"/  No longer force the current selection to be the initialString
"/    self hasSelectionWithinSingleLine ifTrue:[
"/        initialString := self selection asString.
"/    ].
    initialString isNil ifTrue:[
	LastSearchPatterns size > 0 ifTrue:[
	    initialString := LastSearchPatterns first.
	]
    ].

    initialString notNil ifTrue:[
	patternHolder value:initialString.
    ].

    fwd := true.

    doSearch := [:fwd |
	|isVariableSearch pattern searchAction|

	self resetVariablesBeforeNewSearch.

	isVariableSearch := self searchVariableVisible
				and:[searchVariableHolder value
				and:[selectedVariable notNil]].

	isVariableSearch ifTrue:[
            searchAction :=
                [
                    self searchVariableWithSyntaxElement:selectedVariable forward:fwd
                ].
	] ifFalse:[
	    lastSearchWasVariableSearch := false.
	    LastSearchIgnoredCase := lastSearchIgnoredCase := (caseHolder value not).
	    LastSearchWasMatch := lastSearchWasMatch := matchHolder value.
            LastSearchWasMatchWithRegex := matchWithRegexHolder value.
            LastSearchWasWrapAtEndOfText := wrapAtEndHolder value.
            LastSearchWasReplace :=replaceBooleanHolder value.
            LastSearchReplacedString := replaceTextHolder value.

	    pattern := patternHolder value.
	    pattern notEmptyOrNil ifTrue:[
                searchAction :=
                    [
                        self searchUsingSpec:(
                            self class searchSpec new
                                pattern:pattern
                                ignoreCase:lastSearchIgnoredCase
                                match: lastSearchWasMatch
                                regexMatch:matchWithRegexHolder value
                                variable: searchVariableHolder value
                                fullWord: searchFullWordHolder value
                                forward:fwd
                                atBeginOfLineOnly:searchAtBeginOfLineOnlyHolder value
                                wrapAtEnd:wrapAtEndHolder value).
                    ]
	    ]
	].

	replaceBooleanHolder value ifTrue:[
            |selStart replacement replaceAction|

            replacement := replaceTextHolder value.
	    isVariableSearch ifTrue:[
		"/ must replace from the end towards beginning,
		"/ because syntax-elements do not update their position, when
		"/ the text is changed (in replace).

		selectedVariable := selectedVariable lastElementInChain.
		self selectFromCharacterPosition:selectedVariable start to:selectedVariable stop.
                searchAction :=
                    [
                        selectedVariable := selectedVariable previousElement.
                        selectedVariable notNil ifTrue:[
                            self selectFromCharacterPosition:selectedVariable start to:selectedVariable stop.
                        ].
                        "/ self searchVariableWithSyntaxElement:selectedVariable forward:false
                    ].
	    ].

            replaceAction := [ self replace:replacement ]. "/ not implemented here, but in subclasses
            replacePreserveCaseBooleanHolder value ifTrue:[
                replaceAction := [
                    self selectionAsString isUppercaseFirst ifTrue:[
                        self replace:replacement asUppercaseFirst
                    ] ifFalse:[
                        self replace:replacement asLowercaseFirst
                    ]
                ].
            ].

	    selStart := self characterPositionOfSelection.

            replaceAction value.
	    searchAction value.

            replaceAllBooleanHolder value ifTrue:[
                [self characterPositionOfSelection ~= selStart] whileTrue:[
                    selStart := self characterPositionOfSelection.
                    replaceAction value.
                    searchAction value.
                ]
            ]
	] ifFalse:[
	    searchAction value.
	].
    ].

    bindings := IdentityDictionary new.
    bindings at:#searchPattern put:patternHolder.
    modal ifTrue:[
        bindings
            at:#nextAction
            put:[
                replaceAllBooleanHolder value ifTrue:[
                    searchBox doAccept.
                ] ifFalse:[
                    doSearch value:true
                ]
            ].
        bindings
            at:#prevAction
            put:[
                replaceAllBooleanHolder value ifTrue:[
                    fwd := false. searchBox doAccept.
                ] ifFalse:[
                    doSearch value:false
                ]
            ].
    ] ifFalse:[
        bindings at:#nextAction put:[doSearch value:true.].
        bindings at:#prevAction put:[doSearch value:false.].
    ].
    bindings at:#caseSensitive put:caseHolder.
    bindings at:#match put:matchHolder.
    bindings at:#matchWithRegex put:matchWithRegexHolder.
    Regex::RxMatcher isNil ifTrue:[
        bindings at:#matchWithRegexVisible put:false.
    ] ifFalse:[
        bindings at:#matchWithRegexVisible put:matchHolder
    ].
    bindings at:#patternList put:LastSearchPatterns.

    self supportsSyntaxElements ifFalse:[
	bindings at:#searchVariableVisible put:false.
    ] ifTrue:[
	bindings at:#searchVariableVisible put:true.
	selectedVariable := self syntaxElementForSelectedVariable.
	bindings at:#searchVariableEnabled put:(selectedVariable notNil).
	selectedVariable notNil ifTrue:[
	    bindings
		at:#stringWithVariableUnderCursorHolder
                put:(resources string:'Variable ("%1")' with:selectedVariable name).
            "/ searchVariableHolder value:true.
	] ifFalse:[
	    bindings
		at:#stringWithVariableUnderCursorHolder
                put:(resources string:'Variable (none selected)').
	].
    ].
    bindings at:#searchVariable put:searchVariableHolder.

    bindings at:#searchFullWord put:searchFullWordHolder.
    bindings at:#searchFullWordEnabled put:true.
    bindings at:#searchAtBeginOfLineOnly put:searchAtBeginOfLineOnlyHolder.
    bindings at:#wrapAtEndOfTextHolder put:wrapAtEndHolder.
    bindings at:#selectLinesHolder put:selectLinesHolder.

    bindings at:#replaceEnabled put:replaceBooleanEnabledHolder.
    bindings at:#replaceBoolean put:replaceBooleanHolder.
    bindings at:#replaceAllBoolean put:replaceAllBooleanHolder.
    bindings at:#replacePreserveCaseBoolean put:replacePreserveCaseBooleanHolder.
    bindings at:#replaceTextHolder put:replaceTextHolder.

    bindings at:#flyByHelpSpec put:self class flyByHelpSpec.

    updateReturnKeyBehavior :=
        [
            |lbl returnAction|

            "/ when replacing, do not close box on return
            replaceBooleanHolder value ifTrue:[
                lbl := 'Close'.
                returnAction := searchAction.
            ] ifFalse:[
                lbl := 'Cancel'.
                returnAction := nil.
            ].
            (bldr componentAt:#cancelButton) label:(resources string:lbl).
            searchBox window keyboardProcessor returnAction:returnAction.
        ].

    replaceBooleanHolder onChangeEvaluate:
	[
	    replaceBooleanHolder value ifTrue:[
		(bldr componentAt:#ReplaceEntryField) requestFocus
	    ] ifFalse:[
		(bldr componentAt:#patternComboBox) requestFocus
	    ].
            updateReturnKeyBehavior value.
	].

    modal ifTrue:[
	searchBox := SimpleDialog new.
    ] ifFalse:[
	searchBox := ApplicationModel new.
	searchBox createBuilder.
        bindings at:#cancel put:[ searchBox closeRequest ].
    ].
    searchBox resources:(self resources).

    bldr := searchBox builder.
    bldr addBindings:bindings.
    bldr aspectAt:#flyByHelpSpec put:(self class flyByHelpSpec).
    searchBox allButOpenFrom:(self class searchDialogSpec).

    (bldr componentAt:#nextButton) cursor:(Cursor thumbsUp).
    (bldr componentAt:#prevButton) cursor:(Cursor thumbsUp).
    (bldr componentAt:#cancelButton) cursor:(Cursor thumbsDown).

    modal ifTrue:[
        updateReturnKeyBehavior value.
        searchBox openDialogAtPointer.
	searchBox accepted ifTrue:[ doSearch value:fwd ].
    ] ifFalse:[
	(bldr componentAt:#nextButton) isReturnButton:false.
	(bldr componentAt:#cancelButton)
		label:(resources string:'Close');
		action:[searchBox closeRequest].
	"/ searchBox masterApplication:self application.
	self topView beMaster.
	searchBox window
		beSlave;
                openInGroup:(self windowGroup);
                waitUntilVisible;
                assignKeyboardFocusToFirstKeyboardConsumer.
        searchBox window keyboardProcessor
            addAccelerator:#Return action:(bindings at:#nextAction);
            addAccelerator:#Escape action:#closeRequest.
        "/ remember this box for me.
        self objectAttributeAt:#currentModelessSearchBox put:searchBox.
    ]

    "Modified: / 11-07-2006 / 11:18:38 / fm"
    "Created: / 08-03-2012 / 14:02:59 / cg"
!

replace:someText
    "replace the selection by someText. I am readonly, so this is a no-op here.
     Subclasses may redefine me."

    ^ self.
!

save
    "save contents into a file
     - ask user for filename using a fileSelectionBox."

    saveAction value
!

saveAs:fileName
    "save the contents into a file named fileName.
     On error return false otherwise return true"

    ^ self saveAs:fileName doAppend:false
!

saveAs:aFilename doAppend:doAppend
    "save the contents into a file named fileName;
     if doAppend is true, the view's contents is appended to the existing
     contents - otherwise, it overwrites any previous file contents.
     On error return false otherwise return true"

    ^ self saveAs:aFilename doAppend:doAppend compressTabs:true
!

saveAs:aFilename doAppend:doAppend compressTabs:compressTabs
    "save the contents into a file named fileName;
     if doAppend is true, the view's contents is appended to the existing
     contents - otherwise, it overwrites any previous file contents.
     On error return false otherwise return true"

    ^ self saveAs:aFilename doAppend:doAppend compressTabs:compressTabs eolMode:nil
!

saveAs:aFilename doAppend:doAppend compressTabs:compressTabs eolMode:eolMode
    "save the contents into a file named fileName;
     if doAppend is true, the view's contents is appended to the existing
     contents - otherwise, it overwrites any previous file contents.
     eolMode is one of #cr, #nl or #crlf.
     On error return false otherwise return true."

    |filename msg|

    filename := aFilename asFilename.

    self withWriteCursorDo:[
	|aStream|

	(FileStream userInitiatedFileSaveQuerySignal queryWith:filename) ifFalse:[
	    msg := resources
			stringWithCRs:'Refused to write file ''%1'' !!\(ST/X internal permission check)'
			with:filename name.
	] ifTrue:[
	    [
		doAppend ifTrue:[
		    aStream := filename appendingWriteStream.
		] ifFalse:[
                    UserPreferences current generateBackupFileWhenSaving ifTrue:[
                        filename exists ifTrue:[
                            filename moveTo:(filename pathName,'.bak') asFilename
                        ].
                    ].
		    aStream := filename newReadWriteStream.
		].
                aStream eolMode:eolMode.
		self fileOutContentsOn:aStream compressTabs:compressTabs encoding:externalEncoding.
		aStream syncData; close.
		contentsWasSaved := true.
		defaultFileNameForFileDialog := filename.
	    ] on:FileStream openErrorSignal do:[:ex|
		msg := resources stringWithCRs:'Cannot write file ''%1'' !!\(%2)'
				with:filename name
				with:FileStream lastErrorString.
	    ].
	].
    ].

    msg notNil ifTrue:[
	Dialog warn:msg.
	^ false
    ].
    ^ true

    "Modified: / 27-07-2012 / 09:45:13 / cg"
!

search
    "search for a string - show a box to enter searchpattern
     - currently no regular expressions are handled."

    self openSearchBoxAndSearch

    "Modified: / 11-07-2006 / 11:18:38 / fm"
    "Modified: / 08-03-2012 / 14:03:10 / cg"
!

search:patternArg ignoreCase:ign forward:fwd
    "search for a string without matching"

    self search:patternArg ignoreCase:ign match: false forward:fwd
!

search:patternArg ignoreCase:ign match: match forward:fwd
    |pattern|

    pattern := patternArg string.
    pattern notEmpty ifTrue:[
        self rememberSearchPattern:pattern.
        "/ LastSearchIgnoredCase := lastSearchIgnoredCase := ign.
        "/ LastSearchWasMatch := match.
        fwd ifFalse:[
            lastSearchDirection := #backward.
            self searchBwd:pattern ignoreCase:ign match: match.          "    backward search with match is not yet available  "
        ] ifTrue:[
            lastSearchDirection := #forward.
            self searchFwd:pattern ignoreCase:ign match: match.
        ]
    ]

    "Created: / 11-07-2006 / 11:18:04 / fm"
    "Modified: / 23-03-2012 / 12:12:07 / cg"
!

searchUsingSpec:aSearchSpec
    self rememberSearchPattern:(aSearchSpec pattern).
    "/ LastSearchIgnoredCase := lastSearchIgnoredCase := ign.
    "/ LastSearchWasMatch := match.
    aSearchSpec forward ifFalse:[
        lastSearchDirection := #backward.
        self searchBwdUsingSpec:aSearchSpec
    ] ifTrue:[
        lastSearchDirection := #forward.
        self searchFwdUsingSpec:aSearchSpec
    ]

    "Created: / 11-07-2006 / 11:18:04 / fm"
    "Modified: / 23-03-2012 / 12:12:07 / cg"
!

searchVariableVisible
    "search variable option in searchbox visible?
     (only true for codeview2's textview)"

    ^ false

    "Created: / 08-03-2012 / 14:01:24 / cg"
!

searchVariableWithSyntaxElement:syntaxElementForVariable forward:fwd
    "this only works for CodeView2::TextView, which supports syntaxElements.
     Finds the next occurrence of a syntax element (typically, a variable)"

    |el el2|

    lastSearchWasVariableSearch := true.
    el := fwd
        ifTrue:[syntaxElementForVariable nextElement]
        ifFalse:[syntaxElementForVariable previousElement].

    el notNil ifTrue:[
        "bug workaround"
        (el start = syntaxElementForVariable start) ifTrue:[
            el2 := fwd
                ifTrue:[el nextElement]
                ifFalse:[el previousElement].
            el2 notNil ifTrue:[
                el := el2
            ]
        ].
    ].
    el notNil ifTrue:[
        self selectFromCharacterPosition:el start to:el stop.
        self makeLineVisible:(self lineOfCharacterPosition:el start).
    ] ifFalse:[
        self showNotFound
    ].

    "Created: / 08-03-2012 / 14:08:20 / cg"
!

syntaxElementForSelectedVariable
    "for a better search; ignored here, but redefined in CodeView2"

    ^ nil

    "Created: / 08-03-2012 / 14:20:27 / cg"
!

syntaxElementForVariableUnderCursor
    "for a better search; ignored here, but redefined in CodeView2"

    ^ nil

    "Created: / 08-03-2012 / 12:45:26 / cg"
! !

!TextView methodsFor:'native widget support'!

nativeWindowType
    "return a symbol describing my native window type
     (may be used internally by the device as a native window creation hint,
      if the device supports native windows)"

    ^ #TextView

    "Created: 2.5.1997 / 14:41:00 / cg"
! !

!TextView methodsFor:'private'!

currentSelectionBgColor
    ^  selectionBgColor
!

currentSelectionFgColor
    ^ selectionFgColor
!

fileOutContentsOn:aStream
    "save contents on a stream, replacing leading spaces by tab-characters."

    self
        fileOutContentsOn:aStream
        compressTabs:true
!

fileOutContentsOn:aStream compressTabs:compressTabs
    "save contents on a stream. If compressTabs is true,
     leading spaces will be replaced by tab-characters in the output."

    self
        fileOutContentsOn:aStream
        compressTabs:compressTabs
        encoding:nil
!

fileOutContentsOn:aStream compressTabs:compressTabs encoding:encodingSymOrNil
    "save contents on a stream. If compressTabs is true,
     leading spaces will be replaced by tab-characters in the output."

    |startNr nLines string encoder|

    self removeTrailingWhitespace.

    "/ This is now obsolete, as we are always using unicode internally.
    "/ so the following line should be changed to encoderToEncodeFrom:unicode to:xxx.
    encoder := CharacterEncoder encoderToEncodeFrom:gc characterEncoding into:encodingSymOrNil.
    encoder isNullEncoder ifTrue:[
	(list contains:[:lineOrNil|
			    |s|
			    lineOrNil notNil
			    and:[(s := lineOrNil string string) isWideString
			    and:[s asSingleByteStringIfPossible isWideString]]
		       ]
	) ifTrue:[
	    (Dialog confirm:'The text contains non-8bit characters. Encode as UTF8?') ifFalse:[
		^ self
	    ]
	].
	encoder := CharacterEncoder encoderToEncodeFrom:#unicode into:#utf8
    ].

    aStream isFileStream ifTrue:[
	"on some systems, writing linewise is very slow (via NFS)
	 therefore we convert to a string and write it in big chunks.
	 To avoid creating huge strings, we do it in blocks of 1000 lines,
	 limiting temporary string creation to about 50-80k.
	"
	startNr := 1.
	nLines := list size.
        (aStream eolMode notNil
        and:[aStream eolMode ~= #nl]) ifTrue:[
            "/ must do it lineWise ...
            list do:[:line |
                line notNil ifTrue:[
                    encoder encodeString:line withTabs on:aStream
                ].
                aStream cr
            ].
        ] ifFalse:[
            [startNr <= nLines] whileTrue:[
                string := list
                            asStringWithCRsFrom:startNr
                            to:((startNr + 1000) min:nLines)
                            compressTabs:compressTabs.
                encoder encodeString:string string on:aStream.
                startNr := startNr + 1000 + 1.
            ].
        ].
    ] ifFalse:[
        list do:[:aLine |
            aLine notNil ifTrue:[
                encoder encodeString:aLine on:aStream.
            ].
            aStream cr.
        ]
    ]

    "Modified: 8.6.1996 / 11:50:46 / cg"
!

getFontParameters
    "get some info of the used font. They are cached since we use them often ..
     This is redefined here, to use the font's maxHeight/maxAscent for
     line separation. This is required, to allow for proper handling of
     national characters, such as A-diaresis ..."

    |italicFont boldFont font|

    font := gc deviceFont.
    "/ do we really need this info now?
    "/ on unix, it seems to work with the next two lines commented;
    "/ should probably check on windows too
    italicFont := font asItalic onDevice:self device.
    boldFont := font asBold onDevice:self device.

    fontHeight := font height.
    fontAscent := font ascent.
    fontWidth := font width.
    fontIsFixedWidth := font isFixedWidth.

    "/ fA := font maxAscent.
    italicFont notNil ifTrue:[
        fontHeight := fontHeight max:(italicFont height).
        fontAscent := fontAscent max:(italicFont ascent).
        fontIsFixedWidth := fontIsFixedWidth and:[ italicFont isFixedWidth ]
    ].
    boldFont notNil ifTrue:[
        fontHeight := fontHeight max:(boldFont height).
        fontAscent := fontAscent max:(boldFont ascent).
        fontIsFixedWidth := fontIsFixedWidth and:[ boldFont isFixedWidth ]
    ].

    includesNonStrings == true ifTrue:[
	"/ for now, we do not support variable height entries ...
	fontHeight := fontHeight max:(list first heightOn:self).
    ].
    fontHeight := fontHeight + lineSpacing.

    "Modified: 22.5.1996 / 12:02:47 / cg"
    "Created: 22.5.1996 / 12:18:34 / cg"
!

highlightLineSpacing
    "true if the spacing between lines is to be drawn with selected color,
     false if it remains white.
     false for selection in list views; true for edit/text views"

    ^ true
!

isClosingParenthesis:ch
    ((parenthesisSpecification at:#close) includes:ch) ifTrue:[^ true].
    ^ ')]}' includes:ch

    "Modified: / 12-02-2012 / 08:37:01 / cg"
!

isOpeningParenthesis:ch
    ((parenthesisSpecification at:#open) includes:ch) ifTrue:[^ true].
    ^ '([{' includes:ch

    "Modified: / 12-02-2012 / 08:37:11 / cg"
!

rememberSearchPattern:pattern
    |nRemembered patternString|

    self clearSearchAction.

    patternString := pattern string.

    nRemembered := NumRememberedSearchPatterns ? 20.

    LastSearchPatterns isNil ifTrue:[
        LastSearchPatterns := OrderedCollection new.
    ].
    "/ move to top or addFirst
    (LastSearchPatterns includes:patternString) ifTrue:[
        LastSearchPatterns remove:patternString.
    ] ifFalse:[
        LastSearchPatterns size > nRemembered ifTrue:[
            LastSearchPatterns removeLast
        ]
    ].
    LastSearchPatterns addFirst:patternString.

    "Modified: / 23-03-2012 / 13:59:09 / cg"
!

removeTrailingWhitespace
    list isNil ifTrue:[^self].
    list keysAndValuesDo:[:lineNR :line |
        |l|

        line notNil ifTrue:[
            l := line withoutTrailingSeparators.
            list at:lineNR put:l.
        ]
    ].
!

resetVariablesBeforeNewSearch
    "clear the autosearch action, when the first pattern is searched for"

    searchAction := nil.
!

scrollSelectDown
    "auto scroll action; scroll and reinstall timed-block"

    |prevEndLine|

    "just to make certain ..."
    selectionEndLine isNil ifTrue:[^ self].

    self scrollDown.

    "make new selection immediately visible"
    prevEndLine := selectionEndLine.
    selectionEndLine := firstLineShown + nFullLinesShown.
    selectionEndCol := 0.
    prevEndLine to:selectionEndLine do:[:lineNr |
        self redrawLine:lineNr
    ].
    autoScrollBlock notNil ifTrue:[ Processor addTimedBlock:autoScrollBlock afterSeconds:autoScrollDeltaT ].
    self selectionChanged.
!

scrollSelectLeft
    "auto scroll action; scroll and reinstall timed-block"

    |prevStartLine|

    "just to make certain ..."
    selectionStartLine isNil ifTrue:[^ self].
    selectionStartCol isNil ifTrue:[^ self].

    "make new selection immediately visible"
    prevStartLine := selectionStartLine.
    selectionStartCol := selectionStartCol - 1 max:1.
    self scrollLeft.

    autoScrollBlock notNil ifTrue:[ Processor addTimedBlock:autoScrollBlock afterSeconds:autoScrollDeltaT ].
    self selectionChanged.
!

scrollSelectRight
    "auto scroll action; scroll and reinstall timed-block"

    |prevEndCol firstVisibleCol endLine|

    "just to make certain ..."
    selectionEndCol isNil ifTrue:[^ self].
    selectionEndLine isNil ifTrue:[^ self].

    prevEndCol := selectionEndCol.
    selectionEndCol := (selectionEndCol + 1) min:(self listAt:selectionEndLine) size.

    endLine := self listLineToVisibleLine:selectionEndLine.
    endLine notNil ifTrue:[
        firstVisibleCol := self colOfX:1 inVisibleLine:endLine.
        selectionEndCol < firstVisibleCol ifTrue:[
            "/ scrolling faster than selection advances...
            selectionEndCol := firstVisibleCol
        ].
    ].

    self selectionChanged.
    self scrollRight.
    "/ self repairDamage.

    autoScrollBlock notNil ifTrue:[ Processor addTimedBlock:autoScrollBlock afterSeconds:autoScrollDeltaT ].

    "Modified: / 05-08-2010 / 21:25:56 / cg"
!

scrollSelectUp
    "auto scroll action; scroll and reinstall timed-block"

    |prevStartLine|

    "just to make certain ..."
    selectionStartLine isNil ifTrue:[^ self].

    self scrollUp.

    "make new selection immediately visible"
    prevStartLine := selectionStartLine.
    selectionStartLine := firstLineShown.
    selectionStartCol := 1.
    selectionStartLine to:prevStartLine do:[:lineNr |
        self redrawLine:lineNr
    ].
    autoScrollBlock notNil ifTrue:[ Processor addTimedBlock:autoScrollBlock afterSeconds:autoScrollDeltaT ].
    self selectionChanged.
!

stopScrollSelect
    "stop auto scroll; deinstall timed-block"

    autoScrollBlock notNil ifTrue:[
        Processor removeTimedBlock:autoScrollBlock.
        self compressMotionEvents:true.
        autoScrollBlock := nil.
        autoScrollDeltaT := nil
    ]
!

textChanged
    self isNativeWidget ifTrue:[
        gc drawableId notNil ifTrue:[
            device changeText:self contents in:gc drawableId
        ]
    ].
    super textChanged
!

widthForScrollBetween:firstLine and:lastLine
    "return the width in pixels for a scroll between firstLine and lastLine"

    selectionStartLine notNil ifTrue:[
        "/ if there is a selection which covers multiple lines,
        "/ we have to scroll the whole width (to include the selection-rectangle)

        (lastLine < selectionStartLine) ifFalse:[
            (firstLine > selectionEndLine) ifFalse:[
                ^ width
            ]
        ].
    ].
    ^ super widthForScrollBetween:firstLine and:lastLine
! !

!TextView methodsFor:'queries'!

hasSearchActionSelection
    "Here we fake the use of typeOfSelection which is really in EditTextView"

    ^ false
!

specClass
    "redefined, since the name of my specClass is nonStandard (i.e. not TextViewSpec)"

    self class == TextView ifTrue:[^ TextEditorSpec].
    ^ super specClass

    "Modified: / 31.10.1997 / 19:48:35 / cg"
! !

!TextView methodsFor:'redrawing'!

clearMarginOfVisibleLine:visLine with:color
    "if there is a margin, clear it - a helper for selection drawing"

    (leftMargin ~~ 0) ifTrue:[
	viewOrigin x <= margin ifTrue:[
            gc paint:color.
            gc fillRectangleX:(margin-viewOrigin) x y:(self yOfVisibleLine:visLine)- (lineSpacing//2)
               width:leftMargin height:fontHeight
	]
    ]

    "Created: 6.3.1996 / 14:22:55 / cg"
!

drawSelectedFromVisibleLine:startVisLineNr to:endVisLineNr
    startVisLineNr to:endVisLineNr do:[:visLine |
        self drawVisibleLineSelected:visLine
    ]
!

drawVisibleLineSelected:visLineNr
    self
        drawLine:(self withoutAnyColorEmphasis:(self visibleAt:visLineNr))
        inVisible:visLineNr
        with:self currentSelectionFgColor and:self currentSelectionBgColor
!

drawVisibleLineSelected:visLineNr col:col
    self
        drawLine:(self withoutAnyColorEmphasis:(self visibleAt:visLineNr))
        inVisible:visLineNr
        col:col
        with:self currentSelectionFgColor and:self currentSelectionBgColor
!

drawVisibleLineSelected:visLineNr from:selectionStartCol
    self
        drawLine:(self withoutAnyColorEmphasis:(self visibleAt:visLineNr))
        inVisible:visLineNr
        from:selectionStartCol
        with:self currentSelectionFgColor and:self currentSelectionBgColor.
!

drawVisibleLineSelected:visLineNr from:startCol to:endCol
    self
        drawLine:(self withoutAnyColorEmphasis:(self visibleAt:visLineNr))
        inVisible:visLineNr
        from:startCol to:endCol
        with:self currentSelectionFgColor and:self currentSelectionBgColor.
!

redrawFromVisibleLine:startVisLineNr to:endVisLineNr
    "redraw a visible line range"

    |startLine endLine specialCare end selVisStart line1 line2|

    shown ifFalse:[^ self].

    end := endVisLineNr.
    (end > nLinesShown) ifTrue:[
        end := nLinesShown
    ].

    selectionEndLine isNil ifTrue:[
        selectionStartLine := nil
    ].

    selectionStartLine isNil ifTrue:[
        specialCare := false
    ] ifFalse:[
        startLine := self visibleLineToAbsoluteLine:startVisLineNr.
        (startLine > selectionEndLine) ifTrue:[
            specialCare := false
        ] ifFalse:[
            endLine := self visibleLineToAbsoluteLine:end.
            (endLine < selectionStartLine) ifTrue:[
                specialCare := false
            ] ifFalse:[
                specialCare := true
            ]
        ]
    ].

    "easy: nothing is selected"
    specialCare ifFalse:[
        super redrawFromVisibleLine:startVisLineNr to:end.
        ^ self
    ].

    "easy: all is selected"
    ((selectionStartLine < startLine) and:[selectionEndLine > endLine]) ifTrue:[
        self drawSelectedFromVisibleLine:startVisLineNr to:end.
        ^ self
    ].

    (selectionStartLine >= firstLineShown) ifTrue:[
        "draw unselected top part"

        selVisStart := self listLineToVisibleLine:selectionStartLine.
        super redrawFromVisibleLine:startVisLineNr to:(selVisStart - 1).

        "and first partial selected line"
        self redrawVisibleLine:selVisStart.

        "rest starts after this one"
        line1 := selVisStart + 1
    ] ifFalse:[
        line1 := 1
    ].

    (line1 > end) ifTrue:[^ self].
    (line1 < startVisLineNr) ifTrue:[
        line1 := startVisLineNr
    ].

    "draw middle part of selection"

    (selectionEndLine >= (firstLineShown + nLinesShown)) ifTrue:[
        line2 := nLinesShown
    ] ifFalse:[
        line2 := (self listLineToVisibleLine:selectionEndLine) - 1
    ].
    (line2 > end) ifTrue:[
        line2 := end
    ].

    self drawSelectedFromVisibleLine:line1 to:line2.

    (line2 >= end) ifTrue:[^ self].

    "last line of selection"
    self redrawVisibleLine:(line2 + 1).

    ((line2 + 2) <= end) ifTrue:[
        super redrawFromVisibleLine:(line2 + 2) to:end
    ]
!

redrawVisibleLine:visLineNr
    "redraw visible line lineNr"

    |line|

    (selectionStartLine notNil and:[selectionEndLine notNil
    and:[ selectionStartCol notNil and:[selectionEndCol notNil]]]) ifTrue:[
	line := self visibleLineToAbsoluteLine:visLineNr.
	(line between:selectionStartLine and:selectionEndLine) ifTrue:[
	    (line == selectionStartLine) ifTrue:[
		(line == selectionEndLine) ifTrue:[
		    "it's part-of-single-line selection"
		    self clearMarginOfVisibleLine:visLineNr with:bgColor.
		    (selectionStartCol > 1) ifTrue:[
			super redrawVisibleLine:visLineNr from:1 to:(selectionStartCol - 1)
		    ].
		    self drawVisibleLineSelected:visLineNr from:selectionStartCol to:selectionEndCol.
		    super redrawVisibleLine:visLineNr from:(selectionEndCol + 1).
		    ^ self
		].

		"it's the first line of a multi-line selection"
		(selectionStartCol ~~ 1) ifTrue:[
		    self clearMarginOfVisibleLine:visLineNr with:bgColor.
		    super redrawVisibleLine:visLineNr from:1 to:(selectionStartCol - 1)
		] ifFalse:[
		    viewOrigin x == 0 ifTrue:[
			self clearMarginOfVisibleLine:visLineNr with:self currentSelectionBgColor.
		    ]
		].
		self drawVisibleLineSelected:visLineNr from:selectionStartCol.
		^ self
	    ].

	    (line == selectionEndLine) ifTrue:[
		"it's the last line of a multi-line selection"
		(selectionEndCol == 0) ifTrue:[
		    ^ super redrawVisibleLine:visLineNr
		].

		self clearMarginOfVisibleLine:visLineNr with:self currentSelectionBgColor.
		self drawVisibleLineSelected:visLineNr from:1 to:selectionEndCol.
		super redrawVisibleLine:visLineNr from:(selectionEndCol + 1).
		^ self
	    ].

	    "it's a full line in a multi-line selection"
	    self clearMarginOfVisibleLine:visLineNr with:self currentSelectionBgColor.
	    self drawVisibleLineSelected:visLineNr.
	    ^ self
	]
    ].
    super redrawVisibleLine:visLineNr

    "Modified: 6.3.1996 / 14:22:19 / cg"
!

redrawVisibleLine:visLine col:col
    "redraw single character at col in visible line lineNr."

    |line|

    "/
    "/ care for selection
    "/
    (selectionStartLine notNil and:[selectionEndLine notNil
    and:[ selectionStartCol notNil and:[selectionEndCol notNil]]]) ifTrue:[
	line := self visibleLineToAbsoluteLine:visLine.
	(line between:selectionStartLine and:selectionEndLine) ifTrue:[
	    ((line == selectionStartLine)
	    and: [col < selectionStartCol]) ifFalse:[
		((line == selectionEndLine)
		and: [col > selectionEndCol]) ifFalse:[
		    "its in the selection"
		    self drawVisibleLineSelected:visLine col:col.
		    ^ self.
		]
	    ]
	]
    ].
    self drawVisibleLine:visLine col:col with:fgColor and:bgColor

    "Modified: / 22.4.1998 / 08:53:05 / cg"
!

redrawVisibleLine:visLine from:startCol
    "redraw visible line lineNr from startCol to end of line"

    |col line|

    col := startCol.
    col == 0 ifTrue:[
        col := 1.
    ].

    (selectionStartLine notNil and:[selectionEndLine notNil]) ifTrue:[
        line := self visibleLineToAbsoluteLine:visLine.
        (line between:selectionStartLine and:selectionEndLine) ifTrue:[
            ((line == selectionStartLine)
             or:[line == selectionEndLine]) ifTrue:[
                "since I'm lazy, redraw full line"
                self redrawVisibleLine:visLine.
                ^ self
            ].
            "the line is fully within the selection"
            self drawVisibleLineSelected:visLine from:col.
            ^ self
        ]
    ].
    super redrawVisibleLine:visLine from:col

    "Modified: 6.3.1996 / 14:19:38 / cg"
!

redrawVisibleLine:visLine from:startCol to:endCol
    "redraw visible line lineNr from startCol to endCol"

    |line allOut allIn leftCol rightCol|

    line := self visibleLineToAbsoluteLine:visLine.

    allIn := false.
    allOut := false.
    (selectionStartLine isNil or:[selectionEndLine isNil
    or:[selectionStartCol isNil or:[selectionEndCol isNil]]]) ifTrue:[
	allOut := true
    ] ifFalse:[
	(line between:selectionStartLine and:selectionEndLine) ifFalse:[
	    allOut := true
	] ifTrue:[
	    (selectionStartLine == selectionEndLine) ifTrue:[
		((endCol < selectionStartCol)
		or:[startCol > selectionEndCol]) ifTrue:[
		    allOut := true
		] ifFalse:[
		    ((startCol >= selectionStartCol)
		    and:[endCol <= selectionEndCol]) ifTrue:[
			allIn := true
		    ]
		]
	    ] ifFalse:[
		(line == selectionStartLine) ifTrue:[
		    (endCol < selectionStartCol) ifTrue:[
			allOut := true
		    ] ifFalse:[
			(startCol >= selectionStartCol) ifTrue:[
			    allIn := true
			]
		    ]
		] ifFalse:[
		    (line == selectionEndLine) ifTrue:[
			(startCol > selectionEndCol) ifTrue:[
			    allOut := true
			] ifFalse:[
			    (endCol <= selectionEndCol) ifTrue:[
				allIn := true
			    ]
			]
		    ] ifFalse:[
			allIn := true
		    ]
		]
	    ]
	]
    ].
    allOut ifTrue:[
	super redrawVisibleLine:visLine from:startCol to:endCol.
	^ self
    ].

    allIn ifTrue:[
	self drawVisibleLineSelected:visLine from:startCol to:endCol
    ] ifFalse:[
	"redraw part before selection"
	((line == selectionStartLine)
	 and:[startCol <= selectionStartCol]) ifTrue:[
	    super redrawVisibleLine:visLine from:startCol
					      to:(selectionStartCol - 1).
	    leftCol := selectionStartCol
	] ifFalse:[
	    leftCol := startCol
	].
	"redraw selected part"
	(selectionEndLine > line) ifTrue:[
	    rightCol := endCol
	] ifFalse:[
	    rightCol := selectionEndCol min:endCol
	].
	self drawVisibleLineSelected:visLine from:leftCol to:rightCol.

	"redraw part after selection"
	(rightCol < endCol) ifTrue:[
	    super redrawVisibleLine:visLine from:(rightCol + 1) to:endCol
	]
    ].

    "special care for first and last line of selection:
     must handle margin also"

    ((line == selectionEndLine)
    and:[(startCol == 1)
    and:[selectionStartLine < selectionEndLine]])
    ifTrue:[
	self clearMarginOfVisibleLine:visLine with:self currentSelectionBgColor.
    ].

    ((line == selectionStartLine)
    and:[(startCol == 1)
    and:[selectionStartLine < selectionEndLine]])
    ifTrue:[
	self clearMarginOfVisibleLine:visLine with:bgColor.
    ].

    ((line > selectionStartLine)
    and:[(startCol == 1)
    and:[selectionStartLine < selectionEndLine
    and:[line < selectionEndLine]]])
    ifTrue:[
	self clearMarginOfVisibleLine:visLine with:self currentSelectionBgColor.
    ]

    "Modified: 6.3.1996 / 14:23:26 / cg"
! !

!TextView methodsFor:'searching'!

clearSearchAction
    searchAction := nil.
!

scanFor:aCharacter fromLine:startLine col:startCol forward:forward
                     ifFound:foundBlock
                  ifNotFound:notFoundBlock
    "search for a character in the direction given by forward.
     Performs foundBlock with line/col as argument if found, notFoundBlock if not."

    |lineString
     line   "{ Class: SmallInteger }"
     col    "{ Class: SmallInteger }"
     delta  "{ Class: SmallInteger }"
     endCol "{ Class: SmallInteger }"
     cc
     maxLine "{ Class: SmallInteger }"
      |

    col := startCol.
    line := startLine.
    forward ifTrue:[
        delta := 1.
    ] ifFalse:[
        delta := -1.
    ].

    lineString := list at:line.
    maxLine := list size.

    col := col + delta.
    [true] whileTrue:[
        lineString notNil ifTrue:[
            forward ifTrue:[
                endCol := lineString size.
            ] ifFalse:[
                endCol := 1
            ].

            col to:endCol by:delta do:[:rCol |
                cc := lineString at:rCol.
                cc == aCharacter ifTrue:[
                    ^ foundBlock value:line value:rCol.
                ]
            ].
        ].
        line := line + delta.
        (line < 1 or:[line > maxLine]) ifTrue:[
            ^ notFoundBlock value
        ].
        lineString := list at:line.
        forward ifTrue:[
            col := 1
        ] ifFalse:[
            col := lineString size
        ]
    ].
    "not reached"

    "Modified: 15.10.1996 / 12:22:30 / cg"
    "Created: 11.9.1997 / 04:36:29 / cg"
!

searchAction
    ^ searchAction
!

searchAction:aSearcherOrSearchBlock
    searchAction := aSearcherOrSearchBlock
!

searchAgainInSameDirection
    "search again in the same direction and -if found- position cursor"

    |ign match|

    searchBarActionBlock notNil ifTrue:[
        searchBarActionBlock value:#forward value:self.
        ^ self
    ].

    ign := lastSearchIgnoredCase ? LastSearchIgnoredCase ? true.
    match := lastSearchWasMatch ? LastSearchWasMatch ? false.

    self setSearchPatternWithMatchEscapes: match.
    lastSearchPattern notNil ifTrue:[
        lastSearchDirection == #backward ifTrue:[
            self
                searchBwd:lastSearchPattern
                ignoreCase:ign
                match: match
        ] ifFalse:[
            self
                searchFwd:lastSearchPattern
                ignoreCase:ign
                match: match
        ]
    ]

    "Created: / 03-05-1999 / 15:02:16 / cg"
    "Modified: / 21-09-2006 / 16:47:57 / cg"
!

searchBwd
    "search backward (for the same thing again)
     If found, position cursor"

    |ign selectedVariable|

    searchAction notNil ifTrue:[
        "/autosearch is cleared whenever there is search with user selection
        (self hasSelection and:[self hasSearchActionSelection not]) ifTrue: [self clearSearchAction].
    ].

    searchAction notNil ifTrue:[
        "/confusing: this is for autosearch of variables (browse variable uses, for example)
        self searchUsingSearchAction:#backward.
        ^ self.
    ].
    searchBarActionBlock notNil ifTrue:[
        searchBarActionBlock value:#backward value:self.
        ^ self
    ].
    lastSearchWasVariableSearch ifTrue:[
        selectedVariable := self syntaxElementForSelectedVariable.
        selectedVariable notNil ifTrue:[
            self searchVariableWithSyntaxElement:selectedVariable forward:false.
            ^ self.
        ].
        lastSearchWasVariableSearch := false.
    ].

    ign := lastSearchIgnoredCase ? LastSearchIgnoredCase ? true.

    self setSearchPatternWithMatchEscapes: false.
    lastSearchPattern isNil ifTrue:[
        LastSearchPatterns size > 0 ifTrue:[
            lastSearchPattern := LastSearchPatterns first
        ]
    ].

    lastSearchPattern notNil ifTrue:[
        lastSearchDirection := #backward.
        self rememberSearchPattern:lastSearchPattern.
        self
            searchBwd:lastSearchPattern
            ignoreCase:ign
    ]

    "Modified: / 08-03-2012 / 14:26:25 / cg"
!

searchBwd:pattern
    "do a backward search"

    self searchBwd:pattern ifAbsent:[self showNotFound].
"/    lastSearchIgnoredCase := false.
    lastSearchPattern := pattern string

    "Modified: / 21-09-2006 / 16:48:29 / cg"
!

searchBwd:pattern ifAbsent:aBlock
    "do a backward search"

    self
        searchBwdUsingSpec:(ListView::SearchSpec new
                                        pattern:pattern)
        ifAbsent:aBlock

    "Modified: 13.9.1997 / 01:05:49 / cg"
!

searchBwd:pattern ignoreCase:ign
    "do a backward search"

    self
        searchBwd:pattern
        ignoreCase:ign
        ifAbsent:[
                    self sensor compressKeyPressEventsWithKey:#FindPrev.
                    self showNotFound
                 ].
    "/ lastSearchIgnoredCase := ign.
    lastSearchPattern := pattern string

    "Created: / 13-09-1997 / 06:18:00 / cg"
    "Modified: / 23-03-2012 / 12:10:25 / cg"
!

searchBwd:pattern ignoreCase:ign ifAbsent:aBlock
    "do a backward search"

    self
        searchBwdUsingSpec:(ListView::SearchSpec new
                                        pattern:pattern
                                        ignoreCase:ign)
        ifAbsent:aBlock

    "Modified: 13.9.1997 / 01:05:49 / cg"
    "Created: 13.9.1997 / 06:18:41 / cg"
!

searchBwd:pattern ignoreCase:ign match: match
    "do a backward search.
    match pattern functionality is not yet available for backward search"

    "/ lastSearchWasMatch := match.
    self searchBwd:pattern ignoreCase:ign.

    "Modified: / 23-03-2012 / 12:12:44 / cg"
!

searchBwdUsingSpec:searchSpec
    "do a backward search"

    self
        searchBwdUsingSpec:searchSpec
        ifAbsent:[self showNotFound].

"/    lastSearchIgnoredCase := false.
    lastSearchPattern := searchSpec pattern string

    "Modified: / 21-09-2006 / 16:48:29 / cg"
!

searchBwdUsingSpec:searchSpec ifAbsent:aBlock
    "do a backward search"

    |pos startLine startCol|

    pos :=  self startPositionForSearchBackward.
    startLine := pos y.
    startCol := pos x.

    self
        searchBackwardUsingSpec:searchSpec
        startingAtLine:startLine col:startCol
        ifFound:[:line :col :endColOrNil|
            self showMatch:searchSpec pattern isMatch:searchSpec match atLine:line col:col endCol:endColOrNil
        ]
        ifAbsent:aBlock
!

searchForAndSelectMatchingParenthesisFromLine:startLine col:startCol
    "select characters enclosed by matching parenthesis if one is under startLine/Col"

    self
        searchForMatchingParenthesisFromLine:startLine col:startCol
        ifFound:[:line :col |
                  self selectFromLine:startLine col:startCol
                               toLine:line col:col]
        ifNotFound:[self showNotFound]
        onError:[self beep]

    "Modified: 9.10.1997 / 12:57:34 / cg"
!

searchForMatchingParenthesisFromLine:startLine col:startCol
                     ifFound:foundBlock
                  ifNotFound:notFoundBlock
                     onError:failBlock

    "search for a matching parenthesis; start search with character at startLine/startCol.
     Search for the corresponding character is done forward if its an opening,
     backwards if its a closing parenthesis.
     Evaluate foundBlock with line/col as argument if found, notFoundBlock if not.
     If there is a nesting error, evaluate failBlock."

    ^ self
        searchForMatchingParenthesisFromLine:startLine col:startCol
        ifFound:foundBlock
        ifNotFound:notFoundBlock
        onError:failBlock
        ignoring:(parenthesisSpecification at:#ignore ifAbsent:#()) "/ #( $' $" '$[' '$]' '${' '$)' )

    "Modified: / 12-04-2007 / 11:24:24 / cg"
!

searchForMatchingParenthesisFromLine:startLine col:startCol
                     ifFound:foundBlock
                  ifNotFound:notFoundBlock
                     onError:failBlock
                    ignoring:ignoreSet

    "search for a matching parenthesis; start search with character at startLine/startCol.
     Search for the corresponding character is done forward if its an opening,
     backwards if its a closing parenthesis.
     Evaluate foundBlock with line/col as argument if found, notFoundBlock if not.
     If there is a nesting error, evaluate failBlock."

    ^ self
        searchForMatchingParenthesisFromLine:startLine col:startCol
        ifFound:foundBlock
        ifNotFound:notFoundBlock
        onError:failBlock
        openingCharacters: (parenthesisSpecification at:#open)  "/ #( $( $[ ${ "$> $<")
        closingCharacters: (parenthesisSpecification at:#close) "/ #( $) $] $} "$> $<")
        ignoredCharacters: ignoreSet
        specialEOLComment: (parenthesisSpecification at:#eolComment ifAbsent:#()) "/

"/    |i direction lineString
"/     parChar charSet  closingChar
"/     ignoring
"/     line   "{ Class: SmallInteger }"
"/     col    "{ Class: SmallInteger }"
"/     delta  "{ Class: SmallInteger }"
"/     endCol "{ Class: SmallInteger }"
"/     runCol "{ Class: SmallInteger }"
"/     cc prevCC nextCC incSet decSet
"/     nesting "{ Class: SmallInteger }"
"/     maxLine "{ Class: SmallInteger }"
"/     ign skip anySet|
"/
"/    charSet := #( $( $) $[ $] ${ $} " $< $> " ).
"/
"/    parChar := self characterAtLine:startLine col:startCol.
"/    i := charSet indexOf:parChar.
"/    i == 0 ifTrue:[
"/        ^ failBlock value   "not a parenthesis"
"/    ].
"/    direction := #( fwd bwd fwd bwd fwd bwd fwd bwd) at:i.
"/    closingChar := #( $) $( $] $[ $} ${ "$> $<") at:i.
"/
"/    col := startCol.
"/    line := startLine.
"/    direction == #fwd ifTrue:[
"/        delta := 1.
"/        incSet := #( $( $[ ${ "$<" ).
"/        decSet := #( $) $] $} "$>" ).
"/    ] ifFalse:[
"/        delta := -1.
"/        incSet := #( $) $] $} "$>" ).
"/        decSet := #( $( $[ ${ "$<" ).
"/    ].
"/    anySet := Set new.
"/    anySet addAll:incSet; addAll:decSet; addAll:ignoreSet.
"/    anySet := (anySet select:[:c | c isCharacter]) asString.
"/
"/    nesting := 1.
"/    ignoring := false.
"/    lineString := list at:line.
"/    maxLine := list size.
"/
"/    col := col + delta.
"/    [nesting ~~ 0] whileTrue:[
"/        (lineString notNil
"/        and:[lineString includesAny:anySet]) ifTrue:[
"/            direction == #fwd ifTrue:[
"/                endCol := lineString size.
"/            ] ifFalse:[
"/                endCol := 1
"/            ].
"/
"/            col to:endCol by:delta do:[:rCol |
"/                runCol := rCol.
"/
"/                cc := lineString at:runCol.
"/                runCol < lineString size ifTrue:[
"/                    nextCC := lineString at:runCol+1
"/                ] ifFalse:[
"/                    nextCC := nil
"/                ].
"/                runCol > 1 ifTrue:[
"/                    prevCC := lineString at:runCol-1
"/                ] ifFalse:[
"/                    prevCC := nil
"/                ].
"/
"/                ign := skip := false.
"/
"/                "/ check for comments.
"/
"/                ((cc == $" and:[nextCC == $/])
"/                or:[prevCC == $$ ]) ifTrue:[
"/                    "/ do nothing
"/
"/                    skip := true.
"/                ] ifFalse:[
"/                    ignoreSet do:[:ignore |
"/                        ignore == cc ifTrue:[
"/                            ign := true
"/                        ] ifFalse:[
"/                            ignore isString ifTrue:[
"/                                cc == (ignore at:2) ifTrue:[
"/                                    runCol > 1 ifTrue:[
"/                                        (lineString at:(runCol-1)) == (ignore at:1) ifTrue:[
"/                                            skip := true
"/                                        ]
"/                                    ]
"/                                ] ifFalse:[
"/                                    cc == (ignore at:1) ifTrue:[
"/                                        runCol < lineString size ifTrue:[
"/                                            (lineString at:(runCol+1)) == (ignore at:2) ifTrue:[
"/                                                skip := true
"/                                            ]
"/                                        ]
"/                                    ]
"/                                ]
"/                            ]
"/                        ]
"/                    ]
"/                ].
"/
"/                ign ifTrue:[
"/                    ignoring := ignoring not
"/                ].
"/
"/                ignoring ifFalse:[
"/                    skip ifFalse:[
"/                        (incSet includes:cc) ifTrue:[
"/                            nesting := nesting + 1
"/                        ] ifFalse:[
"/                            (decSet includes:cc) ifTrue:[
"/                                nesting := nesting - 1
"/                            ]
"/                        ]
"/                    ]
"/                ].
"/
"/                nesting == 0 ifTrue:[
"/                    "check if legal"
"/
"/                    skip ifFalse:[
"/                        cc == closingChar ifFalse:[
"/                            ^ failBlock value
"/                        ].
"/                        ^ foundBlock value:line value:runCol.
"/                    ]
"/                ]
"/            ].
"/        ].
"/        line := line + delta.
"/        (line < 1 or:[line > maxLine]) ifTrue:[
"/            ^ failBlock value
"/        ].
"/        lineString := list at:line.
"/        direction == #fwd ifTrue:[
"/            col := 1
"/        ] ifFalse:[
"/            col := lineString size
"/        ]
"/    ].
"/    ^ notFoundBlock value

    "Modified: / 12-04-2007 / 11:25:36 / cg"
!

searchForMatchingParenthesisFromLine:startLine col:startCol
                     ifFound:foundBlock
                  ifNotFound:notFoundBlock
                     onError:failBlock
           openingCharacters:openingCharacters
           closingCharacters:closingCharacters

    "search for a matching parenthesis; start search with character at startLine/startCol.
     Search for the corresponding character is done forward if its an opening,
     backwards if its a closing parenthesis.
     Evaluate foundBlock with line/col as argument if found, notFoundBlock if not.
     If there is a nesting error, evaluate failBlock."

    ^ self
        searchForMatchingParenthesisFromLine:startLine col:startCol
        ifFound:foundBlock
        ifNotFound:notFoundBlock
        onError:failBlock
        openingCharacters: openingCharacters
        closingCharacters: closingCharacters
        ignoredCharacters: (parenthesisSpecification at:#ignore ifAbsent:#())
        specialEOLComment: (parenthesisSpecification at:#eolComment ifAbsent:#()) "/

"/    |i direction lineString
"/     parChar charSet  closingChar
"/     ignoring
"/     line   "{ Class: SmallInteger }"
"/     col    "{ Class: SmallInteger }"
"/     delta  "{ Class: SmallInteger }"
"/     endCol "{ Class: SmallInteger }"
"/     runCol "{ Class: SmallInteger }"
"/     cc prevCC nextCC incSet decSet
"/     nesting "{ Class: SmallInteger }"
"/     maxLine "{ Class: SmallInteger }"
"/     ign skip anySet|
"/
"/    charSet := #( $( $) $[ $] ${ $} " $< $> " ).
"/
"/    parChar := self characterAtLine:startLine col:startCol.
"/    i := charSet indexOf:parChar.
"/    i == 0 ifTrue:[
"/        ^ failBlock value   "not a parenthesis"
"/    ].
"/    direction := #( fwd bwd fwd bwd fwd bwd fwd bwd) at:i.
"/    closingChar := #( $) $( $] $[ $} ${ "$> $<") at:i.
"/
"/    col := startCol.
"/    line := startLine.
"/    direction == #fwd ifTrue:[
"/        delta := 1.
"/        incSet := #( $( $[ ${ "$<" ).
"/        decSet := #( $) $] $} "$>" ).
"/    ] ifFalse:[
"/        delta := -1.
"/        incSet := #( $) $] $} "$>" ).
"/        decSet := #( $( $[ ${ "$<" ).
"/    ].
"/    anySet := Set new.
"/    anySet addAll:incSet; addAll:decSet; addAll:ignoreSet.
"/    anySet := (anySet select:[:c | c isCharacter]) asString.
"/
"/    nesting := 1.
"/    ignoring := false.
"/    lineString := list at:line.
"/    maxLine := list size.
"/
"/    col := col + delta.
"/    [nesting ~~ 0] whileTrue:[
"/        (lineString notNil
"/        and:[lineString includesAny:anySet]) ifTrue:[
"/            direction == #fwd ifTrue:[
"/                endCol := lineString size.
"/            ] ifFalse:[
"/                endCol := 1
"/            ].
"/
"/            col to:endCol by:delta do:[:rCol |
"/                runCol := rCol.
"/
"/                cc := lineString at:runCol.
"/                runCol < lineString size ifTrue:[
"/                    nextCC := lineString at:runCol+1
"/                ] ifFalse:[
"/                    nextCC := nil
"/                ].
"/                runCol > 1 ifTrue:[
"/                    prevCC := lineString at:runCol-1
"/                ] ifFalse:[
"/                    prevCC := nil
"/                ].
"/
"/                ign := skip := false.
"/
"/                "/ check for comments.
"/
"/                ((cc == $" and:[nextCC == $/])
"/                or:[prevCC == $$ ]) ifTrue:[
"/                    "/ do nothing
"/
"/                    skip := true.
"/                ] ifFalse:[
"/                    ignoreSet do:[:ignore |
"/                        ignore == cc ifTrue:[
"/                            ign := true
"/                        ] ifFalse:[
"/                            ignore isString ifTrue:[
"/                                cc == (ignore at:2) ifTrue:[
"/                                    runCol > 1 ifTrue:[
"/                                        (lineString at:(runCol-1)) == (ignore at:1) ifTrue:[
"/                                            skip := true
"/                                        ]
"/                                    ]
"/                                ] ifFalse:[
"/                                    cc == (ignore at:1) ifTrue:[
"/                                        runCol < lineString size ifTrue:[
"/                                            (lineString at:(runCol+1)) == (ignore at:2) ifTrue:[
"/                                                skip := true
"/                                            ]
"/                                        ]
"/                                    ]
"/                                ]
"/                            ]
"/                        ]
"/                    ]
"/                ].
"/
"/                ign ifTrue:[
"/                    ignoring := ignoring not
"/                ].
"/
"/                ignoring ifFalse:[
"/                    skip ifFalse:[
"/                        (incSet includes:cc) ifTrue:[
"/                            nesting := nesting + 1
"/                        ] ifFalse:[
"/                            (decSet includes:cc) ifTrue:[
"/                                nesting := nesting - 1
"/                            ]
"/                        ]
"/                    ]
"/                ].
"/
"/                nesting == 0 ifTrue:[
"/                    "check if legal"
"/
"/                    skip ifFalse:[
"/                        cc == closingChar ifFalse:[
"/                            ^ failBlock value
"/                        ].
"/                        ^ foundBlock value:line value:runCol.
"/                    ]
"/                ]
"/            ].
"/        ].
"/        line := line + delta.
"/        (line < 1 or:[line > maxLine]) ifTrue:[
"/            ^ failBlock value
"/        ].
"/        lineString := list at:line.
"/        direction == #fwd ifTrue:[
"/            col := 1
"/        ] ifFalse:[
"/            col := lineString size
"/        ]
"/    ].
"/    ^ notFoundBlock value

    "Modified: / 12-04-2007 / 11:25:36 / cg"
!

searchForMatchingParenthesisFromLine:startLine col:startCol
                     ifFound:foundBlock
                  ifNotFound:notFoundBlock
                     onError:failBlock
           openingCharacters:openingCharacters
           closingCharacters:closingCharacters
           ignoredCharacters:ignoreSet
          specialEOLComment:eolCommentSequence

    "search for a matching parenthesis; start search with character at startLine/startCol.
     Search for the corresponding character is done forward if its an opening,
     backwards if its a closing parenthesis.
     Evaluate foundBlock with line/col as argument if found, notFoundBlock if not.
     If there is a nesting error, evaluate failBlock."

    |i direction lineString
     parChar charSet  closingChar
     ignoring
     line   "{ Class: SmallInteger }"
     col    "{ Class: SmallInteger }"
     delta  "{ Class: SmallInteger }"
     endCol "{ Class: SmallInteger }"
     runCol "{ Class: SmallInteger }"
     cc prevCC nextCC incSet decSet
     nesting "{ Class: SmallInteger }"
     maxLine "{ Class: SmallInteger }"
     ign skip anySet
     eol1 eol2|

    self assert:(openingCharacters size == closingCharacters size).

    charSet := openingCharacters , closingCharacters.

    parChar := self characterAtLine:startLine col:startCol.
    i := charSet indexOf:parChar.
    i == 0 ifTrue:[
        ^ failBlock value   "not a parenthesis"
    ].

    direction := (i <= openingCharacters size) ifTrue:[#fwd] ifFalse:[#bwd].
    closingChar := (closingCharacters , openingCharacters) at:i.

    eol1 := eolCommentSequence at:1 ifAbsent:nil.
    eol2 := eolCommentSequence at:2 ifAbsent:nil.

    col := startCol.
    line := startLine.
    direction == #fwd ifTrue:[
        delta := 1.
        incSet := openingCharacters.
        decSet := closingCharacters.
    ] ifFalse:[
        delta := -1.
        incSet := closingCharacters.
        decSet := openingCharacters.
    ].
    anySet := Set new.
    anySet addAll:incSet; addAll:decSet; addAll:ignoreSet.
    anySet := (anySet select:[:c | c isCharacter]) asString.

    nesting := 1.
    ignoring := false.
    lineString := list at:line.
    maxLine := list size.

    col := col + delta.
    [nesting ~~ 0] whileTrue:[
        (lineString notNil
        and:[lineString includesAny:anySet]) ifTrue:[
            direction == #fwd ifTrue:[
                endCol := lineString size.
            ] ifFalse:[
                endCol := 1
            ].

            col to:endCol by:delta do:[:rCol |
                runCol := rCol.

                cc := lineString at:runCol.
                runCol < lineString size ifTrue:[
                    nextCC := lineString at:runCol+1
                ] ifFalse:[
                    nextCC := nil
                ].
                runCol > 1 ifTrue:[
                    prevCC := lineString at:runCol-1
                ] ifFalse:[
                    prevCC := nil
                ].

                ign := skip := false.

                "/ check for comments.

                ((cc == eol1 and:[nextCC == eol2])
                or:[prevCC == $$ ]) ifTrue:[
                    "/ do nothing

                    skip := true.
                ] ifFalse:[
                    ignoreSet do:[:ignore |
                        ignore == cc ifTrue:[
                            ign := true
                        ] ifFalse:[
                            ignore isString ifTrue:[
                                cc == (ignore at:2) ifTrue:[
                                    runCol > 1 ifTrue:[
                                        (lineString at:(runCol-1)) == (ignore at:1) ifTrue:[
                                            skip := true
                                        ]
                                    ]
                                ] ifFalse:[
                                    cc == (ignore at:1) ifTrue:[
                                        runCol < lineString size ifTrue:[
                                            (lineString at:(runCol+1)) == (ignore at:2) ifTrue:[
                                                skip := true
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ].

                ign ifTrue:[
                    ignoring := ignoring not
                ].

                ignoring ifFalse:[
                    skip ifFalse:[
                        (incSet includes:cc) ifTrue:[
                            nesting := nesting + 1
                        ] ifFalse:[
                            (decSet includes:cc) ifTrue:[
                                nesting := nesting - 1
                            ]
                        ]
                    ]
                ].

                nesting == 0 ifTrue:[
                    "check if legal"
                    skip ifFalse:[
                        cc == closingChar ifFalse:[
                            ^ failBlock value
                        ].
                        ^ foundBlock value:line value:runCol.
                    ]
                ]
            ].
        ].
        line := line + delta.
        (line < 1 or:[line > maxLine]) ifTrue:[
            ^ failBlock value
        ].
        lineString := list at:line.
        direction == #fwd ifTrue:[
            col := 1
        ] ifFalse:[
            col := lineString size
        ]
    ].
    ^ notFoundBlock value

    "Modified: 15.10.1996 / 12:22:30 / cg"
!

searchFwd
    "search forward for the same pattern or selection again"

    |ign match variable|

    searchAction notNil ifTrue:[
        "/ autosearch is cleared whenever there is search with user selection
        (self hasSelection and:[self hasSearchActionSelection not]) ifTrue: [self clearSearchAction].
    ].

    searchAction notNil ifTrue:[
        "/ confusing: this is for autosearch of variables (browse variable uses, for example)
        self searchUsingSearchAction:#forward.
        ^ self.
    ].
    searchBarActionBlock notNil ifTrue:[
        searchBarActionBlock value:#forward value:self.
        ^ self
    ].
    lastSearchWasVariableSearch ifTrue:[
        variable := self syntaxElementForSelectedVariable.
        variable notNil ifTrue:[
            self searchVariableWithSyntaxElement:variable forward:true.
            ^ self.
        ].
        lastSearchWasVariableSearch := false.
    ].

    ign := lastSearchIgnoredCase ? LastSearchIgnoredCase ? true.
    match := lastSearchWasMatch ? LastSearchWasMatch ? false.

    selectStyle == #wordLeft ifTrue:[
        "
         remove the space from the selection
        "
        selectionStartCol := selectionStartCol + 1.
        super redrawLine:selectionStartLine from:selectionStartCol-1 to:selectionStartCol-1.
        selectStyle := #word.
        self selectionChanged.
    ].
    self setSearchPatternWithMatchEscapes: match.

    lastSearchPattern isNil ifTrue:[
        LastSearchPatterns size > 0 ifTrue:[
            lastSearchPattern := LastSearchPatterns first
        ]
    ].

    lastSearchPattern notNil ifTrue:[
        self rememberSearchPattern:lastSearchPattern.
        lastSearchDirection := #forward.
        self
            searchFwd:lastSearchPattern
            ignoreCase:ign
            match: match
    ]

    "Modified: / 08-03-2012 / 14:25:42 / cg"
!

searchFwd:pattern
    "do a forward search"

    self searchFwd:pattern ifAbsent:[self showNotFound].
"/    lastSearchIgnoredCase := false.
    lastSearchPattern := pattern string

    "Modified: / 21-09-2006 / 16:52:04 / cg"
!

searchFwd:pattern ifAbsent:aBlock
    "do a forward search"

    self
        searchFwdUsingSpec:(ListView::SearchSpec new
                                pattern:pattern)
        ifAbsent:aBlock

    "Modified: / 21-09-2006 / 16:51:28 / cg"
!

searchFwd:pattern ignoreCase:ign
    "do a forward search"

    self
        searchFwdUsingSpec:(ListView::SearchSpec new
                                pattern:pattern
                                ignoreCase:ign)
        ifAbsent:[
                    self sensor compressKeyPressEventsWithKey:#FindNext.
                    self showNotFound
                 ].
    "/ lastSearchIgnoredCase := ign.
    lastSearchPattern := pattern string

    "Created: / 13-09-1997 / 06:18:13 / cg"
    "Modified: / 23-03-2012 / 12:09:59 / cg"
!

searchFwd:pattern ignoreCase:ign ifAbsent:aBlock
    "do a forward search"

    self
        searchFwdUsingSpec:(ListView::SearchSpec new
                                pattern:pattern
                                ignoreCase:ign)
        ifAbsent:aBlock

    "Modified: 13.9.1997 / 01:05:35 / cg"
    "Created: 13.9.1997 / 06:18:27 / cg"
!

searchFwd:pattern ignoreCase:ign match: match
    "do a forward search"

    self
        searchFwdUsingSpec:(ListView::SearchSpec new
                                pattern:pattern
                                ignoreCase:ign
                                match:match)
        ifAbsent:[
                    self sensor compressKeyPressEventsWithKey:#FindNext.
                    self showNotFound
                 ].
    "/ lastSearchIgnoredCase := ign.
    "/ lastSearchWasMatch := match.
    lastSearchPattern := pattern string

    "Created: / 13-09-1997 / 06:18:13 / cg"
    "Modified: / 23-03-2012 / 12:12:47 / cg"
!

searchFwd:pattern ignoreCase:ign match: match ifAbsent:aBlock
    "do a forward search"

    self
        searchFwdUsingSpec:(ListView::SearchSpec new
                                pattern:pattern
                                ignoreCase:ign
                                match:match)
        ifAbsent:aBlock

    "Modified: 13.9.1997 / 01:05:35 / cg"
    "Created: 13.9.1997 / 06:18:27 / cg"
!

searchFwd:pattern ignoreCase:ign match: match startingAtLine:startLine col:startCol ifAbsent:aBlock
    "do a forward search"

    self
        searchFwdUsingSpec:(ListView::SearchSpec new
                                pattern:pattern
                                ignoreCase:ign
                                match:match)
        startingAtLine:startLine col:startCol
        ifAbsent:aBlock
!

searchFwdUsingSpec:searchSpec
    "do a forward search"

    self
        searchFwdUsingSpec:searchSpec
        ifAbsent:[self showNotFound].

"/    lastSearchIgnoredCase := false.
    lastSearchPattern := searchSpec pattern string

    "Modified: / 21-09-2006 / 16:52:04 / cg"
!

searchFwdUsingSpec:searchSpec ifAbsent:aBlock
    "do a forward search"

    |pos startLine startCol|

    pos := self startPositionForSearchForward.
    startLine := pos y.
    startCol := pos x.

    self
        searchFwdUsingSpec:searchSpec
        startingAtLine:startLine col:startCol
        ifAbsent:aBlock

    "Modified: 13.9.1997 / 01:05:35 / cg"
    "Created: 13.9.1997 / 06:18:27 / cg"
!

searchFwdUsingSpec:searchSpec startingAtLine:startLine col:startCol ifAbsent:aBlock
    "do a forward search"

    self
        searchForwardUsingSpec:searchSpec
        startingAtLine:startLine col:startCol
        ifFound:[:line :col :endColOrNil|
            self showMatch:searchSpec pattern isMatch:searchSpec match atLine:line col:col endCol:endColOrNil
        ]
        ifAbsent:aBlock
!

searchPattern
    "return the last search pattern"

    ^ lastSearchPattern
!

searchUsingSearchAction:direction
    "search using a searchaction which has been given by someone else.
     Typically, this is the embedding browser, which has provided an action for
      a language aware search (as opposed to a naive string search)"

    self
        searchUsingSearchAction:direction
        ifAbsent:[
                    self sensor compressKeyPressEventsWithKey:#FindNext.
                    self showNotFound
                 ]
!

searchUsingSearchAction:direction ifAbsent:notFoundAction
    "search using a searchaction which has been given by someone else.
     Typically, this is the embedding browser, which has provided an action for
      a language aware search (as opposed to a naive string search)"

    |pos startLine startCol|

    pos :=  direction == #backward
                ifTrue:[self startPositionForSearchBackward]
                ifFalse:[self startPositionForSearchForward].
    startLine := pos y.
    startCol := pos x.

    searchAction notNil ifTrue:[
        searchAction
            value:direction
            value:startLine
            value:startCol
            value:[:line :col | self selectFromLine:line toLine:line]
            value:notFoundAction.
        self hasSelection ifTrue: [
            self changeTypeOfSelectionTo: #searchAction.
        ].
    ].
!

setSearchPattern
    "set the searchpattern from the selection if there is one"

    self setSearchPatternWithMatchEscapes: false.
!

setSearchPattern:aStringOrNil
    "set the searchpattern for future searches"

    aStringOrNil isEmptyOrNil ifTrue:[
        lastSearchPattern := nil.
    ] ifFalse:[
        "/ not withoutSeparators: may want to search for spaces...
        lastSearchPattern := aStringOrNil asString "withoutSeparators" string.
    ].

    "Modified: / 6.3.1999 / 23:47:36 / cg"
!

setSearchPattern:aString ignoreCase:aBoolean
    "set the searchpattern and caseIgnore for future searches"

    self setSearchPattern:aString.
    lastSearchIgnoredCase := aBoolean.
!

setSearchPattern:aString ignoreCase:ignoreCaseBoolean match:matchBoolean
    "set the searchpattern and caseIgnore for future searches"

    self setSearchPattern:aString.
    lastSearchIgnoredCase := ignoreCaseBoolean.
    lastSearchWasMatch := matchBoolean.
!

setSearchPatternWithMatchEscapes: match
    "set the searchpattern from the selection if there is one"

    |sel searchPattern |

"/    clickPos isNil ifTrue:[^ self].

    sel := self selection.
    sel notNil ifTrue:[
        searchPattern := sel asString.
        match ifTrue:[searchPattern := searchPattern withMatchEscapes].
        self setSearchPattern:searchPattern.
    ]

    "Modified: / 6.3.1999 / 23:48:04 / cg"
!

showMatch:pattern atLine:line col:col
    <resource: #obsolete>
    "after a search, highlight the matched pattern.
     The code below needs a rewrite to take care of match-characters
     (for now, it only highlights simple patterns and '*string*' correctly)"

    self showMatch:pattern isMatch:true atLine:line col:col endCol:nil
!

showMatch:pattern isMatch:isMatch atLine:line col:col
    <resource: #obsolete>
    "after a search, highlight the matched pattern."

    self showMatch:pattern isMatch:isMatch atLine:line col:col endCol:nil
!

showMatch:pattern isMatch:isMatch atLine:line col:col endCol:encColOrNil
    "after a search, highlight the matched pattern.
     The code below needs a rewrite to take care of match-characters
     (for now, it only highlights simple patterns and '*string*' correctly)"

    |endCol realPattern|

    (endCol := encColOrNil) isNil ifTrue:[
        "/ a hack.
        realPattern := pattern.
        isMatch ifTrue: [
            (realPattern startsWith:$*) ifTrue:[
                realPattern := realPattern copyButFirst
            ].
            (realPattern endsWith:$*) ifTrue:[
                realPattern := realPattern copyButLast
            ].
        ].
        endCol := (col + realPattern size - 1).
    ].

    self selectFromLine:line col:col toLine:line col:endCol.
    self makeLineVisible:line
!

showNotFound
    "search not found - tell user by beeping and changing
     cursor for a while (sometimes I work with a headset :-)
     (used to be: tell user by changing cursor for a while)"

    self withCursor:(Cursor cross) do:[
        self beep.
        Processor activeProcess millisecondDelay:200.
    ]

    "Modified: 20.2.1997 / 12:49:27 / cg"
!

startPositionForSearchBackward
    ^ self startPositionForSearchBackwardBasedOnSelection
!

startPositionForSearchBackwardBasedOnSelection
    |startLine startCol|

    selectionStartLine notNil ifTrue:[
        startLine := selectionStartLine.
        startCol := selectionStartCol
    ] ifFalse:[
        startLine := 1.
        startCol := 1
    ].

    ^ startCol @ startLine
!

startPositionForSearchForward
    ^ self startPositionForSearchForwardBasedOnSelection
!

startPositionForSearchForwardBasedOnSelection
    |startLine startCol|

    selectionStartLine notNil ifTrue:[
        startLine := selectionStartLine.
        startCol := selectionStartCol
    ] ifFalse:[
        startLine := 1.
        startCol := 1
    ].

    ^ startCol @ startLine
! !

!TextView methodsFor:'selections'!

changeTypeOfSelectionTo:newType
    "ignored here - but redefined in subclasses which
     differentiate between pasted- and user-selections"
!

expandSelectionDown
    |l t|

    selectionStartLine notNil ifTrue:[
	expandingTop == true ifTrue:[
	    l := selectionStartLine.
	    selectionStartLine := selectionStartLine + 1.
	    (selectionStartLine > clickLine
	    or:[selectionStartLine == clickLine and:[selectionStartCol > clickCol]])
	    ifTrue:[
		t := selectionStartLine.
		selectionStartLine := selectionEndLine.
		selectionEndLine := t.
		t := selectionStartCol.
		selectionStartCol := selectionEndCol.
		selectionEndCol := t.
		expandingTop := false
	    ].
	] ifFalse:[
	    l := selectionEndLine.
	    selectionEndLine := selectionEndLine + 1.
	].
"/        self redrawLine:l.
"/        self redrawLine:l+1.
	self validateNewSelection.
	self setPrimarySelection.
	self selectionChanged.
	self redrawFromLine:l to:l+1.
	self makeSelectionVisible.
    ].

    "Created: / 01-03-1996 / 23:35:08 / cg"
    "Modified: / 18-03-1996 / 17:18:15 / cg"
    "Modified: / 17-04-2012 / 21:01:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expandSelectionLeft
    |c l t c1 c2|

    selectionStartLine notNil ifTrue:[
	expandingTop == true ifTrue:[
	    selectionStartCol == 0 ifTrue:[^ self].
	    l := selectionStartLine.
	    selectionStartCol := (selectionStartCol - 1) max:1.
	    c := selectionStartCol.
	] ifFalse:[
	    l := selectionEndLine.
	    selectionEndCol := (selectionEndCol - 1) max:0.
	    c := selectionEndCol.
	    selectionEndLine == selectionStartLine ifTrue:[
		selectionEndCol <= selectionStartCol ifTrue:[
		    t := selectionStartCol. selectionStartCol := selectionEndCol.
		    selectionEndCol := t.
		    expandingTop := true.
		    c := selectionStartCol.
		]
	    ].
	].
	c1 := c.
	c2 := c1 + 1.
	c1 == 0 ifTrue:[
	    c1 := 1
	].
	self validateNewSelection.
	self setPrimarySelection.
	self selectionChanged.
	self redrawLine:l from:c1 to:c2.
	self makeSelectionVisible.
    ].

    "Modified: / 18-03-1996 / 17:05:46 / cg"
    "Modified: / 17-04-2012 / 21:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expandSelectionRight
    |l c t|

    selectionStartLine notNil ifTrue:[
	expandingTop == true ifTrue:[
	    l := selectionStartLine.
	    c := selectionStartCol.
	    selectionStartCol := selectionStartCol + 1.
	    l == selectionEndLine ifTrue:[
		c >= selectionEndCol ifTrue:[
		    expandingTop := false.
		    t := selectionStartCol. selectionStartCol := selectionEndCol.
		    selectionEndCol := t.
		    c := selectionStartCol.
		]
	    ]
	] ifFalse:[
	    l := selectionEndLine.
	    c := selectionEndCol.
	    selectionEndCol := selectionEndCol + 1.
	].

	self validateNewSelection.
	self setPrimarySelection.
	self selectionChanged.
	self redrawLine:l from:(c max:1) to:c+1.
	self makeSelectionVisible.
    ].

    "Created: / 01-03-1996 / 23:33:17 / cg"
    "Modified: / 06-03-1996 / 13:54:10 / cg"
    "Modified: / 17-04-2012 / 21:01:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expandSelectionUp
    |l t|

    selectionStartLine notNil ifTrue:[
	expandingTop == true ifTrue:[
	    selectionStartLine := (selectionStartLine - 1) max:1.
	    l := selectionStartLine.
	] ifFalse:[
	    selectionEndLine := (selectionEndLine - 1) max:0.

	    l := selectionEndLine.
	    (selectionEndLine < clickLine
	    or:[(selectionEndLine == clickLine and:[selectionEndCol < clickCol])])
	    ifTrue:[
		t := selectionStartLine.
		selectionStartLine := selectionEndLine.
		selectionEndLine := t.
		t := selectionStartCol.
		selectionStartCol := selectionEndCol.
		selectionEndCol := t.
		l := selectionStartLine.
		expandingTop := true
	    ].
	].
	self validateNewSelection.
	self setPrimarySelection.
	self selectionChanged.
	"/ self redrawLine:l.
	"/ self redrawLine:l+1.
	self redrawFromLine:l to:l+1.
	self makeSelectionVisible.
    ].

    "Modified: / 06-03-1996 / 14:12:06 / cg"
    "Modified: / 17-04-2012 / 21:01:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSelection
    "return true, if there is a selection"

    ^ selectionStartLine notNil
!

hasSelectionForCopy
    "return true, if there is a selection which can be copyied
     (the same as #hasSelection, except for editfields in password-mode)"

    ^ self hasSelection
!

hasSelectionWithinSingleLine
    "return true, if there is a selection and it is within a line"

    ^ selectionStartLine notNil
      and:[ selectionStartLine == selectionEndLine ]

    "Modified: / 04-07-2006 / 18:42:59 / fm"
!

hasSingleFullLineSelected
    ^ (selectionStartLine notNil
      and:[selectionEndLine notNil
      and:[selectionEndLine == (selectionStartLine+1)
      and:[selectionStartCol == 1
      and:[selectionEndCol == 0
    ]]]])
!

isInSelection:line col:aColNr
    "returns true, if the line, and column is in the selection
    "
    selectionStartLine isNil ifTrue:[^ false].
    selectionEndLine   isNil ifTrue:[^ false].

    (line between:selectionStartLine and:selectionEndLine) ifFalse:[
        ^ false
    ].

    line == selectionStartLine ifTrue:[
        aColNr < selectionStartCol ifTrue:[^ false]
    ].

    line == selectionEndLine ifTrue:[
        (selectionEndCol ~~ 0 and:[selectionEndCol < aColNr]) ifTrue:[^ false]
    ].
    ^ true
!

makeSelectionVisible
    "scroll to make the selection visible"

    |line col|

    selectionStartLine notNil ifTrue:[
        expandingTop == true ifTrue:[
            line := selectionStartLine.
            col := selectionStartCol.
        ] ifFalse:[
            line := selectionEndLine.
            col := selectionEndCol.
        ].
        self makeLineVisible:line.
        self makeColVisible:col inLine:line.
    ]

    "Modified: 6.3.1996 / 13:53:45 / cg"
!

selectAll
    "select the whole text"

    self selectFromLine:1 col:1 toLine:(list size + 1) col:0
!

selectFromCharacterPosition:pos1
    "compute line/col from the character position and select the text up to the end"

    |line1 col1 line2 col2|

    line1 := self lineOfCharacterPosition:pos1.
    col1 := pos1 - (self characterPositionOfLine:line1 col:1) + 1.

    line2 := (list size + 1).
    col2 := 0.
    self selectFromLine:line1 col:col1 toLine:line2 col:col2
!

selectFromCharacterPosition:pos1 to:pos2
    "compute line/col from character positions and select the text"

    |line1 col1 line2 col2|

    pos1 > pos2 ifTrue:[
	^ self unselect
    ].
    line1 := self lineOfCharacterPosition:pos1.
    col1 := pos1 - (self characterPositionOfLine:line1 col:1) + 1.
    col1 < 1 ifTrue:[ col1 := 1 ].

    line2 := self lineOfCharacterPosition:pos2.
    col2 := pos2 - (self characterPositionOfLine:line2 col:1) + 1.
    col2 < 1 ifTrue:[ col2 := 1 ].
    self selectFromLine:line1 col:col1 toLine:line2 col:col2
!

selectFromLine:startLine col:startCol toLine:endLine col:endCol
    "select a piece of text and redraw that area"

    | oldStartCol oldEndCol oldStartLine oldEndLine |

    oldStartCol := selectionStartCol ? startCol.
    oldStartLine := selectionStartLine ? startLine.
    oldEndCol := selectionEndCol ? endCol.
    oldEndLine := selectionEndLine ? endLine.  

    self unselectWithoutRedraw.
    startLine notNil ifTrue:[
	"new:"
	endLine < startLine ifTrue:[
	    ^ self selectFromLine:endLine col:endCol toLine:startLine col:startCol
	].
	(endLine == startLine and:[endCol < startCol]) ifTrue:[
	    endCol ~~ 0 ifTrue:[
		self selectFromLine:endLine col:endCol toLine:startLine col:startCol.
	    ].
	    ^ self
	].

        " old:
	endLine < startLine ifTrue:[^ self].
	(startLine == endLine and:[endCol < startCol]) ifTrue:[^ self].
        "

	selectionStartLine := startLine.
	selectionStartCol := startCol.
	selectionEndLine := endLine.
	selectionEndCol := endCol.
	self validateNewSelection.
	self setPrimarySelection.
	self selectionChanged.

        (selectionStartLine == selectionEndLine 
            and:[oldStartLine == selectionStartLine 
                and:[oldEndLine == selectionEndLine]]) ifTrue:[
                    self redrawLine:selectionStartLine 
                               from:(selectionStartCol min: oldStartCol) 
                                 to:(selectionEndCol max: oldEndCol)
                ] ifFalse:[
                    (selectionStartLine min: oldStartLine) to: (selectionEndLine max: oldEndLine) do:[:lineNr |
                        self redrawLine:lineNr
                    ]
                ].
	selectStyle := nil.
    ]

    "
     |v|

     v := TextView extent:300@300.
     v contents:('smalltalk.rc' asFilename contentsOfEntireFile).
     v openAndWait.

     Delay waitForSeconds:1.

     v selectFromLine:2 col:2 toLine:10 col:15
    "

    "Modified: / 02-01-1997 / 13:32:25 / cg"
    "Modified: / 28-08-2013 / 01:16:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectFromLine:startLine toLine:endLine
    "select a piece of text and redraw that area"

    self selectFromLine:startLine col:1 toLine:endLine+1 col:0

    "
     |v|

     v := TextView extent:300@300.
     v contents:('smalltalk.rc' asFilename contentsOfEntireFile).
     v openAndWait.

     Delay waitForSeconds:1.

     v selectFromLine:2 toLine:10
    "

    "Modified: 29.4.1996 / 12:23:46 / cg"
!

selectLine:selectLine
    "select one line and redraw it"

    self selectFromLine:selectLine col:1 toLine:(selectLine + 1) col:0.
    wordStartCol := selectionStartCol.
    wordEndCol := selectionEndCol.
    wordStartLine := selectionStartLine.
    wordEndLine := selectionEndLine.
    selectStyle := #line
!

selectLineAtY:y
    "select the line at given y-(view-)coordinate"

    |selectLine|

    selectLine := self lineAtY:y. "/ self visibleLineToListLine:(self visibleLineOfY:y).
    selectLine notNil ifTrue:[
        self selectLine:selectLine
    ]
!

selectLineWhereCharacterPosition:pos
    "select the line, where characterPosition pos is living.
     The argument pos starts at 1 from the start of the text
     and counts characters (i.e. can be used to convert from
     character position within a string to line-position in view)."

    self selectLine:(self lineOfCharacterPosition:pos)
!

selectWordAtLine:line col:col
    "select the word at given line/col"

    self
        wordAtLine:line col:col do:[
            :beginLine :beginCol :endLine :endCol :style |

            self selectFromLine:beginLine col:beginCol toLine:endLine col:endCol.
            selectStyle := style
        ]

    "Modified: 18.3.1996 / 17:30:38 / cg"
!

selectWordAtX:x y:y
    "select the word at given x/y-(view-)coordinate"

    |selectVisibleLine selectLine selectCol|

    selectStyle := nil.
    selectVisibleLine := self visibleLineOfY:y.
    selectLine := self visibleLineToListLine:selectVisibleLine.
    selectLine notNil ifTrue:[
        selectCol := self colOfX:x inVisibleLine:selectVisibleLine.
        self selectWordAtLine:selectLine col:selectCol
    ]

    "Modified: / 8.9.1998 / 21:22:46 / cg"
!

selectedInterval
    "return the selection-boundaries as interval"

    ^ self selectionStartIndex to:(self selectionStopIndex - 1)
!

selection
    "return the selection as a collection of (line-)strings.
     If the selection ends in a full line, the last entry in the returned
     collection will be an empty string."

    |sel|

    selectionStartLine isNil ifTrue:[^ nil].
    sel := self textFromLine:selectionStartLine col:(selectionStartCol max:1) toLine:selectionEndLine col:selectionEndCol.
    sel notEmptyOrNil ifTrue:[
        "/ this is rubbish; we are now always using unicode internally
        "/ any many more conversions would be needed at many places...
        (gc characterEncoding ? #'iso10646-1' "eg unicode") ~~ #'iso10646-1' ifTrue:[
            sel := sel encodeFrom:gc characterEncoding into:#'iso10646-1'
        ].
    ].
    ^ sel

    "Modified (comment): / 25-01-2012 / 00:29:09 / cg"
!

selectionAsString
    "return the selection as a String (i.e. without emphasis)"

    |sel|

    (sel := self selection) isNil ifTrue:[^ nil].
    sel := sel collect:[:each| each isNil ifTrue:[nil] ifFalse:[each string]].
    ^ (sel asStringWithCRsFrom:1 to:(sel size) compressTabs:false withCR:false) string
!

selectionChanged
    "can be redefined for notification or special actions.
     If you do, do not forget to do a super selectionChanged"

    self changed:#selection.
"/    self selectionHolder value:{ selectionStartCol @ selectionStartLine .
"/                                 selectionEndCol @ selectionEndLine }
!

selectionEndCol
    ^ selectionEndCol
!

selectionEndLine
    ^ selectionEndLine
!

selectionStartCol
    ^ selectionStartCol
!

selectionStartLine
    ^ selectionStartLine
!

setPrimarySelection
    "can be redefined for notification or special actions"

    device notNil ifTrue:[
        "On X11, be nice and set the PRIMARY selection.
         (#setPrimaryText:ownerView: is void in DeviceWorkstation)"
        device setPrimaryText: self selectionAsString ownerView: self.
    ].

    "Created: / 17-04-2012 / 20:59:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

st80SelectMode
    st80SelectMode notNil ifTrue:[^ st80SelectMode].
    ^ self class st80SelectMode

    "Created: / 03-07-2006 / 16:30:59 / cg"
!

st80SelectMode:aBoolean
    st80SelectMode := aBoolean
!

unselect
    "unselect - if there was a selection redraw that area"

    |startLine endLine startVisLine endVisLine|

    selectionStartLine notNil ifTrue:[
        startLine := selectionStartLine.
        endLine := selectionEndLine.

        self unselectWithoutRedraw.

        "/ if the selection is not visible, we are done

        startLine >= (firstLineShown + nLinesShown) ifTrue:[^ self].
        endLine < firstLineShown ifTrue:[^ self].

        startLine < firstLineShown ifTrue:[
            startVisLine := 1
        ] ifFalse:[
            startVisLine := self listLineToVisibleLine:startLine
        ].
        endLine >= (firstLineShown + nLinesShown) ifTrue:[
            endVisLine := nLinesShown
        ] ifFalse:[
            endVisLine := self listLineToVisibleLine:endLine
        ].

        "/ if its only part of a line, just redraw what has to be

        (startLine == endLine) ifTrue:[
            super redrawVisibleLine:startVisLine from:selectionStartCol to:selectionEndCol
        ] ifFalse:[
            self redrawFromVisibleLine:startVisLine to:endVisLine
        ].
    ].
    selectStyle := nil

    "Modified: 29.5.1996 / 14:54:11 / cg"
!

unselectWithoutRedraw
    "forget selection but do not redraw the selection area
     - can be done when the selected area is redrawn anyway or
     known to be invisible (however, redraw knows about that anyway)."

    selectionStartLine := selectionEndLine := nil.
    self selectionChanged.
!

validateNewSelection
     "make certain that the selection is valid.
      This is a dummy here, but subclasses (like single-line editFields)
      may redefine it to limit the selection to a single line, or whatever."

    ^ self

    "Modified: 29.4.1996 / 12:32:08 / cg"
!

withSelectionForeground:hilightFg background:hilightBg do:aBlock
    "evaluate aBlock while the selection is shown highlighted with colors passed as args."

    |oldFg oldBg|

    "
     change color of selection & hide cursor
    "
    oldFg := selectionFgColor.
    oldBg := selectionBgColor.
    selectionBgColor := hilightBg.
    selectionFgColor := hilightFg.

    expandingTop := true.       "/ hack to make the top of the selection visible
    self makeSelectionVisible.
    selectionStartLine notNil ifTrue:[
        selectionEndLine notNil ifTrue:[
            self redrawFromLine:selectionStartLine to:selectionEndLine.
        ].
    ].
    self flush.

    aBlock ensure:[
        "
         undo selection color change and show cursor again
        "
        selectionFgColor := oldFg.
        selectionBgColor := oldBg.
    ].
! !

!TextView methodsFor:'testing'!

isTextView
    "I am showing text"

    ^ true
! !

!TextView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


TextView initialize!
