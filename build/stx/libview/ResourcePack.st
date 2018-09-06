"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

Dictionary subclass:#ResourcePack
	instanceVariableNames:'packsClassName packsFileName fileReadFailed superPack projectPack
		usedKeys'
	classVariableNames:'Packs FailedToLoadPacks DebugModifications
		KeepStatisticsOnUsedKeys'
	poolDictionaries:''
	category:'Interface-Internationalization'
!

!ResourcePack class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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
    This class supports easy customization of smalltalk code (i.e. internationalization
    and viewStyle adaption).
    ResourcePacks are class specific, meaning that every subclass of View
    and ApplicationModel has an instance of ResourcePack (instVar called 'resources')
    which is created when the first instance of the view/app is created,
    and cached in a class-instVar (so the file is only read once).

    The resourcePack consists of a mapping from strings to values, which are
    then used in labels, buttons, menus etc.
    The resourcePack initializes itself from a file found in 'resources/<className>.rs',
    where 'className' is built by the usual abbreviation mechanism (see abbrev-files).

    Conditional mappings are possible, by including lines as:
        #if <expression>
        #endif
    in the resourcefile. Example:
    file 'foo.rs':
        #if Language == #de
        'abort' 'Abbruch'
        #endif
        #if Language == #fr
        'abort' 'canceller'
        #endif

    the corresponding resource-strings are accessed (from methods within the class)
    using:
        resources string:'abort'

    returning the mapped string (i.e. 'Abbruch' if the global Language is set
    to #de)..

    If no corresponding entry is found in the resources, the key is returned;
    alternatively, use:
        resources string:'foo' default:'bar'
    which returns 'bar', if no resource definition for 'foo' is found.

    Translations can also include arguments, such as:
        resources string:'really delete %1' with:fileName

    This scheme has the advantage, that you can write your programs using your
    native language strings. Later, when new languages are to be supported,
    simply create a resource file for the class and add translations for
    all those strings. (find the keys by looking at users of resource or senders
    of 'string:*').
    Notice, that the grammar of different languages may imply a reordering,
    so the above string becomes the german 'wollen Sie %1 wirklich löschen';
    so using percent-placeholders is much better than simple concatenations of
    arguments to the question.

    More languages can be added later without any change in the code, or recompilation
    or the like. Even by people without access to the source code (i.e. which only have the
    applications binary).

    Also, unsupported languages' strings are simply left unchanged - if you
    write your application in (say) english, and only plan to use it in english,
    no additional work is required (i.e you don't even need a resource file then).
    Strings for unknown languages will come in english
    (which is better than nothing or empty button labels ;-)

    Notice, that you can also translate english to english, by providing an en.rs file.
    This is sometimes useful to fix typing errors or bad syntax in the english,
    as sometimes made by the programmer, without a need to recompile or to also adjust other
    language translations.

    Finally, this scheme is also compatible to a pure enum-key based translation mechanism,
    as typically used in the C-world.
    Simple use keys as argument, and provide translations for all languages (incl. english).
    For example:
        Button label:(resources string:#BTN_FOO_LABEL)


    Summary:
        in subclasses of View and ApplicationModel, instead of writing:

                ...
                b := Button label:'press me'
                ...

        always write:

                ...
                b := Button label:(resources string:'press me')
                ...

        if your class is not a subclass of one of the above, AND you need
        resource translations, you won't inherit the resources variable
        (which is automatically initialized).
        In this case, you have to ask the ResourcePack class explicitely for
        a corresponding package:

                ResourcePack for:aClassName
        or (even better):
                ResourcePack forPackage:aPackageID

        as an example, see how the Date class gets the national names of
        week & monthnames.

    Debugging:
        in the past, it happened that strings as returned by me were modified by someone else
        (replaceAll:with:) and then lead to invalid presentation in the future.
        To detect any bad guy which writes into one of my returned strings, set the DebugModifications
        classVar to true. Then I will return ImmutableStrings which trap on writes.

    [author:]
        Claus Gittinger
"
!

examples
"
    normally, resources are found in files named after their classes sourcefile
    For example, the FileBrowsers resources are found in 'FBrowser.rs'.
    For the examples below, we process resources from a constant string;
	this is NOT representative.
									[exBegin]
	|stream res|

	stream := ReadStream on:'
foo  ''the translation for foo''
#if Language == #de
bar  ''die deutsche uebersetzung von bar''
baz  ''baz hat den Wert %1''
#endif
#if Language == #fr
bar  ''bar en francaise''
baz  ''%1, c''''est baz''
#endif

'.

	res := ResourcePack new readFromResourceStream:stream in:nil.

	Transcript showCR:'baz is translated to: ' , (res string:'baz' with:'1234').
	Transcript showCR:'bar is translated to: ' , (res string:'bar').
	Transcript showCR:'foo is translated to: ' , (res string:'foo').
	Transcript showCR:'fooBar is translated to: ' , (res string:'fooBar').
									[exEnd]
    set the Language to french:
									[exBegin]
	Language := #fr
									[exEnd]
    and repeat the above.
    back to english:
									[exBegin]
	Language := #en
									[exEnd]
    back to german:
									[exBegin]
	Language := #de
									[exEnd]
"
! !

!ResourcePack class methodsFor:'initialization'!

flushCachedResourcePacks
    "forget all cached resources - needed after a style change"

    Packs := nil.
    self initialize

    "
     ResourcePack flushCachedResourcePacks
    "
!

initialize
    Packs isNil ifTrue:[
	Packs := WeakArray new:100.
	FailedToLoadPacks := Set new.
    ].

    "
     ResourcePack initialize
    "

    "Modified: / 28-09-2011 / 15:53:21 / cg"
! !

!ResourcePack class methodsFor:'instance creation'!

for:aClass
    "get the full resource definitions for aClass (i.e. with super packs).
     Also leave the resulting pack in the cache for faster access next time."

    ^ self for:aClass cached:false

    "
     ResourcePack for:TextView
     ResourcePack for:CodeView
     ResourcePack for:Workspace
     ResourcePack for:View
     ResourcePack for:ErrorLogger
     ResourcePack for:NewLauncher
     ResourcePack for:SmallSense::SettingsAppl
     Workspace classResources
    "

    "Modified: / 18-09-2006 / 19:02:57 / cg"
!

for:aClass cached:cached
    "get the full resource definitions for aClass (i.e. with super packs).
     Also leave the resulting pack in the cache for faster access next time."

    |nm pack rsrcDir baseName|

    nm := aClass resourcePackName.
    cached ifTrue:[
        pack := self searchCacheFor:nm.
        pack notNil ifTrue:[^ pack].
    ].

    baseName := (Smalltalk fileNameForClass:nm) , '.rs'.
    rsrcDir := aClass resourceDirectory.

"/ CHECK this
"/    (rsrcDir notNil and:[rsrcDir suffix = 'rs']) ifTrue:[
"/        baseName := (Smalltalk fileNameForClass: rsrcDir tail asFilename withoutSuffix pathName),'.rs'.
"/        rsrcDir := rsrcDir head asFilename.
"/    ].

    rsrcDir notNil ifTrue:[
        pack := self new.
        rsrcDir exists ifTrue:[
            (rsrcDir construct:baseName) exists ifTrue:[
                pack := self fromFile:baseName directory:(rsrcDir name) cached:cached.
            ].
        ]
    ] ifFalse:[
        pack := self fromFile:baseName directory:'resources' cached:cached.
    ].
    aClass superclass notNil ifTrue:[
        pack superPack:(self for:(aClass superclass) cached:cached).
    ].
    pack packsClassOrFileName:nm.
    cached ifTrue:[
        self addToCache:pack.
    ].
    pack projectPack:(self forPackage:(aClass resourcePackage) cached:cached).
    ^ pack

    "
     ResourcePack forPackage:'bosch:dapasx' cached:true

     ResourcePack for:TextView
     ResourcePack for:CodeView
     ResourcePack for:Workspace
     ResourcePack for:View
     ResourcePack for:ErrorLogger
     ResourcePack for:NewLauncher
     Workspace classResources
    "

    "Modified: / 01-11-2010 / 09:09:43 / cg"
!

forPackage:package
    "get the full resource definitions given a package id (such as stx:libbasic').
     Also leave the resulting pack in the cache for faster access next time."

    ^ self forPackage:package cached:true

    "
     ResourcePack forPackage:'stx:libbasic'
     ResourcePack forPackage:'stx:libtool'
    "

    "Modified: / 18-09-2006 / 18:45:31 / cg"
!

forPackage:package cached:cached
    "get the full resource definitions given a package id (such as stx:libbasic').
     Also optionally leave the resulting pack in the cache for faster access next time."

    ^ self forPackage:package resourceFileName:'resources.rs' cached:cached

    "
     ResourcePack forPackage:'stx:libbasic' cached:false
    "

    "Modified: / 19-10-2006 / 23:18:28 / cg"
!

forPackage:package resourceFileName:resourceFileName cached:cached
    "get the full resource definitions given a package id (such as stx:libbasic').
     Also optionally leave the resulting pack in the cache for faster access next time.
     Remember failed packs, to avoid retrying reading the file again and again"

    |fullName pack rsrcDir file|

    fullName := package , '/resources/',resourceFileName.

    cached ifTrue:[
	pack := self searchCacheFor:fullName.
	pack notNil ifTrue:[^ pack].
	(FailedToLoadPacks includes:fullName) ifTrue:[^ nil].
    ].

    rsrcDir := Smalltalk projectDirectoryForPackage:package.
    rsrcDir isNil ifTrue:[
	file := Smalltalk getResourceFileName:resourceFileName forPackage:package.
	file isNil ifTrue:[
	    FailedToLoadPacks add:fullName.
	    ^ nil
	].
	rsrcDir := file asFilename directory.
    ] ifFalse:[
	rsrcDir := rsrcDir asFilename construct:'resources'.
	rsrcDir exists ifFalse:[
	    FailedToLoadPacks add:fullName.
	    ^ nil
	].
    ].

    pack := self fromFile:resourceFileName directory:rsrcDir cached:cached.
    pack packsClassOrFileName:fullName.
    ^ pack

    "
     ResourcePack forPackage:'stx:libbasic' resourceFileName:'resources.rs' cached:false
    "

    "Modified: / 28-09-2011 / 15:55:30 / cg"
!

fromFile:aFileName
    "get the resource definitions from a file in the default directory."

    ^ self fromFile:aFileName directory:'resources'

    "
     ResourcePack fromFile:'SBrowser.rs'
     ResourcePack fromFile:'FBrowser.rs'
     ResourcePack fromFile:'Smalltalk.rs'
     ResourcePack fromFile:'Smalltalk.rs' asFilename
     ResourcePack fromFile:'../../libtool/resources/AboutBox_ru.rs' asFilename
    "
!

fromFile:aFileName directory:dirName
    "get the resource definitions from a file in a directory."

    ^ self fromFile:aFileName directory:dirName cached:false
!

fromFile:aFileName directory:dirName cached:cached
    "get the resource definitions from a file in a directory.
     Uncached low-level entry."

    |newPack|

    newPack := self new.
    KeepStatisticsOnUsedKeys == true ifTrue:[
        newPack rememberUsedKeys.
    ].        
    newPack readFromFile:aFileName directory:dirName.
    cached ifTrue:[
        self addToCache:newPack.
    ].
    ^ newPack
! !

!ResourcePack class methodsFor:'private'!

addToCache:aPack
    |idx|

    Packs isNil ifTrue:[
	self initialize.
    ].

    idx := Packs identityIndexOf:nil.
    idx == 0 ifTrue:[
	idx := Packs findFirst:[:slot | slot class == SmallInteger].
    ].
    idx == 0 ifTrue:[
	"
	 throw away oldest
	"
	idx := Packs size.
	Packs replaceFrom:1 to:idx-1 with:Packs startingAt:2.
    ].
    aPack at:'__language__' put:(UserPreferences current language,'_',UserPreferences current languageTerritory).
    Packs at:idx put:aPack.

    "Modified: / 18-09-2006 / 19:12:12 / cg"
!

searchCacheFor:aClassOrFileName
    |sz "{ Class: SmallInteger }" lang|

    Packs isNil ifTrue:[
	self initialize.
	^ nil
    ].

    lang := (UserPreferences current language,'_',UserPreferences current languageTerritory).

    sz := Packs size.
    1 to:sz do:[:idx |
	|aPack|

	aPack := Packs at:idx.
	(aPack notNil and:[aPack class ~~ SmallInteger]) ifTrue:[
	    (aPack at:'__language__' ifAbsent:nil) = lang ifTrue:[
		aClassOrFileName = aPack packsClassOrFileName ifTrue:[
		    "
		     bring to front for LRU
		    "
		    idx ~~ 1 ifTrue:[
			Packs replaceFrom:2 to:idx with:Packs startingAt:1.
			Packs at:1 put:aPack.
		    ].
		    ^ aPack
		]
	    ]
	]
    ].
    ^ nil

    "
     ResourcePack searchCacheFor:'TextView'
    "

    "Modified: / 18-09-2006 / 19:13:13 / cg"
! !

!ResourcePack class methodsFor:'utilities'!

extractEncodingFromLine:lineString
    |rest encoding|

    (lineString startsWith:'encoding') ifFalse:[^ nil].

    rest := lineString copyFrom:9.
    rest := rest withoutSeparators.
    (rest startsWith:'#') ifTrue:[
	rest := rest copyFrom:2.
    ].
    (rest startsWith:'''') ifTrue:[
	rest := rest copyFrom:2.
	(rest endsWith:'''') ifTrue:[
	    rest := rest copyButLast:1.
	].
    ].
    encoding := rest asSymbol.
    ^ encoding.
!

processResourceLine:lineString encoding:encodingSymbolOrEncoder file:fileName printErrorWith:printError for:aResourcePack
    "process a single valid line (i.e. #ifdef & #include has already been processed)"

    self
	processResourceLine:lineString encoding:encodingSymbolOrEncoder file:fileName printErrorWith:printError for:aResourcePack
	keepUselessTranslations:false.
!

processResourceLine:lineString encoding:encodingSymbolOrEncoder file:fileName printErrorWith:printError for:aResourcePack keepUselessTranslations:keepUselessTranslations
    "process a single valid line (i.e. #ifdef & #include has already been processed)"

    |name lineStream idx rest macroName value
     conditional hasError decoder oldValue ignoreTranslation indirect|

    "/ Transcript showCR:lineString.
    encodingSymbolOrEncoder notNil ifTrue:[
	encodingSymbolOrEncoder isSymbol ifTrue:[
	    decoder := CharacterEncoder encoderFor:encodingSymbolOrEncoder ifAbsent:nil.
	    decoder isNil ifTrue:[ decoder := CharacterEncoder nullEncoderInstance ].
	] ifFalse:[
	    decoder := encodingSymbolOrEncoder
	].
    ].

    decoder notNil ifTrue:[
	lineStream := (decoder decodeString:lineString) readStream.
    ] ifFalse:[
	lineStream := lineString readStream.
    ].
    lineStream signalAtEnd:false.
    lineStream skipSeparators.

    lineStream peek == $# ifTrue:[
	name := Array
		    readFrom:lineStream
		    onError:[
				printError value:('invalid line <' , lineString , '>').
				nil
			    ].
    ] ifFalse:[
	lineStream peek == $' ifTrue:[
	    name := String
			readSmalltalkStringFrom:lineStream
			onError:[
				    printError value:('invalid line <' , lineString , '>').
				    nil
				].
	] ifFalse:[
	    name := lineStream upToSeparator.
	].
    ].

    name isNil ifTrue:[^ self ].

    ignoreTranslation := false.
    hasError := false.

    lineStream skipSeparators.
    idx := lineStream position + 1 + 1.

    lineStream peek == $< ifTrue:[
	"
	 skip <type> if present
	"
	lineStream skipThrough:$>.
	lineStream skipSeparators.
	idx := lineStream position + 2.
    ].

    conditional := indirect := false.
    lineStream peek == $? ifTrue:[
	conditional := true.
	lineStream next.
	lineStream skipSeparators.
    ].

    lineStream peek == $@ ifTrue:[
	indirect := true.
	lineStream next.
	lineStream skipSeparators.
    ].

    lineStream peek == $= ifTrue:[
	lineStream next.

	macroName := lineStream nextAlphaNumericWord.
	[lineStream peek == $.] whileTrue:[
	    lineStream next.
	    lineStream peek notNil ifTrue:[
		macroName := macroName , '.' , (lineStream nextAlphaNumericWord)
	    ]
	].
	rest := lineStream upToEnd.
	value := aResourcePack at:macroName ifAbsent:nil.
	(value isNil) ifTrue:[
	    hasError := true.
	    printError value:('bad (nil-valued) macro: ' , macroName).
	].
"/        value isBlock ifTrue:[
"/            value := value value
"/        ].
	rest isBlank ifFalse:[
	    value := Compiler evaluate:('self ' , rest)
			      receiver:value
			      notifying:nil
			      compile:false.
	    (value == #Error) ifTrue:[
		hasError := true.
		printError value:('error in: "self ' , rest , '"').
	    ].
	    "/ 'self ' print. rest print. ' -> ' print. value printCR.
	]
    ] ifFalse:[
	lineStream peek == $' ifTrue:[
	    value := String
			readSmalltalkStringFrom:lineStream
			onError:[
				    printError value:('invalid line <' , lineString , '>').
				    nil
				].
	    "/ ' -> ' print. value printCR.
	] ifFalse:[
	    rest := lineStream upToEnd.
	    [
		value := Compiler evaluate:rest compile:"true" false.
	    ] on:Error do:[
		printError value:('invalid line <' , rest , '>').
		"/ value := rest
	    ].
	    "/ rest print. ' -> ' print. value printCR.
	].
	(value == #Error) ifTrue:[
	    hasError := true.
	    printError value:('error in: "' , rest , '"').
	] ifFalse:[
"/            value isString ifTrue:[
"/                decoder notNil ifTrue:[
"/                    value := decoder decodeString:value
"/                ]
"/            ]
	]
    ].

    "/ Transcript show:name; show:' -> '; showCR:value.

    hasError ifFalse:[
	(conditional not
	or:[(aResourcePack includesKey:name) not]) ifTrue:[
	    name = value ifTrue:[
		keepUselessTranslations ifFalse:[
		    printError value:('useless resource: "' , name , '"').
		    ignoreTranslation := true
		].
	    ].
	    ignoreTranslation ifFalse:[
		oldValue := aResourcePack at:name ifAbsent:nil.
		oldValue notNil ifTrue:[
		    oldValue ~= value ifTrue:[
			printError value:('conflicting resource: "' , name , '"').
			printError value:('oldValue: ' , oldValue printString).
			printError value:('newValue: ' , value printString).
		    ] ifFalse:[
			printError value:('duplicate resource: "' , name , '"').
		    ].
		].
		indirect ifTrue:[
		    value := aResourcePack string:value.
		].

		DebugModifications == true ifTrue:[
		    "/ for debugging only !! (not all primitive code is ready for immutableStrings)
		    value class == String ifTrue:[
			value := value asImmutableString.
		    ].
		].

		aResourcePack at:name put:value.
	    ]
	]
    ]

    "Modified: / 06-02-2014 / 15:33:03 / cg"
!

resourceFileEntryFor:keyString to:nationalString
    "generate a line for a translation file, which defines a translation
     from keyString to nationalString.
     Naivly, this could be a simple line containing the two storeStrings
     separated by a space. However, it is better to first cut of any leading
     and trailing spaces and special characters, such as ':*.,' etc."

    ^ (self resourceFileStringFor:keyString),' ',(self resourceFileStringFor:nationalString)
!

resourceFileStringFor:aString
    "generate a key or value entry for a translation file, for aString.
     Naivly, this could be a simple the storeString.
     However, it is better to first cut of any leading
     and trailing spaces and special characters, sch as ':*.,' etc."

    ^ (self shortenedKeyFor:aString) storeString

    "
     self resourceFileStringFor:'  foo:   '
     self resourceFileStringFor:'  foo bar:   '
    "
!

shortenedKeyFor:aKey
    "if
	  aKey is '(...)', then return '...'
	  if aKey is '[...]', then return '...'
	  if aKey is '{...}', then return '...'
	  if aKey starts or ends with any of '\:=.,?!! ', then return aKey without it

     This means, that only a single translation is required to provide local translations for
     things like
	'search'
	'search:'
	'search...'
    "

    |idx idx1 idx2 first last keySize|

    first := aKey first.
    last := aKey last.
    keySize := aKey size.

    ((first == $( and:[last == $) ])
    or:[ (first == $[ and:[last == $] ])
    or:[ (first == ${ and:[last == $} ]) ]]) ifTrue:[
	^ self shortenedKeyFor:(aKey copyFrom:2 to:keySize-1).
    ].

    idx1 := aKey findFirst:[:ch | ch isSeparator not].
    idx2 := aKey findLast:[:ch | ch isSeparator not] ifNone:keySize.
    (idx1 > 1 or:[idx2 < keySize]) ifTrue:[
	^ self shortenedKeyFor:(aKey copyFrom:idx1 to:idx2)
    ].

    idx1 := aKey findFirst:[:ch | ('*:=.?!!,-><\' includes:ch) not].
    idx2 := aKey findLast:[:ch | ('*:=.?!!,-><\' includes:ch) not] ifNone:keySize.
    (idx1 > 1 or:[idx2 < keySize]) ifTrue:[
	^ self shortenedKeyFor:(aKey copyFrom:idx1 to:idx2)
    ].

    "/ change duplicated &'s to single
    (idx := aKey indexOf:$&) ~~ 0 ifTrue:[
	(aKey at:idx+1 ifAbsent:nil) ~~ $& ifTrue:[
	    ^ self shortenedKeyFor:(aKey copyTo:idx-1),(aKey copyFrom:idx+1).
	].
    ].
    ^ aKey.

    "
     'abcde' findFirst:[:ch | 'bcd' includes:ch]
     'abcde' indexOfAny:'bcd'

     self shortenedKeyFor:'abc'
     self shortenedKeyFor:'   abc    '
     self shortenedKeyFor:'(abc)'
     self shortenedKeyFor:'abc...'
     self shortenedKeyFor:'(abc...)'
     self shortenedKeyFor:'abc:*'
    "
! !

!ResourcePack methodsFor:'accessing'!

array:anArray
    "translate a collection of strings"

    ^ anArray collect:[:r | self at:r default:r]

    "
     Launcher classResources array:#('file' 'classes')
    "

    "Modified: / 29.1.1998 / 22:44:22 / cg"
!

at:aKey
    "translate a string"

    ^ self at:aKey ifAbsent:aKey
!

at:aKey default:default
    "translate a string"

    ^ self at:aKey ifAbsent:default
!

at:aKey ifAbsent:defaultValue
    "translate a string; search here, in my projects pack and in my superpack(s)"

    |val pack projectPack alreadySearched|

    aKey isNil ifTrue:[ ^ defaultValue value ].

    val := self localAt:aKey.
    val notNil ifTrue:[^ val].

    (projectPack := self projectPack) notNil ifTrue:[
	val := projectPack localAt:aKey.
	val notNil ifTrue:[^ val].
    ].
    alreadySearched := Set new.
    projectPack notNil ifTrue:[ alreadySearched add:projectPack ].

    pack := self superPack.
    [ pack notNil ] whileTrue:[
	val := pack localAt:aKey.
	val notNil ifTrue:[^ val].

	(projectPack := pack projectPack) notNil ifTrue:[
	    (alreadySearched includes:projectPack) ifFalse:[
		val := projectPack localAt:aKey.
		val notNil ifTrue:[^ val].
		alreadySearched add:projectPack.
	    ].
	].
	pack := pack superPack
    ].

    alreadySearched copy do:[:projectPack |
	|p|

	p := projectPack superPack.
	[p notNil and:[(alreadySearched includes:p) not]] whileTrue:[
	    val := p localAt:aKey.
	    val notNil ifTrue:[^ val].
	    alreadySearched add:p.
	    p := p superPack.
	].
    ].

    ^ defaultValue value

    "Modified: / 18-09-2006 / 18:50:52 / cg"
!

localAt:aKey
    "translate a string.
     Some special 'intelligence' has been added:
	if no value for aKey is found,
	  lookup aKey with first character caseChanged and change the results first characters case.
	  or aKey is '(...)', then lookup ... wrap () around the result.
	  or aKey is '[...]', then lookup ... wrap [] around the result.
	  or aKey is '{...}', then lookup ... wrap {} around the result.
	  or aKey starts with a '\', then lookup aKey without '\' and prepend '\' to the result.
	  or aKey ends with a '\', then lookup aKey without '\' and append '\' to the result.
	  or aKey ends with a ':', then lookup aKey without ':' and append ':' to the result.
	  or aKey ends with a '=', then lookup aKey without '=' and append '=' to the result.
	  or aKey ends with a '.', then lookup aKey without '.' and append '.' to the result.
	  or aKey ends with a ',', then lookup aKey without ',' and append ',' to the result.
	  or aKey ends with a '?', then lookup aKey without '?' and append '?' to the result.
	  or aKey ends with a '!!', then lookup aKey without '!!' and append '!!' to the result.
	  or aKey ends with a ' ', then lookup aKey without ' ' and append ' ' to the result.
	  or aKey ends with a ' ...', then lookup aKey without ' ...' and append '...' to the result.
	  or aKey ends with a '...', then lookup aKey without '...' and append '...' to the result.
	  or aKey includes '&', then lookup aKey without '&'.

     This means, that only a single translation is required to provide local translations for
     things like
	'search'
	'search:'
	'search...'
    "

    |val alternativeKey usedKey idx first last|

    val := super at:aKey ifAbsent:nil.
    val notNil ifTrue:[
	^ val value
    ].

    (aKey isString and:[aKey notEmpty]) ifTrue:[
	first := aKey first.
	last := aKey last.

	"/ try with case-first swapped...
	first isLetter ifTrue:[
	    alternativeKey := first isUppercase
				ifTrue:[aKey asLowercaseFirst]
				ifFalse:[aKey asUppercaseFirst].
	    val := super at:alternativeKey ifAbsent:nil.
	    val notNil ifTrue:[
		first isUppercase ifTrue:[
		    ^ val asUppercaseFirst
		].
		^ val asLowercaseFirst.
	    ].
	].

	((first == $( and:[last == $) ])
	or:[ (first == $[ and:[last == $] ])
	or:[ (first == ${ and:[last == $} ]) ]]) ifTrue:[
	    usedKey := aKey copyFrom:2 to:aKey size-1.

	    val := self localAt:usedKey.        "/ recursion
	    val notNil ifTrue:[^ first asString,val,last asString].
	].

	last == $. ifTrue:[
	    (aKey endsWith:' ...') ifTrue:[
		usedKey := aKey copyButLast:4.

		val := self localAt:usedKey.        "/ recursion
		val notNil ifTrue:[^ val , ' ...'].
	    ].
	    (aKey endsWith:'...') ifTrue:[
		usedKey := aKey copyButLast:3.

		val := self localAt:usedKey.        "/ recursion
		val notNil ifTrue:[^ val , '...'].
	    ].
	].

	first isSeparator ifTrue:[
	    usedKey := aKey withoutLeadingSeparators.

	    val := self localAt:usedKey.        "/ recursion
	    val notNil ifTrue:[^ (aKey copyTo:(aKey size - usedKey size)), val]. "/ prepend the stripped separators
	].
	last isSeparator ifTrue:[
	    usedKey := aKey withoutTrailingSeparators.

	    val := self localAt:usedKey.        "/ recursion
	    val notNil ifTrue:[^ val, (aKey copyFrom:usedKey size + 1)].      "/ append the stripped separators
	].

	('*:=.?!!,-><\' includes:last) ifTrue:[
	    aKey size >= 2 ifTrue:[
		usedKey := aKey copyButLast:1.

		val := self localAt:usedKey.        "/ recursion
		val notNil ifTrue:[^ val copyWith:last].
	    ].
	].
	('*:=.?!!-><\' includes:first) ifTrue:[
	    aKey size >= 2 ifTrue:[
		usedKey := aKey copyFrom:2.

		val := self localAt:usedKey.        "/ recursion
		val notNil ifTrue:[^ first asString , val].
	    ].
	].

	(first == $( and:[last == $)]) ifTrue:[
	    usedKey := aKey copyFrom:2 to:(aKey size - 1).

	    val := self localAt:usedKey.        "/ recursion
	    val notNil ifTrue:[^ '(' , val , ')'].
	].

	(idx := aKey indexOf:$&) ~~ 0 ifTrue:[
	    (aKey at:idx+1 ifAbsent:nil) ~~ $& ifTrue:[
		usedKey := (aKey copyTo:idx-1) , (aKey copyFrom:idx+1).
		val := self localAt:usedKey.    "/ recursion
		val notNil ifTrue:[^ val].
	    ].
	].
    ].
    ^ nil.

    "Created: / 18-09-2006 / 17:33:27 / cg"
    "Modified: / 21-08-2007 / 21:18:12 / cg"
    "Modified: / 05-08-2010 / 16:52:32 / sr"
!

name:aKey default:default
    "translate a string.
     Obsolete - use #string:default:"

    <resource: #obsolete>

    ^ self at:aKey ifAbsent:default
!

string:s
    "translate (retrieve) a string - if not present, return s"

    ^ self at:s ifAbsent:s

    "
     NewLauncher classResources
	string:'LICENCEFILE'
    "
!

string:s default:defaultString
    "translate (retrieve) a string - if not present, return defaultString"

    ^ self at:s ifAbsent:defaultString

    "
     NewLauncher classResources
	string:'fooBar' default:'Hello world'
    "

!

string:s default:defaultString with:arg
    "translate and expand arg"

    ^ self string:s default:defaultString withArgs:(Array with:arg)

    "
     NewLauncher classResources
	string:'%1 fooBar' default:'Hello %1' with:'foo'
    "

!

string:s default:defaultString with:arg1 with:arg2
    "translate and expand args"

    ^ self string:s default:defaultString withArgs:(Array with:arg1 with:arg2)
!

string:s default:defaultString with:arg1 with:arg2 with:arg3
    "translate and expand args"

    ^ self string:s default:defaultString withArgs:(Array with:arg1 with:arg2 with:arg3)

    "Created: 9.12.1995 / 19:08:50 / cg"
!

string:s default:defaultString with:arg1 with:arg2 with:arg3 with:arg4
    "translate and expand args"

    ^ self string:s default:defaultString withArgs:(Array with:arg1 with:arg2 with:arg3 with:arg4)

    "Created: 9.9.1996 / 18:52:14 / cg"
!

string:s default:defaultString withArgs:argArray
    "translate and expand args"

    |template|

    template := self at:s ifAbsent:defaultString.
    ^ template expandPlaceholdersWith:argArray.
!

string:s with:arg
    "translate and expand arg"

    ^ self string:s withArgs:(Array with:arg)
!

string:s with:arg1 with:arg2
    "translate and expand args"

    ^ self string:s withArgs:(Array with:arg1 with:arg2)
!

string:s with:arg1 with:arg2 with:arg3
    "translate and expand args"

    ^ self string:s withArgs:(Array with:arg1 with:arg2 with:arg3)

    "Created: 9.12.1995 / 19:08:50 / cg"
!

string:s with:arg1 with:arg2 with:arg3 with:arg4
    "translate and expand args"

    ^ self string:s withArgs:(Array with:arg1 with:arg2 with:arg3 with:arg4)

    "Created: 9.9.1996 / 18:52:14 / cg"
!

string:s with:arg1 with:arg2 with:arg3 with:arg4 with:arg5
    "translate and expand args"

    ^ self string:s withArgs:(Array with:arg1 with:arg2 with:arg3 with:arg4 with:arg5)

!

string:s with:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6
    "translate and expand args"

    ^ self string:s withArgs:(Array with:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6)

    "Created: / 13-11-2010 / 11:35:00 / cg"
!

string:s with:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7
    "translate and expand args"

    ^ self string:s withArgs:(Array with:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7)

    "Created: / 13-11-2010 / 11:35:07 / cg"
!

string:s withArgs:argArray
    "translate and expand args - allow text as arguments"

    |template|

    template := self at:s ifAbsent:s.
    ^ template expandPlaceholdersWith:argArray.








!

stringWithCRs:s
    "translate (retrieve) a string - if not present, return s"

    ^ (self string:s) withCRs

    "
     NewLauncher classResources
	stringWithCRs:'LICENCEFILE'
    "
!

stringWithCRs:s with:arg
    "translate, replace \'s with CRs and finally expand arg.
     CR-replacement is donw before args are inserted
     i.e. if any arg contains a backslash (DOS filenames), those are not translated."

    ^ self stringWithCRs:s withArgs:(Array with:arg)

    "Modified: / 21.3.2003 / 14:22:09 / cg"
!

stringWithCRs:s with:arg1 with:arg2
    "translate, replace \'s with CRs and finally expand args.
     CR-replacement is donw before args are inserted
     i.e. if any arg contains a backslash (DOS filenames), those are not translated."

    ^ self stringWithCRs:s withArgs:(Array with:arg1 with:arg2)

    "Modified: / 21.3.2003 / 14:22:06 / cg"
!

stringWithCRs:s with:arg1 with:arg2 with:arg3
    "translate, replace \'s with CRs and finally expand args.
     CR-replacement is donw before args are inserted
     i.e. if any arg contains a backslash (DOS filenames), those are not translated."

    ^ self stringWithCRs:s withArgs:(Array with:arg1 with:arg2 with:arg3)

    "Created: 9.12.1995 / 19:08:50 / cg"
!

stringWithCRs:s with:arg1 with:arg2 with:arg3 with:arg4
    "translate, replace \'s with CRs and finally expand args.
     CR-replacement is donw before args are inserted
     i.e. if any arg contains a backslash (DOS filenames), those are not translated."

    ^ self stringWithCRs:s withArgs:(Array with:arg1 with:arg2 with:arg3 with:arg4)

    "Modified: / 21.3.2003 / 14:21:48 / cg"
!

stringWithCRs:s with:arg1 with:arg2 with:arg3 with:arg4 with:arg5
    "translate, replace \'s with CRs and finally expand args.
     CR-replacement is donw before args are inserted
     i.e. if any arg contains a backslash (DOS filenames), those are not translated."

    ^ self stringWithCRs:s withArgs:(Array with:arg1 with:arg2 with:arg3 with:arg4 with:arg5)

    "Modified: / 21.3.2003 / 14:21:55 / cg"
!

stringWithCRs:s with:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6
    "translate, replace \'s with CRs and finally expand args.
     CR-replacement is donw before args are inserted
     i.e. if any arg contains a backslash (DOS filenames), those are not translated."

    ^ self stringWithCRs:s withArgs:(Array with:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6)

    "Created: / 13-11-2010 / 11:35:30 / cg"
!

stringWithCRs:s with:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7
    "translate, replace \'s with CRs and finally expand args.
     CR-replacement is donw before args are inserted
     i.e. if any arg contains a backslash (DOS filenames), those are not translated."

    ^ self stringWithCRs:s withArgs:(Array with:arg1 with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7)

    "Created: / 13-11-2010 / 11:35:20 / cg"
!

stringWithCRs:s withArgs:argArray
    "translate, replace \'s with CRs and finally expand args.
     CR-replacement is done before args are inserted
     i.e. if any arg contains a backslash (DOS filenames), those are not translated."

    |template|

    template := self at:s ifAbsent:s.
    ^ template withCRs expandPlaceholdersWith:argArray.
!

whichPackIncludesKey:aKey
    "for debugging: return the pack (alogn the super-pack chain), which
     has a translation for a string"

    |val pack projectPack alreadySearched|

    aKey isNil ifTrue:[ ^ nil ].

    val := self localAt:aKey.
    val notNil ifTrue:[^ self].

    (projectPack := self projectPack) notNil ifTrue:[
	val := projectPack localAt:aKey.
	val notNil ifTrue:[^ projectPack].
    ].
    alreadySearched := Set new.
    projectPack notNil ifTrue:[ alreadySearched add:projectPack ].

    pack := self superPack.
    [ pack notNil ] whileTrue:[
	val := pack localAt:aKey.
	val notNil ifTrue:[^ pack].

	(projectPack := pack projectPack) notNil ifTrue:[
	    (alreadySearched includes:projectPack) ifFalse:[
		val := projectPack localAt:aKey.
		val notNil ifTrue:[^ projectPack].
		alreadySearched add:projectPack.
	    ].
	].
	pack := pack superPack
    ].

    alreadySearched copy do:[:projectPack |
	|p|

	p := projectPack superPack.
	[p notNil and:[(alreadySearched includes:p) not]] whileTrue:[
	    val := p localAt:aKey.
	    val notNil ifTrue:[^ p].
	    alreadySearched add:p.
	    p := p superPack.
	].
    ].

    ^ nil
! !

!ResourcePack methodsFor:'accessing-internals'!

forgetUsedKeys
    "stop keeping a statistic on which kes are actually used"
    
    usedKeys := nil.
!

name:aKey
    "translate a string"

    ^ self at:aKey ifAbsent:aKey
!

packsClassName
    ^ packsClassName
!

packsClassName:aString
    packsClassName := aString
!

packsClassOrFileName
    "old: should no longer be used to access the filename; see packsFileName"

    ^ packsClassName
!

packsClassOrFileName:aString
    "old: should no longer be used to access the filename; see packsFileName"

    packsClassName := aString
!

packsFileName
    ^ packsFileName
!

projectPack
    ^ projectPack

    "Created: / 18-09-2006 / 17:38:07 / cg"
!

projectPack:anotherResourcePack
    projectPack := anotherResourcePack

    "Created: / 29.1.1998 / 22:43:09 / cg"
!

rememberUsedKeys
    "start keeping a statistic on which kes are actually used"
    
    usedKeys := Set new.
!

superPack
    ^ superPack

    "Created: / 18-09-2006 / 17:38:12 / cg"
!

superPack:anotherResourcePack
    superPack := anotherResourcePack

    "Created: / 29.1.1998 / 22:43:09 / cg"
! !

!ResourcePack methodsFor:'file reading'!

fileReadFailed
    "return true, if the pack does not really contain
     valid translations, since the fileRead failed.
     However, all inherited translations are still available
     through the receiver"

    ^ fileReadFailed ~~ false

    "Created: / 14.5.1996 / 10:19:26 / cg"
    "Modified: / 29.1.1998 / 22:46:38 / cg"
!

nonexistingFileRead
    "asked to read definitions for a non-existing file.
     Here, this is legal and ignored (typically using inherited resources).
     However, subclasses (such as styleSheet) may flag it as an error."

    ^ nil

    "Created: 6.9.1997 / 11:38:53 / cg"
!

processLine:lineString encoding:encodingSymbolOrEncoder file:fileName printErrorWith:printError
    "process a single valid line (i.e. #ifdef & #include has already been processed)"

    self class
	processResourceLine:lineString
	encoding:encodingSymbolOrEncoder
	file:fileName
	printErrorWith:printError
	for:self
!

readFromFile:fileName directory:dirName
    "read definitions from a file in a directory"

    |triedFilename inStream ok|

    fileReadFailed := false.
    "/ need to catch errors here, as the handler might itself need resources.
    "/ (happens when da.rs is not present in libbasic/resources.rs)
    ExternalStream openErrorSignal handle:[:ex |
	Transcript showCR:'ResourcePack: failed to open file: ',fileName asString,' in ',dirName asString.
	inStream := nil.
    ] do:[
	dirName = 'resources' ifTrue:[
	    inStream := Smalltalk resourceFileStreamFor:fileName
	] ifFalse:[
	    inStream := Smalltalk systemFileStreamFor:
			    (dirName isNil
				ifTrue:[fileName]
				ifFalse:[dirName asFilename construct:fileName]).
	].
    ].

    inStream isNil ifTrue:[
	"
	 an empty pack
	"
	^ self nonexistingFileRead
    ].

    triedFilename := inStream pathName.
    [
	ok := self readFromResourceStream:inStream in:(triedFilename asFilename directoryName).
    ] ensure:[
	inStream close.
    ].

    ok ifTrue:[
	packsFileName := triedFilename
    ] ifFalse:[
	fileReadFailed := true.

	('ResourcePack [warning]: "' , triedFilename , '" contains error(s) - data may be incomplete.') errorPrintCR.
    ].

    "Modified: / 20-08-2011 / 17:10:02 / cg"
!

readFromResourceStream:inStream in:dirName
    "read definitions from a stream. The dirName argument is required to
     specify where #include files are searched for.
     Return true, if the style sheet could be read without errors, false otherwise."

    |lineString l lineNumber rest value ifLevel skipping first ok encoding decoder pack errorHandler
     printError fileName pushedSkipValues|

    fileName := (inStream isFileStream
                    ifTrue:[inStream pathName asFilename baseName]
                    ifFalse:['---']).

    printError := [:message |
                    'ResourcePack [warning]: ' errorPrint.
                    message errorPrint.
                    ' in file:' errorPrint.
                    fileName errorPrint.
                    ' line: ' errorPrint.
                    lineNumber errorPrintCR
                  ].

    printError := [:message | ].

    encoding := nil.

    ok := true.
    ifLevel := 0.
    skipping := false.
    lineNumber := 0.
    pushedSkipValues := OrderedCollection new.

    errorHandler := [:ex |
                        |con|

                        Transcript showCR:('ResourcePack [warning]: ''' , ex description , '''') "errorPrintCR".
                        Transcript showCR:('ResourcePack [info]: file: ' , inStream pathName printString , ' line: ' , lineNumber printString , ': ''' , lineString , '''') "errorPrintCR".
                        con := ex suspendedContext.
                        Transcript showCR:('ResourcePack [info]: in: ' , con fullPrintString) "errorPrintCR".
                        con := con sender.
                        Transcript showCR:('ResourcePack [info]:   : ' , con fullPrintString) "errorPrintCR".
                        [ con notNil ] whileTrue: [
                            con := con sender.
                            Transcript showCR:('ResourcePack [info]:   : ' , con fullPrintString) "errorPrintCR".
                        ].
                        value := nil.
                        ok := false.
                    ].

    "/ Following is a hack, We no longer have Language and LangueageTerritory globals,
    "/ but in user preferences. However, resource files still access Language global
    "/ directly.
    "/ 
    "/ To workaround this without a need to rewrite them all, we define them here as 
    "/ theead-local variables so they still can be used when (and only when) reading
    "/ resource file. Very hacky, ndeed.
    Processor activeProcess withThreadVariable:#Language boundTo:Smalltalk language do: [
    Processor activeProcess withThreadVariable:#LanguageTerritory boundTo:Smalltalk languageTerritory do: [
    [inStream atEnd] whileFalse:[
        lineString := inStream nextLine. lineNumber := lineNumber + 1.
        [lineString notNil and:[lineString endsWith:$\]] whileTrue:[
            lineString := lineString copyButLast:1.
            l := inStream nextLine. lineNumber := lineNumber + 1.
            l notNil ifTrue:[
                lineString := lineString , l.
            ].
        ].

        (lineString size > 0) ifTrue:[
            first := lineString at:1.
            "/
            "/ for your convenience: treat both ';' AND '"/' as comment-line
            "/
            ((first == $;) or:[lineString startsWith:'"/']) ifFalse:[
                ((first == $#) and:[(lineString startsWith:'#(') not]) ifTrue:[
                    "/ a directive
                    lineString := (lineString copyFrom:2) withoutSpaces.

                    (lineString startsWith:'if') ifTrue:[
                        pushedSkipValues add:skipping.
                        skipping ifFalse:[
                            rest := lineString copyFrom:3.
                            Error, UserInformation
                                handle:errorHandler
                                do:[
                                    value := Compiler evaluate:rest compile:false.
                                ].
                            (value == #Error) ifTrue:[
                                printError value:('error in resource:' , lineString).
                            ].
                            (value == false) ifTrue:[
                                skipping := true
                            ]
                        ].
                        ifLevel := ifLevel + 1
                    ] ifFalse:[
                        (lineString startsWith:'endif') ifTrue:[
                            ifLevel == 0 ifTrue:[
                                printError value:('if/endif nesting error').
                            ] ifFalse:[
                                ifLevel := ifLevel - 1.
                                skipping := pushedSkipValues removeLast.
                            ]
                        ] ifFalse:[
                            (lineString startsWith:'else') ifTrue:[
                                (pushedSkipValues includes:true) ifFalse:[
                                    skipping := skipping not
                                ]
                            ] ifFalse:[
                                skipping ifFalse:[
                                    (lineString startsWith:'superpack') ifTrue:[
                                        rest := lineString copyFrom:('superpack' size + 1).
                                        value := Compiler evaluate:rest compile:false.
                                        (value isKindOf:ResourcePack) ifTrue:[
                                            superPack := value
                                        ]
                                    ] ifFalse:[
                                        (lineString startsWith:'include') ifTrue:[
                                            (lineString startsWith:'includeResourcesFor') ifTrue:[
                                                "/ include those resources ...
                                                rest := lineString copyFrom:('includeResourcesFor' size + 1).
                                                value := Compiler evaluate:rest compile:false.
                                                value isBehavior ifTrue:[
                                                    pack := self class for:value.
                                                    pack notNil ifTrue:[
                                                        self addAll:pack.
                                                    ]
                                                ]
                                            ] ifFalse:[
                                                rest := lineString copyFrom:('include' size + 1).
                                                value := Compiler evaluate:rest compile:false.
                                                value isString ifFalse:[
                                                    printError value:('bad include filename: ' , value printString, ' "',lineString,'"').
                                                ] ifTrue:[
                                                    self readFromFile:value directory:dirName
                                                ]
                                            ]
                                        ] ifFalse:[
                                            (lineString startsWith:'encoding') ifTrue:[
"/decoder notNil ifTrue:[self halt:'oops - encoding change in file'].
                                                encoding := self class extractEncodingFromLine:lineString.
                                                decoder := CharacterEncoder encoderFor:encoding ifAbsent:nil.
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ].
                ] ifFalse:[
                    skipping ifFalse:[
                        Error, UserInformation
                            handle:errorHandler
                            do:[
                                (lineString at:1) == $!! ifTrue:[
                                    "/ evaluate the rest
                                    Compiler evaluate:(lineString copyFrom:2)
                                                      receiver:self
                                                      notifying:nil
                                                      compile:false.
                                ] ifFalse:[
                                    "/ process as resource
                                    self
                                        processLine:lineString
                                        encoding:decoder
                                        file:(inStream isFileStream
                                                ifTrue:[inStream pathName]
                                                ifFalse:['---'])
                                        printErrorWith:printError
                                ]]
                    ]
                ]
            ]
        ]
    ].
    ]].

    ^ ok

    "Modified: / 31-08-1995 / 02:33:45 / claus"
    "Modified: / 18-09-2006 / 20:35:37 / cg"
    "Modified (comment): / 21-11-2017 / 15:22:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ResourcePack methodsFor:'printing & storing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifTrue:[
	aGCOrStream nextPutAll:'ResourcePack for: '.
	packsClassName printOn:aGCOrStream.
	^ self.
    ].

    ^ super displayOn:aGCOrStream
! !

!ResourcePack class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ResourcePack initialize!
