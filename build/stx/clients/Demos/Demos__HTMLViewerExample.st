"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: Demos }"

ApplicationModel subclass:#HTMLViewerExample
	instanceVariableNames:'widgetsByID glView delayedGLInitializationCode'
	classVariableNames:''
	poolDictionaries:'OpenGLConstants'
	category:'Applications'
!

HTML::TreeBuilder subclass:#MyBuilder
	instanceVariableNames:'myApp'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HTMLViewerExample
!


!HTMLViewerExample class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HTMLViewerExample andSelector:#windowSpec
     HTMLViewerExample new openInterface:#windowSpec
     HTMLViewerExample open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'NewApplication'
          name: 'NewApplication'
          bounds: (Rectangle 0 0 567 769)
        )
        component: 
       (SpecCollection
          collection: (
           (HTMLViewSpec
              name: 'HTMLBrowser1'
              layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              htmlText: htmlContents
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
              horizontalLayout: center
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Close'
                    name: 'Button1'
                    translateLabel: true
                    model: closeRequest
                    extent: (Point 125 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!HTMLViewerExample methodsFor:'aspects'!

htmlContents
    ^ self htmlContents_v4
!

htmlContents_v1
    ^ '
<html>
<body>
<p>hello world</p>
<p>bla bla</p>
</body>
</html>
'
!

htmlContents_v2
    |treeBuilder|

    treeBuilder := MyBuilder new.
    treeBuilder
        html;
          body;
            p:'
Actions
Download Package
Browse Code
Show History
Copy Version
Copy Package
Move Version
Move Package
Delete Version
Delete Package
Back
Authentication
Login
Magritte-VisualWorks-nfr.8.mcz
Filename:   Magritte-VisualWorks-nfr.8.mcz
Author: 
Timestamp:  21 October 2007 7:55:31 pm
UUID:   f09e1f58-fc60-6740-878c-b53999697cae
Ancestors:  Magritte-VisualWorks-lr.7.mcz
Message:    Drop MADistribution extension, sort namespace imports
Downloads:  Squeak: 11
Web: 39
';
            clock;
            p:'bla bla';
          bodyEnd;
        htmlEnd.
            
    ^ treeBuilder htmlString
!

htmlContents_v3
    |treeBuilder|

    treeBuilder := MyBuilder new myApp:self.
    treeBuilder
        html:[
    treeBuilder
          body:[
    treeBuilder
            p:self testText1;
            widgetBlock:[ ClockView new ];
            p:'bla bla'
          ]
        ].                                                           
    ^ treeBuilder htmlString
!

htmlContents_v4
    |treeBuilder|

    treeBuilder := MyBuilder new myApp:self.
    treeBuilder
        html:[
    treeBuilder
          body:[
    treeBuilder
            p:self testText1;
            widgetBlock:[ ClockView new ];
            p:'bla bla';
            widgetBlock:[ 
                            |v| 

                            v := View new.
                            v extent:300@300.
                            self 
                                registerGLView:v 
                                forInitializationWith:[:v | self setupGLDemoAnimationIn:v ].
                            v
                        ]
          ]
        ].                                                           
    ^ treeBuilder htmlString
!

registerGLView:aGLView forInitializationWith:aBlock
    delayedGLInitializationCode at:aGLView put:aBlock.
!

registerWidget:aWidget 
    widgetsByID at:(aWidget uuid printString) put:aWidget.
!

setupGLDemoAnimationIn:aView
    [
        |r|

        Delay waitForSeconds:0.5.
        r := OpenGLRenderingContext new.
        r initializeFor:aView.
        r makeCurrent.
        r glClearColorRed:1 green:1 blue:1 alpha:0.

        [
            0 to:360 by:1 do:[:theta |
              r glClear:GLColorBufferBit.

              r glPushMatrix.
              r glRotate:theta x:0.0 y:0.0 z:1.0.

              r glBegin:GL_TRIANGLES.
              r glColor3fv:#( 1.0  0.0  0.0 ); glVertex2fv:#(  0.0    1.0 ).
              r glColor3fv:#( 0.0  1.0  0.0 ); glVertex2fv:#(  0.87  -0.5 ).
              r glColor3fv:#( 0.0  0.0  1.0 ); glVertex2fv:#( -0.87  -0.5 ).
              r glRotate:theta x:0.0 y:0.0 z:1.0.
              r glEnd.

              r glPopMatrix.

              r swapBuffers.
              Delay waitForSeconds:0.01.
            ].
        ] loop.
        r destroyGLContext
    ] fork
!

testText1
    ^ '
Actions
Download Package
Browse Code
Show History
Copy Version
Copy Package
Move Version
Move Package
Delete Version
Delete Package
Back
Authentication
Login
Magritte-VisualWorks-nfr.8.mcz
Filename:   Magritte-VisualWorks-nfr.8.mcz
Author: 
Timestamp:  21 October 2007 7:55:31 pm
UUID:   f09e1f58-fc60-6740-878c-b53999697cae
Ancestors:  Magritte-VisualWorks-lr.7.mcz
Message:    Drop MADistribution extension, sort namespace imports
Downloads:  Squeak: 11
Web: 39
'
!

widgetFor:aKey
    ^ widgetsByID at:aKey
! !

!HTMLViewerExample methodsFor:'initialization'!

initialize
    super initialize.  
    widgetsByID := Dictionary new.
    delayedGLInitializationCode := Dictionary new.
!

postOpenWith:aBuilder
    super postOpenWith:aBuilder.

    delayedGLInitializationCode keysAndValuesDo:[:eachView :eachBlock |
        eachBlock value:eachView
    ].
!

release
    self windowGroup process terminateAllSubprocessesInGroup.
    super release.
! !

!HTMLViewerExample::MyBuilder methodsFor:'accessing'!

myApp:something
    myApp := something.
! !

!HTMLViewerExample::MyBuilder methodsFor:'better components'!

clock
    self widgetClass:'ClockView'
!

widget:aWidget id:id
    self rawText:('<applet widgetid="%1"></applet>' bindWith:id)
!

widgetBlock:aBlock
    |id widget|

    id := UUID genUUID.
    widget := aBlock value.
    widget uuid:id.
    myApp registerWidget:widget.

    self rawText:('<applet widgetid="%1"></applet>' bindWith:id)
!

widgetClass:className
    self rawText:('<applet width="100%" class="%1"></applet>' bindWith:className)
! !

!HTMLViewerExample class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/Demos__HTMLViewerExample.st,v 1.1 2009-07-29 18:08:53 cg Exp $'
! !
