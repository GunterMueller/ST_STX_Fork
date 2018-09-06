"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemoSubCanvasWithEmbeddedFileDialog
	instanceVariableNames:'dialogPart selectedPathHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!


!GUIDemoSubCanvasWithEmbeddedFileDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoSubCanvasWithEmbeddedFileDialog andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoSubCanvasWithEmbeddedFileDialog new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoSubCanvasWithEmbeddedFileDialog open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'NewApplication'
          #name: 'NewApplication'
          #min: #(#Point 10 10)
          #max: #(#Point 1280 1024)
          #bounds: #(#Rectangle 16 46 316 346)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SubCanvasSpec
              #name: 'SubCanvas1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 -70 1.0)
              #hasHorizontalScrollBar: false
              #hasVerticalScrollBar: false
              #majorKey: #FileDialog
              #minorKey: #windowSpec
              #createNewApplication: true
              #createNewBuilder: true
              #postBuildCallback: #fileDialogCreated:
            )
           #(#DividerSpec
              #name: 'Separator1'
              #layout: #(#LayoutFrame 0 0.0 -70 1 0 1.0 -66 1)
            )
           #(#LabelSpec
              #label: 'Selected Path:'
              #name: 'Label1'
              #layout: #(#LayoutFrame 0 0 -61 1 0 1 -31 1)
              #translateLabel: true
              #adjust: #left
            )
           #(#LabelSpec
              #label: 'Label'
              #name: 'Label2'
              #layout: #(#LayoutFrame 0 0 -30 1 0 1 0 1)
              #level: -1
              #translateLabel: true
              #labelChannel: #selectedPathHolder
              #adjust: #left
            )
           )
         
        )
      )
! !

!GUIDemoSubCanvasWithEmbeddedFileDialog methodsFor:'actions'!

selectedFileNameChanged
    self selectedPathHolder value:(dialogPart filenameHolder value asFilename pathName).
! !

!GUIDemoSubCanvasWithEmbeddedFileDialog methodsFor:'aspects'!

selectedPathHolder

    selectedPathHolder isNil ifTrue:[
        selectedPathHolder := ValueHolder new.
    ].
    ^ selectedPathHolder.
! !

!GUIDemoSubCanvasWithEmbeddedFileDialog methodsFor:'hooks'!

fileDialogCreated:aWidget
    dialogPart := aWidget application.
!

postBuildWith:aBuilder

    dialogPart startFilename:('/etc' asFilename asAbsoluteFilename).
    dialogPart filenameHolder onChangeSend:#selectedFileNameChanged to:self.
    super postBuildWith:aBuilder.
! !

!GUIDemoSubCanvasWithEmbeddedFileDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoSubCanvasWithEmbeddedFileDialog.st,v 1.2 2003-03-27 10:06:34 tm Exp $'
! !
