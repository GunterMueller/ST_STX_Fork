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
"{ Package: 'stx:libjava/experiments' }"

"{ NameSpace: Benchmarks }"

Object subclass:#JavaLookup
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'benchmarks-Misc'
!

Object subclass:#B2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaLookup
!

!JavaLookup class methodsFor:'documentation'!

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

!JavaLookup class methodsFor:'benchmarks - direct'!

direct1

    |b2|

    b2 := B2 new.
    Time millisecondsToRun: [
        30000 timesRepeat:[
            b2 method1.
        ].
    ].

    "Created: / 26-12-2011 / 21:19:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

direct2

    |b2|

    b2 := B2 new.
    Time millisecondsToRun: [
        30000 timesRepeat:[
            b2 method2.
        ].
    ].

    "Created: / 26-12-2011 / 21:19:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup class methodsFor:'benchmarks - overload'!

overload1

    |string integer boolean b1|

    string := Java as_String: 's'.
    integer := (Java as_Integer: 10).
    boolean := (Java as_Boolean: true).

    b1 := (Java classForName: 'stx.libjava.benchmarks.B1') new.
    Time millisecondsToRun: [
        10000 timesRepeat:[
            b1 overload1: string.
            b1 overload1: integer.
            b1 overload1: boolean.
        ].
    ].

    "Created: / 26-12-2011 / 21:14:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

overload2

    |string b1|

    string := Java as_String: 's'.

    b1 := (Java classForName: 'stx.libjava.benchmarks.B1') new.
    Time millisecondsToRun: [
        30000 timesRepeat:[
            b1 overload2: string.
        ].
    ].

    "Created: / 26-12-2011 / 21:15:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup class methodsFor:'running'!

run: label

    "
        self run: 'Multiple dispatch'
    "
    | s |
    s := "/'/home/jv/Research/PhD thesis/benchmarks/MOP.csv'
           '/tmp/multiple_dispatch.csv'
            asFilename appendStream.
    [
    #(
    overload1
    overload2
    direct1
    direct2
    ) do:
        [:bench|
        self put: label to: s.
        self put: bench to: s.
        6 timesRepeat:[self put: (self time: bench) to: s].
        s cr].
    ] ensure:[
        s close
    ]

    "Created: / 02-08-2010 / 17:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-01-2012 / 21:37:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup class methodsFor:'utils'!

put: o to: s

    s nextPut:$".
    o printOn: s.
    s nextPut:$".
    s nextPut:$,.
    s space.
    s flush

    "Created: / 02-08-2010 / 17:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

time: bench

    ObjectMemory flushCaches.
    ^Time millisecondsToRun:[20 timesRepeat:[self perform: bench]].

    "Created: / 02-08-2010 / 17:39:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::B2 methodsFor:'methods'!

method1

    ^1

    "Created: / 26-12-2011 / 21:18:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method2

    ^self method1

    "Created: / 26-12-2011 / 21:18:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/experiments/Benchmarks__JavaLookup.st,v 1.5 2015-03-20 13:29:44 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Benchmarks__JavaLookup.st,v 1.5 2015-03-20 13:29:44 vrany Exp $'
! !

