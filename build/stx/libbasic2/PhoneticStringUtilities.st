"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PhoneticStringUtilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Support'
!

Object subclass:#PhoneticStringComparator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:PhoneticStringUtilities
!

PhoneticStringUtilities::PhoneticStringComparator subclass:#ExtendedSoundexStringComparator
	instanceVariableNames:''
	classVariableNames:'CharacterTranslationDict'
	poolDictionaries:''
	privateIn:PhoneticStringUtilities
!

PhoneticStringUtilities::PhoneticStringComparator subclass:#KoelnerPhoneticCodeStringComparator
	instanceVariableNames:''
	classVariableNames:'CharacterTranslationDict'
	poolDictionaries:''
	privateIn:PhoneticStringUtilities
!

PhoneticStringUtilities::PhoneticStringComparator subclass:#SoundexStringComparator
	instanceVariableNames:''
	classVariableNames:'CharacterTranslationDict'
	poolDictionaries:''
	privateIn:PhoneticStringUtilities
!

PhoneticStringUtilities::SoundexStringComparator subclass:#MySQLSoundexStringComparator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:PhoneticStringUtilities
!

Object subclass:#NYSIISStringComparator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:PhoneticStringUtilities
!

PhoneticStringUtilities::PhoneticStringComparator subclass:#PhonemStringComparator
	instanceVariableNames:''
	classVariableNames:'CharacterTranslationDict'
	poolDictionaries:''
	privateIn:PhoneticStringUtilities
!

PhoneticStringUtilities::PhoneticStringComparator subclass:#DoubleMetaphoneStringComparator
	instanceVariableNames:'inputKey primaryTranslation secondaryTranslation startIndex
		currentIndex skipCount'
	classVariableNames:''
	poolDictionaries:''
	privateIn:PhoneticStringUtilities
!

PhoneticStringUtilities::SoundexStringComparator subclass:#MiracodeStringComparator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:PhoneticStringUtilities
!

!PhoneticStringUtilities class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2009 by eXept Software AG
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
    Utilities which are helpful to perform phonetic string searches or comparisons.
    These are all variations or improvements of the soundex algorithm, which usually fails
    to provide good results for non-english languages.
    
    soundexCode
        this algorithm was originally contained in the CharacterArray class;

    nysiis
        a modified soundex algorithm

    miracode
        another modified soundex algorithm ('american soundex') used in the 1880 census.

    mySQLSoundex
        another modified soundex algorithm used in mySQL.

    koelner phoneticCode 
        provides a functionality similar to soundex, but much more tuned towards the German language

    Double metaphone 
        works with most european languages.

    phonem
        described in Georg Wilde and Carsten Meyer, 'Doppelgaenger gesucht - Ein Programm fuer kontextsensitive phonetische Textumwandlung'
        from 'ct Magazin fuer Computer & Technik 25/1999'.

    More info for german readers is found in:
        http://www.uni-koeln.de/phil-fak/phonetik/Lehre/MA-Arbeiten/magister_wilz.pdf
"
!

sampleData
"
    for the 50 most common german names, we get:

                            ext. 
    name        soundex   soundex   metaphone   phonet  phonet2     phonix      daitsch phonem      koeln

    müller      M460    54600000    MLR         MÜLA    NILA        M4000000    689000  MYLR        657
    schmidt     S253    25300000    SKMTT       SHMIT   ZNIT        S5300000    463000  CMYD        8628
    schneider   S253    25360000    SKNTR       SHNEIDA ZNEITA      S5300000    463900  CNAYDR      8627
    fischer     F260    12600000    FSKR        FISHA   FIZA        F8000000    749000  VYCR        387
    weber       W160    16000000    WBR         WEBA    FEBA        $1000000    779000  VBR         317
    meyer       M600    56000000    MYR         MEIA    NEIA        M0000000    619000  MAYR        67
    wagner      W256    25600000    WKNR        WAKNA   FAKNA       $2500000    756900  VACNR       367
    schulz      S242    24200000    SKLS        SHULS   ZULZ        S4800000    484000  CULC        85
    becker      B260    12600000    BKR         BEKA    BEKA        B2000000    759000  BCR         147
    hoffmann    H155    15500000    HFMN        HOFMAN  UFNAN       $7550000    576600  OVMAN       036
    schäfer     S216    21600000    SKFR        SHEFA   ZEFA        S7000000    479000  CVR         837
"
! !

!PhoneticStringUtilities class methodsFor:'phonetic codes'!

koelnerPhoneticCodeOf:aString
    "return a koelner phonetic code.
     The koelnerPhonetic code is for the german language what the soundex code is for english;
     it returns simular strings for similar sounding words. 
     There are some differences to soundex, though: 
        its length is not limited to 4, but depends on the length of the original string;
        it does not start with the first character of the input.
     This algorithm is described by Postel 1969"

    ^ (KoelnerPhoneticCodeStringComparator new phoneticStringsFor:aString) first

    "
     #(
        'Müller'
        'Miller'
        'Mueller'
        'Mühler'
        'Mühlherr'
        'Mülherr'
        'Myler'
        'Millar'
        'Myller'
        'Müllar'
        'Müler'
        'Muehler'
        'Mülller'
        'Müllerr'
        'Muehlherr'
        'Muellar'
        'Mueler'
        'Mülleer'
        'Mueller'
        'Nüller'
        'Nyller'
        'Niler'
        'Czerny'
        'Tscherny'
        'Czernie'
        'Tschernie'
        'Schernie'
        'Scherny'
        'Scherno'
        'Czerne'
        'Zerny'
        'Tzernie'
        'Breschnew'
     ) do:[:w |
         Transcript show:w; show:'->'; showCR:(PhoneticStringUtilities koelnerPhoneticCodeOf:w)
     ].
    "

    "
     PhoneticStringUtilities koelnerPhoneticCodeOf:'Breschnew'. '17863'.
     PhoneticStringUtilities koelnerPhoneticCodeOf:'Breschneff'. '17863'.
     PhoneticStringUtilities koelnerPhoneticCodeOf:'Braeschneff'. '17863'.
     PhoneticStringUtilities koelnerPhoneticCodeOf:'Braessneff'. '17863'.
     PhoneticStringUtilities koelnerPhoneticCodeOf:'Pressneff'. '17863'.
     PhoneticStringUtilities koelnerPhoneticCodeOf:'Presznäph'. '17863'.
     PhoneticStringUtilities koelnerPhoneticCodeOf:'Preschnjiev'. '17863'.
    "
!

mySQLSoundexCodeOf:aString
    "return the mySQL soundex code. The mysql soundex coed is different from the miracode 'american' soundex
     (no 4char limitation; different order of duplicate vowel vs. duplicate code elimination)"

    ^ (MySQLSoundexStringComparator new phoneticStringsFor:aString) first

    "
     #(
        'Müller'
        'Miller'
        'Mueller'
        'Mühler'
        'Mühlherr'
        'Mülherr'
        'Myler'
        'Millar'
        'Myller'
        'Müllar'
        'Müler'
        'Muehler'
        'Mülller'
        'Müllerr'
        'Muehlherr'
        'Muellar'
        'Mueler'
        'Mülleer'
        'Mueller'
        'Nüller'
        'Nyller'
        'Niler'
        'Czerny'
        'Tscherny'
        'Czernie'
        'Tschernie'
        'Schernie'
        'Scherny'
        'Scherno'
        'Czerne'
        'Zerny'
        'Tzernie'
        'Breschnew'
     ) do:[:w |
         Transcript show:w; show:'->'; showCR:(PhoneticStringUtilities mySQLSoundexCodeOf:w)
     ].
    "

    "
     PhoneticStringUtilities mySQLSoundexCodeOf:'Breschnew'. 
     PhoneticStringUtilities mySQLSoundexCodeOf:'Breschneff'. 
     PhoneticStringUtilities mySQLSoundexCodeOf:'Braeschneff'. 
     PhoneticStringUtilities mySQLSoundexCodeOf:'Braessneff'.
     PhoneticStringUtilities mySQLSoundexCodeOf:'Pressneff'. 
     PhoneticStringUtilities mySQLSoundexCodeOf:'Presznäph'. 
     PhoneticStringUtilities mySQLSoundexCodeOf:'Preschnjiev'.
    "
!

soundexCodeOf:aString
    "return a soundex phonetic code or nil.
     Soundex (1918, 1922) returns similar codes for similar sounding words, making it a useful
     tool when searching for words where the correct spelling is unknown.
     (read Knuth or search the web if you don't know what a soundex code is).
     Caveat: 'similar sounding words' means: 'similar sounding in english'."

    ^ (SoundexStringComparator new phoneticStringsFor:aString) first

"/ old code - now use code in private class...
"/    |inStream codeStream ch last lch codeLength codes code lastCode|
"/
"/    inStream := aString readStream.
"/    inStream skipSeparators.
"/    inStream atEnd ifTrue:[
"/        ^ nil
"/    ].
"/
"/    ch := inStream next.
"/    ch isLetter ifFalse:[
"/        ^ nil
"/    ].
"/    codeLength := 0.
"/
"/    codes := Dictionary new.
"/    codes atAll:'bpfv'     put:$1.
"/    codes atAll:'cskgjqxz' put:$2.
"/    codes atAll:'dt'       put:$3.
"/    codes atAll:'l'        put:$4.
"/    codes atAll:'nm'       put:$5.
"/    codes atAll:'r'        put:$6.
"/
"/    codeStream := WriteStream on:(String new:4).
"/    codeStream nextPut:(ch asUppercase).
"/    last := ch asLowercase.
"/    lastCode := codes at:last ifAbsent:nil.
"/
"/    [inStream atEnd] whileFalse:[
"/        ch := inStream next.
"/        lch := ch asLowercase.
"/        lch = last ifFalse:[
"/            last := lch.
"/
"/            code := codes at:lch ifAbsent:nil.
"/            (code notNil and:[ code ~= lastCode]) ifTrue:[
"/                codeLength < 3 ifTrue:[
"/                    codeStream nextPut:code.
"/                    codeLength := codeLength + 1.
"/                    codeLength > 3 ifTrue:[^ codeStream contents].
"/                ].
"/            ].
"/            lastCode := code.
"/        ]
"/    ].
"/    [ codeLength < 3 ] whileTrue:[
"/        codeStream nextPut:$0.
"/        codeLength := codeLength + 1.
"/    ].
"/
"/    ^ codeStream contents

    "
     PhoneticStringUtilities soundexCodeOf:'claus'   
     PhoneticStringUtilities soundexCodeOf:'clause'   
     PhoneticStringUtilities soundexCodeOf:'close'   
     PhoneticStringUtilities soundexCodeOf:'smalltalk' 
     PhoneticStringUtilities soundexCodeOf:'smaltalk'  
     PhoneticStringUtilities soundexCodeOf:'smaltak'   
     PhoneticStringUtilities soundexCodeOf:'smaltok'   
     PhoneticStringUtilities soundexCodeOf:'smoltok'   
     PhoneticStringUtilities soundexCodeOf:'aa'        
     PhoneticStringUtilities soundexCodeOf:'by'        
     PhoneticStringUtilities soundexCodeOf:'bab'       
     PhoneticStringUtilities soundexCodeOf:'bob'       
     PhoneticStringUtilities soundexCodeOf:'bop'       
    "
! !

!PhoneticStringUtilities class methodsFor:'queries'!

isUtilityClass
    ^ self == PhoneticStringUtilities
! !

!PhoneticStringUtilities::PhoneticStringComparator class methodsFor:'constant'!

defaultClass
	^SoundexStringComparator
! !

!PhoneticStringUtilities::PhoneticStringComparator class methodsFor:'documentation'!

documentation
"
    abstract superclass for various phonetic comparators.
    They returns similar strings for similar sounding words, which can be used
    to find similar sounding words in a search list.
    
    Notice, that some comparators are better for particular languages.
"
! !

!PhoneticStringUtilities::PhoneticStringComparator class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!PhoneticStringUtilities::PhoneticStringComparator class methodsFor:'queries'!

isAbstract
    ^ self == PhoneticStringUtilities::PhoneticStringComparator
! !

!PhoneticStringUtilities::PhoneticStringComparator methodsFor:'api'!

does:aString soundLike:anotherString 
    |translations1 translations2|

    translations1 := self phoneticStringsFor:aString.
    translations2 := self phoneticStringsFor:anotherString.

    ^ translations1 contains:[:t1 | 
        translations2 contains:[:t2 | t1 = t2]]

    "
     PhoneticStringUtilities::SoundexStringComparator new
            does:'miller' soundLike:'miler'.   
     PhoneticStringUtilities::SoundexStringComparator new
            does:'miller' soundLike:'milner'.   
    "
!

phoneticStringsFor: aString
    "Should answer an array of alternate phonetic strings for the given input string."
    self subclassResponsibility

    "
     (PhoneticStringUtilities::SoundexStringComparator new
            phoneticStringsFor:'miller') first      
     'miller' asSoundexCode 
    "
! !

!PhoneticStringUtilities::PhoneticStringComparator methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)

    "/ super initialize.   -- commented since inherited method does nothing
! !

!PhoneticStringUtilities::ExtendedSoundexStringComparator class methodsFor:'documentation'!

documentation
"
    There are many extended and enhanced soundex variants around;
    here is one, called 'extended soundex'. It is destribed for example in
    http://www.epidata.dk/documentation.php.
    An author or origin is unknown.

    The number of digits is increased to 5 or 8;
    The first character is not used literally; instead it is encoded like the rest.
    This might have a negative effect on names starting with a vovel, though.

    Overall, it can be doubted if this is really an enhancement after all.
"
! !

!PhoneticStringUtilities::ExtendedSoundexStringComparator methodsFor:'api'!

phoneticStringsFor:aString
    "generates both an extended soundex of length 5 and one of length 8"

    |first second u t prevCode|

    u := aString asUppercase.
    first := second := ''.
    u do:[:c | 
        t := self translate:c.
        (t notNil and:[ t ~= '0' and:[ t ~= prevCode ]]) ifTrue:[
            first := first , t.
            second := second , t.
            second size == 8 ifTrue:[
                ^ Array with:(first copyTo:5) with:second 
            ].
        ].
        prevCode := t
    ].
    [ first size < 5 ] whileTrue:[
        first := first , '0'.
        second := second , '0'.
    ].
    [ second size < 8 ] whileTrue:[
        second := second , '0'
    ].
    ^ Array with:first with:second

    "
     self basicNew phoneticStringsFor:'müller'  #('87900' '87900000')  
     self basicNew phoneticStringsFor:'miller'  #('87900' '87900000')   
     self basicNew phoneticStringsFor:'muller'  #('87900' '87900000')    
     self basicNew phoneticStringsFor:'muler'   #('87900' '87900000')
     self basicNew phoneticStringsFor:'schmidt'    #('38600' '38600000')
     self basicNew phoneticStringsFor:'schneider'  #('38690' '38690000')
     self basicNew phoneticStringsFor:'fischer'    #('23900' '23900000')
     self basicNew phoneticStringsFor:'weber'      #('19000' '19000000')
     self basicNew phoneticStringsFor:'meyer'      #('89000' '89000000')
     self basicNew phoneticStringsFor:'wagner'     #('48900' '48900000')
     self basicNew phoneticStringsFor:'schulz'     #('37500' '37500000')
     self basicNew phoneticStringsFor:'becker'     #('13900' '13900000')
     self basicNew phoneticStringsFor:'hoffmann'   #('28800' '28800000')
     self basicNew phoneticStringsFor:'schäfer'    #('32900' '32900000')
    "
! !

!PhoneticStringUtilities::ExtendedSoundexStringComparator methodsFor:'private'!

translate:aCharacter
    "use simple if's for more speed when compiled"

    "vowels serve as separators"
    aCharacter == $A ifTrue:[^ '0' ].         
    aCharacter == $E ifTrue:[^ '0' ].
    aCharacter == $I ifTrue:[^ '0' ].
    aCharacter == $O ifTrue:[^ '0' ].
    aCharacter == $U ifTrue:[^ '0' ].
    aCharacter == $Y ifTrue:[^ '0' ].

    aCharacter == $B ifTrue:[^ '1' ]. 
    aCharacter == $P ifTrue:[^ '1' ].

    aCharacter == $F ifTrue:[^ '2' ]. 
    aCharacter == $V ifTrue:[^ '2' ]. 

    aCharacter == $C ifTrue:[^ '3' ]. 
    aCharacter == $S ifTrue:[^ '3' ]. 
    aCharacter == $K ifTrue:[^ '3' ].

    aCharacter == $G ifTrue:[^ '4' ]. 
    aCharacter == $J ifTrue:[^ '4' ].

    aCharacter == $Q ifTrue:[^ '5' ]. 
    aCharacter == $X ifTrue:[^ '5' ]. 
    aCharacter == $Z ifTrue:[^ '5' ]. 

    aCharacter == $D ifTrue:[^ '6' ]. 
    aCharacter == $G ifTrue:[^ '6' ]. 
    aCharacter == $T ifTrue:[^ '6' ]. 

    aCharacter == $L ifTrue:[^ '7' ]. 

    aCharacter == $M ifTrue:[^ '8' ]. 
    aCharacter == $N ifTrue:[^ '8' ]. 

    aCharacter == $R ifTrue:[^ '9' ]. 
    ^ nil
! !

!PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator class methodsFor:'documentation'!

documentation
"
     The koelnerPhonetic code is for the german language what the soundex code is for english.
     It returns similar strings for similar sounding words. 

     There are some differences to soundex, though: 
        its length is not limited to 4, but depends on the length of the original string;
        it does not start with the first character of the input.

     This algorithm was described by Postel 1969
"
! !

!PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator methodsFor:'api'!

phoneticStringsFor: aString
    "return a koelner phonetic code.
     The koelnerPhonetic code is for the german language what the soundex code is for english;
     it returns simular strings for similar sounding words. 
     There are some differences to soundex, though: 
        its length is not limited to 4, but depends on the length of the original string;
        it does not start with the first character of the input.
     This algorithm is described by Postel 1969"

    |in ret val rslt|

    in := aString withoutSeparators asLowercase.
    in := in copyReplaceString:'ph' withString:'f'.
    in := in copyReplaceAll:$ü withAll:'u'.
    in := in copyReplaceAll:$ä withAll:'a'.
    in := in copyReplaceAll:$ö withAll:'o'.
    in := in copyReplaceAll:$ß withAll:'ss'.
    in := '#',in,'#'.

    ret := ''.
    1 to:in size-2 do:[:i |
        |sub|

        sub := in copyFrom:i to:i+2.
        val := (i==1) 
                    ifTrue:[ self convertFirst:sub ] 
                    ifFalse:[ self convertRest:sub ].
        ret := ret,val
    ].

    ret := ret select:[:ch | ch ~= $-].

    (ret startsWith:'0') ifTrue:[
        ret := '0',(ret select:[:ch | ch ~= $0]).
    ] ifFalse:[
        ret := ret select:[:ch | ch ~= $0].
    ].

    rslt := String streamContents:[:s |
        |prev|

        ret do:[:ch |
            ch ~= prev ifTrue:[
                s nextPut:ch
            ].
            prev := ch.
        ].
      ].
    ^ Array with:rslt.

    "
     #(
        'Müller'
        'Miller'
        'Mueller'
        'Mühler'
        'Mühlherr'
        'Mülherr'
        'Myler'
        'Millar'
        'Myller'
        'Müllar'
        'Müler'
        'Muehler'
        'Mülller'
        'Müllerr'
        'Muehlherr'
        'Muellar'
        'Mueler'
        'Mülleer'
        'Mueller'
        'Nüller'
        'Nyller'
        'Niler'
        'Czerny'
        'Tscherny'
        'Czernie'
        'Tschernie'
        'Schernie'
        'Scherny'
        'Scherno'
        'Czerne'
        'Zerny'
        'Tzernie'
        'Breschnew'
     ) do:[:w |
         Transcript show:w; show:'->'; showCR:(PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator new phoneticStringsFor:w) first
     ].
    "

    "
     PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator new phoneticStringsFor:'Breschnew' -> '17863'
     PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator new phoneticStringsFor:'Breschneff' -> '17863'
     PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator new phoneticStringsFor:'Braeschneff' -> '17863'
     PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator new phoneticStringsFor:'Braessneff' -> '17863'
     PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator new phoneticStringsFor:'Pressneff' -> '17863'
     PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator new phoneticStringsFor:'Presznäph' -> '17863'
     PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator new phoneticStringsFor:'Präschnäf' -> '17863'
    "
    "
     self basicNew phoneticStringsFor:'müller'      #('657')    
     self basicNew phoneticStringsFor:'möller'      #('657')
     self basicNew phoneticStringsFor:'miller'      #('657')     
     self basicNew phoneticStringsFor:'muller'      #('657')
     self basicNew phoneticStringsFor:'muler'       #('657')
     self basicNew phoneticStringsFor:'schmidt'     #('862')   
     self basicNew phoneticStringsFor:'schneider'   #('8627') 
     self basicNew phoneticStringsFor:'fischer'     #('387') 
     self basicNew phoneticStringsFor:'weber'       #('317') 
     self basicNew phoneticStringsFor:'meyer'       #('67') 
     self basicNew phoneticStringsFor:'wagner'      #('3467') 
     self basicNew phoneticStringsFor:'schulz'      #('858')
     self basicNew phoneticStringsFor:'becker'      #('147')
     self basicNew phoneticStringsFor:'hoffmann'    #('036')
     self basicNew phoneticStringsFor:'schäfer'     #('837') 
    "
! !

!PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator methodsFor:'private'!

convertFirst:chars
    #(
        ('#a#' '0')
        ('#e#' '0')
        ('#i#' '0')
        ('#j#' '0')
        ('#y#' '0')
        ('#o#' '0')
        ('#u#' '0')

        ('#ca' '4')
        ('#ch' '4')
        ('#ck' '4')
        ('#cl' '4')
        ('#co' '4')
        ('#cq' '4')
        ('#cr' '4')
        ('#cu' '4')
        ('#cx' '4')

        ('#c#' '8')
    ) do:[:pair | 
        (pair first match:chars) ifTrue:[
            ^ pair second
        ]
    ].

    ^ self convertRest:chars
!

convertRest:chars
    #(
        ('#ds' '8')
        ('#dc' '8')
        ('#dz' '8')
        ('#ts' '8')
        ('#tc' '8')
        ('#tz' '8')
        ('#d#' '2')
        ('#t#' '2')
        ('cx#' '8')
        ('kx#' '8')
        ('qx#' '8')
        ('#x#' '48')
        ('sc#' '8')
        ('sz#' '8')
        ('#ca' '4')
        ('#co' '4')
        ('#cu' '4')
        ('#ch' '4')
        ('#ck' '4')
        ('#cx' '4')
        ('#cq' '4')
        ('#c#' '8')
        ('#a#' '0')
        ('#e#' '0')
        ('#i#' '0')
        ('#j#' '0')
        ('#y#' '0')
        ('#o#' '0')
        ('#u#' '0')
        ('#h#' '-')
        ('#l#' '5')
        ('#r#' '7')
        ('#m#' '6')
        ('#n#' '6')
        ('#s#' '8')
        ('#z#' '8')
        ('#b#' '1')
        ('#p#' '1')
        ('#f#' '3')
        ('#v#' '3')
        ('#w#' '3')
        ('#g#' '4')
        ('#k#' '4')
        ('#q#' '4')
        ('###' '?')
    ) do:[:pair | 
        (pair first match:chars) ifTrue:[
            ^ pair second
        ]
    ].

    self error:'cannot happen'
! !

!PhoneticStringUtilities::SoundexStringComparator class methodsFor:'documentation'!

documentation
"
    WARNING: this is the so called 'simplified soundex' algorithm;
      there are more variants like miracode (american soundex) or mysqlSoundex around.
      Be sure to use the correct algorithm, if the generated strings must be compatible
      (otherwise, the differences are probably too small to be noticed as effect, but
      your search will be different)

    The following was copied from http://www.civilsolutions.com.au/publications/dedup.htm

    SOUNDEX is a phonetic coding algorithm that ignores many of the unreliable
    components of names, but by doing so reports more matches. 

    There are some variations around in the literature; 
    the following is called 'simplified soundex', and the rules for coding a name are:

    1. The first letter of the name is used in its un-coded form to serve as the prefix
       character of the code. (The rest of the code is numerical).

    2. Thereafter, W and H are ignored entirely.

    3. A, E, I, 0, U, Y are not assigned a code number, but do serve as 'separators' (see Step 5).

    4. Other letters of the name are converted to a numerical equivalent:
                 B, P, F, V              1 
                 C, G, J, K, Q, S, X, Z  2 
                 D, T                    3 
                 L                       4 
                 M, N                    5 
                 R                       6 

    5. There are two exceptions: 
        1. Letters that follow prefix letters which would, if coded, have the same
           numerical code, are ignored in all cases unless a ''separator'' (see Step 3) precedes them.

        2. The second letter of any pair of consonants having the same code number is likewise ignored, 
           i.e. unless there is a ''separator'' between them in the name.

    6. The final SOUNDEX code consists of the prefix letter plus three numerical characters.
       Longer codes are truncated to this length, and shorter codes are extended to it by adding zeros.

    Notice, that in another variant, w and h are treated slightly differently.
    This is only of relevance, if you need to reconstruct original soundex codes of other programs
    or for the original 1880 us census data.
    
    Also notice, that soundex deals better with english. 
    For german and other languages, other algorithms may provide better results.
"
! !

!PhoneticStringUtilities::SoundexStringComparator methodsFor:'api'!

phoneticStringsFor:aString 
    |u p t prevCode|

    u := aString asUppercase.
    p := u first asString.
    prevCode := self translate:u first.
    u from:2 to:u size do:[:c | 
        t := self translate:c.
        (t notNil and:[ t ~= '0' and:[ t ~= prevCode ]]) ifTrue:[
            p := p , t.
            p size == 4 ifTrue:[^ Array with:p ].
        ].
        prevCode := t
    ].
    [ p size < 4 ] whileTrue:[
        p := p , '0'
    ].
    ^ Array with:(p copyFrom:1 to:4)
! !

!PhoneticStringUtilities::SoundexStringComparator methodsFor:'private'!

translate:aCharacter
    "use simple if's for more speed when compiled"

    "vowels serve as separators"
    aCharacter == $A ifTrue:[^ '0' ].         
    aCharacter == $E ifTrue:[^ '0' ].
    aCharacter == $I ifTrue:[^ '0' ].
    aCharacter == $O ifTrue:[^ '0' ].
    aCharacter == $U ifTrue:[^ '0' ].
    aCharacter == $Y ifTrue:[^ '0' ].

    aCharacter == $B ifTrue:[^ '1' ]. 
    aCharacter == $P ifTrue:[^ '1' ]. 
    aCharacter == $F ifTrue:[^ '1' ]. 
    aCharacter == $V ifTrue:[^ '1' ]. 

    aCharacter == $C ifTrue:[^ '2' ]. 
    aCharacter == $S ifTrue:[^ '2' ]. 
    aCharacter == $K ifTrue:[^ '2' ]. 
    aCharacter == $G ifTrue:[^ '2' ]. 
    aCharacter == $J ifTrue:[^ '2' ]. 
    aCharacter == $Q ifTrue:[^ '2' ]. 
    aCharacter == $X ifTrue:[^ '2' ]. 
    aCharacter == $Z ifTrue:[^ '2' ]. 

    aCharacter == $D ifTrue:[^ '3' ]. 
    aCharacter == $T ifTrue:[^ '3' ]. 

    aCharacter == $L ifTrue:[^ '4' ]. 

    aCharacter == $M ifTrue:[^ '5' ]. 
    aCharacter == $N ifTrue:[^ '5' ]. 

    aCharacter == $R ifTrue:[^ '6' ]. 
    ^ nil
! !

!PhoneticStringUtilities::MySQLSoundexStringComparator class methodsFor:'documentation'!

documentation
"
    MySQL soundex is like american Soundex (i.e. miracode) without the 4 character limitation,
    and also removing vokals first, then removing duplicate codes
    (whereas the soundex code does this in reverse order).

    These variations are important, if you need the miracode soundex codes to be generated.
"
! !

!PhoneticStringUtilities::MySQLSoundexStringComparator methodsFor:'api'!

phoneticStringsFor:aString 
    |u p t prevCode|

    u := aString asUppercase.
    p := u first asString.
    prevCode := self translate:u first.
    u from:2 to:u size do:[:c |
        t := self translate:c.
        (t notNil and:[ t ~= '0' and:[ t ~= prevCode ]]) ifTrue:[
            p := p , t.
        ].
        (t ~= '0' and:[ c ~= $W and:[c ~= $H]]) ifTrue:[
            prevCode := t.
        ].
    ].
    [ p size < 4 ] whileTrue:[
        p := p , '0'
    ].
    ^ Array with:p
! !

!PhoneticStringUtilities::NYSIISStringComparator class methodsFor:'documentation'!

documentation
"
    NYSIIS Algorithm:

    1.
        remove all ''S'' and ''Z'' chars from the end of the surname 

    2.
        transcode initial strings
            MAC => MC
            PF => F

    3.
        Transcode trailing strings as follows,
        
            IX => IC
            EX => EC
            YE,EE,IE => Y
            NT,ND => D 

    4.
        transcode ''EV'' to ''EF'' if not at start of name

    5.
        use first character of name as first character of key 

    6.
        remove any ''W'' that follows a vowel 

    7.
        replace all vowels with ''A'' 

    8.
        transcode ''GHT'' to ''GT'' 

    9.
        transcode ''DG'' to ''G'' 

    10.
        transcode ''PH'' to ''F'' 

    11.
        if not first character, eliminate all ''H'' preceded or followed by a vowel 

    12.
        change ''KN'' to ''N'', else ''K'' to ''C'' 

    13.
        if not first character, change ''M'' to ''N'' 

    14.
        if not first character, change ''Q'' to ''G'' 

    15.
        transcode ''SH'' to ''S'' 

    16.
        transcode ''SCH'' to ''S'' 

    17.
        transcode ''YW'' to ''Y'' 

    18.
        if not first or last character, change ''Y'' to ''A'' 

    19.
        transcode ''WR'' to ''R'' 

    20.
        if not first character, change ''Z'' to ''S'' 

    21.
        transcode terminal ''AY'' to ''Y'' 

    22.
        remove traling vowels 

    23.
        collapse all strings of repeated characters 

    24.
        if first char of original surname was a vowel, append it to the code
"
! !

!PhoneticStringUtilities::NYSIISStringComparator methodsFor:'api'!

phoneticStringsFor:aString 
    |k|

    k := self rule1:(aString asUppercase).
    k := self rule2:k.
    k := self rule3:k.
    k := self rule4:k.
    k := self rule5:k.
    k := self rule6:k.
    k := self rule7:k.
    k := self rule8:k.
    k := self rule9:k.
    k := self rule10:k.
    k := self rule11:k.
    k := self rule12:k.
    k := self rule13:k.
    k := self rule14:k.
    k := self rule15:k.
    k := self rule16:k.
    k := self rule17:k.
    k := self rule18:k.
    k := self rule19:k.
    k := self rule20:k.
    k := self rule21:k.
    k := self rule22:k.
    k := self rule23:k.
    k := self rule24:k originalKey:aString.
    ^ Array with:k

    "
     self new phoneticStringsFor:'hello'
     self new phoneticStringsFor:'bliss'
    "
! !

!PhoneticStringUtilities::NYSIISStringComparator methodsFor:'private'!

rule10:key 
    "10. transcode 'PH' to 'F' "
    
    ^ self 
        transcodeAll:'PH'
        of:key
        to:'F'
        startingAt:1
!

rule11:key 
    |k c|

    "11. if not first character, eliminate all 'H' preceded or followed by a vowel "
    k := key copy.
    c := SortedCollection sortBlock:[:a :b | b < a ].
    2 to:key size do:[:i | 
        (key at:i) = $H ifTrue:[
            ((key at:i - 1) isVowel 
                or:[ (i < key size) and:[ (key at:i + 1) isVowel ] ]) ifTrue:[ c add:i ]
        ]
    ].
    c do:[:n | 
        k := (k copyFrom:1 to:n - 1) , (k copyFrom:n + 1 to:k size)
    ].
    ^ k
!

rule12:key 
    |k|

    "12. change 'KN' to 'N', else 'K' to 'C' "
    k := self 
                transcodeAll:'KN'
                of:key
                to:'K'
                startingAt:1.
    k := self 
                transcodeAll:'K'
                of:k
                to:'C'
                startingAt:1.
    ^ k
!

rule13:key 
    "13. if not first character, change 'M' to 'N' "
    
    ^ self 
        transcodeAll:'M'
        of:key
        to:'N'
        startingAt:2
!

rule14:key 
    "14. if not first character, change 'Q' to 'G' "
    
    ^ self 
        transcodeAll:'Q'
        of:key
        to:'G'
        startingAt:2
!

rule15:key 
    "15. transcode 'SH' to 'S' "
    
    ^ self 
        transcodeAll:'SH'
        of:key
        to:'S'
        startingAt:1
!

rule16:key 
    "16. transcode 'SCH' to 'S' "
    
    ^ self 
        transcodeAll:'SCH'
        of:key
        to:'S'
        startingAt:1
!

rule17:key 
    "17. transcode 'YW' to 'Y' "
    
    ^ self 
        transcodeAll:'YW'
        of:key
        to:'Y'
        startingAt:1
!

rule18:key 
    |k|

    "18. if not first or last character, change 'Y' to 'A' "
    k := self 
                transcodeAll:'Y'
                of:key
                to:'A'
                startingAt:2.
    key last = $Y ifTrue:[
        k at:k size put:$Y
    ].
    ^ k
!

rule19:key 
    "19. transcode 'WR' to 'R' "
    
    ^ self 
        transcodeAll:'WR'
        of:key
        to:'R'
        startingAt:1
!

rule1:key 
    |k|

    k := key copy.
     "1. Remove all 'S' and 'Z' chars from the end of the name"
    [
        'SZ' includes:k last
    ] whileTrue:[ k := k copyFrom:1 to:(k size - 1) ].
    ^ k
!

rule20:key 
    "20. if not first character, change 'Z' to 'S' "
    
    ^ self 
        transcodeAll:'Z'
        of:key
        to:'S'
        startingAt:2
!

rule21:key 
    "21. transcode terminal 'AY' to 'Y' "
    
    ^ self 
        transcodeAll:'AY'
        of:key
        to:'Y'
        startingAt:key size - 1
!

rule22:key 
    |k|

    "22. remove trailing vowels "
    k := key copy.
    [ k last isVowel ] whileTrue:[
        k := k copyFrom:1 to:k size - 1
    ].
    ^ k
!

rule23:key 
    |k c|

    "23. collapse all strings of repeated characters "
    k := key copy.
    c := SortedCollection sortBlock:[:a :b | b < a ].
    k size to:2 do:[:i | 
        (k at:i) = (k at:i - 1) ifTrue:[
            c add:i
        ]
    ].
    c do:[:n | 
        k := (k copyFrom:1 to:n - 1) , (k copyFrom:n + 1 to:k size)
    ].
    ^ k
!

rule24:key originalKey:originalKey 
    |k|

    "24. if first char of original surname was a vowel, append it to the code"
    k := key copy.
    originalKey first isVowel ifTrue:[
        k := k , originalKey first asString asUppercase
    ].
    ^ k
!

rule2:key 
    |k|

    k := key copy.
     "2. Transcode initial strings:  MAC => MC   PF => F"
    (k startsWith:'MAC') ifTrue:[
        k := 'MC' , (k copyFrom:4)
    ].
    (k startsWith:'PF') ifTrue:[
        k := 'F' , (k copyFrom:3)
    ].
    ^ k
!

rule3:key 
    |k|

    "3. Transcode trailing strings as follows:
        IX => IC
          EX => EC
          YE, EE, IE => Y
           NT, ND => D"
    k := key copy.
    k := self 
                transcodeTrailing:#( 'IX' )
                of:k
                to:'IC'.
    k := self 
                transcodeTrailing:#( 'EX' )
                of:k
                to:'EC'.
    k := self 
                transcodeTrailing:#( 'YE' 'EE' 'IE' )
                of:k
                to:'Y'.
    k := self 
                transcodeTrailing:#( 'NT' 'ND' )
                of:k
                to:'D'.
    ^ k
!

rule4:key 
    "4. Transcode 'EV' to 'EF' if not at start of name"
    
    ^ self 
        transcodeAll:'EV'
        of:key
        to:'EF'
        startingAt:2
!

rule5:key 
    "5. Use first character of name as first character of key.  Ignored because we're doing an in-place conversion"
    
    ^ key
!

rule6:key 
    |k i|

    "6. Remove any 'W' that follows a vowel"
    k := key copy.
    i := 2.
    [
        (i := k indexOf:$W startingAt:i) > 0
    ] whileTrue:[
        (k at:i - 1) isVowel ifTrue:[
            k := (k copyFrom:1 to:i - 1) , (k copyFrom:i + 1 to:k size).
            i := i - 1
        ]
    ].
    ^ k
!

rule7:key 
    |k|

    "7. replace all vowels with 'A' "
    k := key copy.
    1 to:key size do:[:i | 
        (key at:i) isVowel ifTrue:[
            k at:i put:$A
        ]
    ].
    ^ k
!

rule8:key 
    "8. transcode 'GHT' to 'GT' "
    
    ^ self 
        transcodeAll:'GHT'
        of:key
        to:'GT'
        startingAt:1
!

rule9:key 
    "9. transcode 'DG' to 'G' "
    
    ^ self 
        transcodeAll:'DG'
        of:key
        to:'G'
        startingAt:1
!

transcodeAll:aString of:key to:replacementString startingAt:start 
    |k i|

    k := key copy.
    [
        (i := k indexOfSubCollection:aString startingAt:start) > 0
    ] whileTrue:[
        k := (k copyFrom:1 to:i - 1) , replacementString 
                    , (k copyFrom:i + aString size to:k size)
    ].
    ^ k
!

transcodeTrailing:anArrayOfStrings of:key to:replacementString 
    |answer|

    answer := key copy.
    anArrayOfStrings do:[:aString | 
        answer := self 
                    transcodeAll:aString
                    of:answer
                    to:replacementString
                    startingAt:(answer size - aString size) + 1
    ].
    ^ answer
! !

!PhoneticStringUtilities::PhonemStringComparator class methodsFor:'documentation'!

documentation
"
    Implementation of the PHONEM algorithm, as described in
    'Georg Wilde and Carsten Meyer, Doppelgaenger gesucht -
    Ein Programm fuer kontextsensitive phonetische Textumwandlung
    ct Magazin fuer Computer & Technik 25/1998'
    
    This algorithm deals better with the german language (it cares for umlauts)
"
! !

!PhoneticStringUtilities::PhonemStringComparator methodsFor:'api'!

phoneticStringsFor:aString 
    |s idx t t2|

    s := aString asUppercase.

    idx := 1.
    [idx < (s size-1)] whileTrue:[
        t2 := nil.
        t := s copyFrom:idx to:idx+1.
        t = 'SC' ifTrue:[ t2 := 'C' ]
        ifFalse:[ t = 'SZ' ifTrue:[ t2 := 'C' ]
        ifFalse:[ t = 'CZ' ifTrue:[ t2 := 'C' ]
        ifFalse:[ t = 'TZ' ifTrue:[ t2 := 'C' ]
        ifFalse:[ t = 'TS' ifTrue:[ t2 := 'C' ]
        ifFalse:[ t = 'KS' ifTrue:[ t2 := 'X' ]
        ifFalse:[ t = 'PF' ifTrue:[ t2 := 'V' ]
        ifFalse:[ t = 'QU' ifTrue:[ t2 := 'KW' ]
        ifFalse:[ t = 'PH' ifTrue:[ t2 := 'V' ]
        ifFalse:[ t = 'UE' ifTrue:[ t2 := 'Y' ]
        ifFalse:[ t = 'AE' ifTrue:[ t2 := 'E' ]
        ifFalse:[ t = 'OE' ifTrue:[ t2 := 'Ö' ]
        ifFalse:[ t = 'EI' ifTrue:[ t2 := 'AY' ]
        ifFalse:[ t = 'EY' ifTrue:[ t2 := 'AY' ]
        ifFalse:[ t = 'EU' ifTrue:[ t2 := 'OY' ]
        ifFalse:[ t = 'AU' ifTrue:[ t2 := 'A§' ]
        ifFalse:[ t = 'OU' ifTrue:[ t2 := '§ ' ]]]]]]]]]]]]]]]]].
        t2 notNil ifTrue:[
            s := (s copyTo:idx-1),t2,(s copyFrom:idx+2)
        ] ifFalse:[
            idx := idx + 1.
        ].
    ].

    "/ single character substitutions via tr
    s := s copyTransliterating:'ÖÄZKGQÜIJFWPT§' to:'YECCCCYYYVVDDUA'.
    s := s copyTransliterating:'ABCDLMNORSUVWXY' to:'' complement:true squashDuplicates:false.
    s := s copyTransliterating:'ABCDLMNORSUVWXY' to:'ABCDLMNORSUVWXY' complement:false squashDuplicates:true.
    ^ Array with:s

    "
     self basicNew phoneticStringsFor:'müller'  #('MYLR')    
     self basicNew phoneticStringsFor:'mueller' #('MYLR')    
     self basicNew phoneticStringsFor:'möller'  #('MYLR')
     self basicNew phoneticStringsFor:'miller'  #('MYLR')     
     self basicNew phoneticStringsFor:'muller'  #('MULR') 
     self basicNew phoneticStringsFor:'muler'   #('MULR') 
     self basicNew phoneticStringsFor:'schmidt'     #('CMYD')
     self basicNew phoneticStringsFor:'schneider'   #('CNAYDR')
     self basicNew phoneticStringsFor:'fischer'     #('VYCR')
     self basicNew phoneticStringsFor:'weber'       #('VBR')
     self basicNew phoneticStringsFor:'meyer'       #('MAYR')
     self basicNew phoneticStringsFor:'wagner'      #('VACNR')
     self basicNew phoneticStringsFor:'schulz'      #('CULC')
     self basicNew phoneticStringsFor:'becker'      #('BCR')
     self basicNew phoneticStringsFor:'hoffmann'    #('OVMAN')
     self basicNew phoneticStringsFor:'schäfer'     #('CVR')
     self basicNew phoneticStringsFor:'scheffer'    #('CVR')
     self basicNew phoneticStringsFor:'schaeffer'   #('CVR')
     self basicNew phoneticStringsFor:'schaefer'    #('CVR')
    "
! !

!PhoneticStringUtilities::DoubleMetaphoneStringComparator class methodsFor:'LICENSE'!

copyright
"
Copyright (c) 2002-2004 Robert Jarvis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation 
files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, 
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom 
the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial 
portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE 
USE OR OTHER DEALINGS IN THE SOFTWARE.'
"
! !

!PhoneticStringUtilities::DoubleMetaphoneStringComparator class methodsFor:'classification'!

isSlavoGermanic:aString
    ^ #('w' 'k' 'cz' 'witz') contains:[:sub | aString includesString:sub]

    "
     self isSlavoGermanic:'walter'
    "
! !

!PhoneticStringUtilities::DoubleMetaphoneStringComparator class methodsFor:'documentation'!

documentation
"
    The Double Metaphone algorithm:
    see internet
"
! !

!PhoneticStringUtilities::DoubleMetaphoneStringComparator methodsFor:'accessing'!

currentIndex
	^currentIndex
!

currentIndex: anInteger
	currentIndex := anInteger
!

inputKey
	^inputKey
!

inputKey: aString
	inputKey := aString asUppercase
!

primaryTranslation
	^primaryTranslation
!

primaryTranslation: anObject
	primaryTranslation := anObject
!

secondaryTranslation
	^secondaryTranslation
!

secondaryTranslation: anObject
	secondaryTranslation := anObject
!

skipCount
	^skipCount
!

skipCount: anInteger
	skipCount := anInteger
!

startIndex
	^startIndex
!

startIndex: anObject
	startIndex := anObject
! !

!PhoneticStringUtilities::DoubleMetaphoneStringComparator methodsFor:'api'!

phoneticStringsFor: aString
        "Private - Answers an array of alternate phonetic strings for the given input string."

        self inputKey: aString.
        self performInitialProcessing.
        self processRemainingCharacters.

        ^ Array with: primaryTranslation with: secondaryTranslation
! !

!PhoneticStringUtilities::DoubleMetaphoneStringComparator methodsFor:'initialization'!

initialize
	super initialize.

	self
		startIndex: 1;
		primaryTranslation: '';
		secondaryTranslation: '';
		skipCount: 0;
		currentIndex: 1
! !

!PhoneticStringUtilities::DoubleMetaphoneStringComparator methodsFor:'private'!

addPrimaryTranslation: aString
	self primaryTranslation: self primaryTranslation, aString
!

addSecondaryTranslation: aString
	self secondaryTranslation: self secondaryTranslation, aString
!

decrementSkipCount
	self skipCount: self skipCount - 1
!

incrementSkipCount
	self incrementSkipCount: 1
!

incrementSkipCount: anInteger
	self skipCount: self skipCount + anInteger
!

incrementStartIndex
	self startIndex: self startIndex + 1
!

isSlavoGermanic: aString
	^((aString includesAnyOf: 'WK') or:
		[ (aString indexOfSubCollection: 'CZ' startingAt: 1) >= 1 ]) or:
		[ (aString indexOfSubCollection: 'WITZ' startingAt: 1) >= 1 ]
!

keyAt: anInteger
	(anInteger >=1 and: [ anInteger <= self inputKey size ])
		ifTrue: [ ^self inputKey at: anInteger ]
		ifFalse: [ ^$  ]
!

keyLeftString: lengthInteger
	^self keyMidString: lengthInteger from: 1
!

keyMidString: lengthInteger from: fromInteger
	| result from len additionalSpaces |

	result := ''.
	from := fromInteger.
	len := lengthInteger.

	"Prepend spaces if caller is requesting characters from before the start of the string"

	[ from < 1 ] whileTrue:
		[ result := result, ' '.
		from := from + 1.
		len := len - 1 ].

	from + len - 1 > self inputKey size
		ifTrue:
			[ additionalSpaces := from + len - 1 - self inputKey size.
			len := self inputKey size - from + 1 ]
		ifFalse: [ additionalSpaces := 0 ].

	result := result, (self inputKey copyFrom: from to: (from+len-1 min: self inputKey size)).

	[ additionalSpaces > 0 ] whileTrue:
		[ result := result, ' '.
		additionalSpaces := additionalSpaces - 1 ].

	^result
!

keyRightString: lengthInteger
	^self keyMidString: lengthInteger from: self inputKey size - lengthInteger + 1
!

performInitialProcessing
	(#('GN' 'KN' 'PN' 'WR' 'PS') includes: (self inputKey copyFrom: 1 to: 2))
		ifTrue: [ self incrementStartIndex ].

	(self keyAt: 1) = $X
		ifTrue:
			[ self
				addPrimaryTranslation: 'S';
				addSecondaryTranslation: 'S'.
			self incrementStartIndex ].

	(self keyAt: 1) isVowel
		ifTrue:
			[ self
				addPrimaryTranslation: 'A';
				addSecondaryTranslation: 'A'.
			self incrementStartIndex ]
!

processB
        self
                addPrimaryTranslation: 'P';
                addSecondaryTranslation: 'P'.
        (self keyAt: (currentIndex + 1)) = $B
                ifTrue: [ self incrementSkipCount ].
!

processC
        "i"
        ((((currentIndex >= 3
                and: [ (self keyAt: currentIndex-2) isVowel not ])
                and: [ (self keyMidString: 3 from: currentIndex-1) = 'ACH' ])
                and: [ (self keyAt: currentIndex+2) ~= $I ])
                and: [ ((self keyAt: currentIndex+2) ~= $E)
                                or: [ (self keyMidString: 6 from: currentIndex-2) ~= 'BACHER'
                                                and: [ (self keyMidString: 6 from: currentIndex-2) ~= 'MACHER' ] ] ])
                        ifTrue:
                                [ self addPrimaryTranslation: 'K'.
                                self addSecondaryTranslation: 'K'.
                                self incrementSkipCount: 2.
                                ^self ].

        "ii"
        (self inputKey beginsWith: 'CAESAR')
                ifTrue:
                        [ self addPrimaryTranslation: 'S'.
                        self addSecondaryTranslation: 'S'.
                        self incrementSkipCount: 1.
                        ^self ].

        "iii"
        (self keyMidString: 4 from: currentIndex) = 'CHIA'
                ifTrue:
                        [ self addPrimaryTranslation: 'K'.
                        self addSecondaryTranslation: 'K'.
                        self incrementSkipCount: 1.
                        ^self ].

        "iv"
        (self keyMidString: 2 from: currentIndex) = 'CH'
                ifTrue:
                        [ (currentIndex > 1                "a"
                                        and: [ (self keyMidString: 4 from: currentIndex) = 'CHAE' ])
                                ifTrue: [ self
                                                addPrimaryTranslation: 'K';
                                                addSecondaryTranslation: 'X';
                                                incrementSkipCount: 1.
                                                ^self ].

                        (currentIndex = 1          "b"
                                        and: [ (self inputKey size > 5 and: [(self inputKey copyFrom: 1 to: 6) = 'CHARAC'
                                                        or: [ (self inputKey copyFrom: 1 to: 6) = 'CHARIS' ]] )
                                                or: [self inputKey size > 4 and: [ ((((self inputKey copyFrom: 1 to: 4) = 'CHOR'
                                                        or: [ (self inputKey copyFrom: 1 to: 4) = 'CHYM' ])
                                                        or: [ (self inputKey copyFrom: 1 to: 4) = 'CHIA' ])
                                                        or: [ (self inputKey copyFrom: 1 to: 4) = 'CHEM' ])
                                                        and: [ (self inputKey copyFrom: 1 to: 4) ~= 'CHORE' ] ] ] ])
                                ifTrue: [ self
                                                addPrimaryTranslation: 'K';
                                                addSecondaryTranslation: 'K';
                                                incrementSkipCount: 1.
                                                ^self ].

                        (((((#('VAN ' 'VON ') includes: (self inputKey copyFrom: 1 to: 4))              "c"
                                        or: [ (self inputKey copyFrom: 1 to: 3) = 'SCH' ])
                                        or: [ #('ORCHES' 'ARCHIT' 'ORCHID')
                                                        includes: (self keyMidString: 6 from: currentIndex-2) ])
                                        or: [ #($T $S) includes: (self keyAt: currentIndex+2) ])
                                        or: [ ((currentIndex = 1)
                                                        or: [ #($A $O $U $E) includes: (self keyAt: currentIndex-1) ])
                                                and: [ #($L $R $N $M $B $H $F $V $W $ ) includes: (self keyAt: currentIndex+2) ] ] )
                                ifTrue:
                                        [ self
                                                addPrimaryTranslation: 'K';
                                                addSecondaryTranslation: 'K';
                                                incrementSkipCount: 1.
                                                ^self ]
                                ifFalse:
                                        [ currentIndex > 1
                                                ifTrue:
                                                        [ (self inputKey copyFrom: 1 to: 2) = 'MC'
                                                                ifTrue:
                                                                                [ self
                                                                                                addPrimaryTranslation: 'K';
                                                                                                addSecondaryTranslation: 'K' ]
                                                                ifFalse:
                                                                                [ self
                                                                                                addPrimaryTranslation: 'X';
                                                                                                addSecondaryTranslation: 'K' ] ]
                                                ifFalse:
                                                        [ self
                                                                addPrimaryTranslation: 'X';
                                                                addSecondaryTranslation: 'X' ].
                                        self incrementSkipCount: 1.
                                        ^self ] ].

        "v"
        (self keyAt: currentIndex+1) = $Z
                ifTrue:
                        [ self
                                addPrimaryTranslation: 'S';
                                addSecondaryTranslation: 'X';
                                incrementSkipCount: 1.
                                ^self ].

        "vi"
        (self keyMidString: 3 from: currentIndex+1) = 'CIA'
                ifTrue:
                        [ self
                                addPrimaryTranslation: 'X';
                                addSecondaryTranslation: 'X';
                                incrementSkipCount: 2.
                                ^self ].

        "vii"
        ((self keyAt: currentIndex+1) = $C
                        and: [ ((currentIndex = 2)
                                and: [ (self keyAt: 1) = $M ]) not ])
                ifTrue:
                        [ ((#($I $E $H) includes: (self keyAt: currentIndex+2))
                                        and: [ (self keyMidString: 2 from: currentIndex+2) ~= 'HU' ])
                                ifTrue:
                                        [ ((currentIndex = 2 and: [ (self keyAt: 1) = $A ])
                                                        or: [ #('UCCEE' 'UCCES') includes: (self keyMidString: 5 from: currentIndex-1)])
                                                ifTrue:
                                                        [self
                                                                addPrimaryTranslation: 'KS';
                                                                addSecondaryTranslation: 'KS';
                                                                incrementSkipCount: 2.
                                                                ^self ]
                                                ifFalse:
                                                        [self
                                                                addPrimaryTranslation: 'X';
                                                                addSecondaryTranslation: 'X';
                                                                incrementSkipCount: 2.
                                                                ^self ] ]
                                ifFalse:
                                        [ self
                                                addPrimaryTranslation: 'K';
                                                addSecondaryTranslation: 'K';
                                                incrementSkipCount: 2.
                                                ^self ] ].

        "viii"
        (#($K $G $Q) includes: (self keyAt: currentIndex+1))
                ifTrue:
                        [ self
                                addPrimaryTranslation: 'K';
                                addSecondaryTranslation: 'K';
                                incrementSkipCount: 1.
                                ^self ].

        "ix"
        (#($I $E $Y) includes: (self keyAt: currentIndex+1))
                ifTrue:
                        [ (#('CIO' 'CIE' 'CIA') includes: (self keyMidString: 3 from: currentIndex))
                                ifTrue:
                                        [self
                                                addPrimaryTranslation: 'S';
                                                addSecondaryTranslation: 'X' ]
                                ifFalse:
                                        [self
                                                addPrimaryTranslation: 'S';
                                                addSecondaryTranslation: 'S'].
                        self incrementSkipCount: 1.
                        ^self ].

        "x"
        self
                addPrimaryTranslation: 'K';
                addSecondaryTranslation: 'K'.

        "xi"
        (#(' C' ' Q' ' G') includes: (self keyMidString: 2 from: currentIndex+1))
                ifTrue:
                        [ self incrementSkipCount: 2 ]
                ifFalse:
                        [ ((#($C $K $Q) includes: (self keyAt: currentIndex+1))
                                        and: [ (#('CE' 'CI') includes: (self keyMidString: 2 from: currentIndex+1)) not ])
                                ifTrue: [ self incrementSkipCount: 1] ]
!

processCedille 
	self
		addPrimaryTranslation: 'S';
		addSecondaryTranslation: 'S'
!

processD
        "i"
        (self keyAt: currentIndex+1) = $G
                ifTrue:
                        [ (#($I $E $Y) includes: (self keyAt: currentIndex+2))
                                ifTrue:
                                        [ self
                                                addPrimaryTranslation: 'J';
                                                addSecondaryTranslation: 'J';
                                                incrementSkipCount: 2.
                                        ^self ]
                                ifFalse:
                                        [ self
                                                addPrimaryTranslation: 'TK';
                                                addSecondaryTranslation: 'TK';
                                                incrementSkipCount: 1.
                                        ^self ] ].

        "ii"
        (#($T $D) includes: (self keyAt: currentIndex+1))
                ifTrue:
                        [ self
                                addPrimaryTranslation: 'T';
                                addSecondaryTranslation: 'T';
                                incrementSkipCount: 1.
                        ^self ].

        "iii"
        self
                addPrimaryTranslation: 'T';
                addSecondaryTranslation: 'T'
!

processF
	self
		addPrimaryTranslation: 'F';
		addSecondaryTranslation: 'F'.
	(self keyAt: self currentIndex+1) = $F
		ifTrue: [ self incrementSkipCount: 1 ]
!

processG
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'G':
                if(GetAt(current + 1) == 'H')
          {"
        | word |
        (self keyAt: currentIndex + 1) = $H
        ifTrue: [
                "if((current > 0) AND !!IsVowel(current - 1))"

                (currentIndex > 1 and: [(self keyAt: currentIndex - 1) isVowel not])
                ifTrue: [
              " {
                   MetaphAdd(K);
                   current += 2;
                   break;
                }"

                        self addPrimaryTranslation: 'K';
                        addSecondaryTranslation: 'K'.
                        ^self incrementSkipCount: 1 
                ].

                "if(current < 3)
          {"

                currentIndex < 4 
                ifTrue: [

                        " //'ghislane', ghiradelli
               if(current == 0)
               { "
                        currentIndex = 1 
                        ifTrue: [
                                "if(GetAt(current + 2) == 'I')"

                                (self keyAt: currentIndex + 2) = $I
                                ifTrue: [
                                        "MetaphAdd(J);"
                                        self addPrimaryTranslation: 'J';
                                        addSecondaryTranslation: 'J'.
                                ] ifFalse: [
                                        "MetaphAdd(K);"
                                        self addPrimaryTranslation: 'K';
                                        addSecondaryTranslation: 'K'.
                                ].
                                "  current += 2;
                                break;"
                                ^self incrementSkipCount: 1 
                        ]
                ].

                " //Parker's rule (with some further refinements) - e.g., 'hugh'
                if(((current > 1) AND StringAt((current - 2), 1, B, H, D, ) )
                //e.g., 'bough'
                OR ((current > 2) AND StringAt((current - 3), 1, B, H, D, ) )
                //e.g., 'broughton'
                OR ((current > 3) AND StringAt((current - 4), 1, B, H, ) ) )
         "
                (((currentIndex > 2 and: [#($B $H $D) includes: (self keyAt: currentIndex - 2)]) 
                or: [currentIndex > 3 and: [#($B $H $D) includes: (self keyAt: currentIndex - 3)]])  
                or: [currentIndex > 4 and: [#($B $H) includes: (self keyAt: currentIndex - 4)]])   
                ifTrue: [                         
                        "current += 2;
                        break;"
                        ^self incrementSkipCount: 1 
                ] ifFalse: [
                        " //e.g., 'laugh', 'McLaughlin', 'cough', 'gough', 'rough', 'tough'
               if((current > 2) 
               AND (GetAt(current - 1) == 'U') 
               AND StringAt((current - 3), 1, C, G, L, R, T, ) )"
                        (currentIndex > 3 and: [
                                ((self keyAt: currentIndex - 1) = $U) and: [
                                        #($C $G $L $R $T) includes: (self keyAt: currentIndex - 3)
                                ]
                        ]) ifTrue: [
                                "MetaphAdd(F);"
                                self addPrimaryTranslation: 'F';
                                addSecondaryTranslation: 'F'.
                        ] ifFalse: [
                                " if((current > 0) AND GetAt(current - 1) !!= 'I')
                    MetaphAdd(K);"
                                (currentIndex > 1 and: [(self keyAt: currentIndex - 1) ~= $I])
                                ifTrue: [
                                        self addPrimaryTranslation: 'K';
                                        addSecondaryTranslation: 'K'.
                                ].
                        ].
                        ^self incrementSkipCount: 1 
                ].
        ].
                "if(GetAt(current + 1) == 'N')"
          (self keyAt: currentIndex + 1) = $N
                ifTrue: [
                        "if((current == 1) AND IsVowel(0) AND !!SlavoGermanic())"
                        (currentIndex = 2 and: [(self inputKey at: 1) isVowel and: [(self isSlavoGermanic: self inputKey) not]])
               ifTrue: [
                                "MetaphAdd(KN, N);"
                                self addPrimaryTranslation: 'KN';
                                addSecondaryTranslation: 'N'.
                        ] ifFalse: [
                                " //not e.g. 'cagney'
                                if(!!StringAt((current + 2), 2, EY, ) 
                                AND (GetAt(current + 1) !!= 'Y') 
                                AND !!SlavoGermanic())"
                                ((self inputKey size >= (currentIndex + 2)) and: [
                                        (self inputKey copyFrom: currentIndex + 2 to: (currentIndex + 4 min: self inputKey size)) ~= 'EY' and: [
                                                (self keyAt: currentIndex + 1) ~= $Y and: [
                                                        (self isSlavoGermanic: self inputKey) not
                                                ]
                                        ]
                                ]) ifTrue: [
                                        self addPrimaryTranslation: 'N';
                                        addSecondaryTranslation: 'KN'.
                                ] ifFalse: [
                                        self addPrimaryTranslation: 'KN';
                                        addSecondaryTranslation: 'KN'.
                                ].
                        ].
                        ^self incrementSkipCount: 1 
                ].
                " //'tagliaro'
                if(StringAt((current + 1), 2, LI, ) AND !!SlavoGermanic())"
                ((self inputKey size >= (currentIndex + 3)) and: [
                        (self inputKey copyFrom: currentIndex + 1 to: currentIndex + 2) = 'LI' and: [
                                (self isSlavoGermanic: self inputKey) not]])
                ifTrue: [
                        self addPrimaryTranslation: 'KL';
                        addSecondaryTranslation: 'L'.
                        ^self incrementSkipCount: 1.
                ].
                " //-ges-,-gep-,-gel-, -gie- at beginning
                if((current == 0)
                AND ((GetAt(current + 1) == 'Y') 
                OR StringAt((current + 1), 2, ES, EP, EB, EL, EY, IB, IL, IN, IE, EI, ER, )) )"
                (currentIndex = 1 and: [
                        ((self keyAt: currentIndex + 1) = $Y) or: [
                        (#('ES' 'EP' 'EB' 'EL' 'EY' 'IB' 'IL' 'IN' 'IE' 'EI' 'ER') includes: 
                                (self inputKey copyFrom: currentIndex + 1 to: currentIndex + 2))
                ]]) ifTrue: [
                        self addPrimaryTranslation: 'K';
                        addSecondaryTranslation: 'J'.
                        ^self incrementSkipCount: 1.
                ].
                " // -ger-,  -gy-
                if((StringAt((current + 1), 2, ER, ) OR (GetAt(current + 1) == 'Y'))
                AND !!StringAt(0, 6, DANGER, RANGER, MANGER, )
                AND !!StringAt((current - 1), 1, E, I, ) 
                AND !!StringAt((current - 1), 3, RGY, OGY, ) )
                "
          (((self inputKey copyFrom: currentIndex + 1 to: (currentIndex + 3 min: self inputKey size)) = 'ER' or: [
                                ((self keyAt: currentIndex + 1) = $Y)]) 
                        and: [((#('DANGER' 'RANGER' 'MANGER') includes: (word := self inputKey copyFrom: 1 to: (6 min: self inputKey size))) not)
                                and: [(self keyAt: currentIndex - 1) ~= $E
                                        and: [(#('RGY' 'OGY') includes: (self inputKey copyFrom: currentIndex - 1 to: currentIndex + 1)) not]]])
                 ifTrue: [
                        self addPrimaryTranslation: 'K';
                        addSecondaryTranslation: 'J'.
                        ^self incrementSkipCount: 1.
                ].

          " // italian e.g, 'biaggi'
           if(StringAt((current + 1), 1, E, I, Y, ) OR StringAt((current - 1), 4, AGGI, OGGI, ))
           "
                ((#($E $I $Y) includes: (self keyAt: (currentIndex + 1))) or: [(#('AGGI' 'OGGI') includes: (self inputKey copyFrom: currentIndex - 1 to: (currentIndex + 2 min: self inputKey size)))])
                ifTrue: [
                        " //obvious germanic
                                        if((StringAt(0, 4, VAN , VON , ) OR StringAt(0, 3, SCH, ))
                                                OR StringAt((current + 1), 2, ET, ))                                                MetaphAdd(K);"
                        word := (self inputKey copyFrom: 1 to: 4).
                        ((#('VAN ' 'VON ') includes: word) or: [(word copyFrom: 1 to: 3) = 'SCH' or: [(word copyFrom: 1 to: 2) = 'ET']]) 
                        ifTrue: [
                                self addPrimaryTranslation: 'K';
                                addSecondaryTranslation: 'K'.
                        ] ifFalse: [
                            " //always soft if french ending
                                                if(StringAt((current + 1), 4, IER , ))
                                                        MetaphAdd(J);
                                                else
                                                        MetaphAdd(J, K);
                                        current += 2;
                                        break;"
                                (((self inputKey copyFrom: currentIndex + 1 to: (currentIndex + 5 min: self inputKey size)), '    ') copyFrom: 1 to: 4) = 'IER '
                                ifTrue: [
                                        self addPrimaryTranslation: 'J';
                                        addSecondaryTranslation: 'J'.
                                ] ifFalse: [
                                        self addPrimaryTranslation: 'J';
                                        addSecondaryTranslation: 'K'.
                                ].

                        ].
                        ^self incrementSkipCount: 1.       
                ].                      

        " if(GetAt(current + 1) == 'G')
             current += 2;
         else
             current += 1;
         MetaphAdd(K);
            break;"

                (self keyAt: (currentIndex + 1)) = $G
                ifTrue: [
                        self incrementSkipCount: 1.
                ].
                self addPrimaryTranslation: 'K';
                addSecondaryTranslation: 'K'.
!

processH
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'H':
                                //only keep if first & before vowel or btw. 2 vowels
                                if(((current == 0) OR IsVowel(current - 1)) 
                                        AND IsVowel(current + 1))
                                {
                                        MetaphAdd(H);
                                        current += 2;
                                }else//also takes care of 'HH'
                                        current += 1;
                                break;
"

        (((currentIndex = 1) 
                or: [ (self keyAt: currentIndex - 1) isVowel]) 
        and: [(self keyAt: currentIndex + 1) isVowel])
        ifTrue: [               
                self addPrimaryTranslation: 'H';
                addSecondaryTranslation: 'H'.
                ^self incrementSkipCount: 1.
        ]
!

processJ
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'J':
                                //obvious spanish, 'jose', 'san jacinto'
                                if(StringAt(current, 4, JOSE, ) OR StringAt(0, 4, SAN , ) )
                                {
                                        if(((current == 0) AND (GetAt(current + 4) == ' ')) OR StringAt(0, 4, SAN , ) )
                                                MetaphAdd(H);
                                        else
                                        {
                                                MetaphAdd(J, H);
                                        }
                                        current +=1;
                                        break;
                                }

                                if((current == 0) AND !!StringAt(current, 4, JOSE, ))
                                        MetaphAdd(J, A);//Yankelovich/Jankelowicz
                                else
                                        //spanish pron. of e.g. 'bajador'
                                        if(IsVowel(current - 1) 
                                                AND !!SlavoGermanic()
                                                        AND ((GetAt(current + 1) == 'A') OR (GetAt(current + 1) == 'O')))
                                                MetaphAdd(J, H);
                                        else
                                                if(current == last)
                                                        MetaphAdd(J,  );
                                                else
                                                        if(!!StringAt((current + 1), 1, L, T, K, S, N, M, B, Z, ) 
                                                                        AND !!StringAt((current - 1), 1, S, K, L, ))
                                                                MetaphAdd(J);

                                if(GetAt(current + 1) == 'J')//it could happen!!
                                        current += 2;
                                else
                                        current += 1;
                                break;
"
        | currentWord firstWord nextLetter |
        currentWord := self inputKey copyFrom: currentIndex to: (currentIndex + 3 min: self inputKey size).
        firstWord := self inputKey copyFrom: 1 to: (4 min: self inputKey size).
        nextLetter := self keyAt: currentIndex + 1.
        (currentWord = 'JOSE' or: [firstWord = 'SAN '])
        ifTrue: [       
                ((currentIndex = 1 and: [self inputKey size = 4 or: [self inputKey size >= 5 and: [self keyAt: currentIndex + 4 = $ ]]])
                        or: [firstWord = 'SAN '])
                ifTrue: [
                        self addPrimaryTranslation: 'H';
                        addSecondaryTranslation: 'H'.
                ] ifFalse: [
                        self addPrimaryTranslation: 'J';
                        addSecondaryTranslation: 'H'.
                ].
                ^self.
        ].
        (currentIndex = 1 and: [firstWord ~= 'JOSE'])
        ifTrue: [
                self addPrimaryTranslation: 'J';
                addSecondaryTranslation: 'A'.
        ] ifFalse: [
                ((currentIndex > 1 and: [(self keyAt: currentIndex -1) isVowel])
                and: [(self isSlavoGermanic: self inputKey) not and: [nextLetter == $A or: [nextLetter == $O]]])
                ifTrue: [
                        self addPrimaryTranslation: 'J';
                        addSecondaryTranslation: 'H'.
                ] ifFalse: [
                        currentIndex = self inputKey size 
                        ifTrue: [
                                self addPrimaryTranslation: 'J';
                                addSecondaryTranslation: ' '.
                        ] ifFalse: [
                                ((#($L $T $K $S $N $M $B $Z) includes: nextLetter) not and: [(#($S $K $L) includes: (self keyAt: currentIndex - 1)) not])
                                ifTrue: [
                                        self addPrimaryTranslation: 'J';
                                        addSecondaryTranslation: 'J'.
                                ].
                        ].
                ].
        ].
        nextLetter == $J
        ifTrue: [
                self incrementSkipCount: 1.
        ].
!

processK
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'K':
                                if(GetAt(current + 1) == 'K')
                                        current += 2;
                                else
                                        current += 1;
                                MetaphAdd(K);
                                break;
        "

        (self keyAt: currentIndex + 1) = $K
        ifTrue: [
                self incrementSkipCount: 1
        ].
        self addPrimaryTranslation: 'K';
        addSecondaryTranslation: 'K'.
!

processL

"case 'L':
                                if(GetAt(current + 1) == 'L')
                                {
                                        //spanish e.g. 'cabrillo', 'gallegos'
                                        if(((current == (length - 3)) 
                                                AND StringAt((current - 1), 4, ILLO, ILLA, ALLE, ))
                                                         OR ((StringAt((last - 1), 2, AS, OS, ) OR StringAt(last, 1, A, O, )) 
                                                                AND StringAt((current - 1), 4, ALLE, )) )
                                        {
                                                MetaphAdd(L,  );
                                                current += 2;
                                                break;
                                        }
                                        current += 2;
                                }else
                                        current += 1;
                                MetaphAdd(L);
                                break;
"
        | currentWord |
        (self keyAt: currentIndex + 1) = $L 
        ifTrue: [
                (((currentIndex = (self inputKey size - 2))
                and: [(currentIndex > 1 and: [#('ILLO' 'ILLA' 'ALLE') includes: (currentWord := self inputKey copyFrom: currentIndex - 1 to: (currentIndex + 2 min: self inputKey size))])])
                or: [((#('AS' 'OS') includes: (self inputKey copyFrom: self inputKey size - 1 to: self inputKey size)) or: [#($A $O) includes: (self keyAt: self inputKey size)]) and: [currentWord = 'ALLE']
                        ])
                ifTrue: [
                        self addPrimaryTranslation: 'L';
                        addSecondaryTranslation: ' '.
                        ^self incrementSkipCount: 1.
                ].
                self incrementSkipCount: 1.
        ].
        self addPrimaryTranslation: 'L';
        addSecondaryTranslation: 'L'.   
!

processM

"case 'M':
                                if((StringAt((current - 1), 3, UMB, ) 
                                        AND (((current + 1) == last) OR StringAt((current + 2), 2, ER, )))
                                                //'dumb','thumb'
                                                OR  (GetAt(current + 1) == 'M') )
                                        current += 2;
                                else
                                        current += 1;
                                MetaphAdd(M);
                                break;
"
        (((currentIndex > 1 and: [(self inputKey copyFrom: currentIndex - 1 to: (currentIndex +1 min: self inputKey size)) = 'UMB'])
                and: [currentIndex + 1 = self inputKey size or: [(self inputKey copyFrom: (currentIndex + 2 min: self inputKey size) to: (currentIndex + 4 min: self inputKey size)) = 'ER']])
                or: [(self keyAt: currentIndex + 1) = $M])
                ifTrue: [
                        self incrementSkipCount: 1.
                ].
                self addPrimaryTranslation: 'M';
                addSecondaryTranslation: 'M'.
!

processN
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'N':
                                if(GetAt(current + 1) == 'N')
                                        current += 2;
                                else
                                        current += 1;
                                MetaphAdd(N);
                                break;

        "

        (self keyAt: currentIndex + 1) = $N
        ifTrue: [
                self incrementSkipCount: 1
        ].
        self addPrimaryTranslation: 'N';
        addSecondaryTranslation: 'N'.
!

processNtilde
        "case 'Ñ':
                                current += 1;
                                MetaphAdd(N);
                                break;
        "
        self addPrimaryTranslation: 'N';
        addSecondaryTranslation: 'N'.
!

processP
        "case 'P':
                                if(GetAt(current + 1) == 'H')
                                {
                                        MetaphAdd(F);
                                        current += 2;
                                        break;
                                }

                                //also account for campbell, raspberry
                                if(StringAt((current + 1), 1, P, B, ))
                                        current += 2;
                                else
                                        current += 1;
                                        MetaphAdd(P);
                                break;
"
        | nextLetter |
        (nextLetter := self keyAt: currentIndex + 1) = $H
        ifTrue: [
                self addPrimaryTranslation: 'F';
                addSecondaryTranslation: 'F'.
                ^self incrementSkipCount: 1.
        ].
        (#($P $B) includes: nextLetter)
        ifTrue: [
                self incrementSkipCount: 1.
        ] ifFalse: [
                self addPrimaryTranslation: 'P';
                addSecondaryTranslation: 'P'.
        ].
!

processQ
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'Q':
                                if(GetAt(current + 1) == 'Q')
                                        current += 2;
                                else
                                        current += 1;
                                MetaphAdd(K);
                                break;

        "

        (self keyAt: currentIndex + 1) = $Q
        ifTrue: [
                self incrementSkipCount: 1
        ].
        self addPrimaryTranslation: 'K';
        addSecondaryTranslation: 'K'.
!

processR
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'R':
                                //french e.g. 'rogier', but exclude 'hochmeier'
                                if((current == last)
                                        AND !!SlavoGermanic()
                                                AND StringAt((current - 2), 2, IE, ) 
                                                        AND !!StringAt((current - 4), 2, ME, MA, ))
                                        MetaphAdd(, R);
                                else
                                        MetaphAdd(R);

                                if(GetAt(current + 1) == 'R')
                                        current += 2;
                                else
                                        current += 1;
                                break;
        "
        (currentIndex = self inputKey size and: [
                (self isSlavoGermanic: self inputKey) not and: [
                        (self inputKey copyFrom: ((currentIndex - 2) max: 1) to: ((currentIndex - 1) max: 1)) = 'IE' and: [
                                (#('ME' 'MA') includes: (self inputKey copyFrom: ((currentIndex - 4) max: 1) to: ((currentIndex - 3) max: 1))) not
                        ]
                ]
        ])
        ifTrue: [
                self addPrimaryTranslation: '';
                addSecondaryTranslation: 'R'.
        ] ifFalse: [
                self addPrimaryTranslation: 'R';
                addSecondaryTranslation: 'R'.
        ].
        (self keyAt: currentIndex + 1) = $R
        ifTrue: [
                self incrementSkipCount: 1
        ].
!

processRemainingCharacters
    self startIndex to: self inputKey size do:[ :i | 
        | c methodSelector |

        self skipCount = 0 ifTrue:[ 
            ((self primaryTranslation size > 4) and: [ self secondaryTranslation size > 4 ])
                ifTrue: [ ^self ].

            self currentIndex: i.
            c := self keyAt: i.

            (c isVowel not and: [c ~= $Y]) ifTrue:[ 
                c == $Ç ifTrue: [ 
                    methodSelector := #processCedille 
                ] ifFalse: [ c == $Ñ ifTrue: [ 
                    methodSelector := #processNtilde 
                ] ifFalse: [ 
                    methodSelector := ('process', c asString) asSymbol 
                ]].
                self perform: methodSelector 
            ] 
        ] ifFalse: [ 
            self decrementSkipCount 
        ] 
    ]
!

processS
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'S':
                                //special cases 'island', 'isle', 'carlisle', 'carlysle'
                                if(StringAt((current - 1), 3, ISL, YSL, ))
                                {
                                        current += 1;
                                        break;
                                }

                                //special case 'sugar-'
                                if((current == 0) AND StringAt(current, 5, SUGAR, ))
                                {
                                        MetaphAdd(X, S);
                                        current += 1;
                                        break;
                                }

                                if(StringAt(current, 2, SH, ))
                                {
                                        //germanic
                                        if(StringAt((current + 1), 4, HEIM, HOEK, HOLM, HOLZ, ))
                                                MetaphAdd(S);
                                        else
                                                MetaphAdd(X);
                                        current += 2;
                                        break;
                                }

                                //italian & armenian
                                if(StringAt(current, 3, SIO, SIA, ) OR StringAt(current, 4, SIAN, ))
                                {
                                        if(!!SlavoGermanic())
                                                MetaphAdd(S, X);
                                        else
                                                MetaphAdd(S);
                                        current += 3;
                                        break;
                                }

                                //german & anglicisations, e.g. 'smith' match 'schmidt', 'snider' match 'schneider'
                                //also, -sz- in slavic language altho in hungarian it is pronounced 's'
                                if(((current == 0) 
                                                AND StringAt((current + 1), 1, M, N, L, W, ))
                                                        OR StringAt((current + 1), 1, Z, ))
                                {
                                        MetaphAdd(S, X);
                                        if(StringAt((current + 1), 1, Z, ))
                                                current += 2;
                                        else
                                                current += 1;
                                        break;
                                }

                                if(StringAt(current, 2, SC, ))
                                {
                                        //Schlesinger's rule
                                        if(GetAt(current + 2) == 'H')
                                                //dutch origin, e.g. 'school', 'schooner'
                                                if(StringAt((current + 3), 2, OO, ER, EN, UY, ED, EM, ))
                                                {
                                                        //'schermerhorn', 'schenker'
                                                        if(StringAt((current + 3), 2, ER, EN, ))
                                                        {
                                                                MetaphAdd(X, SK);
                                                        }else
                                                                MetaphAdd(SK);
                                                        current += 3;
                                                        break;
                                                }else{
                                                        if((current == 0) AND !!IsVowel(3) AND (GetAt(3) !!= 'W'))
                                                                MetaphAdd(X, S);
                                                        else
                                                                MetaphAdd(X);
                                                        current += 3;
                                                        break;
                                                }

                                        if(StringAt((current + 2), 1, I, E, Y, ))
                                        {
                                                MetaphAdd(S);
                                                current += 3;
                                                break;
                                        }
                                        //else
                                        MetaphAdd(SK);
                                        current += 3;
                                        break;
                                }

                                //french e.g. 'resnais', 'artois'
                                if((current == last) AND StringAt((current - 2), 2, AI, OI, ))
                                        MetaphAdd(, S);
                                else
                                        MetaphAdd(S);

                                if(StringAt((current + 1), 1, S, Z, ))
                                        current += 2;
                                else
                                        current += 1;
                                break;
"

        | nextChar char2 chars char |
        (#('ISL' 'YSL') includes: (self inputKey copyFrom: (currentIndex - 1 max: 1) to: (currentIndex + 1 min: self inputKey size))) 
        ifTrue: [
                ^self
        ].
        (currentIndex = 1 and: [(self inputKey copyFrom: 1 to: (5 min: self inputKey size)) = 'SUGAR'])
        ifTrue: [
                self addPrimaryTranslation: 'X';
                addSecondaryTranslation: 'S'.
                ^self.
        ].
        (self inputKey copyFrom: currentIndex to: ((currentIndex + 1) min: self inputKey size)) = 'SH'
        ifTrue: [
                (#('HEIM' 'HOEK' 'HOLM' 'HOLZ') includes: (self inputKey copyFrom: (currentIndex + 1 min: self inputKey size) to: ((currentIndex + 5) min: self inputKey size)))
                ifTrue: [
                        self addPrimaryTranslation: 'S';
                        addSecondaryTranslation: 'S'.
                ] ifFalse: [
                        self addPrimaryTranslation: 'X';
                        addSecondaryTranslation: 'X'.
                ].
                ^self incrementSkipCount: 1
        ].
        ((#('SIO' 'SIA') includes: (self inputKey copyFrom: currentIndex to: (currentIndex + 2 min: self inputKey size)))
                or: [(self inputKey copyFrom: currentIndex to: (currentIndex + 3 min: self inputKey size)) = 'SIAN'])
        ifTrue: [
                (self isSlavoGermanic: self inputKey) not
                ifTrue: [
                        self addPrimaryTranslation: 'S';
                        addSecondaryTranslation: 'X'.
                ] ifFalse: [
                        self addPrimaryTranslation: 'S';
                        addSecondaryTranslation: 'S'.
                ].
                ^self incrementSkipCount: 2
        ].
        ((currentIndex = 1 and: [#($M $N $L $W) includes: (self keyAt: currentIndex + 1)])
                or: [(nextChar := self keyAt: currentIndex + 1) = $Z])
        ifTrue: [
                self addPrimaryTranslation: 'S';
                addSecondaryTranslation: 'X'.
                nextChar == $Z
                ifTrue: [
                        ^self incrementSkipCount: 1.
                ].
                ^self.
        ].
        ((self inputKey copyFrom: currentIndex to: ((currentIndex + 1) min: self inputKey size)) = 'SC')
        ifTrue: [
                (char2 := self keyAt: currentIndex + 2) = $H
                ifTrue: [
                        (#('OO' 'ER' 'EN' 'UY' 'ED' 'EM') includes: (chars := self inputKey copyFrom: ((currentIndex + 3) min: self inputKey size) to: ((currentIndex + 4) min: self inputKey size)))
                        ifTrue: [
                                (#('ER' 'EN') includes: chars)
                                ifTrue: [
                                        self addPrimaryTranslation: 'X';
                                        addSecondaryTranslation: 'SK'.
                                ] ifFalse: [
                                        self addPrimaryTranslation: 'SK';
                                        addSecondaryTranslation: 'SK'.
                                ].
                                ^self incrementSkipCount: 2.
                        ] ifFalse: [
                                ((currentIndex = 1 and: [(char := self inputKey at: 4 ifAbsent: [$b]) isVowel not]) and: [char ~= $W])
                                ifTrue: [
                                        self addPrimaryTranslation: 'X';
                                        addSecondaryTranslation: 'S'.
                                ] ifFalse: [
                                        self addPrimaryTranslation: 'X';
                                        addSecondaryTranslation: 'X'.
                                ].
                                ^self incrementSkipCount: 2.
                        ].
                ] ifFalse: [
                        (#($I $E $Y) includes: char2)
                        ifTrue: [
                                self addPrimaryTranslation: 'S';
                                addSecondaryTranslation: 'S'.
                                ^self incrementSkipCount: 2.
                        ] ifFalse: [
                                self addPrimaryTranslation: 'SK';
                                addSecondaryTranslation: 'SK'.
                                ^self incrementSkipCount: 2.
                        ]
                ].
        ].
        (currentIndex = self inputKey size and: [(#('AI' 'OI') includes: (self inputKey copyFrom: ((currentIndex - 2) max: 1) to: ((currentIndex - 1) max: 1)))])
        ifTrue: [
                self addPrimaryTranslation: '';
                addSecondaryTranslation: 'S'.
        ] ifFalse: [
                self addPrimaryTranslation: 'S';
                addSecondaryTranslation: 'S'.
        ].
        (#($S $Z) includes: (self keyAt: currentIndex + 1))
        ifTrue: [
                ^self incrementSkipCount: 1.
        ].
!

processT
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'T':
                                if(StringAt(current, 4, TION, ))
                                {
                                        MetaphAdd(X);
                                        current += 3;
                                        break;
                                }

                                if(StringAt(current, 3, TIA, TCH, ))
                                {
                                        MetaphAdd(X);
                                        current += 3;
                                        break;
                                }

                                if(StringAt(current, 2, TH, ) 
                                        OR StringAt(current, 3, TTH, ))
                                {
                                        //special case 'thomas', 'thames' or germanic
                                        if(StringAt((current + 2), 2, OM, AM, ) 
                                                OR StringAt(0, 4, VAN , VON , ) 
                                                        OR StringAt(0, 3, SCH, ))
                                        {
                                                MetaphAdd(T);
                                        }else{
                                                MetaphAdd(0, T);
                                        }
                                        current += 2;
                                        break;
                                }

                                if(StringAt((current + 1), 1, T, D, ))
                                        current += 2;
                                else
                                        current += 1;
                                MetaphAdd(T);
                                break;
"
        ((self inputKey copyFrom: currentIndex to: ((currentIndex + 3) min: self inputKey size)) = 'TION')
        ifTrue: [
                self addPrimaryTranslation: 'X';
                addSecondaryTranslation: 'X'.   
                ^self incrementSkipCount: 2.
        ].
        (#('TIA' 'TCH') includes: (self inputKey copyFrom: currentIndex to: ((currentIndex + 2) min: self inputKey size)))
        ifTrue: [
                self addPrimaryTranslation: 'X';
                addSecondaryTranslation: 'X'.   
                ^self incrementSkipCount: 2.
        ].
        (((self inputKey copyFrom: currentIndex to: ((currentIndex + 1) min: self inputKey size)) = 'TH') or: [
                ((self inputKey copyFrom: currentIndex to: ((currentIndex + 2) min: self inputKey size)) = 'TTH')
        ])
        ifTrue: [
                ((#('OM' 'AM') includes: (self inputKey copyFrom: currentIndex + 2 to: ((currentIndex + 3) min: self inputKey size)))
                or: [(#('VAN ' 'VON ') includes: (self inputKey copyFrom: 1 to: (4 min: self inputKey size)))
                        or: [(self inputKey copyFrom: 1 to: (3 min: self inputKey size)) = 'SCH']
                        ])
                ifTrue: [
                        self addPrimaryTranslation: 'T';
                        addSecondaryTranslation: 'T'.   
                ] ifFalse: [
                        self addPrimaryTranslation: '0';
                        addSecondaryTranslation: 'T'.   
                ].
                ^self incrementSkipCount: 1.
        ].
        (#($T $D) includes: (self keyAt: currentIndex + 1))
        ifTrue: [
                self incrementSkipCount: 1.
        ].
        self addPrimaryTranslation: 'T';
        addSecondaryTranslation: 'T'.   
!

processV
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'V':
                                if(GetAt(current + 1) == 'V')
                                        current += 2;
                                else
                                        current += 1;
                                MetaphAdd(F);
                                break;


        "

        (self keyAt: currentIndex + 1) = $V
        ifTrue: [
                self incrementSkipCount: 1
        ].
        self addPrimaryTranslation: 'F';
        addSecondaryTranslation: 'F'.
!

processW
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'W':
                                //can also be in middle of word
                                if(StringAt(current, 2, WR, ))
                                {
                                        MetaphAdd(R);
                                        current += 2;
                                        break;
                                }

                                if((current == 0) 
                                        AND (IsVowel(current + 1) OR StringAt(current, 2, WH, )))
                                {
                                        //Wasserman should match Vasserman
                                        if(IsVowel(current + 1))
                                                MetaphAdd(A, F);
                                        else
                                                //need Uomo to match Womo
                                                MetaphAdd(A);
                                }

                                //Arnow should match Arnoff
                                if(((current == last) AND IsVowel(current - 1)) 
                                        OR StringAt((current - 1), 5, EWSKI, EWSKY, OWSKI, OWSKY, ) 
                                                        OR StringAt(0, 3, SCH, ))
                                  {
                                        MetaphAdd(, F);
                                        current +=1;
                                        break;
                                }

                                //polish e.g. 'filipowicz'
                                if(StringAt(current, 4, WICZ, WITZ, ))
                                {
                                        MetaphAdd(TS, FX);
                                        current +=4;
                                        break;
                                }

                                //else skip it
                                current +=1;
                                break;
"
        | word nextLetter |
        ((word := self inputKey copyFrom: currentIndex to: (currentIndex + 1 min: self inputKey size)) = 'WR')
        ifTrue: [
                self addPrimaryTranslation: 'R';
                addSecondaryTranslation: 'R'.
                ^self incrementSkipCount: 1
        ].
        ((currentIndex = 1 and: [(nextLetter := self keyAt: currentIndex + 1) isVowel]) or: [
                word = 'WH'
        ])
        ifTrue: [
                nextLetter isVowel
                ifTrue: [
                        self addPrimaryTranslation: 'A';
                        addSecondaryTranslation: 'F'.
                ] ifFalse: [
                        self addPrimaryTranslation: 'A';
                        addSecondaryTranslation: 'A'.
                ]
        ].
        ((((currentIndex = self inputKey size) and: [(self keyAt: currentIndex - 1) isVowel])
                or: [#('EWSKI' 'EWSKY' 'OWSKI' 'OWSKY') includes: (self inputKey copyFrom: ((currentIndex - 1) max: 1) to: (currentIndex + 3 min: self inputKey size))])
                        or: [self inputKey startsWith:'SCH'])
        ifTrue: [
                self addPrimaryTranslation: '';
                addSecondaryTranslation: 'F'.
                ^self.
        ].
        (#('WICZ' 'WITZ') includes: (self inputKey copyFrom: currentIndex to: (currentIndex + 4 min: self inputKey size)))
        ifTrue: [
                self addPrimaryTranslation: 'TS';
                addSecondaryTranslation: 'FX'.
                ^self incrementSkipCount: 3
        ].
!

processX
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'X':
                                //french e.g. breaux
                                if(!!((current == last) 
                                        AND (StringAt((current - 3), 3, IAU, EAU, ) 
                                                        OR StringAt((current - 2), 2, AU, OU, ))) )
                                        MetaphAdd(KS);

                                if(StringAt((current + 1), 1, C, X, ))
                                        current += 2;
                                else
                                        current += 1;
                                break;
"


        ((currentIndex = self inputKey size) 
        and: [(#('IAU' 'EAU') includes: (self inputKey copyFrom: ((currentIndex - 3) min: 1) to: currentIndex)) 
              or: [(#('AU' 'OU') includes: (self inputKey copyFrom: ((currentIndex - 2) min: 1) to: currentIndex))]]) 
        ifFalse: [
                self addPrimaryTranslation: 'KS';
                addSecondaryTranslation: 'KS'.
        ].
        (#($C $X) includes: (self keyAt: currentIndex + 1))
        ifTrue: [
                ^self incrementSkipCount: 1
        ]

    "Modified: / 24-07-2011 / 06:54:25 / cg"
!

processZ
        "http://aspell.sourceforge.net/metaphone/dmetaph.cpp
        case 'Z':
                                //chinese pinyin e.g. 'zhao'
                                if(GetAt(current + 1) == 'H')
                                {
                                        MetaphAdd(J);
                                        current += 2;
                                        break;
                                }else
                                        if(StringAt((current + 1), 2, ZO, ZI, ZA, ) 
                                                OR (SlavoGermanic() AND ((current > 0) AND GetAt(current - 1) !!= 'T')))
                                        {
                                                MetaphAdd(S, TS);
                                        }
                                        else
                                                MetaphAdd(S);

                                if(GetAt(current + 1) == 'Z')
                                        current += 2;
                                else
                                        current += 1;
                                break;
"

        (self keyAt: currentIndex + 1) = $H
        ifTrue: [
                self addPrimaryTranslation: 'J';
                addSecondaryTranslation: 'J'.
                ^self incrementSkipCount: 1
        ] ifFalse: [
                ((#('ZO' 'ZI' 'ZA') includes: (self inputKey copyFrom: ((currentIndex + 1) min: self inputKey size) to: ((currentIndex + 2) min: self inputKey size))) or: [
                        (self isSlavoGermanic: self inputKey) and: [(currentIndex > 1 and: [(self keyAt: currentIndex - 1) ~= 'T'])]
                ])
                ifTrue: [
                        self addPrimaryTranslation: 'S';
                        addSecondaryTranslation: 'TS'.
                ] ifFalse: [
                        self addPrimaryTranslation: 'S';
                        addSecondaryTranslation: 'S'.
                ].
                (self keyAt: currentIndex + 1) = $Z
                ifTrue: [
                        ^self incrementSkipCount: 1
                ].
        ]
! !

!PhoneticStringUtilities::MiracodeStringComparator class methodsFor:'documentation'!

documentation
"
    Miracode (also called American Soundex) is like Soundex with the addition that h and w are 
    discarded if they separate consonants.

    These variants may be specifically important because they were used in U.S. National Archives. 
    Most archive data were encoded with Miracode, but there are some entries encoded with 
    Simplified Soundex. 

    The HW-rule was documented as a standard in 1910, but actually data of 1880, 1900 and 1910 
    censuses were encoded with mixed methods.
"
! !

!PhoneticStringUtilities::MiracodeStringComparator methodsFor:'api'!

phoneticStringsFor:aString 
    |u p t prevCode|

    u := aString asUppercase.
    p := u first asString.
    prevCode := self translate:u first.
    u from:2 to:u size do:[:c | 
        t := self translate:c.
        (t notNil 
        and:[ t ~= '0' 
        and:[ t ~= prevCode ]]) ifTrue:[
            p := p , t.
            p size == 4 ifTrue:[^ Array with:p ].
        ].
        (c ~= $W and:[c ~= $H]) ifTrue:[
            prevCode := t.
        ].
    ].
    [ p size < 4 ] whileTrue:[
        p := p , '0'
    ].
    ^ Array with:(p copyFrom:1 to:4)
! !

!PhoneticStringUtilities class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

