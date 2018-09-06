"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

AbstractViewer subclass:#Examples2Viewer
	instanceVariableNames:'native1 cairo1 native2 cairo2'
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Examples'
!


!Examples2Viewer class methodsFor:'interface specs'!

previewSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Cairo::Examples2Viewer andSelector:#previewSpec
     Cairo::Examples2Viewer new openInterface:#previewSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: previewSpec
       window: 
      (WindowSpec
         label: 'Preview'
         name: 'Preview'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (NonScrollableArbitraryComponentSpec
             name: 'Native1'
             layout: (LayoutFrame 0 0 0 0 0 0.5 0 0.5)
             component: PluggableView
             postBuildCallback: postBuildNative1:         
           )
          (NonScrollableArbitraryComponentSpec
             name: 'Cairo1'
             layout: (LayoutFrame 0 0.5 0 0 0 1 0 0.5)
                          component: PluggableView
             postBuildCallback: postBuildCairo1:         

           )
          (NonScrollableArbitraryComponentSpec
             name: 'Cairo2'
             layout: (LayoutFrame 0 0 0 0.5 0 0.5 0 1)
                          component: PluggableView
             postBuildCallback: postBuildCairo2:         

           )
          (NonScrollableArbitraryComponentSpec
             name: 'Native2'
             layout: (LayoutFrame 0 0.5 0 0.5 0 1 0 1)
                          component: PluggableView
             postBuildCallback: postBuildNative2:         

           )
          )
        
       )
     )

    "Modified: / 25-02-2016 / 16:49:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples2Viewer class methodsFor:'startup-web applications'!

initialPageSpec
    "this is only required for web-applications"

    ^ self shouldImplement
!

pageSpecs
    "this is only required for web-applications"

    ^ self shouldImplement
! !

!Examples2Viewer methodsFor:'change & update'!

updateAfterExampleMethodChanged
    | method |

    method := self exampleMethodHolder value.
    native1 redrawAction: [self redraw: native1 using: method ].
    native2 redrawAction: [self redraw: native2 using: method ].
    cairo1 redrawAction: [self redraw: cairo1 using: method ].
    cairo2 redrawAction: [self redraw: cairo2 using: method ].
    self redraw

    "Created: / 26-02-2016 / 22:53:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2016 / 16:21:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples2Viewer methodsFor:'drag & drop'!

dropObjects:aCollectionOfDropObjects
    "drop manager wants to drop.
     This is ony sent, if #canDrop: returned true.
     Must be redefined in order for drop to work."

    ^ self shouldImplement
! !

!Examples2Viewer methodsFor:'hooks'!

postBuildCairo1:aPluggableView
    <resource: #uiCallback>

   cairo1 := aPluggableView.
   cairo1 cairoify

    "Created: / 25-02-2016 / 16:50:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildCairo2:aPluggableView
    <resource: #uiCallback>

   cairo2 := aPluggableView.
   cairo2 cairoify

    "Created: / 25-02-2016 / 16:50:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildNative1:aPluggableView
    <resource: #uiCallback>

   native1 := aPluggableView

    "Created: / 25-02-2016 / 16:49:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildNative2:aPluggableView
    <resource: #uiCallback>

   native2 := aPluggableView

    "Created: / 25-02-2016 / 16:49:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples2Viewer methodsFor:'menu'!

menuExamples
    "superclass Cairo::AbstractViewer says that I am responsible to implement this method"

    ^ self menuExamplesFromClass: Cairo::Examples2

    "Modified: / 27-02-2016 / 08:56:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples2Viewer methodsFor:'private'!

redraw
    native1 invalidate.
    native2 invalidate.
    cairo1 invalidate.
    cairo2 invalidate.

    "Created: / 28-02-2016 / 16:20:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redraw:view using: method
    view transformation: nil.
    view lineWidth: 1.
    view paint: Color black.
    (view == cairo1 or:[ view == cairo2 ]) ifTrue:[
        view displayLineFromX: view width - 10 y: 1 toX: view width y: 10.
    ]. 
    self zoomHolder value ~= 100 ifTrue:[ 
        view transformation: (WindowingTransformation scale: self zoomHolder value / 100)
    ].
    self redraw:view using: method with: view.
    view transformation: nil.

    "Created: / 26-02-2016 / 21:49:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 29-02-2016 / 18:40:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples2Viewer methodsFor:'private - templates'!

exampleMethodParameterName
    "superclass Cairo::AbstractViewer says that I am responsible to implement this method"

    ^ 'gc'

    "Modified: / 26-02-2016 / 22:57:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples2Viewer class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

