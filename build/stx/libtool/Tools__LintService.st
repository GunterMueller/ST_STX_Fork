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

CodeViewService subclass:#LintService
	instanceVariableNames:'ruleHolderFromApp highlighter annotations
		annotationsSequenceNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Lint'
!

!LintService class methodsFor:'documentation'!

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
!

documentation
"
    cg:
    
    This service framework is a bit confusing; there is so much code duplication.
    The distinction between LintService and Smallsense::SmalltalkLintService is
    unclear to me.
    
    If I understand this correctly, this is used to highlight the
    output of the static analyzer (debug-button in browser), whereas Smallsense::SmalltalkLintService
    displays the output from the just-in-time analysis in the codeview
    Is this correct?
    Why not merge those two - most of the functionality is the same.     
"    
! !

!LintService class methodsFor:'accessing'!

label
    "Answers a short label - for UI"

    ^'SmallLint Checker'

    "Created: / 05-08-2011 / 11:01:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintService class methodsFor:'testing'!

isUsefulFor:aCodeView
    "this filters useful services.
     Redefined to return true for myself - not for subclasses"

    ^ self == Tools::LintService

    "Created: / 22-07-2013 / 14:01:38 / cg"
! !

!LintService methodsFor:'accessing'!

annotationAtLine: lineNo
    | anns |

    (anns := self annotations) notNil ifTrue:[ 
        ^ anns detect:[:annotation | annotation line = lineNo] ifNone:[nil]
    ].
    ^ nil

    "Created: / 30-01-2012 / 21:06:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 15:40:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotations
    #fixme. "/ code duplication with SmalltalkLintService >> annotations
    (highlighter notNil and:[ highlighter sequenceNumber ~~ annotationsSequenceNumber ]) ifTrue:[
        | rulesToIntervalsMap annotationsPerLineMap |

        rulesToIntervalsMap := highlighter rulesToIntervalsMap.
        rulesToIntervalsMap notNil ifTrue:[ 
            annotationsPerLineMap := Dictionary new.
            rulesToIntervalsMap keysAndValuesDo:[ :rule :intervals |
                intervals do:[:interval | 
                    | line annotation ruleAlready|

                    line := codeView lineOfCharacterPosition: interval first.
                    annotation := annotationsPerLineMap at: line ifAbsentPut:[ LintAnnotation new line: line ].
                    ruleAlready := annotation rule.
                    ruleAlready notNil ifTrue:[ 
                        ruleAlready isComposite ifTrue: [ 
                            (ruleAlready rules includes:rule) ifFalse:[
                                ruleAlready addRule:rule "rules add: rule"
                            ].
                        ] ifFalse:[
                            ruleAlready ~= rule ifTrue:[
                                annotation rule: (RBCompositeLintRule rules: (OrderedCollection with: ruleAlready with: rule))
                            ]
                        ]
                    ] ifFalse:[ 
                        annotation rule: rule
                    ].
                ].
            ].
            annotations := annotationsPerLineMap values sort:[ :a :b | a line < b line ].
            annotationsSequenceNumber := highlighter sequenceNumber.
        ]
    ].
    ^annotations

    "Created: / 15-12-2014 / 15:29:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 18:41:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxHighlighter
    | app rules |

    app := codeView application.
    app notNil ifTrue:[
        rules := self ruleHolderFromApp value.
        rules notEmptyOrNil ifTrue:[
            annotations := nil.
            highlighter rules: rules.
            ^ highlighter
        ].
    ].
    ^nil

    "Created: / 05-08-2011 / 10:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2012 / 01:23:48 / cg"
    "Modified: / 15-12-2014 / 20:22:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintService methodsFor:'aspects'!

ruleHolderFromApp
    "return/create the 'ruleHolderFromApp' value holder (automatically generated)"

    |app|

    ruleHolderFromApp isNil ifTrue:[
        (app := self application) notNil ifTrue:[
            self fetchLintRuleHolder
            "/ ruleHolderFromApp := ValueHolder new.
            "/ ruleHolderFromApp addDependent:self.
        ].
    ].
    ^ ruleHolderFromApp

    "Modified: / 08-03-2012 / 01:17:15 / cg"
!

ruleHolderFromApp:something
    "set the 'ruleHolderFromApp' value holder (automatically generated)"

    |oldValue newValue|

    ruleHolderFromApp notNil ifTrue:[
        oldValue := ruleHolderFromApp value.
        ruleHolderFromApp removeDependent:self.
    ].
    ruleHolderFromApp := something.
    ruleHolderFromApp notNil ifTrue:[
        ruleHolderFromApp addDependent:self.
    ].
    newValue := ruleHolderFromApp value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:ruleHolderFromApp.
    ].
! !

!LintService methodsFor:'change & update'!

update: aspect with: param from: sender
    aspect == #sizeOfView ifFalse:[
    aspect == #pointerInView ifFalse:[
        sender == ruleHolderFromApp ifTrue:[
            self syntaxHighlight: true.
            ^ self.
        ]
    ].
    ].
    super update: aspect with: param from: sender.

    "Created: / 05-08-2011 / 11:49:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2012 / 17:16:59 / cg"
! !


!LintService methodsFor:'initialization'!

initialize

    super initialize.

    highlighter := LintHighlighter new

    "Modified: / 03-09-2010 / 22:29:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 05-08-2011 / 11:53:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintService methodsFor:'private'!

syntaxHighlight: delayed

    | service |
    service := self service: #'Tools::CodeHighlightingService'.
    service notNil ifTrue:[
        service processSafely: delayed
    ].
    codeView updateScrollersViewBackground.

    "Created: / 05-08-2011 / 11:49:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2014 / 19:57:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintService methodsFor:'redrawing'!

drawLine:lineNo in:view atX:x y:yBaseline width:w height:hFont ascent:aFont from:startCol to:endColOrNil with:fg and:bg 
    "Called by both gutterView and textView (well, not yet) to
     allow services to draw custom things on text view.
     Ask JV what the args means if unsure (I'm lazy to document
     them, now it is just an experiment...)"

    "/ cg: why only for smalltalk?
    "/ if there are annotations, why not show it?
    "/ | lang |
    "/ ((lang := codeView language) isNil or:[lang isSmalltalk not]) ifTrue:[ ^ self ].

    self drawAnnotationInLine:lineNo 
         in:view atX:x y:yBaseline width:w height:hFont ascent:aFont 
         from:startCol to:endColOrNil with:fg and:bg
! !

!LintService methodsFor:'registering'!

fetchLintRuleHolder
    |app|

    app := self application.
    app notNil ifTrue:[
        "/ bad design; better idea would be to pass the lintRuleHolder back from the
        "/ application to me explicitely (in a postBuild method for some ruleCanvas of the app)
        (app respondsTo: #selectedLintRules) ifTrue:[
            self ruleHolderFromApp: app selectedLintRules
        ] ifFalse:[
            "/ self breakPoint:#jv.
            "/ Transcript showCR:'LintService [info]: app does not provide a lintRuleHolder'
        ]
    ].

    "Created: / 08-03-2012 / 01:16:38 / cg"
!

registerIn: aCodeView
    super registerIn: aCodeView.
    self fetchLintRuleHolder.

    "Modified: / 17-06-2011 / 13:07:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 05-08-2011 / 11:47:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2012 / 01:16:51 / cg"
! !

!LintService methodsFor:'testing'!

isLintService
    ^ true
! !

!LintService class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

