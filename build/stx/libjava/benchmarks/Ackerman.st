"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#Ackerman
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!


!Ackerman methodsFor:'running'!

runBenchmarkS:n 
    ^ Time millisecondsToRun:[ 3 ackermann:n ].
! !

!Ackerman class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/Ackerman.st,v 1.5 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

