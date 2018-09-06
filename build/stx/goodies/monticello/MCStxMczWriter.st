"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCMczWriter subclass:#MCStxMczWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X Storing'
!

!MCStxMczWriter class methodsFor:'documentation'!

documentation
"
    redefined to add some more stuff to the mcz archive:

    - package pragma to the source code.
    - stx subdirectory (optional), containing required support files for building
          plus resource files.
    - stx.bin subdirectory (optional), containing a precompiled binary dll as per architecture.
"
! !

!MCStxMczWriter class methodsFor:'as yet unclassified'!

readerClass
    ^ MCStXMczReader

    "Created: / 10-05-2015 / 05:46:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStxMczWriter methodsFor:'accessing'!

snapshotWriterClass
        ^ MCStxStWriter
! !

!MCStxMczWriter methodsFor:'serializing'!

serializeDefinitions:definitions
    |string|

    string := super serializeDefinitions:definitions.
    string isWideString ifTrue:[
        ^ string utf8Encoded
    ].
    ^ string
!

serializePackageStX:aPackage
    ^ '(name ''', aPackage packageInfo projectDefinition package , ''')'

    "Created: / 29-05-2013 / 01:49:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStxMczWriter methodsFor:'visiting'!

writeBuildSupportFiles:aVersion for:aProjectDefinition
    Error handle:[:ex |
        Dialog information:('Cannot write build support files because:\\',ex description,'\\Writing source files only.') withCRs.
        ^ self
    ] do:[
        aProjectDefinition forEachFileNameAndGeneratedContentsDo:[:file :contents |
            self addString: contents at: 'snapshot.stx/', file.
        ].
    ]
!

writeIndividualSourceFiles:aVersion for:aProjectDefinition
    "individual source files for dll compilation"

    aProjectDefinition classNames do:[:eachClassName |
        |cls fileName source|

        cls := Smalltalk classNamed:eachClassName.
        cls isNil ifTrue:[
            Transcript showCR:'class missing: ',eachClassName
        ] ifFalse:[
            cls autoload.

            fileName := (Smalltalk fileNameForClass:cls),'.st'.
            source := String streamContents:[:s | cls fileOutOn:s withTimeStamp:false].
            self addString: source at: 'snapshot.stx/', fileName.                               
        ]
    ].
!

writePackage: aPackage
    super writePackage: aPackage.
    aPackage isStXPackage ifTrue:[
        self writePackageStX:aPackage
    ]

    "Created: / 29-05-2013 / 01:48:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writePackageStX:aPackage 
    self addString:(self serializePackageStX:aPackage) at:'package.stx'

    "Created: / 29-05-2013 / 01:48:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeResourceFiles:aVersion for:aProjectDefinition
    "language translations kept in externalfiles"

    |dir rsrcDir|

    dir := aProjectDefinition projectDirectory.
    dir isNil ifTrue:[
        "/ no directory - no resource files
        ^  self.
    ].
    (rsrcDir := dir asFilename / 'resources') exists ifTrue:[
        rsrcDir recursiveDirectoryContentsDo:[:relFn |
            (rsrcDir construct:relFn) isDirectory ifFalse:[
                self addString: ((rsrcDir construct:relFn) contentsOfEntireFile) at: 'snapshot.stx/resources/', relFn.
            ]            
        ].
    ].
!

writeSnapshot: aSnapshot  forVersion: aVersion
    | source snapshot |

    snapshot := MCStXSnapshotPreWriteTransformation transform: aSnapshot.
    source := 
        ('"{ Package: ''%1'' }" !!\\' withCRs bindWith:aVersion package name)
        ,  (self serializeDefinitions: snapshot definitions).

    self addString: source at: 'snapshot/source.', self snapshotWriterClass extension.
    "/ CG: I think, we can comment the following (or is it compatible?)

    "/ JV: 
    "/ NO, DON'T DO IT!! snapshot.bin is THE ONLY thing that Pharo/Squeak reads.
    "/ It does not care about snapshot/source.st, actually
    self addString: (self serializeInBinary: snapshot) at: 'snapshot.bin'

    "Modified (comment): / 31-07-2015 / 08:59:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeVersion: aVersion
    |packageID prjDef|

    super writeVersion: aVersion.

    aVersion snapshot options includeExtrasForSTX ifTrue:[
        "/ ST/X specific stuff here.

        packageID := aVersion package name.
        prjDef := ProjectDefinition definitionClassForPackage:packageID.
        prjDef isNil ifTrue:[
            "/ not a project definition mcz - simply skip
            Transcript show:'No projectDefinition for ',packageID, ' generated simple source only'.
        ] ifFalse:[
            "/ additional support files for recompilation...
            self writeIndividualSourceFiles: aVersion for: prjDef.
            self writeBuildSupportFiles: aVersion for: prjDef.
            self writeResourceFiles: aVersion for: prjDef.
        ]
    ]

    "Modified: / 07-09-2015 / 15:28:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStxMczWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStxMczWriter.st,v 1.6 2013-05-29 11:47:31 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStxMczWriter.st,v 1.6 2013-05-29 11:47:31 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

