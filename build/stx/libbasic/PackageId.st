"
 COPYRIGHT (c) 2006 by eXept Software AG
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

Object subclass:#PackageId
	instanceVariableNames:'packageIdString'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Projects'
!

!PackageId class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    Represents packageID's.
    Knows the relationship between modules and directories in the package-organization.
"
! !

!PackageId class methodsFor:'instance creation'!

from: aStringOrSymbol
    ^ self new packageIdString:aStringOrSymbol

    "
     (self from:'stx:libbasic') module
     (self from:'stx:libbasic') directory
    "

    "Created: / 18-08-2006 / 12:11:58 / cg"
    "Modified: / 12-09-2006 / 15:27:42 / cg"
!

module:moduleString directory:directoryString
    ^ self new module:moduleString directory:directoryString

    "
     (PackageId module:'stx' directory:'libbasic') module
     (PackageId module:'stx' directory:'libbasic') directory
    "

    "Created: / 12-09-2006 / 15:26:24 / cg"
    "Modified: / 18-11-2006 / 17:09:12 / cg"
! !

!PackageId class methodsFor:'defaults'!

noProjectID
    "return the symbol used to tag classes and methods which are loose.
     This means: not yet assigned to a particular project."

    ^ #'__NoProject__'.
! !

!PackageId methodsFor:'accessing'!

directory
    "return the directory component. That's the rest after the colon.
     The module is typically used to define the project-path or project-id within its
     sourcecode repository (which is selected via the module)."

    |idx|

    idx := packageIdString indexOf:$:.
    idx == 0 ifTrue:[
        ^ ''.
    ].
    ^ packageIdString copyFrom:idx+1

    "
     (PackageId from:'stx:libbasic') module
     (PackageId from:'stx:libbasic') directory
     (PackageId from:'stx') module
     (PackageId from:'stx') directory
     (PackageId from:'stx:goodies/xml/stx') module
     (PackageId from:'stx:goodies/xml/stx') directory
    "

    "Created: / 18-08-2006 / 12:15:33 / cg"
    "Modified: / 28-11-2006 / 11:39:14 / cg"
    "Modified (comment): / 19-09-2011 / 11:01:08 / cg"
!

module
    "return the module component. That's the first component up to the colon.
     The module is typically used to select a corresponding sourcecode repository."

    |idx|

    idx := packageIdString indexOf:$:.
    idx == 0 ifTrue:[
        ^ packageIdString.
    ].
    ^ packageIdString copyTo:idx-1

    "
     (PackageId from:'stx:libbasic') module
     (PackageId from:'stx:libbasic') directory
    "

    "Created: / 18-08-2006 / 12:13:53 / cg"
    "Modified: / 27-12-2006 / 11:51:25 / cg"
    "Modified (comment): / 19-09-2011 / 11:01:15 / cg"
!

module:moduleString directory:directoryString
    |ds|

    (directoryString includes:$\) ifTrue:[
        ds := directoryString asFilename components asStringWith:$/.
    ] ifFalse:[
        ds := directoryString
    ].
    packageIdString := (moduleString,':',ds) asSymbol.

    "
     (self new module:'stx' directory:'libbasic') module
     (self new module:'stx' directory:'libbasic') directory
     (self new module:'stx' directory:'goodies/net') module
     (self new module:'stx' directory:'goodies/net') directory
     (self new module:'stx' directory:'goodies\net') module
     (self new module:'stx' directory:'goodies\net') directory
    "

    "Created: / 12-09-2006 / 15:26:48 / cg"
!

packageIdString:aString
    "the required format is:
        module:path
     where path is a unix-like path (i.e. containing slashes).
     However, for our convenience, also allow for
        module/path
     and even:
        module\ms-dos-path
     and convert them as required.
     This makes it easier on a doit, by copy-pasting port of a path into a loadPackage
     expression"

    |components|

    (aString notEmptyOrNil and:[(aString includes:$:) not]) ifTrue:[
        "/ assume its a path
        components := aString asFilename components.
        self module:components first directory:((components copyFrom:2) asStringWith:$/).
    ] ifFalse:[
        packageIdString := aString asSymbol.
    ]

    "
     'stx:libbasic' asPackageId module
     'stx:libbasic' asPackageId directory
     'stx/goodies/net' asPackageId module
     'stx/goodies/net' asPackageId directory
     'stx\goodies\net' asPackageId module
     'stx\goodies\net' asPackageId directory
    "

    "Created: / 18-08-2006 / 12:14:45 / cg"
!

string
    ^ packageIdString

    "Created: / 18-08-2006 / 12:20:54 / cg"
! !

!PackageId methodsFor:'comparing'!

= aPackageId
    "compares equal to a corresponding string"

    ^ packageIdString = aPackageId asPackageId string

    "
     'stx:libbasic' asPackageId = 'stx:libbasic'
     'stx:libbasic' asPackageId = 'stx:libbasic' asSymbol asPackageId
     'stx:libbasic' asPackageId = 'stx:libbasic' asPackageId
     'stx:libbasic2' asPackageId = 'stx:libbasic3' asPackageId
    "

    "Created: / 18-08-2006 / 12:20:47 / cg"
    "Modified: / 12-09-2006 / 15:33:00 / cg"
!

hash
    ^ packageIdString hash

    "Created: / 18-08-2006 / 12:21:19 / cg"
! !

!PackageId methodsFor:'converting'!

asPackageId
    ^ self

    "Created: / 18-08-2006 / 12:22:10 / cg"
!

asString
    ^ packageIdString asString

    "Created: / 18-08-2006 / 12:12:22 / cg"
!

asSymbol
    ^ packageIdString asSymbol

    "Created: / 18-08-2006 / 12:12:29 / cg"
! !

!PackageId methodsFor:'printing'!

printOn:aStream
    aStream
        nextPutAll:'PackageId('; nextPutAll:packageIdString; nextPutAll:')'

    "Created: / 12-10-2006 / 10:30:10 / cg"
! !

!PackageId methodsFor:'queries'!

isModuleId
    "true if this is a module-id only (i.e. no directory component present).
     These are not allowed to be used as real projects, but only for organization.
     The reason is that this is used as selector to select the sourceCodeManager and
     also the manager's repository"

    ^ self directory isEmptyOrNil
!

libraryName
    "return the name of the library, when compiled to a binary (i.e. dll/so).
     To avoid conflicts with the projectDefinition class
     (which is named <module>_<directory_components>), we prefix the library name
     with 'lib'. This has the added advantage, that under unix, linking can be done with
     '-l'shortName."

    ^ 'lib' , (ProjectDefinition projectDefinitionClassNameForDefinitionOf:packageIdString)

    "
     (PackageId from:'stx:libbasic') libraryName
     (PackageId from:'stx:goodies/xml/stx') libraryName
     (PackageId from:'bosch:dapasx') libraryName
     (PackageId from:'exept:expecco') libraryName
    "

    "Created: / 18-08-2006 / 12:35:04 / cg"
!

packageDirectory
    "return the pathName of the directory for this package in the file system"

    ^ Smalltalk getPackageDirectoryForPackage:packageIdString.

    "
     'stx:libbasic2' asPackageId packageDirectory
    "

    "Modified: / 28-06-2016 / 07:55:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parentPackage
    |dir idx|

    dir := self directory.
    dir isNil ifTrue:[
        ^ nil.
    ].
    idx := dir lastIndexOf:$/.
    idx == 0 ifTrue:[
        ^ nil
    ].
    ^ self class from:(self module , ':' , (dir copyTo:idx-1))

    "
     (PackageId from:'stx:libbasic') parentPackage
     (PackageId from:'stx:goodies/xml/stx') parentPackage
     (PackageId from:'stx:goodies/xml/stx') parentPackage parentPackage
     (PackageId from:'stx:goodies/xml/stx') parentPackage parentPackage parentPackage
    "

    "Created: / 23-08-2006 / 15:10:13 / cg"
!

pathRelativeToTopDirectory
    ^ (self module asFilename construct:(self directory)) name.

    "
     'stx:libbasic' asPackageId pathRelativeToTopDirectory
     'stx:goodies/net/ssl' asPackageId pathRelativeToTopDirectory
     'bosch:dapasx' asPackageId pathRelativeToTopDirectory
    "

    "Modified: / 25-07-2012 / 23:02:40 / cg"
!

pathRelativeToTopDirectory:aDirectory
    ^ aDirectory asFilename construct:(self pathRelativeToTopDirectory)

    "
     |top|

     top := Smalltalk packagePath first.
     'stx:goodies/net/ssl' asPackageId pathRelativeToTopDirectory:top
    "
!

projectDefinitionClass
    "return the project definition for this package.
     Eg. for 'stx:libbasic', this would return the stx_libbasic project definition class."

    ^ ProjectDefinition definitionClassForPackage:self

    "
     'stx:libbasic' asPackageId projectDefinitionClass
     'exept/expecco/foo' asPackageId projectDefinitionClass
     'exept/expecco/plugin/manualTest' asPackageId projectDefinitionClass
     'exept:expecco/plugin/manualTest' asPackageId projectDefinitionClass
     'exept_expecco_plugin_manualTest' asPackageId projectDefinitionClass
     'exept/expecco/plugin/edi-edifact' asPackageId projectDefinitionClass
    "
!

projectDefinitionClassName
    ^ ProjectDefinition projectDefinitionClassNameForDefinitionOf:self

    "
     'stx:libbasic' asPackageId projectDefinitionClassName
     'exept/expecco/foo' asPackageId projectDefinitionClassName
     'exept/expecco/plugin/manualTest' asPackageId projectDefinitionClassName
     'exept:expecco/plugin/manualTest' asPackageId projectDefinitionClassName
     'exept_expecco_plugin_manualTest' asPackageId projectDefinitionClassName
     'exept/expecco/plugin/edi-edifact' asPackageId projectDefinitionClassName
    "
!

projectDirectory
    <resource: #obsolete>
    "/ replace by:
    ^ self packageDirectory.

    "/ which works always.
    "/ the one below only works if a projDefClss is present...
"/    |pdClass|
"/
"/    (pdClass := self projectDefinitionClass) isNil ifTrue:[^ nil].
"/    ^ pdClass projectDirectory

    "
     'stx:libbasic2' asPackageId projectDirectory
    "

    "Created: / 21-09-2011 / 18:21:32 / cg"
! !

!PackageId class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

