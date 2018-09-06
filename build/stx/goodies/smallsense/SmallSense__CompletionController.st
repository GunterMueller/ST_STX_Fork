"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2018 Jan Vrany

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

EditTextViewCompletionSupport subclass:#CompletionController
	instanceVariableNames:'support seqno'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core'
!

!CompletionController class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2018 Jan Vrany

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

!CompletionController class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!CompletionController methodsFor:'accessing'!

completionEngine
    | engineClass |

    engineClass := self completionEngineClass.
    ^ engineClass notNil 
        ifTrue:[ engineClass new ]
        ifFalse:[ nil ].

    "Created: / 18-05-2014 / 11:58:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editView
    ^ editView
!

environment
    ^ support notNil 
        ifTrue:[support environment]
        ifFalse:[Smalltalk].

    "Created: / 18-05-2014 / 11:53:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

support
    ^ support
!

support:anEditSupport
    support := anEditSupport.
! !

!CompletionController methodsFor:'accessing-classes'!

completionEngineClass
    ^ support notNil 
        ifTrue:[ support completionEngineClass ]
        ifFalse:[ nil ].

    "Created: / 18-05-2014 / 11:55:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionController methodsFor:'events'!

handleKeyPress:key x:x y:y

    key == #Control_L ifTrue:[
        completionView notNil ifTrue:[
            ^ false.
        ].
    ].

    key == #CodeCompletion  ifTrue: [
        autoSelect := true.    
        self startCompletionProcess.
        ^ true
    ].

    (key == #BackSpace or:[key == #BasicBackspace]) ifTrue:[
        | c |

        c := editView characterBeforeCursor.
        (c notNil and:[c isAlphaNumeric]) ifTrue:[
             ^ false
        ].
    ].     


    completionView notNil ifTrue:[
        (key == #Return and:[completionView hasSelection]) ifTrue:[
            self complete.
            ^ true.
        ].
        key == #Tab ifTrue:[ 
            self handleKeyPressTab.  
            ^ true
        ].
        key isCharacter ifTrue:[
            (self updateSelectionAfterKeyPress: key) ifTrue:[ 
                ^ true
            ].
        ].
    ].
    ^ super handleKeyPress:key x:x y:y

    "Created: / 27-09-2013 / 15:38:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-06-2014 / 10:17:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleKeyPressTab
    "Tab has been pressed, try to complete longest common prefix"

    | first prefix matching longest minlen |

    first := completionView list first.
    prefix := self prefixAlreadyWritten.
    matching := OrderedCollection new.
    minlen := SmallInteger maxVal.
    completionView list do:[:po |
        | s |

        s := po stringToComplete.
        (s startsWith: prefix) ifTrue:[
            matching add: po -> s.
            minlen := minlen min: s size.
        ].
    ].
    matching isEmpty ifTrue:[
        completionView flash.
        ^self.
    ].
    matching size == 1 ifTrue:[
        self complete: matching first key.
    ].

    longest := String streamContents:[:s |
        | i |

        s nextPutAll: prefix.
        i := prefix size + 1.
        [ i <= minlen ] whileTrue:[
            | c |

            c := matching first value at: i.
            (matching allSatisfy:[:e|(e value at: i) == c]) ifTrue:[
                s nextPut:c.
                i := i + 1.
            ] ifFalse:[
                "/ terminate the loop    
                i := minlen + 2.
            ]
        ]
    ].
    longest size = prefix size ifTrue:[
        completionView flash.
        ^self.
    ].
    editView insertStringAtCursor:(longest copyFrom: prefix size + 1).

    "Created: / 31-03-2014 / 22:55:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2014 / 13:55:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postKeyPress:key
    seqno := seqno + 1.
    seqno == SmallInteger maxVal ifTrue:[
        seqno := 0.
    ].

    UserPreferences current immediateCodeCompletion ifFalse:[
        "/ only update, if already open
        completionView isNil ifTrue:[^ self].
    ].

"/    (key == #BackSpace or:[key == #BasicBackspace]) ifTrue:[
"/        self closeCompletionView.
"/        ^ self
"/    ].

    key isCharacter ifTrue:[
        key isLetterOrDigit not ifTrue:[
            "/ Hack for Java - should be delegated to completion engine    
            (key == $. and:[support notNil and:[ support language isJavaLike ]]) ifTrue:[ 
                ^ self
            ].
            self closeCompletionView
        ] ifFalse:[
            | c |

            c := editView characterBeforeCursor.
            (c notNil and:[c isLetterOrDigit]) ifTrue:[
                c := editView characterUnderCursor.
                c isSeparator ifTrue:[
                    autoSelect := false.
                    self updateCompletionList.
                ].
            ]
        ].
        ^ self
    ].

    "Created: / 28-09-2013 / 00:21:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2014 / 13:53:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionController methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ support := nil.
    seqno := 0.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 02-05-2015 / 22:07:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionController methodsFor:'private'!

complete
    self complete: completionView selection.

    "Created: / 27-09-2013 / 15:38:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-03-2014 / 23:22:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

complete: item
    ^ self complete: item afterKeyPress: nil

    "Created: / 31-03-2014 / 23:21:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 14:53:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

complete: item afterKeyPress: keyOrNil
     self closeCompletionView.
     item insert.
     keyOrNil notNil ifTrue:[  
         support keyPressIgnored.
     ].

    "Created: / 11-08-2014 / 14:53:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prefixAlreadyWritten
    | list first |

    completionView notNil ifTrue:[ 
        list := completionView list.
        list notEmptyOrNil ifTrue:[ 
            first := list first.
            (completionView list allSatisfy:[:e | e class == first class ]) ifTrue:[ 
                ^ first stringAlreadyWritten 
            ]
        ]
    ].
    ^ support wordBeforeCursor string .

    "Created: / 18-05-2014 / 13:55:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 11:40:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stopCompletionProcess
    "kill any background completion process"

    editView sensor flushUserEventsFor: self.     
    super stopCompletionProcess

    "Created: / 02-10-2013 / 15:09:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-10-2013 / 11:03:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateCompletionList
    "called for keypress events"

    completionView isNil ifTrue:[
        super updateCompletionList
    ] ifFalse:[
         self updateSelection.
    ].

    "Created: / 27-09-2013 / 15:58:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-09-2013 / 00:15:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSelection
    "Updates selection in completion view based on currently typed partial 
     text. Return true if the complection window should be closed or false
     if it shall be kept open. "

    ^ self updateSelectionAfterKeyPress: nil

    "Created: / 27-09-2013 / 16:16:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 17-06-2014 / 07:24:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSelectionAfterKeyPress: keyOrNil
    "Updates selection in completion view based on currently typed partial 
     text. Return true if the complection window should be closed or false
     if it shall be kept open.

     If `keyOrNil` is not nil, then it's a key press that triggered the update
     which HAS NOT YET been processed by a `editView`.
     "

    | list prefix matcher1 matches1 matcher2 matches2 |

    list := completionView list.
    matcher1 := CompletionEngine exactMatcher.
    matcher2 := CompletionEngine inexactMatcher.
    prefix := self prefixAlreadyWritten.
    keyOrNil isCharacter ifTrue:[ 
        prefix := prefix , keyOrNil
    ].
    matches1 := list select:[:po | matcher1 value: prefix value: po stringToComplete ].
    matches1 notEmptyOrNil ifTrue:[
        matches1 size == 1 ifTrue:[
            | selection completeElectric |

            selection := matches1 anElement.
            completeElectric := (UserPreferences current smallSenseCompleteIfUnambiguous) and:[ support electricInsertSuppressed not ].
            (completeElectric and: [(editView sensor hasKeyEventFor:editView) not]) ifTrue:[
                self complete: selection afterKeyPress: keyOrNil.
                ^ true
            ] ifFalse:[ 
                completionView selection: selection
            ].
        ] ifFalse:[
            | selection |

            selection := matches1 inject: matches1 anElement into:[:mostrelevant :each |
                each relevance > mostrelevant relevance 
                    ifTrue:[each]
                    ifFalse:[mostrelevant]
            ].
            completionView selection: selection.
        ].
        ^ false
    ].

    matches2 := completionView list select:[:po | matcher2 value: prefix value: po stringToComplete ].
    matches2 notEmptyOrNil ifTrue:[
        matches2 size == 1 ifTrue:[
            completionView selection:  matches2 anElement.
        ] ifFalse:[
            | selection |

            selection := matches2 inject: matches2 anElement into:[:mostrelevant :each |
                each relevance > mostrelevant relevance 
                    ifTrue:[each]
                    ifFalse:[mostrelevant]
            ].
            completionView selection: selection.
        ]
    ] ifFalse:[
        completionView selection: nil.
    ].
    ^ false.

    "Created: / 17-06-2014 / 07:19:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2015 / 22:07:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionController methodsFor:'private-API'!

closeCompletionView
    |v|

    self stopCompletionProcess.
    (v := completionView) notNil ifTrue:[
        completionView := nil.
        "/ let it close itself - avoids synchronization problems
        v sensor
            pushUserEvent:#value
            for:[ v topView destroy ].
    ].

    "Created: / 02-10-2013 / 13:57:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2013 / 21:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeCompletions
    "Actually compute the completions and update the completion view."  

    | completions |

    editView sensor flushUserEventsFor: self.

    "/ Wait a while to give user chance finish typing.
    "/ This also reduces CPU consumption by avoiding
    "/ useless computation
    Delay waitForMilliseconds: 200. 

    completions := self computeCompletionsInContext.
    completions notEmptyOrNil ifTrue:[
        editView sensor pushUserEvent: #updateCompletions:sequence: for: self withArguments: (Array with: completions with: seqno)
    ].

    "Created: / 27-09-2013 / 13:12:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2014 / 11:50:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeCompletionsInContext
    | context |

    context := CompletionContext new.
    context environment: self environment.
    context support: support.
    ^self computeCompletionsInContext: context.

    "Created: / 18-05-2014 / 11:50:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

computeCompletionsInContext: aCompletionContext
    | engine |

    engine := self completionEngine.
    ^engine notNil 
        ifTrue:[ engine complete: aCompletionContext ]
        ifFalse:[ nil ]

    "Created: / 18-05-2014 / 11:53:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openCompletionView
    self openCompletionView: #()

    "Created: / 27-09-2013 / 16:17:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openCompletionView: list
    "Makes sure the completion view is opened and with given `list`."
    
    | movePos topView x y  windowExtent screenExtent |
    "/ move the window

    list isEmpty ifTrue:[ ^ self ].
    list = #( 'Busy...' ) ifTrue:[ ^ self ].  

    x := (editView xOfCol:editView cursorCol  inVisibleLine:editView cursorLine)
            - 16"icon" - (editView widthOfString:  "support wordBeforeCursor"list first stringAlreadyWritten) - 5"magic constant".
    y := editView yOfCursor + editView font maxHeight + 3.
    movePos := (editView originRelativeTo: nil) + (x @ y).

    completionView isNil ifTrue:[

        completionView := CompletionView new.
        completionView completionController: self.  
        completionView list:list.
        completionView font: editView font.
        topView := completionView.

        windowExtent := completionView extent copy.
        screenExtent := Screen current monitorBoundsAt: movePos.
        (screenExtent height) < (movePos y + windowExtent y) ifTrue:[
            movePos y: (movePos y - windowExtent y - editView font maxHeight - 5).
        ].
        topView origin:movePos.
        topView 
            bePopUpView;
            beSlave.
"/        topView resizeToFit.
        self updateSelection ifFalse:[
            topView openModal.
        ].
    ] ifFalse:[
        completionView list:list.
        self updateSelection.
"/        topView := completionView topView.
"/        topView ~~ completionView ifTrue:[
"/            topView origin:movePos.
"/            topView resizeToFit.
"/        ]
    ].

    "Created: / 27-09-2013 / 14:01:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-05-2014 / 11:30:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-03-2018 / 10:47:27 / jv"
!

updateCompletions: completionResult sequence: sequence
    seqno == sequence ifTrue:[
        self openCompletionView: completionResult 
    ].

    "Created: / 03-10-2013 / 07:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-10-2013 / 11:02:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionController class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

