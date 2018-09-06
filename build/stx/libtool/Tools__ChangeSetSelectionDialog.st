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

SimpleDialog subclass:#ChangeSetSelectionDialog
	instanceVariableNames:'enabledHolder specHolder specLabelList specLabelIndexHolder
		specEditorSpecHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Dialogs'
!

!ChangeSetSelectionDialog class methodsFor:'documentation'!

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

!ChangeSetSelectionDialog class methodsFor:'instance creation'!

requestChangeSet: title

    | dialog |
    dialog := self new.
    ^(dialog open) 
        ifTrue:[dialog specHolder value changeSet]
        ifFalse:[nil].

    "Created: / 06-07-2011 / 10:52:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSelectionDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetSelectionDialog andSelector:#windowSpec
     Tools::ChangeSetSelectionDialog new openInterface:#windowSpec
     Tools::ChangeSetSelectionDialog open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Select Changeset'
          name: 'Select Changeset'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 631 436)
        )
        component: 
       (SpecCollection
          collection: (
           (UISubSpecification
              name: 'Content'
              layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
              minorKey: windowSpecForEmbedding
            )
           (HorizontalPanelViewSpec
              name: 'ButtonPanel'
              layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 2
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button2'
                    translateLabel: true
                    model: doCancel
                    extent: (Point 311 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button1'
                    translateLabel: true
                    model: doAccept
                    enableChannel: doAcceptEnabledHolder
                    extent: (Point 311 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpecForEmbedding
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetSelectionDialog andSelector:#windowSpecForEmbedding
     Tools::ChangeSetSelectionDialog new openInterface:#windowSpecForEmbedding
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpecForEmbedding
        window: 
       (WindowSpec
          label: 'Select Changeset (embedding)'
          name: 'Select Changeset (embedding)'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 406 337)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Source:'
              name: 'SpecTypeLabel'
              layout: (LayoutFrame 3 0 3 0 100 0 25 0)
              translateLabel: true
              adjust: left
            )
           (PopUpListSpec
              label: 'Select...'
              name: 'SpecType'
              layout: (LayoutFrame 103 0 3 0 -3 1 25 0)
              tabable: true
              model: specLabelIndexHolder
              enableChannel: enabledHolder
              menu: specLabelList
              useIndex: true
            )
           (SubCanvasSpec
              name: 'SubCanvas1'
              layout: (LayoutFrame 3 0 30 0 -3 1 0 1)
              level: 0
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              specHolder: specEditorSpecHolder
              createNewBuilder: false
            )
           )
         
        )
      )
! !

!ChangeSetSelectionDialog class methodsFor:'interface specs - editors'!

editorSpecForDirectory
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetSelectionDialog andSelector:#editorSpecForDirectory
     Tools::ChangeSetSelectionDialog new openInterface:#editorSpecForDirectory
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: editorSpecForDirectory
        window: 
       (WindowSpec
          label: 'Directory Spec Editor'
          name: 'Directory Spec Editor'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 441 310)
        )
        component: 
       (SpecCollection
          collection: (
           (FilenameInputFieldSpec
              name: 'Directory'
              layout: (LayoutFrame 103 0 0 0 0 1 22 0)
              enableChannel: enabledHolder
              model: directoryAspect
              acceptOnPointerLeave: true
              viewClassName: FilenameWidgetWithHistory
            )
           (LabelSpec
              label: 'Directory:'
              name: 'Label1'
              layout: (LayoutFrame 0 0 3 0 100 0 22 0)
              translateLabel: true
              adjust: left
            )
           )
         
        )
      )
!

editorSpecForExplicit
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetSelectionDialog andSelector:#editorSpecForExplicit
     Tools::ChangeSetSelectionDialog new openInterface:#editorSpecForExplicit
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: 'editorSpecForExplicit'
        window: 
       (WindowSpec
          label: 'ChangeSet Spec Editor'
          name: 'ChangeSet Spec Editor'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 441 310)
        )
        component: 
       (SpecCollection
          collection: ()
        )
      )
!

editorSpecForFile
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetSelectionDialog andSelector:#editorSpecForFile
     Tools::ChangeSetSelectionDialog new openInterface:#editorSpecForFile
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: editorSpecForFile
        window: 
       (WindowSpec
          label: 'Directory Spec Editor'
          name: 'Directory Spec Editor'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 441 310)
        )
        component: 
       (SpecCollection
          collection: (
           (FilenameInputFieldSpec
              name: 'Directory'
              layout: (LayoutFrame 103 0 0 0 0 1 22 0)
              enableChannel: enabledHolder
              model: fileAspect
              acceptOnPointerLeave: true
              viewClassName: FilenameWidgetWithHistory
            )
           (LabelSpec
              label: 'File:'
              name: 'FileLabel'
              layout: (LayoutFrame 0 0 3 0 100 0 22 0)
              translateLabel: true
              adjust: left
            )
           )
         
        )
      )

    "Modified: / 20-03-2012 / 11:13:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editorSpecForPackage
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ChangeSetSelectionDialog andSelector:#editorSpecForPackage
     Tools::ChangeSetSelectionDialog new openInterface:#editorSpecForPackage
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: editorSpecForPackage
        window: 
       (WindowSpec
          label: 'Package Spec Editor'
          name: 'Package Spec Editor'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 441 310)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Package:'
              name: 'Label1'
              layout: (LayoutFrame 0 0 3 0 100 0 22 0)
              translateLabel: true
              adjust: left
            )
           (InputFieldSpec
              name: 'EntryField1'
              layout: (LayoutFrame 103 0 0 0 -25 1 25 0)
              enableChannel: enabledHolder
              model: packageAspect
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnPointerLeave: true
              entryCompletionBlock: packageCompletionBlock
            )
           (ActionButtonSpec
              label: '...'
              name: 'Button1'
              layout: (LayoutFrame -25 1 0 0 0 1 25 0)
              translateLabel: true
              model: selectPackage
              enableChannel: enabledHolder
            )
           )
         
        )
      )
! !

!ChangeSetSelectionDialog class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #enabledHolder
        #specHolder
      ).

! !

!ChangeSetSelectionDialog methodsFor:'actions'!

selectPackage
    <resource: #uiCallback>

    self packageAspect value: 
        (Dialog requestProject:'Select package' 
                initialAnswer:nil 
                suggestions:#())

    "Modified: / 06-07-2011 / 10:43:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSelectionDialog methodsFor:'aspects'!

doAcceptEnabledHolder

    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#doAcceptEnabledHolder) isNil ifTrue:[
        holder := (AspectAdaptor forAspect:#notNil)
                    subjectChannel: self specHolder.
        builder aspectAt:#doAcceptEnabledHolder put:holder.
    ].
    ^ holder.

    "Created: / 06-07-2011 / 10:48:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enabledHolder
    "return/create the 'enabledHolder' value holder (automatically generated)"

    enabledHolder isNil ifTrue:[
        enabledHolder := true asValue
    ].
    ^ enabledHolder

    "Modified: / 19-03-2012 / 23:25:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enabledHolder:something
    "set the 'enabledHolder' value holder (automatically generated)"

    enabledHolder := something.
!

specEditorSpecHolder
    "return/create the 'specEditorSpecHolder' value holder (automatically generated)"

    specEditorSpecHolder isNil ifTrue:[
        specEditorSpecHolder := ValueHolder new.
    ].
    ^ specEditorSpecHolder
!

specHolder
    "return/create the 'specHolder' value holder (automatically generated)"

    specHolder isNil ifTrue:[
        specHolder := ValueHolder new.
        specHolder addDependent:self.
    ].
    ^ specHolder
!

specHolder:something
    "set the 'specHolder' value holder (automatically generated)"

    |oldValue newValue|

    specHolder notNil ifTrue:[
        oldValue := specHolder value.
        specHolder removeDependent:self.
    ].
    specHolder := something.
    specHolder notNil ifTrue:[
        specHolder addDependent:self.
    ].
    newValue := specHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:specHolder.
    ].
!

specLabelIndexHolder
    "return/create the 'specLabelIndexHolder' value holder (automatically generated)"

    specLabelIndexHolder isNil ifTrue:[
        specLabelIndexHolder := ValueHolder new.
        specLabelIndexHolder addDependent:self.
    ].
    ^ specLabelIndexHolder
!

specLabelIndexHolder:something
    "set the 'specLabelIndexHolder' value holder (automatically generated)"

    |oldValue newValue|

    specLabelIndexHolder notNil ifTrue:[
        oldValue := specLabelIndexHolder value.
        specLabelIndexHolder removeDependent:self.
    ].
    specLabelIndexHolder := something.
    specLabelIndexHolder notNil ifTrue:[
        specLabelIndexHolder addDependent:self.
    ].
    newValue := specLabelIndexHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:specLabelIndexHolder.
    ].
!

specLabelList
    <resource: #uiAspect>

    specLabelList isNil ifTrue:[
        specLabelList := List withAll:
            (ChangeSetSpec specClasses collect:[:cls|cls label])
            
    ].
    ^ specLabelList.

    "Modified: / 05-07-2011 / 23:35:19 / jv"
    "Created: / 06-07-2011 / 09:49:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSelectionDialog methodsFor:'aspects - spec'!

directoryAspect
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#directoryAspect) isNil ifTrue:[
        holder := (AspectAdaptor forAspect:#directory)
                    subjectChannel: self specHolder.
        builder aspectAt:#directoryAspect put:holder.
    ].
    ^ holder.

    "Modified: / 06-07-2011 / 10:28:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileAspect
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#fileAspect) isNil ifTrue:[
        holder := (AspectAdaptor forAspect:#file)
                    subjectChannel: self specHolder.
        builder aspectAt:#fileAspect put:holder.
    ].
    ^ holder.

    "Modified: / 06-07-2011 / 10:28:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 19-03-2012 / 22:07:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageAspect
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#packageAspect) isNil ifTrue:[
        holder := (AspectAdaptor forAspect:#package)
                    subjectChannel: self specHolder.
        builder aspectAt:#packageAspect put:holder.
    ].
    ^ holder.

    "Created: / 06-07-2011 / 10:28:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageCompletionBlock

    ^DoWhatIMeanSupport packageNameEntryCompletionBlock

    "Created: / 06-07-2011 / 10:45:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSelectionDialog methodsFor:'change & update'!

update:something with:aParameter from:changedObject 
    changedObject == specLabelIndexHolder 
        ifTrue:
            [ self updateSpec.
            ^ self. ].
    changedObject == specHolder 
        ifTrue:
            [ self updateSpecEditor.
            ^ self. ].
    super 
        update:something
        with:aParameter
        from:changedObject

    "Modified: / 05-07-2011 / 23:53:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSpec
    |changeSetSpecClass changeSetSpec|

    changeSetSpecClass := ChangeSetSpec specClasses 
                at:specLabelIndexHolder value.
    changeSetSpec := changeSetSpecClass new.
    self specHolder value:changeSetSpec.

    "Created: / 05-07-2011 / 23:51:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSpecEditor

    | spec |
    spec := self specHolder value.
    spec ifNil:[
        self specEditorSpecHolder value: nil
    ] ifNotNil:[
        self specEditorSpecHolder value: spec editorSpecSelector    
    ]

    "Created: / 05-07-2011 / 23:53:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetSelectionDialog class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__ChangeSetSelectionDialog.st,v 1.3 2014-02-05 18:56:05 cg Exp $'
! !

