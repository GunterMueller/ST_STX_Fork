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

Object subclass:#GDBMIPrinter
	instanceVariableNames:'stream'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Private'
!

!GDBMIPrinter class methodsFor:'documentation'!

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
    A writer that writes GDB commands to an MI channel usin
    GDB MI input syntax [1].




    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        [1]: https://sourceware.org/gdb/onlinedocs/gdb/GDB_002fMI-Input-Syntax.html#GDB_002fMI-Input-Syntax

"
! !

!GDBMIPrinter class methodsFor:'instance creation'!

on: aStream
    ^ self new setStream: aStream.

    "Created: / 11-07-2017 / 21:21:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIPrinter methodsFor:'initialization'!

setStream: aStream
    stream := aStream

    "Created: / 11-07-2017 / 21:22:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIPrinter methodsFor:'printing'!

printCEscapedCharacter: aCharacter
    stream nextPut: $\.
    aCharacter == $" ifTrue:[ stream nextPut: $". ^ self ].
    aCharacter == $\ ifTrue:[ stream nextPut: $\. ^ self ].
    aCharacter == Character backspace ifTrue:[ stream nextPut: $b. ^ self ].
    aCharacter == Character tab ifTrue:[ stream nextPut: $t. ^ self ].
    aCharacter == Character linefeed ifTrue:[ stream nextPut: $n. ^ self ].
    aCharacter == Character return ifTrue:[ stream nextPut: $r. ^ self ].   
    aCharacter == Character newPage ifTrue:[ stream nextPut: $f. ^ self ]. 
    aCharacter codePoint <= 16rFF ifTrue:[ 
        stream nextPut: $x.
        aCharacter codePoint printOn: stream base: 16.
        ^ self.
    ].
    GDBError raiseErrorString: 'Unrepresentable character: \U', (aCharacter codePoint printStringRadix: 16)

    "Created: / 11-07-2017 / 22:12:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCString: aString
    "
    c-string → ''' seven-bit-iso-c-string-content '''
    "
    | start stop |
    stream nextPut: $".
    start := 1.
    [ start <= aString size ] whileTrue:[ 
        | char |
        stop := start.
        [ 
          stop > aString size ifTrue:[ 
            stream nextPutAll:aString startingAt: start to: stop - 1.
            stream nextPut: $".   
            ^ self.
          ].
          char := aString at: stop. 
          stop := stop + 1.
          char == Character space or:[(self needCEscaping: char) not] ] whileTrue.
        stream nextPutAll:aString startingAt: start to: stop - 2.
        self printCEscapedCharacter: char.
        start := stop.
    ].
    stream nextPut: $".

    "Created: / 11-07-2017 / 22:05:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCommand: aGDBCommand
    "
    command → cli-command | mi-command
    "
    aGDBCommand isMICommand ifTrue:[ 
        self printCommandMI: aGDBCommand
    ] ifFalse:[ 
        self printCommandCLI: aGDBCommand.
    ].

    "Created: / 11-07-2017 / 21:29:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCommandCLI: aGDBCLICommand
    "
    cli-command → [ token ] cli-command nl, where cli-command is any existing GDB CLI command.

    "
    aGDBCLICommand token notNil ifTrue:[ 
        aGDBCLICommand token printOn: stream.
    ].
    stream nextPutAll: aGDBCLICommand value.

    "Created: / 11-07-2017 / 21:33:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printCommandMI: aGDBMICommand
    "
    mi-command → [ token ] '-' operation ( ' ' option )* [ ' --' ] ( ' ' parameter )* nl
    "

    | maybeOption |

    aGDBMICommand token notNil ifTrue:[ 
        aGDBMICommand token printOn: stream.
    ].
    stream nextPut:$-; nextPutAll: aGDBMICommand operation.

    "/ Now, this is tricky. We have no distinction between options :-(
    maybeOption := true.
    aGDBMICommand arguments notEmptyOrNil ifTrue:[
        aGDBMICommand arguments do:[:each | 
            | eachAsString |

            eachAsString := each asString.
            stream space.
            eachAsString = '--' ifTrue:[ 
                maybeOption := false.
                stream nextPutAll: '--'.
            ] ifFalse:[
                (maybeOption and:[eachAsString first = $-]) ifTrue:[
                    self printOption: eachAsString
                ] ifFalse:[ 
                    self printParameter: eachAsString.
                ].
            ].
        ].
    ].

    "Created: / 11-07-2017 / 21:36:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-06-2018 / 12:00:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printNl
    "
    nl → CR | CR-LF 

    "
    stream nextPut: Character return.

    "Created: / 11-07-2017 / 21:33:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printNonBlankSequence: aString
    "
    non-blank-sequence → anything, provided it doesn’t contain special characters such as '-', nl, ''' and of course ' '
    "    
    stream nextPutAll: aString

    "Created: / 11-07-2017 / 21:54:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOption: aString
    "
    option → '-' parameter [ ' ' parameter ]
    "
    | i |

    i := 1.
    [ i <= aString size and:[ (aString at: i) == $- ] ] whileTrue:[
        i := i + 1.
    ].
    i to: aString size do:[:i |
        | c |

        c := aString at: i.
        (self needCEscaping: c) ifTrue:[ 
            self printParameter: aString.
            ^ self
        ].
    ].
    stream nextPutAll: aString.

    "Created: / 11-07-2017 / 21:51:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2017 / 23:21:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printParameter: aString
    "
    parameter → non-blank-sequence | c-string
    "    
    (self isNonBlankSequence: aString) ifTrue:[
        self printNonBlankSequence: aString
    ] ifFalse:[ 
        self printCString: aString
    ].

    "Created: / 11-07-2017 / 21:52:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIPrinter methodsFor:'testing'!

isNonBlankSequence: aString
    ^ aString allSatisfy:[:each | (self needCEscaping: each) not ].

    "Created: / 11-07-2017 / 21:53:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2017 / 23:26:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

needCEscaping: aCharacter
    ^ aCharacter == $\ 
        or:[ aCharacter == $" 
        or:[ (aCharacter codePoint between: 33 and: 16r7F) not ]]

    "Created: / 11-07-2017 / 22:42:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

