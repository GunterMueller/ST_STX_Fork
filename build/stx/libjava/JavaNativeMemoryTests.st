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

TestCase subclass:#JavaNativeMemoryTests
	instanceVariableNames:'mem'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaNativeMemoryTests class methodsFor:'documentation'!

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

!JavaNativeMemoryTests methodsFor:'initialization & release'!

setUp
    mem := JavaNativeMemory new.
    mem defaultMallocatedMemoryChunkSize:16"B"

    "Created: / 11-07-2012 / 09:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemoryTests methodsFor:'tests-malloc/free'!

test_01

    mem malloc: 8.
    mem malloc: 8.
    mem malloc: 8.

    self assert: mem chunks size == 2

    "Created: / 11-07-2012 / 09:15:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02a

    | addr1 addr2 |

    addr1 := mem malloc: 8.
    addr2 := mem malloc: 8.
    mem free: addr1.
    mem free: addr2.
    mem malloc: 16.

    self assert: mem chunks size  == 1

    "Created: / 11-07-2012 / 09:32:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02b

    | addr1 addr2 |

    addr1 := mem malloc: 8.
    addr2 := mem malloc: 8.
    mem free: addr2.
    mem free: addr1.
    mem malloc: 16.

    self assert: mem chunks size == 1

    "Created: / 11-07-2012 / 09:32:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02c

    | addr1 addr2 addr3 |

    addr1 := mem malloc: 4.
    addr2 := mem malloc: 4.
    addr3 := mem malloc: 8.
    mem free: addr2.
    mem free: addr1.
    mem free: addr3.
    mem malloc: 16.

    self assert: mem chunks size == 1

    "Created: / 11-07-2012 / 09:33:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02d

    | addr1 addr2 addr3 |

    addr1 := mem malloc: 4.
    addr2 := mem malloc: 4.
    addr3 := mem malloc: 8.
    mem free: addr2.
    mem free: addr3.
    mem free: addr1.
    mem malloc: 16.

    self assert: mem chunks size == 1

    "Created: / 11-07-2012 / 09:33:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03

    | addr1 addr2 |

    addr1 := mem malloc: 16.
    addr2 := mem malloc: 16.

    mem byteAt: addr1 put: 10.
    mem byteAt: addr1 + 15 put: 9.
    mem byteAt: addr2 put: 30.
    mem byteAt: addr2 + 15 put: 33.

    self assert: (mem byteAt: addr1) == 10.
    self assert: (mem byteAt: addr1 + 15) == 9.
    self assert: (mem byteAt: addr2) == 30.
    self assert: (mem byteAt: addr2 + 15) == 33.

    "Created: / 11-07-2012 / 10:03:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemoryTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaNativeMemoryTests.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

