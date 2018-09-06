"{ Encoding: utf8 }"

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

Object subclass:#StringUtilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Support'
!

!StringUtilities class methodsFor:'documentation'!

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
    some less often used algorithms have been moved to here to
    make libbasic more compact.
"
! !

!StringUtilities class methodsFor:'edit distance'!

editDistanceFrom:s1 to:s2 s:substWeight k:kbdTypoWeight c:caseWeight e:exchangeWeight i:insrtWeight
    "another, simpler editing distance between two strings. 
     See also: levenshtein"

    |editedS2 min d|

    s2 size > s1 size ifTrue:[
        ^ self editDistanceFrom:s2 to:s1 s:substWeight k:kbdTypoWeight c:caseWeight e:exchangeWeight i:insrtWeight
    ].
    s1 size > s2 size ifTrue:[
        0 to:s2 size do:[:pos |
            editedS2 := s2 copyWith:$# insertedAfterIndex:pos.
            
            d := self editDistanceFrom:s1 to:editedS2 s:substWeight k:kbdTypoWeight c:caseWeight e:exchangeWeight i:insrtWeight.
            min := (min ? d) min:d.
        ].
        ^ min + insrtWeight
    ].

    ^ (1 to:s1 size) sum:
        [:i | 
            ((s2 at:i) == $# or:[ (s1 at:i)=(s2 at:i)]) 
                ifTrue:[0] 
                ifFalse:[substWeight]
        ] 

    "
     'comptuer' levenshteinTo:'computer'      
     self editDistanceFrom:'comptuer' to:'computer' s:4 k:2 c:1 e:nil i:2        

     'computr' levenshteinTo:'computer'                                    
     self editDistanceFrom:'computr' to:'computer' s:4 k:2 c:1 e:nil i:2        
    "

    "Modified (format): / 09-08-2012 / 05:41:59 / cg"
!

isKey:k1 nextTo:k2
    "return true, if k1 and k2 are adjacent keys on the keyboard.
     This is used to specially priorize plausible typing errors of adjacent keys."

    ^ self isKey:k1 nextTo:k2 onKeyboard:(self keyboardLayout)

    "
     self isKey:$a nextTo:$a   
     self isKey:$a nextTo:$s   
     self isKey:$a nextTo:$q   
     self isKey:$a nextTo:$w    
     self isKey:$a nextTo:$y    
     self isKey:$a nextTo:$z    
     self isKey:$a nextTo:$x    
    "
!

isKey:k1 nextTo:k2 onKeyboard:keys
    "return true, if k1 and k2 are adjacent keys on the keyboard defined by keys"

    |row1 row2 col1 col2|

    row1 := keys findFirst:[:eachRow | col1 := eachRow indexOf:k1. col1 ~~ 0].
    row1 == 0 ifTrue:[^ false].
    row2 := keys findFirst:[:eachRow | col2 := eachRow indexOf:k2. col2 ~~ 0].
    row2 == 0 ifTrue:[^ false].

    ^ (row1-row2) abs <= 1 and:[(col1-col2) abs <= 1]

    "
     self isKey:$a nextTo:$q onKeyboard:(StringUtilities keyboardLayoutForLanguage:#de)
     self isKey:$a nextTo:$x onKeyboard:(StringUtilities keyboardLayoutForLanguage:#de)
    "
!

keyboardLayout
    "the keyboard layout (used with algorithms to find possible typing errors,
     for example: edit distance in levenshtein)"

    ^ self keyboardLayoutForLanguage:(UserPreferences current language)

    "
     self keyboardLayout
    "
!

keyboardLayoutForLanguage:lang
    "the keyboard layout (used with algorithms to find possible typing errors,
     for example: edit distance in levenshtein).
     CAVEAT: hard coded us- and german keyboards here - should go into resource file."

    "/ danish
    lang == #da ifTrue:[
        ^ #( 
               '1234567890-'
               '*qwertyuiopå'
               '**asdfghjklæø'
               '***zxcvbnm' ).
    ].
    lang == #no ifTrue:[
        ^ #( 
               '1234567890-'
               '*qwertyuiopå'
               '**asdfghjkløæ'
               '***zxcvbnm' ).
    ].

    (lang == #de or:[lang == #pl or:[lang == #cz]]) ifTrue:[
        ^ #( 
               '1234567890-'
               '*qwertzuiop'
               '**asdfghjkl:'
               '***yxcvbnm' ).
    ].
    lang == #hu ifTrue:[
        ^ #( 
               '1234567890-'                         
               '*qwertyuiopõú'
               '**asdfghjkléáũ'
               '**ízxcvbnm' ).
    ].

    lang == #pt ifTrue:[
        ^ #( 
               '1234567890-'
               '*qwertyuiop'
               '**asdfghjklç'
               '***zxcvbnm' ).
    ].
    lang == #es ifTrue:[
        ^ #( 
               '1234567890-'
               '*qwertyuiop'
               '**asdfghjklñ'
               '***zxcvbnm' ).
    ].
    (lang == #sv or:[lang == #fi]) ifTrue:[
        ^ #( 
               '1234567890-'
               '*qwertyuiopå'
               '**asdfghjklöä'
               '***zxcvbnm' ).
    ].
    lang == #fr ifTrue:[
        ^ #( 
               '1234567890'
               '*azertyuiop'
               '**qsdfghjklm'
               '***wxcvbn,' ).
    ].

    "/ fallback: english, dutch, italian
    ^ #( 
           '1234567890-'
           '*qwertyuiop'
           '**asdfghjkl:'
           '***zxcvbnm' ).

    "
     self keyboardLayoutForLanguage:#de 
    "

    "Modified (comment): / 09-08-2012 / 05:39:19 / cg"
!

levenshteinDistanceFrom:string1 to:string2 s:substWeight k:kbdTypoWeight c:caseWeight e:exchangeWeight i:insrtWeight d:deleteWeight
    "parametrized levenshtein.
     return the levenshtein distance of two strings;
     this value corrensponds to the number of replacements that have to be
     made to get string2 from string1. The smaller the returned number,
     tbe more similar are the two strings.

     The arguments are the costs for
        s:substitution,
        k:keyboard type (substitution),   if nil, s is used
        c:case-change,                    if nil, s is used
        i:insertion
        d:deletion
        e:exchange                        if nil, s*2 is used
     of a character.
     See IEEE transactions on Computers 1976 Pg 172 ff."

    |d  "delta matrix"
     len1 "{ Class: SmallInteger }"
     len2 "{ Class: SmallInteger }"
     dim  "{ Class: SmallInteger }"
     prevRow row col
     dimPlus1 "{ Class: SmallInteger }"
     min pp c1 c2|

    len1 := string1 size.
    len2 := string2 size.

    "create the help-matrix"

    dim := len1 max:len2.
    dimPlus1 := dim + 1.

    d := Array new:dimPlus1.
    1 to:dimPlus1 do:[:i |
        d at:i put:(Array new:dimPlus1)
    ].

    "init help-matrix"

    (d at:1) at:1 put:0.
    row := d at:1.
    1 to:dim do:[:j |
        row at:(j + 1) put:( (row at:j) + insrtWeight )
    ].

    1 to:dim do:[:i |
        (d at:(i + 1)) at:1 put:(  ((d at:i) at:1) + deleteWeight )
    ].

    1 to:len1 do:[:i |
        c1 := string1 at:i.
        1 to:len2 do:[:j |
            c2 := string2 at:j.
            (c1 == c2) ifTrue:[
                pp := 0
            ] ifFalse:[
                (c1 asLowercase == c2 asLowercase) ifTrue:[
                    pp := caseWeight
                ] ifFalse:[
                    pp := substWeight.
                    substWeight ~~ kbdTypoWeight ifTrue:[
                        (self isKey:c1 asLowercase nextTo:c2 asLowercase) ifTrue:[
                            pp := kbdTypoWeight ? substWeight.
                        ].
                    ].
                    "/ assmuing (;-) that an exchange is very common when typing...
                    exchangeWeight notNil ifTrue:[
                        (i < len1 and:[j < len2]) ifTrue:[
                            ((string1 at:i) = (string2 at:(j+1))
                            and:[ (string1 at:i+1) = (string2 at:j) ]) ifTrue:[
                                pp := exchangeWeight.
                            ].
                        ].
                        (i > 1 and:[j > 1]) ifTrue:[
                            ((string1 at:i) = (string2 at:(j-1))
                            and:[ (string1 at:i-1) = (string2 at:j) ]) ifTrue:[
                                pp := exchangeWeight.
                            ].
                        ].
                    ].
                ]
            ].

            prevRow := d at:i.
            row := d at:(i + 1).
            col := j + 1.
            min := (prevRow at:j) + pp.
            min := min min:( (row at:j) + insrtWeight).
            min := min min:( (prevRow at:col) + deleteWeight).

            row at:col put: min
        ]
    ].

    ^ (d at:(len1 + 1)) at:(len2 + 1)

    "
     'comptuer' levenshteinTo:'computer'       

     self levenshteinDistanceFrom:'comptuer' to:'computer' 
            s:4 k:2 c:1 e:nil i:2 d:6    
    "

    "Modified (comment): / 09-08-2012 / 05:40:08 / cg"
! !

!StringUtilities class methodsFor:'queries'!

isUtilityClass
    ^ self == StringUtilities
! !

!StringUtilities class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

