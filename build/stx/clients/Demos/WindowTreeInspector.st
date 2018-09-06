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

"{ Package: 'stx:clients/Demos' }"

ApplicationModel subclass:#WindowTreeInspector
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Inspector'
!

!WindowTreeInspector class methodsFor:'documentation'!

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
    New, improved windowTreeView;
    combines the original windowTreeView and two inspectors.
    Also demonstrates the use of arbitraryComponents and
    how to plugIn components using the new aspectSelector linking
    scheme.

    [author:]
        Claus Gittinger (cg@exept.de)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

examples
"
                                                                [exBegin]
    WindowTreeInspector open
                                                                [exEnd]
"
! !

!WindowTreeInspector class methodsFor:'image specs'!

zoomInImage
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self zoomInImage inspect
     ImageEditor openOnClass:self andSelector:#zoomInImage
    "

    <resource: #image>

    ^Icon
        constantNamed:#'WindowTreeInspector zoomInImage'
        ifAbsentPut:[(Depth8Image new) width: 26; height: 26; photometric:(#palette); bitsPerSample:(#(8 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\@@@@@@@@DA0\GA0\GA0\GA0\GA0\GA0\@@@PAA@DD
@P@@A@\GA0\GA0\GA0\GA0\G@@PAA@PDA@PD@PD@A@\GA0\GA0\GA0\GA0@D@PPEAP@@@0TEA@D@A@\GA0\GA0\GA0\GA@DDAPTC@@@CAPLEA@D@A0\GA0\G
A0\GA0@AA@TE@PL@@@LCAPLEA@@DA0\GA0\GA0\G@@DEAPTC@0@@APTCAPLEA@@GA0\GA0\GA0\@@PT@@@@@@@@@@@@@@0TD@@\GA0\GA0\GA0@A@0@@@@@@
@@@@@@@EAPP@A0\GA0\GA0\G@@DCAPTEAP@@APTD@ PEA@@GA0\GA0\GA0\@@PDCAPTE@@@EA@HDA@TD@@\GA0\GA0\GA0\@@PDCAPT@@@PBA@PEA@@GA0\G
A0\GA0\GA0@@@PTC@0@@APTEAPP@@@\GA0\GA0\GA0\GA0@@A@PC@0LEAPPD@@X@A0\GA0\GA0\GA0\GA0@@@@@@@@@@@@@FAP@GA0\GA0\GA0\GA0\GA0\@
@@@@@@@@@@PFAP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\E@@PFAP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@PFAP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@PF
AP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@PFAP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@PFAP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@@D@@\GA0\GA0\G
A0\GA0\GA0\GA0\GA0\G@@@GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0@a') ; colorMapFromArray:#[0 0 0 0 255 255 0 0 128 255 255 255 112 128 144 192 192 192 160 82 45 0 0 0]; mask:((ImageMask new) width: 26; height: 26; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@A?@@@A?<@@@?? @@_?<@@G??@@C??8@@??>@@O?? @C??8@@??>@@O?? @A??0@@_?<@@C??@@@_?0@@A?>@@@@O0@@@@>@@@@G0@@@@>@@@@
G0@@@@<@@@@F@@@@@@@b') ; yourself); yourself]

    "Created: / 11.2.2000 / 00:17:20 / cg"
!

zoomOutImage
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self zoomOutImage inspect
     ImageEditor openOnClass:self andSelector:#zoomOutImage
    "

    <resource: #image>

    ^Icon
        constantNamed:#'Object zoomOutImage'
        ifAbsentPut:[(Depth8Image new) width: 26; height: 26; photometric:(#palette); bitsPerSample:(#(8 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\@@@@@@@@DA0\GA0\GA0\GA0\GA0\GA0\@@@PAA@DD
@P@@A@\GA0\GA0\GA0\GA0\G@@PAA@PDA@PD@PD@A@\GA0\GA0\GA0\GA0@D@PPEAPTC@0TEA@D@A@\GA0\GA0\GA0\GA@DDAPTC@0DCAPLEA@D@A0\GA0\G
A0\GA0@AA@TE@PLA@0LCAPLEA@@DA0\GA0\GA0\G@@DEAPTC@0TEAPTCAPLEA@@GA0\GA0\GA0\@@PT@@@@@@@@@@@@@@0TD@@\GA0\GA0\GA0@A@0@@@@@@
@@@@@@@EAPP@A0\GA0\GA0\G@@DCAPTEAPTEAPTD@ PEA@@GA0\GA0\GA0\@@PDCAPTEAPTEA@HDA@TD@@\GA0\GA0\GA0\@@PDCAPTEAPPBA@PEA@@GA0\G
A0\GA0\GA0@@@PTC@0TEAPTEAPP@@@\GA0\GA0\GA0\GA0@@A@PC@0LEAPPD@@X@A0\GA0\GA0\GA0\GA0@@@@@@@@@@@@@FAP@GA0\GA0\GA0\GA0\GA0\@
@@@@@@@@@@PFAP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\E@@PFAP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@PFAP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@PF
AP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@PFAP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@PFAP@GA0\GA0\GA0\GA0\GA0\GA0\GA0\G@@PD@@\GA0\GA0\G
A0\GA0\GA0\GA0\GA0\G@@@GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0\GA0@a') ; colorMapFromArray:#[0 0 0 0 255 255 0 0 128 255 255 255 112 128 144 192 192 192 160 82 45 0 0 0]; mask:((ImageMask new) width: 26; height: 26; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@A?@@@A?<@@@?? @@_?<@@G??@@C??8@@??>@@O?? @C??8@@??>@@O?? @A??0@@_?<@@C??@@@_?0@@A?>@@@@O0@@@@>@@@@G0@@@@>@@@@
G0@@@@<@@@@F@@@@@@@b') ; yourself); yourself]

    "Created: / 11.2.2000 / 00:16:21 / cg"
! !

!WindowTreeInspector class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:WindowTreeInspector andSelector:#windowSpec
     WindowTreeInspector new openInterface:#windowSpec
     WindowTreeInspector open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Widget Inspector'
          #name: 'Widget Inspector'
          #min: #(#Point 0 0)
          #max: #(#Point 1024 721)
          #bounds: #(#Rectangle 13 23 480 533)
          #menu: #menu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#VariableVerticalPanelSpec
              #name: 'VariableVerticalPanel1'
              #layout: #(#LayoutFrame 0 0.0 1 0.0 0 1.0 0 1.0)
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#ArbitraryComponentSpec
                    #name: 'windowTree'
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #hasBorder: false
                    #subAspectHolders: #(
                     #(#selectionHolder
                        #theSelection #selectionChanged
                      )
                     )
                   
                    #component: #WindowTreeView
                  )
                 #(#VariableHorizontalPanelSpec
                    #name: 'VariableHorizontalPanel1'
                    #component: 
                   #(#SpecCollection
                      #collection: #(
                       #(#ViewSpec
                          #name: 'Box1'
                          #component: 
                         #(#SpecCollection
                            #collection: #(
                             #(#LabelSpec
                                #label: 'Widget'
                                #name: 'widgetLabel'
                                #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 24 0)
                                #translateLabel: true
                                #labelChannel: #widgetLabelHolder
                              )
                             #(#ArbitraryComponentSpec
                                #name: 'widgetInspector'
                                #layout: #(#LayoutFrame 0 0.0 24 0.0 0 1.0 0 1.0)
                                #hasBorder: false
                                #component: #InspectorView
                              )
                             )
                           
                          )
                        )
                       #(#ViewSpec
                          #name: 'Box2'
                          #component: 
                         #(#SpecCollection
                            #collection: #(
                             #(#LabelSpec
                                #label: 'Model'
                                #name: 'modelLabel'
                                #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 24 0)
                                #translateLabel: true
                                #labelChannel: #modelLabelHolder
                              )
                             #(#ArbitraryComponentSpec
                                #name: 'modelInspector'
                                #layout: #(#LayoutFrame 0 0.0 24 0.0 0 1.0 0 1.0)
                                #hasBorder: false
                                #component: #InspectorView
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                    #handles: #(#Any 0.5 1.0)
                  )
                 )
               
              )
              #handles: #(#Any 0.5 1.0)
            )
           )
         
        )
      )

    "Modified: / 11.2.2000 / 00:19:05 / cg"
! !

!WindowTreeInspector class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:WindowTreeInspector andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(WindowTreeInspector menu)) startUp
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
         #(#MenuItem
            #label: 'View'
            #translateLabel: true
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Update'
                  #translateLabel: true
                  #value: #updateWidgetTree
                )
               #(#MenuItem
                  #label: '-'
                )
               #(#MenuItem
                  #label: 'Zoom In'
                  #translateLabel: true
                  #value: #zoomIn
                  #labelImage: #(#ResourceRetriever nil #zoomInImage 'Zoom In')
                )
               #(#MenuItem
                  #label: 'ZoomOut'
                  #translateLabel: true
                  #value: #zoomOut
                  #labelImage: #(#ResourceRetriever nil #zoomOutImage 'ZoomOut')
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

    "Modified: / 11.2.2000 / 00:19:02 / cg"
! !

!WindowTreeInspector methodsFor:'actions'!

selectionChanged
    |theWidget model widgetInspector app modelInspector|

    widgetInspector := builder componentAt:#widgetInspector.
    modelInspector := builder componentAt:#modelInspector.

    (theWidget := self theSelection value) isNil ifTrue:[
        self widgetLabelHolder value:'Widget'.
        widgetInspector inspect:nil.
        modelInspector inspect:nil.
    ] ifFalse:[        
        self widgetLabelHolder value:(theWidget class name).
        widgetInspector inspect:theWidget.

        model := theWidget model.
        model isNil ifTrue:[
            app := theWidget application
        ].
        model isNil ifTrue:[
            app isNil ifTrue:[
                self modelLabelHolder value:'Model'.
                modelInspector inspect:nil.
            ] ifFalse:[
                self modelLabelHolder value:'App: ' , app class name.
                modelInspector inspect:app.
            ]
        ] ifFalse:[
            self modelLabelHolder value:('Model: ' , model class name).
            modelInspector inspect:model.
        ].
    ]

    "Modified: / 10.2.2000 / 11:59:34 / cg"
! !

!WindowTreeInspector methodsFor:'aspects'!

modelLabelHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#modelLabelHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#modelLabelHolder put:holder.
    ].
    ^ holder.

    "Created: / 10.2.2000 / 11:49:24 / cg"
!

theSelection
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#theSelection) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#theSelection put:holder.
    ].
    ^ holder.

    "Created: / 10.2.2000 / 01:38:18 / cg"
!

widgetLabelHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#widgetLabelHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#widgetLabelHolder put:holder.
    ].
    ^ holder.

    "Created: / 10.2.2000 / 11:49:21 / cg"
! !

!WindowTreeInspector methodsFor:'menu action'!

updateWidgetTree
    (builder componentAt:#windowTree) update.

    "Created: / 10.2.2000 / 18:29:37 / cg"
    "Modified: / 10.2.2000 / 18:44:58 / cg"
!

zoomIn
    (builder componentAt:#windowTree) zoomIn.

    "Created: / 10.2.2000 / 18:29:42 / cg"
    "Modified: / 10.2.2000 / 18:30:12 / cg"
!

zoomOut
    (builder componentAt:#windowTree) zoomOut.

    "Created: / 10.2.2000 / 18:29:42 / cg"
    "Modified: / 10.2.2000 / 18:30:18 / cg"
! !

!WindowTreeInspector class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/WindowTreeInspector.st,v 1.4 2001-09-25 13:02:24 cg Exp $'
! !
