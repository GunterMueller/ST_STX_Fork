"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractListApplication subclass:#VDBAbstractTreeApplication
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Abstract'
!

!VDBAbstractTreeApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBAbstractTreeApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBAbstractTreeApplication andSelector:#windowSpec
     VDBAbstractTreeApplication new openInterface:#windowSpec
     VDBAbstractTreeApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       uuid: '07a39290-3c2f-11e8-93ae-0021ccd5e3d3'
       window: 
      (WindowSpec
         label: 'Execution Stack'
         name: 'Execution Stack'
         uuid: '07a39291-3c2f-11e8-93ae-0021ccd5e3d3'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (HierarchicalListViewSpec
             name: 'Stack'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             uuid: '07a39292-3c2f-11e8-93ae-0021ccd5e3d3'
             model: internalSelectionHolder
             menu: contextMenu
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             listModel: internalListHolder
             useIndex: false
             highlightMode: line
             doubleClickSelector: doDoubleClick
             selectConditionSelector: internalCanSelect:
             showLines: false
             useDefaultIcons: false
             showRoot: false
             postBuildCallback: postBuildInternalListView:
           )
          )
        
       )
     )

    "Modified: / 09-04-2018 / 20:52:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractTreeApplication class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #debuggerHolder
      ).

! !

!VDBAbstractTreeApplication class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == VDBAbstractTreeApplication.
! !

!VDBAbstractTreeApplication methodsFor:'aspects-private'!

internalListHolder
    "return/create the 'listHolder' value holder (automatically generated)"

    internalListHolder isNil ifTrue:[
        internalListHolder := HierarchicalList new.
        internalListHolder application: self.
        internalListHolder showRoot: false.
        internalListHolder root: HierarchicalItem new.
    ].
    ^ internalListHolder

    "Created: / 20-09-2014 / 23:03:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2017 / 23:33:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractTreeApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

