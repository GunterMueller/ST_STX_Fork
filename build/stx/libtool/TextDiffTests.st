"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#TextDiffTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable-Diff'
!

TextDiffTests comment:'asdfasfsafsafsa
'
!

!TextDiffTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"


"
! !

!TextDiffTests methodsFor:'default'!

testForward
    |diff change first second|

    first := #( 'aaa' 'lll' ).
    second := #( 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' ).
    diff := Diff new.
    diff a:first b:second.
    change := diff diff:false.
    self deny:(change = nil).
    self assert:(change deleted = 0).
    self assert:(change inserted = 2).
    self assert:(change line0 = 1).
    self assert:(change line1 = 1).
    change := change nextLink.
    self deny:(change = nil).
    self assert:(change deleted = 0).
    self assert:(change inserted = 7).
    self assert:(change line0 = 2).
    self assert:(change line1 = 4).
    self assert:(change nextLink = nil).

    "Modified: / 12-02-2010 / 14:23:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testForward1
    "comment stating purpose of this message"
    
    |d a b result|

    a := ''.
    b := ''.
    d := Diff new.
    d a:a b:b.
    result := d diffUsingScript:(Diff::ForwardScript new).
    self assert:(result = nil).

    "Modified: / 12-02-2010 / 13:57:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testForward10
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaaa' 'aaa' 'bbbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' 'ccccc' 'ccccc' ).
    b := #( 'aaa' 'aaaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diff:false.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 0).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 4).
    self assert:(result line0 = 2).
    self assert:(result line1 = 1).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 1).
    self assert:(result line0 = 4).
    self assert:(result line1 = 6).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 9).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 2).
    self assert:(result inserted = 0).
    self assert:(result line0 = 8).
    self assert:(result line1 = 16).
    self assert:(result nextLink = nil).
!

testForward2
    "comment stating purpose of message"
    
    |d a b result|

    a := ''.
    b := #( 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' ).
    d := Diff new.
    d a:a b:b.
    result := d diff:false.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 11).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    self assert:(result nextLink = nil).
!

testForward3
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaa' 'lll' ).
    b := ''.
    d := Diff new.
    d a:a b:b.
    result := d diff:false.
    self deny:(result = nil).
    self assert:(result deleted = 2).
    self assert:(result inserted = 0).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    self assert:(result nextLink = nil).
!

testForward4
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaa' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'aaa' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' ).
    d := Diff new.
    d a:a b:b.
    result := d diff:false.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 1).
    self assert:(result line1 = 1).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 6).
    self assert:(result line0 = 5).
    self assert:(result line1 = 10).
    self assert:(result nextLink = nil).
!

testForward5
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaa' 'aaa' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diff:false.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 2).
    self assert:(result line1 = 2).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 4).
    self assert:(result line1 = 9).
    self assert:(result nextLink = nil).
!

testForward6
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaa' 'aaa' 'bbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diff:false.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 3).
    self assert:(result line0 = 2).
    self assert:(result line1 = 2).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 1).
    self assert:(result line0 = 3).
    self assert:(result line1 = 6).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 9).
    self assert:(result nextLink = nil).
!

testForward7
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaa' 'aaa' 'bbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diff:false.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 3).
    self assert:(result line0 = 2).
    self assert:(result line1 = 2).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 1).
    self assert:(result line0 = 4).
    self assert:(result line1 = 7).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 10).
    self assert:(result nextLink = nil).
!

testForward8
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaaa' 'aaa' 'bbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diff:false.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 0).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 4).
    self assert:(result line0 = 2).
    self assert:(result line1 = 1).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 1).
    self assert:(result line0 = 4).
    self assert:(result line1 = 6).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 9).
    self assert:(result nextLink = nil).
!

testForward9
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaaa' 'aaa' 'bbbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diff:false.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 0).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 4).
    self assert:(result line0 = 2).
    self assert:(result line1 = 1).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 1).
    self assert:(result line0 = 4).
    self assert:(result line1 = 6).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 9).
    self assert:(result nextLink = nil).
!

testForward9NoDiscards
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaaa' 'aaa' 'bbbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d nodiscards:true.
    d a:a b:b.
    result := d diff:false.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 0).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 4).
    self assert:(result line0 = 2).
    self assert:(result line1 = 1).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 1).
    self assert:(result line0 = 4).
    self assert:(result line1 = 6).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 9).
    self assert:(result nextLink = nil).
!

testReverse
    |diff change first second|

    first := #( '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' ).
    second := #( '1' '2' '3' '5' '7' '8' '8' '9' '10' '11' '11' '12' '13' ).
    diff := Diff new.
    diff a:first b:second.
    change := diff diff:false.
    self assert:(change ~= nil).

    "Modified: / 12-02-2010 / 14:23:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testReverse1
    "comment stating purpose of message"
    
    |d a b result|

    a := ''.
    b := ''.
    d := Diff new.
    d a:a b:b.
    result := d diff:false.
    self assert:(result = nil).
!

testReverse10
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaaa' 'aaa' 'bbbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' ',' 'ccccc' ',' 'ccccc' ).
    b := #( 'aaa' 'aaaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diffUsingScript:(Diff::ReverseScript new).
    self deny:(result = nil).
    self assert:(result deleted = 4).
    self assert:(result inserted = 0).
    self assert:(result line0 = 8).
    self assert:(result line1 = 16).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 9).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 1).
    self assert:(result line0 = 4).
    self assert:(result line1 = 6).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 4).
    self assert:(result line0 = 2).
    self assert:(result line1 = 1).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 0).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    self assert:(result nextLink = nil).
!

testReverse2
    "comment stating purpose of message"
    
    |d a b result|

    a := ''.
    b := #( 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' ).
    d := Diff new.
    d a:a b:b.
    result := d diffUsingScript:(Diff::ReverseScript new).
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 11).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    self assert:(result nextLink = nil).
!

testReverse3
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaa' 'lll' ).
    b := ''.
    d := Diff new.
    d a:a b:b.
    result := d diffUsingScript:(Diff::ReverseScript new).
    self deny:(result = nil).
    self assert:(result deleted = 2).
    self assert:(result inserted = 0).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    self assert:(result nextLink = nil).
!

testReverse4
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaa' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'aaa' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' ).
    d := Diff new.
    d a:a b:b.
    result := d diffUsingScript:(Diff::ReverseScript new).
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 6).
    self assert:(result line0 = 5).
    self assert:(result line1 = 10).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 1).
    self assert:(result line1 = 1).
    self assert:(result nextLink = nil).
!

testReverse5
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaa' 'aaa' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diffUsingScript:(Diff::ReverseScript new).
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 4).
    self assert:(result line1 = 9).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 2).
    self assert:(result line1 = 2).
    self assert:(result nextLink = nil).
!

testReverse6
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaa' 'aaa' 'bbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diffUsingScript:(Diff::ReverseScript new).
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 9).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 1).
    self assert:(result line0 = 3).
    self assert:(result line1 = 6).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 3).
    self assert:(result line0 = 2).
    self assert:(result line1 = 2).
    self assert:(result nextLink = nil).
!

testReverse7
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaa' 'aaa' 'bbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaa' 'jjj' 'kkk' 'lll' 'bbb' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diffUsingScript:(Diff::ReverseScript new).
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 10).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 1).
    self assert:(result line0 = 4).
    self assert:(result line1 = 7).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 3).
    self assert:(result line0 = 2).
    self assert:(result line1 = 2).
    self assert:(result nextLink = nil).
!

testReverse8
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaaa' 'aaa' 'bbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diffUsingScript:(Diff::ReverseScript new).
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 9).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 1).
    self assert:(result line0 = 4).
    self assert:(result line1 = 6).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 4).
    self assert:(result line0 = 2).
    self assert:(result line1 = 1).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 0).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    self assert:(result nextLink = nil).
!

testReverse9
    "comment stating purpose of message"
    
    |d a b result|

    a := #( 'aaaa' 'aaa' 'bbbb' 'bbb' 'aaa' 'aaa' 'aaa' 'aaa' ).
    b := #( 'aaa' 'aaaa' 'jjj' 'kkk' 'lll' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
    d := Diff new.
    d a:a b:b.
    result := d diffUsingScript:(Diff::ReverseScript new).
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 5).
    self assert:(result line0 = 6).
    self assert:(result line1 = 9).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 0).
    self assert:(result inserted = 1).
    self assert:(result line0 = 4).
    self assert:(result line1 = 6).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 4).
    self assert:(result line0 = 2).
    self assert:(result line1 = 1).
    result := result nextLink.
    self deny:(result = nil).
    self assert:(result deleted = 1).
    self assert:(result inserted = 0).
    self assert:(result line0 = 0).
    self assert:(result line1 = 0).
    self assert:(result nextLink = nil).
! !

!TextDiffTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/TextDiffTests.st,v 1.2 2014-02-05 18:56:59 cg Exp $'
!

version_SVN
    ^ '$Id: TextDiffTests.st,v 1.2 2014-02-05 18:56:59 cg Exp $'
! !

