"{ NameSpace: CodingExamples_GUI }"

Object subclass:#ReadMe
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'_README'
!

!ReadMe class methodsFor:'documentation'!

documentation
"
    In the CodingExamples_GUI nameSpace, you will find various
    GUI related coding examples.
    These include low-level drawing, medium-level drawing (paths),
    programmed window creation, tutorial examples and GUIPainter
    interface examples.

    The corresponding files are found in 'doc/coding' and
    contain examples of how to use some of the more non-obvious 
    mechanisms of smalltalk (and/or Smalltalk/X), and some view class examples.

    Some files found there contain full classes or methods, others contain just code 
    fragments to be evaluated by doIt. 
    Look at the files (using the FileBrowser) before you start filing them in.

    The examples will be split into two directories (one for mechanisms, 
    another for view tutorials) soon.

    List of files (most contain classes which are also autoloaded):
    (may be outdated by the time you read this ..)

        Model-Simple1           shows how models can be used (i.e. kind of
                                MVC; however, in ST/X the view and controller
                                functionality is combined in the view).
                                This example shows how buttons can use models.

        Model-Simple2           a selectionInListView with a model

        Model-Simple3           buttons and a popUpList with a model

        Model-Label.st          a label and a model

        View-ButtonDemoXX       using Buttons (tutorial examples)

        View-ExampleXX          various views, views-in-views etc.
                                with growing complexity (tutorial examples).
                                (start with example1x, example2, and so on)

        View-FrameXX            more views showing use of frames (tutorial examples)

        View-HelloWorld         hello world in smalltalk
                                (no language without its hello-world program ... :-)
                                This example creates a new View subclass, i.e. it
                                does not use existing widgets, but defines a
                                new 'hello-world' widget.

        View-HelloWorld2        same, but using the existing Label widget.

        View-16bit-strings      example, how 16bit strings are drawn in a view

        View-16bit-labels       demonstrates that labels can handle 16bit strings. 
        View-16bit-buttons      and buttons too

        View-PanelXX            more views showing use of panels
                                (variableVertical & variableHorizontal)

        View-drawing-arc        shows how arcs are drawn
        View-drawing-arc2       more on drawing arcs
        View-drawing-arc3       more on drawing arcs (varying lineWidth)
        View-drawing-arc4       more on drawing arcs (varying lineWidth and color)
        View-drawing-filledarc  shows filled arcs
        View-drawing-filledarc2 filled arcs as in pie charts (i.e. arcs, lines & filled arcs)

        View-PopUpMenu-simple   how to define a very simple popup-menu
        View-PopUpMenu-check    how to define a popup-menu with check-marks
        View-PopUpMenu-submenus how to define a more complex popup-menu (with submenus)

        View-Slider-example1    a simple horizontal slider
        View-Slider-example2    a simple, thin horizontal slider
        View-Slider-example3    a thin horizontal slider showing its value
        View-Slider-example4    same, but value is shown under sliders knob

        View-border-round       a round-bordered view

        View-border-funny       a very funny shaped view - transparent, using an image
                                as border (you never saw this before in smalltalk !!)

        View-transformations    various demos for how transformations can be used
                                when drawing (metric units, scaling etc.)
"
! !

!ReadMe class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/CE_GUIReadMe.st,v 1.7 1998-01-28 14:42:46 cg Exp $'
! !
