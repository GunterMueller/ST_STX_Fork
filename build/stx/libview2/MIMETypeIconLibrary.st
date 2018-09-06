"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MIMETypeIconLibrary
	instanceVariableNames:''
	classVariableNames:'Icons MatchedIcons'
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!MIMETypeIconLibrary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    an icon library especially for file type icons as per mime type.
    This does not (and should not) provide icons itself - it just forwards
    the mime-name based accessors to the standard icon library.
"
! !

!MIMETypeIconLibrary class methodsFor:'initialization'!

flushIcons
    "remove any cached icons. Call this eg. after a style change"

    Icons := nil

    "
     self flushIcons
    "
!

initialize
    "/ now done lazily, when the first icon is asked for
    "/ self initializeIcons
!

initializeIcons
    |icons matchedIcons defaults resources addMapping fileNameToImageMap|

    icons := Dictionary new.
    matchedIcons := OrderedCollection new.
    fileNameToImageMap := Dictionary new.

    defaults := #(
        "/ internal-type to icon mappings.
        directory             directory         
        directoryOpen         directoryOpen       
        directoryLocked       directoryLocked     
        directoryLink         directoryLink     
        directoryNetwork      directoryNetwork 
        file                  file           
        fileLink              fileLink             
        fileLocked            fileLocked       

        executableFile        executableFile             
        deviceFile            deviceFile           
        binaryFile            binaryFile          
        specialFile           specialFile       

        addOnLocked           addOnLocked            
        addOnLinked           addOnLinked            

        directoryGray         directoryGray       
        directoryOpenGray     directoryOpenGray

        "/ these are soon obsolete
        imageFile             imageFile              
        textFile              text             

        "/ mime-type to icon mappings.
        'image/*'                                       imageFile

        "/ misc text ...

        'text/html'                                     textHtml
"/        'text/plain'                                    text
        'text/*'                                        text

        'application/postscript'                        applicationPostscript
        'application/pdf'                               applicationPdf
        'application/rtf'                               applicationRtf     

        "/ video formats ...

"/        'video/x-sgi-movie'                             video
"/        'video/x-msvideo'                               video
"/        'video/quicktime'                               video
"/        'video/x-mpeg2'                                 video
"/        'video/mpeg'                                    video
        'video/*'                                       video
"/        'application/vnd.rn-realmedia'                  video

        "/ audio formats ...

"/        'audio/x-pn-realaudio'                          audio
"/        'audio/x-mpeg'                                  audio
"/        'audio/x-mp3'                                   audio
"/        'audio/x-wav'                                   audio
"/        'audio/x-aiff'                                  audio
"/        'audio/basic'                                   audio
"/        'audio/x-shockwave-flash'                       audio
        'audio/*'                                       audio

        "/ misc stuff
        'application/winword'                           text
        'application/x-waltop-digital-notepad'          digitalNotepad

        "/ binary formats
        'application/binary'                            binaryFile
        'application/library'                           binaryFile
        'application/shared-library'                    binaryFile

        "/ progr. languages
        'application/x-smalltalk-source'                smalltalkSource
        'application/x-smalltalk-source-sif'            text
        'application/x-c-source'                        cSource
        'application/x-c-header'                        headerFile
        'application/x-cpp-source'                      cPlusPlusSource
        'application/x-javascript'                      javaScriptSource
        'application/x-java-source'                     javaSource
        'application/x-lisp-source'                     lispSource

        'application/x-sh'                              text
        'application/x-csh'                             text
        'application/x-tcl'                             text
        'application/x-perl'                            text
        'application/x-make'                            text
        'application/x-batch-script'                    text
        'application/x-asn1-source'                     text

        "/ compressors / archivers
        'application/java-archive'                      javaArchive
        'application/x-tar'                             fileArchive
        'application/x-gtar'                            fileArchive
        'application/x-tar-compressed'                  compressedArchive
        'application/x-zip-compressed'                  compressedArchive
        'application/x-gzip-compressed'                 compressedArchive
        'application/x-cpio'                            fileArchive
        'application/x-shar'                            fileArchive

        'application/x-expecco-testsuite'               expeccoSuite
        'application/x-expecco-logfile'                 expeccoLogfile

        '*'                                             text
     ).

    addMapping := [:key :baseNameOrName |
        |fileName image|

        baseNameOrName notNil ifTrue:[
            baseNameOrName isSymbol ifTrue:[
                image := self perform:baseNameOrName.
            ] ifFalse:[
                image := fileNameToImageMap at:baseNameOrName ifAbsent:nil.
                image isNil ifTrue:[
                    image := Smalltalk imageFromFileNamed:baseNameOrName forClass:self.
                    image isNil ifTrue:[
                        fileName := 'bitmaps/xpmBitmaps/document_images/' , baseNameOrName.
                        image := Smalltalk imageFromFileNamed:fileName forClass:self.
                    ].
                ].
                fileNameToImageMap at:baseNameOrName put:image.
            ].
            image notNil ifTrue:[
                key includesMatchCharacters ifTrue:[
                    matchedIcons add:(key -> image).
                ] ifFalse:[    
                    icons at:key put:image.
                ].
            ].
        ]
    ].

    resources := self classResources.

    "all mappings from the resource file"
    resources keysAndValuesDo:addMapping.

    "missing mappings from above defaults"
    defaults pairWiseDo:[:key :baseName |
        (resources includesKey:key) ifFalse:[
            addMapping value:key value:baseName
        ].
    ].

    Icons := icons.
    MatchedIcons := matchedIcons.

    "
     self initializeIcons
    "
! !

!MIMETypeIconLibrary class methodsFor:'accessing'!

addOnIconsFor:aFilename to:anIcon
    "given a fileName, return an appropriate icon, especially an overlaid icon if linked or locked"

    |addOnIcon addIcns|

    aFilename isNil ifTrue:[^ anIcon ].
    anIcon isNil ifTrue:[^ anIcon ].

    addIcns := OrderedCollection new.
    aFilename isSymbolicLink ifTrue:[
        addOnIcon := self iconForKeyMatching:#addOnLinked.
        addOnIcon notNil ifTrue:[ addIcns add:addOnIcon ].
    ].
    (aFilename isReadable not 
     and:[aFilename isDirectory not or:[aFilename isExecutable not]]) ifTrue:[
        addOnIcon := self iconForKeyMatching:#addOnLocked.
        addOnIcon notNil ifTrue:[ addIcns add:addOnIcon ].
    ].
    addIcns notEmpty ifTrue:[
        addIcns addFirst:anIcon.
        ^ MultiImage images:addIcns.
    ].
    ^ anIcon
!

fileTypeIconKeyFor:aFilename
    "return an icon-key for a fileName.
     This does not look at the file's suffix or into the file's contents,
     for more detailed key i.e. it only returns keys for the common broad categories"

    |info|

    info := aFilename linkInfo.
    info isNil ifTrue:[
        ^ nil.
    ].
    info isSymbolicLink ifTrue:[
        ^ #symbolicLink.
    ].
    info isDirectory ifTrue:[
        ^ #directory.
    ].
    info isSpecialFile ifTrue:[
        ^ #specialFile.
    ].
    aFilename isExecutableProgram ifTrue:[
        ^ #executableFile
    ].
    ^ #file.

    "
     self fileTypeIconKeyFor:'/foo/bar' asFilename 
     self fileTypeIconKeyFor:'/tmp' asFilename 
     self fileTypeIconKeyFor:'/dev/null' asFilename 
     self fileTypeIconKeyFor:'Makefile' asFilename 
     self fileTypeIconKeyFor:'/usr/bin/make' asFilename 
    "
!

iconForFile:aFilename
    "given a fileName, return an appropriate icon"

    |icn|

    icn := self iconForKeyMatching:(self iconKeyForFile:aFilename).
    ^ self addOnIconsFor:aFilename to:icn.
!

iconForKey:mimeTypeOrKey
    ^ self icons at:mimeTypeOrKey ifAbsent:nil.
!

iconForKeyMatching:mimeTypeOrKey
    |icn assoc|

    icn := self iconForKey:mimeTypeOrKey.
    icn notNil ifTrue:[^icn].
    assoc := self iconForMatchKey:mimeTypeOrKey.
    assoc notNil ifTrue:[^ assoc value].
    ^ nil.
!

iconForLinkedDirectory
    "answer the icon used for linked directories"

    ^ self directoryLink.

"/    |dirIcon linkIcon|
"/
"/    dirIcon  := self iconForKeyMatching:#directory.
"/    linkIcon := self iconForKeyMatching:#addOnLinked.
"/
"/    linkIcon notNil ifTrue:[
"/        ^ MultiImage images:(Array with:dirIcon with:linkIcon).
"/    ].
"/    ^ dirIcon

    "
      self iconForLinkedDirectory
    "
!

iconForMatchKey:matchKey
    ^ self matchedIcons detect:[:assoc | assoc key match:matchKey] ifNone:nil.
!

iconKeyForFile:aFilenameArg
    "given a fileName, return an appropriate icon"

    |filename fileType mimeType suffix|

    filename := aFilenameArg asFilename.

    fileType := self fileTypeIconKeyFor:filename.

    (fileType ~~ #directory) ifTrue:[
        suffix := filename suffix.
        (suffix = 'bak' or:[suffix = 'sav']) ifTrue:[
            filename := filename withoutSuffix.
        ].
        mimeType := MIMETypes mimeTypeForFilename:filename.
    ].

    ^ mimeType ? fileType.
!

iconKeyForRemoteDirectory:aFilenameArg
    "given a fileName, return an appropriate icon"

    ^ #directoryNetwork
!

icons
    Icons isNil ifTrue:[
        self initializeIcons
    ].
    ^ Icons
!

matchedIcons
    MatchedIcons isNil ifTrue:[
        self initializeIcons
    ].
    ^ MatchedIcons
! !

!MIMETypeIconLibrary class methodsFor:'image specs'!

addOnLinked
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeAddOnLinked
!

addOnLocked
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeAddOnLocked
!

applicationBinary
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeApplicationBinaryIcon
!

applicationJavaArchive
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeApplicationJavaArchiveIcon
!

applicationLibrary
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeApplicationLibraryIcon
!

applicationPdf
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeApplicationPdfIcon
!

applicationPostscript
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeApplicationPostscriptIcon
!

applicationRtf
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeApplicationRtfIcon
!

applicationSharedLibrary
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeApplicationSharedLibraryIcon
!

audio
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeAudioIcon
!

binaryFile
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeBinaryFileIcon
!

cPlusPlusSource
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeCPlusPlusSourceIcon
!

cSource
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeCSourceIcon
!

compressedArchive
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeCompressedArchiveIcon
!

deviceFile
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeDeviceFileIcon
!

digitalNotepad
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeDigitalNotepadIcon
!

directory
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeDirectoryIcon
!

directoryGray
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeDirectoryGrayIcon
!

directoryLink
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeDirectoryLinkIcon
!

directoryLocked
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeDirectoryLockedIcon
!

directoryNetwork
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeDirectoryNetworkIcon
!

directoryOpen
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeDirectoryOpenIcon
!

directoryOpenGray
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeDirectoryOpenGrayIcon
!

executableFile
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeExecutableFileIcon
!

expeccoLogfile
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeExpeccoLogfileIcon
!

expeccoSuite
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeExpeccoSuiteIcon
!

file
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeFileIcon
!

fileArchive
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeFileArchiveIcon
!

fileLink
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeFileLinkIcon
!

fileLocked
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeFileLockedIcon
!

headerFile
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeHeaderFileIcon
!

homeDirectory
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeHomeIcon
!

imageFile
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeImageFileIcon
!

javaArchive
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeApplicationJavaArchiveIcon
!

javaScriptSource
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeJavaScriptSourceIcon
!

javaSource
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeJavaSourceIcon
!

lispSource
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeLispSourceIcon
!

smalltalkSource
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeSmalltalkSourceIcon
!

specialFile
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeSpecialFileIcon
!

text
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeTextIcon
!

textHtml
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeTextHtmlIcon
!

video
    <resource: #programImage>

    ^ ToolbarIconLibrary fileTypeVideoIcon
! !

!MIMETypeIconLibrary class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/MIMETypeIconLibrary.st,v 1.30 2015-01-26 10:11:25 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/MIMETypeIconLibrary.st,v 1.30 2015-01-26 10:11:25 stefan Exp $'
! !


MIMETypeIconLibrary initialize!
