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
"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

Tools::BackgroundSourceProcessingService subclass:#JavaLintService
	instanceVariableNames:'highlighter showingJava'
	classVariableNames:'Debugging'
	poolDictionaries:''
	category:'Languages-Java-Tools-Editor-Lint'
!

!JavaLintService class methodsFor:'documentation'!

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

!JavaLintService class methodsFor:'accessing'!

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

    ^'Java - Static Checking'

    "Created: / 07-03-2010 / 14:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2013 / 10:01:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

priority
    "Answers a priority of the service. Services with higher priority
     will get the event notification before ones with lower priority.
     Therefore, a lower-priority service might not get the event if high
     priority service processes it"

    ^ 10

    "Created: / 01-02-2012 / 10:29:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService class methodsFor:'queries'!

isUsefulFor:aCodeView
    "this filters useful services.
     must be redefined to return true in subclasses (but each class must do it only
     for itself - not for subclasses"

    ^ (self == JavaLintService)

    "Created: / 24-07-2013 / 11:35:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-08-2014 / 06:53:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService class methodsFor:'testing'!

isAvailable

    ^UserPreferences current smallSenseEnabled

    "Created: / 04-02-2012 / 22:20:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService methodsFor:'accessing'!

syntaxHighlighter
    "Returns a syntax highligter class or nil. The highlighting
     process gather all syntaxHighlighterClasses from all services
     and then use them one by one to highlight the text. Individual
     services may override this method to provide additional
     highliging of the source code"

    ^ showingJava
        ifTrue: [ highlighter ]
        ifFalse: [ nil ]

    "Created: / 05-08-2011 / 10:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 00:33:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService methodsFor:'change & update'!

sourceChanged: aBoolean
    modified := true.
    super sourceChanged: aBoolean

    "Created: / 07-08-2014 / 01:10:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    textView notNil ifTrue:[ 
        (changedObject == textView and:[something == #sizeOfContents]) ifTrue:[
            modified := true.
            ^self.
        ].
        (modified and:[changedObject == textView cursorLineHolder]) ifTrue:[ 
            self process.
        ].
    ].

    changedObject == codeView ifTrue:[
        (#(methodHolder classHolder languageHolder) includes: something) ifTrue:[
            aParameter key removeDependent: self.
            aParameter value addDependent: self.                         
        ].
    ].

    (changedObject == codeView languageHolder 
        or:[changedObject == codeView classHolder
        or:[changedObject == codeView methodHolder]]) ifTrue:[
        | lang |

        lang := codeView language.
        showingJava := JavaCompiler notNil and:[lang notNil and:[lang isJava]].
        ^ self
    ].    

    super update:something with:aParameter from:changedObject

    "Modified: / 07-08-2014 / 01:18:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService methodsFor:'event handling'!

buttonPress:button x:x y:y in:view 
    |lineNr|

    showingJava ifFalse:[ ^ false ].

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
    "Modified: / 21-10-2013 / 15:12:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesModifiedFrom:start to:end
    showingJava ifTrue:[ 
        (end - start) == 0 ifTrue:[ 
            "/ Only one like has been modified - edited?
            "/ Remove all (possible obsolete) error emphasis, but keep
            "/ annotations...

            "/ Does not work yet, we would have to remove problem from
            "/ highlughter problems too!!
"/            | line |
"/
"/            line := textView list at: start.
"/            line notEmptyOrNil ifTrue:[ 
"/                highlighter unmark: line from: 1 to: line size.
"/            ].
        ] ifFalse:[
            "/ More lines has been modified, trigger compilation
            self sourceChanged: true.  
        ].
    ]

    "Created: / 07-08-2014 / 00:57:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService methodsFor:'initialization'!

initialize

    super initialize.

    highlighter := JavaLintHighlighter new.
    showingJava := false.

    "Created: / 05-08-2011 / 11:53:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-10-2013 / 15:11:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService methodsFor:'private'!

annotationAtLine: lineNo
    | annotations |        

    (annotations := highlighter annotations) isEmptyOrNil ifTrue:[ ^ nil ].
    annotations do:[:a|
        | line |

        line := a line.    
        line > lineNo ifTrue:[ ^ nil ].
        line == lineNo ifTrue:[ ^ a ].
    ].
    ^nil

    "Created: / 30-01-2012 / 21:06:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2013 / 13:38:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
    "Modified: / 23-09-2013 / 22:27:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showInfoWindowForLine: lineNo 
    | ann |

    ann := self annotationAtLine: lineNo.
    ann isNil ifTrue: [
        ^ false
    ].
    (JavaLintPopupWindow new)
        problem: ann problem;
        codeView: codeView;
        allButOpen;
        openWindowAt: (Screen current pointerPosition - (20 @ 20)).
    ^ true

    "Created: / 30-01-2012 / 21:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2013 / 13:40:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService methodsFor:'processing'!

process
    showingJava ifTrue:[ 
        super process
    ].

    "Created: / 07-08-2014 / 00:42:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process:delayed
    "Actually process source code. If `delayed` is true, view should be updated
     asynchronously using #pushUserEvent:. Individual services should override
     this method.
     
     NOTE: Do not call this method from custom code directly, always call
     #processSafely: which handle possible errors and protect against
     'debugger bomb'"

    | lang |

    done := false.
    modified := false.

    Delay waitForMilliseconds: 1000."Give user some time to finish coding"
    lang := codeView language.
    lang isJava ifFalse:[ ^ self ].

    modified ifFalse:[
        | list code |
        list := textView list.
        list notEmptyOrNil ifTrue:[
        code := list asStringWithoutEmphasis.
            code notEmptyOrNil ifTrue:[ 
                modified ifFalse:[
                    | problems |

                    problems := JavaCompiler new check: code.
                    modified ifFalse:[ 
                        highlighter problems: problems.
                        self rehighlight: delayed  
                    ].
                ]
            ].
        ].
    ]

    "Created: / 07-08-2014 / 00:41:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-04-2015 / 18:35:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService methodsFor:'redrawing'!

drawLine:lineNo in:view atX:x y:y width:w height:h from:startCol to:endColOrNil with:fg and:bg 
    "Called by both gutterView and textView (well, not yet) to
     allow services to draw custom things on text view.
     Ask JV what the args means if unsure (I'm lazy to document
     them, now it is just an experiment...)"

    | annotation |

    showingJava ifFalse:[ ^ self ].

    annotation :=  self annotationAtLine: lineNo.
    annotation notNil ifTrue:[
        self drawAnnotationIcon: (ToolbarIconLibrary smalllintWarning16x16)
                atX: x y: y  width: w height: h.
    ].

    "Created: / 30-01-2012 / 15:11:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-10-2013 / 15:12:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService methodsFor:'registering'!

registerIn: aCodeView

    super registerIn: aCodeView.
    aCodeView languageHolder addDependent: self.
    aCodeView classHolder    addDependent: self.
    aCodeView methodHolder   addDependent: self.
    aCodeView textView cursorLineHolder addDependent: self.

    "Created: / 17-09-2013 / 00:31:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 01:05:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregister
    codeView textView cursorLineHolder removeDependent: self.
    codeView languageHolder removeDependent: self.
    codeView classHolder    removeDependent: self.
    codeView methodHolder   removeDependent: self.
    super unregister.

    "Created: / 24-10-2013 / 23:12:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 01:05:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintService class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


JavaLintService initialize!
