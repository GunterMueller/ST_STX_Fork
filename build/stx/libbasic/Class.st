"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2009-2010 Jan Vrany
 COPYRIGHT (c) 2015-2016 Jan Vrany
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

ClassDescription subclass:#Class
	instanceVariableNames:'name category classvars comment subclasses classFilename package
		revision environment signature attributes'
	classVariableNames:'DefaultCategoryForDolphin DefaultCategoryForSTV
		DefaultCategoryForUncategorizedClasses
		DefaultCategoryForUndeclaredClasses DefaultCategoryForVAGE
		SubclassCacheSequenceNumber ValidateSourceOnlyOnce
		ValidatedClasses'
	poolDictionaries:''
	category:'Kernel-Classes'
!

Array variableSubclass:#ArrayWithSequenceNumberValidation
	instanceVariableNames:'sequenceNumber'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Class
!

Object subclass:#ClassAttributes
	instanceVariableNames:'primitiveDefinitions primitiveVariables primitiveFunctions
		sharedPools traitComposition localSelectors vGuid fGuid
		projectDirectory'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Class
!

Object subclass:#SimulatedClassPool
	instanceVariableNames:'class'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Class
!

Association subclass:#SimulatedVariableBinding
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Class::SimulatedClassPool
!

!Class class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2009-2010 Jan Vrany
 COPYRIGHT (c) 2015-2016 Jan Vrany
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
    Class adds more functionality to classes; minimum stuff has already
    been defined in Behavior and ClassDescription; this adds naming, categories etc.

    [Instance variables:]

	name            <Symbol>                    the classes name

	category        <Symbol>                    the classes category

	classvars       <String>                    the names of the class variables;
			| <Collection of words>     initially, stc generates a string; this is converted on the fly
						    to an array of names. In the future, stc may be changed.

	comment         <String>                    the classes comment; either a string,
						    a number specifying the offset in classFilename, or nil

	subclasses      <Collection>                cached collection of subclasses
						    (not used for execution, but for the IDE to speed up certain operations)

	classFilename   <String>                    the file (or nil) where the classes' sources are found

	package         <Symbol>                    the package, in which the class was defined (inserted by compilers)

	revision        <String>                    revision string - inserted by stc

	environment     <Symbol | nil>              cached environment (i.e. Smalltalk or a namespace)

	signature       <SmallInteger>              the classes signature (used to detect obsolete or changed classes with binaryStorage)
						    This is filled in lazy - i.e. upon the first signature query.

	attributes   <Array | nil>                  describes primitiveIncludes, primitiveFunctions etc.
						    also a place to add additional attributes, without a need to recompile all classes.


    WARNING: layout known by compiler and runtime system

    [author:]
	Claus Gittinger

    [see also:]
	Behavior ClassDescription Metaclass
"
!

versionManagement
"
    old scheme (up to 5.4.x):
	the #version method is supposed to return a CVS (or RCS) version string.
	this string contains (among other info) the revision number of the CVS container
	from which the class was compiled.
	To access the source code of a class, this file is reconstructed (either cached or
	checked out), and the source-chunk is fetched from that file at the position which
	is stored in the method object.

    new scheme (starting with 5.5.0):
	a classes sourcecode might be present in multiple source code management systems;
	for example, a site might decide to use CVS, where another might wonna use SVN
	(or other in the future).
	Therefore, a single version method is no longer sufficient; each sourceCodeManager
	will store its version info in its own format in a separate version method.
	The sourceCodeManager can be asked via #nameOfVersionMethodInClasses for the selector
	of this version.
	Currently these are #version_CVS and #version_SVN. More might be added in the future.

	Two additional identifiers are added to support a unique id, which can be used to
	compare classes and methods coming from different source containers:
	    version_VID and version_FID
	Both are UUID's. The VID is updated with every change, whereas the FID is assigned only once.
	The FID can be interpreted as a functional-ID, and the VID as an identity id.
"
! !

!Class class methodsFor:'accessing-flags'!

tryLocalSourceFirst
    "if true, local source files are tried first, before a sourceCodemanager is
     consulted. This may speed up the source access, but adds some insecurity, because
     the sourceCodemanager is always getting the source for the classes correct version.
     In contrast, the local file might be different from (edited in an external tool) in
     the meantime. You have been warned - better leave it false (the sourceCodemanager will
     fill its cache and eventually be just as fast...)"

    "JV: When smalltalk is not yet initialized, do use local sources
         because before that, SCM support may not be loaded and configured
         properly, leading to funny errors."
    ^ Smalltalk isInitialized not or:[TryLocalSourceFirst == true].

    "Created: 24.1.1996 / 19:55:35 / cg"
!

tryLocalSourceFirst:aBoolean
    "if true, local source files are tried first, before a sourceCodemanager is
     consulted. This may speed up the source access, but adds some insecurity, because
     the sourceCodemanager is always getting the source for the classes correct version.
     In contrast, the local file might be different from (edited in an external tool) in
     the meantime. You have been warned - better leave it false (the sourceCodemanager will
     fill its cache and eventually be just as fast...)"

    TryLocalSourceFirst := aBoolean

    "Created: 24.1.1996 / 19:55:35 / cg"
!

updateChanges:aBoolean
    "turn on/off changes management. Return the prior value of the flag.
     This value is used as a default fallback - a querySignal handler may still
     decide to return something else."

    |prev|

    prev := UpdatingChanges.
    UpdatingChanges := aBoolean.
    ^ prev
!

updatingChanges
    "return true if changes are recorded.
     The value returned here is the default fallback - a querySignal handler may still
     decide to return something else."

    ^ UpdatingChanges
! !

!Class class methodsFor:'creating new classes'!

name:newName
    "this new instance creation protocol may be used in scripts to replace the traditional inst-creation messages"

    ^ self
        name:newName
        subclassOf:Object
        instanceVariableNames:''
        category:(self defaultCategoryForUncategorizedClasses)
!

name:newName instanceVariableNames:stringOfInstVarNames
    "this new instance creation protocol may be used in scripts to replace the traditional inst-creation messages"

    ^ self
        name:newName
        subclassOf:Object
        instanceVariableNames:stringOfInstVarNames
        category:(self defaultCategoryForUncategorizedClasses)
!

name:newName subclassOf:aClass
    "this new instance creation protocol may be used in scripts to replace the traditional inst-creation messages"

    ^ self
        name:newName
        subclassOf:aClass
        instanceVariableNames:''
        category:(self defaultCategoryForUncategorizedClasses)
!

name:newName subclassOf:aClass instanceVariableNames:stringOfInstVarNames
    "this new instance creation protocol may be used in scripts to replace the traditional inst-creation messages"

    ^ self
        name:newName
        subclassOf:aClass
        instanceVariableNames:stringOfInstVarNames
        category:(self defaultCategoryForUncategorizedClasses)
!

name:newName subclassOf:aClass instanceVariableNames:stringOfInstVarNames category:categoryString
    "this new instance creation protocol may be used in scripts to replace the traditional inst-creation messages"

    ^ self
        name:newName
        subclassOf:aClass
        instanceVariableNames:stringOfInstVarNames
        classVariableNames:nil
        poolDictionaries:nil
        category:categoryString
!

name:newName
         subclassOf:aClass
         instanceVariableNames:stringOfInstVarNames
         classVariableNames:stringOfClassVarNames
         category:categoryString

    "this new instance creation protocol may be used in scripts to replace the traditional inst-creation messages"

    ^ self
        name:newName
        subclassOf:aClass
        instanceVariableNames:stringOfInstVarNames
        classVariableNames:stringOfClassVarNames
        poolDictionaries:nil
        category:categoryString
!

name:newName
         subclassOf:aClass
         instanceVariableNames:stringOfInstVarNames
         classVariableNames:stringOfClassVarNames
         classInstanceVariableNames:stringOfClassInstVarNames
         poolDictionaries:stringOfPoolNames
         category:categoryString

    "this new instance creation protocol may be used in scripts to replace the traditional inst-creation messages"

    ^ self class
        name:newName
        inEnvironment:Smalltalk
        subclassOf:aClass
        instanceVariableNames:stringOfInstVarNames
        variable:false
        words:false
        pointers:false
        classVariableNames:stringOfClassVarNames
        poolDictionaries:stringOfPoolNames
        category:categoryString
        comment:nil
        changed:false
        classInstanceVariableNames:stringOfClassInstVarNames

    "Modified: 16.6.1997 / 11:53:58 / cg"
!

name:newName
         subclassOf:aClass
         instanceVariableNames:stringOfInstVarNames
         classVariableNames:stringOfClassVarNames
         poolDictionaries:stringOfPoolNames
         category:categoryString

    "this new instance creation protocol may be used in scripts to replace the traditional inst-creation messages"

    ^ self class
        name:newName
        inEnvironment:Smalltalk
        subclassOf:aClass
        instanceVariableNames:stringOfInstVarNames
        variable:false
        words:false
        pointers:false
        classVariableNames:stringOfClassVarNames
        poolDictionaries:stringOfPoolNames
        category:categoryString
        comment:nil
        changed:false
        classInstanceVariableNames:nil

    "Modified: 16.6.1997 / 11:53:58 / cg"
!

undeclared: name
    "Creates an 'undeclared' class, a placeholder for
     superclass when loading/filing-in a class whose
     superclass does not exist yet."

    Transcript showCR:'Smalltalk [info]: Declaring undeclared class: ', name.
    ^ Object 
        subclass: name asSymbol
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:(self defaultCategoryForUndeclaredClasses)

    "Created: / 08-11-2010 / 16:08:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class class methodsFor:'helpers'!

nameWithoutPrefix:name
    "helper for fileOut and others - return a name's printString,
     without any owningClass or nameSpace prefix"

    |idx|

    name isNil ifTrue:[^ nil].

    idx := name lastIndexOf:$:.
    [idx > 1 and:[ (name at:(idx-1)) ~~ $: ]] whileTrue:[
	idx := name lastIndexOf:$: startingAt:idx-2.
    ].
    idx == 0 ifTrue:[
	^ name
    ].

    ^ name copyFrom:idx+1.

    "a public class:
     Class nameWithoutPrefix:'Array'
     Class nameWithoutPrefix:'Tools::Array'
    "

    "Modified: / 13-06-2012 / 14:41:21 / cg"
!

revisionInfoFromString:aString
    "{ Pragma: +optSpace }"

    "return a revision info, given a string.
     This extracts the relevant info from aString, asking
     the default sourceCode manager (if there is one).
     Notice, that this method is only invoked, if a class does not know
     its sourceCode manager."

    |mgr|

    "/
    "/ mhmh - ask the default manager.
    "/ if none has been defined, use the CVSSourceCodeManager
    "/
    mgr := SourceCodeManager ? CVSSourceCodeManager.
    "/
    "/ care for standAlone apps which have no CVS (libbasic3) included
    "/
    mgr isNil ifTrue:[
        AbstractSourceCodeManager notNil ifTrue:[
            ^ AbstractSourceCodeManager revisionInfoFromRCSString:aString
        ].
        ^ nil
    ].
    ^ mgr revisionInfoFromString:aString.

    "Modified: / 29-09-2011 / 21:53:29 / cg"
!

revisionStringFromSource:aMethodSourceString
    "{ Pragma: +optSpace }"

    "extract a revision string from a methods source string.
     Caveat: Assumes CVS."

    |lines line|

    lines := aMethodSourceString asCollectionOfLines.
    lines do:[:l |
        |i|

        i := l indexOfSubCollection:'$Header: '.
        "JV @ 2009-12-13: Also search for '$Id: ' (because of SVN-only classes)"
        i == 0 ifTrue:[
        i := l indexOfSubCollection:'$Id: '].
        "JV @ 2013-07-18: Also search for '$Changeset: ' (because of Mercurial-only classes)"
        i == 0 ifTrue:[
        i := l indexOfSubCollection:'$Changeset: '].

        i ~~ 0 ifTrue:[
            line := l copyFrom:i.
            i := line lastIndexOf:$$.
            i > 1 ifTrue:[
                line := line copyTo:i.
            ].
            ^ line
        ]
    ].
    ^ nil

    "Created: / 15-10-1996 / 18:57:57 / cg"
    "Modified: / 22-10-2008 / 20:29:50 / cg"
    "Modified: / 19-07-2013 / 23:32:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class class methodsFor:'misc'!

template:aCategoryString
    "return a class-definition template"

    ^ 'NameOfSuperclass subclass:#NameOfClass
    instanceVariableNames:''instVarName1 instVarName2''
    classVariableNames:''classVarName1 classVarName2''
    poolDictionaries:''''
    category:''' , aCategoryString , ''''

    "Created: / 19.6.1998 / 02:09:06 / cg"
! !

!Class class methodsFor:'private'!

flushSubclassInfo
    "throw away (forget) the cached subclass information, as created
     by #subclassInfo.
     This is private protocol"

    SubclassCacheSequenceNumber := (SubclassCacheSequenceNumber ? 0) + 1.

"/    self allSubInstancesDo:[:cls |
"/        cls flushSubclasses
"/    ].

    "
     Class flushSubclassInfo
    "

    "Modified: / 06-12-2011 / 16:20:13 / cg"
!

flushSubclassInfoFor:aClass
    "throw away (forget) the cached subclass information for aClass, as created
     by #subclassInfo.
     This is private protocol"

    aClass notNil ifTrue:[
	aClass flushSubclasses
    ].

    "
     Class flushSubclassInfoFor:View
    "

    "Modified: / 06-12-2011 / 16:20:49 / cg"
! !

!Class class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Class class or:[self == Class]

    "Created: 15.4.1996 / 17:17:13 / cg"
    "Modified: 23.4.1996 / 15:56:58 / cg"
! !




!Class methodsFor:'Compatibility-Dolphin'!

defaultCategoryForDolphinClasses
    "used only when filing in Dolphin classes (which do not provide a category in their inst creation message)"

    ^ DefaultCategoryForDolphin ? 'Dolphin classes'.
!

guid
    ^ self getAttribute:#fGuid

    "Created: / 23-09-2011 / 10:24:44 / cg"
!

guid:aUUID
    ^ self setAttribute:#fGuid to:aUUID

    "Created: / 23-09-2011 / 10:25:04 / cg"
!

stb_version
    ^ 0
!

subclass:t instanceVariableNames:f classVariableNames:d poolDictionaries:s classInstanceVariableNames:classInstanceVariableNames
    "{ Pragma: +optSpace }"

    "this method allows fileIn of Dolphin classes "

    ^ self subclass:t
	   instanceVariableNames:f
	   classVariableNames:d
	   poolDictionaries:s
	   category:(self defaultCategoryForDolphinClasses)
	   classInstanceVariableNames:classInstanceVariableNames

    "Modified: / 15.6.1998 / 21:31:34 / cg"
    "Modified: / 18.3.1999 / 18:16:11 / stefan"
!

variableSubclass:t instanceVariableNames:f classVariableNames:d poolDictionaries:s classInstanceVariableNames:classInstanceVariableNames
    "{ Pragma: +optSpace }"

    "this method allows fileIn of Dolphin classes "

    ^ self variableSubclass:t
	   instanceVariableNames:f
	   classVariableNames:d
	   poolDictionaries:s
	   category:(self defaultCategoryForDolphinClasses)
	   classInstanceVariableNames:classInstanceVariableNames

    "Modified: / 15.6.1998 / 21:31:34 / cg"
    "Modified: / 18.3.1999 / 18:16:11 / stefan"
! !

!Class methodsFor:'Compatibility-ST/V and V''Age'!

defaultCategoryForSTVorVAGEClasses
    "used only when filing in ST/V and V'Age classes (which do not provide a category in their inst creation message)"

    |cat app|

    DefaultApplicationQuerySignal isHandled ifTrue:[
        "/ while loading a package, this is answered...
        "/ put the new class into a category named after the app
        app := DefaultApplicationQuerySignal query.
        app notNil ifTrue:[
            cat := "'Applications-' ," app nameWithoutPrefix.
        ] ifFalse:[
            cat := DefaultCategoryForVAGE ? 'V''Age classes'.
        ].
    ] ifFalse:[
        cat := DefaultCategoryForSTV ? 'ST/V classes'.
    ].

    ^ cat

    "Modified: / 07-02-2012 / 17:40:35 / cg"
!

subclass:nm classInstanceVariableNames:cIV instanceVariableNames:iV classVariableNames:cV poolDictionaries:p
    "{ Pragma: +optSpace }"

    "this method allows fileIn of ST/V and V'Age classes"

    ^ self
	   subclass:nm
	   instanceVariableNames:iV
	   classVariableNames:cV
	   poolDictionaries:p
	   category:(self defaultCategoryForSTVorVAGEClasses)
	   classInstanceVariableNames:cIV
!

subclass:t instanceVariableNames:f classVariableNames:d poolDictionaries:s
    "{ Pragma: +optSpace }"

    "this method allows fileIn of ST/V and V'Age classes
     (which seem to have no category)"

    ^ self
	   subclass:t
	   instanceVariableNames:f
	   classVariableNames:d
	   poolDictionaries:s
	   category:(self defaultCategoryForSTVorVAGEClasses)

    "Modified: / 15.6.1998 / 21:31:34 / cg"
    "Modified: / 18.3.1999 / 18:16:11 / stefan"
!

variableByteSubclass:t classVariableNames:d poolDictionaries:s
    "{ Pragma: +optSpace }"

    "this method allows fileIn of ST/V and V'Age variable byte classes
     (which seem to have no category and no instvars)"

    ^ self variableByteSubclass:t
	   instanceVariableNames:''
	   classVariableNames:d
	   poolDictionaries:s
	   category:(self defaultCategoryForSTVorVAGEClasses)

    "Modified: / 15.6.1998 / 21:31:38 / cg"
    "Modified: / 18.3.1999 / 18:16:21 / stefan"
!

variableLongSubclass:t classVariableNames:d poolDictionaries:s
    "{ Pragma: +optSpace }"

    "this method allows fileIn of ST/V and V'Age variable long (32bit integers) classes
     (which seem to have no category and no instvars)"

    ^ self variableLongSubclass:t
	   instanceVariableNames:''
	   classVariableNames:d
	   poolDictionaries:s
	   category:(self defaultCategoryForSTVorVAGEClasses)
!

variableSubclass:t instanceVariableNames:f classVariableNames:d poolDictionaries:s
    "{ Pragma: +optSpace }"

    "this method allows fileIn of ST/V and V'Age variable pointer classes
     (which seem to have no category)"

    ^ self variableSubclass:t
	   instanceVariableNames:f
	   classVariableNames:d
	   poolDictionaries:s
	   category:(self defaultCategoryForSTVorVAGEClasses)

    "Modified: / 15.6.1998 / 21:31:41 / cg"
    "Modified: / 18.3.1999 / 18:16:33 / stefan"
!

variableWordSubclass:t classVariableNames:d poolDictionaries:s
    "{ Pragma: +optSpace }"

    "this method allows fileIn of ST/V and V'Age variable word (16bit integers) classes
     (which seem to have no category and no instvars)"

    ^ self variableWordSubclass:t
	   instanceVariableNames:''
	   classVariableNames:d
	   poolDictionaries:s
	   category:(self defaultCategoryForSTVorVAGEClasses)
! !

!Class methodsFor:'Compatibility-ST80'!

classPool
    "return something which allows access to my classVariables via
     #at: and #at:put: messages."

    ^ SimulatedClassPool new setClass:self

    "
     Button classPool
    "

    "Modified: 17.10.1997 / 12:12:14 / cg"
!

fileOutSourceOn:aStream
    self fileOutOn:aStream withTimeStamp:false

    "Created: 20.6.1997 / 17:18:14 / cg"
    "Modified: 20.6.1997 / 17:18:26 / cg"
!

rename:newName
    "same as renameTo: - for ST80 compatibility"

    ^ Smalltalk renameClass:self to:newName.
"/    ^ self renameTo:newName

    "Created: / 18.6.1998 / 22:08:45 / cg"
! !

!Class methodsFor:'Compatibility-Squeak'!

classVarNamed: aSymbol
    "Returns the value of class variable named `aSymbol`.

     Warning: This method is here for Squeak/Pharo compatibility.
     Do not use it in Smalltalk/X code"

    ^ self classVarAt: aSymbol

    "Created: / 17-08-2015 / 13:07:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

classVarNamed: aSymbol put: anObject
    "Set the value of class variable named `aSymbol` to `anObject`.

     Warning: This method is here for Squeak/Pharo compatibility.
     Do not use it in Smalltalk/X code"

    self classVarAt: aSymbol put: anObject

    "Created: / 25-07-2015 / 07:25:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2015 / 09:59:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classVariableNamed: aSymbol
    "Returns the value of class variable named `aSymbol`.

     Warning: This method is here for Squeak/Pharo compatibility.
     Do not use it in Smalltalk/X code"

    ^ self classVarAt: aSymbol

    "Created: / 27-07-2015 / 09:44:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classVariables
    "Return an array of class variable names.

     Warning: This method is here for Squeak/Pharo compatibility.
     Do not use it in Smalltalk/X code"

    ^ self classVarNames

    "Created: / 27-07-2015 / 09:36:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commentStamp:stampString prior:priorVersion
    ^ SqueakCommentReader new
        class:self stamp:stampString priorVersion:priorVersion
!

instanceVariables
    "Return an array of instance variable names.

     Warning: This method is here for Squeak/Pharo compatibility.
     Do not use it in Smalltalk/X code"
   
    ^ self instVarNames

    "Created: / 27-07-2015 / 09:35:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theMetaClass
    ^ self theMetaclass

    "Created: / 28-08-2015 / 09:36:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'accessing'!

addClassVarName:aString
    "add a class variable if not already there and initialize it with nil.
     Also writes a change record and notifies dependents."

    self addClassVarNames:(Array with:aString).

    "Created: / 29-10-1995 / 19:40:51 / cg"
    "Modified: / 23-01-1998 / 15:46:23 / stefan"
    "Modified: / 15-01-2011 / 14:17:41 / cg"
!

addClassVarNames:aCollectionOfStrings
    "add a number of class variables if not already there and initialize them with nil.
     Also writes a change record and notifies dependents."

    |newVariables|

    newVariables := aCollectionOfStrings reject:[:each | self classVarNames includes:each].
    newVariables isEmpty ifTrue:[^ self].

    newVariables := newVariables collect:[:each | each asSymbol].
    self classVariableString:(self classVariableString , ' ' , (newVariables asStringWith:' ')).
    Class withoutUpdatingChangesDo:[
	self withAllSubclasses do:[:cls|
	    cls recompileMethodsAccessingAnyClassvarOrGlobal:newVariables
	].
    ].
    self addChangeRecordForClass:self andNotifyChangeOf:#classVariables.

    "Modified: / 23-01-1998 / 15:46:23 / stefan"
    "Created: / 15-01-2011 / 14:17:21 / cg"
!

allPrivateClasses
    "{ Pragma: +optSpace }"

    "return a collection of all private classes and private-private classes.
     The classes are in any order."

    ^ self privateClassesOrAll:true

!

category
    "return the category of the class.
     The returned value may be a string or symbol."

    |owner|

    (owner := self owningClass) notNil ifTrue:[^ owner category].
    ^ category

    "
     Point category
     Dictionary category
    "

    "Modified: 15.10.1996 / 21:20:01 / cg"
    "Created: 1.4.1997 / 15:23:47 / stefan"
!

category:aStringOrSymbol
    "set the category of the class to be the argument, aStringOrSymbol.
     Sends out change notifications, so browers can update"

    |ns|

    self setCategory:aStringOrSymbol.
    self addChangeRecordForClass:self.
    ns := self nameSpace.
    ns changed:#organization.
    ns ~~ Smalltalk ifTrue:[
        Smalltalk changed:#organization.
    ]

    "Modified: / 23-11-2006 / 16:54:20 / cg"
!

classBaseFilename
    "return the baseName of the file from which the class was compiled.
     In contrast to classFilename, this will always be a plain basename."

    ^ self classFilename asFilename baseName

    "
     Math::ClosedInterval classFilename
    "

    "Created: / 12-10-2006 / 15:49:32 / cg"
!

classFilename
    "return the name of the file from which the class was compiled.
     If the class was loaded via an explicit load (i.e. from the fileBrowser),
     this will be an absolute path. Oherwise, it will be a basename only.
     See classBaseFilename for a method which always returns the basename."

    |owner info fn|

    (owner := self owningClass) notNil ifTrue:[^ owner classFilename].

"/  This was added as an extension of libsvn - should be no longer needed
"/    compatQuery := Smalltalk classNamed: 'SVN::CompatModeQuery'.
"/    (compatQuery notNil
"/    and:[compatQuery isLoaded
"/    and:[(compatQuery query ? true) not]])
"/        ifTrue:[^SVN::Repository containerNameForClass: self].

    classFilename notNil ifTrue:[ 
        (classFilename includes: Filename separator) ifTrue:[ 
            ^ classFilename asFilename baseName.
        ].
        ^ classFilename 
    ].

    (info := self revisionInfo) notNil ifTrue:[
        fn := info fileName.
        fn notNil ifTrue:[
            ^ fn
        ].
    ].
    ^ (Smalltalk fileNameForClass:self), '.', self sourceFileSuffix

    "
     SVN::Repository classFilename
     Array classFilename   
     Array getClassFilename
    "

    "Modified: / 22-10-2008 / 20:58:21 / cg"
    "Modified (comment): / 07-09-2016 / 09:06:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classNamed:aClassNameStringOrSymbol
    "return a private class if present; nil otherwise.
     Added for protocol compatibilty with NameSpace and Smalltalk"

    "{ Pragma: +optSpace }"
    ^ self privateClassesAt:aClassNameStringOrSymbol
!

classVarAt:aSymbol
    "return the value of a class variable.
     Currently, this returns nil if there is no such classvar -
     this may change."

    "
     this hides the (current) implementation of classVariables
     from the outside world. Currently, classvars are stored in
     the Smalltalk dictionary with a funny name, since there are
     no classPools yet.
    "
    ^ Smalltalk at:(self globalKeyForClassVar:aSymbol)
!

classVarAt:aSymbol ifAbsent:exceptionBlock
    "return the value of a class variable.
     Currently, this returns nil if there is no such classvar -
     this may change."

    "
     this hides the (current) implementation of classVariables
     from the outside world. Currently, classvars are stored in
     the Smalltalk dictionary with a funny name, since there are
     no classPools yet.
    "
    ^ Smalltalk at:(self globalKeyForClassVar:aSymbol) ifAbsent:exceptionBlock
!

classVarAt:aSymbolOrString put:something
    "store something in a classvariable.
     Currently this creates a global with a funny name if no such
     classVar exists - this may change."

    "
     this hides the (current) implementation of classVariables
     from the outside world. Currently, classvars are stored in
     the Smalltalk dictionary with a funny name, since there are
     no classPools yet.
    "
    Smalltalk at:(self globalKeyForClassVar:aSymbolOrString) put:something.

    "Modified: / 27-10-2010 / 16:35:17 / cg"
!

classVarNames
    "return a collection of the class variable name-strings.
     Only names of class variables defined in this class are included
     in the returned collection - use allClassVarNames, to get all known names.
     Traditionally, this was called classVarNames, but newer versions of squeak
     seem to have changed to use classVariableNames. 
     So you probably should use the alias"

    classvars isNil ifTrue:[
        ^ #()
    ].
    classvars isString ifTrue:[
        classvars isEmpty ifTrue:[
            classvars := #().
        ] ifFalse:[
            classvars := classvars asCollectionOfWords collect:[:varName| varName asSymbol] as:Array.
        ].
        ^ classvars
    ].

    ^ classvars

    "
     Object classVarNames
     Float classVarNames
    "
!

classVariableString
    "return a string of the class variables names.
     Only names of class variables defined in this class are in the
     returned string."

    classvars isNil ifTrue:[^ ''].
    classvars isString ifTrue:[
	^ classvars
    ].

    ^ classvars asStringWith:(Character space)

    "
     Object classVariableString
     Float classVariableString
    "
!

classVariableString:aString
    "set the classes classvarnames string;
     Initialize new class variables with nil, clear and remove old ones.
     No change record is written and no classes are recompiled."

    |prevVarNames varNames any|

    (aString ~= self classVariableString) ifTrue:[
	prevVarNames := self classVarNames asOrderedCollection.
	classvars := aString.
	varNames := self classVarNames.

	"new ones get initialized to nil;
	 - old ones are nilled and removed from Smalltalk"
	any := false.

	varNames do:[:aName |
	    (prevVarNames includes:aName) ifFalse:[
		"a new one"
		self classVarAt:aName put:nil.
		any := true.
	    ] ifTrue:[
		prevVarNames remove:aName
	    ]
	].
	"left overs are gone"
	prevVarNames do:[:aName |
	    any := true.
	    self classVarAt:aName put:nil.
	    Smalltalk removeKey:(self globalKeyForClassVar:aName).
	].
	any ifTrue:[
	    Smalltalk changed:#classVariables with:self
	].
    ]

    "Modified: / 02-04-1997 / 00:16:05 / stefan"
    "Modified: / 18-11-2006 / 17:13:14 / cg"
!

comment
    "return the comment (aString) of the class"

    |stream string|

    "the comment is either a string, or an integer specifying the
     position within the classes sourcefile ...
    "
    comment isNumber ifTrue:[
        classFilename notNil ifTrue:[
            stream := self sourceStream.
            stream notNil ifTrue:[
                stream position:comment-1.
                string := String readFrom:stream onError:''.
                stream close.
                ^ string
            ].
            ^ nil
        ]
    ].
    ^ comment

    "
     Object comment
     RunArray comment
    "
!

comment:aStringOrNil
    "{ Pragma: +optSpace }"

    "set the comment of the class to be the argument, aString;
     create a change record and notify dependents."

    |oldComment newComment|

    newComment := aStringOrNil.
    (aStringOrNil notNil and:[aStringOrNil withoutSeparators isEmpty]) ifTrue:[
	newComment := nil
    ].
    comment ~= newComment ifTrue:[
	oldComment := self comment.
	comment := newComment.
	self addChangeRecordForClassComment:self.
	self changed:#comment with:oldComment.
	Smalltalk changed:#classComment with:self.
    ]
!

containingNameSpace
    "return the namespace I am really contained in;
     For private or anonymous classes, nil is returned -
     for public classes, Smalltalk is returned."

    "/ (self nameSpace at:self nameWithoutNamespacePrefix ifAbsent:nil)
    "/ or
    (name isSymbol and:[(Smalltalk at:name) == self]) ifFalse:[
        ^ nil
    ].
    ^ self nameSpace
!

environment
    "return the namespace I am contained in; ST-80 compatible name"

    ^ self nameSpace
!

generateClassFilename
    "generate the expected filename for this class - without suffix.
     This may be different from the actual classFilename"

    |nm|

    nm := self theNonMetaclass name.
    ^ nm copyReplaceAll:$: with:$_ ifNone:nm

    "
     Complex generateClassFilename
     HTML::AbstractElement generateClassFilename
    "

    "Modified: / 06-10-2006 / 16:16:01 / cg"
!

getClassFilename
    "return the name of the file from which the class was compiled.
     If the class was loaded via an explicit load (i.e. from the fileBrowser),
     this will be an absolute path. Oherwise, it will be a basename only."

    |owner|

    (owner := self owningClass) notNil ifTrue:[^ owner getClassFilename].
    ^ classFilename

    "Modified: / 06-10-2006 / 13:32:01 / cg"
!

getPackage
    "get the package or nil."

    ^ package
!

globalKeyForClassVar:aStringOrSymbol
    "this helps to encapsulate the (current) implementation of classVariables
     from the outside world. Currently, classvars are stored in
     the Smalltalk dictionary with a funny name, since there are
     no classPools yet.
    "
    ^ (self theNonMetaclass name , ':' , aStringOrSymbol) asSymbol

    "Modified: / 18-11-2006 / 17:13:39 / cg"
!

name
    "return the name of the class.
     This returns a symbol (but notice, that other smalltalks might return a string)."

    ^ name

    "Created: 1.4.1997 / 15:24:32 / stefan"
!

nameSpace
    "return the namespace I am contained in;
     For public classes, Smalltalk is returned.
     For private classes, the owning class is returned.
     For anonymous classes, nil should be returned - but for now, this also returns Smalltalk;
     but will change in the future to return nil then.
     This is left in for a while (because many users of this method expect a non-nil return value).
     In the meantime, use containingNameSpace, which provides the correct answer"

    |idx nsName e restName|

    "/ cached in environment
    environment isNil ifTrue:[
        e := Smalltalk. "/ default

        name notNil ifTrue:[
            "/ due to the implementation, extract this from my name
            "/ (physically, all classes are found in Smalltalk)

            idx := name lastIndexOf:$:.
            idx ~~ 0 ifTrue:[
                (name at:idx-1) == $: ifTrue:[
                    nsName := name copyTo:(idx - 2).
                    e := Smalltalk at:nsName asSymbol ifAbsent:[^ Smalltalk "take care when asking an anon class"].
                ].
            ].
        ].
        environment := e.
    ].

    (environment notNil and:[name notNil]) ifTrue:[
        [
            |tryE|    

            "/ sub namespace ?
            restName := name copyFrom:environment name size + 3.
            idx := restName indexOf:$:.
            (idx ~~ 0 and:[(restName at:idx+1) == $:]) ifTrue:[
                nsName := environment name , '::', (restName copyTo:idx-1).
                tryE := Smalltalk at:nsName asSymbol.
                tryE isNameSpace ifTrue:[
                    "/ Transcript showCR:nsName.
                    "/ Transcript showCR:restName.
                    environment := tryE.
                ].
            ].
            tryE == environment
        ] whileTrue.
    ].

    ^ environment

    "
     Expecco::KeyFile::Extension setEnvironment:nil. 
     Expecco::KeyFile::Extension nameSpace 
     Expecco::KeyFile::Extension containingNameSpace 
    "

    "Modified: / 20.7.1998 / 14:21:36 / cg"
!

package
    "return the package-symbol of the class."

    |owner|

    (owner := self owningClass) notNil ifTrue:[^ owner package].
    package isNil ifTrue:[^ PackageId noProjectID].
    ^ package

    "
     Object package
    "

    "Modified: / 29.12.1998 / 01:15:50 / cg"
!

package:aSymbol
    "set the package-symbol of the class.
     Sends out change notifications, so browers can update"

    |newPackage oldPackage|

    aSymbol == PackageId noProjectID ifTrue:[
        newPackage := nil
    ] ifFalse:[
        newPackage := aSymbol
    ].
    package ~= newPackage ifTrue:[
        oldPackage := package.
        (Smalltalk
                changeRequest:#packageOfClass
                with:(Array with:self with:oldPackage with:newPackage)) ifFalse:[
            ^ self
        ].
        package := newPackage.

        self changed:#package.
        Smalltalk changed:#projectOrganization with:(Array with:self with:oldPackage).
    ].

    "Modified: / 09-08-2006 / 17:58:53 / fm"
!

poolDictionaries
    "this returns the concatenated pool name string"

    ^ self sharedPoolNames asStringWith:' '

    "Modified: / 18-01-2011 / 17:56:12 / cg"
!

primitiveDefinitions:aString
    "{ Pragma: +optSpace }"

    "set the primitiveDefinition string"

    (self isPrivate) ifTrue:[
	self error:'private classes cannot have their own primitiveDefinitions'.
    ].
    self setPrimitiveDefinitions:aString.
    self addChangeRecordForPrimitiveDefinitions:self.

    "Created: 29.10.1995 / 19:41:39 / cg"
!

primitiveDefinitionsString
    "{ Pragma: +optSpace }"

    "return the primitiveDefinition string or nil"

    |owner|

    (owner := self owningClass) notNil ifTrue:[
	^ owner primitiveDefinitionsString
    ].
    ^ self getSourceChunkAttribute:#primitiveDefinitions

    "
     Object primitiveDefinitionsString
     String primitiveDefinitionsString
    "
!

primitiveDefinitionsStringOrDefault
    "return the primitiveDefinition string or a default"

    ^ self primitiveDefinitionsString ? '%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

%}'

    "
     Object primitiveDefinitionsStringOrDefault
     String primitiveDefinitionsStringOrDefault
     ExternalStream primitiveDefinitionsStringOrDefault
    "
!

primitiveFunctions:aString
    "{ Pragma: +optSpace }"

    "set the primitiveFunction string"

    (self isPrivate) ifTrue:[
	self error:'private classes cannot have their own primitiveFunctions'.
    ].
    self setPrimitiveFunctions:aString.
    self addChangeRecordForPrimitiveFunctions:self.

    "Created: 29.10.1995 / 19:41:48 / cg"
!

primitiveFunctionsString
    "{ Pragma: +optSpace }"

    "return the primitiveFunctions string or nil"

    |owner|

    (owner := self owningClass) notNil ifTrue:[
	^ owner primitiveFunctionsString
    ].
    ^ self getSourceChunkAttribute:#primitiveFunctions
!

primitiveFunctionsStringOrDefault
    "return the primitiveFunction string or a default"

    ^ self primitiveFunctionsString ? '%{

/*
 * any local C (helper) functions
 * come here (please, define as static)
 */

%}'

    "
     Object primitiveFunctionsStringOrDefault
     String primitiveFunctionsStringOrDefault
     ExternalStream primitiveFunctionsStringOrDefault
    "
!

primitiveVariables:aString
    "{ Pragma: +optSpace }"

    "set the primitiveVariable string"

    (self isPrivate) ifTrue:[
	self error:'private classes cannot have their own primitiveVariables'.
    ].
    self setPrimitiveVariables:aString.
    self addChangeRecordForPrimitiveVariables:self.

    "Created: 29.10.1995 / 19:41:58 / cg"
!

primitiveVariablesString
    "{ Pragma: +optSpace }"

    "return the primitiveVariables string or nil"

    |owner|

    (owner := self owningClass) notNil ifTrue:[
	^ owner primitiveVariablesString
    ].
    ^ self getSourceChunkAttribute:#primitiveVariables
!

primitiveVariablesStringOrDefault
    "return the primitiveVariable string or a default"

    ^ self primitiveVariablesString ? '%{

/*
 * any local C variables
 * come here (please, define as static)
 */

%}'

    "
     Object primitiveVariablesStringOrDefault
     String primitiveVariablesStringOrDefault
     ExternalStream primitiveVariablesStringOrDefault
    "
!

privateClassNamed:aClassNameStringOrSymbol
    ^ self privateClassesAt:aClassNameStringOrSymbol
!

privateClasses
    "{ Pragma: +optSpace }"

    "return a collection of my private classes (if any).
     The classes are in any order."

    ^ self privateClassesOrAll:false

    "
     Object privateClasses
     ObjectMemory privateClasses
     UILayoutTool privateClasses
    "

    "Modified: / 29.5.1998 / 23:23:18 / cg"
!

privateClassesAt:aClassNameStringOrSymbol
    "{ Pragma: +optSpace }"

    "return a private class if present; nil otherwise"

    |myName nmSym|

    myName := self name.
    myName isNil ifTrue:[
	"/ no name - there cannot be a corresponding private class
	^ nil
    ].
    nmSym := (myName , '::' , aClassNameStringOrSymbol) asSymbolIfInterned.
    nmSym isNil ifTrue:[
	"/ no such symbol - there cannot be a corresponding private class
	^ nil
    ].

    ^ Smalltalk at:nmSym.

    "Modified: 26.6.1997 / 11:44:04 / cg"
!

privateClassesAt:aClassNameStringOrSymbol put:aClass
    "{ Pragma: +optSpace }"

    "add a private class"

    self classVarAt:(':' , aClassNameStringOrSymbol) put:aClass

    "Modified: 26.6.1997 / 11:44:12 / cg"
!

privateClassesOrAll:allOfThem
    "{ Pragma: +optSpace }"

    "return a collection of my direct private classes (if any)
     or direct plus indirect private classes (if allOfThem).
     An empty collection if there are none.
     The classes are in no particular order."

    |classes myName myNamePrefix myNamePrefixLen|

    myName := self name.
    myNamePrefix := myName , '::'.
    myNamePrefixLen := myNamePrefix size.

    Smalltalk keysDo:[:nm |
	|cls|

	(nm startsWith:myNamePrefix) ifTrue:[
	    (allOfThem
	    or:[(nm indexOf:$: startingAt:myNamePrefixLen + 1) == 0]) ifTrue:[
		cls := Smalltalk at:nm.

		(cls isBehavior and:[cls isMeta not]) ifTrue:[
		    classes isNil ifTrue:[
			classes := Set new:10.
		    ].
		    classes add:cls.
		]
	    ]
	]
    ].

    ^ classes ? #()

    "
     UILayoutTool privateClassesOrAll:true
     UILayoutTool privateClassesOrAll:false
    "

    "Modified: / 29-05-1998 / 23:23:18 / cg"
    "Modified (comment): / 18-07-2011 / 09:15:39 / cg"
!

privateClassesSorted
    "{ Pragma: +optSpace }"

    "return a collection of my private classes (if any).
     The classes are sorted by inheritance."

    |classes pivateClassesOf|

    classes := self privateClasses.
    classes notEmpty ifTrue:[
	classes := classes asOrderedCollection.
	classes sort:[:a :b | a name < b name].

	pivateClassesOf := IdentityDictionary new.
	classes do:[:each | pivateClassesOf at:each put:(each allPrivateClasses)].

	classes topologicalSort:[:a :b |
	    "/ a must come before b iff:
	    "/    b is a subclass of a
	    "/    b has a private class which is a subclass of a

	    |mustComeBefore pivateClassesOfB|
	    mustComeBefore := b isSubclassOf:a.
	    pivateClassesOfB := pivateClassesOf at:b.
	    pivateClassesOfB do:[:eachClassInB |
		mustComeBefore := mustComeBefore or:[eachClassInB isSubclassOf:a]
	    ].
	    mustComeBefore
	].
    ].
    ^ classes.

    "
     Object privateClassesSorted
     Class privateClassesSorted
     Class privateClasses
    "

    "Created: 22.3.1997 / 16:10:42 / cg"
    "Modified: 22.3.1997 / 16:11:20 / cg"
!

projectDefinition
    <resource: #obsolete>
    "return the project definition of the classes package"

    self obsoleteMethodWarning.
    ^ self projectDefinitionClass

    "
     Object projectDefinition productVersion
     DAPASX::DapasUI projectDefinition productVersion
    "

    "Created: / 19-09-2006 / 22:02:06 / cg"
!

projectDefinitionClass
    "return the project definition of the classes' package.
     Eg. for Array, this would return the stx_libbasic project definition class."

    ^ ProjectDefinition definitionClassForPackage: self package

    "
     Object projectDefinitionClass productVersion
     DAPASX::DapasUI projectDefinitionClass productVersion
    "

    "Created: / 19-09-2006 / 22:02:06 / cg"
!

realSharedPoolNames
    "this returns the namespace aware pool names"

    |poolNames ns|

    poolNames := self sharedPoolNames.
    (ns := self topNameSpace) notNil ifTrue:[
        ^ poolNames
                collect:[:nm |
                    |p|
                    (p := ns at:nm asSymbol) notNil ifTrue:[
                        p name
                    ] ifFalse:[
                        nm
                    ]].
    ].
    ^ poolNames

    "
     HGCommand sharedPoolNames    
     HGCommand realSharedPoolsNames  
     HGCommand sharedPoolNames  
     Croquet::OpenGL sharedPools
     Croquet::OpenGL sharedPools
    "

    "Created: / 18-01-2011 / 18:02:25 / cg"
!

realSharedPools
    "this returns the namespace aware pools"

    |ns|

    ns := self topNameSpace.
    ^ self sharedPoolNames collect:[:nm | ns at:nm]

    "
     Croquet::OpenGL sharedPools
     Croquet::OpenGL realSharedPools

     Win32OperatingSystem realSharedPools
     Win32OperatingSystem realSharedPoolNames
    "

    "Modified: / 18-01-2011 / 18:05:19 / cg"
!

removeClassVarName:aString
    "{ Pragma: +optSpace }"

    "remove a class variable if not already there.
     Also writes a change record and notifies dependents."

    |names newNames|

    names := self classVarNames.
    (names includes:aString) ifTrue:[
	newNames := ''.
	names do:[:nm | nm ~= aString ifTrue:[newNames := newNames , nm , ' ']].
	self classVariableString:newNames withoutSpaces.
	Class withoutUpdatingChangesDo:[
	    self withAllSubclasses do:[:cls|
		cls recompileMethodsAccessingAnyClassvarOrGlobal:
					(Array with:aString asSymbol)
	    ].
	].
	self addChangeRecordForClass:self andNotifyChangeOf:#classVariables.
    ]

    "Created: / 29.10.1995 / 19:42:08 / cg"
    "Modified: / 23.1.1998 / 15:46:33 / stefan"
!

setCategory:aStringOrSymbol
    "set the category of the class to be the argument, aStringOrSymbol.
     Does NOT send out change notifications (so browers will NOT update)"

    aStringOrSymbol isNil ifTrue:[
        category := aStringOrSymbol
    ] ifFalse:[
        category := aStringOrSymbol asSymbol
    ]

    "Created: 1.4.1997 / 15:24:04 / stefan"
!

setClassFilename:aFilename
    "set the classes filename.
     This is a dangerous (low level) operation,
     since the comment and primitiveSpecs may no longer be accessible,
     if a wrong filename is set here."

    |baseName|
    
    "/ cg: somewhere, the filename is set from a temporary (checkout) files name.
    "/ we MUST catch and FIX this.
    aFilename notNil ifTrue:[
        baseName := aFilename asFilename baseName. 
        (baseName startsWith:'st') ifTrue:[
            (baseName at:3) isDigit ifTrue:[
                self halt:'this should not be reached'
            ].
        ].
    ].
    classFilename := aFilename

    "Modified: / 08-09-1995 / 14:16:48 / claus"
    "Modified: / 25-10-2006 / 13:50:42 / cg"
!

setClassVariableString:aString
    "set the classes classvarnames string.
     This is a dangerous (low level) operation, since the
     classvariables are not really created or updated. Also,
     NO change record is written."

    classvars := aString
!

setComment:aString
    "set the comment of the class to be the argument, aString;
     do NOT create a change record"

    comment := aString
!

setComment:com category:categoryStringOrSymbol
    "set the comment and category of the class;
     do NOT create a change record"

    |cat|

    comment := com.
    categoryStringOrSymbol isNil ifTrue:[
	cat := ''
    ] ifFalse:[
	cat := categoryStringOrSymbol
    ].
    category := cat asSymbol
!

setEnvironment:aNamespace
    "set the namespace I am contained in; ST-80 compatible name"

    environment := aNamespace
!

setPackage:aSymbol
    "set the package of the class.
     Does NOT send out change notifications (so browers will NOT update)"

    package := aSymbol

    "Modified: / 09-08-2006 / 17:59:13 / fm"
!

sharedPoolNames
    "this returns a collection of the plain (non-namespace aware) pool names"

    |pools|

    pools := self getAttribute:#sharedPools.
    pools isNil ifTrue:[
        ^ #().
    ].
    pools isString ifTrue:[
        pools := (pools asCollectionOfWords collect:[:varName| varName asSymbol]) as:Array.
        self setAttribute:#sharedPools to:pools.
    ].
    ^ pools

    "
     OSI::ASN1_Coder sharedPoolNames
     Croquet::OpenGL sharedPoolNames
     OpenGLRenderingContext sharedPoolNames
     Character sharedPoolNames
     Win32OperatingSystem sharedPoolNames
    "

    "Created: / 18-01-2011 / 17:55:42 / cg"
!

sharedPoolNames:aStringOrCollection
    "{ Pragma: +optSpace }"

    "set the sharedPools string (no change notifications)
     Does NOT send out change notifications (so browers will NOT update)"

    self setSharedPoolNames:aStringOrCollection.
    self addChangeRecordForClass:self.

    "Created: / 18-01-2011 / 17:55:48 / cg"
    "Modified: / 18-01-2011 / 20:41:17 / cg"
!

sharedPools
    "this returns a collection of the real pools (i.e. the PoolDictionaries),
     not their names (see sharedPoolNames)"

    |ns ns2 pools|

    ns := self nameSpace.
    ns2 := self topNameSpace.
    pools :=
         self sharedPoolNames
            collect:[:eachName |
                    |pool|

                    ns ~= Smalltalk ifTrue:[
                        pool := ns classNamed:eachName.
                    ].
                    pool isNil ifTrue:[
                        ns2 ~= Smalltalk ifTrue:[
                            pool := ns2 classNamed:eachName.
                        ].
                    ].
                    pool isNil ifTrue:[
                        pool := Smalltalk classNamed:eachName.
                        pool isNil ifTrue:[
                            Transcript showCR:('Warning: no such pool: ',eachName).
                        ]
                    ].
                    pool
                ]
            thenSelect:[:pool | pool notNil].

    ^ pools.


    "
     OSI::ASN1_Coder sharedPoolNames
     OSI::ASN1_Coder sharedPools
     Croquet::OpenGL sharedPools
     OpenGLRenderingContext sharedPools
     Character sharedPools
     Win32OperatingSystem sharedPools
    "

    "Modified: / 29-05-2012 / 12:09:27 / cg"
!

sharedPools:aCollection
    "{ Pragma: +optSpace }"

    "set the sharedPools expects the real pools (i.e. the PoolDictionaries)"

    "/ for backward compatibility, also allow a string arg..
    aCollection isString ifTrue:[
        Transcript show:self name; showCR:' [warning]: string passed to #sharedPools:'.
        self sharedPoolNames:(aCollection asCollectionOfWords collect:[:each | each asSymbol]).
        ^ self.
    ].
    self sharedPoolNames:
        (aCollection
            collect:[:each |
                each isString
                    ifTrue:[ each asSymbol ]
                    ifFalse:[ each name ]
            ]
        ).

    "Modified: / 03-10-2011 / 10:30:30 / cg"
!

source
    "return the classes full source code"

    |code aStream|

" this is too slow for big classes (due to the emphasis stored)...
    code := String new:1000.
    aStream := WriteStream on:code.
    self fileOutOn:aStream
"
    [
        aStream := FileStream newTemporary.
        aStream removeOnClose:true.
    ] on:OpenError do:[:ex|
        self warn:'Class>>#source: cannot create temporary file: ', ex description.
        ^ nil
    ].
    [
        FileOutErrorSignal handle:[:ex |
            aStream nextPut:$" ; nextPutAll:ex description; nextPut:$".
            FileOutErrorSignal isHandled ifTrue:[
                ex reject.
            ].
        ] do:[
            self fileOutOn:aStream.
        ].
        aStream reset.
        code := aStream contents.
    ] ensure:[
        aStream close.
    ].
    ^ code

    "Modified: / 06-10-2006 / 13:34:18 / cg"
!

sourceChecksumFromBinaryRevision
    | start checksum |
    revision isNil ifTrue:[ ^ nil ].
    start:= revision indexOfString: 'SHA1='.
    start ~~ 0 ifTrue:[ 
        checksum := ByteArray new: 20.
        1 to: 20 do: [ :i |
            | si hi lo |

            si := start + 3 + (i * 2).
            hi := (revision at: si) digitValue.
            lo := (revision at: si + 1) digitValue.
            checksum at:i put: ((hi bitShift:4) bitOr: lo)
        ]
    ].
    ^ checksum

    "
    Class sourceChecksumFromBinaryRevision
    "

    "Created: / 26-01-2016 / 11:18:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceChecksumFromStream: aStream
    | stream position hash buffer |

    stream := aStream stream.
    position := stream position.
    hash := SHA1Stream new.
    buffer := ByteArray new: 4096.
    stream position: 0.

    [ stream atEnd ] whileFalse:[ 
        | read |

        read := stream nextAvailableBytes: buffer size into: buffer startingAt: 1.
        hash nextPutBytes: read from: buffer startingAt: 1 
    ].
    stream position: position.
    ^ hash hashValue.
    
    "
    Class sourceChecksumFromStream: Class sourceStream
    Class sourceChecksumFromBinaryRevision            

    (Class sourceChecksumFromStream: Class sourceStream) = (Class sourceChecksumFromBinaryRevision)
    "

    "Created: / 26-01-2016 / 11:24:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceCodeManager
    "Return my (configured) source code manager."

    |owner|

    (owner := self owningClass) notNil ifTrue:[^ owner sourceCodeManager].

    "/ see if there is a package-specific manager
    AbstractSourceCodeManager notNil ifTrue:[
        ^ AbstractSourceCodeManager sourceCodeManagerForPackage: self package.
    ].

    ^ Smalltalk at:#SourceCodeManager "/ nil if SCM is disabled

    "
     Array sourceCodeManager
     foo_p1 sourceCodeManager
    "

    "Created: / 07-12-1995 / 13:16:46 / cg"
    "Modified: / 05-12-2006 / 22:04:26 / cg"
    "Modified (comment): / 04-08-2014 / 00:35:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceCodeManagerFromBinaryRevision

    "Returns the source code manager that should be used for
     source code access based in class's binary revision.
     If not binary revision is available, then configured source
     code manager is returned. If source code management
     is disabled or particular source code manager is not enabled,
     return nil.

     Source code manager for source access may differ from
     configured source code manager:

     - #sourceCodeManager returns the manager use has configured for
       this class using preferences

     - #sourceCodeManagerForSourceAccess is the manager used when asking
       for class source code. It compares version_XXX methods with
       class's binary revision and. When method_XXX matches the
       binary revision string, XXX source code manager is returned,
       as this class has been likely compiled from a source checked out
       using returned source code manager

    CAVEAT: Now, the code expects that the revision string is in
    format '$revision ident$SCM'. It won't work for managers that
    does not use dollar expansion. For, only CVS, SVN and Perforce
    are used so this code should work
    "

    AbstractSourceCodeManager isNil ifTrue:[^ nil]. "/ SCM package not yet loaded.


    revision isNil ifTrue:[^self sourceCodeManager].

    AbstractSourceCodeManager availableManagers do:[:mgr |
        (revision endsWith: mgr managerTypeNameShort) ifTrue:[
            ^mgr
        ]
    ].

    "binary revision is not nil and we haven't found source code manager.
     This may happen when (i) given source code manager is not available
     or (ii) source version methods are somehow corrupted.

     Let's be strict about it for now and throw and error. More relaxed
     version may simply return nil"

"/    self error:'Cannot find source code manager for source access ' ,
"/               '(manager yet not loaded or binary revision corrupted)'
"/        mayProceed: true.

    ^nil


    "
        Object sourceCodeManager
        Object sourceCodeManagerForSourceAccess

        JavaVM sourceCodeManager
        JavaVM sourceCodeManagerForSourceAccess
    "

    "Created: / 06-10-2011 / 09:33:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-08-2014 / 00:32:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subclasses
    "return a collection of the direct subclasses of the receiver"

    "/ use cached information (avoid class hierarchy search), if possible
    (subclasses isNil
    or:[ subclasses sequenceNumber ~= SubclassCacheSequenceNumber ]) ifTrue:[
	self updateAllCachedSubclasses.
	"subclasses may still be nil - obsolete classes may not be updated"
	^ subclasses ? #().
    ].
    ^ subclasses.

    "
     Class flushSubclassInfo.
     Class subclasses.
     SmallInteger subclasses
    "

    "Modified: / 06-12-2011 / 16:05:16 / cg"
!

superclass:aClass
    "set the superclass - this actually creates a new class,
     recompiling all methods for the new one. The receiving class stays
     around anonymously to allow existing instances some life.
     This may change in the future (adjusting existing instances)"

    |owner ns nm|

    "must flush caches since lookup chain changes"
    ObjectMemory flushCaches.

    "/ for correct recompilation, just create a new class ...
    "/ but care to avoid a nameSpace change, by giving my
    "/ full name and answering with Smalltalk to a nameSpace query.

    (owner := self owningClass) notNil ifTrue:[
        ns := owner.
        nm := self nameWithoutPrefix asSymbol
    ] ifFalse:[
        ns := Smalltalk.
        nm := self name
    ].

    Class classRedefinitionNotification answer:#keep do:[
        Class nameSpaceQuerySignal
            answer:ns
            do:[
                aClass
                    perform:(self definitionSelector)
                    withArguments:(Array with:nm
                                   with:(self instanceVariableString)
                                   with:(self classVariableString)
                                   with:(self sharedPoolNames asStringWith: ' ')
                                   with:(self category)).
            ]
    ]

    "Modified: / 20-06-1998 / 18:17:37 / cg"
    "Modified: / 24-06-2014 / 17:02:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withAllPrivateClasses
    "return a collection containing the receiver plus all of my private classes (if any).
     This also inclueds all private classes of private classes, recursively.
     Elements are in no particular order."

    |coll|

    coll := OrderedCollection new.
    self withAllPrivateClassesDo:[:cls | coll add:cls].
    ^ coll

    "Created: / 18-07-2011 / 09:14:38 / cg"
! !


!Class methodsFor:'adding & removing'!

removeFromSystem
    "ST-80 compatibility
     remove myself from the system"

    Smalltalk removeClass:self.
    Smalltalk removeKey:name.

    "Created: 6.2.1996 / 11:32:58 / stefan"
!

unload
    "{ Pragma: +optSpace }"

    "if the receiver was autoloaded, unload and reinstall it as
     autoloaded. Can be used to get rid of no longer needed autoloaded
     classes.
     (maybe, autoloaded classes should unload themselfes when no
      longer needed - for example, after some delay when the last instance
      is gone ...)"

    |nm newClass privateClasses|

    self wasAutoloaded ifFalse:[
	"
	 can it be done ?
	 (all of my methods must have a source)
	"
	self instAndClassSelectorsAndMethodsDo:[:sel :aMethod |
	    aMethod source isNil ifTrue:[^false].
	    aMethod hasPrimitiveCode ifTrue:[^ false].
	].
    ].

    "/ cannot unload, if non-autoloaded subclasses exist ...
    self allSubclassesDo:[:eachSubclass |
	eachSubclass wasAutoloaded ifFalse:[
	    eachSubclass isPrivate ifFalse:[
		self warn:('cannot unload ' , self name , ' (' , eachSubclass name , ' requires it)').
		^ false.
	    ]
	]
    ].

    self allSubclassesDo:[:eachSubclass |
	eachSubclass wasAutoloaded ifTrue:[
	    eachSubclass unload
	] ifFalse:[
	    eachSubclass removeFromSystem.
	]
    ].
    privateClasses := self privateClasses.
    privateClasses notEmpty ifTrue:[
	self withoutUpdatingChangesDo:[
	    privateClasses do:[:eachPrivateClass |
		eachPrivateClass removeFromSystem.
	    ].
	].
    ].
    Transcript showCR:'unloading ' , name , ' ...'.

    "/ reinstall as autoloaded
    Autoload removeClass:self.
    nm := name.
    Smalltalk at:nm put:nil.
    ObjectMemory flushInlineCaches.
    ObjectMemory flushMethodCache.
    newClass := Autoload addClass:nm inCategory:category.
    newClass notNil ifTrue:[
	newClass package:package
    ].
    Smalltalk flushCachedClasses.
    Class flushSubclassInfoFor:self.
    ^ true

    "
     Clock open.
     Clock unload.
     ClockView unload.
     Clock open
    "

    "Modified: 7.6.1996 / 09:15:05 / stefan"
    "Modified: 4.6.1997 / 14:48:02 / cg"
! !


!Class methodsFor:'changes management'!

addChangeRecordForChangeCategory
    "{ Pragma: +optSpace }"

    "add a category change"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForChangeCategory:to: with:category.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addClassDefinitionChangeFor:self
	]
    ]
!

addChangeRecordForClass:aClass
    "{ Pragma: +optSpace }"

    "add a class-definition-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForClass:to: with:aClass.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addClassDefinitionChangeFor:aClass
	]
    ]

    "Modified: / 24.1.1997 / 19:09:41 / cg"
    "Modified: / 18.3.1999 / 18:14:04 / stefan"
!

addChangeRecordForClass:aClass andNotifyChangeOf:aspect
    "writes a change record and notifies dependents."

    |namespace|

    self addChangeRecordForClass:aClass.

    aClass changed:#definition.

    namespace := aClass nameSpace.
    namespace changed:#classDefinition with:aClass.
    namespace ~~ Smalltalk ifTrue:[
	Smalltalk changed:#classDefinition with:aClass.
    ].
    namespace changed:aspect with:aClass.
    namespace ~~ Smalltalk ifTrue:[
	Smalltalk changed:aspect with:aClass.
    ].
!

addChangeRecordForClassCheckIn:aClass
    "{ Pragma: +optSpace }"

    "append a class-was-checkedIn-record to the changes file"

    |rv pkg|

    UpdateChangeFileQuerySignal query ifTrue:[
        rv := aClass revision.
        rv isNil ifTrue:[rv := '???'].
        pkg := aClass package.

        self
            writingChangeWithTimeStamp:false
            perform:#addInfoRecord:to:
            with:('checkin %1 (%2) into %3'
                    bindWith:aClass name
                    with:rv
                    with:pkg).
    ]

    "Created: / 18.11.1995 / 17:04:58 / cg"
    "Modified: / 24.1.1997 / 19:11:55 / cg"
    "Modified: / 18.3.1999 / 18:14:14 / stefan"
!

addChangeRecordForClassComment:aClass
    "{ Pragma: +optSpace }"

    "add a class-comment-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForClassComment:to: with:aClass.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addClassCommentChangeFor:aClass
	]
    ]

    "Modified: / 24.1.1997 / 19:09:59 / cg"
    "Modified: / 18.3.1999 / 18:14:23 / stefan"
!

addChangeRecordForClassContainerRemove:aClass
    "{ Pragma: +optSpace }"

    "append a container-was-removed-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self
	    writingChangeWithTimeStamp:false
	    perform:#addInfoRecord:to:
	    with:('removed source container of ' , aClass name).
    ]

    "Created: / 11.9.1996 / 15:37:19 / cg"
    "Modified: / 24.1.1997 / 19:12:05 / cg"
    "Modified: / 18.3.1999 / 18:14:31 / stefan"
!

addChangeRecordForClassFileOut:aClass
    "{ Pragma: +optSpace }"

    "append a class-was-filedOut-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self
	    writingChangeWithTimeStamp:false
	    perform:#addInfoRecord:to:
	    with:('fileOut ' , aClass name).
    ]

    "Modified: / 24.1.1997 / 19:12:14 / cg"
    "Modified: / 18.3.1999 / 18:14:36 / stefan"
!

addChangeRecordForClassInstvars:aClass
    "{ Pragma: +optSpace }"

    "add a class-instvars-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForClassInstvars:to: with:aClass.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addInstVarDefinitionChangeFor:aClass class
	]
    ]

    "Modified: / 24.1.1997 / 19:10:18 / cg"
    "Modified: / 18.3.1999 / 18:14:43 / stefan"
!

addChangeRecordForClassRemove
    "{ Pragma: +optSpace }"

    "add a class-remove-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForClassRemove:to: with:self.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addClassRemoveChange:self
	]
    ]

    "Modified: / 24.1.1997 / 19:10:25 / cg"
    "Modified: / 18.3.1999 / 18:14:53 / stefan"
!

addChangeRecordForClassRemove:oldClassName
    "{ Pragma: +optSpace }"

    "add a class-remove-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForClassRemove:to: with:self.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addClassRemoveChange:self
	]
    ]

    "Modified: / 24.1.1997 / 19:10:25 / cg"
    "Modified: / 18.3.1999 / 18:14:53 / stefan"
!

addChangeRecordForClassRename:oldName to:newName
    "{ Pragma: +optSpace }"

    "add a class-rename-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangeDo:[:aStream |
	    self addChangeRecordForClassRename:oldName to:newName to:aStream
	]
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addClassRenameChangeFrom:oldName to:newName
	]
    ]

    "Modified: / 24.1.1997 / 19:10:35 / cg"
    "Modified: / 18.3.1999 / 18:14:59 / stefan"
!

addChangeRecordForPrimitiveDefinitions:aClass
    "{ Pragma: +optSpace }"

    "add a primitiveDefinitions-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForPrimitiveDefinitions:to: with:aClass.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addPrimitiveDefinitionsChangeFor:aClass
	]
    ]

    "Modified: / 20.1.1997 / 12:36:10 / cg"
    "Modified: / 18.3.1999 / 18:15:04 / stefan"
!

addChangeRecordForPrimitiveFunctions:aClass
    "{ Pragma: +optSpace }"

    "add a primitiveFunctions-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForPrimitiveFunctions:to: with:aClass.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addPrimitiveFunctionsChangeFor:aClass
	]
    ]

    "Modified: / 20.1.1997 / 12:36:13 / cg"
    "Modified: / 18.3.1999 / 18:15:09 / stefan"
!

addChangeRecordForPrimitiveVariables:aClass
    "{ Pragma: +optSpace }"

    "add a primitiveVariables-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self writingChangePerform:#addChangeRecordForPrimitiveVariables:to: with:aClass.
    ].

    "this test allows a smalltalk without Projects/ChangeSets"
    Project notNil ifTrue:[
	UpdateChangeListQuerySignal query ifTrue:[
	    Project addPrimitiveVariablesChangeFor:aClass
	]
    ]

    "Modified: / 20.1.1997 / 12:36:16 / cg"
    "Modified: / 18.3.1999 / 18:15:14 / stefan"
!

addChangeRecordForSnapshot:aFileName
    "{ Pragma: +optSpace }"

    "add a snapshot-record to the changes file"

    UpdateChangeFileQuerySignal query ifTrue:[
	self
	    writingChangeWithTimeStamp:false
	    perform:#addChangeRecordForSnapshot:to:
	    with:aFileName.
    ]

    "Modified: / 24.1.1997 / 19:12:25 / cg"
    "Modified: / 18.3.1999 / 18:15:20 / stefan"
!

addChangeRecordForSnapshot:aFileName to:aStream
    "{ Pragma: +optSpace }"

    "add a snapshot-record to aStream"

    self addInfoRecord:('snapshot ' , aFileName asString) to:aStream

    "Modified: / 24.1.1997 / 19:11:08 / cg"
    "Modified: / 18.3.1999 / 18:15:30 / stefan"
! !

!Class methodsFor:'enumerating'!

allPrivateClassesDo:aBlock
    "evaluate aBlock on all of my private classes (if any).
     Evaluation is in no particular order."

    self allPrivateClasses do:aBlock
!

privateClassesDo:aBlock
    "evaluate aBlock on all of my (immediate) private classes (if any).
     Evaluation is in no particular order."

    self privateClasses do:aBlock
!

subclassesDo:aBlock
    "evaluate the argument, aBlock for all immediate subclasses.
     This will only enumerate globally known classes - for anonymous
     behaviors, you have to walk over all instances of Behavior."

    self subclasses do:aBlock

    "
     Collection subclassesDo:[:c | Transcript showCR:(c name)]
    "

    "Modified: / 06-12-2011 / 15:59:49 / cg"
!

withAllPrivateClassesDo:aBlock
    "evaluate aBlock on myself and all of my private classes (if any).
     This recurses into private classes of private classes.
     Evaluation is in no particular order."

    aBlock value:self.
    self allPrivateClasses do:aBlock
! !

!Class methodsFor:'fileIn interface'!

primitiveDefinitions
    "this method allows fileIn of classes with primitive code.

     It returns a CCReader which reads the next chunks and installs the
     unprocessed contents in the classes primitiveDefinitions section.
     Thus, although the definitions are NOT processed, they are still visible,
     editable and especially: not lost when filing out the class."

    ^ ClassCategoryReader class:self primitiveSpec:#primitiveDefinitions:

    "Modified: 10.2.1996 / 12:47:12 / cg"
!

primitiveFunctions
    "this method allows fileIn of classes with primitive code.

     It returns a CCReader which reads the next chunks and installs the
     unprocessed contents in the classes primitiveFunctions section.
     Thus, although the functions are NOT processed, they are still visible,
     editable and especially: not lost when filing out the class."

    ^ ClassCategoryReader class:self primitiveSpec:#primitiveFunctions:

    "Modified: 10.2.1996 / 12:47:07 / cg"
!

primitiveVariables
    "this method allows fileIn of classes with primitive code.

     It returns a CCReader which reads the next chunks and installs the
     unprocessed contents in the classes primitiveVariables section.
     Thus, although the variables are NOT processed, they are still visible,
     editable and especially: not lost when filing out the class."

    ^ ClassCategoryReader class:self primitiveSpec:#primitiveVariables:

    "Modified: 10.2.1996 / 12:47:28 / cg"
! !

!Class methodsFor:'fileOut'!

basicFileOutDefinitionOn:aStream withNameSpace:forceNameSpace
    "append an expression on aStream, which defines myself."

    self
	basicFileOutDefinitionOn:aStream
	withNameSpace:forceNameSpace
	withPackage:true

!

basicFileOutDefinitionOn:aStream withNameSpace:forceNameSpace withPackage:showPackage
    "append an expression on aStream, which defines myself."

    self class
	basicFileOutDefinitionOf:self
	on:aStream
	withNameSpace:forceNameSpace withPackage:showPackage
!

basicFileOutDefinitionOn:aStream withNameSpace:forceNameSpace withPackage:showPackage syntaxHilighting:syntaxHilighting
    "append an expression on aStream, which defines myself."

    self class
	basicFileOutDefinitionOf:self
	on:aStream
	withNameSpace:forceNameSpace
	withPackage:showPackage
	syntaxHilighting:syntaxHilighting
!

basicFileOutInstvarTypeKeywordOn:aStream
    "a helper for fileOutDefinition"

    |isVar superclass|

    superclass := self superclass.
    superclass isNil ifTrue:[
	isVar := self isVariable
    ] ifFalse:[
	"I cant remember what this is for ?"
	isVar := (self isVariable and:[superclass isVariable not])
    ].

    aStream nextPutAll:(self firstDefinitionSelectorPart).

    "Created: 11.10.1996 / 18:57:29 / cg"
!

fileOut
    "create a file 'class.st' consisting of all methods in myself in
     sourceForm, from which the class can be reconstructed (by filing in).
     If the current project is not nil, create the file in the projects
     directory. Care is taken, to not clobber any existing file in
     case of errors (for example: disk full).
     Also, since the classes methods need a valid sourcefile, the current
     sourceFile may not be rewritten."

    |dirName nm fileName|

    nm := (Smalltalk fileNameForClass:self name),'.st'.

    "
     this test allows a smalltalk to be built without Projects/ChangeSets
    "
    Project notNil ifTrue:[
	dirName := Project currentProjectDirectory
    ] ifFalse:[
	dirName := Filename currentDirectory
    ].
    fileName := (dirName asFilename construct:nm).
    fileName makeLegalFilename.

    self fileOutAs:fileName name.

"/    "
"/     add a change record; that way, administration is much easier,
"/     since we can see in that changeBrowser, which changes have
"/     already found their way into a sourceFile and which must be
"/     applied again
"/    "
"/    self addChangeRecordForClassFileOut:self

    "Modified: / 07-06-1996 / 09:14:43 / stefan"
    "Modified: / 06-10-2006 / 16:16:19 / cg"
!

fileOutAllMethodsOn:aStream
    self fileOutAllMethodsOn:aStream methodFilter:nil

    "Created: 15.10.1996 / 11:13:00 / cg"
    "Modified: 22.3.1997 / 16:12:17 / cg"
!

fileOutAllMethodsOn:aStream methodFilter:methodFilter
    |collectionOfCategories|

    collectionOfCategories := self class categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
	collectionOfCategories do:[:aCategory |
	    self class fileOutCategory:aCategory methodFilter:methodFilter on:aStream.
	    aStream cr
	]
    ].
    collectionOfCategories := self categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
	collectionOfCategories do:[:aCategory |
	    self fileOutCategory:aCategory methodFilter:methodFilter on:aStream.
	    aStream cr
	]
    ].

    self privateClassesSorted do:[:aClass |
	aClass fileOutAllMethodsOn:aStream methodFilter:methodFilter
    ].

    "Created: 15.10.1996 / 11:13:00 / cg"
    "Modified: 22.3.1997 / 16:12:17 / cg"
!

fileOutAs:filenameString
    "create a file consisting of all methods in myself in
     sourceForm, from which the class can be reconstructed (by filing in).
     The given fileName should be a full path, including suffix.
     Care is taken, to not clobber any existing file in
     case of errors (for example: disk full).
     Also, since the classes methods need a valid sourcefile, the current
     sourceFile may not be rewritten."

    |filename fileExists needRename
     mySourceFileName sameFile s mySourceFileID anySourceRef outStream savFilename|

    self isLoaded ifFalse:[
        ^ FileOutErrorSignal
            raiseRequestWith:self
                 errorString:' - will not fileOut unloaded class: ', self name
    ].

    filename := filenameString asFilename.

    "
     if file exists, copy the existing to a .sav-file,
     create the new file as XXX.new-file,
     and, if that worked rename afterwards ...
    "
    [
        fileExists := filename exists.
        fileExists ifTrue:[
            sameFile := false.

            "/ check carefully - maybe, my source does not really come from that
            "/ file (i.e. all of my methods have their source as string)

            anySourceRef := false.
            self instAndClassMethodsDo:[:m |
                m sourcePosition notNil ifTrue:[
                    anySourceRef := true
                ]
            ].

            anySourceRef ifTrue:[
                s := self sourceStream.
                s notNil ifTrue:[
                    OperatingSystem isUNIXlike ifTrue:[
                        mySourceFileID := s pathName asFilename info id.
                        sameFile := (filename info id) == mySourceFileID.
                    ] ifFalse:[
                        mySourceFileID := s pathName asFilename asAbsoluteFilename.
                        sameFile := (filename asFilename asAbsoluteFilename) = mySourceFileID.
                    ].
                    s close.
                ] ifFalse:[
                    classFilename notNil ifTrue:[
                        "
                         check for overwriting my current source file
                         this is not allowed, since it would clobber my methods source
                         file ... you have to save it to some other place.
                         This happens if you ask for a fileOut into the source-directory
                         (from which my methods get their source)
                        "
                        mySourceFileName := Smalltalk getSourceFileName:classFilename.
                        sameFile := (filenameString = mySourceFileName).
                        sameFile ifFalse:[
                            mySourceFileName notNil ifTrue:[
                                OperatingSystem isUNIXlike ifTrue:[
                                    sameFile := (filename info id) == (mySourceFileName asFilename info id)
                                ]
                            ]
                        ].
                    ]
                ].
            ].

            sameFile ifTrue:[
                ^ FileOutErrorSignal
                    raiseRequestWith:filenameString
                    errorString:(' - may not overwrite sourcefile: %1\try again after loading sources in the browser' withCRs bindWith:filenameString)
            ].

            outStream := FileStream newTemporaryIn:filename directory.
            outStream fileName accessRights:filename accessRights.
            needRename := true
        ] ifFalse:[
            "/ another possible trap: if my sourceFileName is
            "/ the same as the written one AND the new files directory
            "/ is along the sourcePath, we also need a temporary file
            "/ first, to avoid accessing the newly written file.

            self instAndClassMethodsDo:[:m |
                |mSrc mSrcFilename|

                (anySourceRef isNil and:[(mSrc := m sourceFilename) notNil]) ifTrue:[
                    mSrcFilename := mSrc asFilename.
                    (mSrcFilename baseName = filename baseName 
                     and:[mSrcFilename exists]) ifTrue:[
                        anySourceRef := mSrcFilename.
                    ]
                ]
            ].
            anySourceRef notNil ifTrue:[
                outStream := FileStream newTemporaryIn:filename directory.
                outStream fileName accessRights:anySourceRef accessRights.
                needRename := true
            ] ifFalse:[
                outStream := filename writeStream.
                needRename := false
            ]
        ].
    ] on:FileStream openErrorSignal do:[:ex|
        ^ FileOutErrorSignal
                raiseRequestWith:filename name
                errorString:(' - cannot create file:', filename name)
    ].
    self fileOutOn:outStream.
    outStream syncData; close.

    "
     finally, replace the old-file
     be careful, if the old one is a symbolic link; in this case,
     we have to do a copy ...
    "
    needRename ifTrue:[
        fileExists ifTrue:[
            savFilename := filename addSuffix:'.sav~'.
            filename renameTo:savFilename.
        ].
        outStream fileName renameTo:filename.
        fileExists ifTrue:[
            savFilename delete.
        ].
    ].

    "
     add a change record; that way, administration is much easier,
     since we can see in that changeBrowser, which changes have
     already found their way into a sourceFile and which must be
     applied again
    "
    self addChangeRecordForClassFileOut:self

    "Modified: / 07-06-1996 / 09:14:43 / stefan"
    "Created: / 16-04-1997 / 20:44:05 / cg"
    "Modified: / 04-10-2006 / 17:26:23 / cg"
!

fileOutClassInstVarDefinitionOn:aStream
    "append an expression to define my classInstanceVariables on aStream"

    self class
	fileOutClassInstVarDefinitionOn:aStream
	withNameSpace:false
!

fileOutClassInstVarDefinitionOn:aStream withNameSpace:withNameSpace
    "append an expression to define my classInstanceVariables on aStream"

    |anySuperClassInstVar|

    self isLoaded ifFalse:[
	^ self basicFileOutDefinitionOn:aStream withNameSpace:withNameSpace
    ].

    withNameSpace ifTrue:[
	self name printOn:aStream.
    ] ifFalse:[
	self printClassNameOn:aStream.
    ].
    aStream nextPutAll:' class instanceVariableNames:'''.
    self class printInstVarNamesOn:aStream indent:8.
    aStream nextPutAll:''''.

    "mhmh - good idea; saw this in SmallDraw sourcecode ..."

    anySuperClassInstVar := false.
    self allSuperclassesDo:[:aSuperClass |
	aSuperClass class instVarNames do:[:ignored | anySuperClassInstVar := true].
    ].

    aStream cr; cr; nextPut:(Character doubleQuote); cr; space.
    anySuperClassInstVar ifFalse:[
	aStream
	    nextPutLine:'No other class instance variables are inherited by this class.'.
    ] ifTrue:[
	aStream
	    nextPutLine:'The following class instance variables are inherited by this class:'.
	aStream cr.
	self allSuperclassesDo:[:aSuperClass |
	    aStream tab; nextPutAll:aSuperClass name; nextPutAll:' - '.
	    aStream nextPutLine:(aSuperClass class instanceVariableString).
	].

    ].
    aStream nextPut:(Character doubleQuote); cr.

    "Created: / 10.12.1995 / 16:31:25 / cg"
    "Modified: / 1.4.1997 / 16:00:33 / stefan"
    "Modified: / 3.2.2000 / 23:05:28 / cg"
!

fileOutCommentOn:aStream
    "append an expression on aStream, which defines my comment"

    |comment s|

    self printClassNameOn:aStream.
    aStream nextPutAll:' comment:'.
    (comment := self comment) isNil ifTrue:[
	s := ''''''
    ] ifFalse:[
	s := comment storeString
    ].
    aStream nextPutAllAsChunk:s.
    aStream nextPutChunkSeparator.
    aStream cr.
    aStream cr.

    "Modified: 21.12.1996 / 13:36:01 / cg"
!

fileOutDefinitionOn:aStream
    "append an expression on aStream, which defines myself."

    ^ self basicFileOutDefinitionOn:aStream withNameSpace:true

    "Modified: / 04-01-1997 / 20:55:18 / cg"
    "Modified: / 04-02-2014 / 16:49:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutIn:aDirectoryName
    "create a file 'class.st' consisting of all methods in self in
     directory aDirectoryName (ignoring any directory setting in
     the current project).
     This is not logged in that change file (should it be ?)."

    ^ self fileOutIn:aDirectoryName withTimeStamp:true

    "
	self fileOutIn:'/tmp'
	self fileOutIn:'/tmp/doesNotExistBla'
	self fileOutIn:'/tmp' asFilename
    "

    "Modified: / 19-09-1997 / 00:03:53 / stefan"
    "Modified: / 06-10-2006 / 16:16:13 / cg"
!

fileOutIn:aDirectoryName withTimeStamp:withTimeStamp
    "create a file 'class.st' consisting of all methods in self in
     directory aDirectoryName (ignoring any directory setting in
     the current project).
     This is not logged in that change file (should it be ?)."

    |aStream fileName|

    fileName := (Smalltalk fileNameForClass:self name),'.st'.
    [
	aStream := (aDirectoryName asFilename construct:fileName) writeStream.
    ] on:FileStream openErrorSignal do:[:ex|
	^ FileOutErrorSignal
		raiseRequestWith:fileName
		errorString:(' - cannot create file:', fileName)
    ].
    self fileOutOn:aStream withTimeStamp:withTimeStamp.
    aStream close

    "
	self fileOutIn:'/tmp'
	self fileOutIn:'/tmp/doesNotExistBla'
	self fileOutIn:'/tmp' asFilename
    "

    "Modified: / 19-09-1997 / 00:03:53 / stefan"
    "Modified: / 06-10-2006 / 16:16:13 / cg"
!

fileOutOn:aStream
    "file out my definition and all methods onto aStream"

    ^ self fileOutOn:aStream withTimeStamp:true

    "Created: 15.11.1995 / 12:53:32 / cg"
    "Modified: 3.1.1997 / 17:50:28 / cg"
!

fileOutOn:aStream withTimeStamp:stampIt
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended."

    self fileOutOn:aStream withTimeStamp:stampIt withInitialize:true

    "Modified: / 13.3.1998 / 12:23:02 / cg"
!

fileOutOn:aStream withTimeStamp:stampIt withInitialize:initIt
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended.
     If initIt is true, and the class implements a class-initialize method,
     append a corresponding doIt expression for initialization."

    self
	fileOutOn:aStream
	withTimeStamp:stampIt
	withInitialize:initIt
	withDefinition:true
	methodFilter:nil

    "Created: / 15.11.1995 / 12:53:06 / cg"
    "Modified: / 1.4.1997 / 16:01:05 / stefan"
    "Modified: / 13.3.1998 / 12:23:59 / cg"
!

fileOutOn:aStream withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended.
     If initIt is true, and the class implements a class-initialize method,
     append a corresponding doIt expression for initialization.
     The order by which the fileOut is done is used to put the version string at the end.
     Thus, if the version string is expanded (by CVS), the characterPositions of methods should not move"

    |encoder any16Bit|

    "/ check if we need UTF8 encoding
    any16Bit := self withAllPrivateClasses contains:[:cls |
                 cls instAndClassMethods contains:[:m |
                        (methodFilter isNil or:[ (methodFilter value:m) ])
                        and:[ 
                            |src|

                            src := m source.
                            src notNil and:[src containsNon7BitAscii]
                        ]]].

    any16Bit ifTrue:[
        encoder := CharacterEncoder encoderForUTF8.
    ].
    ^ self
        fileOutOn:aStream
        withTimeStamp:stampIt
        withInitialize:initIt
        withDefinition:withDefinition
        methodFilter:methodFilter
        encoder:encoder

    "Modified: / 18-07-2011 / 09:17:17 / cg"
    "Modified: / 13-04-2015 / 21:15:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutOn:outStreamArg withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter encoder:encoderOrNil
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended.
     If initIt is true, and the class implements a class-initialize method,
     append a corresponding doIt expression for initialization.
     The order by which the fileOut is done is used to put the version string at the end.
     Thus, if the version string is expanded (by CVS), the characterPositions of methods should not move"

    self class
	fileOutOn:outStreamArg
	withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition
	methodFilter:methodFilter encoder:encoderOrNil


    "Created: / 15.11.1995 / 12:53:06 / cg"
    "Modified: / 1.4.1997 / 16:01:05 / stefan"
    "Modified: / 13.3.1998 / 12:23:59 / cg"
!

fileOutPrimitiveDefinitionsOn:aStream
    "append primitive defs (if any) to aStream."

    |s|

    "
     primitive definitions - if any
    "
    (s := self primitiveDefinitionsString) notNil ifTrue:[
	aStream nextPutChunkSeparator.
	self printClassNameOn:aStream.
	aStream nextPutAll:' primitiveDefinitions';
		nextPutChunkSeparator;
		cr.
	aStream nextPutAll:s.
	aStream nextPutChunkSeparator; space; nextPutChunkSeparator; cr; cr
    ].
    (s := self primitiveVariablesString) notNil ifTrue:[
	aStream nextPutChunkSeparator.
	self printClassNameOn:aStream.
	aStream nextPutAll:' primitiveVariables';
		nextPutChunkSeparator;
		cr.
	aStream nextPutAll:s.
	aStream nextPutChunkSeparator; space; nextPutChunkSeparator; cr; cr
    ].

    "Modified: 8.1.1997 / 17:45:40 / cg"
!

fileOutPrimitiveFunctionsOn:aStream
    |s|

    "
     primitive functions - if any
    "
    (s := self primitiveFunctionsString) notNil ifTrue:[
	aStream nextPutChunkSeparator.
	self printClassNameOn:aStream.
	aStream nextPutAll:' primitiveFunctions';
		nextPutChunkSeparator;
		cr.
	aStream nextPutAll:s.
	aStream nextPutChunkSeparator; space; nextPutChunkSeparator; cr; cr
    ].
!

fileOutPrimitiveSpecsOn:aStream
    "append primitive defs (if any) to aStream."

    |s|

    "
     primitive definitions - if any
    "
    self fileOutPrimitiveDefinitionsOn:aStream.
    "
     primitive functions - if any
    "
    (s := self primitiveFunctionsString) notNil ifTrue:[
	self fileOutPrimitiveFunctionsOn:aStream
    ].

    "Modified: 8.1.1997 / 17:45:51 / cg"
! !

!Class methodsFor:'fileOut-binary'!

binaryFileOut
    "create a file 'class.cls' (in the current projects fileOut-directory),
     consisting of all methods in myself in a portable binary format.
     The methods source is saved by reference
     to the classes sourceFile if there is any.
     That sourcefile needs to be present after reload in order to be
     browsable."

    self binaryFileOutWithSourceMode:#reference

    "Modified: 5.1.1997 / 15:40:05 / cg"
!

binaryFileOutOn:aStream
    "append a binary representation of myself to aStream"

    self binaryFileOutOn:aStream sourceMode:#reference
!

binaryFileOutOn:aStream sourceMode:sourceMode
    "append a binary representation of myself to aStream in
     a portable binary format.
     The argument controls how sources are to be saved:
        #keep - include the source
        #reference - include a reference to the sourceFile
        #discard - don't save sources.

     With #reference, the sourceFile needs to be present after reload
     in order to be browsable."

    |bos|

    bos := BinaryObjectStorage onNew:aStream.
    bos sourceMode:sourceMode.
    bos nextPutClasses:(Array with:self).
    bos close.
!

binaryFileOutWithSourceMode:sourceMode
    "create a file 'class.cls' (in the current projects fileOut-directory),
     consisting of all methods in myself in a portable binary format.
     The argument controls how sources are to be saved:
        #keep - include the source
        #reference - include a reference to the sourceFile
        #discard - don't save sources.

     With #reference, the sourceFile needs to be present after reload
     in order to be browsable."

    |fileName dirName|

    fileName := (Smalltalk fileNameForClass:self name), '.cls'.

    Project notNil ifTrue:[
        dirName := Project currentProjectDirectory
    ] ifFalse:[
        dirName := '.'
    ].
    fileName := dirName asFilename construct:fileName.
    fileName makeLegalFilename.
    fileName := fileName name.
    self binaryFileOutWithSourceMode:sourceMode as:fileName.

    "Modified: / 06-10-2006 / 16:16:29 / cg"
!

binaryFileOutWithSourceMode:sourceMode as:fileNameString
    "create a file fileNameString,
     consisting of all methods in myself in a portable binary format.
     The argument controls how sources are to be saved:
        #keep - include the source
        #reference - include a reference to the sourceFile
        #discard - don't save sources.

     With #reference, the sourceFile needs to be present after reload
     in order to be browsable."

    |fileName aStream|

    fileName := fileNameString asFilename.
    fileName makeLegalFilename.

    [
        aStream := fileName newReadWriteStream.
    ] on:FileStream openErrorSignal do:[:ex|
        ^ FileOutErrorSignal
                raiseRequestWith:fileName name
                errorString:(' - cannot create file:', fileName name)
    ].

    aStream binary.
    self binaryFileOutOn:aStream sourceMode:sourceMode.
    aStream close.

    "Created: / 29.12.1998 / 21:38:38 / cg"
! !

!Class methodsFor:'fileOut-xml'!

fileOutXML
    "create a file 'class.xml' consisting of all methods in myself in
     XML sourceForm.
     If the current project is not nil, create the file in the projects
     directory. Care is taken, to not clobber any existing file in
     case of errors (for example: disk full)"

    |dirName nm fileName|

    nm := (Smalltalk fileNameForClass:self name) , '.xml'.

    "
     this test allows a smalltalk to be built without Projects/ChangeSets
    "
    Project notNil ifTrue:[
	dirName := Project currentProjectDirectory
    ] ifFalse:[
	dirName := Filename currentDirectory
    ].
    fileName := (dirName asFilename construct:nm).
    fileName makeLegalFilename.

    self fileOutXMLAs:fileName.

    "
     Class fileOutXML
    "
!

fileOutXMLAllDefinitionsOn:aStream
    "append xml expressions on aStream, which defines myself and all of my private classes."

    self fileOutXMLDefinitionOn:aStream.

    "/ here, the full nameSpace prefixes are output,
    "/ to avoid confusing stc
    "/ (which otherwise could not find the correct superclass)
    "/
    FileOutNameSpaceQuerySignal answer:true do:[
	self privateClassesSorted do:[:aClass |
	    aClass fileOutXMLAllDefinitionsOn:aStream
	]
    ].


!

fileOutXMLAllMethodsOn:aStream methodFilter:methodFilter
    |collectionOfCategories|

    collectionOfCategories := self class categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
	collectionOfCategories do:[:aCategory |
	    self class fileOutXMLCategory:aCategory methodFilter:methodFilter on:aStream.
	    aStream cr
	]
    ].
    collectionOfCategories := self categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
	collectionOfCategories do:[:aCategory |
	    self fileOutXMLCategory:aCategory methodFilter:methodFilter on:aStream.
	    aStream cr
	]
    ].

    self privateClassesSorted do:[:aClass |
	aClass fileOutXMLAllMethodsOn:aStream methodFilter:methodFilter
    ].

!

fileOutXMLAs:fileNameOrString
    "create a file consisting of all methods in myself in
     XML sourceForm.
     The given fileName should be a full path, including suffix."

    |aStream fileName|

    self isLoaded ifFalse:[
	^ FileOutErrorSignal
	    raiseRequestWith:self
		 errorString:' - will not fileOut unloaded class: ', self name
    ].

    fileName := fileNameOrString asFilename.
    [
	aStream := fileName writeStream.
    ] on:FileStream openErrorSignal do:[:ex|
	^ FileOutErrorSignal
		raiseRequestWith:fileName name
		errorString:(' - cannot create file: ', fileName name)
    ].
    self fileOutXMLOn:aStream.
    aStream close.

    "
     Class fileOutXMLAs:'test.xml'
     Class fileOutXMLAs:'/blaDoesNotExist/test.xml'
    "
!

fileOutXMLDefinitionOn:aStream
    "append an xml expression on aStream, which defines myself."

    |varNames|

    aStream nextPutLine:'<class>'.

    aStream nextPutAll:'  <name>'.
    aStream nextPutAll:(self nameWithoutPrefix).
    aStream nextPutLine:'</name>'.

    aStream nextPutAll:'  <environment>'.
    aStream nextPutAll:(self nameSpace name).
    aStream nextPutLine:'</environment>'.

    aStream nextPutAll:'  <super>'.
    aStream nextPutAll:(self theNonMetaclass superclass name).
    aStream nextPutLine:'</super>'.

    aStream nextPutAll:'  <private>'.
    aStream nextPutAll:(self isPrivate printString).
    aStream nextPutLine:'</private>'.

    aStream nextPutAll:'  <indexed-type>'.
    aStream nextPutAll:'none'.
    aStream nextPutLine:'</indexed-type>'.

    aStream nextPutAll:'  <inst-vars>'.
    varNames := self instVarNames.
    varNames size > 0 ifTrue:[
	aStream cr.
	varNames do:[:nm |
	    aStream nextPutAll:'    <name>'.
	    aStream nextPutAll:nm.
	    aStream nextPutLine:'</name>'.
	].
	aStream nextPutAll:'  '.
    ].
    aStream nextPutLine:'</inst-vars>'.

    aStream nextPutAll:'  <class-inst-vars>'.
    varNames := self class instVarNames.
    varNames size > 0 ifTrue:[
	aStream cr.
	varNames do:[:nm |
	    aStream nextPutAll:'    <name>'.
	    aStream nextPutAll:nm.
	    aStream nextPutLine:'</name>'.
	].
	aStream nextPutAll:'  '.
    ].
    aStream nextPutLine:'</class-inst-vars>'.

    aStream nextPutAll:'  <imports>'.
    aStream nextPutAll:''.
    aStream nextPutLine:'</imports>'.

    aStream nextPutAll:'  <category>'.
    aStream nextPutAll:self category.
    aStream nextPutLine:'</category>'.

    aStream nextPutLine:'</class>'.

    self classVarNames do:[:nm |
	aStream nextPutLine:'<static>'.
	aStream nextPutAll:' <name>'.
	aStream nextPutAll:nm.
	aStream nextPutLine:'</name>'.
	aStream nextPutAll:' <environment>'.
	aStream nextPutAll:self name.
	aStream nextPutLine:'</environment>'.
	aStream nextPutLine:'</static>'.
    ].
!

fileOutXMLOn:aStream
    "WARNING: untested first version. Not for general use (yet)
     file out my definition and all methods onto aStream in XML format."

    self
	fileOutXMLOn:aStream
	withTimeStamp:true
	withInitialize:true
	withDefinition:true
	methodFilter:nil

!

fileOutXMLOn:aStream withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter
    "WARNING: untested first version. Not for general use (yet)
     file out my definition and all methods onto aStream in XML format.
     If stampIt is true, a timeStamp comment is prepended.
     If initIt is true, and the class implements a class-initialize method,
     append a corresponding doIt expression for initialization.
     The order by which the fileOut is done is used to put the version string at the end.
     Thus, if the version string is expanded (by CVS), the characterPositions of methods should not move"

    |collectionOfCategories copyrightMethod copyrightText comment meta|

    self isLoaded ifFalse:[
        ^ FileOutErrorSignal
            raiseRequestWith:self
                 errorString:' - will not fileOut unloaded class: ', self name
    ].

    meta := self class.

    aStream nextPutLine:'<?xml version="1.0"?>'.
    aStream nextPutLine:'<st-source>'.

    "
     if there is a copyright method, add a copyright element at the beginning,
     taking the string from the copyright method.
     We cannot do this unconditionally - that would lead to my copyrights
     being put on your code ;-).
     On the other hand: I want every file created by myself to have the
     copyright string at the beginning be preserved .... even if the
     code was edited in the browser and filedOut.
    "
    (copyrightMethod := meta compiledMethodAt:#copyright) notNil ifTrue:[
        "
         get the copyright methods source,
         and insert at beginning.
        "
        copyrightText := copyrightMethod source.
        copyrightText isNil ifTrue:[
            "
             no source available - trigger an error
            "
            FileOutErrorSignal
                raiseRequestWith:' - no source for class: '.
            ^ self
        ].
        "
         strip off the selector-line
        "
        copyrightText := copyrightText asCollectionOfLines asStringCollection.
        copyrightText := copyrightText copyFrom:2 to:(copyrightText size).
        [copyrightText last isEmpty] whileTrue:[
            copyrightText := copyrightText copyButLast:1.
        ].
        (copyrightText first = '"') ifTrue:[
            (copyrightText last = '"') ifTrue:[
                copyrightText := copyrightText copyFrom:2 to:(copyrightText size - 1).
            ]
        ].
        copyrightText := copyrightText asString.

        aStream nextPutAll:'<copyright>'.
        copyrightText printXmlTextQuotedOn:aStream.
        aStream nextPutLine:'</copyright>'.
    ].

    stampIt ifTrue:[
        "/
        "/ first, a timestamp
        "/
        aStream nextPutAll:'<time-stamp>'.
        Smalltalk timeStampString printXmlTextQuotedOn:aStream.
        aStream nextPutLine:'</time-stamp>'.
    ].

    withDefinition ifTrue:[
        "/
        "/ then the definition
        "/
        self fileOutXMLAllDefinitionsOn:aStream.
        "/
        "/ a comment - if any
        "/
        (comment := self comment) notNil ifTrue:[
            aStream nextPutLine:'<comment>'.
            aStream nextPutAll:'<class-id>'.
            aStream nextPutAll:(self name).
            aStream nextPutLine:'</class-id>'.
            aStream nextPutLine:'</comment>'.
        ].
        "/
        "/ primitive definitions - if any
        "/
"/        self fileOutPrimitiveSpecsOn:aStream.
    ].

    "/
    "/ methods from all categories in metaclass (i.e. class methods)
    "/ EXCEPT: the version method is placed at the very end, to
    "/         avoid sourcePosition-shifts when checked out later.
    "/         (RCS expands this string, so its size is not constant)
    "/
    collectionOfCategories := meta categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            meta fileOutXMLCategory:aCategory methodFilter:methodFilter on:aStream.
        ]
    ].

    "/
    "/ methods from all categories in myself
    "/
    collectionOfCategories := self categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            self fileOutXMLCategory:aCategory methodFilter:methodFilter on:aStream.
        ]
    ].

    "/
    "/ any private classes' methods
    "/
    self privateClassesSorted do:[:aClass |
        aClass fileOutXMLAllMethodsOn:aStream methodFilter:methodFilter
    ].


    initIt ifTrue:[
        "/
        "/ optionally an initialize message
        "/
        (meta includesSelector:#initialize) ifTrue:[
            aStream nextPutLine:'<initialize>'.
            aStream nextPutAll:'<class-id>'.
            aStream nextPutAll:(self name).
            aStream nextPutLine:'</class-id>'.
            aStream nextPutLine:'</initialize>'.
        ]
    ].

    aStream nextPutLine:'</st-source>'.

    "
     Class
        fileOutXMLOn:'test.xml' asFilename writeStream
        withTimeStamp:true
        withInitialize:true
        withDefinition:true
        methodFilter:nil
    "
! !


!Class methodsFor:'printOut'!

htmlDocumentation
    <resource: #obsolete>
    self obsoleteMethodWarning:'use HTMLDocGenerator htmlDocOf:'.

    ^ HTMLDocGenerator htmlDocOf:self

    "Created: 22.3.1997 / 14:18:23 / cg"
!

printClassVarNamesOn:aStream indent:indent
    "print the class variable names indented and breaking at line end"

    self printNameArray:(self classVarNames) on:aStream indent:indent
!

printFullHierarchyOn:aStream indent:indent
    "print myself and all subclasses on aStream.
     recursively calls itself to print subclasses.
     Can be used to print hierarchy on the printer."

    |nm|

    nm := self name.
    aStream spaces:indent; bold; nextPutAll:nm; normal; nextPutAll:' ('.
    self printInstVarNamesOn:aStream indent:(indent + nm size + 2).
    aStream nextPutLine:')'.

    (self subclasses sort:[:a :b | a name < b name]) do:[:aSubclass |
	aSubclass printFullHierarchyOn:aStream indent:(indent + 2)
    ]

    "|printStream|
     printStream := Printer new.
     Object printFullHierarchyOn:printStream indent:0.
     printStream close"

    "Modified: 13.12.1996 / 14:13:06 / cg"
!

printOutDefinitionOn:aPrintStream
    "print out my definition"

    |comment s superclass|

    aPrintStream nextPutAll:'class                '; bold; nextPutLine:self name; normal.
    aPrintStream nextPutAll:'superclass           '.
    superclass := self superclass.
    superclass isNil ifTrue:[
	s := 'Object'
    ] ifFalse:[
	s := superclass name
    ].
    aPrintStream nextPutLine:s.

    aPrintStream nextPutAll:'instance Variables   '.
    self printInstVarNamesOn:aPrintStream indent:21.
    aPrintStream cr.

    aPrintStream nextPutAll:'class Variables      '.
    self printClassVarNamesOn:aPrintStream indent:21.
    aPrintStream cr.

    category notNil ifTrue:[
	aPrintStream nextPutAll:'category             ';
		     nextPutLine:(category printString).
    ].

    (comment := self comment) notNil ifTrue:[
	aPrintStream cr; nextPutLine:'comment:'; italic; nextPutLine:comment; normal
    ]

    "Created: 10.12.1995 / 16:30:47 / cg"
    "Modified: 9.11.1996 / 00:13:37 / cg"
    "Modified: 1.4.1997 / 16:01:26 / stefan"
!

printOutOn:aPrintStream
    "print out all methods on aPrintStream which should be a printStream"

    |collectionOfCategories|

    self printOutDefinitionOn:aPrintStream.
    aPrintStream cr.
    collectionOfCategories := self class categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
	aPrintStream nextPutLine:'class protocol'.
	aPrintStream cr.
	collectionOfCategories do:[:aCategory |
	    self class printOutCategory:aCategory on:aPrintStream
	]
    ].
    collectionOfCategories := self categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
	aPrintStream nextPutLine:'instance protocol'.
	aPrintStream cr.
	collectionOfCategories do:[:aCategory |
	    self printOutCategory:aCategory on:aPrintStream
	]
    ]

    "Modified: / 25.11.1998 / 12:40:31 / cg"
!

printOutProtocolOn:aPrintStream
    "{ Pragma: +optSpace }"

    |collectionOfCategories|

    self printOutDefinitionOn:aPrintStream.
    aPrintStream cr.
    collectionOfCategories := self class categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
	aPrintStream nextPutLine:'class protocol'.
	aPrintStream cr.
	collectionOfCategories do:[:aCategory |
	    self class printOutCategoryProtocol:aCategory on:aPrintStream
	]
    ].
    collectionOfCategories := self categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
	aPrintStream nextPutLine:'instance protocol'.
	aPrintStream cr.
	collectionOfCategories do:[:aCategory |
	    self printOutCategoryProtocol:aCategory on:aPrintStream
	]
    ]

    "Modified: / 25.11.1998 / 12:40:38 / cg"
!

printSharedPoolNamesOn:aStream indent:indent
    "print the pool names indented and breaking at line end"

    self printNameArray:(self sharedPoolNames) on:aStream indent:indent

    "Modified: / 18-01-2011 / 17:56:16 / cg"
!

storeOn:aStream
    "append my name only - expects class to be there, when restoring"

    aStream nextPutAll:self name
! !

!Class methodsFor:'private-accessing'!

attributes
    "return the extra class attributes or nil"

    attributes isNil ifTrue:[^ nil].
    ^ self classAttributes
!

attributes:aClassAttributesObject
    "set the extra class attributes"

    self classAttributes:aClassAttributesObject
!

classAttributes
    "return the extra class attributes or create them if nil.
     Notice that the stc-compiler is too stupid to generate instances of ClassAttributes directly;
     therefore, it generates arrays which are converted here, when we first access the attribute."

    attributes isNil ifTrue:[
	attributes := ClassAttributes new.
    ] ifFalse:[
	attributes isArray ifTrue:[
	    attributes := ClassAttributes new fromSTCPrimitiveArray:attributes.
	].
    ].
    ^ attributes
!

classAttributes:aClassAttributesObject
    "set the extra class attributes"

    attributes := aClassAttributesObject
!

flushSubclasses
    subclasses := nil
!

getAttribute:aKey
    "get an attribute (by symbolic key)"

    "{ Pragma: +optSpace }"

    attributes isNil ifTrue:[ ^ nil].
    ^ self classAttributes valueFor:aKey

    "Modified: / 23-09-2011 / 10:23:45 / cg"
!

getSourceChunkAttribute:aKey
    "{ Pragma: +optSpace }"

    |pos stream string|

    pos := self getAttribute:aKey.

    "the attribute is either a string, or an integer specifying the
     position within the classes sourcefile ..."

    pos isNumber ifTrue:[
"/        classFilename notNil ifTrue:[
            stream := self sourceStream.
            stream notNil ifTrue:[
                stream position:pos.
                string := stream nextChunk.
                stream close.
                ^ string
            ].
"/        ].
        ^ nil
    ].

    ^ pos
!

setAttribute:key to:aValue
    "{ Pragma: +optSpace }"

    self classAttributes perform:key asMutator with:aValue
!

setName:aString
    "set the classes name - be careful, it will be still
     in the Smalltalk dictionary - under another key.
     This is NOT for general use - see renameTo:"

    environment := nil.
    name := aString

    "Created: 1.4.1997 / 15:46:01 / stefan"
!

setPrimitiveDefinitions:aString
    "{ Pragma: +optSpace }"

    "set the primitiveDefinition string (no change notifications)"

    ^ self setAttribute:#primitiveDefinitions to:aString
!

setPrimitiveFunctions:aString
    "{ Pragma: +optSpace }"

    "set the primitiveFunction string (no change notifications)"

    ^ self setAttribute:#primitiveFunctions to:aString
!

setPrimitiveVariables:aString
    "{ Pragma: +optSpace }"

    "set the primitiveVariable string (no change notifications)"

    ^ self setAttribute:#primitiveVariables to:aString
!

setSharedPoolNames:aStringOrCollection
    "{ Pragma: +optSpace }"

    "set the sharedPools string (no change notifications)"

    ^ self setAttribute:#sharedPools to:aStringOrCollection

    "Created: / 18-01-2011 / 20:41:09 / cg"
!

setSubclasses:aCollection
    subclasses := aCollection

    "Created: / 28-04-2010 / 08:48:49 / cg"
!

updateAllCachedSubclasses
    |subclassesPerClass seqNr makeNewSet|

    makeNewSet := [Set new].

    subclassesPerClass := Dictionary new.
    Smalltalk allClassesDo:[:each |
	|cls superclass|

	cls := each theNonMetaclass.
	(superclass := each superclass) notNil ifTrue:[
	    (subclassesPerClass at:superclass ifAbsentPut:makeNewSet) add:cls
	].
	subclassesPerClass at:cls ifAbsentPut:makeNewSet.
    ].

    SubclassCacheSequenceNumber isNil ifTrue:[
	SubclassCacheSequenceNumber := 0.
    ].
    seqNr := SubclassCacheSequenceNumber.
    subclassesPerClass keysAndValuesDo:[:cls :subclasses |
	|coll|

	coll := ArrayWithSequenceNumberValidation withAll:subclasses.
	coll sequenceNumber:seqNr.
	cls setSubclasses:coll.
    ].

    "
     Class updateAllCachedSubclasses
     Array subclasses
    "

    "Created: / 28-04-2010 / 08:47:20 / cg"
! !

!Class methodsFor:'private-changes management'!

addChangeRecordForChangeCategory:category to:aStream
    "{ Pragma: +optSpace }"

    "append a category change record to aStream"

    self printClassNameOn:aStream.
    aStream nextPutAll:' category:'.
    category storeOn:aStream.
    aStream nextPutChunkSeparator.

    "Created: 3.12.1995 / 13:43:33 / cg"
    "Modified: 3.12.1995 / 14:10:34 / cg"
!

addChangeRecordForClass:aClass to:aStream
    "{ Pragma: +optSpace }"

    "append a class-definition-record to aStream"

    aClass isLoaded ifTrue:[
	aClass basicFileOutDefinitionOn:aStream withNameSpace:true.
	aStream nextPutChunkSeparator.
    ]

    "Created: 3.12.1995 / 13:57:44 / cg"
    "Modified: 3.12.1995 / 14:11:26 / cg"
!

addChangeRecordForClassComment:aClass to:aStream
    "{ Pragma: +optSpace }"

    "append a class-comment-record to aStream"

    aClass fileOutCommentOn:aStream.

    "Modified: 4.3.1996 / 16:49:08 / cg"
!

addChangeRecordForClassInstvars:aClass to:aStream
    "{ Pragma: +optSpace }"

    "append an instvars-record to aStream"

    aClass class fileOutClassInstVarDefinitionOn:aStream withNameSpace:true.
    aStream nextPutChunkSeparator.
!

addChangeRecordForClassRemove:oldClass to:aStream
    "{ Pragma: +optSpace }"

    "append a class-remove-record to aStream"

    aStream
	nextPutAll:'Smalltalk removeClass:';
	nextPutAll:oldClass name;
	nextPutChunkSeparator.
!

addChangeRecordForClassRename:oldName to:newName to:aStream
    "{ Pragma: +optSpace }"

    "append a class-rename-record to aStream"

    aStream
	nextPutAll:'Smalltalk renameClass:';
	nextPutAll:oldName;
	nextPutAll:' to:''';
	nextPutAll:newName;
	nextPutAll:'''';
	nextPutChunkSeparator.

    "Modified: / 01-06-2012 / 09:44:04 / cg"
!

addChangeRecordForPrimitiveDefinitions:aClass to:aStream
    "{ Pragma: +optSpace }"

    "append a primitiveDefinitions-record to aStream"

    aStream nextPutAll:aClass name; nextPutLine:' primitiveDefinitions:''';
	    nextPutAll:(aClass primitiveDefinitionsString storeString copyFrom:2).
    aStream nextPutChunkSeparator.

    "Modified: 9.11.1996 / 00:09:54 / cg"
!

addChangeRecordForPrimitiveFunctions:aClass to:aStream
    "{ Pragma: +optSpace }"

    "append a primitiveFunctions-record to aStream"

    aStream nextPutAll:aClass name; nextPutLine:' primitiveFunctions:''';
	    nextPutAll:(aClass primitiveFunctionsString storeString copyFrom:2).
    aStream nextPutChunkSeparator.

    "Modified: 9.11.1996 / 00:10:02 / cg"
!

addChangeRecordForPrimitiveVariables:aClass to:aStream
    "{ Pragma: +optSpace }"

    "append a primitiveVariables-record to aStream"

    aStream nextPutAll:aClass name; nextPutLine:' primitiveVariables:''';
	    nextPutAll:(aClass primitiveVariablesString storeString copyFrom:2).
    aStream nextPutChunkSeparator.

    "Modified: 9.11.1996 / 00:10:10 / cg"
! !

!Class methodsFor:'queries'!

canHaveExtensions
    "return true, if this class allows extensions from other packages.
     Private classes, namespaces and projectDefinitions don't allow this"

    ^ self isPrivate not

    "
     Smalltalk allClasses select:[:each | each canHaveExtensions not]
    "

    "Created: / 30-08-2006 / 15:27:53 / cg"
!

classResources
    self isPrivate ifTrue:[
	^ self owningClass classResources
    ].
    ^ ResourcePack for:self cached:true.

    "Modified: / 18-09-2006 / 20:37:16 / cg"
!

defaultCategoryForUncategorizedClasses
    "used only when the short scripting class creation messages are used"

    ^ DefaultCategoryForUncategorizedClasses ? 'Uncategorized classes'.
!

defaultCategoryForUndeclaredClasses
    ^ DefaultCategoryForUndeclaredClasses ? '* undeclared classes *'
!

extensions
    "return a collection of extension-methods (both class and inst) from any other package, 
     or empty if there are none.
     Unassigned methods are ignored"

    |classPackage defaultPkg|

    classPackage := self package.
    defaultPkg := PackageId noProjectID.
    ^ self methodsForWhich:[:mthd | mthd package ~= classPackage and:[ mthd package ~= defaultPkg ]]

    "
     CType extensions
     Rectangle extensions
     Rectangle hasExtensions
     Object extensions
     Object hasExtensions
    "

    "Created: / 12-10-2006 / 18:29:51 / cg"
    "Modified: / 05-03-2007 / 17:12:04 / cg"
!

extensionsFrom:aPackageID
    "return the set of extension-methods (both class and inst) from the given package."

    aPackageID = self package ifTrue:[^ #() ].
    ^ self methodsForWhich:[:mthd | mthd package = aPackageID]

    "
     CType extensionsFrom:#'bosch:dapasx'
     Rectangle extensionsFrom:#'bosch:dapasx/support'
     Rectangle extensions
     Class extensions
     Class extensionsFrom:#'stx:libboss'
    "

    "Created: / 07-08-2006 / 22:02:15 / fm"
    "Modified: / 06-03-2007 / 11:54:53 / cg"
!

hasExtensions
    "return true, if there are methods in the receiver, which belong to
     a different package (i.e. package of class ~= package of method).
     Those are class extensions, which must be treated specially when checking classes
     into the sourceCode repository. (extensions are stored separate).
     Unassigned extensions are ignored here (i.e. as yet unpackaged changes)"

    |clsPkg defaultPkg|

    defaultPkg := PackageId noProjectID.
    clsPkg := self package.
    self instAndClassMethodsDo:[:mthd |
        |mthdPkg|
        (((mthdPkg := mthd package) ~= clsPkg) and:[ mthdPkg ~= defaultPkg ]) ifTrue:[^ true ].
    ].
    ^ false

    "
     Time millisecondsToRun:[
        Smalltalk allClasses select:[:each | each hasExtensions]
     ].   

     Dictionary
        withAssociations:
            (Smalltalk allClasses
                select:[:each | each hasExtensions]
                thenCollect:[:each | each -> each extensions])
    "

    "Modified: / 05-03-2007 / 17:06:20 / cg"
!

hasExtensionsFrom:aPackageID
    "return true, if there are methods in the receiver, which belong to
     the package with aPackageID (i.e. package of class ~= package of method).
     Those are class extensions, which must be treated specially when checking classes
     into the sourceCode repository. (extensions are stored separate)"

    |clsPkg|

    clsPkg := self package.
    aPackageID = clsPkg ifTrue:[^ false].

    self instAndClassMethodsDo:[:mthd |
	mthd package = aPackageID ifTrue:[ ^ true].
    ].
    ^ false

    "
     Smalltalk allClasses
	select:[:each | each hasExtensionsFrom:'stx:goodies/refactyBrowser']
     Smalltalk allClasses
	select:[:each | each hasExtensionsFrom:'stx:libboss']
    "

    "Modified: / 06-03-2007 / 11:55:39 / cg"
!

hasUnassignedExtensions
    "return true, if there are methods in the receiver, which have not been
     assigned to any package."

    ^ self unassignedExtensions notEmpty

    "
     Time millisecondsToRun:[
        Smalltalk allClasses select:[:each | each hasUnassignedExtensions]
     ]. 190 130 260

     Dictionary
        withAssociations:
            (Smalltalk allClasses
                select:[:each | each hasUnassignedExtensions]
                thenCollect:[:each | each -> each unassignedExtensions])
    "
!

hasUnsavedChanges
    "return true, if there are changes for this class in the current changeSet"

    ^ ChangeSet current includesChangeForClassOrMetaclassOrPrivateClassOf:self

    "
     Class hasUnsavedChanges
     Array hasUnsavedChanges
    "
!

isBrowserStartable
    "return true, if this is an application class,
     which can be started from the browser"

    ^ self isVisualStartable or:[self isStartableWithStart or:[ self isStartableWithMain ]]

    "Created: / 06-10-2006 / 11:34:28 / cg"
!

isClass
    "return true, if the receiver is some kind of class
     (a real class, not just behavior);
     true is returned here - the method is redefined from Object.
     See also Behavior>>isBehavior."

    ^ true

    "
     Point isClass
     1 isClass
     Behavior new isBehavior
     Behavior new isClass
     Class new isBehavior
     Class new isClass
    "
!

isJavaScriptClass
    ^ self class isJavaScriptMetaclass
!

isStartableWithMain
    "return true, if this is an application class,
     which can be started via #main / #main:"

    ^ (self theMetaclass includesSelector:#main)
     or:[ self theMetaclass includesSelector:#main: ]

    "Created: / 2.11.2001 / 09:37:01 / cg"
    "Modified: / 2.11.2001 / 09:48:05 / cg"
!

isStartableWithStart
    "return true, if this is an application class,
     which can be started via #start"

    ^ self theMetaclass includesSelector:#start
!

methodsForWhich:aFilter
    "return a collection of methods (both class and inst) for which aFilter returns true"

    |matching|

    self instAndClassMethodsDo:[:mthd |
        (aFilter value:mthd) ifTrue:[
            matching isNil ifTrue:[
                matching := OrderedCollection new.
            ].
            matching add:mthd
        ].
    ].
    ^ matching ? #()
!

methodsWithAnyResource:aResourceSymbolCollection
    |methods|

    methods := OrderedCollection new.

    self withAllSuperclassesDo:[:eachClass|
        eachClass instAndClassMethodsDo:[:eachMethod|
            (eachMethod hasAnyResource:aResourceSymbolCollection) ifTrue:[
                methods add:eachMethod.
            ].
        ].
    ].

    ^ methods

    "
        ApplicationModel methodsWithAnyResource:#(fontSpec)
    "
!

packageDirectory
    "return the packageDirectory of this classes package.
     That is usually the directory where my source is, and where package specific additional
     files (bitmaps, resources etc.) are found."

    ^ Smalltalk getPackageDirectoryForPackage:self package.

    "
      self packageDirectory
      stx_libbasic3 packageDirectory
      Array packageDirectory
    "
!

rootsOfTheWorld
    "return a collection of classes which have a nil superclass"

    |set|

    set := IdentitySet new.
    Smalltalk allClassesDo:[:aClass |
	aClass superclass isNil ifTrue:[set add:aClass]
    ].
    ^ set asOrderedCollection

    "
     Class rootsOfTheWorld
    "

    "Modified: 18.4.1997 / 20:55:34 / cg"
!

unassignedExtensions
    "return a collection of methods which have not been assigned to any
     any package, or empty if there are none."

    |noPackage|

    noPackage := PackageId noProjectID.
    ^ self methodsForWhich:[:mthd | mthd package == noPackage ]

    "
     SchemeBoolean unassignedExtensions
    "
!

wasAutoloaded
    "return true, if this class came into the system via an
     autoload; false otherwise.
     This is not an attribute of the class, but instead remembered in
     Autoload. The interface here is for your convenience."

    ^ Autoload wasAutoloaded:self

    "Modified: 21.3.1996 / 16:27:09 / cg"
!

whichClassDefinesClassVar:aVariableName
    "return the class which defines the class variable named aVariableName."

    |cls|

    cls := self.
    [cls notNil] whileTrue:[
        (cls classVarNames includes:aVariableName) ifTrue:[ ^ cls].
        cls := cls superclass
    ].
    ^ nil

    "
     StandardSystemView whichClassDefinesClassVar:'ErrorSignal'
     StandardSystemView whichClassDefinesClassVar:'Foo'
    "
!

whichPoolDefinesPoolVar:aVariableName
    "return the shared which defines the class variable named aVariableName or nil."

    self sharedPools do:[:eachPool |
        (eachPool classVariableNames includes:aVariableName) ifTrue:[ ^ eachPool].
    ].
    ^ nil

    "
     ZipArchiveConstants classVariableNames
     ZipArchive sharedPools
     ZipArchive whichPoolDefinesPoolVar:'ECREC_SIZE'
    "
! !

!Class methodsFor:'renaming'!

makePrivateIn:newOwner
    "make a private class of newOwner from the receiver;
     the receiver must be a public class.
     Returns the new private class."

    |sel newClass|

    self owningClass notNil ifTrue:[
	^ self
    ].

    sel := self definitionSelectorPrivate.

    newClass := self superclass
	perform:sel
	withArguments:(Array
			with:(self nameWithoutPrefix asSymbol)
			with:(self instanceVariableString)
			with:(self classVariableString)
			with:''
			with:newOwner).

    "/ copy over methods ...
    ClassBuilder copyInvalidatedMethodsFrom:self class for:newClass class.
    ClassBuilder copyInvalidatedMethodsFrom:self for:newClass.
    newClass class recompileInvalidatedMethods.
    newClass recompileInvalidatedMethods.

    newOwner changed:#newClass with:newClass.
    Smalltalk changed:#newClass with:newClass.

    self removeFromSystem.
    ^ newClass

    "Modified: / 29.5.1998 / 19:03:49 / cg"
!

makePublic
    "make a public class from the receiver.
     The receiver must be a private class.
     Returns the new public class."

    ^ self makePublicIn:Smalltalk
!

makePublicIn:newNameSpace
    "make a public class from the receiver.
     The receiver must be a private class.
     Returns the new public class."

    |sel owner baseName newName newClass|

    owner := self topOwningClass.
    owner isNil ifTrue:[^ self].

    "/ first, create the public class ...
    sel := self definitionSelector.

    Class nameSpaceQuerySignal answer:newNameSpace
    do:[
	baseName := self nameWithoutPrefix.
"/        (newNameSpace isNil or:[newNameSpace == Smalltalk]) ifTrue:[
"/            newName := baseName
"/        ] ifFalse:[
"/            newName := newNameSpace name , '::' , baseName
"/        ].
	newName := baseName.

	newClass := self superclass
	    perform:sel
	    withArguments:(Array
			    with:(newName asSymbol)
			    with:(self instanceVariableString)
			    with:(self classVariableString)
			    with:''
			    with:(owner category)).

	"/ copy over methods ...
	ClassBuilder copyInvalidatedMethodsFrom:self class for:newClass class.
	ClassBuilder copyInvalidatedMethodsFrom:self for:newClass.
	newClass class recompileInvalidatedMethods.
	newClass recompileInvalidatedMethods.
    ].

    owner changed:#newClass with:newClass.
    Smalltalk changed:#newClass with:newClass.
    (newNameSpace notNil and:[newNameSpace ~~ Smalltalk]) ifTrue:[
	newNameSpace changed:#newClass with:newClass.
    ].

    self removeFromSystem.

    ^ newClass

    "Created: / 23-06-1997 / 13:28:52 / cg"
    "Modified: / 04-07-2006 / 16:27:12 / cg"
!

renameTo:newName
    "change the name of the class. This does not write a change record."

    <resource:#obsolete>

    |oldSym newSym|

    "/ the code below is obsolete - it does not deal with
    "/ classVariables, private classes and does not
    "/ recompile other classes in order to care for namespace
    "/ changes.
    "/ Please use Smalltalk>>renameClass:to:,
    "/ which deals with all of that.
    self obsoleteMethodWarning:'use Smalltalk>>renameClass:to:'.

    oldSym := name asSymbol.
    newSym := newName asSymbol.
    self setName:newSym.

    Smalltalk at:oldSym put:nil.
    Smalltalk removeKey:oldSym.             "26.jun 93"
    Smalltalk at:newSym put:self.

    "Created: / 1.4.1997 / 15:27:53 / stefan"
    "Modified: / 31.7.1998 / 15:21:34 / cg"
! !

!Class methodsFor:'signature checking'!

classinstSizeFromSignature:aSignature
    "for checking class compatibility: return some number based on
     the classinstSize from a signature key (not always the real classinstsize)."

    ^ (aSignature bitShift:-7) bitAnd:7

    "
     Class classinstSizeFromSignature:16r100. 2
     Class classinstSizeFromSignature:16r180. 3
    "

    "Created: 1.4.1997 / 15:23:01 / stefan"
!

instNameKeyFromSignature:aSignature
    "for checking class compatibility: return a number based on the
     names and order of the instance variables from a signature key."

    ^ (aSignature bitShift:-14) bitAnd:16rFFFF

    "
     Point instNameKeyFromSignature:Point signature.
     Association instNameKeyFromSignature:Association signature.
    "

    "Created: 1.4.1997 / 15:23:07 / stefan"
!

instSizeFromSignature:aSignature
    "for checking class compatibility: return the some number based on
     the instSize from a signature key (not always the real instSize)."

    ^ aSignature bitAnd:16r7F

    "
     Class instSizeFromSignature:Point signature.
     Class instSizeFromSignature:Association signature.
     Class instSizeFromSignature:Dictionary signature.
     Class instSizeFromSignature:16r100.
    "

    "Created: 1.4.1997 / 15:23:15 / stefan"
!

instTypeFromSignature:aSignature
    "for checking class compatibility: return some number based on
     the instType (i.e. variableBytes/Pointers etc.) from a signature key."

    ^ (aSignature bitShift:-10) bitAnd:(Class maskIndexType)

    "
     Class instTypeFromSignature:Object signature.
     Class instTypeFromSignature:Array signature.
     Class instTypeFromSignature:String signature.
     Class instTypeFromSignature:OrderedCollection signature.
    "

    "Created: 1.4.1997 / 15:23:20 / stefan"
!

signature
    "return a signature number - this number is useful for a quick
     check for changed classes, and is done in the binary-object loader,
     and the dynamic class loader.
     Do NOT change the algorithm here - others may depend on it.
     Also, the algorithm may change - so never interpret the returned value
     (if at all, use the access #XXXFromSignature: methods)"

    |value   "{ Class: SmallInteger }"
     nameKey "{ Class: SmallInteger }" |

    signature notNil ifTrue:[^ signature].

    value := self flags bitAnd:(Class maskIndexType).
    value := (value bitShift:3) + ((self class instSize - Class instSize) bitAnd:7).
    value := (value bitShift:7) + (self instSize bitAnd:16r7F).

    nameKey := 0.
    self allInstVarNames do:[:name |
	nameKey := nameKey bitShift:1.
	(nameKey bitAnd:16r10000) ~~ 0 ifTrue:[
	    nameKey := nameKey bitXor:1.
	    nameKey := nameKey bitAnd:16rFFFF.
	].
	nameKey := (nameKey + (name at:1) codePoint) bitAnd:16rFFFF.
    ].
    value := value + (nameKey bitShift:14).
    signature := value.
    ^ value

    "
     Array signature
     ByteArray signature
     View signature
    "

    "Created: 1.4.1997 / 15:23:24 / stefan"
! !

!Class methodsFor:'source management'!

binaryRevision
    "return the revision-ID from which the class was stc-compiled;
     nil if its an autoloaded or filedIn class.
     If a classes binary is up-to-date w.r.t. the source repository,
     the returned string is the same as the one returned by #revision."

    |owner manager info c|

    (owner := self owningClass) notNil ifTrue:[^ owner binaryRevision].

    revision notNil ifTrue:[
        c := revision first.
        c == $$ ifTrue:[
            manager := self sourceCodeManagerFromBinaryRevision.
            manager notNil ifTrue:[
                info := manager revisionInfoFromString:revision.
            ].
            info isNil ifTrue:[^ '0'].
            ^ (info revision) ? '0'.
        ].
        c isDigit ifFalse:[
            ^ '0'
        ].
    ].

    ^ revision

    "
     Object binaryRevision
     Object class binaryRevision
    "

    "
     to find all classes which are not up-to-date:

     |classes|

     classes := Smalltalk allClasses
                    select:[:cls | cls binaryRevision notNil and:[cls binaryRevision ~= cls revision]].
     SystemBrowser browseClasses:classes title:'classes which are not up-to-date'
    "

    "Created: / 07-12-1995 / 10:58:47 / cg"
    "Modified: / 01-04-1997 / 23:33:01 / stefan"
    "Modified: / 22-10-2008 / 20:37:05 / cg"
    "Modified: / 23-01-2012 / 19:38:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

binaryRevisionString
    "return the revision-ID from which the class was stc-compiled;
     nil if its an autoloaded or filedIn class.
     If a classes binary is up-to-date w.r.t. the source repository,
     the returned string is the same as the one returned by #revision."

    ^ revision

    "
     Object binaryRevisionString
     Object class binaryRevisionString
    "

    "
     to find all classes which are not up-to-date:

     |classes|

     classes := Smalltalk allClasses
		    select:[:cls | cls binaryRevision notNil and:[cls binaryRevision ~= cls revision]].
     SystemBrowser browseClasses:classes title:'classes which are not up-to-date'
    "

    "Modified: / 01-04-1997 / 23:33:01 / stefan"
    "Modified: / 22-10-2008 / 20:37:05 / cg"
    "Created: / 01-07-2011 / 10:55:03 / cg"
!

currentSourceStream
    "return an open stream on the current source of the receiver"

    |theWriteStream theCurrentSource|

    theWriteStream := String writeStream.
    Method flushSourceStreamCache.
    self fileOutOn:theWriteStream withTimeStamp:false.
    theCurrentSource := theWriteStream contents asString.
    theWriteStream close.
    ^ theCurrentSource

    "Modified: 15.10.1996 / 18:59:40 / cg"
    "Modified: 1.4.1997 / 14:33:12 / stefan"
!

findVersionMethod
    "{ Pragma: +optSpace }"

    "return my revision method. Either this is the sourceCodeManager-specific versionMethod,
     or the fallBack (for backward compatibility)"

    |owner|

    (owner := self owningClass) notNil ifTrue:[^ owner findVersionMethod].
    ^ self findVersionMethodOfManager:self sourceCodeManagerFromBinaryRevision

    "
     Smalltalk allClassesDo:[:cls |
        Transcript show:cls name; show:' -> '; showCR:cls findVersionMethod
     ].

     Number findVersionMethod
     FileDirectory findVersionMethod
     Metaclass findVersionMethod
     Class findVersionMethod
    "

    "Modified: / 19-04-2011 / 13:30:42 / cg"
    "Modified: / 19-07-2013 / 22:11:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

findVersionMethodOfManager:aSourceCodemanagerOrNil
    "{ Pragma: +optSpace }"

    "return my revision method. Either this is the sourceCodeManager-specific versionMethod,
     or the fallBack (for backward compatibility)"

    |owner cls meta allVersionMethodNames nameOfVersionMethodForManager nameOfOldVersionMethod
     tryVersionFromVersionMethod prefixOfVersionMethodSelector|

    (owner := self owningClass) notNil ifTrue:[^ owner findVersionMethodOfManager:aSourceCodemanagerOrNil].

    tryVersionFromVersionMethod :=
	[:versionMethodsName |
	    |aVersionMethod val|

	    aVersionMethod := meta compiledMethodAt:versionMethodsName.
	    (aVersionMethod notNil and:[aVersionMethod isExecutable]) ifTrue:[
		"/
		"/ if it's a method returning the version string,
		"/ that's the returned value
		"/
		val := cls perform:versionMethodsName.
		val isString ifTrue:[^ aVersionMethod].
	    ].
	].

    meta := self theMetaclass.
    cls := self theNonMetaclass.

    prefixOfVersionMethodSelector :=
	AbstractSourceCodeManager notNil
	    ifTrue: [AbstractSourceCodeManager prefixOfVersionMethodSelector ]
	    ifFalse:[ 'version_' ].     "/ sigh - for standalone apps without libbasic3

    allVersionMethodNames := meta methodDictionary keys select:[:sel | sel startsWith:prefixOfVersionMethodSelector].

    aSourceCodemanagerOrNil notNil ifTrue:[
	nameOfVersionMethodForManager := aSourceCodemanagerOrNil nameOfVersionMethodInClasses.
	(allVersionMethodNames includes:nameOfVersionMethodForManager) ifTrue:[
	    tryVersionFromVersionMethod value:nameOfVersionMethodForManager
	].

	"/ only trust the oldVersion method, iff there is no other scv-version
	"/ (i.e. do not misuse an svn-checked-in #version as a version_cvs)
	(allVersionMethodNames copyWithout:nameOfVersionMethodForManager) notEmpty ifTrue:[
	    ^ nil
	].
    ].

    nameOfOldVersionMethod := self nameOfOldVersionMethod.
    tryVersionFromVersionMethod value:nameOfOldVersionMethod.

    ^ nil.

    "
     Smalltalk allClassesDo:[:cls |
	Transcript show:cls name; show:' -> '; showCR:cls findVersionMethod
     ].

     Number findVersionMethod
     FileDirectory findVersionMethod
     Metaclass findVersionMethod
     Class findVersionMethod
    "

    "Created: / 19-04-2011 / 13:30:05 / cg"
!

localSourceStreamFor:sourceFile
    "return an open stream on a local sourcefile, nil if that is not available"

    |fileName info module dir fn package packageDir zar entry|

    "/
    "/ old: look in 'source/<filename>'
    "/ this is still kept in order to find user-private
    "/ classes in her currentDirectory.
    "/
    fileName := Smalltalk getSourceFileName:sourceFile.
    fileName notNil ifTrue:[
	^ fileName asFilename readStreamOrNil.
    ].

    (package := self package) notNil ifTrue:[
	"/ newest scheme ...
	packageDir := Smalltalk findPackageDirectoryForPackage:package.
	packageDir notNil ifTrue:[
	    "/ present there ?
	    packageDir := packageDir asFilename.
	    (fn := packageDir construct:sourceFile) exists ifTrue:[
		^ fn readStreamOrNil.
	    ].

	    "/ a source subdirectory ?
	    fn := (packageDir construct:'source') construct:sourceFile.
	    fn exists ifTrue:[
		^ fn readStreamOrNil.
	    ].

	    "/ a zip-file ?
	    fn := (packageDir construct:'source.zip').
	    fn exists ifTrue:[
		zar := ZipArchive oldFileNamed:fn.
		zar notNil ifTrue:[
		    entry := zar extract:sourceFile.
		    entry notNil ifTrue:[
			^ entry asString readStream
		    ]
		]
	    ]
	].

	"/ will vanish ...
	(package includes:$:) ifTrue:[
	    package := package asString copyReplaceAll:$: with:$/
	] ifFalse:[
	    package := 'stx/' , package
	].
	fileName := Smalltalk getSourceFileName:(package , '/' , sourceFile).
	fileName notNil ifTrue:[
	    ^ fileName asFilename readStreamOrNil.
	].
	(package startsWith:'stx/') ifTrue:[
	    fileName := Smalltalk getSourceFileName:((package copyFrom:5) , '/' , sourceFile).
	    fileName notNil ifTrue:[
		^ fileName asFilename readStreamOrNil.
	    ]
	]
    ].

    "/
    "/ new: look in 'source/<module>/<package>/<filename>
    "/ this makes the symbolic links to (or copy of) the source files
    "/ obsolete.
    info := self packageSourceCodeInfo.
    info notNil ifTrue:[
	module := info at:#module ifAbsent:nil.
	module notNil ifTrue:[
	    dir := info at:#directory ifAbsent:nil.
	    dir notNil ifTrue:[
		fn := (module asFilename construct:dir) construct:sourceFile.
		fileName := Smalltalk getSourceFileName:(fn name).
		fileName notNil ifTrue:[
		    ^ fileName asFilename readStreamOrNil.
		].

		"/ brand new: look for source/<module>/package.zip
		"/ containing an entry for <filename>

		fn := (module asFilename construct:dir) withSuffix:'zip'.
		fileName := Smalltalk getSourceFileName:(fn name).
		fileName notNil ifTrue:[
		    zar := ZipArchive oldFileNamed:fileName.
		    zar notNil ifTrue:[
			entry := zar extract:sourceFile.
			entry notNil ifTrue:[
			    ^ entry asString readStream
			]
		    ]
		].

		"/ and also in source/source.zip ...

		fileName := Smalltalk getSourceFileName:'source.zip'.
		fileName notNil ifTrue:[
		    zar := ZipArchive oldFileNamed:fileName.
		    zar notNil ifTrue:[
			entry := zar extract:sourceFile.
			entry notNil ifTrue:[
			    ^ entry asString readStream
			]
		    ]
		].
	    ]
	]
    ].
    ^ nil

    "Modified: / 18.7.1998 / 22:53:19 / cg"
!

nameOfOldVersionMethod
    "this is now more or less obsolete, as multiple sourceCodeManagers might use
     different version_XXX methods. Currently, we keep this for backward compatibility.
     As classes are checked in, using the new source code manager, these methods will
     be removed and replaced by version_XXX methods (one per manager)."

    ^ #version

    "Modified: / 19-04-2011 / 13:42:18 / cg"
!

nameOfVersionMethod
    <resource: #obsolete>
    "this is now more or less obsolete, as multiple sourceCodeManagers might use
     different version_XXX methods. Keep this for backward compatibility.
     As classes are checked in using the new source code manager, these methods will
     be removed and replaced by version_XXX methods (one per manager)."

    self obsoleteMethodWarning.
    ^ self nameOfOldVersionMethod

    "Modified: / 19-04-2011 / 13:42:18 / cg"
!

packageSourceCodeInfo
    "{ Pragma: +optSpace }"

    "return the sourceCodeInfo, which defines the module and the subdirectory
     in which the receiver class was built.
     This info is extracted from the package id (which is added to stc-compiled classes).
     This method is to be obsoleted soon, since the same info is now found
     in the versionString.

     The info returned consists of a dictionary
     filled with (at least) values at: #module, #directory and #library.
     If no such info is present in the class, nil is returned.
     (this happens with autoloaded and filed-in classes)
     Auotloaded classes set their package from the revisionInfo, if present.

     By convention, this info is encoded in the classes package
     string (which is given as argument to stc) as the last word in parentheses.
     The info consists of 1 to 3 subcomponents, separated by colons.
     The first defines the classes module (i.e. some application identifier),
     the second defines the subdirectory within that module, the third
     defines the name of the class library.
     If left blank, the module info defaults to 'stx',
     the directory info defaults to library name.
     The library name may not be left blank.
     (this is done for backward compatibility,)

     For example:
        '....(libbasic)'                         -> module: stx directory: libbasic library: libbasic
        '....(stx:libbasic)'                     -> module: stx directory: libbasic library: libbasic
        '....(stx:foo:libbfoo)'                  -> module: stx directory: foo library: libfoo
        '....(aeg:libIECInterface)'              -> module: aeg directory: libIECInterface library:libIECInterface
        '....(stx:goodies/persistency:libdbase)' -> module: stx directory: goodies/persistency library:libdbase

     The way how the sourceCodeManager uses this to find the source location
     depends on the scheme used. For CVS, the module is taken as the -d arg,
     while the directory is prepended to the file name.
     Other schemes may do things differently - these are not yet specified.

     Caveat:
        Encoding this info in the package string seems somewhat kludgy.
    "

    |owner sourceInfo packageString idx1 idx2
     moduleString directoryString libraryString components component1 component2 dirComponents mgr|

    (owner := self owningClass) notNil ifTrue:[^ owner packageSourceCodeInfo].

    package isNil ifTrue:[^ nil].
    package == (PackageId noProjectID) ifTrue:[^ nil].

    packageString := package asString.
    idx1 := packageString lastIndexOf:$(.
    idx1 ~~ 0 ifTrue:[
        idx2 := packageString indexOf:$) startingAt:idx1+1.
        idx2 ~~ 0 ifTrue:[
            sourceInfo := packageString copyFrom:idx1 + 1 to:idx2 - 1
        ]
    ] ifFalse:[
        sourceInfo := packageString
    ].

    sourceInfo isNil ifTrue:[^ nil].
    components := sourceInfo asCollectionOfSubstringsSeparatedBy:$:.
    components isEmpty ifTrue:[
"/        moduleString := 'stx'.
"/        directoryString := libraryString := ''.
        ^ nil
    ].

    component1 := components at:1.
    components size == 1 ifTrue:[
        "/ a single name given - the module becomes 'stx' or
        "/ the very first directory component (if such a module exists).
        "/ If the component includes slashes, its the directory
        "/ otherwise the library.
        "/
        dirComponents := Filename components:component1.
        (dirComponents size > 1
        and:[(mgr := self sourceCodeManager) notNil
        and:[mgr checkForExistingModule:dirComponents first]]) ifTrue:[
            moduleString := dirComponents first.
            directoryString := libraryString := (Filename fromComponents:(dirComponents copyFrom:2)) asString.
        ] ifFalse:[
            "/ non-existing; assume directory under the stx package.
            moduleString := 'stx'.
            (component1 startsWith:'stx/') ifTrue:[
                component1 := component1 copyFrom:5
            ].
            directoryString := libraryString := component1.
        ].

        (libraryString includes:$/) ifTrue:[
            libraryString := libraryString asFilename baseName
        ]
    ] ifFalse:[
        moduleString := component1.
        component2 := components at:2.
        directoryString := component2.
        components size == 2 ifTrue:[
            "/ two components - assume its the module and the directory;
            "/ the library is assumed to be named after the directory
            "/ except, if slashes are in the name; then the libraryname
            "/ is the last component.
            "/
            libraryString := component2.
            (libraryString includes:$/) ifTrue:[
                libraryString := libraryString asFilename baseName
            ]
        ] ifFalse:[
            "/ all components given
            libraryString := components at:3.
        ]
    ].

    libraryString isEmpty ifTrue:[
        directoryString notEmpty ifTrue:[
            libraryString := directoryString asFilename baseName
        ].
        libraryString isEmpty ifTrue:[
            "/ lets extract the library from the liblist file ...
            libraryString := Smalltalk libraryFileNameOfClass:self.
            libraryString isNil ifTrue:[^ nil].
        ]
    ].

    moduleString isEmpty ifTrue:[
        moduleString := 'stx'.
    ].
    directoryString isEmpty ifTrue:[
        directoryString := libraryString.
    ].

    ^ IdentityDictionary
        with:(#module->moduleString)
        with:(#directory->directoryString)
        with:(#library->libraryString)

    "
     Object packageSourceCodeInfo
     View packageSourceCodeInfo
     Model packageSourceCodeInfo
     BinaryObjectStorage packageSourceCodeInfo
     MemoryMonitor packageSourceCodeInfo
     ClockView packageSourceCodeInfo
    "

    "Created: 4.11.1995 / 20:36:53 / cg"
    "Modified: 19.9.1997 / 10:42:25 / cg"
!

projectDirectory
    "return my package's/project's directory - that's where the sources, binaries, classLib,
     resources etc. are typically found."

    ^ Smalltalk projectDirectoryForClass:self

    "
     Object projectDirectory
     View projectDirectory
     ApplicationModel projectDirectory
    "
!

resourceDirectory
    "return the directory where my resource file is supposed to live.
     Here, take the package and assume that a directory named 'resources' exists
     in my package directory.
     Return nil, if no such directory exists."

    ^ Smalltalk resourceDirectoryForPackage:(self package)

    "
     Object resourceDirectory
     View resourceDirectory
     ApplicationModel resourceDirectory
    "

    "Modified: / 19-10-2006 / 23:08:37 / cg"
!

resourcePackName
    "return the name which is used as the fileNameBase of my resource file.
     Notice, that this will undergo the same name translation process as
     done with class-source file names. (see ResourcePack).
     The default here is the classes name - this can be redefined in classes
     which want to use another classes resources (NewLauncher -> Launcher)."

    ^ self name

    "Created: / 29-01-1998 / 22:20:12 / cg"
    "Modified: / 19-10-2006 / 23:11:57 / cg"
!

resourcePackage
    "return the package from where my resources are loaded.
     By default, that is the classes package."

    ^ self package
!

revision
    "return the revision-ID of the class which corresponds to the
     scm-version-id of the source to which this class is equivalent.
     The class's default source code manager is asked here.
     Initially, this is the same as #binaryRevision; however, once changes have
     been checked into a source repository, the binary continues to remain based upon
     the old revision, while logically, the class has the new (checked-in) revision.
     To check if a source corresponds to a compiled binary, compare this
     ID with the one returned by #binaryRevision."

    ^ self revisionOfManager:self sourceCodeManager

    "
     Object revision
    "

    "Created: / 11-11-1995 / 14:27:20 / cg"
    "Modified: / 26-03-1997 / 00:14:00 / stefan"
    "Modified: / 04-09-2011 / 11:03:59 / cg"
!

revisionDateString
    "return the revision-Date of the class as a string.
     This is extracted from the version string."

    |info|

    info := self revisionInfo.
    info notNil ifTrue:[
	^ (info date) ? '??/??/??'
    ].
    ^ '??/??/??'

    "
     Object revisionDateString
    "

    "Created: / 23-04-1997 / 12:29:21 / cg"
    "Modified: / 22-10-2008 / 20:38:25 / cg"
!

revisionInfo
    "return an object filled with revision info.
     This extracts the relevant info from the revisionString.
     The revisionInfo contains all or a subset of:
	binaryRevision - the revision upon which the binary of this class is based
	revision       - the revision upon which the class is based logically
			  (different, if a changed class was checked in, but not yet recompiled)
	user           - the user who checked in the logical revision
	date           - the date when the logical revision was checked in
	time           - the time when the logical revision was checked in
	fileName       - the classes source file name
	repositoryPath - the classes source container
    "

    ^ self revisionInfoOfManager:self sourceCodeManagerFromBinaryRevision

    "
     Object revisionString
     Object revisionInfo
     Image revisionInfo
    "

    "Created: / 11-11-1995 / 14:27:20 / cg"
    "Modified: / 26-03-1997 / 00:13:17 / stefan"
    "Modified: / 19-04-2011 / 13:41:24 / cg"
!

revisionInfoOfManager:aSourceCodemanagerOrNil
    "return an object filled with revision info for a given scm manager (or the default manager, if nil)
     This extracts the relevant info from the revisionString.
     The revisionInfo contains all or a subset of:
        binaryRevision - the revision upon which the binary of this class is based
        revision       - the revision upon which the class is based logically
                          (different, if a changed class was checked in, but not yet recompiled)
        user           - the user who checked in the logical revision
        date           - the date when the logical revision was checked in
        time           - the time when the logical revision was checked in
        fileName       - the classes source file name
        repositoryPath - the classes source container
    "

    |vsnString info|

    aSourceCodemanagerOrNil notNil ifTrue:[
        vsnString := self revisionStringOfManager:aSourceCodemanagerOrNil.
    ].
    vsnString isNil ifTrue:[
        "/ cg: I am not sure if this is the correct thing to do, iff the passed in scm-manager
        "/ was not nil. It will return another manager's revision info. Please check.
        vsnString := self revisionStringOfManager:nil.
        vsnString isNil ifTrue:[^ nil].
    ].

    aSourceCodemanagerOrNil notNil ifTrue:[
        info := aSourceCodemanagerOrNil revisionInfoFromString:vsnString inClass:self
    ] ifFalse:[
        info := Class revisionInfoFromString:vsnString.
    ].
    info notNil ifTrue:[
        info binaryRevision:self binaryRevision.
    ].
    ^ info

    "
     Object revisionString
     Object revisionInfo
     Image revisionInfo
    "

    "Modified: / 26-03-1997 / 00:13:17 / stefan"
    "Created: / 19-04-2011 / 13:41:13 / cg"
!

revisionOfManager:aSourceCodemanagerOrNil
    "return the revision-ID of the class which corresponds to the
     scm-version-id of the source to which this class is equivalent.
     The passed in source code manager (or the default manager, if nil) is asked here.
     Initially, this is the same as #binaryRevision; however, once changes have
     been checked into a source repository, the binary continues to remain based upon
     the old revision, while logically, the class has the new (checked-in) revision.
     To check if a source corresponds to a compiled binary, compare this
     ID with the one returned by #binaryRevision."

    |info|

    info := self revisionInfoOfManager:aSourceCodemanagerOrNil.
    info notNil ifTrue:[
        ^ info revision
    ].
    ^ nil "/ ^ self binaryRevision

    "
     Object revision
    "

    "Modified: / 26-03-1997 / 00:14:00 / stefan"
    "Modified (comment): / 01-07-2011 / 10:57:16 / cg"
    "Created: / 04-09-2011 / 11:03:34 / cg"
!

revisionString
    "{ Pragma: +optSpace }"

    "return my revision string; that one is extracted from the
     classes #version method. Either this is a method returning that string,
     or it's a comment-only method and the comment defines the version.
     If the receiver is unloaded, or the source is not accessible,
     or no such method exists, then nil is returned."

    ^ self revisionStringOfManager:nil

    "
     Smalltalk allClassesDo:[:cls |
        Transcript show:cls name; show:' -> '; showCR:cls revisionString
     ].

     Number revisionString
     FileDirectory revisionString
     Metaclass revisionString
    "

    "Created: / 29-10-1995 / 19:28:03 / cg"
    "Modified: / 01-04-1997 / 23:37:25 / stefan"
    "Modified: / 07-02-2001 / 18:03:39 / ps"
    "Modified: / 19-04-2011 / 13:38:07 / cg"
!

revisionStringOfManager:aSourceCodeManagerOrNil
    "{ Pragma: +optSpace }"

    "return my revision string; that one is extracted from the
     classes #version method. Either this is a method returning that string,
     or it's a comment-only method and the comment defines the version.
     If the receiver is unloaded, or the source is not accessible,
     or no such method exists, then nil is returned."

    |owner versionMethod|

    (owner := self owningClass) notNil ifTrue:[^ owner revisionString].

    versionMethod := self findVersionMethodOfManager:aSourceCodeManagerOrNil.
    versionMethod notNil ifTrue:[
        ^ versionMethod valueWithReceiver:(self theNonMetaclass) arguments:#()
    ].
    ^ nil.

    "
     Smalltalk allClassesDo:[:cls |
        Transcript show:cls name; show:' -> '; showCR:cls revisionString
     ].

     Number revisionString
     FileDirectory revisionString
     Metaclass revisionString
    "

    "Modified: / 01-04-1997 / 23:37:25 / stefan"
    "Modified: / 07-02-2001 / 18:03:39 / ps"
    "Created: / 19-04-2011 / 13:37:42 / cg"
!

setBinaryRevision:aString
    "set the revision-ID.
     This should normally not be done in the running system, as the source-manager
     will need this to validate sourcefiles being correct for a given binary
     (and optionally: extracting the required sourcefile from the rcs source)"

    revision := aString

    "Created: 9.12.1995 / 17:05:17 / cg"
!

setPackageFromRevision
    "{ Pragma: +optSpace }"

    "set my package from the info found in the revisionString if present.
     This is used to set some useful packageInfo after autoloading
     (otherwise, autoloaded classes/methods would go into your current
      package - which is probably not a good idea)"

    |info mgr dir lib mod p|

    self owningClass notNil ifTrue:[^ self].

    mgr := self sourceCodeManager.
    mgr notNil ifTrue:[
	info := mgr sourceInfoOfClass:self.

	info notNil ifTrue:[
	    mod := info at:#module ifAbsent:nil.    "/ stx, aeg, <your-organization>
	    dir := info at:#directory ifAbsent:nil. "/ libbasic, libtool ...
	    lib := info at:#library ifAbsent:dir.

	    p := ''.
	    mod notNil ifTrue:[
"/            mod ~= 'stx' ifTrue:[
		    p := p , mod
"/            ]
	    ].
	    dir notNil ifTrue:[
		p notEmpty ifTrue:[p := p , ':'].
		p := p , dir.
	    ] ifFalse:[
		lib notNil ifTrue:[
		    p notEmpty ifTrue:[p := p , ':'].
		    p := p , lib.
		].
	    ].
	    (p notEmpty and:[p ~= package]) ifTrue:[
"/            package notNil ifTrue:[
"/                (name , ': changing packageID from ''' , package , ''' to ''' , p , '''') infoPrintCR.
"/            ].
		package := p.

		self methodDictionary do:[:aMethod |
		    aMethod package isNil ifTrue:[
			aMethod setPackage:p
		    ]
		]
	    ].
	].
    ].
    ^ self

    "
     MemoryMonitor autoload.
     MemoryMonitor setPackageFromRevision
    "

    "Modified: / 12-06-1996 / 11:49:31 / stefan"
    "Modified: / 12-09-2006 / 14:15:47 / cg"
!

sourceFileSuffix
    ^ self class sourceFileSuffix
!

sourceStream
    "return an open stream on my sourcefile, nil if that is not available"

    |owner source stream|

    (owner := self owningClass) notNil ifTrue:[^ owner sourceStream].

    classFilename notNil ifTrue:[
	source := classFilename
    ] ifFalse:[
	source := (Smalltalk fileNameForClass:self) , '.st'
    ].
    stream := self sourceStreamFor:source.
    stream notNil ifTrue:[
	"/ see if its utf8 encoded...
	stream := EncodedStream decodedStreamFor:stream.
    ].
    ^ stream.
!

sourceStreamFor:source
    "return an open stream on a sourcefile, nil if that is not available"

    |owner sourceStream sourceCodeManager validated guessedFileName sep mod dir|

    (owner := self owningClass) notNil ifTrue:[^ owner sourceStreamFor:source].
    validated := false.

    "/
    "/ if there is no SourceCodeManager,
    "/ or TryLocalSourceFirst is true,
    "/ look in standard places first
    "/
    "JV@2011-12-08: 
        (i) first check TryLocalSourceFirst, this avoids useless call to
            #sourceCodeManagerFromBinaryRevision when TryLocalSourceFirst is
            set (for whatever reason)
        (ii) do NOT ask source code manager during system startup - source code
            managers are not configured anyway!! Also, avoids hangups during
            startup when CVSROOT is set, but server is unreacheable.
    CAVEAT: When somebody modifies the code after compilation and methods
        are recompiled during startup (for whatever reason), a bad code may
        used, compilation may fail. However, it may happen anyway as SCM's
        are not yet configured so the system may use wrong one. Moreover,
        the source from which the class is compiled may not be the one in
        repository. I (JV) think this is a good, less confusing compromise.
    "
    (TryLocalSourceFirst == true 
        or:[Smalltalk isInitialized not
            or: [(sourceCodeManager := self sourceCodeManagerFromBinaryRevision) isNil]])
                ifTrue:[
                    sourceStream := self localSourceStreamFor:source.
                ].

    sourceStream isNil ifTrue:[
        "/ mhmh - still no source file.
        "/ If there is a SourceCodeManager, ask it to acquire the
        "/ source for my class and return an open stream on it.
        "/ If that one does not know about the source, look in
        "/ standard places.

        sourceCodeManager notNil ifTrue:[
            classFilename ~= source ifTrue:[
                package notNil ifTrue:[
                    sep := package indexOfAny:'/\:'.
                    sep ~~ 0 ifTrue:[
                        | sourceFileName |


                        mod := package copyTo:sep - 1.
                        dir := package copyFrom:sep + 1.
                        sourceFileName := (source includes: Filename separator) ifTrue:[ source asFilename baseName ] ifFalse:[ source ].
                        sourceStream := sourceCodeManager streamForClass:nil fileName:sourceFileName revision:(self binaryRevision) directory:dir module:mod cache:true.
                    ]
                ].
            ].
            sourceStream isNil ifTrue:[
                classFilename isNil ifTrue:[
                    guessedFileName := (Smalltalk fileNameForClass:self) , '.st'.
                ].
                source asFilename baseName = (classFilename ? guessedFileName) asFilename baseName ifTrue:[
                    sourceStream := sourceCodeManager getSourceStreamFor:self.
                ]
            ].
            sourceStream notNil ifTrue:[
                (self validateSourceStream:sourceStream) ifFalse:[
                    ('Class [info]: repositories source for "%1" is invalid.' bindWith:self theNonMetaclass name) errorPrintCR.
                    sourceStream close.
                    sourceStream := nil
                ] ifTrue:[
                    validated := true.
                ].
            ].
        ]
    ].

    sourceStream isNil ifTrue:[
        "/
        "/ hard case - there is no source file for this class
        "/ (in the source-dir-path).
        "/

        "/
        "/ look if my binary is from a dynamically loaded module,
        "/ and, if so, look in the modules directory for the
        "/ source file.
        "/
        ObjectFileLoader notNil ifTrue:[
            ObjectFileLoader loadedObjectHandlesDo:[:h |
                |f classes|

                sourceStream isNil ifTrue:[
                    (classes := h classes) notEmptyOrNil ifTrue:[
                        (classes includes:self) ifTrue:[
                            f := h pathName.
                            f := f asFilename directory.
                            f := f construct:source.
                            f exists ifTrue:[
                                sourceStream := f readStreamOrNil.
                            ].
                        ].
                    ].
                ]
            ].
        ].
    ].

    "/
    "/ try along sourcePath
    "/
    sourceStream isNil ifTrue:[
        sourceStream := self localSourceStreamFor:source.
    ].

    "/
    "/ final chance: try current directory
    "/
    sourceStream isNil ifTrue:[
        sourceStream := source asFilename readStreamOrNil.
    ].

    (sourceStream notNil and:[validated not]) ifTrue:[
        (self validateSourceStream:sourceStream) ifFalse:[
            ('Class [warning]: source for "%1" is invalid or stripped. Take care.' bindWith:self theNonMetaclass name) errorPrintCR.
            sourceStream close.
            sourceStream := nil
        ].
    ].
"/    (sourceStream notNil and:[sourceStream isFileStream]) ifTrue:[
"/        guessedFileName notNil ifTrue:[
"/            self setClassFilename:(aStream pathName asFilename baseName).
"/        ]
"/    ].
    ^ sourceStream

    "
     Object sourceStream
     Clock sourceStream
     Autoload sourceStream
    "

    "Created: / 10-11-1995 / 21:05:13 / cg"
    "Modified: / 22-04-1998 / 19:20:50 / ca"
    "Modified: / 05-11-2001 / 16:36:30 / cg"
    "Modified: / 07-09-2016 / 09:01:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateVersionMethodFor:newRevisionString
    "{ Pragma: +optSpace }"

    "helper for the checkin procedure.
     Update my #version method, to now return newRevisionString."

    "/ for backward compatibility - however, please change callers...
    ^ self sourceCodeManager updateVersionMethodOf:self for:newRevisionString
!

validateSourceStream:aStream
    "check if aStream really contains my source.
     This is done by checking the version method's return value
     against the version string as contained in the version method.
     This helps to detect mangled source code."

    |cls cannotCheckReason versionMethod info
     versionFromCode versionFromSource oldPos pos src rev|

    ValidateSourceOnlyOnce == true ifTrue:[
        ValidatedClasses notNil ifTrue:[
            (ValidatedClasses includes:self) ifTrue:[
                Transcript showCR:'trust validated'.
                ^ true
            ].
        ] ifFalse:[
            ValidatedClasses := WeakIdentitySet new.
        ].
    ].

    cls := self theNonMetaclass.

    cannotCheckReason := nil.

    (cls sourceChecksumFromBinaryRevision) = (cls sourceChecksumFromStream: aStream) ifTrue:[ 
        ^ true.
    ].

    versionMethod := self findVersionMethod.
    versionMethod isNil ifTrue:[
        cannotCheckReason := 'no valid version method'.
    ] ifFalse:[
        "/
        "/ if its a method returning the string,
        "/ that's the returned value
        "/
        versionFromCode := versionMethod valueWithReceiver:cls arguments:#().
        versionFromCode isString ifFalse:[
            cannotCheckReason := 'version method does not return a string'
        ].
    ].

    versionMethod notNil ifTrue:[
        pos := versionMethod sourcePosition.
        pos isInteger ifFalse:[
            "/ mhmh - either no version method,
            "/ or updated due to a checkin.
            "/ in any case, this should be a good source.

            ^ true.
            "/ cannotCheckReason := 'no source position for version-method'
        ]
    ].

    cannotCheckReason notNil ifTrue:[
        ('Class [warning]: ' , cannotCheckReason , ' in ' , self name) infoPrintCR.
        'Class [info]: cannot validate source; trusting source' infoPrintCR.
        ^ true
    ].

    oldPos := aStream position.
    Stream positionErrorSignal handle:[:ex |
        'Class [info]: position error when accessing source' infoPrintCR.
        ^ false
    ] do:[
        aStream position:pos-1.
    ].
    src := aStream nextChunk.
    aStream position:oldPos.

    (src isEmptyOrNil) ifTrue:[
        'Class [info]: empty source for version-method' infoPrintCR.
        ^ false
    ].
    (src startsWith:'version') ifFalse:[
        'Class [info]: corrupted source (source does not correspond to binary)' infoPrintCR.
        ^ false
    ].

    versionFromSource := Class revisionStringFromSource:src.
    versionFromSource = versionFromCode ifTrue:[
        ValidatedClasses notNil ifTrue:[ ValidatedClasses add:self ].
        ^ true
    ].

    versionFromSource isNil ifTrue:[
        'Class [info]: version-from source is nil' infoPrintCR.
        ^ false
    ].

    "/ mhmh - check my binary version ...

    info := Class revisionInfoFromString:versionFromSource.
    info notNil ifTrue:[
        rev := info at:#revision.
        rev = self binaryRevision ifTrue:[
            ValidatedClasses notNil ifTrue:[ ValidatedClasses add:self ].
            ^ true
        ].
    ].
    'Class [info]: source-version is different from binaryRevision' infoPrintCR.
    ^ false

    "Modified: / 29-09-2011 / 14:29:55 / cg"
    "Modified: / 26-01-2016 / 12:32:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMethodTemplateForSourceCodeManager:aSourceCodeManager

    ^self class versionMethodTemplateForSourceCodeManager:aSourceCodeManager

    "Created: / 16-08-2009 / 12:57:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Class::ArrayWithSequenceNumberValidation methodsFor:'accessing'!

sequenceNumber
    ^ sequenceNumber
!

sequenceNumber:something
    sequenceNumber := something.
! !

!Class::ArrayWithSequenceNumberValidation methodsFor:'checking'!

checkIfValidFor:aSequenceNumber
    ^ aSequenceNumber ~= sequenceNumber

    "Created: / 06-12-2011 / 16:01:16 / cg"
! !

!Class::ClassAttributes class methodsFor:'documentation'!

documentation
"
    Instances hold additional attributes of a class.
    Currently, these are primitive definitions and sharedPools information.
    As these are seldom needed, they are only present as object in some classes
    thus saving us from mostly empty additional slots in the class object itself for most classes
"
! !

!Class::ClassAttributes methodsFor:'accessing'!

fGuid
    ^ fGuid

    "Created: / 23-09-2011 / 10:28:25 / cg"
!

fGuid:something
    fGuid := something.

    "Created: / 23-09-2011 / 10:28:28 / cg"
!

localSelectors
    ^ localSelectors
!

localSelectors:something
    localSelectors := something.
!

primitiveDefinitions
    ^ primitiveDefinitions
!

primitiveDefinitions:something
    primitiveDefinitions := something.
!

primitiveFunctions
    ^ primitiveFunctions
!

primitiveFunctions:something
    primitiveFunctions := something.
!

primitiveVariables
    ^ primitiveVariables
!

primitiveVariables:something
    primitiveVariables := something.
!

projectDirectory
    ^ projectDirectory
!

projectDirectory:something
    projectDirectory := something.
!

sharedPools
    ^ sharedPools
!

sharedPools:something
    sharedPools := something.
!

traitComposition
    ^ traitComposition
!

traitComposition:something
    traitComposition := something.
!

vGuid
    ^ vGuid

    "Created: / 23-09-2011 / 10:28:41 / cg"
!

vGuid:something
    vGuid := something.

    "Created: / 23-09-2011 / 10:28:34 / cg"
!

valueFor:aKey
    ^ self perform:aKey asSymbol

    "Created: / 23-09-2011 / 10:23:26 / cg"
! !

!Class::ClassAttributes methodsFor:'conversion'!

fromSTCPrimitiveArray:anArray
    "for now, the stc compiler generates a 3- or 4-element primitive spec array
     (it does not know anything about the ClassAttributes class).
     This method is invoked to convert."

    primitiveDefinitions := anArray at:1.
    primitiveVariables := anArray at:2.
    primitiveFunctions := anArray at:3.
    anArray size > 3 ifTrue:[
	sharedPools := anArray at:4.
    ].
! !

!Class::SimulatedClassPool class methodsFor:'documentation'!

documentation
"
    in contrast to other smalltalks, ST/X does not keep the classVariables
    in a dictionary; instead, classVariables are stored as special globals,
    with the className as prefix (colon-separated).
    The reason is that stc-compiled code should be allowed to access classVars
    in a similar fashion to globals.

    Whenever a classes classPool is requested (by code imported from visualworks), 
    an instance of myself is created, which forwards at: and at:put: messages 
    to the original class. 
    Notice that classPools are never asked for by smalltalk/x
    code - especially not by the browser. However, imported code (like the refactory browser)
    may do so.

    This is an additional goody class; therefore:

    THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
    OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
    SUCH DAMAGE.

    [author:]
        Claus Gittinger
"
! !

!Class::SimulatedClassPool methodsFor:'accessing'!

associationAt:aName
    "simulate an association"

    ^ SimulatedVariableBinding key:aName value:(class classVarAt:aName)

    "Modified: / 4.2.2000 / 00:27:40 / cg"
!

associationAt:aName ifAbsent:exceptionBlock
    "simulate an association"

    |internalName cls|

    cls := class theNonMetaclass.
    internalName := (cls name , ':' , aName) asSymbol.
    ^ SimulatedVariableBinding key:internalName value:(cls classVarAt:aName)

    "Created: / 3.2.2000 / 23:30:07 / cg"
    "Modified: / 4.2.2000 / 01:58:56 / cg"
!

associations
    |assocs|

    assocs := OrderedCollection new.
    self associationsDo:[:eachAssoc |
	assocs add:eachAssoc
    ].
    ^ assocs

    "Created: / 12-09-2011 / 10:15:11 / cg"
!

associationsDo:aBlock
    "evaluate aBlock for all of my simulated classVarName->value associations"

    class classVarNames do:[:eachName |
	aBlock value:(self associationAt:eachName)
    ].
!

at:aKey
    ^ class classVarAt:aKey
!

at:aKey ifAbsent:exceptionBlock
    ^ class classVarAt:aKey ifAbsent:exceptionBlock
!

at:aKey put:something
    ^ class classVarAt:aKey put:something
!

bindingOf:aKey
    ^ self associationAt:aKey

    "Created: / 12-09-2011 / 09:41:18 / cg"
!

keys
    ^ class classVarNames collect:[:nm | nm asSymbol]

    "
     Button classPool keys
     Button classPool at:#ReturnForm
    "

!

keysAndValuesDo:aBlock
    "evaluate aBlock for all of my simulated classVarName->value associations"

    class classVarNames do:[:eachName |
	aBlock value:eachName value:(class classVarAt:eachName)
    ].
! !

!Class::SimulatedClassPool methodsFor:'accessing-private'!

setClass:aClass
    class := aClass
! !

!Class::SimulatedClassPool::SimulatedVariableBinding class methodsFor:'documentation'!

documentation
"
    Instances are returned from the simulated classPool for VW compatibility.
    See the documentation in SimulatedClassPool for more info.
"
! !

!Class::SimulatedClassPool::SimulatedVariableBinding methodsFor:'queries'!

isVariableBinding
     ^ true

    "Created: / 4.2.2000 / 00:27:20 / cg"
! !

!Class class methodsFor:'documentation'!

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
    ^ '$ Id: Class.st 10643 2011-06-08 21:53:07Z vranyj1  $'
! !

