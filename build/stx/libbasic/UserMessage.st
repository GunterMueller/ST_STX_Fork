"
 COPYRIGHT (c) 2001 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#UserMessage
	instanceVariableNames:'defaultString key catalogID'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Internationalization'
!

!UserMessage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    added for vw5i compatibility, which accesses messageCatalogs
    via:
          (#key << #catalogID >> 'defaultMessage')
    which creates an instance of UserMessage.

    Currently, this is a dummy operation in ST/X, however it is mapped onto
    the resource mechanism, if the given catalogID is the name of a class;
    i.e.
        (YesNoBox classResources string:'continue')

    can now also be written as:

        (#continue << YesNoBox) asString
        (#continue << #YesNoBox >> 'Continue really') asString
"
!

examples
"
Use a class as catalog:
                                                                [exBegin]
        self warn:(#continue << YesNoBox) asString
                                                                [exEnd]
Use a class name as catalog:
                                                                [exBegin]
        self warn:(#continue << #YesNoBox) asString
                                                                [exEnd]
Some default text if the symbol is not present in the catalog:
                                                                [exBegin]
        self warn:(#continue << #YesNoBox >> 'Default for continue') asString.
        self warn:(#continueRRRRRRR << #YesNoBox >> 'Default for continue') asString
                                                                [exEnd]
Here we inherit from the top catalog:
                                                                [exBegin]
        self information:(Time now printStringFormat:(#TIMEFORMAT << self >> 'Resolved via default %h:%m:%s') asString)
                                                                [exEnd]

Can also use a package's catalog:
                                                                [exBegin]
        self information:((#'WARN_RENAME' << #'stx:libtool' ) 
                          withCRs bindWith:'ARG1' with:'ARG2')
                                                                [exEnd]

Lazy resolving the catalog in a block
(if you generate the messages at startup and want to recognize language changes):
                                                                [exBegin]
        self information:((#'WARN_RENAME' << [ Tools::NewSystemBrowser classResources ] ) 
                          withCRs bindWith:'ARG1' with:'ARG2')
                                                                [exEnd]
"
! !

!UserMessage class methodsFor:'instance creation'!

key:aKeySymbol catalogID:aCatalogSymbol
     ^ self new key:aKeySymbol catalogID:aCatalogSymbol
!

key:aKeySymbol defaultString:aString
     ^ self new key:aKeySymbol defaultString:aString
! !

!UserMessage methodsFor:'Compatibility-V''Age'!

bindWith:aString
    "return a copy of the receiver, where a '%1' escape is
     replaced by aString.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:aString)

    "
     'do you like %1 ?' bindWith:'smalltalk'
    "
!

bindWith:string1 with:string2
    "return a copy of the receiver, where a '%1' escape is
     replaced by string1 and '%2' is replaced by string2.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:string1 with:string2)

    "
     'do you prefer %1 or rather %2 ?'
	bindWith:'smalltalk' with:'c++'
    "
!

bindWith:str1 with:str2 with:str3
    "return a copy of the receiver, where a '%1', '%2' and '%3' escapes
     are replaced by str1, str2 and str3 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2 with:str3)

    "
     'do you prefer %1 or rather %2 (not talking about %3) ?'
	bindWith:'smalltalk' with:'c++' with:'c'
    "
!

bindWith:str1 with:str2 with:str3 with:str4
    "return a copy of the receiver, where a '%1', '%2', '%3' and '%4' escapes
     are replaced by str1, str2, str3 and str4 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2 with:str3 with:str4)

    "
     'do you prefer %1 or rather %2 (not talking about %3 or even %4) ?'
	bindWith:'smalltalk' with:'c++' with:'c' with:'assembler'
    "
!

bindWith:str1 with:str2 with:str3 with:str4 with:str5
    "return a copy of the receiver, where a '%1' .. '%5' escapes
     are replaced by str1 .. str5 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2 with:str3 with:str4 with:str5)

    "Created: 31.1.1997 / 16:25:42 / cg"
!

bindWith:str1 with:str2 with:str3 with:str4 with:str5 with:str6
    "return a copy of the receiver, where a '%1' .. '%6' escapes
     are replaced by str1 .. str6 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2
					 with:str3 with:str4
					 with:str5 with:str6)
!

bindWith:str1 with:str2 with:str3 with:str4 with:str5 with:str6 with:str7
    "return a copy of the receiver, where a '%1' .. '%7' escapes
     are replaced by str1 .. str7 respectively.
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:(Array with:str1 with:str2
					 with:str3 with:str4
					 with:str5 with:str6
					 with:str7)
!

bindWithArguments:anArrayOfStrings
    "return a copy of the receiver, where a '%i' escape
     is replaced by the coresponding string from the argument array.
     'i' may be between 1 and 9 (i.e. a maximum of 9 placeholders is allowed).
     To get an integer-indexed placeHolder followed by another digit,
     or an index > 9, you must use %(digit).
     This has been added for VisualAge compatibility."

    ^ self expandPlaceholdersWith:anArrayOfStrings

    "
     'do you prefer %1 or rather %2 (not talking about %3) ?'
        bindWithArguments:#('smalltalk' 'c++' 'c')

     'do you %(what) ?'
        bindWithArguments:(Dictionary new at:#'what' put:'understand'; yourself)
    "
! !

!UserMessage methodsFor:'accessing'!

catalogID
     ^ catalogID 
!

catalogID:aCatalogSymbol
     catalogID := aCatalogSymbol
!

defaultString
     ^ defaultString 
!

defaultString:aString
     defaultString := aString
!

key
     ^ key
!

key:aKeySymbol
     key := aKeySymbol.
!

key:aKeySymbol catalogID:aCatalogSymbol
     key := aKeySymbol.
     catalogID := aCatalogSymbol
!

key:aKeySymbol defaultString:aString
     key := aKeySymbol.
     defaultString := aString
! !

!UserMessage methodsFor:'converting'!

asString
    "convert the user message to a string.
     If there us no mapping for the user message -
        for now: return the defaultString, ignoring the catalogID."

    |str|

    str := self lookupInMessageCatalog.
    str notNil ifTrue:[ ^ str ].
    defaultString notNil ifTrue:[
        ^ defaultString
    ].
    ^ key asString
!

string
    ^ self asString
! !

!UserMessage methodsFor:'printing & storing'!

displayOn:aStream
    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aStream isStream) ifFalse:[
        self asString displayOn:aStream.
        ^ self
    ].

    key storeOn:aStream.
    aStream nextPutAll:' << '.
    catalogID storeOn:aStream.
    defaultString notNil ifTrue:[
        aStream nextPutAll:' >> '.
        defaultString storeOn:aStream.
    ].
!

printOn:aStream
    aStream nextPutAll:self asString
! !

!UserMessage methodsFor:'special string converting'!

expandMacros
    ^ self asString expandMacros

!

expandMacrosWith:arg1
    ^ self asString expandMacrosWith:arg1

!

expandPlaceholdersWith:argArrayOrDictionary
    ^ self asString expandPlaceholdersWith:argArrayOrDictionary
!

expandPlaceholdersWith:argArrayOrDictionary on:aStream
    ^ self asString expandPlaceholdersWith:argArrayOrDictionary on:aStream
!

withCRs
   ^ self asString withCRs
! !

!UserMessage methodsFor:'utilities'!

<< aSymbol
    "set the catalogID"

    self catalogID:aSymbol
!

>> aString
    "set the default string"

    self defaultString:aString

    "
     (#theFooMessage << #myMessages >> 'cannot read subclass of metaclass') 
    "
!

lookupInMessageCatalog
    |messageCatalog resolvedMessageCatalog|

    "catalogID may be a block"
    messageCatalog := resolvedMessageCatalog :=catalogID value.

    "for now - handle the case that the catalogID is
     a classes name; in that case, ask its resourcePack."
    messageCatalog isSymbol ifTrue:[
        resolvedMessageCatalog := Smalltalk at:messageCatalog.
        resolvedMessageCatalog isNil ifTrue:[
            "no class, so it is a packageID"
            resolvedMessageCatalog := ResourcePack forPackage:messageCatalog cached:true.
        ].
    ].
    resolvedMessageCatalog isBehavior ifTrue:[
        resolvedMessageCatalog := resolvedMessageCatalog classResources.
    ].
    (resolvedMessageCatalog isNil) ifTrue:[
        defaultString isNil ifTrue:[
            ^ 'Non-existent message: (%1<<%2)' bindWith:key with:catalogID printString.
        ].
        ^ defaultString.
    ].

    ^ resolvedMessageCatalog at:key ifAbsent:nil.

    "
     (#'WARN_RENAME' << #BrowserView >> 'A class named %1 already exists (in ''%2'')\\that class will no longer be visible (i.e. removed) if you continue.\\Continue ?' ) asString
     (#'WARN_RENAME' << #BrowserView) asString
     (#'WARN_RENAME' << BrowserView classResources) asString
     (#'WARN_RENAME' << [ BrowserView classResources] ) asString
     (#'WARN_RENAME' << #'stx:libtool' ) asString
     (#dontKnow << #nonExistantMessageCatalog) asString
     (#dontKnow << [YesNoBox]) asString
     (#dontKnow << #nonExistantMessageCatalog >> 'Default text') asString
    "
! !

!UserMessage class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

