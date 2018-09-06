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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

Object subclass:#FileOperation
	instanceVariableNames:'errorString result actionForAll'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support'
!

FileOperation subclass:#Copy
	instanceVariableNames:'copiedFiles newFiles'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileOperation
!

FileOperation::Copy subclass:#CopyCorrupted
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileOperation
!

FileOperation subclass:#Create
	instanceVariableNames:'createdFile'
	classVariableNames:'LastCreatedDirectory LastCreatedFile'
	poolDictionaries:''
	privateIn:FileOperation
!

FileOperation subclass:#Delete
	instanceVariableNames:'fileName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileOperation
!

FileOperation::Delete subclass:#Erase
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileOperation
!

FileOperation subclass:#Move
	instanceVariableNames:'movedFiles'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileOperation
!

FileOperation subclass:#Rename
	instanceVariableNames:'renamedFiles'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileOperation
!

!FileOperation class methodsFor:'documentation'!

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
! !

!FileOperation class methodsFor:'instance creation'!

copyCorruptedFile:aSourceFile to:aDestFile
    ^ CopyCorrupted new
        copyFile:aSourceFile to:aDestFile withOverWriteWarning:false copyFileIfSame:false

    "Created: / 07-02-2007 / 18:41:24 / cg"
!

copyFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarningBoolean copyFileIfSame:copyIfSameBoolean
    ^ Copy
	copyFile:aSourceFile to:aDestFile
	withOverWriteWarning:overWriteWarningBoolean
	copyFileIfSame:copyIfSameBoolean
!

copyFiles:aColOfSourceFiles to:aDirectory
    ^ Copy copyFiles:aColOfSourceFiles to:aDirectory
!

createDirectoryIn:aDirectory
    ^ Create createDirectoryIn:aDirectory
!

createDirectoryIn:aDirectory initialAnswer:defaultAnswer
    ^ Create createDirectoryIn:aDirectory initialAnswer:defaultAnswer
!

createFileIn:aDirectory
    ^ Create createFileIn:aDirectory
!

createHardLinkIn:dir
    ^ Create createHardLinkIn:dir
!

createLinkIn:dir soft:soft
    ^ Create createLinkIn:dir soft:soft
!

createSoftLinkIn:dir
    ^ Create createSoftLinkIn:dir
!

deleteFiles:colOfFiles confirm:confirm
    ^ Delete deleteFiles:colOfFiles confirm:confirm
!

eraseFiles:colOfFiles confirm:confirm
    ^ Erase deleteFiles:colOfFiles confirm:confirm
!

moveFile:aSourceFile to:aDestFile
    ^ Move moveFile:aSourceFile to:aDestFile
!

moveFiles:aCollectionOfFiles to:aDestDirectory
    ^ Move moveFiles:aCollectionOfFiles to:aDestDirectory
!

renameFile:filename to:newFileString
    ^ Rename renameFile:filename to:newFileString
!

renameFiles:aCollectionofFilenames
    ^ Rename renameFiles:aCollectionofFilenames
! !

!FileOperation class methodsFor:'defaults'!

suffixForCopyOverExistingFile
    ^ '.copy'
! !

!FileOperation class methodsFor:'queries'!

isAbstract
    ^ self == FileOperation
! !

!FileOperation methodsFor:'accessing'!

errorString
    ^ errorString
!

errorString:something
    errorString := something.
!

result
    ^ result
!

result:something
    result := something.
! !

!FileOperation methodsFor:'dialogs & helpers'!

checkDirectoryExists:aDirectory
    aDirectory exists ifFalse:[
        (Dialog confirm:(AbstractFileBrowser classResources 
                            stringWithCRs:'Non-existing directory: %1\\Create?' 
                            with:aDirectory asString)
        ) ifFalse:[
            ^ false
        ].
        aDirectory recursiveMakeDirectory.
        aDirectory exists ifFalse:[
            Dialog warn:(AbstractFileBrowser classResources 
                            string:'Failed to create directory: %1').
            ^ false
        ].
    ].
    aDirectory isDirectory ifFalse:[
        Dialog warn:('Not a directory: %1' bindWith:aDirectory asString).
        ^ false
    ].
    ^ true

    "Created: / 07-02-2007 / 18:30:49 / cg"
    "Modified: / 09-12-2010 / 08:45:45 / cg"
!

fileExistsDialogForNewFile:newFile oldFile:oldFile withCancel:withCancel
    "return true, if the file should be moved/copied.
     Ask user if oldFile exists."

    ^ self fileExistsDialogForNewFile:newFile oldFile:oldFile withCancel:withCancel withRemoveIfSame:false.
!

fileExistsDialogForNewFile:newFile oldFile:oldFile withCancel:withCancel withRemoveIfSame:withRemoveIfSame
    "return true, if the file should be moved/copied.
     If oldFile exists, ask user.
     If withRemoveIfSame is true, two additional possible values are returned:
        #removeSource and #removeDestination.
    "

    ^ self
        fileExistsDialogForNewFile:newFile oldFile:oldFile withCancel:withCancel withRemoveIfSame:withRemoveIfSame
        withAllAction:false

    "Modified: / 20-03-2012 / 11:44:51 / cg"
!

fileExistsDialogForNewFile:newFile oldFile:oldFile withCancel:withCancel withRemoveIfSame:withRemoveIfSame withAllAction:withAllAction
    "return true, if the file should be moved/copied.
     If oldFile exists, ask user.
     If withRemoveIfSame is true, two additional possible values are returned:
        #removeSource and #removeDestination.
    "

    |msg oldSize newSize sameContents resources sourceType destType labels values default olderOrNewer
     forAllHolder answer oldFileIsDirectory newFileIsDirectory oldFileTime newFileTime|

    newFile exists ifFalse:[ ^ true ].
    oldSize := oldFile fileSize.
    newSize := newFile fileSize.

    sameContents := false.
    oldFileIsDirectory := oldFile isDirectory.
    newFileIsDirectory := newFile isDirectory.

    newFileIsDirectory ifTrue:[
        oldFileIsDirectory ifTrue:[
            "/ could (should?) recursively look for same contents here...
        ].
    ] ifFalse:[
        oldFileIsDirectory ifFalse:[
            sameContents := oldSize = newSize and:[oldFile sameContentsAs:newFile].
        ]
    ].

    resources := AbstractFileBrowser classResources.

    "/ for now:
    oldFileIsDirectory ~~ newFileIsDirectory ifTrue:[
        Dialog warn:(resources string:'Will not overwrite directory with file and vice versa.').
        ^  false.
    ].

    sourceType := newFileIsDirectory ifTrue:'directory' ifFalse:'file'.
    destType := oldFileIsDirectory ifTrue:'directory' ifFalse:'file'.

    sameContents ifTrue:[
        msg := 'Overwrite existing destination %7:\\  %1\    size: %3 of %2\\with %8 source (same contents):\\  %4\    size: %6 of %5'.
    ] ifFalse:[
        msg := 'Overwrite existing destination %7:\\  %1\    size: %3 of %2\\with %8 source:\\  %4\    size: %6 of %5'.
    ].
    newFileTime := newFile modificationTime ? Timestamp now.
    oldFileTime := oldFile modificationTime ? Timestamp now.

    olderOrNewer := newFileTime < oldFileTime    
                    ifTrue:[ 'newer' ]
                    ifFalse:[ 'older' ].
    msg := resources
            stringWithCRs:msg
            withArgs:(Array
                with:newFile asString allBold
                with:(newFileTime printStringFormat:'%(Day)-%(mon)-%(year) %h:%m:%s')
                with:newSize
                with:oldFile asString allBold
                with:(oldFileTime printStringFormat:'%(Day)-%(mon)-%(year) %h:%m:%s')
                with:oldSize
                with:destType
                with:(resources string:olderOrNewer) ).

    (sameContents and:[withRemoveIfSame]) ifTrue:[
        labels := #( 'No' 'Remove Destination' 'Remove Source'  'Yes').
        values := #( false #removeDestination #removeSource true ).
        withCancel ifTrue:[ 
            labels := #('Cancel') , labels.
            values := #( nil ) , values. 
        ].
        default := #removeSource.
    ] ifFalse:[
        labels := #( 'No' 'Yes').
        values := #( false true ).
        withCancel ifTrue:[ 
            labels := #('Cancel') , labels.
            values := #( nil ) , values. 
        ].
        default := false.
    ].

    forAllHolder := false asValue.
    Dialog modifyingBoxWith:[:box |
        withAllAction ifTrue:[
            box addVerticalSpace:10.
            box verticalPanel 
                 add:(CheckBox 
                        label:'Same action for all' 
                        model:forAllHolder).
        ].
    ] do:[
        answer := OptionBox
              request:msg
              label:(resources string:'Overwrite existing file')
              image:(YesNoBox iconBitmap)
              buttonLabels:(resources array:labels)
              values:values
              default:default
              onCancel:nil.
    ].
    (withAllAction and:[answer notNil]) ifTrue:[
        actionForAll := answer
    ].
    ^ answer

    "Created: / 20-03-2012 / 11:44:34 / cg"
! !

!FileOperation methodsFor:'queries'!

isErase
    ^ false
! !

!FileOperation::Copy class methodsFor:'actions'!

copyFile:aSourceFile to:aDestFile
    |instance|

    instance := self new.
    instance copyFile:aSourceFile to:aDestFile.
    ^ instance
!

copyFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning
    |instance|

    instance := self new.
    instance copyFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning.
    ^ instance
!

copyFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarningBoolean copyFileIfSame:copyIfSameBoolean
    |instance|

    instance := self new.
    instance copyFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarningBoolean copyFileIfSame:copyIfSameBoolean.
    ^ instance
!

copyFiles:aColOfSourceFiles to:aDirectory
    |instance|

    instance := self new.
    instance copyFiles:aColOfSourceFiles to:aDirectory.
    ^ instance
!

copyFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning
    |instance|

    instance := self new.
    instance copyFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning.
    ^ instance
!

copyFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning copyFileIfSame:copy
    |instance|

    instance := self new.
    instance copyFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning copyFileIfSame:copy.
    ^ instance
! !

!FileOperation::Copy methodsFor:'accessing'!

colOfCopiedFiles
    "obsolete - bad name"

    ^ self collectionOfCopiedFiles
!

collectionOfCopiedFiles
    copiedFiles isNil ifTrue:[
	copiedFiles := OrderedCollection new.
    ].
    ^ copiedFiles
!

collectionOfNewFiles
    newFiles isNil ifTrue:[
	newFiles := OrderedCollection new.
    ].
    ^ newFiles
! !

!FileOperation::Copy methodsFor:'actions'!

copyFile:aSourceFile to:aDestFile
    self copyFile:aSourceFile to:aDestFile withOverWriteWarning:true
!

copyFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning
    self copyFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning copyFileIfSame:true
!

copyFiles:aColOfSourceFiles to:aDirectory
    ^ self copyFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:true.
!

copyFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning
    ^ self copyFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning copyFileIfSame:true.
! !

!FileOperation::Copy methodsFor:'actions-basic'!

basicCopy:aSourceFile to:newFile
    aSourceFile isDirectory ifTrue:[
        aSourceFile recursiveCopyTo:newFile.
        "/ OperatingSystem recursiveCopyDirectory:(aSourceFile pathName) to:(newFile pathName).
    ] ifFalse:[
        aSourceFile copyTo:newFile.
    ].

    "Created: / 07-02-2007 / 18:35:52 / cg"
!

copyFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarningBoolean copyFileIfSame:copyIfSameBoolean
    |newFile fileString targetDirectory suffix|

    aDestFile isDirectory ifTrue:[
        targetDirectory := aDestFile.
        newFile := aDestFile construct:(aSourceFile baseName).
    ] ifFalse:[
        targetDirectory := aDestFile directory.
        newFile := aDestFile.
    ].

    "/ do not copy if destination directory doesnt exist.
    (self checkDirectoryExists:targetDirectory) ifFalse:[
        result := false.
        ^ self
    ].
    (newFile exists) ifTrue:[
        ((newFile asString = aSourceFile asString) and:[copyIfSameBoolean]) ifTrue:[
            [newFile exists] whileTrue:[
                suffix := newFile suffix.
                fileString := newFile baseName withoutSuffix, self class suffixForCopyOverExistingFile, '.', suffix.
                newFile := targetDirectory construct:fileString.
            ].
        ] ifFalse:[
            overWriteWarningBoolean ifTrue:[
                (self fileExistsDialogForNewFile:newFile oldFile:aSourceFile withCancel:false withRemoveIfSame:false) ifFalse:[
                    result := false.
                    ^ self.
                ]
            ] ifFalse:[
                (Dialog confirm:('Destination "%1" exists - overwrite?' bindWith:aDestFile)) ifFalse:[
                    result := false.
                    ^ self.
                ]
            ]
        ].
    ].
    StreamError handle:[:ex|
        "was not able to copy it"
        newFile remove.
        WarningBox warn:'on copy file - ', ex description.
        self errorString:('on copy file - ', ex description asString).
        result := false.
        ^ self
    ] do:[
        self basicCopy:aSourceFile to:newFile.
    ].
    DirectoryContents flushCachedDirectoryFor:(aSourceFile directory).
    result := true.

    "Modified: / 07-02-2007 / 18:36:02 / cg"
!

copyFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning copyFileIfSame:copy
    |newFile suffix fileString doCopy|

    "/ do not copy if destination directory doest exist.
    (self checkDirectoryExists:aDirectory) ifFalse:[
	result := false.
	^ self
    ].

    aColOfSourceFiles do:[:filename |
	newFile := aDirectory construct:(filename baseName).
	doCopy := true.
	(newFile exists) ifTrue:[
	    ((newFile asString = filename asString) and:[copy]) ifTrue:[
		[newFile exists] whileTrue:[
		    suffix := newFile suffix.
		    fileString := newFile withoutSuffix baseName, self class suffixForCopyOverExistingFile.
		    suffix notEmpty ifTrue:[
			fileString := fileString, '.', suffix.
		    ].
		    newFile := aDirectory construct:fileString.
		].
	    ] ifFalse:[
		overWriteWarning ifTrue:[
		    doCopy := (self fileExistsDialogForNewFile:newFile oldFile:filename withCancel:(aColOfSourceFiles size > 1) withRemoveIfSame:false).
		    doCopy isNil ifTrue:[
			" abort pressed "
			result := false.
			^ self.
		    ]
		]
	    ].
	].
	doCopy ifTrue:[
	    Error handle:[:ex|
		|msg|

		msg := 'on copy file - ', ex description asString.
		"was not able to copy it"
		result := false.
		self errorString:msg.
		( Dialog
		    confirm:('Error ',msg)
		    title:'Copy'
		    yesLabel:'Continue'
		    noLabel:'Abort') ifTrue:[
			ex proceed.
		    ] ifFalse:[
			^ self.
		    ].
	    ] do:[
		self basicCopy:filename to:newFile
	    ].
	    self collectionOfCopiedFiles add:filename.
	    self collectionOfNewFiles add:newFile.
	]
    ].
    DirectoryContents flushCachedDirectoryFor:aDirectory.
    result := true.

    "Modified: / 07-02-2007 / 18:36:54 / cg"
! !

!FileOperation::CopyCorrupted methodsFor:'actions-basic'!

basicCopy:aSourceFile to:newFile
    aSourceFile isDirectory ifTrue:[
	newFile makeDirectory.
	aSourceFile directoryContentsDo:[:eachFileOrDirectory |
	    self basicCopy:(aSourceFile construct:eachFileOrDirectory) to:(newFile construct:eachFileOrDirectory)
	].
    ] ifFalse:[
	self basicCopyFile:aSourceFile to:newFile.
    ].

    "Created: / 07-02-2007 / 18:39:03 / cg"
!

basicCopyFile:sourceFile to:destFile
    "this is a copy which is tolerant w.r.t. read errors.
     Wheneven a read fails, a number of retries is performed
     (with smaller buffer sizes) and, a block of zeros is eventually written.
     This allows for partially corrupted data to be read from a tape or disk."

    |in in2 out doWrite doRead fileSize offset buffer bufferSize nRead nWritten nSingle
     lostStart lostEnd seekFailed|

    buffer := ByteArray new:(self bufferSize).
    bufferSize := buffer size.
    offset := 0.
    sourceFile info isCharacterSpecial ifTrue:[
    ] ifFalse:[
        fileSize := sourceFile fileSize.
    ].
    in := sourceFile readStream binary.
    out := destFile writeStream binary.

    doWrite := [:n |
                nWritten := out nextPutBytes:n from:buffer startingAt:1.
                offset := offset + nWritten.
                nWritten ~= n ifTrue:[
                    self error:'Write error'.
                ].
               ].

    doRead := [:n |
                ReadError handle:[:ex |
                    nRead := 0.
                    in position:offset.
                ] do:[
                    nRead := in nextBytes:n into:buffer startingAt:1.
                ].
               ].

    [
        [
            (fileSize notNil 
                ifTrue:[offset < fileSize]
                ifFalse:[true "in atEnd not"])
        ] whileTrue:[
            |n|

            n := fileSize notNil 
                    ifTrue:[ bufferSize min:(fileSize - offset) ]
                    ifFalse:[ bufferSize ].
            Transcript show:'read @'; showCR:offset.
            doRead value:n.
            nRead > 0 ifTrue:[
                lostStart notNil ifTrue:[
                    Transcript showCR:'CORRUPT: ',(lostStart printString),' .. ',(lostEnd printString).
                    lostStart := nil.
                ].
                doWrite value:nRead.
            ].

            nRead == n ifTrue:[
                bufferSize < buffer size ifTrue:[
                    bufferSize := bufferSize * 2.
                ].
            ] ifFalse:[
                nRead == 0 ifTrue:[
                    "/ try reading single blocks for a while...
                    nSingle := self defectBlockRetryCount.
                    [
                        nSingle > 0 
                        and:[
                            doRead value:(self defectBlockCopySize).
                            nRead > 0]
                    ] whileTrue:[
                        lostStart notNil ifTrue:[
                            Transcript showCR:'CORRUPT: ',(lostStart printString),' .. ',(lostEnd printString).
                            lostStart := nil.
                        ].
Transcript showCR:'single block at ',offset printString, 'size=',nRead printString.
                        doWrite value:nRead.
                        nSingle := nSingle - 1.
                    ].

                    nRead == 0 ifTrue:[
                        in2 := sourceFile readStream binary.
                        Error handle:[:ex |
                        ] do:[
                            in2 position:0.
                            in2 nextBytes:buffer size into:buffer startingAt:1.
                        ].
                        seekFailed := false.
                        Error handle:[:ex |
                            seekFailed := true.
                        ] do:[
                            in2 position:offset.
                        ].
                        seekFailed ifTrue:[
                            buffer atAllPut:0.
                            Transcript showCR:'bad seek at ',offset printString.
                            doWrite value:(self defectBlockCopySize).
                        ] ifFalse:[
                            in close.
                            in := in2.
                            doRead value:(self defectBlockCopySize).
                            nRead > 0 ifTrue:[
Transcript showCR:'single after reopen at ',offset printString.
                                doWrite value:nRead.
                            ] ifFalse:[
                                lostStart isNil ifTrue:[
                                    lostStart := lostEnd := offset.
                                ] ifFalse:[
                                    lostEnd := offset.
                                ].
                                buffer atAllPut:0.
Transcript showCR:'bad at ',offset printString.
                                doWrite value:(self defectBlockCopySize).
                                bufferSize := (self defectBlockCopySize).
                            ].
                        ]
                    ]
                ].
            ].
            Transcript show:'wrote @'; showCR:offset.
        ].
    ] ensure:[
        in close.
        out close.
    ].
    lostStart notNil ifTrue:[
        Transcript showCR:'CORRUPT: ',(lostStart printString),' .. ',(lostEnd printString).
        lostStart := nil.
    ].

    "Created: / 07-02-2007 / 18:40:32 / cg"
    "Modified: / 21-06-2010 / 14:25:22 / cg"
! !

!FileOperation::CopyCorrupted methodsFor:'defaults'!

bufferSize
    ^ 1024*1024*1

    "Created: / 21-06-2010 / 14:20:35 / cg"
!

defectBlockCopySize
    "/ ^ 256
    ^ 128*1024

    "Created: / 21-06-2010 / 14:22:23 / cg"
    "Modified: / 27-11-2010 / 18:06:10 / cg"
!

defectBlockRetryCount
    ^ 1

    "Created: / 21-06-2010 / 14:24:45 / cg"
    "Modified: / 27-11-2010 / 18:05:19 / cg"
! !

!FileOperation::Create class methodsFor:'actions'!

createDirectoryIn:aDirectory

    |instance|

    instance := self new.
    instance createDirectoryIn:aDirectory.
    ^ instance
!

createDirectoryIn:aDirectory initialAnswer:defaultAnswer

    |instance|

    instance := self new.
    instance createDirectoryIn:aDirectory initialAnswer:defaultAnswer.
    ^ instance
!

createFileIn:aFile

    |instance|

    instance := self new.
    instance createFileIn:aFile.
    ^ instance
!

createHardLinkIn:aFile
    "create an new hard link in a files directory"

    ^ self createLinkIn:aFile soft:false
!

createLinkIn:aFile soft:soft
    "create an new soft or hard link in a files directory"

    |instance|

    instance := self new.
    instance createLinkIn:aFile soft:soft.
    ^ instance
!

createSoftLinkIn:aFile
    "create an new soft link in a files directory"

    ^ self createLinkIn:aFile soft:true
! !

!FileOperation::Create methodsFor:'accessing'!

createdFile
    ^ createdFile
!

createdFile:something
    createdFile := something.
! !

!FileOperation::Create methodsFor:'actions'!

createDirectoryIn:startDirectory
    |defaultDirectory|

    "/ stupid - that one already exists
"/    LastCreatedDirectory notNil ifTrue:[
"/        defaultDirectory := LastCreatedDirectory baseName.
"/    ].

    ^ self createDirectoryIn:startDirectory initialAnswer:defaultDirectory
!

createHardLinkIn:aFile
    "create an new hard link in a files directory"

    self createLinkIn:aFile soft:false.
!

createSoftLinkIn:aFile
    "create an new soft link in a files directory"

    self createLinkIn:aFile soft:true.
!

operationError:msg
    self result:false.
    Dialog warn:msg.
    self errorString:msg.
! !

!FileOperation::Create methodsFor:'actions-basic'!

createDirectoryIn:startDirectory initialAnswer:initialAnswerArg
    |resources initialAnswer msg startBaseName newName newDir|

    resources := AbstractFileBrowser classResources.

    startBaseName := startDirectory baseName.
    initialAnswer := initialAnswerArg.
    (startDirectory construct:initialAnswer) exists ifTrue:[
        initialAnswer := nil.
    ].
    newName := Dialog
                    request:(resources string:'Create New Directory in %1:' with:startBaseName allBold)
                    initialAnswer:initialAnswer
                    okLabel:(resources string:'Create')
                    title:(resources string:'Create Directory')
                    onCancel:[
                        self result:false.
                        ^ self
                    ].
    newName isEmpty ifTrue:[
        self result:false.
        ^ self
    ].
    newDir := startDirectory construct:newName.
    newDir exists ifTrue:[
        Dialog warn:(newName, ' already exists.').
        result := false.
        ^ self
    ].

    OsError handle:[:ex|
        msg := errorString := 'cannot create directory "', newName,'" (', (OperatingSystem lastErrorString) , ')'.
        errorString := msg.
        Dialog warn:errorString.
        result := false.
        ^ self
    ] do:[
        newDir makeDirectory
    ].

    self createdFile:newDir.
    LastCreatedDirectory := newDir.
    result := true.

    "Modified: / 05-09-2006 / 11:52:48 / cg"
!

createFileIn:aFile
    "create an empty file"

    |resources aStream msg file directory newName defaultFile newFile|

    resources := AbstractFileBrowser classResources.

    aFile isDirectory ifTrue:[
        directory := aFile
    ] ifFalse:[
        directory := aFile directory.
        file := aFile
    ].
    LastCreatedFile isNil ifTrue:[
        defaultFile := aFile baseName.
    ] ifFalse:[
        defaultFile := LastCreatedFile baseName.
    ].
    newName := Dialog
                    request:(resources string:'Create New File in %1:' with:directory baseName allBold)
                    initialAnswer:defaultFile
                    okLabel:(resources string:'Create')
                    title:(resources string:'Create File')
                    onCancel:[
                        self result:false.
                        ^ self
                    ].
                    
    newName isEmptyOrNil ifTrue:[
        self result:false.
        ^ self
    ].
        
    newFile := directory construct:newName.

    (newFile exists) ifTrue:[
        (newFile isRegularFile) ifTrue:[
            newFile fileSize == 0 ifTrue:[
                Dialog
                    information:(resources stringWithCRs:'An empty "%1" (i.e. with size 0) already existed.' with:newName).
                self createdFile:newFile.
                self result:true.
                ^ self
            ].    
            (Dialog
                confirm:(resources stringWithCRs:'"%1" already exists (with size %2)\\Truncate ?' with:newName with:newFile fileSize)
                yesLabel:(resources string:'Truncate')
                noLabel:(resources string:'Cancel'))
            ifFalse:[
                self result:false.
                ^ self
            ].
        ] ifFalse:[
            Dialog warn:(resources stringWithCRs:'"%1" already exists as a %2' with:newFile fileType).
            self result:false.
            ^ self
        ].    
    ].
    
    FileStream openErrorSignal handle:[:ex|
        msg := resources string:'Cannot create file "%1" (%2)' with:newName with:(FileStream lastErrorString).
        errorString := msg.
        self result:false.
        Dialog warn:errorString.
        ^ self.
    ] do:[
        aStream := newFile newReadWriteStream.
    ].
    aStream close.
    self createdFile:newFile.
    LastCreatedFile := newFile.
    self result:true.
!

createLinkIn:aFile soft:symbolic
    "ask for the link target;
     then, create an new soft or hard link in aFile's directory"

    |resources newPath oldPath box string if1 if2|

    resources := AbstractFileBrowser classResources.

    newPath := (aFile isDirectory ifTrue:[ aFile ] ifFalse:[ aFile directory ]) asValue.
    oldPath := aFile asValue.

    box := Dialog new.
    box label:'Create Link'.

    string := 'Create ', (symbolic ifTrue:['Symbolic'] ifFalse:['Hard']) ,' Link from:'.
    box addTextLabel:(resources string:string) adjust:#left.
    if1 := box addFilenameInputFieldOn:oldPath in:nil tabable:true.
    box addTextLabel:(resources string:'to:') adjust:#left.
    if2 := box addFilenameInputFieldOn:newPath in:nil value tabable:true.

    box addAbortAndOkButtons.

    aFile isDirectory ifFalse:[
        box focusOnField:if1.
    ].
    box showAtPointer.

    box accepted ifFalse:[
        self result:false.
    ] ifTrue:[
        self doCreateLinkFrom:(oldPath value) to:(newPath value) soft:symbolic.
    ].

    "Modified: / 24-07-2011 / 08:24:14 / cg"
!

doCreateLinkFrom:oldPath to:newPathArg soft:symbolic
    "actually create a soft or hard link"

    |resources newPath newPathFile oldPathFile|

    newPath := newPathArg.

    resources := AbstractFileBrowser classResources.

    oldPath isNil ifTrue:[
        self operationError:'Missing source'.
        ^ self.
    ].
    newPath isNil ifTrue:[
        self operationError:'Missing link name (target)'.
        ^ self.
    ].

    newPathFile := newPath asFilename.
    oldPathFile := oldPath asFilename.

    newPathFile exists ifTrue:[
        newPathFile isDirectory ifTrue:[
            newPathFile := newPathFile construct:(oldPathFile baseName).
            newPath := newPathFile name.
        ].
    ].

    newPathFile exists ifTrue:[
        self operationError:(resources string:'%1 already exists' with:newPath allBold).
        ^ self.
    ].
    oldPathFile exists ifFalse:[
        symbolic ifTrue:[
            oldPathFile isAbsolute ifTrue:[
                self operationError:(resources string:'%1 does not exist' with:oldPath allBold).
                ^ self.
            ].
            (newPathFile directory construct:oldPath) exists ifFalse:[
                Dialog warn:(resources string:'%1 does not exist (Warning only)' with:oldPath allBold).
            ].
        ] ifFalse:[
            self operationError:(resources string:'%1 does not exist' with:oldPath allBold).
            ^ self.
        ].
    ].
    ((symbolic not) and:[oldPathFile isDirectory]) ifTrue:[
        self operationError:(resources string:'%1 is a directory' with:oldPath allBold).
        ^ self.
    ].
    ErrorSignal handle:[:ex |
        self operationError:ex description.
    ] do:[
        symbolic ifTrue:[
            newPathFile createAsSymbolicLinkTo:oldPathFile.
        ] ifFalse:[
            newPathFile createAsHardLinkTo:oldPathFile.
        ].
        self createdFile:newPathFile.
        self result:true.
    ].
! !

!FileOperation::Delete class methodsFor:'actions'!

deleteFile:aFileOrDirectory
    "delete aFileOrDirectory"

    |instance|

    instance := self new.
    instance deleteFile:aFileOrDirectory.
    ^ instance
!

deleteFiles:aCollectionOfFiles
    ^ self deleteFiles:aCollectionOfFiles confirm:true
!

deleteFiles:aCollectionOfFiles confirm:confirm
    "delete aCollectionOfFiles"

    |instance|

    instance := self new.
    instance deleteFiles:aCollectionOfFiles confirm:confirm.
    ^ instance
! !

!FileOperation::Delete methodsFor:'actions'!

deleteFiles:colOfFiles
    ^ self deleteFiles:colOfFiles confirm:true.
!

eraseFilesContentsBeforeRemoving:file
    "intentionally left blank"
! !

!FileOperation::Delete methodsFor:'actions-basic'!

deleteFile:aFileOrDirectory
    | file isDirectory |

    aFileOrDirectory notNil ifTrue:[
	file := aFileOrDirectory asFilename.

	isDirectory := file isDirectory.

	Error handle:[:ex|
	    "was not able to remove it"
	    Dialog warn:(ex description).
	    self errorString:(ex description).
	    result := false.
	    ^ self.
	] do:[
	    isDirectory ifTrue:[
		file recursiveRemove
	    ] ifFalse:[
		self eraseFilesContentsBeforeRemoving:file.
		file remove
	    ].
	].
	"/ flush parent directory or directory
    ].
    DirectoryContents flushCachedDirectoryFor:(file directory).
    result := true.

    "Modified: / 17-03-2004 / 12:42:02 / cg"
!

deleteFiles:colOfFiles confirm:confirm
    |resources answer nFilesToDelete ask labels values fileTypeString 
     msg lbls vals dontAskForNonEmptyDirectory nFilesDone|

    dontAskForNonEmptyDirectory := false.
    ask := confirm.
    resources := AbstractFileBrowser classResources.

    nFilesToDelete := colOfFiles size.
    nFilesDone := 0.
    colOfFiles do:[:filenameOrString |
        |filename doDelete skip|

        filename := filenameOrString asFilename.
        skip := false.
        fileTypeString := ''.
        filename isSymbolicLink ifTrue:[
            fileTypeString := 'symbolic link '.
        ] ifFalse:[
            filename exists ifFalse:[
                (Dialog
                    confirm:('%1 does not exist.' bindWith:filename asString allBold)
                    yesLabel:(resources string:'Proceed')
                    noLabel:(resources string:'Cancel'))
                ifFalse:[
                    ^ self.
                ].
                skip := true.
            ]
        ].
        skip ifFalse:[
            ask ifTrue:[
                nFilesToDelete = 1 ifTrue:[
                    labels := #('No' 'Yes').
                    values := #(#no #yes).
                ] ifFalse:[
                    labels := #('Cancel' 'No' 'Yes' 'Yes to All' ).
                    values := #(#cancel #no #yes #yesToAll).
                ].
                (Filename trashDirectoryOrNil notNil) ifTrue:[
                    filename directory pathName ~= Filename trashDirectoryOrNil pathName ifTrue:[
                        nFilesToDelete = 1 ifTrue:[
                            labels := labels , #('Move to Trash').  
                        ] ifFalse:[
                            labels := labels , #('Move all to Trash').
                        ].
                        values := values , #(#moveToTrash).
                    ].
                ].
                msg := self isErase ifTrue:'Really erase' ifFalse:'Really delete'.
                msg := msg ,
                       (nFilesToDelete = 1
                            ifTrue:'\\%1%2 ?'
                            ifFalse:'\\%1%2 \\(%3 files alltogether)').
                answer := Dialog
                    confirmWithCancel:(resources
                                        stringWithCRs:msg
                                        with:fileTypeString
                                        with:(filename asString allBold)
                                        with:nFilesToDelete)
                    labels:(resources array:labels)
                    values:values
                    default:(values indexOf:#yes).
            ] ifFalse:[
                answer := #yesToAll.
            ].

            answer == #cancel ifTrue:[
                ^ self.
            ].

            answer == #yesToAll ifTrue:[
                ask := false.
                answer := #yes.
            ].
            answer == #moveToTrash ifTrue:[
                |trashFn nr|

                ask := false.
                ProgressNotification progressPercentage:(nFilesDone / nFilesToDelete)*100.
                trashFn := Filename trashDirectoryOrNil construct:filename baseName.
                [trashFn exists] whileTrue:[
                    nr := (nr ? 0) + 1.
                    trashFn := Filename trashDirectoryOrNil construct:filename baseName,'.',nr printString.
                ].
                filename moveTo:trashFn.
                nFilesDone := nFilesDone + 1.
            ] ifFalse:[
                answer == #yes ifTrue:[
                    doDelete := true.
                    filename isSymbolicLink ifFalse:[
                        dontAskForNonEmptyDirectory ifFalse:[
                            filename isNonEmptyDirectory ifTrue:[
                                colOfFiles size == 1 ifTrue:[
                                    lbls := #('Cancel' 'Remove').
                                    vals := #(false true).
                                ] ifFalse:[
                                    lbls := #('Cancel All' 'Keep' 'Remove' 'Remove All').
                                    vals := #(nil false true #removeAll).
                                ].
                                doDelete := Dialog
                                            confirmWithCancel:(resources
                                                                stringWithCRs:'Directory ''%1'' is not empty\remove anyway ?'
                                                                with:filename pathName allBold)
                                            labels:( resources array:lbls )
                                            values:vals
                                            default:(vals indexOf:true).
                                doDelete == nil ifTrue:[
                                    ^ self
                                ].
                                doDelete == #removeAll ifTrue:[
                                    dontAskForNonEmptyDirectory := true.
                                    doDelete := true.
                                ].
                            ].
                        ].
                    ].
                    doDelete ifTrue:[
                        ProgressNotification progressPercentage:(nFilesDone / nFilesToDelete)*100.
                        self deleteFile:filename.
                        nFilesDone := nFilesDone + 1.
                    ]
                ].
            ].
            ProgressNotification progressPercentage:(nFilesDone / nFilesToDelete)*100.
        ].
    ].

    "Modified: / 11-10-2010 / 13:08:20 / cg"
! !

!FileOperation::Erase methodsFor:'actions-basic'!

eraseFilesContentsBeforeRemoving:file
    "fill file with zeros (to be really erased from the disk).
     We use this, if the file contains security relevant data (such as crypto-keys)"

    |writeStream fileSize remaining buffer bufferSize nWritten|

    fileSize := file fileSize.
    writeStream := file asFilename readWriteStream.
    [
        remaining := fileSize.
        bufferSize := 8192.
        buffer := ByteArray new:bufferSize.

        [remaining > 0] whileTrue:[
            nWritten := writeStream
                            nextPutBytes:(bufferSize min:remaining)
                            from:buffer.  
            remaining := remaining - nWritten.
            ProgressNotification progressPercentage:(1 - (remaining / fileSize))*100.
        ].
    ] ensure:[
        writeStream close.
    ].

    "Modified: / 07-02-2007 / 18:20:21 / cg"
! !

!FileOperation::Erase methodsFor:'queries'!

isErase
    ^ true
! !

!FileOperation::Move class methodsFor:'actions'!

moveFile:aSourceFile to:aDestFile
    |instance|

    instance := self new.
    instance moveFile:aSourceFile to:aDestFile.
    ^ instance
!

moveFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning
    |instance|

    instance := self new.
    instance moveFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning.
    ^ instance
!

moveFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning moveFileIfSame:move
    |instance|

    instance := self new.
    instance moveFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning moveFileIfSame:move.
    ^ instance
!

moveFiles:aColOfSourceFiles to:aDirectory
    |instance|

    instance := self new.
    instance moveFiles:aColOfSourceFiles to:aDirectory.
    ^ instance
!

moveFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning
    |instance|

    instance := self new.
    instance moveFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning.
    ^ instance
!

moveFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning moveFileIfSame:move
    |instance|

    instance := self new.
    instance moveFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning moveFileIfSame:move.
    ^ instance
! !

!FileOperation::Move methodsFor:'accessing'!

colOfMovedFiles
    "obsolete - bad name"

    ^ self collectionOfMovedFiles
!

collectionOfMovedFiles
    movedFiles isNil ifTrue:[
	movedFiles := OrderedCollection new.
    ].
    ^ movedFiles
! !

!FileOperation::Move methodsFor:'actions'!

moveFile:aSourceFile to:aDestFile

    ^ self moveFile:aSourceFile to:aDestFile withOverWriteWarning:true.
!

moveFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning

    ^ self moveFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning moveFileIfSame:true
!

moveFiles:aColOfSourceFiles to:aDirectory

    ^ self moveFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:true
!

moveFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning

    ^ self moveFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning moveFileIfSame:true
! !

!FileOperation::Move methodsFor:'actions-basic'!

moveFile:aSourceFile to:aDestFile withOverWriteWarning:overWriteWarning moveFileIfSame:move

    |newFile fileString targetDirectory targetIsDirectory suffix doMove|

    targetIsDirectory := aDestFile isDirectory.
    targetIsDirectory ifTrue:[
        targetDirectory := aDestFile.
        newFile := aDestFile construct:(aSourceFile baseName).
    ] ifFalse:[
        targetDirectory := aDestFile directory.
        newFile := aDestFile.
    ].
    "/ do not copy if destination directory doest exist.
    targetDirectory exists ifFalse:[
        Dialog warn:'Cannot move to non-existing directory ', targetDirectory asString.
        result := false.
        ^ self
    ].
    (newFile exists) ifTrue:[
        ((newFile asString = aSourceFile asString) and:[move]) ifTrue:[
            [newFile exists] whileTrue:[
                suffix := newFile suffix.
                fileString := newFile baseName withoutSuffix, self class suffixForCopyOverExistingFile, '.', suffix.
                newFile := targetDirectory construct:fileString.
            ].
        ] ifFalse:[
            overWriteWarning ifTrue:[
                doMove := self fileExistsDialogForNewFile:newFile oldFile:aSourceFile withCancel:false withRemoveIfSame:true.
                doMove == #removeSource ifTrue:[
                    self shouldImplement.
                    result := false.
                    ^ self.
                ].
                doMove == #removeDestination ifTrue:[
                    self shouldImplement.
                    result := false.
                    ^ self.
                ].
                doMove == true ifFalse:[
                    result := false.
                    ^ self.
                ].

            ] ifFalse:[
                result := false.
                ^ self.
            ]
        ].
    ].
    Error handle:[:ex|
        "was not able to copy it"
        WarningBox warn:'Error in move file operation: ', ex description.
        self errorString:('Error in move file operation- ', ex description asString).
        result := false.
        ^ self
    ] do:[
        aSourceFile moveTo:newFile.
    ].
    DirectoryContents flushCachedDirectoryFor:(aSourceFile directory).
    result := true.
!

moveFiles:aColOfSourceFiles to:aDirectory withOverWriteWarning:overWriteWarning moveFileIfSame:move

    |newFile suffix fileString doMove doRemoveSource doRemoveDestination|

    aDirectory exists ifFalse:[
        (Dialog confirm:(AbstractFileBrowser classResources
                            stringWithCRs:'Non-existing directory "%1" .\Create ?'
                            with:aDirectory asString allBold)) ifFalse:[
            result := false.
            ^ self
        ].
        aDirectory makeDirectory.
        aDirectory exists ifFalse:[
            Dialog warn:(AbstractFileBrowser classResources
                                stringWithCRs:'Cannot create directory "%1" !!\Create ?.'
                                with:aDirectory asString allBold).
            result := false.
            ^ self
        ]
    ].
    (aDirectory isDirectory) ifFalse:[
        Dialog warn:('Destination %1 is not a directory.' bindWith:aDirectory asString allBold).
        result := false.
        ^ self
    ].
    aColOfSourceFiles do:[: filename |
        newFile := aDirectory construct:filename baseName.

        doMove := true.
        doRemoveSource := false.
        doRemoveDestination := false.

        (newFile exists) ifTrue:[
            ((newFile asString = filename asString) and:[move]) ifTrue:[
                [newFile exists] whileTrue:[
                    suffix := newFile suffix.
                    fileString := newFile withoutSuffix baseName , self class suffixForCopyOverExistingFile, '.', suffix.
                    newFile := aDirectory construct:fileString.
                ].
            ] ifFalse:[
                overWriteWarning ifTrue:[
                    (doMove := actionForAll) isNil ifTrue:[
                        doMove := self 
                                    fileExistsDialogForNewFile:newFile oldFile:filename 
                                    withCancel:(aColOfSourceFiles size > 1) withRemoveIfSame:true
                                    withAllAction: true.
                        doMove isNil ifTrue:[   "/ cancel
                            result := false.
                            ^ self.
                        ].
                    ].
                    (doMove == #removeSource) ifTrue:[
                        doRemoveSource := true.
                        doMove := false
                    ] ifFalse:[
                        (doMove == #removeDestination) ifTrue:[
                            doRemoveDestination := true.
                            doMove := false
                        ]
                    ]
                ]
            ].
        ].

        (doMove or:[doRemoveSource or:[doRemoveDestination]]) ifTrue:[
            Error handle:[:ex|
                "was not able to copy it"
                |descriptionString|

                result := false.
                descriptionString := ex description asString.
                self errorString:(' Error in Move-File Operation:', descriptionString).
                ( Dialog
                    confirm:(' Error in Move-File Operation: ', descriptionString)
                    title:'Move'
                    yesLabel:'Continue'
                    noLabel:'Abort'
                ) ifFalse:[
                    ^ self.
                ].
            ] do:[
                doRemoveSource ifTrue:[
                    filename remove
                ] ifFalse:[
                    doRemoveDestination ifTrue:[
                        newFile remove
                    ] ifFalse:[
                        filename moveTo:newFile.
                    ]
                ]
            ].
            self collectionOfMovedFiles add:filename
        ]
    ].
    DirectoryContents flushCachedDirectoryFor:aDirectory.
    result := true.

    "Modified: / 20-03-2012 / 11:53:35 / cg"
! !

!FileOperation::Rename class methodsFor:'actions'!

renameFile:oldFile to:newName
    |instance|

    instance := self new.
    instance renameFile:oldFile to:newName.
    ^ instance
!

renameFiles:aColOfFiles
    |instance|

    instance := self new.
    instance renameFiles:aColOfFiles.
    ^ instance
! !

!FileOperation::Rename methodsFor:'accessing'!

renamedFiles
    renamedFiles isNil ifTrue:[
	renamedFiles := OrderedCollection new.
    ].
    ^ renamedFiles
! !

!FileOperation::Rename methodsFor:'actions-basic'!

renameFile:oldFile to:newName
    "rename a file (or directory)"

    |newFile msg resources sameFile|

    (oldFile isNil or:[newName isNil]) ifTrue:[
        result := false.
        ^ self.
    ].
    (oldFile asString isBlank or:[newName isBlank]) ifTrue:[
        result := false.
        ^ self.
    ].
    newName asFilename isAbsolute ifTrue:[
        newFile := newName asFilename.
    ] ifFalse:[
        (oldFile baseName = newName) ifTrue:[
            result := false
        ].
        newFile := oldFile directory construct:newName.
    ].

    oldFile pathName = newFile pathName ifTrue:[
        ^ self.
    ].
    Filename isCaseSensitive ifFalse:[
        sameFile := (oldFile pathName sameAs: newFile pathName)
    ] ifTrue:[
        sameFile := false
    ].

    resources := Dialog classResources.

    OsError handle:[:ex|
        msg := resources
                stringWithCRs:'Cannot rename file %1 to %2 !!\\(%3)'
                with:oldFile baseName
                with:newName
                with:ex errorString.
        Dialog warn:msg.
        result := false.
        ^ self.
    ] do:[
        sameFile ifFalse:[
            newFile exists ifTrue:[
                (newFile sameContentsAs:oldFile) ifTrue:[
                    msg := '%1 exists [with same contents] - rename (i.e. overwrite) anyway ?'
                ] ifFalse:[
                    msg := '%1 exists - rename (i.e. overwrite) anyway ?'
                ].
                (Dialog confirmWithCancel:(resources string:msg with:newName allBold) default:false) ifFalse:[
                    result := false.
                    ^ self.
                ]
            ].
        ].
        oldFile renameTo:newFile.
        self renamedFiles add:newFile.
    ].
    result := true.

    "Modified: / 21-09-2006 / 18:32:12 / cg"
!

renameFiles:aColOfFiles
    |resources queryBox b lastNewName lastOldName initialText oldName newName renameAll doRename|

    resources := AbstractFileBrowser classResources.
    renameAll := false.

    queryBox := FilenameEnterBox new.
    queryBox okText:(resources string:'Rename').

    aColOfFiles size > 1 ifTrue:[
        b := queryBox addAbortButtonLabelled:(resources string:'Cancel All').
        b action:[^ self].
        queryBox addButton:(Button label:(resources string:'Rename All') action:[renameAll := true. queryBox okPressed]) before:(queryBox okButton).
    ].
    aColOfFiles do:[:oldFile |
        oldName := oldFile baseName asString.
        lastNewName notNil ifTrue:[
            initialText := DoWhatIMeanSupport goodRenameDefaultForFile:oldName lastOld:lastOldName lastNew:lastNewName.
        ].
        doRename := false.
        (renameAll and:[initialText notNil]) ifTrue:[
            doRename := true.
            newName := initialText.
        ] ifFalse:[
            queryBox title:(resources string:'Rename %1 to:' with:(oldName allBold)).
            queryBox initialText:(initialText ? oldName).
            queryBox action:[:newEnteredName | newName := newEnteredName. doRename := true.].
            queryBox show "showAtPointer".
            "/ queryBox accepted ifFalse:[self halt].
        ].
        doRename ifTrue:[
            (self renameFile:oldFile to:newName asString) ifTrue:[
                result := true
            ].
            lastOldName := oldName.
            lastNewName := newName.
        ].
    ]
! !

!FileOperation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

