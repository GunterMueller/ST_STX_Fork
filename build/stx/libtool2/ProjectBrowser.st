"
 COPYRIGHT (c) 1999 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

ToolApplicationModel subclass:#ProjectBrowser
	instanceVariableNames:'projectTree modifiedChannel selectedTreeNodeHolder
		lastMoveToProject'
	classVariableNames:'AlreadCheckedExistingModulesAndPackages'
	poolDictionaries:''
	category:'Interface-Tools'
!

TreeItemWithImage subclass:#ProjectTreeItem
	instanceVariableNames:'action spec info'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectBrowser
!

ProjectBrowser::ProjectTreeItem subclass:#ProjectNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectBrowser
!

!ProjectBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"



!

documentation
"
    Obsolete - before even going into production...

    The new project browser & builder.
    This one will (eventually) make packaging of classLibraries and
    applications easier. 

    EXPERIMENTAL: not finished.

    [start with:]
        ProjectBrowser open

    [see also:]
        Project

    [author:]
        Claus Gittinger, eXept Software AG
"
! !

!ProjectBrowser class methodsFor:'class initialization'!

initialize
    "add myself to the launchers tool menu"

    |menuItem|
    menuItem := MenuItem new 
                    translateLabel: true;
                    value: [ProjectBrowser open];
                    label:'Project Builder' icon:nil;
                    nameKey: #projectBrowserIcon;
                    activeHelpKey: #projectBrowserIcon.

    NewLauncher 
        addMenuItem:menuItem 
        from:self
        in:'menu.tools' 
        position:#( #after #changesBrowser) 
        space:true.
"/    NewLauncher allInstancesDo:[:l |
"/        l addUserTool:'Project Builder' 
"/          action:[ProjectBrowser open] 
"/          in:#menu 
"/          after:'Changes Browser' 
"/          icon:self projectBrowserIcon 
"/          space:false
"/    ].

    "
     self initialize
    "
    "
     NewLauncher allInstancesDo:[:l |
        l removeUserTool:'Project Builder'
     ]
    "
! !

!ProjectBrowser class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:ProjectBrowser    
    "

    <resource: #help>

    ^super helpSpec addPairsFrom:#(

#accept
'Accept modifications made here.'

#appType
'An application - ie an executable program (and support files if any).'

#cancel
'Undo modifications made here.'

#defaultNamespace
'Namespace for new classes when created in the Browser.'

#deliverGZipArchive
'Package delivery into a gzip archive (for unix)'

#deliverTarArchive
'Package delivery into a tar archive (for unix)'

#deliverZipArchive
'Package delivery into a zip archive (for win32)'

#deliverCompiledBinary
'Create and deliver as compiled binary (classLibrary) - will only execute on the running systems architecture.'

#deliverByteCode
'Create and deliver as bytecode - portable across architectures.'

#deliverLoadAll
'Deliver a loadAll script file, which files-In the other files.'

#deliverSources
'Include smalltalk sourceCode in the delivery.'

#deliverMakefiles
'Include makefiles in the delivery.'

#includeSource
'Include smalltalk sourceCode in the delivery.'

#installDirMacOS
'The final install directory for MacOS deliveries.'

#installDirUnix
'The final install directory for UNIX deliveries.'

#installDirVMS
'The final install directory for VMS deliveries.'

#installDirWin32
'The final install directory for Win32 deliveries.'

#libType
'A classLibrary addOn (and support files if any)'

loadProjectCode
'Load projects classes from the project directory'

#methodsFile
'Patches & Extensions are stored in this file.'

#packageID
'Package ID used to associate classes & methods to this project.'

#projectDir
'The projects directory.'

#repositoryDirectory
'The directory path below the module in the source-repository.'

#repositoryModule
'The module (top directory) in the source-repository.'

#saveProjectFile
'Write a new .prj file.'

)
! !

!ProjectBrowser class methodsFor:'image specs'!

bigProjectBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bigProjectBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#bigProjectBrowserIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser bigProjectBrowserIcon'
	ifAbsentPut:[(Depth2Image new) width: 48; height: 48; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@U@@EUP@@@@@@@@@@U@@EUP@@@@@@@@@UUP
@UUU@@@@@@@@EUEPEP@U@@@@@@@@EUEPEP@U@@@@@@@@U@EPEP@U@@@@@@@@U@EPEP@U@@@@@@@@U@EPEP@U@@@@@@@@U@EPEPUU@@@@@@@@EU%Z%UU*(@@@
@@@@EU%Z%UU*"@@@@@@@EUUZUUZ*J@@@@@@@EUUUUUUU*@@@@@@@EUUUUUUU*@@@@@@@J**UU**E*@@@@@@@**%UZ*(%*@@@@@@B**%UZ*"%*@@@@@@@@@UU
@@J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@
@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%(@@@@@@J**UZ**J% @@@@@@J**UZ**J%@@@@@@@J**UZ**J%@@@@@@@J**UZ**J%@@@@@@@J**UZ
**J@@@@@@@@J**UZ**H@@@@@@@@J**UZ**@@@@@@@@@@@@UP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 132 0 132 255 255 0]; mask:((Depth1Image new) width: 48; height: 48; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8C<@@@@@8C<@@@@G<G?@@@@_\\G@@@@_\\G@@@@8\\G@@@@8\\G@@@@8\\G@@@@8???<@@@_???<@
@@_???<@@@_???<@@@_???<@@@_???<@@@????<@@A????<@@C????<@@G????<@@G????<@@G????<@@G????<@@G????<@@G????<@@G????<@@G????<@
@G????<@@G????<@@G????8@@G????0@@G???? @@G????@@@G????@@@G???<@@@G???8@@@G???0@@@G??? @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

bigProjectBrowserIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self bigProjectBrowserIcon2 inspect
     ImageEditor openOnClass:self andSelector:#bigProjectBrowserIcon2
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser bigProjectBrowserIcon2'
	ifAbsentPut:[(Depth2Image new) width: 48; height: 48; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@U@@EUP@@@@@@@@@@U@@EUP@@@@@@@@@UUP
@UUU@@@@@@@@EUEPEP@U@@@@@@@@EUEPEP@U@@@@@@@@U@EPEP@U@@@@@@@@U@EPEP@U@@@@@@@@U@EPEP@U@@@@@@@@U@EPEPUU@@@@@@@@EU%Z%UU*(@@@
@@@@EU%Z%UU*"@@@@@@@EUUZUUZ*J@@@@@@@EUUUUUUU*@@@@@@@EUUUUUUU*@@@@@@@J**UU**E*@@@@@@@**%UZ*(%*@@@@@@B**%UZ*"%*@@@@@@@@@UU
@@J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@
@@@J**UZ**J%*@@@@@@J**UZ**J%*@@@@@@J**UZ**J%(@@@@@@J**UZ**J% @@@@@@J**UZ**J%@@@@@@@J**UZ**J%@@@@@@@J**UZ**J%@@@@@@@J**UZ
**J@@@@@@@@J**UZ**H@@@@@@@@J**UZ**@@@@@@@@@@@@UP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0 132 0 132 255 255 0]; mask:((Depth1Image new) width: 48; height: 48; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8C<@@@@@8C<@@@@G<G?@@@@_\\G@@@@_\\G@@@@8\\G@@@@8\\G@@@@8\\G@@@@8???<@@@_???<@
@@_???<@@@_???<@@@_???<@@@_???<@@@????<@@A????<@@C????<@@G????<@@G????<@@G????<@@G????<@@G????<@@G????<@@G????<@@G????<@
@G????<@@G????<@@G????8@@G????0@@G???? @@G????@@@G????@@@G???<@@@G???8@@@G???0@@@G??? @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

buildOptionsIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self buildOptionsIcon inspect
     ImageEditor openOnClass:self andSelector:#buildOptionsIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser buildOptionsIcon'
	ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@ATET@AUEE@APQAP@TDQT@AY%Z@@UUUX@J%*F@@E@I B)Z"X@*V(&@J%*I B)Z"X@*V($@J%*I@B)Z @@@T@@@@a') ; colorMapFromArray:#[0 0 0 132 0 132 255 255 0]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A30O[A%LF?<O?0??G?<??3??O?<??3??O?8??C?8O?@b') ; yourself); yourself]
!

classIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self classIcon inspect
     ImageEditor openOnClass:self andSelector:#classIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser classIcon'
	ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'UUUUUEUUUUQP@@@TTV*%EE@@@AQQUUTTTZ*)@@@@@@@AUUT@@Z*)@@EUUQQQ**$TTUUUEE@@@@AQUUUUTUUUUP@a') ; colorMapFromArray:#[0 0 0 255 255 255 132 130 132]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C?8O? ?>C?8O? ?>C?8O? ?>C?8O? ?>@@@@@@b') ; yourself); yourself]
!

classesIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self classesIcon inspect
     ImageEditor openOnClass:self andSelector:#classesIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser classesIcon'
	ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@B"B%U(( @@@@HJ**"BBUUX @***H @@@BHB**("@)UZH J**"HB**("@@@@H (***HJ@@@BB*J** * @@@@@a') ; colorMapFromArray:#[0 0 0 132 130 132 255 255 255]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'?>C?8O?8??#??/?>??;??/?>??;??/?>O?8?? ?>C?8b') ; yourself); yourself]
!

commentIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self commentIcon inspect
     ImageEditor openOnClass:self andSelector:#commentIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser commentIcon'
	ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'******************U****%Z***)V*********%Z***!!T***(UJ***ER***!!T***(UJ**(UT***(B****(** @a') ; colorMapFromArray:#[0 0 0 0 0 255 255 255 255]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@8@C @N@@@@C @N@@8@C @N@@8@G0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]
!

deploymentIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self deploymentIcon inspect
     ImageEditor openOnClass:self andSelector:#deploymentIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser deploymentIcon'
	ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@ATET@AUEE@APQAP@TDQT@AY%Z@@UUUX@J%*F@@E@I B)Z"X@*V(&@J%*I B)Z"X@*V($@J%*I@B)Z @@@T@@@@a') ; colorMapFromArray:#[0 0 0 132 0 132 255 255 0]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A30O[A%LF?<O?0??G?<??3??O?<??3??O?8??C?8O?@b') ; yourself); yourself]
!

filesIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self filesIcon inspect
     ImageEditor openOnClass:self andSelector:#filesIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser filesIcon'
	ifAbsentPut:[(Depth1Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@G:@P@A_(E@@U>!!W;E_ U?9W?!!_>E?8G? _>@@@b') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@C? O?@?>C?<O?8??3??/??????????O?<??0??C?<b') ; yourself); yourself]
!

methodIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self methodIcon inspect
     ImageEditor openOnClass:self andSelector:#methodIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser methodIcon'
	ifAbsentPut:[(Depth4Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DH@@@@@@@@4QA@@@@@@@TQDPP@@@@@@MDQDH@@@@@@PQDQA@@@@@@LTQA@@@@@@@@I@L@@@@@@@@QD@@@@@@@@@H@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 0 0 132 132 0 0 132 0 132 255 0 255]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@B@@\@C8@_0A? C?@G<@O @\@@ @@@@@@@@@b') ; yourself); yourself]
!

methodsIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self multipleUnlockedMagentaIcon inspect
     ImageEditor openOnClass:self andSelector:#multipleUnlockedMagentaIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser methodsIcon'
	ifAbsentPut:[(Depth4Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(4 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@DH@@@@@@@@4QA@@@@@@@TQDPP@@@@@@MDQDH@@@@@@PQDQA@@@@@@LTQA@@@@@@M@I@L@@@@@EDPQD@@@@@@CQDIB@@@@@@DDQDPP@@@@@CEDPP@@@@@@@BPC@@@@@@@@DQ@@@@@@@@@B@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 0 0 132 132 0 0 132 0 132 255 0 255]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'B@@\@C8@_0A? C?@G<@? G<@_8@?0A?@C8@G@@H@@@@b') ; yourself); yourself]


!

prerequisiteClassesIcon
    <resource: #programImage>

    ^ self classesIcon
!

prerequisitePackagesIcon
    <resource: #programImage>

    ^ self projectsIcon
!

prerequisitesIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self prerequisitesIcon inspect
     ImageEditor openOnClass:self andSelector:#prerequisitesIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser prerequisitesIcon'
	ifAbsentPut:[(Depth1Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C@@L@@@@@@@@@@0A#@F@@X@@@@@L@@0@@@@@@@b') ; colorMapFromArray:#[0 0 0 127 127 127]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@A8@G(@^PA80@C@^@=8S7//^D<@C7#@^LA9@G(@@@@b') ; yourself); yourself]
!

projectBrowserIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self projectBrowserIcon inspect
     ImageEditor openOnClass:self andSelector:#projectBrowserIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser projectBrowserIcon'
	ifAbsentPut:[(Depth2Image new) width: 32; height: 32; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@T@ET@@@@@@UTAUT@@@@@EQPTAP@@@@APEAPE@@@@@E@TE@T@@@@@TAPTUP@@@@@U%)UZ @@@@AUVUV( @@@@EUUUUZ@@@@@*)U*!!(@@@@B*UZ(& @@@@@
ET@JZ@@@@J*U*()(@@@@*)V*"& @@@B*%Z*JZ@@@@J*U*()(@@@@*)V*"& @@@B*%Z*JZ@@@@J*U*() @@@@*)V*"$@@@@B*%Z*JP@@@@J*U*( @@@@@*)V*
 @@@@@@@EP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 132 0 132 255 255 0]; mask:((Depth1Image new) width: 32; height: 32; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@FC0@@G1>@@C,1 @A#LX@@X3F@@F_?<@@???@@O??0@C??<@A???@@_??0@_??<@G???@A???0@_??<@G???@A???0@_??<@G??>@A???@@_?? @G??0@A??
8@@_?<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b') ; yourself); yourself]
!

projectsIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self projectsIcon inspect
     ImageEditor openOnClass:self andSelector:#projectsIcon
    "

    <resource: #image>

    ^Icon
	constantNamed:#'ProjectBrowser projectsIcon'
	ifAbsentPut:[(Depth1Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@_8C?P_;@@\O=0?7C?\O=0?6C?PO<@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 128 128]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@G? ?>G?8??''?>_?9??''?>_?9??G?8_?A?8@@@@@@b') ; yourself); yourself]
! !

!ProjectBrowser class methodsFor:'interface specs'!

classValidationDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#classValidationDialogSpec
     ProjectBrowser new openInterface:#classValidationDialogSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #classValidationDialogSpec
	#window: 
       #(#WindowSpec
	  #label: 'ProjectBrowser'
	  #name: 'ProjectBrowser'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1024 768)
	  #bounds: #(#Rectangle 24 554 457 1003)
	  #menu: #mainMenu
	  #icon: #bigProjectBrowserIcon
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#VariableVerticalPanelSpec
	      #name: 'VariableVerticalPanel1'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 -30 1.0)
	      #handles: 
	     #(#OrderedCollection
		#Any 0.5
		1.0
	      )
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ViewSpec
		    #name: 'Box1'
		    #component: 
		   #(#SpecCollection
		      #collection: #(
		       #(#LabelSpec
			  #label: 'Classes only in Image'
			  #name: 'Label1'
			  #layout: #(#LayoutFrame 0 0 0 0 0 1 30 0)
			  #translateLabel: true
			  #adjust: #left
			)
		       #(#SequenceViewSpec
			  #name: 'List2'
			  #layout: #(#LayoutFrame 0 0.0 30 0.0 0 1.0 0 1.0)
			  #hasHorizontalScrollBar: true
			  #hasVerticalScrollBar: true
			  #useIndex: false
			  #sequenceList: #classesInImageOnly
			)
		       )
                     
		    )
		  )
		 #(#ViewSpec
		    #name: 'Box2'
		    #component: 
		   #(#SpecCollection
		      #collection: #(
		       #(#LabelSpec
			  #label: 'Classes only in Project'
			  #name: 'Label2'
			  #layout: #(#LayoutFrame 0 0 0 0 0 1 30 0)
			  #translateLabel: true
			  #adjust: #left
			)
		       #(#SequenceViewSpec
			  #name: 'List1'
			  #layout: #(#LayoutFrame 0 0.0 30 0.0 0 1.0 0 1.0)
			  #hasHorizontalScrollBar: true
			  #hasVerticalScrollBar: true
			  #useIndex: false
			  #sequenceList: #classesInProjectOnly
			)
		       )
                     
		    )
		  )
		 )
               
	      )
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'HorizontalPanel1'
	      #layout: #(#LayoutFrame 0 0 -30 1 0 1 0 1)
	      #horizontalLayout: #center
	      #verticalLayout: #center
	      #horizontalSpace: 3
	      #verticalSpace: 3
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'OK'
		    #name: 'Button1'
		    #translateLabel: true
		    #model: #closeRequest
		    #extent: #(#Point 125 22)
		  )
		 )
               
	      )
	    )
	   )
         
	)
      )
!

emptyRightCanvasSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#emptyRightCanvasSpec
     ProjectBrowser new openInterface:#emptyRightCanvasSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #emptyRightCanvasSpec
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 10 20 310 320)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#TextEditorSpec
	      #name: 'TextEditor1'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
	      #initiallyInvisible: true
	      #model: #rightCanvasTextHolder
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #isReadOnly: true
	    )
	   )
         
	)
      )
!

methodValidationDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#classValidationDialogSpec
     ProjectBrowser new openInterface:#classValidationDialogSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #classValidationDialogSpec
	#window: 
       #(#WindowSpec
	  #label: 'ProjectBrowser'
	  #name: 'ProjectBrowser'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1024 768)
	  #bounds: #(#Rectangle 24 554 457 1003)
	  #menu: #mainMenu
	  #icon: #bigProjectBrowserIcon
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#VariableVerticalPanelSpec
	      #name: 'VariableVerticalPanel1'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 -30 1.0)
	      #handles: 
	     #(#OrderedCollection
		#Any 0.5
		1.0
	      )
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ViewSpec
		    #name: 'Box1'
		    #component: 
		   #(#SpecCollection
		      #collection: #(
		       #(#LabelSpec
			  #label: 'Methods only in Image'
			  #name: 'Label1'
			  #layout: #(#LayoutFrame 0 0 0 0 0 1 30 0)
			  #translateLabel: true
			  #adjust: #left
			)
		       #(#SequenceViewSpec
			  #name: 'List2'
			  #layout: #(#LayoutFrame 0 0.0 30 0.0 0 1.0 0 1.0)
			  #hasHorizontalScrollBar: true
			  #hasVerticalScrollBar: true
			  #useIndex: false
			  #sequenceList: #methodsInImageOnly
			)
		       )
                     
		    )
		  )
		 #(#ViewSpec
		    #name: 'Box2'
		    #component: 
		   #(#SpecCollection
		      #collection: #(
		       #(#LabelSpec
			  #label: 'Methods only in Project'
			  #name: 'Label2'
			  #layout: #(#LayoutFrame 0 0 0 0 0 1 30 0)
			  #translateLabel: true
			  #adjust: #left
			)
		       #(#SequenceViewSpec
			  #name: 'List1'
			  #layout: #(#LayoutFrame 0 0.0 30 0.0 0 1.0 0 1.0)
			  #hasHorizontalScrollBar: true
			  #hasVerticalScrollBar: true
			  #useIndex: false
			  #sequenceList: #methodsInProjectOnly
			)
		       )
                     
		    )
		  )
		 )
               
	      )
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'HorizontalPanel1'
	      #layout: #(#LayoutFrame 0 0 -30 1 0 1 0 1)
	      #horizontalLayout: #center
	      #verticalLayout: #center
	      #horizontalSpace: 3
	      #verticalSpace: 3
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'OK'
		    #name: 'Button1'
		    #translateLabel: true
		    #model: #closeRequest
		    #extent: #(#Point 125 22)
		  )
		 )
               
	      )
	    )
	   )
         
	)
      )
!

rightCanvasSpecForBuildOptions
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForBuildOptions
     ProjectBrowser new openInterface:#rightCanvasSpecForBuildOptions
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #rightCanvasSpecForBuildOptions
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 216 173 577 536)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#FramedBoxSpec
	      #label: 'STC Compiler Warnings'
	      #name: 'FramedBox2'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 146 0)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#CheckBoxSpec
		    #label: 'Non Standard Language Features'
		    #name: 'CheckBox1'
		    #layout: #(#LayoutFrame 0 0.0 9 0 0 1.0 31 0)
		    #tabable: true
		    #model: #makeWarnNonStandard
		    #translateLabel: true
		  )
		 #(#CheckBoxSpec
		    #label: 'End-of-line Comments'
		    #name: 'CheckBox2'
		    #layout: #(#LayoutFrame 0 0.0 36 0 0 1.0 58 0)
		    #tabable: true
		    #model: #makeWarnEOLComments
		    #translateLabel: true
		  )
		 #(#LabelSpec
		    #label: 'other warning options:'
		    #name: 'Label3'
		    #layout: #(#LayoutFrame 0 0.0 69 0 0 1.0 91 0)
		    #translateLabel: true
		    #adjust: #left
		  )
		 #(#InputFieldSpec
		    #name: 'EntryField1'
		    #layout: #(#LayoutFrame 0 0.0 93 0 0 1.0 115 0)
		    #activeHelpKey: #projectDir
		    #tabable: true
		    #model: #makeOtherWarningOptions
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 )
               
	      )
	    )
	   #(#FramedBoxSpec
	      #label: 'STC Compiler Includes'
	      #name: 'FramedBox3'
	      #layout: #(#LayoutFrame 0 0.0 146 0.0 0 1.0 203 0)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#InputFieldSpec
		    #name: 'EntryField2'
		    #layout: #(#LayoutFrame 0 0.0 4 0 0 1.0 26 0)
		    #activeHelpKey: #repositoryModule
		    #tabable: true
		    #model: #makeIncludes
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 )
               
	      )
	    )
	   #(#FramedBoxSpec
	      #label: 'STC Compiler Defines'
	      #name: 'FramedBox5'
	      #layout: #(#LayoutFrame 0 0.0 210 0.0 0 1.0 267 0)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#InputFieldSpec
		    #name: 'EntryField5'
		    #layout: #(#LayoutFrame 0 0.0 4 0 0 1.0 26 0)
		    #activeHelpKey: #repositoryModule
		    #tabable: true
		    #model: #makeDefines
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 )
               
	      )
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'HorizontalPanel1'
	      #layout: #(#LayoutFrame 0 0 -30 1 0 1 0 1)
	      #horizontalLayout: #fitSpace
	      #verticalLayout: #center
	      #horizontalSpace: 3
	      #verticalSpace: 3
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'Cancel'
		    #name: 'Button1'
		    #activeHelpKey: #cancel
		    #translateLabel: true
		    #model: #cancel
		    #enableChannel: #modifiedChannel
		    #actionValue: ''
		    #useDefaultExtent: true
		  )
		 #(#ActionButtonSpec
		    #label: 'OK'
		    #name: 'Button2'
		    #activeHelpKey: #accept
		    #translateLabel: true
		    #model: #accept
		    #enableChannel: #modifiedChannel
		    #useDefaultExtent: true
		  )
		 )
               
	      )
	    )
	   )
         
	)
      )
!

rightCanvasSpecForClassList
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForClassList
     ProjectBrowser new openInterface:#rightCanvasSpecForClassList
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #rightCanvasSpecForClassList
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 10 20 310 320)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#DataSetSpec
	      #name: 'classTable'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #dataList: #classList
	      #has3Dsepartors: false
	      #columnHolder: #classTableColumns
	      #verticalSpacing: 0
	      #columnAdaptor: #classTableAdaptor
	    )
	   )
         
	)
      )
!

rightCanvasSpecForDeployment
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForDeployment
     ProjectBrowser new openInterface:#rightCanvasSpecForDeployment
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #rightCanvasSpecForDeployment
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 12 22 365 521)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#FramedBoxSpec
	      #label: 'Deliver'
	      #name: 'DeliverBox'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 172 0)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#CheckBoxSpec
		    #label: '''loadAll''-File'
		    #name: 'CheckBox5'
		    #layout: #(#LayoutFrame 0 0.0 67 0 0 1.0 89 0)
		    #activeHelpKey: #deliverLoadAll
		    #tabable: true
		    #model: #deliverLoadAllFile
		    #translateLabel: true
		  )
		 #(#CheckBoxSpec
		    #label: 'Compiled Binary (non-portable .dll / .so)'
		    #name: 'CheckBox6'
		    #layout: #(#LayoutFrame 0 0.0 32 0 0 1.0 54 0)
		    #activeHelpKey: #deliverCompiledBinary
		    #tabable: true
		    #model: #deliverCompiledBinary
		    #translateLabel: true
		  )
		 #(#CheckBoxSpec
		    #label: 'Bytecode Binary (portable)'
		    #name: 'CheckBox1'
		    #layout: #(#LayoutFrame 0 0.0 8 0 0 1.0 30 0)
		    #activeHelpKey: #deliverByteCode
		    #tabable: true
		    #model: #deliverByteCode
		    #translateLabel: true
		  )
		 #(#CheckBoxSpec
		    #label: 'Sources'
		    #name: 'CheckBox4'
		    #layout: #(#LayoutFrame 0 0.0 90 0 0 1.0 112 0)
		    #activeHelpKey: #deliverSources
		    #tabable: true
		    #model: #deliverSources
		    #translateLabel: true
		  )
		 #(#CheckBoxSpec
		    #label: 'Makefiles'
		    #name: 'CheckBox8'
		    #layout: #(#LayoutFrame 0 0.0 113 0 0 1.0 135 0)
		    #activeHelpKey: #deliverMakefiles
		    #tabable: true
		    #model: #deliverMakefiles
		    #translateLabel: true
		  )
		 )
               
	      )
	    )
	   #(#FramedBoxSpec
	      #label: 'Format'
	      #name: 'DeliverAsBox'
	      #layout: #(#LayoutFrame 0 0.0 172 0 0 1.0 290 0)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#CheckBoxSpec
		    #label: 'Tar Archive (.tar - for unix)'
		    #name: 'CheckBox7'
		    #layout: #(#LayoutFrame 0 0.0 34 0 0 1.0 56 0)
		    #activeHelpKey: #deliverTarArchive
		    #tabable: true
		    #model: #deliverTarArchive
		    #translateLabel: true
		  )
		 #(#CheckBoxSpec
		    #label: 'Zip Archive (.zip - for windows)'
		    #name: 'CheckBox2'
		    #layout: #(#LayoutFrame 0 0.0 10 0 0 1.0 32 0)
		    #activeHelpKey: #deliverZipArchive
		    #tabable: true
		    #model: #deliverZipArchive
		    #translateLabel: true
		  )
		 #(#CheckBoxSpec
		    #label: 'GZip Archive (self extracting for unix)'
		    #name: 'CheckBox3'
		    #layout: #(#LayoutFrame 0 0.0 58 0 0 1.0 80 0)
		    #activeHelpKey: #deliverGZipArchive
		    #tabable: true
		    #model: #deliverGZipArchive
		    #translateLabel: true
		  )
		 )
               
	      )
	    )
	   #(#FramedBoxSpec
	      #label: 'Target Install Directory'
	      #name: 'DestinationBox'
	      #layout: #(#LayoutFrame 0 0.0 295 0 0 1.0 448 0)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#LabelSpec
		    #label: 'Unix:'
		    #name: 'Label1'
		    #layout: #(#AlignmentOrigin 76 0.0 16 0 1 0.5)
		    #translateLabel: true
		    #resizeForLabel: true
		    #adjust: #right
		  )
		 #(#InputFieldSpec
		    #name: 'EntryField1'
		    #layout: #(#LayoutFrame 80 0.0 4 0 0 1.0 26 0)
		    #activeHelpKey: #installDirUnix
		    #enableChannel: #canDeliverForUnix
		    #tabable: true
		    #model: #installDirectoryUnix
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 #(#LabelSpec
		    #label: 'Win32:'
		    #name: 'Label2'
		    #layout: #(#AlignmentOrigin 76 0.0 47 0 1 0.5)
		    #translateLabel: true
		    #resizeForLabel: true
		    #adjust: #right
		  )
		 #(#InputFieldSpec
		    #name: 'EntryField2'
		    #layout: #(#LayoutFrame 80 0.0 34 0 0 1.0 56 0)
		    #activeHelpKey: #installDirWin32
		    #enableChannel: #canDeliverForWin32
		    #tabable: true
		    #model: #installDirectoryWin32
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 #(#LabelSpec
		    #label: 'VMS:'
		    #name: 'Label3'
		    #layout: #(#AlignmentOrigin 76 0.0 76 0 1 0.5)
		    #translateLabel: true
		    #resizeForLabel: true
		    #adjust: #right
		  )
		 #(#InputFieldSpec
		    #name: 'EntryField3'
		    #layout: #(#LayoutFrame 80 0.0 63 0 0 1.0 85 0)
		    #activeHelpKey: #installDirVMS
		    #initiallyDisabled: true
		    #enableChannel: #canDeliverForVMS
		    #tabable: true
		    #model: #installDirectoryVMS
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 #(#LabelSpec
		    #label: 'MacOS:'
		    #name: 'Label4'
		    #layout: #(#AlignmentOrigin 76 0.0 106 0 1 0.5)
		    #translateLabel: true
		    #resizeForLabel: true
		    #adjust: #right
		  )
		 #(#InputFieldSpec
		    #name: 'EntryField4'
		    #layout: #(#LayoutFrame 80 0.0 93 0 0 1.0 115 0)
		    #activeHelpKey: #installDirMacOS
		    #initiallyDisabled: true
		    #enableChannel: #canDeliverForMacOS
		    #tabable: true
		    #model: #installDirectoryMac
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 )
               
	      )
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'HorizontalPanel1'
	      #layout: #(#LayoutFrame 0 0 -30 1 0 1 0 1)
	      #horizontalLayout: #fitSpace
	      #verticalLayout: #center
	      #horizontalSpace: 3
	      #verticalSpace: 3
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'Cancel'
		    #name: 'Button1'
		    #translateLabel: true
		    #tabable: true
		    #model: #cancel
		    #enableChannel: #modifiedChannel
		    #actionValue: ''
		    #useDefaultExtent: true
		  )
		 #(#ActionButtonSpec
		    #label: 'OK'
		    #name: 'Button2'
		    #translateLabel: true
		    #tabable: true
		    #model: #accept
		    #enableChannel: #modifiedChannel
		    #actionValue: ''
		    #useDefaultExtent: true
		  )
		 )
               
	      )
	    )
	   )
         
	)
      )
!

rightCanvasSpecForEditableText
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForEditableText
     ProjectBrowser new openInterface:#rightCanvasSpecForEditableText
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #rightCanvasSpecForEditableText
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 216 173 516 473)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#TextEditorSpec
	      #name: 'TextEditor1'
	      #layout: #(#LayoutFrame 0 0.0 30 0.0 0 1.0 0 1.0)
	      #model: #rightCanvasTextHolder
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	    )
	   #(#LabelSpec
	      #label: 'Label'
	      #name: 'Label1'
	      #layout: #(#LayoutFrame 0 0 0 0 0 1 30 0)
	      #translateLabel: true
	      #labelChannel: #textCanvasLabelHolder
	      #adjust: #left
	    )
	   )
         
	)
      )
!

rightCanvasSpecForFiles
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForFiles
     ProjectBrowser new openInterface:#rightCanvasSpecForFiles
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #rightCanvasSpecForFiles
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 216 173 577 536)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#FramedBoxSpec
	      #label: 'File for extensions & patches'
	      #name: 'FramedBox2'
	      #layout: #(#LayoutFrame 0 0.0 62 0.0 0 1.0 122 0)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#InputFieldSpec
		    #name: 'methodsFileEntryField'
		    #layout: #(#LayoutFrame 0 0.0 1 0 0 1.0 23 0)
		    #activeHelpKey: #methodsFile
		    #model: #methodsFile
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 )
               
	      )
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'HorizontalPanel1'
	      #layout: #(#LayoutFrame 0 0 -30 1 0 1 0 1)
	      #horizontalLayout: #fitSpace
	      #verticalLayout: #center
	      #horizontalSpace: 3
	      #verticalSpace: 3
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'Cancel'
		    #name: 'Button1'
		    #activeHelpKey: #cancel
		    #translateLabel: true
		    #model: #cancel
		    #enableChannel: #modifiedChannel
		    #actionValue: ''
		    #useDefaultExtent: true
		  )
		 #(#ActionButtonSpec
		    #label: 'OK'
		    #name: 'Button2'
		    #activeHelpKey: #accept
		    #translateLabel: true
		    #model: #accept
		    #enableChannel: #modifiedChannel
		    #useDefaultExtent: true
		  )
		 )
               
	      )
	    )
	   )
         
	)
      )
!

rightCanvasSpecForHTMLText
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForHTMLText
     ProjectBrowser new openInterface:#rightCanvasSpecForHTMLText
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
	  #window: 
	   #(#WindowSpec
	      #name: 'NewApplication'
	      #layout: #(#LayoutFrame 216 0 173 0 515 0 472 0)
	      #level: 0
	      #label: 'NewApplication'
	      #min: #(#Point 10 10)
	      #max: #(#Point 1280 1024)
	      #bounds: #(#Rectangle 216 173 516 473)
	      #usePreferredExtent: false
	  )
	  #component: 
	   #(#SpecCollection
	      #collection: 
	       #(
		 #(#HTMLViewSpec
		    #name: 'HTMLBrowser1'
		    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
		    #model: #htmlDocumentURLHolder
		    #hasHorizontalScrollBar: true
		    #hasVerticalScrollBar: true
		)
	      )
	  )
      )
!

rightCanvasSpecForPatchesList
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForPatchesList
     ProjectBrowser new openInterface:#rightCanvasSpecForPatchesList
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #rightCanvasSpecForPatchesList
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 162 22 462 322)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#DataSetSpec
	      #name: 'patchesTable'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
	      #menu: #methodMenu
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #dataList: #patchesList
	      #has3Dsepartors: false
	      #columnHolder: #patchesTableColumns
	      #columnAdaptor: #classTableAdaptor
	    )
	   )
         
	)
      )
!

rightCanvasSpecForPrerequisiteClasses
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForPrerequisiteClasses
     ProjectBrowser new openInterface:#rightCanvasSpecForPrerequisiteClasses
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #rightCanvasSpecForPrerequisiteClasses
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #layout: #(#LayoutFrame 220 0 200 0 519 0 499 0)
	  #level: 0
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 220 200 520 500)
	  #usePreferredExtent: false
	  #returnIsOKInDialog: true
	  #escapeIsCancelInDialog: true
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'Known Classes'
	      #name: 'Label1'
	      #layout: #(#LayoutFrame 0 0 0 0 0 0.5 30 0)
	      #translateLabel: true
	    )
	   #(#SequenceViewSpec
	      #name: 'List1'
	      #layout: #(#LayoutFrame 0 0 30 0 0 0.5 -62 1)
	      #tabable: true
	      #model: #selectedClassInPrerequisites
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #miniScrollerVertical: true
	      #doubleClickSelector: #addClassToPrerequisites
	      #valueChangeSelector: #showInfoForRequiredClass:
	      #useIndex: false
	      #sequenceList: #listOfAllClassesInPrerequisites
	    )
	   #(#LabelSpec
	      #label: 'Required Classes'
	      #name: 'Label2'
	      #layout: #(#LayoutFrame 0 0.5 0 0 0 1 30 0)
	      #translateLabel: true
	    )
	   #(#SequenceViewSpec
	      #name: 'List2'
	      #layout: #(#LayoutFrame 0 0.5 30 0 0 1 -62 1)
	      #tabable: true
	      #model: #selectedRequiredClassInPrerequisites
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #miniScrollerVertical: true
	      #doubleClickSelector: #removeClassFromPrerequisites
	      #valueChangeSelector: #showInfoForRequiredClass:
	      #useIndex: false
	      #sequenceList: #listOfRequiredClassesInPrerequisites
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'HorizontalPanel2'
	      #layout: #(#LayoutFrame 0 0 -62 1 0 1 -32 1)
	      #horizontalLayout: #fitSpace
	      #verticalLayout: #center
	      #horizontalSpace: 3
	      #verticalSpace: 3
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'Add'
		    #name: 'addButton'
		    #translateLabel: true
		    #resizeForLabel: false
		    #tabable: true
		    #model: #addClassToPrerequisites
		    #enableChannel: #canAddSelectedClassToPrerequisites
		    #actionValue: ''
		    #useDefaultExtent: true
		  )
		 #(#ActionButtonSpec
		    #label: 'Remove'
		    #name: 'removeButton'
		    #translateLabel: true
		    #resizeForLabel: false
		    #tabable: true
		    #model: #removeClassFromPrerequisites
		    #enableChannel: #canRemoveSelectedClassFromPrerequisites
		    #actionValue: ''
		    #useDefaultExtent: true
		  )
		 )
               
	      )
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'HorizontalPanel1'
	      #layout: #(#LayoutFrame 0 0.0 -30 1 0 1.0 0 1.0)
	      #horizontalLayout: #fitSpace
	      #verticalLayout: #center
	      #horizontalSpace: 3
	      #verticalSpace: 3
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'Cancel'
		    #name: 'Button1'
		    #translateLabel: true
		    #tabable: true
		    #model: #cancel
		    #useDefaultExtent: true
		  )
		 #(#ActionButtonSpec
		    #label: 'OK'
		    #name: 'Button2'
		    #translateLabel: true
		    #tabable: true
		    #model: #accept
		    #useDefaultExtent: true
		  )
		 )
               
	      )
	    )
	   )
         
	)
      )
!

rightCanvasSpecForPrerequisitePackages
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForPrerequisitePackages
     ProjectBrowser new openInterface:#rightCanvasSpecForPrerequisitePackages
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #rightCanvasSpecForPrerequisitePackages
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #layout: #(#LayoutFrame 220 0 200 0 519 0 499 0)
	  #level: 0
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 220 200 520 500)
	  #usePreferredExtent: false
	  #returnIsOKInDialog: true
	  #escapeIsCancelInDialog: true
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#LabelSpec
	      #label: 'Known Packages'
	      #name: 'Label1'
	      #layout: #(#LayoutFrame 0 0 0 0 0 0.5 30 0)
	      #translateLabel: true
	    )
	   #(#SequenceViewSpec
	      #name: 'List1'
	      #layout: #(#LayoutFrame 0 0 30 0 0 0.5 -62 1)
	      #tabable: true
	      #model: #selectedProjectInPrerequisites
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #miniScrollerVertical: true
	      #doubleClickSelector: #addProjectToPrerequisites
	      #useIndex: false
	      #sequenceList: #listOfAllProjectsInPrerequisites
	    )
	   #(#LabelSpec
	      #label: 'Prerequisites'
	      #name: 'Label2'
	      #layout: #(#LayoutFrame 0 0.5 0 0 0 1 30 0)
	      #translateLabel: true
	    )
	   #(#SequenceViewSpec
	      #name: 'List2'
	      #layout: #(#LayoutFrame 0 0.5 30 0 0 1 -62 1)
	      #tabable: true
	      #model: #selectedRequiredProjectInPrerequisites
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #miniScrollerVertical: true
	      #doubleClickSelector: #removeProjectFromPrerequisites
	      #useIndex: false
	      #sequenceList: #listOfRequiredProjectsInPrerequisites
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'HorizontalPanel2'
	      #layout: #(#LayoutFrame 0 0 -62 1 0 1 -32 1)
	      #horizontalLayout: #fitSpace
	      #verticalLayout: #center
	      #horizontalSpace: 3
	      #verticalSpace: 3
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'Add'
		    #name: 'addButton'
		    #translateLabel: true
		    #resizeForLabel: false
		    #tabable: true
		    #model: #addProjectToPrerequisites
		    #enableChannel: #canAddSelectedProjectToPrerequisites
		    #actionValue: ''
		    #useDefaultExtent: true
		  )
		 #(#ActionButtonSpec
		    #label: 'Remove'
		    #name: 'removeButton'
		    #translateLabel: true
		    #resizeForLabel: false
		    #tabable: true
		    #model: #removeProjectFromPrerequisites
		    #enableChannel: #canRemoveSelectedProjectFromPrerequisites
		    #actionValue: ''
		    #useDefaultExtent: true
		  )
		 )
               
	      )
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'HorizontalPanel1'
	      #layout: #(#LayoutFrame 0 0.0 -30 1 0 1.0 0 1.0)
	      #horizontalLayout: #fitSpace
	      #verticalLayout: #center
	      #horizontalSpace: 3
	      #verticalSpace: 3
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'Cancel'
		    #name: 'Button1'
		    #translateLabel: true
		    #tabable: true
		    #model: #cancel
		    #useDefaultExtent: true
		  )
		 #(#ActionButtonSpec
		    #label: 'OK'
		    #name: 'Button2'
		    #translateLabel: true
		    #tabable: true
		    #model: #accept
		    #useDefaultExtent: true
		  )
		 )
               
	      )
	    )
	   )
         
	)
      )
!

rightCanvasSpecForProperties
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForProperties
     ProjectBrowser new openInterface:#rightCanvasSpecForProperties
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #rightCanvasSpecForProperties
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 12 22 373 346)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#FramedBoxSpec
	      #label: 'Project Type'
	      #name: 'FramedBox1'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 61 0)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#RadioButtonSpec
		    #label: 'Application'
		    #name: 'RadioButton1'
		    #layout: #(#LayoutFrame -1 0.0 5 0 0 0.5 27 0)
		    #activeHelpKey: #appType
		    #translateLabel: true
		    #model: #projectType
		    #isTriggerOnDown: true
		    #select: #application
		  )
		 #(#RadioButtonSpec
		    #label: 'Class Library'
		    #name: 'RadioButton2'
		    #layout: #(#LayoutFrame 0 0.5 5 0 0 1.0 27 0)
		    #activeHelpKey: #libType
		    #translateLabel: true
		    #model: #projectType
		    #isTriggerOnDown: true
		    #select: #library
		  )
		 )
               
	      )
	    )
	   #(#FramedBoxSpec
	      #label: 'Project Working Directory'
	      #name: 'FramedBox2'
	      #layout: #(#LayoutFrame 0 0.0 67 0.0 0 1.0 127 0)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#InputFieldSpec
		    #name: 'EntryField1'
		    #layout: #(#LayoutFrame 0 0.0 1 0 0 1.0 23 0)
		    #activeHelpKey: #projectDir
		    #enableChannel: #currentProjectWasNotLoadedFromFile
		    #model: #projectDirectory
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 )
               
	      )
	    )
	   #(#FramedBoxSpec
	      #label: 'Repository'
	      #name: 'FramedBox3'
	      #layout: #(#LayoutFrame 0 0.0 137 0.0 0 1.0 220 0)
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#LabelSpec
		    #label: 'Module:'
		    #name: 'Label1'
		    #layout: #(#AlignmentOrigin 106 0 11 0 1 0.5)
		    #translateLabel: true
		    #resizeForLabel: true
		    #adjust: #right
		  )
		 #(#InputFieldSpec
		    #name: 'EntryField2'
		    #layout: #(#LayoutFrame 110 0.0 0 0 0 1.0 22 0)
		    #activeHelpKey: #repositoryModule
		    #model: #repositoryModule
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 #(#LabelSpec
		    #label: 'Directory:'
		    #name: 'Label2'
		    #layout: #(#AlignmentOrigin 106 0 36 0 1 0.5)
		    #translateLabel: true
		    #resizeForLabel: true
		    #adjust: #right
		  )
		 #(#InputFieldSpec
		    #name: 'EntryField3'
		    #layout: #(#LayoutFrame 110 0.0 25 0 0 1.0 47 0)
		    #activeHelpKey: #repositoryDirectory
		    #model: #repositoryDirectory
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 )
               
	      )
	    )
	   #(#FramedBoxSpec
	      #label: 'Default Namespace'
	      #name: 'FramedBox4'
	      #layout: #(#LayoutFrame 0 0.0 226 0 0 1.0 284 0)
	      #activeHelpKey: #defaultNamespace
	      #labelPosition: #topLeft
	      #translateLabel: true
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#InputFieldSpec
		    #name: 'EntryField4'
		    #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 22 0)
		    #model: #projectNamespace
		    #acceptChannel: #acceptChannel
		    #modifiedChannel: #modifiedChannel
		    #acceptOnPointerLeave: false
		  )
		 )
               
	      )
	    )
	   #(#HorizontalPanelViewSpec
	      #name: 'HorizontalPanel1'
	      #layout: #(#LayoutFrame 0 0 -30 1 0 1 0 1)
	      #horizontalLayout: #fitSpace
	      #verticalLayout: #center
	      #horizontalSpace: 3
	      #verticalSpace: 3
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#ActionButtonSpec
		    #label: 'Cancel'
		    #name: 'Button1'
		    #activeHelpKey: #cancel
		    #translateLabel: true
		    #model: #cancel
		    #enableChannel: #modifiedChannel
		    #actionValue: ''
		    #useDefaultExtent: true
		  )
		 #(#ActionButtonSpec
		    #label: 'OK'
		    #name: 'Button2'
		    #activeHelpKey: #accept
		    #translateLabel: true
		    #model: #accept
		    #enableChannel: #modifiedChannel
		    #useDefaultExtent: true
		  )
		 )
               
	      )
	    )
	   )
         
	)
      )
!

rightCanvasSpecForReadOnlyText
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProjectBrowser andSelector:#rightCanvasSpecForReadOnlyText
     ProjectBrowser new openInterface:#rightCanvasSpecForReadOnlyText
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #rightCanvasSpecForReadOnlyText
	#window: 
       #(#WindowSpec
	  #label: 'NewApplication'
	  #name: 'NewApplication'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1280 1024)
	  #bounds: #(#Rectangle 216 173 516 473)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#TextEditorSpec
	      #name: 'TextEditor1'
	      #layout: #(#LayoutFrame 0 0.0 30 0.0 0 1.0 0 1.0)
	      #model: #rightCanvasTextHolder
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #isReadOnly: true
	    )
	   #(#LabelSpec
	      #label: 'Label'
	      #name: 'Label1'
	      #layout: #(#LayoutFrame 0 0 0 0 0 1 30 0)
	      #translateLabel: true
	      #labelChannel: #textCanvasLabelHolder
	      #adjust: #left
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
     UIPainter new openOnClass:ProjectBrowser andSelector:#windowSpec
     ProjectBrowser new openInterface:#windowSpec
     ProjectBrowser open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #windowSpec
	#window: 
       #(#WindowSpec
	  #label: 'ProjectBrowser'
	  #name: 'ProjectBrowser'
	  #min: #(#Point 10 10)
	  #max: #(#Point 1024 768)
	  #bounds: #(#Rectangle 20 94 623 645)
	  #menu: #mainMenu
	  #icon: #bigProjectBrowserIcon
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#MenuPanelSpec
	      #name: 'ToolBar1'
	      #layout: #(#LayoutFrame 0 0.0 0 0 0 1.0 32 0)
	      #menu: #menu
	      #textDefault: true
	    )
	   #(#VariableVerticalPanelSpec
	      #name: 'VariableVerticalPanel1'
	      #layout: #(#LayoutFrame 0 0.0 32 0.0 0 1.0 -24 1.0)
	      #level: 1
	      #component: 
	     #(#SpecCollection
		#collection: #(
		 #(#VariableHorizontalPanelSpec
		    #name: 'VariableHorizontalPanel1'
		    #component: 
		   #(#SpecCollection
		      #collection: #(
		       #(#SelectionInTreeViewSpec
			  #name: 'TreeList1'
			  #model: #selectedTreeNodeHolder
			  #menu: #itemMenuHolder
			  #performer: #itemMenuPerformer
			  #hasHorizontalScrollBar: true
			  #hasVerticalScrollBar: true
			  #miniScrollerHorizontal: true
			  #showRoot: false
			  #showDirectoryIndicatorForRoot: false
			  #showDirectoryIndicator: true
			  #valueChangeSelector: #itemSelected:
			  #doubleClickSelector: #itemDoubleClicked:
			  #hierarchicalList: #projectTreeHolder
			  #selectConditionSelector: #selectionChangeAllowed:
			  #highlightMode: #label
			)
		       #(#SubCanvasSpec
			  #name: 'SubCanvas1'
			  #hasHorizontalScrollBar: false
			  #hasVerticalScrollBar: false
			  #specHolder: #currentCanvasHolder
			)
		       )
                     
		    )
		    #handles: #(#Any 0.389718 1.0)
		  )
		 #(#ArbitraryComponentSpec
		    #name: 'commandOutputView'
		    #hasHorizontalScrollBar: true
		    #hasVerticalScrollBar: true
		    #miniScrollerHorizontal: true
		    #hasBorder: false
		    #component: #TextCollector
		  )
		 )
               
	      )
	      #handles: #(#Any 0.987879 1.0)
	    )
	   #(#UISubSpecification
	      #name: 'infoBarSubSpec'
	      #layout: #(#LayoutFrame 0 0.0 -24 1 0 1.0 0 1.0)
	      #level: 1
	      #majorKey: #ToolApplicationModel
	      #minorKey: #windowSpecForInfoBar
	    )
	   )
         
	)
      )
! !

!ProjectBrowser class methodsFor:'menu specs'!

classItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProjectBrowser andSelector:#classItemMenu
     (Menu new fromLiteralArrayEncoding:(ProjectBrowser classItemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Remove from Project...'
	    #translateLabel: true
	    #value: #removeClassFromProject
	    #enabled: #hasClassesSelectedHolder
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Browse...'
	    #translateLabel: true
	    #value: #browseClass
	    #enabled: #hasClassesSelectedHolder
	  )
	 )
	nil
	nil
      )
!

classesItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProjectBrowser andSelector:#classesItemMenu
     (Menu new fromLiteralArrayEncoding:(ProjectBrowser classesItemMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
	   #(
	     #(#MenuItem
		#label: 'Add Class...'
		#translateLabel: true
		#value: #addClass
		#enabled: #hasClassesSelectedHolder
	    )
	     #(#MenuItem
		#label: 'Add Classes found in image'
		#translateLabel: true
		#value: #addClassesFromImage
		#enabled: #hasClassesSelectedHolder
	    )
	     #(#MenuItem
		#label: 'Add Classes from files found in directory'
		#translateLabel: true
		#value: #addClassesFromFilesInDirectory
		#enabled: #hasClassesSelectedHolder
	    )
	     #(#MenuItem
		#label: 'Add Classes from files found in directory if present in image'
		#translateLabel: true
		#value: #addClassesFromFilesInDirectoryIfPresentInImage
		#enabled: #hasClassesSelectedHolder
	    )
	     #(#MenuItem
		#label: '-'
	    )
	     #(#MenuItem
		#label: 'Load Classes from Directory'
		#translateLabel: true
		#value: #loadClassesFromDirectory
		#enabled: #canLoadClassesFromDirectory
	    )
	     #(#MenuItem
		#label: 'Load Classes from Repository'
		#translateLabel: true
		#value: #loadClassesFromRepository
		#enabled: #canLoadClassesFromRepository
	    )
	     #(#MenuItem
		#label: '-'
	    )
	     #(#MenuItem
		#label: 'Validate...'
		#translateLabel: true
		#value: #validateAgainstClassesInImage
		#enabled: #hasClassesSelectedHolder
	    )

	     #(#MenuItem
		#label: '-'
	    )
	     #(#MenuItem
		#label: 'Browse...'
		#translateLabel: true
		#value: #browseClasses
		#enabled: #hasClassesSelectedHolder
	    )
	  ) nil
	  nil
      )
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProjectBrowser andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(ProjectBrowser mainMenu)) startUp
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
		  #label: 'New'
		  #translateLabel: true
		  #value: #newProject
		)
	       #(#MenuItem
		  #label: '-'
		)
	       #(#MenuItem
		  #label: 'Load From...'
		  #translateLabel: true
		  #value: #openProject
		  #activeHelpKey: #openProject
		)
	       #(#MenuItem
		  #label: 'Load Project Code'
		  #translateLabel: true
		  #value: #loadProjectCode
		  #enabled: #hasProjectSelectedAndProjectFilenameHolder
		  #activeHelpKey: #loadProjectCode
		)
	       #(#MenuItem
		  #label: '-'
		)
	       #(#MenuItem
		  #label: 'Save Project File'
		  #translateLabel: true
		  #value: #saveProjectFile
		  #enabled: #hasProjectSelectedAndProjectFilenameHolder
		  #activeHelpKey: #saveProjectFile
		)
	       #(#MenuItem
		  #label: 'Save Project Code'
		  #translateLabel: true
		  #value: #saveProjectCode
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'Save All'
		  #translateLabel: true
		  #value: #saveAll
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: '-'
		)
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
	    #label: 'Repository'
	    #translateLabel: true
	    #submenu: 
	   #(#Menu
	      #(
	       #(#MenuItem
		  #label: 'CheckIn All'
		  #translateLabel: true
		  #value: #checkInProject
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: '-'
		)
	       #(#MenuItem
		  #label: 'CheckIn Classes'
		  #translateLabel: true
		  #value: #checkInAllClasses
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'CheckIn Extensions'
		  #translateLabel: true
		  #value: #checkInMethods
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'CheckIn Project File'
		  #translateLabel: true
		  #value: #checkInProjectFile
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'CheckIn Makefiles'
		  #translateLabel: true
		  #value: #checkInMakefiles
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       )
	      nil
	      nil
	    )
	  )
	 #(#MenuItem
	    #label: 'View'
	    #translateLabel: true
	    #submenu: 
	   #(#Menu
	      #(
	       #(#MenuItem
		  #label: 'Current Project'
		  #translateLabel: true
		  #choice: #showWhat
		  #choiceValue: #current
		)
	       #(#MenuItem
		  #label: 'Non BaseSystem Projects'
		  #translateLabel: true
		  #choice: #showWhat
		  #choiceValue: #userProjects
		)
	       #(#MenuItem
		  #label: 'All Projects'
		  #translateLabel: true
		  #choice: #showWhat
		  #choiceValue: #all
		)
	       #(#MenuItem
		  #label: '-'
		)
	       #(#MenuItem
		  #label: 'Update'
		  #translateLabel: true
		  #value: #updateListOfProjects
		)
	       )
	      nil
	      nil
	    )
	  )
	 #(#MenuItem
	    #label: 'Project'
	    #translateLabel: true
	    #submenuChannel: #projectItemMenu
	  )
	 #(#MenuItem
	    #label: 'Build'
	    #translateLabel: true
	    #submenu: 
	   #(#Menu
	      #(
	       #(#MenuItem
		  #label: 'All'
		  #translateLabel: true
		  #value: #buildAll
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: '-'
		)
	       #(#MenuItem
		  #label: 'Make.proto && Makefile'
		  #translateLabel: true
		  #value: #buildMakefiles
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'Makefile'
		  #translateLabel: true
		  #value: #buildMakefile
		  #isVisible: #osIsUnix
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'Makefile for windows (nt.mak)'
		  #translateLabel: true
		  #value: #buildNTMakefile
		  #isVisible: #osIsWindows
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'LoadAll file'
		  #translateLabel: true
		  #value: #buildLoadAllFile
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'abbrev file (for autoload)'
		  #translateLabel: true
		  #value: #buildAbbrevFile
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'Binary class library (non portable)'
		  #translateLabel: true
		  #value: #buildCompiledClassLibrary
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'Bytecode class library (portable)'
		  #translateLabel: true
		  #value: #buildByteCodeClassLibrary
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
		)
	       #(#MenuItem
		  #label: 'Zip archive'
		  #translateLabel: true
		  #value: #buildZipArchive
		  #enabled: #hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
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
		  #label: 'Documentation'
		  #translateLabel: true
		  #value: #openDocumentation
		)
	       #(#MenuItem
		  #label: '-'
		)
	       #(#MenuItem
		  #label: 'About this Application'
		  #translateLabel: true
		  #value: #openAboutThisApplication
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

    "Modified: / 19.1.2000 / 16:52:31 / cg"
!

methodItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProjectBrowser andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(ProjectBrowser menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Browse'
	    #translateLabel: true
	    #value: #browseMethod
	  )
	 #(#MenuItem
	    #label: 'Browse Full'
	    #translateLabel: true
	    #value: #browseMethodFull
	  )
	 #(#MenuItem
	    #label: '-'
	  )
	 #(#MenuItem
	    #label: 'Remove...'
	    #translateLabel: true
	    #value: #removeMethod
	  )
	 #(#MenuItem
	    #label: 'Remove from Project...'
	    #translateLabel: true
	    #value: #removeMethodFromProject
	  )
	 #(#MenuItem
	    #label: 'Move to Project...'
	    #translateLabel: true
	    #value: #moveMethodToProject
	  )
	 )
	nil
	nil
      )
!

methodsItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProjectBrowser andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(ProjectBrowser menu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
	#(
	     #(#MenuItem
		#label: 'Validate...'
		#translateLabel: true
		#value: #validateAgainstMethodsInImage
		#enabled: #hasMethodsSelectedHolder
	    )
	 )
	nil
	nil
      )
!

noItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProjectBrowser andSelector:#projectItemMenu
     (Menu new fromLiteralArrayEncoding:(ProjectBrowser projectItemMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
	   #(
	     #(#MenuItem
		#label: 'New Project'
		#translateLabel: true
		#value: #newProject
	    )
	  ) nil
	  nil
      )
!

prerequisiteClassesItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProjectBrowser andSelector:#prerequisiteClassesItemMenu
     (Menu new fromLiteralArrayEncoding:(ProjectBrowser prerequisiteClassesItemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Update'
	    #translateLabel: true
	    #value: #updateListOfRequiredPrerequisiteClasses
	    #enabled: #hasClassesSelectedHolder
	  )
	 )
	nil
	nil
      )
!

prerequisitePackagesItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProjectBrowser andSelector:#prerequisiteClassesItemMenu
     (Menu new fromLiteralArrayEncoding:(ProjectBrowser prerequisiteClassesItemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
	#(
	 #(#MenuItem
	    #label: 'Add package...'
	    #translateLabel: true
	    #value: #addPrerequisitePackage
	  )
	 )
	nil
	nil
      )
!

projectItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProjectBrowser andSelector:#projectItemMenu
     (Menu new fromLiteralArrayEncoding:(ProjectBrowser projectItemMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
	   #(
	     #(#MenuItem
		#label: 'Load Project'
		#translateLabel: true
		#value: #loadProject
		#enabled: #canLoadCurrentProjectHolder
	    )
	     #(#MenuItem
		#label: 'Unload Project'
		#translateLabel: true
		#value: #unloadProject
		#enabled: #canUnloadCurrentProjectHolder
	    )
	     #(#MenuItem
		#label: '-'
	    )
	     #(#MenuItem
		#label: 'Make Current'
		#translateLabel: true
		#value: #makeCurrentProject
		#enabled: #hasProjectSelectedHolder
	    )
	     #(#MenuItem
		#label: 'Inspect'
		#translateLabel: true
		#value: #inspectCurrentProject
		#enabled: #hasProjectSelectedHolder
	    )
	     #(#MenuItem
		#label: '-'
	    )
"/             #(#MenuItem
"/                #label: 'New SubProject'
"/                #translateLabel: true
"/                #value: #newSubProject
"/                #enabled: #hasProjectSelectedHolder
"/            )
"/             #(#MenuItem
"/                #label: '-'
"/            )
	     #(#MenuItem
		#label: 'Rename...'
		#translateLabel: true
		#value: #renameProject
		#enabled: #hasProjectSelectedHolder
	    )
	     #(#MenuItem
		#label: '-'
	    )
	     #(#MenuItem
		#label: 'Remove...'
		#translateLabel: true
		#value: #removeProject
		#enabled: #hasProjectSelectedHolder
	    )
	  ) nil
	  nil
      )
!

subProjectsItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProjectBrowser andSelector:#subProjectsItemMenu
     (Menu new fromLiteralArrayEncoding:(ProjectBrowser subProjectsItemMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
	   #(
	     #(#MenuItem
		#label: 'New SubProject'
		#translateLabel: true
		#value: #newSubProject
		#enabled: #hasSubProjectsSelectedHolder
	    )
	  ) nil
	  nil
      )
! !

!ProjectBrowser class methodsFor:'startup'!

openOnFile:aFilename
    |project browser nodes theNode|

    browser := self new.
    browser allButOpen.
    project := browser loadFromProjectFile:aFilename.
    browser expandPathToNodeFor:project.
    browser openWindow
! !

!ProjectBrowser class methodsFor:'tableColumns specs'!

classTableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:ProjectBrowser andSelector:#classTableColumns
    "

    <resource: #tableColumns>

    ^#(
      #(#DataSetColumnSpec
	 #label: 'Class'
	 #id: 'classColumn'
	 #labelAlignment: #left
	 #model: #classNameFromClassInfo:
       )
      #(#DataSetColumnSpec
	 #label: 'Included'
	 #id: 'inclusion'
	 #width: 150
	 #editorType: #ComboList
	 #choices: #listOfPossibleConditions:
	 #model: #classIncludeConditionFromClassInfo:
	 #writeSelector: #classIncludeConditionFromClassInfo:put:
       )
      #(#DataSetColumnSpec
	 #label: 'Filename'
	 #labelAlignment: #left
	 #minWidth: 200
	 #model: #classFilenameFromClassInfo:
       )
      )
    
!

patchesTableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:ProjectBrowser andSelector:#patchesTableColumns
    "

    <resource: #tableColumns>

    ^#(
      #(#DataSetColumnSpec
	 #label: 'Class'
	 #id: 'classColumn'
	 #labelAlignment: #left
	 #menu: #patchesMethodMenu
	 #model: #classNameFromMethodInfo:
	 #doubleClickedSelector: #methodPatchDoubleClick:
	 #canSelect: false
       )
      #(#DataSetColumnSpec
	 #label: 'Selector'
	 #id: 'selectorColumn'
	 #labelAlignment: #left
	 #model: #selectorFromMethodInfo:
	 #canSelect: false
       )
      )
    
! !

!ProjectBrowser methodsFor:'accessing'!

selectedTreeNode
    "automatically generated by UIPainter ..."

    ^ self selectedTreeNodeHolder value
! !

!ProjectBrowser methodsFor:'aspects'!

acceptChannel
    |holder|

    (holder := builder bindingAt:#acceptChannel) isNil ifTrue:[
	holder := false asValue.
	builder aspectAt:#acceptChannel put:holder.
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

browseClass
    |node classOrClassName cls|

    self hasClassNodeSelected ifFalse:[^ self].

    node := self selectedTreeNode.
    classOrClassName := node contents value.
    classOrClassName isBehavior ifTrue:[
	cls := classOrClassName.
    ] ifFalse:[
	cls := Smalltalk at:classOrClassName.
    ].
    cls isNil ifTrue:[
	self information:'The class is not (yet) loaded'.
	^ self.
    ].
    cls isLoaded ifFalse:[
	self information:'The class is an autoloaded class.'.
    ].
    SystemBrowser openInClass:cls selector:nil.

!

canAddSelectedClassToPrerequisites
    |holder|

    (holder := builder bindingAt:#canAddSelectedClassToPrerequisites) isNil ifTrue:[
	holder := BlockValue 
			with:[:m | self canAddClassToPrerequisites:m] 
			argument:(self selectedClassInPrerequisites).
	builder aspectAt:#canAddSelectedClassToPrerequisites put:holder.
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

canAddSelectedProjectToPrerequisites
    |holder|

    (holder := builder bindingAt:#canAddSelectedProjectToPrerequisites) isNil ifTrue:[
	holder := BlockValue 
			with:[:m | self canAddProjectToPrerequisites:m] 
			argument:(self selectedProjectInPrerequisites).
	builder aspectAt:#canAddSelectedProjectToPrerequisites put:holder.
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

canDeliverBinaryForMacOS
    ^ OperatingSystem platformName == #macOS
!

canDeliverBinaryForUnix
    ^ OperatingSystem platformName == #unix 
!

canDeliverBinaryForVMS
    ^ OperatingSystem platformName == #vms 

!

canDeliverBinaryForWin32
    ^ OperatingSystem platformName == #win32 
!

canDeliverForMacOS
    |holder|

    (holder := builder bindingAt:#canDeliverForMacOS) isNil ifTrue:[
	holder := BlockValue 
			with:[:a1 :a2 | a1 or:[a2 not]] 
			arguments:(Array 
					with:self canDeliverBinaryForMacOS
					with:self deliverCompiledBinary).
	builder aspectAt:#canDeliverForMacOS put:holder.
    ].
    ^ holder.
!

canDeliverForUnix
    |holder|

    (holder := builder bindingAt:#canDeliverForUnix) isNil ifTrue:[
	holder := BlockValue 
			with:[:a1 :a2 | a1 or:[a2 not]] 
			arguments:(Array 
					with:self canDeliverBinaryForUnix
					with:self deliverCompiledBinary).
	builder aspectAt:#canDeliverForUnix put:holder.
    ].
    ^ holder.
!

canDeliverForVMS
    |holder|

    (holder := builder bindingAt:#canDeliverForVMS) isNil ifTrue:[
	holder := BlockValue 
			with:[:a1 :a2 | a1 or:[a2 not]] 
			arguments:(Array 
					with:self canDeliverBinaryForVMS
					with:self deliverCompiledBinary).
	builder aspectAt:#canDeliverForVMS put:holder.
    ].
    ^ holder.
!

canDeliverForWin32
    |holder|

    (holder := builder bindingAt:#canDeliverForWin32) isNil ifTrue:[
	holder := BlockValue 
			with:[:a1 :a2 | a1 or:[a2 not]] 
			arguments:(Array 
					with:self canDeliverBinaryForWin32
					with:self deliverCompiledBinary).
	builder aspectAt:#canDeliverForWin32 put:holder.
    ].
    ^ holder.
!

canLoadCurrentProjectHolder
    |holder|

    (holder := builder bindingAt:#canLoadCurrentProjectHolder) isNil ifTrue:[
	holder := false asValue.
	builder aspectAt:#canLoadCurrentProjectHolder put:holder.
    ].
    ^ holder.

    "Modified: / 26.4.1999 / 22:47:33 / cg"
!

canRemoveSelectedClassFromPrerequisites
    |holder|

    (holder := builder bindingAt:#canRemoveSelectedClassFromPrerequisites) isNil ifTrue:[
	holder := BlockValue with:[:m | m notNil] argument:(self selectedRequiredClassInPrerequisites).
	builder aspectAt:#canRemoveSelectedClassFromPrerequisites put:holder.
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

canRemoveSelectedProjectFromPrerequisites
    |holder|

    (holder := builder bindingAt:#canRemoveSelectedProjectFromPrerequisites) isNil ifTrue:[
	holder := BlockValue with:[:m | m notNil] argument:(self selectedRequiredProjectInPrerequisites).
	builder aspectAt:#canRemoveSelectedProjectFromPrerequisites put:holder.
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

canUnloadCurrentProjectHolder
    |holder|

    (holder := builder bindingAt:#canUnloadCurrentProjectHolder) isNil ifTrue:[
	holder := false asValue.
	builder aspectAt:#canUnloadCurrentProjectHolder put:holder.
    ].
    ^ holder.

    "Modified: / 26.4.1999 / 22:47:33 / cg"
!

classList
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#classList) isNil ifTrue:[
	builder aspectAt:#classList put:(holder :=  List new).
    ].
    ^ holder.
!

classTableAdaptor
    ^ self
!

classTableColumns
    ^ self class classTableColumns
!

currentCanvasHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#currentCanvasHolder) isNil ifTrue:[
	builder aspectAt:#currentCanvasHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder.
!

currentProjectWasNotLoadedFromFile
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#currentProjectWasNotLoadedFromFile) isNil ifTrue:[
	builder aspectAt:#currentProjectWasNotLoadedFromFile put:(holder :=  ValueHolder new).
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:01:09 / cg"
!

deliverByteCode
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#deliverByteCode) isNil ifTrue:[
	builder aspectAt:#deliverByteCode put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

deliverCompiledBinary
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#deliverCompiledBinary) isNil ifTrue:[
	builder aspectAt:#deliverCompiledBinary put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

deliverGZipArchive
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#deliverGZipArchive) isNil ifTrue:[
	builder aspectAt:#deliverGZipArchive put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

deliverLoadAllFile
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#deliverLoadAllFile) isNil ifTrue:[
	builder aspectAt:#deliverLoadAllFile put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

deliverMakefiles
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#deliverMakefiles) isNil ifTrue:[
	builder aspectAt:#deliverMakefiles put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

deliverSources
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#deliverSources) isNil ifTrue:[
	builder aspectAt:#deliverSources put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

deliverTarArchive
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#deliverTarArchive) isNil ifTrue:[
	builder aspectAt:#deliverTarArchive put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

deliverZipArchive
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#deliverZipArchive) isNil ifTrue:[
	builder aspectAt:#deliverZipArchive put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

hasProjectSelectedAndProjectFilenameHolder
    ^ [ |dir|

	dir := self projectDirectory value asFilename.
	(dir exists and:[dir isDirectory]) ifTrue:[
	    self hasProjectSelectedHolder value
	] ifFalse:[
	    false
	]
    ].
!

hasProjectSelectedAndProjectFilenameHolderAndProjectCodeIsLoaded
^ true.
    ^ [ |dir|

	dir := self projectDirectory value asFilename.
	(dir exists and:[dir isDirectory]) ifTrue:[
	    (self hasProjectSelectedHolder value) ifTrue:[
		self projectCodeIsLoadedHolder value
	    ] ifFalse:[
		false.
	    ]
	] ifFalse:[
	    false
	]
    ].
!

hasProjectSelectedHolder
    |holder|

    (holder := builder bindingAt:#hasProjectSelectedHolder) isNil ifTrue:[
	holder := false asValue.
	builder aspectAt:#hasProjectSelectedHolder put:holder.
    ].
    ^ holder.

    "Modified: / 26.4.1999 / 22:47:33 / cg"
!

hasSubProjectsSelectedHolder
    ^ [
	self hasSubProjectsNodeSelected
      ]
!

htmlDocumentURLHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#htmlDocumentURLHolder) isNil ifTrue:[
	builder aspectAt:#htmlDocumentURLHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder.
!

installDirectoryMacOS
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#installDirectoryMacOS) isNil ifTrue:[
	builder aspectAt:#installDirectoryMacOS put:(holder := '' asValue).
	holder onChangeSend:#value to:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

installDirectoryUnix
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#installDirectoryUnix) isNil ifTrue:[
	builder aspectAt:#installDirectoryUnix put:(holder := '/opt/smalltalk' asValue).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

installDirectoryVMS
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#installDirectoryVMS) isNil ifTrue:[
	builder aspectAt:#installDirectoryVMS put:(holder := '' asValue).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

installDirectoryWin32
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#installDirectoryWin32) isNil ifTrue:[
	builder aspectAt:#installDirectoryWin32 put:(holder := '\Programme\SmalltalkX' asValue).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

listOfAllClassesInPrerequisites
    |holder classes|

    (holder := builder bindingAt:#listOfAllClassesInPrerequisites) isNil ifTrue:[
	builder aspectAt:#listOfAllClassesInPrerequisites put:(holder := SortedCollection new asValue).

	"/ all unloaded classes and classes which where
	"/ loaded are candidates.

	classes := Smalltalk allClasses 
			select:[:cls |
				cls isMeta not
				and:[
				    cls isLoaded not
				    or:[cls wasAutoloaded]]
			       ].

	"/ mark currently loaded classes as bold;
	"/ LATER: those which are superclasses of any of my classes bold-red.

	classes := classes collect:[:cls | |nm|
					nm := cls name.
					cls isLoaded ifTrue:[
					    nm := nm asText allBold.
					].
					nm
				   ].
	holder value addAll:classes.
	self currentProject wasLoadedFromFile ifFalse:[
	    self updateListOfRequiredPrerequisiteClasses.
	]
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

listOfAllProjectsInPrerequisites
    "automatically generated by UIPainter ..."

    |holder projects currentProject|

    (holder := builder bindingAt:#listOfAllProjectsInPrerequisites) isNil ifTrue:[
	builder aspectAt:#listOfAllProjectsInPrerequisites put:(holder := SortedCollection new asValue).

	currentProject := self currentProject.

	projects := Set new.
	Project allInstancesDo:[:p |
	    (p ~~ currentProject 
	    and:[p ~~ Project defaultProject]) ifTrue:[
		projects add:p name.
	    ]
	].
	holder value addAll:projects.
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

listOfPossibleConditions:aRow
    ^ #( always never autoload '-' unix win32 vms macos)


!

listOfRequiredClassesInPrerequisites
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#listOfRequiredClassesInPrerequisites) isNil ifTrue:[
	builder aspectAt:#listOfRequiredClassesInPrerequisites put:(holder := SortedCollection new asValue).
	self currentProject wasLoadedFromFile ifFalse:[
	    self updateListOfRequiredPrerequisiteClasses.
	]
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

listOfRequiredProjectsInPrerequisites
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#listOfRequiredProjectsInPrerequisites) isNil ifTrue:[
	builder aspectAt:#listOfRequiredProjectsInPrerequisites put:(holder := SortedCollection new asValue).
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

makeDefines
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#makeDefines) isNil ifTrue:[
	builder aspectAt:#makeDefines put:(holder := '' asValue).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

makeIncludes
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#makeIncludes) isNil ifTrue:[
	builder aspectAt:#makeIncludes put:(holder := '' asValue).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

makeOtherWarningOptions
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#makeOtherWarningOptions) isNil ifTrue:[
	builder aspectAt:#makeOtherWarningOptions put:(holder := '' asValue).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

makeWarnEOLComments
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#makeWarnEOLComments) isNil ifTrue:[
	builder aspectAt:#makeWarnEOLComments put:(holder := false asValue).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

makeWarnNonStandard
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#makeWarnNonStandard) isNil ifTrue:[
	builder aspectAt:#makeWarnNonStandard put:(holder := true asValue).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

methodsFile
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#methodsFile) isNil ifTrue:[
	builder aspectAt:#methodsFile put:(holder := '' asValue).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

modifiedChannel
    "automatically generated by UIPainter ..."

    modifiedChannel isNil ifTrue:[
	modifiedChannel := false asValue.
    ].
    ^ modifiedChannel.

!

osIsUnix
    ^ OperatingSystem isUNIXlike

    "Created: / 19.1.2000 / 16:45:16 / cg"
!

osIsWindows
    ^ OperatingSystem isMSWINDOWSlike

    "Created: / 19.1.2000 / 16:37:33 / cg"
    "Modified: / 19.1.2000 / 16:43:54 / cg"
!

patchesList
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#patchesList) isNil ifTrue:[
	builder aspectAt:#patchesList put:(holder :=  List new).
    ].
    ^ holder.
!

projectCodeIsLoadedHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#projectCodeIsLoadedHolder) isNil ifTrue:[
	builder aspectAt:#projectCodeIsLoadedHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

projectDirectory
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#projectDirectory) isNil ifTrue:[
	builder aspectAt:#projectDirectory put:(holder := '.' asValue).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

projectNamespace
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#projectNamespace) isNil ifTrue:[
	builder aspectAt:#projectNamespace put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

projectPackage
    |holder dir module|

    (holder := builder bindingAt:#projectPackage) isNil ifTrue:[
	builder aspectAt:#projectPackage put:(holder := '' asValue).
    ].
    holder value size == 0 ifTrue:[
	(module := self repositoryModule value) notNil ifTrue:[
	    (dir := self repositoryDirectory value) notNil ifTrue:[
		holder value:(module , ':' , dir)
	    ]
	]
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

projectTreeHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#projectTree) isNil ifTrue:[
	builder aspectAt:#projectTree put:(holder :=  SelectionInTree new).
	holder root:self projectTree.
    ].
    ^ holder.
!

projectType
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#projectType) isNil ifTrue:[
	builder aspectAt:#projectType put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

repositoryDirectory
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#repositoryDirectory) isNil ifTrue:[
	builder aspectAt:#repositoryDirectory put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

repositoryModule
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#repositoryModule) isNil ifTrue:[
	builder aspectAt:#repositoryModule put:(holder :=  ValueHolder new).
	holder onChangeEvaluate:[modifiedChannel value:true].
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

rightCanvasTextHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#rightCanvasTextHolder) isNil ifTrue:[
	builder aspectAt:#rightCanvasTextHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder.
!

selectedClassInPrerequisites
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#selectedClassInPrerequisites) isNil ifTrue:[
	builder aspectAt:#selectedClassInPrerequisites put:(holder := ValueHolder new).
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

selectedPatchInRightCanvas
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#selectedPatchInRightCanvas) isNil ifTrue:[
	builder aspectAt:#selectedPatchInRightCanvas put:(holder :=  ValueHolder new).
    ].
    ^ holder.
!

selectedProjectInPrerequisites
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#selectedProjectInPrerequisites) isNil ifTrue:[
	builder aspectAt:#selectedProjectInPrerequisites put:(holder := ValueHolder new).
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

selectedRequiredClassInPrerequisites
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#selectedRequiredClassInPrerequisites) isNil ifTrue:[
	builder aspectAt:#selectedRequiredClassInPrerequisites put:(holder := ValueHolder new).
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

selectedRequiredProjectInPrerequisites
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#selectedRequiredProjectInPrerequisites) isNil ifTrue:[
	builder aspectAt:#selectedRequiredProjectInPrerequisites put:(holder := ValueHolder new).
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

selectedTreeNodeHolder
    "automatically generated by UIPainter ..."

    selectedTreeNodeHolder isNil ifTrue:[
	selectedTreeNodeHolder :=  ValueHolder new.
    ].
    ^ selectedTreeNodeHolder.
!

showWhat
    |holder|

    (holder := builder bindingAt:#showWhat) isNil ifTrue:[
	holder := ValueHolder new.
	builder aspectAt:#showWhat put:holder.
	holder onChangeSend:#projectFilterChanged to:self.
    ].
    ^ holder.

    "Created: / 23.3.1999 / 14:18:05 / cg"
!

textCanvasLabelHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#textCanvasLabelHolder) isNil ifTrue:[
	builder aspectAt:#textCanvasLabelHolder put:(holder :='' asValue).
    ].
    ^ holder.
! !

!ProjectBrowser methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    |cls sel oldMthd newMthd prj package|

    something == #name ifTrue:[
	"/ a project was renamed - update my tree
	self projectTree children do:[:pNode |
	    pNode contents == changedObject ifTrue:[
		pNode name:changedObject name.
		pNode changed.
	    ]
	].
	^ self.
    ].

    prj := self currentProject.
    prj isNil ifTrue:[^ self].

    package := prj package.

    changedObject == prj ifTrue:[
	self readAspectsFromProject.
    ].

    changedObject == Smalltalk ifTrue:[
	something == #newClass ifTrue:[
	    aParameter isBehavior ifTrue:[
		aParameter wasAutoloaded ifTrue:[
		    self listOfAllClassesInPrerequisites add:something name.
		    ^ self.
		].
		aParameter package = package ifTrue:[
		    "/ a new class was added to the package;
		    "/ must look if already there, and possibly update my
		    "/ tree and classList
		    (self currentProject includesClass:aParameter) ifFalse:[
			self halt.
		    ].
		    ^ self.
		]
	    ]
	].

	something == #methodInClass ifTrue:[
	    cls := aParameter first.
	    sel := aParameter second.
	    oldMthd := aParameter third.
	    newMthd := cls compiledMethodAt:sel.

	    cls package ~= package ifTrue:[
		"/ method removed from project ?
		(oldMthd notNil and:[oldMthd package = package]) ifTrue:[
		    (newMthd notNil and:[newMthd package ~= package]) ifTrue:[
			"/ remove from methodList
		    ]
		].

		"/ method added to project ?
		(oldMthd isNil or:[oldMthd package ~= package]) ifTrue:[
		    (newMthd notNil and:[newMthd package = package]) ifTrue:[
			"/ add to methodList
		    ]
		]
	    ]
	].
    ].

    "Modified: / 26.4.1999 / 23:39:04 / cg"
! !

!ProjectBrowser methodsFor:'initialization'!

closeDownViews
    Smalltalk removeDependent:self.
    super closeDownViews.
!

postBuildWith:aBuiler
    Smalltalk addDependent:self.
    self modifiedChannel value:false.

    self updateRightCanvas.
    ^ super postBuildWith:aBuiler
!

setupCanvasForNoSelection
    self 
	showReadOnlyText:'Please select an existing project,
load one from a (''.prj'')-file,
or create a new project.'.
! !

!ProjectBrowser methodsFor:'menus'!

itemMenu
    |m|

    self hasNodeSelected ifFalse:[
	^ self class noItemMenu
    ].
    self hasProjectNodeSelected ifTrue:[
	^ self class projectItemMenu
    ].      
    self hasSubProjectsNodeSelected ifTrue:[
	^ self class subProjectsItemMenu
    ].      
    self hasClassesNodeSelected ifTrue:[
	^ self class classesItemMenu
    ].      
    self hasClassNodeSelected ifTrue:[
	^ self class classItemMenu
    ].      
    self hasMethodNodeSelected ifTrue:[
	^ self class methodItemMenu
    ].      
    self hasPatchesNodeSelected ifTrue:[
	^ self class methodsItemMenu
    ].      
    self hasPrerequisiteClassesNodeSelected ifTrue:[
	^ self class prerequisiteClassesItemMenu
    ].      
    self hasPrerequisitePackagesNodeSelected ifTrue:[
	^ self class prerequisitePackagesItemMenu
    ].      
    ^ nil
!

itemMenuHolder
    ^ [ self itemMenu]
!

itemMenuPerformer
    ^ self
! !

!ProjectBrowser methodsFor:'private'!

addProjectNodeToTree:newNode
    |aProject nodeToAdd path childNode|

"/    projectTree add:newNode.

    "/ insert into tree ...
    nodeToAdd := projectTree.

    path := newNode contents package asCollectionOfSubstringsSeparatedByAny:'/\:'.
    path from:1 to:path size-1 do:[:part |
	childNode := nodeToAdd children detect:[:child | child name = part] ifNone:nil.
	childNode isNil ifTrue:[
	    nodeToAdd add:(childNode := ProjectTreeItem new name:part).
	].
	nodeToAdd := childNode.
    ].
    newNode name:(path last).
    nodeToAdd add:newNode.

!

canAddClassToPrerequisites:aClassName
    ^ aClassName notNil
!

canAddProjectToPrerequisites:aProjectName
    ^ aProjectName notNil
      and:[aProjectName ~= self currentProject name]
!

canLoadClassesFromDirectory
    |p projectDir|

    self hasClassesNodeSelected ifFalse:[^ false].

    (p := self currentProject) isNil ifTrue:[^ false].
    (projectDir := p directory) size == 0 ifTrue:[^ false].
    projectDir asFilename exists ifFalse:[^ false].

    ^ true
!

canLoadClassesFromRepository
    |manager p moduleDir packageDir|

    self hasClassesNodeSelected ifFalse:[^ false].

    (p := self currentProject) isNil ifTrue:[^ false].
    (moduleDir := p repositoryModule) size == 0 ifTrue:[^ false].
    (packageDir := p repositoryDirectory) size == 0 ifTrue:[^ false].

    "/ SourceCodeManager available ?

    (AbstractSourceCodeManager notNil 
    and:[AbstractSourceCodeManager isLoaded not]) ifTrue:[
	AbstractSourceCodeManager autoload.    
    ].

    AbstractSourceCodeManager isNil ifTrue:[^ false].
    AbstractSourceCodeManager isLoaded ifFalse:[^ false].
    (manager := Smalltalk at:#SourceCodeManager) isNil ifTrue:[^ false].

    "/ does the repository contain the module/package ?
    "/ since this is a slow operation (involving the CVS manager,
    "/ remember checked modules here in a classVar
    AlreadCheckedExistingModulesAndPackages isNil ifTrue:[
	AlreadCheckedExistingModulesAndPackages := OrderedCollection new
    ].
    AlreadCheckedExistingModulesAndPackages do:[:entry |
	(entry at:1) = moduleDir ifTrue:[
	    (entry at:2) = packageDir ifTrue:[
		^ true
	    ]
	]
    ].

    (manager checkForExistingModule:moduleDir package:packageDir) ifFalse:[^ false].

    AlreadCheckedExistingModulesAndPackages add:(Array with:moduleDir with:packageDir).
    ^ true
!

canLoadCurrentProject
    |prj|

    self hasProjectSelected ifFalse:[^ false].
    (prj := self currentProject) isNil ifTrue:[^ self].
    ^ prj isLoaded not

!

canUnloadCurrentProject
    |prj|

    self hasProjectSelected ifFalse:[^ false].
    (prj := self currentProject) isNil ifTrue:[^ self].
    ^ prj isLoaded

!

checkInClasses:aCollectionOfClasses
    |logMessage|

    logMessage := SourceCodeManagerUtilities getLogMessageFor:'classes in project'.
    SourceCodeManagerUtilities checkinClasses:aCollectionOfClasses withLog:logMessage.
!

currentProject
    |node|

    node := self currentProjectNode.
    node isNil ifTrue:[^ nil].
    ^ node contents

!

currentProjectNode
    |node|

    node := self selectedTreeNode.
    node isNil ifTrue:[^ nil].

    [node notNil and:[node isProjectNode not]] whileTrue:[
	node := node parent.
    ].
    node notNil ifTrue:[
	^ node
    ].
    ^ nil

!

currentProjectsClassNames
    |p|

    p := self currentProject.
    ^ p classes 
	collect:[:classOrSymbol |
		    classOrSymbol isBehavior ifTrue:[
			classOrSymbol name
		    ] ifFalse:[
			classOrSymbol
		    ]
		]

!

expandPathToNodeFor:someContents
    |theNode|

    theNode := self projectTreeHolder 
		    detectFirstItem:[:item | item contents == someContents].

    [theNode notNil] whileTrue:[
	self projectTreeHolder expand:theNode.
	theNode := theNode parent.
    ].



!

hasClassNodeSelected
    |selectedNode|

    selectedNode := self selectedTreeNode.
    selectedNode isNil ifTrue:[^ false].

    ^ selectedNode contents isAssociation
      and:[selectedNode contents key == #class]

!

hasClassesNodeSelected
    ^ self hasNodeSelected:#classes.

!

hasMethodNodeSelected
    |selectedNode|

    selectedNode := self selectedTreeNode.
    selectedNode isNil ifTrue:[^ false].

    ^ selectedNode contents isAssociation
      and:[selectedNode contents key == #method]

!

hasNodeSelected
    ^ self selectedTreeNode notNil

!

hasNodeSelected:type
    |selectedNode|

    selectedNode := self selectedTreeNode.
    selectedNode isNil ifTrue:[^ false].

    ^ selectedNode contents == type

!

hasPatchesNodeSelected
    ^ self hasNodeSelected:#patches.

!

hasPrerequisiteClassesNodeSelected
    ^ self hasNodeSelected:#prerequisiteClasses.
!

hasPrerequisitePackagesNodeSelected
    ^ self hasNodeSelected:#prerequisitePackages.
!

hasPrerequisitesNodeSelected
    ^ self hasNodeSelected:#prerequisites.

!

hasProjectNodeSelected
    |selectedNode|

    selectedNode := self selectedTreeNode.
    selectedNode isNil ifTrue:[^ false].

    ^ selectedNode isProjectNode

!

hasProjectSelected
    |selectedNode node|

    selectedNode := self selectedTreeNode.
    selectedNode isNil ifTrue:[^ false].

    node := selectedNode.
    [node notNil] whileTrue:[
	node isProjectNode ifTrue:[^ true].
	node := node parent.
    ].
    ^ false.
!

hasSubProjectsNodeSelected
    ^ self hasNodeSelected:#subprojects.

!

makeTranscriptVisible
    |transcript|

    transcript := self transcript.

    (transcript relativeCorner y - transcript relativeOrigin y) < 0.1 ifTrue:[
	(self builder componentAt:#VariableVerticalPanel1)      
	    resizeSubViewsTo:#(0.7 0.3)
    ].



!

nodeFor:aProject
    "generate and return a treeNode for some project"

    |projectName pNode 
     propertiesNode docNode classesNode patchesNode subprojectsNode filesNode
     commentNode prerequisitesNode analysisNode designNode codeNode
     userDocNode userOverViewNode userGuideNode userRefManNode
     deploymentNode classIcon methodIcon buildOptionsNode
     prerequisitePackagesNode prerequisiteClassesNode|

    projectName := aProject name.
    pNode := ProjectNode name:projectName.
    pNode contents:aProject.

    pNode add:(commentNode := ProjectTreeItem name:'Comment').
"/    pNode add:(docNode := ProjectTreeItem name:'Documentation').
    pNode add:(propertiesNode := ProjectTreeItem name:'Properties').
    pNode add:(prerequisitesNode := ProjectTreeItem name:'Prerequisites').
"/    pNode add:(subprojectsNode := ProjectTreeItem name:'SubProjects').
    pNode add:(classesNode := ProjectTreeItem name:'Classes').
    pNode add:(patchesNode := ProjectTreeItem name:'Patches & Extensions').
    pNode add:(filesNode := ProjectTreeItem name:'Files').
    pNode add:(buildOptionsNode := ProjectTreeItem name:'Build Options').
    pNode add:(deploymentNode := ProjectTreeItem name:'Deployment').

    subprojectsNode notNil ifTrue:[
	subprojectsNode contents:#subprojects.
	aProject subProjects do:[:aSubProject |
	    subprojectsNode add:(self nodeFor:aSubProject)
	].
    ].

    commentNode icon:(self class commentIcon).
    commentNode action:[:item | self showCommentOf:item].
    commentNode info:'Some comment describing the project'.
    commentNode contents:#comment.

    docNode notNil ifTrue:[
	docNode contents:#documentation.
	docNode action:[:item | self showDocumentationFor:item].

	docNode add:(analysisNode := ProjectTreeItem name:'Analysis').
	docNode add:(designNode := ProjectTreeItem name:'Design').
	docNode add:(codeNode := ProjectTreeItem name:'Code').
	docNode add:(userDocNode := ProjectTreeItem name:'User Documentation').
	userDocNode add:(userOverViewNode := ProjectTreeItem name:'Overview').
	userDocNode add:(userGuideNode := ProjectTreeItem name:'Guide').
	userDocNode add:(userRefManNode := ProjectTreeItem name:'Reference').
	docNode add:(userDocNode := ProjectTreeItem name:'Error Reports').
	docNode add:(userDocNode := ProjectTreeItem name:'Other').
    ].

    prerequisitesNode contents:#prerequisites.
    prerequisitesNode icon:(self class prerequisitesIcon).
    prerequisitesNode add:(prerequisitePackagesNode := ProjectTreeItem name:'Packages').
    prerequisitesNode add:(prerequisiteClassesNode := ProjectTreeItem name:'Classes').
    prerequisitesNode info:'Other projects and classes required by the project'.

    prerequisitePackagesNode contents:#prerequisitePackages.
    prerequisitePackagesNode icon:(self class prerequisitePackagesIcon).
    prerequisitePackagesNode spec:[self class rightCanvasSpecForPrerequisitePackages].
    prerequisitePackagesNode info:'Other projects required by the project'.

    prerequisiteClassesNode contents:#prerequisiteClasses.
    prerequisiteClassesNode icon:(self class prerequisiteClassesIcon).
    prerequisiteClassesNode spec:[self class rightCanvasSpecForPrerequisiteClasses].
    prerequisiteClassesNode info:'Other (autoloaded-) classes required by the project'.

    classIcon := self class classIcon.

    classesNode contents:#classes.
    classesNode icon:(self class classesIcon).
    classesNode info:'Classes contained in the project'.
    (aProject classes copy 
	sort:[:a :b | 
		    |nmA nmB|

		    nmA := a isBehavior ifTrue:[a name] ifFalse:[a].
		    nmB := b isBehavior ifTrue:[b name] ifFalse:[b].
		    nmA < nmB
	     ]
    ) do:[:aClass |
	|cNode cName|

	cName := aClass isBehavior ifTrue:[aClass name] ifFalse:[aClass].
	cNode := ProjectTreeItem name:cName.
	cNode contents:(#class -> aClass).
	cNode icon:classIcon.
	classesNode add:cNode.
    ].


    propertiesNode contents:#properties.
    propertiesNode spec:[self class rightCanvasSpecForProperties].
    propertiesNode info:'Project propreties'.

    filesNode contents:#files.
    filesNode icon:(self class filesIcon).
    filesNode info:'Files (extensions, bitmaps, data) contained in the project'.
    filesNode spec:[self class rightCanvasSpecForFiles].

    methodIcon := self class methodIcon.

    patchesNode contents:#patches.
    patchesNode icon:(self class methodsIcon).
    patchesNode info:'Patches & Extensions (system-changes) contained in the project'.
    (aProject methodInfo copy 
	sort:[:a :b | 
		    a displayString < b displayString.
	    ]
    ) do:[:aMethodInfo |
	|cNode cName|

	cNode := ProjectTreeItem name:(aMethodInfo className , ' ' , aMethodInfo methodName).
	cNode contents:(#method -> aMethodInfo).
	cNode icon:methodIcon.
	patchesNode add:cNode.
    ].

    deploymentNode icon:(self class deploymentIcon).
    deploymentNode spec:[self class rightCanvasSpecForDeployment].
    deploymentNode info:'Deployment & packaging specification.'.
    deploymentNode contents:#deployment.

    buildOptionsNode icon:(self class buildOptionsIcon).
    buildOptionsNode spec:[self class rightCanvasSpecForBuildOptions].
    buildOptionsNode info:'Compilation & include options.'.
    buildOptionsNode contents:#buildOptions.

    ^ pNode

    "Modified: / 23.3.1999 / 14:27:30 / cg"
!

projectTree
    projectTree isNil ifTrue:[
	self updateProjectTree
    ].

    ^ projectTree
!

readAspectsFromProject
    |p type l ns mMod mDir mPkg pkg|

    p := self currentProject.
    p notNil ifTrue:[
	self selectedTreeNode contents == #comment ifTrue:[
	    self rightCanvasTextHolder value:p comment.
	].

	self methodsFile value:(p propertyAt:#methodsFile).
	self projectCodeIsLoadedHolder value:(p isLoaded == true).
	p isLoaded == true ifFalse:[
	    self valueOfInfoLabel value:'Projects code is not loaded.'
	].

	self currentProjectWasNotLoadedFromFile value:p wasLoadedFromFile not.
	(type := p type) == #classLibrary ifTrue:[
	   type := #library
	].
	self projectType value:type.
	self projectDirectory value:(p directory).
	ns := p defaultNameSpace ? Smalltalk.
	ns isSymbol ifFalse:[
	    ns := ns name
	].
	self projectNamespace value:ns.

	pkg := p package ? Project current package.
	mMod := p repositoryModule ? '?'.
	mDir := p repositoryDirectory ? '?'.
	mPkg := mMod , ':' , mDir.

	mPkg ~= pkg ifTrue:[
	    (pkg includes:$:) ifTrue:[
		mMod := pkg upTo:$:.
		mDir := pkg copyFrom:mMod size + 2.
"/                self warn:('package id: ''' , pkg , ''' different from moduleId: ''' , mPkg , 
"/                           '\\Assume module:''' , mMod , ''' directory:''' , mDir , '''') withCRs.
	    ] ifFalse:[
		((mMod ~= '?') and:[mDir ~= '?']) ifTrue:[
"/                    self warn:('package id: ''' , pkg , ''' different from moduleId: ''' , mPkg , 
"/                               '\\Assume package:''' , mMod , ':' , mDir , '''') withCRs.
		    pkg := mMod , ':' , mDir
		] ifFalse:[
"/                    self warn:('package id: ''' , pkg , ''' different from moduleId: ''' , mPkg , 
"/                               '\\Please care for the module and directory settings.') withCRs.
		]
	    ]
	].
	self projectPackage value:pkg.
	self repositoryModule value:mMod.
	self repositoryDirectory value:mDir.

	self deliverCompiledBinary value:(p propertyAt:#deliverCompiledBinary) ? false.
	self deliverByteCode value:(p propertyAt:#deliverByteCode) ? false.
	self deliverGZipArchive value:(p propertyAt:#deliverGZipArchive) ? false.
	self deliverZipArchive value:(p propertyAt:#deliverZipArchive) ? false.
	self deliverTarArchive value:(p propertyAt:#deliverTarArchive) ? false.
	self deliverLoadAllFile value:(p propertyAt:#deliverLoadAllFile) ? false.
	self deliverSources value:(p propertyAt:#deliverSources) ? false.
	self deliverMakefiles value:(p propertyAt:#deliverMakefiles) ? false.

	self makeDefines value:(p propertyAt:#'make.stc.LOCALDEFINES') ? ''.
	self makeIncludes value:(p propertyAt:#'make.stc.LOCALINCLUDES') ? ''.
	self makeOtherWarningOptions value:(p propertyAt:#'make.stc.WARNINGOPTIONS') ? ''.
	self makeWarnEOLComments value:(p propertyAt:#'make.stc.warnEOLComments') ? false.
	self makeWarnNonStandard value:(p propertyAt:#'make.stc.warnNonStandard') ? true.

"/        self makeLocalLibs value:(p propertyAt:#'make.LD_OBJ_LIBS') ? ''.
"/        self makeExtraTargets value:(p propertyAt:#'make.LOCAL_EXTRA_TARGETS') ? ''.

	self installDirectoryUnix 
		value:(p propertyAt:#installDirectoryUnix) ? 
			((p propertyAt:#installDirectory) ? '/opt/smalltalk/packages').
	self installDirectoryWin32 
		value:(p propertyAt:#installDirectoryWin32) ? 
			((p propertyAt:#installDirectory) ? '\Programme\SmalltalkX\packages').
	self installDirectoryVMS 
		value:(p propertyAt:#installDirectoryVMS) ? 
			((p propertyAt:#installDirectory) ? 'SYS$SMALLTALKX:[PACKAGES]').
"/        self installDirectoryMacOS 
"/                value:(p propertyAt:#installDirectoryMacOS) ? 
"/                        ((p propertyAt:#installDirectory) ? '\Programme\SmalltalkX').

	l := p prerequisitePackages collect:[:entry |
		    |pName|

		    entry isString ifTrue:[
			pName := entry
		    ] ifFalse:[
			entry isArray ifTrue:[
			    pName := entry at:1
			] ifFalse:[
			    pName := entry name
			]
		    ]
		].
	self listOfRequiredProjectsInPrerequisites value:(l sort).
	self listOfRequiredClassesInPrerequisites value:(p prerequisiteClasses copy sort).

	modifiedChannel value:false.
	p addDependent:self.
    ].

    "Created: / 23.3.1999 / 14:16:12 / cg"
    "Modified: / 26.4.1999 / 23:38:14 / cg"
!

reallyModified
    |p l selectedNodeType|

    p := self currentProject.
    selectedNodeType := self selectedTreeNode contents.

    selectedNodeType == #comment ifTrue:[
self halt.
	^ self rightCanvasTextHolder value ~= p comment
    ].
    selectedNodeType == #deployment ifTrue:[
	(self deliverByteCode value ~= (p propertyAt:#deliverByteCode)) ifTrue:[^ true].
	(self deliverCompiledBinary value ~= (p propertyAt:#deliverCompiledBinary)) ifTrue:[^ true].
	(self deliverLoadAllFile value ~= (p propertyAt:#deliverLoadAllFile)) ifTrue:[^ true]. 
	(self deliverSources value ~= (p propertyAt:#deliverSources)) ifTrue:[^ true].
	(self deliverMakefiles value ~= (p propertyAt:#deliverMakefiles)) ifTrue:[^ true].

	(self deliverZipArchive value ~= (p propertyAt:#deliverZipArchive)) ifTrue:[^ true].
	(self deliverTarArchive value ~= (p propertyAt:#deliverTarArchive)) ifTrue:[^ true].
	(self deliverGZipArchive value ~= (p propertyAt:#deliverGZipArchive)) ifTrue:[^ true].

	self installDirectoryUnix value ~=
		    ((p propertyAt:#installDirectoryUnix) ? 
		       ((p propertyAt:#installDirectory) ? 
			    '/opt/smalltalk/packages')) ifTrue:[^ true].

	self installDirectoryWin32 value ~=
		    ((p propertyAt:#installDirectoryWin32) ? 
			((p propertyAt:#installDirectory) ? 
			    '\Programme\SmalltalkX\packages')) ifTrue:[^ true].

	self installDirectoryVMS value ~=
		    ((p propertyAt:#installDirectoryVMS) ? 
			((p propertyAt:#installDirectory) ? 
			    'SYS$SMALLTALKX:[PACKAGES]')) ifTrue:[^ true].

	^ false
    ].
    selectedNodeType == #files ifTrue:[
^ true.
	(self methodsFile value ~= (p propertyAt:#methodsFile)) ifTrue:[^ true].
	^ false
    ].
self halt.

    (self projectType value ~~ p type) ifTrue:[^ true].
    (self projectDirectory value ~= p directory) ifTrue:[^ true].
    (self projectPackage value ~= p package) ifTrue:[^ true].
    (self projectNamespace value ~= (p defaultNameSpace ? Smalltalk) name) ifTrue:[^ true].

    (self repositoryModule value ~= p repositoryModule) ifTrue:[^ true].
    (self repositoryDirectory value ~= p repositoryDirectory) ifTrue:[^ true].

"/        self installDirectoryMacOS value ~=
"/                ((p propertyAt:#installDirectoryMacOS) ? 
"/                    ((p propertyAt:#installDirectory) ? 
"/                        '\Programme\SmalltalkX')) ifTrue:[^ true].

    l := p prerequisitePackages collect:[:entry |
		|pName|

		entry isString ifTrue:[
		    pName := entry
		] ifFalse:[
		    entry isArray ifTrue:[
			pName := entry at:1
		    ] ifFalse:[
			pName := entry name
		    ]
		]
	    ].
    self listOfRequiredProjectsInPrerequisites value ~= (l sort) ifTrue:[^ true].
    self listOfRequiredClassesInPrerequisites value ~= (p prerequisiteClasses copy sort)  ifTrue:[^ true].
    self halt.

!

saveAspectsIntoProject
    |p s ns dir pkg|

    p := self currentProject.
    p notNil ifTrue:[
	p removeDependent:self.

	self acceptChannel value:true; value:false.

"/        self currentProjectWasNotLoadedFromFile value:p wasLoadedFromFile not.
	p type:self projectType value.

	dir := self projectDirectory value.
	dir := (dir ? '') asFilename.
	(dir exists and:[dir isDirectory]) ifFalse:[
	    self warn:'Invalid project directory: ' , dir pathName
	].

	p directory:self projectDirectory value.
	pkg := self repositoryModule value , ':' , self repositoryDirectory value.
	p packageName:pkg asSymbol.

	p repositoryModule:self repositoryModule value.
	p repositoryDirectory:self repositoryDirectory value.

	s := self projectNamespace value.
	(s size == 0) ifTrue:[
	    ns := Smalltalk
	] ifFalse:[
	    ns := NameSpace name:s
	].
	p defaultNameSpace:ns.

	p propertyAt:#methodsFile put:self methodsFile value.

	p propertyAt:#deliverCompiledBinary put:self deliverCompiledBinary value.
	p propertyAt:#deliverByteCode put:self deliverByteCode value.
	p propertyAt:#deliverTarArchive put:self deliverTarArchive value.
	p propertyAt:#deliverZipArchive put:self deliverZipArchive value.
	p propertyAt:#deliverGZipArchive put:self deliverGZipArchive value.
	p propertyAt:#deliverLoadAllFile put:self deliverLoadAllFile value.
	p propertyAt:#deliverSources put:self deliverSources value.
	p propertyAt:#deliverMakefiles put:self deliverMakefiles value.

	p propertyAt:#'make.stc.LOCALDEFINES' put:self makeDefines value.
	p propertyAt:#'make.stc.LOCALINCLUDES' put:self makeIncludes value.
	p propertyAt:#'make.stc.WARNINGOPTIONS' put:self makeOtherWarningOptions value.
	p propertyAt:#'make.stc.warnEOLComments' put:self makeWarnEOLComments value.
	p propertyAt:#'make.stc.warnNonStandard' put:self makeWarnNonStandard value.

"/        p propertyAt:#'make.LD_OBJ_LIBS' put:self makeLocalLibs value.
"/        p propertyAt:#'make.LOCAL_EXTRA_TARGETS' put:self makeExtraTargets value.

	p propertyAt:#installDirectoryUnix put:self installDirectoryUnix value.
	p propertyAt:#installDirectoryWin32 put:self installDirectoryWin32 value.
	p propertyAt:#installDirectoryVMS put:self installDirectoryVMS value.
	p propertyAt:#installDirectoryMacOS put:self installDirectoryMacOS value.

	p prerequisiteClasses:(self listOfRequiredClassesInPrerequisites value
			       collect:[:entry | entry string asSymbol]).

	p prerequisitePackages:(self listOfRequiredProjectsInPrerequisites value
			       collect:[:entry | entry string asSymbol]).

	p addDependent:self.
    ].

    "Created: / 23.3.1999 / 14:16:12 / cg"
    "Modified: / 23.3.1999 / 14:18:38 / cg"
!

selectedMethod
    |node methodInfo classOrClassName cls mthd text|

    self hasMethodNodeSelected ifFalse:[^ nil].

    node := self selectedTreeNode.
    methodInfo := node contents value.
    mthd := methodInfo method.
    mthd isNil ifTrue:[
	self valueOfInfoLabel value:'The method is not (yet) loaded.'.
    ].
    ^ mthd
!

transcript
    ^ self builder componentAt:#commandOutputView
!

updateFlagValueHolders
    self hasProjectSelectedHolder value:(self hasProjectSelected).
    self canLoadCurrentProjectHolder value:(self canLoadCurrentProject).
    self canUnloadCurrentProjectHolder value:(self canUnloadCurrentProject).

!

updateProjectTree
    |tree moduleRoots root showWhat|

    self withCursor:Cursor execute do:[
	showWhat := self showWhat value.

	moduleRoots := Dictionary new.

	tree := SelectionInTree new.
	tree root:(root := ProjectTreeItem name:'invisibleRoot').
	root hide:false.

	showWhat notNil ifTrue:[
	    showWhat == #current ifTrue:[
		root add:(self nodeFor:Project current).
	    ] ifFalse:[
		(Project knownProjects asOrderedCollection
		    sort:[:a :b | a package < b package]) 
		do:[:aProject |
		    |newNode nodeToAdd doShow childNode path|

		    (doShow := showWhat == #all) ifFalse:[
			doShow := (aProject package startsWith:'stx:') not
		    ].

		    doShow ifTrue:[
			newNode := self nodeFor:aProject.

			"/ insert into tree ...
			nodeToAdd := root.

			path := aProject package asCollectionOfSubstringsSeparatedByAny:'/\:'.
			path from:1 to:path size-1 do:[:part |
			    childNode := nodeToAdd children detect:[:child | child name = part] ifNone:nil.
			    childNode isNil ifTrue:[
				nodeToAdd add:(childNode := ProjectTreeItem new name:part).
			    ].
			    nodeToAdd := childNode.
			].
			newNode name:(path last).
			nodeToAdd add:newNode.
		    ]
		].
	    ].
	].
	projectTree := root.

	self projectTreeHolder root:projectTree.
    ].
    ^ projectTree
!

updateRightCanvas
    |selectedNode nodeContents spec|

    self builder bindings removeKey:#listOfAllClassesInPrerequisites ifAbsent:nil.  "/ force recompute
    self builder bindings removeKey:#listOfAllProjectsInPrerequisites ifAbsent:nil.  "/ force recompute

    self selectedProjectInPrerequisites value:nil.
    self selectedRequiredProjectInPrerequisites value:nil.

    selectedNode := self selectedTreeNode.
    selectedNode isNil ifTrue:[
	self setupCanvasForNoSelection.
	^ self
    ].

    (spec := selectedNode spec) notNil ifTrue:[
	self currentCanvasHolder value:spec value.
	^ self
    ].

    selectedNode isProjectNode ifTrue:[
	self showCommentOf:selectedNode.
	^ self.
    ].

    selectedNode contents == #classes ifTrue:[
	self showClassListOf:selectedNode.
	^ self.
    ].
    selectedNode contents == #patches ifTrue:[
	self showPatchesListOf:selectedNode.
	^ self.
    ].
    self hasClassNodeSelected ifTrue:[
	self showClassDefinitionOf:selectedNode.
	^ self.
    ].      
    self hasMethodNodeSelected ifTrue:[
	self showMethodSourceOf:selectedNode.
	^ self.
    ].      
    self hasPrerequisitesNodeSelected ifTrue:[
	self showPrerequisitesInfo.
	^ self.
    ].

    self currentCanvasHolder value:(self class emptyRightCanvasSpec).
    self rightCanvasTextHolder value:''.

    "Modified: / 23.3.1999 / 14:16:02 / cg"

! !

!ProjectBrowser methodsFor:'private - building'!

checkForMakeProtoFor:aProject
    |f|

    "/ check for project directory ...
    (self checkForProjectDirectoryFor:aProject) ifFalse:[
	^ false
    ].

    "/ check for Make.proto ...
    f := aProject directory asFilename construct:'Make.proto'.
    f exists ifFalse:[
	(self confirm:'''Make.proto'' does not exist in project directory\\Create ?' withCRs) ifFalse:[
	    ^ false
	].
	self buildMakefiles.
    ].
    ^ true
!

checkForMakefileFor:aProject
    |f|

    "/ check for project directory ...
    (self checkForProjectDirectoryFor:aProject) ifFalse:[
	^ false
    ].

    "/ check for Makefile ...
    f := aProject directory asFilename construct:'Makefile'.
    f exists ifFalse:[
	(self confirm:'''Makefile'' does not exist in project directory\\Create ?' withCRs) ifFalse:[
	    ^ false
	].
	(self checkForMakeProtoFor:aProject) ifFalse:[
	    ^ false
	].
	self buildMakefiles.
    ].
    ^ true
!

checkForProjectDirectoryFor:aProject
    |dir|

    "/ check for project directory ...
    dir := aProject directory asFilename.
    dir exists ifFalse:[
	(self confirm:'Project directory does not exist\\Create ?' withCRs) ifFalse:[
	    ^ false
	].
	dir recursiveMakeDirectory.
    ].
    ^ true


! !

!ProjectBrowser methodsFor:'private - info'!

showPrerequisitesInfo
	self showReadOnlyText:
'When loading this package, 
these other packages/classes 
will be loaded before.
Also, the prerequisite packages'' 
directory pathes will be added
to the include path for 
stc-compilation.'.

	^ self.


! !

!ProjectBrowser methodsFor:'private - table col access'!

classFilenameFromClassInfo:cInfo
    ^ cInfo classFileName
!

classIncludeConditionFromClassInfo:cInfo
    ^ cInfo conditionForInclusion
!

classIncludeConditionFromClassInfo:cInfo put:aSymbol
    cInfo conditionForInclusion:aSymbol.
    ^ cInfo
!

classNameFromClassInfo:cInfo
    |cls nm|

    nm := cInfo className.

    cls := cInfo theClass.
    (cls isNil or:[cls isLoaded not]) ifTrue:[
	^ nm asText allItalic
    ].
    ^ nm

    "Modified: / 26.9.1999 / 13:49:51 / cg"
!

classNameFromMethodInfo:pInfo
    ^ pInfo className
!

classNameFromPatchesInfo:pInfo
    ^ pInfo methodClass name
!

selectorFromMethodInfo:pInfo
    ^ pInfo methodName
!

selectorFromPatchesInfo:pInfo
    ^ pInfo methodSelector
! !

!ProjectBrowser methodsFor:'user actions'!

addClasses
    "ask for, and add a single class"

    |p className cls oldPackage|

    p := self currentProject.

    className := Dialog request:'Class to add:'.
    className size == 0 ifTrue:[^ self].
    cls := Smalltalk classNamed:className.
    cls isNil ifTrue:[
	"/ a new one
	(self confirm:'This is a new class. Add ?') ifFalse:[
	    ^ self      
	].
	p
	    addClass:className
	    classFileName:((Smalltalk fileNameForClass:className) , '.st').
    ] ifFalse:[
	(oldPackage := cls package) ~= p package ifTrue:[
	    "/ a new one
	    (self confirm:'Change the classes package from ' , oldPackage , ' to ' , p package , ' ?') ifFalse:[
		^ self      
	    ].
	    cls package:p package.
	].
	"/ find the other package ..
	oldPackage := Project projectWithId:oldPackage.
	oldPackage notNil ifTrue:[
	    oldPackage removeClass:cls
	].

	p
	    addClass:cls name
	    classFileName:(cls classFilename 
			    ? ((Smalltalk fileNameForClass:cls) , '.st')).
    ].

    self updateClassListForProject:p

!

itemDoubleClicked:index
    |node classOrClassName cls|

    self hasClassNodeSelected ifTrue:[
	node := self selectedTreeNode.
	classOrClassName := node contents value.
	classOrClassName isBehavior ifTrue:[
	    cls := classOrClassName.
	] ifFalse:[
	    cls := Smalltalk at:classOrClassName.
	].
	cls isNil ifTrue:[
	    self information:'The class is not (yet) loaded'.
	    ^ self
	].
	SystemBrowser browseClass:cls.
    ].
!

itemSelected:index
    |item action info p|

    self withWaitCursorDo:[
	self updateRightCanvas.
    ].
    index isNil ifTrue:[
	modifiedChannel value:false.
	^ self
    ].

    self readAspectsFromProject.

    item := self projectTreeHolder value at:index.
    action := item action.
    action notNil ifTrue:[
	action value:item.
    ].

    info := item info.
    info size == 0 ifTrue:[
	((p := self currentProject) notNil
	and:[p isLoaded ~~ true]) ifTrue:[
	    info := 'Projects code is not loaded.'
	].
    ].
    self valueOfInfoLabel value:info.

    self updateFlagValueHolders.
    modifiedChannel value:false.

    "Modified: / 26.4.1999 / 22:49:20 / cg"
!

loadFromProjectFile:aFilenameString
    |oldNode newProject|

    self withReadCursorDo:[
	newProject := Project new loadFromProjectFile:aFilenameString.

	oldNode := self projectTreeHolder 
			detectFirstItem:[:item | item contents class == Project
						 and:[item contents package = newProject package]].
	oldNode notNil ifTrue:[
	    (self confirm:'Overload packages definitions from file ?') ifFalse:[
		^ self
	    ].
	    self projectTreeHolder remove:oldNode.
	].

	newProject notNil ifTrue:[
	    self newProject:newProject
	].
	self expandPathToNodeFor:newProject.

    ].
    ^ newProject
!

loadProject
    |project|

    project := self currentProject.
self halt.
    Smalltalk loadPackage:(project name)
!

loadProjectCode
    |project filesToLoad methodsFile ns anyPatchClassMissing anyPatches
     nMissingSuper prevNMissingSuper|

    project := self currentProject.
    ns := project defaultNameSpace.
    ns isSymbol ifTrue:[
        ns := NameSpace name:ns
    ].
    self withReadCursorDo:[
        filesToLoad := OrderedCollection new.

        "/ load all classes ...
        project classInfo do:[:aClassInfo |
            |className fileToLoad cls|

            className := aClassInfo className.
            fileToLoad := aClassInfo classFileName.
            cls := ns at:className asSymbol.
            cls notNil ifTrue:[
                cls isBehavior ifFalse:[
                    (self confirm:('Attention: a global named ' , className , ' exists, but is not a class.\\Load anyway ?') withCRs)
                    ifFalse:[
                        fileToLoad := nil
                    ]
                ] ifTrue:[
                    cls isLoaded ifTrue:[
                        fileToLoad := nil
                    ]
                ]
            ].
            fileToLoad notNil ifTrue:[
                filesToLoad add:fileToLoad
            ].
        ].

        anyPatchClassMissing := false.
        anyPatches := false.
        project methodInfo do:[:aMethodInfo |
            |className methodName mthd cls|

            className := aMethodInfo className.
            methodName := aMethodInfo methodName.
            cls := Smalltalk at:className asSymbol.
            (cls isNil or:[cls isBehavior not or:[cls isLoaded not]]) ifTrue:[
                self warn:('Missing class: ' , className , ' (required for patches)').
                anyPatchClassMissing := anyPatches := true.
            ] ifFalse:[
                "/ already present ?
                (cls compiledMethodAt:methodName asSymbol) isNil ifTrue:[
                    anyPatches := true.
                ]
            ]
        ].

        (methodsFile := project propertyAt:#methodsFile) notNil ifTrue:[
            anyPatches ifTrue:[
                anyPatchClassMissing ifTrue:[
                    self warn:('Cannot load patches & extensions, due to missing class(es)')
                ] ifFalse:[
                    filesToLoad add:methodsFile
                ]
            ]
        ] ifFalse:[
            anyPatches ifTrue:[
                self warn:('No file for methods (patches & extensions) is defined in project')
            ].
        ].

        filesToLoad size == 0 ifTrue:[
            self information:'Projects code is already loaded.'
        ] ifFalse:[
            "/ load as long as superclasses are missing
            "/ (since the load order could be incorrect)
            prevNMissingSuper := nil.
            nMissingSuper := 1.
            [nMissingSuper > 0 and:[nMissingSuper ~~ prevNMissingSuper]]
            whileTrue:[
                nMissingSuper := 0.
                UndefinedSuperclassError handle:[:ex |
                    nMissingSuper := nMissingSuper + 1.
                    ex proceed
                ] do:[
                    Class packageQuerySignal answer:project package asSymbol
                    do:[
                        filesToLoad do:[:fileToLoad |
                            Smalltalk fileIn:(project directory asFilename construct:fileToLoad) pathName
                        ]
                    ]
                ].
                prevNMissingSuper := nMissingSuper.
            ].
        ].
        project isLoaded:true.
        self readAspectsFromProject
    ]
!

methodPatchDoubleClick:arg
self halt.
!

projectFilterChanged
    |theNode|

    self updateProjectTree.
    self updateRightCanvas.
    self showWhat value == #current ifTrue:[
	theNode := self projectTreeHolder 
			detectFirstItem:[:item | item contents == Project current].

	[theNode notNil] whileTrue:[
	    self projectTreeHolder expand:theNode.
	    theNode := theNode parent.
	].

    ].
!

selectionChangeAllowed:newNode
    |answer|

    newNode == self selectedTreeNode ifTrue:[
	^ true 
    ].
    (modifiedChannel value 
    and:[true "self reallyModified"]) ifTrue:[
	answer := Dialog confirmWithCancel:'Accept changes ?'.
	answer isNil ifTrue:[
	    ^ false
	].
	answer == true ifTrue:[
	    self accept.
	].
    ].
    ^ true

!

showClassDefinitionOf:anItem
    |node classOrClassName cls text|

    self hasClassNodeSelected ifFalse:[^ self].

    self currentCanvasHolder value:(self class rightCanvasSpecForEditableText).

    node := self selectedTreeNode.
    classOrClassName := node contents value.
    classOrClassName isBehavior ifTrue:[
	cls := classOrClassName.
    ] ifFalse:[
	cls := Smalltalk at:classOrClassName.
    ].
    cls isNil ifTrue:[
	text := 'The class is not (yet) loaded'.
    ] ifFalse:[
	text := cls definition
    ].
    self rightCanvasTextHolder value:text.

!

showClassListOf:anItem
    |projectItem project|

    projectItem := anItem parent.
    project := projectItem contents.

    self updateClassListForProject:project.

    self currentCanvasHolder value:(self class rightCanvasSpecForClassList).
!

showCommentOf:anItem
    |projectItem project|

    anItem contents == #comment ifTrue:[
	projectItem := anItem parent
    ] ifFalse:[
	projectItem := anItem
    ].
    project := projectItem contents.

    self textCanvasLabelHolder value:'Projects comment'.
    self currentCanvasHolder value:(self class rightCanvasSpecForEditableText).
    self rightCanvasTextHolder value:project comment.

!

showDocumentationFor:anItem
    |projectItem project|

    anItem contents == #documentation ifTrue:[
	projectItem := anItem parent
    ] ifFalse:[
	projectItem := anItem
    ].
    project := projectItem contents.

    self currentCanvasHolder value:(self class rightCanvasSpecForHTMLText).
    self htmlDocumentURLHolder value:project documentationURL.
!

showMethodSourceOf:anItem
    |node methodInfo classOrClassName cls mthd text|

    self hasMethodNodeSelected ifFalse:[^ self].

    self currentCanvasHolder value:(self class rightCanvasSpecForEditableText).

    node := self selectedTreeNode.
    methodInfo := node contents value.
    cls := Smalltalk at:methodInfo className asSymbol.
    cls isNil ifTrue:[
	text := 'The class is not (yet) loaded'.
    ] ifFalse:[
	mthd := cls compiledMethodAt:(methodInfo methodName asSymbol).
	mthd isNil ifTrue:[
	    text := 'The method is not (yet) loaded'.
	] ifFalse:[
	    text := mthd source
	]
    ].
    self rightCanvasTextHolder value:text.

!

showPatchesListOf:anItem
    |projectItem project patches l|

    projectItem := anItem parent.
    project := projectItem contents.

    self updatePatchesListForProject:project.

"/    patches := project methods.
"/    patches := patches collect:[:m | m who].
"/    patches := patches sort:[:w1 :w2 |
"/                        |w1Nm w2Nm|
"/
"/                        w1Nm := w1 methodClass name.
"/                        w2Nm := w2 methodClass name.
"/                        w1Nm < w2Nm ifTrue:[
"/                            true
"/                        ] ifFalse:[
"/                            w1Nm = w2Nm ifFalse:[
"/                                false
"/                            ] ifTrue:[
"/                                w1 methodSelector < w2 methodSelector
"/                            ]
"/                        ]
"/                       ].
"/
"/    l := self patchesList.
"/    l removeAll.
"/    l addAll:patches.

    self currentCanvasHolder value:(self class rightCanvasSpecForPatchesList).
!

showReadOnlyText:someText
    self currentCanvasHolder value:(self class rightCanvasSpecForReadOnlyText).
    self rightCanvasTextHolder value:someText.

!

unloadProject
    |project filesToLoad methodsFile ns anyPatchClassMissing anyPatches
     nMissingSuper prevNMissingSuper|

    project := self currentProject.
self halt.
!

updateClassListForProject:aProject
    |classInfo l|

    classInfo := aProject classInfo copy asOrderedCollection.
    classInfo sort:[:a :b | a className < b className].

    l := self classList.
    l removeAll.
    l addAll:classInfo.


!

updateListOfProjects
    "scan all classes/methods for new projects"

    self withWaitCursorDo:[
	Project initKnownProjects.
	self updateProjectTree
    ].
!

updateListOfRequiredPrerequisiteClasses
    "all autoloaded superclasses of my classes are definitely required"

    |p anyChange allInPre requiredInPre nTotal nMissing msg|

    p := self currentProject.
    p isNil ifTrue:[^ self].
    anyChange := false.
    nTotal := 0.
    nMissing := 0.
    allInPre := self listOfAllClassesInPrerequisites value.
    requiredInPre := self listOfRequiredClassesInPrerequisites value.

    self currentProjectsClassNames do:[:aClassName |
	|cls|

	cls := Smalltalk at:aClassName asSymbol.
	(cls notNil and:[cls isLoaded]) ifTrue:[
	    cls allSuperclasses do:[:superClass |
		|sName idx|

		(superClass notNil 
		and:[superClass isLoaded
		and:[superClass wasAutoloaded]]) ifTrue:[
		    |sName entry|

		    sName := superClass name.
		    idx := allInPre findFirst:[:item | item string = sName].
		    idx ~~ 0 ifTrue:[
			allInPre removeIndex:idx.
			requiredInPre add:sName asText allBold.
			anyChange := true.
		    ]
		]
	    ]
	] ifFalse:[
	    nMissing := nMissing + 1.
	].
	nTotal := nTotal + 1.
    ].

    anyChange ifTrue:[
	self listOfRequiredClassesInPrerequisites changed.
	self listOfAllClassesInPrerequisites changed.
    ].
    nMissing ~~ 0 ifTrue:[
	nMissing == nTotal ifTrue:[
	    msg := 'Project is not loaded (' , nMissing printString
			    , ' unloaded classes)'.
	] ifFalse:[
	    msg := 'Project is not loaded completely - ' , nMissing printString
			    , ' of the projects ' , nTotal printString , ' classes are not loaded'.
	].
"/        self notify:msg.
    ].
    modifiedChannel value:false.
!

updatePatchesListForProject:aProject
    |methodInfo l|

    methodInfo := aProject methodInfo copy asOrderedCollection.
    methodInfo sort:[:a :b | a displayString < b displayString].

    l := self patchesList.
    l removeAll.
    l addAll:methodInfo.


! !

!ProjectBrowser methodsFor:'user actions - canvas'!

accept
    "save values from aspects into the project"

    self saveAspectsIntoProject.
    modifiedChannel value:false.

!

addClassToPrerequisites
    |sel cls|

    sel := self selectedClassInPrerequisites value.
    self listOfRequiredClassesInPrerequisites value add:sel.
    self listOfAllClassesInPrerequisites value remove:sel.
    self selectedClassInPrerequisites value:nil.

    "/ also add any autoloaded superclass(es)

    cls := Smalltalk at:sel asSymbol.
    (cls notNil and:[cls isLoaded]) ifTrue:[
	cls allSuperclasses do:[:superClass |
	    |sName|

	    (superClass notNil 
	    and:[superClass isLoaded
	    and:[superClass wasAutoloaded]]) ifTrue:[
		|sName idx|
		sName := superClass name.
		idx := self listOfAllClassesInPrerequisites value findFirst:[:s | s string = sName].
		idx ~~ 0 ifTrue:[
		    self listOfAllClassesInPrerequisites value removeIndex:idx.
		    self listOfRequiredClassesInPrerequisites value add:sName asString allBold.
		].
	    ]
	]
    ].
    self listOfRequiredClassesInPrerequisites changed.
    self listOfAllClassesInPrerequisites changed.
    self accept
!

addProjectToPrerequisites
    |sel|

    sel := self selectedProjectInPrerequisites value.
    self listOfRequiredProjectsInPrerequisites value add:sel.
    self listOfAllProjectsInPrerequisites value remove:sel.
    self selectedProjectInPrerequisites value:nil.

    self listOfRequiredProjectsInPrerequisites changed.
    self listOfAllProjectsInPrerequisites changed.
    self accept

!

browseMethod
    "browse the selected method (from tree)"

    |patchWho mthdInfo cls mthd|

    mthdInfo := self selectedTreeNode value value.
    cls := Smalltalk at: mthdInfo className asSymbol.
    cls notNil ifTrue:[
	mthd := cls compiledMethodAt:(mthdInfo methodName asSymbol).    
	mthd notNil ifTrue:[
	    SystemBrowser browseClass:cls selector:mthdInfo methodName.
	    ^ self
	]
    ].
    self information:'Method not (yet) loaded.'
!

browseMethodFromCanvas
    "browse the selected table-rows method (from patches canvas)"

    |patchWho patchIndex|

    patchIndex := self selectedPatchInRightCanvas value.
    patchWho := self patchesList at:patchIndex.
    SystemBrowser browseClass:patchWho methodClass selector:patchWho methodSelector.

!

browseMethodFull
    "browse the selected method (from tree)"

    |patchWho mthdInfo cls mthd|

    mthdInfo := self selectedTreeNode value value.
    cls := Smalltalk at: mthdInfo className asSymbol.
    cls notNil ifTrue:[
	mthd := cls compiledMethodAt:(mthdInfo methodName asSymbol).    
	mthd notNil ifTrue:[
	    SystemBrowser openInClass:cls selector:mthdInfo methodName.
	    ^ self
	]
    ].
    self information:'Method not (yet) loaded.'

!

browseMethodFullFromCanvas
    "browse the selected table-rows method (from patches canvas)"

    |patchWho patchIndex|

    patchIndex := self selectedPatchInRightCanvas value.
    patchWho := self patchesList at:patchIndex.
    SystemBrowser openInClass:patchWho methodClass selector:patchWho methodSelector.

!

cancel
    "reload aspects from the project"

    self readAspectsFromProject
!

removeClassFromPrerequisites
    |sel cls myClasses|

    sel := self selectedRequiredClassInPrerequisites value.
    cls := Smalltalk at:sel asSymbol.

    "/ check if this affects my classes
    (cls notNil and:[cls isLoaded and:[cls wasAutoloaded]]) ifTrue:[
	myClasses := self currentProjectsClassNames.
	cls allSubclassesDo:[:cls |
	    (myClasses includes:cls name) ifTrue:[
		self valueOfInfoLabel value:'Attention - this class is required by ' , cls name.
		(self confirm:'Attention - this class is required by ' , cls name asText allBold, '.\(The project could later fail to load correctly)\\Really remove ?' withCRs) ifFalse:[
		    ^ self
		].
	    ].
	]
    ].

    self listOfAllClassesInPrerequisites value add:sel.
    self listOfRequiredClassesInPrerequisites value remove:sel.
    self selectedRequiredClassInPrerequisites value:nil.

    "/ also remove any autoloaded subclass(es)

    (cls notNil and:[cls isLoaded and:[cls wasAutoloaded]]) ifTrue:[
	cls allSubclassesDo:[:cls |
	    |entry|

	    entry := self listOfRequiredClassesInPrerequisites value remove:cls name ifAbsent:nil.
	    entry notNil ifTrue:[
	       self listOfAllClassesInPrerequisites value add:cls name.
	    ]
	]
    ].

    self listOfRequiredClassesInPrerequisites changed.
    self listOfAllClassesInPrerequisites changed.
    self accept

!

removeProjectFromPrerequisites
    |sel|

    sel := self selectedRequiredProjectInPrerequisites value.
    self listOfAllProjectsInPrerequisites value add:sel.
    self listOfRequiredProjectsInPrerequisites value remove:sel.
    self selectedRequiredProjectInPrerequisites value:nil.

    self listOfRequiredProjectsInPrerequisites changed.
    self listOfAllProjectsInPrerequisites changed.
    self accept

!

showInfoForRequiredClass:entry
    "show why a class is required"

    |cls myClasses|

    entry notNil ifTrue:[
	myClasses := self currentProjectsClassNames asSet.

	cls := Smalltalk at:entry string asSymbol.
	cls allSubclasses do:[:subClass |
	    (myClasses includes:subClass name) ifTrue:[
		self valueOfInfoLabel value:('Required by ' , subClass name).
		^ self.
	    ]
	].
    ].
    self valueOfInfoLabel value:nil
! !

!ProjectBrowser methodsFor:'user actions - menu'!

addClass
    "ask for, and add a single class"

    |p className cls|

    p := self currentProject.

    className := Dialog request:'Class to add:'.
    className size == 0 ifTrue:[^ self].
    cls := Smalltalk classNamed:className.
    cls isNil ifTrue:[
	"/ a new one
	(self confirm:'This is a new class. Add ?') ifFalse:[
	    ^ self      
	].
	p
	    addClass:className
	    classFileName:((Smalltalk fileNameForClass:className) , '.st').
    ] ifFalse:[
	cls package ~= p package ifTrue:[
	    "/ a new one
	    (self confirm:'Change the classes package from ' , cls package , ' to ' , p package , ' ?') ifFalse:[
		^ self      
	    ].
	    cls package:p package.
	].
	p
	    addClass:cls name
	    classFileName:(cls classFilename 
			    ? ((Smalltalk fileNameForClass:cls) , '.st')).
    ].

    self updateClassListForProject:p

!

addClassesFromFilesInDirectory
    "add all classes found from files in the project directory"

    self addClassesFromFilesInDirectoryWithFilter:nil
!

addClassesFromFilesInDirectoryIfPresentInImage
    "add all classes found from files in the project directory,
     but only if class is currently present in the image."

    self addClassesFromFilesInDirectoryWithFilter:[:classOrName | classOrName isBehavior]

!

addClassesFromFilesInDirectoryWithFilter:aFilterBlockOrNil
    "helper to add all classes found from files in the project directory"

    |project existingClasses prjDirectory anyChange numSTFilesFound|

    project := self currentProject.

    existingClasses := project classInfo.
    anyChange := false.
    numSTFilesFound := 0.

    prjDirectory := project directory asFilename.
    (prjDirectory exists and:[prjDirectory isDirectory]) ifFalse:[
	self warn:'Invalid project directory: ' , prjDirectory pathName.
	^ self
    ].

    prjDirectory directoryContents do:[:fn |
	|f oldInfo cls|

	f := prjDirectory construct:fn.
	(f hasSuffix:'st') ifTrue:[
	    numSTFilesFound := numSTFilesFound + 1.

	    oldInfo := existingClasses 
			    detect:[:clsInfo |
					clsInfo classFileName = fn
				   ] 
			    ifNone:nil.
	    oldInfo isNil ifTrue:[
		"/ extract className from fileName ...
		cls := Smalltalk filenameAbbreviations keyAtValue:(f withoutSuffix baseName ).
		cls isNil ifTrue:[
		    cls := f withoutSuffix baseName asSymbol.
		    project defaultNameSpace notNil ifTrue:[
			cls := (project defaultNameSpace name , '::' , cls) asSymbol
		    ]
		].
		(aFilterBlockOrNil isNil 
		or:[aFilterBlockOrNil value:cls]) ifTrue:[
		    project addClass:cls classFileName:fn.
		    anyChange := true.
Transcript showCR:'added ' , fn , ' as class: ' , cls printString.
		] ifFalse:[
Transcript showCR:'skipped ' , fn , ' as class: ' , cls printString.
		]

	    ]
	]
    ].

    anyChange ifTrue:[
	self updateClassListForProject:project
    ] ifFalse:[
	numSTFilesFound == 0 ifTrue:[
	    self information:'No st-sourcefiles found in ' , prjDirectory pathName.
	]
    ]
!

addClassesFromImage
    "add classes with this packageId found in the image"

    |project|

    project := self currentProject.
    Smalltalk allClassesDo:[:aClass |
	aClass isMeta ifFalse:[
	    (aClass isNameSpace not or:[aClass == Smalltalk]) ifTrue:[
		aClass package = project package ifTrue:[
		    (project classInfoFor:aClass) isNil ifTrue:[
			project 
			    addClass:aClass name
			    classFileName:(aClass classFilename 
					    ? ((Smalltalk fileNameForClass:aClass) , '.st')).
		    ]
		 ]
	     ]
	]
    ].                 

    self updateClassListForProject:project

!

addPrerequisitePackage
    "ask for, and add a single class"

    |p packageName cls|

    p := self currentProject.

    packageName := Dialog request:'Package to add:'.
    packageName size == 0 ifTrue:[^ self].

    p addPrerequisitePackage:packageName.
"/    self updatePrerequisitePackageListForProject:p.

    self listOfRequiredProjectsInPrerequisites value add:packageName.
    self listOfAllProjectsInPrerequisites value remove:packageName ifAbsent:nil.
    self selectedProjectInPrerequisites value:nil.

    self listOfRequiredProjectsInPrerequisites changed.
    self listOfAllProjectsInPrerequisites changed.
    self accept

!

browseClasses
    "browse the projects classes"

    |ns p classes nBad uniqueClasses|

    p := self currentProject.
    classes := p classes
		collect:[:clsOrName |
			    |cls realName|

			    clsOrName isSymbol ifTrue:[
				realName := clsOrName.
				(realName includes:$:) ifTrue:[
				    (realName startsWith:'Smalltalk::') ifTrue:[
					realName := (realName copyFrom:'Smalltalk::' size + 1) asSymbol
				    ]
				].
				cls := Smalltalk at:realName
			    ] ifFalse:[
				cls := clsOrName
			    ].
			    cls
			].

    "/ remove duplicates - but want to preserve order
    "/ thats why we do not use asIdentitySet asOrderedCollection
    uniqueClasses := OrderedCollection new.
    classes do:[:cls | (uniqueClasses includesIdentical:cls) ifFalse:[uniqueClasses add:cls]].

    nBad := classes inject:0 into:[:sum :el | el isNil ifTrue:[sum+1] ifFalse:[sum]].
    nBad ~~ 0 ifTrue:[
	classes := classes select:[:cls | cls notNil].
	self warn:('Oops - %1 classes could not be found.\\You should probably load them first.' bindWith:nBad) withCRs.
    ].


    SystemBrowser
	browseClasses:classes title:('Classes in ' , p name) sort:true.



!

buildAbbrevFile
    "generate an abbrev.stc file in the projects directory"

    |p |

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    self withCursor:Cursor wait do:[
	self makeTranscriptVisible.
	TextCollector transcriptQuerySignal answer:self transcript
	do:[
	    p createAbbrevFile.
	]
    ]
!

buildAll
    "build all as specified in the deployment section"

    |p|

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    self makeTranscriptVisible.

    self withCursor:Cursor wait do:[
	"/ prepare the building ...

	TextCollector transcriptQuerySignal answer:self transcript
	do:[
	    (p propertyAt:#deliverLoadAllFile) == true ifTrue:[
		p createLoadAllFile
	    ].

	    (p propertyAt:#deliverSources) == true ifTrue:[
		p createSourceFiles
	    ].

	    (p propertyAt:#deliverMakefiles) == true ifTrue:[
		self buildMakefiles
	    ].

	    (p propertyAt:#deliverCompiledBinary) == true ifTrue:[
		self buildCompiledClassLibrary
	    ].

	    (p propertyAt:#deliverByteCode) == true ifTrue:[
		self buildByteCodeClassLibrary
	    ].

	    "/ now, deploy ...

	    (p propertyAt:#deliverZipArchive) == true ifTrue:[
		p buildZipArchive
	    ].

	    (p propertyAt:#deliverTarArchive) == true ifTrue:[
		p buildTarArchive
	    ].

	    (p propertyAt:#deliverGZipArchive) == true ifTrue:[
		p buildGZipArchive
	    ].
	].
    ].


!

buildCompiledClassLibrary
    "compile a binary class library in the projects directory"

    |p diagnostic error textBox|

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    "/ check for directory ...
    (self checkForProjectDirectoryFor:p) ifFalse:[
	^ self
    ].

    "/ check for Make.proto ...
    (self checkForMakeProtoFor:p) ifFalse:[
	^ self
    ].

    "/ check for Makefile ...
    (self checkForMakefileFor:p) ifFalse:[
	^ self
    ].

    self makeTranscriptVisible.

    "/ now, execute the makefile found there ...
    diagnostic := self transcript.

    error := false.
    diagnostic nextPutLine:('Building compiled class library...' asText emphasizeAllWith:#color->Color blue).

    self withCursor:Cursor wait do:[
	OperatingSystem
	    executeCommand:'make' 
	    inputFrom:nil 
	    outputTo:diagnostic 
	    errorTo:diagnostic 
	    inDirectory:(p directory asFilename pathName) 
	    onError:[:status | error := true].
    ].



!

buildLoadAllFile
    "generate a loadAll file in the projects directory"

    |p |

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    self withCursor:Cursor wait do:[
	self makeTranscriptVisible.
	TextCollector transcriptQuerySignal answer:self transcript
	do:[
	    p createLoadAllFile.
	]
    ]
!

buildMakefile
    "generate a Makefile/nt.mak/vms.mak in the projects directory"

    |p |

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    self withCursor:Cursor wait do:[
	self makeTranscriptVisible.
	TextCollector transcriptQuerySignal answer:self transcript
	do:[
	    p createMakefile
	]
    ].

    "Created: / 16.12.1999 / 01:29:30 / cg"
!

buildMakefiles
    "generate a Make.proto and Makefile in the projects directory"

    |p |

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    self withCursor:Cursor wait do:[
	self makeTranscriptVisible.
	TextCollector transcriptQuerySignal answer:self transcript
	do:[
	    p createProtoMakefile.
	    p createMakefile
	]
    ].
!

buildNTMakefile
    "generate an nt.mak in the projects directory"

    |p |

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    self withCursor:Cursor wait do:[
	self makeTranscriptVisible.
	TextCollector transcriptQuerySignal answer:self transcript
	do:[
	    p createNTMakefile
	]
    ].

    "Created: / 19.1.2000 / 15:55:17 / cg"
!

checkInAllClasses
    "check in all classes"

    |p classes classesToCheckIn anyBad|

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    classesToCheckIn := OrderedCollection new.
    anyBad := false.

    "/ collect in classes ...

    classes := p classes.
    classes do:[:aClassOrClassName |
	|cls clsName|

	cls := aClassOrClassName.
	cls isString ifTrue:[
	    cls := Smalltalk at:cls asSymbol.
	    clsName := aClassOrClassName
	] ifFalse:[
	    clsName := aClassOrClassName name
	].

	cls isBehavior ifFalse:[
	    Transcript showCR:('ProjectBrowser: cannot checkIn unloaded class: ' , clsName).
	    anyBad := true.
	] ifTrue:[
	    cls isLoaded ifFalse:[
		Transcript showCR:('ProjectBrowser: cannot checkIn unloaded class: ' , clsName).
		anyBad := true.
	    ] ifTrue:[
		cls owningClass isNil ifTrue:[ "/ skip private classes
		    Transcript showCR:('ProjectBrowser: checking in class: ' , clsName).
		    classesToCheckIn add:cls.
		]
	    ]
	]
    ].
    anyBad ifTrue:[^ self].

    self checkInClasses:classesToCheckIn.

!

checkInMakefiles
    "check in the Make.proto, Makefile, nt.mak and vms.mak files"

    |p|

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    self warn:'CheckIn of Makefiles not yet implemented.'.
    ^ self.

    "/ check it in ...



!

checkInMethods
    "check in all extensions (patches)"

    |p  methods anyMethodMissing|

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    self warn:'CheckIn of extensions not yet implemented.'.
    ^ self.

    "/ check methods ...

    anyMethodMissing := false.
    methods := p methods.
    methods size > 0 ifTrue:[
	methods do:[:aMethod |
	    aMethod isMethod ifFalse:[
		Transcript showCR:('ProjectBrowser: cannot checkIn unloaded method: ' , aMethod className , ' ' , aMethod methodName).
		anyMethodMissing := true.
	    ]
	].
	anyMethodMissing ifTrue:[
	    Transcript showCR:'ProjectBrowser: cannot save method patches & extensions due to missing method(s)'.
	] ifFalse:[
	    Transcript showCR:('ProjectBrowser: checking in patches & extensions').
	    self checkInMethods:methods
	].
    ].

!

checkInProject
    "check in all classes and extensions"

    |p|

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    "/ check in classes ...
    self checkInAllClasses.

    "/ check methods ...
    self checkInMethods.

    "/ build & check in makefiles
"/    self buildMakefiles.
    self checkInMakefiles.

    "/ check in the project file itself
    self checkInProjectFile.

!

checkInProjectFile
    "check in the prj-file"

    |p|

    p := self currentProject.
    p isNil ifTrue:[
	self information:'No project selected'.
	^ self
    ].

    self warn:'CheckIn of ProjectFile not yet implemented.'.
    ^ self.

    "/ check it in ...



!

inspectCurrentProject
    "inspect the current project"

    self hasProjectSelected ifTrue:[
	self currentProject inspect.
    ]
!

loadClassesFromDirectory
    "load all classes as contained in the project into the system"

    self withReadCursorDo:[
	self currentProject loadClassesFromProjectDirectory.
    ].

!

loadClassesFromRepository
    "load all classes as contained in the project from the source code
     repository into the system"

    self warn:'not yet implemented - please load from directory'

!

makeCurrentProject
    "make the selected Project the current project"

    |project|

    self hasProjectSelected ifTrue:[
	project := self currentProject.

	Project current:project.
	self showWhat value == #current ifTrue:[
	    self updateProjectTree
	]
    ]
!

moveMethodToProject
    |p mthd newPackage|

    p := self currentProject.

    mthd := self selectedMethod.
    mthd notNil ifTrue:[
	newPackage := Dialog request:'Move to project:' initialAnswer:lastMoveToProject.
	newPackage size > 0 ifTrue:[
	    lastMoveToProject := newPackage.
	    newPackage ~= p package ifTrue:[
		mthd package:newPackage asSymbol.
		p removeMethod:mthd.
		self updatePatchesListForProject:p.
		self projectTree remove:self selectedTreeNode.
	    ]
	]
    ].
!

newProject
    self newProject:Project new.

!

newProject:newProject
    |newNode|

    newNode := self nodeFor:newProject.
    self addProjectNodeToTree:newNode.
    self projectTreeHolder root:projectTree.
"/    self projectTreeHolder selectNode:newNode.
"/    self projectTreeHolder expand:newNode.

    self readAspectsFromProject.
    newProject wasLoadedFromFile ifFalse:[
	 self updateListOfRequiredPrerequisiteClasses.
    ]
!

newSubProject
    |projectNode subProjectsNode newNode parentProject newProject|

    projectNode := self currentProjectNode.

    projectNode notNil ifTrue:[
	parentProject := projectNode contents.
	subProjectsNode := projectNode children detect:[:child | child contents == #subprojects].
self halt.
	parentProject notNil ifTrue:[
	    newProject := Project new.
	    newNode := self nodeFor:newProject.

	    parentProject addSubProject:newProject.
	    subProjectsNode add:newNode.
	    self projectTreeHolder root:projectTree.
	    self projectTreeHolder selectNode:newNode.
	]    
    ]    

!

openDocumentation
    self openHTMLDocument: 'tools/pbrowser/TOP.html'

!

openProject
    |fn|

    fn := Dialog 
	requestFileName:'filename:' 
	default:nil
	ifFail:nil
	pattern:'*.prj'
	fromDirectory:(FileSelectionBox lastFileSelectionDirectory).

    fn notNil ifTrue:[
	self loadFromProjectFile:fn.
    ]
!

removeMethod
    |p mthd|

    p := self currentProject.

    mthd := self selectedMethod.
    mthd notNil ifTrue:[
	(self confirm:'Really remove the method (from both project and image) ?') ifTrue:[
	    p removeMethod:mthd.
	    mthd who methodClass removeSelector:mthd who methodSelector.
	    self updatePatchesListForProject:p.
	    self projectTree remove:self selectedTreeNode.
	]
    ] ifFalse:[
	self information:'No such method in the image (yet)'.
    ]
!

removeMethodFromProject
    |p mthd|

    p := self currentProject.

    mthd := self selectedMethod.
    mthd notNil ifTrue:[
	(self confirm:'Really remove the method (from the project) ?') ifTrue:[
	    mthd package:#unknown.
	    p removeMethod:mthd.
	    self updatePatchesListForProject:p.
	    self projectTree remove:self selectedTreeNode.
	]
    ].
!

removeProject
    |projectToRemove selectedNode subNode newNode parentNode parentProject newProject|

    self hasProjectNodeSelected ifTrue:[
	selectedNode := self selectedTreeNode.
	projectToRemove := selectedNode contents.

	(self confirm:'Really remove the project ?') ifTrue:[
	    self withExecuteCursorDo:[
		self projectTreeHolder removeSelection.
		projectToRemove removeFromSystem.
	    ]
	]
    ]
!

renameProject
    |nm projectNode selectedProject|

    projectNode := self currentProjectNode.
    projectNode notNil ifTrue:[
	selectedProject := projectNode contents.

	nm := Dialog 
		request:'Rename to:'
		initialAnswer:selectedProject name.

	nm size > 0 ifTrue:[
	    selectedProject name:nm.
"/            selectedNode name:nm.
"/            selectedNode changed.
	]
    ]
!

saveProjectFile
    "save the project file in the project directory"

    |d p|

    self modifiedChannel value ifTrue:[
	(self confirm:'Changes not confirmed; save anyway ?') ifFalse:[^ self]
    ].

    p := self currentProject.
    p isNil ifTrue:[
	self information:'Select a project first.'.
	^self
    ].
    p directory isNil ifTrue:[
	d := (Dialog request:'Project Directory:').
	d size == 0 ifTrue:[
	    ^ self
	].
	p directory:d
    ].

    self withCursor:Cursor write do:[
	p saveAsProjectFile.
    ]

    "Modified: / 26.4.1999 / 22:43:57 / cg"
!

validateAgainstClassesInImage
    "validate classes in project against classes found in the image"

    |project classesInProjectOnly classesInImageOnly bindings|

    project := self currentProject.
    classesInImageOnly := IdentitySet new.
    classesInProjectOnly := IdentitySet new.

    Smalltalk allClassesDo:[:aClass |
	aClass isMeta ifFalse:[
	    (aClass isNameSpace not or:[aClass == Smalltalk]) ifTrue:[
		aClass package = project package ifTrue:[
		    (project classInfoFor:aClass) isNil ifTrue:[
			classesInImageOnly add:aClass name.
		    ]
		 ]
	     ]
	]
    ].
    project classInfo do:[:clsInfo |
	|clsName cls|

	clsName := clsInfo className.
	cls := Smalltalk at:clsName asSymbol.
	(cls isBehavior not) ifTrue:[
	    classesInProjectOnly add:clsName
	].
    ].

    (classesInImageOnly isEmpty and:[classesInProjectOnly isEmpty]) ifTrue:[
	self information:'Set of classes in project and image are equal.'.
	^ self.
    ].

    classesInImageOnly := classesInImageOnly asOrderedCollection sort.
    classesInProjectOnly := classesInProjectOnly asOrderedCollection sort.

    bindings := IdentityDictionary new.
    bindings at:#classesInImageOnly put:classesInImageOnly.
    bindings at:#classesInProjectOnly put:classesInProjectOnly.

    SimpleDialog
	openDialogInterfaceSpec:(self class classValidationDialogSpec)
	withBindings:bindings

    "Modified: / 26.9.1999 / 16:03:50 / cg"
!

validateAgainstMethodsInImage
    "validate methods in project against methods found in the image"

    |project package methodsInProjectOnly methodsInImageOnly bindings who|

    project := self currentProject.
    package := project package.

    methodsInImageOnly := IdentitySet new.
    methodsInProjectOnly := IdentitySet new.

    Method allSubInstancesDo:[:aMethod |
	aMethod package = package ifTrue:[
	    who := aMethod who.
	    who notNil ifTrue:[
		(project classInfoFor:who methodClass) isNil ifTrue:[
		    "/ is it in the projects methodList ?
		    (project includesMethod:aMethod) ifFalse:[
			methodsInImageOnly add:(who methodClass name , ' ' , who methodSelector).
		    ]
		]
	    ]
	 ]
    ].

    project methodInfo do:[:mthdInfo |
	|clsName sel cls m|

	clsName := mthdInfo className.
	sel := mthdInfo methodName.
	cls := Smalltalk at:clsName asSymbol.
	(project includesClass:clsName) ifFalse:[
	    (cls isBehavior not 
	    or:[(m := cls compiledMethodAt:sel) isNil
	    or:[m package ~= package]]) ifTrue:[
		methodsInProjectOnly add:(clsName , ' ' , sel)
	    ].
	].
    ].

    (methodsInImageOnly isEmpty and:[methodsInProjectOnly isEmpty]) ifTrue:[
	self information:'Set of methods in project and image are equal.'.
	^ self.
    ].

    methodsInImageOnly := methodsInImageOnly asOrderedCollection sort:[:a :b | a printString < b printString].
    methodsInProjectOnly := methodsInProjectOnly asOrderedCollection sort:[:a :b | a printString < b printString].

    bindings := IdentityDictionary new.
    bindings at:#methodsInImageOnly put:methodsInImageOnly.
    bindings at:#methodsInProjectOnly put:methodsInProjectOnly.

    SimpleDialog
	openDialogInterfaceSpec:(self class methodValidationDialogSpec)
	withBindings:bindings

    "Modified: / 26.9.1999 / 16:03:50 / cg"
! !

!ProjectBrowser::ProjectTreeItem methodsFor:'accessing'!

action
    "return the value of the instance variable 'action' (automatically generated)"

    ^ action
!

action:something
    "set the value of the instance variable 'action' (automatically generated)"

    action := something.
!

info
    "return the value of the instance variable 'info' (automatically generated)"

    ^ info
!

info:something
    "set the value of the instance variable 'info' (automatically generated)"

    info := something.
!

spec
    "return the value of the instance variable 'spec' (automatically generated)"

    ^ spec
!

spec:something
    "set the value of the instance variable 'spec' (automatically generated)"

    spec := something.
! !

!ProjectBrowser::ProjectTreeItem methodsFor:'queries'!

isProjectNode
    ^ false
! !

!ProjectBrowser::ProjectNode methodsFor:'queries'!

isProjectNode
    ^ true


! !

!ProjectBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ProjectBrowser initialize!
