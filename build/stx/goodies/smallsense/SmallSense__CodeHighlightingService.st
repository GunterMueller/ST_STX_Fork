"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2016 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

Tools::CodeHighlightingService subclass:#CodeHighlightingService
	instanceVariableNames:'lastLineFromChanged lastLineToChanged lastContentsList'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Services'
!

!CodeHighlightingService class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2016 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!CodeHighlightingService class methodsFor:'accessing'!

label
    "Answers a short label - for UI"

    ^'SmallSense - Code Highlighting'

    "Created: / 27-07-2013 / 22:46:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2013 / 10:27:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService methodsFor:'accessing'!

syntaxHighlighter
    | highlighter |

    highlighter := super syntaxHighlighter.
    highlighter == SyntaxHighlighter ifTrue:[
        ^ SmalltalkSyntaxHighlighter
    ].
    highlighter == SyntaxHighlighter2 ifTrue:[
        ^ SmalltalkSyntaxHighlighter
    ].
    ^ highlighter

    "Created: / 26-08-2013 / 09:26:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService methodsFor:'change & update'!

sourceChanged:force
    ^self sourceChanged: force from: nil to: nil.

    "Created: / 27-07-2013 / 22:52:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceChanged:force from:start to:end    
    "Called when codeview's text changes"

    (force or:[codeView reallyModified]) ifTrue:[
        (start notNil and: [end notNil and:[start > end]]) ifTrue:[
            lastLineFromChanged  := lastLineToChanged := nil.
        ] ifFalse:[
            lastLineFromChanged := start.
            lastLineToChanged := end.   
        ].
        self process
    ].

    "Created: / 27-07-2013 / 22:51:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-08-2013 / 13:00:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:aspect with:param from:sender
    "Invoked when an object that I depend upon sends a change notification."

    textView notNil ifTrue:[
        (sender == textView and:[aspect == #sizeOfContents]) ifTrue:[
"/            self halt.
"/            lastContentsList ~~ textView list ifTrue:[
"/                lastContentsList := textView list.
"/                self sourceChanged:true.
"/                textView instVarNamed: #suppressNotifications put: false.
"/            ].
            ^self.
        ].  
    ].
    super update:aspect with:param from:sender

    "Modified: / 03-08-2013 / 12:39:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService methodsFor:'event handling'!

linesDeletedFrom:start to:end 
    self sourceChanged:true from:start to:end

    "Created: / 27-07-2013 / 22:51:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 01:41:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesInsertedFrom:start to:end 
    self sourceChanged:true from:start to:end

    "Created: / 27-07-2013 / 22:51:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 01:41:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesModifiedFrom:start to:end 
    self sourceChanged:true from:start to:end

    "Created: / 27-07-2013 / 22:50:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService methodsFor:'initialization'!

initialize
    job := (Smalltalk at:#BackgroundQueueProcessingJob) 
                named:self defaultJobName
                on:[:interval |
                    Error handle:[:ex |
                        (Dialog confirm:('Error while processing source:\\',ex description,'\\Debug ?') withCRs)
                        ifTrue:[
                            ex reject.
                        ]
                    ] do:[
                        self process:true changed: interval
                    ]
                ].

    "Created: / 03-08-2013 / 11:08:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService methodsFor:'private'!

setHighlightedLine: line at: lineNr
    |firstShown lastShown anyChange replaceAction list|

    "textView" modified ifTrue:[
        "/ new input arrived in the meantime

        ^ self
    ].
"/    done ifFalse:[
"/        "/ another coloring process has already been started.
"/        "/ ignore this (leftover) code.
"/        ^ self
"/    ].

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
                                ].
                                textView redrawLine:lNr
                            ]
                        ]
                    ]
                ]
            ]
        ].
    list := textView list.  
    replaceAction value: lineNr value: line.
    gutterView invalidate.

"/    Transcript showCR:'--> rehighlighted ', self identityHash printString.

    "Created: / 03-08-2013 / 23:49:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2013 / 00:55:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService methodsFor:'processing'!

process
    "(Re)starts the processing job. Should be called whenever a source 
     must be (re)processed."

    | browser |

    (self syntaxHighlighters isEmptyOrNil) ifTrue:[
        "No higlighter, nothing to do"
        ^self
    ].   

    "/ this clobbers the codeViews modified state; therefore, we have to remember
    "/ this info somewhere ...
    (browser := codeView browser) notNil ifTrue:[
        textView modified ifTrue:[
            browser navigationState realModifiedState: true
        ].
        textView modifiedChannel setValue:false.
    ].

    ((lastLineFromChanged isNil and:[lastLineToChanged isNil]) 
        or:[lastLineFromChanged == 1 and:[lastLineToChanged == textView size]]) ifTrue:[
        job stopAndRemoveAll.
        job add: nil.
    ] ifFalse:[
        job add:(lastLineFromChanged to:lastLineToChanged).
    ]

    "Created: / 03-08-2013 / 11:07:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-08-2013 / 03:41:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process: delayed

    ^self process: delayed changed: nil.

    "Created: / 27-07-2013 / 22:53:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-08-2013 / 11:11:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process: delayed changed: interval

    |oldCode oldCodeList newCode newCodeList newCodeRefetch newCodeListRefetch elements cls mthd highlighters|

    done := false.
    modified := false.
    codeView syntaxElements: nil.
    codeView syntaxElementSelection: nil.

    highlighters := self syntaxHighlighters.

    cls := codeView klass.
    (cls notNil and:[cls isObsolete]) ifTrue:[
        cls isMeta ifTrue:[
            cls := (Smalltalk at:cls theNonMetaclass name) class
        ] ifFalse:[
            cls := Smalltalk at:cls name
        ].
    ].
    mthd := codeView methodHolder value.

    "textView" modified ifFalse:[
        oldCodeList := textView list copy.
        "/ Sometimes oldCodeList is not a string collection
        "/ but Array (usually with one nil element). In that case
        "/ #asStringWithoutEmphasis fails, so check & convert it here.
        (oldCodeList notNil and:[oldCodeList isStringCollection not]) ifTrue:[
            oldCodeList := oldCodeList asStringCollection.
        ].
        "textView" modified ifFalse:[
            oldCodeList notNil ifTrue:[
                oldCode := oldCodeList asStringWithoutEmphasis.
                "textView" modified ifFalse:[
                    Screen currentScreenQuerySignal answer:codeView device do:[
                        Parser parseErrorSignal handle:[:ex |
"/                            |errMsg|

"/                            errMsg := ex description asStringCollection first asString.

                            "/ Transcript topView raiseDeiconified.
                            "/ Transcript showCR:'ParseError: ', ex description.
"/ self halt.
                            "/ self showInfo:(errMsg colorizeAllWith:Color red).
                            newCode := nil.
                        ] do:[
                            | codeAspect |
                            
                            elements := ParseTreeIndex new.
                            codeAspect := codeView codeAspect.

                            "/ switch codeAspect
                            "/ case method
                                codeAspect == SyntaxHighlighter codeAspectMethod ifTrue:[
                                    (interval notNil and:[interval size == 1 and:[highlighters first respondsTo:#formatMethod:source:line:number:in:using:]]) ifTrue:[
                                        newCodeList := oldCodeList.
                                        newCode := newCodeList asString.
                                    ] ifFalse:[
                                        newCodeList := oldCode asStringCollection.
                                        newCode := oldCode asText. 
                                    ].
                                    newCodeListRefetch := [].
                                    newCodeRefetch := [].
                                    highlighters do:[:h|
                                        (interval notNil and:[h respondsTo:#formatMethod:source:line:number:in:using:]) ifTrue:[
                                            newCodeListRefetch value.   
                                            interval do:[:lnr |
                                                | ln |

                                                ln := newCodeList at: lnr ifAbsent:[nil].
                                                ln notEmptyOrNil ifTrue:[
                                                    | nln |

                                                    nln := h formatMethod:mthd source:newCode line: ln string number: lnr in:cls using:syntaxPreferences.
                                                    nln ~~ ln ifTrue:[
                                                        delayed ifTrue:[
                                                            codeView sensor 
                                                                pushUserEvent:#setHighlightedLine:at:
                                                                for:self
                                                                withArguments:(Array with:nln with: lnr).                                                                                                                                                                                                                     
                                                        ] ifFalse:[
                                                           self setHighlightedLine: nln at: lnr.
                                                        ].
                                                        newCodeList at: lnr put: nln.
                                                       newCodeListRefetch := [].
                                                       newCodeRefetch := [ newCode := newCodeList asString. newCodeListRefetch := [] ].   
                                                    ]
                                                ]
                                            ].

                                        ] ifFalse:[
                                            newCodeRefetch value.
                                            newCode := h formatMethod:mthd source:newCode in:cls using:syntaxPreferences elementsInto: elements.
                                            newCodeListRefetch := [ newCodeList := newCode asStringCollection. newCodeRefetch := [] ].
                                            newCodeRefetch := [  ].
                                        ].
                                    ].
                                ] ifFalse:[
                            "/ case expession
                                codeAspect == (SyntaxHighlighter codeAspectExpression) ifTrue:[
                                    newCodeList := oldCode asStringCollection.
                                    newCode := oldCode asText.
                                    highlighters do:[:h|
                                        newCodeRefetch value.
                                        newCode := h formatExpression:newCode in:cls elementsInto: elements.
                                        newCodeListRefetch := [ newCodeList := newCode asStringCollection. newCodeRefetch := [] ].
                                        newCodeRefetch := [  ].
                                    ].
                                ] ifFalse:[
                            "/ case statements
                                codeAspect == (SyntaxHighlighter codeAspectStatements) ifTrue:[
                                    newCodeList := oldCode asStringCollection.
                                    newCode := oldCode asText.
                                    highlighters do:[:h|
                                        (h respondsTo:#formatStatements:in:elementsInto:) ifTrue:[ 
                                            newCodeRefetch value.
                                            newCode := h formatStatements:newCode in:cls elementsInto: elements.
                                            newCodeListRefetch := [ newCodeList := newCode asStringCollection. newCodeRefetch := [] ].
                                            newCodeRefetch := [  ].
                                        ]
                                    ].

                                ] ifFalse:[
                            "/case class definition
                               codeView codeAspect == #classDefinition ifTrue:[
                                    (interval notNil and:[highlighters first respondsTo:#formatClassDefinition:line:number:in:]) ifTrue:[
                                         newCodeList := oldCodeList.
                                         newCode := newCodeList asString.
                                    ] ifFalse:[
                                         newCodeList := oldCode asStringCollection.
                                         newCode := oldCode asText. 
                                    ].
                                    newCodeListRefetch := [].
                                    newCodeRefetch := [].

                                    highlighters do:[:h|
                                       (interval notNil and:[h respondsTo:#formatClassDefinition:line:number:in:]) ifTrue:[
                                            newCodeListRefetch value.
                                            interval do:[:lnr |
                                                | ln |

                                                ln := oldCodeList at: lnr ifAbsent:[nil].
                                                ln notEmptyOrNil ifTrue:[
                                                    | nln |

                                                    nln := h formatClassDefinition:newCode line: ln string number: lnr in:cls.
                                                    nln ~~ ln ifTrue:[
                                                        delayed ifTrue:[
                                                            codeView sensor 
                                                                pushUserEvent:#setHighlightedLine:at:
                                                                for:self
                                                                withArguments:(Array with:nln with: lnr).                                                                                                 
                                                       ] ifFalse:[
                                                           self setHighlightedLine: nln at: lnr.
                                                       ].
                                                       newCodeList at: lnr put: nln.
                                                       newCodeListRefetch := [].
                                                       newCodeRefetch := [ newCode := newCodeList asString. newCodeListRefetch := [] ].   
                                                    ]
                                                ]
                                            ].
                                        ] ifFalse:[
                                            newCodeRefetch value.
                                            newCode := h formatClassDefinition:newCode in:cls elementsInto: elements.
                                            newCodeListRefetch := [ newCodeList := newCode asStringCollection. newCodeRefetch := [] ].
                                            newCodeRefetch := [  ].
                                        ]
                                   ].
                               ]]]].
                        ]
                    ].
                    newCode notNil ifTrue:[
                        "textView" modified ifFalse:[
                            newCode ~= oldCodeList ifTrue:[
                                | newCodeText |

                                newCodeText := newCode.
                                newCode := newCode asStringCollection.
                                "textView" modified ifFalse:[
                                    done := true.
                                    elements source: newCodeText.
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
                                        ]
                                    ]
                                ]
                            ].
                        ]
                    ]
                ] "/ ---
            ]
        ]
    ]

    "Created: / 03-08-2013 / 11:11:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2016 / 21:08:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeHighlightingService class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

