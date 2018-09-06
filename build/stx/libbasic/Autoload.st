"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

nil subclass:#Autoload
	instanceVariableNames:''
	classVariableNames:'LazyLoading AutoloadFailedSignal LoadedClasses InProgressClasses'
	poolDictionaries:''
	category:'Kernel-Classes'
!

!Autoload class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    Autoload is a stub for an 'as yet unloaded' class.

    In memory limited systems (as my original 8Mb 386 system was),
    all seldom-used classes were made subclasses of this class.
    Autoload catches all messages sent to it, and files-in the real class's
    code when first used. Then the caught message is resent to the (now existing) class.

    A note from later days:
        These days, systems usually have enough memory to allow
        having all classes present, so many of the classes which used to be
        autoloaded are no longer these days. However, a number of examples or
        very seldom used frameworks are still present as autoloaded.
        Instead of using autoloaded classes, it is now recommended to bundle
        extra classes into packages, which are loaded en-bloque.
        Packages can be compiled to a shared class library and thus be loaded
        much faster (there is no need to parse and compile source files).

    Lazy loading:
    Class files are searched along the searchPath (see Smalltalk),
    and any of binary-classFile, byteCode-classFile or sourceFile are loaded,
    whichever is found first.
    For binaries to be loaded, these must be found in a package-subdirectory
    along the so called package path.
    Sources in a package directory along the source path.
    In practice, most Autoloaded classes are found and loaded as source file.

    Initial Setup of Auoload Stubs:
    At initial startup (i.e. when ST/X is NOT coming up with an image),
    the 'patches' startup script recursively walks along all directories
    below the TOP directory (that is one above the stx folder),
    and installs autoload stubs for all .st class files found, for which no
    corresponding class is already present.
    As you can imagine, this takes a long time and makes the initial startup quite slow.
    Therefore, this scheme is no longer the recommended one and we (at exept)
    always start ST/X with the '--quick' option, which skips this scan operation.
    Late note: 
        --quick is now (7.1.1) the default. 
        To force an autoload scan, start stx with a --autoload argument.
    
    
    Advantage of Autoload stubs:
    Autoload stubs make it easier for a beginner to ST/X, to see what frameworks and classes
    are there, as they appear in the browser with category and class name (although no
    more details are initially visible.

    [class variables:]

        LazyLoading             <Boolean>       if true, the loaded classes
                                                methods will NOT be compiled at
                                                autoload time, but instead when
                                                first called. This allows for a
                                                faster load. However, expect short
                                                pauses later when the methods are
                                                first executed.

        AutoloadFailedSignal    <Signal>        signal raised if an autoloaded
                                                classes source is not available.

        LoadedClasses           <Collection>    set of classes that heve been
                                                autoloaded (for later unload)

    [see also:]
        Smalltalk

    [author:]
        Claus Gittinger
"
! !

!Autoload class methodsFor:'initialization'!

initialize
    "initialize either the Autoload class
     or load a autoloaded class and initialize it."

    self ~~ Autoload ifTrue:[
        "subclass: catch initialize - load the class and resend #initialize to the real one"
        ^ self doesNotUnderstand:(Message selector:#initialize)
    ].

    "initialize myself"
    AutoloadFailedSignal isNil ifTrue:[
        LazyLoading := false.

        AutoloadFailedSignal := ProceedableError newSignal
                                    nameClass:self message:#autoloadFailedSignal;
                                    notifierString:'autoload failed'.

        self class changeClassTo:AutoloadMetaclass.
        ObjectMemory flushCaches.
    ].
    LoadedClasses isNil ifTrue:[
        LoadedClasses := IdentitySet new.
    ].
    InProgressClasses isNil ifTrue:[
        InProgressClasses := IdentitySet new.
    ].


    "Modified: / 20.5.1997 / 19:06:25 / cg"
    "Modified: / 3.8.1999 / 14:23:30 / stefan"
! !

!Autoload class methodsFor:'Signal constants'!

autoloadFailedSignal
    "return the signal raised when an autoload fails"

    ^ AutoloadFailedSignal
! !

!Autoload class methodsFor:'adding/removing autoloaded classes'!

addClass:aClassName
    "given a name, install a corresponding autoload class stub for it.
     Return the (autoload-) stubClass or nil, if no new class was created."

    ^ self addClass:aClassName inCategory:'autoloaded-Classes'

    "
     Autoload addClass:'Clock'
    "

    "Modified: 24.4.1996 / 19:54:16 / cg"
!

addClass:aClassName inCategory:aCategory
    "given a name, install a corresponding autoload class stub for it.
     Return the (autoload-) stubClass or nil, if no new class was created."

    |nameSymbol cls|

    nameSymbol := aClassName asSymbol.
    (Smalltalk at:nameSymbol) isNil ifTrue:[
        cls := self 
                subclass:nameSymbol
                instanceVariableNames:''
                classVariableNames:''
                poolDictionaries:''
                category:aCategory.
    ].
    ^ cls

    "
     Autoload addClass:'Clock' inCategory:'autoloaded-Demos'
    "

    "Modified: 24.4.1996 / 19:54:20 / cg"
!

removeClass:aClass
    "remove a class from the list of loaded classes"

    LoadedClasses remove:aClass ifAbsent:[]

    "Modified: 24.4.1996 / 19:54:35 / cg"
! !

!Autoload class methodsFor:'fileOut'!

basicFileOutDefinitionOn:aStream withNameSpace:forceNameSpace withPackage:withPackage
    "print an expression to define myself on aStream.
     Since autoloaded classes don't know their real definition, simply
     output some comment string making things clear in the browser."

    |myName fileName nm package|

    (self == Autoload) ifTrue:[
        ^ super 
            basicFileOutDefinitionOn:aStream 
            withNameSpace:forceNameSpace
            withPackage:withPackage
    ].

    myName := self name.
    aStream nextPutAll:'"' ; nextPutLine:'Notice:'; cr;
            spaces:4; nextPutLine:'The ',myName,' class is not yet loaded.'; cr.
    aStream nextPutLine:'It will automatically load itself when accessed (instantiated).'.
    aStream nextPutLine:'To force loading now, execute: '.
    aStream cr; spaces:4; nextPutLine:myName  , ' autoload'.
    aStream cr; nextPutLine:'or use the browser''s load function (in the classList''s ''Special''-menu)'.
    aStream nextPutLine:'(a double-click on the class will also load it).'.
    "
     the following is simply informative ...
     actually, its a hack & kludge - there ought to be a method for this
     in Smalltalk 
     (knowing the details of loading here is no good coding style)
    "
    fileName := (Smalltalk fileNameForClass:myName).
    (ObjectFileLoader notNil and:[Smalltalk loadBinaries]) ifTrue:[
        (nm := Smalltalk libraryFileNameOfClass:myName) notNil ifTrue:[
            nm := nm , ' (a classLibrary, possibly including more classes)'
        ] ifFalse:[
            nm := Smalltalk getBinaryFileName:(fileName , '.so').
            nm isNil ifTrue:[
                nm := Smalltalk getBinaryFileName:(fileName , '.o')
            ].
            nm notNil ifTrue:[
                nm := nm , ' (a classBinary)'
            ]
        ].
    ].
    nm isNil ifTrue:[
        package := self package.
        package notNil ifTrue:[
            nm := Smalltalk getSourceFileName:((package copyReplaceAll:$: with:$/) , '/' , fileName , '.st').
        ].
        nm isNil ifTrue:[
            nm := Smalltalk getSourceFileName:(fileName , '.st').
        ].
    ].
    nm notNil ifTrue:[
        aStream 
            cr; 
            nextPutLine:'When accessed, ' , myName , ' will automatically be loaded';
            nextPutLine:'from: '; spaces:4; nextPutAll:nm.

        nm asFilename isSymbolicLink ifTrue:[
            aStream cr; cr.
            aStream 
                nextPutLine:'which is a link to: '; 
                spaces:4; 
                nextPutAll:(nm asFilename linkInfo path).
        ]
    ] ifFalse:[
        package := self package.
        (Smalltalk at:#SourceCodeManager) notNil ifTrue:[
            aStream nextPutAll:'
When accessed, I''ll ask the sourceCodeManager to load the code 
from ''' , fileName , '.st'' in the ''' , package , ''' package.'.
        ] ifFalse:[
            aStream nextPutAll:'
When accessed, I''ll search for a file named 
''' , fileName , '.st'' in the ''' , package , ''' package.

Packages are tried along the packagePath, which is:
' , ((Smalltalk packagePath asStringCollection collect:[:each| '   ' , each]) asStringWith:Character cr). 
        ]
    ].
    aStream cr; nextPutAll:'"'.

    "Created: / 05-01-1997 / 14:31:33 / cg"
    "Modified: / 06-10-2006 / 16:17:18 / cg"
! !

!Autoload class methodsFor:'lazy compilation'!

compileLazy
    "return the lazy loading flag - if on, fileIn is much faster,
     but pauses are to be expected later, since methods are compiled
     when first executed."

    ^ LazyLoading
!

compileLazy:aBoolean
    "turn on/off lazy loading - if on, fileIn is much faster,
     but pauses are to be expected later, since methods are compiled
     when first executed.
     If you like it, add a line to your startup file."

    LazyLoading := aBoolean
! !

!Autoload class methodsFor:'loading'!

autoload
    "use this to force loading
     - it is defined a noop in all non-autoloading classes.
     Return the loaded class"

    |myName myNameSpace newClass project prevMode packageID
     packageDefinitionClass packageExtensionsFile|

    self == Autoload ifTrue:[
        "already loaded"
        ^ self.
    ].

    myName := self name asSymbol.
    myNameSpace := self nameSpace.

    (InProgressClasses includes:myName) ifTrue:[
        "Class is already being loaded. 
         In most cases we come here through the path:
            subclass autoload 
            -> superclass autoload 
            -> superclass initialize/postAutoload 
            -> subclass autoload (hardcoded in initialize method).
         Simply ignore it here"
            
"/        AutoloadFailedSignal
"/            raiseRequestWith:self
"/            errorString:('autoload of ' , myName , ' failed (recursive invocation)').

        "self is not yet the loaded class - but it will be after the #become:
         that is done eventually by some sender above."
        ^ self.
    ].

    "/ recheck - in case my class somehow came into the system
    "/ (by loading a binary...)
    (newClass := Smalltalk at:myName) ~~ self ifTrue:[
        (newClass isBehavior and:[newClass isLoaded]) ifTrue:[
            (Object infoPrinting and:[Smalltalk silentLoading ~~ true]) ifTrue:[
                Transcript showCR:('Autoload [info]: already loaded: ', myName , '.'); endEntry.
            ].
            self class becomeSameAs:newClass class.
            self becomeSameAs:newClass.

            ObjectMemory flushCaches.
            ^ newClass
        ].
    ].

    (Object infoPrinting and:[Smalltalk silentLoading ~~ true]) ifTrue:[
        "/ thisContext fullPrintAll.
        Transcript showCR:('autoloading ', myName , ' ...'); endEntry.
    ].

    packageID := self package.
    packageID == PackageId noProjectID ifTrue:[
        Transcript showCR:('Autoload [warning]: bad packageID (__NoProject__) in ', myName); endEntry.
    ] ifFalse:[
        "if there is a package-definition, make sure it is loaded first"
        packageDefinitionClass := ProjectDefinition definitionClassForPackage: packageID.
        (packageDefinitionClass notNil) ifTrue:[
            (packageDefinitionClass ~~ self) ifTrue:[
                (packageDefinitionClass isBehavior) ifTrue:[
                    (packageDefinitionClass isLoaded) ifFalse:[
                        packageDefinitionClass autoload.
                    ].
                    "/ make sure that my package's extensions are also present
                    (packageDefinitionClass isLoaded) ifTrue:[
                        packageDefinitionClass loadExtensions    
                    ]
                ].
            ].
        ] ifFalse:[
            "/ no package definition class - look for extensions anyway
            packageExtensionsFile := (Smalltalk projectDirectoryForPackage:packageID) asFilename / 'extensions.st'.
            packageExtensionsFile exists ifTrue:[
                packageExtensionsFile fileIn.
            ].
        ].
    ].

    [
        InProgressClasses add:myName.

        prevMode := ClassCategoryReader sourceMode.
        "/ no- do not do this; it may lead to trouble ...
        "/  ClassCategoryReader sourceMode:#reference.

        "/
        "/ in order to not get a package of private (or whatever),
        "/ temporarily set the currentProject to nil.
        "/ we will later set the classes package to something useful
        "/
        Project notNil ifTrue:[
            project := Project current.
            Project setProject:nil.
        ].

        Class nameSpaceQuerySignal answer:myNameSpace "Smalltalk" 
        do:[
            Class packageQuerySignal answer:packageID 
            do:[
                Class classConventionViolationConfirmationQuerySignal answer:true
                do:[
                    |classFileName|

                    classFileName := self classFilename.    
                    (classFileName notNil and:[classFileName asFilename isAbsolute]) ifTrue:[
                        "/ if filename is absolute, the autoload-class was created by an
                        "/ explicit install-as-autoloaded via the fileBrowser.
                        Smalltalk fileIn:classFileName lazy:false silent:nil.
                    ] ifFalse:[
                        (Smalltalk 
                            fileInClass:myName
                            package:packageID
                            initialize:false 
                            lazy:LazyLoading
                            silent:nil)  
                        isNil ifTrue:[
                            "/ temporary: try without stx/package prefix
                            "/ this will vanish as soon as source-directory
                            "/ is always guaranteed to contain an stx-subtree
                            ((packageID startsWith:'stx/') 
                             or:[packageID startsWith:'stx:']) ifTrue:[
                                Smalltalk 
                                    fileInClass:myName
                                    package:(packageID copyFrom:5)
                                    initialize:false 
                                    lazy:LazyLoading
                                    silent:nil.
                            ]
                        ]
                    ]
                ]
            ]
        ].
    ] ensure:[
        "restore previous state"
        ClassCategoryReader sourceMode:prevMode.
        project notNil ifTrue:[
            Project setProject:project.
        ].
        InProgressClasses remove:myName ifAbsent:[].
    ].

    "                     
      NOTE: ClassLoader did already perform a #becomeSameAs:
            of the loaded class to the new class.

            So some of the code below is no longer needed.
    "

    "did it work ?"
    newClass := Smalltalk at:myName.
    newClass ~~ self ifTrue:[
        "reinstall the autoload class, this will be undone by #become:"
        Smalltalk at:myName put:self.
    ].

    "no - report the error"
    (newClass isNil or:[newClass isLoaded not]) ifTrue:[
        "
         USER INFORMATION:
         this exception has been raised because an autoloaded class
         could not be loaded. Usually, this happens when
         the classes sourcefile is missing, unreadable or if 
         an entry is missing in the abbreviation file.

         Check for a readable file named <myName>.st 
         in the 'source' directory and (if its a long fileName) 
         for a corresponding entry in the abbreviation file
         'include/abbrev.stc'.
         Finally, your searchpath could be set wrong -
         both 'source' and 'include' directories must be found in
         one of the directories named in systemPath.

         In the debugger, press 'Abort' to continue execution.
        " 
        AutoloadFailedSignal
            raiseRequestWith:self
            errorString:('autoload of %1 failed (%2)' 
                            bindWith:myName 
                            with:(newClass isNil ifTrue:['nil result'] ifFalse:['still unloaded'])).
        ^ nil
    ].

    newClass setPackage:packageID.
    newClass instAndClassSelectorsAndMethodsDo:[:sel :mthd | mthd setPackage:packageID].

    "/
    "/ autoloaded classes get their package from the revision (if present)
    "/ this only happens with autoloaded sourceFiles which have no package
    "/ info encoded. (binary classes have it)
    "/ If there is no such information, give it my package (if I have one)
    "/
"/    newClass setPackageFromRevision.
"/
"/    newPackage := newClass package.
"/    (newPackage isNil or:[newPackage = 'no package']) ifTrue:[
"/        (package notNil and:[package ~= 'no package']) ifTrue:[
"/            newClass setPackage:packageID.
"/        ].
"/    ].


    "wow - it worked. now the big trick ..."

"/   newClass class setSoleInstance:self.   "/ will be undone by become ...
"/   self setName:(self name , ' (auto)').

    Smalltalk changed:#aboutToAutoloadClass with:(self -> newClass).
    newClass ~~ self ifTrue:[
        self dependents do:[:aDependent |
            newClass addDependent:aDependent
        ].
        self class becomeSameAs:newClass class.
        self becomeSameAs:newClass.

        ObjectMemory flushCaches.
        Class flushSubclassInfoFor:self.
    ].

    "the rehash here is pure superstition"
    LoadedClasses rehash; add:newClass.

    newClass postAutoload.
    newClass initializeWithAllPrivateClasses.

    Smalltalk changed:#classDefinition with:newClass.
    self changed:#loaded with:newClass.
    ^ newClass

    "Modified: / 23-10-2006 / 18:12:21 / cg"
! !

!Autoload class methodsFor:'message catching'!

at:arg
    "catch at: - redefined because its understood"

    ^ self doesNotUnderstand:(Message selector:#at: argument:arg)
!

basicNew
    "catch basicNew - load the class and send it to the real one"

    ^ self doesNotUnderstand:(Message selector:#basicNew)

    "Modified: 24.4.1996 / 19:53:10 / cg"
!

basicNew:arg
    "catch basicNew: - load the class and send it to the real one"

    ^ self doesNotUnderstand:(Message selector:#basicNew: argument:arg)

    "Modified: 24.4.1996 / 19:53:16 / cg"
!

classResources
    "catch classResources - load the class and resend to the real one"

    ^ self doesNotUnderstand:(Message selector:#classResources)
!

comment
    "return the classes comment.
     Autoloaded classes have no comment; but I myself have one"

    (self == Autoload) ifTrue:[^ super comment].
    ^ 'not yet loaded'
!

copy
    "catch copy - load the class and resend #copy to the real one"

    ^ self doesNotUnderstand:(Message selector:#copy)
!

doesNotUnderstand:aMessage
    "caught a message; load the class and retry the message"

    |newClass|

    self ~~ Autoload ifTrue:[
        newClass := self autoload.
        (newClass notNil and:[newClass isLoaded]) ifTrue:[
            ^ aMessage sendTo:newClass
        ]
    ].
    ^ super doesNotUnderstand:aMessage

    "Modified: / 16-10-2006 / 16:52:20 / cg"
!

error
    "catch error - load the class and resend #error to the real one"

    ^ self doesNotUnderstand:(Message selector:#error)
!

fromString:aString
    "catch  - load the class and send it to the real one"

    ^ self doesNotUnderstand:(Message selector:#fromString: argument:aString)
!

handle:handler do:aBlock
    "autoload the class and resend"

    ^ self doesNotUnderstand:(Message selector:#handle:do: argument:handler argument:aBlock)
!

isAbstract
    ^ false "/ actually: don't know, but do not want to load my class for this query
!

new
    "catch new - load the class and resend #new to the real one"

    ^ self doesNotUnderstand:(Message selector:#new)

    "Modified: 26.5.1997 / 14:59:52 / cg"
!

new:arg
    "catch new: - load the class and resend #new: it to the real one"

    ^ self doesNotUnderstand:(Message selector:#new: argument:arg)

    "Modified: 26.5.1997 / 14:59:58 / cg"
!

privateClassesAt:aClassNameString
    "catch  - load the class and send it to the real one"

    self == Autoload ifTrue:[
        ^ super privateClassesAt:aClassNameString.
    ].
    ^ self doesNotUnderstand:(Message selector:#privateClassesAt: argument:aClassNameString)
!

readFrom:aStream 
    "catch  - load the class and send it to the real one"

    ^ self doesNotUnderstand:(Message selector:#readFrom: argument:aStream)

    "Created: 22.5.1996 / 23:44:23 / stefan"
!

readFrom:aStream onError:exceptionBlock
    "catch  - load the class and send it to the real one"

    ^ self doesNotUnderstand:(Message selector:#readFrom:onError: argument:aStream argument:exceptionBlock)

    "Created: 22.5.1996 / 23:03:39 / stefan"
!

readFromString:aString
    "catch  - load the class and send it to the real one"

    ^ self doesNotUnderstand:(Message selector:#readFromString: argument:aString)

    "Created: 22.5.1996 / 23:46:15 / stefan"
!

readFromString:aString onError:exceptionBlock
    "catch  - load the class and send it to the real one"

    ^ self doesNotUnderstand:(Message selector:#readFromString:onError: argument:aString argument:exceptionBlock)

    "Created: 22.5.1996 / 23:04:49 / stefan"
!

respondsTo:aSelector
    "catch respondsTo: - load the class and resend #respondsTo: it to the real one"

    self == Autoload ifTrue:[
        ^ super respondsTo:aSelector
    ].
    ^ self doesNotUnderstand:(Message selector:#respondsTo: argument:aSelector)

    "Modified: 26.5.1997 / 14:59:58 / cg"
!

value
    "catch value - load the class and resend #value to the real one"

    ^ self doesNotUnderstand:(Message selector:#value)
! !

!Autoload class methodsFor:'private'!

loadAndResendMessage
    "common helper to autoload a class and define a subclass of it by sending
     the sender-message again.
     This is invoked by all #subClass... definition messages."

    |sel args newClass|

    sel := thisContext sender selector.
    args := thisContext sender args.

    "take care: subclassing Autoload must still be possible"
    (self == Autoload) ifTrue:[
        ^ self perform:sel inClass:self class superclass withArguments:args
    ].

    newClass := self autoload.
    newClass notNil ifTrue:[
        newClass isLoaded ifTrue:[
            ^ newClass perform:sel withArguments:args
        ].
        Transcript showCR:'Autoload [warning]: failed to autoload ',self name.
    ].
    ^ nil

    "Created: / 08-02-1997 / 19:42:47 / cg"
    "Modified: / 17-08-2006 / 11:12:24 / cg"
! !

!Autoload class methodsFor:'queries'!

accepts:aSignal
    "redefined to avoid recursive autoload.
     (#autoload eventually raises QueryExceptions.
      These exception may send #accepts: to exception classes
      that are currently being loaded)"

    |newClass|

    self isBeingLoaded ifFalse:[
        newClass := self autoload.
        newClass notNil ifTrue:[
            ^ newClass accepts:aSignal
        ].
    ].
    ^ false
!

handles:anException
    "redefined to avoid recursive autoload.
     (#autoload eventually raises QueryExceptions.
      These exception may send #handles: to exception classes
      that are currently being loaded)"

    |newClass|

    self isBeingLoaded ifFalse:[
        newClass := self autoload.
        newClass notNil ifTrue:[
            ^ newClass handles:anException
        ].
    ].
    ^ false
!

isBehavior
    "return true, if the receiver is describing another objects' behavior.
     Autoloaded classes are definitely; therefore return true."

    ^ true
!

isBeingLoaded
    "answer true if the class loading is currently in process"

    ^ (self ~~ Autoload) and:[InProgressClasses includes:self name asSymbol]

    "Modified: / 16.2.1998 / 11:57:35 / stefan"
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Returns false here."

    ^ false

    "Created: 10.12.1995 / 00:28:22 / cg"
    "Modified: 23.4.1996 / 15:55:36 / cg"
!

isLoaded
    "return true, if the class has been loaded.
     Autoload itself is loaded, subclasses are not.
     This allows testing whether a class has already been loaded."

    ^ (self == Autoload)

    "Modified: / 16-02-1998 / 11:57:35 / stefan"
    "Modified (comment): / 27-07-2013 / 15:35:01 / cg"
!

loadedClasses
    "return the set of classes that were autoloaded"

    ^ LoadedClasses
!

privateClassesOrAll:allOfThem
    "an autoloaded class has none"

    ^ #()
!

wasAutoloaded:aClass
    "return true, if aClass was autoloaded"

    ^ LoadedClasses includes:aClass
! !

!Autoload class methodsFor:'utilities'!

withClass:aClass loadedDo:aBlock
    "ensure that aClass is loaded, while evaluating aBlock for it"

    |wasLoaded loadedClass|

    wasLoaded := aClass isLoaded.
    wasLoaded ifTrue:[  
        ^ aBlock value:aClass
    ].

    ParserFlags 
        withSTCCompilation:#never 
        do:[
            loadedClass := aClass autoload.
        ].


    ^ [
        aBlock value:loadedClass
      ] ensure:[
        aClass unload
      ]

    "
     Autoload withClass:Array loadedDo:[:cls | self assert:cls isLoaded]
     Autoload withClass:Cons loadedDo:[:cls | self assert:cls isLoaded]
    "

    "Created: / 08-02-2011 / 20:01:32 / cg"
! !

!Autoload class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Autoload initialize!
