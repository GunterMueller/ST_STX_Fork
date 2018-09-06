"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

Object subclass:#UndefinedVariable
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!UndefinedVariable class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    node for parse-trees, representing undefined variables
    This is a helper class for the compiler.

    This class exists solely for the error message when accessing undefined
    variables - instead of returning nil,  the compiler returns an instance
    of this class,  which will not understand ANY message.
    The error message will then be 'UndefinedVariable ...' 
    instead of 'UndefineObject ...', which is somewhat more informative.

    [author:]
        Claus Gittinger
"
! !

!UndefinedVariable class methodsFor:'instance creation'!

name:aString
    ^ (self basicNew) setName:aString
! !

!UndefinedVariable methodsFor:'accessing'!

name
    "return the value of the instance variable 'name' (automatically generated)"

    ^ name
! !

!UndefinedVariable methodsFor:'catching messages'!

class
    ^ self
!

methods
    self methodError
!

methodsFor
    ^ self methodError

    "Modified: / 18.6.1998 / 14:43:33 / cg"
!

methodsFor:arg
    ^ self methodError

    "Modified: / 18.6.1998 / 14:43:33 / cg"
!

methodsFor:aCategory stamp:time
    "This was added to allow squeak code to be filedIn."

    ^ self methodsFor:aCategory

    "Created: 15.10.1997 / 18:52:04 / cg"
!

privateMethodsFor:arg
    ^ self methodError
!

protectedMethodsFor:arg
    ^ self methodError
!

publicMethodsFor:arg
    ^ self methodError
!

subclass:t instanceVariableNames:f classVariableNames:d poolDictionaries:s
    self subclassingError
!

subclass:t instanceVariableNames:f classVariableNames:d poolDictionaries:s category:cat
    self subclassingError
!

subclass:t instanceVariableNames:f classVariableNames:d poolDictionaries:s classInstanceVariableNames:ci 
    self subclassingError
!

variableByteSubclass:t instanceVariableNames:f 
			  classVariableNames:d poolDictionaries:s category:cat
    self subclassingError
!

variableSubclass:t instanceVariableNames:f 
			  classVariableNames:d poolDictionaries:s category:cat
    self subclassingError
!

variableWordSubclass:t instanceVariableNames:f 
			  classVariableNames:d poolDictionaries:s category:cat
    self subclassingError
! !

!UndefinedVariable methodsFor:'error reporting'!

methodError
    UndefinedSuperclassError
        raiseWith:self
        errorString:('trying to define methods for undefined class: ', name)
!

subclassingError
    UndefinedSuperclassError
        raiseWith:self
        errorString:('trying to create subclass of undefined class: ', name)
! !

!UndefinedVariable methodsFor:'file skipping'!

fileInFrom:aStream notifying:someOne passChunk:passChunk
    "this is sent, if you continue after a warning about
     methods for undefined class.
     It simply skips chunks and sends a warning to the Transcript."

    |aString done|

    done := false.
    [done] whileFalse:[
        done := aStream atEnd.
        done ifFalse:[
            aString := aStream nextChunk.
            done := (aString size == 0).
            done ifFalse:[
                Transcript showCR:'*** skipping method for undefined class: ' , name
            ]
        ]
    ].

    "Modified: 18.5.1996 / 15:45:03 / cg"
! !

!UndefinedVariable methodsFor:'printing & storing'!

printOn:aStream
    "print myself on aStream"

    aStream nextPutAll:'UndefinedVariable('.
    name printOn:aStream.
    aStream nextPut:$).

    "
     self new printOn:Transcript
    "

    "Created: / 20.1.1998 / 14:10:46 / stefan"
! !

!UndefinedVariable methodsFor:'private-accessing'!

setName:aString
    name := aString
! !

!UndefinedVariable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/UndefinedVariable.st,v 1.26 2013-04-11 08:47:43 stefan Exp $'
! !

