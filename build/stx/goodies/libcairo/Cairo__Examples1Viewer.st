"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

AbstractViewer subclass:#Examples1Viewer
	instanceVariableNames:'output'
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Examples'
!

!Examples1Viewer methodsFor:'change & update'!

updateAfterExampleMethodChanged
    | method |

    method := self exampleMethodHolder value.
    output redrawAction: [self redraw: output using: method ].
    self redraw

    "Created: / 26-02-2016 / 21:40:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2016 / 16:21:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples1Viewer methodsFor:'drag & drop'!

dropObjects:aCollectionOfDropObjects
    "drop manager wants to drop.
     This is ony sent, if #canDrop: returned true.
     Must be redefined in order for drop to work."

    ^ self shouldImplement
! !

!Examples1Viewer methodsFor:'hooks'!

postBuildOutput:aPluggableView
    <resource: #uiCallback>

   output := aPluggableView

    "Modified: / 22-02-2016 / 16:15:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples1Viewer methodsFor:'menu'!

menuExamples
    ^ self menuExamplesFromClass: Cairo::Examples1

    "Modified: / 26-02-2016 / 22:38:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples1Viewer methodsFor:'private'!

redraw
    output invalidate.

    "Created: / 28-02-2016 / 16:20:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redraw:view using: method
    | cr |

    cr := view cairo.
    cr scale: (self zoomHolder value / 100) asFloat.
    [ 
        self redraw: view using: method with: cr. 
    ] ensure:[ 
        cr release
    ].

    "Created: / 26-02-2016 / 21:48:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2016 / 16:15:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Examples1Viewer methodsFor:'private - templates'!

exampleMethodParameterName
    "superclass Cairo::AbstractViewer says that I am responsible to implement this method"

    ^ 'cr'

    "Modified: / 28-02-2016 / 07:56:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

