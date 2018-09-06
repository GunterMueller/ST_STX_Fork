"
 COPYRIGHT (c) 2010 by Claus Gittinger
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

CompilationErrorHandler subclass:#TextCollectingCompilationErrorHandler
	instanceVariableNames:'lines collectWarnings'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!TextCollectingCompilationErrorHandler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Claus Gittinger
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
    collects messages - for check before checking in
"
! !

!TextCollectingCompilationErrorHandler methodsFor:'accessing'!

errorsOnly:aBoolean
    collectWarnings := aBoolean not

    "Created: / 02-11-2010 / 13:09:34 / cg"
! !

!TextCollectingCompilationErrorHandler methodsFor:'error handling'!

error:aMessage position:position to:endPos from:aCompiler
    (lines includes:aMessage) ifTrue:[^ self ].
    lines add:aMessage.

    myStream nextPutLine:('Error: [' ,
                          aCompiler classToCompileFor name
                          , '>>',
                          (aCompiler selector ? '???')
                          , '] ' , (aMessage allBold withColor:Color red darkened)).

    "Created: / 02-11-2010 / 12:52:23 / cg"
    "Modified: / 03-11-2010 / 12:28:49 / cg"
!

warning:aMessage position:position to:endPos from:aCompiler
    collectWarnings ifTrue:[
        (lines includes:aMessage) ifTrue:[^ self ].
        lines add:aMessage.

        myStream nextPutLine:('Warning: [' ,
                              aCompiler classToCompileFor name
                              , '>>',
                              (aCompiler selector ? '???')
                              , '] ' , aMessage).
    ].

    "Created: / 02-11-2010 / 12:51:30 / cg"
    "Modified: / 03-11-2010 / 12:28:45 / cg"
! !

!TextCollectingCompilationErrorHandler methodsFor:'initialization'!

initialize
    lines := OrderedCollection new.
    collectWarnings := true.

    "Created: / 02-11-2010 / 13:00:55 / cg"
! !

!TextCollectingCompilationErrorHandler class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

