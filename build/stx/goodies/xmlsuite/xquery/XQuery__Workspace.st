"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::Workspace subclass:#Workspace
	instanceVariableNames:'workspaceUI documentProvider parserClass'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-UI'
!


!Workspace methodsFor:'accessing'!

documentProvider

    ^ documentProvider

    "Created: / 15-12-2006 / 07:45:45 / janfrog"
    "Modified: / 15-12-2006 / 08:52:45 / janfrog"
    "Modified: / 22-10-2008 / 10:09:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

documentProvider:anXPathDocumentProvider
    documentProvider := anXPathDocumentProvider.

    "Created: / 15-12-2006 / 07:45:45 / janfrog"
!

workspaceUI
    ^ workspaceUI

    "Created: / 12-12-2006 / 13:36:33 / janfrog"
!

workspaceUI:aWorkspaceUI
    workspaceUI := aWorkspaceUI.

    "Created: / 12-12-2006 / 13:36:33 / janfrog"
! !

!Workspace methodsFor:'events'!

keyPress:key x:x y:y
    <resource: #keyboard (#Ctrld #Ctrlp #Ctrli)>


    (key == #Ctrld) ifTrue:[^ self doIt].
    (key == #Ctrli) ifTrue:[^ self inspectIt].
    (key == #Ctrlp) ifTrue:[^ self printIt].

    ^super keyPress:key x:x y:y.

    "Created: / 10-02-2007 / 10:34:35 / janfrog"
    "Modified: / 12-04-2007 / 13:27:40 / janfrog"
! !

!Workspace methodsFor:'initialization & release'!

executeDoIt:aString

    ^self interpreter
        setDocumentProvider: self documentProvider;
        evaluate: aString

    "Created: / 12-12-2006 / 12:46:24 / janfrog"
    "Modified: / 29-08-2007 / 09:44:15 / janfrog"
! !

!Workspace methodsFor:'menu & menu actions'!

doIt
    "user selected 'doIt' from menu; show a wait-cursor, evaluate the code
     and finally restore cursor; return result of evaluation"
    
    |res|

    "self indexClassToUse isNil ifFalse:[
        |selectedText|

        selectedText := self selectionOrTextOfCursorLine.
        interpreter indexClassToUse:self indexClassToUse.
        self do:(selectedText) withValueDo:[:result | res := result. ].

        workspaceUI 
            ifNotNil:[workspaceUI addResult:res].
    ].
    interpreter indexClassToUse:nil.
    "
    self do:(self selectionOrTextOfCursorLine) withValueDo:[:result | res := result. ].

    workspaceUI ifNotNil:[workspaceUI addResult:res]

    "janfrogs ver"
    "^ self 
        do:(self selectionOrTextOfCursorLine)
            withValueDo:[:result | workspaceUI ifNotNil:[workspaceUI addResult: result]]"

    "Created: / 12-12-2006 / 13:24:09 / janfrog"
    "Modified: / 14-11-2007 / 12:40:21 / janfrog"
    "Modified: / 20-11-2007 / 12:36:15 / beyboy"
    "Modified: / 17-04-2008 / 10:02:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doIt: theCode

    self documentProvider ifNotNil:
        [self interpreter setDocumentProvider: self documentProvider].
    ^super doIt: theCode.

    "Created: / 18-09-2008 / 18:03:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 01-12-2008 / 11:04:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

inspectIt
    "user selected 'inspectIt' from menu; use doIt to evaluate the code
     and start an inspector on the result"

    |shifted|

    shifted := self sensor shiftDown.

    ^ self 
        do:(self selectionOrTextOfCursorLine) 
        withValueDo:[:result | shifted ifTrue:[result basicInspect] ifFalse:[result asDocumentFragment inspect] ]

    "Modified: / 16-05-1998 / 16:44:44 / cg"
    "Created: / 12-12-2006 / 12:42:23 / janfrog"
!

inspectQuery
    "user selected 'inspect query' from menu; use doIt to evaluate the code
     and start an inspector on the result"

    |shifted ast |

    shifted := self sensor shiftDown.
    ast := self interpreter parse:(self selectionOrTextOfCursorLine).
    shifted 
        ifTrue:[ast basicInspect]
        ifFalse:[ast inspect]
        "/(self selectionOrTextOfCursorLine)

    "Modified: / 16-05-1998 / 16:44:44 / cg"
    "Created: / 12-04-2007 / 12:50:28 / janfrog"
    "Modified: / 31-10-2007 / 12:28:36 / janfrog"
    "Modified: / 18-09-2008 / 18:03:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

printIt
    "user selected 'printIt' from menu; use doIt to evaluate the code
     and insert result of evaluation into my text.
     If the text is readOnly, do nothing."

    self isReadOnly ifTrue:[
        self beep
    ] ifFalse:[ 
        self 
            do:(self selectionOrTextOfCursorLine) 
            withValueDo:[:result | 
                self cursorLine:selectionEndLine col:(selectionEndCol + 1).
                self insertSelectedStringAtCursor:(result asDocumentFragment asColorXMLString "printString")
            ]
    ]

    "Modified: / 16-05-1998 / 16:44:44 / cg"
    "Created: / 12-12-2006 / 12:36:05 / janfrog"
! !

!Workspace class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
