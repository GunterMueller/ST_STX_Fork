"
 COPYRIGHT (c) 2002 by eXept Software AG
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

ApplicationModel subclass:#AbstractFileBrowser
	instanceVariableNames:'aspects'
	classVariableNames:'CommandHistory CommandHistorySize DefaultCommandPerSuffix
		DefaultFilters DirectoryBookmarks LastEnforcedNameSpace
		LastFileDiffDirectory LastFileDiffFile LastFileSelection
		LastMercurialRepository LastMoveDestination LastMustMatchPattern
		LastScriptBlockString RootHolder RuntimeAspects
		VisitedDirectories'
	poolDictionaries:''
	category:'Interface-Tools-File'
!

AbstractFileBrowser class instanceVariableNames:'DisabledCursorImage EnabledCursorImage'

"
 The following class instance variables are inherited by this class:

	ApplicationModel - ClassResources
	Model - 
	Object - 
"
!

Object subclass:#Clipboard
	instanceVariableNames:'method files'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractFileBrowser
!

Object subclass:#CodeExecutionLock
	instanceVariableNames:'locked'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractFileBrowser
!

List subclass:#DirectoryHistory
	instanceVariableNames:'forwardList backList lastWasForwardPath lastBackPath lastAddPath
		backForwardList backForwardIndex historySize'
	classVariableNames:'HistorySize'
	poolDictionaries:''
	privateIn:AbstractFileBrowser
!

Object subclass:#DirectoryHistoryItem
	instanceVariableNames:'path position'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractFileBrowser::DirectoryHistory
!

Object subclass:#SaveAspectItem
	instanceVariableNames:'value isHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractFileBrowser
!

!AbstractFileBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    [Author:]
        Christian Penk

    Notice: this certainly needs a redesign - all those abstract-abstract classes which
    define stuff which is only needed in some parts makes this hard to understand.
    Especially the fact, that AbstractFileBrowser defines things both as abstract superclass
    and as a container is almost incomprehensable...
"
! !

!AbstractFileBrowser class methodsFor:'accessing'!

currentSelection

    LastFileSelection isNil ifTrue:[
        LastFileSelection := #().
    ].
    ^ LastFileSelection
!

currentSelection:aFilenameCol
    aFilenameCol notEmptyOrNil ifTrue:[
        LastFileSelection := aFilenameCol collect:[:file | (file ? '') asFilename]
    ]
!

directoryHistory

    VisitedDirectories isNil ifTrue:[
        VisitedDirectories := self directoryHistoryClass new.
        "/ VisitedDirectories inspect.
    ].
    ^ VisitedDirectories

    "Modified: / 21-11-2012 / 08:45:49 / cg"
!

resetClassVars
    VisitedDirectories := nil.
    LastFileSelection := nil.

    "
     AbstractFileBrowser resetClassVars
    "

    "Modified: / 21-11-2012 / 08:45:53 / cg"
!

rootHolder

    ^ RootHolder
!

rootHolder:aRoot

    RootHolder := aRoot
! !

!AbstractFileBrowser class methodsFor:'accessing-bookmarks'!

addBookmark:aDirectoryPath
    "add aDirectoryPath to the list of our known bookmarks.
     Do not add duplicates."

    |bookmarks|

    bookmarks := self directoryBookmarks.
    (bookmarks includes:aDirectoryPath) ifFalse:[
        bookmarks add:aDirectoryPath asFilename.
    ].
!

bookmarksFrom:aFileNameOrString
    |bookmarks s fileName line|

    fileName := aFileNameOrString asFilename.
    [
        s := fileName readStream.
    ] on:OpenError do:[:ex|
        ^ nil.
    ].

    bookmarks := OrderedCollection new.
    [s atEnd] whileFalse:[
        line := s nextLine.
        (line startsWith:';') ifFalse:[
            bookmarks add:(Base64Coder decode:line) asString.
        ]
    ].
    s close.

    ^ bookmarks
!

defaultBookMarksFileDirectory
    "the directory, where the default bookmarks are stored (as defaultBookMarksFilename)"

    ^ Filename homeDirectory
!

defaultBookMarksFilename
    "the filename, in which the default bookmarks are stored (in defaultBookMarksDirectory)"

    ^ '.fileBrowserBookmarks'
!

directoryBookmarks
    DirectoryBookmarks isNil ifTrue:[                     
        self loadBookmarksFrom:(self defaultBookMarksFileDirectory construct:self defaultBookMarksFilename).

        DirectoryBookmarks isEmptyOrNil ifTrue:[
            DirectoryBookmarks := OrderedCollection new.
            DirectoryBookmarks add:Filename homeDirectory asAbsoluteFilename.
            DirectoryBookmarks add:Filename currentDirectory asAbsoluteFilename.
        ]
    ].
    ^ DirectoryBookmarks

    "
     DirectoryBookmarks := nil.
     self directoryBookmarks.
    "
!

directoryBookmarks: collectionOfFilenames

    DirectoryBookmarks := collectionOfFilenames.
    self saveBookmarksInDefaultBookmarksFile.
!

editBookmarksWithDefault: aFilenameOrNil
    | oldBookmarks newBookmarks |

    oldBookmarks := self directoryBookmarks copy.
    newBookmarks := BookmarksEditDialog openWith: oldBookmarks defaultBookmark: aFilenameOrNil.
    newBookmarks isNil ifTrue:[^ self].
    self directoryBookmarks: newBookmarks.

    "Modified: / 13-01-2011 / 12:52:28 / cg"
!

hasBookmarks
    ^ self directoryBookmarks notEmptyOrNil
!

loadBookmarksFrom:aFileNameOrString
    |bookmarks|

    bookmarks := self bookmarksFrom: aFileNameOrString.
    bookmarks isNil ifTrue:[^ self].

    DirectoryBookmarks := OrderedCollection new.
    bookmarks do:[:eachPath |
        self addBookmark:eachPath asFilename
    ].
!

removeBookmark:aDirectoryPath
    |bookmarks|

    bookmarks := self directoryBookmarks.
    bookmarks isEmptyOrNil ifTrue:[ ^ self].

    bookmarks remove:aDirectoryPath ifAbsent:[].
!

saveBookmarks
    |fn|

    fn := Dialog 
            requestFileNameForSave:(self resources string:'Save Bookmarks')
            default:(self defaultBookMarksFilename)
            fromDirectory:(self defaultBookMarksFileDirectory).
    fn isEmptyOrNil ifTrue:[^ self].

    self saveBookmarksIn:fn

    "Modified: / 27-10-2010 / 11:27:09 / cg"
!

saveBookmarks: bookmarks in:aFileNameOrString
    "save the bokmarks in aFileNameOrString.
     Use Base64 coding"

    |bookmarkStream fileName coder|

    fileName := aFileNameOrString asFilename.
    fileName exists ifTrue:[
        fileName renameTo:(fileName addSuffix:'sav').
    ].
    bookmarkStream := fileName writeStream.

    "save each bookmark in one line"
    coder := (Base64Coder on:bookmarkStream) lineLimit:nil.
    bookmarks do:[:eachPath |
        eachPath asFilename pathName acceptVisitor:coder.
        coder flush.
        bookmarkStream cr.
    ].
    bookmarkStream syncData; close.
!

saveBookmarksIn:aFileNameOrString
    "save the bokmarks in aFileNameOrString.
     Use Base64 coding"

    | bookmarks |

    bookmarks := self directoryBookmarks.
    self saveBookmarks: bookmarks in:aFileNameOrString
!

saveBookmarksInDefaultBookmarksFile
    self saveBookmarksIn:(self defaultBookMarksFileDirectory construct:self defaultBookMarksFilename)
! !

!AbstractFileBrowser class methodsFor:'accessing-classes'!

directoryHistoryClass
    ^ DirectoryHistory

    "Modified: / 21-11-2012 / 08:46:34 / cg"
! !

!AbstractFileBrowser class methodsFor:'defaults'!

commandHistory

    CommandHistory isNil ifTrue:[
        CommandHistory := OrderedCollection new.
    ].
    ^ CommandHistory
!

commandHistorySize
    "max no of entries in the HistoryList "

    CommandHistorySize isNil ifTrue:[
        CommandHistorySize := 150
    ].
    ^ CommandHistorySize
!

defaultFilterList

    DefaultFilters isNil ifTrue:[
        DefaultFilters := #(        '*'
                                    '*.st' 
                                    '*.[h,c]*' 
                                    '*.txt; *.htm*' 
                                    '*.gif; *.xpm; *.jpg; *.png' 
                                    '~*o; ~*.obj; ~*.dll;' 
                                )
    ].
    ^ DefaultFilters.

    "
     DefaultFilters := nil
    "
!

initialCommandFor:fileName in:aDirectory intoBox:aBox
    "set a useful initial command in an execute box."

    |mime cmd select path suffix baseName pathName|

    path := aDirectory filenameFor:fileName.
    baseName := path baseName.
    suffix := path suffix.

    cmd := UserPreferences current defaultFileOpenCommandFor:suffix.
    cmd notNil ifTrue:[
        aBox initialText:(cmd bindWith:fileName pathName).
        ^ self
    ].
    
    mime := MIMETypes mimeTypeForSuffix:suffix.
"/    mime notNil ifTrue:[
"/        cmd := self initialCommandForMIME:mime file:path
"/    ].

    "/ XXX should be changed to take stuff from a config file
    "/ XXX or from resources.

    (path type == #regular) ifTrue:[
        path isExecutableProgram ifTrue:[
            aBox initialText:(path pathName , ' <arguments>').
            ^ self
        ].

        select := true.

        "some heuristics - my personal preferences ...
         (actually this should come from a configfile)"

        (baseName endsWith:'akefile') ifTrue:[
            aBox initialText:'make target' selectFrom:6 to:11.
            ^ self
        ].

        cmd := MIMETypes defaultCommandPerMIME at:mime ifAbsent:nil.
        cmd notNil ifTrue:[
            select := false
        ].

        cmd isNil ifTrue:[
            suffix := path suffix.
            (suffix = 'C') ifTrue:[
                cmd := 'g++ -c %1'.
                select := 6.
            ] ifFalse:[
                suffix := suffix asLowercase.

                (suffix = 'taz') ifTrue:[
                    aBox initialText:'zcat %1 | tar tvf -'.
                    select := false.
                ].
                (suffix = 'tar') ifTrue:[
                    cmd := 'tar tvf %1'.
                    select := 7.
                ].
                (suffix = 'zoo') ifTrue:[
                    cmd := 'zoo -list %1'.
                    select := 9.
                ].
                (suffix = 'zip') ifTrue:[
                    cmd := 'unzip -l %1'.
                    select := 8.
                ].
                (suffix = 'jar') ifTrue:[
                    cmd := 'unzip -l %1'.
                    select := 8.
                ].
                (suffix = 'z') ifTrue:[
                    (baseName asLowercase endsWith:'tar.z') ifTrue:[
                        cmd := 'zcat %1 | tar tvf -'.
                        select := false.
                    ] ifFalse:[
                        cmd := 'uncompress %1'
                    ].
                ].
                (suffix = 'gz') ifTrue:[
                    (baseName asLowercase endsWith:'tar.gz') ifTrue:[
                        cmd := ('gunzip < %1 | tar tvf -' ).
                        select := false.
                    ] ifFalse:[
                        cmd := 'gunzip %1'.
                    ].
                ].
                (suffix = 'html') ifTrue:[
                    cmd := 'netscape %1'
                ].
                (suffix = 'htm') ifTrue:[
                    cmd := 'netscape %1'
                ].
                (suffix = 'uue') ifTrue:[
                    cmd := 'uudecode %1'
                ].
                (suffix = 'c') ifTrue:[
                    cmd := 'cc -c %1'.
                    select := 5.
                ].
                (suffix = 'cc') ifTrue:[
                    cmd := 'g++ -c %1'.
                    select := 6.
                ].
                (suffix = 'xbm') ifTrue:[
                    cmd := 'bitmap %1'
                ].
                (suffix = 'ps') ifTrue:[
                    cmd := 'ghostview %1'
                ].
                ((suffix = '1') or:[suffix = 'man']) ifTrue:[
                    cmd := 'nroff -man %1'.
                    select := 10.
                ].
            ].
        ].

        cmd isNil ifTrue:[
            DefaultCommandPerSuffix isNil ifTrue:[
                cmd := '<cmd>'
            ] ifFalse:[
                cmd := DefaultCommandPerSuffix 
                        at:suffix
                        ifAbsent:'<cmd>'.
            ].
            cmd := cmd , ' %1'.
        ].

        pathName := path pathName.
        OperatingSystem isUNIXlike ifTrue:[
            pathName includesSeparator ifTrue:[
                pathName := '"' , pathName , '"'
            ]
        ].

        cmd := cmd bindWith:pathName.
        select == false ifTrue:[
            aBox initialText:cmd
        ] ifFalse:[
            select class == Interval ifTrue:[
                aBox initialText:cmd selectFrom:select start to:select stop
            ] ifFalse:[
                select isInteger ifFalse:[
                    select := (cmd indexOf:Character space ifAbsent:[cmd size + 1]) - 1.
                ].
                aBox initialText:cmd selectFrom:1 to:select
            ].
        ]
    ]

    "Modified: / 24.9.1997 / 16:34:52 / stefan"
    "Modified: / 9.4.1998 / 17:15:57 / cg"
!

listOfRuntimeValuesToRemember
    " list of all aspects that will be remembered after closing a FileBrowserV2"
    
    ^ #( 
"/        #filterModel
        #enableFileHistory
        #fileHistory
        #currentSortOrder
        #sortBlockProperty 
       )
!

resetAspects

    RuntimeAspects := nil.

    "
     self resetAspects
    "
!

runtimeAspects

    RuntimeAspects isNil ifTrue:[
        RuntimeAspects := Dictionary new.
    ].
    ^ RuntimeAspects
!

userPreferencesAspectList
    " list of all aspects that will be saved with save settings
      that aspects will be image consistent if the settings are saved in Launcher
      don't forget to add a access methods in UserPreferences if you add a aspect here
    "

    ^ Dictionary 
        withKeysAndValues:#(
           viewDirsInContentsBrowser   true
           showDirectoryTree           true
           showHiddenFiles             true
           viewDescription             false
           viewDetails                 true
           viewDirectoryDescription    false
           viewFilesInDirectoryTree    false
           viewGroup                   false
           viewOwner                   false
           viewPermissions             false
           viewPreview                 false
           viewSize                    true
           viewSizeInKiloBytes         false
           viewSizeInBytes             false
           viewTime                    true
           viewType                    false
           openMultipleApplicationsForType false
           filenameEntryFieldVisibleHolder   true
           toolBarVisibleHolder        true
           sortDirectoriesBeforeFiles  true
           openAlwaysInTextEditor      false
           alwaysUseSmalltalkTools     true
           sortCaseless                false
           "/ useCodeView2InTools         true   -- vanishes
           showDirectoriesOnTop        false 
      )

    "Modified: / 11-05-2012 / 09:22:04 / cg"
    "Modified: / 12-08-2014 / 13:13:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractFileBrowser class methodsFor:'drag & drop'!

doStartDrag:aDropSource in:aView
    "set the cursors before starting the drag & drop operation"

    |hdl|

    hdl := DragAndDropManager new.

    hdl disabledCursor:self disabledCursorIcon.
    hdl enabledCursor:self enabledCursorIcon.
    hdl alienCursor:nil.

    hdl startDragFrom:aView dropSource:aDropSource offset:#topLeft.

    "Modified: / 23-07-2007 / 23:00:38 / cg"
! !

!AbstractFileBrowser class methodsFor:'help specs'!

basicFlyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#lockFileEncoding
'Do not guess the encoding from the file''s contents.'

#closeTabButton
'Close this tab'

#addTerminal
'Add a shell terminal page'

#make
'Call the make command'

#searchFile
'Search a file'

#directoryUp
'Directory up'

#directoryBack
'Directory back'

#directoryForward
'Directory forward'

#directoryHistory
'Directory'

#copyFile
'Copy the selected file(s)'

#cutFile
'Cut the selected file(s)'

#editFile
'Edit the selected file'

#fileHome
'Goto home directory'

#fileDesktop
'Goto desktop directory'

#fileGotoDefault
'Goto default directory (ST/X start directory)'

#fileGotoSmalltalkDirectory
'Goto Smalltalk directory (ST/X application)'

#fileGotoDefaultDirectory
'Goto current directory'

#pasteFile
'Paste file(s)'

#deleteFile
'Delete the selected file(s)'

#fileIn
'File in'

#fileHistory
'File history'

#fileGotoBookmark
'Goto bookmarked directory'

#hideToolBar
'Hide the toolbar (show again via "View"-menu)'

#hideFilenameEntryField
'Hide filename & filter fields (show again via "View"-menu)'

#hideBookmarks
'Hide the bookmarks (show again via "View"-menu)'

#openChangeBrowser
'Open a Changebrowser on file'

#showFileDetails
'Show file details'

#hideFileDetails
'Hide file details'

#toggleDetails
'Show/hide file details'

#viewDetails
'Show/hide file details'

#selectDetails
'Select file details to be shown'

#showDifferences
'Show differences between file and editor versions'

#toggleHexDisplay
'Toggle between hexadecimal and textual representation'

#findInBrowser
'Navigate the browser''s file list to the edited file'

#saveFile
'Save the editor''s contents into the file'

#saveFileAs
'Save the editor''s contents into another file'

#reloadFile
'Reload from the file'

#print
'Send to the printer'

).

    "
     self flyByHelpSpec
    "

    "Modified: / 06-10-2011 / 14:55:27 / cg"
!

flyByHelpSpec
    <resource: #programHelp>

    |spec hist resources|

    spec := self basicFlyByHelpSpec.

    "/ add help items for the history
    hist := self directoryHistory.
    hist notNil ifTrue:[
        resources := self classResources.
        hist canForward ifTrue:[
            spec at:#directoryForward put:[ resources string:'Forward to: %1' with:hist nextForwardItem ].
        ].
        hist canBackward ifTrue:[
            spec at:#directoryBack put:[ resources string:'Back to: %1' with:hist nextBackwardItem ].
        ].
    ].
    ^ spec.

    "
     self flyByHelpSpec
    "

    "Modified: / 03-11-2007 / 12:05:01 / cg"
! !

!AbstractFileBrowser class methodsFor:'image specs'!

clearHistoryIcon
    <resource: #programImage>

    ^ Icon deleteIcon
!

copyIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary copyIcon
!

cutIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary cut20x20Icon2 "cut28x28Icon"
!

deleteIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary erase20x20Icon "/ delete28x28Icon
!

directoryUpIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary directoryUpIcon
!

disabledCursorIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self disabledCursorIcon inspect
     ImageEditor openOnClass:self andSelector:#disabledCursorIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'AbstractFileBrowser class disabledCursorIcon'
        ifAbsentPut:[(Depth1Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@_ @@@XF@@@H@P@@DOB@@BLLP@AA@"@@RHD @H1AD@BRHI@@$QBP@IBH$@BPQI@@"BLP@D QH@ADBB@@H0Q@@AC
8 @@H@P@@A X@@@G8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@_ @@@_>@@@O?0@@G?>@@C<O0@A?@>@@_8G @O?A<@C38O@@<_C0@OC8<@C0_O@@>C?0@G _8@A<C>@@O0_@@A?
? @@O?0@@A?8@@@G8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]
!

enabledCursorIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self enabledCursorIcon inspect
     ImageEditor openOnClass:self andSelector:#enabledCursorIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'AbstractFileBrowser class enabledCursorIcon'
        ifAbsentPut:[(Depth1Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E@@@@AP@@@@T@@@@E@@@@AP@@@@T@@@@E@@@@AP@@@@@@@@?0_0@@@@@@C?A?@@@@@@@@AP@@@@T@@@@E@@@@A
P@@@@T@@@@E@@@@AP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((ImageMask new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G@@@@A0@@@@\@@@@G@@@@A0@@@@\@@@@G@@@@A0@@@@\@@@?8?0@O>O<@C?#?@@@G@@@@A0@@@@\@@@@G@@@@A
0@@@@\@@@@G@@@@A0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]
!

fileInIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary fileInIcon
!

historyBackIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary historyBackIcon
!

historyForwardIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary historyForwardIcon
!

homeIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary homeIcon
!

homeIcon2
    <resource: #programImage>

    ^ ToolbarIconLibrary homeIcon2
!

htmlReloadIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary reload22x22Icon
!

leftDownIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self leftDownIcon inspect
     ImageEditor openOnClass:self andSelector:#leftDownIcon"
    
    ^ Icon constantNamed:#'AbstractFileBrowser class leftDownIcon'
        ifAbsentPut:[
            (Depth2Image new)
                width:28;
                height:28;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
UUUUUUUUUUUPAUUUUUUUP@UUUUUUUPB!!UUUUUU@B*AUUUUU@B*(UUUUUPB** UUUUPB***AUUUTB***(EUUUB****%UUUR*****UUUUU@*%UUUUUUPJ)UUUU
UUTB*UUUUUUU@*%UUUUUUPJ)UUUUUUTB*UUUUUUU@*%UUUUUUPJ)UUUUUUTB*UUUUUUU@*$@@@@AUPJ*****)UTB******UU@******%UPJ*****)UTAUUUU
UUUU@@@@@@@AUUUUUUUUUP@a');
                colorMapFromArray:#[ 255 255 255 0 0 0 40 40 100 255 0 0 ];
                mask:((ImageMask new)
                            width:28;
                            height:28;
                            bits:(ByteArray 
                                        fromPackedString:'
@@@@@@@@@@@@ @@@@\@@@@O @@@G<@@@C? @@A?<@@@?? @@_?<@@G?? @@C<@@@@?@@@@O0@@@C<@@@@?@@@@O0@@@C<@@@@?@@@@O0@@@C??? @???8@O?
?>@C??? @???8@O??>@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]
!

menuHistoryList9x20Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuHistoryList9x20Icon inspect
     ImageEditor openOnClass:self andSelector:#menuHistoryList9x20Icon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:#'AbstractFileBrowser class menuHistoryList9x20Icon'
        ifAbsentPut:[
            (Depth1Image new)
                width:9;
                height:20;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@A0@G@@\@A0@G@@\@A0@G@@\@A0@G@A?@C8@G@@H@G<@@@@@@@@a');
                colorMapFromArray:#[ 255 255 255 0 0 0 ];
                mask:((ImageMask new)
                            width:9;
                            height:20;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@A0@G@@\@A0@G@@\@A0@G@@\@A0@G@A?@C8@G@@H@G<@@@@@@@@a');
                            yourself);
                yourself
        ]
!

menuHistoryListIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self menuHistoryListIcon inspect
     ImageEditor openOnClass:self andSelector:#menuHistoryListIcon"
    
    ^ Icon constantNamed:#'AbstractFileBrowser class menuHistoryListIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:12;
                height:12;
                photometric:(#palette);
                bitsPerSample:(#( 1 ));
                samplesPerPixel:(1);
                bits:(ByteArray fromPackedString:'??S?<O?0??C?<O?0??/?=_?0??C?<O?0');
                colorMapFromArray:#[ 255 255 255 0 0 0 ];
                mask:((ImageMask new)
                            width:12;
                            height:12;
                            bits:(ByteArray fromPackedString:'@@@O@@<@C0A?8C?@G8@O@@X@@@A?8@@@');
                            yourself);
                yourself
        ]
!

newDirectoryIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary newDirectoryIcon
!

removeTabIcon
    <resource: #programImage>

    ^ ToolbarIconLibrary removeTabIcon
!

vt100Terminal
    <resource: #programImage>

    ^ ToolbarIconLibrary shell20x20Icon
! !

!AbstractFileBrowser class methodsFor:'interface specs'!

encodingDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractFileBrowser andSelector:#encodingDialogSpec
     AbstractFileBrowser new openInterface:#encodingDialogSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: encodingDialogSpec
       window: 
      (WindowSpec
         label: 'File Encoding'
         name: 'File Encoding'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 379 590)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Select the External (File-) Encoding:'
             name: 'Label1'
             layout: (LayoutFrame 0 0 0 0 0 1 30 0)
             translateLabel: true
             adjust: left
           )
          (DataSetSpec
             name: 'Table1'
             layout: (LayoutFrame 0 0 30 0 0 1 -60 1)
             model: selectedEncoding
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             dataList: encodingList
             has3Dseparators: true
             columns: 
            (Array
               
              (DataSetColumnSpec
                 label: 'Encoding'
                 labelButtonType: Button
                 height: heightOfFirstRow
                 model: at:
                 canSelect: false
                 isResizeable: false
                 showRowSeparator: false
                 showColSeparator: false
               ) 
              (DataSetColumnSpec
                 label: 'Description'
                 labelButtonType: Button
                 height: heightOfFirstRow
                 model: at:
                 canSelect: false
                 isResizeable: false
                 showRowSeparator: false
                 showColSeparator: false
               )
             )
             doubleClickChannel: accept
           )
          (CheckBoxSpec
             label: 'Lock Encoding'
             name: 'LockEncodingCheckBox'
             layout: (LayoutFrame 3 0 -60 1 217 0 -30 1)
             activeHelpKey: lockFileEncoding
             model: lockFileEncoding
             translateLabel: true
           )
          (HorizontalPanelViewSpec
             name: 'ButtonPanel'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             horizontalLayout: fitSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'Button2'
                   translateLabel: true
                   model: cancel
                   extent: (Point 183 22)
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'Button1'
                   translateLabel: true
                   model: accept
                   isDefault: true
                   extent: (Point 184 22)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

lineEndConventionDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractFileBrowser andSelector:#lineEndConventionDialogSpec
     AbstractFileBrowser new openInterface:#lineEndConventionDialogSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: lineEndConventionDialogSpec
       window: 
      (WindowSpec
         label: 'Line-End Convention'
         name: 'Line-End Convention'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 379 239)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: 'Select the Line-End Convention (used when saving files):'
             name: 'Label1'
             layout: (LayoutFrame 0 0 0 0 0 1 30 0)
             translateLabel: true
             adjust: left
           )
          (VerticalPanelViewSpec
             name: 'VerticalPanel1'
             layout: (LayoutFrame 20 0 40 0 0 1 -30 1)
             horizontalLayout: fit
             verticalLayout: topSpace
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (RadioButtonSpec
                   label: 'NL (Unix)'
                   name: 'RadioButton1'
                   translateLabel: true
                   model: lineEndConvention
                   isTriggerOnDown: true
                   select: nl
                   extent: (Point 359 22)
                 )
                (RadioButtonSpec
                   label: 'CR-NL (MSDOS)'
                   name: 'RadioButton4'
                   translateLabel: true
                   model: lineEndConvention
                   isTriggerOnDown: true
                   select: crlf
                   extent: (Point 359 22)
                 )
                (RadioButtonSpec
                   label: 'CR (VMS and pre OSX mac)'
                   name: 'RadioButton5'
                   translateLabel: true
                   model: lineEndConvention
                   isTriggerOnDown: true
                   select: cr
                   extent: (Point 359 22)
                 )
                (RadioButtonSpec
                   label: 'ETX (some modem protocols and mainframe files)'
                   name: 'RadioButton6'
                   translateLabel: true
                   model: lineEndConvention
                   isTriggerOnDown: true
                   select: etx
                   extent: (Point 359 22)
                 )
                (RadioButtonSpec
                   label: 'EOT (some modem protocols and mainframe files)'
                   name: 'RadioButton7'
                   translateLabel: true
                   model: lineEndConvention
                   isTriggerOnDown: true
                   select: eot
                   extent: (Point 359 22)
                 )
                )
              
             )
           )
          (HorizontalPanelViewSpec
             name: 'ButtonPanel'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             horizontalLayout: fitSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'Button2'
                   translateLabel: true
                   model: cancel
                   extent: (Point 185 22)
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'Button1'
                   translateLabel: true
                   model: accept
                   isDefault: true
                   extent: (Point 185 22)
                 )
                )
              
             )
           )
          )
        
       )
     )
!

tabStopConversionDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:AbstractFileBrowser andSelector:#tabStopConversionDialogSpec
     AbstractFileBrowser new openInterface:#tabStopConversionDialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: 'tabStopConversionDialogSpec'
        window: 
       (WindowSpec
          label: 'Tab-Stop Conversion'
          name: 'Tab-Stop Conversion'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 379 239)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Select the Tab-Stop Conversion (used when saving files):'
              name: 'Label1'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              translateLabel: true
              adjust: left
            )
           (VerticalPanelViewSpec
              name: 'VerticalPanel1'
              layout: (LayoutFrame 0 0 30 0 0 1 -30 1)
              horizontalLayout: center
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (RadioButtonSpec
                    label: '4'
                    name: 'RadioButton1'
                    translateLabel: true
                    model: tabStops
                    isTriggerOnDown: true
                    select: 4
                    extent: (Point 136 22)
                  )
                 (RadioButtonSpec
                    label: '8'
                    name: 'RadioButton4'
                    translateLabel: true
                    model: tabStops
                    isTriggerOnDown: true
                    select: 8
                    extent: (Point 136 22)
                  )
                 )
               
              )
            )
           (HorizontalPanelViewSpec
              name: 'ButtonPanel'
              layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button2'
                    translateLabel: true
                    model: cancel
                    extent: (Point 185 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button1'
                    translateLabel: true
                    model: accept
                    isDefault: true
                    extent: (Point 185 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )

    "Modified: / 28-02-2012 / 11:12:38 / cg"
! !

!AbstractFileBrowser class methodsFor:'menu specs'!

baseBookmarksMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#baseBookmarksMenuSpec
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser baseBookmarksMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: currentFilesHasDirectories
            label: 'Add Bookmark'
            itemValue: addBookmark
            translateLabel: true
          )
         (MenuItem
            enabled: hasBookmarksToRemove
            label: 'Remove Bookmark'
            itemValue: removeBookmark
            translateLabel: true
          )
         (MenuItem
            label: 'Save Bookmarks In...'
            itemValue: saveBookmarks
            translateLabel: true
          )
         )
        nil
        nil
      )
!

baseBookmarksMenuSpec2
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#baseBookmarksMenuSpec2
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser baseBookmarksMenuSpec2)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Edit Bookmarks'
            itemValue: editBookmarks
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: currentFilesHasDirectories
            label: 'Add Bookmark'
            itemValue: addBookmark
            translateLabel: true
          )
         )
        nil
        nil
      )
!

browserMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#browserMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser browserMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Spawn Filebrowser'
            itemValue: doSpawn
            translateLabel: true
            shortcutKey: Ctrln
          )
         (MenuItem
            label: 'Windows Explorer'
            itemValue: doOpenExplorer
            translateLabel: true
            isVisible: systemIsDOS
          )
         (MenuItem
            label: 'Open Finder'
            itemValue: doOpenFinder
            translateLabel: true
            isVisible: systemIsOSX
          )
         (MenuItem
            label: 'C Browser'
            itemValue: doOpenCBrowser
            translateLabel: true
            isVisible: cBrowserMenuItemVisible
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Add Text Editor Page'
            itemValue: newTextEditor
            translateLabel: true
            shortcutKey: Ctrlt
          )
         (MenuItem
            label: 'Add Shell Terminal Page'
            itemValue: doAddTerminal
            translateLabel: true
          )
         (MenuItem
            label: 'Add Archiver Page'
            itemValue: doAddArchiver
            translateLabel: true
          )
         (MenuItem
            label: 'Add Search Page'
            itemValue: doOpenSearchFile
            translateLabel: true
          )
         (MenuItem
            label: '-'
            isVisible: false
          )
         (MenuItem
            label: 'Settings...'
            itemValue: doOpenSettings
            translateLabel: true
            isVisible: false
          )
         (MenuItem
            label: 'Encoding...'
            itemValue: fileEncodingDialog
            translateLabel: true
            isVisible: false
          )
         (MenuItem
            label: 'Line End Convention...'
            itemValue: lineEndConventionDialog
            translateLabel: true
            isVisible: false
          )
         (MenuItem
            label: 'Tab Stop Conversion...'
            itemValue: tabStopConversionDialog
            translateLabel: true
            isVisible: false
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Exit'
            itemValue: closeRequest
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Modified: / 07-01-2012 / 12:51:20 / cg"
!

directoryMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#directoryMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser directoryMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Bookmarks'
            submenuChannel: bookmarksMenu
          )
         (MenuItem
            label: 'Visited Directories'
            submenuChannel: visitedDirectoriesMenu
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Up'
            itemValue: doGoDirectoryUp
          )
         (MenuItem
            activeHelpKey: directoryBack
            enabled: enableBack
            label: 'Back'
            itemValue: doBack
          )
         (MenuItem
            activeHelpKey: directoryBack
            enabled: enableForward
            label: 'Forward'
            itemValue: doForward
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: enableHome
            label: 'Home Directory'
            itemValue: doGotoHomeDirectory
          )
         (MenuItem
            enabled: enableGotoDesktopDirectory
            label: 'Desktop'
            itemValue: doGotoDesktopDirectory
          )
         (MenuItem
            enabled: enableGotoDefaultDirectory
            label: 'Default (Current) Directory'
            itemValue: doGotoDefaultDirectory
          )
         (MenuItem
            enabled: enableGotoSmalltalkDirectory
            label: 'Smalltalk (Application) Directory'
            itemValue: doGotoSmalltalkDirectory
          )
         (MenuItem
            enabled: enableGotoSmalltalkWorkspaceDirectory
            label: 'Smalltalk Workspace Directory'
            itemValue: doGotoSmalltalkWorkspaceDirectory
          )
         (MenuItem
            enabled: enableGotoTempDirectory
            label: 'Smalltalk Temp Directory'
            itemValue: doGotoTempDirectory
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: enableMakeCurrentDirectory
            label: 'Make this the Default (Current) Directory'
            itemValue: doMakeCurrentDirectory
          )
         )
        nil
        nil
      )
!

editMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#editMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser editMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasFileSelection
            label: 'Copy Selected Filenames to Clipboard'
            itemValue: copySelectedFilenames
            translateLabel: true
          )
         (MenuItem
            enabled: fileListIsNotEmpty
            label: 'Copy all Filenames to Clipboard'
            itemValue: copyFileList
            translateLabel: true
          )
         )
        nil
        nil
      )
!

emptyMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#emptyMenuSpec
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser emptyMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         )
        nil
        nil
      )
!

extraMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#extraMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser extraMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Encoding...'
            itemValue: fileEncodingDialog
            translateLabel: true
          )
         (MenuItem
            label: 'Line End Convention...'
            itemValue: lineEndConventionDialog
            translateLabel: true
          )
         (MenuItem
            label: 'Tab Stop Conversion...'
            itemValue: tabStopConversionDialog
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Settings...'
            itemValue: doOpenSettings
            translateLabel: true
            labelImage: (ResourceRetriever ToolbarIconLibrary settings16x16Icon 'Settings...')
          )
         )
        nil
        nil
      )
!

fileMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#fileMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser fileMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: enableFileHistory
            label: 'File History'
            submenuChannel: menuFileHistory
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Open'
            itemValue: doShowFileContents
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'FileIn'
            itemValue: fileFileIn
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'FileIn to Namespace...'
            itemValue: fileFileInToNameSpace
          )
         (MenuItem
            enabled: hasPackageDirectorySelected
            label: 'Load Package from Here'
            itemValue: fileFileInPackage
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'New'
            submenuChannel: newMenu
            keepLinkedMenu: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Cut'
            itemValue: cutFiles
          )
         (MenuItem
            enabled: hasSelection
            label: 'Copy'
            itemValue: copyFiles
          )
         (MenuItem
            enabled: canPaste
            label: 'Paste'
            itemValue: pasteFiles
          )
         (MenuItem
            enabled: hasSelection
            label: 'Delete'
            itemValue: deleteFiles
          )
         (MenuItem
            enabled: hasSelection
            label: 'Erase'
            itemValue: eraseFiles
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Rename...'
            itemValue: renameSelection
            shortcutKey: Rename
          )
         (MenuItem
            enabled: hasSelection
            label: 'Move To...'
            itemValue: moveSelectionTo
          )
         (MenuItem
            enabled: hasSelection
            label: 'Copy To...'
            itemValue: copySelectionTo
          )
         (MenuItem
            enabled: hasSelection
            label: 'Properties...'
            itemValue: doShowProperties
          )
         (MenuItem
            label: '-'
            isVisible: javaSupportLoaded
          )
         (MenuItem
            enabled: canAddToClassPath
            label: 'Add to Java Class Path'
            isVisible: javaSupportLoaded
          )
         (MenuItem
            enabled: canRemoveFromClassPath
            label: 'Remove from Java Class Path'
            isVisible: javaSupportLoaded
          )
         (MenuItem
            enabled: canAddToSourcePath
            label: 'Add to Java Source Path'
            isVisible: javaSupportLoaded
          )
         (MenuItem
            enabled: canRemoveFromSourcePath
            label: 'Remove from Java Source Path'
            isVisible: javaSupportLoaded
          )
         )
        nil
        nil
      )
!

fileOpMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#fileOpMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser fileOpMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasFileSelection
            label: 'Split (by size)...'
            itemValue: splitSelectedFiles
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'Split (by #lines)...'
            itemValue: splitSelectedFilesByLines
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'Join...'
            itemValue: joinSelectedFiles
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'Copy Corrupted File To...'
            itemValue: copySelectionToRepairingCorruptedFiles
          )
         (MenuItem
            label: 'Copy Corrupted File From -> To...'
            itemValue: copyFromToRepairingCorruptedFiles
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'Rot13...'
            itemValue: filterSelectedFiles:
            argument: rot13
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'Truncate...'
            itemValue: truncateSelectedFilesToZeroSize
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Load Signature Support Package'
            itemValue: loadSignatureSupport
            isVisible: cannotGenerateSignatureFiles
          )
         (MenuItem
            enabled: canGenerateSignatureFiles
            label: 'Generate Signed Files'
            itemValue: generateSignaturesForSelectedFiles
          )
         (MenuItem
            enabled: canGenerateSignatureFiles
            label: 'Generate Detached Signature Files (use for dll)'
            itemValue: generateDetachedSignaturesForSelectedFiles
          )
         (MenuItem
            enabled: canGenerateSignatureFiles
            label: 'Generate Patch Installer for File(s)'
            itemValue: generatePatchInstallerForSelectedFiles
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'File Differences'
            itemValue: openDiffView
            isVisible: hasTwoFilesSelectedHolder
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'File Differences...'
            itemValue: openDiffView
            isVisible: hasNotTwoFilesSelectedHolder
          )
         (MenuItem
            enabled: hasSelection
            label: 'Directory Differences'
            itemValue: openDirectoryDiffView
            isVisible: hasTwoDirectoriesSelectedHolder
          )
         (MenuItem
            enabled: hasSelection
            label: 'Directory Differences...'
            itemValue: openDirectoryDiffView
            isVisible: hasNotTwoDirectoriesSelectedHolder
          )
         )
        nil
        nil
      )
!

newMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:DirectoryTreeBrowser andSelector:#newMenu
     (Menu new fromLiteralArrayEncoding:(DirectoryTreeBrowser newMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Directory...'
            #translateLabel: true
            #value: #newDirectory
          )
         #(#MenuItem
            #label: 'File...'
            #translateLabel: true
            #value: #newFile
          )                                     
         #(#MenuItem
            #label: 'Hard Link...'
            #translateLabel: true
            #value: #newHardLink
          )
         #(#MenuItem
            #label: 'Symbolic Link...'
            #translateLabel: true
            #value: #newSoftLink
          )
         )
        nil
        nil
      )
!

scmMenuSlice
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#scmMenuSlice
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser scmMenuSlice)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'CVS'
            isVisible: cvsMenusAreShown
            submenuChannel: cvsMenu
          )
         (MenuItem
            label: 'SVN'
            isVisible: svnMenusAreShown
            submenuChannel: svnMenu
          )
         (MenuItem
            label: 'Mercurial'
            isVisible: mercurialMenusAreShown
            submenuChannel: mercurialMenu
          )
         (MenuItem
            label: 'HG'
            isVisible: hgMenusAreShown
            submenuChannel: hgMenu
          )
         (MenuItem
            label: 'Perforce'
            isVisible: perforceMenusAreShown
            submenuChannel: perforceMenu
          )
         )
        nil
        nil
      )
!

showMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#showMenuSpec
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser showMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Hidden Files'
            translateLabel: true
            hideMenuOnActivated: false
            indication: showHiddenFiles
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Directory Tree'
            translateLabel: true
            hideMenuOnActivated: false
            indication: showDirectoryTree
          )
         (MenuItem
            label: 'Regular Files in TreeView (Left)'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewFilesInDirectoryTree
          )
         (MenuItem
            label: 'Directories in ContentsView (Right)'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewDirsInContentsBrowser
          )
         (MenuItem
            enabled: enableViewNoteBookApplication
            label: 'File Applications'
            translateLabel: true
            hideMenuOnActivated: false
            indication: viewNoteBookApplicationHolder
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'DiskUsage'
            translateLabel: true
            hideMenuOnActivated: false
            indication: showDiskUsageHolder
          )
         )
        nil
        nil
      )
!

showMenuSpecForDialog
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#showMenuSpecForDialog
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser showMenuSpecForDialog)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Hidden Files'
            translateLabel: true
            hideMenuOnActivated: false
            indication: showHiddenFiles
          )
         )
        nil
        nil
      )
!

sortMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#sortMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser sortMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'By Filename'
            #translateLabel: true
            #hideMenuOnActivated: false
            #choice: #sortBlockProperty
            #choiceValue: #baseName
          )
         #(#MenuItem
            #label: 'By Extension'
            #translateLabel: true
            #hideMenuOnActivated: false
            #choice: #sortBlockProperty
            #choiceValue: #suffix
          )
         #(#MenuItem
            #label: 'By Permissions'
            #translateLabel: true
            #hideMenuOnActivated: false
            #choice: #sortBlockProperty
            #choiceValue: #permissions
          )
         #(#MenuItem
            #label: 'By Owner'
            #translateLabel: true
            #isVisible: #viewOwner
            #hideMenuOnActivated: false
            #choice: #sortBlockProperty
            #choiceValue: #owner
          )
         #(#MenuItem
            #label: 'By Group'
            #translateLabel: true
            #isVisible: #viewOwner
            #hideMenuOnActivated: false
            #choice: #sortBlockProperty
            #choiceValue: #group
          )
         #(#MenuItem
            #label: 'By Size'
            #translateLabel: true
            #hideMenuOnActivated: false
            #choice: #sortBlockProperty
            #choiceValue: #fileSize
          )
         #(#MenuItem
            #label: 'By Date && Time'
            #translateLabel: true
            #hideMenuOnActivated: false
            #choice: #sortBlockProperty
            #choiceValue: #modificationTime
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Ignore Case in Sort'
            #translateLabel: true
            #hideMenuOnActivated: false
            #indication: #sortCaseless
          )
         #(#MenuItem
            #label: 'Directories before Files'
            #translateLabel: true
            #hideMenuOnActivated: false
            #indication: #sortDirectoriesBeforeFiles
          )
         )
        nil
        nil
      )
!

toolsMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#toolsMenuSpec
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser toolsMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Open (Win32-Shell)'
            itemValue: doOpenWithShellCommand
            isVisible: systemIsDOS
          )
         (MenuItem
            label: 'Execute UNIX Command...'
            itemValue: doExecuteCommand
            isVisible: systemIsUnix
          )
         (MenuItem
            label: 'Execute DOS Command...'
            itemValue: doExecuteCommand
            isVisible: systemIsDOS
          )
         (MenuItem
            label: 'Execute Script...'
            itemValue: doExecuteScript
          )
         (MenuItem
            enabled: canDoTerminal
            label: 'Shell Terminal'
            itemValue: openTerminal
            isVisible: canDoTerminalAndSystemIsUnix
            labelImage: (ResourceRetriever ToolbarIconLibrary terminal16x16Icon 'Shell Terminal')
          )
         (MenuItem
            enabled: canDoTerminal
            label: 'DOS Terminal'
            itemValue: openTerminal
            isVisible: canDoTerminalAndSystemIsDOS
            labelImage: (ResourceRetriever ToolbarIconLibrary terminal16x16Icon 'DOS Terminal')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'Changes Browser'
            itemValue: openChangesBrowser
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'ChangeSet Browser'
            itemValue: openChangeSetBrowser
            isVisible: changeSetBrowserItemVisible
          )
         (MenuItem
            enabled: hasFileSelection
            label: 'Workspace'
            itemValue: openWorkspace
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canReadAbbrevFile
            label: 'Install Autoloaded'
            itemValue: readAbbrevFile
          )
         (MenuItem
            enabled: anySTFilesPresent
            label: 'Install all ST-Files as Autoloaded'
            itemValue: installAllAsAutoloaded
          )
         (MenuItem
            enabled: recursiveAnySTFilesPresent
            label: 'Recursive Install all ST-Files as Autoloaded'
            itemValue: installAllAsAutoloadedRecursive
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasJava
            label: 'Add Directory to Java Source Path (stx:libjava)'
            itemValue: addDirToJavaSourcePath
          )
         (MenuItem
            enabled: hasJava
            label: 'Add Selected Files to Java Source Path (stx:libjava)'
            itemValue: fileAddToJavaSourcePath
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'File Operations'
            submenuChannel: fileOpMenu
          )
         (MenuItem
            label: 'File Utilities'
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasFileSelection
                  label: 'Editor'
                  itemValue: openEditor
                )
               (MenuItem
                  enabled: hasFileSelection
                  label: 'HTML Reader'
                  itemValue: openHTMLReader
                )
               (MenuItem
                  enabled: hasFileSelection
                  label: 'Web Browser'
                  itemValue: openWebBrowser
                )
               (MenuItem
                  label: 'XML Inspector'
                  itemValue: inspectXmlFile
                  isVisible: hasXml
                  showBusyCursorWhilePerforming: true
                )
               (MenuItem
                  enabled: hasFileSelection
                  label: 'Acroread (PDF Viewer)'
                  itemValue: openPDFViewer
                )
               (MenuItem
                  enabled: hasASN1AndSelection
                  label: 'ASN1 Browser'
                  itemValue: openASN1Browser
                  isVisible: hasASN1
                )
               (MenuItem
                  enabled: hasCBrowser
                  label: 'C Browser'
                  itemValue: openCBrowser
                  isVisible: hasCBrowser
                )
               (MenuItem
                  enabled: canOpenMonticelloBrowser
                  label: 'Monticello Browser'
                  itemValue: doOpenMonticelloBrowser
                )
               (MenuItem
                  enabled: hasJavaAndSelection
                  label: 'Applet Viewer'
                  itemValue: openAppletViewer
                  isVisible: hasJava
                )
               (MenuItem
                  enabled: hasMP3PlayerAndSelection
                  label: 'MP3 Player'
                  itemValue: openMP3Player
                  isVisible: hasMP3Player
                )
               (MenuItem
                  enabled: hasFileSelection
                  label: 'xv (Image Viewer)'
                  itemValue: openXV
                  isVisible: systemIsUnix
                )
               (MenuItem
                  enabled: currentFilesAreInSameDirectory
                  label: 'Slide Show'
                  itemValue: openSlideShow
                  isVisible: hasSlideShow
                )
               (MenuItem
                  enabled: hasFileSelection
                  label: 'gv (Postscript Viewer)'
                  itemValue: openGV
                  isVisible: systemIsUnix
                )
               (MenuItem
                  enabled: hasMP3PlayerAndSelection
                  label: 'MP3 Player'
                  itemValue: openMP3Player
                  isVisible: hasMP3Player
                )
               (MenuItem
                  enabled: hasFileSelection
                  label: 'Realplay (avi viewer)'
                  itemValue: openRP
                  isVisible: systemIsUnix
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Smalltalk'
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasSnapshotSelection
                        label: 'Snapshot Image Browser'
                        itemValue: openSnapshotImageBrowser
                      )
                     (MenuItem
                        enabled: canCreateNewProject
                        label: 'Create Smalltalk Project'
                        itemValue: createProjectAndOpenProjectBrowser
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasResourceFileSelected
                        label: 'Show Contents of Resourcefile'
                        itemValue: readAndShowResources
                      )
                     (MenuItem
                        enabled: hasResourceFileSelected
                        label: 'Resource File Editor'
                        itemValue: openResourceFileEditor
                        showBusyCursorWhilePerforming: true
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasFileSelection
                        label: 'Contents as ByteArray'
                        itemValue: fileContentsAsByteArray
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: 'Image'
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        enabled: hasFileSelection
                        label: 'Image Editor'
                        itemValue: openImageEditor
                      )
                     (MenuItem
                        enabled: hasFileSelection
                        label: 'Image Preview'
                        itemValue: openImagePreview
                      )
                     (MenuItem
                        enabled: hasFileSelection
                        label: 'Image Inspector'
                        itemValue: openImageInspector
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        enabled: hasFileSelection
                        label: 'Convert to GIF'
                        itemValue: convertImageToGIF
                      )
                     (MenuItem
                        enabled: hasFileSelection
                        label: 'Convert to PNG'
                        itemValue: convertImageToPNG
                      )
                     (MenuItem
                        enabled: hasFileSelection
                        label: 'Convert to XPM'
                        itemValue: convertImageToXPM
                      )
                     (MenuItem
                        enabled: hasFileSelection
                        label: 'Convert to JPG'
                        itemValue: convertImageToJPG
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  label: 'Web'
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        label: 'Fetch File by URL...'
                        itemValue: fetchFileByURL
                      )
                     )
                    nil
                    nil
                  )
                )
               (MenuItem
                  enabled: hasZipFileSelectedHolder
                  label: 'ZipFile Tool'
                  itemValue: openZipTool
                )
               (MenuItem
                  enabled: hasFileSelection
                  label: 'Hex Dump'
                  itemValue: fileHexDump
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Find'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'File...'
                  itemValue: fileFindFile
                )
               (MenuItem
                  enabled: hasFileSelection
                  label: 'Same Contents as Selected...'
                  itemValue: fileFindDuplicateFile
                )
               (MenuItem
                  label: 'Duplicate Files'
                  itemValue: fileFindDuplicates
                )
               (MenuItem
                  enabled: hasSelection
                  label: 'All Duplicate Files (Recursive)'
                  itemValue: fileFindAllDuplicates
                )
               (MenuItem
                  label: 'Similar Image Files'
                  itemValue: fileFindSimilarImages
                  isVisible: hasImageColorHistogram
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

viewDetailsMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#viewDetailsMenuSpec
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser viewDetailsMenuSpec)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #label: 'Hidden Files'
            #translateLabel: true
            #indication: #showHiddenFiles
          )
         )
        nil
        nil
      )
! !

!AbstractFileBrowser class methodsFor:'menu specs-scm'!

cvsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#cvsMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser cvsMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Commit (CVS)...'
            itemValue: cvsCommit
            translateLabel: true
          )
         (MenuItem
            enabled: canCvsAddAndCommit
            label: 'Add && Commit...'
            itemValue: cvsAddAndCommit
            translateLabel: true
          )
         (MenuItem
            enabled: canCvsAddAndCommit
            label: 'Add as Binary && Commit...'
            itemValue: cvsAddBinaryAndCommit
            translateLabel: true
          )
         (MenuItem
            label: 'Commit Folder (CVS)...'
            itemValue: cvsCommitFolder
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Update selected Files/Directories'
            itemValue: cvsUpdateSelection
            translateLabel: true
          )
         (MenuItem
            label: 'Update Directory Local'
            itemValue: cvsUpdateAll
            translateLabel: true
          )
         (MenuItem
            label: 'Update Directory Recursive'
            itemValue: cvsUpdateAllRecursive
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Tag...'
            itemValue: cvsTagSelection
            translateLabel: true
          )
         (MenuItem
            enabled: hasSelection
            label: 'Revision Log'
            itemValue: cvsRevisionLog
            translateLabel: true
          )
         (MenuItem
            enabled: hasSelection
            label: 'Compare with newest in Repository'
            itemValue: cvsCompareWithNewest
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: canRemoveCVSContainer
            label: 'Remove File && CVS Container...'
            itemValue: cvsRemoveFileAndCVSContainer
            translateLabel: true
          )
         )
        nil
        nil
      )
!

mercurialMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#mercurialMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser mercurialMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Add'
            itemValue: mercurialAdd
            translateLabel: true
          )
         (MenuItem
            label: 'Commit Changes'
            itemValue: mercurialCommit
            translateLabel: true
          )
         (MenuItem
            label: 'Push...'
            itemValue: mercurialPush
            translateLabel: true
          )
         (MenuItem
            label: 'Status'
            itemValue: mercurialStatus
            translateLabel: true
          )
         (MenuItem
            label: '-'
         )
         (MenuItem
            label: 'Init'
            itemValue: mercurialInit
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Modified: / 17-01-2012 / 15:57:40 / cg"
!

perforceMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:AbstractFileBrowser andSelector:#perforceMenu
     (Menu new fromLiteralArrayEncoding:(AbstractFileBrowser perforceMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Commit'
            itemValue: perforceCommit
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Created: / 15-01-2012 / 13:12:30 / cg"
! !

!AbstractFileBrowser class methodsFor:'misc'!

newLock
    ^ CodeExecutionLock new
! !

!AbstractFileBrowser class methodsFor:'queries'!

isAbstract
    ^ self == AbstractFileBrowser
! !

!AbstractFileBrowser class methodsFor:'resources'!

classResources
    ^ FileBrowser classResources
! !

!AbstractFileBrowser class methodsFor:'utilities'!

contentsOfBytesAsHexDump:data numberOfAddressDigits:addrDigits addressStart:virtualStart
    "utility helper: generate a hexDump with addresses"

    |lines nHexLines replacementForUnprintable|

    "/ used to be:
    "/ replacementForUnprintable := $.
    replacementForUnprintable := Character value:16rB7. "/ a centered dot.

    "generate a virtual collection which evaluates and returns lines on-demand"

    nHexLines := (data size + 15) // 16.

    lines := VirtualArray new.
    lines setSize:nHexLines + (nHexLines // 16).
    lines 
        generator:[:lineNr |
            |blockNr lineNrInBlock startOffset lineStream asciiLineStream byte line|

            blockNr := (lineNr - 1) // 17.
            lineNrInBlock := (lineNr - 1) \\ 17.

            lineNrInBlock == 16 ifTrue:[
                line := ''
            ] ifFalse:[
                startOffset := ((blockNr * 16) + lineNrInBlock) * 16.
                lineStream := String writeStream.
                asciiLineStream := String writeStream.

                lineStream nextPutAll:((startOffset+virtualStart) hexPrintString:addrDigits).
                lineStream nextPutAll:': '.
                1 to:16 do:[:i |
                    i ~~ 1 ifTrue:[ lineStream space ].

                    (startOffset + i) > data size ifTrue:[
                        asciiLineStream nextPut:(Character space).
                        lineStream nextPutAll:'  '.
                    ] ifFalse:[
                        byte := data at:startOffset + i.

                        lineStream nextPutAll:(byte hexPrintString:2).
                        
                        (byte between:32 and:127) ifTrue:[
                            asciiLineStream nextPut:(Character value:byte)
                        ] ifFalse:[
                            (byte between:0 and:31) ifTrue:[
                                "/ the 'nul', 'soh' .. 'gs' chars in unicodePage 2400
                                "/ are perfect here, but usually not available in the font
                                "/ and we have currently no way of knowing if they are...
                                "/ (could let the font draw into abitmap and check if there is something...)
                                "/ therefore, for now, write a dot.·
                                "/ asciiLineStream nextPut:(Character value:(byte + 16r2400))
                                asciiLineStream nextPut:replacementForUnprintable.
                            ] ifFalse:[
                                asciiLineStream nextPut:replacementForUnprintable.
                            ].
                        ].
                    ].
                ].
                line := (lineStream contents paddedTo:(addrDigits + 1 + (3*16)+ 8))
                        , asciiLineStream contents.
            ].
            line
        ].
    ^ lines.

"/    |offs 
"/     col line lineStream asciiLineStream lines|
"/
"/    col := 1.
"/    offs := virtualStart.
"/    lines := StringCollection new.
"/
"/    lineStream := String writeStream.
"/    asciiLineStream := String writeStream.
"/
"/    lineStream nextPutAll:(offs hexPrintString:addrDigits).
"/    lineStream nextPutAll:': '.
"/
"/    data do:[:byte |
"/        lineStream nextPutAll:(byte hexPrintString:2).
"/        (byte between:32 and:127) ifTrue:[
"/            asciiLineStream nextPut:(Character value:byte)
"/        ] ifFalse:[
"/            asciiLineStream nextPut:$.
"/        ].
"/
"/        offs := offs + 1.
"/        col := col + 1.
"/        col > 16 ifTrue:[
"/            lineStream nextPutAll:'        '.
"/            lineStream nextPutAll:asciiLineStream contents.
"/            lines add:(lineStream contents).
"/            (offs bitAnd:16rFF) == 0 ifTrue:[
"/                lines add:nil
"/            ].
"/            lineStream reset.
"/            asciiLineStream reset.
"/
"/            lineStream nextPutAll:(offs hexPrintString:addrDigits).
"/            lineStream nextPutAll:': '.
"/            col := 1.
"/        ] ifFalse:[
"/            lineStream space
"/        ]
"/    ].
"/    line := lineStream contents paddedTo:(3*16 + addrDigits + 1).
"/    lines add:(line , '        ' , asciiLineStream contents).
"/    ^ lines

    "Created: / 13-02-2012 / 15:01:46 / cg"
!

contentsOfFileAsHexDump:f
    ^ self contentsOfFileAsHexDump:f withLimit:nil lastPart:nil
!

contentsOfFileAsHexDump:f withLimit:limitOrNil lastPart:showLastPartOrNil
    |resources fileName stream data offs 
     addrDigits col lines answer sizeLimit showLastPart|

    resources := self classResources.

    fileName := f baseName.
    f isDirectory ifTrue:[
        Dialog warn:(resources string:'%1 is a directory.' with:fileName).
        ^ nil
    ].
    f exists ifFalse:[
        Dialog warn:(resources string:'oops, ''%1'' is gone or unreadable.' with:fileName).
        ^ nil
    ].
    f isReadable ifFalse:[
        Dialog warn:(resources string:'''%1'' is unreadable.' with:fileName).
        ^ nil
    ].
    f fileSize > (1024*1024) ifTrue:[
        limitOrNil notNil ifTrue:[
            sizeLimit := limitOrNil.
            showLastPart := showLastPartOrNil
        ] ifFalse:[
            answer := Dialog 
                            confirmWithCancel:(resources
                                                stringWithCRs:'"%1" is very large (%2).\\Show all or only the first 4 Mb ?' 
                                                with:(fileName contractTo:40) allBold 
                                                with:(UnitConverter fileSizeStringFor:f fileSize))
                            labels:#('Cancel' 'Show All' 'Show First Part' ).

            answer isNil ifTrue:[^ nil].
            answer ifTrue:[
                sizeLimit := 4 * 1024 * 1024
            ].
        ].
    ].

    stream := f readStream binary.
    sizeLimit notNil ifTrue:[
        showLastPart == true ifTrue:[
            stream position:(f fileSize - sizeLimit).
        ].
        data := stream nextBytes:sizeLimit.
    ] ifFalse:[
        data := stream contents.
    ].
    stream close.

    col := 1.
    offs := 0.
    lines := StringCollection new.

    addrDigits := ((f fileSize + 1) log:16) truncated + 1.

    ^ self 
        contentsOfBytesAsHexDump:data 
        numberOfAddressDigits:addrDigits
        addressStart:0

    "Modified: / 13-02-2012 / 15:01:19 / cg"
! !

!AbstractFileBrowser methodsFor:'actions'!

askForCommandFor:fileName thenDo:aBlock
    "setup and launch a querybox to ask for a unix command.
     Then evaluate aBlock passing the command-string as argument."

    |box osName commandString alwaysOpenLikeThisHolder openCmd suffix|

    osName := OperatingSystem platformName.

    box := FilenameEnterBox 
                title:(resources string:'Execute %1 command:' with:osName)
               okText:(resources string:'Execute')
               action:[:cmd | commandString := cmd].

    fileName notNil ifTrue:[
        self initialCommandFor:fileName into:box.
    ].
    alwaysOpenLikeThisHolder := false asValue.
    box verticalPanel add:((CheckBox label:'Always use this command for this file type') model:alwaysOpenLikeThisHolder).
    box directory:(self getDirWithoutFileName:fileName).
    box open.
    
    "/ box destroy.
    alwaysOpenLikeThisHolder value ifTrue:[
        openCmd := commandString upTo:$".
        suffix := fileName suffix.
        UserPreferences current 
            defaultFileOpenCommandFor:suffix put:(openCmd,' "%1"');
            beModified.
        self breakPoint:#cg.
    ].
    
    commandString notNil ifTrue:[
        aBlock value:commandString
    ].

    "Modified: / 7.9.1995 / 10:31:54 / claus"
    "Modified: / 16.9.1997 / 15:35:10 / stefan"
    "Modified: / 14.8.1998 / 14:12:52 / cg"
!

changeFileBrowserTitleTo:aString
    self 
        applicationNamed:#FileBrowserV2 
        ifPresentDo:[:app | app changeFileBrowserTitleTo:aString]
!

copyFileList
    "copy the fileList to the clipBoard"

    |fileList|

    fileList := self 
                    applicationNamed:#DirectoryContentsBrowser 
                    ifPresentDo:[:app | app browserFileList].

    fileList notNil ifTrue:[
        self copyFileListToClipBoard:fileList.
    ]
!

copyFileListToClipBoard:fileList
    "copy the itemList to the clipBoard"

    |stream|

    fileList isEmpty ifTrue:[^ self].

    stream := String writeStream.
    fileList size == 1 ifTrue:[
        stream nextPutAll:(fileList first asString).
    ] ifFalse:[
        fileList do:[:fileName |
            (fileName baseName ~= '..') ifTrue:[
                stream nextPutLine:(fileName asString).
            ]
        ].
    ].
    self window setClipboardText:stream contents.
!

copySelectedFilenames
    "copy the selected fileNames to the clipBoard"

    |fileList|

    fileList := self 
                    applicationNamed:#DirectoryContentsBrowser 
                    ifPresentDo:[:appl | appl selectedFileNames].
    fileList notNil ifTrue:[
        self copyFileListToClipBoard:fileList.
    ].
!

doAddArchiver
    |files|

    files := self currentSelectedFiles.
    files size == 1 ifFalse:[
        Dialog information:'Select exactly one archive.'.
        ^ self
    ].

    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl | appl doAddArchiverOn:files first].

    "Created: / 29-11-2011 / 19:01:31 / cg"
!

doAddTerminal
    |dir|

    dir := self currentDirectory.
    
    dir isNil ifTrue:[
        dir :=  Filename homeDirectory
    ].

    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl | appl addTerminalIn:dir].
!

doOpenSearchFile
    |item file|

    file := self firstSelectedFileName.
    file isNil ifTrue:[
        file := Filename homeDirectory asAbsoluteFilename.
    ].
    item := DirectoryContentsBrowser itemClass fileName:file.
    self openSearchFileOn:item.
!

doShowFileContents
    self 
        applicationNamed:#DirectoryContentsBrowser 
        ifPresentDo:[:appl | ^ appl doShowFileContents].

    ^ nil
!

doShowProperties
    "show long stat (file)-info"

    self fileGetInfo:true
!

enterAction
    self 
        applicationNamed:#DirectoryContentsBrowser 
        ifPresentDo:[:appl | appl ~~ self ifTrue:[ appl enterAction ]].
!

fileEncodingDialog
    "open a dialog to allow change of the file's character encoding.
     Files are converted to internal encoding when read, and converted back
     to this encoding when saved.
     Notice: currently, not too many encodings are supported by the system."

    |bindings encodings encodingDescr idx selectedEncoding|

    encodingDescr := CharacterEncoder supportedExternalEncodings.
    encodings := encodingDescr collect:[:d | d isNil ifTrue:[nil] ifFalse:[d first]].

    bindings := IdentityDictionary new.
    bindings at:#encodingList put:encodingDescr.
    bindings at:#selectedEncoding put:(encodings indexOf:self fileEncoding ifAbsent:1) asValue.
    bindings at:#lockFileEncoding put:(self lockFileEncodingHolder value asValue).

    (self openDialogInterface:#encodingDialogSpec withBindings:bindings)
    ifTrue:[
        idx := (bindings at:#selectedEncoding) value.
        selectedEncoding := encodings at:idx.
        selectedEncoding notNil ifTrue:[
            self fileEncoding:selectedEncoding asSymbol.
        ].
        self lockFileEncoding:(bindings at:#lockFileEncoding) value.
    ].

    "Modified: 30.6.1997 / 14:41:12 / cg"
!

gotoFile:aFilename 
    "select only if the file is not already in the selection"
    
    |currentFileNameHolder currentSel|

    currentFileNameHolder := self currentFileNameHolder.

    currentSel := currentFileNameHolder value.
    (currentSel includes:aFilename) ifFalse:[
        self withWaitCursorDo:[
            currentFileNameHolder value:(OrderedCollection with:(aFilename asAbsoluteFilename)).
        ]
    ].

    "Modified: / 29-12-2010 / 11:04:29 / cg"
!

lineEndConventionDialog
    "open a dialog to allow change of the line end conventions
     (when writing files)"

    |bindings|

    bindings := IdentityDictionary new.
    bindings at:#lineEndConvention put:(self lineEndConvention asValue).

    (self openDialogInterface:#lineEndConventionDialogSpec withBindings:bindings)
    ifTrue:[
        self lineEndConventionHolder value:(bindings at:#lineEndConvention) value asSymbol
    ].

    "Created: / 06-01-2012 / 15:34:51 / cg"
!

newTextEditor
    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl | 
            |editor files item|

            editor := appl newTextEditor.
            (files := self currentSelectedFiles) size == 1 ifTrue:[
                item := DirectoryContentsBrowser itemClass fileName:files first.
                editor item:item.     
            ].    
            ^ editor
        ].

    ^ nil.
!

openApplByFileItem:anItem
    "/ q: is the following always wanted ?
    self window sensor shiftDown ifFalse:[
        "/ cg: no - batch and shell scripts are to be
"/        anItem fileName isExecutableProgram ifTrue:[
"/            self executeCommand:anItem fileName pathName.
"/            ^ self.
"/        ].

"/        OperatingSystem isMSWINDOWSlike ifTrue:[
"/            Error handle:[:ex |
"/            ] do:[
"/                OperatingSystem
"/                    shellExecute:nil
"/                    lpOperation:'open'
"/                    lpFile:(anItem fileName pathName)
"/                    lpParameters:nil
"/                    lpDirectory:(self directory pathName)
"/                    nShowCmd:#SW_SHOWNORMAL.
"/                ^ self.
"/            ]
"/        ]
    ].
    ^ self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl | appl openApplByFileItem:anItem].

    "Modified: / 06-09-2011 / 11:11:15 / cg"
!

openApplForFile:aFilename
    ^ self openApplByFileItem:(DirectoryContentsBrowser itemClass fileName:aFilename).
!

openCommandResultApplication

    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl | ^ appl openCommandResultApplication].

    ^ nil
!

openNewTextEditorOn:anItem
    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl | ^ appl openNewTextEditorOn:anItem ].

    ^ nil
!

openSearchFileOn:anItem
    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl | ^ appl openSearchFileOn:anItem].

    ^ nil.
!

openTextEditorForFile:aFilename
    ^ self openTextEditorOn:(DirectoryContentsBrowser itemClass fileName:aFilename).
!

openTextEditorOn:anItem
    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl | ^ appl openTextEditorOn:anItem ].

    ^ nil.
!

openTextEditorOn:anItem type:aDirDescrOrFile
    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl | ^ appl openTextEditorOn:anItem type:aDirDescrOrFile].

    ^ nil.
!

setCurrentFileName:aFilename 
    self setCurrentFileNames:(OrderedCollection with:aFilename).
!

setCurrentFileNames:aCollectionOfFilenames 
    self currentFileNameHolder value:aCollectionOfFilenames.
!

tabStopConversionDialog
    "open a dialog to allow change of the tab stop conversion (when reading/writing files)"

    |bindings|

    bindings := IdentityDictionary new.
    bindings at:#tabStops put:(self inputTabColumnConversion asValue).

    (self openDialogInterface:#tabStopConversionDialogSpec withBindings:bindings)
    ifTrue:[
        self inputTabColumnConversionHolder value:(bindings at:#tabStops) value
    ].

    "Created: / 06-01-2012 / 15:36:06 / cg"
!

updateAndSelect:aColOfFiles
    self updateCurrentDirectory.
    aColOfFiles notNil ifTrue:[ 
        self setCurrentFileNames:aColOfFiles 
    ].
!

updateCurrentDirectory
    self updateCurrentDirectory:false
!

updateCurrentDirectory:withReread
    DirectoryContents flushCachedDirectoryFor:(self getBestDirectory).

    self 
        applicationNamed:#DirectoryContentsBrowser 
        ifPresentDo:[:appl | withReread ifTrue:[appl doUpdate] ifFalse:[appl doUpdateDirectoryContents]].
    self 
        applicationNamed:#DirectoryTreeBrowser     
        ifPresentDo:[:appl | appl doUpdate].
!

updateCurrentDirectoryWithReread
    self updateCurrentDirectory:true
!

withActivityIndicationDo:aBlock

    self activityVisibilityChannel value:true.
    [
        self withWaitCursorDo:[
            aBlock value.
        ]
    ] ensure:[
        self activityVisibilityChannel value:false.
    ]
! !

!AbstractFileBrowser methodsFor:'actions bookmarks'!

addBookmark
    self currentFilesAreInSameDirectory ifFalse:[^ self].
    self addBookmarks:(self currentSelectedDirectories).
    self class saveBookmarksInDefaultBookmarksFile
!

addBookmarks:aColOfDirectories
    aColOfDirectories do:[ :path |
        self class addBookmark:path
    ].
!

editBookmarks

    | default selectedDirectories |

    selectedDirectories := self currentSelectedDirectories.
    selectedDirectories notEmpty ifTrue:[default := selectedDirectories first].
    self class editBookmarksWithDefault: default.
!

hasBookmarks
    ^ self class hasBookmarks
!

hasBookmarksToRemove
    |bookmarks directories|

    directories := self currentSelectedDirectories.
    bookmarks := self class directoryBookmarks.
    ^ (bookmarks size > 0 and:[directories notEmpty])
!

removeBookmark
    self currentSelectedDirectories do:[:dir|
        self class removeBookmark:dir
    ].
!

saveBookmarks
     self class saveBookmarks
! !

!AbstractFileBrowser methodsFor:'actions history'!

addToCommandHistory:aCommandString for:aFilename
    |cmd suffix cmdHist historySize|

    cmdHist := self class commandHistory.
    (aCommandString notEmptyOrNil) ifTrue:[
        cmdHist notNil ifTrue:[
            cmdHist addFirst:aCommandString.
            historySize := self class commandHistorySize.
            (historySize notNil and:[cmdHist size > historySize]) ifTrue:[
                cmdHist removeLast
            ]
        ].
        aFilename notNil ifTrue:[
            cmd := aCommandString copyTo:(aCommandString indexOf:Character space ifAbsent:[aCommandString size + 1])-1.
            DefaultCommandPerSuffix isNil ifTrue:[
                DefaultCommandPerSuffix := Dictionary new.
            ].
            suffix := aFilename asFilename suffix.
            suffix notNil ifTrue:[
                DefaultCommandPerSuffix at:suffix put:cmd.
            ]
        ]
    ]
!

doBack
    "go backward in the history"

    | fileName|

    fileName := self directoryHistory goBackward.
    fileName notNil ifTrue:[
        self gotoFile:(fileName asFilename).
    ]
!

doForward
    "go forward in the history"

    | fileName|

    fileName := self directoryHistory goForward.
    fileName notNil ifTrue:[
        self gotoFile:(fileName asFilename).
    ] ifFalse:[
        self enableForward value:false.

    ].
! !

!AbstractFileBrowser methodsFor:'applications'!

applicationNamed:anApplicationName ifPresentDo:aBlock
    |appl|

    appl := self applications at:anApplicationName ifAbsent:nil.
    appl notNil ifTrue:[
        ^ aBlock value:appl
    ].
    ^ nil.
!

directoryContentsBrowser
    ^ self applications at:#DirectoryContentsBrowser ifAbsent:nil.
! !

!AbstractFileBrowser methodsFor:'aspects'!

applications
    ^ aspects at:#applications
!

backgroundProcesses

    ^ self aspectFor:#backgroundProcesses ifAbsent:[List new]
!

canMake
    ^ self aspectFor:#canMake ifAbsent:[ ValueHolder with:false ].
!

currentDirectories
    " returns a holder on a Collection of all currently selected directories  
      if only a file is selected, currentDirectories holds the directory of the file
    "

    ^ self aspectFor:#currentDirectories ifAbsent:[ (OrderedCollection new) asValue ].
!

currentDirectoriesValue
    " returns a Collection of all currently selected directories  
      if only a file is selected, currentDirectories holds the directory of the file
    "

    ^ self currentDirectories value
!

currentDirectory
    "return the single current directory or nil"

    |directories|

    directories := self currentSelectedDirectories.
    (directories size ~= 1) ifTrue:[
        ^ nil
    ].
    ^ directories first.
!

currentDirectoryDisplayed
    "Return a directory as Filename that is currently displayed in the browser"

    ^self subclassResponsibility

    "Created: / 14-01-2013 / 11:57:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentFileNameHolder
    "return a ValueHolder with an OrderedCollection containing all selected files.
     If no file but a directory is selected it contains the directories 
     in contrast to currentDirectories which have only the directories"

    ^ self aspectFor:#currentFileNameHolder 
        ifAbsent:[
            |currentSel|    

            currentSel := self class currentSelection.
            currentSel isEmpty ifTrue:[
                currentSel := OrderedCollection with:(Filename currentDirectory asAbsoluteFilename)
            ].
            currentSel asValue
        ] 
        notPresentDo:[:holder|
            |filenames newFilenames|
            filenames := holder value.
            newFilenames := Set new.
            filenames do:[:eachFilename|  
                |existingFilename|
                existingFilename := eachFilename. 
                existingFilename notNil ifTrue:[
                    [existingFilename isRootDirectory or:[existingFilename exists]] whileFalse:[
                        existingFilename := existingFilename directory.
                    ].
                    existingFilename exists ifTrue:[
                        newFilenames add:existingFilename.
                    ].
                ]
            ].
            newFilenames asOrderedCollection.
        ]

    "Modified: / 27-11-2010 / 15:42:45 / cg"
!

defaultFileEncoding
    ^ #'iso8859-1' "/ #'utf-8'
!

enableDirectoryUp

    ^ self aspectFor:#enableDirectoryUp ifAbsent:[ValueHolder with:false]
!

enableGotoDefaultDirectory
    ^ self aspectFor:#enableGotoDefaultDirectory ifAbsent:[ ValueHolder with:true ].
!

enableGotoDesktop
    "/ backward compatibility
    ^ self enableGotoDesktopDirectory.
!

enableGotoDesktopDirectory
    ^ self aspectFor:#enableGotoDesktopDirectory ifAbsent:[ ValueHolder with:true ].

    "Created: / 01-10-2010 / 16:19:17 / cg"
!

enableGotoSmalltalkDirectory
    ^ self aspectFor:#enableGotoSmalltalkDirectory ifAbsent:[ true asValue ].
!

enableGotoSmalltalkWorkspaceDirectory
    ^ self aspectFor:#enableGotoSmalltalkWorkspaceDirectory ifAbsent:[ true asValue ].
!

enableGotoTempDirectory
    ^ self aspectFor:#enableGotoTempDirectory ifAbsent:[ true asValue ].

    "Created: / 29-12-2010 / 11:01:17 / cg"
!

enableHome

    ^ self aspectFor:#enableHome ifAbsent:[ true asValue ].
!

enableMakeCurrentDirectory
    ^ self aspectFor:#enableMakeCurrentDirectory ifAbsent:[ true asValue ].

    "Created: / 26-10-2010 / 17:17:58 / cg"
!

enableViewNoteBookApplication

    ^ self aspectFor:#enableViewNoteBookApplication ifAbsent:[false asValue]
!

fileEncoding
    ^ self fileEncodingHolder value
!

fileEncoding:newEncoding
    self fileEncodingHolder value:newEncoding.

    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:nb | 
            |appl|

            appl := nb selectedApplication.
            (appl notNil and:[appl isTextEditor]) ifTrue:[
                appl fileEncoding:newEncoding
            ]
        ].
!

fileEncodingHolder
    ^ self 
        aspectFor:#fileEncodingHolder 
        ifAbsent:[
            self 
                applicationNamed:#FileApplicationNoteBook
                ifPresentDo:[:appl | appl fileEncodingHolder].
        ]
!

firstSelectedFileName
    |files|

    files := self currentSelectedObjects.
    files notEmpty ifTrue:[
        ^ files first
    ].
    ^ nil

    "Modified: / 04-12-2006 / 13:14:53 / cg"
!

gotoDefaultDirectoryIsVisible
    ^ true.
"/    ^ (Filename defaultDirectory asAbsoluteFilename) ~= (self smalltalkDirectory asAbsoluteFilename).

    "Modified: / 26-10-2010 / 17:23:51 / cg"
!

gotoDesktopDirectoryIsVisible
    Filename desktopDirectory = Filename homeDirectory ifTrue:[^ false].

    ^ (Filename desktopDirectory asAbsoluteFilename) ~= (self smalltalkDirectory asAbsoluteFilename).

    "Created: / 01-10-2010 / 16:26:27 / cg"
!

hasFileSelection
    ^ self aspectFor:#hasFileSelection ifAbsent:[ false asValue ].
!

hasNotTwoDirectoriesSelectedHolder
    ^ self 
        aspectFor:#hasNotTwoDirectoriesSelectedHolder
        ifAbsent:[
            BlockValue 
                with:[:m | self hasTwoDirectoriesSelected not]
                argument:self currentFileNameHolder
        ].

    "Created: / 20-05-2010 / 10:45:50 / cg"
!

hasNotTwoFilesSelectedHolder
    ^ self 
        aspectFor:#hasNotTwoFilesSelectedHolder
        ifAbsent:[
            BlockValue 
                with:[:m | self hasTwoFilesSelected not]
                argument:self currentFileNameHolder
        ].

    "Modified: / 20-05-2010 / 10:46:01 / cg"
!

hasSelection

    ^ self aspectFor:#hasSelection ifAbsent:[ false asValue ].
!

hasTwoDirectoriesSelectedHolder
    ^ self 
        aspectFor:#hasTwoDirectoriesSelectedHolder
        ifAbsent:[
            BlockValue 
                with:[:m | self hasTwoDirectoriesSelected]
                argument:self currentFileNameHolder
        ].

    "Created: / 20-05-2010 / 10:45:41 / cg"
!

hasTwoFilesSelectedHolder
    ^ self 
        aspectFor:#hasTwoFilesSelectedHolder
        ifAbsent:[
            BlockValue 
                with:[:m | self hasTwoFilesSelected]
                argument:self currentFileNameHolder
        ].

    "Modified: / 20-05-2010 / 10:46:08 / cg"
!

inputTabColumnConversion
    ^ self inputTabColumnConversionHolder value

    "Created: / 06-01-2012 / 15:25:56 / cg"
!

inputTabColumnConversionHolder
    ^ self 
        aspectFor:#inputTabColumnConversionHolder 
        ifAbsent:[
            self 
                applicationNamed:#FileApplicationNoteBook
                ifPresentDo:[:appl | appl inputTabColumnConversionHolder].
        ]

    "Created: / 06-01-2012 / 15:26:16 / cg"
!

lineEndConvention
    ^ self lineEndConventionHolder value asSymbol

    "Created: / 06-01-2012 / 13:05:14 / cg"
!

lineEndConvention: aSymbol
    self lineEndConventionHolder value: aSymbol asSymbol

    "Created: / 11-07-2012 / 19:51:58 / cg"
!

lineEndConventionHolder
    ^ self 
        aspectFor:#lineEndConventionHolder 
        ifAbsent:[
            self 
                applicationNamed:#FileApplicationNoteBook
                ifPresentDo:[:appl | appl lineEndConventionHolder].
        ]

    "Created: / 06-01-2012 / 13:02:51 / cg"
!

lockFileEncoding:aBoolean
    self lockFileEncodingHolder value:aBoolean.

    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:nb | 
            |appl|

            appl := nb selectedApplication.
            (appl notNil and:[appl isTextEditor]) ifTrue:[
                appl lockFileEncoding:aBoolean
            ]
        ].
!

lockFileEncodingHolder
    ^ self 
        aspectFor:#lockFileEncodingHolder 
        ifAbsent:[
            self 
                applicationNamed:#FileApplicationNoteBook
                ifPresentDo:[:appl | appl lockFileEncodingHolder].
        ]
!

makeCommandHolder
    ^ self aspectFor:#makeCommandHolder ifAbsent:[ nil asValue ].

    "Created: / 13-04-2012 / 17:01:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notify:aString
    "aString is shown in the lower pane"

    self notifyChannel value:aString

    "Modified (comment): / 11-01-2012 / 21:46:55 / cg"
!

notifyChannel

    ^ self aspectFor:#notifyChannel ifAbsent:['' asValue]
!

progressPercentageHolder
    ^ self aspectFor:#progressPercentageHolder ifAbsent:[ nil asValue ].

    "Created: / 11-10-2010 / 12:54:46 / cg"
!

rootHolder
    "holder, which keeps the rootHolder of the treeView
    "

    ^ self aspectFor:#rootHolder ifAbsent:[
        self class rootHolder asValue.
    ].
!

rootHolder:aHolder

    self aspectFor:#rootHolder put:aHolder
! !

!AbstractFileBrowser methodsFor:'aspects handling'!

aspectFor:something ifAbsent:aBlock
    "returns the model for an aspect; these are stored in a common dictionary"

    ^ self aspectFor:something ifAbsent:aBlock notPresentDo:nil
!

aspectFor:aKey ifAbsent:aBlock notPresentDo:notPresentBlock
    "returns the model for an aspect; these are stored in a common dictionary"

    |holder saveAspectItem aspect|

    holder := aspects at:aKey ifAbsent:[
        masterApplication notNil ifTrue:[
            holder := masterApplication aspectOrNil:aKey forSubApplication:self.
        ].
        holder isNil ifTrue:[
            saveAspectItem := self runtimeAspectValueFor:aKey.
            saveAspectItem notNil ifTrue:[
                saveAspectItem isHolder ifTrue:[
                    holder := ValueHolder with:saveAspectItem value 
                ] ifFalse:[
                    holder := saveAspectItem value 
                ].
            ] ifFalse:[
                aspect := self userPreferencesAspectValueFor:aKey.
                aspect notNil ifTrue:[ 
                    holder := aspect asValue
                ] ifFalse:[
                    holder := aBlock value.
                ]
            ].
        ].
        holder notNil ifTrue:[  
            notPresentBlock notNil ifTrue:[
                holder value:(notPresentBlock value:holder).
            ].
            aspects at:aKey put:holder
        ].
        holder
    ].
    ^ holder
!

aspectFor:something put:aValueHolder
    "stores the model for an aspect; these are stored in a common dictionary"

    aspects at:something put:aValueHolder
!

aspects
    "returns the common aspect dictionary"

    ^ aspects
!

runtimeAspectValueFor:something
    "returns the default aspect item from the class variable RuntimeAspects
    "
    ^ self class runtimeAspects at:something ifAbsent:nil.
!

saveAspectValues
    |prefs saveAspects aspectValue|

    prefs := UserPreferences current.
    
    saveAspects := self class userPreferencesAspectList keys.
    saveAspects do:[ :aspectKey |
        aspectValue := (self perform:aspectKey) value.
        prefs 
            at: ('fileBrowser_',aspectKey asString) asSymbol 
            put: aspectValue.
    ].
    prefs beModified.
    
    "Modified: / 04-09-2006 / 10:02:41 / cg"
!

saveRuntimeAspectValues
    |savedAspects dictionary value isHolder aspect|

    savedAspects := self class listOfRuntimeValuesToRemember.
    dictionary := Dictionary new.
    savedAspects do:[:aspectKey | 
        aspect := self perform:aspectKey.
        isHolder := aspect isValueModel.
        isHolder ifTrue:[
            value := aspect value
        ] ifFalse:[
            value := aspect
        ].
        dictionary at:aspectKey
            put:(SaveAspectItem withValue:value isHolder:isHolder)
    ].
    RuntimeAspects := dictionary.
!

userPreferencesAspectValueFor:something
    "returns the default aspect from the Userpreferences
    "

    (self class userPreferencesAspectList includesKey:something) ifFalse:[ ^ nil].
    ^ UserPreferences current 
        at:('fileBrowser_',something) asSymbol
        ifAbsent:nil "(self class userPreferencesAspectList at:something)".

    "Modified: / 14-10-2010 / 19:16:38 / cg"
! !

!AbstractFileBrowser methodsFor:'aspects-filter'!

filter:aString
    self filterModel value:aString
!

filterBackgroundColor

    ^ self aspectFor:#filterBackgroundColor ifAbsent:[Color white asValue]
!

filterBlockHolder

    ^ self aspectFor:#filterBlockHolder ifAbsent:[self makeFilterBlock asValue]
!

filterListModel

    ^ self aspectFor:#filterListModel ifAbsent:[self class defaultFilterList]
!

filterModel
    |m|

    m := self aspectFor:#filterModel ifAbsent:[(self filterListModel at:1) asValue].
    ^ m
!

filterModel:aHolder
    self aspectFor:#filterModel put:aHolder.
!

filterValueBox

    ^ self aspectFor:#filterValueBox ifAbsent:[ValueHolder new]
!

makeFilterBlock
    "return a two-arg filterblock on the file's path- and base-name. This block should return true for files
     to be shown"

    | filterString filterStrings filters notFilters showHidden filterBlock ignoreCase|

    filterString := self filterModel value.
    filterString = '' ifTrue:[filterString := '*'].
    ignoreCase := "ignoreCaseInPattern ? "(Filename isCaseSensitive not).

    filterStrings := filterString asCollectionOfSubstringsSeparatedBy:$;.
    filterStrings := filterStrings
                select:[:eachFilter | eachFilter withoutSeparators notEmpty].

    filters := filterStrings
                reject:[:eachFilter | eachFilter withoutSeparators startsWith:'~']
                thenCollect:
                    [:eachPattern |
                        |pattern|

                        pattern := eachPattern withoutSeparators.
                        pattern includesMatchCharacters ifFalse:[
                            "JV@2012-03-05: Add implict star at the beginning and at the end of pattern,
                             that's how most of the other applications behave - do what most users expect"
                            pattern first == $* ifFalse:[pattern := '*' , pattern].
                            pattern last  == $* ifFalse:[pattern := pattern , '*'].
                        ].

                       [:name :baseName | pattern match:baseName ignoreCase:ignoreCase]
                    ].

    notFilters := filterStrings
                select:[:eachFilter | eachFilter withoutSeparators startsWith:'~']
                thenCollect:
                    [:eachPattern |
                        |pattern|

                        pattern := eachPattern withoutSeparators.
                        pattern := (pattern copyFrom:2) withoutSeparators.
                        [:name :baseName | pattern match:baseName caseSensitive:ignoreCase not]
                    ].


    (filters size == 1 and:[notFilters isEmpty]) ifTrue:[ 
        filterBlock := filters first 
    ] ifFalse:[
        filters isEmpty ifTrue:[
            filterBlock := [:name :baseName | 
                               (notFilters contains:[:aFilter | aFilter value:name value:baseName ]) not
                           ].
        ] ifFalse:[
            notFilters isEmpty ifTrue:[
                filterBlock := [:name :baseName | 
                                   (filters contains:[:aFilter | aFilter value:name value:baseName ])
                               ].
            ] ifFalse:[
                filterBlock := [:name :baseName | 
                                   (filters contains:[:aFilter | aFilter value:name value:baseName ])
                                   and:[ (notFilters contains:[:aFilter | aFilter value:name value:baseName ]) not ]
                               ].
            ]
        ]
    ].

    showHidden := self showHiddenFiles value.
    showHidden ifTrue:[
        ^ filterBlock.
    ].
    ^ [:name :baseName | 
                name isHidden not and:[filterBlock value:name value:baseName]].

    "Modified: / 05-02-2012 / 01:42:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shownFiles

    ^ self aspectFor:#shownFiles ifAbsent:['-/-' asValue]
! !


!AbstractFileBrowser methodsFor:'aspects-history'!

dirHistory
    "obsolete"
    ^ self directoryHistory
!

directoryHistory
    ^ self class directoryHistory
!

enableBack

    ^ self aspectFor:#enableBack ifAbsent:[ValueHolder with:false]
!

enableFileHistory

    ^ self aspectFor:#enableFileHistory ifAbsent:[ValueHolder with:false]
!

enableForward

    ^ self aspectFor:#enableForward ifAbsent:[ValueHolder with:false]
!

fileHistory
    ^ self aspectFor:#fileHistory ifAbsent:[OrderedSet new]
! !

!AbstractFileBrowser methodsFor:'aspects-visibility'!

activityVisibilityChannel
    " activityVisibilityChannel switches the activity indicator on/off"

    ^ self aspectFor:#activityVisibilityChannel ifAbsent:[ ValueHolder with:false ].
!

alwaysUseSmalltalkTools
    " aspect to prevent os tools to be opened on double click"

    ^ self aspectFor:#alwaysUseSmalltalkTools ifAbsent:[ ValueHolder with:true ].
!

changeSetBrowserItemVisible
    ^ Screen current ctrlDown.
!

cvsMenusAreShown
    ^ ConfigurableFeatures includesFeature: #CVSSupportEnabled

    "Created: / 15-01-2012 / 13:00:05 / cg"
    "Modified: / 19-01-2012 / 10:43:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgMenusAreShown
     ^ (ConfigurableFeatures includesFeature: #HGSupportEnabled)

    "Created: / 14-01-2013 / 11:53:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mercurialMenusAreShown
    ^ ConfigurableFeatures hasMercurialSupportEnabled

    "Created: / 15-01-2012 / 13:00:00 / cg"
!

openAlwaysInTextEditor
    " aspect for open every file in TextEditor don't use e.g. HtmlEditor for *.html'"

    ^ self aspectFor:#openAlwaysInTextEditor ifAbsent:[ false asValue ].
!

openMultipleApplicationsForType

    " aspect for open more applications for e.g. TextEditor and not change the contents of already 
      open TextEditor "

    ^ self aspectFor:#openMultipleApplicationsForType ifAbsent:[ false asValue ].
!

perforceMenusAreShown
    ^ (ConfigurableFeatures includesFeature: #PerforceSupportEnabled)
    and:[ ConfigurableFeatures hasPerforceSupportEnabled ]

    "Created: / 15-01-2012 / 13:12:11 / cg"
    "Modified: / 19-01-2012 / 10:43:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2012 / 11:19:59 / cg"
!

showDirectoriesOnTop

    ^ self aspectFor:#showDirectoriesOnTop ifAbsent:[ false asValue ]

    "Created: / 12-08-2014 / 13:02:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showDirectoryTree

    ^ self aspectFor:#showDirectoryTree ifAbsent:[ true asValue ]
!

showDiskUsageHolder
    |holder|

    holder := self aspectFor:#showDiskUsageHolder ifAbsent:[ false asValue].
    holder addDependent:self.
    ^ holder
!

showHiddenFiles

    ^ self aspectFor:#showHiddenFiles ifAbsent:[ true asValue ].

    "Modified: / 15-10-2010 / 10:28:17 / cg"
!

showHiddenFiles:aHolder
    self aspectFor:#showHiddenFiles put:aHolder.
!

shownFiles:aHolder
    self aspectFor:#shownFiles put:aHolder.
!

svnMenusAreShown
    ^ ConfigurableFeatures includesFeature: #SubversionSupportEnabled

    "Created: / 15-01-2012 / 13:02:03 / cg"
    "Modified: / 19-01-2012 / 10:43:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tagsBrowserVisibleHolder
    masterApplication notNil ifTrue:[
        ^ masterApplication perform:#tagsBrowserVisibleHolder ifNotUnderstood:false
    ].
    ^ self aspectFor:#tagsBrowserVisibleHolder ifAbsent:[ FileApplicationNoteBook::TextEditor defaultTagsBrowserVisible asValue ].

    "Created: / 27-06-2011 / 16:02:59 / cg"
!

useCodeView2InTools
    ^ self aspectFor:#useCodeView2InTools ifAbsent:[ UserPreferences current useCodeView2InTools asValue ].

    "Created: / 06-10-2011 / 11:45:58 / cg"
!

userContextAvailable

    " aspect for show group and user columns in contents view
      windows provides no user context"

    ^ OperatingSystem isMSWINDOWSlike not 
!

viewDescription
    "aspect for show file description in DirectoryContentsBrowser"

    ^ self directoryContentsBrowser viewDescription
!

viewDetails
    "aspect for show more file properties in DirectoryContentsBrowser 
    "

    |directoryContentsBrowser|

    directoryContentsBrowser := self directoryContentsBrowser.
    directoryContentsBrowser isNil ifTrue:[^ nil].    
    ^ directoryContentsBrowser viewDetails
!

viewDirectoryDescription

    " aspect for auto open a TextView for Readme and other see getInfoItem Method files 
      on change directory "

    ^ self aspectFor:#viewDirectoryDescription ifAbsent:[ true asValue ].
!

viewDirsInContentsBrowser

    ^ self aspectFor:#viewDirsInContentsBrowser ifAbsent:[ false asValue ].

    "
     UserPreferences current viewDirsInContentsBrowser
    "
!

viewFilesInContentsBrowser

    ^ self aspectFor:#viewFilesInContentsBrowser ifAbsent:[ true asValue ].
!

viewFilesInDirectoryTree

    " aspect for view files in tree view (not only directories) "

    ^ self aspectFor:#viewFilesInDirectoryTree ifAbsent:[ false asValue ].
!

viewGroup
    " aspect for show group information in DirectoryContentsBrowser "

    ^ self directoryContentsBrowser viewGroup
!

viewIcon
    " aspect for show file-type icon in DirectoryContentsBrowser "

    ^ self directoryContentsBrowser viewIcon
!

viewInodeNumber
    " aspect for show inode numbers in DirectoryContentsBrowser "

    ^ self directoryContentsBrowser viewInodeNumber
!

viewNoteBookApplicationHolder

    ^ self aspectFor:#viewNoteBookApplicationHolder ifAbsent:[ false asValue].
!

viewOwner
    " aspect for show owner information in DirectoryContentsBrowser "

    ^ self directoryContentsBrowser viewOwner
!

viewPermissions
    " aspect for show permission information in DirectoryContentsBrowser "

    ^ self directoryContentsBrowser viewPermissions
!

viewPreview
    " aspect for show image previev in DirectoryContentsBrowser "

    ^ self directoryContentsBrowser viewPreview
!

viewSize
    " aspect for show size information in DirectoryContentsBrowser "

    ^ self directoryContentsBrowser viewSize
!

viewSizeInBytes
    " aspect for show size-in-bytes information in DirectoryContentsBrowser "

    ^ self directoryContentsBrowser viewSizeInBytes
!

viewSizeInKiloBytes
    " aspect for show size-in-kilobytes information in DirectoryContentsBrowser "

    ^ self directoryContentsBrowser viewSizeInKiloBytes
!

viewTime
    " aspect for show time information in DirectoryContentsBrowser"

    ^ self directoryContentsBrowser viewTime
!

viewType
    " aspect for show suffix (type) information in DirectoryContentsBrowser"

    ^ self directoryContentsBrowser viewType
! !

!AbstractFileBrowser methodsFor:'background processing'!

executeCommand:cmd

    self executeCommand:cmd inDirectory:nil
!

executeCommand:cmd inDirectory:aDirectoryOrNil
    | nameString executionBlock|

    executionBlock := self getExecutionBlockForCommand:cmd inDirectory:aDirectoryOrNil.
    nameString := 'Execute: ', cmd.
    self makeExecutionResultProcessFor:executionBlock withName:nameString.
!

getExecutionBlockForCommand:cmd

    ^ self getExecutionBlockForCommand:cmd inDirectory:nil
!

getExecutionBlockForCommand:cmd inDirectory:directoryOrNil
    | dir|

    dir := directoryOrNil.
    directoryOrNil isNil ifTrue:[
        dir := self theSingleSelectedDirectoryOrNil.
        dir isNil ifTrue:[ 
            Dialog warn:(resources string:'Please select a single directory.').
            AbortOperationRequest raise.
            ^ nil
        ].
    ].

    ^ [:stream| 
        stream notNil ifTrue:[
            OperatingSystem 
                executeCommand:cmd
                inputFrom:nil 
                outputTo:stream 
                errorTo:stream 
                inDirectory:dir
                lineWise:true
                showWindow:false
                onError:[:status| false].
        ]
      ].
!

killAllRunningBackgroundProcesses

    self backgroundProcesses do:[ : process |
        self notify:'kill ', process name.
        process terminate.    
    ].
!

makeExecutionResultProcessFor:aBlock withName:aString
    | stream process appl nameString|

    appl := self openCommandResultApplication.
    stream := appl resultStream.
    nameString := aString ? 'Execution Result'.
    appl changeTabTo:nameString.

    process := 
        [ 
            [aBlock value:stream] 
            ensure:[
                self backgroundProcesses remove:process ifAbsent:[].
                appl process value:nil.

                "/ close automatically, if there was no output.
"/                        appl resultStream contents isEmpty ifTrue:[
"/                            appl doClose.
"/                        ]
                stream nextPutLine:'Done.'.
                self enqueueMessage:#updateCurrentDirectory.
            ]
        ] newProcess.
    process priority:(Processor userBackgroundPriority).
    process name:nameString.
    self backgroundProcesses add:process.
    appl process value:process.
    process resume.
! !

!AbstractFileBrowser methodsFor:'change & update'!

currentFileNameHolderChanged
    "/ self currentFileNameHolderChangedForCommon
!

currentFileNameHolderChangedForCommon
    |newDirectories oldDirectories size rootInTreeView selection selectionNotEmpty|

    selection := self currentSelectedObjects.
    self class currentSelection:selection.

    selectionNotEmpty := selection notEmptyOrNil.
    self hasSelection value:selectionNotEmpty.
    self hasFileSelection value:(selectionNotEmpty and:[self firstSelectedFile notNil]).

    newDirectories := self directoriesForFiles:selection.
    oldDirectories := self currentSelectedDirectories.
    oldDirectories ~= newDirectories ifTrue:[
        self currentDirectories value:newDirectories.
        size := newDirectories size.
        rootInTreeView := self 
                            applicationNamed:#DirectoryTreeBrowser 
                            ifPresentDo:[:appl | appl rootHolder].
        rootInTreeView := rootInTreeView value.
        self enableDirectoryUp value:(((size == 1) and:[newDirectories first isRootDirectory not]) "or:[(rootInTreeView notNil and:[rootInTreeView value asFilename isRootDirectory not])]").

        newDirectories notEmpty ifTrue:[
            self directoryHistory addToHistory:(newDirectories first asString).
        ].
        self enableHome value:((newDirectories includes:(Filename homeDirectory asAbsoluteFilename))not).
        "/ self enableGotoDesktop value:((newDirectories includes:(Filename desktopDirectory asAbsoluteFilename))not).
        self enableGotoDefaultDirectory value:((newDirectories includes:(Filename defaultDirectory asAbsoluteFilename))not).
        self enableGotoSmalltalkDirectory value:((newDirectories includes:(self smalltalkDirectory asAbsoluteFilename))not).
        self enableGotoDesktopDirectory value:((newDirectories includes:(Filename desktopDirectory asAbsoluteFilename))not).
        self enableGotoTempDirectory value:((newDirectories includes:(self tempDirectory asAbsoluteFilename))not).
    ].
    self enableGotoDefaultDirectory value:(self currentDirectory isNil or:[self currentDirectory pathName ~= OperatingSystem getCurrentDirectory]).
    self enableMakeCurrentDirectory value:(newDirectories size == 1
                                           and:[ newDirectories first asFilename pathName ~= OperatingSystem getCurrentDirectory ]).
    self enableForward value:self canForward.
    self enableBack    value:self canBackward.

    self updateCanMake.

    "Modified: / 29-12-2010 / 11:01:52 / cg"
    "Modified: / 17-12-2013 / 08:23:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filterModelChanged

    self filterBlockHolder value:(self makeFilterBlock).
!

update:something with:aParameter from:changedObject

    " do here all the things that have to be done for every part of the FileBrowserV2
      and the things that have to be done if it runs standalone "

    changedObject == self currentFileNameHolder ifTrue:[
        self currentFileNameHolderChangedForCommon.
        ^ self
    ].
    changedObject == self sortCaseless ifTrue:[
        self sortFileListsBy:#baseName withReverse:false.
        ^ self
    ].             
    changedObject == self sortBlockProperty ifTrue:[
        self currentSortOrder value at:#reverse put:false.
        ^ self
    ].             
    (changedObject == self filterModel or:[changedObject == self showHiddenFiles]) ifTrue:[
        self filterModelChanged.
        ^ self
    ].
    changedObject == self rootHolder ifTrue:[
        self class rootHolder:(self rootHolder value).
        ^ self
    ].
    changedObject == self showDiskUsageHolder ifTrue:[
        self notify:nil.
        ^ self
    ].

    super update:something with:aParameter from:changedObject
!

updateCanMake
    |dir can|

    can := false.
    dir := self currentDirectory.
    dir notNil ifTrue:[    
        "/ Check for make
        can := (dir asFilename construct:'Makefile') exists.
        can ifFalse:[
            can := (dir asFilename construct:'makefile') exists.
        ].
        OperatingSystem isMSWINDOWSlike ifTrue:[
            can ifFalse:[
                can := (self currentDirectory asFilename construct:'bc.mak') exists.
            ]
        ].
        can ifTrue:[ 
            self makeCommandHolder value: 'make'. 
            self canMake value: true. 
            ^ self 
        ].

        "/Check for Apache ant
        (OperatingSystem canExecuteCommand: 'ant') ifTrue:[
            can := (dir asFilename construct:'build.xml') exists.
            can ifTrue:[ 
                self makeCommandHolder value: 'ant'. 
                self canMake value: true. 
                ^ self 
            ].
        ].

        "/Add more here...

    ].
    self canMake value:can.

    "Modified: / 17-12-2013 / 08:13:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateListAfterDelete:colOfFiles
    self updateCurrentDirectory
! !

!AbstractFileBrowser methodsFor:'clipboard'!

canPaste

    ^ self aspectFor:#canPaste ifAbsent:[ ValueHolder with:false ].
!

clipboard

    ^ self aspectFor:#clipboard ifAbsent:[Clipboard new]
!

copyFilesToClipBoard:colOfFiles
    self putInClipBoard:colOfFiles as:#copy.
!

cutFilesToClipBoard:colOfFiles
    "defete current selected files/directories
    "
    self putInClipBoard:colOfFiles as:#cut.
!

emptyClipBoard

    self clipboard files:nil.
    self canPaste value:false.
!

putInClipBoard:colOfFiles as:aSymbol
    | stream clp|

    colOfFiles isEmpty ifTrue:[ ^ self].
    clp := self clipboard.
    clp files:nil.
    clp method:aSymbol.

    stream := String writeStream.
    stream nextPutAll:aSymbol asString.
    stream nextPutAll:' <'.
    stream nextPutAll:colOfFiles first asString.
    colOfFiles size > 1 ifTrue:[
        stream nextPutAll:' ...'.
    ].
    stream nextPutAll:'> to clipboard'.

    self notify:stream contents.
    clp files:colOfFiles.
    self canPaste value:true.
! !

!AbstractFileBrowser methodsFor:'drag & drop'!

canDropFiles:dropedObjects for:filename 
    |filenameDirString filenameDir|

    dropedObjects isEmpty ifTrue:[^ false].

    filenameDir := self getDirWithoutFileName:filename.
    filenameDir isNil ifTrue:[^ false ].
    filenameDir isWritableDirectory ifFalse:[^ false].

    filenameDirString := filenameDir asString.

    dropedObjects do:[:aDropObject | 
        (self canDropObject:aDropObject into:filenameDir) ifFalse:[^ false].
"/        |dropFileName dropFileNameString physicalPathName|
"/
"/        dropFileName := aDropObject theObject.
"/        dropFileNameString := dropFileName asString.
"/        dropFileName isDirectory ifTrue:[
"/            (self fileName:filenameDirString startsWith:dropFileNameString) ifTrue:[
"/                self notify:'Cannot drop a directory into one of its parent directories'.
"/                ^ false
"/            ]
"/        ] ifFalse:[
"/            physicalPathName := dropFileName physicalPathName.
"/            (filenameDirString = dropFileName directory asString 
"/            or:[ aDropObject isFileInArchive not and:[physicalPathName notNil
"/                 and:[ filenameDirString = physicalPathName asFilename directory asString]]]) ifTrue:[
"/                self notify:'Cannot drop a file into same directory'.
"/                ^ false
"/            ]
"/        ]
    ].
    self notify:nil.
    ^ true
!

canDropObject:aDropObject into:aDirectory
    |filenameDirString dropFileName dropFileNameString physicalPathName|

    dropFileName := aDropObject theObject.
    dropFileNameString := dropFileName asString.
    dropFileName isDirectory ifTrue:[
        filenameDirString := aDirectory asString.
        (self fileName:filenameDirString startsWith:dropFileNameString) ifTrue:[
            self notify:'Cannot drop a directory into one of its parent directories'.
            ^ false
        ]
    ] ifFalse:[
        physicalPathName := dropFileName physicalPathName.
        (aDirectory = dropFileName directory 
        or:[ aDropObject isFileInArchive not 
             and:[physicalPathName notNil
             and:[ aDirectory = physicalPathName asFilename directory]]]) ifTrue:[
            self notify:'Cannot drop a file into same directory'.
            ^ false
        ]
    ].
    ^ true.
!

canDropObjects:aCollectionOfDropObjects in:aWidget
    ^ aCollectionOfDropObjects contains:[:dropObject | dropObject isFileObject]

    "Created: / 13-10-2006 / 15:52:49 / cg"
!

doStartDrag:arg1 in:arg2
    ^ self class doStartDrag:arg1 in:arg2
!

dropObjects:aCollectionOfDropObjects in:aWidget at:position
    |fileEntryFieldHolder destDir dropObject fn d|

    fileEntryFieldHolder := self masterApplication notNil 
                              ifTrue:[ self masterApplication fileEntryFieldHolder ]
                              ifFalse:[ self fileEntryFieldHolder ].

    aWidget model == fileEntryFieldHolder ifTrue:[
        dropObject := aCollectionOfDropObjects first.
        dropObject isFileObject ifTrue:[
            fn := dropObject theObject asFilename.
            dropObject isDirectory ifTrue:[
                d := fn.
            ] ifFalse:[
                d := fn directory.
            ].
            fileEntryFieldHolder value:d pathName.
        ].
        ^ self.
    ].

    destDir := self currentDirectory.
    destDir isNil ifTrue:[^ self].

    self withWaitCursorDo:[
        aCollectionOfDropObjects do:[:dropObject |
            |fn|

            dropObject isFileObject ifTrue:[
                fn := dropObject theObject asFilename.
                dropObject isDirectory ifTrue:[
                    fn recursiveCopyTo:destDir
                ] ifFalse:[
                    fn copyTo:(destDir / fn baseName )
                ]
            ]
        ].
    ].
    self directoryContentsBrowser notNil ifTrue:[
        self directoryContentsBrowser 
            directoryContentsChangeFlag:true;
            wakeUp
    ].

    "Created: / 13-10-2006 / 18:26:41 / cg"
! !

!AbstractFileBrowser methodsFor:'file operations'!

copyFile:aSourceFile to:aDestFile
    "copy to"

    ^ self copyFile:aSourceFile to:aDestFile repairCorruptedFiles:false

    "Modified: / 07-02-2007 / 18:46:44 / cg"
!

copyFile:aSourceFile to:aDestFile repairCorruptedFiles:repairCorruptedFiles
    "copy to"

    |copyOperation msg|

    repairCorruptedFiles ifTrue:[
        copyOperation := FileOperation copyCorruptedFile:aSourceFile to:aDestFile
    ] ifFalse:[
        copyOperation := FileOperation copyFile:aSourceFile to:aDestFile withOverWriteWarning:true copyFileIfSame:true.
    ].
    copyOperation result ifTrue:[
        msg := ('copy ', aSourceFile baseName, ' to:,', aDestFile baseName).
    ] ifFalse:[
        msg := copyOperation errorString.
    ].
    self notify:msg.
    ^ copyOperation result

    "Created: / 07-02-2007 / 18:46:34 / cg"
!

copyFiles:aColOfSourceFiles to:aDirectory 
    |copy result|

    self withActivityIndicationDo:[
        copy := FileOperation copyFiles:aColOfSourceFiles to:aDirectory.
        copy result ifTrue:[
            result := Dictionary withKeys:(copy collectionOfCopiedFiles) andValues:(copy collectionOfNewFiles).
        ] ifFalse:[
            self notify:copy errorString.
        ].
        self updateCurrentDirectory.
    ].
    ^ result

    "Modified: / 25-07-2006 / 09:07:04 / cg"
!

copyFromToRepairingCorruptedFiles
    "ask for source and destination and copy the entered file.
     Especially useful for raw devices to copy corrupted disks/files
    "

    |source destination|

    source := Dialog 
                    requestDirectoryName:(resources string:'Copy from:') 
                    default:(LastMoveDestination ? self currentDirectory)
                    ok:(resources string:'Continue')
                    abort:nil.

    source isEmptyOrNil ifTrue:[^ self].
    source := source asFilename.

    destination := Dialog 
                    requestDirectoryName:(resources string:'Copy "%1" to:' with:source) 
                    default:(LastMoveDestination ? self currentDirectory)
                    ok:(resources string:'Copy')
                    abort:nil.

    destination isEmptyOrNil ifTrue:[^ self].
    destination := destination asFilename.

    self copyFile:source to:destination repairCorruptedFiles:true.
!

copyOrMoveDialog:aCollectionOfFiles for:aDestinationDirectory
    |size msg answer file|

    size := aCollectionOfFiles size.

"/    stream := WriteStream on:'' asText.
"/    stream nextPutAll:'Copy or move'; cr; cr; nextPutAll:'file'.
"/    size == 1 ifFalse:[
"/        stream nextPutAll:'s'.
"/    ].
"/    stream nextPutAll:': '.
"/    stream nextPutAll:aCollectionOfFiles first baseName asString allBold.
"/    size == 1 ifFalse:[
"/        stream nextPutAll:' ... '.
"/        stream nextPutAll:aCollectionOfFiles last baseName asString.
"/    ].
"/    stream cr; nextPutAll:'to: '.
"/    stream nextPutAll:aDestinationDirectory asFilename pathName allBold.
"/    msg := stream contents
    size == 1 ifTrue:[
        file := aCollectionOfFiles first.
        msg := resources    
                stringWithCRs:'Copy or move\\%1:\    %2\to:\    %3 ?'
                with:(file type == #regular ifTrue:'file' ifFalse:[file isDirectory ifTrue:'directory' ifFalse:'object'])
                with:(file baseName allBold)
                with:(aDestinationDirectory asFilename pathName allBold).
    ] ifFalse:[
        msg := resources    
                stringWithCRs:'Copy or move\\    %1 objects\to:\    %2 ?'
                with:size
                with:(aDestinationDirectory asFilename pathName allBold).
    ].

    answer := OptionBox 
                  request:msg 
                  label:(resources string:'Copy or Move')
                  image:(WarningBox iconBitmap)
                  buttonLabels:(resources array:#('Cancel' 'Move' 'Copy' 'Copy As...'))
                  values:#(#cancel #move #copy #copyAs)
                  default:#copy.
    answer isNil ifTrue:[answer := #cancel].
    ^ answer.
!

copyOrMoveFiles:aColOfSourceFiles to:aDestinationDirectory 
    "copy or move aColOfSourceFiles to aDirectory.
     Asks the used if a move or a copy is wanted.
     Returns true if the copyOrMove happened, false if user aborted the operation."

    |answer lastOld lastNew|

    answer := self copyOrMoveDialog:aColOfSourceFiles for:aDestinationDirectory.
    answer == #copyAs ifTrue:[
        aColOfSourceFiles do:[:eachSourceFile |
            |initial destFile srcBase dstBase|

            srcBase := eachSourceFile asFilename baseName.
            lastOld isNil ifTrue:[
                initial := srcBase
            ] ifFalse:[
                initial := DoWhatIMeanSupport
                            goodRenameDefaultForFile:srcBase lastOld:lastOld lastNew:lastNew.
            ].
            dstBase := Dialog request:('Copy %1 as:' bindWith:srcBase) initialAnswer:initial.
            dstBase isNil ifTrue:[^ false].
            self copyFile:eachSourceFile to:(aDestinationDirectory construct:dstBase).
            lastOld := srcBase.
            lastNew := dstBase.
        ].

        ^ true.
    ].
    answer == #copy ifTrue:[
        self copyFiles:aColOfSourceFiles to:aDestinationDirectory.
        ^ true.
    ].
    answer == #move ifTrue:[
        self moveFiles:aColOfSourceFiles to:aDestinationDirectory.
        ^ true.
    ].
    ^ false.
!

copySelectionTo
    "copy the selected file(s) to another directory"

    self copySelectionToRepairingCorruptedFiles:false.
    self updateCurrentDirectoryWithReread.

    "Modified: / 07-02-2007 / 18:42:48 / cg"
!

copySelectionToRepairingCorruptedFiles
    "copy the selected file(s) to another directory"

    self copySelectionToRepairingCorruptedFiles:true.
    self updateCurrentDirectoryWithReread.

    "Created: / 07-02-2007 / 18:42:59 / cg"
!

copySelectionToRepairingCorruptedFiles:repairingCorruptedFiles
    "copy the selected file(s) to another directory"

    |selectedFiles msg destination directory|

    selectedFiles := self currentSelectedObjects copy.
    selectedFiles isEmptyOrNil ifTrue:[^ self].

    msg := (selectedFiles size > 1) 
                ifTrue:[ 'Copy Selected Items to Directory:' ]
                ifFalse:[ 'Copy "%1" to Directory:' ].

    destination := Dialog 
                    requestDirectoryName:(resources stringWithCRs:msg with:selectedFiles first baseName) 
                    default:(LastMoveDestination ? self currentDirectory)
                    ok:(resources string:'Copy')
                    abort:nil.

    destination isEmptyOrNil ifTrue:[^ self].
    destination := destination asFilename.

    destination isDirectory ifFalse:[
        selectedFiles size == 1 ifTrue:[
            directory := destination directory.
            directory isDirectory ifTrue:[
                LastMoveDestination := directory.
                self copyFile:selectedFiles first to:destination repairCorruptedFiles:repairingCorruptedFiles.
                ^ self.
            ]
        ]
    ].

    LastMoveDestination := destination.
    repairingCorruptedFiles ifTrue:[
        selectedFiles do:[:eachFile |    
            self copyFile:eachFile to:destination repairCorruptedFiles:repairingCorruptedFiles.
        ].
        ^ self.
    ] ifFalse:[
        self copyFiles:selectedFiles to:destination
    ]

    "Created: / 07-02-2007 / 18:42:35 / cg"
!

deleteFile:aFile
    "delete the selected files/directories"

    ^ self deleteFiles:(OrderedCollection with:aFile).
!

deleteFiles:colOfFiles
    "delete some files/directories"

    ^ self deleteFiles:colOfFiles confirm:true.
!

deleteFiles:colOfFiles confirm:confirm
    "delete some files/directories"

    |delete result|

    self withActivityIndicationDo:[
        ProgressNotification handle:[:info |
            self progressPercentageHolder value:info progressValue.
            info proceed
        ] do:[
            delete := FileOperation deleteFiles:colOfFiles confirm:confirm.
            result := delete result.
        ].
        result notNil ifTrue:[
            result ifFalse:[
                self notify:delete errorString.
            ] ifTrue:[
                self updateListAfterDelete:colOfFiles.
            ]
        ].
    ].
    ^ result.

    "Modified: / 11-10-2010 / 13:08:24 / cg"
!

eraseFiles:colOfFiles
    "erase (clear and delete) some files/directories"

    ^ self eraseFiles:colOfFiles confirm:true.
!

eraseFiles:colOfFiles confirm:confirm
    "erase (clear and delete) some files/directories"

    |deleteOperation result fileSize|

    self withActivityIndicationDo:[
        fileSize := colOfFiles first asFilename fileSize.
        deleteOperation := FileOperation eraseFiles:colOfFiles confirm:confirm.
        (colOfFiles size == 1 and:[ fileSize < (10*1024*1024) ])
        ifTrue:[
            result := deleteOperation result.
        ] ifFalse:[
            ProgressIndicator
                displayProgressNotifications:'Erasing' 
                abortable:true 
                at:nil 
                during:[
                    result := deleteOperation result.
                ].
        ].

        result notNil ifTrue:[
            result ifFalse:[
                self notify:deleteOperation errorString.
            ] ifTrue:[
                self updateListAfterDelete:colOfFiles.
            ]
        ].
    ].
    ^ result.

    "Modified: / 25-07-2006 / 09:07:16 / cg"
!

moveFile:aSourceFile to:aDestFile
    "move a file/directory"

    |move|

    move := FileOperation moveFile:aSourceFile to:aDestFile.
    move result ifTrue:[
        self notify:(resources string: 'move "%1" to "%2"' with:aSourceFile asString with:aDestFile asString).
    ] ifFalse:[
        self notify:move errorString.
    ].
    self updateCurrentDirectory.
    ^ move result
!

moveFiles:aColOfSourceFiles to:aDirectory 
   "move some files to aDirectory"

    |move|

    self withActivityIndicationDo:[
        move := FileOperation moveFiles:aColOfSourceFiles to:aDirectory.
        move result ifFalse:[
            self notify:move errorString.
        ].
        self updateCurrentDirectory.
    ].
    ^ move collectionOfMovedFiles

    "Modified: / 25-07-2006 / 09:07:32 / cg"
!

moveSelectionTo
    "move the selected file(s) to another directory"

    |destinationDirectory|

    destinationDirectory := Dialog 
                                requestDirectoryName:(resources stringWithCRs:'Move Selected Items to Directory:') 
                                default:(LastMoveDestination ? self currentDirectory)
                                ok:(resources string:'Move')
                                abort:nil.
    destinationDirectory isEmptyOrNil ifTrue:[^ self].

    LastMoveDestination := destinationDirectory.
    self moveFiles:(self currentSelectedObjects copy) to:destinationDirectory asFilename.
    self updateCurrentDirectoryWithReread.


    "Modified: / 04-12-2006 / 13:15:12 / cg"
!

newDirectory
    "ask for and create a new directory"

    |selectedFiles singleSelectedFile defaultAnswer directory createOp newFile mime|

    directory := self currentDirectory.
    directory isNil ifTrue:[
        self warn:'Select a single directory to create a directory'.
        ^ self
    ].

    "/ clever default if selection is an archive...
    selectedFiles := self currentSelectedFiles.
    selectedFiles size == 1 ifTrue:[
        singleSelectedFile := selectedFiles first.

        mime := MIMETypes mimeTypeForFilename:singleSelectedFile.
        (mime notNil and:[mime isArchiveType]) ifTrue:[
            defaultAnswer := singleSelectedFile asFilename withoutSuffix baseName.

            mime := MIMETypes mimeTypeForFilename:defaultAnswer.
            (mime notNil and:[mime isArchiveType]) ifTrue:[
                defaultAnswer := defaultAnswer asFilename withoutSuffix baseName
            ].
        ].
    ].


    defaultAnswer notNil ifTrue:[
        createOp := FileOperation createDirectoryIn:directory initialAnswer:defaultAnswer.
    ] ifFalse:[
        createOp := FileOperation createDirectoryIn:directory.
    ].
    createOp result ifFalse:[ ^ self].
    newFile := createOp createdFile.
    newFile notNil ifTrue:[
        self updateCurrentDirectory.
    ]
!

newFile
    "ask for and create a new file"

    | curFile directory create file|

    directory := self currentDirectory.
    directory isNil ifTrue:[
        self warn:'Select a single directory to create a file.'.
        ^ self.
    ].

    curFile := self firstSelectedFile.
    curFile notNil ifTrue:[
        file := curFile.
    ] ifFalse:[
        file := directory.
    ].
    create := FileOperation createFileIn:file.
    create result ifFalse:[ ^ self].
    self updateAndSelect:(OrderedCollection with:(create createdFile)).
!

newHardLink
    "ask for and create a hard link (unix only)"

    self newLink:#hard.
!

newLink:typeOfLink
    "ask for and create a symbolic if symbolic is true otherwise a hard link (unix only)"

    | sel dir create createdFile|

    sel := self currentSelectedObjects.
    (sel size ~= 1) ifTrue:[
        self warn:'Select one directory to link'.
        ^ self
    ].
    dir := sel first.

    create := FileOperation createLinkIn:dir soft:(typeOfLink == #soft).
    create result ifFalse:[ ^ self].
    createdFile := create createdFile.
    createdFile notNil ifTrue:[
        typeOfLink == #soft ifTrue:[
            self updateCurrentDirectory.
        ] ifFalse:[
            self updateAndSelect:(OrderedCollection with:createdFile).
        ]
    ].

    "Modified: / 04-12-2006 / 13:15:15 / cg"
!

newSoftLink
    "ask for and create a soft link (unix only)"

    self newLink:#soft.
!

pasteFiles
    "paste from clipBoard"

    |buffer destination files directories copiedFiles thisIsAFileMoveOperation|

    files := self clipboard files.
    files isEmptyOrNil ifTrue:[ ^ self ].

    thisIsAFileMoveOperation := self clipboard method == #cut.

    buffer := self clipboard copy.
    directories := self currentSelectedDirectories.
    directories size ~~ 1 ifTrue:[
        |box dirStringCol|

        dirStringCol := directories collect:[:aDir| aDir asString].
        box := ListSelectionBox new.
        box title:'Paste into which directory ?'.
        box list:dirStringCol.
        box okAction:[:sel | destination := sel asFilename].
        box show.
        box destroy.
    ] ifFalse:[
        destination := directories anElement.
    ].

    thisIsAFileMoveOperation ifTrue:[
        buffer files copy do:[:aFile|
            aFile directory = destination ifTrue:[
                buffer files remove:aFile.
            ].
        ].
    ].
    copiedFiles := self copyFiles:(buffer files) to:destination.
    copiedFiles notEmptyOrNil ifTrue:[    
        thisIsAFileMoveOperation ifTrue:[
            self deleteFiles:(copiedFiles keys) confirm:false.
        ]. 

        "/ select those pasted files.
        self updateCurrentDirectory:true.
        self currentFileNameHolder value:copiedFiles values.
    ]
!

renameFile:aFile 
    "rename the selected file(s)"

    ^ self renameFiles:(Array with:aFile).
!

renameFile:filename to:newFileString update:aBoolean
    "rename filename to newFileString"

    |rename|

    rename := FileOperation renameFile:filename to:newFileString.
    rename result ifTrue:[
        aBoolean ifTrue:[
            self updateAndSelect:(rename renamedFiles).
        ].
    ] ifFalse:[
        self notify:rename errorString.
    ].
    ^ rename result
!

renameFiles:aColOfFiles 
    "rename some file(s)"

    |rename|

    rename := FileOperation renameFiles:aColOfFiles.
    rename result ifFalse:[
        self notify:rename errorString.
        ^ nil.
    ].
    ^ rename
!

renameSelection
    "rename the selected file(s)"

    |renamed|

    renamed := self renameFiles:(self currentSelectedObjects copy).
    renamed notNil ifTrue:[
        self updateAndSelect:renamed renamedFiles.
    ].

    "Modified: / 04-12-2006 / 13:15:24 / cg"
! !

!AbstractFileBrowser methodsFor:'menu accessing'!

bookmarksMenu
    <resource: #programMenu>

    ^ self bookmarksMenuForBaseSpec:self class baseBookmarksMenuSpec.
!

bookmarksMenuForBaseSpec:aBaseMenuSpec
    <resource: #programMenu>

    |menu bookmarks|

    menu := aBaseMenuSpec decodeAsLiteralArray.

    "/ add the bookmark items ...
    bookmarks := self class directoryBookmarks.
    bookmarks notEmptyOrNil ifTrue:[
        menu addSeparator.
        bookmarks do:[:dirName |
            menu addItem:(MenuItem 
                            label:dirName asString 
                            itemValue:[
                                (self currentSelectedDirectories includes:dirName) ifFalse:[
                                    self setCurrentFileName:dirName.
                                ].
                            ]).
        ].
    ].
    menu findGuiResourcesIn:self.
    ^ menu

    "Modified: / 14-01-2012 / 21:14:03 / cg"
!

canBackward
    ^ self directoryHistory canBackward.

    "Modified: / 27-03-2007 / 10:54:55 / cg"
!

canForward
    ^ self directoryHistory canForward.

    "Modified: / 27-03-2007 / 10:54:57 / cg"
!

gotoBookmarksMenu
    <resource: #programMenu>

    ^ self bookmarksMenuForBaseSpec:self class baseBookmarksMenuSpec2.
!

menuDirHistory:backOrForward
    "initialize the history menu"

    <resource: #programMenu >

    |hist menu pathList currentSel currentPath|

    hist := self directoryHistory.
    hist isEmpty ifTrue:[^ nil].

    backOrForward == #back ifTrue:[
        currentSel := self currentSelectedDirectories.
        currentSel size == 1 ifTrue:[
            currentPath := currentSel first asString.
        ] ifFalse:[
            currentPath := nil.
        ].
        pathList := hist getBackCollection.
    ] ifFalse:[
        pathList := hist getForwardCollection.
    ].
    pathList isEmpty ifTrue:[ ^ nil].

    pathList size > 30 ifTrue:[
        pathList := pathList copyTo:30
    ].

    menu := Menu new.

    pathList do:[:aPath| 
        menu addItem:(MenuItem
                        label:aPath
                        itemValue:[ self setCurrentFileName:(aPath asFilename) ]
                        translateLabel:false).
    ].
    menu findGuiResourcesIn:self.
    ^ menu

    "Modified: / 09-09-2012 / 13:07:22 / cg"
!

menuDirHistoryBack
    "initialize the directory menu
    "
    <resource: #programMenu >

    ^ self menuDirHistory:#back.
!

menuDirHistoryForward
    "initialize the directory menu
    "
    <resource: #programMenu >

    ^ self menuDirHistory:#forward.
!

menuFileHistory
    "initialize the file history menu
    "
    <resource: #programMenu >

    |menu hist text removeItem|

    hist := self fileHistory.
    hist isEmpty ifTrue:[^ nil].

    menu := Menu new.

    hist copy do:[:aFileItem|
        aFileItem fileName exists ifTrue:[
            menu addItem:(MenuItem 
                            label: aFileItem fileName asString 
                            itemValue:
                                [
                                    self setCurrentFileName:(aFileItem fileName).
                                    self openApplByFileItem:aFileItem
                                ]
                            translateLabel:false).
        ] ifFalse:[
            "/ remove all not existing history entries
            hist remove:aFileItem.
        ]
    ].
    menu addSeparator.

    removeItem := MenuItem new.
    removeItem translateLabel:true.
    text := resources string:'Clear History'.
    "/ text := LabelAndIcon icon:(self class clearHistoryIcon) string:text.
    removeItem label:text.
    removeItem 
        itemValue:[
            self fileHistory removeAll.
            self enableFileHistory value:false.
        ].
    menu addItem:removeItem.
    menu findGuiResourcesIn:self.
    ^ menu

    "Modified (format): / 09-09-2012 / 13:07:36 / cg"
!

sortMenu
    <resource: #programMenu >

    |menu|

    menu :=  Menu decodeFromLiteralArray:self class sortMenu.
    menu findGuiResourcesIn:self.
    ^ menu

    "Modified: / 27-03-2007 / 10:47:42 / cg"
!

viewDetailsMenuSpec
    |specContentsBrowser itemsContentsBrowser specHere itemsHere spec| 

    specHere := self class viewDetailsMenuSpec.
    itemsHere := specHere at:2.

    specContentsBrowser := self directoryContentsBrowser class viewBrowserMenuSpec.
    itemsContentsBrowser := (specContentsBrowser at:2).

    spec := specHere copy.
    spec at:2 put:(itemsContentsBrowser , itemsHere).
    ^ spec
!

viewInContentsBrowserMenu
    self 
        applicationNamed:#DirectoryContentsBrowser 
        ifPresentDo:[:appl | ^ appl viewBrowserMenu].

    ^ nil.
!

visitedDirectoriesMenu
    <resource: #programMenu >

    |menu histCopy text removeItem|

    histCopy := self directoryHistory.
    histCopy isEmpty ifTrue:[^ nil].

    menu := Menu new.

    histCopy do:[:aFile| 
        menu addItem:(MenuItem 
                        label:aFile asString 
                        itemValue:[
                            self setCurrentFileName:(aFile path asFilename).
                        ]).
    ].
    menu addSeparator.

    "/ text := LabelAndIcon icon:(self class clearHistoryIcon) string:(resources string:'Clear History').
    text := (resources string:'Clear History').
    removeItem := MenuItem new.
    removeItem translateLabel:true.
    removeItem label:text.
    removeItem 
        itemValue:[
            self directoryHistory removeAll.
            self enableForward value:self canForward.
            self enableBack value:self canBackward.
        ].

    menu addItem:removeItem.
    menu findGuiResourcesIn:self.
    ^ menu

    "Modified: / 09-09-2012 / 13:07:45 / cg"
! !

!AbstractFileBrowser methodsFor:'menu actions'!

doCompareTwoFiles
    self openDiffView.
!

doGoDirectoryUp
    | upDir directory rootInTreeView|

    self enableDirectoryUp value ifFalse:[ ^ self].
    self currentFilesAreInSameDirectory ifTrue:[
        directory := self currentDirectory.
        directory isNil ifTrue:[ ^ self].
    ] ifFalse:[
        rootInTreeView := self 
                            applicationNamed:#DirectoryTreeBrowser 
                            ifPresentDo:[:appl | appl rootHolder].
        directory := rootInTreeView value asFilename.
    ].
    upDir := directory directory.
    self setCurrentFileName:upDir.
!

doGotoDefaultDirectory
    self gotoFile:(Filename defaultDirectory).
!

doGotoDesktopDirectory
    self gotoFile:(Filename desktopDirectory).
!

doGotoHomeDirectory
    self gotoFile:(Filename homeDirectory).
!

doGotoSmalltalkDirectory
    self gotoFile:(self smalltalkDirectory).
!

doGotoSmalltalkWorkspaceDirectory
    self gotoFile:(UserPreferences current workspaceDirectory).
!

doGotoTempDirectory
    self gotoFile:(self tempDirectory).

    "Created: / 29-12-2010 / 11:03:17 / cg"
!

doMakeCurrentDirectory
    OperatingSystem setCurrentDirectory:(self currentDirectory pathName).
    self currentFileNameHolderChangedForCommon.

    "Created: / 26-10-2010 / 17:21:19 / cg"
!

fileGetInfo:longInfo 
    "get info on selected file - show it in a box"

    |string box updater|

    string := self getFileInfoStringForFirstSelectedFile:longInfo.
    string notNil ifTrue:[
        box := InfoBox title:string.
        updater := [
                    [true] whileTrue:[
                        Delay waitForSeconds:2.
                        string := self getFileInfoStringForFirstSelectedFile:longInfo.
                        string isNil ifTrue:[ ^ self].
                        box title:string
                    ]
                ] fork.
        box show.
        updater terminate.
        box destroy
    ]
!

smalltalkDirectory
    |stxPath|

    stxPath := OperatingSystem pathOfSTXExecutable.
    stxPath isNil ifTrue:[
        ^ Filename currentDirectory
    ].
    ^ stxPath asFilename directory.
!

tempDirectory
    ^ Filename tempDirectory.

    "Created: / 29-12-2010 / 11:03:00 / cg"
! !

!AbstractFileBrowser methodsFor:'menu actions-file'!

addDirToJavaSourcePath
    "add the current path to java's sourcePath
     (only available with ST/J System"

    Java addToSourcePath:self currentDirectory pathName

    "Modified: 14.12.1996 / 15:37:47 / cg"
    "Created: 2.8.1997 / 14:11:19 / cg"
!

copyFiles
    self 
        withSelectedFilesOrDirectoriesDo:[:filesOrDirs | self copyFilesToClipBoard:filesOrDirs]
!

cutFiles
    self 
        withSelectedFilesOrDirectoriesDo:[:filesOrDirs | self cutFilesToClipBoard:filesOrDirs]
!

deleteFiles
    self 
        withSelectedFilesOrDirectoriesDo:[:filesOrDirs | self deleteFiles:filesOrDirs]
!

eraseFiles
    self 
        withSelectedFilesOrDirectoriesDo:[:filesOrDirs | self eraseFiles:filesOrDirs]
!

fileAddToJavaSourcePath
    "add the current path to java's sourcePath
     (only available with ST/J System"

    self currentSelectedObjects do:[:each |
        Java addToSourcePath:(each pathName)
    ].

    "Created: / 9.11.1998 / 05:41:34 / cg"
    "Modified: / 9.11.1998 / 05:56:00 / cg"
!

openSettingsDialog
    |dialog|

    dialog := FileBrowserV2SettingsDialog new.
    dialog settingsDialog:self.
    dialog allButOpen.
    dialog doReload.
    dialog openWindow
!

withSelectedFilesOrDirectoriesDo:aBlock
    |files dirs|

    files := self currentSelectedFiles.
    files notEmpty ifTrue:[
        aBlock value:files.        
    ] ifFalse:[
        dirs := self currentSelectedDirectories.
        dirs notEmpty ifTrue:[
            aBlock value:dirs.        
        ].
    ].
! !

!AbstractFileBrowser methodsFor:'menu actions-help'!

openAboutThisApplication
    "opens an about box for this application."

    Dialog aboutClass:self class.
!

openHTMLDocument:relativeDocPath
    HTMLDocumentView openFullOnDocumentationFile:relativeDocPath
! !

!AbstractFileBrowser methodsFor:'menu actions-scm-cvs'!

canCvsAddAndCommit

    |selectedFiles|

    selectedFiles := self currentSelectedObjects.
    ^ (selectedFiles notEmpty and:[self currentFilesAreInSameDirectory]).
!

canRemoveCVSContainer
    ^ self currentSelectedFiles 
        contains:[:fileName|
            |dirOfFile cvsDir|

            dirOfFile := self getDirWithoutFileName:fileName.
            cvsDir := dirOfFile construct:'CVS'.
            cvsDir isDirectory
        ].
!

commitFilesToCVS:files
    |numFiles|

    (numFiles := files size) > 0 ifTrue:[
        self withActivityIndicationDo:[
            self cvsCommitFiles:files
        ]
    ]
!

cvsAddAndCommit
    self cvsAddAndCommitAsBinary:false
!

cvsAddAndCommitAsBinary:asBinary
    |sel log logArg binArg cmd dir executionBlock nameString|

    log := Dialog
        requestText:(resources string:'Enter initial log message:')
        lines:10
        columns:70
        initialAnswer:nil.
    log isNil ifTrue:[^ self].

    OperatingSystem isMSWINDOWSlike ifTrue:[
        logArg := '-m "' , log , '"'.
    ] ifFalse:[
        logArg := '-m ''' , log , ''''.
    ].

    binArg := ''.
    asBinary ifTrue:[
        binArg := '-kb '.
    ].
    sel := self currentSelectedFiles.
    executionBlock := 
        [:stream |
            log notNil ifTrue:[
                sel size > 0 ifTrue:[
                    sel do:[:fn |
                        |nameArg|

                        nameArg := '"',fn baseName,'"'.

                        dir := self getDirWithoutFileName:fn.
                        cmd := 'cvs add ',logArg,' ',binArg,nameArg.
                        (self getExecutionBlockForCommand:cmd inDirectory:dir) value:stream.

                        cmd := ('cvs commit -l ',logArg,' ',nameArg).
                        (self getExecutionBlockForCommand:cmd inDirectory:dir) value:stream.
                        "/ mhmh - it seems that only old CVS implementations (at least turqoise)
                        "/ support and need the 'admin -kb' command.
                        "/ newer ones use the '-kb' option in the 'cvs add' command
                        asBinary ifTrue:[
                            cmd := ('cvs admin -kb ' , nameArg).
                            (self getExecutionBlockForCommand:cmd inDirectory:dir) value:stream.

                            cmd := ('cvs upd ' , nameArg).
                            (self getExecutionBlockForCommand:cmd inDirectory:dir) value:stream.
                        ].
                    ]
                ] 
            ]
        ].
    nameString := 'Command> cvs add and commit'.
    self makeExecutionResultProcessFor:executionBlock withName:nameString.

    "Modified (format): / 15-01-2012 / 16:02:07 / cg"
!

cvsAddBinaryAndCommit
    self cvsAddAndCommitAsBinary:true
!

cvsCommit
    |selectedFiles|

    selectedFiles:= self currentSelectedFiles.
    self cvsCommitFiles:selectedFiles
!

cvsCommitFiles:files
    |nFiles log logTmp s logArg msg executionBlock nameString |

    nFiles := files size.
    nFiles == 0 ifTrue:[^ self].

    nFiles == 1 ifTrue:[
        msg := resources string:'Enter log message for checkIn of "%1"' with:(files first baseName)
    ] ifFalse:[
        nFiles > 1 ifTrue:[
            msg := resources string:'Enter log message for %1 files to checkIn' with:nFiles printString
        ] ifFalse:[
            msg := resources string:'Enter log message for checkIn'
        ]
    ].

    log := Dialog
        requestText:msg
        lines:10
        columns:70
        initialAnswer:nil.

    log isNil ifTrue:[^ self].
    log := log replChar:$"  withString:'\"'.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        "/ save the log message into another tempFile ...
        s := FileStream newTemporary.
        logTmp := s fileName.
        s nextPutAll:log.
        s close.

        logArg := '-F "', logTmp pathName, '"'.
    ] ifFalse:[
        logArg := '-m ''' , log , ''''.
    ].

    executionBlock := [:stream |
        [
            files do:[:fn |
                | dir nameArg cmd |

                nameArg := '"',fn baseName,'"'.
                dir := fn directory.
                cmd := 'cvs commit ',logArg,' ' , nameArg.
stream showCR:fn pathName.
                (self getExecutionBlockForCommand:cmd inDirectory:dir) value:stream.
            ] 
        ] ensure:[
            logTmp notNil ifTrue:[ logTmp remove ].
        ].
    ].
    nameString := 'Command> cvs commit'.
    self makeExecutionResultProcessFor:executionBlock withName:nameString.
!

cvsCommitFolder
    |dir log logTmp s logArg msg executionBlock nameString |

    (dir := self currentDirectory) isNil ifTrue:[ ^ self ].

    msg := resources string:'Enter log message for checkIn of "%1"' with:(dir baseName).
    log := Dialog
        requestText:msg
        lines:10
        columns:70
        initialAnswer:nil.

    log isNil ifTrue:[^ self].
    log := log replChar:$"  withString:'\"'.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        "/ save the log message into another tempFile ...
        s := FileStream newTemporary.
        logTmp := s fileName.
        s nextPutAll:log.
        s close.

        logArg := '-F "', logTmp pathName, '"'.
    ] ifFalse:[
        logArg := '-m ''' , log , ''''.
    ].

    executionBlock := [:stream |
            [
                |cmd|

                cmd := 'cvs commit ',logArg.
                (self getExecutionBlockForCommand:cmd inDirectory:dir) value:stream.
            ] ensure:[
                logTmp notNil ifTrue:[ logTmp remove ].
            ].
        ]. 
    
    nameString := 'Command> cvs commit'.
    self makeExecutionResultProcessFor:executionBlock withName:nameString.
!

cvsCompareWithNewest
    |selectedFiles|

    selectedFiles:= self currentSelectedFiles.
    selectedFiles do:[:each |
        |out diffs|

        out := CharacterWriteStream new:100.
        OperatingSystem 
            executeCommand:'cvs diff -b ',each baseName
            outputTo:out
            inDirectory:each directoryName.
        diffs := out contents.
        TextView openWith:diffs.
    ].

    "Modified: / 23-01-2012 / 14:08:28 / cg"
!

cvsRemoveAndRemoveFromCVS:filesToRemove
    "remove the selected file(s) and their CVS containers - no questions asked"

    |toRemove updateRunning executionBlock nameString|

    updateRunning := self backgroundProcesses value notEmpty.
    self killAllRunningBackgroundProcesses.
    toRemove := OrderedCollection new.

    executionBlock := 
        [:stream |
            |cmd logArg prevDir prevFiles|

            OperatingSystem isMSWINDOWSlike ifTrue:[
                logArg := '-m "' , 'removed via FileBrowser' , '"'.
            ] ifFalse:[
                logArg := '-m ''' , 'removed via FileBrowser' , ''''.
            ].
            prevFiles := ''.

            filesToRemove do:[:fileName |
                |dir file|

                dir := fileName directory.
                (prevDir notNil and:[prevDir ~= dir]) ifTrue:[
                    cmd := 'cvs commit -l ',logArg, ' ',prevFiles.
                    "/ Transcript show:prevDir; space; showCR:cmd.
                    (self getExecutionBlockForCommand:cmd inDirectory:prevDir) value:stream.
                    prevFiles := ''.
                ].

                OsError handle:[:ex|
                    "was not able to remove it"
                    | lastError msg |
                    lastError := OperatingSystem lastErrorString.
                    msg := (resources string:'cannot remove ''%1'' !!' with:fileName).
                    lastError isNil ifFalse:[
                        msg := msg , '\\(' , lastError , ')'
                    ].
                    Dialog warn:msg withCRs
                ] do:[
                    (fileName isSymbolicLink) ifFalse:[
                        fileName remove.
                        file := fileName baseName.
                        cmd := ('cvs remove -f "',file,'"').
                        (self getExecutionBlockForCommand:cmd inDirectory:dir) value:stream.
                        "/ Transcript show:dir; space; showCR:cmd.
                    ]
                ].
                prevDir := dir.
                prevFiles := prevFiles,' ',file.
            ].
            cmd := 'cvs commit -l ',logArg, ' ',prevFiles.
            "/ Transcript show:prevDir; space; showCR:cmd.
            (self getExecutionBlockForCommand:cmd inDirectory:prevDir) value:stream.
        ].
    nameString := 'Command> cvs remove and commit ', filesToRemove first baseName.
    filesToRemove size > 1 ifTrue:[
        nameString := nameString, ' ...'.
    ].
    self makeExecutionResultProcessFor:executionBlock withName:nameString.
!

cvsRemoveFileAndCVSContainer
    |files|

    files := self currentSelectedFiles copy.
    self removeFilesAndCVSContainers:files
!

cvsRevisionLog
    | cmd sel executionBlock nameString|

    sel := self currentSelectedObjects.
    sel isEmpty ifTrue:[ ^ self ].

    executionBlock := [:stream |
        sel do:[:fn |
            | dir nameArg |

            nameArg := '"',fn baseName,'"'.
            dir := fn directory.
            cmd := 'cvs log ' , nameArg.
            (self getExecutionBlockForCommand:cmd inDirectory:dir) value:stream.
        ]
    ].
    nameString := 'Command> cvs log'.
    self makeExecutionResultProcessFor:executionBlock withName:nameString.
!

cvsTagSelection
    |tag tags cmd|

    tag := Dialog
                request:(resources string:'Tag (possibly multiple, separated by ";"):')
                initialAnswer:(CVSSourceCodeManager recentTag).
    tag isEmptyOrNil ifTrue:[^ self ].

    CVSSourceCodeManager recentTag:tag.

    CVSSourceCodeManager notNil ifTrue:[
        cmd := CVSSourceCodeManager cvsExecutable.
    ] ifFalse:[
        cmd := 'cvs'.
    ].

    tags := tag asCollectionOfSubstringsSeparatedByAny:',;'.
    tags do:[:eachTag |
        self executeCommand:('%1 tag -F "%2" %3' 
                                bindWith:cmd 
                                with:(eachTag withoutSeparators) 
                                with:(self makeFileNameArgumentString))
    ].
!

cvsUpdateAll
    | cmd |

    CVSSourceCodeManager notNil ifTrue:[
        cmd := CVSSourceCodeManager cvsExecutable.
    ] ifFalse:[
        cmd := 'cvs'.
    ].

    self executeCommand:(cmd, ' upd -l').
!

cvsUpdateAllRecursive
    | cmd |

    CVSSourceCodeManager notNil ifTrue:[
        cmd := CVSSourceCodeManager cvsExecutable.
    ] ifFalse:[
        cmd := 'cvs'.
    ].
    self executeCommand:(cmd, ' upd -d').
!

cvsUpdateSelection
    |stream cmd|

    CVSSourceCodeManager notNil ifTrue:[
        cmd := CVSSourceCodeManager cvsExecutable.
    ] ifFalse:[
        cmd := 'cvs'.
    ].

    stream := CharacterWriteStream new.
    stream 
        nextPutAll:cmd; 
        nextPutAll:' upd ';
        nextPutAll:(self makeFileNameArgumentString).

    self executeCommand:stream contents.
!

makeFileNameArgumentString
    |stream|

    stream := CharacterWriteStream new.
    self currentSelectedFiles do:[: file |
        stream nextPut:$".
        stream nextPutAll:file baseName.
        stream nextPutAll:'" '.
    ].
    ^ stream contents.
!

removeFilesAndCVSContainers:files
    |numFiles question aswer|

    (numFiles := files size) > 0 ifTrue:[
        numFiles > 1 ifTrue:[
            question := resources string:'Remove %1 selected files and their CVS containers ?' with:numFiles
        ] ifFalse:[
            question := resources string:'Remove ''%1'' and its CVS container ?' with:(files first baseName allBold)
        ].

        aswer := Dialog 
                confirm:question withCRs
                yesLabel:(resources string:'Remove')
                noLabel:(resources string:'Cancel').

        aswer ifTrue:[
            self withActivityIndicationDo:[
                self cvsRemoveAndRemoveFromCVS:files
            ]
        ]
    ]
! !


!AbstractFileBrowser methodsFor:'menu actions-scm-mercurial'!

mercurialAdd
    |executionBlock sel maxCmdSize|

    maxCmdSize := 512.

    sel := self currentSelectedObjects.
    sel isEmptyOrNil ifTrue:[
        ^ self
    ].

    executionBlock := 
        [:stream |
            |prevDir cmd|

            prevDir := nil.
            sel do:[:fn |
                |nameArg dir|

                nameArg := '"',fn baseName,'"'.
                dir := fn directory.
                (dir ~= prevDir or:[ (cmd size + nameArg size) > maxCmdSize]) ifTrue:[
                    "/ flush
                    cmd notNil ifTrue:[
                        (self getExecutionBlockForCommand:cmd inDirectory:prevDir) value:stream.
                        cmd := nil.
                    ]
                ].
                cmd isNil ifTrue:[
                    cmd := 'hg add'.
                ].
                cmd := cmd,' ',nameArg.
                prevDir := dir.
            ].
            cmd notNil ifTrue:[
                (self getExecutionBlockForCommand:cmd inDirectory:prevDir) value:stream.
                cmd := nil.
            ].
            stream nextPutLine:'Commit to finish the transaction'. 
        ].

    self makeExecutionResultProcessFor:executionBlock withName:'Command> hg add'.

    "Created: / 15-01-2012 / 15:55:47 / cg"
!

mercurialCommit
    |dir executionBlock|

"/    dir := self currentDirectory.
    dir := self directoryContentsBrowser directory.
    executionBlock := 
        [:stream |
            (self getExecutionBlockForCommand:'hg commit' 
                  inDirectory:dir) value:stream.
            stream nextPutLine:'Push to sync other repositories'. 
        ].

    self makeExecutionResultProcessFor:executionBlock withName:'Command> hg commit'.

    "Created: / 15-01-2012 / 16:21:27 / cg"
!

mercurialInit
    |dir executionBlock|

    dir := self directoryContentsBrowser directory.

    (Dialog confirm:(resources 
                        string:'Initialize new Mercurial Repository in %1?'
                        with:dir baseName)) ifFalse:[^ self].

    executionBlock := 
        [:stream |
            (self getExecutionBlockForCommand:('hg init')
                  inDirectory:dir) value:stream.
        ].

    self makeExecutionResultProcessFor:executionBlock withName:'Command> hg init'.

    "Created: / 17-01-2012 / 15:58:46 / cg"
!

mercurialPush
    |destination dir executionBlock|

    destination := Dialog request:'Mercurial Repository'
                    initialAnswer:(LastMercurialRepository ? MercurialSourceCodeManager repositoryName).
    destination isEmptyOrNil ifTrue:[^ self].

    LastMercurialRepository := destination.

    dir := self directoryContentsBrowser directory.
    executionBlock := 
        [:stream |
            (self getExecutionBlockForCommand:('hg push "%1"' bindWith:destination)
                  inDirectory:dir) value:stream.
        ].

    self makeExecutionResultProcessFor:executionBlock withName:'Command> hg push'.

    "Created: / 15-01-2012 / 16:29:41 / cg"
!

mercurialStatus
    |executionBlock sel maxCmdSize|

    maxCmdSize := 512.

    sel := self currentSelectedObjects.
    sel isEmptyOrNil ifTrue:[
        ^ self
    ].

    executionBlock := 
        [:stream |
            |prevDir cmd|

            prevDir := nil.
            sel do:[:fn |
                |nameArg dir|

                nameArg := '"',fn baseName,'"'.
                dir := fn directory.
                (dir ~= prevDir or:[ (cmd size + nameArg size) > maxCmdSize]) ifTrue:[
                    "/ flush
                    cmd notNil ifTrue:[
                        (self getExecutionBlockForCommand:cmd inDirectory:prevDir) value:stream.
                        cmd := nil.
                    ]
                ].
                cmd isNil ifTrue:[
                    cmd := 'hg status'.
                ].
                cmd := cmd,' ',nameArg.
                prevDir := dir.
            ].
            cmd notNil ifTrue:[
                (self getExecutionBlockForCommand:cmd inDirectory:prevDir) value:stream.
                cmd := nil.
            ].
        ].

    self makeExecutionResultProcessFor:executionBlock withName:'Command> hg status'.

    "Created: / 15-01-2012 / 19:43:08 / cg"
! !

!AbstractFileBrowser methodsFor:'menu actions-tools'!

allFilesInSelectedDirectoriesForWhich:aBlock
    |directories allFiles|

    directories := self currentSelectedDirectories.
    directories isEmpty ifTrue:[^ self].

    allFiles := OrderedCollection new.
    directories do:[:dir|
        [
            |fileNames|

            fileNames := dir directoryContents.
            fileNames notNil ifTrue:[
                fileNames := fileNames 
                                collect:[:fn | dir construct:fn]
                                thenSelect:[:fn | fn isDirectory not and:[aBlock value:fn]].
                allFiles addAll:fileNames.
            ]
        ] on:FileStream openErrorSignal do:[:ex|
            self warn:(resources stringWithCRs:'Cannot access: %1\(%2)' 
                            with:ex pathName
                            with:ex description).
            ex proceedWith:nil.
        ].
    ].

    ^ allFiles
!

conversionChainFrom:inSuffix to:outSuffix
    |conv|

    inSuffix = outSuffix ifTrue:[
        ^ nil
    ].

    "/ q&d hack to get my images converted for old html-browsers...
    "/ this should come from somewhere else (do we need an ImageConverter class ?).

    conv := OrderedCollection new.
    conv add:('anytopnm %1 > %2' -> 'pnm').

    outSuffix = 'png' ifTrue:[
        conv add:('pnmtopng %1 > %2' -> 'png').
        ^ conv.
    ].
    outSuffix = 'gif' ifTrue:[
        conv add:('ppmquant 256 %1 | ppmtogif > %2' -> 'gif').
        ^ conv.
    ].
    outSuffix = 'xpm' ifTrue:[
        conv add:('ppmtoxpm %1 > %2' -> 'xpm').
        ^ conv.
    ].
    outSuffix = 'jpg' ifTrue:[
        conv add:('ppmtojpeg %1 > %2' -> 'jpg').
        ^ conv.
    ].
    self error:'unimplemented conversion'.
!

convertImageFrom:fileName to:outFile onError:exceptionBlock
    |writer image outSuffix|

    outSuffix := outFile suffix.

    ((writer := MIMETypes imageReaderForSuffix:outSuffix) notNil
    and:[ (image := Image fromFile:fileName) notNil
    and:[ writer canRepresent:image ]]) ifTrue:[
        "/ can do it with Smalltalk tools
        writer save:image onFile:outFile.
    ] ifFalse:[
        "/ use external tools (pbm-package, if available)
        self 
            convertImageUsingExternalFileToolsFrom:fileName 
            toSuffix:outSuffix 
            onError:exceptionBlock.
    ].

    "Created: / 20-05-2010 / 11:12:36 / cg"
!

convertImageToGIF
    self convertImageToSuffix:'gif'
!

convertImageToJPG
    self convertImageToSuffix:'jpg'
!

convertImageToPNG
    self convertImageToSuffix:'png'
!

convertImageToSuffix:outSuffix
    |outFile filesToConvert|

    self withActivityIndicationDo:[
        filesToConvert := self currentSelectedObjects copy.
        filesToConvert do:[:fileName |
            self notify:(resources string:'Converting: %1...' with:fileName baseName).

            fileName isDirectory ifFalse:[
                |skip|

                skip := false.
                outFile := fileName withSuffix:outSuffix.
                outFile exists ifTrue:[
                    |answer|

                    answer := Dialog 
                        confirmWithCancel:(resources string:'Overwrite existing %1 ?' with:outFile baseName allBold)
                        default:false.
                    answer isNil ifTrue:[AbortSignal raise].
                    answer ifFalse:[ skip := true ].
                ].
                skip ifFalse:[
                    self 
                        convertImageFrom:fileName 
                        to:outFile 
                        onError:[:errMsg |
                            filesToConvert size == 1 ifTrue:[
                                Dialog warn:errMsg
                            ] ifFalse:[
                                (Dialog confirm:errMsg yesLabel:(resources string:'OK') noLabel:(resources string:'Cancel')) ifFalse:[
                                    ^ self
                                ]
                            ].
                        ].

                    self updateAndSelect:nil.
                ]
            ]
        ].
        self notify:nil.
    ]

    "Modified: / 20-05-2010 / 11:15:35 / cg"
!

convertImageToXPM
    self convertImageToSuffix:'xpm'
!

convertImageUsingExternalFileToolsFrom:fileName toSuffix:outSuffix onError:exceptionBlock
    |inFile outFile chainOfConversions conversionStream 
     eachConversionSuffixCommandPair eachConversionCommand eachConversionSuffix|

    chainOfConversions := self conversionChainFrom:(fileName suffix) to:outSuffix.

    chainOfConversions isNil ifTrue:[ 
        self warn:('Don''t know how to convert from %1 to %2' bindWith:fileName suffix with:outSuffix).
        ^ false 
    ].
    conversionStream := chainOfConversions readStream.

    inFile := fileName.
    eachConversionSuffixCommandPair := conversionStream next.
    eachConversionCommand := eachConversionSuffixCommandPair key.

    eachConversionCommand == #readToXPM ifTrue:[
        |image tempStreamXPM|

        image := Image fromFile:(inFile pathName).
        image isNil ifTrue:[
            self warn:'Unknown format/not an image: ' , inFile baseName.
            ^ false.
        ].
        tempStreamXPM  := FileStream newTemporaryWithSuffix:'xpm'.
        XPMReader save:image onStream:tempStreamXPM.
        tempStreamXPM close.
        inFile := tempStreamXPM fileName.
        eachConversionSuffixCommandPair := conversionStream next.
    ].

    [
        |command errOutput errMsg|

        [eachConversionSuffixCommandPair notNil] whileTrue:[
            eachConversionCommand := eachConversionSuffixCommandPair key.
            eachConversionSuffix  := eachConversionSuffixCommandPair value.

            self notify:(resources string:'Converting: %1 to %2...' with:fileName baseName with:eachConversionSuffix).

            outFile := (FileStream newTemporaryWithSuffix:eachConversionSuffix) close pathName.
            command := eachConversionCommand 
                            bindWith:(inFile pathName)
                            with:(outFile pathName).

            errOutput := String writeStream.

            (OperatingSystem executeCommand:command errorTo:errOutput) ifFalse:[
                errMsg := resources
                            stringWithCRs:'Conversion of %1 to %2 using %3 failed:\\%4.' 
                            with:inFile baseName allBold
                            with:eachConversionSuffix
                            with:eachConversionCommand allBold
                            with:errOutput contents.
                exceptionBlock value:errMsg.

                (inFile ~= fileName) ifTrue:[inFile delete].
                outFile delete.
                ^ false
            ].
            (inFile ~= fileName) ifTrue:[inFile delete].
            inFile := outFile.
            eachConversionSuffixCommandPair := conversionStream next
        ].
        outFile moveTo:(fileName withSuffix:(chainOfConversions last value)).
    ] ifCurtailed:[
        (inFile ~= fileName) ifTrue:[inFile delete].
        outFile delete.
    ].
    ^ true.

    "Created: / 20-05-2010 / 11:05:50 / cg"
!

createProjectAndOpenProjectBrowser
    |nm f s directory|

    self currentFilesAreInSameDirectory ifFalse:[^ self].
    directory := self currentDirectory.
    nm := directory baseName.
    f := (directory  construct:nm) withSuffix:'prj'.
    f exists ifTrue:[
        Dialog warn:'A file named ' , f baseName , ' already exists.'.
        ^ self.
    ].
    s := f writeStream.
    s nextPutAll:'
name            ''' , nm , '''
type            #classLibrary
package         #''private:' , nm , '''
prerequisites   nil

classes      #( )
'.
    s close.
    ProjectBrowser openOnFile:f.
!

doExecuteCommand
    "execute an OperatingSystem-command"

    | action fileName|

    fileName := self firstSelectedFile.
    action := [:command | 
                self addToCommandHistory:command for:fileName.
                self executeCommand:command.
              ].
    self askForCommandFor:fileName thenDo:action
!

doExecuteScript
    "execute a Smalltalk script"

    |textHolder dialog template dummyClass dummyInstance|

    template :=
'"/ Smalltalk script:

"/ the following variables are accessible:
"/      directory       (= ' , (self theSingleSelectedDirectoryOrNil ? Filename homeDirectory) pathName , ')
"/      selectedFiles   (= ...)
"/
"/ Beginner warning: Smalltalk know-how is useful here ;-).
"/
"/ Useful operations are:
"/      directory directoryContentsDo:[:eachBaseNameString | ...]
"/      directory directoryContentsAsFilenamesDo:[:eachFilename | ...]
"/      directory directory
"/
"/ example: move all files which match a aarticular pattern to
"/          a separate directory:
"/ 
"/        |directory idx prefix rest newDir oldFile newFile|
"/
"/        directory := ''/mnt/var/priv/image/tv/frank/frank2/2131_008.jpg'' asFilename.
"/
"/        directory directoryContentsDo:[:eachBaseNameString |
"/            (eachBaseNameString includes:$_) ifTrue:[
"/                idx := eachBaseNameString indexOf:$_.
"/                prefix := eachBaseNameString copyTo:(idx - 1).
"/                rest := eachBaseNameString copyFrom:(idx + 1).
"/                newDir := directory construct:prefix.
"/                newDir exists ifFalse:[
"/                    (Dialog confirm:''Create '' , newDir pathName) ifTrue:[
"/                        newDir makeDirectory.
"/                    ].
"/                ].
"/                newDir exists ifTrue:[
"/                    oldFile := directory construct:eachBaseNameString.
"/                    newFile := newDir construct:rest.
"/                    oldFile moveTo:newFile
"/                ]
"/            ]
"/        ]
'.

    LastScriptBlockString isNil ifTrue:[
        LastScriptBlockString := template.
    ].

    textHolder := ValueHolder new.
    dialog := Dialog 
                 forRequestText:(resources string:'Enter script')
                 editViewClass:CodeView
                 lines:25 
                 columns:70
                 initialAnswer:LastScriptBlockString
                 model:textHolder.
    dialog addButton:(Button label:'Template' action:[textHolder value:template. textHolder changed:#value.]).
    dialog open.
    dialog accepted ifFalse:[^ self].

    LastScriptBlockString := textHolder value.

    Class classConventionViolationConfirmationQuerySignal 
        answer:true
        do:[
            dummyClass := Object class
                    name:#Dummy
                    inEnvironment:nil
                    subclassOf:Object
                    instanceVariableNames:'directory selectedFiles'
                    variable:false
                    words:true
                    pointers:true
                    classVariableNames:''
                    poolDictionaries:''
                    category:#dummyCategory
                    comment:nil
                    changed:true.
        ].

    dummyInstance := dummyClass basicNew.
    dummyInstance instVarAt:1 put:(self theSingleSelectedDirectoryOrNil ? Filename homeDirectory).
    dummyInstance instVarAt:2 put:(self currentSelectedFiles value).

    Compiler
        evaluate:textHolder value
        in:nil 
        receiver:dummyInstance 
        notifying:nil 
        logged:false
        ifFail:[]
        compile:true.

"/    fileName := self firstSelectedFile.
"/    action := [:command | 
"/                self addToCommandHistory:command for:fileName.
"/                self executeCommand:command.
"/              ].
"/    self askForCommandFor:fileName thenDo:action
!

doMake
    |dir cmd|

    cmd := self makeCommandHolder value.

    "Make"
    cmd = 'make' ifTrue:[
        dir := self theSingleSelectedDirectoryOrNil.
        OperatingSystem isMSWINDOWSlike ifTrue:[
            dir notNil ifTrue:[
                (dir construct:'bmake.bat') exists ifTrue:[
                    cmd := 'bmake.bat'.
                ]
            ]
        ].
        self executeCommand:cmd.
        ^self.
    ].

    "Apache ant"
    cmd = 'ant' ifTrue:[
        self executeCommand:cmd.
        ^self.
    ].

    "Add more here..."

    "Modified (comment): / 13-04-2012 / 17:07:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenCBrowser
    "the CBrowser is an eXept-internal C-language IDE tool.
     (no longer of much interest, since we have VC and eclipse, but this was written
     20 years ago ;-)"

    |destDir|

    (CBrowser isNil or:[ CBrowser::Browser isNil ]) ifTrue:[
        Smalltalk loadPackage:'exept:CC'
    ].
    destDir := self currentDirectory.
    CBrowser::Browser openIn:destDir pathName

    "Modified: / 04-10-2011 / 13:41:31 / cg"
    "Modified (comment): / 27-07-2012 / 20:41:40 / cg"
!

doOpenExplorer
    self currentDirectory asFilename openExplorer

    "Modified: / 21-07-2012 / 12:28:36 / cg"
!

doOpenFinder
    self currentDirectory asFilename openFinder

    "Modified: / 21-07-2012 / 12:28:36 / cg"
!

doOpenMonticelloBrowser
    MCMczReader isNil ifTrue:[ Smalltalk loadPackage:'stx:goodies/monticello'].

    self withWaitCursorDo:[
        self currentSelectedFiles do:[:fn |
            |version snapshot|

            fn suffix asLowercase = 'mcz' ifTrue:[
                version := MCMczReader versionFromFile:fn.
                snapshot := version snapshot.
                (Tools::ChangeSetBrowser2 
                        on: snapshot asChangeSet
                        label: version info name)
                    beTwoColumn;
                    targetNamespace:nil;
                    targetPackage:nil;
                    open
                ]
        ]
    ]
!

doOpenSettings
    self openSettingsDialog
!

doOpenWithShellCommand
    "open using win32-shell"

    |fileName|

    fileName := self firstSelectedFile.
    fileName notNil ifTrue:[    
        OperatingSystem
            openApplicationForDocument:fileName pathName 
            operation:#open
    ]

    "Modified: / 21-07-2012 / 12:26:10 / cg"
!

editMode:aSymbol
    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl |
            |subApp|

            subApp := appl selectedApplication.
            subApp notNil ifTrue:[
                ^ subApp perform:aSymbol
            ]
        ].

    "Created: / 11-09-2006 / 12:42:08 / cg"
!

editModeInsert
    self editMode:#editModeInsert

    "Created: / 11-09-2006 / 12:40:36 / cg"
!

editModeInsertAndSelect
    self editMode:#editModeInsertAndSelect

    "Created: / 11-09-2006 / 12:40:45 / cg"
!

editModeOverwrite
    self editMode:#editModeOverwrite

    "Modified: / 11-09-2006 / 12:42:26 / cg"
!

fetchFileByURL
    |url destinationFilename|

    url := Dialog request:'URL to Fetch:' initialAnswer:'http://host/path'.
    url isEmptyOrNil ifTrue:[^ self].
    url := url asURL.

    destinationFilename := Dialog request:'Download As:' initialAnswer:(UnixFilename named:url path) baseName.
    destinationFilename isEmptyOrNil ifTrue:[^ self].

    destinationFilename := self currentDirectory asFilename / destinationFilename.
    destinationFilename exists ifTrue:[
        |answer|

        answer := Dialog 
            confirm:(resources string:'Overwrite existing %1 ?' with:destinationFilename baseName allBold)
            default:false.
        answer ~~ true ifTrue:[^ self].
    ].
    self withActivityIndicationDo:[
        self notify:(resources string:'Fetching %1' with:url).
        HTTPInterface get:url destinationFile:destinationFilename.
        self notify:nil.
    ]

    "Modified: / 20-05-2010 / 11:15:35 / cg"
!

fileContentsAsByteArray
    |file|

    file := self firstSelectedFile.
    file isNil ifTrue:[^ self ].
    file asFilename fileSize > (1024*1024) ifTrue:[
        file asFilename fileSize > (128*1024*1024) ifTrue:[
            Dialog warn:(resources string:'File is too big').
            ^ self.
        ].
        (Dialog confirm:(resources string:'File is big - proceed ?')) ifFalse:[^ self].
    ].
    file asFilename binaryContentsOfEntireFile inspect
!

fileFileIn
    "fileIn the selected file(s)"

    self fileFileInLazy:false 
!

fileFileIn:aFilename lazy:lazy
    "fileIn a file"

    self withActivityIndicationDo:[
        self notify:('File in:', aFilename asFilename baseName).
        self singleFileFileIn:aFilename lazy:lazy.
        self notify:nil.
    ]

    "Created: / 20-09-2006 / 14:28:35 / cg"
!

fileFileInLazy
    "fileIn the selected file(s). Do a quick load (no compilation)"

    self fileFileInLazy:true 
!

fileFileInLazy:lazy
    "fileIn the selected file(s)"

    self currentSelectedFiles do:[:fileName |
        self fileIn:fileName lazy:lazy
    ].

    "Modified: / 20-09-2006 / 14:29:24 / cg"
!

fileFileInPackage
    "assuming the current directory is a package directory, load it"

    |packageDir dir path top packageID|

    "/ find a reasonable package-id (walk up until we find stx)
    path := ''.
    dir := packageDir := self currentDirectory.

    top := (Smalltalk projectDirectoryForPackage:'stx') asFilename.
    [ (dir / 'stx') = top ] whileFalse:[
        path := dir baseName , '/' , path.
        dir := dir directory.
        dir isNil ifTrue:[
            Dialog warn:'Could not find a path from "stx" to the current directory.'.
            "/ should ask the user for a packageID and proceed...
            ^  self.
        ].
    ].
    packageID := path copyButLast:1.
    Smalltalk loadPackage:packageID fromDirectory:packageDir asAutoloaded:true
!

fileFileInToNameSpace
    "fileIn the selected file(s)<into a nameSpace"

    |ns listOfKnownNameSpaces|

    listOfKnownNameSpaces := Set new.
    NameSpace 
        allNameSpaces 
            do:[:eachNameSpace | 
                listOfKnownNameSpaces add:eachNameSpace name
            ].
    listOfKnownNameSpaces := listOfKnownNameSpaces asOrderedCollection sort.

    ns := Dialog 
                request:'During fileIn, new classes are created in nameSpace:'
                initialAnswer:(LastEnforcedNameSpace ? Class nameSpaceQuerySignal query name)
                list:listOfKnownNameSpaces.
    ns isEmptyOrNil ifTrue:[^ self].

    LastEnforcedNameSpace := ns.
    ns := NameSpace name:ns.

    Class nameSpaceQuerySignal 
        answer:ns
        do:[ 
            self fileFileInLazy:false 
        ] 
!

fileFindAllDuplicates
    "scan directory and all subdirs for duplicate files"

    |fileNames dir infoDir filesBySize
     result info dirPrefix myName stream textBox maxLength directories|


    self withActivityIndicationDo:[
        result := Dictionary new.
        myName := self class name asString.
        directories := self currentSelectedDirectories.
        directories isEmpty ifTrue:[^ self].
        
        dir := directories first.
"/        self label: myName, '- gathering file names ...'.
        [
            fileNames := dir recursiveDirectoryContents.
        ] on:FileStream openErrorSignal do:[:ex|
            self warn:(resources stringWithCRs:'Cannot access: %1\(%2)' 
                            with:ex pathName
                            with:ex description).
            ^ self
        ].
        fileNames := fileNames 
                        collect:[:fn | dir construct:fn]
                        thenSelect:[:fn | fn isDirectory not].

"/        self label:myName , '- gathering sizes ...'.
        infoDir := Dictionary new.
        fileNames do:[:fn |
            infoDir at:fn put:(fn fileSize)
        ].

        "/ for each, get the file's size.
        "/ in a first pass, look for files of the same size and
        "/ compare them ...

"/        self label:myName , '- preselect possible duplicates ...'.
        filesBySize := Dictionary new.
        infoDir keysAndValuesDo:[:fn :sz |
            |entry|

            entry := filesBySize at:sz ifAbsentPut:[Set new].
            entry add:fn.
        ].

        "/ any of same size ?

"/        self label:myName , '- checking for duplicates ...'.
        filesBySize do:[:entry |
            |files|

            entry size > 1 ifTrue:[
                files := entry asArray.
                1 to:files size-1 do:[:idx1 |
                    idx1+1 to:files size do:[:idx2 |
                        |fn1 fn2|

                        fn1 := files at:idx1.
                        fn2 := files at:idx2.

"/                        self label:myName , '- checking ' , fn1 baseName , ' vs. ' , fn2 baseName , ' ...'.
                        (result at:fn2 ifAbsent:nil) ~= fn1 ifTrue:[
                            "/ compare the files
                            (fn1 sameContentsAs:fn2) ifTrue:[
"/                                Transcript show:'Same: '; show:fn1 baseName; show:' and '; showCR:fn2 baseName.
                                result at:fn1 put:fn2.
                            ]
                        ]
                    ]
                ]
            ]
        ].

"/        self label:myName , '- sorting ...'.
        dirPrefix := dir pathName.
        result := result associations.
        result := result collect:[:assoc |
                                        |f1 f2|

                                        f1 := assoc key name.
                                        f2 := assoc value name.
                                        (f1 startsWith:dirPrefix) ifTrue:[
                                            f1 := f1 copyFrom:dirPrefix size + 2.
                                        ].
                                        (f2 startsWith:dirPrefix) ifTrue:[
                                            f2 := f2 copyFrom:dirPrefix size + 2.
                                        ].
                                        f1 < f2 ifTrue:[
                                            f2 -> f1
                                        ] ifFalse:[
                                            f1 -> f2
                                        ]
                                ].
        result sort:[:f1 :f2 | f2 value < f1 value].

        info := OrderedCollection new.
        result do:[:assoc |
            info add:(assoc key , ' same as ' , assoc value)
        ].
        info isEmpty ifTrue:[
            Dialog information:(resources string:'No duplicate files found.').
            ^ self.
        ].
    ].

    stream := CharacterWriteStream new.
    stream nextPutAllLines:info.

    textBox := TextBox new.
    textBox initialText:(stream contents).
    stream close.
    textBox title:(resources string:'File duplicates in directory: %1' with:dir asString).
    textBox readOnly:true.
    textBox noCancel.
    textBox label:(resources string:'Duplicates in %1' with:dir asString).
    maxLength := 10.
    info do:[: el |
        maxLength := maxLength max:(el size).
    ].
    textBox extent:((maxLength * 5)@(info size * 20)); sizeFixed:false.
    textBox maxExtent:Screen current extent.
    textBox openModeless.

    "Modified: / 27-07-2012 / 09:29:00 / cg"
!

fileFindDuplicateFile
    "scan directory for duplicates of the selected files"

    |files filesBySize samePerFile stream textBox mustHaveMatches|

    files := self currentSelectedFiles.
    files isEmpty ifTrue:[^ self].

    self withWaitCursorDo:[
        filesBySize := Dictionary new.
        files do:[:fn |
            |sz entry|

            sz := fn asFilename fileSize.
            (filesBySize at:sz ifAbsentPut:[Set new]) add:fn.
        ].

        samePerFile := Dictionary new.

        self currentSelectedDirectories do:[:eachDir |
            eachDir recursiveDirectoryContentsAsFilenamesDo:[:eachFile |
                eachFile isDirectory ifFalse:[
                    |sz possibleMatches|

                    sz := eachFile fileSize.
                    possibleMatches := filesBySize at:sz ifAbsent:nil.
                    possibleMatches notNil ifTrue:[
                        possibleMatches do:[:eachFileWithSameSize |
                            eachFileWithSameSize ~= eachFile ifTrue:[
                                (eachFileWithSameSize sameContentsAs:eachFile) ifTrue:[
                                    (samePerFile at:eachFileWithSameSize ifAbsentPut:[Set new]) add:eachFile
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ].
    ].

    stream := CharacterWriteStream with:'Duplicates:'.
    (samePerFile keys asOrderedCollection sort:[:a :b | a asFilename baseName < b asFilename baseName])
    do:[:origFile |
        |sameFiles|

        sameFiles :=  samePerFile at:origFile.
        stream nextPutLine:origFile baseName.
        (sameFiles asOrderedCollection collect:[:each | each baseName]) sort do:[:eachSameName |
            stream nextPutAll:'    '; nextPutLine:eachSameName.
        ]
    ].
    stream nextPutLine:'Files without duplicates:'.
    (samePerFile keys asOrderedCollection sort:[:a :b | a asFilename baseName < b asFilename baseName])
    do:[:origFile |
        |sameFiles|

        sameFiles :=  samePerFile at:origFile.
        sameFiles isEmpty ifTrue:[
            stream nextPutLine:origFile baseName.
        ].
    ].

    mustHaveMatches := Dialog request:'Must have for duplicates matching ?:' initialAnswer:(LastMustMatchPattern ? '[a-z][a-z][a-z]_[0-9][0-9][0-9].*').
    mustHaveMatches notEmptyOrNil ifTrue:[
        LastMustMatchPattern := mustHaveMatches.

        stream nextPutLine:'Files without duplicates in xxx_nnn.jpg:'.
        (samePerFile keys asOrderedCollection sort:[:a :b | a asFilename baseName < b asFilename baseName])
        do:[:origFile |
            |sameFiles|

            sameFiles :=  samePerFile at:origFile.
            sameFiles notEmpty ifTrue:[
                (sameFiles contains:[:file | mustHaveMatches match:file baseName]) ifFalse:[
                    stream nextPutLine:origFile baseName.
                ]
            ].
        ].
    ].

    textBox := TextBox new.
    textBox initialText:(stream contents).
    textBox title:'Files with same contents'.
    textBox readOnly:true.
    textBox noCancel.
    textBox extent:(350@400).
    textBox maxExtent:Screen current extent.
    textBox openModeless. "/ showAtPointer.

    "Created: / 11-07-2011 / 12:39:44 / cg"
!

fileFindDuplicates
    "scan directory for duplicate files"

    |infoDir filesBySize result info stream textBox maxLength directories allFiles titleStream size|

    directories := self currentSelectedDirectories.

    self withActivityIndicationDo:[
        result := Dictionary new.

        directories := self currentSelectedDirectories.
        directories isEmpty ifTrue:[^ self].

        allFiles := self allFilesInSelectedDirectoriesForWhich:[:f | true].

        infoDir := Dictionary new.
        allFiles do:[:fn |
            infoDir at:fn put:(fn info)
        ].

        "/ for each, get the file's size.
        "/ in a first pass, look for files of the same size and
        "/ compare them ...

        filesBySize := Dictionary new.
        infoDir keysAndValuesDo:[:fn :info |
            |sz entry|

            sz := info size.
            entry := filesBySize at:sz ifAbsentPut:[Set new].
            entry add:fn.
        ].

        "/ any of same size ?

        filesBySize do:[:entry |
            |files|

            entry size > 1 ifTrue:[
                files := entry asArray.
                1 to:files size-1 do:[:idx1 |
                    idx1+1 to:files size do:[:idx2 |
                        |fn1 fn2|

                        fn1 := files at:idx1.
                        fn2 := files at:idx2.

                        (result at:fn2 ifAbsent:nil) ~= fn1 ifTrue:[
                            "/ compare the files
                            (fn1 sameContentsAs:fn2) ifTrue:[
"/                                Transcript show:'Same: '; show:fn1 baseName; show:' and '; showCR:fn2 baseName.
                                result at:fn1 put:fn2.
                            ]
                        ]
                    ]
                ]
            ]
        ].

        result := result associations.
        result := result collect:[:assoc |
                                        |f1 f2|

                                        f1 := assoc key asString.
                                        f2 := assoc value asString.
                                        f1 < f2 ifTrue:[
                                            f2 -> f1
                                        ] ifFalse:[
                                            f1 -> f2
                                        ]
                                ].
        "/ result sort:[:f1 :f2 | f1 key > f2 key "f2 value < f1 key value"].
        result sort:[:f1 :f2 | " f1 key > f2 key" f2 value < f1 key value].

        info := OrderedCollection new.
        size := self getBestDirectory asString size.
        result do:[:assoc |
            |fn1 fn2|

            fn1 := assoc key.
            fn2 := assoc value.
            size > 1 ifTrue:[
                fn1 := ('..', (fn1 copyFrom:(size + 1))).
                fn2 := ('..', (fn2 copyFrom:(size + 1))).
            ].
            (fn1 includes:Character space) ifTrue:[
                fn1 := '"' , fn1 , '"'
            ].
            (fn2 includes:Character space) ifTrue:[
                fn2 := '"' , fn2 , '"'
            ].
            info add:(fn1 , ' same as ' , fn2)
        ].
        info isEmpty ifTrue:[
            Dialog information:'No duplicate files found.'.
            ^ self.
        ].
    ].
    stream := CharacterWriteStream new.
    stream nextPutAllLines:info.

    titleStream := CharacterWriteStream with:'File duplicates in directory'.
    directories size == 1 ifTrue:[
        titleStream nextPutAll:'y: '; nextPutAll: directories first asString.
    ] ifFalse:[
        titleStream nextPutLine:'ies: '.
        directories do:[:dir|
            size > 1 ifTrue:[
                titleStream nextPutAll:'..'.
                titleStream nextPutLine:((dir asString) copyFrom:(size + 1)).
            ] ifFalse:[
                titleStream nextPutLine:(dir asString).
            ].
        ]
    ].

    textBox := TextBox new.
    textBox initialText:(stream contents).
    textBox title:(titleStream contents).
    textBox readOnly:true.
    textBox noCancel.
    stream := WriteStream on:''.
    stream nextPutAll:'Duplicates in '.
    directories do:[ :aDirectory |
        stream nextPutAll:aDirectory baseName.
        stream space.
    ].
    textBox label:stream contents.
    maxLength := 10.
    info do:[: el |
        maxLength := maxLength max:(el size).
    ].
    textBox extent:((maxLength * 5)@((info size max:40)* 10)).
    textBox maxExtent:Screen current extent.
    textBox openModeless. "/ showAtPointer.

    "Modified: / 27-07-2012 / 09:29:14 / cg"
!

fileFindFile
    |filename|

    filename := self firstSelectedFileName.
    filename isNil ifTrue:[
        filename := Filename homeDirectory.
    ].
    FindFileApplication openOnFileName:filename for:self.
!

fileFindSimilarImages
    "scan directory for similar image files"

    |result stream textBox directories imageFiles histogramsV histogramsH 
     similarV similarH similar alreadyPrinted|

self withWaitCursorDo:[
    self withActivityIndicationDo:[
        result := Dictionary new.

        directories := self currentSelectedDirectories.
        directories isEmpty ifTrue:[^ self].

        imageFiles := self allFilesInSelectedDirectoriesForWhich:[:f | f mimeTypeFromName isImageType].
        "/ imageFiles := imageFiles select:[:f | f baseName startsWith:'foo'].
        imageFiles sort:[:a :b | a pathName < b pathName].
        
        "/ for each, get the color histogram
        histogramsV := Dictionary new.
        histogramsH := Dictionary new.
        imageFiles do:[:fn |
            |hist image|

            image := Image fromFile:fn.
            Transcript showCR:'generating histogram for ',fn baseName.
            hist := ImageColorHistogram new forImage:image.
            histogramsV at:fn put:(hist histogramVectorV).
            histogramsH at:fn put:(hist histogramVectorH).
        ].

        similarH := Dictionary new.
        similarV := Dictionary new.
        similar := Dictionary new.

        (self firstSelectedFile notNil
            ifTrue:[ Array with:self firstSelectedFile ]
            ifFalse:[ imageFiles ])
        do:[:eachFile1 |
            |setOfSimilar distancesV distancesH|

            distancesV := OrderedCollection new.
            distancesH := OrderedCollection new.
            setOfSimilar := OrderedCollection new.

            imageFiles do:[:eachFile2 |
                |v1 v2 dV dH|

                eachFile1 ~= eachFile2 ifTrue:[
                    v1 := histogramsV at:eachFile1.
                    v2 := histogramsV at:eachFile2.
                    dV := ImageColorHistogram distanceFrom:v1 to:v2.
                    distancesV add:(eachFile2 -> dV).
                    v1 := histogramsH at:eachFile1.
                    v2 := histogramsH at:eachFile2.
                    dH := ImageColorHistogram distanceFrom:v1 to:v2.
                    distancesH add:(eachFile2 -> dH).
                    (dV < 10000 and:[dH < 10000]) ifTrue:[
                        setOfSimilar add:eachFile2->(dV + dH).
                    ].
                ]
            ].
            distancesV sort:[:a1 :a2 | a1 value < a2 value].
            distancesH sort:[:a1 :a2 | a1 value < a2 value].
            similarV at:eachFile1 put:distancesV.
            similarH at:eachFile1 put:distancesH.
            setOfSimilar notEmpty ifTrue:[ similar at:eachFile1 put:setOfSimilar ].
        ].

        similar isEmpty ifTrue:[
            Dialog information:'No similarities found.'.
            ^ self.
        ].
    ].

    stream := CharacterWriteStream new.
    alreadyPrinted := Set new.

    imageFiles do:[:eachFile |
        |eachSet|

        (alreadyPrinted includes:eachFile) ifFalse:[
            eachSet := similar at:eachFile ifAbsent:nil.
            eachSet notNil ifTrue:[
                stream nextPutLine:eachFile pathName.
                eachSet do:[:info |
                    |fn2 dist|

                    fn2 := info key.
                    dist := info value.
                    stream nextPutAll:'    '.
                    stream nextPutAll:fn2 pathName.
                    stream nextPutLine:' (',dist printString,')'.
                    alreadyPrinted add:fn2.
                ].
                stream cr.
            ].
        ].
    ].
    ].

    textBox := TextBox new.
    textBox initialText:(stream contents).
    textBox title:'File similarities:'.
    textBox readOnly:true.
    textBox noCancel.

    textBox label:'File similarities'.
    textBox extent:(400@((similar size max:40)* 10)).
    textBox maxExtent:Screen current extent.
    textBox openModeless. "/ showAtPointer.

    "Modified: / 25-07-2006 / 09:07:25 / cg"
!

fileHexDump

    | file item|

    file := self firstSelectedFile.
    file notNil ifTrue:[
        item := DirectoryContentsBrowser itemClass fileName:file.
        self 
            applicationNamed:#FileApplicationNoteBook
            ifPresentDo:[:appl | appl openTextEditorWithHexPresentationOn:item].
    ].
!

fileIn:aFilename
    "fileIn a file"

    self fileIn:aFilename lazy:false

    "Created: / 20-09-2006 / 14:30:06 / cg"
!

fileIn:aFilename lazy:lazy
    "fileIn a file"

    self withActivityIndicationDo:[
        self notify:('File in:', aFilename asFilename baseName).
        self singleFileFileIn:aFilename lazy:lazy.
        self notify:nil.
    ]

    "Created: / 20-09-2006 / 14:29:21 / cg"
!

filterSelectedFiles:whichFilter
    |selectedFiles numFiles msg filterBlock|

    selectedFiles := self currentSelectedObjects.
    (numFiles := selectedFiles size) == 0 ifTrue:[^ self].

    msg := 'Replace contents of file ''%2'' with output of %3-filter ?'.
    numFiles > 1 ifTrue:[
        msg := 'Replace contents of %1 files with output of %3-filter ?'.
    ].

    (Dialog 
        confirm:(resources stringWithCRs:msg with:numFiles with:selectedFiles first baseName allBold with:whichFilter)
        initialAnswer:false
    ) ifFalse:[
        ^ self
    ].

    whichFilter == #rot13 ifTrue:[
        filterBlock := [:charIn | charIn rot13 ].
    ].
    "/ add more here...

    filterBlock isNil ifTrue:[
        self information:'No such filter: ' , whichFilter.
        ^ self.
    ].

    selectedFiles do:[:fileName |
        |s|

        self notify:('Processing:',  fileName baseName).
        fileName isDirectory ifFalse:[
            [
                |inFile outFile in out|

                inFile := fileName asFilename.
                outFile := (fileName pathName , '.filter') asFilename.

                [
                    |charIn charOut|

                    in := inFile readStream.
                    out := outFile writeStream.
                    [in atEnd] whileFalse:[
                        charIn := in next.
                        charOut := filterBlock value:charIn.
                        out nextPut:charOut.
                    ].
                    out close. out:= nil.
                    outFile renameTo:inFile.
                ] ensure:[
                    out notNil ifTrue:[ out close ].
                    in notNil ifTrue:[ in close ].
                    outFile delete.
                ]
            ] on:FileStream openErrorSignal do:[:ex|
                self warn:('Cannot process "%1".' bindWith:fileName baseName allBold).
            ].
        ]
    ].
    self notify:nil.

    "Modified: / 04-12-2006 / 13:14:48 / cg"
!

forEachParsedXmlFileDo:aBlock
    "parse all selected XML files, for each dom-tree, evaluate aBlock"

    self withActivityIndicationDo:[
        | selectedFiles xmlDocument |

        selectedFiles:= self currentSelectedFiles.
        selectedFiles do:[:fileName |
            XML::XMLSignal handle:[:ex |
                Dialog 
                    information:('Error while reading XML:\    %1' bindWith:ex description) withCRs
                    title:'XML Error'.
                ^ self.
            ] do:[
                |s d magic encoder document|

                s := fileName asFilename readStream.
                [
                    s binary.
                    magic := (s next:2).
                    magic = #[254 255] ifTrue:[
                        "/ UTF16BE
                        document := CharacterEncoder decodeString:(s upToEnd) from:#utf16be.
                    ] ifFalse:[ 
                        magic = #[255 254] ifTrue:[
                            "/ UTF16LE
                            document := CharacterEncoder decodeString:(s upToEnd) from:#utf16le.
                        ].
                    ]. 
                ] ensure:[
                    s close.
                ].
                document notNil ifTrue:[
                    xmlDocument := XML::XMLParser 
                                    processDocumentString:document 
                                    beforeScanDo:[:parse| parse validate:false].
                ] ifFalse:[
                    xmlDocument := XML::XMLParser 
                                    processDocumentInFilename:fileName 
                                    beforeScanDo:[:parse| parse validate:false].
                ]
            ].
            aBlock value:xmlDocument.
        ].
    ]

    "Created: / 17-02-2011 / 13:58:21 / cg"
!

forEachSelectedFileIgnoringDirectories:ignoreDirs do:aBlock 
    |numItems path files|

    files := self currentSelectedFiles.
    
    (numItems := files size) > 2 ifTrue:[
        (self 
            confirm:(resources string:'Open for each of the %1 items ?' 
                                 with:numItems)) ifFalse:[^ self].
    ].

    self withActivityIndicationDo:[
        files do:[:fileName |
            (ignoreDirs not or:[fileName isDirectory not]) ifTrue:[
                fileName isAbsolute ifTrue:[
                    path := fileName name.
                ] ifFalse:[
                    path := fileName pathName.
                ].
                aBlock value:path
            ]
        ].
    ].

    "Modified: / 19-01-2017 / 16:57:03 / stefan"
!

generateDetachedSignaturesForSelectedFiles
    "generate detached signature (pkcs7) files from the contents of the selected files.
     For Smalltalk text files, better use #generateSignaturesForSelectedFiles."

    self withActivityIndicationDo:[
        self currentSelectedFiles do:[:fn |
            |data hash signature signatureFile|

            self notify:'Generating detached signature file for ', (fn baseName),'...'.

            data := fn contentsAsString.
            hash := SHA1Stream hashValueOf:data.

            signature := Expecco::KeyFileGenerator new signExpeccoCode:hash.

            signatureFile := fn addSuffix:'sig'.
            signatureFile contents:signature.
        ].
        self updateCurrentDirectoryWithReread.
        self notify:nil.
    ]
!

generatePatchInstallerForSelectedFiles
    "generate an expecco patch, which installs the selected file(s).
     Opens a dialog asking for the target directory and if the patch should be signed"

    |dialog targetDirHolder targetDir 
     generateSignedPatchHolder patchFileNameHolder patchFileName|

    targetDirHolder := '.' asValue.
    generateSignedPatchHolder := true asValue.
    patchFileNameHolder := '/tmp/00nn_patchFile.st' asValue.

    dialog := Dialog new.
    dialog label:(resources string:'Patch Installer for File(s)').
    dialog addTextLabel:'Patchfile Name' adjust:#left.
    dialog addInputFieldOn:patchFileNameHolder tabable:true.
    dialog addTextLabel:'Target directory (relative to executable''s directory at execution time)' adjust:#left.
    dialog addInputFieldOn:targetDirHolder tabable:true.
    dialog addCheckBox:'Generate Signed Patch' on:generateSignedPatchHolder.
    dialog addAbortAndOkButtons.
    dialog open.

    dialog accepted ifFalse:[^ self].

    targetDir := targetDirHolder value asFilename.
    patchFileName := patchFileNameHolder value asFilename.

    self withActivityIndicationDo:[
        |outStream zipArchive pkcs7SignedData signatureFilename|

        self notify:'Generating self extracting st script: ', patchFileName name, '...'.
        outStream := patchFileName writeStream.
        outStream nextPutAll:'
|patchStream zipArchive|
patchStream := Expecco::Browser::CurrentPatchStreamQuery query.
patchStream isNil ifTrue:[ self error:''sorry, this patch can only be installed in expecco 2.6.2 and newer (missing CurrentPatchStreamQuery)''].
zipArchive := ZipArchive readingFrom:patchStream.
zipArchive members do:[:each | zipArchive extract:each fileName].
patchStream setToEnd. "/ to force fileIn to finish
!!

!! !!

'.
        zipArchive := ZipArchive writingTo:outStream. "/ newFileNamed:(patchFileName).

        self currentSelectedFiles do:[:fn |
            |inStream signatureFilename|

            inStream := fn asFilename readStream.
            zipArchive addFile: (targetDir construct:fn asFilename baseName) name fromStream:inStream.
            inStream close.
        ].

        zipArchive close.

        generateSignedPatchHolder value ifTrue:[
            self notify:'Generating signed file from: ', patchFileName name, '...'.

            pkcs7SignedData := Expecco::KeyFileGenerator new signExpeccoCode:patchFileName contentsOfEntireFile.
            signatureFilename := patchFileName withSuffix:'expeccoPatch'.
            signatureFilename contents:pkcs7SignedData.
        ].
        self notify:nil.
    ]
!

generateSignaturesForSelectedFiles
    "generate signed pkcs7 files from the contents of the selected files.
     These can be delivered as expeccoPatch files"

    self withActivityIndicationDo:[
        self currentSelectedFiles do:[:fn |
            |pkcs7SignedData signatureFilename|

            self notify:'Generating signed file from: ', (fn baseName), '...'.

            pkcs7SignedData := Expecco::KeyFileGenerator new signExpeccoCode:fn contentsOfEntireFile.
            signatureFilename := fn withSuffix:'expeccoPatch'.
            signatureFilename contents:pkcs7SignedData.
        ].
        self updateCurrentDirectoryWithReread.
        self notify:nil.
    ]
!

inspectXmlFile
    "Show an XML file - either in an XMLInspector or fall back to
     a plain inspector on the XML tree"

    self forEachParsedXmlFileDo:[:xmlDocument |
        XML::XMLInspector notNil ifTrue:[
            XML::XMLInspector openOn:xmlDocument.
        ] ifFalse:[
            "fall back..."
            xmlDocument inspect.
        ]
    ].

    "Modified: / 17-02-2011 / 13:58:16 / cg"
!

installAllAsAutoloaded
    "install all classes found here as autoloaded classes"

    self installAllAsAutoloadedRecursive:false
!

installAllAsAutoloadedRecursive
    "install all classes found here and in subdirectories as autoloaded classes"

    self installAllAsAutoloadedRecursive:true
!

installAllAsAutoloadedRecursive:aBoolean
    "install all classes found here (and in subdirs if aBoolean is true) as autoloaded classes"

    [
        LoadInProgressQuery answerNotifyLoadingDo:[
            |installAction|

            installAction := 
                [:fn |
                    (fn suffix = 'st') ifTrue:[
                        self notify:('Install as autoloaded: ', fn baseName).
                        self installAsAutoloaded:fn.
                    ]
                ].

            self withActivityIndicationDo:[
                self currentSelectedDirectories do:[:dir|
                    aBoolean ifTrue:[
                        dir recursiveDirectoryContentsAsFilenamesDo:installAction
                    ] ifFalse:[
                        dir directoryContentsAsFilenamesDo:installAction
                    ].
                ].
                self notify:nil.
            ].
        ]
    ] fork.
!

installAsAutoloaded:aFilename
    "install aFilename as autoloaded class"

    Smalltalk installAutoloadedClassFromSourceFile:aFilename

    "Modified: / 01-08-2013 / 16:58:09 / cg"
!

joinSelectedFiles
    |selectedFiles numFiles msg outFileName outFile outStream|

    selectedFiles := self currentSelectedObjects.
    (numFiles := selectedFiles size) <= 1 ifTrue:[^ self].

    msg := 'Join each of the %1 files into single file named:\\Attention: order in which files were selected is relevant here !!'.
    outFileName := Dialog request:(resources stringWithCRs:msg with:numFiles with:selectedFiles first baseName).
    outFileName isEmptyOrNil ifTrue:[^ self].
    outFile := selectedFiles first directory construct:outFileName.

    outStream := outFile writeStream.

    selectedFiles do:[:fileName |
        |inStream|

        self notify:('Adding:',  fileName baseName).
        inStream := fileName readStream.
        inStream copyToEndInto:outStream.
        inStream close.
    ].
    outStream close.
    self notify:nil.

    "Modified: / 04-12-2006 / 13:15:10 / cg"
!

loadImageThenDo:aBlock
    |img path files|

    files := self currentSelectedFiles.
    files isEmpty ifTrue:[ ^ self].
    files do:[:fileName |
        path := fileName.
        path isDirectory ifFalse:[
            img := Image fromFile:(path pathName).
            img notNil ifTrue:[
                aBlock value:img
            ] ifFalse:[
                Dialog warn:(resources string:'Unknown image format: "%1"' with:fileName asString)
            ]
        ]
    ].
!

loadSignatureSupport
    Expecco::KeyFileGenerator isNil ifTrue:[
        Smalltalk loadPackage:'exept:expecco/license'
    ].
!

openASN1Browser

    self openTool:OSI::ASN1Browser 
!

openAppletViewer
    |numItems files|

    files := self currentSelectedFiles.
    (numItems := files size) > 2 ifTrue:[
        (self 
            confirm:(resources string:'open for each of the %1 items ?' 
                                 with:numItems)) ifFalse:[^ self].
    ].

    Java startupJavaSystem.
"/    Java markAllClassesUninitialized.
"/    Java initAllStaticFields.
"/    Java initAllClasses.

    files do:[:fileName |
        |p path|

        path := fileName.
        path isDirectory ifFalse:[
            p := Java 
                    javaProcessForMainOf:(Java classForName:'sun.applet.AppletViewer')
                    argumentString:path pathName.
            p resume.
        ]
    ].
!

openCBrowser
    |dir files|

    dir := self theSingleSelectedDirectoryOrNil.
    dir isNil ifTrue:[ ^ self].
    self withActivityIndicationDo:[
        files := self currentSelectedObjects.
        files notEmptyOrNil ifTrue:[
            CBrowser::Browser openOn:files first.
        ] ifFalse:[
            CBrowser::Browser openIn:dir.
        ]
    ]

    "Modified: / 04-12-2006 / 13:15:19 / cg"
!

openChangeSetBrowser
    "open a changeSet browser on the selected file(s)"

    self
        openTool:(UserPreferences current changeSetBrowserClass) 
        with:#openOnFile: 
        ignoreDirectories:true

    "Modified (comment): / 27-07-2012 / 20:42:55 / cg"
!

openChangesBrowser
    "open a change browser on the selected file(s)"

    self openTool:(UserPreferences current changesBrowserClass)
!

openDiffView
    "open a diff-view on the two selected files"

    |name1 name2 files title 
     defaultName defaultDir|

    files := self currentSelectedObjects.
    files isEmpty ifTrue:[
        Dialog warn:(resources string:'You have to select a file first').
        ^ self.
    ].

    (files size == 2) ifTrue:[
        name1 := files last.
        name2 := files first.
    ] ifFalse:[
        LastFileDiffFile notNil ifTrue:[
            LastFileDiffFile exists ifTrue:[
                name1 := LastFileDiffFile.
            ].
"/            | directory |
"/            directory := self currentDirectory.
"/            directory notNil ifTrue:[
"/                lastFile := directory asFilename construct:(LastFileDiffFile baseName).
"/                (lastFile exists and:[lastFile isReadable]) ifTrue:[
"/                    name1 := lastFile.
"/                ]
"/            ]
        ].
        name2 := files first.
        title := resources string:'Show differences between "%1" and:' with:name2 baseName.
        defaultName := name1 notNil ifTrue:[name1 baseName] ifFalse:[nil].
        defaultDir := name1 notNil ifTrue:[name1 directory] ifFalse:[self currentDirectory].
        name1 := DialogBox 
                    requestFileName:title 
                    default:defaultName 
                    ok:(resources string:'OK') 
                    abort:(resources string:'Compare against File List') 
                    pattern:'*' 
                    fromDirectory:defaultDir.
    ].
    self openDiffViewOn:name1 and:name2

    "Modified: / 03-05-2012 / 08:03:16 / cg"
!

openDiffViewOn:fileArg1 and:fileArg2
    "open a diff-view on two files"

    |file1 file2 text1 text2 d err nm l1 sameContents msg|

    file1 := fileArg1.
    file2 := fileArg2.

    self withWaitCursorDo:[
        (file1 isNil or:[file1 asString isEmpty]) ifTrue:[
            text1 := self getAllFilesAsStrings asStringCollection withTabs.
            text1 := text1 collect:[:l | l isNil ifTrue:[' '] ifFalse:[l string]].
            file1 := nil.
            l1 := 'browser contents'
        ] ifFalse:[
            file1 := file1 asFilename.
            LastFileDiffFile := file1.
            file1 isReadable ifFalse:[
                nm := file1.
                file1 exists ifFalse:[
                    err := '"%1" does not exist.'.
                ] ifTrue:[
                    err := '"%1" is not readable.'
                ].
            ].
            l1 := file1 pathName
        ].

        err isNil ifTrue:[
            file2 isReadable ifFalse:[
                nm := file2.
                file2 exists ifFalse:[
                    err := '"%1" does not exist.'.
                ] ifTrue:[
                    err := '"%1" is not readable.'
                ].
            ].
        ].
        err notNil ifTrue:[
            Dialog warn:(resources string:err with:nm pathName allBold).
            ^ self
        ].

        self withActivityIndicationDo:[
            ((file1 notNil and:[file1 fileSize > (1024*1024*32)])
            or:[ file2 fileSize > (1024*1024*32) ]) ifTrue:[
                file1 fileSize = file2 fileSize ifTrue:[
                    ProgressIndicator
                        displayBusyIndicator:'Comparing...'
                        at:(Screen default center)
                        during:[
                            sameContents := (file1 sameContentsAs:file2).
                        ].
                    sameContents ifTrue:[
                        self information:'Same contents.'
                    ] ifFalse:[
                        self information:'Different contents (File(s) too big for more details).'
                    ].
                ] ifFalse:[
                    self information:'Different size (File(s) too big for more details).'
                ].
                ^ self.
            ].

            file1 notNil ifTrue:[
                file1 isDirectory ifTrue:[
                    text1 := file1 directoryContents asString.
                ] ifFalse:[
                    text1 := file1 contents.
                ]
            ].
            file2 isDirectory ifTrue:[
                text2 := file2 directoryContents asString.
            ] ifFalse:[
                text2 := file2 contents.
            ].
            text1 = text2 ifTrue:[
                (file1 isDirectory or:[file2 isDirectory]) ifTrue:[
                    msg := 'Same filename lists.'
                ] ifFalse:[
                    msg := 'Same contents.'
                ].
                self information:msg
            ] ifFalse:[
                d := DiffTextView 
                        openOn:text1 label:l1
                        and:text2 label:file2 pathName.
                d topView label:(resources string:'File Differences').
            ]
        ]
    ]

    "Modified: / 03-05-2012 / 08:03:16 / cg"
!

openDirectoryDiffView
    "open a directory diff-view"

    |name1 name2 files|

    files := self currentSelectedObjects.
    files notEmpty ifTrue:[
        name1 := files first asFilename.
        name1 asFilename isDirectory ifFalse:[
            name1 := name1 directory
        ].
    ].

    (files size == 2) ifTrue:[
        name2 := files second.
    ] ifFalse:[
        (files size ~= 1) ifTrue:[
            Dialog warn:(resources string:'Please select one or two directories.').
            ^ self.
        ].
        name2 := Dialog 
                    requestDirectoryName:(resources
                                            string:'Recursive compare "%1" with folder:' 
                                            with:name1 asFilename baseName)
                    default:(LastFileDiffDirectory ? self currentDirectory).
        name2 isEmptyOrNil ifTrue:[^ self].
        LastFileDiffDirectory := name2.
    ].
    name2 := name2 asFilename.

    name2 asFilename isDirectory ifFalse:[
        name2 := name2 directory
    ].

    self 
        applicationNamed:#FileApplicationNoteBook
        ifPresentDo:[:appl | ^ appl openCompareDirectory:name1 with:name2].

    "Created: / 20-05-2010 / 15:01:17 / cg"
!

openEditor
    self openTool:EditTextView
!

openGV
    self openOSCommandWithFiles:'gv'
!

openHTMLReader

    self openTool:HTMLDocumentView ignoreDirectories:false
!

openImageEditor
    [
        self loadImageThenDo:[:img | img edit]
    ] fork
!

openImageInspector
    [
        self loadImageThenDo:[:img | img inspect]
    ] fork
!

openImagePreview
    [
        self 
            loadImageThenDo:
                [:img |
                    |i top viewer|

                    top := StandardSystemView new.

                    viewer := ImageView origin:0.0@0.0 corner:1.0@1.0 in:top.
                    i := img.
                    top extent:200@200.
                    top label:(img fileName asFilename directory baseName , Filename separator , img fileName asFilename baseName).
                    top openAndWait.

                    (i width > 200 or:[i height > 200]) ifTrue:[
                        i := i magnifiedPreservingRatioTo:200@200.
                    ].
                    viewer image:i.
                ].
    ] fork
!

openMP3Player
    |file|

    file := self currentSelectedFiles.
    (file isEmpty) ifTrue:[
        ^ self.
    ].
    file := file first.
    (MP3PlayerApplication ? SaugFix::MP3PlayerApplication) playSong:file.
!

openOSCommandWithFiles:command
    |files fileNames|

    files := self currentSelectedFiles.
    (files isEmpty) ifTrue:[
        ^ self.
    ].

    fileNames := files collect:[:each |
                    '"' , each asFilename pathName , '"'
                 ].

    [
        OperatingSystem 
            executeCommand:command , ' ' , fileNames asStringCollection asString
            inDirectory:(files first asFilename directory).
    ] fork
!

openPDFViewer
    |files fileNames cmd arg|

    files := self currentSelectedFiles.
    (files isEmpty) ifTrue:[
        ^ self.
    ].
    cmd := MIMETypes defaultCommandTemplateToOpenMimeType:'application/pdf'.
    cmd isNil ifTrue:[
        Dialog warn:'No viewer has been defined for pdf-files (See MIMETypes initialization).'.
        ^ self.
    ].

    fileNames := 
        files 
            collect:
                [:each |
                    '"' , each asFilename pathName , '"'
                ].
    arg := fileNames asStringCollection asStringWith:' '.

    (cmd includesString:'"%1"') ifTrue:[
        cmd := cmd copyReplaceString:'"%1"' withString:'%1'    
    ].

    [
        OperatingSystem executeCommand:(cmd bindWith:arg).
    ] fork

    "Modified: / 12-05-2004 / 12:31:20 / cg"
!

openRP
    self openOSCommandWithFiles:'realplay'
!

openResourceFileEditor

    self 
        openTool: Tools::InternationalLanguageTranslationEditor
        with: #openOnFile:
!

openSlideShow
    |dir|

    dir := self theSingleSelectedDirectoryOrNil.
    dir isNil ifTrue:[^ self].

    CodingExamples_GUI::SlideShow openIn:dir.
!

openSnapshotImageBrowser
    "Sorry, for now, only the old browser can handle snapShotImages."

    ^ self openTool:SystemBrowser with:#openOnSnapShotImage: ignoreDirectories:true
!

openTerminal
    |dir|

    dir := self theSingleSelectedDirectoryOrHomeDir.

    TerminalApplication notNil ifTrue:[
        TerminalApplication openIn:dir
    ] ifFalse:[
        VT100TerminalView openShellIn:dir.
    ].
!

openTool:aToolClass
    "open a tool on the selected file(s)"

    ^ self openTool:aToolClass ignoreDirectories:true
!

openTool:aToolClass ignoreDirectories:ignoreDirs
    "open a tool on the selected file(s)"

    ^ self
        openTool:aToolClass 
        with:#openOn: 
        ignoreDirectories:ignoreDirs
!

openTool:aToolClass with:aSelector
    "open a tool on the selected file(s)"

    ^ self openTool:aToolClass with:aSelector ignoreDirectories:true
!

openTool:aToolClass with:aSelector ignoreDirectories:ignoreDirs
    "open a tool on the selected file(s)"

    |tool|

    aToolClass isNil ifTrue:[
        Dialog warn:'Sorry, that tool seems to be not available'.
        ^ nil.
    ].
    self forEachSelectedFileIgnoringDirectories:ignoreDirs do:[:path |
        tool := aToolClass perform:aSelector with:path.
    ].
    ^ tool
!

openWebBrowser
    self 
        forEachSelectedFileIgnoringDirectories:true 
        do:[:path |
            Error
                handle:[:ex |
                    Dialog warn:'Shell execution failed: ',ex description
                ] do:[
                    OperatingSystem openApplicationForDocument:path operation:#open.
                    ^ self.
                ]
        ].
!

openWorkspace
    self 
        openTool:WorkspaceApplication 
        with:#openOnFile:
        ignoreDirectories:true
!

openXV
    self openOSCommandWithFiles:'xv'
!

openZipTool
    |zipTool|

    (zipTool := self openTool:ZipTool) notNil ifTrue:[
        zipTool initialExtractDirectory:(self theSingleSelectedDirectoryOrHomeDir).
    ].
!

readAbbrevFile
    "read the abbrev file and install classes found there as autoloaded classes"

    |directories|

    directories := self currentSelectedDirectories.
    directories isEmpty ifTrue:[^ self].

    self withActivityIndicationDo:[
        directories do:[:eachDir |
            Smalltalk installAutoloadedClassesFrom:(eachDir construct:'abbrev.stc').
        ]
    ]

    "Modified: / 25-07-2006 / 09:07:43 / cg"
!

readAndShowResources
    self withActivityIndicationDo:[
        | selectedFiles|

        selectedFiles:= self currentSelectedFiles.
        selectedFiles do:[:fileName |
            resources := ResourcePack fromFile:fileName.
            resources inspect.
        ].
    ]
!

singleFileFileIn:fileName lazy:lazy
    "fileIn the selected file(s)"

    |aStream wasLazy notifyString dontAskSignals lang|

    fileName isRegularFile ifFalse:[
        ^ self.
    ].

    [
        (ObjectFileLoader notNil
         and:[ObjectFileLoader hasValidBinaryExtension:fileName]) ifTrue:[
            AbortOperationRequest catch:[
                |p|

                "/
                "/ look if already loaded ...  then unload first
                "/
                p := fileName pathName.
                (ObjectFileLoader loadedObjectFiles includes:p) ifTrue:[
                    (Dialog confirm:(resources 
                                        string:'%1 is already loaded; load anyway ?'
                                        with:p)) ifFalse:[
                        ^ self
                    ].
                    notifyString := 'unloading old ' , p , ' ...'.
                    Transcript showCR:notifyString.
                    self notify:notifyString.
                    ObjectFileLoader unloadObjectFile:p. 
                ].

                notifyString := 'loading ' , p , ' ...'.
                Transcript showCR:notifyString.
                self notify:notifyString.
                (ObjectFileLoader loadObjectFile:p) isNil ifTrue:[
                    notifyString := 'Error: could not load ' , p.
                    Transcript showCR:notifyString.
                    self notify:notifyString.
               ] ifFalse:[
                    Class addInfoRecord:('fileIn ' , fileName asFilename pathName) 
                ].
            ]
        ] ifFalse:[ ((fileName hasSuffix:'cls') 
                     and:[((fileName mimeTypeOfContents ? '') startsWith:'application/x-smalltalk-source') not ]) ifTrue:[
            "/ loading a binary class file
            aStream := fileName readStreamOrNil.
            aStream notNil ifTrue:[
                aStream fileInBinary.
            ]
        ] ifFalse:[
            ((fileName hasSuffix:'class') or:[(fileName hasSuffix:'cla')]) ifTrue:[
                "/ loading a java class file
                JavaClassReader notNil ifTrue:[
                    JavaClassReader loadFile:fileName
                ]
            ] ifFalse:[ (fileName hasSuffix:'sif') ifTrue:[
                "/ loading a sif (smalltalk interchange format) file
                SmalltalkInterchangeSTXFileInManager autoload.    
                SmalltalkInterchangeFileManager newForFileIn
                    fileName: fileName pathName;
                    fileIn.
            ] ifFalse:[ (fileName hasSuffix:'pcl') ifTrue:[
                Parcel isNil ifTrue:[
                    Dialog warn:'Parcel support not loaded.'
                ] ifFalse:[
                    Parcel loadParcelFrom: fileName pathName
                ]
            ] ifFalse:[ (fileName hasSuffix:'jar') ifTrue:[
                JavaVM isNil ifTrue:[ 
                    Dialog warn: (resources string: 'Java support is not loaded.').
                    ^ self.
                ] ifFalse:[
                    JavaVM booted ifFalse:[ 
                        (Dialog confirm: (resources string: 'Java is not initialized. Initialize now?')) ifFalse:[ ^ self. ].
                        JavaVM boot.
                    ].
                    JavaVM loadClassesIn: fileName.  
                ]
            ] ifFalse:[
                "/ ask programming languages...
                lang := ProgrammingLanguage allDetect:[:l | l canReadSourceFile:fileName] ifNone:nil.
                (lang isNil and:[(fileName hasSuffix:'js')]) ifTrue:[
                    Smalltalk loadPackage:'stx:libjavascript'.
                    lang := ProgrammingLanguage allDetect:[:l | l canReadSourceFile:fileName] ifNone:nil.
                ].
                (lang notNil and:[lang ~= SmalltalkLanguage]) ifTrue:[
                    lang fileIn:fileName.
                ] ifFalse:[
                    "/ loading a regular (chunk) or xml source file
                    Error handle:[:ex |
                        self errorNotify:'Error during file in: ', ex description.
                        ex resume.
                    ] do:[
                        aStream := fileName readStream.
                        [
                            Class withoutUpdatingChangesDo:[
                                wasLazy := Compiler compileLazy:lazy.
                                Smalltalk fileInStream:aStream.
                            ].
                            Class addInfoRecord:('fileIn ' , fileName asString) 
                        ] ensure:[
                            Compiler compileLazy:wasLazy.
                            aStream close
                        ]
                    ]
                ]
            ]]]]
        ]]
    ] on:Error, HaltInterrupt, Class packageRedefinitionNotification do:[:ex| 
        |sig msg label labels values action proceedValue isRedef redefKind|

        isRedef := false.
        sig := ex creator.
        (dontAskSignals notNil and:[dontAskSignals includesKey:sig]) ifTrue:[
            action := #continue    
        ] ifFalse:[
            (sig == NoHandlerError and:[ex parameter rejected]) ifTrue:[
                ex reject
            ].
            sig == Class methodRedefinitionNotification ifTrue:[
                msg := 'trying to overwrite method:\\    ' , ex oldMethod whoString , '\\in package ''' 
                       , ex oldPackage , ''' with method from package ''' , ex newPackage , ''''.
                label := 'Method redefinition in fileIn'.
                redefKind := 'method'.
                isRedef := true.
            ] ifFalse:[sig == Class classRedefinitionNotification ifTrue:[
                msg := 'trying to redefine class: ' , ex oldClass name allBold , '\\in package ''' 
                       , ex oldPackage , ''' with new definition from package ''' , ex newPackage , ''''.
                label := 'Class redefinition in fileIn'.
                redefKind := 'class'.
                isRedef := true.
            ] ifFalse:[sig == HaltInterrupt ifTrue:[ |sender|
                label := msg := 'Breakpoint/Halt in fileIn'.
                sender := ex suspendedContext.
                msg := msg , ('\\in %1 » %2' bindWith:(sender receiver class name) with:(sender sender selector))
            ] ifFalse:[
                label := 'Error in fileIn'.
                msg := 'error in fileIn: %1'
            ]]].

            msg := msg bindWith:ex description.

            labels := #('Cancel' 'Skip' 'Debug' 'Compare Sources').
            values := #(abort     skip  debug   compareSources).

            isRedef ifTrue:[
                  msg := msg, ('%<cr>%<cr>Continue will install the change and assign the %1 to the new package.
    Keep Package will install the change, but keep the %1 in the old package.' bindWith:redefKind).

                  labels := labels , #('Keep Package' ).
                  values := values , #(keep).
            ].

            labels := labels , #( 'Continue' 'ContinueForAll').
            values := values , #(  continue   continueForAll).

            AbortAllOperationWantedQuery query ifTrue:[
                  labels := #('Cancel All') , labels.
                  values := #(cancelAll) , values.
            ].

            action := Dialog 
                          choose:(msg withCRs) 
                          label:label
                          image:(WarningBox iconBitmap)
                          labels:labels
                          values:values
                          default:#continue
                          onCancel:#abort.
        ].

        action == #continueForAll ifTrue:[
            dontAskSignals isNil ifTrue:[
                dontAskSignals := IdentityDictionary new.
            ].
            dontAskSignals at:sig put:#continue.
            action := #continue.
        ].

        (action == #compareSources) ifTrue:[
            DiffCodeView 
                openOn:(ex oldMethod source) label:'Old Source'
                and:(ex newMethod source) label:'New Source'
                title:ex description.
            ex resignalAs:ex
        ].
        (action == #continue or:[action == #keep]) ifTrue:[
            ex proceedWith:action "(isRedef ifTrue:[#keep] ifFalse:[#continue])".
        ].
        action == #abort ifTrue:[
            AbortOperationRequest raise.
            ex return
        ].
        action == #cancelAll ifTrue:[
            AbortAllOperationRequest raise.
            ex return
        ].
        action == #skip ifTrue:[
            ex proceedWith:nil
        ].
        action == #debug ifTrue:[
            Debugger enter:ex returnableSuspendedContext 
                     withMessage:ex description 
                     mayProceed:true.
            ex proceedWith:nil.
        ].
        ex reject
    ]

    "Modified: / 22-11-2011 / 13:52:17 / cg"
    "Modified: / 19-02-2014 / 12:49:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

splitFile:infile intoPiecesOfSize:kiloBytes
    |bytesPerSplit splitIndex bufferSize buffer n
     inStream outFile outStream remaining remainingInThisOutfile|

    bufferSize := 32*1024.

    inStream := infile readStream.

    bytesPerSplit := kiloBytes * 1024.

    remaining := infile fileSize.
    splitIndex := 1.
    [remaining > 0] whileTrue:[
        outFile := infile pathName , '_' , (splitIndex printString leftPaddedTo:3 with:$0).
        outStream := outFile asFilename writeStream.
        remainingInThisOutfile := remaining min:bytesPerSplit.
        [remainingInThisOutfile > 0] whileTrue:[
            buffer := ByteArray new:bufferSize.
            n := inStream 
                    nextBytes:(bufferSize min:remainingInThisOutfile)
                    into:buffer 
                    startingAt:1.
            outStream nextPutBytes:n from:buffer startingAt:1.
            remainingInThisOutfile := remainingInThisOutfile - n.
            remaining := remaining - n.
        ].
        outStream close.
        splitIndex := splitIndex + 1.
    ].
    inStream close.
!

splitFile:infile intoPiecesWithNumberOfLines:numberOfLines
    |splitIndex line
     inStream outFile outStream remainingLinesInThisOutfile|

    inStream := infile readStream.

    splitIndex := 1.
    [inStream atEnd] whileFalse:[
        outFile := infile pathName , '_' , (splitIndex printString leftPaddedTo:3 with:$0).
        outStream := outFile asFilename writeStream.
        remainingLinesInThisOutfile := numberOfLines.
        [(remainingLinesInThisOutfile > 0) and:[inStream atEnd not]] whileTrue:[
            line := inStream nextLine.
            outStream nextPutLine:line.
            remainingLinesInThisOutfile := remainingLinesInThisOutfile - 1.
        ].
        outStream close.
        splitIndex := splitIndex + 1.
    ].
    inStream close.
!

splitSelectedFiles
    |selectedFiles numFiles msg sizeString kiloBytes|

    selectedFiles := self currentSelectedFiles.
    (numFiles := selectedFiles size) == 0 ifTrue:[^ self].

    msg := (numFiles > 1) 
                ifTrue:'Split each of the %1 files into pieces of size (in kB):'
                ifFalse:'Split %2 into pieces of size (in kB):'.

    sizeString := Dialog request:(resources stringWithCRs:msg with:numFiles with:selectedFiles first baseName).
    sizeString isEmptyOrNil ifTrue:[^ self].
    kiloBytes := Integer readFrom:sizeString onError:nil.
    kiloBytes isNil ifTrue:[^ self].

    selectedFiles do:[:fileName |
        self notify:('Splitting:',  fileName baseName).
        fileName isDirectory ifFalse:[
            self splitFile:fileName intoPiecesOfSize:kiloBytes.
        ]
    ].
    self notify:nil.

    "Modified: / 04-12-2006 / 13:15:26 / cg"
!

splitSelectedFilesByLines
    |selectedFiles numFiles msg numLinesString numLines|

    selectedFiles := self currentSelectedFiles.
    (numFiles := selectedFiles size) == 0 ifTrue:[^ self].

    msg := (numFiles > 1) 
                ifTrue:'Split each of the %1 files into pieces with number of lines:'
                ifFalse:'Split %2 into pieces with number of lines:'.

    numLinesString := Dialog request:(resources stringWithCRs:msg with:numFiles with:selectedFiles first baseName).
    numLinesString isEmptyOrNil ifTrue:[^ self].

    numLines := Integer readFrom:numLinesString onError:nil.
    numLines isNil ifTrue:[^ self].

    selectedFiles do:[:fileName |
        self notify:('Splitting:',  fileName baseName).
        fileName isDirectory ifFalse:[
            self splitFile:fileName intoPiecesWithNumberOfLines:numLines
        ]
    ].
    self notify:nil.
!

truncateSelectedFilesToZeroSize
    |selectedFiles numFiles msg|

    selectedFiles := self currentSelectedObjects.
    (numFiles := selectedFiles size) == 0 ifTrue:[^ self].

    msg := 'Really truncate file ''%2'' to zero length ?\\WARNING: contents of file is lost !!\This cannot be undone.'.
    numFiles > 1 ifTrue:[
        msg := 'Really truncate %1 files to zero length ?\\WARNING: contents of files is lost !!\This cannot be undone.'.
    ].

    (Dialog 
        confirm:(resources stringWithCRs:msg with:numFiles with:selectedFiles first baseName allBold)
        initialAnswer:false
    ) ifFalse:[
        ^ self
    ].

    selectedFiles do:[:fileName |
        |s|

        self notify:('Truncating:',  fileName baseName).
        fileName isDirectory ifFalse:[
            [
                s := fileName writeStream.
                s close.
            ] on:FileStream openErrorSignal do:[:ex|
                self warn:('Cannot truncate "%1".' bindWith:fileName baseName allBold).
            ].
        ]
    ].
    self notify:nil.

    "Modified: / 04-12-2006 / 13:15:28 / cg"
! !

!AbstractFileBrowser methodsFor:'menu queries-tools'!

anySTFilesOrDirectoriesPresent
    ^ self anyDirectoriesOrFilesPresentWithSuffix:'st'
!

anySTFilesPresent
    ^ self anyFilesPresentWithSuffix:'st'
!

canCreateNewProject
    self currentFilesAreInSameDirectory ifFalse:[^ false].
    ^ self currentSelectedFiles contains:[:fileName| 
        | suffix|
        suffix := fileName suffix asLowercase.
        (suffix = 'prj' or:[suffix = 'st'])
    ]
!

canDoTerminal

    ^ OperatingSystem isUNIXlike
      or:[OperatingSystem isMSWINDOWSlike]
!

canDoTerminalAndSystemIsDOS

    ^ self canDoTerminal and:[OperatingSystem isMSWINDOWSlike]
!

canDoTerminalAndSystemIsUnix

    ^ self canDoTerminal and:[OperatingSystem isUNIXlike]
!

canGenerateSignatureFiles
    "we need the both the KeyFileGenerator (for the secret expecco key) and the KeyFile"

    Expecco::KeyFileGenerator isNil ifTrue:[ ^ false ].
    Expecco::KeyFile isNil ifTrue:[ ^ false ].

    ^ self currentSelectedFiles notEmptyOrNil
!

canOpenMonticelloBrowser
    ^ self currentSelectedFiles
        contains:[:fileName|
            fileName suffix asLowercase = 'mcz'
        ]
!

canReadAbbrevFile

    |currentDirectory|

    self currentFilesAreInSameDirectory ifFalse:[^ false].
    currentDirectory := self currentDirectory.
    ^ currentDirectory notNil 
      and:[ (currentDirectory construct:'abbrev.stc') exists ]
!

canRemoveFromSourcePath

    ^ false
!

cannotGenerateSignatureFiles
    ^ self canGenerateSignatureFiles not
!

hasASN1
    ^ [ OSI::ASN1Parser notNil 
        and:[OSI::ASN1Parser isLoaded]]

!

hasASN1AndSelection
    ^ [ self hasSelection value 
        and:[self currentSelectedFiles size > 0
        and:[OSI::ASN1Parser notNil 
        and:[OSI::ASN1Parser isLoaded]]]]
!

hasCBrowser
    ^ [ CBrowser::Browser notNil ]
!

hasJava

    ^ [ JavaVM notNil 
        and:[JavaClassReader notNil 
        and:[JavaClassReader isLoaded]]]
!

hasJavaAndSelection

    ^ [ self currentSelectedFiles notEmptyOrNil
        and:[JavaClassReader notNil 
        and:[JavaClassReader isLoaded]]]
!

hasMP3Player

    ^ [ MP3PlayerApplication notNil
        or:[SaugFix::MP3PlayerApplication notNil ]]
!

hasMP3PlayerAndSelection

    ^ [ self currentSelectedFiles notEmptyOrNil
        and:[ self hasMP3Player value]]
!

hasResourceFileSelected
    ^ (self currentSelectedFiles) 
        contains:[:fn | 
            fn suffix asLowercase = 'rs'
        ].
!

hasSlideShow

    ^ [CodingExamples_GUI::SlideShow notNil]
!

hasSnapshotSelection

    ^ [ 
        | files |

        files := self currentSelectedFiles.
        ((files size == 1)
        and:[ files first hasSuffix:'img' ])
      ]
!

hasXml
    ^ [ XML::XMLParser notNil ]
!

hasXmlFileSelected
    "/ cg - no longer use this to enable XML-inspector (always enabled).
    "/ then handle the error when it ever fails during xml-parsing.

    ^ [
        |sel fileName|

        sel := self currentSelectedFiles.
        sel size == 1 ifTrue:[
            fileName := sel first.
            fileName notNil ifTrue:[
                #('xml' 'xsd' 'vdx') includes:fileName suffix asLowercase
            ] ifFalse:[
                false
            ]
        ] ifFalse:[
            false
        ]
      ]
!

hasZipFileSelected
    |sel fileName suff|

    sel := self currentSelectedFiles.
    sel size == 1 ifFalse:[^ false].

    fileName := sel first.
    fileName isNil ifTrue:[^ false].

    suff := fileName suffix asLowercase.
    (suff = 'zip' or:[suff = 'jar']) ifTrue:[^ true].

    ^ fileName mimeTypeOfContents = 'application/x-zip-compressed'

    "Modified: / 14-02-2011 / 17:17:03 / cg"
!

hasZipFileSelectedHolder
    ^ [ self hasZipFileSelected ]

    "Created: / 14-02-2011 / 17:16:08 / cg"
!

javaSupportLoaded

    ^ false
! !



!AbstractFileBrowser methodsFor:'presentation'!

getModeString:modeBits
    "convert file-mode bits into a more user-friendly string.
     This is wrong here - should be moved into OperatingSystem."

    ^ self getModeString:modeBits 
                    with:#( 'owner:' $r $w $x 
                            ' group:' $r $w $x 
                            ' others:' $r $w $x )
!

getModeString:modeBits with:texts
    "convert file-mode bits into a more user-friendly string.
     This is wrong here - should be moved into OperatingSystem."

    |bits modeString|

    bits := modeBits bitAnd:8r777.
    modeString := ''.

    #( nil 8r400 8r200 8r100 nil 8r040 8r020 8r010 nil 8r004 8r002 8r001 ) 
    with: texts do:[:bitMask :access |
        |ch|

        bitMask isNil ifTrue:[
            modeString := modeString , access
        ] ifFalse:[
            (bits bitAnd:bitMask) == 0 ifTrue:[
                ch := $-
            ] ifFalse:[
                ch := access
            ].
            modeString := modeString copyWith:ch 
        ]
    ].
    ^ modeString
! !

!AbstractFileBrowser methodsFor:'private'!

theSingleSelectedDirectoryOrHomeDir
    |dir|

    dir := self theSingleSelectedDirectoryOrNil.
    dir isNil ifTrue:[ dir := Filename homeDirectory].
    ^ dir.
!

theSingleSelectedDirectoryOrNil
    |dirs|

    dirs := self currentSelectedDirectories.
    dirs size ~= 1 ifTrue:[ ^ nil].
    ^ dirs anElement.
!

theSingleSelectedFileOrNil
    |dirs|

    dirs := self currentSelectedFiles.
    dirs size ~= 1 ifTrue:[ ^ nil].
    ^ dirs anElement.
! !

!AbstractFileBrowser methodsFor:'queries'!

cBrowserLoaded
    ^ CBrowser::Browser notNil
!

cBrowserMenuItemVisible
    ^ self cBrowserLoaded or:[ OperatingSystem getLoginName = 'cg' ]

    "Created: / 04-10-2011 / 13:40:38 / cg"
!

getAllFilesAsStrings
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

getFileInfoStringForFirstSelectedFile:longInfo
    "get stat info on selected file - return a string which can be
     shown in a box"

    |selFiles filename fileOutput modeBits modeString s info
     sizeString fileSize tAccess tModification buffer|

    selFiles := self currentSelectedObjects.
    selFiles size ~~ 1 ifTrue:[ ^ nil].
    filename := selFiles first.

    info := filename linkInfo.
    info isNil ifTrue:[
        ^ 'Cannot get fileInfo'.
        ^ nil
    ].

    buffer := Text writeStream.

    buffer 
        nextPutAll:'filename: '; 
        nextPutLine:filename asString.

    OperatingSystem isMSDOSlike ifTrue: [
        (info alternativeName notNil
        and:[ info alternativeName ~= info fullName ]) ifTrue:[
            buffer nextPutAll:'shortname: '.
            buffer nextPutLine:info alternativeName.
        ]
    ].

    buffer nextPutAll:'type:   '.
    info isSymbolicLink ifTrue:[
        filename exists ifFalse:[
            buffer nextPutAll:'broken '.
        ].
        buffer 
            nextPutAll:'symbolic link to: ';
            nextPutLine:(info path ? '???').
    ] ifFalse:[
        (longInfo and:[info isRegular]) ifTrue:[
            fileOutput := filename fileType.
        ].

        fileOutput isNil ifTrue:[
            s := info type asString
        ] ifFalse:[
            s := 'regular (' , fileOutput , ')'
        ].
        buffer nextPutLine:s.
    ].

    fileSize := info fileSize.
    sizeString := 'size:   ', fileSize printString.
    longInfo ifTrue:[
        fileSize > 1024  ifTrue:[
            sizeString := sizeString,' (',(UnitConverter fileSizeStringFor:fileSize),')'.
        ].
    ].
    buffer nextPutLine:sizeString.

    modeBits := info mode.
    modeString := self getModeString:modeBits.

    buffer nextPutAll:'access: '; nextPutAll:modeString.
    longInfo ifTrue:[
        buffer nextPutAll:' ('; nextPutAll:(modeBits printStringRadix:8); nextPut:$).
    ].
    buffer
        cr;
        nextPutAll:'owner:  ';
        nextPutLine:(OperatingSystem getUserNameFromID:(info uid)).

    longInfo ifTrue:[
        buffer 
            nextPutAll:'group:  ';
            nextPutLine:(OperatingSystem getGroupNameFromID:(info gid)).

        tAccess := info accessTime.
        buffer 
            nextPutAll:'last access:       '; 
            nextPutAll:tAccess asDate printString; 
            space;
            nextPutLine:tAccess asTime printString.

        tModification := info modificationTime.
        buffer 
            nextPutAll:'last modification: '; 
            nextPutAll:tModification asDate printString; 
            space;
            nextPutLine:tModification asTime printString.
    ].
    ^ buffer contents

    "Modified: / 07-02-2007 / 10:38:14 / cg"
!

hasImageColorHistogram
    ^ ImageColorHistogram notNil
!

hasSubversionSupport
    ^ ConfigurableFeatures includesFeature: #SubversionSupport

    "Created: / 24-06-2010 / 19:59:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 10:41:19 / cg"
    "Modified: / 19-01-2012 / 10:43:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialCommandFor:fileName into:aBox
    "set a useful initial command for execute box."

    self class initialCommandFor:fileName in:Filename currentDirectory intoBox:aBox
!

isAbstractFileBrowser

    ^ true
!

systemIsDOS

    ^ OperatingSystem isMSDOSlike
!

systemIsOSX

    ^ OperatingSystem isOSXlike
!

systemIsUnix
    ^ OperatingSystem isUNIXlike
!

systemSupportsVolumes

    ^ OperatingSystem supportsVolumes
! !

!AbstractFileBrowser methodsFor:'queries-file'!

allItemsOfCurrentDirectory
    self 
        applicationNamed:#DirectoryContentsBrowser 
        ifPresentDo:[:app | ^ app allItemsOfCurrentDirectory].

    ^ nil
!

anyFilesPresentWithSuffix:suffix
    self currentSelectedDirectories do:[:dir|
        [
            (dir directoryContentsAsFilenamesDo:[:fn | (fn suffix = suffix) ifTrue:[ ^ true]])
        ] on:FileStream openErrorSignal do:[:ex|].
    ].
    ^ false.
!

commonPrefixOfSelectedFiles
    |selFiles stringCol firstPre|

    selFiles := self currentSelectedObjects.
    selFiles isEmpty ifTrue:[^ nil].

    stringCol := selFiles collect:[:file | file asString].
    firstPre := stringCol at:1.
    stringCol from:2 do:[:el|
         firstPre := firstPre commonPrefixWith:el.
    ].
    ^ firstPre asFilename

    "Modified: / 04-12-2006 / 13:14:25 / cg"
!

compressTabsOnSave
    "if true, compress leading spaces (multiples of 8) with a tab character
     when saving.
     Default is true"

    ^ true
!

currentFilesAreInSameDirectory

    ^ self parentDirectoriesOfCurrentFiles size < 2
!

currentFilesHasDirectories

    ^ self currentSelectedDirectories notEmpty.
!

directoriesForFiles:aFileCol
     ^ aFileCol collect:[:file| self getDirWithoutFileName:file] as:Set.
!

fileListIsEmpty
    self 
        applicationNamed:#DirectoryContentsBrowser 
        ifPresentDo:[:appl | ^ appl fileListIsEmpty].

    ^ nil.
!

fileListIsNotEmpty

    ^ self fileListIsEmpty not.   
!

fileName:aFilename1 startsWith:aFilename2
    " check if aFilename2 is a prefix of aFilename1"

    | file1 file2 |

    (aFilename2 isNil or:[aFilename1 isNil]) ifTrue:[ ^ false].
    file1 := aFilename1 asFilename.
    file2 := aFilename2 asFilename.

    file2 isRootDirectory ifTrue:[ ^ true].

    ((file1 isDirectory) 
    and:[(file2 isDirectory)
    and:[file1 directory = file2 directory]]) ifTrue:[
        ^ file1 baseName = file2 baseName
    ].
    ^ (file1 pathName) startsWith:(file2 pathName)
!

getAllFilesAsStringCollection
    self 
        applicationNamed:#DirectoryContentsBrowser 
        ifPresentDo:[:appl | ^ appl getAllFilesAsStringCollection].

    ^ nil
!

getBestDirectory

    |selFiles stringCol firstPre|

    selFiles := self currentSelectedDirectories.
    selFiles isEmpty ifTrue:[^ nil].
    selFiles size == 1 ifTrue:[^ selFiles first].
    stringCol := (selFiles collect:[:file| file asString]) asOrderedCollection.
    firstPre := stringCol at:1.
    stringCol from:2 do:[:el|
         firstPre :=  firstPre commonPrefixWith:el.
    ].
    (firstPre endsWith:(OperatingSystem fileSeparator)) ifTrue:[
        firstPre removeLast.
    ].
    ^ firstPre asFilename
!

getDirWithoutFileName:aFileName

    | dir |
    aFileName isNil ifTrue:[
        ^ aFileName.    
    ].
    dir := aFileName asFilename.
    dir isDirectory ifFalse:[
        dir := dir directory.
    ].
    ^ dir.
!

getInfoItem
    "get filename of a description-file (.dir.info, README etc.);
     This file is automatically shown when a directory is entered.
     You can add more names below if you like."

    |dir|

    dir := self theSingleSelectedDirectoryOrNil.
    dir isNil ifTrue:[ ^ nil].

    #(
       '.dir.info'
       'README'
       'ReadMe'
       'Readme'
       'readme'
       'read.me'
       'Read.me'
       'READ.ME'
       'README.TXT'
       'README.txt'
       'readme.txt'
       'Readme.txt'
       'Info.txt'
       'info.txt'
       'INFO.TXT'
       'INFO.txt'
    ) do:[:f |
        |n|

        n := dir construct:f.
        (n isReadable and:[n isDirectory not]) ifTrue:[
            ^ DirectoryContentsBrowser itemClass fileName:n
        ]
    ].
    ^ nil
!

hasPackageDirectorySelected
    |dir|

    dir := self currentDirectory.
    ^  dir notNil
    and:[ dir exists
    and:[ (dir / 'abbrev.stc') exists ]]
!

parentDirectoriesOfCurrentFiles
    ^ self currentSelectedObjects 
        collect:[:file | file directory] as:Set

    "Modified: / 04-12-2006 / 13:15:21 / cg"
!

recursiveAnyFilesPresentWithSuffix:suffix
    ^ true. "/ the code below is too slow for a menu enabling operation

"/    |directories|
"/
"/    directories := self currentDirectories value.
"/    directories do:[:dir|
"/        [
"/            dir recursiveDirectoryContentsDo:[:f |
"/                (f asFilename suffix = suffix) ifTrue:[ ^ true]
"/            ]
"/        ] on:FileStream openErrorSignal do:[:ex|].
"/    ].
"/    ^ false.
!

recursiveAnySTFilesPresent
    ^ self recursiveAnyFilesPresentWithSuffix:'st'
! !

!AbstractFileBrowser methodsFor:'selection'!

currentSelectedDirectories
    ^ self currentDirectoriesValue.
!

currentSelectedFiles
    ^ self currentSelectedObjects reject:[:file | file isDirectory].

    "Modified: / 04-12-2006 / 13:14:39 / cg"
!

currentSelectedObjects
    ^ self currentFileNameHolder value 
!

firstSelectedFile
    ^ self currentSelectedObjects 
        detect:[:file | (file ? '') asFilename isDirectory not]
        ifNone:[].

    "Modified: / 04-12-2006 / 13:14:50 / cg"
!

hasOnlyDirectoriesSelected
    ^ self currentSelectedObjects conform:[:file | file isDirectory].

    "Created: / 20-05-2010 / 10:45:03 / cg"
!

hasOnlyFilesSelected

    ^ self currentSelectedObjects conform:[:file | file isDirectory not].

    "Modified: / 04-12-2006 / 13:15:01 / cg"
!

hasTwoDirectoriesSelected

    ^ self currentSelectedObjects size == 2 
        and:[self hasOnlyDirectoriesSelected]

    "Created: / 20-05-2010 / 10:45:18 / cg"
!

hasTwoFilesSelected

    ^ self currentSelectedObjects size == 2 
        and:[self hasOnlyFilesSelected]

    "Modified: / 04-12-2006 / 13:15:04 / cg"
!

selectNextFile
    self 
        applicationNamed:#DirectoryContentsBrowser 
        ifPresentDo:[:appl | appl ~~ self ifTrue:[ appl selectNextFile ]].
!

selectPreviousFile
    self 
        applicationNamed:#DirectoryContentsBrowser 
        ifPresentDo:[:appl | appl ~~ self ifTrue:[ appl selectPreviousFile ]].
! !

!AbstractFileBrowser methodsFor:'sorting'!

currentSortOrder
    ^ self aspectFor:#currentSortOrder ifAbsent:[ Dictionary new asValue ].
!

sortBlockHolder
    ^ self aspectFor:#sortBlockHolder ifAbsent:[
        (FileSorter directoriesBeforeFiles:(self sortDirectoriesBeforeFiles value and:[self viewDirsInContentsBrowser value]) 
                    selector:#fileName 
                    sortCaseless:self sortCaseless value 
                    sortReverse:false) asValue.
    ].
!

sortBlockProperty
    |v|
    
    v := self aspectFor:#sortBlockProperty ifAbsent:[ #baseName asValue ].
    v addDependent:self.
    ^ v.
!

sortCaseless
    " aspect for sort caseless "

    ^ self 
        aspectFor:#sortCaseless 
        ifAbsent:[ (Filename isCaseSensitive not) asValue ]
!

sortDirectoriesBeforeFiles

    " aspect for sort directories always before files"
    ^ self aspectFor:#sortDirectoriesBeforeFiles ifAbsent:[ true asValue ].
!

sortFileListsBy:instanceName 

    self sortFileListsBy:instanceName withReverse:true
!

sortFileListsBy:instanceName withReverse:aBoolean
    | aSymbol sortCaselessLocal currentSortOrder sorter isReverse|

    aSymbol := instanceName asSymbol.
    self sortBlockProperty setValue:instanceName asSymbol.
    sortCaselessLocal := self sortCaseless value.
    currentSortOrder := self currentSortOrder value.
    currentSortOrder isEmptyOrNil ifTrue:[
        self currentSortOrder value:(currentSortOrder := Dictionary new).
        currentSortOrder at:#column put:aSymbol.
        currentSortOrder at:#reverse put:false.
        currentSortOrder at:#sortCaseless put:sortCaselessLocal.
    ] ifFalse:[
        (currentSortOrder at:#sortCaseless) ~= sortCaselessLocal ifTrue:[
            "/ sort caseless changed
            currentSortOrder at:#sortCaseless put:sortCaselessLocal.
        ] ifFalse:[
            (currentSortOrder at:#column) = aSymbol ifTrue:[
                "/ same column like before - change sort order ifReverse is true
                aBoolean ifTrue:[
                    isReverse := currentSortOrder at:#reverse.
                    currentSortOrder at:#reverse put:(isReverse not).
                ].
            ] ifFalse:[
                "/ another column - remark column
                currentSortOrder at:#column put:aSymbol.
            ]
        ]
    ].
    self currentSortOrder changed.

    sorter := FileSorter directoriesBeforeFiles:(self sortDirectoriesBeforeFiles value and:[self viewDirsInContentsBrowser value]) 
                            selector:instanceName 
                            sortCaseless:sortCaselessLocal 
                            sortReverse:(currentSortOrder at:#reverse).
    self sortBlockHolder value:sorter.

    "Modified: / 18-09-2007 / 09:42:47 / cg"
! !

!AbstractFileBrowser methodsFor:'startup & release'!

initializeAspects
    aspects := IdentityDictionary new.
    aspects at:#applications put:(IdentityDictionary new).
!

makeDependent
    self filterModel addDependent:self.            
    self currentFileNameHolder addDependent:self.
    self sortDirectoriesBeforeFiles addDependent:self.
    self sortCaseless addDependent:self.
    self showHiddenFiles addDependent:self.
    self rootHolder addDependent:self.
!

masterApplication:anApplication

    masterApplication isNil ifTrue:[
        (anApplication notNil and:[anApplication askFor:#isAbstractFileBrowser]) ifTrue:[
            aspects := anApplication aspects
        ] ifFalse:[
            aspects isNil ifTrue:[
                self initializeAspects.
            ]
        ].
        self applications at:(self className) put:self.
"/        self makeDependent.
    ].
    ^ super masterApplication:anApplication.
!

postBuildWith:aBuilder
    self makeDependent.
    super postBuildWith:aBuilder.
!

postOpenWith:aBuilder

    super postOpenWith:aBuilder.
    "/ now done for all windowGroups by the group itself
    "/ self windowGroup showWaitCursorWhenBusyForMillis:100.

    "Modified: / 25-07-2006 / 09:12:45 / cg"
! !

!AbstractFileBrowser::Clipboard methodsFor:'accessing'!

files
    "return the value of the instance variable 'files' (automatically generated)"

    ^ files
!

files:something
    "set the value of the instance variable 'files' (automatically generated)"

    files := something.
!

method
    "return the value of the instance variable 'method' (automatically generated)"

    ^ method
!

method:something
    "set the value of the instance variable 'method' (automatically generated)"

    method := something.
! !

!AbstractFileBrowser::CodeExecutionLock methodsFor:'accessing'!

locked
    "return the value of the instance variable 'locked' (automatically generated)"

    locked isNil ifTrue:[
        locked := false.
    ].
    ^ locked
! !

!AbstractFileBrowser::CodeExecutionLock methodsFor:'actions'!

doIfUnLocked:aBlock

    self locked ifFalse:[
        aBlock value.
    ].
!

doLocked:aBlock

    locked  := true.
    aBlock ensure:[
        locked := false.
    ]
! !

!AbstractFileBrowser::DirectoryHistory class methodsFor:'defaults'!

defaultHistorySize
    ^ 50
! !

!AbstractFileBrowser::DirectoryHistory class methodsFor:'instance creation'!

new
    ^ (super new) initializeHistory.
! !

!AbstractFileBrowser::DirectoryHistory methodsFor:'accessing'!

historySize
    historySize isNil ifTrue:[^ self class defaultHistorySize].
    ^ historySize
!

historySize:aNumber
    historySize := aNumber
! !

!AbstractFileBrowser::DirectoryHistory methodsFor:'actions'!

addToHistory:aPath
    | item pathToAdd sep|

    pathToAdd := aPath.
    (pathToAdd endsWith:(sep := Filename separator)) ifTrue:[
        pathToAdd asFilename isRootDirectory ifFalse:[
            pathToAdd := pathToAdd copyButLast:(sep asString size).    
        ]    
    ].

    item := self getItemFor:pathToAdd.
    self backForwardListAdd:pathToAdd.
    item isNil ifTrue:[
        " not already in history"
        self size >= self historySize ifTrue:[
            self removeLast.
        ].
        item := DirectoryHistoryItem path:pathToAdd.
    ] ifFalse:[
        "already been there before; move the entry to
         the beginning, so it will fall out later."
        self remove:item.
    ].
    self addFirst:item

    "Modified: / 24-07-2011 / 07:12:54 / cg"
!

backForwardListAdd:aPath
    |pathIndex|

    pathIndex := backForwardList indexOf:aPath.
    pathIndex == 0 ifTrue:[
        " a new path comes in remove forward paths "
        (backForwardList size) > backForwardIndex ifTrue:[
            backForwardList removeFromIndex:(backForwardIndex + 1) toIndex:(backForwardList size).    
        ].
    ] ifFalse:[
        backForwardList remove:aPath.
        pathIndex <= backForwardIndex ifTrue:[
            backForwardIndex := backForwardIndex - 1.
        ]
    ].
    backForwardList add:aPath afterIndex:backForwardIndex.
    backForwardIndex := backForwardIndex + 1.
    backForwardIndex > self historySize ifTrue:[
        backForwardList removeFirst.
        backForwardIndex := backForwardIndex - 1.
    ].
!

goBackward
    "return the first path of the backward list;
     remove it from the back list and add it ti the forward list."

    |retPath|

    self canBackward ifTrue:[
        retPath := backForwardList at:(backForwardIndex - 1).
        backForwardIndex := backForwardIndex - 1.
    ].
    ^ retPath.
!

goForward
    "return the first path of the forward list;
     remove it from the list."

    |retPath|

    self canForward ifTrue:[
        retPath := backForwardList at:backForwardIndex + 1.
        backForwardIndex := backForwardIndex + 1.
    ].
    ^ retPath.
!

resetForwardBackward

    self initialize
!

setPosition:aPosition for:aPath

    self do:[:item| 
        item path = aPath ifTrue:[
            item position:aPosition.
        ]
    ].
! !

!AbstractFileBrowser::DirectoryHistory methodsFor:'initialization'!

initializeHistory

    backForwardList := OrderedCollection new.
    self reverseDo:[:el|
        backForwardList add:el path.
    ].
    backForwardIndex := backForwardList size.
! !

!AbstractFileBrowser::DirectoryHistory methodsFor:'queries'!

canBackward

    ^ backForwardIndex > 1 
!

canForward

    ^ (backForwardList size >= (backForwardIndex + 1))
!

getBackCollection

    | backCol |

    backCol := OrderedCollection new.
    self canBackward ifTrue:[
        | tmpCol |
        tmpCol := backForwardList copyTo:backForwardIndex - 1.
        tmpCol reverseDo:[ :el|
            backCol add:el.
        ]
    ].
    ^ backCol
!

getForwardCollection

    | forwCol |

    forwCol := OrderedCollection new.
    self canForward ifTrue:[
        forwCol := backForwardList copyFrom:(backForwardIndex + 1)    
    ].
    ^ forwCol
!

getItemFor:aPath
    ^ self detect:[:item| item path = aPath] ifNone:nil.
"/    self do:[:item| item path = aPath ifTrue:[^ item]].
"/    ^ nil.
!

getPositionFor:aPath

    |item|

    item := self getItemFor:aPath.

    item notNil ifTrue:[
        ^ item position.
    ].
    ^ nil
!

includesPath:aPath
    ^ self contains:[:item | item path = aPath].

"/    self do:[:item| item path = aPath ifTrue:[^ true]].
"/    ^ false.
!

nextBackwardItem
    "return the first path of the backward list"

    |retPath|

    self canBackward ifTrue:[
        retPath := backForwardList at:backForwardIndex.
    ].
    ^ retPath.
!

nextForwardItem
    "return the first path of the forward list"

    |retPath|

    self canForward ifTrue:[
        retPath := backForwardList at:backForwardIndex + 1.
    ].
    ^ retPath.
! !

!AbstractFileBrowser::DirectoryHistory::DirectoryHistoryItem class methodsFor:'instance creation'!

path:aPath

    ^ self new path:aPath
! !

!AbstractFileBrowser::DirectoryHistory::DirectoryHistoryItem methodsFor:'accessing'!

asFilename
    ^ path asFilename
!

path
    "return the value of the instance variable 'path' (automatically generated)"

    ^ path
!

path:something
    "set the value of the instance variable 'path' (automatically generated)"

    path := something.
!

position
    "return the value of the instance variable 'position' (automatically generated)"

    ^ position
!

position:something
    "set the value of the instance variable 'position' (automatically generated)"

    position := something.
!

printString

    ^ self path asString
! !

!AbstractFileBrowser::SaveAspectItem class methodsFor:'instance creation'!

withValue:aValue isHolder:aBoolean

    | instance |

    instance := self basicNew.
    instance value:aValue.
    instance isHolder:aBoolean.
    ^ instance
! !

!AbstractFileBrowser::SaveAspectItem methodsFor:'accessing'!

isHolder
    "return the value of the instance variable 'isHolder' (automatically generated)"

    ^ isHolder
!

isHolder:something
    "set the value of the instance variable 'isHolder' (automatically generated)"

    isHolder := something.
!

value
    "return the value of the instance variable 'value' (automatically generated)"

    ^ value
!

value:something
    "set the value of the instance variable 'value' (automatically generated)"

    value := something.
! !

!AbstractFileBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

