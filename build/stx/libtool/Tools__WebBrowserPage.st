"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
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

ApplicationModel subclass:#WebBrowserPage
	instanceVariableNames:'history webKitView urlHolder titleHolder linkHolder
		bookmarkHolder toolBarVisibleHolder bookmarkBarVisibleHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Web'
!

!WebBrowserPage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
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

!WebBrowserPage class methodsFor:'image specs'!

hideToolBarIcon

    <resource: #image>

    ^ToolbarIconLibrary hideToolbarIcon

    "Created: / 08-06-2011 / 12:09:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WebBrowserPage class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::WebBrowserPage andSelector:#contentSpec
     Tools::WebBrowserPage new openInterface:#contentSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: contentSpec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (NonScrollableArbitraryComponentSpec
              name: 'Content'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              component: webKitView
            )
           )
         
        )
      )
!

toolBarSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::WebBrowserPage andSelector:#toolBarSpec
     Tools::WebBrowserPage new openInterface:#toolBarSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: toolBarSpec
        window: 
       (WindowSpec
          label: 'Tool Bar'
          name: 'Tool Bar'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 30)
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'ToolBarMenu'
              layout: (LayoutFrame 0 0.0 0 0.0 100 0.0 0 1.0)
              level: 0
              menu: toolBarMenu
              textDefault: true
            )
           (ViewSpec
              name: 'URLPanel'
              layout: (LayoutFrame 100 0.0 0 0 0 1 0 1)
              level: 0
              component: 
             (SpecCollection
                collection: (
                 (InputFieldSpec
                    name: 'URLFIeld'
                    layout: (LayoutFrame 2 0 5 0 -2 1 -3 1)
                    model: urlHolder
                    acceptOnLeave: false
                    acceptOnReturn: true
                    acceptOnTab: false
                    acceptOnPointerLeave: false
                    acceptIfUnchanged: true
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::WebBrowserPage andSelector:#windowSpec
     Tools::WebBrowserPage new openInterface:#windowSpec
     Tools::WebBrowserPage open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Web Browser Page'
          name: 'Web Browser Page'
          labelChannel: titleHolder
          min: (Point 10 10)
          bounds: (Rectangle 0 0 707 516)
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: 'ToolBar'
              layout: (LayoutFrame 0 0 0 0 0 1 40 0)
              level: 0
              visibilityChannel: toolBarVisibleHolder
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'hideToolBarIcon'
                    name: 'HideToolBarButton'
                    layout: (LayoutFrame 0 0 0 0 13 0 0 1)
                    activeHelpKey: hideToolBar
                    level: 0
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: hideToolbar
                  )
                 (UISubSpecification
                    name: 'ToolBarSpec'
                    layout: (LayoutFrame 13 0 0 0 0 1 0 1)
                    minorKey: toolBarSpec
                  )
                 )
               
              )
            )
           (ViewSpec
              name: 'BookmarkBar'
              layout: (LayoutFrame 0 0 40 0 0 1 66 0)
              visibilityChannel: bookmarkBarVisibleHolder
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'hideToolBarIcon'
                    name: 'Button1'
                    layout: (LayoutFrame 0 0 0 0 13 0 0 1)
                    activeHelpKey: hideToolBar
                    level: 0
                    hasCharacterOrientedLabel: false
                    translateLabel: true
                    model: hideBookmarkBar
                  )
                 (SubCanvasSpec
                    name: 'Bookmarks'
                    layout: (LayoutFrame 13 0 3 0 0 1 -3 1)
                    level: 0
                    hasHorizontalScrollBar: false
                    hasVerticalScrollBar: false
                    miniScrollerHorizontal: false
                    majorKey: BookmarkBar
                    subAspectHolders: 
                   (Array
                      
                     (SubChannelInfoSpec
                        subAspect: bookmarkHolder
                        aspect: bookmarkHolder
                      ) 
                     (SubChannelInfoSpec
                        subAspect: bookmarksHolder
                        aspect: bookmarkListHolder
                      )
                    )
                    createNewApplication: true
                    createNewBuilder: true
                  )
                 )
               
              )
            )
           (UISubSpecification
              name: 'Content'
              layout: (LayoutFrame 0 0 67 0 0 1 0 1)
              minorKey: contentSpec
            )
           )
         
        )
      )
! !

!WebBrowserPage class methodsFor:'menu specs'!

toolBarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::WebBrowserPage andSelector:#toolBarMenu
     (Menu new fromLiteralArrayEncoding:(Tools::WebBrowserPage toolBarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: canGoBackAspect
            label: 'Back'
            itemValue: goBack
            translateLabel: true
            isButton: true
            submenuChannel: goBackMenu
            labelImage: (ResourceRetriever ToolbarIconLibrary historyBackIcon)
          )
         (MenuItem
            enabled: canGoForwardAspect
            label: 'Forward'
            itemValue: goForward
            translateLabel: true
            isButton: true
            submenuChannel: goForwardMenu
            labelImage: (ResourceRetriever ToolbarIconLibrary historyForwardIcon)
          )
         )
        nil
        nil
      )

    "Modified: / 08-11-2011 / 16:42:44 / cg"
! !

!WebBrowserPage class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #urlHolder
      ).

! !

!WebBrowserPage methodsFor:'actions'!

hideBookmarkBar
    <resource: #uiCallback>

    self bookmarkBarVisibleHolder value: false

    "Modified: / 10-06-2011 / 23:57:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hideToolbar
    <resource: #uiCallback>

    self toolBarVisibleHolder value: false.

    "Modified: / 10-06-2011 / 23:58:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

switchToBookmarkEntry: bookmark


    self bookmarkHolder value: bookmark copy.    
    history goTo: bookmark.
    self urlHolder value: bookmark url.

    "Created: / 16-06-2011 / 16:10:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WebBrowserPage methodsFor:'aspects'!

bookmarkBarVisibleHolder
    "return/create the 'bookmarkBarVisibleHolder' value holder (automatically generated)"

    bookmarkBarVisibleHolder isNil ifTrue:[
        bookmarkBarVisibleHolder := true asValue.
        bookmarkBarVisibleHolder addDependent:self.
    ].
    ^ bookmarkBarVisibleHolder

    "Modified: / 10-06-2011 / 23:56:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmarkBarVisibleHolder:something
    "set the 'bookmarkBarVisibleHolder' value holder (automatically generated)"

    |oldValue newValue|

    bookmarkBarVisibleHolder notNil ifTrue:[
        oldValue := bookmarkBarVisibleHolder value.
        bookmarkBarVisibleHolder removeDependent:self.
    ].
    bookmarkBarVisibleHolder := something.
    bookmarkBarVisibleHolder notNil ifTrue:[
        bookmarkBarVisibleHolder addDependent:self.
    ].
    newValue := bookmarkBarVisibleHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:bookmarkBarVisibleHolder.
    ].
!

bookmarkHolder
    "return/create the 'bookmarkHolder' value holder (automatically generated)"

    bookmarkHolder isNil ifTrue:[
        bookmarkHolder := ValueHolder new.
    ].
    ^ bookmarkHolder
!

bookmarkListHolder

    ^BookmarkList forWebBrowser

    "Created: / 08-06-2011 / 12:16:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linkHolder
    "return/create the 'linkHolder' value holder (automatically generated)"

    linkHolder isNil ifTrue:[
        linkHolder := ValueHolder new.
        linkHolder addDependent:self.
    ].
    ^ linkHolder
!

linkHolder:something
    "set the 'linkHolder' value holder (automatically generated)"

    |oldValue newValue|

    linkHolder notNil ifTrue:[
        oldValue := linkHolder value.
        linkHolder removeDependent:self.
    ].
    linkHolder := something.
    linkHolder notNil ifTrue:[
        linkHolder addDependent:self.
    ].
    newValue := linkHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:linkHolder.
    ].
!

titleHolder
    "return/create the 'titleHolder' value holder (automatically generated)"

    titleHolder isNil ifTrue:[
        titleHolder := ValueHolder new.
        titleHolder addDependent:self.
    ].
    ^ titleHolder
!

titleHolder:something
    "set the 'titleHolder' value holder (automatically generated)"

    |oldValue newValue|

    titleHolder notNil ifTrue:[
        oldValue := titleHolder value.
        titleHolder removeDependent:self.
    ].
    titleHolder := something.
    self webKitView title: titleHolder.
    titleHolder notNil ifTrue:[
        titleHolder addDependent:self.
    ].
    newValue := titleHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:titleHolder.
    ].

    "Modified: / 08-06-2011 / 14:51:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

toolBarVisibleHolder
    "return/create the 'toolBarVisibleHolder' value holder (automatically generated)"

    toolBarVisibleHolder isNil ifTrue:[
        toolBarVisibleHolder := true asValue.
        toolBarVisibleHolder addDependent:self.
    ].
    ^ toolBarVisibleHolder

    "Modified: / 10-06-2011 / 23:57:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

toolBarVisibleHolder:something
    "set the 'toolBarVisibleHolder' value holder (automatically generated)"

    |oldValue newValue|

    toolBarVisibleHolder notNil ifTrue:[
        oldValue := toolBarVisibleHolder value.
        toolBarVisibleHolder removeDependent:self.
    ].
    toolBarVisibleHolder := something.
    toolBarVisibleHolder notNil ifTrue:[
        toolBarVisibleHolder addDependent:self.
    ].
    newValue := toolBarVisibleHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:toolBarVisibleHolder.
    ].
!

urlHolder
    "return/create the 'urlHolder' value holder (automatically generated)"

    urlHolder isNil ifTrue:[
        urlHolder := 'http://google.com' asValue.
        urlHolder addDependent:self.
    ].
    ^ urlHolder

    "Modified: / 08-06-2011 / 15:06:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

urlHolder:something
    "set the 'urlHolder' value holder (automatically generated)"

    |oldValue newValue|

    urlHolder notNil ifTrue:[
        oldValue := urlHolder value.
        urlHolder removeDependent:self.
    ].
    urlHolder := something.
    self webKitView url: urlHolder.
    urlHolder notNil ifTrue:[
        urlHolder addDependent:self.
    ].
    newValue := urlHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:urlHolder.
    ].

    "Modified: / 08-06-2011 / 14:27:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

webKitView

    webKitView isNil ifTrue:[
        webKitView := WebKitView new
                        url: self urlHolder;
                        title: self titleHolder;
                        link: self linkHolder;
            
                        yourself.
    ].
    ^webKitView.

    "Created: / 07-06-2011 / 22:50:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 15:04:27 / cg"
    "Modified: / 30-05-2012 / 18:28:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WebBrowserPage methodsFor:'aspects-queries'!

canGoBackAspect

    ^(AspectAdaptor forAspect:#canGoBack)                
                subjectChannel: history;
                yourself.

    "Modified: / 21-07-2009 / 22:39:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 01-09-2009 / 22:38:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-06-2011 / 12:36:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canGoForwardAspect


   ^(AspectAdaptor forAspect:#canGoForward)                
                subjectChannel: history;
                yourself.

    "Modified: / 21-07-2009 / 22:39:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 01-09-2009 / 22:39:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-06-2011 / 12:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WebBrowserPage methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == urlHolder ifTrue:[
         self updateBookmark.
         ^ self.
    ].

    changedObject == toolBarVisibleHolder ifTrue:[
         self updateToollBarAndBookmarkBarVisibility.
         ^ self.
    ].

    changedObject == linkHolder ifTrue:[
         self updateLink.
         ^ self.
    ].

    changedObject == bookmarkBarVisibleHolder ifTrue:[
         self updateToollBarAndBookmarkBarVisibility.
         ^ self.
    ].

    

    super update:something with:aParameter from:changedObject

    "Modified: / 30-05-2012 / 18:28:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateBookmark

    | url title bookmark |
    url := self urlHolder value.
    title := self titleHolder value.

    ((bookmark := self bookmarkHolder value) notNil and:[bookmark url = url]) ifTrue:[
        self bookmarkHolder value label: title.
    ] ifFalse:[
        self bookmarkHolder value: (Bookmark forUrl: url label: title).
        history goTo: self bookmarkHolder value
    ]

    "Created: / 08-06-2011 / 12:19:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-06-2011 / 14:55:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateLink

    (masterApplication notNil and:[masterApplication respondsTo: #infoLabelHolder]) ifTrue:[
        masterApplication infoLabelHolder value: (self linkHolder value ? '')

    ]

    "Created: / 30-05-2012 / 18:28:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateToollBarAndBookmarkBarVisibility
    |toolBarVisible toolBar bookmarkBarVisible bookmarkBar pageContent topOffset h|

    builder isNil ifTrue:[^self].
    toolBar := self componentAt:#ToolBar.
    bookmarkBar := self componentAt:#BookmarkBar.
    topOffset := 0.
    toolBar isNil ifFalse:[
        toolBarVisible := self toolBarVisibleHolder value.
        toolBarVisible ifTrue:[
            topOffset := topOffset + toolBar height.
        ]
    ].
    bookmarkBar isNil ifFalse:[    
        bookmarkBarVisible := self bookmarkBarVisibleHolder value.     
        bookmarkBarVisible ifTrue:[
            h := bookmarkBar height.
            bookmarkBar layout topOffset:topOffset.
            bookmarkBar layout bottomOffset:topOffset + h.
            bookmarkBar container notNil ifTrue:[
                bookmarkBar containerChangedSize.
            ].
            topOffset := topOffset + h. 
        ]
    ].


    pageContent := self componentAt:#Content.
    pageContent notNil ifTrue:[
        pageContent layout topOffset:topOffset.
        pageContent container notNil ifTrue:[
            pageContent containerChangedSize.
        ].
    ].

    "Created: / 10-06-2011 / 23:55:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 15:04:22 / cg"
! !

!WebBrowserPage methodsFor:'hooks'!

commonPostOpen

    self updateToollBarAndBookmarkBarVisibility

    "Created: / 11-06-2011 / 00:00:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WebBrowserPage methodsFor:'initialization'!

initialize

    super initialize.
    history := NavigationHistory new.

    "Created: / 08-06-2011 / 12:23:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WebBrowserPage methodsFor:'menu-actions'!

goBack

    self switchToHistoryEntry: history goBack

    "Created: / 22-02-2008 / 10:16:30 / janfrog"
    "Modified: / 22-02-2008 / 17:18:43 / janfrog"
    "Modified: / 08-06-2011 / 14:56:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

goForward

    self switchToHistoryEntry: history goForward

    "Created: / 22-02-2008 / 10:16:30 / janfrog"
    "Modified: / 22-02-2008 / 17:18:56 / janfrog"
    "Modified: / 08-06-2011 / 14:57:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

switchToHistoryEntry: bookmark

    self urlHolder value: bookmark url

    "Created: / 08-06-2011 / 15:01:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WebBrowserPage methodsFor:'menu-dynamic'!

goBackMenu

    <resource: #programMenu>

    | menu |
    menu := Menu new.
    history goBackItems do:
        [:historyEntry|
        menu addItem:
            (MenuItem
                label: historyEntry label
                itemValue:[self switchToHistoryEntry: historyEntry])].
    ^menu

    "Created: / 22-02-2008 / 16:55:18 / janfrog"
    "Modified: / 27-02-2008 / 11:54:08 / janfrog"
    "Modified: / 08-06-2011 / 15:01:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-09-2012 / 13:24:30 / cg"
!

goForwardMenu
    <resource: #programMenu>

    | menu |

    menu := Menu new.
    history goForwardItems do:[:historyEntry|
        menu addItem:
            (MenuItem
                label: historyEntry label
                itemValue:[self switchToHistoryEntry: historyEntry])
    ].
    ^menu

    "Created: / 22-02-2008 / 16:55:18 / janfrog"
    "Modified: / 27-02-2008 / 11:54:27 / janfrog"
    "Modified: / 08-06-2011 / 15:01:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 09-09-2012 / 13:24:59 / cg"
! !

!WebBrowserPage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__WebBrowserPage.st,v 1.9 2014-02-05 19:09:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__WebBrowserPage.st,v 1.9 2014-02-05 19:09:12 cg Exp $'
!

version_SVN
    ^ '$Id: Tools__WebBrowserPage.st,v 1.9 2014-02-05 19:09:12 cg Exp $'
! !

