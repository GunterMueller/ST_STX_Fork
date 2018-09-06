"{ Encoding: utf8 }"

"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

JavaScanner subclass:#GroovyScanner
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Groovy-Tools-Source'
!


!GroovyScanner class methodsFor:'initialization'!

setupKeywordTable
    "initialize the scanners actionTables - these are used to dispatch
     into scanner methods as characters are read"

    super setupKeywordTable.
    KeywordTable at: 'def' put: #def.

    "Created: / 14-05-2014 / 14:06:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyScanner methodsFor:'error reporting'!

warnPossibleIncompatibility:aString position:smallInteger1 to:smallInteger2

    "Created: / 12-05-2014 / 16:23:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyScanner methodsFor:'reading next token'!

nextString:delimiter character:ignored
    |s pos nextChar inString inTrippleQuoteString |

    s := (String new:20) writeStream.

    pos := source position.
    source next.
    nextChar := source next.
    inString := true.
    inTrippleQuoteString := false.

    (delimiter == $" and:[nextChar == $"]) ifTrue:[
        source peek == $" ifTrue:[
            inTrippleQuoteString := true.
            nextChar := source next.
            nextChar := source next.
        ].
    ].
    (delimiter == $' and:[nextChar == $']) ifTrue:[
        source peek == $' ifTrue:[
            inTrippleQuoteString := true.
            nextChar := source next.
            nextChar := source next.
        ].
    ]. 

    [inString] whileTrue:[
        nextChar isNil ifTrue:[
            allowRunawayString ifTrue:[
                tokenValue := s contents.
                tokenType := #String.          
                ^ tokenType.
            ].
            self syntaxError:'unexpected end-of-input in String'
                    position:pos + 1 to:(source position).
            tokenValue := nil.
            tokenType := #EOF.
            ^ tokenType
        ].
        nextChar == $\ ifTrue:[
            nextChar := source next.
            nextChar := self characterEscape:nextChar.
        ] ifFalse:[
            (nextChar == Character cr) ifTrue:[
                lineNr := lineNr + 1
            ] ifFalse:[
                (nextChar == delimiter) ifTrue:[
                    inTrippleQuoteString ifTrue:[
                        nextChar := source next.
                        nextChar == delimiter ifTrue:[
                            "/ OK, two $"/$' found...
                            nextChar := source next.
                            nextChar == delimiter ifTrue:[
                                inString := false.
                            ] ifFalse:[
                                s nextPut:delimiter.
                                s nextPut:delimiter.
                            ].
                        ] ifFalse:[
                            s nextPut:delimiter.
                        ].
                    ] ifFalse:[
                        (source peekOrNil == delimiter) ifTrue:[
                            source next
                        ] ifFalse:[
                            inString := false
                        ]
                    ]
                ].
            ].
        ].
        inString ifTrue:[
            s nextPut:nextChar.
            nextChar := source next
        ]
    ].

    tokenValue := s contents.
    tokenType := #String.

    ^ tokenType

    "Created: / 18-10-2013 / 12:54:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-09-2014 / 11:40:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextToken
    "Refefined here to support hash-bang"

    source position < 1 ifTrue:[ 
        source peek == $# ifTrue:[ 
            source next.
            source peek == $!! ifTrue:[ 
                source nextLine.
            ].
        ].
    ].
    ^ super nextToken

    "Created: / 12-05-2014 / 16:21:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyScanner class methodsFor:'documentation'!

version_CVS

    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

