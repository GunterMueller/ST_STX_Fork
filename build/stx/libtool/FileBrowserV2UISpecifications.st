"
 COPYRIGHT (c) 2002 by eXept Software AG 
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

Object subclass:#FileBrowserV2UISpecifications
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

VariablePanelSpec subclass:#PanelSpec
	instanceVariableNames:'whichView orientation visibility'
	classVariableNames:''
	poolDictionaries:''
	privateIn:FileBrowserV2UISpecifications
!

!FileBrowserV2UISpecifications class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG 
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
    copy of the Panel from CBrowser , if a better HorizontalPanel and VerticalPanel is available
    the new version can be used here
"
! !

!FileBrowserV2UISpecifications class methodsFor:'classAccess'!

panelSpecClass

    ^ PanelSpec
! !

!FileBrowserV2UISpecifications class methodsFor:'interface specs'!

listSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileBrowserV2UISpecifications andSelector:#listSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: listSpec
        window: 
       (WindowSpec
          label: 'Graphs'
          name: 'Graphs'
          min: (Point 10 10)
          bounds: (Rectangle 14 46 449 234)
        )
        component: 
       (SpecCollection
          collection: (
           (HierarchicalListViewSpec
              name: 'HierarchicalListModel'
              layout: (LayoutFrame 225 0 7 0 398 0 79 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              highlightMode: line
            )
           (LabelSpec
              label: 'HierarchicalList'
              name: 'HierarchicalListLabel'
              layout: (Point 252 15)
              style: (FontDescription helvetica medium roman 10)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (SelectionInListModelViewSpec
              name: 'SelectionInListModel'
              layout: (LayoutFrame 6 0 7 0 179 0 79 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              highlightMode: line
            )
           (LabelSpec
              label: 'SelectionInList'
              name: 'SelectionInListLabel'
              layout: (Point 33 15)
              style: (FontDescription helvetica medium roman 10)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           (ListModelViewSpec
              name: 'ListModel'
              layout: (LayoutFrame 6 0 100 0 179 0 172 0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
            )
           (LabelSpec
              label: 'ListModel'
              name: 'ListModelLabel'
              layout: (Point 33 109)
              style: (FontDescription helvetica medium roman 10)
              resizeForLabel: true
              adjust: left
              canUIDrag: false
            )
           )
         
        )
      )
!

othersSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileBrowserV2UISpecifications andSelector:#othersSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #othersSpec
        #window: 
       #(#WindowSpec
          #label: 'Panel Specs'
          #name: 'Panel Specs'
          #layout: #(#LayoutFrame 119 0 66 0 536 0 215 0)
          #level: 0
          #min: #(#Point 10 10)
          #bounds: #(#Rectangle 119 66 537 216)
          #usePreferredExtent: false
          #returnIsOKInDialog: true
          #escapeIsCancelInDialog: true
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#LabelSpec
              #label: 'Wrapper'
              #name: 'WrapperLabel'
              #layout: #(#Point 9 6)
              #style: #(#FontDescription #helvetica #medium #roman 10)
              #resizeForLabel: true
              #adjust: #left
              #canUIDrag: false
            )
"/           #(#'ViewSpec'
"/              #name: 'Wrapper'
"/              #layout: #(#LayoutFrame 6 0 26 0 179 0 98 0)
"/            )
           #(#LabelSpec
              #label: 'Panel'
              #name: 'PanelLabel'
              #layout: #(#Point 201 6)
              #style: #(#FontDescription #helvetica #medium #roman 10)
              #resizeForLabel: true
              #adjust: #left
              #canUIDrag: false
            )

           #(#'FileBrowserV2UISpecifications::PanelSpec'
              #name: 'Panel'
              #layout: #(#LayoutFrame 198 0 26 0 376 0 98 0)
              #level: 0
              #whichView: #first
              #orientation: #vertical
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#LabelSpec
                    #label: 'A'
                    #name: 'Label1'
                    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 0.5 0 1.0)
                    #level: 2
                    #canUIDrag: false
                  )
                 #(#LabelSpec
                    #label: 'B'
                    #name: 'Label2'
                    #layout: #(#LayoutFrame 0 0.5 0 0.0 0 1.0 0 1.0)
                    #level: 2
                    #canUIDrag: false
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!FileBrowserV2UISpecifications class methodsFor:'setup'!

setup
"
FileBrowserV2UISpecifications setup.

"
    |listSpec othersSpec|

    UISelectionPanel galleryClass removeUserSpecWithLabel:'Graphs'.
    UISelectionPanel galleryClass removeUserSpecWithLabel:'Clocks etc.'.
    UISelectionPanel galleryClass removeUserSpecWithLabel:'Business Graphics'.
    UISelectionPanel galleryClass removeUserSpecWithLabel:'C-Lists'.
    UISelectionPanel galleryClass removeUserSpecWithLabel:'C-Others'.

    listSpec := ValueHolder new.
    listSpec value:(self listSpec).

    UISelectionPanel galleryClass addUserSpecHolder:listSpec
                label:'C-Lists'.

    othersSpec := ValueHolder new.
    othersSpec value:(self othersSpec).

    UISelectionPanel galleryClass addUserSpecHolder:othersSpec
                label:'C-Others'.
! !

!FileBrowserV2UISpecifications::PanelSpec class methodsFor:'interface specs'!

detailsEditSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FileBrowserV2UISpecifications::PanelSpec andSelector:#detailsEditSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: detailsEditSpec
       window: 
      (WindowSpec
         label: 'Panel Detail Spec'
         name: 'Panel Detail Spec'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 438 374)
       )
       component: 
      (SpecCollection
         collection: (
          (UISubSpecification
             name: 'SubSpecification1'
             layout: (LayoutFrame 1 0 0 0.0 0 1.0 183 0)
             majorKey: ViewSpec
             minorKey: detailsEditSpec
           )
          (FramedBoxSpec
             label: 'Handles'
             name: 'FramedBox2'
             layout: (LayoutFrame 0 0.0 169 0 0 1.0 284 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Bar Width:'
                   name: 'BarWidthLabel'
                   layout: (AlignmentOrigin 100 0 13 0 1 0.5)
                   activeHelpKey: barWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'BarWidthField'
                   layout: (LayoutFrame 100 0 0 0 140 0 22 0)
                   activeHelpKey: barWidth
                   tabable: true
                   model: barWidth
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Bar Level:'
                   name: 'BarLevelLabel'
                   layout: (AlignmentOrigin 244 0 13 0 1 0.5)
                   activeHelpKey: barLevel
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (InputFieldSpec
                   name: 'BarLevelField'
                   layout: (LayoutFrame 246 0 0 0 296 0 22 0)
                   activeHelpKey: barLevel
                   tabable: true
                   model: barLevel
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                (LabelSpec
                   label: 'Show:'
                   name: 'ShowHandlesLabel'
                   layout: (LayoutFrame 0 0 28 0 100 0 47 0)
                   activeHelpKey: showHandle
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'Default'
                   name: 'ShowHandlesPopUpList'
                   layout: (LayoutFrame 100 0 28 0 225 0 47 0)
                   activeHelpKey: showHandle
                   translateLabel: true
                   resizeForLabel: true
                   tabable: true
                   model: showHandleIdx
                   menu: showHandleList
                   useIndex: true
                 )
                (LabelSpec
                   label: 'Position:'
                   name: 'HandlePositionLabel'
                   layout: (AlignmentOrigin 293 0 38 0 1 0.5)
                   activeHelpKey: handlePosition
                   translateLabel: true
                   resizeForLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'Default'
                   name: 'HandlePositionPopUpList'
                   layout: (LayoutFrame 298 0 28 0 0 1 47 0)
                   activeHelpKey: handlePosition
                   translateLabel: true
                   resizeForLabel: true
                   tabable: true
                   model: handlePositionIdx
                   menu: handlePositionList
                   useIndex: true
                 )
                (LabelSpec
                   label: 'Snap Mode:'
                   name: 'SnapLabel'
                   layout: (LayoutFrame 0 0 54 0 100 0 76 0)
                   activeHelpKey: snapMode
                   translateLabel: true
                   adjust: right
                 )
                (PopUpListSpec
                   label: 'none'
                   name: 'SnapModePopUpList'
                   layout: (LayoutFrame 100 0 54 0 225 0 75 0)
                   activeHelpKey: snapMode
                   translateLabel: true
                   adjust: center
                   tabable: true
                   model: snapModeIdx
                   menu: snapModeList
                   useIndex: true
                 )
                )
              
             )
           )
          (FramedBoxSpec
             label: 'Visibility'
             name: 'FramedBox1'
             layout: (LayoutFrame 0 0.0 287 0 0 1.0 376 0)
             labelPosition: topLeft
             translateLabel: true
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Orientation:'
                   name: 'orientation'
                   layout: (AlignmentOrigin 100 0 13 0 1 0.5)
                   activeHelpKey: borderWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (ComboListSpec
                   name: 'orientationList'
                   layout: (LayoutFrame 100 0 2 0 194 0 24 0)
                   model: orientation
                   comboList: orientationList
                   useIndex: false
                 )
                (LabelSpec
                   label: 'which:'
                   name: 'visibilityOf'
                   layout: (AlignmentOrigin 248 0 13 0 1 0.5)
                   activeHelpKey: borderWidth
                   translateLabel: true
                   resizeForLabel: true
                   adjust: left
                 )
                (ComboListSpec
                   name: 'whichViewList'
                   layout: (LayoutFrame 247 0 2 0 0 1.0 24 0)
                   model: whichView
                   comboList: whichViewList
                   useIndex: false
                 )
                (LabelSpec
                   label: 'Visibility:'
                   name: 'visibilityLabel'
                   layout: (AlignmentOrigin 100 0 40 0 1 0.5)
                   translateLabel: true
                   resizeForLabel: true
                 )
                (InputFieldSpec
                   name: 'visibility'
                   layout: (LayoutFrame 100 0 29 0 0 1.0 51 0)
                   activeHelpKey: canvas
                   model: visibility
                   group: inputGroup
                   acceptChannel: acceptChannel
                   modifiedChannel: modifiedChannel
                   acceptOnPointerLeave: false
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!FileBrowserV2UISpecifications::PanelSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self adaptApects:#( visibility ) to:env for:anInstance channel:aChannel converter:#symbolOrNil.
    self adaptApects:#( whichView orientation ) to:env for:anInstance channel:aChannel.

    env at:#whichViewList put:#( #first #last ) asValue.
    env at:#orientationList put:#( #horizontal #vertical ) asValue.



! !

!FileBrowserV2UISpecifications::PanelSpec methodsFor:'accessing'!

orientation
    "return the value of the instance variable 'orientation' (automatically generated)"

    ^ orientation ? #vertical
!

orientation:something
    "set the value of the instance variable 'orientation' (automatically generated)"
    something notNil ifTrue:[
	orientation := something asSymbol
    ] ifFalse:[
	orientation := something.
    ]
!

visibility
    "return the value of the instance variable 'orientation' (automatically generated)"

    ^ visibility
!

visibility:something
    "set the value of the instance variable 'visibility' (automatically generated)"

    visibility := something.
!

whichView
    "return the value of the instance variable 'whichView' (automatically generated)"

    ^ whichView ? #first
!

whichView:something
    "set the value of the instance variable 'whichView' (automatically generated)"

    whichView := something.
! !

!FileBrowserV2UISpecifications::PanelSpec methodsFor:'building'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    visibility notNil ifTrue:[more add:visibility].
    ^ more
!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView
    "
    super setAttributesIn:aView with:aBuilder.

    aView        whichView:(self whichView).
    aView      orientation:(self orientation).
    aView visibilityHolder:(self getBindingIn:aBuilder binding:visibility).



! !

!FileBrowserV2UISpecifications::PanelSpec methodsFor:'computation'!

setupInitialLayoutFor:aView
    |superView|

    aView geometryLayout:nil.

    (    aView relativeOrigin isNil 
     or:[aView relativeExtent isNil 
	 and:[aView relativeCorner isNil]]
    ) ifTrue:[
	superView := aView superView.

	self isVertical ifTrue:[
	    aView corner:0@0.
	    aView origin:0.0@0.0.
	    aView extent:1.0@0.3.
	    superView notNil ifTrue:[
		superView setupSubviews.
		superView resizeSubviews.
	    ]
	] ifFalse:[
	    aView origin:0.0@0.0.
	    aView extent:0.3@1.0.
	    superView notNil ifTrue:[
		superView setupSubviews
	    ]
	]
    ]
! !

!FileBrowserV2UISpecifications::PanelSpec methodsFor:'converting'!

skippedInLiteralEncoding
    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.
    visibility isNil ifTrue:[l add:#visibility].
    ^ l
! !

!FileBrowserV2UISpecifications::PanelSpec methodsFor:'queries'!

isVertical
    ^ self orientation == #vertical

!

viewClass
    "return the corresponding view class of the spec"

    ^ FileBrowserV2PanelView
! !

!FileBrowserV2UISpecifications class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: FileBrowserV2UISpecifications.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

