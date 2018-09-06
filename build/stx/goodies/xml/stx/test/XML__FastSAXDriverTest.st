"
 COPYRIGHT (c) 2007 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/xml/stx/test' }"

"{ NameSpace: XML }"

TestCase subclass:#FastSAXDriverTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-Tests'
!

!FastSAXDriverTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!FastSAXDriverTest methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!FastSAXDriverTest methodsFor:'tests'!

test1
    |s|

    s := ReadStream on:'<foo>bla</foo>'.

    FastSAXDriver
	on:s
	beforeScanDo:[:parser |

	].

    "
     self run:#test1
     self new test1
    "

    "Modified: / 19-11-2007 / 15:58:06 / cg"
!

test2
    |s|

    s := ReadStream on:'<foo>
bla
</foo>'.

    FastSAXDriver
	on:s
	beforeScanDo:[:parser |

	].

    "
     self run:#test2
     self new test2
    "

    "Modified: / 19-11-2007 / 15:58:09 / cg"
!

test3
    |s|

    s := ReadStream on:'<foo>
<bar>bla</bar>
</foo>'.

    FastSAXDriver
	on:s
	beforeScanDo:[:parser |

	].

    "
     self run:#test3
     self new test3
    "

    "Modified: / 19-11-2007 / 15:58:11 / cg"
!

test4
    |s|

    s := ReadStream on:'<foo>
<bar>bla1</bar>
<baz>bla2</baz>
</foo>'.

    FastSAXDriver
	on:s
	beforeScanDo:[:parser |

	].

    "
     self run:#test4
     self new test4
    "

    "Created: / 18-11-2007 / 12:23:47 / cg"
    "Modified: / 19-11-2007 / 15:58:14 / cg"
!

test8
    |s|

    s := ('C:\Dokumente und Einstellungen\ca\workB\exept\expecco\projects\expecco\eXpeccoSelfTest.xcmp'
	    asFilename readStream).
    FastSAXDriver
	on:s
	beforeScanDo:[:parser |

	].
    s close.

    "
     self run:#test8
     self new test8
     Time millisecondsToRun:[
	self new test8
     ]
2373 2294 2443
    "

    "Created: / 18-11-2007 / 12:29:19 / cg"
    "Modified: / 19-11-2007 / 15:58:16 / cg"
!

test8b
    |s|

    s := ('C:\Dokumente und Einstellungen\ca\workB\exept\expecco\projects\expecco\eXpeccoSelfTest.xcmp'
	    asFilename readStream).
    FastSAXDriver
	on:s
	beforeScanDo:[:parser |
	    parser validate:false
	].
    s close.

    "
     self run:#test8b
     self new test8b
     Time millisecondsToRun:[
	self new test8b
     ]
    "

    "Created: / 18-11-2007 / 12:29:19 / cg"
    "Modified: / 19-11-2007 / 15:58:16 / cg"
!

test9
    |s|

    'c:\expeccoDB' asFilename directoryContentsAsFilenamesDo:[:fn |
	fn isDirectory ifFalse:[
	    Transcript showCR:fn.
	    s := fn readStream.

	    FastSAXDriver
		on:s
		beforeScanDo:[:parser |

		].
	    s close.
	].
    ].

    "
     self run:#test9
     self new test9
     Time millisecondsToRun:[
	self new test9
     ]
2373 2294 2443
    "

    "Created: / 18-11-2007 / 12:29:19 / cg"
    "Modified: / 19-11-2007 / 15:58:16 / cg"
! !

!FastSAXDriverTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/test/XML__FastSAXDriverTest.st,v 1.3 2014-07-01 10:09:25 cg Exp $'
! !
