"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

Object subclass:#URITransmission
	instanceVariableNames:'readFromUri writeToUri historyUri interval activeTime infoChannel
		transmissionInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-URI'
!

!URITransmission class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    readFromUri and writeToUri
        pathsegment of both have to be the same, 
        like a directory path or a file path.



    [author:]
        Timo Merkert (tm@asterix)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!URITransmission class methodsFor:'instance creation'!

fromString:aString

    |read write aCollectionOfWords|

    aCollectionOfWords := aString asCollectionOfWords.

    read    := URI fromString:(aCollectionOfWords at:1).
    write   := URI fromString:(aCollectionOfWords at:2).

    ^ self new
        readFromUri:read
        writeToUri:write
        interval:(Number readFrom:(aCollectionOfWords at:3 ifAbsent:'') onError:nil).


"
    self fromString:'file:/tmp/test/transmission  
                          ftp://asterix.exept.de/home/tm/tmp  
                          10'  
"
!

fromString:aString onError:anExceptionBlock

    ^ Error handle:[:ex|
        anExceptionBlock value
    ] do:[
        self fromString:aString
    ].


"
    self fromString:('file:/tmp/test/transmission  
                          ftp://tm:password@asterix.exept.de/home/tm/tmp  
                          10') onError:nil
"
! !

!URITransmission class methodsFor:'default access'!

ftpMoveToFilenameSuffix

    ^ '.old'
!

moveToSubDirectoryName

    ^ 'history'
!

transferBufferSize
    ^ 8 * 1024
! !

!URITransmission methodsFor:'accessing'!

activeTime
    "return the value of the instance variable 'activeTime' (automatically generated)"

    ^ activeTime
!

activeTime:aTimestamp
    "set the value of the instance variable 'activeTime' (automatically generated)"

    activeTime := aTimestamp.
!

infoChannel:something
    "set the value of the instance variable 'infoChannel' (automatically generated)"

    infoChannel := something.
!

interval
    "return the value of the instance variable 'interval' (automatically generated)"

    ^ interval
!

interval:minutes
    "set the value of the instance variable 'interval' (automatically generated)"

    interval := minutes.
!

readFromUri
    "return the value of the instance variable 'readFromUri' (automatically generated)"

    ^ readFromUri
!

readFromUri:anURI
    "set the value of the instance variable 'readFromUri' (automatically generated)"

    readFromUri := anURI.
!

transmissionInfo
    ^ transmissionInfo
!

writeToUri
    "return the value of the instance variable 'writeToUri' (automatically generated)"

    ^ writeToUri
!

writeToUri:anURI
    "set the value of the instance variable 'writeToUri' (automatically generated)"

    writeToUri := anURI.
! !

!URITransmission methodsFor:'actions'!

advanceFrom:aTimestamp

    activeTime := aTimestamp addMinutes:(interval ? 0)
!

doCommit
    "perform the transmission"

    |copyBlock|

    copyBlock := 
        [:aReadStream :readAttributes | 
            |readUri copyUri infoStream|

            (readAttributes at:#requestDirectory) ifTrue:[
                copyUri := writeToUri construct:(readAttributes at:#baseName)
            ] ifFalse:[
                copyUri := writeToUri.
            ].

            self copyStream:aReadStream toUri:copyUri.

            readUri := readAttributes at:#uriInfo.
            infoStream := '' writeStream.
            readUri isRemote ifTrue:[
                infoStream nextPutAll:'GET'
            ] ifFalse:[
                infoStream nextPutAll:'PUT'
            ].
            infoStream nextPutAll:' ('.
            readUri publicPrintOn:infoStream.
            infoStream nextPutAll:') ('.
            copyUri publicPrintOn:infoStream.
            infoStream nextPutAll:')'.
            self info:infoStream contents.
        ].
    
    StreamError 
        handle:[:ex | 
            ex errorString:('From:(%1) %2' bindWith:readFromUri with:ex description).
            ex reject
        ]
        do:[
            readFromUri scheme = #file ifTrue:[
                readFromUri 
                    readStreamsDo:copyBlock
                    filterBlock:nil
                    renameBlock:[:aFilenameString | 
                            |historyDirectory filename|

                            filename := aFilenameString asFilename.
                            historyDirectory := filename directory construct:self class moveToSubDirectoryName.
                            historyDirectory exists ifFalse:[
                                historyDirectory makeDirectory.
                            ].
                            historyDirectory construct:filename baseName
                        ].
            ] ifFalse:[
                readFromUri 
                    readStreamsDo:copyBlock
                    filterBlock:[:baseName| (baseName asString endsWith:self class ftpMoveToFilenameSuffix) not]
                    renameBlock:[:aFilenameString | 
                            aFilenameString , self class ftpMoveToFilenameSuffix
                        ].
            ].
        ].
! !

!URITransmission methodsFor:'helpers'!

copyStream:aReadStream toUri:writeUri 
    "copy the contents of aReadStream to writeUri"
    
    writeUri 
        writeStreamDo:[:aWriteStream :writeAttributes | 
                (aWriteStream notNil and:[aWriteStream isWritable]) ifTrue:[
                    aWriteStream copyToEndFrom:aReadStream.
                ] ifFalse:[
                    OperatingSystem fileNotFoundErrorSignal
                        raiseRequestWith:writeUri path
                        errorString:('Error creating %1 for writing' bindWith:writeUri)
                ].
            ]
        create:true
        atomic:true
! !

!URITransmission methodsFor:'instance creation'!

readFromUri:readFromUriArg writeToUri:writeToUriArg 
    "set instance variables (automatically generated)"

    readFromUri := readFromUriArg.
    writeToUri  := writeToUriArg.
!

readFromUri:readFromUriArg writeToUri:writeToUriArg interval:intervalArg
    "set instance variables (automatically generated)"

    readFromUri := readFromUriArg.
    writeToUri  := writeToUriArg.
    interval    := intervalArg.
! !

!URITransmission methodsFor:'notification'!

errorInfo:aMessage

    |text|

    text := Text string:aMessage color:Color red.

    infoChannel isNil ifTrue:[
        Transcript showCR:text.
        ^ self
    ].

    infoChannel value:text
!

info:aMessage

    infoChannel isNil ifTrue:[
        Transcript showCR:aMessage.
        ^ self
    ].

    infoChannel value:aMessage
! !

!URITransmission class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/URITransmission.st,v 1.23 2018-02-06 16:43:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/URITransmission.st,v 1.23 2018-02-06 16:43:49 cg Exp $'
! !

