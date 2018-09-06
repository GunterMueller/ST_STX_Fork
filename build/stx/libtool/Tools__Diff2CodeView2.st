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

"{ NameSpace: Tools }"

DiffCodeView2 subclass:#Diff2CodeView2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

Object subclass:#Diff2Data
	instanceVariableNames:'text1 text2 inserted deleted changed'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff2CodeView2
!

!Diff2CodeView2 class methodsFor:'documentation'!

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
! !

!Diff2CodeView2::Diff2Data methodsFor:'accessing'!

changed

    ^changed copy

    "Modified: / 02-05-2010 / 19:31:18 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 16-07-2010 / 09:35:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changed:something
    changed := something.
!

deleted
    ^ deleted
!

deleted:something
    deleted := something.
!

inserted
    ^ inserted
!

inserted:something
    inserted := something.
!

text1
    ^ text1
!

text1:something
    text1 := something.
!

text2
    ^ text2
!

text2:something
    text2 := something.
! !

!Diff2CodeView2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__Diff2CodeView2.st,v 1.3 2015-02-13 19:27:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__Diff2CodeView2.st,v 1.3 2015-02-13 19:27:24 cg Exp $'
! !

