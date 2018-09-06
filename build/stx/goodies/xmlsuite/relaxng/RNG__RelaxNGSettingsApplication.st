"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

AbstractSettingsApplication subclass:#RelaxNGSettingsApplication
	instanceVariableNames:'schemaSearchPathHolder selectedDirectoryAspect'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Settings'
!


!RelaxNGSettingsApplication class methodsFor:'initialization'!

initialize

    self installInSettings

    "Created: / 22-06-2005 / 14:44:01 / masca"
!

installInSettings

    AbstractLauncherApplication settingsList 
        addLast:(Array with:'Relax NG' with:self name)

    "Created: / 22-06-2005 / 14:46:18 / masca"
! !

!RelaxNGSettingsApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:RNG::RelaxNGSettingsApplication andSelector:#windowSpec
     RNG::RelaxNGSettingsApplication new openInterface:#windowSpec
     RNG::RelaxNGSettingsApplication open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'RelaxNGSettingsApplication'
          name: 'RelaxNGSettingsApplication'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 462 357)
        )
        component: 
       (SpecCollection
          collection: (
           (FramedBoxSpec
              name: 'SchemaSearchPathBox'
              label: 'Schema search paths'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              labelPosition: topLeft
              translateLabel: true
              component: 
             (SpecCollection
                collection: (
                 (SelectionInListModelViewSpec
                    name: 'SchemaSearchPathList'
                    layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
                    model: selectedDirectoryAspect
                    menu: schemaSearchPathMenu
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    listModel: schemaSearchPathHolder
                    useIndex: false
                    highlightMode: line
                  )
                 (HorizontalPanelViewSpec
                    name: 'ButtonPanel'
                    layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
                    horizontalLayout: fit
                    verticalLayout: center
                    horizontalSpace: 3
                    verticalSpace: 3
                    component: 
                   (SpecCollection
                      collection: (
                       (ActionButtonSpec
                          label: 'Add'
                          name: 'AddButton'
                          translateLabel: true
                          model: addDirectoryAction
                          extent: (Point 212 22)
                        )
                       (ActionButtonSpec
                          label: 'Remove'
                          name: 'RemoveButton'
                          translateLabel: true
                          enableChannel: carRemoveDirectory
                          disabledLogo: 'removeDirecoryAction'
                          extent: (Point 213 22)
                        )
                       )
                     
                    )
                  )
                 )
               
              )
            )
           )
         
        )
      )

    "Modified: / 22-06-2005 / 15:13:40 / masca"
! !

!RelaxNGSettingsApplication class methodsFor:'menu specs'!

schemaSearchPathMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:RNG::RelaxNGSettingsApplication andSelector:#schemaSearchPathMenu
     (Menu new fromLiteralArrayEncoding:(RNG::RelaxNGSettingsApplication schemaSearchPathMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Add...'
            itemValue: addDirectoryAction
            translateLabel: true
          )
         (MenuItem
            enabled: canRemoveDirectory
            label: 'Remove'
            itemValue: removeDirectoryAction
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Created: / 22-06-2005 / 14:58:13 / masca"
! !

!RelaxNGSettingsApplication methodsFor:'accessing'!

schemaSearchPathHolder


    ^schemaSearchPathHolder ifNil:[
        schemaSearchPathHolder := RNG::Schema schemaSearchPath copy asList asValue
    ]

    "Created: / 22-06-2005 / 14:54:20 / masca"
!

selectedDirectoryAspect


    ^selectedDirectoryAspect ifNil:[
        selectedDirectoryAspect := ValueHolder new
    ]

    "Created: / 22-06-2005 / 14:56:20 / masca"
! !

!RelaxNGSettingsApplication methodsFor:'actions'!

addDirectoryAction

    | directoryName |
    directoryName := Dialog requestDirectoryName:'Select directory with schemas'.
    directoryName isEmptyOrNil ifTrue:[^self].
    directoryName asFilename exists ifFalse:[^Dialog warn:'Directory ',directoryName,' does not exist'].
    directoryName asFilename isDirectory ifFalse:[^Dialog warn:directoryName,' is not directory'].

    schemaSearchPathHolder value add:directoryName.
    modifiedChannel value:true

    "Created: / 22-06-2005 / 14:55:39 / masca"
!

removeDirectoryAction

    selectedDirectoryAspect value ifNil:[^self].
    schemaSearchPathHolder value remove:selectedDirectoryAspect value.
    modifiedChannel value:true

    "Created: / 22-06-2005 / 14:55:39 / masca"
! !

!RelaxNGSettingsApplication methodsFor:'drag & drop'!

drop:arg1 in:arg2 at:arg3 
    "drop manager wants to drop.
This is ony sent, if #canDrop:in: returned true.
Must be redefined in apps which return true to #canDrop."

    self shouldImplement

    "Created: / 22-06-2005 / 14:47:45 / masca"
! !

!RelaxNGSettingsApplication methodsFor:'protocol'!

basicSaveSettings
    "Superclass says that I am responsible to implement this method"

    RNG::Schema schemaSearchPath:schemaSearchPathHolder value asOrderedCollection

    "Created: / 22-06-2005 / 14:47:45 / masca"
!

hasUnsavedChanges
    "Superclass says that I am responsible to implement this method"

    ^modifiedChannel value

    "Created: / 22-06-2005 / 14:47:44 / masca"
!

readSettings

    "
        Nothing to do now
    "

    "Modified: / 22-06-2005 / 14:54:48 / masca"
! !

!RelaxNGSettingsApplication methodsFor:'queries'!

canRemoveDirectory

    self selectedDirectoryAspect value notNil

    "Created: / 22-06-2005 / 14:58:49 / masca"
! !

!RelaxNGSettingsApplication class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__RelaxNGSettingsApplication.st,v 1.1.1.1 2005-11-01 22:07:14 vranyj1 Exp $'
! !

RelaxNGSettingsApplication initialize!
