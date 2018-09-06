"
 COPYRIGHT (c) 2016-2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#FormTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects-Tests'
!

!FormTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016-2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!FormTests methodsFor:'running'!

setUp
    Screen current isNil ifTrue:[
        Smalltalk openDisplay
    ].
    self skipIf: Screen current isNil description: 'Display connection not available'

    "Created: / 25-04-2016 / 20:30:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-01-2018 / 21:27:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FormTests methodsFor:'tests - regression'!

test_issue_25a
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/25
    "
    | form font bits1 bits2 |

    self skipIf: ConfigurableFeatures hasXFT not description: 'XFT support not compiled in'.
    form := Form width:32 height:32 depth:24.
    self assert: form device blackpixel = 0.
    form paint: Color black on: Color white.
    form clear.
    bits1 := form bits.
    self assert: (bits1 size \\ 4) == 0.
    1 to: bits1 size by: 4 do:[:i |
        self assert: ((i \\ 4) == 0 or:[ (bits1 at: i) == 255 ])
    ].
    font := XftFontDescription for: SimpleView defaultFont.
    form font: font.
    form displayString: 'X' x: 16 y: 16.
    bits2 := form bits.
    self assert: (bits1 size \\ 4) == 0.
    self assert: (bits1 asArray = bits2 asArray) not

    "Created: / 26-11-2016 / 00:23:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-01-2017 / 23:22:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_82
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/82
    "
    | f |
    f := Form width:8 height:8 depth:1.
    f colorMap:(Array with:Screen current blackColor with: Screen current whiteColor).
    f clear.
    f paint:(Color colorId:1).  
    self assert: (f bits allSatisfy:[:byte | byte = 0 ])

    "Created: / 25-04-2016 / 20:04:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

test_issue_88a
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/88
    "
    | f |
    f := Form width:8 height:8 depth:1.
    f colorMap:(Array with:Screen current blackColor with: Screen current whiteColor).
    f paint:(Color colorId:0) on: (Color colorId:1).
    f clear.
    f displayPointX: 1 y: 0.
    f displayPointX: 3 y: 0.
    f displayPointX: 5 y: 0.
    f displayPointX: 7 y: 0.
    f displayPointX: 1 y: 2.
    f displayPointX: 1 y: 4.
    f displayPointX: 1 y: 6.  
    f getBits.
    self assert: f bits = #[ 2r10101010 2r11111111 2r10111111  2r11111111 2r10111111  2r11111111 2r10111111 2r11111111].

    f releaseFromDevice.
    f setDevice:Screen current id:nil gcId:nil.
    f recreate.

    self assert: f bits = #[ 2r10101010 2r11111111 2r10111111  2r11111111 2r10111111  2r11111111 2r10111111 2r11111111].

    "Created: / 05-05-2016 / 22:59:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_88b
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/88
    "
    | form bits |
    form := Form width:8 height:8 depth:24.
    form paint: Color black on: Color white.
    form clear.
    bits := form bits.
    self assert: (bits size \\ 4) == 0.
    1 to: bits size by: 4 do:[:i |
        self assert: ((i \\ 4) == 0 or:[ (bits at: i) == 255 ])
    ].
    form displayPointX: 1 y: 0.
    form displayPointX: 3 y: 0.
    form displayPointX: 5 y: 0.
    form displayPointX: 7 y: 0.
    form displayPointX: 1 y: 2.
    form displayPointX: 1 y: 4.
    form displayPointX: 1 y: 6.  
    form getBits.
    bits := form bits.
    self assert: (bits size \\ 4) == 0.
    self
        "/ [0, 0]
        assert: (bits at: (0*4)+1) == 16rFF;
        assert: (bits at: (0*4)+2) == 16rFF;
        assert: (bits at: (0*4)+3) == 16rFF;
        "/ [1, 0]
        assert: (bits at: (1*4)+1) == 16r00;
        assert: (bits at: (1*4)+2) == 16r00;
        assert: (bits at: (1*4)+3) == 16r00;
        "/ [2, 0]
        assert: (bits at: (2*4)+1) == 16rFF;
        assert: (bits at: (2*4)+2) == 16rFF;
        assert: (bits at: (2*4)+3) == 16rFF.

    form releaseFromDevice.
    form setDevice:Screen current id:nil gcId:nil.
    form recreate.
    
    bits := form bits.
    self
        "/ [0, 0]
        assert: (bits at: (0*4)+1) == 16rFF;
        assert: (bits at: (0*4)+2) == 16rFF;
        assert: (bits at: (0*4)+3) == 16rFF;
        "/ [1, 0]
        assert: (bits at: (1*4)+1) == 16r00;
        assert: (bits at: (1*4)+2) == 16r00;
        assert: (bits at: (1*4)+3) == 16r00;
        "/ [2, 0]
        assert: (bits at: (2*4)+1) == 16rFF;
        assert: (bits at: (2*4)+2) == 16rFF;
        assert: (bits at: (2*4)+3) == 16rFF.

    "Created: / 05-05-2016 / 23:02:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2017 / 13:35:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_88c
    "
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/88
    "
    | form bits1 bits2 bits3 |
    form := Form width:8 height:8 depth:24.
    form paint: (Color redByte:16r10 greenByte:16r10 blueByte:16r10)   on: Color white.
    form clear.
    bits1 := form bits.
    self assert: (bits1 size \\ 4) == 0.
    1 to: bits1 size by: 4 do:[:i |
        self assert: ((i \\ 4) == 0 or:[ (bits1 at: i) == 255 ])
    ].
    form displayPointX: 1 y: 0.
    form displayPointX: 3 y: 0.
    form displayPointX: 5 y: 0.
    form displayPointX: 7 y: 0.
    form displayPointX: 1 y: 2.
    form displayPointX: 1 y: 4.
    form displayPointX: 1 y: 6.  
    form getBits.
    bits2 := form bits.
    self assert: (bits1 size \\ 4) == 0.

    form releaseFromDevice.
    form setDevice:Screen current id:nil gcId:nil.
    form recreate.
    
    bits3 := form bits.
    self assert: bits2 = bits3.

    "Created: / 12-01-2017 / 13:36:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2017 / 21:19:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FormTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'

! !

