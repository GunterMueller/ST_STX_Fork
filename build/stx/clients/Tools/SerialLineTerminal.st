"{ Package: 'stx:clients/Tools' }"

TelnetTool subclass:#SerialLineTerminal
	instanceVariableNames:'connection serialLine speed parity dataBits stopBits'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Tools-System'
!


!SerialLineTerminal class methodsFor:'interface specs'!

portConfigurationSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SerialLineTerminal andSelector:#portConfigurationSpec
     SerialLineTerminal new openInterface:#portConfigurationSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #portConfigurationSpec
        #window: 
       #(#WindowSpec
          #label: 'NewApplication'
          #name: 'NewApplication'
          #min: #(#Point 10 10)
          #max: #(#Point 1280 1024)
          #bounds: #(#Rectangle 12 22 312 322)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#LabelSpec
              #label: 'Serial Line:'
              #name: 'Label1'
              #layout: #(#LayoutFrame 20 0 40 0 120 0 62 0)
              #translateLabel: true
              #adjust: #right
            )
           #(#ComboBoxSpec
              #name: 'ComboBox1'
              #layout: #(#LayoutFrame 120 0 40 0 -5 1 62 0)
              #model: #serialLineHolder
              #acceptOnPointerLeave: false
              #comboList: #serialLineList
            )
           #(#LabelSpec
              #label: 'Speed:'
              #name: 'Label2'
              #layout: #(#LayoutFrame 20 0 69 0 120 0 91 0)
              #translateLabel: true
              #adjust: #right
            )
           #(#PopUpListSpec
              #label: '9600'
              #name: 'PopUpList1'
              #layout: #(#LayoutFrame 120 0 69 0 -5 1 91 0)
              #adjust: #right
              #model: #speedHolder
              #menu: #speedList
              #useIndex: false
            )
           #(#LabelSpec
              #label: 'Parity:'
              #name: 'Label3'
              #layout: #(#LayoutFrame 20 0 99 0 120 0 121 0)
              #translateLabel: true
              #adjust: #right
            )
           #(#PopUpListSpec
              #label: 'none'
              #name: 'PopUpList2'
              #layout: #(#LayoutFrame 120 0 99 0 -5 1 121 0)
              #adjust: #right
              #model: #parityHolder
              #menu: #parityList
              #useIndex: false
            )
           #(#LabelSpec
              #label: 'Data Bits:'
              #name: 'Label4'
              #layout: #(#LayoutFrame 20 0 129 0 120 0 151 0)
              #translateLabel: true
              #adjust: #right
            )
           #(#PopUpListSpec
              #label: '8'
              #name: 'PopUpList3'
              #layout: #(#LayoutFrame 120 0 129 0 -5 1 151 0)
              #adjust: #right
              #model: #dataBitsHolder
              #menu: #dataBitsList
              #useIndex: false
            )
           #(#LabelSpec
              #label: 'Stop Bits:'
              #name: 'Label5'
              #layout: #(#LayoutFrame 20 0 159 0 120 0 181 0)
              #translateLabel: true
              #adjust: #right
            )
           #(#PopUpListSpec
              #label: '1'
              #name: 'PopUpList4'
              #layout: #(#LayoutFrame 120 0 159 0 -5 1 181 0)
              #adjust: #right
              #model: #stopBitsHolder
              #menu: #stopBitsList
              #useIndex: false
            )
           #(#HorizontalPanelViewSpec
              #name: 'HorizontalPanel1'
              #layout: #(#LayoutFrame 0 0.0 -30 1 0 1.0 0 1.0)
              #horizontalLayout: #center
              #verticalLayout: #center
              #horizontalSpace: 3
              #verticalSpace: 3
              #reverseOrderIfOKAtLeft: true
              #component: 
             #(#SpecCollection
                #collection: #(
                 #(#ActionButtonSpec
                    #label: 'Cancel'
                    #name: 'Button1'
                    #translateLabel: true
                    #model: #cancel
                    #extent: #(#Point 125 22)
                  )
                 #(#ActionButtonSpec
                    #label: 'OK'
                    #name: 'Button2'
                    #translateLabel: true
                    #model: #accept
                    #isDefault: true
                    #extent: #(#Point 125 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!SerialLineTerminal class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SerialLineTerminal andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(SerialLineTerminal menu)) startUp
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
                  #translateLabel: true
                  #value: #closeRequest
                )
               )
              nil
              nil
            )
          )
         #(#MenuItem
            #label: 'Configuration'
            #translateLabel: true
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Port'
                  #translateLabel: true
                  #value: #configurePort
                  #enabled: #notConnected
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
                  #label: 'ST/X Online Documentation'
                  #translateLabel: true
                  #value: #showDocumentation
                )
               #(#MenuItem
                  #label: '-'
                )
               #(#MenuItem
                  #label: 'About SerialLineTerminal...'
                  #translateLabel: true
                  #value: #showAbout
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

!SerialLineTerminal methodsFor:'actions'!

accept
    "automatically generated by UIPainter ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."

    "action to be added ..."

    Transcript showCR:self class name, ': action for accept ...'.
!

cancel
    "automatically generated by UIPainter ..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."

    "action to be added ..."

    Transcript showCR:self class name, ': action for cancel ...'.
! !

!SerialLineTerminal methodsFor:'aspects'!

dataBitsHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#dataBitsHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#dataBitsHolder put:holder.
    ].
    ^ holder.
!

dataBitsList
    ^ #( 
         '5' 
         '7'
         '8' 
        )


!

isConnected
    ^ [line notNil]


!

parityHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#parityHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#parityHolder put:holder.
    ].
    ^ holder.
!

parityList
    ^ #( 
         'odd' 
         'even'
         'none' 
         'mark'
        )


!

serialLineHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#serialLineHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#serialLineHolder put:holder.
    ].
    ^ holder.
!

serialLineList
    OperatingSystem isMSDOSlike ifTrue:[
        ^ #( 
             'COM1' 
             'COM2'
             'COM3'
             'COM4'
            )
    ].    
    ^ #( 
         '/dev/cua0' 
         '/dev/cua1'
         '/dev/cua2'
         '/dev/cua3'
        )
!

speedHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#speedHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#speedHolder put:holder.
    ].
    ^ holder.
!

speedList
    ^ #( 
         '50' 
         '75'
         '110' 
         "/ '134' 
         '150'
         '300'
         '600'
         '1200' 
         "/ '1600'
         "/ '1800'
         "/ '2000' 
         '2400' 
         "/ '3600'
         '4800' 
         "/ '7200'
         '9600'
         '19200'
         '38400'
         '57600'
         '115200'
        )


!

stopBitsHolder
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."

    |holder|

    (holder := builder bindingAt:#stopBitsHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#stopBitsHolder put:holder.
    ].
    ^ holder.
!

stopBitsList
    ^ #( 
         '0' 
         '1'
         '2' 
        )


! !

!SerialLineTerminal methodsFor:'initialization'!

postBuildWith:aBuilder
    self window label:'Terminal'.
    super postBuildWith:aBuilder
! !

!SerialLineTerminal methodsFor:'menu actions'!

configurePort
    "open a box asking for the hostname;
     connect to that host"

    self serialLineHolder value:serialLine.
    self speedHolder value:(speed ? 9600) printString.
    self parityHolder value:(parity ? 'none').
    self dataBitsHolder value:(dataBits ? 8) printString.
    self stopBitsHolder value:(stopBits ? 1) printString.

    (self openDialogInterface:#portConfigurationSpec) ifTrue:[
        self setupSerialLine
    ].


!

setupSerialLine
    ""
    |cmd|

    connection notNil ifTrue:[
        connection close.
        connection := nil
    ].

    serialLine := self serialLineHolder value.
    speed := Number readFrom:(self speedHolder value) onError:speed.
    parity := self parityHolder value.
    dataBits := Number readFrom:(self dataBitsHolder value) onError:dataBits.
    stopBits := Number readFrom:(self stopBitsHolder value) onError:stopBits.

    cmd := 'stty ' , speed printString , ' cs' , dataBits printString.
    parity = 'none' ifTrue:[
        cmd := cmd , ' -parenb'.
    ] ifFalse:[
        cmd := cmd , ' parenb'.
        parity = 'odd' ifTrue:[
            cmd := cmd , ' parodd'.
        ] ifFalse:[
            parity = 'even' ifTrue:[
                cmd := cmd , ' -parodd'.
            ] 
        ]
    ].
    stopBits == 2 ifTrue:[
        cmd := cmd , ' cstopb'.
    ] ifFalse:[
        cmd := cmd , ' -cstopb'.
    ].

    cmd := cmd , ' clocal cread crtscts'.
    cmd := cmd , ' -echo -icanon'.
    cmd := cmd , ' <' , serialLine.
"/ self halt.
    (OperatingSystem executeCommand:cmd) ifFalse:[
        self warn:'stty command failed'
    ].

    connection := serialLine asFilename readWriteStream.
    connection isNil ifTrue:[
        self warn:'cannot open serial line: ' , serialLine
    ] ifFalse:[
        connection buffered:false
    ]

! !

!SerialLineTerminal methodsFor:'misc user interface'!

showAbout
    "opens an about this application box"

    |rev box myClass clsRev image|

    rev := ''.
    myClass := self class.

    (clsRev := myClass revision) notNil ifTrue: [rev := '  (rev: ', clsRev printString, ')'].
    box := AboutBox title:
        '\Smalltalk/X SerialLine Terminal

Demonstrates use the VT100TerminalView class.

Written Jan-1999 by cg@exept.de' withCRs.

    image := self class icon.
    image notNil ifTrue:[
        box image:image
    ].
    box label:'About Telnet'.
    box autoHideAfter:10 with:[].
    box showAtPointer.

    "Modified: / 8.8.1998 / 01:12:17 / cg"


! !

!SerialLineTerminal class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Tools/SerialLineTerminal.st,v 1.2 2001-12-11 10:29:16 cg Exp $'
! !
