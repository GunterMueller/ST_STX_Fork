"{ Package: 'stx:goodies/refactoryBrowser/refactoring' }"

Error subclass:#RefactoringError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Support'
!


!RefactoringError class methodsFor:'signalling'!

raiseSignal: aString with: anObject 
        "Raise an exception."

        ^(self new)
                searchFrom: thisContext sender;
                originator: thisContext sender homeReceiver;
                messageText: aString;
                parameter: anObject;
                raiseSignal
!

raiseSignal: aString with: anObject isResumable:isResumable
        "Raise an exception."

        ^(self new)
                searchFrom: thisContext sender;
                originator: thisContext sender homeReceiver;
                messageText: aString;
                parameter: anObject;
                isResumable:isResumable;
                raiseSignal
! !

!RefactoringError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/refactoring/RefactoringError.st,v 1.5 2003-09-26 11:51:34 cg Exp $'
! !
