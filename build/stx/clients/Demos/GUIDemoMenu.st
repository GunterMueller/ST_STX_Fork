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

GUIDemoApplication subclass:#GUIDemoMenu
	instanceVariableNames:'selection'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoMenu class methodsFor:'documentation'!

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
    The example demonstrates how to use the menu widgets. Each widget
    will work on the same model and list.  All widgets are configured
    to use the string as the  selection value (not the index into 
    the list).
    The example contains a  SequenceView  widget, which in general is
    not a kind of menu, but the interface (its model) looks similar.
    Notice, that initially, all widgets are disabled (to demonstrate
    the use of enableChannels). To enable the widgets, select the menu
    item under the 'Enable Channel' menu entry.

    [author:]
        Claus Atzkern

    [start with:]
        GUIDemoMenu open
        GUIDemo open
"


! !

!GUIDemoMenu class methodsFor:'interface specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoMenu andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoMenu menu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Enable Channel'
                #submenu: 
                 #(#Menu
                    
                     #(
                       #(#MenuItem
                          #label: 'Enable Selection'
                          #indication: #enabledChannel
                      )
                    ) nil
                    nil
                )
            )
             #(#MenuItem
                #label: ''
            )
             #(#MenuItem
                #label: '='
            )
             #(#MenuItem
                #label: 'foo'
                #value: #doSelect:
                #enabled: #enabledChannel
                #argument: 'foo'
                #indication: #isFooSelected
            )
             #(#MenuItem
                #label: '='
            )
             #(#MenuItem
                #label: 'bar'
                #value: #doSelect:
                #enabled: #enabledChannel
                #argument: 'bar'
                #indication: #isBarSelected
            )
             #(#MenuItem
                #label: '='
            )
             #(#MenuItem
                #label: 'baz'
                #value: #doSelect:
                #enabled: #enabledChannel
                #argument: 'baz'
                #indication: #isBazSelected
            )
             #(#MenuItem
                #label: '='
            )
          ) nil
          nil
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoMenu andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoMenu new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoMenu open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #name: #windowSpec
          #window: 
           #(#WindowSpec
              #name: 'Menu'
              #layout: #(#LayoutFrame 216 0 173 0 529 0 800 0)
              #level: 0
              #label: 'Menu'
              #min: #(#Point 10 10)
              #max: #(#Point 1160 870)
              #bounds: #(#Rectangle 216 173 530 801)
              #usePreferredExtent: false
              #returnIsOKInDialog: true
              #escapeIsCancelInDialog: true
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#LabelSpec
                    #name: 'PullDownMenu Label'
                    #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 19 0)
                    #level: 1
                    #label: 'PullDownMenu'
                    #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                    #resizeForLabel: true
                    #adjust: #left
                )
                 #(#MenuPanelSpec
                    #name: 'PullDownMenu Widget'
                    #layout: #(#LayoutFrame 0 0.0 23 0.0 0 1.0 46 0.0)
                    #menu: #menu
                )
                 #(#LabelSpec
                    #name: 'Tabview Label'
                    #layout: #(#LayoutFrame 0 0.0 65 0 0 1.0 84 0)
                    #level: 1
                    #label: 'Tabview'
                    #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                    #resizeForLabel: true
                    #adjust: #left
                )
                 #(#TabViewSpec
                    #name: 'TabView Widget'
                    #layout: #(#LayoutFrame 5 0.0 89 0 -5 1.0 125 0)
                    #enableChannel: #enabledChannel
                    #model: #selectionHolder
                    #menu: #listHolder
                )
                 #(#LabelSpec
                    #name: 'PopUpList Label'
                    #layout: #(#LayoutFrame 0 0.0 145 0 0 1.0 164 0)
                    #level: 1
                    #label: 'PopUpList'
                    #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                    #resizeForLabel: true
                    #adjust: #left
                )
                 #(#PopUpListSpec
                    #name: 'PopUpList Widget'
                    #layout: #(#LayoutFrame 5 0.0 169 0 -5 1.0 191 0)
                    #label: 'PopUpList'
                    #model: #selectionHolder
                    #enableChannel: #enabledChannel
                    #menu: #listHolder
                    #useIndex: false
                )
                 #(#LabelSpec
                    #name: 'ComboBox Label'
                    #layout: #(#LayoutFrame 0 0.0 210 0 0 1.0 229 0)
                    #level: 1
                    #label: 'ComboBox'
                    #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                    #resizeForLabel: true
                    #adjust: #left
                )
                 #(#ComboBoxSpec
                    #name: 'ComboBox Widget'
                    #layout: #(#LayoutFrame 5 0.0 234 0 -5 1.0 254 0)
                    #enableChannel: #enabledChannel
                    #model: #selectionHolder
                    #immediateAccept: false
                    #acceptOnTab: false
                    #comboList: #listHolder
                    #useIndex: false
                )
                 #(#LabelSpec
                    #name: 'ComboList Label'
                    #layout: #(#LayoutFrame 0 0.0 274 0 0 1.0 293 0)
                    #level: 1
                    #label: 'ComboList'
                    #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                    #resizeForLabel: true
                    #adjust: #left
                )
                 #(#ComboListSpec
                    #name: 'ComboList Widget'
                    #layout: #(#LayoutFrame 5 0.0 298 0 -5 1.0 318 0)
                    #enableChannel: #enabledChannel
                    #model: #selectionHolder
                    #comboList: #listHolder
                    #useIndex: false
                )
                 #(#LabelSpec
                    #name: 'SequenceView Label'
                    #layout: #(#LayoutFrame 0 0.0 387 0 0 1.0 406 0)
                    #level: 1
                    #label: 'SequenceView'
                    #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                    #resizeForLabel: true
                    #adjust: #left
                )
                 #(#SequenceViewSpec
                    #name: 'SequenceView Widget'
                    #layout: #(#LayoutFrame 5 0.0 411 0.0 -5 1.0 0 1.0)
                    #enableChannel: #enabledChannel
                    #model: #selectionHolder
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #miniScrollerHorizontal: true
                    #useIndex: false
                    #sequenceList: #listHolder
                )
                 #(#LabelSpec
                    #name: 'RadioButtonLabel'
                    #layout: #(#LayoutFrame 0 0.0 338 0 0 1.0 357 0)
                    #level: 1
                    #label: 'Radio Buttons'
                    #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                    #resizeForLabel: true
                    #adjust: #left
                )
                 #(#RadioButtonSpec
                    #name: 'RadioButton1'
                    #layout: #(#LayoutFrame 2 0.0 361 0 66 0 383 0)
                    #label: 'foo'
                    #translateLabel: true
                    #model: #selectionHolder
                    #enableChannel: #enabledChannel
                    #isTriggerOnDown: true
                    #lampColor: #(#Color 0.0 66.9993 0.0)
                    #select: 'foo'
                )
                 #(#RadioButtonSpec
                    #name: 'RadioButton2'
                    #layout: #(#LayoutFrame 67 0.0 361 0 131 0 383 0)
                    #label: 'bar'
                    #translateLabel: true
                    #model: #selectionHolder
                    #enableChannel: #enabledChannel
                    #isTriggerOnDown: true
                    #lampColor: #(#Color 100.0 100.0 0.0)
                    #select: 'bar'
                )
                 #(#RadioButtonSpec
                    #name: 'RadioButton3'
                    #layout: #(#LayoutFrame 139 0.0 361 0 206 0 383 0)
                    #label: 'baz'
                    #translateLabel: true
                    #model: #selectionHolder
                    #enableChannel: #enabledChannel
                    #isTriggerOnDown: true
                    #lampColor: #(#Color 100.0 0.0 0.0)
                    #select: 'baz'
                )
              )
          )
      )
! !

!GUIDemoMenu methodsFor:'accessing menu'!

doSelect:something
    "called from menu when selection changed; the argument is the
     label selected (see menu specification).
    "
    |sel|

    something = selection ifTrue:[
        self showCR:'menu: deselect'
    ] ifFalse:[
        self showCR:'menu: change selection to: ', something.
        sel := something.
    ].
    self selectionHolder value:sel


!

menu
    "this window spec was automatically generated by the ST/X MenuEditor"

    ^ self class menu


! !

!GUIDemoMenu methodsFor:'aspects'!

enabledChannel
    "returns a value holder, which is set to true if selection mode is enabled
    "
    ^ builder booleanValueAspectFor:#enabledChannel

" SAME AS:

    |holder|

    (holder := builder bindingAt:#enabledChannel) isNil ifTrue:[
        builder aspectAt:#enabledChannel put:(holder :=  ValueHolder new).
        holder value:true
    ].
    ^ holder
"


!

isBarSelected
    "returns a value holder, which is set to true in case that
     'bar' is selected (see menu specification).
    "
    ^ builder booleanValueAspectFor:#isBarSelected


!

isBazSelected
    "returns a value holder, which is set to true in case that
     'baz' is selected (see menu specification).
    "
    ^ builder booleanValueAspectFor:#isBazSelected


!

isFooSelected
    "returns a value holder, which is set to true in case that
     'baz' is selected (see menu specification).
    "
    ^ builder booleanValueAspectFor:#isFooSelected


!

listHolder
    "returns list used by the all menu lists
    "
    ^ #( 'foo' 'bar' 'baz' )

"
  OR:   if list might change during processing

    |holder|

    (holder := builder bindingAt:#listHolder) isNil ifTrue:[
        builder aspectAt:#listHolder put:(holder :=  ValueHolder new).
        holder value:#( 'foo' 'bar' 'baz' )
    ].
    ^ holder
"

!

selectionHolder
    "returns a value holder, which keeps the current selection as string
     or nil
    "
    |holder|

    (holder := builder bindingAt:#selectionHolder) isNil ifTrue:[
        holder := AspectAdaptor new subject:self; forAspect:#selection.
        builder aspectAt:#selectionHolder put:holder.
    ].
    ^ holder

! !

!GUIDemoMenu methodsFor:'selection'!

selection
    "get the current selection
    "
    ^ selection

!

selection:aNewSelection
    "set the selection and update the subcanvas view and the enabled holders
     used by the menu.
    "
    selection ~= aNewSelection ifTrue:[
        (selection := aNewSelection) notNil ifTrue:[
            self showCR:'selection changed to:  ', selection printString
        ] ifFalse:[
            self showCR:'nothing selected'.
        ].

        "/ update enabled channels

        self isBarSelected value:(selection = 'bar').
        self isBazSelected value:(selection = 'baz').
        self isFooSelected value:(selection = 'foo').
    ].

! !

!GUIDemoMenu class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoMenu.st,v 1.7 2001-12-08 13:43:41 cg Exp $'
! !
