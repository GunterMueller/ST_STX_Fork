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

ToolApplicationModel subclass:#NewChangesBrowser
	instanceVariableNames:'changes changeFileName skipSignal changeFileTimestamp
		autoUpdateBlock filterCompletionBlock editingClassSource modified'
	classVariableNames:'AutoUpdate CompressSnapshotInfo CategoryColumn DeltaInfoColumn
		TypeColumn TimeStampColumn PositionsColumn PrivateAsSeparate
		ClassNameColumn ClassAndSelectorColumn SelectorColumn'
	poolDictionaries:''
	category:'Interface-Browsers'
!

Object subclass:#Change
	instanceVariableNames:'delta string type timeStamp category chunk lastPosition position
		className selector followUp'
	classVariableNames:''
	poolDictionaries:''
	privateIn:NewChangesBrowser
!

!NewChangesBrowser class methodsFor:'documentation'!

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
    The future Changes Browser.

    [start with:]
        NewChangesBrowser open
        NewChangesBrowser openOnFile:aFileName

    [author:]
        Thomas Zwick, eXept Software AG
        enhanced by Felix Madrid, eXept Software AG
"
! !

!NewChangesBrowser class methodsFor:'instance creation'!

openOn:aFileName
    "opens a Changes Browser with the changes of the aFileName"

    ^self openOnFile:aFileName

    "Created: / 17.10.1998 / 14:41:28 / cg"
!

openOnFile:aFileName
    "opens a Changes Browser with the changes of the aFileName"

    ^self new
	changeFileName:aFileName;
	open

! !

!NewChangesBrowser class methodsFor:'accessing'!

autoSelectNext
    "returns true here, makes a Delete operation automatically
     select the next change"

    ^ true


!

label
    "returns my label"

    ^'Changes Browser'
! !

!NewChangesBrowser class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:NewChangesBrowser
    "

    <resource: #help>

    ^super flyByHelpSpec addPairsFrom:#(

#applyAll
'Apply all changes.'

#applyForClassToEnd
'Apply changes which affect this class to the end.'

#applyFromLastSnapshot
'Apply changes from the last snapshot to the end.'

#applyLine
'Apply the selected change.'

#applyToEnd
'Apply all changes from the selected one to the end.'

#deleteAll
'Deletes all changes.'

#deleteCompress
'Deletes all obsolete changes.'

#deleteCompressForClass
'Deletes obsolete changes for this class, leaving the last one.'

#deleteForClassToEnd
'Deletes changes for this class from the selection to the end.'

#deleteLine
'Deletes the selected change.'

#deleteToEnd
'Deletes changes from the selected one to the end.'

#fileLoad
'Opens a dialog for selecting and loading another changes file.'

#fileReload
'Reloads the changes file (undo your modifications).'

#fileSave
'Saves the list of changes into the current changes file.'

#filterField
'Matching patterns filtering the changes (separate patterns by blanks).'

#settingsAutoUpdate
'Toggle automatic update.'

#settingsColumns
'Configure which columns are shown in the list.'

#settingsColumnsCategory
'Toggle display of the changes category in the list.'

#settingsColumnsDeltaInfo
'Toggle display of the delta-info in the list.'

#settingsColumnsPosition
'Togle display of the changes file-position in the list.'

#settingsColumnsTimeStamp
'Toggle display of the changes time stamp in the list.'

#settingsColumnsType
'Toggle display of the change-type in the list.'

#settingsPrivateAsSeparate
'Toggle if changes for private private are included when applying, deleting, or compressing for a class.'

#testCompareWithCurrentVersion
'Opens a info dialog showing the difference between the changes code and the method current code.'

#testFindLastSnapshot
'Searches backward for the previous snapshot entry.'

#testFindNextSnapshot
'Searches forward for the next snapshot entry.'

)

    "Modified: / 19.5.1998 / 17:59:39 / cg"
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:NewChangesBrowser    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#applyAll
'Apply all changes.'

#applyForClassToEnd
'Apply changes to the end which affect this class.'

#applyFromLastSnapshot
'Apply changes from the last snapshot to the end.'

#applyLine
'Apply the selected change.'

#applyToEnd
'Apply all changes from the selected one to the end.'

#deleteAll
'Deletes all changes.'

#deleteCompress
'Deletes all obsolete changes.'

#deleteCompressForClass
'Deletes obsolete changes for this class, leaving the last one.'

#deleteForClassToEnd
'Deletes changes for this class from the selection to the end.'

#deleteLine
'Deletes the selected change.'

#deleteToEnd
'Deletes changes from the selected one to the end.'

#fileLoad
'Opens a dialog for selecting and loading another changes file.'

#fileReload
'Reloads the changes file (undo your modifications).'

#fileSave
'Saves the list of changes into the current changes file.'

#filterField
'Matching patterns filtering the changes (separate patterns by blanks).'

#settingsAutoUpdate
'Toggle automatic update.'

#settingsColumns
'Configure which columns are shown in the list.'

#settingsColumnsCategory
'Toggle display of the changes category in the list.'

#settingsColumnsClassName
'Toggle display of the className in the list.'

#settingsColumnsDeltaInfo
'Toggle display of the delta-info in the list.'

#settingsColumnsPosition
'Togle display of the changes file-position in the list.'

#settingsColumnsTimeStamp
'Toggle display of the changes time stamp in the list.'

#settingsColumnsType
'Toggle display of the change-type in the list.'

#settingsPrivateAsSeparate
'Toggle if changes for private private are included when applying, deleting, or compressing for a class.'

#testCompareWithCurrentVersion
'Opens a info dialog showing the difference between the changes code and the method current code.'

#testFindLastSnapshot
'Searches backward for the previous snapshot entry.'

#testFindNextSnapshot
'Searches forward for the next snapshot entry.'

)
! !

!NewChangesBrowser class methodsFor:'image specs'!

applyFromLastSnapshotIcon
    ^ self applyFromLastSnapshotIcon2
!

applyFromLastSnapshotIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self applyFromLastSnapshotIcon inspect
     ImageEditor openOnClass:self andSelector:#applyFromLastSnapshotIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'NewChangesBrowser class applyFromLastSnapshotIcon'
        ifAbsentPut:[(Depth4Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(4)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BH"H"H@@@@@@@@@H"H"H @@@@@@@@@@@@@B@@@@@@
@@;.;.; H@@@@@@@C.;.;.@@@@@@@@@@@@@@8@@N@@@@C?????C @@@N@@@O????<@@@8@@@@@@@@@C0@@@@8@@O????<O@@C @@@@?????0@@@@C @@@@@@
@O@@@N@@@@DQDQDP<@C @@@@@_??DQ@@@@@@@@@A????D@@@@@@@@@DQDQDP@@@@C @@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C?0@B@P@B@P@O?P@O?P@O?0@??@@??@@??LC?<\C?<\C?<8O?08O?10O?10??C ??[@??_@?<^@?<_@?<_@') ; yourself); yourself]
!

applyFromLastSnapshotIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self applyFromLastSnapshotIcon1 inspect
     ImageEditor openOnClass:self andSelector:#applyFromLastSnapshotIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'NewChangesBrowser class applyFromLastSnapshotIcon1'
        ifAbsentPut:[(Depth4Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(4)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@BH@@@@@@QDQ<@@BH @@@@@AH"H@@@H"@@@@@@D"H H H"@@@@@@@RH"@"H"@@@@@@@AH"H@H"H@@@@@@@<@@@@BH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@;.;.; @@@@@@@@C.;.;.@@@@@@@@@@@@@@8@@N@@@@C?????C @@@N@@@O????<@@@8@@@@@@@@@C0@@@@8@@O????<O@@C @@@@?????0@@@@C @@@@@@
@O@@@N@@@@DQDQDP<@C @@@@@_??DQ@@@@@@@@@A????D@@@@@@@@@DQDQDP@@@@C @@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A@C<C@C<C@C<&@C<<@C<\@C<H@@@@?<@@?<@@?<LC?<\C?<\C?<8O?08O?10O?10??C ??[@??_@?<^@?<_@?<_@') ; yourself); yourself]
!

applyIcon
    ^ self applyIcon2
!

applyIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self applyIcon inspect
     ImageEditor openOnClass:self andSelector:#applyIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'NewChangesBrowser class applyIcon'
        ifAbsentPut:[(Depth2Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(2)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
UUUUUUUPUUUUUU?PUUUUUU?[UUUUUW=PP@@@@C<QQUUU=_4PQUUU?_4VQ**U_?TPQUUUW?TPQUUUW=TXQ***U=TPQ**UUUTPQ*****TPQ***%UTPQ****)TP
QUUUUUTPQUUUUUTUP@@@@@@PUUUUUUUPUUUUUUUPUUUUUUUPUUUUUUUP') ; colorMapFromArray:#[0 0 0 255 255 255 170 170 170 255 0 0]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@8@@@8@@A0_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]
!

applyIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self applyIcon2 inspect
     ImageEditor openOnClass:self andSelector:#applyIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'NewChangesBrowser class applyIcon2'
        ifAbsentPut:[(Depth4Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[4]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
DQDQDQDQDQDQP3PQDQDQDQDQDQECMADQDQDQDQDQECMADQDQDQEDPQDTL4DP@@@@@DL4@DL4@Q@QDQDQP3MAP3PADADQDQDTL3P3PPDPD"H"HQECL3MA@Q@Q
DQDQDQP3MADADADQDQDQDTL4DPDPD"H"H"HQEDDQ@Q@RH"H!!DQDQDQDADAH"H"H"H"H"DPDPD"H"H"H!!DQDQ@Q@RH"H"H"H"HQDADADQDQDQDQDQDPDPDQDQ
DQDQDQDQ@Q@@@@@@@@@@@@@ADQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDb') ; colorMapFromArray:#[0 0 0 255 255 255 170 170 170 255 0 0 85 85 85]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@<@@@<@@A8@C!!8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]
!

applyToEndIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self applyToEndIcon inspect
     ImageEditor openOnClass:self andSelector:#applyToEndIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'NewChangesBrowser class applyToEndIcon'
        ifAbsentPut:[(Depth4Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[4]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@DP@@@@@@@@@@@@DQ@@@@@@@@@@@@@QD@@@"H"H"@@Q@QD@@@BH"H"H@ADQD@@@@@@@@@ @@QDP@@BH"H"HB@@@DP@@@H"H"H @@@@@@@@@@@@@B@@@@@@
@@L3L3L0H@@@@@@@@3L3L3@@@@@@@@@@@@@@L@@B@@@@@3L3L3@0@@@B@@@CL3L3L@@@H@@@@@@@@@@0@@@@H@@ADQDQDC@@@ @@@@DQDQDP@@@@@ @@@@@@
@A@@@B@@@@DQDQDPD@@ @@@@@SL3DQ@@@@@@@@@AL3L3D@@@@@@@@@DQDQDP@@@@@ @@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255 127 127 127 170 170 170 255 0 0]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A@@@CC?0CC?0&C?0<O?0\O?0HO?0@??@@??@@??LC?<\C?<\C?<8O?08O?10O?10??C ??[@??_@?<^@?<_@?<_@') ; yourself); yourself]
!

compressIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     ImageEditor openOnClass:self andSelector:#compressIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'NewChangesBrowser compressIcon'
	ifAbsentPut:[(Depth2Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@????<@@@:***(@@@8@@@8@@@8@@@8@@@@@@@8@@@@@@@8A@@@@@@8@@:**0@8HC**+@@8@@@@@@@8H@@@@@@8@@@@@@@8@@@@@@@8@@@@@@@8@@C????8@@C****(@@@@@@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 124 124 124 170 170 170 255 255 255]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@??0A??8A??8A??8A8A8G>A8@@A8G?98O?18_?!!8??A8@@A8G>A8@0A8C??8C??8C??8C??0@0@@D2@@G>@@D2@@') ; yourself); yourself]
!

deleteIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     ImageEditor openOnClass:self andSelector:#deleteIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'NewChangesBrowser deleteIcon'
	ifAbsentPut:[(Depth2Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@AUUUU@@OA??UU@@@AUUUU@@@AUUUU@B@A???U@H@A??5U@@@A???0@@@AUUUB@B@@@@@@@@@@@@@A@BK@@@@A_:@@@@@AO2G@@@@AL2@@@@@AL2C@@@@AL2@@@@@AL2@@@@@AL2H@@@@AL2@@@@@A\:@@@@@H_8 @@@@@@@H') ; colorMapFromArray:#[0 0 0 255 255 255 127 127 127 170 170 170]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'_?<@_?<@_?<P_?<P_?<X_?<X_?<H_? H_?O<_?XL@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@G0') ; yourself); yourself]
!

deleteToEndIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     ImageEditor openOnClass:self andSelector:#deleteToEndIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'NewChangesBrowser deleteToEndIcon'
	ifAbsentPut:[(Depth2Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@B** @@O@B** @@@@@@@ @@@@??< @B@@??<@@H@@@@L@@@@EUUL@@@@G?U@B@B@G?=@@@@@EUU@A@BK@@@@A_:@@@@@AO2G@@@@AL2@@@@@AL2C@@@@AL2@@@@@AL2@@@@@AL2H@@@@AL2@@@@@A\:@@@@@H_8 @@@@@@@H') ; colorMapFromArray:#[0 0 0 255 255 255 127 127 127 170 170 170]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C?0@C?0@C?0PO?0PO?0XO?0X??@H??@H??O<?<XL?<_<?<_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@G0') ; yourself); yourself]
!

findLastSnapshotIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     ImageEditor openOnClass:self andSelector:#findLastSnapshotIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'NewChangesBrowser findLastSnapshotIcon'
	ifAbsentPut:[(Depth2Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@EUUUW@A@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@F***(@A@F***(@M@F***(@H@F***(@@@F***(@@@F***(@I@L@@@@@@@@@@@@@A@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0 170 170 170]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??B@@@B@C@B@G B@O0@@_8@@G @@G @@G @') ; yourself); yourself]
!

findNextSnapshotIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     ImageEditor openOnClass:self andSelector:#findNextSnapshotIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'NewChangesBrowser findNextSnapshotIcon'
	ifAbsentPut:[(Depth2Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@DA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D@B@@@@@@@@@@@@@@@E@@@@@@@@@EUUUW@N@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@V***(@H@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@L@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0 170 170 170]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@G @@G @@G @@_8@@O0@@G @@C@@@@@@C??@C??@C??@C??@C??@C??BC??BC??BC??BC??@C??@C??@C??@C??@') ; yourself); yourself]
!

findPreviousForClassIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self findPreviousForClassIcon inspect
     ImageEditor openOnClass:self andSelector:#findPreviousForClassIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'NewChangesBrowser class findPreviousForClassIcon'
        ifAbsentPut:[(Depth2Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(2)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@EUUUW@A@G???<@@@G???<@@@G???<@@@G???<@@@G???<@@@G???<@@@G???<@A@G???<@M@G???<@H@G???<@@@G???<@@@G???<@I@L@@@@@@@@@@@@@A
@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0 170 170 170]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??B@@@B@C@B@G B@O0@@_8@@G @@G @@G @') ; yourself); yourself]
!

findPreviousSnapshotIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self findPreviousSnapshotIcon inspect
     ImageEditor openOnClass:self andSelector:#findPreviousSnapshotIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'NewChangesBrowser class findPreviousSnapshotIcon'
        ifAbsentPut:[(Depth2Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(2)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@EUUUW@A@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@F***(@A@F***(@M@F***(@H@F***(@@@F***(@@@F***(@I@L@@@@@@@@@@@@@A
@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0 170 170 170]; mask:((Depth1Image new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??B@@@B@C@B@G B@O0@@_8@@G @@G @@G @') ; yourself); yourself]
! !

!NewChangesBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:NewChangesBrowser andSelector:#windowSpec
     NewChangesBrowser new openInterface:#windowSpec
     NewChangesBrowser open
    "

    <resource: #canvas>

    ^

       #(#FullSpec
	  #window:
	   #(#WindowSpec
	      #name: 'Changes Browser'
	      #layout: #(#LayoutFrame 53 0 92 0 687 0 583 0)
	      #label: 'Changes Browser'
	      #min: #(#Point 10 10)
	      #max: #(#Point 1152 900)
	      #bounds: #(#Rectangle 53 92 688 584)
	      #menu: #menu
	      #usePreferredExtent: false
	  )
	  #component:
	   #(#SpecCollection
	      #collection:
	       #(
		 #(#MenuPanelSpec
		    #name: 'menuToolbarView'
		    #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 32 0)
		    #menu: #menuToolbar
		    #style: #(#FontDescription #helvetica #medium #roman 10)
		    #showSeparatingLines: true
		)
		 #(#VariableVerticalPanelSpec
		    #name: 'variableVerticalPanel1'
		    #layout: #(#LayoutFrame 0 0.0 34 0 0 1.0 -26 1.0)
		    #component:
		     #(#SpecCollection
			#collection:
			 #(
			   #(#ViewSpec
			      #name: 'Box1'
			      #component:
			       #(#SpecCollection
				  #collection:
				   #(
				     #(#DataSetSpec
					#name: 'changesDataSetView'
					#layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 -28 1.0)
					#model: #selectionOfChange
					#menu: #menuTable
					#hasHorizontalScrollBar: true
					#hasVerticalScrollBar: true
					#miniScrollerHorizontal: true
					#dataList: #listOfChanges
					#useIndex: false
					#has3Dsepartors: true
					#doubleClickSelector: #doBrowseClass
					#columnHolder: #listOfChangeColumns
					#valueChangeSelector: #changeSelected:
				    )
				     #(#ViewSpec
					#name: 'Box2'
					#layout: #(#LayoutFrame 0 0.0 -28 1 0 1.0 0 1.0)
					#component:
					 #(#SpecCollection
					    #collection:
					     #(
					       #(#LabelSpec
						  #name: 'filterLabel'
						  #layout: #(#AlignmentOrigin 37 0 13 0.0 1 0.5)
						  #label: 'Filter:'
						  #style: #(#FontDescription #helvetica #medium #roman 10)
						  #adjust: #left
					      )
					       #(#InputFieldSpec
						  #name: 'filterField'
						  #layout: #(#LayoutFrame 41 0.0 3 0 250 0 25 0)
						  #activeHelpKey: #filterField
						  #model: #valueOfFilter
						  #immediateAccept: false
					      )
					       #(#ProgressIndicatorSpec
						  #name: 'readProgressIndicator'
						  #layout: #(#LayoutFrame 41 0 3 0 250 0 25 0)
						  #model: #valueOfReadProgress
						  #foregroundColor: #(#Color 0.0 60.0 60.0)
					      )
					       #(#ActionButtonSpec
						  #name: 'allButton'
						  #layout: #(#LayoutFrame 258 0.0 2 0.0 268 0 13 0)
						  #label: ' '
						  #model: #doFilter:
					      )
					       #(#LabelSpec
						  #name: 'allLabel'
						  #layout: #(#LayoutFrame 273 0 0 0.0 310 0 14 0)
						  #label: '= all'
						  #translateLabel: true
						  #style: #(#FontDescription #helvetica #medium #roman 10)
						  #adjust: #left
					      )
					       #(#ActionButtonSpec
						  #name: 'methodChangesButton'
						  #layout: #(#LayoutFrame 359 0.0 2 0.0 369 0 13 0)
						  #label: ' '
						  #backgroundColor: #(#Color 100.0 100.0 100.0)
						  #model: #doFilterType:
						  #actionValue: 'method'
					      )
					       #(#LabelSpec
						  #name: 'methodChangesLabel'
						  #layout: #(#LayoutFrame 373 0 0 0.0 458 0 14 0)
						  #label: '= method'
						  #translateLabel: true
						  #style: #(#FontDescription #helvetica #medium #roman 10)
						  #adjust: #left
					      )
					       #(#ActionButtonSpec
						  #name: 'classChangesButton'
						  #layout: #(#LayoutFrame 455 0.0 2 0.0 465 0 13 0)
						  #label: ' '
						  #backgroundColor: #(#Color 50.0008 50.0008 50.0008)
						  #model: #doFilterType:
						  #actionValue: 'class'
					      )
					       #(#LabelSpec
						  #name: 'classChangesLabel'
						  #layout: #(#LayoutFrame 470 0 0 0.0 580 0 14 0)
						  #label: '= class change'
						  #translateLabel: true
						  #style: #(#FontDescription #helvetica #medium #roman 10)
						  #adjust: #left
					      )
					       #(#ActionButtonSpec
						  #name: 'snapshotButton'
						  #layout: #(#LayoutFrame 258 0.0 16 0.0 268 0 27 0)
						  #label: ' '
						  #backgroundColor: #(#Color 100.0 0.0 0.0)
						  #model: #doFilterType:
						  #actionValue: 'image'
					      )
					       #(#LabelSpec
						  #name: 'snapshotLabel'
						  #layout: #(#LayoutFrame 273 0 14 0.0 355 0 28 0)
						  #label: '= snapshot'
						  #translateLabel: true
						  #style: #(#FontDescription #helvetica #medium #roman 10)
						  #adjust: #left
					      )
					       #(#ActionButtonSpec
						  #name: 'fileInButton'
						  #layout: #(#LayoutFrame 359 0.0 16 0.0 369 0 27 0)
						  #label: ' '
						  #backgroundColor: #(#Color 0.0 80.0 80.0)
						  #model: #doFilterSourceType:
						  #actionValue: '* file*'
					      )
					       #(#LabelSpec
						  #name: 'fileInLabel'
						  #layout: #(#LayoutFrame 374 0 14 0.0 440 0 28 0)
						  #label: '= fileIn'
						  #translateLabel: true
						  #style: #(#FontDescription #helvetica #medium #roman 10)
						  #adjust: #left
					      )
					       #(#ActionButtonSpec
						  #name: 'checkInButton'
						  #layout: #(#LayoutFrame 455 0.0 16 0.0 465 0 27 0)
						  #label: ' '
						  #backgroundColor: #(#Color 0.0 0.0 100.0)
						  #model: #doFilterSourceType:
						  #actionValue: '* checkin*'
					      )
					       #(#LabelSpec
						  #name: 'checkInLabel'
						  #layout: #(#LayoutFrame 470 0 14 0.0 550 0 28 0)
						  #label: '= checkIn'
						  #translateLabel: true
						  #style: #(#FontDescription #helvetica #medium #roman 10)
						  #adjust: #left
					      )
					    )
					)
				    )
				  )
			      )
			  )
			   #(#WorkspaceSpec
			      #name: 'changeTextEditor'
			      #model: #valueOfChangeText
			      #hasHorizontalScrollBar: true
			      #hasVerticalScrollBar: true
			      #miniScrollerHorizontal: true
			      #isReadOnly: true
			  )
			)
		    )
		    #handles: #(#Any 0.5 1.0)
		)
		 #(#UISubSpecification
		    #name: 'windowSpecForInfoBar'
		    #layout: #(#LayoutFrame 0 0.0 -24 1 0 1.0 0 1.0)
		    #majorKey: #ToolApplicationModel
		    #minorKey: #windowSpecForInfoBar
		)
	      )
	  )
      )

    "Modified: / 19.5.1998 / 18:58:47 / cg"
! !

!NewChangesBrowser class methodsFor:'list specs'!

tableColumnsForChangeAttributes
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:NewChangesBrowser andSelector:#tableColumnsForChangeAttributes
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         labelButtonType: Button
         rendererType: rowSelector
         backgroundSelector: listColor
         showSelectionHighLighted: false
       )
      (DataSetColumnSpec
         label: 'Change'
         id: change
         labelAlignment: left
         labelButtonType: Button
         model: string
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Class'
         id: 'className'
         labelAlignment: left
         activeHelpKey: ''
         labelButtonType: Button
         model: className
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Selector'
         id: 'selector'
         labelAlignment: left
         activeHelpKey: ''
         labelButtonType: Button
         model: selector
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Category'
         id: category
         labelAlignment: left
         labelButtonType: Button
         model: category
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Delta Info'
         id: deltaInfo
         labelAlignment: left
         labelButtonType: Button
         model: delta
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Time Stamp'
         id: timeStamp
         labelAlignment: left
         labelButtonType: Button
         model: timeStamp
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Type'
         id: type
         labelAlignment: left
         labelButtonType: Button
         model: type
         canSelect: false
       )
      (DataSetColumnSpec
         label: 'Position'
         id: position
         labelAlignment: left
         labelButtonType: Button
         model: positions
         canSelect: false
       )
      )
    
! !

!NewChangesBrowser class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NewChangesBrowser andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(NewChangesBrowser menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: fileReload
                  enabled: valueOfNotReading
                  label: 'Reload'
                  itemValue: doReload
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: fileLoad
                  enabled: valueOfNotSaving
                  label: 'Load...'
                  itemValue: doLoad
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: fileSave
                  enabled: valueOfNotReading
                  label: 'Save'
                  itemValue: doSave
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: fileBrowseClass
                  enabled: valueOfHavingChangeSelection
                  label: 'Browse Class'
                  itemValue: doBrowseClass
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: fileExit
                  enabled: valueOfNotSaving
                  label: 'Exit'
                  itemValue: closeRequest
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Apply'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: applyLine
                  enabled: valueOfHavingChangeSelection
                  label: 'Change'
                  itemValue: doApply
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: applyAll
                  enabled: valueOfNotReading
                  label: 'All'
                  itemValue: doApplyAll
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: applyToEnd
                  enabled: valueOfHavingSelection
                  label: 'To End'
                  itemValue: doApplyToEnd
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: applyForClassToEnd
                  enabled: valueOfHavingChangeSelection
                  label: 'All for Class'
                  itemValue: doApplyAllForClass
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: applyForClassToEnd
                  enabled: valueOfHavingChangeSelection
                  label: 'For Class to End'
                  itemValue: doApplyForClassToEnd
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: applyFromLastSnapshot
                  enabled: valueOfNotReading
                  label: 'From Last Snapshot'
                  itemValue: doApplyFromLastSnapshot
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Delete'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: deleteLine
                  enabled: valueOfHavingSelection
                  label: 'Change'
                  itemValue: doDelete
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: deleteAll
                  enabled: valueOfNotReading
                  label: 'All'
                  itemValue: doDeleteAll
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: deleteToEnd
                  enabled: valueOfHavingSelection
                  label: 'To End'
                  itemValue: doDeleteToEnd
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: applyForClassToEnd
                  enabled: valueOfHavingChangeSelection
                  label: 'All for Class'
                  itemValue: doDeleteAllForClass
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: deleteForClassToEnd
                  enabled: valueOfHavingChangeSelection
                  label: 'For Class to End'
                  itemValue: doDeleteForClassToEnd
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: deleteCompress
                  enabled: valueOfNotReading
                  label: 'Compress'
                  itemValue: doCompress
                  translateLabel: true
                )
               (MenuItem
                  activeHelpKey: deleteCompressForClass
                  enabled: valueOfHavingChangeSelection
                  label: 'Compress for Class'
                  itemValue: doCompressForClass
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Search'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: testFindPreviousSnapshot
                  enabled: valueOfHavingSelection
                  label: 'Find Previous Snapshot'
                  itemValue: doFindSnapshot:
                  translateLabel: true
                  argument: 'previous'
                )
               (MenuItem
                  activeHelpKey: testFindNextSnapshot
                  enabled: valueOfHavingSelection
                  label: 'Find Next Snapshot'
                  itemValue: doFindSnapshot:
                  translateLabel: true
                  argument: 'next'
                )
               (MenuItem
                  activeHelpKey: testFindLastSnapshot
                  enabled: valueOfHavingSelection
                  label: 'Find Last Snapshot'
                  itemValue: doFindSnapshot:
                  translateLabel: true
                  argument: 'last'
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Test'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: testCompareWithCurrentVersion
                  enabled: valueOfHavingChangeSelection
                  label: 'Compare with Current Version'
                  itemValue: doCompare
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Settings'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  activeHelpKey: settingsAutoUpdate
                  enabled: valueOfNotReading
                  label: 'Auto Update'
                  translateLabel: true
                  indication: autoUpdateMode:
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: settingsPrivateAsSeparate
                  enabled: valueOfNotReading
                  label: 'Private Classes as Separate'
                  translateLabel: true
                  indication: privateAsSeparate:
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: settingsColumns
                  label: 'Columns'
                  translateLabel: true
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        activeHelpKey: settingsColumnsClassName
                        label: 'Class'
                        translateLabel: true
                        isVisible: false
                        hideMenuOnActivated: false
                        indication: classNameColumn:
                      )
                     (MenuItem
                        activeHelpKey: settingsColumnsCategory
                        label: 'Selector'
                        translateLabel: true
                        isVisible: false
                        hideMenuOnActivated: false
                        indication: selectorColumn:
                      )
                     (MenuItem
                        activeHelpKey: settingsColumnsCategory
                        label: 'Category'
                        translateLabel: true
                        hideMenuOnActivated: false
                        indication: categoryColumn:
                      )
                     (MenuItem
                        activeHelpKey: settingsColumnsDeltaInfo
                        label: 'Delta Info'
                        translateLabel: true
                        hideMenuOnActivated: false
                        indication: deltaInfoColumn:
                      )
                     (MenuItem
                        activeHelpKey: settingsColumnsType
                        label: 'Type'
                        translateLabel: true
                        hideMenuOnActivated: false
                        indication: typeColumn:
                      )
                     (MenuItem
                        activeHelpKey: settingsColumnsTimeStamp
                        label: 'Time Stamp'
                        translateLabel: true
                        hideMenuOnActivated: false
                        indication: timeStampColumn:
                      )
                     (MenuItem
                        activeHelpKey: settingsColumnsPosition
                        label: 'Positions'
                        translateLabel: true
                        hideMenuOnActivated: false
                        indication: positionsColumn:
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: valueOfNotReading
                  label: 'Fonts'
                  translateLabel: true
                  submenuChannel: menuFont
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'MENU_Help'
            translateLabel: true
            startGroup: conditionalRight
            submenuChannel: menuHelp
          )
         )
        nil
        nil
      )
!

menuTable
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NewChangesBrowser andSelector:#menuTable
     (Menu new fromLiteralArrayEncoding:(NewChangesBrowser menuTable)) startUp
    "

    <resource: #menu>

    ^

       #(#Menu

	   #(
	     #(#MenuItem
		#label: 'Apply'
		#translateLabel: true
		#value: #doApply
		#activeHelpKey: #applyLine
		#enabled: #valueOfHavingChangeSelection
	    )
	     #(#MenuItem
		#label: 'Apply To End'
		#translateLabel: true
		#value: #doApplyToEnd
		#activeHelpKey: #applyToEnd
		#enabled: #valueOfHavingSelection
	    )
	     #(#MenuItem
		#label: 'Apply All For Class'
		#translateLabel: true
		#value: #doApplyAllForClass
		#activeHelpKey: #applyForClassToEnd
		#enabled: #valueOfHavingChangeSelection
	    )
	     #(#MenuItem
		#label: 'Apply For Class To End'
		#translateLabel: true
		#value: #doApplyForClassToEnd
		#activeHelpKey: #applyForClassToEnd
		#enabled: #valueOfHavingChangeSelection
	    )
	     #(#MenuItem
		#label: '-'
	    )
	     #(#MenuItem
		#label: 'Delete'
		#translateLabel: true
		#value: #doDelete
		#activeHelpKey: #deleteLine
		#enabled: #valueOfHavingSelection
	    )
	     #(#MenuItem
		#label: 'Delete To End'
		#translateLabel: true
		#value: #doDeleteToEnd
		#activeHelpKey: #deleteToEnd
		#enabled: #valueOfHavingSelection
	    )
	     #(#MenuItem
		#label: 'Delete All For Class'
		#translateLabel: true
		#value: #doDeleteAllForClass
		#activeHelpKey: #applyForClassToEnd
		#enabled: #valueOfHavingChangeSelection
	    )
	     #(#MenuItem
		#label: 'Delete For Class To End'
		#translateLabel: true
		#value: #doDeleteForClassToEnd
		#activeHelpKey: #deleteForClassToEnd
		#enabled: #valueOfHavingChangeSelection
	    )
	     #(#MenuItem
		#label: '-'
	    )
	     #(#MenuItem
		#label: 'Browse Class'
		#translateLabel: true
		#value: #doBrowseClass
		#activeHelpKey: #fileBrowseClass
		#enabled: #valueOfHavingChangeSelection
	    )
	     #(#MenuItem
		#label: '-'
	    )
	     #(#MenuItem
		#label: 'Compress For Class'
		#translateLabel: true
		#value: #doCompressForClass
		#activeHelpKey: #deleteCompressForClass
		#enabled: #valueOfHavingChangeSelection
	    )
	  ) nil
	  nil
      )

    "Modified: / 19.5.1998 / 18:03:59 / cg"
!

menuToolbar
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:NewChangesBrowser andSelector:#menuToolbar
     (Menu new fromLiteralArrayEncoding:(NewChangesBrowser menuToolbar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: fileLoad
            enabled: valueOfNotReading
            label: 'Load'
            itemValue: doLoad
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary loadFromFileIcon)
          )
         (MenuItem
            activeHelpKey: fileSave
            enabled: valueOfNotSaving
            label: 'Save'
            itemValue: doSave
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary saveToFileIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: applyLine
            enabled: valueOfHavingChangeSelection
            label: 'Apply'
            itemValue: doApply
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever nil applyIcon)
          )
         (MenuItem
            activeHelpKey: applyToEnd
            enabled: valueOfHavingSelection
            label: 'Apply To End'
            itemValue: doApplyToEnd
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever nil applyToEndIcon)
          )
         (MenuItem
            activeHelpKey: applyFromLastSnapshot
            enabled: valueOfNotReading
            label: 'Apply From Last Snapshot'
            itemValue: doApplyFromLastSnapshot
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever nil applyFromLastSnapshotIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: deleteLine
            enabled: valueOfHavingSelection
            label: 'Delete'
            itemValue: doDelete
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever nil deleteIcon)
          )
         (MenuItem
            activeHelpKey: deleteToEnd
            enabled: valueOfHavingSelection
            label: 'Delete To End'
            itemValue: doDeleteToEnd
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever nil deleteToEndIcon)
          )
         (MenuItem
            activeHelpKey: deleteCompress
            enabled: valueOfNotReading
            label: 'Compress'
            itemValue: doCompress
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever nil compressIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: testFindPreviousSnapshot
            enabled: valueOfHavingSelection
            label: 'Find Previous Snapshot'
            itemValue: doFindSnapshot:
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever nil findPreviousSnapshotIcon)
            argument: 'previous'
          )
         (MenuItem
            activeHelpKey: testFindNextSnapshot
            enabled: valueOfHavingSelection
            label: 'Find Next Snapshot'
            itemValue: doFindSnapshot:
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever nil findNextSnapshotIcon)
            argument: 'next'
          )
         )
        nil
        nil
      )
! !

!NewChangesBrowser methodsFor:'accesssing - columns'!

categoryColumn
    "returns whether the column for the category attribute of the changes is shown"

    ^CategoryColumn ? (CategoryColumn := false)
!

categoryColumn: aBoolean
    "sets whether the column for the category attribute of the changes is shown"

    self changeColumn: #category add: (CategoryColumn := aBoolean)

    "Modified: / 19.5.1998 / 20:30:13 / cg"
!

classAndSelectorColumn
    "returns whether the column for the category attribute of the changes is shown"

    ^ClassAndSelectorColumn ? (ClassAndSelectorColumn := false)
!

classAndSelectorColumn: aBoolean
    "sets whether the column for the category attribute of the changes is shown"

    self changeColumn: #classAndSelector add: (ClassAndSelectorColumn := aBoolean)

    "Modified: / 19.5.1998 / 20:30:13 / cg"
!

classNameColumn
    "returns whether the column for the category attribute of the changes is shown"

    ^ClassNameColumn ? (ClassNameColumn := false)
!

classNameColumn: aBoolean
    "sets whether the column for the className attribute of the changes is shown"

    self changeColumn: #className add: (ClassNameColumn := aBoolean)

    "Modified: / 19.5.1998 / 20:30:13 / cg"
!

deltaInfoColumn
    "returns whether the column for the delta info attribute of the changes is shown"

    ^DeltaInfoColumn ? (DeltaInfoColumn := false)
!

deltaInfoColumn: aBoolean
    "sets whether the column for the delta info attribute of the changes is shown; and updates"

    self changeColumn: #deltaInfo add: (DeltaInfoColumn := aBoolean).
    (self window notNil and: [DeltaInfoColumn]) ifTrue: [self doReload]

    "Modified: / 19.5.1998 / 20:30:21 / cg"
!

positionsColumn
    "returns whether the column for the position attribute of the changes is shown"

    ^PositionsColumn ? (PositionsColumn := false)
!

positionsColumn: aBoolean
    "sets whether the column for the positions attribute of the changes is shown"

    self changeColumn: #position add: (PositionsColumn := aBoolean)

    "Modified: / 19.5.1998 / 20:30:37 / cg"
!

selectorColumn
    "returns whether the column for the category attribute of the changes is shown"

    ^SelectorColumn ? (SelectorColumn := false)
!

selectorColumn: aBoolean
    "sets whether the column for the category attribute of the changes is shown"

    self changeColumn: #selector add: (SelectorColumn := aBoolean)

    "Modified: / 19.5.1998 / 20:30:13 / cg"
!

timeStampColumn
    "returns whether the column for the time stamp attribute of the changes is shown"

    ^TimeStampColumn ? (TimeStampColumn := false)
!

timeStampColumn: aBoolean
    "sets whether the column for the time stamp attribute of the changes is shown"

    self changeColumn: #timeStamp add: (TimeStampColumn := aBoolean)

    "Modified: / 19.5.1998 / 20:30:42 / cg"
!

typeColumn
    "returns whether the column for the type attribute of the changes is shown"

    ^TypeColumn ? (TypeColumn := false)
!

typeColumn: aBoolean
    "sets whether the column for the type attribute of the changes is shown"

    self changeColumn: #type add: (TypeColumn := aBoolean)

    "Modified: / 19.5.1998 / 20:30:46 / cg"
! !

!NewChangesBrowser methodsFor:'accesssing - views'!

changeTextEditor
    "returns the view of the changeTextEditor"

    ^builder componentAt: #changeTextEditor



!

filterField
    "returns the view of the filterField"

    ^builder componentAt: #filterField



!

filterLabel
    "returns the view of the filterLabel"

    ^builder componentAt: #filterLabel



!

readProgressIndicator
    "returns the view of the readProgressIndicator"

    ^builder componentAt: #readProgressIndicator



! !

!NewChangesBrowser methodsFor:'aspects'!

listOfChangeColumns
    "initializes (during the startup) and returns the value holder for the columns"

    |holder|
    (holder := builder bindingAt:#listOfChangeColumns) isNil ifTrue:[
        builder aspectAt:#listOfChangeColumns put:(holder := List new).
        self changeColumn: nil add: true.
        self changeColumn: #change add: true.

        self classNameColumn: self classNameColumn.
        self classAndSelectorColumn: self classAndSelectorColumn.
        self selectorColumn: self selectorColumn.
        self categoryColumn: self categoryColumn.
        self timeStampColumn: self timeStampColumn.
        self typeColumn: self typeColumn.
"/        self deltaInfoColumn: self deltaInfoColumn.
        self positionsColumn: self positionsColumn.
    ].
    ^ holder

    "Modified: / 19.5.1998 / 20:30:31 / cg"
!

listOfChanges
    "returns the value holder for the changes"

    |holder|
    (holder := builder bindingAt:#listOfChanges) isNil ifTrue:[
	builder aspectAt:#listOfChanges put:(holder := List new)
    ].
    ^ holder
!

selectionOfChange
    "returns the value holder for the selected change"

    |holder|
    (holder := builder bindingAt:#selectionOfChange) isNil ifTrue:[
	builder aspectAt:#selectionOfChange put:(holder :=  ValueHolder new).
    ].
    ^ holder
!

valueOfChangeText
    "returns the value holder for the source code of the selected change"

    |holder|
    (holder := builder bindingAt:#valueOfChangeText) isNil ifTrue:[
	builder aspectAt:#valueOfChangeText put:(holder :=  ValueHolder new).
    ].
    ^ holder
!

valueOfFilter
    "returns the value holder for the string of the filter"

    |holder|
    (holder := builder bindingAt:#valueOfFilter) isNil ifTrue:[
	builder aspectAt:#valueOfFilter put:(holder :=  ValueHolder new).
	holder addDependent: self
    ].
    ^ holder
!

valueOfHavingChangeSelection
    "returns whether the selected change can be applied as value holder"

    |holder|
    (holder := builder bindingAt:#valueOfHavingChangeSelection) isNil ifTrue:[
	builder aspectAt:#valueOfHavingChangeSelection put:(holder :=  false asValue).
    ].
    ^ holder
!

valueOfHavingSelection
    "returns whether a change is selected as value holder"

    |holder|
    (holder := builder bindingAt:#valueOfHavingSelection) isNil ifTrue:[
	builder aspectAt:#valueOfHavingSelection put:(holder :=  false asValue).
    ].
    ^ holder
!

valueOfNotReading
    "returns whether it is not reading or compressing as value holder"

    |holder|
    (holder := builder bindingAt:#valueOfReading) isNil ifTrue:[
	builder aspectAt:#valueOfReading put:(holder :=  true asValue).
    ].
    ^ holder
!

valueOfNotSaving
    "returns whether it is not saving as value holder"

    |holder|
    (holder := builder bindingAt:#valueOfNotSaving) isNil ifTrue:[
	builder aspectAt:#valueOfNotSaving put:(holder :=  true asValue).
    ].
    ^ holder
!

valueOfReadProgress
    "returns the stage of reading or compressing as value holder"

    |holder|
    (holder := builder bindingAt:#valueOfReadProgress) isNil ifTrue:[
	builder aspectAt:#valueOfReadProgress put:(holder :=  ValueHolder with: 0).
    ].
    ^ holder
! !

!NewChangesBrowser methodsFor:'callbacks'!

changeSelected: lineNr
    "fetches the source code of the change and shows it in the codeView"

    |aStream sawExcla chunk selectedRow changeNr|

    lineNr == 0 ifTrue: [^nil].
    changeNr := changes indexOf: (self listOfChanges at: lineNr).
    aStream := self streamForChange: (changes at: changeNr).
    aStream isNil ifTrue:[^ self].
    sawExcla := aStream peekFor:(aStream class chunkSeparator).
    chunk := aStream nextChunk.
    sawExcla ifTrue:[
	chunk := aStream nextChunk
    ].
    aStream close.
    self valueOfChangeText value:chunk.

    self updateChannels
! !

!NewChangesBrowser methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "evaluates the filterCompletionBlock after returning the filter string"

    super update:something with:aParameter from:changedObject.

    changedObject == self valueOfFilter ifTrue:[
        filterCompletionBlock value: changedObject value.
        self listOfChanges size > 0 ifTrue: [self addToHistory: changedObject value -> #doFilter:]
    ]
!

updateChannels
    "updates my channels"

    |change|
    (change := self selectionOfChange value) notNil
    ifTrue:
    [
	self valueOfHavingSelection value: true.
	self valueOfHavingChangeSelection value:
	    ((change type = 'method') or: [(change type = 'class')])
    ]
    ifFalse:
    [
	self valueOfHavingSelection value: false.
	self valueOfHavingChangeSelection value: false
    ]






! !

!NewChangesBrowser methodsFor:'compiler interface'!

correctableSelectorWarning:aText position:smallInteger1 to:smallInteger2 from:aByteCodeCompiler

    ^false

    "Created: / 16-11-2010 / 16:04:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

correctableWarning:aText position:smallInteger1 to:smallInteger2 from:aByteCodeCompiler

    ^false

    "Created: / 16-11-2010 / 16:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wantChangeLog
    "sent by the compiler to ask if a changeLog entry should
     be written. Return false here."

    ^ false


! !

!NewChangesBrowser methodsFor:'error handling'!

correctableError:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifys us of an error - this should really not happen since
     changes ought to be correct (did someone edit the changes file ??).
     Show the bad change in the codeView and let codeView hilight the error;
     no corrections allowed here therefore return false"

    self error:aString position:relPos to:relEndPos from:aCompiler.
    ^ false
!

error:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifys us of an error - this should really not happen since
     changes ought to be correct (did someone edit the changes file ??).
     Show the bad change in the codeView and let codeView hilight the error"

    |action|

    (skipSignal notNil) ifTrue:[

        self changeTextEditor highlightingErrorPosition:relPos to:relEndPos do:[
            |box|

            "
             start dialog - make certain cleanup is done
            "
            action := OptionBox
                          request:aString
                          label:'Error'
                          image:(WarningBox iconBitmap)
                          buttonLabels:#('cancel' 'skip' 'continue')
                          values:#(#abort #skip #continue)
                          default:#continue.
        ].

        action == #abort ifTrue:[
            Object abortSignal raise.
            ^ false
        ].
        action == #skip ifTrue:[
            skipSignal raise.
            ^ false
        ].
        ^  false
    ].
    ^self changeTextEditor error:aString position:relPos to:relEndPos from:aCompiler
!

unusedVariableWarning:aText position:smallInteger1 to:smallInteger2 from:aByteCodeCompiler

    ^false

    "Created: / 24-02-2011 / 22:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifys us of a warning - ignore it"

    ^ self

! !

!NewChangesBrowser methodsFor:'help'!

defaultInfoLabel
    "returns the default label for the info bar"

    changeFileName asFilename exists ifTrue: [^changeFileName].
    ^'No change file name defined.'



!

openDocumentation
   self openHTMLDocument:'tools/cbrowser/TOP.html'.
! !

!NewChangesBrowser methodsFor:'initialization'!

initialize
    "initializes the instance variables"

    super initialize.

    changes           := List new.
    self changeFileName: ObjectMemory nameForChanges.
    AutoUpdate        := AutoUpdate ? false.
    PrivateAsSeparate := PrivateAsSeparate ? false.

    ObjectMemory addDependent:self.
! !

!NewChangesBrowser methodsFor:'menu modes'!

autoUpdateMode
    "returns whether autoUpdate is on/off"

    ^AutoUpdate

!

autoUpdateMode: aMode
    "sets the autoUpdate to aMode"

    AutoUpdate := aMode

!

privateAsSeparate
    "returns whether private classes are handled as separate changes"

    ^PrivateAsSeparate

!

privateAsSeparate: aMode
    "sets the PrivateAsSeparate to aMode"

    PrivateAsSeparate := aMode

! !

!NewChangesBrowser methodsFor:'private'!

applyChange:aChange
    "applies aChange"

    |aStream nm applyAction changeNr|

    aStream := self streamForChange:aChange.
    aStream isNil ifTrue:[^ self].

    nm := self classNameOfChange:aChange.
    nm notNil ifTrue:[
        |cls|

        cls := Smalltalk at:(nm asSymbol) ifAbsent:[].
        cls notNil ifTrue:[
            cls isLoaded ifFalse:[
                cls autoload
            ]
        ]
    ].

    applyAction := [
        |sig|

        (skipSignal notNil) ifTrue:[
            sig := skipSignal
        ] ifFalse:[
            sig := Object abortSignal
        ].
        sig catch:[
            |reader doItChunk methodsForChunk|

            "/ a followup methodsFor: chunk...
            aChange followUp ifTrue:[
                methodsForChunk := aChange chunk.
            ] ifFalse:[
                doItChunk := aStream nextChunk.   "/ an empty chunk sometimes...
                doItChunk notEmpty ifTrue:[
                    Compiler evaluate:doItChunk notifying:self.
                ] ifFalse:[
                    methodsForChunk := aStream nextChunk.   "/ the real one
                ]
            ].
            methodsForChunk notNil ifTrue:[
                Class methodRedefinitionSignal handle:[:ex |
                    ex proceedWith:#keep
                ] do:[
                    reader := Compiler evaluate:methodsForChunk notifying:self.
                    reader fileInFrom:aStream notifying:self passChunk:false single:true.
                ]
            ]
        ].
    ].

    "/
    "/ if I am showing the changes file, don't update it
    "/
    changeFileName asFilename pathName = ObjectMemory nameForChanges asFilename pathName ifTrue:[
        Class withoutUpdatingChangesDo:applyAction
    ] ifFalse:[
        applyAction value
    ].
    aStream close

    "Modified: / 8.9.1998 / 12:48:01 / cg"
!

autoSelectChange:aChange
    "selects aChange"

    self class autoSelectNext ifTrue:[
	((self listOfChanges indexOf: aChange) <= self listOfChanges size) ifTrue:[
	    self selectionOfChange value: aChange.
	    self changeSelected:(self listOfChanges indexOf: aChange).
	    self updateChannels.
	    ^ self
	]
    ].
    self updateChannels.
    self unselectChange

!

autoSelectLast
    "selects the last change"

    self autoSelectChange: (self listOfChanges at: self listOfChanges size ifAbsent: nil).
    self updateChannels.

!

autoSelectOrEnd:aChange
    "selects aChange or the last"

    |last|

    last := self listOfChanges size.
    aChange notNil ifTrue:[
	self autoSelectChange:aChange
    ] ifFalse:[
	self selectionOfChange value: (self listOfChanges at: last ifAbsent: nil).
	self changeSelected: last
    ].
    self updateChannels
!

changeColumn: aColumnId add: addOrRemove
    "adds or removes a attribute column to the table"

    |newListOfChangeColumns|

    newListOfChangeColumns := self listOfChangeColumns asOrderedCollection.
    addOrRemove ifTrue:[
        newListOfChangeColumns add:
            ((self class tableColumnsForChangeAttributes
                collect: [:i| i decodeAsLiteralArray])
                    detect: [:column| column id = aColumnId])
    ] ifFalse:[
        newListOfChangeColumns remove:
            (self listOfChangeColumns detect: [:column| column id = aColumnId] ifNone: nil) ifAbsent: nil
    ].
    self listOfChangeColumns contents: newListOfChangeColumns.
    self autoSelectLast

    "Modified: / 19.5.1998 / 20:32:53 / cg"
!

changeFileName:aFileName
    "sets the name of the file with the changes"

    changeFileName := aFileName asFilename name.
"/ (Filename currentDirectory asAbsoluteFilename construct: aFileName) name.

    "Modified: / 17.10.1998 / 14:43:01 / cg"
!

checkClassIsLoaded:aClass
    "returns true if aClass is loaded"

    |cls|

    cls := aClass theNonMetaclass.
    cls isLoaded ifFalse:[
        (self confirm:(cls name , ' is an autoloaded class.\I can only compare the methods texts if its loaded first.\\Load the class first ?') withCRs)
        ifTrue:[
            cls autoload
        ]
    ].
    ^ cls isLoaded

    "Modified: / 18-08-2011 / 09:51:39 / cg"
!

checkIfFileHasChanged
    "checks if changes file has changed"

    |f info|

    Processor removeTimedBlock:autoUpdateBlock.
    f := changeFileName asFilename.
    (info := f info) isNil ifTrue:[
        self newLabel:'unaccessible'
    ] ifFalse:[
        (info modificationTime) > changeFileTimestamp ifTrue:[
            self newLabel:'outdated'.
            AutoUpdate ifTrue:[
                self doReload
            ]
        ] ifFalse:[
            self newLabel:''
        ]
    ].
    Processor addTimedBlock:autoUpdateBlock afterSeconds:5.
!

classNameAndClassFromNode:aTreeNode
    |rcvr className changeClass|

    rcvr := aTreeNode receiver.
    rcvr isUnaryMessage ifTrue:[
        self assert:(rcvr selector = 'class').

        className := rcvr receiver name.
        SourceCodeManagerError 
            handle:[:ex | ]
            do:[ changeClass := (Smalltalk classNamed:className) class ].
        className := className , ' class'.
        ^ className -> changeClass
    ].

    (rcvr type == #Nil) ifTrue:[
        ^ 'nil' -> nil
    ].

    className := rcvr name.
    SourceCodeManagerError 
        handle:[:ex | ]
        do:[ changeClass := Smalltalk classNamed:className ].
    ^ className -> changeClass

    "Created: / 18-08-2011 / 09:38:37 / cg"
!

classNameOfChange:aChange
    "returns the classname of aChange
     (for classChanges (i.e. xxx class), the non-metaClassName (i.e. xxx) is returned)"

    |name|

    name := self fullClassNameOfChange:aChange.
    name isNil ifTrue:[^ nil].
    (name endsWith:' class') ifTrue:[
        ^ name copyButLast:6
    ].
    ^ name
!

compareChange:aChange
    "compares aChange with the current version"

    |aStream chunk sawExcla parseTree thisClass cat oldSource newSource
     parser sel oldMethod outcome showDiff d t1 t2 selector isLoaded
     method beep|

    aStream := self streamForChange:aChange.
    aStream isNil ifTrue:[^ self].

    showDiff := false.

    aChange followUp ifFalse:[
	sawExcla := aStream peekFor:(aStream class chunkSeparator).
	chunk := aStream nextChunk.
    ] ifTrue:[
	chunk := aChange chunk.
	sawExcla := true.
    ].

    beep := false.
    sawExcla ifFalse:[
	outcome := 'Cannot compare this change\(i.e. this is not a method change)!!'.

	parseTree := Parser parseExpression:chunk.
	(parseTree notNil and:[parseTree isMessage]) ifTrue:[
	    ((selector := parseTree selector) == #removeSelector:) ifTrue:[
		thisClass := (parseTree receiver evaluate).
		thisClass isBehavior ifTrue:[
		    (self checkClassIsLoaded:thisClass) ifTrue:[
			selector := (parseTree arg1 evaluate).
			(thisClass includesSelector:selector) ifTrue:[
			    outcome := 'Change removes the #' , selector , ' method from ' , thisClass name.
			] ifFalse:[
			    outcome := 'Change has no effect\(there is no method for #' , selector , ' in ' , thisClass name , ')'
			]
		    ] ifFalse:[
			beep := true.
			outcome := 'Cannot compare this change (compare requires class to be loaded)!!'.
		    ]
		]
	    ].
	    selector == #category: ifTrue:[
		parseTree receiver isMessage ifTrue:[
		    parseTree receiver selector == #compiledMethodAt: ifTrue:[
			(method := parseTree receiver evaluate) isMethod ifTrue:[
			    method category = parseTree arg1 evaluate ifTrue:[
				outcome := 'Change has no effect\(same category)'.
			    ] ifFalse:[
				outcome := 'Category is different (''' , method category , ''' vs. ''' , parseTree arg1 evaluate , ''')'
			    ]
			] ifFalse:[
			    beep := true.
			    outcome := 'There is no such method!!'
			]
		    ]
		]
	    ]
	]
    ] ifTrue:[
	parseTree := Parser parseExpression:chunk.
	(parseTree notNil
	 and:[parseTree ~~ #Error
	 and:[parseTree isMessage]]) ifTrue:[
	    (parseTree selector == #methodsFor:) ifTrue:[
		thisClass := (parseTree receiver evaluate).
		thisClass isBehavior ifTrue:[
		    (isLoaded := self checkClassIsLoaded:thisClass) ifFalse:[
			outcome := 'Cannot compare this change\(compare requires class to be loaded)!!'.
		    ].

		    cat := parseTree arg1 evaluate.
		    newSource := aStream nextChunk.

		    parser := Parser parseMethod:newSource in:thisClass.
		    (parser notNil and:[parser ~~ #Error]) ifTrue:[
			sel := parser selector.
			oldMethod := thisClass compiledMethodAt:sel.
			oldMethod notNil ifTrue:[
			    (oldMethod category = cat) ifFalse:[
				Transcript showCR:'Category changed.'.
			    ].
			    oldSource := oldMethod source.
			    (oldSource = newSource) ifTrue:[
				outcome := 'Same source.'
			    ] ifFalse:[
				oldSource isNil ifTrue:[
				    beep := true.
				    outcome := 'No source for compare.'
				] ifFalse:[
				    "/
				    "/ compare for tabulator <-> space changes
				    "/ before showing diff...
				    "/
				    t1 := oldSource asCollectionOfLines collect:[:s | s withTabsExpanded].
				    t2 := newSource asCollectionOfLines collect:[:s | s withTabsExpanded].
				    t1 = t2 ifTrue:[
					outcome := 'Same source.'
				    ] ifFalse:[
					outcome := 'Source changed!!'.
					showDiff := true.

					"/
					"/ check if only historyLine diffs
					"/
					(HistoryManager notNil
					and:[HistoryManager isActive]) ifTrue:[
					    (HistoryManager withoutHistoryLines:newSource)
					    =
					    (HistoryManager withoutHistoryLines:oldSource)
					    ifTrue:[
						outcome := 'Same source (history only).'.
						showDiff := false.
					    ]
					].
				    ]
				]
			    ]
			] ifFalse:[
			    isLoaded ifTrue:[
				beep := true.
				outcome := 'Method does not exist!!'
			    ]
			]
		    ] ifFalse:[
			outcome := 'Change unparsable!!'
		    ].
		    (showDiff and:[oldSource notNil and:[newSource notNil]]) ifTrue:[
			d := DiffTextView
				openOn:oldSource label:'Current version (in image)'
				and:newSource label:'Change version'.
			d label:'method differences'.
		    ]
		] ifFalse:[
		    beep := true.
		    outcome := 'Class does not exist!!'
		]
	    ] ifFalse:[
		beep := true.
		outcome := 'Not comparable!!'
	    ]
	] ifFalse:[
	    beep := true.
	    outcome := 'Not comparable!!'
	]
    ].
    aStream close.
    showDiff ifFalse:[
	beep ifTrue:[
	    self warn:outcome withCRs.
	] ifFalse:[
	    self information:outcome withCRs.
	]
    ]
!

compressForClass:aClassNameOrNil
    "compresses the list of changes;
     this replaces multiple method-changes by the last (i.e. the most recent) change.
     If the class argument is nil, compress for all classes.
     otherwise, only changes for that class are compressed."

    |aStream searchIndex anyMore deleteSet index
     str snapshotProto snapshotPrefix snapshotNameIndex fileName|

    aStream := FileStream readonlyFileNamed:changeFileName.
    aStream isNil ifTrue:[^ self].

    aClassNameOrNil isNil ifTrue:[
	self newLabel:'compressing...'.
    ] ifFalse:[
	self newLabel:'compressing for ' , aClassNameOrNil.
    ].

    CompressSnapshotInfo == true ifTrue:[
	"
	 get a prototype snapshot record (to be independent of
	 the actual format ..
	"
	str := WriteStream on:String new.
	Class addChangeRecordForSnapshot:'foo' to:str.
	snapshotProto := str contents.
	snapshotPrefix := snapshotProto copyTo:10.
	snapshotNameIndex := snapshotProto findString:'foo'.
    ].

    self valueOfNotReading value: false.
    self valueOfHavingSelection value: false.
    self valueOfHavingChangeSelection value: false.
    self valueOfReadProgress value: 0.
    self readProgressIndicator raise.
    self filterLabel label: 'Comp:'; redraw.

    self withExecuteCursorDo:[
	|numChanges classes selectors types excla sawExcla
	 changeNr chunk aParseTree parseTreeChunk
	 thisClass thisSelector codeChunk codeParser
	 compressThis oldValue|

	numChanges := changes size.
	classes := Array new:numChanges.
	selectors := Array new:numChanges.
	types := Array new:numChanges.

	"starting at the end, get the change class and change selector;
	 collect all in classes / selectors"

	changeNr := numChanges.
	excla := aStream class chunkSeparator.

	[changeNr >= 1] whileTrue:[
	    oldValue := self valueOfReadProgress value.
		self valueOfReadProgress value: (100 - ((aStream position/aStream size) * 100) rounded).
		oldValue ~~ self valueOfReadProgress value
		    ifTrue: [self readProgressIndicator redrawEdges;redraw].
	    aStream position:(changes at: changeNr) position.
	    sawExcla := aStream peekFor:excla.
	    chunk := aStream nextChunk.
	    sawExcla ifTrue:[
		"optimize a bit if multiple methods for same category arrive"
		(chunk = parseTreeChunk) ifFalse:[
		    aParseTree := Parser parseExpression:chunk.
		    parseTreeChunk := chunk
		].
		(aParseTree notNil
		and:[(aParseTree ~~ #Error)
		and:[aParseTree isMessage]]) ifTrue:[
		    (aParseTree selector == #methodsFor:) ifTrue:[
			thisClass := (aParseTree receiver evaluate).
			codeChunk := aStream nextChunk.
			codeParser := Parser
					  parseMethodSpecification:codeChunk
					  in:thisClass
					  ignoreErrors:true
					  ignoreWarnings:true.
			(codeParser notNil and:[codeParser ~~ #Error]) ifTrue:[
			    selectors at:changeNr put:(codeParser selector).
			    classes at:changeNr put:thisClass.
			    types at:changeNr put:#methodsFor
			]
		    ]
		]
	    ] ifFalse:[
		aParseTree := Parser parseExpression:chunk.
		parseTreeChunk := chunk.
		(aParseTree notNil
		and:[(aParseTree ~~ #Error)
		and:[aParseTree isMessage]]) ifTrue:[
		    (aParseTree selector == #removeSelector:) ifTrue:[
			selectors at:changeNr put:(aParseTree arg1 value ).
			classes at:changeNr put:(aParseTree receiver evaluate).
			types at:changeNr put:#removeSelector
		    ]
		] ifFalse:[
		    CompressSnapshotInfo == true ifTrue:[
			(chunk startsWith:snapshotPrefix) ifTrue:[
			    str := chunk readStream position:snapshotNameIndex.
			    fileName := str upTo:(Character space).
			    "
			     kludge to allow use of match-check below
			    "
			    selectors at:changeNr put:snapshotPrefix.
			    classes at:changeNr put:fileName.
			]
		    ]
		]
	    ].
	    changeNr := changeNr - 1
	].
	aStream close.

	"for all changes, look for another class/selector occurrence later
	 in the list and, if there is one, add change number to the delete set"

	deleteSet := OrderedCollection new.
	changeNr := 1.
	[changeNr < changes size] whileTrue:[
	    thisClass := classes at:changeNr.

	    compressThis := false.
	    aClassNameOrNil isNil ifTrue:[
		compressThis := true
	    ] ifFalse:[
		"/ skipping unloaded/unknown classes
		thisClass isBehavior ifTrue:[
		    thisClass isMeta ifTrue:[
			compressThis := aClassNameOrNil = thisClass soleInstance name.
		    ] ifFalse:[
			compressThis := aClassNameOrNil = thisClass name.
			(PrivateAsSeparate not and: [thisClass isPrivate])
			    ifTrue:[compressThis := aClassNameOrNil = thisClass owningClass name]
		    ]
		 ]
	    ].

	    compressThis ifTrue:[
		thisSelector := selectors at:changeNr.
		searchIndex := changeNr.
		anyMore := true.
		[anyMore] whileTrue:[
		    searchIndex := classes indexOf:thisClass
					startingAt:(searchIndex + 1).
		    (searchIndex ~~ 0) ifTrue:[
			((selectors at:searchIndex) == thisSelector) ifTrue:[
			    thisClass notNil ifTrue:[
				deleteSet add:changeNr.
				anyMore := false
			    ]
			]
		    ] ifFalse:[
			anyMore := false
		    ]
		].
	    ].

	    changeNr := changeNr + 1
	].

	"finally delete what has been found"

	(deleteSet size > 0) ifTrue:[
	    index := deleteSet size.
	    [index > 0] whileTrue:[
		self silentDeleteChange: (changes at: (deleteSet at:index)).
		index := index - 1
	    ].
	    self setChangeList
	].
    ].
    self valueOfNotReading value: true.
    self filterField raise.
    self filterLabel label: 'Filter:'.
    self newLabel: ''
!

contractClass:className selector:selector to:maxLen
    |s l|

    s := className , ' ', selector.
    s size > maxLen ifTrue:[
	l := maxLen - 1 - selector size max:20.
	s := (className contractTo:l) , ' ' , selector.

	s size > maxLen ifTrue:[
	    l := maxLen - 1 - className size max:20.
	    s := className , ' ', (selector contractTo:l).

	    s size > maxLen ifTrue:[
		s := (className contractTo:(maxLen // 2 - 1)) , ' ' , (selector contractTo:maxLen // 2)
	    ]
	]
    ].
    ^ s

!

deleteChangesFrom:start to:stop
    "deletes a range of changes"

    self unselectChange.
    stop to:start by:-1 do:[:changeNr|
	self silentDeleteChange:(self listOfChanges at: changeNr)
    ].
    self setChangeList
!

fullClassNameOfChange:aChange
    "returns the full classname of aChange
     (for classChanges (i.e. xxx class), a string ending in ' class' is returned.
     - since parsing ascii methods is slow, keep result cached in
       changeClassNames for the next query"

    |chunk aParseTree recTree sel name arg1Tree isMeta prevMethodDefNr
     words changeStream fullParseTree ownerTree ownerName oldDollarSetting|

    aChange isNil ifTrue:[^ nil].

    "
     first look, if not already known
    "
    name := aChange className.
    name notNil ifTrue:[^ name].

    prevMethodDefNr := changes indexOf: aChange.
    [(changes at:prevMethodDefNr) followUp] whileTrue:[
	prevMethodDefNr := prevMethodDefNr - 1.
    ].

    "
     get the chunk
    "
    chunk := (changes at:prevMethodDefNr) chunk.
    chunk isNil ifTrue:[^ nil].       "mhmh - empty"

    (chunk startsWith:'''---') ifTrue:[
	words := chunk asCollectionOfWords.
	words size > 2 ifTrue:[
	    (words at:2) = 'checkin' ifTrue:[
		name := words at:3.
		aChange className: name.
		^ name
	    ]
	].
    ].

    "/ fix it - otherwise, it cannot be parsed
    (chunk endsWith:'primitiveDefinitions:') ifTrue:[
	chunk := chunk , ''''''
    ].
    (chunk endsWith:'primitiveFunctions:') ifTrue:[
	chunk := chunk , ''''''
    ].
    (chunk endsWith:'primitiveVariables:') ifTrue:[
	chunk := chunk , ''''''
    ].

    "
     use parser to construct a parseTree
    "
    oldDollarSetting := Parser allowDollarInIdentifier.
    [
	Parser allowDollarInIdentifier:true.
	aParseTree := Parser parseExpression:chunk.
    ] valueNowOrOnUnwindDo:[
	Parser allowDollarInIdentifier:oldDollarSetting
    ].

    (aParseTree isNil or:[aParseTree == #Error]) ifTrue:[
	^ nil        "seems strange... (could be a comment)"
    ].
    aParseTree isMessage ifFalse:[
	^ nil        "very strange... (whats that ?)"
    ].

    "
     ask parser for selector
    "
    sel := aParseTree selector.
    recTree := aParseTree receiver.

    "
     is it a method-change, methodRemove or comment-change ?
    "
    (#(#'methodsFor:'
       #'privateMethodsFor:'
       #'protectedMethodsFor:'
       #'publicMethodsFor:'
       #'removeSelector:'
       #'comment:'
       #'primitiveDefinitions:'
       #'primitiveFunctions:'
       #'primitiveVariables:'
       #'renameCategory:to:'
       #'instanceVariableNames:'
    ) includes:sel) ifTrue:[
	"
	 yes, the className is the receiver
	"
	(recTree notNil and:[recTree ~~ #Error]) ifTrue:[
	    isMeta := false.
	    recTree isUnaryMessage ifTrue:[
		(recTree selector ~~ #class) ifTrue:[^ nil].
		"id class methodsFor:..."
		recTree := recTree receiver.
		isMeta := true.
	    ].
	    recTree isPrimary ifTrue:[
		name := recTree name.
		isMeta ifTrue:[
		    name := name , ' class'.
		].
		aChange className: name.
		^ name
	    ]
	].
	"more strange things"
	^ nil
    ].

    "
     is it a change in a class-description ?
    "
    (('subclass:*' match:sel)
    or:[('variable*subclass:*' match:sel)]) ifTrue:[
	"/ must parse the full changes text, to get
	"/ privacy information.

	changeStream := self streamForChange:aChange.
	changeStream notNil ifTrue:[
	    chunk := changeStream nextChunk.
	    changeStream close.
	    fullParseTree := Parser parseExpression:chunk.
	    (fullParseTree isNil or:[fullParseTree == #Error]) ifTrue:[
		fullParseTree := nil
	    ].
	    fullParseTree isMessage ifFalse:[
		fullParseTree := nil
	    ].
	    "/ actually, the nil case cannot happen
	    fullParseTree notNil ifTrue:[
		aParseTree := fullParseTree.
		sel := aParseTree selector.
	    ].
	].

	arg1Tree := aParseTree arg1.
	(arg1Tree notNil and:[arg1Tree isConstant]) ifTrue:[
	    name := arg1Tree value asString.

	    "/ is it a private-class ?
	    ('*privateIn:' match:sel) ifTrue:[
		ownerTree := aParseTree args last.
		ownerName := ownerTree name asString.
		name := ownerName , '::' , name
	    ].
	    aChange className: name.
	    ^ name
	].
	"very strange"
	^ nil
    ].

    "
     is it a class remove ?
    "
    (sel == #removeClass:) ifTrue:[
	(recTree notNil
	and:[recTree ~~ #Error
	and:[recTree isPrimary
	and:[recTree name = 'Smalltalk']]]) ifTrue:[
	    arg1Tree := aParseTree arg1.
	    (arg1Tree notNil and:[arg1Tree isPrimary]) ifTrue:[
		name := arg1Tree name.
		aChange className: name.
		^ name
	    ].
	]
    ].

    "
     is it a method category change ?
    "
    ((sel == #category:)
    or:[sel == #privacy:]) ifTrue:[
	(recTree notNil
	and:[recTree ~~ #Error
	and:[recTree isMessage
	and:[recTree selector == #compiledMethodAt:]]]) ifTrue:[
	    isMeta := false.
	    recTree := recTree receiver.
	    recTree isUnaryMessage ifTrue:[
		(recTree selector ~~ #class) ifTrue:[^ nil].
		"id class "
		recTree := recTree receiver
	    ].
	    recTree isPrimary ifTrue:[
		isMeta ifTrue:[
		    name := name , ' class'.
		].
		name := recTree name.
		aChange className: name.
		^ name
	    ]
	]
    ].
    ^ nil
!

newLabel:how
    "sets the label"

    how size = 0 ifTrue: [^self window label:self class label].
    self window label:self class label, ' (', how, ')'
!

readChangesFileInBackground:inBackground
    "reads the changes file, creates a list of header-lines (changeChunks)
     and a list of chunk-positions (changePositions).
     Starting with 2.10.3, the entries are multi-col entries;
     the cols are:                                                    
        1   delta (only if comparing)
                '+' -> new method (w.r.t. current state)
                '-' -> removed method (w.r.t. current state)
                '?' -> class does not exist currently
                '=' -> change is same as current methods source
        2   class/selector
        3   type of change
                doit
                method
                category change
        4   timestamp

     since comparing slows down startup time, it is now disabled by
     default and can be enabled via a toggle."

    |aStream maxLen i f v|

    self valueOfNotReading value: false.
    self valueOfHavingSelection value: false.
    self valueOfHavingChangeSelection value: false.

    editingClassSource := false.

    maxLen := 60.

    f := changeFileName asFilename.
    aStream :=  f readStream.
    aStream isNil ifTrue:[^ nil].

    self newLabel:(resources string:'updating...').

    i := f info.
    changeFileTimestamp := i modificationTime.

    self valueOfReadProgress value: 0.
    v := self readProgressIndicator.
    v notNil ifTrue:[v raise].
    v := self filterLabel.
    v notNil ifTrue:[v label: 'Read:'; redraw].

    self withReadCursorDo:[
        |myProcess myPriority|

        "
         this is a time consuming operation (especially, if reading an
         NFS-mounted directory; therefore lower my priority...
        "
        inBackground ifTrue:[
            myProcess := Processor activeProcess.
            myPriority := myProcess priority.
            myProcess priority:(Processor userBackgroundPriority).
        ].

        [
            |excla timeStampInfo lastChange|

            excla := aStream class chunkSeparator.

            [aStream atEnd] whileFalse:[
                |change changeDelta changeString changeType changeCategory
                 line s l classAndName changeClass sawExcla category className selector
                 chunkText chunkPos sel oldValue|

                change := Change new.
                "
                 get a chunk (separated by excla)
                "
                oldValue := self valueOfReadProgress value.
                self valueOfReadProgress value: (((aStream position/aStream size) * 100) rounded).
"/                oldValue ~~ self valueOfReadProgress value
"/                    ifTrue: [self readProgressIndicator redrawEdges;redraw].

                aStream skipSeparators.
                chunkPos := aStream position.

                sawExcla := aStream peekFor:excla.
                chunkText := aStream nextChunk.
                chunkText notNil ifTrue:[
                    |index headerLine cls|

                    (chunkText startsWith:'''---- timestamp ') ifTrue:[
                        timeStampInfo := (chunkText copyFrom:16 to:(chunkText size - 6)) withoutSpaces.
                    ] ifFalse:[

                        "
                         only first line is saved in changeChunks...
                        "
                        index := chunkText indexOf:(Character cr).
                        (index ~~ 0) ifTrue:[
                            chunkText := chunkText copyTo:(index - 1).

                            "take care for comment changes - must still be a
                             valid expression for classNameOfChange: to work"

                            (chunkText endsWith:'comment:''') ifTrue:[
                                chunkText := chunkText , '...'''
                            ].
                            (chunkText endsWith:'primitiveDefinitions:''') ifTrue:[
                                sel := 'primitiveDefinitions:'.
                                chunkText := chunkText copyButLast:1
                            ].
                            (chunkText endsWith:'primitiveVariables:''') ifTrue:[
                                sel := 'primitiveVariables:'.
                                chunkText := chunkText copyButLast:1
                            ].
                            (chunkText endsWith:'primitiveFunctions:''') ifTrue:[
                                sel := 'primitiveFunctions:'.
                                chunkText := chunkText copyButLast:1
                            ].
                        ].

                        change chunk: chunkText.
                        change position: chunkPos.
                        lastChange notNil ifTrue: [lastChange lastPosition: chunkPos - 1].
                        lastChange := change.
                        change timeStamp: timeStampInfo.
                        change followUp: false.
                        headerLine := nil.
                        changeDelta := ' '.

                        sawExcla ifFalse:[
                            (chunkText startsWith:'''---- snap') ifTrue:[
                                changeType := ''.
                                headerLine := chunkText.
                                changeString := (chunkText contractTo:maxLen).
                                timeStampInfo := nil.
                            ] ifFalse:[

                                |p cls|

                                headerLine := chunkText , ' (doIt)'.

                                "
                                 first, assume doIt - then lets have a more detailed look...
                                "
                                ((chunkText startsWith:'''---- file')
                                or:[(chunkText startsWith:'''---- check')]) ifTrue:[
                                    changeType := ''.
                                    timeStampInfo := nil.
                                ] ifFalse:[
                                    changeType := 'doIt'.
                                ].
                                changeString := (chunkText contractTo:maxLen).

                                p := Parser parseExpression:chunkText inNameSpace:Smalltalk.
                                (p notNil
                                 and:[p ~~ #Error
                                 and:[p isMessage]]) ifTrue:[
                                    sel := p selector.
                                ].
                                (sel == #removeSelector:) ifTrue:[
                                    classAndName := self classNameAndClassFromNode:p.
                                    cls := classAndName key. changeClass := classAndName value.
                                    sel := (p args at:1) evaluate.

                                    DeltaInfoColumn ifTrue:[
                                        (changeClass isNil or:[changeClass isLoaded not]) ifTrue:[
                                            changeDelta := '?'
                                        ] ifFalse:[
                                            (changeClass implements:sel asSymbol) ifTrue:[
                                                changeDelta := '-'.
                                            ]
                                        ]
                                    ].
                                    changeType := 'remove'.
                                    changeString := self contractClass:cls selector:sel to:maxLen.
                                    className := cls.
                                    selector := sel.
                                ].
                                (p notNil and:[p ~~ #Error
                                and:[p isMessage
                                and:[p receiver isMessage
                                and:[p receiver selector == #compiledMethodAt:]]]]) ifTrue:[
                                    classAndName := self classNameAndClassFromNode:p receiver.
                                    cls := classAndName key. changeClass := classAndName value.
                                    (sel == #category:) ifTrue:[
                                        sel := (p receiver args at:1) evaluate.
                                        changeType := '(category change)'.
                                        changeString := self contractClass:cls selector:sel to:maxLen.
                                    ].
                                    (sel == #privacy:) ifTrue:[
                                        sel := (p receiver args at:1) evaluate.
                                        changeType := 'privacy change'.
                                        changeString := self contractClass:cls selector:sel to:maxLen.
                                    ].
                                    className := cls.
                                    selector := sel.
                                ].
                                (#(#'subclass:'
                                  #'variableSubclass:'
                                  #'variableByteSubclass:'
                                  #'variableWordSubclass:'
                                  #'variableLongSubclass:'
                                  #'variableFloatSubclass:'
                                  #'variableDoubleSubclass:'
                                  #'primitiveDefinitions:'
                                  #'primitiveFunctions:'
                                  #'primitiveVariables:'
                                 ) includes:sel) ifTrue:[
                                    changeType := 'class definition'.
                                ].
                            ]
                        ] ifTrue:[
                            |done first p className cls text methodPos|

                            "
                             method definitions actually consist of
                             two (or more) chunks; skip next chunk(s)
                             up to an empty one.
                             The system only writes one chunk,
                             and we cannot handle more in this ChangesBrowser....
                            "
                            className := nil.
                            p := Parser parseExpression:chunkText inNameSpace:Smalltalk.

                            (p notNil and:[p ~~ #Error]) ifTrue:[
                                sel := p selector.
                                (sel == #methodsFor:) ifTrue:[
                                    classAndName := self classNameAndClassFromNode:p.
                                    className := classAndName key. changeClass := classAndName value.
                                    category := (p args at:1) evaluate.
                                ].
                            ].

                            done := false.
                            first := true.
                            [done] whileFalse:[

                                changeDelta := ' '.
                                methodPos := aStream position.

                                text := aStream nextChunk.
                                text isNil ifTrue:[
                                    done := true
                                ] ifFalse:[
                                    done := text isEmpty
                                ].
                                done ifFalse:[
                                    first ifFalse:[
                                        change := Change new.
                                        change chunk: chunkText.
                                        change string:changeString.
                                        change position: methodPos.
                                        change className: className.
                                        lastChange notNil ifTrue: [lastChange lastPosition: methodPos - 1].
                                        lastChange := change.
                                        change timeStamp: timeStampInfo.
                                        change followUp: true.
                                        editingClassSource := true.
                                    ].

                                    first := false.
                                    "
                                     try to find the selector
                                    "
                                    sel := nil.
                                    className notNil ifTrue:[
                                        p := Parser
                                                 parseMethodSpecification:text
                                                 in:nil
                                                 ignoreErrors:true
                                                 ignoreWarnings:true.
                                        (p notNil and:[p ~~ #Error]) ifTrue:[
                                            sel := p selector.
                                        ]
                                    ].

                                    sel isNil ifTrue:[
                                        changeString := (chunkText contractTo:maxLen).
                                        changeType := 'change'.
                                        headerLine := chunkText , ' (change)'.
                                    ] ifFalse:[
                                        changeString :=  self contractClass:className selector:sel to:maxLen.
                                        changeType := 'method definition'.
                                        changeCategory := category.
                                        headerLine := className , ' ' , sel , ' ' , '(change category: ''' , category , ''')'.
                                        change selector:sel.
                                    ].

                                    DeltaInfoColumn ifTrue:[
                                        changeClass isNil ifFalse:[
                                            cls := changeClass theNonMetaclass
                                        ].

                                        (changeClass isNil or:[cls isLoaded not]) ifTrue:[
                                            changeDelta := '?'
                                        ] ifFalse:[
                                            (changeClass implements:sel asSymbol) ifFalse:[
                                                changeDelta := '+'.
                                            ] ifTrue:[
                                                |m currentText t1 t2|

                                                m := changeClass compiledMethodAt:sel asSymbol.
                                                currentText := m source.
                                                currentText notNil ifTrue:[
                                                    text asString = currentText asString ifTrue:[
                                                        changeDelta := '='
                                                    ] ifFalse:[
                                                        t1 := currentText asCollectionOfLines collect:[:s | s withTabsExpanded].
                                                        t2 := text asCollectionOfLines collect:[:s | s withTabsExpanded].
                                                        t1 = t2 ifTrue:[
                                                            changeDelta := '='
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    ].
                                    change delta:changeDelta.
                                    change string:changeString.
                                    change type:changeType.
                                    change category: changeCategory.
                                    change timeStamp:timeStampInfo.
                                    changes add:change.
                                ].
                                changeString := nil.
                                headerLine := nil.

                            ]
                        ].
                        changeString notNil ifTrue:[
                            change delta:changeDelta.
                            change string:changeString.
                            change type:changeType.
                            change timeStamp:timeStampInfo.
                            changes add:change.

                        ] ifFalse:[
                            headerLine notNil ifTrue:[
                                changes add: change.
                            ]
                        ]
                    ]
                ].
                change lastPosition: aStream position.
            ].
            modified := false.

        ] valueNowOrOnUnwindDo:[
            aStream close.
            inBackground ifTrue:[myProcess priority:myPriority].
        ].
    ].
    changes removeLast.
    self setChangeList.
    self valueOfNotReading value: true.
    self filterField raise.
    self filterLabel label: 'Filter:'.

    self checkIfFileHasChanged.

    "Modified: / 16-11-2010 / 15:52:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-08-2011 / 09:45:23 / cg"
!

selectorOfMethodChange:aChange
    "returns the selector of the method change, or nil if it is not a method change"

    |source parser sel|

    source := self sourceOfMethodChange:aChange.
    source isNil ifTrue:[^ nil].

    parser := Parser
		parseMethod:source
		in:nil
		ignoreErrors:true
		ignoreWarnings:true.

    (parser notNil and:[parser ~~ #Error]) ifTrue:[
	sel := parser selector.
    ].
    ^ sel
!

setChangeList
    "sets the list of changes into the list for the table by evaluating filterCompletionBlock"

    self unselectChange.
    filterCompletionBlock value: self valueOfFilter value.
!

silentDeleteChange:aChange
    "delete aChange do not update changeListView"

    modified := true.

    changes remove:aChange
!

silentDeleteChangesFor:aClassName from:start to:stop
    "deletes changes for aChange in the range [start,stop]
     and returns the number of the deleted changes"

    |index numDeleted clsName|

    numDeleted := 0.
    index := stop.
    [index >= start] whileTrue:
    [
	((clsName := self classNameOfChange:(self listOfChanges at: index)) notNil and:
	[(clsName = aClassName or: [PrivateAsSeparate not and: [(clsName upTo: $:) = aClassName]])])
	ifTrue:
	[
	    self silentDeleteChange:(self listOfChanges at: index).
	    numDeleted := numDeleted + 1.
	].
	index := index - 1
    ].
    ^ numDeleted
!

sourceOfMethodChange:aChange
    "returns the source code of the method change, or nil if it is not a method change."

    |aStream chunk sawExcla parseTree sourceChunk|

    aStream := self streamForChange:aChange.
    aStream isNil ifTrue:[^ nil].

    aChange followUp ifFalse:[
	sawExcla := aStream peekFor:(aStream class chunkSeparator).
	chunk := aStream nextChunk.
    ] ifTrue:[
	chunk := aChange chunk.
	sawExcla := true.
    ].

    sawExcla ifTrue:[
	parseTree := Parser parseExpression:chunk.
	(parseTree notNil and:[parseTree isMessage]) ifTrue:[
	    (parseTree selector == #methodsFor:) ifTrue:[
		sourceChunk := aStream nextChunk.
	    ]
	].
    ].
    aStream close.
    ^ sourceChunk
!

streamForChange:aChange
    "returns the stream for aChange"

    |aStream|

    aStream := FileStream readonlyFileNamed:changeFileName.
    aStream isNil ifTrue:[^ nil].
    aStream position:aChange position.
    ^ aStream

!

unselectChange
    "unselects the current change"

    self selectionOfChange value: nil.
    self valueOfChangeText value: nil

!

withSelectedChangeDo:aBlock
    "just a helper, check for a selected change and evaluate aBlock
     with busy cursor"

    |change|

    (change := self selectionOfChange value) notNil
    ifTrue:[
	self withExecuteCursorDo:[aBlock value:change]
    ]
! !

!NewChangesBrowser methodsFor:'startup & release'!

closeRequest
    "asks for saving before closing"

    self valueOfNotSaving value ifFalse: [^ self].

    modified == true ifTrue:[
        (OptionBox
              request:(resources string:'Change list was modified. Exit anyway?') withCRs
              label:'Changes Browser'
              image:(WarningBox iconBitmap)
              buttonLabels:(resources array:#('Cancel' 'Discard Modifications and Exit'))
              values:#(abort ignore)
              default:#save
        ) == #abort ifTrue:[^ self].
    ].
    super closeRequest

    "Modified: / 20-05-1998 / 03:53:47 / cg"
    "Modified: / 08-04-2011 / 10:22:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postOpenWith:aBuilder
    "starts reading the changes from the file and
     builds entryCompletionBlock for the filterField before opening"

    super postOpenWith:aBuilder.

    builder namedComponents do:
    [:aView|
        aView allSubViewsDo:
        [:v|
            v redraw
        ]
    ].

    autoUpdateBlock := [self checkIfFileHasChanged].
    Processor addTimedBlock:autoUpdateBlock afterSeconds:5.
    self updateInfoLabel.

    self filterField entryCompletionBlock:
    (filterCompletionBlock := [:value|
        |filter filters i changesCopy|
        self unselectChange.
        filter := self filterField contents.
        (filters := filter asArrayOfSubstrings) size > 0 ifTrue:[
            changesCopy := changes copy.
            i := 0.
            filters do:[:filter|
                i := i + 1.
                changesCopy contents:
                    (changesCopy select: [:row|
                        filter match: (row string asArrayOfSubstrings at: i ifAbsent: [''''])])
            ].
            self listOfChanges contents: changesCopy
        ] ifFalse:[
            self listOfChanges contents: changes
        ].
        self autoSelectLast.
    ]).

    Object errorSignal handle: [:ex |
        ex signal == HaltSignal ifTrue:[
            ex reject
        ].
        ex signal == MessageTracer breakpointSignal ifTrue:[
            ex reject
        ].
        self warn:'Error while reading changes file:\\' , ex errorString.
    ] do: [
        self readChangesFileInBackground:true
    ].

    "Modified: / 30.7.1998 / 11:37:51 / cg"
!

uninitialize
    "removes the autoUpdateBlock from the Processor and myself from the ObjectMemory"

    Processor removeTimedBlock:autoUpdateBlock.
    ObjectMemory removeDependent:self
! !

!NewChangesBrowser methodsFor:'user actions'!

doApply
    "applies the selected change"

    self withSelectedChangeDo:[:change|
	skipSignal := nil.
	self applyChange:change.
	self autoSelectChange: (self listOfChanges at: (self listOfChanges indexOf: change) + 1 ifAbsent: [^self autoSelectLast])
    ]
!

doApplyAll
    "applies all changes"

    self withExecuteCursorDo:[
	|change|
	self unselectChange.
	skipSignal isNil ifTrue:[skipSignal := Signal new].
	1 to:self listOfChanges size do:[:changeNr |
	    self selectionOfChange value:(change := self listOfChanges at: changeNr).
	    self applyChange:change
	].
	self autoSelectLast
    ]

!

doApplyAllForClass
    "applies all changes having the same class like the selected one"

    self doApplyForClassToEndFrom: 1


!

doApplyForClassToEnd
    "applies all changes having the same class like the selected one from the selected to the end"

    self doApplyForClassToEndFrom: (self listOfChanges indexOf: self selectionOfChange value)
!

doApplyForClassToEndFrom: start
    "applies changes with same class like the selected one from start to end"

    self withSelectedChangeDo:[:change|
	|classNameToApply thisClassName lastChange change2|
	(classNameToApply := self classNameOfChange:change) notNil
	ifTrue:
	[
	    self unselectChange.
	    skipSignal isNil ifTrue:[skipSignal := Signal new].
	    start to:self listOfChanges size do:
	    [:changeNr|
		change2 := self listOfChanges at: changeNr.
		((thisClassName := self classNameOfChange:change2) notNil and:
		[thisClassName = classNameToApply or:
		[PrivateAsSeparate not and: [(thisClassName upTo: $:) = classNameToApply]]])
		ifTrue:
		[
		    self selectionOfChange value: change2.
		    self applyChange:change2.
		    lastChange := change2
		]
	    ].
	    self autoSelectChange:lastChange.
	]
    ]

!

doApplyFromLastSnapshot
    "applies all changes made since the last snapshot"

    self autoSelectLast.
    (self doFindSnapshot: 'last') ifTrue: [self doApplyToEnd]
!

doApplyToEnd
    "applies all changes from selected one to be end"

    self withSelectedChangeDo:[:change|
	self unselectChange.
	skipSignal isNil ifTrue:[skipSignal := Signal new].
	(self listOfChanges indexOf: change) to: self listOfChanges size do:[:changeNr|
	    self selectionOfChange value:(self listOfChanges at: changeNr).
	    self applyChange:(self listOfChanges at: changeNr)
	].
	self autoSelectChange:self listOfChanges last
    ]

!

doBrowseClass
    "opens a System Browser on the class of a change (and selector)"

    |className cls isMeta|

    className := self fullClassNameOfChange:self selectionOfChange value.
    className notNil ifTrue:[
	isMeta := false.
	(className endsWith:' class') ifTrue:[
	    className := className copyButLast:6.
	    isMeta := true.
	].
	(cls := Smalltalk classNamed:className) notNil ifTrue:[
	    isMeta ifTrue:[cls := cls class].
	    cls browserClass
		openInClass:cls
		selector:(self selectorOfMethodChange:self selectionOfChange value)
	]
    ]

    "Modified: / 26.9.2001 / 17:35:50 / cg"
!

doCompare
    "compares a change with the current system version"

    |change|

    (change := self selectionOfChange value) notNil ifTrue:[
	self withExecuteCursorDo:[self compareChange:change]
    ].
    self newLabel:''
!

doCompress
    "compresses the changes, i.e. replaces multiple changes by the last change"

    |changesSizeBefore|
    (changesSizeBefore := changes size) == 0 ifTrue: [^self warn: 'Nothing to compress!!'].
    self setChangeList.
    self unselectChange.
    self compressForClass:nil.
    self setChangeList.
    self updateInfoLabel.

    self information:
	'Compression Rate:   ', (((changesSizeBefore - changes size)/changesSizeBefore) * 100) rounded printString, '%\' withCRs,
	'Obsolete Changes: ', (changesSizeBefore - changes size) printString, ' from ', changesSizeBefore printString




!

doCompressForClass
    "compresses changes for the selected class.
     this replaces multiple method-changes by the last (i.e. the most recent) change."

    self withSelectedChangeDo:[:change|
	| classNameToCompress |

	(classNameToCompress := self classNameOfChange:change) notNil ifTrue:[
	    self compressForClass:classNameToCompress.
	    filterCompletionBlock value: self valueOfFilter value.
	    self autoSelectLast
	]
    ]

!

doDelete
    "deletes the selected change"

    |change selectionIndex|

    (change := self selectionOfChange value) notNil ifTrue:[
	selectionIndex := self listOfChanges indexOf: change.
	self unselectChange.
	self silentDeleteChange:change.
	self listOfChanges remove:change.
	self autoSelectOrEnd: (self listOfChanges at: selectionIndex ifAbsent: [nil]).
    ]
!

doDeleteAll
    "deletes all changes"

    self deleteChangesFrom:1 to: self listOfChanges size.
    self autoSelectOrEnd: nil

!

doDeleteAllForClass
    "deletes all changes having the same class like the selected one"

    self doDeleteForClassToEndFrom: 1

!

doDeleteForClassToEnd
    "deletes all changes having the same class like the selected one from the selected to the end"

    self withSelectedChangeDo:[:change|
	self doDeleteForClassToEndFrom: (self listOfChanges indexOf: change)
    ]


!

doDeleteForClassToEndFrom: start
    "deletes changes with same class like the selected one from start to end"

    self withSelectedChangeDo:[:change|
	|classNameToDelete|
	(classNameToDelete := self classNameOfChange:change) notNil ifTrue:[
	    self unselectChange.
	    self silentDeleteChangesFor:classNameToDelete
				   from:start
				     to:self listOfChanges size.
	    self setChangeList.
	    self autoSelectOrEnd: nil
	]
    ].



!

doDeleteToEnd
    "deletes all changes from selected one to be end"

    |changeNr|

    changeNr := (self listOfChanges indexOf: self selectionOfChange value).
    changeNr ~~ 0 ifTrue:[
	self deleteChangesFrom:changeNr to: self listOfChanges size.
	self unselectChange.
	self autoSelectOrEnd: nil
    ]

!

doFilter: aFilterString
    "filter the changes with aFilterString"

    self selectionOfChange value: nil.
    self valueOfFilter value: aFilterString withoutNotifying: self.
    self valueOfFilter changed.
    self autoSelectLast
!

doFilterSourceType: aFilterStringTypeString
    "filter the source changes with aFilterStringTypeString"

    self selectionOfChange value: nil.
    self listOfChanges contents: #().
    self valueOfFilter value: '' withoutNotifying: self.
    self listOfChanges contents: (changes select: [:change| change type = 'source' and: [aFilterStringTypeString match: change string]]).
    self autoSelectLast

!

doFilterType: aFilterTypeString
    "filter the changes with aFilterTypeString"

    self selectionOfChange value: nil.
    self valueOfFilter value: '' withoutNotifying: self.
    self listOfChanges contents: (changes select: [:change| change type = aFilterTypeString]).
    self autoSelectLast

!

doFindSnapshot: what
    "finds the last made snapshot and selects it. what is one of last, prvious or next"

    |snapshotNr snapshotFound|

    (self listOfChanges contains: [:change| change type = 'image']) ifFalse: [
        self warn: 'No snapshot found!!'.
        ^ false.
    ].

    self withSelectedChangeDo:[:change|
        what = 'last' ifTrue:[            
            snapshotNr := self listOfChanges size+1.
        ] ifFalse:[
            snapshotNr := self listOfChanges indexOf: change.
        ].

        snapshotFound := false.
        [snapshotNr > 0 and: [snapshotFound not]] whileTrue:[
            (what = 'last' or:[what = 'previous']) ifTrue:[
                snapshotNr := snapshotNr - 1.
                snapshotNr == 0 ifTrue: [snapshotNr := self listOfChanges size].
            ] ifFalse:[
                snapshotNr := snapshotNr + 1.
                snapshotNr > self listOfChanges size ifTrue: [snapshotNr := 1].
            ].
            (self listOfChanges at: snapshotNr ifAbsent: [^self autoSelectChange: (what = 'last' ifTrue: [self listOfChanges last] ifFalse: [self listOfChanges first])]) type = 'image'
            ifTrue:[
                snapshotFound := true.
                self autoSelectChange:(self listOfChanges at: snapshotNr)
            ]
        ]
    ].

    ^ snapshotFound
!

doLoad
    "opens a dialog for loading changes from a file"

    |fileName|
    (fileName :=
        "
        FileSelectionBrowser
            request: 'Load Changes List'
            fileName: changeFileName
            withFileFilters: #('c*'))"
        Dialog
            requestFileName:'Load Changes List'
            default: changeFileName
            pattern:'*.chg;*.st'  
        ) notNil

    ifTrue:
    [
        changeFileName := fileName.
        changes removeAll.
        self readChangesFileInBackground:true.
        self unselectChange.
        Processor addTimedBlock:autoUpdateBlock afterSeconds:5.
        self updateInfoLabel.
        self autoSelectLast
    ]

    "Modified: / 11-10-2010 / 20:35:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doReload
    "reloads the changes from the file"

    changes removeAll.
    self unselectChange.
    self readChangesFileInBackground:true.
    self autoSelectLast

!

doSave
    "write back the changes file. To avoid problems when the disk is full
     or a crash occurs while writing (well, or someone kills us),
     first write the stuff to a new temporary file. If this works ok,
     rename the old change-file to a .bak file and finally rename the
     tempfile back to the change-file.
     That way, if anything happens, either the original file is left unchanged,
     or we have at least a backup of the previous change file."

    |inStream outStream tempfile stamp f|

    self valueOfNotReading value ifFalse: [^nil].

    editingClassSource ifTrue:[
	(self confirm:'You are editing a classes sourceFile (not a changeFile) !!\Are you certain, you want to overwrite it ?' withCRs)
	ifFalse:[
	    ^ false
	]
    ].

    tempfile := Filename newTemporaryIn:nil.
    tempfile exists ifTrue:[tempfile remove].

    outStream := tempfile writeStream.
    outStream isNil ifTrue:[
	self warn:'Cannot create temporary file in current directory.'.
	^ false
    ].

    inStream := FileStream readonlyFileNamed:changeFileName.
    inStream isNil ifTrue:[^ false].

    self withCursor:(Cursor write) do:[
	|excla sawExcla done first chunk
	 nChanges "{Class:SmallInteger}" |

	Stream writeErrorSignal handle:[:ex |
	    self warn:('Could not update the changes file.\\' , ex errorString) withCRs.
	    ^ false
	] do:[

	    self valueOfNotSaving value: false.

	    excla := inStream class chunkSeparator.
	    nChanges := changes size.

	    1 to:nChanges do:[:index |
		inStream position: (changes at: index) position.
		sawExcla := inStream peekFor:excla.
		chunk := inStream nextChunk.

		(chunk notNil
		and:[(chunk startsWith:'''---- snap') not]) ifTrue:[
		    (stamp := (changes at:index) timeStamp) notNil ifTrue:[
			outStream nextPutAll:'''---- timestamp ' , stamp , ' ----'''.
			outStream nextPut:excla; cr.
		    ].
		].

		sawExcla ifTrue:[
		    outStream nextPut:excla.
		    outStream nextChunkPut:chunk.
		    outStream cr; cr.

		    "
		     a method-definition chunk - skip followups
		    "
		    done := false.
		    first := true.
		    [done] whileFalse:[
			chunk := inStream nextChunk.
			chunk isNil ifTrue:[
			    outStream cr; cr.
			    done := true
			] ifFalse:[
			    chunk isEmpty ifTrue:[
				outStream space; nextChunkPut:chunk; cr; cr.
				done := true.
			    ] ifFalse:[
				first ifFalse:[
				    outStream cr; cr.
				].
				outStream nextChunkPut:chunk.
			    ].
			].
			first := false.
		    ].
		] ifFalse:[
		    outStream nextChunkPut:chunk.
		    outStream cr
		]
	    ].
	    outStream close.
	    inStream close.
	].

	f := changeFileName asFilename.
	f renameTo:(f withSuffix:'bak').
	tempfile renameTo:changeFileName.
	self doReload.
	modified := false.
	self valueOfNotSaving value: true.
    ].
    ^ true


! !

!NewChangesBrowser::Change methodsFor:'accessing'!

category

    ^category
!

category: aValue

    category := aValue
!

chunk

    ^chunk
!

chunk: aValue

    chunk := aValue
!

className

    ^className
!

className: aValue

    className := aValue
!

delta
    |cls|

    delta size = 0 ifTrue: [^''].
    delta = '='    ifTrue: [^'Current'].
    delta = '?'    ifTrue: [
	(className notNil and:[className knownAsSymbol]) ifTrue:[
	    (cls := Smalltalk at:className asSymbol ifAbsent:nil) notNil ifTrue:[
		cls isBehavior ifTrue:[
		    cls isLoaded ifFalse:[
			^ 'Not loaded'
		    ]
		]
	    ]
	].
	^'No class'
    ].
    delta = '-'    ifTrue: [^'Remove'].
    delta = '+'    ifTrue: [^'New'].
    ^delta

    "Modified: / 29.7.1998 / 23:08:10 / cg"
!

delta: aValue

    delta := aValue
!

followUp

    ^followUp
!

followUp: aValue

    followUp := aValue
!

lastPosition: aValue

    lastPosition := aValue
!

listColor
    ((string size < 3) or:[(string at: 3) ~~ $-]) ifTrue:[
        (self type = 'class') ifTrue: [^Color gray].
        ^ Color white
    ].

    (string includesMatchString: '---- s') ifTrue: [^Color red].
    (string includesMatchString: '---- f') ifTrue: [^Color cyan: 100 magenta: 20 yellow: 20].
    (string includesMatchString: '---- c') ifTrue: [^Color blue].

    ^Color white
!

position

    ^position
!

position: aValue

    position := aValue
!

positions

    ^position printString, ' - ', lastPosition printString
!

selector
    ^ selector
!

selector:something
    selector := something.
!

string

    ^string
!

string: aValue

    string := aValue
!

timeStamp

    ^timeStamp
!

timeStamp: aValue

    timeStamp := aValue
!

type

    (type = 'doIt' or: [type = 'remove']) ifTrue: [^'class'].
    (type size = 0) ifTrue: [(string includesMatchString: '---- s') ifTrue: [^'image'] ifFalse: [^'source']].
    (self category = nil) ifTrue: [^'class'].
    ^'method'
!

type: aValue

    type := aValue
! !

!NewChangesBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

