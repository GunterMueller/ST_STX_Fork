"
 COPYRIGHT (c) 2007 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Tools }"

ToolApplicationModel subclass:#ViewTreeInspectorApplication
	instanceVariableNames:'model treeView hasSingleSelectionHolder clickedItem clickedPoint
		motionAction process followFocusChannel showNamesHolder
		inspectorView inspectorModeIndexHolder path
		isCatchingEventsChannel browser'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

Object subclass:#MenuDesc
	instanceVariableNames:'title value action'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ViewTreeInspectorApplication
!

HierarchicalItem subclass:#ViewTreeItem
	instanceVariableNames:'widget isDrawnShown exists xOffsetAdditionalName'
	classVariableNames:'HandleExtent'
	poolDictionaries:''
	privateIn:ViewTreeInspectorApplication
!

ValueModel subclass:#ViewTreeModel
	instanceVariableNames:'lockSema selectedSuperItems selection hiddenLevel listOfItems
		inputEventAction mappedViewAction beforeSelectionChangedAction
		icons timedUpdateTask selectOnClickHolder testModeChannel
		hasTargetWidgetChannel catchEvents'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ViewTreeInspectorApplication
!

HierarchicalList subclass:#ItemList
	instanceVariableNames:'treeModel eventHook eventHookInitialized showWidgetNames'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ViewTreeInspectorApplication::ViewTreeModel
!

!ViewTreeInspectorApplication class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
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
     Small application showing a ViewTreeModel use.

     It displays a hierarchical list of a selected TopView and
     all its contained subViews.
     Useful to have a look at subcomponents - to see how views
     are structured.


    [Instance variables:]
        model           <ViewTreeModel>      the used ViewTreeModel
        clickedItem     <ViewTreeItem>       item under the clickedPoint (motion action)
        clickedPoint    <Point>              point where the motion action started from.
        motionAction    <Action>             (oneArg-) action called durring buttonMotion.


    [author:]
        Claus Atzkern

    [see also:]
        ViewTreeModel
        ViewTreeItem
"
! !

!ViewTreeInspectorApplication class methodsFor:'initialization'!

initialize
    "add myself to the launcher menu
    "
    self installInLauncher.
!

installInLauncher
    "add myself to the launcher menu"

    |menuItem icon|

    NewLauncher isNil ifTrue:[^ self].
    "/ cg - disabled. the icon is too ugly.
    ^ self.

"/    icon := ToolbarIconLibrary inspectLocals20x20Icon magnifiedTo:28@28.
"/
"/    menuItem := MenuItem new 
"/                    label: 'View Tree Inspector';
"/                    value: [ ViewTreeInspectorApplication open];
"/                    isButton: true;
"/                    icon: icon;
"/                    nameKey: #viewInspect.
"/
"/    menuItem startGroup:#right.
"/    NewLauncher addMenuItem:menuItem in:'toolbar'
"/                   position:#( #before #help)
"/                      space:false.

    "
     self installInLauncher
     self removeFromLauncher
    "
!

postAutoload
    "add myself to the launcher menu
    "
    self installInLauncher.
"
self installInLauncher
self removeFromLauncher
"
!

removeFromLauncher
    "remove myself from the launcher menu
    "
    NewLauncher isNil ifTrue:[^ self].
    NewLauncher removeUserTool:#viewInspect

"
self installInLauncher
self removeFromLauncher
"
!

unload
    "class is about to be unloaded - remove myself from the launcher menu
    "
    self removeFromLauncher.
    super unload.
! !

!ViewTreeInspectorApplication class methodsFor:'help specs'!

flyByHelpSpec
    <resource: #help>

    ^super flyByHelpSpec addPairsFrom:#(

#doRedraw
'Force the application to redraw its windows'

#doUncatchEvents
'Release picked view and uncatch events\(currently locked for widget selection)'  

#doCatchEvents
'Lock view and catch events for widget selection\(currently unlocked)'  

#doInspectApplication
'Inspect the selected view''s application'  

#doBrowseApplication
'Browse the selected view''s application'  

#doPickView
'Pick a widget with the mouse and inspect its view hierarchy'  

)
! !

!ViewTreeInspectorApplication class methodsFor:'image specs'!

crossHairIcon
    ^ ToolbarIconLibrary bigCrossHairIcon
!

lockViewIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self lockViewIcon inspect
     ImageEditor openOnClass:self andSelector:#lockViewIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::ViewTreeInspectorApplication lockViewIcon'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@A8^G!!7O3ACP5*P@@A8^G @@@@@@@@@@@A8^@@@OE0/!!P0S#0@@^G @@@@@@@@@@@B (@D''D#48"1.CX5H@(J@@@@@@@@@@@@B (B(>SAT"
''%!!/P7,@(J@@@@@@@@@@@@@%IB0#M"H%IRTQV5P@IRT@@@@@@@@@@@ANSX:U]PANS$8:T80@S$8@@@@@@@@@@@AN&UYWK(EYQ@\FUPQHXT8@@@@@@@@@@@AN
HC2!!TVY:Y#-%I*IKMD8@@@@@@@@@@@A$\@83XBEG%).GGX _!!&P@@@@@@@@@@@AO[P5+ &(WPYN@["!!E\$<@@@@@@@@@@@B_F''FQPAXX_!!&TGH4HB9<@@@@@
@@@@@@B_%3HCJ7=BKPU,Q)01B9<@@@@@@@@@@@@PBP8T_F!!''JPI)_Y"D&!!@@@@@@@@@@@@@$B)I9TGXO''WQIWQ93W0@@@@@@@@@@@@@$"U=JR$)JR$)JR$)_
"P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[132 141 152 147 150 154 250 223 1 246 214 0 205 172 133 238 195 0 213 180 146 217 186 150 188 136 0 206 151 0 183 125 9 208 208 202 196 204 214 255 255 210 255 255 219 210 178 65 242 242 235 106 112 117 96 107 126 250 255 255 255 241 0 154 154 151 255 227 0 67 35 0 52 17 0 253 211 0 208 159 0 167 178 193 222 168 0 248 231 45 208 174 26 199 152 26 225 184 36 255 249 75 220 220 215 77 88 108 241 241 235 245 245 239 255 250 109 242 249 255 255 255 142 255 237 1 142 148 162 242 212 1 143 154 176 174 133 0 222 189 144 169 179 192 177 184 193 184 129 0 255 255 194 253 241 60 210 210 205 214 214 209 77 83 92 230 230 225 98 106 114 243 243 238 117 117 114 255 252 115 255 255 255 115 123 147 130 140 156 152 156 159 241 210 0 53 18 0 151 116 0 162 170 184 218 187 150 193 143 4 220 165 0 206 188 46 181 130 21 204 173 44 206 206 201 208 167 44 72 84 108 240 240 234 244 244 238 243 243 237 212 182 79 255 255 126 131 135 141 119 133 159 132 141 163 195 162 126 219 188 133 218 185 135 180 180 176 221 190 150 175 181 191 176 183 196 181 189 201 202 170 38 209 209 204 207 207 202 251 241 74 229 229 224 238 238 233 226 234 245 244 244 237 255 251 113 255 255 124 255 241 2 255 234 3 249 219 0 255 249 29 252 243 30 227 181 0 212 165 5 222 170 0 173 179 194 216 171 19 255 255 198 208 208 203 156 90 7 206 175 50 91 91 95 211 180 71 242 242 237 246 246 241 212 182 80 255 255 123 129 137 152 255 239 8 251 223 0 59 25 0 251 215 0 228 183 0 222 191 149 249 238 43 177 186 197 187 129 0 186 194 206 209 209 203 249 238 67 255 255 211 226 226 221 235 235 229 100 103 111 76 93 127 255 255 112 88 104 139 130 135 148 149 155 158 247 218 0 224 194 126 255 217 0 228 184 0 13 30 68 161 138 32 204 152 0 255 255 53 206 155 18 207 207 201 255 250 72 255 255 82 209 176 59 232 232 227 243 243 236 245 245 240 255 255 115 255 255 251]; mask:((Depth1Image new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@G8@@O<@@_>@@^^@@\N@@\N@@?? @?? @?? @?? @?? @?? @?? @?? @_?@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

releaseViewIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self releaseViewIcon inspect
     ImageEditor openOnClass:self andSelector:#releaseViewIcon
     Icon flushCachedIcons
    "
    <resource: #image>

    ^Icon
        constantNamed:'Tools::ViewTreeInspectorApplication releaseViewIcon'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@A8^G!!7O3ACP5*P@@A8^G @@@@@@@@@@@A8^@@@OE0/!!P0S#0@@^G @@@@@@@@@@@B (@@''D#48"1.CX5H@(J@@@@@@@@@@@@B (@@@@@@"
''%!!/P7,@(J@@@@@@@@@@@@@%I@@@@BH%IRTQV5P@IRT@@@@@@@@@@@ANSP@@@@ANS$8:T80@S$8@@@@@@@@@@@AN&UYWK(EYQ@\FUPQHXT8@@@@@@@@@@@AN
HC2!!TVY:Y#-%I*IKMD8@@@@@@@@@@@A$\@83XBEG%).GGX _!!&P@@@@@@@@@@@AO[P5+ &(WPYN@["!!E\$<@@@@@@@@@@@B_F''FQPAXX_!!&TGH4HB9<@@@@@
@@@@@@B_%3HCJ7=BKPU,Q)01B9<@@@@@@@@@@@@PBP8T_F!!''JPI)_Y"D&!!@@@@@@@@@@@@@$B)I9TGXO''WQIWQ93W0@@@@@@@@@@@@@$"U=JR$)JR$)JR$)_
"P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[132 141 152 147 150 154 250 223 1 246 214 0 205 172 133 238 195 0 213 180 146 217 186 150 188 136 0 206 151 0 183 125 9 208 208 202 196 204 214 255 255 210 255 255 219 210 178 65 242 242 235 106 112 117 96 107 126 250 255 255 255 241 0 154 154 151 255 227 0 67 35 0 52 17 0 253 211 0 208 159 0 167 178 193 222 168 0 248 231 45 208 174 26 199 152 26 225 184 36 255 249 75 220 220 215 77 88 108 241 241 235 245 245 239 255 250 109 242 249 255 255 255 142 255 237 1 142 148 162 242 212 1 143 154 176 174 133 0 222 189 144 169 179 192 177 184 193 184 129 0 255 255 194 253 241 60 210 210 205 214 214 209 77 83 92 230 230 225 98 106 114 243 243 238 117 117 114 255 252 115 255 255 255 115 123 147 130 140 156 152 156 159 241 210 0 53 18 0 151 116 0 162 170 184 218 187 150 193 143 4 220 165 0 206 188 46 181 130 21 204 173 44 206 206 201 208 167 44 72 84 108 240 240 234 244 244 238 243 243 237 212 182 79 255 255 126 131 135 141 119 133 159 132 141 163 195 162 126 219 188 133 218 185 135 180 180 176 221 190 150 175 181 191 176 183 196 181 189 201 202 170 38 209 209 204 207 207 202 251 241 74 229 229 224 238 238 233 226 234 245 244 244 237 255 251 113 255 255 124 255 241 2 255 234 3 249 219 0 255 249 29 252 243 30 227 181 0 212 165 5 222 170 0 173 179 194 216 171 19 255 255 198 208 208 203 156 90 7 206 175 50 91 91 95 211 180 71 242 242 237 246 246 241 212 182 80 255 255 123 129 137 152 255 239 8 251 223 0 59 25 0 251 215 0 228 183 0 222 191 149 249 238 43 177 186 197 187 129 0 186 194 206 209 209 203 249 238 67 255 255 211 226 226 221 235 235 229 100 103 111 76 93 127 255 255 112 88 104 139 130 135 148 149 155 158 247 218 0 224 194 126 255 217 0 228 184 0 13 30 68 161 138 32 204 152 0 255 255 53 206 155 18 207 207 201 255 250 72 255 255 82 209 176 59 232 232 227 243 243 236 245 245 240 255 255 115 255 255 251]; mask:((Depth1Image new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@G8@@O<@@O>@@@^@@@N@@@N@@?? @?? @?? @?? @?? @?? @?? @?? @_?@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
! !

!ViewTreeInspectorApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ViewTreeInspectorApplication andSelector:#windowSpec
     Tools::ViewTreeInspectorApplication new openInterface:#windowSpec
     Tools::ViewTreeInspectorApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'View Tree Inspector'
         name: 'View Tree Inspector'
         min: (Point 10 10)
         max: (Point 1024 9999)
         bounds: (Rectangle 0 0 693 643)
         menu: menu
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'toolbarMenu'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 40 0)
             menu: toolbarMenu
             textDefault: true
           )
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0.0 40 0.0 0 1.0 0 1.0)
             component: 
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'PathAndListPane'
                   component: 
                  (SpecCollection
                     collection: (
                      (ViewSpec
                         name: 'PathPane'
                         layout: (LayoutFrame 0 0 0 0 0 1 25 0)
                         component: 
                        (SpecCollection
                           collection: (
                            (InputFieldSpec
                               name: 'Path'
                               layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                               model: path
                               acceptOnReturn: true
                               acceptOnTab: true
                               acceptOnPointerLeave: true
                               emptyFieldReplacementText: 'No View Selected'
                             )
                            )
                          
                         )
                       )
                      (HierarchicalListViewSpec
                         name: 'List'
                         layout: (LayoutFrame 0 0 25 0 0 1 0 1)
                         level: 1
                         model: model
                         menu: middleButtonMenu
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         miniScrollerHorizontal: true
                         miniScrollerVertical: false
                         listModel: listOfItems
                         multipleSelectOk: true
                         useIndex: false
                         highlightMode: label
                         showLeftIndicators: false
                         indicatorSelector: indicatorClicked:
                         useDefaultIcons: false
                         postBuildCallback: postBuildTree:
                       )
                      )
                    
                   )
                 )
                (ViewSpec
                   name: 'Box2'
                   component: 
                  (SpecCollection
                     collection: (
                      (TabViewSpec
                         name: 'TabHeader1'
                         layout: (LayoutFrame 0 0.0 0 0 0 1.0 25 0)
                         model: inspectorModeIndexHolder
                         menu: inspectorModes
                         useIndex: true
                         translateLabel: true
                       )
                      (SubCanvasSpec
                         name: 'Browser'
                         layout: (LayoutFrame 0 0 26 0 0 1 0 1)
                         visibilityChannel: browserVisibleHolder
                         hasHorizontalScrollBar: true
                         hasVerticalScrollBar: true
                         majorKey: #'Tools::NewSystemBrowser'
                         minorKey: singleClassWithoutVariableListBrowserSpec
                         createNewApplication: true
                         createNewBuilder: true
                         postBuildCallback: postBuildBrowserCanvas:
                       )
                      (ViewSpec
                         name: 'Inspector'
                         layout: (LayoutFrame 0 0 26 0 0 1 0 1)
                         visibilityChannel: inspectorVisibleHolder
                         postBuildCallback: postBuildInspectorView:
                         viewClassName: 'InspectorView'
                       )
                      )
                    
                   )
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          )
        
       )
     )
! !

!ViewTreeInspectorApplication class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."      


    "
     MenuEditor new openOnClass:Tools::ViewTreeInspectorApplication andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(Tools::ViewTreeInspectorApplication menu)) startUp
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
                  label: 'Pick a View'
                  itemValue: doPickView
                )
               (MenuItem
                  enabled: hasTargetWidgetChannel
                  label: 'Release Picked View'
                  itemValue: doUnpick
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Settings'
                  submenu: 
                 (Menu
                    (
                     (MenuItem
                        label: 'Test Mode'
                        hideMenuOnActivated: false
                        indication: testModeChannel
                      )
                     (MenuItem
                        enabled: testModeChannel
                        label: 'Follow Focus'
                        hideMenuOnActivated: false
                        indication: followFocusChannel
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        label: 'Select on Click'
                        hideMenuOnActivated: false
                        indication: selectOnClickHolder
                      )
                     (MenuItem
                        label: '-'
                      )
                     (MenuItem
                        label: 'Show Name of Widgets'
                        hideMenuOnActivated: false
                        indication: showNamesHolder
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
                  label: 'Exit'
                  itemValue: closeRequest
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            enabled: hasSingleSelectionHolder
            label: 'Selection'
            submenuChannel: middleButtonMenu
          )
         (MenuItem
            label: 'Widget'
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasSingleSelectionHolder
                  label: 'Browse'
                  itemValue: doBrowse:
                  argument: view
                )
               (MenuItem
                  enabled: hasSingleSelectionHolder
                  label: 'Inspect'
                  itemValue: doInspect:
                  argument: view
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasTargetWidgetChannel
                  label: 'All Components'
                  startGroup: right
                  submenuChannel: submenuComponents:
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Application'
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Redraw'
                  itemValue: doRedraw
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasSingleSelectionHolder
                  label: 'Browse'
                  itemValue: doBrowse:
                  argument: application
                )
               (MenuItem
                  enabled: hasSingleSelectionHolder
                  label: 'Inspect'
                  itemValue: doInspect:
                  argument: application
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: canBrowseWindowSpecMethod
                  label: 'Browse Window Spec Method'
                  itemValue: doBrowseWindowSpecMethod
                )
               (MenuItem
                  enabled: canEditWindowSpec
                  label: 'Edit Window Spec'
                  itemValue: doEditWindowSpec
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  enabled: hasTargetWidgetChannel
                  label: 'All Applications'
                  submenuChannel: submenuApplications:
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Process'
            submenu: 
           (Menu
              (
               (MenuItem
                  enabled: hasSingleSelectionHolder
                  label: 'Debug'
                  itemValue: doDebugProcess
                )
               (MenuItem
                  enabled: hasSingleSelectionHolder
                  label: 'Inspect'
                  itemValue: doInspect:
                  argument: process
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'Open Process Monitor'
                  itemValue: doOpenProcessMonitor
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Help'
            startGroup: conditionalRight
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application...'
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

middleButtonMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::ViewTreeInspectorApplication andSelector:#middleButtonMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ViewTreeInspectorApplication middleButtonMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Browse View Class'
            itemValue: doBrowse:
            argument: view
          )
         (MenuItem
            label: 'Browse Model Class'
            itemValue: doBrowse:
            isVisible: hasModel
            argument: model
          )
         (MenuItem
            label: 'Browse Application Class'
            itemValue: doBrowse:
            isVisible: hasApplication
            argument: application
          )
         (MenuItem
            label: 'Browse Controller Class'
            itemValue: doBrowse:
            isVisible: hasController
            argument: controller
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Inspect View'
            itemValue: doInspect:
            argument: view
          )
         (MenuItem
            label: 'Inspect Window Group'
            itemValue: doInspect:
            argument: group
          )
         (MenuItem
            label: 'Inspect Model'
            itemValue: doInspect:
            isVisible: hasModel
            argument: model
          )
         (MenuItem
            label: 'Inspect Application'
            itemValue: doInspect:
            isVisible: hasApplication
            argument: application
          )
         (MenuItem
            label: 'Inspect Controller'
            itemValue: doInspect:
            isVisible: hasController
            argument: controller
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Flash'
            itemValue: doFlash
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Destroy'
            itemValue: doDestroy
            labelImage: (ResourceRetriever ToolbarIconLibrary erase16x16Icon 'Destroy')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Geometry'
            submenuChannel: submenuGeometry:
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'Interface'
            submenuChannel: submenuInterface:
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'Visibility'
            submenuChannel: submenuVisibility:
            keepLinkedMenu: true
          )
         (MenuItem
            label: 'Instance Variables'
            submenuChannel: submenuInspector:
            keepLinkedMenu: true
          )
         (MenuItem
            label: '='
          )
         (MenuItem
            label: ''
          )
         (MenuItem
            enabled: selectedComponentHasChildren
            label: 'Applications'
            nameKey: single
            submenuChannel: submenuApplications:
            keepLinkedMenu: true
          )
         (MenuItem
            enabled: selectedComponentHasChildren
            label: 'Components'
            nameKey: single
            submenuChannel: submenuComponents:
            keepLinkedMenu: true
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
     MenuEditor new openOnClass:Tools::ViewTreeInspectorApplication andSelector:#toolbarMenu
     (Menu new fromLiteralArrayEncoding:(Tools::ViewTreeInspectorApplication toolbarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasTargetWidgetChannel
            label: 'Redraw'
            itemValue: doRedraw
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary reloadIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Pick a View and Catch Events'
            itemValue: doPickView
            translateLabel: false
            isButton: true
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary pickWindowIcon)
          )
         (MenuItem
            enabled: hasTargetWidgetChannel
            isVisible: isNotCatchingEventsChannel
            label: 'Catch Events of Picked View'
            activeHelpKey: doCatchEvents
            itemValue: doCatchEvents
            nameKey: doCatchEvents
            isButton: true
            labelImage: (ResourceRetriever nil releaseViewIcon)
          )
         (MenuItem
            enabled: hasTargetWidgetChannel
            isVisible: isCatchingEventsChannel
            label: 'Release Picked View and Uncatch Events'
            activeHelpKey: doUncatchEvents
            itemValue: doUncatchEvents
            nameKey: doUncatchEvents
            isButton: true
            labelImage: (ResourceRetriever nil lockViewIcon)
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            activeHelpKey: doBrowseApplication
            enabled: hasSingleSelectionHolder
            label: 'Browse Application'
            itemValue: doBrowse:
            translateLabel: false
            isButton: true
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary systemBrowser24x24Icon2)
            argument: application
          )
         (MenuItem
            activeHelpKey: doInspectApplication
            enabled: hasSingleSelectionHolder
            label: 'Inspect Application'
            itemValue: doInspect:
            translateLabel: false
            isButton: true
            hideMenuOnActivated: false
            labelImage: (ResourceRetriever ToolbarIconLibrary inspect22x24Icon)
            argument: application
          )
         )
        nil
        nil
      )
! !

!ViewTreeInspectorApplication class methodsFor:'startup'!

openInPickMode
    |app|

    app := self new.
    app open.
    app doPickView.
    ^ app
!

openInPickModeAndRelease
    "release the pick-lock after picking"

    |app|

    app := self openInPickMode.
    app doUncatchEvents.
    ^ app
!

openOn:aView
    "show a particular window's topView hierarchy,
     select the given view"

    |app|

    app := self new.
    app open.
    app showWindow:aView.
    ^ app
! !

!ViewTreeInspectorApplication methodsFor:'actions'!

indicatorClicked:anIndex
    |item sensor|

    item := model listOfItems at:anIndex ifAbsent:nil.

    item notNil ifTrue:[
        (     (sensor := self window sensor) notNil
         and:[(sensor ctrlDown or:[sensor shiftDown])]
        ) ifTrue:[
            item recursiveToggleExpand
        ] ifFalse:[
            item toggleExpand
        ]
    ].
! !

!ViewTreeInspectorApplication methodsFor:'aspects'!

browserVisibleHolder
    "what is shown in the inspector:
     1->Widget
     2->Application
     3->WindowGroup
     4->Sensor
     5->Model 
     6->Widget Class 
     7->Application Class 
    "

    ^ BlockValue
        with:[:v | self inspectorMode == #widgetClass or:[self inspectorMode == #applicationClass] ]
        argument:self inspectorModeIndexHolder
!

canBrowseWindowSpecMethod
    ^ self hasSingleSelectionHolder value and:[ self windowSpecMethodOfSelection notNil ]
!

canEditWindowSpec
    ^ self hasSingleSelectionHolder value and:[ self windowSpecMethodOfSelection notNil ]
!

followFocusChannel
    "boolean holder, which indicates whether selection changed dependend on the focus view"

    ^ followFocusChannel
!

hasSingleSelectionHolder
    "boolean holder, true if one item is selected"

    ^ hasSingleSelectionHolder
!

hasTargetWidgetChannel
    "answer the channel which is set to true if a target widget exists"

    ^ model hasTargetWidgetChannel
!

inspectorMode
    "what is shown in the inspector:
     1->widget
     2->application
     3->WindowGroup
     4->Sensor
     5->Model 
     6->Widget Class 
     7->Application Class 
    "

    |mode|
    mode := inspectorModeIndexHolder value.
    ^ #( widget application group sensor model widgetClass applicationClass) at:mode ifAbsent:#widget

    "Created: / 30-07-2013 / 07:44:59 / cg"
!

inspectorModeIndexHolder
    "what is shown in the inspector:
     1->Widget
     2->Application
     3->WindowGroup
     4->Sensor
     5->Model 
     6->Widget Class 
     7->Application Class 
    "

    ^ inspectorModeIndexHolder

    "Created: / 30-07-2013 / 07:44:07 / cg"
!

inspectorModes
    "/ labels of tabs
    ^ #('Widget' 'Application' 'WindowGroup' 'Sensor' 'Model' 'Widget Class' 'App Class')

    "Created: / 30-07-2013 / 09:42:16 / cg"
!

inspectorVisibleHolder
    "what is shown in the inspector:
     1->Widget
     2->Application
     3->WindowGroup
     4->Sensor
     5->Model 
     6->Widget Class 
     7->Application Class 
    "

    ^ BlockValue
        with:[:v | v not ]
        argument:self browserVisibleHolder
!

isCatchingEventsChannel
    ^ isCatchingEventsChannel
!

isNotCatchingEventsChannel
    ^ BlockValue forLogicalNot:self isCatchingEventsChannel
!

listOfItems
    "returns the hierarchical list of items"

    ^ model listOfItems
!

model
    "returns my selection model, a ViewTreeModel"

    ^ model
!

path
    <resource: #uiAspect>

    path isNil ifTrue:[
        path := PluggableAdaptor 
                    on: self model 
                    getter:[ :model | model path ]
                    setter:[ :model :newValue |  ]
    ].
    ^ path.

    "Modified: / 19-05-2014 / 18:40:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectOnClickHolder
    "boolean holder, which indicates whether the selection will change on click"

    ^ model selectOnClickHolder
!

showNamesHolder
    "boolean holder, which indicates whether application names or widget names
     as additional text are shown for the items"

    ^ showNamesHolder
!

testModeChannel
    "answer a boolean channel which describes the behaviour how to process
     events on the target view.

     false: all input events are eaten and the selection is shown on the target view.
     true:  no  input events are eaten and no  selection is shown on the target view."

    ^ model testModeChannel
!

windowSpecMethodOfSelection
    |item view app nonMeta meta masterApp
     spec builder specSelector implementors|

    item := model selectedItem.
    item isNil ifTrue:[^ nil]. 

    view := item widget.
    view isNil ifTrue:[^ nil]. 

    app := view application.
    app isNil ifTrue:[^ nil]. 
    
    builder := app builder.
    builder isNil ifTrue:[^ nil]. 

    spec := builder spec.
    spec isNil ifTrue:[^ nil].

    specSelector := spec name.
    specSelector isNil ifTrue:[^ nil].

    ((nonMeta := app class theNonMetaclass) canUnderstand:specSelector) ifTrue:[
        ^ nonMeta lookupMethodFor:specSelector.
    ].
    ((meta := app class theMetaclass) canUnderstand:specSelector) ifTrue:[
        ^ meta lookupMethodFor:specSelector.
    ].

    "/ maybe a simple dialog given a spec
    (masterApp := app masterApplication) notNil ifTrue:[
        ((nonMeta := masterApp class theNonMetaclass) canUnderstand:specSelector) ifTrue:[     
            ^ nonMeta lookupMethodFor:specSelector.
        ].
        ((meta := masterApp class theMetaclass) canUnderstand:specSelector) ifTrue:[    
            ^ meta lookupMethodFor:specSelector.
        ].
    ].

    implementors := Smalltalk allImplementorsOf: specSelector.
    implementors size == 1 ifTrue:[
        ^ implementors first compiledMethodAt:specSelector.
    ].

    ^ nil
! !

!ViewTreeInspectorApplication methodsFor:'change & update'!

inspectorModeIndexHolderChanged
    self updateInspector

    "Created: / 30-07-2013 / 09:21:51 / cg"
!

selectionChanged
    |info view item|

    item := model selectedItem.
    item notNil ifTrue:[ 
        |state|

        view := item widget.

        view id isNil ifTrue:[
            state := 'no ID'.
        ] ifFalse:[
            view shown ifTrue:[
                state := 'visible'.
            ] ifFalse:[
                state := 'invisible'
            ].
        ].
        info := '%1 [%2] - %3' bindWith:(view class name)
                                   with:(view name ? '') with:state allBold.
    ] ifFalse:[
        info := ''
    ].
    hasSingleSelectionHolder value:(view notNil).
    self updateInspector

    "Modified: / 30-07-2013 / 09:21:27 / cg"
!

update:something with:someArgument from:aModel
    |oldSelection|

    aModel == showNamesHolder ifTrue:[
        oldSelection := model selectedItem.
        model selectedItem:nil.
        self listOfItems showWidgetNames:(aModel value).
        model selectedItem:oldSelection.
        ^ self
    ].

    aModel == model ifTrue:[
        self selectionChanged.
        ^ self
    ].

    super update:something with:someArgument from:aModel.
!

updateBrowser
    |cls widget|

    widget := self selectedView.
    
    "/ update the browser
    self inspectorMode == #widgetClass ifTrue:[
        cls := widget class.
    ] ifFalse:[
        cls := widget application class
    ].    
    browser switchToClass:cls selector:nil.
!

updateInspector
    |view mode obj|

    view := self selectedView.
    mode := self inspectorMode.
    
    ((mode == #widgetClass) or:[(mode == #applicationClass)]) ifTrue:[
        "/ update the browser
        view notNil ifTrue:[
            self updateBrowser.
        ].
        ^ self.
    ].
    
    (view isNil or:[mode == #widget]) ifTrue:[
        obj := view.
    ] ifFalse:[ (mode == #group) ifTrue:[
        obj := view windowGroup
    ] ifFalse:[ (mode == #sensor) ifTrue:[
        obj := view sensor
    ] ifFalse:[ (mode == #model) ifTrue:[
        obj := view model
    ] ifFalse:[
        obj := view application.
    ]]]].
    inspectorView inspect:obj.
    inspectorView headLineLabel:(obj class nameWithoutPrefix)

    "Created: / 30-07-2013 / 09:21:16 / cg"
! !

!ViewTreeInspectorApplication methodsFor:'event processing'!

processButtonMotionEvent:ev
    |click rootView|

    motionAction isNil ifTrue:[^ self].

    (rootView := model rootView) isNil ifTrue:[
        clickedItem := motionAction := nil.
        ^ self
    ].

    click := rootView device
            translatePoint:((ev x)@ (ev y))
            fromView:(ev view)
            toView:rootView.

    click = clickedPoint ifFalse:[
        (clickedItem isNil or:[(click dist:clickedPoint) > 5.0]) ifTrue:[
            motionAction value:click
        ]
    ].
!

processButtonPressEvent:ev
    |rootView sensor lastRectangle|

    rootView    := model rootView.
    sensor      := model rootView sensor.
    clickedItem := model listOfItems detectItemRespondsToView:(ev view).

    (sensor ctrlDown or:[sensor shiftDown]) ifTrue:[
        clickedItem notNil ifTrue:[
            self selectOnClickHolder value ifTrue:[
                model toggleSelectItem:clickedItem
            ].
        ].
        clickedItem := motionAction := nil.
        ^ self
    ].

    clickedPoint := rootView device translatePoint:((ev x)@ (ev y))  fromView:(ev view) toView:rootView.
    lastRectangle := nil.

    motionAction :=[:p|
        rootView    := model rootView device rootView.
        rootView    := model rootView.
        clickedItem := nil.

        rootView xoring:[
            lastRectangle notNil ifTrue:[ rootView displayRectangle:lastRectangle ]
                                ifFalse:[ rootView clippedByChildren:false ].

            p isNil ifTrue:[
                rootView clippedByChildren:true.
                motionAction := nil.
            ] ifFalse:[
                lastRectangle := Rectangle origin:(clickedPoint min:p) corner:(clickedPoint max:p).
                rootView displayRectangle:lastRectangle.
            ].
            rootView flush.
        ].
        lastRectangle
    ].
!

processButtonReleaseEvent:anEvent
    |rootView rectangle newItems widget origin|

    (rootView := model rootView) isNil ifTrue:[
        clickedItem := motionAction := nil.
        ^ self
    ].
    motionAction isNil ifTrue:[ ^ self ].
    clickedItem notNil ifTrue:[ ^ model selectItem:clickedItem ].

    rectangle := motionAction value:nil.
    rectangle isNil ifTrue:[^ self].

    newItems := OrderedCollection new.

    model rootItem recursiveDo:[:anItem|
        widget := anItem widget.
        origin := widget originRelativeTo:rootView.

        (rectangle containsRect:(Rectangle origin:origin extent:(widget extent))) ifTrue:[
            newItems add:anItem.
        ]
    ].
    model value:newItems.
!

processEvent:anEvent
    |button menu|

    anEvent isKeyPressEvent ifTrue:[ self processKeyPressEvent:anEvent. ^ self  ].
    anEvent isButtonEvent  ifFalse:[ ^ self ].

    button := anEvent button.

    (button == 2 or:[button == #menu]) ifTrue:[
        motionAction isNil ifTrue:[
            anEvent isButtonPressEvent ifTrue:[
                self selectOnClickHolder value ifTrue:[
                    menu := self middleButtonMenu value.
                    menu notNil ifTrue:[
                        menu := MenuPanel 
                                    menu:(Menu new fromLiteralArrayEncoding:menu)
                                    receiver:self.
                        menu startUp.
                    ]
                ].
            ].
            clickedItem := nil.
        ].
        ^ self
    ].

    anEvent isButtonPressEvent  ifTrue:[ self processButtonPressEvent:anEvent. ^ self ].
    anEvent isButtonMotionEvent ifTrue:[ self processButtonMotionEvent:anEvent. ^ self ].

    anEvent isButtonReleaseEvent ifTrue:[
        self selectOnClickHolder value ifTrue:[
            self processButtonReleaseEvent:anEvent
        ].
    ].
    clickedItem := motionAction := nil.

    anEvent type == #'buttonMultiPress:x:y:' ifTrue:[
        self selectOnClickHolder value ifTrue:[
            self doInspect:#view.
        ].
    ].
!

processKeyPressEvent:anEvent
    |item prnt idx key max next|

    key := anEvent key.
    key isSymbol ifFalse:[^ self].

    key == #Delete    ifTrue:[ ^ self doDestroy ].
    key == #InspectIt ifTrue:[ ^ self doInspect:#view ].

    (   key == #CursorUp
    or:[key == #CursorDown
    or:[key == #CursorLeft
    or:[key == #CursorRight]]]
    ) ifFalse:[
        ^ self
    ].
    item := model selectedItem.

    item isNil ifTrue:[
        ^ model selectedItem:(model first ? model rootItem)
    ].

    prnt := item parent.
    prnt isNil ifTrue:[
        "/ is the root item
        (key == #CursorUp or:[key == #CursorLeft]) ifTrue:[item := model listOfItems last]
                                                  ifFalse:[item := item at:1 ifAbsent:item].

        ^ model selectedItem:item
    ].
    key == #CursorLeft ifTrue:[ ^ model selectedItem:prnt ].

    key == #CursorRight ifTrue:[
        next := item at:1 ifAbsent:nil.
        next notNil ifTrue:[ model selectedItem:next ].
        ^ self
    ].

    max := prnt size.

    key == #CursorUp ifTrue:[
        idx := prnt identityIndexOf:item.
        idx == 1 ifTrue:[idx := max + 1].
        model selectedItem:(prnt at:idx - 1).
        ^ self.
    ].

    key == #CursorDown ifTrue:[
        idx := prnt identityIndexOf:item.
        idx == max ifTrue:[idx := 0].
        model selectedItem:(prnt at:idx + 1).
        ^ self.
    ].
!

processMappedView:aView
    |parent anchor|

    parent := self listOfItems detectItemRespondsToView:aView.
    parent isNil ifTrue:[ ^ self ].

    NotFoundSignal handle:[:ex|
        "contained subvies used by spec are not yet created;
         thus we have to wait until last used subview is build
        "
        anchor := nil.
    ] do:[
        anchor := parent class buildViewsFrom:(parent widget).
    ].
    anchor notNil ifTrue:[
        parent updateFromChildren:anchor children.
    ].
! !

!ViewTreeInspectorApplication methodsFor:'initialization & release'!

closeDownViews
    "release the grapped application"

    process := nil.
    super closeDownViews.
    self doUnpick.
!

initialize
    "setup my model and channels"

    super initialize.

    hasSingleSelectionHolder := false asValue.
    followFocusChannel       := false asValue.
    isCatchingEventsChannel  := false asValue.
    inspectorModeIndexHolder := 1 asValue.
    inspectorModeIndexHolder onChangeSend:#inspectorModeIndexHolderChanged to:self.

    model := ViewTreeModel new.
    model inputEventAction:[:ev| self processEvent:ev ].
    model mappedViewAction:[:vw| self processMappedView:vw ].
    model application:self.
    model addDependent:self.


    showNamesHolder := false asValue.
    showNamesHolder addDependent:self.

    "Modified: / 30-07-2013 / 09:20:08 / cg"
!

postBuildBrowserCanvas:aSubCanvas
    browser := aSubCanvas application.

    "/ browser navigationState meta onChangeEvaluate:(self updateBrowser).
    "/ self updateBrowser.
!

postBuildInspectorView:anInspector
    inspectorView := anInspector.
!

postBuildTree:aTree
    treeView := aTree scrolledView.
    "/ treeView hasConstantHeight:true.
!

release
    "release the grapped application"

    super release.
    self doUnpick.
! !

!ViewTreeInspectorApplication methodsFor:'menu queries'!

hasApplication
    "returns true if the current selected view has an application"

    |view|

    view := self selectedView.
  ^ (view notNil and:[view application notNil])
!

hasController
    "returns true if the current selected item's view has a controller
     other than nil or the view itself"

    |view controller|

    view := self selectedView.

    view notNil ifTrue:[
        controller := view controller.
      ^ (controller notNil and:[controller ~~ view])
    ].
    ^ false
!

hasModel
    "returns true if the current selected view has a model"

    |view|

    view := self selectedView.
  ^ (view notNil and:[view model notNil])
! !

!ViewTreeInspectorApplication methodsFor:'menu specs'!

middleButtonMenu
    "returns the middleButton menu for the single selected item or nil"

    ^ [ 
        model selectedItem notNil 
            ifTrue:[self class middleButtonMenu]
            ifFalse:[nil]
      ]
!

submenuApplications:aMenu
    |applications menu item list addBlock|

    item := aMenu selection nameKey == #single ifTrue:[model selectedItem]
                                              ifFalse:[model rootItem].
    item isNil ifTrue:[^ nil].

    applications := IdentityDictionary new.

    addBlock := [:el| |cls ctr|
        cls := self resolveApplicationClassFor:el.

        cls notNil ifTrue:[
            ctr := applications at:cls ifAbsent:0.
            applications at:cls put:(ctr + 1).
        ].
    ].
    item recursiveDo:addBlock.
    addBlock value:item.

    applications isEmpty ifTrue:[^ nil ].
    list := SortedCollection sortBlock:[:a :b| a title < b title ].

    applications keysAndValuesDo:[:cls :ctr|
       list add:(MenuDesc title:(cls name)
                          value:(ctr printString)
                         action:[self doSelectNextOfApplicationClass:cls startingIn:item]
                 ).
    ].

    menu := MenuDesc buildFromList:list onGC:aMenu.
    menu do:[:el|
        el hideMenuOnActivated:false
    ].
    ^ menu
!

submenuComponents:aMenu
    |widgets list total menu item|

    item := aMenu selection nameKey == #single ifTrue:[model selectedItem]
                                              ifFalse:[model rootItem].
    item isNil ifTrue:[^ nil].

    widgets := IdentityDictionary new.
    total   := 0.

    item recursiveDo:[:el| |cls ctr|
        cls := el widget.

        cls notNil ifTrue:[
            cls := cls class.
            ctr := widgets at:cls ifAbsent:0.
            widgets at:cls put:(ctr + 1).
            total := total + 1.
        ].
    ].
    total == 0 ifTrue:[^ nil].
    list := SortedCollection sortBlock:[:a :b| a title < b title ].

    widgets keysAndValuesDo:[:cls :ctr|
        list add:(MenuDesc title:(cls name)
                           value:(ctr printString)
                          action:[self doSelectNextOfClass:cls startingIn:item]
                 ).
    ].
    list := list asOrderedCollection.
    list add:(MenuDesc separator).
    list add:(MenuDesc title:'Total' value:(total printString)).
    menu := MenuDesc buildFromList:list onGC:aMenu.
    menu do:[:el|
        el hideMenuOnActivated:false
    ].
    ^ menu
!

submenuGeometry:aMenu
    "builds and returns the geometry submenu"

    |view point inst list x y|

    view := self selectedView.
    view isNil ifTrue:[^ nil].

    list := OrderedCollection new.

    "/ origin
    point := view relativeOrigin.
    point isNil ifTrue:[ point := view origin ].

    x := view left.
    y := view top.

    (x == point x and:[y == point y]) ifTrue:[ inst := point ]
                                     ifFalse:[ inst := '%1 --> (%2@%3)' bindWith:point with:x with:y ].

    list add:(MenuDesc title:'origin' value:inst).

    "/ corner
    point := view relativeCorner.
    point isNil ifTrue:[ point := view corner ].

    x := view right.
    y := view bottom.

    (x == point x and:[y == point y]) ifTrue:[ inst := point ]
                                     ifFalse:[ inst := '%1 --> (%2@%3)' bindWith:point with:x with:y ].

    list add:(MenuDesc title:'corner' value:inst).

    "/ extent
    (point := view relativeExtent) isNil ifTrue:[point := view extent].
    list add:(MenuDesc title:'extent' value:point).

    "/ preferred extent
    list add:(MenuDesc title:'pref. extent' value:(view preferredExtent)).
    list add:(MenuDesc separator).

    "/ view insets
    inst := 'l:%1  r:%2  t:%3  b:%4' bindWith:(view leftInset)
                                         with:(view rightInset)
                                         with:(view topInset)
                                         with:(view bottomInset).

    list add:(MenuDesc title:'insets'      value:inst).
    list add:(MenuDesc title:'borderWidth' value:(view borderWidth)).
    list add:(MenuDesc title:'level'       value:(view level)).
    list add:(MenuDesc separator).

    (inst := view layout) notNil ifTrue:[ inst := inst displayString ].
    list add:(MenuDesc title:'layout' value:inst).

    (inst := view transformation) notNil ifTrue:[ inst := inst displayString ].
    list add:(MenuDesc title:'transformation' value:inst).

    (view isKindOf:Label) ifTrue:[
        list add:(MenuDesc separator).
        (inst := view adjust) notNil ifTrue:[ inst := inst displayString ].
        list add:(MenuDesc title:'adjust' value:inst).
    ].
    (view isKindOf:PanelView) ifTrue:[
        list add:(MenuDesc separator).
        (inst := view horizontalLayout ) notNil ifTrue:[ inst := inst displayString ].
        list add:(MenuDesc title:'horizontalLayout' value:inst).
        (inst := view verticalLayout ) notNil ifTrue:[ inst := inst displayString ].
        list add:(MenuDesc title:'verticalLayout' value:inst).
    ].

    ^ MenuDesc buildFromList:list onGC:aMenu
!

submenuInspector:aMenu
    "builds and returns the inspector submenu"

    |view list n names label value indices|

    view := self selectedView.
    view isNil ifTrue:[^ nil].

    n := view class instSize.
    n > 0 ifFalse:[^ nil ].

    list  := OrderedCollection new:n.
    names := view class allInstVarNames.
    indices := (1 to:names size) asArray.
    names sortWith:indices.

    1 to:n do:[:i| |action|
        label := (names at:i) printString.
        value := view instVarAt:(indices at:i).
        value isNil ifTrue:[
            value  := '------'.
            action := nil.
        ] ifFalse:[
            value  := value displayString contractAtEndTo:40.
            action := [(view instVarAt:i) inspect].
        ].
        list add:(MenuDesc title:label value:value action:action).
    ].

    ^ MenuDesc buildFromList:list onGC:aMenu

    "Modified: / 31-07-2013 / 13:12:52 / cg"
!

submenuInterface:aMenu
    "builds and returns the interface submenu"

    |view label inst value list|

    view := self selectedView.
    view isNil ifTrue:[^ nil].

    list := OrderedCollection new.

    inst  := view controller.
    value := nil.

    inst isNil ifTrue:[
        label := nil
    ] ifFalse:[
        inst == view ifTrue:[ 
            label := '== view itself' 
        ] ifFalse:[ 
            label := inst displayString.
            value := [view controller inspect].
        ].
    ].
    list add:(MenuDesc title:'controller' value:label action:value).

    inst := view delegate.
    inst notNil ifTrue:[
        list add:(MenuDesc title:'delegate' value:(inst displayString) action:[ view delegate inspect ]).
    ].

    inst := view application.

    inst notNil ifTrue:[ 
        |topAppl|

        list add:(MenuDesc title:'application' value:inst action:[ view application inspect ]).

        topAppl := inst topApplication.

        (topAppl notNil and:[topAppl ~~ inst]) ifTrue:[
            list add:(MenuDesc title:'topApplication' value:topAppl action:[ inst topApplication inspect ]).
        ].
    ].
    list add:(MenuDesc separator).

    (view respondsTo:#'model') ifTrue:[
        inst := view model.

        inst isNil 
            ifTrue:[ label := value := nil ]
            ifFalse:[ label := inst displayString.
                      label := label,(self aspectLabelFor:inst inApplicationOf:view).  
                      value := [ view model inspect ].
                    ].

        list add:(MenuDesc title:'model' value:label action:value).

        (inst notNil and:[view respondsTo:#modelInterface]) ifTrue:[
            view modelInterface keysAndValuesDo:[:key : val|
                val isNil ifTrue:[ label := nil ]
                         ifFalse:[ label := val displayString ].

                list add:(MenuDesc title:('      - ', key) value:label ).
            ]
        ].
    ].

    (view respondsTo:#enableChannel) ifTrue:[
        inst := view enableChannel.

        inst isNil ifTrue:[ label := value := nil ]
                  ifFalse:[ label := inst displayString.
                            label := label,(self aspectLabelFor:inst inApplicationOf:view).  
                            value := [ view enableChannel inspect ].
                          ].

        list add:(MenuDesc title:'enableChannel' value:label action:value).
    ].

    #( #action #pressAction #releaseAction ) do:[:actionSelector |
        (view respondsTo:actionSelector) ifTrue:[
            inst := view perform:actionSelector.

            inst isNil 
                ifTrue:[ label := value := nil ]
                ifFalse:[ label := inst displayString.
                            value := [ (view perform:actionSelector) inspect ].
                        ].

            list add:(MenuDesc title:actionSelector"'action'" value:label action:value).
        ].
    ].

    list last isSeparator ifFalse:[ list add:(MenuDesc separator) ].

    (view respondsTo:#listHolder) ifTrue:[
        inst := view listHolder.

        inst isNil ifTrue:[ label := value := nil ]
                  ifFalse:[ label := inst class printString.
                            label := label,(self aspectLabelFor:inst inApplicationOf:view).  
                            value := [ view listHolder inspect ].
                          ].
        list add:(MenuDesc title:'listHolder' value:label action:value).
    ].

    (view respondsTo:#list) ifTrue:[
        inst := view list.

        inst isNil ifTrue:[ label := value := nil ]
                  ifFalse:[ label := '%1 [%2]' bindWith:(inst class printString) with:(inst size).
                            label := label,(self aspectLabelFor:inst inApplicationOf:view).  
                            value := [ view list inspect ].
                          ].

        list add:(MenuDesc title:'list' value:label action:value).
    ].

    list last isSeparator ifTrue:[ list removeLast ].
    ^ MenuDesc buildFromList:list onGC:aMenu

    "Modified: / 31-07-2013 / 13:09:55 / cg"
!

submenuVisibility:aMenu
    "builds and returns the geometry submenu"

    |view list value|

    view := self selectedView.
    view isNil ifTrue:[^ nil].

    list := OrderedCollection new.

    list add:(MenuDesc title:'device'     value:(view device printString)).
    list add:(MenuDesc title:'drawableId' value:(view id)).
    list add:(MenuDesc title:'gcId'       value:(view gcId)).

    list add:(MenuDesc separator).

    list add:(MenuDesc title:'shown'    value:(view shown)).
    list add:(MenuDesc title:'realized' value:(view realized)).

    list add:(MenuDesc separator).

    list add:(MenuDesc title:'hiddenOnRealize' value:(view isHiddenOnRealize)).

    (value := view visibilityChannel) isNil ifTrue:[
        list add:(MenuDesc title:'visibilityChannel' value:'------').
    ] ifFalse:[
        list add:(MenuDesc title:'visibilityChannel'
                           value:(value displayString)
                          action:[view visibilityChannel inspect]).
    ].

    ^ MenuDesc buildFromList:list onGC:aMenu
! !

!ViewTreeInspectorApplication methodsFor:'private'!

aspectLabelFor:aModel inApplicationOf:aView
    |app|

    aModel isNil ifTrue:[^ ''].
    aView isNil ifTrue:[^ ''].
    (app := aView application) isNil ifTrue:[^ ''].
    app builder bindings keysAndValuesDo:[:aspect :value |
        value == aModel ifTrue:[^ ' [aspect: ',aspect,']'].
    ].
    app class allInstVarNames do:[:nm | 
        (app instVarNamed:nm) == aModel ifTrue:[^ ' [instvar: ',nm,']']
    ].

    ^ ''

    "Created: / 27-04-2012 / 14:22:09 / cg"
!

selectFocusView
    |rootView focusView|

    rootView := model rootView.

    (rootView notNil and:[rootView shown]) ifTrue:[
        focusView := rootView windowGroup focusView.
    ].
    focusView isNil ifTrue:[^ self ].

    self selectView:focusView
!

selectView:aView
    |currentItem viewItem|

    currentItem := model selectedItem.

    (currentItem notNil and:[currentItem widget == aView]) ifTrue:[
        ^ self
    ].
    viewItem := model listOfItems recursiveDetect:[:el| el widget == aView ].

    viewItem notNil ifTrue:[
        model selectItem:viewItem.
    ].        
!

setRootItem:aRootItemOrNil
    |theProcess|

    aRootItemOrNil isNil ifTrue:[
        process := nil.
    ] ifFalse:[
        "/ expand tree to level 3
        aRootItemOrNil do:[:aRootChild|
            aRootChild do:[:aSubChild| aSubChild expand ].
            aRootChild expand.
        ].
        aRootItemOrNil expand.

        process isNil ifTrue:[
            theProcess := process :=
                Process 
                    for:[   
                        |update testModeChannel|

                        update := false.
                        testModeChannel := model testModeChannel.

                        [process == theProcess] whileTrue:[
                            Delay waitForSeconds:0.5.

                            (treeView notNil and:[process == theProcess and:[treeView shown]]) ifTrue:[
                                (testModeChannel value == true and:[followFocusChannel value == true]) ifTrue:[
                                    self selectFocusView.
                                ].
                                update ifTrue:[
                                    self updateShownStatus.
                                ].
                                update := update not.
                            ].
                        ].
                    ] 
                    priority:(Processor userSchedulingPriority).
            theProcess name:'ViewTreeInspector - Focus Follower'.
            theProcess resume.
        ].
    ].
    model rootItem:aRootItemOrNil.

    "Modified: / 25-07-2013 / 12:03:44 / cg"
!

updateShownStatus
    |rootItem min max visState listIdx visY0 visY1 height damage|

    rootItem := model rootItem.
    (rootItem notNil and:[rootItem widget shown]) ifFalse:[^ self].

    max := 0.
    min := 9999999.

    rootItem recursiveEachVisibleItemDo:[:anItem|
        visState := (anItem widget shown).

        visState ~~ anItem isDrawnShown ifTrue:[
            anItem isDrawnShown:visState.
            listIdx := treeView identityIndexOf:anItem.

            listIdx > 0 ifTrue:[    
                max := max max:listIdx.
                min := min min:listIdx.
            ].
        ].
    ].
    max < min ifTrue:[^ self].
    max := max + 1.

    visY0  := (treeView yVisibleOfLine:min) max:0.
    visY1  := (treeView yVisibleOfLine:max) min:(treeView height).
    height := visY1 - visY0.
    
    height > 2 ifTrue:[
        treeView shown ifTrue:[
            damage := Rectangle left:0 top:visY0 width:(treeView width) height:height.
            treeView invalidateDeviceRectangle:damage repairNow:false.
        ].
    ].
! !

!ViewTreeInspectorApplication methodsFor:'selection'!

selectedView
    "answer the selected view or nil"

    |item|

    item := model selectedItem.
    item notNil ifTrue:[ ^ item widget ].
  ^ nil
! !

!ViewTreeInspectorApplication methodsFor:'testing'!

resolveApplicationClassFor:aTreeItem
    aTreeItem isApplicationClass ifTrue:[
       ^ aTreeItem applicationClass
    ].
    ^ nil
!

selectedComponentHasChildren
    |item|

    item := model selectedItem.
    ^ (item notNil and:[item hasChildren])
! !

!ViewTreeInspectorApplication methodsFor:'user operations'!

doBrowse:what
    "open browser on:
        #view           browse class
        #model          browse model class
        #application    browse application class
        #controller     browse controller class
    "
    |inst|

    (inst := self objectToInspectOrBrowse:what) isNil ifTrue:[^ self].
    inst class browserClass openInClass:(inst class) selector:nil

    "Modified: / 28-08-2013 / 23:57:42 / cg"
!

doBrowseWindowSpecMethod
    |mthd|

    mthd := self windowSpecMethodOfSelection.
    NewSystemBrowser openInClass:mthd mclass selector:mthd selector
!

doCatchEvents
    model catchEvents:true.
    isCatchingEventsChannel value:true.
"/    ((builder componentAt:'toolbarMenu') itemAt:#doUncatchEvents) 
"/        enabled:true;
"/        label:(self class releaseViewIcon);
"/        activeHelpKey:#doUncatchEvents.
!

doDebugProcess
    "open debugger on the window process"

    |view|

    view := self selectedView.
    view isNil ifTrue:[^ nil].

    Debugger openOn:view windowGroup process
!

doDestroy
    "destroy the current selected view"

    |item parent|

    item := model selectedItem.
    item isNil ifTrue:[ ^ self].

    parent := item parent.

    parent isNil ifTrue:[
        "/ the root
        model withSelectionHiddenDo:[item deleteAll].
      ^ self
    ].

    model withSelectionHiddenDo:[
        |idx nsel|

        idx := parent identityIndexOf:item.

        idx == parent size ifTrue:[
            nsel := parent at:(idx - 1) ifAbsent:parent
        ] ifFalse:[
            nsel := parent at:(idx + 1)
        ].
        model setValue:nil.
        item delete.

        parent isLayoutContainer ifTrue:[
            parent widget sizeChanged:nil
        ].
        model value:nsel.
    ].
!

doEditWindowSpec
    |mthd|

    mthd := self windowSpecMethodOfSelection.
    UIPainter openOnClass:mthd mclass andSelector:mthd selector
!

doFlash
    "flash the selected view"

    |view|

    view := self selectedView.
    view isNil ifTrue:[ ^ self].

    view shown ifTrue:[
        model withSelectionHiddenDo:[
            view perform:#flash ifNotUnderstood:nil.
        ].
    ].
!

doInspect:what
    "open inspector on:
        #view           inspect class
        #group          inspect windowGroup
        #model          inspect model
        #application    inspect application
        #controller     inspect controller
        #process        inspect application's process
    "

    |inst|

    (inst := self objectToInspectOrBrowse:what) isNil ifTrue:[^ self].
    inst inspect.

    "Modified: / 28-08-2013 / 23:58:27 / cg"
!

doOpenProcessMonitor
    (ProcessMonitorV2 ? ProcessMonitor) open

    "Created: / 25-07-2013 / 12:34:23 / cg"
!

doPickView
    "pick a window's topView"

    |screen clickedView topWindow cursor|

    self doUnpick.

    cursor := Cursor fromImage:(self class crossHairIcon).

    screen := Screen current.
    clickedView := screen viewFromPoint:(screen pointFromUserShowing:cursor).
    clickedView isNil ifTrue:[^ self].

    topWindow := clickedView topView.

    (    topWindow == Screen current rootView
     or:[topWindow == self window topView]
    ) ifTrue:[
        ^ self
    ].

    self showWindow:clickedView.
!

doRedraw
    "redraw the app"

    model rootView notNil ifTrue:[
        model rootView withAllSubViewsDo:[:v | v "redraw; "invalidate].
    ]
!

doSelectNextElementStartingIn:anItem forWhich:aBlock
    |startItem firstFound searchNext|

    startItem  := model last.
    searchNext := startItem notNil.        
    firstFound := nil.

    anItem recursiveDo:[:el|
        el == startItem ifTrue:[
            searchNext := false
        ] ifFalse:[
            (aBlock value:el) ifTrue:[
                searchNext ifFalse:[^ model selectItem:el].

                firstFound isNil ifTrue:[
                    firstFound := el
                ]
            ]
        ]
    ].
    firstFound notNil ifTrue:[
        self window beep.
        model selectItem:firstFound
    ].
!

doSelectNextOfApplicationClass:aClass startingIn:anItem
    self doSelectNextElementStartingIn:anItem forWhich:[:el | (self resolveApplicationClassFor:el) == aClass].
!

doSelectNextOfClass:aClass startingIn:anItem
    self doSelectNextElementStartingIn:anItem forWhich:[:el | el widget class == aClass].
!

doUncatchEvents
    "release the inspected window (no longer catch its events)"

    model catchEvents:false.
    isCatchingEventsChannel value:false.
"/    ((builder componentAt:'toolbarMenu') itemAt:#doUncatchEvents) 
"/        label:(self class releaseViewIcon);
"/        enabled:false;
"/        activeHelpKey:#doCatchEvents.
    self doRedraw
!

doUnpick
    "release current picked window and contained subwindows"

    self setRootItem:nil.
!

objectToInspectOrBrowse:what
    "return one of:
        #view           inspect view/widget
        #group          inspect windowGroup
        #model          inspect model
        #application    inspect application
        #controller     inspect controller
        #process        inspect application's process
        #widgetClass    browse widget's class
    "
    |view|

    view := self selectedView.
    view isNil ifTrue:[^ nil].

    what == #group       ifTrue:[ ^ view windowGroup ].
    what == #model       ifTrue:[ ^ view model ].
    what == #controller  ifTrue:[ ^ view controller ].
    what == #process     ifTrue:[ ^ view windowGroup process ].
    what == #sensor      ifTrue:[ ^ view sensor ].
    what == #application ifTrue:[ ^ view application ? view topView ].
    what == #applicationClass ifTrue:[ ^ view application ? view topView ].

    ^ view

    "Modified: / 28-08-2013 / 23:58:27 / cg"
!

openDocumentation
    HTMLDocumentView openFullOnDocumentationFile:'tools/misc/TOP.html#VIEWTREEINSPECTOR'
!

showWindow:aView
    "show a particular window's topView hierarchy,
     select the given view"

    | topWindow |

    topWindow := aView topView.

    self doCatchEvents.
    self setRootItem:(ViewTreeItem buildViewsFrom:topWindow).
    self selectView:aView.
! !

!ViewTreeInspectorApplication::MenuDesc class methodsFor:'building'!

buildFromList:aList onGC:aMenu
    |tabSpec menu w menuPanel|

    w := 0.
    aList do:[:el| w := w max:(el widthOn:aMenu) ].

    tabSpec := TabulatorSpecification new.
    tabSpec unit:#pixel.
    tabSpec positions:#(0     1.5 ).
    tabSpec align:#(#left #left).

    w := w + 15.
    tabSpec positions:(Array with:0 with:w).

    menu := Menu new.

    aList do:[:el|
        menu addItem:(el asMenuItemWithTabulatorSpecification:tabSpec).
    ].
    menuPanel := MenuPanel menu:menu.
    ^ menuPanel
! !

!ViewTreeInspectorApplication::MenuDesc class methodsFor:'instance creation'!

separator
    ^ self new
!

title:aTitle value:aValue
    ^ self title:aTitle value:aValue action:nil
!

title:aTitle value:aValue action:anAction
    ^ self new title:aTitle value:aValue action:anAction
! !

!ViewTreeInspectorApplication::MenuDesc methodsFor:'accessing'!

title
    ^ title
! !

!ViewTreeInspectorApplication::MenuDesc methodsFor:'building'!

asMenuItemWithTabulatorSpecification:aTabSpec
    |array|

    title isNil ifTrue:[ ^ MenuItem label:value ].     "/ separator

    array := Array with:(title, ':') with:'------'.

    value notNil ifTrue:[
        array at:2 put:(value printString, ' ')
    ].

   ^ MenuItem 
        label:(MultiColListEntry fromStrings:array tabulatorSpecification:aTabSpec)
        value:action
! !

!ViewTreeInspectorApplication::MenuDesc methodsFor:'instance creation'!

title:aTitle value:aValue action:anAction
    "test for separator
    "
    title  := aTitle withoutSeparators.
    action := anAction.

    aValue notNil ifTrue:[
        value := aValue printString.

        value size > 70 ifTrue:[
            value := value copyFrom:1 to:70.
            value := value, '...'
        ]
    ].
! !

!ViewTreeInspectorApplication::MenuDesc methodsFor:'queries'!

isSeparator
    ^ title isNil
!

widthOn:aGC
    title isNil ifTrue:[^ 5].  "/ separator
    ^ title widthOn:aGC
! !

!ViewTreeInspectorApplication::ViewTreeItem class methodsFor:'building'!

buildViewsFrom:aView
    "build the items starting from a source view;
     returns the anhor.
    "
    |item subViews subItems|

    aView isNil ifTrue:[^ nil].

    item     := self forView:aView.
    subViews := aView subViews.

    subViews notEmptyOrNil ifTrue:[
        subItems := OrderedCollection new.
        subViews do:[:aSubView|
            subItems add:(self buildViewsFrom:aSubView).
        ].
        item children:subItems.
    ].
    ^ item
! !

!ViewTreeInspectorApplication::ViewTreeItem class methodsFor:'documentation'!

documentation
"
    ViewTreeItems represants a pickable object within a ViewTreeModel.
    The class is used to build up the hierarchical tree.

    [Instance variables:]
        widget        <View>            the widget represented by the item
        spec          <UISpecification> the UISpecification or nil

    [Class variables:]
        HandleExtent  <Point>           keeps the extent of a handle


    [author:]
        Claus Atzkern

    [see also:]
        HierarchicalItem
        ViewTreeModel
"
!

version
    ^ '$Header$'
! !

!ViewTreeInspectorApplication::ViewTreeItem class methodsFor:'initialization'!

initialize
    "set the extent of the Handle
    "
    HandleExtent := 6@6.
! !

!ViewTreeInspectorApplication::ViewTreeItem class methodsFor:'instance creation'!

forView:aView
    |item|

    item := self basicNew initialize.
    item forView:aView.
  ^ item
!

new
    self error:'not allowed'.
  ^ nil
!

on:aView withSpec:aSpec
    |item|

    item := self basicNew initialize.
    item on:aView withSpec:aSpec.
  ^ item
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'accessing'!

applicationClass
    |appl|

    widget notNil ifTrue:[
        appl := widget application.
        appl notNil ifTrue:[^ appl class ].
    ].
    ^ nil
!

isDrawnShown
    "returns true if the last display operations was done during the widget was shown
    "
    ^ isDrawnShown
!

isDrawnShown:aBoolean
    isDrawnShown := aBoolean.
!

rootView
    "returns the widget assigned to the root or nil
    "
    parent isNil ifTrue:[^ nil].

    ^ parent rootView
!

specClass
    "returns the spec-class assigned to the item
    "
    ^ widget specClass
!

treeModel
    "returns the assigned treeModel, an instance of ViewTreeModel
    "
    ^ parent treeModel
!

widget
    "returns the widget assigned to the item
    "
    ^ widget
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'accessing layout'!

boundsRelativeToRoot
    "returns the bounds relative to the root widget
    "
    ^ self originRelativeToRoot extent:(widget extent)
!

cornerRelativeToRoot
    "returns the corner relative to the root widget
    "
    ^ self originRelativeToRoot + (widget extent)
!

extent
    "returns the extent of the widget
    "
    ^ widget extent
!

layoutType
    "returns the type of layout assigned to the wiget; nil if the
     superView cannot resize its sub widgets
    "
    |layout specClass superView|

    (superView := widget superView) isNil ifTrue:[
        ^ #Extent
    ].
        
    specClass := superView specClass.

    (specClass notNil and:[specClass isLayoutContainer]) ifTrue:[
        ^ specClass canResizeSubComponents ifTrue:[#Extent] ifFalse:[nil]
    ].

    (layout := widget geometryLayout) isNil ifTrue:[
        ^ #Extent
    ].

    layout isLayout ifTrue:[
        layout isLayoutFrame        ifTrue:[ ^ #LayoutFrame ].
        layout isAlignmentOrigin    ifTrue:[ ^ #AlignmentOrigin ].
        layout isLayoutOrigin       ifTrue:[ ^ #LayoutOrigin ].
    ] ifFalse:[
        layout isRectangle          ifTrue:[ ^ #Rectangle ].
        layout isPoint              ifTrue:[ ^ #Point ].

    ].
    Transcript showCR:'UNSUPPORTRD LAYOUT: ', layout printString.
  ^ nil
!

originRelativeToRoot
    "returns the origin relative to the root widget
    "
    ^ widget originRelativeTo:(self rootView)
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'accessing optimize'!

children
    "redefined: optimize
    "
    ^ children
!

hasChildren
    |subViews list item|

    children size ~~ 0 ifTrue:[
        ^ true
    ].
    isExpanded := false.
    subViews   := widget subViews.

    subViews size == 0 ifTrue:[^ false].

    list := OrderedCollection new.

    subViews do:[:aSubView|
        item := self class buildViewsFrom:aSubView.
        item parent:self.
        list add:item.
    ].
    children := list.
    ^ true
!

size
    "redefined: returns list of children
    "
    ^ children size
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'displaying'!

additionalLabelForItem:anItem
    "answer an additional label for an Item"

    parent notNil ifTrue:[
        ^ parent additionalLabelForItem:anItem
    ].
    ^ nil
!

displayIcon:anIcon atX:x y:y on:aGC
    |x0 y0 y1 w|

    super displayIcon:anIcon atX:x y:y on:aGC.

    self exists ifFalse:[
        aGC paint:(Color red).

        y0 := y + 1.
        y1 := y + anIcon height - 2.

        x0 := x - 1.
        w  := anIcon width.

        2 timesRepeat:[
            aGC displayLineFromX:x0 y:y0 toX:(x0 + w) y:y1.
            aGC displayLineFromX:x0 y:y1 toX:(x0 + w) y:y0.
            x0 := x0 + 1.
        ].
    ].
!

displayOn:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
    |labelHeight additionalName label isValidAndShown|

    label := self label.
    label isEmptyOrNil ifTrue:[^ self].

    widget id isNil ifTrue:[
        isDrawnShown := false.

        self exists ifFalse:[
            xOffsetAdditionalName := nil.
        ].
        isValidAndShown := false.
    ] ifFalse:[
        isValidAndShown := widget shown.
    ].
    isValidAndShown ifFalse:[
        label := Text string:label emphasis:#italic.
        label colorizeAllWith:Color gray.
    ].

    labelHeight := self heightOn:aGC.
    self displayLabel:label h:labelHeight on:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected.

    xOffsetAdditionalName notNil ifTrue:[
        additionalName := self additionalLabelForItem:self.

        additionalName notNil ifTrue:[
            self displayLabel:additionalName
                            h:labelHeight on:aGC
                            x:(x + xOffsetAdditionalName)
                            y:y
                            h:h.
        ] ifFalse:[
            xOffsetAdditionalName := nil.
        ].
    ].
!

recursiveAdditionalNameBehaviourChanged
    width := xOffsetAdditionalName := nil.

    children notNil ifTrue:[
        children do:[:each| each recursiveAdditionalNameBehaviourChanged ]
    ].
!

widthOn:aGC
    "return the width of the receiver, if it is to be displayed on aGC
    "
    |additionalName|

    width isNil ifTrue:[
        width := self widthOf:(self label) on:aGC.
        width := width + 2.

        additionalName := self additionalLabelForItem:self.

        additionalName notNil ifTrue:[
            xOffsetAdditionalName := width + 10.
            width := xOffsetAdditionalName + (self widthOf:additionalName on:aGC).
            width := width + 2.
        ] ifFalse:[
            xOffsetAdditionalName := nil.
        ].
    ].
    ^ width
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'enumerating'!

handlesDo:aTwoArgAction
    "evaluate the two arg block on each handle; the arguments to the block is
     the rectangle relative to the rootView and the handle type which is
     set to nil if not resizeable.

     TYPES:     type    position( X - Y )
                -------------------------        
                #LT     Left   - Top
                #LC     Left   - Center
                #LB     Left   - Bottom
                #CT     Center - Top
                #CB     Center - Bottom
                #RT     Right  - Top
                #RC     Right  - Center
                #RB     Right  - Bottom

                nil     ** handle not pickable **
    "
    |type relOrg relCrn maxExt rootView w h
     xL    "{ Class:SmallInteger }"
     xC    "{ Class:SmallInteger }"
     xR    "{ Class:SmallInteger }"
     yT    "{ Class:SmallInteger }"
     yC    "{ Class:SmallInteger }"
     yB    "{ Class:SmallInteger }"
    |
    rootView := self rootView.
    rootView isNil ifTrue:[^ self ].

    relOrg   := widget originRelativeTo:rootView.
    relOrg isNil ifTrue:[ ^ self ].    "/ widget destroyed

    relOrg   := relOrg - (HandleExtent // 2).
    relCrn   := relOrg + widget extent.
    maxExt   := rootView extent - HandleExtent.

    xL := relOrg x max:0.
    xR := relCrn x min:(maxExt x).
    xC := xR + xL // 2.

    yT := relOrg y max:0.
    yB := relCrn y min:(maxExt y).
    yC := yB + yT // 2.

    type := self layoutType.
    w   := HandleExtent x.
    h   := HandleExtent y.

    (type == #LayoutFrame or:[type == #Rectangle]) ifTrue:[
        aTwoArgAction value:(Rectangle left:xL top:yT width:w height:h) value:#LT.
        aTwoArgAction value:(Rectangle left:xL top:yC width:w height:h) value:#LC.
        aTwoArgAction value:(Rectangle left:xL top:yB width:w height:h) value:#LB.
        aTwoArgAction value:(Rectangle left:xC top:yT width:w height:h) value:#CT.
        aTwoArgAction value:(Rectangle left:xC top:yB width:w height:h) value:#CB.
        aTwoArgAction value:(Rectangle left:xR top:yT width:w height:h) value:#RT.
        aTwoArgAction value:(Rectangle left:xR top:yC width:w height:h) value:#RC.
        aTwoArgAction value:(Rectangle left:xR top:yB width:w height:h) value:#RB.
      ^ self
    ].

    aTwoArgAction value:(Rectangle left:xL top:yT width:w height:h) value:nil.
    aTwoArgAction value:(Rectangle left:xL top:yB width:w height:h) value:nil.
    aTwoArgAction value:(Rectangle left:xR top:yT width:w height:h) value:nil.

    type == #Extent ifTrue:[
        aTwoArgAction value:(Rectangle left:xC top:yB width:w height:h) value:#CB.
        aTwoArgAction value:(Rectangle left:xR top:yC width:w height:h) value:#RC.
        aTwoArgAction value:(Rectangle left:xR top:yB width:w height:h) value:#RB.
      ^ self
    ].
    aTwoArgAction value:(Rectangle left:xR top:yB width:w height:h) value:nil.
!

recursiveEachVisibleItemDo:anOneArgBlock
    "recursive evaluate the block on each child which is visible
    "
    (isExpanded and:[children size > 0]) ifTrue:[
        children do:[:aChild|
            anOneArgBlock value:aChild.
            aChild recursiveEachVisibleItemDo:anOneArgBlock.
        ]
    ].
!

subViewsDo:aOneArgBlock
    "evaluate aBlock for all subviews other than InputView's   
    "
    |subViews|

    subViews := widget subViews.

    subViews notNil ifTrue:[
        subViews do:aOneArgBlock
    ].
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'initialization'!

forView:aView
    widget := aView.
!

initialize
    "setup default attributes
    "
    super initialize.
    isDrawnShown := false.
    isExpanded   := false.
    children     := OrderedCollection new.
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'operations delete'!

delete
    "delete self and all contained items; the assigned views are destroyed
     in case of rootView, only the children are deleted
    "
    parent isHierarchicalItem ifTrue:[
        self criticalDo:[
            parent remove:self.
            widget destroy.
        ]
    ] ifFalse:[
        self deleteAll
    ].
!

deleteAll
    "delete all contained items; the assigned views are destroyed
    "
    children size == 0 ifTrue:[^ self].

    self criticalDo:[
        self nonCriticalDo:[:el| el widget destroy ].
        self removeAll
    ].
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'operations layout'!

asLayoutFrame
    "convert the layout of the widget to a LayoutFrame;
    "
    |extent layout newLyt lftFrc lftOff topFrc topOff|

    layout := widget geometryLayout.

    layout isNil ifTrue:[
        ^ widget bounds asLayout
    ].

    layout isLayout ifFalse:[
        layout isRectangle ifTrue:[
            ^ LayoutFrame leftOffset:(layout left) rightOffset:(layout right)
                           topOffset:(layout top) bottomOffset:(layout bottom)
        ].
        layout isPoint ifTrue:[
            extent := widget extent.
          ^ LayoutFrame leftOffset:(layout x)  rightOffset:(layout x + extent x)
                         topOffset:(layout y) bottomOffset:(layout y + extent y)
        ].

        Transcript showCR:'UNSUPPORTRD LAYOUT: ', layout printString.
      ^ nil
    ].

    layout isLayoutFrame ifTrue:[ ^ layout copy ].    

    lftFrc := layout leftFraction.
    lftOff := layout leftOffset.
    topFrc := layout topFraction.
    topOff := layout topOffset.
    extent := widget extent.

    newLyt := LayoutFrame leftFraction:lftFrc offset:lftOff
                         rightFraction:lftFrc offset:(lftOff + extent x)
                           topFraction:topFrc offset:topOff
                        bottomFraction:topFrc offset:(topOff + extent y).

    (      layout isAlignmentOrigin
     and:[(layout leftAlignmentFraction ~= 0 or:[layout topAlignmentFraction ~= 0])]
    ) ifTrue:[
        |svRc prBd dlta|

        svRc := widget superView viewRectangle.
        prBd := widget preferredBounds.

        dlta := (  ((layout rectangleRelativeTo:svRc preferred:prBd) corner)
                 - ((newLyt rectangleRelativeTo:svRc preferred:prBd) corner)
                ) rounded.

        newLyt   leftOffset:(lftOff + dlta x).
        newLyt  rightOffset:(lftOff + extent x + dlta x).
        newLyt    topOffset:(topOff + dlta y).
        newLyt bottomOffset:(topOff + extent y + dlta y).
    ].
    ^ newLyt
!

moveLeft:l top:t
    "move the widget n pixele left and right
    "
    |layout|

    self isMoveable ifFalse:[ ^ self ].

    (layout := widget geometryLayout) isNil ifTrue:[
        "Extent"
        widget origin:(widget origin + (l@t)).
      ^ self
    ].

    layout := layout copy.

    layout isLayout ifTrue:[
        layout leftOffset:(layout leftOffset + l)
                topOffset:(layout topOffset  + t).

        layout isLayoutFrame ifTrue:[
            layout  rightOffset:(layout rightOffset  + l).
            layout bottomOffset:(layout bottomOffset + t).
        ]

    ] ifFalse:[
        layout isRectangle ifTrue:[
            layout setLeft:(layout left + l).
            layout  setTop:(layout top  + t).
        ] ifFalse:[
            layout isPoint ifFalse:[^ self].
            layout x:(layout x + l) y:(layout y + t).
        ]
    ].
    widget geometryLayout:layout.
!

resizeLeft:l top:t right:r bottom:b
    "resize the widget measured in pixels
    "
    |layout|

    self isResizeable ifFalse:[
        ^ self
    ].

    (layout := widget geometryLayout) isNil ifTrue:[
        "Extent"
        (r == l and:[b == t]) ifFalse:[
            widget extent:(widget computeExtent + ((r-l) @ (b-t))).
        ].
        ^ self
    ].

    layout isLayout ifTrue:[
        layout := layout copy.

        layout leftOffset:(layout leftOffset + l)
                topOffset:(layout topOffset  + t).

        layout isLayoutFrame ifTrue:[
            layout bottomOffset:(layout bottomOffset + b).
            layout  rightOffset:(layout rightOffset  + r).
        ]
    ] ifFalse:[
        layout isRectangle ifFalse:[^ self].
        layout := layout copy.

        layout left:(layout left   + l)
              right:(layout right  + r)
                top:(layout top    + t)
             bottom:(layout bottom + b).
    ].
    widget geometryLayout:layout.
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'operations update'!

updateChildren
    |queue|

    queue := OrderedCollection new.
    queue add:self.

    self criticalDo:[
        [queue notEmpty] whileTrue:[
            |toRemove  elProcessed|

            elProcessed := queue removeFirst.
            toRemove := nil.
            elProcessed nonCriticalDo:[:el|
                el exists ifTrue:[
                    queue add:el.
                ] ifFalse:[
                    toRemove isNil ifTrue:[toRemove := OrderedCollection new].
                    toRemove add:el.
                ]
            ].
            toRemove notNil ifTrue:[
                toRemove do:[:el| elProcessed remove:el ].
            ].
        ].
    ].
!

updateFromChildren:mergedList
    "update my children against the list of items derived from
     the merged list.
    "

    mergedList size == 0 ifTrue:[ ^ self removeAll ].
    children   size == 0 ifTrue:[ ^ self addAll:mergedList ].

    self criticalDo:[
        self nonCriticalDo:[:el| |wdg|
            wdg := el widget.
            mergedList detect:[:e2| e2 widget == wdg ] ifNone:[ self remove:el ].
        ].

        mergedList keysAndValuesDo:[:i :el| |wdg e2|
            wdg := el widget.

            e2  := self at:i ifAbsent:nil.

            (e2 isNil or:[e2 widget ~~ wdg]) ifTrue:[
                self add:el beforeIndex:i
            ]
        ]
    ].
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'printing & storing'!

icon
    "get the icon used for presentation
    "
    |specClass model|

    specClass := self specClass.
    specClass isNil ifTrue:[^ nil].

    model := self treeModel.

    model notNil ifTrue:[
        ^ model iconAt:specClass ifNonePut:[specClass icon]
    ].
    ^ specClass icon
!

label
    "get the label used for presentation
    "
    ^ self string
!

printOn:aStream
    "append a a printed representation of the item to aStream
    "
    aStream nextPutAll:(self string)
!

string
    "get the string
    "
    ^ widget class name.
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'queries'!

canChangeLayout
    "returns true if the layout of the widget can be changed and the
     layout is not organized by its superView
    "
    ^ self isResizeable
!

canResizeSubComponents
    "returns true if the widget can resize its sub components
    "
    |specClass|

    specClass := self specClass.

    specClass notNil ifTrue:[
        ^ specClass canResizeSubComponents
    ].
    ^ false
!

exists
    widget id notNil ifTrue:[^ true ].

    exists ~~ false ifTrue:[
        exists := false.

        widget superView notNil ifTrue:[
            (parent isHierarchicalItem and:[parent exists]) ifTrue:[
                exists := (parent widget subViews includesIdentical:widget).
            ].
        ].
    ].
    ^ exists
!

isApplicationClass
    |cls|

    cls := widget class.

    ^ (    cls == ApplicationSubView
        or:[cls == ApplicationWindow
        or:[cls == SubCanvas]]
      ) 
!

isSelected
    |model|

    model := self treeModel.
    model notNil ifTrue:[^ model isSelected:self].
    ^ false
!

supportsSubComponents
    "returns true if the widget supports sub components
    "
    |specClass|

    widget isScrollWrapper ifTrue:[
        ^ false
    ].
    specClass := self specClass.

    specClass notNil ifTrue:[
        ^ specClass supportsSubComponents
    ].
    ^ false
! !

!ViewTreeInspectorApplication::ViewTreeItem methodsFor:'testing'!

isInLayoutContainer
    "returns true if the widget is in a layout container
    "
    |sv specClass|

    sv := widget superView.

    sv notNil ifTrue:[
        specClass := sv specClass.

        specClass notNil ifTrue:[
            ^ specClass isLayoutContainer
        ].
    ].
    ^ false
!

isLayoutContainer
    "answer whether corresponding view instances of the spec class can contain
     (and arrange) other view
    "
    |specClass|

    specClass := self specClass.

    specClass notNil ifTrue:[
        ^ specClass isLayoutContainer
    ].
    ^ false
!

isMoveable
    "returns true if the widget is not in a layout container
    "
    self isInLayoutContainer ifFalse:[
        ^ widget superView notNil
    ].
    ^ false
!

isResizeable
    "returns true if the widget is resizeable
    "
    |sv specClass|

    sv := widget superView.

    sv notNil ifTrue:[
        specClass := sv specClass.

        specClass notNil ifTrue:[
            ^ specClass canResizeSubComponents
        ].
    ].
    ^ false
! !

!ViewTreeInspectorApplication::ViewTreeModel class methodsFor:'documentation'!

documentation
"
    Instances of ViewTreeModel can be used as model on a View and all
    it contained subviews for a HierarchicalListView.
    The model keeps two values, the hierarchical representation of the views
    and subviews (ViewTreeItems) and the selection, a list of selected ViewTreeItems's.
    It shows the selected items highlighted.


    [Instance variables:]
        lockSema            <Semaphore>         lock selection notifications and redraws

        testModeChannel     <ValueHolder>       true, than running in test mode.

        hasTargetWidgetChannel <ValueHolder>    true, than any target view is grapped

        selection           <Sequence or nil>   selected items or nil

        hiddenLevel         <Integer>           internal use; redrawing the selection
                                                only is done if the counter is 0.

        listOfItems         <HierarchicalList>  hiearchical list build from existing items.

        selectedSuperItems  <Sequence>          list of selected super items; items selected
                                                but not contained in another selected item.

        inputEventAction    <Action>            called for each InputEvent

        mappedViewAction    <Action>            called for a new mapped view which
                                                can not be found in the current item list.

        beforeSelectionChangedAction <Action>   called before the selection changed

    [author:]
        Claus Atzkern

    [see also:]
        ViewTreeItem
"
!

examples
"
    example 1: pick any window and show views and contained views
                                                                                [exBegin]
    |top sel model panel|

    model := ViewTreeModel new.
    top   := StandardSystemView new; extent:440@400.
    sel   := ScrollableView for:HierarchicalListView miniScroller:true origin:0.0@0.0 corner:1.0@1.0 in:top.
    sel bottomInset:24.

    panel := HorizontalPanelView origin:0.0@1.0 corner:1.0@1.0 in:top.
    panel topInset:-24.
    panel horizontalLayout:#fitSpace.

    Button label:'Exit'       action:[model rootItem:nil. top destroy] in:panel.
    Button label:'Pick Views' action:[  |win|
                                        (     (win := Screen current viewFromUser) notNil
                                         and:[(win := win topView) ~~ Screen current rootView
                                         and:[win ~~ top]]
                                        ) ifTrue:[
                                            model rootItem:(ViewTreeItem buildViewsFrom:win)
                                        ] ifFalse:[
                                            model rootItem:nil
                                        ]
                                     ] in:panel.

    sel  multipleSelectOk:true.
    sel              list:model listOfItems.
    sel             model:model.
    sel          useIndex:false.

    sel doubleClickAction:[:i| |el|
        el := model listOfItems at:i.
        el spec notNil ifTrue:[ el spec   inspect ] ifFalse:[ el widget inspect ]
    ].
    sel indicatorAction:[:i| (model listOfItems at:i) toggleExpand ].

    model inputEventAction:[:anEvent| |item|
        anEvent isButtonEvent ifTrue:[
            anEvent isButtonPressEvent ifTrue:[
                model selectedItem:(model listOfItems detectItemRespondsToView:(anEvent view)).
            ] ifFalse:[
                anEvent type == #'buttonMultiPress:x:y:' ifTrue:[
                    (item := model selectedItem) notNil ifTrue:[item widget inspect]
                ]
            ]
        ]
    ].

    top openAndWait.
    [[top shown] whileTrue:[Delay waitForSeconds:0.5]. model rootItem:nil] forkAt:8

                                                                                [exEnd]
"
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'accessing'!

application:anApplication
    listOfItems application:anApplication.
!

catchEvents:aBoolean
    catchEvents := aBoolean.
    aBoolean ifFalse:[
        self redrawUnselected:selection andLock:false checkTestMode:false.
    ].
!

path
    "Return a XPath like path to this item"

    | view views|

    selection isNil ifTrue:[ ^ nil ].
    selection isCollection ifTrue:[ 
        selection size ~~ 1 ifTrue:[ ^ nil ].
        view := selection anElement widget.
    ] ifFalse:[ 
        view := selection widget.
    ].
    views := OrderedCollection new.
    [ view notNil ] whileTrue:[ 
        views add: view.
        view := view superView.
    ].
    views removeLast.
    ^ String streamContents:[ :s|
        views reverseDo:[:each |
            s nextPutAll:'/'.
            s nextPutAll: each name asString "storeString".
        ].
    ]

    "Created: / 19-05-2014 / 18:15:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rootItem
    "get the rootItem the event viewer is established on
    "
    ^ listOfItems root
!

rootItem:anItem
    "set the rootItem the event viewer is established on
    "
    |expanded|

    timedUpdateTask := nil.
    self deselect.

    lockSema critical:[
        anItem notNil ifTrue:[ expanded := anItem isExpanded ]
                     ifFalse:[ expanded := false ].

        self value:nil.
        listOfItems root:anItem.

        anItem notNil ifTrue:[
            timedUpdateTask := Process for:[ self timedUpdateTaskCycle ] priority:8.
            timedUpdateTask name:'Update'.
            timedUpdateTask resume.
        ].
    ].

    (expanded and:[anItem notNil]) ifTrue:[
        anItem expand
    ].
    ^ anItem
!

rootView
    "get the top widget the event viewer is established on, a View
    "
    ^ listOfItems rootView
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'accessing actions'!

beforeSelectionChangedAction
    "none argument action which is called before
     the selection changed
    "
    ^ beforeSelectionChangedAction
!

beforeSelectionChangedAction:aNoneArgBlock
    "none argument action which is called before
     the selection changed
    "
    beforeSelectionChangedAction := aNoneArgBlock.
!

inputEventAction
    "called for each input event; the argument to the action is the WindowEvent
    "
    ^ inputEventAction
!

inputEventAction:aOneArgActionTheEvent
    "called for each input event; the argument to the action is the WindowEvent
    "
    inputEventAction := aOneArgActionTheEvent.
!

mappedViewAction
    "called for a new mapped view which can not be found
     in the current item list
    "
    ^ mappedViewAction
!

mappedViewAction:aOneArgBlockTheMappedView
    "called for a new mapped view which can not be found
     in the current item list
    "
    mappedViewAction := aOneArgBlockTheMappedView
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'accessing look'!

iconAt:aKey ifNonePut:aNoneArgBlock
    |icon view|

    icon := icons at:aKey ifAbsent:nil.
    icon notNil ifTrue:[^ icon].

    icon := aNoneArgBlock value.
    icon isNil ifTrue:[^ nil].

    view := self rootView.
    view isNil ifTrue:[^ icon].

    icon := icon copy onDevice:(view device).
    icon isImage ifTrue:[
        icon clearMaskedPixels.
    ].
    icons at:aKey put:icon.
    ^ icon
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'accessing visibility'!

signalHiddenLevel
    "show the selection if signaled; increments hiddenLevel
     see: #waitHiddenLevel
    "
    (hiddenLevel := hiddenLevel - 1) < 1 ifTrue:[
        hiddenLevel := 0.
        self invalidateSelection.
    ].
!

waitHiddenLevel
    "hide the selection until signaled; increments hiddenLevel
     see: #signalHiddenLevel
    "
    self redrawUnselected:selection andLock:true
!

withSelectionHiddenDo:aNoneArgumentBlock
    "apply block with selection hidden
    "

    [   self waitHiddenLevel.

        aNoneArgumentBlock value

    ] valueNowOrOnUnwindDo:[
        self signalHiddenLevel.
    ].
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'aspects'!

hasTargetWidgetChannel
    "answer the channel which is set to true if a target widget exists"

    ^ hasTargetWidgetChannel
!

listOfItems
    "hiearchical list build from existing items"

    ^ listOfItems
!

selectOnClickHolder
    "boolean holder, which indicates whether the selection will change on click
    "
    ^ selectOnClickHolder
!

testModeChannel
    "answer a boolean channel which describes the behaviour how to process
     events on the target view.

     false: all input events are eaten and the selection is shown on the target view.
     true:  no  input events are eaten and no  selection is shown on the target view."

    ^ testModeChannel
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'change & update'!

targetWidgetChanged
    hasTargetWidgetChannel value:(self rootItem notNil).
!

timedUpdateTaskCycle
    |view myTaskId|

    myTaskId := timedUpdateTask.

    listOfItems root notNil ifTrue:[
        view := listOfItems root widget.
    ].

    [ view notNil ] whileTrue:[
        Delay waitForSeconds:0.5.
        
        (myTaskId == timedUpdateTask and:[view id notNil]) ifFalse:[
            view := nil.
        ] ifTrue:[
            (view sensor hasUserEvent:#updateChildren for:self) ifFalse:[
                view sensor pushUserEvent:#updateChildren for:self.
            ].
        ].
    ].
    timedUpdateTask == myTaskId ifTrue:[
        timedUpdateTask := nil.
        listOfItems root:nil.
    ].
!

update:something with:someArgument from:aModel

    aModel == testModeChannel ifTrue:[
        (hiddenLevel == 0 and:[selection size > 0]) ifTrue:[
            testModeChannel value ifTrue:[
                self redrawUnselected:selection andLock:false checkTestMode:false.
            ] ifFalse:[
                self invalidateSelection.
            ].
        ].
        ^ self
    ].
    super update:something with:someArgument from:aModel.
!

updateChildren
    |rootItem|

    rootItem := listOfItems root.
    rootItem isNil ifTrue:[^ self].

    rootItem exists ifFalse:[
        listOfItems root:nil.
    ] ifTrue:[
        rootItem updateChildren.
    ].
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'event processing'!

processEvent:anEvent
    "catch and process all WindowEvents for the rootComponent and its contained
     widgets; redraw selection in case of damage...
     return true, if the event was eaten"

    |evView item rootView testMode|

    catchEvents ifFalse:[^ false].

    evView := anEvent view.
    evView isNil ifTrue:[
        (anEvent isMessageSendEvent not or:[anEvent receiver ~~ self]) ifTrue:[
            ^ false
        ].
        anEvent value.
        ^ true.
    ].
    rootView := listOfItems rootView.
    rootView isNil ifTrue:[ ^ false ].

    anEvent isConfigureEvent ifTrue:[
        hiddenLevel == 0 ifTrue:[
            self redrawUnselected:selection andLock:false.
        ].
        ^ false
    ].

    "/ check whether view is contained within the rootView
    (evView == rootView or:[evView isComponentOf:rootView]) ifFalse:[
        ^ false
    ].

    anEvent isInputEvent ifFalse:[
        anEvent isDamage ifTrue:[
            hiddenLevel == 0 ifTrue:[self invalidateSelection].
            ^ false
        ].

        anEvent isMapEvent ifTrue:[
            mappedViewAction notNil ifTrue:[
                item := listOfItems recursiveDetect:[:el| el widget == evView].
                item isNil ifTrue:[ mappedViewAction value:evView ]
            ].
            ^ false
        ].

        anEvent type == #terminate ifTrue:[
            item := listOfItems recursiveDetect:[:el| el widget == evView].
            item notNil ifTrue:[ self processTerminateForItem:item ].
            ^ false
        ].
        ^ false
    ].
    testMode := testModeChannel value.

    anEvent isFocusEvent ifTrue:[
        evView == rootView ifTrue:[
            self invalidateSelection
        ].
        ^ testMode not.
    ].
    anEvent isPointerEnterLeaveEvent ifTrue:[ ^ testMode not ].

    testMode ifFalse:[
        inputEventAction notNil ifTrue:[ inputEventAction value:anEvent ].
    ] ifTrue:[
        anEvent isButtonPressEvent ifTrue:[
            selectOnClickHolder value ifTrue:[
                self selectItem:(listOfItems detectItemRespondsToView:evView).
            ].
        ]
    ].

    (hiddenLevel ~~ 0 and:[anEvent isButtonReleaseEvent]) ifTrue:[
        hiddenLevel := 1.
        self signalHiddenLevel.
    ].

    ^ testMode not
!

processTerminateForItem:anItem
    "received terminate for an item
    "
    anItem remove.
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'initialization'!

initialize
    "setup the default attributes
    "
    super initialize.

    hiddenLevel           := 0.
    lockSema              := RecursionLock new.
    listOfItems           := ItemList new on:self.
    selectedSuperItems    := #().
    icons                 := IdentityDictionary new.
    catchEvents           := true.

    hasTargetWidgetChannel := false asValue.
    selectOnClickHolder    := true asValue.

    testModeChannel := false asValue.
    testModeChannel addDependent:self.
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'private selection'!

invalidateSelection
    "invalidate (force async redraw) the current selection
    "
    |topView|

    testModeChannel value ifTrue:[ ^ self ]. "/ test whether running testMode

    (     hiddenLevel == 0
     and:[selection notNil
     and:[(topView := listOfItems rootView) notNil
     and:[topView shown]]]
    ) ifTrue:[
        topView sensor pushUserEvent:#redrawSelection for:self withArguments:#()
    ]
!

recursiveRepair:theDamages startIn:aView relativeTo:aRootView
    "repair all views and contained views, which intersects the damage.
     !!!! all damages repaired are removed from the list of damages !!!!
    "
    |color relOrg damage subViews repaired
     bwWidth    "{ Class:SmallInteger }"
     x          "{ Class:SmallInteger }"
     y          "{ Class:SmallInteger }"
     w          "{ Class:SmallInteger }"
     h          "{ Class:SmallInteger }"
     relOrgX    "{ Class:SmallInteger }"
     relOrgY    "{ Class:SmallInteger }"
     width      "{ Class:SmallInteger }"
     height     "{ Class:SmallInteger }"
     size       "{ Class:SmallInteger }"
    |
    (aView shown and:[theDamages notEmpty]) ifFalse:[ ^ self ].

    subViews := aView subViews.

    subViews size ~~ 0 ifTrue:[
        subViews reverseDo:[:v| self recursiveRepair:theDamages startIn:v relativeTo:aRootView ].
        theDamages isEmpty ifTrue:[ ^ self ].
    ].

    relOrg  := aView originRelativeTo:aRootView.
    bwWidth := aView borderWidth.
    size    := theDamages size.

    "/ compute relative origin starting from border left@top
    relOrgX := relOrg x - bwWidth.
    relOrgY := relOrg y - bwWidth.
    width   := aView width  + bwWidth + bwWidth.
    height  := aView height + bwWidth + bwWidth.

    size to:1 by:-1 do:[:anIndex|
        repaired := damage := theDamages at:anIndex.

        "/ compute the rectangle into the view
        y := damage top  - relOrgY.
        x := damage left - relOrgX.
        w := damage width.
        h := damage height.

        x     < 0      ifTrue:[ w := w + x. x := 0. repaired := nil ].
        y     < 0      ifTrue:[ h := h + y. y := 0. repaired := nil ].
        x + w > width  ifTrue:[ w := width  - x.    repaired := nil ].
        y + h > height ifTrue:[ h := height - y.    repaired := nil ].

        (w > 0 and:[h > 0]) ifTrue:[
            bwWidth ~~ 0 ifTrue:[
                color isNil ifTrue:[
                    "/ must force redraw of border
                    color := aView borderColor.
                    aView borderColor:(Color colorId:1).
                    aView borderColor:color.
                ].
                w := w - bwWidth.
                h := h - bwWidth.

                (x := x - bwWidth) < 0 ifTrue:[w := w + x. x := 0].
                (y := y - bwWidth) < 0 ifTrue:[h := h + y. y := 0].

                h > 0 ifFalse:[w := 0].         "/ later testing on width only
            ].

            w > 0 ifTrue:[
                aView clearRectangleX:x y:y width:w height:h.
                aView exposeX:x y:y width:w height:h
            ].
            repaired notNil ifTrue:[ theDamages removeFromIndex:anIndex toIndex:anIndex ].
        ]
    ].
!

redrawSelection
    "redraw all items selected
    "
    |topView size|

    testModeChannel value ifTrue:[ ^ self ]. "/ test whether running testMode

    (     hiddenLevel == 0
     and:[(size := selection size) > 0
     and:[(topView := listOfItems rootView) notNil
     and:[topView shown
     and:[(topView sensor hasEvent:#redrawSelection for:self) not]]]]
    ) ifFalse:[
        ^ self
    ].

    lockSema critical:[
        |list|

        list := selection.

        list size > 0 ifTrue:[
            topView paint:(Color black).
            topView clippedByChildren:false.

            list keysAndValuesReverseDo:[:anIndex :anItem|
                (anIndex == 1 and:[size > 1]) ifTrue:[ topView paint:(Color red) ].

                anItem handlesDo:[:aRect :what|
                    what isNil ifTrue:[topView displayRectangle:aRect]
                              ifFalse:[topView    fillRectangle:aRect]
                ]
            ].
            topView clippedByChildren:true.
        ].
    ].
!

redrawUnselected:aList andLock:doLock
    "redraw all items unselected; if doLock is true, the hiddenLevel
     is incremented and thus the select mechanism is locked.
    "
    self redrawUnselected:aList andLock:doLock checkTestMode:true.
!

redrawUnselected:aList andLock:doLock checkTestMode:checkTestMode
    "redraw all items unselected; if doLock is true, the hiddenLevel
     is incremented and thus the select mechanism is locked.
    "
    |rootView damages subViews x y w h|

    doLock ifTrue:[
        hiddenLevel := hiddenLevel + 1.
        hiddenLevel ~~ 1 ifTrue:[^ self].
    ] ifFalse:[
        hiddenLevel ~~ 0 ifTrue:[^ self].
    ].
    checkTestMode ifTrue:[
        testModeChannel value ifTrue:[ ^ self ]. "/ test whether running testMode
    ].

    (     aList size ~~ 0
     and:[(rootView := listOfItems rootView) notNil
     and:[rootView shown]]
    ) ifFalse:[
        ^ self
    ].

    lockSema critical:[
        damages := OrderedCollection new:(8 * aList size).

        aList do:[:item|
            item handlesDo:[:handle :what|
                damages reverseDo:[:el|
                    (el intersects:handle) ifTrue:[
                        damages removeIdentical:el.

                        handle left:(handle left   min:el left)
                              right:(handle right  max:el right)
                                top:(handle top    min:el top)
                             bottom:(handle bottom max:el bottom)
                    ]
                ].                        
                damages add:handle
            ]
        ].

        damages do:[:el|
            x := el left.
            y := el top.
            w := el width.
            h := el height.

            rootView clearRectangleX:x y:y width:w height:h.
            rootView         exposeX:x y:y width:w height:h.
        ].

        (subViews := rootView subViews) notNil ifTrue:[
            subViews reverseDo:[:v| self recursiveRepair:damages startIn:v relativeTo:rootView ].
        ].
    ].
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'queries'!

isInTestMode
    "answer false, all input events are eaten and the selection is shown on the target view.
     answer true,  no  input events are eaten and no  selection is shown on the target view."

    ^ testModeChannel value
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'selection accessing'!

at:anIndex
    "returns the selected item at an index or nil
    "
    selection notNil ifTrue:[
        ^ selection at:anIndex ifAbsent:nil
    ].
    ^ nil
!

at:anIndex ifAbsent:aBlock
    "returns the selected item at an index or the result of the block
    "
    selection notNil ifTrue:[
        ^ selection at:anIndex ifAbsent:aBlock
    ].
    ^ aBlock value
!

first
    "returns the first selected item or nil
    "
    ^ self at:1
!

last
    "returns the last selected item or nil
    "
    ^ selection notNil ifTrue:[selection last] ifFalse:[nil]
!

selectedItem
    "returns the single selected item or nil (size ~~ 1 nil is returned)
    "
    ^ selection size == 1 ifTrue:[selection at:1] ifFalse:[nil]
!

selectedSuperItems
    "returs the list of selected superItems; items selected
     but not contained in another selected item.
    "
    ^ selectedSuperItems
!

size
    "returns the number of items selected
    "
    ^ selection size
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'selection adding & removing'!

add:item
    "add an item to the current selection
    "
    |newSelect|

    item isNil ifTrue:[^ item].

    lockSema critical:[
        selection isNil ifTrue:[
            newSelect := Array with:item.
        ] ifFalse:[
            (self includes:item) ifFalse:[
                newSelect := selection copyWith:item
            ]
        ].

        newSelect size ~~ selection size ifTrue:[
            item makeVisible.
            self value:newSelect
        ]
    ].
    ^ item
!

addAll:aCollectionOfItems
    "add a collection of items to the current selection
    "
    |newSelect|

    aCollectionOfItems size == 0 ifTrue:[ ^ aCollectionOfItems ].

    lockSema critical:[
        selection isNil ifTrue:[
            newSelect := Array withAll:aCollectionOfItems.
        ] ifFalse:[
            newSelect := OrderedCollection withAll:selection.

            aCollectionOfItems do:[:el|
                (selection includesIdentical:el) ifFalse:[newSelect add:el]
            ].
        ].
        self value:newSelect.
    ].
    ^ aCollectionOfItems
!

deselect
    "clear the selection
    "
    self value:nil.
!

remove:item
    "remove the item from the current selection
    "
    |newSelect|

    item isNil ifTrue:[^ nil].

    lockSema critical:[
        (selection notNil and:[selection includesIdentical:item]) ifTrue:[
            selection size == 1 ifTrue:[ newSelect := nil ]
                               ifFalse:[ newSelect := selection copyWithout:item ].

            self value:newSelect
        ].
    ].
    ^ item
!

removeAll
    "clear the selection
    "
    self deselect.
!

removeAll:loItems
    "remove all items of the collection from the current selection
    "
    |newSelect|

    selection   isNil ifTrue:[ ^ loItems ].
    loItems size == 0 ifTrue:[ ^ loItems ].

    lockSema critical:[
        selection notNil ifTrue:[
            newSelect := selection select:[:el| (loItems includesIdentical:el) not ].
            self value:newSelect.
        ]
    ].
    ^ loItems
!

selectAll
    "select all items
    "
    |root newSelection|

    root := listOfItems root.

    root isNil ifTrue:[
        newSelection := nil
    ] ifFalse:[
        newSelection := OrderedCollection new.
        root recursiveDo:[:el| newSelection add:el ].
    ].
    self value:newSelection.
!

selectItem:anItem
    "set the current selection to the item
    "
    self value:anItem
!

selectRootItem
    "set the current selection to the root item
    "
    self value:(self rootItem).
!

selectedItem:anItem
    "set the current selection to the item
    "
    self selectItem:anItem.
!

toggleSelectItem:anItem
    "toggle selection-state of the item; add or remove the item from the
     current selection.
    "
    anItem notNil ifTrue:[
        (self includes:anItem) ifTrue:[self remove:anItem]
                              ifFalse:[self add:anItem]
    ].
    ^ anItem
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'selection enumerating'!

collect:aBlock
    "for each element in the selection, evaluate the argument, aBlock
     and return a new collection with the results
    "
    |res|

    res := OrderedCollection new.
    self do:[:el| res add:(aBlock value:el)].
  ^ res
!

do:aOneArgBlock
    "evaluate the argument, aBlock for each item in the selection
    "
    |cashedSelection|

    cashedSelection := selection.
    cashedSelection isNil ifTrue:[^ nil].
  ^ cashedSelection do:aOneArgBlock
!

from:start do:aOneArgBlock
    "evaluate the argument, aBlock for the items starting at index start
    "
    |cashedSelection|

    cashedSelection := selection.
    cashedSelection isNil ifTrue:[^ nil].
  ^ cashedSelection from:start do:aOneArgBlock
!

from:start to:stop do:aOneArgBlock
    "evaluate the argument, aBlock for the items with index start to
     stop in the selection.
    "
    |cashedSelection|

    cashedSelection := selection.
    cashedSelection isNil ifTrue:[^ nil].
  ^ cashedSelection from:start to:stop do:aOneArgBlock
!

reverseDo:aOneArgBlock
    "evaluate the argument, aBlock for each item in the selection
    "
    |cashedSelection|

    cashedSelection := selection.
    cashedSelection isNil ifTrue:[^ nil].
  ^ cashedSelection reverseDo:aOneArgBlock
!

select:aBlock
    "return a new collection with all elements from the selection, for which
     the argument aBlock evaluates to true.
    "
    |res|

    res := OrderedCollection new.
    self do:[:el| (aBlock value:el) ifTrue:[res add:el] ].
  ^ res
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'selection protocol'!

changed:aParameter with:oldSelection
    "update the visibility staus of the current selection
    "
    |unselected rootView rootItem selSize|

    selSize := selection size.

    selSize == 0 ifTrue:[
        selectedSuperItems := #().
    ] ifFalse:[
        selSize == 1 ifTrue:[
            selectedSuperItems := Array with:(selection at:1).
        ] ifFalse:[
            rootItem := listOfItems root.

            (selection includesIdentical:rootItem) ifTrue:[
                selectedSuperItems := Array with:rootItem.
            ] ifFalse:[
                selectedSuperItems := OrderedCollection new:selSize.

                selection do:[:anItem|
                    anItem parentsDetect:[:el| selection includesIdentical:el ]
                                  ifNone:[ selectedSuperItems add:anItem ].
                ].
            ]
        ]
    ].

    (     hiddenLevel == 0
     and:[(rootView := listOfItems rootView) notNil
     and:[rootView shown]]
    ) ifTrue:[
        selSize == 0 ifTrue:[
            "/ must redraw the old selection unselected
            self redrawUnselected:oldSelection andLock:false
        ] ifFalse:[
            self invalidateSelection.

            oldSelection size ~~ 0 ifTrue:[
                "/ must redraw all elements no longer in the selection
                unselected := oldSelection select:[:el| (selection includesIdentical:el) not ].
                self redrawUnselected:unselected andLock:false.
            ]
        ]
    ].
    super changed:aParameter with:oldSelection.
!

setValue:aNewSelection 
    "set the selection without notifying
    "
    |newSelect idx|

    newSelect := nil.

    aNewSelection notNil ifTrue:[
        lockSema critical:[
            aNewSelection isCollection ifFalse:[
                (selection size == 1 and:[selection first == aNewSelection]) ifTrue:[
                    newSelect := selection
                ] ifFalse:[
                    newSelect := Array with:aNewSelection.
                ]
            ] ifTrue:[
                aNewSelection notEmpty ifTrue:[
                    aNewSelection size ~~ selection size ifTrue:[
                        newSelect := aNewSelection copy.
                    ] ifFalse:[
                        idx := selection findFirst:[:el| (aNewSelection includesIdentical:el) not ].

                        idx ~~ 0 ifTrue:[newSelect := aNewSelection copy]
                                ifFalse:[newSelect := selection ].
                    ]
                ]
            ]
        ].
    ].
    newSelect ~~ selection ifTrue:[
        beforeSelectionChangedAction value.
        selection := newSelect.
        selection notNil ifTrue:[selection do:[:el| el makeVisible]]
    ].
!

triggerValue:aValue
    "set my value & send change notifications to my dependents.
     Send the change message even if the value didn't change.
    "
    |oldSelection|

    lockSema critical:[
        oldSelection := selection.
        self setValue:aValue.
        self changed:#value with:oldSelection
    ]
!

value
    "returns the current selection
    "
    ^ selection ? #()
!

value:aValue
    "change the current selection and send change notifications to my
     dependents if it changed.
    "
    |oldSelection|

    lockSema critical:[
        oldSelection := selection.
        self setValue:aValue.

        oldSelection == selection ifFalse:[
            self changed:#value with:oldSelection
        ]
    ].
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'selection searching'!

detect:aBlock
    "evaluate the argument, aBlock for each item in the selection until
     the block returns true; in this case return the element which caused
     the true evaluation.
     If none of the evaluations returns true, an error is raised
    "
    ^ self detect:aBlock ifNone:[self errorNotFound]
!

detect:aBlock ifNone:exceptionBlock
    "evaluate the argument, aBlock for each item in the selection until the
     block returns true; in this case return the element which caused the
     true evaluation.
     If none of the evaluations returns true, the result of the evaluation
     of the exceptionBlock is returned
    "
    |cashedSelection|

    cashedSelection := selection.
    cashedSelection isNil ifTrue:[ ^ exceptionBlock value ].
  ^ cashedSelection detect:aBlock ifNone:exceptionBlock
!

detectLast:aBlock
    "evaluate the argument, aBlock for each item in the selection until
     the block returns true; in this case return the element which caused
     the true evaluation. The items are processed in reverse order.
     If none of the evaluations returns true, an error is raised
    "
    ^ self detectLast:aBlock ifNone:[self errorNotFound]
!

detectLast:aBlock ifNone:exceptionBlock
    "evaluate the argument, aBlock for each item in the selection until
     the block returns true; in this case return the element which caused
     the true evaluation. The items are processed in reverse order.
     If none of the evaluations returns true, the result of the evaluation
     of the exceptionBlock is returned
    "
    |cashedSelection|

    cashedSelection := selection.
    cashedSelection isNil ifTrue:[ ^ exceptionBlock value ].
  ^ cashedSelection detectLast:aBlock ifNone:exceptionBlock
! !

!ViewTreeInspectorApplication::ViewTreeModel methodsFor:'selection testing'!

includes:anItem
    "returns true if the item is in the current selection
    "
    |cashedSelection|

    cashedSelection := selection.
    cashedSelection isNil ifTrue:[^ false].
 ^  cashedSelection includesIdentical:anItem
!

includesAll:aCollection
    "return true, if all items of the collection are included in the current selection
    "
    |cashedSelection|

    aCollection size ~~ 0 ifTrue:[
        cashedSelection := selection.
        cashedSelection isNil ifTrue:[ ^ false ].

        aCollection do:[:el|
            (cashedSelection includesIdentical:el) ifFalse:[^ false]
        ]
    ].
    ^ true
!

includesAny:aCollection
    "return true, if the any item of the collection is in the current selection
    "
    |cashedSelection|

    aCollection notNil ifTrue:[
        cashedSelection := selection.

        cashedSelection notNil ifTrue:[
            aCollection do:[:el|
                (cashedSelection includesIdentical:el) ifTrue:[^ true]
            ]
        ]
    ].
    ^ false
!

includesIdentical:anItem
    "returns true if the item is in the current selection
    "
    ^ self includes:anItem
!

isEmpty
    "returns true if the current selection is empty
    "
    ^ selection size == 0
!

isSelected:anItem
    "returns true if the item is in the current selection
    "
    ^ self includes:anItem
!

notEmpty
    "returns true if the current selection is not empty
    "
    ^ selection size ~~ 0
! !

!ViewTreeInspectorApplication::ViewTreeModel::ItemList class methodsFor:'documentation'!

documentation
"
    Kind of HierarchicalList class which contains all the visible
    ViewTreeItem's and the root, the anchor of the hierarchical list.

    [Instance variables:]
        treeModel       <ViewTreeModel>         all events are delegated to
        eventHook       <BlockValue>            save and resore the pre/post -EventHook


    [author:]
        Claus Atzkern

    [see also:]
        HierarchicalList
        ViewTreeModel
        ViewTreeItem
"
! !

!ViewTreeInspectorApplication::ViewTreeModel::ItemList methodsFor:'accessing'!

root:theRoot
    "set the root item; delegate events to my treeModel
    "
    |rootView|

    theRoot == root ifTrue:[^ self].

    rootView := self rootView.
    super root:theRoot.

    rootView notNil ifTrue:[ |wgrp|
        wgrp := rootView windowGroup.

        wgrp notNil ifTrue:[
           wgrp removePreEventHook:treeModel.
           wgrp removePostEventHook:self.
        ].
    ].

    super root:theRoot.
    rootView := self rootView.

    rootView notNil ifTrue:[
        "must setup a task because there might not exist a windowGroup at the moment
        "
        [   |wgrp|

            [rootView == self rootView] whileTrue:[
                wgrp := rootView windowGroup.
                wgrp notNil ifTrue:[
                    rootView := nil.
                    wgrp addPreEventHook:treeModel.
                    wgrp addPostEventHook:self.
                ] ifFalse:[
                    Delay waitForMilliseconds:100.
                ].
            ].

        ] forkAt:(Processor userSchedulingPriority + 2).
    ].
    treeModel notNil ifTrue:[
        treeModel targetWidgetChanged.
    ].
    
    ^ root.
!

rootView
    "returns the widget assigned to the root or nil
    "
    ^ root notNil ifTrue:[root widget] ifFalse:[nil]
!

treeModel
    "returne the treeModel, a ViewTreeModel
    "
    ^ treeModel
! !

!ViewTreeInspectorApplication::ViewTreeModel::ItemList methodsFor:'accessing look'!

additionalLabelForItem:anItem
    "answer the additional lable for an item or nil"

    |widget l applClass applClassName key|

    widget := anItem widget.

    l := nil.
    showWidgetNames == true ifTrue:[
        l := '"', widget name, '"'
    ].

    anItem isApplicationClass ifTrue:[
        applClass := anItem applicationClass.
        applClass notNil ifTrue:[   
            applClassName := '[', applClass name allBold, ']'.
            l := (l isNil ifTrue:[''] ifFalse:[l , ' ']) , applClassName
        ].
    ].

    application notNil ifTrue:[
        key := application builder namedComponents keyAtValue:widget ifAbsent:nil.
        key notNil ifTrue:[
            l := l , ' #',key
        ].
    ].

    ^ l
!

showWidgetNames
    "answer true if the additional text is the widget name
     otherwise the name of the application"

    ^ showWidgetNames ? true
!

showWidgetNames:aBoolean
    "set true if the additional text is the widget name
     otherwise the name of the application"

    self showWidgetNames == aBoolean ifFalse:[
        showWidgetNames := aBoolean.

        root notNil ifTrue:[
            root recursiveAdditionalNameBehaviourChanged.
            self changed.
        ].
    ].
! !

!ViewTreeInspectorApplication::ViewTreeModel::ItemList methodsFor:'event processing'!

processEvent:anEvent
    "post process event
    "
    ^ treeModel isInTestMode not
! !

!ViewTreeInspectorApplication::ViewTreeModel::ItemList methodsFor:'instance creation'!

on:aModel
    "set the model, a ViewTreeModel
    "
    treeModel := aModel.
    showRoot  := true.
    "/ showWidgetNames := false.
    showWidgetNames := true.
! !

!ViewTreeInspectorApplication::ViewTreeModel::ItemList methodsFor:'searching'!

detectItemRespondsToView:aView
    "returns the bottom-most item which contains the view
    "
    |view item topView|

    root notNil ifTrue:[
        view    := aView.
        topView := root widget.

        [ view notNil ] whileTrue:[
            topView == view ifTrue:[^ root].
            item := root recursiveDetect:[:el| el widget == view ].
            item notNil ifTrue:[^ item].
            view := view superView
        ]
    ].
    ^ nil
!

recursiveDetect:aOneOrgBlock
    "recursive find the first child, for which evaluation 
     of the block returns true; if none nil is returned
    "
    root notNil ifTrue:[
        (aOneOrgBlock value:root) ifTrue:[ ^ root ].
      ^ root recursiveDetect:aOneOrgBlock
    ].
    ^ nil
! !

!ViewTreeInspectorApplication class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ViewTreeInspectorApplication initialize!
ViewTreeInspectorApplication::ViewTreeItem initialize!
