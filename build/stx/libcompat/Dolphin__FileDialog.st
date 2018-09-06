"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

Object subclass:#FileDialog
	instanceVariableNames:'caption defaultExtension fileTypes value'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!FileDialog class methodsFor:'queries'!

allFilesType
    ^ #('All Files (*.*)' '*.*')
! !

!FileDialog methodsFor:'setup'!

caption:aTitle
    caption := aTitle.

    "
     self new
        caption:'Select a file'
    "
!

defaultExtension:aString
    defaultExtension := aString

    "
     self new
        defaultExtension:'st'
    "
!

fileTypes:descriptions
    "each descriptions element consists of 2 elements:
        a textual description
        a matchPattern (usually on the suffix)"

    fileTypes := descriptions

    "
     self new
        fileTypes:(Array
                        with: #('PalmOS Resource Databases (*.prc)' '*.prc')
                        with: #('Smalltalk source files (*.st)' '*.st')
                        with: FileDialog allFilesType)
    "
!

value:aString
    value := aString

    "
     self new
        value:'st'
    "
! !

!FileDialog methodsFor:'startup'!

showModal
    |default|

    value notNil ifTrue:[
        default := value asFilename withSuffix:defaultExtension.
    ].

    ^ Dialog
        requestFileName:caption
        default:default
        ifFail:nil "/ failReturn
        pattern:defaultExtension
        fromDirectory:(FileSelectionBox lastFileSelectionDirectory) "/ dir.

    "
     FileOpenDialog new
            fileTypes:Package packageFileDialogTypes;
            defaultExtension: 'st';
            value: 'foo';
            caption: 'Open File: foo';
            showModal
    "

    "
     FileOpenDialog new
            fileTypes:Package packageFileDialogTypes;
            value: 'foo';
            caption: 'Open File: foo';
            showModal
    "

    "Modified (comment): / 08-06-2017 / 14:01:08 / mawalch"
! !

!FileDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__FileDialog.st,v 1.3 2017-06-08 12:02:04 mawalch Exp $'
!

version_SVN
    ^ '$Id: Dolphin__FileDialog.st,v 1.3 2017-06-08 12:02:04 mawalch Exp $'
! !

