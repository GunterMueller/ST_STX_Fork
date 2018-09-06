"
 COPYRIGHT (c) 2006 by eXept Software AG
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

CodeView subclass:#NewSystemBrowserCodeView
	instanceVariableNames:'browser parseTree selectedNode parsingProcess
		parsingProcessRunning highlightEmphasis seqNum'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!NewSystemBrowserCodeView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!NewSystemBrowserCodeView class methodsFor:'initialization'!

initialize
    "
        self initialize
    "
    "/ MUST be done in the keyboard.rc file
    "
    Smalltalk addStartBlock:
        [Display keyboardMap 
            bindValue:#ImplementorsOfIt to:#Cmdm;
            bindValue:#SendersOfIt to:#Cmdn;
            bindValue:#GoBack to:#CmdBackSpace]
    "

    "Created: / 25-12-2007 / 19:58:53 / janfrog"
    "Modified: / 27-02-2008 / 12:16:10 / janfrog"
    "Modified: / 15-04-2010 / 16:40:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-07-2011 / 16:21:38 / cg"
! !

!NewSystemBrowserCodeView class methodsFor:'menu specs'!

editMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::NewSystemBrowserCodeView andSelector:#editMenuSpec
     (Menu new fromLiteralArrayEncoding:(Tools::NewSystemBrowserCodeView editMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Implementors'
            itemValue: browseImplementorsOfIt
            translateLabel: true
            shortcutKey: ImplementorsOfIt
          )
         (MenuItem
            label: 'Senders'
            itemValue: browseSendersOfIt
            translateLabel: true
            shortcutKey: SendersOfIt
          )
         (MenuItem
            label: 'Refactor'
            translateLabel: true
            isVisible: false
            shortcutKey: Shift
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Accept'
            itemValue: accept
            translateLabel: true
            shortcutKey: Accept
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Cut'
            itemValue: cut
            translateLabel: true
            shortcutKey: Cut
          )
         (MenuItem
            label: 'Copy'
            itemValue: copySelection
            translateLabel: true
            shortcutKey: Copy
          )
         (MenuItem
            label: 'Paste'
            itemValue: pasteOrReplace
            translateLabel: true
            shortcutKey: Paste
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Undo'
            itemValue: undo
            translateLabel: true
            shortcutKey: Undo
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Do it'
            itemValue: doIt
            translateLabel: true
            shortcutKey: DoIt
          )
         (MenuItem
            label: 'Print it'
            itemValue: printIt
            translateLabel: true
            shortcutKey: PrintIt
          )
         (MenuItem
            label: 'Inspect it'
            itemValue: inspectIt
            translateLabel: true
            shortcutKey: InspectIt
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Special'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Inspect RB Parse Tree'
                  itemValue: inspectParseTree
                  translateLabel: true
                )
               (MenuItem
                  label: 'Inspect selected selector'
                  itemValue: inspectSelectedSelector
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'More'
            nameKey: More
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Modified: / 18-10-2008 / 18:50:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!NewSystemBrowserCodeView methodsFor:'accessing'!

browser
    ^ browser ? menuHolder

    "Created: / 25-12-2007 / 10:20:01 / janfrog"
    "Modified: / 26-12-2007 / 12:22:56 / janfrog"
!

browser:something
    browser := something.

    "Created: / 25-12-2007 / 10:20:01 / janfrog"
!

findNode

    ^selectedNode 
        ifNil:[self findNodeForInterval: self selectedInterval]
        ifNotNil:[selectedNode]

    "Created: / 18-02-2008 / 22:52:24 / janfrog"
    "Modified: / 19-02-2008 / 09:35:11 / janfrog"
!

findNodeForInterval:anInterval
    "
        An empty interval check based on Claus' suggestion
        (email Fri, 10 Oct 2008 16:10:25 +0200)
    "
    anInterval isEmpty ifTrue:[^nil].

    ^self findNodeIn: self parseTree forInterval: anInterval

    "Created: / 19-02-2008 / 09:44:50 / janfrog"
    "Modified: / 18-10-2008 / 16:47:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 01-09-2009 / 22:45:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

findNodeIn:tree forInterval:interval 
    ^ DoWhatIMeanSupport findNodeIn:tree forInterval:interval
"/    |node wouldReturn|
"/
"/    node := nil.
"/    tree = #error ifTrue:[^nil].
"/    tree nodesDo:[:each | 
"/        (each intersectsInterval:interval) ifTrue:[
"/            (node isNil or:[node == each parent]) ifTrue:[
"/                node := each
"/            ] ifFalse:[
"/                (node parent notNil 
"/                    and:[node parent isCascade and:[each parent isCascade]]) ifFalse:[^ nil]
"/            ]
"/        ] ifFalse:[
"/            node notNil ifTrue:[
"/                "/ already found one - beyond that one; leave
"/                wouldReturn notNil ifTrue:[wouldReturn := node].
"/            ]
"/        ].
"/    ].
"/(wouldReturn notNil and:[wouldReturn ~~ node]) ifTrue:[self halt].
"/    ^ node

    "Created: / 19-02-2008 / 09:40:24 / janfrog"
    "Modified: / 21-02-2008 / 09:35:31 / janfrog"
!

selectedClass

    ^self browser theSingleSelectedClass

    "Created: / 21-02-2008 / 09:26:55 / janfrog"
!

selectedNode
    ^ self findNode

    "Created: / 21-02-2008 / 09:17:29 / janfrog"
!

selectedSelector
    |selectedText|

    ^ (selectedText := self selectionAsString) isEmptyOrNil 
        ifFalse:[ (SystemBrowser extractSelectorFrom:selectedText) asSymbol ]
        ifTrue:[
            selectedNode ifNil:[ self highlightNodeAtCursor ].
            (selectedNode notNil and:[ selectedNode isMessage ]) ifTrue:[
                selectedNode selector
            ] ifFalse:[ nil ]
        ]

    "Created: / 26-12-2007 / 11:12:26 / janfrog"
    "Modified: / 19-02-2008 / 09:16:11 / janfrog"
    "Modified: / 04-08-2011 / 19:05:43 / cg"
! !

!NewSystemBrowserCodeView methodsFor:'accessing-contents'!

list: anObject

    super list: anObject.
    self updateParseTree.

    "Created: / 25-12-2007 / 10:05:17 / janfrog"
! !

!NewSystemBrowserCodeView methodsFor:'change & update'!

updateParseTree

    self startParsingProcess
    "/Transcript showCR:'Updating parse tree'

    "Created: / 25-12-2007 / 10:05:49 / janfrog"
    "Modified: / 25-12-2007 / 21:29:28 / janfrog"
! !

!NewSystemBrowserCodeView methodsFor:'event handling'!

buttonMotion:button x:x y:y 
    (button == 0 and:[ self sensor ctrlDown ]) ifFalse:[
        ^ super buttonMotion:button x:x y:y
    ].    
    self
        highlightNodeAtX:x y:y;
        redraw.

    "Created: / 25-12-2007 / 21:53:50 / janfrog"
    "Modified: / 19-02-2008 / 09:15:09 / janfrog"
!

buttonPress: button x: x y: y 
    | node |

    (self sensor ctrlDown and: [ (node := self selectedNode) notNil ]) 
        ifTrue: 
            [ button = 1 
                ifTrue: [ ^ self openMenu: (node leftClickMenuInCodeView: self) ].
            button = #paste 
                ifTrue: [ ^ self openMenu: (node middleClickMenuInCodeView: self) ].
            button = 2 
                ifTrue: [ ^ self openMenu: (node rightClickMenuInCodeView: self) ] ].
    super 
        buttonPress: button
        x: x
        y: y

    "Created: / 26-12-2007 / 11:39:50 / janfrog"
    "Modified: / 21-02-2008 / 09:17:29 / janfrog"
!

handleNonCommandKey:keyArg

    super handleNonCommandKey: keyArg.
    self startParsingProcess.

    "Created: / 18-02-2008 / 17:18:22 / janfrog"
!

keyPress:key x:x y:y 
    <resource: #keyboard (#Control_L 
                          #Tab #Return #BackSpace #Delete
                          #GoBack)>

    (x notNil and:[ y notNil ]) ifTrue:[
        key = #'Control_L' ifTrue:[
            self
                highlightNodeAtX:x y:y;
                redraw
        ].
         "key = #Alt_L ifTrue: [self highlightParseTreeNodeAtX: x y: y; redraw]"
    ].

    (#( #Tab #Return #BackSpace #Delete) includes:key) ifTrue:[
        self startParsingProcess
    ].

    key == #GoBack ifTrue:[self goBack].
    
    ^ super 
        keyPress:key
        x:x
        y:y

    "Created: / 25-12-2007 / 23:49:38 / janfrog"
    "Modified: / 27-02-2008 / 12:18:56 / janfrog"
    "Modified: / 12-03-2009 / 16:35:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

keyRelease: key x: x y: y 
"/    textView isQuickMenuModifierReleased ifTrue:[
"/        selectedNode := nil. 
"/        self highlightClear; redraw     
"/    ].
        
    ^ super 
        keyRelease: key
        x: x
        y: y

    "Created: / 25-12-2007 / 23:15:15 / janfrog"
    "Modified: / 19-02-2008 / 09:16:11 / janfrog"
! !

!NewSystemBrowserCodeView methodsFor:'menu'!

browseClassesMenu: classes 
    | menu|

    menu := Menu new.
    classes do:
        [:cls|
        menu addItem:(MenuItem 
                        label: ('Browse ' , cls fullName asText allBold)
                        itemValue:[self browseClass: cls])].

    ^ menu

    "Modified: / 19-10-2008 / 08:16:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 01-09-2009 / 09:41:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editMenu

    | editMenu superEditMenu moreMenu moreMenuItem |
    editMenu := self class editMenuSpec decodeAsLiteralArray.
    superEditMenu := super editMenu.
    moreMenu := superEditMenu subMenuAt: superEditMenu numberOfItems.
    moreMenuItem := editMenu menuItemLabeled: 'More'.
    moreMenuItem submenu: moreMenu asMenu.
    editMenu findGuiResourcesIn: self.
    ^editMenu

    "Created: / 25-12-2007 / 10:10:01 / janfrog"
    "Modified: / 25-12-2007 / 19:50:53 / janfrog"
    "Modified: / 18-10-2008 / 20:31:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

messageNodeContextMenu:messageNode 
    |menu|

    menu := Menu new.
    menu
        addItem:((MenuItem new)
                    label:'Implementors';
                    shortcutKey:#ImplementorsOfIt;
                    submenuChannel:(Promise 
                                value:[ self messageNodeImplementorsMenu:messageNode ]));
        addItem:((MenuItem new)
                    label:'Senders';
                    shortcutKey:#SendersOfIt;
                    submenuChannel:(Promise value:[ self messageNodeSendersMenu:messageNode ])).
    ^ menu

    "Created: / 18-02-2008 / 21:05:36 / janfrog"
!

messageNodeImplementorsMenu:messageNode 
    |implementors selector menu|

    menu := Menu new.
    implementors := self implementorsOf:(selector := messageNode selector).
    implementors isEmptyOrNil ifTrue:[
        menu addItem:(MenuItem label:'No implementors found') disable
    ] ifFalse:[
        menu addItem:(MenuItem 
                    label:(selector storeString , (' (all implementors) ') asText allItalic)
                    itemValue:[
                        self browseMethods:implementors
                            label:'Implementors of ' , selector storeString
                    ]).
        menu addSeparator.
        implementors do:[:mth | 
            menu 
                addItem:(MenuItem 
                            label:(selector storeString 
                                    , (' in ' , mth containingClass name asText allBold))
                            itemValue:[ self browseMethod:mth label: 'Implementor of ' , selector storeString  ])
        ]
    ].
    ^ menu

    "Created: / 18-02-2008 / 21:05:47 / janfrog"
    "Modified: / 19-10-2008 / 08:16:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-08-2011 / 19:05:37 / cg"
!

messageNodeSendersMenu:messageNode 
    |implementors selector menu|

    menu := Menu new.
    implementors := self sendersOf:(selector := messageNode selector).
    implementors isEmptyOrNil ifTrue:[
        menu addItem:(MenuItem label:'No senders found') disable
    ] ifFalse:[
        menu addItem:(MenuItem 
                    label:(selector storeString , (' (all senders)') asText allItalic)
                    itemValue:[
                        self browseMethods:implementors
                            label:'Senders of ' , selector storeString
                    ]).
        menu addSeparator.
        implementors do:[:mth | 
            menu 
                addItem:(MenuItem 
                            label:(mth selector storeString 
                                   , (' in ' , mth containingClass name asText allBold))
                            itemValue:[ self browseMethod:mth label: 'Sender of ' , selector storeString ])
        ]
    ].
    ^ menu

    "Created: / 18-02-2008 / 21:05:56 / janfrog"
    "Modified: / 19-10-2008 / 08:17:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-08-2011 / 19:05:40 / cg"
!

openMenu: aMenuOrNil

    aMenuOrNil ifNotNil:
        [self highlightClear; redraw.
        aMenuOrNil startUp].

    "Created: / 18-02-2008 / 19:03:08 / janfrog"
!

variableNodeMenuContext:variableNode

    | menu |
    menu := Menu new.
    menu 
        addItem:
            (MenuItem 
                label: 'Rename Local Variable'
                itemValue:[self refactorMenuRenameLocalVariable]
                enabled:(self isLocalVariableNode: variableNode));
        addItem:
            (MenuItem 
                label: 'Rename Instance Variable'
                itemValue:[self refactorMenuRenameInstanceVariable]
                enabled:(self isInstanceVariableNode: variableNode)).

    ^menu

    "Created: / 18-02-2008 / 21:10:46 / janfrog"
    "Modified: / 21-02-2008 / 09:40:09 / janfrog"
    "Modified: / 09-09-2012 / 13:24:19 / cg"
! !

!NewSystemBrowserCodeView methodsFor:'menu - actions'!

accept

    super accept.
    self startParsingProcess

    "Created: / 26-12-2007 / 12:33:19 / janfrog"
!

browseClass: class

    self browser ifNil: [^NewSystemBrowser browseClass:class].
    (UserPreferences current alwaysOpenNewTabWhenCtrlClick or:[self browser navigationState modified])  
        ifTrue:
            [self browser 
                spawnClassBrowserFor:(Array with: class)
                in:#newBuffer]
        ifFalse:
            [self browser 
                switchToClass: class].

    "Modified: / 19-02-2008 / 10:15:17 / janfrog"
    "Created: / 01-09-2009 / 08:52:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

browseImplementorsOfIt

    | selector implementors |
    selector := self selectedSelector.
    implementors := self implementorsOf: selector.
    self browseMethods: implementors label: 'Implementors of: ', selector storeString

    "Created: / 26-12-2007 / 11:02:41 / janfrog"
!

browseMethod: method label: label

    self browser ifNil: [^NewSystemBrowser openInMethod:method].
    (UserPreferences current alwaysOpenNewTabWhenCtrlClick or:[self browser navigationState modified])  
        ifTrue:
            [self browser 
                spawnMethodBrowserFor:(Array with: method)
                in:#newBuffer 
                label:label]
        ifFalse:
            [self browser 
                switchToClass: method containingClass 
                selector: method selector].

    "Modified: / 19-02-2008 / 10:15:17 / janfrog"
    "Created: / 19-10-2008 / 08:16:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

browseMethods: methods label: label

    methods size = 1 ifTrue:
        [^self browseMethod: methods anyOne label: label].

    self browser 
        ifNil: [NewSystemBrowser browseMethods: methods title: label]
        ifNotNil:[self browser spawnMethodBrowserFor:methods in:#newBuffer label:label]

    "Created: / 26-12-2007 / 11:32:04 / janfrog"
    "Modified: / 19-10-2008 / 08:17:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

browseSendersOfIt

    | selector implementors |
    selector := self selectedSelector.
    implementors := self sendersOf: selector.
    self browseMethods: implementors label: 'Senders of: ', selector storeString

    "Created: / 26-12-2007 / 11:35:43 / janfrog"
!

goBack

    (self browser respondsTo: #goBack)
        ifTrue:[self browser goBack]

    "Created: / 27-02-2008 / 12:18:02 / janfrog"
!

inspectParseTree
    ^ self parseTree inspect

    "Created: / 25-12-2007 / 21:36:09 / janfrog"
    "Modified: / 19-02-2008 / 09:20:03 / janfrog"
!

inspectSelectedSelector

    ^self selectedSelector inspect

    "Created: / 26-12-2007 / 11:16:48 / janfrog"
!

refactorMenuRenameInstanceVariable

    self topView application codeMenuRenameTemporary

    "Created: / 21-02-2008 / 09:15:08 / janfrog"
!

refactorMenuRenameLocalVariable

    self browser codeMenuRenameTemporary

    "Created: / 18-02-2008 / 21:21:26 / janfrog"
    "Modified: / 19-02-2008 / 09:59:11 / janfrog"
! !

!NewSystemBrowserCodeView methodsFor:'menu - double dispatch'!

blueButtonMenuForMessageNode:messageNode 
    ^ self messageNodeContextMenu:messageNode

    "Created: / 18-02-2008 / 19:12:56 / janfrog"
    "Modified: / 18-02-2008 / 21:05:36 / janfrog"
!

blueButtonMenuForVariableNode: messageNode

    ^self variableNodeMenuContext:messageNode

    "Created: / 18-02-2008 / 21:04:32 / janfrog"
!

leftClickMenuForMessageNode: messageNode 
    ^ self messageNodeImplementorsMenu: messageNode

    "Modified: / 18-02-2008 / 21:05:47 / janfrog"
!

leftClickMenuForVariableNode: varNode
    | environment classes |

    self browser ifNil:[^nil].
    environment := self browser theSingleSelectedMethod mclass environment.
    classes := OrderedCollection new.
    [ environment notNil ] whileTrue:[
        | cls |

        cls := environment at: varNode name asSymbol.
        cls ifNotNil:[classes add: cls].
        environment :=
            (environment == Smalltalk) 
                ifTrue:[environment := nil]
                ifFalse:[environment environment]
    ].
    ^classes isEmpty 
        ifTrue:[self browseClassesMenu: classes ]
        ifFalse:[self variableNodeMenuContext: varNode]

    "Modified: / 18-02-2008 / 21:05:47 / janfrog"
    "Created: / 01-09-2009 / 08:41:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2009 / 09:46:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-07-2011 / 16:04:47 / cg"
!

middleClickMenuForMessageNode: messageNode 
    ^ self messageNodeSendersMenu: messageNode

    "Created: / 18-02-2008 / 19:08:50 / janfrog"
    "Modified: / 18-02-2008 / 21:05:56 / janfrog"
!

redButtonMenuForMessageNode:messageNode 
    ^ self messageNodeImplementorsMenu:messageNode

    "Modified: / 18-02-2008 / 21:05:47 / janfrog"
!

rightClickMenuForMessageNode: messageNode 
    ^ self messageNodeContextMenu: messageNode

    "Created: / 18-02-2008 / 19:12:56 / janfrog"
    "Modified: / 18-02-2008 / 21:05:36 / janfrog"
!

rightClickMenuForVariableNode: variableNode 
    ^ self variableNodeMenuContext: variableNode

    "Created: / 18-02-2008 / 21:04:32 / janfrog"
!

yellowButtonMenuForMessageNode:messageNode 
    ^ self messageNodeSendersMenu:messageNode

    "Created: / 18-02-2008 / 19:08:50 / janfrog"
    "Modified: / 18-02-2008 / 21:05:56 / janfrog"
! !

!NewSystemBrowserCodeView methodsFor:'private'!

implementorsOf: selector

    selector ifNil:[^#()].
    ^SystemBrowser
        findImplementorsOf: selector
        in: Smalltalk allClasses
        ignoreCase: false

    "Created: / 26-12-2007 / 11:37:11 / janfrog"
!

sendersOf: selector

    ^SystemBrowser
        findSendersOf: selector
        in: Smalltalk allClasses
        ignoreCase: false

    "Created: / 26-12-2007 / 11:37:22 / janfrog"
! !

!NewSystemBrowserCodeView methodsFor:'private - highlighting'!

highlightClear
    self list ifNil:[ ^ self ].
    self list do:[:line | 
        line isText ifTrue:[
            line emphasisAllRemove:self selectorEmphasis
        ]
    ]

    "Created: / 25-12-2007 / 23:26:27 / janfrog"
    "Modified: / 26-12-2007 / 12:28:05 / janfrog"
!

highlightFrom: start to: end 
    "Remove underlined emphasis"

    |startLine startCol endLine endCol|

    startLine := self lineOfCharacterPosition:start.
    startCol := start - (self characterPositionOfLine:startLine col:1) + 1.
    endLine := self lineOfCharacterPosition:end.
    endCol := end - (self characterPositionOfLine:endLine col:1) + 1.
    self highlightFromLine: startLine col: startCol toLine: endLine col: endCol

    "Created: / 25-12-2007 / 22:56:28 / janfrog"
!

highlightLine:lineNo fromLine:startLine col:endLine toLine:startCol col:endCol emphasis: em 
    |line start end|

    (lineNo between:startLine and:endLine) ifFalse:[
        ^ self
    ].
    line := self listAt:lineNo.
    start := lineNo = startLine ifTrue:[
                startCol
            ] ifFalse:[
                line indexOfFirstNonBlankCharacter
            ].
    end := lineNo = endLine ifTrue:[
                endCol
            ] ifFalse:[ line size ].
    line 
        emphasisFrom:start
        to:end
        add: em

    "Created: / 25-06-2010 / 13:59:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

highlightNode:node 
    selectedNode == node ifTrue:[^ self].
    selectedNode := node.
    selectedNode ifNil:[ ^ self highlightClear ].
    selectedNode highlightInCodeView:self.

    "Created: / 19-02-2008 / 09:14:38 / janfrog"
!

highlightNodeAtCursor
    self highlightNodeAtLine:self cursorLine col:self cursorCol

    "Created: / 19-02-2008 / 09:14:46 / janfrog"
!

highlightNodeAtLine:line col:col 
    |characterPosition node|

    (self parseTree isNil or:[ self parseTree = #error ]) ifTrue:[
        ^ self
    ].
    characterPosition := self characterPositionOfLine:line col:col.
    node := self findNodeForInterval: (characterPosition to:characterPosition).
    self highlightNode:node

    "Created: / 19-02-2008 / 09:14:58 / janfrog"
!

highlightNodeAtX:x y:y 
    |visibleLine line col|

    (self parseTree isNil or:[ self parseTree = #error ]) ifTrue:[
        ^ self
    ].
    visibleLine := self visibleLineOfY:y.
    col := self colOfX:x inVisibleLine:visibleLine.
    line := self visibleLineToAbsoluteLine:visibleLine.
    self highlightNodeAtLine:line col:col

    "Created: / 19-02-2008 / 09:15:09 / janfrog"
!

highlightWithoutClearFrom: start to: end 
    "Remove underlined emphasis"

    |startLine startCol endLine endCol|

    startLine := self lineOfCharacterPosition:start.
    startCol := start - (self characterPositionOfLine:startLine col:1) + 1.
    endLine := self lineOfCharacterPosition:end.
    endCol := end - (self characterPositionOfLine:endLine col:1) + 1.
    self highlightWithoutClearFromLine: startLine col: startCol toLine: endLine col: endCol

    "Created: / 25-12-2007 / 23:27:14 / janfrog"
!

highlightWithoutClearFromLine: startLine col: startCol toLine: endLine col: endCol

    self list keysAndValuesDo:
        [:lineNo :line|
        |start end|
        line isText ifTrue:
            [self highlightLine: lineNo fromLine: startLine col: endLine toLine: startCol col: endCol]].

    "Created: / 25-12-2007 / 23:35:07 / janfrog"
!

highlightWithoutClearFromLine: startLine col: startCol toLine: endLine col: endCol emphasis: em

    self list keysAndValuesDo:
        [:lineNo :line|
        |start end|
        line isText ifTrue:
            [self highlightLine: lineNo fromLine: startLine col: endLine toLine: startCol col: endCol emphasis: em]].

    "Created: / 25-06-2010 / 13:58:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectorEmphasis
    highlightEmphasis isNil ifTrue:[
        highlightEmphasis := #(underline bold)
    ].
    ^ highlightEmphasis.

    "Created: / 25-12-2007 / 22:57:23 / janfrog"
    "Modified: / 01-09-2009 / 22:29:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NewSystemBrowserCodeView methodsFor:'private - highlighting - nodes'!

highlightLiteralNode: node

    node value isSymbol ifTrue:
        [self highlightFrom: node start to: node stop]

    "Created: / 26-12-2007 / 10:19:08 / janfrog"
!

highlightMessageNode: node

    self highlightClear.
    node selectorParts do:
        [:part|self highlightWithoutClearFrom: part start to: part stop]

    "Created: / 25-12-2007 / 23:41:36 / janfrog"
!

highlightVariableNode: node 
    (#('self' 'super' 'here' 'thisContext') includes:node name) ifTrue:[^self].
    ^ self highlightFrom: node start to: node stop

    "Created: / 25-12-2007 / 23:45:42 / janfrog"
    "Modified: / 18-02-2008 / 20:51:51 / janfrog"
! !

!NewSystemBrowserCodeView methodsFor:'private - parsing'!

parseTree

    ^ parseTree

    "Created: / 19-02-2008 / 09:20:03 / janfrog"
    "Modified: / 19-10-2008 / 07:36:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

parseTree:something
    parseTree := something.

    "Created: / 19-10-2008 / 07:39:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

parseTree:something sequenceNumber: givenSeqNum

    givenSeqNum < seqNum ifFalse:
        [parseTree := something].

    "Created: / 12-03-2009 / 16:29:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

startParsingProcess
    |prio contents|

    seqNum := ((seqNum ? 0) + 1).
    parsingProcess 
        ifNotNil:[
            parsingProcessRunning ~~ true ifTrue:[
                ^ self
            ].
            self stopParsingProcess
        ].
    prio := Processor userBackgroundPriority - 1.
    self shown ifFalse:[
        prio := prio - 1 max:1
    ].
    contents := self contents.
    parsingProcess := [
                [
                    | tree |
                    tree := ((contents isEmptyOrNil) 
                                ifTrue:[ nil ]
                                ifFalse:[ RBParser parseMethod:contents onError:[:err :pos | #error ] ]).
                    self sensor 
                            pushUserEvent:#parseTree:sequenceNumber:
                            for: self
                            withArguments: 
                                (Array with: tree with: seqNum)
                ] ensure:[
                    parsingProcessRunning := false.
                    parsingProcess := nil.
                ]
            ] forkAt:prio

    "Modified: / 19-02-2008 / 09:22:57 / janfrog"
    "Created: / 21-08-2009 / 15:40:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-08-2009 / 11:51:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2011 / 19:05:45 / cg"
!

stopParsingProcess
    |p|

    (p := parsingProcess) notNil ifTrue:[
        parsingProcess := nil.
        p terminate.
        "/ raise its prio to make it terminate quickly
        p priority:(Processor userSchedulingPriority + 1)
    ]

    "Created: / 25-12-2007 / 21:16:03 / janfrog"
! !

!NewSystemBrowserCodeView methodsFor:'private - testing'!

isInstanceVariableNode: node


    node isVariable ifFalse:[^false].
    ^(self selectedClass allInstVarNames includes:(node name))

    "Created: / 21-02-2008 / 09:39:10 / janfrog"
!

isLocalVariableNode: node


    (self parseTree arguments includes: node) ifTrue:[^true].
    (self parseTree body temporaries includes: node) ifTrue:[^true].
    ^false

    "Created: / 21-02-2008 / 09:32:33 / janfrog"
! !

!NewSystemBrowserCodeView class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


NewSystemBrowserCodeView initialize!
