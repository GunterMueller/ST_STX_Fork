"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Scanner
	instanceVariableNames:'typeArray actionArray source lineNr token tokenType tokenPosition
		tokenValue tokenName tokenLineNr tokenLastEndPosition hereChar
		peekChar peekChar2 requestor exitBlock errorFlag ignoreErrors
		ignoreWarnings saveComments currentComments collectedSource
		scanColonAsKeyword outStream outCol inArrayLiteral lastDirective
		parserFlags didWarnAboutSTXSpecialComment
		didWarnAboutUnderscoreInIdentifier didWarnAboutOldStyleAssignment
		didWarnAboutDollarInIdentifier didWarnAboutPeriodInSymbol
		unicodeActions'
	classVariableNames:'DefaultTypeArray DefaultActionArray EmptySourceNotificationSignal
		DefaultUnicodeActions'
	poolDictionaries:''
	category:'System-Compiler'
!

Scanner class instanceVariableNames:'TypeArray ActionArray UnicodeActions'

"
 No other class instance variables are inherited by this class.
"
!

Object subclass:#Comment
	instanceVariableNames:'commentType commentString startPosition endPosition'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Scanner
!

Object subclass:#Directive
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Scanner
!

Scanner::Directive subclass:#ClassDirective
	instanceVariableNames:'className'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Scanner::Directive
!

Scanner::Directive::ClassDirective subclass:#ClassHintDirective
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Scanner::Directive
!

!Scanner class methodsFor:'documentation'!

bugs
"
   array constant containing keywords as in:
	#(
		foo:bar:
		fee:baz:
	 )

   is scanned as 4-element array containing ( #foo: #bar: #fee: #baz: )
   this MUST be fixed.

   workaround:
	#(
		#'foo:bar:'
		#'fee:baz:'
	 )

"
!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Scanner reads from a stream and returns individual smalltalk tokens
    Its main method is #nextToken, which reads and returns the next token
    Possibly placing additional information (such as tokenValue) into
    instance variables as a side effect.

    TODO:
	some testers noticed that ST-80's scanner methods are called
	xLetter, xDigit etc. For code using these (internals), the nextNumber,
	nextIdentifier etc. methods should be renamed.
	(to me, these seem to be internal private methods;
	 their public use is not a good idea ..)

	Scanner is typically subclassed for parsing and #nextToken
	invoked via #self-sends.
	This should be changed and scanner ought to be an instance variable
	of Parser - this allows more flexible use of the scanner/parser
	framework (i.e. changing the scanner without affecting the parser).

    Extensions:
	this scanner allows for 3-character binary selectors.
	also, # is a valid selector. (however, ## is currently scanned as a symbol literal).

    [author:]
	Claus Gittinger

    [see also:]
	Parser
"
! !

!Scanner class methodsFor:'initialization'!

binarySelectorCharacters
    "return a collection of characters which are allowed in binary selectors"

    ^ Method binarySelectorCharacters.
!

extendedBinarySelectorCharacters
    "return a collection of characters which are optionally allowed in binary selectors"

    "/ ^ '±×·÷«»'.
    ^ String
	with:(Character value:16rB1)  "/ plus-minus
	with:(Character value:16rD7)  "/ times
	with:(Character value:16rB7)  "/ centered dot
	with:(Character value:16rF7)  "/ divide
	with:(Character value:16rAB)  "/ <<
	with:(Character value:16rBB). "/ >>

    "Modified (comment): / 17-11-2016 / 09:22:42 / cg"
!

setupActions
    "initialize the scanner's actionTables - these are used to dispatch
     into scanner methods as characters are read.
     Compatibility note: in previous versions, these tables used to be kept
     in classVariables, which made reuse hard as subclasses had no easy way of
     defining their own tables. These are now class instance variables."

    |block actionArray typeArray unicodeActions unicodeTypes|

    actionArray := Array new:256.
    typeArray := Array new:256.
    unicodeActions := Dictionary new.
    unicodeTypes := Dictionary new.

    "/ TODO: later versions should be configurable w.r.t separators.
    "/ #(9 10 12 13 26 32) do: [:i | TypeArray at:(i+1) put: #separator].
    block := [:s :char | s nextNumber].
    actionArray from:($0 codePoint) to:($9 codePoint) put:block.

    block := [:s :char | s nextSpecial].
    self binarySelectorCharacters do:[:binop |
	|codePoint|
	codePoint := binop codePoint.
	codePoint <= typeArray size ifTrue:[
	    typeArray at:codePoint put:#special.
	    actionArray at:codePoint put:block
	] ifFalse:[
	    unicodeTypes at:codePoint put:#extendedSpecial.
	    unicodeActions at:codePoint put:block
	].
    ].

    block := [:s :char | s nextExtendedSpecial:char].
    self extendedBinarySelectorCharacters do:[:binop |
	|codePoint|
	codePoint := binop codePoint.
	codePoint <= typeArray size ifTrue:[
	    typeArray at:codePoint put:#extendedSpecial.
	    actionArray at:codePoint put:block
	] ifFalse:[
	    unicodeTypes at:codePoint put:#extendedSpecial.
	    unicodeActions at:codePoint put:block
	].
    ].

    "/ that one is a special case (both binarySelector AND syntax).
    typeArray at:($| codePoint) put:nil.

    block := [:s :char | s nextToken:char].
    ';.^|()[]{}' do:[:ch |
	actionArray at:(ch codePoint) put:block
    ].

    block := [:s :char | s nextIdentifier].
    actionArray from:($a codePoint) to:($z codePoint) put:block.
    actionArray from:($A codePoint) to:($Z codePoint) put:block.

    "kludge: action is characterToken, but type is special"
    typeArray at:($| codePoint) put:#special.

    "kludge: action is nextColonOrAssign, but type is special"
    typeArray at:($: codePoint) put:#special.

    actionArray at:($' codePoint) put:[:s :char | s nextString:char].
    actionArray at:($$ codePoint) put:[:s :char | s nextCharacter].
    actionArray at:($# codePoint) put:[:s :char | s nextHash].
    actionArray at:($!! codePoint) put:[:s :char | s nextExcla].
    actionArray at:($% codePoint) put:[:s :char | s nextPrimitive].
    actionArray at:($: codePoint) put:[:s :char | s nextColonOrAssign].
    actionArray at:($_ codePoint) put:[:s :char | s nextUnderline].

    unicodeActions at:2190 "<- left arrow" put:[:s :char | s nextAssignmentArrow].

    ActionArray := DefaultActionArray := actionArray.
    TypeArray := DefaultTypeArray := typeArray.
    UnicodeActions := DefaultUnicodeActions := unicodeActions.

    "
     Scanner setupActions
     Scanner withAllSubclassesDo:[:cls | cls setupActions ]
    "

    "Modified: / 02-07-2017 / 01:11:27 / cg"
! !

!Scanner class methodsFor:'instance creation'!

for:aStringOrStream
    "create & return a new scanner reading from aStringOrStream"

    ^ self basicNew initializeFor:aStringOrStream

    "Modified: 23.5.1997 / 12:08:42 / cg"
!

new
    "create & return a new scanner"

    ^ self basicNew initialize.

    "Modified: / 23.5.1997 / 12:08:42 / cg"
    "Created: / 26.5.1999 / 12:02:16 / stefan"
! !

!Scanner class methodsFor:'Signal constants'!

doNotShowCompilerWarningAgainActionQuery
    ^ DoNotShowCompilerWarningAgainActionQuery
!

emptySourceNotificationSignal
    ^ EmptySourceNotificationSignal

    "Created: / 16.5.1998 / 15:55:14 / cg"
! !

!Scanner class methodsFor:'accessing'!

actionArray
    ActionArray isNil ifTrue:[
	self setupActions
    ].
    ^ ActionArray ? DefaultActionArray
!

flushActionArray
    ActionArray := DefaultActionArray := nil.
    TypeArray := DefaultTypeArray := nil.

    "
     Scanner flushActionArray
     Parser flushActionArray
     ByteCodeCompiler flushActionArray
     Explainer flushActionArray
    "
!

typeArray
    TypeArray isNil ifTrue:[
	self setupActions
    ].
    ^ TypeArray ? DefaultTypeArray
!

unicodeActions
    UnicodeActions isNil ifTrue:[
	self setupActions
    ].
    ^ UnicodeActions ? DefaultUnicodeActions

    "Created: / 25-03-2011 / 13:57:34 / cg"
! !

!Scanner class methodsFor:'class initialization'!

initialize
    "initialize the classes defaults. Typically, these are changed
     later in the 'private.rc' file."

    EmptySourceNotificationSignal isNil ifTrue:[
	EmptySourceNotificationSignal := QuerySignal new mayProceed:true.
	EmptySourceNotificationSignal notifierString:'empty source given to evaluate'.
	EmptySourceNotificationSignal nameClass:self message:#emptySourceNotificationSignal.
    ].

    "
     self initialize
    "

    "Modified: / 16.5.1998 / 15:55:41 / cg"
! !

!Scanner class methodsFor:'defaults'!

allowDollarInIdentifier
    "return true, if $-characters are allowed in identifiers.
     Notice, that dollars are NEVER allowed as the first character in an identifier."

    ^ ParserFlags allowDollarInIdentifier

    "Created: 7.9.1997 / 01:32:18 / cg"
    "Modified: 7.9.1997 / 01:39:44 / cg"
!

allowDollarInIdentifier:aBoolean
    "this allows turning on/off $-characters in identifiers.
     Notice, that dollars are NEVER allowed as the first character in an identifier.
     If turned off (the default), dollars are not allowed in identifiers,
     but instead are scanned as character-constant prefix.
     If turned on, dollars are in identifiers are allowed, while extra
     dollars are still scanned as constant character prefix.
     If you have to fileIn old VW-Vsn2.x classes, turn this off
     before filing them in; i.e.:
	Compiler allowDollarInIdentifiers:false"

    ParserFlags allowDollarInIdentifier:aBoolean.

    "Created: 7.9.1997 / 01:34:49 / cg"
    "Modified: 7.9.1997 / 01:39:30 / cg"
!

allowDolphinExtensions
    "return true, if ##(..) computed literal Arrays are allowed"

    ^ ParserFlags allowDolphinExtensions
!

allowDolphinExtensions:aBoolean
    "this allows turning on/off support for computed literal Arrays ##(..) as in dolphin.
     If you want to fileIn Dolphin classes, enable this with:
	Compiler allowDolphinComputedArrays:true"

    ParserFlags allowDolphinExtensions:aBoolean.

    "
     self allowDolphinExtensions:true
     self allowDolphinExtensions:false
    "
!

allowLiteralNameSpaceSymbols
    "return true, if literal nameSpace symbols are allowed (#foo::bar) are allowed"

    ^ ParserFlags allowLiteralNameSpaceSymbols
!

allowOldStyleAssignment
    "return true, if underscore-assignment (pre ST-80v4 syntax) are to be allowed"

    ^ ParserFlags allowOldStyleAssignment
!

allowOldStyleAssignment:aBoolean
    "this allows turning on/off recognition of underscore-assignment (pre ST-80v4 syntax).
     You must turn this off, if code with variables named '_' is to be filedIn"

    ParserFlags allowOldStyleAssignment:aBoolean
!

allowQualifiedNames
    "return true, if #{..} qualified names are allowed"

    ^ ParserFlags allowQualifiedNames
!

allowQualifiedNames:aBoolean
    "this allows turning on/off support for qualifiedNames #{ .., } as in vw3.
     If you want to fileIn vw3 or later classes, enable this with:
	Compiler allowQualifiedNames:true
     Notice, that qualified names are not really supported semantically
     (they are parsed, but treated like regular globals)
    "

    ParserFlags allowQualifiedNames:aBoolean.

    "
     self allowQualifiedNames:true
     self allowQualifiedNames:false
    "
!

allowSqueakExtensions
    "return true, if support for squeak extensions
	computed arrays { .., }
	c/java style arguments in message sends rec foo(arg1, ... argN)
     is enabled."

    ^ ParserFlags allowSqueakExtensions
!

allowSqueakExtensions:aBoolean
    "this allows turning on/off support for squeak extensions:
	computed arrays { .., }
	c/java style arguments in message sends rec foo(arg1, ... argN)

     If you want to fileIn Squeak classes, enable this with:
	Compiler allowSqueakComputedArrays:true"

    ParserFlags allowSqueakExtensions:aBoolean.

    "
     self allowSqueakExtensions:true
     self allowSqueakExtensions:false
    "
!

allowUnderscoreInIdentifier
    "return true, if underscores are allowed in identifiers"

    ^ ParserFlags allowUnderscoreInIdentifier
!

allowUnderscoreInIdentifier:aBoolean
    "this allows turning on/off underscores in identifiers.
     If turned off (the default), underscores are not allowed in identifiers,
     but instead scanned as assignment character (old ST/80 syntax).
     If turned on, underscores are in identifiers are allowed, while extra
     underscores are still scanned as assignment.
     If you have to fileIn old VW-Vsn2.x classes,
     turn them off with:
	Compiler allowUnderscoreInIdentifiers:false"

    ParserFlags allowUnderscoreInIdentifier:aBoolean.

    "Modified: 7.9.1997 / 01:35:19 / cg"
!

maxBinarySelectorSize
    ^ Method maxBinarySelectorSize
!

warnCommonMistakes
    "return true, if common beginners mistakes are to be warned about"

    ^ ParserFlags warnCommonMistakes
!

warnCommonMistakes:aBoolean
    "this allows turning on/off warnings about common beginners mistakes.
     Those are not really errors in the strict sense, but often lead to
     run time errors later.
     Examples are: expr or:expr2, where expr2 is not a block.
     If you get bored by those warnings, turn them off by adding
     a line as:
	Compiler warnCommonMistakes:false
     in your 'private.rc' file"

    ParserFlags warnCommonMistakes:aBoolean
!

warnDollarInIdentifier
    "return true, if $-characters in identifiers are to be warned about"

    ^ ParserFlags warnDollarInIdentifier

    "Created: 7.9.1997 / 01:36:17 / cg"
!

warnDollarInIdentifier:aBoolean
    "this allows turning on/off warnings about $-characters in identifiers.
     You may find those warnings useful, to make certain that your code
     is portable to other smalltalk versions, which do not allow this
     (i.e. VW releases 2.x and maybe others).
     Notice, that dollars are NEVER allowed as the first character in an identifier.
     If you get bored by those warnings, turn them off by adding
     a line as:
	Compiler warnDollarInIdentifier:false
     in your 'private.rc' file"

    ParserFlags warnDollarInIdentifier:aBoolean

    "Created: 7.9.1997 / 01:37:42 / cg"
    "Modified: 7.9.1997 / 01:40:02 / cg"
!

warnOldStyleAssignment
    "return true, if underscore-assignment (pre ST-80v4 syntax) are to be warned about"

    ^ ParserFlags warnOldStyleAssignment
!

warnOldStyleAssignment:aBoolean
    "this allows turning on/off warnings about underscore-assignment (pre ST-80v4 syntax).
     If you get bored by those warnings, turn them off by adding
     a line as:
	Compiler warnOldStyleAssignment:false
     in your 'private.rc' file"

    ParserFlags warnOldStyleAssignment:aBoolean
!

warnPossibleIncompatibilities
    "return true, if possible incompatibilities (with other ST systems)
     are to be warned about"

    ^ ParserFlags warnPossibleIncompatibilities

    "Modified: 23.5.1997 / 12:02:02 / cg"
!

warnPossibleIncompatibilities:aBoolean
    "this turns warnings about possible incompatibilities (with other ST systems)
     on or off.
     If you get bored by those warnings, turn them off by adding
     a line as:
	Compiler warnPossibleIncompatibilities:false
     in your 'private.rc' file."

    ParserFlags warnPossibleIncompatibilities:aBoolean

    "Created: 23.5.1997 / 12:02:45 / cg"
!

warnSTXSpecials
    "return true, if ST/X specials are to be warned about"

    ^ ParserFlags warnSTXSpecials
!

warnSTXSpecials:aBoolean
    "this allows turning on/off warnings about stx specials.
     If you get bored by those warnings, turn them off by adding
     a line as:
	Compiler warnSTXSpecials:false
     in your 'private.rc' file"

    ParserFlags warnSTXSpecials:aBoolean
!

warnUnderscoreInIdentifier
    "return true, if underscores in identifiers are to be warned about"

    ^ ParserFlags warnUnderscoreInIdentifier
!

warnUnderscoreInIdentifier:aBoolean
    "this allows turning on/off warnings about underscores in identifiers.
     You may find those warnings useful, to make certain that your code
     is portable to other smalltalk versions, which do not allow this
     (i.e. VW releases 2.x).
     If you get bored by those warnings, turn them off by adding
     a line as:
	Compiler warnUnderscoreInIdentifier:false
     in your 'private.rc' file"

    ParserFlags warnUnderscoreInIdentifier:aBoolean

    "Modified: 7.9.1997 / 01:37:13 / cg"
!

warnings
    "return true, if any warnings are to be shown"

    ^ ParserFlags warnings
!

warnings:aBoolean
    "this allows turning on/off all warnings; the default is on.
     You can turn off warnings in your 'private.rc' file with
	 Compiler warnings:false
    "

    ParserFlags warnings:aBoolean

    "Modified: 23.5.1997 / 12:03:05 / cg"
! !

!Scanner class methodsFor:'utility scanning'!

scanNumberFrom:aStream
    "utility - helper for Number>>readSmalltalkSyntaxFrom:"

    ^ self basicNew scanNumberFrom:aStream

    "
     |s|

     s := '12345abcd' readStream.
     Transcript showCR:(self scanNumberFrom:s).
     Transcript showCR:(s upToEnd).
    "
    "
     |s|

     s := '16rffffxabcd' readStream.
     Transcript showCR:(self scanNumberFrom:s).
     Transcript showCR:(s upToEnd).
    "
    "
     |s|

     s := '1.2345abcd' readStream.
     Transcript showCR:(self scanNumberFrom:s).
     Transcript showCR:(s upToEnd).
    "
    "
     |s|

     s := '1.abcd' readStream.
     Transcript showCR:(self scanNumberFrom:s).
     Transcript showCR:(s upToEnd).
    "

    "Modified: / 18.6.1998 / 23:10:39 / cg"
! !

!Scanner methodsFor:'Compatibility-ST80'!

endOfLastToken
    "return the position of the token which was just read.
     This method was required by some PD program.
     It is not maintained and may be removed without notice."

    ^ source position + 1

    "Modified: 23.5.1997 / 12:14:27 / cg"
!

scan:aStringOrStream
    "initialize the scanner: set the source-stream and
     preread the first token"

    self initializeFor:aStringOrStream.
    self nextToken

    "Created: / 30.10.1997 / 16:59:39 / cg"
!

scanDoing:aBlock
    "scan, evaluating aBlock for every scanned token."

    |t|

    [(t := self nextToken) ~~ #EOF] whileTrue:[
	aBlock value:t.
    ].
!

scanToken
    "read the next token from my input stream"

    ^ self nextToken

    "Created: / 30.10.1997 / 17:00:16 / cg"
!

scanTokens:aStringOrStream
    "return a collection of symbolic tokens from the passed input,
     similar to what would be read when reading '#( <string> )'"

    |tokens readArray|

    self initializeFor:aStringOrStream.

    readArray :=
        [
            |elements|

            elements := OrderedCollection new.
            [ (token ~~ $) ) and:[ token notNil ] ] whileTrue:[
                token == $( ifTrue:[
                    self nextToken.
                    elements add:(readArray value)
                ] ifFalse:[
                    elements add:token.
                ].
                self nextToken.
            ].
            elements asArray
        ].

    tokens := OrderedCollection new.
    self nextToken.

    [token notNil] whileTrue:[
	token == $( ifTrue:[
	    self nextToken.
	    tokens add:(readArray value)
	] ifFalse:[
	    tokens add:token
	].
	self nextToken
    ].
    ^ tokens

    "
     Scanner new scanTokens:'name ident #sym ''string'' 8r12'

     Scanner new scanTokens:'translate (200px 100px)'

     Scanner new
	scanTokens:'Boolean subclass:#True
				instanceVariableNames:''''
				classVariableNames:''''
				poolDictionaries:''''
				category:''Kernel-Objects''
	'
    "

    "Modified: / 23-08-2017 / 23:58:03 / cg"
! !

!Scanner methodsFor:'Compatibility-Squeak'!

notify:message at:codeStreamPosition
    "Squeak compatibility"

    ^ self notifyWarning:message position:codeStreamPosition to:nil
! !

!Scanner methodsFor:'accessing'!

atEnd
    "true if the scanned source stream's end has been reached"

    ^ source atEnd
!

comments
    ^ currentComments ? #()
!

exitBlock:aBlock
    exitBlock := aBlock
!

getCollectedComments
    "retrieve the so far collected comments, reset comment collection"

    |comments|

    (comments := currentComments) isEmptyOrNil ifTrue:[^ nil].
    currentComments := nil.
    ^ comments

    "Created: / 05-10-2011 / 10:09:01 / cg"
!

inArrayLiteral:aBoolean
    inArrayLiteral := aBoolean
!

lineNumber
    ^ lineNr
!

newSourceStream:aStream
    source := aStream.
    self nextToken.

    "Created: / 29.10.1998 / 21:59:33 / cg"
!

outStream:aStream
    outStream := aStream.
    outCol := outCol ? 1.
!

requestor
    ^ requestor
!

saveComments:aBoolean
    saveComments := aBoolean.

    "Created: / 20-04-1996 / 20:03:56 / cg"
    "Modified: / 23-05-1997 / 12:14:49 / cg"
    "Modified (comment): / 04-10-2011 / 15:35:51 / cg"
!

sourcePosition
    ^ source position + 1
!

sourcePositionWithoutPeeks

    | pos |
    pos := self sourcePosition.
    peekChar2 notNil ifTrue:[^ pos - 2].
    peekChar  notNil ifTrue:[^ pos - 1].
    ^pos

    "Created: / 25-08-2011 / 11:19:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceStream
    ^ source

    "Created: 20.4.1996 / 19:59:58 / cg"
!

tokenEndPosition
    ^ tokenPosition + tokenName size - 1.

    "Created: / 22-10-2013 / 00:30:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-10-2013 / 03:11:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tokenLineNr
    ^ tokenLineNr
!

tokenName
    ^ tokenName
!

tokenPosition
    ^ tokenPosition
!

tokenStartPosition
    ^ tokenPosition

    "Created: / 22-10-2013 / 00:29:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tokenType
    ^ tokenType
!

tokenValue
    ^ tokenValue

    "Created: / 21.12.2001 / 22:38:08 / cg"
! !

!Scanner methodsFor:'accessing-flags'!

allowDollarInIdentifier
    ^ parserFlags allowDollarInIdentifier
!

allowDollarInIdentifier:something
    parserFlags allowDollarInIdentifier:something
!

allowLiteralNameSpaceSymbols
    ^ parserFlags allowLiteralNameSpaceSymbols
!

allowLiteralNameSpaceSymbols:aBoolean
    parserFlags allowLiteralNameSpaceSymbols:aBoolean
!

allowOldStyleAssignment
    ^ parserFlags allowOldStyleAssignment
!

allowOldStyleAssignment:aBoolean
    parserFlags allowOldStyleAssignment:aBoolean
!

allowSqueakExtensions
    "return true, if support for squeak extensions
	computed arrays { .., }
	c/java style arguments in message sends rec foo(arg1, ... argN)
     is enabled."

    ^ parserFlags allowSqueakExtensions
!

allowSqueakExtensions:aBoolean
    "this allows turning on/off support for squeak extensions:
	computed arrays { .., }
	c/java style arguments in message sends rec foo(arg1, ... argN)
    "

    parserFlags allowSqueakExtensions:aBoolean
!

allowUnderscoreInIdentifier
    ^ parserFlags allowUnderscoreInIdentifier
!

allowUnderscoreInIdentifier:aBoolean
    parserFlags allowUnderscoreInIdentifier:aBoolean
!

didWarnAboutOldStyleAssignment
    ^ didWarnAboutOldStyleAssignment ? false
!

parserFlags
    ^ parserFlags
!

parserFlags:aParserFlagsInstance
    parserFlags := aParserFlagsInstance
!

scanColonAsKeyword
    "/ not used here, but eases subclassing for other languages.
    ^ scanColonAsKeyword
!

warnCommonMistakes
    ^ parserFlags warnCommonMistakes
!

warnCommonMistakes:aBoolean
    parserFlags warnCommonMistakes:aBoolean
!

warnDollarInIdentifier
    ^ parserFlags warnDollarInIdentifier
!

warnDollarInIdentifier:aBoolean
    parserFlags warnDollarInIdentifier:aBoolean
!

warnOldStyleAssignment
    ^ parserFlags warnOldStyleAssignment
!

warnOldStyleAssignment:aBoolean
    parserFlags warnOldStyleAssignment:aBoolean
!

warnPossibleIncompatibilities
    "return true, if possible incompatibilities (with other ST systems)
     are to be warned about"

    ^ parserFlags warnPossibleIncompatibilities
!

warnPossibleIncompatibilities:aBoolean
    parserFlags warnPossibleIncompatibilities:aBoolean
!

warnSTXNameSpaceUse
    ^ parserFlags warnSTXNameSpaceUse
!

warnSTXNameSpaceUse:aBoolean
    parserFlags warnSTXNameSpaceUse:aBoolean
!

warnSTXSpecialComment
    ^ parserFlags warnSTXSpecialComment
!

warnSTXSpecialComment:aBoolean
    parserFlags warnSTXSpecialComment:aBoolean
!

warnUnderscoreInIdentifier
    ^ parserFlags warnUnderscoreInIdentifier
!

warnUnderscoreInIdentifier:aBoolean
    parserFlags warnUnderscoreInIdentifier:aBoolean
! !

!Scanner methodsFor:'directives'!

parseClassDirective
    "
     Class: className
    "

    |className|

    className := self parseDirectiveClassNameArg.
    className isNil ifTrue:[
	Transcript showCR:'Scanner [warning]: unrecognized ''Class'' directive'.
	^ false
    ].
    lastDirective := Directive newClassDirective className:className.
    ^ true
!

parseClassHintDirective
    "
     ClassHint: className
    "

    |className|

    className := self parseDirectiveClassNameArg.
    className isNil ifTrue:[
	Transcript showCR:'Scanner [warning]: unrecognized ''ClassHint'' directive'.
	^ false
    ].
    lastDirective := Directive newClassHintDirective className:className.
    ^ true
!

parseDirective
    "parse a directive inside a comment (introduced with '{').
     This is an ST/X special"

    |directive|

    source next.
    source skipSeparatorsExceptCR.
    hereChar := source peekOrNil.
    hereChar isLetter ifTrue:[
	directive := source nextAlphaNumericWord asLowercase.
	source peekOrNil == $: ifTrue:[
	    source next.
	    source skipSeparatorsExceptCR.
	    hereChar := source peekOrNil.

	    "
	     Package: 'name-of-package'
	     Package: packageId
	    "
	    directive = 'package' ifTrue:[
		self parsePackageDirective.
	    ].

	    "
	     Namespace: 'nameSpaceIdentifier'
	     Namespace: nameSpaceIdentifier
	    "
	    (directive = 'namespace') ifTrue:[
		self parseNamespaceDirective.
	    ].

	    "
	     Uses: 'nameSpace1', ... , 'nameSpaceN'
	     Uses: nameSpaceId1, ... , nameSpaceIdN
	    "
	    directive = 'uses' ifTrue:[
		self parseUsesDirective.
	    ].

	    "
	     reuires: 'name-of-feature'
	    "
	    directive = 'requires' ifTrue:[
		self parseRequiresDirective.
	    ].

	    "
	     Prerequisites: 'name-of-package', ... , 'name-of-package'
	    "
	    directive = 'prerequisites' ifTrue:[
		self parsePrerequisitesDirective.
	    ].

	    "
	     Syntax: 'name-of-dialect'
	    "
	    directive = 'syntax' ifTrue:[
		self parseSyntaxDirective.
	    ].

	    "
	     Class: className
	    "
	    directive = 'class' ifTrue:[
		self parseClassDirective.
	    ].
	    "
	     ClassHint: className
	    "
	    directive = 'classhint' ifTrue:[
		self parseClassHintDirective.
	    ].
	]
    ].
    hereChar := source peekOrNil.
    ^ true.

    "Modified: / 06-12-2006 / 16:14:54 / cg"
!

parseDirectiveClassNameArg
    "helper for parsing a directive"

    ^ self
	parseDirectiveStringArg:[:ch | ch isLetterOrUnderline]
			   rest:[:ch | ch isLetterOrDigit or:[ch == $_ or:[ch == $:]]]

    "Modified: / 18-11-2006 / 14:48:07 / cg"
!

parseDirectiveStringArg
    "helper for parsing a directive.
     scans a word starting with a letter or underline,
     and consisting of letters, digits, underlines or dots."

    ^ self parseDirectiveStringArg:[:ch | ch isLetterOrUnderline]
			      rest:[:ch | ch isLetterOrDigit or:[ch == $_ or:[ch == $.]]]

    "Modified: / 18-11-2006 / 14:47:12 / cg"
!

parseDirectiveStringArg:firstCharacterCheckBlock rest:restCharacterCheckBlock
    "helper for parsing a directive"

    |strBuffer|

    strBuffer := WriteStream on:''.

    hereChar == $' ifTrue:[
	hereChar := source nextPeek.
	[hereChar ~~ $'] whileTrue:[
	    strBuffer nextPut:hereChar.
	    hereChar := source nextPeek.
	].
	hereChar := source nextPeek.
	^ strBuffer contents
    ].

    (firstCharacterCheckBlock value:hereChar) ifTrue:[
	strBuffer nextPut:hereChar.
	hereChar := source nextPeek.
	[restCharacterCheckBlock value:hereChar] whileTrue:[
	    strBuffer nextPut:hereChar.
	    hereChar := source nextPeek.
	].
	^ strBuffer contents
    ].

    ^ nil

    "Created: / 18-11-2006 / 14:46:09 / cg"
!

parseDirectiveStringListArg
    "helper for parsing a directive"

    |list|

    list := OrderedCollection new.

    [hereChar == $'] whileTrue:[
	list addLast:self parseDirectiveStringArg.
	source skipSeparatorsExceptCR.
	hereChar := source peekOrNil.
	(hereChar == $,) ifTrue:[
	    source next.
	    source skipSeparatorsExceptCR.
	    hereChar := source peekOrNil.
	].
    ].
    ^ list

    "Modified: / 5.3.1998 / 02:55:40 / cg"
!

parseNamespaceDirective
    "
     Namespace: 'nameSpace'
     Namespace: nameSpace
    "

    |namespace target|

    namespace := self parseDirectiveStringArg.
    namespace isNil ifTrue:[
	Transcript showCR:'Scanner [warning]: unrecognized ''Namespace'' directive'.
	^ false
    ].
    target := (requestor notNil and:[ requestor respondsTo:#setNameSpace: ]) ifTrue:[requestor] ifFalse:[self].
    Error handle:[:ex |
	ParseError raiseErrorString:ex description
    ] do:[
	target setNameSpace:namespace.
    ].
    ^ true
!

parsePackageDirective
    "
     Package: 'name-of-package'
     Package: packageId
    "

    |packageName target|

    packageName := self parseDirectiveStringArg.
    packageName isNil ifTrue:[
	Transcript showCR:'Scanner [warning]: unrecognized ''Package'' directive'.
	^ false
    ].
    packageName := packageName asSymbol.
    target := (requestor notNil and:[ requestor respondsTo:#setPackage: ]) ifTrue:[requestor] ifFalse:[self].
    target setPackage:packageName.
    ^ true
!

parsePrerequisitesDirective
    "
     Prerequisites: 'name-of-package1', ... , 'name-of-packageN'
    "

    |list|

    list := self parseDirectiveStringListArg.
    list isNil ifTrue:[
	Transcript showCR:'Scanner [warning]: unrecognized ''Prerequisites'' directive'.
	^ false
    ].
    (requestor notNil and:[requestor respondsTo:#requirePackages:]) ifTrue:[
	requestor requirePackages:list
    ].
    ^ true
!

parseRequiresDirective
    "
     Require: 'name-of-feature', ... , 'name-of-featureN'
    "

    |list|

    list := self parseDirectiveStringListArg.
    list isNil ifTrue:[
	Transcript showCR:'Scanner [warning]: unrecognized ''Requires'' directive'.
	^ false
    ].
"/ self halt.
    (requestor notNil and:[requestor respondsTo:#requireFeatures:]) ifTrue:[
	requestor requireFeatures:list
    ].
    ^ true

    "Created: / 06-12-2006 / 16:14:43 / cg"
!

parseSyntaxDirective
    "
     Syntax: 'st-syntax-id'
    "

    |syntax target|

    syntax := self parseDirectiveStringArg.
    syntax isNil ifTrue:[
	Transcript showCR:'Scanner [warning]: unrecognized ''Syntax'' directive'.
	^ false
    ].
    target := (requestor notNil and:[ requestor respondsTo:#setSyntax: ]) ifTrue:[requestor] ifFalse:[self].
    target setSyntax:syntax.
    ^ true
!

parseUsesDirective
    "
     Uses: 'nameSpace1', ... , 'nameSpaceN'
     Uses: nameSpaceId1, ... , nameSpaceIdN
    "

    |list|

    list := self parseDirectiveStringListArg.
    list isNil ifTrue:[
	Transcript showCR:'Scanner [warning]: unrecognized ''Uses'' directive'.
	^ false
    ].
    (requestor notNil and:[requestor respondsTo:#addNameSpaces:]) ifTrue:[
	requestor addNameSpaces:list
    ].
    ^ true
! !

!Scanner methodsFor:'dummy-syntax highlighting'!

markCommentFrom:pos1 to:pos2

    "Created: / 31.3.1998 / 13:34:45 / cg"
!

markConstantFrom:pos1 to:pos2

    "Created: / 1.4.1998 / 13:02:56 / cg"
!

markStringFrom:pos1 to:pos2

    "Created: / 31.3.1998 / 16:37:18 / cg"
!

markSymbolFrom:pos1 to:pos2

    "Created: / 1.4.1998 / 12:58:42 / cg"
! !

!Scanner methodsFor:'error handling'!

clearErrorFlag
    errorFlag := false.
!

correctableError:message position:pos1 to:pos2
    "report an error which can be corrected by compiler -
     return non-false, if correction is wanted
     (there is more than true/false returned here)"

    |correctIt|

    requestor isNil ifTrue:[
"/        self showErrorMessage:message position:pos1.
	correctIt := false
    ] ifFalse:[
	correctIt := requestor correctableError:message position:pos1 to:pos2 from:self
    ].

    ("correctIt == false or:["correctIt == #Error"]") ifTrue:[
	self setErrorFlag.
	exitBlock value
    ].
    ^ correctIt

    "Created: / 13-05-1998 / 16:45:56 / cg"
!

correctableSelectorWarning:message position:pos1 to:pos2
    "report a warning which can be corrected by compiler -
     return non-false, if correction is wanted (there is more than
     true/false returned here)"

    |correctIt|

    requestor isNil ifTrue:[
	correctIt := false
    ] ifFalse:[
	DoNotShowCompilerWarningAgainActionQuery handle:[:ex |
	    parserFlags warnAboutPossiblyUnimplementedSelectors:false.
	    ParserFlags warnAboutPossiblyUnimplementedSelectors:false.
	    ex proceed.
	] do:[
	    correctIt := requestor correctableSelectorWarning:message position:pos1 to:pos2 from:self
	]
    ].
    correctIt == false ifTrue:[
	exitBlock value
    ].
    ^ correctIt

    "Created: / 19-01-2000 / 16:28:03 / cg"
!

correctableWarning:aMessage doNotShowAgainAction:doNotShowAgainAction doNotShowAgainForThisMethodAction:doNotShowAgainForThisMethodAction position:position to:endPos
    "notify requestor of a warning - if there is no requestor, just ignore it.
     Return the result passed back from the requestor (or false, if there is none)."

    |answer warnAction realAction real2Action|

    ignoreWarnings ifTrue:[ ^ false ].
    parserFlags warnings ifFalse:[^ false].

    requestor isNil ifTrue:[
	^ false
    ].

    warnAction := [ answer := requestor correctableWarning:aMessage position:position to:endPos from:self ].

    doNotShowAgainAction notNil ifTrue:[
	realAction := warnAction.
	warnAction :=
	    [
		DoNotShowCompilerWarningAgainActionQuery
		    answer:doNotShowAgainAction
		    do:realAction
	    ].
    ].
    (doNotShowAgainForThisMethodAction notNil and:[ self isDoIt not ]) ifTrue:[
	real2Action := warnAction.
	warnAction :=
	    [
		DoNotShowCompilerWarningAgainForThisMethodActionQuery
		    answer:doNotShowAgainForThisMethodAction
		    do:real2Action
	    ].
    ].

    warnAction value.
    ^ answer

    "Created: / 28-02-2012 / 08:42:01 / cg"
!

correctableWarning:message position:pos1 to:pos2
    "report an error which can be corrected by compiler -
     return non-false, if correction is wanted
     (there is more than true/false returned here - i.e. a symbol, describing how to fix it)"

    |correctIt|

    requestor isNil ifTrue:[
	"/ self showErrorMessage:message position:pos1.
	correctIt := false
    ] ifFalse:[
	correctIt := requestor correctableWarning:message position:pos1 to:pos2 from:self
    ].

    (correctIt == false or:[correctIt == #Error]) ifTrue:[
	exitBlock value
    ].
    ^ correctIt

    "Created: / 02-11-2010 / 13:32:32 / cg"
!

disableWarningsOnCurrentMethodFor:flagName
    "ignored here"

    "Created: / 28-02-2012 / 14:44:43 / cg"
!

errorFlag:flagArg
    errorFlag := flagArg
!

errorMessagePrefix
    ^ 'Error:'
!

ignorableParseError:message
    self parseError:message.
    "/ if proceeded, install method anyway (used with non-st/x primitives)
    self clearErrorFlag
!

invalidCharacter:ch
    |errMsg v|

    v := ch codePoint.
    ch isPrintable ifTrue:[
	errMsg := 'Invalid character: ''' , ch asString , ''' ', '(' , (v radixPrintStringRadix:16) , ').'.
    ] ifFalse:[
	errMsg := 'Invalid character: ' , (v radixPrintStringRadix:16) , '.'.
    ].
    v > 16r7F ifTrue:[
	errMsg := errMsg , '

Notice:
  Only 7-bit ascii allowed (for compatibility with other Smalltalk dialects).
  You can enable some of the special characters via the compiler-settings dialog.'.
    ].
    self syntaxError:errMsg position:tokenPosition to:tokenPosition.
    source next.
    tokenName := token := nil.
    tokenType := #Error.
    ^ #Error

    "Modified: / 17-11-2016 / 09:37:52 / cg"
!

lastTokenLineNumber
    "return the line number of the token which was just read."

    ^ tokenLineNr

    "Created: 8.11.1996 / 18:46:36 / cg"
    "Modified: 23.5.1997 / 12:16:12 / cg"
!

notifyError:aMessage position:position to:endPos
    "notify requestor of an error - if there is no requestor
     put it on the transcript. Requestor is typically the CodeView
     in which the accept/doIt was triggered, or the PositionableStream
     which does the fileIn. The requestor may decide how to highlight the
     error (and/or to abort the compile).
     Return the result passed back by the requestor."

    (Smalltalk isInitialized not and:[Smalltalk isDebuggableApp]) ifTrue:[
        "/ error during startup, but sometimes we expect an error and want to suppress it
        Parser parseWarningSignal query ~~ #ignore ifTrue:[
            (self class name,' [error]: error during initialization:') errorPrint.
            aMessage errorPrintCR.
            thisContext fullPrintAll.
        ].
    ].

    ignoreErrors ifTrue:[
        "/ usually done, when syntax highlighting or looking for used variables
        "/ self halt.
    ] ifFalse:[
        "/ Raise an error.
        "/ For backward compatibility, if error IS NOT handled and requestor
        "/ IS set, then dispatch to requestor.

        "/ backward compatibility - will vanish eventually (use a handler, Luke)
        ("ParseError isHandled not and: ["requestor notNil"]") ifTrue:[
            requestor error:aMessage position:position to:endPos from:self.
            ^ self
        ].
        true "ParseError isHandled" ifTrue:[
            ParseError new
                errorMessage:aMessage startPosition:position endPosition:endPos;
                parameter:self;
                lineNumber:tokenLineNr; "lineNr"
                raiseRequest.
            ^ self
        ].
        self showErrorMessage:aMessage position:position.
    ].

    "Modified: / 18-01-2012 / 14:54:22 / Alexander Zottnick"
    "Modified: / 19-01-2012 / 10:18:36 / cg"
    "Modified: / 02-05-2014 / 14:51:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-04-2018 / 10:39:56 / stefan"
!

notifyWarning:aMessage doNotShowAgainAction:doNotShowAgainAction doNotShowAgainForThisMethodAction:doNotShowAgainForThisMethodAction position:position to:endPos
    "notify requestor of a warning - if there is no requestor, just ignore it.
     Return the result passed back from the requestor (or false, if there is none)."

    |answer warnAction realAction real2Action|

    ignoreWarnings ifTrue:[ ^ false ].
    parserFlags warnings ifFalse:[^ false].

    requestor isNil ifTrue:[
"/        self showErrorMessage:aMessage position:position.
	^ false
    ].

    warnAction := [ answer := requestor warning:aMessage position:position to:endPos from:self ].

    doNotShowAgainAction notNil ifTrue:[
	realAction := warnAction.
	warnAction :=
	    [
		DoNotShowCompilerWarningAgainActionQuery
		    answer:doNotShowAgainAction
		    do:realAction
	    ].
    ].
    (doNotShowAgainForThisMethodAction notNil and:[ self isDoIt not ]) ifTrue:[
	real2Action := warnAction.
	warnAction :=
	    [
		DoNotShowCompilerWarningAgainForThisMethodActionQuery
		    answer:doNotShowAgainForThisMethodAction
		    do:real2Action
	    ].
    ].

    warnAction value.
    ^ answer

    "Created: / 28-02-2012 / 08:42:01 / cg"
!

notifyWarning:aMessage doNotShowAgainAction:doNotShowAgainAction position:position to:endPos
    "notify requestor of a warning - if there is no requestor, just ignore it.
     Return the result passed back from the requestor (or false, if there is none)."

    ^ self
	notifyWarning:aMessage
	doNotShowAgainAction:doNotShowAgainAction
	doNotShowAgainForThisMethodAction:nil
	position:position to:endPos

    "Modified: / 28-02-2012 / 08:44:45 / cg"
!

notifyWarning:aMessage position:position to:endPos
    "notify requestor of an warning - if there is no requestor
     put it on the transcript.
     Return the result passed back by the requestor."

    ^ self
	notifyWarning:aMessage
	doNotShowAgainAction:nil
	position:position to:endPos.

    "Modified (format): / 28-02-2012 / 08:44:13 / cg"
!

parseError:aMessage
    "report an error"

    ^ self parseError:aMessage position:tokenPosition to:nil

    "Created: / 13.5.1998 / 16:45:13 / cg"
!

parseError:aMessage line:lNr
    "report an error"

    |position|

    tokenLineNr := lNr.
    position := self positionFromLineNumber:lNr.
    ^ self parseError:aMessage position:position to:nil

    "Created: / 13-05-1998 / 16:45:05 / cg"
    "Modified: / 16-11-2006 / 14:29:00 / cg"
!

parseError:aMessage position:position
    "report an error"

    ^ self parseError:aMessage position:position to:nil

    "Created: / 13.5.1998 / 16:45:05 / cg"
!

parseError:aMessage position:position to:endPos
    "report an error"

    |fullMessage|

    Smalltalk isInitialized ifFalse:[
	(self class name,' [error]: error during initialization:') errorPrint.
	aMessage errorPrintCR.
	thisContext fullPrintAll.
    ].

    "/ fullMessage := (self errorMessagePrefix) , ' ' , (aMessage ? '???').
    fullMessage := (aMessage ? 'Unspecified error').
    self setErrorFlag.
    self notifyError:fullMessage position:position to:endPos.
    exitBlock value.
    ^ false

    "Created: / 13-05-1998 / 16:44:55 / cg"
    "Modified: / 22-08-2006 / 14:13:11 / cg"
!

positionFromLineNumber:lNr
    (requestor notNil and:[requestor isTextView]) ifTrue:[
	^ requestor characterPositionOfLine:lNr col:1.
    ].
    ^ nil

    "Created: / 16-11-2006 / 14:28:37 / cg"
!

setErrorFlag
    errorFlag := true.
!

showErrorMessage:aMessage position:pos
    "show an errormessage on the Transcript"

    (ignoreErrors or:[Smalltalk silentLoading]) ifFalse:[
	Transcript showCR:('Scanner [<4p> line:<1p> off:<2p>]: <3p>'
			    expandMacrosWith:tokenLineNr with:pos with:aMessage with:source).
    ]

    "Modified: 18.5.1996 / 15:44:35 / cg"
!

syntaxError:aMessage
    "a syntax error happened - position is not known"

    ^ self syntaxError:aMessage position:tokenPosition
!

syntaxError:aMessage position:position
    "a syntax error happened - only start position is known"

    ^ self syntaxError:aMessage position:position to:nil
!

syntaxError:aMessage position:position to:endPos
    "a syntax error happened.
     Return true for correction, false if not"

    |fullMessage ret|

    "/ fullMessage := self errorMessagePrefix , ' ' , aMessage.
    fullMessage := aMessage.
    ret := self notifyError:fullMessage position:position to:endPos.
    "/ exitBlock value.
    "/ ^ false
    self setErrorFlag.
    ^ ret.

    "Modified: / 30-06-2011 / 19:49:19 / cg"
!

warnCommonMistake:msg at:position
    "warn about a common beginners mistake"

    self warnCommonMistake:msg position:position to:position

    "Modified: 23.5.1997 / 12:16:34 / cg"
!

warnCommonMistake:msg position:pos1 to:pos2
    "warn about a common beginners mistake"

    ignoreWarnings ifFalse:[
	parserFlags warnings ifTrue:[
	    parserFlags warnCommonMistakes ifTrue:[
		self
		    warning:msg
		    position:pos1 to:pos2.
	    ]
	]
    ]

    "Created: 18.7.1996 / 10:28:38 / cg"
    "Modified: 23.5.1997 / 12:16:39 / cg"
!

warnDollarAt:position
    "warn about $-character in an identifier"

    ignoreWarnings ifFalse:[
	didWarnAboutDollarInIdentifier ifFalse:[
	    parserFlags warnDollarInIdentifier ifTrue:[
		self
		    warning:'$-characters in identifiers/symbols are nonportable'
		    doNotShowAgainAction:[ ParserFlags warnDollarInIdentifier:false ]
		    position:position to:position.
		"
		 only warn once (per method)
		"
		didWarnAboutDollarInIdentifier := true
	    ]
	]
    ]

    "Created: 7.9.1997 / 01:50:24 / cg"
    "Modified: 7.9.1997 / 01:51:13 / cg"
!

warnOldStyleAssignmentAt:position
    "warn about an oldStyle assignment"

    ignoreWarnings ifFalse:[
	didWarnAboutOldStyleAssignment ifFalse:[
	    parserFlags warnOldStyleAssignment ifTrue:[
		self
		    warning:'Old style assignment - please change to use '':='''
		    doNotShowAgainAction:[ ParserFlags warnOldStyleAssignment:false ]
		    position:position to:position.
	    ].
	    "
	     only warn once (per method)
	    "
	    didWarnAboutOldStyleAssignment := true
	]
    ]

    "Modified: 23.5.1997 / 12:16:48 / cg"
!

warnParagraphAt:position
    "warn about §-character in an identifier"

    ignoreWarnings ifFalse:[
	"/ didWarnAboutParagraphInIdentifier ifFalse:[
	    parserFlags warnParagraphInIdentifier ifTrue:[
		self
		    warning:'§-characters in identifiers/symbols are nonportable'
		    doNotShowAgainAction:[ ParserFlags warnParagraphInIdentifier:false ]
		    position:position to:position.
		"
		 only warn once (per method)
		"
		parserFlags := parserFlags copy.
		parserFlags warnParagraphInIdentifier:false.
		"/ didWarnAboutParagraphInIdentifier := true
	    ]
	"/ ]
    ]

    "Created: / 17-11-2016 / 09:16:22 / cg"
!

warnPeriodAt:position
    "warn about a period in an identifier"

    ignoreWarnings ifFalse:[
	didWarnAboutPeriodInSymbol ifFalse:[
	    parserFlags warnAboutPeriodInSymbol ifTrue:[
		self
		    warning:'Period in symbols are nonportable'
		    doNotShowAgainAction:[ ParserFlags warnAboutPeriodInSymbol:false ]
		    position:position to:position.
		"
		 only warn once (per method)
		"
		didWarnAboutPeriodInSymbol := true
	    ]
	]
    ]
!

warnPossibleIncompatibility:msg position:pos1 to:pos2
    "warn about a possible incompatibility with other ST systems"

    ignoreWarnings ifFalse:[
	parserFlags warnPossibleIncompatibilities ifTrue:[
	    self
		warning:('Possible incompatibility.\\' , msg) withCRs
		doNotShowAgainAction:[ ParserFlags warnPossibleIncompatibilities:false.
				       parserFlags warnPossibleIncompatibilities:false ]
		position:pos1 to:pos2.
	]
    ]

    "Created: 23.5.1997 / 12:17:54 / cg"
    "Modified: 23.5.1997 / 12:22:37 / cg"
!

warnSTXSpecialCommentAt:position to:endPosition
    ignoreWarnings ifFalse:[
	"/ dfo
	didWarnAboutSTXSpecialComment ifFalse:[
	    parserFlags warnSTXSpecialComment ifTrue:[
		self
		    warning:'End-of-line comments are a nonstandard feature of ST/X'
		    doNotShowAgainAction:[ parserFlags warnSTXSpecialComment:false. ParserFlags warnSTXSpecials:false. ]
		    doNotShowAgainForThisMethodAction: [ self disableWarningsOnCurrentMethodFor: #warnSTXSpecials ]
		    position:position to:endPosition.
		"
		 only warn once
		"
		didWarnAboutSTXSpecialComment := true
	    ]
	]
    ].

    "Modified: / 16-03-2012 / 18:37:11 / cg"
!

warnUnderscoreAt:position
    "warn about an underscore in an identifier"

    ignoreWarnings ifFalse:[
	didWarnAboutUnderscoreInIdentifier ifFalse:[
	    parserFlags warnUnderscoreInIdentifier ifTrue:[
		self
		    warning:'Underscores in identifiers/symbols are nonportable'
		    doNotShowAgainAction:[ ParserFlags warnUnderscoreInIdentifier:false ]
		    position:position to:position.
		"
		 only warn once (per method)
		"
		didWarnAboutUnderscoreInIdentifier := true
	    ]
	]
    ]

    "Modified: 23.5.1997 / 12:17:06 / cg"
!

warning:aMessage
    "a warning - position is not known"

    ^ self warning:aMessage position:tokenPosition
!

warning:aMessage doNotShowAgainAction:doNotShowAgainAction doNotShowAgainForThisMethodAction:doNotShowAgainForThisMethodAction position:position to:endPos
    "a warning"

    ^ self
	notifyWarning:((self warningMessagePrefix) , ' ' , aMessage)
	doNotShowAgainAction:doNotShowAgainAction
	doNotShowAgainForThisMethodAction:doNotShowAgainForThisMethodAction
	position:position to:endPos

    "Created: / 28-02-2012 / 08:38:16 / cg"
!

warning:aMessage doNotShowAgainAction:doNotShowAgainAction position:position to:endPos
    "a warning"

    ^ self
	warning:aMessage
	doNotShowAgainAction:doNotShowAgainAction
	doNotShowAgainForThisMethodAction:nil
	position:position to:endPos

    "Modified: / 28-02-2012 / 08:43:00 / cg"
!

warning:aMessage line:lNr
    "a warning - only start position is known"

    |position|

    position := self positionFromLineNumber:lNr.
    ^ self warning:aMessage position:position to:nil

    "Created: / 16-11-2006 / 14:29:30 / cg"
!

warning:aMessage position:position
    "a warning - only start position is known"

    ^ self warning:aMessage position:position to:nil
!

warning:aMessage position:position to:endPos
    "a warning"

    ^ self
	notifyWarning:((self warningMessagePrefix) , ' ' , aMessage)
	doNotShowAgainAction:nil
	position:position to:endPos
!

warningMessagePrefix
    ^ 'Warning:'
! !

!Scanner methodsFor:'general scanning'!

scanNumberFrom:aStringOrStream
    "scan aSourceString for the next number in smalltalk syntax.
     Return the number or nil. Leave the position of the stream after the number
     or unchanged (if no number is coming)
     Extension:
	since contant fractions (int/int) are treated like lexical tokens (not messages)
	in Smalltalk/X, this also reads fractions."

    |oldPos posAfter denominator numerator parentized sign|

    self initializeFor:aStringOrStream.
    oldPos := source position.
    self nextToken.

    sign := 1.
    tokenType == #BinaryOperator ifTrue:[
	tokenName = '+' ifTrue:[
	    self nextToken.
	] ifFalse:[
	    tokenName = '-' ifTrue:[
		sign := -1.
		self nextToken.
	    ].
	].
    ].
    (parentized := tokenType == $( ) ifTrue:[
	self nextToken.
	tokenType == #BinaryOperator ifTrue:[
	    tokenName = '+' ifTrue:[
		self nextToken.
	    ] ifFalse:[
		tokenName = '-' ifTrue:[
		    sign := sign negated.
		    self nextToken.
		].
	    ].
	].
    ].

    (tokenValue isNumber) ifTrue:[
	"/ must keep stream positioned correctly
	"/ (undo lookahead)
	posAfter := source position.
	peekChar notNil ifTrue:[
	    peekChar2 notNil ifTrue:[
		posAfter := posAfter - 1
	    ].
	    posAfter := posAfter - 1
	].
	tokenValue isInteger ifTrue:[
	    source skipSeparators.
	    source peekOrNil == $/ ifTrue:[
		numerator := tokenValue.
		self nextToken. "/ skip /
		"/ oops - must check for //
		tokenName = '/' ifFalse:[
		    parentized ifTrue:[
			"/ nothing at all
			source position:oldPos.
			^ nil.
		    ].
		    "/ only an integer
		    source position:posAfter.
		    ^ tokenValue
		].

		self nextToken. "/ get denominator
		tokenType == #BinaryOperator ifTrue:[
		    tokenName = '+' ifTrue:[
			self nextToken.
		    ] ifFalse:[
			tokenName = '-' ifTrue:[
			    sign := sign negated.
			    self nextToken.
			].
		    ].
		].
		(tokenType == #Integer and:[tokenValue isInteger]) ifTrue:[
		    denominator := tokenValue.
		    tokenValue := Fraction numerator:numerator denominator:denominator.
		    posAfter := source position.
		    peekChar notNil ifTrue:[
			peekChar2 notNil ifTrue:[
			    posAfter := posAfter - 1
			].
			posAfter := posAfter - 1
		    ].
		].
	    ].
	].
	parentized ifTrue:[
	    tokenType == $) ifTrue:[
		self nextToken
	    ]
	] ifFalse:[
	    source position:posAfter.
	].
	sign == -1 ifTrue:[^ tokenValue negated].
	^ tokenValue
    ].
    "/ backup in case of error; return nil
    source position:oldPos.
    ^ nil.

    "Created: / 18.6.1998 / 23:05:22 / cg"
    "Modified: / 19.11.1999 / 18:25:52 / cg"
!

scanPositionsFor:aTokenString inString:aSourceString
    "scan aSourceString for occurrences of aTokenString.
     Return a collection of start positions.
     Added for VW compatibility (to support simple syntax-highlight)."

    |searchType searchName searchValue positions t|

    aTokenString notNil ifTrue:[
	"
	 first, look what kind of token we have to search for
	"
	self initializeFor:(ReadStream on:aTokenString).
	self nextToken.
	searchType := tokenType.
	searchName := tokenName.
	searchValue := tokenValue.
    ].

    "
     start the real work ...
    "
    self initializeFor:(ReadStream on:aSourceString).
    positions := OrderedCollection new.

    [(t := self nextToken) ~~ #EOF] whileTrue:[
	searchType == t ifTrue:[
	    (searchName isNil or:[tokenName = searchName]) ifTrue:[
		(searchValue isNil or:[tokenValue = searchValue]) ifTrue:[
		    positions add:tokenPosition.
		]
	    ]
	]
    ].

    ^ positions

    "
     Scanner new scanPositionsFor:'hello' inString:'foo bar hello baz hello'
     Scanner new scanPositionsFor:'3.14' inString:'foo 3.145 bar hello 3.14 baz hello 3.14'
     Scanner new scanPositionsFor:'16' inString:'foo 16 bar hello 16r10 baz hello 2r10000'
    "
! !

!Scanner methodsFor:'initialization'!

initialize
    "initialize the scanner"

    "/ <modifier: #super> "must be called if redefined"

    errorFlag := false.
    tokenPosition := 1.
    tokenLineNr := lineNr := 1.
    currentComments := nil.
    "/ allow for these to be already set (kludge)
    saveComments isNil ifTrue:[ saveComments := false ].
    parserFlags isNil ifTrue:[ parserFlags := ParserFlags new ].

    ignoreErrors := false.
    ignoreWarnings := parserFlags warnings not.
    didWarnAboutSTXSpecialComment := false.
    didWarnAboutUnderscoreInIdentifier := false.
    didWarnAboutDollarInIdentifier := false.
    didWarnAboutOldStyleAssignment := false.

    "/ not used here, but eases subclassing for other languages.
    scanColonAsKeyword isNil ifTrue:[ scanColonAsKeyword := true ].
    self initializeActionTable.

    "Modified: / 13-02-2017 / 13:45:51 / cg"
!

initializeActionTable
    actionArray := self class actionArray.
    unicodeActions := self class unicodeActions.
    typeArray := self class typeArray.

    "Created: / 18-10-2006 / 23:10:55 / cg"
    "Modified: / 25-03-2011 / 13:57:50 / cg"
!

initializeFlagsFrom:aScanner
    "initialize flags from another scanner"

    ignoreErrors := aScanner ignoreErrors.
    ignoreWarnings := aScanner ignoreWarnings.
    parserFlags := aScanner parserFlags copy.

    "/ not used here, but eases subclassing for other languages.
    scanColonAsKeyword := aScanner scanColonAsKeyword.
!

initializeFor:aStringOrStream
    "initialize the new scanner & prepare for reading from aStringOrStream"

    actionArray isNil ifTrue:[
	"/ if not already initialized...
	self initialize.
    ].
    self source:aStringOrStream.

    "Modified: / 05-10-2011 / 09:24:00 / cg"
!

requestor:anObject
    "set the requestor to be notified"

    requestor := anObject

    "Created: / 07-12-2006 / 18:13:13 / cg"
!

setSource:newSource
    source := newSource

!

source:aStringOrStream
    "prepare for reading from aStringOrStream;
     notice: if token is nonNil, it is preserved. This allows for scanning
     across streams."

    errorFlag := false.
    tokenPosition := 1.
    tokenLineNr := lineNr := 1.
    currentComments := nil.

    aStringOrStream isStream ifFalse:[
	source := ReadStream on:aStringOrStream
    ] ifTrue:[
	source := aStringOrStream.
    ].

    "Modified: / 26-05-1999 / 12:02:16 / stefan"
    "Modified: / 06-12-2011 / 00:45:50 / cg"
! !

!Scanner methodsFor:'parser interface'!

token
    ^ token
!

tokenLineNr:lineNumberArg
    tokenLineNr := lineNumberArg
!

tokenPosition:positionArg
    tokenPosition := positionArg
! !

!Scanner methodsFor:'private'!

backupPosition
    "if reading from a stream, at the end we might have read
     one token too many"

    (tokenType == #EOF) ifFalse:[
	source position:tokenPosition-1
    ]
!

beginComment
    ^ self
!

checkForKeyword:string
    "check if string is a keyword (as opposed to an identifier).
     That is, its one of 'self', 'super', 'nil', 'true', 'false',
     or 'thisContext'.
     'here' is handled elsewhere (since it must be treated as an
     identifier, if declared locally."

    |firstChar|

    firstChar := string at:1.
    (firstChar == $s) ifTrue:[
	(string = 'self')  ifTrue:[tokenType := #Self. ^true].
	(string = 'super') ifTrue:[tokenType := #Super. ^true]
    ].
    (firstChar == $n) ifTrue:[
	(string = 'nil') ifTrue:[tokenType := #Nil. tokenValue := nil. ^true]
    ].
    (firstChar == $t) ifTrue:[
	(string = 'true') ifTrue:[tokenType := #True. tokenValue := true. ^true].
	(string = 'thisContext') ifTrue:[tokenType := #ThisContext. ^true]
    ].
    (firstChar == $f) ifTrue:[
	(string = 'false') ifTrue:[tokenType := #False. tokenValue := false. ^true]
    ].
    ^ false

    "Modified: / 13.5.1998 / 14:59:55 / cg"
!

collectedSource
    ^ collectedSource
!

eatPeekChar
    peekChar isNil ifTrue:[
	source next.
    ] ifFalse:[
	peekChar := nil.
    ].

    "Created: / 24.10.1998 / 17:25:39 / cg"
!

endComment:comment
    saveComments ifTrue:[
	currentComments isNil ifTrue:[
	    currentComments := OrderedCollection with:comment
	] ifFalse:[
	    currentComments add:comment
	]
    ].
!

endComment:commentString type:commentType
    "obsolete; left for backward compatibility"

    ^ self endComment:commentString type:commentType start:nil end:nil
!

endComment:commentString type:commentType start:startPos end:endPos
    |comment|

    saveComments ifTrue:[
	comment := Comment new commentString:commentString commentType:commentType.
	comment startPosition:startPos endPosition:endPos.

	currentComments isNil ifTrue:[
	    currentComments := OrderedCollection with:comment
	] ifFalse:[
	    currentComments add:comment
	]
    ].

    "Created: / 17.2.1998 / 14:48:49 / cg"
!

eolIsWhiteSpace
    ^ true

    "Created: / 14-03-2011 / 14:11:46 / cg"
!

escapeCharacterFor:aCharacter
    "only if AllowExtendedSTXSyntax is true
     For now: do not use, since stc does not support it.

     much like character escapes in C-literals;
     expands:
	\n      newLine
	\r      return
	\t      tab
	\b      backspace
	\f      formfeed
	\g      bell

	\\      backSlash
	\ ...\  (backslash-separator) ignored up to next backslash
	\xNN    hexCharacter
	\uNNNN  hex UnicodeCharacter
    "

    |ascii nextChar fetchNext|

    aCharacter == $n ifTrue:[^ Character nl].
    aCharacter == $r ifTrue:[^ Character return].
    aCharacter == $t ifTrue:[^ Character tab].
    aCharacter == $b ifTrue:[^ Character backspace].
    aCharacter == $f ifTrue:[^ Character ff].
    aCharacter == $g ifTrue:[^ Character bell].
    aCharacter == $\ ifTrue:[^ aCharacter].
    aCharacter isSeparator ifTrue:[
	nextChar := source next.
	[nextChar notNil and:[nextChar ~~ $\]] whileTrue:[
	    (nextChar == Character cr) ifTrue:[
		lineNr := lineNr + 1
	    ].
	    nextChar := source next.
	].
	^ nil
    ].

    (aCharacter == $x or:[ aCharacter == $u ]) ifTrue:[
	fetchNext :=
	    [
		nextChar := source next.
		(nextChar notNil and:[nextChar isDigitRadix:16]) ifFalse:[
		    self syntaxError:'hex digit expected in string literal'
			 position:(source position) to:(source position).
		].
		nextChar digitValue
	    ].

	ascii := fetchNext value.
	ascii := (ascii bitShift:4) bitOr:(fetchNext value).

	(aCharacter == $u ) ifTrue:[
	    ascii := (ascii bitShift:4) bitOr:(fetchNext value).
	    ascii := (ascii bitShift:4) bitOr:(fetchNext value).
	].
	^ Character value:ascii.
    ].
    ^ aCharacter

    "
     ParserFlags allowExtendedSTXSyntax:true
    "
    "
     'hello\nworld'
     'hello\x0Dworld'
     'hello\x08world'
     'hello\
    \world'
    "
    "
     ParserFlags allowExtendedSTXSyntax:false
    "
!

ignoreErrors
    "return the flag which controls notification of errors"

    ^ ignoreErrors
!

ignoreErrors:aBoolean
    "enable/disable notification of errors"

    ignoreErrors := aBoolean
!

ignoreWarnings
    "return the flag which controls notification of warnings"

    ^ ignoreWarnings
!

ignoreWarnings:aBoolean
    "enable/disable notification of warnings"

    ignoreWarnings := aBoolean
!

isCommentCharacter:ch
    "return true, if ch is the comment-start character.
     Brought into a separate method to allow for easier subclassing"

    ^ ch == $"

    "Created: / 14.5.1998 / 20:51:42 / cg"
    "Modified: / 14.5.1998 / 20:53:01 / cg"
!

isDoIt
    ^ false
!

isSpecialOrExtendedSpecialCharacter:ch
    |code charType|

    code := ch codePoint.
    (code between:1 and: typeArray size) ifFalse:[^ false].

    charType := typeArray at:code.
    ^ (charType == #special)
       or:[ (charType == #extendedSpecial) and:[parserFlags allowExtendedBinarySelectors] ]

    "
     self basicNew isSpecialOrExtendedSpecialCharacter:$-
    "
!

notifying:anObject
    "set the requestor to be notified"

    requestor := anObject
!

setNameSpace:aNameSpace
    "/ ignored here

    "Created: 8.11.1996 / 13:33:10 / cg"
!

setPackage:aNameSpace
    "/ ignored here

    "Created: 8.11.1996 / 13:33:10 / cg"
!

setSyntax:aSyntax
! !

!Scanner methodsFor:'reading next token'!

nextAssignmentArrow
    "return a left-arrow"

    ^ self nextToken:$_

    "Created: / 25-03-2011 / 13:58:50 / cg"
!

nextCharacter
    "a $ has been read - return a character token"

    |nextChar t|

    source next.
    nextChar := source next.
    nextChar notNil ifTrue:[
	t := nextChar.
	tokenType := #Character.
    ] ifFalse:[
	t := nil.
	tokenType := #EOF
    ].
    tokenValue := token := t.
    ^ tokenType

    "Modified: / 13.5.1998 / 15:09:50 / cg"
!

nextColonOrAssign
    "colon has been read - look for = to make it an assign"

    |thirdChar|

    "/ special kludge for identifier:= (without spaces inbetween)
    "/ here we needed two characters lookahead after the identifier ...

    peekChar == $= ifTrue:[
	source next.
	peekChar := nil.
	tokenType := token := #':='.

	thirdChar := source peek.
	thirdChar notNil ifTrue:[
	    (self isSpecialOrExtendedSpecialCharacter:thirdChar) ifTrue:[

	    ]
	].

	^ tokenType
    ].

    "/ special kludge for nameSpace:: (without spaces inbetween)
    "/ here we needed two characters lookahead after the identifier ...

    peekChar == $: ifTrue:[
	source next.
	peekChar := nil.
	tokenType := token := #'::'.
	^ tokenType
    ].

    (source nextPeek == $=) ifTrue:[
	source next.
	tokenType := token := #':='
    ] ifFalse:[
	tokenType := token := $:
    ].
    ^ tokenType

    "Modified: / 13.5.1998 / 15:10:04 / cg"
!

nextExcla
    "a !! has been read - return either
	the !! binarySelector,
	ExclaLeftParen     (for '!!('),
	ExclaLeftBrack     (for '!!['),
	ExclaLeftBrace     (for '!!{')
    "

    |nextChar|

    nextChar := source nextPeek.
    parserFlags allowExtendedSTXSyntax == true ifTrue:[
	(nextChar == $( ) ifTrue:[
	    source next.
	    token := '!!('.
	    tokenType := #ExclaLeftParen.
	    ^ tokenType
	].

	(nextChar == $[ ) ifTrue:[
	    source next.
	    token := '!!['.
	    tokenType := #ExclaLeftBrack.
	    ^ tokenType
	].

	(nextChar == ${ ) ifTrue:[
	    source next.
	    token := '!!{'.
	    tokenType := #ExclaLeftBrace.
	    ^ tokenType
	].
    ].

    "this allows excla to be used as binop -
     I don't know, if this is correct ..."

"/    tokenName := token := '!!'.
"/    tokenType := #BinaryOperator.
"/    ^ tokenType

    ^ self nextSpecialWith:$!!.
!

nextExtendedSpecial:ch
    parserFlags allowExtendedBinarySelectors ifTrue:[
	^ self nextSpecial
    ].
    ^ self invalidCharacter:source peek.
!

nextHash
    "a # has been read - return either
	a symbol,
	HashLeftParen     (for '#('),
	HashLeftBrack     (for '#['),
	HashLeftBrace     (for '#{'  and AllowQualifiedNames)
	HashHashLeftParen (for '##(' and AllowDolphinExtensions)
	HashHashLeftBrack (for '##[' )
	HashHash          (for '##' )

     extended syntax (scheme-style literal arrays):
	HashTypedArrayParen   (for '#u8(', '#s8(' , '#u16(' ...)
	type in tokenValue: u1, u8, u16, u32, u64, s8, s16, s32, s64,
			    f16, f32, f64, f, d, b, B
    "

    |nextChar string allowUnderscoreInIdentifier|

    allowUnderscoreInIdentifier := parserFlags allowUnderscoreInIdentifier.

    nextChar := source nextPeek.
    nextChar notNil ifTrue:[
	(nextChar == $( ) ifTrue:[
	    source next.
	    token := '#('.
	    tokenType := #HashLeftParen.
	    ^ tokenType
	].

	(nextChar == $[ ) ifTrue:[
	    "ST-80 & ST/X support Constant ByteArrays as #[...]"
	    source next.
	    token := '#['.
	    tokenType := #HashLeftBrack.
	    ^ tokenType
	].

	(nextChar == ${ ) ifTrue:[
	    " #{ ... } is one of:
		#{ Foo.Bar.Baz }            VW3 and later qualified name
		#{ xx-xx-xx-xx-...-xx }     StAgents UUID
		#{ URL }                    url object qualifier
	    "
	    source next.
	    token := '#{'.
	    tokenType := #HashLeftBrace.
	    ^ tokenType
	].

	(nextChar == $' ) ifTrue:[
	    "ST-80 and ST/X support arbitrary symbols as #'...'"
	    self nextString:nextChar.
	    self markSymbolFrom:tokenPosition to:(source position).
	    tokenType == #EOF ifFalse:[
		tokenValue isWideString ifTrue:[
		    self syntaxError:'symbols which require 2-byte characters are not (yet) allowed'
			    position:tokenPosition to:(source position).
		].
		tokenValue := token := tokenValue asSymbol.
		tokenType := #Symbol.
	    ].
	    ^ tokenType
	].

	(nextChar == $#) ifTrue:[
	    nextChar := source nextPeek.
	    nextChar == $( ifTrue:[
		parserFlags allowDolphinExtensions == true ifTrue:[
		    "dolphin does computed literals as ##( ... )"
		    source next.
		    token := '##('.
		    tokenType := #HashHashLeftParen.
		    ^ tokenType
		].
	    ].

	    nextChar == $[ ifTrue:[
		source next.
		token := '##['.
		tokenType := #HashHashLeftBrack.
		^ tokenType
	    ].

	    parserFlags allowVisualAgeESSymbolLiterals == true ifTrue:[
		(self nextSymbolAfterHash) notNil ifTrue:[
		    tokenType := #ESSymbol.
		    ^ #ESSymbol
		].
		(nextChar == $') ifTrue:[
		    source next.
		    self nextString:nextChar.
		    tokenType := #ESSymbol.
		    ^ #ESSymbol
		].
	    ].

	    token := '##'.
	    tokenType := #HashHash.
	    ^ tokenType
	].

	parserFlags allowSTXExtendedArrayLiterals ifTrue:[
	    "/ scheme-style typed literal array extension
	    ('usfdbB' includes:nextChar) ifTrue:[
		|prefix|

		prefix := String with:nextChar.
		nextChar := source nextPeek.
		[nextChar notNil and:[nextChar isDigit]] whileTrue:[
		    prefix := prefix copyWith:nextChar.
		    nextChar := source nextPeek.
		].
		nextChar == $( ifTrue:[
		    source next.
		    (
			#( 'f' 'd' 'b' 'B'
			   'u1' 'u8' 'u16' 'u32' 'u64'
			   's8' 's16' 's32' 's64'
			   'f16' 'f32' 'f64'
			) includes:prefix
		    ) ifTrue:[
			tokenType := #HashTypedArrayParen.
			tokenValue := prefix asSymbol.
			^ tokenType
		    ].
		    self parseError:'unsupported literal array type: ',prefix.
		    tokenType := #HashLeftParen.
		    ^ #HashLeftParen
		].
		^ self nextSymbolAfterHash:prefix.
	    ].
	].

	(self nextSymbolAfterHash) notNil ifTrue:[
	    ^ #Symbol
	].

	(self isSpecialOrExtendedSpecialCharacter:nextChar) ifTrue:[
	    string := source next asString.
	    nextChar := source peek.
	    nextChar notNil ifTrue:[
		(self isSpecialOrExtendedSpecialCharacter:nextChar) ifTrue:[
		    source next.
		    string := string copyWith:nextChar
		]
	    ].
	    self markSymbolFrom:tokenPosition to:(source position).
	    tokenValue := token := string asSymbol.
	    tokenType := #Symbol.
	    ^ tokenType
	]
    ].

    "this allows hash to be used as binop -
     I don't know, if this is correct ..."
    tokenName := token := '#'.
    tokenType := #BinaryOperator.
    ^ tokenType

    "Modified: / 01-08-2006 / 14:57:19 / cg"
    "Modified (format): / 30-09-2011 / 12:23:04 / cg"
!

nextId
    "no longer used here - remains for backwardCompatibility for
     subclass users ... (sigh)"

    |nextChar string oldString
     index "{ Class: SmallInteger }"
     max   "{ Class: SmallInteger }" |

    nextChar := source peekOrNil.
    string := String uninitializedNew:20.
    index := 0.
    max := 10.
    [
	(nextChar notNil and:[nextChar isLetterOrDigit]) ifFalse:[
	    ^ string copyTo:index
	].
	(index == max) ifTrue:[
	    oldString := string.
	    string := String basicNew:(max * 2).
	    string replaceFrom:1 to:max with:oldString.
	    max := max * 2
	].
	index := index + 1.
	string at:index put:nextChar.
	nextChar := source nextPeek
    ] loop.

    "Modified: / 5.3.1998 / 02:53:57 / cg"
!

nextIdentifier
    "an alpha character (or underscore if AllowUnderscore) has been read.
     Return the next identifier."

    |nextChar string ok pos ch2
     allowUnderscoreInIdentifier allowDollarInIdentifier
     allowNationalCharactersInIdentifier|

    allowUnderscoreInIdentifier := parserFlags allowUnderscoreInIdentifier.
    allowDollarInIdentifier := parserFlags allowDollarInIdentifier.
    allowNationalCharactersInIdentifier := parserFlags allowNationalCharactersInIdentifier.

    hereChar == $_ ifTrue:[
	"/
	"/ no need to check for allowUnderscoreInIdentifier here;
	"/ could not arrive here if it was off
	"/
	nextChar := source nextPeek.
	parserFlags allowOldStyleAssignment ifTrue:[
	    (nextChar notNil and:[ nextChar isLetterOrDigit or:[nextChar == $_]]) ifFalse:[
		"oops: a single underscore is an old-style assignement"
		nextChar == $: ifFalse:[
		    self warnOldStyleAssignmentAt:tokenPosition.
		    tokenType := token := $_.
		    ^ tokenType
		]
	    ].
	].
	string := '_'.
	self warnUnderscoreAt:tokenPosition.
	[nextChar == $_] whileTrue:[
	    string := string copyWith:$_.
	    nextChar := source nextPeek.
	].
	(nextChar notNil and:[nextChar isLetterOrDigit]) ifTrue:[
	    string := string , source nextAlphaNumericWord.
	]
    ] ifFalse:[
	nextChar := source peekOrNil.
	(nextChar notNil and:[nextChar isLetterOrDigit]) ifTrue:[
	    string := source nextAlphaNumericWord "self nextId".
	] ifFalse:[
	    string := ''
	]
    ].
    nextChar := source peekOrNil.

    (((nextChar == $_) and:[allowUnderscoreInIdentifier])
    or:[ (allowDollarInIdentifier and:[nextChar == $$ ])
    or:[ (nextChar == $§ and:[ parserFlags allowParagraphInIdentifier])
    or:[ allowNationalCharactersInIdentifier and:[ nextChar notNil and:[nextChar isNationalLetter]]]]]) ifTrue:[
	pos := source position + 1.
	nextChar == $_ ifTrue:[
	    self warnUnderscoreAt:pos.
	] ifFalse:[
	    nextChar == $$ ifTrue:[
		self warnDollarAt:pos.
	    ] ifFalse:[
		nextChar == $§ ifTrue:[
		    self warnParagraphAt:pos.
		] ifFalse:[
		    "/ self warnNationalCharacterAt:pos.
		]
	    ]
	].
	ok := true.
	[ok] whileTrue:[
	    string := string copyWith:nextChar.
	    nextChar := source nextPeek.
	    nextChar isNil ifTrue:[
		ok := false
	    ] ifFalse:[
		(nextChar isLetterOrDigit) ifTrue:[
		    string := string , source nextAlphaNumericWord.
		    nextChar := source peekOrNil.
		].
		ok := ((nextChar == $_) and:[allowUnderscoreInIdentifier])
		      or:[((nextChar == $$ ) and:[allowDollarInIdentifier])
		      or:[((nextChar == $§ ) and:[parserFlags allowParagraphInIdentifier])
		      or:[(nextChar notNil and:[nextChar isNationalLetter]) and:[allowNationalCharactersInIdentifier]]]].
	    ]
	].
    ].

    (nextChar == $: and:[scanColonAsKeyword]) ifTrue:[
	source next.
	ch2 := source peekOrNil.
	"/ colon follows - care for '::' (nameSpace separator) or ':=' (assignment)
	(ch2 == $=) ifFalse:[
	    (ch2 == $:) ifFalse:[
		tokenName := token := string copyWith:nextChar.
		tokenType := #Keyword.
		inArrayLiteral == true ifTrue:[
		    (ch2 isLetter
		    or:[ch2 == $_ and:[allowUnderscoreInIdentifier]]) ifTrue:[
			"/ kludge: recurse to read the rest.
			self nextIdentifier.
			tokenName := token := (string copyWith:nextChar) , token.
			tokenType ~~ #Keyword ifTrue:[
			    self syntaxError:'invalid keyword symbol in array constant'
				    position:tokenPosition to:(source position).
			].
			tokenType := #Keyword.
		    ].
		].
		^ tokenType
	    ].
	    peekChar := $:.
	    peekChar2 := $:.
	] ifTrue:[
	    peekChar := $:.
	    peekChar2 := $=.
	]
    ] ifFalse:[
	(nextChar == $. and:[parserFlags allowQualifiedNames]) ifTrue:[
	    "/ period follows - if next-after character is an identifier character,
	    "/ make peekSym a #NameSpaceSeparator; otherwise a $.
	    source next.
	    ch2 := source peekOrNil.
	    (ch2 notNil
	    and:[ch2 isLetter or:[ch2 == $_ and:[allowUnderscoreInIdentifier]]]) ifTrue:[
		peekChar := #'::'.
	    ] ifFalse:[
		peekChar := $.
	    ].
	].
    ].

    nextChar == $- ifTrue:[
	pos := source position + 1.
	self
	    warnPossibleIncompatibility:'add spaces around ''-'' for compatibility with other systems'
	    position:pos to:pos.
    ].

    tokenName := token := string.
    (self checkForKeyword:string) ifFalse:[
	tokenType := #Identifier.
    ].
    ^ tokenType

    "Created: / 13-09-1995 / 12:56:42 / claus"
    "Modified: / 17-11-2016 / 09:19:46 / cg"
!

nextMantissa:radix
    "read the mantissa of a radix number"

    <resource: #obsolete>

    ^ (self nextMantissaAndScaledPartWithRadix:radix) first
!

nextMantissaAndScaledPartWithRadix:radix
    "read the mantissa of a radix number.
     Since we don't know yet if this is for a Float, LongFloat or a FixedPoint,
     return info which is useful for all: an array consisting of
     the mantissa as float/longFloat, the numerator and the scale for a fixedPoint."

    ^ Number readMantissaAndScaleFrom:source radix:radix
!

nextNumber
    "scan a number; handles radix prefix, mantissa and exponent.
     Allows for
	e, d or q to be used as exponent limiter (for float or long float),
	s for scaled fixpoint numbers,
	f for single precision floats.
     i.e. 1e5 -> float (technically a c-double precision IEEE)
	  1d5 -> float (also, a c-double precision IEEE)
	  1q5 -> long float (a c-long double)
	  1s  -> a fixed point with precision from number of digits given.
	  1s5 -> a fixed point with 5 digits precision.
	  1f5 -> shortFloat (technically a c-single precision IEEE float).
	  1f  -> shortFloat (technically a c-single precision IEEE float).
	  1d  -> shortFloat (technically a c-single precision IEEE float).
	  1q  -> shortFloat (technically a c-single precision IEEE float).
     support for scaled decimals can be disabled, if code needs to be read,
     which does not know about them (very unlikely)"

    |pos1 nextChar value integerPart sign
     expSign tokenRadix mantissaAndScaledPart d type exp scale|

    tokenRadix := 10.
    sign := 1.
    type := #Integer.
    pos1 := source position + 1.

    value := Integer readFrom:source radix:tokenRadix.
    nextChar := source peekOrNil.
    (nextChar == $r) ifTrue:[
	tokenRadix := value.
	source next.

	(tokenRadix between:2 and:36) ifFalse:[
	    self syntaxError:'bad radix (must be 2 .. 36)'
		    position:tokenPosition to:(source position).
	].
	source peekOrNil == $- ifTrue:[
	    source next.
	    sign := -1
	].
	value := Integer readFrom:source radix:tokenRadix.
	nextChar := source peekOrNil.
    ].

    (nextChar == $.) ifTrue:[
	nextChar := source nextPeek.
	(nextChar notNil and:[nextChar isDigitRadix:tokenRadix]) ifTrue:[
	    (tokenRadix > 13 and:[nextChar == $d or:[nextChar == $D]]) ifTrue:[
		self warning:'float with radix > 13 - (d/D are valid digits; not exponent-leaders)'
		    position:tokenPosition to:(source position).
	    ].
	    (tokenRadix > 14 and:[nextChar == $e or:[nextChar == $E]]) ifTrue:[
		self warning:'float with radix > 14 - (e/E are valid digits; not exponent-leaders)'
		    position:tokenPosition to:(source position).
	    ].
	    mantissaAndScaledPart := self nextMantissaAndScaledPartWithRadix:tokenRadix.
	    integerPart := value.
	    value := integerPart + (mantissaAndScaledPart first).  "could be a longFloat now"
	    type := #Float.
	    nextChar := source peekOrNil
	] ifFalse:[
	    ('eEdDqQfF' includes:nextChar) ifTrue:[
		"/ allow 5.e-3 - is this standard ?

	    ] ifFalse:[
"/                nextChar == (Character cr) ifTrue:[
"/                    lineNr := lineNr + 1.
"/                ].
		nextChar := peekChar := $..
	    ]
	]
    ].

    ('eEdDqQfF' includes:nextChar) ifTrue:[
	(nextChar == $q or:[nextChar == $Q]) ifTrue:[
	    value := value asLongFloat
	] ifFalse:[
	    false "(nextChar == $f or:[nextChar == $F])" ifTrue:[
		value := value asShortFloat
	    ] ifFalse:[
		value := value asFloat.
	    ].
	].
	type := #Float.
	nextChar := source nextPeek.
	(nextChar notNil and:[(nextChar isDigit"Radix:tokenRadix") or:['+-' includes:nextChar]]) ifTrue:[
	    expSign := 1.
	    (nextChar == $+) ifTrue:[
		nextChar := source nextPeek
	    ] ifFalse:[
		(nextChar == $-) ifTrue:[
		    nextChar := source nextPeek.
		    expSign := -1
		]
	    ].
	    exp := (Integer readFrom:source) * expSign.
	    value := value * ((value class unity * tokenRadix) raisedToInteger:exp).
	    nextChar := source peek.
	].
    ] ifFalse:[
	value isLimitedPrecisionReal ifTrue:[
	    "/ no type specified - makes it a float
	    value := value asFloat.
	].

	parserFlags allowFixedPointLiterals == true ifTrue:[
	    "/ ScaledDecimal numbers
	    ('s' includes:nextChar) ifTrue:[
		nextChar := source nextPeek.

		(nextChar notNil and:[(nextChar isDigit)]) ifTrue:[
		    scale := (Integer readFrom:source).
		].

		mantissaAndScaledPart isNil ifTrue:[
		    value := value asFixedPoint:(scale ? 0)
		] ifFalse:[
		    d := 10 raisedTo:(mantissaAndScaledPart last).
		    value := FixedPoint
			numerator:((integerPart * d) + mantissaAndScaledPart second)
			denominator:d
			scale:(scale ? mantissaAndScaledPart last).
		].
		type := #FixedPoint.
		self
		    warnPossibleIncompatibility:'fixedPoint literal might be incompatibile with other systems'
		    position:pos1 to:source position + 1.
	    ].
	].
    ].

    nextChar == $- ifTrue:[
	self
	    warnPossibleIncompatibility:'add a space before ''-'' for compatibility with other systems'
	    position:(source position + 1) to:(source position + 1).
    ].

    tokenValue := token := value * sign.
    tokenType := type.
    (tokenValue isLimitedPrecisionReal) ~~ (tokenType == #Float) ifTrue:[
	self shouldImplement.
    ].

"/    self markConstantFrom:tokenPosition to:(source position - 1).
    ^ tokenType

    "Modified: / 15-06-2017 / 11:07:52 / cg"
!

nextPrimitive
    "scan an inline C-primitive."

    |nextChar inPrimitive string stringCollector
     index "{ Class: SmallInteger }"
     len   "{ Class: SmallInteger }" |

    nextChar := source nextPeek.
    (nextChar == ${) ifFalse:[
	^ self nextSpecialWith:$%
    ].

    stringCollector := CharacterWriteStream new.
    nextChar := source nextPeek.
    inPrimitive := true.
    [inPrimitive] whileTrue:[
	[nextChar == $%] whileFalse:[
	    nextChar isNil ifTrue:[
		self syntaxError:'unterminated primitive'
			position:tokenPosition to:source position + 1.
		^ #Error
	    ].
	    stringCollector nextPut:nextChar.
	    nextChar := source next
	].
	(source peekOrNil == $}) ifTrue:[
	    inPrimitive := false
	] ifFalse:[
	    stringCollector nextPut:nextChar.
	    nextChar := source next
	]
    ].
    source next.
    tokenValue := token := stringCollector contents.
    tokenType := #Primitive.
    lineNr := lineNr + (tokenValue occurrencesOf:(Character cr)).
    ^ tokenType
!

nextSpecial
    "a special character has been read, look for another one.
     also -number is handled here"

    |firstChar|

    firstChar := source next.
    ^ self nextSpecialWith:firstChar
!

nextSpecialWith:firstChar
    "a special character has been read, look for another one.
     also -number is handled here"

    |secondChar thirdChar fourthChar string p|

    secondChar := source peekOrNil.
    ((firstChar == $-) and:[secondChar notNil]) ifTrue:[
	secondChar isDigit ifTrue:[
	    self nextNumber.
	    tokenValue := token := tokenValue negated.
	    ^ tokenType
	]
    ].
    string := firstChar asString.

    "/ changed: do not allow second char to be a hash
    "/ unless the first is also.
    secondChar == $# ifTrue:[
	(parserFlags allowHashAsBinarySelector
	and:[firstChar == $#]) ifFalse:[
	    tokenName := token := string.
	    tokenType := #BinaryOperator.
	    ^ tokenType
	].
    ].

    secondChar notNil ifTrue:[
	(secondChar == $-) ifTrue:[
	    "special- look if minus belongs to number following"
	    p := source position.
	    source next.
	    thirdChar := source peekOrNil.
	    source position:p.
	    (thirdChar notNil and:[thirdChar isDigit]) ifTrue:[
		tokenName := token := string.
		tokenType := #BinaryOperator.
		self
		    warnPossibleIncompatibility:'add a space before ''-'' for compatibility with stc and other ST systems'
		    position:p+1
		    to:p+1.
		^ tokenType
	    ]
	].
	(self isSpecialOrExtendedSpecialCharacter:secondChar) ifTrue:[
	    source next.
	    string := string copyWith:secondChar.

	    thirdChar := source peekOrNil.
	    thirdChar notNil ifTrue:[
		(self isSpecialOrExtendedSpecialCharacter:thirdChar) ifTrue:[
		    p := source position.
		    source next.
		    fourthChar := source peekOrNil.
		    source position:p.

		    (thirdChar == $-) ifTrue:[
			"special- look if minus belongs to number following"
			(fourthChar notNil and:[fourthChar isDigit]) ifTrue:[
			    tokenName := token := string.
			    tokenType := #BinaryOperator.
			    self
				warnPossibleIncompatibility:'add a space before ''-'' for compatibility with stc and other ST systems'
				position:p+1
				to:p+1.
			    ^ tokenType
			].
		    ].
		    thirdChar == $# ifTrue:[
			(fourthChar notNil and:[fourthChar isSeparator]) ifFalse:[
			    "/ in sth. like ->#foo, the binop is NOT ->#
			    tokenName := token := string.
			    tokenType := #BinaryOperator.
			    ^ tokenType
			].
		    ].
		    source next.
		    string := string copyWith:thirdChar.
		].
	    ].
	].
    ].
    tokenName := token := string.
    tokenType := #BinaryOperator.
    ^ tokenType

    "Modified: / 12-02-2017 / 11:02:51 / cg"
!

nextString:delimiter
    "a single quote has been scanned; scan the string (caring for doubled quotes"

    |nextChar string pos
     index "{ Class: SmallInteger }"
     len   "{ Class: SmallInteger }"
     inString peekChar|

    string := String uninitializedNew:20.
    len := 20.
    index := 1.
    pos := source position + 1.
    source next.
    nextChar := source next.
    inString := true.

    [inString] whileTrue:[
	nextChar isNil ifTrue:[
	    self syntaxError:'unexpected end-of-input in String'
		    position:pos to:(source position).
	    self markStringFrom:pos to:source position.
	    token := nil.
	    tokenType := #EOF.
	    ^ tokenType
	].
	(nextChar == Character cr) ifTrue:[
	    lineNr := lineNr + 1
	] ifFalse:[
	    (nextChar == delimiter) ifTrue:[
		(source peekOrNil == delimiter) ifTrue:[
		    source next
		] ifFalse:[
		    inString := false
		]
	    ] ifFalse:[
		parserFlags allowExtendedSTXSyntax == true ifTrue:[
		    (nextChar == $\) ifTrue:[
			peekChar := source peekOrNil.
			peekChar notNil ifTrue:[
			    source next.
			    nextChar := self escapeCharacterFor:peekChar.
			]
		    ]
		]
	    ].
	].
	inString ifTrue:[
	    nextChar notNil ifTrue:[
		nextChar codePoint > 255 ifTrue:[
		    string bitsPerCharacter < nextChar bitsPerCharacter ifTrue:[
			nextChar codePoint > 16rFFFF ifTrue:[
			    string := string asUnicode32String
			] ifFalse:[
			    string := string asUnicode16String.
			].
		    ].
		].
		string at:index put:nextChar.
		(index == len) ifTrue:[
		    string := string , (string species new:len).
		    len := len * 2
		].
		index := index + 1.
	    ].
	    nextChar := source next
	]
    ].

    tokenValue := token := string copyTo:(index - 1).
    tokenType := #String.
    ^ tokenType

    "Created: / 01-08-2006 / 14:56:07 / cg"
    "Modified: / 22-08-2006 / 14:10:26 / cg"
!

nextSymbolAfterHash
    "helper: a # has been read - return #Symbol token or nil"

    ^ self nextSymbolAfterHash:''
!

nextSymbolAfterHash:prefix
    "helper: #<prefix> has been read - return #Symbol token or nil"

    |nextChar string part isNameSpaceSymbol allowUnderscoreInIdentifier
     allowPeriodInSymbol|

    nextChar := source peek.
    (nextChar isNil and:[prefix isEmpty]) ifTrue:[^ nil].

    allowUnderscoreInIdentifier := parserFlags allowUnderscoreInIdentifier.
    allowPeriodInSymbol := parserFlags allowPeriodInSymbol.
    isNameSpaceSymbol := false.

    prefix isEmpty ifTrue:[
	nextChar isLetter ifFalse:[
	    ((nextChar == $_) and:[allowUnderscoreInIdentifier]) ifFalse:[
		((nextChar == $.) and:[allowPeriodInSymbol]) ifFalse:[
		    (nextChar isDigit and:[parserFlags allowSymbolsStartingWithDigit]) ifFalse:[
			"/ just for the better error message
			(nextChar isNationalAlphaNumeric) ifTrue:[
			    |errMsg|

			    errMsg := 'Invalid character: ''' , nextChar asString , ''' ', '(' , (nextChar codePoint radixPrintStringRadix:16) , ').'.
			    errMsg := errMsg , '\\Notice:\  Only 7-bit ascii allowed (for compatibility with other Smalltalk dialects).' withCRs.
			    errMsg := errMsg , '\  If you need symbols with 8-bit characters, use the #''...'' form, or ''...'' asSymbol.' withCRs.
			    self syntaxError:errMsg position:tokenPosition to:source position+1.
			].
			^ nil
		    ]
		]
	    ]
	].
    ].

    string := prefix.
    [
	nextChar notNil
	and:[nextChar isLetterOrDigit
	    or:[(nextChar == $_ and:[allowUnderscoreInIdentifier])
	    or:[nextChar == $. and:[allowPeriodInSymbol and:[source peek isLetter]]]]
	 ]
    ] whileTrue:[
	nextChar == $_ ifTrue:[
	    part := nil.
	] ifFalse:[
	    (allowPeriodInSymbol and:[nextChar == $.]) ifTrue:[
		part := nil.
	    ] ifFalse:[
		part := source nextAlphaNumericWord.
	    ]
	].
	part notNil ifTrue:[
	    string := string , part.
	].
	nextChar := source peek.

	((allowUnderscoreInIdentifier and:[nextChar == $_])
	or:[ allowPeriodInSymbol and:[nextChar == $.] ]) ifTrue:[
	    nextChar == $_ ifTrue:[
		self warnUnderscoreAt:source position + 1.
	    ] ifFalse:[
		self warnPeriodAt:source position + 1.
	    ].
	    [(nextChar == $_) or:[(allowPeriodInSymbol and:[nextChar == $.])]] whileTrue:[
		string := string copyWith:nextChar.
		nextChar := source nextPeek.
		(nextChar notNil and:[nextChar isLetterOrDigit]) ifTrue:[
		    string := string , source nextAlphaNumericWord.
		    nextChar := source peek.
		] ifFalse:[
		    (allowPeriodInSymbol and:[string last == $.]) ifTrue:[
			peekChar := nextChar.
			nextChar := $..
			string := string copyButLast:1.
			tokenValue := token := string asSymbol.
			tokenType := #Symbol.
			^ tokenType
		    ].
		].
	    ].
	].
	(nextChar == $:) ifFalse:[
	    self markSymbolFrom:tokenPosition to:(source position).
	    tokenValue := token := string asSymbol.
	    tokenType := #Symbol.
	    ^ tokenType
	].
	string := string copyWith:nextChar.
	nextChar := source nextPeek.
	parserFlags allowLiteralNameSpaceSymbols ifTrue:[
	    (nextChar == $:) ifTrue:[
		string := string copyWith:nextChar.
		nextChar := source nextPeek.
		isNameSpaceSymbol := true.
	    ].
	].
    ].
    tokenValue := token := string asSymbol.
    tokenType := #Symbol.
    ^ tokenType

    "Modified (format): / 18-06-2017 / 16:31:56 / cg"
!

nextToken
    "return the next token from the source-stream"

    |skipping actionBlock v ch tok|

    source isPositionable ifTrue:[
	tokenLastEndPosition := source position+1.
    ].

    [
	peekChar notNil ifTrue:[
	    "/ kludge - should be called peekSym.
	    "/ used when xlating Foo.Bar into Foo::Bar
	    peekChar isSymbol ifTrue:[
		token := nil.
		tokenType := peekChar.
		peekChar := nil.
		^ tokenType
	    ].

	    (peekChar isSeparator or:[ peekChar codePoint == 16rFEFF ]) ifTrue:[
		peekChar == (Character cr) ifTrue:[
		    lineNr := lineNr + 1.
		].
		hereChar := peekChar.
		peekChar := peekChar2.
		peekChar2 := nil.
		(hereChar == Character cr) ifTrue:[
		    (self eolIsWhiteSpace) ifFalse:[
			token := nil.
			tokenType := #EOL.
			^ tokenType
		    ].
		].
	    ].
	].

	peekChar notNil ifTrue:[
	    ch := peekChar.
	    peekChar := peekChar2.
	    peekChar2 := nil.
	    hereChar := nil.
	] ifFalse:[
	    skipping := true.
	    [skipping] whileTrue:[

		outStream notNil ifTrue:[
		    [
			hereChar := source peekOrNil.
			(hereChar notNil
			    and:[(hereChar == Character space) or:[hereChar isSeparator]])
		    ] whileTrue:[
			source next.
			outStream space.
			outCol := outCol + 1.
			hereChar == (Character cr) ifTrue:[
			    self eolIsWhiteSpace ifFalse:[
				source isPositionable ifTrue:[
				    tokenPosition := source position.
				].
				token := nil.
				tokenType := #EOL.
				^ tokenType
			    ].
			]
		    ]
		] ifFalse:[
		    hereChar := source skipSeparatorsExceptCR.
		].

		hereChar isNil ifTrue:[
		    skipping := false
		] ifFalse:[
		    hereChar == (Character cr) ifTrue:[
			lineNr := lineNr + 1.
			source next.
			outStream notNil ifTrue:[
			    outStream cr.
			    outCol := 1
			].
			self eolIsWhiteSpace ifFalse:[
			    source isPositionable ifTrue:[
				tokenPosition := source position.
			    ].
			    token := nil.
			    tokenType := #EOL.
			    ^ tokenType
			].
		    ] ifFalse:[
			hereChar == (Character return) ifTrue:[
			    outStream notNil ifTrue:[
				outStream nextPut:hereChar.
				outCol := 1
			    ].
			    source next.
			] ifFalse:[
			    (self isCommentCharacter:hereChar) ifTrue:[
				"start of a comment"

				self skipComment.
				hereChar := source peekOrNil.
			    ] ifFalse:[
				skipping := false
			    ]
			]
		    ]
		].
	    ].
	    hereChar isNil ifTrue:[
		source isPositionable ifTrue:[
		    tokenPosition := source position + 1.
		].
		token := nil.
		tokenType := #EOF.
		^ tokenType
	    ].
	    ch := hereChar
	].
	source isPositionable ifTrue:[
	    tokenPosition := source position + 1.
	].
	tokenLineNr := lineNr.

	(v := ch codePoint) == 0 ifTrue:[
	    v := Character space codePoint
	].
	v <= 16rFF ifTrue:[
	    actionBlock := actionArray at:v.
	] ifFalse:[
	    actionBlock := unicodeActions at:v ifAbsent:nil
	].
	actionBlock notNil ifTrue:[
	    tok := actionBlock value:self value:ch.
	    tok notNil ifTrue:[
		^ tok
	    ].
	    "/ a nil token means: continue reading
	] ifFalse:[
	    (ch isNationalLetter and:[parserFlags allowNationalCharactersInIdentifier]) ifTrue:[
		tok := self nextIdentifier.
		tok notNil ifTrue:[
		    ^ tok
		].
		"/ a nil token means: continue reading
	    ] ifFalse:[
		(ch == $§ and:[parserFlags allowParagraphInIdentifier]) ifTrue:[
		    tok := self nextIdentifier.
		    tok notNil ifTrue:[
			^ tok
		    ].
		    "/ a nil token means: continue reading
		] ifFalse:[
		    ^ self invalidCharacter:ch.
		].
	    ].
	]
    ] loop.

    "Modified: / 13-09-1995 / 12:56:14 / claus"
    "Modified: / 27-07-2011 / 15:36:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2017 / 11:27:59 / cg"
!

nextToken:aCharacter
    "return a character token"

    tokenType := token := aCharacter.
    hereChar notNil ifTrue:[source next].
    ^ tokenType

    "Modified: / 13.5.1998 / 15:10:23 / cg"
!

nextUnderline
    "return either an identifier, or an underline (sometimes an assignment)  token"

    parserFlags allowUnderscoreInIdentifier ifTrue:[
	^ self nextIdentifier
    ].
    ^ self nextToken:$_
!

skipComment
    "skip over a comment;
     handles ST/X eol comments (quote-slash)
     and multiline-delimiter comment (quote-less-less).
     Multiline-delimiter comments start with ''<<TOKEN and end in a line which starts with TOKEN (quote-quote being a double quote here)"

    |commentStream commentType commentText startPos endPos stillInComment anyNonBlank
     delimiter line|

    anyNonBlank := false.

    saveComments ifTrue:[
        commentStream := CharacterWriteStream on:''.
        self beginComment.
    ].

    outStream notNil ifTrue:[
        outStream nextPut:Character doubleQuote.
        outCol := outCol + 1
    ].

    startPos := source position + 1.
    source next.
    hereChar := source peekOrNil.
    commentType := #regularComment.

    "
     special ST/X addition:
     a $/ right after the initial double quote makes it an up-to-end-of-line comment,
     which is very useful to comment out parts of filed-in source code.
     Since this is non-standard, you loose compatibility with other Smalltalks, if you use it.
     (however, it is so convenient - I don't want to miss it)
    "
    (hereChar == $/ and:[parserFlags allowSTXEOLComments]) ifTrue:[
        hereChar := source nextPeek.

        self skipToEndOfLineRememberingIn:commentStream.
        endPos := source position.
        self markCommentFrom:startPos to:endPos+1.
        commentType := #eolComment.
        self warnSTXSpecialCommentAt:startPos to:endPos.
        outStream notNil ifTrue:[
            outStream cr.
            outCol := 1
        ].
        "skip cr"
        source next.
    ] ifFalse:[
        (hereChar == $< and:[parserFlags allowSTXDelimiterComments]) ifTrue:[
            hereChar := source nextPeek.
            (hereChar == $<) ifTrue:[
                "
                 another special ST/X addition:
                 a << right after the initial double quote makes it a token delimited comment,
                 which continues up to a line starting with the token.
                 This is very useful to comment out which contain any other type of comment.
                 Since this is non-standard, you loose compatibility with other Smalltalks, if you use it.
                "
                commentStream notNil ifTrue:[
                    commentStream nextPutAll:'<<'
                ].
                hereChar := source nextPeek.

                delimiter := String streamContents:[:s | self skipToEndOfLineRememberingIn:s].
                delimiter := delimiter withoutSeparators.
                delimiter isEmpty ifTrue:[
                    self parseError:'invalid delimiter in comment'.
                    ^  self
                ].
                ((delimiter first isLetterOrUnderline)
                and:[delimiter from:2 conform:[:ch | ch isLetterOrDigit]]) ifFalse:[
                    "/ treat as regular comment
                    commentType := #regularComment.
                    source position:startPos.
                ] ifTrue:[
                    "/ delimiter comment
                    hereChar == Character cr ifTrue:[
                        hereChar := source nextPeek.
                    ].
                    commentStream notNil ifTrue:[
                        commentStream nextPutLine:delimiter
                    ].
                    stillInComment := true.
                    [stillInComment and:[hereChar notNil]] whileTrue:[
                        line := String streamContents:[:s | self skipToEndOfLineRememberingIn:s].
                        commentStream notNil ifTrue:[
                            commentStream nextPutLine:line
                        ].
                        hereChar == Character cr ifTrue:[
                            hereChar := source nextPeek.
                        ].
                        stillInComment := (line startsWith:delimiter) not.
                    ].
                    stillInComment ifTrue:[
                        self markCommentFrom:startPos to:(source collectionSize).
                        self warning:'unclosed comment (missing delimiter: "',delimiter,'")' position:startPos to:(source position + 1)
                    ].
                    self markCommentFrom:startPos to:(source position + 1).
                    commentType := #delimiterComment.
                ]
            ] ifFalse:[
                commentStream notNil ifTrue:[
                    commentStream nextPut:$<
                ].
            ].
        ].

        (commentType == #regularComment) ifTrue:[
            hereChar == ${ ifTrue:[
                "
                 special ST/X addition:
                 a ${ right after the initial double quote starts a directive
                "
                self parseDirective
            ].

            stillInComment := true.
            [stillInComment] whileTrue:[
                stillInComment := false.

                [hereChar notNil and:[hereChar ~~ (Character doubleQuote)]] whileTrue:[
                    hereChar isSeparator ifFalse:[ anyNonBlank := true ].
                    hereChar == (Character cr) ifTrue:[
                        lineNr := lineNr + 1.
                    ].
                    commentStream notNil ifTrue:[
                        commentStream nextPut:hereChar
                    ].
                    outStream notNil ifTrue:[
                        outStream nextPut:hereChar.
                        outCol := outCol + 1
                    ].
                    hereChar := source nextPeek
                ].

                hereChar isNil ifTrue:[
                    self markCommentFrom:startPos to:(source collectionSize).
                    self warning:'unclosed comment' position:startPos to:(source position + 1)
                ] ifFalse:[
                    self markCommentFrom:startPos to:(source position + 1).
                    outStream notNil ifTrue:[
                        outStream nextPut:(Character doubleQuote).
                        outCol := outCol + 1
                    ].
                ].
                endPos := source position.
                "skip final dQuote"
                source next.

                (source peek == Character doubleQuote) ifTrue:[
                    stillInComment := true.
                    hereChar := source nextPeek.
                ].
            ].
        ]
    ].

    saveComments ifTrue:[
        commentText := commentStream contents.
        self endComment:commentText type:commentType start:startPos end:endPos.
    ].

    ignoreWarnings ifFalse:[
        parserFlags warnAboutBadComments ifTrue:[
            anyNonBlank ifFalse:[
                commentType == #regularComment ifTrue:[
                    self isDoIt ifFalse:[
                        self
                            warning:'empty comment'
                            doNotShowAgainAction:[ ParserFlags warnAboutBadComments: false ]
                            position:startPos to:endPos+1.
                        parserFlags warnAboutBadComments:false.
                    ]
                ].
            ].
        ].
    ].

    "Modified: / 30-08-2017 / 09:58:02 / cg"
!

skipToEndOfLineRememberingIn:commentStreamOrNil
    [hereChar notNil and:[hereChar ~~ Character cr]] whileTrue:[
	commentStreamOrNil notNil ifTrue:[
	    commentStreamOrNil nextPut:hereChar
	].
	outStream notNil ifTrue:[
	    outStream nextPut:hereChar.
	    outCol := outCol + 1
	].
	hereChar := source nextPeek.
    ].
    lineNr := lineNr + 1.
! !

!Scanner::Comment methodsFor:'accessing'!

commentString
    "return the value of the instance variable 'commentString' (automatically generated)"

    ^ commentString

    "Created: / 17.2.1998 / 14:44:33 / cg"
!

commentString:something
    "set the value of the instance variable 'commentString' (automatically generated)"

    commentString := something.

    "Created: / 17.2.1998 / 14:44:33 / cg"
!

commentString:commentStringArg commentType:commentTypeArg
    commentString := commentStringArg.
    commentType := commentTypeArg.

    "Created: / 17.2.1998 / 14:44:33 / cg"
!

commentType
    ^ commentType

    "Created: / 17.2.1998 / 14:44:33 / cg"
!

commentType:something
    commentType := something.

    "Created: / 17.2.1998 / 14:44:33 / cg"
!

endPosition
    ^ endPosition
!

endPosition:something
    endPosition := something.
!

startPosition
    ^ startPosition
!

startPosition:something
    startPosition := something.
!

startPosition:startPositionArg endPosition:endPositionArg
    startPosition := startPositionArg.
    endPosition := endPositionArg.
!

string
    ^ commentString

    "Created: / 17.2.1998 / 14:49:52 / cg"
! !

!Scanner::Comment methodsFor:'converting'!

asString
    ^ commentString.
!

asStringCollection
    ^ commentString asStringCollection.
! !

!Scanner::Comment methodsFor:'queries'!

isEndOfLineComment
    ^ commentType == #eolComment
! !

!Scanner::Directive class methodsFor:'instance creation'!

newClassDirective
    ^ ClassDirective new
!

newClassHintDirective
    ^ ClassHintDirective new
! !

!Scanner::Directive methodsFor:'queries'!

isClassHintDirective
    ^ false
! !

!Scanner::Directive::ClassDirective methodsFor:'accessing'!

className
    ^ className
!

className:something
    className := something.
! !

!Scanner::Directive::ClassHintDirective methodsFor:'queries'!

isClassHintDirective
    ^ true
! !

!Scanner class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Scanner initialize!
