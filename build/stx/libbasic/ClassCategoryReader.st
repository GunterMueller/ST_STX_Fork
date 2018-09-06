"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

Object subclass:#ClassCategoryReader
	instanceVariableNames:'myClass myCategory privacy ignore primSpec'
	classVariableNames:'SourceMode SkipUnchangedMethods'
	poolDictionaries:''
	category:'Kernel-Support'
!

!ClassCategoryReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    a helper class for fileIn - keeps track of class and category to filein for.
    Instances of this are created by the #methodsFor: methods in Class, to
    read the next chunk(s) from a stream.

    ClassCategoryReaders allow different ways of keeping the sourceCode of its
    loaded code. This is controlled by the SourceMode class variable which may be:

        #discard         - forget the source code; no browsing/recompilation is possible

        #keep            - keep the source code as a string.
                           any saved image will later be fully independent of any
                           source files.

        #reference       - keep a reference to the loaded files basename
                           In order to be browsable, the original sourcefile should be
                           found along the sourcePath 
                           (i.e. typically a link in the source directory should be present)

        #absReference    - keep a reference to the loaded files absolute pathname
                           but only if the file ends with .st.
                           (this is ok in multiUser configurations, where all sourcefiles are mounted
                           on a common path; typically automounted systems)

        #forceAbsReference 
                         - like above, but also do it for files not ending with .st.
                           Must be used with care - NEVER ever reference sources from the changes
                           file, because the changesBrowser does not adjust methods sources
                           when it compresses or removes changes.

        #sourceReference - append source to the `st.src' file,
                           and keep a reference to that file.
                           if the image is later moved to another location,
                           this file should be moved along with it.

    [author:]
        Claus Gittinger

    [see also:]
        Class PositionableStream
"
! !

!ClassCategoryReader class methodsFor:'initialization'!

initialize
    SourceMode := #keep.
    SkipUnchangedMethods := true.

    "
     ClassCategoryReader initialize
    "

    "Modified: 14.2.1997 / 18:26:52 / cg"
! !

!ClassCategoryReader class methodsFor:'instance creation'!

class:aClass
    "return a new ClassCategoryReader to operate on aClass"

    ^ self new class:aClass
!

class:aClass category:aCategory
    "return a new ClassCategoryReader to read methods for aClass with
     methodCategory aCategory"

    ^ self new class:aClass category:aCategory
!

class:aClass primitiveSpec:which
    "return a ClassCategoryReader to read a primitiveSpec chunk"

    ^ self new class:aClass primitiveSpec:which
! !

!ClassCategoryReader class methodsFor:'defaults'!

keepSource
    ^ SourceMode == #keep

    "Created: 9.9.1995 / 15:22:27 / claus"
!

keepSource:aBoolean
    SourceMode := (aBoolean ifTrue:[#keep] ifFalse:[#reference])

    "Created: 9.9.1995 / 15:22:26 / claus"
    "Modified: 9.2.1996 / 17:23:04 / cg"
!

skipUnchangedMethods
    "return true, if the default for unchanged methods is to skip them.
     The default is true."

    ^ SkipUnchangedMethods

    "Created: 14.2.1997 / 18:27:49 / cg"
    "Modified: 14.2.1997 / 18:28:13 / cg"
!

skipUnchangedMethods:aBoolean
    "return true, if the default for unchanged methods is to skip them.
     The default is true. Can be temporarily changed to false, if
     a forced fileIn is required."

    SkipUnchangedMethods := aBoolean

    "Created: 14.2.1997 / 18:27:43 / cg"
    "Modified: 14.2.1997 / 18:28:42 / cg"
!

sourceMode 
    "return the sourceMode, which controls how sources are to be handled.
     Read #documentation for more info"

    ^ SourceMode

    "Created: 9.2.1996 / 17:22:58 / cg"
!

sourceMode:aSymbol 
    "set the sourceMode, which controls how sources are to be handled.
     Read #documentation for more info"

    SourceMode := aSymbol

    "Created: 9.2.1996 / 17:23:00 / cg"
! !

!ClassCategoryReader methodsFor:'fileIn'!

fileInFrom:aStream
    "read method-chunks from the input stream, aStream; compile them
     and add the methods to the class defined by the class-instance var"

    ^ self 
        fileInFrom:aStream 
        notifying:nil 
        passChunk:false
        single:false
        silent:nil

    "Modified: / 17.5.1998 / 19:58:33 / cg"
!

fileInFrom:aStream notifying:requestor passChunk:passChunk
    "read method-chunks from the input stream, aStream; compile them
     and add the methods to the class defined by the class-instance var;
     errors and notifications are passed to requestor.
     If passChunk is true, chunks are given to the requestor,
     via a #source: message, allowing it to open a view showing any
     arronous source code."

    ^ self
        fileInFrom:aStream 
        notifying:requestor 
        passChunk:passChunk 
        single:false
        silent:nil

    "Modified: / 17.5.1998 / 19:58:15 / cg"
!

fileInFrom:aStream notifying:requestor passChunk:passChunk single:oneChunkOnly
    "read method-chunks from the input stream, aStream; compile them
     and add the methods to the class defined by the class-instance var;
     errors and notifications are passed to requestor.
     If passChunk is true, chunks are given to the requestor,
     via a #source: message, allowing it to open a view showing any
     erroneous source code.
     If oneChunkOnly is true, the fileIn is finished after the first chunk."

    ^ self
        fileInFrom:aStream 
        notifying:requestor 
        passChunk:passChunk 
        single:oneChunkOnly 
        silent:nil

    "Modified: / 17.5.1998 / 19:58:05 / cg"
!

fileInFrom:aStream notifying:requestor passChunk:passChunk single:oneChunkOnly silent:beSilent
    "read method-chunks from the input stream, aStream; compile them
     and add the methods to the class defined by the class-instance var;
     errors and notifications are passed to requestor.
     If passChunk is true, chunks are given to the requestor,
     via a #source: message, allowing it to open a view showing any
     erroneous source code.
     If oneChunkOnly is true, the fileIn is finished after the first chunk.
     The beSilent argument controls output to the transcript, if its true or
     false. If its nil, output is controlled by the Smalltalk>>silenLoading setting."

    |aString done method compiler canMakeSourceRef sourceFile pos nm src s silent|

    (silent := Object infoPrinting not) ifFalse:[
        silent := beSilent ? Smalltalk silentLoading
    ].
    
    silent ifFalse:[
        myClass isNil ifTrue:[
            nm := '** UndefinedClass **'
        ] ifFalse:[
            nm := myClass name
        ].
        Transcript show:'  '; show:nm; show:' -> '; show:myCategory.
        ignore ifTrue:[
            Transcript show:' (** ignored **)'.
        ] ifFalse:[
            privacy notNil ifTrue:[
                Transcript show:' (** '; show:privacy; show:' **)'
            ]
        ].
        Transcript cr.
    ].

    canMakeSourceRef := false.

    "/
    "/ SourceMode controls if
    "/ the sourceString should be kept or
    "/ a reference to the fileStream should be placed into the
    "/ method instead.
    "/
    ((SourceMode ~~ #keep) 
    and:[SourceMode ~~ #discard]) ifTrue:[
        aStream isFileStream ifTrue:[
            sourceFile := aStream pathName.
            "/
            "/ only do it, if the sourceFiles name
            "/ ends with '.st'
            "/ this prevents methods from referencing the changes file.
            "/
            ((SourceMode == #forceAbsReference)
            or:[sourceFile asFilename hasSuffix:'st']) ifTrue:[
                canMakeSourceRef := true.

                (SourceMode ~~ #absReference
                and:[SourceMode ~~ #forceAbsReference]) ifTrue:[
                    SourceMode == #sourceReference ifTrue:[
                        sourceFile := 'st.src'.
                    ] ifFalse:[
                        sourceFile := aStream pathName asFilename baseName
                    ]
                ]
            ]
        ]
    ].

    done := false.
    [done] whileFalse:[
        done := aStream atEnd.
        done ifFalse:[
            canMakeSourceRef ifTrue:[
                pos := aStream position + 1
            ].
            aString := aStream nextChunk.
            aStream skipSeparators.
            done := aString size == 0.
            done ifFalse:[
                primSpec notNil ifTrue:[
                    ignore ifFalse:[
                        myClass perform:primSpec with:aString.
                        "
                         ignore rest
                        "
                        ignore := true
                    ]
                ] ifFalse:[
                    passChunk ifTrue:[
                        requestor source:aString
                    ].

                    compiler := myClass compilerClass.

                    "/
                    "/ kludge - for now;
                    "/ have to make ST/X's compiler protocol be compatible to ST-80's
                    "/ for other compilers to work ... (TGEN for example)
                    "/
                    (compiler respondsTo:#compile:forClass:inCategory:notifying:install:skipIfSame:silent:)
                    ifTrue:[
                        "/ ST/X's compiler
                        method := compiler
                                     compile:aString
                                     forClass:myClass
                                     inCategory:myCategory
                                     notifying:requestor
                                     install:true
                                     skipIfSame:SkipUnchangedMethods
                                     silent:silent.

                        (method notNil and:[method ~~ #Error]) ifTrue:[
                            canMakeSourceRef ifTrue:[
                                (src := method getSource) = aString ifTrue:[
                                    "/ it was not corrected ...

                                    SourceMode == #sourceReference ifTrue:[
                                        s := sourceFile asFilename appendingWriteStream.
                                        s setToEnd.     
                                        pos := s position + 1.
                                        s nextChunkPut:src.
                                        s close.
                                    ].
                                    method sourceFilename:sourceFile position:pos 
                                ]
                            ] ifFalse:[
                                SourceMode == #discard ifTrue:[
                                    method sourceFilename:nil position:nil
                                ]
                            ]
                        ]
                    ] ifFalse:[
                        "/ some generated (TGEN) compiler
                        method := compiler new
                                      compile:aString 
                                      in:myClass 
                                      notifying:requestor 
                                      ifFail:nil
                    ].

                    ignore ifTrue:[
                        method setPrivacy:#ignore
                    ] ifFalse:[
                        privacy notNil ifTrue:[
                            method setPrivacy:privacy
                        ]
                    ]
                ]
            ].
            oneChunkOnly ifTrue:[done := true].
        ]
    ]

    "Modified: / 09-09-1995 / 15:29:08 / claus"
    "Modified: / 23-01-1998 / 15:25:01 / stefan"
    "Created: / 17-05-1998 / 19:56:32 / cg"
    "Modified: / 31-07-2011 / 09:30:07 / cg"
!

fileInFrom:aStream silent:beSilent
    "read method-chunks from the input stream, aStream; compile them
     and add the methods to the class defined by the class-instance var.
     The beSilent argument controls if a message is to be sent to the Transcript."

    ^ self 
        fileInFrom:aStream 
        notifying:nil 
        passChunk:false
        single:false
        silent:beSilent

    "Created: / 17.5.1998 / 19:59:08 / cg"
    "Modified: / 17.5.1998 / 19:59:57 / cg"
! !

!ClassCategoryReader methodsFor:'private'!

class:aClass category:aCategory
    "set the instance variables"

    myClass := aClass.
    "/ ensure that the class is loaded.
    myClass autoload.
    myCategory := aCategory.
    ignore := false
!

class:aClass primitiveSpec:which
    "set the instance variables"

    myClass := aClass.
    "/ ensure that the class is loaded.
    myClass autoload.
    primSpec := which.
    ignore := false
! !

!ClassCategoryReader methodsFor:'special'!

ignoredProtocol 
    ignore := true

    "Created: 10.2.1996 / 12:54:15 / cg"
!

privateProtocol
    privacy := #private
!

protectedProtocol
    privacy := #protected
! !

!ClassCategoryReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ClassCategoryReader initialize!
