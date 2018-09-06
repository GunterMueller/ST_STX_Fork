"
 COPYRIGHT (c) 2008 by eXept Software AG
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

StringSearchTool subclass:#StringSearchToolForTextView
	instanceVariableNames:'textView matchHolder'
	classVariableNames:'LastMatch'
	poolDictionaries:''
	category:'Interface-Tools'
!

!StringSearchToolForTextView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!StringSearchToolForTextView class methodsFor:'accessing'!

lastMatch

    ^ LastMatch ? false
!

lastMatch: aBoolean

    LastMatch := aBoolean
! !

!StringSearchToolForTextView class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::StringSearchToolForTextView andSelector:#windowSpec
     Tools::StringSearchToolForTextView new openInterface:#windowSpec
     Tools::StringSearchToolForTextView open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Tools::StringSearchTool'
          name: 'Tools::StringSearchTool'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 883 27)
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: 'SearchBox'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              level: -1
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'closeSearchBarIcon'
                    name: 'hideSearchBarButton'
                    layout: (LayoutFrame 1 0 2 0 22 0 23 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: hideSearchBar
                  )
                 (LabelSpec
                    label: 'Search:'
                    name: 'SearchLabel'
                    layout: (LayoutFrame 23 0 1 0 71 0 23 0)
                    translateLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'SearchEntryField'
                    layout: (LayoutFrame 72 0 1 0 253 0 23 0)
                    model: searchTextHolder
                    immediateAccept: true
                    acceptOnReturn: true
                    acceptOnTab: true
                    acceptOnLostFocus: true
                    modifiedChannel: searchTextModifiedHolder
                    acceptOnPointerLeave: false
                    postBuildCallback: postBuildSearchTextView:
                  )
                 (ActionButtonSpec
                    label: 'searchNextIcon'
                    name: 'SearchNextButton'
                    layout: (LayoutFrame 258 0 2 0 279 0 23 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: searchNextTextButtonPressed
                  )
                 (ActionButtonSpec
                    label: 'searchPreviousIcon'
                    name: 'searchPreviousButton'
                    layout: (LayoutFrame 286 0 2 0 307 0 23 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: searchPreviousTextButtonPressed
                  )
                 (CheckBoxSpec
                    label: 'Case'
                    name: 'DoNotIgnoreCaseCheckBox'
                    layout: (LayoutFrame 312 0 1 0 396 0 23 0)
                    model: matchCaseHolder
                    translateLabel: true
                  )
                 (CheckBoxSpec
                    label: 'Match'
                    name: 'MatchCheckBox'
                    layout: (LayoutFrame 396 0 1 0 480 0 23 0)
                    model: matchHolder
                    translateLabel: true
                  )
                 (CheckBoxSpec
                    label: 'Restart'
                    name: 'RestartCheckBox'
                    layout: (LayoutFrame 480 0 1 0 564 0 23 0)
                    model: restartHolder
                    translateLabel: true
                  )
                 (LabelSpec
                    label: 'SearchBarImageInfoLabel'
                    name: 'SearchBarImageInfoLabel'
                    layout: (LayoutFrame 564 0 1 0 588 0 23 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    labelChannel: searchBarImageInfoLabelHolder
                  )
                 (LabelSpec
                    label: 'SearchBarInfoLabel'
                    name: 'SearchBarInfoLabel'
                    layout: (LayoutFrame 595 0 1 0 877 0 23 0)
                    translateLabel: true
                    labelChannel: searchBarInfoLabelHolder
                    adjust: left
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpec_old
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::StringSearchToolForTextView andSelector:#windowSpec_old
     Tools::StringSearchToolForTextView new openInterface:#windowSpec_old
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: #'windowSpec_old'
        window: 
       (WindowSpec
          label: 'Tools::StringSearchTool'
          name: 'Tools::StringSearchTool'
          min: (Point 10 10)
          max: (Point 1024 768)
          bounds: (Rectangle 0 0 883 27)
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: 'SearchBox'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              level: -1
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'closeSearchBarIcon'
                    name: 'hideSearchBarButton'
                    layout: (LayoutFrame 1 0 2 0 22 0 23 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: hideSearchBar
                  )
                 (LabelSpec
                    label: 'Search:'
                    name: 'SearchLabel'
                    layout: (LayoutFrame 23 0 1 0 71 0 23 0)
                    translateLabel: true
                    adjust: right
                  )
                 (InputFieldSpec
                    name: 'SearchEntryField'
                    layout: (LayoutFrame 72 0 1 0 253 0 23 0)
                    model: searchTextHolder
                    immediateAccept: true
                    acceptOnReturn: true
                    acceptOnTab: true
                    acceptOnLostFocus: true
                    modifiedChannel: searchTextModifiedHolder
                    acceptOnPointerLeave: false
                    postBuildCallback: postBuildSearchTextView:
                  )
                 (ActionButtonSpec
                    label: 'searchNextIcon'
                    name: 'SearchNextButton'
                    layout: (LayoutFrame 258 0 2 0 279 0 23 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: searchNextTextButtonPressed
                  )
                 (ActionButtonSpec
                    label: 'searchPreviousIcon'
                    name: 'searchPreviousButton'
                    layout: (LayoutFrame 286 0 2 0 307 0 23 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: searchPreviousTextButtonPressed
                  )
                 (CheckBoxSpec
                    label: 'Case'
                    name: 'CaseCheckBox'
                    layout: (LayoutFrame 312 0 1 0 424 0 23 0)
                    model: matchCaseHolder
                    translateLabel: true
                  )
                 (CheckBoxSpec
                    label: 'Match'
                    name: 'MatchCheckBox'
                    layout: (LayoutFrame 424 0 1 0 508 0 23 0)
                    model: matchHolder
                    translateLabel: true
                  )
                 (CheckBoxSpec
                    label: 'Restart'
                    name: 'RestartCheckBox'
                    layout: (LayoutFrame 509 0 1 0 593 0 23 0)
                    model: restartHolder
                    translateLabel: true
                  )
                 (LabelSpec
                    label: 'SearchBarImageInfoLabel'
                    name: 'SearchBarImageInfoLabel'
                    layout: (LayoutFrame 598 0 1 0 622 0 23 0)
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    labelChannel: searchBarImageInfoLabelHolder
                  )
                 (LabelSpec
                    label: 'SearchBarInfoLabel'
                    name: 'SearchBarInfoLabel'
                    layout: (LayoutFrame 633 0 1 0 882 0 23 0)
                    translateLabel: true
                    labelChannel: searchBarInfoLabelHolder
                    adjust: left
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!StringSearchToolForTextView methodsFor:'accessing'!

textView
    ^ textView
!

textView:something
    textView := something.
! !

!StringSearchToolForTextView methodsFor:'aspects'!

matchCheckboxVisible
    ^ true
!

matchHolder

    matchHolder isNil ifTrue:[
        matchHolder := self class lastMatch asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       matchHolder addDependent:self.
        matchHolder onChangeSend:#matchHolderChanged to:self.

    ].
    ^ matchHolder.

    "Created: / 16-06-2007 / 06:45:04 / Administrador"
    "Modified: / 16-06-2007 / 19:32:15 / Administrador"
! !

!StringSearchToolForTextView methodsFor:'change & update'!

matchHolderChanged

    self searchNextTextIncludingCurrentSelection: true.
    self setFocusToSearchTextView.
    self class lastMatch: self matchHolder value.
!

searchTextModifiedHolderChanged

    |searchPattern|

    super searchTextModifiedHolderChanged.

    searchPattern := self searchText.
"/    Transcript showCR: searchPattern.
    textView setSearchPattern: searchPattern.
! !

!StringSearchToolForTextView methodsFor:'initialization & release'!

postBuildSearchTextView: anEditFieldView

    super postBuildSearchTextView: anEditFieldView.
    anEditFieldView crAction: self crAction.
! !

!StringSearchToolForTextView methodsFor:'misc'!

trimMatchPattern: aString

    ^ aString trimForWhich: [:ch | ch == $*].

    "
    '***foo***' trimForWhich: [:ch | ch = $*].  
    'foo***' trimForWhich: [:ch | ch = $*].    
    '***foo' trimForWhich: [:ch | ch = $*].      
    '***f***o***o***' trimForWhich: [:ch | ch = $*].     
    'foo' trimForWhich: [:ch | ch = $*].
    "
! !

!StringSearchToolForTextView methodsFor:'public'!

crAction

    ^ [self returnFocusToTextView]
!

escapePressed

    self returnFocusToTextView. 
    super escapePressed.
!

returnFocusToTextView

    textView takeFocus
!

searchPreviousTextReachBeginning
    |message searchText match |

    searchText := self searchText.
    match := self matchHolder value.

    match ifTrue: [
        searchText := self trimMatchPattern: searchText.
        (searchText includes: $*) ifTrue: [
            message := (resources string: 'Match pattern not available for backward search').
            self searchTextNotFound: message.
            Smalltalk beep.
            ^ self
        ].    
    ].

    super searchPreviousTextReachBeginning
! !

!StringSearchToolForTextView methodsFor:'searching'!

hideSearchBar

    masterApplication isNil ifTrue:[^ self].
    masterApplication hideSearchBar.
    self returnFocusToTextView.
!

searchNextTextFromBeginning
    |searchText ignoreCase match absentBlock|

    searchText := self searchText.
    searchText isEmptyOrNil ifTrue:[^self].
    self textView isNil ifTrue:[^ self].
    ignoreCase := self ignoreCase.
    match := self matchHolder value.
    absentBlock := [self searchTextNotFound.].
    self textView 
        searchFwd:searchText 
        ignoreCase:ignoreCase 
        match: match
        startingAtLine:1 
        col:0
        ifAbsent:absentBlock
!

searchNextTextIncludingCurrentSelection: includeCurrentSelection
    |searchText ignoreCase  match absentBlock startCol startLine |

    self searchTextStarted.
    searchText := self searchText.
    searchText isEmptyOrNil ifTrue:[^self].
    self textView isNil ifTrue:[^ self].
    ignoreCase := self ignoreCase.
    match := self matchHolder value.
    absentBlock := [self searchNextTextReachEnd].

    (self textView hasSelection and:[includeCurrentSelection]) 
        ifTrue:[
            startCol := ((self textView selectionStartCol ? 1) - 2) max: 0.
            startLine := (self textView selectionStartLine ? 1).
            self textView searchFwd:searchText ignoreCase:ignoreCase match: match startingAtLine:startLine col:startCol ifAbsent:absentBlock.
        ] ifFalse:[   
            self textView startPositionForSearchForward = (0 @ 1) ifTrue: [
                absentBlock := [self searchTextNotFound].
            ].
            self textView searchFwd:searchText ignoreCase:ignoreCase match: match ifAbsent:absentBlock
    ].
!

searchPreviousText

    |searchText ignoreCase match absentBlock|

    self searchTextStarted.
    searchText := self searchText.
    searchText isEmptyOrNil ifTrue:[^self].
    ignoreCase := self ignoreCase.
    self textView isNil ifTrue:[^ self].
    match := self matchHolder value.
    match ifTrue: [
        searchText := self trimMatchPattern: searchText.
    ].
    absentBlock := [self searchPreviousTextReachBeginning].
    self textView searchBwd:searchText ignoreCase:ignoreCase ifAbsent:absentBlock.
!

searchPreviousTextFromEnd

    |searchText ignoreCase absentBlock startLine startCol|

    searchText := self searchText.
    searchText isEmptyOrNil ifTrue:[^self].
    ignoreCase := self ignoreCase.
    self textView isNil ifTrue:[^ self].
    absentBlock := [self searchTextNotFound.].
    startLine := self textView numberOfLines + 1.
    startCol := 1.
    self textView 
        searchBwd:searchText 
        ignoreCase:ignoreCase
        startingAtLine:startLine 
        col:startCol 
        ifAbsent:absentBlock
! !

!StringSearchToolForTextView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__StringSearchToolForTextView.st,v 1.17 2015-02-13 21:58:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__StringSearchToolForTextView.st,v 1.17 2015-02-13 21:58:38 cg Exp $'
! !

