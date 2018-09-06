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
"{ Package: 'stx:libjava' }"

WordArray variableWordSubclass:#JavaExceptionTable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaExceptionTable class methodsFor:'documentation'!

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

!JavaExceptionTable methodsFor:'accessing'!

handlerPCFor:exception at:pc in:aMethod
    "if there is a handler for exceptionClass, with given pc,
     return the handler-PC; otherwise, return nil."

    | i |
    "JV+MH@2011-02-25: You may wonder why there is endPC - 1:
    The Java VM Spec, 3rd edition, sec 4.7.3, page 78:

    The fact that end_pc is exclusive is a historical mistake in the design of the
    Java virtual machine: if the Java virtual machine code for a method is exactly
    65535 bytes long and ends with an instruction that is 1 byte long, then that
    instruction cannot be protected by an exception handler. A compiler writer can
    work around this bug by limiting the maximum size of the generated Java
    virtual machine code for any method, instance initialization method, or static
    initializer (the size of any code array) to 65534 bytes.

    "
    i := 1.
    [ i < self size ] whileTrue:[
        | startPC endPC handlerPC catchType |

        startPC := self at: i.
        endPC := self at: i + 1.
        handlerPC := self at: i + 2.
        catchType := self at: i + 3.

        (pc between:startPC and:endPC - 1) ifTrue:[
            (catchType == 0) ifTrue:[^ handlerPC].
            exception notNil ifTrue:[
                catchType := (aMethod constantPool at: catchType) javaClass.
                (exception isKindOf:catchType) ifTrue:[
                    ^ handlerPC
                ].
            ]
        ].
        i := i + 4.
    ].
    ^ nil

    "Created: / 06-05-2013 / 21:55:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaExceptionTable methodsFor:'queries'!

hasFinallyBasedOnExceptionTable
    | i |

    i := 1.
    [ i < self size ] whileTrue:[
        (self at: i + 3) == 0 ifTrue:[ ^ true ].
        i := i + 4.
    ].
    ^ false

    "Created: / 06-05-2013 / 21:59:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaExceptionTable class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaExceptionTable.st,v 1.3 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

