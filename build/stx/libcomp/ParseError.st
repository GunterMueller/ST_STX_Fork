"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

ProceedableError subclass:#ParseError
	instanceVariableNames:'errorMessage startPosition endPosition lineNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!ParseError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    raised for any compilation-related errors.
    (originally, I wanted to subclass this from compilationError,
    and raise different error for code generator issues (i.e. method too
    big, etc.) But all users of the parser in the system (RB-stuff, Lint stuff,
    fileIn etc.) always handle the ParseError, and I don't want them to be forced to change.
    So we subclass the codeGenerator issues from this one.
"
! !

!ParseError methodsFor:'accessing'!

description
    |s|

    s := super description.
    s last isSeparator ifFalse:[
        errorMessage notEmptyOrNil ifTrue:[
            s := s , ' '
        ]
    ].
    s := s , (errorMessage ? '').
    lineNumber notNil ifTrue:[
        s := s , ' [Line ' , lineNumber asString , ']'
    ].
    ^ s
!

endPosition
    ^ endPosition
!

errorMessage
    ^ errorMessage
!

errorMessage:something
    errorMessage := something.
!

errorMessage:errorMessageArg startPosition:startPositionArg 
    errorMessage := errorMessageArg.
    startPosition := startPositionArg.
!

errorMessage:errorMessageArg startPosition:startPositionArg endPosition:endPositionArg 
    errorMessage := errorMessageArg.
    startPosition := startPositionArg.
    endPosition := endPositionArg.
!

lineNumber
    ^ lineNumber
!

lineNumber:something
    lineNumber := something.
!

parser
    ^ originator
!

startPosition
    ^ startPosition
! !

!ParseError class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

