"{ Package: 'stx:goodies/demos/jh/math/fractalApplication' }"

"{ NameSpace: Demos }"

ApplicationModel subclass:#FractalApplication
	instanceVariableNames:'fractalSet fractalView'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-JH-Mandelbrot'
!

!FractalApplication class methodsFor:'documentation'!

documentation
"
    Application to display a fractal set. Zoom in, zoom out are supported.

    [author:]
	Jan Hussaarts (Jan@DESKTOPJAN)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
								[exBegin]
    FractalApplication new openMandelbrot

								[exEnd]

"
!

history
    "Created: / 17.5.2003 / 00:29:31 / Jan"
! !

!FractalApplication class methodsFor:'instance creation'!

openOn:aFractalSet
    self new openOn:aFractalSet
! !

!FractalApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FractalApplication andSelector:#windowSpec
     FractalApplication new openInterface:#windowSpec
     FractalApplication open
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #windowSpec
	#window:
       #(#WindowSpec
	  #label: 'MyLabel'
	  #name: 'MyLabel'
	  #min: #(#Point 180 180)
	  #max: #(#Point 1024 749)
	  #bounds: #(#Rectangle 13 23 311 321)
	  #menu: #mainMenu
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#FramedBoxSpec
	      #label: ''
	      #name: 'FramedBox1'
	      #layout: #(#LayoutFrame 5 0 5 0 -5 1 -5 1)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component:
	     #(#SpecCollection
		#collection: #(
		 #(#NonScrollableArbitraryComponentSpec
		    #name: 'FractalView'
		    #layout: #(#LayoutFrame -9 0 -9 0 9 1 9 1)
		    #component: #fractalView
		  )
		 )

	      )
	    )
	   )

	)
      )
! !

!FractalApplication class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:MandelbrotApplication andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(MandelbrotApplication mainMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'File'
	    #translateLabel: true
	    #submenu:
	   #(#Menu
	      #(
	       #(#MenuItem
		  #label: 'Exit'
		  #itemValue: #closeRequest
		  #translateLabel: true
		)
	       )
	      nil
	      nil
	    )
	  )
	 #(#MenuItem
	    #label: 'Features'
	    #translateLabel: true
	    #submenu:
	   #(#Menu
	      #(
	       #(#MenuItem
		  #label: 'Zoom in'
		  #itemValue: #zoomIn
		  #translateLabel: true
		)
	       #(#MenuItem
		  #label: 'Zoom out'
		  #itemValue: #zoomOut
		  #translateLabel: true
		)
	       #(#MenuItem
		  #label: '-'
		)
	       #(#MenuItem
		  #label: 'Julia'
		  #itemValue: #createJulia
		  #translateLabel: true
		)
	       #(#MenuItem
		  #label: '-'
		)
	       #(#MenuItem
		  #label: 'Change colors'
		  #itemValue: #changeColors
		  #translateLabel: true
		)
	       #(#MenuItem
		  #label: '-'
		)
	       #(#MenuItem
		  #label: 'Return to default'
		  #itemValue: #reset
		  #translateLabel: true
		)
	       )
	      nil
	      nil
	    )
	  )
	 #(#MenuItem
	    #label: 'Help'
	    #translateLabel: true
	    #startGroup: #right
	    #submenu:
	   #(#Menu
	      #(
	       #(#MenuItem
		  #label: 'About this Application'
		  #itemValue: #openAboutThisApplication
		  #translateLabel: true
		)
	       )
	      nil
	      nil
	    )
	  )
	 )
	nil
	nil
      )
! !

!FractalApplication methodsFor:'accessing'!

aboutThisApplicationText
^'It was fun building this app.

Jan Hussaarts'
!

changeColors
   self fractalView changeColors.
!

createJulia

|point j|

point := self fractalSet calculatePoint: (self fractalView pointFromUser).
j := JuliaSet default.
j c:(Complex real: point x imaginary: point y).
FractalApplication openOn: j
!

fractalSet
    "return the value of the instance variable 'mandelbrotSet' (automatically generated)"

    ^ fractalSet
!

fractalView
    "return the value of the instance variable 'mandelbrotView' (automatically generated)"

    ^ fractalView
!

reset
   self fractalView reset
!

zoomIn
   self fractalView zoomIn
!

zoomOut
   self fractalView zoomOut
! !

!FractalApplication methodsFor:'hooks'!

closeRequest
    "automatically generated by UIPainter ..."

    "*** the code here does nothing. It is invoked when"
    "*** the topView has been asked to close"
    "*** Please change as required and accept in the browser."

    "specific code to be added below ..."
    "return without the 'super closeRequest' to stay open"

    ^super closeRequest
!

postBuildWith:aBuilder
    self builder window label:self fractalSet label.
    super postBuildWith:aBuilder
!

postOpenWith:aBuilder
    "automatically generated by UIPainter ..."

    "*** the code here does nothing. It is invoked when"
    "*** the topView has been opened, but before events are dispatched for it"
    "*** Please change as required and accept in the browser."

    "specific code to be added below ..."
    "or after the super send"

    super postOpenWith:aBuilder.
! !

!FractalApplication methodsFor:'initialization & release'!

open
    self openMandelbrot
!

openJulia
    fractalView := FractalView on:(fractalSet :=JuliaSet default).
    super open.
!

openMandelbrot
    fractalView := FractalView on:(fractalSet := MandelbrotSet default).
    super open.
!

openOn:aFractalSet
fractalSet := aFractalSet.
    fractalView := FractalView on:(aFractalSet).
    super open
! !

!FractalApplication methodsFor:'menu actions'!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
! !

!FractalApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/fractalApplication/FractalApplication.st,v 1.3 2008-10-26 13:45:19 cg Exp $'
! !