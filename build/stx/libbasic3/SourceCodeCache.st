"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

Object subclass:#SourceCodeCache
	instanceVariableNames:''
	classVariableNames:'Default'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!SourceCodeCache class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    This class represents global source code cache for caching
    class source in multiple revisions. 

    It is intended to replace caching (copy-paste) code in 
    CVS/Perforce source code managers in #streamForClass:...

    More features are planned in future like setting a limit
    for cache size or compressing cached files in a .zip file
    to save disk space.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        CVSSourceCodeManager class>>streamForClass:fileName:revision:directory:module:cache:
        PerforceSourceCodeManager class>>streamForClass:fileName:revision:directory:module:cache:
"
! !

!SourceCodeCache class methodsFor:'accessing'!

default

    Default isNil ifTrue:[Default := self new].
    ^Default

    "Created: / 11-10-2011 / 23:23:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeCache methodsFor:'accessing'!

streamForClass:aClass fileName:classFileName revision:revisionString repository: repositoryId module:moduleDir directory:packageDir ifAbsent: block

    "Answers a stream for given class (stored in classFileName) at
     given revision. If the stream is not in the cache, then the
     block is called with the desired cached filename as an argument.
     The block should return a stream (not necesarily on the filename
     passed)."

    | file stream |
    file := self cachedFileNameForRepository: repositoryId module: moduleDir directory: packageDir container: classFileName revision: revisionString.
    file exists ifTrue:[
        ^file readStream.
    ].

    [ 
        file directory recursiveMakeDirectory 
    ] on: Error do:[:ex|
        self error: 'Cannot make cache directory: ', ex description.        
    ].
    stream := block valueWithOptionalArgument: file.
    stream isNil ifTrue:[^nil].
    stream isPositionable ifFalse:[
        self error: 'Source stream is not positionable!!'.
    ].
    stream isFileStream ifTrue:[
        stream pathName ~= file pathName ifTrue:[
            stream pathName asFilename copyTo: file.
        ].
    ] ifFalse:[
        file writingFileDo:[:cache|
            [ stream atEnd ] whileFalse:[
                cache nextPutAll: (stream next: 4096)
            ].
        ].
        stream position: 0.
    ].
    ^stream

    "Created: / 12-10-2011 / 09:58:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeCache methodsFor:'private'!

cachedFileNameForRepository: repositoryId module: module directory: package container: container revision: revision

    | cache |
    cache := AbstractSourceCodeManager cacheDirectoryName.
    cache isNil ifTrue:[AbstractSourceCodeManager initCacheDirPath].
    cache := AbstractSourceCodeManager cacheDirectoryName.
    ^ cache asFilename
        "/ repositoryId "/ TODO: Ignored for now, discuss with Claus
        / module
        / (package copyReplaceAll:$/ with: Filename separator) 
        / (container, '_' , revision)

    "
        SourceCodeCache default 
            cachedFileNameForRepository: 'CVS01'
            module: 'stx' 
            directory: 'goodies/sunit'
            container: 'TestCase.st' 
            revision: '1234'
    "

    "Created: / 12-10-2011 / 09:51:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeCache class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/SourceCodeCache.st,v 1.4 2014-02-05 17:51:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/SourceCodeCache.st,v 1.4 2014-02-05 17:51:43 cg Exp $'
! !

