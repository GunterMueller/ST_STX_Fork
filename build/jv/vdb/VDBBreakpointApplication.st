"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractApplication subclass:#VDBBreakpointApplication
	instanceVariableNames:'breakpointHolder enabledHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Others'
!

!VDBBreakpointApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBBreakpointApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBBreakpointApplication andSelector:#windowSpec
     VDBBreakpointApplication new openInterface:#windowSpec
     VDBBreakpointApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Breakpoint'
         name: 'Breakpoint'
         labelChannel: titleHolder
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'Controls'
             layout: (LayoutFrame 5 0 5 0 -5 1 -5 1)
             horizontalLayout: fit
             verticalLayout: topSpaceFit
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Condition'
                   name: 'ConditionLabel'
                   translateLabel: true
                   adjust: left
                   enableDisableColorChannel: enabledHolder
                   useDefaultExtent: true
                 )
                (ComboBoxSpec
                   name: 'Condition'
                   enableChannel: enabledHolder
                   model: breakpointConditionHolder
                   acceptOnPointerLeave: false
                   useDefaultExtent: true
                 )
                (LabelSpec
                   label: 'Script'
                   name: 'ScriptLabel'
                   translateLabel: true
                   adjust: left
                   enableDisableColorChannel: enabledHolder
                   useDefaultExtent: true
                 )
                (TextEditorSpec
                   name: 'TextEditor1'
                   enableChannel: enabledHolder
                   model: breakpointScriptHolder
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   hasKeyboardFocusInitially: false
                   extent: (Point 290 198)
                   useDynamicPreferredHeight: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!VDBBreakpointApplication class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #breakpointHolder
        #debuggerHolder
      ).

! !

!VDBBreakpointApplication methodsFor:'aspects'!

breakpointConditionHolder
    ^ (AspectAdaptor forAspect: #condition) subjectChannel: self breakpointHolder

    "Created: / 12-07-2017 / 11:06:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

breakpointHolder
    "return/create the 'breakpointHolder' value holder (automatically generated)"

    breakpointHolder isNil ifTrue:[
        breakpointHolder := ValueHolder new.
    ].
    ^ breakpointHolder
!

breakpointHolder:aValueModel
    "set the 'breakpointHolder' value holder (automatically generated)"

    breakpointHolder := aValueModel.
!

breakpointScriptHolder
    ^ (AspectAdaptor forAspect: #script) subjectChannel: self breakpointHolder

    "Created: / 12-07-2017 / 11:07:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enabledHolder
    "return/create the 'breakpointHolder' value holder (automatically generated)"

    enabledHolder isNil ifTrue:[
        enabledHolder := (AspectAdaptor forAspect: #notNil) subjectChannel: self breakpointHolder
    ].
    ^ enabledHolder

    "Created: / 14-07-2017 / 10:29:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBBreakpointApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

