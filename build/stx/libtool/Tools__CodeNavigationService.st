"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

CodeViewService subclass:#CodeNavigationService
	instanceVariableNames:'lastHighlightedElement selectorEmphasis variableEmphasis
		currentEmphasis currentEmphasisForAssign linesToRedraw menuShown
		assignmentEmphasis'
	classVariableNames:'DefaultVariableEmphasis DefaultSelectorEmphasis
		DefaultAssignmentEmphasis'
	poolDictionaries:''
	category:'Interface-CodeView'
!

!CodeNavigationService class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
! !


!CodeNavigationService class methodsFor:'accessing'!

label
    "Answers a short label - for UI"

    ^'Semi-modal Code Navigation'

    "Created: / 07-03-2010 / 14:00:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

requiredServices

    ^#(#'Tools::CodeHighlightingService')

    "Created: / 27-07-2011 / 11:40:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService class methodsFor:'accessing - defaults'!

defaultAssignmentEmphasis
    "must only define a background - otherwise, syntax highlight fg is lost"

    DefaultAssignmentEmphasis isNil ifTrue:[
        ^ Array with:(#backgroundColor -> (UserPreferences current assignmentBackgroundColorForNavigationService))
    ].
    ^ DefaultAssignmentEmphasis
!

defaultSelectorEmphasis
    "must only define a background - otherwise, syntax highlight fg is lost"

    DefaultSelectorEmphasis isNil ifTrue:[
        ^ Array with:(#backgroundColor -> (UserPreferences current selectorBackgroundColorForNavigationService))
    ].
    ^ DefaultSelectorEmphasis

    "Modified: / 21-08-2011 / 09:58:18 / cg"
!

defaultVariableEmphasis
    "must only define a background - otherwise, syntax highlight fg is lost"

    DefaultVariableEmphasis isNil ifTrue:[
        ^ Array with:(#backgroundColor -> (UserPreferences current variableBackgroundColorForNavigationService))
    ].
    ^ DefaultVariableEmphasis

    "Created: / 25-06-2010 / 13:56:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 11:04:20 / cg"
! !

!CodeNavigationService class methodsFor:'testing'!

isUsefulFor:aCodeView
    "this filters useful services.
     Redefined to return true for myself - not for subclasses"

    ^ self == Tools::CodeNavigationService

    "Created: / 22-07-2013 / 13:59:20 / cg"
! !

!CodeNavigationService methodsFor:'change & update'!

update: aspect with: param from: sender
    sender == textView modifiedChannel ifTrue:[
        codeView reallyModified ifTrue:[
            "/ no longer highlight - the info is wrong anyway !!
            self highlightClear.
        ].
    ].

    "JV: I changed 'halt' to 'breakPoint: #cg'"

    "Created: / 22-08-2011 / 16:22:19 / cg"
    "Modified: / 25-08-2011 / 15:10:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-09-2011 / 05:15:42 / cg"
! !

!CodeNavigationService methodsFor:'code services'!

browseClass:class 
    self browser isNil ifTrue:[ ^ NewSystemBrowser browseClass:class ].
    (UserPreferences current alwaysOpenNewTabWhenCtrlClick 
        or:[ self browser navigationState modified ]) 
            ifTrue:[
                self browser 
                    spawnFullBrowserInClass:class
                    selector:nil
                    in:#newBuffer
            ]
            ifFalse:[ self browser switchToClass:class ]

    "Created: / 15-02-2010 / 09:36:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-07-2010 / 11:00:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 10:07:30 / cg"
!

browser

    ^codeView browserHolder value

    "Created: / 06-03-2010 / 21:14:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService methodsFor:'event handling'!

button1Press
    | node |

    node := codeView currentParseNode.
    node isNil ifTrue:[ 
        ^ self 
    ].
    node isSelector ifTrue:[
        self button1PressForMessageNode: node.
        ^self.
    ].
    node isVariable ifTrue:[
        self button1PressForVariableNode: node.
        ^self.
    ].

    ^self.

    "Created: / 14-02-2010 / 18:43:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:58:02 / cg"
    "Modified: / 21-02-2012 / 14:30:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

button1PressForMessageNode: node

    ^self button1PressForSelector: node selector.

    "Created: / 21-02-2012 / 14:30:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2014 / 22:11:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

button1PressForSelector: selector
    | impls |

    impls := codeView implementorsOf: selector.
    "/ impls size = 1 ifTrue:[^codeView browseMethod: impls anyOne].
    [
        menuShown := codeView implementorsMenu: impls selector: selector.
        "/ cg: why is this done?
        "/ self highlightClear.
        menuShown showAtPointer.
    ] ensure:[
        menuShown := nil
    ].

    "Created: / 14-02-2010 / 18:50:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-06-2011 / 19:34:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 17:16:23 / jv"
    "Modified (comment): / 29-08-2013 / 16:27:58 / cg"
!

button1PressForVariableNode: node
    | name value |

    node isGlobalVariable ifTrue:[
        value := nil.
        name := node name asSymbolIfInterned.
        name notNil ifTrue:[
            value := Smalltalk at: name.
        ].
        value notNil ifTrue:[
            value isBehavior ifTrue:[
                self browseClass: value.
            ] ifFalse:[
                value inspect.
            ]
        ]
    ]

    "Created: / 21-02-2012 / 14:30:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2014 / 22:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

button2Press

    | sel node|

    sel := codeView syntaxElementSelection.
    (sel notNil 
      and:[(node := sel node) isMessage 
           or:[node isSelector]]
    ) ifTrue:[
        ^self button2PressForSelector: node selector
    ].

    "Created: / 14-02-2010 / 18:43:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2012 / 16:49:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-06-2014 / 11:09:33 / az"
!

button2PressForSelector: selector
    | senders |

    [
        senders := codeView sendersOf: selector.
    ] valueWithTimeout:(500 milliseconds). 
    senders isNil ifTrue:[^ self].

    "/ senders size = 1 ifTrue:[ codeView browseMethod: senders anyOne. ^ self].
    [
        menuShown := codeView sendersMenu: senders selector: selector.
        "/ cg: why is this done?
        "/ self highlightClear.
        menuShown showAtPointer.
    ] ensure:[
        menuShown := nil.
    ].

    "Created: / 14-02-2010 / 18:50:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-06-2011 / 19:34:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-08-2013 / 21:59:26 / cg"
    "Modified (comment): / 29-08-2013 / 16:28:03 / cg"
!

buttonMotion:button x:x y:y in:view 
    "Handles an event in given view (a subview of codeView).
     If the method returns true, the event will not be processed
     by the view."
    
    (view == textView and:[ textView isQuickMenuModifierPressed ]) ifTrue:[
        self highlightElementAtX:x y:y.
        ^ true
    ].
    ^ false

    "Created: / 06-03-2010 / 20:40:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 21-08-2011 / 10:07:15 / cg"
!

buttonPress: button x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, the event will not be processed
     by the view."

    (view == textView) ifTrue:[
        textView isQuickMenuModifierPressed ifTrue:[
            button == 1      ifTrue: [
                codeView sensor shiftDown ifTrue:[
                    ^self button2Press
                ].
                ^self button1Press
            ].
            button == #paste ifTrue: [^self button2Press].   
            button == 2      ifTrue: [^self button2Press]
        ] ifFalse:[
            button == 1 ifTrue:[
                self highlightVariableAtX:x y:y.
            ]
        ]
    ].
    ^false

    "Created: / 06-03-2010 / 21:12:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-06-2010 / 14:53:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2013 / 23:42:02 / cg"
!

buttonRelease: button x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, the event will not be processed
     by the view."

    "/ if I show a quick senders/implementors menu, eat this event
    ^ menuShown notNil
!

findNextVariableFromCursor
    | currentElement nextElement |

    codeView hasSelection ifTrue:[
        currentElement := self elementAtLine: textView selectionStartLine col: textView selectionStartCol.
    ] ifFalse:[
        currentElement := codeView syntaxElementSelection.
    ].
    currentElement isVariable ifTrue:[
        nextElement := currentElement nextElement.
        nextElement notNil ifTrue:[
            textView selectFrom: nextElement start to: nextElement stop. 
        ]
    ]

    "Created: / 18-09-2013 / 13:15:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

findPreviousVariableFromCursor
    | currentElement prevElement |

    codeView hasSelection ifTrue:[
        currentElement := self elementAtLine: textView selectionStartLine col: textView selectionStartCol.
    ] ifFalse:[
        currentElement := codeView syntaxElementSelection.
    ].
    currentElement isVariable ifTrue:[
        prevElement := currentElement previousElement.
        prevElement notNil ifTrue:[
            textView selectFrom: prevElement start to: prevElement stop. 
        ]
    ]

    "Created: / 18-09-2013 / 13:15:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isQuickMenuModifierPressed
    ^ textView isQuickMenuModifierPressed
"/
"/    sensor := textView sensor.
"/    UserPreferences current codeView2QuickSendersAndImplementorsOnControl ifTrue:[
"/        ^ sensor ctrlDown
"/    ].
"/    ^ sensor metaDown

    "Modified: / 28-08-2013 / 22:13:18 / cg"
!

isQuickMenuModifierReleased
    |sensor|

    sensor := textView sensor.
    UserPreferences current codeView2QuickSendersAndImplementorsOnControl ifTrue:[
        ^ sensor ctrlDown not
    ].
    ^ sensor metaDown not
!

keyPress:key x:x y:y in:view 
    "Handles an event in given view (a subview of codeView).
     If the method returns true, it has eaten the event and it will not be processed
     by the view."

    <resource: #keyboard (#Control_L #Ctrl 
                          #CursorRight #CursorDown #CursorLeft #CursorUp)>

    |ev p sensor|

    (view == textView) ifTrue:[
        sensor := view sensor.

        "/ ("ctrlDown" "key == #'Control_L' or:[ key == #Ctrl ]") ifTrue:[
        (textView isQuickMenuModifierPressed) ifTrue:[
            "/ because it is delegated, the position is not correct
            ev := WindowGroup lastEventQuerySignal query.
            p := view device translatePoint:(ev x @ ev y) fromView:ev view toView:view.
            sensor 
                pushUserEvent:#highlightElementAtX:y: 
                for: self 
                withArguments:{p x. p y.}.
            ^ false "/ true. -- no, don't eat the key
        ].

"/        codeView reallyModified "textView modified" ifTrue:[
"/            self highlightClear. 
"/            codeView syntaxElements: nil.
"/            ^ false
"/        ].


        (key == #FocusNext) ifTrue:[
            sensor pushUserEvent:#findNextVariableFromCursor for:self.            
            ^ true.
        ].
        (key == #FocusPrevious) ifTrue:[
            sensor pushUserEvent:#findPreviousVariableFromCursor for:self.
            ^ true.
        ].

        (key == #CursorRight
          or:[key == #CursorDown
          or:[key == #CursorLeft
          or:[key == #CursorUp]]]
        ) ifTrue:[
            sensor pushUserEvent:#highlightVariableAtCursor for:self .
        ] ifFalse:[
            "/ sensor pushUserEvent:#highlightClear for:self .
        ]

    ].
    ^ false

    "Created: / 06-03-2010 / 20:50:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-09-2011 / 05:17:30 / cg"
    "Modified: / 18-09-2013 / 15:20:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyRelease: key x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, it has eaten the event and it will not be processed
     by the view."

    |ev p|

"/    (view == textView and:[textView isQuickMenuModifierReleased]) ifTrue:[
"/        "/    (view == textView and:[key == #'Control_L' or:[key == #Ctrl]]) ifTrue:[
"/        "/ because it is delegated, the position is not correct
"/        ev := WindowGroup lastEventQuerySignal query.
"/        p := view device translatePoint:(ev x @ ev y) fromView:ev view toView:view.
"/ "/       self highlightClear. 
"/ "/        view sensor pushUserEvent:#highlightClear for:self. 
"/        ^ false "/ true -- do not eat the event
"/    ].
    ^ false

    "Created: / 06-03-2010 / 21:03:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 11:32:40 / cg"
!

linesDeletedFrom: start to: end

    self highlightClear

    "Created: / 06-07-2011 / 17:14:36 / jv"
    "Created: / 16-09-2011 / 15:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesInsertedFrom: start to: end

    self highlightClear

    "Created: / 06-07-2011 / 17:14:36 / jv"
    "Created: / 16-09-2011 / 15:39:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesModifiedFrom: start to: end

    self highlightClear

    "Created: / 06-07-2011 / 17:14:36 / jv"
    "Created: / 16-09-2011 / 15:19:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService methodsFor:'initialization'!

initialize

    super initialize.

    "the following must only define a background - otherwise, syntax highlight fg is lost"
    selectorEmphasis := self class defaultSelectorEmphasis.
    variableEmphasis := self class defaultVariableEmphasis.
    assignmentEmphasis := self class defaultAssignmentEmphasis.
    linesToRedraw := OrderedCollection new.

    "Created: / 25-06-2010 / 14:05:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService methodsFor:'misc'!

highlightClassVariable:name
    "interface from browser (when a class var is selected)"

    self highlightVariable:name isClassVariable:true
!

highlightInstanceVariable:name
    "interface from browser (when an inst var is selected)"

    self highlightVariable:name isClassVariable:false
!

highlightVariable:name isClassVariable:isClassVariable
    "interface from browser (when an inst or class var is selected)"

    |element|

    element := (codeView syntaxElements ? #()) 
                    detect:[:e |     
                        e isVariable
                        and:[ (isClassVariable 
                                    ifTrue:[e isClassVariable ]
                                    ifFalse:[e isInstanceVariable ])
                        and:[ e name = name ]]
                    ] ifNone:nil.

    self highlightClear.
    codeView syntaxElementSelection:nil.
    self highlightVariable:element.
! !

!CodeNavigationService methodsFor:'private'!

elementAtCharacterPosition: pos 
    | treeIndex low high mid midEl |

    treeIndex := codeView syntaxElements.
    treeIndex isNil ifTrue:[ ^ nil ].
    low := 1.
    high := treeIndex size.

    [ low <= high ] whileTrue:[ 
        mid := (low + high) >> 1.
        midEl := treeIndex at: mid.
        pos < midEl start ifTrue:[ 
            high := mid - 1.
        ] ifFalse:[ 
            midEl stop < pos ifTrue:[ 
                low := mid + 1.
            ] ifFalse:[ 
                ^ midEl 
            ].
        ].
    ].
    ^ nil.

    "Created: / 15-02-2014 / 10:14:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

elementAtCursor
    ^self elementAtLine: textView cursorLine col: textView cursorCol "- 1"

    "Created: / 25-06-2010 / 14:39:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

elementAtLine:line col:colArg 
    |col|

    "/ if beyond end of line, do not advance into next line
    col := colArg min:(textView listAt:line) size.
    ^ self elementAtCharacterPosition: (textView characterPositionOfLine:line col:col)

    "Created: / 15-02-2014 / 10:15:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

elementAtX:x y:y 
    |visibleLine line col|

    codeView syntaxElements isNil ifTrue:[^nil].

    visibleLine := textView visibleLineOfY:y.
    col := textView colOfX:x inVisibleLine:visibleLine.
    line := textView visibleLineToAbsoluteLine:visibleLine.
    ^self elementAtLine:line col:col

    "Created: / 25-06-2010 / 14:52:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-08-2010 / 08:50:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 10:26:08 / cg"
!

highlighEmphasisFor: element

    element isNil ifTrue:[^nil].

    element isSelector ifTrue:[^selectorEmphasis].
    element isVariable ifTrue:[^variableEmphasis].
    element isSelf     ifTrue:[^variableEmphasis].

    ^nil

    "Created: / 25-06-2010 / 13:54:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:58:05 / cg"
!

highlightClear

    ^self highlightClear: true.

    "Modified: / 26-12-2007 / 12:28:05 / janfrog"
    "Created: / 25-06-2010 / 14:15:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-07-2011 / 08:50:45 / cg"
    "Modified: / 20-07-2011 / 18:52:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

highlightClear: redraw
    lastHighlightedElement := nil.
    codeView syntaxElementSelection == nil ifTrue:[ ^ self ].

    textView list isNil ifTrue:[ ^ self ].
    textView list withIndexDo:[:line :lineNo | 
        line isText ifTrue:[ 
            (line hasEmphasis: currentEmphasis) ifTrue:[
                line emphasisAllRemove:currentEmphasis.
                linesToRedraw add: lineNo.
            ] ifFalse:[
                (currentEmphasisForAssign notNil and:[line hasEmphasis: currentEmphasisForAssign]) ifTrue:[
                    line emphasisAllRemove:currentEmphasisForAssign.
                    linesToRedraw add: lineNo.
                ]
            ]
        ] 
    ].
    codeView syntaxElementSelection:nil.

    redraw ifTrue:[self redrawLines].

    "Modified: / 26-12-2007 / 12:28:05 / janfrog"
    "Created: / 20-07-2011 / 18:52:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:58:08 / cg"
!

highlightElement:element
    "walk through the chain of elements and highlight each
     Notice, that the chain links elements for the same-variable
     (and lists for same-named-but-in-different-scope variables have
      already been separated)"

    |e firstElement savedEmphasis currentSelection highlightSingle|

    (currentSelection := codeView syntaxElementSelection) == element ifTrue:[ ^ self ]. "/ no change
    currentSelection notNil ifTrue:[
        self highlightClear: false.
    ].

    currentEmphasis := savedEmphasis := self highlighEmphasisFor:element.
    currentEmphasisForAssign := nil.

    highlightSingle :=
        [:element |
            |start stop|

            start := element start.
            stop := element stop.

            element assigned ifTrue:[
                [
                    currentEmphasis := currentEmphasisForAssign := assignmentEmphasis.
                    self highlightWithoutClearFrom:start to:stop.
                ] ensure:[
                    currentEmphasis := savedEmphasis.
                ].
            ] ifFalse:[
                self highlightWithoutClearFrom:start to:stop.
            ].
        ].

    element notNil ifTrue:[ 
        codeView syntaxElementSelection:element.
        e := firstElement := element firstElementInChain.

        "/ cg: I thought that this would work, to speedup up the case, where the same
        "/ element is to be highlighted again (it does, but now, it does not correctly
        "/ redraw in some situations)
        "/ can someone check this?
        false ifTrue:[
            e == lastHighlightedElement ifTrue:[
                "/ same chain
                highlightSingle value:element.
                ^ self
            ].
            lastHighlightedElement := e.    "/ remember
        ].

        [ e notNil ] whileTrue:[
            "/ cg: suppress variables with same name, but in different blocks
            "/ (e isVariable not or:[ e isInSameBlockScopeAs:firstElement]) ifTrue:[
                highlightSingle value:e.
            "/ ].
            e := e nextElement 
        ].
    ].
    self redrawLines.

    "Created: / 14-02-2010 / 16:18:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-07-2011 / 18:52:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 10:22:58 / cg"
!

highlightElementAtCursor
    self highlightElementAtLine: textView cursorLine col: textView cursorCol

    "Created: / 14-02-2010 / 16:17:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2010 / 19:59:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

highlightElementAtLine:line col:col 
    |elementOrNil|

    elementOrNil := self elementAtLine: line col: col.
    self highlightElement:elementOrNil

    "Created: / 14-02-2010 / 16:17:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-10-2013 / 01:29:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

highlightElementAtX:x y:y 
    |elementOrNil|

    elementOrNil := self elementAtX:x y:y.
    self highlightElement:elementOrNil

    "Created: / 14-02-2010 / 16:12:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2010 / 20:06:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 10:22:10 / cg"
!

highlightElementOrNil:e
    e notNil ifTrue:[
        "/ cg: only if selected !!
        "/ self halt.
        self highlightElement:e.
    ] ifFalse:[
        self highlightClear
    ].

    "Created: / 25-06-2010 / 14:52:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 21-08-2011 / 09:56:39 / cg"
!

highlightLine:lineNo fromLine:startLine col:endLine toLine:startCol col:endCol
    |line start end|

    (lineNo between:startLine and:endLine) ifFalse:[ ^ self ].

    line := textView listAt:lineNo.
    line isEmpty ifTrue:[^self].

    start := (lineNo = startLine) 
                ifTrue:[ startCol  ] 
                ifFalse:[ line indexOfNonSeparator ].
    end := (lineNo = endLine) 
                ifTrue:[ endCol ] 
                ifFalse:[ line size ].
    line setRuns:(line runs asArray).
    "/ JV: CG commented following and added the commtent code below.
    "/     however, this clear all other emphasis like bold, color and so on!!
    line 
        emphasisFrom:(start max: 1)
        to:(end min: line size)
        add: currentEmphasis.
"/    line 
"/        emphasizeFrom:(start max: 1)
"/        to:(end min: line size)
"/        with: currentEmphasis.
    line setRuns:(line runs asRunArray).                              

    linesToRedraw add: lineNo.

    "Created: / 25-06-2010 / 14:15:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-07-2011 / 13:02:51 / cg"
    "Modified: / 25-02-2014 / 21:01:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

highlightVariable:element 
    (element notNil and:[ element isVariableOrSelf ]) ifTrue:[
        self highlightElement:element.
    ] ifFalse:[
        self highlightClear.
    ].

    "Modified: / 20-07-2011 / 18:54:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 09:39:42 / cg"
!

highlightVariableAtCursor
    self highlightElementOrNil:(self elementAtCursor)

    "Modified: / 25-06-2010 / 14:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 09:56:56 / cg"
!

highlightVariableAtX:x y:y 
    self highlightElementOrNil:(self elementAtX:x y:y).

    "Created: / 25-06-2010 / 14:52:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 10:24:50 / cg"
!

highlightWithoutClearFrom: start to: end
    "Remove underlined emphasis"

    |startLine startCol endLine endCol|

    startLine := textView lineOfCharacterPosition:start.
    startCol := start - (textView characterPositionOfLine:startLine col:1) + 1.
    endLine := textView lineOfCharacterPosition:end.
    endCol := end - (textView characterPositionOfLine:endLine col:1) + 1.
    self highlightWithoutClearFromLine: startLine col: startCol toLine: endLine col: endCol

    "Created: / 25-06-2010 / 14:15:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

highlightWithoutClearFromLine: startLine col: startCol toLine: endLine col: endCol 

    textView list keysAndValuesDo: [:lineNo :line|
        line isText ifTrue: [
            self highlightLine: lineNo fromLine: startLine col: endLine toLine: startCol col: endCol
        ]
    ].

    "Created: / 25-06-2010 / 14:15:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService methodsFor:'redrawing'!

redrawLines
    linesToRedraw do:[:lineNo|
        textView invalidateLine: lineNo.
    ].
    linesToRedraw := OrderedCollection new

    "Created: / 20-07-2011 / 18:45:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 18-08-2011 / 16:01:34 / cg"
! !

!CodeNavigationService class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

