"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

AbstractSettingsApplication subclass:#CodeView2SettingsAppl
	instanceVariableNames:'useCodeView2InTools useCodeView2InDebugger useCodeView2InBrowser
		useCodeView2InToolEnabled useCodeView2InWorkspace
		codeView2AutoPrettyPrint codeView2ShowAcceptCancel
		codeView2QuickSendersAndImplementorsOnControl
		showAcceptCancelBarInBrowser'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

!CodeView2SettingsAppl class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!CodeView2SettingsAppl class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::CodeView2SettingsAppl    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#showAcceptCancelBarInGutter
'Show the Gutterview''s own Accept/Cancel Bar (disabled if outer Accept/Cancel bar is enabled)'

#useCodeView2InBrowser
'Use the new editor in SystemBrowsers (disabled if the global use of CodeEditor2 is disabled in the tools settings)'

#useCodeView2InWorkspace
'Use the new editor in Workspaces (disabled if the global use of Code Editor2 is disabled in the tools settings)'

#useCodeView2InDebugger
'Use the new editor in the Debugger (disabled if the global use of Code Editor2 is disabled in the tools settings)'

#codeView2QuickSendersAndImplementorsOnControl
'If on, the CTRL (Control) key is used to get the quick implementors/senders menus via left/right mouse click.\If off, the ALT key is used.\Check this, if your window manager eats ALT-key events for breakfast.'

#codeView2AutoPrettyPrint
'Automatically indent (prettyprint) code. This is experimental and not yet enabled by default, 
as it uses the refactory browser''s prettyprint function, which is known to loose comments and generate
ugly layout occasionally. For now, it is recommended to manually prettyprint code (using the format button),
and check if it looks good enough to be accepted.'

)
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::CodeView2SettingsAppl    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#showAcceptCancelBarInGutter
'When selected, use CodeView''s internal Accept/Cancel bar shown in gutter.'

)
! !

!CodeView2SettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'Tools::CodeView2SettingsAppl class defaultIcon'
        ifAbsentPut:[
            (Depth4Image new)
                width:22;
                height:22;
                photometric:(#palette);
                bitsPerSample:(#[ 4 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
*****************+.************(.8"H"H"H"J(@**";UUU%UUUU@@^+.;.;-VUUUU@@]:.;.;.5YUUUT@A7**";Y&Y&Y&X@]7^**K-UUVUU@@]7\Z*(
.5UUYU@@]7\R**"EUUU%T@A7]1J**HY&Y&XC]7\Q&**(!!UUU(3M7\Y&***"EUUU#L3L2QJ***HY&Z#L3L6)D***(!!&Y*L3L6Z$R***"EUUP3M&ZEQJ***HUU
RRY(UUUD***("*)J*****$R***"J)J******QJ***HUUUZUUUUUD***TQDQDQDQDQDR***************(b');
                colorMapFromArray:#[ 240 160 80 192 80 0 64 0 0 240 208 160 0 0 0 240 240 240 192 192 192 240 128 0 208 208 208 48 48 48 160 160 160 255 0 0 ];
                mask:((ImageMask new)
                            width:22;
                            height:22;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@C@@@G??LG??<_??<_??<G??<G??<G??<G??<G??8G??0G??0G??0G??0G??0G??0G??0G??0G??0O??0@@@@');
                            yourself);
                yourself
        ]
! !

!CodeView2SettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::CodeView2SettingsAppl andSelector:#windowSpec
     Tools::CodeView2SettingsAppl new openInterface:#windowSpec
     Tools::CodeView2SettingsAppl open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Code Editor Settings'
         name: 'Code Editor Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 589 346)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'VBox'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (FramedBoxSpec
                   label: 'Individual Tool Support'
                   name: 'ToolSupport'
                   visibilityChannel: false
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'ToolSupportCheckBox'
                         layout: (LayoutFrame 0 0 0 0 0 1 96 0)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Use Advanced Code Editor in Class Browser'
                               name: 'CheckBox2'
                               activeHelpKey: useCodeView2InBrowser
                               enableChannel: useCodeView2InToolEnabled
                               model: useCodeView2InBrowser
                               translateLabel: true
                               extent: (Point 543 30)
                             )
                            (CheckBoxSpec
                               label: 'Use Advanced Code Editor in Debugger (experimental)'
                               name: 'CheckBox3'
                               activeHelpKey: useCodeView2InDebugger
                               enableChannel: useCodeView2InToolEnabled
                               model: useCodeView2InDebugger
                               translateLabel: true
                               extent: (Point 543 30)
                             )
                            (CheckBoxSpec
                               label: 'Use Advanced Code Editor in Workspace'
                               name: 'CheckBox4'
                               activeHelpKey: useCodeView2InWorkspace
                               enableChannel: useCodeView2InToolEnabled
                               model: useCodeView2InWorkspace
                               translateLabel: true
                               extent: (Point 543 30)
                             )
                            )
                          
                         )
                         useDynamicPreferredHeight: true
                         usePreferredHeight: true
                       )
                      )
                    
                   )
                   extent: (Point 589 130)
                 )
                (FramedBoxSpec
                   label: 'Edit Support'
                   name: 'EditSupport'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel1'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Show Accept/Cancel Bar in Editor'
                               name: 'ShowAcceptCancelBarInBrowser'
                               activeHelpKey: showAcceptCancelBar
                               model: showAcceptCancelBarInBrowser
                               translateLabel: true
                               extent: (Point 543 30)
                             )
                            (ViewSpec
                               name: 'Box1'
                               component: 
                              (SpecCollection
                                 collection: (
                                  (CheckBoxSpec
                                     label: 'Use Internal Accept/Cancel Bar Shown in Editor''s Gutter'
                                     name: 'CheckBox6'
                                     layout: (LayoutFrame 25 0 0 0 0 1 0 1)
                                     activeHelpKey: showAcceptCancelBarInGutter
                                     enableChannel: showAcceptCancelBarInBrowser
                                     model: codeView2ShowAcceptCancel
                                     translateLabel: true
                                   )
                                  )
                                
                               )
                               extent: (Point 543 30)
                             )
                            (CheckBoxSpec
                               label: 'Auto Pretty Print (experimental, not yet recommended)'
                               name: 'CheckBox5'
                               activeHelpKey: codeView2AutoPrettyPrint
                               visibilityChannel: false
                               enableChannel: false
                               model: codeView2AutoPrettyPrint
                               translateLabel: true
                               extent: (Point 543 30)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 589 136)
                 )
                (FramedBoxSpec
                   label: 'Keyboard Shortcuts'
                   name: 'FramedBox1'
                   labelPosition: topLeft
                   translateLabel: true
                   component: 
                  (SpecCollection
                     collection: (
                      (VerticalPanelViewSpec
                         name: 'VerticalPanel2'
                         layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                         horizontalLayout: fit
                         verticalLayout: top
                         horizontalSpace: 3
                         verticalSpace: 3
                         component: 
                        (SpecCollection
                           collection: (
                            (CheckBoxSpec
                               label: 'Quick Senders/Implementors Menu with CTRL key (as opposed to ALT key)'
                               name: 'CheckBox7'
                               activeHelpKey: codeView2QuickSendersAndImplementorsOnControl
                               model: codeView2QuickSendersAndImplementorsOnControl
                               translateLabel: true
                               extent: (Point 543 30)
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                   extent: (Point 589 76)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!CodeView2SettingsAppl methodsFor:'aspects'!

acceptCancelInGutterEnabledHolder
    ^ [UserPreferences current showAcceptCancelBar not] 
!

codeView2AutoPrettyPrint

    codeView2AutoPrettyPrint isNil ifTrue:[
        codeView2AutoPrettyPrint := ValueHolder new.
        codeView2AutoPrettyPrint onChangeSend:#updateModifiedChannel to:self
    ].
    ^ codeView2AutoPrettyPrint

    "Modified: / 11-03-2010 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 07-08-2011 / 12:52:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeView2QuickSendersAndImplementorsOnControl
    codeView2QuickSendersAndImplementorsOnControl isNil ifTrue:[
        codeView2QuickSendersAndImplementorsOnControl := ValueHolder new.
        codeView2QuickSendersAndImplementorsOnControl onChangeSend:#updateModifiedChannel to:self
    ].
    ^ codeView2QuickSendersAndImplementorsOnControl

    "Modified: / 11-03-2010 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeView2ShowAcceptCancel
    "this is a little confusing: the codeview2 has its own accept/cancel bar
     (why reinvent the wheel?).
     So if this is enabled, the outer accept/cancel bar will be suppressed,
     if this is on"

    codeView2ShowAcceptCancel isNil ifTrue:[
        codeView2ShowAcceptCancel := ValueHolder new.
        codeView2ShowAcceptCancel onChangeSend:#updateModifiedChannel to:self
    ].
    ^ codeView2ShowAcceptCancel

    "Modified: / 10-10-2011 / 16:43:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showAcceptCancelBarInBrowser
    "this is a little confusing: the codeview2 has its own accept/cancel bar
     (why reinvent the wheel?).
     So if this is enabled, the outer accept/cancel bar will be suppressed,
     if this is on"

    showAcceptCancelBarInBrowser isNil ifTrue:[
        showAcceptCancelBarInBrowser := false asValue.
        showAcceptCancelBarInBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ showAcceptCancelBarInBrowser.

    "Created: / 06-12-2013 / 17:39:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useCodeView2InBrowser

    useCodeView2InBrowser isNil ifTrue:[
        useCodeView2InBrowser := ValueHolder new.
        useCodeView2InBrowser onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useCodeView2InBrowser

    "Modified: / 11-03-2010 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-07-2011 / 10:30:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useCodeView2InDebugger

    useCodeView2InDebugger isNil ifTrue:[
        useCodeView2InDebugger := ValueHolder new.
        useCodeView2InDebugger onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useCodeView2InDebugger

    "Modified: / 11-03-2010 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-07-2011 / 10:30:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useCodeView2InTools

    useCodeView2InTools isNil ifTrue:[
        useCodeView2InTools := ValueHolder new.
        useCodeView2InTools onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useCodeView2InTools

    "Modified: / 11-03-2010 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useCodeView2InWorkspace

    useCodeView2InWorkspace isNil ifTrue:[
        useCodeView2InWorkspace := ValueHolder new.
        useCodeView2InWorkspace onChangeSend:#updateModifiedChannel to:self
    ].
    ^ useCodeView2InWorkspace

    "Modified: / 11-03-2010 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-07-2011 / 10:31:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2SettingsAppl methodsFor:'aspects-enablement'!

useCodeView2InToolEnabled
    "return/create the 'useCodeView2InTools' value holder (automatically generated)"

    useCodeView2InToolEnabled isNil ifTrue:[
        useCodeView2InToolEnabled := UserPreferences current useCodeView2InTools asValue.
"/            (AspectAdaptor forAspect: #not) 
"/                subjectChannel: self useCodeView2InTools
    ].
    ^ useCodeView2InToolEnabled

    "Modified: / 11-03-2010 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-07-2011 / 10:39:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-11-2011 / 15:11:55 / cg"
! !

!CodeView2SettingsAppl methodsFor:'protocol'!

basicAspects
    ^#( 
        "/#useCodeView2InTools 
        #useCodeView2InBrowser
        #useCodeView2InDebugger
        #useCodeView2InWorkspace
        "/Editing support
        #codeView2AutoPrettyPrint
        #showAcceptCancelBarInBrowser
        #codeView2ShowAcceptCancel
        #codeView2QuickSendersAndImplementorsOnControl
    )

    "Modified: / 06-12-2013 / 17:39:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicReadSettings
    self readAspects:self basicAspects from:currentUserPrefs.

    "Modified: / 19-07-2011 / 17:11:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicSaveSettings

    self writeAspects:self basicAspects to:currentUserPrefs.

    "Modified: / 26-07-2011 / 10:43:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

helpFilename
    "subclasses must return the relative name of a helpFile
     in the doc/online/<language>/help directory.
     Or nil, if no help is available."

    ^ nil"for now"

    "Modified: / 19-07-2011 / 16:55:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2SettingsAppl methodsFor:'queries'!

hasUnsavedChanges
    ^ self
        hasChangedAspectIn: self basicAspects
        asComparedTo:currentUserPrefs

    "Modified: / 19-07-2011 / 17:12:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-11-2011 / 15:25:16 / cg"
! !

!CodeView2SettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

