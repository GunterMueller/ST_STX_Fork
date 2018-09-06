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

ApplicationModel subclass:#ArbitraryComponentDemo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUIBuilder'
!

!ArbitraryComponentDemo class methodsFor:'documentation'!

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
    simple example using arbitrary components.
    The components are static - i.e. created when the GUI is
    opened and not changed thereafter.

    [author:]
        cg

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!ArbitraryComponentDemo class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::ArbitraryComponentDemo andSelector:#windowSpec
     CodingExamples_GUI::ArbitraryComponentDemo new openInterface:#windowSpec
     CodingExamples_GUI::ArbitraryComponentDemo open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'ArbitraryComponentDemo'
          #name: 'ArbitraryComponentDemo'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 13 23 329 323)
          #menu: #mainMenu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#ArbitraryComponentSpec
              #name: 'ArbitraryComponent1'
              #layout: #(#LayoutFrame 6 0 29 0 155 0 169 0)
              #hasBorder: false
              #component: #view1
            )
           #(#ArbitraryComponentSpec
              #name: 'ArbitraryComponent2'
              #layout: #(#LayoutFrame 160 0 173 0 295 0 294 0)
              #hasBorder: false
              #component: #view2
            )
           #(#LabelSpec
              #label: 'view1, a ClockView'
              #name: 'Label1'
              #layout: #(#LayoutFrame 6 0 5 0 155 0 27 0)
              #level: 1
              #translateLabel: true
            )
           #(#LabelSpec
              #label: 'view2'
              #name: 'Label2'
              #layout: #(#LayoutFrame 164 0 148 0 293 0 170 0)
              #level: 1
              #translateLabel: true
            )
           )
         
        )
      )

    "Modified: / 11.2.2000 / 01:43:29 / cg"
! !

!ArbitraryComponentDemo class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::ArbitraryComponentDemo andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::ArbitraryComponentDemo mainMenu)) startUp
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
! !

!ArbitraryComponentDemo methodsFor:'components'!

view1
    ^ ClockView new

    "Created: / 5.2.2000 / 18:03:31 / cg"
!

view2
    ^ View new viewBackground:Color red

    "Created: / 5.2.2000 / 18:03:43 / cg"
! !

!ArbitraryComponentDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ArbitraryComponentDemo.st,v 1.3 2000-02-11 13:33:28 cg Exp $'
! !
