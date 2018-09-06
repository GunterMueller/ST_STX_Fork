"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CharacterTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!CharacterTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!CharacterTests methodsFor:'tests'!

test01_CaseTesting
    "test lower/uppercase return value for all unicode characters up to 16r1C6FF (i.e. Unicode 3.2)"

    |unicodeDataFile|

    unicodeDataFile := self class packageDirectory / 'testData' / 'UnicodeData-4.0.0.txt'.
    "/ unicodeDataFile := '/Users/cg/work/exept/regression/testData/UnicodeData-4.0.0.txt' asFilename .
    "/ unicodeDataFile := '/Users/cg/work/exept/regression/testData/UnicodeData-4.0.0.txt' asFilename .

    CharacterEncoderCodeGenerator isNil ifTrue:[
	Smalltalk fileInClass:'CharacterEncoderCodeGenerator' package:'stx:goodies'
    ].

    CharacterEncoderCodeGenerator new
	readingUnicodeDataFrom:(unicodeDataFile readStream)
	do:[:codePoint :name :category :canOrd :bidiCat :decMap
	    :decDigitValue :digitValue :numValue
	    :mirrored :unicodeName :comment :ucValue :lcValue :tcValue |
		|ch ucCh lcCh tcCh isUppercase isLowercase isTitlecase isLetter dToUc dToLc|

		"/ for now, do not check above 1C6FF (i.e. only Uniode 3.2)
		codePoint <= 16r1C6FF ifTrue:[
		    isUppercase := category = 'Lu'.
		    isLowercase := category = 'Ll'.
		    isTitlecase := category = 'Lt'.
		    isLetter := isUppercase | isLowercase | isTitlecase
				or:[(category = 'Lm') or:[(category = 'Lo')]].

		    ch := Character value:codePoint.
		    self assert:(ch isUppercase == isUppercase) description:('isUppercase of ',ch codePoint asString).
		    self assert:(ch isLowercase == isLowercase) description:('isLowercase of ',ch codePoint asString).
		    "/ self assert:(ch isTitlecase == isTitlecase).
		    self assert:(ch isNationalLetter == isLetter) description:('isNationalLetter of ',ch codePoint asString).

		    ucValue notNil ifTrue:[
			ucCh := Character value:ucValue.
			self assert:(ch asUppercase = ucCh) description:('asUppercase of ',ch codePoint asString).
		    ] ifFalse:[
			self assert:(ch asUppercase = ch) description:('asUppercase of ',ch codePoint asString).
		    ].
		    lcValue notNil ifTrue:[
			lcCh := Character value:lcValue.
			self assert:(ch asLowercase = lcCh) description:('asLowercase of ',ch codePoint asString).
		    ] ifFalse:[
			self assert:(ch asLowercase = ch) description:('asLowercase of ',ch codePoint asString).
		    ].
		    tcValue notNil ifTrue:[
			tcCh := Character value:tcValue.
			self assert:(ch asTitlecase = tcCh) description:('asTitlecase of ',ch codePoint asString).
		    ] ifFalse:[
			self assert:(ch asTitlecase = ch) description:('asTitlecase of ',ch codePoint asString).
		    ].
		].
	].

    "
     self new test01CaseTesting
    "

    "Modified (comment): / 05-08-2011 / 18:59:24 / cg"
!

test02_Concatenation
    "test , operator on characters (to test against possible inlining or compiler optimizations, use variables, not constants)"

    |a b r s s2|

    s := ($a to: $z) asString.
    s2 :=($b to: $z) asString.

    "/ char , string
    a := $a. b := ''.     self assert:(r := a,b) = 'a'.
    a := $a. b := 'b'.    self assert:(r := a,b) = 'ab'.
    a := $a. b := 'bc'.   self assert:(r := a,b) = 'abc'.
    a := $a. b := 'bcd'.  self assert:(r := a,b) = 'abcd'.
    a := $a. b := 'bcde'. self assert:(r := a,b) = 'abcde'.
    "/ just in case there is some wordlength related problem...
    1 to:20 do:[:n |
	self assert:($a,(s2 copyTo:n)) = (s copyTo:n+1)
    ].

    "/ char , char
    a := $a. b := $b.     self assert:(r := a,b) = 'ab'.

    s2 :=($a to: $y) asString.
    "/ string, char
    a := $a. b := ''.     self assert:(r := b,a) = 'a'.
    a := $a. b := 'b'.    self assert:(r := b,a) = 'ba'.
    a := $a. b := 'bc'.   self assert:(r := b,a) = 'bca'.
    a := $a. b := 'bcd'.  self assert:(r := b,a) = 'bcda'.
    a := $a. b := 'bcde'. self assert:(r := b,a) = 'bcdea'.
    "/ just in case there is some wordlength related problem...
    1 to:20 do:[:n |
	self assert:((s2 copyLast:n),$z) = (s copyLast:n+1)
    ].

    "
     self new test02_Concatenation
    "

    "Modified (comment): / 05-08-2011 / 18:59:24 / cg"
! !

!CharacterTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

