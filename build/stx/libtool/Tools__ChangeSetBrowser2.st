"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2015-2018 Jan Vrany
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ToolApplicationModel subclass:#ChangeSetBrowser2
	instanceVariableNames:'changesetHolder titleHolder allowOpenHolder changesetFile
		navigatorChangesetHolder navigatorSpecHolder list1 list1Holder
		selection1Holder list2 list2Holder selection2Holder classHolder
		languageHolder codeAspectHolder showRemovedAspect showSameAspect
		showTimestampHolder sourceView changeSourceHolder
		imageSourceHolder targetPackage allowRemoveHolder
		allowAcceptHolder infoPanel updateChangeFileHolder
		showFilterHolder showingRegularChangesetHolder isWorkingHolder
		isWorkingNotHolder hasSelectionHolder showConflictsOnlyAspect
		targetNameSpaceName showDefinitionsOnlyAspect'
	classVariableNames:'ShowRemoved LastSelectionConditionString RecentTargetPackages
		LastConfirmersExtent'
	poolDictionaries:''
	category:'Interface-Browsers-ChangeSet'
!

ApplicationModel subclass:#ChangeEditor
	instanceVariableNames:'changeHolder readonlyHolder showdiffHolder sourceChangeHolder
		sourceImageHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ChangeSetBrowser2
!

!ChangeSetBrowser2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2015-2018 Jan Vrany
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
! !

!ChangeSetBrowser2 class methodsFor:'instance creation'!

on: aStringOrChangeSet
    "Opens a browser on given changeset. If the argument is
    string, then loads the changeset from given file - for
    compatibility with other tools"

    ^aStringOrChangeSet isString ifTrue:[
        self onFile: aStringOrChangeSet
    ] ifFalse:[
        self on: aStringOrChangeSet label: aStringOrChangeSet name
    ]

    "Modified: / 21-05-2012 / 13:55:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

on: aChangeSet label: aString

    ^self on: aChangeSet label: aString setupWith: [:browser]

    "Created: / 26-10-2010 / 22:50:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

on: aChangeSet label: label setupWith: aBlock

    | browser |

    browser := self new.
    browser
        changeset: aChangeSet;
        title: label.
    aBlock value: browser.
    ^browser

    "Created: / 26-10-2010 / 22:50:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onFile: aString
    | browser |

    browser := self new.
    browser enqueueDelayedAction:[browser doOpenFile: aString].
    ^browser

    "Created: / 17-05-2012 / 23:36:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2 class methodsFor:'accessing'!

showRemoved

    ^ShowRemoved == true
!

showRemoved: aBoolean

    ShowRemoved := aBoolean
! !

!ChangeSetBrowser2 class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::ChangeSetBrowser
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#fileLoad
'Select a file and show its contained changeset'

#fileSave
'Save the changeset in a file'

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

#testFindPreviousSnapshot
'Searches backward for the previous snapshot entry.'

#testFindNextSnapshot
'Searches forward for the next snapshot entry.'

)

    "Created: / 27-12-2011 / 10:37:47 / cg"
    "Modified: / 29-03-2012 / 12:13:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::ChangeSetBrowser2
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
'Open a changeset file (.chg or .st)'

#fileOpenSelection
''

#fileReload
'Reloads the changes file (undo your modifications).'

#fileSave
'Saves changes to current change file.'

#fileSaveAs
'Save changes to a file'

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

#testFindPreviousSnapshot
'Searches backward for the previous snapshot entry.'

#fileOpenCurrent
'Open current system changeset'

#fileOpenSelection
'Opens a new browser on currently selected changes'

)

    "Modified: / 01-08-2012 / 18:40:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2 class methodsFor:'image specs'!

applyFromLastSnapshotIcon
    ^ self applyFromLastSnapshotIcon2
!

applyFromLastSnapshotIcon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self applyFromLastSnapshotIcon inspect
     ImageEditor openOnClass:self andSelector:#applyFromLastSnapshotIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'NewChangesBrowser class applyFromLastSnapshotIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 4 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BH"H"H@@@@@@@@@H"H"H @@@@@@@@@@@@@B@@@@@@
@@;.;.; H@@@@@@@C.;.;.@@@@@@@@@@@@@@8@@N@@@@C?????C @@@N@@@O????<@@@8@@@@@@@@@C0@@@@8@@O????<O@@C @@@@?????0@@@@C @@@@@@
@O@@@N@@@@DQDQDP<@C @@@@@_??DQ@@@@@@@@@A????D@@@@@@@@@DQDQDP@@@@C @@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@C?0@B@P@B@P@O?P@O?P@O?0@??@@??@@??LC?<\C?<\C?<8O?08O?10O?10??C ??[@??_@?<^@?<_@?<_@');
                            yourself);
                yourself
        ]
!

applyFromLastSnapshotIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self applyFromLastSnapshotIcon2 inspect
     ImageEditor openOnClass:self andSelector:#applyFromLastSnapshotIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::ChangeSetBrowser2 applyFromLastSnapshotIcon2'
        ifAbsentPut:[(Depth4Image new) width:22; height:22; bits:(ByteArray fromPackedString:'
@@@BH@@@@@@QDQ<@@BH @@@@@AH"H@@@H"@@@@@@D"H H H"@@@@@@@RH"@"H"@@@@@@@AH"H@H"H@@@@@@@<@@@@BH@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@H"H"H @@@@@@@@@"H"H"@@@@@@@@@@@@@@H@@N@@@@C?????@ @@@N@@@O????<@@@8@@@@@@@@@C0@@@@8@@O????<O@@C @@@@?????0@@@@C @@@@@@
@O@@@N@@@@DQDQDP<@C @@@@@_??DQ@@@@@@@@@A????D@@@@@@@@@DQDQDP@@@@C @@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255 255 0 0 0 255 0 0 0 255 0 255 255 255 255 0 255 0 255 127 0 0 0 127 0 0 0 127 0 127 127 127 127 0 127 0 127 127 127 127 170 170 170]; mask:((ImageMask new) width:22; height:22; bits:(ByteArray fromPackedString:'A@C<C@C<C@C<&@C<<@C<\@C<H@@@@?<@@?<@@?<LC?<\C?<\C?<8O?08O?10O?10??C ??[@??_@?<^@?<_@?<_@') ; yourself); yourself]
!

applyIcon
    ^ self applyIcon2
!

applyIcon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self applyIcon inspect
     ImageEditor openOnClass:self andSelector:#applyIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'NewChangesBrowser class applyIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUUUUUPUUUUUU?PUUUUUU?[UUUUUW=PP@@@@C<QQUUU=_4PQUUU?_4VQ**U_?TPQUUUW?TPQUUUW=TXQ***U=TPQ**UUUTPQ*****TPQ***%UTPQ****)TP
QUUUUUTPQUUUUUTUP@@@@@@PUUUUUUUPUUUUUUUPUUUUUUUPUUUUUUUP');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@8@@@8@@A0_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

applyIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self applyIcon2 inspect
     ImageEditor openOnClass:self andSelector:#applyIcon2
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'NewChangesBrowser class applyIcon2'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
DQDQDQDQDQDQP3PQDQDQDQDQDQECMADQDQDQDQDQECMADQDQDQEDPQDTL4DP@@@@@DL4@DL4@Q@QDQDQP3MAP3PADADQDQDTL3P3PPDPD"H"HQECL3MA@Q@Q
DQDQDQP3MADADADQDQDQDTL4DPDPD"H"H"HQEDDQ@Q@RH"H!!DQDQDQDADAH"H"H"H"H"DPDPD"H"H"H!!DQDQ@Q@RH"H"H"H"HQDADADQDQDQDQDQDPDPDQDQ
DQDQDQDQ@Q@@@@@@@@@@@@@ADQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDQDb');
                colorMapFromArray:#[ 0 0 0 255 255 255 170 170 170 255 0 0 85 85 85 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@<@@@<@@A8@C!!8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8_??8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

applyToEndIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self applyToEndIcon inspect
     ImageEditor openOnClass:self andSelector:#applyToEndIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'NewChangesBrowser class applyToEndIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@DP@@@@@@@@@@@@DQ@@@@@@@@@@@@@QD@@@"H"H"@@Q@QD@@@BH"H"H@ADQD@@@@@@@@@ @@QDP@@BH"H"HB@@@DP@@@H"H"H @@@@@@@@@@@@@B@@@@@@
@@L3L3L0H@@@@@@@@3L3L3@@@@@@@@@@@@@@L@@B@@@@@3L3L3@0@@@B@@@CL3L3L@@@H@@@@@@@@@@0@@@@H@@ADQDQDC@@@ @@@@DQDQDP@@@@@ @@@@@@
@A@@@B@@@@DQDQDPD@@ @@@@@SL3DQ@@@@@@@@@AL3L3D@@@@@@@@@DQDQDP@@@@@ @@@@@@@@@@@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'A@@@CC?0CC?0&C?0<O?0\O?0HO?0@??@@??@@??LC?<\C?<\C?<8O?08O?10O?10??C ??[@??_@?<^@?<_@?<_@');
                            yourself);
                yourself
        ]
!

compressIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#compressIcon"
    
    ^ Icon constantNamed:#'NewChangesBrowser compressIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@????<@@@:***(@@@8@@@8@@@8@@@8@@@@@@@8@@@@@@@8A@@@@@@8@@:**0@8HC**+@@8@@@@@@@8H@@@@@@8@@@@@@@8@@@@@@@8@@@@@@@8@@C????8@@C****(@@@@@@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 124 124 124 170 170 170 255 255 255 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@??0A??8A??8A??8A8A8G>A8@@A8G?98O?18_?!!8??A8@@A8G>A8@0A8C??8C??8C??8C??0@0@@D2@@G>@@D2@@');
                            yourself);
                yourself
        ]
!

deleteIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#deleteIcon"
    
    ^ Icon constantNamed:#'NewChangesBrowser deleteIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@AUUUU@@OA??UU@@@AUUUU@@@AUUUU@B@A???U@H@A??5U@@@A???0@@@AUUUB@B@@@@@@@@@@@@@A@BK@@@@A_:@@@@@AO2G@@@@AL2@@@@@AL2C@@@@AL2@@@@@AL2@@@@@AL2H@@@@AL2@@@@@A\:@@@@@H_8 @@@@@@@H');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'_?<@_?<@_?<P_?<P_?<X_?<X_?<H_? H_?O<_?XL@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@G0');
                            yourself);
                yourself
        ]
!

deleteToEndIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#deleteToEndIcon"
    
    ^ Icon constantNamed:#'NewChangesBrowser deleteToEndIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@B** @@O@B** @@@@@@@ @@@@??< @B@@??<@@H@@@@L@@@@EUUL@@@@G?U@B@B@G?=@@@@@EUU@A@BK@@@@A_:@@@@@AO2G@@@@AL2@@@@@AL2C@@@@AL2@@@@@AL2@@@@@AL2H@@@@AL2@@@@@A\:@@@@@H_8 @@@@@@@H');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'C?0@C?0@C?0PO?0PO?0XO?0X??@H??@H??O<?<XL?<_<?<_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@_<@@G0');
                            yourself);
                yourself
        ]
!

findLastSnapshotIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#findLastSnapshotIcon"
    
    ^ Icon constantNamed:#'NewChangesBrowser findLastSnapshotIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@EUUUW@A@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@F***(@A@F***(@M@F***(@H@F***(@@@F***(@@@F***(@I@L@@@@@@@@@@@@@A@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??B@@@B@C@B@G B@O0@@_8@@G @@G @@G @');
                            yourself);
                yourself
        ]
!

findNextSnapshotIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     ImageEditor openOnClass:self andSelector:#findNextSnapshotIcon"
    
    ^ Icon constantNamed:#'NewChangesBrowser findNextSnapshotIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@DA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@D@B@@@@@@@@@@@@@@@E@@@@@@@@@EUUUW@N@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@V***(@H@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@L@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@G @@G @@G @@_8@@O0@@G @@C@@@@@@C??@C??@C??@C??@C??@C??BC??BC??BC??BC??@C??@C??@C??@C??@');
                            yourself);
                yourself
        ]
!

findPreviousForClassIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self findPreviousForClassIcon inspect
     ImageEditor openOnClass:self andSelector:#findPreviousForClassIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'NewChangesBrowser class findPreviousForClassIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@EUUUW@A@G???<@@@G???<@@@G???<@@@G???<@@@G???<@@@G???<@@@G???<@A@G???<@M@G???<@H@G???<@@@G???<@@@G???<@I@L@@@@@@@@@@@@@A
@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??B@@@B@C@B@G B@O0@@_8@@G @@G @@G @');
                            yourself);
                yourself
        ]
!

findPreviousSnapshotIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self findPreviousSnapshotIcon inspect
     ImageEditor openOnClass:self andSelector:#findPreviousSnapshotIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'NewChangesBrowser class findPreviousSnapshotIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@EUUUW@A@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@F***(@@@F***(@A@F***(@M@F***(@H@F***(@@@F***(@@@F***(@I@L@@@@@@@@@@@@@A
@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 0 0 0 255 255 255 255 0 0 170 170 170 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??@C??B@@@B@C@B@G B@O0@@_8@@G @@G @@G @');
                            yourself);
                yourself
        ]
! !

!ChangeSetBrowser2 class methodsFor:'interface opening'!

confirmChanges: aChangeSet
    "open a confirmation dialog for a number of changes to be applied"

    ^self 
        confirmChanges: aChangeSet 
        label: (self resources string:'Apply the following changes?')

    "Modified: / 08-11-2010 / 18:01:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 13:19:49 / cg"
!

confirmChanges:aChangeSet label: aString
    "Hmm, DialogBox class layout options are quite limited :-(("

    |browser browserView dialog|

    browser := self on: aChangeSet.
    browser allowAccept: false.
    browser allowRemove: true.
    browser showRemovedAspect: true asValue.
    browser beHierarchical.
    browserView := ApplicationSubView new
                client:browser
                spec:#windowSpecForEmbedding.
    dialog := (Dialog new)
                addComponent:browserView withHeight: 600;
                addAbortAndOkButtons;
                yourself.
    dialog label: aString.
"/    dialog buttonPanel
"/        layout:(LayoutFrame fractions:(0.0 @ 1.0 corner:1.0 @ 1.0)
"/                offsets:(0 @ -30 corner:0 @ 0)).
"/    browserView layout:(LayoutFrame fractions:(0.0 @ 0.0 corner:1.0 @ 1.0)
"/                offsets:(0 @ 0 corner:0 @ -30)).
    dialog stickAtBottomWithVariableHeight:browserView.
    dialog
        okAction:
            [LastConfirmersExtent := dialog window extent. 
             ^browser list1Holder value condenseChangesForRemoved];
        abortAction:
            [^#()].

    dialog openWithExtent: (LastConfirmersExtent ? (800@700)).
    ^#()

    "
         Tools::ChangeSetBrowser2
            confirmChanges:
                (ChangeSet current copyFrom: ((ChangeSet current size - 10) max: 1) to: ChangeSet current size)
            label: 'Last 10 changes...'
    "

    "Created: / 08-11-2010 / 17:59:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 20:19:44 / cg"
    "Modified: / 27-07-2012 / 17:12:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

open
    "Open browser and load current changefile"

    | browser |

    browser := self new.
    browser open.
    "JV: I would like to open current changefile only if the tool is opened from
     launcher toolbar button"

    (thisContext sender sender receiver isKindOf: AbstractLauncherApplication) ifTrue:[
        browser builder window sensor
            pushUserEvent: #doOpenCurrent for: browser.
    ] ifFalse:[
        browser builder window sensor
            pushUserEvent: #doOpenNew for: browser.

    ]

    "Created: / 25-01-2012 / 17:16:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 21:24:19 / cg"
!

openOn: aChangeSet
    ^(self on: aChangeSet) 
        open;
        yourself

    "
        self openOn: ChangeSet current
    "

    "Modified (comment): / 24-01-2012 / 20:01:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 13:19:18 / cg"
!

openOn: aChangeSet label: aString

    ^self openOn: aChangeSet label: aString setupWith: [:browser]

    "Created: / 26-10-2010 / 22:50:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

openOn: aChangeSet label: aString setupWith: aBlock

    ^(self on: aChangeSet label: aString setupWith: aBlock) open; yourself

    "Created: / 26-10-2010 / 23:07:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 13:19:30 / cg"
! !

!ChangeSetBrowser2 class methodsFor:'interface specs'!

hierarchicalNavigatorSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetBrowser2 andSelector:#hierarchicalNavigatorSpec
     Tools::ChangeSetBrowser2 new openInterface:#hierarchicalNavigatorSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: hierarchicalNavigatorSpec
        window:
       (WindowSpec
          label: 'Hierarchical Navigator'
          name: 'Hierarchical Navigator'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component:
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'ChangeList'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              majorKey: #'Tools::HierarchicalChangeList'
              subAspectHolders:
             (Array

               (SubChannelInfoSpec
                  subAspect: allowAcceptHolder
                  aspect: allowAcceptHolder
                )
               (SubChannelInfoSpec
                  subAspect: allowRemoveHolder
                  aspect: allowRemoveHolder
                )

               (SubChannelInfoSpec
                  subAspect: inGeneratorHolder
                  aspect: list1Holder
                )
               (SubChannelInfoSpec
                  subAspect: menuHolder
                  aspect: list1MenuHolder
                )

               (SubChannelInfoSpec
                  subAspect: selectionHolder
                  aspect: selection1Holder
                )
               (SubChannelInfoSpec
                  subAspect: showFilterHolder
                  aspect: showFilterHolder
                )

               (SubChannelInfoSpec
                  subAspect: showRemovedHolder
                  aspect: showRemovedAspect
                )
               (SubChannelInfoSpec
                  subAspect: showSameHolder
                  aspect: showSameAspect
                )
               (SubChannelInfoSpec
                  subAspect: showConflictsOnlyHolder
                  aspect: showConflictsOnlyAspect
                )
               (SubChannelInfoSpec
                  subAspect: showDefinitionsOnlyHolder
                  aspect: showDefinitionsOnlyAspect
                )
              )
              createNewApplication: true
              createNewBuilder: true
              postBuildCallback: list1View:
            )
           )

        )
      )
!

oneColumnNavigatorSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetBrowser2 andSelector:#oneColumnNavigatorSpec
     Tools::ChangeSetBrowser2 new openInterface:#oneColumnNavigatorSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: oneColumnNavigatorSpec
        window:
       (WindowSpec
          label: 'One Column Navigator'
          name: 'One Column Navigator'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component:
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'ChangeList'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              majorKey: #'Tools::ChangeList'
              subAspectHolders:
             (Array

               (SubChannelInfoSpec
                  subAspect: allowAcceptHolder
                  aspect: allowAcceptHolder
                )
               (SubChannelInfoSpec
                  subAspect: allowRemoveHolder
                  aspect: allowRemoveHolder
                )

               (SubChannelInfoSpec
                  subAspect: inGeneratorHolder
                  aspect: list1Holder
                )
               (SubChannelInfoSpec
                  subAspect: menuHolder
                  aspect: list1MenuHolder
                )

               (SubChannelInfoSpec
                  subAspect: selectionHolder
                  aspect: selection1Holder
                )
               (SubChannelInfoSpec
                  subAspect: showFilterHolder
                  aspect: showFilterHolder
                )

               (SubChannelInfoSpec
                  subAspect: showRemovedHolder
                  aspect: showRemovedAspect
                )
               (SubChannelInfoSpec
                  subAspect: showSameHolder
                  aspect: showSameAspect
                )

               (SubChannelInfoSpec
                  subAspect: showTimestampHolder
                  aspect: showTimestampHolder
                )
               (SubChannelInfoSpec
                  subAspect: showConflictsOnlyHolder
                  aspect: showConflictsOnlyAspect

                )
               (SubChannelInfoSpec
                  subAspect: showDefinitionsOnlyHolder
                  aspect: showDefinitionsOnlyAspect

                )
              )
              createNewApplication: true
              createNewBuilder: true
              postBuildCallback: list1View:
            )
           )

        )
      )

    "Modified: / 16-04-2013 / 16:10:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

twoColumnNavigatorSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetBrowser2 andSelector:#twoColumnNavigatorSpec
     Tools::ChangeSetBrowser2 new openInterface:#twoColumnNavigatorSpec
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: twoColumnNavigatorSpec
        window:
       (WindowSpec
          label: 'Two Column Navigator'
          name: 'Two Column Navigator'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component:
       (SpecCollection
          collection: (
           (VariableHorizontalPanelSpec
              name: 'Columns'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              component:
             (SpecCollection
                collection: (
                 (SubCanvasSpec
                    name: 'FirstColumn'
                    hasHorizontalScrollBar: false
                    hasVerticalScrollBar: false
                    majorKey: #'Tools::ChangeList'
                    subAspectHolders:
                   (Array

                     (SubChannelInfoSpec
                        subAspect: allowAcceptHolder
                        aspect: allowAcceptHolder
                      )
                     (SubChannelInfoSpec
                        subAspect: allowRemoveHolder
                        aspect: allowRemoveHolder
                      )

                     (SubChannelInfoSpec
                        subAspect: inGeneratorHolder
                        aspect: list1Holder
                      )
                     (SubChannelInfoSpec
                        subAspect: menuHolder
                        aspect: list1MenuHolder
                      )

                     (SubChannelInfoSpec
                        subAspect: outGeneratorHolder
                        aspect: list2Holder
                      )
                     (SubChannelInfoSpec
                        subAspect: selectionHolder
                        aspect: selection1Holder
                      )

                     (SubChannelInfoSpec
                        subAspect: showFilterHolder
                        aspect: showFilterHolder
                      )
                     (SubChannelInfoSpec
                        subAspect: showRemovedHolder
                        aspect: showRemovedAspect
                      )

                     (SubChannelInfoSpec
                        subAspect: showSameHolder
                        aspect: showSameAspect
                      )
                     (SubChannelInfoSpec
                        subAspect: showTimestampHolder
                        aspect: showTimestampHolder
                      )
                   (SubChannelInfoSpec
                      subAspect: showConflictsOnlyHolder
                      aspect: showConflictsOnlyAspect
                    )
                   (SubChannelInfoSpec
                      subAspect: showDefinitionsOnlyHolder
                      aspect: showDefinitionsOnlyAspect
                    )
                    )
                    createNewApplication: true
                    createNewBuilder: true
                    postBuildCallback: list1View:
                  )
                 (SubCanvasSpec
                    name: 'SecondColumn'
                    hasHorizontalScrollBar: false
                    hasVerticalScrollBar: false
                    majorKey: #'Tools::ChangeList'
                    subAspectHolders:
                   (Array

                     (SubChannelInfoSpec
                        subAspect: allowAcceptHolder
                        aspect: allowAcceptHolder
                      )
                     (SubChannelInfoSpec
                        subAspect: allowRemoveHolder
                        aspect: allowRemoveHolder
                      )

                     (SubChannelInfoSpec
                        subAspect: inGeneratorHolder
                        aspect: list2Holder
                      )
                     (SubChannelInfoSpec
                        subAspect: menuHolder
                        aspect: list2MenuHolder
                      )

                     (SubChannelInfoSpec
                        subAspect: selectionHolder
                        aspect: selection2Holder
                      )
                     (SubChannelInfoSpec
                        subAspect: showFilterHolder
                        aspect: showFilterHolder
                      )

                     (SubChannelInfoSpec
                        subAspect: showRemovedHolder
                        aspect: showRemovedAspect
                      )
                     (SubChannelInfoSpec
                        subAspect: showSameHolder
                        aspect: showSameAspect
                      )

                     (SubChannelInfoSpec
                        subAspect: showTimestampHolder
                        aspect: showTimestampHolder
                    )
                   (SubChannelInfoSpec
                      subAspect: showConflictsOnlyHolder
                      aspect: showConflictsOnlyAspect
                    )
                   (SubChannelInfoSpec
                      subAspect: showDefinitionsOnlyHolder
                      aspect: showDefinitionsOnlyAspect
                    )

                    )
                    createNewApplication: true
                    createNewBuilder: true
                    postBuildCallback: list2View:
                  )
              )
              handles: (Any 0.5 1.0)
            )
           )

        )
        )
    )

    "Modified: / 01-05-2013 / 11:22:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetBrowser2 andSelector:#windowSpec
     Tools::ChangeSetBrowser2 new openInterface:#windowSpec
     Tools::ChangeSetBrowser2 open
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: windowSpec
        window:
       (WindowSpec
          label: 'ChangeSet browser'
          name: 'ChangeSet browser'
          labelChannel: titleHolder
          min: (Point 10 10)
          bounds: (Rectangle 0 0 800 600)
          menu: mainMenu
        )
        component:
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'ToolBar'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              menu: toolbarMenu
              textDefault: true
            )
           (SubCanvasSpec
              name: 'InfoPanel'
              layout: (LayoutFrame 0 0 30 0 0 1 70 0)
              level: 0
              initiallyInvisible: true
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              clientKey: infoPanel
              createNewBuilder: false
            )
           (UISubSpecification
              name: 'Contents'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              minorKey: windowSpecWithoutToolbar
            )
           )

        )
      )
!

windowSpecForEmbedding

    ^self windowSpecWithoutToolbar
!

windowSpecWithoutToolbar
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetBrowser2 andSelector:#windowSpecWithoutToolbar
     Tools::ChangeSetBrowser2 new openInterface:#windowSpecWithoutToolbar
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpecWithoutToolbar
       window: 
      (WindowSpec
         label: 'ChangeSet browser'
         name: 'ChangeSet browser'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 653 488)
         menu: mainMenu
       )
       component: 
      (SpecCollection
         collection: (
          (VariableVerticalPanelSpec
             name: 'VerticalPanel'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'NavigatorPanel'
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   specHolder: navigatorSpecHolder
                   createNewBuilder: false
                 )
                (SubCanvasSpec
                   name: 'TextDiffTool'
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   majorKey: #'Tools::TextDiff2Tool'
                   minorKey: windowSpecForEmbedding
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: classHolder
                       aspect: classHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: languageHolder
                       aspect: languageHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: codeAspectHolder
                       aspect: codeAspectHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: labelAHolder
                       aspect: labelAHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: labelBHolder
                       aspect: labelBHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: textAHolder
                       aspect: changeSourceHolder
                     )
                     
                    (SubChannelInfoSpec
                       subAspect: textBHolder
                       aspect: imageSourceHolder
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: true
                 )
                )
              
             )
             handles: (Any 0.32581967213114754 1.0)
           )
          )
        
       )
     )
! !

!ChangeSetBrowser2 class methodsFor:'menu specs'!

changeMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::ChangeSetBrowser2 andSelector:#changeMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ChangeSetBrowser2 changeMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasChangeSelectedAndNotRemoved:
            label: 'Apply'
            itemValue: changeMenuApplySelection:
            isVisible: allowAcceptHolder
            shortcutKey: Accept
            auxValue: 100
            ignoreShortcutKeys: true
          )
         (MenuItem
            label: 'Apply All'
            itemValue: changeMenuApply:
            isVisible: allowAcceptHolder
          )
         (MenuItem
            label: '-'
            isVisible: allowAcceptHolder
          )
         (MenuItem
            label: 'Delete (selected)'
            itemValue: changeMenuDeleteSelection:
            nameKey: Delete
            isVisible: allowRemoveHolder
            shortcutKey: Delete
          )
         (MenuItem
            label: 'Delete (unselected)'
            itemValue: changeMenuDeleteSelectionInverted:
            nameKey: Delete
            isVisible: allowRemoveHolder
          )
         (MenuItem
            label: 'Undelete'
            itemValue: changeMenuUndeleteSelection:
            nameKey: Undelete
            isVisible: allowRemoveHolder
          )
         (MenuItem
            label: '-'
            isVisible: allowRemoveHolder
          )
         (MenuItem
            label: 'Select...'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Select Same'
                  itemValue: changeMenuSelectSame:
                )
               (MenuItem
                  label: 'Select Additions (new classes/methods)'
                  itemValue: changeMenuSelectAdditions:
                )
               (MenuItem
                  label: 'Select Removals'
                  itemValue: changeMenuSelectRemovals:
                )
               (MenuItem
                  label: 'Select Differences'
                  itemValue: changeMenuSelectDifferences:
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Select All'
                  itemValue: changeMenuSelectAll:
                  shortcutKey: SelectAll
                )
               (MenuItem
                  label: 'Select None'
                  itemValue: changeMenuSelectNone:
                )
               (MenuItem
                  label: 'Invert Selection'
                  itemValue: changeMenuSelectInversion:
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Select "version_XXX" Methods'
                  itemValue: changeMenuSelectVersionMethods:
                )
               (MenuItem
                  label: 'Select "copyright" Methods'
                  itemValue: changeMenuSelectCopyrightMethods:
                )
               (MenuItem
                  label: 'Select "class initialize" DoIts'
                  itemValue: changeMenuSelectClassInitializeDoIts:
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Select Using Block...'
                  itemValue: changeMenuSelectUsingBlock:
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
            enabled: notShowConflictsOnlyOrDefinitionsOnlyAspect
            label: 'Show Deleted'
            isVisible: allowRemoveHolder
            indication: showRemovedAspect
          )
         (MenuItem
            enabled: notShowConflictsOnlyOrDefinitionsOnlyAspect
            label: 'Show Same'
            indication: showSameAspect
          )
         (MenuItem
            enabled: notShowDefinitionsOnlyAspect
            label: 'Show Conflicts Only'
            indication: showConflictsOnlyAspect
          )
         (MenuItem
            enabled: notShowConflictsOnlyAspect
            label: 'Show Definitions Only'
            indication: showDefinitionsOnlyAspect
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Inspect Change'
            itemValue: changeMenuInspect:
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSingleChangeSelectedAndCanBrowseClass:
            label: 'Browse Class(es)'
            itemValue: changeMenuBrowseClass:
          )
         (MenuItem
            enabled: hasSingleChangeSelectedAndCanBrowse:
            label: 'Browse Method(s)'
            itemValue: changeMenuBrowse:
          )
         )
        nil
        nil
      )

    "Modified: / 04-03-2016 / 16:02:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenu1
    <resource: #programMenu>

    ^self changeMenu

    "Modified: / 17-05-2012 / 22:51:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenu2
    <resource: #programMenu>

    ^self changeMenu

    "Modified: / 17-05-2012 / 22:51:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::ChangeSetBrowser2 andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ChangeSetBrowser2 mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'New'
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        activeHelpKey: fileNew
                        label: 'New Changeset'
                        itemValue: doOpenNew
                      )
                     (MenuItem
                        label: 'New Window'
                        itemValue: doOpenNewWindow
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
                  activeHelpKey: fileOpenSelection
                  enabled: isWorkingNotHolder
                  label: 'Spawn Browser on Selection'
                  itemValue: doOpenOnSelection
                  isVisible: allowOpenHolder
                )
               (MenuItem
                  activeHelpKey: fileOpenSelection
                  enabled: isWorkingNotHolder
                  label: 'Spawn on Selection'
                  itemValue: doOpenOnSelection
                  isVisible: allowOpenHolder
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Inspect ChangeSet'
                  itemValue: doInspectChangeSet
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  activeHelpKey: fileLoad
                  enabled: isWorkingNotHolder
                  label: 'Open...'
                  itemValue: doOpen
                  isVisible: allowOpenHolder
                  shortcutKey: Ctrlo
                )
               (MenuItem
                  activeHelpKey: fileOpenCurrent
                  enabled: isWorkingNotHolder
                  label: 'Open Session Changeset'
                  itemValue: doOpenSession
                  isVisible: allowOpenHolder
                )
               (MenuItem
                  activeHelpKey: fileOpenCurrent
                  enabled: isWorkingNotHolder
                  label: 'Open Session Changefile'
                  itemValue: doOpenCurrent
                  isVisible: allowOpenHolder
                )
               (MenuItem
                  activeHelpKey: fileOpenCurrent
                  enabled: isWorkingNotHolder
                  label: 'Open Cypress Package'
                  itemValue: doOpenCypress
                  isVisible: allowOpenHolderAndCypressPresent
                )
               (MenuItem
                  activeHelpKey: fileSaveAs
                  enabled: isWorkingNotHolder
                  label: 'Save'
                  itemValue: doSave
                )
               (MenuItem
                  enabled: isWorkingNotHolder
                  label: 'Save As...'
                  itemValue: doSaveAs
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: isWorkingNotHolder
            label: 'Changes'
            isVisible: isTwoColumnHolderNot
            submenuChannel: list1MenuHolder
          )
         (MenuItem
            enabled: isWorkingNotHolder
            label: 'Left'
            isVisible: isTwoColumnHolder
            submenuChannel: list1MenuHolder
          )
         (MenuItem
            enabled: isWorkingNotHolder
            label: 'Right'
            isVisible: isTwoColumnHolder
            submenuChannel: list2MenuHolder
          )
         (MenuItem
            label: 'View'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'List'
                  hideMenuOnActivated: false
                  choice: navigatorSpecHolder
                  choiceValue: oneColumnNavigatorSpec
                )
               (MenuItem
                  label: 'Hierarchical List'
                  hideMenuOnActivated: false
                  choice: navigatorSpecHolder
                  choiceValue: hierarchicalNavigatorSpec
                )
               (MenuItem
                  label: 'Browser Like'
                  hideMenuOnActivated: false
                  choice: navigatorSpecHolder
                  choiceValue: twoColumnNavigatorSpec
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: notShowConflictsOnlyOrDefinitionsOnlyAspect
                  label: 'Show Deleted'
                  hideMenuOnActivated: false
                  indication: showRemovedAspect
                )
               (MenuItem
                  enabled: notShowConflictsOnlyOrDefinitionsOnlyAspect
                  label: 'Show Same'
                  hideMenuOnActivated: false
                  indication: showSameAspect
                )
               (MenuItem
                  enabled: notShowDefinitionsOnlyAspect
                  label: 'Show Conflicts Only'
                  hideMenuOnActivated: false
                  indication: showConflictsOnlyAspect
                )
               (MenuItem
                  enabled: notShowConflictsOnlyAspect
                  label: 'Show Definitions Only'
                  hideMenuOnActivated: false
                  indication: showDefinitionsOnlyAspect
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Show Filter'
                  hideMenuOnActivated: false
                  indication: showFilterHolder
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Show Timestamp'
                  hideMenuOnActivated: false
                  indication: showTimestampHolder
                )
               (MenuItem
                  label: 'Update'
                  itemValue: menuUpdate
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Loading'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Set Target Package...'
                  itemValue: setTargetPackage
                )
               (MenuItem
                  label: 'Set Target Namespace...'
                  itemValue: setTargetNamespace
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Update Changefile'
                  indication: updateChangeFileHolder
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'MENU_Help'
            startGroup: conditionalRight
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'ChangesBrowser Documentation'
                  itemValue: openHTMLDocument:
                  argument: 'tools/cbrowser/TOP.html'
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About ChangesBrowser...'
                  itemValue: openAboutThisApplication
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
!

toolbarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::ChangeSetBrowser2 andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ChangeSetBrowser2 toolbarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: fileLoad
            enabled: isWorkingNotHolder
            label: 'Load'
            itemValue: doOpen
            isButton: true
            isVisible: isStandalone
            labelImage: (ResourceRetriever XPToolbarIconLibrary loadFromFileIcon)
          )
         (MenuItem
            activeHelpKey: fileSave
            enabled: isWorkingNotHolder
            label: 'Save'
            itemValue: doSave
            isButton: true
            isVisible: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary saveToFileIcon)
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            activeHelpKey: applyLine
            enabled: hasSelectionHolder
            label: 'Apply'
            itemValue: doApply
            isButton: true
            isVisible: true
            labelImage: (ResourceRetriever nil applyIcon)
          )
         (MenuItem
            activeHelpKey: applyToEnd
            enabled: hasSelectionHolder
            label: 'Apply To End'
            itemValue: doApplyToEnd
            isButton: true
            isVisible: true
            labelImage: (ResourceRetriever nil applyToEndIcon)
          )
         (MenuItem
            activeHelpKey: applyFromLastSnapshot
            enabled: hasSelectionHolder
            label: 'Apply From Last Snapshot'
            itemValue: doApplyFromLastSnapshot
            isButton: true
            isVisible: true
            labelImage: (ResourceRetriever nil applyFromLastSnapshotIcon)
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            activeHelpKey: deleteLine
            enabled: hasSelectionHolder
            label: 'Delete'
            itemValue: doDelete
            isButton: true
            isVisible: allowRemoveHolder
            labelImage: (ResourceRetriever nil deleteIcon)
          )
         (MenuItem
            activeHelpKey: deleteToEnd
            enabled: hasSelectionHolder
            label: 'Delete To End'
            itemValue: doDeleteToEnd
            isButton: true
            isVisible: allowRemoveHolder
            labelImage: (ResourceRetriever nil deleteToEndIcon)
          )
         (MenuItem
            activeHelpKey: deleteCompress
            enabled: isWorkingNotHolder
            label: 'Compress'
            itemValue: doCompress
            isButton: true
            isVisible: allowRemoveHolder
            labelImage: (ResourceRetriever nil compressIcon)
          )
         (MenuItem
            label: '-'
            isVisible: showingRegularChangesetHolder
          )
         (MenuItem
            activeHelpKey: testFindPreviousSnapshot
            enabled: hasSelectionHolder
            label: 'Find Previous Snapshot'
            itemValue: doFindSnapshot:
            isButton: true
            isVisible: showingRegularChangesetHolder
            labelImage: (ResourceRetriever nil findPreviousSnapshotIcon)
            argument: 'previous'
          )
         (MenuItem
            activeHelpKey: testFindNextSnapshot
            enabled: hasSelectionHolder
            label: 'Find Next Snapshot'
            itemValue: doFindSnapshot:
            isButton: true
            isVisible: showingRegularChangesetHolder
            labelImage: (ResourceRetriever nil findNextSnapshotIcon)
            argument: 'next'
          )
         )
        nil
        nil
      )
! !

!ChangeSetBrowser2 class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #changesetHolder
      ).

! !

!ChangeSetBrowser2 methodsFor:'accessing'!

allowAccept: aBoolean

    ^self allowAcceptHolder value: aBoolean

    "Created: / 24-01-2012 / 19:50:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowOpen: aBoolean

    self allowOpenHolder value: aBoolean

    "Created: / 26-10-2010 / 23:18:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowRemove: aBoolean

    ^self allowRemoveHolder value: aBoolean

    "Created: / 24-01-2012 / 20:00:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

beHierarchical

    ^self navigatorSpecHolder value: #hierarchicalNavigatorSpec

    "Modified: / 14-10-2010 / 15:52:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

beOneColumn

    ^self navigatorSpecHolder value: #oneColumnNavigatorSpec

    "Modified: / 14-10-2010 / 15:52:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

beTwoColumn

    ^self navigatorSpecHolder value: #twoColumnNavigatorSpec

    "Modified: / 14-10-2010 / 15:51:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeset

    ^self changesetHolder value
!

changeset: aChangeSet

    self changesetHolder value: aChangeSet
!

codeAspect
    ^self codeAspectHolder value

    "Created: / 04-04-2013 / 18:28:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readOnly: aBoolean
    self allowAcceptHolder value:false.

    "Created: / 20-07-2010 / 09:48:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2012 / 14:31:50 / cg"
!

selectedChanges
    | sel |

    sel := selection2Holder value.
    sel isEmptyOrNil ifTrue:[
        sel := selection1Holder value.
    ].
    ^ sel select:[:each | each notNil].
!

showFilter: aBoolean
    self showFilterHolder value: aBoolean

    "Created: / 11-02-2012 / 22:47:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showSame: aBoolean
    self showSameAspect value: aBoolean

    "Created: / 01-11-2014 / 00:04:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

targetNamespace:something
    targetNameSpaceName := something.
!

targetPackage:something
    targetPackage := something.
!

theSingleSelectedChange
    | change sel |
    change := nil.
    sel := selection2Holder value.
    sel isNil ifTrue:[
        sel := selection1Holder value.
    ].
    sel isNil ifTrue:[
        ^nil
    ].
    sel do:
        [:each|
        change notNil ifTrue:[nil].
        change isNil ifTrue:[change := each]].
    ^change

    "Modified: / 26-07-2012 / 19:33:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

title: aString

    self titleHolder value: aString

    "Created: / 26-10-2010 / 23:01:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2 methodsFor:'accessing - menus'!

list1MenuHolder
    ^ [
        |menu|

        menu := builder menuFor:#changeMenu1.
        "/ cg: must nil shortcut keys, because the menu is present twice,
        "/ and the user (me) gets confused, if it is always the left menu, which
        "/ is firing
        menu allItemsDo:[:item | item shortcutKey:nil. item argument:list1 ].
        menu
    ]

    "Created: / 04-08-2011 / 18:11:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-09-2011 / 16:07:20 / cg"
!

list2MenuHolder
    ^ [
        |menu|

        menu := builder menuFor:#changeMenu2.
        "/ cg: must nil shortcut keys, because the menu is present twice,
        "/ and the user (me) gets confused, if it is always the left menu, which
        "/ is firing
        menu allItemsDo:[:item | item shortcutKey:nil. item argument:list2 ].
        menu
    ]

    "Created: / 04-08-2011 / 18:13:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-09-2011 / 16:07:34 / cg"
! !

!ChangeSetBrowser2 methodsFor:'accessing-defaults'!

defaultTitle
    ^ 'No changeset'

    "Modified: / 08-04-2011 / 10:10:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2 methodsFor:'actions'!

accept: source
    | entry chg |

    (entry := self theSingleSelectedChange) isNil ifTrue:[^self].
    chg := entry change.
    chg isMethodCodeChange ifTrue: [
        chg source: source asString
    ]

    "Modified: / 29-11-2010 / 22:40:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:56:53 / cg"
!

processEvent:anEvent
    "filter keyboard events for accept key"

    <resource: #keyboard (#Accept)>

    |evView|

    anEvent isKeyPressEvent ifTrue:[
        evView := anEvent targetView.
        anEvent key == #Accept ifTrue:[
            (evView isComponentOf:list1 window) ifTrue:[ self changeMenuApplyChanges:(self selectedChangesIn:list1) in: list1 . ^true ].
            (evView isComponentOf:list2 window) ifTrue:[ self changeMenuApplyChanges:(self selectedChangesIn:list2) in: list2 . ^true ].
        ].
    ].
    ^ false

    "Modified: / 04-03-2016 / 15:54:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2 methodsFor:'aspects'!

allowAcceptHolder
    "return/create the 'selectionHolder' value holder (automatically generated)"

    allowAcceptHolder isNil ifTrue:[
        allowAcceptHolder := ValueHolder with: true.
    ].
    ^ allowAcceptHolder

    "Modified: / 24-10-2009 / 19:56:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 24-01-2012 / 19:50:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowOpenHolder
    "return/create the 'allowOpenHolder' value holder (automatically generated)"

    allowOpenHolder isNil ifTrue:[
        allowOpenHolder := ValueHolder with: true.
    ].
    ^ allowOpenHolder

    "Modified: / 17-03-2011 / 22:32:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowOpenHolderAndCypressPresent

    ^BlockValue
        with: [:value|
            value and: [ ConfigurableFeatures includesFeature:#Cypress ]
        ]
        argument: self allowOpenHolder.

    "Modified (format): / 07-09-2012 / 20:09:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowRemoveHolder
    "return/create the 'allowRemoveHolder' value holder (automatically generated)"

    allowRemoveHolder isNil ifTrue:[
        allowRemoveHolder := ValueHolder with:false.
        allowRemoveHolder addDependent:self.
    ].
    ^ allowRemoveHolder

    "Modified: / 24-01-2012 / 19:59:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowRemoveHolder:something
    "set the 'showRemovedHolder' value holder (automatically generated)"

    |oldValue newValue|

    allowRemoveHolder notNil ifTrue:[
        oldValue := allowRemoveHolder value.
        allowRemoveHolder removeDependent:self.
    ].
    allowRemoveHolder := something.
    allowRemoveHolder notNil ifTrue:[
        allowRemoveHolder addDependent:self.
    ].
    newValue := allowRemoveHolder value.
    oldValue ~~ newValue ifTrue:[
        self
            update:#value
            with:newValue
            from:allowRemoveHolder.
    ].

    "Modified (format): / 24-01-2012 / 19:48:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSourceHolder
    <resource: #uiAspect>
    changeSourceHolder isNil ifTrue: [
        changeSourceHolder := nil asValue.
    ].
    ^ changeSourceHolder.

    "Modified: / 19-07-2011 / 11:54:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetHolder
    "return/create the 'changesetHolder' value holder (automatically generated)"

    changesetHolder isNil ifTrue:[
        changesetHolder := ValueHolder new.
        changesetHolder addDependent:self.
    ].
    ^ changesetHolder
!

changesetHolder:something
    "set the 'changesetHolder' value holder (automatically generated)"

    |oldValue newValue|

    changesetHolder notNil ifTrue:[
        oldValue := changesetHolder value.
        changesetHolder removeDependent:self.
    ].
    changesetHolder := something.
    changesetHolder notNil ifTrue:[
        changesetHolder addDependent:self.
    ].
    newValue := changesetHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:changesetHolder.
    ].
!

classHolder
    "return/create the 'classHolder' value holder (automatically generated)"

    classHolder isNil ifTrue:[
        classHolder := ValueHolder with:nil.
    ].
    ^ classHolder

    "Modified: / 19-07-2011 / 19:12:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAspectHolder
    "return/create the 'codeAspectHolder' value holder (automatically generated)"

    codeAspectHolder isNil ifTrue:[
        codeAspectHolder := ValueHolder with: nil.
    ].
    ^ codeAspectHolder

    "Modified: / 27-07-2012 / 22:04:12 / cg"
    "Modified: / 04-04-2013 / 18:28:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

imageSourceHolder
    <resource: #uiAspect>
    imageSourceHolder isNil ifTrue: [
        imageSourceHolder := nil asValue.
    ].
    ^ imageSourceHolder.

    "Created: / 19-07-2011 / 11:54:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoPanel
    infoPanel isNil ifTrue:[
        infoPanel := InlineMessageDialog new
    ].
    ^ infoPanel

    "Created: / 09-02-2012 / 19:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTwoColumnHolder
    | holder |

    holder :=  builder bindings at: #isTwoColumnHolder ifAbsentPut:[
        BlockValue
            with:[:v| v value == #twoColumnNavigatorSpec]
            argument: self navigatorSpecHolder.
    ].
    ^holder

    "Created: / 30-03-2012 / 12:07:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTwoColumnHolderNot
    | holder |

    holder :=  builder bindings at: #isTwoColumnHolderNot ifAbsentPut:[
        BlockValue
            with:[:v| v value ~~ #twoColumnNavigatorSpec]
            argument: self navigatorSpecHolder.
    ].
    ^holder

    "Created: / 30-03-2012 / 12:08:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelAHolder

    ^'Change' asValue

    "Created: / 19-07-2011 / 11:46:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelBHolder

    ^'Image' asValue

    "Created: / 19-07-2011 / 11:46:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

languageHolder
    languageHolder isNil ifTrue:[
        languageHolder := ValueHolder with:nil.
    ].
    ^ languageHolder

    "Modified: / 19-07-2011 / 19:12:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 03-12-2011 / 10:37:39 / cg"
!

list1Holder
    "return/create the 'list1Holder' value holder (automatically generated)"

    list1Holder isNil ifTrue:[
        list1Holder := ValueHolder new.
    ].
    ^ list1Holder
!

list1Holder:something
    "set the 'list1Holder' value holder (automatically generated)"

    list1Holder := something.
!

list2Holder
    "return/create the 'list2Holder' value holder (automatically generated)"

    list2Holder isNil ifTrue:[
        list2Holder := ValueHolder new.
    ].
    ^ list2Holder
!

list2Holder:something
    "set the 'list2Holder' value holder (automatically generated)"

    list2Holder := something.
!

navigatorChangesetHolder
    "return/create the 'navigatorChangesetHolder' value holder (automatically generated)"

    navigatorChangesetHolder isNil ifTrue:[
        navigatorChangesetHolder := ValueHolder new.
    ].
    ^ navigatorChangesetHolder
!

navigatorSpecHolder
    <resource: #uiAspect>

    navigatorSpecHolder isNil ifTrue:[
        navigatorSpecHolder := ValueHolder with:
                                                    "/#hierarchicalNavigatorSpec
                                                    "/#twoColumnNavigatorSpec
                                                    #oneColumnNavigatorSpec.
        navigatorSpecHolder addDependent: self.

    ].
    ^ navigatorSpecHolder.

    "Modified: / 04-02-2012 / 21:25:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notShowConflictsOnlyAspect
    ^ BlockValue forLogicalNot:(self showConflictsOnlyAspect)
!

notShowConflictsOnlyOrDefinitionsOnlyAspect
    ^ BlockValue 
        forLogical:(self notShowConflictsOnlyAspect)
        and:(self notShowDefinitionsOnlyAspect)
!

notShowDefinitionsOnlyAspect
    ^ BlockValue forLogicalNot:(self showDefinitionsOnlyAspect)
!

selection1Holder
    "return/create the 'selection1Holder' value holder (automatically generated)"

    selection1Holder isNil ifTrue:[
        selection1Holder := ValueHolder new.
        selection1Holder addDependent:self.
    ].
    ^ selection1Holder
!

selection1Holder:something
    "set the 'selection1Holder' value holder (automatically generated)"

    |oldValue newValue|

    selection1Holder notNil ifTrue:[
        oldValue := selection1Holder value.
        selection1Holder removeDependent:self.
    ].
    selection1Holder := something.
    selection1Holder notNil ifTrue:[
        selection1Holder addDependent:self.
    ].
    newValue := selection1Holder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selection1Holder.
    ].
!

selection2Holder
    "return/create the 'selection2Holder' value holder (automatically generated)"

    selection2Holder isNil ifTrue:[
        selection2Holder := ValueHolder new.
        selection2Holder addDependent:self.
    ].
    ^ selection2Holder
!

selection2Holder:something
    "set the 'selection2Holder' value holder (automatically generated)"

    |oldValue newValue|

    selection2Holder notNil ifTrue:[
        oldValue := selection2Holder value.
        selection2Holder removeDependent:self.
    ].
    selection2Holder := something.
    selection2Holder notNil ifTrue:[
        selection2Holder addDependent:self.
    ].
    newValue := selection2Holder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:selection2Holder.
    ].
!

showConflictsOnlyAspect
    "return/create the 'showConflictsOnlyAspect' value holder (automatically generated)"

    showConflictsOnlyAspect isNil ifTrue:[
        showConflictsOnlyAspect := ValueHolder with: false.
    ].
    ^ showConflictsOnlyAspect
!

showConflictsOnlyAspect:aValueHolder
    showConflictsOnlyAspect := aValueHolder.
!

showDefinitionsOnlyAspect
    "return/create the 'showDefinitionsOnlyAspect' value holder (automatically generated)"

    showDefinitionsOnlyAspect isNil ifTrue:[
        showDefinitionsOnlyAspect := ValueHolder with: false.
    ].
    ^ showDefinitionsOnlyAspect
!

showDefinitionsOnlyAspect:aValueHolder
    showDefinitionsOnlyAspect := aValueHolder.
!

showFilterHolder
    "return/create the 'showFilterHolder' value holder (automatically generated)"

    showFilterHolder isNil ifTrue:[
        showFilterHolder := false asValue.
    ].
    ^ showFilterHolder

    "Modified: / 11-02-2012 / 22:46:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showFilterHolder:something
    "set the 'showFilterHolder' value holder (automatically generated)"

    showFilterHolder := something.
!

showRemovedAspect
    "return/create the 'showDeletedAspect' value holder (automatically generated)"

    showRemovedAspect isNil ifTrue:[
        showRemovedAspect := (AspectAdaptor forAspect:#showRemoved)
                                subject: self class.
    ].
    ^ showRemovedAspect
!

showRemovedAspect:aValueHolder
    showRemovedAspect := aValueHolder.
!

showSameAspect
    "return/create the 'showSameAspect' value holder (automatically generated)"

    showSameAspect isNil ifTrue:[
        showSameAspect := ValueHolder with: true.
    ].
    ^ showSameAspect

    "Modified: / 04-08-2011 / 18:42:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showSameAspect:something
    "set the 'showSameAspect' value holder (automatically generated)"

    showSameAspect := something.
!

showTimestampHolder
    "return/create the 'showTimestampHolder' value holder (automatically generated)"

    showTimestampHolder isNil ifTrue:[
        showTimestampHolder := ValueHolder with: false.
    ].
    ^ showTimestampHolder

    "Modified: / 26-07-2012 / 18:47:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showTimestampHolder:something
    "set the 'showTimestampHolder' value holder (automatically generated)"

    showTimestampHolder := something.
!

showingRegularChangesetHolder
    "return/create the 'showingRegularChangesetHolder' value holder (automatically generated)"

    showingRegularChangesetHolder isNil ifTrue:[
        showingRegularChangesetHolder := ValueHolder with: false.
        showingRegularChangesetHolder addDependent:self.
    ].
    ^ showingRegularChangesetHolder

    "Modified: / 26-07-2012 / 19:45:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showingRegularChangesetHolder:something
    "set the 'showingRegularChangesetHolder' value holder (automatically generated)"

    |oldValue newValue|

    showingRegularChangesetHolder notNil ifTrue:[
        oldValue := showingRegularChangesetHolder value.
        showingRegularChangesetHolder removeDependent:self.
    ].
    showingRegularChangesetHolder := something.
    showingRegularChangesetHolder notNil ifTrue:[
        showingRegularChangesetHolder addDependent:self.
    ].
    newValue := showingRegularChangesetHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:showingRegularChangesetHolder.
    ].
!

titleHolder
    "return/create the 'titleHolder' value holder (automatically generated)"

    titleHolder isNil
        ifTrue:[ titleHolder := ValueHolder with:self defaultTitle. ].
    ^ titleHolder

    "Modified: / 26-10-2010 / 22:54:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateChangeFileHolder
    updateChangeFileHolder isNil ifTrue:[
        updateChangeFileHolder := false asValue.
    ].
    ^ updateChangeFileHolder

    "Created: / 07-09-2011 / 15:54:03 / cg"
    "Created: / 11-02-2012 / 22:40:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2 methodsFor:'aspects-queries'!

hasSelectionHolder

    hasSelectionHolder isNil ifTrue:[
        hasSelectionHolder :=
            BlockValue
                with:[:sel1 :sel2|
                    sel1 value notEmptyOrNil or:[sel2 value notEmptyOrNil]
                ]
                argument: self selection1Holder
                argument: self selection2Holder
    ].
    ^hasSelectionHolder

    "Created: / 17-05-2012 / 20:45:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isWorkingHolder

    isWorkingHolder isNil ifTrue:[
        isWorkingHolder := ValueHolder with: false.
    ].
    ^isWorkingHolder

    "Created: / 17-05-2012 / 20:45:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isWorkingNotHolder

    isWorkingNotHolder isNil ifTrue:[
        isWorkingNotHolder := BlockValue forLogicalNot: self  isWorkingHolder
    ].
    ^isWorkingNotHolder

    "Created: / 17-05-2012 / 20:45:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2 methodsFor:'change & update'!

changesetChanged

    self titleHolder value: (self changeset name ifNil:[self defaultTitle]).
    self list1Holder value: self getNavigatorChangeSet

    "Modified: / 04-08-2011 / 18:05:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2012 / 13:18:54 / cg"
!

selectionChanged
    | listEntry change srcImage srcChange|

    listEntry := self theSingleSelectedChange.
    (listEntry notNil and:[(change := listEntry change) isCompositeChange not]) ifTrue:[
        codeAspectHolder setValue:
            (change isMethodCodeChange
                ifTrue:[SyntaxHighlighter codeAspectMethod]
                ifFalse:[
                    (change isClassDefinitionChange
                        ifTrue:[SyntaxHighlighter codeAspectClassDefinition]   
                        ifFalse:[SyntaxHighlighter codeAspectExpression])]).
        self classHolder value: change changeClass.
        srcImage := change imageSource.
        srcChange := change changeSource.
        "/ Hack to make sure code is displayed in similar way
        "/ (i.e., with no namespace pragma)
        (change isClassDefinitionChange and:[change isPrivateClassDefinitionChange]) ifTrue:[
            srcChange := change definitionStringInNamespace: nil.
        ].
        srcImage notNil ifTrue:[
            srcImage := srcImage withoutSeparators.
        ].
        srcChange := srcChange withoutSeparators.  

        changeSourceHolder setValue: srcChange"; changed: #value".
        srcImage = srcChange ifTrue:[
            imageSourceHolder setValue: nil"; changed: #value".
        ] ifFalse:[
            imageSourceHolder setValue: srcImage"; changed: #value".

            "/ check agan, based on parser (ignoring indentation)
            change isClassDefinitionChange ifTrue:[
                |parseError treeA treeB|

                (srcImage notEmptyOrNil and:[ srcChange notEmptyOrNil ]) ifTrue:[
                    parseError := false.
                    treeA := RBParser parseExpression:srcImage onError: [:str :pos | parseError := true].
                    treeB := RBParser parseExpression:srcChange onError: [:str :pos | parseError := true].
                    parseError ifFalse:[
                        (treeA equalTo:treeB withMapping:(Dictionary  new)) ifTrue:[
                            imageSourceHolder setValue: nil
                        ]
                    ]
                ]
            ].
        ].
        changeSourceHolder changed.
        imageSourceHolder changed.
        codeAspectHolder changed.

        self showSource: true
    ] ifFalse:[
        self showSource: false.
        self classHolder value: nil.
        changeSourceHolder setValue: nil; changed: #value.
        imageSourceHolder setValue: nil; changed: #value.
    ].

    "Created: / 24-10-2009 / 19:49:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 23:42:46 / cg"
    "Modified: / 19-11-2013 / 12:16:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showingRegularChangesetChanged

    self showTimestampHolder value: showingRegularChangesetHolder value.

    "Created: / 26-07-2012 / 19:40:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update: aspect with: param from: sender

    sender == changesetHolder ifTrue: [
        self changesetChanged .
        ^self
    ].
    sender == navigatorSpecHolder ifTrue: [
        self changesetChanged .
        ^self
    ].
    sender == selection1Holder ifTrue: [
        self selectionChanged.
        ^self
    ].
    sender == selection2Holder ifTrue: [
        self selectionChanged.
        ^self
    ].

    sender == showingRegularChangesetHolder ifTrue:[
        self showingRegularChangesetChanged.
        ^self.
    ].
    super update: aspect with: param from: sender

    "Created: / 24-10-2009 / 19:29:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2 methodsFor:'initialization'!

list1View: aSubApplicationView
    list1 := aSubApplicationView application.
    list1 applyAction:[:change | self changeMenuApplyChange:change].

    "Created: / 04-08-2011 / 17:56:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-09-2012 / 14:22:37 / cg"
!

list2View: aSubApplicationView
    list2 := aSubApplicationView application.
    list2 applyAction:[:change | self changeMenuApplyChange:change].

    "Created: / 04-08-2011 / 17:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-09-2012 / 14:22:50 / cg"
!

postBuildSourceView: aView

    sourceView := aView.

    "Modified: / 19-07-2011 / 19:08:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postOpenWith: aBuilder
    super postOpenWith: aBuilder.

    "/ I want to intercept keyboard events.
    self windowGroup addPreEventHook:self.
! !

!ChangeSetBrowser2 methodsFor:'menu actions'!

doApply
    "Applies currently selected change"

    self changeMenuApplySelection: self list.

    "Modified: / 30-03-2012 / 12:18:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doApplyFromLastSnapshot

    self doFindSnapshot: #last.
    self doApplyToEnd.

    "Modified: / 30-03-2012 / 12:19:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doApplySelectedChanges
    self selectedChanges do:[:chgListEntry |
        self changeMenuApplyChange: chgListEntry change.
    ].
!

doApplyToEnd

    self changeMenuApplyToEnd: self list.

    "Modified: / 30-03-2012 / 12:35:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCompress
    self loadChangeSet: (self changesetHolder value copy condenseChanges)

    "Modified: / 04-03-2015 / 17:26:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doDelete
   self changeMenuDeleteSelection: self list.

    "Modified: / 30-03-2012 / 12:21:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doDeleteToEnd
    "automatically generated by UIEditor ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."
    "*** (and replace this comment by something more useful ;-)"

    "action to be added ..."

    Transcript showCR:self class name, ': action for #doDeleteToEnd ...'.
!

doFindSnapshot:previousOrNext
    self doFindSnapshot: previousOrNext in: self list.

    "Modified: / 27-07-2012 / 15:40:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doFindSnapshot:previousOrNext in: changeList
    | snapshot selection searchBlock notFoundMessage |


    selection := self theSingleSelectedChange.
    searchBlock := [:listEntry|
        listEntry == selection ifTrue:[
            snapshot notNil ifTrue:[
                changeList selection: (OrderedCollection with: snapshot).
            ] ifFalse:[
                self infoPanel showMessage: notFoundMessage closeAfter: 5"sec".
            ].
            ^self.
        ] ifFalse:[
            (listEntry change isOtherChange and:[listEntry change type == #snapshot]) ifTrue:[
                snapshot := listEntry
            ].
        ].
    ].
    previousOrNext = 'previous' ifTrue:[
        selection isNil ifTrue:[
            selection := changeList list last.
            changeList selection: (Array with: selection).
        ].
        notFoundMessage := resources string:'No snapshot prior selected change found.'.
        changeList list do: searchBlock.
    ] ifFalse:[
        selection isNil ifTrue:[
            selection := changeList list first.
            changeList selection: (Array with: selection).
        ].
        notFoundMessage := resources string:'No snapshot after selected change found.'.
        changeList list reverseDo: searchBlock.
    ]

    "Created: / 27-07-2012 / 15:38:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doInspectChangeSet
    self changeMenuInspectChangeset: changesetHolder value
!

doOpen
    | file |

    [
        file := Dialog requestFileName:'Select Changeset to Load' pattern:'*.chg;*.st'.
    ] on: Dialog aboutToOpenBoxNotificationSignal do:[:ex|
        | dialog |

        dialog := ex box.
        "/ cg: who wanted to do something here?
        ex pass.
    ].
    file isNil ifTrue:[^self].
    self doOpenFile: file

    "Modified: / 08-04-2011 / 10:11:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 21:21:40 / cg"
!

doOpen: aChangeSet
    <resource: #obsolete>
    "/ a bad name - implying opening a window...
    self loadChangeSet: aChangeSet

    "Created: / 05-12-2009 / 13:43:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 21:21:24 / cg"
!

doOpenCurrent

    self doOpenFile: ObjectMemory nameForChanges.
    self showFilter: true.

    "Created: / 05-12-2009 / 13:44:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenCurrentChangeFile
    self withWaitCursorDo:[
        self class openOn: (ChangeSet fromFile: ObjectMemory nameForChanges)
    ].

    "Created: / 05-12-2009 / 13:44:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 27-07-2012 / 21:16:42 / cg"
!

doOpenCypress

    | file |
    [
        file := Dialog requestDirectoryName:(resources string: 'Select Cypress Package')."/ pattern:'*.package'.
    ] on: Dialog aboutToOpenBoxNotificationSignal do:[:ex|
        | dialog |

        dialog := ex box.
        "/ cg: who wanted to do something here?
        ex pass.
    ].

    file isNil ifTrue:[^self].
    self doOpenCypress: file

    "Modified: / 03-09-2012 / 11:53:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenCypress: aStringOrFilename
    "Opens a Cypress package in given directory"

    | dir changeset |

    dir := aStringOrFilename asFilename.
    dir exists ifFalse:[
        Dialog warn: (resources string:'Selected directory does not exists').
        ^self.
    ].
    dir isDirectory ifFalse:[
        Dialog warn: (resources string:'Selected file is not a directory').
        ^self.
    ].
    (dir / 'properties.json') isReadable ifFalse:[
        Dialog warn: (resources string:'No properties.json found. Perhaps not a Cypress package directory?').
        ^self.
    ].

    self showProgress: (resources string: 'Reading Cypress Package...') while: [
        changeset := ((Smalltalk at:#CypressReader) readPackageFrom: dir) asChangeSet.
        self doOpen: changeset.
    ].

    "Created: / 03-09-2012 / 11:44:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-10-2015 / 18:12:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenFile: aStringOrFilename
    | cs fn |

    self showProgress: 'Reading ' , (fn := aStringOrFilename asFilename) baseName while:[
        [
            cs := ChangeSet fromFile: aStringOrFilename.
        ] on: ChangeSet::InvalidChangeChunkError do:[:ex|
            ex proceed.
        ].
        ((fn suffix = 'chg') or:[fn pathName = ObjectMemory nameForChanges]) ifTrue:[
            self list scrollToBottom: true.
            self showingRegularChangesetHolder value: true.
        ] ifFalse:[
            self showingRegularChangesetHolder value: false.
        ].
        self allowRemove: false."/true.
        self doOpen: cs.
    ].

    "Created: / 09-02-2012 / 19:11:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2012 / 11:38:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenNew
    self doOpen: ChangeSet new.
    self showFilterHolder value: false.
    self infoPanel
        reset;
        beInformation;
        message: (resources string:'Open file or drag''n''drop changes from other changeset/diff browser');
        addButtonWithLabel: (resources string:'Open File') action:[self doOpen];
        addButtonOK;
        show.

    "Modified: / 01-08-2012 / 18:36:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenNewWindow
    | new |

    new := self class new.
    new open.

    "Created: / 01-08-2012 / 18:22:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenOnSelection

    | selection |

    selection := ChangeSet new.
    self selectionDo: [:each|selection add: each].
    self class openOn: selection label: (self titleHolder value , ' ' , (resources string:'(Selected changes)'))

    "Modified: / 25-07-2012 / 15:31:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenSession
    "Opens a session changeset?"

    "/ Load a copy, so compress would not affect the original changeset
    self loadChangeSet: ChangeSet current copy.
    self allowRemove: true.

    "Modified: / 04-03-2015 / 18:18:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSave
    changesetFile isNil ifTrue:[
        self doSaveAs
    ] ifFalse:[
        self doSaveAs:changesetFile format: (self formatFromFile: changesetFile)  
    ]

    "Modified: / 05-03-2018 / 12:29:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSaveAs
    | file formatMap formatHolder |

    formatMap := Dictionary new
                at: (resources string: 'Smalltalk/X changeset') put: nil;
                at: (resources string: 'Smalltalk/X source') put: #classSource;
                at: (resources string: 'Bee Smalltalk changseset') put: #Bee;
                yourself.
    formatHolder := (formatMap keyAtValue: (self formatFromFile: changesetFile)) asValue.
    Dialog aboutToOpenBoxNotificationSignal handle:[:ex|
        | dialog |
        dialog := ex box application.
        dialog addComponent: (ComboListView new
                                list: formatMap keys asArray sort;
                                model: formatHolder;
                                yourself)
                    labeled: (resources string: 'Format:').
        ex pass.
    ] do:[
        file := Dialog requestFileName:'Select File for Save' default: (changesetFile ? 'somechanges.chg') pattern:('*.chg').
    ].
    file isNil ifTrue:[^self].
    self doSaveAs: file format: (formatMap at: formatHolder value)

    "Modified: / 27-12-2011 / 10:39:52 / cg"
    "Modified: / 05-03-2018 / 12:28:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSaveAs: newFile format: format
    | changesetToSave |

    changesetToSave := ChangeSet new.
    self list1Holder value do:[:e|
        e removed ~~ true ifTrue:[changesetToSave add:e].
    ].
    changesetToSave saveToFile: newFile format: format.
    changesetFile := newFile.

    "Created: / 05-03-2018 / 12:12:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doScrollToBottom

    | changeList |
    changeList := self list.
    changeList selection: { changeList list last }

    "Created: / 30-03-2012 / 16:56:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isStandalone
    ^ self window isApplicationSubView not

    "Modified: / 05-03-2018 / 09:38:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadChangeSet: aChangeSet
    self changesetHolder value: aChangeSet.
    self infoPanel hide.

    "Created: / 05-12-2009 / 13:43:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 27-07-2012 / 21:20:50 / cg"
    "Modified: / 04-03-2015 / 17:11:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadCurrentChangeFile
    self withWaitCursorDo:[
        self loadChangeSet: (ChangeSet fromFile: ObjectMemory nameForChanges)
    ].

    "Created: / 05-12-2009 / 13:44:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 27-07-2012 / 21:20:44 / cg"
!

menuUpdate
    self changesetChanged.
"/    list1 updateList.
"/    list2 updateList.
!

setTargetNamespace
    "specify an st/x namespace to be used as default"

    | nsName |

    nsName := Dialog
                requestNameSpace:'Namepace to load code into:'
                initialAnswer:targetNameSpaceName.
    nsName isEmptyOrNil ifTrue:[^self].

    targetNameSpaceName := nsName.
    "/ self targetNamespaceNameHolder value:('Target-Namespace: ',targetNamespace).

    list1 list do:[:each |
        each change nameSpaceOverride:nsName
    ].
    list2 list do:[:each |
        each change nameSpaceOverride:nsName
    ].
    self changeset do:[:chg | chg nameSpaceOverride:nsName].

    "Created: / 07-09-2011 / 12:49:42 / cg"
!

setTargetPackage
    "specify an st/x package identifier to be used as default"

    | package |

    package := Dialog
                requestProject:'Default Smalltalk/X package to load code into:'
                initialAnswer:targetPackage
                suggestions:(RecentTargetPackages ? #()).
    package isNil ifTrue:[^self].

    RecentTargetPackages isNil ifTrue:[
        RecentTargetPackages := OrderedCollection new.
    ].
    RecentTargetPackages remove:package ifAbsent:[].
    RecentTargetPackages addFirst:package.

    targetPackage := "lastPackage := "package.
    "/ self targetPackageHolder value:('Target-Package: ',targetPackage).

    "Created: / 07-09-2011 / 12:47:15 / cg"
! !

!ChangeSetBrowser2 methodsFor:'menu actions - changes'!

changeMenuApply: changeList
    | changesToApply changeIdx |

    changesToApply := OrderedCollection new.
    self changesDo:[:chg|chg removed ifFalse:[changesToApply add: chg]].
    self changeMenuApplyChanges: changesToApply.
    "Advance to next change"
    changeIdx := changeList list findFirst: [:each | each change == changesToApply last ].
    changeIdx <= changeList list size ifTrue:[
        changeIdx := changeIdx min: changeList list size.
        changeList selection: { changeList list at: (changeIdx + 1 min: changeList list size)}
    ] ifFalse:[ 
        changeList redrawListItemAt: changeIdx.
    ].

    (list2 notNil and:[changeList ~~ list2]) ifTrue:[
        "/ to get the =-icons
        list2 redrawList
    ].

    "Created: / 04-08-2011 / 17:26:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2011 / 15:49:00 / cg"
    "Modified: / 25-04-2015 / 22:17:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-05-2017 / 17:04:16 / jv"
!

changeMenuApplySelection: changeList

    changeList selection do:[:change|
        self changeMenuApplyChange:change change.
        self selectChangeAfter: change change in: changeList.
    ].

    "Created: / 04-08-2011 / 17:27:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 28-12-2011 / 15:48:53 / cg"
    "Modified: / 04-03-2016 / 15:58:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuApplyToEnd: changeList
    | start stop list |

    list := changeList list.
    start := changeList selectionIndices max.
    stop  := list size.

    start to: stop do:[:idx|
        | chg |

        chg := list at: idx.
        changeList selection: { chg }.
        self changeMenuApplyChange:chg change.
    ].
    changeList redrawListItemAt: stop.

    list2 notNil ifTrue:[
        "/ to get the =-icons
        list2 updateList
    ].

    "Created: / 04-08-2011 / 17:27:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 27-12-2011 / 10:53:00 / cg"
    "Modified: / 21-05-2015 / 13:41:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuBrowse: changeList
    |changes methods classes|

    changes := self selectedChangesIn: changeList.
    "/ changes := changeList listHolder value collect:[:c | c change].

    (changes conform:[:c | c isClassDefinitionChange]) ifTrue:[
        classes := (changes collect:[:c | c changeClass]).
        UserPreferences systemBrowserClass 
            browseClasses:classes label:'selected monticello classes'.
    ] ifFalse:[
        methods := OrderedCollection new.
        changes do:[:each |
            each isCompositeChange ifTrue:[
                each changes do:[:each2 | each2 isMethodChange ifTrue:[ methods add:each2 changeMethod ]]
            ] ifFalse:[
                each isMethodChange ifTrue:[
                    methods add:(each changeMethod).
                ]
            ]
        ].
        (methods includes:nil) ifTrue:[
            Dialog warn:('%1 methods are not present in the image' bindWith:(methods occurrencesOf:nil)).
            methods := methods reject:[:m | m isNil].
            methods isEmpty ifTrue:[^ self].
        ].
        UserPreferences systemBrowserClass 
            browseMethods:methods title:'selected monticello methods' sort:false.
    ].

    "Created: / 04-08-2011 / 17:27:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-07-2012 / 13:13:37 / cg"
    "Modified: / 13-11-2013 / 11:49:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuBrowseClass: changeList
    |changes classes addThemChanges cls|

    changes := self selectedChangesIn: changeList.

    classes := Set new.
    addThemChanges := 
        [:c |
            c isClassDefinitionChange ifTrue:[
                classes add:c changeClass theNonMetaclass
            ] ifFalse:[
                c isMethodChange ifTrue:[
                    cls := c changeMethod isNil
                                ifTrue:[ c changeClass ]
                                ifFalse:[ c changeMethod mclass theNonMetaclass ].
                    classes add:cls
                ] ifFalse:[
                    c isCompositeChange ifTrue:[
                        c changes do:addThemChanges
                    ]
                ]
            ]
        ].
    changes do:addThemChanges.

    UserPreferences systemBrowserClass 
        browseClasses:classes label:'selected monticello classes'.

    "Created: / 04-08-2011 / 17:27:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 05-09-2011 / 16:08:35 / cg"
!

changeMenuCompareClass: changeList
    |changes classNames classNameToClassMapping lastNameSpace
     addClassName addThemChanges existingClasses
     allChanges changeSet1 changeSet2 diffSet|

    changes := self selectedChangesIn: changeList.

    classNameToClassMapping := Dictionary new.
    classNames := Set new.
    allChanges := ChangeSet new.
    existingClasses := Set new.

    addClassName :=
        [:nmArg |
            |nm ns existingClass goodAnswer cls|

            nm := nmArg.
            existingClass := Smalltalk classNamed:nm.

            existingClass notNil ifTrue:[
                goodAnswer := nm
            ] ifFalse:[
                ns := NameSpace allNameSpaces
                                    detect:[:ns | (ns classNamed:nm) notNil ]
                                    ifNone:nil.
                ns notNil ifTrue:[
                    goodAnswer := (ns classNamed:nm) name.
                ] ifFalse:[
                    goodAnswer := nm.
                    (lastNameSpace notNil
                        and:[ lastNameSpace isNameSpace
                        and:[(cls := lastNameSpace classNamed:nm) notNil ]]
                    ) ifTrue:[
                        goodAnswer := cls name.
                    ] ifFalse:[
                        (lastNameSpace notNil
                            and:[ lastNameSpace isBehavior
                            and:[(cls := lastNameSpace privateClassesAt:nm asSymbol) notNil ]]
                        ) ifTrue:[
                            goodAnswer := cls name.
                        ]
                    ].
                ].
            ].
            nm := Dialog
                    request:('Class to compare for "%1"?' bindWith:nmArg)
                    initialAnswer:goodAnswer.
            nm isNil ifTrue:[^ self].
            nm notEmpty ifTrue:[
                existingClass := Smalltalk at:nm asSymbol.
            ].
            existingClass notNil ifTrue:[
                classNameToClassMapping at:nmArg put:existingClass.
                existingClasses add:existingClass.
            ].
            classNames add:nmArg
        ].

    addThemChanges := [:changes |
        "/ collect classes and mappings
        changes do:[:c |
            c isClassDefinitionChange ifTrue:[
                addClassName value:(c className).
                allChanges add:c.
            ]].

        changes do:[:c |
            c isMethodChange ifTrue:[
                (classNames includes:(c className)) ifFalse:[
                    addClassName value:(c className).
                ].
                allChanges add:c.
            ]].

        changes do:[:c |
            c isCompositeChange ifTrue:[
                addThemChanges value:(c changes)
            ].
        ].
    ].

    changes do:addThemChanges.

    "/ now, build a diffset and present it...
    changeSet1 := allChanges.
    changeSet2 := ChangeSet new.
    existingClasses do:[:cls |
        changeSet2 addAll:(ChangeSet forExistingClass:cls).
    ].
    diffSet := changeSet1 diffSetsAgainst:changeSet2.

    (UserPreferences versionDiffViewerClass)
        openOnDiffSet:diffSet
        labelA:'Monticello'
        labelB:'Current (In Image)'
        title:'Diffs'
        ignoreExtensions:false.

    "Created: / 04-08-2011 / 17:27:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 01-12-2011 / 18:36:44 / cg"
!

changeMenuDeleteSelection: changeList

    changeList selection do:[:change|self changeMenuDeleteChange:change change].
    changeList updateList.
    (list2 notNil and:[changeList ~~ list2]) ifTrue:[
        "/ to get the =-icons
        list2 updateList
    ].

    "Created: / 04-08-2011 / 17:28:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuDeleteSelectionInverted: changeList
    | sel |

    sel := changeList selection ? #().
    changeList list do:[:change|
        (sel includes: change) ifFalse:[
            self changeMenuDeleteChange:change change
        ].
    ].
    changeList updateList.
    (list2 notNil and:[changeList ~~ list2]) ifTrue:[
        "/ to get the =-icons
        list2 updateList
    ].

    "Created: / 17-05-2012 / 22:55:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuDeleteToEnd: changeList
    |lastIdx|

    lastIdx := changeList selectionIndices max.
    changeList list from:lastIdx do:[:change | self changeMenuDeleteChange:change change].
    list2 notNil ifTrue:[
        "/ to get the =-icons
        list2 updateList
    ].

    "Created: / 27-12-2011 / 10:53:00 / cg"
    "Created: / 30-03-2012 / 12:22:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuInspect: changeList

    changeList selection size == 1 ifTrue:[
        changeList selection anyOne change inspect
    ] ifFalse:[
        (changeList selection collect:[:each|each change]) inspect
    ]

    "Created: / 04-08-2011 / 17:28:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuInspectChangeset: changeList
    self changesetHolder value inspect.

    "Created: / 04-08-2011 / 17:28:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectAdditions: changeList

    self changeMenuSelectIn: changeList suchThat:[:change|change delta = #+]

    "Created: / 04-08-2011 / 17:29:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectAll: changeList

    self changeMenuSelectIn: changeList suchThat:[:change|true]

    "Created: / 04-08-2011 / 17:29:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectClassInitializeDoIts: changeList

    self changeMenuSelectIn: changeList suchThat:[:changeEntry|
        | change |

        change :=  changeEntry change.
        change isDoIt 
            and:[change source endsWith: ' initialize']
    ]

    "Created: / 13-11-2013 / 18:40:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectCopyrightMethods: changeList

    self changeMenuSelectIn: changeList suchThat:[:changeEntry|
        | change |

        change :=  changeEntry change.
        change isMethodCodeChange 
            and:[change selector == #copyright
            and:[change isForMeta]]
    ]

    "Created: / 12-11-2013 / 17:22:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectDifferences: changeList

    self changeMenuSelectIn: changeList suchThat:[:change|change delta = #~]

    "Created: / 04-08-2011 / 17:29:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectInversion: changeList

    | oldSel newSel |
    oldSel := changeList selection.
    newSel := OrderedCollection new.
    changeList list do:[:change|
        (oldSel includes: change) ifFalse:[
            newSel add: change.
        ]
    ].
    changeList selection: newSel.

    "Created: / 17-05-2012 / 23:03:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectNone: changeList

    self changeMenuSelectIn: changeList suchThat:[:change|false]

    "Created: / 04-08-2011 / 17:30:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectRemovals: changeList

    self changeMenuSelectIn: changeList suchThat:[:change|change delta = #-]

    "Modified: / 29-10-2010 / 13:18:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 04-08-2011 / 17:35:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectSame: changeList

    self changeMenuSelectIn: changeList suchThat:[:change|change delta = #=]

    "Modified: / 29-10-2010 / 13:18:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 04-08-2011 / 17:35:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectUsingBlock: changeList

    |conditionBlockString conditionBlock dialog textHolder template|

    template :=
'[:change|
     "/ Define condition for selection below:
     "/ change is an instance of Change
     "/ change will be selected if and only if block returns true


     true"/always select the change
]
'.

    LastSelectionConditionString isNil ifTrue:[
        LastSelectionConditionString := template.
    ].


    textHolder := ValueHolder new.
    dialog := Dialog
                 forRequestText:(resources string:'Enter condition for selection')
                 lines:20
                 columns:70
                 initialAnswer:LastSelectionConditionString
                 model:textHolder.
    dialog addButton:(Button label:'Template' action:[textHolder value:template. textHolder changed:#value.]).
    dialog open.
    dialog accepted ifFalse:[^ self].

    conditionBlockString := textHolder value.
    LastSelectionConditionString := conditionBlockString.

    conditionBlock := Parser evaluate:conditionBlockString.
    conditionBlock isBlock ifFalse:[
        self error:'Bad selection block (syntax error?)'.
        ^ self
    ].

    self changeMenuSelectIn: changeList suchThat: [:change|conditionBlock value: change change].

    "Created: / 04-08-2011 / 17:42:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2013 / 17:13:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectVersionMethods: changeList

    self changeMenuSelectIn: changeList suchThat:[:changeEntry|
        | change |

        change :=  changeEntry change.
        change isMethodCodeChange 
            and:[((AbstractSourceCodeManager isVersionMethodSelector: change selector) or:[AbstractSourceCodeManager isExtensionsVersionMethodSelector:change selector])
            and:[change isForMeta]]
    ]

    "Created: / 12-11-2013 / 17:22:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuUndeleteSelection: changeList

    self selectionDo:[:chg|chg removed: false]

    "Modified: / 29-10-2010 / 13:53:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 04-08-2011 / 17:42:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedChangesIn: changeList
    |changes|

    changes := (changeList == list1
                    ifTrue:[ selection1Holder ]
                    ifFalse:[ selection2Holder ]) value.
    ^ changes collect:[:eachListEntry | eachListEntry change].

    "Created: / 23-07-2012 / 13:13:11 / cg"
! !

!ChangeSetBrowser2 methodsFor:'menu actions - changes - helpers'!

changeMenuApplyChange: aChange

"/    aChange isClassDefinitionChange ifTrue:
"/        [(Smalltalk at: aChange superClassName asSymbol)
"/            ifNil:[^self error: 'Nil superclass']].

    | nsQueries packageQueries hasMC apply innerApply innerApply2 targetNameSpace |

    aChange removed ifTrue:[ ^ self ].

    nsQueries := Class nameSpaceQuerySignal.
    packageQueries := Class packageQuerySignal.
    hasMC := ConfigurableFeatures includesFeature:#MonticelloSupport.
    hasMC ifTrue:[
        nsQueries := nsQueries , MCStXNamespaceQuery.
        packageQueries := packageQueries , MCStXPackageQuery.
    ].

    apply := 
        [
            targetNameSpaceName notNil ifTrue:[ 
                aChange applyWithNameSpaceOverride: targetNameSpaceName
            ] ifFalse:[ 
                aChange apply
            ].
        ].

    targetNameSpaceName notNil ifTrue:[
        targetNameSpace := NameSpace name: targetNameSpaceName.
        innerApply := apply.
        apply := [
            nsQueries answer: targetNameSpace do:innerApply.
        ]
    ].

    hasMC ifTrue:[
        innerApply2 := apply.
        apply := 
            [
                MCInteractiveLoadingQuery answer: true do: innerApply2
            ].
    ].

    self withWaitCursorDo:[
        updateChangeFileHolder value ifTrue:[
            packageQueries answer: self targetPackage do: apply            
        ] ifFalse:[
            Class updateChangeFileQuerySignal answer: false do:[
                packageQueries answer: self targetPackage do: apply
            ]
        ].                              
    ].

    "Modified: / 07-09-2011 / 22:24:57 / cg"
    "Modified: / 04-02-2014 / 18:27:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuApplyChanges: changesToApply
    | changesThatFailToApply |

    changesThatFailToApply := ChangeSet new.
    ProgressIndicator
        displayProgress:'Applying changes...'
        at:(Screen default centerOfMonitorHavingPointer)
        from:200 to:400
        during:[:val |
            1 to: changesToApply size do:[:i|
                |change|

                change := changesToApply at: i.
                val value:((100 / changesToApply size) * i) rounded.
                [
                    self changeMenuApplyChange: change
                ] on: Error do:[
                    changesThatFailToApply add: change
                ]
            ]
        ]

    "Created: / 04-08-2011 / 17:26:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuApplyChanges: changesToApply in: changeList
    changesToApply notEmpty ifTrue:[ 
        self changeMenuApplyChanges: changesToApply.
        self selectChangeAfter: changesToApply last in: changeList.
    ].

    "Created: / 04-03-2016 / 15:54:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuDeleteChange: change

    change removed: true

    "Created: / 30-03-2012 / 12:22:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeMenuSelectIn: changeList suchThat:conditionBlock

    | sel |
    sel := OrderedCollection new.
    changeList listHolder value do: [:chg|(conditionBlock value: chg) ifTrue:[sel add: chg]].
    changeList selectionHolder value: sel.

    "Created: / 04-08-2011 / 17:29:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2013 / 17:12:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2 methodsFor:'private'!

changesDo:aBlock
    self changeset do:aBlock.

    "Created: / 30-08-2011 / 14:30:58 / cg"
!

formatFromFile: aFilename
    "Guess and return format of given changefile."
    aFilename notNil ifTrue:[ 
        | suffix |

        suffix := aFilename asFilename suffix.
        suffix = '.chg' ifTrue:[ ^ nil ].
        suffix = '.ch' ifTrue:[ ^ #Bee  ].    
        suffix = '.st' ifTrue:[ ^ #classSource ].    
    ].
    ^ nil

    "Created: / 05-03-2018 / 12:28:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getNavigatorChangeSet

    | changeset |
    changeset := changesetHolder value. "/deepCopy.
    (changeset isKindOf: ChangeSet) ifFalse:
        [changeset := ChangeSet withAll: changeset].

    ^ (self navigatorSpecHolder value ~~ #oneColumnNavigatorSpec) ifTrue:[
        changeset groupByClass
    ] ifFalse:[
        changeset flatten
    ]

    "Created: / 24-10-2009 / 19:31:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 17:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

iconSelectorForChange:aChange
    |currentMethod|

    targetPackage notNil ifTrue:[
        aChange isMethodChange ifTrue:[
            (currentMethod := aChange changeMethod) notNil ifTrue:[
                currentMethod package ~= targetPackage ifTrue:[
                    ^ #iconExcla
                ]
            ]
        ].
    ].
    ^ nil.
!

list
    "Returns list to operate on"

    ^self isTwoColumn ifTrue:[list2] ifFalse:[list1]

    "Created: / 30-03-2012 / 12:02:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawChangeListViews

    list1 notNil ifTrue:[
        list1 builder window allSubViewsDo: [:v|v redraw]
    ].
    list2 notNil ifTrue:[
        list2 builder window allSubViewsDo: [:v|v redraw]
    ].

    "Created: / 16-03-2011 / 22:41:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectChangeAfter: change in: changeList
    "Advance to next change"
    | changeIdx |

    changeIdx := changeList list findFirst:[:changeItem | changeItem change ==  change ] ifNone:[ ^ self ].
    changeIdx < changeList list size ifTrue:[
        changeList selection: { changeList list at: changeIdx + 1 }
    ] ifFalse:[ 
        changeList redrawListItemAt: changeIdx.
    ].

    "Created: / 04-03-2016 / 15:52:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectionDo: aBlock

    | applyBlock |

    applyBlock := [:e|aBlock value: e change].

"/    selectionHolder value isEmptyOrNil ifTrue:[
"/        (self navigatorChangesetHolder value ? #()) do: aBlock
"/    ] ifFalse:[
        selection2Holder value isEmptyOrNil not
            ifTrue:[selection2Holder value do: [:e|e notNil ifTrue:[applyBlock value:e]]]
            ifFalse:[selection1Holder value do: [:e|e notNil ifTrue:[applyBlock value:e]]].
"/    ].
    self redrawChangeListViews

    "Created: / 29-10-2010 / 13:47:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2012 / 17:16:40 / cg"
    "Modified: / 18-05-2012 / 09:05:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showProgress: label while: block

    self infoPanel progress: label while: [
        [
            self isWorkingHolder value: true.
            block value
        ] ensure:[
            self isWorkingHolder value: false.
        ]
    ]

    "Created: / 10-02-2012 / 10:35:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showSource: aBoolean
    | panel |

    "Not yet implemented"

    ^self.

"/ cg: but what is it supposed to do???
"/    sourceView ifNil:[^self].
"/    panel := builder componentAt: #VerticalPanel.
"/    aBoolean ifTrue:[
"/        (panel subViews includes: sourceView) ifTrue:[^self].
"/        panel addSubView: sourceView.
"/    ] ifFalse:[
"/        (panel subViews includes: sourceView) ifFalse:[^self].
"/        panel removeSubView: sourceView.
"/        sourceView setId: nil.
"/    ]

    "Created: / 11-07-2011 / 16:06:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-07-2012 / 17:44:01 / cg"
!

targetPackage
    ^ targetPackage ? PackageId noProjectID

    "Created: / 07-09-2011 / 20:12:04 / cg"
! !

!ChangeSetBrowser2 methodsFor:'queries'!

canApplyChanges

    ^true

    "Created: / 29-10-2010 / 13:07:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canDrop: somethign

    self breakPoint:#jv.

    "Created: / 20-03-2011 / 21:34:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 20:21:15 / cg"
!

hasChangeSelectedAndNotRemoved: changeList

    | sel |
    sel := changeList selection.
    sel isEmptyOrNil ifTrue:[^false].
    ^(sel anySatisfy:[:each|each removed]) not

    "Modified: / 24-07-2011 / 06:52:28 / cg"
    "Created: / 04-08-2011 / 18:23:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSingleChangeSelectedAndCanBrowse: changeList
    | sel |

    sel := changeList selection.
    sel isEmptyOrNil ifTrue:[^false].
    ^true

    "Created: / 04-08-2011 / 18:25:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSingleChangeSelectedAndCanBrowseClass: changeList
    | sel |

    sel := changeList selection.
    sel isEmptyOrNil ifTrue:[^false].
    ^ sel contains:[:entry | entry change isOrContainsClassDefinitionChange ]. 
! !

!ChangeSetBrowser2 methodsFor:'testing'!

isHierarchical

    ^self navigatorSpecHolder == #hierarchicalNavigatorSpec

    "Modified: / 14-10-2010 / 15:52:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 30-03-2012 / 11:59:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isOneColumn

    ^self navigatorSpecHolder value == #oneColumnNavigatorSpec

    "Modified: / 14-10-2010 / 15:52:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 30-03-2012 / 11:59:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTwoColumn

    ^self navigatorSpecHolder == #twoColumnNavigatorSpec

    "Modified: / 14-10-2010 / 15:51:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 30-03-2012 / 11:59:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2::ChangeEditor class methodsFor:'documentation'!

documentation
"
    A simple, embeddable window to show a single change.
    If readonlyHolder's value is false, then user is
    allowed to edit the change (i.e., modify the source code)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    Tools::ChangeEditor open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for
    ... executable example here ...
                                                                [exEnd]
"
! !

!ChangeSetBrowser2::ChangeEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetBrowser2::ChangeEditor andSelector:#windowSpec
     Tools::ChangeSetBrowser2::ChangeEditor new openInterface:#windowSpec
     Tools::ChangeSetBrowser2::ChangeEditor open
    "

    <resource: #canvas>

    ^
     #(FullSpec
        name: windowSpec
        window:
       (WindowSpec
          label: 'Change Editor'
          name: 'Change Editor'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 579 341)
        )
        component:
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'TextDiffTool'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              majorKey: #'Tools::TextDiff2Tool'
              minorKey: windowSpecForEmbedding
              subAspectHolders:
             (Array

               (SubChannelInfoSpec
                  subAspect: classHolder
                  aspect: classAspect
                )
               (SubChannelInfoSpec
                  subAspect: codeAspectHolder
                  aspect: codeAspect
                )

               (SubChannelInfoSpec
                  subAspect: labelAHolder
                  aspect: labelAHolder
                )
               (SubChannelInfoSpec
                  subAspect: labelBHolder
                  aspect: labelBHolder
                )

               (SubChannelInfoSpec
                  subAspect: showDiffHolder
                  aspect: showdiffHolder
                )
               (SubChannelInfoSpec
                  subAspect: textAHolder
                  aspect: sourceChangeHolder
                )

               (SubChannelInfoSpec
                  subAspect: textBHolder
                  aspect: sourceImageHolder
                )
              )
              createNewApplication: true
              createNewBuilder: true
            )
           )

        )
      )

    "Modified: / 16-03-2012 / 13:08:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2::ChangeEditor methodsFor:'accessing'!

sourceChangeHolder
    ^ sourceChangeHolder
!

sourceChangeHolder:something
    sourceChangeHolder := something.
!

sourceImageHolder
    ^ sourceImageHolder
!

sourceImageHolder:something
    sourceImageHolder := something.
! !

!ChangeSetBrowser2::ChangeEditor methodsFor:'aspects'!

changeHolder
    "return/create the 'changeHolder' value holder (automatically generated)"

    changeHolder isNil ifTrue:[
        changeHolder := ValueHolder new.
        changeHolder addDependent:self.
    ].
    ^ changeHolder
!

changeHolder:something
    "set the 'changeHolder' value holder (automatically generated)"

    |oldValue newValue|

    changeHolder notNil ifTrue:[
        oldValue := changeHolder value.
        changeHolder removeDependent:self.
    ].
    changeHolder := something.
    changeHolder notNil ifTrue:[
        changeHolder addDependent:self.
    ].
    newValue := changeHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:changeHolder.
    ].
!

classAspect

    ^(AspectAdaptor forAspect: #changeClass)
        subjectChannel: self changeHolder

    "Created: / 29-11-2011 / 11:21:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAspect

    ^BlockValue
        with: [:change|
            change isMethodCodeChange
                ifTrue:[ SyntaxHighlighter codeAspectMethod ]
                ifFalse:[ SyntaxHighlighter codeAspectExpression ]
        ] argument: self changeHolder

    "Created: / 29-11-2011 / 11:21:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2012 / 22:03:31 / cg"
!

labelAText

    ^'Change'

    "Created: / 27-11-2011 / 14:59:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

labelBText

    ^'Current (in image)'

    "Created: / 27-11-2011 / 14:59:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readonlyHolder
    "return/create the 'readonlyHolder' value holder (automatically generated)"

    readonlyHolder isNil ifTrue:[
        readonlyHolder := ValueHolder new.
        readonlyHolder addDependent:self.
    ].
    ^ readonlyHolder
!

readonlyHolder:something
    "set the 'readonlyHolder' value holder (automatically generated)"

    |oldValue newValue|

    readonlyHolder notNil ifTrue:[
        oldValue := readonlyHolder value.
        readonlyHolder removeDependent:self.
    ].
    readonlyHolder := something.
    readonlyHolder notNil ifTrue:[
        readonlyHolder addDependent:self.
    ].
    newValue := readonlyHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:readonlyHolder.
    ].
!

showdiffHolder
    "return/create the 'showdiffHolder' value holder (automatically generated)"

    showdiffHolder isNil ifTrue:[
        showdiffHolder := ValueHolder new.
    ].
    ^ showdiffHolder
!

showdiffHolder:something
    "set the 'showdiffHolder' value holder (automatically generated)"

    showdiffHolder := something.
! !

!ChangeSetBrowser2::ChangeEditor methodsFor:'change & update'!

changeChanged
    "changeHolder has changed, update sources etc..."

    | change |

    change := changeHolder value.

    sourceChangeHolder value: change changeSource.
    sourceImageHolder value: change imageSource.

    "Created: / 29-11-2011 / 11:15:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-07-2012 / 17:39:48 / cg"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."


    changedObject == changeHolder ifTrue:[
         self changeChanged.
         ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 29-11-2011 / 11:15:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetBrowser2 class methodsFor:'documentation'!

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

