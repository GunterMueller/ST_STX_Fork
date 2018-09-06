"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#Ary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!


!Ary methodsFor:'running'!

runAryTest: x with: y with: n
	1 to: 1000 do: [:ignored|
			n to: 1 by: -1 do: [:i| y at: i put: (y at: i) + (x at: i)] ].
!

runBenchmarkS:n 
    | x  y |

    x := (1 to:n) asArray.
    y := Array new:n withAll:0.
    ^ Time 
        millisecondsToRun:[
            self 
                runAryTest:x
                with:y
                with:n
        ].
! !

!Ary class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/Ary.st,v 1.5 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

