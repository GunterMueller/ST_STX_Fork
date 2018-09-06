"
 COPYRIGHT (c) 1997 by eXept Software AG 
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

Object subclass:#MIMETypes
	instanceVariableNames:''
	classVariableNames:'CharSetToFontMapping DefaultCommandPerMIMEPerOS
		DefaultPrintCommandPerMIMEPerOS
		FileSuffixToImageReaderClassMapping FileSuffixToTypeMapping
		FilenameToTypeMapping LastSuffix LastType
		SuffixToCommentStringMapping SuffixToParenthesisSpecMapping
		TypeFromContentsDetectors TypeToCommentStringMapping
		TypeToFileSuffixMapping TypeToImageReaderClassMapping
		TypeToInfoMapping TypeToParenthesisSpecMapping
		TypeToViewerApplicationMapping'
	poolDictionaries:''
	category:'Net-Communication-Support'
!

ImmutableString variableByteSubclass:#MIMEType
	instanceVariableNames:''
	classVariableNames:'CachedTypes'
	poolDictionaries:''
	privateIn:MIMETypes
!

!MIMETypes class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG 
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
    just a place to keep MIME information
    (avoid spreading things at many places)

    MIMETypes is abstract and functional.
    Actually, in some OperatingSystems, this information may
    be found in some config files (or registries).
    Therefore, this class may have to be extended to support this
    and fetch the information from there eventually.

    [author:]
        Claus Gittinger
"
!

examples
"
                                                                            [exBegin]
    MIMETypes mimeTypeFromString:'text/plain' 
                                                                            [exEnd]
                                                                            [exBegin]
    MIMETypes mimeTypeFromString:'application/x-expecco-testsuite' 
                                                                            [exEnd]

                                                                            [exBegin]
    MIMETypes mimeTypeForSuffix:'gif'     
    MIMETypes mimeTypeForSuffix:'ets'
    MIMETypes mimeTypeForSuffix:'xlsx'
                                                                            [exEnd]
"
!

knownTypes
"
    simply a reminder for me ...

    application         mime                            file extentsions

        powerpoint      application/ms-powerpoint       .pot, .ppz, .ppt, .pps, 
                        application/mspowerpoint        
                        application/vnd.ms-powerpoint   
                        application/x-mspowerpoint

        shockwave       application/x-shockwave-flash   .swf     

        futuresplash    application/futuresplash        .spl
"
! !

!MIMETypes class methodsFor:'initialization'!

addMimeTypeDetector:aMimeTypeFromContentsDetectorBlock
    "any class (especially: image readers) may add a block
     which detects the mime-type from a givel contents.
     The block is called with two arguments, some data (usually the first few kilobytes
     of a file) and the suffix of the file, or nil if unknown.
     The block should return the mimeType or nil."
     
    TypeFromContentsDetectors isNil ifTrue:[ TypeFromContentsDetectors := OrderedCollection new ]. 
    TypeFromContentsDetectors add:aMimeTypeFromContentsDetectorBlock.
!

initialize
    "initialize wellKnown facts"
    
    MIMEType initialize. "must be initialized first"
    LastSuffix := LastType := nil.
    self initializeFileNameToMimeTypeMapping.
    self initializeImageReaderMappings.
    self initializeCommentStringMappings.
    self initializeParenthesisSpecMappings.
    
    "
     self initialize
    "

    "Modified: / 10-04-2007 / 15:16:44 / cg"
    "Modified (comment): / 29-11-2011 / 19:11:51 / cg"
!

initializeCommentStringMappings
    "these are used by the editor's comment/uncomment functions"

    TypeToCommentStringMapping := Dictionary new.
    SuffixToCommentStringMapping := Dictionary new.

    TypeToCommentStringMapping 
        at:'application/x-make'
        put:#('#' (nil nil)).           "/ '#' EOL comments only

    TypeToCommentStringMapping 
        at:'application/x-sh'
        put:#('#' (nil nil)).           "/ '#' EOL comments only

    #('text/html' 'text/xml' 
      'application/xml' 
      'application/x-expecco-testsuite'
      'application/x-expecco-logfile'
    )
    do:[:eachXMLType |
        TypeToCommentStringMapping 
            at:eachXMLType
            put:#(nil ('<!!-- ' ' -->')). "/ '<!!-- ... -->' delimited comments only
    ].

    TypeToCommentStringMapping 
        at:'text/css'
        put:#('//' ('/*' '*/')).          

    TypeToCommentStringMapping 
        at:'application/x-batch-script'
        put:#('@REM ' '@rem ' 'REM ' 'rem ' (nil nil)).         "/ 'rem ' for EOL comments only

    "/ the following is ST/X specific
    TypeToCommentStringMapping 
        at:'application/x-smalltalk-source'
        put:#('"/' ('"' '"')).           "/ '"/ ' for EOL; ".." for delimited comments

    "/ this is for standard smalltalk
"/    TypeToCommentStringMapping 
"/        at:'application/x-smalltalk-source'
"/        put:#(nil ('"' '"')).            "/ ".." for delimited comments only


    TypeToCommentStringMapping 
        at:'application/x-pascal-source'
        put:#(nil ('{' '}')).           "/ '{'..'}' for delimited comments

    "/ this is ANSI-c
    TypeToCommentStringMapping 
        at:'application/x-c-source'
        put:#('//' ('/*' '*/')).          

    TypeToCommentStringMapping 
        at:'application/x-cpp-source'
        put:#('//' ('/*' '*/')).          

    TypeToCommentStringMapping 
        at:'application/x-csharp-source'
        put:#('//' ('/*' '*/')).          

    TypeToCommentStringMapping 
        at:'application/x-java-source'
        put:#('//' ('/*' '*/')).          

    TypeToCommentStringMapping 
        at:'application/x-javascript'
        put:#('//' ('/*' '*/')).          

    TypeToCommentStringMapping 
        at:'application/x-lisp-source'
        put:#(';' (nil nil)).           "/ ';' for EOL comments only

    TypeToCommentStringMapping 
        at:'application/x-python-source'
        put:#('#' (nil nil)).           "/ '#' for EOL comments only

    TypeToCommentStringMapping 
        at:'application/x-asn1-source'
        put:#('--' ('--' '--')).          


    "/ st/x support files
    SuffixToCommentStringMapping 
        at:'style'
        put:#(';' (nil nil)).          

    SuffixToCommentStringMapping 
        at:'rs'
        put:#(';' (nil nil)).

    "Modified: / 06-09-2011 / 10:46:27 / cg"
!

initializeDefaultCommands
    "these are used to select an application to be opened when a file of a particular
     type is double clicked in the browser.
     TODO: move this to OS"

    |unixCommands win32Commands unixPrintCommands win32PrintCommands listToTry|

    DefaultCommandPerMIMEPerOS := Dictionary new.
    DefaultCommandPerMIMEPerOS at:#unix  put:(unixCommands := Dictionary new).
    DefaultCommandPerMIMEPerOS at:#win32 put:(win32Commands := Dictionary new).

    unixCommands at:'application/x-tar-compressed' put:'tar tvf -'.

    OperatingSystem isMSWINDOWSlike ifFalse:[ |cmd|
        OperatingSystem isOSXlike ifTrue:[
            unixCommands at:'text/html' put:('open -a Safari "%1"').       
            unixCommands at:'application/pdf' put:('open -a Preview "%1"').       
        ] ifFalse:[
            listToTry := #('firefox' 'chrome' 'chromium' 'konqueror' 'opera').
            cmd := listToTry
                        detect:[:aCmd| (OperatingSystem pathOfCommand:aCmd) notEmptyOrNil ]
                        ifNone:nil.
            cmd notNil ifTrue:[
                unixCommands at:'text/html' put:(cmd, ' "%1"')       
            ].

            listToTry := #('acroread' 'okular' 'evince' 'kpdf' 'xpdf').
            cmd := listToTry
                        detect:[:aCmd| (OperatingSystem pathOfCommand:aCmd) notEmptyOrNil ]
                        ifNone:nil.
            cmd notNil ifTrue:[
                unixCommands at:'application/pdf' put:(cmd, ' "%1"')       
            ].
        ].
    ].


    DefaultPrintCommandPerMIMEPerOS := Dictionary new.
    DefaultPrintCommandPerMIMEPerOS at:#unix  put:(unixPrintCommands := Dictionary new).
    DefaultPrintCommandPerMIMEPerOS at:#win32 put:(win32PrintCommands := Dictionary new).

    "/ if you have a good (intelligent) spooler ;-)
    unixPrintCommands at:'application/pdf'         put:'lpr "%1"'.
    "/ if not, you may need more...
    "/ unixPrintCommands at:'application/pdf'         put:'pdfToPS %1 | lpr'.

    "
     self initializeDefaultCommands
    "

    "Modified: / 12-05-2004 / 11:43:23 / cg"
!

initializeFileInfoMappings
    "these are used by the file browser if a 'file' command is not present in the OS"

    TypeToInfoMapping := Dictionary new.

    TypeToInfoMapping at:'application/x-smalltalk-source' put:'Smalltalk source'.
    TypeToInfoMapping at:'text/html' put:'HTML document'.
    TypeToInfoMapping at:'text/xml' put:'XML document'.
    TypeToInfoMapping at:'application/xml' put:'XML document'.
    TypeToInfoMapping at:'application/x-c-source' put:'C source'.
    TypeToInfoMapping at:'application/x-c-header' put:'C header file'.
    TypeToInfoMapping at:'application/x-cpp-source' put:'C++ source'.
    TypeToInfoMapping at:'application/x-csharp-source' put:'C# source'.
    TypeToInfoMapping at:'application/x-java-source' put:'Java source'.
    TypeToInfoMapping at:'application/x-javascript' put:'Javascript source'.
    TypeToInfoMapping at:'application/x-lisp-source' put:'Lisp source'.
    TypeToInfoMapping at:'application/x-python-source' put:'Python source'.

    TypeToInfoMapping at:'application/x-make' put:'make rules'.
    TypeToInfoMapping at:'application/binary' put:'binary object file'.

    "
     self initializeFileInfoMappings
     'foo.H' asFilename mimeTypeFromName
     'foo.o' asFilename mimeTypeFromName
    "
!

initializeFileNameToMimeTypeMapping
    "initialize wellKnown facts"

    |types|

    FileSuffixToTypeMapping isNil ifTrue:[
        FileSuffixToTypeMapping := Dictionary new
    ].
    TypeToFileSuffixMapping isNil ifTrue:[
        TypeToFileSuffixMapping := Dictionary new
    ].
    FilenameToTypeMapping isNil ifTrue:[
        FilenameToTypeMapping := Dictionary new.
    ].

    types := OrderedCollection new.
    types addAll:self textTypeList.
    types addAll:self imageTypeList.
    types addAll:self videoTypeList.
    types addAll:self audioTypeList.
    types addAll:self applicationTypeList.
    types addAll:self osSpecificTypeList.

    types pairWiseDo:[:suff :typeString|
        |type|

        type := MIMEType fromString:typeString.
        suff isArray ifTrue:[
            suff do:[:s | FileSuffixToTypeMapping at:s put:type].
            TypeToFileSuffixMapping at:type put:suff first.
        ] ifFalse:[
            FileSuffixToTypeMapping at:suff put:type.
            TypeToFileSuffixMapping at:type put:suff.
        ].
    ].

    self miscFilenameList pairWiseDo:[:nm :typeString|
        |type|

        type := MIMEType fromString:typeString.
        nm isArray ifTrue:[
            nm do:[:s | FilenameToTypeMapping at:s put:type]
        ] ifFalse:[
            FilenameToTypeMapping at:nm put:type
        ]
    ].

    "
     self initializeFileNameToMimeTypeMapping
    "
!

initializeImageReaderMappings
    "these are used so select an image reader, based on a bitmap image's mime type"

    |rdr|

    FileSuffixToImageReaderClassMapping isNil ifTrue:[
        FileSuffixToImageReaderClassMapping := Dictionary new
    ].
    "MIME" TypeToImageReaderClassMapping isNil ifTrue:[
        TypeToImageReaderClassMapping := Dictionary new
    ].

    "/ setup mimeType to image reader class mapping ...
    TypeToImageReaderClassMapping at:'image/jpeg' put:JPEGReader.
    TypeToImageReaderClassMapping at:'image/gif'  put:GIFReader.
    TypeToImageReaderClassMapping at:'image/tiff' put:TIFFReader.
    TypeToImageReaderClassMapping at:'image/png'  put:PNGReader.
    TypeToImageReaderClassMapping at:'image/icns' put:MacOSXIconReader.

    "/ setup suffix to image reader class mapping ...
    FileSuffixToImageReaderClassMapping at:'jpg'  put:JPEGReader.
    FileSuffixToImageReaderClassMapping at:'jpeg' put:JPEGReader.
    FileSuffixToImageReaderClassMapping at:'gif'  put:GIFReader.
    FileSuffixToImageReaderClassMapping at:'tif'  put:TIFFReader.
    FileSuffixToImageReaderClassMapping at:'tiff' put:TIFFReader.
    FileSuffixToImageReaderClassMapping at:'png'  put:PNGReader.
    FileSuffixToImageReaderClassMapping at:'icns'  put:MacOSXIconReader.

    "/ some 'used-to-be-optional' readers
    (rdr := Smalltalk at:#WindowsIconReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/bmp'      put:rdr.
        TypeToImageReaderClassMapping       at:'image/x-MS-bmp' put:rdr.
        TypeToImageReaderClassMapping       at:'image/x-ms-bmp' put:rdr.
        TypeToImageReaderClassMapping       at:'image/x-MS-ico' put:rdr.
        TypeToImageReaderClassMapping       at:'image/x-ms-ico' put:rdr.
        FileSuffixToImageReaderClassMapping at:'bmp'            put:rdr.
        FileSuffixToImageReaderClassMapping at:'ico'            put:rdr.
    ].
    (rdr := Smalltalk at:#XBMReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-xbitmap' put:rdr.
        FileSuffixToImageReaderClassMapping at:'xbm'             put:rdr.
    ].
    (rdr := Smalltalk at:#XPMReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-xpixmap' put:rdr.
        FileSuffixToImageReaderClassMapping at:'pm'              put:rdr.
    ].
    (rdr := Smalltalk at:#PBMReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-portable-pixmap'  put:rdr.
        TypeToImageReaderClassMapping       at:'image/x-portable-bitmap'  put:rdr.
        TypeToImageReaderClassMapping       at:'image/x-portable-graymap' put:rdr.
        TypeToImageReaderClassMapping       at:'image/x-portable-anymap'  put:rdr.
        FileSuffixToImageReaderClassMapping at:'ppm'                      put:rdr.
        FileSuffixToImageReaderClassMapping at:'pbm'                      put:rdr.
        FileSuffixToImageReaderClassMapping at:'pgm'                      put:rdr.
        FileSuffixToImageReaderClassMapping at:'pnm'                      put:rdr.
    ].
    (rdr := Smalltalk at:#PCXReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-pcx' put:rdr.
        FileSuffixToImageReaderClassMapping at:'pcx'         put:rdr.
    ].
    (rdr := Smalltalk at:#TargaReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-targa' put:rdr.
        FileSuffixToImageReaderClassMapping at:'tga'           put:rdr.
    ].
    (rdr := Smalltalk at:#XWDReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-xwindowdump' put:rdr.
        TypeToImageReaderClassMapping       at:'image/x-windowdump'  put:rdr.
        FileSuffixToImageReaderClassMapping at:'xwd'                 put:rdr.
    ].
    (rdr := Smalltalk at:#BlitImageReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-blitimage' put:rdr.
        FileSuffixToImageReaderClassMapping at:'48x48x1'           put:rdr.
    ].
    (rdr := Smalltalk at:#IrisRGBReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-rgb' put:rdr.
        FileSuffixToImageReaderClassMapping at:'rgb'         put:rdr.
    ].
    (rdr := Smalltalk at:#SunRasterReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-sunraster' put:rdr.
        FileSuffixToImageReaderClassMapping at:'im8'               put:rdr.
        FileSuffixToImageReaderClassMapping at:'icon'              put:rdr.
    ].
    (rdr := Smalltalk at:#ST80FormReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-st80-form' put:rdr.
        FileSuffixToImageReaderClassMapping at:'form'              put:rdr.
    ].
    (rdr := Smalltalk at:#FaceReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-face' put:rdr.
        FileSuffixToImageReaderClassMapping at:'face'         put:rdr.
    ].
    (rdr := Smalltalk at:#PCDReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-photo-cd' put:rdr.
        FileSuffixToImageReaderClassMapping at:'pcd'              put:rdr.
    ].
    (rdr := Smalltalk at:#CMURasterReader) notNil ifTrue:[
        TypeToImageReaderClassMapping       at:'image/x-cmu-raster' put:rdr.
        FileSuffixToImageReaderClassMapping at:'ras'                put:rdr.
    ].

    "/ movie formats - experimental and not yet complete / finished / delivered / published
"/    (rdr := Smalltalk at:#FLIReader) notNil ifTrue:[
"/        TypeToImageReaderClassMapping       at:'video/x-fli' put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'fli'         put:rdr.
"/    ].
"/    (rdr := Smalltalk at:#AVIReader) notNil ifTrue:[
"/        TypeToImageReaderClassMapping       at:'video/x-msvideo' put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'avi'             put:rdr.
"/    ].
"/    (rdr := Smalltalk at:#AVIReader) notNil ifTrue:[
"/        TypeToImageReaderClassMapping       at:'video/x-msvideo' put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'avi'             put:rdr.
"/    ].
"/    (rdr := Smalltalk at:#QuickTimeReader) notNil ifTrue:[
"/        TypeToImageReaderClassMapping       at:'video/quicktime' put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'qt'              put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'mov'             put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'moov'            put:rdr.
"/    ].
"/    (rdr := Smalltalk at:#MPEG2Reader) notNil ifTrue:[
"/        TypeToImageReaderClassMapping       at:'video/x-mpeg2' put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'mpg2'          put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'mpv2'          put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'mp2v'          put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'mp2'           put:rdr.
"/    ].
"/    (rdr := Smalltalk at:#MPEGReader) notNil ifTrue:[
"/        TypeToImageReaderClassMapping       at:'video/mpeg' put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'mpg'        put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'mpeg'       put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'mpe'        put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'mpv'        put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'vps'        put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'mpegv'      put:rdr.
"/    ].
"/    (rdr := Smalltalk at:#SGIMovieReader) notNil ifTrue:[
"/        TypeToImageReaderClassMapping       at:'video/x-sgi-movie' put:rdr.
"/        FileSuffixToImageReaderClassMapping at:'movie'             put:rdr.
"/    ].
!

initializeParenthesisSpecMappings
    "these are used by the editors to mark matching parenthesis"

    |spec|

    TypeToParenthesisSpecMapping := Dictionary new.
    SuffixToParenthesisSpecMapping := Dictionary new.
    
    "/ ST/X spec
    spec := IdentityDictionary new.
    spec at:#open put:#( $( $[ ${ ).
    spec at:#close put:#( $) $] $} ).
    spec at:#ignore put:#( $' $" '$[' '$]' '${' '$)' ).
    spec at:#eolComment put:'"/'.
    TypeToParenthesisSpecMapping at:'application/x-smalltalk-source' put:spec.
    
    "/ XML & HTML
    spec := IdentityDictionary new.
    spec at:#open put:#( $< ).
    spec at:#close put:#( $> ).
    spec at:#ignore put:#( $' $" '$[' '$]' '${' '$)' ).
    #( 'text/html' 'text/xml' 'application/xml' ) do:[:eachXMLType | 
        TypeToParenthesisSpecMapping at:eachXMLType put:spec
    ].
    
    "/ ANSI-c, Java, C#    
    spec := IdentityDictionary new.
    spec at:#open put:#( $( $[ ${ ).
    spec at:#close put:#( $) $] $} ).
    spec at:#ignore put:#( $' $" ).
    spec at:#eolComment put:'//'.
    TypeToParenthesisSpecMapping at:'application/x-c-source' put:spec.
    TypeToParenthesisSpecMapping at:'application/x-cpp-source' put:spec.
    TypeToParenthesisSpecMapping at:'application/x-csharp-source' put:spec.
    TypeToParenthesisSpecMapping at:'application/x-java-source' put:spec.
    TypeToParenthesisSpecMapping at:'application/x-javascript' put:spec.
    TypeToParenthesisSpecMapping at:'application/x-python-source' put:spec.
    
    "/ Lisp / Scheme    
    spec := IdentityDictionary new.
    spec at:#open put:#( $( $[ ).
    spec at:#close put:#( $) $] ).
    spec at:#ignore put:#( $" ).
    spec at:#eolComment put:';'.
    TypeToParenthesisSpecMapping at:'application/x-lisp-source' put:spec.

    "Created: / 10-04-2007 / 15:16:37 / cg"
! !

!MIMETypes class methodsFor:'initialization-lists'!

applicationCompressorsAndArchiveTypeList
    ^ #(
        'tar'                       'application/x-tar'
        'gtar'                      'application/x-gtar'
        ('tgz' 'tar.gz')            'application/x-tar-gzip-compressed'   "/ 'application/x-tar-compressed'
        ('tar.bz2')                 'application/x-tar-bzip2-compressed'
        'zip'                       'application/x-zip-compressed'
        'bz2'                       'application/x-bzip2-compressed'
        ('gz' 'z')                  'application/x-gzip-compressed'
        'cpio'                      'application/x-cpio'
        'shar'                      'application/x-shar'
        'jar'                       'application/java-archive'
        'sar'                       'application/x-squeak-archive'
        'sit'                       'application/x-stuffit'
        'hqx'                       'application/mac-binhex40'
        'cpt'                       'application/mac-compactpro'
        'pkg'                       'application/x-xar'     "/ a mac archiver for packages
    )
!

applicationMiscTypeList
    "misc applications"

    ^ #(
        ('a' 'o' 'obj' )                        'application/binary'
        ('lic')                                 'application/license'
        ('dll' 'so')                            'application/shared-library'

        ('ets')                                 'application/x-expecco-testsuite'
        ('etr')                                 'application/x-expecco-testrepository'
        ('elf')                                 'application/x-expecco-logfile'
        ('expeccolicense')                      'application/x-expecco-license'
        ('expeccopatch')                        'application/x-expecco-patch'
    )

    "Modified: / 03-11-2011 / 10:42:28 / sr"
!

applicationProgLangTypeList
    "applications for programming languages"

    ^ #(
        ('st' 'cls' 'rc')            'application/x-smalltalk-source'
        'sif'                        'application/x-smalltalk-source-sif'
        'pac'                        'application/x-smalltalk-dolphin-package'

        'sts'                        'application/x-squeak-source'
        'pr'                         'application/x-squeak-project'

        'c'                          'application/x-c-source'
        ('cc' 'cpp')                 'application/x-cpp-source'
        'cs'                         'application/x-csharp-source'
        ('h' 'hi')                   'application/x-c-header'
        ('js' 'mocha')               'application/x-javascript'
        ('java' 'jav')               'application/x-java-source'
        'sh'                         'application/x-sh'
        'csh'                        'application/x-csh'
        'tcl'                        'application/x-tcl'
        'pl'                         'application/x-perl'
        'dart'                       'application/x-dart'
        'mak'                        'application/x-make'
        'bat'                        'application/x-batch-script'
        ('asn1' 'x409' 'gdmo' 'gdm') 'application/x-asn1-source'

        ('lisp' 'lsp' 'scm' 'ss' 
         'arc' 'cl' 'brg')           'application/x-lisp-source'
        'py'                         'application/x-python-source'
    )

    "Modified (comment): / 21-08-2012 / 20:55:13 / cg"
!

applicationTextTypeList
    "text applications"

    ^ #(
        ('ps' 'eps')                 'application/postscript'
        "/ 'ai'                         'application/postscript'
        'pdf'                        'application/pdf'
        'rtf'                        'application/rtf'
        "/ 'rtf'                        'text/rtf'            ????
        'ics'                        'text/calendar'
        'doc'                        'application/ms-word-document'
        "/ 'doc'                        'application/winword'
        'swf'                        'application/x-shockwave-flash'
        ('ppt' 'ppz' 'pot' 'pps')    'application/mspowerpoint'
        'xls'                        'application/x-excel'   
        'slk'                        'application/vnd.ms-excel'
        'txt'                        'text/plain'
        'xlsx'                       'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        'xltx'                       'application/vnd.openxmlformats-officedocument.spreadsheetml.template'
        'potx'                       'application/vnd.openxmlformats-officedocument.presentationml.template'
        'ppsx'                       'application/vnd.openxmlformats-officedocument.presentationml.slideshow'
        'pptx'                       'application/vnd.openxmlformats-officedocument.presentationml.presentation'
        'sldx'                       'application/vnd.openxmlformats-officedocument.presentationml.slide'
        'docx'                       'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        'dotx'                       'application/vnd.openxmlformats-officedocument.wordprocessingml.template'
        'xlam'                       'application/vnd.ms-excel.addin.macroEnabled.12'
        'xlsb'                       'application/vnd.ms-excel.sheet.binary.macroEnabled.12'

        'edi'                        'application/EDIFACT'
    )

    "Modified: / 26-05-2012 / 15:27:30 / cg"
    "Modified: / 18-05-2015 / 09:46:47 / sr"
!

applicationTypeList
    "applications"

    |typeList|                            

    typeList := OrderedCollection new.
    typeList addAll:self applicationProgLangTypeList.
    typeList addAll:self applicationTextTypeList.
    typeList addAll:self applicationCompressorsAndArchiveTypeList.
    typeList addAll:self applicationMiscTypeList.

    ^ typeList
!

audioTypeList
    "audio formats ..."

    ^ #(
        ('au' 'snd')            'audio/basic'
        ('ra')                  'audio/x-realaudio'
        ('ram' 'rm')            'audio/x-pn-realaudio'
"/ cg: see unixSpecific / windowsSpecific
"/        'rpm'                   'audio/x-pn-realaudio-plugin'
        ('mpa' 'mpega' 'mpga')  'audio/mpeg'
        "/ 'mp3'                   'audio/x-mp3'
        ('mp3' 'mp2')           'audio/mpeg'
        'wav'                   'audio/x-wav'
        ('aif' 'aiff' 'aifc')   'audio/x-aiff'
        ('midi' 'mid')          'audio/midi'
    )

    "Modified: / 26-05-2012 / 15:23:45 / cg"
!

imageTypeList

    ^ #(
        "/ image formats ...

        ('jpg' 'jpeg')  'image/jpeg'
        'gif'           'image/gif'
        ('tif' 'tiff')  'image/tiff'
        ('xbm' 'bm')    'image/x-xbitmap'
        'xpm'           'image/x-xpixmap'
        'png'           'image/png'
        'pcd'           'image/x-photo-cd'
        'bmp'           'image/x-MS-bmp'
        'rgb'           'image/x-rgb'
        'ppm'           'image/x-portable-pixmap'
        'pgm'           'image/x-portable-graymap'
        'pbm'           'image/x-portable-bitmap'
        'pnm'           'image/x-portable-anymap'
        'xwd'           'image/x-xwindowdump'
        'ras'           'image/x-cmu-raster'
        'tga'           'image/x-targa'
        'ico'           'image/x-ico'
        'icns'          'image/icns'  
    ) 
!

miscFilenameList
    "other formats (not by suffix, but by fileName instead) ..."

    ^ #(
        ('makefile' 'make.proto' 'make.spec' 'nt.mak')  'application/x-make'
        ('exe' 'bin' 'com')                             'application/octet-stream'
        ('class')                                       'application/octet-stream'
        ('top')                                         'application/x-waltop-digital-notepad'
    )
!

osSpecificTypeList
    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ self windowsSpecificTypeList
    ].
    ^ self unixSpecificTypeList

"
    self osSpecificTypeList
"
!

textTypeList
   "/ misc text ...

    ^ #(
        ('html' 'htm' 'shtml')  'text/html'
        ('txt' 'text')          'text/plain'
        'xml'                   'text/xml'
        'xsd'                   'text/xml'
        'css'                   'text/css'
        'csv'                   'text/csv'
    )
!

unixSpecificTypeList

    ^ #(
"/ cg: RPM is 'audio/x-pn-realaudio-plugin' for WIN32
"/     and 'application/x-rpm' for Unix
        'rpm'                   'application/x-rpm'
    )
!

videoTypeList
    "/ video formats ...

    ^ #(
        ('qt' 'mov' 'moov')                'video/quicktime'
        ('mpv' 'mpegv' 'mpg' 'mpeg' 'mpe') 'video/mpeg'
        'movie'                            'video/x-sgi-movie'
        ('avi' 'wmv' 'asf')                'video/x-msvideo'
        ('mpv2' 'mp2v' 'mp2' 'mpeg2')      'video/x-mpeg2'
        ('mp4')                            'video/mp4'
        'rm'                               'application/vnd.rn-realmedia'
        'rv'                               'video/x-pn-realvideo'
        'fli'                              'video/x-fli'
        'flv'                              'video/x-flv'      "/ macromedia flash video
   )
!

windowsSpecificTypeList
    ^ #(
"/ cg: RPM is 'audio/x-pn-realaudio-plugin' for WIN32
"/     and 'application/x-rpm' for Unix
        'rpm'                   'audio/x-pn-realaudio-plugin'
    )
! !

!MIMETypes class methodsFor:'obsolete'!

defaultCommandForMimeType:mimeType
    <resource: #obsolete>
    self obsoleteMethodWarning:'use #defaultCommandTemplateToOpenMimeType:'.

    ^ self defaultCommandTemplateToOpenMimeType:mimeType

    "
     MIMETypes defaultCommandTemplateToOpenMimeType:'application/pdf' 
    "

    "Created: / 12-05-2004 / 11:09:22 / cg"
    "Modified: / 12-05-2004 / 11:16:53 / cg"
!

fontForCharset:aCharSetName
    "return the font-encoding for an iso-charset"

    <resource:#obsolete>
    self obsoleteMethodWarning:'use FontDescription >> fontNamePatternForCharset:'.
    ^ FontDescription fontNamePatternForCharset:aCharSetName.

    "
     MIMETypes fontForCharset:'iso2022-jp'       
     MIMETypes fontForCharset:'euc-jp'     
    "

    "Modified: / 1.8.1998 / 17:00:57 / cg"
! !

!MIMETypes class methodsFor:'queries'!

defineImageType:mimeType suffix:aSuffix reader:aReaderClass
    "register an image reader."

    aSuffix notNil ifTrue:[
        self imageReaderForSuffix:aSuffix put:aReaderClass.
    ].

    mimeType notNil ifTrue:[
        self imageReaderForType:mimeType put:aReaderClass
    ].

    (aSuffix notNil and:[mimeType notNil]) ifTrue:[
        self mimeTypeForSuffix:aSuffix put:mimeType
    ].
!

fileInfoForMimeType:mimeType
    "given a mimeType, return an info string similar to what the unix 'file' command
     provides. This info here is returned by systems which have no file (i.e. MSDOS) and
     for types of which file does not know about (smalltalk files, for example)"

    TypeToInfoMapping isNil ifTrue:[
        self initializeFileInfoMappings
    ].

    ^ TypeToInfoMapping at:mimeType ifAbsent:nil

    "
     self fileInfoForMimeType:(MIMEType fromString:'image/gif')     
    "
!

fileSuffixToImageReaderMapping
    "return the suffix-to-imageReader mapping"

    ^ FileSuffixToImageReaderClassMapping ? #()

    "Modified: / 1.8.1998 / 17:00:11 / cg"
!

imageFileSuffixes
    "return a collection with known file suffixes"

    FileSuffixToImageReaderClassMapping isNil ifTrue:[^ #()].
    ^ FileSuffixToImageReaderClassMapping keys

    "Created: / 30.6.1997 / 22:04:48 / cg"
    "Modified: / 1.8.1998 / 17:01:26 / cg"
!

mimeTypeForFilename:filenameOrString
    "given a filename, return the mime-type or nil, if unknown"

    |type filename lcFilename suff suff2|

    filename := filenameOrString asFilename.

    lcFilename := filename baseName asLowercase.
    type := FilenameToTypeMapping at:lcFilename ifAbsent:nil.
    type isNil ifTrue:[
        "/ allow for fallback ...
        type := OperatingSystem mimeTypeForFilename:lcFilename.
        "/ the special value #unknown is returned as nil;
        "/ this avoids constant retry if a mimeType is not known in
        "/ the OS.
"/        type isNil ifTrue:[
"/            FilenameToTypeMapping at:lcFilename put:#unknown
"/        ].
    ].

    type == #unknown ifTrue:[
        type := nil.
    ].

    type isNil ifTrue:[
        suff := filename suffix.
        suff size ~~ 0 ifTrue:[
            "/ sigh - special code for multiple-suffices...
            "/ .tar.gz -> tgz
            suff2 := filename withoutSuffix suffix.
            suff2 size > 0 ifTrue:[
                type := self mimeTypeForSuffix:(suff2 , '.' , suff).
            ].
            type isNil ifTrue:[
                type := self mimeTypeForSuffix:suff
            ].
        ]
    ].

    ^ type

    "
     MIMETypes mimeTypeForFilename:'typeinst.dvi'      
     MIMETypes mimeTypeForFilename:'foo.tar'
     MIMETypes mimeTypeForFilename:'foo.tgz'
     MIMETypes mimeTypeForFilename:'foo.tar.gz'
     MIMETypes mimeTypeForFilename:'foo.txt'   
     MIMETypes mimeTypeForFilename:'foo.pkg'   
    "

    "Modified: / 10-05-2011 / 11:55:18 / cg"
    "Modified (format): / 28-07-2012 / 09:39:15 / cg"
!

mimeTypeForFilename:filename put:mimeType
    "register a mime type for a filename"

    FilenameToTypeMapping isNil ifTrue:[
        FilenameToTypeMapping := Dictionary new
    ].
    FilenameToTypeMapping at:filename put:(MIMEType fromString:mimeType asLowercase)
!

mimeTypeForSuffix:suffix
    "given a file suffix, return the mime-type"

    |type lcSuffix|

    suffix = LastSuffix ifTrue:[
        ^ LastType
    ].

    lcSuffix := suffix asLowercase.
    type := FileSuffixToTypeMapping at:lcSuffix ifAbsent:nil.
    type isNil ifTrue:[
        "/ allow for fallback ...
        type := OperatingSystem mimeTypeForSuffix:lcSuffix.
        "/ the special value #unknown is returned as nil;
        "/ this avoids constant retry if a mimeType is not known in the OS.

        type := type ? #unknown.
        FileSuffixToTypeMapping at:lcSuffix put:type.
    ].

    type == #unknown ifTrue:[
        type := nil.
    ].
    type notNil ifTrue:[
        LastSuffix := suffix.
        LastType := MIMEType fromString:type.
        ^ LastType
    ].
    ^ type

    "
     self mimeTypeForSuffix:'gif'     
     self mimeTypeForSuffix:'rpm'     
     self mimeTypeForSuffix:'zip'     
    "

    "Created: / 30-06-1997 / 21:55:51 / cg"
    "Modified: / 14-02-2011 / 17:14:34 / cg"
!

mimeTypeForSuffix:suffix put:mimeType
    "register a mime type for a file suffix"

    FileSuffixToTypeMapping isNil ifTrue:[
        FileSuffixToTypeMapping := Dictionary new
    ].
    FileSuffixToTypeMapping at:suffix put:mimeType asLowercase

    "Created: / 30.6.1997 / 21:56:20 / cg"
    "Modified: / 1.8.1998 / 17:03:18 / cg"
!

mimeTypeForSuffixMapping

    ^ FileSuffixToTypeMapping
!

mimeTypeFromString:mimeTypeString
    "given a mime-type for a string"

     ^ MIMEType fromString:mimeTypeString

    "
     MIMETypes mimeTypeFromString:'text/html' 
     MIMETypes mimeTypeFromString:'image/gif' 
     MIMETypes mimeTypeFromString:'application/x-expecco-testsuite' 
    "
!

mimeTypeOfContents:filename
    "given a filename, scan the contents, return the mime-type or nil, if unknown"

    |typeString|

    typeString := filename mimeTypeOfContents.
    typeString isNil ifTrue:[^ nil].
    ^ MIMEType fromString:typeString.
!

mimeTypeOfData:someData
    "this tries to guess the mime type of contents of someData.
     Returns nil, if unknown.
     This is done using some heuristics, and may need some improvement"

    ^ self mimeTypeOfData:someData suffix:nil
!

mimeTypeOfData:someData suffix:fileNameSuffixOrNilIfUnknown
    "this tries to guess the mime type of contents of someData.
     Returns nil, if unknown.
     In addition to registered detectors (see addMimeTypeDetector:),
     this is done using some heuristics, and may need some improvement"

    |buffer lcBuffer size idx idx2|

    someData isEmptyOrNil ifTrue:[^ nil].

    TypeFromContentsDetectors notNil ifTrue:[
        TypeFromContentsDetectors do:[:eachDetector |
            |m|
            
            m := eachDetector value:someData value:fileNameSuffixOrNilIfUnknown.
            m notNil ifTrue:[^ m]
        ]
    ].    
    
    size := 2048 min:someData size.

    "/ read some data from the file ...
    buffer := (someData copyTo:size) asString.

    lcBuffer := buffer asLowercase.

    (idx := lcBuffer findString:'mimetype:') ~~ 0 ifTrue:[
        idx := idx + 'mimetype:' size.
        idx := lcBuffer indexOfNonSeparatorStartingAt:idx.
        idx2 := lcBuffer indexOfSeparatorStartingAt:idx.
        idx2 > idx ifTrue:[
            ^ MIMEType fromString:(lcBuffer copyFrom:idx to:idx2-1)
        ].
    ].

    "/ real starters
    #(
        ( #[16r4C 16r00 16r00 16r00 16r01 16r14 16r02 16r00 16r00 16r00 16r00 16r00 16rC0 16r00 16r00 16r00 16r00 16r00 16r00 16r46] 
                #'application/x-ms-shortcut' )
        ( 'ITOLITLS' 
                #'application/x-ms-reader' )
        ( 'WALTOP' 
                #'application/x-waltop-digital-notepad' )
        ('PK'                       
                #'application/x-zip-compressed')
        ('<?xml'                       
                #'text/xml')
     ) pairsDo:[:pattern :what |
        |patternString|

        patternString := pattern asString.
        (buffer startsWith:patternString) ifTrue:[
            what = #'application/x-zip-compressed' ifTrue:[
                fileNameSuffixOrNilIfUnknown = 'jar' ifTrue:[
                    ^ MIMEType fromString: #'application/java-archive'
                ].
            ].
            ^ MIMEType fromString:what
        ]
    ].

    "/ somewhere near the beginning
    #(
            ('<body:'                   #'text/html')
            ('%!!ps-adobe'               #'application/postscript')
            ('%PDF-'                    #'application/pdf')
            ('#!! /bin/sh'               #'application/x-sh')
            ('#!!/bin/sh'                #'application/x-sh')
            "/ ('#!! /bin/bash'              'application/x-bash')
            "/ ('#!!/bin/bash'               'application/x-bash')
            ('UNB+UNO'                  #'application/EDIFACT')

            ('---- encoding: '          #'application/x-smalltalk-source')
            ('---- timestamp '          #'application/x-smalltalk-source')
            ('from dolphin'             #'application/x-smalltalk-source')
            ('from visualworks'         #'application/x-smalltalk-source')
            ('from squeak'              #'application/x-smalltalk-source')
            ('from smalltalk/x'         #'application/x-smalltalk-source')
            ('"{ Package:'              #'application(x-smalltalk-source')
            ('categoriesforclass'       #'application/x-smalltalk-source')
            ('methodsfor!!'              #'application/x-smalltalk-source')
            ('subclass:'                #'application/x-smalltalk-source')
            ('methodsfor:'              #'application/x-smalltalk-source')
            ('interchangeversion:'      #'application/x-smalltalk-source-sif')
            ('subclass:'                #'application/x-smalltalk-source')
            ('methodsfor:'              #'application/x-smalltalk-source')
            ('Application create:'      #'application/x-smalltalk-source')
            ('becomeDefault!!'           #'application/x-smalltalk-source')
            ('(reader defineClass:'     #'application/x-smalltalk-source')      "/ gravel smalltalk

    ) pairsDo:[:pattern :what | 
        (lcBuffer findString:pattern) ~~ 0 ifTrue:[
            ^ MIMEType fromString:what
        ]
    ].
    
    (idx := lcBuffer findString:'<h') ~~ 0 ifTrue:[
        ((lcBuffer continuesWith:'<head' startingAt:idx)
        or:[(lcBuffer continuesWith:'<html' startingAt:idx)
        or:[(lcBuffer continuesWith:'<h1' startingAt:idx)
        or:[(lcBuffer continuesWith:'<h2' startingAt:idx)
        or:[(lcBuffer continuesWith:'<h3' startingAt:idx)
        or:[(lcBuffer continuesWith:'<h4' startingAt:idx)
        or:[(lcBuffer continuesWith:'<h5' startingAt:idx)
        or:[(lcBuffer continuesWith:'<h6' startingAt:idx)]]]]]]])
        ifTrue:[
            ^ MIMEType fromString:'text/html'
        ]
    ].

    [size ~~ 0 and:[(buffer at:size) isPrintable]] whileTrue:[size := size - 1].

    size == 0 ifTrue:[
        ^ MIMEType fromString:'text/plain'
    ].
    ^ nil

    "Modified: / 12-07-2011 / 19:08:17 / cg"
!

suffixForMimeType:mimeType
    "given a file suffix, return the mime-type"

    ^ TypeToFileSuffixMapping at:mimeType ifAbsent:nil

    "
     self suffixForMimeType:(MIMEType fromString:'image/gif')     
    "

    "Created: / 30.6.1997 / 21:55:51 / cg"
    "Modified: / 23.12.1999 / 22:30:55 / cg"
!

suffixForMimeTypeString:mimeTypeString
    "given a file suffix, return the mime-type"

     ^ self suffixForMimeType:(MIMEType fromString:mimeTypeString) 

    "
     self suffixForMimeTypeString:'image/gif' 
    "

    "Created: / 30.6.1997 / 21:55:51 / cg"
    "Modified: / 23.12.1999 / 22:30:55 / cg"
! !

!MIMETypes class methodsFor:'queries-applications'!

defaultCommandPerMIME
    "returns the collection which is used to map MIME-type to command-templates."

    "TODO: move this to OS/UserPreferences"

    DefaultCommandPerMIMEPerOS isNil ifTrue:[
        self initializeDefaultCommands
    ].
    OperatingSystem isUNIXlike ifTrue:[
        ^ DefaultCommandPerMIMEPerOS at:#unix
    ].
    ^ DefaultCommandPerMIMEPerOS at:#win32

    "
     MIMETypes defaultCommandPerMIME
    "

    "Modified (comment): / 16-09-2011 / 16:20:12 / cg"
!

defaultCommandTemplateToOpenMimeType:mimeType
    |cmd|

    cmd := self defaultCommandPerMIME at:mimeType ifAbsent:nil.
    cmd isNil ifTrue:[
        OperatingSystem isMSWINDOWSlike ifTrue:[
            cmd := Win32OperatingSystem::RegistryEntry commandTemplateToOpenMimeType:mimeType
        ].
    ].
    ^ cmd

    "
     MIMETypes defaultCommandTemplateToOpenMimeType:'application/pdf'
     MIMETypes defaultCommandTemplateToOpenMimeType:'text/html'
    "

    "Created: / 12-05-2004 / 11:09:22 / cg"
    "Modified: / 12-05-2004 / 11:16:53 / cg"
!

defaultCommandTemplateToPrintMimeType:mimeType
    |cmd|

    cmd := self defaultPrintCommandPerMIME at:mimeType ifAbsent:nil.
    cmd isNil ifTrue:[
        OperatingSystem isMSWINDOWSlike ifTrue:[
            cmd := Win32OperatingSystem::RegistryEntry commandTemplateToPrintMimeType:mimeType
        ].
    ].
    ^ cmd

    "
     MIMETypes defaultCommandTemplateToPrintMimeType:'application/pdf'
    "
!

defaultPrintCommandPerMIME
    "returns the collection which is used to map MIME-type to printing command-templates."

    "TODO: move this to OS/UserPreferences"

    DefaultPrintCommandPerMIMEPerOS isNil ifTrue:[
        self initializeDefaultCommands
    ].
    OperatingSystem isUNIXlike ifTrue:[
        ^ DefaultPrintCommandPerMIMEPerOS at:#unix
    ].
    ^ DefaultPrintCommandPerMIMEPerOS at:#win32
! !

!MIMETypes class methodsFor:'queries-image formats'!

imageReaderClasses
    "return a collection of registered image reader classes"

    |setOfClasses|

    setOfClasses := IdentitySet new.
    FileSuffixToImageReaderClassMapping notNil ifTrue:[
        FileSuffixToImageReaderClassMapping keysAndValuesDo:[:suff :cls |
            setOfClasses add:cls
        ].
    ].
    TypeToImageReaderClassMapping notNil ifTrue:[
        TypeToImageReaderClassMapping keysAndValuesDo:[:suff :cls |
            setOfClasses add:cls
        ].
    ].
    ^ setOfClasses

    "Created: / 30.6.1997 / 22:03:42 / cg"
    "Modified: / 1.8.1998 / 16:59:52 / cg"
!

imageReaderForSuffix:aSuffix
    "given a file suffix, return an approriate image reader class"

    FileSuffixToImageReaderClassMapping isNil ifTrue:[
        self initializeImageReaderMappings
    ].
    ^ FileSuffixToImageReaderClassMapping at:aSuffix asLowercase ifAbsent:nil

    "Created: / 30.6.1997 / 21:59:11 / cg"
    "Modified: / 1.8.1998 / 17:01:58 / cg"
!

imageReaderForSuffix:aSuffix put:aReaderClass
    "register an image reader for a file suffix"

    FileSuffixToImageReaderClassMapping isNil ifTrue:[
        self initializeImageReaderMappings
    ].
    FileSuffixToImageReaderClassMapping at:aSuffix asLowercase put:aReaderClass

    "Created: / 30.6.1997 / 21:59:43 / cg"
    "Modified: / 1.8.1998 / 17:02:14 / cg"
!

imageReaderForType:mimeTypeString
    "given a mime-type, return an approriate image reader class"

    TypeToImageReaderClassMapping isNil ifTrue:[
        self initializeImageReaderMappings
    ].
    ^ TypeToImageReaderClassMapping at:mimeTypeString asLowercase ifAbsent:nil

    "Created: / 30.6.1997 / 21:56:01 / cg"
    "Modified: / 1.8.1998 / 17:02:28 / cg"
!

imageReaderForType:mimeTypeString put:aReaderClass
    "register an image reader for a mime-type"

    TypeToImageReaderClassMapping isNil ifTrue:[
        self initializeImageReaderMappings
    ].
    TypeToImageReaderClassMapping at:mimeTypeString asLowercase put:aReaderClass

    "Created: / 30.6.1997 / 21:56:11 / cg"
    "Modified: / 1.8.1998 / 17:02:40 / cg"
! !

!MIMETypes class methodsFor:'queries-language syntax'!

commentStringsForFilename:aFilename
    "return a useful comment definition; heuristics for now.
     The returned value is an array of 2 elements;
     the first is the end-of-line comment string (or nil);
     the second an array of opening/closing delimiters (or an array of nils)"

     |mime|

     mime := MIMETypes mimeTypeForFilename:aFilename.
     ^ self commentStringsForMimeType:mime suffix:(aFilename asFilename suffix)

    "
     MIMETypes commentStringsForFilename:'Makefile'.
     MIMETypes commentStringsForFilename:'Object.st'. 
     MIMETypes commentStringsForFilename:'Foo.java'. 
     MIMETypes commentStringsForFilename:'Foo.html'. 
    "
!

commentStringsForFilename:aFilename ifUnknown:alternativeBlockReturningCommentString
    "return a useful comment definition; heuristics for now.
     The returned value is an array of 2 elements;
     the first is the end-of-line comment string (or nil);
     the second an array of opening/closing delimiters (or an array of nils)"

     |mime|

     mime := MIMETypes mimeTypeForFilename:aFilename.
     ^ self commentStringsForMimeType:mime suffix:(aFilename asFilename suffix) ifUnknown:alternativeBlockReturningCommentString

    "
     MIMETypes commentStringsForFilename:'Makefile'.
     MIMETypes commentStringsForFilename:'Object.st'. 
     MIMETypes commentStringsForFilename:'Foo.java'. 
    "
!

commentStringsForMimeType:mime suffix:suff
    "return a useful comment definition; heuristics for now.
     The returned value is an array of 2 elements;
     the first is the end-of-line comment string (or nil);
     the second an array of opening/closing delimiters (or an array of nils)"

    ^ self
        commentStringsForMimeType:mime suffix:suff 
        ifUnknown: #(';' (nil nil))  

    "
     |mime|

     mime := MIMETypes mimeTypeForFilename:'Makefile'.
     MIMETypes commentStringsForMimeType:mime suffix:nil.     
    "

    "
     |mime|

     mime := MIMETypes mimeTypeForFilename:'Object.st'.
     MIMETypes commentStringsForMimeType:mime suffix:nil.    
    "
!

commentStringsForMimeType:mime suffix:suff ifUnknown:alternativeBlockReturningCommentString
    "return a useful comment definition; heuristics for now.
     The returned value is an array of 2 elements;
     the first is the end-of-line comment string (or nil);
     the second an array of opening/closing delimiters (or an array of nils)"

    |commentSpec|

    commentSpec := TypeToCommentStringMapping at:mime ifAbsent:nil.
    commentSpec notNil ifTrue:[
        ^ commentSpec
    ].
    suff notNil ifTrue:[
        commentSpec := SuffixToCommentStringMapping at:suff ifAbsent:nil.
        commentSpec notNil ifTrue:[
            ^ commentSpec
        ].
    ].
    ^ alternativeBlockReturningCommentString value

    "
     |mime|

     mime := MIMETypes mimeTypeForFilename:'Makefile'.
     MIMETypes commentStringsForMimeType:mime suffix:nil.     
    "

    "
     |mime|

     mime := MIMETypes mimeTypeForFilename:'Object.st'.
     MIMETypes commentStringsForMimeType:mime suffix:nil.    
    "
!

parenthesisSpecForFilename:aFilename
    "return a useful parentesis spec; heuristics for now.
     The returned value is a dictionary to be used as parentesis spec in an editor"

     |mime|

     mime := MIMETypes mimeTypeForFilename:aFilename.
     ^ self parenthesisSpecForMimeType:mime suffix:(aFilename asFilename suffix)

    "
     MIMETypes parenthesisSpecForFilename:'Object.st'. 
     MIMETypes parenthesisSpecForFilename:'Foo.java'. 
     MIMETypes parenthesisSpecForFilename:'Foo.html'. 
     MIMETypes parenthesisSpecForFilename:'Foo.lsp'. 
    "

    "Created: / 10-04-2007 / 15:18:41 / cg"
!

parenthesisSpecForFilename:aFilename ifUnknown:alternative
     |mime|

     mime := MIMETypes mimeTypeForFilename:aFilename.
     ^ self parenthesisSpecForMimeType:mime suffix:(aFilename asFilename suffix) ifUnknown:alternative

    "Created: / 10-04-2007 / 15:26:20 / cg"
!

parenthesisSpecForMimeType:mime suffix:suff
    ^ self
        parenthesisSpecForMimeType:mime suffix:suff 
        ifUnknown: nil

    "Created: / 10-04-2007 / 15:19:39 / cg"
!

parenthesisSpecForMimeType:mime suffix:suff ifUnknown:alternativeValue
    |spec|

    spec := TypeToParenthesisSpecMapping at:mime ifAbsent:nil.
    spec notNil ifTrue:[
        ^ spec
    ].

    spec := SuffixToParenthesisSpecMapping at:suff ifAbsent:nil.
    spec notNil ifTrue:[
        ^ spec
    ].

    ^ alternativeValue value

    "Created: / 10-04-2007 / 15:20:38 / cg"
! !

!MIMETypes::MIMEType class methodsFor:'documentation'!

documentation
"
    like a string, but knows that it represents a mimeType.
    mimetypes are singletons, remembered in the class variable CachedTypes.
"
! !

!MIMETypes::MIMEType class methodsFor:'instance creation'!

fromString:aString
    |cachedType newType|

    aString class == self ifTrue:[^ aString].

    CachedTypes isNil ifTrue:[
        CachedTypes := Dictionary new:100.
    ].
    cachedType := CachedTypes at:aString ifAbsent:nil.
    cachedType notNil ifTrue:[^ cachedType].

    newType := aString copy changeClassTo:self.
    CachedTypes at:aString put:newType.
    ^ newType

    "
     self fromString:'text/html'
    "

    "Modified: / 20-07-2012 / 17:36:31 / cg"
! !

!MIMETypes::MIMEType methodsFor:'queries'!

fileTypeInfo
    ^ MIMETypes fileTypeInfoForMimeType:self

    "
     (MIMETypes mimeTypeFromString:'application/x-smalltalk-source') fileTypeInfo 
    "
!

isArchive
    <resource: #obsolete>
    "return true, if I represent an archive type (such as zip or tar)"

    ^ self isArchiveType
!

isArchiveType
    "return true, if I represent an archive type (such as zip or tar)"

    |archivTypes|

    archivTypes := MIMETypes applicationCompressorsAndArchiveTypeList.
    archivTypes pairWiseDo:[: ext : type |
        self = type ifTrue:[ ^ true].
    ].
    ^ false
!

isBinary
    <resource: #obsolete>
    "return true, if I represent a binary (non-text) type"

    ^ self isBinaryType
!

isBinaryType
    "return true, if I represent a binary (non-text) type"

    ^ self isTextType not
!

isHtml
    <resource: #obsolete>
    "return true, if I represent the html text type"

    ^ self isHtmlType
!

isHtmlType
    "return true, if I represent the html text type"

    ^ (self = 'text/html')
!

isImage
    <resource: #obsolete>
    "return true, if I represent an image type (such as gif or jpg)"

    ^ self isImageType
!

isImageType
    "return true, if I represent an image type (such as gif or jpg)"

    ^ (self startsWith:'image/')
!

isPdf
    <resource: #obsolete>
    "return true, if I represent the pdf type"

    ^ self isPdfType
!

isPdfType
    "return true, if I represent the pdf type"

    ^ (self = 'application/pdf')
!

isSmalltalkSource
    <resource: #obsolete>
    "return true, if I represent the smalltalk sourcecode type"

    ^ self isSmalltalkSourceType
!

isSmalltalkSourceType
    "return true, if I represent the smalltalk sourcecode type"

    ^ (self startsWith: 'application/x-smalltalk-source')
!

isTextType
    "return true, if I represent some text type"

    ^ self startsWith:'text/'
!

isXml
    <resource: #obsolete>
    "return true, if I represent the xml text type"

    ^ self isXmlType
!

isXmlType
    "return true, if I represent the xml text type"

    ^ (self = 'text/xml')
!

suffix
    ^ MIMETypes suffixForMimeType:self

    "
       (MIMETypes mimeTypeFromString:'application/x-expecco-testsuite') suffix 
    "
! !

!MIMETypes class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


MIMETypes initialize!
