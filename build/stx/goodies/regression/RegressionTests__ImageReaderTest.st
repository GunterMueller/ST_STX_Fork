"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ImageReaderTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!ImageReaderTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	cg (cg@AQUA-DUO)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ImageReaderTest methodsFor:'tests'!

test001_bmp
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/bmpImages/test1.bmp').
    self assert:(img notNil).
    self assert:(img depth == 1).

    "/ img inspect.

    self assert:((img colorAtX:0 y:0) rgbValue = 16r4040FF).
    self assert:((img colorAtX:0 y:63) rgbValue = 16r4040FF).
    self assert:((img colorAtX:0 y:18) rgbValue = 16r40FF40).

    "
     self run:#test001_bmp
     self new test001_bmp"
!

test002_bmp
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/bmpImages/test4.bmp').
    self assert:(img notNil).
    self assert:(img depth == 4).

    self assert:((img colorAtX:0 y:15) rgbValue = 16rFF0000).
    self assert:((img colorAtX:35 y:15) rgbValue = 16r004000).
    self assert:((img colorAtX:35 y:30) rgbValue = 16r008000).
    self assert:((img colorAtX:35 y:45) rgbValue = 16r00C000).
    self assert:((img colorAtX:35 y:60) rgbValue = 16r00FF00).
    self assert:((img colorAtX:70 y:15) rgbValue = 16r0000FF).

    "/ img inspect.
    "
     self run:#test002_bmp
     self new test002_bmp"
!

test003_bmp
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/bmpImages/test8.bmp').
    self assert:(img notNil).
    self assert:(img depth == 8).
    self assert:((img colorAtX:30 y:0) rgbValue = 16rFF0000).

    "/ img inspect
    "
     self run:#test003_bmp
     self new test003_bmp"
!

test004_bmp
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/bmpImages/testcompress4.bmp').
    self assert:(img notNil).
    self assert:(img depth == 4).
    self assert:((img colorAtX:0 y:15) rgbValue = 16rFF0000).
    self assert:((img colorAtX:35 y:15) rgbValue = 16r004000).
    self assert:((img colorAtX:35 y:30) rgbValue = 16r008000).
    self assert:((img colorAtX:35 y:45) rgbValue = 16r00C000).
    self assert:((img colorAtX:35 y:60) rgbValue = 16r00FF00).
    self assert:((img colorAtX:70 y:15) rgbValue = 16r0000FF).

    "/ img inspect.
    "
     self run:#test004_bmp
     self new test004_bmp"
!

test005_bmp
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/bmpImages/testcompress8.bmp').
    self assert:(img notNil).
    self assert:(img depth == 8).
    self assert:((img colorAtX:30 y:0) rgbValue = 16rFF0000).

    "/ img inspect.
    "
     self run:#test005_bmp
     self new test005_bmp"
!

test006_bmp
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/bmpImages/test8os2.bmp').
    self assert:(img notNil).

    "/ img inspect.
    "
     self run:#test006_bmp
     self new test006_bmp"
!

test007_bmp
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/bmpImages/test4os2v2.bmp').
    self assert:(img notNil).

    "/ img inspect.
    "
     self run:#test007_bmp
     self new test007_bmp"
!

test008_bmp
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/bmpImages/test16.bmp').
    self assert:(img notNil).

    "/ img inspect.
    "
     self run:#test008_bmp
     self new test008_bmp"
!

test009_bmp
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/bmpImages/test24.bmp').
    self assert:(img notNil).

    "/ img inspect.
    "
     self run:#test009_bmp
     self new test009_bmp"
!

test010_bmp
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/bmpImages/test32.bmp').
    self assert:(img notNil).

    "/ img inspect.
    "
     self run:#test010_bmp
     self new test010_bmp"
!

test101
    |alpha s bits img|

    img := Depth32Image width:16 height:16.
    alpha := #[
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255

		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255

		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255

		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
		    0 0 0 0 63 63 63 63 127 127 127 127 255 255 255 255
	      ].
    s := WriteStream on:#[].
    alpha do:[:a |
	s nextPut:127.    "/ r
	s nextPut:127.    "/ g
	s nextPut:127.    "/ b
	s nextPut:a.
    ].

    bits := (s contents).
    img bits:bits.
    "/ img inspect.

    "
     self run:#test101
     self new test101
    "
!

testPNG_001_basn0g01
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/pngImages/basn0g01.png').
    self assert:(img notNil).
    self assert:(img depth == 1).
    self assert:(img extent = (32@32)).
    self assert:(img colorAt:(0@0)) = Color white.
    self assert:(img colorAt:(31@31)) = Color black.

    "/ img inspect.
    "
     self run:#testPNG_001_basn0g01
     self new testPNG_001_basn0g01
    "

    "Created: / 05-02-2011 / 10:32:32 / cg"
!

testPNG_002_basn0g02
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/pngImages/basn0g02.png').
    self assert:(img notNil).
    self assert:(img depth == 2).
    self assert:(img extent = (32@32)).
    self assert:(img colorAt:(0@0)) rgbValue = 0.
    self assert:(img colorAt:(31@31)) rgbValue = 16rAAAAAA.

    "/ img inspect.
    "
     self run:#testPNG_002_basn0g02
     self new testPNG_002_basn0g02
    "

    "Created: / 05-02-2011 / 10:33:24 / cg"
!

testPNG_003_basi0g01
    |img|

    img := Image fromFile:(self class packageDirectory construct:'testData/pngImages/basi0g01.png').
    self assert:(img notNil).
    self assert:(img depth == 1).
    self assert:(img extent = (32@32)).
    self assert:(img colorAt:(0@0)) = Color white.
    self assert:(img colorAt:(31@31)) = Color black.
    "/ img inspect.

    "
     self run:#testPNG_003_basi0g01
     self new testPNG_003_basi0g01
    "

    "Created: / 05-02-2011 / 10:32:32 / cg"
!

test_bmp_01
    |img allOK failed|

    failed := OrderedCollection new.
    allOK := true.
    (self class packageDirectory construct:'testData/bmpImages') directoryContentsAsFilenamesDo:[:f |
	(f isRegularFile and:[f hasSuffix:'bmp']) ifTrue:[
	    Error handle:[:ex |
		img := nil.
	    ] do:[
		img := Image fromFile:f.
	    ].
	    img isNil ifTrue:[
		Transcript printf:'failed: %s\n' with:f baseName.
		allOK := false.
		failed add:f baseName.
	    ].
	].
    ].
    self assert:allOK description:('failed to read: %s' printfWith:(failed asStringWith:', ')).

    "
     self run:#test_bmp_01
     self new test_bmp_01
    "
!

test_bmp_02
    |img allOK failed|

    failed := OrderedCollection new.
    allOK := true.
    (self class packageDirectory construct:'testData/bmpImages/bmpsuite-2.4') directoryContentsAsFilenamesDo:[:f |
	(f isRegularFile and:[f hasSuffix:'bmp']) ifTrue:[
	    Error handle:[:ex |
		img := nil.
	    ] do:[
		img := Image fromFile:f.
	    ].
	    img isNil ifTrue:[
		Transcript printf:'failed: %s\n' with:f baseName.
		allOK := false.
		failed add:f baseName.
	    ].
	].
    ].
    self assert:allOK description:('failed to read: %s' printfWith:(failed asStringWith:', ')).

    "
     self run:#test_bmp_02
     self new test_bmp_02
    "
!

test_png_01
    "/ currently, 4 files fail;
    "/ these are greyscale+alpha images

    |img allOK failed|

    failed := OrderedCollection new.
    allOK := true.
    (self class packageDirectory construct:'testData/pngImages') directoryContentsAsFilenamesDo:[:f |
	(f isRegularFile and:[f hasSuffix:'png']) ifTrue:[
	    img := nil.
	    (f baseName startsWith:'x') ifTrue:[
		"/ should fail
		self should:[ img := Image fromFile:f ] raise:(Image badImageFormatQuerySignal).
		self assert:img == nil.
	    ] ifFalse:[
		Error handle:[:ex |
		    img := nil.
		] do:[
                    img := Image fromFile:f.
		].
		img isNil ifTrue:[
		    Transcript printf:'failed: %s\n' with:f baseName.
		    allOK := false.
		    failed add:f baseName.
		].
	    ].
	].
    ].
    "/ self assert:allOK description:('failed to read: %s' printfWith:(failed asStringWith:', ')).
    allOK ifFalse:[
	self assert:(failed size == 4) description:('failed to read: %s' printfWith:(failed asStringWith:', ')).
    ].

    "
     self run:#test_png_01
     self new test_png_01
    "

    "Modified (comment): / 08-03-2016 / 18:21:01 / cg"
!

test_png_02
    |referenceImg img|

    img := Image fromFile:(self class packageDirectory construct:'testData/pngImages/basn0g01.png').
    self assert:(img notNil).

    referenceImg := (Depth1Image new) width: 32; height: 32;
			    photometric:(#palette);
			    bitsPerSample:(#[1]);
			    samplesPerPixel:(1);
			    bits:(ByteArray fromPackedString:'
?????/????3????8????<OO3?>C3<??@<?O? OL3?0C3L?8@<3O<@O G>@C8A?@@?L? @O3O0@C??8@@??<@@O?>@@C??@@@?? O8O?0C>C?8@00?<@LLO>@
C>C?@@? ? @LLO0@CCC8@@? <@@O8N@@@@C@@@@@ @@@@@@@@@@b') ;
			    colorMapFromArray:#[0 0 0 255 255 255];
			    yourself.

    self assert:(img bits = referenceImg bits).
    self assert:(img width = referenceImg width).
    self assert:(img height = referenceImg height).
    self assert:(img depth = referenceImg depth).
    self assert:(img bitsPerSample asArray = referenceImg bitsPerSample asArray).
    self assert:(img samplesPerPixel = referenceImg samplesPerPixel).
    self assert:(img colorFromValue:0) = (referenceImg colorFromValue:0).
    self assert:(img colorFromValue:1) = (referenceImg colorFromValue:1).

    "
     self run:#test_png_02
     self new test_png_02
    "
! !

!ImageReaderTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

