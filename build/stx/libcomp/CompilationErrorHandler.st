"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

Object subclass:#CompilationErrorHandler
	instanceVariableNames:'myStream currentSource failBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!CompilationErrorHandler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    Instances of this class are created temporary during fileIn.
    They get notified about any errors. Currently, all we
    do here is to output the error on the Transcript;
    eventually, we will open a box showing the position of the error.
"
! !

!CompilationErrorHandler class methodsFor:'instance creation'!

new
    ^ self basicNew initialize

    "Created: / 02-11-2010 / 13:00:35 / cg"
!

on:aStream
    ^ self new reader:aStream
! !

!CompilationErrorHandler methodsFor:'accessing'!

failBlock:something
    failBlock := something.
!

source:aString
    currentSource := aString
! !

!CompilationErrorHandler methodsFor:'error handling'!

correctableError:aMessage position:position to:endPos from:aCompiler
    "error notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    self error:aMessage position:position to:endPos from:aCompiler.
    ^ false. "/ no correction

    "Created: / 30-07-1999 / 18:11:15 / cg"
    "Modified: / 02-11-2010 / 12:58:54 / cg"
!

correctableSelectorWarning:aMessage position:position to:endPos from:aCompiler
    "warning notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    self warning:aMessage position:position to:endPos from:aCompiler.
    ^ false. "/ no correction

    "Modified: / 02-11-2010 / 12:59:04 / cg"
!

correctableWarning:aMessage position:position to:endPos from:aCompiler
    "error notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    self warning:aMessage position:position to:endPos from:aCompiler.
    ^ false

    "Created: / 02-11-2010 / 13:29:40 / cg"
!

error:aMessage position:position to:endPos from:aCompiler
    "error notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    "
     will eventually open a TextBox here, showing the error ....
    "
"/    position printOn:Transcript.
"/    Transcript show:' '.
    Transcript showCR:aMessage.
    failBlock notNil ifTrue:[ failBlock value ].
    ^ false

    "Created: / 30.7.1999 / 18:10:30 / cg"
!

unusedVariableWarning:aMessage position:position to:endPos from:aCompiler
    "warning notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    ^ self warning:aMessage position:position to:endPos from:aCompiler
!

warning:aMessage position:position to:endPos from:aCompiler
    "warning notification during fileIn - ignore it.
     This is sent by the compiler/evaluator if it detects errors."

    ^ false

    "Created: / 30.7.1999 / 18:11:05 / cg"
! !

!CompilationErrorHandler methodsFor:'private-accessing'!

collectingStream:aStream
    myStream := aStream

    "Created: / 02-11-2010 / 12:51:48 / cg"
!

reader:aStream
    myStream := aStream
! !

!CompilationErrorHandler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/CompilationErrorHandler.st,v 1.14 2014-02-20 15:18:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/CompilationErrorHandler.st,v 1.14 2014-02-20 15:18:45 cg Exp $'
! !

