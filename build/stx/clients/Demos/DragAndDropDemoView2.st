"{ NameSpace: CodingExamples_GUI }"

View subclass:#DragAndDropDemoView2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

!DragAndDropDemoView2 class methodsFor:'documentation'!

documentation
"
    demonstrates string dragging.

    See the buttonPress method, where a drag is initiated.
    At endDrop, look at the transcript.


    [author:]
        Claus Gittinger

    [start with:]
        CodingExamples_GUI::DragAndDropDemoView2 new open
"
! !

!DragAndDropDemoView2 methodsFor:'events'!

buttonPress:button x:x y:y
    DragAndDropManager new
        startGenericDrag:[:p :v | v displayString:'hello' at:p]
        in:self 
        at:(x@y) 
        atEnd:[:view
               :viewID
               :rootPoint
               :viewPoint | ]


! !

!DragAndDropDemoView2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/DragAndDropDemoView2.st,v 1.1 1998-03-30 12:01:22 ca Exp $'
! !
