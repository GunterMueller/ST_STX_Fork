"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2014 Claus Gittinger
 COPYRIGHT (c) 2015 Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

Tools::BackgroundSourceProcessingService subclass:#SmalltalkLintService
	instanceVariableNames:'rulesHolder rules highlighter support annotations
		annotationsSequenceNumber annotationsPerLine'
	classVariableNames:'Debugging'
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Lint'
!

!SmalltalkLintService class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2014 Claus Gittinger
 COPYRIGHT (c) 2015 Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SmalltalkLintService class methodsFor:'accessing'!

debugging
    ^Debugging == true

    "Created: / 17-02-2012 / 00:48:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debugging: aBoolean

    Debugging := aBoolean

    "Created: / 16-02-2012 / 16:22:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    "Answers short label - for UI"

    ^'SmallSense - Static Checking'

    "Created: / 07-03-2010 / 14:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2013 / 22:36:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

priority
    "Answers a priority of the service. Services with higher priority
     will get the event notification before ones with lower priority.
     Therefore, a lower-priority service might not get the event if high
     priority service processes it"

    ^ 10

    "Created: / 01-02-2012 / 10:29:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkLintService class methodsFor:'queries'!

isUsefulFor:aCodeView
    "this filters useful services.
     must be redefined to return true in subclasses (but each class must do it only
     for itself - not for subclasses"

    ^ self == SmalltalkLintService

    "Created: / 24-07-2013 / 11:35:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-09-2013 / 15:26:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkLintService class methodsFor:'testing'!

isAvailable

    ^UserPreferences current smallSenseEnabled

    "Created: / 04-02-2012 / 22:20:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkLintService methodsFor:'accessing'!

annotationAtLine: lineNo
    | anns |

    (anns := self annotations) notNil ifTrue:[ 
        ^ annotationsPerLine at: lineNo ifAbsent:[nil].
        ^ anns detect:[:annotation | annotation line = lineNo] ifNone:[ nil ]
    ].
    ^ nil

    "Created: / 30-01-2012 / 21:06:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 15:40:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotations
    (highlighter notNil and:[ highlighter sequenceNumber ~~ annotationsSequenceNumber ]) ifTrue:[ 
        | rulesToIntervalsMap annotationsPerLineMap |

        rulesToIntervalsMap := highlighter rulesToIntervalsMap.
        rulesToIntervalsMap notNil ifTrue:[ 
            annotationsPerLineMap := Dictionary new.
            rulesToIntervalsMap keysAndValuesDo:[ :rule :intervals |
                intervals do:[:interval | 
                    | line annotation r |

                    line := codeView lineOfCharacterPosition: interval first.
                    annotation := annotationsPerLineMap at: line ifAbsentPut:[ Tools::LintAnnotation new line: line ].
                    (r := annotation rule) notNil ifTrue:[ 
                        r isComposite 
                            ifTrue: [ r addRule:rule "rules add: rule" ]
                            ifFalse:[ annotation rule: (RBCompositeLintRule rules: (OrderedCollection with: r with: rule))]
                    ] ifFalse:[ 
                        annotation rule: rule
                    ].
                ].
            ].
            annotationsPerLine := annotationsPerLineMap.
            annotations := annotationsPerLineMap values sort:[ :a :b | a line < b line ].
            annotationsSequenceNumber := highlighter sequenceNumber.
        ]
    ].
    ^annotations

    "Created: / 15-12-2014 / 15:29:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 19:00:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxHighlighter

    ^highlighter

    "Created: / 05-08-2011 / 10:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkLintService methodsFor:'aspects'!

rulesHolder
    "return/create the 'rulesHolder' value holder (automatically generated)"

    rulesHolder isNil ifTrue:[
        rulesHolder := ValueHolder new.
        rulesHolder addDependent:self.
    ].
    ^ rulesHolder
!

rulesHolder:something
    "set the 'rulesHolder' value holder (automatically generated)"

    |oldValue newValue|

    rulesHolder notNil ifTrue:[
        oldValue := rulesHolder value.
        rulesHolder removeDependent:self.
    ].
    rulesHolder := something.
    rulesHolder notNil ifTrue:[
        rulesHolder addDependent:self.
    ].
    newValue := rulesHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:rulesHolder.
    ].
! !

!SmalltalkLintService methodsFor:'change & update'!

sourceChanged:force
    | lang |

    annotations := annotationsPerLine := nil.

    rules isNil ifTrue:[ ^ self ].
    rules resetResult.
    ((lang := codeView language) isNil or:[lang isSmalltalk not]) ifTrue:[ ^ self ].

    super sourceChanged:force.

    "Created: / 18-02-2012 / 22:50:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 19:00:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == rulesHolder ifTrue:[
        UserPreferences current smallSenseBackgroundLintEnabled ifTrue:[
            | rulesHierarchical ruleList disabledRules |

            "/xxxx
            rulesHierarchical := rulesHolder value.
            rulesHierarchical notNil ifTrue:[
                disabledRules := SmalltalkChecker forceDisabledRules.
                ruleList := rulesHierarchical flattened reject:[:each| disabledRules includes: each class name].
                ruleList := ruleList collect:[ :e | e class new ].
                rules := RBCompositeLintRule rules: ruleList.
                highlighter rules: ruleList.
                self process.
            ].
        ].
        ^ self.
    ].

    super update:something with:aParameter from:changedObject

    "Modified (format): / 16-10-2014 / 23:20:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkLintService methodsFor:'event handling'!

buttonPress:button x:x y:y in:view 
    |lineNr|

    rules isNil ifTrue:[
        ^ false
    ].
    view == gutterView ifTrue:[
        button == 1 ifTrue:[
            lineNr := textView yVisibleToLineNr:y.
            lineNr notNil ifTrue:[ 
                ^ self showInfoWindowForLine: lineNr 
            ].
            ^ false.
        ].
    ].
    ^ false

    "Created: / 30-01-2012 / 21:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

viewRealized

    | browser |

    UserPreferences current smallSenseBackgroundLintEnabled ifFalse:[ ^ self ].

    (browser := codeView browser) notNil ifTrue:[
        browser navigationState canvasType ~~ #smallLintByRuleResultBrowserSpec ifTrue:[
            self rulesHolder: (browser perform:#smalllintRulesOrDefaultHolder ifNotUnderstood:[browser smalllintRulesOrAllHolder])
        ].
    ].

    "Created: / 23-01-2012 / 10:43:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2013 / 22:43:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkLintService methodsFor:'initialization'!

initialize

    super initialize.

    highlighter := Tools::LintHighlighter new.

    "Created: / 05-08-2011 / 11:53:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-12-2014 / 09:38:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkLintService methodsFor:'private'!

process
    "(Re)starts the processing job. Should be called whenever a source 
     must be (re)processed."

    rules isNil ifTrue:[
        ^self
    ].

    ^super process.

    "Created: / 24-01-2012 / 12:43:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process: delayed
    "Do the real source processing. If delayed is true, actuall data update must
     be done within the event queue using #pushUserEvent:...
    "
    |lang cls env oldCodeList oldCode |

    rules isNil ifTrue:[ ^ self ].

    codeView codeAspect ~~ #method ifTrue:[ ^ self ].
    (lang := codeView language) isNil ifTrue: [ ^ self ].
    lang isSmalltalk ifFalse: [ ^ self ]. 
    done := false.
    modified := false.

    cls := codeView klass.
        cls isNil ifTrue:[^ self ].    


    Delay waitForMilliseconds: 200."Give user some time to write"

    (cls notNil and:[cls isObsolete]) ifTrue:[
        cls isMeta ifTrue:[
            cls := (Smalltalk at:cls theNonMetaclass name) class
        ] ifFalse:[
            cls := Smalltalk at:cls name
        ].
    ].

    "textView" modified ifFalse:[
        oldCodeList := textView list copy.
        oldCodeList isEmptyOrNil ifTrue: [ ^ self ].
        "textView" modified ifFalse:[
            oldCodeList isNil ifFalse:[
                oldCode := oldCodeList asStringWithoutEmphasis.
                oldCode isEmptyOrNil ifTrue:[ ^ self ].
                "textView" modified ifFalse:[
                    Screen currentScreenQuerySignal answer:codeView device
                    do:[
                        Error handle:[:ex |
                            | errMsg |

                            Debugging == true ifTrue:[
                                Debugging := false.    
                                ex pass.
                            ].

"/                            Transcript topView raiseDeiconified.
"/                            Transcript showCR:'ParseError: ', ex description.
                            errMsg := ex description asStringCollection first asString.
                            self showInfo:(('Smalltalk Lint: ',errMsg) colorizeAllWith:Color red).
                        ] do:[
                            env := (SmallSense::SmalltalkUnacceptedMethodEnvironment onClass:cls methodSource: oldCode).
"/ Transcript showCR:rules.
"/ Transcript showCR:rules rules.
                            SmalltalkChecker runRule: rules onEnvironment: env
                        ].
                        delayed ifTrue:[
                            codeView sensor pushUserEvent:#rehighlight: for:self withArgument: true.
                        ] ifFalse:[
                            self rehighlight: true.
                        ]
                    ]
                ]
            ]
        ]
    ]

    "Created: / 24-01-2012 / 12:44:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-10-2014 / 01:10:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rehighlight: delayed
    | service |

    service := self service: SmallSense::CodeHighlightingService name.
    service isNil ifTrue:[
        service := self service: Tools::CodeHighlightingService name
    ].
    service notNil ifTrue:[
        service sourceChanged: true.
    ]

    "Created: / 27-01-2012 / 17:06:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-12-2014 / 19:00:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showInfoWindowForLine: lineNo
    | ann |

    ann := self annotationAtLine: lineNo.
    ann isNil ifTrue:[ ^ false ].

    codeView topView beMaster.

    CriticsWindow new
        rule: ann rule;
        codeView: codeView;
        allButOpen;
        "/ openWindowAt: (Screen current pointerPosition - (20@20)).
        openWindowAs:#popUp at: (Screen current pointerPosition - (20@20)).

    ^true

    "Created: / 30-01-2012 / 21:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkLintService methodsFor:'redrawing'!

drawLine:lineNo in:view atX:x y:yBaseline width:w height:hFont ascent:aFont 
    from:startCol to:endColOrNil with:fg and:bg
    "Called by both gutterView and textView (well, not yet) to
     allow services to draw custom things on text view.
     Ask JV what the args means if unsure (I'm lazy to document
     them, now it is just an experiment...)"

    "/ | lang |
    "/ ((lang := codeView language) isNil or:[lang isSmalltalk not]) ifTrue:[ ^ self ].

    (UserPreferences current smallSenseBackgroundLintEnabled == true) ifFalse:[ ^ self ].

    self drawAnnotationInLine:lineNo 
         in:view atX:x y:yBaseline width:w height:hFont ascent:aFont 
         from:startCol to:endColOrNil with:fg and:bg
! !

!SmalltalkLintService methodsFor:'registering'!

unregister
    super unregister.
    rulesHolder removeDependent: self.

    "Created: / 14-10-2014 / 22:40:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkLintService class methodsFor:'documentation'!

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

