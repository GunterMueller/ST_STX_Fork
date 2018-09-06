"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#Hash
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!


!Hash methodsFor:'running'!

runBenchmarkS:n 
    | count  table |

    count := 0.
    table := Dictionary new:n + (n // 5).
    ^ Time 
        millisecondsToRun:[
            1 to:n do:[:each | 
                table at:(each printStringRadix:16) put:each
            ].
            1 to:n do:[:each | 
                (table includesKey:(each printStringRadix:10)) ifTrue:[
                    count := count + 1
                ]
            ].
        ].
! !

!Hash class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/Hash.st,v 1.5 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

