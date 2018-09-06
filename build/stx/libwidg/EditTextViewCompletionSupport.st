"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

Object subclass:#EditTextViewCompletionSupport
	instanceVariableNames:'completionView completionProcess editView autoSelect
		editViewLostFocusBlock'
	classVariableNames:'LastCompletions'
	poolDictionaries:''
	category:'Views-Text'
!

!EditTextViewCompletionSupport class methodsFor:'documentation'!

documentation
"
    An abstract supperclass to support completion in text views.
    Individual completion engines may create a subclass of
    EditTextCompletionSupport and customize it.

    Basically, they have to implement #computeCompletions

    [author:]
        Claus Gittinger

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!EditTextViewCompletionSupport class methodsFor:'instance creation'!

for:anEditView
    ^ self new editView:anEditView
! !

!EditTextViewCompletionSupport class methodsFor:'queries'!

isAbstract
    ^ self == EditTextViewCompletionSupport

    "Created: / 26-09-2013 / 16:22:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditTextViewCompletionSupport methodsFor:'accessing'!

editView:anEditTextView
    editView := anEditTextView.
! !

!EditTextViewCompletionSupport methodsFor:'events'!

buttonPress:button x:x y:y
    self closeCompletionView.
!

editViewLostFocus
    "this is a hack for Windows:
     on windows, an activate:false event is first sent to my textView,
     then an activate is sent to the completion popup.
     this is done BEFORE the buttonPress event is delivered.
     therefore, allow for the activate of the completionMenu and its button event to be processed.
     before forcing it to be closed..."

    | focusedView |

    "/ JV@2017-12-15: I don't really understand the problem and the solution.
    "/ However, closing forcibly the completion view turned out to be a problem
    "/ on Windows IF focus-follow-mouse is enabled:
    "/
    "/ When a completion view is opened, it may be opened just "below" the mouse
    "/ so the completion view gets the focus and edit view looses it. Since
    "/ edit view lost focus, this method is called and completion view is closed.
    "/
    "/ To handle this case, we do nothing IF focus switches to editor or
    "/ the completion view itself.
    "/
    "/ See issue https://swing.fit.cvut.cz/projects/stx-jv/ticket/176
    "/
    focusedView := editView device focusView.
    focusedView notNil ifTrue:[
        focusedView == editView ifTrue:[ ^ self ].
        focusedView topView == completionView ifTrue:[ ^ self ].
    ].

    completionView notNil ifTrue:[
        editView graphicsDevice anyButtonPressed ifTrue:[
            editView sensor pushUserEvent:#editViewLostFocus for:self.
        ] ifFalse:[
            self closeCompletionView
        ]
    ].

    "Modified: / 15-12-2017 / 00:26:50 / jv"
    "Modified (comment): / 15-12-2017 / 08:43:37 / jv"
!

handleKeyPress:key x:x y:y
    "return true, if I have eaten this keypress"

    |ch completeImmediate eatCursorLeftOrRight eatCursorUpDown|

    "/ completeImmediate := UserPreferences current immediateCodeCompletion.

    "/ open on CTRL- or TAB-key?
    (completionView isNil or:[completionView realized not]) ifTrue:[
        editView hasSelection ifFalse:[
            ((ch := editView characterBeforeCursor) notNil "/ i.e. not at begin of line
            and:[ ch isLetterOrDigit or:[ ch == $_ ] ]) ifTrue:[
                (key == #Control_L or:[ key == #Ctrl or:[ key == #Control_R or:[ key == #Control]]]) ifTrue:[
                    UserPreferences current codeCompletionOnControlKey ifTrue:[
                        autoSelect := true.
                        self updateCompletionList
                    ]
                ].
                ((key == #Tab) and:[editView sensor shiftDown not]) ifTrue:[
                    UserPreferences current codeCompletionOnTabKey ifTrue:[
                        autoSelect := true.
                        self updateCompletionList.
                        ^ true
                    ].
                ]
            ].
        ].
        ^ false.
    ].

    "/ key for completion view ? (careful: do not forward too many, it would disturb user's typing)
    key isCharacter ifFalse:[
        "/ forward to menu
        (completionView notNil) ifTrue:[
            "/never
            eatCursorLeftOrRight := false.
"/                                    completeImmediate not
"/                                    or:[ editView sensor shiftDown
"/                                    or:[ editView sensor ctrlDown ]].
            "/ only with shift or ctrl
            eatCursorUpDown :=
                    (UserPreferences current codeCompletionViewKeyboardNavigationNeedsModifier not)
                    or:[ editView sensor shiftDown
                    or:[ editView sensor ctrlDown]].

            ((key == #CursorDown and:[eatCursorUpDown])
                or:[ (key == #CursorUp and:[eatCursorUpDown])
                or:[ ((key == #CursorLeft) and:[eatCursorLeftOrRight])
                or:[ ((key == #CursorRight) and:[eatCursorLeftOrRight])
                or:[ ((key == #Return) and:[ completionView hasSelection ])
            ]]]]) ifTrue:[
                "/ forward to completion view
                completionView sensor pushUserEvent:#value for:[ completionView keyPress:key x:0 y:0 ].
                ^ true.
            ].

            (key == #Control_L or:[ key == #Control_R or:[ key == #Control or:[ key == #Ctrl ]]]) ifTrue:[
                "/ CTRL is a toggle
"/                self closeCompletionView.
"/                ^ true.
                ^ false "/ don't eat
            ].
            (key == #Escape) ifTrue:[
                self closeCompletionView.
                ^ true  "/ EAT
            ].
            "/ shift does not close
            (key == #Shift_L or:[ key == #Shift_R or:[ key == #Shift]]) ifTrue:[
                ^ false "/ don' eat
            ].

            (key == #BackSpace) ifTrue:[
                ^ false "/ don' eat
            ].
            self closeCompletionView.
            ^ false "/ don' eat
        ].
    ].
    ^ false.
!

postKeyPress:key
    |doComplete|

    UserPreferences current immediateCodeCompletion ifFalse:[
        "/ only update, if already open
        completionView isNil ifTrue:[^ self].
    ].

    (key == #BackSpace or:[key == #BasicBackspace]) ifTrue:[
        autoSelect := false.
        self updateCompletionList.
        ^ self
    ].

    key isCharacter ifTrue:[
        (doComplete := key isSeparator not) ifFalse:[
            "/ also on a separator, but only if at the end of a non-empty line
            doComplete := editView lineStringBeforeCursor withoutSeparators notEmpty.
        ].
        doComplete ifFalse:[
            self closeCompletionView
        ] ifTrue:[
            autoSelect := false.
            self updateCompletionList.
        ].
        ^ self
    ].
!

startTimeoutForEditViewLostFocus
    "see comment in #editViewLostFocus"

    editViewLostFocusBlock isNil ifTrue:[
        editViewLostFocusBlock := [self editViewLostFocus].
    ].
    Processor addTimedBlock:editViewLostFocusBlock afterMilliseconds:200.
! !

!EditTextViewCompletionSupport methodsFor:'private'!

computeCompletions
    "Actually compute the completions and update the completion view."

    self subclassResponsibility

    "Created: / 26-09-2013 / 17:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    self stopCompletionProcess.
    self closeCompletionView.
    super release
!

startCompletionProcess
    "start the code completion process in the background"

    |initialList cursorX cursorY|

    "/ terminate any previous process
    self stopCompletionProcess.

    (editView sensor hasKeyPressEventFor:nil) ifTrue:[
        "/ 'cl' printCR.
        self closeCompletionView.
        ^ self
    ].
    ((cursorX := editView xOfCursor) isNil
    or:[ (cursorY := editView yOfCursor) isNil ]) ifTrue:[
        "/ no cursor - user is selecting, or cursor has been scrolled out of sight.
        "/ 'cl2' printCR.
        self closeCompletionView.
        ^ self
    ].

    completionView isNil ifTrue:[
        initialList := #( 'Busy...' ).
        "/ 'op1' printCR.
    ] ifFalse:[
        initialList := completionView list.
        "/ 'op2' printCR.
    ].
    self openCompletionView:initialList.

    completionProcess :=
        [
            "/ protect end-user applications from errors
            Error handle:[:ex |
                Smalltalk isSmalltalkDevelopmentSystem ifTrue:[ ex reject ]
            ] do:[
                (editView topView isDebugView) ifTrue:[
                    ControlInterrupt ignoreIn:[
                        self computeCompletions.
                    ].
                ] ifFalse:[
                    self computeCompletions.
                ].
            ].
        ] forkAt:(Processor activePriority - 1).

    "Modified: / 26-09-2013 / 17:36:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stopCompletionProcess
    "kill any background completion process"

    |p|

    (p := completionProcess) notNil ifTrue:[
        completionProcess := nil.
        p terminate.
    ].
!

updateCompletionList
    "called for keypress events"

    self startCompletionProcess.
! !

!EditTextViewCompletionSupport methodsFor:'private-API'!

closeCompletionView
    |v|

    (v := completionView) notNil ifTrue:[
        completionView := nil.
        "/ let it close itself - avoids synchronization problems
        v sensor
            pushUserEvent:#value
            for:[ v topView destroy ]
    ].
!

openCompletionView
    "Opens the completion view with an initial list. Called as soon as
     completion is initiated but completion options are not yet computed."

    self openCompletionView: (Array with: 'Busy...')

    "Created: / 26-09-2013 / 17:06:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openCompletionView: list
    "Makes sure the completion view is opened and with given `list`."

    | textCursorPosInTextView textCursorPosOnScreen movePos topView
      screenBounds screenBoundsCorner
      helpViewsExtent helpViewsWidth helpViewsHeight|

    "/ move the window away from the text cursor (to not cover what user types in)
    "/ get the screen-relative position of the text cursor
    textCursorPosInTextView := editView xOfCursor @ editView yOfCursor.

    "/ care for the scroll-offset (xOfCursor/yOFCursor gives me
    textCursorPosInTextView := textCursorPosInTextView - (editView viewOrigin x @ 0).

    textCursorPosOnScreen := editView device
                    translatePoint:textCursorPosInTextView
                    fromView:editView toView:nil.

    "/ currently, we have to stay away a bit, to avoid getting the focus
    "/ this will be somewhat to the down-right of the textCursor
    movePos := textCursorPosOnScreen + (60 @ (editView font height)).

    completionView isNil ifTrue:[
        completionView := CodeCompletionHelpMenuView new.
        completionView name:'completion'.
        completionView level:0.
        completionView list:list.
        completionView enable:false.
        completionView extent:completionView preferredExtentForContents.
        "/ completionView font: editView font.
        topView := CodeCompletionHelpView with:completionView.
        topView editView:editView.
    ] ifFalse:[
        completionView list:list.
        topView := completionView topView.
    ].

    topView ~~ completionView ifTrue:[
        topView resizeToFit.

        "/ make sure, the window is visible
        screenBounds := topView device monitorBoundsAt:topView origin.
        screenBoundsCorner := screenBounds corner.

        helpViewsExtent := topView extent.
        helpViewsWidth := helpViewsExtent x.
        helpViewsHeight := helpViewsExtent y.

        "/ if it does not lie completely inside the screen, move it
        (movePos x + helpViewsWidth) > screenBoundsCorner x ifTrue:[
            movePos := (textCursorPosOnScreen x - 60 - helpViewsWidth) @ movePos y.
        ].
        (movePos y + helpViewsHeight) > screenBoundsCorner y ifTrue:[
            movePos := movePos x @ (textCursorPosOnScreen y - helpViewsHeight).
        ].
        movePos y < 0 ifTrue:[
            movePos := movePos x @ 0
        ].
        topView origin:movePos.
    ].

    "Created: / 26-09-2013 / 17:07:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!EditTextViewCompletionSupport class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

