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

CodeViewService subclass:#BreakpointService
	instanceVariableNames:'breakpoints currentMethod currentMethodClass methodHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

!BreakpointService class methodsFor:'documentation'!

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

!BreakpointService class methodsFor:'accessing'!

label
    "Answers a short label - for UI"

    ^ 'Breakpoints'
! !

!BreakpointService class methodsFor:'testing'!

isUsefulFor:aCodeView
    "this filters useful services.
     Redefined to return true for myself - not for subclasses"

    ^ self == Tools::BreakpointService

    "Created: / 22-07-2013 / 14:01:17 / cg"
! !

!BreakpointService methodsFor:'accessing'!

breakpointAtLine:line
    "return the breakpoint at line (may be disabled) or nil, if there is none"

    |pos|

    breakpoints isNil ifTrue:[^ nil].

    pos := textView characterPositionOfLine:line col:1.
    ^ breakpoints 
        detect:[:each | each position = pos ] 
        ifNone:[ 
            breakpoints 
                detect:[:each | each line == line and:[each position isNil ]] 
                ifNone:[ nil ]
        ]

    "Modified: / 17-06-2011 / 13:59:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-07-2011 / 21:33:23 / cg"
!

breakpoints
    "/ Fixup breakpoint positions
    self fixupBreakpointPositions.
    ^ breakpoints

    "Modified: / 08-05-2014 / 14:02:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeAllBreakpoints
    breakpoints := OrderedCollection new.
    gutterView invalidate.
!

setOrToggleBreakpointAtLine:line
    |pos bpnt prepareFullBreakSupport mClass ok|

    "/ if true, setting a single breakpoint in a method will create
    "/ a whole set of invisible (and disabled) breakpoints in that method,
    "/ one for each line.
    "/ These can later be enabled in the debugger
    "/ (otherwise, the debugger's behavior is stupid, as it cannot recompile a method
    "/ to set additional breakpoints).
    "/ We accept the additional overhead, as we are in debug mode anyway.
    "/ prepareFullBreakSupport := false.
    prepareFullBreakSupport := true.

    codeView method isNil ifTrue:[
        ^ self
    ].
    currentMethod isNil ifTrue:[   
        ^ self
    ].

    textView reallyModified ifTrue:[
        "/ leads to ugly behavior (method no longer found), if we allow
        "/ this...
        Dialog warn:'Please accept first (cannot set breakpoint while text is modified)'.
        ^ self
    ].

    bpnt := self breakpointAtLine:line.
    bpnt isNil ifTrue:[
        "/ no breakpoint there - create a new one as required (i.e. recompile)
        ok := (self canCreateOrToggleBreakpointAtLine:line).
        ok ifFalse:[
            (currentMethod isMethodWithBreakpoints and:[ prepareFullBreakSupport ]) ifFalse:[
                (codeView topView notNil and:[codeView topView isDebugView]) ifTrue:[
                    (Dialog 
                        confirm:'Sorry, in an active method, I can only add new breakpoints in an already breakpointed method.
(i.e. a method stopped at a method breakpoint or one which already has statement breakpoints)
The reason is that the method needs to be recompiled for the breakpoint, which would not affect the method being currently executed.

You can proceed to set the breakpoint, but it will only affect the next call into this method, not the current invocation.'
                        yesLabel:'Set Breakpoint for Next Call' noLabel:'OK') ifTrue:[
"/ self halt.
                            ok := true.
                        ]
                ] ifFalse:[
                    Dialog warn:'Sorry, cannot add a new breakpoint here.'.
                ].
            ]
        ].
        ok ifTrue:[
            prepareFullBreakSupport ifTrue:[
                "/ add a (disabled) breakpoint for every source line. This
                "/ allows for breakpoints to be enabled/disabled in the debugger...
                1 to:textView numberOfLines do:[:eachLine |
                    |oldBPnt eachPos otherBpnt|

                    oldBPnt := self breakpointAtLine:eachLine.
                    oldBPnt isNil ifTrue:[
                        eachPos := textView characterPositionOfLine:eachLine col:1.
                        breakpoints isNil ifTrue:[ breakpoints := OrderedCollection new].
                        breakpoints add:((otherBpnt := Breakpoint new method:codeView method) position:eachPos line:eachLine).
                        eachLine == line ifTrue:[
                            bpnt := otherBpnt.
                        ] ifFalse:[
                            otherBpnt beInvisible.
                        ]
                    ].
                ].
            ] ifFalse:[
                pos := textView characterPositionOfLine:line col:1.
                breakpoints add:((bpnt := Breakpoint new method:codeView method) position:pos line:line).
            ].
            Screen current shiftDown ifTrue:[
                "/ trace
                bpnt beTracepoint
            ].
            self assert: breakpoints notEmptyOrNil.

            "/ recompile the method with breakpoints
            self recompile.
        ]
    ] ifFalse:[
        "/ breakpoint already there - just enable/disable
        Screen current shiftDown ifTrue:[
            bpnt toggleTracing
        ] ifFalse:[
            bpnt toggle.
        ].
        (currentMethod isNil or:[(mClass := currentMethod mclass) isNil]) ifTrue:[
            "/ hack: ouch - was wrapped in the meantime;
            "/ hurry up and update. Should be done elsewhere (in codeView)
            self updateCurrentMethod.
            currentMethod notNil ifTrue:[ mClass := currentMethod mclass ].
        ].
        bpnt method:currentMethod.
        mClass notNil ifTrue:[
            Smalltalk changed:#methodTrap with:(MethodTrapChangeNotificationParameter changeClass:mClass changeSelector:currentMethod selector).
        ].
    ].

    (bpnt notNil and:[bpnt isReached not]) ifTrue:[
        | app |    

        app := codeView application.
        (app respondsTo: #showInfo:) ifTrue:[
            app showInfo: 'Cannot set breakpoint here, try another line...'.
        ].
        "/ codeView flash.
    ] ifFalse:[
        gutterView redrawLine:line.
    ].

    "Created: / 17-06-2011 / 13:45:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2014 / 17:36:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-11-2016 / 18:49:05 / cg"
! !

!BreakpointService methodsFor:'change & update'!

update: aspect with: param from: sender
    aspect == #visibility ifTrue:[^ self].
    aspect == #sizeOfView ifTrue:[^ self].
    aspect == #classHolder ifTrue:[^ self].
    aspect == #languageHolder ifTrue:[^ self].
    sender == codeView modifiedChannel ifTrue:[^ self].

    "/ ATTENTION: I thought that fetching the methodHolder once in initialize would
    "/ be ok. However, it seems not (codeView gives me something which it does not use/change later).
    "/ so this fetch is called in update as well.
    "/ maybe s.o. (ie. Jan) fixes CodeView2
    (aspect == #methodHolder or:[sender == self fetchMethodHolder]) ifTrue:[
        self updateCurrentMethod.
    ].
    super update: aspect with: param from: sender

    "Created: / 06-07-2011 / 15:21:08 / cg"
!

updateBreakPointsFor:aMethod
    |methodsBreakPoints|

    "/ Transcript show:'update breakpoints for method: '; showCR:aMethod.
    aMethod notNil ifTrue:[
        aMethod breakpointsDo:[:eachLiteral |
            methodsBreakPoints isNil ifTrue:[
                methodsBreakPoints := OrderedCollection new.
            ].
            methodsBreakPoints add:eachLiteral copy.
        ].
        currentMethodClass := aMethod mclass.
    ] ifFalse:[
        currentMethodClass := nil
    ].
    breakpoints := methodsBreakPoints.
    breakpoints notNil ifTrue:[ 
        "/ Nil out breakpoint's position. It's invalid as soon as
        "/ user edits the code. Instead, depend on line information.
        "/ Breakpoint character positions are fixed up just before
        "/ passing a breakpoints to the compiler, see
        "/ #fixupBreakpointPositions
        breakpoints do:[:each | each method:aMethod. each position: nil ].
    ].
    currentMethod := aMethod.

    "Created: / 06-07-2011 / 15:24:09 / cg"
    "Modified: / 06-07-2011 / 17:32:54 / jv"
    "Modified: / 23-02-2015 / 14:48:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateCurrentMethod
    |method realMethod oldBreakPoints|

    "/ codeView methodHolder class == BlockValue ifTrue:[self breakPoint:#cg].

    method := realMethod := codeView method.
    (method notNil and:[method mclass isNil]) ifTrue:[
        "/ hack: ouch - was wrapped in the meantime;
        "/ hurry up and update. Should be done elsewhere (in codeView)
        realMethod := MethodWithBreakpoints allBreakpointedMethods detect:[:m | m originalMethod == method and:[m mclass notNil]] ifNone:nil.
        realMethod isNil ifTrue:[
            realMethod := WrappedMethod allWrappedMethods detect:[:m | m originalMethod == method and:[m mclass notNil]] ifNone:nil.
        ].
    ].
    realMethod ~~ currentMethod ifTrue:[
        "/ self fetchMethodHolder setValue:realMethod.
        oldBreakPoints := breakpoints.
        self updateBreakPointsFor:realMethod.
        oldBreakPoints ~= breakpoints ifTrue:[
            gutterView invalidate.
        ]
    ].

    "Modified: / 22-07-2013 / 13:33:28 / cg"
! !

!BreakpointService methodsFor:'event handling'!

buttonMultiPress:button x:x y:y in:view
    |lineNr|

    view == gutterView ifTrue:[
        button == 1 ifTrue:[
            lineNr := textView yVisibleToLineNr:y.
            lineNr notNil ifTrue:[ self setOrToggleBreakpointAtLine:lineNr ].
            ^ true.
        ].
        button == 3 ifTrue:[
            ^ true.
        ]
    ].
    ^ false

    "Created: / 17-06-2011 / 13:05:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-06-2011 / 08:31:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-09-2011 / 14:41:00 / cg"
!

buttonPress:button x:x y:y in:view
    |lineNr|

    "now disabled: need a double click (like in other editors);
     also this allows toggling breakpoints even if there are ther service-annotations"

    view == gutterView ifTrue:[
        button == 1 ifTrue:[
            lineNr := textView yVisibleToLineNr:y.
            FlyByHelp currentHelpListener notNil ifTrue:[
                "/ show a message that a double click is now needed    
                FlyByHelp currentHelpListener initiateHelpFor:view at:x@y now:true
            ].
"/            lineNr notNil ifTrue:[ self setOrToggleBreakpointAtLine:lineNr ].
            ^ false.
        ].
"/        button == 3 ifTrue:[
"/            ^ true.
"/        ]
    ].
    ^ false

    "Created: / 17-06-2011 / 13:05:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-09-2011 / 14:41:00 / cg"
    "Modified: / 03-12-2014 / 10:22:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:key x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, it has eaten the event and it will not be processed
     by the view."

    key == #Accept ifTrue:[ 
        textView undoableDo:[
            BreakpointQuery answer: self breakpoints do:[
                textView accept.
            ].
        ].
        ^ true
    ].
    ^ false

    "Created: / 08-05-2014 / 10:42:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-05-2014 / 13:52:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesDeletedFrom: start to: end
    | breakpointsToRemove |

    breakpoints isEmptyOrNil ifTrue:[^self].

    breakpointsToRemove := Set new.
    start to: end do:[:line | 
        | breakpointToRemove |

        breakpointToRemove := self breakpointAtLine: line.
        breakpointToRemove notNil ifTrue:[ breakpointsToRemove add: breakpointToRemove ].
    ].
    breakpoints removeAll: breakpointsToRemove.
    self moveBreakpointsAfterLine: end by: (end - start + 1) negated

    "Created: / 06-07-2011 / 17:16:27 / jv"
    "Modified: / 04-06-2014 / 17:56:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesInsertedFrom: start to: end

    breakpoints isEmptyOrNil ifTrue:[^self].

    self moveBreakpointsAfterLine: start - 1 by: (end - start + 1)

    "Created: / 06-07-2011 / 17:16:36 / jv"
! !

!BreakpointService methodsFor:'help'!

flyByHelpTextAtLine:ignoredLineNr
    |topView|

    (self canCreateOrToggleBreakpointAtLine:nil) ifFalse:[
        ((topView := codeView topView) notNil and:[topView isDebugView]) ifTrue:[
            self hasBreakpoints ifFalse:[
                ^ 'Sorry - cannot add breakpoint in the debugger (would need recompilation)\(can only add breakpoints if stopped at a method breakpoint)' withCRs
            ].
            ^ 'Sorry - cannot add new breakpoint if method is already entered\(i.e. if not stopped at a breakpoint).' withCRs
        ].
        ^ 'Cannot add breakpoint when modified. Please accept first.'
    ].

    ^ 'Double Click to toggle breakpoint. Shift-Double-Click to toggle tracepoint.'

    "Created: / 27-01-2012 / 14:04:52 / cg"
! !

!BreakpointService methodsFor:'initialization'!

fetchMethodHolder
    "redefinable in subclasses, which do not have a codeView2/methodHolder"

    "/ ATTENTION: I thought that fetching the methodHolder once in initialize would
    "/ be ok. However, it seems not (codeView gives me something which it does not use/change later).
    "/ so this fetch is called in update as well.
    "/ maybe s.o. (ie. Jan) fixes CodeView2
    methodHolder := codeView methodHolder.
    ^ methodHolder
!

initialize

    super initialize.
    breakpoints := OrderedCollection new.

    "Created: / 17-06-2011 / 13:49:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BreakpointService methodsFor:'private'!

fixupBreakpointPositions
    breakpoints notEmptyOrNil ifTrue:[ 
        breakpoints do:[:each |  
            | pos |

            pos := textView characterPositionOfLine: each line col:1.
            each position: pos.  
        ].
        breakpoints := breakpoints select:[:b |b line >= 0].
        breakpoints sort:[:a :b|a position <= b position].
   ].

    "Created: / 08-05-2014 / 14:02:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-11-2016 / 18:30:56 / cg"
    "Modified (comment): / 21-11-2016 / 12:49:07 / cg"
!

moveBreakpointsAfterLine:line by: delta
    breakpoints do:[:bpnt|
        bpnt line >= line ifTrue:[
            "/ Note that position will be fixed up in BreakpointService>>breakpoints
            bpnt position:nil line:(bpnt line + delta). 
        ]
    ].
    breakpoints := breakpoints reject:[:bpnt | bpnt line <= 0].

    "/gutterView redrawLinesFrom: line.

    "Created: / 17-06-2011 / 13:45:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 06-07-2011 / 17:26:30 / jv"
    "Modified: / 08-05-2014 / 14:01:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-11-2016 / 19:09:12 / cg"
!

recompile
    "recompile the current method for changed breakpoints"

    |oldMethod newMethod compilerClass compiler class selector|

    oldMethod := codeView method.
    (oldMethod notNil and:[oldMethod hasPrimitiveCode not]) ifTrue:[
        "/ be careful: if the text has been edited/modified, do not compile
        textView modified ifTrue:[
            self breakPoint: #cg.
            self breakPoint: #jv.
            ^self.
        ] ifFalse:[
            "/ prepare to get reachable bpts
            self fixupBreakpointPositions.
            breakpoints do:[:bp | bp isReached:false].

            class := oldMethod mclass.
            class isNil ifTrue:[
                class := codeView classHolder value.
                class isNil ifTrue:[
                    self breakPoint:#jv.
                    Dialog warn:'oops - lost the methods''s class'.
                    ^ self.
                ]
            ].
            selector := oldMethod selector.

            Class withoutUpdatingChangesDo:[
                "/ compilerClass := ByteCodeCompilerWithBreakpointSupport.
                compilerClass := oldMethod programmingLanguage compilerWithBreakpointSupportClass.
                compilerClass isNil ifTrue:[
                    Dialog warn:'No breakpoint support for this programming language'.
                    ^ self.
                ].
                compiler := compilerClass new.
                compiler breakpoints:breakpoints.
"/ not needed - new compilers already know it
"/                compiler methodClass:(oldMethod programmingLanguage isSTXJavaScript 
"/                                            ifTrue:[JavaScriptFunctionWithBreakpoints]
"/                                            ifFalse:[MethodWithBreakpoints]).
                newMethod := compiler
                            compile:oldMethod source
                            forClass:class
                            inCategory:oldMethod category
                            notifying:nil
                            install:false
                            skipIfSame:false
                            silent:true
                            foldConstants:true
                            ifFail:[ Transcript showCR:'BreakpointService: failed to recompile for breakpoint' ].

                selector isNil ifTrue:[
                    "/ May happen as the selector is not stored in the method but
                    "/ searches through method's mclass methodDictionary.
                    "/ Following should be save as breakpoint is not installed when
                    "/ the code is modified...
                    selector := compiler selector.
                ].

                oldMethod isWrapped ifTrue:[
                    "/ update the wrapped method - do not install
                    newMethod originalMethod: oldMethod originalMethod.
                    oldMethod replaceOriginalMethodWith:newMethod.
                ] ifFalse:[
                    "/ install
                    newMethod originalMethod: oldMethod.
                    (class primAddSelector: selector withMethod:newMethod) ifFalse:[
                        oldMethod mclass:class.
                        self breakPoint: #cg.
                        self breakPoint: #jv.
                        ^ self
                    ].
                ].

                breakpoints := breakpoints species new.
                newMethod breakpointsDo:[ :each | each method:newMethod. breakpoints add: each ].
                self assert:(breakpoints isSortedBy:[:a :b |a position <= b position]).

                "/ must update breakpoints BEFORE the following, because it leads to a change
                "/ notification, which may clear the breakpoints collection!!
                self fetchMethodHolder value:newMethod.
                oldMethod mclass isNil ifTrue:[
                    "/ although this is not strictly true, not doing this
                    "/ would confuse a lot of other tools (such as the browser)
                    oldMethod mclass:class.
                ].
                class changed:#methodTrap with:selector. "/ tell browsers
                Smalltalk changed:#methodTrap with:(MethodTrapChangeNotificationParameter changeClass:class changeSelector:selector).
            ].
        ]
    ]

    "Created: / 05-07-2011 / 21:33:13 / cg"
    "Modified: / 23-02-2015 / 14:49:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-11-2016 / 19:14:34 / cg"
! !

!BreakpointService methodsFor:'queries'!

canCreateOrToggleBreakpointAtLine:lineOrNilForAnywhere
    "is it possible to place a breakpoint here and now?"

    |bpnt topView|

    textView reallyModified ifTrue:[
        "/ this is not really true - we could keep track of where the breakpoints
        "/ are while editing and shift them as required.
        "/ (another idea worth a try would be
        "/ to match the original parsetree (enumerating nodes with the breakpoints)
        "/ against the new parsetree (walking in sync?) when finally compiling,
        "/  and placing new breakpoints on matching tree nodes. 
        "/ (too much work, for a quick solution, I guess)
        ^ false
    ].

    "/ can always toggle existing breakpoints...
    lineOrNilForAnywhere notNil ifTrue:[
        bpnt := self breakpointAtLine:lineOrNilForAnywhere.
        bpnt notNil ifTrue:[
            ^ true.
        ]
    ] ifFalse:[
        (currentMethod notNil and:[currentMethod isMethodWithBreakpoints]) ifTrue:[
            ^ true.
        ]
    ].

    "/ ok, the method has no breakpoints yet.

    "/ this is a bad hack - looking into the debugger's state here.
    "/ I guess, we have to move code around a bit...
    ((topView := codeView topView) class == DebugView) ifTrue:[
        "/ can only create new breakpoints in the debugger,
        "/ iff we are in a wrapped method's prolog
        topView selectedContextIsWrapped ifTrue:[
            topView selectedContext lineNumber == 1 ifTrue:[
                ^ true
            ].
        ].

        "/ well, if the debugger's code has already been modified,
        "/ we will accept the new code anyway. So there's no problem in adding
        "/ a breakpoint on the fly...
        topView showingAlreadyModifiedCode ifTrue:[^ true].
        ^ false.
    ].

    "/ in a non-debugger, we can do it.
    ^  true.
!

hasBreakpoints
    ^ breakpoints notEmptyOrNil
! !

!BreakpointService methodsFor:'redrawing'!

drawLine:lineNo in:view atX:x y:yBaseline width:w height:hFont ascent:aFont
    from:startCol to:endColOrNil with:fg and:bg
    "Called by both gutterView and textView (well, not yet) to
     allow services to draw custom things on text view.
     Ask JV what the args means if unsure (I'm lazy to document
     them, now it is just an experiment...)"

    |mthd bpnt icon dx dy|

    "/ these tests make the breakpointService unusable for other applications 
    "/ (which are not based on smalltalk methods). 
    "/ They are not really needed: if there is a breakpoint,
    "/ I can show it. Period.

    "/    (mthd := self fetchMethodHolder value) isNil ifTrue:[
    "/        ^ self
    "/    ].
    "/    currentMethodClass isNil ifTrue:[
    "/        "/ hack: ouch - was wrapped in the meantime;
    "/        ^ self. "/ wait for the real update
    "/        "/ hurry up and update. Should be done elsewhere (in codeView)
    "/        "/ self updateCurrentMethod.
    "/    ].

    view == gutterView ifTrue:[
        bpnt := self breakpointAtLine:lineNo.
        bpnt isNil ifTrue:[
            ^ self
        ].
        icon := bpnt icon.
        icon isNil ifTrue:[
            ^ self
        ].
        dx := ((w - icon width) / 2) rounded.
        dy := ((hFont - icon height) / 2) rounded.
        icon
            displayOn:view
            x:x + dx
            y:yBaseline - hFont + dy + 4. "TODO: Magic constant"
    ].

    "Created: / 17-06-2011 / 13:52:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-07-2011 / 22:14:33 / cg"
! !

!BreakpointService methodsFor:'registering'!

registerIn:aCodeView
    super registerIn:aCodeView.
    self fetchMethodHolder.
! !

!BreakpointService methodsFor:'testing'!

isBreakpointService
    ^ true
! !

!BreakpointService class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

