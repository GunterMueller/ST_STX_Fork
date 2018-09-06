"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

AbstractSettingsApplication subclass:#SettingsAppl
	instanceVariableNames:'smallSenseEnabled smallSenseEnabledAndMethodsSwizzledHolder
		smallSenseBackgroundTypingEnabled smallSenseBackgroundLintEnabled
		smallSenseElectricEditSupportEnabled
		smallSenseCompleteIfUnambiguous smallSenseCompletionEnabled
		smallSenseSwizzledInfoHolder smallSenseNewDialogsEnabled'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface'
!

!SettingsAppl class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!SettingsAppl class methodsFor:'class initialization'!

initialize

    NewLauncher
        addSettingsApplicationByClass: self name
        withName: 'Tools/SmallSense'
        icon: nil.

    "Created: / 04-02-2012 / 21:50:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2014 / 14:23:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SettingsAppl class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:SmallSense::SettingsAppl
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#smallSenseBackgroundLintEnabled
'When enabled, a hint on code are shown next to the line number,\based on a static code analysis (SmallLint).\See the SmallLint settings for which rules are to be applied'

#smallSenseBackgroundTypingEnabled
'When enabled, SmallSense runs a type-inferencer on the code to give more accurate type hints and completion data'

#smallSenseCompleteIfUnambiguous
'Enable automatic completion if unambigious.\Will automatically insert the completion, if there only one possible completion is found.\This may be somewhat disturbing, as it makes blind typing a little tricky.'

#smallSenseCompletionEnabled
'Enable the SmallSense completion algorithm, instead of the default one.\It is currently a matter of personal taste, which one provides better completions'

#smallSenseElectricEditSupportEnabled
'When enabled, closing brackets, blank lines and spaces are automatically inserted,\as soon as opening bracket or other tokens are typed. Honours formatting settings.'

#smallSenseEnabled
'General enable/disable the SmallSense support package'

#smallSenseNewDialogsEnabled
'EXPERIMENTAL. When enabled, use SmallSense''s own dialogs for classes, methods, packages, ...\Requires swizzling.'

)
! !

!SettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::SettingsAppl andSelector:#windowSpec
     SmallSense::SettingsAppl new openInterface:#windowSpec
     SmallSense::SettingsAppl open
    "

    <resource: #canvas>

    ^
    #(FullSpec
       name: windowSpec
       window:
      (WindowSpec
         label: 'SmallSense Settings'
         name: 'SmallSense Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 536 651)
       )
       component:
      (SpecCollection
         collection: (
          (CheckBoxSpec
             label: 'Enable SmallSense '
             name: 'Enable'
             layout: (LayoutFrame 0 0 0 0 0 1 30 0)
             activeHelpKey: smallSenseEnabled
             model: smallSenseEnabled
             translateLabel: true
           )
          (LabelSpec
             label: 'Methods not swizzled, some features may not be available'
             name: 'SwizzlingInfo'
             layout: (LayoutFrame 23 0 30 0 0 1 55 0)
             visibilityChannel: hasMethodsToSwizzle
             translateLabel: true
             labelChannel: smallSenseSwizzledInfoHolder
             adjust: left
           )
          (LinkButtonSpec
             label: 'What''s this?'
             name: 'Button1'
             layout: (LayoutFrame -100 1 30 0 0 1 55 0)
             visibilityChannel: hasMethodsToSwizzle
             foregroundColor: (Color 0.0 0.0 100.0)
             translateLabel: true
             model: smallSenseSwizzlingDocumentationOpen
           )
          (DividerSpec
             name: 'Separator'
             layout: (LayoutFrame 5 0 56 0 -5 1 60 0)
           )
          (VerticalPanelViewSpec
             name: 'Panel'
             layout: (LayoutFrame 5 0 61 0 -5 1 26 1)
             horizontalLayout: fit
             verticalLayout: top
             horizontalSpace: 3
             verticalSpace: 3
             component:
            (SpecCollection
               collection: (
                (ViewSpec
                   name: 'Spacer1'
                   extent: (Point 526 15)
                 )
                (LabelSpec
                   label: 'Code Editor'
                   name: 'Label1'
                   translateLabel: true
                   adjust: left
                   extent: (Point 526 22)
                 )
                (CheckBoxSpec
                   label: 'Enable Code Analysis (Lint)'
                   name: 'LintEnabled'
                   activeHelpKey: smallSenseBackgroundLintEnabled
                   enableChannel: smallSenseEnabled
                   model: smallSenseBackgroundLintEnabled
                   translateLabel: true
                   extent: (Point 526 22)
                 )
                (CheckBoxSpec
                   label: 'Enable Background Type Inferencer'
                   name: 'CheckBox2'
                   activeHelpKey: smallSenseBackgroundTypingEnabled
                   enableChannel: smallSenseEnabledAndMethodsSwizzledHolder
                   model: smallSenseBackgroundTypingEnabled
                   translateLabel: true
                   extent: (Point 526 22)
                 )
                (CheckBoxSpec
                   label: 'Enable "Electric Edit" Support'
                   name: 'CheckBox3'
                   activeHelpKey: smallSenseElectricEditSupportEnabled
                   enableChannel: smallSenseEnabled
                   model: smallSenseElectricEditSupportEnabled
                   translateLabel: true
                   extent: (Point 526 22)
                 )
                (CheckBoxSpec
                   label: 'Enable Code Completion (using SmallSense Completion Engine)'
                   name: 'CheckBox4'
                   activeHelpKey: smallSenseCompletionEnabled
                   enableChannel: smallSenseEnabled
                   model: smallSenseCompletionEnabled
                   translateLabel: true
                   extent: (Point 526 22)
                 )
                (CheckBoxSpec
                   label: 'Auto-complete when Completion is Unambiguous'
                   name: 'CheckBox5'
                   activeHelpKey: smallSenseCompleteIfUnambiguous
                   enableChannel: smallSenseEnabledAndCompletionEnabled
                   model: smallSenseCompleteIfUnambiguous
                   translateLabel: true
                   extent: (Point 526 22)
                 )
                (ViewSpec
                   name: 'Spacer2'
                   extent: (Point 526 15)
                 )
                (LabelSpec
                   label: 'Dialogs'
                   name: 'Label2'
                   translateLabel: true
                   adjust: left
                   extent: (Point 526 22)
                 )
                (CheckBoxSpec
                   label: 'Enable New Dialogs (EXPERIMENTAL)'
                   name: 'CheckBox6'
                   activeHelpKey: smallSenseNewDialogsEnabled
                   enableChannel: smallSenseEnabledAndMethodsSwizzledHolder
                   model: smallSenseNewDialogsEnabled
                   translateLabel: true
                   extent: (Point 526 28)
                 )
                )

             )
           )
          )

       )
     )

! !

!SettingsAppl methodsFor:'actions'!

smallSenseSwizzlingDocumentationOpen
    <resource: #uiCallback>

   OperatingSystem openApplicationForDocument: 'https://bitbucket.org/janvrany/stx-goodies-smallsense/wiki/Swizzling.md'  operation: #open

    "Modified: / 13-01-2015 / 09:28:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SettingsAppl methodsFor:'aspects'!

smallSenseBackgroundLintEnabled


    smallSenseBackgroundLintEnabled isNil ifTrue:[
        smallSenseBackgroundLintEnabled := true asValue.
        smallSenseBackgroundLintEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallSenseBackgroundLintEnabled.

    "Modified: / 04-02-2012 / 21:47:56 / Jan Vrany "
!

smallSenseBackgroundTypingEnabled


    smallSenseBackgroundTypingEnabled isNil ifTrue:[
        smallSenseBackgroundTypingEnabled := true asValue.
        smallSenseBackgroundTypingEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallSenseBackgroundTypingEnabled.

    "Modified: / 04-02-2012 / 21:48:02 / Jan Vrany "
!

smallSenseCompleteIfUnambiguous


    smallSenseCompleteIfUnambiguous isNil ifTrue:[
        smallSenseCompleteIfUnambiguous := true asValue.
        smallSenseCompleteIfUnambiguous onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallSenseCompleteIfUnambiguous.

    "Created: / 18-01-2014 / 23:36:58 / Jan Vrany "
!

smallSenseCompletionEnabled


    smallSenseCompletionEnabled isNil ifTrue:[
        smallSenseCompletionEnabled := true asValue.
        smallSenseCompletionEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallSenseCompletionEnabled.

    "Modified: / 27-02-2014 / 09:33:53 / Jan Vrany "
!

smallSenseElectricEditSupportEnabled


    smallSenseElectricEditSupportEnabled isNil ifTrue:[
        smallSenseElectricEditSupportEnabled := true asValue.
        smallSenseElectricEditSupportEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallSenseElectricEditSupportEnabled.

    "Modified: / 26-07-2013 / 12:36:25 / Jan Vrany "
!

smallSenseEnabled


    smallSenseEnabled isNil ifTrue:[
        smallSenseEnabled := true asValue.
        smallSenseEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallSenseEnabled.

    "Modified: / 04-02-2012 / 21:48:11 / Jan Vrany "
!

smallSenseEnabledAndCompletionEnabled
    ^ BlockValue forLogical: self smallSenseEnabled and: self smallSenseCompletionEnabled

    "Created: / 27-02-2014 / 09:41:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

smallSenseEnabledAndMethodsSwizzledHolder
    smallSenseEnabledAndMethodsSwizzledHolder isNil ifTrue:[
        smallSenseEnabledAndMethodsSwizzledHolder :=
            PluggableAdaptor on: self smallSenseEnabled getter:[ :model | model value and:[ self smallSenseSwizzled ] ]
    ].
    ^ smallSenseEnabledAndMethodsSwizzledHolder.

    "Created: / 13-01-2015 / 09:44:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

smallSenseNewDialogsEnabled
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    smallSenseNewDialogsEnabled isNil ifTrue:[
        smallSenseNewDialogsEnabled := true asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       smallSenseNewDialogsEnabled addDependent:self.
"/       smallSenseNewDialogsEnabled onChangeSend:#smallSenseNewDialogsEnabledChanged to:self.
        smallSenseNewDialogsEnabled onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ smallSenseNewDialogsEnabled.

    "Modified: / 10-05-2014 / 11:56:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

smallSenseSwizzled
    ^ (Smalltalk at: #stx_goodies_smallsense) swizzled

    "Created: / 12-01-2015 / 07:25:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

smallSenseSwizzledInfoHolder
    smallSenseSwizzledInfoHolder isNil ifTrue:[
        smallSenseSwizzledInfoHolder := ValueHolder new.
        (Smalltalk at: #stx_goodies_smallsense) swizzled ifTrue:[
            smallSenseSwizzledInfoHolder value:
                ((resources string: 'Methods swizzled.') asText allBold colorizeAllWith: Color green darker).
        ] ifFalse:[
            smallSenseSwizzledInfoHolder value:
                (resources string: 'Methods not swizzled, some features may not be available.')
        ].
    ].
    ^ smallSenseSwizzledInfoHolder

    "Created: / 12-01-2015 / 07:20:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SettingsAppl methodsFor:'protocol'!

basicAspects
    ^#(
       smallSenseEnabled

       smallSenseBackgroundLintEnabled
       smallSenseBackgroundTypingEnabled
       smallSenseElectricEditSupportEnabled

       smallSenseCompletionEnabled
       smallSenseCompleteIfUnambiguous

       smallSenseNewDialogsEnabled
    )

    "Modified: / 10-05-2014 / 00:04:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

    ^ self shouldImplement
! !

!SettingsAppl methodsFor:'queries'!

hasMethodsToSwizzle
    "Return true, if this SmallSense version has anything to swizzle"

    ^ (Smalltalk at: #stx_goodies_smallsense) extensionMethods
        anySatisfy: [ :m | (m annotationAt: #swizzle:) notNil or:[(m annotationAt: #swizzle:checksum:) notNil ] ]

    "
    SmallSense::SettingsAppl basicNew hasMethodsToSwizzle

    (Smalltalk at: #stx_goodies_smallsense) extensionMethods
        select: [ :m | (m annotationAt: #swizzle:) notNil or:[(m annotationAt: #swizzle:checksum:) notNil ] ]

    "

    "Created: / 13-01-2015 / 09:33:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasUnsavedChanges
    ^ self
        hasChangedAspectIn: self basicAspects
        asComparedTo:currentUserPrefs

    "Modified: / 19-07-2011 / 17:12:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-11-2011 / 15:25:16 / cg"
! !

!SettingsAppl class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


SettingsAppl initialize!
