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
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Archiver
	instanceVariableNames:'process temporaryDirectory fileName outStream errorStream
		synchron'
	classVariableNames:'MimeTypeMapping'
	poolDictionaries:''
	category:'System-Support-FileFormats'
!

Archiver subclass:#MultiFileArchive
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Object subclass:#ArchiverOutputParser
	instanceVariableNames:'firstLineRead archiver'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver subclass:#CompressedFile
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver::CompressedFile subclass:#BZ2Compressed
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver subclass:#CompressedTarArchive
	instanceVariableNames:'tarArchiver tarFile'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver::CompressedFile subclass:#GZipCompressed
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver::MultiFileArchive subclass:#ArArchive
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver::MultiFileArchive subclass:#TarArchive
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver::CompressedTarArchive subclass:#TarBZ2Archive
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver::CompressedTarArchive subclass:#TarGZipArchive
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver::MultiFileArchive subclass:#XarArchive
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver::MultiFileArchive subclass:#ZipArchive
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

!Archiver class methodsFor:'documentation'!

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
    this is a soon to be obsoleted helper class for the fileBrowser.
    it wraps OS-specific command line archivers (tar, zip, rar, etc)
    into a common protocol useful to display an archive's contents.

    will be removed - do not use for your projects.
"
! !

!Archiver class methodsFor:'initialization'!

initializeMimeTypeMapping
    MimeTypeMapping := Dictionary 
        withKeysAndValues:
            #(
                'application/x-tar-compressed'         CompressedTarArchive     "abstract - special handling"
                'application/x-tar-gzip-compressed'    TarGZipArchive       
                'application/x-tar-bzip2-compressed'   TarBZ2Archive        
                'application/x-tar'                    TarArchive          
                'application/x-gzip-compressed'        GZipCompressed      
                'application/x-zip-compressed'         ZipArchive          
                'application/x-bzip2-compressed'       BZ2Compressed       
                'application/x-squeak-archive'         ZipArchive          
                'application/x-squeak-monticello-archive'     ZipArchive          
                'application/java-archive'             ZipArchive          
                'application/x-xar'                    XarArchive "/ on OSX         

                'application/x-ar-archive'             ArArchive           
                'application/x-ar-library'             ArArchive           
                'application/library'                  ArArchive           

"/       'application/x-rpm'                    RPMArchive          
"/       'application/x-rpm-archive'            RPMArchive          
"/       'application/x-redhat packet manager'  RPMArchive  

                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ZipArchive

                'application/x-expecco-testsuite'   ZipArchive
            ).

    "Modified: / 01-12-2011 / 21:25:08 / cg"
! !

!Archiver class methodsFor:'instance creation'!

classForMimeType:aMimeType fileName:aFileNameOrNil
    |className|

    MimeTypeMapping isNil ifTrue:[
        self initializeMimeTypeMapping
    ].    
    className := MimeTypeMapping at:aMimeType ifAbsent:nil.
    className isNil ifTrue:[
        "/ hard coded heuristics...
        aFileNameOrNil asFilename suffix = 'mcz' ifTrue:[^ ZipArchive].
        ^ nil
    ].

    className = #CompressedTarArchive ifTrue:[
        (aFileNameOrNil notNil and:[aFileNameOrNil suffix = 'bz2']) ifTrue:[
            className := #TarBZ2Archive
        ] ifFalse:[
            "this is the default"
            className := #TarGZipArchive
        ]
    ].
    ^ self privateClassesAt:className.

    "
     self classForMimeType:nil fileName:nil   
     self classForMimeType:'application/x-tar-compressed' fileName:nil   
     self classForMimeType:'application/x-tar' fileName:nil   
     self classForMimeType:'application/x-foo' fileName:nil   
     self classForMimeType:'application/x-squeak-archive' fileName:nil  
     self classForMimeType:'application/java-archive' fileName:nil 
     'foo.sar' asFilename mimeTypeFromName               
     'foo.jar' asFilename mimeTypeFromName               
     'foo.a' asFilename mimeTypeFromName               
    "

    "Modified: / 01-12-2011 / 21:26:24 / cg"
!

new
    ^ super new
!

newFor:aFilename
    |fn archiverClass|

    fn := aFilename asFilename.
    archiverClass := self classForMimeType:fn mimeTypeFromName fileName:fn.
    archiverClass isNil ifTrue:[^ nil].
    ^ archiverClass with:fn
!

with:aFilename
    ^ self new fileName:aFilename.
! !

!Archiver class methodsFor:'classAccess'!

arArchive

    ^ ArArchive
!

gzipArchive
    ^ GZipCompressed
!

tarArchive

    ^ TarArchive
!

tarGZipArchive

    ^ TarGZipArchive
!

zipArchive

    ^ ZipArchive
! !

!Archiver class methodsFor:'columns'!

columns
    self subclassResponsibility
! !

!Archiver class methodsFor:'command strings'!

stringWithQuotedFileBaseNames:aColOfFiles

    aColOfFiles isNil ifTrue:[^ ''].

    ^ String 
        streamContents:[:str |
            aColOfFiles do:[:fn | 
                str nextPutAll:' "'.
                str nextPutAll:(fn asFilename baseName).
                str nextPutAll:'"'.
            ].
        ]
! !

!Archiver class methodsFor:'commandOutputReader'!

commandOutputParser
    ^ self commandOutputParserClass new
!

commandOutputParserClass
    ^ ArchiverOutputParser
! !

!Archiver class methodsFor:'queries'!

canAddFiles

    ^ false
!

canDragnDrop

    ^ true.
!

canExtractFiles

    ^ false
!

canRemoveFiles

    ^ false
!

canViewFile

    ^ false
!

hasTitleLine

    ^ false
!

isAbstract
    ^ self == Archiver
! !

!Archiver methodsFor:'accessing'!

errorStream
    "return the value of the instance variable 'errorStream' (automatically generated)"

    ^ errorStream
!

errorStream:something
    "set the value of the instance variable 'errorStream' (automatically generated)"

    errorStream := something.
!

fileName
    "return the value of the instance variable 'fileName' (automatically generated)"

    ^ fileName
!

fileName:something
    "set the value of the instance variable 'fileName' (automatically generated)"

    fileName := something.
!

outStream
    "return the value of the instance variable 'outStream' (automatically generated)"

    ^ outStream
!

outStream:something
    "set the value of the instance variable 'outStream' (automatically generated)"

    outStream := something.
!

outStream:anOutStream errorStream:anErrorStream synchron:aBoolean
    outStream := anOutStream.
    errorStream := anErrorStream.
    synchron := aBoolean
!

process
    "return the value of the instance variable 'process' (automatically generated)"

    ^ process
!

process:something
    "set the value of the instance variable 'process' (automatically generated)"

    process := something.
!

synchron
    "return the value of the instance variable 'synchron' (automatically generated)"

    ^ synchron
!

synchron:something
    "set the value of the instance variable 'synchron' (automatically generated)"

    synchron := something.
!

temporaryDirectory
    "return the value of the instance variable 'temporaryDirectory' (automatically generated)"

    temporaryDirectory isNil ifTrue:[
        temporaryDirectory := Filename newTemporaryDirectory.
    ].
    ^ temporaryDirectory
! !

!Archiver methodsFor:'actions'!

extractFilesTo:aDirectory
    self extractFiles:nil to:aDirectory
!

getCommandToListFiles:aColOfFiles
    self subclassResponsibility.
!

listFiles:aColOfFiles
    |cmd dir|

    self fileName isNil ifTrue:[ ^ self].
    dir := self fileName directory.
    cmd := self getCommandToListFiles:aColOfFiles.
    cmd isNil ifTrue:[
        errorStream nextPutLine:'No command to list the archive.'.
        ^ self
    ].
    self executeCommand:cmd directory:dir

    "Modified: / 16-09-2011 / 16:33:50 / cg"
!

removeFilesFromArchive:aColOfFiles
    self subclassResponsibility.
! !

!Archiver methodsFor:'actions-basic'!

addFilesToArchive:colOfFiles
    self subclassResponsibility.
!

extractFiles:aColOfFilesOrNil to:aDirectory
    self subclassResponsibility.
! !

!Archiver methodsFor:'actions-private'!

removeTemporaryDirectory
    temporaryDirectory notNil ifTrue:[
        self temporaryDirectory recursiveRemove.
        temporaryDirectory := nil.
    ].
!

stopProcess
    |p|

    p := process.
    p notNil ifTrue:[
        p terminateGroup.
        p waitUntilFinished.
        process := nil.
    ].
! !

!Archiver methodsFor:'command execution'!

executeCommand:cmd directory:aDirectory
    |osProcess|

    cmd isNil ifTrue:[
        errorStream nextPutAll:'No command for archive operation.'.
        ^ false
    ].
    osProcess := OSProcess new
                    command:cmd;
                    lineWise:true;          "do it lineWise, since outStream may be an ActorStream"
                    outStream:outStream;
                    errorStream:errorStream;
                    directory:aDirectory.

    synchron isNil ifTrue:[synchron := true].
    synchron ifTrue:[
        ^ osProcess execute.
    ] ifFalse:[
        osProcess terminateActionBlock:[process := nil].
        process := osProcess.
        ^ osProcess startProcess.
    ]

    "Modified: / 16-09-2011 / 16:32:37 / cg"
!

isValidOutputLine:line
    "return true, if line contains a valid list-files output line"

    self subclassResponsibility
!

listFilesReader
    |reader|

    reader := ArchiverOutputParser new.
    reader archiver:self.
    ^ reader
! !

!Archiver methodsFor:'command strings'!

addDoubleQuotedFilenames:collectionOfFilenames toStream:aStream
    collectionOfFilenames notNil ifTrue:[
        collectionOfFilenames do:[:el | 
            aStream nextPutAll:' "'.
            aStream nextPutAll:(el asString).
            aStream nextPutAll:'"'
        ].
    ].
! !

!Archiver methodsFor:'initialization & release'!

release
    self stopProcess.
    self removeTemporaryDirectory.
    super release
! !

!Archiver::MultiFileArchive methodsFor:'actions'!

addFilesToArchive:colOfFiles
    |cmd tempDir archivFile archivInTemp fileSize backupFile result|

    archivFile := self fileName.

    tempDir := self temporaryDirectory.
    archivInTemp := tempDir construct:(archivFile baseName).

    "/ copy a non-empty archiv to tempDir
    fileSize := archivFile fileSize.
    (fileSize notNil and: [fileSize > 0])
      ifTrue: [archivFile copyTo:archivInTemp].

    "/ keep a save copy

"/    backupFile := archivFile withSuffix: 'sav'.
"/    (backupFile exists) ifTrue:[
"/          backupFile recursiveRemove. " works for a file as well as for a directory " 
"/    ].

"/    archivFile renameTo:(archivFile withSuffix:'sav').

    [
        "/ copy files to be added to tempDir
        colOfFiles do:[:file | | destName |
            destName := tempDir construct:(file asFilename baseName).
            file isDirectory
              ifTrue: [destName := tempDir]. 
            file recursiveCopyTo:destName.
        ].

        "/ addFiles to the archive. Synchron command execution answers
        "/ a boolean.
        cmd := self getCommandToAdd:colOfFiles toArchive:archivInTemp.
        cmd isNil ifTrue:[
            errorStream nextPutAll:'No command to add files.'.
            result := false
        ] ifFalse:[
            result := self executeCommand:cmd directory:tempDir.
        ].

        "/ copy the archive back
        (result == true and: [archivInTemp exists]) ifTrue:[
            archivInTemp copyTo:archivFile.
        ].
    ] ensure:[
        "/ cg: remove the tempFile
        archivInTemp exists ifTrue:[ archivInTemp remove.].
        "/ cg: remove copied files
       " colOfFiles do:[:file |
            (tempDir construct:(file asFilename baseName)) remove.
        ]. "
        "/ boris: remove the temporary directory and its name, too.
        tempDir recursiveRemove.
        temporaryDirectory := nil.
    ].

    ^result == true.

    "Modified: / 16-09-2011 / 16:35:17 / cg"
!

extractFiles:aColOfFilesOrNil to:aDirectory
    |execDir cmd|

    execDir := self fileName directory.
    cmd := self getCommandToExtractFiles:aColOfFilesOrNil intoDirectory:aDirectory.
    cmd isNil ifTrue:[
        errorStream nextPutAll:'No command to extract files.'.
        ^ self.
    ].
    self executeCommand:cmd directory:execDir.

    "Modified: / 16-09-2011 / 16:35:34 / cg"
!

extractFiles:aColOfFiles withoutDirectoryTo:aDirectory
    |execDir tempDir tempFile targetFile|

    execDir := self fileName directory.
    tempDir := self temporaryDirectory.
    self extractFiles:aColOfFiles to:tempDir.

    aColOfFiles do:[ : aFileString |
        tempFile := self temporaryDirectory construct:aFileString.
        targetFile := aDirectory construct:(aFileString asFilename baseName).
        targetFile exists ifTrue:[
            targetFile recursiveRemove.
        ].
        tempFile exists ifTrue:[
            tempFile recursiveCopyTo:targetFile.
        ].
    ].
!

removeFilesFromArchive:aColOfFiles

    |cmd|

    cmd := self getCommandToRemoveFiles:aColOfFiles.
    cmd isNil ifTrue:[
        errorStream nextPutAll:'No command to remove files.'.
        ^ self.
    ].
    self executeCommand:cmd directory:(self fileName directory).

    "Modified: / 16-09-2011 / 16:35:41 / cg"
! !

!Archiver::MultiFileArchive methodsFor:'command strings'!

getCommandToAdd:colOfFiles toArchive:archivIn
    self subclassResponsibility
!

getCommandToExtractFiles:sel intoDirectory:dir
    self subclassResponsibility
!

getCommandToListFiles:aColOfFiles
    self subclassResponsibility
!

getCommandToRemoveFiles:aColOfFiles
    self subclassResponsibility
! !

!Archiver::ArchiverOutputParser class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!Archiver::ArchiverOutputParser methodsFor:'accessing'!

archiver:something
    "set the value of the instance variable 'archiver' (automatically generated)"

    archiver := something.
! !

!Archiver::ArchiverOutputParser methodsFor:'initialization'!

initialize
    firstLineRead := false.
! !

!Archiver::ArchiverOutputParser methodsFor:'parsing'!

parseLine:lineIn forItemClass:itemClass
    |words archiverColumns item index key line|

    (firstLineRead not and:[archiver class hasTitleLine]) ifTrue:[
        firstLineRead := true.
        ^ nil.
    ].

    line := OperatingSystem decodePathOrCommandOutput:lineIn.

    (archiver isValidOutputLine:line) ifFalse:[
        ^ nil.
    ].

    words := line asCollectionOfWords.
    archiverColumns := archiver columns.
    item := itemClass new.
    index := 1.

    archiverColumns do:[:colDescr |
        | itemWordCount itemStream itemFieldSelector itemWriter |

        itemWordCount := colDescr second.
        itemFieldSelector := colDescr first.
        itemFieldSelector notNil ifTrue:[
            itemWriter := itemFieldSelector asMutator.
        ].
        itemStream := WriteStream on:''.
        itemWordCount == #rest ifTrue:[
            words from:index do:[:w|
                itemStream nextPutAll:w.
                itemStream space.
            ].
        ] ifFalse:[
            words from:index to:(index + itemWordCount - 1) do:[:w|
                itemStream nextPutAll:w.
                itemStream space.
            ].
            index := index + itemWordCount.
        ].
        itemWriter notNil ifTrue:[
            item perform:itemWriter with:(itemStream contents withoutSeparators).
        ].
        itemStream close.
    ].
    ((archiverColumns collect:[:el| el first]) includes:#permissions) ifTrue:[
        (item permissions startsWith:$d) ifTrue:[
            key := #directory.
            item isDirectory:true.
        ] ifFalse:[
            key := MIMETypes mimeTypeForFilename:(item fileName asFilename baseName).
            item isDirectory:false.
        ].
    ] ifFalse:[
        key := MIMETypes mimeTypeForFilename:(item fileName asFilename baseName).
    ].
    item icon:(MIMETypeIconLibrary iconForKeyMatching:key).
    ^ item
! !

!Archiver::CompressedFile class methodsFor:'command strings'!

compressCommand
    self subclassResponsibility
!

uncompressCommand
    self subclassResponsibility
! !

!Archiver::CompressedFile class methodsFor:'queries'!

canViewFile

    ^ true
! !

!Archiver::CompressedFile methodsFor:'actions'!

compressFile:aFile to:newFile
    | cmd directory|

    directory := newFile directory.
    (directory exists) ifFalse:[
        self warn:'Cannot compress to non-existing directory ', directory asString.
    ].
    (directory isDirectory) ifFalse:[
        self warn:'Cannot compress to non-directory ', directory asString.
    ].

    cmd := self getCommandToCompress:aFile asNew:newFile.
    self executeCommand:cmd directory:directory.
    newFile exists ifTrue:[
        self fileName:newFile.
    ].
!

extractFiles:aColOfFilesOrNil to:aDirectory
    self uncompressTo:aDirectory
!

uncompressTo:aDirectory
    | cmd file newFile|

    (aDirectory exists) ifFalse:[
        self warn:'Cannot uncompress to non-existing directory ', aDirectory asString.
        ^ self
    ].
    (aDirectory isDirectory) ifFalse:[
        self warn:'Cannot uncompress to file ', aDirectory asString.
        ^ self
    ].
    file := newFile := self fileName.
    (file directory pathName = aDirectory pathName) ifFalse:[
        newFile := aDirectory construct:(file baseName).
        file copyTo:newFile.
    ].
    cmd := self getCommandToUncompress:newFile.
    self executeCommand:cmd directory:aDirectory. 
! !

!Archiver::CompressedFile methodsFor:'columns'!

columns
    self subclassResponsibility
!

isValidOutputLine:line
    ^ line endsWith:self fileName withoutSuffix baseName.
! !

!Archiver::CompressedFile methodsFor:'command strings'!

getCommandToCompress:aFile asNew:newFile
    ^ '%1 -c %2 > %3' 
        bindWith:self class compressCommand
        with:aFile asString 
        with:newFile asString
!

getCommandToListFiles:dummyArg
    ^ 'gzip -l "' , self fileName baseName , '"'
!

getCommandToUncompress:aFileName 
    ^ '%1 %2' 
        bindWith:self class uncompressCommand
        with:aFileName baseName
! !

!Archiver::BZ2Compressed class methodsFor:'command strings'!

compressCommand
    ^ 'bzip2'
!

uncompressCommand
    ^ 'bunzip2'
! !

!Archiver::BZ2Compressed methodsFor:'columns'!

columns
    ^ #(      
         #(#fileName        1)
    ) 
!

isValidOutputLine:line
    ^ true
! !

!Archiver::BZ2Compressed methodsFor:'command strings'!

getCommandToListFiles:dummyArg
    ^ 'echo ' , self fileName withoutSuffix baseName
"/    ^ 'bzip2 -t -v "' , self fileName baseName , '"'
! !

!Archiver::CompressedTarArchive class methodsFor:'queries'!

canAddFiles
    ^ Archiver tarArchive canAddFiles
!

canRemoveFiles
    ^ Archiver tarArchive canRemoveFiles
!

canViewFile
    ^ Archiver tarArchive canViewFile
!

compressorClass
    self subclassResponsibility
! !

!Archiver::CompressedTarArchive methodsFor:'accessing'!

fileName:aFile
    |tempDir file compressor suffix tarFilename|

    super fileName:aFile.
    " unzip file in tempDirectory and do all the things with tar file "
    tempDir := self temporaryDirectory.
    compressor := (self class compressorClass) with:(self fileName).
    compressor uncompressTo:tempDir.
    suffix := self fileName suffix.
    file := self fileName withoutSuffix.
    tarFilename := file baseName.
    file suffix ~= 'tar' ifTrue:[
        tarFilename := tarFilename , '.tar'
    ].
    tarFile := self temporaryDirectory construct:tarFilename.
    tarArchiver := Archiver::TarArchive with:tarFile.
! !

!Archiver::CompressedTarArchive methodsFor:'actions'!

addFilesToArchive:colOfFiles
    self setCommandOptions.
    tarArchiver addFilesToArchive:colOfFiles.
    "/ synchronize the tar archive under temporary file with archiv file position
    self synchronize.
!

extractFiles:aColOfFiles to:aDirectory
    self setCommandOptions.
    tarArchiver extractFiles:aColOfFiles to:aDirectory.
!

extractFiles:aColOfFiles withoutDirectoryTo:aDirectory
    self setCommandOptions.
    tarArchiver extractFiles:aColOfFiles withoutDirectoryTo:aDirectory.
!

listFiles:aColOfFiles
    self setCommandOptions.
    tarArchiver listFiles:aColOfFiles.
!

removeFilesFromArchive:aColOfFiles
    self setCommandOptions.
    tarArchiver removeFilesFromArchive:aColOfFiles.
    self synchronize.
! !

!Archiver::CompressedTarArchive methodsFor:'actions private'!

setCommandOptions
    tarArchiver outStream:(self outStream).
    tarArchiver errorStream:(self errorStream).
    tarArchiver synchron:(self synchron).
!

synchronize
    self subclassResponsibility
! !

!Archiver::CompressedTarArchive methodsFor:'columns'!

columns
    ^ tarArchiver columns
!

isValidOutputLine:line
    ^ tarArchiver isValidOutputLine:line
! !

!Archiver::CompressedTarArchive methodsFor:'initialization & release'!

release
    super release.
    tarArchiver release.
! !

!Archiver::GZipCompressed class methodsFor:'command strings'!

compressCommand
    ^ 'gzip'
!

uncompressCommand
    ^ 'gunzip'
! !

!Archiver::GZipCompressed class methodsFor:'queries'!

hasTitleLine
    ^ true
! !

!Archiver::GZipCompressed methodsFor:'columns'!

columns

    "/ columns in stream order
    "/  colums id/readSelector          words to read
    ^ #( "/ #(#method          1)      
         "/ #(#crc             1)    
         "/ #(#dateAndTime     3)   
         #(#compressSize    1)  
         #(#size            1) 
         #(#ratio           1) 
         #(#fileName        #rest)
    ) 
!

isValidOutputLine:line
    ^ line endsWith:self fileName withoutSuffix baseName.
! !

!Archiver::GZipCompressed methodsFor:'command strings'!

getCommandToListFiles:dummyArg
    ^ 'gzip -l "' , self fileName baseName , '"'
! !

!Archiver::ArArchive class methodsFor:'command strings'!

arCommand
    ^ 'ar'
! !

!Archiver::ArArchive methodsFor:'columns'!

columns
    "/  colums id/readSelector words to read
    ^ #( 
         #(#permissions     1)      
         #(#ownerGroup      1)    
         #(#size            1)   
         #(#monthName       1)  
         #(#dayString       1)  
         #(#timeString      1)  
         #(#yearString      1)  
         #(#fileName        #rest)
    ) 
!

isValidOutputLine:line
    ('[-r][-w][-x]' match:(line copyTo:3)) ifTrue:[^ true].
    ^ false.
! !

!Archiver::ArArchive methodsFor:'command strings'!

getCommandToExtractFiles:sel intoDirectory:dir 
    |stream|

    stream := WriteStream on:''.

    "/ 'x'  arArchivUnpackOption
    stream nextPutAll:('(cd %3 ; %1 x "%2" ' 
                    bindWith:self class arCommand
                    with:self fileName asString string
                    with:dir asString string).

    sel notNil ifTrue:[
        sel do:[:el | 
            stream nextPutAll:' "'.
            stream nextPutAll:(el asString).
            stream nextPutAll:'"'
        ].
    ].
    stream nextPutAll:')'.
    ^ stream contents.
!

getCommandToListFiles:aColOfFiles 
    |stream|

    stream := WriteStream on:''.

    "/ 't'  arArchivListContentsOption
    "/ 'v'  arArchivVerboseOption
    stream nextPutAll:('%1 tv "%2"' 
                    bindWith:self class arCommand
                    with:self fileName baseName).

    stream nextPutAll:(self class stringWithQuotedFileBaseNames:aColOfFiles).
    ^ stream contents.
! !

!Archiver::TarArchive class methodsFor:'command strings'!

tarCommand
    ^ 'tar'
! !

!Archiver::TarArchive class methodsFor:'queries'!

canAddFiles

    ^ true
!

canRemoveFiles

    ^ true
!

canViewFile

    ^ true
! !

!Archiver::TarArchive methodsFor:'columns'!

columns

    "/  colums id/readSelector words to read
    ^ #( #(#permissions     1)      
         #(#ownerGroup      1)    
         #(#size            1)   
         #(#dateAndTime     2)  
         #(#fileName        #rest)
    ) 
!

isValidOutputLine:line
    ('[-d][-r][-w][-x]' match:(line copyTo:4)) ifTrue:[^ true].
    ^ false.
! !

!Archiver::TarArchive methodsFor:'command strings'!

getCommandToAdd:aColOfFiles toArchive:archiveFile
    |stream|

    archiveFile exists ifFalse:[^ nil].

    stream := WriteStream on:''.

    "/ 'r'  TarArchivAddOption
    "/ 'f'  TarArchivFileOption
    stream nextPutAll:('%1 rf "%2"' 
                    bindWith:self class tarCommand
                    with:archiveFile asString string).

    stream nextPutAll:(self class stringWithQuotedFileBaseNames:aColOfFiles).
    ^ stream contents
!

getCommandToExtractFiles:sel intoDirectory:dir 
    |stream|

    stream := WriteStream on:''.

    "/ 'x'  TarArchivUnpackOption
    "/ 'f'  TarArchivFileOption
    "/ 'C'  TarArchivUnpackInDirectoryOption
    stream nextPutAll:('%1 -xf "%2" -C "%3"' 
                    bindWith:self class tarCommand
                    with:self fileName asString string
                    with:dir asString).

    sel notNil ifTrue:[
        sel do:[:el | 
            stream nextPutAll:' "'.
            stream nextPutAll:(el asString).
            stream nextPutAll:'"'
        ].
    ].
    ^ stream contents.
!

getCommandToListFiles:aColOfFiles 
    |stream|

    stream := WriteStream on:''.

    "/ 't'  TarArchivListContentsOption
    "/ 'v'  TarArchivVerboseOption
    "/ 'f'  TarArchivFileOption
    stream nextPutAll:('%1 -tvf "%2"' 
                    bindWith:self class tarCommand
                    with:self fileName baseName).

    stream nextPutAll:(self class stringWithQuotedFileBaseNames:aColOfFiles).
    ^ stream contents.
!

getCommandToRemoveFiles:sel 
    |stream filename|

    filename := self fileName.
    filename exists ifFalse:[^ nil].

    stream := WriteStream on:''.

    "/ 'f'  TarArchivFileOption
    stream nextPutAll:('%1 --delete -f "%2"' 
                    bindWith:self class tarCommand
                    with:self fileName baseName).

    stream nextPutAll:(self class stringWithQuotedFileBaseNames:sel).
    ^ stream contents
! !

!Archiver::TarBZ2Archive class methodsFor:'queries'!

canAddFiles

    ^ Archiver tarArchive canAddFiles
!

canRemoveFiles

    ^ Archiver tarArchive canRemoveFiles
!

canViewFile

    ^ Archiver tarArchive canViewFile
!

compressorClass
    ^ Archiver::BZ2Compressed
! !

!Archiver::TarBZ2Archive methodsFor:'actions private'!

synchronize
    |gzipArchiver|

    gzipArchiver := Archiver::BZ2Compressed with:nil.
    gzipArchiver compressFile:(tarArchiver fileName) to:(self fileName).
! !

!Archiver::TarGZipArchive class methodsFor:'queries'!

canAddFiles

    ^ Archiver tarArchive canAddFiles
!

canRemoveFiles

    ^ Archiver tarArchive canRemoveFiles
!

canViewFile

    ^ Archiver tarArchive canViewFile
!

compressorClass
    ^ Archiver::GZipCompressed
! !

!Archiver::TarGZipArchive methodsFor:'actions private'!

synchronize
    |gzipArchiver|

    gzipArchiver := Archiver::GZipCompressed with:nil.
    gzipArchiver compressFile:(tarArchiver fileName) to:(self fileName).
! !

!Archiver::XarArchive class methodsFor:'command strings'!

xarCommand
    ^ 'xar'
! !

!Archiver::XarArchive class methodsFor:'queries'!

canAddFiles

    ^ false
!

canRemoveFiles

    ^ false
!

canViewFile

    ^ true
! !

!Archiver::XarArchive methodsFor:'columns'!

columns

    "/  colums id/readSelector words to read
    ^ #(      
         #(#fileName        #rest)
    ) 
!

isValidOutputLine:line
    ^ true
! !

!Archiver::XarArchive methodsFor:'command strings'!

getCommandToExtractFiles:sel intoDirectory:dir 
    |stream|

    stream := WriteStream on:''.

    "/ '-x'  TarArchivUnpackOption
    "/ '-f'  TarArchivFileOption
    "/ '-C'  TarArchivUnpackInDirectoryOption
    stream nextPutAll:('%1 -x  -C %3 -f "%2"' 
                    bindWith:self class xarCommand
                    with:self fileName asString string
                    with:dir asString).

    sel notNil ifTrue:[
        sel do:[:el | 
            stream nextPutAll:' "'.
            stream nextPutAll:(el asString).
            stream nextPutAll:'"'
        ].
    ].
    ^ stream contents.
!

getCommandToListFiles:aColOfFiles 
    |stream|

    stream := WriteStream on:''.

    "/ '-t'  TarArchivListContentsOption
    "/ '-f'  TarArchivFileOption
    stream nextPutAll:('%1 -t -f "%2"' 
                    bindWith:self class xarCommand
                    with:self fileName baseName).

    stream nextPutAll:(self class stringWithQuotedFileBaseNames:aColOfFiles).
    ^ stream contents.
! !

!Archiver::ZipArchive class methodsFor:'command strings'!

unzipCommand
    |cmdString s cmd|

    OperatingSystem isUNIXlike ifTrue:[
        ^ 'unzip'
    ].
    OperatingSystem isMSWINDOWSlike ifTrue:[
        cmdString := MIMETypes defaultCommandTemplateToOpenMimeType:'application/x-zip-compressed'.
        cmdString notEmptyOrNil ifTrue:[
            s := cmdString readStream.
            s skipSeparators.
            s peek == $" ifTrue:[
                s next.
                cmd := (s upTo:$")
            ] ifFalse:[
                cmd := s upToSeparator.
            ].
            ^ cmd
        ].
        ^ 'winrar.exe'
    ].
    ^ nil

    "
     self unzipCommand    
    "

    "Modified: / 16-09-2011 / 17:26:18 / cg"
!

zipCommand
    OperatingSystem isUNIXlike ifTrue:[
        ^ 'zip'
    ].
    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ self unzipCommand.
    ].
    ^ nil

    "Modified: / 16-09-2011 / 16:26:00 / cg"
! !

!Archiver::ZipArchive class methodsFor:'queries'!

canAddFiles

    ^ true
!

canRemoveFiles

    ^ true
!

canViewFile

    ^ true
!

hasLastLine
    ^ true
!

hasTitleLine
    ^ true
! !

!Archiver::ZipArchive methodsFor:'columns'!

columns

    "/  colums id/readSelector    words to read
    ^ #( (#permissions     1)      
         (#version         2)    
         (#size            1)     
         (#type            1)    
         (#ratio           1)    
         (nil              1)  
         (#dateAndTime     2)  
         (#fileName        #rest)
    ) 
!

isValidOutputLine:line
    ('[-d][-r][-w][-x]' match:(line copyToMax:4)) ifTrue:[^ true].
    ^ false.
! !

!Archiver::ZipArchive methodsFor:'command strings'!

getCommandToAdd:aColOfFiles toArchive:archiveFile
    "archiveFile exists ifFalse:[^ nil]."

    OperatingSystem isUNIXlike ifTrue:[
        ^ String streamContents:[:s |
                s nextPutAll:('%1 -r "%2"' 
                    bindWith:self class zipCommand
                    with:archiveFile asString string).

                self 
                    addDoubleQuotedFilenames:(aColOfFiles collect:[:each | each asFilename baseName])
                    toStream:s.
        ].
    ].

    ^ nil

    "Modified (comment): / 16-09-2011 / 16:27:20 / cg"
!

getCommandToExtractFiles:aColOfFiles intoDirectory:dir
    |cmd template|

    cmd := self class unzipCommand.

    OperatingSystem isUNIXlike ifTrue:[
        template := '%1 -o -d "%2" "%3"'
    ].
    OperatingSystem isMSDOSlike ifTrue:[
        self halt:'unhandled os'.
    ].

    template notNil ifTrue:[
        ^ String streamContents:[:s |
            "/ -o   UnzipOverwriteExistingFilesOption
            "/ -d   UnzipExtDirectoryOption

            s nextPutAll:(template 
                    bindWith:cmd
                    with:dir asString string
                    with:self fileName asString).

            self addDoubleQuotedFilenames:aColOfFiles toStream:s.
        ]
    ].

    ^ nil.

    "Modified: / 16-09-2011 / 16:38:57 / cg"
!

getCommandToListFiles:aColOfFiles 
    |cmd headlessCmd template|

    cmd := self class unzipCommand.

    OperatingSystem isUNIXlike ifTrue:[
        "/  -Z      ZipInfoOption
        "/  -h      ZipHeaderOption
        "/  -t      ZipTotalOption
        template := '"%1" -Z -m -h "%2"'
    ].
    OperatingSystem isMSDOSlike ifTrue:[
        |mapping cmdBasename|

        mapping := #('winrar.exe' 'rar.exe'     '"%1" l "%2"'
"/ does not work yet:
"/                     '7zFM.exe'   '7z.exe'      '"%1" l "%2"'
                    ).
        cmdBasename := cmd asFilename baseName.
        mapping inGroupsOf:3 do:[:originalBasename :mappedBasename :templ|
            (cmdBasename sameAs:originalBasename) ifTrue:[
                headlessCmd := cmd asFilename directory construct:mappedBasename.
                headlessCmd isExecutableProgram ifTrue:[
                    cmd := headlessCmd pathName.
                    template := templ.
                ].
            ].
        ].
        template isNil ifTrue:[
            self halt:'unknown command'
        ].
    ].

    template notNil ifTrue:[
        ^ String streamContents:[:s |
            s nextPutAll:(template 
                            bindWith:cmd with:self fileName asString string).

            aColOfFiles notNil ifTrue:[       
                self breakPoint:#ca.
                self 
                    addDoubleQuotedFilenames:(aColOfFiles collect:[:each | each asFilename baseName])
                    toStream:s.
            ].
        ].
    ].
    ^ nil.

    "Modified: / 29-11-2011 / 20:19:18 / cg"
!

getCommandToRemoveFiles:aColOfFiles 
    OperatingSystem isUNIXlike ifTrue:[
        ^ String streamContents:[:s |
            s nextPutAll:('%1 -d "%2"' 
                        bindWith:self class zipCommand
                        with:self fileName asString string).

            self addDoubleQuotedFilenames:aColOfFiles toStream:s.
        ]
    ].

    ^ nil.

    "Modified: / 16-09-2011 / 16:29:09 / cg"
! !

!Archiver class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

