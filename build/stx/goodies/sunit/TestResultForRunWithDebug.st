"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestResultStX subclass:#TestResultForRunWithDebug
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Smalltalk/X'
!


!TestResultForRunWithDebug methodsFor:'outcome'!

rememberException:exception

    super rememberException: exception.
Transcript showCR:'99'.
    ^exception reject.

    "Created: / 20-08-2011 / 13:32:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestResultForRunWithDebug class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestResultForRunWithDebug.st,v 1.2 2015-01-31 00:31:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestResultForRunWithDebug.st,v 1.2 2015-01-31 00:31:19 cg Exp $'
! !

