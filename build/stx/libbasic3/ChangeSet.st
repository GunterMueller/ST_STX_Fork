"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2015-2018 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

OrderedCollection subclass:#ChangeSet
	instanceVariableNames:'changedClasses changeSelectors name'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

Object subclass:#ChangeFileReader
	instanceVariableNames:'inputStream parseTree changeAction changeSet selector receiver
		arguments receiverSelector receiverReceiver lineNumber position
		className methodSelector nameSpaceOverride chunk timestamp
		classIsJava'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet
!

Object subclass:#ChangeFileWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet
!

ChangeSet::ChangeFileReader subclass:#BeeChangeFileReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet
!

ChangeSet::ChangeFileWriter subclass:#BeeChangeFileWriter
	instanceVariableNames:'timestamp'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet
!

Error subclass:#ChangeProcessingError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet
!

SmalltalkChunkFileSourceWriter subclass:#ClassSourceWriter
	instanceVariableNames:'changeSetBeingSaved packageName namespaceName topClassName
		classInfos metaInfos'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet
!

Object subclass:#ClassInfo
	instanceVariableNames:'name superclass definition comment methods methodDictionary
		namespace primitiveDefinitions primitiveVariables
		primitiveFunctions'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet::ClassSourceWriter
!

Object subclass:#DiffSet
	instanceVariableNames:'changed onlyInReceiver onlyInArg same'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet
!

ChangeSet::ChangeFileReader subclass:#DolphinPACFileReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet
!

ChangeSet::ChangeProcessingError subclass:#InvalidChangeChunkError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet
!

ChangeSet::ChangeFileReader subclass:#SIFChangeFileReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSet
!

!ChangeSet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2015-2018 Jan Vrany
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
    used in the changes management to keep track of changes

    [author:]
	Claus Gittinger
"
! !

!ChangeSet class methodsFor:'instance creation'!

forExistingClass:aClass
    "build a changeSet for some given class, all of its private classes
     and all extensions if any.
     I.e. a changeSet which represents the existing class in the image.
     That does of course not give deltas, but instead reflects the current
     state of the given class.
     It is useful in conjunction with the other utility methods,
     for example, when building patchLists, diffSets, comparing etc."

    |changeSet s changeObject|

    "/ kludge: could do this much faster...
    s := ReadWriteStream on:''.
    aClass fileOutOn:s.
    s reset.
    changeSet := self fromStream:s.

    "/ fetch the real package info...
    changeSet do:[:eachChange |
	eachChange isMethodChange ifTrue:[
	    changeObject := eachChange changeMethod.
	    changeObject notNil ifTrue:[
		eachChange package:changeObject package
	    ].
	] ifFalse:[
	    eachChange isClassChange ifTrue:[
		changeObject := eachChange changeClass.
		changeObject notNil ifTrue:[
		    eachChange package:changeObject package
		].
	    ].
	].
    ].

    ^ changeSet

"/    |source changeSet chunk sawExcla lastTimeStamp s change nameSpace|

"/    changeSet := self new.
"/
"/    "/ first, a classDefinition change ...
"/    changeSet addClassDefinitionChangeFor:aClass.
"/    "/ are there any class-instVars ?
"/    aClass class instVarNames size > 0 ifTrue:[
"/        changeSet addInstVarDefinitionChangeFor:aClass class.
"/    ].
"/    "/ a comment ?
"/    aClass comment size > 0 ifTrue:[
"/        changeSet addClassCommentChangeFor:aClass.
"/    ].
"/
"/    "/ class methods first ...
"/    aClass class methodDictionary keysAndValuesDo:[:sel :mthd |
"/        changeSet addMethodChange:mthd in:aClass class.
"/    ].
"/
"/    "/ instance methods ...
"/    aClass methodDictionary keysAndValuesDo:[:sel :mthd |
"/        changeSet addMethodChange:mthd in:aClass.
"/    ].
"/
"/    ^ changeSet


    "
     ChangeSet forExistingClass:ChangeSet
     ChangeSet forExistingClass:A

     Rectangle hasExtensions
     ChangeSet forExistingClass:Rectangle
    "

    "Created: / 16-02-1998 / 12:19:34 / cg"
    "Modified: / 12-10-2006 / 23:45:14 / cg"
    "Modified (format): / 01-12-2011 / 19:10:22 / cg"
!

forExistingClass:aClass withExtensions:withExtensions
    "build a changeSet for some given full class with or without extensions.
     That does of course not give deltas, but instead reflects the current
     state of the given class.
     It is useful in conjunction with the other utility methods,
     for example, when building patchLists, diffSets etc."

    ^ self
	forExistingClass:aClass
	withExtensions:withExtensions
	withLooseMethods:false
	extensionsOnly:false

    "
     Object hasExtensions
     Object extensions size

     (ChangeSet forExistingClass:Object) size
     (ChangeSet forExistingClass:Object withExtensions:false) size

     (ChangeSet forExistingClass:stx_libbasic3 withExtensions:false)
    "

    "Created: / 12-10-2006 / 18:13:02 / cg"
    "Modified: / 12-10-2006 / 23:46:05 / cg"
!

forExistingClass:aClass withExtensions:withExtensions extensionsOnly:extensionsOnly
    "build a changeSet for some given full class, the base-class or the extensions only,
     as specified by the with-arguments.
     That does of course not give deltas, but instead reflects the current
     state of the given class.
     It is useful in conjunction with the other utility methods,
     for example, when building patchLists, diffSets etc."

    ^ self
	forExistingClass:aClass
	withExtensions:withExtensions
	withLooseMethods:false
	extensionsOnly:extensionsOnly

    "
     ChangeSet forExistingClass:ChangeSet

     Rectangle hasExtensions
     Rectangle extensions

     ChangeSet forExistingClass:Rectangle withExtensions:true extensionsOnly:false
     ChangeSet forExistingClass:Rectangle withExtensions:false extensionsOnly:false
     ChangeSet forExistingClass:Rectangle withExtensions:false extensionsOnly:true
    "

    "Created: / 12-10-2006 / 18:13:02 / cg"
    "Modified: / 12-10-2006 / 23:46:05 / cg"
!

forExistingClass:aClass withExtensions:withExtensions withLooseMethods:withLooseMethods
    "build a changeSet for some given full class with or without extensions.
     That does of course not give deltas, but instead reflects the current
     state of the given class.
     It is useful in conjunction with the other utility methods,
     for example, when building patchLists, diffSets etc."

    ^ self
	forExistingClass:aClass
	withExtensions:withExtensions
	withLooseMethods:withLooseMethods
	extensionsOnly:false

    "
     Object hasExtensions
     Object extensions size

     (ChangeSet forExistingClass:Object) size
     (ChangeSet forExistingClass:Object withExtensions:false) size

     (ChangeSet forExistingClass:stx_libbasic3 withExtensions:false)
    "

    "Created: / 12-10-2006 / 18:13:02 / cg"
    "Modified: / 12-10-2006 / 23:46:05 / cg"
!

forExistingClass:aClass withExtensions:withExtensions withLooseMethods:withLooseMethods extensionsOnly:extensionsOnly
    "build a changeSet for some given full class, the base-class or the extensions only,
     as specified by the with-arguments.
     That does of course not give deltas, but instead reflects the current
     state of the given class.
     It is useful in conjunction with the other utility methods,
     for example, when building patchLists, diffSets etc."

    |changeSet classPackage notInClassesPackage realExtensions looseMethods|

    changeSet := self forExistingClass:aClass.
    classPackage := aClass package.

    notInClassesPackage :=
		[:change |
		    change isMethodChange
		    and:[ change package ~= classPackage ]
		].

    realExtensions :=
		[:change |
		    change isMethodChange
		    and:[ change package ~= classPackage
		    and:[ change package ~~ PackageId noProjectID ]]
		].

    looseMethods :=
		[:change |
		    change isMethodChange
		    and:[change package == PackageId noProjectID ]
		].

    extensionsOnly ifTrue:[
	withLooseMethods ifTrue:[
	    ^ changeSet select:notInClassesPackage
	].

	^ changeSet select:realExtensions.
    ].

    withExtensions ifFalse:[
	withLooseMethods ifFalse:[
	    ^ changeSet reject:notInClassesPackage
	].

	^ changeSet reject:realExtensions.
    ].

    withLooseMethods ifFalse:[
	^ changeSet reject:looseMethods.
    ].

    ^ changeSet

    "
     ChangeSet forExistingClass:ChangeSet

     Rectangle hasExtensions
     Rectangle extensions

     ChangeSet forExistingClass:Rectangle withExtensions:true extensionsOnly:false
     ChangeSet forExistingClass:Rectangle withExtensions:false extensionsOnly:false
     ChangeSet forExistingClass:Rectangle withExtensions:false extensionsOnly:true
    "

    "Created: / 12-10-2006 / 18:13:02 / cg"
    "Modified: / 12-10-2006 / 23:46:05 / cg"
!

forExistingMethods:aCollectionOfMethods
    "build a changeSet for a collection of methods in the image.
     That does of course not give deltas, but instead reflects the current
     state of the given set of methods.
     It is useful in conjunction with the other utility methods,
     for example, when building patchLists, diffSets etc."

    |changeSet stream previousPackage|

    changeSet := self new.
    aCollectionOfMethods do:[:eachMethod |
        |change source|

        source := eachMethod source.
        source isNil ifTrue:[
            Transcript showCR:'oops - no source for ',eachMethod whoString.
        ].
        change := MethodDefinitionChange new.
        eachMethod mclass notNil ifTrue:[ change className:eachMethod mclass name ].
        source notNil ifTrue:[ change source:source ].
        change selector:eachMethod selector.
        change package:(eachMethod package).
        change category:(eachMethod category).
        changeSet add:change.
    ].

"/    stream := ReadWriteStream on:''.
"/    aCollectionOfMethods do:[:eachMethod |
"/        previousPackage ~= eachMethod package ifTrue:[
"/            stream nextPutAll:'"{ Package: '''.
"/            stream nextPutAll:eachMethod package asString.
"/            stream nextPutAll:''' }"'; cr; cr.
"/        ].
"/        eachMethod mclass fileOutMethod:eachMethod on:stream
"/    ].
"/    stream reset.
"/    changeSet := self fromStream:stream.
"/    changeSet do:[:eachChange |
"/        eachChange package:(eachChange changeMethod package).
"/    ].
    ^ changeSet

    "
     ChangeSet forExistingMethods:(Array with:(Array compiledMethodAt:#at:)
                                         with:(Object compiledMethodAt:#at:)
                                         with:(Behavior compiledMethodAt:#compiledMethodAt:) )
    "

    "Modified: / 17-09-2011 / 10:26:03 / cg"
!

forPackage: pkg
    "build a changeSet for a given package in the image"

    ^self forPackage: pkg ignoreAutoloaded: false.

    "Created: / 20-05-2008 / 17:56:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 12-08-2009 / 14:23:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

forPackage: pkg ignoreAutoloaded: ignoreAutoloaded
    "build a changeSet for a given package in the image"

    |changeSet packageClasses packageExtensions|

    packageClasses := ProjectDefinition searchForClassesWithProject: pkg.
    packageClasses := packageClasses select:[:each | each programmingLanguage isSmalltalk ].
    packageExtensions := ProjectDefinition searchForExtensionsWithProject: pkg.
    packageExtensions := packageExtensions select:[:each | each programmingLanguage isSmalltalk ].
    changeSet := self forExistingMethods: packageExtensions.
    packageClasses do:[:cls|
        (ignoreAutoloaded not and:[cls isLoaded not]) ifTrue:[cls autoload].
        cls isLoaded ifTrue: [
            changeSet addAll: (self forExistingClass:cls withExtensions:false)
        ]
    ].
    changeSet name: 'Package ' , pkg.
    ^changeSet

    "Created: / 12-08-2009 / 14:22:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 31-07-2014 / 09:51:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromBeeStream:aStream
    "build a changeSet from a Bee Smalltalk .bsc format stream, containing chunks.
     Return the changeSet."

    ^ self fromBeeStream:aStream while:[:thisChange | true]

    "Created: / 21-08-2014 / 18:34:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromBeeStream:aStream while:aConditionBlock
    "build a changeSet from a Bee Smalltalk .bsc stream, containing chunks
     Pass each change to the conditionBlock and stop whenever that
     returns false. This allows skipping reamaining chunks, and speeding up
     reading, if only parts need to be extracted
     (for example: only documentation methods).
     Return the changeSet."

    |changeSet|

    changeSet := self new.
    self
	changesFromStream:aStream
	for:changeSet
	reader:(BeeChangeFileReader new)
	do:[:aChange :lineNumberOrNil :posOrNil |
	    changeSet add:aChange.
	    (aConditionBlock value:aChange) ifFalse:[^ changeSet].
	].

    ^ changeSet

    "Created: / 21-08-2014 / 18:34:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromDiffSet:aDiffSet
    "build a changeSet from a given diffSet. This can be used as a patchSet,
     to update the first-version in the diffSet to the second-version"

    |changeSet|

    changeSet := self new.
    "/ class definitions first...
    changeSet addAll:((aDiffSet changed collect:[:eachPair | eachPair second]) select:[:ch | ch isClassDefinitionChange]).
    changeSet addAll:((aDiffSet onlyInArg) select:[:ch | ch isClassDefinitionChange]).

    "/ first add new methods...
    changeSet addAll:((aDiffSet onlyInArg) reject:[:ch | ch isClassDefinitionChange]).
    "/ then, changed methods...
    changeSet addAll:((aDiffSet changed collect:[:eachPair | eachPair second]) reject:[:ch | ch isClassDefinitionChange]).
    "/ then, removed methods...
    aDiffSet onlyInReceiver do:[:each |
	|ch|

	ch := MethodRemoveChange className:(each className) selector:(each selector).
	changeSet add:ch.
    ].
    ^ changeSet

    "Created: / 08-02-2011 / 10:48:36 / cg"
!

fromDirectory: aStringOfFilename
    "Read all .st files (non-recursively) from `aStringOrFilename`.
     Return the resuling ChangeSet"

    ^ self fromDirectory: aStringOfFilename asSmalltalkXPackage: false.

    "Created: / 02-04-2011 / 00:54:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2013 / 17:36:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromDirectory: aStringOfFilename asSmalltalkXPackage: isSmalltalkXPackage
    "Read all .st files (non-recursively) from `aStringOrFilename`
     Return the resuling ChangeSet.

     If `isSmalltalkXPacklage` is true, then treat directory as Smalltalk/X
     package directory as checked out from a VCS. Read only those files
     present in abbrev.stc (if present)."

    | directory abbrevFile filter |

    directory := aStringOfFilename asFilename.
    (isSmalltalkXPackage and:[(abbrevFile := directory asFilename / 'abbrev.stc') exists]) ifTrue:[
	| files |

	files := OrderedCollection new.
	files add:'extensions.st'.
	(directory asFilename / 'abbrev.stc') readingFileDo:[:s |
	    Smalltalk withAbbreviationsFromStream: s do:[:className :abbrev :pkg  | files add: (abbrev , '.st')]
	].
	filter := [:filename | files includes: filename baseName ]
    ] ifFalse:[
	filter := [:filename | filename  suffix = 'st' ]
    ].
    ^ self fromDirectory: aStringOfFilename filter: filter

    "Created: / 02-12-2013 / 17:36:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-02-2014 / 19:05:14 / cg"
!

fromDirectory: aStringOrFilename filter: filter
    "Read all files (non-recursively) from `aStringOrFilename` for which the
     filter return true. Return the resuling ChangeSet"

    | d cs files step |

    d := aStringOrFilename asFilename.
    cs := self new.
    files := (d directoryContentsAsFilenames) select:filter.
    step :=  100 / files size.
    files withIndexDo: [:each :index |
	ProgressNotification notify: 'Reading ', each baseName progress: (step * (index - 1)).
	[
	    cs addAll: (self fromFileOrDirectory: each)
	] on: ProgressNotification do:[:ex |
	    ex proceed.
	].
    ].
    ProgressNotification notify: nil progress: 100.
    cs name: aStringOrFilename asFilename asAbsoluteFilename pathName.
    ^cs


    "
	ChangeSet fromDirectory: (Smalltalk getPackageDirectoryForPackage:'stx:libbasic')
    "

    "Created: / 12-11-2013 / 15:24:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromDolphinPACStream:aStream
    "build a changeSet from a stream, containing dolphin pac file chunks."

    ^ self fromDolphinPACStream:aStream while:[:thisChange | true]

!

fromDolphinPACStream:aStream while:aConditionBlock
    "build a changeSet from a stream, containing dolphin pac file chunks.
     Pass each change to the conditionBlock and stop whenever that
     returns false. This allows skipping reamaining chunks, and speeding up
     reading, if only parts need to be extracted
     (for example: only documentation methods)."

    |changeSet|

    changeSet := self new.
    self
	changesFromStream:aStream
	for:changeSet
	reader:(DolphinPACFileReader new)
	do:[:aChange :lineNumberOrNil :posOrNil |
	    changeSet add:aChange.
	    (aConditionBlock value:aChange) ifFalse:[^ changeSet].
	].

    ^ changeSet
!

fromFile:filenameOrString
    "build a changeSet from a file, which contains chunks.
     (i.e. either a classes sourceFile or a change-file).
     Return the changeSet."

    |filename suffix mime stream changeSet|

    filename := filenameOrString asFilename.
    suffix := filename suffix.
    ((suffix = 'bsc') or:[suffix = 'ch']) ifTrue:[
        filename readingFileDo:[:stream |
            changeSet := self fromBeeStream:stream.
        ].
        changeSet name: filename baseName.
        ^ changeSet
    ].

    mime := MIMETypes mimeTypeForFilename:filename.
    mime isNil ifTrue:[
        mime := filename mimeTypeOfContents.
        mime isNil ifTrue:[
            "/ self error:'unknown MIME type for file' mayProceed:true.

            "/ assume chunk format
            mime := 'text/plain'.
        ].
    ].

    [
        stream := filename readStream.
        mime = 'text/xml' ifTrue:[
            changeSet := self fromXMLStream:stream.
        ] ifFalse:[
            mime = 'application/x-smalltalk-source-sif' ifTrue:[
                changeSet := self fromSIFStream:stream.
            ] ifFalse:[
                mime = 'application/x-smalltalk-dolphin-package' ifTrue:[
                    changeSet := self fromDolphinPACStream:stream.
                ] ifFalse:[
                    stream := EncodedStream decodedStreamFor:stream.
                    changeSet := self fromStream:stream.
                ]
            ]
        ]
    ] ensure:[
        stream notNil ifTrue:[stream close].
    ].
    changeSet name: filename baseName.
    ^ changeSet

    "
     ChangeSet fromFile: 'st.chg'
     ChangeSet fromFile: 'patches'
    "

    "Created: / 16-02-1998 / 12:19:34 / cg"
    "Modified (comment): / 28-07-2012 / 09:41:40 / cg"
    "Modified: / 26-02-2018 / 11:17:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromFileOrDirectory: fileOrDirectory
    "Read either a single .st-file, or all .st files (non-recursively) in a directory.
     Return the resuling ChangeSet"

    | f changeSet|

    f := fileOrDirectory asFilename.
    changeSet := 
        f isDirectory
            ifTrue:[self fromDirectory: f]
            ifFalse:[self fromFile: f].
    changeSet name: f pathName.
    ^ changeSet

    "
     ChangeSet fromFileOrDirectory: (Smalltalk getPackageDirectoryForPackage:'stx:libbasic')
    "

    "Created: / 02-04-2011 / 00:50:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromSIFStream:aStream
    "build a changeSet from a SIF stream, containing chunks
     in smalltalk interchange format.
     Return the changeSet."

    ^ self fromSIFStream:aStream while:[:thisChange | true]
!

fromSIFStream:aStream while:aConditionBlock
    "build a changeSet from a SIF stream, containing chunks
     in smalltalk interchange format.
     Pass each change to the conditionBlock and stop whenever that
     returns false. This allows skipping reamaining chunks, and speeding up
     reading, if only parts need to be extracted
     (for example: only documentation methods).
     Return the changeSet."

    |changeSet|

    changeSet := self new.
    self
	changesFromStream:aStream
	for:changeSet
	reader:(SIFChangeFileReader new)
	do:[:aChange :lineNumberOrNil :posOrNil |
	    changeSet add:aChange.
	    (aConditionBlock value:aChange) ifFalse:[^ changeSet].
	].

    ^ changeSet
!

fromStream:aStream
    "build a changeSet from a stream, containing chunks.
     (i.e. either a classes sourceFile or a change-file).
     Return the changeSet."

    ^ self fromStream:aStream while:[:thisChange | true]

    "
     ChangeSet fromStream:('changes' asFilename readStream)
     ChangeSet fromStream:('patches' asFilename readStream)
     ChangeSet fromStream:(Object source asString readStream)
    "

    "Created: / 16.2.1998 / 12:19:34 / cg"
    "Modified: / 14.12.1999 / 15:23:16 / cg"
!

fromStream:aStream while:aConditionBlock
    "build a changeSet from a stream, containing chunks.
     (i.e. either a classes sourceFile or a change-file).
     Pass each change to the conditionBlock and stop whenever that returns false. 
     This allows skipping reamaining chunks, 
     and thus speeding up reading, if only parts need to be extracted
     (for example: only documentation methods, 
      or espcially if only class definition changes up to the first method change are required).
     Returns the changeSet."

    |changeSet|

    changeSet := self new.
    self
        changesFromStream:aStream
        for:changeSet
        reader:(ChangeFileReader new)
        do:[:aChange :lineNumberOrNil :posOrNil |
            (aConditionBlock value:aChange) ifFalse:[^ changeSet].
            changeSet add:aChange.
        ].

    ^ changeSet

    "
     ChangeSet fromStream:('changes' asFilename readStream)
     ChangeSet fromStream:('patches' asFilename readStream)
     ChangeSet fromStream:(Object source asString readStream)
     ChangeSet fromStream:(XWorkstation source asString readStream)
    "

    "Created: / 16-02-1998 / 12:19:34 / cg"
    "Modified: / 14-12-1999 / 15:23:16 / cg"
    "Modified (comment): / 01-08-2012 / 15:24:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromXMLStream:aStream
    "build a changeSet from an XML stream, containing XML change definitions in VisualWorks XML change file format.
     Return the changeSet."

    |changeSet builder nameSpace|

    aStream isNil ifTrue:[^ nil].

    changeSet := self new.
    nameSpace := Smalltalk.

    builder := XML::SourceScannerNodeBuilder new.
    builder scanFile:aStream do:[:change | changeSet add: change. ].
    ^ changeSet

    "
     ChangeSet fromXMLStream:('../../goodies/xml/vw/xmlFileInTests/XMLParser.xml' asFilename readStream)
     ChangeSetBrowser
        openOn:(ChangeSet fromXMLStream:('../../goodies/xml/vw/xmlFileInTests/XMLParser.xml' asFilename readStream))
    "
! !

!ChangeSet class methodsFor:'Compatibility-ST80'!

patches
    ^ #()

    "Created: / 27.10.1997 / 13:52:54 / cg"
! !


!ChangeSet class methodsFor:'Compatibility-VW'!

component: component definition: anObject change: changeSymbol
    "Include indication that a class/namespace was added or removed
     from a CodeComponent."

    self
	changed:#'component:definition:change:'
	with:
	    ( Array
		    with: component
		    with: anObject
		    with: changeSymbol
	    )

! !

!ChangeSet class methodsFor:'instance creation-private'!

changesFromStream:aStream do:aBlock
    "enumerate changes from a stream and invoke aBlock on each.
     The block is invoked with the change, a lineNumberOrNil and streamPosition arguments.
     The lineNumber is only valid, if the underlying stream
     provides line-numbers; otherwise, nil is passed."

    ^ self
	changesFromStream:aStream
	for:(self new)
	reader:nil
	do:aBlock

    "
     ChangeSet
	changesFromStream:('changes' asFilename readStream)
	do:[:chg | Transcript showCR:chg]
    "

    "Created: / 16.2.1998 / 12:19:34 / cg"
    "Modified: / 14.12.1999 / 15:23:16 / cg"
!

changesFromStream:aStream for:aChangeSet reader:aReader do:aBlock
    "enumerate changes from a stream and invoke aBlock on each.
     The block is invoked with the change, a lineNumberOrNil and streamPosition arguments.
     The lineNumber is only valid, if the underlying stream
     provides line-numbers; otherwise, nil is passed."

    |encodedStream chunk s change currentNameSpace currentPackage defaultPackage
     lineNumber pos reader reportProgress size |

    aStream isNil ifTrue:[^ self].

    currentNameSpace := Smalltalk.
    currentPackage := defaultPackage := Class packageQuerySignal query.

    (reader := aReader) isNil ifTrue:[
        reader := ChangeFileReader new.
    ].

    aStream isEncodedStream ifTrue:[
        encodedStream := aStream
    ] ifFalse:[
        aStream isPositionable ifTrue:[
            encodedStream := EncodedStream decodedStreamFor: aStream
        ] ifFalse:[
            encodedStream := EncodedStream stream: aStream encoder: CharacterEncoder nullEncoderInstance
        ].
    ].
    reportProgress := encodedStream stream isPositionable
                        and:[ ProgressNotification notNil
                        and:[ ProgressNotification isHandled ]].
    reportProgress ifTrue:[
        size := encodedStream stream size.
    ].

    reader changeSet:aChangeSet.
    reader changeAction:aBlock.
    reader inputStream:encodedStream.

    [encodedStream atEnd] whileFalse:[
        encodedStream skipSeparators.
        lineNumber := encodedStream lineNumber.


        reportProgress ifTrue:[
            pos := encodedStream position + 1.
            ProgressNotification notify: nil progress:(100 / size) * pos.
        ].

        chunk := encodedStream nextChunk.

        (chunk notEmptyOrNil) ifTrue:[
            Class nameSpaceQuerySignal handle:[:ex| ex proceedWith:currentNameSpace] do:[
                Class packageQuerySignal handle:[:ex| ex proceedWith:currentPackage] do:[
                    |parser tree ns pkg|

                    parser := Parser for:chunk.
                    "/ parser parseForCode.
                    Parser parseErrorSignal handle:[:ex |
                        Transcript showCR:'ChangeSet: error while reading: ',ex description.
                        tree := #Error.
                    ] do:[
                        tree := parser
                                parseExpressionWithSelf:nil
                                notifying:nil
                                ignoreErrors:true
                                ignoreWarnings:true
                                inNameSpace:currentNameSpace.
                    ].
                    tree ~~ #Error ifTrue:[
                        tree isNil ifTrue:[
                            "/ Hmm....it could be package-definition chunk in extensions container...
                            "/ if there is any package directive in there, extract it.
                            ((pkg := parser currentPackage) notNil
                            and:[pkg ~~ currentPackage]) ifTrue:[
                                currentPackage := pkg
                            ] ifFalse:[
                                "/ if there is any nameSpace directive in there, extract it.
                                ((ns := parser currentNameSpace) notNil
                                and:[ns ~~ currentNameSpace]) ifTrue:[
                                    currentNameSpace := ns
                                ] ifFalse:[
                                    change := DoItChange new.
                                    change source:chunk.
                                    aBlock valueWithOptionalArgument:change and:lineNumber and:pos.
                                ].
                            ].
                        ] ifFalse:[
                            "/ if there is any nameSpace directive in there, extract it.
                            ((ns := parser currentNameSpace) notNil
                            and:[ns ~~ currentNameSpace]) ifTrue:[
                                currentNameSpace := ns
                            ].
                            "/ if there is any package directive in there, extract it.
                            ((pkg := parser currentPackage) notNil
                            and:[pkg ~~ currentPackage]) ifTrue:[
                                currentPackage := pkg
                            ].
                            "/
                            "/ what type of chunk is this ...
                            "/
                            tree isLiteral ifTrue:[
                                (s := tree evaluate) isString ifTrue:[
                                    (s startsWith:'---- ') ifTrue:[
                                        (s startsWith:'---- timestamp') ifTrue:[ 
                                            "/ Beginning of next record in changelog. Reset all
                                            "/ previously set namespaces and packages
                                            currentPackage := defaultPackage.
                                            currentNameSpace := Smalltalk.
                                        ]. 
                                        reader inputStream: s readStream.
                                        reader processInfo: s.
                                        reader inputStream: encodedStream.
                                    ].
                                ] ifFalse:[
                                    self error:'unexpected change-chunk' mayProceed:true
                                ]
                            ] ifFalse:[
                                tree isMessage ifTrue:[
                                    (reader
                                        changesFromParseTree:tree
                                        lineNumber:lineNumber
                                        position:pos
                                        chunk: chunk
                                    ) ifFalse:[
                                        change := DoItChange new.
                                        change source:chunk.
                                        aBlock valueWithOptionalArgument:change and:lineNumber and:pos.
                                    ]
                                ] ifFalse:[
                                    InvalidChangeChunkError
                                        raiseRequestErrorString:('unexpected change-chunk in or around line %1' bindWith:lineNumber)
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].

    "
     ChangeSet fromStream:('changes' asFilename readStream)
     ChangeSet fromStream:('patches' asFilename readStream)
     ChangeSet fromStream:(Object source asString readStream)
    "

    "Created: / 16-02-1998 / 12:19:34 / cg"
    "Modified: / 30-07-2013 / 21:34:16 / cg"
    "Modified: / 26-04-2016 / 22:52:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet class methodsFor:'queries'!

current
    "ST-80 compatibility: return the current changeSet"

    |p|

    (Project notNil and:[(p := Project current) notNil]) ifTrue:[
	^ p changeSet
    ].
    ^ #()

    "
     ChangeSet current
    "
! !

!ChangeSet class methodsFor:'signal access'!

invalidChangeChunkError
    ^ InvalidChangeChunkError
! !

!ChangeSet class methodsFor:'utilities'!

decodedStreamFor:aStream
    <resource: #obsolete>
    ^ EncodedStream decodedStreamFor:aStream
! !

!ChangeSet methodsFor:'Compatibility-ST80'!

changeClass:aClass

    "dummy here"

    "Created: / 04-02-2000 / 18:30:59 / cg"
    "Modified (format): / 05-09-2012 / 16:39:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSelectors
    "return a collection (a set) of all selectors for which changes are in this changeSet"

    |selectors|

    changeSelectors isNil ifTrue:[
        selectors := IdentitySet new.
        self do:[:chg |
            |sel|

            chg notNil ifTrue:[
                chg isMethodChange ifTrue:[
                    sel := chg selector.
                    sel notNil ifTrue:[
                        selectors add:sel
                    ]
                ]
            ]
        ].
        changeSelectors := selectors.
    ].
    ^ changeSelectors.

    "
     ChangeSet current changeSelectors
    "

    "Modified: / 30-05-2007 / 12:12:32 / cg"
!

changedClasses
    "return a collection of all classes for which changes are in this changeSet"

    |classes|

    changedClasses isNil ifTrue:[
	classes := IdentitySet new.
	self do:[:chg |
	    |cls|

	    chg notNil ifTrue:[
		cls := chg changeClass.
		cls notNil ifTrue:[
		    cls isRealNameSpace ifFalse:[
			classes add:cls
		    ]
		]
	    ]
	].
	changedClasses := classes.
    ].
    ^ changedClasses.

    "
     ChangeSet current changedClasses
     ChangeSet current flushChangedClassesCache
    "

    "Modified: / 10-11-2006 / 17:17:26 / cg"
!

component:component definition:anObject change:changeSymbol
    "Include indication that a class/namespace was added or removed
     from a CodeComponent."

    self
	changed:#'component:definition:change:'
	with:
	    ( Array
		    with: component
		    with: anObject
		    with: changeSymbol
	    )
!

reorganizeSystem
    "dummy here"

    "Created: / 6.2.2000 / 20:45:10 / cg"
! !

!ChangeSet methodsFor:'accessing'!

name
    ^ name
!

name:aString
    name := aString.

    "Modified (format): / 28-07-2012 / 09:34:52 / cg"
! !

!ChangeSet methodsFor:'change & update'!

changed:anAspectSymbol with:aParameter
    "Allow objects to depend on the ChangeSet class instead of a particular instance
     of ChangeSet (which may be switched using projects)."

    self == self class current ifTrue:[
        self class changed:anAspectSymbol with:aParameter.
    ].
    super changed:anAspectSymbol with:aParameter
! !

!ChangeSet methodsFor:'changes management'!

addClassCommentChangeFor:aClass
    "add a classComment change to the receiver"

    |newChange|

    newChange := ClassCommentChange class:aClass.
    newChange comment:aClass comment.
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Modified: / 14.11.2001 / 13:35:34 / cg"
!

addClassDefinitionChangeFor:aClass
    "add a classDefinition change to the receiver"

    |newChange|

    newChange := ClassDefinitionChange class:aClass source:(aClass definition).
    newChange package:aClass package.
    self rememberChangedClass:aClass.
    self addChange:newChange

    "
     (ChangeSet new addClassDefinitionChangeFor:ChangeSet) inspect
    "

    "Modified: / 12-10-2006 / 18:17:02 / cg"
!

addClassRemoveChange:oldClass
    "add a classRemove change to the receiver"

    |newChange|

    newChange := ClassRemoveChange new className:oldClass name.
    self rememberChangedClass:oldClass.
    oldClass isPrivate ifTrue:[
	self rememberChangedClass:oldClass topOwningClass.
    ].
    ClassRemoveChange::ClassBeingRemovedQuery
	answer:oldClass
	do:[
	    self addChange:newChange
	]
    "Modified: / 14.11.2001 / 13:35:39 / cg"
!

addClassRenameChangeFrom:oldName to:newName
    "add a classRename change to the receiver"

    |newChange|

    newChange := ClassRenameChange new oldName:oldName newName:newName.
    self rememberChangedClass:(Smalltalk at:newName).
    self addChange:newChange

    "Modified: / 14.11.2001 / 13:35:41 / cg"
!

addDoIt:aString
    "add a doIt to the receiver"

    |newChange|

    newChange := DoItChange new source:aString.
    self addChange:newChange.

    "Modified: / 14.11.2001 / 13:35:44 / cg"
!

addInstVarDefinitionChangeFor:aClass
    "add an instVarDefinition change to the receiver"

    |newChange|

    newChange := ClassInstVarDefinitionChange
			class:aClass
			source:(aClass name , ' instanceVariableNames:' , aClass instanceVariableString storeString).
    newChange classInstVarNames:aClass instanceVariableString asCollectionOfWords.
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Modified: / 25-11-2011 / 17:38:42 / cg"
!

addMethodCategoryChange:aMethod category:newCategory in:aClass
    "add a methodCategory change to the receiver"

    |newChange|

    newChange := MethodCategoryChange
			class:aClass
			selector:(aClass selectorAtMethod:aMethod)
			category:newCategory.
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Modified: / 14.11.2001 / 13:35:48 / cg"
!

addMethodChange:aMethod fromOld:oldMethod in:aClass
    "add a method change to the receiver"

    |newChange|

    newChange := MethodDefinitionChange
			class:aClass
			selector:aMethod selector
			source:aMethod source
			category:aMethod category.
    oldMethod notNil ifTrue:[
	newChange previousVersion:oldMethod.
    ].
    self rememberChangedClass:aClass.
    self addChange:newChange.

    "Modified: / 14.11.2001 / 13:35:50 / cg"
!

addMethodChange:aMethod in:aClass
    "add a method change to the receiver"

    |newChange|

    newChange := MethodDefinitionChange
			class:aClass
			selector:aMethod selector
			source:aMethod source
			category:aMethod category.
    newChange package:(aMethod package).
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Modified: / 12-10-2006 / 18:15:28 / cg"
!

addMethodPackageChange:aMethod package:newPackage in:aClass
    "add a methodPackage change to the receiver"

    |newChange selector|

    selector := (aClass selectorAtMethod:aMethod).
    selector isNil ifTrue:[^ self].

    newChange := MethodPackageChange
			class:aClass
			selector:selector
			package:newPackage.
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Created: / 09-10-2006 / 14:02:33 / cg"
!

addMethodPrivacyChange:aMethod in:aClass
    "add a methodPrivacy change to the receiver"

    |newChange|

    newChange := MethodPrivacyChange
			class:aClass
			selector:(aClass selectorAtMethod:aMethod)
			privacy:aMethod privacy.
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Modified: / 27.8.1995 / 22:55:22 / claus"
    "Modified: / 14.11.2001 / 13:35:55 / cg"
!

addPrimitiveDefinitionsChangeFor:aClass
    "add a primitiveDefinitions change to the receiver"

    |newChange|

    newChange := ClassPrimitiveDefinitionsChange new
			class:aClass source:(aClass primitiveDefinitionsString).
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Modified: / 14.11.2001 / 13:35:57 / cg"
!

addPrimitiveFunctionsChangeFor:aClass
    "add a primitiveFunctions change to the receiver"

    |newChange|

    newChange := ClassPrimitiveFunctionsChange new
			class:aClass source:(aClass primitiveFunctionsString).
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Modified: / 14.11.2001 / 13:35:59 / cg"
!

addPrimitiveVariablesChangeFor:aClass
    "add a primitiveVariables change to the receiver"

    |newChange|

    newChange := ClassPrimitiveVariablesChange new
			 class:aClass source:(aClass primitiveVariablesString).
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Modified: / 14.11.2001 / 13:36:01 / cg"
!

addRemoveSelectorChange:aSelector fromOld:oldMethod in:aClass
    "add a method-remove change to the receiver"

    |newChange|

    newChange := MethodRemoveChange class:aClass selector:aSelector.
    oldMethod notNil ifTrue:[
	newChange previousVersion:oldMethod.
    ].
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Modified: / 27.8.1995 / 22:55:22 / claus"
    "Created: / 16.2.1998 / 12:47:07 / cg"
    "Modified: / 14.11.2001 / 13:36:04 / cg"
!

addRenameCategoryChangeIn:aClass from:oldCategory to:newCategory
    "add a category rename change to the receiver"

    |newChange|

    newChange := MethodCategoryRenameChange class:aClass.
    newChange oldCategoryName:oldCategory newCategoryName:newCategory.
    self rememberChangedClass:aClass.
    self addChange:newChange

    "Modified: / 14.11.2001 / 13:36:06 / cg"
! !

!ChangeSet methodsFor:'enumerating'!

rejectAllVersionMethodChanges
    "Return a new ChangeSet without version_XXX methods"

    ^ self reject:[:each | each isMethodCodeChange and:[(AbstractSourceCodeManager isVersionMethodSelector: each selector) ]].

    "Created: / 06-01-2014 / 21:13:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet methodsFor:'fileIn / fileOut'!

fileInFrom:aStream
    self fileInFrom:aStream while:[:change | true]
!

fileInFrom:aStream while:aConditionBlock
    self class
	changesFromStream:aStream
	for:self
	reader:(ChangeFileReader new)
	do:[:aChange :lineNumberOrNil :posOrNil |
	    self add:aChange.
	    (aConditionBlock value:aChange) ifFalse:[^ self].
	].
!

fileOutAs: aStringOrFilename
    | stream |

    stream := aStringOrFilename asFilename writeStream.

    stream nextPutLine:'''---- encoding: utf8 ----''!!'.
    stream := EncodedStream stream:stream encoder:(CharacterEncoder encoderForUTF8).

    [ 
        self fileOutOn: stream 
    ] ensure: [
        stream close
    ]

    "Created: / 05-12-2009 / 12:33:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutOn: stream

    self do:[:chg|chg fileOutOn: stream]

    "Created: / 05-12-2009 / 12:32:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!ChangeSet methodsFor:'misc'!

addPatch:nameOfPatch
    "ignored for now - allows fileIn of ST-80 patch stuff .."

    ^ self
! !


!ChangeSet methodsFor:'private-accessing'!

addChange:aChange
    |changeClass|

    aChange timeOfChangeIfKnown isNil ifTrue:[
	aChange timeStamp:(Timestamp now).
    ].

    self add:aChange.
    changedClasses notNil ifTrue:[
	(changeClass := aChange changeClass) notNil ifTrue:[
	    changedClasses add:changeClass.
	].
    ].
    changeSelectors notNil ifTrue:[
	aChange isMethodChange ifTrue:[
	    changeSelectors add:aChange selector.
	].
    ].

"/    aChange sendChangeNotificationThroughSmalltalk.
    self changed:#addChange: with:aChange.

    "Created: / 14-11-2001 / 13:35:11 / cg"
    "Modified: / 10-11-2006 / 16:47:13 / cg"
!

flushChangedClassesCache
    changedClasses := changeSelectors := nil

    "
     ChangeSet current flushChangedClassesCache
    "
!

rememberChangedClass:aClass
    changedClasses notNil ifTrue:[
	changedClasses add:aClass
    ].
!

removeAll:aCollection
    aCollection notEmpty ifTrue:[
	super removeAll:aCollection.
	changedClasses := changeSelectors := nil.
	self changed:#removeAll: with:aCollection.
    ]
!

unrememberChangedClasses
    changedClasses := nil
! !

!ChangeSet methodsFor:'queries'!

changedPackages
    "return a collection of all packages for which changes are in this changeSet"

    |classes changedPackages|

    changedPackages := Set new.

    self do:[:chg |
	|p mthd cls|

	p := chg package.
	p isNil ifTrue:[
	    chg isMethodChange ifTrue:[
		mthd := chg changeMethod.
		mthd notNil ifTrue:[
		    p := mthd package.
		] ifFalse:[
		    cls := chg changeClass.
		    cls notNil ifTrue:[
			p := cls package.
		    ]
		]
	    ] ifFalse:[
		chg isClassChange ifTrue:[
		    cls := chg changeClass.
		    cls notNil ifTrue:[
			p := cls package.
		    ]
		]
	    ].
	].
	p notNil ifTrue:[
	    changedPackages add:p.
	]
    ].

"/    self changedClasses do:[:cls |
"/        |p|
"/
"/        (p := cls package) notNil ifTrue:[
"/            changedPackages add:p.
"/        ]
"/    ].
    ^ changedPackages.

    "
     ChangeSet current changedPackages
    "

    "Created: / 22-09-2006 / 16:37:40 / cg"
    "Modified: / 13-10-2006 / 01:20:48 / cg"
!

changesForPackage:aPackageSymbol
    ^(self select:[:aChange |
	|includeThis mClass mthd|

	includeThis := false.
	(aChange isMethodChange or:[aChange isMethodRemoveChange]) ifTrue:[
	    mClass := aChange changeClass.
	    mClass notNil ifTrue:[
		mthd := mClass compiledMethodAt:(aChange selector).
		mthd isNil ifTrue:[
		    aChange isMethodRemoveChange ifTrue:[
			includeThis := (mClass package = aPackageSymbol)
		    ].
		] ifFalse:[
		    includeThis := (mthd package = aPackageSymbol)
		]
	    ].
	] ifFalse:[
	    (aChange isClassChange) ifTrue:[
		(aChange changeClass notNil) ifTrue:[
		    includeThis := (aChange changeClass package = aPackageSymbol)
		].
	    ].
	].
	includeThis
    ])

    "
     ChangeSet current changesForPackage:#'stx:goodies/libsvn'
    "

    "Created: / 05-11-2001 / 14:21:17 / cg"
    "Modified: / 12-10-2006 / 16:51:27 / cg"
    "Modified: / 22-10-2008 / 13:25:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (comment): / 26-07-2012 / 11:54:00 / cg"
!

classDefinitionChanges
    ^ self select:[:chg | chg isClassDefinitionChange] as:OrderedCollection.
!

includesChangeForClass:aClass
    |nameOfClass|

    nameOfClass := aClass theNonMetaclass name.
    ^ self includesChangeForClassNamed:nameOfClass

    "
     ChangeSet current includesChangeForClass:ChangeSet
     ChangeSet current includesChangeForClass:ChangeSet class
     ChangeSet current includesChangeForClass:SourceCodeManagerUtilities
     ChangeSet current includesChangeForClass:(Expecco::ExpeccoXMLDecoder::ObjectCreator)
    "

    "Modified: / 09-10-2006 / 13:39:22 / cg"
!

includesChangeForClass:aClass selector:selector
    |nameOfNonMetaClass nameOfClass|

    (self changeSelectors includes:selector) ifFalse:[^ false].

    nameOfNonMetaClass := aClass theNonMetaclass name.
    (self changedClasses contains:[:someClass | someClass theNonMetaclass name = nameOfNonMetaClass]) ifFalse:[^ false].

    nameOfClass := aClass name.

    ^ self contains:[:aChange | (selector = aChange selector) and:[nameOfClass = aChange className]]

    "
     ChangeSet current includesChangeForClass:ChangeSet selector:#includesChangeForClass:
    "

    "Created: / 31.10.2001 / 10:26:31 / cg"
    "Modified: / 31.10.2001 / 10:59:49 / cg"
!

includesChangeForClassNamed:aClassName
    (self changedClasses contains:[:aClass | aClass theNonMetaclass name = aClassName]) ifFalse:[^ false].
    ^ self contains:[:aChange | aChange className = aClassName]

    "
     ChangeSet current includesChangeForClassNamed:'ChangeSet'
    "
!

includesChangeForClassOrMetaclass:aClass
    |nameOfClass nameOfMetaclass|

    nameOfClass := aClass theNonMetaclass name.
    nameOfMetaclass := aClass theMetaclass name.

    (self changedClasses contains:[:eachClass | eachClass theNonMetaclass name = nameOfClass]) ifFalse:[
	^ false.
    ].


    ^ self contains:[:eachChange |
			|changeClassName|

			changeClassName := eachChange className.
			changeClassName = nameOfClass or:[changeClassName = nameOfMetaclass]
		    ]

    "Modified: / 09-10-2006 / 13:40:29 / cg"
!

includesChangeForClassOrMetaclassOrPrivateClassOf:aClass
    |nameOfClass nameOfMetaclass|

    nameOfClass := aClass theNonMetaclass name.
    nameOfMetaclass := aClass theMetaclass name.

    self do:[:aChange |
	|changeClassName changeClass|

	changeClassName := aChange className.
	(changeClassName = nameOfClass) ifTrue:[^ true].
	(changeClassName = nameOfMetaclass) ifTrue:[^ true].

	changeClass := aChange changeClass.
	(changeClass notNil
	and:[changeClass isPrivate
	and:[changeClass owningClass == aClass]]) ifTrue:[
	    ^ true
	]
    ].
    ^ false

    "Modified (format): / 25-07-2012 / 16:50:26 / cg"
!

includesChangeForClassOrMetaclassOrPrivateClassOfAny:aCollectionOfClasses
    |namesOfClasses namesOfMetaclasses|

    namesOfClasses := (aCollectionOfClasses collect:[:eachClass | eachClass theNonMetaclass name]) asArray.
    namesOfMetaclasses := (aCollectionOfClasses collect:[:eachClass | eachClass theMetaclass name]) asArray.

    self do:[:aChange |
	|changeClassName changeClass|

	changeClassName := aChange className.
	(namesOfClasses includes:changeClassName) ifTrue:[^ true].
	(namesOfMetaclasses includes:changeClassName) ifTrue:[^ true].

	changeClass := aChange changeClass.
	(changeClass notNil and:[changeClass isPrivate]) ifTrue:[
	    (aCollectionOfClasses includes:changeClass owningClass) ifTrue:[
		^ true
	    ].
	]
    ].
    ^ false

    "Created: / 08-09-2011 / 04:24:26 / cg"
!

includesChangeForPackage:aPackageID
    ^ self changedPackages includes:aPackageID

"/    ^ self contains:[:aChange | aChange package = aPackageID]

    "
     ChangeSet current includesChangeForPackage:'stx:libbasic'
    "

    "Created: / 25-10-2006 / 18:06:55 / cg"
!

methodDefinitionChangesForClassNamed:aClassName
    ^ self select:[:chg | chg isMethodDefinitionChange and:[chg className = aClassName]] as:OrderedCollection.
!

selectClassesForWhichIncludesChangeForClassOrMetaclassOrPrivateClassFrom:aCollectionOfClasses
    "return the set of classes from a given collection, for which I have changes."

    |selected alreadyProcessed classes prev|

    classes := (aCollectionOfClasses
	    collect:[:eachClass | eachClass theNonMetaclass]) as:IdentitySet.

    selected := IdentitySet new.
    alreadyProcessed := IdentitySet new.

    self do:[:eachChange |
	|changeClassName changeClass isIn|

	changeClass := eachChange changeClass.
	(changeClass notNil and:[changeClass ~~ prev]) ifTrue:[
	    changeClass := changeClass theNonMetaclass.
	    (alreadyProcessed includes:changeClass) ifFalse:[
		(classes includes:changeClass) ifTrue:[
		    selected add:changeClass
		].

		"/ Care for private classes. If one of its owningClass
		"/ is in the given collection, add **that owningClass** into
		"/ result too!!!!

		changeClass isPrivate ifTrue:[
		    |owner|

		    owner := changeClass owningClass.
		    [owner notNil] whileTrue:[
			(classes includes:owner) ifTrue:[
			    selected add:owner.
			    owner := nil.
			] ifFalse:[
			    owner := owner owningClass.
			].
		    ].
		].
		alreadyProcessed add: changeClass.
	    ].
	    prev := changeClass.
	].
    ].
    ^ selected.

    "Created: / 04-09-2012 / 14:01:37 / cg"
    "Modified: / 09-08-2013 / 12:40:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectForWhichIncludesChangeForClassOrMetaclassOrPrivateClassFrom:aCollectionOfClasses
    "select changes for one of a given class.
     Returns a collection of changes"

    |selected  classes |

    classes := aCollectionOfClasses collect:[:eachClass | eachClass theNonMetaclass] as:Array.

    selected := self class new.

    self do:[:eachChange |
        |changeClassName changeClass isIn|

        changeClass := eachChange changeClass.
        (changeClass notNil) ifTrue:[
            changeClass := changeClass theNonMetaclass.
            ((classes includes:changeClass)
                or: [
                    changeClass isPrivate
                    and: [ (classes includes:changeClass owningClass) ]
                ]
            ) ifTrue:[
                selected add: eachChange
            ].
        ]
    ].
    ^ selected.

    "Created: / 08-09-2011 / 04:38:32 / cg"
! !

!ChangeSet methodsFor:'utilities'!

apply
    "apply all changes in the receiver's changeSet"

    self do:[:aChange |
	aChange apply
    ]
!

condenseChanges
    | changesToRemove changesToKeep |

    changesToKeep := self class new.
    changesToRemove := self class new.
    self reverseDo:[:change|
	(changesToKeep anySatisfy:[:each|each isForSameAs: change])
	    ifTrue:[changesToRemove add: change]
	    ifFalse:[changesToKeep add: change]
    ].
    self condenseChanges: changesToRemove.

    "Created: / 22-10-2008 / 13:05:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

condenseChanges:changesToRemove
    "remove the given changes - a helper for the rest of the condense protocol"

    changesToRemove notEmpty ifTrue:[
	changedClasses := changeSelectors := nil.
	self removeAll:changesToRemove.
	"/ self changed. "/  -- removeAll already sends out a notification
	Smalltalk changed:#currentChangeSet with:self.
    ].

    "Created: / 12-10-2006 / 16:51:11 / cg"
!

condenseChangesForClass:aClass
    "remove all changes for aClass (and its metaclass)
     (i.e. leave changes for other classes)."

    self condenseChangesForClass:aClass package:nil
!

condenseChangesForClass:aClass package:aPackageSymbol
    "remove all changes for aClass (and its metaclass) and aPackageSymbol
     (i.e. leave methodChanges for other packages).
     This is invoked when a class is checked into the repository."

    self condenseChangesForClass:aClass selector:nil package:aPackageSymbol

    "Modified: / 5.11.2001 / 14:29:22 / cg"
!

condenseChangesForClass:aClass selector:aSelector
    "remove all changes for aClass >> selector."

    self condenseChangesForClass:aClass selector:aSelector package:nil

    "Created: / 26-09-2006 / 17:22:59 / cg"
!

condenseChangesForClass:aClass selector:selectorOrNil package:aPackageSymbol
    "remove all changes for aClass/selector and aPackageSymbol
     (i.e. leave methodChanges for other packages).
     If selectorOrNil is nil, all changes for that class (or metaclass) are removed;
     otherwise, only changes for the given selector.
     This is invoked when a class is checked into the repository."

    |changesToRemove className metaClassName chgCls|

    className := aClass theNonMetaclass name.
    metaClassName := aClass theMetaclass name.

    changesToRemove :=
	self select:[:aChange |
	    |chgClassName chgClass removeThis mClass mthd|

	    removeThis := false.
	    chgClassName := aChange className.
	    (chgClassName = className or:[chgClassName = metaClassName]) ifTrue:[
		removeThis := true
	    ] ifFalse:[
		chgCls := aChange changeClass.
		chgCls isNil ifTrue:[
		    (chgClassName startsWith:(aClass name,':')) ifTrue:[
			"a change for a private class of a no-longer present one..."
			    removeThis := true
		    ].
		].

		(chgCls notNil
		and:[chgCls isPrivate
		and:[chgCls topOwningClass == aClass]]) ifTrue:[
		    removeThis := true
		]
	    ].
	    selectorOrNil notNil ifTrue:[
		(aChange isMethodChange or:[aChange isMethodRemoveChange]) ifFalse:[
		    removeThis := false.
		] ifTrue:[
		    aChange selector = selectorOrNil ifFalse:[
			removeThis := false.
		    ].
		]
	    ].

	    removeThis ifTrue:[
		aChange isMethodChange ifTrue:[
		    mClass := aChange changeClass.
		    mClass notNil ifTrue:[
			mthd := mClass compiledMethodAt:(aChange selector).
			mthd isNil ifTrue:[
			    "/ mthd does no longer exist
			    "/ I no longer understand what this was meant for .. (sigh)
			    "/                        aPackageSymbol notNil ifTrue:[
			    "/                            removeThis := false
			    "/                        ]
			] ifFalse:[
			    (aPackageSymbol notNil and:[mthd package ~= aPackageSymbol]) ifTrue:[
				removeThis := false
			    ]
			]
		    ]
		].
	    ].
	    removeThis
	].

    self condenseChanges:changesToRemove

    "Modified: / 12-10-2006 / 16:51:38 / cg"
!

condenseChangesForExtensionsInPackage:aPackageSymbol
    "remove all changes for aClass and aPackageSymbol
     (i.e. leave methodChanges for other packages).
     This is invoked when a class is checked into the repository."

    |changesToRemove|

    changesToRemove := OrderedCollection new.

    changesToRemove := self select:[:aChange |
	|removeThis mClass mthd|

	(aChange isMethodChange or:[aChange isMethodRemoveChange]) ifTrue:[
	    removeThis := false.
	    mClass := aChange changeClass.
	    (mClass notNil and:[mClass package ~= aPackageSymbol]) ifTrue:[
		mthd := mClass compiledMethodAt:(aChange selector).
		mthd isNil ifTrue:[
		    aChange isMethodRemoveChange ifTrue:[
			removeThis := true
		    ].
		] ifFalse:[
		    mthd package = aPackageSymbol ifTrue:[
			removeThis := true
		    ]
		]
	    ].
	].
	removeThis
    ].

    self condenseChanges:changesToRemove

    "Created: / 05-11-2001 / 14:21:17 / cg"
    "Modified: / 12-10-2006 / 16:51:32 / cg"
!

condenseChangesForPackage:aPackageSymbol
    "remove all changes for aPackageSymbol
     This is invoked when a project is checked into the repository."

    |changesToRemove|

    changesToRemove := self select:[:aChange |
	|removeThis mClass mthd|

	removeThis := false.
	(aChange isMethodChange or:[aChange isMethodRemoveChange]) ifTrue:[
	    mClass := aChange changeClass.
	    mClass notNil ifTrue:[
		mthd := mClass compiledMethodAt:(aChange selector).
		mthd isNil ifTrue:[
		    aChange isMethodRemoveChange ifTrue:[
			removeThis := (mClass package = aPackageSymbol)
		    ].
		] ifFalse:[
		    removeThis := (mthd package = aPackageSymbol)
		]
	    ].
	] ifFalse:[
	    (aChange isClassChange) ifTrue:[
		(aChange changeClass notNil) ifTrue:[
		    removeThis := (aChange changeClass package = aPackageSymbol)
		].
	    ].
	].
	removeThis
    ].

    self condenseChanges:changesToRemove

    "Created: / 05-11-2001 / 14:21:17 / cg"
    "Modified: / 12-10-2006 / 16:51:27 / cg"
!

diffSetsAgainst:anotherChangeSet
    "walk over the receiver and anotherChangeSet,
     add all changes to one of the tree lists:
        onlyInReceiver, onlyInArg or changed,
     each being a changeSet containing corresponding changes.
     WARNING:
        destructive; could modify both the receiver and the argument by possibly
        changing methodChanges into categoryChanges"

    ^ self diffSetsAgainst:anotherChangeSet comparingDifferentClasses:false    
!

diffSetsAgainst:anotherChangeSet comparingDifferentClasses:comparingDifferentClasses
    "walk over the receiver and anotherChangeSet,
     add all changes to one of the tree lists:
        onlyInReceiver, onlyInArg or changed,
     each being a changeSet containing corresponding changes.
     If comparingDifferentClasses is false, changes to different classes will 
     generate onlyInA/onlyInB changes; eg. changes for the same selector will be
     listed on either side.
     If it is true, we are comparing two different classes, and selectors present in 
     both will be listed as different (or even as the same).
     
     WARNING:
        destructive; could modify both the receiver and the argument by possibly
        changing methodChanges into categoryChanges."

    |otherChangeIndicesBySelector otherNonMethodChangeIndices changeIndicesBySelector nonMethodChangeIndices
     onlyInReceiver onlyInArg changedMethods same
     indexFromChangedMethodsToA indexFromChangedMethodsToB
     "info" ret isForSame isSame|

    comparingDifferentClasses ifTrue:[
        isForSame := [:aChangeInA :aChangeInB |
                        |isForSame|
                        
                        isForSame := false.
                        (aChangeInA isMethodChange 
                            and:[aChangeInB isMethodChange
                            and:[aChangeInA changeSelector = aChangeInB changeSelector
                            and:[aChangeInA changeClass isMeta = aChangeInB changeClass isMeta]]])
                        ifTrue:[
                            isForSame := true.
                        ] ifFalse:[
                            (aChangeInA isClassChange 
                                and:[aChangeInB isClassChange 
                                and:[aChangeInA changeClass nameWithoutNameSpacePrefix 
                                     = aChangeInB changeClass nameWithoutNameSpacePrefix]])
                            ifTrue:[
                                isForSame := true.
                            ]
                        ].
                        isForSame
                     ].

        isSame := [:aChangeInA :aChangeInB | 
                        (aChangeInA source = aChangeInB source) 
                  ]. 
    ] ifFalse:[
        isForSame := [:aChangeInA :aChangeInB | 
                        (aChangeInA isForSameAs:aChangeInB) 
                     ].
                     
        isSame := [:aChangeInA :aChangeInB | 
                        (aChangeInA sameAs:aChangeInB) 
                  ]. 
    ].    

    onlyInReceiver := self class new.
    onlyInArg      := self class new.
    changedMethods := self class new.
    same           := self class new.

    indexFromChangedMethodsToA := OrderedCollection new.
    indexFromChangedMethodsToB := OrderedCollection new.

    otherChangeIndicesBySelector := Dictionary new.
    otherNonMethodChangeIndices := OrderedCollection new.

    "/ these caches reduces square runtime to almost linear...
    anotherChangeSet keysAndValuesDo:[:idxB :aChangeInB |
        |setOfOtherChangeIndicesForThisSelector|

        aChangeInB isMethodChange ifTrue:[
            setOfOtherChangeIndicesForThisSelector := otherChangeIndicesBySelector at:(aChangeInB selector) ifAbsentPut:[OrderedCollection new].
            setOfOtherChangeIndicesForThisSelector add:idxB.
        ] ifFalse:[
            otherNonMethodChangeIndices add:idxB
        ].
    ].

    self keysAndValuesDo:[:idxA :aChangeInA |
        |indicesOfChangesToExplore anyFound ch|

        anyFound := false.

        aChangeInA isMethodChange ifTrue:[
            indicesOfChangesToExplore := otherChangeIndicesBySelector at:(aChangeInA selector) ifAbsent:#()
        ] ifFalse:[
            indicesOfChangesToExplore := otherNonMethodChangeIndices.
        ].

        indicesOfChangesToExplore do:[:idxB |
            |aChangeInB|

            aChangeInB := anotherChangeSet at:idxB.

            (isForSame value:aChangeInA value:aChangeInB) ifTrue:[
                "/ these two are for the same class/selector
                anyFound := true.

                "/ also in B - is it different?
                (isSame value:aChangeInA value:aChangeInB) ifFalse:[
                    changedMethods add:aChangeInA.
                    indexFromChangedMethodsToA add:idxA.
                    indexFromChangedMethodsToB add:idxB.
                ] ifTrue:[
                    aChangeInA isMethodChange ifTrue:[
                        aChangeInA methodCategory ~= aChangeInB methodCategory ifTrue:[
                            "/ only the category is different;
                            "/ make it a MethodCategory changes.

                            ch := MethodCategoryChange new
                                    className:aChangeInA className
                                    selector:aChangeInA selector
                                    category:aChangeInA methodCategory;
                                    "JV@2012-03-20: Also keeps origin, required by merge tool"
                                    origin: aChangeInA.
                            self at:idxA put:ch.

                            ch := MethodCategoryChange new
                                    className:aChangeInB className
                                    selector:aChangeInB selector
                                    category:aChangeInB methodCategory;
                                    "JV@2012-03-20: Also keeps origin, required by merge tool"
                                    origin: aChangeInB.
                            anotherChangeSet at:idxB put:ch.

                            changedMethods add:aChangeInA.
                            indexFromChangedMethodsToA add:idxA.
                            indexFromChangedMethodsToB add:idxB.
                        ]
                    ].
                ]
            ] ifFalse:[
                (isSame value:aChangeInA value:aChangeInB) ifTrue:[
                    anyFound := true.
                ] ifFalse:[
                ]
            ]
        ].

        anyFound ifFalse:[
            onlyInReceiver add:aChangeInA.
        ]
    ].

    "/ these caches reduce square runtime to almost linear...
    changeIndicesBySelector := Dictionary new.
    nonMethodChangeIndices := OrderedCollection new.

    self keysAndValuesDo:[:idxA :aChangeInA |
        |setOfChangeIndicesForThisSelector|

        aChangeInA isMethodChange ifTrue:[
            setOfChangeIndicesForThisSelector := changeIndicesBySelector at:(aChangeInA selector) ifAbsentPut:[OrderedCollection new].
            setOfChangeIndicesForThisSelector add:idxA.
        ] ifFalse:[
            nonMethodChangeIndices add:idxA
        ].
    ].

    anotherChangeSet keysAndValuesDo:[:idxB :aChangeInB |
        |anyFound indicesOfChangesToExplore|

        anyFound := false.

        aChangeInB isMethodChange ifTrue:[
            indicesOfChangesToExplore := changeIndicesBySelector at:(aChangeInB selector) ifAbsent:#()
        ] ifFalse:[
            indicesOfChangesToExplore := nonMethodChangeIndices.
        ].

        indicesOfChangesToExplore do:[:idxA |
            |aChangeInA idxM|

            aChangeInA := self at:idxA.

            (isForSame value:aChangeInA value:aChangeInB) ifTrue:[
                anyFound := true.

                "/ also in B - is it different ?
                (isSame value:aChangeInA value:aChangeInB) ifFalse:[
                    "/ already there ?
                    idxM := changedMethods findFirst:[:c | (isForSame value:c value:aChangeInB)].
                    idxM == 0 ifTrue:[
                        changedMethods add:aChangeInB.
                        indexFromChangedMethodsToB add:idxB.
                    ] ifFalse:[
                        indexFromChangedMethodsToB at:idxM put:idxB
                    ]
                ]
            ] ifFalse:[
                (isSame value:aChangeInA value:aChangeInB) ifTrue:[
                    anyFound := true.
                ] ifFalse:[
                ]
            ]
        ].
        anyFound ifFalse:[
            onlyInArg add:aChangeInB.
        ]
    ].

"/    info := OrderedCollection new:(changedMethods size).
"/    changedMethods keysAndValuesDo:[:idx :changedMethod |
"/        info add:(Array
"/                        with:(indexFromChangedMethodsToA at:idx)
"/                        with:(indexFromChangedMethodsToB at:idx)
"/                 )
"/    ].
    changedMethods := (1 to:changedMethods size) asOrderedCollection collect:[:idx |
                        |cA cB|

                        cA := self at:(indexFromChangedMethodsToA at:idx).
                        cB := anotherChangeSet at:(indexFromChangedMethodsToB at:idx).
                        Array with:cA with:cB
                      ].

    same := self reject:[:chg|(changedMethods contains:[:pair|pair first == chg]) or:[onlyInReceiver includes: chg]].

    ret := DiffSet new
                changed:changedMethods
                onlyInReceiver:onlyInReceiver
                onlyInArg:onlyInArg
                same: same.
"/    ret info:info.
    ^ret

    "Modified: / 12-10-2006 / 22:22:39 / cg"
    "Modified (comment): / 01-12-2011 / 19:12:55 / cg"
    "Modified: / 20-03-2012 / 22:05:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffSetsAgainstImage

    |imageChangeSet|

    imageChangeSet := self class new.
    self changedClasses do:
	[:class|
	(class isMetaclass or:[class isPrivate]) ifFalse:
	    [imageChangeSet addAll:
		(self class fromStream: class source asString readStream)]].
    ^self diffSetsAgainst: imageChangeSet

    "Created: / 04-12-2007 / 16:03:28 / janfrog"
!

flatten
    "return a flat changeset from a changeset which may contain compositeChanges"
    
    | flatten |

    flatten := self class new: self size.
    self do:[:ea|
        ea do:[:ea2| flatten add: ea2]
    ].
    ^ flatten

    "Created: / 29-10-2010 / 14:40:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

groupBy: groupBlock labelAs: labelBlock

    "
	returns a new changeset consisting of CompositeChanges.
	Changes are grouped together by value (tag) of groupBlock.
	Each composite change is then labeled using label
	returned by labelBlock (called with the tag returned
	by groupBlock as arg)
    "

    ^ self groupBy: groupBlock labelAs: labelBlock sort: false

    "Created: / 24-07-2009 / 23:17:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-07-2009 / 19:40:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-10-2010 / 12:45:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-08-2011 / 16:07:30 / cg"
!

groupBy: groupBlock labelAs: labelBlock sort: doSort
    "returns a new changeset consisting of CompositeChanges.
     Changes are grouped together by value (tag) of groupBlock.
     Each composite change is then labeled using label
     returned by labelBlock (called with the tag returned
     by groupBlock as arg)"

    | buckets newChangeset keys |

    buckets := OrderedDictionary new.
    self do:[:change|
	| tag |

	tag := groupBlock value: change.
	(buckets at: tag ifAbsentPut: [self class new:4]) add: change
    ].
    newChangeset := self class new: buckets size.

    keys := buckets keys select:[:k | k notNil].
    doSort ifTrue:[ keys sort ].
    keys do:[:tag |
	|changes classDefs|

	changes := buckets at:tag.

	"Move class definition to the front"
	classDefs := changes select:[:chg|chg isClassDefinitionChange].
	changes removeAll: classDefs.
	changes addAllFirst: classDefs.

	tag notNil ifTrue:[
	    newChangeset add:
		(CompositeChange
		    name: (labelBlock value: tag)
		    changes: changes)
	]
    ].
    (buckets includesKey: nil) ifTrue:[
	newChangeset addAll: (buckets at: nil)
    ].
    ^newChangeset

    "Created: / 24-07-2009 / 23:17:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-07-2009 / 19:40:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-10-2010 / 12:45:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 30-08-2011 / 16:07:01 / cg"
!

groupByClass
    |nm|

    ^self
	groupBy: [:change|
	    change isClassChange ifTrue: [
		nm := change className.
		(nm notNil and:[nm endsWith:' class']) ifTrue:[nm := nm copyTo: nm size - 6].
		nm
	    ] ifFalse: [
		nil
	    ]
	]
	labelAs: [:className|
	    className
	]
	sort: true

    "Created: / 25-07-2009 / 19:43:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-10-2009 / 18:49:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-08-2011 / 16:08:38 / cg"
!

saveSignedToFile:aFilename
    "write the changeSet to a signed file in chunk format"

    self saveSignedToFile:aFilename format:nil

    "Created: / 08-02-2011 / 11:18:54 / cg"
!

saveSignedToFile:aFilename format:formatSymbolOrNil
    "write the changeSet to a signed file in some format.
     Sign with the exept key (which you do not have outside of exept!!).
     Nil is chunk format (currently, the only supported)"

    |s pkcs7SignedData|

    self assert: (Smalltalk at:#'Expecco::KeyFileGenerator') notNil.

    s := WriteStream on:(String new:2000).
    self saveToStream:s format:formatSymbolOrNil.

    pkcs7SignedData := (Smalltalk at:#'Expecco::KeyFileGenerator') new signExpeccoCode:s contents.
    aFilename asFilename contents:pkcs7SignedData.

    "Modified (comment): / 26-07-2012 / 12:15:58 / cg"
!

saveToFile:aFilename
    "write the changeSet to a regular file in chunk format"

    self saveToFile:aFilename format:nil

    "Created: / 08-02-2011 / 11:18:46 / cg"
!

saveToFile:aFilename format:formatSymbolOrNil
    "Writes the changeSet to a regular file in some format.
     Supported formats are:
       nil ............ chunk changeset file
       #classSource ... class fileout format, assumes that
                        the receiver is a changeset containing
                        single class (possibly with its private
                        classes)
       #Bee ........... Bee Smalltalk changeset file format    
    "

    |s|

    s := aFilename asFilename writeStream.
    [
        self saveToStream:s format:formatSymbolOrNil.
    ] ensure:[ s close ].

    "Created: / 08-02-2011 / 11:20:06 / cg"
    "Modified: / 24-10-2017 / 11:57:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveToStream:aStream format:formatSymbolOrNil
    "Writes the changeSet to a stream in some format.
     Supported formats are:
       nil ............ chunk changeset file format
       #classSource ... class fileout format, assumes that
                        the receiver is a changeset containing
                        single class (possibly with its private
                        classes)
       #Bee ........... Bee Smalltalk changeset file format      
    "


    formatSymbolOrNil isNil ifTrue:[
        ChangeFileWriter new fileOut:self on:aStream.
        ^ self.
    ].

    formatSymbolOrNil == #classSource ifTrue:[
        ClassSourceWriter new fileOut:self on:aStream.
        ^ self.
    ].

    formatSymbolOrNil == #Bee ifTrue:[
        BeeChangeFileWriter new fileOut:self on:aStream.
        ^ self.
    ].

    self error:'Unknown format, possible formats are { nil, #classSource . #Bee }'

    "Created: / 08-02-2011 / 11:25:16 / cg"
    "Modified: / 24-10-2017 / 11:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sortedByClassName
    "returns a new changeset containing the changes sorted by class names"
    
    | newChangeset |

    newChangeset := self class new: self size.
    newChangeset addAll:self.                
    newChangeset sort:[:a :b |
                    |nameA nameB|
                    nameA := a isClassChange ifTrue:[ a className ] ifFalse:[ '^other' ].
                    nameB := b isClassChange ifTrue:[ b className ] ifFalse:[ '^other' ].
                    nameA < nameB].
    ^ newChangeset                
! !

!ChangeSet::ChangeFileReader methodsFor:'accessing'!

changeAction:aBlock
    changeAction := aBlock.
!

changeSet:something
    "set the value of the instance variable 'changeSet' (automatically generated)"

    changeSet := something.
!

inputStream:aStream
    inputStream := aStream.
! !

!ChangeSet::ChangeFileReader methodsFor:'helpers'!

addChange:change

    timestamp notNil ifTrue:[change timeStamp: timestamp].
    timestamp := nil.
    change isClassChange ifTrue:[
	change package: Class packageQuerySignal query.
	change nameSpace: Class nameSpaceQuerySignal query.
    ].

    changeAction
	valueWithOptionalArgument:change
	and:lineNumber
	and:position.

    "Modified: / 11-06-2013 / 15:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkReceiverIsGlobalNamed:expectedName
    ^ self variableNameOfReceiver = expectedName
!

classNameOf:aReceiver
    "old"

    | nameSpace isMeta clsNode clsName |
    nameSpace := Class nameSpaceQuerySignal query.

    isMeta := false.
    classIsJava := false.


    (aReceiver isUnaryMessage and:[aReceiver selector == #class]) ifTrue:[
	isMeta := true.
	clsNode := aReceiver receiver.
    ] ifFalse:[
	clsNode := aReceiver.
    ].

    clsNode isMessage ifFalse:[
	"Normal smalltalk method on Smalltalk class"
	clsName := clsNode name
    ] ifTrue:[
	"Maybe a Java class?"
	((clsNode selector == #classForName:) and:[clsNode receiver name = 'Java']) ifTrue:[
	    clsName := '(Java classForName:''%1'')' bindWith: clsNode arguments first value.
	    classIsJava := true.
	].
    ].

    isMeta ifTrue:[
	clsName := clsName , ' class'.
    ].

    (nameSpace ~~ Smalltalk and:[(clsName startsWith: nameSpace name) not])
	ifTrue:[
	    ^ nameSpace name , '::' , clsName
	] ifFalse:[
	    ^ clsName
	].

    "Modified: / 30-01-2013 / 10:02:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classNameOfRememberingNamespace:aReceiver
    "new"

    | nameSpace isMeta clsNode clsName |
    nameSpace := Class nameSpaceQuerySignal query.

    isMeta := false.
    classIsJava := false.


    (aReceiver isUnaryMessage and:[aReceiver selector == #class]) ifTrue:[
	isMeta := true.
	clsNode := aReceiver receiver.
    ] ifFalse:[
	clsNode := aReceiver.
    ].

    clsNode isMessage ifFalse:[
	"Normal smalltalk method on Smalltalk class"
	clsName := clsNode name
    ] ifTrue:[
	"Maybe a Java class?"
	((clsNode selector == #classForName:) and:[clsNode receiver name = 'Java']) ifTrue:[
	    clsName := '(Java classForName:''%1'')' bindWith: clsNode arguments first value.
	    classIsJava := true.
	].
    ].

    isMeta ifTrue:[
	clsName := clsName , ' class'.
    ].

    "Strip off the namespace"
    (classIsJava not and:[ nameSpace ~~ Smalltalk]) ifTrue:[
	(clsName startsWith: nameSpace name) ifTrue:[
	    clsName := clsName copyFrom: nameSpace name size + 3.
	]
    ].

    (nameSpace ~~ Smalltalk and:[(clsName startsWith: nameSpace name) not])
	ifTrue:[
	    "/ old: remember namespace in name
	    "/ ^ nameSpace name , '::' , clsName
	    "/ new: remember in override
	    nameSpaceOverride := nameSpace.
	    ^ clsName
	] ifFalse:[
	    nameSpaceOverride := nil.
	    ^ clsName
	].

    "Modified: / 11-06-2013 / 17:55:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extractMethodsClassAndSelectorFromReceiver
    "helper for all changes which are of the form:
	(className compiledMethodAt:#methodSelector) something: ...
    "

    (receiver isMessage
    and:[receiverSelector == #'compiledMethodAt:']) ifFalse:[
	self error:'unexpected change' mayProceed:true.
	^ false.
    ].

    "/ className := self classNameOf:receiverReceiver.
    className := self classNameOfRememberingNamespace:receiverReceiver.
    self assert:className notNil.

    methodSelector := (receiver arguments at:1) evaluate.
    self assert:methodSelector notNil.
    ^ true.

    "Created: / 27-07-2012 / 21:33:47 / cg"
!

receiversClassName
    ^ self classNameOf:receiver
!

receiversClassNameRememberingNamespace
    ^ self classNameOfRememberingNamespace:receiver
!

variableNameOfReceiver

    receiver isVariable ifFalse:[ ^ nil ].
    ^ receiver name
! !

!ChangeSet::ChangeFileReader methodsFor:'reading'!

changesFromParseTree:aTree lineNumber:initialLineNumberOrNil position:initialPositionOrNil
    "given a parse-tree (from parsing some changes source/chunk),
     create changes and evaluate changeAction on each.
     The chnageAction-block is invoked with the change and a lineNumberOrNil as
     arg; the lineNumber is only valid, if the underlying inputStream
     provides line-numbers; otherwise, nil is passed."

    ^self changesFromParseTree:aTree lineNumber:initialLineNumberOrNil position:initialPositionOrNil chunk: nil

    "Modified: / 24-01-2012 / 17:29:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesFromParseTree:aTree lineNumber:initialLineNumberOrNil position:initialPositionOrNil chunk: initialChunkOrNil
    "given a parse-tree (from parsing some changes source/chunk),
     create changes and evaluate changeAction on each.
     The changeAction-block is invoked with the change and a lineNumberOrNil as
     arg; the lineNumber is only valid, if the underlying inputStream
     provides line-numbers; otherwise, nil is passed."

    lineNumber := initialLineNumberOrNil.
    position := initialPositionOrNil.
    chunk := initialChunkOrNil.
    parseTree := aTree.

    selector := aTree selector.
    receiver := aTree receiver.
    arguments := aTree arguments.

    receiver isMessage ifTrue:[
        receiverSelector := receiver selector.
        receiverReceiver := receiver receiver.
    ].

    ^ self processChange

    "Created: / 24-01-2012 / 17:28:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::ChangeFileReader methodsFor:'reading-private'!

handleCategoriesForChange
    |selector category categories attributes change|

    selector := arguments first value.
    className := self receiversClassNameRememberingNamespace.

    categories := OrderedCollection new.
    attributes := OrderedCollection new.

    [
        inputStream skipSeparators.
        category := inputStream nextChunk.
        category notEmptyOrNil
    ] whileTrue:[
        ( #( 'public' 'private' ) includes: category) ifTrue:[
            attributes add:category
        ] ifFalse:[
            categories add:category
        ].
    ].
    categories notEmpty ifTrue:[
        categories size == 1 ifTrue:[
            category := categories first.
        ] ifFalse:[
            category := categories asStringWith:' and '
        ].    
        change := MethodCategoryChange
                        className:className
                        selector:selector
                        source:(parseTree printString)
                        category:category.
        self addChange:change.
    ].
    
    attributes notEmpty ifTrue:[
        attributes size == 1 ifTrue:[
            "/ easy
            (attributes first = 'public') ifTrue:[
                "/ default anyway - ignore
            ] ifFalse:[
                change := MethodPrivacyChange
                            className:className
                            selector:selector
                            privacy:(attributes first asSymbol).
                change nameSpaceOverride:nameSpaceOverride.
                change source:(parseTree printString).
                self addChange:change.
            ].
        ] ifFalse:[
            self halt:'multiple/missing attributes not supported'.
        ].
    ].
    ^ true

    "Modified: / 11-06-2013 / 16:11:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleCategoriesForClassChange
    |category categories attributes change|

    className := self receiversClassNameRememberingNamespace.

    categories := OrderedCollection new.
    attributes := OrderedCollection new.

    [
        inputStream skipSeparators.
        category := inputStream nextChunk.
        category notEmptyOrNil
    ] whileTrue:[
        ( #( 'public' 'private' ) includes: category) ifTrue:[
            attributes add:category
        ] ifFalse:[
            categories add:category
        ].
    ].

    categories notEmpty ifTrue:[
        categories size == 1 ifTrue:[
            "/ easy
            category := categories first
        ] ifFalse:[
            category := categories asStringWith:' and '
        ].    
        change := ClassCategoryChange new
                            className:className
                            category:category.
        self addChange:change.
    ].

    attributes notEmpty ifTrue:[
        attributes size == 1 ifTrue:[
            "/ easy
            (attributes first = 'public') ifTrue:[
                "/ default anyway - ignore
            ] ifFalse:[
                "/ a private class!!
"/            change := ClassDefinitionChange
"/                        className:className
"/                        selector:selector
"/                        privacy:(attributes first asSymbol).
"/            change nameSpaceOverride:nameSpaceOverride.
"/            change source:(parseTree printString).
"/            self addChange:change.
            ].
        ] ifFalse:[
            self halt:'multiple/missing attributes not supported'.
        ].
    ].
    ^ true

    "Modified: / 11-06-2013 / 16:11:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleClassCommentChange
    |change|

    className := self receiversClassNameRememberingNamespace.

    change := ClassCommentChange new.
    change className:className comment:(arguments at:1) evaluate.
    change source:(parseTree printString).
    self addChange:change.
    ^ true

    "Modified: / 11-06-2013 / 16:11:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleClassDefinitionChange
    |nameSpace change|

    className := (arguments at:1) evaluate.

    nameSpace := Class nameSpaceQuerySignal query.
    (nameSpace == Smalltalk) ifTrue:[ nameSpace := nil ].

    "/ old: remember namespace in className
"/    nameSpace ~~ Smalltalk ifTrue:[
"/        className := nameSpace name , '::' , className
"/    ].

    change := ClassDefinitionChange new.
    change className:className; source:(parseTree printString).
    change definitionSelector:selector.

    receiver isVariable ifTrue:[
        change superClassName:receiver name.
    ].
    selector keywords with:arguments do:[:kw :arg |
        kw = #'instanceVariableNames:' ifTrue:[
            change instanceVariableString:arg evaluate.
        ].
        kw = #'classVariableNames:' ifTrue:[
            change classVariableString:arg evaluate.
        ].
        kw = #'poolDictionaries:' ifTrue:[
            change poolDictionaries:arg evaluate.
        ].
        kw = #'category:' ifTrue:[
            change category:arg evaluate.
        ].
        kw = #'privateIn:' ifTrue:[
            | nm |

            nm := arg name.
            nameSpace notNil ifTrue:[
                (nm startsWith: nameSpace name) ifTrue:[
                    nm := nm copyFrom: nameSpace name size + 3.
                ].
            ].
            change className:(nm ,'::',change classNameWithoutNamespace).
            change owningClassName:nm.
            change private:true.
        ].
    ].

    change package:(Class packageQuerySignal query).
"/        nameSpace ~~ Smalltalk ifTrue:[
"/            change nameSpaceName:(nameSpace name).
"/        ].
"/
    self addChange:change.
    ^ true

    "Modified: / 30-08-2010 / 13:56:32 / cg"
    "Modified: / 11-06-2013 / 22:30:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleClassInitializeChange
    | change nm |

    nm := self receiversClassNameRememberingNamespace.

    change := ClassInitializeChange new source: chunk.
    change className: nm.
    self addChange: change.

    ^ true

    "Modified: / 21-03-2014 / 18:19:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleClassInstanceVariableDefinitionChange
    |change|

    className := self receiversClassNameRememberingNamespace.

    change := ClassInstVarDefinitionChange new.
    change className:className.
    change source:(parseTree printString).
    change classInstVarNames:(parseTree arguments first value asCollectionOfWords asArray).
    self addChange:change.
    ^ true

    "Modified: / 25-11-2011 / 17:40:49 / cg"
    "Modified: / 11-06-2013 / 16:11:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleMethodCategoryChange
    |change|

    self extractMethodsClassAndSelectorFromReceiver ifFalse:[
	^ false.
    ].

    change := MethodCategoryChange new.
    change
	className:className
	selector:methodSelector
	category:(arguments at:1) evaluate.

    self addChange:change.
    ^ true

    "Modified: / 27-07-2012 / 21:34:42 / cg"
    "Modified: / 11-06-2013 / 16:11:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleMethodCategoryRenameChange
    |change|

    className := self receiversClassNameRememberingNamespace.

    change := MethodCategoryRenameChange new.
    change
	className:className;
	oldCategoryName:(arguments at:1) evaluate
	newCategoryName:(arguments at:2) evaluate.

    self addChange:change.
    ^ true

    "Modified: / 11-06-2013 / 16:11:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleMethodChange
    [
	^ self handleMethodChangeUnsafe
    ] on: Error do:[:ex|
	| change |

	change := InvalidChange new source: chunk.
	self addChange: change.

	"Read methods that may follow"

	[ (chunk := inputStream nextChunk) notEmptyOrNil ] whileTrue:[
	    change := InvalidChange new source: chunk.
	    self addChange: change.
	]
    ].

    ^ true

    "Modified (comment): / 24-01-2012 / 17:32:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleMethodChangeUnsafe
    |priv categoryName methodSource change parser |

    className := self receiversClassNameRememberingNamespace.

    (selector == #'ignoredMethodsFor:') ifTrue:[
        priv := #ignored.
    ] ifFalse:[
        priv := nil
    ].
    classIsJava := false.
    ((selector == #'methods')
    or:[(selector == #'publicMethods')
    or:[(selector == #'methodsFor')]]) ifTrue:[
        categoryName := 'uncategorized public'
    ] ifFalse:[
        (selector == #'privateMethods') ifTrue:[
            categoryName := 'uncategorized private'
        ] ifFalse:[
            categoryName := (arguments at:1) evaluate.
        ]
    ].
    inputStream skipSeparators.
    lineNumber := inputStream lineNumber.
    "/ Care for non-positionable streams
    position := nil.
    inputStream isPositionable ifTrue:[
        position := inputStream position + 1.
    ].

    methodSource := chunk := inputStream nextChunk.

    [methodSource notEmptyOrNil] whileTrue:[
        parser := Parser
                    parseMethodArgAndVarSpecification:methodSource
                    in:nil
                    ignoreErrors:true
                    ignoreWarnings:true
                    parseBody:false.

        parser isNil ifTrue:[
            "/ something wierd ...
            methodSelector := '????'.
        ] ifFalse:[
            methodSelector := parser selector.
        ].

        change := MethodDefinitionChange new.
        change
            className:className
            selector:methodSelector
            source:methodSource
            category:categoryName
            privacy:priv.
        classIsJava ifTrue:[ change classIsJava: classIsJava ].

        self addChange:change.

        inputStream skipSeparators.
        lineNumber := inputStream lineNumber.
        "/ Care for non-positionable streams
        position := nil.
        inputStream isPositionable ifTrue:[
            position := inputStream position + 1.
        ].
        methodSource := chunk := inputStream nextChunk.
    ].
    ^ true

    "Created: / 24-01-2012 / 16:52:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2018 / 09:23:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleMethodPackageChange
    |change|

    self extractMethodsClassAndSelectorFromReceiver ifFalse:[
	^ false.
    ].

    change := MethodPackageChange new.
    change
	className:className
	selector:methodSelector
	package:(arguments at:1) evaluate.

    self addChange:change.
    ^ true

    "Created: / 27-07-2012 / 21:31:25 / cg"
    "Modified: / 11-06-2013 / 16:11:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleMethodPrivacyChange
    |change|

    self extractMethodsClassAndSelectorFromReceiver ifFalse:[
	^ false.
    ].

    change := MethodPrivacyChange new.
    change
	className:className
	selector:methodSelector
	privacy:(arguments at:1) evaluate.

    self addChange:change.
    ^ true

    "Modified: / 27-07-2012 / 21:35:20 / cg"
    "Modified: / 11-06-2013 / 16:11:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleNameSpaceCreationChange
    |change|

    (self checkReceiverIsGlobalNamed:#Namespace) ifFalse:[
	(self checkReceiverIsGlobalNamed:#NameSpace) ifFalse:[
	    self error:'unexpected receiver in nameSpace message' mayProceed:true.
	    ^ false
	].
    ].

    className := (arguments at:1) evaluate.

    change := NameSpaceCreationChange new.
    change name:className.
    self addChange:change.
    ^ true
!

handlePrimitiveChange
    self handlePrimitiveChange:nil
!

handlePrimitiveChange: sourceOrNil
    "if sourceOrNil is nil, the def has not been read and must be read from
     the next chunk. Otherwise, it has been already read as argument."

    |change primSource|

    className := self receiversClassNameRememberingNamespace.

    sourceOrNil notNil ifTrue:[
	primSource := sourceOrNil
    ] ifFalse:[
	inputStream skipSeparators.
	primSource := inputStream nextChunk.
    ].

    (selector == #'primitiveDefinitions' or:[ selector == #'primitiveDefinitions:' ]) ifTrue:[
	change := ClassPrimitiveDefinitionsChange new
    ] ifFalse:[
	(selector == #'primitiveFunctions' or:[ selector == #'primitiveFunctions:' ]) ifTrue:[
	    change := ClassPrimitiveFunctionsChange new
	] ifFalse:[
	    change := ClassPrimitiveVariablesChange new
	]
    ].
    change className:className source:primSource.
    self addChange:change.
    ^ true

    "Created: / 27-07-2012 / 21:39:55 / cg"
    "Modified (format): / 11-06-2013 / 16:12:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleRemoveClassChange
    |change|

    (self checkReceiverIsGlobalNamed:#Smalltalk) ifFalse:[
	self error:'unexpected receiver in remove-class message' mayProceed:true.
	^ false
    ].

    className := (arguments at:1) name.
"/            nameSpace ~~ Smalltalk ifTrue:[
"/                className := nameSpace name , '::' , className
"/            ].

    change := ClassRemoveChange new.
    change className:className.
    self addChange:change.
    ^ true
!

handleRemoveMethodChange
    |change|

    className := self receiversClassName.

    methodSelector := (arguments at:1) evaluate.
    change := MethodRemoveChange new.
    change className:className selector:methodSelector.
    self addChange:change.
    ^ true
!

handleRenameClassChange
    |oldName newName change|

    (self checkReceiverIsGlobalNamed:#Smalltalk) ifFalse:[
	self error:'unexpected receiver in rename-class message' mayProceed:true.
	^ false.
    ].

    oldName := (arguments at:1) name.
    newName := (arguments at:2) evaluate.

    change := ClassRenameChange new oldName:oldName newName:newName.
    self addChange:change.
    ^ true
!

handleSqueakCommentStamp
    |comment change|

    inputStream skipSeparators.

    comment := inputStream nextChunk.

    className := self receiversClassNameRememberingNamespace.

    change := ClassCommentChange new.
    change className:className comment:comment.
    change source:(parseTree printString).
    self addChange:change.
    ^ true
!

handleVW7ClassDefinitionChange
    |nameSpace change|

    nameSpace := receiver.
    className := (arguments at:1) evaluate.

"/    nameSpace := Class nameSpaceQuerySignal query.
"/    nameSpace ~~ Smalltalk ifTrue:[
"/        className := nameSpace name , '::' , className
"/    ].

    change := ClassDefinitionChange new.
    change className:className; source:(parseTree printString).

    change package:(Class packageQuerySignal query).
    self addChange:change.
    ^ true
!

processChange
    "given a parse-tree (from parsing some changes source/chunk),
     create changes and evaluate changeAction on each.
     The block is invoked with the change and a lineNumberOrNil as
     arg; the lineNumber is only valid, if the underlying stream
     provides line-numbers; otherwise, nil is passed."

    [
	^ self processChangeUnsafe
    ] on: Error do:[:ex|
	| change |

	change := DoItChange new source: chunk.
	self addChange: change.
    ].

    ^true

    "Modified: / 24-01-2012 / 17:34:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processChangeUnsafe
    "given a parse-tree (from parsing some changes source/chunk),
     create changes and evaluate changeAction on each.
     The block is invoked with the change and a lineNumberOrNil as
     arg; the lineNumber is only valid, if the underlying stream
     provides line-numbers; otherwise, nil is passed."

    |dispatchSelector|

    dispatchSelector := ('process_',(selector copyReplaceAll:$: with:$_)) asSymbol.
"/ Transcript showCR:dispatchSelector.
    (self respondsTo:dispatchSelector) ifTrue:[
	^ self perform:dispatchSelector.
    ].

    "/ any subclass definiton selector ?
    (Behavior definitionSelectors includes:selector)
    ifTrue:[
	^ self handleClassDefinitionChange.
    ].

    self error:'unhandled change selector: ',selector.
    ^ false

    "Created: / 24-01-2012 / 17:33:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processInfo: string
    "Processes 'info record' - an info record consist of a chunk containing
     single string literal starting with ----, such as:

    '---- timestamp jv@neso 12-03-2012 10:49:40 ----'
    '---- snapshot st.img 30-03-2012 11:40:24 ----'
    '---- checkin SVN::ConfigurationApp into stx:libsvn (1.12) 12-03-2012 10:51:15 ----'
    '---- rake update 30-03-2012 11:40:24 ----'
    '---- start 30-03-2012 11:40:24 ----'

    timestamp info records are (for historical reasons) processed in ChangeSet
    "

    | kind sel |
    inputStream skip: 5.
    kind := inputStream upTo: Character space.
    (kind endsWith:$:) ifTrue:[
	kind := kind copyButLast:1
    ].
    sel := ('process_', kind) asSymbolIfInterned.
    sel notNil ifTrue:[
	MessageNotUnderstood handle:[
	    self process_otherInfo:kind
	] do:[
	    self perform: sel.
	]
    ] ifFalse:[
	self process_otherInfo:kind
    ]

    "Created: / 30-03-2012 / 16:44:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process_category_
    "'category:' chunk (ST/X)"

    ^ self handleMethodCategoryChange.
!

process_comment_
    "'comment:' chunk (ST/X)"

    ^ self handleClassCommentChange.
!

process_encoding
    "St/X encoding info record. Ignored"
!

process_ignoredMethodsFor_
    "'ignoredMethodsFor:' chunk (ST/X)"

    ^ self handleMethodChange.
!

process_initialize
    "'class initialize' chunk"

    ^ self handleClassInitializeChange
!

process_instanceVariableNames_
    "'instanceVariableNames:' chunk (ST/X)"

    ^ self handleClassInstanceVariableDefinitionChange.
!

process_name_
    "'name:' chunk (ST/X)"

    ^ self handleNameSpaceCreationChange.
!

process_otherInfo:what
    "'---- <what> 12-03-2012 10:49:40 ----'

    '<what>' is already read from inputStream.
    "

    "/ inputStream skipSeparators.
    self addChange: (InfoChange type: what data: (inputStream upToEnd) timestamp: nil)

    "Created: / 18-05-2012 / 17:03:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process_package_
    "'package:' chunk (ST/X)"

    ^ self handleMethodPackageChange.

    "Created: / 27-07-2012 / 21:36:30 / cg"
!

process_primitiveDefinitions
    "'primitiveDefinitions' chunk (ST/X)"

    ^ self handlePrimitiveChange:nil.

    "Modified: / 27-07-2012 / 21:40:33 / cg"
!

process_primitiveDefinitions_
    "'primitiveDefinitions:' chunk (ST/X)"

    ^ self handlePrimitiveChange: (arguments at:1) evaluate.

    "Created: / 27-07-2012 / 21:42:03 / cg"
!

process_primitiveFunctions
    "'primitiveFunctions' chunk (ST/X)"

    ^ self handlePrimitiveChange:nil.

    "Modified: / 27-07-2012 / 21:40:23 / cg"
!

process_primitiveFunctions_
    "'primitiveFunctions:' chunk (ST/X)"

    ^ self handlePrimitiveChange: (arguments at:1) evaluate.

    "Created: / 27-07-2012 / 21:37:21 / cg"
!

process_primitiveVariables
    "'primitiveVariables' chunk (ST/X)"

    ^ self handlePrimitiveChange:nil.

    "Modified: / 27-07-2012 / 21:40:35 / cg"
!

process_primitiveVariables_
    "'primitiveVariables:' chunk (ST/X)"

    ^ self handlePrimitiveChange: (arguments at:1) evaluate.

    "Created: / 27-07-2012 / 21:41:49 / cg"
!

process_privacy_
    "'privacy:' chunk (ST/X)"

    ^ self handleMethodPrivacyChange.
!

process_privateMethods
    "'privateMethods' chunk (ST/V and dolphin)"

    ^ self handleMethodChange.
!

process_privateMethodsFor_
    "'privateMethodsFor:' chunk (ST/X)"

    ^ self handleMethodChange.
!

process_protectedMethodsFor_
    "'protectedMethodsFor:' chunk (ST/X)"

    ^ self handleMethodChange.
!

process_publicMethodsFor_
    "'publicMethodsFor:' chunk (ST/X)"

    ^ self handleMethodChange.
!

process_rake
    "Rake build system info record

    '---- rake update st.img 12-03-2012 10:49:40 ----'!!
    '---- rake compile st.img 12-03-2012 10:49:40 ----'!!

    'rake' is already read from inputStream.
    "

    | ts what |

    inputStream skipSeparators.
    what := inputStream through: Character space. "/read snapshot name
    inputStream through: Character space. "/skip username@host
    ts := Timestamp readFrom: inputStream.
    self addChange: (InfoChange type: #rake data: what timestamp: ts)

    "Created: / 01-08-2012 / 19:33:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process_removeClass_
    "'removeClass:' chunk (ST/X)"

    ^ self handleRemoveClassChange.
!

process_removeSelector_
    "'removeSelector:' chunk (ST/X)"

    ^ self handleRemoveMethodChange.
!

process_renameCategory_to_
    "'renameCategory:to:' chunk (ST/X)"

    ^ self handleMethodCategoryRenameChange.
!

process_renameClass_to_
    "'renameClass:to:' chunk (ST/X)"

    ^ self handleRenameClassChange.
!

process_snapshot
    "St/X system start info record

    '---- snapshot st.img 12-03-2012 10:49:40 ----'!!

    'start' is already read from inputStream.
    "

    | ts file |

    inputStream skipSeparators.
    file := inputStream through: Character space. "/read snapshot name
    ts := Timestamp readFrom: inputStream.
    self addChange: (InfoChange type: #snapshot data: file timestamp: ts)

    "Created: / 18-05-2012 / 17:04:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process_start
    "St/X system start info record

    '---- start 12-03-2012 10:49:40 ----'!!

    'start' is already read from inputStream.
    "

    | ts |

    inputStream skipSeparators.
    ts := Timestamp readFrom: inputStream.
    self addChange: (InfoChange type: #start data: nil timestamp: ts)

    "Created: / 18-05-2012 / 17:03:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process_timestamp
    "St/X timestamp info record. Example:

    '---- timestamp jv@neso 12-03-2012 10:49:40 ----'!!

    'timestamp' is already read from inputStream.
    "

    inputStream skipSeparators; through: Character space. "/read username@host
    timestamp := Timestamp readFrom: inputStream.

    "Created: / 02-04-2012 / 19:08:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::ChangeFileReader methodsFor:'reading-private-dolphin'!

process_categoriesForClass
    "'categoriesForClass' chunk (Dolphin)"

    ^ self handleCategoriesForClassChange.
!

process_categoriesFor_
    "'categoriesFor:' chunk (Dolphin)"

    ^ self handleCategoriesForChange.
!

process_methods
    "'methods' chunk (ST/V and dolphin)"

    ^ self handleMethodChange.
!

process_methodsFor
    "'methodsFor' chunk (ST/V and dolphin)"

    ^ self handleMethodChange.
!

process_methodsForUndefined_
    "'methodsForUndefined:' chunk (?)"

    ^ self handleMethodChange.
!

process_methodsFor_
    "'methodsFor:' chunk (ST/80, Squeak, ST/X, VW, ...)"

    ^ self handleMethodChange.
!

process_publicMethods
    "'publicMethods' chunk (ST/V and dolphin)"

    ^ self handleMethodChange.
! !

!ChangeSet::ChangeFileReader methodsFor:'reading-private-gravel'!

process_addClassMethod_
    "'reader addClassMethod:' chunk (gravel Smalltalk)"

    ^ self process_addMethodOrClassMethod:true
!

process_addMethodOrClassMethod:isClassMethod
    "'reader addMethod:' chunk (gravel Smalltalk)"

    |categoryName methodSource change parser|

    categoryName := (arguments at:1) evaluate.

    lineNumber := inputStream lineNumber.
    "/ Care for non-positionable streams
    position := nil.
    inputStream isPositionable ifTrue:[
	position := inputStream position + 1.
    ].
    methodSource := inputStream nextChunk.

    parser := Parser
		parseMethodArgAndVarSpecification:methodSource
		in:nil
		ignoreErrors:true
		ignoreWarnings:true
		parseBody:false.

    parser isNil ifTrue:[
	"/ something wierd ...
	methodSelector := '????'.
    ] ifFalse:[
	methodSelector := parser selector.
    ].

    isClassMethod ifTrue:[
	className := className , ' class'
    ].

    change := MethodDefinitionChange new.
    change
	className:className
	selector:methodSelector
	source:methodSource
	category:categoryName
	privacy:nil.

    self addChange:change.

"/ self halt.
    ^ true
!

process_addMethod_
    "'reader addMethod:' chunk (gravel Smalltalk)"

    ^ self process_addMethodOrClassMethod:false
!

process_addSimpleClassTrait_
    "'reader defineaddSimpleTraitTrait:' chunk (gravel Smalltalk)"

    |change traitName|

    traitName := (arguments at:1) evaluate.

    change := TraitDefinitionChange new.
    change
	className:className,' class';
	baseTrait:traitName;
	source:chunk.
"/ self halt.
    self addChange:change.
    ^ true
!

process_addSimpleTrait_
    "'reader defineaddSimpleTraitTrait:' chunk (gravel Smalltalk)"

    |change traitName gravelSuperclassName superclassName|

    traitName := (arguments at:1) evaluate.
    gravelSuperclassName := (arguments at:2) evaluate.
    superclassName := SourceFileLoader::SourceFileReader classNameMappingFor:gravelSuperclassName.

    change := TraitDefinitionChange new.
    change
	className:className;
	superClassName:superclassName;
	baseTrait:traitName;
	source:chunk.
"/ self halt.
    self addChange:change.
    ^ true
!

process_defineClass_superclass_
    "'reader defineClass:superclass:' chunk (gravel Smalltalk)"

    |nameSpace change gravelSuperclassName superclassName|

    className := (arguments at:1) evaluate.
    gravelSuperclassName := (arguments at:2) evaluate.
    superclassName := SourceFileLoader::SourceFileReader classNameMappingFor:gravelSuperclassName.

    nameSpace := Class nameSpaceQuerySignal query.
    (nameSpace == Smalltalk) ifTrue:[ nameSpace := nil ].

    change := ClassDefinitionChange new.
    change
	className:className;
	superClassName:superclassName;
	source:chunk.
"/ self halt.
    self addChange:change.
    ^ true
!

process_defineTrait_superclass_
    "'reader defineTrait:' chunk (gravel Smalltalk)"

    |nameSpace change|

    className := (arguments at:1) evaluate.

    nameSpace := Class nameSpaceQuerySignal query.
    (nameSpace == Smalltalk) ifTrue:[ nameSpace := nil ].

    change := TraitDefinitionChange new.
    change
	className:className;
	source:chunk.
"/ self halt.
    self addChange:change.
    ^ true
! !

!ChangeSet::ChangeFileReader methodsFor:'reading-private-squeak'!

process_commentStamp_prior_
    "'commentStamp:prior::' chunk (Squeak)"

    ^ self handleSqueakCommentStamp.
!

process_methodsFor_stamp_
    "'methodsFor:stamp:' chunk (Squeak)"

    ^ self handleMethodChange.
! !

!ChangeSet::ChangeFileWriter methodsFor:'source writing'!

fileOut: aChangeSet on: aStream
    | hasWideChars stream lastNameSpace |

    hasWideChars := aChangeSet contains:[:each | each source isWideString ].
    hasWideChars ifTrue:[
	stream := EncodedStream stream: aStream encoder: CharacterEncoder encoderForUTF8.
	stream nextPutAll: '"{ Encoding: utf8 }"'; cr; cr.
	stream nextPutAll: '!!'; cr; cr.
    ] ifFalse:[
	stream := aStream
    ].

    lastNameSpace := nil.

    aChangeSet do:[:eachChange |
	eachChange isClassChange ifTrue:[
	    | changeNameSpace |

	    changeNameSpace := eachChange nameSpaceName.
	    changeNameSpace ~= lastNameSpace ifTrue:[
		aStream nextPutAll: ('"{ NameSpace: %1 }"' bindWith: changeNameSpace).
		aStream cr; cr.
		stream nextPutLine:'!!'.
		lastNameSpace := changeNameSpace.
	    ].
	    eachChange isMethodCodeChange ifTrue:[
		stream nextPutAll:'!!'; nextPutAll:(eachChange className); nextPutAll:' methodsFor: '.
		stream nextPutAll:(eachChange methodCategory storeString).
		stream nextPutLine:'!!'.
		stream cr.
		stream nextPutAllAsChunk:(eachChange source).
		stream nextPutLine:'!! !!'.
	    ] ifFalse:[
		stream nextPutAll:(eachChange source).
		stream nextPutLine:'!!'.
	    ].
	].
	aStream cr.
    ].

    "Created: / 04-02-2014 / 18:51:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2014 / 12:48:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::BeeChangeFileReader methodsFor:'helpers'!

currentMethodProtocol
    "Returns a protocol of currently processed `MethodDefinition` change"

    | categoryIndex category|

    self assert: parseTree receiver name = 'MethodDefinition'.
    categoryIndex := parseTree selector keywords indexOf: 'category:'.
    category := parseTree arguments at: categoryIndex.
    ^ category value.

    "Created: / 27-02-2018 / 09:36:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

receiversClassNameRememberingNamespace
    ^ (parseTree arguments at: 3) value.

    "Created: / 21-08-2014 / 18:53:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::BeeChangeFileReader methodsFor:'reading-private'!

handleMethodChangeUnsafe
    | retval changeSetSize protocol |

    changeSetSize := changeSet size.
    retval := super handleMethodChangeUnsafe.
    protocol := self currentMethodProtocol.
    changeSetSize + 1 to: changeSet size do:[:i | 
        (changeSet at: i) category: protocol.
    ].
    ^ retval.

    "Created: / 27-02-2018 / 09:27:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processChangeUnsafe
    "given a parse-tree (from parsing some changes source/chunk),
     create changes and evaluate changeAction on each.
     The block is invoked with the change and a lineNumberOrNil as
     arg; the lineNumber is only valid, if the underlying stream
     provides line-numbers; otherwise, nil is passed."

    |dispatchSelector|

    dispatchSelector := ('process_',(selector copyReplaceAll:$: with:$_)) asSymbol.
"/ Transcript showCR:dispatchSelector.
    (self respondsTo:dispatchSelector) ifTrue:[
        ^ self perform:dispatchSelector.
    ].

    (parseTree receiver isVariable and:[ parseTree receiver name = 'MethodDefinition']) ifTrue:[ 
        ^ self handleMethodChange
    ].
    
    "/ any subclass definiton selector ?
    (Behavior definitionSelectors includes:selector)
    ifTrue:[
        ^ self handleClassDefinitionChange.
    ].

    self error:'unhandled change selector: ',selector.
    ^ false

    "Created: / 21-08-2014 / 18:37:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-02-2018 / 17:30:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-02-2018 / 09:26:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process_timeStamp_author_className_project_
    "/ Nothing to do

    "Created: / 26-02-2018 / 11:38:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::BeeChangeFileWriter methodsFor:'source writing'!

fileOut: aChangeSet on: aStream
    | hasWideChars stream |

    hasWideChars := aChangeSet contains:[:each | each source isWideString ].
    hasWideChars ifTrue:[
        stream := EncodedStream stream: aStream encoder: CharacterEncoder encoderForUTF8.
    ] ifFalse:[
        stream := aStream
    ].
    aChangeSet do:[:chg |
        chg isMethodDefinitionChange ifTrue:[
            self fileOutMethodDefinition: chg on: stream
        ] ifFalse:[ 
            chg isClassDefinitionChange ifTrue:[ 
                self fileOutClassDefinition: chg on: stream
            ] ifFalse:[ 
                self notYetImplemented
            ].
        ].
        stream cr.
    ].

    "Created: / 05-03-2018 / 12:53:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2018 / 13:53:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutClassDefinition: aMethodClassChange on: aStream

    aStream nextPutAll: '!!ClassDefinition timeStamp:'; nextPutAll: timestamp storeString; nextPutAll: ' author: ''Unknown'''; nextPutAll:' className: '; nextPutAll: aMethodClassChange className asString storeString; nextPutAll: '!!';cr.
    aStream nextPutAll: aMethodClassChange superClassName; cr;
        tab; nextPutAll: 'subclass: #'; nextPutAll: aMethodClassChange className; cr;
        tab; nextPutAll: 'instanceVariableNames: '; nextPutAll: aMethodClassChange instanceVariableString storeString ; cr;
        tab; nextPutAll: 'classVariableNames: '; nextPutAll: aMethodClassChange classVariableString storeString ; cr;
        tab; nextPutAll: 'poolDictionaries: '; nextPutAll: aMethodClassChange poolDictionaries ? '' storeString ; cr;
        nextPut: $!!; cr;
        cr.

    "Created: / 24-10-2017 / 11:52:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutMethodDefinition: aMethodDefinitionChange on: aStream
    aStream nextPutAll: '!!MethodDefinition timeStamp:'; nextPutAll: timestamp storeString; 
                nextPutAll: ' author: ';    nextPutAll: 'Unknown' storeString;
                nextPutAll: ' className: '; nextPutAll: aMethodDefinitionChange className storeString; 
                nextPutAll: ' selector: ';  nextPutAll: aMethodDefinitionChange selector storeString; 
                nextPutAll: ' category: ';  nextPutAll: aMethodDefinitionChange category storeString; 
                nextPutAll: '!!'.   
     aStream cr.
     aStream nextChunkPut: aMethodDefinitionChange source.
     aStream cr.

    "Created: / 24-10-2017 / 11:52:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::ClassSourceWriter methodsFor:'private'!

analyze
    "Analyzes changeset and build some index"

    classInfos := Dictionary new.
    metaInfos := Dictionary new.
    topClassName := nil.
    "Pass 1 - collect classes"
    changeSetBeingSaved do:[:change|
        | pkg |
        pkg := change package.
        packageName isNil ifTrue:[
            packageName := pkg.
        ] ifFalse:[
            "/Just a defensive check...
            self assert: (pkg isNil or:[pkg = packageName]) message: 'STC does not support multiple packages in source files'.
        ].

        change isClassDefinitionChange ifTrue:[
            | nm ns |

            nm := change className.
            (nm endsWith:' class') ifFalse:[
                (classInfos includesKey: nm) ifTrue:[
                    self error:'Multiple definitions of class ', nm.
                    ^self.
                ].
                classInfos at: nm put: (ClassInfo new name: nm).
                metaInfos at: nm put: (ClassInfo new name: nm , ' class').
                change isPrivateClassDefinitionChange ifFalse:[
                    topClassName notNil ifTrue:[
                        self error: ('Multiple top class definitions (%1 vs %2)' bindWith: topClassName with: nm).
                        ^self.
                    ].
                    topClassName := nm.
                    namespaceName := change nameSpaceName.

                ]
            ]
        ]
    ].

    "/ Could be an extension container...
    topClassName isNil ifTrue:[
        ^self
    ].

    "Pass 2: fill in infos"
    changeSetBeingSaved do:[:change|
        change isClassChange ifTrue:[
            | nm info |

            nm := change className.
            (nm endsWith: ' class') ifTrue:[
                info := metaInfos at: (nm copyButLast:(' class' size)).
            ] ifFalse:[
                info := classInfos at: nm.
                "Fill superclass info..."
                change isClassDefinitionChange ifTrue:[
                    | superNm |
                    superNm := change superClassName.
                    superNm notNil ifTrue:[
                        (classInfos includesKey: superNm) ifTrue:[
                            info superclass: (classInfos at: superNm).
                            (metaInfos at: nm) superclass: (classInfos at: superNm).
                        ].
                    ].
                ].
            ].
            info addChange: change.
        ]
    ].

    classInfos do:[:info|info namespace: namespaceName].
    metaInfos  do:[:info|info namespace: namespaceName].


    "
        ChangeSet::ClassSourceWriter new
            changeSetBeingSaved: (ChangeSet forExistingClass: ChangeSet);
            analyze;
            yourself

    "

    "Created: / 15-03-2012 / 17:51:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2013 / 17:59:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSetBeingSaved:something
    changeSetBeingSaved := something.
!

privateClassesOf: classInfo

    | classInfoNameSz |

    classInfoNameSz := classInfo name size.
    ^classInfos values select:[:info|
	info name size > classInfoNameSz and:[
	    (info name startsWith: classInfo name)
		and:[(info name at:classInfoNameSz + 1) == $:
		    and:[(info name at:classInfoNameSz + 2) == $:
			and:[(info name indexOf: $: startingAt: classInfo name size + 3) == 0]]]]
    ]

    "Created: / 15-03-2012 / 19:31:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

privateClassesSortedOf: classInfo

    |classes|

    classes := self privateClassesOf: classInfo.
    (classes size > 0) ifTrue:[
	classes := classes asOrderedCollection.
	classes sort:[:a :b | a name < b name].

	classes topologicalSort:[:a :b |
	    "/ a must come before b iff:
	    "/    b is a subclass of a
	    "/    b has a private class which is a subclass of a

	    |mustComeBefore privateClassesOfB|
	    mustComeBefore := (b isSubclassOf:a) or:[b isPrivateClassOf: a].
	    mustComeBefore
	].
    ].
    ^ classes.

    "
     Object privateClassesSorted
     NewSystemBrowser privateClassesSorted
     NewSystemBrowser privateClasses
    "

    "Created: / 15-03-2012 / 19:45:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::ClassSourceWriter methodsFor:'source writing'!

fileOut:aChangeSet on:outStreamArg
    |encoder any16Bit|

    any16Bit := aChangeSet contains:[:chg | |src| src := chg source. src notNil and:[src isWideString and:[ src contains: [:c | c codePoint > 16rFF ] ] ] ].
    any16Bit ifTrue:[
        encoder := CharacterEncoder encoderForUTF8.
    ].          


    ^ self
        fileOut: aChangeSet
        on:outStreamArg
        withTimeStamp:false
        withInitialize:true
        withDefinition:true
        methodFilter:nil encoder:encoder.

    "Created: / 04-02-2014 / 18:36:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-04-2015 / 21:27:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOut:aChangeSet on:outStreamArg withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter encoder:encoderOrNil

    |collectionOfCategories versionMethods extensionVersionMethods comment
     nonMeta meta classesImplementingInitialize outStream
     allMetaClassSelectors versionSelectors extensionVersionSelectors
     allVersionMethods|

    self todo:'code duplication with SmalltalkChunkFileSourceFileWriter - please refactor'.

    changeSetBeingSaved := aChangeSet.
    self analyze.

    encoderOrNil isNil ifTrue:[
        outStream := outStreamArg.
    ] ifFalse:[
        outStream := EncodedStream stream:outStreamArg encoder:encoderOrNil.
        outStream nextPutAll:'"{ Encoding: '; nextPutAll: encoderOrNil nameOfEncoding; nextPutAll: ' }"'; cr; cr.
    ].

    "/ Just a bunch of extensions?
    topClassName isNil ifTrue:[
        self fileOutMethodsOn: outStream.
        ^self.
    ].

    nonMeta := classInfos at: topClassName.
       meta :=  metaInfos at: topClassName.

    methodsAlreadySaved := Set new.



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
        outStream nextPutAll:(Smalltalk timeStamp).
        outStream nextPutChunkSeparator.
        outStream cr; cr.
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
            nonMeta printClassNameOn: outStream.
            outStream nextPutAll:' comment:'.
            comment comment storeOn: outStream.
            outStream cr.
            outStream nextPut:$!!; cr; cr.
        ].
        "/
        "/ ST/X primitive definitions - if any
        "/
        self fileOutPrimitiveSpecsOf: nonMeta on:outStream.
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

    "/ TODO: that does not work - MethodDefinition does not implement #isVisualWorksTypedef
"/    nonMeta methodDictionary keysAndValuesDo:[:sel :m |
"/        m isVisualWorksTypedef ifTrue:[
"/            self fileOutCategory:m category of:nonMeta except:nil only:(Array with:m) methodFilter:methodFilter on:outStream.
"/        ].
"/    ].
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
    (self privateClassesSortedOf: nonMeta) do:[:aClass |
        self fileOutAllMethodsOf:aClass on:outStream methodFilter:methodFilter
    ].


    "/
    "/ finally, the previously skipped version method(s) - but NOT the extension version methods
    "/
    versionMethods notEmpty ifTrue: [
        self fileOutCategory:'documentation' of:meta except:nil only:versionMethods methodFilter:methodFilter on:outStream.
    ].

    initIt ifTrue:[
        "/
        "/ optionally an initialize message
        "/
        classesImplementingInitialize := OrderedCollection new.

        classInfos values with: metaInfos values do:[:class :meta|
            (meta includesSelector: #initialize) ifTrue:[
                classesImplementingInitialize add: class.
            ]
        ].

        classesImplementingInitialize size ~~ 0 ifTrue:[
            classesImplementingInitialize topologicalSort:[:a :b | b isSubclassOf:a].
            outStream cr.
            classesImplementingInitialize do:[:eachClass |
                eachClass printClassNameOn:outStream. outStream nextPutAll:' initialize'.
                outStream nextPutChunkSeparator.
                outStream cr.
            ].
        ].
    ]

    "Created: / 15-11-1995 / 12:53:06 / cg"
    "Modified: / 01-04-1997 / 16:01:05 / stefan"
    "Modified: / 29-09-2011 / 14:53:49 / cg"
    "Created: / 15-03-2012 / 17:39:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-04-2015 / 21:25:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutAllDefinitionsOf:nonMetaInfo on:aStream
    "append expressions on aStream, which defines myself and all of my private classes."

    | metaInfo definition metaDefinition |

    definition := nonMetaInfo definition.
    definition isPrivateClassDefinitionChange ifFalse:[
        definition package notNil ifTrue:[
            aStream nextPutAll: ('"{ Package: ''%1'' }"' bindWith: definition package).
            aStream cr; cr.
        ].
        aStream nextPutAll: ('"{ NameSpace: %1 }"' bindWith: namespaceName ? 'Smalltalk').
        aStream cr; cr.
    ].

    aStream nextChunkPut: (definition definitionStringInNamespace: namespaceName).
    aStream cr; cr.

    "/
    "/ optional classInstanceVariables
    "/
    metaInfo := metaInfos at: nonMetaInfo name.
    metaDefinition := metaInfo definition.
    metaDefinition notNil ifTrue:[
        | anySuperClassInstVar myClass |
        aStream
            nextPutAll: metaDefinition className;
            nextPutAll:' instanceVariableNames:';
            nextPutAll: (metaDefinition classInstVarNames asStringWith:' ') storeString.
        "mhmh - good idea; saw this in SmallDraw sourcecode ..."

        anySuperClassInstVar := false.
        myClass := metaDefinition changeClass.
        myClass notNil ifTrue:[myClass := myClass theNonMetaclass].
        myClass notNil ifTrue:[
            myClass allSuperclassesDo:[:aSuperClass |
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
                myClass allSuperclassesDo:[:aSuperClass |
                    aStream tab; nextPutAll:aSuperClass name; nextPutAll:' - '.
                    aStream nextPutLine:(aSuperClass class instanceVariableString).
                ].

            ].
        ].
        aStream nextPut:(Character doubleQuote); cr.
        aStream nextPut:$!!; cr; cr
    ].

    "/ here, the full nameSpace prefixes are output,
    "/ to avoid confusing stc
    "/ (which otherwise could not find the correct superclass)
    "/
    Class fileOutNameSpaceQuerySignal answer:false do:[
        Class forceNoNameSpaceQuerySignal answer:true do:[
            (self privateClassesSortedOf: nonMetaInfo) do:[:i |
                 self fileOutAllDefinitionsOf:i on:aStream
            ]
        ]
    ].

    "Created: / 15-10-1996 / 11:15:19 / cg"
    "Modified: / 22-03-1997 / 16:11:56 / cg"
    "Created: / 15-03-2012 / 19:18:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-04-2015 / 18:32:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutAllMethodsOf:aClass on:aStream methodFilter:methodFilter
    | collectionOfCategories meta |

    meta := metaInfos at: aClass name.

    collectionOfCategories := meta categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
	collectionOfCategories do:[:aCategory |
	    self fileOutCategory:aCategory of:meta  methodFilter:methodFilter on:aStream.
"/            aStream cr.
	]
    ].
    collectionOfCategories := aClass categories asSortedCollection.
    collectionOfCategories notNil ifTrue:[
	collectionOfCategories do:[:aCategory |
	    self fileOutCategory:aCategory of:aClass methodFilter:methodFilter on:aStream.
"/            aStream cr.
	]
    ].

    (self privateClassesSortedOf: aClass) do:[:privateClass |
	self fileOutAllMethodsOf:privateClass on:aStream methodFilter:methodFilter
    ].

    "Created: / 15-10-1996 / 11:13:00 / cg"
    "Modified: / 22-03-1997 / 16:12:17 / cg"
    "Created: / 19-03-2012 / 18:21:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-05-2013 / 09:06:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutMethod:change on:aStream
    "file a single method onto aStream."

    | changeToFileOut |

    change isMethodCategoryChange ifTrue:[
	self assert: change origin notNil.
	changeToFileOut := change origin copy.
	changeToFileOut category: change category.
    ] ifFalse:[
	changeToFileOut := change.
    ].
    changeToFileOut source notEmptyOrNil ifTrue:[
	super fileOutMethod:changeToFileOut on:aStream
    ] ifFalse:[
"/        self error: 'Should not happen' mayProceed: true.
    ]

    "Created: / 20-03-2012 / 22:33:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutMethodsOn:stream
    "Writes a set of methods in changesetBeingSaved in same format as
     extensions.st created by source code management. Code stolen from

     AbstractSourceCodeManager class>>fileOutSourceCodeExtensions:package:on:version:
    "

    | methodsSortedByName |


	stream nextPutAll:'"{ Package: '''.
	stream nextPutAll:packageName asString.
	stream nextPutAll:''' }"'; nextPutChunkSeparator; cr; cr.

"/        s nextPutAll:(Smalltalk timeStamp).
"/        s nextPutChunkSeparator.
"/        s cr; cr.

	"/ sort them by name (to avoid conflict due to CVS merge)
	methodsSortedByName := changeSetBeingSaved.
	methodsSortedByName sort:[:a :b |
				    |clsA clsB|

				    clsA := a className.
				    clsB := b className.
				    clsA < clsB ifTrue:[
					true
				    ] ifFalse:[
					clsA > clsB ifTrue:[
					    false
					] ifFalse:[
					    a selector < b selector
					]
				    ]
				  ].
	methodsSortedByName do:[:aMethod |
	    |cat source privacy|

	    self assert: aMethod package = packageName.
	    "/self assert: aMethod programmingLanguage isSmalltalk.


	    stream nextPutChunkSeparator.
	    aMethod className printOn: stream.

	    (privacy := aMethod privacy) ~~ #public ifTrue:[
		stream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
	    ] ifFalse:[
		stream nextPutAll:' methodsFor:'.
	    ].

	    cat := aMethod category ? ''.
	    stream nextPutAll:cat asString storeString.
	    stream nextPutChunkSeparator; cr; cr.

	    source := aMethod source.
	    source isNil ifTrue:[
		"FileOutErrorSignal"Error
		    raiseRequestWith:self
		    errorString:(' - no source for method: ' ,
				 self className , '>>' ,
				 aMethod selector)
	    ] ifFalse:[
		stream nextChunkPut:source.
	    ].
	    stream space.
	    stream nextPutChunkSeparator.
	    stream cr.
	].

    "Created: / 30-01-2013 / 09:35:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutPrimitiveSpecsOf: nonMeta on:aStream
    "append primitive defs (if any) to aStream."

    |s|

    "
     primitive definitions - if any
    "
    (s := nonMeta primitiveDefinitionsString) notNil ifTrue:[
	aStream nextPutChunkSeparator.
	nonMeta printClassNameOn:aStream.
	aStream nextPutAll:' primitiveDefinitions';
		nextPutChunkSeparator;
		cr.
	aStream nextPutAll:s.
	aStream nextPutChunkSeparator; space; nextPutChunkSeparator; cr; cr
    ].
    (s := nonMeta primitiveVariablesString) notNil ifTrue:[
	aStream nextPutChunkSeparator.
	nonMeta printClassNameOn:aStream.
	aStream nextPutAll:' primitiveVariables';
		nextPutChunkSeparator;
		cr.
	aStream nextPutAll:s.
	aStream nextPutChunkSeparator; space; nextPutChunkSeparator; cr; cr
    ].

    "Created: / 15-03-2012 / 19:48:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateHeaderWithCopyrightOn:outStream
    |copyrightChange copyrightText|

    copyrightChange :=
        (metaInfos at: topClassName) methodAt: #copyright.


    copyrightChange notNil ifTrue:[
        "
         get the copyright method's comment-text, strip off empty and blank lines
         and insert at beginning.
        "
        copyrightText := Parser methodCommentFromSource: copyrightChange source.
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

    "Created: / 15-03-2012 / 19:01:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::ClassSourceWriter::ClassInfo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015-2018 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

version_SVN
    ^ '$Id$'
! !

!ChangeSet::ClassSourceWriter::ClassInfo class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ChangeSet::ClassSourceWriter::ClassInfo methodsFor:'accessing'!

categories

    ^ (methods collect:[:e|e category]) asSet

    "Created: / 19-03-2012 / 18:03:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

comment
    ^ comment
!

comment:something
    comment := something.
!

definition
    ^ definition
!

definition:something
    definition := something.
!

methodAt: selector
    ^methods detect:[:each|each selector == selector] ifNone:[nil].

    "Created: / 15-03-2012 / 19:11:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodDictionary
    methodDictionary isEmptyOrNil ifTrue:[
        methodDictionary := Dictionary new.
        self methodsDo:[:e | methodDictionary at: e selector put: e]  
    ].

    ^ methodDictionary.
    "Modified: / 13-04-2015 / 19:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methods
    ^ methods
!

methods:something
    methods := something.
    methodDictionary := Dictionary new.
    methods do:[:m|methodDictionary at: m selector put: m].

    "Modified: / 19-03-2012 / 18:12:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name
!

name:something
    name := something.
!

namespace
    ^ namespace
!

namespace:aString
    namespace := aString.
!

primitiveDefinitions
    ^ primitiveDefinitions
!

primitiveDefinitionsString
    ^ primitiveDefinitions isNil
	ifTrue:[nil]
	ifFalse:[primitiveDefinitions source]

    "Created: / 13-04-2012 / 13:14:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primitiveFunctions
    ^ primitiveFunctions
!

primitiveFunctionsString
    ^ primitiveFunctions isNil
	ifTrue:[nil]
	ifFalse:[primitiveFunctions source]

    "Created: / 13-04-2012 / 13:15:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primitiveVariables
    ^ primitiveVariables
!

primitiveVariablesString
    ^ primitiveVariables isNil
	ifTrue:[nil]
	ifFalse:[primitiveVariables source]

    "Created: / 13-04-2012 / 13:15:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectorAtMethod: m
    ^m selector

    "Created: / 19-03-2012 / 18:14:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

superclass
    ^ superclass
!

superclass:something
    superclass := something.
! !

!ChangeSet::ClassSourceWriter::ClassInfo methodsFor:'adding'!

addChange: change

    change isClassDefinitionChange ifTrue:[
	self assert: definition isNil.
	definition := change.
	^self.
    ].
    change isMethodCodeChange ifTrue:[
	methods add: change.
	^self.
    ].
    change isMethodCategoryChange ifTrue:[
	methods add: change.
	^self.
    ].

    change isClassInstVarDefinitionChange ifTrue:[
	self assert: definition isNil.
	definition := change.
	^self
    ].

    change isPrimitiveDefinitionsChange ifTrue:[
	primitiveDefinitions := change.
	^self
    ].

    change isPrimitiveVariablesChange ifTrue:[
	primitiveVariables := change.
	^self
    ].

    change isPrimitiveFunctionsChange ifTrue:[
	primitiveFunctions := change.
	^self
    ].

    change isClassCommentChange ifTrue:[
	comment := change.
	^self
    ].

    change isClassInitializeChange ifTrue:[
	"/ Ignore it, the class inititalization chunk is
	"/ written fileOut:on:withTimeStamp:withInitialize:withDefinition:methodFilter:encoder:
	"/ for all class implementing class-side #initialize
	^ self
    ].

    self error: 'Unknown change'

    "Created: / 15-03-2012 / 19:12:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-06-2014 / 08:14:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::ClassSourceWriter::ClassInfo methodsFor:'enumerating'!

methodsDo: aBlock

    methods do: aBlock

    "Created: / 19-03-2012 / 18:14:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::ClassSourceWriter::ClassInfo methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ name := nil.
    "/ instDefinition := nil.
    "/ classDefinition := nil.
    methods := OrderedCollection new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 15-03-2012 / 19:12:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::ClassSourceWriter::ClassInfo methodsFor:'printing & storing'!

printClassNameOn:aStream
    | nameWithoutNs |

    nameWithoutNs := name.
"/    namespace notNil ifTrue:[
"/        self assert: (name startsWith:namespace).
"/        nameWithoutNs := nameWithoutNs copyFrom: namespace size + 3.
"/    ].

    aStream nextPutAll: nameWithoutNs

    "Created: / 19-03-2012 / 18:17:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2013 / 17:59:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    aStream nextPutAll: self class nameWithoutPrefix.
    aStream nextPutAll:'('.
    name printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 19-03-2012 / 19:43:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::ClassSourceWriter::ClassInfo methodsFor:'queries'!

includesSelector: selector

    ^methods anySatisfy:[:m|m selector == selector].

    "Created: / 19-03-2012 / 18:22:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPrivateClassOf: classInfo

    ^(name startsWith: classInfo name)
	and:[ (name at: (classInfo name size + 1)) == $:
	    and:[ (name at: (classInfo name size + 2)) == $:]]

    "Created: / 15-03-2012 / 19:42:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSubclassOf: classInfo

    ^superclass notNil and:
	[superclass == classInfo or:[superclass isSubclassOf: classInfo]]

    "Created: / 15-03-2012 / 19:41:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::DiffSet class methodsFor:'documentation'!

documentation
"
    I represent the differences between two change sets.
    As such, I can be used by a VersionDiffBrowser and to generate patchSets.
"
! !

!ChangeSet::DiffSet methodsFor:'accessing'!

changed
    "return the set of methods which were different"

    ^ changed

    "Modified: / 12-10-2006 / 22:06:55 / cg"
!

changed:something
    "set the set of changed methods"

    changed := something.

    "Modified: / 12-10-2006 / 22:06:03 / cg"
!

changed:changedArg onlyInReceiver:onlyInReceiverArg onlyInArg:onlyInArgArg
    self changed:changedArg onlyInReceiver:onlyInReceiverArg onlyInArg:onlyInArgArg same:nil
!

changed:changedArg onlyInReceiver:onlyInReceiverArg onlyInArg:onlyInArgArg same: sameArg
    "set instance variables (automatically generated)"

    changed := changedArg.
    changed isNil ifTrue:[changed := OrderedCollection new].

    onlyInReceiver := onlyInReceiverArg.
    onlyInReceiver isNil ifTrue:[onlyInReceiver := ChangeSet new].

    onlyInArg := onlyInArgArg.
    onlyInArg isNil ifTrue:[onlyInArg := ChangeSet new].

    same := sameArg.
    same isNil ifTrue:[same := ChangeSet new].

    "Created: / 19-03-2012 / 21:35:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onlyInArg
    "return the set of methods which were only present in the argument of the diffset"

    ^ onlyInArg

    "Modified: / 12-10-2006 / 22:07:02 / cg"
!

onlyInArg:something
    onlyInArg := something.
!

onlyInReceiver
    "return the set of methods which were only present in the receiver of the diffset"

    ^ onlyInReceiver

    "Modified: / 12-10-2006 / 22:07:12 / cg"
!

onlyInReceiver:something
    onlyInReceiver := something.
!

same
    ^ same
!

same:something
    same := something.
! !

!ChangeSet::DiffSet methodsFor:'merging'!

addDiffSet:anotherDiffset
    changed addAll:(anotherDiffset changed).
    onlyInReceiver addAll:(anotherDiffset onlyInReceiver).
    onlyInArg addAll:(anotherDiffset onlyInArg).
    same addAll: (anotherDiffset same).

    "Created: / 12-10-2006 / 22:49:30 / cg"
    "Modified: / 19-03-2012 / 21:36:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

copy
    ^ self class new
	changed:changed copy
	onlyInReceiver:onlyInReceiver copy
	onlyInArg:onlyInArg copy
	same:same copy

    "Created: / 12-10-2006 / 22:50:56 / cg"
    "Modified: / 19-03-2012 / 21:36:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSet::DiffSet methodsFor:'misc'!

removeAllVersionMethods
    changed := changed
		    reject:[:pair |
			pair first isMethodChangeForVersionMethod
		    ].
    onlyInReceiver := onlyInReceiver
		    reject:[:chg |
			chg isMethodChangeForVersionMethod
		    ].
    onlyInArg := onlyInArg
		    reject:[:chg |
			chg isMethodChangeForVersionMethod
		    ].
!

sortByClassName
    onlyInReceiver notNil ifTrue:[
        onlyInReceiver := onlyInReceiver sortedByClassName.
    ].
    onlyInArg notNil ifTrue:[
        onlyInArg := onlyInArg sortedByClassName.
    ].
    changed notEmptyOrNil ifTrue:[
        changed := changed sort:[:pairA :pairB |
                        |nameA nameB chgA chgB|
                        chgA := pairA first. chgB := pairB first.
                        nameA := chgA isClassChange ifTrue:[chgA className] ifFalse:['^other'].
                        nameB := chgB isClassChange ifTrue:[chgB className] ifFalse:['^other'].
                        nameA < nameB]    
    ].
! !

!ChangeSet::DiffSet methodsFor:'queries'!

changedClasses
    |allChangedClasses|

    allChangedClasses := Set new.
    allChangedClasses addAll:(onlyInArg changedClasses).
    allChangedClasses addAll:(onlyInReceiver changedClasses).
    changed do:[:eachChangePair |
	allChangedClasses add:(eachChangePair first changeClass).
	allChangedClasses add:(eachChangePair second changeClass).
    ].
    allChangedClasses remove:nil ifAbsent:[].
    ^ allChangedClasses

    "Created: / 26-09-2012 / 15:39:18 / cg"
!

isEmpty
    ^ changed isEmpty
    and:[ onlyInReceiver isEmpty
    and:[ onlyInArg isEmpty ] ]
!

notEmpty
    ^ self isEmpty not

    "Created: / 12-10-2006 / 23:12:27 / cg"
! !

!ChangeSet::DolphinPACFileReader methodsFor:'reading-private'!

handleCategoriesForClass
    |category change|

    [
	inputStream skipSeparators.
	category := inputStream nextChunk.
	category notEmpty
    ] whileTrue:[
	change := ClassCategoryChange new.
	change
	    className:className
	    category:category.

	self addChange:change.
    ].
    ^ true
!

handleCategoriesForMethod
    |methodSelector categories change isPrivate isPublic category|

    methodSelector := (arguments at:1) evaluate.
    inputStream skipSeparators.
    isPrivate := false.

    categories := OrderedCollection new.
    [
	|done category |

	category := inputStream nextChunk withoutSeparators.
	done := category isEmpty.
	done ifFalse:[
	    categories add:category
	].
	done
    ] whileFalse.

    categories size > 1 ifTrue:[
	isPrivate := categories includes:'private'.
	categories remove:'private' ifAbsent:nil.
    ].
    categories size > 1 ifTrue:[
	isPublic := categories includes:'public'.
	categories remove:'public' ifAbsent:nil.
    ].
"/    categories size > 1 ifTrue:[
"/        self halt.
"/    ].

    category := categories first.
    isPrivate ifTrue:[
	category := category , '-private'.
    ].

    change := MethodCategoryChange new.
    change
	className:className
	selector:methodSelector
	category:category.

    self addChange:change.
    ^ true
!

processChange
    "given a parse-tree (from parsing some changes source/chunk),
     create changes and evaluate changeAction on each.
     The block is invoked with the change and a lineNumberOrNil as
     arg; the lineNumber is only valid, if the underlying stream
     provides line-numbers; otherwise, nil is passed."

    (selector == #'categoriesForClass') ifTrue:[
	^ self handleCategoriesForClass.
    ].
    (selector == #'categoriesFor:') ifTrue:[
	^ self handleCategoriesForMethod.
    ].
    selector == #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:' ifTrue:[
	^ self handleClassDefinitionChange.
    ].
"/    selector == #'guid:' ifTrue:[
"/        ^ self handleGUIDChange.
"/    ].
    ^ super processChange


"/    selector == #named:superclass:indexedInstanceVariables:instanceVariableNames:classVariableNames:sharedPools:classInstanceVariableNames: ifTrue:[
"/        ^ self handleClassDefinitionChange.
"/    ].
"/    (selector == #'key:value:') ifTrue:[
"/        (self checkReceiverIsGlobalNamed:'Annotation') ifTrue:[
"/            ^ self handleAnnotation.
"/        ]
"/    ].
"/    selector == #'method' ifTrue:[
"/        ^ self handleMethodChange:false.
"/    ].
"/    selector == #'classMethod' ifTrue:[
"/        ^ self handleMethodChange:true.
"/    ].
"/
"/    selector == #'initializer' ifTrue:[
"/        ^ true
"/    ].
"/    selector == #'initialize' ifTrue:[
"/        ^ true
"/    ].
"/self halt.
"/
"/    ^ false

    "Created: / 16.2.1998 / 13:42:40 / cg"
    "Modified: / 15.12.1999 / 00:29:06 / cg"
! !

!ChangeSet::InvalidChangeChunkError class methodsFor:'queries'!

mayProceed
    ^ true
! !

!ChangeSet::SIFChangeFileReader methodsFor:'reading-private'!

handleAnnotation
    |key value lastChange change|

    key := (arguments at:1) evaluate.
    value := (arguments at:2) evaluate.

    key = 'Prerequisite' ifTrue:[
"/        change := SIFPrerequisiteChange new prerequisiteFileName:value.
"/        self addChange:change.
	^ true
    ].

    lastChange := changeSet last.

    key = 'package' ifTrue:[
	change := ClassCategoryChange new className:(lastChange className) category:value.
	self addChange:change.
	^ true
    ].
    key = 'category' ifTrue:[
"/        change := MethodCategoryChange new className:(lastChange className) selector:(lastChange selector) category:value.
"/        self addChange:change.
	lastChange category:value.
	^ true
    ].
    key = 'stamp' ifTrue:[
	"/ lastChange timeStamp:value.
	^ true
    ].
    ^ false
!

handleClassDefinitionChange
    |nameSpace change|

    (self checkReceiverIsGlobalNamed:#Class) ifFalse:[
	self error:'unexpected receiver in classDefinition message' mayProceed:true.
	^ false.
    ].
    className := (arguments at:1) evaluate.

    nameSpace := Class nameSpaceQuerySignal query.
    nameSpace ~~ Smalltalk ifTrue:[
	className := nameSpace name , '::' , className
    ].

    change := ClassDefinitionChange new.
    change className:className; source:(parseTree printString).

    change package:(Class packageQuerySignal query).
    self addChange:change.
    ^ true
!

handleMethodChange:isMeta
    |categoryName methodSource change parser |

    className := self receiversClassName.
    isMeta ifTrue:[
	className := className , ' class'
    ].

    categoryName := 'uncategorized'.

    inputStream skipSeparators.
    lineNumber := inputStream lineNumber.
    position := inputStream position + 1.

    methodSource := inputStream nextChunk.

    parser := Parser
		parseMethodArgAndVarSpecification:methodSource
		in:nil
		ignoreErrors:true
		ignoreWarnings:true
		parseBody:false.

    parser isNil ifTrue:[
	"/ something wierd ...
	methodSelector := '????'.
    ] ifFalse:[
	methodSelector := parser selector.
    ].

    change := MethodDefinitionChange new.
    change
	className:className
	selector:methodSelector
	source:methodSource
	category:categoryName
	privacy:nil.

    self addChange:change.
    ^ true
!

processChange
    "given a parse-tree (from parsing some changes source/chunk),
     create changes and evaluate changeAction on each.
     The block is invoked with the change and a lineNumberOrNil as
     arg; the lineNumber is only valid, if the underlying stream
     provides line-numbers; otherwise, nil is passed."

    (selector == #'interchangeVersion:') ifTrue:[
	^ true
    ].
    selector == #named:superclass:indexedInstanceVariables:instanceVariableNames:classVariableNames:sharedPools:classInstanceVariableNames: ifTrue:[
	^ self handleClassDefinitionChange.
    ].
    (selector == #'key:value:') ifTrue:[
	(self checkReceiverIsGlobalNamed:'Annotation') ifTrue:[
	    ^ self handleAnnotation.
	]
    ].
    selector == #'method' ifTrue:[
	^ self handleMethodChange:false.
    ].
    selector == #'classMethod' ifTrue:[
	^ self handleMethodChange:true.
    ].

    selector == #'initializer' ifTrue:[
	^ true
    ].
    selector == #'initialize' ifTrue:[
	^ true
    ].

    ^ false

    "Created: / 16.2.1998 / 13:42:40 / cg"
    "Modified: / 15.12.1999 / 00:29:06 / cg"
! !

!ChangeSet class methodsFor:'documentation'!

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
    ^ '$Id$'
! !

