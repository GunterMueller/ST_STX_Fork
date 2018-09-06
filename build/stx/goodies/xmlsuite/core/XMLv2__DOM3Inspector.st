"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

ApplicationModel subclass:#DOM3Inspector
	instanceVariableNames:'modelHolder elementPropertiesPane domNodeInspectorView'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3 Inspector'
!

HierarchicalItem subclass:#DOM3NodeItem
	instanceVariableNames:'node'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DOM3Inspector
!

ApplicationModel subclass:#ElementPropertiesPane
	instanceVariableNames:'modelHolder'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DOM3Inspector
!


!DOM3Inspector class methodsFor:'instance creation'!

on: aNode

    ^self new
        model: aNode;
        yourself

    "Created: / 10-01-2010 / 10:17:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DOM3Inspector class methodsFor:'interface specs'!

propertiesTabPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:XMLv2::DOM3Inspector andSelector:#propertiesTabPaneSpec
     XMLv2::DOM3Inspector new openInterface:#propertiesTabPaneSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: propertiesTabPaneSpec
        window: 
       (WindowSpec
          label: 'DOM Node properties'
          name: 'DOM Node properties'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 538 516)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'ElementPropertiesCanvas'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              clientHolder: domNodePropertiesPaneAspect
              subAspectHolders: 
             (Array
                
               (SubChannelInfoSpec
                  subAspect: modelHolder
                  aspect: domNodeAspect
                )
              )
            )
           )
         
        )
      )

    "Modified: / 12-12-2006 / 09:09:10 / janfrog"
    "Modified: / 10-01-2010 / 10:56:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

smalltalkObjectTabPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:XMLv2::DOM3Inspector andSelector:#smalltalkObjectTabPaneSpec
     XMLv2::DOM3Inspector new openInterface:#smalltalkObjectTabPaneSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: smalltalkObjectTabPaneSpec
        window: 
       (WindowSpec
          label: 'DOM Node properties'
          name: 'DOM Node properties'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 538 516)
        )
        component: 
       (SpecCollection
          collection: (
           (ArbitraryComponentSpec
              name: 'NodeInspector'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              hasBorder: false
              component: domNodeInspectorView
            )
           )
         
        )
      )

    "Modified: / 12-12-2006 / 09:43:08 / janfrog"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:XMLv2::DOM3Inspector andSelector:#windowSpec
     XMLv2::DOM3Inspector new openInterface:#windowSpec
     XMLv2::DOM3Inspector open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'DOM Inspector'
          name: 'DOM Inspector'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 554 438)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableHorizontalPanelSpec
              name: 'SplitPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              showHandle: true
              snapMode: both
              component: 
             (SpecCollection
                collection: (
                 (HierarchicalListViewSpec
                    name: 'NodeTree'
                    model: domNodeAspect
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    listModel: domNodeTreeAspect
                    useIndex: false
                    highlightMode: line
                    useDefaultIcons: false
                    properties: 
                   (PropertyListDictionary
                      dragArgument: nil
                      dropArgument: nil
                      canDropSelector: canDropDocument:
                      dropSelector: dropDocument:
                    )
                  )
                 (NoteBookViewSpec
                    name: 'NodeProperties'
                    menu: propertyTabList
                  )
                 )
               
              )
              handles: (Any 0.3 1.0)
            )
           )
         
        )
      )

    "Modified: / 12-12-2006 / 11:40:23 / janfrog"
!

xmlTabPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:XMLv2::DOM3Inspector andSelector:#propertyPaneXML
     XMLv2::DOM3Inspector new openInterface:#propertyPaneXML
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: propertyPaneXML
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (TextEditorSpec
              name: 'NodeXML'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: domNodeXMLAspect
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              isReadOnly: true
            )
           )
         
        )
      )

    "Created: / 12-12-2006 / 08:48:07 / janfrog"
! !

!DOM3Inspector class methodsFor:'list specs'!

propertyTabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#propertyTabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'XML'
          minorKey: xmlTabPaneSpec
        )
       (TabItem
          label: 'Properties'
          minorKey: propertiesTabPaneSpec
        )
       (TabItem
          label: 'Smalltalk object'
          minorKey: smalltalkObjectTabPaneSpec
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]

    "Modified: / 12-12-2006 / 09:43:44 / janfrog"
! !

!DOM3Inspector class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #modelHolder
      ).

    "Modified: / 12-12-2006 / 11:40:23 / janfrog"
    "Modified: / 23-04-2010 / 11:30:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DOM3Inspector methodsFor:'accessing'!

domNode

    | domNodeItem |
    domNodeItem := self domNodeAspect value.
    ^domNodeItem    
        ifNotNil:[domNodeItem node]
        ifNil:[nil]

    "Created: / 12-12-2006 / 00:42:07 / janfrog"
    "Modified: / 10-01-2010 / 10:43:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

domNodeInspectorView

    domNodeInspectorView ifNil:
        [domNodeInspectorView := InspectorView new.
         "domNodeInspectorView fieldListLabel: 'DOM3Node:'"
        domNodeInspectorView inspect:self domNode].
    ^domNodeInspectorView

    "Created: / 12-12-2006 / 09:41:31 / janfrog"
    "Modified: / 12-12-2006 / 11:41:17 / janfrog"
!

elementPropertiesPane

    elementPropertiesPane ifNil:
        [elementPropertiesPane := ElementPropertiesPane new modelHolder:self domNodeAspect].
    ^elementPropertiesPane

    "Created: / 12-12-2006 / 09:12:00 / janfrog"
    "Modified: / 10-01-2010 / 10:31:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

model

    ^self modelHolder value
!

model: anObject

    self modelHolder value: anObject
! !

!DOM3Inspector methodsFor:'aspects'!

domNodeAspect
    ^ builder bindings at:#domNodeAspect
        ifAbsent:[
            builder bindings at:#domNodeAspect
                put:((self domNodeTreeAspect value root asValue)
                        onChangeSend:#updateDomNodeInspectorView to: self;
                        yourself)
        ].

    "Created: / 12-12-2006 / 00:15:39 / janfrog"
    "Modified: / 12-12-2006 / 09:44:23 / janfrog"
    "Modified: / 10-01-2010 / 10:29:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

domNodePropertiesPaneAspect
    ^ builder bindings at:#domNodePropertiesPaneAspect
        ifAbsent:[
            builder bindings at:#domNodePropertiesPaneAspect
                put:(PluggableAdaptor on:self domNodeAspect
                        getter:[:m | 
                            m value 
                                ifNil:[ nil ]
                                ifNotNil:[
                                    m value isElement ifFalse:[
                                        nil
                                    ] ifTrue:[
                                        self elementPropertiesPane
                                    ]
                                ]
                        ])
        ]

    "Created: / 12-12-2006 / 09:09:00 / janfrog"
!

domNodeTreeAspect
    ^ builder bindings at:#domTreeNodeAspect
        ifAbsent:[
            |hlist|
            hlist := (HierarchicalList new)
                        root:(DOM3NodeItem for:self model);
                        showRoot:(self model notNil and:[ self model isDocumentFragment not]);
                        yourself.
            hlist root expand.
            builder bindings at:#domTreeNodeAspect put:hlist
        ]

    "Created: / 12-12-2006 / 00:16:47 / janfrog"
    "Modified: / 12-12-2006 / 12:47:40 / janfrog"
    "Modified: / 15-07-2010 / 16:06:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

domNodeXMLAspect
    ^ builder bindings at:#domNodeXMLAspect
        ifAbsent:[
            builder bindings at:#domNodeXMLAspect
                put:((AspectAdaptor forAspect:#asColorXMLString) 
                        subjectChannel:self domNodeAspect)
        ]

    "Created: / 12-12-2006 / 00:45:19 / janfrog"
    "Modified: / 10-01-2010 / 10:34:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modelHolder
    "return/create the 'modelHolder' value holder (automatically generated)"

    modelHolder isNil ifTrue:[
        modelHolder := ValueHolder new.
    ].
    ^ modelHolder
!

modelHolder:something
    "set the 'modelHolder' value holder (automatically generated)"

    |oldValue newValue|

    modelHolder notNil ifTrue:[
        oldValue := modelHolder value.
        modelHolder removeDependent:self.
    ].
    modelHolder := something.
    modelHolder notNil ifTrue:[
        modelHolder addDependent:self.
    ].
    newValue := modelHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:modelHolder.
    ].
!

propertyTabList
    "Generated by the TabListEditor"
    
    |list|

    (list := builder bindingAt:#propertyTabList) isNil ifTrue:[
        builder bindings at:#propertyTabList
            put:(list := self class propertyTabList).
    ].
    ^ list

    "Created: / 12-12-2006 / 00:12:43 / janfrog"
! !

!DOM3Inspector methodsFor:'change & update'!

modelChanged

    self domNodeTreeAspect 
            root:(DOM3NodeItem for:self model);
            showRoot:(self model notNil and:[self model isDocumentFragment not]).
            
    self domNodeTreeAspect root expand.

    "Created: / 23-04-2010 / 11:44:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-07-2010 / 16:03:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == modelHolder ifTrue:[
         self modelChanged.
         ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 23-04-2010 / 11:44:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DOM3Inspector methodsFor:'drag & drop'!

canDropDocument: anObject

    self halt.

    "Created: / 12-12-2006 / 09:23:48 / janfrog"
!

dropDocument: anObject

    self halt.

    "Created: / 12-12-2006 / 09:23:51 / janfrog"
! !

!DOM3Inspector methodsFor:'updating'!

updateDomNodeInspectorView

    self domNodeInspectorView inspect: self domNode

    "Modified: / 12-12-2006 / 09:45:29 / janfrog"
! !

!DOM3Inspector::DOM3NodeItem class methodsFor:'documentation'!

version
    ^'$Id$'
! !

!DOM3Inspector::DOM3NodeItem class methodsFor:'instance creation'!

for: node 

    ^self new setNode: node; yourself

    "Created: / 12-12-2006 / 00:32:53 / janfrog"
!

for: node parent: parent

    ^self new setNode: node; parent: parent; yourself

    "Created: / 12-12-2006 / 00:30:51 / janfrog"
! !

!DOM3Inspector::DOM3NodeItem methodsFor:'accessing'!

asColorXMLString

    ^node 
        ifNil:['']
        ifNotNil:[node asColorXMLString]

    "Created: / 10-01-2010 / 10:49:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2010 / 11:37:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

attributes

    ^node attributes

    "Created: / 10-01-2010 / 10:49:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

children

    children ifNil:
        [children := 
            node 
                ifNil:
                    [#()]
                ifNotNil:
                    [node childNodes 
                        select:[:childNode| (childNode isText not) or:[childNode isIgnorableText not]]
                        thenCollect:[:childNode|self class for:childNode parent: self.]]].
    ^children

    "Created: / 12-12-2006 / 00:21:50 / janfrog"
    "Modified: / 12-12-2006 / 10:32:05 / janfrog"
    "Modified: / 23-04-2010 / 11:31:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isElement

    ^node notNil and:[node isElement]

    "Created: / 10-01-2010 / 10:49:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2010 / 11:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    node ifNil:[^''].

    node isElement ifTrue:[^'<',node nodeName,'>'].
    ^node nodeName

    "Created: / 12-12-2006 / 00:19:56 / janfrog"
    "Modified: / 23-04-2010 / 11:36:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

namespaceURI

    ^node namespaceURI

    "Created: / 10-01-2010 / 10:48:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

node
    ^ node

    "Created: / 12-12-2006 / 09:46:03 / janfrog"
!

nodeName

    ^node nodeName

    "Created: / 10-01-2010 / 10:48:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nodeType

    ^node nodeType

    "Created: / 10-01-2010 / 10:48:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nodeValue

    ^node nodeValue

    "Created: / 10-01-2010 / 10:48:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DOM3Inspector::DOM3NodeItem methodsFor:'initialization'!

setNode: aNode

    node := aNode

    "Created: / 12-12-2006 / 00:22:34 / janfrog"
! !

!DOM3Inspector::DOM3NodeItem methodsFor:'message delegation'!

doesNotUnderstand: aMessage

    ^(node respondsTo: aMessage selector)
        ifTrue:[aMessage reinvokeFor: node]
        ifFalse:[super doesNotUnderstand: aMessage]

    "Created: / 12-12-2006 / 09:04:49 / janfrog"
! !

!DOM3Inspector::ElementPropertiesPane class methodsFor:'documentation'!

version
    ^'$Id$'
! !

!DOM3Inspector::ElementPropertiesPane class methodsFor:'instance creation'!

on: aNode

    ^self new
        model: aNode;
        yourself

    "Created: / 10-01-2010 / 10:24:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DOM3Inspector::ElementPropertiesPane class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:XMLv2::DOM3Inspector::ElementPropertiesPane andSelector:#windowSpec
     XMLv2::DOM3Inspector::ElementPropertiesPane new openInterface:#windowSpec
     XMLv2::DOM3Inspector::ElementPropertiesPane open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Element Properties'
          name: 'Element Properties'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 508 266)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'PropertiesAndAttributesTablePane'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: topSpaceFit
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (HorizontalPanelViewSpec
                    name: 'PropertiesPane'
                    horizontalLayout: leftSpaceFit
                    verticalLayout: center
                    horizontalSpace: 3
                    verticalSpace: 3
                    component: 
                   (SpecCollection
                      collection: (
                       (VerticalPanelViewSpec
                          name: 'LabelPane'
                          horizontalLayout: left
                          verticalLayout: spreadSpace
                          horizontalSpace: 3
                          verticalSpace: 3
                          component: 
                         (SpecCollection
                            collection: (
                             (LabelSpec
                                label: 'Node Name:'
                                name: 'NodeNameLabel'
                                translateLabel: true
                                resizeForLabel: true
                                adjust: left
                                useDefaultExtent: true
                              )
                             (LabelSpec
                                label: 'Namespace URI:'
                                name: 'NamespaceURILabel'
                                translateLabel: true
                                resizeForLabel: true
                                adjust: left
                                useDefaultExtent: true
                              )
                             (LabelSpec
                                label: 'Node Type:'
                                name: 'NodeTypeLabel'
                                translateLabel: true
                                resizeForLabel: true
                                adjust: left
                                useDefaultExtent: true
                              )
                             (LabelSpec
                                label: 'Node Value:'
                                name: 'NodeValueLabel'
                                translateLabel: true
                                resizeForLabel: true
                                adjust: left
                                useDefaultExtent: true
                              )
                             )
                           
                          )
                          extent: (Point 130 93)
                        )
                       (VerticalPanelViewSpec
                          name: 'ValuePanel'
                          horizontalLayout: fit
                          verticalLayout: spreadSpace
                          horizontalSpace: 3
                          verticalSpace: 3
                          component: 
                         (SpecCollection
                            collection: (
                             (InputFieldSpec
                                name: 'NodeNameField'
                                initiallyDisabled: true
                                model: domNodeNameAspect
                                acceptOnReturn: true
                                acceptOnTab: true
                                acceptOnLostFocus: true
                                acceptOnPointerLeave: false
                                extent: (Point 369 22)
                              )
                             (InputFieldSpec
                                name: 'NamespaceURIField'
                                initiallyDisabled: true
                                model: domNodeNamespaceURIAspect
                                acceptOnReturn: true
                                acceptOnTab: true
                                acceptOnLostFocus: true
                                acceptOnPointerLeave: false
                                extent: (Point 369 22)
                              )
                             (InputFieldSpec
                                name: 'NodeTypeField'
                                initiallyDisabled: true
                                model: domNodeTypeAspect
                                acceptOnReturn: true
                                acceptOnTab: true
                                acceptOnLostFocus: true
                                acceptOnPointerLeave: false
                                extent: (Point 369 22)
                              )
                             (InputFieldSpec
                                name: 'NodeValueField'
                                initiallyDisabled: true
                                model: domNodeValueAspect
                                acceptOnReturn: true
                                acceptOnTab: true
                                acceptOnLostFocus: true
                                acceptOnPointerLeave: false
                                extent: (Point 369 22)
                              )
                             )
                           
                          )
                          extent: (Point 369 90)
                        )
                       )
                     
                    )
                    extent: (Point 508 90)
                  )
                 (DataSetSpec
                    name: 'AttributesTable'
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    dataList: domNodeAttributesAspect
                    columnHolder: attributeTableColumns
                    extent: (Point 508 167)
                  )
                 )
               
              )
            )
           )
         
        )
      )

    "Modified: / 12-12-2006 / 09:19:49 / janfrog"
! !

!DOM3Inspector::ElementPropertiesPane class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #model
      ).

    "Modified: / 12-12-2006 / 09:19:49 / janfrog"
! !

!DOM3Inspector::ElementPropertiesPane class methodsFor:'tableColumns specs'!

attributeTableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:XMLv2::DOM3Inspector::ElementPropertiesPane andSelector:#attributeTableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Node Name'
         labelAlignment: left
         labelButtonType: Button
         printSelector: nodeName
       )
      (DataSetColumnSpec
         label: 'Node Value'
         labelAlignment: left
         labelButtonType: Button
         printSelector: nodeValue
       )
      )

    "Created: / 12-12-2006 / 09:19:30 / janfrog"
! !

!DOM3Inspector::ElementPropertiesPane methodsFor:'accessing'!

model

    ^self modelHolder value
!

model: anObject

    self modelHolder value: anObject
! !

!DOM3Inspector::ElementPropertiesPane methodsFor:'aspects'!

domNodeAttributesAspect
    ^ builder bindings at:#domNodeAttributesAspect
        ifAbsent:[
            builder bindings at:#domNodeAttributesAspect
                put:((AspectAdaptor forAspect:#attributes) 
                        subjectChannel:self modelHolder)
        ]

    "Created: / 12-12-2006 / 09:20:19 / janfrog"
    "Modified: / 10-01-2010 / 10:25:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

domNodeNameAspect
    ^ builder bindings at:#domNodeNameAspect
        ifAbsent:[
            builder bindings at:#domNodeNameAspect
                put:((AspectAdaptor forAspect:#nodeName) subjectChannel:self modelHolder)
        ]

    "Created: / 12-12-2006 / 09:16:51 / janfrog"
    "Modified: / 10-01-2010 / 10:25:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

domNodeNamespaceURIAspect
    ^ builder bindings at:#domNodeNamespaceURIAspect
        ifAbsent:[
            builder bindings at:#domNodeNamespaceURIAspect
                put:((AspectAdaptor forAspect:#namespaceURI) 
                        subjectChannel:self modelHolder)
        ]

    "Created: / 12-12-2006 / 09:16:51 / janfrog"
    "Modified: / 10-01-2010 / 10:25:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

domNodeTypeAspect
    ^ builder bindings at:#domNodeTypeAspect
        ifAbsent:[
            builder bindings at:#domNodeTypeAspect
                put:((AspectAdaptor forAspect:#nodeType) subjectChannel:self modelHolder)
        ]

    "Created: / 12-12-2006 / 09:16:51 / janfrog"
    "Modified: / 10-01-2010 / 10:25:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

domNodeValueAspect
    ^ builder bindings at:#domNodeValueAspect
        ifAbsent:[
            builder bindings at:#domNodeValueAspect
                put:((AspectAdaptor forAspect:#nodeValue) subjectChannel:self modelHolder)
        ]

    "Created: / 12-12-2006 / 09:16:51 / janfrog"
    "Modified: / 10-01-2010 / 10:25:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modelHolder
    "return/create the 'modelHolder' value holder (automatically generated)"

    modelHolder isNil ifTrue:[
        modelHolder := ValueHolder new.
    ].
    ^ modelHolder
!

modelHolder:aValueModel
    "set the 'modelHolder' value holder (automatically generated)"

    modelHolder := aValueModel.
! !

!DOM3Inspector class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOM3Inspector.st,v 1.1 2006-12-12 13:54:55 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
