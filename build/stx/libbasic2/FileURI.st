"
 COPYRIGHT (c) 2002 by eXept Software AG
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

HierarchicalURI subclass:#FileURI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Resources'
!

!FileURI class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!FileURI class methodsFor:'instance creation'!

fromFilename:aFilename
    "create an URI based on an a filename"

    ^ self new fromFilename:aFilename
! !

!FileURI class methodsFor:'accessing'!

schemes
    "answer the list of supported schemes"

    ^ #(file)
! !

!FileURI methodsFor:'converting'!

asFilename
    "answer the receiver represented as filename"

    ^ authority notEmptyOrNil ifTrue:[
        Filename remoteHost:authority rootComponents:pathSegments.
    ] ifFalse:[
        isAbsolute ifTrue:[
            Filename rootComponents:pathSegments.
        ] ifFalse:[
            Filename fromComponents:pathSegments.
        ].
    ].

    "
        (URI fromString:'file:///dir/file') asFilename
        (URI fromString:'file:///C:dir/file') asFilename
        (URI fromString:'file:///C:/dir/file') asFilename
        (URI fromString:'file:///~/bla') asFilename
        (URI fromString:'file:///~root/bla') asFilename 
        (URI fromString:'file:////host/dir/file') asFilename 
    "
! !

!FileURI methodsFor:'initialization'!

fromFilename:aFilename
    "create an URI based on an a filename"

    |volume|

    pathSegments := aFilename components.
    aFilename isAbsolute ifTrue:[
        (pathSegments notEmpty and:[pathSegments first startsWith:'\\']) ifTrue:[
            "this is a MS-Windows network path: \\host\path"
            isAbsolute := false. "there are already enogh / in the first pathComponent"
            pathSegments at:1 put:(pathSegments first replaceAll:$\ with:$/).
        ] ifFalse:[
            "this is an absolute path"
            isAbsolute := true.
            volume := aFilename volume.
            volume notEmpty ifTrue:[
                pathSegments at:1 put:volume.
            ].
        ].
    ] ifFalse:[
        "this is a relative path"
        isAbsolute := false.
    ]

    "
      self fromFilename:'/a/b/c'  asFilename   
      self fromFilename:'//a/b/c' asFilename  
      self fromFilename:'a/b/c'   asFilename    

      self fromFilename:'\a\b\c'  asFilename   
      self fromFilename:'~user\a\b\c'  asFilename   
      self fromFilename:'C:\a\b\c'  asFilename   
      self fromFilename:'\\a\b\c'  asFilename 
      self fromFilename:'a\b\c'   asFilename    
    "
! !

!FileURI methodsFor:'queries'!

exists

    ^ self asFilename exists
! !

!FileURI methodsFor:'stream access'!

readStream

    ^ self asFilename readStream

    "
     'file:/etc/group' asURI readStream contents
     'file:/~/.profile' asURI readStream contents
     (URI fromString:'file:~/.profile') asFilename
     (URI fromString:'file:~/.profile') readStream upToEnd
    "
!

readStreamDo:aBlock
    "evaluate a block with the read stream as first argument
     and a dictionary containing attributes as second argument.
     The stream is closed after aBlock has been evaluated."

    |attributes file stream|

    attributes := self class attributes.
    file := self asFilename.
    attributes at:#fileSize put:file fileSize.
    attributes at:#baseName put:file baseName.  
    attributes at:#uriInfo  put:self printString.  

    ^ [ 
        stream := file readStream.
        aBlock value:stream optionalArgument:attributes
     ] ensure:[
        stream notNil ifTrue:[stream close]
     ].

    "
     '/etc/group' asURI readStreamDo:[:stream :attributes|
        stream contents         
                addFirst:attributes printString; 
                yourself
     ].

     'file:/etc/group' asURI readStreamDo:[:stream :attributes|
        stream contents         
                addFirst:attributes printString; 
                yourself
     ].
    "
!

readStreamsDo:aBlock
    "evaluate the block with a Collection of streams as first argument
     and a dictionary containing attributes as second argument,
     - a collection with a stream on a single file,
     - or a collection with streams on a directorie's files, but not recursive"

    self readStreamsDo:aBlock filterBlock:nil renameBlock:nil.
!

readStreamsDo:aBlock filterBlock:oneArgFilterBlock renameBlock:renameBlock
    "evaluate the block with a Collection of streams as first argument
     and a dictionary containing attributes as second argument,
     - a collection with a stream on a single file,
     - or a collection with streams on a directories files, but not recursive"

    |attributes fn files list baseName|

    fn := self asFilename.
    files := OrderedCollection new.
    list := OrderedCollection new.
    attributes := self class attributes.

    fn isDirectory ifTrue:[
        attributes at:#requestDirectory put:true.
        fn directoryContentsAsFilenamesDo:[:eachFilename|
            eachFilename isDirectory ifFalse:[
                files add:eachFilename
            ].
        ].
    ] ifFalse:[
        baseName := fn baseName.
        (baseName includesAny:'*?[]') ifTrue:[ |directoryName|
            attributes at:#requestDirectory put:true.
            directoryName := fn directory.
            directoryName directoryContentsDo:[:eachFilenameString|
                (baseName match:eachFilenameString) ifTrue:[ |filename|
                    filename := directoryName construct:eachFilenameString.
                    filename isDirectory ifFalse:[
                        files add:(directoryName construct:eachFilenameString).
                    ].
                ].
            ].
        ] ifFalse:[
            attributes at:#requestDirectory put:false.
            files add:fn.
        ].
    ].

    oneArgFilterBlock notNil ifTrue:[
        files := files select:oneArgFilterBlock
    ].

    files do:[:eachFilename| |baseName stream|
        [
            baseName := eachFilename baseName.
            attributes at:#fileSize put:eachFilename fileSize.
            attributes at:#baseName put:baseName.  
            (self pathSegments includes:baseName) ifTrue:[
                attributes at:#uriInfo put:self.  
            ] ifFalse:[ |uri col|
                uri := self copy.
                col := self pathSegments copy.
                col removeLast.
                col add:baseName.
                uri pathSegments:col.
                attributes at:#uriInfo put:uri.  
            ].
            stream := eachFilename readStream.
            aBlock value:stream optionalArgument:attributes.
        ] ensure:[
            stream notNil ifTrue:[stream close]
        ].

        renameBlock notNil ifTrue:[
            |renameFilenameString|
            renameFilenameString := renameBlock value:eachFilename pathName.
            renameFilenameString asFilename exists ifTrue:[
                renameFilenameString := renameFilenameString, '.', 
                        (Timestamp now printStringFormat:'%(year)%(mon)%(day)%h%m%s').
            ].
            eachFilename moveTo:renameFilenameString.
        ].
    ].

    "
        (URI fromString:'file:~/test/out') 
            readStreamsDo:[:stream :attributes | 
                Transcript showCR:(attributes at:#baseName).
                Transcript showCR:(attributes at:#fileSize).
                Transcript showCR:(attributes at:#requestDirectory).
                Transcript showCR:(attributes at:#uriInfo).
            ].
        (URI fromString:'file:~/test/out/*1') 
            readStreamsDo:[:stream :attributes | 
                Transcript showCR:(attributes at:#baseName).
                Transcript showCR:(attributes at:#fileSize).
                Transcript showCR:(attributes at:#requestDirectory).
                Transcript showCR:(attributes at:#uriInfo).
            ].
    "
!

writeStreamDo:aBlock
    "evaluate a block with the write stream as first argument
     and a dictionary containing attributes as second argument.
     The stream is closed after aBlock has been evaluated.
     Attributes may be the mime type (key #MIME)"

    |stream|

    ^ [
        stream := self asFilename writeStream.
        aBlock value:stream optionalArgument:self class attributes
     ] ensure:[
        stream notNil ifTrue:[stream close]
     ].

    "
        (URI fromString:'file:/home/tm/tmp') 
            readStreamsDo:[:stream :attributes| 
                Transcript showCR:(attributes at:#MIME).
                Transcript showCR:(stream isWritable).
            ].
    "
!

writeStreamDo:aBlock create:doCreate

    ^ self writeStreamDo:aBlock create:doCreate atomic:false.
!

writeStreamDo:aBlock create:doCreate atomic:doAtomic
    "evaluate a block with the write stream as first argument
     and a dictionary containing attributes as second argument.
     The stream is closed after aBlock has been evaluated.
     Attributes may be the mime type (key #MIME)

     If doCreate is true, a nonExistent directory will be created.
     If doAtomic is true, files will appear atomically, by using
        an intermediate file theat will be renamed"

    |stream fileName toFileName|

    fileName := self asFilename.
    toFileName := fileName.
    doAtomic ifTrue:[
        fileName isDirectory ifFalse:[
            toFileName := fileName directory.
        ].
        toFileName := toFileName construct:'.transferFile'.
    ].
    [
        Stream streamErrorSignal handle:[:ex|
            doCreate ifFalse:[
                ex reject
            ].    
            fileName directory recursiveMakeDirectory.
            self exists ifTrue:[ |infoStream|
                infoStream := '' writeStream.
                self publicPrintOn:infoStream.
                self error:('Local write: Datei %1 already exists!!' bindWith:infoStream contents).
            ].
            stream := toFileName writeStream.
        ] do:[
            self exists ifTrue:[ |infoStream|
                infoStream := '' writeStream.
                self publicPrintOn:infoStream.
                self error:('Local write: Datei %1 already exists!!' bindWith:infoStream contents).
            ].
            stream := toFileName writeStream.
        ].
        aBlock value:stream optionalArgument:self class attributes.
        stream close.
        doAtomic ifTrue:[
            toFileName moveTo:fileName.
        ]
    ] ifCurtailed:[
        stream notNil ifTrue:[stream close]
    ].

    "
        (URI fromString:'file:/~') 
            readStreamsDo:[:stream :attributes|
                stream notNil ifTrue:[
                    Transcript show(attributes at:#MIME); tab; showCR:(stream isWritable).
                ].
            ].
    "
! !

!FileURI class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

