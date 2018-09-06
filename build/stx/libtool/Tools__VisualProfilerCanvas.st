"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

NavigatorModel subclass:#VisualProfilerCanvas
	instanceVariableNames:'profilerStatistics selectedMethods packageFilter
		perspectiveSpecHolder callTreeHolder selectedCallTreeItemHolder
		methodList'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New-Profiler'
!

HierarchicalItem subclass:#CallTreeItem
	instanceVariableNames:'subjects'
	classVariableNames:''
	poolDictionaries:''
	privateIn:VisualProfilerCanvas
!

!VisualProfilerCanvas class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

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

!VisualProfilerCanvas class methodsFor:'interface specs'!

callTreeSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::VisualProfilerCanvas andSelector:#callTreeSpec
     Tools::VisualProfilerCanvas new openInterface:#callTreeSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: callTreeSpec
        window: 
       (WindowSpec
          label: 'Visual Profiler - Call Tree'
          name: 'Visual Profiler - Call Tree'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (HierarchicalListViewSpec
              name: 'CallTree'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: selectedCallTreeItemHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: callTreeHolder
              useIndex: false
              highlightMode: line
              useDefaultIcons: false
            )
           )
         
        )
      )

    "Modified: / 10-10-2007 / 08:51:10 / janfrog"
!

methodListSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::VisualProfilerCanvas andSelector:#methodListSpec
     Tools::VisualProfilerCanvas new openInterface:#methodListSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: methodListSpec
        window: 
       (WindowSpec
          label: 'Method list'
          name: 'Method list'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (DataSetSpec
              name: 'MethodList'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: selectedCallTreeItemHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              dataList: methodListAspect
              useIndex: false
              columnHolder: methodListColumns
            )
           )
         
        )
      )

    "Modified: / 01-12-2007 / 23:57:41 / janfrog"
!

sidebarInfoSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::VisualProfilerCanvas andSelector:#sidebarInfoSpec
     Tools::VisualProfilerCanvas new openInterface:#sidebarInfoSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: sidebarInfoSpec
        window: 
       (WindowSpec
          label: 'General Info'
          name: 'General Info'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'Panel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: topFit
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (TransparentBoxSpec
                    name: 'StartTimeBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Start time:'
                          name: 'StartTimestampLabel'
                          layout: (LayoutFrame 0 0 0 0 0 1 0 0.5)
                          translateLabel: true
                          adjust: left
                        )
                       (LabelSpec
                          name: 'StartTimestamp'
                          layout: (LayoutFrame 30 0 0 0.5 0 1 0 1)
                          translateLabel: true
                          labelChannel: startTimestampAspect
                          adjust: left
                        )
                       )
                     
                    )
                    extent: (Point 300 50)
                  )
                 (TransparentBoxSpec
                    name: 'ExecutionTimeBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Execution time:'
                          name: 'ExecutionTimeLabel'
                          layout: (LayoutFrame 0 0 0 0 0 1 0 0.5)
                          translateLabel: true
                          adjust: left
                        )
                       (LabelSpec
                          label: 'Label'
                          name: 'ExecutionTime'
                          layout: (LayoutFrame 30 0 0 0.5 0 1 0 1)
                          translateLabel: true
                          labelChannel: executionTimeAspect
                          adjust: left
                        )
                       )
                     
                    )
                    extent: (Point 300 50)
                  )
                 (TransparentBoxSpec
                    name: 'NotesBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Notes:'
                          name: 'NotesLabel'
                          layout: (LayoutFrame 0 0 0 0 0 1 25 0)
                          translateLabel: true
                          adjust: left
                        )
                       (TextEditorSpec
                          name: 'Notes'
                          layout: (LayoutFrame 30 0 25 0 0 1 0 1)
                          model: notesAspect
                          hasHorizontalScrollBar: true
                          hasVerticalScrollBar: true
                        )
                       )
                     
                    )
                    extent: (Point 300 194)
                  )
                 )
               
              )
            )
           )
         
        )
      )

    "Modified: / 24-11-2007 / 09:27:08 / janfrog"
!

sidebarPackageFilterSpec
    <resource: #canvas>
    "This resource specification was automatically generated
     by the UIPainter of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."
    "
     UIPainter new openOnClass:Tools::VisualProfilerCanvas andSelector:#packageFilterSpec
     Tools::VisualProfilerCanvas new openInterface:#packageFilterSpec"
    
    ^ #( #FullSpec
  #name: #sidebarPackageFilterSpec
  #window:
 #(WindowSpec label: 'Package Filter' name: 'Package Filter' min: (Point 10 10) bounds: (Rectangle 0 0 300 300))
  #component:
 #(SpecCollection collection: ((SubCanvasSpec name: 'PackageFilterCanvas' layout: (LayoutFrame 0 0 0 0 0 1 0 1) hasHorizontalScrollBar: false hasVerticalScrollBar: false majorKey: #'Tools::HierarchicalPackageFilterList' minorKey: windowSpec subAspectHolders: (Array (SubChannelInfoSpec subAspect: packageFilter aspect: packageFilter)) createNewApplication: true createNewBuilder: true))) )

    "Modified: / 24-11-2007 / 08:34:31 / janfrog"
!

sidebarSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::VisualProfilerCanvas andSelector:#sidebarSpec
     Tools::VisualProfilerCanvas new openInterface:#sidebarSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: sidebarSpec
        window: 
       (WindowSpec
          label: 'Profiler Sidebar'
          name: 'Profiler Sidebar'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (MenuPanelSpec
              name: 'ToolBar'
              layout: (LayoutFrame 0 0 0 0 0 1 30 0)
              menu: sidebarMenu
              textDefault: true
            )
           (NoteBookViewSpec
              name: 'SidebarNotebook'
              layout: (LayoutFrame 0 0 30 0 0 1 0 1)
              menu: sidebarNotebookTabList
              direction: left
              fitLastRow: false
            )
           )
         
        )
      )

    "Modified: / 24-11-2007 / 09:13:40 / janfrog"
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::VisualProfilerCanvas andSelector:#windowSpec
     Tools::VisualProfilerCanvas new openInterface:#windowSpec
     Tools::VisualProfilerCanvas open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Visual Profiler'
          name: 'Visual Profiler'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 714 332)
        )
        component: 
       (SpecCollection
          collection: (
           (VariableHorizontalPanelSpec
              name: 'SidebarAndPerspectivePanel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              showHandle: true
              snapMode: both
              component: 
             (SpecCollection
                collection: (
                 (UISubSpecification
                    name: 'SidebarSpec'
                    minorKey: sidebarSpec
                  )
                 (NoteBookViewSpec
                    name: 'PerspectiveNoteBook'
                    menu: perspectiveNotebookTabList
                    direction: bottom
                    fitLastRow: false
                  )
                 )
               
              )
              handles: (Any 0.3 1.0)
            )
           )
         
        )
      )

    "Modified: / 24-11-2007 / 09:07:56 / janfrog"
! !

!VisualProfilerCanvas class methodsFor:'list specs'!

perspectiveNotebookTabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#perspectiveNotebookTabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'Call tree'
          createNewBuilder: false
          minorKey: callTreeSpec
        )
       (TabItem
          label: 'Method list'
          createNewBuilder: false
          minorKey: methodListSpec
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]

    "Modified: / 02-12-2007 / 00:03:42 / janfrog"
!

sidebarNotebookTabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#sidebarNotebookTabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'Statistics'
          minorKey: sidebarInfoSpec
        )
       (TabItem
          label: 'Packages'
          createNewBuilder: false
          minorKey: sidebarPackageFilterSpec
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]

    "Modified: / 24-11-2007 / 08:45:36 / janfrog"
! !

!VisualProfilerCanvas class methodsFor:'menu specs'!

sidebarMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::VisualProfilerCanvas andSelector:#sidebarMenu
     (Menu new fromLiteralArrayEncoding:(Tools::VisualProfilerCanvas sidebarMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Save Profile Data'
            itemValue: saveProfilerAction
            isButton: true
            labelImage: (ResourceRetriever ToolbarIconLibrary saveToFileIcon)
          )
         )
        nil
        nil
      )
! !

!VisualProfilerCanvas class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        environmentHolder
        #packageFilter
        #profilerStatistics
        #selectedMethods
      ).

    "Modified: / 01-12-2007 / 23:57:41 / janfrog"
    "Modified: / 24-02-2014 / 10:37:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VisualProfilerCanvas class methodsFor:'tableColumns specs'!

methodListColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:Tools::VisualProfilerCanvas andSelector:#methodListColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         labelButtonType: Button
         rendererType: rowSelector
         showRowSeparator: false
         showSelectionHighLighted: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Tally'
         labelButtonType: Button
         type: number
         model: tally
         canSelect: false
         showRowSeparator: false
         showSelectionHighLighted: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Method'
         labelButtonType: Button
         model: methodLabel
         canSelect: false
         showRowSeparator: false
         showSelectionHighLighted: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Package'
         labelButtonType: Button
         model: packageLabel
         canSelect: false
         showRowSeparator: false
         showSelectionHighLighted: false
         showColSeparator: false
       )
      )

    "Modified: / 01-12-2007 / 23:56:15 / janfrog"
! !

!VisualProfilerCanvas methodsFor:'aspects'!

callTreeHolder
    callTreeHolder isNil ifTrue:[
        callTreeHolder := HierarchicalList new.
        callTreeHolder application: self.
    ].
    ^ callTreeHolder.

    "Created: / 10-10-2007 / 08:34:26 / janfrog"
    "Modified: / 10-10-2007 / 12:48:20 / janfrog"
!

executionTimeAspect

    ^(PluggableAdaptor on: profilerStatistics)
        getBlock:[:model|
            model value
                ifNil:['N/A']
                ifNotNil:[model value computationTime printString 
                            , 'ms'
                                ,' (', (TimeDuration new setMilliseconds:model value computationTime) printString , ')']]
        putBlock:[:ign1 :ign2|self shouldNeverBeReached]
        updateBlock:[:ign1 :ign2 :ign3|true]

    "Created: / 24-11-2007 / 08:44:49 / janfrog"
!

methodListAspect

    methodList isNil ifTrue:[methodList := List new].
    ^methodList

    "Created: / 01-12-2007 / 23:38:16 / janfrog"
    "Modified: / 18-11-2011 / 15:01:52 / cg"
!

notesAspect

    ^(AspectAdaptor forAspect:#notes)
        subjectChannel: self profilerStatistics

    "Created: / 24-11-2007 / 09:27:47 / janfrog"
!

packageFilter
    "return/create the 'packageFilter' value holder (automatically generated)"

    packageFilter isNil ifTrue:[
        packageFilter := ValueHolder new.
    ].
    ^ packageFilter

    "Created: / 09-10-2007 / 21:27:32 / janfrog"
!

packageFilter:something
    "set the 'packageFilter' value holder (automatically generated)"

    packageFilter ifNotNil:[packageFilter removeDependent: self].
    packageFilter := something.
    packageFilter ifNotNil:[packageFilter addDependent: self].

    "Created: / 09-10-2007 / 21:27:32 / janfrog"
    "Modified: / 10-10-2007 / 12:47:08 / janfrog"
!

perspectiveNotebookTabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#perspectiveNotebookTabList) isNil ifTrue:[
        builder aspectAt:#perspectiveNotebookTabList put:(list := self class perspectiveNotebookTabList).
    ].
    ^ list

    "Created: / 10-10-2007 / 10:10:07 / janfrog"
!

perspectiveSpecHolder
    perspectiveSpecHolder isNil ifTrue:[
        perspectiveSpecHolder := #callTreeSpec asValue.
    ].
    ^ perspectiveSpecHolder.

    "Created: / 10-10-2007 / 08:31:35 / janfrog"
!

profilerStatistics
    "return/create the 'profilerStatistics' value holder (automatically generated)"

    profilerStatistics isNil ifTrue:[
        profilerStatistics := ValueHolder new.
    ].
    ^ profilerStatistics

    "Created: / 09-10-2007 / 21:53:38 / janfrog"
!

profilerStatistics:something
    "set the 'profilerStatistics' value holder (automatically generated)"

    profilerStatistics ifNotNil:[profilerStatistics removeDependent: self].
    profilerStatistics := something.
    profilerStatistics ifNotNil:[profilerStatistics addDependent: self].

    "Created: / 09-10-2007 / 21:53:38 / janfrog"
    "Modified: / 10-10-2007 / 08:46:46 / janfrog"
!

selectedCallTreeItemHolder
    selectedCallTreeItemHolder isNil ifTrue:[
        selectedCallTreeItemHolder := ValueHolder new.
        selectedCallTreeItemHolder onChangeSend:#selectedCallTreeItemChanged to:self.
    ].
    ^ selectedCallTreeItemHolder.

    "Created: / 10-10-2007 / 08:51:34 / janfrog"
!

selectedMethods
    "return/create the 'selectedMethods' value holder (automatically generated)"

    selectedMethods isNil ifTrue:[
        selectedMethods := ValueHolder new.
    ].
    ^ selectedMethods

    "Created: / 09-10-2007 / 21:18:18 / janfrog"
!

selectedMethods:something
    "set the 'selectedMethods' value holder (automatically generated)"

    selectedMethods := something.

    "Created: / 09-10-2007 / 21:18:18 / janfrog"
!

sidebarNotebookTabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#sidebarNotebookTabList) isNil ifTrue:[
        builder aspectAt:#sidebarNotebookTabList put:(list := self class sidebarNotebookTabList).
    ].
    ^ list

    "Created: / 10-10-2007 / 10:10:35 / janfrog"
!

startTimestampAspect

    ^(PluggableAdaptor on: profilerStatistics)
        getBlock:[:model|
            model value
                ifNil:['N/A']
                ifNotNil:[model value startTimestamp printString]]
        putBlock:[:ign1 :ign2|self shouldNeverBeReached]
        updateBlock:[:ign1 :ign2 :ign3|true]

    "Created: / 24-11-2007 / 08:57:58 / janfrog"
! !

!VisualProfilerCanvas methodsFor:'change & update'!

methodsSelectionChanged

    self topApplication == self
        ifFalse:[self topApplication methodsSelectionChanged]

    "Created: / 09-10-2007 / 21:33:50 / janfrog"
!

selectedCallTreeItemChanged
    |selectedCallTreeItem|

    (selectedCallTreeItem := self selectedCallTreeItemHolder value) isNil ifTrue:[^self].
    self switchToMethod: selectedCallTreeItem method

    "Created: / 10-10-2007 / 08:52:33 / janfrog"
    "Modified: / 18-11-2011 / 15:02:20 / cg"
!

update: aspect with: value from: sender

    sender == self profilerStatistics 
        ifTrue:[^self updateCallTreeRoot; updateMethodList].

    sender == self packageFilter 
        ifTrue:[self updateCallTree; updateMethodList]

    "Created: / 10-10-2007 / 08:46:59 / janfrog"
    "Modified: / 01-12-2007 / 23:52:07 / janfrog"
!

updateCallTree

    self callTreeHolder root updateChildren

    "Created: / 10-10-2007 / 12:57:36 / janfrog"
!

updateCallTreeRoot

    |  callTree callTreeRootItem |

    callTree := self callTreeHolder.
    profilerStatistics value isNil ifTrue:[^callTree root: nil].
    callTreeRootItem := CallTreeItem 
                            subject: profilerStatistics value tree
                            parent: callTree.
    callTree root: callTreeRootItem.
    callTree showRoot: true.

    "Created: / 10-10-2007 / 12:59:07 / janfrog"
    "Modified (format): / 18-11-2011 / 15:02:32 / cg"
!

updateMethodList
    | items |

    self methodListAspect removeAll.
    self profilerStatistics value isNil ifTrue:[^self].
    items := ProfilerInfoBuilder::MethodList new 
                packages: self packageFilter value;
                build: self profilerStatistics value tree;
                items.

    self methodListAspect addAll: items

    "Created: / 01-12-2007 / 23:39:15 / janfrog"
    "Modified: / 18-11-2011 / 15:02:49 / cg"
! !

!VisualProfilerCanvas methodsFor:'hooks'!

commonPostBuild

    super commonPostBuild.
    self updateCallTreeRoot.
    self updateMethodList.

    "Created: / 09-10-2007 / 20:05:18 / janfrog"
    "Modified: / 01-12-2007 / 23:39:34 / janfrog"
!

postBuildEditModeInfoLabel: view

    "Created: / 09-10-2007 / 21:06:35 / janfrog"
!

postBuildEditorNoteBook: view

    "Created: / 09-10-2007 / 21:05:39 / janfrog"
! !

!VisualProfilerCanvas methodsFor:'user actions'!

switchToMethod: aMethod

    self selectedMethods value:(Array with: aMethod).
    self methodsSelectionChanged

    "Created: / 09-10-2007 / 21:36:35 / janfrog"
! !

!VisualProfilerCanvas methodsFor:'user actions-profiler'!

profilerTestAction

    self switchToMethod:(Object >> #yourself).

    "Created: / 09-10-2007 / 21:07:53 / janfrog"
!

saveProfilerAction
    | file profiler |

    file := Dialog requestFileName:'Select file' pattern:'*.profiler.boss'.
    file isEmptyOrNil ifTrue:[^self].
    profiler := self profilerStatistics value.
    profiler storeStatisticsOn: file asFilename writeStream

    "Created: / 24-11-2007 / 09:16:38 / janfrog"
    "Modified: / 04-08-2011 / 19:06:07 / cg"
! !

!VisualProfilerCanvas::CallTreeItem class methodsFor:'documentation'!

version
    ^'$Header: /cvs/stx/stx/libtool/Tools__VisualProfilerCanvas.st,v 1.10 2014-11-10 22:34:53 cg Exp $'
! !

!VisualProfilerCanvas::CallTreeItem class methodsFor:'instance creation'!

subject: subject parent: parent

    ^self new
        subject: subject;
        parent: parent;
        yourself

    "Created: / 10-10-2007 / 08:35:55 / janfrog"
! !

!VisualProfilerCanvas::CallTreeItem methodsFor:'accessing'!

children

    children isNil ifTrue:[children := self createChildren].
    ^children

    "Created: / 10-10-2007 / 08:38:28 / janfrog"
    "Modified: / 10-10-2007 / 13:24:06 / janfrog"
    "Modified: / 18-11-2011 / 15:03:00 / cg"
!

createChildren
    |childrenTmp childrenStream|

    self subject isNil ifTrue:[ ^ children := #() ].
    childrenStream := (OrderedCollection new:self subject called size) 
                writeStream.
    self createChildrenOn:childrenStream.
    childrenTmp := childrenStream contents.
    childrenTmp := self mergeChildren: childrenTmp.
    childrenTmp do:[:child | child parent:self].
    ^ childrenTmp

    "Created: / 10-10-2007 / 13:17:04 / janfrog"
    "Modified: / 24-11-2007 / 09:43:30 / janfrog"
    "Modified: / 18-11-2011 / 15:03:03 / cg"
!

createChildrenOn:aStream 
    self directChildren do:[:child | 
        child isFiltered ifTrue:[
            child createChildrenOn:aStream
        ] ifFalse:[
            aStream nextPut:child
        ]
    ]

    "Created: / 10-10-2007 / 13:05:52 / janfrog"
!

directChildren
    |called|

    (called := self subject called) isNil ifTrue:[ ^ #() ].
    ^ called 
        collect:[:childSubject | self class subject:childSubject parent:self ]

    "Created: / 10-10-2007 / 13:07:24 / janfrog"
    "Modified: / 24-11-2007 / 09:18:56 / janfrog"
    "Modified: / 18-11-2011 / 15:03:31 / cg"
!

label
    ^ self totalTally printString , '% in ' 
        , (self subject isBlock ifTrue:[ '[] in ' ] ifFalse:[ '' ]) 
            , (self subject selector ? '<no selector>') , ' ' 
        , ('[' , (self subject methodClass 
                        ifNil:[ 'nil class' ]
                        ifNotNil:[ self subject methodClass name ]) 
                , ']') allBold 
            , ' [' , self methodPackage asString allItalic 
        , ']'

    "Created: / 10-10-2007 / 08:40:44 / janfrog"
    "Modified: / 24-11-2007 / 09:42:16 / janfrog"
    "Modified: / 07-11-2008 / 08:40:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

method
    |methodClass|

    (methodClass := self subject methodClass) isNil ifTrue:[ ^ nil ].
    ^ methodClass >> self subject selector asSymbol

    "Created: / 10-10-2007 / 08:49:58 / janfrog"
    "Modified: / 24-11-2007 / 09:18:56 / janfrog"
    "Modified: / 18-11-2011 / 15:03:56 / cg"
!

methodPackage
    | mth |

    mth := self method.
    mth isNil ifTrue:[^#__NoProject__].
    ^ mth package

    "Created: / 10-10-2007 / 13:03:21 / janfrog"
    "Modified (format): / 18-11-2011 / 15:04:15 / cg"
!

subject
    ^ subjects anyOne

    "Created: / 10-10-2007 / 08:35:21 / janfrog"
    "Modified: / 24-11-2007 / 09:41:22 / janfrog"
!

subject:anObject
    subjects := Array with: anObject

    "Created: / 10-10-2007 / 08:35:21 / janfrog"
    "Modified: / 24-11-2007 / 09:41:33 / janfrog"
!

subjects
    ^ subjects

    "Created: / 24-11-2007 / 09:41:14 / janfrog"
!

subjects:something
    subjects := something.

    "Created: / 24-11-2007 / 09:41:14 / janfrog"
!

totalTally

    ^subjects inject:0 into:[:tally :subject| tally + subject totalTally]

    "Created: / 24-11-2007 / 09:43:01 / janfrog"
! !

!VisualProfilerCanvas::CallTreeItem methodsFor:'change & update'!

updateChildren

    self removeAll.
    self addAll:self createChildren

    "Created: / 10-10-2007 / 13:02:13 / janfrog"
! !

!VisualProfilerCanvas::CallTreeItem methodsFor:'comparing'!

shouldBeMergedWith:anotherCallTreeItem 
    ^ self subject methodClass = anotherCallTreeItem subject methodClass 
        and:[
            self subject selector = anotherCallTreeItem subject selector 
                and:[ self subject isBlock not ]
        ]

    "Created: / 24-11-2007 / 09:50:34 / janfrog"
! !

!VisualProfilerCanvas::CallTreeItem methodsFor:'private'!

mergeChildren: rawChildren

    |mergedChildren|

    mergedChildren := OrderedCollection new.
    [rawChildren isEmpty] whileFalse:[
        | childToMerge childrenToMerge |

        childToMerge := mergedChildren add:(rawChildren removeFirst).
        childrenToMerge := rawChildren select:[:e|e shouldBeMergedWith:childToMerge] as: OrderedCollection.
        rawChildren removeAll: childrenToMerge.
        childrenToMerge do:[:e|childToMerge subjects addAll:e subjects].
    ].
    ^mergedChildren

    "Created: / 24-11-2007 / 09:20:07 / janfrog"
    "Modified: / 21-05-2014 / 15:49:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VisualProfilerCanvas::CallTreeItem methodsFor:'testing'!

isFiltered

    | isFiltered |
    isFiltered := false.
    self application packageFilter value 
        ifNotNil:[isFiltered := (self application packageFilter value includes: self methodPackage) not].
    ^isFiltered

    "Created: / 10-10-2007 / 13:09:46 / janfrog"
! !

!VisualProfilerCanvas class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__VisualProfilerCanvas.st,v 1.10 2014-11-10 22:34:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__VisualProfilerCanvas.st,v 1.10 2014-11-10 22:34:53 cg Exp $'
!

version_SVN
    ^ '$Id: Tools__VisualProfilerCanvas.st,v 1.10 2014-11-10 22:34:53 cg Exp $'
! !

