"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2005 by eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
 COPYRIGHT (c) 2018 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ParserFlags
	instanceVariableNames:'warnings warnUnusedVars warnUndeclared warnST80Directives
		warnSTXHereExtensionUsed warnSTXSpecialComment
		warnUnderscoreInIdentifier warnOldStyleAssignment
		warnCommonMistakes warnSTXNameSpaceUse
		warnPossibleIncompatibilities warnDollarInIdentifier
		warnParagraphInIdentifier warnHiddenVariables
		warnAboutVariableNameConventions warnAboutWrongVariableNames
		warnAboutBadComments warnInconsistentReturnValues
		warnAboutNonLowercaseLocalVariableNames
		warnAboutPossibleSTCCompilationProblems
		warnAboutReferenceToPrivateClass warnAboutShortLocalVariableNames
		warnAboutPossiblyUnimplementedSelectors
		warnAboutUnknownCharacterEscapesInJavaScriptStringConstant
		warnPlausibilityChecks allowLiteralNameSpaceSymbols
		allowUnderscoreInIdentifier allowDollarInIdentifier
		allowParagraphInIdentifier allowOldStyleAssignment
		allowSqueakExtensions allowDolphinExtensions
		allowExtendedBinarySelectors allowQualifiedNames
		allowFunctionCallSyntaxForBlockEvaluation
		allowLocalVariableDeclarationWithInitializerExpression
		allowDomainVariables allowArrayIndexSyntaxExtension
		allowReservedWordsAsSelectors allowVariableReferences
		allowLazyValueExtension allowFixedPointLiterals
		allowExtendedSTXSyntax allowVisualAgeESSymbolLiterals
		allowExtensionsToPrivateClasses allowSqueakPrimitives
		allowVisualAgePrimitives allowSTVPrimitives allowSTVExtensions
		allowNationalCharactersInIdentifier allowHashAsBinarySelector
		allowSTXEOLComments allowEmptyStatements
		allowVisualWorksMethodAnnotations
		allowPossibleSTCCompilationProblems arraysAreImmutable
		stringsAreImmutable implicitSelfSends stcKeepCIntermediate
		stcKeepOIntermediate stcKeepSTIntermediate stcModulePath
		stcCompilation stcCompilationIncludes stcCompilationDefines
		stcCompilationOptions stcPath ccCompilationOptions ccPath
		linkArgs linkSharedArgs linkCommand libPath searchedLibraries
		warnAboutPeriodInSymbol allowPeriodInSymbol allowCaretAsBinop
		allowUnicodeStrings allowUnicodeCharacters allowCharacterEscapes
		allowStringEscapes allowAssignmentToBlockArgument
		allowAssignmentToMethodArgument allowAssignmentToPoolVariable
		lineNumberInfo allowSTXDelimiterComments
		allowSTXExtendedArrayLiterals warnAssignmentToBlockArgument
		warnAssignmentToMethodArgument warnAssignmentToPoolVariable
		allowSignedByteArrayElements allowSymbolsStartingWithDigit
		allowJavaScriptConst'
	classVariableNames:'AllowArrayIndexSyntaxExtension AllowAssignmentToBlockArgument
		AllowAssignmentToMethodArgument AllowAssignmentToPoolVariable
		AllowCaretAsBinop AllowCharacterEscapes AllowDollarInIdentifier
		AllowDolphinExtensions AllowDomainVariables AllowEmptyStatements
		AllowExtendedBinarySelectors AllowExtendedSTXSyntax
		AllowExtensionsToPrivateClasses AllowFixedPointLiterals
		AllowFunctionCallSyntaxForBlockEvaluation
		AllowHashAsBinarySelector AllowLazyValueExtension
		AllowLiteralNameSpaceSymbols
		AllowLocalVariableDeclarationWithInitializerExpression
		AllowNationalCharactersInIdentifier AllowOldStyleAssignment
		AllowParagraphInIdentifier AllowPeriodInSymbol
		AllowPossibleSTCCompilationProblems AllowQualifiedNames
		AllowReservedWordsAsSelectors AllowSTVExtensions
		AllowSTVPrimitives AllowSTXDelimiterComments AllowSTXEOLComments
		AllowSTXExtendedArrayLiterals AllowSqueakExtensions
		AllowSqueakPrimitives AllowStringEscapes
		AllowUnderscoreInIdentifier AllowUnicodeCharacters
		AllowUnicodeStrings AllowVariableReferences
		AllowVisualAgeESSymbolLiterals AllowVisualAgePrimitives
		AllowVisualWorksMethodAnnotations ArraysAreImmutable BCCTop
		CCCompilationOptions CCPath DefineForBorlandC DefineForCLANG
		DefineForGNUC DefineForMINGW DefineForMINGW32 DefineForMINGW64
		DefineForMSC DefineForVisualC ForcedCompiler ImplicitSelfSends
		LibDirectory LibPath LineNumberInfo LinkArgs LinkCommand
		LinkSharedArgs MakeCommand MingwTop PerMethodFlags SDKTop
		STCCompilation STCCompilationDefines STCCompilationIncludes
		STCCompilationOptions STCKeepCIntermediate STCKeepOIntermediate
		STCKeepSTIntermediate STCModulePath STCPath SearchedLibraries
		StringsAreImmutable VCTop WarnAboutBadComments
		WarnAboutNonLowercaseLocalVariableNames WarnAboutPeriodInSymbol
		WarnAboutPossibleSTCCompilationProblems
		WarnAboutPossiblyUnimplementedSelectors
		WarnAboutReferenceToPrivateClass WarnAboutShortLocalVariableNames
		WarnAboutUnknownCharacterEscapesInJavaScriptStringConstant
		WarnAboutVariableNameConventions WarnAboutWrongVariableNames
		WarnAssignmentToBlockArgument WarnAssignmentToMethodArgument
		WarnAssignmentToPoolVariable WarnCommonMistakes
		WarnDollarInIdentifier WarnHiddenVariables
		WarnInconsistentReturnValues WarnOldStyleAssignment
		WarnParagraphInIdentifier WarnPlausibilityChecks
		WarnPossibleIncompatibilities WarnST80Directives WarnSTXSpecials
		WarnUndeclared WarnUnderscoreInIdentifier WarnUnusedVars Warnings
		AutoDefineVariables AllowSignedByteArrayElements
		AllowSymbolsStartingWithDigit AllowJavaScriptConst
		AllowJavaScriptLet'
	poolDictionaries:''
	category:'System-Compiler'
!

!ParserFlags class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2005 by eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
 COPYRIGHT (c) 2018 Jan Vrany
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
    compiler flags (used to be defined in Scanner and Parser) have been extracted for easier
    individual-method customization (using ST as scripting).

    The class side provides correspondingly-named variables, which hold the default values.

    howTo_fileInVSE:
	ParserFlags allowSTVExtensions:true.
	ParserFlags allowSTVPrimitives:true.
	ParserFlags allowSTXEOLComments:false.

    for stx debugging:
	STCKeepCIntermediate := true

"
! !

!ParserFlags class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!ParserFlags class methodsFor:'accessing-compilation control'!

allowExtensionsToPrivateClasses
    ^ AllowExtensionsToPrivateClasses
!

allowExtensionsToPrivateClasses:aBoolean
    AllowExtensionsToPrivateClasses := aBoolean
!

allowPossibleSTCCompilationProblems
    ^ AllowPossibleSTCCompilationProblems

    "
     self allowPossibleSTCCompilationProblems:true
     self allowPossibleSTCCompilationProblems:false

     self warnAboutPossibleSTCCompilationProblems
    "

    "Created: / 16-11-2006 / 14:31:36 / cg"
!

allowPossibleSTCCompilationProblems:aBoolean
    AllowPossibleSTCCompilationProblems := aBoolean

    "Created: / 16-11-2006 / 14:31:40 / cg"
!

arraysAreImmutable
    "return true if arrays and byteArrays are compiled as immutable literals"

    ^ ArraysAreImmutable
!

arraysAreImmutable:aBoolean
    "turn on/off immutable array and byteArrays literals - default is false for ST-80 compatibilty."

    ArraysAreImmutable := aBoolean.

    "
     can be added to your private.rc file:

     ParserFlags arraysAreImmutable:true
     ParserFlags arraysAreImmutable:false
    "
!

fullLineNumberInfo
    ^ (self lineNumberInfo == #full)

    "Created: / 26-09-2012 / 14:16:09 / cg"
!

implicitSelfSends
    "return true if undefined variables with
     lowercase first character are to be turned
     into implicit self sends"

    ^ ImplicitSelfSends
!

implicitSelfSends:aBoolean
    "turn on/off implicit self sends"

    ImplicitSelfSends := aBoolean

    "
     Compiler implicitSelfSends:true
     Compiler implicitSelfSends:false
    "
!

lineNumberInfo
    ^ LineNumberInfo

    "Created: / 26-09-2012 / 13:27:34 / cg"
!

lineNumberInfo:aSymbol
    LineNumberInfo := aSymbol.

    "Created: / 26-09-2012 / 13:27:54 / cg"
!

stringsAreImmutable
    "return true if strings are immutable literals"

    ^ StringsAreImmutable

    "Created: / 3.8.1998 / 14:53:25 / cg"
!

stringsAreImmutable:aBoolean
    "turn on/off immutable string literals - default is false for ST-80 compatibilty."

    StringsAreImmutable := aBoolean.

    "
     can be added to your private.rc file:

     ParserFlags stringsAreImmutable:true
     ParserFlags stringsAreImmutable:false
    "

    "Created: / 3.8.1998 / 14:53:28 / cg"
! !

!ParserFlags class methodsFor:'accessing-per method flags'!

disableFlag:flagName forClass:class selector:selector
    "remember that warnings named flagName (such as #warnUnusedVars)
     are disabled for a particular method.
     Sent if user wants to disable warnings in the future
     (try defining a method with an unused var, to see)"

    |key|

    PerMethodFlags isNil ifTrue:[
	PerMethodFlags := Dictionary new.
    ].
    key := class name, '>>',selector.
    PerMethodFlags at:key put:(Timestamp now + self perMethodDisableWarningTimeDuration).

    "Created: / 28-02-2012 / 12:57:45 / cg"
!

isFlag:flagName enabledForClass:class selector:selector
    "return true, if warnings named <flagName> (such as #warnUnusedVars)
     are to be suppressed for a particular method."

    |key endTime|

    PerMethodFlags isNil ifTrue:[^ true].
    class isNil ifTrue:[^ true].
    selector isNil ifTrue:[^ true].

    key := class name, '>>',selector.
    endTime := PerMethodFlags at:key ifAbsent:nil.
    endTime isNil ifTrue:[^ true].
    endTime > Timestamp now ifTrue:[^ false].
    PerMethodFlags removeKey:key.
    ^ true

    "Created: / 28-02-2012 / 12:57:30 / cg"
!

perMethodDisableWarningTimeDuration
    "when the user wants to suppress a particular warning for a particular
     method, it will be only suppressed for some time duration.
     After that, the suppress will automatically be removed, and normal warnings
     are issued again."

    ^ 30 minutes

    "Created: / 08-03-2012 / 10:22:57 / cg"
!

reenableAllSuppressedFlags
    "turn off any suppressed warnings"

    PerMethodFlags := nil

    "Created: / 28-02-2012 / 12:59:08 / cg"
! !

!ParserFlags class methodsFor:'accessing-stc compilation control'!

bccTop:aPath
    "windows only: define the borland-C installation directory.
     must contain bin\bcc32.exe and include.
     Typically, something like 'C:\borland\bcc55'"

    BCCTop := aPath

    "Created: / 08-08-2011 / 22:41:48 / cg"
!

ccCompilationOptions
    ^ CCCompilationOptions ? ''
!

ccCompilationOptions:aString
    CCCompilationOptions := aString
!

ccPath
    ^ CCPath
!

ccPath:aSymbol
    CCPath := aSymbol
!

libDirectory
    ^ LibDirectory

    "Created: / 07-08-2011 / 14:01:21 / cg"
!

libDirectory:aString
    LibDirectory := aString

    "Created: / 07-08-2011 / 14:01:28 / cg"
!

libPath
    ^ LibPath
!

libPath:aString
    LibPath := aString
!

linkArgs
    ^ LinkArgs
!

linkArgs:aString
    LinkArgs := aString
!

linkCommand
    ^ LinkCommand
!

linkCommand:aString
    LinkCommand := aString
!

linkSharedArgs
    ^ LinkSharedArgs
!

linkSharedArgs:aString
    LinkSharedArgs := aString

    "Modified (format): / 28-02-2012 / 13:34:58 / cg"
!

makeCommand
    ^ MakeCommand

    "Created: / 09-08-2006 / 18:45:04 / fm"
!

makeCommand:aString
    MakeCommand := aString

    "Created: / 09-08-2006 / 18:45:12 / fm"
!

sdkTop:aPath
    "windows only: define the SDK top directory.
     must include folder with windows header files.
     Typically something like 'C:\Program Files\Microsoft SDKs\Windows\v6.0A'"

    SDKTop := aPath

    "Created: / 08-08-2011 / 22:39:24 / cg"
!

searchedLibraries
    ^ SearchedLibraries
!

searchedLibraries:aString
    SearchedLibraries := aString
!

stcCompilation
    ^ STCCompilation
!

stcCompilation:aSymbol
    STCCompilation := aSymbol
!

stcCompilationDefines
    ^ STCCompilationDefines
!

stcCompilationDefines:aString
    STCCompilationDefines := aString
!

stcCompilationIncludes
    ^ STCCompilationIncludes
!

stcCompilationIncludes:aString
    STCCompilationIncludes := aString
!

stcCompilationOptions
    ^ STCCompilationOptions
!

stcCompilationOptions:aString
    STCCompilationOptions := aString
!

stcKeepCIntermediate
    ^ STCKeepCIntermediate ? false

    "Modified: / 16-09-2011 / 19:56:18 / cg"
!

stcKeepCIntermediate:aBoolean
    STCKeepCIntermediate := aBoolean.

    "
     STCKeepCIntermediate := true.
     STCKeepCIntermediate := false.
    "

    "Modified: / 07-11-2006 / 10:58:42 / cg"
!

stcKeepOIntermediate
    ^ STCKeepOIntermediate ? false

    "Modified: / 16-09-2011 / 19:56:49 / cg"
!

stcKeepOIntermediate:aBoolean
    STCKeepOIntermediate := aBoolean.

    "
     STCKeepOIntermediate := true.
     STCKeepOIntermediate := false.
    "
!

stcKeepSTIntermediate
    ^ STCKeepSTIntermediate ? false

    "
     STCKeepSTIntermediate := true.
     STCKeepSTIntermediate := false.
    "

    "Modified: / 16-09-2011 / 19:57:17 / cg"
!

stcKeepSTIntermediate:aBoolean
    STCKeepSTIntermediate := aBoolean.

    "
     STCKeepSTIntermediate := true.
     STCKeepSTIntermediate := false.
    "

    "Modified: / 07-11-2006 / 10:58:54 / cg"
!

stcModulePath
    "the folder, where temporarily compiled modules are created by stc.
     Used to be inside the bin-directory, but that did not work for readonly/shared
     st/x installations (i.e. running stx from a mounted dbg).
     Therefore, this is now in the workspace (where the snapshot image resudes as well)
     
     Notice: 
        this ought to be a persistent folder (at least as along as any
        snapshot image is present, which refers to any module there.
        As we cannot (currently) scan snapshots, this is somewhat tricky."
        
    STCModulePath notNil ifTrue:[^ STCModulePath].    
    ^ UserPreferences current workspaceDirectory  / 'modules'     
!

stcModulePath:aPath
    "set the path to the directory, where temporary modules are created.
     Obsolete now, as this should not be set from the outside,
     but instead rely totally on the userPreferences."

    STCModulePath := aPath.
!

stcPath
    ^ STCPath
!

stcPath:aPath
    STCPath := aPath
!

useBorlandC
    "true if borland compiler should be used"

    ^ self usedCompilerDefine = DefineForBorlandC

    "Created: / 15-03-2007 / 13:33:32 / cg"
!

useClang
    "true if clang compiler should be used"

    ^ self usedCompilerDefine = DefineForCLANG
!

useCompilerDefine: aCompilerDefine
    "enforce a particular compiler to be used (independent from
     what the system was compiled with)"

    ForcedCompiler := aCompilerDefine.

    "
     self useCompiler: DefineForBorlandC
     self useCompiler: DefineForVisualC
     self useCompiler: DefineForMINGW32
    "

    "Created: / 20-07-2012 / 13:10:30 / cg"
!

useGnuC
    "true if gnu-c compiler should be used"

    ^ self usedCompilerDefine = DefineForGNUC

    "Created: / 15-03-2007 / 13:34:49 / cg"
!

useMingw32
    "true if mingw compiler should be used"

    ^ self usedCompilerDefine = DefineForMINGW32
!

useMingw64
    "true if mingw compiler should be used"

    ^ self usedCompilerDefine = DefineForMINGW64
!

useVisualC
    "true if visual-c compiler should be used"

    |def|

    ^ (def := self usedCompilerDefine) = DefineForVisualC
    or:[ def = DefineForMSC ]

    "Created: / 08-08-2011 / 22:50:25 / cg"
!

usedCompiler
    |dfn|

    dfn := self usedCompilerDefine.

    dfn = DefineForGNUC ifTrue:[ ^'gcc'].
    dfn = DefineForBorlandC ifTrue:[ ^'bcc'].
    dfn = DefineForMSC ifTrue:[ ^'vc'].
    dfn = DefineForVisualC ifTrue:[ ^'vc'].
    dfn = DefineForMINGW64 ifTrue:[ ^'mingw'].
    dfn = DefineForMINGW32 ifTrue:[ ^'mingw'].
    dfn = DefineForMINGW ifTrue:[ ^'mingw'].
"/    dfn = DefineForLCC ifTrue:[ ^'lcc'].

    OperatingSystem isMSWINDOWSlike ifTrue:[
	^ 'bcc'
    ].
    ^ 'gcc'

    "
     self usedCompiler
    "

    "Created: / 31-01-2012 / 12:05:30 / cg"
!

usedCompilerDefine
    "return the define to be used for the compiler toolchain.
     By default, the toolchain with which stx itself was compiled is used (getCCDefine);
     can be overwritten by setting ForcedCompiler"
     
    |dfn|

    dfn := ForcedCompiler.
    dfn isNil ifTrue:[ dfn := STCCompilerInterface getCCDefine].
    ^ dfn

    "
     ForcedCompiler := DefineForCLANG.
     self usedCompilerDefine.
     
     ForcedCompiler := nil.
     self usedCompilerDefine.
    "
    
    "Created: / 20-07-2012 / 13:11:22 / cg"
!

vcTop:aPath
    "windows only: define the visual-C top directory.
     must contain bin\cl.exe and include.
     Typically, something like 'C:\Program Files\Microsoft Visual Studio 10.0\VC'"

    VCTop := aPath

    "Created: / 08-08-2011 / 22:39:15 / cg"
!

withSTCCompilation:howSymbol do:aBlock
    |prev|

    prev := self stcCompilation.
    self stcCompilation:howSymbol.
    aBlock ensure:[ self stcCompilation:prev ]
! !

!ParserFlags class methodsFor:'accessing-syntax-control'!

allowArrayIndexSyntaxExtension
    "experimental"

    ^ AllowArrayIndexSyntaxExtension ? false

    "
     self allowArrayIndexSyntaxExtension:true
     self allowArrayIndexSyntaxExtension:false
     self allowArrayIndexSyntaxExtension
    "
!

allowArrayIndexSyntaxExtension:aBoolean
    "experimental"

    AllowArrayIndexSyntaxExtension := aBoolean.

    "
     self allowArrayIndexSyntaxExtension:true
     self allowArrayIndexSyntaxExtension:false
    "
!

allowAssignmentToBlockArgument
    ^ AllowAssignmentToBlockArgument

    "Created: / 08-09-2011 / 14:49:46 / cg"
!

allowAssignmentToBlockArgument:aBoolean
    AllowAssignmentToBlockArgument := aBoolean

    "Created: / 08-09-2011 / 14:50:23 / cg"
!

allowAssignmentToMethodArgument
    ^ AllowAssignmentToMethodArgument

    "Created: / 08-09-2011 / 14:49:57 / cg"
!

allowAssignmentToMethodArgument:aBoolean
    AllowAssignmentToMethodArgument := aBoolean

    "Created: / 08-09-2011 / 14:50:34 / cg"
!

allowAssignmentToPoolVariable
    ^ AllowAssignmentToPoolVariable

    "Created: / 08-09-2011 / 14:50:06 / cg"
!

allowAssignmentToPoolVariable:aBoolean
    AllowAssignmentToPoolVariable := aBoolean

    "Created: / 08-09-2011 / 14:50:48 / cg"
!

allowDollarInIdentifier
    "return true, if $-characters are allowed in identifiers.
     Notice, that dollars are NEVER allowed as the first character in an identifier
     (because they are interpreted as character-constant then)."

    ^ AllowDollarInIdentifier

    "Created: / 07-09-1997 / 01:32:18 / cg"
    "Modified (comment): / 16-11-2016 / 22:25:59 / cg"
!

allowDollarInIdentifier:aBoolean
    "this allows turning on/off $-characters in identifiers.
     Notice, that dollars are NEVER allowed as the first character in an identifier.
     If turned off (the default), dollars are not allowed in identifiers,
     but instead are scanned as character-constant prefix.
     If turned on, dollars in identifiers are allowed, while extra
     dollars are still scanned as constant character prefix.
     If you have to fileIn old VW-Vsn2.x classes, turn this off
     before filing them in; i.e.:
        Compiler allowDollarInIdentifiers:false
    "

    AllowDollarInIdentifier := aBoolean.

    "Created: / 07-09-1997 / 01:34:49 / cg"
    "Modified (comment): / 16-11-2016 / 22:26:38 / cg"
!

allowDolphinExtensions
    "return true, if ##(..) computed literals are allowed"

    ^ AllowDolphinExtensions
!

allowDolphinExtensions:aBoolean
    "this allows turning on/off support for computed arrays ##(..) as in dolphin.
     If you want to fileIn Dolphin classes, enable this with:
	Compiler allowDolphinComputedArrays:true"

    AllowDolphinExtensions := aBoolean.

    "
     self allowDolphinExtensions:true
     self allowDolphinExtensions:false
    "
!

allowEmptyStatements
    "return true, if empty statements are allowed (two .'s in a row).
     Notice, that stc cannot (yet) handle those."

    ^ AllowEmptyStatements

    "Created: / 20-11-2006 / 14:29:02 / cg"
!

allowEmptyStatements:aBoolean
    "turn on/off, if empty statements are allowed (two .'s in a row).
     Notice, that stc cannot (yet) handle those."

    AllowEmptyStatements := aBoolean

    "Created: / 20-11-2006 / 14:29:15 / cg"
!

allowExtendedBinarySelectors
    "experimental extended selectors extensions"

    ^ AllowExtendedBinarySelectors

    "
     ParserFlags allowExtendedBinarySelectors
     ParserFlags allowExtendedBinarySelectors:false
     ParserFlags allowExtendedBinarySelectors:true
    "
!

allowExtendedBinarySelectors:aBoolean
    "experimental syntay extensions"

    AllowExtendedBinarySelectors := aBoolean
!

allowExtendedSTXSyntax
    "experimental syntay extensions"

    ^ AllowExtendedSTXSyntax
!

allowExtendedSTXSyntax:aBoolean
    "experimental syntay extensions"

    AllowExtendedSTXSyntax := aBoolean

    "
     self allowExtendedSTXSyntax:true
     'a\tb' inspect.
     'a\u1616b' inspect.
     self allowExtendedSTXSyntax:false
    "
!

allowFixedPointLiterals
    "return true, if nnnsn (FixedPoint) literals are allowed"

    ^ AllowFixedPointLiterals
!

allowFixedPointLiterals:aBoolean
    "enable/disable, if nnnsn (FixedPoint) literals are allowed"

    AllowFixedPointLiterals := aBoolean
!

allowFunctionCallSyntaxForBlockEvaluation
    "experimental"

    ^ AllowFunctionCallSyntaxForBlockEvaluation

    "
     AllowFunctionCallSyntaxForBlockEvaluation := true
    "
!

allowFunctionCallSyntaxForBlockEvaluation:aBoolean
    "experimental"

    AllowFunctionCallSyntaxForBlockEvaluation := aBoolean.
!

allowHashAsBinarySelector
    ^ AllowHashAsBinarySelector
!

allowHashAsBinarySelector:aBoolean
    AllowHashAsBinarySelector := aBoolean

    "
     self allowHashAsBinarySelector:true
     self allowHashAsBinarySelector:false
    "
!

allowJavaScriptConst
    "return true, if const is allowed and treated as a keyword (in JavaScript)"

    ^ AllowJavaScriptConst

    "Created: / 08-08-2017 / 23:48:48 / cg"
!

allowJavaScriptConst:aBoolean
    "true, if const is allowed and treated as a keyword (in JavaScript)"

    AllowJavaScriptConst := aBoolean

    "Created: / 08-08-2017 / 23:49:07 / cg"
!

allowLiteralNameSpaceSymbols
    "return true, if literal nameSpace symbols are allowed (#foo::bar) are allowed"

    ^ AllowLiteralNameSpaceSymbols
!

allowLiteralNameSpaceSymbols:aBoolean
    "controls, if literal nameSpace symbols are allowed (#foo::bar) are allowed"

    AllowLiteralNameSpaceSymbols := aBoolean
!

allowLocalVariableDeclarationWithInitializerExpression
    "experimental"

    ^ AllowLocalVariableDeclarationWithInitializerExpression
!

allowLocalVariableDeclarationWithInitializerExpression:aBoolean
    "experimental"

    AllowLocalVariableDeclarationWithInitializerExpression := aBoolean.
!

allowNationalCharactersInIdentifier
    "return true, if national characters (diaresis etc.) are allowed in identifiers"

    ^ AllowNationalCharactersInIdentifier
!

allowNationalCharactersInIdentifier:aBoolean
    "this allows turning on/off recognition of national characters (diaresis etc.) in identifiers.
     Use this ONLY to file in some non-ANSI ST/V code"

    AllowNationalCharactersInIdentifier := aBoolean

    "
     ParserFlags allowNationalCharactersInIdentifier:true
    "
!

allowOldStyleAssignment
    "return true, if underscore-assignment (pre ST-80v4 syntax) are to be allowed"

    ^ AllowOldStyleAssignment
!

allowOldStyleAssignment:aBoolean
    "this allows turning on/off recognition of underscore-assignment (pre ST-80v4 syntax).
     You must turn this off, if code with variables named '_' is to be filedIn"

    AllowOldStyleAssignment := aBoolean
!

allowParagraphInIdentifier
    "return true, if §-characters are allowed in identifiers (treated as letter)"

    ^ AllowParagraphInIdentifier

    "Created: / 16-11-2016 / 22:24:32 / cg"
!

allowParagraphInIdentifier:aBoolean
    "this allows turning on/off §-characters in identifiers."

    AllowParagraphInIdentifier := aBoolean.

    "Created: / 16-11-2016 / 22:28:49 / cg"
!

allowPeriodInSymbol
    "return true, if periods are allowed in a symbol literal #foo.bar.
     Needed to parse some old ST80/Squeak code"

    ^ AllowPeriodInSymbol
!

allowPeriodInSymbol:aBoolean
    "control, if periods are allowed in a symbol literal #foo.bar.
     Needed to parse some old ST80/Squeak code"

    AllowPeriodInSymbol := aBoolean

    "
     self allowPeriodInSymbol:true.
     self assert:( Parser parseExpression:' #foo.bar.baz. ' ) value == #'foo.bar.baz'.

     self allowPeriodInSymbol:false.
     self assert:( Parser parseExpression:' #foo.bar.baz. ' ) value == #'foo'.
   "
!

allowQualifiedNames
    "return true, if #{..} qualified names are allowed"

    ^ AllowQualifiedNames
!

allowQualifiedNames:aBoolean
    "this allows turning on/off support for qualifiedNames #{ .., } as in vw3.
     If you want to fileIn vw3 or later classes, enable this with:
	Compiler allowQualifiedNames:true
     Notice, that qualified names are not really supported semantically
     (they are parsed, but treated like regular globals)
    "

    AllowQualifiedNames := aBoolean.

    "
     self allowQualifiedNames:true
     self allowQualifiedNames:false
    "
!

allowReservedWordsAsSelectors
    "return true, if self, super, thisContext, nil, true and false are to be allowed
     as unary message selectors."

    ^ AllowReservedWordsAsSelectors ? false
!

allowReservedWordsAsSelectors:aBoolean
    "enable/disable, if self, super, thisContext, nil, true and false are to be allowed
     as unary message selectors."

    AllowReservedWordsAsSelectors := aBoolean.

    "
     self allowReservedWordsAsSelectors:true
     self allowReservedWordsAsSelectors:false
    "
!

allowSTVExtensions
    "return true, if support for ST/V syntax extensions is enabled."

    ^ AllowSTVExtensions
!

allowSTVExtensions:aBoolean
    "this allows turning on/off support for ST/V extensions:
     If you want to fileIn ST/V classes, enable this with:
	Compiler allowSTVComputedArrays:true"

    AllowSTVExtensions := aBoolean.

    "
     ParserFlags allowSTVExtensions:true
     ParserFlags allowSTVExtensions:false
    "
!

allowSTVPrimitives
    "return true, if support for ST/V primitives is enabled."

    ^ AllowSTVPrimitives
!

allowSTVPrimitives:aBoolean
    "this allows turning on/off support for ST/V primitives"

    AllowSTVPrimitives := aBoolean

    "
     ParserFlags allowSTVPrimitives:true
    "
!

allowSTXDelimiterComments
    "token delimited comments;
     these are multiline comments of the form:
        ''>>TOKEN
           ... anything, including double quotes
        TOKEN>>''
     (the '' being a double quote in the above)
     Such comments are especially useful to comment pieces of sample code, which may
     contain another comment in it, but you don't want to make them all EOL comments
     (which are an ST/X speciality also, by the way).
     Be aware, that no other smalltalk supports this, so your code becomes harder to port, if you use it.
    "

    ^ AllowSTXDelimiterComments

    "Modified (comment): / 28-07-2017 / 10:32:54 / cg"
!

allowSTXDelimiterComments:aBoolean
    "enable token delimited comments;
     these are multiline comments of the form:
	''>>TOKEN
	   ... anything, including double quotes
	TOKEN>>''
     (the '' being a double quote in the above)
     Such comments are especially useful to comment pieces of sample code, which may
     contain another comment in it, but you don't want to make them all EOL comments
     (which are an ST/X speciality also, by the way).
     Be aware, that no other smalltalk supports this, so your code becomes harder to port, if you use it.
    "

    AllowSTXDelimiterComments := aBoolean.

    "
     self allowSTXDelimiterComments:true
     self allowSTXDelimiterComments:false
    "
!

allowSTXEOLComments
    "are ST/X end-of-line comments allowed?"

    ^ AllowSTXEOLComments
!

allowSTXEOLComments:aBoolean
    "are ST/X end-of-line comments allowed?"

    AllowSTXEOLComments := aBoolean.

    "
     self allowSTXEOLComments:true
     self allowSTXEOLComments:false
    "
!

allowSTXExtendedArrayLiterals
    "are scheme-style typed literal arrays allowed?"

    ^ AllowSTXExtendedArrayLiterals ? false
!

allowSTXExtendedArrayLiterals:aBoolean
    "are scheme-style typed literal arrays allowed?"

    AllowSTXExtendedArrayLiterals := aBoolean.

    "
     self allowSTXExtendedArrayLiterals:true
     self allowSTXExtendedArrayLiterals:false
    "
!

allowSignedByteArrayElements
    "return true, if byteArray elements are allowed to be negative."

    ^ AllowSignedByteArrayElements
!

allowSignedByteArrayElements:aBoolean
    "controls, if byteArray elements are allowed to be negative."

    AllowSignedByteArrayElements := aBoolean
!

allowSqueakExtensions
    "return true, if support for squeak extensions
	computed arrays { .., }
	c/java style arguments in message sends rec foo(arg1, ... argN)
     is enabled."

    ^ AllowSqueakExtensions
!

allowSqueakExtensions:aBoolean
    "this allows turning on/off support for squeak extensions:
	computed arrays { .., }
	c/java style arguments in message sends rec foo(arg1, ... argN)

     If you want to fileIn Squeak classes, enable this with:
	Compiler allowSqueakComputedArrays:true"

    AllowSqueakExtensions := aBoolean.

    "
     self allowSqueakExtensions:true
     self allowSqueakExtensions:false
    "
!

allowSqueakPrimitives
    "return true, if support for squeak primitives is enabled."

    ^ AllowSqueakPrimitives
!

allowSqueakPrimitives:aBoolean
    "this allows turning on/off support for squeak primitives"

    AllowSqueakPrimitives := aBoolean
!

allowSymbolsStartingWithDigit
    "return true, if a symbol is allowed to start with a digit
     i.e. as in #2D.
     This seems to be ok in new Squeak/Pharo versions"

    ^ AllowSymbolsStartingWithDigit

    "Created: / 18-06-2017 / 16:23:20 / cg"
!

allowSymbolsStartingWithDigit:aBoolean
    "controls if a symbol is allowed to start with a digit
     i.e. as in #2D.
     This seems to be ok in new Squeak/Pharo versions"

    AllowSymbolsStartingWithDigit := aBoolean

    "Created: / 18-06-2017 / 16:24:47 / cg"
!

allowUnderscoreInIdentifier
    "return true, if underscores are allowed in identifiers"

    ^ AllowUnderscoreInIdentifier
!

allowUnderscoreInIdentifier:aBoolean
    "this allows turning on/off underscores in identifiers.
     If turned off (the default), underscores are not allowed in identifiers,
     but instead scanned as assignment character (old ST/80 syntax).
     If turned on, underscores are in identifiers are allowed, while extra
     underscores are still scanned as assignment.
     If you have to fileIn old VW-Vsn2.x classes,
     turn them off with:
	Compiler allowUnderscoreInIdentifiers:false"

    AllowUnderscoreInIdentifier := aBoolean.

    "Modified: 7.9.1997 / 01:35:19 / cg"
!

allowUnicodeCharacters
    ^ AllowUnicodeCharacters
!

allowUnicodeCharacters:aBoolean
    AllowUnicodeCharacters := aBoolean.
!

allowUnicodeStrings
    ^ AllowUnicodeStrings
!

allowUnicodeStrings:aBoolean
    AllowUnicodeStrings := aBoolean.
!

allowVisualAgeESSymbolLiterals
    "return true, if ##symbols are allowed (treated like symbols)"

    ^ AllowVisualAgeESSymbolLiterals
!

allowVisualAgeESSymbolLiterals:aBoolean
    "if on, visualAge's ##symbols are allowed (treated like symbols)"

    AllowVisualAgeESSymbolLiterals := aBoolean.
!

allowVisualAgePrimitives
    "return true, if support for V'Age primitives is enabled."

    ^ AllowVisualAgePrimitives

    "
     AllowVisualAgePrimitives := true
     AllowVisualAgePrimitives := false
    "

    "Modified (comment): / 18-10-2011 / 16:49:12 / cg"
!

allowVisualAgePrimitives:aBoolean
    "this allows turning on/off support for V'Age primitives"

    AllowVisualAgePrimitives := aBoolean
!

allowVisualWorksMethodAnnotations
    "return true, if support for V'Works extended primitive syntax for method annotations."

    ^ AllowVisualWorksMethodAnnotations

    "Created: / 07-07-2006 / 15:49:32 / cg"
!

allowVisualWorksMethodAnnotations:aBoolean
    "turn on/off support for V'Works extended primitive syntax for method annotations."

    AllowVisualWorksMethodAnnotations := aBoolean

    "Created: / 07-07-2006 / 15:49:27 / cg"
!

warnAssignmentToBlockArgument
    ^ WarnAssignmentToBlockArgument
!

warnAssignmentToBlockArgument:aBoolean
    WarnAssignmentToBlockArgument := aBoolean
!

warnAssignmentToMethodArgument
    ^ WarnAssignmentToMethodArgument
!

warnAssignmentToMethodArgument:aBoolean
    WarnAssignmentToMethodArgument := aBoolean
!

warnAssignmentToPoolVariable
    ^ WarnAssignmentToPoolVariable
!

warnAssignmentToPoolVariable:aBoolean
    WarnAssignmentToPoolVariable := aBoolean
! !

!ParserFlags class methodsFor:'accessing-warning-control'!

warnAboutBadComments
    "controls generation of warning messages about empty comments"

    ^ WarnAboutBadComments
!

warnAboutBadComments:aBoolean
    "controls generation of warning messages about empty comments"

    WarnAboutBadComments := aBoolean
!

warnAboutNonLowercaseLocalVariableNames
    "controls generation of warning messages about wrong variable names"

    ^ WarnAboutNonLowercaseLocalVariableNames
!

warnAboutNonLowercaseLocalVariableNames:aBoolean
    "controls generation of warning messages about wrong variable names"

    WarnAboutNonLowercaseLocalVariableNames := aBoolean
!

warnAboutPeriodInSymbol
    ^ WarnAboutPeriodInSymbol
!

warnAboutPeriodInSymbol:aBoolean
    WarnAboutPeriodInSymbol := aBoolean
!

warnAboutPossibleSTCCompilationProblems
    ^ WarnAboutPossibleSTCCompilationProblems

    "Created: / 16-11-2006 / 14:31:52 / cg"
!

warnAboutPossibleSTCCompilationProblems:aBoolean
    WarnAboutPossibleSTCCompilationProblems := aBoolean

    "Created: / 16-11-2006 / 14:31:57 / cg"
!

warnAboutPossiblyUnimplementedSelectors
    ^ WarnAboutPossiblyUnimplementedSelectors
!

warnAboutPossiblyUnimplementedSelectors:aBoolean
    WarnAboutPossiblyUnimplementedSelectors := aBoolean
!

warnAboutReferenceToPrivateClass
    "controls generation of warning messages when a private class is referenced"

    ^ WarnAboutReferenceToPrivateClass
!

warnAboutReferenceToPrivateClass:aBoolean
    "controls generation of warning messages when a private class is referenced"

    WarnAboutReferenceToPrivateClass := aBoolean
!

warnAboutShortLocalVariableNames
    "controls generation of warning messages about short variable names"

    ^ WarnAboutShortLocalVariableNames
!

warnAboutShortLocalVariableNames:aBoolean
    "controls generation of warning messages about short variable names"

    WarnAboutShortLocalVariableNames := aBoolean
!

warnAboutUnknownCharacterEscapesInJavaScriptStringConstant
    "things like '\c:foo' instead of '\\c:foo' "

    ^ WarnAboutUnknownCharacterEscapesInJavaScriptStringConstant

    "Created: / 04-10-2011 / 19:54:57 / cg"
!

warnAboutUnknownCharacterEscapesInJavaScriptStringConstant:aBoolean
    "things like '\c:foo' instead of '\\c:foo' "

    WarnAboutUnknownCharacterEscapesInJavaScriptStringConstant := aBoolean

    "Created: / 04-10-2011 / 19:54:42 / cg"
!

warnAboutVariableNameConventions
    "controls generation of warning messages about wrong variable names"

    ^ WarnAboutVariableNameConventions
!

warnAboutVariableNameConventions:aBoolean
    "controls generation of warning messages about wrong variable names"

    WarnAboutVariableNameConventions := aBoolean
!

warnAboutWrongVariableNames
    "controls generation of warning messages about wrong variable names"

    ^ WarnAboutWrongVariableNames
!

warnAboutWrongVariableNames:aBoolean
    "controls generation of warning messages about wrong variable names"

    WarnAboutWrongVariableNames := aBoolean
!

warnCommonMistakes
    "return true, if common beginners mistakes are to be warned about"

    ^ WarnCommonMistakes
!

warnCommonMistakes:aBoolean
    "this allows turning on/off warnings about common beginners mistakes.
     Those are not really errors in the strict sense, but often lead to
     run time errors later.
     Examples are: expr or:expr2, where expr2 is not a block.
     If you get bored by those warnings, turn them off by adding
     a line as:
	ParserFlags warnCommonMistakes:false
     in your 'private.rc' file"

    WarnCommonMistakes := aBoolean

    "Modified: / 05-09-2006 / 11:46:26 / cg"
!

warnDollarInIdentifier
    "return true, if $-characters in identifiers are to be warned about"

    ^ Warnings and:[WarnDollarInIdentifier]

    "Created: 7.9.1997 / 01:36:17 / cg"
!

warnDollarInIdentifier:aBoolean
    "this allows turning on/off warnings about $-characters in identifiers.
     You may find those warnings useful, to make certain that your code
     is portable to other Smalltalk versions, which do not allow this
     (i.e. VW releases 2.x and maybe others).
     Notice, that dollars are NEVER allowed as the first character in an identifier.
     If you get bored by those warnings, turn them off by adding
     a line as:
        ParserFlags warnDollarInIdentifier:false
     in your 'private.rc' file"

    WarnDollarInIdentifier := aBoolean

    "Created: / 07-09-1997 / 01:37:42 / cg"
    "Modified: / 05-09-2006 / 11:46:23 / cg"
    "Modified (comment): / 16-11-2016 / 22:31:06 / cg"
!

warnHiddenVariables
    "controls generation of warning messages about hiding variables by locals"

    ^ WarnHiddenVariables
!

warnHiddenVariables:aBoolean
    "controls generation of warning messages about hiding variables by locals"

    WarnHiddenVariables := aBoolean
!

warnInconsistentReturnValues
    "return true, if compiler should warn about inconsitent (boolean / non-boolean)
     return values"

    ^ WarnInconsistentReturnValues
!

warnInconsistentReturnValues:aBoolean
    "constrols if the compiler should warn about inconsitent (boolean / non-boolean)
     return values"

    WarnInconsistentReturnValues := aBoolean
!

warnOldStyleAssignment
    "return true, if underscore-assignment (pre ST-80v4 syntax) are to be warned about"

    ^ Warnings and:[WarnOldStyleAssignment]
!

warnOldStyleAssignment:aBoolean
    "this allows turning on/off warnings about underscore-assignment (pre ST-80v4 syntax).
     If you get bored by those warnings, turn them off by adding
     a line as:
	ParserFlags warnOldStyleAssignment:false
     in your 'private.rc' file"

    WarnOldStyleAssignment := aBoolean

    "Modified: / 05-09-2006 / 11:46:17 / cg"
!

warnParagraphInIdentifier
    "return true, if §-characters in identifiers are to be warned about"

    ^ Warnings and:[WarnParagraphInIdentifier]

    "Created: / 16-11-2016 / 22:30:01 / cg"
!

warnParagraphInIdentifier:aBoolean
    "this allows turning on/off warnings about §-characters in identifiers.
     You may find those warnings useful, to make certain that your code
     is portable to other Smalltalk versions, which do not allow this"

    WarnParagraphInIdentifier := aBoolean

    "Created: / 16-11-2016 / 22:30:45 / cg"
!

warnPlausibilityChecks
    "controls generation of warning messages about plausibility checks (possible precedence, etc.)"

    ^ WarnPlausibilityChecks

    "Created: / 19-01-2012 / 10:38:20 / cg"
!

warnPlausibilityChecks:aBoolean
    "controls generation of warning messages about plausibility checks (possible precedence, etc.)"

    WarnPlausibilityChecks := aBoolean

    "Created: / 19-01-2012 / 10:38:39 / cg"
!

warnPossibleIncompatibilities
    "return true, if possible incompatibilities (with other ST systems)
     are to be warned about"

    ^ Warnings and:[WarnPossibleIncompatibilities]

    "Modified: 23.5.1997 / 12:02:02 / cg"
!

warnPossibleIncompatibilities:aBoolean
    "this turns warnings about possible incompatibilities (with other ST systems)
     on or off.
     If you get bored by those warnings, turn them off by adding
     a line as:
	ParserFlags warnPossibleIncompatibilities:false
     in your 'private.rc' file."

    WarnPossibleIncompatibilities := aBoolean

    "Created: / 23-05-1997 / 12:02:45 / cg"
    "Modified: / 05-09-2006 / 11:46:14 / cg"
!

warnSTXSpecials
    "return true, if ST/X specials are to be warned about"

    ^ Warnings and:[WarnSTXSpecials]
!

warnSTXSpecials:aBoolean
    "this allows turning on/off warnings about stx specials.
     If you get bored by those warnings, turn them off by adding
     a line as:
	ParserFlags warnSTXSpecials:false
     in your 'private.rc' file"

    WarnSTXSpecials := aBoolean

    "Modified: / 05-09-2006 / 11:46:11 / cg"
!

warnUnderscoreInIdentifier
    "return true, if underscores in identifiers are to be warned about"

    ^ Warnings and:[WarnUnderscoreInIdentifier]
!

warnUnderscoreInIdentifier:aBoolean
    "this allows turning on/off warnings about underscores in identifiers.
     You may find those warnings useful, to make certain that your code
     is portable to other smalltalk versions, which do not allow this
     (i.e. VW releases 2.x).
     If you get bored by those warnings, turn them off by adding
     a line as:
	ParserFlags warnUnderscoreInIdentifier:false
     in your 'private.rc' file"

    WarnUnderscoreInIdentifier := aBoolean

    "Modified: / 05-09-2006 / 11:46:08 / cg"
!

warnUnusedVars
    "controls generation of warning messages about unued method variables"

    ^ WarnUnusedVars
!

warnUnusedVars:aBoolean
    "controls generation of warning messages about unued method variables"

    WarnUnusedVars := aBoolean
!

warnings
    "return true, if any warnings are to be shown"

    ^ Warnings
!

warnings:aBoolean
    "this allows turning on/off all warnings; the default is on.
     You can turn off warnings in your 'private.rc' file with
	 ParserFlags warnings:false
    "

    Warnings := aBoolean

    "
     ParserFlags warnings
     ParserFlags warnings:true
     ParserFlags warnings:false
    "

    "Modified: / 05-09-2006 / 11:46:47 / cg"
! !

!ParserFlags class methodsFor:'class initialization'!

initialize
    | executablePath topDirectory stcExe |

    Warnings := true.
    WarnUndeclared := true.
    WarnUnusedVars := true.
    WarnSTXSpecials := false.
    WarnST80Directives := false.
    WarnAboutWrongVariableNames := true.
    WarnAboutVariableNameConventions := true.
    WarnAboutBadComments := true.
    WarnUnderscoreInIdentifier := false.
    WarnDollarInIdentifier := true.
    WarnParagraphInIdentifier := true.
    WarnOldStyleAssignment := true.
    WarnCommonMistakes := true.
    WarnPossibleIncompatibilities := false.
    WarnHiddenVariables := true.
    WarnInconsistentReturnValues := true.
    WarnAboutNonLowercaseLocalVariableNames := true.
    WarnAboutShortLocalVariableNames := false.
    WarnAboutPossibleSTCCompilationProblems := true.
    WarnAboutReferenceToPrivateClass := true.
    WarnAboutPossiblyUnimplementedSelectors := true.
    WarnAboutPeriodInSymbol := true.
    WarnAboutUnknownCharacterEscapesInJavaScriptStringConstant := false.
    WarnPlausibilityChecks := true.
    WarnAssignmentToBlockArgument := true.
    WarnAssignmentToMethodArgument := true.
    WarnAssignmentToPoolVariable := true.

    AllowReservedWordsAsSelectors := false.
    AllowUnderscoreInIdentifier := true.
    AllowParagraphInIdentifier := false.
    AllowDollarInIdentifier := false.           "/ st80-vms dollars in identifiers
    AllowOldStyleAssignment := true.            "/ st80 underscore as assignment
    AllowDolphinExtensions := false.            "/ dolphin computed literal
    AllowQualifiedNames := false.               "/ vw3 qualified names
    AllowExtendedBinarySelectors := false.      "/ vw5.4 extended binary selectors (plus/minus, center-dot etc.)
    AllowCaretAsBinop := false.                 "/ too dangerous
    AllowLiteralNameSpaceSymbols := true.       "/ st/x literal nameSpace-symbols (#foo::bar)
    AllowArrayIndexSyntaxExtension := false.
    AllowFunctionCallSyntaxForBlockEvaluation := false.
    AllowLocalVariableDeclarationWithInitializerExpression := false.
    AllowDomainVariables := false.
    AllowArrayIndexSyntaxExtension := false.
    AllowReservedWordsAsSelectors := true.
    AllowVariableReferences := false.
    AllowLazyValueExtension := false.
    AllowFixedPointLiterals := true "false".
    AllowExtendedSTXSyntax := false.
    AllowVisualAgeESSymbolLiterals := false.
    AllowExtensionsToPrivateClasses := true.
    AllowVisualAgePrimitives := false.
    AllowSqueakExtensions := true.              "/ squeak computed array
    AllowSqueakPrimitives := false.
    AllowSTVPrimitives := false.                "/ number-sign syntax
    AllowSTVExtensions := false.
    AllowNationalCharactersInIdentifier := false.
    AllowHashAsBinarySelector := true.
    AllowSTXEOLComments := true.
    AllowSTXDelimiterComments := true.         "/ until stc and RBScanner support it also
    AllowVisualWorksMethodAnnotations := false.
    AllowPossibleSTCCompilationProblems := true. "/ must be true, to allow fileIn!!
    AllowEmptyStatements := false.
    AllowPeriodInSymbol := false.
    "/ these are only used by the new compiler
    AllowUnicodeStrings := false.
    AllowUnicodeCharacters := false.
    AllowCharacterEscapes := false.
    AllowStringEscapes := false.
    AllowAssignmentToBlockArgument := false.
    AllowAssignmentToMethodArgument := false.
    AllowAssignmentToPoolVariable := false.
    "/ AllowAssignmentToPoolVariable := true.
    AllowSignedByteArrayElements := false.
    AllowSymbolsStartingWithDigit := false.

    AllowJavaScriptConst := true.              
    
    ArraysAreImmutable := false.                "/ still care for ST-80 compatibility
    StringsAreImmutable := false.               "/ still care for ST-80 compatibility
    "/ ArraysAreImmutable := true.                 "/ do not care for ST-80 compatibility
    "/ StringsAreImmutable := true.                "/ do not care for ST-80 compatibility
    ImplicitSelfSends := false.
    
    STCKeepCIntermediate := false.
    STCKeepOIntermediate := false.
    STCKeepSTIntermediate := false.
    STCCompilation := #default.

    DefineForBorlandC := '__BORLANDC__'.
    DefineForVisualC := '__VISUALC__'.
    DefineForMSC := '__MSC__'.
    DefineForGNUC := '__GNUC__'.
    DefineForMINGW := '__MINGW__'.
    DefineForMINGW32 := '__MINGW32__'.
    DefineForMINGW64 := '__MINGW64__'.
    DefineForCLANG := '__CLANG__'.

    stcExe := OperatingSystem isMSWINDOWSlike ifTrue:['stc.exe'] ifFalse:['stc'].

    (executablePath := OperatingSystem pathOfSTXExecutable) notNil ifTrue:[
        topDirectory := executablePath asFilename directory.
        (((topDirectory / 'include') exists and:[(topDirectory / 'stc') exists or:[(topDirectory / 'bin' / stcExe) exists]])
          or:[
            topDirectory := topDirectory directory.
            ((topDirectory / 'include') exists and:[(topDirectory / 'stc') exists or:[(topDirectory / 'bin' / stcExe) exists]])
              or:[
                topDirectory := topDirectory directory.
                ((topDirectory / 'include') exists and:[(topDirectory / 'stc') exists or:[(topDirectory / 'bin' / stcExe) exists]])
              ]
           ]
        ) ifTrue:[
            self initializeSTCFlagsForTopDirectory: topDirectory.
        ]
    ].


    self useGnuC ifTrue:[ 
        self initializeSTCFlagsForGCC.
    ].
    self useClang ifTrue:[ 
        self initializeSTCFlagsForClang.
    ].    
    self useMingw32 ifTrue:[ 
        self initializeSTCFlagsForMINGW32.
    ].
    self useMingw64 ifTrue:[ 
        self initializeSTCFlagsForMINGW64.
    ].
    



    "
     ParserFlags initialize
    "

    "Modified: / 09-08-2006 / 18:47:18 / fm"
    "Modified: / 08-08-2017 / 23:49:41 / cg"
    "Modified: / 06-01-2016 / 22:25:30 / jv"
    "Modified: / 21-03-2018 / 23:20:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeSTCFlagsForClang
    self ccPath: 'clang'.
    self linkCommand: 'clang'.
    ExternalAddress pointerSize == 4 ifTrue:[
        self linkArgs: '-m32'.
        self linkSharedArgs: '-shared -m32'
    ] ifFalse:[ 
        self linkArgs: '-m64'.
        self linkSharedArgs: '-shared -m64'
    ].

    "Created: / 21-03-2018 / 23:20:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeSTCFlagsForGCC
    self ccPath: 'gcc'.
    self linkCommand: 'gcc'.
    ExternalAddress pointerSize == 4 ifTrue:[
        self linkArgs: '-m32'.
        self linkSharedArgs: '-shared -m32'
    ] ifFalse:[ 
        self linkArgs: '-m64'.
        self linkSharedArgs: '-shared -m64'
    ].

    "Created: / 09-12-2015 / 22:10:52 / jv"
    "Modified: / 03-02-2016 / 23:48:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeSTCFlagsForMINGW32
    | mingwDirs mingwDir |

    mingwDirs := Array with: (OperatingSystem getEnvironment: 'MINGW_DIR')
                       with: 'C:\MSYS64\MINGW32' 
                       with: 'C:\MINGW'.        
    mingwDir := mingwDirs detect:[:e | e notNil and:[e asFilename isDirectory ] ] ifNone:[ ^ self ].
    mingwDir := mingwDir asFilename.

    self ccPath: (mingwDir / 'bin' / 'gcc') pathName.
    self linkCommand: (mingwDir / 'bin' / 'gcc') pathName.
    self linkArgs: ''.
    self linkSharedArgs: '-shared'

    "Created: / 09-12-2015 / 22:00:19 / jv"
    "Modified: / 17-06-2016 / 16:39:41 / jv"
!

initializeSTCFlagsForMINGW64
    | mingwDirs mingwDir |

    mingwDirs := Array with: (OperatingSystem getEnvironment: 'MINGW_DIR')  
                       with: 'C:\MSYS64\MINGW64'
                       with: 'C:\MINGW64'.        
    mingwDir := mingwDirs detect:[:e | e notNil and:[e asFilename isDirectory ] ] ifNone:[ ^ self ].
    mingwDir := mingwDir asFilename.

    self ccPath: (mingwDir / 'bin' / 'gcc') pathName.
    self linkCommand: (mingwDir / 'bin' / 'gcc') pathName.
    self linkArgs: ''.
    self linkSharedArgs: '-shared'

    "Created: / 09-12-2015 / 22:07:25 / jv"
    "Modified: / 17-06-2016 / 16:39:36 / jv"
!

initializeSTCFlagsForTopDirectory:topDirArg
    "topDirArg must be the stx directory (where stc directory with stc-executable is found)
     notice: for now, can only initialize for borland+windows or linux;
     visualC setup still fails."

    |topDir topDirName stcExe stcPath |

    topDir := topDirArg.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        topDirArg isString ifTrue:[
            topDir := topDirArg copyReplaceAll:$/ with:$\ ifNone:topDirArg.
        ]
    ].
    topDir := topDir asFilename.
    topDirName := topDir name.

    "/ if in the development directory, use ./modules
    Smalltalk isSmalltalkDevelopmentSystem ifTrue:[
        STCModulePath := UserPreferences current workspaceDirectory / 'modules'.
    ] ifFalse:[
        STCModulePath := Filename tempDirectory / 'modules'.
    ].

    stcExe := OperatingSystem isMSWINDOWSlike ifTrue:['stc.exe'] ifFalse:['stc'].

    (stcPath := topDir / 'stc' / stcExe) exists ifTrue:[
        "/ build-tree environment
        STCPath := stcPath pathName.        
    ] ifFalse:[
        (stcPath := topDir / 'bin' / stcExe) exists ifTrue:[
            "/ Packaged environment
            STCPath := stcPath pathName.        
        ] ifFalse:[
            Logger warning: 'stc not found in "%1"' with: topDirName.
            Logger warning: 'stc-compiling (primitive code) will not work in the browser'. 
            STCCompilation := #never.
        ]
    ].


    STCCompilationOptions := '+optinline +inlineNew'.
    LibPath := ''.
    SearchedLibraries := #().
    MakeCommand := 'make'
    .
    "
     ParserFlags initializeSTCFlagsForTopDirectory:'../..'
     ParserFlags initialize
    "

    "Modified: / 09-08-2006 / 18:47:18 / fm"
    "Created: / 06-08-2011 / 19:47:47 / cg"
    "Modified: / 09-12-2015 / 17:03:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-01-2016 / 22:45:09 / jv"
! !

!ParserFlags methodsFor:'accessing'!

fullLineNumberInfo
    ^ (self lineNumberInfo == #full)

    "Created: / 26-09-2012 / 14:13:42 / cg"
!

lineNumberInfo
    ^ lineNumberInfo

    "Created: / 26-09-2012 / 13:27:08 / cg"
!

lineNumberInfo:something
    lineNumberInfo := something.

    "Created: / 26-09-2012 / 13:27:17 / cg"
! !

!ParserFlags methodsFor:'accessing-compilation control'!

allowExtensionsToPrivateClasses
    ^ allowExtensionsToPrivateClasses
!

allowExtensionsToPrivateClasses:aBoolean
    allowExtensionsToPrivateClasses := aBoolean
!

allowPossibleSTCCompilationProblems
    ^ allowPossibleSTCCompilationProblems

    "Created: / 16-11-2006 / 14:24:54 / cg"
!

allowPossibleSTCCompilationProblems:aBoolean
    allowPossibleSTCCompilationProblems := aBoolean

    "Created: / 16-11-2006 / 14:24:56 / cg"
!

arraysAreImmutable
    ^ arraysAreImmutable
!

arraysAreImmutable:aBoolean
    arraysAreImmutable := aBoolean.
!

flattenVisualWorksNamespaces
    ^ true
!

stringsAreImmutable
    ^ stringsAreImmutable
!

stringsAreImmutable:aBoolean
    stringsAreImmutable := aBoolean.
! !

!ParserFlags methodsFor:'accessing-stc compilation control'!

ccCompilationOptions
    ^ ccCompilationOptions ? ''

    "
     self ccCompilationOptions
    "

    "Modified (comment): / 17-11-2016 / 15:40:29 / cg"
!

ccCompilationOptions:something
    ccCompilationOptions := something.
!

ccPath
    ^ ccPath

    "
     self ccPath
    "

    "Modified (comment): / 17-11-2016 / 15:40:40 / cg"
!

ccPath:something
    ccPath := something.
!

implicitSelfSends
    ^ implicitSelfSends
!

implicitSelfSends:aBoolean
    implicitSelfSends := aBoolean.
!

libPath
    ^ libPath

    "
     self libPath
    "

    "Modified (comment): / 17-11-2016 / 15:40:52 / cg"
!

libPath:aString
    libPath := aString
!

linkArgs
    ^ linkArgs

    "
     self linkArgs
    "

    "Modified (comment): / 17-11-2016 / 15:41:03 / cg"
!

linkArgs:aString
    linkArgs := aString
!

linkCommand
    ^ linkCommand

    "
     self linkCommand
    "

    "Modified (comment): / 17-11-2016 / 15:41:16 / cg"
!

linkCommand:aString
    linkCommand := aString
!

linkSharedArgs
    ^ linkSharedArgs
!

linkSharedArgs:aString
    linkSharedArgs := aString
!

searchedLibraries
    ^ searchedLibraries
!

searchedLibraries:aString
    searchedLibraries := aString
!

stcCompilation
    ^ stcCompilation
!

stcCompilation:something
    stcCompilation := something.
!

stcCompilationDefines
    ^ stcCompilationDefines
!

stcCompilationDefines:something
    stcCompilationDefines := something.
!

stcCompilationIncludes
    ^ stcCompilationIncludes

    "
     self stcCompilationIncludes
    "

    "Modified (comment): / 17-11-2016 / 15:41:43 / cg"
!

stcCompilationIncludes:something
    stcCompilationIncludes := something.
!

stcCompilationOptions
    ^ stcCompilationOptions
!

stcCompilationOptions:something
    stcCompilationOptions := something.
!

stcKeepCIntermediate
    ^ stcKeepCIntermediate ? false

    "Modified: / 16-09-2011 / 19:56:22 / cg"
!

stcKeepCIntermediate:something
    stcKeepCIntermediate := something.
!

stcKeepOIntermediate
    ^ stcKeepOIntermediate ? false

    "Modified: / 16-09-2011 / 19:56:52 / cg"
!

stcKeepOIntermediate:something
    stcKeepOIntermediate := something.
!

stcKeepSIntermediate
    ^ false
    "/ ^ true
!

stcKeepSTIntermediate
    ^ stcKeepSTIntermediate ? false

    "Modified: / 16-09-2011 / 19:57:11 / cg"
!

stcKeepSTIntermediate:something
    stcKeepSTIntermediate := something.
!

stcModulePath
    stcModulePath isNil ifTrue:[^ self class stcModulePath].
    ^ stcModulePath
!

stcModulePath:aPath
    "set the path to the directory (for an individual compilation context).
     Obsolete now, as this should not be set from the outside,
     but instead rely totally on the userPreferences."

    stcModulePath := aPath.
!

stcPath
    ^ stcPath
!

stcPath:aPath
    stcPath := aPath.
! !

!ParserFlags methodsFor:'accessing-syntax-control'!

allowArrayIndexSyntaxExtension
    ^ allowArrayIndexSyntaxExtension ? false

    "Modified: / 08-08-2017 / 16:57:03 / cg"
!

allowArrayIndexSyntaxExtension:aBoolean
    allowArrayIndexSyntaxExtension := aBoolean.
!

allowAssignmentToBlockArgument
    ^ allowAssignmentToBlockArgument
!

allowAssignmentToBlockArgument:aBoolean
    allowAssignmentToBlockArgument := aBoolean.
!

allowAssignmentToMethodArgument
    ^ allowAssignmentToMethodArgument
!

allowAssignmentToMethodArgument:aBoolean
    allowAssignmentToMethodArgument := aBoolean.
!

allowAssignmentToPoolVariable
    ^ allowAssignmentToPoolVariable
!

allowAssignmentToPoolVariable:aBoolean
    allowAssignmentToPoolVariable := aBoolean.
!

allowCaretAsBinop
    ^ allowCaretAsBinop
!

allowCaretAsBinop:aBoolean
    allowCaretAsBinop := aBoolean.
!

allowCharacterEscapes
    ^ allowCharacterEscapes
!

allowCharacterEscapes:aBoolean
    allowCharacterEscapes := aBoolean.
!

allowDollarInIdentifier
    ^ allowDollarInIdentifier
!

allowDollarInIdentifier:aBoolean
    allowDollarInIdentifier := aBoolean.
!

allowDolphinExtensions
    ^ allowDolphinExtensions
!

allowDolphinExtensions:aBoolean
    allowDolphinExtensions := aBoolean
!

allowDomainVariables
    ^ allowDomainVariables
!

allowDomainVariables:aBoolean
    allowDomainVariables := aBoolean.
!

allowEmptyStatements
    ^ allowEmptyStatements ? false

    "Created: / 20-11-2006 / 13:56:14 / cg"
!

allowEmptyStatements:aBoolean
    allowEmptyStatements := aBoolean.

    "Created: / 20-11-2006 / 14:26:48 / cg"
!

allowExtendedBinarySelectors
    ^ allowExtendedBinarySelectors
!

allowExtendedBinarySelectors:aBoolean
    allowExtendedBinarySelectors := aBoolean.
!

allowExtendedSTXSyntax
    ^ allowExtendedSTXSyntax
!

allowExtendedSTXSyntax:aBoolean
    allowExtendedSTXSyntax := aBoolean.
!

allowFixedPointLiterals
    ^ allowFixedPointLiterals
!

allowFixedPointLiterals:aBoolean
    allowFixedPointLiterals := aBoolean.
!

allowFunctionCallSyntaxForBlockEvaluation
    ^ allowFunctionCallSyntaxForBlockEvaluation ? false

    "Modified: / 08-08-2017 / 16:57:17 / cg"
!

allowFunctionCallSyntaxForBlockEvaluation:aBoolean
    allowFunctionCallSyntaxForBlockEvaluation := aBoolean.
!

allowHashAsBinarySelector
    ^ allowHashAsBinarySelector
!

allowJavaScriptConst
    ^ allowJavaScriptConst

    "Created: / 08-08-2017 / 23:50:12 / cg"
!

allowJavaScriptConst:aBoolean
    allowJavaScriptConst := aBoolean

    "Created: / 08-08-2017 / 23:50:23 / cg"
!

allowLazyValueExtension
    ^ allowLazyValueExtension
!

allowLazyValueExtension:aBoolean
    allowLazyValueExtension := aBoolean.
!

allowLiteralNameSpaceSymbols
    ^ allowLiteralNameSpaceSymbols
!

allowLiteralNameSpaceSymbols:aBoolean
    allowLiteralNameSpaceSymbols := aBoolean
!

allowLocalVariableDeclarationWithInitializerExpression
    ^ allowLocalVariableDeclarationWithInitializerExpression
!

allowLocalVariableDeclarationWithInitializerExpression:aBoolean
    allowLocalVariableDeclarationWithInitializerExpression := aBoolean.
!

allowNationalCharactersInIdentifier
    ^ allowNationalCharactersInIdentifier
!

allowNationalCharactersInIdentifier:aBoolean
    allowNationalCharactersInIdentifier := aBoolean
!

allowOldStyleAssignment
    "return true, if underscore-assignment (pre ST-80v4 syntax) are to be allowed"

    ^ allowOldStyleAssignment
!

allowOldStyleAssignment:aBoolean
    "return true, if underscore-assignment (pre ST-80v4 syntax) are to be allowed"
    
    allowOldStyleAssignment := aBoolean
!

allowParagraphInIdentifier
    ^ allowParagraphInIdentifier

    "Created: / 16-11-2016 / 22:29:06 / cg"
!

allowParagraphInIdentifier:aBoolean
    allowParagraphInIdentifier := aBoolean.

    "Created: / 16-11-2016 / 22:29:14 / cg"
!

allowPeriodInSymbol
    ^ allowPeriodInSymbol
!

allowPeriodInSymbol:aBoolean
    allowPeriodInSymbol := aBoolean
!

allowQualifiedNames
    ^ allowQualifiedNames
!

allowQualifiedNames:aBoolean
    allowQualifiedNames := aBoolean.
!

allowReservedWordsAsSelectors
    ^ allowReservedWordsAsSelectors
!

allowReservedWordsAsSelectors:aBoolean
    allowReservedWordsAsSelectors := aBoolean.
!

allowSTVExtensions
    "return true, if support for ST/V extensions is enabled."

    ^ allowSTVExtensions
!

allowSTVPrimitives
    "return true, if support for ST/V primitives is enabled."

    ^ allowSTVPrimitives
!

allowSTXDelimiterComments
    "are ST/X token-delimited comments allowed?
     (see comment on class side)"

    ^ allowSTXDelimiterComments
!

allowSTXDelimiterComments:aBoolean
    "are ST/X token-delimited comments allowed?
     (see comment on class side)"

    allowSTXDelimiterComments := aBoolean.

    "
     ParserFlags allowSTXDelimiterComments:false
     ParserFlags allowSTXDelimiterComments:true
    "
!

allowSTXEOLComments
    "are ST/X end-of-line comments allowed?"

    ^ allowSTXEOLComments
!

allowSTXEOLComments:aBoolean
    "are ST/X end-of-line comments allowed?"

    allowSTXEOLComments := aBoolean.

    "
     ParserFlags allowSTXEOLComments:false
     ParserFlags allowSTXEOLComments:true
    "
!

allowSTXExtendedArrayLiterals
    "are scheme-style typed literal arrays allowed?"

    ^ allowSTXExtendedArrayLiterals ? false
!

allowSTXExtendedArrayLiterals:aBoolean
    "are scheme-style typed literal arrays allowed?"

    allowSTXExtendedArrayLiterals := aBoolean
!

allowSTXFunctions
    ^ false

    "Created: / 23-05-2011 / 17:43:45 / cg"
!

allowSignedByteArrayElements
    ^ allowSignedByteArrayElements
!

allowSignedByteArrayElements:aBoolean
    allowSignedByteArrayElements := aBoolean
!

allowSqueakExtensions
    "return true, if support for squeak extensions
	computed arrays { .., }
	c/java style arguments in message sends rec foo(arg1, ... argN)
     is enabled."

    ^ allowSqueakExtensions
!

allowSqueakExtensions:aBoolean
    "this allows turning on/off support for squeak extensions:
	computed arrays { .., }
	c/java style arguments in message sends rec foo(arg1, ... argN)
    "

    allowSqueakExtensions := aBoolean
!

allowSqueakPrimitives
    "return true, if support for squeak primitives is enabled."

    ^ allowSqueakPrimitives
!

allowSqueakPrimitives:aBoolean
    "this allows turning on/off support for squeak primitives"

    allowSqueakPrimitives := aBoolean
!

allowStringEscapes
    ^ allowStringEscapes
!

allowStringEscapes:aBoolean
    allowStringEscapes := aBoolean.
!

allowSymbolsStartingWithDigit
    "return true, if a symbol is allowed to start with a digit
     i.e. as in #2D.
     This seems to be ok in new Squeak/Pharo versions"

    ^ allowSymbolsStartingWithDigit

    "Created: / 18-06-2017 / 16:26:08 / cg"
!

allowSymbolsStartingWithDigit:aBoolean
    "control if a symbol is allowed to start with a digit
     i.e. as in #2D.
     This seems to be ok in new Squeak/Pharo versions"

    allowSymbolsStartingWithDigit := aBoolean

    "Created: / 18-06-2017 / 16:26:23 / cg"
!

allowUnderscoreInIdentifier
    ^ allowUnderscoreInIdentifier
!

allowUnderscoreInIdentifier:aBoolean
    allowUnderscoreInIdentifier := aBoolean
!

allowUnicodeCharacters
    ^ allowUnicodeCharacters
!

allowUnicodeCharacters:aBoolean
    allowUnicodeCharacters := aBoolean
!

allowUnicodeStrings
    ^ allowUnicodeStrings
!

allowUnicodeStrings:aBoolean
    allowUnicodeStrings := aBoolean
!

allowVariableReferences
    ^ allowVariableReferences
!

allowVariableReferences:aBoolean
    allowVariableReferences := aBoolean.
!

allowVisualAgeESSymbolLiterals
    ^ allowVisualAgeESSymbolLiterals
!

allowVisualAgeESSymbolLiterals:aBoolean
    allowVisualAgeESSymbolLiterals := aBoolean.
!

allowVisualAgePrimitives
    "return true, if support for V'Age primitives is enabled."

    ^ allowVisualAgePrimitives
!

allowVisualAgePrimitives:aBoolean
    "this allows turning on/off support for V'Age primitives"

    allowVisualAgePrimitives := aBoolean
!

allowVisualWorksMethodAnnotations
    "return true, if support for V'Works extended primitive syntax for method annotations."

    ^ allowVisualWorksMethodAnnotations

    "Created: / 07-07-2006 / 15:48:30 / cg"
!

allowVisualWorksMethodAnnotations:aBoolean
    "turn on/off support for V'Works extended primitive syntax for method annotations."

    allowVisualWorksMethodAnnotations := aBoolean

    "Created: / 07-07-2006 / 15:49:03 / cg"
!

warnAssignmentToBlockArgument
    ^ warnAssignmentToBlockArgument
!

warnAssignmentToBlockArgument:aBoolean
    warnAssignmentToBlockArgument := aBoolean.
!

warnAssignmentToMethodArgument
    ^ warnAssignmentToMethodArgument
!

warnAssignmentToMethodArgument:aBoolean
    warnAssignmentToMethodArgument := aBoolean.
!

warnAssignmentToPoolVariable
    ^ warnAssignmentToPoolVariable
!

warnAssignmentToPoolVariable:aBoolean
    warnAssignmentToPoolVariable := aBoolean.
! !

!ParserFlags methodsFor:'accessing-warning-control'!

warnAboutBadComments
    ^ warnAboutBadComments
!

warnAboutBadComments:aBoolean
    warnAboutBadComments := aBoolean.
!

warnAboutNonLowercaseLocalVariableNames
    ^ warnAboutNonLowercaseLocalVariableNames
!

warnAboutNonLowercaseLocalVariableNames:aBoolean
    warnAboutNonLowercaseLocalVariableNames := aBoolean.
!

warnAboutPeriodInSymbol
    ^ warnAboutPeriodInSymbol
!

warnAboutPeriodInSymbol:aBoolean
    warnAboutPeriodInSymbol := aBoolean.
!

warnAboutPossibleSTCCompilationProblems
    ^ warnAboutPossibleSTCCompilationProblems

    "Created: / 16-11-2006 / 14:24:38 / cg"
!

warnAboutPossibleSTCCompilationProblems:aBoolean
    warnAboutPossibleSTCCompilationProblems := aBoolean.

    "Created: / 16-11-2006 / 14:24:40 / cg"
!

warnAboutPossiblyUnimplementedSelectors
    ^ warnAboutPossiblyUnimplementedSelectors
!

warnAboutPossiblyUnimplementedSelectors:aBoolean
    warnAboutPossiblyUnimplementedSelectors := aBoolean.
!

warnAboutReferenceToPrivateClass
    "controls generation of warning messages when a private class is referenced"

    ^ warnAboutReferenceToPrivateClass
!

warnAboutReferenceToPrivateClass:aBoolean
    "controls generation of warning messages when a private class is referenced"

    warnAboutReferenceToPrivateClass := aBoolean
!

warnAboutShortLocalVariableNames
    ^ warnAboutShortLocalVariableNames
!

warnAboutShortLocalVariableNames:aBoolean
    warnAboutShortLocalVariableNames := aBoolean.
!

warnAboutUnknownCharacterEscapesInJavaScriptStringConstant
    ^ warnAboutUnknownCharacterEscapesInJavaScriptStringConstant ? false

    "Created: / 04-10-2011 / 19:51:19 / cg"
!

warnAboutUnknownCharacterEscapesInJavaScriptStringConstant:aBoolean
    warnAboutUnknownCharacterEscapesInJavaScriptStringConstant := aBoolean.

    "Created: / 04-10-2011 / 19:51:27 / cg"
!

warnAboutVariableNameConventions
    ^ warnAboutVariableNameConventions
!

warnAboutVariableNameConventions:aBoolean
    warnAboutVariableNameConventions := aBoolean.
!

warnAboutWrongVariableNames
    ^ warnAboutWrongVariableNames
!

warnAboutWrongVariableNames:aBoolean
    warnAboutWrongVariableNames := aBoolean.
!

warnCommonMistakes
    ^ warnCommonMistakes
!

warnCommonMistakes:aBoolean
    warnCommonMistakes := aBoolean.
!

warnDollarInIdentifier
    ^ warnDollarInIdentifier
!

warnDollarInIdentifier:aBoolean
    warnDollarInIdentifier := aBoolean.
!

warnHiddenVariables
    ^ warnHiddenVariables
!

warnHiddenVariables:aBoolean
    "controls generation of warning messages about hiding variables by locals"

    warnHiddenVariables := aBoolean.

    "Modified: / 30-11-2010 / 15:00:55 / cg"
!

warnInconsistentReturnValues
    ^ warnInconsistentReturnValues
!

warnInconsistentReturnValues:aBoolean
    warnInconsistentReturnValues := aBoolean.
!

warnOldStyleAssignment
    ^ warnOldStyleAssignment
!

warnOldStyleAssignment:aBoolean
    warnOldStyleAssignment := aBoolean.
!

warnParagraphInIdentifier
    ^ warnParagraphInIdentifier

    "Created: / 16-11-2016 / 22:29:33 / cg"
!

warnParagraphInIdentifier:aBoolean
    warnParagraphInIdentifier := aBoolean.

    "Created: / 16-11-2016 / 22:29:45 / cg"
!

warnPlausibilityChecks
    "controls generation of warning messages about plausibility checks (possible precedence, etc.)"

    ^ warnPlausibilityChecks ? true

    "Created: / 19-01-2012 / 10:38:54 / cg"
!

warnPlausibilityChecks:aBoolean
    "controls generation of warning messages about plausibility checks (possible precedence, etc.)"

    warnPlausibilityChecks := aBoolean

    "Created: / 19-01-2012 / 10:39:02 / cg"
!

warnPossibleIncompatibilities
    "holds true, if possible incompatibilities (with other ST systems)
     are to be warned about"

    ^ warnPossibleIncompatibilities
!

warnPossibleIncompatibilities:aBoolean
    "holds true, if possible incompatibilities (with other ST systems)
     are to be warned about"

    warnPossibleIncompatibilities := aBoolean.
!

warnST80Directives
    ^ warnST80Directives
!

warnST80Directives:aBoolean
    warnST80Directives := aBoolean.

    "Modified: / 30-01-2011 / 13:01:06 / cg"
!

warnSTXHereExtensionUsed
    ^ warnSTXHereExtensionUsed
!

warnSTXHereExtensionUsed:aBoolean
    warnSTXHereExtensionUsed := aBoolean.
!

warnSTXNameSpaceUse
    ^ warnSTXNameSpaceUse
!

warnSTXNameSpaceUse:aBoolean
    warnSTXNameSpaceUse := aBoolean.
!

warnSTXSpecialComment
    ^ warnSTXSpecialComment
!

warnSTXSpecialComment:aBoolean
    warnSTXSpecialComment := aBoolean.
!

warnUndeclared
    ^ warnUndeclared
!

warnUndeclared:aBoolean
    warnUndeclared := aBoolean.
!

warnUnderscoreInIdentifier
    ^ warnUnderscoreInIdentifier
!

warnUnderscoreInIdentifier:aBoolean
    warnUnderscoreInIdentifier := aBoolean.
!

warnUnusedVars
    ^ warnUnusedVars
!

warnUnusedVars:aBoolean
    warnUnusedVars := aBoolean.
!

warnings
    ^ warnings ? true

    "Modified: / 30-01-2011 / 13:05:48 / cg"
!

warnings:aBoolean
    warnings := aBoolean.

    "Modified: / 30-01-2011 / 13:00:51 / cg"
! !

!ParserFlags methodsFor:'initialization'!

initialize
    "each instance is initially setup from the classes global defaults.
     (but can be changed as required for an individual compilation run"

    warnings := Warnings.
    warnUndeclared := WarnUndeclared.
    warnUnusedVars := WarnUnusedVars.
    warnST80Directives := WarnST80Directives.
    warnSTXSpecialComment := WarnSTXSpecials.
    warnSTXNameSpaceUse := WarnSTXSpecials.
    warnSTXHereExtensionUsed := WarnSTXSpecials.
    warnUnderscoreInIdentifier := WarnUnderscoreInIdentifier.
    warnDollarInIdentifier := WarnDollarInIdentifier.
    warnParagraphInIdentifier := WarnParagraphInIdentifier.
    warnOldStyleAssignment := WarnOldStyleAssignment.
    warnCommonMistakes := WarnCommonMistakes.
    warnPossibleIncompatibilities := WarnPossibleIncompatibilities.
    warnAboutVariableNameConventions := WarnAboutVariableNameConventions.
    warnAboutWrongVariableNames := WarnAboutWrongVariableNames.
    warnAboutBadComments := WarnAboutBadComments.
    warnAboutReferenceToPrivateClass := WarnAboutReferenceToPrivateClass.
    warnHiddenVariables := WarnHiddenVariables.
    warnInconsistentReturnValues := WarnInconsistentReturnValues.
    warnAboutNonLowercaseLocalVariableNames := WarnAboutNonLowercaseLocalVariableNames.
    warnAboutShortLocalVariableNames := WarnAboutShortLocalVariableNames.
    warnAboutPossibleSTCCompilationProblems := WarnAboutPossibleSTCCompilationProblems.
    warnAboutPossiblyUnimplementedSelectors := WarnAboutPossiblyUnimplementedSelectors.
    warnAboutPeriodInSymbol := WarnAboutPeriodInSymbol.
    warnAboutUnknownCharacterEscapesInJavaScriptStringConstant := WarnAboutUnknownCharacterEscapesInJavaScriptStringConstant.
    warnPlausibilityChecks := WarnPlausibilityChecks.
    warnAssignmentToBlockArgument := WarnAssignmentToBlockArgument.
    warnAssignmentToMethodArgument := WarnAssignmentToMethodArgument.
    warnAssignmentToPoolVariable := WarnAssignmentToPoolVariable.

    allowUnderscoreInIdentifier := AllowUnderscoreInIdentifier.
    allowDollarInIdentifier := AllowDollarInIdentifier.
    allowParagraphInIdentifier := AllowParagraphInIdentifier.
    allowOldStyleAssignment := AllowOldStyleAssignment.
    allowSqueakExtensions := AllowSqueakExtensions.
    allowDolphinExtensions := AllowDolphinExtensions.
    allowLiteralNameSpaceSymbols := AllowLiteralNameSpaceSymbols.
    allowExtendedBinarySelectors := AllowExtendedBinarySelectors.
    allowCaretAsBinop := AllowCaretAsBinop.
    allowFunctionCallSyntaxForBlockEvaluation := AllowFunctionCallSyntaxForBlockEvaluation.
    allowLocalVariableDeclarationWithInitializerExpression := AllowLocalVariableDeclarationWithInitializerExpression.
    allowDomainVariables := AllowDomainVariables.
    allowArrayIndexSyntaxExtension := AllowArrayIndexSyntaxExtension.
    allowReservedWordsAsSelectors := AllowReservedWordsAsSelectors.
    allowVariableReferences := AllowVariableReferences.
    allowLazyValueExtension := AllowLazyValueExtension.
    allowFixedPointLiterals := AllowFixedPointLiterals.
    allowExtendedSTXSyntax := AllowExtendedSTXSyntax.
    allowQualifiedNames := AllowQualifiedNames.
    allowVisualAgeESSymbolLiterals := AllowVisualAgeESSymbolLiterals.
    allowExtensionsToPrivateClasses := AllowExtensionsToPrivateClasses.
    allowVisualAgePrimitives := AllowVisualAgePrimitives.
    allowSqueakPrimitives := AllowSqueakPrimitives.
    allowSTVPrimitives := AllowSTVPrimitives.
    allowSTVExtensions := AllowSTVExtensions.
    allowNationalCharactersInIdentifier := AllowNationalCharactersInIdentifier.
    allowHashAsBinarySelector := AllowHashAsBinarySelector.
    allowSTXEOLComments := AllowSTXEOLComments.
    allowSTXDelimiterComments := AllowSTXDelimiterComments.
    allowSTXExtendedArrayLiterals := AllowSTXExtendedArrayLiterals.
    allowVisualWorksMethodAnnotations := AllowVisualWorksMethodAnnotations.
    allowPossibleSTCCompilationProblems := AllowPossibleSTCCompilationProblems.
    allowEmptyStatements := AllowEmptyStatements.
    allowPeriodInSymbol := AllowPeriodInSymbol.
    "/ these are only supported in the new compiler
    allowUnicodeStrings := AllowUnicodeStrings.
    allowUnicodeCharacters := AllowUnicodeCharacters.
    allowCharacterEscapes := AllowCharacterEscapes.
    allowStringEscapes := AllowStringEscapes.
    allowAssignmentToBlockArgument := AllowAssignmentToBlockArgument.
    allowAssignmentToMethodArgument := AllowAssignmentToMethodArgument.
    allowAssignmentToPoolVariable := AllowAssignmentToPoolVariable.
    allowSignedByteArrayElements := AllowSignedByteArrayElements.
    allowSymbolsStartingWithDigit := AllowSymbolsStartingWithDigit.

    allowJavaScriptConst := AllowJavaScriptConst.              
    
    arraysAreImmutable := ArraysAreImmutable ? true.
    stringsAreImmutable := StringsAreImmutable ? true.
    implicitSelfSends := ImplicitSelfSends ? false.
    lineNumberInfo := LineNumberInfo ? false.

    stcKeepCIntermediate := STCKeepCIntermediate.
    stcKeepOIntermediate := STCKeepOIntermediate.
    stcKeepSTIntermediate := STCKeepSTIntermediate.
    stcModulePath := STCModulePath.
    stcCompilation := STCCompilation.
    stcCompilationIncludes := STCCompilationIncludes.
    stcCompilationDefines := STCCompilationDefines.
    stcCompilationOptions := STCCompilationOptions.
    stcPath := STCPath.
    ccCompilationOptions := CCCompilationOptions.
    ccPath := CCPath.
    linkArgs := LinkArgs.
    linkCommand := LinkCommand.
    libPath := LibPath.
    searchedLibraries := SearchedLibraries.

    "
     ParserFlags initialize.
     self new inspect.
    "

    "Modified: / 08-08-2017 / 23:50:01 / cg"
! !

!ParserFlags class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ParserFlags initialize!
