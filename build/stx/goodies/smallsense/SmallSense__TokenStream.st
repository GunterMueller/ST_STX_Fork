"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

Object subclass:#TokenStream
	instanceVariableNames:'scanner scannerSourceReadLimit tokens last position full
		positionMax positionOfCursor caretTokenReported'
	classVariableNames:'BacklogSize'
	poolDictionaries:''
	category:'SmallSense-Utils-Matcher'
!

Object subclass:#Token
	instanceVariableNames:'type value startPosition endPosition'
	classVariableNames:''
	poolDictionaries:''
	privateIn:TokenStream
!

!TokenStream class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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
    A custom read-only stream that return high-level tokens produced
    by underlying scanner object. The scanner must conform to API of
    Scanner class.

    Additionaly, when a cursor position is provided, TokenStream returns
    a virtual token with type #CARET.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        Scanner
        TokenPatternMatcher.

"
! !

!TokenStream class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    BacklogSize := 100.

    "Modified: / 07-08-2013 / 01:47:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenStream class methodsFor:'instance creation'!

on: scanner
    ^ self new initializeOn: scanner cursor: nil

    "Created: / 06-05-2014 / 15:25:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-05-2014 / 15:08:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

on: scanner cursor: cursor
    ^ self new initializeOn: scanner cursor: cursor

    "Created: / 15-05-2014 / 15:08:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenStream methodsFor:'accessing'!

sourceStream
    ^ scanner sourceStream

    "Created: / 07-08-2013 / 01:44:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenStream methodsFor:'initialization'!

initializeOn: scannerObject
    ^ self initializeOn: scannerObject cursor: nil

    "Created: / 06-05-2014 / 15:27:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-05-2014 / 15:08:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeOn: scannerArg cursor: positionOfCursorArg
    scanner := scannerArg.
    positionOfCursor := positionOfCursorArg.
    tokens := Array new: BacklogSize.
    last := 0.
    full := false.
    position := 0.
    positionMax := 0.
    caretTokenReported := false.

    positionOfCursor notNil ifTrue:[ 
        scannerArg sourceStream isExternalStream ifTrue:[ 
            self error: 'Cursor reporting us supported only on internal streams'.
        ].
        scannerSourceReadLimit := scannerArg sourceStream readLimit.
        scannerArg sourceStream readLimit: (positionOfCursor min: scannerSourceReadLimit)
    ].

    "Created: / 15-05-2014 / 15:07:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-05-2014 / 17:55:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenStream methodsFor:'stream api'!

atEnd
    ^ self peek type == #EOF

    "Created: / 14-03-2012 / 22:53:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2013 / 01:49:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contents
    ^ Array streamContents:[ :s | 
        [ self atEnd ] whileFalse:[ 
            s nextPut: self next
        ].
    ].

    "Created: / 15-05-2014 / 07:49:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

next
    | i t |
    position < positionMax ifTrue:[
        i := last - (positionMax - position) + 1.
        i <= 0 ifTrue:[
            i := tokens size + i.
        ].
        position := position + 1.
        ^ tokens at: i.
    ].
    scanner nextToken.
    t := scanner token.
    "/ Smalltalk / JavaScript scanners does not return token objects, sigh...
    (t isCharacter or:[ t isString ]) ifTrue:[ 
        t := Token new
                type: scanner tokenType;
                value: scanner token;
                startPosition: scanner tokenStartPosition;
                endPosition: scanner tokenEndPosition;        
                yourself
    ].
    t isNil ifTrue:[ 
        t := Token new
                type: #EOF;
                yourself
    ].
    t type == #EOF ifTrue:[ 
        (caretTokenReported not and:[scanner sourceStream position == positionOfCursor]) ifTrue:[ 
            t type: #CARET.
            t value: $|.
            t startPosition: positionOfCursor.
            t endPosition: positionOfCursor.
            caretTokenReported := true.
            scanner sourceStream readLimit: scannerSourceReadLimit.
        ].
    ].
    position := positionMax := positionMax + 1.
    last := last + 1.
    last > tokens size ifTrue:[ 
        full ifFalse:[ full := true ].
        last := 1 
    ].
    tokens at: last put: t.
    ^ t

    "Created: / 14-03-2012 / 22:53:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-05-2014 / 17:56:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

next: anInteger 
    "Answer up to anInteger elements of my collection. Overridden for efficiency."

    ^ self shouldNotImplement

    "Modified: / 06-05-2014 / 15:51:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

peek
    | t |

    t := self next.
    position := position - 1.
    ^ t

    "Modified: / 07-08-2013 / 01:12:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

position
    ^position

    "Created: / 14-03-2012 / 22:52:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2013 / 01:06:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

position: anInteger
    (positionMax - anInteger) > (tokens size) ifTrue:[
        Stream positionErrorSignal raiseErrorString:'Not that much tokens in backlog!! You may try to increase it.'.
        ^ self.
    ].
    position := anInteger.

    "Modified: / 07-08-2014 / 11:46:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

position: tokenPosition sourcePosition: sourcePosition
    position := positionMax := tokenPosition.
    tokens := tokens class new: tokens size.
    full := false.

    scanner sourceStream position: sourcePosition.
    positionOfCursor notNil ifTrue:[
        sourcePosition < positionOfCursor ifTrue:[
            scanner sourceStream readLimit: (positionOfCursor min: scannerSourceReadLimit).
            caretTokenReported := false.
        ].
    ].

    "Created: / 13-06-2014 / 17:06:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reset
    (positionMax) > (tokens size) ifTrue:[
        scanner sourceStream reset.    
        tokens := Array new: BacklogSize.
        last := 0.
        full := false.
        position := 0.
        positionMax := 0.
    ].
    position := 0.

    "Created: / 14-05-2014 / 16:19:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 11:57:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipSeparators
    self halt.

    "Created: / 15-03-2012 / 10:35:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2013 / 01:15:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

uncheckedPeek
    "An unchecked version of peek that throws an error if we try to peek over the end of the stream, even faster than #peek."

    ^ self peek

    "Modified: / 14-03-2012 / 22:46:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenStream::Token methodsFor:'accessing'!

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

stopPosition
    ^ endPosition

    "Created: / 04-04-2013 / 00:32:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    ^ type
!

type:something
    type := something.
!

value
    ^ value
!

value:something
    value := something.
! !

!TokenStream::Token methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    aStream nextPut: ${.
    type printOn:aStream.
    aStream nextPutAll:' - '.
    value printOn:aStream.
    aStream nextPutAll:' <'.
    startPosition printOn:aStream.
    aStream nextPutAll:'-'.
    endPosition printOn:aStream.
    aStream nextPutAll:'>}'.

    "Modified: / 06-05-2014 / 15:33:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenStream class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


TokenStream initialize!
