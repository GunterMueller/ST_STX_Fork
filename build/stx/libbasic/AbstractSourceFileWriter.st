"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009-2010 Jan Vrany
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

Object subclass:#AbstractSourceFileWriter
	instanceVariableNames:'generatingSourceForOriginal'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

Query subclass:#MethodSourceRewriteQuery
	instanceVariableNames:'method source'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractSourceFileWriter
!

!AbstractSourceFileWriter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009-2010 Jan Vrany
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
    Abstract common superclass for source file writers
"
! !

!AbstractSourceFileWriter class methodsFor:'queries'!

isAbstract
    ^ self == AbstractSourceFileWriter
! !

!AbstractSourceFileWriter class methodsFor:'signal constants'!

methodSourceRewriteQuery
    "hook to allow for just-in-time rewriting of a method's sourceCode while filing out
    used when saving version_XXX methods in a non-XXX sourceCodeManager
    (i.e. to rewrite all non-CVS version methods while saving into a CVS repository)
    this is required because we cannot save an SVN version method (dollar-ID-...-dollar) into a
    CVS repository without loosing the original string with the next checkout, because it also gets  
    expanded by CVS. The same is true vice-versa for CVS-Ids, which get clobbered by SVN.

    see SmalltalkChunkFileSourceWriter fileOutMethod:on:"

    ^ MethodSourceRewriteQuery
! !

!AbstractSourceFileWriter methodsFor:'accessing'!

generatingSourceForOriginal:aBoolean
    "if false (the default), the source of the current (in image) code is generated.
     That means, that any extension method which shadows some other original method,
     that extension method's code is generated.
     if true, the code of the original method is generated.
     Use a true value, when generating code for a SCM checkin operation, as then we do not
     want the extension to shadow the original"

    generatingSourceForOriginal := aBoolean.
! !

!AbstractSourceFileWriter methodsFor:'fileout'!

fileOut:aClass on:outStreamArg 

    self 
        fileOut:aClass on:outStreamArg 
        withTimeStamp:true withInitialize:true 
        withDefinition:true 
        methodFilter:nil encoder:nil

    "Created: / 15-08-2009 / 13:11:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!AbstractSourceFileWriter methodsFor:'source writing'!

fileOut: class on:stream withTimeStamp: stampIt withInitialize: initIt withDefinition: withDefinition methodFilter:methodFilter

    ^ self 
        fileOut: class 
        on:stream 
        withTimeStamp: stampIt 
        withInitialize: initIt 
        withDefinition: withDefinition 
        methodFilter:methodFilter 
        encoder:nil

    "Created: / 04-10-2014 / 12:10:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOut: class on:stream withTimeStamp: stampIt withInitialize: initIt withDefinition: withDefinition methodFilter:methodFilter encoder:encoderOrNil
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "Modified: / 16-08-2009 / 09:59:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

fileOutMethods: methods on:stream

    "Files out a bunch of methods. This is used to file-out extension methods"    

    self subclassResponsibility

    "Modified: / 16-08-2009 / 09:59:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 30-12-2009 / 18:34:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutPackageDefinition:packageId on:stream 
    "Files out a package definition on the stream, so all subsequent
     code entities will be placed in that package"
    
    self subclassResponsibility

    "Modified: / 16-08-2009 / 09:59:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 30-12-2009 / 18:34:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSourceFileWriter methodsFor:'source writing - comments'!

fileOutComment: aStringOrStringCollection on: aStream
    "Writes a comment to a stream using proper syntax"

    self fileOutCommentStartOn: aStream.
    aStringOrStringCollection isStringCollection
        ifTrue:[
            aStringOrStringCollection 
                do:[:line|self fileOutCommentLine: line on: aStream]
                separatedBy: [aStream cr]]
        ifFalse:[
            (aStringOrStringCollection includes: Character cr)
                ifTrue:"/hmm...multiline comment as string
                    [aStringOrStringCollection asStringCollection
                        do:[:line|self fileOutCommentLine: line on: aStream]
                        separatedBy: [aStream cr]]
                ifFalse:
                    [self fileOutCommentLine: aStringOrStringCollection on: aStream]].
    self fileOutCommentEndOn: aStream.

    "Created: / 21-08-2009 / 09:36:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

fileOutCommentEndOn: aStream
    "
        Writes a comment end mark on aStream.
    "

    ^self subclassResponsibility

    "Created: / 21-08-2009 / 09:40:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

fileOutCommentLine: aString on: aStream

    "
        Writes a single line of comment on a comment to a stream.
        Should not put an cr to the stream!!
    "

    ^self subclassResponsibility

    "Created: / 21-08-2009 / 09:42:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

fileOutCommentStartOn: aStream
    "
        Writes a comment start mark on aStream.
    "

    ^self subclassResponsibility

    "Created: / 21-08-2009 / 09:40:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!AbstractSourceFileWriter::MethodSourceRewriteQuery class methodsFor:'documentation'!

documentation
"
    hook to allow for just-in-time rewriting of a method's sourceCode while filing out
    used when saving version_XXX methods in a non-XXX sourceCodeManager
    (i.e. to rewrite all non-CVS version methods while saving into a CVS repository)
    this is required because we cannot save an SVN version method (dollar-ID-...-dollar) into a
    CVS repository without loosing the original string with the next checkout, because it also gets  
    expanded by CVS. The same is true vice-versa for CVS-Ids, which get clobbered by SVN.

    see SmalltalkChunkFileSourceWriter fileOutMethod:on:
"
! !

!AbstractSourceFileWriter::MethodSourceRewriteQuery methodsFor:'accessing'!

method
    ^ method
!

method:methodArg source:sourceArg 
    method := methodArg.
    source := sourceArg.
!

source
    ^ source
! !

!AbstractSourceFileWriter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id: AbstractSourceFileWriter.st 10643 2011-06-08 21:53:07Z vranyj1  $'
! !

