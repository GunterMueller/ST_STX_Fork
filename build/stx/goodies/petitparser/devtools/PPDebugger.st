"{ Package: 'stx:goodies/petitparser/devtools' }"

Object subclass:#PPDebugger
	instanceVariableNames:'indent'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Debugging'
!


!PPDebugger class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPDebugger methodsFor:'events'!

enterParser: aPPParser stream: aStream

    indent timesRepeat:[Transcript nextPutAll:'    '].
    Transcript nextPutAll:'{ '.
    Transcript nextPutAll: aPPParser name ? aPPParser printString.
    [
        Transcript nextPutAll: ' pos = '; nextPutAll: aStream position printString.
    ] on: Error do:[:ex|
        Debugger enter.
    ].
    Transcript cr.
    indent := indent + 1.

    "Created: / 12-03-2012 / 16:41:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-01-2013 / 15:16:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

leaveParser: aPPParser stream: aStream result: result

    indent := indent - 1.
    indent timesRepeat:[Transcript nextPutAll:'    '].
    Transcript nextPutAll:'} '.
    Transcript nextPutAll: aPPParser name ? aPPParser printString.
    Transcript nextPutAll: ' pos = '; nextPutAll: aStream position printString.
    Transcript nextPutAll: ' result = '.
    result isPetitFailure ifTrue:[
        Transcript nextPutAll: 'FAILURE '.
    ].
    Transcript nextPutAll: result printString.
    Transcript cr.

    "Created: / 12-03-2012 / 16:41:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-01-2013 / 15:17:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPDebugger methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    indent := 0.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 12-03-2012 / 16:41:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPDebugger class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/PPDebugger.st,v 1.2 2013-01-11 15:17:28 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/PPDebugger.st,v 1.2 2013-01-11 15:17:28 vrany Exp $'
!

version_SVN
    ^ '§Id: PPDebugger.st 10 2012-05-04 18:54:13Z vranyj1 §'
! !
