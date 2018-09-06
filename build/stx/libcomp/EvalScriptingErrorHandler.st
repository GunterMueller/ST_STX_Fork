"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2014 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

CompilationErrorHandler subclass:#EvalScriptingErrorHandler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!EvalScriptingErrorHandler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    I am the ErrorHandler used when executing eval-scripts
"
! !

!EvalScriptingErrorHandler methodsFor:'error handling'!

error:aMessage position:position to:endPos from:aCompiler
    "error notification.
     This is sent by the compiler/evaluator if it detects errors."

    self showErrorOrWarning:aMessage as:'Error' position:position to:endPos from:aCompiler.
    ^ #Error
!

showErrorOrWarning:aMessage as:errorOrWarning position:position to:endPos from:aCompiler
    "error notification.
     This is sent by the compiler/evaluator if it detects errors."

    |lineNr pos|

    lineNr := myStream isNil ifTrue:[1] ifFalse:[myStream lineNumber ? '?'].
    pos := position ? '?'.

    Stderr nextPutLine:('[%1 %2/%3] %4' bindWith:errorOrWarning with:lineNr with:pos with:aMessage).
    currentSource notNil ifTrue:[
        Stderr 
            nextPutLine:currentSource;
            spaces:position?0;
            nextPutLine:'^'.
    ].
    ^ #Error
!

warning:aMessage position:position to:endPos from:aCompiler
    "warning notification.
     This is sent by the compiler/evaluator if it detects something strange."

    self showErrorOrWarning:aMessage as:'Warning' position:position to:endPos from:aCompiler.
    ^ false
! !

!EvalScriptingErrorHandler methodsFor:'queries'!

autoDefineVariables
    "when evaluating with --eval, auto define any variables as workspace vars"

    ^ #workspace. "/ true
! !

!EvalScriptingErrorHandler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/EvalScriptingErrorHandler.st,v 1.9 2015-05-22 18:37:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/EvalScriptingErrorHandler.st,v 1.9 2015-05-22 18:37:50 cg Exp $'
! !

