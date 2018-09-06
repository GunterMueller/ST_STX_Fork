"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCWriter subclass:#MCMczWriter
	instanceVariableNames:'zip infoWriter'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Storing'
!


!MCMczWriter class methodsFor:'initialization'!

new
    ^self basicNew initialize
! !

!MCMczWriter class methodsFor:'as yet unclassified'!

fileOut: aVersion on: aStream
	| inst |
	inst := self on: aStream.
	inst writeVersion: aVersion.
	inst flush.
	

!

readerClass
	^ MCMczReader
! !

!MCMczWriter methodsFor:'accessing'!

format
	^ '1'
!

snapshotWriterClass
	^ MCStWriter
!

stream: aStream

    super stream: aStream.
    self zip.

    "Created: / 11-09-2010 / 14:18:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

zip

    zip ifNil:[zip := ZipArchive writingTo: stream].
    ^ zip

    "Modified: / 11-09-2010 / 14:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCMczWriter methodsFor:'initializing'!

initialize
        super initialize.
        "/zip := ZipArchive new.

    "Modified: / 11-09-2010 / 14:13:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCMczWriter methodsFor:'serializing'!

serializeDefinitions: aCollection
        | writer s |
        s := CharacterWriteStream on: (String new: 64).
        writer := self snapshotWriterClass on: s.
        writer writeDefinitions: aCollection.
        ^ s contents

    "Modified: / 05-05-2012 / 19:38:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

serializeInBinary:aSnapshot 
    |writer s|

    s := ReadWriteStream on:ByteArray new.
    writer := DataStream on:s.
    writer nextPut:aSnapshot.
    ^ s contents

    "Modified: / 11-09-2010 / 19:24:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

serializePackage: aPackage
        ^ '(name ''', aPackage monticelloName, ''')'

    "Modified: / 29-05-2013 / 02:10:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

serializeVersionInfo: aVersionInfo
	infoWriter ifNil: [infoWriter := MCVersionInfoWriter new].
	^ String streamContents:
		[:s |
		infoWriter stream: s.
		infoWriter writeVersionInfo: aVersionInfo]
! !

!MCMczWriter methodsFor:'visiting'!

writeDefinitions: aVersion
        self writeSnapshot: aVersion snapshot forVersion: aVersion
!

writeFormat
"	self addString: self format at: 'format'."
!

writePackage: aPackage
	self addString: (self serializePackage: aPackage) at: 'package'
!

writeSnapshot: aSnapshot
    self addString: (self serializeDefinitions: aSnapshot definitions) at: 'snapshot/source.', self snapshotWriterClass extension.
    self addString: (self serializeInBinary: aSnapshot) at: 'snapshot.bin'

    "Created: / 29-05-2013 / 12:01:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeSnapshot: aSnapshot  forVersion: aVersion    
    self writeSnapshot: aSnapshot

    "Created: / 29-05-2013 / 12:04:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeVersion: aVersion
	self writeFormat.
	self writePackage: aVersion package.
	self writeVersionInfo: aVersion info.
	self writeDefinitions: aVersion.
	aVersion dependencies do: [:ea | self writeVersionDependency: ea]
!

writeVersionDependency: aVersionDependency
	| string |
	string := (self serializeVersionInfo: aVersionDependency versionInfo).
	self addString: string at: 'dependencies/', aVersionDependency package name
!

writeVersionInfo: aVersionInfo
	| string |
	string := self serializeVersionInfo: aVersionInfo.
	self addString: string at: 'version'.

! !

!MCMczWriter methodsFor:'writing'!

addString: string at: path
        | member |
        member := zip addString: string as: path.
        "/member desiredCompressionMethod: ZipArchive compressionDeflated

    "Modified: / 11-09-2010 / 14:19:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flush
        "zip writeTo: stream."
        zip close.
        stream close

    "Modified: / 11-09-2010 / 19:36:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCMczWriter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

