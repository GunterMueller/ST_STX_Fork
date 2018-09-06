"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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
"{ Package: 'stx:libscm/common' }"

"{ NameSpace: Smalltalk }"

SimpleDialog subclass:#SCMAbstractDialog
	instanceVariableNames:'onCancelBlock onAcceptBlock titleHolder subtitleHolder infoPanel'
	classVariableNames:'CatchExceptions'
	poolDictionaries:''
	category:'SCM-Common-StX-Interface'
!

!SCMAbstractDialog class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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

!SCMAbstractDialog class methodsFor:'instance creation'!

on: model

    ^self new 
        model: model;
        yourself

    "Created: / 14-04-2008 / 11:09:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SCMAbstractDialog class methodsFor:'accessing'!

catchExceptions

    ^CatchExceptions isNil or:[CatchExceptions]

    "Created: / 09-12-2009 / 16:22:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

catchExceptions: aBoolean

    CatchExceptions := aBoolean

    "Created: / 09-12-2009 / 16:22:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractDialog class methodsFor:'image specs'!

dialogIcon
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

downArrow
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self downArrow inspect
     ImageEditor openOnClass:self andSelector:#downArrow
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::Dialog class downArrow'
        ifAbsentPut:[(Depth1Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@C?@O<@_ @<@A @@@@@@@@@@@@@@b') ; yourself); yourself]
!

errorIcon
    ^ ToolbarIconLibrary error32x32Icon

    "Created: / 09-12-2009 / 16:38:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractDialog class methodsFor:'interface opening'!

openOn: model


    ^(self on: model) open

    "Created: / 14-04-2008 / 11:09:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-04-2008 / 13:17:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SCMAbstractDialog class methodsFor:'interface specs'!

buttonsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SCMAbstractDialog andSelector:#buttonsSpec
     SCMAbstractDialog new openInterface:#buttonsSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: buttonsSpec
       window: 
      (WindowSpec
         label: 'Buttons'
         name: 'Buttons'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 400 30)
       )
       component: 
      (SpecCollection
         collection: (
          (HorizontalPanelViewSpec
             name: 'ButtonPanel'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: okCancelBox
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 3
             reverseOrderIfOKAtLeft: true
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'CancelButton'
                   translateLabel: true
                   model: doCancel
                   extent: (Point 195 22)
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'AcceptButton'
                   translateLabel: true
                   labelChannel: acceptButtonTitleAspect
                   model: doAccept
                   enableChannel: acceptEnabledHolder
                   extent: (Point 196 22)
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::Dialog andSelector:#contentSpec
     SVN::Dialog new openInterface:#contentSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: contentSpec
        window: 
       (WindowSpec
          label: 'Dialog'
          name: 'Dialog'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'You should override #contentSpec'
              name: 'Message'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              translateLabel: true
            )
           )
         
        )
      )
!

errorSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::Dialog andSelector:#errorSpec
     SVN::Dialog new openInterface:#errorSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: errorSpec
        window: 
       (WindowSpec
          label: 'Error'
          name: 'Error'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'errorIcon'
              name: 'ErrorIcon'
              layout: (LayoutFrame 0 0 0 0 35 0 35 0)
              hasCharacterOrientedLabel: false
              translateLabel: true
            )
           (LabelSpec
              name: 'ErrorMessage'
              layout: (LayoutFrame 35 0 0 0 0 1 0 1)
              translateLabel: true
              labelChannel: infoHolder
            )
           )
         
        )
      )
!

messageSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::Dialog andSelector:#messageSpec
     SVN::Dialog new openInterface:#messageSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: messageSpec
        window: 
       (WindowSpec
          label: 'Message'
          name: 'Message'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (HTMLViewSpec
              name: 'HTMLBrowser'
              layout: (LayoutFrame 20 0 20 0 -20 1 -20 1)
              level: 0
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              htmlText: infoHolder
            )
           )
         
        )
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SCMAbstractDialog andSelector:#windowSpec
     SCMAbstractDialog new openInterface:#windowSpec
     SCMAbstractDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'SubVersion: Dialog '
         name: 'SubVersion: Dialog '
         labelChannel: titleHolder
         min: (Point 10 10)
         bounds: (Rectangle 0 0 648 451)
       )
       component: 
      (SpecCollection
         collection: (
          (ViewSpec
             name: 'TitleBox'
             layout: (LayoutFrame 0 0 0 0 0 1 66 0)
             backgroundColor: (Color 100.0 100.0 100.0)
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'DialogTitle'
                   name: 'DialogTitle'
                   layout: (LayoutFrame 10 0 0 0 -75 1 40 0)
                   style: (FontDescription helvetica medium roman 18 #'iso10646-1')
                   backgroundColor: (Color 100.0 100.0 100.0)
                   translateLabel: true
                   labelChannel: titleHolder
                   adjust: left
                 )
                (LabelSpec
                   label: 'DialogSubtitle'
                   name: 'DialogSubtitle'
                   layout: (LayoutFrame 30 0 40 0 -75 1 66 0)
                   backgroundColor: (Color 100.0 100.0 100.0)
                   translateLabel: true
                   labelChannel: subtitleHolder
                   resizeForLabel: false
                   adjust: left
                 )
                (LabelSpec
                   label: 'Icon'
                   name: 'DialogIcon'
                   layout: (LayoutFrame -157 1 0 0 0 1 66 0)
                   hasCharacterOrientedLabel: false
                   backgroundColor: (Color 100.0 100.0 100.0)
                   translateLabel: true
                   labelChannel: dialogIconAspect
                 )
                )
              
             )
           )
          (ViewSpec
             name: 'ContentBox'
             layout: (LayoutFrame 5 0 70 0 -5 1 -50 1)
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'InfoPanel'
                   layout: (LayoutFrame 0 0 0 0 0 1 40 0)
                   level: 0
                   initiallyInvisible: true
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   clientKey: infoPanel
                   createNewBuilder: false
                 )
                (SubCanvasSpec
                   name: 'Content'
                   layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   specHolder: contentSpecHolder
                   createNewBuilder: false
                 )
                )
              
             )
           )
          (DividerSpec
             name: 'Separator'
             layout: (LayoutFrame 5 0 -50 1 -5 1 -30 1)
           )
          (UISubSpecification
             name: 'Buttons'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             minorKey: buttonsSpec
           )
          )
        
       )
     )
! !

!SCMAbstractDialog class methodsFor:'menu specs'!

actionsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SVN::Dialog andSelector:#actionsMenu
     (Menu new fromLiteralArrayEncoding:(SVN::Dialog actionsMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'ActionsMenu'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Catch exceptions'
                  translateLabel: true
                  indication: catchExceptionsAspect
                )
               (MenuItem
                  label: 'Inspect model'
                  itemValue: doInspect
                  translateLabel: true
                )
               (MenuItem
                  label: 'Inspect dialog'
                  itemValue: doInspectDialog
                  translateLabel: true
                )
               )
              nil
              nil
            )
            labelImage: (ResourceRetriever #'SVN::Dialog' downArrow)
          )
         )
        nil
        nil
      )
! !

!SCMAbstractDialog methodsFor:'accessing'!

acceptButtonLabel
    ^ 'OK'

    "Created: / 13-04-2008 / 11:06:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

acceptEnabled
    ^ self acceptEnabledHolder value

    "Created: / 16-08-2009 / 17:18:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

acceptEnabled:aBoolean 
    self acceptEnabledHolder value:aBoolean

    "Created: / 03-10-2008 / 14:29:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

contentSpec

    ^self contentSpecHolder value

    "Created: / 21-10-2008 / 12:39:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

contentSpec: aSymbol

    self contentSpecHolder value: aSymbol

    "Created: / 21-10-2008 / 12:38:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

infoPanel
    infoPanel isNil ifTrue:[
        infoPanel := Tools::InlineMessageDialog new
    ].
    ^ infoPanel

    "Created: / 09-02-2012 / 19:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

model
    <resource: #obsolete>

    ^self subclassResponsibility

    "Created: / 12-01-2013 / 11:58:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subtitle
    "return the value in 'dialogSubtitleHolder'"
    
    ^ self subtitleHolder value

    "Created: / 22-10-2008 / 12:40:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 07:53:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

subtitle:newValue 
    "set the value in 'dialogSubtitleHolder'"
    
    self subtitleHolder value:'     ' , newValue

    "Created: / 22-10-2008 / 12:40:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 07:53:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

title

    ^self dialogTitleAspect value

    "Created: / 22-10-2008 / 12:40:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

title: aString

    ^self titleHolder value: aString

    "Created: / 22-10-2008 / 12:40:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 14:12:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SCMAbstractDialog methodsFor:'accessing - defaults'!

defaultContentSpec

    ^#contentSpec

    "Created: / 21-10-2008 / 12:35:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultModel
    ^ nil

    "Created: / 03-10-2008 / 14:57:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultSubtitle

    ^''

    "Created: / 03-10-2008 / 13:54:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

defaultTitle
    ^ 'Commit'

    "Created: / 03-10-2008 / 13:58:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-02-2012 / 18:25:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractDialog methodsFor:'actions'!

doAccept
    self acceptEnabled ifTrue:[
        super doAccept
    ]

    "Created: / 16-08-2009 / 17:18:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doCancel
    self infoPanel doAbortIfWorking.
    super doCancel

    "Created: / 28-10-2008 / 14:47:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-10-2012 / 19:21:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doHelp
    <resource: #uiCallback>

    Transcript showCR:self class name, ': action for doHelp ...'.
!

doInspect

    self model inspect
!

doInspectDialog

    self inspect

    "Created: / 10-03-2010 / 15:30:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractDialog methodsFor:'aspects'!

acceptButtonTitleAspect
    ^ self acceptButtonLabel

    "Modified: / 31-03-2008 / 18:53:56 / janfrog"
    "Created: / 13-04-2008 / 11:08:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

acceptEnabledHolder
    |holder|

    (holder := builder bindingAt:#acceptEnabledHolder) isNil ifTrue:[
        holder := false asValue.
        builder aspectAt:#acceptEnabledHolder put:holder.
    ].
    ^ holder.

    "Created: / 14-04-2008 / 11:17:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2008 / 12:56:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

catchExceptionsAspect

    ^(AspectAdaptor forAspect:#catchExceptions)
        subject: self class

    "Created: / 09-12-2009 / 16:23:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contentSpecHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#contentSpecHolder) isNil ifTrue:[
        holder := self defaultContentSpec asValue.
        holder onChangeSend:#contentSpecChanged to: self.
        builder aspectAt:#contentSpecHolder put:holder.
    ].
    ^ holder.

    "Created: / 21-10-2008 / 12:34:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-10-2008 / 11:22:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

dialogIconAspect
    ^ self class dialogIcon

    "Created: / 13-04-2008 / 11:05:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

subtitleHolder
    "return/create the valueHolder 'dialogSubtitleHolder'"
    
    subtitleHolder isNil ifTrue:[
        subtitleHolder := self defaultSubtitle asValue
    ].
    ^ subtitleHolder

    "Created: / 03-10-2008 / 13:53:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 07:53:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

titleHolder
    titleHolder isNil ifTrue:[
        titleHolder := self defaultTitle asValue.
    ].
    ^titleHolder

    "Modified: / 31-03-2008 / 18:53:56 / janfrog"
    "Created: / 13-04-2008 / 11:05:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 07:52:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SCMAbstractDialog methodsFor:'change & update'!

contentSpecChanged

    self contentSpecChanged: self contentSpec

    "Created: / 22-10-2008 / 11:22:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-11-2008 / 18:31:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

contentSpecChanged: specSymbol

    "nothing to do here"

    "Created: / 06-11-2008 / 18:31:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SCMAbstractDialog methodsFor:'events'!

closeAccept

    [onAcceptBlock ifNotNil:[onAcceptBlock value: self]]
        ensure:[super closeAccept]
!

closeCancel

    [onCancelBlock ifNotNil:[onCancelBlock value: self]]
        ensure:[super closeCancel]
!

closeWindow
    super closeWindow.
    self infoPanel doAbortIfWorking.

    "Created: / 01-11-2009 / 16:33:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2012 / 17:19:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractDialog methodsFor:'hooks'!

onAccept: aBlock

    onAcceptBlock := aBlock
!

onCancel: aBlock

    onCancelBlock := aBlock
! !

!SCMAbstractDialog methodsFor:'initialization'!

initialize

    super initialize.
    self createBuilder

    "Created: / 22-10-2008 / 12:37:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SCMAbstractDialog methodsFor:'private'!

handleError: ex

    self breakPoint: #jv.

    self class catchExceptions ifFalse:[ex pass].    
    self showError: ex description.

    "Created: / 09-12-2009 / 16:32:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleUserConfirmation: ex

    ^ex proceedWith: ex defaultAction

    "Created: / 09-12-2009 / 16:31:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showContent

    self 
        contentSpec: #contentSpec.

    "Created: / 09-04-2009 / 08:14:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showErorr: aString
    self infoPanel beWarning; showMessage: aString

    "Created: / 04-10-2012 / 19:24:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showError: aString

    self 
        info: aString;
        contentSpec: #errorSpec

    "Created: / 09-12-2009 / 16:40:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showMessage: aString
    self infoPanel beInformation; showMessage: aString

    "Created: / 09-04-2009 / 08:14:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-10-2012 / 19:24:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showProgressWhile:aBlock 

    self infoPanel progress: 'Working copy...' while: aBlock.

    "Created: / 21-10-2008 / 12:07:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 08:28:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 11-02-2012 / 23:03:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractDialog class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

