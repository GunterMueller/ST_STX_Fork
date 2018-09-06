"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

FileDialog subclass:#FileDialogWithPreview
	instanceVariableNames:'imagePreview'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileDialogWithPreview class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    a FileDialog with image preview
"
! !

!FileDialogWithPreview class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileDialogWithPreview andSelector:#windowSpec
     FileDialogWithPreview new openInterface:#windowSpec
     FileDialogWithPreview open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'FileDialog'
          name: 'FileDialog'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 407 607)
          menu: mainMenu
          performer: treeBrowser
        )
        component: 
       (SpecCollection
          collection: (
           (VariableVerticalPanelSpec
              name: 'FilePanel'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 -30 1.0)
              showHandle: true
              handlePosition: center
              component: 
             (SpecCollection
                collection: (
                 (ViewSpec
                    name: 'FilePart'
                    component: 
                   (SpecCollection
                      collection: (
                       (MenuPanelSpec
                          name: 'ToolBar1'
                          layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 40 0)
                          tabable: true
                          menu: toolBarMenu
                          textDefault: true
                        )
                       (VariableHorizontalPanelSpec
                          name: 'DeviceAndFilterPanel'
                          layout: (LayoutFrame 0 0 40 0 0 1 70 0)
                          level: 1
                          showHandle: true
                          component: 
                         (SpecCollection
                            collection: (
                             (ViewSpec
                                name: 'Box1'
                                component: 
                               (SpecCollection
                                  collection: (
                                   (ComboListSpec
                                      name: 'ComboList1'
                                      layout: (LayoutFrame 1 0 1 0.0 -1 1 -1 1)
                                      visibilityChannel: driveSelectorVisible
                                      model: selectedDeviceDrive
                                      comboList: listOfDeviceDrives
                                      useIndex: false
                                      hidePullDownMenuButton: false
                                    )
                                   )
                                 
                                )
                              )
                             (ViewSpec
                                name: 'Box2'
                                component: 
                               (SpecCollection
                                  collection: (
                                   (LabelSpec
                                      label: 'Filter:'
                                      name: 'FilterLabel'
                                      layout: (LayoutFrame 1 0 2 0 59 0 -2 1)
                                      translateLabel: true
                                      adjust: right
                                    )
                                   (InputFieldSpec
                                      name: 'FilterEntryField'
                                      layout: (LayoutFrame 60 0 -27 1 -2 1 -2 1)
                                      model: filterHolder
                                      immediateAccept: true
                                      acceptOnReturn: true
                                      acceptOnTab: true
                                      acceptOnLostFocus: true
                                      acceptOnPointerLeave: false
                                      postBuildCallback: postBuildFilterField:
                                    )
                                   )
                                 
                                )
                              )
                             )
                           
                          )
                          handles: (Any 0.2972972972973 1.0)
                        )
                       (SubCanvasSpec
                          name: 'DirectoryTreeBrowser'
                          layout: (LayoutFrame 0 0.0 70 0 0 1.0 -30 1)
                          tabable: true
                          hasHorizontalScrollBar: false
                          hasVerticalScrollBar: false
                          majorKey: DirectoryTreeBrowser
                          subAspectHolders: 
                         (Array
                            
                           (SubChannelInfoSpec
                              subAspect: filterModel
                              aspect: filterHolder
                            ) 
                           (SubChannelInfoSpec
                              subAspect: rootHolder
                              aspect: rootDirectoryHolder
                            )
                            
                           (SubChannelInfoSpec
                              subAspect: showHiddenFiles
                              aspect: showHiddenFiles
                            )
                          )
                          createNewApplication: true
                          createNewBuilder: true
                          postBuildCallback: postBuildTreeBrowser:
                        )
                       (LabelSpec
                          label: 'Filename:'
                          name: 'FilenameLabel'
                          layout: (LayoutFrame 3 0 -25 1 90 0 -1 1)
                          translateLabel: true
                          labelChannel: filenameLabelHolder
                          adjust: left
                        )
                       (FilenameInputFieldSpec
                          name: 'FilenameEntryField'
                          layout: (LayoutFrame 90 0 -25 1 -4 1 -1 1)
                          tabable: true
                          model: filenameHolder
                          immediateAccept: false
                          acceptOnPointerLeave: false
                          hasKeyboardFocusInitially: true
                          postBuildCallback: postBuildFileNameField:
                        )
                       )
                     
                    )
                  )
                 (ViewSpec
                    name: 'PreviewBox'
                    visibilityChannel: previewVisibleHolder
                    component: 
                   (SpecCollection
                      collection: (
                       (ArbitraryComponentSpec
                          name: 'ArbitraryComponent1'
                          layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                          visibilityChannel: imageViewVisible
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                          miniScrollerHorizontal: true
                          miniScrollerVertical: true
                          hasBorder: false
                          component: ImageView
                          postBuildCallback: postBuildImageView:
                        )
                       )
                     
                    )
                  )
                 )
               
              )
              handles: (Any 0.750433275563258 1.0)
              postBuildCallback: postBuildVerticalPanelView:
            )
           (HorizontalPanelViewSpec
              name: 'ButtonPanel'
              layout: (LayoutFrame 0 0.0 -30 1 0 1 0 1)
              visibilityChannel: buttonPanelVisibleHolder
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'cancelButton'
                    translateLabel: true
                    labelChannel: cancelLabelHolder
                    tabable: true
                    model: doCancel
                    extent: (Point 131 25)
                  )
                 (ActionButtonSpec
                    label: 'Append'
                    name: 'appendButton'
                    visibilityChannel: appendButtonVisibleHolder
                    translateLabel: true
                    labelChannel: appendLabelHolder
                    tabable: true
                    model: appendPressed
                    extent: (Point 132 25)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'okButton'
                    translateLabel: true
                    labelChannel: okLabelHolder
                    tabable: true
                    model: okPressed
                    isDefault: true
                    extent: (Point 132 25)
                  )
                 )
               
              )
              keepSpaceForOSXResizeHandleH: true
            )
           )
         
        )
      )
! !

!FileDialogWithPreview class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #filenameHolder
        #filterHolder
        #rootDirectoryHolder
      ).

! !

!FileDialogWithPreview methodsFor:'change & update'!

fileSelectionChanged
    |fn mime image|

    super fileSelectionChanged.
    ((fn := self filenameHolder value) notNil and:[ fn exists ]) ifTrue:[
        (mime := fn mimeTypeFromName) notNil ifTrue:[
            mime isImageType ifTrue:[
                image := Image fromFile:fn.
                imagePreview image:image.
            ].
        ].
    ].

    "Created: / 14-02-2011 / 18:00:39 / cg"
! !

!FileDialogWithPreview methodsFor:'initialization'!

postBuildImageView:aView
    imagePreview := aView

    "Created: / 14-02-2011 / 18:08:05 / cg"
! !

!FileDialogWithPreview class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/FileDialogWithPreview.st,v 1.6 2013-12-07 10:46:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/FileDialogWithPreview.st,v 1.6 2013-12-07 10:46:29 cg Exp $'
! !

