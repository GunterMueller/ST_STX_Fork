"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

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

EditSupport subclass:#JavaEditSupport
	instanceVariableNames:'lastTypedKey0 lastTypedKey1 lastTypedKey2 lastTypedKey3'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Java'
!

!JavaEditSupport class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

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

!JavaEditSupport methodsFor:'accessing'!

language
    "superclass SmallSenseEditSupport says that I am responsible to implement this method"

    | javaLanguageClass |

    javaLanguageClass := Smalltalk at:#JavaLanguage.
    ^ javaLanguageClass notNil ifTrue:[ javaLanguageClass instance ] ifFalse: [ nil ].

    "Modified: / 04-10-2013 / 08:42:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaEditSupport methodsFor:'accessing-classes'!

completionEngineClass
    "Returns a code completion engine class or nil, of 
     no completion is supported"

    OperatingSystem getLoginName = 'jv' ifTrue:[
        ^ SmallSense::JavaCompletionEngine
    ].
    ^ SmallSense::JavaCompletionEngineSimple

    "Created: / 03-10-2013 / 17:45:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-08-2014 / 10:53:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scannerClass
    "Returns a class to use for scanning lines. If nil, scanning is
     not supported and scanLine* methods will return an empty array."

    ^ (Smalltalk at: #JavaScanner)

    "Created: / 22-10-2013 / 00:38:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaEditSupport methodsFor:'editing'!

electricInsertSnippet
    | tokens  lastToken0 |

    tokens := self scanLineAtCursor.
    tokens isEmptyOrNil ifTrue:[
        ^ false
    ].
    lastToken0 := tokens at:(tokens size - 3).
    lastToken0 = 'Error' ifTrue:[
        ^ false
    ].
    (tokens last > textView cursorCol) ifTrue:[
        ^ false
    ].
    
    "/ Insert try { ... }
    
    lastToken0 == #try ifTrue:[
        (tokens size == 4 
            or:[ (tokens size > 4) and:[ (tokens at:tokens size - 7) ~~ $. ] ]) 
                ifTrue:[
                    self electricInsertBlockOpenedBy:' {' closedBy:'}'.
                    ^ true.
                ]
    ].
    
    "/ Insert catch (  ) { ... }
    
    lastToken0 == #catch ifTrue:[
        (tokens size > 4 and:[ (tokens at:tokens size - 7) == $} ]) ifTrue:[
            | cursorLine  cursorCol |

            cursorLine := textView cursorLine.
            cursorCol := textView cursorCol.
            self electricInsertBlockOpenedBy:' (  ) {' closedBy:'}'.
            textView cursorLine:cursorLine col:cursorCol + 3.
            ^ true.
        ].
    ].
    
    "/ Insert finally { ... }
    
    lastToken0 == #finally ifTrue:[
        (tokens size > 4 and:[ (tokens at:tokens size - 7) == $} ]) ifTrue:[
            self electricInsertBlockOpenedBy:' {' closedBy:'}'.
            ^ true.
        ].
    ].
    
    "/ Insert if/while/synchronized ( )  { ... }
    
    (#( #if #while #synchronized ) includes:lastToken0) ifTrue:[
        (tokens size = 4) ifTrue:[
            | cursorLine  cursorCol |

            cursorLine := textView cursorLine.
            cursorCol := textView cursorCol.
            self electricInsertBlockOpenedBy:' (  ) {' closedBy:'}'.
            textView cursorLine:cursorLine col:cursorCol + 3.
            ^ true.
        ].
    ].
    
    "/ Insert for ( ; ; )  { ... }
    
    (lastToken0 == #for) ifTrue:[
        (tokens size = 4) ifTrue:[
            | cursorLine  cursorCol |

            cursorLine := textView cursorLine.
            cursorCol := textView cursorCol.
            self electricInsertBlockOpenedBy:' ( ; ; ) {' closedBy:'}'.
            textView cursorLine:cursorLine col:cursorCol + 3.
            ^ true.
        ].
    ].
    ^ false

    "Created: / 22-10-2013 / 01:53:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:00:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaEditSupport methodsFor:'event handling'!

keyPress: key x:x y:y in: view

    "Handles an event in given view (a subview of codeView).
     If the method returns true, the event will not be processed
     by the view."

    view ~~ textView ifTrue:[ ^ false ].

    (self keyPressIgnored: key) ifTrue:[
        ^ true.
    ]. 

    lastTypedKey3 := lastTypedKey2.
    lastTypedKey2 := lastTypedKey1.
    lastTypedKey1 := lastTypedKey0.
    lastTypedKey0 := key.

    key == #CodeCompletion ifTrue:[ 
        | controller |

        (controller := self textView completionSupport) notNil ifTrue:[
            ^ controller handleKeyPress:key x:x y:y 
        ].
        ^ false
    ]. 

    key == #Return ifTrue:[ 
        ^ self keyPressReturn.
    ]. 

    UserPreferences current smallSenseElectricEditSupportEnabled ifFalse:[ ^ false ].     

    key == ${ ifTrue:[
        ^ self keyPressOpenCurly
    ].

    key == Character space ifTrue:[
        ^ self electricInsertSnippet
    ].

    ^ false

    "Created: / 07-03-2010 / 09:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-05-2015 / 00:09:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressOpenCurly
    | line tokens i |

    line := textView listAt: textView cursorLine.
    line notEmptyOrNil ifTrue:[
        i := line size.
        [ i > 0 and:[(line at: i) isSeparator] ] whileTrue:[ i := i - 1 ].
        (i ~~ 0 and:[textView cursorCol < i]) ifTrue:[
            ^ false.        ].
    ] ifFalse:[
        self electricInsertBlockOpenedBy:'{' closedBy:'}'. 
        ^ true
    ].

    tokens := self scanLineAtCursor.
    tokens notEmptyOrNil ifTrue:[
        | column |

        column := textView cursorCol.
        (tokens at: tokens size - 3) = 'Error' ifTrue:[ ^ false ].
        1 to: tokens size - 3 by: 4 do:[:i |
            (column between: (tokens at: i + 2) and: (tokens at: i + 3)) ifTrue:[
                (tokens at: i) == #String ifTrue:[ ^ false ].

                self electricInsertBlockOpenedBy:'{' closedBy:'}'. 
                ^ true.
            ].
        ].
    ].

    self electricInsertBlockOpenedBy:'{' closedBy:'}'. 
    ^ true

    "Created: / 04-08-2013 / 01:54:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:01:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPressReturn
    | line c i indent lineNr ccontroler  |

    textView isInInsertMode ifFalse:[ ^ false ].
    ccontroler := textView completionSupport.
    (ccontroler notNil and:[ ccontroler isCompletionViewShown ]) ifTrue:[ 
        ^ false.
    ].

    "/ First, check if the cursor is at the end of line, i.e., if
    "/ there's no text after the cursor...
    lineNr := textView cursorLine.
    line := textView listAt: lineNr.
    i := line size.
    i >= textView cursorCol ifTrue:[ 
        [ i > 0 and:[ (c := line at:i) isSeparator ] ] whileTrue:[ i := i - 1 ].    
        i <= textView cursorCol ifFalse:[ 
            "/ If not, do not indent...
            ^ false 
        ].
    ].

    "/ Search for closest non-empty line above
    lineNr := textView cursorLine.
    [ lineNr > 0 and:[ (line := textView list at: lineNr ifAbsent:[nil]) isEmptyOrNil ] ] whileTrue:[ lineNr := lineNr - 1 ].
    lineNr == 0 ifTrue:[ 
        "/ No such line found, givin up
        ^ false.
    ].
    indent := line indexOfNonSeparator.
    "/ Look for opening curly, if found, increase indent...
    i := line size.
    [ i > 0 and:[ (c := line at:i) isSeparator ] ] whileTrue:[ i := i - 1 ].
    (i > 0 and:[ c == ${ ]) ifTrue:[ 
        indent := indent + 4.
    ].
    textView undoableDo:[
        textView insertCharAtCursor:(Character cr).
        textView cursorCol: indent.
    ].
    ^ true

    "Created: / 13-08-2014 / 15:30:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-05-2015 / 00:17:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaEditSupport methodsFor:'initialization'!

initializeForService: anEditService    
    super initializeForService: anEditService.
    textView autoIndent:true.

    "Created: / 27-09-2013 / 13:55:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 12-02-2015 / 00:01:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaEditSupport methodsFor:'private'!

tokenAtCursorLine
    | scanner token |

    scanner := (Smalltalk at:#JavaScanner) for: (textView listAt: textView cursorLine) string.

    [ 
        [ 
            token := scanner nextToken.
            (token ~~ #EOF and:[ scanner tokenEndPosition + 1 < textView cursorCol ])
        ] whileTrue.
    ] on: Error do:[
        token := nil.
    ].
    ^ token

    "Created: / 04-08-2013 / 02:00:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:02:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tokensAtCursorLine
    | scanner token |

    scanner := (Smalltalk at:#JavaScanner) for: (textView listAt: textView cursorLine) string.
    ^ OrderedCollection streamContents:[:tokens |
        [ token := scanner nextToken.token ~~ #EOF ] whileTrue:[
            tokens nextPut: token.
        ].
    ].

    "Created: / 04-08-2013 / 01:57:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2015 / 00:02:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaEditSupport class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

