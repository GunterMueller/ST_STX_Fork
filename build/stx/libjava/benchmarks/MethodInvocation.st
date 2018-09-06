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
"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#MethodInvocation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!

!MethodInvocation class methodsFor:'documentation'!

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
!

history

    "Created: #run / 13-09-2012 / 22:27:57 / mh <marcel.hlopko@fit.cvut.cz>"
! !

!MethodInvocation methodsFor:'running'!

doSmth
   ^self
!

runBenchmarkS2J:n 
    | inst |

    inst := JAVA stx libjava benchmarks MethodInvocation new.
    ^ Time 
        millisecondsToRun:[
            1 to:n do:[:idx | 
                inst doSmth
            ].
        ].

    "Created: / 04-11-2012 / 21:22:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runBenchmarkS:n 
    | inst |

    inst := self class new.
    ^ Time 
        millisecondsToRun:[ 
            1 to: n do: [:idx|
                inst doSmth
            ] ].
! !

!MethodInvocation class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/MethodInvocation.st,v 1.5 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

