"{ Encoding: utf8 }"

"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

Object subclass:#GDBMIParser
	instanceVariableNames:'source lookahead token token2CommandMappingBlock recorder'
	classVariableNames:''
	poolDictionaries:'GDBCommandStatus'
	category:'GDB-Private'
!

!GDBMIParser class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
    A parser that reads GDB MI output records from a stream
    and converts them to objects.

    See [1] for description of GDB MI output syntax.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        [1]: https://sourceware.org/gdb/onlinedocs/gdb/GDB_002fMI-Output-Syntax.html#GDB_002fMI-Output-Syntax

"
! !

!GDBMIParser class methodsFor:'instance creation'!

on: aStringOrStream
    ^ self new on: aStringOrStream

    "Created: / 27-05-2014 / 23:50:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'accessing'!

recorder
    ^ recorder
!

recorder:something
    recorder := something.
!

token2CommandMappingBlock: aBlock
    token2CommandMappingBlock := aBlock.

    "Created: / 19-06-2014 / 21:34:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'initialization'!

on: aStringOrStream
    source := aStringOrStream readStream

    "Created: / 27-05-2014 / 23:50:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'parsing'!

parseByte
    | c1 c2 |

    c1 := self next.
    c1 isHexDigit ifFalse:[ 
        self error: 'hex digit expected'.
    ].
    c2 := self next.
    c2 isHexDigit ifFalse:[ 
        self error: 'hex digit expected'.
    ].
    ^ ((c1 digitValueRadix: 16) bitShift: 4) bitOr:(c2 digitValueRadix: 16)

    "Created: / 22-06-2018 / 11:27:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseByteArray
    | bytes |
    self expect: $".
    self skipSeparators.
    bytes := ByteArray new writeStream.
    [ self peek ~~ $" ] whileTrue:[
        bytes nextPut: self parseByte.
        self skipSeparators.
    ].
    self next. "/ eat $"
    ^ bytes contents

    "Created: / 22-06-2018 / 11:24:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCString
    self expect: $".
    ^ self parseCStringRest: ''.

    "Created: / 27-05-2014 / 23:51:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 18-06-2014 / 07:19:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCStringEscape: char
    |ascii c |

    char == $" ifTrue:[
	^ $".
    ].

    char == $b ifTrue:[
	^ Character backspace
    ].
    char == $t ifTrue:[
	^ Character tab
    ].
    char == $n ifTrue:[
	^ Character cr
    ].
    char == $r ifTrue:[
	^ Character return
    ].
    char == $f ifTrue:[
	^ Character newPage
    ].

"/    char == $u ifTrue:[
"/        ascii := 0.
"/        c := source peekOrNil.
"/        4 timesRepeat:[
"/            (c isDigitRadix:16) ifFalse:[
"/                self syntaxError:'invalid hex character constant'
"/                        position:source position-2 to:(source position - 1).
"/                ^ Character value:ascii
"/            ].
"/            ascii := (ascii bitShift:4).
"/            ascii := ascii + c digitValue.
"/            source next. c := source peekOrNil.
"/        ].
"/        ^ Character value:ascii
"/    ].
    char == $x ifTrue:[
	ascii := 0.
	c := self peekOrNil.
	2 timesRepeat:[
	    (c isDigitRadix:16) ifFalse:[
		self error:'Invalid hex character escape'.
		^ Character value:ascii
	    ].
	    ascii := (ascii bitShift:4).
	    ascii := ascii + c digitValue.
	    self next. c := self peekOrNil.
	].
	^ Character value:ascii
    ].
    "OctalEscape ::= \ OctalDigit |
		     \ OctalDigit OctalDigit
		     \ ZeroToThree OctalDigit OctalDigit"

    (char between:$0 and:$3) ifTrue:[
	ascii := char digitValue.
	c := self peekOrNil.
	(c between: $0 and: $7) ifTrue:[
	    self next.
	    ascii := (ascii bitShift:3).
	    ascii := ascii + c digitValue.
	].
	c := self peekOrNil.
	(c between: $0 and: $7) ifTrue:[
	    self next.
	    ascii := (ascii bitShift:3).
	    ascii := ascii + c digitValue.
	].
	^ Character value:ascii
    ].
    (char between:$4 and: $7) ifTrue:[
	ascii := char digitValue.
	c := self peekOrNil.
	(c between: $0 and: $7) ifTrue:[
	    self next.
	    ascii := (ascii bitShift:3).
	    ascii := ascii + c digitValue.
	].
	^ Character value:ascii
    ].

    ^ char

    "Created: / 28-05-2014 / 00:02:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCStringRest: alreadyRead
    | buffer inString nextChar |

    buffer := (String new: 50) writeStream.
    buffer nextPutAll: alreadyRead.
    nextChar := self next.
    inString := true.
    [inString] whileTrue:[
        nextChar isNil ifTrue:[
            self error: 'Unexpected end of input'.
        ].
        nextChar == $\ ifTrue:[
            nextChar := self next.
            nextChar := self parseCStringEscape:nextChar.
        ] ifFalse:[
            (nextChar == $") ifTrue:[
                (self peekOrNil == $") ifTrue:[
                    self next
                ] ifFalse:[
                    inString := false
                ]
            ].
        ].
        inString ifTrue:[
            buffer nextPut:nextChar.
            nextChar := self next
        ]
    ].
    ^ buffer contents

    "Created: / 18-06-2014 / 07:17:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseNl
    | c |

    c := self peek.
    c == Character return"CR" ifTrue:[ 
        self next.
        c := self peek.
    ].
    c == Character lf"LF" ifTrue:[
        self next
    ].

    "Created: / 30-05-2014 / 09:52:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2014 / 00:38:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2018 / 08:56:40 / jv"
!

parseNonBlankSequence
    ^ String streamContents:[ :buffer | 
        [ self peek isNil or: [ self peek isSeparator ] ] whileFalse:[
            buffer nextPut: self next.
        ]
    ]

    "Created: / 24-06-2014 / 23:19:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput
    "
    output → ( out-of-band-record )* [ result-record ] '(gdb)' nl
    out-of-band-record → async-record | stream-record

    "

    | peek events |

    events := GDBEventSet new.

    peek := self peek.
    peek == Character space ifTrue:[ self next ].
    peek := self peek.
    peek == Character cr ifTrue:[ self next ].
    [
        token := nil.
        peek := self peek.
        peek isNil ifTrue:[ 
            source atEnd ifTrue:[ ^ events ].
        ].
        peek isDigit ifTrue:[ self parseToken. peek := self peek ].
        peek ~~ $(
    ] whileTrue:[
        ('*+=' includes: self peek) ifTrue:[
            | event |

            event := self parseAsyncRecord.
            events add: event.
            "Sigh, GDB 7.7.1 does not write '(gdb)' terminator after an
             async events (even though specification says it should). 
             Thus, report any execution record immediately"
            event isAsyncEvent ifTrue:[
                events last token: token.
                recorder notNil ifTrue:[ 
                    recorder recordResponseEnd.
                ].
                ^ events
            ].
        ] ifFalse:[
            ('~@&' includes: self peek) ifTrue:[
                events add: self parseStreamRecord.
            ] ifFalse:[
                peek == $^ ifTrue:[
                    events add: self parseResultRecord.
                    "/ Sigh, when using MI over PTY (as suggested by Pedro Alves),
                    "/ the PTY is kept open if GDB exits so peek block for ever.
                    "/ So, if ^exit status is reported, exit immediately. 
                    (events last isCommandResultEvent and:[ events last status == #exit ]) ifTrue:[ 
                        events last token: token. 
                        recorder notNil ifTrue:[ 
                            recorder recordResponseEnd.
                        ].
                        ^ events
                    ].
                ] ifFalse:[
                    self error:'Invalid MI record'.
                ].
            ].
        ].
        events last token: token.
    ].
    self expect: '(gdb)'.
    [ self peek == Character space ] whileTrue:[ self next ].
    self parseNl.
    recorder notNil ifTrue:[ 
        recorder recordResponseEnd.
    ].
    ^ events

    "Created: / 30-05-2014 / 09:52:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2017 / 11:04:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePostStartHeader
    "
Python Exception <type 'exceptions.ImportError'> No module named gdb: 
./gdb: warning: 
Could not load the Python gdb module from `/usr/local/share/gdb/python'.
Limited Python support is available from the _gdb module.
Suggest passing --data-directory=/path/to/gdb/data-directory.

=thread-group-added,id='i1'
(gdb) 

    "

    | atBeginingOfLine c |

    atBeginingOfLine := true.
    [ 
        c := source peek.
        atBeginingOfLine and:[ c == $= ]
    ] whileFalse:[ 
        c := source next.
        atBeginingOfLine := c == Character lf
    ].

    "Created: / 01-03-2015 / 08:25:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseResultClass
    "
    result-class → 'done' | 'running' | 'connected' | 'error' | 'exit'
    "
    | c1 c2 |

    c1 := self peek.
    c1 == $d ifTrue:[
	self expect: 'done'.
	^ CommandStatusDone.
    ].
    c1 == $r ifTrue:[
	self expect: 'running'.
	^ CommandStatusDone.
    ].
    c1 == $c ifTrue:[
	self expect: 'connected'.
	^ CommandStatusConnected.
    ].
    c1 == $e ifTrue:[
	self next.
	c2 := self peek.
	c2 == $x ifTrue:[
	    self expect: 'xit'.
	    ^ CommandStatusExit.
	].
	c2 == $r ifTrue:[
	    self expect: 'rror'.
	    ^ CommandStatusError.
	].
    ].
    ^ self error:'Unsupported result class'

    "Created: / 31-05-2014 / 00:16:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2014 / 23:21:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseResultRecord
    "
    result-record → '^' result-class ( ',' result )* nl
    "

    | command result status descriptor propertyName propertyDescriptor propertyValue |

    self expect: $^.
    result := GDBCommandResult new.
    status := self parseResultClass.
    result status: status.
    descriptor := GDBMAContainer new.
    (token notNil and:[ token2CommandMappingBlock notNil ]) ifTrue:[ 
        command := token2CommandMappingBlock value: token. 
        command notNil ifTrue:[
            result command: command.
            status ~~ CommandStatusError ifTrue:[
                descriptor := command resultDescription.        
            ].
        ].
    ].

    descriptor klass isNil ifTrue:[ 
        "/ Command result is not an object but list of properties...
        [ self peek == $, ] whileTrue:[
            self next. "/ eat $,
            propertyName := self parseVariable.
            propertyDescriptor := descriptor propertyDescriptorAt: propertyName.
            self expect: $=.
            propertyDescriptor isNil ifTrue:[ 
                propertyValue := self parseValue.
            ] ifFalse:[ 
                propertyValue := propertyDescriptor parseUsingGDBMIParser:self. 
            ]. 
            result propertyAt: propertyName put: propertyValue.
         ].             
    ] ifFalse:[ 
        "/ Command result forms an object.
        "/ Create an object and parse property list as its properties.
        | object |

        object := descriptor klass new.
        self peek == $, ifTrue:[
            self next. "/ eat first , following command status...
            self parsePropertiesFor: object describedBy: descriptor.
        ].
        result propertyAt: #value put: object.
    ].
    self parseNl.
    ^ GDBCommandResultEvent new result: result.

    "Created: / 30-05-2014 / 09:52:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-02-2018 / 09:35:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseToken
    token := 0.
    [ self peek isDigit ] whileTrue:[ 
        token := (token * 10) + (self next codePoint - $0 codePoint).
    ].

    "Created: / 28-05-2014 / 00:14:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-06-2014 / 00:49:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'parsing-async events'!

parseAsyncRecord
    "
    async-record → exec-async-output | status-async-output | notify-async-output
    "
    self peek == $* ifTrue:[
        self next.
        ^ self parseAsyncRecord: GDBExecutionEvent.
    ].
    self peek == $+ ifTrue:[
        self next.
        ^ self parseAsyncRecord: GDBStatusEvent .
    ].
    self peek == $= ifTrue:[
        self next.
        ^ self parseAsyncRecord: GDBNotificationEvent.
    ].

    ^ self error: 'Invalid async-record'

    "Created: / 30-05-2014 / 09:57:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2014 / 22:19:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseAsyncRecord: eventClassBase
    "
    async-output → async-class ( ',' result )* nl
    "

    | type eventClass event propertyName propertyDescriptor descriptor propertyValue |

    type := self parseString.
    eventClass := eventClassBase eventClassForType: type.
    event := eventClass new.
    event type: type.
    descriptor := eventClass description.
    [ self peek == $, ] whileTrue:[
        self next. "/ eat $,
        propertyName := self parseVariable.
        propertyDescriptor := descriptor propertyDescriptorAt: propertyName.
        self expect: $=.
        propertyDescriptor isNil ifTrue:[ 
            propertyValue := self parseValue.
        ] ifFalse:[ 
            propertyValue := propertyDescriptor parseUsingGDBMIParser:self. 
        ]. 
        event propertyAt: propertyName put: propertyValue.
    ].
    self parseNl.

    ^ event

    "Created: / 01-06-2014 / 23:43:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-06-2014 / 21:43:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'parsing-commands'!

parseCommand

    self peek isDigit ifTrue:[ 
        self parseToken
    ].

    ^ self peek == $- ifTrue:[ 
        self parseCommandMI
    ] ifFalse:[ 
        self parseCommandCLI
    ].

    "Created: / 24-06-2014 / 23:08:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandCLI
    "raise an error: this method should be implemented (TODO)"

    ^ GDBCLICommand new
        token: token;
        value: self nextLine;
        yourself

    "Created: / 24-06-2014 / 23:10:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandMI
    "raise an error: this method should be implemented (TODO)"

    | operation className class args |

    self next. "/ eat $-.
    operation := self parseVariable.
    className := ('GDBMI_' , (operation copyReplaceAll: $- with: $_)) asSymbol.
    class := Smalltalk at: className.
    args := OrderedCollection new.
    [ self peek isNil or:[ self peek == Character cr ] ] whileFalse:[  
        self skipSeparators.
        self peek == $" ifTrue:[ 
            args add: self parseCString
        ] ifFalse:[ 
            args add: self parseNonBlankSequence
        ].
    ].
    self next. "/ eat CR.
    ^ (class arguments: args asArray) token: token.

    "Created: / 24-06-2014 / 23:10:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-08-2014 / 08:02:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'parsing-misc'!

parseResult
    "
    result → variable = value
    "

    | name value |

    name := self parseVariable.
    self expect: $=.
    value := self parseValue.
    ^ name -> value

    "Created: / 30-05-2014 / 10:15:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2014 / 00:39:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseString
    ^ String streamContents:[:s|
        [ self peek notNil and:[self peek isLetterOrDigit or:['-_' includes: self peek ] ] ] whileTrue:[
            s nextPut: self next.
        ]
    ].

    "Created: / 30-05-2014 / 10:32:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 23:30:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseVariable
    "
    variable → string
    "
    ^ self parseString

    "Created: / 30-05-2014 / 10:31:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'parsing-stream output'!

parseStreamRecord
    "
    stream-record → console-stream-output | target-stream-output | log-stream-output
    "

    self peek == $~ ifTrue:[
        self next.
        ^ self parseStreamRecord: GDBConsoleOutputEvent.
    ].
    self peek == $@ ifTrue:[
        self next.
        ^ self parseStreamRecord: GDBTargetOutputEvent.
    ].
    self peek == $& ifTrue:[
        self next.
        ^ self parseStreamRecord: GDBLogOutputEvent.
    ].
    self error:'Invalid stream record'

    "Created: / 30-05-2014 / 09:57:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2014 / 22:21:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseStreamRecord: eventClass
    | value |

    value := self parseCString.
    self parseNl.
    ^ eventClass new value: value; yourself

    "Created: / 01-06-2014 / 23:41:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'parsing-utils'!

expect: aStringOrChar

    | c |
    aStringOrChar isCharacter ifTrue:[
	(self atEnd or:[(c := self next) ~= aStringOrChar]) ifTrue:[
	    self error:('Expected ''%1'' got ''%2''.' bindWith: aStringOrChar with: c).
	].
	^self.
    ].
    aStringOrChar isString ifTrue:[
	aStringOrChar do:[:expected|
	    (self atEnd or:[(c := self next) ~= expected]) ifTrue:[
		self error:('Expected ''%1''.' bindWith: aStringOrChar).
	    ].
	].
	^self.
    ].

    self error:'Invalid expected value'.

    "Created: / 19-11-2012 / 20:08:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-05-2014 / 00:17:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expectLineEnd
    self expect: Character cr.

    "Created: / 19-11-2012 / 20:06:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expectSpace
    self expect: Character space.

    "Created: / 19-11-2012 / 20:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'parsing-values'!

parseConst
    "
    const → c-string
    "

    ^ self parseCString.

    "Created: / 30-05-2014 / 10:36:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseList
    "
    list → '[]' | '[' value ( ',' value )* ']' | '[' result ( ',' result )* ']'
    "

    | list |

    self expect: $[.
    list := self parseListBody.
    self expect: $].
    ^ list

    "Created: / 30-05-2014 / 10:36:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2014 / 22:14:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseListBody
    ^self parseListBody: $]

    "Created: / 17-06-2014 / 22:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-07-2017 / 08:25:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseListBody: terminator
    | value object |

    object := OrderedCollection new.
    self peek ~~ terminator ifTrue:[
        [
            ('"{[' includes: self peek) ifFalse:[ 
                self parseVariable.
                self expect: $=.
            ].
            value := self parseValue.
            object add: value.
        ] doWhile:[
            (self peek == $,) ifTrue:[ self next. true ] ifFalse:[ false ]     
        ].
    ].
    ^ object asArray

    "Created: / 06-07-2017 / 08:24:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseTuple
    | object |

    self expect: ${.
    object := self parseTupleBody.
    self expect: $}.
    ^ object

    "Created: / 30-05-2014 / 10:36:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 14-06-2014 / 02:28:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseTupleBody
    | name value dict |

    "/ Sometimes what looks like a tupple is actually
    "/ braced array, such as in : ...,script={"line1","line2"},...
    self peek = $" ifTrue:[ 
        ^ self parseListBody:$}.
    ].
    "/ OK, a real tuple:
    dict := Dictionary new.
    self peek ~~ $} ifTrue:[
        name := self parseVariable.
        self expect: $=.
        value := self parseValue.
        dict at: name put: value.
        [ self peek == $, ] whileTrue:[
            self next.
            name := self parseVariable.
            self expect: $=.
            value := self parseValue.
            dict at: name put: value.
        ].
    ].
    ^ dict

    "Created: / 14-06-2014 / 02:19:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-07-2017 / 08:25:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValue
    "
    value → const | tuple | list
    "

    self peek == $" ifTrue:[
	^ self parseConst
    ].
    self peek == ${ ifTrue:[
	^ self parseTuple.
    ].
    self peek == $[ ifTrue:[
	^ self parseList
    ].
    self error:'Invalid value'

    "Created: / 30-05-2014 / 10:31:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'parsing-values-typed'!

parsePropertiesFor: object describedBy: descriptor
    | propertyName propertyValue propertyDescriptor |

    [ 
        propertyName := self parseVariable.
        propertyDescriptor := descriptor propertyDescriptorAt: propertyName.
        self expect: $=.
        propertyDescriptor isNil ifTrue:[ 
            propertyValue := self parseValue.
        ] ifFalse:[ 
            propertyValue := propertyDescriptor parseUsingGDBMIParser:self. 
        ].
        object propertyAt: propertyName put: propertyValue
    ] doWhile: [ 
        (self peek == $,) ifTrue:[ self next. true ] ifFalse:[ false ]
    ].
    ^ object

    "Created: / 19-03-2015 / 07:52:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValueAsBoolean
    "
    bool → 'y' | 'n' | value
    "

    self peek == $" ifTrue:[
        | c |

        self expect: $".
        c := self next.
        (c ~~ $y and:[ c ~~ $n and:[ c ~~ $1 and:[ c ~~ $0 ]]] ) ifTrue:[
            | s |

            s := self parseCStringRest: c asString.  
            s = 'true' ifTrue:[ ^ true ].
            s = 'false' ifTrue:[ ^ false ].
            ^ s

        ].
        self peek ~~ $" ifTrue:[ 
            | s |

            s := self parseCStringRest: c asString. 
            s = 'true' ifTrue:[ ^ true ].
            s = 'false' ifTrue:[ ^ false ].
            ^ s
        ].
        self next.
        ^ (c == $y) or:[ c == $1 ]
    ].
    ^ self parseValue

    "Created: / 18-06-2014 / 07:33:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2018 / 22:21:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValueAsByteArray
    ^ self parseByteArray

    "Created: / 22-06-2018 / 11:18:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValueAsInstanceOf: class
    | description |

    class == Boolean ifTrue:[ 
        description := Magritte::MABooleanDescription new.
    ] ifFalse:[
    class == Integer ifTrue:[ 
        description := Magritte::MANumberDescription new
    ] ifFalse:[
    class == String ifTrue:[ 
        description := Magritte::MAStringDescription new
    ] ifFalse:[
        description := class description. 
    ]]].     

    ^ self parseValueAsListOf: class describedBy: description.

    "Created: / 18-06-2014 / 20:28:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2014 / 23:16:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValueAsInstanceOf: class describedBy: descriptor
    | object |

    self peek ~~ ${ ifTrue:[ ^ self parseValue ].
    self next. "/ eat {
    object := class new.
    self peek ~~ $} ifTrue:[
        self parsePropertiesFor: object describedBy: descriptor
    ].
    self expect: $}.
    ^ object

    "Created: / 18-06-2014 / 20:28:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2015 / 07:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValueAsInteger
    self peek == $" ifTrue:[
        | c v |

        self expect: $".
        c := self next.
        v := 0.
        c isDigit ifTrue:[
            (c == $0 and:[ self peek == $x ]) ifTrue:[ 
                "/ Find 0x prefix, parse hex number (address or alike)
                self next. "/ eat $x
                c := self next.
                [ c isHexDigit ] whileTrue:[ 
                    v := (v << 4) + (c digitValue).
                    c := self next.
                ].
            ] ifFalse:[
                "/ Parse decimal number
                [ c isDigit ] whileTrue:[ 
                    v := (v * 10) + (c digitValue).
                    c := self next.
                ].
            ].
            c == $" ifTrue:[ 
                ^ v
            ] ifFalse:[ 
                ^ self parseCStringRest:v printString , c  
            ].
        ].
        ^ self parseCStringRest: c asString
    ].
    ^ self parseValue

    "Created: / 18-06-2014 / 07:39:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2018 / 14:50:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValueAsListElementDescribedBy:descriptor
    | tag |
    self peek isAlphaNumeric ifTrue:[ 
        tag := self parseVariable.
        self expect: $=. 
    ].
    ^ descriptor parseUsingGDBMIParser:self taggedAs: tag.

    "Created: / 11-11-2017 / 12:19:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2018 / 16:22:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValueAsListOf: class
    | description |

    class == Boolean ifTrue:[ 
        description := Magritte::MABooleanDescription new.
    ] ifFalse:[
    class == Integer ifTrue:[ 
        description := Magritte::MANumberDescription new
    ] ifFalse:[
    class == String ifTrue:[ 
        description := Magritte::MAStringDescription new
    ] ifFalse:[
        description := class description. 
    ]]].     

    ^ self parseValueAsListOf: class describedBy: description.

    "Created: / 18-06-2014 / 21:00:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2014 / 23:17:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValueAsListOf:class describedBy:descriptor
    ^ self parseValueAsListOf:class describedBy:descriptor allowOmmitedBrackets: false

    "Created: / 18-06-2014 / 21:00:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-11-2017 / 12:14:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValueAsListOf:class describedBy:descriptor allowOmmitedBrackets: allowOmmitedBrackets
    | list bracketsOmmited |

    self peek == $[ ifTrue:[ 
        self next. "/ eat $[
        bracketsOmmited := false.
    ] ifFalse:[
        allowOmmitedBrackets ifFalse:[
            ^ self parseValue 
        ].
        bracketsOmmited := true.
    ].

    list := OrderedCollection new.
    bracketsOmmited ifTrue:[ 
        [ 
            list add: (self parseValueAsListElementDescribedBy: descriptor).  
        ] doWhile:[  
            (self peek == $,) ifTrue:[ self next ].
            self peek == ${
        ].    
    ] ifFalse:[
        self peek ~~ $] ifTrue:[ 
            [ 
                list add: (self parseValueAsListElementDescribedBy: descriptor).  
            ] doWhile: [
                (self peek == $,) ifTrue:[ self next. true ] ifFalse:[ false ]
            ].
        ].
    ].

    bracketsOmmited ifFalse:[
        self expect: $]. "/ eats $]
    ].
    ^ list asNilIfEmpty.

    "Created: / 11-11-2017 / 12:14:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-11-2017 / 17:22:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 03-07-2018 / 15:51:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseValueAsString
    ^ self parseCString

    "Created: / 23-09-2014 / 22:22:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser methodsFor:'streaming'!

atEnd
    ^ lookahead isNil and:[ source atEnd ].

    "Created: / 28-05-2014 / 00:17:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-06-2014 / 02:27:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

next
    | next |
    lookahead notNil ifTrue:[
        next := lookahead.
        lookahead := nil.
        ^ next.
    ].
    next := source next.
    recorder notNil ifTrue:[ 
        recorder recordResponseChar: next.
    ].
    ^ next

    "Created: / 23-10-2012 / 10:57:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-06-2014 / 21:56:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextLine
    | line |

    line := lookahead notNil 
                ifTrue:[ lookahead asString , (source nextLine ? '') ] 
                ifFalse:[ source nextLine ? ''].
    lookahead := nil.
    recorder notNil ifTrue:[ 
        recorder recordResponse: line.  
    ].
    ^ line

    "Created: / 23-10-2012 / 11:05:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2015 / 15:05:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

peek
    lookahead notNil ifTrue:[
        ^ lookahead
    ].
    lookahead := source next.
    recorder notNil ifTrue:[ 
        lookahead notNil ifTrue:[
            recorder recordResponseChar: lookahead.
        ].
    ].
    ^ lookahead

    "Created: / 28-05-2014 / 00:18:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-06-2014 / 09:34:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

peekOrNil
    lookahead notNil ifTrue:[ ^ lookahead ].
    source atEnd ifTrue:[ ^ nil ].
    ^ self peek

    "Created: / 28-05-2014 / 00:15:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipSeparators
    [ self peek notNil and:[ self peek isSeparator ] ] whileTrue:[ self next ]

    "Created: / 19-11-2012 / 20:05:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-06-2014 / 23:31:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

