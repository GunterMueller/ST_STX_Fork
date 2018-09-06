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

TestCase subclass:#JavaThreadingTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaThreadingTests class methodsFor:'documentation'!

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

!JavaThreadingTests class methodsFor:'accessing'!

resources

  ^ Array 
        with: JavaInitializedResource 
        with: JavaLibrariesResource
        with: JavaTestsResource

    "Created: / 30-03-2012 / 13:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaThreadingTests methodsFor:'tests'!

test_regression_01
    "Make sure that java.lang.Thread (& corresponding Smalltalk Process) is removed from
     Java:Threads map when thread finished (to avoid resource leak)"

    | thread threadProcess activeProcess blocker |

    blocker := Semaphore new.
    [ 
        thread := JAVA java lang Thread currentThread.
        "/ Use Java classVarAt: hack to avoud need for access methods not otherwise
        "/ required. They should be cleaned.
        threadProcess := (Java classVarAt: #Threads) at: thread.
        activeProcess := Processor activeProcess.
        blocker signal.
    ] fork.
    blocker wait.
    self assert: thread notNil.
    self assert: threadProcess notNil.
    self assert: threadProcess == activeProcess.
    "/ Give exist actions chance to run.
    Delay waitForMilliseconds: 100.
    self assert: ((Java classVarAt: #Threads) includesKey: thread) not.

    "Created: / 08-08-2014 / 09:33:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

