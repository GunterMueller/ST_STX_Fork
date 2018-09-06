"{ Package: 'stx:libjavascript/tests' }"

TestCase subclass:#JavaScriptCompletionEngineTests
	instanceVariableNames:'suggestions label'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!


!JavaScriptCompletionEngineTests methodsFor:'helpers'!

complete: codeWithExclam
    | position code |

    position := codeWithExclam indexOf: $!!.
    code := (codeWithExclam copyTo: position - 1) , (codeWithExclam copyFrom: position + 1).
    ^ self complete: code position: position

    "Created: / 24-09-2013 / 13:54:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

complete: code position: pos

    | textView |

    textView := Workspace new.
    textView contents: code.
    textView setCursorCol: (textView colOfCharacterPosition: pos).
    textView setCursorLine: (textView lineOfCharacterPosition: pos).

    "
    SmallSense::ParseNodeInspector openOnNode: (JavaScriptCompletionParser new parseMethod: code in: self class ignoreErrors:true ignoreWarnings:true) tree source: code.
    "

    JavaScriptCompletionEngine new
        completeForMethod: nil class: self class context: nil codeView: textView 
        into: [:suggestionsArg :editorArg :labelArg |
            suggestions := suggestionsArg.
            label := labelArg.
        ].

    "Created: / 24-09-2013 / 13:08:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 24-09-2013 / 15:55:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptCompletionEngineTests methodsFor:'tests'!

test_01

    self complete: 'execute() { return testSe!! }'.

    self assert: suggestions size == 4.
    self assert: (suggestions includesAll: self class allInstVarNames)

    "Created: / 24-09-2013 / 13:04:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2013 / 15:40:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02

    self complete: 'execute(a) { return testSe!! }'.

    self assert: suggestions size == 5.
    self assert: (suggestions includesAll: self class allInstVarNames).
    self assert: (suggestions includesAll: #(a)).

    "Created: / 24-09-2013 / 15:47:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2013 / 15:40:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03

    self complete: 'execute(a) { var foo = 0; return testSe!! }'.

    self assert: suggestions size == 6.
    self assert: (suggestions includesAll: self class allInstVarNames).
    self assert: (suggestions includesAll: #(a foo)).

    "Created: / 24-09-2013 / 15:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2013 / 15:40:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04

    self complete: 'execute(a) { var foo = 0; { return testSe!! } }'.

    self assert: suggestions size == 6.
    self assert: (suggestions includesAll: self class allInstVarNames).
    self assert: (suggestions includesAll: #(a foo)).

    "Created: / 24-09-2013 / 15:48:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2013 / 15:40:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05

    self complete: 'execute(a) { var foo = 0; { var bar; return testSe!! } }'.

    self assert: suggestions size == 7.
    self assert: (suggestions includesAll: self class allInstVarNames).
    self assert: (suggestions includesAll: #(a foo bar)).

    "Created: / 24-09-2013 / 15:48:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2013 / 15:41:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_06

    self complete: 'execute(a) { return new Arr!! }'.

    self assert: suggestions notEmptyOrNil.
    self assert: (suggestions includes: 'Array').
    self assert: (suggestions includes: 'ArrayedCollection').

    "Created: / 24-09-2013 / 15:49:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2013 / 10:39:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_07

    self complete: 'execute(a) { return Transcript.showC!! }'.

    self assert: suggestions notEmptyOrNil.
    self assert: (suggestions includes: 'showCR').

    "Created: / 25-09-2013 / 13:59:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_08

    self complete: 'execute(a) { return 1.betwe!! }'.

    self assert: suggestions notEmptyOrNil.
    self assert: (suggestions includes: 'between_and').

    "Created: / 25-09-2013 / 14:27:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_09

    self complete: 'execute(a) { return a.betwe!! }'.

    self assert: suggestions notEmptyOrNil.
    self assert: (suggestions includes: 'between_and').

    "Created: / 25-09-2013 / 14:27:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaScriptCompletionEngineTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/tests/JavaScriptCompletionEngineTests.st,v 1.2 2013-09-25 14:42:14 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/tests/JavaScriptCompletionEngineTests.st,v 1.2 2013-09-25 14:42:14 vrany Exp $'
! !

