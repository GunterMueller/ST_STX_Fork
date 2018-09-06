"{ Package: 'stx:goodies/petitparser/devtools' }"

PPParser subclass:#PPDebuggingParser
	instanceVariableNames:'parser debugger'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Debugging'
!


!PPDebuggingParser class methodsFor:'instance creation'!

parser: parser debugger: debugger

    ^self new parser: parser; debugger: debugger

    "Created: / 12-03-2012 / 16:47:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPDebuggingParser methodsFor:'accessing'!

debugger
    ^ debugger
!

debugger:aPPDebugger
    debugger := aPPDebugger.
!

parser
    ^ parser
!

parser:aPPParser
    parser := aPPParser.
! !

!PPDebuggingParser methodsFor:'parsing'!

parseOn:aStream
    | result |

    debugger enterParser: parser stream: aStream.
    result := parser parseOn: aStream.
    debugger leaveParser: parser stream: aStream result: result.
    ^result.

    "Modified: / 12-03-2012 / 16:41:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPDebuggingParser methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitPPDebuggingParser:self
! !

!PPDebuggingParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/PPDebuggingParser.st,v 1.2 2013-01-10 13:22:02 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/PPDebuggingParser.st,v 1.2 2013-01-10 13:22:02 vrany Exp $'
!

version_SVN
    ^ '§Id: PPDebuggingParser.st 10 2012-05-04 18:54:13Z vranyj1 §'
! !
