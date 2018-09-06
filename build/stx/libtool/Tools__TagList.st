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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

List subclass:#TagList
	instanceVariableNames:'rawList filteredList filter tagsValidForFile sortCriteria groupBy
		showOnly flags tagTypesPresent usingDefaultCTags ctagsCommand
		ctagsIsExCtags ctagsIsExCtags5x remoteTarget'
	classVariableNames:'Sorted CachedTagListsPerFile DefaultSortCriteria DefaultShowOnly
		TagsSuffixes DefaultGroupBy'
	poolDictionaries:''
	category:'Interface-Tools-File-Tags'
!

!TagList class methodsFor:'documentation'!

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
!

documentation
"
    a list of tags as read & generated from parsing a source file.
    For some languages, naive parsing is supported right here;
    for other languages, external tools (ctags) are used.
    The tags are used bz the tagList or to navigate quickly to some
    function in the C-browser.
"
! !

!TagList class methodsFor:'accessing - suffixes'!

tagsSuffixes
"flush with:
TagsSuffixes := nil
"
    TagsSuffixes notNil ifTrue:[
        ^ TagsSuffixes
    ].
    TagsSuffixes := IdentityDictionary new.

    TagsSuffixes at:#'text/asm'                 put:#( 's' 'asm' ).
    TagsSuffixes at:#'text/c'                   put:#( 'c' 'h' 'ci' 'hi' 'sc' 'sth').
    TagsSuffixes at:#'text/cpp'                 put:#( 'cc' 'cpp' 'cxx' 'c++' 'hxx' 'hpp' 'h++').
    TagsSuffixes at:#'text/x-objcsrc'           put:#( 'm').
    TagsSuffixes at:#'text/eiffel'              put:#( 'e' 'eif' ).
    TagsSuffixes at:#'text/fortran'             put:#( 'f' 'for' 'ftn' 'f77' 'f90' ).
    TagsSuffixes at:#'text/html'                put:#( 'htm' 'html').
    TagsSuffixes at:#'text/java'                put:#( 'java' 'jav' 'j').
    TagsSuffixes at:#'text/javaScript'          put:#( 'js' ).
    TagsSuffixes at:#'text/javascript'          put:#( 'js' ).
    TagsSuffixes at:#'application/x-javascript' put:#( 'js' ).
    TagsSuffixes at:#'text/dart'                put:#( 'dart' ).
    TagsSuffixes at:#'application/x-dart'       put:#( 'dart' ).
    TagsSuffixes at:#'text/make'                put:#( 'makefile' 'make.proto' 'makefile.*' '*.mak' '*.bpr').
    TagsSuffixes at:#'text/prolog'              put:#( 'pl' ).
    TagsSuffixes at:#'text/python'              put:#( 'py' ).
    TagsSuffixes at:#'text/php'                 put:#( 'php' ).
    TagsSuffixes at:#'text/lisp'                put:#( 'lisp' 'el' 'lsp' 'cl').
    TagsSuffixes at:#'text/lisp-arc'            put:#( 'arc' ).
    TagsSuffixes at:#'text/scheme'              put:#( 'scm' 'ss' 'brg').
    TagsSuffixes at:#'text/oz'                  put:#( 'oz').
    TagsSuffixes at:#'text/lua'                 put:#( 'lua').
    TagsSuffixes at:#'text/smalltalk'           put:#( 'st' 'ST' 'St' 'Prj').
    TagsSuffixes at:#'text/tcl'                 put:#( 'tcl' ).
    TagsSuffixes at:#'text/ruby'                put:#( 'rb' ).
    TagsSuffixes at:#'text/yacc'                put:#( 'y' ).
    TagsSuffixes at:#'text/batch'               put:#( 'bat' ).
    TagsSuffixes at:#'text/xml-xsd'             put:#( 'xsd' ).
    ^ TagsSuffixes

    "Modified: / 28-09-2012 / 14:48:25 / cg"
! !

!TagList class methodsFor:'defaults'!

arcLispSuffixes
    "returns a list of supported arc-lisp-suffixes"

    ^ self tagsSuffixes at:#'text/lisp-arc'
!

assemblerSuffixes
    "returns a list of supported assembler-suffixes"

    ^ self tagsSuffixes at:#'text/asm'
!

batchSuffixes
    "returns a list of supported batchfile-suffixes
    "
    ^ self tagsSuffixes at:#'text/batch'

    "Created: / 28-09-2012 / 14:48:41 / cg"
!

cPlusPlusSuffixes
    "returns a list of supported c-suffixes"

    ^ self tagsSuffixes at:#'text/cpp'
!

cSuffixes
    "returns a list of supported c-suffixes"

    ^ self tagsSuffixes at:#'text/c'
!

commonLispSuffixes
    "returns a list of supported common-lisp-suffixes"

    ^ self tagsSuffixes at:#'text/lisp'
!

dartSuffixes
    "returns a list of supported dart-suffixes"

    ^ self tagsSuffixes at:#'text/dart'

    "Created: / 22-08-2012 / 21:01:32 / cg"
!

eiffelSuffixes
    "returns a list of supported eiffel-suffixes
    "
    ^ self tagsSuffixes at:#'text/eiffel'
!

fortranSuffixes
    "returns a list of supported fortran-suffixes
    "
    ^ self tagsSuffixes at:#'text/fortran'
!

htmlSuffixes
    "returns a list of supported html-suffixes
    "
    ^ self tagsSuffixes at:#'text/html'

    "Created: / 20-04-2011 / 19:03:39 / cg"
!

isTagSearchableSuffix:aSuffix
    "returns true, if aSuffix looks ok for ctags
    "
    self tagsSuffixes keysAndValuesDo:[:tag :suffixes |
        (suffixes includes:aSuffix) ifTrue:[^ true].
    ].
"/    (self cSuffixes includes:aSuffix) ifTrue:[^ true].
"/    (self javaSuffixes includes:aSuffix) ifTrue:[^ true].
"/    (self fortranSuffixes includes:aSuffix) ifTrue:[^ true].
"/    (self eiffelSuffixes includes:aSuffix) ifTrue:[^ true].
"/    (self commonLispSuffixes includes:aSuffix) ifTrue:[^ true].
"/    (self schemeSuffixes includes:aSuffix) ifTrue:[^ true].
    ^ false
!

javaScriptSuffixes
    "returns a list of supported javaScript-suffixes"

    ^ self tagsSuffixes at:#'text/javaScript'

    "Created: / 28-06-2010 / 12:44:58 / cg"
!

javaSuffixes
    "returns a list of supported java-suffixes
    "
    ^ self tagsSuffixes at:#'text/java'
!

luaSuffixes
    "returns a list of supported lua-suffixes
    "
    ^ self tagsSuffixes at:#'text/lua'
!

makeFilePatterns
    "returns a list of makefile match patterns
    "
    ^ self tagsSuffixes at:#'text/make'
!

objcSuffixes
    "returns a list of supported c-suffixes"

    ^ self tagsSuffixes at:#'text/x-objcsrc'
!

ozSuffixes
    "returns a list of supported oz-suffixes
    "
    ^ self tagsSuffixes at:#'text/oz'
!

phpSuffixes
    "returns a list of supported php-suffixes"

    ^ self tagsSuffixes at:#'text/php'
!

pltSchemeLispSuffixes
    ^ #('plt')

    "Created: / 21-10-2011 / 09:32:20 / cg"
!

prologSuffixes
    "returns a list of supported prolog-suffixes
    "
    ^ self tagsSuffixes at:#'text/prolog'
!

pythonSuffixes
    "returns a list of supported python-suffixes
    "
    ^ self tagsSuffixes at:#'text/python'
!

racketSchemeLispSuffixes
    ^ #('rkt')

    "Created: / 21-10-2011 / 09:32:27 / cg"
!

rubySuffixes
    "returns a list of supported ruby-suffixes
    "
    ^ self tagsSuffixes at:#'text/ruby'
!

schemeSuffixes
    "returns a list of supported scheme-lisp-suffixes
    "
    ^ self tagsSuffixes at:#'text/scheme'
!

smalltalkSuffixes
    "returns a list of supported smalltalk-suffixes
    "
    ^ self tagsSuffixes at:#'text/smalltalk'
!

tclSuffixes
    "returns a list of supported tcl-suffixes
    "
    ^ self tagsSuffixes at:#'text/tcl'
!

xsdSuffixes
    "returns a list of supported xsd-suffixes
    "
    ^ self tagsSuffixes at:#'text/xml-xsd'
!

yaccSuffixes
    "returns a list of supported yacc-suffixes
    "
    ^ self tagsSuffixes at:#'text/yacc'
! !

!TagList class methodsFor:'queries'!

isArcLispSuffix:suffix
    ^ self isSuffix:suffix in:self arcLispSuffixes
!

isAssemblerSuffix:suffix
    ^ self isSuffix:suffix in:self assemblerSuffixes
!

isBatchSuffix:suffix
    ^ self isSuffix:suffix in:self batchSuffixes

    "Created: / 28-09-2012 / 14:47:43 / cg"
!

isCOrCPlusPlusSuffix:suffix
    ^ (self isCSuffix:suffix) or:[self isCPlusPlusSuffix:suffix]
!

isCPlusPlusSuffix:suffix
    ^ self isSuffix:suffix in:self cPlusPlusSuffixes
!

isCSuffix:suffix
    ^ self isSuffix:suffix in:self cSuffixes
!

isCommonLispSuffix:suffix
    ^ self isSuffix:suffix in:self commonLispSuffixes
!

isDartSuffix:suffix
    ^ self isSuffix:suffix in:self dartSuffixes

    "Created: / 22-08-2012 / 21:01:10 / cg"
!

isEiffelSuffix:suffix
    ^ self isSuffix:suffix in:self eiffelSuffixes
!

isFortranSuffix:suffix
    ^ self isSuffix:suffix in:self fortranSuffixes
!

isHTMLSuffix:suffix
    ^ self isSuffix:suffix in:self htmlSuffixes

    "Created: / 20-04-2011 / 19:03:26 / cg"
!

isJavaScriptSuffix:suffix
    ^ self isSuffix:suffix in:self javaScriptSuffixes

    "Created: / 28-06-2010 / 12:44:47 / cg"
!

isJavaSuffix:suffix
    ^ self isSuffix:suffix in:self javaSuffixes
!

isLispSuffix:suffix
    ^ (self isCommonLispSuffix:suffix) 
    or:[(self isSchemeSuffix:suffix)
    or:[(self isArcLispSuffix:suffix)
    or:[(self isPltSchemeLispSuffix:suffix)
    or:[(self isRacketSchemeLispSuffix:suffix)]]]]

    "Modified: / 21-10-2011 / 09:31:30 / cg"
!

isLuaSuffix:suffix
    ^ self isSuffix:suffix in:self luaSuffixes
!

isMakefileName:fileName
    |lcName|

    lcName := fileName asFilename baseName asLowercase.
    self makeFilePatterns do:[:aPattern |
        (aPattern match:lcName) ifTrue:[ ^ true ].
    ].
    ^ false
!

isObjcSuffix:suffix
    ^ self isSuffix:suffix in:self objcSuffixes
!

isOzSuffix:suffix
    ^ self isSuffix:suffix in:self ozSuffixes
!

isPhpSuffix:suffix
    ^ self isSuffix:suffix in:self phpSuffixes
!

isPltSchemeLispSuffix:suffix
    ^ self isSuffix:suffix in:self pltSchemeLispSuffixes

    "Created: / 21-10-2011 / 09:30:56 / cg"
!

isPrologSuffix:suffix
    ^ self isSuffix:suffix in:self prologSuffixes
!

isPythonSuffix:suffix
    ^ self isSuffix:suffix in:self pythonSuffixes
!

isRacketSchemeLispSuffix:suffix
    ^ self isSuffix:suffix in:self racketSchemeLispSuffixes

    "Created: / 21-10-2011 / 09:31:04 / cg"
!

isRubySuffix:suffix
    ^ self isSuffix:suffix in:self rubySuffixes
!

isSchemeSuffix:suffix
    ^ self isSuffix:suffix in:self schemeSuffixes
!

isSmalltalkSuffix:suffix
    ^ self isSuffix:suffix in:self smalltalkSuffixes
!

isTCLSuffix:suffix
    ^ self isSuffix:suffix in:self tclSuffixes
!

isXSDSuffix:suffix
    ^ self isSuffix:suffix in:self xsdSuffixes
!

isYaccSuffix:suffix
    ^ self isSuffix:suffix in:self yaccSuffixes
! !

!TagList class methodsFor:'queries basic'!

isSuffix:suffix in:patterns
    |lcSuffix|

    lcSuffix := suffix asLowercase.
    ^ patterns contains:[:pattern | pattern match:lcSuffix].
!

tagMimeTypeForFile:aFile
    "returns the tag-mimetype for a file or nil
    "
    |suff file list name mimeMake|

    aFile isNil ifTrue:[^ nil].

    file := aFile asFilename.
    suff := file suffix.

    suff size ~~ 0 ifTrue:[
        suff := suff asLowercase.

        (suff = 'bak' or:[suff = 'sav']) ifTrue:[
            file := file asFilename withoutSuffix.
            suff := file suffix.
            suff size ~~ 0 ifTrue:[
                suff := suff asLowercase
            ]
        ]
    ].
    list := self tagsSuffixes.

    " hack to test for make-file patterns "
    name := file baseName asLowercase.
    mimeMake := #'text/make'.

    ((list at:mimeMake) contains:[:pattern | pattern match:name]) ifTrue:[
        ^ mimeMake
    ].

    self tagsSuffixes keysAndValuesDo:[:mimeType :suffixes|
        (suffixes includes:suff) ifTrue:[ 
            ^ mimeType 
        ]
    ].
    ^ aFile asFilename mimeTypeOfContents
    "/ ^ nil
! !

!TagList class methodsFor:'tag generation'!

cachedTagsFromFile:aFilename in:aTempDirectory
    "retrieve a cached tagList for a file"

    |tagList cached fileTime suffix|

    fileTime := aFilename modificationTime.

    CachedTagListsPerFile isNil ifTrue:[
        CachedTagListsPerFile := Dictionary new.
    ].
    cached := CachedTagListsPerFile at:aFilename ifAbsent:nil.
    cached notNil ifTrue:[
        fileTime > cached tagTimestamp ifFalse:[
            ^ cached tagList
        ]
    ].
    suffix := aFilename suffix.

"/    ((self isCSuffix:suffix) 
"/    or:[(self isJavaSuffix:suffix)
"/    or:[(self isFortranSuffix:suffix)
"/    or:[(self isEiffelSuffix:suffix)]]])
"/    ifFalse:[
"/        ^ #()
"/    ].
    tagList := self new.
    tagList showOnly:nil.
    tagList fromFile:aFilename in:aTempDirectory.
    tagList do:[:eachTag | eachTag fileName:aFilename].

    CachedTagListsPerFile at:aFilename put:(CachedTags new tagList:tagList; tagTimestamp:fileTime; yourself).
    ^ tagList

    "Modified: / 07-06-2010 / 12:13:25 / cg"
!

cachedTagsFromFile:aFilename in:aTempDirectory buildTargetHandler:aTargetHandler remote:aBoolean
    "retrieve a cached tagList for a file"

    ^ self cachedTagsFromFile:aFilename in:aTempDirectory.
!

flushCachedTags
    CachedTagListsPerFile := nil

    "
     self flushCachedTags
    "
!

makeTargetTagsInFile:aMakefilePath
    "makefile tags:
     naive, q&d scan for lines ending with a colon
    "
    ^ self makeTargetTagsInFile:aMakefilePath filter:nil
!

makeTargetTagsInFile:aMakefilePath filter:showOnly
    "makefile tags:
     naive, q&d scan for lines ending with a colon
    "
    |targets|

    Tag autoload.

    targets := OrderedCollection new.
    aMakefilePath asFilename contents keysAndValuesDo:[:lnr :line |
        |idxColon idxAssign varName target|

        line size > 0 ifTrue:[
            line first isSeparator ifFalse:[
                (line startsWith:$#) ifFalse:[
                    idxAssign := line indexOf:$=.
                    idxAssign ~~ 0 ifTrue:[
                        showOnly ~~ #targets ifTrue:[
                            varName := line copyFrom:1 to:idxAssign - 1.
                            targets add:(Tag::TVariable 
                                            label:varName 
                                            pattern:('/^',varName,'=')
                                            type:nil
                                            lineNumber:lnr)
                        ]
                    ] ifFalse:[
                        idxColon := line indexOf:$:.
                        idxColon ~~ 0 ifTrue:[
                            target := line copyFrom:1 to:idxColon - 1.
                            "/ ignore macro-targets

                            (target includes:$$) ifFalse:[
                                (target startsWith:$.) ifFalse:[
                                    "/ normal targets
                                    targets add:(Tag::TMakeTarget 
                                                    label:target 
                                                    pattern:('/^',target,':')
                                                    type:nil
                                                    lineNumber:lnr)
                                ] ifTrue:[
                                    "/ rule-targets
                                    targets add:(Tag::TMakeRule 
                                                    label:target 
                                                    pattern:('/^',target,':')
                                                    type:nil
                                                    lineNumber:lnr)
                                ]
                            ] ifTrue:[
                                "/ rule-targets
                                targets add:(Tag::TMakeTarget 
                                                label:target 
                                                pattern:('/^',target,':')
                                                type:nil
                                                lineNumber:lnr)
                            ].
                        ]
                    ]
                ]
            ]
        ]
    ].
    ^ targets
! !

!TagList methodsFor:'accessing'!

tagTypesPresent:aBoolean
    tagTypesPresent := aBoolean.
! !

!TagList methodsFor:'accessing-filters'!

anchorsOnly
    ^ showOnly == #anchors
!

anchorsOnly:aBoolean
    showOnly := DefaultShowOnly := nil.
    aBoolean ifTrue:[
        showOnly := "DefaultShowOnly :=" #anchors
    ].

    "Created: / 08-05-2011 / 10:11:39 / cg"
!

classesFunctionsAndVariablesOnly
    ^ showOnly == #classesFunctionsAndVariables

    "Modified: / 07-06-2010 / 14:18:09 / cg"
!

classesFunctionsAndVariablesOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #classesFunctionsAndVariables
    ].

    "Modified: / 05-05-2011 / 15:21:53 / cg"
!

classesOnly
    ^ showOnly == #classes

    "Modified: / 07-06-2010 / 14:18:12 / cg"
!

classesOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #classes
    ].

    "Modified: / 05-05-2011 / 15:21:56 / cg"
!

dartClassesAndMethodsOnly
    ^ showOnly == #dartClassesAndMethods

    "Modified: / 07-06-2010 / 14:18:25 / cg"
!

dartClassesAndMethodsOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #dartClassesAndMethods
    ].

    "Modified: / 05-05-2011 / 15:23:25 / cg"
!

dartClassesOnly
    ^ showOnly == #dartClasses

    "Modified: / 07-06-2010 / 14:18:28 / cg"
!

dartClassesOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #dartClasses
    ].

    "Modified: / 05-05-2011 / 15:23:29 / cg"
!

dartMethodsOnly
    ^ showOnly == #dartMethods

    "Modified: / 07-06-2010 / 14:18:30 / cg"
!

dartMethodsOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #dartMethods
    ].

    "Modified: / 05-05-2011 / 15:23:31 / cg"
!

definesOnly
    ^ showOnly == #defines

    "Modified: / 07-06-2010 / 14:18:15 / cg"
!

definesOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #defines
    ].

    "Modified: / 05-05-2011 / 15:21:58 / cg"
!

documentationOnly
    ^ showOnly == #documentation

    "Created: / 08-05-2011 / 10:11:47 / cg"
!

documentationOnly:aBoolean
    showOnly := DefaultShowOnly := nil.
    aBoolean ifTrue:[
        showOnly := "DefaultShowOnly :=" #documentation
    ].

    "Created: / 08-05-2011 / 10:11:39 / cg"
!

filter:aStringOrNil
    (filter ? '') ~= (aStringOrNil ? '') ifTrue:[
        filter := aStringOrNil.       
        rawList notNil ifTrue:[
            self updateContentsFromRawList
        ].
    ].

    "Modified: / 05-05-2011 / 14:43:04 / cg"
!

flagNamed:aSymbol
    ^ flags at:aSymbol ifAbsent:false
!

flagNamed:aSymbol put:aBoolean
    flags at:aSymbol put:aBoolean
!

functionsAndVariablesOnly
    ^ showOnly == #functionsAndVariables

    "Modified: / 07-06-2010 / 14:18:05 / cg"
!

functionsAndVariablesOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #functionsAndVariables
    ].

    "Modified: / 05-05-2011 / 15:22:01 / cg"
!

functionsOnly
    ^ showOnly == #functions

    "Modified: / 07-06-2010 / 14:17:54 / cg"
!

functionsOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #functions
    ].

    "Modified: / 05-05-2011 / 15:22:03 / cg"
!

headlinesOnly
    ^ showOnly == #headlines
!

headlinesOnly:aBoolean
    showOnly := DefaultShowOnly := nil.
    aBoolean ifTrue:[
        showOnly := "DefaultShowOnly :=" #headlines
    ].
!

hideClasses
    ^ self flagNamed:#hideClasses
!

hideClasses:aBoolean
    self flagNamed:#hideClasses put:aBoolean

    "Modified: / 05-05-2011 / 15:22:08 / cg"
!

hideDartClasses
    ^ self flagNamed:#hideDartClasses
!

hideDartClasses:aBoolean
    self flagNamed:#hideDartClasses put:aBoolean

    "Modified: / 05-05-2011 / 15:22:32 / cg"
!

hideDartFields
    ^ self flagNamed:#hideDartFields
!

hideDartFields:aBoolean
    self flagNamed:#hideDartFields put:aBoolean

    "Modified: / 05-05-2011 / 15:22:34 / cg"
!

hideDartInterfaces
    ^ self flagNamed:#hideDartInterfaces
!

hideDartInterfaces:aBoolean
    self flagNamed:#hideDartInterfaces put:aBoolean

    "Modified: / 05-05-2011 / 15:22:38 / cg"
!

hideDartMethods
    ^ self flagNamed:#hideDartMethods
!

hideDartMethods:aBoolean
    self flagNamed:#hideDartMethods put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:40 / cg"
!

hideDartPackages
    ^ self flagNamed:#hideDartPackages 
!

hideDartPackages:aBoolean
    self flagNamed:#hideDartPackages put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:41 / cg"
!

hideDataLabels
    ^ self flagNamed:#hideDataLabels
!

hideDataLabels:aBoolean
    self flagNamed:#hideDataLabels put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:10 / cg"
!

hideDefines
    ^ self flagNamed:#hideDefines 
!

hideDefines:aBoolean
    self flagNamed:#hideDefines put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:12 / cg"
!

hideDocumentation
    ^ self flagNamed:#hideDocumentation

    "Created: / 08-05-2011 / 10:11:02 / cg"
!

hideDocumentation:aBoolean
    self flagNamed:#hideDocumentation put:aBoolean.

    "Created: / 08-05-2011 / 10:11:06 / cg"
!

hideFunctionProtoTypes
    ^ self flagNamed:#hideFunctionProtoTypes
!

hideFunctionProtoTypes:aBoolean
    self flagNamed:#hideFunctionProtoTypes put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:14 / cg"
!

hideFunctions
    ^ self flagNamed:#hideFunctions
!

hideFunctions:aBoolean
    self flagNamed:#hideFunctions put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:18 / cg"
!

hideHTMLHeaders
    ^ self flagNamed:#hideHTMLHeaders 

    "Created: / 12-09-2012 / 12:29:45 / cg"
!

hideHTMLHeaders:aBoolean
    self flagNamed:#hideHTMLHeaders put:aBoolean.

    "Created: / 12-09-2012 / 12:29:52 / cg"
!

hideHTMLInput
    ^ self flagNamed:#hideHTMLInput 

    "Created: / 20-04-2011 / 19:01:04 / cg"
!

hideHTMLInput:aBoolean
    self flagNamed:#hideHTMLInput put:aBoolean.

    "Created: / 20-04-2011 / 19:01:32 / cg"
    "Modified: / 05-05-2011 / 15:22:21 / cg"
!

hideHTMLScript
    ^ self flagNamed:#hideHTMLScript 

    "Created: / 20-04-2011 / 19:00:32 / cg"
!

hideHTMLScript:aBoolean
    self flagNamed:#hideHTMLScript put:aBoolean.

    "Created: / 20-04-2011 / 19:01:32 / cg"
    "Modified: / 05-05-2011 / 15:22:23 / cg"
!

hideHTMLTable
    ^ self flagNamed:#hideHTMLTable

    "Created: / 20-04-2011 / 19:01:23 / cg"
!

hideHTMLTable:aBoolean
    self flagNamed:#hideHTMLTable put:aBoolean.

    "Created: / 20-04-2011 / 19:01:48 / cg"
    "Modified: / 05-05-2011 / 15:22:26 / cg"
!

hideHTMLTextArea
    ^ self flagNamed:#hideHTMLTextArea 

    "Created: / 20-04-2011 / 19:00:55 / cg"
!

hideHTMLTextArea:aBoolean
    self flagNamed:#hideHTMLTextArea put:aBoolean.

    "Created: / 20-04-2011 / 19:01:58 / cg"
    "Modified: / 05-05-2011 / 15:22:28 / cg"
!

hideJavaClasses
    ^ self flagNamed:#hideJavaClasses 
!

hideJavaClasses:aBoolean
    self flagNamed:#hideJavaClasses put:aBoolean

    "Modified: / 05-05-2011 / 15:22:32 / cg"
!

hideJavaFields
    ^ self flagNamed:#hideJavaFields 
!

hideJavaFields:aBoolean
    self flagNamed:#hideJavaFields put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:34 / cg"
!

hideJavaInterfaces
    ^ self flagNamed:#hideJavaInterfaces 
!

hideJavaInterfaces:aBoolean
    self flagNamed:#hideJavaInterfaces put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:38 / cg"
!

hideJavaMethods
    ^ self flagNamed:#hideJavaMethods
!

hideJavaMethods:aBoolean
    self flagNamed:#hideJavaMethods put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:40 / cg"
!

hideJavaPackages
    ^ self flagNamed:#hideJavaPackages 
!

hideJavaPackages:aBoolean
    self flagNamed:#hideJavaPackages put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:41 / cg"
!

hideLabels
    ^ self flagNamed:#hideLabels 
!

hideLabels:aBoolean
    self flagNamed:#hideLabels put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:46 / cg"
!

hideLispConstants
    ^ self flagNamed:#hideLispConstants 
!

hideLispConstants:aBoolean
    self flagNamed:#hideLispConstants put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:46 / cg"
!

hideLispEvaluations
    ^ self flagNamed:#hideLispEvaluations 
!

hideLispEvaluations:aBoolean
    self flagNamed:#hideLispEvaluations put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:49 / cg"
!

hideLispMacros
    ^ self flagNamed:#hideLispMacros 
!

hideLispMacros:aBoolean
    self flagNamed:#hideLispMacros put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:50 / cg"
!

hideLispMethods
    ^ self flagNamed:#hideLispMethods 
!

hideLispMethods:aBoolean
    self flagNamed:#hideLispMethods put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:53 / cg"
!

hideLocalLabels
    ^ self flagNamed:#hideLocalLabels 
!

hideLocalLabels2
    ^ self flagNamed:#hideLocalLabels2 

    "Created: / 24-03-2012 / 23:23:15 / cg"
!

hideLocalLabels2:aBoolean
    self flagNamed:#hideLocalLabels2 put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:54 / cg"
    "Created: / 24-03-2012 / 23:23:20 / cg"
!

hideLocalLabels3
    ^ self flagNamed:#hideLocalLabels3 

    "Created: / 13-05-2012 / 11:12:37 / cg"
!

hideLocalLabels3:aBoolean
    self flagNamed:#hideLocalLabels3 put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:54 / cg"
    "Created: / 13-05-2012 / 11:12:42 / cg"
!

hideLocalLabels:aBoolean
    self flagNamed:#hideLocalLabels put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:54 / cg"
!

hideLuaFunctions
    ^ self flagNamed:#hideLuaFunctions
!

hideLuaFunctions:aBoolean
    self flagNamed:#hideLuaFunctions put:aBoolean
!

hideMethods
    ^ self flagNamed:#hideMethods 

    "Created: / 21-08-2012 / 21:02:24 / cg"
!

hideMethods:aBoolean
    self flagNamed:#hideMethods put:aBoolean.

    "Created: / 21-08-2012 / 21:01:38 / cg"
!

hideObjcClasses
    ^ self flagNamed:#hideObjcClasses 
!

hideObjcClasses:aBoolean
    self flagNamed:#hideObjcClasses put:aBoolean.
!

hideObjcMethods
    ^ self flagNamed:#hideObjcMethods 
!

hideObjcMethods:aBoolean
    self flagNamed:#hideObjcMethods put:aBoolean.
!

hideOzClasses
    ^ self flagNamed:#hideOzClasses 
!

hideOzClasses:aBoolean
    self flagNamed:#hideOzClasses put:aBoolean.

    "Modified: / 05-05-2011 / 15:22:58 / cg"
!

hideOzFunctions
    ^ self flagNamed:#hideOzFunctions
!

hideOzFunctions:aBoolean
    self flagNamed:#hideOzFunctions put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:00 / cg"
!

hideOzMethods
    ^ self flagNamed:#hideOzMethods 
!

hideOzMethods:aBoolean
    self flagNamed:#hideOzMethods put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:02 / cg"
!

hidePythonClasses
    ^ self flagNamed:#hidePythonClasses 
!

hidePythonClasses:aBoolean
    self flagNamed:#hidePythonClasses put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:05 / cg"
!

hidePythonFunctions
    ^ self flagNamed:#hidePythonFunctions 
!

hidePythonFunctions:aBoolean
    self flagNamed:#hidePythonFunctions put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:07 / cg"
!

hidePythonMethods
    ^ self flagNamed:#hidePythonMethods 
!

hidePythonMethods:aBoolean
    self flagNamed:#hidePythonMethods put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:09 / cg"
!

hideStatic
    ^ self flagNamed:#hideStatic 
!

hideStatic:aBoolean
    self flagNamed:#hideStatic put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:11 / cg"
!

hideStructMembers
    ^ self flagNamed:#hideStructMembers 
!

hideStructMembers:aBoolean
    self flagNamed:#hideStructMembers put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:15 / cg"
!

hideStructures
    ^ self flagNamed:#hideStructures
!

hideStructures:aBoolean
    self flagNamed:#hideStructures put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:17 / cg"
!

hideTextLabels
    ^ self flagNamed:#hideTextLabels 
!

hideTextLabels:aBoolean
    self flagNamed:#hideTextLabels put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:19 / cg"
!

hideTypedefs
    ^ self flagNamed:#hideTypedefs 
!

hideTypedefs:aBoolean
    self flagNamed:#hideTypedefs put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:21 / cg"
!

hideVariables
    ^ self flagNamed:#hideVariables 
!

hideVariables:aBoolean
    self flagNamed:#hideVariables put:aBoolean.

    "Modified: / 05-05-2011 / 15:23:23 / cg"
!

javaClassesAndMethodsOnly
    ^ showOnly == #javaClassesAndMethods

    "Modified: / 07-06-2010 / 14:18:25 / cg"
!

javaClassesAndMethodsOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #javaClassesAndMethods
    ].

    "Modified: / 05-05-2011 / 15:23:25 / cg"
!

javaClassesOnly
    ^ showOnly == #javaClasses

    "Modified: / 07-06-2010 / 14:18:28 / cg"
!

javaClassesOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #javaClasses
    ].

    "Modified: / 05-05-2011 / 15:23:29 / cg"
!

javaMethodsOnly
    ^ showOnly == #javaMethods

    "Modified: / 07-06-2010 / 14:18:30 / cg"
!

javaMethodsOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #javaMethods
    ].

    "Modified: / 05-05-2011 / 15:23:31 / cg"
!

macrosOnly
    ^ showOnly == #macros

    "Created: / 07-06-2010 / 12:09:22 / cg"
    "Modified: / 07-06-2010 / 14:18:33 / cg"
!

macrosOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #macros
    ].

    "Created: / 07-06-2010 / 12:09:34 / cg"
    "Modified: / 05-05-2011 / 15:23:33 / cg"
!

methodsOnly
    ^ showOnly == #methods

    "Created: / 07-06-2010 / 12:12:26 / cg"
    "Modified: / 07-06-2010 / 14:18:38 / cg"
!

methodsOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #methods
    ].

    "Created: / 07-06-2010 / 12:12:30 / cg"
    "Modified: / 05-05-2011 / 15:23:35 / cg"
!

ozClassesOnly
    ^ showOnly == #ozClasses

    "Modified: / 07-06-2010 / 14:18:41 / cg"
!

ozClassesOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #ozClasses
    ].

    "Modified: / 05-05-2011 / 15:23:38 / cg"
!

ozFunctionsOnly
    ^ showOnly == #ozFunctions

    "Modified: / 07-06-2010 / 14:18:44 / cg"
!

ozFunctionsOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #ozFunctions
    ].
    self updateContentsFromRawList.

    "Modified: / 05-05-2011 / 15:18:51 / cg"
!

ozMethodsOnly
    ^ showOnly == #ozMethods

    "Modified: / 07-06-2010 / 14:18:47 / cg"
!

ozMethodsOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #ozMethods
    ].

    "Modified: / 05-05-2011 / 15:23:44 / cg"
!

pythonClassesOnly
    ^ showOnly == #pythonClasses

    "Modified: / 07-06-2010 / 14:18:52 / cg"
!

pythonClassesOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #pythonClasses
    ].

    "Modified: / 05-05-2011 / 15:23:46 / cg"
!

pythonFunctionsOnly
    ^ showOnly == #pythonFunctions

    "Modified: / 07-06-2010 / 14:18:55 / cg"
!

pythonFunctionsOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #pythonFunctions
    ].

    "Modified: / 05-05-2011 / 15:23:48 / cg"
!

pythonMethodsOnly
    ^ showOnly == #pythonMethods

    "Modified: / 07-06-2010 / 14:18:58 / cg"
!

pythonMethodsOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #pythonMethods
    ].

    "Modified: / 05-05-2011 / 15:23:51 / cg"
!

showOnly
    tagTypesPresent == false ifTrue:[
        ^ nil    "/ showing everything
    ].
    ^ showOnly "? DefaultShowOnly"

    "Modified: / 20-06-2010 / 01:44:13 / cg"
!

showOnly:aSymbol
    showOnly := aSymbol

    "Modified: / 05-05-2011 / 15:23:55 / cg"
!

structsOnly
    ^ showOnly == #structs

    "Created: / 25-06-2010 / 10:42:27 / cg"
!

structsOnly:aBoolean
    showOnly := DefaultShowOnly := nil.
    aBoolean ifTrue:[
        showOnly := "DefaultShowOnly :=" #structs
    ].

    "Created: / 25-06-2010 / 10:42:39 / cg"
    "Modified: / 05-05-2011 / 15:23:58 / cg"
!

targetsOnly
    ^ showOnly == #targets

    "Modified: / 07-06-2010 / 14:19:03 / cg"
!

targetsOnly:aBoolean
    showOnly := DefaultShowOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #targets
    ].

    "Modified: / 05-05-2011 / 15:24:02 / cg"
!

typesOnly
    ^ showOnly == #types

    "Modified: / 07-06-2010 / 14:19:06 / cg"
!

typesOnly:aBoolean
    showOnly := DefaultShowOnly := nil.
    aBoolean ifTrue:[
        showOnly := "DefaultShowOnly :=" #types
    ].

    "Modified: / 05-05-2011 / 15:24:04 / cg"
!

variablesOnly
    ^ showOnly == #variables

    "Modified: / 07-06-2010 / 14:19:09 / cg"
!

variablesOnly:aBoolean
    showOnly := nil.
    aBoolean ifTrue:[
        showOnly := DefaultShowOnly := #variables
    ].

    "Modified: / 05-05-2011 / 15:24:06 / cg"
! !

!TagList methodsFor:'accessing-presentation'!

groupBy
    ^ groupBy

    "Created: / 05-05-2011 / 14:31:37 / cg"
    "Modified: / 05-05-2011 / 15:34:14 / cg"
!

groupBy:aSymbolOrNil
    groupBy ~~ aSymbolOrNil ifTrue:[
        groupBy := DefaultGroupBy := aSymbolOrNil.
        self updateContentsFromFilteredList
    ].

    "Created: / 05-05-2011 / 14:32:00 / cg"
!

groupedByType
    ^ self groupBy == #byType

    "Created: / 05-05-2011 / 14:32:53 / cg"
!

groupedByType:aBoolean
    aBoolean == true ifTrue:[
        self groupBy:#byType
    ] ifFalse:[
        self groupBy:nil
    ].

    "Created: / 05-05-2011 / 14:33:05 / cg"
!

sortCriteria
    ^ sortCriteria ? DefaultSortCriteria
!

sortCriteria:aSymbolOrNil
    sortCriteria ~~ aSymbolOrNil ifTrue:[
        sortCriteria := DefaultSortCriteria := aSymbolOrNil.
        Sorted := sortCriteria.
        self updateContentsFromFilteredList
    ].

    "Modified: / 05-05-2011 / 14:50:18 / cg"
!

sorted
    "backward compatibility"

    ^ self sortCriteria notNil 
!

sorted:aBoolean
    "backward compatibility"

    aBoolean ifTrue:[
        self sortCriteria:#byName
    ] ifFalse:[
        self sortCriteria:nil
    ].
!

sortedByLineNumber
    ^ self sortCriteria isNil
    or:[ self sortCriteria == #lineNumber ]

    "Modified: / 05-05-2011 / 14:30:33 / cg"
!

sortedByLineNumber:aBoolean
    aBoolean == true ifTrue:[
        self sortCriteria:#lineNumber
    ].

    "Modified: / 27-06-2010 / 21:31:44 / cg"
!

sortedByName
    ^ self sortCriteria == #byName 
!

sortedByName:aBoolean
    aBoolean == true ifTrue:[
        self sortCriteria:#byName
    ].
!

sortedByNameIgnoringCase
    ^ self sortCriteria == #byNameIgnoringCase 
!

sortedByNameIgnoringCase:aBoolean
    aBoolean == true ifTrue:[
        self sortCriteria:#byNameIgnoringCase
    ].
!

sortedByNameIgnoringLeadingUnderscores
    ^ self sortCriteria == #byNameIgnoringLeadingUnderscores 
!

sortedByNameIgnoringLeadingUnderscores:aBoolean
    aBoolean == true ifTrue:[
        self sortCriteria:#byNameIgnoringLeadingUnderscores
    ].
!

sortedByNameIgnoringLeadingUnderscoresAndCase
    ^ self sortCriteria == #byNameIgnoringLeadingUnderscoresAndCase 
!

sortedByNameIgnoringLeadingUnderscoresAndCase:aBoolean
    aBoolean == true ifTrue:[
        self sortCriteria:#byNameIgnoringLeadingUnderscoresAndCase
    ].
!

sortedByType
    ^ self sortCriteria == #byType 
!

sortedByType:aBoolean
    aBoolean == true ifTrue:[
        self sortCriteria:#byType
    ].
!

tagTypesPresent
    ^ tagTypesPresent
! !

!TagList methodsFor:'initialization'!

initContents:n
    "Invoked when a new instance is created."

    super initContents:n.
    flags isNil ifTrue:[
        flags := IdentityDictionary new.
    ].
!

initialize
    "Invoked when a new instance is created."

    flags := IdentityDictionary new.
! !

!TagList methodsFor:'private'!

applyFilterToList:aList
    |filters|

    filters := filter splitByAny:',;'.
    filters size == 1 ifTrue:[
        filter includesMatchCharacters ifFalse:[
            ^ aList select:[:tag | tag label includesString:filter caseSensitive:false]
        ].
    ].

    ^ aList 
        select:[:tag |
            filters 
                contains:[:someFilter |
                    someFilter includesMatchCharacters ifTrue:[
                        someFilter match:tag label caseSensitive:false
                    ] ifFalse:[
                        tag label includesString:someFilter caseSensitive:false
                    ].
                ].
        ].
!

getCtagsVersion
    " parse major and minor version from ctags by operating system command
      cehck for the 'Exuberant Ctags' string being present
      return an Array with mafor and minor part of version or nil if not available"

    | stream string index majorVersion minorVersion indexOfPoint|

    stream := WriteStream on:''.
    OperatingSystem         
        executeCommand:'ctags --version' 
        inputFrom:nil 
        outputTo:stream 
        errorTo:stream 
        inDirectory:nil
        onError:[:status| false].
    string := stream contents.
    index := string findString:'Exuberant Ctags' ifAbsent:[nil].
    index notNil ifTrue:[
        string := (string copyFrom:(index + ('Exuberant Ctags' size))) asCollectionOfWords first.
        (string includes:$,) ifTrue:[ string := string copyTo:((string indexOf:$,) - 1)].
        indexOfPoint := string indexOf:$. ifAbsent:nil.
        indexOfPoint notNil ifTrue:[
            majorVersion := (string copyFrom:1 to:indexOfPoint - 1) asInteger.
            minorVersion := (string copyFrom:indexOfPoint + 1 to:string size) asInteger.
            ^ Array with:majorVersion with:minorVersion.
        ]
    ].
    ^ nil

    "Modified: / 05-05-2011 / 14:48:08 / cg"
!

setFilteredList:aList
    filteredList := aList.
    self updateContentsFromFilteredList

    "Created: / 05-05-2011 / 14:46:12 / cg"
!

setRawList:aList
    rawList := aList.
    self updateContentsFromRawList

    "Created: / 05-05-2011 / 14:46:22 / cg"
!

shellCommandFor:aFilenameString
    "returns the shellCommand to be used"

    |template|

    (template := self shellCommandTemplateFor:aFilenameString) isNil ifTrue:[
        ^ nil
    ].
    ^ template bindWith:aFilenameString

    "Modified: / 05-01-2012 / 11:10:03 / cg"
!

shellCommandTemplateFor:aFilenameString
    "returns the shellCommand to be used (contains %1 for the filename).
     When first called, looks for ctags (both a private and the system-supplied),
     and tries to see what version that is. I prefer exuberant ctags version"

    |lcSuffix shellCommand isCSuffix isCPlusPlusSuffix isObjcSuffix
     isJavaSuffix isEiffelSuffix isFortranSuffix
     isTCLSuffix isRubySuffix isPythonSuffix isPhpSuffix isJavaScriptSuffix
     showOnly response suff fn langValue langOption moreOptions|

    ctagsCommand isNil ifTrue:[
        remoteTarget isNil ifTrue:[
            "/ local use
            suff := (OperatingSystem isMSWINDOWSlike) ifTrue:'.exe' ifFalse:''.

            ctagsCommand := 'ctags',suff.
            (ctagsCommand notNil and:[(fn := ctagsCommand asFilename) isExecutableProgram]) ifTrue:[
                ctagsCommand := fn pathName.
                ctagsIsExCtags := ctagsIsExCtags5x := true.
            ] ifFalse:[
                ctagsCommand := 'bin/ctags',suff.
                (ctagsCommand notNil and:[(fn := ctagsCommand asFilename) isExecutableProgram]) ifTrue:[
                    ctagsCommand := fn pathName.
                    ctagsIsExCtags := ctagsIsExCtags5x := true.
                ] ifFalse:[
                    ctagsCommand := Smalltalk getPackageFileName:'stx/support/tools/ctags-5.8/ctags',suff.
                    (ctagsCommand notNil and:[(fn := ctagsCommand asFilename) isExecutableProgram]) ifTrue:[
                        ctagsCommand := fn pathName.
                        ctagsIsExCtags := ctagsIsExCtags5x := true.
                    ] ifFalse:[
                        ctagsCommand := Smalltalk getPackageFileName:'stx/support/tools/ctags-3.2.2/ctags',suff.
                        (ctagsCommand notNil and:[(fn := ctagsCommand asFilename) isExecutableProgram]) ifTrue:[
                            ctagsCommand := fn pathName.
                            ctagsIsExCtags := true.
                            ctagsIsExCtags5x := false.
                        ] ifFalse:[
                            ctagsIsExCtags := nil.
                            ctagsIsExCtags5x := nil.
                            ctagsCommand := Smalltalk getPackageFileName:'stx/support/tools/ctags/ctags',suff.
                            (ctagsCommand notNil and:[(fn := ctagsCommand asFilename) isExecutableProgram]) ifTrue:[
                                ctagsCommand := fn pathName.
                            ] ifFalse:[
                                "/ use systems default ctags command
                                ctagsCommand := 'ctags'.
                            ]
                        ]
                    ].
                ]
            ]
        ] ifFalse:[
            "/ cross-development
"/            target remoteOperatingSystem = 'Linux' ifTrue:[
                "/ use systems default ctags command
                ctagsCommand := 'ctags'.
                ctagsIsExCtags := nil.
                ctagsIsExCtags5x := nil.
"/            ]
        ].
    ].

    (ctagsIsExCtags isNil or:[ctagsIsExCtags5x isNil]) ifTrue:[
        ctagsCommand notNil ifTrue:[
            response := OperatingSystem getCommandOutputFrom:(ctagsCommand, ' --version').
            (response notNil 
            and:[response asLowercase startsWith:'exuberant ctags']) ifTrue:[
                ctagsIsExCtags := true.

                response := (response copyFrom:'exuberant ctags' size + 1) withoutSeparators.
                ctagsIsExCtags5x := response startsWith:'5.' 
            ].
        ].
    ].

    ctagsIsExCtags5x ifTrue:[
        langOption := '--language-force=%1'.
    ] ifFalse:[ ctagsIsExCtags ifTrue:[
        langOption := '--lang=%1'.
    ]].

    shellCommand := ctagsCommand.
    (shellCommand includes:Character space) ifTrue:[
        shellCommand := '"',shellCommand,'"'.
    ].
    moreOptions := ''.

    showOnly := self showOnly.

    lcSuffix := aFilenameString asFilename suffix asLowercase.
    isCSuffix := self class isCSuffix:lcSuffix.

    "/ a hack for temporary files generated by stc
    lcSuffix = 'sc' ifTrue:[
        (aFilenameString asFilename asAbsoluteFilename components includes:'stx') ifTrue:[
            isCSuffix := true
        ].
    ].
    isCPlusPlusSuffix := self class isCPlusPlusSuffix:lcSuffix.
    isObjcSuffix := self class isObjcSuffix:lcSuffix.

    (shellCommand notNil and:[(ctagsIsExCtags ? false)]) ifTrue:[
        isJavaSuffix := self class isJavaSuffix:lcSuffix.
        isEiffelSuffix := self class isEiffelSuffix:lcSuffix.
        isFortranSuffix := self class isFortranSuffix:lcSuffix.

        "/ ex_ctags supports c, c++, java, fortran and a few others
        (isCSuffix or:[isCPlusPlusSuffix or:[isObjcSuffix
        or:[isJavaSuffix or:[isEiffelSuffix or:[isFortranSuffix]]]]]) ifFalse:[
            (ctagsIsExCtags5x ? false) ifFalse:[
                ^ nil
            ].

            "/ ex_ctags5.x also supports:
            "/     Assembler, AWK, ASP, BETA,
            "/     Bourne/Korn/Z Shell, C, C++, C#, COBOL, Eiffel, Erlang, Fortran, Java, Lisp,
            "/     Lua, Makefile, Pascal, Perl, PHP, PL/SQL, Python, REXX, Ruby, Scheme,
            "/     S-Lang, SML (Standard ML), Tcl, Vera, Verilog, VHDL, Vim, and YACC.
        ].
        isTCLSuffix := self class isTCLSuffix:lcSuffix.
        isRubySuffix := self class isRubySuffix:lcSuffix.
        isPythonSuffix := self class isPythonSuffix:lcSuffix.
        isPhpSuffix := self class isPhpSuffix:lcSuffix.
        isJavaScriptSuffix := self class isJavaScriptSuffix:lcSuffix.

        usingDefaultCTags    := false.
        shellCommand := shellCommand asFilename asAbsoluteFilename pathName.
"/            shellCommand := shellCommand, ' -f - --c-types=f  --file-scope=no'.
"/            shellCommand := shellCommand, ' -f - --file-scope=yes'.
"/            shellCommand := shellCommand, ' -f - --file-scope=yes'.
        shellCommand := shellCommand, ' -f - --file-scope=yes --excmd=number'.

        (isCSuffix or:[isCPlusPlusSuffix or:[isObjcSuffix]]) ifTrue:[
            isCPlusPlusSuffix 
                ifTrue:[ langValue := 'c++']
                ifFalse:[ langValue := 'c'].

            showOnly == #classes ifTrue:[
                moreOptions := moreOptions, ' --c-types=c'
            ] ifFalse:[
                showOnly == #functions ifTrue:[
                    moreOptions := moreOptions, ' --c-types=f'
                ] ifFalse:[
                    showOnly == #functionsAndVariables ifTrue:[
                        moreOptions := moreOptions, ' --c-types=fv'
                    ] ifFalse:[
                        showOnly == #classesFunctionsAndVariables ifTrue:[
                            moreOptions := moreOptions, ' --c-types=cfv'
                        ] ifFalse:[
                            showOnly == #variables ifTrue:[
                                moreOptions := moreOptions, ' --c-types=v'
                            ] ifFalse:[
                                showOnly == #types ifTrue:[
                                    moreOptions := moreOptions, ' --c-types=t'
                                ] 
                            ] 
                        ] 
                    ] 
                ] 
            ]. 
            self hideStructMembers == true ifTrue:[ moreOptions := moreOptions, ' --c-types=-m'].
            self hideDefines == true ifTrue:[ moreOptions := moreOptions, ' --c-types=-d' ].
            self hideTypedefs == true ifTrue:[ moreOptions := moreOptions, ' --c-types=-t' ].
            self hideStructures == true ifTrue:[ moreOptions := moreOptions, ' --c-types=-s'].
            self hideVariables == true ifTrue:[ moreOptions := moreOptions, ' --c-types=-v'].
            self hideFunctions == true ifTrue:[ moreOptions := moreOptions, ' --c-types=-f'].
            self hideClasses == true ifTrue:[ moreOptions := moreOptions, ' --c-types=-c'].
        ].

        isJavaSuffix ifTrue:[
            langValue := 'java'.

            showOnly == #javaClasses ifTrue:[
                moreOptions := moreOptions, ' --java-types=c'
            ] ifFalse:[
                showOnly == #javaMethods ifTrue:[
                    moreOptions := moreOptions, ' --java-types=m'
                ] ifFalse:[
                    showOnly == #javaClassesAndMethods ifTrue:[
                        moreOptions := moreOptions, ' --java-types=mc'
                    ]
                ]
            ]. 
            self hideJavaClasses == true ifTrue:[ moreOptions := moreOptions, ' --java-types=-c' ].
            self hideJavaMethods == true ifTrue:[ moreOptions := moreOptions, ' --java-types=-m' ].
            self hideJavaInterfaces == true ifTrue:[ moreOptions := moreOptions, ' --java-types=-i' ].
            self hideJavaFields == true ifTrue:[ moreOptions := moreOptions, ' --java-types=-f' ].
            self hideJavaPackages == true ifTrue:[ moreOptions := moreOptions, ' --java-types=-p' ].
        ].

        isEiffelSuffix ifTrue:[
            langValue := 'eiffel'.

            showOnly == #classes ifTrue:[ 
                moreOptions := moreOptions, ' --eiffel-types=c' 
            ] ifFalse:[
                showOnly == #features ifTrue:[
                    moreOptions := moreOptions, ' --eiffel-types=f'
                ]
            ]. 
"/            hideEiffelClasses == true ifTrue:[
"/                moreOptions := moreOptions, ' --eiffel-types=-c'
"/            ].
"/            hideEiffelFeatures == true ifTrue:[
"/                moreOptions := moreOptions, ' --eiffel-types=-m'
"/            ].
        ].

        isFortranSuffix ifTrue:[
            langValue := 'fortran'.

            showOnly == #functions ifTrue:[
                moreOptions := moreOptions, ' --fortran-types=f'
            ] ifFalse:[
                showOnly == #interfaces ifTrue:[
                    moreOptions := moreOptions, ' --fortran-types=i'
                ] ifFalse:[
                    showOnly == #subroutines ifTrue:[
                        moreOptions := moreOptions, ' --fortran-types=s'
                    ] ifFalse:[
                        showOnly == #commonBlocks == true ifTrue:[
                            moreOptions := moreOptions, ' --fortran-types=c'
                        ]
                    ]
                ]
            ]. 
"/            hideFortranFunctions == true ifTrue:[
"/                moreOptions := moreOptions, ' --fortran-types=-f'
"/            ].
"/            hideFortranInterfaces == true ifTrue:[
"/                moreOptions := moreOptions, ' --fortran-types=-i'
"/            ].
"/            hideFortranSubroutines == true ifTrue:[
"/                moreOptions := moreOptions, ' --fortran-types=-s'
"/            ].
"/            hideFortranCommonBlocks == true ifTrue:[
"/                moreOptions := moreOptions, ' --fortran-types=-c'
"/            ].
"/            hideFortranEntryPoints == true ifTrue:[
"/                moreOptions := moreOptions, ' --fortran-types=-e'
"/            ].
"/            hideFortranLabels == true ifTrue:[
"/                moreOptions := moreOptions, ' --fortran-types=-l'
"/            ].
"/            hideFortranDerivedTypes == true ifTrue:[
"/                moreOptions := moreOptions, ' --fortran-types=-t'
"/            ].
        ].

"/            shellCommand := shellCommand, ' -f -'.
        langValue notNil ifTrue:[
            langOption notNil ifTrue:[
                shellCommand := shellCommand , ' ' , (langOption bindWith:langValue)
            ].
        ].
        moreOptions notEmptyOrNil ifTrue:[
            shellCommand := shellCommand , moreOptions
        ].
        shellCommand := shellCommand, ' "%1"'.
        remoteTarget notNil ifTrue:[
            ^ (remoteTarget makeRemoteCommandFrom:shellCommand inDirectory:'./').
        ].
        ^ shellCommand.
    ].

    "/ regular ctags: assume supports c, c++ only
    isCSuffix ifFalse:[
        ^ nil
    ].

    usingDefaultCTags := true.

    shellCommand := 'ctags'.

"/   "sunos and realIX have no option -s"
"/    (OperatingSystem getOSType  = 'linux') ifTrue:[
"/        shellCommand := 'ctags -S'
"/    ].
    Transcript showCR:('TagList [info]: using default ctags command (not ctags from stx): <', shellCommand, '>').
    ctagsCommand := nil. "/ flush - so we will check again.

    shellCommand := shellCommand, ' "%1"'.
    remoteTarget notNil ifTrue:[
        ^ (remoteTarget makeRemoteCommandFrom:shellCommand inDirectory:'./').
    ].
    ^ shellCommand

    "Modified: / 08-07-2010 / 00:23:24 / cg"
    "Created: / 05-01-2012 / 11:07:41 / cg"
!

sortBlock
    "sort AND group"

    |sortBlock|

    sortCriteria := self sortCriteria.
    sortBlock := self sortBlockForSortCriteria.

    groupBy isNil ifTrue:[
        ^ sortBlock
    ].

    ^ [:a :b| 
            |t1 t2 l1 l2|

            t1 := a typeIdentifierInList ? ' '.
            t2 := b typeIdentifierInList ? ' '.
            t1 = t2 ifTrue:[
                sortBlock value:a value:b
            ] ifFalse:[
                t1 < t2 
            ]
      ].

    "Modified: / 05-05-2011 / 15:35:02 / cg"
!

sortBlockForSortCriteria
    sortCriteria == #byName ifTrue:[ 
        ^ [:a :b| 
                |l1 l2|

                l1 := a label ? ''.
                l2 := b label ? ''.
                l1 = l2 ifTrue:[
                    (a lineNumber ? 0) < (b lineNumber ? 0)
                ] ifFalse:[
                    l1 < l2 
                ]
            ]
    ].

    sortCriteria == #byNameIgnoringCase ifTrue:[ 
        ^ [:a :b| 
                |l1 l2|

                l1 := a label asLowercase.
                l2 := b label asLowercase.
                l1 = l2 ifTrue:[
                    (a lineNumber ? 0) < (b lineNumber ? 0)
                ] ifFalse:[
                    l1 < l2 
                ]
          ]
    ].

    sortCriteria == #byNameIgnoringLeadingUnderscores ifTrue:[
        ^ [:a :b| 
                |l1 l2 i|

                l1 := a label.
                l2 := b label.
                l1 = l2 ifTrue:[
                    (a lineNumber ? 0) < (b lineNumber ? 0)
                ] ifFalse:[
                    i := l1 findFirst:[:c | (c ~~ $_)].
                    i > 1 ifTrue:[
                        l1 := l1 copyFrom:i
                    ].
                    i := l2 findFirst:[:c | (c ~~ $_)].
                    i > 1 ifTrue:[
                        l2 := l2 copyFrom:i
                    ].
                    l1 < l2 
                ]
          ].
    ].

    sortCriteria == #byNameIgnoringLeadingUnderscoresAndCase ifTrue:[
        ^ [:a :b| 
                |l1 l2 i|

                l1 := a label asLowercase.
                l2 := b label asLowercase.
                l1 = l2 ifTrue:[
                    (a lineNumber ? 0) < (b lineNumber ? 0)
                ] ifFalse:[
                    i := l1 findFirst:[:c | (c ~~ $_)].
                    i > 1 ifTrue:[
                        l1 := l1 copyFrom:i
                    ].
                    i := l2 findFirst:[:c | (c ~~ $_)].
                    i > 1 ifTrue:[
                        l2 := l2 copyFrom:i
                    ].
                    l1 < l2 
                ]
          ].
    ].

"/    sortCriteria == #byType ifTrue:[ 
"/        ^ [:a :b| 
"/                |t1 t2 l1 l2|
"/                t1 := a typeIdentifierInList ? ' '.
"/                t2 := b typeIdentifierInList ? ' '.
"/                t1 = t2 ifTrue:[
"/                    l1 := a label.
"/                    l2 := b label.
"/                    l1 = l2 ifTrue:[
"/                        (a lineNumber ? 0) < (b lineNumber ? 0)
"/                    ] ifFalse:[
"/                        l1 < l2 
"/                    ]
"/                ] ifFalse:[
"/                    t1 < t2 
"/                ]
"/          ].
"/    ].

    ^ [:a :b| a lineNumber < b lineNumber ]

    "Created: / 05-05-2011 / 14:37:25 / cg"
    "Modified: / 18-06-2011 / 19:30:45 / cg"
!

updateContentsFromFilteredList
    "call this, if only the sort order has changed (no need to call ctags or filter again)"

    |list|

    list := filteredList.
    list notEmptyOrNil ifTrue:[
        list := list asSortedCollection:(self sortBlock).
    ].
    self contents:(list ? #()).

    "Created: / 05-05-2011 / 14:45:41 / cg"
!

updateContentsFromRawList
    "call this, if only the filter has changed (no need to call ctags again)"

    filteredList := (filter isEmptyOrNil or:[rawList isNil])
                        ifTrue:[ rawList ]
                        ifFalse:[ self applyFilterToList:rawList ].
    filteredList notNil ifTrue:[
        self hideFunctions == true ifTrue:[
            filteredList := filteredList reject:[:tag | tag isFunctionTag].
        ] ifFalse:[
            showOnly == #functions ifTrue:[
                filteredList := filteredList select:[:tag | tag isFunctionOrMethodTag].
            ].
        ].
    ].
    self updateContentsFromFilteredList

    "Modified: / 05-05-2011 / 15:13:14 / cg"
! !

!TagList methodsFor:'queries'!

bestTagForLine:lineNr 
    "find the best tag for a given lineNr in the file"

    ^ self bestTagForLine:lineNr filtering:nil
!

bestTagForLine:lineNr filtering:tagFilterOrNil
    "find the best tag for a given lineNr in the file.
     The filter can be used eg. to find only function tags
     (i.e. to ignore case and goto labels in C)"

    |bestTag sortedByLineNumber|

    sortedByLineNumber := self sortedByLineNumber.
    self do:[:eachTag |
        eachTag notNil ifTrue:[
            (tagFilterOrNil isNil or:[tagFilterOrNil value:eachTag]) ifTrue:[
                eachTag lineNumber <= lineNr ifTrue:[
                    bestTag isNil ifTrue:[
                        bestTag := eachTag.
                        "/ sortedByLineNumber ifTrue:[^ eachTag].
                    ] ifFalse:[
                        eachTag lineNumber > bestTag lineNumber ifTrue:[
                            bestTag := eachTag    
                        ]
                    ]
                ].
            ].
        ].
    ].

    ^ bestTag
!

tagForFunction:functionName 
    ^ rawList 
        detect:[:tag |
            tag isFunctionTag and:[ tag label = functionName ]
        ]
        ifNone:nil
!

tagForMacro:macroName 
    ^ rawList 
        detect:[:tag |
            tag isMacroTag and:[ tag label = macroName ]
        ]
        ifNone:nil
!

tagForType:typeName 
    ^ rawList 
        detect:[:tag |
            tag isTypeTag and:[ tag label = typeName ]
        ]
        ifNone:nil
!

tagsValidForFile
    "the file, for which the tagsList is valid"

    ^ tagsValidForFile
! !

!TagList methodsFor:'tag generation'!

fromFile:aFile in:aTempDirectory
    "create tags from a file;
     either use the ctags/etags command, or an internal naive, simple method."

    |forceSimpleTagList list shellCmd numTags fileContents|

    rawList := nil.
    tagsValidForFile := nil.

    forceSimpleTagList := false.
    (self class isSmalltalkSuffix:aFile suffix) ifTrue:[
        forceSimpleTagList := true.
    ].
    
    "/ the simple builtin tagList generator is actually better than the ctags output for makefiles
    (self class makeFilePatterns contains:[:aPattern | (aPattern match:aFile baseName asLowercase)]) ifTrue:[forceSimpleTagList := true].

    forceSimpleTagList ifFalse:[
        shellCmd := (self shellCommandFor:aFile pathName).
        shellCmd notNil ifTrue:[
            tagTypesPresent := false.     "/ will be set again, when ctags command provides types
            list := ((self getTagListFromFile:aFile usingCommand:shellCmd mode:nil in:aTempDirectory) ? #()) asOrderedCollection.
            "/ kludge: I am better in getting cases/switches/labels
            list addAll:(self getAdditionalCTagsInFile:aFile withList:list).
            "/ another kludge - add in my own scanned objc tags
            (self class isObjcSuffix:aFile suffix) ifTrue:[
                |objcTags|
                
                objcTags := self objcTagsInFile:aFile.
                list 
                    removeAllSuchThat:[:ctag | 
                        objcTags contains:[:objctag | objctag lineNumber = ctag lineNumber]
                    ].
                list addAll:objcTags.    
            ].    
        ].
    ].

    "/ in case ctags could not find anything, try our own, naive fallback (not too bad either)
    list isEmptyOrNil ifTrue:[
        list := ((self getSimpleTagListFromFile:aFile in:aTempDirectory) ? #()) asOrderedCollection.
    ].
    tagTypesPresent := true.

    numTags := list size.
    fileContents := aFile contents.

    (numTags > 1 and:[fileContents notEmptyOrNil]) ifTrue:[
        numTags to:1 by:-1 do:[:i| 
            |tag lnr|

            tag := list at:i ifAbsent:nil.

            lnr := tag lineNumberIn:fileContents.
            lnr == 0 ifTrue:[
                list removeIndex:i
            ] ifFalse:[
                tag lineNumber:lnr
            ]
        ]
    ].    
    self setRawList:list.
    tagsValidForFile := aFile.

    "Modified: / 05-01-2012 / 11:03:29 / cg"
!

fromFile:aFile in:aTempDirectory onTarget:aTarget
    "create tags from a file;
     either use the ctags/etags command, or an intenral naive, simple method.
    "
    |list|

    remoteTarget := aTarget.

    [ 
        list := self fromFile:aFile in:aTempDirectory
    ] ensure:[
        remoteTarget := nil.
    ].
    ^ list
!

getModeFromFileSuffixOf:aFile 
    |suffix mode|

    suffix := aFile suffix.
    (self class isCSuffix:suffix) ifTrue:[
        ^ #c.
    ].
    (self class isCPlusPlusSuffix:suffix) ifTrue:[
        ^ #c.
    ].
    (self class isJavaSuffix:suffix) ifTrue:[
        ^ #java.
    ].
    (self class isFortranSuffix:suffix) ifTrue:[
        ^ #fortran.
    ].
    (self class isEiffelSuffix:suffix) ifTrue:[
        ^ #eiffel.
    ].
    (self class isHTMLSuffix:suffix) ifTrue:[
        ^ #html.
    ].
    ^ mode

    "Modified: / 20-04-2011 / 19:02:54 / cg"
!

getTagListFromFile:aFile usingCommand:scmd mode:modeOrNil in:aTempDirectory
    "create ctags-list from a file, using cmd (which is etags / ctags)"

    |list pipe tag tagFile contents mode infoDictionary|

    (mode := modeOrNil) isNil ifTrue:[
        mode := self getModeFromFileSuffixOf:aFile.
    ].
    list := OrderedCollection new:512.

    infoDictionary := Dictionary new.

"/    Transcript showCR:'execute tags command: ', scmd.
    usingDefaultCTags ifFalse:[
        (pipe := PipeStream readingFrom:scmd) notNil ifTrue:[
            [
                |line atEnd|

                atEnd := false.
                ReadError 
                    handle:[:ex | ]
                    do:[
                        [atEnd] whileFalse:[
                            (line := pipe nextLine) isNil ifTrue:[
                                atEnd := pipe atEnd
                            ] ifFalse:[
"/ Transcript showCR:line.
                                tag := self tagFromLine:line mode:mode using:infoDictionary.

                                tag notNil ifTrue:[
                                    list add:tag
                                ]
                            ]
                        ]
                    ]
            ] ensure:[pipe close].
        ].
        ^ list.
    ].

    (OperatingSystem executeCommand:scmd inDirectory:aTempDirectory) ifTrue:[
        tagFile := aTempDirectory construct:'tags'.

        tagFile exists ifTrue:[
            contents := tagFile contents.

            contents notNil ifTrue:[
                contents do:[:aLine|
                    (tag := self tagFromLine:aLine mode:mode using:infoDictionary) notNil ifTrue:[list add:tag]
                ]
            ].
            Exception 
                handle:[:ex| ] 
                do:[tagFile remove].
        ].
        ^ list.
    ].

    scmd = 'ctags' ifFalse:[
        "/ try default ctags without any options
        ^ self getTagListFromFile:aFile usingCommand:'ctags' mode:modeOrNil in:aTempDirectory
    ].
    ^ #()

    "Created: / 05-01-2012 / 11:03:04 / cg"
!

tagFromLine:aLine mode:languageMode using:infoDictionary
    "analyze the line as returned from ctags and create a corresponding tag object for it"

    |stream word1 word2 tagType pattern key 
     file className lineNumber tagClass fmtString fmt
     showOnly|

    "/ Transcript showCR:aLine.
    aLine size < 6 ifTrue:[
        ^ nil
    ].
    aLine first == $!! ifTrue:[
        (aLine startsWith:'!!_TAG_FILE_FORMAT') ifTrue:[
            "/ aha - ex. ctags
            stream := aLine readStream.
            stream upTo:Character tab.
            stream skipSeparators.
            fmtString := stream upTo:Character tab.
            fmt := Integer readFrom:fmtString onError:nil.
            fmt notNil ifTrue:[
                infoDictionary at:#formatVersion put:fmt
            ]
        ].
        ^ nil
    ].

    "/ tab separated list; except for the pattern, which might include a tab.
    stream := aLine readStream.
    key := stream upTo:Character tab.
    stream skipSeparators.
    file := stream upTo:Character tab.
    stream skipSeparators.
    stream peek == $/ ifTrue:[
        stream next.
        pattern := stream upTo:$/.
        [(pattern last) == $\] whileTrue:[
            pattern at:(pattern size) put:$/.
            pattern := pattern , (stream upTo:$/).
        ].
    ] ifFalse:[
        stream peek isDigit ifTrue:[
            lineNumber := Integer readFrom:stream onError:nil.
            lineNumber isNil ifTrue:[
                self halt:'should not happen - please debug'.
            ] ifFalse:[
                pattern := key.
            ].
        ] ifFalse:[
            self halt:'should not happen - please debug'.
        ].
    ].
    stream peekFor:$;.
    stream peekFor:$".
    stream skipSeparators.
    tagType := stream upTo:Character tab.
    stream skipSeparators.
    word1 := stream upTo:Character tab.     "/ optional file: (scope)
    stream skipSeparators.
    word2 := stream upTo:Character tab.     "/ optional class:

    (word1 startsWith:'file:') ifTrue:[     "/ file: (scope)
        self hideStatic == true ifTrue:[^ nil].
    ].

    (word2 startsWith: 'class:') ifTrue:[
        className := word2 copyFrom:('class:' size)
    ] ifFalse:[
        (word1 startsWith: 'class:') ifTrue:[
            className := word1 copyFrom:('class:' size)
        ]
    ].
"/    (word1 startsWith: 'class:') ifTrue:[
"/        className := word1 copyFrom:('class:' size)
"/    ].
"/    (word2 startsWith: 'class:') ifTrue:[
"/        className := word2 copyFrom:('class:' size)
"/    ].

    tagClass := Tag.
    tagClass autoload.

    "/ typeCharacter to tag-Class mapping...
    languageMode == #c ifTrue:[
        "/ Transcript showCR:tagType.
        tagType = 'v' ifTrue:[ 
            self hideVariables == true ifTrue:[^ nil].
            tagClass := Tag::TVariable 
        ] ifFalse:[ tagType = 'f' ifTrue:[ 
            self hideFunctions == true ifTrue:[^ nil].
            tagClass := Tag::TFunction 
        ] ifFalse:[ tagType = 'd' ifTrue:[ 
            self hideDefines == true ifTrue:[^ nil].
            tagClass := Tag::TMacro 
        ] ifFalse:[ tagType = 't' ifTrue:[ 
            self hideTypedefs == true ifTrue:[^ nil].
            tagClass := Tag::TTypedef 
        ] ifFalse:[ tagType = 'm' ifTrue:[ 
            self hideStructMembers == true ifTrue:[^ nil].
            tagClass := Tag::TMember
        ] ifFalse:[ tagType = 's' ifTrue:[ 
            self hideStructures == true ifTrue:[^ nil].
            tagClass := Tag::TStruct
        ] ifFalse:[ tagType = 'u' ifTrue:[ 
            self hideStructures == true ifTrue:[^ nil].
            tagClass := Tag::TUnion
        ] ifFalse:[ tagType = 'c' ifTrue:[ 
            self hideClasses == true ifTrue:[^ nil].
            tagClass := Tag::TClass
        ] ifFalse:[ tagType = 'e' ifTrue:[ 
            tagClass := Tag::TEnumMember. 
        ] ifFalse:[ tagType = 'g' ifTrue:[ 
            tagClass := Tag::TEnum. 
"/        ] ifFalse:[ tagType = 'n' ifTrue:[ 
"/            tagClass := Tag::TNamespace
"/        ] ifFalse:[ tagType = 'p' ifTrue:[ 
"/            tagClass := Tag::TFunctionPrototype
"/        ] ifFalse:[ tagType = 'x' ifTrue:[ 
"/            tagClass := Tag::TExternVariable
        ] ifFalse:[ 
            self breakPoint:#cg.
            "/ add more here 
        ]]]]]]]]]]
    ] ifFalse:[ languageMode == #java ifTrue:[
        tagType = 'c' ifTrue:[ 
            self hideJavaClasses == true ifTrue:[^ nil].
            tagClass := Tag::TClass 
        ] ifFalse:[ tagType = 'm' ifTrue:[ 
            self hideJavaMethods == true ifTrue:[^ nil].
            tagClass := Tag::TMethod
        ] ifFalse:[ tagType = 'f' ifTrue:[ 
            self hideJavaFields == true ifTrue:[^ nil].
            tagClass := Tag::TField
        ] ifFalse:[ tagType = 'i' ifTrue:[ 
            self hideJavaInterfaces == true ifTrue:[^ nil].
            tagClass := Tag::TInterface
        ] ifFalse:[ tagType = 'p' ifTrue:[ 
            self hideJavaPackages == true ifTrue:[^ nil].
            tagClass := Tag::TPackage
        ] ifFalse:[
            "/ add more here */
        ]]]]]
    ] ifFalse:[ languageMode == #eiffel ifTrue:[
        tagType = 'c' ifTrue:[ 
            self hideClasses == true ifTrue:[^ nil].
            tagClass := Tag::TClass 
"/        ] ifFalse:[ tagType = 'f' ifTrue:[ 
"/            tagClass := Tag::TFeature
"/        ] ifFalse:[ tagType = 'l' ifTrue:[ 
"/            tagClass := Tag::TLocalEntity
        ] ifFalse:[
            "/ add more here */
        ]
    ] ifFalse:[ languageMode == #fortran ifTrue:[
        tagType = 'f' ifTrue:[ 
            self hideFunctions == true ifTrue:[^ nil].
            tagClass := Tag::TFunction 
        ] ifFalse:[ tagType = 'i' ifTrue:[ 
"/            hideInterfaces == true ifTrue:[^ nil].
            tagClass := Tag::TInterface
        ] ifFalse:[ tagType = 't' ifTrue:[ 
            self hideTypedefs == true ifTrue:[^ nil].
            tagClass := Tag::TTypedef 
"/        ] ifFalse:[ tagType = 'l' ifTrue:[ 
"/            tagClass := Tag::TLabel
"/        ] ifFalse:[ tagType = 'm' ifTrue:[ 
"/            tagClass := Tag::TModule
"/        ] ifFalse:[ tagType = 'n' ifTrue:[ 
"/            tagClass := Tag::TNameList
"/        ] ifFalse:[ tagType = 'p' ifTrue:[ 
"/            tagClass := Tag::TProgram
"/        ] ifFalse:[ tagType = 's' ifTrue:[ 
"/            tagClass := Tag::TSubroutine
"/        ] ifFalse:[ tagType = 'b' ifTrue:[ 
"/            tagClass := Tag::TBlockData
"/        ] ifFalse:[ tagType = 'c' ifTrue:[ 
"/            tagClass := Tag::TCommonBlock
"/        ] ifFalse:[ tagType = 'e' ifTrue:[ 
"/            tagClass := Tag::TEntryPoint
        ] ifFalse:[
            "/ add more here */
        ]]]
    ]]]].

    tagTypesPresent := true.

    tagType size == 0 ifTrue:[
        tagType := ''
    ] ifFalse:[
        (showOnly := self showOnly) notNil ifTrue:[
            "/ how ugly can a piece of code get?
            showOnly == #classes ifTrue:[
                tagClass ~~ Tag::TClass ifTrue:[^ nil].
            ] ifFalse:[ showOnly == #functions ifTrue:[
                tagClass ~~ Tag::TFunction ifTrue:[^ nil].
            ] ifFalse:[ showOnly == #variables ifTrue:[
                tagClass ~~ Tag::TVariable ifTrue:[^ nil].
            ] ifFalse:[ showOnly == #types ifTrue:[
                (tagClass ~~ Tag::TTypedef 
                and:[ true "tagClass ~~ Tag::TUnion" 
                and:[ tagClass ~~ Tag::TStruct ]])ifTrue:[^ nil].
            ] ifFalse:[ showOnly == #functionsAndVariables ifTrue:[
                ((tagClass ~~ Tag::TFunction) 
                and:[tagClass ~~ Tag::TVariable]) ifTrue:[^ nil].
            ] ifFalse:[ showOnly == #classesFunctionsAndVariables ifTrue:[
                ((tagClass ~~ Tag::TFunction) 
                and:[(tagClass ~~ Tag::TVariable)
                and:[tagClass ~~ Tag::TClass]]) ifTrue:[^ nil].
            ] ifFalse:[ showOnly == #defines ifTrue:[
                tagClass ~~ Tag::TMacro ifTrue:[^ nil].
            ] ifFalse:[ showOnly == #structs ifTrue:[
                tagClass ~~ Tag::TStruct ifTrue:[^ nil].
            ] ifFalse:[ showOnly == #everything ifTrue:[
            ] ifFalse:[ showOnly == #headlines ifTrue:[
                tagClass ~~ Tag::THeaderElement ifTrue:[^ nil].
            ] ifFalse:[ showOnly == #anchors ifTrue:[
                tagClass ~~ Tag::TAnchorElement ifTrue:[^ nil].
            ] ifFalse:[ showOnly == #targets ifTrue:[
                tagClass ~~ Tag::TMakeTarget ifTrue:[^ nil].
            ] ifFalse:[    
                self halt:'unhandled showOnly'.
            ]]]]]]]]]]]]
        ]
    ].

    ^ tagClass label:key 
             pattern:pattern
                type:tagType
          lineNumber:lineNumber
           className:className.

    "Modified: / 05-05-2011 / 15:45:55 / cg"
! !

!TagList methodsFor:'tag generation - helpers'!

linewiseNaiveTagsInFile:aFilePath using:parseLineBlock
    "common helper for naive linewise parsing tags"

    |targets line lineNr s tagOrTagCollection|

    Tag autoload.

    targets := OrderedCollection new.
    s := aFilePath asFilename readStream.
    s notNil ifTrue:[
        s := LineNumberReadStream readingFrom:s.
        [s atEnd] whileFalse:[
            lineNr := s lineNumber.
            line := s nextLine.

            tagOrTagCollection := parseLineBlock value:line value:lineNr.
            tagOrTagCollection notNil ifTrue:[
                tagOrTagCollection isCollection ifTrue:[
                    targets addAll:tagOrTagCollection
                ] ifFalse:[
                    targets add:tagOrTagCollection
                ].
            ].
        ].
        s close
    ].
    ^ targets

    "Modified: / 08-05-2011 / 10:12:29 / cg"
!

plainTextBetweenHTMLElement:startElement andElementWithTag:endTag
    "applied to an <h1>-tag element, passing '/h1' as endTag,
     this retrieves the plain text of the headline. Used by the tag list."

    |el collector hasSpace txt|

    collector := CharacterWriteStream on:(String new:100).
    el := startElement next.

    hasSpace := true.
    [ el notNil and:[el tag ~= endTag] ] whileTrue:[
        el isTextElement ifTrue:[
            hasSpace ifFalse:[
                collector space.
                hasSpace := true.
            ].
            txt := el text withoutSeparators.
            txt notEmpty ifTrue:[
                collector nextPutAll:txt.
                hasSpace := txt endsWith:' '.
            ]
        ].
        el := el next
    ].
    ^ collector contents

    "Created: / 12-09-2012 / 12:38:01 / cg"
!

tagsForLinesStartingWithIdentifierAndColon:aFilePath
    "helper for yacc tags (and maybe others in the future):
     naive, q&d scan for lines matching:
        <anything>:
    "

    |targets line l lineNr nm s words w|

    Tag autoload.

    targets := OrderedCollection new.
    s := aFilePath asFilename readStream.
    s notNil ifTrue:[
        s := LineNumberReadStream readingFrom:s.
        [s atEnd] whileFalse:[
            line := s nextLine.
            l := line withoutSeparators.
            words := l asCollectionOfWords.

            words size >= 1 ifTrue:[
                w := words first.
                (w endsWith:$:) ifTrue:[
                    nm := w copyButLast.

                    lineNr := s lineNumber - 1.
                    targets add:(Tag::TLabel
                                    label:nm 
                                    pattern:nil
                                    type:nil
                                    lineNumber:lineNr).
                ].
            ]
        ].
        s close
    ].
    ^ targets

    "Created: / 28-09-2012 / 14:45:35 / cg"
! !

!TagList methodsFor:'tag generation - simple'!

assemblerTagsInFile:aFilePath
    "assembler tags:
     naive, q&d scan for lines matching:
        <anything>:
     CAVEAT:
        the code below handles linux-i386 assembler only (for now)
    "

    |targets line l lineNr nm s words w directive
     hideLocals hideLocals2 hideLocals3 hideData hideText currentSegment|

    Tag autoload.

    targets := OrderedCollection new.
    s := aFilePath asFilename readStream.
    s notNil ifTrue:[
        hideLocals := self flagNamed:#hideLocalLabels ? false.
        hideLocals2 := self flagNamed:#hideLocalLabels2 ? false.
        hideLocals3 := self flagNamed:#hideLocalLabels3 ? false.
        hideData := self flagNamed:#hideDataLabels ? false.
        hideText := self flagNamed:#hideTextLabels ? false.
        currentSegment := #text.

        s := LineNumberReadStream readingFrom:s.
        [s atEnd] whileFalse:[
            lineNr := s lineNumber.
            line := s nextLine.
            l := line withoutSeparators.
            words := l asCollectionOfWords.
            words size >= 1 ifTrue:[
                w := words first.
                (w endsWith:$:) ifTrue:[
                    (hideText and:[currentSegment == #text]) ifFalse:[
                        (hideData and:[currentSegment == #data]) ifFalse:[
                            (hideLocals and:[(w startsWith:$.)]) ifFalse:[
                                (hideLocals2 and:[(w startsWith:$_) not]) ifFalse:[
                                    (hideLocals3 
                                        and:[ (w startsWith:$L) 
                                        and:[ (w size > 1) 
                                        and:[ ((w copyFrom:2 to:(w size-1)) conform:[:c | c isDigit])
                                     ]]]) ifFalse:[
                                        nm := w copyButLast.
                                        targets add:(Tag::TLabel 
                                                        label:nm 
                                                        pattern:nil
                                                        type:nil
                                                        lineNumber:lineNr).
                                    ].
                                ].
                            ].
                        ].
                    ].
                    words size >= 2 ifTrue:[
                        directive := words second
                    ] ifFalse:[
                        directive := nil.
                    ]
                ] ifFalse:[
                    directive := w.
                ].
                (directive notNil and:[directive startsWith:$.]) ifTrue:[
                     directive = '.text' ifTrue:[
                        currentSegment := #text
                    ] ifFalse:[ directive = '.data' ifTrue:[
                        currentSegment := #data
                    ] ifFalse:[ directive = '.bss' ifTrue:[
                        currentSegment := #data
                    ] ifFalse:[ directive = '.rodata' ifTrue:[
                        currentSegment := #data
                    ]]]]
                ]
            ]
        ].
        s close
    ].
    ^ targets

    "Modified: / 13-05-2012 / 11:25:49 / cg"
!

batchTagsInFile:aFilePath
    "batch-file
     naive, q&d scan for lines matching:
        :<anything>
    "

    |targets line l lineNr nm s words|

    Tag autoload.

    targets := OrderedCollection new.
    s := aFilePath asFilename readStream.
    s notNil ifTrue:[
        s := LineNumberReadStream readingFrom:s.
        [s atEnd] whileFalse:[
            line := s nextLine.
            (line startsWith:$:) ifTrue:[
                l := line withoutSeparators.
                words := (l copyFrom:2) asCollectionOfWords.

                words size == 1 ifTrue:[
                    nm := words first.

                    lineNr := s lineNumber - 1.
                    targets add:(Tag::TLabel
                                    label:nm 
                                    pattern:nil
                                    type:nil
                                    lineNumber:lineNr).
                ].
            ]
        ].
        s close
    ].
    ^ targets

    "Created: / 28-09-2012 / 14:45:10 / cg"
!

dartTagsInFile:aFilePath
    "dart tags:
     naive, q&d scan for lines matching:
        interface foo
        class foo
        function foo
    "

    |targets line l lineNr nm s|

    Tag autoload.

    targets := OrderedCollection new.
    s := aFilePath asFilename readStream.
    s notNil ifTrue:[
        s := LineNumberReadStream readingFrom:s.
        [s atEnd] whileFalse:[
            lineNr := s lineNumber.
            line := s nextLine.
            l := line withoutSeparators.
            {
                { 'function '  . #functions  . self hideFunctions . Tag::TFunction } .
                { 'var '       . #variables  . self hideVariables . Tag::TVariable } .
                { 'class '     . #classes    . self hideClasses . Tag::TClass      } .
                { 'abstract class '     . #classes    . self hideClasses . Tag::TClass      } .
                { 'interface ' . #interfaces . self hideDartInterfaces . Tag::TInterface } .
                { 'factory '   . #methods .    self hideMethods . Tag::TMethod } .
            } tuplesDo:[:keywordSpace :showOnlyEnum :hideVariableValue :tagType|
                (l startsWith:keywordSpace) ifTrue:[
                    (showOnly isNil or:[showOnly == showOnlyEnum]) ifTrue:[
                        hideVariableValue ~~ true ifTrue:[
                            nm := l copyFrom:(keywordSpace size + 1).
                            nm := nm copyTo:(nm 
                                                findFirst:[:ch | (ch isLetterOrDigit or:['$_.' includes:ch]) not] 
                                                ifNone:nm size+1)-1.
                            targets add:(tagType 
                                            label:nm 
                                            pattern:nil
                                            type:nil
                                            lineNumber:lineNr).
                        ]
                    ]
                ].
            ]
        ].
        s close
    ].
    ^ targets

    "Created: / 28-06-2010 / 12:44:25 / cg"
    "Modified: / 22-08-2012 / 21:32:33 / cg"
!

getAdditionalCTagsInFile:aFilePath withList:ctagsList
    "additional tags, which are not found by the standard ctags utility:
        case foo:   - case label tags
        switch:     - case label tags
        label:      - label tags (if there is a corresponding goto)

     The already generated ctagsList is passed as argument,
     so duplicates etc. can be detected"

    |targets line lineNr s caseLabel l gotoTargets possibleLabels 
     addLabelTag findCurrentFunctionPrefix|

    self hideLabels ifTrue:[^ #()].
    showOnly notNil ifTrue:[^ #()].

    Tag autoload.

    targets := OrderedCollection new.
    gotoTargets := Set new.
    possibleLabels := OrderedCollection new.

    findCurrentFunctionPrefix :=
        [:lineNr |
            |bestSoFar|

            ctagsList do:[:each |
                each isFunctionOrMethodTag ifTrue:[
                    each lineNumber <= lineNr ifTrue:[
                        (bestSoFar isNil or:[ each lineNumber > bestSoFar lineNumber]) ifTrue:[
                            bestSoFar := each
                        ]
                    ].
                ].
            ].
            bestSoFar isNil
                ifTrue:[ '' ]
                ifFalse:[ bestSoFar label, ' ' ]
        ].

    addLabelTag := 
        [:tagType :lineNr :label |
            |fnPrefix|

            fnPrefix := findCurrentFunctionPrefix value:lineNr.
            targets add:(tagType
                            label:(fnPrefix,label)
                            pattern:nil
                            type:nil
                            lineNumber:lineNr).
        ].

    s := aFilePath asFilename readStream.
    s notNil ifTrue:[
        lineNr := 0.
        s := LineNumberReadStream readingFrom:s.
        [s atEnd] whileFalse:[
            lineNr := lineNr + 1.
            line := s nextLine withoutSeparators.
            ((line startsWith:'case ') and:[line includes:$:]) ifTrue:[
                l := line readStream. 
                l skip:5.
                caseLabel := l upTo:$:.
                addLabelTag value:(Tag::TCaseLabel) value:lineNr 
                            value:('case ' allItalic , caseLabel",' <case>' allItalic").
            ] ifFalse:[
                (line startsWith:'default:') ifTrue:[
                    addLabelTag value:(Tag::TCaseLabel) value:lineNr 
                                value:('case ' allItalic, 'default').
                ] ifFalse:[
                    ((line startsWith:'switch') and:[line includes:$(]) ifTrue:[
                        l := line readStream. 
                        l skip:6.
                        l skipSeparators.
                        l peek == $( ifTrue:[
                            l next.
                            caseLabel := (l upTo:$)) withoutSeparators.
                            caseLabel notEmpty ifTrue:[
                                caseLabel := 'switch (',caseLabel,')'.
                                addLabelTag value:(Tag::TCaseLabel) value:lineNr 
                                            value:('case ' allItalic , caseLabel).
                            ]
                        ]
                    ] ifFalse:[
                        (line startsWith:'goto ') ifTrue:[
                            |targetLabel|
                            l := line readStream. 
                            l skip:5.
                            l skipSeparators.
                            targetLabel := (l upTo:$; ) withoutSeparators.
                            targetLabel notEmpty ifTrue:[
                                gotoTargets add:targetLabel.
                            ]
                        ] ifFalse:[
                            (line includes:$:) ifTrue:[
                                |label|
                                label := (line upTo:$:) withoutSeparators.
                                label notEmpty ifTrue:[
                                    ((label first isLetter or:[label first = $_])
                                    and:[ label conform:[:ch | ch isLetterOrDigit or:[ch = $_]]]) ifTrue:[
                                        |fnPrefix|
                                        fnPrefix := findCurrentFunctionPrefix value:lineNr.
                                        possibleLabels 
                                            add:(Tag::TCaseLabel
                                                label:(fnPrefix,('label ' allItalic , label))
                                                pattern:label
                                                type:nil
                                                lineNumber:lineNr)
                                    ].
                                ].
                            ].
                        ].
                    ]
                ]
            ].
        ].
        s close
    ].
    possibleLabels 
        select:[:lbl | gotoTargets includes:lbl pattern]
        thenDo:[:lbl | targets add:lbl].
    ^ targets
!

getAdditionalTagsInFile:aFile withList:ctagsList
    "a chance to generate a list of additional tags,    
     which are not found by the standard ctags utility.
     For example, for C, labels and switches are detected and added.
     The already generated ctagsList is passed as argument,
     so duplicates etc. can be detected"

    (self class isCSuffix:(aFile suffix)) ifTrue:[
        ^ self getAdditionalCTagsInFile:aFile withList:ctagsList
    ].
    ^ #()
!

getSimpleTagListFromFile:aFileOrString in:aTempDirectory
    "fallback, if no ctags is present, or if the file is not a c-file.
     Implemented here for some other file types (Makefiles)
    "
    |file lcName pathName suffix mime|

    file := aFileOrString asFilename.
    lcName := file baseName asLowercase.
    pathName := file pathName.

    self class makeFilePatterns do:[:aPattern |
        (aPattern match:lcName) ifTrue:[
            ^ self class makeTargetTagsInFile:pathName filter:showOnly
        ]
    ].

    suffix := lcName asFilename suffix.
    mime := TagList tagMimeTypeForFile:file.

    ((self class isSmalltalkSuffix:suffix)
    or:[(mime ? '') includesString:'smalltalk']) ifTrue:[
        "/ smalltalk tags - simulated
        ^ self stTagsInFile:pathName in:aTempDirectory
    ].
    ((self class isPythonSuffix:suffix)
    or:[(mime ? '') includesString:'python']) ifTrue:[
        "/ python tags - simulated
        ^ self pythonTagsInFile:pathName
    ].
    ((self class isPhpSuffix:suffix)
    or:[(mime ? '') includesString:'php']) ifTrue:[
        "/ php tags - simulated
        ^ self phpTagsInFile:pathName
    ].
    ((self class isLispSuffix:suffix)
    or:[(mime ? '') includesString:'lisp']) ifTrue:[
        "/ lisp tags - simulated
        ^ self lispTagsInFile:pathName
    ].
    ((self class isObjcSuffix:suffix)
    or:[(mime ? '') includesString:'objcsrc']) ifTrue:[
        "/ objc tags - simulated
        ^ self objcTagsInFile:pathName
    ].
    ((self class isOzSuffix:suffix)
    or:[(mime ? '') includesString:'oz']) ifTrue:[
        "/ oz tags - simulated
        ^ self ozTagsInFile:pathName
    ].
    ((self class isPrologSuffix:suffix)
    or:[(mime ? '') includesString:'prolog']) ifTrue:[
        "/ prolog tags - simulated
        ^ self prologTagsInFile:pathName
    ].
    ((self class isTCLSuffix:suffix)
    or:[(mime ? '') includesString:'tcl']) ifTrue:[
        "/ tcl tags - simulated
        ^ self tclTagsInFile:pathName
    ].
    ((self class isAssemblerSuffix:suffix)
    or:[(mime ? '') includesString:'assembler']) ifTrue:[
        "/ assembler tags - simulated
        ^ self assemblerTagsInFile:pathName
    ].
    ((self class isRubySuffix:suffix)
    or:[(mime ? '') includesString:'ruby']) ifTrue:[
        "/ ruby tags - simulated
        ^ self rubyTagsInFile:pathName
    ].
    ((self class isYaccSuffix:suffix)
    or:[(mime ? '') includesString:'yacc']) ifTrue:[
        "/ yacc tags - simulated
        ^ self yaccTagsInFile:pathName
    ].
    ((self class isJavaScriptSuffix:suffix)
    or:[(mime ? '') includesString:'javascript']) ifTrue:[
        "/ js tags - simulated
        ^ self javaScriptTagsInFile:pathName
    ].
    ((self class isDartSuffix:suffix)
    or:[(mime ? '') includesString:'dart']) ifTrue:[
        "/ dart tags - simulated
        ^ self dartTagsInFile:pathName
    ].
    ((self class isLuaSuffix:suffix)
    or:[(mime ? '') includesString:'lua']) ifTrue:[
        "/ lua tags - simulated
        ^ self luaTagsInFile:pathName
    ].

    ((self class isHTMLSuffix:suffix)
    or:[(mime ? '') includesString:'html']) ifTrue:[
        "/ html tags - simulated
        ^ self htmlTagsInFile:pathName
    ].
    ((self class isBatchSuffix:suffix)
    or:[(mime ? '') includesString:'batch']) ifTrue:[
        "/ batch tags - simulated
        ^ self batchTagsInFile:pathName
    ].
    ((self class isXSDSuffix:suffix)
    or:[(mime ? '') includesString:'xsd']) ifTrue:[
        "/ xsd tags - simulated
        ^ self xsdTagsInFile:pathName
    ].
    (suffix = 'rs') ifTrue:[
        ^ self stxResourceTagsInFile:pathName
    ].

    "/ could add more here ...
    ^ nil.

    "Created: / 05-01-2012 / 10:55:03 / cg"
!

htmlTagsInFile:aFilePath
    "hatml tags:
     naive, q&d scan for lines containing:
        <textarea>
        <input>
        <table>
        <script>
        <hX>
    "

    |targets line l lineNr s tag|

    "/ TODO: use HTMPParser to read all of them !!

    Tag autoload.

    targets := OrderedCollection new.
    s := aFilePath asFilename readStream.
    s notNil ifTrue:[
        s := LineNumberReadStream readingFrom:s.
        [s atEnd] whileFalse:[
            lineNr := s lineNumber.
            line := s nextLine.
            line := line withoutSeparators.
            l := line asLowercase.

            #(
                'textarea'      hideHTMLTextArea    nil
                'input'         hideHTMLInput       nil
                'table'         hideHTMLTable       nil
                'script'        hideHTMLScript      nil
                'form'          hideHTMLForm        nil
                'a'             nil                 anchors
                'h1'            hideHTMLHeaders     headlines
                'h2'            hideHTMLHeaders     headlines
                'h3'            hideHTMLHeaders     headlines
                'h4'            hideHTMLHeaders     headlines
                'h5'            hideHTMLHeaders     headlines
                'h6'            hideHTMLHeaders     headlines
            ) inGroupsOf:3 do:[:nm :hideInstVarName :thisType|
                |type hideHolder idx tagText doc markup label text markupName markupType
                 isHeader|

                type := hideHolder := nil.

                idx := l indexOfSubCollection:('<',nm).
                idx ~~ 0 ifTrue:[
                    hideHolder := hideInstVarName isNil 
                                    ifTrue:[ false ]
                                    ifFalse:[ self flagNamed:hideInstVarName ].

                    tagText := line copyFrom:idx.
                    doc := HTMLParser new parseText:tagText.
                    markup := doc markup.
                    markupName := markup name.
                    markupType := "markup tag ?" markup type.

                    isHeader := (#(h1 h2 h3 h4 h5 h6) includes:markupType).
                    isHeader ifTrue:[ 
                        type := Tag::THeaderElement  
                    ] ifFalse: [ 
                        markupType == #'form' ifTrue:[ 
                            type := Tag::TFormElement
                        ] ifFalse:[
                            markupType == #'a' ifTrue:[ 
                                type := Tag::TAnchorElement.
                                markupName := markup hrefString notEmptyOrNil 
                                                ifTrue:['"',markup hrefString,'"'] 
                                                ifFalse:[ markup name ]
                            ] ifFalse:[ 
                                type := Tag::TElement 
                            ]
                        ].
                    ].

                    markup id notEmptyOrNil ifTrue:[
                        label := nm , ' (',markup id,')'
                    ] ifFalse:[
                        markupName notEmptyOrNil ifTrue:[
                            label := nm , ' (',markupName,')'
                        ] ifFalse:[
                            (markupType == #input and:[ markup valueString notEmptyOrNil ]) ifTrue:[
                                label := nm , ' ("',markup valueString,'")'
                            ] ifFalse:[
                                (markupType == #script and:[ markup src notEmptyOrNil ]) ifTrue:[
                                    label := nm , ' ("',markup src,'")'
                                ] ifFalse:[
                                    ( isHeader 
                                          and:[text := self plainTextBetweenHTMLElement:markup andElementWithTag:('/',markupType).
                                               text notEmpty] 
                                    ) ifTrue:[
                                        label := '"',text,'" (',nm,')'
                                    ] ifFalse:[
                                         label := nm
                                    ]
                                ]
                            ]
                        ].
                    ].

                    (showOnly isNil or:[thisType isNil or:[showOnly == thisType]]) ifTrue:[
                        hideHolder value ~~ true ifTrue:[
                            tag := type 
                                        label:label 
                                        pattern:nil
                                        type:nil
                                        lineNumber:lineNr.
                            targets add:tag.
                        ]
                    ]
                ].
            ].
        ].
        s close
    ].
    ^ targets

    "Created: / 20-04-2011 / 18:59:29 / cg"
    "Modified: / 12-09-2012 / 17:54:07 / cg"
    "Modified (format): / 16-11-2016 / 17:17:41 / cg"
!

javaScriptTagsInFile:aFilePath
    "javaScript tags:
     naive, q&d scan for lines matching:
        (function foo
    "

    |targets line l lineNr nm s|

    Tag autoload.

    targets := OrderedCollection new.
    s := aFilePath asFilename readStream.
    s notNil ifTrue:[
        s := LineNumberReadStream readingFrom:s.
        [s atEnd] whileFalse:[
            lineNr := s lineNumber.
            line := s nextLine.
            l := line withoutSeparators.

            (l = 'function') ifTrue:[
                l := l , ' ' , (s nextLine withoutSeparators).
            ].
            (l startsWith:'function ') ifTrue:[
                (showOnly isNil or:[showOnly == #functions]) ifTrue:[
                    self hideFunctions ~~ true ifTrue:[
                        nm := l copyFrom:('function ' size + 1).
                        nm := nm copyTo:(nm 
                                            findFirst:[:ch | (ch isLetterOrDigit or:['$_' includes:ch]) not] 
                                            ifNone:nm size+1)-1.
                        targets add:(Tag::TFunction 
                                        label:nm 
                                        pattern:nil
                                        type:nil
                                        lineNumber:lineNr).
                    ]
                ]
            ] ifFalse:[
                (l startsWith:'var ') ifTrue:[
                    (showOnly isNil or:[showOnly == #variables]) ifTrue:[
                        self hideVariables ~~ true ifTrue:[
                            nm := l copyFrom:('var ' size + 1).
                            nm := nm copyTo:(nm 
                                                findFirst:[:ch | (ch isLetterOrDigit or:['$_' includes:ch]) not] 
                                                ifNone:nm size+1)-1.
                            targets add:(Tag::TVariable 
                                            label:nm 
                                            pattern:nil
                                            type:nil
                                            lineNumber:lineNr).
                        ].
                    ].
                ] ifFalse:[
                    ((l includesString:'=function') or:[(l includesString:'= function')]) ifTrue:[
                        (showOnly isNil or:[showOnly == #functions]) ifTrue:[
                            self hideFunctions ~~ true ifTrue:[
                                nm := l copyTo:((l indexOf:$=) - 1). nm := nm withoutSeparators.
                                targets add:(Tag::TFunction 
                                                label:nm 
                                                pattern:nil
                                                type:nil
                                                lineNumber:lineNr).
                            ].
                        ].
                    ].
                ].
            ]
        ].
        s close
    ].
    ^ targets

    "Created: / 28-06-2010 / 12:44:25 / cg"
    "Modified: / 08-05-2011 / 10:39:55 / cg"
!

lispTagFromLine:line lineNr:lineNr
    "lisp/scheme tags:
     naive, q&d scan for lines starting with:
        (define ...
        (defun ...
        (defvar ...
        (defmacro ...
        (defclass ...
        (defmethod ...
        (defpackage ...
        (eval-when ...
        (define- ...
        (def* ...
        (set ...
        (constant ...
        (defconstant ...
        (define-constant ...
        ;;; more        documentation
    
     This is NOT syntax aware, so affected by formatting, line breaks etc.
     Just enough to allow most scheme and lisp programs to be tagged and
     viewed in the file browser. For real lisp work, more is needed.    
    "

    |l nm words def inParens rest|

    l := line withoutSeparators.

    (l startsWith:'(') ifFalse:[  
        (showOnly notNil and:[showOnly ~~ #documentation]) ifTrue:[^ nil].
        self hideDocumentation == true ifTrue:[ ^ nil ].

        (l startsWith:';;;') ifFalse:[^ nil].

        rest := (l copyFrom:4) withoutSeparators.
        rest isEmpty ifTrue:[^ nil].
        (rest conform:[:ch | ch == $;]) ifTrue:[^ nil].
        ^ Tag::TDocumentation 
                        label:(rest withColor:(Color blue "grey")) 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].

    words := (l copyFrom:2) asCollectionOfWords.
    words size >= 2 ifFalse:[^ nil].

    def := words first.
    nm := words second.

    "/ inparens is true if we have (define (name
    (inParens := nm = '(') ifTrue:[
        words size > 2 ifTrue:[ nm := words third ] ifFalse:[ nm := '' ].
    ] ifFalse:[    
        (inParens := nm startsWith:'(') ifTrue:[
            nm := nm copyFrom:2.
        ] ifFalse:[
            nm := nm upTo:$(.    "/ in case it is (define foo() - without space after name
            (inParens := nm startsWith:'(') ifTrue:[
                nm := nm copyFrom:2.
            ].
        ].
    ].    
    (nm endsWith:')') ifTrue:[
        nm := nm copyButLast
    ].

    def = 'define' ifTrue:[             "/ scheme
        inParens ifTrue:[
            (showOnly notNil and:[showOnly ~~ #functions]) ifTrue:[^ nil].
            self hideFunctions == true ifTrue:[ ^ nil ].
            ^ Tag::TFunction 
                            label:nm 
                            pattern:nil
                            type:nil
                            lineNumber:lineNr.
        ] ifFalse:[
            "/ check for (define name (lambda ...
            "/ and (define name (macro ...
            (words size > 2
              and:[ words third startsWith:'(' ]) ifTrue:[
                (words third = '(' and:[words size > 3]) ifTrue:[
                    def := words fourth
                ] ifFalse:[
                    def := words third copyFrom:2.
                ].
                def = 'lambda' ifTrue:[
                    (showOnly notNil and:[showOnly ~~ #functions]) ifTrue:[^ nil].
                    self hideFunctions == true ifTrue:[ ^ nil ].
                    ^ Tag::TFunction 
                                    label:nm 
                                    pattern:nil
                                    type:nil
                                    lineNumber:lineNr.
                ].
                def = 'macro' ifTrue:[
                    (showOnly notNil and:[showOnly ~~ #macros]) ifTrue:[^ nil].
                    self hideLispMacros == true ifTrue:[ ^ nil ].
                    ^ Tag::TLispMacro 
                                    label:nm 
                                    pattern:nil
                                    type:nil
                                    lineNumber:lineNr.
                ].
            ].
            (showOnly notNil and:[showOnly ~~ #variables]) ifTrue:[^ nil].
            self hideVariables == true ifTrue:[ ^ nil ].
            ^ Tag::TVariable 
                            label:nm 
                            pattern:nil
                            type:nil
                            lineNumber:lineNr.
        ].
        ^ nil
    ].

    def = 'defun' ifTrue:[
        (showOnly notNil and:[showOnly ~~ #functions]) ifTrue:[^ nil].
        self hideFunctions == true ifTrue:[ ^ nil ].

        ^ Tag::TFunction 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    def = 'defvar' ifTrue:[
        (showOnly notNil and:[showOnly ~~ #variables]) ifTrue:[^ nil].
        self hideVariables == true ifTrue:[ ^ nil ].
        ^ Tag::TVariable 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    def = 'set' ifTrue:[
        self hideVariables == true ifTrue:[ ^ nil ].
        ^ Tag::TVariable 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    (def = 'defconstant' or:[def = 'define-constant' or:[def = 'constant']]) ifTrue:[
        (showOnly notNil and:[showOnly ~~ #constants]) ifTrue:[^ nil].
        self hideLispConstants == true ifTrue:[ ^ nil ].
        ^ Tag::TLispConstant 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    (def = 'mac' or:[def = 'defmacro' or:[def = 'define-macro']]) ifTrue:[
        (showOnly notNil and:[showOnly ~~ #macros]) ifTrue:[^ nil].
        self hideLispMacros == true ifTrue:[ ^ nil ].
        ^ Tag::TLispMacro 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    (def = 'defclass' or:[def = 'define-class']) ifTrue:[
        (showOnly notNil and:[showOnly ~~ #classes]) ifTrue:[^ nil].
        self hideClasses == true ifTrue:[ ^ nil ].
        ^ Tag::TClass 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    (def = 'defmethod' or:[def = 'define-method' or:[def = 'define-generic']]) ifTrue:[
        (showOnly notNil and:[showOnly ~~ #methods]) ifTrue:[^ nil].
        self hideLispMethods == true ifTrue:[ ^ nil ].
        ^ Tag::TMethod 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    (def = 'defpackage') ifTrue:[
        self hideLispMethods == true ifTrue:[ ^ nil ].
        ^ Tag::TPackage 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    def = 'eval-when' ifTrue:[
        self hideLispEvaluations == true ifTrue:[ ^ nil ].
        ^ Tag::TLispEval 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    def = 'defstruct' ifTrue:[
        self hideStructures == true ifTrue:[ ^ nil ].
        ^ Tag::TStruct 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    (def startsWith:'def') ifTrue:[
        (showOnly notNil and:[showOnly ~~ #functions]) ifTrue:[^ nil].
        self hideFunctions == true ifTrue:[ ^ nil ].
        ^ Tag::TFunction 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].
    ^ nil

    "Modified: / 08-05-2011 / 10:57:03 / cg"
!

lispTagsInFile:aFilePath
    "lisp tags:
     naive, q&d scan for lines starting with (not syntax-aware):
        (define ...
        (defun ...
        (defvar ...
        (defmacro ...
        (defclass ...
        (defmethod ...
        (defpackage ...
        (eval-when ...
        (define- ...
        (def* ...
        (set ...
        (constant ...
        (defconstant ...
        ;;; moretext     documentation
    "

    ^ self
        linewiseNaiveTagsInFile:aFilePath 
        using:[:line :lineNr |
                self lispTagFromLine:line lineNr:lineNr
              ]

    "Modified: / 08-05-2011 / 10:12:29 / cg"
!

luaTagFromLine:line lineNr:lineNr
    "lua tags:
     naive, q&d scan for lines starting with (not syntax-aware):
        local function ...
    "

    |l nm words def isLocal|

    l := line withoutSeparators.

    (l startsWith:'--') ifTrue:[^ nil].     "/ comment  

    words := l splitByAny:(' (),',Character tab).
    words size >= 2 ifFalse:[^ nil].

    (isLocal := words first = 'local') ifTrue:[ words := words copyFrom:2 ].
    words size <= 2 ifTrue:[ ^ nil ]. 
    def := words first.
    nm := words second.

    def = 'function' ifTrue:[
        (showOnly notNil and:[showOnly ~~ #functions]) ifTrue:[^ nil].
        self hideFunctions == true ifTrue:[ ^ nil ].
        ^ Tag::TFunction 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
    ].

    isLocal ifTrue:[
        (words includes:'=') ifTrue:[
            words := words copyTo:(words indexOf:'=')-1
        ].
        ^ words 
            collect:[:eachVar |
                Tag::TVariable 
                            label:eachVar 
                            pattern:nil
                            type:nil
                            lineNumber:lineNr.
            ]
            as:Array.
    ].

    ^ nil
!

luaTagsInFile:aFilePath
    "lua tags:
     naive, q&d scan for lines starting with (not syntax-aware):
        local function ...
    "

    ^ self
        linewiseNaiveTagsInFile:aFilePath 
        using:[:line :lineNr |
                self luaTagFromLine:line lineNr:lineNr
              ]
!

objcTagFromLine:line lineNr:lineNr
    "objc tags:
     naive, q&d scan for lines starting with some common patterns"

    |l nm lineStream kwLen type hideHolder skipType|

    l := line withoutSeparators.
    skipType := false.
    
    (l startsWith:'@interface') ifTrue:[
        kwLen := '@interface' size.
        type := Tag::TInterface.
        hideHolder := self hideObjcClasses.
    ].
    (l startsWith:'@implementation') ifTrue:[
        kwLen := '@implementation' size.
        type := Tag::TClass.
        hideHolder := self hideObjcClasses.
    ].
    (l startsWith:'@property') ifTrue:[
        kwLen := '@property' size.
        type := Tag::TMacro.
    ].
    (l startsWithAnyOf:'+-') ifTrue:[
        kwLen := 1.
        type := Tag::TMethod.
        hideHolder := self hideObjcMethods.
        skipType := true.
    ].
    hideHolder value ~~ true ifTrue:[
        kwLen notNil ifTrue:[
            lineStream := l readStream.
            lineStream skip:kwLen; skipSeparators.
            skipType ifTrue:[
                lineStream peek == $( ifTrue:[
                    lineStream next. lineStream skipThrough:$).
                    lineStream skipSeparators.
                ].    
            ].
            
            nm := lineStream upToElementForWhich:[:ch | (ch isLetterOrDigit or:['_' includes:ch]) not].
            (nm notEmpty and:[nm first isLetterOrUnderline]) ifTrue:[    
                ^ type 
                                label:nm 
                                pattern:nil
                                type:nil
                                lineNumber:lineNr.
            ]
        ].
    ].
    
    ^ nil
!

objcTagsInFile:aFilePath
    "objc tags:
     naive, q&d scan for lines starting with some wellknown patterns"

    ^ self
        linewiseNaiveTagsInFile:aFilePath 
        using:[:line :lineNr |
                self objcTagFromLine:line lineNr:lineNr
              ]
!

ozTagFromLine:line lineNr:lineNr
    "oz tags:
     naive, q&d scan for lines starting with:
        fun { name ...
    "

    |l nm lineStream kwLen skipBrace type hideHolder|

    l := line withoutSeparators.

    kwLen := nil.
    skipBrace := false.

    (l startsWith:'class') ifTrue:[
        kwLen := 5.
        type := Tag::TClass.
        hideHolder := self hideOzClasses.
    ].
    (l startsWith:'meth') ifTrue:[
        kwLen := 4.
        type := Tag::TMethod.
        hideHolder := self hideOzMethods.
    ].
    (l startsWith:'fun') ifTrue:[
        kwLen := 3.
        skipBrace := true.
        type := Tag::TFunction.
        hideHolder := self hideOzFunctions.
    ].
    (l startsWith:'proc') ifTrue:[
        kwLen := 4.
        skipBrace := true.
        type := Tag::TFunction.
        hideHolder := self hideOzFunctions.
    ].
    hideHolder value ~~ true ifTrue:[
        kwLen notNil ifTrue:[
            lineStream := l readStream.
            lineStream skip:kwLen; skipSeparators.

            (skipBrace not or:[lineStream peek = ${ ]) ifTrue:[
                skipBrace ifTrue:[lineStream skip:1; skipSeparators].  
                nm := lineStream upToElementForWhich:[:ch | (ch isLetterOrDigit or:['_' includes:ch]) not].
                (nm notEmpty and:[nm first isLetterOrUnderline]) ifTrue:[    
                    ^ type 
                                    label:nm 
                                    pattern:nil
                                    type:nil
                                    lineNumber:lineNr.
                ]
            ]
        ].
    ].
    ^ nil
!

ozTagsInFile:aFilePath
    "oz tags:
     naive, q&d scan for lines starting with:
        fun { name ...
    "

    ^ self
        linewiseNaiveTagsInFile:aFilePath 
        using:[:line :lineNr |
                self ozTagFromLine:line lineNr:lineNr
              ]
!

phpTagFromLine:line lineNr:lineNr
    "php tags:
     naive, q&d scan for lines starting with:
        var ...
        class ...
        function ...
    "

    |l nm lineStream|

    l := line withoutSeparators.
    (l startsWith:'public ') ifTrue:[ l := (l copyFrom:'public ' size + 1) withoutSeparators ].
    (l startsWith:'private ') ifTrue:[ l := (l copyFrom:'private ' size + 1) withoutSeparators ].

    (l startsWith:'var ') ifTrue:[
        lineStream := (l copyFrom:'var ' size) readStream.
        lineStream skipSeparators.
        lineStream peek == $$ ifTrue:[
            lineStream next.
            nm := lineStream 
                    nextMatching:[:c | c isLetter] 
                    thenMatching:[:c | c isLetterOrDigit or:[c == $_]].
            ^ (Tag::TVariable 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr).
        ]
    ] ifFalse:[
        ((l startsWith:'class ') or:[l startsWith:'Class '])ifTrue:[
            lineStream := (l copyFrom:'class ' size) readStream.
            lineStream skipSeparators.
            nm := lineStream 
                    nextMatching:[:c | c isLetter] 
                    thenMatching:[:c | c isLetterOrDigit or:[c == $_]].
            ^ (Tag::TClass 
                            label:nm 
                            pattern:nil
                            type:nil
                            lineNumber:lineNr).
        ] ifFalse:[
            ((l startsWith:'function ') or:[l startsWith:'Function ']) ifTrue:[
                lineStream := (l copyFrom:'function ' size) readStream.
                lineStream skipSeparators.
                nm := lineStream 
                        nextMatching:[:c | c isLetter or:[c == $_]] 
                        thenMatching:[:c | c isLetterOrDigit or:[c == $_]].
                 ^ (Tag::TFunction
                                label:nm 
                                pattern:nil
                                type:nil
                                lineNumber:lineNr).
            ].
        ].
    ].
    ^ nil
!

phpTagsInFile:aFilePath
    "php tags:
     naive, q&d scan for lines starting with:
        var ...
        class ...
        function ...
    "

    ^ self
        linewiseNaiveTagsInFile:aFilePath 
        using:[:line :lineNr |
                self phpTagFromLine:line lineNr:lineNr
              ]
!

prologTagFromLine:line lineNr:lineNr
    "prolog tags:
     naive, q&d scan for lines matching:
        <anything> :-
    "

    |l nm|

    l := line withoutSeparators.

    (l includesString:':-') ifTrue:[
        (l startsWith:':-') ifFalse:[
            nm := l copyTo:(l indexOfSubCollection:':-').
            ^ (Tag::TPrologClause 
                            label:nm 
                            pattern:nil
                            type:nil
                            lineNumber:lineNr).
        ]
    ].
    ^ nil
!

prologTagsInFile:aFilePath
    "prolog tags:
     naive, q&d scan for lines matching:
        <anything> :-
    "

    ^ self
        linewiseNaiveTagsInFile:aFilePath 
        using:[:line :lineNr |
                self prologTagFromLine:line lineNr:lineNr
              ]
!

pythonTagsInFile:aFilePath
    "python tags:
     naive, q&d scan for lines matching
        class <anything> :
     or
        def <anything> :
    "

    |targets line l lineNr nm s inClass indent classIndent|

    Tag autoload.

    inClass := nil.
    targets := OrderedCollection new.
    s := aFilePath asFilename readStream.
    inClass := OrderedCollection new.
    classIndent := 0.

    s notNil ifTrue:[
        s := LineNumberReadStream readingFrom:s.
        [s atEnd] whileFalse:[
            lineNr := s lineNumber.
            line := s nextLine.
            l := line withoutSeparators.
            l size > 0 ifTrue:[

                line := line withTabsExpanded:8.
                indent := line findFirst:[:c | c ~~ Character space].
                indent := indent // 8.
                indent < classIndent ifTrue:[
                    inClass removeFirstIfAbsent:nil.
                    classIndent := classIndent - 1.
                ].

                (l startsWith:'class ') ifTrue:[
                    (l endsWith:':') ifTrue:[
                        nm := l copyFrom:7 to:(l size - 1).
                        nm := nm withoutSeparators.
                        (showOnly ~~ #pythonFunctions
                        and:[showOnly ~~ #pythonMethods]) ifTrue:[
                            self hidePythonClasses ~~ true ifTrue:[
                                targets add:(Tag::TClass 
                                                label:nm 
                                                pattern:nil
                                                type:nil
                                                lineNumber:lineNr).
                            ].
                        ].
                        nm := nm upTo:$(.
                        inClass addFirst:nm.
                        classIndent := indent + 1.
                    ]
                ] ifFalse:[
                    (l startsWith:'def ') ifTrue:[
                        (l endsWith:':') ifTrue:[
                            nm := l copyFrom:5 to:(l size - 1).
                            nm := nm withoutSeparators.

                            inClass size > 0 ifTrue:[
                                (showOnly ~~ #pythonFunctions
                                and:[showOnly ~~ #pythonClasses]) ifTrue:[
                                    self hidePythonMethods ~~ true ifTrue:[
                                        nm := inClass first , '.' , nm.
                                        targets add:(Tag::TMethod 
                                                        label:nm 
                                                        pattern:nil
                                                        type:nil
                                                        lineNumber:lineNr).
                                    ]
                                ]
                            ] ifFalse:[
                                (showOnly ~~ #pythonClasses
                                and:[showOnly ~~ #pythonMethods]) ifTrue:[
                                    self hidePythonFunctions ~~ true ifTrue:[
                                        targets add:(Tag::TFunction 
                                                        label:nm 
                                                        pattern:nil
                                                        type:nil
                                                        lineNumber:lineNr).
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ].
        s close
    ].
    ^ targets

    "Modified: / 08-05-2011 / 10:39:10 / cg"
!

rubyTagFromLine:line lineNr:lineNr
    "ruby tags:
     naive, q&d scan for lines matching:
        def any
    "

    |l nm|

    l := line withoutSeparators.

    (l startsWith:'def ') ifTrue:[
        nm := l copyFrom:5.
        ^ (Tag::TFunction 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr).
    ] ifFalse:[
        (l startsWith:'class ') ifTrue:[
            self hideClasses == true ifFalse:[
                nm := l copyFrom:6.
                ^ (Tag::TClass 
                                label:nm 
                                pattern:nil
                                type:nil
                                lineNumber:lineNr).
            ]
        ].
    ].
    ^ nil

    "Modified: / 08-05-2011 / 10:38:44 / cg"
!

rubyTagsInFile:aFilePath
    "ruby tags:
     naive, q&d scan for lines matching:
        def any
    "

    ^ self
        linewiseNaiveTagsInFile:aFilePath 
        using:[:line :lineNr |
                self rubyTagFromLine:line lineNr:lineNr
              ]

    "Modified: / 08-05-2011 / 10:38:44 / cg"
!

stTagsInFile:aFilePath in:aTempDirectory
    "smalltalk tags:
     not so naive: generate a changeList from the contents and convert it into a tag-list
    "

    |targets s anyPrimitiveDefinitions shellCmd cTagsList|

    Tag autoload.

    anyPrimitiveDefinitions := false.
    targets := OrderedCollection new.
    s := aFilePath asFilename readStream.
    s notNil ifTrue:[
        s := LineNumberReadStream readingFrom:s.
        s skipSeparators.

        "/ new interface: block-arg to #changesFromStream:do: gets 3 args
        [
            ChangeSet::InvalidChangeChunkError handle:[:ex |
                Dialog warn:('TagList [info]: Error while processing changes in "%1":\\%2' withCRs
                                bindWith:aFilePath asFilename pathName
                                with: ex description).
            ] do:[
                ChangeSet changesFromStream:s do:[:aChange :lNr :pos|
                    aChange isClassDefinitionChange ifTrue:[
                        self hideClasses == true ifFalse:[
                            targets add:(Tag::TClass 
                                        label:(aChange className) 
                                        pattern:('/subclass:')
                                        type:nil
                                        lineNumber:lNr).
                        ]
                    ] ifFalse:[
                        aChange isMethodChange ifTrue:[
                            self hideMethods == true ifFalse:[
                                targets add:((Tag::TMethod
                                            label:(aChange selector) 
                                            pattern:('/^' , aChange selector)
                                            type:nil
                                            lineNumber:lNr)
                                                isMeta:(aChange className endsWith:' class')).
                            ]
                        ] ifFalse:[
                            aChange isPrimitiveChange ifTrue:[
                                targets add:(Tag::TMacro
                                            label:(aChange isPrimitiveDefinitionsChange
                                                        ifTrue:['<< primitive definitions >>']
                                                        ifFalse:[ (aChange isPrimitiveFunctionsChange
                                                                    ifTrue:['<< primitive functions >>']
                                                                    ifFalse:['<< primitive variables >>'])])
                                            pattern:('/^' , aChange source asStringCollection first)
                                            type:nil
                                            lineNumber:lNr).
                                anyPrimitiveDefinitions := true
                            ]
                        ]
                    ].
                ]
            ]
        ] ensure:[
            s close.
        ].
    ].

    anyPrimitiveDefinitions ifTrue:[
        "/ also invoke ctags on the file, merge those tags.
        "/ sorry: not perfect, because ctags seems to get confused by the extra %{ %} nesting.
        shellCmd := (self shellCommandTemplateFor:(aFilePath asFilename withSuffix:'c') pathName)
                        bindWith:aFilePath.
        shellCmd notNil ifTrue:[
            cTagsList := self getTagListFromFile:aFilePath asFilename usingCommand:shellCmd mode:#c in:aTempDirectory.
            cTagsList notEmptyOrNil ifTrue:[
                ^ cTagsList , targets
            ].
        ].
    ].

    ^ targets

    "Created: / 05-01-2012 / 10:56:26 / cg"
!

stxResourceTagsInFile:aFilePath
    "resource tags:
     scan for translated entries to show them alphabetically"

    |rsrcPack|

    rsrcPack := ResourcePack fromFile:aFilePath.
    ^ self
        linewiseNaiveTagsInFile:aFilePath 
        using:[:rawLine :lineNr |
            |line key tag|

            line := rawLine withoutSeparators.
            (line isEmpty or:[line startsWithAnyOf:'#;']) ifFalse:[
                (line startsWith:$') ifTrue:[
                    "read as smalltalk string"
                    key := String readFrom:line.
                ] ifFalse:[
                    key := line upToSeparator.
                ].
                (rsrcPack includesKey:key) ifTrue:[
                    tag := Tag::TLabel 
                        label:key 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr.
                ]
            ].
            tag
        ].
!

tclTagFromLine:line lineNr:lineNr
    "tcl tags:
     naive, q&d scan for lines matching:
        proc any
    "

    |l nm words|

    l := line withoutSeparators.

    (l startsWith:'proc ') ifTrue:[
        nm := l withoutPrefix:'proc '.
        ^(Tag::TFunction 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr).
    ] ifFalse:[ (l startsWith:'tixWidgetClass ') ifTrue:[
        nm := l copyFrom:'tixWidgetClass ' size + 1.
        (nm endsWith:'{') ifTrue:[
            nm := (nm copyButLast) withoutSeparators.
        ].
        ^(Tag::TClass 
                        label:nm 
                        pattern:nil
                        type:nil
                        lineNumber:lineNr).
    ] ifFalse:[ (l startsWith:'set ') ifTrue:[
        self hideVariables ~~ true ifTrue:[
            words := l asCollectionOfWords.
            words size >= 2 ifTrue:[
                nm := words second.
                ^(Tag::TVariable 
                                label:nm 
                                pattern:nil
                                type:nil
                                lineNumber:lineNr).
        ]
    ]]]].
    ^ nil
!

tclTagsInFile:aFilePath
    "tcl tags:
     naive, q&d scan for lines matching:
        proc any
    "

    ^ self
        linewiseNaiveTagsInFile:aFilePath 
        using:[:line :lineNr |
                self tclTagFromLine:line lineNr:lineNr
              ]
!

xsdTagFromLine:line lineNr:lineNr
    "xsd schema tags:
     naive, q&d scan for lines matching:
        <xsd:complexType...
        <xsd:simpleType ...
     Should be replaced by a more sophisticated reader, which parses the xml first.    
    "

    |l nm i1 i2|

    l := line withoutSeparators.

    ((l includesString:':complexType ') or:[l includesString:':simpleType ']) ifTrue:[
        i1 := l findString:'name="'.        
        i1 ~~ 0 ifTrue:[
            nm := l copyFrom:(i1 + 'name="' size).
            i2 := nm indexOf:$".
            nm := nm copyTo:i2-1.
            ^(Tag::TTypedef 
                            label:nm 
                            pattern:nil
                            type:nil
                            lineNumber:lineNr).
        ].
    ].
    (l includesString:':element ') ifTrue:[
        i1 := l findString:'name="'.        
        i1 ~~ 0 ifTrue:[
            nm := l copyFrom:(i1 + 'name="' size).
            i2 := nm indexOf:$".
            nm := nm copyTo:i2-1.
            ^(Tag::TElement 
                            label:nm 
                            pattern:nil
                            type:nil
                            lineNumber:lineNr).
        ].
    ].
    ^ nil
!

xsdTagsInFile:aFilePath
    "xsd tags:
     naive, q&d scan for lines matching:
        <xsd:complexType...
        <xsd:simpleType ...
     Should be replaced by a more sophisticated reader, which parses the xml first.    
    "

    ^ self
        linewiseNaiveTagsInFile:aFilePath 
        using:[:line :lineNr |
                self xsdTagFromLine:line lineNr:lineNr
              ]
!

yaccTagsInFile:aFilePath
    "yacc tags:
     naive, q&d scan for lines matching:
        <anything>:
    "

    ^ self tagsForLinesStartingWithIdentifierAndColon:aFilePath

    "Modified: / 28-09-2012 / 14:45:52 / cg"
! !

!TagList methodsFor:'testing'!

supportsFile:aFile
    "return true, if we can generate tags for a file"

    aFile isReadable ifFalse:[^ false].

    "/ cg: now always return true - let generateTag run against the wall...
    ^ true.

"/    lcSuffix := aFile suffix asLowercase.
"/    selfClass := self class.
"/
"/    lcSuffix size ~~ 0 ifTrue:[
"/        ((selfClass isCSuffix:lcSuffix) 
"/        or:[(selfClass isJavaSuffix:lcSuffix)
"/        or:[(selfClass isEiffelSuffix:lcSuffix)
"/        or:[(selfClass isFortranSuffix:lcSuffix)
"/        or:[(selfClass isPythonSuffix:lcSuffix)
"/        or:[(selfClass isLispSuffix:lcSuffix)
"/        or:[(selfClass isPrologSuffix:lcSuffix)
"/        or:[(selfClass isTCLSuffix:lcSuffix)
"/        or:[(selfClass isAssemblerSuffix:lcSuffix)
"/        or:[(selfClass isSmalltalkSuffix:lcSuffix)
"/        or:[(selfClass isRubySuffix:lcSuffix)]]]]]]]]]])
"/        ifTrue:[
"/            ^ true
"/        ].
"/    ].
"/
"/    lcName := aFile baseName asLowercase.
"/    ^ selfClass makeFilePatterns contains:[:pattern | pattern match:lcName]
! !

!TagList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

