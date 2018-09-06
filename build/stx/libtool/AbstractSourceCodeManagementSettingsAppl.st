"
 COPYRIGHT (c) 2006 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

AbstractSettingsApplication subclass:#AbstractSourceCodeManagementSettingsAppl
	instanceVariableNames:'shownInBrowserMenusHolder sourceCacheDir verboseSourceCodeAccess
		removeEnabled listOfModules'
	classVariableNames:''
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!AbstractSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    Abstract superclass of all source-code managers.

    These should implement an interface similar to what is found in CVSSourceCodeManager,
    providing methods to checkin/out files from a central repository.

    Not all managers will probably provide the same set of functions; 
    time will show, if such an abstraction is possible
    (the way source code management systems organize their code is different, 
    some keep individual per-class version numbers (CVS, RCS, SVN) 
    others keep an overall (configuration-) id (SVN, Git and Hg).
"
! !

!AbstractSourceCodeManagementSettingsAppl class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:CVSSourceCodeManagementSettingsAppl    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#workDirectory
'Directory where checkin/checkout happens (temporary source directory)'

#shownInBrowserMenus
'If checked, the Systembrowser includes operations for me in its SCM menus'

)

    "Created: / 11-01-2012 / 15:38:11 / cg"
! !

!AbstractSourceCodeManagementSettingsAppl class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSourceCodeManagementSettingsAppl defaultIcon'
        ifAbsentPut:[(Depth8Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@@@@@@@@@A@PHB@0P@@@@@@@@@@@@@@@@@@@HEA \HA $JB0HD@@@@@@@@@@@@@@HLA04NC0HD@@L@@ P@@@@@@@@@@@@ED@ NDP@@@@@@@@@D@@@@@@@@
@@@BA \FAPP@@@@@@@@@@@P@@@@@@@@@AQ@RC0@@@@@@@@@@@@@@@@@@@@@@@@TGA!!DD@@@@@@@@@@@@@@@@@@@D@PDIA08OA@@@@@@@@@@@@@@@@@@@AP S
A0XIBPXGC0P@@@@@@@@@@@@@@@@ECAPLBPXOAP@@@@@@EQX@@@@@@@@@@@TIE@XOAP@@@@@@EQ\XE @@@@@@@@@@AP$OAP@@@@@@FQ\ZE!! V@@@@@@@@@@@E
F0@@@@@@EQ\ZF!!(VFAX@@@@@@@@@@@@@@@@ZEQ\VE!!(ZF!!XWF @@@@@@@@@@@@@@@@@@@A\ZE!!(@@@@@@@@@@@@@@@@@@@@@@@@XE!!XZ@@@@@@@@@@@@@@@@
@@@@@@@@EQ(V@@@@@@@@@@@@@@@@@@@@@@@@EQ\VE @@@@@@@@@@@@@@@@@@@@@@EQ VE @@@@@@@@@@@@@@F @@@@@WEQ VE!!(@@@@@@@@@@@@@@@@@E!!\W
EQXVE @@@@@@@@@@@@@@@@@@@@@@@A(Z@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 32 64 0 0 64 0 32 32 0 0 32 0 32 96 32 96 192 128 192 224 192 160 224 160 32 128 64 64 96 64 64 96 32 32 160 64 160 224 192 64 160 96 32 128 32 224 224 224 64 128 64 160 192 160 224 224 192 32 160 96 160 160 160 64 64 64 96 96 96 128 128 128 192 192 192 32 32 32 32 64 32]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'@O8@@?>@A??@A?C C<@0C8@PC8@@??@@??F@_>O@O<_ G8?0C1?8A#?<@C?<@@_@H@_@L@?@GC>@C?>@A?<@@_0@') ; yourself); yourself]
!

defaultIconSmall
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIconSmall inspect
     ImageEditor openOnClass:self andSelector:#defaultIconSmall
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AbstractSourceCodeManagementSettingsAppl class defaultIconSmall'
        ifAbsentPut:[(Depth8Image new) width: 11; height: 11; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@0LAPT@@@@@@@@EC@0LC@T@@@@@@ 0L@@@@@@T@@@@EA T@@@@@@@@EAP0IC@<@@AX@@@@EBP0E@@@VE!!X@@@@EF0@@E!!(ZFAX@@@@@@AXVE1XVE @V
@@@@@@@VE @@@@@VE!!XVE!!X@@@@@@@@WE!!XV@@@@@@@a') ; colorMapFromArray:#[0 0 0 32 64 0 0 64 0 32 32 0 0 32 0 32 96 32 96 192 128 192 224 192 160 224 160 32 128 64 64 96 64 64 96 32 32 160 64 160 224 192 64 160 96 32 128 32 224 224 224 64 128 64 160 192 160 224 224 192 32 160 96 160 160 160 64 64 64 96 96 96 128 128 128 192 192 192 32 32 32 32 64 32]; mask:((ImageMask new) width: 11; height: 11; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C0@_ C!!@N@C< G''@L>@G8DF@O8@_@@@a') ; yourself); yourself]
! !

!AbstractSourceCodeManagementSettingsAppl class methodsFor:'queries'!

isAbstract
    ^ self == AbstractSourceCodeManagementSettingsAppl

    "Created: / 02-03-2012 / 15:55:41 / cg"
!

managerClass
    "backlink to my manager class (needed by the settings app)"

    self subclassResponsibility

    "Created: / 19-04-2011 / 12:47:28 / cg"
!

managerTypeName
    ^ self managerClass managerTypeName

    "Created: / 19-04-2011 / 12:48:37 / cg"
! !

!AbstractSourceCodeManagementSettingsAppl methodsFor:'actions'!

condenseSourceCache
    self withWaitCursorDo:[ AbstractSourceCodeManager condenseSourceCache ].
    Method flushSourceStreamCache.

    "Modified: / 28-11-2006 / 12:21:33 / cg"
!

flushSourceCache
    self withWaitCursorDo:[ AbstractSourceCodeManager flushSourceCache ].

    "Modified: / 30-09-2011 / 13:33:47 / cg"
! !

!AbstractSourceCodeManagementSettingsAppl methodsFor:'aspects'!

acceptChannel

    acceptChannel isNil ifTrue:[
        acceptChannel := TriggerValue new.
    ].
    ^ acceptChannel.
!

initialListOfModules
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

listOfModules
    listOfModules isNil ifTrue:[
        listOfModules := self initialListOfModules.
        listOfModules onChangeSend:#updateModifiedChannel to:self
    ].
    ^ listOfModules.

    "Modified: / 02-03-2012 / 14:42:53 / cg"
!

removeEnabled

    removeEnabled isNil ifTrue:[
        removeEnabled := false asValue.
    ].
    ^ removeEnabled.
!

sampleModuleList
    <resource: #uiAspect>

    |modules|

    modules := Smalltalk allPackageIDs 
                collect:[:packageId | packageId asPackageId module ]
                as:Set.

    modules remove:(PackageId noProjectID) ifAbsent:[].
    ^ modules asSortedCollection

    "Created: / 12-03-2012 / 11:54:25 / cg"
!

shownInBrowserMenusHolder
    shownInBrowserMenusHolder isNil ifTrue:[
        shownInBrowserMenusHolder := true asValue.
        shownInBrowserMenusHolder onChangeSend:#updateModifiedChannel to:self
    ].
    ^ shownInBrowserMenusHolder.

    "Created: / 10-01-2012 / 00:16:13 / cg"
!

sourceCacheDir
    sourceCacheDir isNil ifTrue:[
        sourceCacheDir := ValueHolder new.
        sourceCacheDir onChangeSend:#updateModifiedChannel to:self
    ].
    ^ sourceCacheDir.
!

verboseSourceCodeAccess
    verboseSourceCodeAccess isNil ifTrue:[
        verboseSourceCodeAccess := false asValue.
        verboseSourceCodeAccess onChangeSend:#updateModifiedChannel to:self
    ].
    ^ verboseSourceCodeAccess.
! !

!AbstractSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

