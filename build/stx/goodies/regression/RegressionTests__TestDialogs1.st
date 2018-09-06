"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

ApplicationModel subclass:#TestDialogs1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!TestDialogs1 class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	Claus Gittinger (cg@alan)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

examples
"
  Starting the application:
								[exBegin]
    TestApplication1 open

								[exEnd]

  more examples to be added:
								[exBegin]
    ... add code fragment for
    ... executable example here ...
								[exEnd]
"
!

history
    "Created: / 14.12.2000 / 19:19:07 / cg"
! !

!TestDialogs1 class methodsFor:'interface specs'!

dialogSpec1
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TestApplication1 andSelector:#dialogSpec1
     TestApplication1 new openInterface:#dialogSpec1
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #dialogSpec1
	#window:
       #(#WindowSpec
	  #label: #TestApplication1
	  #name: #TestApplication1
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 16 46 316 346)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#ActionButtonSpec
	      #label: 'OK'
	      #name: 'Button1'
	      #layout: #(#LayoutFrame 7 0 271 0 132 0 293 0)
	      #translateLabel: true
	      #model: #accept
	    )
	   #(#ActionButtonSpec
	      #label: 'Cancel'
	      #name: 'Button2'
	      #layout: #(#LayoutFrame 167 0 271 0 292 0 293 0)
	      #translateLabel: true
	      #model: #cancel
	    )
	   )

	)
      )
!

dialogSpec2
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TestApplication1 andSelector:#dialogSpec2
     TestApplication1 new openInterface:#dialogSpec2
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #dialogSpec2
	#window:
       #(#WindowSpec
	  #label: #TestApplication1
	  #name: #TestApplication1
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 16 46 316 346)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#ActionButtonSpec
	      #label: 'OK'
	      #name: 'Button1'
	      #layout: #(#LayoutFrame 7 0 271 0 132 0 293 0)
	      #translateLabel: true
	      #model: #accept
	    )
	   #(#ActionButtonSpec
	      #label: 'Cancel'
	      #name: 'Button2'
	      #layout: #(#LayoutFrame 167 0 271 0 292 0 293 0)
	      #translateLabel: true
	      #model: #cancel
	    )
	   #(#InputFieldSpec
	      #name: 'EntryField1'
	      #layout: #(#LayoutFrame 50 0 127 0 255 0 149 0)
	      #acceptOnPointerLeave: false
	    )
	   )

	)
      )
!

dialogSpec3
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TestApplication1 andSelector:#dialogSpec3
     TestApplication1 new openInterface:#dialogSpec3
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #dialogSpec3
	#window:
       #(#WindowSpec
	  #label: #TestApplication1
	  #name: #TestApplication1
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 16 46 316 346)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#ActionButtonSpec
	      #label: 'OK'
	      #name: 'Button1'
	      #layout: #(#LayoutFrame 7 0 271 0 132 0 293 0)
	      #translateLabel: true
	      #model: #accept
	      #isDefault: true
	    )
	   #(#ActionButtonSpec
	      #label: 'Cancel'
	      #name: 'Button2'
	      #layout: #(#LayoutFrame 167 0 271 0 292 0 293 0)
	      #translateLabel: true
	      #model: #cancel
	    )
	   )

	)
      )
!

dialogSpec4
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TestApplication1 andSelector:#dialogSpec3
     TestApplication1 new openInterface:#dialogSpec3
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #dialogSpec3
	#window:
       #(#WindowSpec
	  #label: #TestApplication1
	  #name: #TestApplication1
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 16 46 316 346)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#ActionButtonSpec
	      #label: 'OK'
	      #name: 'Button1'
	      #layout: #(#LayoutFrame 7 0 271 0 132 0 293 0)
	      #translateLabel: true
	      #model: #accept
	      #isDefault: true
	    )
	   #(#ActionButtonSpec
	      #label: 'Cancel'
	      #name: 'Button2'
	      #layout: #(#LayoutFrame 167 0 271 0 292 0 293 0)
	      #translateLabel: true
	      #model: #cancel
	    )
	   #(#InputFieldSpec
	      #name: 'EntryField1'
	      #layout: #(#LayoutFrame 50 0 127 0 255 0 149 0)
	      #acceptOnPointerLeave: false
	    )
	   )

	)
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:TestApplication1 andSelector:#windowSpec
     TestApplication1 new openInterface:#windowSpec
     TestApplication1 open
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #windowSpec
	#window:
       #(#WindowSpec
	  #label: 'TestApplication1'
	  #name: 'TestApplication1'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1024 768)
	  #bounds: #(#Rectangle 16 46 316 346)
	  #menu: #mainMenu
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'Label'
	      #name: 'Label1'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
	      #translateLabel: true
	      #labelChannel: #infoMessageHolder
	    )
	   )

	)
      )
! !

!TestDialogs1 class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated by the Browser."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:TestApplication1 andSelector:#mainMenu
    "

    <resource: #menu>

    ^ #(#Menu
	   #(
	     #(#MenuItem
		#label: 'File'
		#translateLabel: true
		#submenu:
		 #(#Menu
		     #(
		       #(#MenuItem
			  #label: 'Exit'
			  #translateLabel: true
			  #value: #closeRequest
		      )
		    ) nil
		    nil
		)
	    )
	     #(#MenuItem
		#label: 'Tests'
		#translateLabel: true
		#submenu:
		 #(#Menu
		     #(
		       #(#MenuItem
			  #label: 'Dialog1'
			  #translateLabel: true
			  #value: #testDialog1
		      )
		       #(#MenuItem
			  #label: 'Dialog2'
			  #translateLabel: true
			  #value: #testDialog2
			)
		       #(#MenuItem
			  #label: 'Dialog3'
			  #translateLabel: true
			  #value: #testDialog3
			)
		       #(#MenuItem
			  #label: 'Dialog4'
			  #translateLabel: true
			  #value: #testDialog4
			)
		    ) nil
		    nil
		)
	    )


	  ) nil
	  nil
      )
! !

!TestDialogs1 methodsFor:'aspects'!

infoMessageHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    |holder|

    (holder := builder bindingAt:#infoMessageHolder) isNil ifTrue:[
	holder := ValueHolder new.
	builder aspectAt:#infoMessageHolder put:holder.

	holder value:'
Please check that
all dialogs (open via the ''Tests''-menuItem)
close when their OK-Button is pressed.
'.
    ].
    ^ holder.
! !

!TestDialogs1 methodsFor:'initialization & release'!

closeDownViews
    "This is a hook method generated by the Browser.
     It will be invoked when your app/dialog-window is really closed.
     See also #closeDownViews, which is invoked before and may suppress the close
     or ask the user for confirmation."

    "/ change the code below as required ...
    "/ This should cleanup any leftover resources
    "/ (for example, temporary files)
    "/ super closeRequest will initiate the closeDown

    "/ add your code here

    "/ do not remove the one below ...
    ^ super closeDownViews
!

postBuildWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked during the initialization of your app/dialog,
     after all of the visual components have been built,
     but BEFORE the top window is made visible.
     Add any app-specific actions here (reading files, setting up values etc.)
     See also #postOpenWith:, which is invoked after opening."

    "/ add any code here ...

    ^ super postBuildWith:aBuilder
!

postOpenWith:aBuilder
    "This is a hook method generated by the Browser.
     It will be invoked right after the applications window has been opened.
     Add any app-specific actions here (starting background processes etc.).
     See also #postBuildWith:, which is invoked before opening."

    "/ add any code here ...

    ^ super postOpenWith:aBuilder
! !

!TestDialogs1 methodsFor:'menu actions'!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    HTMLDocumentView openFullOnDocumentationFile:'TOP.html'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
!

testDialog1
    self openDialogInterface:#dialogSpec1
!

testDialog2
    self openDialogInterface:#dialogSpec2
!

testDialog3
    self openDialogInterface:#dialogSpec3
!

testDialog4
    self openDialogInterface:#dialogSpec4
! !

!TestDialogs1 class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

