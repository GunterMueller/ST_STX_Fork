"
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#BeeProjectWriter
	instanceVariableNames:'name version author timestamp description classesToBeInitialized'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!BeeProjectWriter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!BeeProjectWriter class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)


! !

!BeeProjectWriter class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!BeeProjectWriter class methodsFor:'private'!

basenameForPackage:pkg
    |  pkgdef |

    pkgdef := ProjectDefinition definitionClassForPackage: pkg.
    ^ pkgdef name.

    "Created: / 03-11-2015 / 07:15:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BeeProjectWriter class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == BeeProjectWriter.
! !

!BeeProjectWriter class methodsFor:'simple API'!

fileOut: pkg in: directory
    "File out Bee package (definition - .prj and source - .stp) in
     given directory."

    | basename prjFilename stpFilename |

    basename := self basenameForPackage: pkg.
    prjFilename := directory asFilename / (basename , '.prj').
    stpFilename := directory asFilename  / (basename , '.stp').

    BeeProjectDefinitionWriter fileOut: pkg to: prjFilename.
    BeeProjectSourceWriter fileOut: pkg to: stpFilename.

    "Created: / 03-11-2015 / 07:14:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOut:packageId on:stream
    self new fileOut:packageId on:stream

    "Modified: / 14-04-2015 / 13:52:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOut:packageId to: stringOrFilename
    stringOrFilename asFilename writingFileDo:[ :stream |
        self fileOut: packageId on: stream
    ].

    "Created: / 24-10-2015 / 08:49:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BeeProjectWriter methodsFor:'accessing'!

author
    ^ author
!

author:something
    author := something.
!

description
    ^ description
!

description:something
    description := something.
!

name
    ^ name
!

name:something
    name := something.
!

timestamp
    ^ timestamp
!

timestamp:something
    timestamp := something.
!

version
    ^ version
!

version:something
    version := something.
! !

!BeeProjectWriter methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ name := nil.
    author := OperatingSystem getFullUserName.
    version := timestamp := Timestamp now.
    description := 'Not yet described'.
    classesToBeInitialized := Dictionary new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 07-09-2016 / 14:39:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BeeProjectWriter methodsFor:'private'!

mappings
    | mappings |

    mappings := Dictionary new.
    mappings at: 'NAME' put: name.
    mappings at: 'VERSION' put: version.
    mappings at: 'AUTHOR' put: author .
    mappings at: 'TIMESTAMP' put: timestamp asDate asString, ' ', timestamp asTime asString.
    mappings at: 'DESCRIPTION' put: description.
    ^ mappings

    "Created: / 02-11-2015 / 16:59:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2016 / 14:21:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BeeProjectWriter methodsFor:'source writing'!

fileOut:packageID on:aStream
    | projectDefinitionClass revinfo classesToFileout methodsToFileOut |

    projectDefinitionClass := packageID asPackageId projectDefinitionClass.
    classesToBeInitialized := OrderedCollection new.

    revinfo := projectDefinitionClass revisionInfo.
    name := projectDefinitionClass name.
    version := revinfo revision.
    author := revinfo author asString.
    timestamp := Timestamp fromDate: revinfo date andTime: revinfo time.
    description := projectDefinitionClass description.  

    aStream lineEndCRLF.

    "/ make sure that everything is loaded.
    projectDefinitionClass notNil ifTrue:[
        projectDefinitionClass autoload.
        projectDefinitionClass ensureFullyLoaded.
        classesToFileout := Smalltalk allClassesInPackage:packageID.
    ] ifFalse:[
        classesToFileout := Smalltalk allClassesInPackage:packageID.
        classesToFileout := classesToFileout collect:[:each | each autoload].
    ].

    methodsToFileOut := projectDefinitionClass extensions.

    self activityNotification:'checking for unportable unicode...'.

    self fileOutHeaderOn:aStream.
    self fileOutClasses: classesToFileout on: aStream.
    self fileOutExtensions: methodsToFileOut on: aStream.
    self fileOutFooterOn: aStream.

    "Created: / 14-04-2015 / 13:42:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2016 / 14:34:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutClasses:arg1 on:arg2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

fileOutExtensions:arg1 on:arg2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

fileOutFooterOn:aStresm

    "Created: / 03-11-2015 / 23:05:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutHeaderOn:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !


BeeProjectWriter initialize!
