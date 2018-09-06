"{ Package: 'stx:libjava/benchmarks' }"

"{ NameSpace: Smalltalk }"

JavaBenchmark subclass:#OverloadedMethods2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Benchmarks-Java-Obsolete-Micro'
!


!OverloadedMethods2 methodsFor:'running'!

doSmth_1: i
   ^self

!

doSmth_2:f
   ^self

!

doSmth_3:c
   ^self

!

doSmth_4:f
   ^self

!

doSmth_5:f
   ^self

!

doSmth_6:f
   ^self

!

doSmth_7:f
   ^self

!

doSmth_8:f
   ^self

!

doSmth_9:f
   ^self

!

runBenchmarkS2J:n 
    | inst  o |

    inst := JAVA stx libjava benchmarks OverloadedMethods2 new.
    o := JAVA java lang Object new.
    ^ Time 
        millisecondsToRun:[
            1 to:n do:[:idx | 
                inst doSmth:0.
                inst doSmth:''.
                inst doSmth:o.
                inst doSmth:$c.
                inst doSmth:1.
                inst doSmth:false
            ].
        ].

    "Created: / 31-10-2012 / 23:37:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runBenchmarkS:n 
    | inst o |

    inst := self class new.
    o := Object new.        
    ^ Time 
        millisecondsToRun:[
            1 to:n do:[:idx | 
                inst doSmth_1:0.
                inst doSmth_2:1.23345.
                inst doSmth_4:o.
                inst doSmth_5:''.
                inst doSmth_6:$c.
                inst doSmth_7:1.
                inst doSmth_8:1.
                inst doSmth_9:false.
            ].
        ].

    "Modified: / 04-11-2012 / 21:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!OverloadedMethods2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/benchmarks/OverloadedMethods2.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

