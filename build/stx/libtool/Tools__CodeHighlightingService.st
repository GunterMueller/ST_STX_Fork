"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2016 Jan Vrany
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

BackgroundSourceProcessingService subclass:#CodeHighlightingService
	instanceVariableNames:'syntaxPreferences'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

!CodeHighlightingService class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2016 Jan Vrany
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

!CodeHighlightingService class methodsFor:'accessing'!

label
    "Answers a short label - for UI"

    ^'Syntax Highlighting'

    "Created: / 07-03-2010 / 14:00:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService class methodsFor:'testing'!

isUsefulFor:aCodeView
    "this filters useful services.
     Redefined to return true for myself - not for subclasses"

    ^ self == Tools::CodeHighlightingService

    "Created: / 22-07-2013 / 14:00:54 / cg"
! !

!CodeHighlightingService methodsFor:'accessing'!

preferences:preferences
    "must be able to set those - otherwise, it uses a different coloring scheme in
     expecco"

    syntaxPreferences := preferences.
!

syntaxHighlighter
    | app lang highlighter |

    "First, ask application..."
    app := codeView application.
    app notNil ifTrue:[
        | mthd class |

        mthd := codeView method.
        (mthd notNil and:[app respondsTo: #syntaxHighlighterForMethod:]) ifTrue:[
            highlighter := app syntaxHighlighterForMethod:mthd.
        ] ifFalse:[
            class := codeView classHolder value.
            (class notNil and:[app respondsTo: #syntaxHighlighterForClass:]) ifTrue:[                        
                highlighter := app syntaxHighlighterForClass: class.
            ] ifFalse:[
                (app respondsTo: #syntaxHighlighter) ifTrue:[                        
                    highlighter := app syntaxHighlighter.
                ].
            ].
        ]
    ].
    "App did not provide any highlighter..."
    highlighter isNil ifTrue:[        
        highlighter := (lang := codeView language) isNil
                        ifTrue:[nil]
                        ifFalse:[lang syntaxHighlighterClass].
    ].
    "HACK!!!!!!"
    highlighter == SyntaxHighlighter ifTrue:[
        highlighter := SyntaxHighlighter2
    ].
    ^ highlighter

    "Created: / 05-08-2011 / 10:48:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-07-2013 / 13:33:46 / cg"
    "Modified: / 10-06-2014 / 17:58:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxHighlighters

    | highlighters highlighter |

    highlighters := OrderedCollection new: 4.
    highlighter := self syntaxHighlighter.
    highlighter notNil ifTrue:[
        "/ cg: who sets this highlighter when adding a subclass to one of the expecco codeDescriptions?
        "/ highlighter class == Workflow::ExecutionEditorShellScript::NaiveShellScriptSyntaxHighlighter ifTrue:[self halt].
        "/ highlighter  == Workflow::ExecutionEditorShellScript::NaiveShellScriptSyntaxHighlighter ifTrue:[self halt].
        highlighters add: highlighter 
    ].

    codeView servicesDo:[:service|
        service ~~ self ifTrue:[
            highlighter := service syntaxHighlighter.        
            highlighter notNil ifTrue:[
                "/ cg: who sets this highlighter when adding a subclass to one of the expecco codeDescriptions?
                "/ highlighter class == Workflow::ExecutionEditorShellScript::NaiveShellScriptSyntaxHighlighter ifTrue:[self halt].
                "/ highlighter  == Workflow::ExecutionEditorShellScript::NaiveShellScriptSyntaxHighlighter ifTrue:[self halt].
                highlighters add: highlighter
            ].
        ]
    ].
    ^highlighters

    "Created: / 05-08-2011 / 10:49:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-07-2012 / 12:58:48 / cg"
    "Modified: / 27-11-2014 / 15:42:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService methodsFor:'accessing-defaults'!

defaultJobName

    ^'CodeView2''s syntax highlighting job'

    "Created: / 24-01-2012 / 12:06:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService methodsFor:'private'!

clearScrollbarBackground
    "/ immediate change the scroller back to showing nothing;
    "/ will get new info, when the highlighter is finished.

    |scroller|

    codeView notNil ifTrue:[
        scroller := textView superView verticalScrollBar thumb.
        scroller shown ifTrue:[
            scroller
                initStyle ;
                invalidateRepairNow:true.
        ]
    ].    
!

process
    "(Re)starts the processing job. Should be called whenever a source 
     must be (re)processed."

    | highlighters |

    (highlighters := self syntaxHighlighters) isEmptyOrNil ifTrue:[
        "No higlighter, nothing to do"
        ^self
    ].

    super process.

    "Modified: / 07-07-2011 / 12:26:12 / Jan Vrany <jan.vrant@fit.cvut,cz>"
    "Modified: / 26-09-2011 / 15:40:23 / cg"
    "Created: / 24-01-2012 / 12:11:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process: delayed

    |oldCode oldCodeList newCode elements cls mthd highlighterClasses|
"/    codeView topView class == DebugView ifTrue:[^ self].

    done := false.
    modified := false.
    codeView syntaxElements: nil.
    codeView syntaxElementSelection: nil.

    highlighterClasses := self syntaxHighlighters.

    cls := codeView klass.
    (cls notNil and:[cls isObsolete]) ifTrue:[
        cls isMeta ifTrue:[
            cls := (Smalltalk at:cls theNonMetaclass name) class
        ] ifFalse:[
            cls := Smalltalk at:cls name
        ].
    ].
    mthd := codeView method.

    "textView" modified ifFalse:[
        "/ bad bad bad: textView's list may change, while we copy!!!!!!!!!!
        [
            oldCodeList := textView list copy.
        ] valueUninterruptably.

        "textView" modified ifFalse:[
            oldCodeList isNil ifFalse:[
                oldCode := oldCodeList asStringCollection asStringWithoutEmphasis.
                "textView" modified ifFalse:[
                    Screen currentScreenQuerySignal answer:codeView device
                    do:[
                        "/ cg: not a good idea to handle it here;
                        "/ Syntaxhighlighter does it also, and will generate a better colorized string
"/                        Parser parseErrorSignal handle:[:ex |
"/                            |errMsg|
"/
"/                            errMsg := ex description asStringCollection first asString.
"/
"/                            "/ Transcript topView raiseDeiconified.
"/                            Transcript showCR:'Error caught: ', ex description.
"/                            "/ self halt.
"/                            "/ self showInfo:(errMsg colorizeAllWith:Color red).
"/                            newCode := nil.
"/                        ] do:[
                            | codeAspect |
                            
                            elements := ParseTreeIndex new.
                            newCode := oldCode asText.
                            codeAspect := codeView codeAspect.
                            codeAspect == SyntaxHighlighter codeAspectMethod ifTrue:[
                                highlighterClasses do:[:e|newCode := e formatMethod:mthd source:newCode in:cls using:syntaxPreferences elementsInto: elements].
                            ] ifFalse:[
                                codeAspect == (SyntaxHighlighter codeAspectExpression) ifTrue:[
                                    highlighterClasses do:[:e|newCode := e formatExpression:newCode in:cls elementsInto: elements].
                                ] ifFalse:[
                                    codeAspect == (SyntaxHighlighter codeAspectClassDefinition) ifTrue:[
                                        highlighterClasses do:[:e|newCode := e formatClassDefinition:newCode string in:cls elementsInto: elements].
                                    ] ifFalse:[ 
                                        codeAspect == (SyntaxHighlighter codeAspectStatements) ifTrue:[
                                            highlighterClasses do:[:e|newCode := e formatStatements:newCode string in:cls elementsInto: elements].
                                        ]        
                                    ].
                                ].
                            ].
"/                        ]
                    ].
                    newCode notNil ifTrue:[
                        "textView" modified ifFalse:[
                            newCode ~= oldCodeList ifTrue:[
                                newCode := newCode asStringCollection.
                                "textView" modified ifFalse:[
                                    done := true.
                                    textView notNil ifTrue:[
                                        "/ must add this event - and not been interrupted
                                        "/ by any arriving key-event.
                                        "/ self showInfo:nil.
                                        delayed ifTrue:[
                                            codeView sensor
                                                pushUserEvent:#setHighlightedCode:elements:
                                                for:self
                                                withArguments:(Array with:newCode with: elements).
                                                "/self delayedUpdateBufferLabelWithCheckIfModified
                                        ] ifFalse:[
                                            textView contents: newCode.
                                            codeView syntaxElements: elements.
                                            gutterView invalidate.
                                            codeView updateScrollersViewBackground.
                                        ]
                                    ]
                                ]
                            ].
                        ]
                    ]
                ]
            ]
        ]
    ]

    "Created: / 24-01-2012 / 12:21:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-07-2013 / 13:33:40 / cg"
    "Modified: / 22-02-2016 / 21:00:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setHighlightedCode:newCode elements: elements
    "the background synhighlighter has generated new colored text,
     with highlighted syntax.
     If there have been no modifications in the meantime, install it."

    |firstShown lastShown cursorWasOn anyChange newLines l replaceAction list|

    "/ It may happen that service is unregistered while
    "/ an user event for #setHighlightedCode:elements: is already in
    "/ an event queue but not yet processed. To handle this situation.
    "/ check if textView is nil (which is in case the service is unregistered)
    textView isNil ifTrue:[ ^ self ].


    modified ifTrue:[ 
        "/ a new input arrived in the meantime
        ^ self 
    ].

    done ifFalse:[
        "/ another coloring process has already been started.
        "/ ignore this (leftover) code.
        ^ self
    ].

    firstShown := textView firstLineShown.
    lastShown := textView lastLineShown.

    replaceAction := [:lNr :line |
            |oldLine|

            oldLine :=  list at:lNr ifAbsent:nil.
            oldLine notNil ifTrue:[
                line notNil ifTrue:[
                    "/ this check is needed - there is a race
                    "/ when the text is converted. This detects the
                    "/ resulting error.
                    "/ Certainly a kludge.

                    oldLine string = line string ifTrue:[
                        | i |

                        "JV@2012-02-01: Remove any emphasis on leading whitespace"
                        "(presumably created by LintHighlighter)"
                        i := line string indexOfNonSeparator.
                        i > 1 ifTrue:[
                            | e |

                            (e := (line emphasisAt: i - 1)) notNil ifTrue:[
                                line emphasisFrom: 1 to: i - 1 remove: e.
                            ]
                        ].

                        oldLine emphasis ~= line emphasis ifTrue:[
                            textView modifiedChannel removeDependent:self.
                            list at:lNr put:line.
                            textView modifiedChannel addDependent:self.
                            (lNr between:firstShown and:lastShown) ifTrue:[
                                anyChange ifFalse:[
                                    anyChange := true.
                                    cursorWasOn := textView hideCursor
                                ].
                                textView redrawLine:lNr
                            ]
                        ]
                    ]
                ]
            ]
        ].

    anyChange := false.
    newLines := newCode asStringCollection.
    list := textView list.
    list isNil ifTrue:[
        textView list:newLines.
    ] ifFalse:[
        "/ the cursor line first - that's where your eyes are ...
        ((l := textView cursorLine) notNil and:[l between: 1 and: newLines size]) ifTrue:[
            l <= newLines size ifTrue:[
                replaceAction value:l value:(newLines at:l)
            ]
        ].
        newLines keysAndValuesDo:replaceAction.
        anyChange ifTrue:[
            cursorWasOn ifTrue:[
                textView showCursor
            ]
        ]
    ].
    codeView syntaxElements: elements.
    gutterView invalidate.
    codeView updateScrollersViewBackground.
    
"/    Transcript showCR:'--> rehighlighted ', self identityHash printString.

    "Modified: / 09-10-2006 / 11:50:17 / cg"
    "Created: / 14-02-2010 / 16:10:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 21-08-2011 / 09:38:22 / cg"
    "Modified: / 01-02-2012 / 19:18:00 / jv"
    "Modified: / 20-01-2015 / 15:17:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

