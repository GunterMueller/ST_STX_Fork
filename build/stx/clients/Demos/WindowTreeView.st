"
 COPYRIGHT (c) 1991 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
"{ Package: 'stx:clients/Demos' }"

TreeGraphView subclass:#WindowTreeView
	instanceVariableNames:'showAll showAllInstances showAllWindows'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Trees'
!

!WindowTreeView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"


!

documentation
"
    This is one of the oldest demo views in ST/X;
    many features which are now awailable were not at the time this was
    written. It definitely needs a facelift...

    a small application showing an ObjectView / TreeView use

    This displays a hierarchical picture of either a single views
    or all views widget hierarchy.
    Useful to have a look at subcomponents - to see how views
    are structured.

    [start with:]
        WindowTreeView open

    [see also:]
        ClassTreeView TreeView
        ObjectView DisplayObject

    [author:]
        Claus Gittinger - written spring 91
"
! !

!WindowTreeView class methodsFor:'startup'!

open 
    "open a windowTree on all views on the current screen"

    ^ self openOn:nil allWindows:true allScreens:false

    "
     WindowTreeView open
    "

    "Modified: / 10.2.2000 / 18:42:01 / cg"
!

openOn:aTopView 
    "open a windowTree on a particular view"

    ^ self openOn:aTopView allWindows:false allScreens:false.

    "
     WindowTreeView openOn:(BrowserView allInstances first)
     WindowTreeView openOn:nil
    "

    "Modified: / 10.2.2000 / 18:43:15 / cg"
!

openOn:aTopView allScreens:allScreens
    "basic open; if aTopView is nonNil, a tree on that screen is
     opened. If nil, and allScreens is false, the views on the current screen 
     are shown. Otherwise, all views on all devices are shown."

    ^ self openOn:aTopView allWindows:true allScreens:allScreens

    "Modified: / 10.2.2000 / 18:41:37 / cg"
!

openOn:aTopView allWindows:allWindows allScreens:allScreens
    "basic open; if aTopView is nonNil, a tree on that screen is
     opened. If nil, and allScreens is false, the views on the current screen 
     are shown. Otherwise, all views on all devices are shown."

    |topView v treeView|

    topView := StandardSystemView new.
    topView icon:(Image fromFile:'Demo.icon' resolution:100 on:topView device).
    aTopView isNil ifTrue:[
        topView label:'Window hierarchy - known views'
    ] ifFalse:[
        topView label:'Window hierarchy - ' , aTopView printString
    ].

    treeView := self basicNew.
    treeView showAllWindows:allWindows.
    treeView showAllInstances:allScreens.
    treeView initialize.

    v  := HVScrollableView forView:treeView in:topView.
    v origin:(0 @ 0) extent:(1.0 @ 1.0).
    v topNode:aTopView.

    topView open.
    ^ treeView.

    "
     WindowTreeView openOn:(BrowserView allInstances first)
    "

    "Modified: / 10.2.2000 / 18:42:38 / cg"
!

openOn:aTopView initialSelection:aView
    "open a windowTree on a particular view. Initially select one of its subviews"

    |treeView el|

    treeView := self openOn:aTopView allWindows:false allScreens:false.

    el := treeView elementForObject:aView.
    treeView select:el.
    treeView makeVisible:el.
    ^ treeView.
!

openOnAll
    "open a windowTree on all views on all screens"

    ^ self openOn:nil allWindows:true allScreens:true.

    "
     WindowTreeView openOnAll
    "

    "Modified: / 10.2.2000 / 18:41:53 / cg"
! !

!WindowTreeView methodsFor:'accessing-behavior'!

showAllInstances:aBoolean
    showAllInstances := aBoolean
!

showAllWindows:aBoolean
    showAllWindows := aBoolean

    "Created: / 10.2.2000 / 18:39:59 / cg"
! !

!WindowTreeView methodsFor:'generating the class-tree picture'!

addChildrenToTreeFrom:anElement father:father xPos:xPos yPos:yPos first:isFirst
    ^ super addChildrenToTreeFrom:anElement father:father xPos:xPos yPos:yPos first:false
!

addChildrenToTreeFrom:aView xPos:xPos yPos:yPos
    "special - we may have a forest here ..."

    |yNext yPrev views|

    yNext := yPos.
    aView isNil ifTrue:[
        "/ all views on the current screen (or all views on all screens)
        "/ or no selected view yet.
        showAllWindows == true ifTrue:[
            showAllInstances == true ifTrue:[
                views := TopView allSubInstances
            ] ifFalse:[
                views := Screen current allViews
            ].
            views do:[:v |
                v superView isNil ifTrue:[
                    "its a top-view"

                    (v respondsTo:#subViews) ifTrue:[
                        "a real view, dont show if its a modal or
                         popup view, except when currently visible"
                        (showAll or:[v realized or:[v isPopUpView not]]) ifTrue:[
                            "dont show ShadowViews, popups etc."
                            yPrev := yNext.
                            yNext := self addChildrenToTreeFrom:v father:nil xPos:xPos yPos:yNext first:false.

                            "anything added ?"
                            yNext ~~ yPrev ifTrue:[
                                "create a gap"
                                 yNext := yNext + (device verticalPixelPerMillimeter*10) rounded.
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ] ifFalse:[
        "/ a particular view
        yNext := self addChildrenToTreeFrom:aView father:nil xPos:xPos yPos:yNext first:true.
    ].
    ^ yNext

    "Modified: / 10.2.2000 / 18:40:21 / cg"
!

allSuperViewsShownOf:aView
    aView isNil ifTrue:[^ true].
    aView realized ifFalse:[^ false].
    aView shown ifFalse:[^ false].
    aView isTopView ifTrue:[^ true].
    ^ self allSuperViewsShownOf:aView superView
!

bgColorFor:aView
    "return a color for a node:
        blue:   non-views (borders, wrappers etc.)
        red:    visible (shown) views
        black:  invisible (hidden) views
    "

    aView isView ifFalse:[
        ^ Color blue lightened
    ].

    aView realized ifTrue:[
        (self allSuperViewsShownOf:aView) "/ (aView topView realized and:[aView topView shown]) 
        ifTrue:[
            ^ Color red lightened
        ].
        ^ Color lightGrey
    ].
    ^ Color grey

    "Modified: 14.2.1997 / 14:15:50 / cg"
!

childrenOf:aThingy do:aBlock
    "enumerate the children of aThingy into aBlock"

    |subviews sub children|

    showAll ifFalse:[
        "dont show ShadowViews, popups etc."

        (aThingy isView and:[aThingy isPopUpView]) ifTrue:[
            ^ self
        ]
    ].

    "/ used to be only subViews here; however, in the meantime, this
    "/ tree-viewer can also be used for other things, like specs and hw-hierarchies.
    "/ need to refactor this, and make the selector a parameter somehow.

    "a real view with real subViews ?"
    MessageNotUnderstood catch:[
        subviews := aThingy subViews.
    ].
    subviews notNil ifTrue:[
        subviews do:aBlock
    ].

    "a real view with simulated subViews ?"
    MessageNotUnderstood catch:[
        subviews := aThingy components.
    ].
    subviews notNil ifTrue:[
        subviews do:aBlock
    ].

    "a spec-like thing ?"
    MessageNotUnderstood catch:[
        sub := aThingy component.
    ].
    sub notNil ifTrue:[
        aBlock value:sub
    ].

    "a spec-like thing ?"
    MessageNotUnderstood catch:[
        children := aThingy children.
    ].
    children notNil ifTrue:[
        children do:aBlock
    ].

    "Modified: 14.2.1997 / 14:14:54 / cg"
!

colorFor:aView
    "return a color for a node:
        blue:   non-views (borders, wrappers etc.)
        red:    visible (shown) views
        black:  invisible (hidden) views
    "

"/    aView isView ifFalse:[
"/        ^ Color blue
"/    ].
"/
"/    (aView realized and:[
"/     aView topView realized and:[
"/     aView topView shown]]) ifTrue:[
"/        device hasGreyscales ifTrue:[
"/            ^ Color red
"/        ].
"/        ^ Color veryDarkGrey
"/    ].
    ^ Black

    "Modified: 14.2.1997 / 14:15:50 / cg"
!

textFor:aView
    "return a text-string for a node"

    |lbl maxSz line1 line2 line3 app|

    (aView isKindOf:StandardSystemView) ifTrue:[
        lbl := aView label asString string.
        maxSz := 30.
    ].

    (aView isKindOf:Label) ifTrue:[
        aView label isString ifTrue:[
            lbl := aView label asString string.
            maxSz := 15.
        ] ifFalse:[
            aView label isImageOrForm ifTrue:[
                lbl := '%1x%2-Image' bindWith:(aView label width) with:(aView label height).
"/                maxSz := 99.                               
            ]
        ].
    ].

    lbl notNil ifTrue:[
        line1 := '%1 ("%2")' 
                    bindWith:aView class name
                    with:(lbl contractTo:15)
    ] ifFalse:[
        line1 := aView class name
    ].
    line2 := aView perform:#name ifNotUnderstood:[ aView printString ].
    line2 := line2 ? 'unnamed'.
    app := aView perform:#application ifNotUnderstood:[ nil ].
    app isNil ifTrue:[
        line3 := ''
    ] ifFalse:[
        line3 := app class name.
    ].
    "/ line3 := aView level printString.
    ^ (line1,'\',line2,'\',line3) withCRs

    "Modified: / 5.2.2000 / 17:32:17 / cg"
! !

!WindowTreeView methodsFor:'initialization'!

initialize
    topNode := nil.
    showAll isNil ifTrue:[showAll := false].
    showAllInstances isNil ifTrue:[showAllInstances := false].
    showAllWindows isNil ifTrue:[showAllWindows := true].

    super initialize.

    self menuHolder:self.
    self menuPerformer:self.
    self menuMessage:#menu.

    "Modified: / 10.2.2000 / 18:40:55 / cg"
! !

!WindowTreeView methodsFor:'menu'!

menu
    "return a middleButtonMenu, depending on what is selected.
     That menu is funny/strange/wierd, 
     in that part of it is really information, not menu-actions"

    <resource: #programMenu>

    |items selectors m v org corner ext prefExt lI tI rI bI info bounds 
     layout bw lvl vModel vController vApplication vMasterApplication
     geometryInfo colorInfo modelInfo modelSelectors|

    topNode isNil ifTrue:[
        items := #(
                   ('Update (Created)'       doUpdate       )
                   ('Update (all Views)'     doUpdateAll    )
                   ('-')
                   ('Select View'            doSelectView   )
                  ).
    ] ifFalse:[
        items := #(
                   ('Update'                 doUpdate       )
                   ('-')
                   ('Select View'            doSelectView   )
                  ).
    ].

    selection isNil ifTrue:[
        ^ PopUpMenu itemList:items resources:resources.
    ].

    v := (assoc at:selection).  "/ the selected objects view

    (v respondsTo:#model) ifTrue:[
        vModel := v model.
    ].
    (v respondsTo:#controller) ifTrue:[
        vController := v controller.
    ].
    (v respondsTo:#application) ifTrue:[
        vApplication := v application.
        vApplication notNil ifTrue:[
            (vApplication respondsTo:#masterApplication) ifTrue:[
                vMasterApplication := vApplication masterApplication.
            ]
        ].
    ].

    items := items , #(
                        ('-'                               )
                        ('Geometry'          geometryInfo  )
                        ('Colors'            colorInfo  )
                        ('Interface'         modelInfo     )
                        ('-'                               )
                        ('Browse View Class' doBrowse      )
                      ).

    vModel notNil ifTrue:[
        (vModel isKindOf:ApplicationModel) ifTrue:[
            items := items , #( ('Browse Application Class'  doBrowseModel) ).
        ] ifFalse:[
            items := items , #( ('Browse Model Class'  doBrowseModel) ).
        ].
    ].
    vApplication notNil ifTrue:[
        vApplication ~~ vModel ifTrue:[
            items := items , #( ('Browse Application' browseApplication) ).
        ].
        vMasterApplication notNil ifTrue:[
            vMasterApplication ~~ vApplication ifTrue:[
                vMasterApplication ~~ vModel ifTrue:[
                    items := items , #( ('Browse MasterApplication' browseMasterApplication) ).
                ]
            ]
        ].
    ].
    vController notNil ifTrue:[
        vController ~~ v ifTrue:[
            items := items , #( ('Browse Controller Class' doBrowseController) ).
        ]
    ].

    items := items , #(
                        ('-'                   )
                        ('Inspect View'         doInspect)
                        ('Inspect Window Group' doInspectWindowGroup)
                      ).

    vModel notNil ifTrue:[
        (vModel isKindOf:ApplicationModel) ifTrue:[
            items := items , #( ('Inspect ApplicationModel' inspectModel) ).
        ] ifFalse:[
            items := items , #( ('Inspect Model' inspectModel) ).
        ].
    ].
    vController notNil ifTrue:[
        vController ~~ v ifTrue:[
            items := items , #( ('Inspect Controller' inspectController) ).
        ]
    ].

    vApplication notNil ifTrue:[
        vApplication ~~ vModel ifTrue:[
            items := items , #( ('Inspect Application' inspectApplication) ).
        ].
        vMasterApplication notNil ifTrue:[
            vMasterApplication ~~ vApplication ifTrue:[
                vMasterApplication ~~ vModel ifTrue:[
                    items := items , #( ('Inspect MasterApplication' inspectMasterApplication) ).
                ]
            ]
        ].
    ].

    v isView ifTrue:[
        v isRootView ifFalse:[
            items := items , #(
                                ('-'                     )
                                ('Raise'      doRaise    )
                                ('Lower'      doLower    )
                                ('Flash'      doFlash    )
                                ('-'                     )
                                ('Destroy'    doDestroy  )
                              ).
        ].
    ].

    m := PopUpMenu itemList:items resources:resources.

    "/ the info parts ...
    geometryInfo := OrderedCollection new.
    (v isView) ifTrue:[
        v isRootView ifFalse:[
            v relativeOrigin notNil ifTrue:[
                org := v relativeOrigin
            ] ifFalse:[
                org := v origin
            ].
            v relativeCorner notNil ifTrue:[
                corner := v relativeCorner
            ] ifFalse:[
                corner := v corner
            ].
            v relativeExtent notNil ifTrue:[
                ext := v relativeExtent
            ] ifFalse:[
                ext := v extent
            ].
            layout := v geometryLayout.
            lI := v leftInset.
            rI := v rightInset.
            tI := v topInset.
            bI := v bottomInset.
            bw := v borderWidth.
            lvl := v level.
            prefExt := v preferredExtent.
            (v left @ v top) = org ifTrue:[
                geometryInfo add:('origin: ' , org printString)
            ] ifFalse:[
                geometryInfo add:('origin: ' , org printString ,
                               ' --> (' , v left printString ,
                               '@' , v top printString , ')').
            ].
            (v right @ v bottom) = corner ifTrue:[
                geometryInfo add:('corner: ' , corner printString)
            ] ifFalse:[
                geometryInfo add:('corner: ' , corner printString ,
                               ' --> (' , v right printString ,
                               '@' , v bottom printString , ')').
            ].
            geometryInfo add:('extent: ' , ext printString).
            geometryInfo add:('prefExt: ' , prefExt printString).
            geometryInfo add:('inset l: ' , lI printString ,
                           ' r: ' , rI printString ,
                           ' t: ' , tI printString ,
                           ' b: ' , bI printString).
            geometryInfo add:('borderWidth: ' , bw printString , ' level: ' , lvl printString).
        ].
    ] ifFalse:[
        bounds := v bounds.
        bounds notNil ifTrue:[
            org := bounds origin.
            corner := bounds corner.
            geometryInfo add:('bounds: ' , bounds displayString).
        ].
        v isView ifTrue:[
            v isLayoutWrapper ifTrue:[
                layout := v layout
            ]
        ]
    ].

    geometryInfo add:('layout: ' , layout displayString).
    v isView ifTrue:[
        geometryInfo add:('transformation: ' , v transformation displayString).
    ].
    m subMenuAt:#geometryInfo
            put:(PopUpMenu
                        labels:geometryInfo
                        selectors:nil
                        receiver:nil).


    "/ the color info part ...
    colorInfo := OrderedCollection new.
    (v isView) ifTrue:[
        v isRootView ifFalse:[
            colorInfo add:('viewBG: ' , (' ' asText colorizeAllWith:v viewBackground), ' ' , v viewBackground printString).
            colorInfo add:('FG: ' , (' ' asText colorizeAllWith:v foregroundColor), ' ' , v foregroundColor printString).
            colorInfo add:('BG: ' , (' ' asText colorizeAllWith:v backgroundColor), ' ' , v backgroundColor printString).
        ].
    ] ifFalse:[
    ].

    m subMenuAt:#colorInfo
            put:(PopUpMenu
                        labels:colorInfo
                        selectors:nil
                        receiver:nil).


    "/ the model info part ...
    modelInfo := OrderedCollection new.
    modelSelectors := OrderedCollection new.
    vController == v ifTrue:[
        modelInfo add:('controller: ' , (vController displayString contractAtEndTo:60) , ' (== view itself)').
    ] ifFalse:[
        modelInfo add:('controller: ' , (vController displayString contractAtEndTo:60)).
    ].
    modelSelectors add:(vController notNil ifTrue:[#inspectController] ifFalse:[nil]).

    (v isKindOf:Button) ifTrue:[
        modelInfo add:('action callBack: ' , v releaseAction displayString).
        modelSelectors add:#browseCallbackAction.
    ].

    v isView ifTrue:[
        v isTopView ifTrue:[
            modelInfo add:('keyboardProcessor: ' , v keyboardProcessor displayString).
            modelSelectors add:#inspectKeyboardProcessor.
        ].
    ].

    v isView ifTrue:[
        v delegate notNil ifTrue:[
            modelInfo add:('delegate: ' , v delegate displayString).
            modelSelectors add:#inspectDelegate.
        ].
    ].

    modelInfo add:('model: ' , (vModel displayString contractAtEndTo:60) displayString).
    modelSelectors add:(vController notNil ifTrue:[#inspectModel] ifFalse:[nil]).
    vModel notNil ifTrue:[
        (v respondsTo:#modelInterface) ifTrue:[
            v modelInterface keysAndValuesDo:[:key : val |
                modelInfo add:('  ' , key , ':' , val displayString).
                modelSelectors add:nil.
            ]
        ]
    ].

    vApplication notNil ifTrue:[
        vApplication == vModel ifTrue:[
            modelInfo add:('application: ' , vApplication displayString , ' (== model)').
        ] ifFalse:[
            modelInfo add:('application: ' , vApplication displayString).
        ].
        modelSelectors add:#inspectApplication.

        vMasterApplication notNil ifTrue:[
            vMasterApplication == vApplication ifTrue:[
                modelInfo add:('masterApplication: ' , vMasterApplication displayString , ' (== application)').
            ] ifFalse:[
                vMasterApplication == vModel ifTrue:[
                    modelInfo add:('masterApplication: ' , vMasterApplication displayString , ' (== model)').
                ] ifFalse:[
                    modelInfo add:('masterApplication: ' , vMasterApplication displayString).
                ]
            ].
            modelSelectors add:#inspectMasterApplication.
        ].
    ].

    m subMenuAt:#modelInfo
            put:(PopUpMenu
                        labels:modelInfo
                        selectors:modelSelectors
                        receiver:self).

    ^ m

    "Modified: / 22-01-1998 / 15:31:09 / stefan"
    "Created: / 20-06-1998 / 12:56:43 / cg"
    "Modified: / 18-09-2007 / 09:48:31 / cg"
! !

!WindowTreeView methodsFor:'user interaction'!

browseApplication 
    "open a browser on the selected views application class"

    self withSelectedElementDo:[:theView |
        |application|

        (application := theView application) notNil ifTrue:[
            application browse
        ]
    ]

    "Created: / 18-09-2007 / 09:48:51 / cg"
!

browseCallbackAction
    "open a browser on the selected button's action"

    self withSelectedElementDo:[:theButton |
        |action|

        (action := theButton releaseAction) notNil ifTrue:[
            UserPreferences browserClass openInMethod:action method
        ]
    ]
!

browseMasterApplication 
    "open a browser on the selected views application class"

    self withSelectedElementDo:[:theView |
        |application|

        (application := theView application masterApplication) notNil ifTrue:[
            application browse
        ]
    ]

    "Created: / 18-09-2007 / 09:49:08 / cg"
!

doBrowse
    "open a browser in the selected views class"

    self withSelectedElementDo:[:theView |
         theView class browserClass openInClass:(theView class) selector:nil
    ]

    "Modified: 1.3.1997 / 16:08:47 / cg"
!

doBrowseController 
    "open a browser on the selected views controller class"

    self withSelectedElementDo:[:theView |
        |controller|

        (controller := theView controller) notNil ifTrue:[
            UserPreferences current systemBrowserClass openInClass:(controller class) selector:nil
        ]
    ]

    "Modified: / 14.2.1997 / 14:16:44 / cg"
    "Created: / 31.10.1997 / 20:11:08 / cg"
!

doBrowseModel
    "open a browser on the selected views model class"

    self withSelectedElementDo:[:theView |
        |model|

        (model := theView model) notNil ifTrue:[
            UserPreferences current systemBrowserClass openInClass:(model class) selector:nil
        ]
    ]

    "Modified: / 14.2.1997 / 14:16:51 / cg"
    "Created: / 31.10.1997 / 20:11:44 / cg"
!

doDestroy
    "destroy the selected view"

    self withSelectedElementDo:[:theView |
        theView destroy.
        self updateTree
    ]

    "Modified: 14.2.1997 / 14:17:13 / cg"
!

doFlash
    "flash the selected view (to find it)"

    self withSelectedElementDo:[:theView |
        theView shown ifTrue:[
            theView perform:#flash ifNotUnderstood:nil
        ]
    ]

    "Created: / 20.6.1998 / 13:03:20 / cg"
    "Modified: / 19.11.1999 / 17:29:55 / cg"
!

doInspect
    "inspect the selected view"

    self withSelectedElementDo:[:theView |
         theView inspect
    ]

    "Modified: 14.2.1997 / 14:17:10 / cg"
!

doInspectWindowGroup
    "inspect the selected views windowGroup"

    |groups|

    groups := IdentitySet new.
    self withSelectedElementDo:[:theView |
         groups add:theView windowGroup
    ].
    groups do:[:each | each inspect].
!

doLower
    "bring the selected views topView to the back"

    self withSelectedElementDo:[:theView |
         theView topView lower
    ]

    "Modified: 14.2.1997 / 14:17:34 / cg"
!

doRaise
    "bring the selected view to the front"

    self withSelectedElementDo:[:theView |
         theView raise
    ]

    "Modified: / 10.2.2000 / 18:45:24 / cg"
!

doSelectView
    "let user select a view by picking"

    |v el|

    v := Screen current viewFromUser.
    (v isComponentOf:topNode) ifTrue:[
        el := assoc keyAtValue:v.
        self select:el.
        self makeVisible:el.
    ].
!

doUpdate
    "update the tree (in case new views have been created).
     Only show views which are known to the device."

    showAllInstances := false.
    self update.

    "Modified: / 10.2.2000 / 18:44:38 / cg"
!

doUpdateAll
    "update the tree for all view instances (even those, which
     have not yet been created on the display)"

    showAllInstances := true.
    self update.

    "Created: / 14.2.1997 / 14:07:55 / cg"
    "Modified: / 10.2.2000 / 18:44:42 / cg"
!

doubleClick:anElement
    anElement inspect


!

inspectApplication 
    "open an inspector on the selected views application"

    self withSelectedElementDo:[:theView |
        |application|

        (application := theView application) notNil ifTrue:[
            application inspect
        ]
    ]

    "Created: / 31.10.1997 / 20:12:26 / cg"
    "Modified: / 31.10.1997 / 20:16:04 / cg"
!

inspectController 
    "open an inspector on the selected views controller"

    self withSelectedElementDo:[:theView |
        |controller|

        (controller := theView controller) notNil ifTrue:[
            controller inspect
        ]
    ]

    "Modified: 14.2.1997 / 14:18:55 / cg"
!

inspectDelegate 
    "open an inspector on the selected views delegate"

    self withSelectedElementDo:[:theView |
        |delegate|

        (delegate := theView delegate) notNil ifTrue:[
            delegate inspect
        ]
    ]

    "Modified: / 14.2.1997 / 14:18:55 / cg"
    "Created: / 16.7.1998 / 18:52:45 / cg"
!

inspectKeyboardProcessor
    "open an inspector on the selected views keyboardProcessor"

    self withSelectedElementDo:[:theView |
        |keyboardProcessor|

        (keyboardProcessor := theView keyboardProcessor) notNil ifTrue:[
            keyboardProcessor inspect
        ]
    ]
!

inspectMasterApplication 
    "open an inspector on the selected views application"

    self withSelectedElementDo:[:theView |
        |application|

        (application := theView application masterApplication) notNil ifTrue:[
            application inspect
        ]
    ]

    "Created: / 16.7.1998 / 18:52:28 / cg"
    "Modified: / 19.11.1999 / 17:46:31 / cg"
!

inspectModel
    "open an inspector on the selected views model"

    self withSelectedElementDo:[:theView |
        |model|

        (model := theView model) notNil ifTrue:[
            model inspect
        ]
    ]

    "Modified: 14.2.1997 / 14:19:01 / cg"
!

select:anObject
    super select:anObject.
    anObject notNil ifTrue:[
        self doFlash
    ].

    "Created: / 16.7.1998 / 18:41:19 / cg"
!

update
    "update the tree (in case new views have been created)."

    self updateTree.
    self contentsChanged

    "Modified: / 14.2.1997 / 14:18:35 / cg"
    "Created: / 10.2.2000 / 18:44:26 / cg"
! !

!WindowTreeView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/WindowTreeView.st,v 1.61 2011-10-28 07:37:15 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/WindowTreeView.st,v 1.61 2011-10-28 07:37:15 stefan Exp $'
! !
