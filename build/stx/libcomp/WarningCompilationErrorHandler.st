"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

CompilationErrorHandler subclass:#WarningCompilationErrorHandler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!WarningCompilationErrorHandler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    I am a warning ErrorHandler - i.e. showing a warning for
    compilation errors.
"
! !

!WarningCompilationErrorHandler methodsFor:'error handling'!

error:aMessage position:position to:endPos from:aCompiler
    "error notification.
     This is sent by the compiler/evaluator if it detects errors."

    |box|

    box := TextBox new.
    box initialText:currentSource.
    box label:aMessage.
    box textView selectFromCharacterPosition:(position?1) to:(endPos?currentSource size).
    box open.

    box accepted ifFalse:[ ^ #Error ].
    ^ false

    "Created: / 30.7.1999 / 18:10:22 / cg"
    "Modified: / 30.7.1999 / 22:37:30 / cg"
! !

!WarningCompilationErrorHandler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/WarningCompilationErrorHandler.st,v 1.6 2011-09-29 11:19:11 cg Exp $'
! !
