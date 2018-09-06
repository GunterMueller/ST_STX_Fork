"{ Package: 'stx:libtool2' }"

Object subclass:#Archiver
	instanceVariableNames:'process temporaryDirectory fileName outStream errorStream
		synchron'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-FileFormats'
!

Archiver subclass:#GZipArchive
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver subclass:#TarArchive
	instanceVariableNames:'fileName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!

Archiver subclass:#TarGZipArchive
	instanceVariableNames:'tarArchiver tarFile'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Archiver
!


!Archiver class methodsFor:'instance creation'!

with:aFilename

    | instance |

    instance := self new.
    instance fileName:aFilename.
    ^ instance
! !

!Archiver class methodsFor:'classAccess'!

gzipArchive

    ^ GZipArchive
!

tarArchive

    ^ TarArchive
!

tarGZipArchive

    ^ TarGZipArchive
! !

!Archiver class methodsFor:'common options'!

MinusSign

    ^ $-
!

PipeSign

    ^ $>
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
        temporaryDirectory := Filename newTemporary.
        temporaryDirectory makeDirectory.
    ].
    ^ temporaryDirectory
! !

!Archiver methodsFor:'actions'!

addFilesToArchiv:colOfFiles

    self subclassResponsibility.
!

extractTo:aColOfFiles

    self subclassResponsibility.
!

listFilesFromArchiv

    self subclassResponsibility.
!

removeFilesFromArchiv:aColOfFiles

    self subclassResponsibility.
! !

!Archiver methodsFor:'actions private'!

removeTemporaryDirectory

    | tmp |

    temporaryDirectory notNil ifTrue:[
        tmp := self temporaryDirectory.
        (FileDirectory directoryNamed:(tmp directory)) removeDirectory:tmp baseName.
        temporaryDirectory := nil.
    ].
!

stopProcess

    process notNil ifTrue:[
        process terminateWithAllSubprocesses.
        process waitUntilTerminated.
    ].
! !

!Archiver methodsFor:'command execution'!

executeCommand:cmd directory:aDirectory


    synchron isNil ifTrue:[synchron := true].
    synchron ifTrue:[
         OperatingSystem 
            executeCommand:cmd
            inputFrom:nil
            outputTo:outStream
            errorTo:errorStream
            inDirectory:aDirectory
            lineWise:true
            onError:[:status| false].
    ] ifFalse:[
        process := Process for:[
                [ 
                     OperatingSystem 
                        executeCommand:cmd
                        inputFrom:nil
                        outputTo:outStream
                        errorTo:errorStream
                        inDirectory:aDirectory
                        lineWise:true
                        onError:[:status| false].
                ] 
                valueNowOrOnUnwindDo:[
                    process := nil.
                ].

        ] priority:(Processor systemBackgroundPriority).
        process name:('ArchivFileCommand command >', cmd).
        process resume.
    ]
!

outStream:aOutStream errorStream:aErrorStream

    outStream := aOutStream.
    errorStream := aErrorStream.
!

outStream:aOutStream errorStream:aErrorStream synchron:aBoolean

    outStream := aOutStream.
    errorStream := aErrorStream.
    synchron := aBoolean
! !

!Archiver methodsFor:'initialization & release'!

release

    self stopProcess.
    self removeTemporaryDirectory.
! !

!Archiver::GZipArchive class methodsFor:'zip archiv command options'!

GZipArchivFileOption
    ^ 'f'
!

GZipArchivUnzipCommand
    ^ 'gunzip'
!

GZipArchivWriteToStdioOption
    ^ 'c'
!

GZipArchivZipCommand
    ^ 'gzip'
! !

!Archiver::GZipArchive methodsFor:'actions'!

unzipTo:aDirectory

    | cmd file newFile|

    (aDirectory exists not) ifTrue:[
        DialogBox warn:'cant unzip to not existing directory ', aDirectory asString.
    ].
    (aDirectory isDirectory not) ifTrue:[
        DialogBox warn:'cant unzip to file ', aDirectory asString.
    ].
    file := self fileName.
    (file directory asString = aDirectory asString) ifFalse:[
        file copyTo:(aDirectory construct:(file baseName)).
    ].
    newFile := aDirectory construct:(file baseName).
    cmd := self getUnzipCommandForFile:newFile.
    self executeCommand:cmd directory:aDirectory. 
!

zipFile:aFile to:newFile

    | cmd directory|

    directory := newFile directory.
    (directory exists not) ifTrue:[
        DialogBox warn:'cant unzip to not existing directory ', directory asString.
    ].
    (directory isDirectory not) ifTrue:[
        DialogBox warn:'cant unzip to file ', directory asString.
    ].
    cmd := self getZipCommandForFile:aFile to:newFile.
    self executeCommand:cmd directory:directory.
    newFile exists ifTrue:[
        self fileName:newFile.
    ].
! !

!Archiver::GZipArchive methodsFor:'command strings'!

getUnzipCommand

    | stream cmd|

    stream := WriteStream on:''.
    stream nextPutAll:self class GZipArchivUnzipCommand.
    stream space.
    stream nextPutAll:self fileName baseName.
    cmd := stream contents.
    stream close.
    ^ cmd
!

getUnzipCommandForFile:aFileName

    | stream cmd|

    stream := WriteStream on:''.
    stream nextPutAll:self class GZipArchivUnzipCommand.
    stream space.
    stream nextPutAll:aFileName asString.
    cmd := stream contents.
    stream close.
    ^ cmd
!

getZipCommandForFile:aFileName

    | stream cmd|

    stream := WriteStream on:''.
    stream nextPutAll:self class GZipArchivZipCommand.
    stream space.
    stream nextPutAll:aFileName asString.
    cmd := stream contents.
    stream close.
    ^ cmd
!

getZipCommandForFile:aFile to:newFile
    | stream cmd|

    stream := WriteStream on:''.
    stream nextPutAll:self class GZipArchivZipCommand.
    stream space.
    stream nextPut:self class MinusSign.
    stream nextPutAll:self class GZipArchivWriteToStdioOption.
    stream space.
    stream nextPutAll:aFile asString.
    stream space.
    stream nextPut:self class PipeSign.
    stream space.
    stream nextPutAll:newFile asString.
    cmd := stream contents.
    stream close.
    ^ cmd
! !

!Archiver::TarArchive class methodsFor:'command strings'!

TarArchivAddOption
    ^ 'r'
!

TarArchivCommand
    ^ 'tar'
!

TarArchivDeleteOption
    ^ '--delete'
!

TarArchivFileOption
    ^ 'f'
!

TarArchivListContentsOption
    ^ 't'
!

TarArchivListOptions
    ^ self TarArchivListContentsOption , self TarArchivVerboseOption 
        , self TarArchivFileOption
!

TarArchivListZippedOptions
    ^ self TarArchivListContentsOption , self TarArchivVerboseOption 
        , self TarArchivFileOption , self TarArchivZipOption
!

TarArchivUnpackInDirectoryOption
    ^ '-C '
!

TarArchivUnpackOption
    ^ 'x'
!

TarArchivVerboseOption
    ^ 'v'
!

TarArchivZipOption
    ^ 'z'
! !

!Archiver::TarArchive methodsFor:'actions'!

addFilesToArchiv:colOfFiles

    | cmd tempDir archivFile archivInTemp|

    tempDir := self temporaryDirectory.
    archivFile := self fileName.
    archivInTemp := tempDir construct:(archivFile baseName).
    "/ copy files to be added to tempDir
    colOfFiles do:[ :file |
        file recursiveCopyTo:(tempDir construct:(file baseName))
    ].

    "/ copy tar archiv to tempDir
    archivFile copyTo:archivInTemp.

    "/ addFiles to the tar archive
    cmd := self getAddFilesToTarArchiveCommandForArchiv:archivInTemp with:colOfFiles.
    self executeCommand:cmd directory:tempDir.

    "/ copy tar archiv back
    archivInTemp copyTo:(self fileName).
!

extractTo:aDirectory 

    ^ self extractTo:aDirectory with:nil
!

extractTo:aDirectory with:files

    |execDir cmd|

    execDir := self fileName directory.
    cmd := self getExtractSelectedFilesCommandForDirectory:aDirectory withSelection:files.
    self executeCommand:cmd directory:execDir.
!

extractWithOutDirectoryTo:aDirectory with:files

    |execDir tempDir tempFile|

    execDir := self fileName directory.
    tempDir := self temporaryDirectory.
    self extractTo:tempDir with:files.
    files do:[ : aFileString |
        tempFile := self temporaryDirectory construct:aFileString.
        tempFile exists ifTrue:[
            tempFile recursiveCopyTo:(aDirectory construct:(aFileString fileName asFilename baseName)).
        ].
    ].
!

listFilesFromArchiv

    self listFilesFromArchiv:nil
!

listFilesFromArchiv:newColOfFiles

    | cmd dir|

    self fileName isNil ifTrue:[ ^ self].
    dir := self fileName directory.
    cmd := self getFileListFromArchivCommand:newColOfFiles.
    self executeCommand:cmd directory:dir 
!

removeFilesFromArchiv:aColOfFiles

    |cmd|

    cmd := self getRemoveFilesFromTarArchivFor:aColOfFiles.
    self executeCommand:cmd directory:(self fileName directory). 
! !

!Archiver::TarArchive methodsFor:'command strings'!

getAddFilesToTarArchiveCommand:aColOfFiles 
    |filename cmd stream|

    filename := self fileName.
    filename exists ifTrue:[
        stream := WriteStream on:''.
        stream nextPutAll:self class TarArchivCommand.
        stream space.
        stream nextPutAll:self class TarArchivAddOption.
        stream nextPutAll:self class TarArchivFileOption.
        stream space.
        stream nextPutAll:filename asString.
        aColOfFiles do:[:el | 
            stream space.
            stream nextPutAll:(el asString)
        ].
        cmd := stream contents
    ].
    ^ cmd
!

getAddFilesToTarArchiveCommandForArchiv:archivFile with:aColOfFiles 
    | cmd stream|

    archivFile exists ifTrue:[
        stream := WriteStream on:''.
        stream nextPutAll:self class TarArchivCommand.
        stream space.
        stream nextPutAll:self class TarArchivAddOption.
        stream nextPutAll:self class TarArchivFileOption.
        stream space.
        stream nextPutAll:archivFile asString.
        aColOfFiles do:[:el | 
            stream space.
            stream nextPutAll:(el baseName)
        ].
        cmd := stream contents
    ].
    ^ cmd
!

getExtractSelectedFilesCommandForDirectory:dir withSelection:sel 
    | stream cmd|

    stream := WriteStream on:''.
    stream nextPutAll:self class TarArchivCommand.
    stream space.
    stream nextPutAll:self class TarArchivUnpackOption.
    stream nextPutAll:self class TarArchivFileOption.
    stream space.
    stream nextPutAll:self fileName asString.
    stream space.
    stream nextPutAll:self class TarArchivUnpackInDirectoryOption.
    stream space.
    stream nextPutAll:dir asString.
    sel notNil ifTrue:[
        sel do:[:el | 
            stream space.
            stream nextPutAll:(el fileName asString)
        ].
    ].
    cmd := stream contents.
    stream close.
    ^ cmd
!

getFileListFromArchivCommand:aColOfFiles 

    | stream cmd|

    stream := WriteStream on:''.
    stream nextPutAll:self class TarArchivCommand.
    stream space.
    stream nextPutAll:self class TarArchivListOptions.
    stream space.
    stream nextPutAll:self fileName baseName.
    aColOfFiles notNil ifTrue:[
        aColOfFiles do:[:el | 
            stream space.
            stream nextPutAll:(el baseName)
        ]
    ].
    cmd := stream contents.
    stream close.
    ^ cmd
!

getRemoveFilesFromTarArchivFor:sel 
    | stream filename|

    filename := self fileName.
    filename exists ifTrue:[
        stream := WriteStream on:''.
        stream nextPutAll:self class TarArchivCommand.
        stream space.
        stream nextPutAll:self class TarArchivDeleteOption.
        stream space.
        stream nextPut:self class MinusSign.
        stream nextPutAll:self class TarArchivFileOption.
        stream space.
        stream nextPutAll:filename asString.
        sel do:[:el | 
            stream space.
            stream nextPutAll:el
        ].
        ^ stream contents
    ]
! !

!Archiver::TarGZipArchive methodsFor:'accessing'!

fileName:aFile

    | tempDir file gzipArchiver suffix|

    super fileName:aFile.
    " unzip file in tempDirectory and do all the things with tar file "
    tempDir := self temporaryDirectory.
    gzipArchiver := Archiver::GZipArchive with:(self fileName).
    gzipArchiver unzipTo:tempDir.
    suffix := self fileName suffix.
    file := self fileName withoutSuffix.
    file := file baseName.
    suffix = 'tgz' ifTrue:[
        file := file , '.tar'
    ].
    tarFile := self temporaryDirectory construct:file.
    tarArchiver := TarArchive with:tarFile.
! !

!Archiver::TarGZipArchive methodsFor:'actions'!

addFilesToArchiv:colOfFiles

    self setCommandOptions.
    tarArchiver addFilesToArchiv:colOfFiles.
    self synchronize.
!

extractTo:aDirectory 

    self extractTo:aDirectory with:nil.
!

extractTo:aDirectory with:col

    self setCommandOptions.
    tarArchiver extractTo:aDirectory with:col.
!

extractWithOutDirectoryTo:aDirectory with:files

    self setCommandOptions.
    tarArchiver extractWithOutDirectoryTo:aDirectory with:files.
!

listFilesFromArchiv

    self listFilesFromArchiv:nil
!

listFilesFromArchiv:newColOfFiles

    self setCommandOptions.
    ^ tarArchiver listFilesFromArchiv:newColOfFiles.
!

removeFilesFromArchiv:aColOfFiles

    self setCommandOptions.
    tarArchiver removeFilesFromArchiv:aColOfFiles.
    self synchronize.
! !

!Archiver::TarGZipArchive methodsFor:'actions private'!

setCommandOptions

    tarArchiver outStream:(self outStream).
    tarArchiver errorStream:(self errorStream).
    tarArchiver synchron:(self synchron).
!

synchronize

    |gzipArchiver|

    gzipArchiver := GZipArchive with:nil.
    gzipArchiver zipFile:(tarArchiver fileName) to:(self fileName).
! !

!Archiver::TarGZipArchive methodsFor:'initialization & release'!

release

    super release.
    tarArchiver release.
! !

!Archiver class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
