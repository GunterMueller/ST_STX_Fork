"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava/experiments' }"

JavaByteCodeInterpreter subclass:#JavaByteCodeSteppableInterpreter
	instanceVariableNames:'interpretInnerHook'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Bytecode'
!

!JavaByteCodeSteppableInterpreter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaByteCodeSteppableInterpreter methodsFor:'accessing'!

byteCode
^ byteCode.

    "Created: / 01-04-2011 / 16:18:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

constantPool
^constantPool.

    "Created: / 01-04-2011 / 16:20:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

context
    ^ context.

    "Created: / 01-04-2011 / 16:20:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

currentOp
    ^ op.

    "Created: / 01-04-2011 / 16:18:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

instructionPointer
^ instrPointer.

    "Created: / 01-04-2011 / 16:19:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

method
    ^ method.

    "Created: / 01-04-2011 / 16:20:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

numArgs
    ^ numArgs.

    "Created: / 01-04-2011 / 16:19:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

numVars
^numVars.

    "Created: / 01-04-2011 / 16:19:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

programCounter
^pc.

    "Created: / 01-04-2011 / 16:20:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

receiver
^ receiver.

    "Created: / 01-04-2011 / 16:19:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

stackPointer
^ sp.

    "Created: / 01-04-2011 / 16:18:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

wide
    ^ wide.

    "Created: / 01-04-2011 / 16:19:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeSteppableInterpreter methodsFor:'interpretation'!

enterProcessingLoop
"nothing done here (yet?), call interpretNext"

    "Created: / 31-03-2011 / 16:40:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-04-2011 / 16:13:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

hasFinished
    ^ leaveProcessor.

    "Created: / 31-03-2011 / 22:53:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

interpret: aMethod receiver: aReceiver arguments: args 
    self 
        log: ('Invoking method ' , aMethod name , ' on ' , aReceiver printString 
                , ' with ' , args printString).
    super 
        interpret: aMethod
        receiver: aReceiver
        arguments: args.
    ^ self.

    "Created: / 17-03-2011 / 17:25:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-04-2011 / 16:10:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

interpretInner:aJavaMethod receiver:aReceiver arguments:arguments 
    interpretInnerHook isNil ifTrue:[
        ^ super 
            interpretInner:aJavaMethod
            receiver:aReceiver
            arguments:arguments
    ] ifFalse:[
        ^ interpretInnerHook 
            with:aJavaMethod
            with:aReceiver
            with:arguments
    ].

    "Created: / 31-03-2011 / 16:41:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-04-2011 / 16:15:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:50:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

interpretInnerHook: threeArgBlock 
    "args: method receiver arguments"
    
    interpretInnerHook := threeArgBlock.

    "Created: / 31-03-2011 / 22:50:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-04-2011 / 14:49:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

interpretNext
    leaveProcessor ifTrue: [ ^ self interpretationFinished ].
    Context cannotReturnSignal handle: [:ex | ^ ex parameter ]
        do: 
            [ instrPointer := pc.
            op := byteCode at: pc.
            pc := pc + 1.
            self switch: op. ].

    "Created: / 31-03-2011 / 16:41:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

returnValue
    ^ retVal.

    "Created: / 31-03-2011 / 22:53:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeSteppableInterpreter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/experiments/JavaByteCodeSteppableInterpreter.st,v 1.5 2015-03-20 13:29:44 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

