"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

HierarchicalURI subclass:#SftpURI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Resources'
!

Object subclass:#WriteStreamSimulator
	instanceVariableNames:'connection remotePath'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SftpURI
!

!SftpURI class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SftpURI class methodsFor:'accessing'!

schemes

    ^ #(sftp)
! !

!SftpURI class methodsFor:'ftp requests'!

pathExists:aPathname ftpClient:aFtpClient
    |list|

    (OpenError, FTPClient fileNotFoundErrorSignal) handle:[:ex|] do:[
        list := aFtpClient directoryContentsOf:aPathname.
        ^ list size = 1 and:[list first = aPathname].
    ].
    ^ false.
! !

!SftpURI methodsFor:'defaults'!

defaultPort
    "answer the default ssh port here"

    ^ 22
!

defaultUser
    ^ OperatingSystem getLoginName
! !

!SftpURI methodsFor:'ftp requests'!

connectThenDo:aOneArgBlock
    "setup a ftp connection and call aOneArgBlock with it"

    |sftpClient|

    SftpClient isNil ifTrue:[
        Smalltalk loadPackage:'stx:goodies/communication'.
    ].    
    sftpClient := SftpClient new
                hostname:self host;
                username:self user;
                port:self port.

    aOneArgBlock value:sftpClient.
! !

!SftpURI methodsFor:'stream access'!

readStreamDo:aBlock
    self connectThenDo:[:ftp| |stream path attributes|
        [
            path := self path.
            attributes := self class attributes.
            attributes at:#fileSize put:(ftp sizeOf:path).
            attributes at:#baseName put:self pathSegments last.  
            attributes at:#uriInfo  put:self printString.  

            stream := ftp getStreamFor:path.
            aBlock value:stream optionalArgument:attributes.
        ] ensure:[
            stream notNil ifTrue:[
                stream close.
            ].
        ].
    ].

    "
     'ftp://stefan:password@ftp.exept.de/etc/group' asURI readStreamDo:[:stream :attributes | 
         self halt
      ].
    "
!

readStreamsDo:aBlock
    "evaluate the block with a Collection of streams as first argument
     and a dictionary containing attributes as second argument,
     - a collection with a stream on a single file,
     - or a collection with streams on a directory's files, but not recursive

     The streams are closed after aBlock has been evaluated.
     Attributes may be the mime type (key #MIME)"

    self readStreamsDo:aBlock skipFilenamesWithSuffix:nil renameBlock:nil
!

readStreamsDo:aBlock filterBlock:oneArgFilterBlock renameBlock:renameBlock
    "evaluate the block with a Collection of streams as first argument
     and a dictionary containing attributes as second argument,
     - a collection with a stream on a single file,
     - or a collection with streams on a directory's files, but not recursive

     The streams are closed after aBlock has been evaluated.
     Attributes may be the mime type (key #MIME)"

    |attributes list requestDirectory path dirUri dirPath|

    requestDirectory := false.
    path := self path.
    "kludge for pathnames starting with a users home dirctory"
    (path startsWith:'/~/') ifTrue:[
        path := path copyFrom:4.
    ].
    (path startsWith:'/~') ifTrue:[
        path := path copyFrom:2.
    ].

    attributes := self class attributes.
    list := OrderedCollection new.

    self connectThenDo:[:ftp| 
        |baseName|

        "try to change directory to path.
         If we get a file error, we know that the directory does not exist"
        baseName := self baseName.
        (baseName includesAny:'*?[]') ifTrue:[
            requestDirectory := true.
            dirUri  := self directory.
            dirPath := dirUri path.
            "kludge for pathnames starting with a users home dirctory"
            (dirPath startsWith:'/~/') ifTrue:[
                dirPath := dirPath copyFrom:4.
            ].
            (dirPath startsWith:'/~') ifTrue:[
                dirPath := dirPath copyFrom:2.
            ].
            FTPClient fileNotFoundErrorSignal handle:[:ex|] 
                "skip error about an empty directory"
            do:[
                list addAll:
                    ((ftp directoryContentsOf:dirPath) 
                        collect:[:filenameString| filenameString withoutSeparators asFilename baseName]
                        thenSelect:[:filenameString| filenameString matches:baseName]).
            ].
        ] ifFalse:[
            [
                dirUri := self.
                dirPath := path.
                requestDirectory := true.
                FTPClient fileNotFoundErrorSignal handle:[:ex|] 
                    "skip error about an empty directory"
                do:[
                    list addAll:
                        ((ftp directoryContentsOf:dirPath) 
                            collect:[:filenameString| filenameString asFilename baseName]
                            "thenSelect:[:filenameString| filenameString matches:baseName]").
                ].
            ] on:FTPClient fileErrorSignal do:[:ex|
                "no directory, fetch path istSelf"
            ].
        ].
        requestDirectory ifFalse:[
            dirUri := self directory.
            dirPath := dirUri path.
            "kludge for pathnames starting with a users home directory"
            (dirPath startsWith:'/~/') ifTrue:[
                dirPath := dirPath copyFrom:4.
            ].
            (dirPath startsWith:'/~') ifTrue:[
                dirPath := dirPath copyFrom:2.
            ].
            list add:self baseName.
        ].

        attributes at:#requestDirectory put:requestDirectory.

        "skip all files which are not selected by filterBlock"
        oneArgFilterBlock notNil ifTrue:[
            list := list select:oneArgFilterBlock.
        ].

        list do:[:eachBaseName| |stream|
            "get a stream for the contents of the file"
            (OpenError, FTPClient fileErrorSignal) handle:[:ex| 
                "ignore errors -- skip subdirectories"
            ] do:[
                stream := ftp getStreamFor:(dirPath, '/', eachBaseName).
"/                attributes at:#fileSize put:(ftp sizeOf:eachBaseName).
                attributes at:#fileSize put:stream fileSize.
                attributes at:#baseName put:eachBaseName.
            ].

            stream notNil ifTrue:[
                |srcUri srcPath|

                requestDirectory ifTrue:[
                    "accessing the contents of a directory"
                    srcUri := dirUri construct:eachBaseName.
                ] ifFalse:[ |pathSegments|
                    "accessing a single file"
                    srcUri := self.
                ].
                attributes at:#uriInfo put:srcUri.  

                [ 
                    aBlock value:stream optionalArgument:attributes 
                ] ensure:[stream close].

                renameBlock notNil ifTrue:[ 
                    |renameFilenameString|

                    renameFilenameString := renameBlock value:eachBaseName.
"/                    [
                        ftp rename:(dirPath, '/', eachBaseName) to:(dirPath, '/', renameFilenameString).
"/                    ] on:FTPClient fileErrorSignal do:[:ex|
"/                        "rename failed, maybe file already exists"
"/                        renameFilenameString := renameFilenameString, '.', 
"/                            (Timestamp now printStringFormat:'%(year)%(mon)%(day)%h%m%s').
"/                        ftp rename:eachBaseName to:renameFilenameString.
"/                    ].
                ].
            ].
        ].
    ].


    "
        |pwd|

        pwd := Dialog requestPassword:''. 
        (URI fromString:('ftp://tm:%1@exept/~/tmp' bindWith:pwd) ) 
            readStreamsDo:[:stream :attributes | 
                Transcript showCR:(attributes at:#baseName).
                Transcript showCR:(attributes at:#fileSize).
                Transcript showCR:(attributes at:#requestDirectory).
                Transcript showCR:(attributes at:#uriInfo).
            ].
    "
!

readStreamsDo:aBlock renameBlock:renameBlock
    "evaluate the block with a Collection of streams as first argument
     and a dictionary containing attributes as second argument,
     - a collection with a stream on a single file,
     - or a collection with streams on a directorie's files, but not recursive

     The streams are closed after aBlock has been evaluated.
     Attributes may be the mime type (key #MIME)"

    self readStreamsDo:aBlock skipFilenamesWithSuffix:nil renameBlock:renameBlock
!

writeStreamDo:aBlock
    "use FTPClient for now"

    self connectThenDo:[:ftp| |stream|
        [
            stream := ftp putStreamFor:self path.
            aBlock value:stream optionalArgument:self class attributes.
        ] ensure:[
            stream notNil ifTrue:[
                stream close.
            ].
        ].
    ]

    "
     'ftp://stefan:password@hippo/etc/group' asURI writeStreamDo:[:stream :attributes | 
         self halt
      ].
    "
!

writeStreamDo:aBlock create:doCreate

    ^ self writeStreamDo:aBlock create:doCreate atomic:false.
!

writeStreamDo:aBlock create:doCreate atomic:doAtomic
    "use FTPClient for now.

     If doCreate is true, a nonExistent directory will be created.
     If doAtomic is true, files will appear atomically, by using
        an intermediate file theat will be renamed"

    |path toPath directory|

    path := self path.
    "kludge"
    (path startsWith:'/~/') ifTrue:[
        path := path copyFrom:4.
    ].
    (path startsWith:'/~') ifTrue:[
        path := path copyFrom:2.
    ].

    doAtomic ifTrue:[
        toPath := self directoryPath, '/.transferFile'.
        "kludge"
        (toPath startsWith:'/~/') ifTrue:[
            toPath := toPath copyFrom:4.
        ].
        (toPath startsWith:'/~') ifTrue:[
            toPath := toPath copyFrom:2.
        ].
    ] ifFalse:[
        toPath := path.
    ].
        
    self connectThenDo:[:ftp| |stream|
        [
            [
                (self class pathExists:path ftpClient:ftp) ifTrue:[ |infoStream|
                    infoStream := '' writeStream.
                    self publicPrintOn:infoStream.
                    self error:('FTP write: Datei %1 already exists!!' bindWith:infoStream contents).
                ].
"/                stream := ftp putStreamFor:toPath.
                stream := WriteStreamSimulator new 
                                        remotePath:toPath;
                                        connection:ftp.
                aBlock value:stream optionalArgument:self class attributes.
            ] on:OpenError, FTPClient filePutErrorSignal do:[:ex|
                doCreate ifFalse:[
                    ex reject
                ].
                "create the missing directory on the fly"
                directory := self directoryPath.
                FTPClient fileNotFoundErrorSignal handle:[:ex| ] do:[
                    ftp mkdir:directory.
                ].
"/                ftp cd:directory.
                (self class pathExists:path ftpClient:ftp) ifTrue:[ |infoStream|
                    infoStream := '' writeStream.
                    self publicPrintOn:infoStream.
                    self error:('FTP write: Datei %1 already exists!!' bindWith:infoStream contents).
                ].
"/                stream := ftp putStreamFor:toPath.
                aBlock value:stream optionalArgument:self class attributes.
            ].
            stream close.
            doAtomic ifTrue:[
                ftp rename:toPath to:path
            ].
        ] ifCurtailed:[
            stream notNil ifTrue:[
                stream close.
            ].
        ].
    ]
! !

!SftpURI methodsFor:'testing'!

exists
    "does the file represented by this uri exist?
     establish a connection for try to get a readStream"

    |exists|

    self connectThenDo:[:aFtpClient|
        exists :=  self class pathExists:self path ftpClient:aFtpClient
    ].

    ^ exists ? false

"
    |pwd uri|

    pwd := Dialog requestPassword:'Password:'. 
    uri := (URI fromString:('ftp://tm:%1@exept/home/tm/tmp/test.txt' bindWith:pwd) ).
    uri pathExists
"
!

isAbsolute
    "there is nothing like a relative ftp URI"

    ^ true
!

isRemote
    "return true, if this is a remote URI"

    ^ true
! !

!SftpURI::WriteStreamSimulator methodsFor:'accessing'!

connection
    ^ connection
!

connection:something
    connection := something.
!

remotePath
    ^ remotePath
!

remotePath:something
    remotePath := something.
! !

!SftpURI::WriteStreamSimulator methodsFor:'copying'!

copyToEndFrom:readStream
    |localPathName|

    readStream isFileStream ifFalse:[
        self error:'WriteStreamSimulator - source is not a FileStream'.
    ].

    localPathName := readStream pathName.
    connection copyLocal:localPathName to:remotePath.
! !

!SftpURI::WriteStreamSimulator methodsFor:'queries'!

isWritable
    ^ remotePath notNil
! !

!SftpURI::WriteStreamSimulator methodsFor:'stream simulation'!

close
   ^ self
! !

!SftpURI class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

