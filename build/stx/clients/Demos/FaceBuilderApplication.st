"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: Demos }"

ApplicationModel subclass:#FaceBuilderApplication
	instanceVariableNames:'mundWert nasenWert augenWert rechterOhrWert getVStepSlider
		linkerOhrWert'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Tutorial'
!

!FaceBuilderApplication class methodsFor:'documentation'!

documentation
"
    Timos learning application (use of valueHolders, embedded widgets etc).

    [author:]
        Timo Merkert (tm@idefix)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!FaceBuilderApplication class methodsFor:'image specs'!

exitIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self exitIcon inspect
     ImageEditor openOnClass:self andSelector:#exitIcon
    "

    <resource: #image>

    ^Icon
        constantNamed:#'MySmilyFace2 exitIcon'
        ifAbsentPut:[(Depth8Image new) width: 32; height: 24; photometric:(#palette); bitsPerSample:(#(8 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BA @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B@,A@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DFA XMCQHTE @@@@@@@@@@@@@@@@@@@@@@@@@@@P4MDQ\QFA\LAQDF@ DA@PX@@@PDA@@@@@@ACPXAA!!XVE00TD1PTC@TE@ $RD0,KC1HLC $NC @@@@DRE 4RB1TTEA,TEA@R@10BE!!HLC@<UC0TLB0,O@@@@A!!HKB0,WCA\LEAPRC LHG@ RD XFA XF@PXD@@@@@@@BE1 KD ,PC@,LD0<NC 8HEQ(^G 4@@@@@@@@@@@@@@@XKFALKB1@PB0TEDPTOBQHRFQ$_G0@@@@@@@@@@@@@@A TKB0,RC@<ED!!TXB08B@0HEG1$Y@@@@@@@@@@@@@@@FDQLKB0,RB0,LFAPTBP HEQ(V@@@@@@@@@@@@@@@@@@XKD1LLD1 TF1(ZF1PUBPTTG!!$M@@@@@@@@@@@@@@@@@QHRDQTTEA,TF1(TE@LPBAH^G0X@@@@@@@@@@@@@@@@@@P$RD00TEAPTEALS@10HF1X@@@@@@@@@@@@@@@@@@@@@@@DFB00LEA(LC0<CE!!4[G @@@@@@@@@@@@@@@@@@@@@@@@@DA XFB0,RE0<HD!!$Y@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@A@DD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 121 36 8 140 45 17 169 65 35 68 18 6 227 121 60 130 77 36 138 81 0 173 30 19 167 79 32 239 113 105 195 117 65 207 130 73 148 89 47 207 101 52 219 100 57 185 111 77 186 115 36 186 97 48 205 121 52 215 138 81 227 109 60 161 108 57 173 129 72 201 136 70 208 152 87 231 146 89 235 154 81 138 4 0 241 134 107 219 167 98 231 185 121 44 0 0 0 0 64 0 48 0 0 5 254 32 32 142 100 105 158 104 170 174 108 235 190 112 44 207 116 109 223 120 174 239 124 239 255 64 91 32 16 236 9 6 132 162 78 32 40 24 148 183 192 1 145 80 60 161 53 3 117 193 32 98 97 6 67 160 225 40 60 32 141 47 42 16 14 55 220 232 136 100 66 169 88 212 36 182 225 109 233 95 48 23 22 129 11 19 19 21 20 16 87 60 73 107 99 13 22 143 114 23 19 17 11 24 20 127 12 20 5 11 17 15 98 2 0 67 1 2 68 98 0 79 4 170 171 41 6 22 97 94 34 164 143 22 18 147 92 133 154 25 187 26 20 12 11 18 18 14 3 3 144 17 13 17 144 181 111 18 2 9 9 13 143 174 22 177 121 209 111 165 2 123 22 16 22 11 23 12 225 20 20 19 151 227 190 155 18 5 3 2 7 9 181 15 19 191 11 132 15 193 14 12 17 14 14 9 251 3 252 38 92 73 232 19 205 64 37 96 16 232 105 26 119 8 67 47 95 21 238 29 96 130 96 64 129 57 242 42 208 171 80 200 94 129 143 31 241 133 187 83 34 64 173 5 4 254 79 114 169 112 225 28 133 13 46 25 64 8 150 128 29 7 38 7 44 36 144 192 37 220 130 7 12 42 48 120 0 114 232 2 141 102 170 137 48 0 97 38 48 9 16 46 208 139 218 18 29 133 14 190 38 72 216 201 78 0 2 1 28 14 236 75 32 231 80 184 12 20 50 208 195 197 229 66 34 54 140 72 8 228 73 143 231 133 187 12 238 102 165 208 139 129 58 126 3 56 32 64 32 24 193 197 96 7 218 40 110 163 71 213 10 3 223 230 173 77 152 112 1 166 158 224 24 124 172 73 236 200 96 7 124 199 93 88 114 215 210 132 186 60 155 134 211 232 243 52 209 97 252 28 12 150 80 65 131 6 15 184 113 167 177 97 64 106 230 211 63 135 178 190 32 212 239 130 139 23 249 21 24 6 65 129 237 13 30 118 229 86 52 195 21 23 64 148 128 77 173 0 97 30 167 139 17 34 92 124 240 204 1 212 57 25 62 100 240 240 161 61 117 25 1 192 17 162 176 54 53 23 8 167 191 171 11 122 116 159 249 7 196 36 112 65 123 4 126 240 94 12 174 20 254 240 203 105 192 241 228 215 3 199 5 19 1 71 24 252 34 204 87 196 96 88 64 2 237 165 151 65 20 15 208 71 14 61 167 89 104 15 79 60 209 33 207 6 132 56 192 193 139 97 5 211 0 4 99 132 129 3 83 17 48 32 207 55 92 116 18 204 90 225 96 96 78 95 9 12 102 100 109 26 4 178 67 124 28 45 184 99 120 36 46 244 16 95 26 32 37 219 103 27 104 144 193 6 25 92 160 20 13 214 197 147 75 56 242 8 201 215 6 89 218 182 101 47 71 109 101 81 1 124 225 182 222 110 55 24 240 35 132 102 48 112 201 67 90 66 247 28 151 89 45]; yourself]
! !

!FaceBuilderApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MySmilyFace2 andSelector:#windowSpec
     MySmilyFace2 new openInterface:#windowSpec
     MySmilyFace2 open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'NewApplication'
              #layout: #(#LayoutFrame 12 0 22 0 442 0 536 0)
              #label: 'NewApplication'
              #min: #(#Point 600 500)
              #max: #(#Point 800 800)
              #bounds: #(#Rectangle 12 22 443 537)
              #menu: #menu
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#ViewSpec
                    #name: 'AussererFrame'
                    #layout: #(#LayoutFrame 0 0.2 10 0 0 0.8 0 0.8)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#ViewSpec
                              #name: 'innererFrame'
                              #layout: #(#LayoutFrame 10 0 10 0 -3 1 -3 1)
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#ArbitraryComponentSpec
                                        #name: 'funView'
                                        #layout: #(#LayoutFrame 8 0.0 8 0.0 -2 1.0 -2 1.0)
                                        #component: #getSmilyView
                                        #hasBorder: false
                                    )
                                  )
                              )
                              #level: -3
                              #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                          )
                        )
                    )
                    #level: 3
                    #backgroundColor: #(#Color 0.0 86.9993 0.0)
                )
                 #(#LabelSpec
                    #name: 'Label4'
                    #layout: #(#LayoutFrame 0 0 4 0 0 0.2 21 0)
                    #label: 'Linkes Ohr'
                    #translateLabel: true
                    #resizeForLabel: true
                )
                 #(#InputFieldSpec
                    #name: 'EntryField4'
                    #layout: #(#LayoutFrame 15 0 25 0 75 0 47 0)
                    #initiallyDisabled: true
                    #model: #linkerOhrWert
                    #type: #number
                )
                 #(#HorizontalPanelViewSpec
                    #name: 'linkesOhr'
                    #layout: #(#LayoutFrame 0 0 50 0 0 0.2 0 0.8)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#ArbitraryComponentSpec
                              #name: 'SliderLinkesOhr'
                              #model: #linkerOhrWert
                              #component: #getVStepSlider
                              #hasBorder: false
                              #extent: #(#Point 23 322)
                          )
                        )
                    )
                    #horizontalLayout: #center
                    #verticalLayout: #center
                    #horizontalSpace: 3
                    #verticalSpace: 20
                )
                 #(#LabelSpec
                    #name: 'Label5'
                    #layout: #(#LayoutFrame 0 0.8 4 0 0 1.0 21 0)
                    #label: 'Rechtes Ohr'
                    #translateLabel: true
                    #resizeForLabel: true
                )
                 #(#InputFieldSpec
                    #name: 'EntryField5'
                    #layout: #(#LayoutFrame -79 1 25 0 -19 1 47 0)
                    #initiallyDisabled: true
                    #model: #rechterOhrWert
                    #type: #number
                )
                 #(#HorizontalPanelViewSpec
                    #name: 'rechtesOhr'
                    #layout: #(#LayoutFrame 0 0.8 50 0 0 1.0 0 0.8)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#ArbitraryComponentSpec
                              #name: 'SliderRechtesOhr'
                              #model: #rechterOhrWert
                              #component: #getVStepSlider
                              #hasBorder: false
                              #extent: #(#Point 23 332)
                          )
                        )
                    )
                    #horizontalLayout: #center
                    #verticalLayout: #center
                    #horizontalSpace: 3
                    #verticalSpace: 3
                )
                 #(#VerticalPanelViewSpec
                    #name: 'VerticalPanel1'
                    #layout: #(#LayoutFrame 0 0 0 0.8 0 0.8 0 1)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#HorizontalPanelViewSpec
                              #name: 'Augen'
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#LabelSpec
                                        #name: 'Label1'
                                        #label: 'Augen'
                                        #translateLabel: true
                                        #extent: #(#Point 60 22)
                                    )
                                     #(#InputFieldSpec
                                        #name: 'EntryField3'
                                        #initiallyDisabled: true
                                        #model: #augenWert
                                        #type: #number
                                        #extent: #(#Point 60 22)
                                    )
                                     #(#ArbitraryComponentSpec
                                        #name: 'ArbitraryComponent1'
                                        #model: #augenWert
                                        #component: #getHStepSlider
                                        #hasBorder: false
                                        #extent: #(#Point 219 23)
                                    )
                                  )
                              )
                              #horizontalLayout: #leftFit
                              #verticalLayout: #center
                              #horizontalSpace: 3
                              #verticalSpace: 3
                              #extent: #(#Point 345 33)
                          )
                           #(#HorizontalPanelViewSpec
                              #name: 'Nase'
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#LabelSpec
                                        #name: 'Label2'
                                        #label: 'Nase'
                                        #translateLabel: true
                                        #extent: #(#Point 60 22)
                                    )
                                     #(#InputFieldSpec
                                        #name: 'EntryField1'
                                        #initiallyDisabled: true
                                        #model: #nasenWert
                                        #type: #number
                                        #extent: #(#Point 60 22)
                                    )
                                     #(#ArbitraryComponentSpec
                                        #name: 'ArbitraryComponent2'
                                        #model: #nasenWert
                                        #component: #getHStepSlider
                                        #hasBorder: false
                                        #extent: #(#Point 219 23)
                                    )
                                  )
                              )
                              #horizontalLayout: #leftFit
                              #verticalLayout: #center
                              #horizontalSpace: 3
                              #verticalSpace: 3
                              #extent: #(#Point 345 33)
                          )
                           #(#HorizontalPanelViewSpec
                              #name: 'Mund'
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#LabelSpec
                                        #name: 'Label3'
                                        #label: 'Mund'
                                        #translateLabel: true
                                        #resizeForLabel: true
                                        #extent: #(#Point 60 22)
                                    )
                                     #(#InputFieldSpec
                                        #name: 'EntryField2'
                                        #initiallyDisabled: true
                                        #model: #mundWert
                                        #type: #number
                                        #extent: #(#Point 60 22)
                                    )
                                     #(#ArbitraryComponentSpec
                                        #name: 'ArbitraryComponent3'
                                        #model: #mundWert
                                        #component: #getHStepSlider
                                        #hasBorder: false
                                        #extent: #(#Point 219 23)
                                    )
                                  )
                              )
                              #horizontalLayout: #leftFit
                              #verticalLayout: #center
                              #horizontalSpace: 3
                              #verticalSpace: 3
                              #extent: #(#Point 345 33)
                          )
                        )
                    )
                    #horizontalLayout: #fit
                    #verticalLayout: #fit
                    #horizontalSpace: 3
                    #verticalSpace: 2
                )
                 #(#ActionButtonSpec
                    #name: 'Button1'
                    #layout: #(#LayoutOrigin -86 1.0 -28 1.0)
                    #label: 'und Tschüß...'
                    #translateLabel: true
                    #model: #closeRequest
                )
              )
          )
      )
! !

!FaceBuilderApplication class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Demos::FaceBuilderApplication andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(Demos::FaceBuilderApplication menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'About'
            #translateLabel: true
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'About this Application...'
                  #itemValue: #MyShowAbout
                  #translateLabel: true
                )
               )
              nil
              nil
            )
          )
         #(#MenuItem
            #label: 'File'
            #translateLabel: true
            #submenu: 
           #(#Menu
              #(
               #(#MenuItem
                  #label: 'Open'
                  #itemValue: #MyFileOpen
                  #translateLabel: true
                )
               #(#MenuItem
                  #label: 'Save as...'
                  #itemValue: #MyFileSaveAs
                  #translateLabel: true
                )
               #(#MenuItem
                  #label: '-'
                )
               #(#MenuItem
                  #activeHelpKey: #helpExit
                  #label: 'Exit'
                  #itemValue: #closeRequest
                  #translateLabel: true
                  #labelImage: #(#ResourceRetriever #MySmilyFace2 #exitIcon 'Exit')
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
                  #label: 'How to Modify Faces'
                  #itemValue: #MyShowHelp
                  #translateLabel: true
                  #accessCharacterPosition: -30
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

!FaceBuilderApplication methodsFor:'aspects'!

augenWert
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    augenWert isNil ifTrue:[
        augenWert :=  ValueHolder new value:0.
    ].
    ^ augenWert.
!

linkerOhrWert
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    linkerOhrWert isNil ifTrue:[
        linkerOhrWert :=  ValueHolder new value:0.
    ].
    ^ linkerOhrWert.
!

mundWert
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    mundWert isNil ifTrue:[
        mundWert :=  ValueHolder new value:0.
    ].
    ^ mundWert.
!

nasenWert
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    nasenWert isNil ifTrue:[
        nasenWert :=  ValueHolder new value:0.
    ].
    ^ nasenWert.
!

rechterOhrWert
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    rechterOhrWert isNil ifTrue:[
        rechterOhrWert :=  ValueHolder new value:0.
    ].
    ^ rechterOhrWert.
! !

!FaceBuilderApplication methodsFor:'hooks'!

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
    "automatically generated by UIPainter ..."

    "*** the code here does nothing. It is invoked when"
    "*** the widgets have been built, but before the view is opened"
    "*** Please change as required and accept in the browser."

    "specific code to be added below ..."
    "or after the super send"

    |view|

    augenWert value:50.
    nasenWert value:50.
    mundWert value:50.

    view := (aBuilder componentAt:#funView).
    view := view scrolledView.
    view mundHolder:mundWert.
    view nasenHolder:nasenWert.
    view augenHolder:augenWert.
    view rechtesOhrHolder:rechterOhrWert.
    view linkesOhrHolder:linkerOhrWert.

    super postBuildWith:aBuilder
! !

!FaceBuilderApplication methodsFor:'menuEvent'!

MyFileOpen
    |box fbox fileName dic fstream fehler smilyView|
    box := FileSelectionBox new.
    box label: 'open a file'.
    box title:'Filter:'.
    box pattern:'*.fac'.
    box enterField contents:'MySmily.fac'.
    box open.
    box accepted 
    ifTrue:[ "wenn Dateiname bestaetigt"

             "smilyView"
             smilyView := builder componentAt:#funView.

             Transcript showCR:'path is ' , box pathName.
             Transcript showCR:'full path:  ' , box pathName.
             Transcript showCR:'files name: ' , box fileName.
             "/Transcript showCR:'directory : ' , box directory.
             fileName := box enterField contents.
             Object errorSignal 
             handle:[:ex |    "Exception-Behandlungsblock"
                      "Dialogbox mit Fehlerinformation"
                      fbox := WarningBox title:'Datei ist fehlerhaft (' ,ex errorString ,')'.
                      fbox okText:'OK'.
                      fbox showAtPointer.
                      ex proceedWith:20.
                     ] do:[ "Datei lesen"
                           fstream := FileStream readonlyFileNamed: fileName.
                           fstream notNil 
                           ifTrue: [ "wenn Filestream ok"
                                     dic := Object  readFrom:fstream.
                                     "Werte eintragen"
                                     smilyView augenHolder value:(dic at:#augenWert).
                                     smilyView nasenHolder value:(dic at:#nasenWert).
                                     smilyView mundHolder value: (dic at:#mundWert).
                                     smilyView linkesOhrHolder value: (dic at:#linkerOhrWert).
                                     smilyView rechtesOhrHolder value:(dic at:#rechterOhrWert).
                                     fstream close.
                                   ]"fstream !!= Nil"
                           ifFalse:[ "wenn Filestream nicht ok, Datei is nich"
                                     fbox := WarningBox title:'Datei ist nicht vorhanden'.
                                     fbox okText:'OK'.
                                     fbox showAtPointer.
                                   ]."fstream = Nil"

                         ]."do Aktionsende"
           ]."box accepted = true"
!

MyFileSaveAs
    |box fileName a1 dic fstream|
    box := FileSelectionBox new.
    box label: 'File save as ...'.
    box title:'Filter:'.
    box pattern:'*.fac'.
    box listView ignoreDirectories:true.
    box enterField contents:'MySmily.fac'.
    box open.
    box accepted ifTrue:[ "wenn Dateiname bestaetigt"
                Transcript showCR:'path is ' , box pathName.
                Transcript showCR:'full path:  ' , box pathName.
                Transcript showCR:'files name: ' , box fileName.
                "/Transcript showCR:'directory : ' , box directoryName.
                fileName := box enterField contents.
    dic := Dictionary  new.
    dic at:#augenWert      put:augenWert value.
    dic at:#nasenWert      put:nasenWert value.
    dic at:#mundWert       put:mundWert value.
    dic at:#linkerOhrWert  put:linkerOhrWert value.
    dic at:#rechterOhrWert put:rechterOhrWert value.

    "/dic inspect.
    fstream := FileStream newFileNamed:fileName.
    dic storeOn:fstream.
    fstream close.
    ]."ifTrue Aktionsende"
 
!

MyShowAbout
    |a|

    a := AboutBox new.
    a viewBackground:(Color yellow) darkened.
 
    a label:'About Smily Faces ...'.
    a formLabel backgroundColor:(Color green) darkened.
    a formLabel foregroundColor:Color white.

    a background:(Color yellow).
    a viewBackground:(Color yellow) darkened.

    "message"
    a title:'   smily Faces

    just try and wonder         

    but no hope                 


    Have fun.
'.


    a show 
!

MyShowHelp
    |h|

    h := AboutBox new.
    h label:'About Smily Faces ...'.
    h maskOrigin:0.2@0.2.
    h title:'smily Faces

    learning by dooing          

    Have fun.
'.
    h formLabel foregroundColor:Color white.
    h show .
    ^h
! !

!FaceBuilderApplication methodsFor:'views'!

getHStepSlider
    ^ HorizontalSteppingSlider new
!

getSmilyView
    ^ SmilyView new
!

getVStepSlider
    |s|

    s := SteppingSlider new.
    s start:-50 stop:50 step:1.
    ^ s
! !

!FaceBuilderApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/FaceBuilderApplication.st,v 1.4 2003-01-16 10:47:46 cg Exp $'
! !
