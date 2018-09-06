"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::DebuggerService subclass:#DebuggerService
	instanceVariableNames:'lastIsn'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Debugging-Model'
!


!DebuggerService methodsFor:'event handling'!

breakpointReached 

    | currentIsn |
    currentIsn := self instruction.
    (lastIsn notNil 
        and:[lastIsn startPosition == currentIsn startPosition
            and:[lastIsn stopPosition == currentIsn stopPosition]])
                ifTrue:[lastIsn := currentIsn. ^self].
    lastIsn := currentIsn.
    super breakpointReached

    "Created: / 20-04-2010 / 19:45:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DebuggerService methodsFor:'interrupt handling'!

contextInterrupt

    "/Transcript showCR:'>> CONTEXT INTERRUPT'

    "Created: / 29-11-2008 / 12:05:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-04-2010 / 19:56:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

terminateInterrupt

    |nextInterpreter|

"/    Transcript showCR:'Service: TERMINATE INTERRUPT'.
    nextInterpreter := interpreter nextInterpreter.
    self detach.
    (nextInterpreter notNil"and:[self showFullStackHolder value]")
        ifTrue:  [self attach: nextInterpreter].
    self changed:#interpreter with: #terminated.

    "Created: / 01-12-2008 / 08:34:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-12-2008 / 13:44:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-04-2010 / 20:00:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tracepointInterrupt

"/    Transcript show:'Service: STEP INTERRUPT: '.
"/    self context displayOn: Transcript.
"/    Transcript cr.

    mode tracepointInterrupt

    "Created: / 13-12-2008 / 12:55:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-12-2008 / 11:27:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-04-2010 / 19:57:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DebuggerService class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
