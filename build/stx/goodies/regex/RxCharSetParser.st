"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

Object subclass:#RxCharSetParser
	instanceVariableNames:'source lookahead elements'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxCharSetParser comment:'-- Regular Expression Matcher v 1.1 (C) 1996, 1999 Vassili Bykov
-- See `documentation'' protocol of RxParser class for user''s guide.
--
I am a parser created to parse the insides of a character set ([...]) construct. I create and answer a collection of "elements", each being an instance of one of: RxsCharacter, RxsRange, or RxsPredicate.

Instance Variables:

	source	<Stream>	open on whatever is inside the square brackets we have to parse.
	lookahead	<Character>	The current lookahead character
	elements	<Collection of: <RxsCharacter|RxsRange|RxsPredicate>> Parsing result'
!

!RxCharSetParser class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
! !

!RxCharSetParser class methodsFor:'instance creation'!

on: aStream

	^self new initialize: aStream
! !

!RxCharSetParser methodsFor:'accessing'!

parse

        lookahead == $- ifTrue:
                [self addChar: $-.
                self match: $-].
        [lookahead isNil] whileFalse: [self parseStep].
        ^elements
! !

!RxCharSetParser methodsFor:'initialize-release'!

initialize: aStream

	source := aStream.
	lookahead := aStream next.
	elements := OrderedCollection new
! !

!RxCharSetParser methodsFor:'parsing'!

addChar: aChar

	elements add: (RxsCharacter with: aChar)
!

addRangeFrom: firstChar to: lastChar

	firstChar asInteger > lastChar asInteger ifTrue:
		[RxParser signalSyntaxException: ' bad character range'].
	elements add: (RxsRange from: firstChar to: lastChar)
!

match: aCharacter

        aCharacter = lookahead
                ifFalse: [RxParser signalSyntaxException: 'unexpected character: ', (lookahead asString)].
        ^source atEnd
                ifTrue: [lookahead := nil]
                ifFalse: [lookahead := source next]
!

parseCharOrRange

        | firstChar |
        firstChar := lookahead.
        self match: firstChar.
        lookahead == $- ifTrue:
                [self match: $-.
                lookahead isNil
                        ifTrue: [^self addChar: firstChar; addChar: $-]
                        ifFalse: 
                                [self addRangeFrom: firstChar to: lookahead.
                                ^self match: lookahead]].
        self addChar: firstChar
!

parseEscapeChar

        self match: $\.
        $- = lookahead
                ifTrue: [elements add: (RxsCharacter with: $-)]
                ifFalse: [
                        "cg: original code did not handle \n, \t etc. in [..] character sets:
                        elements add: (RxsPredicate forEscapedLetter: lookahead)].
                        "
                        (RxParser backslashConstants includesKey:lookahead) 
                            ifTrue: [
                                elements add: (RxsCharacter with: (RxParser backslashConstants at: lookahead))]
                            ifFalse: [
                                elements add: (RxsPredicate forEscapedLetter: lookahead)]].
        self match: lookahead
!

parseNamedSet
        | name |
        self match: $[; match: $:.
        name := lookahead asString, (source upTo: $:).
        lookahead := source next.
        self match: $].
        elements add: (RxsPredicate forNamedClass: name)
!

parseStep

        lookahead == $[ ifTrue:
                [source peek = $:
                        ifTrue: [^self parseNamedSet]
                        ifFalse: [^self parseCharOrRange]].
        lookahead == $\ ifTrue:
                [^self parseEscapeChar].
        lookahead == $- ifTrue:
                [RxParser signalSyntaxException: 'invalid range'].
        self parseCharOrRange
! !

!RxCharSetParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxCharSetParser.st,v 1.7 2015-02-13 22:46:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxCharSetParser.st,v 1.7 2015-02-13 22:46:11 cg Exp $'
! !

