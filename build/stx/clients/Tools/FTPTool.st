"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:clients/Tools' }"

ApplicationModel subclass:#FTPTool
	instanceVariableNames:'ftpClient connectProcess listLong'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Tools-System'
!

!FTPTool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    a simple demo application providing some
    graphical interface to ftp.

    (mostly an UI-builder testcase & ftpClient demo)

    [author:]
	Claus Gittinger

    [see also]
	FTPClient

    [start with:]
	FTPTool open
"
! !

!FTPTool class methodsFor:'constants'!

transferBufferSize
    ^ 8 * 1024

    "Created: 3.4.1997 / 21:02:56 / cg"
    "Modified: 3.4.1997 / 21:25:23 / cg"
! !

!FTPTool class methodsFor:'interface specs'!

connectDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:FTPTool andSelector:#connectDialogSpec
     FTPTool new openInterface:#connectDialogSpec
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #connectDialogSpec
	#window:
       #(#WindowSpec
	  #label: 'Connect'
	  #name: 'Connect'
	  #bounds: #(#Rectangle 134 191 495 455)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'connect to host'
	      #name: 'label1'
	      #layout: #(#LayoutFrame 0 0 0 0 0 1 31 0)
	      #level: 0
	    )
	   #(#LabelSpec
	      #label: 'Hostname:'
	      #name: 'HostLabel'
	      #layout: #(#AlignmentOrigin 0 0.3 70 0 1 0.5)
	      #level: 0
	      #translateLabel: true
	      #adjust: #right
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#editField1
		nil
	      )
	      #name: 'HostEntryField'
	      #layout: #(#LayoutFrame 5 0.3 59 0 -5 1 81 0)
	      #tabable: true
	      #model: #hostNameHolder
	      #immediateAccept: false
	      #acceptOnLeave: true
	      #acceptOnReturn: true
	      #acceptOnTab: true
	      #acceptOnLostFocus: true
	      #acceptOnPointerLeave: false
	    )
	   #(#LabelSpec
	      #label: 'Port:'
	      #name: 'PortLabel'
	      #layout: #(#AlignmentOrigin 0 0.3 99 0 1 0.5)
	      #level: 0
	      #translateLabel: true
	      #adjust: #right
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#PortEntryField
		nil #editField1
		nil
	      )
	      #name: 'PortEntryField'
	      #layout: #(#LayoutFrame 5 0.3 88 0 -2 1 110 0)
	      #tabable: true
	      #model: #portHolder
	      #type: #numberOrNil
	      #immediateAccept: false
	      #acceptOnLeave: true
	      #acceptOnReturn: true
	      #acceptOnTab: true
	      #acceptOnLostFocus: true
	      #acceptOnPointerLeave: false
	    )
	   #(#LabelSpec
	      #label: 'User name:'
	      #name: 'UserNameLabel'
	      #layout: #(#AlignmentOrigin 0 0.3 148 0 1 0.5)
	      #level: 0
	      #translateLabel: true
	      #adjust: #right
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#editField2
		nil
	      )
	      #name: 'UserNameEntryField'
	      #layout: #(#LayoutFrame 5 0.3 137 0 -5 1 159 0)
	      #tabable: true
	      #model: #userNameHolder
	      #immediateAccept: false
	      #acceptOnLeave: true
	      #acceptOnReturn: true
	      #acceptOnTab: true
	      #acceptOnLostFocus: true
	      #acceptOnPointerLeave: false
	    )
	   #(#LabelSpec
	      #label: 'Password:'
	      #name: 'PasswordLabel'
	      #layout: #(#AlignmentOrigin 0 0.3 177 0 1 0.5)
	      #level: 0
	      #translateLabel: true
	      #adjust: #right
	    )
	   #(#InputFieldSpec
	      #attributes:
	     #(#PasswordEntryField
		nil #editField3
		nil
	      )
	      #name: 'PasswordEntryField'
	      #layout: #(#LayoutFrame 5 0.3 166 0 -5 1 188 0)
	      #tabable: true
	      #model: #passwordHolder
	      #immediateAccept: false
	      #acceptOnLeave: true
	      #acceptOnReturn: true
	      #acceptOnTab: true
	      #acceptOnLostFocus: true
	      #acceptOnPointerLeave: false
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'horizontalPanelView1'
	      #layout: #(#LayoutFrame 0 0.0 -30 1 0 1.0 0 1)
	      #level: 0
	      #horizontalLayout: #fitSpace
	      #verticalLayout: #center
	      #horizontalSpace: 4
	      #verticalSpace: 4
	      #component:
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'cancel'
		    #name: 'button1'
		    #tabable: true
		    #model: #cancel
		    #extent: #(#Point 174 27)
		  )
		 #(#ActionButtonSpec
		    #label: 'connect'
		    #name: 'button2'
		    #tabable: true
		    #model: #accept
		    #isDefault: true
		    #extent: #(#Point 173 27)
		  )
		 )

	      )
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
     UIPainter new openOnClass:FTPTool andSelector:#windowSpec
     FTPTool new openInterface:#windowSpec
     FTPTool open
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #windowSpec
	#window:
       #(#WindowSpec
	  #label: 'FTP Tool'
	  #name: 'FTP Tool'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1024 768)
	  #bounds: #(#Rectangle 12 22 711 485)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#HorizontalPanelViewSpec
	      #name: 'horizontalPanelView4'
	      #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 36 0)
	      #level: -1
	      #horizontalLayout: #leftSpace
	      #verticalLayout: #center
	      #horizontalSpace: 4
	      #verticalSpace: 4
	      #component:
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'connect ...'
		    #name: 'connectButton'
		    #translateLabel: true
		    #resizeForLabel: true
		    #tabable: true
		    #model: #connect
		    #useDefaultExtent: true
		  )
		 #(#ActionButtonSpec
		    #label: 'status...'
		    #name: 'showStatusButton'
		    #translateLabel: true
		    #resizeForLabel: true
		    #model: #showStatus
		    #initiallyDisabled: true
		    #enableChannel: #getEnableHolder
		    #useDefaultExtent: true
		  )
		 #(#ActionButtonSpec
		    #label: 'Help...'
		    #name: 'helpButton'
		    #translateLabel: true
		    #resizeForLabel: true
		    #model: #showHelp
		    #useDefaultExtent: true
		  )
		 #(#ViewSpec
		    #name: 'view13'
		    #extent: #(#Point 25 25)
		  )
		 #(#ToggleSpec
		    #label: 'Binary'
		    #name: 'binaryToggle'
		    #translateLabel: true
		    #model: #binaryModeHolder
		    #isTriggerOnDown: true
		    #lampColor: #(#Color 100.0 100.0 0.0)
		    #useDefaultExtent: true
		  )
		 #(#ViewSpec
		    #name: 'Box1'
		    #extent: #(#Point 50 25)
		  )
		 #(#ActionButtonSpec
		    #label: 'quit'
		    #name: 'quitButton'
		    #translateLabel: true
		    #resizeForLabel: true
		    #tabable: true
		    #model: #quit
		    #useDefaultExtent: true
		  )
		 )

	      )
	    )
	   #(#VariableVerticalPanelSpec
	      #name: 'variableVerticalPanel1'
	      #layout: #(#LayoutFrame 0 0.0 36 0 0 1.0 -25 1.0)
	      #component:
	     #(#SpecCollection
		#collection: #(
		 #(#ViewSpec
		    #name: 'localFileFrame'
		    #component:
		   #(#SpecCollection
		      #collection: #(
		       #(#HorizontalPanelViewSpec
			  #name: 'horizontalPanelView3'
			  #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 36 0)
			  #level: -1
			  #horizontalLayout: #leftSpace
			  #verticalLayout: #center
			  #horizontalSpace: 4
			  #verticalSpace: 4
			  #component:
			 #(#SpecCollection
			    #collection: #(
			     #(#ActionButtonSpec
				#label: 'put'
				#name: 'putFileButton'
				#resizeForLabel: true
				#tabable: true
				#model: #putFile
				#enableChannel: #putEnableHolder
				#useDefaultExtent: true
			      )
			     )

			  )
			)
		       #(#ViewSpec
			  #name: 'view3'
			  #layout: #(#LayoutFrame 0 0 36 0 0 1 0 1)
			  #component:
			 #(#SpecCollection
			    #collection: #(
			     #(#LabelSpec
				#label: 'local files:'
				#name: 'localFilesLabel'
				#layout: #(#LayoutFrame 0 0 0 0 130 0 23 0)
				#adjust: #left
			      )
			     #(#InputFieldSpec
				#name: 'localDirectoryInput'
				#layout: #(#LayoutFrame 110 0 0 0 -120 1.0 23 0)
				#tabable: true
				#model: #localDirectoryHolder
				#immediateAccept: false
				#acceptOnLeave: true
				#acceptOnLostFocus: true
				#acceptOnPointerLeave: false
			      )
			     #(#CheckBoxSpec
				#label: 'long list'
				#name: 'localLongList'
				#layout: #(#LayoutFrame -120 1.0 0 0 0 1.0 23 0)
				#tabable: true
				#model: #localLongListHolder
			      )
			     #(#SequenceViewSpec
				#name: 'localDirectoryList'
				#layout: #(#LayoutFrame 0 0.0 23 0 0 1 0 1)
				#tabable: true
				#model: #localFileList
				#style: #(#FontDescription #courier #medium #roman 12)
				#hasHorizontalScrollBar: true
				#hasVerticalScrollBar: true
				#miniScrollerHorizontal: true
				#useIndex: false
			      )
			     )

			  )
			)
		       )

		    )
		  )
		 #(#ViewSpec
		    #name: 'remoteFileFrame'
		    #component:
		   #(#SpecCollection
		      #collection: #(
		       #(#HorizontalPanelViewSpec
			  #name: 'horizontalPanelView1'
			  #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 36 0)
			  #level: -1
			  #horizontalLayout: #leftSpace
			  #verticalLayout: #center
			  #horizontalSpace: 4
			  #verticalSpace: 4
			  #component:
			 #(#SpecCollection
			    #collection: #(
			     #(#ActionButtonSpec
				#label: 'get'
				#name: 'getFileButton'
				#resizeForLabel: true
				#tabable: true
				#model: #getFile
				#enableChannel: #getEnableHolder
				#useDefaultExtent: true
			      )
			     #(#ActionButtonSpec
				#label: 'show'
				#name: 'showFileButton'
				#resizeForLabel: true
				#tabable: true
				#model: #showFile
				#enableChannel: #getEnableHolder
				#useDefaultExtent: true
			      )
			     )

			  )
			)
		       #(#ViewSpec
			  #name: 'view4'
			  #layout: #(#LayoutFrame 0 0.0 36 0.0 0 1.0 0 1.0)
			  #component:
			 #(#SpecCollection
			    #collection: #(
			     #(#LabelSpec
				#label: 'remote files:'
				#name: 'remoteFilesLabel'
				#layout: #(#LayoutFrame 0 0 0 0 130 0 23 0)
				#adjust: #left
			      )
			     #(#InputFieldSpec
				#name: 'remoteDirectoryInput'
				#layout: #(#LayoutFrame 110 0 0 0 -120 1.0 23 0)
				#tabable: true
				#model: #remoteDirectoryHolder
				#immediateAccept: false
				#acceptOnLeave: true
				#acceptOnLostFocus: true
				#acceptOnPointerLeave: false
			      )
			     #(#CheckBoxSpec
				#label: 'long list'
				#name: 'remoteLongList'
				#layout: #(#LayoutFrame -120 1.0 0 0 0 1.0 23 0)
				#tabable: true
				#model: #remoteLongListHolder
			      )
			     #(#SequenceViewSpec
				#name: 'remoteDirectoryList'
				#layout: #(#LayoutFrame 0 0.0 23 0 0 1 0 1)
				#tabable: true
				#model: #remoteFileList
				#style: #(#FontDescription #courier #medium #roman 12)
				#hasHorizontalScrollBar: true
				#hasVerticalScrollBar: true
				#miniScrollerHorizontal: true
				#useIndex: false
			      )
			     )

			  )
			)
		       )

		    )
		  )
		 )

	      )
	      #handles: #(#Any 0.5 1.0)
	    )
	   #(#LabelSpec
	      #label: ' '
	      #name: 'infoLabel'
	      #layout: #(#LayoutFrame 2 0.0 -25 1.0 -2 1.0 -2 1.0)
	      #level: -1
	      #resizeForLabel: false
	      #adjust: #left
	    )
	   #(#ProgressIndicatorSpec
	      #name: 'progressIndicator'
	      #layout: #(#LayoutFrame 77 0.5 -19 1.0 -4 1.0 -6 1.0)
	      #initiallyInvisible: true
	      #model: #transferProgressHolder
	      #showPercentage: false
	    )
	   )

	)
      )
! !

!FTPTool methodsFor:'actions'!

accept
    "automatically generated by UIPainter ..."

    "action to be added ..."
    Transcript showCR:'action for accept ...'.

    "Created: 26.3.1997 / 15:56:36 / cg"
!

cancel
    "automatically generated by UIPainter ..."

    "action to be added ..."
    Transcript showCR:'action for cancel ...'.

    "Created: 26.3.1997 / 15:56:36 / cg"
!

connect
    |hostName|

    ftpClient notNil ifTrue:[
	(self confirm:('still connected to ' , self hostNameHolder value ,'.\\disconnect ?') withCRs)
	ifFalse:[
	    ^ self
	].
	self disConnect.
    ].
    FTPClient isNil ifTrue:[
	self warn:'Missing FTPClient class'.
	^ self
    ].

    (self openDialogInterface:#connectDialogSpec) ifTrue:[
	ftpClient := FTPClient new.
	self userNameHolder value = 'anonymous' ifTrue:[
	    self passwordHolder value:(OperatingSystem getLoginName
				       , '@'
				       , OperatingSystem getHostName).
	].
	hostName := self hostNameHolder value.
	self activityNotification:('connecting to %1...' bindWith:hostName).
	connectProcess := [
	    FTPClient ftpErrorSignal handle:[:ex |
		self activityNotification:ex errorString.
		ftpClient := nil.
	    ] do:[
		ftpClient
		    connectTo:hostName
		    port:self portHolder value
		    user:self userNameHolder value
		    password:self passwordHolder value.
		self activityNotification:'Connected to ' , hostName.
		self updateRemoteList.

		self getEnableHolder value:true.
		self putEnableHolder value:true.
	    ].
	    connectProcess := nil.
	] forkAt:7.
    ]

    "Created: 26.3.1997 / 15:19:01 / cg"
    "Modified: 28.3.1997 / 22:20:30 / cg"
!

disConnect
    ftpClient notNil ifTrue:[
	connectProcess notNil ifTrue:[
	    connectProcess terminate.
	    connectProcess := nil
	].
	Stream errorSignal handle:[:ex |
	    ex return.
	] do:[
	    ftpClient close.
	].
	ftpClient := nil.

	self updateRemoteList.

	self getEnableHolder value:false.
	self putEnableHolder value:false.
    ].

    "Created: 26.3.1997 / 17:30:27 / cg"
    "Modified: 29.3.1997 / 19:19:52 / cg"
!

getFile
    |line localFileName filename|

    line := self remoteFileList selection.
    line isNil ifTrue:[
	self activityNotification:'get: select a remote file first'.
	^ self
    ].
    filename := line asCollectionOfWords last.

    localFileName := self localDirectoryHolder value withoutSpaces asFilename
			construct:filename.

    localFileName exists ifTrue:[
	(self confirm:'''' , localFileName pathName , ''' exists - get anyway ?') ifFalse:[
	    ^ self
	]
    ].

    self withCursor:Cursor read do:[
	self doGet:filename asLocal:localFileName.
    ].
    self updateLocalList.

    "Modified: 29.3.1997 / 13:29:50 / cg"
!

localDirectoryChanged
    self updateLocalList

    "Created: 27.3.1997 / 11:36:50 / cg"
!

localFileSelectionChanged

    "Modified: 28.3.1997 / 22:20:08 / cg"
!

putFile
    |line filename localFileName|

    line := self localFileList selection.
    line isNil ifTrue:[
	self activityNotification:'put: select a local file first'.
	^ self
    ].

    filename := line asCollectionOfWords last.

    localFileName := self localDirectoryHolder value withoutSpaces asFilename
			construct:filename.

    localFileName exists ifFalse:[
	self warn:'oops ''' , localFileName path , ''' no longer exists'.
	^ self
    ].

    self withCursor:Cursor write do:[
	self putFile:localFileName pathName asRemote:filename.
    ].
    self updateRemoteList.

    "Modified: 28.3.1997 / 22:34:36 / cg"
!

quit
    self closeRequest

    "Modified: 26.3.1997 / 17:31:40 / cg"
!

remoteDirectoryChanged
    |remoteDir|

    ftpClient notNil ifTrue:[
	remoteDir := self remoteDirectoryHolder value.
	remoteDir notNil ifTrue:[
	    FTPClient fileNotFoundErrorSignal handle:[:ex |
		self activityNotification:'no such directory'.
		^ self
	    ] do:[
		FTPClient ftpErrorSignal handle:[:ex |
		    self activityNotification:(ex errorString).
		    ^ self
		] do:[
		    self withCursor:Cursor wait do:[
			ftpClient cd:remoteDir.
		    ]
		]
	    ].
	]
    ].
    self updateRemoteList

    "Created: 27.3.1997 / 11:37:25 / cg"
    "Modified: 2.4.1997 / 12:34:56 / cg"
!

remoteFileSelectionChanged

    "Modified: 28.3.1997 / 22:20:13 / cg"
!

showFile
    |line filename in contents textBox|

    line := self remoteFileList selection.
    line isNil ifTrue:[
	self activityNotification:'show: select a remote file first'.
	^ self
    ].
    filename := line asCollectionOfWords last.

    self transferProgressHolder value:0.
    (builder componentAt:#progressIndicator) beVisible.

    self withCursor:Cursor read do:[
	self activityNotification:'transferring ''' , filename , ''' ...'.

	FTPClient transmissionErrorSignal handle:[:ex |
	    self activityNotification:ex errorString.
	] do:[
	    ftpClient binary.
	    contents := ftpClient get:filename.
	    self activityNotification:'''' , filename , ''' transferred.'.
	    self transferProgressHolder value:100.
	]
    ].

    (builder componentAt:#progressIndicator) beInvisible.

    self withWaitCursorDo:[
	textBox := TextBox new.
	textBox initialText:contents asString.
	textBox title:'Contents of ' , filename , ':'.
	textBox readOnly:true.
	textBox noCancel.
	textBox label:filename.
	textBox extent:(600@250); sizeFixed:true.
	textBox showAtPointer.
    ]

    "Created: 27.3.1997 / 15:11:28 / cg"
    "Modified: 29.3.1997 / 19:23:00 / cg"
!

showHelp
    |status text textBox|

    ftpClient isNil ifTrue:[
	self warn:'Not connected'.
	^ self
    ].

    status := ftpClient help.
    status isNil ifTrue:[
	text := 'Help command not implemented by ftp-server'
    ] ifFalse:[
	text := status asStringCollection
    ].

    textBox := TextBox new.
    textBox initialText:text.
    textBox title:'Help response:'.
    textBox readOnly:true.
    textBox noCancel.
    textBox label:'HELP'.
    textBox extent:(600@250); sizeFixed:true.
    textBox showAtPointer.

!

showStatus
    |status text textBox|

    status := ftpClient systemStatus.
    status isNil ifTrue:[
	text := 'Status command not implemented by ftp-server'
    ] ifFalse:[
	text := status asStringCollection
    ].

    textBox := TextBox new.
    textBox initialText:text.
    textBox title:'Status response:'.
    textBox readOnly:true.
    textBox noCancel.
    textBox label:'STATUS'.
    textBox extent:(600@250); sizeFixed:true.
    textBox showAtPointer.

! !

!FTPTool methodsFor:'aspects'!

binaryModeHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#binaryModeHolder) isNil ifTrue:[
	builder aspectAt:#binaryModeHolder put:(holder := true asValue).
    ].
    ^ holder

    "Created: 26.3.1997 / 15:08:57 / cg"
    "Modified: 26.3.1997 / 15:09:54 / cg"
!

getEnableHolder
    |holder|

    (holder := builder bindingAt:#getEnableHolder) isNil ifTrue:[
	builder aspectAt:#getEnableHolder put:(holder :=  false asValue).
    ].
    ^ holder

    "Created: 26.3.1997 / 15:56:36 / cg"
    "Modified: 28.3.1997 / 20:48:20 / cg"
!

hostNameHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#hostNameHolder) isNil ifTrue:[
	builder aspectAt:#hostNameHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder

    "Created: 26.3.1997 / 15:56:36 / cg"
!

localDirectoryHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#localDirectoryHolder) isNil ifTrue:[
	builder aspectAt:#localDirectoryHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder

    "Created: 27.3.1997 / 11:34:08 / cg"
!

localFileList
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#localFileList) isNil ifTrue:[
	builder aspectAt:#localFileList put:(holder :=  SelectionInList new).
    ].
    ^ holder

    "Created: 26.3.1997 / 15:08:57 / cg"
    "Modified: 26.3.1997 / 15:09:50 / cg"
!

localLongListHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#localLongListHolder) isNil ifTrue:[
	builder aspectAt:#localLongListHolder put:(holder :=  true asValue).
    ].
    ^ holder

    "Modified: 28.3.1997 / 19:17:55 / cg"
    "Created: 28.3.1997 / 20:09:25 / cg"
!

passwordHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#passwordHolder) isNil ifTrue:[
	builder aspectAt:#passwordHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder

    "Created: 26.3.1997 / 15:56:36 / cg"
!

portHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#portHolder) isNil ifTrue:[
	builder aspectAt:#portHolder put:(holder := (Socket portOfService:'ftp') asValue).
    ].
    ^ holder

    "Created: 26.3.1997 / 15:56:36 / cg"
!

putEnableHolder
    |holder|

    (holder := builder bindingAt:#putEnableHolder) isNil ifTrue:[
	builder aspectAt:#putEnableHolder put:(holder :=  false asValue).
    ].
    ^ holder

    "Created: 28.3.1997 / 20:50:21 / cg"
!

remoteDirectoryHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#remoteDirectoryHolder) isNil ifTrue:[
	builder aspectAt:#remoteDirectoryHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder

    "Created: 27.3.1997 / 11:33:08 / cg"
    "Modified: 27.3.1997 / 11:33:40 / cg"
!

remoteFileList
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#remoteFileList) isNil ifTrue:[
	builder aspectAt:#remoteFileList put:(holder :=  SelectionInList new).
    ].
    ^ holder

    "Created: 26.3.1997 / 15:08:57 / cg"
    "Modified: 26.3.1997 / 15:09:54 / cg"
!

remoteLongListHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#remoteLongListHolder) isNil ifTrue:[
	builder aspectAt:#remoteLongListHolder put:(holder :=  true asValue).
    ].
    ^ holder

    "Modified: 28.3.1997 / 19:17:55 / cg"
    "Created: 28.3.1997 / 20:09:30 / cg"
!

transferProgressHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#transferProgressHolder) isNil ifTrue:[
	builder aspectAt:#transferProgressHolder put:(holder := 0 asValue).
    ].
    ^ holder

    "Created: 29.3.1997 / 16:45:58 / cg"
!

userNameHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#userNameHolder) isNil ifTrue:[
	builder aspectAt:#userNameHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder

    "Created: 26.3.1997 / 15:56:36 / cg"
! !

!FTPTool methodsFor:'events'!

closeRequest
    self disConnect.
    super closeRequest

    "Created: 26.3.1997 / 17:31:37 / cg"
! !

!FTPTool methodsFor:'intitialization'!

postBuildWith:aBuilder
    |host dom|

    super postBuildWith:aBuilder.

    self localLongListHolder value:true.
    self localLongListHolder onChangeSend:#updateLocalList to:self.
    self remoteLongListHolder value:true.
    self remoteLongListHolder onChangeSend:#updateRemoteList to:self.

    self userNameHolder value:'anonymous'.
    host := OperatingSystem getHostName.
    (host includes:$.) ifFalse:[
	dom := OperatingSystem getDomainName.
	dom size > 0 ifTrue:[
	    host := host , '.' , dom
	].
    ].
    self passwordHolder value:(OperatingSystem getLoginName
			       , '@'
			       , host).

    self localDirectoryHolder value:(Filename currentDirectory pathName).
    self updateLocalList.

    self localDirectoryHolder onChangeSend:#localDirectoryChanged to:self.
    self remoteDirectoryHolder onChangeSend:#remoteDirectoryChanged to:self.

    FTPClient isNil ifTrue:[
	Smalltalk loadPackage:'stx:goodies/communication'
    ].

    "
     self open
    "

    "Modified: / 27.7.1998 / 20:09:03 / cg"
! !

!FTPTool methodsFor:'private'!

updateLists
    self updateLocalList.
    ftpClient notNil ifTrue:[
	self updateRemoteList
    ].

    "Created: 28.3.1997 / 19:19:14 / cg"
!

updateLocalList
    |p list cmd|

    OperatingSystem isUNIXlike ifTrue:[
	self localLongListHolder value ifTrue:[
	    cmd := 'ls -l'
	] ifFalse:[
	    cmd := 'ls'
	]
    ] ifFalse:[
	OperatingSystem isVMSlike ifTrue:[
	    self localLongListHolder value ifTrue:[
		cmd := 'dir/columns=1/size/owner/times'
	    ] ifFalse:[
		cmd := 'dir/columns=1'
	    ]
	] ifFalse:[
	    self localLongListHolder value ifTrue:[
		cmd := 'dir'
	    ] ifFalse:[
		cmd := 'dir'
	    ]
	]
    ].

    p := PipeStream
	    readingFrom:cmd
	    inDirectory:self localDirectoryHolder value.
    list := p contents.
    p close.
    self localFileList list:(list asStringCollection).

    "Modified: 28.3.1997 / 22:19:52 / cg"
!

updateRemoteList
    |list dir|

    ftpClient isNil ifTrue:[
	self remoteDirectoryHolder value notNil ifTrue:[
	    self remoteDirectoryHolder value:nil.
	    self remoteFileList list:nil.
	].
	^ self
    ].

    self withCursor:Cursor read do:[
	FTPClient ftpErrorSignal handle:[:ex |
	    self activityNotification:(ex errorString).
	    self remoteFileList list:nil.
	    ^ self
	] do:[
	    dir := ftpClient pwd.
	    dir ~= self remoteDirectoryHolder value ifTrue:[
		self remoteDirectoryHolder value:dir withoutNotifying:self.
	    ].
	    FTPClient ftpErrorSignal handle:[:ex |
		ftpClient passiveMode:true.
		self remoteLongListHolder value ifTrue:[
		    list := ftpClient list.
		] ifFalse:[
		    list := ftpClient nlist.
		    list sort.
		].
	    ] do:[
		self remoteLongListHolder value ifTrue:[
		    list := ftpClient list.
		] ifFalse:[
		    list := ftpClient nlist.
		    list sort.
		].
	    ]
	]
    ].
    self remoteFileList list:(list asStringCollection).

    "Created: 26.3.1997 / 17:45:33 / cg"
    "Modified: 29.3.1997 / 13:19:44 / cg"
! !

!FTPTool methodsFor:'private - actions'!

doGet:remoteFilename asLocal:localFileName
    |out in buffer n t rate fileSize bytesTransferred percent|

    out := localFileName writeStream.

    self transferProgressHolder value:0.
    (builder componentAt:#progressIndicator) beVisibleNow.

    self activityNotification:'transferring ''' , remoteFilename , ''' ...'.

    FTPClient transmissionErrorSignal handle:[:ex |
	self activityNotification:ex errorString.
    ] do:[
	ftpClient binary.
	fileSize := ftpClient sizeOf:remoteFilename.

	in := ftpClient getStreamFor:remoteFilename.

	buffer := ByteArray new:(self class transferBufferSize).
	t := Time millisecondsToRun:[
	    bytesTransferred := 0.
	    [in atEnd] whileFalse:[
		fileSize notNil ifTrue:[
		    percent := (bytesTransferred / fileSize) * 100.
		    self transferProgressHolder value:percent.
		    builder window device flush.
		].
		in readWait.
		n := in nextBytes:(buffer size) into:buffer.
		out nextPutBytes:n from:buffer.
		bytesTransferred := bytesTransferred + n.
	    ].
	].
	self transferProgressHolder value:100.
	builder window device flush.

	in close.
	(t = 0 or:[(rate := (out size / t)) = 0]) ifTrue:[
	    self activityNotification:'''' , remoteFilename , ''' transferred'.
	] ifFalse:[
	    rate := rate asFixedPoint:3.
	    self activityNotification:'''' , remoteFilename , ''' transferred ('
					   , rate printString , ' kb/sec)'.
	]
    ].
    out close.
    (builder componentAt:#progressIndicator) beInvisible.

    "Created: 28.3.1997 / 22:23:56 / cg"
    "Modified: 3.4.1997 / 21:24:59 / cg"
!

putFile:localFileName asRemote:remoteFileName
    |in out buffer n t rate fileSize bytesTransferred percent|

    in := localFileName asFilename readStream.
    in binary.

    fileSize := localFileName asFilename fileSize.

    self transferProgressHolder value:0.
    (builder componentAt:#progressIndicator) beVisibleNow.

    self activityNotification:'transferring ''' , localFileName , ''' ...'.

    ftpClient binary.
    FTPClient transmissionErrorSignal handle:[:ex |
	self activityNotification:ex errorString.
    ] do:[
	out := ftpClient putStreamFor:remoteFileName.

	t := Time millisecondsToRun:[
	    buffer := ByteArray new:(self class transferBufferSize).
	    [in atEnd] whileFalse:[
		percent := (bytesTransferred / fileSize) * 100.
		self transferProgressHolder value:percent.

		n := in nextBytes:(buffer size) into:buffer.
		out writeWait.
		out nextPutBytes:n from:buffer.
		bytesTransferred := bytesTransferred + n.
	    ].
	].
	self transferProgressHolder value:100.

	out close.

	rate := (out size / t) asFixedPoint:3.
	self activityNotification:'''' , localFileName , ''' transferred ('
				       , rate printString , ' kb/sec)'.
    ].

    (builder componentAt:#progressIndicator) beInvisible.
    in close.

    "Created: 28.3.1997 / 22:25:28 / cg"
    "Modified: 3.4.1997 / 21:25:04 / cg"
! !

!FTPTool methodsFor:'user information'!

activityNotification:aString
    |infoLabel|

    (infoLabel := builder componentAt:#infoLabel) label:aString.
    infoLabel redraw

    "Modified: 29.3.1997 / 14:39:49 / cg"
! !

!FTPTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Tools/FTPTool.st,v 1.29 2016-04-20 21:09:27 mawalch Exp $'
! !
