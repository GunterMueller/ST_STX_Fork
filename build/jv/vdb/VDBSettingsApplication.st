"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

AbstractSettingsApplication subclass:#VDBSettingsApplication
	instanceVariableNames:'infoPanel vdbPrettyPrintingEnabled vdbFrameFiltersEnabled'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Others'
!

!VDBSettingsApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBSettingsApplication class methodsFor:'initialization'!

initialize

    self installInSettings

    "Created: / 23-06-2005 / 09:27:10 / masca"
!

installInSettings
    
    Smalltalk addStartBlock:[
        AbstractLauncherApplication 
            addSettingsApplicationByClass:self name withName:'Tools/Visual VM Debugger' icon:self defaultIcon
    ]

    "Created: / 23-06-2005 / 09:27:10 / masca"
    "Modified: / 10-04-2018 / 16:56:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBSettingsApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBSettingsApplication andSelector:#windowSpec
     VDBSettingsApplication new openInterface:#windowSpec
     VDBSettingsApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       uuid: '10c0dbf0-3cd7-11e8-882f-0021ccd5e3d3'
       window: 
      (WindowSpec
         label: 'Java Settings'
         name: 'Java Settings'
         uuid: '10c0dbf1-3cd7-11e8-882f-0021ccd5e3d3'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 695 627)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: ' Visual/VM Debugger Settings'
             name: 'SettingsTitle'
             layout: (LayoutFrame 0 0 0 0 0 1 66 0)
             style: (FontDescription helvetica medium roman 18 #'iso10646-1' nil nil)
             uuid: '10c0dbf2-3cd7-11e8-882f-0021ccd5e3d3'
             backgroundColor: (Color 100.0 100.0 100.0)
             translateLabel: true
             adjust: left
           )
          (LabelSpec
             label: 'Icon'
             name: 'Icon'
             layout: (LayoutFrame -75 1 0 0 0 1 66 0)
             uuid: '10c10300-3cd7-11e8-882f-0021ccd5e3d3'
             hasCharacterOrientedLabel: false
             backgroundColor: (Color 100.0 100.0 100.0)
             translateLabel: true
             labelChannel: libjavaCupIcon
           )
          (SubCanvasSpec
             name: 'InfoPanel'
             layout: (LayoutFrame 0 0 67 0 0 1 107 0)
             uuid: '10c10301-3cd7-11e8-882f-0021ccd5e3d3'
             level: 0
             initiallyInvisible: true
             hasHorizontalScrollBar: false
             hasVerticalScrollBar: false
             clientKey: infoPanel
             createNewBuilder: false
           )
          (VerticalPanelViewSpec
             name: 'Controls'
             layout: (LayoutFrame 0 0 70 0 0 1 0 1)
             uuid: '10c10302-3cd7-11e8-882f-0021ccd5e3d3'
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Enable Pretty Printers'
                   name: 'EnablePrettyPrinters'
                   uuid: '10c10303-3cd7-11e8-882f-0021ccd5e3d3'
                   model: vdbPrettyPrintingEnabled
                   translateLabel: true
                   extent: (Point 695 22)
                 )
                (CheckBoxSpec
                   label: 'Enable Frame Filters'
                   name: 'EnableFrameFilters'
                   uuid: '10c10304-3cd7-11e8-882f-0021ccd5e3d3'
                   model: vdbFrameFiltersEnabled
                   translateLabel: true
                   extent: (Point 695 22)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!VDBSettingsApplication methodsFor:'aspects'!

aspects
    ^ #(vdbPrettyPrintingEnabled vdbFrameFiltersEnabled)

    "Created: / 10-04-2018 / 16:53:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoPanel
    infoPanel isNil ifTrue:[
        infoPanel := Tools::InlineMessageDialog new.
    ].
    ^ infoPanel

    "Created: / 10-04-2018 / 16:52:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

vdbFrameFiltersEnabled
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    vdbFrameFiltersEnabled isNil ifTrue:[
        vdbFrameFiltersEnabled := false asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       vdbFrameFiltersEnabled addDependent:self.
       vdbFrameFiltersEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ vdbFrameFiltersEnabled.

    "Modified: / 10-04-2018 / 16:53:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

vdbPrettyPrintingEnabled
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    vdbPrettyPrintingEnabled isNil ifTrue:[
        vdbPrettyPrintingEnabled := false asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       vdbPrettyPrintingEnabled addDependent:self.
       vdbPrettyPrintingEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ vdbPrettyPrintingEnabled.

    "Modified: / 10-04-2018 / 16:53:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


VDBSettingsApplication initialize!
