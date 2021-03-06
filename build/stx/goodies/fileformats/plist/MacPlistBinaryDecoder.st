"
 COPYRIGHT (c) 2015 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/fileformats/plist' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MacPlistBinaryDecoder
	instanceVariableNames:'inputStream'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-FileFormats'
!

!MacPlistBinaryDecoder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015 by Claus Gittinger
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
    A common binary file format representation on Mac OSX.
    On OSX, this is used to store user preferences, settings and application histories.
    It is also used to provide additional attributes for applications 
    (such as type of document, icons etc.)

    Notice, that OSX is moving towards a new plist format, which is XML based.
    This decoder reads the old binary format. New applications should use the new format,
    and only use this decoder to convert/read old plist files.
    Actually, because I am lazy, this decoder uses a command line utility to first convert from binary
    to xml plist format. Thus, it will only work on OS-X.

    [author:]
        Claus Gittinger

    [see also:]
        MacPlistXMLDecoder MacPlistXMLCoder

    [instance variables:]

    [class variables:]
"
!

examples
"
   restore:
                                                                [exBegin]
     |inFile decodedObject|

     inFile := '/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/German.lproj/InfoPlist.strings'.
     inFile := '/Applications/TextEdit.app/Contents/Resources/German.lproj/Localizable.strings'.
     
     decodedObject := (MacPlistBinaryDecoder on:inFile asFilename binaryContentsOfEntireFile) decodedObject.
     decodedObject inspect.
                                                                [exEnd]
    on my system, this is definitely a binary file:
                                                                [exBegin]
     |inFile decodedObject|

     inFile := '/Library/Preferences/com.apple.Bluetooth.plist' asFilename readStream.
     decodedObject := (MacPlistBinaryDecoder on:inFile asFilename binaryContentsOfEntireFile) decodedObject.
     decodedObject inspect.
                                                                [exEnd]

"
! !

!MacPlistBinaryDecoder class methodsFor:'instance creation'!

on:aByteArrayOrReadStream
    Smalltalk requirePackage:'stx:goodies/xml/stx'.
    
    ^ self new on:aByteArrayOrReadStream readStream
! !

!MacPlistBinaryDecoder methodsFor:'decoding'!

decodedObject
    "use plutil to convert to XML, then read that"

    |tmpFile tmpXMLFile decoder object|

    tmpFile := Filename newTemporary.
    [
        tmpFile contents:inputStream upToEnd.
        (OperatingSystem isOSXlike and:[OperatingSystem canExecuteCommand:'plutil']) ifTrue:[
            "/ use the plutil command to convert from binary to XML,
            "/ then read the XML file    
            tmpXMLFile := Filename newTemporary.
            OperatingSystem executeCommand:('plutil -convert xml1 -o %2 %1' bindWith:tmpFile pathName with:tmpXMLFile pathName).
            tmpXMLFile readingFileDo:[:s |            
                "/ to avoid package dependency from libbasic2 to goodies/xml
                "/ see package loading on instance-side
                decoder := (Smalltalk at:#MacPlistXMLDecoder) on:s.
                object := decoder decodedObject.
            ].    
        ] ifFalse:[
            "/ use the 100% Smalltalk binary plist reader 
            "/ (which may or may not work 100%, as it is written after reverse engineering the file structure)
            object := MacBinaryPListFileReader readFrom:(tmpFile readStream).
        ].        
    ] ensure:[
        tmpFile remove.
        tmpXMLFile notNil ifTrue:[tmpXMLFile remove].
    ].    
    ^ object.

    "Modified: / 22-02-2017 / 11:17:31 / cg"
! !

!MacPlistBinaryDecoder methodsFor:'initialization'!

on:aStream
    inputStream := aStream
! !

!MacPlistBinaryDecoder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/fileformats/plist/MacPlistBinaryDecoder.st,v 1.1 2018-05-03 23:27:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/fileformats/plist/MacPlistBinaryDecoder.st,v 1.1 2018-05-03 23:27:21 cg Exp $'
! !

