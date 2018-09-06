"
 COPYRIGHT (c) 1997 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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

Filename subclass:#UnixFilename
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Unix'
!

!UnixFilename class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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
    Filenames in Unix.
"

!

examples
    "
        (self named:'/tmp/') writeStream close
    "
! !

!UnixFilename class methodsFor:'defaults'!

defaultTempDirectoryName
    "return the default temp directory as a filename."

    |tempDirString tempDir|

    #('STX_TMPDIR' 'ST_TMPDIR' 'TMPDIR' 'TEMPDIR' 'TEMP' 'TMP') do:[:envVar |
        tempDirString := OperatingSystem getEnvironment:envVar.
        tempDirString notNil ifTrue:[
            tempDir := self named:tempDirString.    
            (tempDir exists and:[ tempDir isWritable ]) ifTrue:[
                Logger info: 'using tmp folder "%1" as specified by environment: "%2"' with:tempDir pathName with:envVar.
                ^ tempDir asFilename.
            ].
        ].
    ].

    tempDir := '/tmp' asFilename.
    ('Filename [info]: using default unix tmp folder: ',tempDir pathName) infoPrintCR.
    ^ tempDir    

    "
     Filename defaultTempDirectoryName
     Filename defaultTempDirectoryName exists
     Filename defaultTempDirectoryName isWritable
    "

    "Modified: / 27-10-2016 / 23:09:08 / jv"
! !

!UnixFilename class methodsFor:'queries'!

isBadCharacter:aCharacter
    "return true, if aCharacter is unallowed in a filename."

    aCharacter == $/ ifTrue:[^ true].
    ^ super isBadCharacter:aCharacter

    "Created: 8.9.1997 / 00:13:14 / cg"
!

isCaseSensitive
    "return true, if filenames are case sensitive.
     This is not really correct, as the sensitivity may depend on
     the paricular mounted file system (NFS, for example)"

    ^ OperatingSystem caseSensitiveFilenames
!

nullFilename
    "Return /dev/null"

    ^ '/dev/null'

    "
     Filename nullFilename  
    "

    "Modified: / 14.1.1998 / 14:20:55 / stefan"
!

parentDirectoryName
    "return the name used for the parent directory.
     This is '..' for unix and dos-like systems.
     (there may be more in the future."

    ^ '..'
!

separator
    "return the file/directory separator."

     ^ $/

     "
      Filename concreteClass separator  
     "

    "Created: 8.9.1997 / 00:18:14 / cg"
!

separatorString
    "return the file/directory separator as a string."

    ^ '/'

    "
     Filename separatorString  
    "
! !

!UnixFilename methodsFor:'file queries'!

fileType
    "this returns a string describing the type of contents of the file. 
     This is done using the unix 'file' command,
     (which usually is configurable by /etc/magic).
     Warning:
         Since the returned string differs among systems (and language settings),
         it is only useful for user-information; 
         NOT as a tag to be used by a program.
         For this, use mimeType or mimeTypeOfContents."

    |typeString|

    "/ since executing 'file' takes some time, the most common
    "/ ones are checked first, using the general fileType implementation. 
    "/ (also, the file-command is only available on Unix systems,
    "/ so this provides a reasonable fallback).

    typeString := super fileType.
    typeString ~= 'file' ifTrue:[^ typeString].

    typeString := PipeStream outputFromCommand:('file "' , self pathName , '"').
    typeString notNil ifTrue:[
        typeString := typeString copyFrom:(typeString indexOf:$:) + 1.
        typeString := typeString withoutSeparators
    ].
    ^ typeString

    "
     'Makefile' asFilename fileType 
     '.' asFilename fileType     
     '/dev/null' asFilename fileType        
     'smalltalk.rc' asFilename fileType    
     'bitmaps/SBrowser.xbm' asFilename fileType    
     '../../libtool/bitmaps/SBrowser.xbm' asFilename fileType    
     './stx' asFilename fileType    
    "

    "Modified: / 21.7.1998 / 11:26:32 / cg"
! !

!UnixFilename methodsFor:'queries'!

isExplicitRelative
    "return true, if this name is an explicit relative name
     (i.e. starts with './' or '../', to avoid path-prepending)"

    (nameString startsWith:'./') ifTrue:[
	^ true
    ].
    (nameString startsWith:'../') ifTrue:[
	^ true
    ].
    ^ false
!

isHidden
    "return true, if the receiver represents a hidden file.
     On UNIX, a name starting with a period is considered hidden."

    |baseName|

    baseName := self baseName.
    ^ ((baseName startsWith:'.') and:[baseName ~= '..'])
!

isImplicit
    "return true, if the receiver represents builtin names such as '.' or '..'.
     On UNIX, the current and parent dir names are considered implicit."

    |name|

    name := self baseName.
    ^ name = '.' or:[name = '..'].

    "Modified: / 18.9.1997 / 18:03:28 / stefan"
    "Modified: / 21.7.1998 / 11:10:42 / cg"
! !

!UnixFilename methodsFor:'special accessing'!

osName
    "redefined from superclass, because we do not distinguish file and directory names"

    ^ self osNameForFile
! !

!UnixFilename class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

