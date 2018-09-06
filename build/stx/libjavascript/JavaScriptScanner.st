"
 COPYRIGHT (c) 1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

Scanner subclass:#JavaScriptScanner
	instanceVariableNames:'allowDegeneratedMantissa'
	classVariableNames:'Verbose'
	poolDictionaries:''
	category:'Languages-JavaScript-Compiling & Parsing'
!

!JavaScriptScanner class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

examples
"
    |s in|

    in := '
function scalefactor(value) {
    scalevector[0]=value;
    scalevector[1]=1.;
    scalevector[2]=1.;
}
'.

    s := JavaScriptScanner for:in readStream.
    s nextToken  


    |s in|

    in := '
function scalefactor(value) {
    scalevector[0]=value;
    scalevector[1]=1.;
    scalevector[2]=1.;
}
'.
    s := JavaScriptScanner new.
    s scanTokens:(in readStream).
"

    "Created: / 13.5.1998 / 14:54:06 / cg"
! !

!JavaScriptScanner class methodsFor:'initialization'!

setupActions
    "initialize the scanners actionTables - these are used to dispatch
     into scanner methods as characters are read"

    |block|

    ActionArray := Array new:256.
    TypeArray := Array new:256.

    block := [:s :char | s nextNumber].
    ActionArray from:($0 codePoint) to:($9 codePoint) put:block.

    block := [:s :char | s nextToken:char].
    #( $: $; $. $, ${ $} $( $) $[ $] $_ $? $~) do:[:ch |
        ActionArray at:(ch codePoint) put:block
    ].

    block := [:s :char | s nextIdentifier].
    ActionArray from:($a codePoint) to:($z codePoint) put:block.
    ActionArray from:($A codePoint) to:($Z codePoint) put:block.
    ActionArray at:$_ codePoint put:block.

    ActionArray at:($' codePoint) put:[:s :char | s nextString ].
    ActionArray at:($" codePoint) put:[:s :char | s nextString ].
    ActionArray at:($!! codePoint) put:[:s :char | s nextMulti:#(($= #'!!=' (($= #'!!==')))) after:char].
    ActionArray at:($= codePoint) put:[:s :char | s nextMulti:#(($> #'=>') ($= #'==' (($= #'===')))) after:char].
    ActionArray at:($< codePoint) put:[:s :char | s nextMulti:#(($= #'<=') ($< #'<<' (($= #'<<=')))) after:char].
    ActionArray at:($> codePoint) put:[:s :char | s nextMulti:#(($= #'>=') ($> #'>>' (($> #'>>>') ($= #'>>=') ))) after:char].

    ActionArray at:($- codePoint) put:[:s :char | s nextMulti:#(($- #'--') ($= #'-=')) after:char].
    ActionArray at:($+ codePoint) put:[:s :char | s nextMulti:#(($+ #'++') ($= #'+=')) after:char].
    ActionArray at:($: codePoint) put:[:s :char | s nextMulti:#(($: #'::')) after:char].
    ActionArray at:($* codePoint) put:[:s :char | s nextMulti:#(($= #'*=') ($* #'**')) after:char].
    ActionArray at:($/ codePoint) put:[:s :char | s nextMulti:#(($= #'/=') ($* nil #skipComment) ($/ nil #skipEOLComment)) after:char].
    ActionArray at:($% codePoint) put:[:s :char | s nextMulti:#(($= #'%=')) after:char].
    ActionArray at:($& codePoint) put:[:s :char | s nextMulti:#(($= #'&=') ($& #'&&')) after:char].
    ActionArray at:($^ codePoint) put:[:s :char | s nextMulti:#(($= #'^=')) after:char].
    ActionArray at:($| codePoint) put:[:s :char | s nextMulti:#(($= #'|=') ($| #'||')) after:char].
    ActionArray at:($$ codePoint) put:[:s :char | s nextCharacter ].

    "
     JavaScriptScanner setupActions
    "

    "Created: / 14-05-1998 / 15:48:03 / cg"
    "Modified: / 17-05-1998 / 21:03:37 / cg"
    "Modified: / 27-08-2018 / 15:28:14 / Claus Gittinger"
! !

!JavaScriptScanner methodsFor:'accessing'!

tokenType
    ^ tokenType
! !

!JavaScriptScanner methodsFor:'initialization'!

initialize
    "initialize the scanner"

    super initialize.

    "/ have my own tables ...

    self allowUnderscoreInIdentifier:true.
    self allowDollarInIdentifier:false.
    self allowOldStyleAssignment:false.
    parserFlags allowNationalCharactersInIdentifier:false.
    parserFlags allowQualifiedNames:false.

    allowDegeneratedMantissa := true.     "/ something like 123.
    scanColonAsKeyword := false.

    actionArray := self class actionArray.
    typeArray := self class typeArray.

    "Created: / 14.5.1998 / 15:48:04 / cg"
    "Modified: / 26.10.1998 / 14:50:26 / cg"
! !

!JavaScriptScanner methodsFor:'private'!

checkForKeyword:string
    "check if string is a keyword (as opposed to an identifier)."

    |firstChar|

    firstChar := string at:1.
    (firstChar == $b) ifTrue:[
        (string = 'break') ifTrue:[tokenType := #break. ^true].
        ^ false
    ].
    (firstChar == $c) ifTrue:[
        (string = 'continue') ifTrue:[tokenType := #continue. ^true].
        (string = 'case') ifTrue:[tokenType := #case. ^true].
        (string = 'catch') ifTrue:[tokenType := #catch. ^true].
        (string = 'const') ifTrue:[
            parserFlags allowJavaScriptConst ifTrue:[
                tokenType := #const. ^true
            ].
        ].
        ^ false
    ].
    (firstChar == $d) ifTrue:[
        (string = 'default') ifTrue:[tokenType := #default. ^true].
        "/ do is not a keyword - it is also allowed as identifier
        ^ false
    ].
    (firstChar == $e) ifTrue:[
        (string = 'else') ifTrue:[tokenType := #else. ^true].
        ^ false
    ].
    (firstChar == $f) ifTrue:[
        (string = 'function') ifTrue:[tokenType := #function. ^true].
        (string = 'for') ifTrue:[tokenType := #for. ^true].
"/        (string = 'foreach') ifTrue:[tokenType := #foreach. ^true].
        (string = 'false') ifTrue:[tokenType := #false. tokenValue := false. ^true].
        (string = 'finally') ifTrue:[tokenType := #finally. tokenValue := false. ^true].
        ^ false
    ].
    (firstChar == $i) ifTrue:[
        (string = 'if') ifTrue:[tokenType := #if. ^true].
        ^ false
    ].
    (firstChar == $l) ifTrue:[
        (string = 'let') ifTrue:[tokenType := #let. ^true].
        ^ false
    ].
    (firstChar == $n) ifTrue:[
        (string = 'null') ifTrue:[tokenType := #null. tokenValue := nil. ^true].
        (string = 'nil') ifTrue:[tokenType := #null. tokenValue := nil. ^true].
        ^ false
    ].
    (firstChar == $r) ifTrue:[
        (string = 'return') ifTrue:[tokenType := #return. ^true].
        ^ false
    ].
    (firstChar == $s) ifTrue:[
        "/ (string = 'static') ifTrue:[tokenType := #static. ^true]. - handled as identifier
        "/ (string = 'synchronized') ifTrue:[tokenType := #synchronized. ^true].
        "/ (string = 'short') ifTrue:[tokenType := #short. ^true].
        (string = 'super') ifTrue:[tokenType := #super. ^true].
        (string = 'switch') ifTrue:[tokenType := #switch. ^true].
        ^ false
    ].
    (firstChar == $t) ifTrue:[
        (string = 'this') ifTrue:[tokenType := #this. ^true].
        (string = 'try') ifTrue:[tokenType := #try. ^true].
        (string = 'true') ifTrue:[tokenType := #true. tokenValue := true. ^true].
        (string = 'throw') ifTrue:[tokenType := #throw. ^true].
        "/ (string = 'transient') ifTrue:[tokenType := #transient. ^true].
        "/ (string = 'throws') ifTrue:[tokenType := #throws. ^true].
        (string = 'typeof') ifTrue:[tokenType := #typeof. ^true].
        ^ false
    ].
    (firstChar == $u) ifTrue:[
        (string = 'undefined') ifTrue:[tokenType := #null. tokenValue := nil. ^true].
        ^ false
    ].
    (firstChar == $v) ifTrue:[
        (string = 'var') ifTrue:[tokenType := #var. ^true].
        (string = 'void') ifTrue:[tokenType := #void. tokenValue := Void. ^true]. "/ - handled as identifier
        "/ (string = 'volatile') ifTrue:[tokenType := #volatile. ^true].
        ^ false
    ].
    (firstChar == $w) ifTrue:[
        (string = 'with') ifTrue:[tokenType := #with. ^true].
        (string = 'while') ifTrue:[tokenType := #while. ^true].
        ^ false
    ].
    ^ false

    "Created: / 14-05-1998 / 15:48:04 / cg"
    "Modified: / 09-08-2017 / 00:03:56 / cg"
    "Modified: / 31-08-2018 / 12:55:31 / Claus Gittinger"
!

handleCategoryDirective:categoryString
    "called when encountering a /** category: xxxx **/ comment;
     categoryString will be xxxx.
     Can be redefined in subclasses"

    "Created: / 26-10-2011 / 17:47:28 / cg"
!

handleCommentDirectivesIn:commentText
    "/ called for the text after the initial "/*"

    |plainText|

    (commentText endsWith:'**/') ifFalse:[^ self].
    (commentText startsWith:'* ') ifFalse:[^ self].

    plainText := commentText copyButLast:3.
    plainText := plainText copyFrom:3.

    (plainText startsWith:'category: ') ifTrue:[
        self handleCategoryDirective:(plainText copyFrom:'category: ' size+1) withoutSeparators.
        ^ self.
    ].

    "Created: / 26-10-2011 / 17:39:35 / cg"
!

isCommentCharacter:ch
    "return true, if ch is the comment-start character"

    ^ false

    "Created: / 14.5.1998 / 20:53:33 / cg"
! !

!JavaScriptScanner methodsFor:'reading next token'!

hex2CharacterEscape
    |x1 x2|

    x1 := source next.
    x2 := source next.

    (x1 isNil or:[x2 isNil]) ifTrue:[
        self syntaxError:'unexpected end-of-input in String'
                position:tokenPosition to:(source position - 1).
        self markStringFrom:tokenPosition to:source position-1.
        ^ nil.
    ].
    ((x1 isDigitRadix:16) and:[(x2 isDigitRadix:16)]) ifFalse:[
        self syntaxError:'invalid hex-character escape'
                position:tokenPosition to:(source position - 1).
        ^ Character value:0
    ].
    ^ Character value:((x1 digitValue * 16) + (x2 digitValue))

    "Modified: / 26-10-2011 / 17:15:49 / cg"
!

hex4CharacterEscape
    |x1 x2 x3 x4|

    x1 := source next.
    x2 := source next.
    x3 := source next.
    x4 := source next.

    (x1 isNil or:[x2 isNil or:[x3 isNil or:[x4 isNil]]]) ifTrue:[
        self syntaxError:'unexpected end-of-input in String'
                position:tokenPosition to:(source position - 1).
        self markStringFrom:tokenPosition to:source position-1.
        ^ nil.
    ].
    ((x1 isDigitRadix:16) 
    and:[(x2 isDigitRadix:16)
    and:[(x3 isDigitRadix:16)
    and:[(x4 isDigitRadix:16)]]]) ifFalse:[
        self syntaxError:'invalid hex-character escape'
                position:tokenPosition to:(source position - 1).
        ^ Character value:0
    ].
    ^ Character value:(((((x1 digitValue * 16) + (x2 digitValue)) * 16) + (x3 digitValue)) * 16) + (x4 digitValue).

    "Modified: / 26-10-2011 / 17:15:45 / cg"
!

nextCharacter
    |pos|

    pos := tokenPosition.
    source next.

    (hereChar := source peek) == $' ifTrue:[
        ^ self nextStringOrCharacter:true
    ].

    self syntaxError:'incorrect Character Constant'
            position:pos to:(source position).
!

nextMulti:list after:firstChar
    "a char has been read - peek ahead in list"

    |pc|

    peekChar isNil ifTrue:[
        source next.
    ] ifFalse:[
        peekChar := nil.
    ].
    pc := source peek.

    list do:[:spec |
        |ch tok idx chOrSelectorOrSpec|

        ch := spec at:1.

        pc == ch ifTrue:[
            tok := spec at:2.
            idx := 3.

            peekChar isNil ifTrue:[
                source next.
            ] ifFalse:[
                peekChar := nil.
            ].

            spec size > 2 ifTrue:[
                "/ continue
                chOrSelectorOrSpec := (spec at:3).
                chOrSelectorOrSpec isArray ifTrue:[
                    peekChar := source peek.
                    ^ self nextMulti:chOrSelectorOrSpec after:tok.
                ].
                source peek == chOrSelectorOrSpec ifTrue:[
                    source next.
                    tok := spec at:4.
                    idx := 5.
                ]
            ].

            tok isNil ifTrue:[
                ^ self perform:(spec at:idx).
            ].

            tokenType := token := tok.
            ^ tokenType
        ]
    ].

    tokenType := token := firstChar.
    ^ tokenType

    "Created: / 14.5.1998 / 19:19:34 / cg"
    "Modified: / 16.5.1998 / 19:09:59 / cg"
!

nextNumber
    |nextChar value s|

    value := 0.
    nextChar := source peekOrNil.
    nextChar == $0 ifTrue:[
        source next.
        nextChar := source peekOrNil.
        nextChar isNil ifTrue:[
            tokenValue := token := value.
            tokenType := #Integer.
            ^ tokenType
        ].
        (nextChar == $x or:[nextChar == $X]) ifTrue:[
            source next.
            value := Integer readFrom:source radix:16.

            tokenValue := token := value.
            tokenType := #Integer.
            ^ tokenType
        ].
        (nextChar == $b or:[nextChar == $b]) ifTrue:[
            source next.
            value := Integer readFrom:source radix:2.

            tokenValue := token := value.
            tokenType := #Integer.
            ^ tokenType
        ].
        (nextChar between:$0 and:$7) ifTrue:[
            value := Integer readFrom:source radix:8.
            tokenValue := token := value.
            tokenType := #Integer.
            ^ tokenType
        ].
    ].

    nextChar isDigit ifTrue:[
        value := Integer readFrom:source radix:10.
        nextChar := source peekOrNil.
    ].

    (nextChar == $.) ifTrue:[
        nextChar := source nextPeek.
        (nextChar notNil and:[nextChar isDigitRadix:10]) ifTrue:[
            value := value asFloat + (self nextMantissaAndScaledPartWithRadix:10) first.
            nextChar := source peekOrNil
        ] ifFalse:[
            allowDegeneratedMantissa == true ifTrue:[
                (nextChar notNil and:[nextChar isSeparator]) ifTrue:[
                    self warning:'degenerated float constant: ' , value printString , '.' .
                    tokenValue := token := value asFloat.
                    tokenType := #Float.
                    ^ tokenType
                ].
            ].

"/            nextChar == (Character cr) ifTrue:[
"/                lineNr := lineNr + 1.
"/            ].
            nextChar := peekChar := $..
        ]
    ].
    ((nextChar == $e) or:[nextChar == $E]) ifTrue:[
        nextChar := source nextPeek.
        (nextChar notNil and:[(nextChar isDigitRadix:10) or:['+-' includes:nextChar]]) ifTrue:[
            s := 1.
            (nextChar == $+) ifTrue:[
                nextChar := source nextPeek
            ] ifFalse:[
                (nextChar == $-) ifTrue:[
                    nextChar := source nextPeek.
                    s := s negated
                ]
            ].
            value := value asFloat
                     * (10.0 raisedToInteger:((Integer readFrom:source radix:10) * s))
        ]
    ].
    nextChar == $- ifTrue:[
        self
            warnPossibleIncompatibility:'add a space before ''-'' for compatibility with other systems'
            position:(source position) to:(source position).
    ].

    tokenValue := token := value.
    (value isLimitedPrecisionReal) ifTrue:[
        (nextChar == $d) ifTrue:[
            source next
        ].
        tokenType := #Float
    ] ifFalse:[
        tokenType := #Integer
    ].
"/    self markConstantFrom:tokenPosition to:(source position - 1).
    ^ tokenType

    "Created: / 14.5.1998 / 20:00:25 / cg"
    "Modified: / 16.5.1998 / 15:51:46 / cg"
!

nextString
    ^ self nextStringOrCharacter:false
!

nextStringOrCharacter:asCharacter
    |delimiter s pos endPos nextChar inString badEscapeChar|

    delimiter := hereChar.

    s := (String new:20) writeStream.

    pos := tokenPosition.
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
        
        nextChar == $\ ifTrue:[
            nextChar := source next.
            nextChar == $b ifTrue:[
                nextChar := Character backspace
            ] ifFalse:[ nextChar == $t ifTrue:[
                nextChar := Character tab
            ] ifFalse:[ nextChar == $n ifTrue:[
                nextChar := Character cr
            ] ifFalse:[ nextChar == $r ifTrue:[
                nextChar := Character return
            ] ifFalse:[ nextChar == $f ifTrue:[
                nextChar := Character newPage
            ] ifFalse:[ nextChar == $x ifTrue:[
                nextChar := self hex2CharacterEscape.
                nextChar isNil ifTrue:[
                    token := nil.
                    tokenType := #EOF.
                    ^ tokenType
                ].
            ] ifFalse:[ nextChar == $u ifTrue:[
                nextChar := self hex4CharacterEscape.
                nextChar isNil ifTrue:[
                    token := nil.
                    tokenType := #EOF.
                    ^ tokenType
                ].
            ] ifFalse:[ nextChar == Character cr ifTrue:[
                nextChar := nil
            ] ifFalse:[
                ((nextChar == $') or:[nextChar == $" or:[nextChar == $\]]) ifFalse:[         
                    parserFlags warnAboutUnknownCharacterEscapesInJavaScriptStringConstant ifTrue:[
                        badEscapeChar isNil ifTrue:[ badEscapeChar := nextChar asString ]
                    ].
                ]
            ]]]]]]]]
        ] ifFalse:[
            (nextChar == Character cr) ifTrue:[
                lineNr := lineNr + 1
            ] ifFalse:[
                (nextChar == delimiter) ifTrue:[
                    (source peekOrNil == delimiter) ifTrue:[
                        source next
                    ] ifFalse:[
                        inString := false
                    ]
                ].
            ].
        ].
        inString ifTrue:[
            nextChar notNil ifTrue:[
                nextChar bitsPerCharacter > s contents bitsPerCharacter ifTrue:[
                    s setCollection:(nextChar stringSpecies fromString:s collection).
                ].
                s nextPut:nextChar.
            ].    
            nextChar := source next
        ]
    ].
    endPos := source position.
    self markStringFrom:pos to:endPos.
    badEscapeChar notNil ifTrue:[
        self warning:('Unknown character escape: "\',badEscapeChar asString,'"') position:pos to:endPos.
    ].

    tokenValue := token := s contents.
    tokenType := #String.

    asCharacter ifTrue:[
        token size ~~ 1 ifTrue:[
            self syntaxError:'Character constant must be of size 1' position:pos to:endPos.
        ].
        tokenType := #Character.
        tokenValue := token := token first
    ].

    ^ tokenType

    "Created: / 16-05-1998 / 19:53:05 / cg"
    "Modified: / 04-10-2011 / 20:08:58 / cg"
    "Modified: / 27-08-2018 / 15:23:08 / Claus Gittinger"
!

nextToken
    |t|

    [
        t := super nextToken.
        t isNil
    ] whileTrue.
    Verbose == true ifTrue:[Transcript showCR:t].
    ^ t

    "
     Verbose := true
    "

    "Created: / 14.5.1998 / 15:48:04 / cg"
    "Modified: / 16.5.1998 / 19:12:29 / cg"
!

skipComment
    "/* has already been read"

    |nextChar startPos commentStream commentText|

    startPos := source position-1.

    commentStream := CharacterWriteStream new:30.

    hereChar := source peek.
    [true] whileTrue:[
        hereChar isNil ifTrue:[
            "/ EOF in comment ?!!?
            commentText := commentStream contents.
            self handleCommentDirectivesIn:commentText.
            saveComments ifTrue:[
                self endComment:commentText type:#regularComment.
            ].
            ^ nil
        ].
        commentStream notNil ifTrue:[ commentStream nextPut:hereChar ].

        hereChar == $* ifTrue:[
            outStream notNil ifTrue:[
                outStream nextPut:hereChar.
                outCol := outCol + 1
            ].
            hereChar := source nextPeek.
            hereChar == $/ ifTrue:[
                commentStream notNil ifTrue:[ commentStream nextPut:hereChar ].
                self markCommentFrom:startPos to:(source position).
                hereChar := source nextPeek.
                commentText := commentStream contents.
                self handleCommentDirectivesIn:commentText.
                saveComments ifTrue:[
                    self endComment:commentText type:#regularComment.
                ].
                ^ nil
            ].
            nextChar := hereChar.
        ] ifFalse:[
            hereChar == Character cr ifTrue:[
                lineNr := lineNr + 1.
            ].
            nextChar := source nextPeek.
        ].

        outStream notNil ifTrue:[
            outStream nextPut:hereChar.
            outCol := outCol + 1
        ].
        hereChar := nextChar.
    ].

    "Modified: / 26-10-2011 / 17:42:14 / cg"
!

skipEOLComment
    "// has already been read"

    |startPos commentStream commentText|

    startPos := source position-1.

    commentStream := CharacterWriteStream new:30.
    commentStream nextPutAll:'//'.

    hereChar := source peek.
    [hereChar notNil and:[hereChar ~~ Character cr]] whileTrue:[
        commentStream notNil ifTrue:[
            commentStream nextPut:hereChar
        ].
        outStream notNil ifTrue:[
            outStream nextPut:hereChar.
            outCol := outCol + 1
        ].
        hereChar := source nextPeek.
    ].
    self markCommentFrom:startPos to:(source position).
    hereChar := source nextPeek.
    lineNr := lineNr + 1.
    outStream notNil ifTrue:[
        outStream cr.
        outCol := 1
    ].
    commentText := commentStream contents.
    "/ self handleCommentDirectivesIn:commentText.
    saveComments ifTrue:[
        self endComment:commentText type:#eolComment.
    ].
    ^ nil.

    "Created: / 16-05-1998 / 19:11:05 / cg"
    "Modified: / 26-10-2011 / 17:43:46 / cg"
! !

!JavaScriptScanner class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptScanner.st,v 1.59 2018-08-31 10:56:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptScanner.st,v 1.59 2018-08-31 10:56:00 cg Exp $'
! !

