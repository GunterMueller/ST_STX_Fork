"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#BecomeTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!


!BecomeTests methodsFor:'tests'!

test01_become
    "Test the two way become. Note. we cannot use string literals for this test"

    | a b c d |

    a := c := '123' copy.
    b := d := 'cd' copy.

    a become: b.

    self 
        assert: a = 'cd';
        assert: b = '123';
        assert: c = 'cd';
        assert: d = '123'.


    "
     self new test01_become
    "

    "Created: / 30-04-2016 / 09:39:09 / cg"
!

test10_becomeForward
    "Test the forward become."

    | a b c d |

    a := 'ab' copy.
    b := 'cd' copy.
    c := a.
    d := b.

    a becomeForward: b.

    self 
        assert: a = 'cd';
        assert: b = 'cd';
        assert: c = 'cd';
        assert: d = 'cd'.


    "
     self new test10_becomeForward
    "

    "Created: / 30-04-2016 / 09:39:19 / cg"
!

test11_becomeForwardDontCopyIdentityHash
    "Check that
        1. the argument to becomeForward: is NOT modified to have the receiver's identity hash.
        2. the receiver's identity hash is unchanged."

    | a b hb |

    a := 'ab' copy.
    b := 'cd' copy.
    hb := b identityHash.

    a becomeForward: b copyHash: false.

    self 
        assert: a identityHash = hb;
        assert: b identityHash = hb.

    "
     self new test11_becomeForwardDontCopyIdentityHash
    "

    "Created: / 30-04-2016 / 09:39:30 / cg"
!

test12_becomeForwardHash
    | a b c hb |

    a := 'ab' copy.
    b := 'cd' copy.
    c := a.
    hb := b hash.

    a becomeForward: b.

    self 
        assert: a hash = hb;
        assert: b hash = hb;
        assert: c hash = hb.

    "
     self new test12_becomeForwardHash
    "

    "Created: / 30-04-2016 / 09:39:38 / cg"
!

test13_becomeForwardIdentityHash
    "Check that
            1. the argument to becomeForward: is modified to have the receiver's identity hash.
            2. the receiver's identity hash is unchanged."

    | a b ha |

    a := 'ab' copy.
    b := 'cd' copy.
    ha := a identityHash.

    a becomeForward: b.

    self 
        assert: a identityHash = ha;
        assert: b identityHash = ha.


    "
     self new test13_becomeForwardIdentityHash
    "

    "Created: / 30-04-2016 / 09:39:45 / cg"
!

test50_becomeHash

    | a b c d ha hb |

    a := c := 'ab' copy.
    b := d := 'cd' copy.

    ha := a hash.
    hb := b hash.

    a become: b.

    self 
        assert: a = 'cd';
        assert: b = 'ab';
        assert: c = 'cd';
        assert: d = 'ab';
        assert: a hash = hb;
        assert: b hash = ha;
        assert: c hash = hb;
        assert: d hash = ha.


    "
     self new test50_becomeHash
    "

    "Created: / 30-04-2016 / 09:39:53 / cg"
!

test51_becomeIdentityHash
    "Note. The identity hash of both objects seems to change after the become:"

    | a b c d |

    a := 'ab' copy.
    b := 'cd' copy.
    c := a.
    d := b.

    a become: b.

    self 
        assert: a identityHash = c identityHash;
        assert: b identityHash = d identityHash;
        deny: a identityHash = b identityHash.

    "
     self new test51_becomeIdentityHash
    "

    "Created: / 30-04-2016 / 09:40:02 / cg"
!

test60_becomeArray
    | a b  |

    a := Array new:0.
    b := Array new:0.

    a add: 1.
    ObjectMemory garbageCollect.
    b add: 1.
    ObjectMemory garbageCollect.
    a add: 2.
    ObjectMemory garbageCollect.
    b add: 2.
    ObjectMemory garbageCollect.
    a printString.
    b printString.
    self 
        assert: a size == 2;
        assert: b size == 2.

    "
     self new test60_becomeArray
    "

    "Created: / 30-04-2016 / 09:40:02 / cg"
!

test61_becomeArray
    | a b  |

    a := Array new:0.
    b := Array new:0.

    50 timesRepeat:[
        a add: 1.
        ObjectMemory garbageCollect.
        b add: 1.
        ObjectMemory garbageCollect.
    ].        
    self 
        assert: a size == 50;
        assert: b size == 50.

    "
     self new test61_becomeArray
    "
! !

!BecomeTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

