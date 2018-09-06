"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

SimpleDialog subclass:#MCDialog
	instanceVariableNames:'onCancelBlock onAcceptBlock modelHolder titleHolder
		subtitleHolder infoHolder progressIndicator worker exception'
	classVariableNames:'CatchExceptions'
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!

!MCDialog class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
! !

!MCDialog class methodsFor:'instance creation'!

on: model

    ^self new 
        model: model;
        yourself

    "Created: / 14-04-2008 / 11:09:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MCDialog class methodsFor:'accessing'!

catchExceptions

    ^CatchExceptions isNil or:[CatchExceptions]

    "Created: / 09-12-2009 / 16:22:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

catchExceptions: aBoolean

    CatchExceptions := aBoolean

    "Created: / 09-12-2009 / 16:22:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCDialog class methodsFor:'image specs'!

dialogIcon
    ^ "IconLibrary svn_wizban"nil

    "Created: / 13-04-2008 / 11:06:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-09-2010 / 22:59:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

!MCDialog class methodsFor:'interface opening'!

openOn: model


    ^(self on: model) open

    "Created: / 14-04-2008 / 11:09:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-04-2008 / 13:17:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MCDialog class methodsFor:'interface specs'!

buttonsSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MCDialog andSelector:#buttonsSpec
     MCDialog new openInterface:#buttonsSpec
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
                   isDefault: true
                   defaultable: true
                   extent: (Point 196 22)
                 )
                )
              
             )
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

progressSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::Dialog andSelector:#progressSpec
     SVN::Dialog new openInterface:#progressSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: progressSpec
        window: 
       (WindowSpec
          label: 'Progress'
          name: 'Progress'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'InfoPanel'
              layout: (LayoutFrame 20 0 20 0 -20 1 -20 1)
              horizontalLayout: fit
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Working'
                    name: 'InfoHolder'
                    translateLabel: true
                    labelChannel: infoHolder
                    adjust: left
                    useDefaultExtent: true
                  )
                 (ProgressIndicatorSpec
                    name: 'ProgressIndicator'
                    model: progressHolder
                    isActivityIndicator: true
                    postBuildCallback: postBuildProgressIndicator:
                    useDefaultExtent: true
                  )
                 )
               
              )
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
     UIPainter new openOnClass:MCDialog andSelector:#windowSpec
     MCDialog new openInterface:#windowSpec
     MCDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'SubVersion: Commit '
         name: 'SubVersion: Commit '
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
                   label: 'SVN Dialog'
                   name: 'DialogTitle'
                   layout: (LayoutFrame 10 0 0 0 -75 1 40 0)
                   style: (FontDescription helvetica medium roman 18 #'iso10646-1')
                   backgroundColor: (Color 100.0 100.0 100.0)
                   translateLabel: true
                   labelChannel: titleHolder
                   adjust: left
                 )
                (LabelSpec
                   label: 'SVN Dialog Subtitle'
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
                   layout: (LayoutFrame -75 1 0 0 0 1 66 0)
                   hasCharacterOrientedLabel: false
                   backgroundColor: (Color 100.0 100.0 100.0)
                   translateLabel: true
                   labelChannel: dialogIconAspect
                 )
                )
              
             )
           )
          (SubCanvasSpec
             name: 'Content'
             layout: (LayoutFrame 5 0 70 0 -5 1 -50 1)
             hasHorizontalScrollBar: false
             hasVerticalScrollBar: false
             specHolder: contentSpecHolder
             createNewBuilder: false
           )
          (DividerSpec
             name: 'Separator'
             layout: (LayoutFrame 5 0 -50 1 -5 1 -30 1)
           )
          (LinkButtonSpec
             label: 'Help'
             name: 'Help'
             layout: (LayoutFrame 53 0 -26 1 153 0 -3 1)
             initiallyInvisible: true
             visibilityChannel: false
             foregroundColor: (Color 0.0 0.0 87.0)
             translateLabel: true
             model: doHelp
           )
          (MenuPanelSpec
             name: 'More'
             layout: (LayoutFrame 0 0 -30 1 62 0 0 1)
             level: 0
             visibilityChannel: false
             model: doInspect
             menu: actionsMenu
           )
          (UISubSpecification
             name: 'Buttons'
             layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
             minorKey: buttonsSpec
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
! !

!MCDialog class methodsFor:'menu specs'!

actionsMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:MCDialog andSelector:#actionsMenu
     (Menu new fromLiteralArrayEncoding:(MCDialog actionsMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Debug'
            translateLabel: true
            isButton: true
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
          )
         )
        nil
        nil
      )
! !

!MCDialog methodsFor:'accessing'!

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

info: aString

    ^self infoHolder value: aString

    "Created: / 09-04-2009 / 08:00:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

model
    ^self modelHolder value

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Created: / 12-04-2008 / 20:50:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

model:aModel
    self modelHolder subjectChannel:aModel
    "aModel isValueModel 
        ifTrue:[self modelHolder subjectChannel:aModel]
        ifFalse:[self modelHolder subject:aModel]."

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Created: / 12-04-2008 / 20:50:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

modelHolder
    ^ modelHolder 
        ifNil:[
            modelHolder := (AspectAdaptor subjectChannel:self defaultModel) 
                        forAspect:#value
        ]

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Created: / 12-04-2008 / 20:50:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-10-2008 / 14:57:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
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

!MCDialog methodsFor:'accessing - defaults'!

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
    ^ self subclassResponsibility

    "Created: / 03-10-2008 / 13:58:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MCDialog methodsFor:'actions'!

doAccept
    self acceptEnabled ifTrue:[
        super doAccept
    ]

    "Created: / 16-08-2009 / 17:18:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doCancel

    "Terminate a worker process, if any"
    worker ifNotNil:[worker terminate].
    "And close"
    super doCancel

    "Created: / 28-10-2008 / 14:47:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doHelp
    <resource: #uiCallback>

    Dialog information: 'Sorry: no help (yet)'.

    "Modified: / 24-07-2012 / 16:20:22 / cg"
!

doInspect

    self model inspect
!

doInspectDialog

    self inspect

    "Created: / 10-03-2010 / 15:30:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCDialog methodsFor:'aspects'!

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

infoHolder
    "return/create the 'infoHolder' value holder (automatically generated)"

    infoHolder isNil ifTrue:[
        infoHolder := ValueHolder new.
    ].
    ^ infoHolder
!

progressHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#progressHolder) isNil ifTrue:[
        holder := nil asValue.
        builder aspectAt:#progressHolder put:holder.
    ].
    ^ holder.

    "Created: / 21-10-2008 / 12:24:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
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

!MCDialog methodsFor:'change & update'!

contentSpecChanged

    self contentSpecChanged: self contentSpec

    "Created: / 22-10-2008 / 11:22:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-11-2008 / 18:31:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

contentSpecChanged: specSymbol

    "nothing to do here"

    "Created: / 06-11-2008 / 18:31:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MCDialog methodsFor:'events'!

closeAccept

    [onAcceptBlock ifNotNil:[onAcceptBlock value: self]]
        ensure:[super closeAccept]
!

closeCancel

    [onCancelBlock ifNotNil:[onCancelBlock value: self]]
        ensure:[super closeCancel]
!

closeWindow

    worker 
        ifNotNil:[worker addExitAction:[self closeWindow]]
        ifNil:[super closeWindow]

    "Created: / 01-11-2009 / 16:33:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCDialog methodsFor:'hooks'!

onAccept: aBlock

    onAcceptBlock := aBlock
!

onCancel: aBlock

    onCancelBlock := aBlock
!

postBuildProgressIndicator:aView
    <resource: #uiCallback>

    progressIndicator := aView

    "Modified: / 28-10-2008 / 12:50:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MCDialog methodsFor:'initialization'!

initialize

    super initialize.
    self createBuilder

    "Created: / 22-10-2008 / 12:37:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MCDialog methodsFor:'private'!

handleError: ex

    self class catchExceptions ifFalse:[ex pass].    
    self showError: ex description.

    "Created: / 09-12-2009 / 16:32:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleNotification:ex 

    self info:ex messageText.
    ex parameter isNumber 
        ifTrue:
            [progressIndicator showBusyIndication:false.
            self progressHolder value:ex parameter]
        ifFalse:
            [progressIndicator showBusyIndication:true].
    ex proceed.

    "Modified: / 09-12-2009 / 16:32:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

showError: aString

    self 
        info: aString;
        contentSpec: #errorSpec

    "Created: / 09-12-2009 / 16:40:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showMessage: aString

    self 
        info: aString;
        contentSpec: #messageSpec.

    "Created: / 09-04-2009 / 08:14:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showProgressWhile:aBlock 
    |prevSpec|

    prevSpec := self contentSpec.
    self contentSpec:#progressSpec.
    worker := 
            [[ aBlock on: UserConfirmation do: [:ex|self handleUserConfirmation: ex] ]
                on: (ActivityNotification , ProgressNotification)
                do: [:ex|self handleNotification: ex]
                on: Error
                do: [:ex|self handleError: ex].
            worker := nil] newProcess.
    worker
        addExitAction:[
                self contentSpec == #progressSpec ifTrue:[
                    self contentSpec:prevSpec
                ].
                worker := nil
            ];
        resume.

    "Created: / 21-10-2008 / 12:07:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-04-2009 / 08:28:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-12-2009 / 16:42:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDialog.st,v 1.6 2013-03-28 00:13:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDialog.st,v 1.6 2013-03-28 00:13:45 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: MCDialog.st 12 2010-09-15 13:13:22Z vranyj1 §'
! !

