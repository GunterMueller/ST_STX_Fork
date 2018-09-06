"{ NameSpace: CodingExamples_GUI }"

View subclass:#DragAndDropDemoView1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

!DragAndDropDemoView1 class methodsFor:'documentation'!

documentation
"
    demonstrates rubber-line dragging.

    See the buttonPress method, where a drag is initiated.
    At endDrop, look at the transcript.

    [author:]
        Claus Gittinger

    [start with:]
        CodingExamples_GUI::DragAndDropDemoView1 new open
"


! !

!DragAndDropDemoView1 methodsFor:'events'!

buttonPress:button x:x y:y
    DragAndDropManager new
        startLineDragIn:self at:(x@y) 
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

!DragAndDropDemoView1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/DragAndDropDemoView1.st,v 1.1 1998-03-30 12:01:09 ca Exp $'
! !
