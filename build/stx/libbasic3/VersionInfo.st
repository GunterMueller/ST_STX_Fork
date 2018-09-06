"
 COPYRIGHT (c) 2008 by eXept Software AG
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

Object subclass:#VersionInfo
	instanceVariableNames:'moreAttributes logMessage revision binaryRevision user timestamp
		date time fileName state'
	classVariableNames:''
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!VersionInfo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
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
    In ancient times, Class used to return a Dictionary when asked for versionInfo.
    This has been replaced by instances of this class and subclasses.

    Notice, that subclasses may add more info for specific source repositories
    (CVSVersionInfo, MonticelloVersionInfo etc.).
    However, any generic tools/ui should only depend on the values (and getters) found here.

    [author:]
        cg (cg@AQUA-DUO)
"
! !

!VersionInfo methodsFor:'accessing'!

at:aSymbolKey
    "backward compatible dictionary-like accessing"

    ^ self 
        at:aSymbolKey 
        ifAbsent:[ self warn:'VersionInfo: no such property: ',aSymbolKey. nil]

    "
     self new at:#binaryRevision
     self new at:#foo
    "

    "Modified: / 22-10-2008 / 20:23:31 / cg"
!

at:aSymbolKey ifAbsent:replacement
    "backward compatible dictionary-like accessing"

    (self respondsTo:aSymbolKey) ifTrue:[
        ^ (self perform:aSymbolKey)
    ].
    moreAttributes notNil ifTrue:[
        ^ moreAttributes at:aSymbolKey ifAbsent:replacement
    ].    
    ^ replacement value

    "
     self new at:#binaryRevision
     self new at:#foo ifAbsent:#bar
    "

    "Created: / 22-10-2008 / 20:19:42 / cg"
!

at:aSymbolKey put:value
    "backward compatible dictionary-like accessing"

    |setter|

    setter := aSymbolKey asMutator.
    (self respondsTo:setter) ifTrue:[
        self perform:setter with:value.
        ^ value "/ sigh
    ].
    moreAttributes isNil ifTrue:[
        moreAttributes := IdentityDictionary new.
    ].
    moreAttributes at:aSymbolKey put:value.
    ^ value "/ sigh

    "
     self new at:#binaryRevision put:#bar
     self new at:#foo put:#bar; yourself
    "

    "Created: / 22-10-2008 / 20:20:54 / cg"
!

author
    ^ self user

    "Created: / 21-12-2011 / 23:09:54 / cg"
!

author:aString
    ^ self user:aString

    "Created: / 21-12-2011 / 23:09:54 / cg"
!

binaryRevision
    ^ binaryRevision
!

binaryRevision:aString
    binaryRevision := aString.
!

date
    timestamp notNil ifTrue:[^ timestamp asDate].
    ^ date
!

date:something
    date := something.
!

day
    ^ date
!

fileName
    ^ fileName
!

fileName:aString
    fileName := aString.
!

keysAndValuesDo:aBlock
    self class instVarNames do:[:nm |
        nm ~= 'moreAttributes' ifTrue:[   
            aBlock value:(nm asSymbol) value:(self perform:nm asSymbol)
        ].
    ].
    moreAttributes notNil ifTrue:[
        moreAttributes keysAndValuesDo:aBlock
    ].
    
    "Created: / 22-10-2008 / 20:48:08 / cg"
!

logMessage
    ^ logMessage
!

logMessage:aString
    logMessage := aString.
!

majorVersion
    |v|

    v := self revision.
    v notEmptyOrNil ifTrue:[
        ^ v upTo:$.
    ].
    ^ nil

    "
     Array revisionInfo majorVersion
    "
!

minorVersion
    |v|

    v := self revision.
    v notEmptyOrNil ifTrue:[
        ^ v copyFrom:(v indexOf:$.)+1
    ].
    ^ nil

    "
     Array revisionInfo minorVersion
    "
!

repositoryPathName
    "raise an error: must be redefined in concrete subclass(es)"

    ^ nil "Not known"

    "Modified: / 23-11-2011 / 23:33:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision
    ^ revision
!

revision:aString
    revision := aString.
!

state
    ^ state
!

state:something
    state := something.
!

symbolicVersionName
    "iff that source code manager uses cryptic names for versions,
     (eg. dbManager, git and hg managers), we may add an additional symbolic
     version name, which is used for human readers (and not required to be unique).
     Usually something like x.y-nn, where nn is the user name is returned there.
     Here, we return the revision proper, which is ok for cvs, svn and others with a 
     user-friendly version number."

    ^ revision
!

time
    timestamp notNil ifTrue:[^ timestamp asTime].
    ^ time
!

time:something
    time := something.
!

timeStamp:aTimestamp
    date := aTimestamp asDate.
    time := aTimestamp asTime.

    "Created: / 04-12-2011 / 10:06:02 / cg"
!

timestamp
    timestamp notNil ifTrue:[^ timestamp].
    date isNil ifTrue:[^ nil].
    time isNil ifTrue:[
        Error handle:[:ex |
            ^ nil
        ] do:[    
            ^ date asTimestamp
        ].
    ].
    ^ Timestamp fromDate:date andTime:time
!

timestamp:aTimestamp
    timestamp := aTimestamp

    "Created: / 04-12-2011 / 10:06:02 / cg"
!

timezone
    timestamp notNil ifTrue:[^ timestamp timezone].
    
    ^ nil "Not known"

    "Modified: / 23-11-2011 / 13:54:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

user
    ^ user
!

user:aString
    user := aString.
! !

!VersionInfo class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

