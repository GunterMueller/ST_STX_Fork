"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
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

TestCase subclass:#StringTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!

!StringTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!StringTests class methodsFor:'queries'!

coveredClassNames
    "should be redefined to return a collection of classes which are tested by
     this suite/case. 
     If not redefined, coveredPackageNames should be.

     These classes can be instrumented for coverage analysis,
     before running the suite to provide coverage analysis/report"

    ^ #( String CharacterArray )

    "Created: / 06-07-2011 / 21:27:03 / cg"
! !

!StringTests methodsFor:'helpers'!

runAccessTestsOnInstancesOf:aStringClass
    |str s0 s1 s2 s3 s4 t|

    0 to:33 do:[:l |
        str := aStringClass new:l.
        str atAllPut:(Character space).
        self assert:( str isBlank ).

        1 to:l do:[:pos |
            str at:pos put:$a.
            self assert:( str isBlank not ).
            str at:pos put:(Character space).
        ].
    ].

    s0 := aStringClass new:0.
    self assert:s0 isEmpty.
    self assert:s0 isEmptyOrNil.
    self assert:s0 size == 0.

    s1 := (aStringClass new:5) replaceFrom:1 with:'hello'.
    s2 := (aStringClass new:6) replaceFrom:1 with:' world'.
    self assert:(s1 , s2) size == 11.
    self assert:(s1 , s2) class == aStringClass.
    self assert:(s1 = 'hello').
    self assert:(s2 = ' world').
    self assert:(s1 size == 5).
    self assert:(s2 size == 6).

    self assert:(s1 = 'hello').
    self assert:(s1 asSymbol == #'hello').
    self assert:(s1 copyFrom:1) = 'hello'.
    self assert:(s1 copyFrom:1) class == aStringClass.
    self assert:(s1 copyFrom:1 to:3) = 'hel'.
    self assert:(s1 copyFrom:1 to:3) class == aStringClass.
    self assert:(s1 copyWith:$X) = 'helloX'.
    self assert:(s1 copyWith:$X) class == aStringClass.
    self assert:(s1 endsWith:'llo').
    self assert:(s1 startsWith:'hel').

    self assert:(t := s1 identityIndexOf:$h) == 1 description:('identityIndex is %1 (should be 1)' bindWith:t).
    self assert:(t := s1 identityIndexOf:$l) == 3 description:('identityIndex is %1 (should be 3)' bindWith:t).
    self assert:(t := s1 identityIndexOf:$L) == 0 description:('identityIndex is %1 (should be 0)' bindWith:t).

    self assert:(s1 identityIndexOf:$h startingAt:1) == 1.
    self assert:(s1 identityIndexOf:$h startingAt:2) == 0.
    self assert:(s1 identityIndexOf:$e startingAt:1) == 2.
    self assert:(s1 identityIndexOf:$e startingAt:2) == 2.
    self assert:(s1 identityIndexOf:$l startingAt:1) == 3.
    self assert:(s1 identityIndexOf:$l startingAt:2) == 3.
    self assert:(s1 identityIndexOf:$l startingAt:3) == 3.
    self assert:(s1 identityIndexOf:$l startingAt:4) == 4.
    self assert:(s1 identityIndexOf:$l startingAt:5) == 0.
    self assert:(s1 identityIndexOf:$l startingAt:6) == 0.

    self assert:(s1 indexOf:$h) == 1.
    self assert:(s1 indexOf:$l) == 3.
    self assert:(s1 indexOf:$L) == 0.
    self assert:(s1 indexOf:$A) == 0.

    self assert:(s1 indexOf:$h startingAt:1) == 1.
    self assert:(s1 indexOf:$h startingAt:2) == 0.
    self assert:(s1 indexOf:$e startingAt:1) == 2.
    self assert:(s1 indexOf:$e startingAt:2) == 2.
    self assert:(s1 indexOf:$l startingAt:1) == 3.
    self assert:(s1 indexOf:$l startingAt:2) == 3.
    self assert:(s1 indexOf:$l startingAt:3) == 3.
    self assert:(s1 indexOf:$l startingAt:4) == 4.
    self assert:(s1 indexOf:$l startingAt:5) == 0.
    self assert:(s1 indexOf:$l startingAt:6) == 0.

    self assert:(s1 includes:$l).
    self assert:(s1 includes:$L) not.

    self assert:(s1 includesAny:'a') not.
    self assert:(s1 includesAny:'ab') not.
    self assert:(s1 includesAny:'abc') not.
    self assert:(s1 includesAny:'abcd') not.
    self assert:(s1 includesAny:'abcde').
    self assert:(s1 includesAny:'e').
    self assert:(s1 includesAny:'ae').
    self assert:(s1 includesAny:'ea').
    self assert:(s1 includesAny:'abe').
    self assert:(s1 includesAny:'eab').
    self assert:(s1 includesAny:'aeb').
    self assert:(s1 includesAny:'abce').
    self assert:(s1 includesAny:'eabc').
    self assert:(s1 includesAny:'aebc').
    self assert:(s1 includesAny:'abec').
    self assert:(s1 includesAny:'abcde').
                                                  " 12345678901234567890 "
    s3 := (aStringClass new:20) replaceFrom:1 with:'12 45,78;01.34-67+90'.
    t := s3 asCollectionOfSubstringsSeparatedBy:$,.
    self assert:(t size = 2).
    self assert:(t first = '12 45').
    self assert:(t second = '78;01.34-67+90').

    t := s3 asCollectionOfSubstringsSeparatedByAny:',;. '.
    self assert:(t size = 5).
    self assert:(t first = '12').
    self assert:(t second = '45').
    self assert:(t third = '78').
    self assert:(t fourth = '01').
    self assert:(t fifth = '34-67+90').

    s4 := (aStringClass new:10) replaceFrom:1 with:'123',Character tab,'567',Character cr,'90'.
    self assert:(s4 size = 10).
    self assert:(s4 indexOfSeparatorStartingAt:1) = 4.
    self assert:(s4 indexOfSeparatorStartingAt:3) = 4.
    self assert:(s4 indexOfSeparatorStartingAt:4) = 4.
    self assert:(s4 indexOfSeparatorStartingAt:5) = 8.
    self assert:(s4 indexOfControlCharacterStartingAt:1) = 4.
    self assert:(s4 indexOfNonSeparatorStartingAt:1) = 1.
    self assert:(s4 indexOfNonSeparatorStartingAt:3) = 3.
    self assert:(s4 indexOfNonSeparatorStartingAt:4) = 5.
    self assert:(s4 indexOfNonSeparatorStartingAt:5) = 5.
! !

!StringTests methodsFor:'tests'!

test01_access
    0 to:33 do:[:l |
        |str|

        str := String new:l.
        str atAllPut:(Character space).
        self assert:( str isBlank ).
        self assert:((str size == 0) or: [(str first) == Character space.]). 

        1 to:l do:[:pos |
            str at:pos put:$a.
            self assert:( str isBlank not ).
            self assert:((str at:pos) == $a). 
            str at:pos put:(Character space).
        ].
    ].
    self runAccessTestsOnInstancesOf:String

    "
     self new test01_access
    "
!

test02_subclassAccess
    |myStringClass s1|

    Class withoutUpdatingChangesDo:[
	myStringClass := String
			subclass:#'MyString'
			instanceVariableNames:'foo'
			classVariableNames:''
			poolDictionaries:nil.
	myStringClass compile:'foo ^foo'.
	myStringClass compile:'foo:arg foo := arg'.
    ].

    s1 := (myStringClass new:5) replaceFrom:1 with:'hello'.
    self assert:(s1 foo isNil).
    self assert:(s1 size == 5).
    s1 foo:16r11413344.         "/ ensure there is a $A inside (hex 41)
    self assert:(s1 foo == 16r11413344).
    self assert:(s1 = 'hello').
    self assert:(s1 deepCopy foo == 16r11413344).

    self assert:((s1 indexOf:$A) == 0).                 "/ should not find the A
    self assert:((s1 identityIndexOf:$A) == 0).         "/ should not find the A
    self assert:((s1 findFirst:[:ch | ch == $A]) == 0). "/ should not find the A

    self runAccessTestsOnInstancesOf:myStringClass.

    "
     self new test02_subclassAccess
    "
!

test10_Contains8BitCharacters
    0 to:65 do:[:l |
	|str|

	str := String new:l.
	str atAllPut:(Character value:16r7F).
	self assert:( str contains8BitCharacters not ).

	1 to:l do:[:pos |
	    str at:pos put:(Character value:16r80).
	    self assert:( str contains8BitCharacters ).
	    str at:pos put:(Character value:16r7F).
	].
    ].

    "
     self new test10_Contains8BitCharacters
    "
!

test11_IsEmpty
    |nul n|
    nul := 0 asCharacter.
    n := 1.
    self assert:('' isEmpty).
    self assert:(' ' isEmpty not).
    self assert:(nul asCharacter asString isEmpty not).
    self assert:(('' , nul) isEmpty not).
    self assert:((String new:0) isEmpty).
    self assert:((String new:17 withAll:nul) isEmpty not).

    [ 
        29 timesRepeat:[  
            |s|

            s := String new:(n + 17).
            self assert:(s isEmpty not).
            n := n * 2.
        ].
    ] on: AllocationFailure do:[:ex | 
        "/ This is to be expected, we're trying to allocate up to 512MB
        "/ which migh not be possible on 32bit system...
    ].
    self assert:((String new:17 withAll:nul) isEmpty not).
    self assert:((String new:0 withAll:nul) isEmpty).
    "
     self new test11_IsEmpty
    "

    "Modified (format): / 30-11-2016 / 13:49:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test12_Comparison
    0 to: 255 do: [ :i |
        |s t|  

        1 to: 9 do: [ :j |
            s := String new:j withAll:(i asCharacter).
            t := s copy.

            self assert:(s notNil).
            self assert:(s = s).
            self assert:(s ~= s) not.  
            self assert:(s < s) not.
            self assert:(s > s) not.
            self assert:(s = (s,s)) not.

            self assert:(t notNil).
            self assert:(s = t).
            self assert:(s ~= t) not.  
            self assert:(s < t) not.
            self assert:(s > t) not.

            self assert:((s = nil) == ((s ~= nil) not)).
            self assert:((s = '') == ((s ~= '') not)).
        ].

        s := i asCharacter asString.
        0 to: 255 do: [ :j |
            t := j asCharacter asString.
            self assert:(t notNil).

            self assert:((s = t) == ((s ~= t) not)).
        ]
    ].

    "
     self new test12_Comparison
    "
!

test15_CompareWithCollating
    | nul |

    nul := 0 asCharacter asString.
    self assert:('' compareWith:'' collating:true) == 0.
    self assert:('' compareWith:'' collating:false) == 0.
    self assert:(nul compareWith:(255 asCharacter asString) collating:false) == -1.      
    self assert:((255 asCharacter asString) compareWith:nul collating:false) == 1.
    "/ This will fail and is a WONTFIX
    "/ self assert:((('' compareWith:nul collating:false) == 0) == ('' = nul)).

    0 to: 255 do: [ :i |
        |s|

        s := i asCharacter asString.
        self assert:(s notNil).

        "/ This will fail and is a WONTFIX 
        "/ self assert:('' compareWith:s collating:false) ~= 0.
        self assert:('' compareWith:s collating:false) == ((s compareWith:'' collating:false) negated).

        0 to: 255 do: [ :j |
            | t |
            t := j asCharacter asString.
            self assert:(t notNil).

            self assert:(((s compareWith:t collating:false) == -1) == (s < t)).
            self assert:(((s compareWith:t collating:false) == 0) == (s = t)).
            self assert:(((s compareWith:t collating:false) == 1) == (s > t)).
            self assert:(((s compareWith:t collating:true) == -1) == (s < t)).
            self assert:(((s compareWith:t collating:true) == 0) == (s = t)).
            self assert:(((s compareWith:t collating:true) == 1) == (s > t)). 
        ]
    ].

    0 to: 9 do: [ :i |
        0 to: 255 do: [ :j |
            |s t|
            s := String new:i withAll:(j asCharacter).
            t := s copy.

            self assert: (s compareWith:s collating:false) == 0.
            self assert: (s compareWith:s collating:true) == 0.
            self assert: (s compareWith:t collating:false) == 0.
            self assert: (s compareWith:t collating:true) == 0    
        ]
    ].

    "
     self new test15_CompareWithCollating
    "
!

test20_literalsAreReadonly
    |myClass s1 l2 s2 parserFlags compiler|

    parserFlags := Compiler new parserFlags copy.
    parserFlags stringsAreImmutable:true.
    parserFlags arraysAreImmutable:true.

    Class withoutUpdatingChangesDo:[
	myClass := Object
			subclass:#'MyClass'
			instanceVariableNames:''
			classVariableNames:''
			poolDictionaries:nil.

	compiler := myClass compilerClass new.
	compiler parserFlags:parserFlags.
	compiler compile:'lit1 ^''hello''' forClass:myClass install:true.

	compiler := myClass compilerClass new.
	compiler parserFlags:parserFlags.
	compiler compile:'lit2 ^#(''foo'' ''bar'' ''baz'')' forClass:myClass install:true.
    ].

    s1 := myClass new perform:#lit1.
    self assert:(s1 isString).
    self assert:(s1 class == ImmutableString).
    self should:[ s1 at:1 put:$H ] raise:Error.

    l2 := myClass new perform:#lit2.
    self assert:(l2 isArray).
    self assert:(l2 class == ImmutableArray).
    self should:[ l2 at:1 put:$H ] raise:Error.
    s2 := l2 at:1.
    self assert:(s2 isString).
    self assert:(s2 class == ImmutableString).
    self should:[ s2 at:1 put:$H ] raise:Error.

    "
     self new test20_literalsAreReadonly
    "

    "Modified: / 02-08-2011 / 19:30:53 / cg"
!

test30_indexOfSubCollection
    |i|
      "/  12345678901
    i := 'hello world' indexOfSubCollection:'world' startingAt:1 ifAbsent:0 caseSensitive:true.
    self assert:(i == 7).
    i := 'hello wOrLd' indexOfSubCollection:'world' startingAt:1 ifAbsent:0 caseSensitive:true.
    self assert:(i == 0).
    i := 'hello wOrLd' indexOfSubCollection:'world' startingAt:1 ifAbsent:0 caseSensitive:false.
    self assert:(i == 7).
    i := 'hello wOrLd' indexOfSubCollection:'ll' startingAt:1 ifAbsent:0 caseSensitive:false.
    self assert:(i == 3).

    i := 'hello wOrLd yellow' indexOfSubCollection:'ll' startingAt:1 ifAbsent:0 caseSensitive:false.
    self assert:(i == 3).
    i := 'hello wOrLd yellow' indexOfSubCollection:'ll' startingAt:3 ifAbsent:0 caseSensitive:false.
    self assert:(i == 3).
    i := 'hello wOrLd yellow' indexOfSubCollection:'ll' startingAt:4 ifAbsent:0 caseSensitive:false.
    self assert:(i == 15).

    i := 'hello wOrLd yellow' indexOfSubCollection:'low' startingAt:1 ifAbsent:0 caseSensitive:false.
    self assert:(i == 16).
    i := 'hello wOrLd yellow' indexOfSubCollection:'low' startingAt:17 ifAbsent:0 caseSensitive:false.
    self assert:(i == 0).
    i := 'hello wOrLd yellow' indexOfSubCollection:'low' startingAt:18 ifAbsent:0 caseSensitive:false.
    self assert:(i == 0).

    "
     self new test30_indexOfSubCollection
    "
!

test40_indexOfAny
    |s i collection|

    s := 'Some Sample Generators (74035660-d1f6-11df-9ab3-00ff7b08316c)'.
    1 to:s size do:[:start |
        i := s indexOfAny:'-' startingAt:start.
        self assert:(i == 0 or:[ i >= start]).
        (i ~~ 0) ifTrue:[
            self assert:(s at:i) == $-
        ].    
    ].
    "/    123456789012 
    s := 'bla bla 1234'.
    1 to:s size do:[:start |
        i := s indexOfAny:'1234' startingAt:start.
        self assert:(i == 0 or:[ i >= start]).
        (i == 9) ifTrue:[ self assert:((s at:i) == $1) ].
        (i == 10) ifTrue:[ self assert:((s at:i) == $2) ].
        (i == 11) ifTrue:[ self assert:((s at:i) == $3) ].
        (i == 12) ifTrue:[ self assert:((s at:i) == $4) ].
    ].

    collection := #($o, $l, $o).
      "/  12345678901
    i := 'hello world' indexOfAny:collection startingAt:1.
    self assert:(i == 3).
    i := 'hello world' indexOfAny:collection startingAt:2.
    self assert:(i == 3).
    i := 'hello world' indexOfAny:collection startingAt:3.
    self assert:(i == 3).  
    i := 'hello world' indexOfAny:collection startingAt:4.
    self assert:(i == 4).  
    i := 'hello world' indexOfAny:collection startingAt:5.
    self assert:(i == 5).  
    i := 'hello world' indexOfAny:collection startingAt:6.
    self assert:(i == 8).  
    i := 'hello world' indexOfAny:collection startingAt:7.
    self assert:(i == 8).
    i := 'hello world' indexOfAny:collection startingAt:8.
    self assert:(i == 8).               
    i := 'hello world' indexOfAny:collection startingAt:9.
    self assert:(i == 10).  
    i := 'hello world' indexOfAny:collection startingAt:10.
    self assert:(i == 10).  
    i := 'hello world' indexOfAny:collection startingAt:11.
    self assert:(i == 0).
    i := 'hello world' indexOfAny:collection startingAt:12.
    self assert:(i == 0).
    i := 'hello world' indexOfAny:collection startingAt:10000.
    self assert:(i == 0).
    "
     self new test40_indexOfAny
    "

    "Created: / 29-10-2010 / 14:58:21 / cg"
!

test41_contains
    |s|

    s := 'abcdefg'.
    self assert:(s contains:[:ch | ch == $a]).
    self assert:(s contains:[:ch | ch == $A]) not.
    self assert:(s contains:[:ch | ch == $1]) not.
    self assert:(s contains:[:ch | ch == (0 asCharacter)]) not.
    "
     self new test41_contains
    "
!

test42_includesAny
    |s|

    1 to:20 do:[:na |
        s := (String new:na withAll:$a),'bla bla 1234'.
        self assert:( s includesAny:'12').
        self assert:( s includesAny:'21').
        self assert:( s includesAny:'15').
        self assert:( s includesAny:'51').
        self assert:( s includesAny:'45').
        self assert:( s includesAny:'54').
        self assert:( s includesAny:'56') not.
    ].
    
    "
     self new test42_includesAny
    "
!

test43_occurrencesOf
    |s|

    "/             12345678901
    self assert:( 'hello world' occurrencesOf:$0 ) == 0.
    self assert:( 'hello world' occurrencesOf:$l ) == 3.  
    self assert:( 'hello world' occurrencesOf:$d ) == 1.  

    "/ how about 0-bytes in between
    self assert:( #[0 0 1 0 0] asString occurrencesOf:(Character value:1) ) == 1.
    self assert:( #[0 0 1 0 0] asString occurrencesOf:(Character value:0) ) == 4.

    1 to:10 do:[:nA |
        1 to:10 do:[:nB |
            s := (String new:nA withAll:$a),(String new:nB withAll:$b).
            self assert:(s occurrencesOf:$a) == nA.
            self assert:(s occurrencesOf:$b) == nB.
        ]
    ].    

    s := String new:1024.
    s atAllPut:$a.
    s at:512 put:(Character space).
    self assert:(s occurrencesOf:(Character space)) == 1.
    self assert:(s occurrencesOf:$a) == 1023.

    s := String new:1024.
    s atAllPut:$a.
    1 to:1024 by:2 do:[:i | s at:i put:$b].
    self assert:(s occurrencesOf:$a) == 512.
    self assert:(s occurrencesOf:$b) == 512.

    "
     self new test43_occurrencesOf
    "
!

test50_indexOf
    |s i|

    s := 'Some Sample Generators (74035660-d1f6-11df-9ab3-00ff7b08316c)'.
    1 to:s size do:[:start |
        i := s indexOf:$- startingAt:start.
        self assert:(i == 0 or:[ i >= start]).
    ].
    "/             12345678901
    self assert:( 'hello world' indexOf:$0 startingAt:1 ) == 0.
    self assert:( 'hello world' indexOf:$l startingAt:1 ) == 3.  
    self assert:( 'hello world' indexOf:$l startingAt:5 ) == 10.  
    self assert:( 'hello world' indexOf:$d startingAt:5 ) == 11.  

    "/             12345678901
    self assert:(('hello world' indexOf:$o startingAt:1) == 5).
    self assert:(('hello world' indexOf:$o startingAt:2) == 5).
    self assert:(('hello world' indexOf:$o startingAt:3) == 5).
    self assert:(('hello world' indexOf:$o startingAt:4) == 5).
    self assert:(('hello world' indexOf:$o startingAt:5) == 5).
    self assert:(('hello world' indexOf:$o startingAt:6) == 8).
    self assert:(('hello world' indexOf:$o startingAt:7) == 8).
    self assert:(('hello world' indexOf:$o startingAt:8) == 8).
    self assert:(('hello world' indexOf:$o startingAt:9) == 0).
    self assert:(('hello world' indexOf:$o startingAt:10) == 0).
    self assert:(('hello world' indexOf:$o startingAt:11) == 0).
    self assert:(('hello world' indexOf:$o startingAt:12) == 0).
    self assert:(('hello world' indexOf:$o startingAt:10000) == 0).

    "/ how about 0-bytes in between
    self assert:( #[0 0 1 0 0] asString indexOf:(Character value:1) startingAt:1 ) == 3.
    self assert:( #[0 0 1 0 0] asString indexOf:(Character value:0) startingAt:3 ) == 4.
    self assert:( #[0 0 1 1 0] asString indexOf:(Character value:0) startingAt:3 ) == 5.
    self assert:( #[0 1 0 1 0] asString indexOf:(Character value:1) startingAt:3 ) == 4.

    s := '12345678901234b'.
    self assert:(s indexOf:$x) == 0.
    self assert:(s indexOf:$1) == 1.
    self assert:(s indexOf:$2) == 2.
    self assert:(s indexOf:$3) == 3.
    self assert:(s indexOf:$4) == 4.
    self assert:(s indexOf:$5) == 5.
    self assert:(s indexOf:$0) == 10.
    self assert:(s indexOf:$b) == 15.

    s := ''.
    self assert:(s indexOf:$1) == 0.
    s := '1'.
    self assert:(s indexOf:$1) == 1.
    self assert:(s indexOf:$2) == 0.
    s := '12'.
    self assert:(s indexOf:$1) == 1.
    self assert:(s indexOf:$2) == 2.
    self assert:(s indexOf:$3) == 0.
    s := '123'.
    self assert:(s indexOf:$1) == 1.
    self assert:(s indexOf:$2) == 2.
    self assert:(s indexOf:$3) == 3.
    self assert:(s indexOf:$4) == 0.
    s := '1234'.
    self assert:(s indexOf:$1) == 1.
    self assert:(s indexOf:$2) == 2.
    self assert:(s indexOf:$3) == 3.
    self assert:(s indexOf:$4) == 4.
    self assert:(s indexOf:$5) == 0.
    s := '12345'.
    self assert:(s indexOf:$1) == 1.
    self assert:(s indexOf:$2) == 2.
    self assert:(s indexOf:$3) == 3.
    self assert:(s indexOf:$4) == 4.
    self assert:(s indexOf:$5) == 5.
    self assert:(s indexOf:$6) == 0.
    s := '123456'.
    self assert:(s indexOf:$1) == 1.
    self assert:(s indexOf:$2) == 2.
    self assert:(s indexOf:$3) == 3.
    self assert:(s indexOf:$4) == 4.
    self assert:(s indexOf:$5) == 5.
    self assert:(s indexOf:$6) == 6.
    self assert:(s indexOf:$7) == 0.
    s := '1234567'.
    self assert:(s indexOf:$1) == 1.
    self assert:(s indexOf:$2) == 2.
    self assert:(s indexOf:$3) == 3.
    self assert:(s indexOf:$4) == 4.
    self assert:(s indexOf:$5) == 5.
    self assert:(s indexOf:$6) == 6.
    self assert:(s indexOf:$7) == 7.
    self assert:(s indexOf:$8) == 0.
    s := '12345678'.
    self assert:(s indexOf:$1) == 1.
    self assert:(s indexOf:$2) == 2.
    self assert:(s indexOf:$3) == 3.
    self assert:(s indexOf:$4) == 4.
    self assert:(s indexOf:$5) == 5.
    self assert:(s indexOf:$6) == 6.
    self assert:(s indexOf:$7) == 7.
    self assert:(s indexOf:$8) == 8.
    self assert:(s indexOf:$9) == 0.
    s := '123456789'.
    self assert:(s indexOf:$1) == 1.
    self assert:(s indexOf:$2) == 2.
    self assert:(s indexOf:$3) == 3.
    self assert:(s indexOf:$4) == 4.
    self assert:(s indexOf:$5) == 5.
    self assert:(s indexOf:$6) == 6.
    self assert:(s indexOf:$7) == 7.
    self assert:(s indexOf:$8) == 8.
    self assert:(s indexOf:$9) == 9.

    self assert:(s indexOf:$0) == 0.
    self assert:(s indexOf:$b) == 0.

    s := String new:1024.
    s atAllPut:$a.
    s at:512 put:(Character space).
    self assert:(s indexOf:(Character space)) == 512.
    self assert:(s indexOf:(Character space) startingAt:1) == 512.
    self assert:(s indexOf:(Character space) startingAt:2) == 512.
    self assert:(s indexOf:(Character space) startingAt:3) == 512.
    self assert:(s indexOf:(Character space) startingAt:4) == 512.
    self assert:(s indexOf:(Character space) startingAt:5) == 512.
    self assert:(s indexOf:(Character space) startingAt:6) == 512.
    self assert:(s indexOf:(Character space) startingAt:7) == 512.
    self assert:(s indexOf:(Character space) startingAt:8) == 512.
    self assert:(s indexOf:(Character space) startingAt:9) == 512.
    self assert:(s indexOf:(Character space) startingAt:511) == 512.
    self assert:(s indexOf:(Character space) startingAt:512) == 512.
    self assert:(s indexOf:(Character space) startingAt:513) == 0.

    "
     self new test50_indexOf
    "

    "Created: / 29-10-2010 / 14:58:21 / cg"
!

test51_indexOf
    "
    Tests for bug #68: String>>indexOf:startingAt: broken under Windows/ MINGW64
    https://swing.fit.cvut.cz/projects/stx-jv/ticket/68
    "
    self assert: ('1234(xxxx' indexOf: $( startingAt: 1) == 5.

    "Created: / 23-11-2015 / 21:39:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test51_substrings
    self assert:('aaa/bbb/ccc' subStrings:'/') asArray = #('aaa' 'bbb' 'ccc').
    self assert:(('aaa/bbb/ccc' subStrings:'/') asStringWith:'/') = 'aaa/bbb/ccc'.

"/    self assert:('/aaa/bbb/ccc' subStrings:'/') asArray = #('' 'aaa' 'bbb' 'ccc').
"/    self assert:(('/aaa/bbb/ccc' subStrings:'/') asStringWith:'/') = '/aaa/bbb/ccc'.
"/
"/    self assert:('aaa/bbb/ccc/' subStrings:'/') asArray = #('aaa' 'bbb' 'ccc' '' ).
"/    self assert:(('aaa/bbb/ccc/' subStrings:'/') asStringWith:'/') = '/aaa/bbb/ccc/'.
"/
"/    self assert:('/aaa/bbb/ccc/' subStrings:'/') asArray = #('' 'aaa' 'bbb' 'ccc' '').
"/    self assert:(('/aaa/bbb/ccc/' subStrings:'/') asStringWith:'/') = '/aaa/bbb/ccc'' '.
"/
"/    self assert:('//aaa/bbb/ccc' subStrings:'/') asArray = #('' '' 'aaa' 'bbb' 'ccc').
"/    self assert:(('//aaa/bbb/ccc' subStrings:'/') asStringWith:'/') = '//aaa/bbb/ccc'.

    "
     self new test51_substrings
    "
!

test52_indexOfSeparator
    |j s|

    self assert:('' indexOfSeparator) == 0.
    1 to:20 do:[:n |
        s := (String new:n withAll:$a).
        1 to:20 do:[:start |
            self assert:(s indexOfSeparatorStartingAt:start) == 0.
        ].    
    ].    
    1 to:20 do:[:n |
        s := (String new:n withAll:$a),' '.
        1 to:n do:[:start |
            self assert:(s indexOfSeparatorStartingAt:start) == (n+1).
        ].    
    ].    
    
    { 
        Character space .
        Character tab .
        Character return .
        Character lf .
    } do:[:sep |
        1 to:20 do:[:na |
            1 to:20 do:[:nb |
                s := (String new:na withAll:$a),sep,(String new:na withAll:$a).
                1 to:na do:[:start |
                    self assert:(s indexOfSeparatorStartingAt:start) == (na+1).
                ]
            ]
        ].    
    ].
    
    { 
        Character esc .
        Character null .
        $a .
    } do:[:nonSep |
        1 to:20 do:[:na |
            1 to:20 do:[:nb |
                s := (String new:na withAll:$a),nonSep,(String new:na withAll:$a).
                1 to:20 do:[:start |
                    self assert:(s indexOfSeparatorStartingAt:start) == 0.
                ]
            ]
        ].    
    ].

    s := String new:1000 withAll:$a.
    self assert:(s indexOfSeparatorStartingAt:1) == 0.
    400 to: 417 do:[:i |
        s := String new:1000 withAll:$a.
        s at:i put:(Character space).
        self assert:(s indexOfSeparatorStartingAt:1) == i.

        s := String new:1000 withAll:$a.
        s at:i put:(Character return).
        self assert:(s indexOfSeparatorStartingAt:1) == i.
    ]. 

      "/  12345678901
    j := 'hello world' indexOfSeparatorStartingAt:1.
    self assert:(j == 6).
    j := 'hello world ' indexOfSeparatorStartingAt:2.
    self assert:(j == 6).
    j := 'hello world ' indexOfSeparatorStartingAt:3.
    self assert:(j == 6).  
    j := 'hello world ' indexOfSeparatorStartingAt:4.
    self assert:(j == 6).  
    j := 'hello world ' indexOfSeparatorStartingAt:5.
    self assert:(j == 6).
    j := 'hello world ' indexOfSeparatorStartingAt:6.
    self assert:(j == 6).
    j := 'hello world ' indexOfSeparatorStartingAt:7.
    self assert:(j == 12).
    j := 'hello world ' indexOfSeparatorStartingAt:8.
    self assert:(j == 12).
    j := 'hello world ' indexOfSeparatorStartingAt:9.
    self assert:(j == 12).  
    j := 'hello world ' indexOfSeparatorStartingAt:10.
    self assert:(j == 12).  
    j := 'hello world ' indexOfSeparatorStartingAt:11.
    self assert:(j == 12).
    j := 'hello world ' indexOfSeparatorStartingAt:12.
    self assert:(j == 12).
    j := 'hello world' indexOfSeparatorStartingAt:12.
    self assert:(j == 0).  
    j := 'hello world ' indexOfSeparatorStartingAt:13.
    self assert:(j == 0).
    j := 'hello world ' indexOfSeparatorStartingAt:10000.
    self assert:(j == 0).  
     
    "
     self new test52_indexOfSeparator
    "
!

test54_occurrencesOf
    |s|

    self assert:('' occurrencesOf:$a) == 0.
    1 to:20 do:[:n |
        s := (String new:n withAll:$a).
        self assert:(s occurrencesOf:$a) == n.
    ].    
    1 to:20 do:[:na |
        1 to:20 do:[:nb |
            s := (String new:na withAll:$a),(String new:nb withAll:$b).
            self assert:(s occurrencesOf:$a) == na.
        ].    
    ].    
    1 to:40 do:[:n |
        s := String new:n withAll:$a.
        1 to:n by:2 do:[:n |
            s at:n put:$b.
        ].    
        self assert:(s occurrencesOf:$a) == (n // 2).
    ].    
    
    s := String new:1000 withAll:$a.
    self assert:(s occurrencesOf:$a) == 1000.
    1 to:1000 do:[:i |
        s at:i put:$b.
        self assert:(s occurrencesOf:$a) == (1000-i).
        self assert:(s occurrencesOf:$b) == i.
    ].
    
    "
     self new test54_occurrencesOf
    "
!

test60_hash
    "
    As of 2013-01-09 for strings of size 7 String & Unicode16String hash
    returned different values. This test checks this
    "

    | tester |

    tester := [:s|
        |sHash u16Hash u32Hash|

        sHash := s hash.
        u16Hash := s asUnicode16String hash.
        u32Hash := s asUnicode32String hash.

        self assert: sHash == u16Hash
             description: ('String and Unicode16String hashes differ on "%1" (%2)'
                                bindWith:s with:s class name).
        self assert: sHash == u32Hash
             description: ('String and Unicode32String hashes differ on "%1" (%2)'
                                bindWith:s with:s class name)
    ].

    tester value:'a'.
    tester value:'12345678901234'.
    tester value:'1234567890123'.
    tester value:'123456789012'.
    tester value:'12345678901'.
    tester value:'1234567890'.
    tester value:'123456789'.
    tester value:'12345678'.
    tester value:'1234567'.
    tester value:'123456'.
    tester value:'12345'.
    tester value:'1234'.
    tester value:'123'.
    tester value:'12'.
    tester value:'boolean'.

    "/ strings with 0-elements
    tester value:('' copyWith:Character null).
    tester value:('1' copyWith:Character null).
    tester value:('12' copyWith:Character null).
    tester value:('123' copyWith:Character null).
    tester value:('1234' copyWith:Character null).
    tester value:('12345' copyWith:Character null).
    tester value:('123456' copyWith:Character null).
    tester value:('1234567' copyWith:Character null).
    tester value:('12345678' copyWith:Character null).
    tester value:('123456789' copyWith:Character null).

    tester value:('' copyWith:Character null),'123'.
    tester value:('1' copyWith:Character null),'123'.
    tester value:('12' copyWith:Character null),'123'.
    tester value:('123' copyWith:Character null),'123'.
    tester value:('1234' copyWith:Character null),'123'.
    tester value:('12345' copyWith:Character null),'123'.
    tester value:('123456' copyWith:Character null),'123'.
    tester value:('1234567' copyWith:Character null),'123'.
    tester value:('12345678' copyWith:Character null),'123'.
    tester value:('123456789' copyWith:Character null),'123'.
    
    "/ String allInstancesDo:[:each| tester value:each].
    Symbol allInstancesDo:[:each| tester value:each].

    "Created: / 09-01-2013 / 10:58:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test65_concatenation
    |strA strB|

    0 to:32 do:[:szA | 
        0 to:32 do:[:szB | 
            |szAB|

            strA := String new:szA withAll:$a.
            strB := String new:szB withAll:$b.
            szAB := szA + szB.
            self assert:(szA = strA size).
            self assert:(szB = strB size).
            10000 timesRepeat:[
                |strAB|

                strAB := strA , strB.

                self assert:(szAB == strAB size).
            ]
        ]
    ].

    strA := strB := ''.
    self assert: ((strA , strB) = '').
    self assert: ((strA , strA) = '').
    strA := 'a'.
    self assert: ((strA , strA) = 'aa').  
    self assert: ((strA , strB) = 'a').
    strA := ''.
    strB := 'b'.
    self assert: ((strA , strB) = 'b').    
    strA := 'b'.
    strB := 'a'.
    self assert: ((strB , strA) = 'ab'). 
    "
     self new test65_concatenation
    "
!

test66_replace
    |strA|

    1 to:64 do:[:szA |
        strA := String new:szA withAll:$a.
            1 to:szA do:[:idx |
                strA at:idx put:$*.

                strA replaceAll:$* with:$#.

                self assert:(strA at:idx) = $#.
                self assert:(strA occurrencesOf:$#) = idx.
                self assert:(strA count:[:ch | ch = $#]) = idx.
                self assert:(strA occurrencesOf:$*) = 0.
                self assert:(strA count:[:ch | ch = $*]) = 0.
                self assert:(strA includes:$#).
                self assert:(strA includes:$*) not.
        ]
    ]

    "
     self new test66_replace
    "
!

test67_concatenationAnd
    |strA strB strC|

    0 to:32 do:[:szA | 
        0 to:32 do:[:szB | 
            0 to:32 do:[:szC | 
                |szABC|
                strA := String new:szA withAll:$a.
                strB := String new:szB withAll:$b.
                strC := String new:szC withAll:$c.

                szABC := szA + szB + szC.
                self assert:(szA = strA size).
                self assert:(szB = strB size).
                self assert:(szC = strC size).

                300 timesRepeat:[
                    |strABC|

                    strABC := strA concatenate:strB and:strC.

                    self assert:(szABC == strABC size).
                ]
            ]
        ]
    ].
    strA := strB := strC := ''.
    self assert: ((strA concatenate:strB and:strC) = '').
    strA := 'a'.
    self assert: ((strA concatenate:strB and:strC) = 'a').
    strA := ''.
    strB := 'b'.
    self assert: ((strA concatenate:strB and:strC) = 'b').    
    strB := ''.
    strC := 'c'.
    self assert: ((strA concatenate:strB and:strC) = 'c').    
    strA := 'c'.
    strB := 'b'.
    strC := 'a'.
    self assert: ((strC concatenate:strB and:strA) = 'abc').         
    "
     self new test67_concatenationAnd
    "
!

test68_concatenationAndAnd
    |strA strB strC strD|

    0 to:32 do:[:szA | 
        strA := String new:szA withAll:$a.
        self assert:(szA = strA size).
        0 to:32 do:[:szB | 
            strB := String new:szB withAll:$b.
            self assert:(szB = strB size).
            0 to:32 do:[:szC | 
                strC := String new:szC withAll:$c.
                self assert:(szC = strC size).
                0 to:32 do:[:szD | 
                    |szABCD|
                    strD := String new:szD withAll:$d.

                    szABCD := szA + szB + szC + szD.

                    self assert:(szD = strD size).

                    5 timesRepeat:[
                        |strABCD|

                        strABCD := strA concatenate:strB and:strC and:strD.

                        self assert:(szABCD == strABCD size).
                    ]      
                ]
            ]
        ]
    ].

    strA := strB := strC := strD := ''.
    self assert: ((strA concatenate:strB and:strC and:strD) = '').
    strA := 'a'.
    self assert: ((strA concatenate:strB and:strC and:strD) = 'a').
    strA := ''.
    strB := 'b'.
    self assert: ((strA concatenate:strB and:strC and:strD) = 'b').    
    strB := ''.
    strC := 'c'.
    self assert: ((strA concatenate:strB and:strC and:strD) = 'c').    
    strC := ''.
    strD := 'd'.
    self assert: ((strA concatenate:strB and:strC and:strD) = 'd').    
    strA := 'd'.
    strB := 'c'.
    strC := 'b'.
    strD := 'a'.   
    self assert: ((strD concatenate:strC and:strB and:strA) = 'abcd'). 
    "
     self new test68_concatenationAndAnd
    "
!

test70_storeString

    self assert: 'AAA' storeString = '''AAA'''.
    self assert: 'A''A''A' storeString = '''A''''A''''A'''.

    self assert: 'AAA' asImmutableString storeString = '''AAA'''.
    self assert: 'A''A''A' asImmutableString storeString = '''A''''A''''A'''.

    "Created: / 14-07-2013 / 19:17:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test80_copyReplaceAll

    | orig copy |

    orig := 'AAA' copy. "/ In case literals are immutable...
    self assert: orig = 'AAA'.

    copy := orig copyReplaceAll: $A with: $X.
    self assert: copy = 'XXX'.
    self assert: orig = 'AAA'.

    orig := 'AAA' asImmutableString.
    self assert: orig = 'AAA'.

    copy := orig copyReplaceAll: $A with: $X.
    self assert: copy = 'XXX'.
    self assert: orig = 'AAA'.

    "Created: / 06-03-2014 / 15:10:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test81_filling

    | str |

    str := 'AAA' copy. "/ In case literals are immutable...

    str atAllPut:$B.
    self assert: str = 'BBB'.

    str from:1 to:0 put:$C.
    self assert: str = 'BBB'.

    str from:1 to:1 put:$D.
    self assert: str = 'DBB'.

    str from:1 to:2 put:$E.
    self assert: str = 'EEB'.

    str from:1 to:3 put:$F.
    self assert: str = 'FFF'.

    str from:1 to:0 put:$G.
    self assert: str = 'FFF'.

    str from:-1 to:-2 put:$G.
    self assert: str = 'FFF'.

    self should:[
	str from:-1 to:-1 put:$x
    ] raise:SubscriptOutOfBoundsError.
    self assert: str = 'FFF'.

    self should:[
	str from:-1 to:1 put:$x
    ] raise:SubscriptOutOfBoundsError.
    self assert: str = 'FFF'.
!

test90_hash
    | string8 string16 string32 |

    string8 := 'sun/nio/cs/UTF_8.class'.
    string16 := string8 asUnicode16String.
    string32 := string8 asUnicode16String.

    self assert: string8 hash == string16 hash.
    self assert: string8 hash == string32 hash.

    "Created: / 09-10-2014 / 12:41:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

