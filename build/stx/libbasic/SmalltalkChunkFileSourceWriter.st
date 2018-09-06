"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2009-2010 Jan Vrany
 COPYRIGHT (c) 2015 Jan Vrany
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

AbstractSourceFileWriter subclass:#SmalltalkChunkFileSourceWriter
	instanceVariableNames:'classBeingSaved methodsAlreadySaved'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!SmalltalkChunkFileSourceWriter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
 COPYRIGHT (c) 2009-2010 Jan Vrany
 COPYRIGHT (c) 2015 Jan Vrany
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
    I know how to write smalltalk chunk file format
"
! !

!SmalltalkChunkFileSourceWriter class methodsFor:'simple API'!

fileOut:aClass on:aStream
    self fileOut:aClass on:aStream withTimeStamp:true
        withInitialize:true withDefinition:true
        methodFilter:nil encoder:nil
!

fileOut:aClass on:aStream withTimeStamp:withTimeStamp
        withInitialize:initIt withDefinition:withDefinition
        methodFilter:methodFilter encoder:encoderOrNil

    self new
        fileOut:aClass on:aStream withTimeStamp:withTimeStamp
        withInitialize:initIt withDefinition:withDefinition
        methodFilter:methodFilter encoder:encoderOrNil
! !

!SmalltalkChunkFileSourceWriter class methodsFor:'utilities - source code'!

methodTemplate
    <resource: #obsolete>
    "return a method definition template string"

    |s|

    self obsoleteMethodWarning:'use codeGenerator'.
    ^ SmalltalkLanguage instance methodTemplate.

"/    s := (TextStream ? WriteStream) on:''.
"/    s nextPutAll:
"/'message "selector and argument names"
"/    "comment stating purpose of this message"
"/
"/    |temporaries|
"/
"/    "statement."
"/    "statement."
"/
"/    "
"/     optional: comment giving example use
"/    "
"/'.
"/    s cr.
"/    s emphasis:(UserPreferences current commentEmphasisAndColor).
"/    s nextPutAll:
"/'"
"/ change the above template into real code;
"/ remove this comment.
"/ Then `accept'' either via the menu 
"/ or via the keyboard (usually CMD-A).
"/
"/ You do not need this template; you can also
"/ select any existing methods code, change it,
"/ and finally `accept''. The method will then be
"/ installed under the selector as defined in the
"/ actual text - no matter which method is selected
"/ in the browser.
"/
"/ Or clear this text, type in the method from scratch
"/ and install it with `accept''.
"/
"/ If you don''t like this method template to appear,
"/ disable it either via the global or browser''s settings dialog,
"/ or by evaluating:
"/     UserPreferences current showMethodTemplate:false
"/"
"/'.
"/    ^ s contents

    "Modified: / 18-11-2016 / 01:36:39 / cg"
!

methodTemplateForDocumentation
    <resource: #obsolete>
    "return a method definition template string"

    |s|

    self obsoleteMethodWarning:'use codeGenerator'.
    ^ SmalltalkLanguage instance methodTemplateForDocumentation.

"/    s := (TextStream ? WriteStream) on:''.
"/    s nextPutAll:
"/'documentation
"/'.
"/    s emphasis:(UserPreferences current commentEmphasisAndColor).
"/    s nextPutAll:(
"/'"
"/    comment describing this class.
"/    you can disable the generation of this template by evaluating:
"/         UserPreferences current showMethodTemplate:false
"/
"/    [instance variables:]
"/        describe instance variables
"/    [class variables:]
"/        describe class variables
"/    [see also:]
"/        
"/    [author:]
"/        %1
"/"
"/' bindWith:(OperatingSystem getFullUserName)).
"/    ^ s contents

    "Modified: / 18-11-2016 / 01:37:41 / cg"
!

versionMethodTemplateForCVS
    <resource: #obsolete>
    "careful to avoid expansion by cvs here!!"

    self obsoleteMethodWarning:'use methodTemplateForVersionMethodCVS'.
    ^ ('version_CVS\    ^ ''$' , 'Header$''') withCRs

    "Created: / 21-08-2012 / 11:52:27 / cg"
! !

!SmalltalkChunkFileSourceWriter methodsFor:'source writing'!

fileOut:aClass on:outStreamArg withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter
    |encoder any16Bit|

    any16Bit := aClass withAllPrivateClasses contains:[:cls |
                 cls instAndClassMethods contains:[:m |
                        (methodFilter isNil or:[ (methodFilter value:m) ])
                        and:[ 
                            |src|

                            src := m source.
                            src notNil and:[src isWideString and:[ src contains: [:c | c codePoint > 16rFF ] ] ]
                        ]]].

    any16Bit ifTrue:[
        encoder := CharacterEncoder encoderForUTF8.
    ].
    ^ self
        fileOut: aClass 
        on:outStreamArg
        withTimeStamp:stampIt
        withInitialize:initIt
        withDefinition:withDefinition
        methodFilter:methodFilter
        encoder:encoder

    "Created: / 04-10-2014 / 12:11:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-04-2015 / 21:28:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOut:aClass on:outStreamArg withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter encoder:encoderOrNil
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended.
     If initIt is true, and the class implements a class-initialize method,
     append a corresponding doIt expression for initialization.
     The order by which the fileOut is done is used to put the version method at the end.
     Thus, if the version string is expanded (by CVS), the characterPositions of all other methods should not move.
     Notice that any extensions version method is NOT written when a project definition is saved;
     it is ABSOLUTELY required, that it is saved to the extensions.st file only (because the expanded version string
     would be the version string of the project definition file and NOT the version string of the extensions file).
     todo: code duplication with JavaScriptSourceFileWriter - please refactor"

    |collectionOfCategories comment versionMethods extensionVersionMethods
     nonMeta meta classesImplementingInitialize outStream 
     allMetaClassSelectors versionSelectors extensionVersionSelectors
     allVersionMethods|

    self todo:'code duplication with JavaScriptSourceFileWriter - please refactor'.

    classBeingSaved := nonMeta := aClass theNonMetaclass.
    meta := nonMeta class.
    methodsAlreadySaved := Set new.

    nonMeta isLoaded ifFalse:[
        ^ ClassDescription fileOutErrorSignal 
            raiseRequestWith:nonMeta
            errorString:' - will not fileOut unloaded class: ', nonMeta name
    ].

    encoderOrNil isNil ifTrue:[
        outStream := outStreamArg.
    ] ifFalse:[
        outStream := EncodedStream stream:outStreamArg encoder:encoderOrNil.
        outStream nextPutAll:'"{ Encoding: ' , encoderOrNil nameOfEncoding , ' }"'; cr; cr.
    ].

    "
     if there is a copyright method, add a copyright comment
     at the beginning, taking the string from the copyright method.
     We cannot do this unconditionally - that would lead to my copyrights
     being put on your code ;-).
     On the other hand: I want every file created by myself to have the
     copyright string at the beginning be preserved .... even if the
     code was edited in the browser and filedOut.
    "
    self generateHeaderWithCopyrightOn:outStream.

    stampIt ifTrue:[
        "/
        "/ first, a timestamp
        "/
        self generateTimestampOn:outStream.
    ].

    withDefinition ifTrue:[
        "/
        "/ then the definition(s)
        "/
        self fileOutAllDefinitionsOf:nonMeta on:outStream.
        "/
        "/ a comment - if any
        "/
        (comment := nonMeta comment) notNil ifTrue:[
            self fileOutClassCommentOf:nonMeta on:outStream.
        ].
        "/
        "/ ST/X primitive definitions - if any
        "/
        nonMeta fileOutPrimitiveSpecsOn:outStream.
    ].

    "/
    "/ methods from all categories in metaclass (i.e. class methods)
    "/ EXCEPT: the version method is placed at the very end, to
    "/         avoid sourcePosition-shifts when checked out later.
    "/         (RCS expands this string, so its size is not constant)
    "/
    collectionOfCategories := meta categories asSortedCollection.

    allMetaClassSelectors := meta methodDictionary keys.
    versionSelectors := allMetaClassSelectors select:[:selector | AbstractSourceCodeManager isVersionMethodSelector:selector ].
    versionMethods := versionSelectors collect:[:eachSelector | meta methodDictionary at:eachSelector].
    extensionVersionSelectors := allMetaClassSelectors select:[:selector | AbstractSourceCodeManager isExtensionsVersionMethodSelector:selector ]. 
    extensionVersionMethods := extensionVersionSelectors collect:[:eachSelector | meta methodDictionary at:eachSelector].
    allVersionMethods := Set new addAll:versionMethods; addAll:extensionVersionMethods; yourself.

    collectionOfCategories notNil ifTrue:[
        "/
        "/ documentation first (if any), but not the version method
        "/
        (collectionOfCategories includes:'documentation') ifTrue:[

"/            versionMethods do:[:versionMethod |
"/                |source|
"/
"/                source := versionMethod source.
"/                (source isEmptyOrNil or:[(source startsWith:nonMeta nameOfOldVersionMethod) not]) ifTrue:[
"/                    "something bad happend to the classes code"
"/
"/                    Class fileOutErrorSignal 
"/                        raiseRequestWith:aClass
"/                        errorString:' - bad source for version method (uncompiled class file?): ', (versionMethod displayString)
"/                ].
"/            ].

            self fileOutCategory:'documentation' of:meta except:allVersionMethods only:nil methodFilter:methodFilter on:outStream.
        ].

        "/
        "/ initialization next (if any)
        "/
        (collectionOfCategories includes:'initialization') ifTrue:[
            self fileOutCategory:'initialization' of:meta methodFilter:methodFilter on:outStream.
        ].

        "/
        "/ instance creation next (if any)
        "/
        (collectionOfCategories includes:'instance creation') ifTrue:[
            self fileOutCategory:'instance creation' of:meta methodFilter:methodFilter on:outStream.
        ].
        collectionOfCategories do:[:aCategory |
            ((aCategory ~= 'documentation')
            and:[(aCategory ~= 'initialization')
            and:[aCategory ~= 'instance creation']]) ifTrue:[
                self fileOutCategory:aCategory of:meta methodFilter:methodFilter on:outStream.
            ]
        ]
    ].

    "/ if there are any primitive definitions (vw-like ffi-primitives),
    "/ file them out first in the order: defines, types.
    "/ Otherwise, we might have trouble when filing in later, because the types are needed
    "/ for the primitive calls.
    nonMeta methodDictionary keysAndValuesDo:[:sel :m |
        m isVisualWorksTypedef ifTrue:[
            self fileOutCategory:m category of:nonMeta except:nil only:(Array with:m) methodFilter:methodFilter on:outStream.
        ].
    ].

    "/
    "/ methods from all categories
    "/
    collectionOfCategories := nonMeta categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            self fileOutCategory:aCategory of:nonMeta methodFilter:methodFilter on:outStream.
        ]
    ].

    "/
    "/ any private classes' methods
    "/
    nonMeta privateClassesSorted do:[:eachPrivateClass |
        self fileOutAllMethodsOf:eachPrivateClass on:outStream methodFilter:methodFilter
    ].


    "/
    "/ finally, the previously skipped version method (but not the extensionsVersion methods!!)
    "/
    versionMethods notEmpty ifTrue: [
        self fileOutCategory:'documentation' of:meta except:nil only:versionMethods methodFilter:methodFilter on:outStream.
    ].

    initIt ifTrue:[
        "/
        "/ optionally an initialize message
        "/
        classesImplementingInitialize := OrderedCollection new.

        (meta includesSelector:#initialize) ifTrue:[
            classesImplementingInitialize add:nonMeta
        ].
        nonMeta privateClassesSorted do:[:aPrivateClass |
            (aPrivateClass theMetaclass includesSelector:#initialize) ifTrue:[
                classesImplementingInitialize add:aPrivateClass
            ]
        ].
        classesImplementingInitialize notEmpty ifTrue:[
            outStream cr.
            classesImplementingInitialize topologicalSort:[:a :b | b isSubclassOf:a].
            classesImplementingInitialize do:[:eachClass |
                self generateCallToInitializerFor:eachClass on:outStream
            ].
        ].
    ]

    "Created: / 15-11-1995 / 12:53:06 / cg"
    "Modified: / 01-04-1997 / 16:01:05 / stefan"
    "Modified: / 29-09-2011 / 14:53:49 / cg"
!

fileOutAllDefinitionsOf:aNonMetaClass on:aStream
    self fileOutAllDefinitionsOf:aNonMetaClass on:aStream withNameSpace: true.

    "Created: / 15-10-1996 / 11:15:19 / cg"
    "Modified: / 22-03-1997 / 16:11:56 / cg"
    "Modified: / 04-02-2014 / 20:00:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutAllDefinitionsOf:aNonMetaClass on:aStream withNameSpace: withNameSpacePragma
    "append expressions on aStream, which defines myself and all of my private classes."

    |s|

    s := CharacterWriteStream on:(String new:50).
    self fileOutDefinitionOf:aNonMetaClass on:s withNameSpace: withNameSpacePragma.
    aStream nextChunkPut:(s contents).

    "/ self fileOutDefinitionOf:aNonMetaClass on:aStream.
    "/ aStream nextPutChunkSeparator. 
    aStream cr; cr.

    "/
    "/ optional classInstanceVariables
    "/
    aNonMetaClass class instanceVariableString isBlank ifFalse:[
        self fileOutClassInstVarDefinitionOf:aNonMetaClass on:aStream
    ].

    "/ here, the full nameSpace prefixes are output,
    "/ to avoid confusing stc 
    "/ (which otherwise could not find the correct superclass)
    "/
    Class fileOutNameSpaceQuerySignal answer:false do:[
        Class forceNoNameSpaceQuerySignal answer:true do:[
            aNonMetaClass privateClassesSorted do:[:aClass |
                 self fileOutAllDefinitionsOf:aClass on:aStream withNameSpace: false
            ]
        ]
    ].

    "Created: / 04-02-2014 / 20:00:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutAllMethodsOf:aClass on:aStream methodFilter:methodFilter
    |collectionOfCategories|

    collectionOfCategories := aClass class categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            self fileOutCategory:aCategory of:aClass class  methodFilter:methodFilter on:aStream.
        ]
    ].
    collectionOfCategories := aClass categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
        collectionOfCategories do:[:aCategory |
            self fileOutCategory:aCategory of:aClass methodFilter:methodFilter on:aStream.
        ]
    ].

    aClass privateClassesSorted do:[:aClass |
        self fileOutAllMethodsOf:aClass on:aStream methodFilter:methodFilter
    ].

    "Created: 15.10.1996 / 11:13:00 / cg"
    "Modified: 22.3.1997 / 16:12:17 / cg"
!

fileOutCategory:aCategory of:aClass except:skippedMethods only:savedMethods methodFilter:methodFilter on:aStream
    "file out all methods belonging to aCategory, aString onto aStream.
     If skippedMethods is nonNil, those are not saved.
     If savedMethods is nonNil, only those are saved.
     If both are nil, all are saved. See version-method handling in
     fileOut for what this is needed."

    |sortedSelectors first prevPrivacy privacy interestingMethods cat prjDef|

    interestingMethods := OrderedCollection new.
    aClass methodsDo:[:each |
        | wanted method shadowed |

        method := each.
        (methodsAlreadySaved includes:method) ifFalse:[
            (aCategory = method category) ifTrue:[
                wanted := methodFilter isNil or:[methodFilter value:method].
                wanted ifFalse:[ 
                    "/ care for methods which have been shadowed by an extension from another package!!
                    "/ The problem is that we cannot easily introspect the filter, so we cannot know
                    "/ if the filter is for package or not. In most (all?) cases it is as this method
                    "/ is mostly used by source code management, so if the filter filters method out,
                    "/ try afain for possibly shadowed method.
                    methodFilter notNil ifTrue:[ 
                        shadowed := method shadowedMethod.
                        shadowed notNil ifTrue:[ 
                            wanted := methodFilter value: shadowed.
                        ].
                    ].
                ].
                wanted ifTrue:[
                    skippedMethods notNil ifTrue:[
                        wanted := (skippedMethods includesIdentical:method) not
                    ] ifFalse:[
                        wanted := savedMethods isNil or:[ savedMethods includesIdentical:method ].
                    ].
                    wanted ifTrue:[
                        (method selector isSymbol) ifTrue:[
                            interestingMethods add:method
                        ] ifFalse:[
                            Transcript showCR:'skipping non-symbol method ', method selector printString.
                        ].
                    ].
                ]
            ]
        ]
    ].

    interestingMethods notEmpty ifTrue:[
        "/
        "/ sort by selector
        "/
        sortedSelectors := interestingMethods collect:[:m | aClass selectorAtMethod:m].
        sortedSelectors sortWith:interestingMethods.

        generatingSourceForOriginal == true ifTrue:[
            "/ care for methods which have been shadowed by an extension from another package!!
            (prjDef := aClass theNonMetaclass projectDefinitionClass) notNil ifTrue:[
                prjDef hasSavedOverwrittenMethods ifTrue:[
                    interestingMethods := interestingMethods collect:[:m |
                                                |originalOrNil|
                                                
                                                (m package ~~ aClass package) ifTrue:[ 
                                                    originalOrNil := prjDef savedOverwrittenMethodForClass:aClass selector:m selector.
                                                    originalOrNil notNil ifTrue:[ 
                                                        1.
                                                        self breakPoint:#cg 
                                                    ].
                                                ].
                                                originalOrNil ? m
                                          ].
                ]
            ].
        ].

        first := true.
        prevPrivacy := nil.

        interestingMethods do:[:eachMethod |
            privacy := eachMethod privacy.

            first ifFalse:[
                privacy ~~ prevPrivacy ifTrue:[
                    first := true.
                    aStream space.
                    aStream nextPutChunkSeparator.
                ].
                aStream cr; cr
            ].

            first ifTrue:[
                aStream nextPutChunkSeparator.
                aClass printClassNameOn:aStream.
                privacy ~~ #public ifTrue:[
                    aStream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
                ] ifFalse:[
                    aStream nextPutAll:' methodsFor:'.
                ].
                cat := aCategory.
                cat isNil ifTrue:[ cat := '' ].
                aStream nextPutAll:aCategory asString storeString.
                aStream nextPutChunkSeparator; cr; cr.
                first := false.
            ].
            self fileOutMethod:eachMethod on:aStream.
            methodsAlreadySaved add:eachMethod.

            prevPrivacy := privacy.
        ].
        aStream space.
        aStream nextPutChunkSeparator.
        aStream cr
    ].
    aStream cr

    "Modified: / 28-08-1995 / 14:30:41 / claus"
    "Modified: / 12-06-1996 / 11:37:33 / stefan"
    "Modified: / 15-11-1996 / 11:32:21 / cg"
    "Created: / 01-04-1997 / 16:04:33 / stefan"
    "Modified: / 03-10-2014 / 23:16:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutCategory:aCategory of:aClass methodFilter:methodFilter on:aStream
    "file out all methods belonging to aCategory, aString onto aStream"

    self fileOutCategory:aCategory of:aClass except:nil only:nil methodFilter:methodFilter on:aStream

    "Created: 1.4.1997 / 16:04:44 / stefan"
!

fileOutClassCommentOf:aNonMetaClass on:aStream
    aNonMetaClass fileOutCommentOn:aStream.
!

fileOutClassInstVarDefinitionOf:aNonMetaClass on:aStream
    aNonMetaClass fileOutClassInstVarDefinitionOn:aStream.
    aStream nextPutChunkSeparator. 
    aStream cr; cr
!

fileOutCommentEndOn:aStream
    "Writes a comment end mark on aStream."

    "/ intentionally left blank - make each line an EOL-comment instead
!

fileOutCommentLine:aString on:aStream
    "Writes a single line of comment on a comment to a stream."

    aStream 
        nextPutAll:'"/ ';
        nextPutAll: aString
!

fileOutCommentStartOn:aStream
    "Writes a comment start mark on aStream."

    "/ intentionally left blank - make each line an EOL-comment instead
!

fileOutDefinitionOf:aNonMetaClass on:aStream
    aNonMetaClass fileOutDefinitionOn:aStream.
!

fileOutDefinitionOf:aNonMetaClass on:aStream withNameSpace: withNameSpacePragma
    aNonMetaClass basicFileOutDefinitionOn:aStream withNameSpace: withNameSpacePragma

    "Created: / 04-02-2014 / 20:00:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutMethod:aMethod on:aStream
    "file a single method onto aStream."

    |source possiblyRewrittenSource rewriteQuery|

    source := aMethod source asSingleByteStringIfPossible.
    source isNil ifTrue:[
        Class fileOutErrorSignal 
            raiseRequestWith:aMethod mclass
            errorString:' - no source for method: ', (aMethod displayString)
    ] ifFalse:[
        "/ hook to allow for just-in-time rewriting of a method's sourceCode while filing out
        "/ used when saving version_XXX methods in a non-XXX sourceCodeManager
        "/ (i.e. to rewrite all non-CVS version methods while saving into a CVS repository)
        "/ this is required because we cannot save an SVN version method (dollar-ID-...-dollar) into a
        "/ CVS repository without loosing the original string with the next checkout, because it also gets  
        "/ expanded by CVS. The same is true vice-versa for CVS-Ids, which get clobbered by SVN.
        "/ also used, when generating sourcecode for another Smalltalk system (VSE fileout)

        rewriteQuery := AbstractSourceFileWriter methodSourceRewriteQuery new.
        rewriteQuery method:aMethod source:source.
        possiblyRewrittenSource := (rewriteQuery query) ? source.
        aStream nextChunkPut:possiblyRewrittenSource.
"/possiblyRewrittenSource ~= source ifTrue: [
"/    Transcript showCR: possiblyRewrittenSource.
"/].
    ].

    "Modified: / 13-04-2015 / 21:37:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutMethods: methods on: stream

    methods do:[:method| 
        |cat source privacy|

        stream nextPutChunkSeparator.
        "JV@2012-09-05: Support for filing out Java extension methods"
        method mclass theNonMetaclass isJavaClass ifTrue:[
            | class classBinaryName comps |

            class := method mclass theNonMetaclass .
            "Sigh, make it compatible with old and new naming of Java classes

            old -> aJavaClass name == #'java/lang/Object'
            new -> aJavaClass name == JAVA::java::lang::Object
                   aJavaClass binaryName == #'java/lang/Object'
            "
            classBinaryName := (class respondsTo: #binaryName) 
                                    ifTrue:[ class binaryName ]
                                    ifFalse:[ class name ].      
            stream nextPutAll:'(Java classForName:'''.
            stream nextPutAll:(classBinaryName copyReplaceAll:$/ with: $.).
            stream nextPutAll:''')'.
            method mclass isMetaclass ifTrue:[
                stream nextPutAll: ' class'.
            ].
        ] ifFalse:[
            method mclass name printOn:stream.
        ].
        "/        self printClassNameOn:aStream.

        (privacy := method privacy) ~~ #public ifTrue:[
            stream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
        ] ifFalse:[
            stream nextPutAll:' methodsFor:'.
        ].

        cat := method category ? ''.
        stream nextPutAll:cat asString storeString.
        stream nextPutChunkSeparator; cr; cr.

        self fileOutMethod: method on: stream.

        stream space.
        stream nextPutChunkSeparator.
        stream cr]

    "Created: / 30-12-2009 / 18:43:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-10-2013 / 08:57:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutPackageDefinition:pkg on:aStream 
    (pkg notNil and:[ pkg ~= PackageId noProjectID ]) ifTrue:[
        aStream nextPutAll:'"{ Package: '''.
        aStream nextPutAll:pkg asString.
        aStream
            nextPutAll:''' }"'; cr; cr;
            nextPut:$!!; cr; cr
    ]
!

generateCallToInitializerFor:aClass on:aStream
    aClass printClassNameOn:aStream. aStream nextPutAll:' initialize'.
    aStream nextPutChunkSeparator.
    aStream cr.
!

generateHeaderWithCopyrightOn:outStream
    |copyrightMethod copyrightText|

    "if there is a copyright method, add a copyright comment
     at the beginning, taking the string from the copyright method.
     We cannot do this unconditionally - that would lead to my copyrights
     being put on your code ;-).
     On the other hand: I want every file created by myself to have the
     copyright string at the beginning be preserved .... even if the
     code was edited in the browser and filedOut."

    (copyrightMethod := classBeingSaved theMetaclass compiledMethodAt:#copyright) notNil ifTrue:[
        "
         get the copyright method's comment-text, strip off empty and blank lines
         and insert at beginning.
        "
        copyrightText := copyrightMethod comment.
        copyrightText notEmptyOrNil ifTrue:[
            copyrightText := copyrightText asCollectionOfLines asStringCollection.
            copyrightText := copyrightText withoutLeadingAndTrailingBlankLines.
            copyrightText notEmpty ifTrue:[
                copyrightText addFirst:'"'.
                copyrightText addLast:'"'.
                copyrightText := copyrightText asString.
                outStream nextPutAllAsChunk:copyrightText.
            ].
        ].
    ].
!

generateTimestampOn:outStream
    outStream nextPutAll:(Smalltalk timeStamp).
    outStream nextPutChunkSeparator. 
    outStream cr; cr.
! !

!SmalltalkChunkFileSourceWriter class methodsFor:'documentation'!

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
    ^ '$ Id: SmalltalkChunkFileSourceWriter.st 10643 2011-06-08 21:53:07Z vranyj1  $'
! !

