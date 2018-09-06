"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

PackageHandler subclass:#StxPackageFileHandler
	instanceVariableNames:'package filename'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Handlers'
!

!StxPackageFileHandler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!StxPackageFileHandler class methodsFor:'instance creation'!

forFilename:aFilename

    (self isFileBase:aFilename) ifTrue:[
        ^ StxBasePackageHandler forFilename:aFilename
    ].
    (self isFileVersion1:aFilename) ifTrue:[
        ^ Version1 forFilename:aFilename
    ].

    self error:'File type unknown'
!

forPackage:aPackage 
    ^ self basicNew package:aPackage
!

openStxPackageFormat:aFormat
    ^ ((StxPackageFileReader) version:aFormat) new
!

version:aVersionNumber
    aVersionNumber == 0 ifTrue:[
        ^ StxBasePackageHandler.
    ].

    aVersionNumber == 1 ifTrue:[
        ^ Version1.
    ].
    self error:'Version unknown'
! !

!StxPackageFileHandler class methodsFor:'accessing-globals'!

packageManager
    ^ PackageManager smalltalkPackageManager
! !

!StxPackageFileHandler class methodsFor:'queries'!

isFileBase:aFilename
    ^ false
!

isFileVersion1:aFilename
    ^ true
! !

!StxPackageFileHandler methodsFor:'accessing'!

filename
    "return the value of the instance variable 'filename' (automatically generated)"

    ^ filename
!

filename:something
    "set the value of the instance variable 'filename' (automatically generated)"

    filename := something.
!

package
    "return the value of the instance variable 'package' (automatically generated)"

    ^ package
!

package:something
    "set the value of the instance variable 'package' (automatically generated)"

    package := something.
!

version
    ^ 1
! !

!StxPackageFileHandler methodsFor:'api'!

fileInFrom:arg1 notifying:arg2 passChunk:arg3 single:arg4 silent:arg5 
!

installPackageIn:aPackageManager 
    ^ (self newPackageReader) installPackageIn:aPackageManager 
!

loadPackageIn:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

savePackageAs:arg 

    ^ (self newPackageWriter) savePackageAs:arg 

!

savePackageOn:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

uninstallPackageFrom:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

unloadPackageIn:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!StxPackageFileHandler methodsFor:'checks'!

canReadFilename:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

checkOkToInstall:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

checkOkToUninstall:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!StxPackageFileHandler methodsFor:'factory'!

newPackageReader
    ^ (self packageReaderClass version:self version) new 
            filename:filename;
            package:package.
!

newPackageWriter
    ^ (self packageWriterClass version:self version) new 
            package:package.




!

packageReaderClass
    ^ StxPackageFileReader
!

packageWriterClass
    ^ StxPackageFileWriter
! !

!StxPackageFileHandler class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/StxPackageFileHandler.st,v 1.2 2006-01-10 09:32:05 cg Exp $'
! !
