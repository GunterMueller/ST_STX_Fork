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

Object subclass:#StxPackageFileWriter
	instanceVariableNames:'handler stream'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Handlers'
!

Object subclass:#Version1
	instanceVariableNames:'package'
	classVariableNames:''
	poolDictionaries:''
	privateIn:StxPackageFileWriter
!

!StxPackageFileWriter class methodsFor:'documentation'!

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

!StxPackageFileWriter class methodsFor:'instance creation'!

forPackage:aPackage 

    ^ (self version:1) forPackage:aPackage 
!

version:aVersionNumber

    aVersionNumber == 1 ifTrue:[
        ^ Version1.
    ].
    self error:'Version unknown'
! !

!StxPackageFileWriter::Version1 class methodsFor:'instance creation'!

forPackage:aPackage
    ^ self basicNew package:aPackage
! !

!StxPackageFileWriter::Version1 methodsFor:'accessing'!

fileOutVersion
    ^ 1
!

package
    "return the value of the instance variable 'package' (automatically generated)"

    ^ package
!

package:something
    "set the value of the instance variable 'package' (automatically generated)"

    package := something.
! !

!StxPackageFileWriter::Version1 methodsFor:'api'!

savePackageAs:aFilename
    | writeStream |
    self createPathFor:aFilename.
    [ 
        self canWriteTo:aFilename. "may return exceptions"
        writeStream := aFilename writeStream.
        self savePackageOn:writeStream.   "may return exceptions"
    ] ensure:[
        writeStream close.
    ].

    package markClean.
    ^ package
!

savePackageOn:aWriteStream
    self forPackage:package saveInstallationScriptChunkOn:aWriteStream.
    self forPackage:package saveClassDefinitionsOn:aWriteStream.
    self forPackage:package saveLooseMethodsOn:aWriteStream.
! !

!StxPackageFileWriter::Version1 methodsFor:'fileOut - chunks'!

forPackage:aPackage saveClassDefinitionsOn:aWriteStream 

    aPackage classNames size > 0 ifTrue:[
        aWriteStream nextPutAll:'"Class Definitions"!!'.
        aWriteStream cr.
        aPackage classesDo:[:aClass |
            aClass nameSpace isNameSpace ifTrue:[
                self fileOutClass:aClass on:aWriteStream.
            ] ifFalse:[| ownerClass |
                "aClass is a privateClass"
                ownerClass := aClass nameSpace.    
                ownerClass package == aPackage name ifFalse:[
                ]. "ifTrue:[
                    Do nothing - the class has already been filed out by its ownerClass!!
                ]."
            ]
        ].
        aWriteStream cr.
        aWriteStream nextPutAll:'"End of Class Definitions"!!'.
        aWriteStream cr.
    ].
!

forPackage:aPackage saveInstallationScriptChunkOn:aWriteStream
    "create an installation script which is used to create
     an initial package which can help determine if the package
     is loadable"
    self forPackage:aPackage savePackageFormatOn:aWriteStream.
    self forPackage:aPackage savePackageInstanceCreationOn:aWriteStream.
    self forPackage:aPackage savePackageFileVersionOn:aWriteStream.
    self forPackage:aPackage savePackageCommentOn:aWriteStream.
    self forPackage:aPackage saveClassNamesOn:aWriteStream.
    self forPackage:aPackage saveLooseMethodNamesOn:aWriteStream.
    self forPackage:aPackage saveScriptsOn:aWriteStream.
    self forPackage:aPackage savePrerequisitesOn:aWriteStream.
    self forPackage:aPackage saveEndingOn:aWriteStream.
!

forPackage:aPackage saveLooseMethodsOn:aWriteStream 
    aPackage looseMethods size > 0 ifTrue:[
        aWriteStream nextPutAll:'"LooseMethods"!!'.
        aWriteStream cr.
        aPackage looseMethods do:[:aLooseMethod |
            self fileOutLooseMethod:aLooseMethod on:aWriteStream
        ].
        aWriteStream nextPutAll:'!!'.
        aWriteStream cr.

        aWriteStream nextPutAll:'"End of LooseMethods"!!'.
    ].
! !

!StxPackageFileWriter::Version1 methodsFor:'fileOut - subparts'!

fileOutClass:aClass on:aWriteStream

    "ClassDescription fileOutErrorSignal can occur here from autoloaded classes"
    aClass isLoaded ifFalse:[
        aClass autoload
    ].

    package blockedMethods isEmpty ifFalse:[
        Transcript 
                nextPutAll:'Finnish me!!'; 
                cr;
                nextPutAll:'''blockedMethods '' are not accounted for at the moment!!'' in:'; 
                cr;
                nextPutAll:'Packages::StxPackageFileWriter::Version1>>fileOutClass:on:'  ; 
                cr
        
    ].
    aClass fileOutOn:aWriteStream
!

fileOutLooseMethod:aMethod on:aWriteStream 

    aWriteStream nextPut:$!!.
    aWriteStream nextPutAll:aMethod mclass asString.
    aWriteStream nextPutAll:' methodsFor:'.
    aWriteStream nextPut:$'.
    aWriteStream nextPutAll:(aMethod category).
    aWriteStream nextPut:$'.
    aWriteStream nextPut:$!!.
    aWriteStream cr.

    aWriteStream nextPutAll:aMethod source.
    aWriteStream nextPut:$!!.
    aWriteStream cr.
!

forPackage:aPackage saveClassNamesOn:aWriteStream

    aPackage classNames size > 0 ifTrue:[

        aWriteStream 
            nextPutAll:'"ClassNames"';
            cr.

        aWriteStream 
            nextPutAll:'aPackage ';
            cr.

        aPackage classNames do:[:aClassname |
            aWriteStream 
                nextPutAll:'    addClassNamed:#', aClassname, ';';
                cr.
        ].

        aWriteStream nextPutAll:'    yourself.'; "pointless but makes this code more readable"    
        cr.

        aWriteStream 
            nextPutAll:'"End of ClassNames"';
            cr;
            cr.

    ].
!

forPackage:aPackage saveEndingOn:aWriteStream
    aWriteStream 
        nextPutAll:'aPackage!!';
        cr;
        cr.
!

forPackage:aPackage saveLooseMethodNamesOn:aWriteStream

    aPackage looseMethods size > 0 ifTrue:[

        aWriteStream 
            nextPutAll:'"LooseMethodNames"';
            cr.

        aWriteStream 
            nextPutAll:'aPackage ';
            cr.

        aPackage looseMethods do:[:aMethod |
            aWriteStream 
                nextPutAll:'    addMethodNamed:#', aMethod name asString, ' forClassNamed:#', aMethod ownedClassName asString, ';';
                cr.
        ].

        aWriteStream nextPutAll:'    yourself.'. "pointless but makes this code more readable"    
        aWriteStream 
            cr;
            nextPutAll:'"End of LooseMethodNames"';
            cr;
            cr.
    ].
!

forPackage:aPackage savePackageCommentOn:aWriteStream 
    aWriteStream
        nextPutAll:'aPackage packageComment:';
        nextPutAll:aPackage packageComment ? '''''';
        nextPut:$.;
        cr;
        cr.
!

forPackage:aPackage savePackageFileVersionOn:aWriteStream 

    aWriteStream 
        nextPutAll:'aPackage packageVersion:';
        nextPutAll:self fileOutVersion printString;
        nextPut:$.;
        cr.
!

forPackage:aPackage savePackageFormatOn:aWriteStream 
    aWriteStream nextPutAll:'!!Packages::PackageHandler openStxPackageFormat:1!!';
    cr
!

forPackage:aPackage savePackageInstanceCreationOn:aWriteStream 
    aWriteStream 
        nextPutAll:'|aPackage|';
        cr;
        nextPutAll:'aPackage := Package named: ';
        nextPut:$';
        nextPutAll:aPackage name;
        nextPut:$';
        nextPut:$.;
        cr.
!

forPackage:aPackage savePrerequisitesOn:aWriteStream

    aPackage prerequisites size > 0 ifTrue:[
        aWriteStream
            nextPutAll:'"Prerequisites"';
            cr.

        self forPackage:aPackage savePrerequisteClassesOn:aWriteStream.
        self forPackage:aPackage  savePrerequistePackagesOn:aWriteStream.
        aWriteStream
            nextPutAll:'"End of Prerequisites"';
            cr;
            cr.
        
    ]

!

forPackage:aPackage savePrerequisteClassesOn:aWriteStream

    aPackage classPrerequisites size > 0 ifTrue:[

        aPackage classPrerequisites do:[:prerequisite |

            aWriteStream
                nextPutAll:'aPackage' ;
                cr;
                nextPutAll:'   addClassNamePrerequisite:#', prerequisite name;
                cr;
                nextPutAll:'   ifFailString:';
                nextPut:$';
                nextPutAll:prerequisite ifFailedString;
                nextPut:$';
                nextPut:$;;
                cr.
        ].

        aWriteStream nextPutAll:'   yourself.'; "pointless but makes this code more readable"    
        cr.


    ].
!

forPackage:aPackage savePrerequistePackagesOn:aWriteStream

    aPackage packagePrerequisites size > 0 ifTrue:[

        aPackage packagePrerequisites do:[:prerequisite |

            aWriteStream
                nextPutAll:'aPackage' ;
                cr;
                nextPutAll:'   addPackageNamePrerequisite:#', prerequisite name;
                cr;
                nextPutAll:'   ifFailString:';
                nextPut:$';
                nextPutAll:prerequisite ifFailedString;
                nextPut:$';
                nextPut:$;;
                cr.
        ].

        aWriteStream nextPutAll:'   yourself.'; "pointless but makes this code more readable"    
        cr.
    ]
!

forPackage:aPackage saveScriptsOn:aWriteStream 

    aPackage scripts size > 0 ifTrue:[ | aScript |

        aWriteStream 
            nextPutAll:'"Scripts"';
            cr.
        (aScript := aPackage postInstallScript) getString size == 0 ifFalse:[
            aWriteStream
                nextPutAll:'aPackage postInstallScriptString:';
                nextPut:$';
                nextPutAll:aScript getString;
                nextPut:$';
                nextPut:$.;
                cr.
        ].

        (aScript := aPackage preInstallScript) getString size == 0 ifFalse:[
            aWriteStream
                nextPutAll:'aPackage preInstallScriptString:';
                nextPut:$';
                nextPutAll:aScript getString;
                nextPut:$';
                nextPut:$.;
                cr.
        ].

        (aScript := aPackage postUninstallScript) getString size == 0 ifFalse:[
            aWriteStream
                nextPutAll:'aPackage postUninstallScriptString:';
                nextPut:$';
                nextPutAll:aScript getString;
                nextPut:$';
                nextPut:$.;
                cr.
        ].

        (aScript := aPackage postUninstallScript) getString size == 0 ifFalse:[
            aWriteStream
                nextPutAll:'aPackage preUninstallScriptString:';
                nextPut:$';
                nextPutAll:aScript getString;
                nextPut:$';
                nextPut:$.;
                cr.
        ].
        aWriteStream
            cr;
            cr.


    ].
! !

!StxPackageFileWriter::Version1 methodsFor:'helpers'!

createPathFor:aFilename
    " create the path name for the filename if it does not already exist"
    ^ aFilename directory makeDirectory.
! !

!StxPackageFileWriter::Version1 methodsFor:'instance creation'!

forPackage:aPackage
    ^ self basicNew package:aPackage
! !

!StxPackageFileWriter::Version1 methodsFor:'queries'!

canWriteTo:aFilename
    "return an error if the reciever cannot write to aFilename"

    aFilename isFilename ifFalse:[
        ^ self error:aFilename printString, ' is not a filename so cannot be written to.'.
    ].

    aFilename directory exists ifFalse:[
        ^ self error:aFilename directory printString, ' directory does not exist.'.
    ].

    aFilename directory canBeWritten ifFalse:[
        ^ self error:aFilename printString, ' cannot be written to.'.
    ].

    (aFilename isDirectory not) ifFalse:[
        ^ self error:aFilename printString, ' is a directory and cannot be written to'.
    ].
! !

!StxPackageFileWriter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/StxPackageFileWriter.st,v 1.5 2006/01/10 09:31:44 cg Exp $'
! !