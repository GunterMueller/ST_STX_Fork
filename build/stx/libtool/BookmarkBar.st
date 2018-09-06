"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

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

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#BookmarkBar
	instanceVariableNames:'bookmarkHolder bookmarksHolder menuHolder
		bookmarkButtonIconHolder hasBookmarkHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Bookmarks'
!

!BookmarkBar class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

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

!BookmarkBar class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:BookmarkBar    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#starButton
'Click for bookmark menu'

)

    "Created: / 03-07-2011 / 23:09:48 / cg"
! !

!BookmarkBar class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BookmarkBar andSelector:#windowSpec
     BookmarkBar new openInterface:#windowSpec
     BookmarkBar open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Bookmark bar'
          name: 'Bookmark bar'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 600 25)
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'Bookmarks'
              layout: (LayoutFrame 0 0 0 0 -40 1 0 1)
              level: 0
              menu: menuHolder
              textDefault: true
            )
           (ActionButtonSpec
              name: 'BookmarkButton'
              layout: (LayoutFrame -25 1 1 0 0 1 22 0)
              activeHelpKey: starButton
              level: 0
              hasCharacterOrientedLabel: false
              labelChannel: bookmarkButtonIconHolder
              model: bookmarkMenu
              postBuildCallback: postBuiltStarButton:
            )
           (ActionButtonSpec
              label: 'OK'
              name: 'menu'
              layout: (LayoutFrame -13 1 0 0 -3 1 0 1)
              initiallyInvisible: true
              hasCharacterOrientedLabel: false
              translateLabel: true
              labelChannel: menuButtonIcon
              model: bookmarkMenu
            )
           )
         
        )
      )
! !

!BookmarkBar class methodsFor:'menu specs'!

bookmarkMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:BookmarkBar andSelector:#bookmarkMenu
     (Menu new fromLiteralArrayEncoding:(BookmarkBar bookmarkMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Add'
            translateLabel: true
            submenuChannel: bookmarkMenuAddSlice
            isMenuSlice: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Bookmark Editor'
            itemValue: menuOpenBookmarkEditor
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!BookmarkBar class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #bookmarkHolder
        #bookmarksHolder
      ).

! !

!BookmarkBar methodsFor:'actions'!

bookmark
    <resource: #uiCallback>

    self menuAddBookmark

    "Modified: / 02-06-2011 / 21:39:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmarkMenu
    <resource: #uiCallback>
    |menu|

    menu := self class bookmarkMenu decodeAsLiteralArray.
    menu findGuiResourcesIn:self.
    menu startUp

    "Modified: / 02-06-2011 / 20:05:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkBar methodsFor:'aspects'!

bookmarkButtonIconHolder
    <resource: #uiAspect>

    bookmarkButtonIconHolder isNil ifTrue:[
        bookmarkButtonIconHolder := ToolbarIconLibrary bookmarks14x14 asValue.
    ].
    ^ bookmarkButtonIconHolder.

    "Modified: / 18-05-2011 / 18:22:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-12-2011 / 15:47:13 / cg"
!

bookmarkHolder
    "return/create the 'bookmarkHolder' value holder (automatically generated)"

    bookmarkHolder isNil ifTrue:[
        bookmarkHolder := ValueHolder new.
        bookmarkHolder addDependent:self.
    ].
    ^ bookmarkHolder
!

bookmarkHolder:something
    "set the 'bookmarkHolder' value holder (automatically generated)"

    |oldValue newValue|

    bookmarkHolder notNil ifTrue:[
        oldValue := bookmarkHolder value.
        bookmarkHolder removeDependent:self.
    ].
    bookmarkHolder := something.
    bookmarkHolder notNil ifTrue:[
        bookmarkHolder addDependent:self.
    ].
    newValue := bookmarkHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:bookmarkHolder.
    ].
!

bookmarksHolder
    "return/create the 'bookmarksHolder' value holder (automatically generated)"

    bookmarksHolder isNil ifTrue:[
        bookmarksHolder := ValueHolder new.
        bookmarksHolder addDependent:self.
    ].
    ^ bookmarksHolder
!

bookmarksHolder:something
    "set the 'bookmarksHolder' value holder (automatically generated)"

    |oldValue newValue|

    bookmarksHolder notNil ifTrue:[
        oldValue := bookmarksHolder value.
        bookmarksHolder removeDependent:self.
    ].
    bookmarksHolder := something.
    bookmarksHolder notNil ifTrue:[
        bookmarksHolder addDependent:self.
    ].
    newValue := bookmarksHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:bookmarksHolder.
    ].
!

hasBookmarkHolder
    "return/create the 'bookmarkHolder' value holder (automatically generated)"

    hasBookmarkHolder isNil ifTrue:[
        hasBookmarkHolder := (AspectAdaptor forAspect:#notNil)
                                subjectChannel: (self bookmarkHolder)
    ].
    ^ hasBookmarkHolder

    "Created: / 08-06-2011 / 12:39:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuButtonIcon
    <resource: #uiAspect>

    ^ToolbarIconLibrary sortIndicatorIcon

    "Created: / 02-06-2011 / 19:55:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuHolder
    "return/create the 'menuHolder' value holder (automatically generated)"

    menuHolder isNil ifTrue:[
        menuHolder := ValueHolder new.
    ].
    ^ menuHolder

    "Modified: / 18-05-2011 / 18:57:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkBar methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == bookmarksHolder ifTrue:[
        self updateMenu.
        ^ self.
    ].

    changedObject == bookmarkHolder ifTrue:[
        self updateBookmarkButton.
        ^ self.
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 02-06-2011 / 22:47:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateBookmarkButton

    "Created: / 02-06-2011 / 22:47:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateMenu

    | menu item |

    self window isVisible ifFalse:[^self].
    menu := self bookmarksHolder value asMenu.
    menu hasItems ifFalse:[
        item := MenuItem 
                    label: ('No bookmarks yet, click here or on star to add one' withColor: Color gray)
                    itemValue: #bookmarkMenu
                    enabled: self hasBookmarkHolder.
        item isButton: true.
        menu addItem: item.
    ].
    

    menu findGuiResourcesIn:self.
    menuHolder value: menu.

    "Created: / 18-05-2011 / 18:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-06-2011 / 12:40:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-09-2012 / 13:07:51 / cg"
! !

!BookmarkBar methodsFor:'hooks'!

closeDownViews
    self release.
    super closeDownViews

    "Created: / 15-03-2012 / 13:26:54 / Jan Vrany <jan.vrany.fit.cvut.cz>"
!

commonPostOpen
    |bh|

    super commonPostOpen.
    bh := self bookmarksHolder.
    bh value isNil ifTrue:[
        bh value: BookmarkList forSystemBrowser
    ].
    self updateMenu.

    "Created: / 18-05-2011 / 18:58:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 19:51:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:31:54 / cg"
!

postBuiltStarButton:aButton
    aButton enterLevel:1.
    aButton leaveLevel:0.

    "Created: / 03-07-2011 / 23:08:01 / cg"
! !

!BookmarkBar methodsFor:'initialization & release'!

release

    bookmarksHolder notNil ifTrue:[
        bookmarksHolder removeDependent: self.
    ].
    super release

    "Created: / 15-03-2012 / 13:30:56 / Jan Vrany <jan.vrany.fit.cvut.cz>"
!

releaseAsSubCanvas
    self release.
    super releaseAsSubCanvas

    "Created: / 15-03-2012 / 13:28:48 / Jan Vrany <jan.vrany.fit.cvut.cz>"
! !

!BookmarkBar methodsFor:'menu'!

bookmarkMenuAddSlice
    ^ BookmarkAddMenuBuilder new buildMenuFor:self bookmarksHolder value

    "Created: / 02-06-2011 / 21:54:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-07-2011 / 11:38:29 / cg"
! !

!BookmarkBar methodsFor:'menu actions'!

menuAddBookmark

    self menuAddBookmarkTo: self bookmarksHolder value root.

    "Created: / 02-06-2011 / 21:36:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuAddBookmarkTo: folder
    | bookmark |

    bookmark := self bookmarkHolder value.
    bookmark isNil ifTrue:[^self].
    folder add: bookmark.
    self bookmarksHolder value save.

    "Created: / 02-06-2011 / 22:17:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:32:07 / cg"
!

menuOpenBookmarkEditor

    BookmarkListEditor new
        bookmarkList: self bookmarksHolder value;
        open.

    "Modified: / 02-06-2011 / 20:02:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkBar class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

