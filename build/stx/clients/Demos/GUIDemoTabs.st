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

GUIDemoApplication subclass:#GUIDemoTabs
	instanceVariableNames:'index updateTab'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoTabs class methodsFor:'documentation'!

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







! !

!GUIDemoTabs class methodsFor:'interface specs'!

tabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass:CodingExamples_GUI::GUIDemoTabs andSelector:#tabList
    "

    <resource: #tabList>

    ^     #(
       #(#TabItem
          #label: 'foo'
          #translateLabel: true
        )
       #(#TabItem
          #label: 'bar'
          #enabled: false
          #foregroundColor: #(#Color 100.0 0.0 0.0)
          #translateLabel: true
        )
       #(#TabItem
          #label: 'baz'
          #foregroundColor: #(#Color 100.0 0.0 0.0)
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoTabs andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoTabs new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoTabs open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Demo Tabs'
              #layout: #(#LayoutFrame 86 0 263 0 402 0 565 0)
              #label: 'Demo Tabs'
              #min: #(#Point 10 10)
              #max: #(#Point 1280 1024)
              #bounds: #(#Rectangle 86 263 403 566)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#TabViewSpec
                    #name: 'TabList'
                    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 45 0)
                    #model: #tabSelection
                    #menu: #tabList
                    #useIndex: true
                )
                 #(#NoteBookViewSpec
                    #name: 'NoteBook'
                    #layout: #(#LayoutFrame 0 0.0 65 0 0 1.0 -160 1.0)
                    #model: #tabSelection
                    #menu: #tabList
                    #useIndex: true
                )
                 #(#ViewSpec
                    #name: 'Configuration'
                    #layout: #(#LayoutFrame 0 0.0 -160 1.0 0 1.0 0 1.0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#LabelSpec
                              #name: 'TabIndexLabel'
                              #layout: #(#AlignmentOrigin 57 0 19 0 1 0.5)
                              #label: 'Index:'
                              #resizeForLabel: true
                          )
                           #(#ArrowButtonSpec
                              #name: 'L Button'
                              #layout: #(#LayoutFrame 63 0 9 0 85 0 31 0)
                              #model: #index:
                              #isTriggerOnDown: true
                              #actionValue: '-'
                              #direction: #left
                          )
                           #(#LabelSpec
                              #name: 'IndexHolder'
                              #layout: #(#LayoutFrame 87 0 9 0 114 0 31 0)
                              #labelChannel: #indexStringHolder
                              #level: 1
                          )
                           #(#ArrowButtonSpec
                              #name: 'R Button'
                              #layout: #(#LayoutFrame 116 0 9 0 138 0 31 0)
                              #model: #index:
                              #isTriggerOnDown: true
                              #actionValue: '+'
                              #direction: #right
                          )
                           #(#FramedBoxSpec
                              #name: 'Frame Configuration'
                              #layout: #(#LayoutFrame 0 0.0 40 0 0 1.0 0 1.0)
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#CheckBoxSpec
                                        #name: 'IsEnabled'
                                        #layout: #(#LayoutOrigin 43 0 62 0)
                                        #model: #isEnabled
                                        #label: 'Is Enabled'
                                    )
                                     #(#LabelSpec
                                        #name: 'TabLabel'
                                        #layout: #(#AlignmentOrigin 45 0 14 0 1 0.5)
                                        #label: 'Label:'
                                        #resizeForLabel: true
                                    )
                                     #(#InputFieldSpec
                                        #name: 'LabelHolder'
                                        #layout: #(#LayoutFrame 47 0 4 0 -7 1.0 26 0)
                                        #model: #labelHolder
                                        #immediateAccept: false
                                    )
                                     #(#LabelSpec
                                        #name: 'ColorLabel'
                                        #layout: #(#AlignmentOrigin 45 0 43 0 1 0.5)
                                        #label: 'Color:'
                                        #resizeForLabel: true
                                    )
                                     #(#MenuPanelSpec
                                        #name: 'ColorMenu'
                                        #layout: #(#LayoutFrame 47 0 33 0 157 0 56 0)
                                        #menu: #colorMenu
                                    )
                                  )
                              )
                              #label: 'Configuration'
                              #labelPosition: #topLeft
                          )
                        )
                    )
                    #level: 1
                )
              )
          )
      )
! !

!GUIDemoTabs class methodsFor:'resources'!

bar
    |icon|

    icon := Smalltalk imageFromFileNamed:'xpmBitmaps/document_images/tiny_yellow_dir_open.xpm' 
                      inPackage:'stx:goodies'.
    ^ LabelAndIcon icon:icon string:'bar'.
!

foo
    ^  Smalltalk imageFromFileNamed:'xpmBitmaps/document_images/tiny_yellow_dir.xpm' 
                  inPackage:'stx:goodies'.

! !

!GUIDemoTabs methodsFor:'accessing'!

colorMenu
    "returns the color menu
    "
    |menu|

    menu := ColorMenu colorMenu:true value:#colorChanged:.
    menu receiver:self.
  ^ menu
! !

!GUIDemoTabs methodsFor:'actions'!

index:anArg
    "index changed; setup configuration
    "
    |delta|

    delta := (anArg = '+') ifTrue:1 ifFalse:-1.
    index := (index + delta) - 1 \\ self tabList size + 1.

    self updateHoldersForIndex:index
!

updateHoldersForIndex:anArg
    "index changed; setup configuration
    "
    |tab|

    tab := self tabList at:index.

    updateTab := false.

    self labelHolder value:(tab label).
    self indexStringHolder value:(index printString).
    self isEnabled   value:(tab isEnabled).

    updateTab := true.
! !

!GUIDemoTabs methodsFor:'aspects'!

indexStringHolder
    "holder which keeps the index as a printable string
    "
    |holder|

    (holder := builder bindingAt:#indexStringHolder) isNil ifTrue:[
        builder aspectAt:#indexStringHolder put:(holder := index printString asValue).
    ].
    ^ holder
!

isEnabled
    "holder which keeps the enabled state of the current tab
    "
    |holder|

    (holder := builder bindingAt:#isEnabled) isNil ifTrue:[
        builder aspectAt:#isEnabled put:(holder :=  false asValue).
        holder onChangeSend:#enabedStateChanged to:self.
    ].
    ^ holder
!

labelHolder
    "holder which keeps the label of the current tab
    "
    |holder|

    (holder := builder bindingAt:#labelHolder) isNil ifTrue:[
        builder aspectAt:#labelHolder put:(holder :=  ValueHolder new).
        holder onChangeSend:#labelHolderChanged to:self.
    ].
    ^ holder
!

tabList
    "automatically generated by TabItem Editor ..."

    |list|

    (list := builder bindingAt:#tabList) isNil ifTrue:[
        builder aspectAt:#tabList put:(list := self class tabList).
    ].
    ^ list
!

tabSelection
    "holder which keeps the current tab selection as integer
    "
    |holder|

    (holder := builder bindingAt:#tabSelection) isNil ifTrue:[
        builder aspectAt:#tabSelection put:(holder :=  ValueHolder new).
    ].
    ^ holder
! !

!GUIDemoTabs methodsFor:'change & update'!

colorChanged:aColor
    "color changed
    "
    |tab|

    (tab := self whichTabIsModified) notNil ifTrue:[
        tab foregroundColor:aColor
    ]
!

enabedStateChanged
    "enabled state changed
    "
    |tab|

    (tab := self whichTabIsModified) notNil ifTrue:[
        tab enabled:(self isEnabled value).
    ]

!

labelHolderChanged
    "label changed
    "
    |tab|

    (tab := self whichTabIsModified) notNil ifTrue:[
        tab label:(self labelHolder value).
    ]
! !

!GUIDemoTabs methodsFor:'initialization'!

initialize
    "setup defaults
    "
    super initialize.
    index := 1.
    updateTab := true.

!

postBuildWith:aBuilder
    super postBuildWith:aBuilder.
    self updateHoldersForIndex:index
! !

!GUIDemoTabs methodsFor:'private'!

whichTabIsModified
    "returns the current tab to be configured or nil
    "
    ^ updateTab ifTrue:[self tabList at:index ifAbsent:nil] ifFalse:[nil]

! !

!GUIDemoTabs class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoTabs.st,v 1.5 2003-03-20 11:19:57 cg Exp $'
! !
