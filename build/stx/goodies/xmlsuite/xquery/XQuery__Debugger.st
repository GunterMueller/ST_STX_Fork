"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::Debugger subclass:#Debugger
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Debugging-UI'
!


!Debugger class methodsFor:'interface specs'!

variablePaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:XQuery::Debugger andSelector:#variablePaneSpec
     XQuery::Debugger new openInterface:#variablePaneSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: variablePaneSpec
        window: 
       (WindowSpec
          label: 'Variables'
          name: 'Variables'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableHorizontalPanelSpec
              name: 'Panel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              showHandle: true
              snapMode: both
              component: 
             (SpecCollection
                collection: (
                 (DataSetSpec
                    name: 'List'
                    model: variableHolder
                    menu: variableMenu
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    dataList: variableListAspect
                    useIndex: false
                    has3Dseparators: true
                    doubleClickSelector: variableInspect
                    columnHolder: variableListColumns
                  )
                 (TransparentBoxSpec
                    name: 'InspectorBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (SubCanvasSpec
                          name: 'Inspector'
                          layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                          hasHorizontalScrollBar: false
                          hasVerticalScrollBar: false
                          miniScrollerVertical: false
                          majorKey: #'XMLv2::DOM3Inspector'
                          subAspectHolders: 
                         (Array
                            
                           (SubChannelInfoSpec
                              subAspect: modelHolder
                              aspect: variableAsDocumentFragmentAspect
                            )
                          )
                          createNewApplication: true
                          createNewBuilder: true
                        )
                       )
                     
                    )
                  )
                 )
               
              )
              handles: (Any 0.5 1.0)
            )
           )
         
        )
      )
! !

!Debugger class methodsFor:'menu specs'!

variableMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:XQuery::Debugger andSelector:#variableMenu
     (Menu new fromLiteralArrayEncoding:(XQuery::Debugger variableMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasVariableSelected
            label: 'Inspect'
            itemValue: variableInspect
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Modified: / 23-04-2010 / 10:43:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Debugger class methodsFor:'tableColumns specs'!

variableListColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:XQuery::Debugger andSelector:#variableListColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Name'
         labelButtonType: Button
         width: 0.25
         printSelector: name
         canSelect: false
         showRowSeparator: false
       )
      (DataSetColumnSpec
         label: 'Type'
         labelButtonType: Button
         width: 0.25
         printSelector: typeName
         canSelect: false
         showRowSeparator: false
       )
      (DataSetColumnSpec
         label: 'Value'
         labelButtonType: Button
         width: 0.49
         printSelector: valueString
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      )

    "Modified: / 20-04-2010 / 21:01:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Debugger methodsFor:'aspects'!

variableAsDocumentFragmentAspect

    ^(AspectAdaptor forAspect:#asDocumentFragment)
        subjectChannel: self variableHolder

    "Created: / 23-04-2010 / 11:27:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Debugger methodsFor:'menu actions'!

variableInspect

    | variable |
    (variable := self variableHolder value)
        ifNotNil:[variable value inspect]

    "Modified: / 23-04-2010 / 10:44:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Debugger class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
