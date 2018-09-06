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

SelectionInListModelView subclass:#CodeCompletionMenu
	instanceVariableNames:'wholeList typedString codeView selectedString cursorCol column
		position'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

!CodeCompletionMenu class methodsFor:'documentation'!

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

!CodeCompletionMenu class methodsFor:'interface opening'!

openFor: aCodeView at: anInteger with:aCollection
    |m|

    m := (self new)
        initializeForView:aCodeView at: anInteger with: aCollection.

    ^ m openModalXX.

    "Created: / 16-02-2010 / 10:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2010 / 08:41:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-07-2011 / 00:05:01 / cg"
! !

!CodeCompletionMenu methodsFor:'accessing'!

contentHeight

    | size |

    size := self list size max: 10.
    ^(size * (wholeList anyOne heightOn:self)) + 15

    "Created: / 22-03-2006 / 22:36:49 / janfrog"
    "Modified: / 26-03-2006 / 19:39:49 / janfrog"
    "Modified: / 16-02-2010 / 10:58:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contentWidth

    | w |

    w := wholeList
        inject:0
        into:[:max :each|max max:(each widthOn:self)].

    ^(w + 20) min: 600

    "Created: / 22-03-2006 / 22:36:49 / janfrog"
    "Modified: / 06-03-2010 / 08:17:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeCompletionMenu methodsFor:'event handling'!

backspaceKeyPress

    typedString isEmpty ifTrue:[^self topView close].

    typedString := typedString allButLast.
    self updateList

    "Created: / 25-05-2005 / 20:03:22 / janfrog"
    "Modified: / 22-03-2006 / 21:04:09 / janfrog"
!

characterKeyPress:aCharacter
    | newString |

    newString := typedString , aCharacter.
    (wholeList anySatisfy:[:s|s startsWith:newString]) ifTrue:[
        typedString := newString.
        self updateList.
    ]

    "Created: / 25-05-2005 / 20:02:12 / janfrog"
    "Modified: / 27-05-2005 / 22:29:10 / janfrog"
!

doubleClicked
    self returnKeyPress

    "Created: / 30-06-2011 / 20:01:03 / cg"
!

keyPress:key x:x y:y
    <resource: #keyboard (#Return #BackSpace #Tab)>

    key isCharacter ifTrue:[
        self characterKeyPress:key.
        codeView keyPress:key x:x y:y.
        ^self
    ].
    key == #Return ifTrue:[
        self returnKeyPress.
        ^self
    ].
    key == #BackSpace ifTrue:[
        codeView keyPress:key x:x y:y.
        self backspaceKeyPress.
        ^self
    ].
    key == #Tab ifTrue:[
           "/self tabKeyPressX:x y:y.
           Transcript showCR:'Tab-completion broken. Disabled'.
           ^self.
    ].

    ^super keyPress:key x:x y:y

    "Created: / 25-05-2005 / 19:57:27 / janfrog"
    "Modified: / 22-03-2006 / 21:12:35 / janfrog"
!

mapped
    super mapped.
    self forceUngrabPointer.
    self grabPointer.

"/    self requestFocus.
"/    self grabPointer.
"/    self grabKeyboard.

    "Created: / 30-06-2011 / 19:58:59 / cg"
!

returnKeyPress

    self list size = 1 ifTrue:[
        selectedString := self list first.
        codeView setCursorCol:cursorCol.
        self topView close
    ] ifFalse:[        
        self selection ifNotNil:[
            selectedString := self at:self selection.
            codeView setCursorCol:cursorCol.
            self topView close
        ]
    ]

    "Created: / 25-05-2005 / 20:34:16 / janfrog"
    "Modified: / 29-05-2005 / 09:40:15 / janfrog"
!

tabKeyPressX:x y:y
    | currentList idx char completionString|

    currentList := self list.
    idx := typedString size + 1.
    [
        (currentList conform:[:s|s size >= idx]) 
        and:[
            char := currentList anyOne at:idx.
            currentList conform:[:s|(s at:idx) == char]
        ]
    ] whileTrue:[
        idx := idx + 1.
    ].
    completionString := currentList anyOne copyFrom:(typedString size + 1) to:idx - 1.
    completionString do:[:c|codeView keyPress:c x:x y:y].
    typedString := typedString , completionString.
    Transcript showCR:typedString

    "Created: / 29-05-2005 / 09:50:03 / janfrog"
! !

!CodeCompletionMenu methodsFor:'initialize'!

initialize

    super initialize.

    typedString := ''.
    highlightMode := #line

    "Created: / 28-05-2005 / 19:49:09 / janfrog"
!

initializeForView: aTextView at: anInteger with: aCollection 

    self initialize.

    codeView := aTextView.
    wholeList := aCollection.
    "/ self font:codeView font.
    position := anInteger.
    cursorCol := codeView cursorCol.

    "Modified: / 29-05-2005 / 09:39:35 / janfrog"
    "Created: / 16-02-2010 / 10:10:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-07-2011 / 00:08:31 / cg"
! !

!CodeCompletionMenu methodsFor:'interface opening'!

openModalXX
    | modalBox p |

    self updateList.

    self list size == 1 ifTrue:[^self list anyOne string copyFrom:(typedString size + 1)].

    modalBox := PopUpView new.

    ScrollableView   
        forView:self 
        hasHorizontalScrollBar:false 
        hasVerticalScrollBar:true 
        miniScrollerH:true 
        miniScrollerV:true 
        origin:0.0@0.0 
        corner:1.0@1.0 
        in:modalBox.

    modalBox extent:(self contentWidth) @ (self contentHeight).

    p := codeView originRelativeTo: nil.
    p x: (p x + (codeView xOfPosition:position) - textStartLeft - 3).
    p y: (p y + ("(codeView yOfPosition:position) max:"
                    (codeView yOfCursor)) + gc font maxHeight).
    "/x := codeView absoluteXOfCursor - (typedString widthOn:codeView) - 10 - 12"/width of icon
    " 10 - Magic number, but looks good on my computer"
    "/x := (codeView absoluteXOfPosition: position) - textStartLeft - 3.
    "/y := codeView absoluteYOfCursor + font maxHeight.
    "/y := (codeView absoluteYOfCursor max: (codeView absoluteYOfPosition: position))  + font maxHeight.

    modalBox origin:p.
    modalBox makeFullyVisible.
    modalBox exclusivePointer:false.
    modalBox open.
    ^ selectedString ifNotNil:[selectedString string copyFrom:(typedString size + 1)]

    "Modified: / 01-07-2011 / 09:30:29 / cg"
! !

!CodeCompletionMenu methodsFor:'updating'!

updateList

    self list:(wholeList select:[:s| s startsWith:typedString])

    "Created: / 25-05-2005 / 20:06:07 / janfrog"
    "Modified: / 27-05-2005 / 22:23:37 / janfrog"
! !

!CodeCompletionMenu class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__CodeCompletionMenu.st,v 1.6 2014-02-18 17:00:43 stefan Exp $'
!

version_SVN
    ^ '$Id: Tools__CodeCompletionMenu.st,v 1.6 2014-02-18 17:00:43 stefan Exp $'
! !

