"
 COPYRIGHT (c) 1997 by eXept Software AG
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

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoToolBar
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoToolBar class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    shows use of menus/toolbars
    Notice, that a menuPanel is not limited
    to traditional looking menus; instead, items
    can also be set up to look like buttons, radioButtons
    or checkToggles.
    In addition, items can be defined to consist of
    either a textual label, an icon alone or a combined text+icon.
    Also, various color combinations are possible.
    Finally, notice the right-adjusted menu item, which is used with help menus.

    [author:]
        Claus Atzkern

    [start with:]
        GUIDemoToolBar open
        GUIDemo open
"

! !

!GUIDemoToolBar class methodsFor:'icons'!

icon3
    ^ TabViewSpec icon
!

icon4
    ^ SequenceViewSpec icon
!

icon5
    ^ SelectionInTreeViewSpec icon
!

icon6
    ^ ScrollerSpec icon
!

icon8
    ^ RadioButtonSpec icon
!

iconAndLabel
    ^ TextEditorSpec icon
!

iconButton
    ^ ActionButtonSpec icon
!

iconIndicator
    ^ RadioButtonSpec icon
!

iconLabel
    ^ RadioButtonSpec icon
!

iconToggle
    ^ ToggleSpec icon
!

iconVisibility
    ^ ProgressIndicatorSpec icon
! !

!GUIDemoToolBar class methodsFor:'menu specs'!

menuBehaviour
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoToolBar andSelector:#menuBehaviour
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoToolBar menuBehaviour)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Enabled'
                #indication: #enabled
            )
             #(#MenuItem
                #label: 'Visibile'
                #translateLabel: true
                #indication: #visibility
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: 'Label'
                #translateLabel: true
                #isVisible: #visibility
                #enabled: #enabled
            )
             #(#MenuItem
                #label: 'Label & Icon'
                #translateLabel: true
                #isVisible: #visibility
                #enabled: #enabled
                #labelImage: #(#ResourceRetriever nil #iconAndLabel 'Label & Icon')
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: 'Indicator'
                #isVisible: #visibility
                #enabled: #enabled
                #indication: #indicator1
            )
             #(#MenuItem
                #label: 'Indicator'
                #translateLabel: true
                #isVisible: #visibility
                #enabled: #enabled
                #labelImage: #(#ResourceRetriever nil #iconAndLabel 'Indicator')
                #indication: #indicator2
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: 'Button'
                #isButton: true
                #isVisible: #visibility
                #enabled: #enabled
                #labelImage: #(#ResourceRetriever nil #iconButton)
            )
             #(#MenuItem
                #label: 'Toggle'
                #isButton: true
                #isVisible: #visibility
                #enabled: #enabled
                #labelImage: #(#ResourceRetriever nil #iconToggle)
                #indication: #toggle1
            )
          ) nil
          nil
      )
!

menuButtons
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoToolBar andSelector:#menuButtons
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoToolBar menuButtons)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Button'
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconButton 'Button')
            )
             #(#MenuItem
                #label: 'Button'
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconAndIcon)
            )
             #(#MenuItem
                #label: 'Button'
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconButton)
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: 'Toggle'
                #translateLabel: true
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconToggle 'Toggle')
                #indication: #toggle1
            )
             #(#MenuItem
                #label: 'Toggle'
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconAndIcon)
                #indication: #toggle4
            )
             #(#MenuItem
                #label: 'Toggle'
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconToggle)
                #indication: #toggle2
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: 'Toggle'
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconToggle)
                #indication: #toggle3
            )
             #(#MenuItem
                #label: 'Toggle'
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconToggle)
                #indication: #toggle3not
            )
          ) nil
          nil
      )
!

menuColors
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoToolBar andSelector:#menuColors
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoToolBar menuColors)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Fg Color'
                #translateLabel: true
                #labelImage: #(#ResourceRetriever nil #fgColorLabel)
            )
             #(#MenuItem
                #label: 'FgBgColor'
                #translateLabel: true
                #labelImage: #(#ResourceRetriever nil #fgAndBgColorLabel)
            )
             #(#MenuItem
                #label: 'Label And Icon'
                #translateLabel: true
                #labelImage: #(#ResourceRetriever nil #fgColorLabelAndIcon)
            )
             #(#MenuItem
                #label: 'Indicator'
                #translateLabel: true
                #labelImage: #(#ResourceRetriever nil #fgColorIndicator)
                #indication: #indicator1
            )
             #(#MenuItem
                #label: 'Indicator'
                #translateLabel: true
                #labelImage: #(#ResourceRetriever nil #fgColorIndicatorLabelAndIcon)
                #indication: #indicator2
            )
          ) nil
          nil
      )
!

menuItems
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoToolBar andSelector:#menuItems
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoToolBar menuItems)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Label'
            )
             #(#MenuItem
                #label: 'Icon'
                #translateLabel: true
                #labelImage: #(#ResourceRetriever nil #iconLabel)
            )
             #(#MenuItem
                #label: 'Label & Icon'
                #translateLabel: true
                #labelImage: #(#ResourceRetriever nil #iconAndLabel 'Label & Icon')
            )
             #(#MenuItem
                #label: 'Icon & Icon'
                #translateLabel: true
                #labelImage: #(#ResourceRetriever nil #iconAndIcon)
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: 'Indicator'
                #indication: #indicator1
            )
             #(#MenuItem
                #label: 'Indicator'
                #translateLabel: true
                #labelImage: #(#ResourceRetriever nil #iconIndicator)
                #indication: #indicator3
            )
             #(#MenuItem
                #label: 'Indicator'
                #labelImage: #(#ResourceRetriever nil #iconIndicator 'Indicator')
                #indication: #indicator2
            )
          ) nil
          nil
      )
!

menuRadioButtons
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoToolBar andSelector:#menuRadioButtons
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoToolBar menuRadioButtons)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Radio Buttons'
                #translateLabel: true
                #submenuChannel: #menuRadioButtons
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: 'Label'
                #translateLabel: true
                #nameKey: #A
                #choice: #radioGroup
                #choiceValue: 1
            )
             #(#MenuItem
                #label: 'Icon'
                #translateLabel: true
                #nameKey: #B
                #labelImage: #(#ResourceRetriever nil #iconLabel)
                #choice: #radioGroup
                #choiceValue: 2
            )
             #(#MenuItem
                #label: 'Label & Icon'
                #translateLabel: true
                #nameKey: #C
                #labelImage: #(#ResourceRetriever nil #iconAndLabel 'Label & Icon')
                #choice: #radioGroup
                #choiceValue: 3
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: 'Toggle'
                #translateLabel: true
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconToggle 'Toggle')
                #choice: #radioGroupToggle
                #choiceValue: 1
            )
             #(#MenuItem
                #label: 'Toggle'
                #translateLabel: true
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconAndIcon)
                #choice: #radioGroupToggle
                #choiceValue: 2
            )
             #(#MenuItem
                #label: 'Toggle'
                #translateLabel: true
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconToggle)
                #choice: #radioGroupToggle
                #choiceValue: 3
            )
          ) nil
          nil
      )
!

menuSubmenus
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoToolBar andSelector:#menuSubmenus
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoToolBar menuSubmenus)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Submenu'
                #translateLabel: true
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Foo'
                      )
                       #(#MenuItem
                          #label: 'Bar'
                      )
                       #(#MenuItem
                          #label: 'Baz'
                      )
                       #(#MenuItem
                          #label: 'Submenu Link'
                          #translateLabel: true
                          #submenuChannel: #menuSubmenus
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: 'Submenu Items'
                #translateLabel: true
                #submenuChannel: #menuItems
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: 'Submenu Buttons'
                #translateLabel: true
                #submenuChannel: #menuButtons
            )
             #(#MenuItem
                #label: 'Bind Right'
                #translateLabel: true
                #startGroup: #right
            )
             #(#MenuItem
                #label: 'Button'
                #isButton: true
                #labelImage: #(#ResourceRetriever nil #iconButton)
            )
          ) nil
          nil
      )
!

menuWidgets
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoToolBar andSelector:#menuWidgets
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoToolBar menuWidgets)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'WIDGETS IN MENU:'
            #translateLabel: true
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #label: 'Hierarchical Tree'
            #font: #(#FontDescription #helvetica #bold #roman 18)
            #submenuChannel: #getHierarchicalTree
            #keepLinkedMenu: true
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #label: 'New List'
            #font: #(#FontDescription #helvetica #bold #roman 18)
            #submenuChannel: #getNewList:
            #keepLinkedMenu: true
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #label: 'Old List'
            #font: #(#FontDescription #helvetica #bold #roman 18)
            #submenuChannel: #getOldList:
            #keepLinkedMenu: true
          )
         #(#MenuItem
            #label: ''
          )
         #(#MenuItem
            #label: 'Application'
            #font: #(#FontDescription #helvetica #bold #roman 18)
            #submenuChannel: #getApplication
            #keepLinkedMenu: true
          )
         )
        nil
        nil
      )
! !

!GUIDemoToolBar class methodsFor:'window specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoToolBar andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoToolBar new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoToolBar open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Demo Tabs'
          #name: 'Demo Tabs'
          #min: #(#Point 10 10)
          #max: #(#Point 1280 1024)
          #bounds: #(#Rectangle 97 230 727 610)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#MenuPanelSpec
              #name: 'menuItems'
              #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 32 0)
              #menu: #menuItems
              #textDefault: true
            )
           #(#MenuPanelSpec
              #name: 'menuButtons'
              #layout: #(#LayoutFrame 0 0.0 52 0 0 1.0 84 0)
              #menu: #menuButtons
              #textDefault: true
            )
           #(#MenuPanelSpec
              #name: 'menuSubmenus'
              #layout: #(#LayoutFrame 0 0.0 104 0 0 1.0 136 0)
              #menu: #menuSubmenus
              #textDefault: true
            )
           #(#MenuPanelSpec
              #name: 'menuBehaviour'
              #layout: #(#LayoutFrame 0 0.0 156 0 0 1.0 188 0)
              #menu: #menuBehaviour
              #textDefault: true
            )
           #(#MenuPanelSpec
              #name: 'menuColors'
              #layout: #(#LayoutFrame 0 0.0 208 0 0 1.0 240 0)
              #menu: #menuColors
              #textDefault: true
            )
           #(#MenuPanelSpec
              #name: 'menuRadioButtons'
              #layout: #(#LayoutFrame 0 0.0 260 0 0 1.0 292 0)
              #menu: #menuRadioButtons
              #textDefault: true
            )
           #(#MenuPanelSpec
              #name: 'menuWidgets'
              #layout: #(#LayoutFrame 0 0.0 312 0 0 1.0 344 0)
              #menu: #menuWidgets
              #textDefault: true
            )
           )
         
        )
      )
! !

!GUIDemoToolBar methodsFor:'accessing icons'!

iconAndIcon
    ^ LabelAndIcon form:(self class iconButton)
                  image:(self class iconToggle).
! !

!GUIDemoToolBar methodsFor:'accessing items'!

fgAndBgColorLabel
     ^ Text string:'FG/BG-Color' foregroundColor:(Color blue)
                                 backgroundColor:(Color green)
!

fgColorIndicator
     |text|

     ^ Text string:'Indicator' color:(Color yellow).
!

fgColorIndicatorLabelAndIcon
     |text|

     text := Text string:'Indicator' color:(Color cyan).
     ^ LabelAndIcon icon:(self class iconLabel) string:text.
!

fgColorLabel
    ^ Text string:'FG-Color' color:(Color red)
!

fgColorLabelAndIcon
     |text|

     text := Text string:'Label & Icon' color:(Color magenta).
     ^ LabelAndIcon icon:(self class iconLabel) string:text.
! !

!GUIDemoToolBar methodsFor:'accessing widgets'!

getApplication

    |widget appl|

    (widget := builder bindingAt:#Application) isNil ifTrue:[
        widget := SimpleView new.
        widget client:(appl := CodingExamples_GUI::GUIDemoTabs new).
        widget extent:300@300.
        builder aspectAt:#Application put:widget.
    ].
    ^ widget

!

getHierarchicalTree

    |widget list item action|

    (widget := builder bindingAt:#HierarchicalTree) isNil ifTrue:[
        list := HierarchicalList new.
        item := HierarchicalItem::Example labeled:'Root Item'.

        item expand.
        list showRoot:false.
        list root:item.

        widget := ScrollableView for:HierarchicalListView miniScrollerH:false.

        widget list:list.
        widget multipleSelectOk:true.
        action := [:i|  |el|
                        (el := list at:i ifAbsent:nil) notNil ifTrue:[
                            el toggleExpand.
                        ]
                  ].
        widget doubleClickAction:action.
        widget   indicatorAction:action.
        widget preferredExtent:250@250.

        builder aspectAt:#HierarchicalTree put:widget.
    ].
    ^ widget

!

getNewList:theMenu

    |widget list|

    (widget := builder bindingAt:#NewList) isNil ifTrue:[
        |img1 img2 img3 item itmCls stxLabel item1lbl item2lbl|

        widget := ScrollableView for:SelectionInListModelView.
        builder aspectAt:#NewList put:widget.

        itmCls := HierarchicalItemWithLabelAndIcon "SelectionInListModelViewSpec::Item".

        list  := HierarchicalList new.
        img1  := ResourceSelectionBrowser iconPrivateClass.
        img2  := ResourceSelectionBrowser iconCategory.
        img3  := Icon stxIcon.

        item  := itmCls labeled:(Text string:'New List/Tree' emphasis:#bold) icon:img1.

        stxLabel := StringCollection with:''
                                     with:( Text string:'New Feature' emphasis:#(bold underline))
                                     with:'views in'
                                     with:'menus'.

        stxLabel := Array with:img3 with:(stxLabel asString).
        item1lbl := Array with:'Label ....' with:img1.

        item2lbl := Array with:img1 with:(Text string:'Italic ....' emphasis:#italic)
                                    with:(Text string:'Color' color:(Color red))
                                    with:img2
                                    with:(Text string:'Bold' emphasis:#bold).

        3 timesRepeat:[
            item add:(itmCls labeled:stxLabel).

            item add:(itmCls labeled:item1lbl).
            item add:(itmCls labeled:item2lbl).
            item add:(itmCls labeled:'... without icons ... ').
        ].
        item expand.
        list root:item.
        widget list:list.
        widget highlightMode:#line.
        widget preferredExtent:200@200.

        widget doubleClickAction:[:anIndex|
            theMenu closeMenus.
            Transcript showCR:('SELECTED INDEX: ', anIndex printString).
        ].
    ].
    ^ widget
!

getOldList:theMenu

    |widget list|

    (widget := builder bindingAt:#OldList) isNil ifTrue:[
        widget := ScrollableView for:SelectionInListView.
        builder aspectAt:#OldList put:widget.
        list := OrderedCollection new.

        1 to:100 do:[:i| list add:('entry [%1]' bindWith:i)].
        widget list:list.
        widget preferredExtent:(150@200).

        widget doubleClickAction:[:anIndex|
            theMenu closeMenus.
            Transcript showCR:('SELECTED INDEX: ', anIndex printString).
        ].
    ].
    ^ widget

! !

!GUIDemoToolBar methodsFor:'aspects'!

enabled

    |holder|

    (holder := builder bindingAt:#enabled) isNil ifTrue:[
        holder := true asValue.
        builder aspectAt:#enabled put:holder.
    ].
    ^ holder

!

indicator1

    |holder|

    (holder := builder bindingAt:#indicator1) isNil ifTrue:[
        holder := true asValue.
        builder aspectAt:#indicator1 put:holder.
    ].
    ^ holder

!

indicator2

    |holder|

    (holder := builder bindingAt:#indicator2) isNil ifTrue:[
        holder := true asValue.
        builder aspectAt:#indicator2 put:holder.
    ].
    ^ holder

!

indicator3

    |holder|

    (holder := builder bindingAt:#indicator3) isNil ifTrue:[
        builder aspectAt:#indicator3 put:true asValue.
    ].
    ^ holder

!

radioGroup

    |holder|

    (holder := builder bindingAt:#radioGroup) isNil ifTrue:[
        holder := false asValue.
        builder aspectAt:#radioGroup put:holder.
        holder value:1.
    ].
    ^ holder

!

radioGroupToggle

    |holder|

    (holder := builder bindingAt:#radioGroupToggle) isNil ifTrue:[
        holder := false asValue.
        builder aspectAt:#radioGroupToggle put:holder.
        holder value:1.
    ].
    ^ holder

!

toggle1

    |holder|

    (holder := builder bindingAt:#toggle1) isNil ifTrue:[
        holder := false asValue.
        builder aspectAt:#toggle1 put:holder.
    ].
    ^ holder

!

toggle2

    |holder|

    (holder := builder bindingAt:#toggle2) isNil ifTrue:[
        holder := false asValue.
        builder aspectAt:#toggle2 put:holder.
    ].
    ^ holder

!

toggle3

    |holder|

    (holder := builder bindingAt:#toggle3) isNil ifTrue:[
        holder := false asValue.
        builder aspectAt:#toggle3 put:holder.
        holder addDependent:self.
    ].
    ^ holder

!

toggle3not

    |holder value|

    (holder := builder bindingAt:#toggle3not) isNil ifTrue:[
        holder := true asValue.
        builder aspectAt:#toggle3not put:holder.
        holder addDependent:self.
    ].
    ^ holder
!

toggle4

    |holder|

    (holder := builder bindingAt:#toggle4) isNil ifTrue:[
        holder := false asValue.
        builder aspectAt:#toggle4 put:holder.
    ].
    ^ holder

!

toggleAndIconIndication

    |holder|

    (holder := builder bindingAt:#toggleAndIconIndication) isNil ifTrue:[
        builder aspectAt:#toggleAndIconIndication put:false asValue.
    ].
    ^ holder

!

toggleIndication

    |holder|

    (holder := builder bindingAt:#toggleIndication) isNil ifTrue:[
        builder aspectAt:#toggleIndication put:false asValue.
    ].
    ^ holder

!

visibility

    |holder|

    (holder := builder bindingAt:#visibility) isNil ifTrue:[
        holder := true asValue.
        builder aspectAt:#visibility put:holder.
    ].
    ^ holder

! !

!GUIDemoToolBar methodsFor:'change & update'!

update:what with:aPara from:aModel
    |t3 t3not|

    t3    := self toggle3.
    t3not := self toggle3not.

    aModel == t3 ifTrue:[
        t3not value:t3 value not.
    ].
    aModel == t3not ifTrue:[
        ^ t3 value:t3not value not.
    ].
    ^ super update:what with:aPara from:aModel
! !

!GUIDemoToolBar class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoToolBar.st,v 1.7 2013-03-14 00:20:44 cg Exp $'
! !

