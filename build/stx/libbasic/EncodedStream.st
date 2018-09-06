"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2010 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

PeekableStream subclass:#EncodedStream
	instanceVariableNames:'encoder stream'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!EncodedStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2010 Jan Vrany
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
    a stream which transparently decodes from an external decoding,
    looking for '{ Encoding: xxx' near the beginning of the file.

    especially targeted towards reading ST/X source files.
"
! !

!EncodedStream class methodsFor:'instance creation'!

stream:streamArg encoder:encoder
    ^ (self basicNew) stream:streamArg; encoder:encoder

    "
     |s|
     s := EncodedStream stream:Transcript encoder:(CharacterEncoder encoderToEncodeFrom:#utf8 into:#unicode).
     s nextPutAll:('צהü' utf8Encoded)
    "
!

stream:streamArg encoding:encodingSymbol
    ^ self stream:streamArg encoder:(CharacterEncoder encoderFor:encodingSymbol)

    "
     |baseStream s|
     baseStream := '' readWriteStream.
     s := EncodedStream stream:baseStream encoding:#utf8.
     s nextPutAll:'צהü'.
     baseStream reset; contents.
    "
! !

!EncodedStream class methodsFor:'Compatibility-VW5.4'!

on: aStream encodedBy: aStreamEncoder

        ^self basicNew on: aStream encodedBy: aStreamEncoder
! !

!EncodedStream class methodsFor:'utilities'!

decodedStreamFor:aStream
    "given a positionable stream, guess its encoding (by reading the
     first few lines, looking for a string with an encoding hint,
     and return an appropriate encoded string, which does the decoding
     on the fly. Used mostly to read UTF8 files (source code)"

    |encodingSymbol decodedStream|

    aStream inputStream isPositionable ifTrue:[
        encodingSymbol := CharacterEncoder guessEncodingOfStream:aStream inputStream.
        decodedStream := self stream:aStream encoding:encodingSymbol.
        "JV@2012-03-27: NO, DO NOT CHANGE POSITION!! Caller might be interested
                        in all data!!!!!!"
        "/decodedStream skipEncodingChunk.
    ] ifFalse:[
        "/ setup for no-encoding; 
        "/ switch to a real encoder later,
        "/ whenever an encoding pragma is encountered later by #nextChunk.
        decodedStream := self stream:aStream encoder:CharacterEncoder nullEncoderInstance.
    ].
    ^ decodedStream

    "Modified: / 23-08-2013 / 17:30:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

encoderFor:anEncodingSymbol
    (anEncodingSymbol isNil
    or:[ anEncodingSymbol = #'iso8859-1' 
    or:[ anEncodingSymbol = #'ascii' ]]) ifTrue:[
        ^ nil
    ].
    ^ CharacterEncoder encoderFor:anEncodingSymbol.
! !

!EncodedStream methodsFor:'Compatibility-VW5.4'!

on:aStream encodedBy:aStreamEncoder
    "Initialize the receiver on aStream with aStreamEncoder."

"/    skipSize := PositionRecord new.
"/    aStreamEncoder skipRecord: skipSize.
"/    binary := false.
"/    lineEndConvention == nil 
"/            ifTrue: 
"/                    [aStream needsFileLineEndConversion 
"/                            ifTrue: [self lineEndConvention: IOAccessor defaultLineEndConvention]
"/                            ifFalse: [self lineEndConvention: LineEndTransparent]].
    self stream: aStream.
    self encoder: aStreamEncoder
! !

!EncodedStream methodsFor:'accessing'!

contentsSpecies

    "Not sure if this is ok"

    ^ stream contentsSpecies.

"/    ^UnicodeString

    "Created: / 14-06-2005 / 17:11:01 / janfrog"
!

encoder
    ^ encoder
!

encoder:something
    encoder := something.
!

inputStream
    ^ stream inputStream
!

lineNumber
    ^ stream lineNumber
!

pathName
    "if our base stream has a pathname, delegate..."

    stream isNil ifTrue:[
        ^ nil.
    ].
    ^ stream pathName.
!

readStream
    ^ self
!

stream
    ^ stream
!

stream:something
    stream := something.
! !

!EncodedStream methodsFor:'private fileIn'!

basicFileInNotifying:someone passChunk:passChunk
    "central method to file in from the receiver, i.e. read chunks and evaluate them -
     return the value of the last chunk.
     Someone (which is usually some codeView) is notified of errors."

    |lastValue pkg nameSpace usedNameSpaces
     packageQuerySignal nameSpaceQuerySignal usedNameSpaceQuerySignal
     changeDefaultApplicationNotificationSignal
     defaultApplicationQuerySignal defaultApplication
     confirmationQuerySignal handledSignals passedSignals askSomeoneForPackage outerContext askForVariableTypeOfUndeclaredQuery|

    self skipSeparators.
    lastValue := self peek.
    lastValue == $< ifTrue:[
        "/ assume, it's an xml file
        ^ self fileInXMLNotifying:someone passChunk:passChunk.
    ].
    lastValue == $# ifTrue:[
        "assume unix interpreter name:
         '#!!stx -e' or something like this"
        self nextPeek == $!! ifTrue:[
            "skip the unix command line"
            self nextLine
        ] ifFalse:[
             self error:'Invalid chunk start'
        ]
    ].

    (Smalltalk at:#Compiler) isNil ifTrue:[
        self isFileStream ifTrue:[
            Transcript show:('[' , self pathName , '] ').
        ].
        Transcript showCR:'cannot fileIn (no compiler).'.
        ^ nil.
    ].

    "/ support for V'Age applications
    defaultApplicationQuerySignal := Class defaultApplicationQuerySignal.
    changeDefaultApplicationNotificationSignal := Class changeDefaultApplicationNotificationSignal.

    "/ support for ST/X's nameSpaces & packages
    packageQuerySignal := Class packageQuerySignal.
    nameSpaceQuerySignal := Class nameSpaceQuerySignal.
    usedNameSpaceQuerySignal := Class usedNameSpaceQuerySignal.

    (someone respondsTo:#packageToInstall) ifTrue:[
        pkg := someone packageToInstall.
        askSomeoneForPackage := true.
    ] ifFalse:[
        pkg := packageQuerySignal query.
        askSomeoneForPackage := false.
    ].
    (someone respondsTo:#currentNameSpace) ifTrue:[
        nameSpace := someone currentNameSpace
    ] ifFalse:[
        nameSpace := nameSpaceQuerySignal query.
    ].
    (someone respondsTo:#usedNameSpaces) ifTrue:[
        usedNameSpaces := someone usedNameSpaces
    ] ifFalse:[
        usedNameSpaces := usedNameSpaceQuerySignal query.
    ].
    (someone respondsTo:#defaultApplication) ifTrue:[
        defaultApplication := someone defaultApplication
    ] ifFalse:[
        defaultApplication := defaultApplicationQuerySignal query.
    ].

    confirmationQuerySignal := Metaclass confirmationQuerySignal.

    handledSignals := SignalSet new.
    passedSignals := IdentitySet new.

    handledSignals add:changeDefaultApplicationNotificationSignal.
    passedSignals add:changeDefaultApplicationNotificationSignal.
    handledSignals add:defaultApplicationQuerySignal.
    passedSignals add:defaultApplicationQuerySignal.

    handledSignals add:packageQuerySignal.
    handledSignals add:usedNameSpaceQuerySignal.
    handledSignals add:nameSpaceQuerySignal.
    handledSignals add:confirmationQuerySignal.
    passedSignals add:confirmationQuerySignal.
    Parser notNil ifTrue:[
        "only if libcomp is present"
        "Also catch a 'Parser askForVariableTypeOfUndeclaredQuery' and proceed with nil. 
         Imagine somebody has autodefine workspace variables on and then 
         evaluate Smalltalk loadPackage:'xyz' that loads code from source (using file-in), 
         certainly we don't want to compile workspace variable access for every
         not-yet-loaded class in some namespace. 
         This is demonstrated by Regression::CompilerTests2>>test_01 
         and this change actually fixes this test."
        askForVariableTypeOfUndeclaredQuery := Parser askForVariableTypeOfUndeclaredQuery.
        handledSignals add:askForVariableTypeOfUndeclaredQuery.
    ].


    outerContext := thisContext.

    handledSignals handle:[:ex |
        |sig|

        sig := ex creator.
        ((passedSignals includes:sig) and:[sig isHandledIn:outerContext]) ifTrue:[
            ex reject
        ].
        
        sig == changeDefaultApplicationNotificationSignal ifTrue:[
            "/ invoked via #becomeDefault to set the defaultApp and the package.
            "/ (only when filing in V'Age code)
            defaultApplication := ex parameter.
            pkg := defaultApplication name asSymbol.
            ex proceedWith:nil
        ].
        sig == defaultApplicationQuerySignal ifTrue:[
            "/ query for the application to add classes & methods into
            "/ (only when filing in V'Age code)
            ex proceedWith:defaultApplication
        ].
        sig == packageQuerySignal ifTrue:[
            "answer the package to use for classes & methods"
            askSomeoneForPackage ifTrue:[
                ex proceedWith:someone packageToInstall
            ] ifFalse:[
                ex proceedWith:pkg
            ]
        ].
        sig == usedNameSpaceQuerySignal ifTrue:[
            "answer the nameSpaces to be searched when encountering globals"
            ex proceedWith:usedNameSpaces
        ].
        sig == nameSpaceQuerySignal ifTrue:[
            "answer the nameSpace to install new classes in"
            ex proceedWith:nameSpace
        ].
        sig == confirmationQuerySignal ifTrue:[
            "don't pop up dialogs"
            ex proceedWith:false
        ].
        sig == askForVariableTypeOfUndeclaredQuery ifTrue:[
           "no autodefined variables or so"
            ex proceedWith:nil.
        ].
    ] do:[
        [self atEnd] whileFalse:[
            lastValue := self fileInNextChunkNotifying:someone passChunk:passChunk
        ]
    ].
    ^ lastValue

    "Modified: / 10.9.1999 / 16:54:01 / stefan"
    "Modified: / 16.11.2001 / 16:21:28 / cg"
    "Modified: / 18-03-2013 / 17:45:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EncodedStream methodsFor:'stream protocol'!

atEnd
    ^ stream atEnd
!

close
    stream close
!

contents

    ^String streamContents: [:s|
        [ self atEnd ] whileFalse:[
            |ch|
            ch := self next.
            "/ decoder may decide to return nil from #next, even though the
            "/ underlying stream was not at the end before. This is probably a bug...
            ch notNil ifTrue:[
                s nextPut: ch
            ]
        ]
    ]

    "Created: / 25-02-2010 / 23:34:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cr
    self nextPutAll:(Character cr asString)
!

emphasis:anObject

    stream emphasis:anObject

    "Created: / 15-06-2005 / 11:16:33 / janfrog"
!

flush
    stream flush
!

isEmpty
    ^ stream isEmpty
!

isOpen
    ^ stream notNil and:[stream isOpen]
!

next

    ^encoder readNextCharacterFrom:stream

    "Created: / 14-06-2005 / 17:01:39 / janfrog"
!

next:charactersToRead

    ^encoder readNext:charactersToRead charactersFrom:stream

    "Created: / 16-06-2005 / 11:43:43 / masca"
!

nextChunk
    "as a side effect, check for an encoding chunk"
    
    |prevEncoder chunk|

    chunk := stream nextChunk.
    chunk isNil ifTrue:[
        ^ nil
    ].
    prevEncoder := encoder.
    (prevEncoder isNullEncoder and:[stream isPositionable not]) ifTrue:[
        "/ not already checked
        "/ check if we need lazy setup of the encoder
        "/ (used with non-positionable streams)
        (chunk includesString:'{ Encoding:') ifTrue:[
            |enc|

            enc := self class encoderFor:(CharacterEncoder guessEncodingOfBuffer:chunk).
            enc notNil ifTrue:[
                prevEncoder := encoder := enc.
            ].
        ]
    ].
    ^ prevEncoder decodeString:chunk
!

nextChunkPut:chunk
    stream nextChunkPut:(encoder encodeString:chunk)
!

nextPut:aCharacter
    self nextPutAll:(aCharacter asString).
!

nextPutAll:aCollection
    encoder encodeString:aCollection on:stream 
!

nextPutAll:aCollection startingAt:start to:stop
    encoder encodeString:(aCollection copyFrom:start to:stop) on:stream.
!

peek

    ^stream peek

    "Created: / 20-06-2005 / 10:13:03 / masca"
    "Modified: / 20-06-2005 / 13:06:14 / masca"
!

peekFor:aCharacter
    ^ stream peekFor:aCharacter
!

position
    ^ stream position
!

position0Based
    <resource: #obsolete>
    "to be obsoleted - use position"

    ^ stream position
!

position0Based:newPosition
    <resource: #obsolete>
    "to be obsoleted - use position"

    stream position:newPosition
!

position1Based
    <resource: #obsolete>
    "to be obsoleted - use position"

    ^ stream position + 1
!

position1Based:newPosition
    <resource: #obsolete>
    "to be obsoleted - use position"

    stream position:newPosition-1
!

position:newPosition
    stream position:newPosition
!

reset
    stream reset

    "Created: / 25-02-2010 / 23:37:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setToEnd
    stream setToEnd
!

size
    "not always correct, but probably better than 0.
     Better use #isEmpty."

    "/ is that better?
    "/ self error:'size of input is unknown (due to decoding)'
    ^ stream size

    "Created: / 31-08-2012 / 16:52:40 / cg"
!

skip: anInteger

    "/ Should skip on character basis, not on bytes. This works for XML reader
    ^stream skip: anInteger

    "Created: / 20-06-2005 / 13:06:06 / masca"
!

skipSeparators
    ^ stream skipSeparators
!

sync
    stream sync
!

syncData
    stream syncData
! !

!EncodedStream methodsFor:'testing'!

isEncodedStream
    ^ true

    "Created: / 04-02-2014 / 20:27:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPositionable
    ^ stream isPositionable

    "Created: / 14-03-2014 / 16:18:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isReadable
    ^ stream isReadable
!

isWritable
    ^ stream isWritable
! !

!EncodedStream methodsFor:'utilities'!

skipEncodingChunk
    |pos chunk token|

    stream isPositionable ifFalse:[
        ^ self
    ].

    pos := self position.
    chunk := self nextChunk.
    [
        "/ if this is a valid chunk (i.e. not a comment or encoding-directive),
        "/ then position back, so it will be processed as usual.
"/ We could parse here, but this is overkill, since we are only interested in the fact,
"/ that there is anything else than a comment in the chunk.
"/        result := (Parser for:chunk)
"/            ignoreErrors:true;
"/            ignoreWarnings:true;
"/            parseMethodBody.

        token := (Scanner for:chunk)
                     ignoreErrors:true;
                     ignoreWarnings:true;
                     nextToken.

        token ~= #EOF ifTrue:[
            self position:pos
        ].
    ] on:Parser parseWarningSignal do:[:ex|
        "really ignore any error.
         Even setting ignorError will output diagnostics here
         during standalone startup when debugging"
        ex proceedWith:#ignore.
    ].

    "Modified: / 29-07-2011 / 17:42:11 / cg"
! !

!EncodedStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id: EncodedStream.st 10643 2011-06-08 21:53:07Z vranyj1  $'
! !

