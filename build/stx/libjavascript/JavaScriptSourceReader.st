"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

Object subclass:#JavaScriptSourceReader
	instanceVariableNames:'classBeingLoaded'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Framework'
!

!JavaScriptSourceReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaScriptSourceReader class methodsFor:'fileIn'!

fileIn:aFilename
    ^ self new fileIn:aFilename
!

fileInStream:aStream
    ^ self new fileInStream:aStream
! !

!JavaScriptSourceReader methodsFor:'fileIn'!

fileIn:aFilename
    aFilename asFilename readingFileDo:[:s |
        self fileInStream:s.
    ].
!

fileInStream:aStream
    Parser undefinedVariableNotification ignoreIn:[
        ClassBuildWarning ignoreIn:[
            JavaScriptCompiler parseClassFile:aStream.
        ].
    ].
! !

!JavaScriptSourceReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptSourceReader.st,v 1.5 2014-05-15 10:35:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptSourceReader.st,v 1.5 2014-05-15 10:35:38 cg Exp $'
! !

