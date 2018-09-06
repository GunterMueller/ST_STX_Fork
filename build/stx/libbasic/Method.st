"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2009-2010 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
 COPYRIGHT (c) 2017 Claus Gittinger
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

CompiledCode variableSubclass:#Method
	instanceVariableNames:'source sourcePosition category package mclass lookupObject
		annotations'
	classVariableNames:'PrivateMethodSignal LastFileReference LastSourceFileName
		LastWhoClass LastFileLock LastMethodSources LastMethodSourcesLock
		CompilationLock Overrides LastParseTreeCache'
	poolDictionaries:''
	category:'Kernel-Methods'
!

Object subclass:#MethodWhoInfo
	instanceVariableNames:'myClass mySelector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Method
!

Object subclass:#ParseTreeCacheEntry
	instanceVariableNames:'parserClass method parser'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Method
!

Object subclass:#ParserCacheEntry
	instanceVariableNames:'method parser'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Method
!

!Method class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2009-2010 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
 COPYRIGHT (c) 2017 Claus Gittinger
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
    this class defines protocol for executable methods;
    both compiled and interpreted methods are represented by this class.
    Compiled methods have a non-nil code field, while interpreted methods have
    a nil code field and non-nil byteCode field.
    If there are both non-nil code and bytecode fields, the VM will execute
    the machine-code of a method. If both are nil when executed, a #noByteCode
    message is sent (by the VM) to the method, where a signal is raised.
    (or, a user defined interpreter can be invoked on the smalltalk level)

    The method's sourcecode is represented by source and sourcePosition:
    - if sourcePosition is a Number, the source-field is the fileName and
      sourcePosition is the character offset of the source-chunk in this source file.
    - If sourcePosition is nil, the source fields holds the source string.
    (an old version used ExternalString instances here, but that lead to
     10000's of additional little objects ...)

    The flags field defines things like the number of method-locals,
    method arguments and stack requirements (for interpreted methods).
    Do not depend on any value in the flags field - it may change without
    notice.

    Notice, that in ST/X, method can be subclassed; executable code is
    identified not by being an instance of Block or Method, but instead by
    having the executable flag bit set in the class. The VM can execute anything
    which is identified as executable (assuming that the first instance variable
    is the machine-code address) - this allows for easy future extension.

    Literals:
        Notice that stc compiled methods do not list all of their used literals.
        In fact, stc-code uses a kind of class-constant-table,
        and only message-send symbols are found in the literal array.
        Thus, in order to find constants (literals) used by a method,
        you have to parse its source.

    [Instance variables:]

        source          <String>        the source itself (if sourcePosition isNil)
                                        or the fileName where the source is found

        sourcePosition  <Integer>       the position of the methods chunk in the file

        category        <Symbol>        the methods category
        package         <Symbol>        the package, in which the methods was defined
        mclass          <Class>         the class in which I am defined
        indexed slots                   literals

    [Class variables:]

        PrivateMethodSignal             raised on privacy violation (see docu)

        LastFileReference               weak reference to the last sourceFile
        LastSourceFileName              to speedup source access via NFS

    WARNING: layout known by compiler and runtime system - don't change

    [author:]
        Claus Gittinger
"
!

dynamicMethods
"
    On systems which support dynamic loading of stc-compiled machine code (SYS5.4, Linux),
    methods may now be compiled to machine code from within the browser,
    and the resulting machine code object be loaded in.
    The ObjectFileLoader keeps (weak) handles to the resulting methods and
    invalidates the corresponding method objects, if the underlying methods
    object code is unloaded.
    Invalid methods will trap into the debugger when executed;
    also, the browser marks them as '(* not executable *)' in its method list.

    Notice: this has nothing to do with JIT compilation, which is always possible.
    JIT-compilation is done from bytecodes to a machineCode cache.
    In contrast, dynamic loading of stc-compiled code goes via intermediate C-code
    which is compiled by the machines native C-compiler.
    As opposed to JITted code, this allows for embedded primitive C-code.
"
!

privacy
"
    ST/X includes an EXPERIMENTAL implementation of method privacy.
    Individual methods may be set to private or protected via the
    privacy:#private and privacy:#protected messages. Also, categories may be
    filedIn as a whole as private using #privateMethodsFor: or as
    protected using #protectedMethodsFor: instead of the well known #methodsFor:.

    The additional #publicMethodsFor: is for documentation purposes, and
    is equivalent to #methodsFor: (also to support fileIn of ENVY methods).

    Protected methods may be executed only when called via a self-send
    from the superclass-methods and self or super-sends from methods in the
    class itself or subclasses.
    Private methods may not be called from subclasses-methods,
    i.e. they may only be called via self sends from within the current class.
    (i.e. protected methods are less private than private ones)

    When such a situation arises, the VM (runtime system) will raise the
    PrivateMethodSignal exception (if nonNil), which usually brings you into the
    debugger.

    If PrivateMethodSignal is nil, the VM will not check for this, and
    execution is as usual. (you may want to nil-it for production code,
    and leave it non nil during development).

    NOTICE: there is no (not yet?) standard defined for method privacy,
    however, the definition protocol was designed to be somewhat ENVY compatible
    (from what can be deduced by reading PD code).

    Also, the usability of privacy is still to be tested.
    This interface, the implementation and the rules for when a privacy violation
    may change (in case of some ANSI standard being defined).
    Be warned and send me suggestions & critics (constructive ;-)

    Late note (Feb 2000):
        the privacy feature has now been in ST/X for some years and was NOT heavily
        used - neither at eXept, nor by customers.
        In Smalltalk, it seems to be a very questionable feature, actually limiting
        code reusability.
        The privacy features are left in the system to demonstrate that it can be
        done in Smalltalk (for religious C++ fans ... to avoid useless discussions)
        (the check is not expensive, w.r.t. the VM runtime behavior).
"
! !

!Method class methodsFor:'initialization'!

initialize
    "create signals"

    PrivateMethodSignal isNil ifTrue:[
        "EXPERIMENTAL"
        PrivateMethodSignal := ExecutionError newSignalMayProceed:true.
        PrivateMethodSignal nameClass:self message:#privateMethodSignal.
        PrivateMethodSignal notifierString:'attempt to execute private/protected method'.
    ].

    LastFileLock isNil ifTrue:[
        LastFileLock := RecursionLock new name:'Method-LastFile'.
        LastMethodSourcesLock := RecursionLock new name:'Method-LastMethodSources'.

        LastFileReference := WeakArray new:1.
    ].

    CompilationLock := RecursionLock new name:'MethodCompilation'.

    "Modified: / 03-01-1997 / 16:58:16 / stefan"
    "Modified (comment): / 20-07-2012 / 18:41:11 / cg"
!

lastMethodSourcesLock
    LastMethodSourcesLock isNil ifTrue:[
	self initialize
    ].
    ^ LastMethodSourcesLock
! !

!Method class methodsFor:'Signal constants'!

privateMethodSignal
    "return the signal raised when a private/protected method is called
     by some other object (i.e. not a self- or super send)"

    ^ PrivateMethodSignal
! !


!Method class methodsFor:'cleanup'!

lowSpaceCleanup
    LastParseTreeCache := nil.
    LastSourceFileName := LastWhoClass := nil.
    self flushSourceStreamCache.

    "Created: / 08-08-2011 / 19:11:23 / cg"
! !

!Method class methodsFor:'queries'!

binarySelectorCharacters
    "return a collection of characters which are allowed in binary selectors"

    ^ '&-+=*/\<>~@,?!!|%#'.
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Method

    "Modified: 23.4.1996 / 15:59:50 / cg"
!

maxBinarySelectorSize
    ^ 3

    "
     in ST/X, binops are allowed with up-to 3 characters;
     for example:
	<->
	<=>
	+++
	:=:
     etc. are valid binOps here
    "
!

methodDefinitionTemplateForSelector:aSelector
    "given a selector, return a prototype definition string"

    ^ self programmingLanguage
	methodDefinitionTemplateForSelector:aSelector

    "
     Method methodDefinitionTemplateForSelector:#foo
     Method methodDefinitionTemplateForSelector:#+
     Method methodDefinitionTemplateForSelector:#foo:bar:baz:
    "
!

methodDefinitionTemplateForSelector:aSelector andArgumentNames:argNames
    "given a selector, return a prototype definition string"

    ^ self programmingLanguage
	methodDefinitionTemplateForSelector:aSelector andArgumentNames:argNames

    "
     Method methodDefinitionTemplateForSelector:#foo          andArgumentNames:#()
     Method methodDefinitionTemplateForSelector:#+            andArgumentNames:#('aNumber')
     Method methodDefinitionTemplateForSelector:#foo:bar:baz: andArgumentNames:#('fooArg' 'barArg' 'bazArg')
    "
!

methodPrivacySupported
    "return true, if the system was compiled to support methodPrivacy.
     You should not depend on that feature being available."

%{  /* NOCONTEXT */
#if defined(F_PRIVATE) || defined(F_CLASSPRIVATE)
    RETURN (true);
#else
    RETURN (false);
#endif
%}
!

resourceTypes
    "get the types of resources for which a spec definition and corresponding editor exist"

    ^ #(canvas menu image fileImage help hierarchicalList tabList tableColumns)
! !

!Method class methodsFor:'special'!

flushParseTreeCache
    "used by lint and the compiler"

    LastParseTreeCache := nil

    "
     Method flushParseTreeCache
    "

    "Created: / 01-03-2012 / 16:45:34 / cg"
!

flushSourceStreamCache
    LastFileLock critical:[
        LastSourceFileName := LastMethodSources := nil.
        LastFileReference at:1 put:nil.
    ].

    "
     Method flushSourceStreamCache
    "

    "Created: 9.2.1996 / 19:05:28 / cg"
! !

!Method class methodsFor:'trap methods'!

trapMethodForNumArgs:numArgs
    "return a method which will raise an invalid code object exception.
     Before recompiling methods (due to changed variable scopes, for example),
     all method's code is replaced by this. If recompilation fails, this code
     remains in the method to make it trap, whenever executed later.
     Otherwise, if recompilation succeeeds, that code will vanish after the compile"

    |trapSel trapMethod|

    trapSel := #(
		   invalidCodeObject
		   invalidCodeObjectWith:
		   invalidCodeObjectWith:with:
		   invalidCodeObjectWith:with:with:
		   invalidCodeObjectWith:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:with:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:with:with:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:with:with:with:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:with:with:with:with:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:with:with:with:with:with:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:with:with:with:with:with:with:with:with:with:
		   invalidCodeObjectWith:with:with:with:with:with:with:with:with:with:with:with:with:with:with:
		) at:(numArgs + 1).

    (trapMethod := self compiledMethodAt:trapSel) isNil ifTrue:[
	trapMethod := Method compiledMethodAt:trapSel.
    ].
    ^ trapMethod.

    "
	self trapMethodForNumArgs:2
    "

    "Created: / 04-11-1996 / 21:58:58 / cg"
    "Modified: / 14-09-2011 / 11:23:09 / sr"
    "Modified (comment): / 30-10-2011 / 11:04:24 / cg"
! !


!Method methodsFor:'Compatibility-Squeak'!

isCompiledMethod
    ^ true

    "Created: / 13-06-2012 / 14:51:19 / cg"
!

pragmaAt:aKey
    ^ self annotationAt:aKey

    "Created: / 11-09-2011 / 18:09:05 / cg"
!

pragmas
    "for squeak compatibility, we only present real pragmas"

    ^ (self annotations ? #()) select:[:a | a isArray not and:[ a isResource not ] ]
!

propertyValueAt:aKey
    "for now - no properties"

    ^ nil

    "Created: / 12-09-2011 / 08:42:02 / cg"
!

sourceCode
    ^ self source

    "Created: / 30-10-2014 / 23:24:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'Compatibility-VW'!

attributeAt:aSymbol ifAbsent:exceptionValue
    |annots|

    annots := self annotationsAt:aSymbol.
    annots isEmptyOrNil ifTrue:[
	(aSymbol endsWith:$:) ifFalse:[
	    annots := self annotationsAt:(aSymbol,$:) asSymbol.
	].
	annots isEmptyOrNil ifTrue:[
	    ^ exceptionValue value
	].
    ].
    ^ annots first arguments first
!

attributeMessages
    ^ self annotations
	collect:[:annot | Message selector:annot key arguments:annot arguments]
!

classIsMeta
    "return true, if this method is a class method"

    ^ self mclass isMeta
!

sendsAnySelector:aCollectionOfSymbols
    "return true, if this method contains a message-send
     with any from aCollectionOfSymbols as selector."

    ^ self sendsAny:aCollectionOfSymbols
!

sendsSelector:aSelectorSymbol
    "return true, if this method contains a message-send
     with aSelectorSymbol as selector."

    ^ self sends:aSelectorSymbol
! !


!Method methodsFor:'accessing'!

category
    "return the methods category or nil"

    ^ category
!

category:aStringOrSymbol
    "set the methods category"

    |newCategory oldCategory cls|

    aStringOrSymbol notNil ifTrue:[
	newCategory := aStringOrSymbol.
	newCategory ~= (oldCategory := category) ifTrue:[
	    self setCategory:newCategory.

	    cls := self mclass.
	    cls notNil ifTrue:[
		cls addChangeRecordForMethodCategory:self category:newCategory.
		self changed:#category with:oldCategory.            "/ will vanish
		cls changed:#organization with:self selector.       "/ will vanish
		Smalltalk changed:#methodCategory with:(Array with:cls with:self with:oldCategory).
	    ]
	]
    ]

    "Modified: / 25-09-2007 / 16:15:24 / cg"
!

comment
    "return the method's comment.
     This is done by searching for and returning the first comment
     from the methods source (excluding any double-quotes).
     Returns nil if there is no comment (or source is not available)."

    |src parserClass|

    src := self source.
    src isNil ifTrue:[^ nil].
    (parserClass := self programmingLanguage parserClass) isNil ifTrue:[^ nil].
    ^ parserClass methodCommentFromSource:src

    "
     (Method compiledMethodAt:#comment) comment
     (Object class compiledMethodAt:#infoPrinting:) comment
    "

    "Modified: / 23-02-1998 / 10:26:08 / stefan"
    "Modified: / 01-06-2012 / 23:03:57 / cg"
!

getMclass
    "return the last known class in which this method was (or still is) contained in.
     Notice, that the mclass query returns nil, if a method is wrapped or no longer valid
     due to an accept in a browser or debugger. However, the mclass slot still contains a
     reference to the once valid class"

    ^ mclass
!

getPackage
    "return the package-ID of the method"

    ^ package
!

getSource
    "low-level access to the source instance-variable.
     For internal (compiler) use only.
     This is NOT always the methods source string"

    ^ source
!

getSourcePosition
    "low-level access to the sourcePosition instance-variable.
     For internal (compiler) use only.
     This is NOT always the methods sourcePosition"

    ^ sourcePosition
!

localSourceFilename:aFileName position:aNumber
    "set the method's sourcefile/position indicating, that
     this is a local file (i.e. the 'st.src' file).
     The indicator for this is a negative source position."

    self assert:(aFileName isText not).   "/ will break monticello-binary-data-writing
    source := aFileName.
    sourcePosition := aNumber negated

    "Created: 16.1.1997 / 01:25:52 / cg"
!

lookupObject

    "/ lookupObject isNil ifTrue:[^ BuiltinLookup instance "Lookup builtin"].
    ^ lookupObject

    "Created: / 28-04-2010 / 18:36:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:47:12 / cg"
!

lookupObject: anObject
    anObject == BuiltinLookup instance ifTrue:[
	self setLookupObject: nil
    ] ifFalse:[
	self setLookupObject: anObject.
    ].

    "Created: / 28-04-2010 / 18:36:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2010 / 19:32:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeLocalStringSource
    "assure that the methods source code is stored locally as a string
     within the method (as opposed to an external string, which is accessed
     by reading the source code file).
     This is required, when a method's package is changed, to assure that its
     sourceCode is not lost."

    source notNil ifTrue:[
	sourcePosition notNil ifTrue:[
	    "/ this looks wierd - but (self source) will retrieve the external source
	    "/ (from the file) and store it. So afterwards, we will have the string and
	    "/ sourcePosition will be nil
	    self source:(self source)
	]
    ].
!

mclass:aClass
    "set the method's class. That is the class in which I am installed.
     This is a cache; the validity of which will be checked and the cache
     possibly be invalidated when mclass is asked for."

"/    mclass == aClass ifTrue:[ ^ self ].
"/
"/     (mclass notNil and:[aClass notNil]) ifTrue:[
"/         'Method [warning]: mclass already set' errorPrintCR.
"/     ].
    mclass := aClass.

    "Modified: / 28-11-2006 / 12:12:27 / cg"
!

nameSpace
    "Returns my namespace or nil. If no explicit method namespace
     is set, my programmming language is used as default namespace
     (for compatibility reasons, nil is returned for smalltalk methods,
     which means that the method is not namespaced).
    "

    | nsA prefix |

    nsA := self annotationAt: #namespace:.
    nsA notNil ifTrue:[^nsA nameSpace].

    prefix := self programmingLanguage defaultSelectorNameSpacePrefix.
    (prefix isNil or:[prefix = 'Smalltalk']) ifTrue:[ ^ nil].
    ^ NameSpace name:prefix

    "
     (Method >> #nameSpace) nameSpace
     (Object >> #yourself) nameSpace
    "

    "Created: / 26-04-2010 / 16:30:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2010 / 09:38:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 14:17:09 / cg"
!

nameSpace: aNameSpace

    self annotateWith: (Annotation nameSpace: aNameSpace name)

    "Created: / 20-05-2010 / 10:05:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2010 / 11:30:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 23:08:48 / cg"
!

nameSpaceName
    | ns |
    ns := self nameSpace.
    ^ ns isNil ifTrue:[''] ifFalse:[ns name]
!

originalMethodIfWrapped
    "return the method the receiver is wrapping - none here"

    ^ self

    "Created: / 22-10-2010 / 11:46:07 / cg"
!

overriddenMethod
    <resource: #obsolete>

    self obsoleteMethodWarning: 'Use overwrittenMethod instead, stupid naming'.
    ^self overwrittenMethod

    "Created: / 17-06-2009 / 19:09:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 18-11-2011 / 14:48:07 / cg"
    "Modified: / 05-07-2012 / 10:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

overriddenMethod: aMethod
    <resource: #obsolete>

    self obsoleteMethodWarning: 'Use overwrittenMethod: instead, stupid naming'.
    self overwrittenMethod: aMethod

    "Created: / 17-06-2009 / 19:09:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-08-2009 / 10:47:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-11-2011 / 14:48:26 / cg"
    "Modified: / 05-07-2012 / 10:51:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

overwrittenMethod
    "Answers overridden method or nil."

    Overrides isNil ifTrue:[
        ^ nil
    ].
    ^ Overrides at:self ifAbsent:nil.

    "Created: / 05-07-2012 / 10:49:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

overwrittenMethod: aMethod
    "Set overridden method to aMethod"

    Overrides isNil ifTrue:[Overrides := WeakIdentityDictionary new:10].
    aMethod notNil ifTrue:[aMethod makeLocalStringSource].
    Overrides at:self put:aMethod

    "Created: / 05-07-2012 / 10:50:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package
    "return the package-symbol of the method (nil is translated to noProject here)"

    |cls|

    package notNil ifTrue:[ ^ package ].

    "/ get it from my class
    (cls := self mclass) isNil ifTrue:[
	^ PackageId noProjectID.
    ].
    "/ set it.
    package := cls getPackage.
    package isNil ifTrue:[
	^ PackageId noProjectID.
    ].
    ^ package

    "Modified: / 28-11-2006 / 12:12:43 / cg"
!

package:aSymbol
    "set the package-symbol"

    |cls oldPackage newPackage|

    newPackage := aSymbol.
    aSymbol == PackageId noProjectID ifTrue:[
        Transcript showCR:'warning: unassigning method from any package'.
        "/ newPackage := nil
    ].

    package ~~ newPackage ifTrue:[
        oldPackage := package.
        "/ this is required, because otherwise I would no longer be able to
        "/ reconstruct my sourcecode (as the connection to the source-file is lost).
        self makeLocalStringSource.
        package := newPackage.

        cls := self mclass.
        "JV@2011-01-27: BUG FIX: method may be wrapped (breakpoint on it).
         Search for the wrapper, if none is found, return immediately
         (avoids DNU)"
        cls isNil ifTrue:[
            | wrapper |

            wrapper := self wrapper.
            wrapper isNil ifTrue:[ ^ self ].
            cls := wrapper mclass.
            cls isNil ifTrue:[ ^ self ].
        ].

        self changed:#package.                                              "/ will vanish
        cls changed:#methodPackage with:self selector.                      "/ will vanish

        Smalltalk changed:#projectOrganization with:(Array with:cls with:self with:oldPackage).
        cls addChangeRecordForMethodPackage:self package:newPackage.
    ]

    "Modified: / 23-11-2006 / 17:01:02 / cg"
    "Modified: / 27-01-2012 / 17:15:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-01-2012 / 21:22:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setAnnotations: anObject
    "set the annotations (low level - use do not use)"

    annotations :=  anObject

    "Created: / 20-05-2010 / 11:27:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setCategory:aStringOrSymbol
    "set the methods category (without change notification)"

    aStringOrSymbol notNil ifTrue:[
	category := aStringOrSymbol asSymbol
    ]

    "Modified: / 13.11.1998 / 23:55:05 / cg"
!

setPackage:aSymbol
    "set the package-symbol (low level - use package:)"

    package := aSymbol
!

source
    "return the sourcestring for the receiver"

    |sourceStream chunk|

    "
     if sourcePosition is nonNil, its the fileName and
     abs(sourcePosition) is the offset.
     Otherwise, source is the real source
    "
    sourcePosition isNil ifTrue:[^ source].
    source isNil ifTrue:[^ nil].

    LastMethodSources notNil ifTrue:[
        self class lastMethodSourcesLock critical:[
            LastMethodSources notNil ifTrue:[
                chunk := LastMethodSources at:self ifAbsent:nil.
            ].
        ].
        chunk notNil ifTrue:[
            ^ chunk
        ].
    ].

    LastFileLock
        critical:[
            "have to protect sourceStream from being closed as a side effect
             of some other process fetching some the source from a different source file"

            sourceStream := self sourceStreamUsingCache:true.
            sourceStream notNil ifTrue:[
                [
                    chunk := self sourceChunkFromStream:sourceStream.
                ] on:DecodingError do:[:ex|
                    "CharacterEncoder>>#guessEncoding is not fail safe - retry with plain unencoded data"

                    Logger info:'DecodingError ignored when reading %1 (%2)' with:self whoString with:ex description.
                    sourceStream := self rawSourceStreamUsingCache:true.
                    ex restart.
                ].
            ].
        ]
        timeoutMs:100
        ifBlocking:[
            "take care if LastFileLock is not available - maybe we are
             called by a debugger while someone holds the lock.
             Use uncached source streams"
            sourceStream := self sourceStreamUsingCache:false.
            sourceStream notNil ifTrue:[
                [
                    chunk := self sourceChunkFromStream:sourceStream.
                    sourceStream close.
                ] on:DecodingError do:[:ex|
                    "CharacterEncoder>>#guessEncoding is not fail safe - retry with plain unencoded data"
                    Logger info:'DecodingError ignored when reading %1 (%2)' with:self whoString with:ex description.
                    sourceStream close.
                    sourceStream := self rawSourceStreamUsingCache:false.
                    ex restart.
                ].
            ].
        ].

    "Cache the source of recently used methods"
    chunk notNil ifTrue:[
        "JV@2013-08-19: Don't consult UserPreferences if the system is initializing. This may
         lead in funny side-effect as #initializeDefaultPreferences is called which tries to
         initialize some colors. But Color itself is likely not yet initialized, so DNU is
         thrown.
         CG: also care for standalone non-GUI progs, which have no userPreferences class"
        (Smalltalk isInitialized
        and:[UserPreferences notNil
        and:[UserPreferences current keepMethodSourceCode]]) ifTrue:[
            source := chunk.
            sourcePosition := nil.
            ^ source.
        ].

        CacheDictionary notNil ifTrue:[
            self class lastMethodSourcesLock critical:[
                LastMethodSources isNil ifTrue:[
                    LastMethodSources := CacheDictionary new:50.
                ].
                LastMethodSources at:self put:chunk.
            ]
        ].
    ].

    ^ chunk

    "Modified: / 07-01-1997 / 16:20:09 / stefan"
!

source:aString
    "set the methods sourcestring"

    self assert:(aString isText not).   "/ will break monticello-binary-data-writing
    source := aString.
    sourcePosition := nil
!

sourceFilename
    "return the sourcefilename if source is extern; nil otherwise"

    sourcePosition notNil ifTrue:[^ source].
    ^ nil
!

sourceFilename:aFileName position:aNumber
    "set the methods sourcefile/position"

    self assert:(aFileName isText not).   "/ will break monticello-binary-data-writing
    source := aFileName.
    sourcePosition := aNumber
!

sourceLineNumber
    "return the lineNumber of my source within the returned
     source sourcestring.
     For ST methods, the returned sourceString is always the
     methods pure source; therefore, the lineNumber is always 1."

    ^ 1

    "Created: 30.7.1997 / 15:42:01 / cg"
!

sourcePosition
    "return the sourceposition if source is extern; nil otherwise"

    sourcePosition isNil ifTrue:[^ sourcePosition].
    ^ sourcePosition abs

    "Modified: 16.1.1997 / 01:28:25 / cg"
! !

!Method methodsFor:'accessing-annotations'!

annotateWith: annotation
    "add a (hidden) annotation.
     This is only present in the image, not in the method's source code"

    | index |

    index := self annotationIndexOf: annotation key.
    index isNil ifTrue:[
	annotations := annotations isNil
			    ifTrue:[Array with: annotation]
			    ifFalse:[annotations copyWith:annotation]
    ] ifFalse:[
	annotations at: index put: annotation
    ].
"/    annotation annotatesMethod: self.

    "
	(Object >> #yourself) annotateWith: (Annotation namespace: 'Fictious').
	(Object >> #yourself) annotations.
	(Object >> #yourself) annotationAt: #namespace:
    "

    "Created: / 19-05-2010 / 16:20:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2010 / 11:22:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 26-07-2012 / 15:47:51 / cg"
!

annotationAt: key
    | index |

    index := self annotationIndexOf: key.
    index isNil ifTrue:[^ nil].
    ^ self annotationAtIndex: index.

    "
	(Object >> #yourself) annotationAt: #namespace:
    "

    "Created: / 19-05-2010 / 16:16:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-07-2010 / 22:35:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:46:21 / cg"
    "Modified (format): / 26-07-2012 / 15:47:54 / cg"
!

annotations
    "return (a copy) of the annotations array"

    | retval |

    annotations isNil ifTrue:[^ #()].

    retval := Array new: annotations size.
    1 to: annotations size do: [:i|
	retval at: i put: (self annotationAtIndex: i).
    ].
    ^ retval.

    "Modified: / 18-11-2011 / 14:46:56 / cg"
    "Modified (comment): / 26-07-2012 / 15:50:26 / cg"
    "Modified: / 05-03-2014 / 15:18:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotations: anObject
    "set the annotations"

    self setAnnotations: anObject.
"/    "iterate over annotations just to invoke
"/     annotationAtIndex: which lazily initializes annotations
"/     and sends #annotatesMethod:"
"/    self annotationsDo:[:annotation|]

    "Created: / 02-07-2010 / 22:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotationsAt: key

    ^OrderedCollection
	streamContents:[:annotStream|
	    self annotationsAt: key do: [:annot| annotStream nextPut: annot]
	]

    "Created: / 16-07-2010 / 11:41:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 26-07-2012 / 15:46:56 / cg"
!

annotationsAt: key do: block
    self annotationsDo: [:annot|
	annot key == key ifTrue:[block value: annot]
    ]

    "Created: / 16-07-2010 / 11:48:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 26-07-2012 / 15:48:37 / cg"
!

annotationsAt: key1 orAt: key2

    ^OrderedCollection
	streamContents:[:annotStream|
	    self annotationsAt: key1 orAt: key2 do: [:annot|annotStream nextPut: annot]
	]

    "Created: / 16-07-2010 / 11:41:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 26-07-2012 / 15:49:11 / cg"
!

annotationsAt: key1 orAt: key2 do: block
    self annotationsDo:[:annot |
        |key|
        key := annot key.
        (key == key1 or:[key == key2]) ifTrue:[
            block value: annot
        ]
    ]

    "Created: / 16-07-2010 / 11:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 26-07-2012 / 15:49:30 / cg"
!

annotationsDo: aBlock
    annotations isNil ifTrue:[^nil].
    1 to: annotations size do: [:i|
	aBlock value: (self annotationAtIndex: i)
    ].

    "Created: / 02-07-2010 / 22:33:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2010 / 19:38:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 18-11-2011 / 14:47:06 / cg"
! !


!Method methodsFor:'accessing-visibility'!

isIgnored
    "return true, if this is an ignored method.
     Ignored methods are physically present in the source file,
     but no code is generated for it by stc, and the VM does not see
     it in its message lookup.
     (i.e. setting a method to #ignored, and sending that selector,
      leads to either the superclasses implementation to be called,
      or a doesNotUnderstand exception to be raised)

     Notice: this is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

    ^ self privacy == #ignored

    "Modified: / 23.1.1998 / 15:23:02 / stefan"
!

isPrivate
    "return true, if this is a private method.
     Execution of private methods is only allowed via self sends
     from superclasses or the class itself.
     If a private method is called by some other class, a runtime
     error (PrivateMethodSignal) is raised.
     Notice: method privacy is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

    ^ self privacy == #private

    "Modified: / 23.1.1998 / 15:23:13 / stefan"
!

isProtected
    "return true, if this is a protected method.
     Execution of protected methods is only allowed via self/super sends
     from superclasses, the class itself or subclasse.
     If a protected method is called by some other class, a runtime
     error (PrivateMethodSignal) is raised.

     Notice: method privacy is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

    ^ self privacy == #protected

    "Modified: / 23.1.1998 / 15:23:27 / stefan"
!

isPublic
    "return true, if this is a public method - I.e. can be executed via any send.
     This is the default and how other smalltalk implementations treat all methods.

     Notice: method privacy is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

    ^ self privacy == #public

    "Modified: / 23.1.1998 / 15:23:40 / stefan"
!

isRestricted
    "return the flag bit stating that this method is restricted.
     Execution of the receiver will only be allowed if the system is not in
     'trap restricted mode' (-->ObjectMemory) otherise a runtime
     error (PrivateMethodSignal) is raised.

     Notice: method restriction is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

%{  /* NOCONTEXT */
#ifdef F_RESTRICTED
    INT f = __intVal(__INST(flags));

    if (f & F_RESTRICTED) {
	RETURN (true);
    }
#endif
%}.
    ^ false
! !

!Method privateMethodsFor:'accessing-visibility'!

primSetPrivacy:aSymbol
    "set the methods access rights (privacy) from a symbol;
     Currently, this must be one of #private, #protected, #public or #ignored.
     #setPrivacy: simply sets the attribute. When changing methods, that
     have already been called, #privacy: should be used.

     Notice: method privacy is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.
     If at all, use it for debugging purposes, to catch messagesends
     which are not supposed to be sent by others.
     (especially, if working in a team, while integrating other peoples work)

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

%{  /* NOCONTEXT */

#if defined(M_PRIVACY)
    INT f = __intVal(__INST(flags));
    INT p;

    if (aSymbol == @symbol(public))
	p = 0;
    else if (aSymbol == @symbol(protected))
	p = F_PRIVATE;
    else if (aSymbol == @symbol(private))
	p = F_CLASSPRIVATE;
    else if (aSymbol == @symbol(ignored))
	p = F_IGNORED;
    else
	RETURN(false);  /* illegal symbol */


    f = (f & ~M_PRIVACY) | p;
    __INST(flags) = __mkSmallInteger(f);
#endif

%}.
    ^ true

    "Modified: 27.8.1995 / 22:58:08 / claus"
! !

!Method methodsFor:'accessing-visibility'!

privacy
    "return a symbol describing the methods access rights (privacy);
     Currently, this is one of #private, #protected, #public or #ignored.

     Notice: method privacy is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.
     If at all, use it for debugging purposes, to catch messagesends
     which are not supposed to be sent by others.
     (especially, if working in a team, while integrating other peoples work)

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

%{  /* NOCONTEXT */
    /* I made this a primitive to get the define constant from stc.h */

#if defined(M_PRIVACY) && (defined(F_PRIVATE) || defined(F_CLASSPRIVATE) || defined(F_IGNORED))

    INT f = __intVal(__INST(flags));
    switch (f & M_PRIVACY) {

# ifdef F_PRIVATE
    case F_PRIVATE:
	RETURN (@symbol(protected));
	break;
# endif
# ifdef F_CLASSPRIVATE
    case F_CLASSPRIVATE:
	RETURN (@symbol(private));
	break;
# endif
# ifdef F_IGNORED
    case F_IGNORED:
	RETURN (@symbol(ignored));
	break;
# endif
    }
#endif
%}.

    ^ #public
!

privacy:aSymbol
    "set the methods access rights (privacy) from a symbol;
     Currently, this must be one of #private, #protected, #public or #ignored.

     Notice: method privacy is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.
     If at all, use it for debugging purposes, to catch message sends
     which are not supposed to be sent by others.
     (especially, if working in a team, while integrating other peoples work)

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

    |oldPrivacy|

    oldPrivacy := self privacy.

    (self setPrivacy:aSymbol flushCaches:true) ifTrue:[
	|myClass mySelector|

	myClass := self mclass.
	mySelector := self selector.

	self changed:#privacy.                                       "/ will vanish
	myClass notNil ifTrue:[
	    mySelector notNil ifTrue:[
		myClass changed:#methodPrivacy with:mySelector.      "/ will vanish
		Smalltalk changed:#privacyOfMethod with:(Array with:myClass with:self with:oldPrivacy).
		myClass addChangeRecordForMethodPrivacy:self.
	    ]
	]
    ]

    "Modified: / 23-11-2006 / 17:03:20 / cg"
!

restricted:aBoolean
    "set or clear the flag bit stating that this method is restricted.
     Execution of the receiver will only be allowed if the system is not in
     'trap restricted mode' (-->ObjectMemory) otherise a runtime
     error (PrivateMethodSignal) is raised.

     Notice: method restriction is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

%{  /* NOCONTEXT */
    /* I made this a primitive to get the define constant from stc.h */

#ifdef F_RESTRICTED
    INT f = __intVal(__INST(flags));
    INT old;

    old = f;
    if (aBoolean == true)
	f |= F_RESTRICTED;
    else
	f &= ~F_RESTRICTED;
    __INST(flags) = __mkSmallInteger(f);
    if (old & F_RESTRICTED)
	RETURN(true);
#endif
%}.
    ^ false

    "
     (ObjectMemory class compiledMethodAt:#compressingGarbageCollect) restricted:true
    "

    "Created: 7.11.1995 / 20:36:19 / stefan"
!

setPrivacy:aSymbol
    "set the methods access rights (privacy) from a symbol;
     Currently, this must be one of #private, #protected, #public or #ignored.
     #setPrivacy: simply sets the attribute. When changing methods, that
     have already been called, #privacy: should be used.

     Notice: method privacy is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.
     If at all, use it for debugging purposes, to catch messagesends
     which are not supposed to be sent by others.
     (especially, if working in a team, while integrating other peoples work)

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

    ^ self setPrivacy:aSymbol flushCaches:true
!

setPrivacy:aSymbol flushCaches:doFlush
    "set the method's access rights (privacy) from a symbol;
     Currently, this must be one of #private, #protected, #public or #ignored.
     #setPrivacy: simply sets the attribute. When changing methods, that
     have already been called, #privacy: should be used.

     Notice: method privacy is a nonstandard feature, not supported
     by other Smalltalk implementations and not specified in the ANSI spec.
     If at all, use it for debugging purposes, to catch message sends
     which are not supposed to be sent by others.
     (especially, if working in a team, while integrating other peoples work)

     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

    |old sel|

    old := self privacy.
    old == aSymbol ifTrue:[^ false].
    (self primSetPrivacy:aSymbol) ifFalse:[^ false].

    "/
    "/ no need to flush, if changing from private to public
    "/
    doFlush ifTrue:[
	(aSymbol == #public and:[old ~~ #ignored]) ifFalse:[
	    (sel := self selector) notNil ifTrue:[
		ObjectMemory flushCachesForSelector:sel numArgs:self argumentCount
	    ] ifFalse:[
		ObjectMemory flushCaches.
	    ].
	].
    ].
    ^ true
! !

!Method methodsFor:'binary storage'!

asByteCodeMethod
    "if the receiver has no bytecodes, create & return a method having
     the same semantics as the receiver, but uses interpreted bytecodes.
     Otherwise, return the receiver. The new method is not installed in
     the methodDictionary of any class - just returned.
     If the method contains primitive code, this may return a method
     without bytecode.
     Can be used to obtain a bytecode version of a machine-code method,
     for binary storage or dynamic recompilation (which is not yet finished)
     or to compile lazy methods down to executable ones."

    |mthd|

    byteCode notNil ifTrue:[
	"
	 is already a bytecoded method
	"
	^ self
    ].

    ParserFlags
	withSTCCompilation:#never
	do:[
	    mthd := self asExecutableMethod.
	].
    ^ mthd

    "Created: 24.10.1995 / 14:02:32 / cg"
    "Modified: 5.1.1997 / 01:01:53 / cg"
!

asByteCodeMethodWithSource:newSource
    |mthd|

    ParserFlags
	withSTCCompilation:#never
	do:[
	    mthd := self asExecutableMethodWithSource:newSource.
	].
    ^ mthd

    "Created: 24.10.1995 / 14:02:32 / cg"
    "Modified: 5.1.1997 / 01:01:53 / cg"
!

asExecutableMethod
    "if the receiver has neither bytecodes nor machinecode, create & return a
     method having semantics as the receiver's source. This may be machine code,
     if the system supports dynamic loading of object code and the source includes
     primitive code. However, bytecode is preferred, since it compiles faster.
     Otherwise, return the receiver. The new method is not installed in
     the methodDictionary of any class - just returned.
     Can be used to compile lazy methods down to executable ones."

    |temporaryMethod sourceString|

    byteCode notNil ifTrue:[
        "
         is already a bytecoded method
        "
        ^ self
    ].

    sourceString := self source.
    sourceString isNil ifTrue:[
        'Method [warning]: cannot generate bytecode (no source for compilation)' errorPrintCR.
        ^ nil
    ].

    temporaryMethod := self asExecutableMethodWithSource:sourceString.

    (temporaryMethod isNil or:[temporaryMethod == #Error]) ifTrue:[
        'Method [warning]: cannot generate bytecode (contains primitive code or error)' errorPrintCR.
        ^ nil.
    ].
    "/
    "/ try to save a bit of memory, by sharing the source (whatever it is)
    "/
    temporaryMethod sourceFilename:source position:sourcePosition.
    ^ temporaryMethod
!

asExecutableMethodWithSource:newSource
    |temporaryMethod cls|

    cls := self containingClass.
    cls isNil ifTrue:[
        'Method [warning]: cannot generate bytecode (no class for compilation)' errorPrintCR.
        ^ nil
    ].

    "we have to sequentialize this using a lock-semaphore,
     to make sure only one method is compiled at a time.
     Otherwise, we might get into trouble, if (due to a timeout)
     another recompile is forced while compiling this one ...
     (happened when autoloading animation demos)
    "
    CompilationLock critical:[
        "
         don't want this to go into the changes file,
         don't want output on Transcript and definitely
         don't want a lazy method ...
        "
        Class withoutUpdatingChangesDo:[
            |silent lazy|

            silent := Smalltalk silentLoading:true.
            lazy := Compiler compileLazy:false.

            [
                |compiler|

                Class nameSpaceQuerySignal answer:(cls nameSpace)
                do:[
                    compiler := cls compilerClass.

                    "/
                    "/ kludge - have to make ST/X's compiler protocol
                    "/ be compatible to ST-80's
                    "/
                    (compiler respondsTo:#compile:forClass:inCategory:notifying:install:)
                    ifTrue:[
                        temporaryMethod := compiler
                                             compile:newSource
                                             forClass:cls
                                             inCategory:(self category)
                                             notifying:nil
                                             install:false.
                    ] ifFalse:[
                        temporaryMethod := compiler new
                                             compile:newSource
                                             in:cls
                                             notifying:nil
                                             ifFail:nil
                    ].
                ].
            ] ensure:[
                Compiler compileLazy:lazy.
                Smalltalk silentLoading:silent.
            ]
        ].
    ].
    (temporaryMethod isNil or:[temporaryMethod == #Error]) ifTrue:[
        'Method [warning]: cannot generate bytecode (contains primitive code or error)' errorPrintCR.
        ^ nil.
    ].
    "/
    "/ try to save a bit of memory, by sharing the source (whatever it is)
    "/
    temporaryMethod source:newSource.
    "/
    "/ don't forget the methods class & package ...
    "/
    temporaryMethod setPackage:package.
    temporaryMethod mclass:(self getMclass).
    ^ temporaryMethod
! !


!Method methodsFor:'copying'!

copy
    "redefined to change a source ref into a real string"

    |aCopy|

    aCopy := super copy.
    sourcePosition notNil ifTrue:[
	aCopy source:(self source)
    ].
    aCopy mclass:nil.
    ^ aCopy

    "Modified: 16.1.1997 / 01:27:25 / cg"
! !

!Method methodsFor:'error handling'!

invalidCodeObject
    "{ Pragma: +optSpace }"

    "this method is triggered by the interpreter when a nil or non method
     is about to be executed.
     In this case, the VM sends this to the bad method (the receiver).

     Also, the Compiler creates methods with their code/bytecode set to
     this method if - after a class change - a method cannot be compiled
     and is therefore no longer executable (for example, after an instvar
     has been removed, and a method still tries to access this instvar)

     Thus, we arrive here, when playing around in a classes methodArray,
     or compiler/runtime system is broken :-(,
     or you ignore the error messages during some recompile."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Modified: 4.11.1996 / 22:45:06 / cg"
!

invalidCodeObjectWith:arg
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 2 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: / 14-09-2011 / 11:23:49 / sr"
!

invalidCodeObjectWith:arg with:arg2
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 2 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:16:41 / cg"
    "Modified: 4.11.1996 / 22:45:15 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 3 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:16:51 / cg"
    "Modified: 4.11.1996 / 22:45:18 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 4 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:17:00 / cg"
    "Modified: 4.11.1996 / 22:45:22 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 5 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:17:09 / cg"
    "Modified: 4.11.1996 / 22:45:25 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5 with:arg6
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 6 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:17:17 / cg"
    "Modified: 4.11.1996 / 22:45:28 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 7 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:17:25 / cg"
    "Modified: 4.11.1996 / 22:45:31 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7 with:arg8
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 8 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:17:32 / cg"
    "Modified: 4.11.1996 / 22:45:38 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7 with:arg8 with:arg9
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 9 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:17:37 / cg"
    "Modified: 4.11.1996 / 22:45:41 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7 with:arg8 with:arg9 with:arg10
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 10 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:17:45 / cg"
    "Modified: 4.11.1996 / 22:45:44 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7 with:arg8 with:arg9 with:arg10 with:arg11
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 11 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:17:52 / cg"
    "Modified: 4.11.1996 / 22:45:47 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7 with:arg8 with:arg9 with:arg10 with:arg11 with:arg12
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 12 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 20:51:28 / cg"
    "Modified: 4.11.1996 / 22:46:01 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7 with:arg8 with:arg9 with:arg10 with:arg11 with:arg12 with:arg13
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 13 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:18:09 / cg"
    "Modified: 4.11.1996 / 22:45:57 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7 with:arg8 with:arg9 with:arg10 with:arg11 with:arg12 with:arg13 with:arg14
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 14 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:18:17 / cg"
    "Modified: 4.11.1996 / 22:45:55 / cg"
!

invalidCodeObjectWith:arg with:arg2 with:arg3 with:arg4 with:arg5 with:arg6 with:arg7 with:arg8 with:arg9 with:arg10 with:arg11 with:arg12 with:arg13 with:arg14 with:arg15
    "{ Pragma: +optSpace }"

    "When recompiling classes after a definition-change, all
     uncompilable methods (with 15 args) will be bound to this method here,
     so that evaluating such an uncompilable method will trigger an error."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseErrorString:'invalid method - not executable'.

    "Created: 4.11.1996 / 21:18:22 / cg"
    "Modified: 4.11.1996 / 22:45:52 / cg"
!

privateMethodCalled
    "{ Pragma: +optSpace }"

    "this error is triggered, if a private or protected method is called.

     If you continue in the debugger, the method will be called,
     and further privacy exceptions will NOT be reported at this call location,
     until any new method is compiled, or the privacy of any method changes,
     or the caches are flushed.
     (the reason is that after the continue, the method is entered into the
      calling cache, for which method privacy is not checked.
      Any of the above actions flushes this cache and a privacy check
      is performed again.)
     Future versions may not enter private methods into the cache, to fix this
     (unobvious) behavior. However, then you will get an exception for EVERY
     call to a private method ...

     Notice: method privacy is a nonstandard feature, not supported
     by other smalltalk implementations and not specified in the ANSI spec.
     This is EXPERIMENTAL - and being evaluated for usability.
     It may change or even vanish (if it shows to be not useful)."

    ^ PrivateMethodSignal raiseRequest

    "Modified: 4.11.1996 / 22:46:09 / cg"
!

uncompiledCodeObject
    "{ Pragma: +optSpace }"

    "this method is invoked by methods which contain primitive code,
     but have not been compiled to machine code (either due to an error
     when compiling, or simply because no stc is available.
     For those methods, the compiler generated a method object consisting
     of the original source code, but with this methods machine/byte code."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseRequestWith:self
	errorString:'invalid method - not compiled'.

    "Modified: 4.11.1996 / 22:58:02 / cg"
!

unloadedCodeObject
    "{ Pragma: +optSpace }"

    "this method is invoked by methods which have been binary-unloaded
     For those the source info consists
     of the original source code, but with this methods machine/byte code."

%{
    /*
     * for reasons too far from being explained here,
     * this MUST be a compiled method
     */
%}.
    ^ InvalidCodeError
	raiseRequestWith:self
	errorString:'invalid method - unloaded'.

    "Created: 4.11.1996 / 22:57:54 / cg"
    "Modified: 4.11.1996 / 22:58:28 / cg"
! !


!Method methodsFor:'printing & storing'!

printOn:aStream
    "put a printed representation of the receiver onto aStream.
     Since methods do not store their class/selector, we have to search
     for it here."

    |classAndSelector m wrapped|

    wrapped := false.

    self basicPrintOn:aStream."/ aStream nextPutAll:(self classNameWithArticle).
    aStream nextPut:$(.

    classAndSelector := self who.
    classAndSelector isNil ifTrue:[
        "
         not anchored in any class.
         check if wrapped (to be more informative in inspectors)
        "
        m := self wrapper.
        m notNil ifTrue:[
            classAndSelector := m who.
            wrapped := true.
        ]
    ].
    classAndSelector notNil ifTrue:[
        (classAndSelector methodClass) name printOn:aStream.
        "/ print out in a form that can directly be evaluated (>> is a selector in Behavior)
        "/ in order to not break existing code which parses those strings,
        "/ do not replace '>>' by '  '
        aStream nextPutAll:' >> '.
        (classAndSelector methodSelector) printOn:aStream.
    ] ifFalse:[
        "
         sorry, a method which is nowhere anchored
        "
        aStream nextPutAll:'unbound'
    ].
    aStream nextPut:$).

    wrapped ifTrue:[
        aStream nextPutAll:'; wrapped'
    ].

    "
     (Object compiledMethodAt:#at:) printOn:Transcript. Transcript cr.
     (Object compiledMethodAt:#at:) copy printOn:Transcript. Transcript cr.

     (Object compiledMethodAt:#at:) whoString printOn:Transcript. Transcript cr.
     (Object compiledMethodAt:#at:) copy whoString printOn:Transcript. Transcript cr.
    "

    "Modified: / 22-10-2010 / 12:07:25 / cg"
!

whoString
    "return a string as className>>selector, if this is not an unbound
     method.
     Otherwise return 'unbound'. Used with debugging."

    |who|

    who := self who.
    who notNil ifTrue:[
        "/ in order to not break existing code which parses those strings,
        "/ do not replace '>>' by '  '
        ^ who methodClass name , ' >> ' , (who methodSelector storeString)
    ].
    ^ 'unboundMethod'

    "
     Method new whoString
     (Method compiledMethodAt:#whoString) whoString
    "

    "Modified: 1.11.1996 / 16:27:04 / cg"
!

whoStringWith:sep
    "return a string like className>>selector, 
     if this is not an unbound method.
     Otherwise return 'unbound'. Used with debugging."

    |who|

    who := self who.
    who notNil ifTrue:[
        ^ who methodClass name , sep , (who methodSelector storeString)
    ].
    ^ 'unboundMethod'

    "
     Method new whoStringWith:' >> '
     (Method compiledMethodAt:#whoString) whoStringWith:' >> '
     (Method compiledMethodAt:#whoString) whoStringWith:'  '
     (Method compiledMethodAt:#whoString) whoStringWith:' -> '
    "
! !

!Method methodsFor:'private'!

annotationAtIndex: index
    "return the annotation at given index.
     any raw annotation array (as generated by the compiler)
     is lazily initialized from the 2-element format to real annotation instances here.
     This is done to avoid the need for knowledge about annotation instances in the stc compiler."

    | annotationOrArray annotation args |

    annotations isNil ifTrue:[^nil].

    annotationOrArray := annotation := annotations at: index.
    annotationOrArray isArray ifTrue:[
        args := annotationOrArray size == 2
                    ifTrue:[annotationOrArray second]
                    ifFalse:[#()].
        args isArray ifFalse:[args := Array with: args].
        annotation := Annotation
                        method:self
                        key: annotationOrArray first
                        arguments: args.
        annotation isUnknown ifFalse:[
            annotations isImmutable ifTrue:[
                annotations := annotations asMutableCollection
            ].
            annotations at: index put: annotation.
"/            annotation annotatesMethod: self
        ].
    ].
    ^annotation

    "Created: / 02-07-2010 / 22:30:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2010 / 19:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:46:27 / cg"
    "Modified (comment): / 26-07-2012 / 15:48:07 / cg"
!

annotationIndexOf: key
    "Returns the index of annotation with given key
     or nil if there is no such annotation"

    annotations isNil ifTrue:[^nil].

    annotations keysAndValuesDo: [:index :annotationOrArray|
	annotationOrArray isArray
	    ifTrue: [annotationOrArray first == key ifTrue:[^index]]
	    ifFalse:[annotationOrArray key == key ifTrue:[^index]]
    ].
    ^nil.

    "Created: / 19-05-2010 / 16:40:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2010 / 19:23:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-07-2012 / 15:48:14 / cg"
!

cacheSourceStream:aStream
    "remember a (raw) source stream for later use"

    |lastStream|

    (package notNil and:[package ~= PackageId noProjectID]) ifTrue:[
	LastFileLock critical:[
	    lastStream := LastFileReference at:1.
	    (lastStream notNil
	      and:[lastStream class ~~ SmallInteger
	      and:[lastStream isOpen]]) ifTrue:[
		lastStream close.
	    ].
	    LastSourceFileName := package,'/',source.
	    LastFileReference at:1 put:aStream.
	].
    ].
!

getAnnotations
    ^annotations

    "Created: / 10-07-2010 / 21:55:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2010 / 19:30:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 26-07-2012 / 15:49:38 / cg"
!

getLookupObject

    ^lookupObject

    "Created: / 10-07-2010 / 21:55:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

localSourceStream
    "try to open a stream from a local source file,
     searching in standard places."

    |dir fileName sourceBaseName aStream|

    "/ Source may be absolute. If so, try it first without searching
    "/ along package path. This should be much faster when running from
    "/ build-directory (the usual case when developing)
    (source includes: Filename separator) ifTrue:[ 
        aStream := source asFilename readStreamOrNil.
        aStream notNil ifTrue:[^ aStream].    
        sourceBaseName := source asFilename baseName.
    ] ifFalse:[ 
        sourceBaseName := source.
    ].

    package notNil ifTrue:[
        "/
        "/ old: look in 'source/<filename>'
        "/ this is still kept in order to find user-private
        "/ classes in her currentDirectory.
        "/
        fileName := Smalltalk getSourceFileName:(package copyReplaceAll:$: with:$/) , '/' , sourceBaseName.
        fileName notNil ifTrue:[
            aStream := fileName asFilename readStreamOrNil.
            aStream notNil ifTrue:[^ aStream].
        ].
        "/
        "/ new: look in package-dir
        "/
        dir := Smalltalk getPackageDirectoryForPackage:package.
        dir notNil ifTrue:[
            fileName := dir construct:sourceBaseName.
            aStream := fileName asFilename readStreamOrNil.
            aStream notNil ifTrue:[^ aStream].
        ].
    ].
    fileName := Smalltalk getSourceFileName:sourceBaseName.
    fileName notNil ifTrue:[
        aStream := fileName asFilename readStreamOrNil.
    ].
    ^ aStream

    "Modified: / 07-09-2016 / 09:20:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rawSourceStreamUsingCache:usingCacheBoolean
    "return an open sourceStream (needs positioning).
     If usingCacheBoolean is true, cache the stream (but take care against concurrent access).
     You have to close the stream, if usingCacheBoolean is false, and should not close it
     if usingCacheBoolean is true."

    |aStream fileName who myClass mgr className classNameSymbol dir mod pkgDef |

    "
     if sourcePosition is nonNil, its the fileName and
     abs(sourcePosition) is the offset.
     Otherwise, source is the real source
    "
    source isNil ifTrue:[^ nil].
    sourcePosition isNil ifTrue:[^ source readStream].

    usingCacheBoolean ifTrue:[
        (package notNil and:[package ~= PackageId noProjectID]) ifTrue:[
            "/ keep the last source file open, because open/close
            "/ operations maybe slow on NFS-mounted file systems.
            "/ Since the reference to the file is weak, it will be closed
            "/ automatically if the file is not referenced for a while.
            "/ Neat trick.

            LastFileLock critical:[
                aStream := LastFileReference at:1.
                (aStream isNil
                  or:[aStream class == SmallInteger
                  or:[aStream isOpen not]]) ifTrue:[
                    aStream := nil.
                    LastFileReference at:1 put:nil.
                ].
                (aStream notNil
                 and:[LastSourceFileName ~= (package,'/',source)]) ifTrue:[
                    aStream := nil.
                ].
            ].

            aStream notNil ifTrue:[
                ^ aStream
            ].
        ].
    ].

    "/ a negative sourcePosition indicates
    "/ that this is a local file
    "/ (not to be requested via the sourceCodeManager)
    "/ This kludge was added, to allow sourceCode to be
    "/ saved to a local source file (i.e. 'st.src')
    "/ and having a clue for which file is meant later.

    sourcePosition < 0 ifTrue:[
        aStream := source asFilename readStreamOrNil.
        aStream isNil ifTrue:[
            "/ search in some standard places
            fileName := Smalltalk getSourceFileName:source.
            fileName notNil ifTrue:[
                aStream := fileName asFilename readStreamOrNil.
            ].
        ].
        aStream notNil ifTrue:[
            usingCacheBoolean ifTrue:[
                self cacheSourceStream:aStream.
            ].
            ^ aStream
        ].
    ].

    "/ First, try local source (if configured)
    Class tryLocalSourceFirst ifTrue:[ 
        aStream := self localSourceStream.
        aStream notNil ifTrue:[
            usingCacheBoolean ifTrue:[
                self cacheSourceStream:aStream.
            ].
            ^ aStream
        ].
    ].


    "/ Figure out my source code manager
    (mclass notNil and:[package == mclass package]) ifTrue:[
        mgr := mclass sourceCodeManagerFromBinaryRevision
    ] ifFalse:[
        "I'm an extension and we don't have binary revision info (!!)
         for extensions, try to guess here"
        pkgDef := ProjectDefinition definitionClassForPackage: package.
        pkgDef notNil ifTrue:[
            mgr := pkgDef sourceCodeManagerFromBinaryRevision
        ] ifFalse:[
            "OK, trust the configuration"
            mgr := AbstractSourceCodeManager managerForPackage: package
        ]
    ].

    "/ If there's no SCM for and we have not tried a local source yet,
    "/ (see above around line 70), try local source. 
    (Class tryLocalSourceFirst not and:[mgr isNil]) ifTrue:[
        aStream := self localSourceStream.
        aStream notNil ifTrue:[
            usingCacheBoolean ifTrue:[
                self cacheSourceStream:aStream.
            ].
            ^ aStream
        ].
    ].

    "/
    "/ nope - ask my class for the source (this also invokes the SCMgr)
    "/
    who := self who.
    who notNil ifTrue:[
        myClass := who methodClass.

        (package notNil and:[package ~= myClass package and:[package ~= #'__NoProject__']]) ifTrue:[
            "/ I am an extension
            mgr notNil ifTrue:[
                "/ try to get the source using my package information ...

                | sourceFileName |

                sourceFileName := (source includes: Filename separator) ifTrue:[ source asFilename baseName ] ifFalse:[ source ].
                mod := package asPackageId module.
                dir := package asPackageId directory.
                aStream := mgr streamForExtensionFile:sourceFileName package:package directory:dir module:mod cache:true.
                aStream notNil ifTrue:[
                    usingCacheBoolean ifTrue:[
                        self cacheSourceStream:aStream.
                    ].
                    ^ aStream
                ].
            ].
            "/ consult the local fileSystem
            aStream := self localSourceStream.
            aStream notNil ifTrue:[
                usingCacheBoolean ifTrue:[
                    self cacheSourceStream:aStream.
                ].
                ^ aStream
            ]
        ].

        aStream := myClass sourceStreamFor:source.
        aStream notNil ifTrue:[
            usingCacheBoolean ifTrue:[
                self cacheSourceStream:aStream.
            ].
            ^ aStream
        ].
    ].

    "/
    "/ nope - look in standard places
    "/ (if there is a source-code manager - otherwise, we already did that)
    "/
    (mgr notNil and:[Class tryLocalSourceFirst not]) ifTrue:[
        aStream := self localSourceStream.
        aStream notNil ifTrue:[
            usingCacheBoolean ifTrue:[
                self cacheSourceStream:aStream.
            ].
            ^ aStream
        ].
    ].

    "/
    "/ final chance: try current directory
    "/
    aStream isNil ifTrue:[
        aStream := source asFilename readStreamOrNil.
        aStream notNil ifTrue:[
            usingCacheBoolean ifTrue:[
                self cacheSourceStream:aStream.
            ].
            ^ aStream
        ].
    ].

    (who isNil and:[source notNil]) ifTrue:[
        "/
        "/ mhmh - seems to be a method which used to be in some
        "/ class, but has been overwritten by another or removed.
        "/ (i.e. it has no containing class anyMore)
        "/ try to guess the class from the sourceFileName.
        "/ and retry.
        "/
        className := Smalltalk classNameForFile:source.
        (classNameSymbol := className asSymbolIfInterned) notNil ifTrue:[
            myClass := Smalltalk at:classNameSymbol ifAbsent:nil.
            myClass notNil ifTrue:[
                aStream := myClass sourceStreamFor:source.
                aStream notNil ifTrue:[
                    usingCacheBoolean ifTrue:[
                        self cacheSourceStream:aStream.
                    ].
                    ^ aStream
                ].
            ]
        ]
    ].

    ^ nil

    "Modified: / 26-11-2006 / 22:33:38 / cg"
    "Modified: / 07-09-2016 / 08:53:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setLookupObject: lookup
    "set the lookupObject (low level - use lookupObject:)"

    lookupObject ~~ lookup ifTrue:[
	lookupObject := lookup.
	ObjectMemory flushCaches.
    ].

    "Created: / 11-07-2010 / 19:31:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceChunkFromStream:aStream
    PositionError handle:[:ex |
	^ nil
    ] do:[
	aStream position:(sourcePosition ? 1) abs - 1.
    ].
    ^ aStream nextChunk.
!

sourceStreamUsingCache:usingCacheBoolean
    "return an open sourceStream (needs positioning).
     If usingCacheBoolean is true, cache the stream (but take care against concurrent access).
     You have to close the stream, if usingCacheBoolean is false, and should not close it
     if usingCacheBoolean is true."

    |rawStream|

    rawStream := self rawSourceStreamUsingCache:usingCacheBoolean.
    rawStream isNil ifTrue:[
	^ nil.
    ].
    rawStream position:0.

    "/ see if its utf8 encoded...
    ^ EncodedStream decodedStreamFor:rawStream.
! !

!Method methodsFor:'private-compiler interface'!

primitiveNumber
    "for stx rel >= 5.x only:
     return the primitive number."

%{  /* NOCONTEXT */

#ifdef F_PRIMITIVE
    INT f = __intVal(__INST(flags));
    OBJ nr = 0;

    if (f & F_PRIMITIVE) {
	nr = __INST(code_);
    }
    RETURN (nr);
#endif
%}.
    self primitiveFailed
!

setPrimitiveNumber:aNumber
    "for stx rel >= 5.x only:
     mark the method as having primitive code."

%{  /* NOCONTEXT */

#ifdef F_PRIMITIVE
    INT f = __intVal(__INST(flags));

    f |= F_PRIMITIVE;
    __INST(flags) = __mkSmallInteger(f);
    __INST(code_) = aNumber;
    RETURN (self);
#endif
%}.
    self primitiveFailed



!

setResourceFlag
    "mark the method as having a <resource> definition in its
     source. This flag can be used to find resource-flagged methods quicker."

%{  /* NOCONTEXT */

#ifdef F_RESOURCE
    INT f = __intVal(__INST(flags));

    f |= F_RESOURCE;
    __INST(flags) = __mkSmallInteger(f);
#endif
%}
! !

!Method methodsFor:'queries'!

accessedInstVars
    "return a collection of instVarNames, which are accessed by
     the receiver method"

    |src parser|

    src := self source.
    src notNil ifTrue:[
	parser := Parser
			parseMethod:src
			in:self containingClass
			ignoreErrors:true
			ignoreWarnings:true.

	(parser notNil and:[parser ~~ #Error]) ifTrue:[
	    ^ parser usedInstVars
	].
    ].
    ^ #() "/ actually: unknown

    "Modified: 19.6.1997 / 17:54:09 / cg"
!

accessesField:instVarIndex
    "return true, if the instvar at instVarIndex is accessed by the receiver.
     Uses parser (for now); could look at bytecode as well here..."

    |instVarName|

    instVarName := (self mclass allInstVarNames) at:instVarIndex.
    ^ self accessesInstVar:instVarName

    "Created: / 23-07-2012 / 11:13:54 / cg"
!

accessesInstVar:instVarName
    "return true, if the named instvar is accessed by the receiver.
     Uses parser (for now); could look at bytecode as well here..."

    |usedInstVars|

    (self source includesString:instVarName) ifFalse:[^ false].     "/ that's much faster than parsing...
    usedInstVars := self parse:#'parseMethodSilent:in:' with:self mclass  return:#usedInstVars or:#().
    ^ usedInstVars includes:instVarName.

    "Created: / 23-07-2012 / 11:15:02 / cg"
!

containingClass
    "return the class I am defined in.
     Notice, that the containingClass query returns nil, if a method is wrapped or no longer valid
     due to an accept in a browser or debugger.
     However, the mclass slot still contains a reference to the once valid class and can be fetched
     via getMclass.
     See comment in who."

    "based on who, which has been added for ST-80 compatibility"

    |who|

    mclass notNil ifTrue:[
	"/ check if this (cached) info is still valid...
	(mclass containsMethod:self) ifTrue:[
	    ^ mclass
	].
	^ nil.
    ].

    who := self who.
    who notNil ifTrue:[
	mclass := who methodClass.
	^ mclass
    ].
    "
     none found - sorry
    "
    ^ nil

    "
     (Object compiledMethodAt:#at:) containingClass

     (Object class compiledMethodAt:#version) containingClass
    "
!

externalLibraryFunction
    "if this is an externalLibraryFunction call, return the externalLibraryFunction.
     Returns nil otherwise."

    |newMethod function|

    (self
	literalsDetect:[:lit |
	    #(
		#'invoke'
		#'invokeWith:'
		#'invokeWith:with:'
		#'invokeWith:with:with:'
		#'invokeWith:with:with:with:'
		#'invokeWithArguments:'
		#'invokeCPPVirtualOn:'
		#'invokeCPPVirtualOn:with:'
		#'invokeCPPVirtualOn:with:with:'
		#'invokeCPPVirtualOn:with:with:with:'
		#'invokeCPPVirtualOn:with:with:with:with:'
		#'invokeCPPVirtualOn:withArguments:'
	    ) includes:lit
	]
	ifNone:nil) notNil
    ifTrue:[
	"/ sigh - for stc-compiled code, this does not work:
	function := self literalsDetect:[:lit | lit isExternalLibraryFunction] ifNone:nil.
	function isNil ifTrue:[
	    "/ parse it and ask the parser
	    newMethod := Compiler compile:self source forClass:self mclass install:false.
	    function := newMethod literalsDetect:[:lit | lit isExternalLibraryFunction] ifNone:nil.
	].
	^ function
    ].
    ^ nil

    "
     (IDispatchPointer compiledMethodAt:#'invokeGetTypeInfo:_:_:')
	externalLibraryFunction
    "
!

hasAnnotation
    "Return true iff the method has any annotation"

    ^annotations notNil

    "Created: / 11-07-2010 / 19:27:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-07-2012 / 15:49:59 / cg"
!

hasAnnotation: key
    "Return true iff the method is annotated with the given key"

    annotations isNil ifTrue:[^ false].
    ^ (self annotationIndexOf: key) notNil

    "Created: / 11-07-2010 / 19:28:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 26-07-2012 / 15:49:54 / cg"
!

hasAnyResource:aCollectionOfSymbols
    "return true if the method has a <resource> definition for any symbol in aCollectionOfSymbols"

    ^ self hasResource and:[ self resources keys includesAny:aCollectionOfSymbols ]

    "
     Method allInstancesDo:[:m |
	(m hasAnyResource:#(image canvas)) ifTrue:[self halt]
     ].
    "
!

hasPrimitiveCode
    "return true, if the method contains primitive code; false if not.
     Uses Parser to parse methods source and get the information."

    |src|

    "/ first a trivial reject, if the source does not
    "/ contain a '% {' sequence

    src := self source.
    src notNil ifTrue:[
	(src includesString:(String with:$% with:${) "<- no constant here - to avoid trouble with stupid scanners" ) ifFalse:[
	    "/ cannot contain primitive code.
	    ^ false
	]
    ].

    "/ ok; it may or may not ...

    ^ self parse:#'parseMethodSilent:' return:#hasPrimitiveCode or:false

    "
     (Method compiledMethodAt:#hasPrimitiveCode) hasPrimitiveCode
     (Object compiledMethodAt:#at:) hasPrimitiveCode
     (Object compiledMethodAt:#basicAt:) hasPrimitiveCode
    "

    "Modified: 22.1.1997 / 00:03:45 / cg"
!

hasResource
    "return true if the method had a <resource> definition in its
     source. This flag can be used to find resource-flagged methods quicker."

%{  /* NOCONTEXT */

#ifdef F_RESOURCE
    RETURN (((INT)__INST(flags) & __MASKSMALLINT(F_RESOURCE)) ? true : false);
#endif
%}.
    ^ false
!

indexOfOLECall
    "return the vtable inedx, if the method contains an ole call; nil if not.
     Uses Parser to parse methods source and get the information."

    |funcOrNil|

    funcOrNil := self externalLibraryFunction.
    (funcOrNil isNil or:[funcOrNil isCallTypeOLE not]) ifTrue:[^ nil].
    ^ funcOrNil vtableIndex

    "
     (Method compiledMethodAt:#hasPrimitiveCode) isOLECall
     (Method compiledMethodAt:#hasPrimitiveCode) indexOfOLECall

     (Win32OperatingSystem class compiledMethodAt:#primClosePrinter:) isOLECall
     (Win32OperatingSystem class compiledMethodAt:#primClosePrinter:) indexOfOLECall
     (Win32OperatingSystem class compiledMethodAt:#primClosePrinter:) isExternalLibraryFunctionCall
     (Win32OperatingSystem class compiledMethodAt:#primClosePrinter:) externalLibraryFunctionCall

     (IUnknownPointer compiledMethodAt:#invokeAddRef) isExternalLibraryFunctionCall
     (IUnknownPointer compiledMethodAt:#invokeAddRef) externalLibraryFunction
     (IUnknownPointer compiledMethodAt:#invokeAddRef) isOLECall
     (IUnknownPointer compiledMethodAt:#invokeAddRef) indexOfOLECall
    "

    "Modified (comment): / 25-09-2012 / 12:01:32 / cg"
!

isDocumentationMethod
    "Return true, if this is a documentation only (only a comment) method
     (implies being a metaclass method)"

    self mclass isMeta ifFalse:[^ false].
    self isVersionMethod ifTrue:[^ false].
    ^ self parse:#'parseMethodSilent:' return:#isEmptyMethod or:false.
!

isExtension
    "return true, if this method is an extension (i.e. package ~= classes' package)"

    ^ package ~= self mclass package

    "Created: / 07-09-2011 / 09:29:13 / cg"
!

isExternalLibraryFunctionCall
    "Return true, if this is an externalLibraryFunction call."

    "/ sigh - for now, stc-compiled code does not have it in the literal array
    "/ to be fixed...

    ^ self externalLibraryFunction notNil
!

isForCompatibility
    "returns true, if this method only used for compatibility
     and should use only when porting foreign code but not otherwise"

    |res|

    ^ self package == #'stx:libcompat'
      or:[(res := self resources) notNil and:[res includesKey:#compatibility]]
!

isInvalid
    "return true, if this method is not executable due to
     a (re)-compilation error. Since invalidation is by patching the
     method's code-pointer to a trap function, check for that here.
     (see comment in Method>>invalidCodeObject)."

    |m myCode|

    myCode := self code.

    m := self trapMethodForNumArgs:(self argumentCount).
    (m notNil and:[self ~~ m]) ifTrue:[
	(myCode notNil and:[myCode = m code]) ifTrue:[^ true].
	(byteCode notNil and:[byteCode == m byteCode]) ifTrue:[^ true].
    ].

    m := Method compiledMethodAt:#uncompiledCodeObject.
    (m notNil and:[self ~~ m]) ifTrue:[
	(myCode notNil and:[myCode = m code]) ifTrue:[^ true].
	(byteCode notNil and:[byteCode == m byteCode]) ifTrue:[^ true].
    ].

    m := Method compiledMethodAt:#unloadedCodeObject.
    (m notNil and:[self ~~ m]) ifTrue:[
	(myCode notNil and:[myCode = m code]) ifTrue:[^ true].
	(byteCode notNil and:[byteCode == m byteCode]) ifTrue:[^ true].
    ].

    ^ false

    "Modified: 4.11.1996 / 23:34:24 / cg"
!

isMethod
    "return true, if the receiver is some kind of method;
     true returned here - the method is redefined from Object."

    ^ true
!

isMethodWithBreakpoints
    "only redefined in MethodWithBreakpoints"

    ^ false

    "Created: / 01-08-2012 / 17:26:43 / cg"
!

isOLECall
    "return true, if the method is an ole call; false if not."

    |funcOrNil|

    funcOrNil := self externalLibraryFunction.
    ^ funcOrNil notNil and:[funcOrNil isCallTypeOLE]
!

isObsolete
    "returns true, if this method is obsolete and should not be used any longer"

    |res|

    ^ (res := self resources) notNil and:[res includesKey:#obsolete]
!

isShadowingExtension
    "return true, if this method is an extension (i.e. package ~= classes' package)
     which shadows an existing method from another package (i.e. a package conflict)"

    ^ self shadowedMethod notNil.

    "Modified: / 03-10-2014 / 15:16:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSubclassResponsibility
    ^ self 
        sendsAnySelector:#( 
            #subclassResponsibility #subclassResponsibility: 
            #implementedBySubclass  "/ ST/V code uses this
        ).

    "Created: / 16-07-2017 / 11:25:54 / cg"
!

isSynthetic
    "a syntheric method does not really exist - it is only shown in a browser's list"

    ^ false

    "Modified (format): / 07-09-2011 / 09:00:56 / cg"
!

isVersionMethod
    "Return true, if this is a CVS, SVN or other version method.
     Stupid: need to know all of them here; better add a pragma or
     method attribute for that..."

    ^ self mclass isMeta
    and:[(AbstractSourceCodeManager isVersionMethodSelector:self selector)]

    "
     (Method class compiledMethodAt:#version) isVersionMethod
     (Method class compiledMethodAt:#documentation) isVersionMethod
    "
!

isVisualWorksTypedef
    "Return true, if this is a type-returning method (a visualWorks typedef)"

    ^ (self literals size > 0)
    and:[ (self literalAt:1) isKindOf:CType ]
!

mclass
    "return the class in which the receiver is currently contained in.
     Notice, that the mclass query returns nil, if a method is wrapped or no longer valid
     due to an accept in a browser or debugger.
     However, the mclass slot still contains a reference to the once valid class and can be fetched
     via getMclass.
     Same as #containingClass, for ST80 compatibility."

    ^ self containingClass

    "Created: 19.6.1997 / 16:26:13 / cg"
!

messages
    "return a collection of message-selectors, sent by this method."

    ^ self messagesSent
!

messagesDo:aBlock
    "evaluate aBlock for each message-selector sent by this method.
     Uses Parser to parse methods source and extract the names."

    ^ self messagesSent do:aBlock
!

messagesPossiblySent
    "return a collection with the message selectors possibly sent to by the receiver.
     Uses Parser to parse methods source and extract the names.
     The returned collection includes perform-like and possibly performed messages"

    ^ self parse:#'parseMethodSilent:in:' with:self mclass return:#messagesPossiblySent or:#()

    "
     (Method compiledMethodAt:#printOn:) messagesSent
     (Point compiledMethodAt:#x:) messagesSent

     (WindowEvent class compiledMethodAt:#focusInView:) messagesSent
     (WindowEvent class compiledMethodAt:#focusInView:) messagesPossiblySent

     (Method compiledMethodAt:#messagesPossiblySent) messagesSent
     (Method compiledMethodAt:#messagesPossiblySent) messagesPossiblySent
    "
!

messagesSent
    "return a collection with the message selectors sent to by the receiver.
     Uses Parser to parse methods source and extract the names.
     The returned collection includes all used message selectors (i.e. including super-send messages)"

    ^ self parse:#'parseMethodSilent:in:' with:self mclass return:#messagesSent or:#()

    "
     (Method compiledMethodAt:#printOn:) messagesSent
     (Point compiledMethodAt:#x:) messagesSent
    "
!

messagesSentToSelf
    "return a collection with the message selectors sent to self by the receiver.
     Uses Parser to parse methods source and extract the names."

    ^ self parse:#'parseMethodSilent:in:' with:self mclass return:#messagesSentToSelf or:#()

!

messagesSentToSuper
    "return a collection with the message selectors sent to super by the receiver.
     Uses Parser to parse methods source and extract the names."

    ^ self parse:#'parseMethodSilent:in:' with:self mclass return:#messagesSentToSuper or:#()

!

methodArgAndVarNames
    "return a collection with the methods argument and variable names.
     Uses Parser to parse methods source and extract the names.
     Returns an empty collection if the source is not available, or some other
     syntax/parse error occurred.
     For methods with no args and no vars, an empty collection is returned."

    |parserClass parser sourceString argNames varNames|

    parserClass := self parserClass.
    sourceString := self source.
    (parserClass notNil and:[sourceString notNil]) ifTrue:[
	parser := parserClass parseMethodArgAndVarSpecificationSilent:sourceString.
	(parser isNil or:[parser == #Error]) ifTrue:[^ #()].
	argNames := parser methodArgs.
	varNames := parser methodVars.
	argNames isNil ifTrue:[^ varNames ? #()].
	varNames isNil ifTrue:[^ argNames ? #()].
	^ (argNames , varNames)
    ].
    ^ #()

    "
     (Method compiledMethodAt:#printOn:) methodArgAndVarNames
    "
!

methodArgAndVarNamesInContext: context
    "return a collection with the method's argument and variable names.
     Uses Parser to parse methods source and extract the names.
     Returns nil if the source is not available, or some other
     syntax/parse error occurred. For methods with no args and no vars,
     an empty collection is returned."

     ^self methodArgAndVarNames

     "Created: / 18-12-2012 / 18:17:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodArgNames
    "return a collection with the methods argument names.
     Uses Parser to parse methods source and extract the names."

    ^ self parse:#'parseMethodSpecificationSilent:' return:#methodArgs or:nil

    "
     (Method compiledMethodAt:#printOn:) methodArgNames
    "

    "Modified: 31.10.1995 / 14:36:46 / cg"
!

methodComment
    "return the methods first comment, nil if there is none.
     This is a somewhat stupid implementation."

    |text line nQuote index qIndex qIndex2 comment|

    text := self source asCollectionOfLines.
    (text size < 2) ifTrue:[^nil].

    line := (text at:2).
    nQuote := line occurrencesOf:(Character doubleQuote).
    (nQuote == 2) ifTrue:[
	qIndex := line indexOf:(Character doubleQuote).
	qIndex2 := line indexOf:(Character doubleQuote) startingAt:(qIndex + 1).
	^ line copyFrom:(qIndex + 1) to:(qIndex2 - 1)
    ].
    (nQuote == 1) ifTrue:[
	qIndex := line indexOf:(Character doubleQuote).
	comment := line copyFrom:(qIndex + 1).
	(line indexOf:$/ startingAt:qIndex) == (qIndex+1) ifTrue:[
	    "/ an EOL comment
	    ^ (comment copyFrom:2) withoutSeparators
	].

	"/ not an EOL comment
	index := 3.
	line := text at:index.
	nQuote := line occurrencesOf:(Character doubleQuote).
	[nQuote ~~ 1] whileTrue:[
	    comment := comment , Character cr asString , line withoutSpaces.
	    index := index + 1.
	    line := text at:index.
	    nQuote := line occurrencesOf:(Character doubleQuote)
	].
	qIndex := line indexOf:(Character doubleQuote).
	^ comment , Character cr asString , (line copyTo:(qIndex - 1)) withoutSpaces
    ].
    ^ nil

    "
     (Method compiledMethodAt:#methodComment) methodComment
    "
!

methodDefinitionTemplate
    "return the string that defines the method and the arguments"

    ^ self class
	methodDefinitionTemplateForSelector:self selector
	andArgumentNames:self methodArgNames

    "
      (self compiledMethodAt:#printOn:) methodDefinitionTemplate
    "
!

methodInvocationInfo
    "redefined by InstrumentedMethod, to return the collected info"

    ^ nil

    "Created: / 27-04-2010 / 13:36:12 / cg"
!

methodVarNames
    "return a collection with the methods local-variable names.
     Uses Parser to parse methods source and extract the names."

    ^ self parse:#'parseMethodArgAndVarSpecificationSilent:' return:#methodVars or:nil

    "
     (Method compiledMethodAt:#printOn:) methodVarNames
    "

    "Modified: 31.10.1995 / 14:36:49 / cg"
!

modificationTime
    "try to extract the modificationTime as a timeStamp from
     the receiver's source. If there is no source or no history line,
     we do not know the modification time, and nil is returned."

    |s list histLine|

    HistoryManager isNil ifTrue:[^ nil].

    s := self source.
    s isNil ifTrue:[^ nil].
    list := HistoryManager getAllHistoriesFrom:s.
    list isEmptyOrNil ifTrue:[^ nil].
    histLine := list last.
    ^ Timestamp
        fromDate:histLine date
        andTime:histLine time

    "
     (Method compiledMethodAt:#modificationTime) modificationTime
     (Method compiledMethodAt:#isMethod) modificationTime
    "

    "Modified: 8.9.1995 / 15:08:22 / claus"
    "Modified: 4.11.1996 / 22:28:17 / cg"
!

modifiedInstVars
    "returns a collection of instance variables which are modified by this method.
     Uses parser (for now); could look at bytecode as well here..."

    ^ self parse:#'parseMethodSilent:in:' with:self mclass  return:#modifiedInstVars or:#().
!

name
    "for compatibility with javaMethods"

    ^ self selector

    "Created: / 9.11.1998 / 06:15:08 / cg"
!

overwrites:aMethod
    |mth|

    mth := self.
    [ mth := mth overwrittenMethod. mth notNil ] whileTrue:[
        mth == aMethod ifTrue:[
            ^ true
        ].
    ].
    ^ false

    "Created: / 05-07-2012 / 10:52:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parse:parseSelector return:accessSelector or:valueIfNoSource
    "helper for methodArgNames, methodVarNames etc.
     Get the source, let parser parse it using parseSelector,
     return parser-info using accessSelector"

    ^ self parse:parseSelector with:nil return:accessSelector or:valueIfNoSource

    "
     (Method compiledMethodAt:#parse:return:or:)
	parse:#'parseMethodSilent:' return:#sentMessages or:#()
    "
!

parse:parseSelector with:arg2 return:accessSelector or:valueIfNoSource
    "helper for methodArgNames, methodVarNames etc.
     Get the source, let parser parse it using parseSelector,
     return parser-info using accessSelector"

    |parser parserClass sourceString cachedInfo|

    parserClass := self parserClass.

    "/ because parsing the same method multiple times for different aspects
    "/ is very common with the new browser's info displays, we cache a few
    "/ of them. If the same is parsed soon after, we do not have to parse again.
    LastParseTreeCache notNil ifTrue:[
        "/ to flush: LastParseTreeCache removeAll.
        cachedInfo := LastParseTreeCache at:self ifAbsent:nil.
        cachedInfo notNil ifTrue:[
            cachedInfo method == self ifTrue:[
                cachedInfo parser class == parserClass ifTrue:[
                    "/ Transcript show:'hit '; showCR:self.
                    ^ cachedInfo parser perform:accessSelector
                ]
            ].
            LastParseTreeCache removeKey:self
        ]
    ].

    sourceString := self source.
    (parserClass notNil and:[sourceString notNil]) ifTrue:[
        parseSelector argumentCount == 2 ifTrue:[
            parser := parserClass perform:parseSelector with:sourceString with:arg2.
        ] ifFalse:[
            parser := parserClass perform:parseSelector with:sourceString.
        ].
        (parser isNil or:[parser == #Error]) ifTrue:[^ valueIfNoSource].
        "do not cache the parser, if it was parsing for code - a lot of information is missing then"
        (self mclass notNil and:[parser wasParsedForCode not]) ifTrue:[
            LastParseTreeCache isNil ifTrue:[
                LastParseTreeCache := CacheDictionary new:500.
            ].
            LastParseTreeCache at:self put:(ParserCacheEntry new method:self parser:parser).
        ].
        ^ parser perform:accessSelector
    ].
    ^ valueIfNoSource

    "
     LastParseTreeCache removeAll.

     (Method compiledMethodAt:#parse:return:or:)
        parse:#'parseMethodSilent:' return:#sentMessages or:#()
    "

    "Modified: / 01-03-2012 / 14:30:50 / cg"
    "Modified (comment): / 30-07-2013 / 15:53:41 / cg"
!

parseAnnotations
    "return the method's annotations."

    |src parser|

    src := self source.
    src isNil ifTrue:[
        ^ nil "/ actually: don't know
    ].

    self parserClass isNil ifTrue:[
        ^ nil
    ].
    parser := self parserClass parseMethod: src.
    (parser isNil or: [parser == #Error]) ifTrue:[
        ^ nil "/ actually error
    ].
    ^ annotations := parser annotations.

    "Created: / 10-07-2010 / 21:16:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseResources
    "return the method's resource spec; either nil or a collection of symbols.
     Resources are a special kind of annotation, of the form:
        <resource: #symbol...>
     and flags methods which depend on keyboard bindings or provide menus, specs or bitmap images"

    |src parser|

    src := self source.
    src isNil ifTrue:[
        ^ nil "/ actually: don't know
    ].

    (src findString:'resource:') == 0 ifTrue:[
        ^ nil "/ actually: error
    ].
    "/ no need to parse all - only interested in resource-info
    self parserClass isNil ifTrue:[
        ^ nil
    ].
    parser := self parserClass parseMethodArgAndVarSpecificationSilent:src in:nil.
    parser isNil ifTrue:[
        ^ nil "/ actually error
    ].
    ^ parser primitiveResources.
!

possiblySends:aSelectorSymbol
    "return true, if this method contains an indirect message-send
     (such as perform) with aSelectorSymbol as selector."

    (self referencesLiteral:aSelectorSymbol) ifTrue:[
	^ self messagesPossiblySent includesIdentical:aSelectorSymbol
    ].
    ^ false
!

previousVersion
    "return the receiver's previous version's source code"

    |previous|

    previous := self previousVersions:2.
    previous isEmptyOrNil ifTrue:[^ nil].
    ^ previous first.

"/    |sel cls previous|
"/
"/    sel := self selector.
"/    sel isNil ifTrue:[ ^ nil ].
"/
"/    cls := self mclass.
"/    cls isNil ifTrue:[ ^ nil ].
"/
"/    ChangeSet current reverseDo:[:change |
"/        (change isMethodChange
"/            and:[ (change selector == sel)
"/            and:[ change changeClass == cls ]])
"/        ifTrue:[
"/            previous := change previousVersion.
"/            previous notNil ifTrue:[
"/                ^ previous
"/            ]
"/        ]
"/    ].
"/    ^ nil.

"/    history := Class methodHistory.
"/    history isNil ifTrue:[^ nil].
"/
"/    entry := history detect:[:entry | |type old new|
"/                                    type := entry first.
"/                                    type == #methodChange ifTrue:[
"/                                        old := entry second.
"/                                        new := entry third.
"/                                        new == self
"/                                    ] ifFalse:[
"/                                        false
"/                                    ]
"/                             ]
"/                     ifNone:nil.
"/    entry isNil ifTrue:[^nil].
"/    ^ entry second.
"/    ^ history at:self ifAbsent:nil

    "Modified: / 26-07-2012 / 13:16:34 / cg"
!

previousVersionCode
    "return the receiver's previous version's source code"

    |previous|

    previous := self previousVersion.
    previous isNil ifTrue:[ ^ nil ].

    ^ previous source
!

previousVersions
    "return a collection of the receiver's previous versions (sources)"

    ^ self previousVersions:nil

    "Modified (comment): / 26-07-2012 / 12:04:15 / cg"
!

previousVersions:count
    "return a collection of the receiver's count previous versions (sources).
     A nil count will retrieve all versions"

    |sel cls versions lastChange firstSrc last|

    sel := self selector.
    sel isNil ifTrue:[^ #()].

    cls := self mclass.
    cls isNil ifTrue:[^ #()].

    versions := OrderedCollection new.

    ChangeSet current reverseDo:[:change |
	(change isMethodChange
	    and:[ (change selector == sel)
	    and:[ change changeClass == cls ]])
	ifTrue:[
	    versions addFirst:change.
	    lastChange := change.
	    (count notNil and:[versions size == count]) ifTrue:[
		^ versions
	    ]
	]
    ].

    lastChange notNil ifTrue:[
	last := lastChange previousVersion.
	last notNil ifTrue:[
	    firstSrc := last source.
	    (firstSrc notEmptyOrNil
	    and:[ firstSrc ~= lastChange source]) ifTrue:[
		versions addFirst:(MethodDefinitionChange
				    className:lastChange className
				    selector:lastChange selector
				    source:firstSrc
				    category:lastChange category).
	    ]
	]
    ].
    ^ versions

    "
     (Method compiledMethodAt:#previousVersions:) previousVersions:nil
    "

    "Created: / 26-07-2012 / 11:59:57 / cg"
!

readsField:instVarIndex
    "return true, if the instvar at instVarIndex is read by the receiver.
     Uses parser (for now); could look at bytecode as well here..."

    |instVarName|

    instVarName := (self mclass allInstVarNames) at:instVarIndex.
    ^ self readsInstVar:instVarName

    "Modified: / 23-07-2012 / 11:16:08 / cg"
!

readsInstVar:instVarName
    "return true, if the named instvar is read by the receiver.
     Uses parser (for now); could look at bytecode as well here..."

    |readInstVars|

    (self source includesString:instVarName) ifFalse:[^ false].     "/ that's much faster than parsing...
    readInstVars := self parse:#'parseMethodSilent:in:' with:self mclass  return:#readInstVars or:#().
    ^ readInstVars includes:instVarName.

    "Created: / 23-07-2012 / 11:15:56 / cg"
!

refersToLiteral: anObject
    "redefined to search in annotations"

    (super refersToLiteral: anObject) ifTrue:[^ true].

    self annotationsDo:[:annot |
	(annot refersToLiteral: anObject) ifTrue:[
	    "/ self halt.
	    ^ true
	].
    ].
    ^ false

    "Created: / 26-07-2012 / 15:51:14 / cg"
!

refersToLiteralMatching: aMatchString
    (super refersToLiteralMatching: aMatchString) ifTrue:[^ true].

    self annotationsDo:[:annot |
	(annot refersToLiteralMatching: aMatchString) ifTrue:[
	    "/ self halt.
	    ^ true
	].
    ].
    ^ false

    "Created: / 26-07-2012 / 15:51:36 / cg"
!

resourceType
    "ST-80 compatibility:
     return the methods first resource specs key.
     Returns either nil, or a single symbol."

    |resources|

    (resources := self resources) notNil ifTrue:[
	resources keysAndValuesDo:[:key :val|
	    ^ key
	].
    ].
    ^ nil
!

resources
    "return the methods resource spec; either nil or a collection of symbols."

    | resources |

    self hasResource ifFalse:[^ nil].
    annotations isNil ifTrue:[^ self parseResources].

    resources := IdentityDictionary new.
    self annotationsAt: #resource: orAt: #resource:values: do:[:annot|
        resources at: annot type put: annot value ? true
    ].
    ^ resources

    "Modified: / 16-07-2010 / 11:49:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:48:41 / cg"
!

selector
    "return the selector under which I am found in my containingClasses
     method-table.
     See comment in who."

    "based on who, which has been added for ST-80 compatibility"

    |who|

    who := self who.
    who notNil ifTrue:[^ who methodSelector].
    "
     none found - sorry
    "
    ^ nil

    "
     |m|
     m := Object compiledMethodAt:#at:.
     m selector
    "

    "Modified: 1.11.1996 / 16:25:48 / cg"
!

sends:aSelectorSymbol
    "return true, if this method contains a message-send
     with aSelectorSymbol as selector."

    (self referencesLiteral:aSelectorSymbol) ifTrue:[
        "/ cg: was temporarily disabled to speed up some searches.
        "/ I think, we have to change the callers to call referencesLiteral: instead,
        "/ if there is any speed problem there. Not here.
        "/ ^ true.
        "/ the self messagesSent does a parse-tree analysis
        ^ self messagesSent includesIdentical:aSelectorSymbol
    ].
    ^ false
!

sends:selectorSymbol1 or:selectorSymbol2
    "return true, if this method contains a message-send
     to either selectorSymbol1 or selectorSymbol2.
     This is a hack, because calling sends: twice parses twice (should cache parse trees)"

    ^ self sendsAny:{ selectorSymbol1 selectorSymbol2 }

    "Modified (comment): / 08-08-2011 / 18:43:04 / cg"
!

sendsAny:aCollectionOfSelectorSymbols
    "return true, if this method contains a message-send
     to any of aCollectionOfSelectorSymbols."

    |msgs|

    (aCollectionOfSelectorSymbols contains:[:sym | self referencesLiteral:sym]) ifTrue:[
	"/ cg: was temporarily disabled to speed up some searches.
	"/ I think, we have to change the caller's to call referencesLiteral: instead,
	"/ if there is any speed problem there. Not here.
	"/ ^ true.

	msgs := self messagesSent.
	^ aCollectionOfSelectorSymbols contains:[:sym | msgs includesIdentical:sym]
    ].
    ^ false

    "Created: / 08-08-2011 / 18:53:24 / cg"
!

sendsMessageForWhich:aCheckBlock
    "return true, if this method contains a message-send
     for which aCheckBlock returns true, when given the selector."

    self literalsDo:[:each |
        each isSymbol ifTrue:[
            "/ first check if the selector matches
            (aCheckBlock value:each) ifTrue:[
                "/ then, if this is really a message send
                (self messagesSent includes:each) ifTrue:[^ true].
            ]
        ]
    ].
    ^ false

    "
     (self compiledMethodAt:#sendsAnyForWhich:)
        sendsAnyForWhich:[:sel | sel startsWith:'message']
     (self compiledMethodAt:#sendsAnyForWhich:)
        sendsAnyForWhich:[:sel | sel startsWith:'foo']
    "
!

shadowedMethod
    "Return the shadowed method if this method is an extension (i.e. package ~= classes' package)
     AND it shadows (redefines) an existing method from the method's class.
     If this method does not shadow any other method, return nil."

    | myClass nonMetaClass myProjectDefinition originalMethod|

    myClass := self mclass.
    myClass isNil ifTrue:[^ nil].
    nonMetaClass := myClass theNonMetaclass.

    (package ~= nonMetaClass package
	and:[ package ~= PackageId noProjectID
	and:[ (myProjectDefinition := nonMetaClass projectDefinitionClass) notNil ]])
    ifTrue:[
	originalMethod := myProjectDefinition savedOverwrittenMethodForClass:myClass selector:self selector.

	"/ mhm - what if it does no make a difference?
	"/ (originalMethod notNil and:[originalMethod source = self source]) ifTrue:[
	"/    "/ self halt. ^ nil
	"/ ].
	^ originalMethod
    ].
    ^ nil

    "Created: / 03-10-2014 / 15:16:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldBeSkippedInDebuggersWalkBack
    "return true, if this method thinks, it should be skipped in a walkback.
     This is done by looking for a #skipInDebuggersWalkBack flag in the method's resources."

    |resources|

    resources := self resources.
    ^ resources notNil
        and:[ resources includesKey:#skipInDebuggersWalkBack ].
!

superMessages
    "return a collection of message-selectors, sent to super by this method."

    ^ self messagesSentToSuper
!

usedGlobals
    "return a collection with the global names referred to by the receiver.
     Uses Parser to parse methods source and extract them."

    ^ self parse:#'parseMethodSilent:in:' with:self mclass return:#usedGlobals or:#()

    "
     (Method compiledMethodAt:#resources) usedGlobals
    "
!

usedSymbols
    "return a collection with the symbols referred to by the receiver.
     Uses Parser to parse methods source and extract them.
     This collection only includes implicit symbols references
     (i.e. not messages sent)"

    ^ self parse:#'parseMethodSilent:in:' with:self mclass return:#usedSymbols or:#()

    "
     (Method compiledMethodAt:#usedSymbols) usedSymbols
     (Method compiledMethodAt:#usedSymbols) messagesSent
    "
!

who
    "return the class and selector of where I am defined in;
     nil is returned for unbound methods.

     ST/X special notice:
	returns an instance of MethodWhoInfo, which
	responds to #methodClass and #methodSelector query messages.
	For backward- (& ST-80) compatibility, the returned object also
	responds to #at:1 and #at:2 messages.

     Implementation notice:
	To avoid an expensive search, the once valid containing class is kept and remembered
	in the mclass slot. However, if a method gets recompiled or wrapped, the mclass field is
	no longer valid and who on the old method returns nil (because the method is actually no longer
	contained in that class). However, to allow easier unwrapping (and gathering of the corresponding
	wrapper), the mclass field is never nilled. I.e. it still refers to the original class.
	Therefore, a validation of the mclass slot is done here."

    |cls sel fn clsName checkBlock|

    mclass notNil ifTrue:[
	"/ check if this (cached) info is still valid...
	sel := mclass selectorAtMethod:self.
	sel notNil ifTrue:[
	    ^ MethodWhoInfo class:mclass selector:sel
	].
	^ nil.
    ].

    checkBlock :=
	[:cls |
	    |sel|

	    sel := cls selectorAtMethod:self.
	    sel notNil ifTrue:[
		LastWhoClass := cls theNonMetaclass name.
		mclass := cls.
		^ MethodWhoInfo class:cls selector:sel
	    ].
	].

    "
     first, look in the class we found something the last time
     this may often give a hit, when asking who repeatingly for
     a context chain. (keep last by its name, to not keep classes from
     being garbage collected)
    "
    LastWhoClass notNil ifTrue:[
	cls := Smalltalk at:LastWhoClass ifAbsent:nil.
	cls notNil ifTrue:[
	    checkBlock value:cls theNonMetaclass.
	    checkBlock value:cls theMetaclass.
	]
    ].

    "
     speedup kludge: if my sourceFileName is valid,
     extract the className from it and try that class first.
    "
    (fn := self sourceFilename) notNil ifTrue:[
	clsName := fn asFilename nameWithoutSuffix.
	clsName := clsName asSymbolIfInterned.
	clsName notNil ifTrue:[
	    cls := Smalltalk at:clsName ifAbsent:nil.
	    cls notNil ifTrue:[
		checkBlock value:cls theNonMetaclass.
		checkBlock value:cls theMetaclass.
	    ]
	].
    ].

    "
     limit the search to global classes only -
     since probability is high, that the receiver is found in there ...
    "
    Smalltalk allClassesDo:[:cls |
	checkBlock value:cls theNonMetaclass.
	checkBlock value:cls theMetaclass.
    ].

    LastWhoClass := nil.
"/    "
"/     mhmh - must be a method of some anonymous class (i.e. one not
"/     in the Smalltalk dictionary). Search all instances of Behavior
"/    "
"/    Behavior allSubInstancesDo:[:someClassLikeThingy |
"/        (classes includes:someClassLikeThingy) ifFalse:[
"/            checkBlock value:someClassLikeThingy.
"/        ]
"/    ].
    "
     none found - sorry
    "
    ^ nil

    "typical situation: some well-known class"
    "
     |m|
     m := Object compiledMethodAt:#copy.
     m who
    "

    "untypical situation: an anonymous class"
    "
     |m cls|

     Object
	subclass:#FunnyClass
	instanceVariableNames:'foo'
	classVariableNames:''
	poolDictionaries:''
	category:'testing'.
     cls := Smalltalk at:#FunnyClass.
     Smalltalk removeClass:cls.

     cls compile:'testMethod1:arg foo:=arg'.
     cls compile:'testMethod2 ^ foo'.
     m := cls compiledMethodAt:#testMethod1:.

     m who
    "

    "Modified: / 07-11-2006 / 13:58:50 / cg"
!

wrapper
    "only for wrapped methods: return the wrapper.
     That's the WrapperMethod which contains myself."

    WrappedMethod notNil ifTrue:[
	WrappedMethod allInstancesDo:[:m |
	    m originalMethod == self ifTrue:[^ m].
	].
    ].
    ^ nil

    "Modified: / 05-12-2011 / 11:15:26 / cg"
!

writesField:instVarIndex
    "return true, if the instvar at instVarIndex is written (modified) by the receiver.
     Uses parser (for now); could look at bytecode as well here..."

    |instVarName|

    instVarName := (self mclass allInstVarNames) at:instVarIndex.
    ^ self writesInstVar:instVarName

    "Modified: / 23-07-2012 / 11:16:51 / cg"
!

writesInstVar:instVarName
    "return true, if the named instvar is written (modified) by the receiver.
     Uses parser (for now); could look at bytecode as well here..."

    |modifiedInstVars|

    (self source includesString:instVarName) ifFalse:[^ false].     "/ that's much faster than parsing...
    modifiedInstVars := self parse:#'parseMethodSilent:in:' with:self mclass return:#modifiedInstVars or:#().
    ^ modifiedInstVars includes:instVarName.

    "Created: / 23-07-2012 / 11:16:36 / cg"
! !


!Method methodsFor:'source management'!

revisionInfo
    "cg: is this correct for extensions? (shouldn't this be the revisionInfo from the extensions container?)"

    ^self containingClass theNonMetaclass revisionInfo

    "Created: / 28-08-2010 / 22:43:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-09-2010 / 16:38:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'trap methods'!

makeInvalid
    "make the receiver an invalid method, which raises an invalidCodeObject
     signal when executed. This is not for public use - it is required for
     the objectFileLoader to invalidate methods whose code is unloaded."

    |invldMethod|

    invldMethod := self trapMethodForNumArgs:(self argumentCount).
    self code:invldMethod code.
    self byteCode:nil.

    "Created: 17.9.1995 / 15:00:52 / claus"
    "Modified: 4.11.1996 / 23:04:34 / cg"
!

makeUncompiled
    "make the receiver an uncompiled method, which raises an invalidCodeObject
     signal when executed. This is not for public use - it is required for
     the compiler to invalidate methods which cannot be compiled due to errors
     after a class definition change (for example: instvars are no longer there)."

    |invldMethod|

    invldMethod := self class compiledMethodAt:#uncompiledCodeObject.
    self code:invldMethod code.
    self byteCode:nil.

    "Created: 17.9.1995 / 15:01:14 / claus"
    "Modified: 4.11.1996 / 23:04:46 / cg"
!

makeUnloaded
    "make the receiver an unloaded method, which raises an invalidCodeObject
     signal when executed. This is not for public use - it is required for
     the objectFileLoader to invalidate methods for which a shared library has
     been removed."

    |invldMethod|

    invldMethod := self class compiledMethodAt:#unloadedCodeObject.
    self code:invldMethod code.
    self byteCode:nil.

    "Created: 4.11.1996 / 22:59:21 / cg"
    "Modified: 4.11.1996 / 23:04:52 / cg"
!

trapMethodForNumArgs:numArgs
    ^ self class trapMethodForNumArgs:numArgs

    "Created: / 04-11-1996 / 21:58:58 / cg"
    "Modified: / 08-09-2011 / 05:35:48 / cg"
! !

!Method::MethodWhoInfo class methodsFor:'documentation'!

documentation
"
    In earlier times, Method>>who returned an array filled
    with the methods class and selector.
    This was done, since a smalltalk method cannot return multiple
    values, but 2 values had to be returned from that method.
    Thus, the who-interface was used as:
	info := <someMethod> who.
	class := info at:1.
	sel := info at:2.

    Sure, this is ugly coding style, and the system has been changed to return
    an object (an instance of MethodWhoInfo) which responds to the two
    messages: #methodClass and #methodSelector.
    This allows to write things much more intuitive:
	info := <someMethod> who.
	class := info methodClass.
	sel := info methodSelector.

    However, to be backward compatible, the returned object still responds to
    the #at: message, but only allows inices of 1 and 2 to be used.

    The MethodWhoInfo class is private to Method - its not visible to other
    classes.

    [author:]
	Claus Gittinger

    [see also:]
	Method
"
! !

!Method::MethodWhoInfo class methodsFor:'instance creation'!

class:cls selector:sel
    "return a new MethodWhoInfo object;
     this is a private interface for Method"

    ^ self basicNew class:cls selector:sel

    "Modified: 2.1.1997 / 15:27:59 / cg"
! !

!Method::MethodWhoInfo methodsFor:'accessing'!

method
    ^ myClass compiledMethodAt:mySelector
!

methodClass
    "return the class which contains the method represented by myself"

    ^ myClass

    "
     (Method compiledMethodAt:#who) who methodClass
     (Method::MethodWhoInfo compiledMethodAt:#methodClass) who methodClass
    "

    "Modified: 2.1.1997 / 14:59:02 / cg"
!

methodSelector
    "return the selector under which the the method represented by myself
     is found in the class"

    ^ mySelector

    "Modified: 2.1.1997 / 14:59:24 / cg"
! !

!Method::MethodWhoInfo methodsFor:'compatibility'!

at:index
    "simulate the old behavior (when Method>>who returned an array)"

    index == 1 ifTrue:[
	^ myClass
    ].
    index == 2 ifTrue:[
	^ mySelector
    ].

    "/ sigh - full compatibility ?
    ^ self indexNotIntegerOrOutOfBounds:index
! !

!Method::MethodWhoInfo methodsFor:'private-accessing'!

class:cls selector:sel
    myClass := cls.
    mySelector := sel


! !

!Method::ParseTreeCacheEntry methodsFor:'accessing'!

method
    ^ method
!

method:something
    method := something.
!

parser
    ^ parser
!

parser:something
    parser := something.
!

parserClass
    ^ parserClass
!

parserClass:something
    parserClass := something.
!

parserClass:parserClassArg method:methodArg
    parserClass := parserClassArg.
    method := methodArg.
!

parserClass:parserClassArg method:methodArg parser:parserArg
    parserClass := parserClassArg.
    method := methodArg.
    parser := parserArg.

    "Created: / 08-08-2011 / 19:05:02 / cg"
! !

!Method::ParserCacheEntry methodsFor:'accessing'!

method
    ^ method
!

method:something
    method := something.
!

method:methodArg parser:parserArg
    method := methodArg.
    parser := parserArg.

    "Created: / 08-08-2011 / 19:05:02 / cg"
!

parser
    ^ parser
!

parser:something
    parser := something.
! !

!Method class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$ Id: Method.st 10648 2011-06-23 15:55:10Z vranyj1 $'
! !


Method initialize!
