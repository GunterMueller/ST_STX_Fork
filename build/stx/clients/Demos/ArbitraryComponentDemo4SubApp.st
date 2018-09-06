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

ApplicationModel subclass:#ArbitraryComponentDemo4SubApp
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUIBuilder'
!

!ArbitraryComponentDemo4SubApp class methodsFor:'documentation'!

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
    simple example for plugged aspects with embedded sub-applications.

    This application exports two aspects, which can be connected to an embedding
    applications aspects.
    (see CodingExamples_GUI::ArbitraryComponentDemo4 as example)

    Notice, that any GUI-application can immediately make use of my,
    and connect my aspects without a need for program code
    (i.e. the connection can be made in the GUI Painter)

    [author:]
        cg

    [see also:]

    [instance variables:]

    [class variables:]
"



! !

!ArbitraryComponentDemo4SubApp class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::ArbitraryComponentDemo4SubApp andSelector:#windowSpec
     CodingExamples_GUI::ArbitraryComponentDemo4SubApp new openInterface:#windowSpec
     CodingExamples_GUI::ArbitraryComponentDemo4SubApp open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'ArbitraryComponentDemo3'
          #name: 'ArbitraryComponentDemo3'
          #min: #(#Point 0 0)
          #max: #(#Point 1024 721)
          #bounds: #(#Rectangle 12 22 312 170)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#LabelSpec
              #label: 'Embedded SubCanvas'
              #name: 'Label1'
              #layout: #(#LayoutFrame 0 0.0 9 0 0 1.0 31 0)
              #level: 1
              #translateLabel: true
            )
           #(#ArbitraryComponentSpec
              #name: 'ArbitraryComponent1'
              #layout: #(#LayoutOrigin 84 0 103 0)
              #model: #ledValue
              #hasBorder: false
              #subAspectHolders: 
             #(#Array
                
               #(#SubChannelInfoSpec
                  #subAspect: #ledColorChannel
                  #aspect: #ledColor
                )
              )
              #component: #DigitalLedDisplay
            )
           #(#ComboListSpec
              #name: 'colorList'
              #layout: #(#LayoutFrame 84 0 43 0 209 0 63 0)
              #model: #colorNameValue
              #comboList: 
             #(#red
                #green #yellow
                #white
              )
              #useIndex: false
            )
           #(#InputFieldSpec
              #name: 'valueEntryField'
              #layout: #(#LayoutFrame 84 0 74 0 289 0 96 0)
              #model: #ledValue
              #type: #number
              #acceptOnLeave: true
              #acceptOnLostFocus: true
              #acceptOnPointerLeave: true
            )
           #(#LabelSpec
              #label: 'Color:'
              #name: 'colorLabel'
              #layout: #(#LayoutFrame 8 0 42 0 81 0 64 0)
              #translateLabel: true
              #adjust: #right
            )
           #(#LabelSpec
              #label: 'Value:'
              #name: 'valueLabel'
              #layout: #(#LayoutFrame 8 0 75 0 81 0 97 0)
              #translateLabel: true
              #adjust: #right
            )
           )
         
        )
      )
! !

!ArbitraryComponentDemo4SubApp class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(#ledColor #ledValue )
! !

!ArbitraryComponentDemo4SubApp methodsFor:'aspects'!

colorNameValue
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#colorNameValue) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#colorNameValue put:holder.
"/        holder addDependent:self.
    ].
    ^ holder.
!

ledColor
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#ledColor) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#ledColor put:holder.
"/        holder addDependent:self.
    ].
    ^ holder.
!

ledValue
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#ledValue) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#ledValue put:holder.
"/        holder addDependent:self.
    ].
    ^ holder.
! !

!ArbitraryComponentDemo4SubApp methodsFor:'aspects - exported'!

ledColor:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ |holder|

    "/ (holder := builder bindingAt:#ledColor) notNil ifTrue:[
    "/     holder removeDependent:self.
    "/ ].
    builder aspectAt:#ledColor put:something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.
!

ledValue:something
    "automatically generated by UIPainter ..."

    "This method is used when I am embedded as subApplication,"
    "and the mainApp wants to connect its aspects to mine."

    "/ |holder|

    "/ (holder := builder bindingAt:#ledValue) notNil ifTrue:[
    "/     holder removeDependent:self.
    "/ ].
    builder aspectAt:#ledValue put:something.
    "/ something notNil ifTrue:[
    "/     something addDependent:self.
    "/ ].
    ^ self.
! !

!ArbitraryComponentDemo4SubApp class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ArbitraryComponentDemo4SubApp.st,v 1.1 2000-02-17 14:55:55 cg Exp $'
! !
