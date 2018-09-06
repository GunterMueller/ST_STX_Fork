"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1995 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

View subclass:#HTMLDocumentFrame
	instanceVariableNames:'documentAnchor localAnchor homeDocument homeText showImages
		topDirectoryName currentDirectoryName enableExecution hRefHistory
		currentPercentage visitedActions visitedUrls currentDocument
		currentAction painter currentLocalAnchor localImages uriHolder
		infoHolder currentURL style printStyle formatContext printing
		documentResolver currentURLHost enableScriptExecution
		enableInternalApplets enableAlienApplets enableJavaApplets
		urlHistory additionalBindings loadedAppletClasses
		lastClickPosition helpDocumentPath nameSpaceForExecution
		documentLoadInProgress catchErrors suppressRedraw
		documentEncoding fontEncoding uriInputHolder
		updateTopViewsTitleFlag anchorOfMousePointer accessLock
		enableActionLinks enableExternalLinks canGoBackHolder
		linkActionPerformer anchorActionPerformer
		masterClickActionPerformer selfInDoitExpressions normalCursor
		anchorCursor'
	classVariableNames:'CachedImages HTMLExtension ImageFlushProcess ImageFlushDelay
		InternalImageTable FileExtensionTable FileExecutorTable
		AnonymousAppletClasses DebugErrors DocumentSearchPathes'
	poolDictionaries:''
	category:'System-Documentation'
!

Object subclass:#HRefHistoryEntry
	instanceVariableNames:'url action anchor position text host'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTMLDocumentFrame
!

Query subclass:#ImageResolverQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTMLDocumentFrame
!

!HTMLDocumentFrame class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    displays HTML documents.

    [author:]
        Claus Gittinger

    [see also:]
        HTMLDocumentView HTMLDocumentPainter
"

! !

!HTMLDocumentFrame class methodsFor:'initialization'!

fileExecutorTable
    FileExecutorTable isNil ifTrue:[
        self initializeFileExecutorTable
    ].
    ^ FileExecutorTable
!

fileExtensionTable
    FileExtensionTable isNil ifTrue:[
        self initializeFileExtensionTable.
    ].
    ^ FileExtensionTable
!

initialize
    OperatingSystem isMSDOSlike ifTrue:[
        HTMLExtension := 'htm'
    ] ifFalse:[
        HTMLExtension := 'html'
    ].
    ObjectMemory addDependent:self.
    ImageFlushDelay := 300.
    DebugErrors := false.

    AnonymousAppletClasses := true.

    "/ self initializeInternalImageTable.   -- now done lazily in getter
    "/ self initializeFileExtensionTable.   -- now done lazily in getter

    "
     self initialize
    "

    "Created: / 20-05-1996 / 20:29:56 / cg"
    "Modified: / 07-08-1997 / 17:55:54 / cg"
    "Modified: / 05-03-2018 / 16:12:33 / stefan"
!

initializeFileExecutorTable
    FileExecutorTable isNil ifTrue:[
        FileExecutorTable := Dictionary new.
        
        FileExecutorTable at:'text-plain'  put:self.
        FileExecutorTable at:'text-html'   put:self.
    ].

    "
     FileExecutorTable := nil.
     self initializeFileExecutorTable
    "

    "Modified: 8.7.1996 / 19:15:28 / cg"
    "Created: 10.7.1996 / 14:41:02 / cg"
!

initializeFileExtensionTable
    "setup the table mapping file-name extensions to 
     internal document types"

    FileExtensionTable isNil ifTrue:[
        FileExtensionTable := Dictionary new.
        
        FileExtensionTable at:'txt'  put:#('internal-gopher-text'   'text-plain').
        FileExtensionTable at:'htm'  put:#('internal-gopher-text'   'text-html').
        FileExtensionTable at:'html' put:#('internal-gopher-text'   'text-html').

        FileExtensionTable at:'gif'  put:#('internal-gopher-image'  'image-gif').
        FileExtensionTable at:'tiff' put:#('internal-gopher-image'  'image-tiff').
        FileExtensionTable at:'xbm'  put:#('internal-gopher-image'  'image-xbm').
        FileExtensionTable at:'xpm'  put:#('internal-gopher-image'  'image-xbm').

        FileExtensionTable at:'au'   put:#('internal-gopher-sound'  'misc-sound-au').
        FileExtensionTable at:'dir'  put:#('internal-gopher-menu'   'misc-dir').
        FileExtensionTable at:'exe'  put:#('internal-gopher-binary' 'misc-binary').
    ].

    "
     FileExtensionTable := nil.
     self initializeFileExtensionTable
    "

    "Created: 8.7.1996 / 18:50:51 / cg"
    "Modified: 10.4.1997 / 10:30:43 / cg"
!

initializeInternalImageTable
    "setup the table mapping internal document types to
     bitmap image filenames"

    InternalImageTable isNil ifTrue:[
        InternalImageTable := Dictionary new.
        
"/        InternalImageTable at:'internal-gopher-unknown' put:'file_unknown.xpm'.
"/        InternalImageTable at:'internal-gopher-text'    put:'file_text.xpm'.
"/        InternalImageTable at:'internal-gopher-text'    put:'file_text.xpm'.
"/        InternalImageTable at:'internal-gopher-image'   put:'file_image.xpm'.
"/        InternalImageTable at:'internal-gopher-sound'   put:'file_sound.xpm'.
"/        InternalImageTable at:'internal-gopher-menu'    put:'file_dir.xpm'.
"/        InternalImageTable at:'internal-gopher-binary'  put:'file_binary.xpm'.
"/        InternalImageTable at:'internal-gopher-binary'  put:'file_binary.xpm'.

        InternalImageTable at:'internal-gopher-unknown' put:'yellow_file_plain.xpm'.
        InternalImageTable at:'internal-gopher-text'    put:'yellow_file_text.xpm'.
        InternalImageTable at:'internal-gopher-index'   put:'yellow_file_text_index.xpm'.
        InternalImageTable at:'internal-gopher-image'   put:'yellow_file_image.xpm'.
        InternalImageTable at:'internal-gopher-sound'   put:'yellow_file_sound.xpm'.
        InternalImageTable at:'internal-gopher-menu'    put:'yellow_dir_plain.xpm'.
        InternalImageTable at:'internal-gopher-binary'  put:'yellow_file_binary.xpm'.
        InternalImageTable at:'internal-gopher-binary'  put:'yellow_file_binary.xpm'.

        InternalImageTable at:'internal-broken'         put:'broken.xpm'.
    ].

    "
     InternalImageTable := nil.
     self initializeInternalImageTable
    "

    "Created: 20.5.1996 / 20:29:56 / cg"
    "Modified: 17.6.1997 / 18:14:00 / cg"
!

internalImageTable
    InternalImageTable isNil ifTrue:[
        self initializeInternalImageTable
    ].
    ^ InternalImageTable
!

update:something with:aParameter from:changedObject
    (something == #save) ifTrue:[
        "
         smalltalk is about to save an image - don't save cachedImages
        "
        CachedImages := nil.
        ImageFlushProcess notNil ifTrue:[
            "no cache, so terminate cache flusher"
            ImageFlushProcess terminate.
            ImageFlushProcess := nil.
        ].
    ].

    "Created: 15.6.1996 / 16:42:07 / cg"
! !

!HTMLDocumentFrame class methodsFor:'accessing'!

documentSearchPathes
    "DocumentSearchPathes := nil"

    DocumentSearchPathes isNil ifTrue:[
        DocumentSearchPathes := self defaultDocumentSearchPathes.
    ].
    ^ DocumentSearchPathes

    "Modified: / 08-06-2010 / 17:36:31 / cg"
!

documentSearchPathesAdd:something
    "add path without language to search path for html documents "
    (self documentSearchPathes includes:something) ifFalse:[
        self documentSearchPathes add:something
    ].

    "Modified: / 08-06-2010 / 17:33:35 / cg"
!

imageResolverQuery
    "return the query which, when answered, will provide an image resolver"
    
    ^ ImageResolverQuery

    "Created: / 19-06-2018 / 17:01:48 / Claus Gittinger"
! !

!HTMLDocumentFrame class methodsFor:'cleanup'!

flushCachedImages
    CachedImages := nil

    "Created: 3.7.1996 / 13:53:13 / cg"
!

lowSpaceCleanup
    "cleanup in low-memory situations"

    self flushCachedImages

    "Created: / 20-05-1996 / 13:31:58 / cg"
    "Modified: / 03-07-1996 / 13:53:18 / cg"
    "Modified (comment): / 20-07-2017 / 12:06:31 / cg"
! !

!HTMLDocumentFrame class methodsFor:'defaults'!

defaultAlienAppletsEnabled
    ^ true.

    "
     self defaultAlienAppletsEnabled  
    "

    "Modified: 3.8.1997 / 19:14:01 / cg"
    "Created: 7.8.1997 / 14:49:15 / cg"
!

defaultDocumentSearchPathes
    "default value for the 'DocumentSearchPathes' instance variable (automatically generated)"

    |paths|

    paths := OrderedCollection new.
    paths add:('../doc/online' asFilename).
    paths add:('../../doc/online' asFilename).
    paths add:('doc/online' asFilename).

    "/ for books
    paths add:('doc/' asFilename).
    paths add:('../doc/' asFilename).
    paths add:('../../doc/' asFilename).

    ^ paths

    "Modified: / 08-06-2010 / 17:36:07 / cg"
!

defaultHTMLExtension
    ^ HTMLExtension

    "
     self defaultHTMLExtension  
    "

    "Modified: 20.5.1996 / 19:14:39 / cg"
    "Created: 20.5.1996 / 20:29:29 / cg"
!

defaultInternalAppletsEnabled
    ^ true

    "
     self defaultInternalAppletsEnabled  
    "

    "Modified: 3.8.1997 / 19:13:35 / cg"
    "Created: 7.8.1997 / 14:49:23 / cg"
!

defaultJavaAppletsEnabled
    ^ true.

    "
     self defaultJavaAppletsEnabled  
    "

    "Modified: 3.8.1997 / 19:13:48 / cg"
    "Created: 7.8.1997 / 14:49:20 / cg"
!

defaultScriptExecutionEnabled
    ^ false

    "
     self defaultScriptExecutionEnabled  
    "

    "Modified: 20.5.1996 / 19:14:39 / cg"
    "Created: 7.8.1997 / 14:49:27 / cg"
!

documentFileFor:relativeOrAbsolutePath
    "given a relative path in the documentation hierarchy,
     find the file's absolute path - first trying the current language,
     if not found, try an english version"

    ^ self documentFileFor:relativeOrAbsolutePath searchIn:nil

    "
    self documentSearchPathesAdd:'./stx/doc/online'.
     Smalltalk language:#en.
     self documentFileFor:'TOP.html'.
     self documentFileFor:'programming/viewintro.html'

     Smalltalk language:#de.
     self documentFileFor:'TOP.html'.
     self documentFileFor:'programming/viewintro.html'
    "

    "Created: / 20-05-1996 / 20:29:29 / cg"
    "Modified: / 26-01-2011 / 18:02:51 / cg"
!

documentFileFor:relativeOrAbsolutePath searchIn:pathesOrNil
    "given a relative path in the documentation hierarchy,
     find the file's absolute path - first trying the current language,
     if not found, try an english version"

    |file lang paths|

    lang := UserPreferences current language.

    "XXX Kludge for now, map ISO-639 abbreviations to dir names.
     Should rename the directories"

    lang == #en ifTrue:[
        lang := #english.
    ] ifFalse:[lang == #de ifTrue:[
        lang := #german.
    ] ifFalse:[lang == #fr ifTrue:[
        lang := #french.
    ] ifFalse:[lang == #it ifTrue:[
        lang := #italian.
    ] ifFalse:[lang == #es ifTrue:[
        lang := #spanish.
    ] ifFalse:[lang == #jp ifTrue:[
        lang := #japanese.
    ]]]]]].

    paths := OrderedCollection withAll:(self documentSearchPathes).
    pathesOrNil notNil ifTrue:[
        paths := pathesOrNil asOrderedCollection , paths
    ].

    paths do:[:eachPath|
        file :=  Smalltalk getSystemFileName:(((eachPath asFilename construct:lang) construct:relativeOrAbsolutePath) pathName).
        file notNil ifTrue:[ ^ file ].
    ].
    paths do:[:eachPath|
        file :=  Smalltalk getSystemFileName:(((eachPath asFilename construct:'english') construct:relativeOrAbsolutePath) pathName).
        file notNil ifTrue:[ ^ file ].
    ].
    paths do:[:eachPath|
        file :=  Smalltalk getSystemFileName:((eachPath asFilename construct:relativeOrAbsolutePath) pathName).
        file notNil ifTrue:[ ^ file ].
    ].

    ^ file

    "
    self documentSearchPathesAdd:'./stx/doc/online'.
     Smalltalk language:#en.
     self documentFileFor:'TOP.html'.
     self documentFileFor:'programming/viewintro.html'

     Smalltalk language:#de.
     self documentFileFor:'TOP.html'.
     self documentFileFor:'programming/viewintro.html'
    "

    "Created: / 20-05-1996 / 20:29:29 / cg"
    "Modified: / 26-01-2011 / 18:02:51 / cg"
! !

!HTMLDocumentFrame class methodsFor:'startup'!

onFile:aDocumentName in:aView
    "create a documentationView on aDocumentName in some other view.
     Returns the htmlView"

    ^ self
        onFile:aDocumentName text:nil top:nil in:aView

    "example: wrapping a documentViewer into another view:

     |top panel list bottom htmlView|

     top := StandardSystemView new.
     panel := VariableVerticalPanel origin:0.0@0.0 corner:1.0@1.0 in:top.
     list := ScrollableView for:FileSelectionList origin:0.0@0.0 corner:1.0@0.25 in:panel.
     list directory:'../../doc/online/english'.
     list action:[:arg | 
                        htmlView setTopDirectoryName:(list directory pathName).
                        htmlView showFileDocument:(list selectedPathname)
                 ].
     list matchBlock:[:name | '*.html' match:name].
     bottom := View origin:0.0@0.25 corner:1.0@1.0 in:panel.
     htmlView := HTMLDocumentView onFile:'../../doc/online/english/TOP.html' in:bottom.

     top open
    "

    "Created: 20.5.1996 / 20:29:56 / cg"
    "Modified: 19.3.1997 / 20:38:38 / cg"
!

onFile:aFileName text:htmlText top:topDirectory in:top
    "create a documentationView on aDocumentName or htmlText in
     some other view. Returns the htmlView.
     Helper for onFile:in: and onText:in:"

    |scrollFrame htmlView file directory|

    scrollFrame := HVScrollableView for:self miniScrollerH:true miniScrollerV:false in:top.
    scrollFrame origin:0.0@0.0 corner:1.0@1.0.
    htmlView := scrollFrame scrolledView.

    aFileName isNil ifTrue:[
        htmlView homeText:htmlText.
        directory := topDirectory.
    ] ifFalse:[        
        file := aFileName asFilename.
        topDirectory notNil ifTrue:[
            directory := topDirectory.
        ] ifFalse:[
            directory := file directoryName.
        ].
        htmlView homeDocument:(file baseName).
    ].
    htmlView setTopDirectoryName:directory.
    ^ htmlView

    "Created: 20.5.1996 / 20:29:56 / cg"
    "Modified: 10.1.1997 / 11:53:27 / cg"
!

onText:htmlText in:aView
    "create a documentationView on htmlText (must be html) in some other view.
     Returns the htmlView."

    ^ self
        onFile:nil text:htmlText top:nil in:aView

    "example: wrapping a documentViewer into another view:

     |top panel list bottom htmlView|

     top := StandardSystemView new.
     panel := VariableVerticalPanel origin:0.0@0.0 corner:1.0@1.0 in:top.
     list := ScrollableView for:FileSelectionList origin:0.0@0.0 corner:1.0@0.25 in:panel.
     list directory:'../../doc/online/english'.
     list action:[:arg | 
                        htmlView setTopDirectoryName:(list directory pathName).
                        htmlView showFileDocument:(list selectedPathname)
                 ].
     list matchBlock:[:name | '*.html' match:name].
     bottom := View origin:0.0@0.25 corner:1.0@1.0 in:panel.
     htmlView := self 
                    onText:'
<html>
<body>
<h1>some text</h1>
</body>
</html>
' 
                    in:bottom.

     top open
    "

    "Created: 20.5.1996 / 20:29:56 / cg"
    "Modified: 19.3.1997 / 20:38:46 / cg"
! !

!HTMLDocumentFrame methodsFor:'accessing'!

bind:key to:value
    additionalBindings isNil ifTrue:[
        additionalBindings := Dictionary new.
    ].
    value isNil ifTrue:[
        additionalBindings removeKey:key ifAbsent:nil
    ] ifFalse:[
        additionalBindings at:key put:value.
    ].

    "Created: 11.10.1996 / 12:51:56 / cg"
!

canGoBackHolder
    "a valueholder which holds true, if there is an URL history entry 
     to which we can go back"

    canGoBackHolder isNil ifTrue:[
        canGoBackHolder := false asValue
    ].
    ^ canGoBackHolder
!

currentDirectoryName
    "return the current URLs directoryName"

    ^ currentDirectoryName

    "Created: 11.9.1996 / 21:01:05 / cg"
    "Modified: 6.8.1997 / 13:25:10 / cg"
!

currentDocument
    "return the current document"

    ^ currentDocument

    "Created: 11.9.1996 / 21:01:14 / cg"
    "Modified: 6.8.1997 / 13:24:55 / cg"
!

currentURL
    "return the current documents URL"

    ^ currentURL

    "Created: 11.9.1996 / 21:01:50 / cg"
    "Modified: 6.8.1997 / 13:24:44 / cg"
!

defaultViewBackgroundColor
    ^ styleSheet colorAt:'htmlBackgroundColor' default:(View defaultViewBackgroundColor).

    "Modified: 12.6.1996 / 18:21:09 / cg"
    "Created: 12.6.1996 / 18:21:58 / cg"
!

documentAnchor
    ^ documentAnchor
!

documentEncoding
    ^ documentEncoding

    "Created: 30.6.1997 / 11:22:50 / cg"
!

documentEncoding:anEncodingSymbol
    documentEncoding := anEncodingSymbol.
    fontEncoding := self fontEncodingFor:documentEncoding.

"/    Transcript show:'docEncoding: '; showCR:documentEncoding.
"/    Transcript show:'fontEncoding: '; showCR:fontEncoding.

    "Modified: 1.7.1997 / 00:50:11 / cg"
!

enableActionLinks:something
    enableActionLinks := something.
!

enableExternalLinks:something
    enableExternalLinks := something.
!

forms
    ^ painter forms
!

getDocumentFilename:urlString
    "only resolves local files - not URLs"
    
    |fileName convertedFileName f current|

    "/ netscape compatibility
    (urlString startsWith:'internal-') ifTrue:[
        (Array with:urlString
               with:'internal-broken')
        do:[:fn |
            fileName := self class internalImageTable at:fn ifAbsent:nil.
            fileName notNil ifTrue:[
                #('bitmaps/xpmBitmaps/document_images/'
                  'bitmaps/' 'xpmBitmaps/document_images/' '') do:[:path |
                
                    f := Smalltalk getBitmapFileName:(path , fileName).
                    f notNil ifTrue:[
                        ^ f asFilename
                    ]
                ]
            ]
        ].
        fileName := Smalltalk getBitmapFileName:'brokenImage.xbm'.
        fileName notNil ifTrue:[
            ^ fileName asFilename
        ].
        ^ 'brokenImage.xbm' asFilename
    ].

    (urlString asFilename isAbsolute) ifTrue:[
        fileName := urlString
    ] ifFalse:[
        currentDirectoryName isNil ifTrue:[
            ^ urlString asFilename
        ].
        currentDirectoryName isURL ifTrue:[^ nil].
            
        current := currentDirectoryName asFilename.
        fileName := current constructString:urlString.

        fileName asFilename exists ifFalse:[
            convertedFileName := current constructString:urlString asLowercase.
            convertedFileName asFilename exists ifTrue:[
                ^ convertedFileName asFilename
            ].
            convertedFileName := current constructString:urlString asUppercase.
            convertedFileName asFilename exists ifTrue:[
                ^ convertedFileName asFilename
            ].
        ].

        fileName asFilename exists ifFalse:[
            "/ try top
            convertedFileName := topDirectoryName asFilename constructString:urlString.
            convertedFileName asFilename exists ifTrue:[
                ^ convertedFileName asFilename
            ].
        ]
    ].
    ^ fileName asFilename

    "Created: / 17-05-1996 / 17:02:44 / cg"
    "Modified: / 17-02-2017 / 10:27:55 / cg"
!

getDocumentSource:anchorHref action:action
    |rest method file idx found|

    anchorHref notNil ifTrue:[
        method := 'file'.
        idx := anchorHref indexOf:$:.
        (idx ~~ 0 and:[idx > 2]) ifTrue:[
            method := anchorHref copyTo:(idx - 1).
            rest := anchorHref copyFrom:(idx + 1).
        ] ifFalse:[
            rest := anchorHref
        ].

        "/
        "/ rest is everything after initial <method>:
        "/
        idx := rest indexOf:$# startingAt:idx + 1.
        found := false.
        [found or:[idx == 0]] whileFalse:[
            (rest at:idx+1) ~~ $# ifTrue:[
                found := true.
            ] ifFalse:[
                idx := rest indexOf:$# startingAt:idx+2
            ]
        ].
        idx ~~ 0 ifTrue:[
            file := (rest copyTo:(idx - 1)) asNilIfEmpty.
        ] ifFalse:[
            file := rest
        ].

        action notNil ifTrue:[
            idx := action indexOf:$:.
            idx ~~ 0 ifTrue:[
                method := action copyTo:(idx - 1).
                rest := action copyFrom:(idx + 1).
            ] ifFalse:[
                method := 'doit'.
                rest := action
            ].

            self topView withWaitCursorDo:[
                method = 'doit' ifTrue:[
                    Error handle:[:ex |
                        Dialog information:ex description.
                    ] do:[
                        Compiler evaluate:rest receiver:self
                    ]    
                ] ifFalse:[
                    (method = 'plain') ifTrue:[
                        ^ Error handle:[:ex |
                            Dialog information:ex description.
                            nil
                        ] do:[
                            Compiler evaluate:rest receiver:self.
                        ].
                    ] ifFalse:[
                        (method = 'html') ifTrue:[
                            ^ Error handle:[:ex |
                                Dialog information:ex description.
                                nil
                            ] do:[
                                Compiler evaluate:rest receiver:self.
                            ].
                        ] ifFalse:[
"/                          self halt:'unexpected anchor'
                        ]
                    ]
                ]
            ]
        ] ifFalse:[
            file notNil ifTrue:[
                method = 'file' ifTrue:[
                    ^ self getFileSource:file
                ] ifFalse:[
"/                  self halt:'unexpected anchor'
                ]
            ]
        ].
    ].
    ^ nil

    "Created: / 21-05-1996 / 10:07:40 / cg"
    "Modified: / 22-08-1998 / 16:06:59 / cg"
    "Modified: / 08-02-2017 / 19:05:31 / stefan"
!

getFileSource:urlString
    |fileName text|

    urlString notNil ifTrue:[
        self topView withCursor:(Cursor read) do:[
            fileName := self getDocumentFilename:urlString.
            [
                fileName isDirectory ifFalse:[
                    text := fileName contentsOfEntireFile.
                ].
            ] on: FileStream openErrorSignal do:[:ex| "do nothing"].
        ].
    ].

    ^ text

    "Created: 21.5.1996 / 10:06:21 / cg"
!

history
    urlHistory isNil ifTrue:[
        urlHistory := OrderedCollection new.
    ].
    ^ urlHistory

    "Created: 21.9.1996 / 16:54:43 / cg"
    "Modified: 21.9.1996 / 16:58:51 / cg"
!

homeDocument:urlString
    homeDocument := urlString.
    homeText := nil.
    "/ self showFileDocument:urlString anchor:nil remember:true.
    self showDocument:urlString.

    "Created: / 17.5.1996 / 17:05:41 / cg"
    "Modified: / 23.1.1998 / 12:24:15 / cg"
!

homeText:someText
    homeDocument := nil.
    homeText := someText.
    currentURLHost := nil.

    self 
        rememberDocument:nil 
        host:nil 
        text:someText 
        action:nil 
        inHistory:true.

    currentURL := 'internal'.

    self 
        setText:someText 
        anchor:nil 
        documentName:nil.

    "Modified: 13.9.1996 / 16:14:24 / cg"
!

infoDisplay:aString
    infoHolder notNil ifTrue:[
        infoHolder value:aString
    ].

    "Created: 21.9.1996 / 14:24:07 / cg"
!

infoHolder:aValueHolder
    infoHolder := aValueHolder.
    aValueHolder notNil ifTrue:[
        self enableEvent:#pointerMotion
    ]

    "Created: 25.7.1996 / 12:02:58 / cg"
    "Modified: 21.9.1996 / 14:23:54 / cg"
!

locationDisplay:aString
    uriHolder notNil ifTrue:[
        uriHolder value:aString
    ].
    uriInputHolder notNil ifTrue:[
        uriInputHolder removeDependent:self.
        uriInputHolder value:aString.
        uriInputHolder addDependent:self.
    ].

    "Created: / 21.9.1996 / 14:21:19 / cg"
    "Modified: / 17.4.1998 / 21:23:25 / cg"
!

model:aValueHolder
    aValueHolder ~~ model ifTrue:[
        super model:aValueHolder.
        self setText:model value.
    ]
!

painter
    ^ painter

    "Created: 21.9.1996 / 14:47:46 / cg"
!

rememberDocument:url host:urlHost text:text action:action inHistory:inHistory
    "remember that the current document was ever visited.
     This affects the color in which corresponding anchor elements are drawn.
     If inHistory is true, it is also remembered in the back-history"

    |newEntry lastEntry|

    documentAnchor notNil ifTrue:[
        inHistory ifTrue:[
            self getVerticalPosition.

            newEntry := HRefHistoryEntry new
                url:url action:action anchor:nil position:currentPercentage text:text host:urlHost.

            hRefHistory size > 0 ifTrue:[
                lastEntry := hRefHistory last.
                lastEntry = newEntry ifTrue:[^ self].
            ].

            self getVerticalPosition.

            hRefHistory isNil ifTrue:[
                hRefHistory := OrderedCollection new
            ].
            hRefHistory addLast:newEntry.
            url notNil ifTrue:[
                urlHistory isNil ifTrue:[
                    urlHistory := OrderedCollection new.
                ].
                self canGoBackHolder value:(urlHistory size > 1
                                           or:[ (urlHistory size == 1) and:[urlHistory first ~= currentURL]] ).
                urlHistory addLast:url.
            ].
        ].

        action notNil ifTrue:[
            visitedActions isNil ifTrue:[
                visitedActions := Set new.
            ].
            visitedActions add:action.
        ] ifFalse:[
            url notNil ifTrue:[
                visitedUrls isNil ifTrue:[
                    visitedUrls := Set new.
                ].
                visitedUrls add:url.
            ].
        ]
    ].

    "Created: / 13-09-1996 / 16:13:13 / cg"
    "Modified: / 08-08-2010 / 15:20:18 / cg"
!

setTopDirectoryName:aDirectoryName
    topDirectoryName := currentDirectoryName := aDirectoryName

    "Created: 20.5.1996 / 19:19:00 / cg"
!

showImages:aBoolean
    "turn on/off image display"

    showImages := aBoolean

    "Created: 10.1.1997 / 11:47:35 / cg"
!

showInfo:aString
    self infoDisplay:aString

    "Created: 11.10.1996 / 13:33:47 / cg"
!

style
    "returns the style information; a dictionary filled with
     font-, color- and other information"

    ^ style

    "Created: 11.10.1996 / 13:06:20 / cg"
!

updateLabelFlag:aBoolean
    <resource: #obsolete>
    self obsoleteMethodWarning.
    self updateTopViewsTitleFlag:aBoolean
!

updateTopViewsTitleFlag:aBoolean
    "When I encounter a <title>-element, I can optionally update my topview's window title.
     This behavior can be controlled by setting/clearing this flag.
     The default is false (explicitly turned on by the HTMLDocumentView)"

    updateTopViewsTitleFlag := aBoolean
!

uriHolder:aValueHolder
    uriHolder := aValueHolder.

    "Created: / 25.7.1996 / 12:04:57 / cg"
    "Modified: / 17.4.1998 / 21:22:28 / cg"
!

uriInputHolder:aValueHolder
    uriInputHolder notNil ifTrue:[
        uriInputHolder removeDependent:self
    ].
    uriInputHolder := aValueHolder.
    uriInputHolder notNil ifTrue:[
        uriInputHolder addDependent:self
    ].

    "Modified: / 17.4.1998 / 19:53:00 / cg"
    "Created: / 17.4.1998 / 21:22:22 / cg"
!

visitedURLs
    ^ visitedUrls

    "Created: 11.9.1996 / 21:01:50 / cg"
    "Modified: 21.9.1996 / 14:16:31 / cg"
! !

!HTMLDocumentFrame methodsFor:'accessing-behavior'!

anchorActionPerformer
    "if set, this block gets all anchor actions to be performed,
     before ANY internal action is attempted.
     The block should return true if it handled the click.
     Useful to divert any link action to an external browser."

    ^ anchorActionPerformer

    "Modified (comment): / 12-06-2017 / 14:08:16 / mawalch"
!

anchorActionPerformer:aBlock
    "if set, this block gets all anchor actions to be performed,
     before ANY internal action is attempted.
     The block should return true if it handled the click.
     Useful to divert any link action to an external browser."

    anchorActionPerformer := aBlock

    "Modified (comment): / 12-06-2017 / 14:08:13 / mawalch"
!

linkActionPerformer
    "can be set from applications which embed an html view and want to be
     called back when an action-link is pressed.
     This avoids the smelly habbit of adding private methods as extensions
     to this class (eg. Jan's quickFix).
     To use, set the linkActionPerformer in your postBuild method,
     then generate action anchors of the form: <A action='doit: linkActionPerformer doSomething'>"
     
    ^ linkActionPerformer
!

linkActionPerformer:something
    "set a link-action performer.
     Can be set from applications which embed an html view and want to be
     called back when an action-link is pressed.
     This avoids the smelly habbit of adding private methods as extensions
     to this class (eg. Jan's quickFix).
     To use, set the linkActionPerformer in your postBuild method,
     then generate action anchors of the form: <A action='doit: linkActionPerformer doSomething'>
    "

    linkActionPerformer := something.
!

masterClickActionPerformer:aBlock
    "if set, this block gets invoked with element and click position
     before ANY internal action or other action is attempted.
     The block should return true, if it handled the click.   
     Useful to divert any click action to an external tool/browser
     (can also be used to filter clocks on some elements)."
     
    masterClickActionPerformer := aBlock
!

selfInDoitExpressions:someone
    "if set, that one will be 'self' in a doit expression.
     If not set, the DocumentFrame itself will play this role"

    selfInDoitExpressions := someone
! !

!HTMLDocumentFrame methodsFor:'accessing-document'!

localImageAt:url put:anImage
    "when using the html-view internally, this allows for images to be provided by
     Smalltalk, without a need for a file or http-service"

    localImages at:url put:anImage
!

performAction:action source:source documentName:urlString remember:rem
    "an action link:
        <A action='doit: <ST-expr>'
     a browse-action link
        <A action='browse: <class>'
     a plain-text generating link:
        <A action='plaintext: <ST-expr>'
     an html-text generating link:
        <A action='htmltext: <ST-expr>'

     inside a doit expression, 'self' will be bound to selfInDoitExpressions,
     which - if never set - defaults to the receiver (i.e. the HTMLDocumentFrame itself).
    "        

    |rest method idx text|

    idx := action indexOf:$:.
    idx ~~ 0 ifTrue:[
        method := (action copyTo:(idx - 1)) asLowercase.
        rest := action copyFrom:(idx + 1).
    ] ifFalse:[
        method := 'doit'.
        rest := action
    ].

    method = 'doit' ifTrue:[
        "/
        "/ only execute - no text loading
        "/
        Error handle:[:ex |
            catchErrors ifFalse:[
                ex reject
            ].
            ex mayProceed ifTrue:[
                (Dialog 
                    confirm:(resources stringWithCRs:'Error encountered while evaluating the example:\\%1\\Proceed?' with:ex description))
                ifTrue:[ex proceed].    
            ] ifFalse:[    
                Dialog 
                    warn:(resources stringWithCRs:'Error encountered while evaluating the example:\\%1' with:ex description)
            ].
        ] do:[
            Compiler evaluate:rest receiver:selfInDoitExpressions.
        ].
        ^ self
    ].

    (method = 'browse' or:[method = 'browseit']) ifTrue:[
        "/
        "/ only open a browser - no text loading
        "/
        Error handle:[:ex |
            catchErrors ifFalse:[
                ex reject
            ].
            Dialog 
                warn:(resources stringWithCRs:'error encountered while opening browser:\\%1' with:ex description) 
"/                    'HTML [info]: error while evaluating expression' infoPrintCR
        ] do:[
            |cls|

            cls := Smalltalk at:(rest withoutSeparators asSymbol).
            cls notNil ifTrue:[
                cls autoload.
                Smalltalk browseInClass:cls.
            ]
        ].
        ^ self
    ].

    (method = 'plain' or:[method = 'plaintext']) ifTrue:[
        "/
        "/ action returns plain text
        "/
        Error handle:[:ex |
            catchErrors ifFalse:[
                ex reject
            ].
            Dialog 
                warn:(resources stringWithCRs:'error encountered while evaluating the example:\\%1' with:ex description) 
"/                        'HTML [info]: error while evaluating expression' infoPrintCR
        ] do:[
            text := Compiler evaluate:rest receiver:selfInDoitExpressions.
        ].
        (text notEmptyOrNil) ifTrue:[
            self 
                setText:text 
                plain:true 
                anchor:nil 
                documentName:urlString
                remember:rem.
            visitedActions isNil ifTrue:[
                visitedActions := Set new.
            ].
            visitedActions add:action.
            currentAction := action.
        ].
        ^ self
    ].

    "/
    "/ action returns html text
    "/
    (method = 'html' or:[method = 'htmltext']) ifTrue:[
        Error handle:[:ex |
            |con|
            
            catchErrors ifFalse:[
                ex reject
            ].
            'HTML [info]: error while evaluating expression:' infoPrintCR.
            ('HTML [info]: signal: ' , ex creator printString) infoPrintCR.
            con := ex suspendedContext.
            ('HTML [info]: context: ' , con printString) infoPrintCR.
            1 to:4 do:[:i |
                con notNil ifTrue:[
                    con := con sender.
                    ('HTML [info]:        : ' , con printString) infoPrintCR.
                ].
            ].
            con := nil.
            Dialog 
                warn:(resources stringWithCRs:'error encountered while generating the document:\%1\\with:\%2' 
                        with:ex description with:rest) 
        ] do:[
            text := Compiler evaluate:rest receiver:selfInDoitExpressions.
        ].
        (text notEmptyOrNil) ifTrue:[
            self 
                setText:text 
                plain:source 
                anchor:nil 
                documentName:urlString 
                remember:rem.
            visitedActions isNil ifTrue:[
                visitedActions := Set new.
            ].
            visitedActions add:action.
            currentAction := action.
        ]
    ] ifFalse:[
        ('HTML [info]: unsupported action method: ' , method) infoPrintCR
    ]
!

setText:text
    "set the text - see example"

    AbortOperationRequest catch:[
        self 
            setText:text 
            header:nil 
            footer:nil 
            id:nil 
            anchor:nil
    ]

    "Modified: 22.4.1996 / 22:41:11 / cg"
    "Created: 17.5.1996 / 17:09:14 / cg"
!

setText:text anchor:anchor
    "set the text - see example"

    AbortOperationRequest catch:[
        self 
            setText:text 
            header:nil 
            footer:nil 
            id:nil 
            anchor:anchor
    ]

    "Modified: 22.4.1996 / 22:41:01 / cg"
    "Created: 17.5.1996 / 17:12:07 / cg"
!

setText:text anchor:anchor documentName:documentName
    self
        setText:text
        plain:false
        anchor:anchor 
        documentName:documentName
        remember:false

    "Modified: 20.4.1996 / 19:42:52 / cg"
    "Created: 17.5.1996 / 17:11:07 / cg"
!

setText:text header:header footer:footer id:elementId anchor:anchor
    "set the text - see examples"

    |s clearProcess oldDocHeight oldDocWidth 
     newDocHeight newDocWidth didClear|

    didClear := false.
    oldDocHeight := self heightOfContents.
    oldDocWidth := self widthOfContents.

    "/ instead of clearing immediately,
    "/ fork a higher prio process which does the clearing
    "/ after a short delay.
    "/ this looks good on big documents (clearing them)
    "/ and avoids flashing on small documents, which are
    "/ ready before the clear time ...

    text notNil ifTrue:[
        shown ifTrue:[
            suppressRedraw ~~ true ifTrue:[
                clearProcess := 
                    [
                        Delay waitForMilliseconds:300.
                        shown ifTrue:[
                            self clear.
                            didClear := true.
                        ].
                        clearProcess := nil.
                    ] forkAt:(Processor activePriority + 1).
            ]
        ].
    ].

    documentAnchor := nil.
    localImages := Dictionary new.
    infoHolder notNil ifTrue:[
        infoHolder value:''.
    ].

    suppressRedraw ~~ true ifTrue:[
        printing ifFalse:[
            self setViewOrigin:0@0.    
            "/ self scrollToTop.
        ]
    ].

    text notNil ifTrue:[
        |document|
        
        s := text isStream ifTrue:[ text ] ifFalse:[ text asString readStream ].
        document := HTMLParser new 
                        parseText:s 
                        withBindings:(self ampersandBindings)
                        for:self.
        document notNil ifTrue:[
            documentAnchor := document markup
        ].
    ].

    painter isNil ifTrue:[
        painter := HTMLDocumentPainter new.
        painter imageResolver:(ImageResolverQuery query).
    ] ifFalse:[
        "/ careful - could be called by a meta-command subprocess;
        "/ in this case do not terminate.
        accessLock critical:[
            TerminateProcessRequest catch:[
                painter release
            ].
        ].
    ].

    realized ifTrue:[
        documentLoadInProgress := true.
        [
            |styleToUse|

            styleToUse := printing ifTrue:[ printStyle ] ifFalse:[ style ].
            accessLock critical:[
                painter format:documentAnchor for:formatContext resolver:self style:styleToUse
            ]
        ] ensure:[
            documentLoadInProgress := false
        ]
    ].

    clearProcess notNil ifTrue:[
        clearProcess terminate.
    ].

    suppressRedraw ~~ true ifTrue:[
        (printing not and:[shown]) ifTrue:[
            didClear ifFalse:[
                self clear.
            ].
            self invalidate.
        ]
    ].

    newDocHeight := self heightOfContents.
    newDocWidth := self widthOfContents.

    printing ifFalse:[
        (newDocHeight ~~ oldDocHeight 
        or:[newDocWidth ~~ oldDocWidth]) ifTrue:[
            self changed:#sizeOfContents
        ]
    ]

    "Modified: / 25-10-2010 / 13:25:33 / cg"
    "Modified: / 19-06-2018 / 17:12:31 / Claus Gittinger"
!

setText:text plain:plain anchor:anchor documentName:documentName remember:rem
    |t txt|

    printing ifFalse:[
        self 
            rememberDocument:currentDocument 
            host:currentURLHost 
            text:nil 
            action:currentAction 
            inHistory:rem.
    ].

    plain ifTrue:[
        text isStream ifTrue:[
            txt := text contents asString
        ] ifFalse:[
            txt := text
        ].
        t := (txt copy replChar:$< withString:'&lt;')
                replChar:$> withString:'&gt;'.
        t := '<PLAIN><CODE><PRE>' , Character cr asString , t
                , Character cr asString , '</PRE></CODE></PLAIN>'.
    ] ifFalse:[
        t := text
    ].

"/    self topView withWaitCursorDo:[
        currentURL := documentName.

        self setText:t anchor:anchor.

        documentName ~= currentDocument ifTrue:[
"/            documentName ~~ nil ifTrue:[
                currentDocument := documentName.
                currentAction := nil.
                self getVerticalPosition
"/            ]
        ].

        "/ Transcript showCR:'currentDir = ' , currentDirectoryName.
        "/ Transcript showCR:'current = ' , currentDocument.
        "/ Transcript showCR:'on ' , anchor printString.
"/    ].

    "Created: 17.5.1996 / 17:11:44 / cg"
    "Modified: 18.9.1996 / 13:49:25 / cg"
!

showDocument:urlOrUrlString
    self 
        showDocument:urlOrUrlString 
        text:nil
        action:nil
        remember:true
        source:false

    "Created: 18.9.1996 / 16:28:26 / cg"
!

showDocument:url file:fileName onHost:aHost anchor:anchor remember:rem source:showSource
    |s text 
     myTopView newURLHost doRemember
     newDirectoryName newDocumentName
     info previousDocument previousURLHost previousAction|

    previousDocument := currentDocument.
    previousURLHost := currentURLHost.
    previousAction := currentAction.

    topDirectoryName isNil ifTrue:[
        topDirectoryName := '.'
    ].
    currentDirectoryName isNil ifTrue:[
        currentDirectoryName := '.'
    ].
    currentDocument notNil ifTrue:[
        currentDirectoryName := currentDocument asFilename directoryName.
    ].

    myTopView := self topView.
    url notNil ifTrue:[
        myTopView withCursor:(Cursor read) do:[
            info := self documentStreamForURL:url file:fileName onHost:aHost.
            info notNil ifTrue:[
                s := info at:1.
                s notNil ifTrue:[
                    newDocumentName := info at:2.
                    newDirectoryName := info at:3.
                    newURLHost := info at:4.
                ]
            ].

            s isNil ifTrue:[
                newDocumentName isNil ifFalse:[
                    self showNotFound:url.
                ].
                ^ self.
            ].

"/            uriHolder notNil ifTrue:[
"/                newDocumentName ~= uriHolder value ifTrue:[
"/                    uriHolder value:newDocumentName.
"/                ]
"/            ].
        ].
    ].

    newURLHost notNil ifTrue:[
        currentURLHost := newURLHost
    ].
"/    self setText:nil.

    (text isNil 
    and:[s isNil]) ifTrue:[
        newDocumentName notNil ifTrue:[
            self showEmpty:newDocumentName
        ].
    ] ifFalse:[

        myTopView withWaitCursorDo:[
            showSource ifTrue:[
                text isNil ifTrue:[
                    text := s contents asString.
                    s close
                ].
                text := (text copy replChar:$< withString:'&lt;')
                            replChar:$> withString:'&gt;'.
                text := '<TITLE>Source of ' , newDocumentName , '</TITLE>'
                        , Character cr asString 
                        , '<PLAIN><CODE><PRE>' , Character cr asString , text
                        , Character cr asString 
                        , '</PRE></CODE></PLAIN>'.
            ].

            "/ have to change the current dir before setting the new document
            "/ otherwise, resolveImage requests fail

            newDirectoryName notNil ifTrue:[
                currentDirectoryName := newDirectoryName.
                "
                 need the full pathName ...
                "
                currentDirectoryName := currentDirectoryName asFilename pathName.
            ].

            text isNil ifTrue:[
                self 
                    setText:s 
                    anchor:anchor 
                    documentName:newDocumentName.
            ] ifFalse:[
                self 
                    setText:text 
                    anchor:anchor 
                    documentName:newDocumentName.
            ].

            s close.
        ]
    ].

    doRemember := rem.
    self 
        rememberDocument:previousDocument
        host:previousURLHost
        text:nil 
        action:previousAction 
        inHistory:doRemember.

    "Modified: / 18.6.1996 / 10:35:40 / stefan"
    "Created: / 13.9.1996 / 13:14:37 / cg"
    "Modified: / 27.7.1998 / 19:45:06 / cg"
!

showDocument:url source:aBoolean
    self 
        showDocument:url 
        text:nil
        action:nil
        remember:true
        source:aBoolean

    "Created: 18.9.1996 / 16:45:33 / cg"
!

showDocument:urlOrUrlString text:anchorText action:action remember:rem source:source
    |url rest method host file|

    "/    Transcript show:'anchor selected text='; showCR:anchorText.
    "/    Transcript show:'anchor selected href='; showCR:url.

    urlOrUrlString isEmptyOrNil ifTrue:[
        action isNil ifTrue:[^ self].
        url := URL fromString:'/'.
    ] ifFalse:[
        urlOrUrlString isString ifTrue:[
            url := URL fromString:urlOrUrlString.
        ] ifFalse:[
            url := urlOrUrlString.
        ]
    ].
    uriHolder notNil ifTrue:[
        uriHolder value:(url printString).
    ].

    method := (url method) ? 'file'.

    (method = 'man') ifTrue:[
        |manPage|
        
        "/ manPage := HTMLDocGenerator manPageFor:(url host).
        true "manPage notEmptyOrNil" ifTrue:[
            self 
                showTextDocument:(url asString) 
                file:(url host) 
                method:'man' 
                remember:rem 
                source:'man page for ',(url host).
            ^ self
        ]
    ].
    
    file := url file.
    localAnchor := url anchor.
    host := currentURLHost := url host.
    rest := url rest.

    (file isNil and:[method notNil and:[host notNil]]) ifTrue:[ file := '/' ].

    action notNil ifTrue:[
        self topView withWaitCursorDo:[
            self performAction:action source:source documentName:url urlPrintString remember:rem.
        ].
    ] ifFalse:[
        (file notNil or:[host notNil]) ifTrue:[
            self showTextDocument:url file:file method:method remember:rem source:source.
        ]
    ].

    "/
    "/ there may still be a local anchor to visit
    "/
    localAnchor notNil ifTrue:[
        "/ Transcript showCR:'local: ' , localAnchor.
        "/ Transcript show:'id='; showCR:(self anchorToId:localAnchor).
        self positionOnAnchor:localAnchor.
    ].
    currentLocalAnchor := localAnchor

    "Created: / 17.5.1996 / 18:31:54 / cg"
    "Modified: / 20.7.1998 / 16:03:40 / cg"
!

showFileDocument:fileName
    self showFileDocument:fileName anchor:nil remember:false

    "Created: 20.5.1996 / 19:19:45 / cg"
    "Modified: 13.9.1996 / 16:47:20 / cg"
!

showFileDocument:fileName anchor:anchor remember:rem
    self showFileDocument:fileName anchor:anchor remember:rem source:false

    "Created: 17.5.1996 / 17:07:55 / cg"
    "Modified: 13.9.1996 / 16:47:09 / cg"
!

showFileDocument:fileName anchor:anchor remember:rem source:showSource
    ^ self
        showDocument:fileName 
        file:fileName
        onHost:currentURLHost 
        anchor:anchor 
        remember:rem 
        source:showSource

    "Modified: 13.9.1996 / 16:46:57 / cg"
!

showFileDocument:fileName remember:rem
    self showFileDocument:fileName anchor:nil remember:rem

    "Created: 20.5.1996 / 19:27:34 / cg"
    "Modified: 13.9.1996 / 16:47:24 / cg"
!

showTextDocument:urlString file:file method:method remember:rem source:source
    |text|

    (#('file' 'plainfile' 'http' 'https' 'ftp') includes:method)
    ifTrue:[
        self 
            showDocument:urlString
            file:file 
            onHost:currentURLHost 
            anchor:nil 
            remember:rem 
            source:source.
        ^ self
    ].

    method = 'man' ifTrue:[
        self withWaitCursorDo:[
            text := HTMLDocGenerator manPageFor:file.
        ].
        (text notEmptyOrNil) ifTrue:[
            self 
                setText:text 
                plain:false "/ source 
                anchor:nil 
                documentName:urlString 
                remember:rem.
            visitedActions isNil ifTrue:[
                visitedActions := Set new.
            ].
"/            visitedActions add:action.
"/            currentAction := action.
        ].
        ^ self
    ].

    ('HTML [info]: unsupported access method: ' , method) infoPrintCR

    "Modified: / 17-07-2018 / 15:13:40 / Claus Gittinger"
! !

!HTMLDocumentFrame methodsFor:'accessing-security'!

alienAppletsEnabled
    ^ enableAlienApplets

    "Modified: 18.9.1996 / 16:16:12 / cg"
    "Created: 18.9.1996 / 16:20:02 / cg"
!

catchErrors
    ^ catchErrors

    "Created: 7.8.1997 / 17:59:04 / cg"
!

enableAlienApplets:aBoolean
    enableAlienApplets := aBoolean.

    "Modified: 18.9.1996 / 16:16:12 / cg"
    "Created: 18.9.1996 / 16:16:45 / cg"
!

enableExecution:aBoolean
    enableExecution := aBoolean.

    "Modified: 18.9.1996 / 16:16:12 / cg"
!

enableInternalApplets:aBoolean
    enableInternalApplets := aBoolean.

    "Modified: 18.9.1996 / 16:16:12 / cg"
    "Created: 18.9.1996 / 16:16:41 / cg"
!

enableJavaApplets:aBoolean
    enableJavaApplets := aBoolean.

    "Modified: 18.9.1996 / 16:16:12 / cg"
    "Created: 7.8.1997 / 14:38:14 / cg"
!

enableScriptExecution:aBoolean
    enableScriptExecution := aBoolean.

    "Modified: 18.9.1996 / 16:16:12 / cg"
    "Created: 18.9.1996 / 16:16:35 / cg"
!

internalAppletsEnabled
    ^ enableInternalApplets

    "Modified: 18.9.1996 / 16:16:12 / cg"
    "Created: 18.9.1996 / 16:20:11 / cg"
!

javaAppletsEnabled
    ^ enableJavaApplets

    "Created: 7.8.1997 / 14:38:20 / cg"
!

nameSpaceForExecution:aNameSpace
    nameSpaceForExecution := aNameSpace

    "Created: 23.12.1996 / 12:19:29 / cg"
!

scriptExecutionEnabled
    ^ enableScriptExecution

    "Modified: 18.9.1996 / 16:16:12 / cg"
    "Created: 18.9.1996 / 16:20:30 / cg"
! !

!HTMLDocumentFrame methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == uriInputHolder ifTrue:[
        self showDocument:uriInputHolder value.
        ^ self
    ].
    changedObject == model ifTrue:[
        self updateFromModel.
        ^ self
    ].
    super update:something with:aParameter from:changedObject

    "Created: / 17.4.1998 / 19:54:04 / cg"
    "Modified: / 17.4.1998 / 21:23:39 / cg"
!

updateFromModel
    self setText:model value.
! !

!HTMLDocumentFrame methodsFor:'defaults'!

isManPageSuffix:suffix
    ^ #('1' 'man') includes:suffix asLowercase

    "Created: 9.1.1997 / 14:30:43 / cg"
    "Modified: 9.1.1997 / 14:31:42 / cg"
!

mimeTypeFromSuffix:suffix
    |lcSuffix type|

    lcSuffix := suffix asLowercase.
    (type := MIMETypes mimeTypeForSuffix:lcSuffix) notNil ifTrue:[
        ^ type
    ].

    ^ nil

    "
     self basicNew mimeTypeFromSuffix:'gif' 
     self basicNew mimeTypeFromSuffix:'htm' 
     self basicNew mimeTypeFromSuffix:'qt' 
    "

    "Modified: 1.7.1997 / 00:17:59 / cg"
! !

!HTMLDocumentFrame methodsFor:'document painter callBacks'!

appletClass:className fromURL:url
    ^ self
        appletClass:className 
        fromURL:url 
        archive:nil

    "Modified: / 14.10.1998 / 13:22:15 / cg"
!

appletClass:className fromURL:url archive:archiveURLOrNil
    |clsName inStream srcStream bos cls fullPath appletNamespace|

    archiveURLOrNil notNil ifTrue:[
        ^ #delayedJavaLoad
    ].

    clsName := className.
    clsName isNil ifTrue:[
        clsName := url asFilename withoutSuffix baseName
    ].


    fullPath := self fullURLPathFor:url.
    fullPath isNil ifTrue:[
        fullPath := url.
        fullPath asFilename suffix size == 0 ifTrue:[
            fullPath := fullPath , '.class'
        ]
    ].

    loadedAppletClasses notNil ifTrue:[
        cls := loadedAppletClasses at:fullPath ifAbsent:nil.
        cls notNil ifTrue:[
            ('HTML [info]: class in: ' , url , ' is already loaded.') infoPrintCR.
            ^ cls
        ].
    ].

    "/ make certain, Applet is not autoloaded into wrong
    "/ NameSpace (in code below) ...

    Applet autoload.

    ('HTML [info]: loading binary applet from: ' , url) infoPrintCR.

    enableJavaApplets == true ifTrue:[
        ((fullPath asFilename hasSuffix:'class') 
        or:[fullPath asFilename hasSuffix:'CLASS']) ifTrue:[

            JavaClassReader notNil ifTrue:[
                Autoload autoloadFailedSignal handle:[:ex |
                ] do:[
                    JavaClassReader autoload.
                ]
            ].

            (JavaClassReader notNil 
            and:[JavaClassReader isLoaded]) ifTrue:[
                "/ new - let appletLoader (via embeddedAppletFrame) doit
                ^ #delayedJavaLoad.

"/                "/ try java class loading first ...
"/                JavaClassReader invalidClassFormatSignal handle:[:ex |
"/                    cls := nil.
"/                    ex return.
"/                ] do:[
"/                    inStream := self codeStreamFor:url.
"/                    inStream isNil ifTrue:[
"/                        ('HTML [warning]: cannot load applet from: ' , url) errorPrintCR.
"/
"/                        ^ nil
"/                    ].
"/                    cls := JavaClassReader readStream:inStream.
"/                    ('HTML [info]: loaded javaClass: ' , cls printString , ' from: ' , url) infoPrintCR.
"/                    inStream close.
"/                ].
            ]
        ]
    ].

    cls isNil ifTrue:[
        "/ try smalltalk class ...

        inStream := self codeStreamFor:url.
        inStream isNil ifTrue:[
            ('HTML [warning]: cannot load applet from: ' , url) errorPrintCR.

            ^ nil
        ].

        bos := BinaryObjectStorage onOld:inStream.

        "/ create a private namespace ...

        Class withoutUpdatingChangesDo:[
            appletNamespace := AnonymousAppletClasses ifFalse:[Smalltalk] ifTrue:[NameSpace name:'Applets'].
        ].

        "/ load class into that ...

        Class nameSpaceQuerySignal answer:appletNamespace
        do:[
            BinaryIOManager binaryLoadErrorSignal handle:[:binEx |
                url asFilename suffix = 'cls' ifTrue:[
                    srcStream := self codeStreamFor:(url asFilename withSuffix:'st') name.
                    srcStream notNil ifTrue:[
                        "/ try source if present.
                        (self confirm:'load of binary applet code (''' , clsName , ''') failed.

Reason: ' , binEx description , '

Trying source load ?') 
                        ifTrue:[
                            srcStream text.
                            Error handle:[:ex |
                                self warn:'load of applet code (''' , clsName , ''') failed.

Reason: ' , ex description.
                                ex return
                            ] do:[
                                ('HTML [info]: loading source applet from: ' , (url asFilename withSuffix:'st') name) infoPrintCR.
                                Class withoutUpdatingChangesDo:[
                                    srcStream fileIn.
                                ].
                                srcStream close.
                                cls := appletNamespace at:clsName asSymbol.
                            ]
                        ].
                        binEx return
                    ].
                ].

                self warn:'load of applet code (''' , clsName , ''') failed.

Reason: ' , binEx description.
                cls := nil.
                binEx return
            ] do:[
                Error handle:[:ex |
                    BinaryIOManager binaryLoadErrorSignal raise
                ] do:[
                    cls := bos next.
                ]
            ].
        ].
        bos close.
    ].

    cls notNil ifTrue:[
        loadedAppletClasses isNil ifTrue:[
            loadedAppletClasses := Dictionary new.
        ].
        loadedAppletClasses at:fullPath put:cls.
    ].

    ^ cls

    "Created: / 14.10.1998 / 13:21:49 / cg"
    "Modified: / 22.10.1998 / 02:17:13 / cg"
!

codeStreamFor:url
    "returns a stream on a codeFile or nil"

    ^ self streamForURL:url.

    "Modified: 23.10.1996 / 22:23:54 / cg"
!

fullURLPathFor:url
    "returns an URL's full path"

    |urlString fileName path|

    urlString := url asUnixFilenameString.

    currentURLHost notNil ifTrue:[
        (urlString asFilename isAbsolute) ifTrue:[
            path := urlString.
        ] ifFalse:[
            currentDirectoryName ~= '/' ifTrue:[
                path := currentDirectoryName , '/' , urlString
            ] ifFalse:[
                path := '/' , urlString
            ]
        ].
        ^ 'http:' , '//' , currentURLHost , path.
    ].

    fileName := self getDocumentFilename:urlString.
    fileName exists ifFalse:[
        "/ if we are in an action, try homeDir as well
        "/ makes life so much easier.
        "/ Transcript showCR:'try home'.

        (urlString startsWith:'/') ifFalse:[
            topDirectoryName isNil ifTrue:[
                topDirectoryName := self class documentFileFor:''
            ].
            fileName := (topDirectoryName , '/' , urlString) asFilename.
        ] ifTrue:[
            fileName := self getDocumentFilename:(urlString copyFrom:2).
        ]
    ].

    fileName exists ifTrue:[
        ^ fileName pathName
    ].

    ^ nil

    "Created: / 10.10.1996 / 20:07:53 / cg"
    "Modified: / 16.9.1997 / 14:35:13 / stefan"
    "Modified: / 18.7.1998 / 22:53:57 / cg"
!

imageFor:urlString
    "returns an image or nil"

    ^ self imageFor:urlString now:false

    "Modified: 23.10.1996 / 22:24:01 / cg"
!

imageFor:urlStringIn now:now
    "returns an image or nil. The argument now specifies, if the image
     should be converted to a device image right NOW or not.
     Usually, it is false (i.e. no interest in a device image) during
     document scan, and true when the image is to be displayed."

    |urlString fileName path image
     idx cacheEntry dImage txt reply info data imageType reader
     url method port file host base ftp newURL myURL|

    showImages ifFalse:[
        ^ nil
    ].

    urlString := urlStringIn asUnixFilenameString.

    localImages notNil ifTrue:[
        (image := localImages at:urlString ifAbsent:nil) notNil ifTrue:[
            now ifTrue:[
                dImage := image onDevice: device.
                dImage ~~ image ifTrue:[    
                    localImages at:urlString put:dImage.
                    ^ dImage
                ].
            ].
            ^ image.
        ].
    ].

    "/ if it resolves to a local file, take it.
    fileName := self getDocumentFilename:urlString.
    (fileName notNil and:[fileName exists]) ifFalse:[
        "/ if we are in an action, try homeDir as well
        "/ makes life so much easier.
        "/ Transcript showCR:'try home'.

        topDirectoryName isURL ifFalse:[
            (urlString startsWith:'/') ifFalse:[
                topDirectoryName isNil ifTrue:[
                    topDirectoryName := self class documentFileFor:''
                ].
                fileName := (topDirectoryName asFilename / urlString).
            ] ifTrue:[
                fileName := self getDocumentFilename:(urlString copyFrom:2).
            ]
        ].
    ].
    (fileName notNil and:[fileName exists]) ifFalse:[
        (urlString startsWith:'internal-') ifFalse:[
            currentDocument isNil ifTrue:[
                myURL := URL fromString:'.'.
            ] ifFalse:[
                myURL := URL fromString:currentDocument.
            ].
            url := URL fromString:urlString.
            method := (url method) ? (myURL method) ? 'file'.
            port := (url port) ? (myURL port).
            file := url file.
            host := (url host).

            base := '/'.
            host isNil ifTrue:[
                currentURLHost notNil ifTrue:[
                    method isNil ifTrue:[
                        method := 'http'.
                    ].
                    host := currentURLHost.
                    currentDirectoryName isURL ifTrue:[
                        base := currentDirectoryName path asUnixFilenameString.
                    ] ifFalse:[    
                        base := currentDirectoryName asFilename pathName asUnixFilenameString.
                    ]
                ]
            ].

            (method = 'ftp') ifTrue:[
                path := file.
                ftp := FTPClient new.
                FTPClient ftpErrorSignal catch:[
                    FTPClient connectFailedSignal handle:[:ex |
                        ^ nil
                    ] do:[
                        ftp connectTo:host.
                        ftp binary.
                        data := ftp get:path.
                        ftp close.
                    ].
                    data isNil ifTrue:[^ nil].
                    ^ ImageReader fromStream:(ReadStream on:data).
                ]
            ].

            ((method = 'http') or:[(method = 'https') or:[host notNil]]) ifTrue:[
                (file notNil and:[file startsWith:'/']) ifTrue:[
                    path := file.
                ] ifFalse:[
                    base ~= '/' ifTrue:[
                        path := base , '/' , urlString
                    ] ifFalse:[
                        path := '/' , urlString
                    ]
                ].

                HTTPInterface isNil ifTrue:[
                    Smalltalk loadPackage:'stx:goodies/communication'
                ].    
                reply := HTTPInterface 
                                get:path 
                                fromHost:host
                                port:port
                                fromDocument:currentDocument.
                reply isNil ifTrue:[
                    ^ nil 
                ].
                reply isErrorResponse ifTrue:[
    "/                reply responseCode == #unknownHost ifTrue:[
    "/                    ^ nil 
    "/                ].
    "/
    "/                reply responseCode == #unreachableHost ifTrue:[
    "/                    ^ nil 
    "/                ].
    "/
    "/                reply responseCode == #noResponse ifTrue:[
    "/                    ^ nil 
    "/                ].
                    ^ nil
                ].

                reply isMovedResponse ifTrue:[
                    newURL := reply location.
                    newURL isNil ifTrue:[^ nil].
                    ^ self imageFor:newURL now:now.
                ].

                txt := reply data.
                info := reply rawHeader.
                data := txt asByteArray.

                reader := ImageReader.
                idx := info findFirst:[:line | line asLowercase startsWith:'content-type:'].

                idx ~~ 0 ifTrue:[
                    imageType := info at:idx.
                    imageType := (imageType copyFrom:(imageType indexOfAny:':')+1) withoutSpaces asLowercase.
                    imageType := imageType upTo:$;.

                    reader := MIMETypes imageReaderForType:imageType.

    "/                imageType = 'image/gif' ifTrue:[
    "/                    reader := GIFReader
    "/                ] ifFalse:[
    "/                    imageType = 'image/tiff' ifTrue:[
    "/                        reader := TIFFReader
    "/                    ] ifFalse:[
    "/                        imageType = 'image/jpeg' ifTrue:[
    "/                            reader := JPEGReader
    "/                        ]
    "/                    ]
    "/                ]
                ].
                reader == ImageReader ifTrue:[
                    ^ nil
                ].
                image := reader fromStream:(ReadStream on:data).
                ^ image
            ].
        ].
    ].

    path := fileName pathName.

    "/ Transcript show:'image resolve: ' , urlString.
    "/ Transcript showCR:' -> ' , path.

    CachedImages notNil ifTrue:[
        idx := CachedImages findFirst:[:entry | 
                                                entry key = path ifTrue:[
                                                    cacheEntry := entry.    
                                                    image := entry value.
                                                    true.
                                                ] ifFalse:[
                                                    false       
                                                ]
                                      ].
        idx ~~ 0 ifTrue:[
            CachedImages addLast:(CachedImages removeAtIndex:idx).
            now ifTrue:[
                dImage := image onDevice: device.
                dImage ~~ image ifTrue:[
                    cacheEntry value:dImage.
                    image := dImage.
                ]
            ].
        ].

        image notNil ifTrue:[
            "/ Transcript showCR:'cached image ' , urlString.
        ].
    ].

    image isNil ifTrue:[
        "/ Transcript showCR:url , '->' , fileName asString.

        (fileName exists and:[fileName isDirectory not])ifTrue:[
            "/ Transcript showCR:'exists as ', path.
            image := Image fromFile:path.
            image isNil ifTrue:[
                ('HTMLDocumentView [info]: nonexisting image: ', path) infoPrintCR.
                ^ nil
            ].

            now ifTrue:[
                image := image onDevice: device.
            ].

            CachedImages isNil ifTrue:[
                CachedImages := OrderedCollection new:30.
            ] ifFalse:[
                CachedImages size > 30 ifTrue:[
                    CachedImages removeFirst
                ]
            ].

            CachedImages addLast:(path->image).

            self startImageFlushProcess.
        ].

        image isNil ifTrue:[
            ('HTMLDocumentView [info]: nonexisting image: ', path) infoPrintCR.
            ^ nil
        ].
    ].

    localImages at:urlString put:image.
    ^ image.

    "Created: / 17-05-1996 / 16:59:32 / cg"
    "Modified: / 16-01-1998 / 11:11:52 / stefan"
    "Modified: / 17-02-2017 / 14:09:42 / cg"
!

streamForURL:urlStringIn
    "returns a stream or nil"

    |urlString fileName path 
     txt reply data
     url method port file host base ftp|

    urlString := urlStringIn asUnixFilenameString.

    url := URL fromString:urlString.
    method := url method ? 'file'.
    port := url port.
    file := url file.
    host := url host.

    base := '/'.
    host isNil ifTrue:[
        currentURLHost notNil ifTrue:[
            method isNil ifTrue:[
                method := 'http'.
            ].
            host := currentURLHost.
            base := currentDirectoryName.
        ]
    ].


    ((method = 'http') or:[host notNil]) ifTrue:[
        (file startsWith:'/') ifTrue:[
            path := file.
        ] ifFalse:[
            base ~= '/' ifTrue:[
                path := base , '/' , urlString
            ] ifFalse:[
                path := '/' , urlString
            ]
        ].

        HTTPInterface isNil ifTrue:[
            Smalltalk loadPackage:'stx:goodies/communication'
        ].    
        reply := HTTPInterface 
                        get:path 
                        fromHost:host
                        port:port
                        fromDocument:currentDocument.
        reply isNil ifTrue:[
            ^ nil 
        ].
        reply isErrorResponse ifTrue:[
"/            reply responseCode == #unknownHost ifTrue:[
"/                ^ nil 
"/            ].
"/
"/            reply responseCode == #unreachableHost ifTrue:[
"/                ^ nil 
"/            ].
"/
"/            reply responseCode == #noResponse ifTrue:[
"/                ^ nil 
"/            ].
            ^ nil
        ].
"/        info := reply rawHeader.
        txt := reply data.
        data := txt asByteArray.

        ^ (ReadStream on:data).
    ].

    (method = 'ftp') ifTrue:[
        path := file.
        ftp := FTPClient new.
        FTPClient ftpErrorSignal catch:[
            FTPClient connectFailedSignal handle:[:ex |
                ^ nil
            ] do:[
                ftp connectTo:host.
                ftp binary.
                data := ftp get:path.
                ftp close.
            ].
            data isNil ifTrue:[^ nil].
            ^ (ReadStream on:data).
        ]
    ].

    (method isNil or:[method = 'file']) ifTrue:[
        fileName := self getDocumentFilename:urlString.
        fileName exists ifFalse:[
            "/ if we are in an action, try homeDir as well
            "/ makes life so much easier.

            (urlString startsWith:'/') ifFalse:[
                topDirectoryName isNil ifTrue:[
                    topDirectoryName := self class documentFileFor:''
                ].
                fileName := (topDirectoryName , '/' , urlString) asFilename.
            ] ifTrue:[
                fileName := self getDocumentFilename:(urlString copyFrom:2).
            ]
        ].
        path := fileName pathName.

        fileName exists ifTrue:[
            "/ Transcript showCR:'exists as ', path.
            ^ fileName readStream binary
        ].
    ].

    ('HTMLDocumentView [info]: nonexisting file/document: ', path) infoPrintCR.
    ^ nil

    "Created: / 23.10.1996 / 22:23:39 / cg"
    "Modified: / 16.1.1998 / 11:11:45 / stefan"
    "Modified: / 18.7.1998 / 22:54:14 / cg"
!

submitDoitMethod:method form:info
    |action argValues argNames arguments parser parseTree missingArg|

    action := method copyFrom:(method indexOf:$|) + 1.

    action := '[' , action , ']'.

    argValues := info at:#attributes.
    "
     ok, the action contains a block
     and the attributes contains the arg <-> value associations
     first, parse the block (suing the compiler) to
     get more symbolic info about it ...
    "
"/              Transcript showCR:action.

    parser := Parser for:action in:nil.
    parser nextToken.
    parseTree := parser block.   

"/              Transcript showCR:parseTree.

    (parseTree notNil and:[parseTree ~~ #Error]) ifTrue:[
        parseTree isBlock ifTrue:[
            parseTree arguments isNil ifTrue:[
                arguments := #()
            ] ifFalse:[
                "
                 collect argument names
                "
                argNames := parseTree arguments collect:[:v | v name].

                "
                 construct an array where the values are  ...
                "
                missingArg := false.
                arguments := argNames collect:[:nm | |val|
                                                        val := argValues at:nm asSymbol ifAbsent:nil.
                                                        val isNil ifTrue:[missingArg := true].
                                                        val].

                "
                 any argument empty ?
                "
                missingArg ifTrue:[
                    self warn:'you must fill out all entry fields first'.
                    ^ self
                ].

                arguments := arguments asArray.
            ].

"/                       Transcript showCR:arguments displayString.

            enableExecution ifFalse:[
                self warn:('execution disabled.\If it wasn''t, the code executed would be:\\',
                           parseTree printString) withCRs.
                ^ self
            ].

            "
             now, call the block, catching errors
            "
            AbortOperationRequest handle:[:ex |
                ex return
            ] do:[
                Error handle:[:ex |
                    catchErrors ifFalse:[
                       ex reject
                    ].
                    Dialog warn:('an error occurred while performing the action.\'
                                 , '(' , ex description , ')\\Check the document\\' 
                                 , parseTree printString) withCRs.
                    ex return.
                ] do:[
                   |realBlock|

                   realBlock := Compiler evaluate:action receiver:self notifying:nil.
                   realBlock isBlock ifTrue:[
                       realBlock valueWithArguments:arguments.
                   ] ifFalse:[
                       parseTree valueWithArguments:arguments.
                   ]
                ]
            ].
            ^ self
        ]
    ].
    self warn:('there is some error in the definition of the action\\Check the document\\' 
               , parseTree printString) withCRs.
!

submitForm:info
    |method|

    (SignalSet with:AbortOperationRequest 
               with:Error) handle:[:ex |
        catchErrors ifFalse:[
            ex reject
        ].
        'HTML [info]: error when evaluating the expression' infoPrintCR.
        ex return
    ] do:[
        self topView withExecuteCursorDo:[
            method := ((info at:#method) ? '') withoutSpaces.
            (method isEmpty or:[method asLowercase startsWith:'doit']) ifTrue:[
                self submitDoitMethod:method form:info.
            ] ifFalse:[
                self warn:'I will only execute special Smalltalk DOIT forms'.
            ]
        ]
    ]

    "Created: / 21.5.1996 / 19:03:30 / cg"
    "Modified: / 16.11.2001 / 17:39:06 / cg"
!

title:aString
    "define the title - a callBack when a <TITLE> tag is encountered"

    |lbl iconLabel|

    updateTopViewsTitleFlag ifFalse:[ ^ self].

    lbl := aString withoutSeparators.

    (lbl includes:$-) ifTrue:[
        iconLabel := (lbl copyFrom:(lbl indexOf:$-)+1) withoutSeparators
    ] ifFalse:[
        (lbl includes:$:) ifTrue:[
            iconLabel := (lbl copyFrom:(lbl indexOf:$:)+1) withoutSeparators
        ] ifFalse:[
            iconLabel := 'Documentation'
        ]
    ].

    self topView label:lbl iconLabel:iconLabel

    "Modified: 4.4.1997 / 16:25:54 / cg"
!

visitTest:urlString action:actionString
    |fileName idx|

    actionString notNil ifTrue:[
        visitedActions isNil ifTrue:[^ false].
        ^ visitedActions includes:actionString.
    ].

    visitedUrls isNil ifTrue:[^ false].

"/ ('check visited: ' , urlString) printCR.

"/ Transcript showCR:'check visited: ' , urlString.

    idx := urlString indexOf:$#.
    idx ~~ 0 ifTrue:[
        fileName := urlString copyTo:(idx - 1).
    ] ifFalse:[
        fileName := urlString
    ].
    (fileName startsWith:'/') ifFalse:[
        currentDirectoryName isNil ifTrue:[
            "/ mhmh - a docGen thingy
            ^ false
        ].
        fileName := (currentDirectoryName asFilename construct:fileName) pathName.
    ].
    ^ visitedUrls includes:fileName.

    "Created: 20.5.1996 / 14:09:51 / cg"
    "Modified: 14.2.1997 / 13:10:10 / cg"
! !

!HTMLDocumentFrame methodsFor:'event handling'!

buttonMotion:state x:x y:y
    |a|

    painter isNil ifTrue:[^ self].

    a := painter anchorAt:x@y.
    a notNil ifTrue:[
        a ~~ anchorOfMousePointer ifTrue:[
            anchorOfMousePointer := a.
            self updateAnchorInfoForX:x y:y.
            self showAnchorCursor.
        ].
    ] ifFalse:[
        self showNormalCursor.
        anchorOfMousePointer := nil.
    ].

    "Modified: / 11-08-2010 / 09:42:43 / cg"
    "Modified: / 03-09-2018 / 15:38:41 / Claus Gittinger"
!

buttonPress:button x:x y:y
    |a el|

    painter isNil ifTrue:[^ self].

    lastClickPosition := x@y.

    (button ~~ 1) ifTrue:[
        "/ for menus
        ^ super buttonPress:button x:x y:y
    ].

    masterClickActionPerformer notNil ifTrue:[
        "/ find the corresponding element...
        documentAnchor notNil ifTrue:[
            el := self elementAt:lastClickPosition.
            (masterClickActionPerformer value:lastClickPosition value:el) ifTrue:[^ self].
        ].    
    ].
    
    a := painter anchorAt:lastClickPosition.
    a notNil ifTrue:[
        anchorActionPerformer notNil ifTrue:[
            (anchorActionPerformer value:a optionalArgument:self) ifTrue:[
                ^ self 
            ].
        ].

        a isExample ifTrue:[
            self exampleElementSelected:a.
        ] ifFalse:[
            |clickAction|
            
            clickAction := a parameterFor:#'ONCLICK'.
            clickAction notNil ifTrue:[
                painter buttonWidgetPressed:a.
            ] ifFalse:[
                painter flushAnchorColors.

                self anchorElementSelected:a.
                "/
                "/ there could now be another anchor under the
                "/ mouse cursor ...
                "/
                self updateAnchorInfoForX:x y:y
            ]
        ]
    ].    

    "Created: / 17.5.1996 / 17:37:53 / cg"
    "Modified: / 27.7.1998 / 10:34:57 / cg"
!

keyPress:key x:x y:y
    <resource: #keyboard (#PreviousPage #NextPage #HalfPageUp #HalfPageDown
                          #BeginOfText #EndOfText
                          #CursorUp #CursorDown
                          #ScrollUp #ScrollDown )>

    |n|

"/ (key == #InspectIt) ifTrue:[self inspect].

    (key == #PreviousPage) ifTrue: [^ self pageUp].
    (key == #NextPage)     ifTrue: [^ self pageDown].
    (key == #HalfPageUp)   ifTrue: [^ self halfPageUp].
    (key == #HalfPageDown) ifTrue: [^ self halfPageDown].

    (key == #BeginOfText) ifTrue:[^ self scrollToTop].
    (key == #EndOfText) ifTrue:[^ self scrollToBottom].

    (key == #CursorDown) ifTrue:[^ self scrollDown].
    (key == #CursorUp) ifTrue:[^ self scrollUp].

    (key == #ScrollUp) ifTrue:[
        n := 1 + (self sensor compressKeyPressEventsWithKey:#ScrollUp).
        ^ self scrollUp:(n * self verticalScrollStep)
    ].
    (key == #ScrollDown) ifTrue:[
        n := 1 + (self sensor compressKeyPressEventsWithKey:#ScrollDown).
        ^ self scrollDown:(n * self verticalScrollStep)
    ].

    super keyPress:key x:x y:y

    "Created: 13.9.1996 / 14:05:49 / cg"
    "Modified: 9.1.1997 / 12:19:46 / cg"
!

mouseWheelZoom:amount
    "CTRL-wheel action"

    self changeScaleForMouseWheelZoom:amount
!

redraw
    self clear. 
    gc paint:self blackColor.
    documentAnchor notNil ifTrue:[
        self redrawX:0 y:0 width:width height:height
    ]

    "Created: 17.5.1996 / 17:35:07 / cg"
    "Modified: 9.10.1996 / 18:17:52 / cg"
!

redrawX:x y:y width:w height:h

    documentAnchor notNil ifTrue:[
        self clearRectangleX:x y:y width:w height:h.
        painter isNil ifTrue:[^ self].
        documentLoadInProgress ifTrue:[^ self].
        
        accessLock critical:[
            painter displayX:x y:y width:w height:h on:self
        ].
    ]

    "Created: / 17-05-1996 / 16:02:37 / cg"
    "Modified: / 25-10-2010 / 13:24:34 / cg"
!

showAnchorCursor
    "to be redefined"

    self cursor:anchorCursor

    "Created: / 02-09-2018 / 12:17:06 / Claus Gittinger"
!

showNormalCursor
    "to be redefined"

    self cursor:normalCursor

    "Created: / 02-09-2018 / 12:17:10 / Claus Gittinger"
!

sizeChanged:how
    painter notNil ifTrue:[
        realized ifFalse:[
            "/ first resize
            documentLoadInProgress := true.
            [
                painter format:documentAnchor for:self resolver:self style:style.
            ] ensure:[
                documentLoadInProgress := false
            ]
        ] ifTrue:[
            painter reformatDocument.
            self invalidate.
        ].
        localAnchor notNil ifTrue:[
            self positionOnAnchor:localAnchor.
            localAnchor := nil.
        ]
    ].
    super sizeChanged:how.

    "Created: / 20-05-1996 / 12:47:32 / cg"
    "Modified: / 20-07-1998 / 16:04:22 / cg"
    "Modified: / 19-06-2018 / 17:11:44 / Claus Gittinger"
! !

!HTMLDocumentFrame methodsFor:'help'!

helpTextAt:aPoint
    |a title info|

    painter notNil ifTrue:[
        accessLock critical:[
            a := painter anchorAt:aPoint.
        ].
        a notNil ifTrue:[
            title := a parameterFor:#TITLE.
            title notNil ifTrue:[^ title].    

            info := a parameterFor:#INFO.
            info notNil ifTrue:[^ info].    
        ]
    ].
    ^ nil "/ super helpTextAt:aPoint

    "Modified: / 16-11-2016 / 21:29:43 / cg"
! !

!HTMLDocumentFrame methodsFor:'initialization & release'!

destroy
    painter notNil ifTrue:[painter release].

    documentAnchor := painter := homeText := localImages := currentDocument := nil.

    super destroy.

    "Modified: / 15.2.1996 / 12:45:54 / stefan"
    "Created: / 20.5.1996 / 20:35:31 / cg"
    "Modified: / 27.10.1997 / 21:28:24 / cg"
!

fetchDeviceResources
    "fetch device specific resources."

    style fetchDeviceColorsFor:device.
!

initFonts:aPageStyle
    |fontSize fontStyles fontStyle encoding fontType normalFamily codeFamily|

    fontStyles := aPageStyle fontStyles.
    fontStyles isNil ifTrue:[
        fontStyles := IdentityDictionary new.
        aPageStyle fontStyles:fontStyles.
    ].

    "/ encoding := #'iso8859-1'.
    encoding := #'iso10646-1'.
    fontStyle := fontStyles at:encoding ifAbsentPut:[HTMLFontStyle new].

    fontSize := fontStyle fontSize ? (aPageStyle fontSize).

    device supportsXftFonts ifTrue:[
        fontType := XftFontDescription.
        normalFamily := 'Arial'.
        codeFamily := 'Courier'.
    ] ifFalse:[
        fontType := Font.
        normalFamily := 'times'.
        codeFamily := 'courier'.
    ].

    fontStyle normalFont:       (fontType family:normalFamily face:'light' style:'roman' size:fontSize encoding:encoding).
    fontStyle boldNormalFont:   (fontType family:normalFamily face:'bold'   style:'roman' size:fontSize encoding:encoding).
    fontStyle italicNormalFont: (fontType family:normalFamily face:'medium' style:'italic' size:fontSize encoding:encoding).
    fontStyle boldItalicNormalFont:(fontType family:normalFamily face:'bold' style:'italic' size:fontSize encoding:encoding).

    fontStyle codeFont:         (fontType family:codeFamily face:'medium' style:'roman' size:fontSize encoding:encoding).
    fontStyle boldCodeFont:     (fontType family:codeFamily face:'bold'   style:'roman' size:fontSize encoding:encoding).
    fontStyle italicCodeFont:   (fontType family:codeFamily face:'medium' style:'oblique' size:fontSize encoding:encoding).
    fontStyle boldItalicCodeFont:(fontType family:codeFamily face:'bold'  style:'oblique' size:fontSize encoding:encoding).

    fontStyle normalSmallFont:  (fontType family:normalFamily face:'medium' style:'roman' size:fontSize*0.8 encoding:encoding).

    fontStyle h1Font:   (fontType family:normalFamily face:'bold' style:'roman' size:(fontSize * 1.8) rounded encoding:encoding).
    fontStyle h2Font:   (fontType family:normalFamily face:'bold' style:'roman' size:(fontSize * 1.4) rounded encoding:encoding).
    fontStyle h3Font:   (fontType family:normalFamily face:'bold' style:'roman' size:(fontSize * 1.2) rounded encoding:encoding).
    fontStyle h4Font:   (fontType family:normalFamily face:'bold' style:'roman' size:(fontSize) encoding:encoding).
    fontStyle h5Font:   (fontType family:normalFamily face:'bold' style:'roman' size:(fontSize * 0.8) rounded encoding:encoding).
    fontStyle h6Font:   (fontType family:normalFamily face:'bold' style:'roman' size:(fontSize * 0.8) rounded encoding:encoding).

    fontStyle symbolFont:(fontType family:'symbol' face:'medium' style:'roman' size:fontSize encoding:encoding).

    "Created: / 05-09-1996 / 21:15:00 / cg"
    "Modified: / 10-08-2010 / 15:55:03 / cg"
!

initLazyFontStyle:aFontStyle size:fontSize encoding:encoding
    |available firstFont idx|

    available := device 
                    fontsInFamily:'*' 
                    filtering:[:f | |fontsEncoding|
                        fontsEncoding := f encoding.
                        fontsEncoding notNil and:[encoding match:fontsEncoding]
                    ].

    available notEmpty ifTrue:[
        available := available asOrderedCollection.
        idx := available findFirst:[:fd | fd size == fontSize].
        idx ~~ 0 ifTrue:[
            firstFont := available at:idx
        ] ifFalse:[
            "/ take the first - for now.
            firstFont := available first.
        ].
        aFontStyle fontSize:firstFont size.

        aFontStyle normalFont:firstFont.
        aFontStyle boldNormalFont:firstFont.
        aFontStyle italicNormalFont:firstFont.
        aFontStyle boldItalicNormalFont:firstFont.

        aFontStyle codeFont:firstFont.
        aFontStyle boldCodeFont:firstFont.
        aFontStyle italicCodeFont:firstFont.
        aFontStyle boldItalicCodeFont:firstFont.

        aFontStyle normalSmallFont:firstFont.

        aFontStyle h1Font:firstFont.
        aFontStyle h2Font:firstFont.
        aFontStyle h3Font:firstFont.
        aFontStyle h4Font:firstFont.
        aFontStyle h5Font:firstFont.
        aFontStyle h6Font:firstFont.

        aFontStyle symbolFont:(Font family:'symbol' face:'medium' style:'roman' size:fontSize encoding:firstFont encoding).
    ].
!

initStyle
    "setup style specifics."

    <resource: #style (#'html.activeAnchorForegroundColor'
                       #'html.activeAnchorBackgroundColor'
                       #'html.anchorForegroundColor'
                       #'html.anchorUnderline'
                       #'html.exampleAnchorForegroundColor'
                       #'html.foregroundColor'
                       #'html.backgroundColor'
                       #'html.visitedAnchorForegroundColor'
                       #'html.fontSize'
                       #'html.printFontSize')>

    super initStyle.

    style := HTMLPageStyle new.
    style extraListItemSpacing:2.
    style activeAnchorFGColor:  (styleSheet colorAt:'html.activeAnchorForegroundColor'  default:Color red).
    style activeAnchorBGColor:  (styleSheet colorAt:'html.activeAnchorBackgroundColor'  default:viewBackground).
    style anchorFGColor:        (styleSheet colorAt:'html.anchorForegroundColor'        default:Color blue).
    style anchorUnderline:      (styleSheet at:'html.anchorUnderline'                   default:false).
    style exampleFGColor:       (styleSheet colorAt:'html.exampleAnchorForegroundColor' default:(Color red:40 green:0 blue:0)).
    style textFGColor:          (styleSheet colorAt:'html.foregroundColor'              default:Color black).
    style codeFGColor:          (styleSheet colorAt:'html.codeForegroundColor'          default:style textFGColor).
    style viewBGColor:          (styleSheet colorAt:'html.backgroundColor'              default:self defaultViewBackgroundColor).
    style visitedAnchorFGColor: (styleSheet colorAt:'html.visitedAnchorForegroundColor' default:(Color red:15 green:2 blue:36)).
    style fontSize:             (styleSheet at:'html.fontSize' default:(TextView defaultFont size)).
    style headerNumbers:        false.

    self initFonts:style.

    printStyle := HTMLPageStyle new.
    printStyle extraListItemSpacing:2.
    printStyle activeAnchorFGColor:     (style anchorFGColor).
    printStyle activeAnchorBGColor:     (Color white).
    printStyle anchorFGColor:           (style anchorFGColor).
    printStyle anchorUnderline:         false.
    printStyle exampleFGColor:          (style exampleFGColor).
    printStyle textFGColor:             (style textFGColor).
    printStyle codeFGColor:             (style codeFGColor).
    printStyle viewBGColor:             Color white.
    printStyle visitedAnchorFGColor:    (style anchorFGColor).
    printStyle fontSize:                (styleSheet at:#'html.printFontSize' default:12).
    printStyle headerNumbers:           true.
    printStyle printTOC:                true.
    printStyle initialHeaderNumbers:    #(1 1 1 1 1 1).

    style initialHeaderNumbers:#(1 1 1 1 1 1).

    (Printer notNil and:[Printer supportsColor]) ifFalse:[
        printStyle activeAnchorFGColor:(Color black).
        printStyle activeAnchorBGColor:(Color white).
        printStyle anchorFGColor:(Color black).
        printStyle exampleFGColor:(Color black).
        printStyle textFGColor:(Color black).
        printStyle codeFGColor:(Color black).
        printStyle visitedAnchorFGColor:(Color black).
    ].

    self initFonts:printStyle.

    "Modified: / 18.5.1998 / 12:38:49 / cg"
!

initialize
    |bg|

    super initialize.

    accessLock := RecursionLock new.

    self documentEncoding:#'iso10646-1'.

    formatContext  := self.
    documentLoadInProgress := false.
    printing := false.
    updateTopViewsTitleFlag := false.
    enableActionLinks := enableExternalLinks := true.
    catchErrors := DebugErrors not.

    (bg := viewBackground exactOn:device) isNil ifTrue:[
        "/ no - never use dithered colors for the background
        'HTML [info]: try nearby exact background color' infoPrintCR.
        bg := viewBackground nearestOn:device
    ].
    bg isDithered ifTrue:[
        'HTML [info]: cannot get undithered background color' infoPrintCR.
    ].

    showImages := true.
    topDirectoryName := currentDirectoryName := '.'.

    self paint:self blackColor.

    enableExecution := true.
    selfInDoitExpressions := self.
    enableInternalApplets := self class defaultInternalAppletsEnabled.
    enableAlienApplets := self class defaultAlienAppletsEnabled.
    enableJavaApplets := self class defaultJavaAppletsEnabled.
    enableScriptExecution := self class defaultScriptExecutionEnabled.
    self menuMessage:#editMenu.

    normalCursor := Cursor normal.
    anchorCursor := Cursor hand.

    "Created: / 17-05-1996 / 17:01:55 / cg"
    "Modified: / 25-10-2010 / 13:24:14 / cg"
    "Modified: / 05-03-2018 / 16:11:08 / stefan"
    "Modified: / 02-09-2018 / 12:15:12 / Claus Gittinger"
!

recreate
    "sent after a snapin or a migration, reinit for new device"

    super recreate.
    painter notNil ifTrue:[
        painter getFontsFor:self
    ]

    "Created: 15.6.1996 / 17:01:52 / cg"
!

reinitStyle
    "handle dynamic style changes"

    |oldBg|

    "/ must remember my viewBackground - it
    "/ could be an image originalted from the
    "/ document.

    oldBg := viewBackground.
    super reinitStyle.
    self viewBackground:oldBg

    "Modified: / 11.9.1998 / 13:22:18 / cg"
! !

!HTMLDocumentFrame methodsFor:'internal pseudo documents'!

documentStreamForErrorResponse:reply forURL:urlString location:location onHost:aHost
    "return an array filled with:
        stream
        newDocument name        
        newDocument directory
        documentHost
     mhmh - this is not very object-oriented ...
    "

    |s|

    reply responseCode == #unknownHost ifTrue:[
        s := self pseudoDocumentStreamOnString:'The requested URL ' , urlString , ' refers to an unknown host.'
                                      headLine:'Unknown host: ' , aHost 
                                         title:'Unknown host'.
        ^ Array with:s with:location with:nil with:nil
    ].

    reply responseCode == #unreachableHost ifTrue:[
        s := self pseudoDocumentStreamOnString:'The requested URL ' , urlString , ' refers to an unreachable host.'
                                      headLine:'Unreachable host: ' , aHost 
                                         title:'Unreachable host'.
        ^ Array with:s with:location with:nil with:nil
    ].

    reply responseCode == #noResponse ifTrue:[
        s := self pseudoDocumentStreamOnString:'The requested URL ' , urlString , ' refers to a host which seems to not respond to HTTP requests.'
                                      headLine:'No HTTP response from: ' , aHost 
                                         title:'No HTTP response'.
        ^ Array with:s with:location with:nil with:nil
    ].

"/            reply responseCode == #writeError ifTrue:[
"/                s := self pseudoDocumentStreamOnString:'Got an error while transmitting HTTP-GET request for ' , urlString , '.'
"/                                              headLine:'Write error' 
"/                                                 title:'Write error'.
"/                ^ Array with:s with:location with:nil with:nil
"/            ].

    s := self pseudoDocumentStreamOnString:'The requested URL ' , urlString , ' refers to an unloadable document.'
                                  headLine:'HTTP error' 
                                     title:'HTTP error'.
    ^ Array with:s with:location with:nil with:nil
!

documentStreamForURL:urlOrString file:urlFileName onHost:aHost
    "return an array filled with:
        stream
        newDocument name        
        newDocument directory
        documentHost
     mhmh - this is not very object-oriented ...
    "

    |s txt reply fileName path suffix urlString
     location url method host port ftp data mime newURL|

    host := aHost.

    host isNil ifTrue:[
        fileName := self getDocumentFilename:urlFileName.
        path := fileName pathName.
    ] ifFalse:[
        (urlFileName asFilename isAbsolute) ifTrue:[
            path := urlFileName.
            fileName := urlFileName asFilename.
        ] ifFalse:[
            fileName := urlFileName asFilename.
            host = currentURLHost ifTrue:[
                currentDirectoryName ~= '/' ifTrue:[
                    path := currentDirectoryName , '/' , urlFileName
                ] ifFalse:[
                    path := '/' , urlFileName
                ]
            ] ifFalse:[
                path := urlFileName
            ]
        ].
        location := 'http:' , '//' , host , path.
    ].

    urlOrString isString ifTrue:[
        url := URL fromString:urlOrString.
        urlString := urlOrString.
    ] ifFalse:[
        url := urlOrString.
        urlString := url urlPrintString.
    ].

    host := url host.
    method := (url method) ? 'file'.
    port := url port.

    host isNil ifTrue:[
        fileName isDirectory ifTrue:[
            s := self pseudoDocumentStreamForDirectory:path.
            ^ Array with:s with:path with:urlFileName with:nil
        ]
    ].

    suffix := fileName suffix.
    mime := self mimeTypeFromSuffix:suffix.

    "/
    "/ an html page ?
    "/
    mime = 'text/html' ifTrue:[
        host isNil ifTrue:[
            "/
            "/ local file
            "/
            s := fileName readStreamOrNil.
            s isNil ifTrue:[
                s := self pseudoDocumentStreamForUnreadableFile:path.
                ^ Array with:s with:path with:urlFileName with:nil
            ].
            ^ Array with:s with:path with:s pathName asFilename directoryName with:nil
        ].

        method = 'ftp' ifTrue:[
            ftp := FTPClient new.
            FTPClient ftpErrorSignal catch:[
                FTPClient connectFailedSignal handle:[:ex |
                    s := self pseudoDocumentStreamOnString:'The requested URL ' , urlString , ' refers to an unreachable host.'
                                                  headLine:'Unreachable host: ' , host 
                                                     title:'Unreachable host'.
                    ^ Array with:s with:location with:nil with:nil
                ] do:[
                    ftp connectTo:host.
                    ftp ascii.
                    data := ftp get:path.
                    ftp close.
                ].
            ].

            data isNil ifTrue:[
                s := self pseudoDocumentStreamForUnreadableFile:urlString.
                ^ Array with:s with:location with:nil with:nil
            ].

            ^ Array with:(ReadStream on:data asString) with:urlString with:nil with:nil
        ].
        HTTPInterface isNil ifTrue:[
            Smalltalk loadPackage:'stx:goodies/communication'
        ].    
        reply := HTTPInterface get:path fromHost:host port:port fromDocument:currentDocument.

        reply isNil ifTrue:[
            s := self pseudoDocumentStreamForUnreadableFile:path.
            ^ Array with:s with:location with:nil with:nil
        ].
        reply isErrorResponse ifTrue:[
            ^ self documentStreamForErrorResponse:reply forURL:urlString location:location onHost:host.
        ].

        txt := reply data.
"/        info := reply rawHeader.

        s := ReadStream on:(txt asString).
        ^ Array with:s with:location with:(path asFilename directoryName) with:host
    ].

    host notNil ifTrue:[
        method = 'ftp' ifTrue:[
            ftp := FTPClient new.
            FTPClient ftpErrorSignal catch:[
                FTPClient connectFailedSignal handle:[:ex |
                    s := self pseudoDocumentStreamOnString:'The requested URL ' , urlString , ' refers to an unreachable host.'
                                                  headLine:'Unreachable host: ' , host 
                                                     title:'Unreachable host'.
                    ^ Array with:s with:location with:nil with:nil
                ] do:[
                    ftp connectTo:host.
                    ftp ascii.
                    data := ftp get:path.
                    ftp close.
                ]
            ].

            data isNil ifTrue:[
                s := self pseudoDocumentStreamForUnreadableFile:urlString.
                ^ Array with:s with:location with:nil with:nil
            ].

            ^ Array with:(ReadStream on:data asString) with:urlString with:nil with:nil
        ].
        HTTPInterface isNil ifTrue:[
            s := self pseudoDocumentStreamForUnreadableFile:urlString message:'HTTPInterface missing - no internet access possible.'.
            ^ Array with:s with:location with:nil with:nil
        ].

        "/
        "/ lets see what we get ...
        "/
        reply := HTTPInterface get:path fromHost:host port:port fromDocument:currentDocument.
        reply isNil ifTrue:[
            s := self pseudoDocumentStreamForUnreadableFile:path.
            ^ Array with:s with:location with:nil with:nil
        ].
        reply isErrorResponse ifTrue:[
            ^ self documentStreamForErrorResponse:reply forURL:urlString location:location onHost:host.
        ].

        reply isMovedResponse ifTrue:[
            "/ document moved - auto forward ...
            newURL := reply location.
            newURL isNil ifTrue:[^ nil].
            ^ self documentStreamForURL:newURL file:'' onHost:''.
        ].

"/        info := reply rawHeader.
        txt := reply data.

        s := ReadStream on:(txt asString).
        ^ Array with:s with:location with:(path asFilename directoryName) with:host
    ].

    "/
    "/ an image ?
    "/
    (mime notNil and:[mime startsWith:'image/']) ifTrue:[
        s := self pseudoDocumentStreamForImageFile:path.
        s isNil ifTrue:[
            s := self pseudoDocumentStreamForUnreadableFile:path.
        ].
        ^ Array with:s with:path with:urlFileName with:nil
    ].

    "/
    "/ a postscript file ?
    "/
    mime = 'application/postscript' ifTrue:[
        s := self pseudoDocumentStreamForPostscriptFile:path.
        ^ Array with:s with:nil with:nil with:nil
    ].

    "/
    "/ a man page ?
    "/
    (self isManPageSuffix:suffix) ifTrue:[
        s := self pseudoDocumentStreamForManPageFile:path.
        ^ Array with:s with:path with:urlFileName with:nil
    ].



    "/
    "/ a pdf file ?
    "/
    mime = 'application/pdf' ifTrue:[
        s := self pseudoDocumentStreamForPDFFile:path.
        ^ Array with:s with:nil with:nil with:nil
    ].

    "/
    "/ anything else
    "/
    s := self pseudoDocumentStreamForPlainFile:path.
    ^ Array with:s with:path with:urlFileName with:nil

    "Modified: / 16-01-1998 / 11:12:29 / stefan"
    "Modified: / 11-10-2006 / 14:58:24 / cg"
!

pseudoDocumentStreamForDirectory:url
    "a directory in an HREF - create pseudo document"

    |s urlDir entry|

    urlDir := url asFilename.
    urlDir isReadable ifFalse:[
        ^ self pseudoDocumentStreamForUnreadableFile:url
    ].

    s := WriteStream on:''.

    s nextPutAll:'<head><title>Directory listing of ' ; nextPutAll:url; nextPutLine:'</title></head><body>'.
    s nextPutAll:'<h1>Directory listing of '; nextPutAll:url; nextPutLine:'</h1>'.
    s nextPutLine:'<pre>'.

    (urlDir pathName ~= '/') ifTrue:[
        s nextPutAll:'<a HREF="'.
        s nextPutAll:url asFilename directoryName asString.
        s nextPutLine:'">Up to higher level directory</A><BR>'.
    ].

    urlDir directoryContents do:[:fileName |
        |f nm suffix info size n unitString sizeString fn
         modificationTime fileExtensionTable|

        (fileName ~= '.'
        and:[fileName ~= '..'
        and:[(fileName startsWith:'.') not]]) ifTrue:[
            f := urlDir construct:fileName.

            s nextPutAll:'<a HREF="'.
            s nextPutAll:f pathName.
            s nextPutAll:'"><IMG border=0 SRC="'.
            f isDirectory ifTrue:[
                nm := 'internal-gopher-menu'.
            ] ifFalse:[
                suffix := f suffix asLowercase.
                (fileExtensionTable := self class fileExtensionTable) notNil ifTrue:[
                    entry := fileExtensionTable at:suffix ifAbsent:nil.
                    entry notNil ifTrue:[
                        nm := entry first
                    ]
                ].
                nm isNil ifTrue:[
                    nm := 'internal-gopher-unknown'
                ].
            ].

            fn := fileName contractTo:32.

            s nextPutAll:nm; nextPutAll:'"> '; nextPutAll:fn.
            s nextPutAll:(String new:32 - fn size); nextPutAll:'</A>'.

            info := f info.
            info notNil ifTrue:[
                size := (info size).
                unitString := ' bytes'.
                size < (500 * 1024) ifTrue:[
                    size < 1024 ifTrue:[
                        n := size
                    ] ifFalse:[
                        n := (size * 10 // 1024 / 10.0).
                        unitString := ' Kb   '
                    ]
                ] ifFalse:[
                    n := (size * 10 // 1024 // 1024 / 10.0).
                    unitString := ' Mb   '
                ].

                modificationTime := info modificationTime.
                sizeString :=  (n printStringLeftPaddedTo:5) , unitString.
                s nextPutAll:sizeString; space.
                s nextPutAll:((modificationTime asDate displayString) paddedTo:12).
                s space.
                s nextPutAll:modificationTime asTime displayString.
            ].

            s cr
        ]
    ].
    s nextPutAll:'</pre></body>'.

    ^ ReadStream on:s contents

    "Created: 8.7.1996 / 19:00:00 / cg"
    "Modified: 22.4.1997 / 19:27:53 / cg"
!

pseudoDocumentStreamForImageFile:url
    "an image in an HREF - create pseudo document"

    |s|

    s := WriteStream on:''.

    s nextPutAll:'<head><title>'; nextPutAll:url; nextPutLine:'</title></head><body>'.
    s nextPutLine:'<pre><IMG SRC="' , url , '" border=0>'.
    s nextPutAll:'</pre></body>'.

    ^ ReadStream on:s contents

    "Created: 8.7.1996 / 20:28:26 / cg"
    "Modified: 22.4.1997 / 11:22:56 / cg"
!

pseudoDocumentStreamForManPageFile:url
    "a manPage in an HREF - create pseudo document"

    |s text|

    s := WriteStream on:''.

    s nextPutAll:'<head><title>Man output of '; nextPutAll:url; nextPutLine:'</title></head><body>'.

    text := (HTMLDocGenerator manPageFor:url
                              manCommand:'nroff -man ' , url).

    s nextPutAll:text.
    s nextPutAll:'</body>'.

    ^ ReadStream on:s contents

    "Created: 9.9.1996 / 17:46:41 / cg"
    "Modified: 10.4.1997 / 10:37:45 / cg"
!

pseudoDocumentStreamForPDFFile:url
    "a PDF file in an HREF - create error document, if acroread cannot be opened"

    |cmd infoMessage|

    OperatingSystem isMSWINDOWSlike ifTrue:[
        OsError handle:[:ex |
        ] do:[
            OperatingSystem openApplicationForDocument:url operation:#open.
            ^ nil
        ]
    ].

    cmd := MIMETypes defaultCommandTemplateToOpenMimeType:'application/pdf'.
    cmd notNil ifTrue:[
        cmd := cmd bindWith:url.
        (OperatingSystem executeCommand:cmd) ifTrue:[
            ^ nil
        ].
    ].

    cmd isNil ifTrue:[
        infoMessage := 'No command was defined/associated for PDF documents.'
    ] ifFalse:[
        infoMessage := 'Cannot execute reader command (as PDF viewer)<P><CODE>',cmd,'</CODE>'.
    ].
    ^ self 
        pseudoDocumentStreamOnHTML:infoMessage
        headLine:'Cannot execute' 
        title:'Error'.

    "Modified: / 12-05-2004 / 12:55:23 / cg"
!

pseudoDocumentStreamForPlainFile:url
    "a plainFile in an HREF - create pseudo document"

    |s nm text|

    nm := url asFilename.
    nm isReadable ifFalse:[
        ^ self pseudoDocumentStreamForUnreadableFile:url
    ].

    s := WriteStream on:''.

    s nextPutAll:'<head><title>'; nextPutAll:url; nextPutLine:'</title></head><body>'.

    s nextPutAll:'<pre>'; cr.
    nm := url asFilename.
    text := nm contentsOfEntireFile.
    text := text replChar:$< withString:'&lt;'.
    text := text replChar:$> withString:'&gt;'.

    s nextPutAll:text.
    s nextPutAll:'</pre></body>'.

    ^ ReadStream on:s contents

    "Created: 8.7.1996 / 19:42:07 / cg"
    "Modified: 10.4.1997 / 10:33:20 / cg"
!

pseudoDocumentStreamForPostscriptFile:url
    "a postscript file in an HREF - create error document, if ghostview cannot be opened"

    (OperatingSystem executeCommand:'ghostview ' , url) ifFalse:[
        (OperatingSystem executeCommand:'gv ' , url) ifFalse:[
            ^ self pseudoDocumentStreamOnString:'Cannot execute ghostview/gv (as postscript viewer)'
                                          headLine:'Cannot execute' 
                                             title:'Error'.
        ].
    ].
    ^ nil

    "Created: 13.9.1996 / 13:37:30 / cg"
    "Modified: 13.9.1996 / 15:35:10 / cg"
!

pseudoDocumentStreamForUnreadableFile:urlString
    "an unreadable file in an HREF - create pseudo document"

    ^ self pseudoDocumentStreamForUnreadableFile:urlString message:nil

    "Modified: / 11-10-2006 / 14:57:19 / cg"
!

pseudoDocumentStreamForUnreadableFile:urlString message:msg
    "an unreadable file in an HREF - create pseudo document"

    |s m t|

    m := ((URL fromString:urlString) method) ? 'file'.
    (m isNil or:[m = 'file']) ifTrue:[
        t := 'Local file is unreadable'.
        urlString asFilename exists ifTrue:[
            s := 'File not readable: ' , urlString
        ] ifFalse:[
            s := 'No file: ' , urlString
        ].
    ] ifFalse:[
        s := 'No file: ' , urlString.
        t := 'File is unreadable'.
    ].
    ^ self pseudoDocumentStreamOnString:(msg ? s) headLine:t title:urlString

    "Created: / 11-10-2006 / 14:57:04 / cg"
!

pseudoDocumentStreamOnHTML:aString headLine:headLine title:title
    "create pseudo document showing a string"

    |s text|

    s := WriteStream on:''.

    s nextPutAll:'<head><title>'; nextPutAll:title; nextPutLine:'</title></head><body>'.
    headLine notNil ifTrue:[
        s nextPutLine:'<h1>' , headLine , '</h1>'.
    ].

    text := aString copy.

    s nextPutAll:text.
    s nextPutAll:'</body>'.

    ^ ReadStream on:s contents

    "Created: 13.9.1996 / 15:32:26 / cg"
    "Modified: 10.4.1997 / 10:38:06 / cg"
!

pseudoDocumentStreamOnString:aString headLine:headLine title:title
    "create pseudo document showing a string"

    |textWithEscapes|

    textWithEscapes := aString copy.
    textWithEscapes := textWithEscapes replChar:$< withString:'&lt;'.
    textWithEscapes := textWithEscapes replChar:$> withString:'&gt;'.
    ^ self pseudoDocumentStreamOnHTML:textWithEscapes headLine:headLine title:title

    "Created: 13.9.1996 / 15:32:26 / cg"
    "Modified: 10.4.1997 / 10:38:06 / cg"
!

pseudoDocumentStreamOnString:aString title:title
    "create pseudo document showing a string"

    |s text|

    s := WriteStream on:''.

    s nextPutAll:'<title>'; nextPutAll:title; nextPutLine:'</title><body>'.
    s nextPutLine:'<pre>'.

    text := aString copy.
    text := text replChar:$< withString:'&lt;'.
    text := text replChar:$> withString:'&gt;'.

    s nextPutAll:text.
    s nextPutAll:'</pre></body>'.

    ^ ReadStream on:s contents

    "Created: 13.9.1996 / 13:43:08 / cg"
    "Modified: 10.4.1997 / 10:38:14 / cg"
! !

!HTMLDocumentFrame methodsFor:'menu & actions'!

clickedExampleTextOrNil
    |a actionText anchorText action text|

    a := painter anchorAt:lastClickPosition.
    a isNil ifTrue:[ ^ nil].

    anchorText := a anchorText.
    actionText := a actionString.

    action := actionText ? anchorText.

    "/ forget any emphasis
    text := action withoutSeparators asStringCollection.

    "/ remove any empty lines at the beginning and the end
    ^ text withoutLeadingAndTrailingBlankLines
"/    [text notEmpty and:[ text first isEmptyOrNil]] whileTrue:[
"/        text removeFirst
"/    ].
"/    [text notEmpty and:[text last isEmptyOrNil]] whileTrue:[
"/        text removeLast
"/    ].
"/    ^ text.

    "Created: / 06-11-1996 / 13:22:05 / cg"
    "Modified: / 16-11-2016 / 21:29:24 / cg"
!

copyExampleText
    |text|

    text := self clickedExampleTextOrNil.
    text notNil ifTrue:[
        self setClipboardText:text.
    ].
!

copyLink
    |a urlString|

    a := painter anchorAt:lastClickPosition.
    a notNil ifTrue:[
        urlString := a hrefString.
        urlString notEmptyOrNil ifTrue:[
            self setClipboardText:urlString.
        ]
    ].
    ^ nil

    "Created: / 06-11-1996 / 13:22:05 / cg"
    "Modified: / 16-11-2016 / 17:15:02 / cg"
!

editImage
    |imgElement|

    imgElement := painter imageAt:lastClickPosition.
    imgElement notNil ifTrue:[
        imgElement image edit
    ].
    ^ nil

    "Modified: / 6.11.1996 / 13:45:19 / cg"
    "Created: / 7.9.1998 / 19:38:56 / cg"
!

editMenu
    "return an appropriate popUpMenu.
     check if pointer is over:
        an example - offer copy-example
        an image   - offer inspect-image
        a href     - offer open-new-browser
    "

    <resource: #programMenu>

    |a img imgFileName itemList imgItems m|

    painter isNil ifTrue:[^ self].
    lastClickPosition isNil ifTrue:[^ self].       

    itemList := #(
                   ('Back'                backToPreviousDocument)
                 ).

    a := painter anchorAt:lastClickPosition.
    a notNil ifTrue:[
        itemList := (itemList , #(
                       ('-'                                     )
                       ('Copy Link'                             copyLink)
                       ('-'                                     )
                       ('Copy Example''s Text'                    copyExampleText)
                       ('Open a Workspace on Example''s Text'     workspaceOnExampleText)
                       ('Open a Terminal on Example''s Text'      terminalOnExampleText)
                       ('-'                                     )
                       ('DoIt (execute)'                   executeExampleText)
                       ('InspectIt (execute && inspect result)'   executeAndInspectExampleText)
                      )).
    ].

    img := painter imageAt:lastClickPosition.
    img notNil ifTrue:[
        img image notNil ifTrue:[
            imgFileName := img image fileName.
            imgFileName isNil ifTrue:[
                imgFileName := img urlString 
            ].
            imgFileName notNil ifTrue:[
                imgFileName := imgFileName asFilename baseName.
                imgItems := #(
                                ('-'                                    )
                                ('Inspect Image (%1)'  inspectImage     )
                                ('Edit Image (%1)'     editImage        )
                                ('Save Image (%1)...'  saveImage        )
                                ('Show Image in FileBrowser' showImageInFileBrowser)
                              ).

                imgItems := imgItems 
                                collect:[:each | 
                                    |eachCopy lbl xLatedLbl|
                                    
                                    eachCopy := each copy.
                                    lbl := (eachCopy at:1).
                                    xLatedLbl := resources string:lbl with:imgFileName.
                                    eachCopy at:1 put:xLatedLbl.
                                    eachCopy
                                ]. 
                itemList := itemList , imgItems
            ]
        ].
    ].

    itemList := itemList , #(
                        ('-'                   )
                        ('Edit Document in File Browser' editThisDocument)
                    ).
    m := PopUpMenu
        itemList:itemList
        resources:resources.

    (currentURL isNil or:[currentURL asFilename exists not]) ifTrue:[
        m disableAll:#(editThisDocument).
    ].

    imgFileName notNil ifTrue:[
        (img image fileName notNil and:[img image fileName asFilename exists]) ifFalse:[
            m disable:#showImageInFileBrowser
        ]
    ].

    (hRefHistory isEmptyOrNil) ifTrue:[
        m disable:#backToPreviousDocument
    ].

    (a notNil) ifTrue:[
        a isCommandExample ifFalse:[
            m disableAll:#(terminalOnExampleText).
        ].    
        
        (a isExample) ifFalse:[
            m disableAll:#(executeExampleText executeAndInspectExampleText).
            a isCopyableExample ifFalse:[
                a isCommandExample ifFalse:[  
                    m disableAll:#(copyExampleText).
                ]
            ]
        ].
        (a isExample 
            or:[ a isCopyableExample 
            or:[ a isCommandExample 
            or:[ a hrefString isEmptyOrNil ]]]
        ) ifTrue:[
            m disable:#copyLink.
        ].
    ].
    ^ m

    "Modified: / 16-11-2016 / 17:15:12 / cg"
!

editThisDocument
    currentURL asFilename exists ifTrue:[
        FileBrowser default openOn:(currentURL asFilename)
    ].

    "Modified: / 01-09-2017 / 14:05:11 / cg"
!

executeAndInspectExampleText
    |text|

    text := self clickedExampleTextOrNil asString.
    self
        executeExampleText:text 
        withResultDo:[:rslt |
                        rslt inspect.
                     ]
        onErrorDo:[:ex |
                        infoHolder notNil ifTrue:[
                            infoHolder value:('Error: ' , ex description)
                        ].
                        Dialog 
                            warn:(resources stringWithCRs:'Error encountered while evaluating in the example:\\%1' with:ex description)
                  ].
!

executeExampleText
    |text|

    text := self clickedExampleTextOrNil asString.
    self
        executeExampleText:text
        withResultDo:[:rslt |
                     ]
        onErrorDo:[:ex |
                        infoHolder notNil ifTrue:[
                            infoHolder value:('Error: ' , ex description)
                        ].
                        Dialog 
                            warn:(resources stringWithCRs:'Error encountered while evaluating in the example:\\%1' with:ex description) 
                  ].
!

inspectImage
    |imgElement|

    imgElement := painter imageAt:lastClickPosition.
    imgElement notNil ifTrue:[
        imgElement image inspect
    ].
    ^ nil

    "Created: 6.11.1996 / 13:44:30 / cg"
    "Modified: 6.11.1996 / 13:45:19 / cg"
!

openNewOnAnchor
    |anchorElement href|

"/ does not work yet

    anchorElement := painter anchorAt:lastClickPosition.
    anchorElement notNil ifTrue:[
        href := anchorElement hrefString.
        href notEmptyOrNil ifTrue:[
            HTMLDocumentView openFullOnURL:href.
        ].
    ].

    "Created: / 27-04-1998 / 20:29:44 / cg"
    "Modified: / 16-11-2016 / 17:16:12 / cg"
!

saveImage
    |imgElement img fileName defaultName|

    imgElement := painter imageAt:lastClickPosition.
    imgElement notNil ifTrue:[
        (img := imgElement image) notNil ifTrue:[
            defaultName := img fileName.
            defaultName isNil ifTrue:[
                defaultName := imgElement urlString.
                defaultName isNil ifTrue:[
                    defaultName := 'unknown'
                ]
            ].
            defaultName := defaultName asFilename withoutSuffix baseName.

            fileName := Dialog
                        requestFileNameForSave:(resources string:'Save Image In:')
                        default:(defaultName , '.tiff')
                        ok:(resources string:'Save')
                        abort:(resources string:'Cancel')
                        pattern:'*.tiff'.

            fileName notNil ifTrue:[
                img saveOn:fileName.
            ]
        ]
    ].
    ^ nil

    "Created: / 06-11-1996 / 13:44:30 / cg"
    "Modified: / 27-10-2010 / 11:34:29 / cg"
!

showImageInFileBrowser
    |imgElement image imageFileName|

    imgElement := painter imageAt:lastClickPosition.
    imgElement notNil ifTrue:[
        (image := imgElement image) notNil ifTrue:[     "/ not unloadable    
            (imageFileName := image fileName) notNil ifTrue:[  "/ not from http  
                (imageFileName := imageFileName asFilename) exists ifTrue:[  "/ not a bad/removed file  
                    FileBrowser default
                        openOnFileNamed:imageFileName pathName
                        editing:false.
                ]
            ]    
        ].
    ].
    ^ nil

    "Modified: / 01-09-2017 / 14:05:14 / cg"
!

terminalOnExampleText
    |dir text app terminal|

    text := self clickedExampleTextOrNil.
    text notNil ifTrue:[
        dir := OperatingSystem pathOfSTXExecutable asFilename directory.
        TerminalApplication notNil ifTrue:[
            app := TerminalApplication openIn:dir.
            terminal := app selectedWorkspace.
        ] ifFalse:[
            terminal := VT100TerminalView openShellIn:dir.
        ].
        Delay waitForSeconds:0.2.
        terminal sendLine:'export PATH=$PATH:.'.
        terminal send:text asStringWithoutFinalCR.
    ].
!

workspaceOnExampleText
    |text|

    text := self clickedExampleTextOrNil.
    text notNil ifTrue:[
        (WorkspaceApplication openWith:text) "/ initialSyntax:nil. -- not a good idea; most examples are smalltalk
    ].
! !

!HTMLDocumentFrame methodsFor:'misc'!

ampersandBindings
    |bindings loginName fullName words|

    bindings := Dictionary new.
    bindings at:#date        put:(Date today printString).
    bindings at:#time        put:(Time now printString).
    bindings at:#host        put:(OperatingSystem getHostName).
    currentURL isNil ifTrue:[
        bindings at:#url         put:''.
        bindings at:#urlBaseName put:''.
        bindings at:#urlDirName  put:''.
    ] ifFalse:[
        bindings at:#url         put:currentURL.
        bindings at:#urlBaseName put:currentURL asFilename baseName.
        bindings at:#urlDirName  put:currentURL asFilename directoryName.
    ].
    bindings at:#exception   put:'no exception information'.
    bindings at:#message     put:'no message'.
    bindings at:#loginName   put:(loginName := OperatingSystem getLoginName).
    bindings at:#userID      put:OperatingSystem getUserID printString.
    bindings at:#groupID     put:OperatingSystem getGroupID printString.
    fullName := OperatingSystem getFullUserName.
    (fullName isEmptyOrNil) ifTrue:[
        bindings at:#userName      put:loginName.
        bindings at:#userFirstName put:loginName.
    ] ifFalse:[
        bindings at:#userName      put:fullName.

        words := fullName asCollectionOfWords.
        (words size > 1 
        and:[words first endsWith:',']) ifTrue:[
            bindings at:#userFirstName put:(words last).
        ] ifFalse:[
            bindings at:#userFirstName put:(words first).
        ].
    ].

    bindings at:#hostName    put:(OperatingSystem getHostName).
    bindings at:#domainName  put:(OperatingSystem getDomainName).

    bindings at:#stxVersion  put:(Smalltalk versionString).

    additionalBindings notNil ifTrue:[
        additionalBindings keysAndValuesDo:[:k :v|
            bindings at:k put:v
        ]
    ].
    ^ bindings

    "Modified: 24.1.1997 / 11:22:14 / cg"
!

backToPreviousDocument
    |url historyEntry action anchor pos text host|

    (hRefHistory isEmptyOrNil) ifTrue:[
        ^ self
    ].
    urlHistory notEmptyOrNil ifTrue:[
        urlHistory removeLast.
    ].
    
    historyEntry := hRefHistory removeLast.

"/  Transcript showCR:historyEntry printString.

    url := historyEntry url.
    action := historyEntry action.
    anchor := historyEntry anchor.
    pos := historyEntry position.
    text := historyEntry text.
    host := historyEntry host.

    self canGoBackHolder value:(urlHistory size > 1
                               or:[ (urlHistory size == 1) and:[urlHistory first ~= url]] ).

"/Transcript showCR:'back to ' , url.
"/Transcript showCR:'anchor ' , anchor printString.

    currentURLHost := host.

    text notNil ifTrue:[
        self setText:text anchor:anchor documentName:nil.
    ] ifFalse:[
        self showDocument:url text:nil action:action remember:false source:false.
    ].

    anchor notNil ifTrue:[
        self positionOnAnchor:anchor
    ] ifFalse:[
        pos notNil ifTrue:[
            self scrollVerticalToPercent:pos.
        ]
    ]

    "Modified: / 21.9.1996 / 17:00:04 / cg"
    "Created: / 27.10.1997 / 21:00:59 / cg"
!

elementAt:aPoint
    ^ painter elementAt:aPoint 
!

fontEncodingFor:encodingSymbol
    |fn|

    fn := FontDescription fontNamePatternForCharset:encodingSymbol.
    fn isNil ifTrue:[
        fn := #'iso8859-1'
    ].
    ^ fn

    "Created: 30.6.1997 / 11:24:46 / cg"
    "Modified: 1.7.1997 / 00:36:23 / cg"
!

getVerticalPosition
     |h|

     h := self heightOfContents.
     h == 0 ifTrue:[^ 0].
     currentPercentage := self yOriginOfContents / h * 100.

    "Created: 17.5.1996 / 17:12:44 / cg"
    "Modified: 21.5.1996 / 15:24:54 / cg"
!

isValidMethod:methodString
    ^ #('file' 'http' 'ftp') includes:methodString
!

positionOnAnchor:aLocalAnchor
    |pos|

    pos := painter positionOfAnchor:aLocalAnchor.
    pos isNil ifTrue:[
        "/ not yet visible - remember to position later
        localAnchor := aLocalAnchor
    ] ifFalse:[
        self scrollVerticalTo:((pos y - 10) max:0).
        self getVerticalPosition.
    ]
!

positionTo:aPoint
    self scrollVerticalTo:(aPoint y max:0).
    self getVerticalPosition.
!

showNotFound:aFileName
    self setText:'
<HTML><BODY>
<STRONG>Cannot find document:</STRONG>
<P>
' , aFileName , '
</BODY></HTML>
'       anchor:nil.

    "Created: 22.5.1996 / 14:03:03 / cg"
!

startImageFlushProcess
    ImageFlushProcess notNil ifTrue:[
        ImageFlushProcess terminate "/ NoSignal
    ].
    ImageFlushProcess := [
                            Delay waitForSeconds:ImageFlushDelay.
                            ImageFlushProcess := nil.    
                            CachedImages := nil.
                         ] fork.
    ImageFlushProcess name:'HTMLDocumentView: image flusher'.

    "Created: / 17-06-1996 / 17:56:09 / cg"
    "Modified: / 29-06-2011 / 19:24:27 / cg"
! !

!HTMLDocumentFrame methodsFor:'queries'!

documentTitle
    ^ self currentDocument
!

extentOfContents
    ^ (self widthOfContents @ self heightOfContents)
!

heightForLines:numberOfLines
    "return the height of the receiver, if numberOfLines are to be displayed"

    |normalFont fs|

    "need a device font for query"
    fs := style fontStyles at:#'iso8859-1' ifAbsent:nil.
    fs isNil ifTrue:[
        fs := style fontStyles at:#'iso10646-1' ifAbsent:nil.
        fs isNil ifTrue:[^ 15].
    ].
    normalFont := fs normalFont onDevice:device.
    ^ numberOfLines * normalFont height + normalFont descent + (margin * 2)

    "Created: / 06-09-1996 / 17:58:45 / stefan"
    "Modified: / 10-08-2010 / 23:09:44 / cg"
!

heightOfContents
    painter isNil ifTrue:[^ 0].

    ^ painter height

    "Created: 17.5.1996 / 17:29:15 / cg"
    "Modified: 17.5.1996 / 17:32:19 / cg"
!

horizontalScrollStep
    ^ 10

    "Created: / 22.5.1999 / 17:28:58 / cg"
!

preferredExtentForLines:numLines cols:numCols
    "get an approximation for the extent to display numLines and
     numCols in normal fontsize"

    |normalFont fs|

    "need a device font for query"
    fs := style fontStyles at:#'iso8859-1' ifAbsent:nil.
    fs isNil ifTrue:[
        fs := style fontStyles at:#'iso10646-1' ifAbsent:nil.
        fs isNil ifTrue:[^ 300@300].
    ].
    normalFont := fs normalFont onDevice:device.
    ^ (((normalFont widthOf:'x') * numCols + margin + margin) 
      @ 
      (normalFont height * numLines + margin + margin + normalFont descent)).

    "Created: / 06-09-1996 / 17:59:30 / stefan"
    "Modified: / 10-08-2010 / 23:11:25 / cg"
!

verticalScrollStep
    "return the amount to scroll when stepping up/down (also used for mouseWheel)."

    ^ 10

    "Created: / 22.5.1999 / 13:14:10 / cg"
!

widthOfContents
    painter isNil ifTrue:[^ self innerWidth].
    ^ painter width

    "Created: 17.5.1996 / 17:29:20 / cg"
    "Modified: 2.10.1996 / 13:58:44 / cg"
! !

!HTMLDocumentFrame methodsFor:'user actions'!

anchorElementSelected:anchorElement
    "user clicked on an anchor.
     If the anchor has an action link and linkActions are enabled,
     or it is an external link, and external links are enabled,
     or it is an internal link, then proceed in showDocument:,
     which performs the action. Otherwise ignore the click"

    |newURL actionString hrefString|

    actionString := anchorElement actionString.
    hrefString := anchorElement hrefString.

    actionString notEmptyOrNil ifTrue:[
        enableActionLinks ifFalse:[^ self].
    
        enableExternalLinks ifFalse:[
            hrefString isEmptyOrNil ifTrue:[
                newURL := URL fromString:'/'.
            ] ifFalse:[
                newURL := URL fromString:hrefString.
            ].
            newURL ~= uriHolder value ifTrue:[^ self].
        ]
    ].

    self 
        showDocument:hrefString 
        text:(anchorElement anchorText)
        action: actionString
        remember:true
        source:false

    "Modified: 24.4.1997 / 12:20:16 / cg"
!

exampleElementSelected:exampleElement
    "user clicked on an example. If execution is enabled,
     evaluate it save from any exceptions (show what happened, if
     any exception is raised during evaluation).
     If the exampleElement has a SHOWRESULT attribute, display the
     printString in the infoView."

    |action exampleHRef anchorText actionText showResult|

    "/ exampleHRef := exampleElement hrefString.   "/ not used
    anchorText := exampleElement anchorText.
    actionText := exampleElement actionString.

"/    Transcript show:'example selected text='; showCR:anchorText.

    action := actionText ? anchorText.
    showResult := exampleElement hasParameterFor:#'SHOWRESULT'.

    self
        executeExampleText:action 
        withResultDo:[:rslt |
                        showResult ifTrue:[
                            self showResultOfCodeExample:rslt.
                        ]
                     ]
        onErrorDo:[:ex |
                        |answer|

                        showResult ifTrue:[
                            infoHolder notNil ifTrue:[
                                infoHolder value:('Error: ' , ex description)
                            ]
                        ].
                        answer := OptionBox 
                            request:(resources stringWithCRs:'Error encountered while evaluating in the example:\\%1' with:ex description)  
                            buttonLabels:#('Abort' 'Debug' ) 
                            values:#(abort debug )
                            default:#abort.
                        answer = #debug ifTrue:[
                            ex reject "/ DebugView enter.
                        ]
                  ].

    "Modified: / 16-11-2016 / 17:15:42 / cg"
!

executeExampleText:action withResultDo:resultAction onErrorDo:errorAction
    "user clicked on an example. If execution is enabled,
     evaluate it save from any exceptions (show what happened, if
     any exception is raised during evaluation).
     If the exampleElement has a SHOWRESULT attribute, display the
     printString in the infoView."

    |plug box l tv
    |

    enableExecution ifFalse:[
        box := DialogBox new.
        l := box addTextLabel:('Code execution disabled.\if it wasn''t, the action would be:\\') withCRs.
        l adjust:#left.
        box font:(Font family:'courier' size:12).
        tv := HVScrollableView for:TextView.
        tv contents:action.
        tv preferredExtent:400@200.
        tv extent:400@200.
        box addComponent:tv.
        box addOkButton.
        box show.
"/        self warn:('code execution disabled.\if it wasn''t, the action would be:\\' , action) withCRs.
        ^ self
    ].

    self topView withWaitCursorDo:[
        |transcript|

        transcript := Transcript current.
        plug := Plug new.
        plug respondTo:#error:position:to:from:
             with:[:msg :p1 :p2 :who | Dialog warn:('Syntax error in the example:\\' , msg) withCRs].
        plug respondTo:#correctableError:position:to:from:
             with:[:msg :p1 :p2 :who | transcript showCR:('Warning in the example:\\' , msg) withCRs. false].
        plug respondTo:#correctableWarning:position:to:from:
             with:[:msg :p1 :p2 :who | transcript showCR:('Warning in the example:\\' , msg) withCRs. false].
        plug respondTo:#correctableSelectorWarning:position:to:from:
             with:[:msg :p1 :p2 :who | transcript showCR:('Warning in the example:\\' , msg) withCRs. false].
        plug respondTo:#warning:position:to:from:
             with:[:msg :p1 :p2 :who | transcript showCR:('Warning in the example:\\' , msg) withCRs. false].
        plug respondTo:#autoDefineVariables
             with:[#doIt].
        AbortOperationRequest handle:[:ex |
            ex return
        ] do:[
            UserInterrupt handle:[:ex |
                |answer|

                catchErrors ifFalse:[
                    ex reject
                ].
                answer := Dialog 
                    confirmWithCancel:(resources string:'Example execution interrupted.') withCRs
                    labels:(resources array:#('Debug' 'Abort' 'Continue')).
"/ Transcript showCR:answer.
                answer == false ifTrue:[
                    AbortOperationRequest raise
                ].
                answer isNil ifTrue:[
                    Debugger enter.
                ].
                ex proceed
            ] do:[
                Error handle:[:ex |
                    catchErrors ifFalse:[
                        ex reject
                    ].
                    ex creator == UserInterrupt ifTrue:[
                        (Dialog 
                            confirm:(resources string:'Example execution interrupted.\\Abort ?') withCRs
                            yesLabel:(resources string:'Abort')
                            noLabel:(resources string:'Continue'))
                        ifFalse:[
                            ex proceed
                        ]
                    ] ifFalse:[
                        errorAction value:ex.
                    ].
                    ex return
                ] do:[
                    Class nameSpaceQuerySignal handle:[:ex |
                        |ns|

                        nameSpaceForExecution isNil ifTrue:[
                            ns := Project defaultNameSpace
                        ] ifFalse:[
                            ns := nameSpaceForExecution
                        ].
                        ex proceedWith:ns
                    ] do:[
                        |rslt|

                        rslt := Compiler 
                            evaluate:action
                            receiver:self
                            notifying:plug.

                        resultAction value:rslt.
                    ]
                ]
            ]
        ]
    ]

    "Created: / 20-05-1996 / 14:45:04 / cg"
    "Modified: / 20-07-2011 / 10:28:43 / cg"
!

showResultOfCodeExample:rslt
    |classInfo|

    infoHolder isNil ifTrue:[^ self].

    classInfo := ''.
    rslt isInteger ifFalse:[
        rslt isLimitedPrecisionReal ifFalse:[
            rslt isBoolean ifFalse:[
                rslt isNil ifFalse:[
                    classInfo := ' ( ' , rslt classNameWithArticle , ' )'.
                ].
            ].
        ].
    ].

    infoHolder value:('The result is: ' , rslt displayString, classInfo)
!

updateAnchorInfoForX:x y:y
    "look for any anchor under the mouse pointer at x/y;
     update infoLabel, if there is any"

    |a urlString action url typ info title method file localAnchor host pos|

    painter isNil ifTrue:[^ self].
    infoHolder isNil ifTrue:[^ self].

    a := painter anchorAt:x@y.
    a notNil ifTrue:[
        (info := a parameterFor:#'INFO') notNil ifTrue:[
            infoHolder value:info
        ] ifFalse:[ (title := a parameterFor:#'TITLE') notNil ifTrue:[
            infoHolder value:title
        ] ifFalse:[
            (urlString := a hrefString) notEmptyOrNil ifTrue:[
                infoHolder value:urlString.

                "/ if it's a href to a local anchor, 
                "/ check if that anchor is present

                url := URL fromString:urlString.

                method := (url method) ? 'file'.
                file := url file.
                localAnchor := url anchor.
                host := url host.

                (method = 'file' 
                and:[(file isEmptyOrNil)
                and:[localAnchor notNil
                and:[host isNil]]]) ifTrue:[
                    pos := painter positionOfAnchor:localAnchor.
                    pos isNil ifTrue:[
                        infoHolder value:(urlString , ' ??')
                    ]
                ].
            ] ifFalse:[
                typ := a parameterFor:#'TYPE'.
                (typ notNil and:[typ asLowercase = 'example']) ifTrue:[
                    infoHolder value:'#internal: doIt - execution'
                ] ifFalse:[
                    action := a parameterFor:#'ACTION'.
                    (action notNil) ifTrue:[
                        infoHolder value:'#internal: doIt - execution'
                    ] ifFalse:[
                        infoHolder value:''
                    ]
                ]
            ]
        ]].
        (a hasParameterFor:#'ONMOUSEOVER') ifTrue:[
            painter mouseOverAnchor:a.
        ] 
    ] ifFalse:[
        infoHolder value:''
    ].

    "Created: / 04-01-1997 / 23:19:38 / cg"
    "Modified: / 16-11-2016 / 17:16:24 / cg"
    "Modified (comment): / 13-02-2017 / 20:21:57 / cg"
! !

!HTMLDocumentFrame::HRefHistoryEntry methodsFor:'accessing'!

action
    ^ action
!

anchor
    ^ anchor
!

host
    ^ host
!

position
    ^ position
!

text
    ^ text
!

url
    ^ url
!

url:urlArg action:actionArg anchor:anchorArg position:positionArg text:textArg host:hostArg 
    url := urlArg.
    action := actionArg.
    anchor := anchorArg.
    position := positionArg.
    text := textArg.
    host := hostArg.
! !

!HTMLDocumentFrame::ImageResolverQuery class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Claus Gittinger

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HTMLDocumentFrame class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentFrame.st,v 1.227 2018-09-03 13:39:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLDocumentFrame.st,v 1.227 2018-09-03 13:39:02 cg Exp $'
! !


HTMLDocumentFrame initialize!
