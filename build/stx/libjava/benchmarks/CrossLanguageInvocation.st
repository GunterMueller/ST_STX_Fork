"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#CrossLanguageInvocation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!


!CrossLanguageInvocation methodsFor:'running'!

doSmth
   ^self
!

runBenchmarkS2J:n 
    | inst |

    inst := JAVA stx libjava benchmarks CrossLangInvocation new.
    ^ Time 
        millisecondsToRun:[
            1 to: n do: [:idx|
                inst doSmth
            ].
        ]

    "Created: / 31-10-2012 / 23:37:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

!CrossLanguageInvocation class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/CrossLanguageInvocation.st,v 1.5 2015-03-20 12:08:01 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

