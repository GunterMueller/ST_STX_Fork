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

"{ NameSpace: Smalltalk }"

TestCase subclass:#JavaExceptionTests
	instanceVariableNames:'signal'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaExceptionTests class methodsFor:'documentation'!

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

!JavaExceptionTests class methodsFor:'accessing'!

resources

  ^ Array 
        with: JavaInitializedResource 
        with: JavaLibrariesResource
        with: JavaTestsResource

    "Created: / 30-03-2012 / 13:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaExceptionTests methodsFor:'callbacks'!

call: trhower with: aBoolean 
    aBoolean ifTrue: [ signal raise ].

    "Created: / 03-04-2012 / 17:33:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2012 / 18:04:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

throw_me: aBoolean

    aBoolean ifTrue:[signal raise].

    "Created: / 03-04-2012 / 17:31:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaExceptionTests methodsFor:'error handling (interop)'!

doesNotUnderstand:aMessage

    | method  selector class args|
    selector := aMessage selector.
    args := aMessage arguments.
    class := self class.

    method := JavaLookup instance lookupMethodForSelector: selector
                directedTo: class
                for: self
                withArguments: args
                from: thisContext sender sender
                ilc: nil.

    method isNil ifTrue:[
        ^super doesNotUnderstand:aMessage
    ] ifFalse:[
        ^ method valueWithReceiver: self arguments: args
    ].

    "Created: / 06-09-2011 / 22:16:26 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 15-12-2011 / 23:42:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaExceptionTests methodsFor:'running'!

setUp
    signal := Signal new.

    "Created: / 03-04-2012 / 17:30:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaExceptionTests methodsFor:'tests'!

test_01a
    "
    Scenario (method activation stack, last called at bottom)
        1) ST method, handles IllegalArgumentException
        2) Java method, throws IllegalArgumentException.
    "

    | thrower caught |
    thrower := JAVA stx libjava tests mocks JavaExceptionTestsHelper new.
    [ 
        thrower throw_me: true.
        caught := false.
        
    ] on: JAVA java lang IllegalArgumentException do: [:ex|
        caught := true.
    ].

    self assert: caught == true.

    "Created: / 18-03-2012 / 11:06:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2017 / 22:40:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01b
    "
     Scenario (method activation stack, last called at bottom)
        1) ST method, handles IllegalArgumentException
        2) Java method, does not IllegalArgumentException."
    
    | thrower  caught |
    thrower := JAVA stx libjava tests mocks JavaExceptionTestsHelper new.
    [
        thrower throw_me: false.
        caught := false.
    ] on: JAVA java lang IllegalArgumentException do: [:ex | 
        caught := true. 
    ].
    self assert: caught == false.

    "Created: / 18-03-2012 / 21:49:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2012 / 18:17:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-08-2017 / 22:40:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01c
    "
    Scenario (method activation stack, last called at bottom)
        1) ST method, handles IllegalArgumentException
        2) Java method, does not IllegalArgumentException.
    "

    | thrower caught |
    thrower := JAVA stx libjava tests mocks JavaExceptionTestsHelper new.
    [ 
        thrower throw_me: true.
        caught := false.
        
    ] on: JAVA java lang Throwable do: [:ex|
        caught := true.
    ].

    self assert: caught == true.

    "Created: / 18-03-2012 / 22:11:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2017 / 22:40:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01d
    "
    Scenario (method activation stack, last called at bottom)
        1) ST method, handles IllegalArgumentException
        2) Java method, does not IllegalArgumentException.
    "

    | thrower caught |
    thrower := JAVA stx libjava tests mocks JavaExceptionTestsHelper new.
    [
        [ 
            thrower throw_me: true.
            caught := false.
            
        ] on: JAVA java lang ArrayIndexOutOfBoundsException do: [:ex|
            caught := true.
        ].
    ] on: JavaUnhandledExceptionError do:[
        caught := 123.
    ].

    self assert: caught == 123.

    "Created: / 18-03-2012 / 22:12:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2017 / 22:40:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01e
    "
    Scenario (method activation stack, last called at bottom)
        1) ST method, handles IllegalArgumentException
        2) Java method, throws IllegalArgumentException.
    "

    | thrower caught |
    thrower := JAVA stx libjava tests mocks JavaExceptionTestsHelper new.
    [ 
        thrower call: true.
        caught := false.
        
    ] on: JAVA java lang IllegalArgumentException do: [:ex|
        caught := true.
    ].

    self assert: caught == true.

    "Created: / 03-04-2012 / 14:44:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-08-2017 / 22:40:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03a
    "
     Scenario (method activation stack, last called at bottom)
        1) ST method, handles IllegalArgumentException
        2) Java method with finally
        3) Java method, throws IllegalArgumentException."
    
    | thrower  caught |
    thrower := JAVA stx libjava tests mocks JavaExceptionTestsHelper new.
    [
        thrower test_03: true.
        caught := false.
    ] on: JAVA java lang IllegalArgumentException do: [:ex | caught := true. ].
    self assert: caught == true.
    self assert: (thrower instVarNamed: #token) == 3.

    "Created: / 03-04-2012 / 15:39:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-11-2012 / 16:50:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-08-2017 / 22:40:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04a
    "
     Scenario (method activation stack, last called at bottom)
        1) ST method, handles 'signal'
        2) Java method with finally
        3) Smalltak method, throws 'signal'"
    
    | thrower  caught |
    thrower := JAVA stx libjava tests mocks JavaExceptionTestsHelper new.
    [
        thrower test_04: self with: true.
        caught := false.
    ] on: signal do: [:ex | caught := true. ].
    self assert: caught == true.
    self assert: (thrower instVarNamed: #token) == 3.

    "Created: / 03-04-2012 / 17:30:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2012 / 18:04:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-08-2017 / 22:40:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaExceptionTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaExceptionTests.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

