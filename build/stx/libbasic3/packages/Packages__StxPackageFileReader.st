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

Object subclass:#StxPackageFileReader
	instanceVariableNames:'handler stream'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Handlers'
!

Object subclass:#Version1
	instanceVariableNames:'filename package'
	classVariableNames:''
	poolDictionaries:''
	privateIn:StxPackageFileReader
!

!StxPackageFileReader class methodsFor:'documentation'!

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

!StxPackageFileReader class methodsFor:'instance creation'!

forFilename:aFilename

    (self isFileVersion1:aFilename) ifTrue:[
        ^ Version1 forFilename:aFilename
    ].

    self error:'File type unknown'
!

forPackage:aPackage 

    ^ (self version:1) forPackage:aPackage 
!

version:aVersionNumber

    aVersionNumber == 1 ifTrue:[
        ^ Version1.
    ].
    self error:'Version unknown'
! !

!StxPackageFileReader class methodsFor:'queries'!

isFileBase:aFilename
    ^ false
!

isFileVersion1:aFilename
    ^ true
! !

!StxPackageFileReader::Version1 class methodsFor:'globals'!

smalltalkPackageManager
    ^ PackageManager smalltalkPackageManager
! !

!StxPackageFileReader::Version1 class methodsFor:'instance creation'!

forFilename:aPackage
    ^ self basicNew filename:aPackage
! !

!StxPackageFileReader::Version1 methodsFor:'accessing'!

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
! !

!StxPackageFileReader::Version1 methodsFor:'api'!

fileInFrom:aStream notifying:someone passChunk:passChunk single:single silent:beSilent 
    "sent by a file browser or something similar"
    | packageManager |

    packageManager := PackageManager smalltalkPackageManager.
    packageManager ifNil:[
        self error: 'Error during fileIn'.
        ^ self.
    ].

    package := (self getInitialPackageFromChunk:aStream nextChunk).
    package ifNil:[
        self error: 'Error during fileIn'.
        ^ self.
    ].

    self package:package.
    self 
        basicInstallPackage:package 
        fromStream:aStream 
        in:self class smalltalkPackageManager.

    packageManager addPackage:package.
!

installPackageIn:aPackageManager
    (self checkOkToInstall:package).   "/ may produce errors
    self basicInstallPackage:package in:aPackageManager.
    ^ package
!

loadPackageIn:aPackageManager 

    |aStream aPackage|
    self canReadFilename:filename.

    [
        aStream := filename readStream.
        aStream nextChunk.
        aStream nextChunk.
        aPackage := self getInitialPackageFromChunk:aStream nextChunk.
    ] ensure:[aStream close].

    self filename:filename.
    aPackageManager addPackage:aPackage.
    self package:aPackage.
    aPackage packageHandler:self.
    aPackage initializeLoaded.
    ^ aPackage
! !

!StxPackageFileReader::Version1 methodsFor:'checks'!

canReadFilename:aFilename

    aFilename isFilename ifFalse:[
        ^ self error:aFilename printString, ' is not a filename so cannot be written to.'.
    ].

    aFilename directory exists ifFalse:[
        ^ self error:aFilename directory printString, ' directory does not exist.'.
    ].

    aFilename exists ifFalse:[
        ^ self error:aFilename printString, ' file does not exist'.
    ].

    (aFilename isDirectory not) ifFalse:[
        ^ self error:aFilename printString, ' is a directory and cannot be read'.
    ].
!

checkOkToInstall:aPackage
    "check that aPackage is ok to install. Look for incompatibilities"

    self canReadFilename:filename
! !

!StxPackageFileReader::Version1 methodsFor:'helpers'!

applyChange:aChange fromPackage:aPackage 
    "apply change and make sure created objects are associated
    with package"

    | aMethod |
    aChange isMethodChange ifTrue:[
        aChange apply.
"/        aMethod := ChangesHelper getCurrentMethodFromMethodChange:aChange.
        aMethod := aChange changeMethod.
        aMethod ifNil:[
            self error:'Error during fileIn'.
            ^ self.
        ].

        aMethod setPackage:aPackage name.
        ^ self
    ].

    aChange apply
!

createPackagePath                                                    
    " create the path name for the filename if it does not already exist"
    ^ self createPathFor:package filename
!

createPathFor:aFilename
    " create the path name for the filename if it does not already exist"
    ^ aFilename directory makeDirectory.
!

openReadStreamStreamOn:aFilename andDo:aOneArgBlockWithAnExpectedStream
    | aStream |
    [
        aStream := aFilename readStream.
        aOneArgBlockWithAnExpectedStream value:aStream
    ] ensure:[
        aStream close
    ]

! !

!StxPackageFileReader::Version1 methodsFor:'installation / uninstallation'!

basicInstallPackage:aPackage fromStream:aStream in:aPackageManager
    "install a package"
    | changeSet |
    aPackage prerequisites evaluate.
    aPackage preInstallScript evaluate.

    changeSet := ChangeSet fromStream:aStream.  
    changeSet do:[:aChange |
        self applyChange:aChange fromPackage:aPackage.
    ].
    self validateInstallation. "/ may produce errors
    aPackage initializeInstalled.

"/    aPackage isInstalled:true. 
    aPackage postInstallScript evaluate.
!

basicInstallPackage:aPackage in:aPackageManager
    "install a package"
    
    self openReadStreamStreamOn:aPackage filename andDo:[:aStream |
        self skipPackageHeaderFrom:aStream.
"/        aStream nextChunk       
        self basicInstallPackage:aPackage fromStream:aStream  in:aPackageManager
    ].
!

skipPackageHeaderFrom:aReadStream 
    aReadStream nextChunk. "/ nothing
    aReadStream nextChunk. "/ script for creating the receiver
    aReadStream nextChunk. "/ the package header
! !

!StxPackageFileReader::Version1 methodsFor:'loading'!

loadFromStream:aStream 
    aStream nextChunk.
    aStream nextChunk.    "/ anEmpty string
    package := self getInitialPackageFromChunk:aStream nextChunk.    "/ the receiver representation
    package filename:filename.
    ^ package
! !

!StxPackageFileReader::Version1 methodsFor:'stream messages'!

getChangeSetFrom:aStream 
    ^ ChangeSet fromStream:aStream
!

getInitialPackageFrom:aStream 
    |nextChunk|

    nextChunk := aStream nextChunk.
    Class nameSpaceQuerySignal 
            answer:Packages
            do:[
        ^ (Compiler evaluate:nextChunk)
    ]
!

getInitialPackageFromChangeSet:aChangeSet 
    |nextChunk|

    nextChunk := aChangeSet first source.
    Class nameSpaceQuerySignal 
            answer:Packages
            do:[
        ^ (Compiler evaluate:nextChunk)
    ]
!

getInitialPackageFromChunk:aChunk 

    Class nameSpaceQuerySignal 
            answer:Packages
            do:[
        ^ (Compiler evaluate:aChunk)
    ]
! !

!StxPackageFileReader::Version1 methodsFor:'validation'!

validateAllClassesAreInImage

    #toDo
!

validateAllMethodsAreInImage
    #toDo
!

validateInstallation
    self validateAllClassesAreInImage.
    self validateAllMethodsAreInImage.
! !

!StxPackageFileReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/StxPackageFileReader.st,v 1.2 2006/01/10 09:32:03 cg Exp $'
! !