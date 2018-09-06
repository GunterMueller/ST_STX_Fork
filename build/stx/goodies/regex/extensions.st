"{ Package: 'stx:goodies/regex' }"!

!CharacterArray methodsFor:'matching - regex'!

allRegexMatches: rxString
    "return a collection of substrings in the receiver, 
     which match the regular expression in rxString.
     Refer to `documentation' protocol of RxParser class for details."

    ^ rxString asRegex matchesIn: self

    "
     '1234 abcd 3456 defg' allRegexMatches:'[0-9]+'

     '[0-9]+' asRegex matchesIn:'1234 abcd 3456 defg'
    "
! !

!CharacterArray methodsFor:'matching - regex'!

asRegex
    "Compile the receiver as a regex matcher.
     May raise RxParser>>syntaxErrorSignal or RxParser>>compilationErrorSignal.
     This is a part of the Regular Expression Matcher package,
        (c) 1996, 1999 Vassili Bykov.
     Refer to `documentation' protocol of Regex::RxParser class for details."

    ^ Regex::RxParser preferredMatcherClass
        for: (Regex::RxParser new parse: self)

    "Modified (comment): / 18-07-2011 / 15:15:01 / cg"
! !

!CharacterArray methodsFor:'matching - regex'!

asRegexIgnoringCase
    "Compile the receiver as a regex matcher.
     May raise RxParser>>syntaxErrorSignal or RxParser>>compilationErrorSignal.
     This is a part of the Regular Expression Matcher package,
	(c) 1996, 1999 Vassili Bykov.
     Refer to `documentation' protocol of RxParser class for details."

    ^ Regex::RxParser preferredMatcherClass
	    for: (Regex::RxParser new parse: self)
	    ignoreCase: true
! !

!CharacterArray methodsFor:'matching - regex'!

copyWithRegex: rxString matchesReplacedWith: aString
    "return a new string where all matches are replaced by aString.
     Refer to `documentation' protocol of RxParser class for details."

    ^ rxString asRegex copy: self replacingMatchesWith: aString
    "
     'abcabc123abc' copyWithRegex:'ab.' matchesReplacedWith:'*'
     'abcabc123abc' copyWithRegex:'ab.' matchesReplacedWith:''
     'abc [4] cde [9]' copyWithRegex:'\[[0-9]+\]' matchesReplacedWith:'[x]'
    "

    "Modified (comment): / 02-08-2018 / 12:57:30 / Claus Gittinger"
! !

!CharacterArray methodsFor:'matching - regex'!

copyWithRegex: rxString matchesTranslatedUsing: aBlock
    "return a new string where all matches are replaced by the output from aBlock.
     Refer to `documentation' protocol of RxParser class for details."

    ^ rxString asRegex copy: self translatingMatchesUsing: aBlock

    "
     'abcabc123abc' copyWithRegex:'ab.' matchesTranslatedUsing:[:m | '(',m,')'] 
    "
! !

!CharacterArray methodsFor:'matching - regex'!

hasAnyRegexMatches: rxString
    "return true, if any substrings in the receiver, matches the regular expression in rxString.
     Refer to `documentation' protocol of RxParser class for details."

    rxString asRegex matchesIn:self do:[:m | ^ true].
    ^ false

    "
     '1234 abcd 3456 defg' hasAnyRegexMatches:'[0-9]+'   
     'abcd 3456 defg' hasAnyRegexMatches:'[0-9]+'        
     'abcd xxax defg' hasAnyRegexMatches:'[0-9]+'        
    "

    "Created: / 13-08-2010 / 17:09:05 / sr"
! !

!CharacterArray methodsFor:'matching - regex'!

hasAnyRegexMatches: rxString ignoringCase:aBoolean
    "return true, if any substrings in the receiver, matches the regular expression in rxString.
     Refer to `documentation' protocol of RxParser class for details."

    aBoolean ifTrue:[
        ^ self hasAnyRegexMatchesIgnoringCase: rxString
    ] ifFalse:[
        ^ self hasAnyRegexMatches: rxString
    ].

    "
     '1234 abcd 3456 defg' hasAnyRegexMatches:'[0-9]+'   
     'abcd 3456 defg' hasAnyRegexMatches:'[0-9]+'        
     'abcd xxax defg' hasAnyRegexMatches:'[0-9]+'        
     'arith [arc]' hasAnyRegexMatches:'(ab)+'        
     'arith [arc]' hasAnyRegexMatches:'(ab)*'        
    "

    "Created: / 13-12-2010 / 11:03:05 / cg"
! !

!CharacterArray methodsFor:'matching - regex'!

hasAnyRegexMatchesIgnoringCase: rxString
    "return true, if any substrings in the receiver, matches the regular expression in rxString.
     Refer to `documentation' protocol of RxParser class for details."

    rxString asRegexIgnoringCase matchesIn:self do:[:m | ^ true].
    ^ false

    "
     'ABCD XYZ DEFG' hasAnyRegexMatchesIgnoringCase:'[a-z]+'        
     'ABCD XYZ DEFG' hasAnyRegexMatches:'[a-z]+'        

     '1234 abcd 3456 defg' hasAnyRegexMatchesIgnoringCase:'[a-z]+'   
     'abcd 3456 defg' hasAnyRegexMatchesIgnoringCase:'[a-z]+'        
    "

    "Created: / 13-08-2010 / 17:11:11 / sr"
! !

!CharacterArray methodsFor:'matching - regex'!

matchesRegex: regexString
    "Test if the receiver matches a regex.
     May raise RxParser>>regexErrorSignal or child signals.
     This is a part of the Regular Expression Matcher package,
        (c) 1996, 1999 Vassili Bykov.
     Refer to `documentation' protocol of Regex::RxParser class for details."

    ^regexString asRegex matches: self

    "
     'hello world' matchesRegex:'h.*d'.
    "

    "Modified (comment): / 18-07-2011 / 15:15:05 / cg"
! !

!CharacterArray methodsFor:'matching - regex'!

matchesRegex:regexString caseSensitive:aBoolean
    "Test if the receiver matches a regex.
     May raise RxParser>>regexErrorSignal or child signals.
     This is a part of the Regular Expression Matcher package,
        (c) 1996, 1999 Vassili Bykov.
     Refer to `documentation' protocol of RxParser class for details."

    aBoolean ifFalse:[
        ^ self matchesRegexIgnoringCase:regexString
    ] ifTrue:[
        ^ self matchesRegex:regexString
    ].

    "
     'hello world' matchesRegex:'h.*d'.
    "

    "Created: / 13-12-2010 / 11:01:49 / cg"
! !

!CharacterArray methodsFor:'matching - regex'!

matchesRegex:regexString ignoringCase:aBoolean
    "Test if the receiver matches a regex.
     May raise RxParser>>regexErrorSignal or child signals.
     This is a part of the Regular Expression Matcher package,
        (c) 1996, 1999 Vassili Bykov.
     Refer to `documentation' protocol of RxParser class for details."

    aBoolean ifTrue:[
        ^ self matchesRegexIgnoringCase:regexString
    ] ifFalse:[
        ^ self matchesRegex:regexString
    ].

    "
     'hello world' matchesRegex:'h.*d'.
    "

    "Created: / 13-12-2010 / 11:01:49 / cg"
! !

!CharacterArray methodsFor:'matching - regex'!

matchesRegexIgnoringCase: regexString
    "Test if the receiver matches a regex.
     May raise RxParser>>regexErrorSignal or child signals.
     This is a part of the Regular Expression Matcher package,
	(c) 1996, 1999 Vassili Bykov.
     Refer to `documentation' protocol of RxParser class for details."

    ^regexString asRegexIgnoringCase matches: self

    "
     'hElLo wOrld' matchesRegexIgnoringCase:'h.*d'.
    "
! !

!CharacterArray methodsFor:'matching - regex'!

prefixMatchesRegex: regexString
    "Test if the receiver's prefix matches a regex.
     May raise RxParser class>>regexErrorSignal or child signals.
     This is a part of the Regular Expression Matcher package,
        (c) 1996, 1999 Vassili Bykov.
     Refer to `documentation' protocol of RxParser class for details."

    ^regexString asRegex matchesPrefix: self

    "
     'hello world' prefixMatchesRegex:'h.*o'.
    "
! !

!CharacterArray methodsFor:'matching - regex'!

prefixMatchesRegexIgnoringCase: regexString
    "Test if the receiver's prefix matches a regex.
     May raise RxParser class>>regexErrorSignal or child signals.
     This is a part of the Regular Expression Matcher package,
	(c) 1996, 1999 Vassili Bykov.
     Refer to `documentation' protocol of RxParser class for details."

    ^regexString asRegexIgnoringCase matchesPrefix: self
! !

!CharacterArray methodsFor:'matching - regex'!

regex: rxString matchesCollect: aBlock
    "for all substrings in the receiver which match the regular expression in rxString, evaluate aBlock,
     and collect the returned values.
     Refer to `documentation' protocol of RxParser class for details."

    ^ rxString asRegex matchesIn: self collect: aBlock

    "
     'hello world' regex:'\w+' matchesCollect:[:each | each asUppercase ].
     '1234 hello 456 world' regex:'\d+' matchesCollect:[:each | Number readFrom:each ].
    "
! !

!CharacterArray methodsFor:'matching - regex'!

regex:rxString matchesDo: aBlock
    "for all substrings in the receiver which match the regular expression in rxString, evaluate aBlock.
     Refer to `documentation' protocol of RxParser class for details."

    ^ rxString asRegex matchesIn: self do: aBlock

    "
     'hello world' regex:'\w+' matchesDo:[:each | Transcript showCR:each ].
    "
! !

!stx_goodies_regex class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/extensions.st,v 1.11 2018-08-02 10:57:59 cg Exp $'
! !

