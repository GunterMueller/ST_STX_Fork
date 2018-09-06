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

Process subclass:#JavaProcess
	instanceVariableNames:'suspendedContext'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Classes'
!

Object subclass:#Helper
	instanceVariableNames:'javaThreadObject javaProcess'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaProcess
!

!JavaProcess class methodsFor:'documentation'!

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

!JavaProcess class methodsFor:'instance creation'!

newHelper

    ^Helper new

    "Created: / 15-12-2010 / 11:11:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaProcess class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaProcess methodsFor:'accessing'!

suspendedContext
    |con|

"/    suspendedContext notNil ifTrue:[^ suspendedContext].
"/    state ~~ #debug ifTrue:[
"/        "/ hide non-JAVA contexts ...
"/        con := super suspendedContext.
"/        [con notNil] whileTrue:[
"/            (con isMemberOf:JavaContext) ifTrue:[^ con].
"/            con := con sender.
"/        ].
"/    ].
    ^ super suspendedContext

    "Created: / 7.5.1996 / 09:02:03 / cg"
    "Modified: / 4.2.1998 / 20:44:31 / cg"
!

suspendedContext:aContext
    suspendedContext := aContext

    "Created: 7.5.1996 / 09:02:12 / cg"
! !

!JavaProcess methodsFor:'interrupts'!

clearInterruptActions
    interruptActions := nil

    "Created: 14.8.1997 / 17:27:22 / cg"
!

isInterrupted
    ^ interruptActions notNil

    "Created: 14.8.1997 / 17:26:40 / cg"
!

markInterrupted
    super interruptWith:[]

    "Modified: / 10.4.1998 / 15:20:58 / cg"
    "Created: / 10.4.1998 / 15:21:15 / cg"
! !

!JavaProcess methodsFor:'suspend & resume'!

terminateNoSignal
    | jThread jThreadMonitor |
    jThread := Java threadForStProcess: self.
    jThread notNil ifTrue:[
        jThreadMonitor := jThread getJavaMonitor.
        [ 
            jThreadMonitor 
                acquire; 
                notify: true. "/ notifyAll()
        ] ensure:[ 
            jThreadMonitor release.
        ].    
    ].
    super terminateNoSignal

    "Created: / 15-12-2010 / 00:18:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2011 / 12:51:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 23:39:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaProcess::Helper methodsFor:'initialization'!

javaProcess:something
    javaProcess := something.
!

javaThreadObject:something
    javaThreadObject := something.
! !

!JavaProcess::Helper methodsFor:'support'!

value
    | procName |

    AbortOperationRequest handle:[:ex | 
        procName := javaProcess name.
        (procName startsWith:'JAVA-AWT-EventQueue') ifTrue:[
            Logger 
                log:('thread ' , procName , ' aborted - restarting process.')
                severity:Logger severityDEBUG
                facility:'JVM'.
            ex restart.
        ] ifFalse:[
            (javaProcess == (Smalltalk at:#'JavaVM:JavaScreenUpdaterThread') 
                or:[ javaProcess == (Smalltalk at:#'JavaVM:JavaEventQueueThread') ]) 
                    ifTrue:[
                        Logger 
                            log:('thread ' , procName , ' aborted - restarting process.')
                            severity:Logger severityDEBUG
                            facility:'JVM'.
                        ex restart
                    ]
                    ifFalse:[
                        Logger 
                            log:('thread ' , procName , ' aborted.')
                            severity:Logger severityDEBUG
                            facility:'JVM'.
                    ]
        ].
    ] do: [
            [
                JavaVM javaExceptionSignal handle:[:ex | 
                    | exClass |

                    procName := javaProcess name.
                    exClass := ex parameter class.
                    exClass == (Java at:'java.lang.ThreadDeath') ifTrue:[
                        Logger 
                            log:('thread ' , procName , ' terminated')
                            severity:Logger severityDEBUG
                            facility:'JVM'.
                    ] ifFalse:[
                        Logger 
                            log:('JAVA: thread ''' , procName , ''' terminated with exception: ' 
                                    , exClass name)
                            severity:Logger severityDEBUG
                            facility:'JVM'.
                    ].
                    ex return.
                ] do:[
                    MessageNotUnderstood handle:[:ex | 
                            | 
                            "/ remap doesNotUnderstand with nil-receiver to
                            "/ a nullPointerException ...
                             con  m |

                            con := ex suspendedContext.
                            con receiver isNil ifTrue:[
                                ((m := con sender method) notNil and:[ m isJavaMethod ]) ifTrue:[
                                    JavaVM throwNullPointerException.
                                    AbortSignal raise.
                                    
                                    "/ ex proceed.
                                ]
                            ].
                            ex reject.
                        ]
                        do:[
                            "/ Transcript showCR:(Timestamp now printString , 'start thread: ', stProcess name).
                            [
                                javaThreadObject instVarNamed:'tid' put:javaProcess id.
                                JavaUnhandledThreadDeathError handle:[ 
                                    "/ Ignore unhandled ThreadDeath, see Thread#stop()
                                ] do:[
                                    javaThreadObject perform:#'run()V'.
                                ].
                                (Smalltalk at:#'JavaVM:ThreadTrace') == true ifTrue:[
                                    Logger 
                                        log:('thread ' , javaProcess name , ' terminated')
                                        severity:Logger severityDEBUG
                                        facility:'JVM'.
                                ].
                            ] ensure:[
                                javaThreadObject perform:#'exit()V'.
                                (Smalltalk at:#'JavaVM:ThreadTrace') == true ifTrue:[
                                    Logger 
                                        log:('after exit of thread ' , javaProcess name)
                                        severity:Logger severityDEBUG
                                        facility:'JVM'.
                                ]
                            ]
                        ]
                    ]
            ] ensure:[
                javaProcess == (Smalltalk at:#'JavaVM:JavaScreenUpdaterThread') ifTrue:[
                    Smalltalk at:#'JavaVM:JavaScreenUpdaterThread' put:nil.
                ].
                javaProcess == (Smalltalk at:#'JavaVM:JavaEventQueueThread') ifTrue:[
                    Smalltalk at:#'JavaVM:JavaEventQueueThread' put:nil.
                ].
                
"/                                    screenUpdaterClass := Java at:'sun.awt.ScreenUpdater'.    
"/                                    screenUpdaterClass notNil ifTrue:[
"/                                        screenUpdaterClass instVarNamed:'updater' put:nil.
"/                                    ].
                
            ]
        ]

    "Created: / 15-12-2010 / 11:06:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2011 / 12:51:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 15-08-2017 / 23:44:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaProcess class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaProcess.st,v 1.24 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaProcess.st,v 1.24 2015-03-20 12:08:00 vrany Exp $'
!

version_SVN
    ^ 'Id'
! !

