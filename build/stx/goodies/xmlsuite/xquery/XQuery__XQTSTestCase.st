"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TestCase subclass:#XQTSTestCase
	instanceVariableNames:'interpreter'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSTestCase class methodsFor:'accessing'!

resources

    ^Array with: XQTSTestResource

    "Created: / 10-11-2008 / 16:23:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQTSTestCase class methodsFor:'testing'!

isAbstract

    ^self == XQTSTestCase

    "Created: / 10-11-2008 / 16:22:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQTSTestCase methodsFor:'assertions'!

should: block raiseErrorCodes: arrayOfErrorCodes

"/    <resource: #skipInDebuggersWalkBack>

    ^ self assert:
            (self 
                executeShould:block 
                inScopeOf:(XQueryParserError, XQueryInterpreterError)
                suchThat:[:ex|arrayOfErrorCodes includes:ex errorCode])

    "Created: / 10-11-2008 / 16:53:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-11-2008 / 18:39:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-09-2009 / 17:12:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

shouldRaiseError: block

    <resource: #skipInDebuggersWalkBack>

    ^ self assert:
            (self 
                executeShould:block 
                inScopeOf:(XQueryParserError, XQueryInterpreterError)
                suchThat:[ :ex | ^true ] )

    "Modified: / 10-11-2008 / 18:39:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 14-09-2009 / 17:16:49 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQTSTestCase methodsFor:'initialization & release'!

setUp

    super setUp.
    interpreter := XQueryInterpreter new
                    openPerseusDebuggerOnError: false;
                    yourself

    "Created: / 10-11-2008 / 17:01:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-06-2009 / 19:34:12 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQTSTestCase methodsFor:'private'!

executeShould: aBlock inScopeOf: anExceptionalEvent suchThat: suchBlock

    [aBlock value]
        on: anExceptionalEvent
        do: [:ex | ^suchBlock value: ex].
    ^false.

    "Created: / 10-11-2008 / 18:40:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQTSTestCase methodsFor:'xqts utilities'!

xqtsBind: variableName toContentsOf: fileName
    | variableValue document documentAdaptor |

    document := XMLv2::Parser forDOM3 processDocumentInFilename:
                    (XQTSTestResource current xqtsInputFile: fileName).
    documentAdaptor := XQuery::DOM3XDMAdaptor new document: document.
    variableValue := XQuerySequence with:
                        (NodeItem new 
                            documentAdaptor: documentAdaptor;
                            nodeId: documentAdaptor xpathDocument).

    interpreter
        bindExternalVar: (XQuerySequence withAtomicValue: variableName asType: 'xs:QName')
        to: variableValue.

    "Created: / 10-11-2008 / 17:23:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 20:06:42 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 28-01-2010 / 11:36:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xqtsResultTextFromFile: fileName
    |file|
    file := (XQTSTestResource current xqtsResultFile: fileName).

    file isRegularFile ifTrue: [
        ^ file contents asStringWithoutFinalCR replString: ' />' withString: '/>'.
    ].

    "Created: / 10-11-2008 / 17:10:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-09-2009 / 14:07:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xqtsResultTextFromResult: xqueryResult

    ^xqueryResult asString

    "Created: / 10-11-2008 / 17:10:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-04-2009 / 15:04:02 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xqtxBind: what toContentsOf: contents
    "Method to overcome xqts-generator bug"
    ^self xqtsBind: what toContentsOf: contents

    "Created: / 08-03-2009 / 20:21:46 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQTSTestCase class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
