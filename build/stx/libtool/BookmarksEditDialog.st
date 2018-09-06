"
 COPYRIGHT (c) 2008 by eXept Software AG
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

SimpleDialog subclass:#BookmarksEditDialog
	instanceVariableNames:'selectedBookmarksHolder bookmarkListHolder defaultBookmark answer'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!BookmarksEditDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!BookmarksEditDialog class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#moveUp
'Move the selected bookmark up in the list'

#moveDown
'Move the selected bookmark down in the list'

#exportBookmarks
'Export bookmarks to a file'

#importBookmarks
'Import bookmarks from a file'

#newBookmark
'Add a new bookmark'

#removeBookmark
'Remove the selected bookmark'

#sortBookmarks
'Sort bookmarks alphabetically'

).
! !

!BookmarksEditDialog class methodsFor:'image specs'!

fileIn22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileIn22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileIn22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'BookmarksEditDialog class fileIn22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
GQ4]GQ4]GQ4]GQ4]GQ4]GP@@@@@@@A4]GQ4]GQ4]GQ4]GQ4]GQ4@@@@@@@@]GQ4]GQ4]GQ4]GQ4]GQ4]@@@@@@@@GQ4]GQ4]GQ4]GQ4]EATUEQTUEQTU@A4]
GQ4]GQ4]GQ4]EAT&I0PQGQ4]EP@]GQ4]GQ4]GQ4]EA8UI HKBQ4]GQT@GQ4]GQ4]GQ4]EAPTEBXFDP$]GQ4U@A4]GQ4]GQ4@GQP!!JQ<&AQDOGQ4]EP@]GQ4]
GQ4@@A4TE2$)F1$ID14]GQT@GQ4]GR$)JR$)JR$)JR$"BQ4]GQ4U@A4]GQ4)JR$)JR$)JR$)JPPQD14]EP@]GP@@JR$)JR$)JR$)JR$)F@<SGQT@GQ4@GR$)
JR$)JR$)JR$)F1(QGQ4U@A4]@@@)JR$)JR$)JR$)I XEC@<]EQ4]GQ4]GQ4@@A4T@R$)C"XFARH@GQT]GQ4]GQ4]@@@]E@D)J@8[F T"AA4UGQ4]GQ4]GQ4]
GQPAB!!<N@ XZFRH]EQ4]GQ4]GQ4]GQ4T@P((C"XFARH"BQT]GQ4]GQ4]GQ4]EAPTEAPTEAPTEAPT@A4]GQ4]GQ4]GQ4]GQ4]GQ4@@@@@@@@]GQ4]GQ4]GQ4]
GQ4]GQ4]@@@@@@@@GQ4]GQ4]GQ4]@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240 248 0 0]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@?8@A?8@C?8@G?8@G?8@G?8C??8C??8C??8C??8C??8@G?8@G?8@G?8@G?8@G?8@@@@@@@@@@@@') ; yourself); yourself]
!

fileOut22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self fileOut22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#fileOut22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'BookmarksEditDialog class fileOut22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
GQ4]GQ4]GQ4]GQ4]GQ4]GP@@@@@@@A4]GQ4]GQ4]GQ4]GQ4]GQ4@@@@@@@@]GQ4]GQ4]GQ4]GQ4]GQ4]@@@@@@@@GQ4]GQ4]GQ4]GQ4]EATUEQTUEQTU@A4]
GQ4]GQ4]GQ4]EAT&I0PQGQ4]EP@]GQ4]GQ4]GQ4]EA8UI HKBQ4]GQT@GQ4]GQ4]GQ4]EAPTEBXFDP$]GQ4U@A4]GQ4]GQ4@GQP!!JQ<&AQDOGQ4]EP@]GQ4]
GQ4@@A4TE2$)F1$ID14]GQT@GQ4]GR$)JR$)JR$)JR$"BQ4]GQ4U@A4]GQ4)JR$)JR$)JR$)JPPQD14]EP@]GP@@JR$)JR$)JR$)JR$)F@<SGQT@GQ4@GR$)
JR$)JR$)JR$)F1(QGQ4U@A4]@@@)JR$)JR$)JR$)I XEC@<]EQ4]GQ4]GQ4@@A4T@R$)C"XFARH@GQT]GQ4]GQ4]@@@]E@D)J@8[F T"AA4UGQ4]GQ4]GQ4]
GQPAB!!<N@ XZFRH]EQ4]GQ4]GQ4]GQ4T@P((C"XFARH"BQT]GQ4]GQ4]GQ4]EAPTEAPTEAPTEAPT@A4]GQ4]GQ4]GQ4]GQ4]GQ4@@@@@@@@]GQ4]GQ4]GQ4]
GQ4]GQ4]@@@@@@@@GQ4]GQ4]GQ4]@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240 248 0 0]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@?8@A?8@C?8@G?8@G?8@G?8C??8C??8C??8C??8C??8@G?8@G?8@G?8@G?8@G?8@@@@@@@@@@@@') ; yourself); yourself]
!

icon

    ^ ToolbarIconLibrary directoryBookmarksIcon
!

sort22x22Icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self sort22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#sort22x22Icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'BookmarksEditDialog class sort22x22Icon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
GQ4]GQ4]GQ4]GQ4]GQ4]GP@@@@@@@A4]GQ4]GQ4]GQ4]GQ4]GQ4@@@@@@@@]GQ4*J"(*GQ4TEQTUEQTUEQTUEQT@GQ4*GQ4]J!!4]EATUEQTUEQTUEQTU@A4]
J!!4]GR(]GQP&I"X&I0PQGQ4]EP@]GR(]GQ4*GQ4TI"(*I HKBQ4]GQT@GQ4]J"(*J"(]EBX&I"XFDP$]GQ4U@A4]GQ4]GP@@GQPAJ"(*AQDOGQ4]EP@]GQ4]
J @@@@@T@PTEF1$ID14]GQT@GQ4]GR()JR$)E@D*J"(*BQ4]GQ4U@A4]@@@*JR$)JQPAAPTEAPPQD14]EP@]GP@]J"$)JR$T@R(*J"(*F@<SGQT@GQ4*J"(*
J"$)E@DEAPTEF1(QGQ4UGQ4]GR(*J @@GQPAJ"(*J"(*C@<]EQ4]GQ4]J!!4@@A4T@PTEC"XFARH@GQT]GQ4]GQ4]GQ4]E@D*J"(*J"(*AA4UGQ4]J"(*J"(]
GQPAB!!<N@ XZFRH]EQ4]GQ4]GR(@GQ4T@R(*J"(*J"(*GQT@GQ4]GR(@GQ4]E@DJJ@8&A T"H $U@A4]@B(]GQ4]GQPTEAPTEAPTEAPTE@@]GR(*J"(*GQ4]
GQ4]GQ4]@@@@@@@@GQ4@@@@@@@@]@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[250 250 255 225 225 237 236 236 244 213 213 228 245 245 252 241 241 248 239 239 246 216 216 230 210 210 224 252 252 255 229 229 239 248 248 254 244 244 250 219 219 232 234 234 243 253 253 255 232 232 241 249 249 254 224 224 236 254 254 255 156 156 182 208 208 223 206 206 221 204 204 219 246 246 253 242 242 249 240 240 247 238 238 245 215 215 229 255 255 255 211 211 225 230 230 240 228 228 238 201 201 218 243 243 249 222 222 235 220 220 233 218 218 231 235 235 244 233 233 242 231 231 240 248 0 0 0 0 0]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@G @@H''?8H''?8H''?8G7?8@G?8BG?8BG?8BG?8BG?8O''?8GG?8BG?8@G?8O''?8AG?8BG?8DG?8O @@@@@@') ; yourself); yourself]
! !

!BookmarksEditDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BookmarksDialog andSelector:#windowSpec
     BookmarksDialog new openInterface:#windowSpec
     BookmarksDialog open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Edit Bookmarks'
          name: 'Edit Bookmarks'
          min: (Point 0 0)
          bounds: (Rectangle 0 0 450 296)
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'ToolBar'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              menu: toolBarMenu
              textDefault: true
            )
           (SequenceViewSpec
              name: 'BookmarkList'
              layout: (LayoutFrame 0 0 30 0 0 1 -30 1)
              model: selectedBookmarksHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              isMultiSelect: true
              useIndex: false
              sequenceList: bookmarkListHolder
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
              horizontalLayout: center
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button1'
                    translateLabel: true
                    model: doAccept
                    extent: (Point 125 22)
                  )
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button2'
                    translateLabel: true
                    model: doCancel
                    extent: (Point 125 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!BookmarksEditDialog class methodsFor:'menu specs'!

toolBarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:BookmarksEditDialog andSelector:#toolBarMenu
     (Menu new fromLiteralArrayEncoding:(BookmarksEditDialog toolBarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            activeHelpKey: newBookmark
            label: 'New...'
            itemValue: new
            isButton: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary newBookmark22x22Icon)
          )
         (MenuItem
            activeHelpKey: removeBookmark
            enabled: removeButtonEnabledHolder
            label: 'Remove...'
            itemValue: remove
            isButton: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary close22x22Icon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: moveUp
            enabled: upButtonEnabledHolder
            label: 'Up'
            itemValue: up
            isButton: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary up22x22Icon)
          )
         (MenuItem
            activeHelpKey: moveDown
            enabled: downButtonEnabledHolder
            label: 'Down'
            itemValue: down
            isButton: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary down22x22Icon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: sortBookmarks
            enabled: sortButtonEnabledHolder
            label: 'Sort'
            itemValue: sort
            isButton: true
            labelImage: (ResourceRetriever BookmarksEditDialog sort22x22Icon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: importBookmarks
            label: 'Import...'
            itemValue: import
            isButton: true
            labelImage: (ResourceRetriever XPToolbarIconLibrary fileIn22x22Icon)
          )
         (MenuItem
            activeHelpKey: exportBookmarks
            label: 'Export...'
            itemValue: export
            isButton: true
            labelImage: (ResourceRetriever BookmarksEditDialog fileOut22x22Icon)
          )
         )
        nil
        nil
      )
! !

!BookmarksEditDialog class methodsFor:'opening'!

openWith: bookmarks

    ^ self openWith: bookmarks defaultBookmark: ''
!

openWith:bookmarks defaultBookmark:aFilename
    | dialog bookmarkStrings |

    dialog := self new.

    dialog allButOpenInterface:#windowSpec.

    aFilename notNil ifTrue:[dialog defaultBookmark: aFilename asString].
    bookmarkStrings := bookmarks collect:[:each | each asString].
    dialog bookmarkList: bookmarkStrings.
    dialog openWindow.
    ^ dialog answer

    "
     Dialog aboutToOpenBoxNotificationSignal handle:[:ex |
        self halt.
        ex proceed
     ] do:[
        self openWith:#() defaultBookmark:nil
     ].
    "
! !

!BookmarksEditDialog methodsFor:'accessing'!

answer
    ^ answer
!

bookmarkList

    ^ self bookmarkListHolder.
!

bookmarkList: bookmarkStrings

    self bookmarkList contents: bookmarkStrings.
    self sortButtonEnabledHolder value:(bookmarkStrings size > 0).
!

defaultBookmark
    ^ defaultBookmark
!

defaultBookmark:something
    defaultBookmark := something.
!

indexForNewBookmark

    | index |
    index := self selectedBookmarkIndex.
    index = 0 ifTrue:[^ self bookmarkList size].
    ^ index
!

indexOfBookmark: aString

    ^ self bookmarkList indexOf: aString
!

selectBookmark: bookmark

    self selectedBookmarks: (Array with: bookmark).
!

selectedBookmarkIndex

    | someBookmarks |

    someBookmarks := self selectedBookmarks.
    someBookmarks size = 1 ifTrue:[
        ^ self indexOfBookmark: someBookmarks first
    ].
    ^ 0
!

selectedBookmarks

    ^ self selectedBookmarksHolder value
!

selectedBookmarks: aCollection

    ^ self selectedBookmarksHolder value: aCollection
! !

!BookmarksEditDialog methodsFor:'aspects'!

bookmarkListHolder
    <resource: #uiAspect>

    bookmarkListHolder isNil ifTrue:[
        bookmarkListHolder := List new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       bookmarkListHolder addDependent:self.
"/        bookmarkListHolder onChangeSend:#bookmarkListChanged to:self.
    ].
    ^ bookmarkListHolder.
!

downButtonEnabledHolder

    ^ builder valueAspectFor:#'downButtonEnabledHolder' initialValue:false
!

removeButtonEnabledHolder

    ^ builder valueAspectFor:#'removeButtonEnabledHolder' initialValue:false
!

selectedBookmarksHolder
    <resource: #uiAspect>

    selectedBookmarksHolder isNil ifTrue:[
        selectedBookmarksHolder := #() asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       selectedBookmarksHolder addDependent:self.
       selectedBookmarksHolder onChangeSend:#selectedBookmarksChanged to:self.
    ].
    ^ selectedBookmarksHolder.
!

sortButtonEnabledHolder

    ^ builder valueAspectFor:#'sortButtonEnabledHolder' initialValue:false
!

upButtonEnabledHolder

    ^ builder valueAspectFor:#'upButtonEnabledHolder' initialValue:false
! !

!BookmarksEditDialog methodsFor:'initialization'!

initialize

    defaultBookmark := ''.
    ^ super initialize.
! !

!BookmarksEditDialog methodsFor:'menu actions'!

down

    | someBookmarks bookmarkToMove index |

    someBookmarks := self selectedBookmarks.
    someBookmarks size = 1 ifFalse:[^ self].
    bookmarkToMove := someBookmarks first.
    index := self indexOfBookmark: bookmarkToMove.
    index = self bookmarkList size ifTrue:[^self].
    self bookmarkList remove: bookmarkToMove.
    self bookmarkList add: bookmarkToMove afterIndex: index.
    self selectBookmark: bookmarkToMove.
!

export

    | filename bookmarks |

    filename := Dialog 
        requestFileNameForSave:(resources string:'Select file to export bookmarks:') 
        default:'.fileBrowserBookmarks'
        fromDirectory:Filename desktopDirectory. 
    filename isEmptyOrNil ifTrue:[^ self].

    bookmarks := self bookmarkList.
    AbstractFileBrowser saveBookmarks: bookmarks in:filename.

    "Modified: / 27-10-2010 / 11:29:02 / cg"
!

import
    | answer filename bookmarksFromFile bookmarksToAdd bookmarks|

    answer := Dialog 
        requestFileName:(resources string:'Select file to import bookmarks:') 
        default:'.fileBrowserBookmarks'
        fromDirectory:Filename desktopDirectory.

    answer isEmptyOrNil ifTrue:[^ self].
    filename := answer asFilename.
    (filename isDirectory or:[filename exists not]) ifTrue:[^ self].
    bookmarksFromFile := AbstractFileBrowser bookmarksFrom: filename.

    bookmarks := self bookmarkList.
    bookmarksToAdd := bookmarksFromFile reject:[:each | bookmarks includes: each].
    bookmarks addAll: bookmarksToAdd.

    self sortButtonEnabledHolder value:(bookmarks size > 0).
!

new

    | someBookmarks default index bookmark|

    someBookmarks := self selectedBookmarks.

    default := someBookmarks isEmpty 
        ifTrue:[defaultBookmark]
        ifFalse:[someBookmarks first].

    bookmark := Dialog request:'New Bookmark' title:'Enter a directory' initialAnswer:default.
    bookmark isEmptyOrNil ifTrue:[^ self].
    (self bookmarkList includes: bookmark) ifTrue:[^ self].

    index := self indexForNewBookmark.
    self bookmarkList add: bookmark afterIndex: index.
    self selectBookmark: bookmark.
!

remove

    | someBookmarks message ans |

    someBookmarks := self selectedBookmarks.
    someBookmarks isEmpty ifTrue:[^ self].

    message := 'Really remove bookmarks: ', String lf.
    someBookmarks do:[:each | message := message, String lf, (String new: 5) , each].
    ans := Dialog confirm: message.
    ans ifFalse:[^ self].

    self bookmarkList removeAll: someBookmarks.
!

sort
    self bookmarkList sort.
!

up

    | someBookmarks bookmarkToMove index |

    someBookmarks := self selectedBookmarks.
    someBookmarks size = 1 ifFalse:[^ self].
    bookmarkToMove := someBookmarks first.
    index := self indexOfBookmark: bookmarkToMove.
    index = 1 ifTrue:[^self].
    self bookmarkList remove: bookmarkToMove.
    self bookmarkList add: bookmarkToMove beforeIndex: index - 1.
    self selectBookmark: bookmarkToMove.
! !

!BookmarksEditDialog methodsFor:'queries'!

hasChanges

    |oldDirectoryBookmarks|

    oldDirectoryBookmarks := AbstractFileBrowser directoryBookmarks collect:[:each | each asString].
    ^ self bookmarkList asOrderedCollection ~= oldDirectoryBookmarks
! !

!BookmarksEditDialog methodsFor:'user actions'!

doAccept

    | filenames |

    filenames := self bookmarkList collect:[:each | each asFilename].
    answer := filenames.
    ^ super doAccept
!

doCancel
    | ans |

    self hasChanges ifTrue:[
        ans := Dialog confirm:(resources string:'Really forget all changes?').
        ans ifFalse:[^ self].
    ].
    ^ super doCancel

    "Modified: / 13-01-2011 / 12:59:20 / cg"
!

selectedBookmarksChanged
    | someBookmarks selectedBookmarkIndex |

    someBookmarks := self selectedBookmarks.

    self upButtonEnabledHolder value: false.
    self downButtonEnabledHolder value: false.
    self removeButtonEnabledHolder value: false.

    someBookmarks isEmpty ifTrue:[^ self].

    someBookmarks size = 1 ifTrue:[
        selectedBookmarkIndex := self selectedBookmarkIndex.
        selectedBookmarkIndex = 1 ifFalse:[
            self upButtonEnabledHolder value: true.
        ].
        selectedBookmarkIndex = self bookmarkList size ifFalse:[
            self downButtonEnabledHolder value: true.
        ].
    ] ifFalse:[
        self upButtonEnabledHolder value: false.
        self downButtonEnabledHolder value: false.
    ].
    self removeButtonEnabledHolder value: true.
! !

!BookmarksEditDialog class methodsFor:'documentation'!

version
    ^ '$Id: BookmarksEditDialog.st 7854 2012-01-30 17:49:41Z vranyj1 $'
!

version_CVS
    ^ 'Header: /cvs/stx/stx/libtool/BookmarksEditDialog.st,v 1.10 2011/01/17 12:06:37 cg Exp '
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: BookmarksEditDialog.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

