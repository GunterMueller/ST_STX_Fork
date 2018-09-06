"{ NameSpace: CodingExamples_GUI }"

View subclass:#DragAndDropDemoView3
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

!DragAndDropDemoView3 class methodsFor:'documentation'!

documentation
"
    demonstrates arrow-line dragging.

    See the buttonPress method, where a drag is initiated.
    At endDrop, look at the transcript.

    [author:]
        Claus Gittinger

    [start with:]
        CodingExamples_GUI::DragAndDropDemoView3 new open
"


! !

!DragAndDropDemoView3 methodsFor:'events'!

buttonPress:button x:x y:y
    DragAndDropManager new
        startArrowDragIn:self 
        at:(x@y)
        atEnd:[:view
               :viewID
               :rootPoint
               :viewPoint | 

               Transcript show:'dropped at ';
                          show:viewPoint;
                          show:' (screen: ';
                          show:rootPoint;
                          show:') in '.
               view notNil ifTrue:[
                   Transcript showCR:view
               ] ifFalse:[
                   Transcript show:'alien view ';
                              showCR:viewID address
               ] 
        ].


! !

!DragAndDropDemoView3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/DragAndDropDemoView3.st,v 1.1 1998-03-30 12:01:36 ca Exp $'
! !
