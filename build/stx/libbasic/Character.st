"
 COPYRIGHT (c) 1988 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Magnitude subclass:#Character
	instanceVariableNames:'asciivalue'
	classVariableNames:'CharacterTable Separators'
	poolDictionaries:''
	category:'Magnitude-General'
!

!Character class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    This class represents characters.

    Notice, that actual character objects are not used when characters
    are stored in strings, symbols etc.
    These only store a character's asciiValue/codePoint for a more compact representation.
    The word 'asciiValue' is a historic leftover - actually, any integer
    code is allowed and actually used (i.e. characters are not limited to 8bit).
    Also, the encoding is actually Unicode, of which ascii is a subset and the same encoding value
    for the first 128 characters (codePoint 0 to 127 are the same in ascii).

    Some heavily used Characters are kept as singletons; i.e. for every asciiValue (0..N),
    there exists exactly one instance of Character, which is shared.
    Character value:xxx checks for this, and returns a reference to an existing instance.
    For N<=255, this is guaranteed; i.e. in all Smalltalks, the single byte characters are always
    handled like this, and you can therefore safely compare them using == (identity compare).

    Other characters (i.e. codepoint > N) are not guaranteed to be shared;
    i.e. these my or may not be created as required.
    Actually, do NOT depend on which characters are and which are not shared.
    Always compare using #= if there is any chance of a non-ascii character being involved.

    Once again (because beginners sometimes make this mistake):
	This means: you may compare characters using #== ONLY IFF you are certain,
	that the characters ranges is 0..255.
	Otherwise, you HAVE TO compare using #=. (if in doubt, always compare using #=).
	Sorry for this inconvenience, but it is (practically) impossible to keep
	the possible maximum of 2^32 characters (Unicode) around, for that convenience alone.

    In ST/X, N is (currently) 1024. This means that all the latin characters and some others are
    kept as singleton in the CharacterTable class variable (which is also used by the VM when characters
    are instantiated).

    Methods marked as (JS) come from the manchester Character goody
    (CharacterComparing) by Jan Steinman, which allow Characters to be used as
    Interval elements (i.e. ($a to:$z) do:[...] );
    They are not a big deal, but convenient add-ons.
    Some of these have been modified a bit.

    WARNING: characters are known by compiler and runtime system -
	     do not change the instance layout.

    Also, although you can create subclasses of Character, the compiler always
    creates instances of Character for literals ...
    ... and other classes are hard-wired to always return instances of characters
    in some cases (i.e. String>>at:, Symbol>>at: etc.).
    Therefore, it may not make sense to create a character-subclass.

    Case Mapping in Unicode:
	There are a number of complications to case mappings that occur once the repertoire
	of characters is expanded beyond ASCII.

	* Because of the inclusion of certain composite characters for compatibility,
	  such as U+01F1 'DZ' capital dz, there is a third case, called titlecase,
	  which is used where the first letter of a word is to be capitalized
	  (e.g. Titlecase, vs. UPPERCASE, or lowercase).
	  For example, the title case of the example character is U+01F2 'Dz' capital d with small z.

	* Case mappings may produce strings of different length than the original.
	  For example, the German character U+00DF small letter sharp s expands when uppercased to
	  the sequence of two characters 'SS'.
	  This also occurs where there is no precomposed character corresponding to a case mapping.
	  *** This is not yet implemented (in 5.2) ***

	* Characters may also have different case mappings, depending on the context.
	  For example, U+03A3 capital sigma lowercases to U+03C3 small sigma if it is not followed
	  by another letter, but lowercases to 03C2 small final sigma if it is.
	  *** This is not yet implemented (in 5.2) ***

	* Characters may have case mappings that depend on the locale.
	  For example, in Turkish the letter 0049 'I' capital letter i lowercases to 0131 small dotless i.
	  *** This is not yet implemented (in 5.2) ***

	* Case mappings are not, in general, reversible.
	  For example, once the string 'McGowan' has been uppercased, lowercased or titlecased,
	  the original cannot be recovered by applying another uppercase, lowercase, or titlecase operation.

    Collation Sequence:
	*** This is not yet implemented (in 5.2) ***

    [author:]
	Claus Gittinger

    [see also:]
	String TwoByteString Unicode16String Unicode32String
	StringCollection Text
"
! !

!Character class methodsFor:'instance creation'!

basicNew
    "catch new - Characters cannot be created with new"

    ^ self error:'Characters cannot be created with new'
!

codePoint:anInteger
    "return a character with codePoint anInteger"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    {
	char ch = (char)(context.stArg(0).intValue("[codePoint:]"));

	return context._RETURN(STCharacter._new(ch));
    }
    /* NOTREACHED */
#else
    INT __codePoint;

    if (__isSmallInteger(anInteger)) {
	__codePoint = __smallIntegerVal(anInteger);
	if ((unsigned INT)(__codePoint) <= MAX_IMMEDIATE_CHARACTER /* (__codePoint >= 0) && (__codePoint <= 255) */) {
	    RETURN ( __MKCHARACTER(__codePoint) );
	} else {
	    RETURN ( __MKUCHARACTER(__codePoint) );
	}
    }
#endif
%}.
    (anInteger between:0 and:(CharacterTable size - 1)) ifTrue:[
	^ CharacterTable at:(anInteger + 1)
    ].
    (anInteger between:16r100 and:16r3FFFFFFF) ifTrue:[
	^ super basicNew setCodePoint:anInteger
    ].
    "
     a characters codePoint must be 0..16r3FFFFFFF.
     (i.e. only characters with up-to 30 bits are allowed.)
    "
    RangeError raiseWith:anInteger errorString:'invalid codePoint for character'

    "
      self codePoint:16r34.
      self codePoint:16r3455.
      self codePoint:16rFFFFFFFFFFFFFFFFFFF.
    "
!

digitValue:anInteger
    "return a character that corresponds to anInteger.
     0-9 map to $0-$9, 10-35 map to $A-$Z"

    |val "{ Class: SmallInteger }" |

    val := anInteger.
    (val between:0 and:9) ifTrue:[
	^ Character codePoint:(val + ($0 codePoint))
    ].
    (val between:10 and:35) ifTrue:[
	^ Character codePoint:(val + ($A codePoint - 10))
    ].
    ^ self error:'value not in range 0 to 35'
!

utf8DecodeFrom:aStream
    "read and return a single unicode character from an UTF8 encoded stream"

    |fetchNext c1 c2 codePoint|

    c1 := aStream next.
    codePoint := c1 codePoint.
    codePoint <= 16r7F ifTrue:[
	"/ 0xxxxxxx - 7 bits
	^ c1 asCharacter.
    ].

    (codePoint bitAnd:2r11000000) == 2r10000000 ifTrue:[
	"/ out of sync (got an intermediate character)
	InvalidEncodingError raiseRequestWith:codePoint errorString:' - out of sync'.
	^ c1 asCharacter.
    ].

    fetchNext := [  |code|
		    code := aStream next codePoint.
		    (code bitAnd:2r11000000) == 2r10000000 ifFalse:[
			"/ followup chars must have 2r10 in high bits
			InvalidEncodingError raiseRequestWith:code.
			^ c1 asCharacter.
		    ].
		    code bitAnd:16r3F
		 ].

    (codePoint bitAnd:2r11100000) == 2r11000000 ifTrue:[
	"/ 110xxxxx 10xxxxxx - 11 bits
	codePoint := codePoint bitAnd:16r1F.
	codePoint := (codePoint bitShift:6) bitOr:(fetchNext value).
	codePoint <= 16r7F ifTrue:[
	    InvalidEncodingError raiseRequestWith:codePoint.
	].
	^ Character codePoint:codePoint
    ].
    (codePoint bitAnd:2r11110000) == 2r11100000 ifTrue:[
	"/ 1110xxxx 10xxxxxx 10xxxxxx - 16 bits
	codePoint := codePoint bitAnd:16r0F.
	codePoint := (codePoint bitShift:6) bitOr:(fetchNext value).
	codePoint := (codePoint bitShift:6) bitOr:(fetchNext value).
	codePoint <= 16r7FF ifTrue:[
	    InvalidEncodingError raiseRequestWith:codePoint.
	].
	^ Character codePoint:codePoint
    ].

    (codePoint bitAnd:2r11111000) == 2r11110000 ifTrue:[
	"/ 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx - 21 bits
	codePoint := codePoint bitAnd:16r07.
	codePoint := (codePoint bitShift:6) bitOr:(fetchNext value).
	codePoint := (codePoint bitShift:6) bitOr:(fetchNext value).
	codePoint := (codePoint bitShift:6) bitOr:(fetchNext value).
	codePoint <= 16rFFFF ifTrue:[
	    InvalidEncodingError raiseRequestWith:codePoint.
	].
	^ Character codePoint:codePoint
    ].

    (codePoint bitAnd:2r11111100) == 2r11111000 ifTrue:[
	"/ 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx - 26 bits
	codePoint := codePoint bitAnd:16r03.
	codePoint := (codePoint bitShift:6) bitOr:(fetchNext value).
	codePoint := (codePoint bitShift:6) bitOr:(fetchNext value).
	codePoint := (codePoint bitShift:6) bitOr:(fetchNext value).
	codePoint := (codePoint bitShift:6) bitOr:(fetchNext value).
	codePoint <= 16r1FFFFF ifTrue:[
	    InvalidEncodingError raiseRequestWith:codePoint.
	].
	^ Character codePoint:codePoint
    ].

    (codePoint bitAnd:2r11111110) == 2r11111100 ifTrue:[
	"/ 1111110x ... 10xxxxxx - any number of bits
	codePoint := codePoint bitAnd:16r01.

	c2 := aStream peek.
	[c2 notNil and:[(c2 codePoint bitAnd:2r11000000) == 2r10000000]] whileTrue:[
	    codePoint := (codePoint bitShift:6) bitOr:(c2 codePoint bitAnd:16r3F).
	    aStream next.
	    c2 := aStream peek.
	].
	codePoint <= 16r3FFFFFF ifTrue:[
	    InvalidEncodingError raiseRequestWith:codePoint.
	].
	^ Character codePoint:codePoint
    ].

    InvalidEncodingError raiseRequestWith:codePoint.
    ^ c1 asCharacter.

    "
      Character utf8DecodeFrom:'a' readStream
      Character utf8DecodeFrom:#[195 188] asString readStream
    "

    "test:

      |utf8Encoding original readBack|

      1 to:16rFFFF do:[:codePoint |
	original := Character value:codePoint.
	utf8Encoding := original utf8Encoded.
	readBack := Character utf8DecodeFrom:(utf8Encoding readStream).
	readBack codePoint = codePoint ifFalse:[
	    self halt
	]
      ]
    "
!

value:anInteger
    "return a character with codePoint anInteger - backward compatibility"

    ^ self codePoint:anInteger
! !

!Character class methodsFor:'accessing untypeable characters'!

controlCharacter:char
    "Answer the Character representing ctrl-char.
     ctrl-a -> 1; ctrl-@ -> 0"

    char == $@ ifTrue:[^ self codePoint:0].
    self assert:char isLetter.
    ^ self codePoint:(char asLowercase - $a + 1)

    "
     self controlCharacter:$@
     self controlCharacter:$d
    "
!

endOfInput
    "Answer the Character representing ctrl-d (Unix-EOF)."

    ^ self codePoint:4
!

leftParenthesis
    "Answer the Character representing a left parenthesis."

    ^ self codePoint:40
!

period
    "Answer the Character representing a carriage period."

    ^ self codePoint:46
!

poundSign
    "Answer the Character representing a pound sign (hash)."

    ^ self codePoint:35
!

rightParenthesis
    "Answer the Character representing a right parenthesis."

    ^ self codePoint:41
! !

!Character class methodsFor:'constants'!

backspace
    "return the backspace character"

    ^ Character codePoint:8
!

bell
    "return the bell character"

    ^ Character codePoint:7
!

cr
    "return the lineEnd character
     - actually (in unix) this is a newline character"

    ^ Character codePoint:10
!

del
    "return the delete character"

    ^ Character codePoint:16r7F
!

doubleQuote
    "return the double-quote character"

    ^ Character codePoint:34
!

esc
    "return the escape character"

    ^ Character codePoint:27
!

etx
    "return the end-of-text character"

    ^ Character codePoint:3
!

euro
    "The Euro currency sign (notice: not all fonts support it).
     The Unicode encoding is U+20AC"

    ^ Character codePoint:16r20AC

    "
     Transcript font:(Font family:'courier' size:12 encoding:'iso10646-1').
     Transcript showCR:Character euro
    "
    "
     0 to:255 do:[:i |
	Transcript
	    show:'| '; show:((i printStringRadix:16) leftPaddedTo:2);
	    show:' | '; show:(i printStringPaddedTo:3);
	    show:' | '; show:(Character value:i);
	    cr.
     ]
    "
!

excla
    "return the exclamation-mark character"
    ^ $!!
!

ff
    "return the form-feed character"

    ^ Character codePoint:12
!

lf
    "return the newline/linefeed character"

    ^ Character codePoint:10
!

linefeed
    "squeak compatibility: return the newline/linefeed character"

    ^ Character codePoint:10
!

maxImmediateCodePoint
    "return the maximum codePoint until which the characters are shared"
%{ /* NOCONTEXT */
    RETURN(__mkSmallInteger(MAX_IMMEDIATE_CHARACTER));
%}.

    "
      self maxImmediateCodePoint
    "
!

maxValue
    "return the maximum codePoint a character may have"

    ^ 16r3FFFFFFF
!

newPage
    "return the form-feed character"

    ^ Character codePoint:12
!

nl
    "return the newline character"

    ^ Character codePoint:10
!

null
    ^ Character codePoint:0
!

quote
    "return the single-quote character"

    ^ Character codePoint:39
!

return
    "return the return character.
     In ST/X, this is different from cr - for Unix reasons."

    ^ Character codePoint:13
!

space
    "return the blank character"

    ^ Character codePoint:32
!

tab
    "return the tabulator character"

    ^ Character codePoint:9
! !

!Character class methodsFor:'primitive input'!

fromUser
    "return a character from the keyboard (C's standard input stream)
     - this should only be used for emergency evaluators and the like."

%{  /* NOCONTEXT */
#   include <errno.h>

    int c;

    for (;;) {
	c = getchar();
	if (c >= 0) break;
	if (errno != EINTR) {
	    RETURN (nil);
	}
    }
    RETURN ( __MKCHARACTER(c & 0xFF) );
%}.
    ^ Processor activeProcess stdin next
! !

!Character class methodsFor:'queries'!

allCharacters
    "added for squeak compatibility: return a collection of all singleton chars.
     Notice, for memory efficiency reasons, only some of the low-codepoint characters
     are actually kept as singletons. less frequently used character instances are created on the fly,
     as wide string elements are accessed (and hopefully garbage collected sooner or later)"

    ^ CharacterTable

    "
     Character allCharacters
    "
!

hasSharedInstances
    "return true if this class has shared instances, that is, instances
     with the same value are identical.
     Although not always shared (TwoByte CodePoint-Characters), these should be treated
     so, to be independent of the number of the underlying implementation"

    ^ true
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Character

    "Modified: 23.4.1996 / 15:56:39 / cg"
!

isLegalUnicodeCodePoint:anInteger
    "answer true, if anInteger is a valid unicode code point"

    "Range 16rD800 - 16rDFFF is reserved for the
     lower and upper substitution page for UCS-16"
    (anInteger >= 16rD800) ifTrue:[
	(anInteger <= 16rDFFF) ifTrue:[
	    ^ false.
	].
	(anInteger == 16rFFFE) ifTrue:[
	    ^ false.
	].
	(anInteger == 16rFFFF) ifTrue:[
	    ^ false.
	].
    ].
    ^ true
!

separators
    "return a collection of separator chars.
     Added for squeak compatibility"

    Separators isNil ifTrue:[
	Separators := Array
	    with:Character space
	    with:Character return
	    "/ with:Character cr
	    with:Character tab
	    with:Character lf
	    with:Character ff
    ].
    ^ Separators

    "
     Character separators
    "
! !

!Character methodsFor:'Compatibility-Dolphin'!

isAlphaNumeric
    "Compatibility method for dolphin and VSE - do not use in new code.
     Return true, if I am a letter or a digit
     Please use isLetterOrDigit for compatibility reasons (which is ANSI)."

    ^ self isLetterOrDigit
!

isAlphabetic
    "Compatibility method - do not use in new code.
     Return true, if I am a letter.
     Please use isLetter for compatibility reasons (which is ANSI)."

    ^ self isLetter
!

isControl
    "Compatibility method - do not use in new code.
     Return true if I am a control character (i.e. ascii value < 32)"

    ^ self isControlCharacter
!

isHexDigit
    "return true if I am a valid hexadecimal digit"

    ^ '0123456789abcdefABCDEF' includes:self

    "
     $a isHexDigit
    "
!

isPunctuation
    "Compatibility method - do not use in new code.
     The code below is not unicode aware"

    ^ (asciivalue between:16r21 and:16r40)
      or:[ (asciivalue between:16r5B and:16r60)
      or:[ (asciivalue between:123 and:126)
      or:[ (asciivalue between:161 and:191)
      or:[ (asciivalue == 215 )
      or:[ (asciivalue == 247 ) ]]]]]
! !

!Character methodsFor:'accessing'!

codePoint
    "return the codePoint of myself.
     Traditionally, this was named 'asciiValue';
     however, characters are not limited to 8bit characters."

    ^ asciivalue
!

instVarAt:index put:anObject
    "catch instvar access - asciivalue may not be changed"

    self error:'Characters may not be modified'
! !

!Character methodsFor:'arithmetic'!

+ aMagnitude
    "Return the Character that is <aMagnitude> higher than the receiver.
     Wrap if the resulting value is not a legal Character value. (JS)"

    ^ Character codePoint:((asciivalue + aMagnitude asInteger) \\ 16r3FFFFFFF)

    "
     $A + 5
    "

    "Modified: 27.6.1996 / 12:34:51 / cg"
!

- aMagnitude
    "Return the Character that is <aMagnitude> lower than the receiver.
     Wrap if the resulting value is not a legal Character value. (JS)
     claus:
	modified to return the difference as integer, if the argument
	is another character. If the argument is a number, a character is
	returned."

    aMagnitude isCharacter ifTrue:[
	^ asciivalue - aMagnitude asInteger
    ].
    ^ Character codePoint:((asciivalue - aMagnitude asInteger) \\ 16r3FFFFFFF)

    "
     $z - $a
     $d - 3
    "

    "Modified: 27.6.1996 / 12:35:34 / cg"
!

// aMagnitude
    "Return the Character who's value is the receiver divided by <aMagnitude>.
     Wrap if the resulting value is not a legal Character value. (JS)"

    ^ Character codePoint:(asciivalue // aMagnitude asInteger \\ 16r3FFFFFFF)
!

\\ aMagnitude
    "Return the Character who's value is the receiver modulo <aMagnitude>.
     Wrap if the resulting value is not a legal Character value. (JS)"

    ^ Character codePoint:(asciivalue \\ aMagnitude asInteger \\ 16r3FFFFFFF)
! !


!Character methodsFor:'comparing'!

< aMagnitude
    "return true, if the arguments asciiValue is greater than the receiver's"

    ^ (asciivalue < aMagnitude asInteger)
!

<= aMagnitude
    "return true, if the arguments asciiValue is greater or equal to the receiver's"

    ^ (asciivalue <= aMagnitude asInteger)
!

= aCharacter
    "return true, if the argument, aCharacter is the same character
     Redefined to take care of character sizes > 8bit."
%{
#ifdef __SCHTEAM__
    if (self == aCharacter) {
	return context._RETURN_true();
    }
    if (aCharacter.characterP() == STObject.True) {
	if (self.charValue() == aCharacter.charValue()) {
	    return context._RETURN_true();
	} else {
	    return context._RETURN_false();
	}
    }
#endif /* not SCHTEAM */
%}.
    self == aCharacter ifTrue:[^ true].
    aCharacter isCharacter ifFalse:[^ false].
    ^ asciivalue = aCharacter codePoint

    "
	$A = (Character value:65)
	$A = (Character codePoint:65)
	$A = ($B-1)
	$A = 65
    "
!

> aMagnitude
    "return true, if the arguments asciiValue is less than the receiver's"

    ^ (asciivalue > aMagnitude asInteger)
!

>= aMagnitude
    "return true, if the arguments asciiValue is less or equal to the receiver's"

    ^ (asciivalue >= aMagnitude asInteger)
!

hash
    "return an integer useful for hashing"

    ^ asciivalue
!

identityHash
    "return an integer useful for hashing on identity"

%{
    INT __codePoint;

    __codePoint = __smallIntegerVal(__INST(asciivalue));

    if (__codePoint <= MAX_IMMEDIATE_CHARACTER) {
	RETURN ( __mkSmallInteger(__codePoint + 4096) );
    }
%}.

    ^ super identityHash

    "
      $a identityHash.
      (Character value:1234) identityHash
    "
!

sameAs:aCharacter
    "return true, if the argument, aCharacter is the same character,
     ignoring case differences."

    self == aCharacter ifTrue:[^ true].
    ^ self asLowercase = aCharacter asLowercase

    "
      (Character value:345) sameAs:(Character value:345)
    "
!

~= aCharacter
    "return true, if the argument, aCharacter is not the same character
     Redefined to take care of character sizes > 8bit."

    self == aCharacter ifTrue:[^ false].
    aCharacter isCharacter ifFalse:[^ true].
    ^ (asciivalue ~~ aCharacter codePoint)
! !

!Character methodsFor:'converting'!

asCharacter
    "usually sent to integers, but redefined here to allow integers
     and characters to be used commonly without a need for a test."

    ^ self

    "
     32 asCharacter
    "
!

asInteger
    "the same as #codePoint.
     Use #asInteger, if you need protocol compatibility with Numbers etc..
     Use #codePoint in any other case for better stc optimization"

    ^ asciivalue
!

asLowercase
    "return a character with same letter as the receiver, but in lowercase.
     Returns the receiver if it is already lowercase or if there is no lowercase equivalent.
     CAVEAT:
	for now, this method is only correct for unicode characters up to u+1d6ff (Unicode3.1).
	(which is more than mozilla does, btw. ;-)"

%{
#ifdef __SCHTEAM__
    {
	char ch = self.charValue("[asLowercase]");

	ch = java.lang.Character.toLowerCase(ch);
	return context._RETURN(STCharacter._new(ch));
    }
    /* NOTREACHED */
#else
    static int __mapping[] = {
    /* From    To             Every   Diff   */
       0x0041, ((0x19 << 8) | 0x01), 0x0020  ,
       0x00c0, ((0x16 << 8) | 0x01), 0x0020  ,
       0x00d8, ((0x06 << 8) | 0x01), 0x0020  ,
       0x0100, ((0x2e << 8) | 0x02), 0x0001  ,
       0x0130, ((0x00 << 8) | 0x00), -199   ,
       0x0132, ((0x04 << 8) | 0x02), 0x0001  ,
       0x0139, ((0x0e << 8) | 0x02), 0x0001  ,
       0x014a, ((0x2c << 8) | 0x02), 0x0001  ,
       0x0178, ((0x00 << 8) | 0x00), -121   ,
       0x0179, ((0x04 << 8) | 0x02), 0x0001  ,
       0x0181, ((0x00 << 8) | 0x00), 0x00d2  ,
       0x0182, ((0x02 << 8) | 0x02), 0x0001  ,
       0x0186, ((0x00 << 8) | 0x00), 0x00ce  ,
       0x0187, ((0x00 << 8) | 0x00), 0x0001  ,
       0x0189, ((0x01 << 8) | 0x01), 0x00cd  ,
       0x018b, ((0x00 << 8) | 0x00), 0x0001  ,
       0x018e, ((0x00 << 8) | 0x00), 0x004f  ,
       0x018f, ((0x00 << 8) | 0x00), 0x00ca  ,
       0x0190, ((0x00 << 8) | 0x00), 0x00cb  ,
       0x0191, ((0x00 << 8) | 0x00), 0x0001  ,
       0x0193, ((0x00 << 8) | 0x00), 0x00cd  ,
       0x0194, ((0x00 << 8) | 0x00), 0x00cf  ,
       0x0196, ((0x00 << 8) | 0x00), 0x00d3  ,
       0x0197, ((0x00 << 8) | 0x00), 0x00d1  ,
       0x0198, ((0x00 << 8) | 0x00), 0x0001  ,
       0x019c, ((0x00 << 8) | 0x00), 0x00d3  ,
       0x019d, ((0x00 << 8) | 0x00), 0x00d5  ,
       0x019f, ((0x00 << 8) | 0x00), 0x00d6  ,
       0x01a0, ((0x04 << 8) | 0x02), 0x0001  ,
       0x01a6, ((0x00 << 8) | 0x00), 0x00da  ,
       0x01a7, ((0x00 << 8) | 0x00), 0x0001  ,
       0x01a9, ((0x00 << 8) | 0x00), 0x00da  ,
       0x01ac, ((0x00 << 8) | 0x00), 0x0001  ,
       0x01ae, ((0x00 << 8) | 0x00), 0x00da  ,
       0x01af, ((0x00 << 8) | 0x00), 0x0001  ,
       0x01b1, ((0x01 << 8) | 0x01), 0x00d9  ,
       0x01b3, ((0x02 << 8) | 0x02), 0x0001  ,
       0x01b7, ((0x00 << 8) | 0x00), 0x00db  ,
       0x01b8, ((0x04 << 8) | 0x04), 0x0001  ,
       0x01c4, ((0x00 << 8) | 0x00), 0x0002  ,
       0x01c5, ((0x00 << 8) | 0x00), 0x0001  ,
       0x01c7, ((0x00 << 8) | 0x00), 0x0002  ,
       0x01c8, ((0x00 << 8) | 0x00), 0x0001  ,
       0x01ca, ((0x00 << 8) | 0x00), 0x0002  ,
       0x01cb, ((0x10 << 8) | 0x02), 0x0001  ,
       0x01de, ((0x10 << 8) | 0x02), 0x0001  ,
       0x01f1, ((0x00 << 8) | 0x00), 0x0002  ,
       0x01f2, ((0x02 << 8) | 0x02), 0x0001  ,
       0x01f6, ((0x00 << 8) | 0x00), -97   ,
       0x01f7, ((0x00 << 8) | 0x00), -56   ,
       0x01f8, ((0x26 << 8) | 0x02), 0x0001  ,
#ifndef UNICODE_3_2
       0x0220, ((0x00 << 8) | 0x00), -130  ,          /* Unicode4.0 - not in X fonts - sigh */
#endif
       0x0222, ((0x10 << 8) | 0x02), 0x0001  ,
       0x0386, ((0x00 << 8) | 0x00), 0x0026  ,
       0x0388, ((0x02 << 8) | 0x01), 0x0025  ,
       0x038c, ((0x00 << 8) | 0x00), 0x0040  ,
       0x038e, ((0x01 << 8) | 0x01), 0x003f  ,
       0x0391, ((0x10 << 8) | 0x01), 0x0020  ,
       0x03a3, ((0x08 << 8) | 0x01), 0x0020  ,
#ifndef UNICODE_3_2
       0x03d8, ((0x00 << 8) | 0x00), 1  ,             /* Unicode4.0 - not in X fonts - sigh */
#endif
       0x03da, ((0x14 << 8) | 0x02), 0x0001  ,
       0x03f4, ((0x00 << 8) | 0x00), -60   ,
#ifndef UNICODE_3_2
       0x03f7, ((0x03 << 8) | 0x03), 1  ,             /* Unicode4.0 - not in X fonts - sigh */
       0x03f9, ((0x00 << 8) | 0x00), -7 ,             /* Unicode4.0 - not in X fonts - sigh */
#endif
       0x0400, ((0x0f << 8) | 0x01), 0x0050  ,
       0x0410, ((0x1f << 8) | 0x01), 0x0020  ,
       0x0460, ((0x20 << 8) | 0x02), 0x0001  ,
#ifndef UNICODE_3_2
       0x048a, ((0x00 << 8) | 0x00), 1 ,              /* Unicode4.0 - not in X fonts - sigh */
#endif
       0x048c, ((0x32 << 8) | 0x02), 0x0001  ,
#ifdef UNICODE_3_2
       0x04c1, ((0x02 << 8) | 0x02), 0x0001  ,
#else
       0x04c1, ((0x04 << 8) | 0x02), 0x0001  ,        /* Unicode4.0 - not in X fonts - sigh */
#endif
#ifdef UNICODE_3_2
       0x04c7, ((0x04 << 8) | 0x04), 0x0001  ,
#else
       0x04c7, ((0x04 << 8) | 0x02), 0x0001  ,
       0x04cd, ((0x00 << 8) | 0x00), 0x0001  ,
#endif
       0x04d0, ((0x24 << 8) | 0x02), 0x0001  ,
       0x04f8, ((0x00 << 8) | 0x00), 0x0001  ,
#ifndef UNICODE_3_2
       0x0500, ((0x0E << 8) | 0x02), 1  ,
#endif
       0x0531, ((0x25 << 8) | 0x01), 0x0030  ,
       0x1e00, ((0x94 << 8) | 0x02), 0x0001  ,
       0x1ea0, ((0x58 << 8) | 0x02), 0x0001  ,
       0x1f08, ((0x07 << 8) | 0x01), -8   ,
       0x1f18, ((0x05 << 8) | 0x01), -8   ,
       0x1f28, ((0x07 << 8) | 0x01), -8   ,
       0x1f38, ((0x07 << 8) | 0x01), -8   ,
       0x1f48, ((0x05 << 8) | 0x01), -8   ,
       0x1f59, ((0x06 << 8) | 0x02), -8   ,
       0x1f68, ((0x07 << 8) | 0x01), -8   ,
       0x1f88, ((0x07 << 8) | 0x01), -8   ,
       0x1f98, ((0x07 << 8) | 0x01), -8   ,
       0x1fa8, ((0x07 << 8) | 0x01), -8   ,
       0x1fb8, ((0x01 << 8) | 0x01), -8   ,
       0x1fba, ((0x01 << 8) | 0x01), -74  ,
       0x1fbc, ((0x00 << 8) | 0x00), -9   ,
       0x1fc8, ((0x03 << 8) | 0x01), -86  ,
       0x1fcc, ((0x00 << 8) | 0x00), -9   ,
       0x1fd8, ((0x01 << 8) | 0x01), -8   ,
       0x1fda, ((0x01 << 8) | 0x01), -100 ,
       0x1fe8, ((0x01 << 8) | 0x01), -8   ,
       0x1fea, ((0x01 << 8) | 0x01), -112 ,
       0x1fec, ((0x00 << 8) | 0x00), -7   ,
       0x1ff8, ((0x01 << 8) | 0x01), -128 ,
       0x1ffa, ((0x01 << 8) | 0x01), -126 ,
       0x1ffc, ((0x00 << 8) | 0x00), -9   ,
       0x2126, ((0x00 << 8) | 0x00), -7517   ,
       0x212a, ((0x00 << 8) | 0x00), -8383   ,
       0x212b, ((0x00 << 8) | 0x00), -8262   ,
       0x2160, ((0x0f << 8) | 0x01), 0x0010  ,
       0x24b6, ((0x19 << 8) | 0x01), 0x001a  ,
       0xff21, ((0x19 << 8) | 0x01), 0x0020  ,
       0x10400, ((0x27 << 8) | 0x01), 0x0028
    };

    REGISTER unsigned INT __codePoint;
    REGISTER int *  __p;

    __codePoint = __intVal(__INST(asciivalue));

    // comon ascii stuff first
    if (__codePoint < 0x80) {
	if ((__codePoint >= 'A') && (__codePoint <= 'Z')) {
	    unsigned int newCodePoint = __codePoint - 'A' + 'a';
	    RETURN (__MKCHARACTER(newCodePoint)) ;
	}
	RETURN (self);
    }

    for (__p = __mapping; (char *)__p < ((char *)__mapping) + sizeof(__mapping); __p += 3) {
	unsigned rangeStart, rangeSize, rangeEnd, mod;

	rangeStart = (unsigned)__p[0];
	if (__codePoint < rangeStart) break;

	rangeSize = ((unsigned)__p[1]) >> 8;
	rangeEnd = rangeStart + rangeSize;
	if (__codePoint <= rangeEnd) {
	    mod = __p[1] & 0xFF;
	    if ((mod == 0) || (((__codePoint - rangeStart) % mod) == 0)) {
		OBJ newChar;
		unsigned newCodePoint;

		newCodePoint = __codePoint + __p[2];
		if (newCodePoint <= MAX_IMMEDIATE_CHARACTER) {
		    RETURN (__MKCHARACTER(newCodePoint)) ;
		}
		newChar = __MKUCHARACTER(newCodePoint) ;
		if (newChar == nil) goto allocationError;
		RETURN (newChar) ;
	    }
	}
    }
    RETURN (self);
allocationError: ;
#endif /* ! __SCHTEAM__ */
%}.
    ^ AllocationFailure raise.

    "
     $A asLowercase
     $a asLowercase
     (Character value:16r01F5) asUppercase asLowercase
     (Character value:16r0205) asUppercase asLowercase
     (Character value:16r03B1) asUppercase asLowercase
     (Character value:16r1E00) asLowercase
    "
!

asString
    "return a string of len 1 with myself as contents"

%{  /* NOCONTEXT */
    char buffer[2];
    OBJ s;
    unsigned INT val;

    val = __intVal(__characterVal(self));
    if (val <= 0xFF) {
	buffer[0] = (char) val;
	buffer[1] = '\0';
	s = __MKSTRING_L(buffer, 1);
	if (s != nil) {
	    RETURN (s);
	}
    }
    if (val <= 0xFFFF) {
	s = __MKEMPTYU16STRING(1);
	if (s != nil) {
	    __Unicode16StringInstPtr(s)->s_element[0] = val;
	    RETURN (s);
	}
    }
%}.
    asciivalue > 16rFF ifTrue:[
	asciivalue > 16rFFFF ifTrue:[
	    ^ (Unicode32String new:1) at:1 put:self; yourself
	].
	^ (Unicode16String new:1) at:1 put:self; yourself
    ].

    ^ (String new:1) at:1 put:self; yourself.

    "
     (Character value:16rB5) asString
     (Character value:16r1B5) asString
    "
!

asSymbol
    "Return a unique symbol with the name taken from the receiver's characters.
     Here, a single character symbol is returned."

    ^ Symbol internCharacter:self
!

asTitlecase
    "return a character with same letter as the receiver, but in titlecase.
     Returns the receiver if it is already titlecase or if there is no titlecase equivalent."

    "
     For example, in Unicode, character U+01F3 is LATIN SMALL LETTER DZ.
     (Let us write this compound character using ASCII as 'dz'.)
     This character uppercases to character U+01F1, LATIN CAPITAL LETTER DZ.
     (Which is basically 'DZ'.)
     But it titlecases to to character U+01F2, LATIN CAPITAL LETTER D WITH SMALL LETTER Z.
     (Which we can write 'Dz'.)

      character uppercase titlecase
      --------- --------- ---------
      dz        DZ        Dz
    "
    |ch|

%{
    static unsigned short __mapping[] = {
       0x01C4,    0x01C5,
       0x01C6,    0x01C5,
       0x01C7,    0x01C8,
       0x01C9,    0x01C8,
       0x01CA,    0x01CB,
       0x01CC,    0x01CB,
       0x01F1,    0x01F2,
       0x01F3,    0x01F2,
    };

    REGISTER unsigned INT __codePoint;
    REGISTER unsigned short *__p;

    __codePoint = __intVal(__INST(asciivalue));
    if ((__codePoint > 0x01C0) && (__codePoint < 0x01FF)) {
	for (__p = __mapping; (char *)__p < ((char *)__mapping) + sizeof(__mapping); __p += 2) {
	    if ((__codePoint == __p[0]) || (__codePoint == __p[1])) {
		short newCodePoint;
		OBJ newChar;

		newCodePoint = __p[1];
		if (newCodePoint == __codePoint) {
		    RETURN (self);
		}
		if (newCodePoint <= MAX_IMMEDIATE_CHARACTER) {
		    RETURN (__MKCHARACTER(newCodePoint)) ;
		}
		newChar = __MKUCHARACTER(newCodePoint) ;
		if (newChar == nil) goto getOutOfHere;
		RETURN (newChar) ;
	    }
	}
    }
    if (__codePoint < 0x80) {
	// do it here for common ascii characters
	if ((__codePoint >= 'a') && (__codePoint <= 'z')) {
	    unsigned char newCodePoint = __codePoint - 'a' + 'A';
	    RETURN (__MKCHARACTER(newCodePoint)) ;
	}
	RETURN (self) ;
    }

    ch = self;
getOutOfHere: ;
%}.
    ch notNil ifTrue:[
	^ ch asUppercase.
    ].

    ^ AllocationFailure raise.

    "
     $A asTitlecase
     $a asTitlecase
     (Character value:16r01F1) asTitlecase
     (Character value:16r01F2) asTitlecase
    "
!

asUnicodeString
    "return a unicode string of len 1 with myself as contents.
     This will vanish, as we now (rel5.2.x) use Unicode as default."

    asciivalue > 16rFFFF ifTrue:[
	^ (Unicode32String new:1) at:1 put:self; yourself.
    ].
    ^ (Unicode16String new:1) at:1 put:self; yourself.
!

asUppercase
    "return a character with same letter as the receiver, but in uppercase.
     Returns the receiver if it is already uppercase or if there is no uppercase equivalent.
     CAVEAT:
	for now, this method is only correct for unicode characters up to u+1d6ff (Unicode3.1).
	(which is more than mozilla does, btw. ;-)"

%{
#ifdef __SCHTEAM__
    {
	char ch = self.charValue("[asUppercase]");

	ch = java.lang.Character.toUpperCase(ch);
	return context._RETURN(STCharacter._new(ch));
    }
    /* NOTREACHED */
#else
    static int __mapping[] = {
    /* From    To             Every   Diff   */
       0x0061, ((0x19 << 8) | 0x01), -32  ,
       0x00b5, ((0x00 << 8) | 0x3b), 0x02e7  ,
       0x00e0, ((0x16 << 8) | 0x01), -32   ,
       0x00f8, ((0x06 << 8) | 0x01), -32   ,
       0x00ff, ((0x00 << 8) | 0x01), 0x0079  ,
       0x0101, ((0x2e << 8) | 0x02), -1   ,
       0x0131, ((0x00 << 8) | 0x02), -232  ,
       0x0133, ((0x04 << 8) | 0x02), -1   ,
       0x013a, ((0x0e << 8) | 0x02), -1   ,
       0x014b, ((0x2c << 8) | 0x02), -1   ,
       0x017a, ((0x04 << 8) | 0x02), -1   ,
       0x017f, ((0x00 << 8) | 0x01), -300  ,
       0x0183, ((0x02 << 8) | 0x02), -1   ,
       0x0188, ((0x04 << 8) | 0x04), -1   ,
       0x0192, ((0x00 << 8) | 0x06), -1   ,
       0x0195, ((0x00 << 8) | 0x03), 0x0061  ,
#ifndef UNICODE_3_2
       0x0199, ((0x04 << 8) | 0x08), -1   ,
       0x019e, ((0x00 << 8) | 0x00), 130  ,          /* Unicode4.0 - not in X fonts - sigh */
#endif
       0x0199, ((0x08 << 8) | 0x08), -1   ,
       0x01a3, ((0x02 << 8) | 0x02), -1   ,
       0x01a8, ((0x05 << 8) | 0x05), -1   ,
       0x01b0, ((0x04 << 8) | 0x04), -1   ,
       0x01b6, ((0x03 << 8) | 0x03), -1   ,
       0x01bd, ((0x00 << 8) | 0x04), -1   ,
       0x01bf, ((0x00 << 8) | 0x02), 0x0038  ,
       0x01c5, ((0x00 << 8) | 0x06), -1   ,
       0x01c6, ((0x00 << 8) | 0x01), -2   ,
       0x01c8, ((0x00 << 8) | 0x02), -1   ,
       0x01c9, ((0x00 << 8) | 0x01), -2   ,
       0x01cb, ((0x00 << 8) | 0x02), -1   ,
       0x01cc, ((0x00 << 8) | 0x01), -2   ,
       0x01ce, ((0x0e << 8) | 0x02), -1   ,
       0x01dd, ((0x00 << 8) | 0x01), -79   ,
       0x01df, ((0x10 << 8) | 0x02), -1   ,
       0x01f2, ((0x00 << 8) | 0x03), -1   ,
       0x01f3, ((0x00 << 8) | 0x01), -2   ,
       0x01f5, ((0x04 << 8) | 0x04), -1   ,
       0x01fb, ((0x24 << 8) | 0x02), -1   ,
       0x0223, ((0x10 << 8) | 0x02), -1   ,
       0x0253, ((0x00 << 8) | 0x20), -210   ,
       0x0254, ((0x00 << 8) | 0x01), -206   ,
       0x0256, ((0x01 << 8) | 0x01), -205   ,
       0x0259, ((0x00 << 8) | 0x02), -202   ,
       0x025b, ((0x00 << 8) | 0x02), -203   ,
       0x0260, ((0x00 << 8) | 0x05), -205   ,
       0x0263, ((0x00 << 8) | 0x03), -207   ,
       0x0268, ((0x00 << 8) | 0x05), -209   ,
       0x0269, ((0x06 << 8) | 0x06), -211   ,
       0x0272, ((0x00 << 8) | 0x03), -213   ,
       0x0275, ((0x00 << 8) | 0x03), -214   ,
       0x0280, ((0x03 << 8) | 0x03), -218   ,
       0x0288, ((0x00 << 8) | 0x05), -218   ,
       0x028a, ((0x01 << 8) | 0x01), -217   ,
       0x0292, ((0x00 << 8) | 0x07), -219   ,
       0x0345, ((0x00 << 8) | 0xb3), 0x0054  ,
       0x03ac, ((0x00 << 8) | 0x67), -38   ,
       0x03ad, ((0x02 << 8) | 0x01), -37   ,
       0x03b1, ((0x10 << 8) | 0x01), -32   ,
       0x03c2, ((0x00 << 8) | 0x01), -31   ,
       0x03c3, ((0x08 << 8) | 0x01), -32   ,
       0x03cc, ((0x00 << 8) | 0x01), -64   ,
       0x03cd, ((0x01 << 8) | 0x01), -63   ,
       0x03d0, ((0x00 << 8) | 0x02), -62   ,
       0x03d1, ((0x00 << 8) | 0x01), -57   ,
       0x03d5, ((0x00 << 8) | 0x04), -47   ,
       0x03d6, ((0x00 << 8) | 0x01), -54   ,
#ifndef UNICODE_3_2
       0x03d9, ((0x00 << 8) | 0x00), -1  ,             /* Unicode4.0 - not in X fonts - sigh */
#endif
       0x03db, ((0x14 << 8) | 0x02), -1    ,
       0x03f0, ((0x00 << 8) | 0x01), -86   ,
       0x03f1, ((0x00 << 8) | 0x01), -80   ,
#ifdef UNICODE_3_2
       0x03f2, ((0x00 << 8) | 0x01), -79   ,
#else
       0x03f2, ((0x00 << 8) | 0x00), 7  ,              /* Unicode4.0 - not in X fonts - sigh */
#endif
       0x03f5, ((0x00 << 8) | 0x00), -96   ,
#ifndef UNICODE_3_2
       0x03f8, ((0x03 << 8) | 0x03), -1  ,             /* Unicode4.0 - not in X fonts - sigh */
#endif
       0x0430, ((0x1f << 8) | 0x01), -32   ,
       0x0450, ((0x0f << 8) | 0x01), -80   ,
       0x0461, ((0x20 << 8) | 0x02), -1   ,
#ifndef UNICODE_3_2
       0x048b, ((0x00 << 8) | 0x00), -1 ,              /* Unicode4.0 - not in X fonts - sigh */
#endif
       0x048d, ((0x32 << 8) | 0x02), -1   ,
#ifdef UNICODE_3_2
       0x04c2, ((0x02 << 8) | 0x02), -1   ,
#else
       0x04c2, ((0x04 << 8) | 0x02), -1   ,            /* Unicode4.0 - not in X fonts - sigh */
#endif
#ifdef UNICODE_3_2
       0x04c8, ((0x04 << 8) | 0x04), -1   ,
#else
       0x04c8, ((0x04 << 8) | 0x02), -1   ,
       0x04ce, ((0x00 << 8) | 0x00), -1   ,
#endif
       0x04d1, ((0x24 << 8) | 0x02), -1   ,
       0x04f9, ((0x00 << 8) | 0x04), -1   ,
#ifndef UNICODE_3_2
       0x0501, ((0x0E << 8) | 0x02), -1  ,
#endif
       0x0561, ((0x25 << 8) | 0x01), -48   ,
       0x1e01, ((0x94 << 8) | 0x02), -1   ,
       0x1e9b, ((0x00 << 8) | 0x06), -59   ,
       0x1ea1, ((0x58 << 8) | 0x02), -1   ,
       0x1f00, ((0x07 << 8) | 0x01), 0x0008  ,
       0x1f10, ((0x05 << 8) | 0x01), 0x0008  ,
       0x1f20, ((0x07 << 8) | 0x01), 0x0008  ,
       0x1f30, ((0x07 << 8) | 0x01), 0x0008  ,
       0x1f40, ((0x05 << 8) | 0x01), 0x0008  ,
       0x1f51, ((0x06 << 8) | 0x02), 0x0008  ,
       0x1f60, ((0x07 << 8) | 0x01), 0x0008  ,
       0x1f70, ((0x01 << 8) | 0x01), 0x004a  ,
       0x1f72, ((0x03 << 8) | 0x01), 0x0056  ,
       0x1f76, ((0x01 << 8) | 0x01), 0x0064  ,
       0x1f78, ((0x01 << 8) | 0x01), 0x0080  ,
       0x1f7a, ((0x01 << 8) | 0x01), 0x0070  ,
       0x1f7c, ((0x01 << 8) | 0x01), 0x007e  ,
       0x1f80, ((0x07 << 8) | 0x01), 0x0008  ,
       0x1f90, ((0x07 << 8) | 0x01), 0x0008  ,
       0x1fa0, ((0x07 << 8) | 0x01), 0x0008  ,
       0x1fb0, ((0x01 << 8) | 0x01), 0x0008  ,
       0x1fb3, ((0x00 << 8) | 0x02), 0x0009  ,
       0x1fbe, ((0x00 << 8) | 0x0b), -7205   ,
       0x1fc3, ((0x00 << 8) | 0x05), 0x0009  ,
       0x1fd0, ((0x01 << 8) | 0x01), 0x0008  ,
       0x1fe0, ((0x01 << 8) | 0x01), 0x0008  ,
       0x1fe5, ((0x00 << 8) | 0x04), 0x0007  ,
       0x1ff3, ((0x00 << 8) | 0x0e), 0x0009  ,
       0x2170, ((0x0f << 8) | 0x01), -16   ,
       0x24d0, ((0x19 << 8) | 0x01), -26   ,
       0xff41, ((0x19 << 8) | 0x01), -32  ,
       0x10428, ((0x27 << 8) | 0x01), -40
    };

    REGISTER unsigned INT __codePoint;
    REGISTER int *__p;

    __codePoint = __intVal(__INST(asciivalue));

   // comon ascii stuff first
    if (__codePoint < 0x80) {
	if ((__codePoint >= 'a') && (__codePoint <= 'z')) {
	    unsigned newCodePoint;

	    newCodePoint = __codePoint - 'a' + 'A';
	    RETURN (__MKCHARACTER(newCodePoint)) ;
	}
	RETURN (self);
    }

    for (__p = __mapping; (char *)__p < ((char *)__mapping) + sizeof(__mapping); __p += 3) {
	unsigned rangeStart, rangeSize, rangeEnd, mod;

	rangeStart = (unsigned)__p[0];
	if (rangeStart > __codePoint) break;

	rangeSize = ((unsigned)__p[1]) >> 8;
	rangeEnd = rangeStart + rangeSize;
	if (__codePoint <= rangeEnd) {
	    mod = __p[1] & 0xFF;
	    if ((mod == 0) || (((__codePoint - rangeStart) % mod) == 0)) {
		OBJ newChar;
		unsigned newCodePoint;

		newCodePoint = __codePoint + __p[2];
		if (newCodePoint <= MAX_IMMEDIATE_CHARACTER) {
		    RETURN (__MKCHARACTER(newCodePoint)) ;
		}
		newChar = __MKUCHARACTER(newCodePoint) ;
		if (newChar == nil) goto allocationError;
		RETURN (newChar) ;
	    }
	}
    }
    RETURN (self);
allocationError: ;
#endif /* ! __SCHTEAM__ */
%}.
    ^ AllocationFailure raise.

    "
     $A asLowercase
     $a asUppercase
     (Character value:16r01F5) asUppercase
     (Character value:16r0205) asUppercase
     (Character value:16r03B1) asUppercase
    "
!

digitValue
    "return my digitValue for any base (up to 37)"

    |code "{ Class: SmallInteger }" |

    code := asciivalue.
    (code between:($0 codePoint) and:($9 codePoint)) ifTrue:[
	^ code - $0 codePoint
    ].
    (code between:($a codePoint) and:($z codePoint)) ifTrue:[
	^ code + (10 - $a codePoint)
    ].
    (code between:($A codePoint) and:($Z codePoint)) ifTrue:[
	^ code + (10 - $A codePoint)
    ].

"remove error below for X3J20 conformance ... "
    self error:'bad character'.
" "
    ^ -1
!

digitValueRadix:base
    "return my digitValue for base.
     Return nil, if it is not a valid character for that base"

    |code "{ Class: SmallInteger }" |

    code := asciivalue.
    base < 10 ifTrue:[
	(code between:($0 codePoint) and:($0 codePoint + base - 1)) ifTrue:[
	    ^ code - $0 codePoint
	].
	^ nil.
    ].
    (code between:($0 codePoint) and:($9 codePoint)) ifTrue:[
	^ code - $0 codePoint
    ].
    base <= 10 ifTrue:[
	^ nil.
    ].
    (code between:($a codePoint) and:($a codePoint + base - 1 - 10)) ifTrue:[
	^ code + (10 - $a codePoint)
    ].
    (code between:($A codePoint) and:($A codePoint + base - 1 - 10)) ifTrue:[
	^ code + (10 - $A codePoint)
    ].
    ^ nil

    "
     self assert:($0 digitValueRadix:10) == 0.
     self assert:($9 digitValueRadix:10) == 9.
     self assert:($a digitValueRadix:10) == nil.
     self assert:($a digitValueRadix:11) == 10.
     self assert:($A digitValueRadix:11) == 10.
     self assert:($a digitValueRadix:16) == 10.
     self assert:($A digitValueRadix:16) == 10.
     self assert:($f digitValueRadix:16) == 15.
     self assert:($F digitValueRadix:16) == 15.
     self assert:($g digitValueRadix:16) == nil.
     self assert:($G digitValueRadix:16) == nil.
     self assert:($g digitValueRadix:17) == 16.
     self assert:($G digitValueRadix:17) == 16.
    "
!

literalArrayEncoding
    "encode myself as an array literal, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray."

    ^ self

    "Created: / 27.10.1997 / 14:40:37 / cg"
!

to:aMagnitude
    "Return an Interval over the characters from the receiver to <aMagnitude>.
     Wrap <aMagnitude> if it is not a legal Character value. (JS)"

    ^ Interval from:self to:(aMagnitude \\ 16r3FFFFFFF)
!

to:aMagnitude by:inc
    "Return an Interval over the characters from the receiver to <aMagnitude>.
     Wrap <aMagnitude> if it is not a legal Character value. (JS)"

    ^ Interval from:self to:(aMagnitude \\ 16r3FFFFFFF) by:inc

    "Created: / 04-07-2011 / 19:35:15 / cg"
!

utf8Encoded
    "convert a character to its UTF-8 encoding.
     this returns a String"

    |s|

    asciivalue <= 16r7F ifTrue:[
	^ self asString.
    ].

    s := WriteStream on:(String new:6).
    s nextPutUtf8:self.
    ^ s contents

    "
     'ä' utf8Encoded
     'a' utf8Encoded
    "
! !

!Character methodsFor:'copying'!

, aStringOrCharacter
    "return a string containing the concatenation of the receiver character
     and the argument, a string or character.
     Added for symetry, as we allow string,char also char,string should be allowed"

%{
    OBJ s;
    unsigned INT val;

    // fast code for common cases
    val = __intVal(__characterVal(self));
    if (val <= 0xFF) {
	if (__isCharacter(aStringOrCharacter)) {
	    unsigned INT val2 = __intVal(__characterVal(aStringOrCharacter));

	    if (val2 <= 0xFF) {
		char buffer[2];

		buffer[0] = val;
		buffer[1] = val2;
		s = __MKSTRING_L(buffer, 2);
		if (s != nil) {
		    RETURN (s);
		}
	    }
	} else {
	    if (__isString(aStringOrCharacter)) {
		int strSize = __stringSize(aStringOrCharacter);

		s = __MKEMPTYSTRING(strSize+1);
		if (s != nil) {
		    __StringInstPtr(s)->s_element[0] = val;
		    memcpy(__StringInstPtr(s)->s_element+1, __stringVal(aStringOrCharacter), strSize+1); // copies 0-byte too
		    RETURN (s);
		}
	    }
	}
    }
%}.
    ^ self asString , aStringOrCharacter

    "
     $. , $:
     $. , 'abc' , $.

      Time millisecondsToRun:[ 10000000 timesRepeat:[ $a , $b ]]
      Time millisecondsToRun:[ 10000000 timesRepeat:[ $a , 'b' ]]
      Time millisecondsToRun:[ 10000000 timesRepeat:[ 'a' , 'b' ]]
      Time millisecondsToRun:[ 10000000 timesRepeat:[ 'a' , $b ]]
    "
!

copy
    "return a copy of myself
     reimplemented since characters are unique"

     ^ self
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "return a deep copy of myself
     reimplemented since characters are immutable"

     ^ self
!

shallowCopy
    "return a shallow copy of myself
     reimplemented since characters are immutable"

     ^ self
!

simpleDeepCopy
    "return a deep copy of myself
     reimplemented since characters are immutable"

     ^ self
! !

!Character methodsFor:'encoding'!

rot13
     "Usenet: from `rotate alphabet 13 places']
      The simple Caesar-cypher encryption that replaces each English
      letter with the one 13 places forward or back along the alphabet,
      so that 'The butler did it!!' becomes 'Gur ohgyre qvq vg!!'
      Most Usenet news reading and posting programs include a rot13 feature.
      It is used to enclose the text in a sealed wrapper that the reader must choose
      to open -- e.g., for posting things that might offend some readers, or spoilers.
      A major advantage of rot13 over rot(N) for other N is that it
      is self-inverse, so the same code can be used for encoding and decoding."

    ^ self rot:13

    "
     $h rot13
     $h rot13 rot13
     'The butler did it!!' rot13             -> 'Gur ohgyre qvq vg!!'
     'The butler did it!!' rot13 rot13       -> 'The butler did it!!'
    "
!

rot:n
     "Usenet: from `rotate alphabet N places']
      The simple Caesar-cypher encryption that replaces each English
      letter with the one N places forward or back along the alphabet,
      so that 'The butler did it!!' becomes 'Gur ohgyre qvq vg!!' by rot:13
      Most Usenet news reading and posting programs include a rot13 feature.
      It is used to enclose the text in a sealed wrapper that the reader must choose
      to open -- e.g., for posting things that might offend some readers, or spoilers.
      A major advantage of rot13 over rot(N) for other N is that it
      is self-inverse, so the same code can be used for encoding and decoding."

    (self isLetter) ifTrue:[
	self isLowercase ifTrue:[
	    ^ 'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz' at:(self-$a+1+n)
	].
	^ 'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ' at:(self-$A+1+n)
    ].
    ^ self

    "
     'The butler did it!!' rot:13                -> 'Gur ohgyre qvq vg!!'
     ('The butler did it!!' rot:13) rot:13       -> 'The butler did it!!'
    "
! !


!Character methodsFor:'obsolete'!

asciiValue
    "return the asciivalue of myself.
     The name 'asciiValue' is a historic leftover:
	characters are not limited to 8bit characters.
     So the actual value returned is a codePoint (i.e. full potential for 31bit encoding).
     PP has removed this method with 4.1 and providing asInteger instead.
     ANSI defines #codePoint, please use this method"

    <resource:#obsolete>

    ^ asciivalue

    "Modified: 27.6.1996 / 12:34:34 / cg"
! !

!Character methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
	^ super displayOn:aGCOrStream
    ].

    self storeOn:aGCOrStream.
    aGCOrStream nextPutAll:' "16r'.
    asciivalue printOn:aGCOrStream base:16.
    aGCOrStream nextPutAll:' '.
    asciivalue printOn:aGCOrStream.
    aGCOrStream nextPut:$".
!

isLiteral
    "return true, if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    ^ true
!

print
    "print myself on stdout.
     If Stdout is nil, this method does NOT (by purpose) use the stream classes and
     will therefore work even in case of emergency or very early startup (but only, if Stdout is nil)."

%{  /* NOCONTEXT */

    if (@global(Stdout) == nil) {
	putchar(__intVal(__INST(asciivalue)));
	RETURN(self);
    }
%}.
    super print
!

printOn:aStream
    "print myself on aStream"

    aStream nextPut:self
!

printString
    "return a string to print me"

    ^ self asString
!

storeOn:aStream
    "store myself on aStream"

    |special|

    (asciivalue between:33 and:127) ifTrue:[
	aStream nextPut:$$; nextPut:self
    ] ifFalse:[
	(self == Character space) ifTrue:[
	    special := #space
	] ifFalse:[
	    (self == Character cr) ifTrue:[
		special := #cr.
	    ] ifFalse:[
		(self == Character tab) ifTrue:[
		    special := #tab.
		] ifFalse:[
		    (self == Character esc) ifTrue:[
			special := #esc.
		    ]
		]
	    ]
	].
	special notNil ifTrue:[
	    aStream nextPutAll:'(Character '; nextPutAll:special; nextPut:$).
	    ^ self
	].
	aStream nextPutAll:'(Character codePoint:16r'.
	asciivalue printOn:aStream base:16.
	aStream nextPut:$)
     ].

    "Modified: / 23.2.1996 / 23:27:32 / cg"
    "Modified: / 20.1.1998 / 14:10:46 / stefan"
! !

!Character methodsFor:'private-accessing'!

setCodePoint:anInteger
    "very private - set the codePoint.
     - use this only for newly created characters with codes > MAX_IMMEDIATE_CHARACTER.
     DANGER alert:
	funny things happen, if this is applied to
	one of the shared characters with codePoints 0..MAX_IMMEDIATE_CHARACTER."

    asciivalue := anInteger
! !

!Character methodsFor:'queries'!

bitsPerCharacter
    "return the number of bits I require for storage.
     (i.e. am I an Ascii/ISO8859-1 Character or will I need more
     bits for storage."

    asciivalue <= 16rFF ifTrue:[^ 8].
    asciivalue <= 16rFFFF ifTrue:[^ 16].
    ^ 32
!

bytesPerCharacter
    "return the number of bytes I require for storage"

    asciivalue <= 16rFF ifTrue:[^ 1].
    asciivalue <= 16rFFFF ifTrue:[^ 2].
    ^ 4
!

characterSize
    "return the number of bits I require for storage.
     Protocol compatibility with CharacterArray."

    asciivalue <= 16r80 ifTrue:[
	^ 7
    ].
    asciivalue <= 16rFF ifTrue:[
	^ 8
    ].
    asciivalue <= 16rFFFF ifTrue:[
	^ 16
    ].
    ^ 32
!

stringSpecies
    "return the type of string that is needed to store me"

    asciivalue <= 16rFF ifTrue:[^ String].
    asciivalue <= 16rFFFF ifTrue:[^ Unicode16String].
    ^ Unicode32String
!

unicodeBlock
    "return the name of the unicode block in which this character is.
     incomplete"

    asciivalue <= 16r007F ifTrue:[^ #BASIC_LATIN ].
    asciivalue <= 16r00FF ifTrue:[^ #LATIN1_SUPPLEMENT ].
    asciivalue <= 16r017F ifTrue:[^ #LATIN1_EXTENDED_A].
    asciivalue <= 16r024F ifTrue:[^ #LATIN1_EXTENDED_B].
    asciivalue <= 16r02AF ifTrue:[^ #IPA_EXTENSIONS].
    asciivalue <= 16r02FF ifTrue:[^ #SPACING_MODIFIER_LETTERS].
    asciivalue <= 16r036f ifTrue:[ ^ #COMBINING_DIACRITICAL_MARKS ].
    asciivalue <= 16r03FF ifTrue:[ ^ #GREEK_AND_COPTIC ].
    asciivalue <= 16r04FF ifTrue:[ ^ #CYRILLIC ].
    asciivalue <= 16r052F ifTrue:[ ^ #CYRILLIC_SUPPLEMENT ].
    asciivalue <= 16r058F ifTrue:[ ^ #ARMENIAN ].
    asciivalue <= 16r05FF ifTrue:[ ^ #HEBREW ].
    asciivalue <= 16r06FF ifTrue:[ ^ #ARABIC ].
    asciivalue <= 16r074F ifTrue:[ ^ #SYRIAC ].
    asciivalue <= 16r077F ifTrue:[ ^ #ARABIC_SUPPLEMENT ].
    asciivalue <= 16r07BF ifTrue:[ ^ #THAANA ].
    asciivalue <= 16r07FF ifTrue:[ ^ #NKO ].
    asciivalue <= 16r083F ifTrue:[ ^ #SAMARITAN ].
    asciivalue <= 16r085F ifTrue:[ ^ #MANDAIC ].
    asciivalue <= 16r087F ifTrue:[ ^ nil ].
    asciivalue <= 16r08FF ifTrue:[ ^ #ARABIC_EXTENDED_A ].
    asciivalue <= 16r097F ifTrue:[ ^ #DEVANAGARI ].
    asciivalue <= 16r09FF ifTrue:[ ^ #BENGALI ].
    asciivalue <= 16r0A7F ifTrue:[ ^ #GURMUKHI ].
    asciivalue <= 16r0AFF ifTrue:[ ^ #GUJARATI ].
    asciivalue <= 16r0B7F ifTrue:[ ^ #ORIYA ].
    asciivalue <= 16r0BFF ifTrue:[ ^ #TAMIL ].
    asciivalue <= 16r0C7F ifTrue:[ ^ #TELUGU ].
    asciivalue <= 16r0CFF ifTrue:[ ^ #KANNADA ].
    asciivalue <= 16r0D7F ifTrue:[ ^ #MALAYALAM ].
    asciivalue <= 16r0DFF ifTrue:[ ^ #SINHALA ].
    asciivalue <= 16r0E7F ifTrue:[ ^ #THAI ].
    asciivalue <= 16r0EFF ifTrue:[ ^ #LAO ].
    asciivalue <= 16r0FFF ifTrue:[ ^ #TIBETAN ].
    asciivalue <= 16r109F ifTrue:[ ^ #MYANMAR ].
    asciivalue <= 16r10FF ifTrue:[ ^ #GEORGIAN ].
    asciivalue <= 16r11FF ifTrue:[ ^ #HANGUL_JAMO ].
    asciivalue <= 16r137F ifTrue:[ ^ #ETHIOPIC ].
    asciivalue <= 16r139F ifTrue:[ ^ #ETHIOPIC_SUPPLEMENT ].
    asciivalue <= 16r13FF ifTrue:[ ^ #CHEROKEE ].
    asciivalue <= 16r167F ifTrue:[ ^ #UNIFIED_CANADIAN_ABORIGINAL_SYLLABICS ].
    asciivalue < 16r1AB0 ifTrue:[ ^ #OTHER ].
    asciivalue <= 16r1AFF ifTrue:[ ^ #COMBINING_DIACRITICAL_MARKS_EXTENDED ].
    asciivalue < 16r1DC0 ifTrue:[ ^ #OTHER ].
    asciivalue <= 16r1DFF ifTrue:[ ^ #COMBINING_DIACRITICAL_MARKS_SUPPLEMENT ].
    asciivalue <= 16r1EFF ifTrue:[ ^ #LATIN_EXTENDED_ADDITIONAL ].
    asciivalue <= 16r1FFF ifTrue:[ ^ #GREEK_EXTENDED ].
    asciivalue <= 16r206F ifTrue:[ ^ #GENERAL_PUNKTUATION ].
    asciivalue <= 16r209F ifTrue:[ ^ #SUPERSCRIPTS_AND_SUBSCRIPTS ].
    asciivalue <= 16r20CF ifTrue:[ ^ #CURRENCY_SYMBOLS ].
    asciivalue < 16r2190 ifTrue:[ ^ #OTHER ].
    asciivalue <= 16r21FF ifTrue:[ ^ #ARROWS ].
    asciivalue <= 16r22FF ifTrue:[ ^ #MATHEMATICAL_OPERATORS ].
    asciivalue <= 16r23FF ifTrue:[ ^ #MISCELLANEOUS_TECHNICAL ].
    asciivalue < 16r2600 ifTrue:[ ^ #OTHER ].
    asciivalue <= 16r26FF ifTrue:[ ^ #MISCELLANEOUS_SYMBOLS ].
    asciivalue <= 16r27BF ifTrue:[ ^ #DINGBATS ].
    asciivalue <= 16r27EF ifTrue:[ ^ #MISCELLANEOUS_MATHEMATICAL_SYMBOLS_A ].
    ^ #OTHER

    "
     (Character value:16r200) unicodeBlock
    "
! !

!Character methodsFor:'testing'!

isCharacter
    "return true,  if the receiver is some kind of character"

    ^ true
!

isControlCharacter
    "return true if I am a control character (i.e. ascii value < 32 or == 16rFF)"

%{  /* NOCONTEXT */
    REGISTER INT val;

    val = __intVal(__INST(asciivalue));
    if (val < ' ' || val == 0xFF) {
	RETURN ( true );
    }
    RETURN (false);
%}.

    "
     (Character value:1) isControlCharacter
     $a isControlCharacter
    "
!

isDigit
    "return true, if I am a digit (i.e. $0 .. $9)"

%{  /* NOCONTEXT */

    REGISTER INT val;

    val = __intVal(__INST(asciivalue));
    if ((unsigned INT)(val - '0') <= ('9' - '0')) {
	RETURN ( true );
    }
    RETURN ( false );
%}.
    ^ asciivalue between:$0 codePoint and:$9 codePoint
!

isDigitRadix:r
    "return true, if I am a digit of a base r number"

    (asciivalue < $0 codePoint) ifTrue:[^ false].
    (r > 10) ifTrue:[
	(asciivalue <= $9 codePoint) ifTrue:[
	    ^ true
	].
	((asciivalue - $a codePoint) between:0 and:(r - 11)) ifTrue:[
	    ^ true
	].
	^ (asciivalue - $A codePoint) between:0 and:(r - 11)
    ].
    (asciivalue - $0 codePoint) < r ifTrue:[^ true].
    ^ false
!

isEndOfLineCharacter
    "return true if I am a line delimitting character"

%{  /* NOCONTEXT */

    REGISTER INT val;

    val = __intVal(__INST(asciivalue));
    if ((val == '\n')
     || (val == '\r')
     || (val == '\f')) {
	RETURN ( true );
    }
    RETURN (false);
%}.
    ^ asciivalue == 16r0A
      or:[asciivalue == 16r0D
      or:[asciivalue == 16r0C]]

!

isImmediate
    "return true if I am an immediate object
     i.e. I am represented in the pointer itself and
     no real object header/storage is used me.
     For VW compatibility, shared characters (i.e. in the range 0..MAX_IMMEDIATE_CHARACTER)
     also return true here"

%{  /* NOCONTEXT */
    if (__smallIntegerVal(__INST(asciivalue)) <= MAX_IMMEDIATE_CHARACTER) {
	RETURN ( true );
    }
%}.
    ^ false

    "
	$a isImmediate.
	(Character value:255) isImmediate.
	(Character value:256) isImmediate.
	(Character value:1566) isImmediate.
    "
!

isLetter
    "return true, if I am a letter in the 'a'..'z' range.
     Use isNationalLetter, if you are interested in those."

%{  /* NOCONTEXT */

    REGISTER INT val;

    val = __intVal(__INST(asciivalue));
    if ((unsigned INT)(val - 'a') <= ('z' - 'a')) {
	RETURN ( true );
    }
    if ((unsigned INT)(val - 'A') <= ('Z' - 'A')) {
	RETURN ( true );
    }
    RETURN ( false );
%}.
    ^ (asciivalue between:($a codePoint) and:($z codePoint))
      or:[(asciivalue between:($A codePoint) and:($Z codePoint))]
!

isLetterOrDigit
    "return true, if I am a letter (a..z or A..Z) or a digit (0..9)
     Use isNationalAlphaNumeric, if you are interested in those."

%{  /* NOCONTEXT */

    REGISTER INT val;

    val = __intVal(__INST(asciivalue));
    if ((unsigned INT)(val - 'a') <= ('z' - 'a')) {
	RETURN ( true );
    }
    if ((unsigned INT)(val - 'A') <= ('Z' - 'A')) {
	RETURN ( true );
    }
    if ((unsigned INT)(val - '0') <= ('9' - '0')) {
	RETURN ( true );
    }
    RETURN ( false );
%}.
    ^ self isLetter or:[self isDigit]
!

isLetterOrUnderline
    "return true, if I am a letter or $_"

    ^ self == $_ or:[ self isLetter ]
!

isLowercase
    "return true, if I am a lower-case letter.
     This one does care for national characters.
     Caveat:
	only returns the correct value for codes up to u+1d6ff (Unicode3.1).
	(which is more than mozilla does, btw. ;-)"

%{  /* NOCONTEXT */

    REGISTER unsigned INT val;
    REGISTER unsigned int lowByte;
#define TRUE_IF_ODD(x)      ((x & 1) ? true : false)
#define TRUE_IF_EVEN(x)     ((x & 1) ? false : true)

    /* because used so often, this is open coded, instead of table driven */
    val = __intVal(__INST(asciivalue));
    lowByte = val & 0xFF;

    /* the most likely case here, outside the switch */
    if (val <= 0xFF) {
	if ((unsigned)(lowByte - 'a') <= ('z' - 'a')) {
	    RETURN ( true );
	}

	/* iso8859 puts national lower case characters at e0 .. ff */
	if ((lowByte >= 0xDF) && (lowByte <= 0xFF)) {
	    if (lowByte != 0xF7) {
		RETURN(true);
	    }
	}
	if (lowByte == 0xAA) RETURN(true);     /* FEMININE ORDINAL INDICATOR (high a-underline) */
	if (lowByte == 0xB5) RETURN(true);     /* MICRO SIGN */
	if (lowByte == 0xBA) RETURN(true);     /* MASCULINE ORDINAL INDICATOR (high o-underline) */
	RETURN (false);
    }

    switch (val >> 8) {
	case 0x01:
	    if (lowByte <= 0x37) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte <= 0x48) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte <= 0x78) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte <= 0x7E) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte <= 0x80) { RETURN (true); }
	    if (lowByte < 0xCD) {
		if (lowByte == 0x81) { RETURN (false); }
		if (lowByte <= 0x85) {
		    RETURN (TRUE_IF_ODD(lowByte));
		}
		if (lowByte == 0x88) { RETURN (true); }
		if (lowByte == 0x8C) { RETURN (true); }
		if (lowByte == 0x8D) { RETURN (true); }
		if (lowByte == 0x92) { RETURN (true); }
		if (lowByte == 0x95) { RETURN (true); }
		if (lowByte == 0x99) { RETURN (true); }
		if (lowByte == 0x9A) { RETURN (true); }
		if (lowByte == 0x9B) { RETURN (true); }
		if (lowByte == 0x9E) { RETURN (true); }
		if (lowByte <= 0xA0) { RETURN (false); }
		if (lowByte <= 0xA6) { RETURN (TRUE_IF_ODD(lowByte)); }
		if (lowByte <= 0xAA) { RETURN (TRUE_IF_EVEN(lowByte)); }
		if (lowByte <= 0xAE) { RETURN (TRUE_IF_ODD(lowByte)); }
		if (lowByte == 0xB2) { RETURN (false); }
		if (lowByte <= 0xB6) { RETURN (TRUE_IF_EVEN(lowByte)); }
		if (lowByte == 0xB9) { RETURN (true); }
		if (lowByte == 0xBA) { RETURN (true); }
		if (lowByte == 0xBD) { RETURN (true); }
		if (lowByte == 0xBE) { RETURN (true); }
		if (lowByte == 0xBF) { RETURN (true); }
		if (lowByte == 0xC6) { RETURN (true); }
		if (lowByte == 0xC9) { RETURN (true); }
		if (lowByte == 0xCC) { RETURN (true); }
		RETURN (false);
	    }
	    if (lowByte <= 0xDC) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte <= 0xEF) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte == 0xF0) { RETURN (true); }
	    if (lowByte == 0xF1) { RETURN (false); }
	    if (lowByte == 0xF2) { RETURN (false); }
	    if (lowByte == 0xF3) { RETURN (true); }
	    if (lowByte <= 0xF6) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte == 0xF7) { RETURN (false); }
	    RETURN (TRUE_IF_ODD(lowByte));

	case 0x02:
	    if (lowByte <= 0x33) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte <= 0x36) { RETURN (true); }
	    if (lowByte < 0x50) { RETURN (false); }
	    if (lowByte < 0xB0) { RETURN (true); }
	    RETURN (false);


	case 0x03:
	    if (lowByte == 0x90) { RETURN (true); }
	    if (lowByte <= 0xAB) { RETURN (false); }
	    if (lowByte <= 0xD1) { RETURN (true); }
	    if (lowByte == 0xD5) { RETURN (true); }
	    if (lowByte == 0xD6) { RETURN (true); }
	    if (lowByte < 0xD7) { RETURN (false); }
	    if (lowByte <= 0xEF) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte <= 0xF3) { RETURN (true); }
	    if (lowByte == 0xF5) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (lowByte == 0xF8) { RETURN (true); }
	    if (lowByte == 0xFB) { RETURN (true); }
#endif
	    RETURN (false);

	case 0x04:
	    if (lowByte <= 0x2F) { RETURN (false); }
	    if (lowByte <= 0x5F) { RETURN (true); }
	    if (lowByte <= 0x81) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte < 0x8A) { RETURN (false); }
	    if (lowByte <= 0xC0) { RETURN (TRUE_IF_ODD(lowByte)); }
#ifdef UNICODE_3_2
	    if (lowByte == 0xC5) { RETURN (true); }
#endif
#ifdef UNICODE_3_2
	    if (lowByte <= 0xC8) { RETURN (TRUE_IF_EVEN(lowByte)); }
#else
	    if (lowByte <= 0xCA) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte == 0xCD) { RETURN (false); }
	    if (lowByte == 0xCE) { RETURN (true); }
#endif
	    if (lowByte == 0xCB) { RETURN (false); }
	    if (lowByte == 0xCC) { RETURN (true); }
	    RETURN (TRUE_IF_ODD(lowByte));

	case 0x05:
	    if (lowByte <= 0x0F) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte < 0x61) { RETURN (false); }
	    if (lowByte <= 0x87) { RETURN (true); }
	    RETURN (false);

	case 0x1D:
#ifndef UNICODE_3_2
	    if (lowByte <= 0x2B) { RETURN (true); }
	    if (lowByte <= 0x61) { RETURN (false); }
	    if (lowByte <= 0x70) { RETURN (true); }
#endif
	    RETURN (false);

	case 0x1E:
	    if (lowByte < 0x96) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte <= 0x9F) { RETURN (true); }
	    RETURN (TRUE_IF_ODD(lowByte));

	case 0x1F:
	    if (lowByte <= 0x6F) {
		if (lowByte & 0x0008) { RETURN (false); }
		RETURN (true);
	    }
	    if (lowByte <= 0x87) { RETURN (true); }
	    if (lowByte < 0xB8) {
		if (lowByte & 0x0008) { RETURN (false); }
		RETURN (true);
	    }
	    if (lowByte == 0xBE) { RETURN (true); }
	    if (lowByte == 0xD4) { RETURN (false); }
	    if (lowByte == 0xC5) { RETURN (false); }
	    if (lowByte == 0xD5) { RETURN (false); }
	    if (lowByte == 0xC1) { RETURN (false); }
	    if (lowByte == 0xF1) { RETURN (false); }
	    if (lowByte == 0xC0) { RETURN (false); }
	    if (lowByte == 0xF0) { RETURN (false); }
	    if (((lowByte & 0x000F) >= 0x0000) && ((lowByte & 0x000F) <= 0x0007)) { RETURN (true); }
	    RETURN (false);

	case 0x20:
#ifndef UNICODE_3_2
	    if (lowByte == 0x71) { RETURN (true); }
#endif
	    if (lowByte == 0x7F) { RETURN (true); }
	    RETURN (false);

	case 0x21:
	    if (lowByte == 0x0A) { RETURN (true); }
	    if (lowByte < 0x0E) { RETURN (false); }
	    if (lowByte <= 0x0F) { RETURN (true); }
	    if (lowByte == 0x13) { RETURN (true); }
	    if (lowByte == 0x2F) { RETURN (true); }
	    if (lowByte == 0x34) { RETURN (true); }
	    if (lowByte == 0x39) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (lowByte == 0x3D) { RETURN (true); }
	    if (lowByte <= 0x45) { RETURN (false); }
	    if (lowByte <= 0x49) { RETURN (true); }
#endif
	    RETURN (false);

	case 0xFB:
	    if (lowByte <= 0x1C) { RETURN (true); }
	    RETURN (false);

	case 0xFF:
	    if ((lowByte >= 0x41) && (lowByte <= 0x5A)) { RETURN (true); }
	    RETURN (false);

	case 0x104:
	    if (lowByte <= 0x27) { RETURN (false); }
	    if (lowByte <= 0x4D) { RETURN (true); }
#ifdef UNICODE_3_2
	    if (lowByte <= 0x4D) { RETURN (true); }
#else
	    if (lowByte <= 0x4F) { RETURN (true); }
#endif
	    RETURN (false);

	case 0x1D4:
	case 0x1D5:
	case 0x1D6:
	    if (val <= 0x1D419) { RETURN (false); }
	    if (val < 0x1D6be) {
		if (((val - 0x1D41A) % 52) <= 25) { RETURN (true); }
		RETURN (false);
	    }
	    if (val < 0x1D6c2) { RETURN (false); }
	    if (val < 0x1D6db) { RETURN (true); }
	    if (val == 0x1D6db) { RETURN (false); }
	    if (val < 0x1D6e2) { RETURN (true); }
	    if (val <= 0x1D6fb) { RETURN (false); }
	    RETURN (true);

#ifdef UNICODE_4
	case 0x1D7:
	    if (lowByte <= 0x1b) { RETURN (true); }
	    if (lowByte <= 0x35) { RETURN (false); }
	    if (lowByte <= 0x55) { RETURN (true); }
	    if (lowByte <= 0x6f) { RETURN (false); }
	    if (lowByte <= 0x8F) { RETURN (true); }

	    RETURN (false);
#endif
    }
#undef TRUE_IF_ODD
#undef TRUE_IF_EVEN
    RETURN (false);
%}.

    "Modified: / 05-08-2011 / 18:56:33 / cg"
!

isPrintable
    "return true, if the receiver is a useful printable character
     (see fileBrowser's showFile:-method on how it can be used)"

    (asciivalue between:32 and:127) ifTrue:[^ true].
    asciivalue == 12 ifTrue:[^ true].   "/ FF
    asciivalue == 13 ifTrue:[^ true].   "/ CR
    asciivalue == 9 ifTrue:[^ true].    "/ TAB
    asciivalue == 10 ifTrue:[^ true].   "/ NL

    (asciivalue between:16rA0 and:16rBF) ifTrue:[^ true]. "/ ISO-8859
    ^ self isNationalAlphaNumeric

    "Modified: 7.8.1997 / 17:05:24 / cg"
!

isSeparator
    "return true if I am a space, cr, tab, nl, or newPage"

%{  /* NOCONTEXT */

    REGISTER INT val;

    val = __intVal(__INST(asciivalue));
    if (val <= ' ')
	if ((val == ' ')
	 || (val == '\n')
	 || (val == '\t')
	 || (val == '\r')
	 || (val == '\f')) {
	    RETURN ( true );
	}
    RETURN (false);
%}.
    ^ (asciivalue == 16r20)
      or:[asciivalue == 16r0D
      or:[asciivalue == 16r0A
      or:[asciivalue == 16r09
      or:[asciivalue == 16r0C]]]]
!

isUppercase
    "return true, if I am an upper-case letter.
     This one does care for national characters.
     Caveat:
	only returns the correct value for codes up to u+1d6ff (Unicode3.1).
	(which is more than mozilla does, btw. ;-)"

%{  /* NOCONTEXT */
#define TRUE_IF_ODD(x)      ((x & 1) ? true : false)
#define TRUE_IF_EVEN(x)     ((x & 1) ? false : true)

    /* because used so often, this is open coded, instead of table driven */
    REGISTER unsigned INT val;
    REGISTER int lowByte;

    val = __intVal(__INST(asciivalue));
    lowByte = val & 0xFF;

    /* the most likely case here, outside the switch */
    if (val <= 0xFF) {
	if ((unsigned int)(lowByte - 'A') <= ('Z' - 'A')) {
	    RETURN ( true );
	}
	/* iso8859 puts national upper case characters at c0 .. df */
	if ((lowByte >= 0xC0) && (lowByte <= 0xDE)) {
	    if (lowByte != 0xD7) {
		RETURN(true);
	    }
	}
	RETURN (false);
    }

    switch (val >> 8) {
	case 0x01:
	    if (lowByte <= 0x37) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte <= 0x48) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte <= 0x78) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte <= 0x7E) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte < 0xCD) {
		if (lowByte == 0x80) { RETURN (false); }
		if (lowByte == 0x81) { RETURN (true); }
		if (lowByte <= 0x86) {
		    RETURN (TRUE_IF_EVEN(lowByte));
		}
		if (lowByte <= 0x89) {
		    RETURN (TRUE_IF_ODD(lowByte));
		}
		if (lowByte <= 0x8B) { RETURN (true); }
		if (lowByte <= 0x8D) { RETURN (false); }
		if (lowByte <= 0x91) { RETURN (true); }
		if (lowByte == 0x93) { RETURN (true); }
		if (lowByte == 0x94) { RETURN (true); }
		if (lowByte == 0x96) { RETURN (true); }
		if (lowByte == 0x97) { RETURN (true); }
		if (lowByte == 0x98) { RETURN (true); }
		if (lowByte == 0x9C) { RETURN (true); }
		if (lowByte == 0x9D) { RETURN (true); }
		if (lowByte == 0x9F) { RETURN (true); }
		if (lowByte < 0xA0) { RETURN (false); }
		if (lowByte <= 0xA6) { RETURN (TRUE_IF_EVEN(lowByte)); }
		if (lowByte <= 0xAA) { RETURN (TRUE_IF_ODD(lowByte)); }
		if (lowByte <= 0xAE) { RETURN (TRUE_IF_EVEN(lowByte)); }
		if (lowByte == 0xB2) { RETURN (true); }
		if (lowByte <= 0xB7) { RETURN (TRUE_IF_ODD(lowByte)); }
		if (lowByte == 0xB8) { RETURN (true); }
		if (lowByte == 0xBC) { RETURN (true); }
		if (lowByte == 0xC4) { RETURN (true); }
		if (lowByte == 0xC7) { RETURN (true); }
#if 0
		if (lowByte == 0xC8) { RETURN (true); }
#endif
		if (lowByte == 0xCA) { RETURN (true); }
#if 0
		if (lowByte == 0xCB) { RETURN (true); }
#endif
		RETURN (false);         /* WRONG !!! */
	    }
	    if (lowByte <= 0xDC) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte <= 0xEF) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte == 0xF0) { RETURN (false); }
	    if (lowByte == 0xF1) { RETURN (true); }
	    if (lowByte == 0xF2) { RETURN (false); }
	    if (lowByte == 0xF3) { RETURN (false); }
	    if (lowByte == 0xF4) { RETURN (true); }
	    if (lowByte == 0xF5) { RETURN (false); }
	    if (lowByte == 0xF6) { RETURN (true); }
	    if (lowByte == 0xF7) { RETURN (true); }
	    RETURN (TRUE_IF_EVEN(lowByte));

	case 0x02:
	    if (lowByte <= 0x33) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    RETURN (false);

	case 0x03:
	    if (lowByte < 0x86) { RETURN (false); }
	    if (lowByte == 0x87) { RETURN (false); }
	    if (lowByte == 0x90) { RETURN (false); }
	    if (lowByte <= 0xAB) { RETURN (true); }
	    if (lowByte <= 0xD1) { RETURN (false); }
	    if (lowByte <= 0xD4) { RETURN (true); }
	    if (lowByte <= 0xD7) { RETURN (false); }
	    if (lowByte <= 0xEF) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte == 0xF4) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (lowByte == 0xF7) { RETURN (true); }
	    if (lowByte == 0xF9) { RETURN (true); }
	    if (lowByte == 0xFa) { RETURN (true); }
#endif
	    RETURN (false);

	case 0x04:
	    if (lowByte <= 0x2F) { RETURN (true); }
	    if (lowByte <= 0x5F) { RETURN (false); }
	    if (lowByte <= 0x81) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte < 0x8A) { RETURN (false); }
	    if (lowByte <= 0xC0) { RETURN (TRUE_IF_EVEN(lowByte)); }
#ifdef UNICODE_3_2
	    if (lowByte == 0xC5) { RETURN (false); }
#endif
#ifdef UNICODE_3_2
	    if (lowByte <= 0xC8) { RETURN (TRUE_IF_ODD(lowByte)); }
#else
	    if (lowByte <= 0xCA) { RETURN (TRUE_IF_ODD(lowByte)); }
	    if (lowByte == 0xCD) { RETURN (true); }
	    if (lowByte == 0xCE) { RETURN (false); }
#endif
	    if (lowByte == 0xCB) { RETURN (true); }
	    if (lowByte == 0xCC) { RETURN (false); }
	    RETURN (TRUE_IF_EVEN(lowByte));

	case 0x05:
	    if (lowByte <= 0x0F) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte < 0x31) { RETURN (false); }
	    if (lowByte <= 0x56) { RETURN (true); }
	    RETURN (false);

	case 0x10:
	    if (lowByte < 0xA0) { RETURN (false); }
	    if (lowByte <= 0xCF) { RETURN (true); }
	    RETURN (false);

	case 0x1E:
	    if (lowByte < 0x96) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte < 0xA0) { RETURN (false); }
	    RETURN (TRUE_IF_EVEN(lowByte));

	case 0x1F:
	    if (lowByte <= 0x6F) {
		if (lowByte & 0x0008) { RETURN (true); }
	    }
	    if (lowByte <= 0x87) { RETURN (false); }
	    if (lowByte < 0xB8) { RETURN (false); }
	    if (lowByte < 0xBC) { RETURN (true); }
	    if (lowByte == 0xEC) { RETURN (true); }
	    if (((lowByte & 0x000F) >= 0x0008) && ((lowByte & 0x000F) <= 0x000B)) { RETURN (true); }
	    RETURN (false);

	case 0x21:
	    if (lowByte == 0x02) { RETURN (true); }
	    if (lowByte == 0x07) { RETURN (true); }
	    if (lowByte < 0x0B) { RETURN (false); }
	    if (lowByte < 0x0E) { RETURN (true); }
	    if (lowByte == 0x10) { RETURN (true); }
	    if (lowByte == 0x11) { RETURN (true); }
	    if (lowByte == 0x12) { RETURN (true); }
	    if (lowByte == 0x15) { RETURN (true); }
	    if (lowByte == 0x19) { RETURN (true); }
	    if (lowByte == 0x1A) { RETURN (true); }
	    if (lowByte == 0x1B) { RETURN (true); }
	    if (lowByte == 0x1C) { RETURN (true); }
	    if (lowByte == 0x1D) { RETURN (true); }
	    if (lowByte < 0x24) { RETURN (false); }
	    if (lowByte <= 0x2A) { RETURN (TRUE_IF_EVEN(lowByte)); }
	    if (lowByte == 0x2B) { RETURN (true); }
	    if (lowByte == 0x2C) { RETURN (true); }
	    if (lowByte == 0x2D) { RETURN (true); }
	    if (lowByte == 0x30) { RETURN (true); }
	    if (lowByte == 0x31) { RETURN (true); }
	    if (lowByte == 0x33) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (lowByte == 0x3E) { RETURN (true); }
	    if (lowByte == 0x3F) { RETURN (true); }
	    if (lowByte == 0x45) { RETURN (true); }
#endif
	    RETURN (false);

	case 0xFF:
	    if ((lowByte >= 0x21) && (lowByte <= 0x3A)) { RETURN (true); }
	    RETURN (false);

	case 0x104:
	    if (lowByte <= 0x27) { RETURN (true); }
	    RETURN (false);

	case 0x1D4:
	case 0x1D5:
	case 0x1D6:
	    if (val <= 0x1D419) { RETURN (true); }
	    if (val < 0x1D6be) {
		if (((val - 0x1D41A) % 52) <= 25) { RETURN (false); }
		RETURN (true);
	    }
	    if (val < 0x1D6c1) { RETURN (true); }
	    if (val < 0x1D6e2) { RETURN (false); }
	    if (val < 0x1D6fb) { RETURN (true); }

	    RETURN (false);
    }
    RETURN (false);

#undef TRUE_IF_ODD
#undef TRUE_IF_EVEN
%}
!

isVowel
    "return true, if I am a vowel (lower- or uppercase)"

    "/ I know the code is ugly;
    "/ better code is:
    "/     'aeiou' includes:self asLowercase
    "/ or:
    "/     'aeiouAEIOU' includes:self
    "/
    "/ until I have a smart compiler, I use the shorter (codewise):

    (self == $a) ifTrue:[^ true].
    (self == $e) ifTrue:[^ true].
    (self == $i) ifTrue:[^ true].
    (self == $o) ifTrue:[^ true].
    (self == $u) ifTrue:[^ true].
    (self == $A) ifTrue:[^ true].
    (self == $E) ifTrue:[^ true].
    (self == $I) ifTrue:[^ true].
    (self == $O) ifTrue:[^ true].
    (self == $U) ifTrue:[^ true].
    ^ false
! !

!Character methodsFor:'testing - national'!

asNonDiacritical
    "return a new character which represents the receiver without diacritics.
     This is used with string search and when lists are to be ordered/sorted by base character order.
     CAVEAT:
	for now, this method is only correct for unicode characters up to u+2FF,
	i.e. latin languages"

%{  /* NOCONTEXT */

    REGISTER INT val;

    /* because used so often, this is open coded, instead of table driven */
    val = __intVal(__INST(asciivalue));
    switch (val >> 8) {
	case 0x00:
	    if (val < 0xC0) { RETURN(self); }
	    if (val <= 0xC6) { val = 'A'; break; }
	    if (val == 0xC7) { val = 'C'; break; }
	    if (val <= 0xCB) { val = 'E'; break; }
	    if (val <= 0xCF) { val = 'I'; break; }
	    if (val == 0xD0) { val = 'D'; break; }
	    if (val == 0xD1) { val = 'N'; break; }
	    if (val <= 0xD6) { val = 'O'; break; }
	    if (val == 0xD7) { RETURN(self) }
	    if (val == 0xD8) { val = 'O'; break; }
	    if (val <= 0xDC) { val = 'U'; break; }
	    if (val == 0xDD) { val = 'Y'; break; }

	    if (val < 0xE0) { RETURN(self) }
	    if (val <= 0xE6) { val = 'a'; break; }
	    if (val == 0xE7) { val = 'c'; break; }
	    if (val <= 0xEB) { val = 'e'; break; }
	    if (val <= 0xEF) { val = 'i'; break; }
	    if (val == 0xF0) { val = 'd'; break; }
	    if (val == 0xF1) { val = 'n'; break; }
	    if (val <= 0xF6) { val = 'o'; break; }
	    if (val == 0xF7) { RETURN(self) }
	    if (val == 0xF8) { val = 'o'; break; }
	    if (val <= 0xFC) { val = 'u'; break; }
	    if (val == 0xFD) { val = 'y'; break; }
	    if (val == 0xFF) { val = 'y'; break; }
	    RETURN (self);

	case 0x01:
	    if (val <= 0x105) { val = (val & 1) ? 'a' : 'A'; break; }
	    if (val <= 0x10D) { val = (val & 1) ? 'c' : 'C'; break; }
	    if (val <= 0x111) { val = (val & 1) ? 'd' : 'D'; break; }
	    if (val <= 0x11B) { val = (val & 1) ? 'e' : 'E'; break; }
	    if (val <= 0x123) { val = (val & 1) ? 'g' : 'G'; break; }
	    if (val <= 0x127) { val = (val & 1) ? 'h' : 'H'; break; }
	    if (val <= 0x133) { val = (val & 1) ? 'i' : 'I'; break; }
	    if (val <= 0x137) { val = (val & 1) ? 'k' : 'K'; break; }
	    if (val == 0x138) { val = 'K'; break; }
	    if (val <= 0x142) { val = (val & 1) ? 'L' : 'l'; break; }
	    if (val <= 0x148) { val = (val & 1) ? 'N' : 'n'; break; }
	    if (val <= 0x14B) { val = (val & 1) ? 'n' : 'N'; break; }
	    if (val <= 0x153) { val = (val & 1) ? 'o' : 'O'; break; }
	    if (val <= 0x159) { val = (val & 1) ? 'r' : 'R'; break; }
	    if (val <= 0x161) { val = (val & 1) ? 's' : 'S'; break; }
	    if (val <= 0x167) { val = (val & 1) ? 't' : 'T'; break; }
	    if (val <= 0x173) { val = (val & 1) ? 'u' : 'U'; break; }
	    if (val <= 0x175) { val = (val & 1) ? 'w' : 'W'; break; }
	    if (val <= 0x178) { val = (val & 1) ? 'y' : 'Y'; break; }
	    if (val <= 0x17E) { val = (val & 1) ? 'Z' : 'z'; break; }
	    RETURN (self);

	case 0x02:
	    if (val <= 0x203) { val = (val & 1) ? 'a' : 'A'; break; }
	    if (val <= 0x207) { val = (val & 1) ? 'e' : 'E'; break; }
	    if (val <= 0x20B) { val = (val & 1) ? 'i' : 'I'; break; }
	    if (val <= 0x20F) { val = (val & 1) ? 'o' : 'O'; break; }
	    if (val <= 0x213) { val = (val & 1) ? 'r' : 'R'; break; }
	    if (val <= 0x217) { val = (val & 1) ? 'u' : 'U'; break; }
	    if (val <= 0x219) { val = (val & 1) ? 's' : 'S'; break; }
	    if (val <= 0x21B) { val = (val & 1) ? 't' : 'T'; break; }
	    RETURN (self);

	case 0x03:
	    // to be done
	    RETURN (self);

	case 0x04:
	    // to be done
	    RETURN (self);
    }
    if (val <= MAX_IMMEDIATE_CHARACTER) {
	RETURN (__MKCHARACTER(val)) ;
    }
    RETURN (__MKUCHARACTER(val)) ;
%}

    "
     $e asNonDiacritical
     $é asNonDiacritical
     $ä asNonDiacritical
     $å asNonDiacritical
    "
!

isNationalAlphaNumeric
    "return true, if the receiver is a letter or digit.
     This assumes unicode encoding."

    ^ self isNationalLetter or:[self isNationalDigit]
!

isNationalDigit
    "return true, if the receiver is a digit.
     This assumes unicode encoding.
     WARNING: this method is not complete."

    |codePoint "{ Class SmallInteger }"|

    codePoint := asciivalue.

    codePoint <= 16rFF ifTrue:[                "/ u00xx - unicode latin1 page
	^ codePoint between:$0 codePoint and:$9 codePoint.
    ].

    ^ codePoint between:16rFF10 and:16rFF19
!

isNationalLetter
    "return true, if the receiver is a letter.
     CAVEAT:
	for now, this method is only correct for unicode characters up to u+1d6ff (Unicode3.1).
	(which is more than mozilla does, btw. ;-)"

%{  /* NOCONTEXT */

    REGISTER INT val;

    /* because used so often, this is open coded, instead of table driven */
    val = __intVal(__INST(asciivalue));
    switch (val >> 8) {
	case 0x00:
	    if ((unsigned INT)(val - 'A') <= ('Z' - 'A')) {
		RETURN ( true );
	    }
	    if ((unsigned INT)(val - 'a') <= ('z' - 'a')) {
		RETURN ( true );
	    }
	    if (val == 0xAA) { RETURN (true); }
	    if (val == 0xB5) { RETURN (true); }
	    if (val == 0xBA) { RETURN (true); }
	    if (val < 0xC0) { RETURN (false); }
	    if (val == 0xD7) { RETURN (false); }
	    if (val == 0xF7) { RETURN (false); }
	    RETURN (true);

	case 0x01:
	    RETURN (true);

	case 0x02:
#ifdef UNICODE_3_2
	    if (val <= 0x2B8) { RETURN (true); }
	    if (val == 0x2B9) { RETURN (false); }
	    if (val == 0x2BA) { RETURN (false); }
#else
	    if (val <= 0x2BA) { RETURN (true); }
#endif
	    if (val <= 0x2C1) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (val <= 0x2C5) { RETURN (false); }
	    if (val <= 0x2CF) { RETURN (true); }
#endif
	    if (val == 0x2D0) { RETURN (true); }
	    if (val == 0x2D1) { RETURN (true); }
	    if (val <= 0x2DF) { RETURN (false); }
	    if (val <= 0x2E4) { RETURN (true); }
	    if (val == 0x2EE) { RETURN (true); }
	    RETURN (false);

	case 0x03:
	    if (val == 0x37A) { RETURN (true); }
	    if (val <= 0x385) { RETURN (false); }
	    if (val == 0x387) { RETURN (false); }
#ifndef UNICODE_3_2
	    if (val == 0x3F6) { RETURN (false); }
#endif
	    RETURN (true);

	case 0x04:
	    if (val <= 0x481) { RETURN (true); }
	    if (val <= 0x486) { RETURN (false); }
	    if (val == 0x487) { RETURN (true); }
#ifdef UNICODE_3_2
	    if (val <= 0x48A) { RETURN (false); }
#else
	    if (val <= 0x489) { RETURN (false); }
#endif
	    RETURN (true);

	case 0x05:
	    if (val <= 0x50f) { RETURN (true); }
	    if (val <= 0x530) { RETURN (false); }
	    if (val <= 0x556) { RETURN (true); }
	    if (val <= 0x558) { RETURN (false); }
	    if (val <= 0x559) { RETURN (true); }
	    if (val <= 0x55F) { RETURN (false); }
	    if (val <= 0x587) { RETURN (true); }
	    if (val <= 0x5cf) { RETURN (false); }
	    if (val <= 0x5f2) { RETURN (true); }
	    RETURN (false);

	case 0x06:
	    if (val <= 0x620) { RETURN (false); }
	    if (val <= 0x64A) { RETURN (true); }
	    if (val <= 0x66D) { RETURN (false); }
	    if (val == 0x670) { RETURN (false); }
	    if (val <= 0x6D3) { RETURN (true); }
	    if (val == 0x6D5) { RETURN (true); }
	    if (val == 0x6E5) { RETURN (true); }
	    if (val == 0x6E6) { RETURN (true); }
	    if (val == 0x6EE) { RETURN (true); }
	    if (val == 0x6EF) { RETURN (true); }
	    if (val == 0x6FA) { RETURN (true); }
	    if (val == 0x6FB) { RETURN (true); }
	    if (val == 0x6FC) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (val == 0x6FF) { RETURN (true); }
#endif
	    RETURN (false);

	case 0x07:
	    if (val <= 0x70F) { RETURN (false); }
	    if (val == 0x711) { RETURN (false); }
	    if (val <= 0x72F) { RETURN (true); }
#ifdef UNICODE_3_2
	    if (val <= 0x74d) { RETURN (false); }
	    if (val <= 0x74e) { RETURN (true); }
#else
	    if (val <= 0x74c) { RETURN (false); }
	    if (val <= 0x74f) { RETURN (true); }
#endif
	    if (val <= 0x77F) { RETURN (false); }
	    if (val <= 0x7a5) { RETURN (true); }
	    if (val <= 0x7af) { RETURN (false); }
#ifndef UNICODE_3_2
	    if (val == 0x7B1) { RETURN (true); }
#endif
	    RETURN (false);

	case 0x09:
#ifdef UNICODE_3_2
	    if (val <= 0x904) { RETURN (false); }
#else
	    if (val <= 0x903) { RETURN (false); }
#endif
	    if (val <= 0x93B) { RETURN (true); }
	    if (val == 0x93D) { RETURN (true); }
	    if (val == 0x950) { RETURN (true); }
	    if (val <= 0x957) { RETURN (false); }
	    if (val <= 0x961) { RETURN (true); }
	    if (val <= 0x984) { RETURN (false); }
	    if (val <= 0x9BB) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (val == 0x9BD) { RETURN (true); }
#endif
	    if (val <= 0x9DB) { RETURN (false); }
	    if (val <= 0x9E1) { RETURN (true); }
	    if (val <= 0x9EF) { RETURN (false); }
	    if (val <= 0x9F1) { RETURN (true); }
	    RETURN (false);

	case 0x0A:
	    if (val <= 0xa04) { RETURN (false); }
	    if (val <= 0xa3B) { RETURN (true); }
	    if (val <= 0xa58) { RETURN (false); }
	    if (val <= 0xa65) { RETURN (true); }
	    if (val <= 0xa71) { RETURN (false); }
	    if (val <= 0xa80) { RETURN (true); }
	    if (val <= 0xa84) { RETURN (false); }
	    if (val <= 0xaBB) { RETURN (true); }
	    if (val == 0xaBD) { RETURN (true); }
	    if (val <= 0xaCF) { RETURN (false); }
#ifndef UNICODE_3_2
	    if (val == 0xAE2) { RETURN (false); }
	    if (val == 0xAE3) { RETURN (false); }
#endif
	    if (val <= 0xaE5) { RETURN (true); }
	    RETURN (false);

	case 0x0B:
	    if (val <= 0xB04) { RETURN (false); }
	    if (val <= 0xb3B) { RETURN (true); }
	    if (val == 0xb3d) { RETURN (true); }
	    if (val <= 0xb5B) { RETURN (false); }
	    if (val <= 0xb65) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (val == 0xB71) { RETURN (true); }
	    if (val == 0xB83) { RETURN (true); }
#endif
	    if (val <= 0xb84) { RETURN (false); }
	    if (val <= 0xbBB) { RETURN (true); }
	    RETURN (false);

	case 0x0c:
	    if (val <= 0xc04) { RETURN (false); }
	    if (val <= 0xc3d) { RETURN (true); }
	    if (val <= 0xc5f) { RETURN (false); }
	    if (val <= 0xc65) { RETURN (true); }
	    if (val <= 0xc84) { RETURN (false); }
#ifndef UNICODE_3_2
	    if (val == 0xcbc) { RETURN (false); }
#endif
	    if (val <= 0xcbd) { RETURN (true); }
	    if (val <= 0xcdc) { RETURN (false); }
	    if (val <= 0xce5) { RETURN (true); }
	    RETURN (false);

	case 0x0d:
	    if (val <= 0xd04) { RETURN (false); }
	    if (val <= 0xd3d) { RETURN (true); }
	    if (val <= 0xd5f) { RETURN (false); }
	    if (val <= 0xd65) { RETURN (true); }
	    if (val <= 0xd84) { RETURN (false); }
	    if (val <= 0xdc9) { RETURN (true); }
	    RETURN (false);

	case 0x0E:
	    if (val == 0xE31) { RETURN (false); }
	    if (val <= 0xE33) { RETURN (true); }
	    if (val <= 0xE3F) { RETURN (false); }
	    if (val <= 0xE46) { RETURN (true); }
	    if (val <= 0xE7f) { RETURN (false); }
	    if (val <= 0xEb0) { RETURN (true); }
	    if (val == 0xEb1) { RETURN (false); }
	    if (val <= 0xEb3) { RETURN (true); }
	    if (val <= 0xEbc) { RETURN (false); }
	    if (val <= 0xEc7) { RETURN (true); }
	    if (val <= 0xEdb) { RETURN (false); }
	    RETURN (true);

	case 0x0F:
	    if (val == 0xf00) { RETURN (true); }
	    if (val <= 0xf3F) { RETURN (false); }
	    if (val <= 0xf70) { RETURN (true); }
	    if (val <= 0xf87) { RETURN (false); }
	    if (val <= 0xf8f) { RETURN (true); }
	    RETURN (false);

	case 0x10:
	    if (val <= 0x102b) { RETURN (true); }
	    if (val <= 0x104f) { RETURN (false); }
	    if (val <= 0x1055) { RETURN (true); }
	    if (val <= 0x109f) { RETURN (false); }
	    if (val <= 0x10fa) { RETURN (true); }
	    RETURN (false);

	case 0x11:
	case 0x12:
	    RETURN (true);

	case 0x13:
	    if (val <= 0x1360) { RETURN (true); }
	    if (val <= 0x139f) { RETURN (false); }
	    RETURN (true);

	case 0x14:
	case 0x15:
	    RETURN (true);

	case 0x16:
	    if (val == 0x166d) { RETURN (false); }
	    if (val == 0x166e) { RETURN (false); }
	    if (val == 0x1680) { RETURN (false); }
	    if (val == 0x169b) { RETURN (false); }
	    if (val == 0x169c) { RETURN (false); }
	    if (val <= 0x16ea) { RETURN (true); }
	    RETURN (false);

	case 0x17:
#ifndef UNICODE_3_2
	    if (val == 0x1712) { RETURN (false); }
	    if (val == 0x1713) { RETURN (false); }
	    if (val == 0x1714) { RETURN (false); }
	    if (val == 0x1732) { RETURN (false); }
	    if (val == 0x1733) { RETURN (false); }
	    if (val == 0x1734) { RETURN (false); }
	    if (val == 0x1735) { RETURN (false); }
	    if (val == 0x1736) { RETURN (false); }
	    if (val == 0x1752) { RETURN (false); }
	    if (val == 0x1753) { RETURN (false); }
	    if (val == 0x1772) { RETURN (false); }
	    if (val == 0x1773) { RETURN (false); }
#endif
	    if (val <= 0x17b3) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (val == 0x17D7) { RETURN (true); }
	    if (val == 0x17DC) { RETURN (true); }
#endif
	    RETURN (false);

	case 0x18:
	    if (val <= 0x181f) { RETURN (false); }
	    if (val <= 0x18a8) { RETURN (true); }
	    RETURN (false);

	case 0x19:
#ifndef UNICODE_3_2
	    if (val <= 0x191F) { RETURN (true); }
	    if (val <= 0x194F) { RETURN (false); }
	    if (val <= 0x197F) { RETURN (true); }
#endif
	    RETURN (false);

	case 0x1d:
	    if (val <= 0x1d6B) { RETURN (true); }
	    RETURN (false);

	case 0x1e:
	    RETURN (true);

	case 0x1f:
	    if (val <= 0x1fbc) { RETURN (true); }
	    if (val == 0x1fbe) { RETURN (true); }
	    if (val <= 0x1fc1) { RETURN (false); }
	    if (val <= 0x1fcc) { RETURN (true); }
	    if (val <= 0x1fcf) { RETURN (false); }
	    if (val <= 0x1fdc) { RETURN (true); }
	    if (val <= 0x1fdf) { RETURN (false); }
	    if (val <= 0x1fec) { RETURN (true); }
	    if (val <= 0x1ff1) { RETURN (false); }
	    if (val <= 0x1ffc) { RETURN (true); }
	    RETURN (false);

	case 0x20:
#ifndef UNICODE_3_2
	    if (val == 0x2071) { RETURN (true); }
#endif
	    if (val == 0x207f) { RETURN (true); }
	    RETURN (false);

	case 0x21:
	    if (val == 0x2102) { RETURN (true); }
	    if (val == 0x2107) { RETURN (true); }
	    if (val <= 0x2109) { RETURN (false); }
	    if (val <= 0x2113) { RETURN (true); }
	    if (val == 0x2115) { RETURN (true); }
	    if (val <= 0x2118) { RETURN (false); }
	    if (val <= 0x211d) { RETURN (true); }
	    if (val <= 0x2123) { RETURN (false); }
	    if (val == 0x2125) { RETURN (false); }
	    if (val == 0x2127) { RETURN (false); }
	    if (val == 0x2129) { RETURN (false); }
	    if (val == 0x212E) { RETURN (false); }
	    if (val == 0x2132) { RETURN (false); }
	    if (val == 0x213A) { RETURN (false); }
#ifndef UNICODE_3_2
	    if (val == 0x213B) { RETURN (false); }
	    if (val <= 0x213F) { RETURN (true); }
	    if (val <= 0x2144) { RETURN (false); }
	    if (val == 0x214A) { RETURN (false); }
	    if (val == 0x214B) { RETURN (false); }
#endif
	    if (val <= 0x2152) { RETURN (true); }
	    RETURN (false);

	case 0x30:
	    if (val == 0x3005) { RETURN (true); }
	    if (val == 0x3006) { RETURN (true); }
	    if (val <= 0x3030) { RETURN (false); }
	    if (val <= 0x3035) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (val == 0x303B) { RETURN (true); }
	    if (val == 0x303C) { RETURN (true); }
#endif
	    if (val <= 0x3040) { RETURN (false); }
	    if (val <= 0x3098) { RETURN (true); }
	    if (val <= 0x309c) { RETURN (false); }
#ifndef UNICODE_3_2
	    if (val == 0x30A0) { RETURN (false); }
#endif
	    if (val == 0x30Fb) { RETURN (false); }
	    RETURN ((true));

	case 0x31:
	    if (val <= 0x318f) { RETURN (true); }
	    if (val <= 0x319F) { RETURN (false); }
	    RETURN ((true));

	case 0x34:
	    RETURN ((true));

	case 0x4d:
	    if (val <= 0x4DB4) { RETURN (false); }
#ifndef UNICODE_3_2
	    if (val <= 0x4DBF) { RETURN (true); }
	    RETURN (false);
#else
	    RETURN (true);
#endif

	case 0x4e:
	    RETURN ((true));

	case 0x9f:
	    if (val <= 0x9fa4) { RETURN (false); }
	    RETURN (true);

	case 0xA0:
	case 0xA1:
	case 0xA2:
	case 0xA3:
	    RETURN (true);

	case 0xA4:
	    if (val <= 0xa48f) { RETURN (true); }
	    RETURN (false);

	case 0xA5:
	    RETURN (true);

	case 0xAC:
	    RETURN (true);

	case 0xD7:
	    RETURN (true);

	case 0xF9:
	case 0xFA:
	    RETURN (true);

	case 0xFB:
	    if (val == 0xfb1e) { RETURN (false); }
	    if (val == 0xfb29) { RETURN (false); }
	    RETURN (true);

	case 0xFC:
	    RETURN (true);

	case 0xFD:
	    if (val <= 0xFD3d) { RETURN (true); }
	    if (val <= 0xFD4F) { RETURN (false); }
#ifndef UNICODE_3_2
	    if (val == 0xFDFC) { RETURN (false); }
	    if (val == 0xFDFD) { RETURN (false); }
#endif
	    RETURN (true);

	case 0xFE:
#ifndef UNICODE_3_2
	    if (val <= 0xFE0F) { RETURN (false); }
#endif
	    if (val <= 0xFE1f) { RETURN (true); }
	    if (val <= 0xFE6F) { RETURN (false); }
	    if (val <= 0xFEFE) { RETURN (true); }
	    RETURN (false);

	case 0xFF:
	    if (val <= 0xFF20) { RETURN (false); }
	    if (val <= 0xFF3a) { RETURN (true); }
	    if (val <= 0xFF40) { RETURN (false); }
	    if (val <= 0xFF5a) { RETURN (true); }
	    if (val <= 0xFF65) { RETURN (false); }
	    if (val <= 0xFFdC) { RETURN (true); }
	    RETURN (false);

	case 0x100:
#ifndef UNICODE_3_2
	    RETURN (true);
#else
	    RETURN (false);
#endif

	case 0x103:
	    if (val <= 0x1031f) { RETURN (true); }
	    if (val <= 0x1032F) { RETURN (false); }
	    if (val <= 0x10349) { RETURN (true); }
#ifndef UNICODE_3_2
	    if (val <= 0x1037F) { RETURN (false); }
	    if (val <= 0x1039E) { RETURN (true); }
#endif
	    RETURN (false);

	case 0x104:
#ifndef UNICODE_3_2
	    if (val <= 0x1049F) { RETURN (true); }
	    if (val <= 0x104aF) { RETURN (false); }
#endif
	    RETURN (true);

	case 0x108:
#ifndef UNICODE_3_2
	    RETURN (true);
#else
	    RETURN (false);
#endif

	case 0x1D4:
	case 0x1D5:
	    RETURN (true);

	case 0x1D6:
	    if (val == 0x1d6c1) { RETURN (false); }
	    if (val == 0x1d6db) { RETURN (false); }
	    if (val == 0x1d6fb) { RETURN (false); }
	    RETURN (true);
    }
    RETURN (false);
%}
! !

!Character methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceCharacter:self level:level from:referrer

! !

!Character methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitCharacter:with: to aVisitor"

    ^ aVisitor visitCharacter:self with:aParameter
! !

!Character class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
