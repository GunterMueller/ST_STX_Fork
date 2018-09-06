"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

AbstractSourceFileWriter subclass:#GroovySourceFileWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Groovy-Support'
!

!GroovySourceFileWriter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!GroovySourceFileWriter methodsFor:'source writing'!

fileOut:class on:stream withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter encoder:encoderOrNil
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

fileOutMethods:methods on:stream
    "superclass AbstractSourceFileWriter says that I am responsible to implement this method"

    ^ self shouldImplement
!

fileOutPackageDefinition:packageId on:stream
    "Files out a package definition on the stream, so all subsequent
     code entities will be placed in that package"

    ^ self shouldImplement
! !

!GroovySourceFileWriter methodsFor:'source writing - comments'!

fileOutCommentEndOn:aStream
    "Writes a comment end mark on aStream."

    "Modified: / 18-02-2012 / 18:35:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutCommentLine:aString on:aStream
    "superclass AbstractSourceFileWriter says that I am responsible to implement this method"

    ^ aStream nextPutAll:'// '; nextPutAll: aString

    "Modified: / 18-02-2012 / 18:35:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutCommentStartOn:aStream
    "Writes a comment start mark on aStream."

    "Modified: / 18-02-2012 / 18:35:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovySourceFileWriter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/GroovySourceFileWriter.st,v 1.5 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

