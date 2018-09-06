"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

JavaAbstractLexicalHighlighter subclass:#JavaLexicalHighlighter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Source'
!

JavaScanner subclass:#HighlightingScanner
	instanceVariableNames:'buffer bufferFirst bufferLast highlighter'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaLexicalHighlighter
!

!JavaLexicalHighlighter class methodsFor:'formatting'!

formatClassDefinition: code line: line number: lineNr in: cls

    ^self new formatClassDefinition: code line: line number: lineNr in: cls

    "Created: / 12-08-2014 / 13:35:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLexicalHighlighter methodsFor:'accessing-classes'!

scannerClass
    "Return a highlighting scanner class to use"

    ^ HighlightingScanner

    "Created: / 25-06-2014 / 11:57:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLexicalHighlighter methodsFor:'formatting'!

formatClassDefinition: code line: line number: lineNr in: cls
    | scanner |    

    line isEmptyOrNil ifTrue:[ ^  nil ].

    sourceText := line asText.    
    "/ The `...codeViewThene ? UserPreferences current` trick below is 
    "/ there to make this code working with both old and editor-thene-aware 
    "/ code. Will wanish as soon as editor thene support will be
    "/ integrated.
    preferences := UserPreferences current codeViewTheme ? UserPreferences current.     
    scanner := self scannerClass for: line asString.
    scanner highlighter: self.
    [
        [ scanner nextToken ~~ #EOF ] whileTrue.
    ] on: Error do:[

    ].
    ^ sourceText

    "Created: / 12-08-2014 / 13:36:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2017 / 21:18:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLexicalHighlighter::HighlightingScanner methodsFor:'accessing'!

highlighter
    ^ highlighter
!

highlighter:aJavaSyntaxHighlighter
    highlighter := aJavaSyntaxHighlighter.
! !

!JavaLexicalHighlighter::HighlightingScanner methodsFor:'error handling'!

syntaxError:aMessage position:position to:endPos
    "a syntax error happened"

    endPos notNil ifTrue:[
        highlighter markBadIdentifierFrom:position to: endPos.
    ]

    "Created: / 13-04-2012 / 18:31:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLexicalHighlighter::HighlightingScanner methodsFor:'initialization'!

initialize
    "initialize the scanner"

    super initialize.
    saveComments := true.
    buffer := Array new: 3.
    bufferFirst := 1.
    bufferLast := 0.

    "Created: / 17-03-2012 / 00:02:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2013 / 18:51:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLexicalHighlighter::HighlightingScanner methodsFor:'private'!

checkForKeyword:string
    | isKW |

    isKW := super checkForKeyword:string.
    isKW ifTrue:[
        highlighter markKeyword:string from:tokenStartPosition + 1 to:tokenStartPosition + string size
    ].
    ^isKW

    "Created: / 17-03-2012 / 00:15:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLexicalHighlighter::HighlightingScanner methodsFor:'reading next token'!

nextToken
    | t |

    t := super nextToken.
    t == #String ifTrue:[
        highlighter markStringFrom:tokenStartPosition + 1 to: tokenEndPosition + 1.  
    ] ifFalse:[
    t == #Integer ifTrue:[
        highlighter markConstantFrom:tokenStartPosition + 1 to: tokenEndPosition + 1.
    ]].
"/    bufferLast := (bufferLast \\ buffer size) + 1.
"/    bufferLast == bufferFirst ifTrue:[
"/        bufferFirst := (bufferFirst \\ buffer size) + 1.
"/    ].
"/    buffer at: bufferLast put: self token.
"/    "/ Now, do a quick check for some common token sequences...not a full parsing,
"/    "/ but helps a bit
"/    ((bufferLast - bufferFirst) \\ 10) > 2 ifTrue:[
"/        "/ Quick check for method call sequence...
"/        t == $( ifTrue:[
"/
"/            ((buffer at:(bufferLast - 1) \\ buffer size) type == #Identifier
"/                and:[(buffer at:(bufferLast - 2) \\ buffer size) type == $.
"/                and:[(buffer at:(bufferLast - 1) \\ buffer size) value first isLowercase]])
"/                ifTrue:[
"/                    | nameToken |
"/    
"/                    nameToken := (buffer at:(bufferLast - 1) \\ buffer size).
"/                    highlighter markSelector: nameToken value from: nameToken startPosition to: nameToken endPosition.
"/                    ^ t
"/                ].
"/        ].
"/        "/ Add more patterns here
"/    ].

    ^ t

    "Created: / 14-05-1998 / 15:48:04 / cg"
    "Modified: / 16-05-1998 / 19:12:29 / cg"
    "Created: / 17-03-2012 / 19:15:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-10-2013 / 20:25:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipComment
    super skipComment.
    highlighter markCommentFrom:((tokenStartPosition + 1) max: 1) to: source position.
    ^nil

    "Created: / 17-03-2012 / 00:04:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipEOLComment
    super skipEOLComment.
    highlighter markCommentFrom:((tokenStartPosition - 1) max: 1) to: source position.
    ^nil

    "Created: / 17-03-2012 / 00:05:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

