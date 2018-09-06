"
 COPYRIGHT (c) 2000 by eXept Software AG 
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.


"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#ArbitraryComponentDemo2
	instanceVariableNames:'widgetHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUIBuilder'
!

!ArbitraryComponentDemo2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG 
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
    simple example using dynamic arbitrary components.
    The components are dynamic - i.e. by setting a valueHolder,
    the embedded arbitrary component is changed.

    [author:]
        cg

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!ArbitraryComponentDemo2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::ArbitraryComponentDemo2 andSelector:#windowSpec
     CodingExamples_GUI::ArbitraryComponentDemo2 new openInterface:#windowSpec
     CodingExamples_GUI::ArbitraryComponentDemo2 open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'ArbitraryComponentDemo2'
          #name: 'ArbitraryComponentDemo2'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 218 175 604 521)
          #menu: #mainMenu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#ArbitraryComponentSpec
              #name: 'ArbitraryComponent1'
              #layout: #(#LayoutFrame 6 0 29 0 204 0 211 0)
              #level: -1
              #hasBorder: false
              #viewChannel: #widgetHolder
            )
           #(#LabelSpec
              #label: 'view, a dynamic arbitrary component'
              #name: 'Label1'
              #layout: #(#LayoutFrame 6 0 5 0 314 0 27 0)
              #level: 1
              #translateLabel: true
            )
           #(#HorizontalPanelViewSpec
              #name: 'HorizontalPanel1'
              #layout: #(#LayoutFrame 0 0.0 228 0 0 1.0 298 0)
              #horizontalLayout: #fitSpace
              #verticalLayout: #center
              #horizontalSpace: 3
              #verticalSpace: 3
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#ActionButtonSpec
                    #label: 'Clock'
                    #name: 'Button1'
                    #translateLabel: true
                    #model: #makeClock
                    #extent: #(#Point 124 22)
                  )
                 #(#ActionButtonSpec
                    #label: 'Empty Red'
                    #name: 'Button2'
                    #translateLabel: true
                    #model: #makeEmptyRed
                    #extent: #(#Point 125 22)
                  )
                 #(#ActionButtonSpec
                    #label: 'Empty Green'
                    #name: 'Button3'
                    #translateLabel: true
                    #model: #makeEmptyGreen
                    #extent: #(#Point 125 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )

    "Modified: / 11.2.2000 / 01:43:40 / cg"
! !

!ArbitraryComponentDemo2 class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::ArbitraryComponentDemo2 andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::ArbitraryComponentDemo2 mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'File'
            #translateLabel: true
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Exit'
                  #translateLabel: true
                  #value: #closeRequest
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

    "Modified: / 5.2.2000 / 18:01:51 / cg"
    "Created: / 5.2.2000 / 18:07:00 / cg"
! !

!ArbitraryComponentDemo2 methodsFor:'actions'!

makeClock
    self widgetHolder value:ClockView new

    "Created: / 5.2.2000 / 18:10:53 / cg"
!

makeEmptyGreen
    self widgetHolder value:(View new viewBackground:Color green)

    "Created: / 5.2.2000 / 18:11:21 / cg"
!

makeEmptyRed
    self widgetHolder value:(View new viewBackground:Color red)

    "Created: / 5.2.2000 / 18:11:15 / cg"
! !

!ArbitraryComponentDemo2 methodsFor:'components'!

widgetHolder
    widgetHolder isNil ifTrue:[
        widgetHolder := ValueHolder new.
    ].
    ^ widgetHolder

    "Created: / 5.2.2000 / 18:07:58 / cg"
! !

!ArbitraryComponentDemo2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ArbitraryComponentDemo2.st,v 1.3 2000-02-11 13:33:43 cg Exp $'
! !
