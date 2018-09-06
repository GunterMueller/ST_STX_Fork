"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#ProcessMonitorV2
	instanceVariableNames:'processList tableColumns selectedProcesses updateSema showDetail
		hasSelectionHolder showProcessId showGroup showState showPrio
		showUsedStack showTotalStack showCurrentSegment showSwitch
		showWhere showInstrumentation showApplication showWindowTitle
		currentSortOrder processTable showDeadHolder sortBlock
		selectionRestartable updateListDelayTimeHolder
		updateContentsDelayTimeHolder enableDecreaseListDelayTime
		enableDecreaseContentsDelayTime enableIncreaseListDelayTime
		enableIncreaseContentsDelayTime listUpdateDelay updateDelay
		updateBlock listUpdateBlock updateProcess visibleBlock
		allowModifications tableMenu
		hasSelectionWithApplicationProcessHolder
		hasSelectionAndProcessIsApplicationProcessHolder
		hasSelectionWithStoppedProcessHolder
		hasSelectionAndProcessIsStoppedHolder
		hasSelectionWithGUIProcessHolder
		hasSelectionWithDisabledInstrumentationHolder
		hasSelectionWithEnabledInstrumentationHolder interruptCountHolder
		timerActionCountHolder lastInterruptCount lastTimerActionCount
		lastUpdateTimestamp showStartTime'
	classVariableNames:''
	poolDictionaries:''
	category:'Monitors-ST/X'
!

Object subclass:#ProcessItem
	instanceVariableNames:'processId processGroup processName processActive processState
		processPrio processUsedStack processTotalStack processWhere
		processInstrumentation processApplication processWindowTitle
		processInstance weakArrayWithProcesses
		processInstanceIndexInWeakArray processCurrentSegment
		processSwitch prioVal idVal groupVal processBlocked
		startTimestamp'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProcessMonitorV2
!

!ProcessMonitorV2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    documentation to be added.

    [author:]
	Christian Penk (penk@bierfix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
								[exBegin]
    ProcessMonitorV2 open

								[exEnd]

  Starting the application withot any possibilities to change
  the processes
								[exBegin]
    ProcessMonitorV2 openAllowNoModifications

								[exEnd]

  more examples to be added:
								[exBegin]
    ... add code fragment for
    ... executable example here ...
								[exEnd]
"
!

history
    "Created: / 14.1.2003 / 11:16:10 / penk"
! !

!ProcessMonitorV2 class methodsFor:'instance creation'!

openAllowNoModifications


    |application|

    application := self new.
    application open.
    application allowModifications value:false.
! !

!ProcessMonitorV2 class methodsFor:'defaults'!

defaultLabel
    ^ 'Process Monitor'
!

resourcePackName
    "return the name which is used as the fileNameBase of my resource file.
     Here, use the same resources as the (old) ProcessMonitor"

    ^ 'ProcessMonitor'
! !

!ProcessMonitorV2 class methodsFor:'help'!

aboutThisApplicationText
    ^ super aboutThisApplicationText ,
      '\\Written 2003 by Christian Penk, eXept Software AG,\and Claus Gittinger, eXept Software AG.' withCRs
!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:ProcessMonitorV2
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#Debug
'Debug the selected process'

#Details
'Details - select columns to display'

#Inspect
'Inspect the selected process'

#findProcessByView
'Pick a view and select the associated window group process'

#'Lower Prio'
'Lower the priority of the selected process'

#'Raise Prio'
'Raise the priority of the selected process'

#RaiseWindow
'Raise the application''s window'

#Restart
'Restart'

#Resume
'Resume'

#Abort
'Abort'

#Stop
'Stop'

#Suspend
'Suspend'

#Terminate
'Terminate'

#'Terminate Group'
'Terminate Group'

#'Update Process List'
'Update Process List'

processId
'The process ID. A unique number'

processGroup
'The processes group ID. Usually the ID of the parent process. Nil if detached from parent'

processName
'The processes name'

processApplication
'The processes application class (if any)'

processWindowTitle
'The processes window title (if any)'

processInstrumentation
'The process is currently executed with instrumentaion monitoring active'

processWasActive
'The process was active any time during the last update interval (+)\ or actively running when probed (*)'

processState
'The execution state'

processPriority
'The execution priority, and optional priority range'

processWhere
'The currently executed method or the method which suspended it'

processUsedStack
'The amount of stack space used by the process (in bytes)'

processTotalStack
'The amount of allocated stack space (in bytes) and the number of allocated stack segments'

processSwitch
'The overall count of stack segment switches'

processCurrentSegment
'The address range of the current stack segment'

#interruptCount
'Interrupts per second'

#listUpdateInterval
'Interval to update the list of processes'

#timerActionCount
'Timer actions per second'

#updateInterval
'Interval to update the status of processes'

)

    "Modified: / 05-06-2007 / 18:35:47 / cg"
! !

!ProcessMonitorV2 class methodsFor:'image specs'!

defaultIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
	constantNamed:'ProcessMonitorV2 class defaultIcon'
	ifAbsentPut:[(Depth1Image new) width: 32; height: 32; photometric:(#whiteIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@G????9@@@@BP@@@@$O?>@I@@@@BP??8@$@@@@IC?? BP@@@@$@@@@I@@@@BP@@@@$M,@@IC[@@BP@@@@$@@@@I@@@@BP@@@@$@@@@I@@@@BP@@@@$@@
@@I????>@@@@@CLX7L0*)QDPJ*TQDCL%FH #IQADH*TPQBJX7Y b') ; yourself]
!

detailsMenuIconDown
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self detailsMenuIconDown inspect
     ImageEditor openOnClass:self andSelector:#detailsMenuIconDown
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class detailsMenuIconDown'
	ifAbsentPut:[
	    (Depth1Image new)
		width:7;
		height:5;
		photometric:(#palette);
		bitsPerSample:(#( 1 ));
		samplesPerPixel:(1);
		bits:(ByteArray fromPackedString:'@@@@@@@b');
		colorMapFromArray:#[ 0 0 0 255 255 255 ];
		mask:((ImageMask new)
			    width:7;
			    height:5;
			    bits:(ByteArray fromPackedString:'@A@(UJ(b');
			    yourself);
		yourself
	]
!

detailsMenuIconUp
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self detailsMenuIconUp inspect
     ImageEditor openOnClass:self andSelector:#detailsMenuIconUp
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class detailsMenuIconUp'
	ifAbsentPut:[
	    (Depth1Image new)
		width:7;
		height:5;
		photometric:(#palette);
		bitsPerSample:(#( 1 ));
		samplesPerPixel:(1);
		bits:(ByteArray fromPackedString:'@@@@@@@b');
		colorMapFromArray:#[ 0 0 0 255 255 255 ];
		mask:((ImageMask new)
			    width:7;
			    height:5;
			    bits:(ByteArray fromPackedString:'*%P(D@@b');
			    yourself);
		yourself
	]
!

process22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self process22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#process22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class process22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EA0@@@@@@@@@@@@@@@@@@@@@@@@@@AP\@@@@@@@@@@@@@@@@@
@@@GAP@@APXFB@@@AP\@@@@@@@@@@@@@B@XEAPXFA XEAPXH@@@@@@@@@@@@@@@GA XFA XFA XH@@@@@@@@@@@@@@@@APXFA0 GA XFA0@@@@@@@@@@@@@@
APXFA0 @@@TFA XG@@@@@@@@@@@EAPXFA  @@@@@APXFA TG@@@@@@@@B@ FA XG@@@@@@TFA XHB@@@@@@@@@@@A0\FA T@@@TFA XH@@@@@@@@@@@@@@@G
A XFAPTFA XH@@@@@@@@@@@@@@@@APXFA XFA XFB@@@@@@@@@@@@@@@APXHA0XFA XFAPXH@@@@@@@@@@@@@@\H@@@EA XG@@@GB@@@@@@@@@@@@@@@@@@@
@@TH@@@@@@@@@@@@@@@@@@@@@@@@@@@EB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
		colorMapFromArray:#[ 0 0 0 128 128 128 160 160 160 195 195 195 220 220 220 255 255 255 194 194 194 161 161 165 127 127 127 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?<@C?<@O??@_9? _9? O??@C?<@C?<@G?>@G?>@COL@@O@@@F@@@@@@@@@@@@@@');
			    yourself);
		yourself
	]
!

processAbort22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processAbort22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processAbort22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class processAbort22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#[ 8 ]);
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@E@ @@@@@@@@@@@@@@@@@@@@@@@@@@APH@@@@@@@@@@@@@@@@@
@@@BAP@@APLC@P@@APH@@@@@@@@@@@@@@PLEAPLC@0LEAPLA@@@@@@@@@@@@@@@B@0LC@0LC@0LA@@@@@@@@@@@@@@@@APLC@ DB@0LC@ @@@@@@@@@@@@@@
APLC@ D@@@TC@0LB@@@@@@@@@@@EAPLC@0D@@@@@APLC@0TB@@@@@@@@@PDC@0LB@@@@@@TC@0LA@P@@@@@@@@@@@ HC@0T@@@TC@0LA@@TE@@@@@@@@@@@B
@0LCAPTC@0LA@@TFA TE@@@@@@@@APLC@0LC@0LC@PTFA@PFAP@@@@@@APLA@ LC@0LCAPTFA@PDA@XE@@@@@@HA@@@E@0LB@@TFA@PDA@PFA @@@@@@@@TE
@@TA@@@EA XDA@PFAPT@@@@@@@@EA TE@P@@APTEA PDA @@@@@@@@@@@@TFAP@@@@TEA PDA T@@@@@@@@@@@@@A XEAPTFA PDA@X@@@@@@@@@@@@@@@TF
A XFA@PDA XE@@@@@@@@@@@@@@@@APTFA XFA TE@@@@@@@a');
		colorMapFromArray:#[ 0 0 0 127 127 127 161 161 165 194 194 194 255 0 0 255 255 255 192 0 0 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?<@C?<@O??@_9? _9? O?? C??8C??8G??<G??<C?_<@?_0@^_0@O? @O? @G?@');
			    yourself);
		yourself
	]
!

processDebug22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processDebug22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processDebug22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class processDebug22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@F@0@@@@@@@@@@@@@@@@@@@@@@@@@@A L@@@@@@@@@@@@@@@@@
@@@CA @@A PD@P@@A L@@@@@@@@@@@@@@PPFA PDA@PFA PA@@@@@@@@@@@@@@@CA@PD@@@DA@PA@@@@@@@@@@@@@@@@A P@@0DC@@@D@0@@@@@@@@@@@@@@
A PD@0@@@@X@@@@@@@@@@@@@@@@FA PDA@D@@@@@@@HB@ HB@ @@@@@@@PDDA@@@@@@@@ HBAPTEAPTB@@@@@@@@@0@B@ @B@ HEAPTEAPTEAPH@@@@@@@HB
APTE@@HEAPTEAPTEAPTE@ @@@@@B@ TEAP@BAPTEAPTEAPTEAPH@@@@@@@HEAPT@@@@@@@@@@@@@@@@@@@@@@@HBAPTE@@HBAPTEAPTEAPTE@ @@@@@@@ HE
@ @B@ HEAPTEAPTE@ H@@@@@@@@@@@@@@@HB@ HB@ HB@ @@@@@@@@@@@@@@@@@@@@@B@ HB@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
		colorMapFromArray:#[ 0 0 0 127 127 127 128 0 0 161 161 165 194 194 194 255 0 0 255 255 255 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?= C??XO?? _=?0_??8O??<???<C??<G??<???<_??<@??8@G?0@L? @Q#X@FA ');
			    yourself);
		yourself
	]
!

processInspect22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processInspect22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processInspect22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class processInspect22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EA0@@@@@@@@@@@@@@@@@@@@@@@@@@AP\@@@@@@@@@@@@@@@@@
@@@GAP@@APXFB@@@AP\@@@@@@@@@@@@@B@XEAPXFA XEAPXH@@@@@@@@@@@@@@@GA XFA @@@@XH@@@@@@@@@@@@@@@@APXF@@@BCPH@@@@@@@@@@@@@@@@@
APXF@@0MCP4MCP0@@@@@@@@@@@@EAPXFA @MCPTEAP4M@@TG@@@@@@@@B@ FA @BCPTEAP4MCPH@B@@@@@@@@@@@A0\@CP4EAP4MCP4M@@@@@@@@@@@@@@@G
@@HMAP4MCP4M@ @@@@@@@@@@@@@@APX@CP4MCP4MCP@@@@@@@@@@@@@@APXH@@0MCP4MCP0@BP@@@@@@@@@@@@\H@@@@@@HM@ @@@ @@@@@@@@@@@@@@@@@@
@@T@@@@@B @K@0@@@@@@@@@@@@@@@@@EB@@@@@@@C ,C@@@@@@@@@@@@@@@@@@@@@@@@@@@NB0L@@@@@@@@@@@@@@@@@@@@@@@@@@@8K@0@@@@@@@@@@@@@@
@@@@@@@@@@@@C ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
		colorMapFromArray:#[ 0 0 0 128 128 128 160 160 160 195 195 195 220 220 220 255 255 255 194 194 194 161 161 165 127 127 127 120 120 120 0 64 64 88 88 88 80 80 80 200 200 200 48 48 48 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?<@C?<@O??@_?? _?? O??@C?>@C?<@G?>@G??@CO/ @OG0@FC8@@A<@@@<@@@X');
			    yourself);
		yourself
	]
!

processLowerPrio22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processLowerPrio22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processLowerPrio22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class processLowerPrio22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EA0@@@@@@@@@@@@@@@@@@@@@@@@@@AP\@@@@@@@@@@@@@@@@@
@@@GAP@@APXFB@@@AP\@@@@@@@@@@@@@B@XEAPXFA XEAPXH@@@@@@@@@@@@@@@GA XFA XFA XH@@@@@@@@@@@@@@@@APXFA0 GA XFA0@@@@@@@@@@@@@@
APXFA0 @@@TFA XG@@@@@@@@@@@EAPXFA  @@@@@APXFA TG@@@@@@@@B@ FA XG@@@@@@TEAPTEAPTE@@@@@@@@A0\FA T@@@TFAP@@@@@@AP@@@@@@@@@G
A XFAPTFA T@@@@@@@T@@@@@@@@@APXFA XFA XE@@@@@@@E@@@@@@@@APXHA0XFA XFAP@@@@@@AP@@@@@@@@\H@@@EA XEAPT@@@@@@@TEAP@@@@@@@@@@
@@THAP@@@@@@@@@@@@T@@@@@@@@@@@@EB@@E@@@@@@@@@@T@@@@@@@@@@@@@@@@@@@T@@@@@@@T@@@@@@@@@@@@@@@@@@@@@AP@@@@T@@@@@@@@@@@@@@@@@
@@@@@@@E@@T@@@@@@@@@@@@@@@@@@@@@@@@@@@T@@@@@@@@a');
		colorMapFromArray:#[ 0 0 0 128 128 128 160 160 160 195 195 195 220 220 220 255 255 255 194 194 194 161 161 165 127 127 127 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?<@C?<@O??@_9? _9?0O??0C??0C??0G??0G??<CO?<@O?8@F_0@@O @@G@@@B@');
			    yourself);
		yourself
	]
!

processRaisePrio22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processRaisePrio22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processRaisePrio22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class processRaisePrio22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EA0@@@@@@@@@@@@@@@@@@@@@@@@@@AP\@@@@@@@@@@@@@@@@@
@@@GAP@@APXFB@@@AP\@@@@@@@@@@@@@B@XEAPXFA XEAPXH@@@@@@@@@@@@@@@GA XFA XFA XH@@@@@@@@@@@@@@@@APXFA0 GA XFA0@@@@@@@@@@@@@@
APXFA0 @@@TFA XG@@@@@@@@@@@EAPXFA  @@@@@APXFA TG@@@@@@@@B@ FA XG@@@@@@TFA XEB@@@@@@@@@@@A0\FA T@@@TFA XE@@T@@@@@@@@@@@@G
A XFAPTFA XE@@@@AP@@@@@@@@@@APXFA XFA XE@@@@@@@E@@@@@@@@APXHA0XFA XE@@@@@@@@@@T@@@@@@@\H@@@EA XE@@@@@@@@@@@@AP@@@@@@@@@@
@@THAPTE@@@@@@@EAPT@@@@@@@@@@@@EB@@@AP@@@@@@AP@@@@@@@@@@@@@@@@@@@@T@@@@@@@T@@@@@@@@@@@@@@@@@@@@E@@@@@@@E@@@@@@@@@@@@@@@@
@@@@AP@@@@@@AP@@@@@@@@@@@@@@@@@@@@TEAPTEAPT@@@@a');
		colorMapFromArray:#[ 0 0 0 128 128 128 160 160 160 195 195 195 220 220 220 255 255 255 194 194 194 161 161 165 127 127 127 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?<@C?<@O??@_9? _9? O??@C?? C??0G??8G??<CO?<@O_0@F_0@@_0@@_0@@_0');
			    yourself);
		yourself
	]
!

processRestart22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processRestart22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processRestart22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class processRestart22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@GAP@@@@@@@@@@@@@@@@@@@@@@@@@@A0T@@@@@@@@@@@@@@@@@
@@@EA0@@A0XFA@@@A0T@@@@@@@@@@@@@A@XGA0XFA XGA0XD@@@@@@@@@@@@@@@EA XFA XF@@@@@@@@@@@@@@@@@@@@A0XFAPP@@@LC@0@@@P@@@@@@@@@@
A0XFAPP@@0LC@0@E@@@@@@@@@@@GA0XFA P@@@LC@0@FA \@@@@@@@@@A@PFA XE@@LC@0@FA XD@@@@@@@@@@@@APTFA @C@0L@A XD@@@@@@@@@@@@@@@E
@@LC@0LC@0L@@@@@@@@@@@@@@@@@A0X@@0LC@0L@@@@@@@@@@@@@@@@@A0XDAP@C@0L@@@@@@@@@@@@@@@@@@@TD@@@@@@L@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
		colorMapFromArray:#[ 0 0 0 0 64 0 0 128 0 0 192 0 127 127 127 161 161 165 194 194 194 255 255 255 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?>@C?? O??0_?>P_?>HO?<@C?= C?30G?''8G7/<CCO0@PC0@HG @L_ @G?@@A<@');
			    yourself);
		yourself
	]
!

processResume22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processResume22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processResume22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class processResume22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EA0@@@@@@@@@@@@@@@@@@@@@@@@@@AP\@@@@@@@@@@@@@@@@@
@@@GAP@@APXFB@@@AP\@@@@@@@@@@@@@B@XEAPXFA XEAPXH@@@@@@@@@@@@@@@GA XFA XFA XH@@@@@@@@@@@@@@@@APXFA0 GA XFA0@@@@@@@@@@@@@@
APXFA0 @@@TFA XG@@@@@@@@@@@EAPXFA  @@@@@APXFA TG@@@@@@@@B@ FA XG@@@@@@TE@@THB@@@@@@@@@@@A0\FA T@@@TFAP@@AP@@@@@@@@@@@@@G
A XFAPTFA T@@@@E@@@@@@@@@@@@APXFA XFA XE@@@@@@T@@@@@@@@@APXHA0XFA XFAP@@@@@@AP@@@@@@@@\H@@@EA XG@@T@@@@@@@@E@@@@@@@@@@@@
@@TH@@@E@@@@@@@@AP@@@@@@@@@@@@@EB@@@AP@@@@@@AP@@@@@@@@@@@@@@@@@@@@T@@@@@AP@@@@@@@@@@@@@@@@@@@@@E@@@@AP@@@@@@@@@@@@@@@@@@
@@@@AP@@AP@@@@@@@@@@@@@@@@@@@@@@@@T@AP@@@@@@@@@a');
		colorMapFromArray:#[ 0 0 0 128 128 128 160 160 160 195 195 195 220 220 220 255 255 255 194 194 194 161 161 165 127 127 127 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?<@C?<@O??@_9? _9? O??@C??@C?? G??0G??8CO_8@O_0@F_ @@_@@@^@@@\@');
			    yourself);
		yourself
	]
!

processStop22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processStop22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processStop22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class processStop22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EA0@@@@@@@@@@@@@@@@@@@@@@@@@@AP\@@@@@@@@@@@@@@@@@
@@@GAP@@APXFB@@@AP\@@@@@@@@@@@@@B@XEAPXFA XEAPXH@@@@@@@@@@@@@@@GA XFA XFA XH@@@@@@@@@@@@@@@@APXFA0 GA XFA0@@@@@@@@@@@@@@
APXFA0 @@@TFA XG@@@@@@@@@@@EAPXFA  @@@@@APXFA TG@@@@@@@@B@ FA XG@@@@@@TFA XHB@@@@@@@@@@@A0\FA T@@@TFA XH@@@@@@@@@@@@@@@G
A XFAPTFAPTEAPTEAPTEAP@@@@@@APXFA XFA T@@@@EAP@@@@T@@@@@APXHA0XFA XE@@@@APT@@@@E@@@@@@\H@@@EA XGAP@@@@TE@@@@AP@@@@@@@@@@
@@TH@@T@@@@EAP@@@@T@@@@@@@@@@@@EB@@E@@@@APT@@@@E@@@@@@@@@@@@@@@@AP@@@@TE@@@@AP@@@@@@@@@@@@@@@@T@@@@EAP@@@@T@@@@@@@@@@@@@
@@@E@@@@APT@@@@E@@@@@@@@@@@@@@@@APTEAPTEAPTEAP@a');
		colorMapFromArray:#[ 0 0 0 128 128 128 160 160 160 195 195 195 220 220 220 255 255 255 194 194 194 161 161 165 127 127 127 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?<@C?<@O??@_9? _9? O??@C??<C??<G??<G??<CO?<@O?<@F?<@@?<@@?<@@?<');
			    yourself);
		yourself
	]
!

processSuspend22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processSuspend22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processSuspend22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class processSuspend22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EA0@@@@@@@@@@@@@@@@@@@@@@@@@@AP\@@@@@@@@@@@@@@@@@
@@@GAP@@APXFB@@@AP\@@@@@@@@@@@@@B@XEAPXFA XEAPXH@@@@@@@@@@@@@@@GA XFA XFA XH@@@@@@@@@@@@@@@@APXFA0 GA XFA0@@@@@@@@@@@@@@
APXFA0 @@@TFA XG@@@@@@@@@@@EAPXFA  @@@@@APXFA TG@@@@@@@@B@ FA XG@@TEAPTEAPTEAPTEAPT@@@@@A0\FA TEAPTEAPTEAPTEAPTE@@@@@@@G
A XFAPTE@@@@@@@@@@@EAP@@@@@@APXFA TEAP@@@@@@@@@@APT@@@@@APXHA0XEAPT@@@@@@@@@@@TE@@@@@@\H@@@EAPTE@@@@@@@@@@@EAP@@@@@@@@@@
@@TEAP@@@@@@@@@@APT@@@@@@@@@@@@EAPT@@@@@@@@@@@TE@@@@@@@@@@@@APTE@@@@@@@@@@@EAP@@@@@@@@@@@@TEAP@@@@@@@@@@APT@@@@@@@@@@@@E
APTEAPTEAPTEAPTE@@@@@@@@@@@@APTEAPTEAPTEAPTEAP@a');
		colorMapFromArray:#[ 0 0 0 128 128 128 160 160 160 195 195 195 220 220 220 255 255 255 194 194 194 161 161 165 127 127 127 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?<@C?<@O??@_9? _??<O??<C??<C??<G??<G??<CO?<@O?<@G?<@G?<@G?<@G?<');
			    yourself);
		yourself
	]
!

processTerminate22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processTerminate22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processTerminate22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class processTerminate22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@EA0@@@@@@@@@@@@@@@@@@@@@@@@@@AP\@@@@@@@@@@@@@@@@@
@@@GAP@@APXFB@@@AP\@@@@@@@@@@@@@B@XEAPXFA XEAPXH@@@@@@@@@@@@@@@GA XFA XFA XH@@@@@@@@@@@@@@@@APXFA0 GA XFA0@@@@@@@@@@@@@@
APXFA0 @@@TFA XG@@@@@@@@@@@EAPXFA  @@@@@APXFA TGC@@@@@@@B@ FA XG@@@LC@TFA XHC@,K@@@@@@@@A0\FA TLB0,LC@XHC@,KBP@@@@@@@@@G
A XFAPTJB0,LB0,KBP@@@@@@@@@@APXFA XFA (KB0,KBP@@@@@@@@@@APXHA0XFA XFC@,KC@@@@@@@@@@@@@\H@@@EA XGC@,KB00@@@@@@@@@@@@@@@@@
@@THC@,I@@(KC@@@@@@@@@@@@@@@@@@EB@0I@@@@B ,@@@@@@@@@@@@@@@@@@@0K@@@@@@@JB0@@@@@@@@@@@@@@@@@LBP@@@@@@@@,@@@@@@@@@@@@@@@@@
C@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
		colorMapFromArray:#[ 0 0 0 128 128 128 160 160 160 195 195 195 220 220 220 255 255 255 194 194 194 161 161 165 127 127 127 64 0 0 128 0 0 192 0 0 255 0 0 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@@F@@@O@@COL@G?>@G?>@C?<@C?<@O??@_9? _;?0O??0C?? C??@G?>@G?>@CO?@@O#@@GA @C@ @B@@@@@@');
			    yourself);
		yourself
	]
!

processTerminateGroup22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self processTerminateGroup22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#processTerminateGroup22x22Icon
     Icon flushCachedIcons"

    ^ Icon
	constantNamed:#'ProcessMonitorV2 class processTerminateGroup22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AP\@@@@@@@@@@@@@@@@@@@@@@@@@@@TG@@@@@@@@@@@@@@@@@@@@A0T@@@TFA  @@@TG@@@@@@@@@@@@
@@ FAPTF@@@FAPTFB@@@@@@@@@@@@@@@A0XF@@TG@@XFB@@@@@@@@@@@@@@@@@@FA @EA0@FA @@@@@@@@@@@@@@@@\E@@@EA XH@@@EA0@@@@@@@@@@AP@H
A TEA XFA TEA  @A0@@@@@@@@ H@@\FA XFA XFA  @B@ @@@@@@@@@@@@EA XGB@\FA XG@@@@@@@L@@@@@@@EA XGB@@@AP0LA \@@@@LB0,@@@TEA XF
B@@FA 0KB00LAP\LB0,I@@@HB@XFA \@A X@AP(KB00KB0,I@@@@@@@GA0XFAP@@APXFB ,KB0,I@@@@@@@@@@\FA XEAPXFA  LB0,L@@@@@@@@@@@EA XF
A XFA XLB0,KC@@@@@@@@@@EA  GA XFA XLB0$@B ,L@@@@@@@@A0 @@@TFA \@C@$H@@@JB0@@@@@@@@@@@@@@AP @C@,@@@@@@@(K@@@@@@@@@@@@@@TH
@@0I@@@@@@@@B0@@@@@@@@@@@@@@@@@L@@@@@@@@@@@@@@@a');
		colorMapFromArray:#[ 0 0 0 128 128 128 160 160 160 195 195 195 220 220 220 255 255 255 194 194 194 161 161 165 127 127 127 64 0 0 128 0 0 192 0 0 255 0 0 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@L@@@^@@F^X@O?<@O?<@G?8@G?8@_?>@???@???@_?>P_?>8???8???0_?? G??@G??@O?? O?= F_80@_ P@M@@');
			    yourself);
		yourself
	]
!

raiseWindow22x22Icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self raiseWindow22x22Icon inspect
     ImageEditor openOnClass:self andSelector:#raiseWindow22x22Icon
     Icon flushCachedIcons"

    ^ Icon constantNamed:'ProcessMonitorV2 class raiseWindow22x22Icon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:22;
		photometric:(#palette);
		bitsPerSample:(#[ 8 ]);
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@.K"8.K"8.K"8.K"8.K"8.K"8.K @@@@@@@ HB@ HB@ HB@ HB@ HB@B8@@@@@@@H+J2,+J2,+J2,+J2,+@ @.@@@@@@@BJ2,+J2,+J2,+J2,+J2 @K @@
@ HB@ HB@ HB@ HB@ HBJ2,"@B8@@@HB@ HB@ HB@ HB@ HB@",EF @.@@@B@ HB@ HB@ HB@ HB@" EHQ(@K @@@ HB@ HB@ HB@ HB@ H"AR$(@B8@@@H+
J2,+J2,+J2,+J2,!!JBD''J@@.@@@BJ2,+J2,+J2,+J2,+HR !!I2 @K @@@",+J2,+J2,+J2,+J2\(HRL @B8@@@H+J2,+J2,+J2,+J2,''JBT#H@@.@@@BJ2,+
J2,+J2,+J2,EI2 ''A"@@K @@@",+J2,+J2,+J2,EARL I0X @B8@@@H+J2,+J2,+J2,EAR$#HB\FH@@.@@@BJ2,+J2,+J2,EAR$)A"@F@2@@K @@@",+J2,+
J2,EAR$)HPX HB@Y@B8@@@H+J2,+J2,EAPT)HRDFH@@@@@@.@@@BJ2,EJR$)HRD!!CB\''@2@@@@@@K @@DRPGA2<^D@,KJ!!<-JB@Y@@@@@B8@@@@@@@@@@@@@
@@@@@@@@@@@@@@@.@@@@@@@@@@@@@@@@@@@@@@@@K"8.K @a');
		colorMapFromArray:#[ 160 200 248 175 200 248 0 48 168 208 208 224 207 216 240 240 240 248 223 216 224 80 136 208 240 232 240 175 208 248 176 208 248 64 112 192 239 232 232 255 248 176 255 248 24 255 248 152 79 120 192 48 120 208 159 192 248 255 248 88 160 192 248 255 248 48 255 248 96 144 184 248 240 144 24 15 56 160 63 88 176 191 216 248 240 208 24 255 248 136 79 120 200 63 104 184 48 80 176 239 232 240 31 72 176 223 216 232 80 144 208 224 224 240 255 248 200 224 224 232 48 88 176 240 240 240 64 104 184 255 248 248 47 112 208 63 96 184 236 233 216 79 128 200 ];
		mask:((ImageMask new)
			    width:22;
			    height:22;
			    bits:(ByteArray
					fromPackedString:'@@@@A??0A??0A??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O??0O?>@O?>@O?>@@@@@@@@@');
			    yourself);
		yourself
	]
!

terminateGroupIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self terminateGroupIcon inspect
     ImageEditor openOnClass:self andSelector:#terminateGroupIcon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class terminateGroupIcon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:22;
		height:20;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@PDA@PXJB (JB (JB (JB TE@PDA@PDA@PXJB (JB (JB (JB (JA0TA@PD@@PXJB (JB (JB (JB (JB (JA D@@@HDB (J@ HJB (JB PDA@(JB X@@@@@
@P\G@PDAA (JB XA@PDFA XA@@@@A DA@PDA@PXJB (F@PDA@PDA@PX@A \A@PD@@@@@@@@@A DJ@@@@@@@@@@XJB DA@@,KB0,K@@@A@@,KB0,KB0@AA XF
B (@B0,KB0,@@@,KB0,KB0@A@PDA@PXJB @KB0,KB0,KB0,KB0@A@PDA@PXJB (J@@,KB0,KB0,KB0@A@PD@@PXJB (JB (@B0,KB0,KB0@JA D@@@HDB (J
@ HJB @KB0,KB0@JB X@@@@@@P\G@PDAA @KB0,KB0,K@@XA@@@@@@DA@PDA@P@KB0,KB0,KB0,@@P@@@@@A@PDA@P@KB0,KB0@KB0,KB0@@@@@@@@DA@P@K
B0,KB0@@@@,KB0,K@@@@@@@@@@@KB0,KB0@A@@@@B0,KB0,@@@@@@@@@@@@@@@@A@P@@@@@@@@@@@@@@@@@@@@@@@@DA@P@@@@@@@@@@@@@b');
		colorMapFromArray:#[ 0 0 0 48 48 48 56 59 56 64 68 64 88 92 88 128 128 128 160 160 160 192 192 192 216 219 216 239 244 239 248 252 248 160 0 0 ];
		mask:((ImageMask new)
			    width:22;
			    height:20;
			    bits:(ByteArray
					fromPackedString:'???<???<_??8_??0O??0_??8???<???<???<???<???<_??8_??0O??0O??0O??0G?/8A?''<A?#<@G@@');
			    yourself);
		yourself
	]
!

terminateIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self terminateIcon inspect
     ImageEditor openOnClass:self andSelector:#terminateIcon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class terminateIcon'
	ifAbsentPut:[
	    (Depth8Image new)
		width:16;
		height:16;
		photometric:(#palette);
		bitsPerSample:(#( 8 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C@@@@@@@@@@LC@@@@@@@C@ H@@@@@@@LB@ LC@@@C@ H@@@@@@@@@@@DB@ LB
@ H@@@@@@@@@@@@@@PHB@ H@@@@@@@@@@@@@@@@C@ HC@@@@@@@@@@@@@@@C@ HB@0@@@@@@@@@@@@@C@ @@@PHC@@@@@@@@@@@@@0@@@@@A@ @@@@@@@@@@
@0H@@@@@@@DB@@@@@@@@@@L@@@@@@@@@@ @@@@@@@@@C@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
		colorMapFromArray:#[ 64 0 0 128 0 0 192 0 0 255 0 0 ];
		mask:((ImageMask new)
			    width:16;
			    height:16;
			    bits:(ByteArray
					fromPackedString:'@@@@@@@HCA0_O@_8@?@A8@O A7@FL@0XC@ H@@@@@@@b');
			    yourself);
		yourself
	]
!

viewDetailsIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self viewDetailsIcon inspect
     ImageEditor openOnClass:self andSelector:#viewDetailsIcon
     Icon flushCachedIcons"

    ^ Icon constantNamed:#'ProcessMonitorV2 class viewDetailsIcon'
	ifAbsentPut:[
	    (Depth1Image new)
		width:16;
		height:16;
		photometric:(#palette);
		bitsPerSample:(#( 1 ));
		samplesPerPixel:(1);
		bits:(ByteArray
			    fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@b');
		colorMapFromArray:#[ 0 0 0 255 255 255 ];
		mask:((ImageMask new)
			    width:16;
			    height:16;
			    bits:(ByteArray
					fromPackedString:'@@@@@@@@]+X@@@@@]+X@@@@@]+X@@@@@]+X@@@@@@@@b');
			    yourself);
		yourself
	]
! !

!ProcessMonitorV2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ProcessMonitorV2 andSelector:#windowSpec
     ProcessMonitorV2 new openInterface:#windowSpec
     ProcessMonitorV2 open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'ProcessMonitor'
         name: 'ProcessMonitor'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 791 358)
         menu: mainMenu
         icon: defaultIcon
       )
       component: 
      (SpecCollection
         collection: (
          (MenuPanelSpec
             name: 'ToolBar1'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
             menu: toolBarMainMenu
             textDefault: true
           )
          (DataSetSpec
             name: 'ProcessTable'
             layout: (LayoutFrame 0 0.0 32 0.0 0 1.0 -25 1)
             model: selectedProcesses
             menu: tableMenu
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             dataList: processList
             useIndex: false
             doubleClickSelector: doubleClickedAt:
             columnHolder: tableColumns
             multipleSelectOk: true
             verticalSpacing: 0
             postBuildCallback: postBuildProcessTable:
           )
          (LabelSpec
             label: 'IRQ:'
             name: 'Label1'
             layout: (LayoutFrame 0 0 -24 1 50 0 0 1)
             activeHelpKey: interruptCount
             translateLabel: true
             adjust: left
           )
          (LabelSpec
             name: 'Label2'
             layout: (LayoutFrame 50 0 -24 1 100 0 0 1)
             activeHelpKey: interruptCount
             translateLabel: true
             labelChannel: interruptCountHolder
             adjust: left
           )
          (LabelSpec
             label: 'TMR:'
             name: 'Label3'
             layout: (LayoutFrame 100 0 -24 1 150 0 0 1)
             activeHelpKey: timerActionCount
             translateLabel: true
             adjust: left
           )
          (LabelSpec
             name: 'Label4'
             layout: (LayoutFrame 150 0 -24 1 200 0 0 1)
             activeHelpKey: timerActionCount
             translateLabel: true
             labelChannel: timerActionCountHolder
             adjust: left
           )
          (LabelSpec
             label: 'Update Interval (s):'
             name: 'ContentsUpdateLabel'
             layout: (LayoutFrame -593 1 -24 1 -402 1 0 1)
             activeHelpKey: updateInterval
             translateLabel: true
             adjust: right
           )
          (ViewSpec
             name: 'Box1'
             layout: (LayoutFrame -396 1 -24 1 -306 1 0 1)
             activeHelpKey: updateInterval
             level: 0
             component: 
            (SpecCollection
               collection: (
                (ArrowButtonSpec
                   name: 'ArrowButton3'
                   layout: (LayoutFrame 68 0 0 0 89 0 20 0)
                   translateLabel: true
                   model: increaseupdateContentsDelayTime
                   enableChannel: enableIncreaseContentsDelayTime
                   isTriggerOnDown: true
                   autoRepeat: true
                   actionValue: ''
                   direction: up
                 )
                (InputFieldSpec
                   name: 'EntryField2'
                   layout: (LayoutFrame 22 0 0 0 66 0 22 0)
                   model: updateContentsDelayTimeHolder
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: false
                 )
                (ArrowButtonSpec
                   name: 'ArrowButton4'
                   layout: (LayoutFrame 0 0 0 0 20 0 20 0)
                   translateLabel: true
                   model: decreaseupdateContentsDelayTime
                   enableChannel: enableDecreaseContentsDelayTime
                   isTriggerOnDown: true
                   autoRepeat: true
                   actionValue: ''
                   direction: down
                 )
                )
              
             )
           )
          (LabelSpec
             label: 'Processlist:'
             name: 'ListUpdateLabel'
             layout: (LayoutFrame -301 1 -24 1 -110 1 0 1)
             activeHelpKey: listUpdateInterval
             translateLabel: true
             adjust: right
           )
          (ViewSpec
             name: 'Box2'
             layout: (LayoutFrame -103 1 -24 1 -16 1 0 1)
             activeHelpKey: listUpdateInterval
             level: 0
             component: 
            (SpecCollection
               collection: (
                (ArrowButtonSpec
                   name: 'ArrowButton5'
                   layout: (LayoutFrame 68 0 0 0 89 0 20 0)
                   translateLabel: true
                   model: increaseupdateListDelayTime
                   enableChannel: enableIncreaseListDelayTime
                   isTriggerOnDown: true
                   autoRepeat: true
                   actionValue: ''
                   direction: up
                 )
                (InputFieldSpec
                   name: 'EntryField3'
                   layout: (LayoutFrame 22 0 0 0 66 0 22 0)
                   model: updateListDelayTimeHolder
                   acceptOnReturn: true
                   acceptOnTab: true
                   acceptOnLostFocus: true
                   acceptOnPointerLeave: false
                 )
                (ArrowButtonSpec
                   name: 'ArrowButton6'
                   layout: (LayoutFrame 0 0 0 0 20 0 20 0)
                   translateLabel: true
                   model: decreaseupdateListDelayTime
                   enableChannel: enableDecreaseListDelayTime
                   isTriggerOnDown: true
                   autoRepeat: true
                   actionValue: ''
                   direction: down
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
! !

!ProcessMonitorV2 class methodsFor:'menu specs'!

applicationMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProcessMonitorV2 andSelector:#applicationMenu
     (Menu new fromLiteralArrayEncoding:(ProcessMonitorV2 applicationMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: hasSelectionWithApplicationProcessHolder
	    label: 'Raise Applications Window'
	    itemValue: raiseApplicationWindow
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: hasSelectionWithApplicationProcessHolder
	    label: 'Lower Applications Window'
	    itemValue: lowerApplicationWindow
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    enabled: hasSelectionWithApplicationProcessHolder
	    label: 'Close'
	    itemValue: closeApplication
	    translateLabel: true
	  )
	 )
	nil
	nil
      )

    "Modified: / 07-06-2007 / 12:44:21 / cg"
!

debugMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProcessMonitorV2 andSelector:#debugMenu
     (Menu new fromLiteralArrayEncoding:(ProcessMonitorV2 debugMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: hasSelectionHolder
	    label: 'Inspect Process'
	    itemValue: inspectSelection
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: hasSelectionWithApplicationProcessHolder
	    label: 'Inspect Application'
	    itemValue: inspectApplication
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	  )
	 (MenuItem
	    enabled: hasSelectionWithApplicationProcessHolder
	    label: 'Browse Application'
	    itemValue: browseApplication
	    translateLabel: true
	  )
	 (MenuItem
	    label: '-'
	    isVisible: allowModificationsAndHasDebugger
	  )
	 (MenuItem
	    enabled: hasSelectionHolder
	    label: 'Debug'
	    itemValue: debugProcess
	    translateLabel: true
	    isVisible: allowModificationsAndHasDebugger
	  )
	 )
	nil
	nil
      )

    "Modified: / 07-06-2007 / 12:49:58 / cg"
!

instrumentationMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProcessMonitorV2 andSelector:#instrumentationMenu
     (Menu new fromLiteralArrayEncoding:(ProcessMonitorV2 instrumentationMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    enabled: hasSelectionWithEnabledInstrumentationHolder
	    label: 'Disable'
	    itemValue: disableInstrumentation
	    translateLabel: true
	  )
	 (MenuItem
	    enabled: hasSelectionWithDisabledInstrumentationHolder
	    label: 'Enable'
	    itemValue: enableInstrumentation
	    translateLabel: true
	  )
	 )
	nil
	nil
      )
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ProcessMonitorV2 andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(ProcessMonitorV2 mainMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    label: 'File'
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Start Timeslicing'
		  itemValue: startTimeslicing
		  translateLabel: true
		  isVisible: isNotTimeslicing
		)
	       (MenuItem
		  label: 'Stop Timeslicing'
		  itemValue: stopTimeslicing
		  translateLabel: true
		  isVisible: isTimeslicing
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  label: 'Exit'
		  itemValue: closeRequest
		  translateLabel: true
		)
	       )
	      nil
	      nil
	    )
	  )
	 (MenuItem
	    label: 'Process'
	    translateLabel: true
	    isVisible: allowModifications
	    submenuChannel: processMenu
	  )
	 (MenuItem
	    label: 'Application'
	    translateLabel: true
	    submenuChannel: applicationMenu
	    keepLinkedMenu: true
	  )
	 (MenuItem
	    label: 'Debug'
	    translateLabel: true
	    submenuChannel: debugMenu
	    keepLinkedMenu: true
	  )
	 (MenuItem
	    label: 'Instrumentation'
	    translateLabel: true
	    submenuChannel: instrumentationMenu
	    keepLinkedMenu: true
	  )
	 (MenuItem
	    label: 'View'
	    translateLabel: true
	    submenuChannel: viewDetailsMenuSpec
	  )
	 (MenuItem
	    label: 'MENU_Help'
	    startGroup: conditionalRight
	    translateLabel: true
	    submenu:
	   (Menu
	      (
	       (MenuItem
		  label: 'Documentation'
		  itemValue: openDocumentation
		  translateLabel: true
		)
	       (MenuItem
		  label: '-'
		)
	       (MenuItem
		  label: 'About this Application...'
		  itemValue: openAboutThisApplication
		  translateLabel: true
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
!

processMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ProcessMonitorV2 andSelector:#processMenu
     (Menu new fromLiteralArrayEncoding:(ProcessMonitorV2 processMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            enabled: hasSelectionWithStoppedProcessHolder
            label: 'Resume'
            itemValue: resumeProcess
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Suspend'
            itemValue: suspendProcess
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Stop'
            itemValue: stopProcess
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Abort'
            itemValue: abortProcess
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Terminate'
            itemValue: terminateProcess
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Hard Terminate'
            itemValue: hardTerminateProcess
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Terminate Group'
            itemValue: terminateProcessGroup
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Terminate All Like This'
            itemValue: terminateAllLikeThis
          )
         (MenuItem
            enabled: selectionRestartable
            label: 'Restart'
            itemValue: restartProcess
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Raise Prio'
            itemValue: raisePrio
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Lower Prio'
            itemValue: lowerPrio
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Set Prio Range...'
            itemValue: setPrioRange
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Find by View'
            itemValue: findProcessByView
          )
         )
        nil
        nil
      )
!

tableMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ProcessMonitorV2 andSelector:#tableMenu
     (Menu new fromLiteralArrayEncoding:(ProcessMonitorV2 tableMenu)) startUp
    "

    <resource: #menu>

    ^
     #(#Menu
        #(
         #(#MenuItem
            #enabled: #hasSelectionHolder
            #label: 'Debug'
            #itemValue: #debugProcess
          )
         #(#MenuItem
            #enabled: #hasSelectionHolder
            #label: 'Inspect'
            #itemValue: #inspectSelection
          )
         #(#MenuItem
            #enabled: #hasSelectionWithApplicationProcessHolder
            #label: 'Inspect Application'
            #itemValue: #inspectApplication
          )
         #(#MenuItem
            #enabled: #hasSelectionWithApplicationProcessHolder
            #label: 'Browse Application'
            #itemValue: #browseApplication
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #enabled: #hasSelectionWithStoppedProcessHolder
            #label: 'Resume'
            #itemValue: #resumeProcess
          )
         #(#MenuItem
            #enabled: #hasSelectionHolder
            #label: 'Suspend'
            #itemValue: #suspendProcess
          )
         #(#MenuItem
            #enabled: #hasSelectionHolder
            #label: 'Stop'
            #itemValue: #stopProcess
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #enabled: #hasSelectionHolder
            #label: 'Abort'
            #itemValue: #abortProcess
          )
         #(#MenuItem
            #enabled: #hasSelectionHolder
            #label: 'Terminate'
            #itemValue: #terminateProcess
          )
         #(#MenuItem
            #enabled: #hasSelectionHolder
            #label: 'Hard Terminate'
            #itemValue: #hardTerminateProcess
          )
         #(#MenuItem
            #enabled: #hasSelectionHolder
            #label: 'Terminate Group'
            #itemValue: #terminateProcessGroup
          )
         (MenuItem
            enabled: hasSelectionHolder
            label: 'Terminate All Like This'
            itemValue: terminateAllLikeThis
          )
         #(#MenuItem
            #enabled: #selectionRestartable
            #label: 'Restart'
            #itemValue: #restartProcess
          )
         #(#MenuItem
            #label: '-'
          )
         #(#MenuItem
            #enabled: #hasSelectionHolder
            #label: 'Raise Prio'
            #itemValue: #raisePrio
          )
         #(#MenuItem
            #enabled: #hasSelectionHolder
            #label: 'Lower Prio'
            #itemValue: #lowerPrio
          )
         )
        nil
        nil
      )

    "Modified: / 07-06-2007 / 12:49:47 / cg"
!

toolBarMainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ProcessMonitorV2 andSelector:#toolBarMainMenu
     (Menu new fromLiteralArrayEncoding:(ProcessMonitorV2 toolBarMainMenu)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
	(
	 (MenuItem
	    activeHelpKey: Inspect
	    enabled: hasSelectionHolder
	    label: 'Inspect'
	    itemValue: inspectSelection
	    isButton: true
	    isVisible: allowModifications
	    labelImage: (ResourceRetriever ProcessMonitorV2 processInspect22x22Icon)
	  )
	 (MenuItem
	    activeHelpKey: Debug
	    enabled: hasSelectionHolder
	    label: 'Debug'
	    itemValue: debugProcess
	    isButton: true
	    isVisible: allowModificationsAndHasDebugger
	    labelImage: (ResourceRetriever ProcessMonitorV2 processDebug22x22Icon)
	  )
	 (MenuItem
	    activeHelpKey: RaiseWindow
	    enabled: hasSelectionWithApplicationProcessHolder
	    label: 'Raise Applications Window'
	    itemValue: raiseApplicationWindow
	    isButton: true
	    labelImage: (ResourceRetriever ProcessMonitorV2 raiseWindow22x22Icon)
	  )
	 (MenuItem
	    label: 'Find Process by View'
	    itemValue: findProcessByView
	    isButton: true
	    labelImage: (ResourceRetriever ToolbarIconLibrary pickWindowIcon)
	  )
	 (MenuItem
	    label: '-'
	    isVisible: allowModifications
	  )
	 (MenuItem
	    activeHelpKey: Resume
	    enabled: hasSelectionWithStoppedProcessHolder
	    label: 'Resume'
	    itemValue: resumeProcess
	    isButton: true
	    isVisible: allowModifications
	    labelImage: (ResourceRetriever ProcessMonitorV2 processResume22x22Icon)
	  )
	 (MenuItem
	    activeHelpKey: Stop
	    enabled: hasSelectionHolder
	    label: 'Stop'
	    itemValue: stopProcess
	    isButton: true
	    isVisible: allowModifications
	    labelImage: (ResourceRetriever ProcessMonitorV2 processStop22x22Icon)
	  )
	 (MenuItem
	    activeHelpKey: Abort
	    enabled: hasSelectionHolder
	    label: 'Abort'
	    itemValue: abortProcess
	    isButton: true
	    isVisible: allowModifications
	    labelImage: (ResourceRetriever ProcessMonitorV2 processAbort22x22Icon)
	  )
	 (MenuItem
	    label: '-'
	    isVisible: allowModifications
	  )
	 (MenuItem
	    activeHelpKey: Terminate
	    enabled: hasSelectionHolder
	    label: 'Terminate'
	    itemValue: terminateProcess
	    isButton: true
	    isVisible: allowModifications
	    labelImage: (ResourceRetriever ProcessMonitorV2 processTerminate22x22Icon)
	  )
	 (MenuItem
	    activeHelpKey: #'Terminate Group'
	    enabled: hasSelectionHolder
	    label: 'Terminate Group'
	    itemValue: terminateProcessGroup
	    isButton: true
	    isVisible: allowModifications
	    labelImage: (ResourceRetriever ProcessMonitorV2 processTerminateGroup22x22Icon)
	  )
	 (MenuItem
	    activeHelpKey: Restart
	    enabled: selectionRestartable
	    label: 'Restart'
	    itemValue: restartProcess
	    isButton: true
	    isVisible: allowModifications
	    labelImage: (ResourceRetriever ProcessMonitorV2 processRestart22x22Icon)
	  )
	 (MenuItem
	    label: '-'
	    isVisible: allowModifications
	  )
	 (MenuItem
	    activeHelpKey: #'Lower Prio'
	    enabled: hasSelectionHolder
	    label: 'Lower Prio'
	    itemValue: lowerPrio
	    isButton: true
	    isVisible: allowModifications
	    labelImage: (ResourceRetriever ProcessMonitorV2 processLowerPrio22x22Icon)
	  )
	 (MenuItem
	    activeHelpKey: #'Raise Prio'
	    enabled: hasSelectionHolder
	    label: 'Raise Prio'
	    itemValue: raisePrio
	    isButton: true
	    isVisible: allowModifications
	    labelImage: (ResourceRetriever ProcessMonitorV2 processRaisePrio22x22Icon)
	  )
	 (MenuItem
	    label: ''
	    isVisible: allowModifications
	  )
	 (MenuItem
	    activeHelpKey: #'Update Process List'
	    label: 'Update'
	    itemValue: updateList
	    isButton: true
	    startGroup: right
	    labelImage: (ResourceRetriever ToolbarIconLibrary reloadIcon)
	  )
	 (MenuItem
	    activeHelpKey: Details
	    label: 'View Details'
	    isButton: true
	    startGroup: right
	    submenuChannel: viewDetailsMenuSpec
	    labelImage: (ResourceRetriever ToolbarIconLibrary viewDetailsIcon)
	  )
	 )
	nil
	nil
      )
!

viewDetailsMenuSpec
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:ProcessMonitorV2 andSelector:#viewDetailsMenuSpec
     (Menu new fromLiteralArrayEncoding:(ProcessMonitorV2 viewDetailsMenuSpec)) startUp
    "

    <resource: #menu>

    ^
     #(Menu
        (
         (MenuItem
            label: 'Id'
            hideMenuOnActivated: false
            indication: showProcessId
          )
         (MenuItem
            label: 'Group'
            hideMenuOnActivated: false
            indication: showGroup
          )
         (MenuItem
            label: 'Instrumentation'
            hideMenuOnActivated: false
            indication: showInstrumentation
          )
         (MenuItem
            label: 'State'
            hideMenuOnActivated: false
            indication: showState
          )
         (MenuItem
            label: 'Prio'
            hideMenuOnActivated: false
            indication: showPrio
          )
         (MenuItem
            label: 'Used Stack'
            hideMenuOnActivated: false
            indication: showUsedStack
          )
         (MenuItem
            label: 'Total Stack'
            hideMenuOnActivated: false
            indication: showTotalStack
          )
         (MenuItem
            label: 'Current-Segment'
            hideMenuOnActivated: false
            indication: showCurrentSegment
          )
         (MenuItem
            label: 'Switch'
            hideMenuOnActivated: false
            indication: showSwitch
          )
         (MenuItem
            label: 'Where'
            hideMenuOnActivated: false
            indication: showWhere
          )
         (MenuItem
            label: 'Application'
            hideMenuOnActivated: false
            indication: showApplication
          )
         (MenuItem
            label: 'Window Title'
            hideMenuOnActivated: false
            indication: showWindowTitle
          )
         (MenuItem
            label: 'Start Time'
            hideMenuOnActivated: false
            indication: showStartTime
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Show Dead Processes'
            indication: showDeadHolder
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            label: 'Update'
            itemValue: updateView
          )
         )
        nil
        nil
      )
! !

!ProcessMonitorV2 class methodsFor:'tableColumns specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:ProcessMonitorV2 andSelector:#tableColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Id'
         id: id
         labelAlignment: left
         activeHelpKeyForLabel: 'processId'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'idVal'
         width: 45
         height: heightOfFirstRow
         type: number
         model: processId
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Group'
         id: group
         labelAlignment: left
         activeHelpKeyForLabel: 'processGroup'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'groupVal'
         width: 45
         height: heightOfFirstRow
         model: processGroup
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Name'
         id: name
         labelAlignment: left
         activeHelpKeyForLabel: 'processName'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processName'
         width: 200
         height: heightOfFirstRow
         model: processName
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Instr.'
         id: instrumentation
         labelAlignment: left
         activeHelpKeyForLabel: 'processInstrumentation'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processInstrumentation'
         width: 50
         height: heightOfFirstRow
         model: processInstrumentation
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: ''
         id: active
         activeHelpKeyForLabel: 'processWasActive'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processActive'
         width: 10
         height: 5
         model: processActive
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'State'
         id: state
         labelAlignment: left
         activeHelpKeyForLabel: 'processState'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processState'
         width: 100
         height: heightOfFirstRow
         model: processState
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Prio'
         id: prio
         labelAlignment: left
         activeHelpKeyForLabel: 'processPriority'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'prioVal'
         width: 40
         height: heightOfFirstRow
         model: processPrio
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Used Stack'
         id: usedStack
         labelAlignment: left
         activeHelpKeyForLabel: 'processUsedStack'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processUsedStack'
         columnAlignment: right
         width: 75
         height: heightOfFirstRow
         type: number
         model: processUsedStack
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Total Stack'
         id: totalStack
         labelAlignment: left
         activeHelpKeyForLabel: 'processTotalStack'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processTotalStack'
         columnAlignment: right
         width: 75
         height: heightOfFirstRow
         model: processTotalStack
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Current-Segment'
         id: currentSegment
         labelAlignment: left
         activeHelpKeyForLabel: 'processCurrentSegment'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processCurrentSegment'
         width: 110
         height: heightOfFirstRow
         model: processCurrentSegment
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Switch'
         id: switch
         labelAlignment: left
         activeHelpKeyForLabel: 'processSwitch'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processSwitch'
         columnAlignment: right
         width: 55
         height: heightOfFirstRow
         type: number
         model: processSwitch
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Where'
         id: where
         labelAlignment: left
         activeHelpKeyForLabel: 'processWhere'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processWhere'
         height: heightOfFirstRow
         model: processWhere
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Application'
         id: application
         labelAlignment: left
         activeHelpKeyForLabel: 'processApplication'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processApplication'
         height: heightOfFirstRow
         model: processApplication
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Window Title'
         id: windowTitle
         labelAlignment: left
         activeHelpKeyForLabel: 'processWindowTitle'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processWindowTitle'
         height: heightOfFirstRow
         model: processWindowTitle
         menuFromApplication: false
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Start Time'
         id: startTime
         activeHelpKeyForLabel: 'processStartTime'
         labelButtonType: Button
         labelActionSelector: sortProcessListBy:
         labelActionArgument: 'processStartTime'
         height: heightOfFirstRow
         type: timestamp
         model: processStartTime
         formatString: '%(day)-%(shortMonthName) %h:%m:%s'
         menuFromApplication: false
         showRowSeparator: false
         showColSeparator: false
       )
      )
    
! !

!ProcessMonitorV2 methodsFor:'accessing'!

visibleBlock
    ^ visibleBlock
!

visibleBlock:aProcessVisibleFilterBlock
    visibleBlock := aProcessVisibleFilterBlock.
! !

!ProcessMonitorV2 methodsFor:'actions'!

changeSelectionTo:aSelection
    | newSelection |

    aSelection notNil ifTrue:[
	newSelection := OrderedCollection new.
	aSelection do:[:processItem |
	    | index |

	    index := processList findFirst:[:anItem | (anItem processInstance == processItem processInstance)].
	    index ~~ 0 ifTrue:[
		newSelection add:(processList at:index).
	    ].
	].
	self selectedProcesses value:newSelection
    ].
!

changeSelectionToProcesses:aProcessList

    aProcessList notNil ifTrue:[
	| newSelection |
	newSelection := OrderedCollection new.
	aProcessList do:[:aProcess |
	    | index |
	    index := processList findFirst:[:anItem | (anItem processInstance == aProcess)].
	    index ~~ 0 ifTrue:[
		newSelection add:(processList at:index).
	    ].
	].
	self selectedProcesses value:newSelection
    ].
!

decreaseupdateContentsDelayTime
    updateDelay := (self scaledUpdateContentsDelayTime - 0.1) asFixedPoint:1.
    self updateContentsDelayTimeHolder value:updateDelay.
    self evaluateEnableInDecreaseButtons.
!

decreaseupdateListDelayTime
    listUpdateDelay := (self scaledUpdateListDelayTime - 0.1) asFixedPoint:1.
    self updateListDelayTimeHolder value:listUpdateDelay.
    self evaluateEnableInDecreaseButtons.
!

doubleClickedAt:anItemIndex
    "open a debugger on the selected process"

    self debugProcess
!

evaluateEnableInDecreaseButtons
    | contentsDelaySmallerThanListDelay |

    updateDelay := self scaledUpdateContentsDelayTime.
    listUpdateDelay := self scaledUpdateListDelayTime.
    
    contentsDelaySmallerThanListDelay := (updateDelay < listUpdateDelay).
    self enableDecreaseContentsDelayTime value:(updateDelay > 0.5).
    self enableDecreaseListDelayTime value:contentsDelaySmallerThanListDelay.
    self enableIncreaseContentsDelayTime value:contentsDelaySmallerThanListDelay.
!

getProcessList
    "select processes to display.
     Subclasses may redefine this"

    |coll|

    self showDeadHolder value ifTrue:[
        coll := Process allSubInstances asOrderedCollection.
    ] ifFalse:[
        coll := ProcessorScheduler knownProcesses asOrderedCollection.
        coll add:Processor scheduler.
    ].
    ^ coll
!

increaseupdateContentsDelayTime
    updateDelay := (self scaledUpdateContentsDelayTime + 0.1) asFixedPoint:1.
    self updateContentsDelayTimeHolder value:updateDelay.
    self evaluateEnableInDecreaseButtons.
!

increaseupdateListDelayTime
    listUpdateDelay := (self scaledUpdateListDelayTime + 0.1) asFixedPoint:1.
    self updateListDelayTimeHolder value:listUpdateDelay.
    self evaluateEnableInDecreaseButtons.
!

selectedProcessesDo:aBlock
    | sel proc|

    sel := self selectedProcesses value.
    sel isNil ifTrue:[^ self].

    sel do:[:processItem |
	proc := processItem processInstance.
	proc notNil ifTrue:[
	    aBlock value:proc.
	].
    ].

    "Modified: / 07-06-2007 / 12:38:25 / cg"
!

selectedProcessesSend:aSelector
    "send a message to all selected processes"

    self selectedProcessesDo:[:p |
	p perform:aSelector
    ].

    self updateList.

    "Modified: / 07-06-2007 / 12:38:29 / cg"
! !

!ProcessMonitorV2 methodsFor:'aspects'!

currentSortOrder
    "return/create the 'currentSortOrder' value holder (automatically generated)"

    currentSortOrder isNil ifTrue:[
	currentSortOrder := Dictionary new asValue.
    ].
    ^ currentSortOrder
!

interruptCountHolder

    interruptCountHolder isNil ifTrue:[
        interruptCountHolder := '-' asValue.
    ].
    ^ interruptCountHolder.
!

isNotTimeslicing
    ^ self isTimeslicing not

    "Created: / 03-11-2011 / 21:26:10 / cg"
!

isTimeslicing
    ^ Processor isTimeSlicing

    "Created: / 03-11-2011 / 21:25:53 / cg"
!

processList

    processList isNil ifTrue:[
	processList := List new.
    ].
    ^ processList.
!

scaledUpdateContentsDelayTime

    ^ self updateContentsDelayTimeHolder value asFloat asFixedPoint:1.
!

scaledUpdateListDelayTime

    ^ self updateListDelayTimeHolder value asFloat asFixedPoint:1.
!

selectedProcesses

    selectedProcesses isNil ifTrue:[
        selectedProcesses := ValueHolder new.
        selectedProcesses onChangeSend:#selectionChanged to:self.
        "/ selectedProcesses addDependent:self.
    ].
    ^ selectedProcesses.
!

showDeadHolder
    "return/create the 'showDead' value holder (automatically generated)"

    showDeadHolder isNil ifTrue:[
        showDeadHolder := false asValue.
        showDeadHolder onChangeSend:#updateList to:self.
        "/ showDead addDependent:self.
    ].
    ^ showDeadHolder
!

sortBlock

    sortBlock isNil ifTrue:[
	| curSortOrder defaultSortInstance|
	defaultSortInstance := #idVal.
	sortBlock := [:a :b |
	    ((a perform:defaultSortInstance) < (b perform:defaultSortInstance))
	].
	curSortOrder := self currentSortOrder value.
	curSortOrder at:#column put:defaultSortInstance.
	curSortOrder at:#reverse put:true.
    ].
    ^ sortBlock
!

tableColumns

    tableColumns isNil ifTrue:[
	tableColumns := self class tableColumns asValue.
    ].
    ^ tableColumns.
!

timerActionCountHolder

    timerActionCountHolder isNil ifTrue:[
        timerActionCountHolder := '-' asValue.
    ].
    ^ timerActionCountHolder.
!

updateContentsDelayTimeHolder

    updateContentsDelayTimeHolder isNil ifTrue:[
        updateContentsDelayTimeHolder := updateDelay asValue.
        updateContentsDelayTimeHolder onChangeSend:#evaluateEnableInDecreaseButtons to:self.
    ].
    ^ updateContentsDelayTimeHolder.
!

updateListDelayTimeHolder

    updateListDelayTimeHolder isNil ifTrue:[
        updateListDelayTimeHolder := listUpdateDelay asValue.
        updateListDelayTimeHolder onChangeSend:#evaluateEnableInDecreaseButtons to:self.
    ].
    ^ updateListDelayTimeHolder.
! !

!ProcessMonitorV2 methodsFor:'aspects-column'!

showApplication
    "return/create the 'showApplication' value holder (automatically generated)"

    showApplication isNil ifTrue:[
	showApplication := false asValue.
	showApplication onChangeSend:#viewedColumnsChanged to:self
    ].
    ^ showApplication

    "Created: / 17-08-2011 / 10:46:56 / cg"
!

showCurrentSegment
    "return/create the 'showCurrentSegment' value holder (automatically generated)"

    showCurrentSegment isNil ifTrue:[
	showCurrentSegment := showDetail asValue.
	showCurrentSegment onChangeSend:#viewedColumnsChanged to:self.
    ].
    ^ showCurrentSegment
!

showGroup
    "return/create the 'showGroup' value holder (automatically generated)"

    showGroup isNil ifTrue:[
	showGroup := true asValue.
	showGroup onChangeSend:#viewedColumnsChanged to:self.
    ].
    ^ showGroup
!

showInstrumentation
    "return/create the 'showInstrumentation' value holder (automatically generated)"

    showInstrumentation isNil ifTrue:[
	showInstrumentation := true asValue.
	showInstrumentation onChangeSend:#viewedColumnsChanged to:self
    ].
    ^ showInstrumentation

    "Created: / 17-08-2011 / 10:46:27 / cg"
!

showPrio
    "return/create the 'showPrio' value holder (automatically generated)"

    showPrio isNil ifTrue:[
	showPrio := true asValue.
	showPrio onChangeSend:#viewedColumnsChanged to:self.
    ].
    ^ showPrio
!

showProcessId

    showProcessId isNil ifTrue:[
	showProcessId := true asValue.
	showProcessId onChangeSend:#viewedColumnsChanged to:self
    ].
    ^ showProcessId
!

showStartTime
    "return/create the 'showStartTime' value holder (automatically generated)"

    showStartTime isNil ifTrue:[
        showStartTime := false asValue.
        showStartTime onChangeSend:#viewedColumnsChanged to:self
    ].
    ^ showStartTime
!

showState
    "return/create the 'showState' value holder (automatically generated)"

    showState isNil ifTrue:[
	showState := true asValue.
	showState onChangeSend:#viewedColumnsChanged to:self
    ].
    ^ showState
!

showSwitch
    "return/create the 'showSwitch' value holder (automatically generated)"

    showSwitch isNil ifTrue:[
	showSwitch := showDetail asValue.
	showSwitch onChangeSend:#viewedColumnsChanged to:self
    ].
    ^ showSwitch
!

showTotalStack
    "return/create the 'showTotalStack' value holder (automatically generated)"

    showTotalStack isNil ifTrue:[
	showTotalStack := showDetail asValue.
	showTotalStack onChangeSend:#viewedColumnsChanged to:self
    ].
    ^ showTotalStack
!

showUsedStack
    "return/create the 'showUsedStack' value holder (automatically generated)"

    showUsedStack isNil ifTrue:[
	showUsedStack := showDetail asValue.
	showUsedStack onChangeSend:#viewedColumnsChanged to:self
    ].
    ^ showUsedStack
!

showWhere
    "return/create the 'showWhere' value holder (automatically generated)"

    showWhere isNil ifTrue:[
	showWhere := true asValue.
	showWhere onChangeSend:#viewedColumnsChanged to:self
    ].
    ^ showWhere
!

showWindowTitle
    "return/create the 'showWindowTitle' value holder (automatically generated)"

    showWindowTitle isNil ifTrue:[
	showWindowTitle := false asValue.
	showWindowTitle onChangeSend:#viewedColumnsChanged to:self
    ].
    ^ showWindowTitle

    "Created: / 17-08-2011 / 10:46:47 / cg"
! !

!ProcessMonitorV2 methodsFor:'aspects-menu enabling'!

allowModifications

    allowModifications isNil ifTrue:[
	allowModifications := true asValue
    ].
    ^ allowModifications
!

allowModificationsAndHasDebugger
    ^ BlockValue
	forLogical:(self allowModifications)
	and:[ Debugger notNil ]
!

enableDecreaseContentsDelayTime

    enableDecreaseContentsDelayTime isNil ifTrue:[
	enableDecreaseContentsDelayTime := true asValue.
    ].
    ^ enableDecreaseContentsDelayTime.
!

enableDecreaseListDelayTime

    enableDecreaseListDelayTime isNil ifTrue:[
	enableDecreaseListDelayTime := true asValue.
    ].
    ^ enableDecreaseListDelayTime.
!

enableIncreaseContentsDelayTime

    enableIncreaseContentsDelayTime isNil ifTrue:[
	enableIncreaseContentsDelayTime := true asValue.
    ].
    ^ enableIncreaseContentsDelayTime.
!

enableIncreaseListDelayTime

    enableIncreaseListDelayTime isNil ifTrue:[
	enableIncreaseListDelayTime := true asValue.
    ].
    ^ enableIncreaseListDelayTime.
!

hasSelection
    ^ self selectedProcesses value notEmptyOrNil

    "Modified: / 05-06-2007 / 17:43:58 / cg"
!

hasSelectionHolder
    ^ hasSelectionHolder

    "Created: / 05-06-2007 / 17:41:54 / cg"
!

hasSelectionWithApplicationProcess
    ^ self hasSelectionWithProcessForWhich:[:p |self isApplicationProcess:p ]

    "Created: / 05-06-2007 / 17:50:37 / cg"
!

hasSelectionWithApplicationProcessHolder
    ^ hasSelectionWithApplicationProcessHolder

    "Created: / 05-06-2007 / 17:50:31 / cg"
!

hasSelectionWithDisabledInstrumentation
    InstrumentationContext isNil ifTrue:[^ false].

    ^ self hasSelectionWithProcessForWhich:[:p | (InstrumentationContext forProcess:p) isNil ]

    "Created: / 17-08-2011 / 11:42:19 / cg"
!

hasSelectionWithDisabledInstrumentationHolder
    ^ hasSelectionWithDisabledInstrumentationHolder

    "Created: / 17-08-2011 / 11:49:35 / cg"
!

hasSelectionWithEnabledInstrumentation
    InstrumentationContext isNil ifTrue:[^ false].

    ^ self hasSelectionWithProcessForWhich:[:p | (InstrumentationContext forProcess:p) notNil ]

    "Created: / 17-08-2011 / 11:42:08 / cg"
!

hasSelectionWithEnabledInstrumentationHolder
    ^ hasSelectionWithEnabledInstrumentationHolder

    "Created: / 17-08-2011 / 11:49:39 / cg"
!

hasSelectionWithGUIProcess
    ^ self hasSelectionWithProcessForWhich:[:p |p isGUIProcess ]

    "Created: / 05-06-2007 / 17:52:10 / cg"
!

hasSelectionWithGUIProcessHolder
    ^ hasSelectionWithGUIProcessHolder

    "Created: / 05-06-2007 / 17:52:01 / cg"
!

hasSelectionWithProcessForWhich:aBlock
    ^ self hasSelection
      and:[ self selectedProcesses value contains:[:pItem |
		|process|

		process := pItem processInstance.
		process notNil and:[ aBlock value:process ]]  ]

    "Created: / 05-06-2007 / 17:40:27 / cg"
!

hasSelectionWithStoppedProcess
    ^ self hasSelectionWithProcessForWhich:[:p |p isStopped ]

    "Modified: / 05-06-2007 / 17:40:42 / cg"
!

hasSelectionWithStoppedProcessHolder
    ^ hasSelectionWithStoppedProcessHolder

    "Created: / 05-06-2007 / 17:42:41 / cg"
!

selectionRestartable

    selectionRestartable isNil ifTrue:[
	selectionRestartable := ValueHolder new.
    ].
    ^ selectionRestartable
! !

!ProcessMonitorV2 methodsFor:'change & update'!

selectionChanged

    |hasSelection allRestartable|

    hasSelection := self hasSelection.

    hasSelectionHolder value:hasSelection.

    hasSelection ifFalse:[
	self selectionRestartable value:false.
	hasSelectionWithStoppedProcessHolder value:false.
	hasSelectionWithApplicationProcessHolder value:false.
	hasSelectionWithGUIProcessHolder value:false.
	hasSelectionWithEnabledInstrumentationHolder value:false.
	hasSelectionWithDisabledInstrumentationHolder value:false.
	^ self
    ].

    hasSelectionWithStoppedProcessHolder value:self hasSelectionWithStoppedProcess.
    hasSelectionWithApplicationProcessHolder value:self hasSelectionWithApplicationProcess.
    hasSelectionWithGUIProcessHolder value:self hasSelectionWithGUIProcess.
    hasSelectionWithEnabledInstrumentationHolder value:self hasSelectionWithEnabledInstrumentation.
    hasSelectionWithDisabledInstrumentationHolder value:self hasSelectionWithDisabledInstrumentation.

    allRestartable := true.
    self selectedProcessesDo:[:p |
	p isRestartable ifFalse:[
	    allRestartable := false
	].
    ].
    self selectionRestartable value:allRestartable.
    ^ self.

    "Modified: / 17-08-2011 / 11:41:32 / cg"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == builder window ifTrue:[
        something == #visibility ifTrue:[
            self updateList.
        ].
    ].
    super update:something with:aParameter from:changedObject
!

viewedColumnsChanged
    "take the class's columnSpec and select the one's selected by the user.
     Stuff this filtered tableColSpec into the value holder"
    
    | columns buffer locCurrentSortOrder currentSortOrderColumn currentSortOrderReverse oldSelection sel|

    "/ remember the selected processes
    sel := self selectedProcesses value.
    sel notNil ifTrue:[
        oldSelection := OrderedCollection new.
        sel do:[:proItem|
            |process|

            (process := proItem processInstance) notNil ifTrue:[
                oldSelection add:process
            ].
        ].
    ].

    "/ Transcript showCR:'oldSelection on catch in viewedColumnsChanged', (oldSelection isNil ifTrue:['nil'] ifFalse:[oldSelection first printString]).
    columns := OrderedCollection new.
    self class tableColumns do:[:el|
        columns add:(DataSetColumnSpec decodeFromLiteralArray:el).
    ].
    buffer := columns copy.
    locCurrentSortOrder := self currentSortOrder value.
    currentSortOrderColumn := locCurrentSortOrder at:#column ifAbsent:nil.
    currentSortOrderReverse := locCurrentSortOrder at:#reverse ifAbsent:nil.
    buffer do:[:col |
        | id |
        id := col id.
        id notNil ifTrue:[
            (col labelActionArgument notNil and:[col labelActionArgument asSymbol == currentSortOrderColumn]) ifTrue:[
                | label icon|
                label := col label.
                icon := currentSortOrderReverse ifTrue:[self class detailsMenuIconDown] ifFalse:[self class detailsMenuIconUp].
                col label:(LabelAndIcon label:label icon:icon).
            ].
            #(
                ( #id             #showProcessId)
                ( #group          #showGroup)
                ( #prio           #showPrio)
                ( #currentSegment #showCurrentSegment)
                ( #state          #showState)
                ( #switch         #showSwitch)
                ( #totalStack     #showTotalStack)
                ( #usedStack      #showUsedStack)
                ( #where          #showWhere)
                ( #application    #showApplication)
                ( #windowTitle    #showWindowTitle)
                ( #startTime      #showStartTime)
                ( #instrumentation #showInstrumentation)
            ) pairsDo:[:colName :holderAccessorSelector |
                (id == colName and:[(self perform:holderAccessorSelector) value not]) ifTrue:[
                    columns remove:col.
                ]
            ]
        ]
    ].
    
    updateSema critical:[
        self tableColumns value:columns.
"/        self updateTable:nil.
"/        Transcript showCR:'oldSelection on set in viewedColumnsChanged', (oldSelection isNil ifTrue:['nil'] ifFalse:[oldSelection first printString]).
        self changeSelectionToProcesses:oldSelection.
    ].

    "Modified: / 17-08-2011 / 11:11:21 / cg"
! !

!ProcessMonitorV2 methodsFor:'event handling'!

processEvent:anEvent
    "filter keyboard events.
     Return true, if I have eaten the event"

    <resource: #keyboard (#InspectIt )>

    |focusView key rawKey|

    anEvent isKeyPressEvent ifTrue:[
	focusView := anEvent targetView.
	key := anEvent key.
	rawKey := anEvent rawKey.

	(focusView == processList) ifTrue:[
	    key == #InspectIt ifTrue:[
		self inspectSelection.
		^ true.
	    ].
	]
    ].
    ^ false
! !

!ProcessMonitorV2 methodsFor:'initialization & release'!

commonPostOpen

    super commonPostOpen.

    builder window addDependent:self.
    self viewedColumnsChanged.
    self updateList.
    self startUpdateProcess.
    self selectionChanged.
    self sortProcessListBy:#idVal.
    self windowGroup addPreEventHook:self.
!

initialize

    super initialize.

    hasSelectionHolder := false asValue.
    hasSelectionWithStoppedProcessHolder := false asValue.
    hasSelectionWithApplicationProcessHolder := false asValue.
    hasSelectionWithGUIProcessHolder := false asValue.
    hasSelectionWithDisabledInstrumentationHolder := false asValue.
    hasSelectionWithEnabledInstrumentationHolder := false asValue.

    showDetail := (Smalltalk at:#SystemDebugging ifAbsent:false).
    updateSema := Semaphore forMutualExclusion.
    updateDelay := 1.0 "0.5" asFixedPoint:1.     "/ seconds
    listUpdateDelay := 5.0 asFixedPoint:1.

    "/ event mode is no longer used;
    "/ this event support may vanish
    Processor isPureEventDriven ifTrue:[
        updateBlock := [self updateStatus:nil].
        listUpdateBlock := [self updateList].
    ].

    "Modified: / 17-08-2011 / 11:39:13 / cg"
!

postBuildProcessTable:aWidget

    processTable       := aWidget scrolledView.
    processTable wantsFocusWithPointerEnter.
!

release
    updateBlock notNil ifTrue:[
	Processor removeTimedBlock:updateBlock.
	updateBlock := nil.
    ].
    listUpdateBlock notNil ifTrue:[
	Processor removeTimedBlock:listUpdateBlock.
	listUpdateBlock := nil.
    ].
    updateProcess notNil ifTrue:[
	updateProcess terminate.
	updateProcess := nil.
    ].
    super release
!

restarted
    "restarted from snapshot"

    super restarted.
    self startUpdateProcess.
! !

!ProcessMonitorV2 methodsFor:'menu accessing'!

tableMenu

    ^[
	self tableMenuAccess
    ]
!

tableMenuAccess
    self allowModifications value ifTrue:[
	tableMenu isNil ifTrue:[
	    tableMenu := Menu decodeFromLiteralArray:(self class tableMenu).
	    tableMenu receiver:self.
	    tableMenu findGuiResourcesIn:self.
	].
	^ tableMenu
    ].
    ^ nil

    "Modified: / 27-03-2007 / 08:43:43 / cg"
! !

!ProcessMonitorV2 methodsFor:'menu actions'!

abortProcess
    "abort (raise AbortSignal in) the selected process"

    self selectedProcessesDo:[:p |
	p abort
    ].
    self updateList.

    "Modified: / 07-06-2007 / 12:38:42 / cg"
!

findProcessByView
    "let user click on a window. then select the corresponding process"

    |v wg p item|

    v := Screen current viewFromUser.
    v notNil ifTrue:[
	(wg := v windowGroup) notNil ifTrue:[
	    (p := wg process) notNil ifTrue:[
		item := processList detect:[:i | i processId = p id] ifNone:nil.
		item notNil ifTrue:[
		    self selectedProcesses value:(Array with:item)
		]
	    ].
	]
    ].
!

hardTerminateProcess
    "hard terminate the selected process"

    self selectedProcessesSend:#terminateNoSignal
!

lowerPrio
    "lower the selected processes priority"

    self selectedProcessesDo:[:p |
       p priority:(p priority - 1)
    ].
    self updateList.

    "Modified: / 07-06-2007 / 12:38:50 / cg"
!

openDocumentation
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    HTMLDocumentView openFullOnDocumentationFile:'tools/misc/TOP.html#PROCESSMONITOR'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
!

raisePrio
    "raise the selected processes priority"

    self selectedProcessesDo:[:p |
       p priority:(p priority + 1)
    ].
    self updateList.

    "Modified: / 07-06-2007 / 12:38:57 / cg"
!

restartProcess
    "restarts the selected process"

    self selectedProcessesDo:[:p |
	p restart.
    ].
    self updateList.

    "Modified: / 07-06-2007 / 12:39:04 / cg"
!

resumeProcess
    "resume the selected process (i.e. let it run) "

    self selectedProcessesSend:#resume
!

setPrioRange
    "set a prio-range the selected processes priority"

    |rangeString range|

    [
	rangeString := Dialog
			    request:'Priority Range (min to: max)'
			    initialAnswer:'7 to: 8'.
	rangeString isNil ifTrue:[
	    ^ self  "aborted"
	].
	range := Interval readFrom:rangeString onError:nil.
    ] doWhile:[range isNil].

    self selectedProcessesDo:[:p |
       p priorityRange:range
    ].
    self updateList.
!

startTimeslicing
    Processor isTimeSlicing ifFalse:[
	Processor startTimeSlicing.
    ].

    "Created: / 03-11-2011 / 21:26:27 / cg"
!

stopProcess
    "stop the selected process - not even interrupts will wake it up"

    self selectedProcessesSend:#stop
!

stopTimeslicing
    Processor isTimeSlicing ifTrue:[
	Processor stopTimeSlicing.
    ].

    "Created: / 03-11-2011 / 21:26:40 / cg"
!

suspendProcess
    "suspend the selected process - interrupts will let it run again"

    self selectedProcessesSend:#suspend
!

terminateAllLikeThis
    "terminate the selected process with all of its subprocesses"

    |names|

    names := Set new.
    self selectedProcessesDo:[:p |
        names add:p name.
    ].

    ProcessorScheduler knownProcesses 
        select:[:p | (names includes:p name) ]
        thenDo:[:eachProcessToTerminate |
        |doTerminateThis|

        doTerminateThis :=
            ((eachProcessToTerminate isSystemProcess not)
            or:[ Dialog confirm:(resources 
                                    string:'Terminate the system process: %1 (Pid=%2)?'
                                    with:eachProcessToTerminate name
                                    with:eachProcessToTerminate id) ]).
                            
        doTerminateThis ifTrue:[
            eachProcessToTerminate terminate
        ].    
    ].
    
    self updateList.
!

terminateProcess
    "terminate the selected process"

    self selectedProcessesSend:#terminate.
    self updateList.
!

terminateProcessGroup
    "terminate the selected process with all of its subprocesses"

    self selectedProcessesSend:#terminateGroup.
    self updateList.
! !

!ProcessMonitorV2 methodsFor:'menu actions-application'!

closeApplication
    "close the process(es) topView(s)"

    self selectedApplicationTopViewsDo:[:topView | topView terminate]

    "Created: / 07-06-2007 / 12:40:20 / cg"
!

lowerApplicationWindow
    "lower the selected process(es) topView(s)"

    self selectedApplicationTopViewsDo:[:topView | topView lower]

    "Created: / 07-06-2007 / 12:43:46 / cg"
!

raiseApplicationWindow
    "raise the selected process(es) topView(s)"

    self selectedApplicationTopViewsDo:[:topView |
        |wg v|

        topView raiseDeiconified.
        wg := topView windowGroup.
        [wg isInModalLoop] whileTrue:[
            wg := wg modalGroup.
            (v := wg mainView) notNil ifTrue:[v raiseDeiconified].
        ].
    ]

    "Created: / 05-06-2007 / 18:37:30 / cg"
    "Modified: / 15-11-2016 / 00:22:22 / cg"
!

selectedApplicationTopViewsDo:aBlock
    self selectedProcessesDo:[:eachProcess |
        |wg|

        wg := self windowGroupOfProcess:eachProcess.
        wg notNil ifTrue:[
            |topView|

            (topView := wg mainView) notNil ifTrue:[
                aBlock value:topView.
            ]
        ]
    ]

    "Created: / 07-06-2007 / 12:42:09 / cg"
    "Modified: / 15-11-2016 / 00:18:37 / cg"
! !

!ProcessMonitorV2 methodsFor:'menu actions-debug'!

browseApplication
    "open a browser on the selected process(es) application or topView"

    self selectedApplicationTopViewsDo:[:topView |
	|app|

	(app := topView application) notNil ifTrue:[
	    app class browse.
	] ifFalse:[
	    topView class browse.
	]
   ]

    "Created: / 07-06-2007 / 12:48:05 / cg"
!

debugProcess
    "open a debugger on the selected process(es)"

    Debugger isNil ifTrue:[ ^ self ].

    self selectedProcessesDo:[:p |
       Debugger openOn:p
    ]

    "Modified: / 07-06-2007 / 12:34:43 / cg"
!

debugWhenResumed
    "open a debugger when the selected process(es) is resumed"

    Debugger isNil ifTrue:[ ^ self ].

    self selectedProcessesDo:[:p |
       p addInterruptAction:[Debugger enter]
    ]

    "Modified: / 07-06-2007 / 12:34:38 / cg"
!

disableInstrumentation
    InstrumentationContext isNil ifTrue:[^ self].

    self selectedProcessesDo:[:p |
       InstrumentationContext setInstrumentationContext:nil in:p
    ]

    "Created: / 17-08-2011 / 11:50:36 / cg"
!

enableInstrumentation
    |context|

    InstrumentationContext isNil ifTrue:[^ self].

    context := InstrumentationContext new.
    self selectedProcessesDo:[:p |
       InstrumentationContext setInstrumentationContext:context in:p
    ]

    "Created: / 17-08-2011 / 11:50:12 / cg"
!

inspectApplication
    "open an inspector on the selected process(es) application or topView"

    self selectedApplicationTopViewsDo:[:topView |
	|app|

	(app := topView application) notNil ifTrue:[
	    app inspect.
	] ifFalse:[
	    topView inspect.
	]
   ]

    "Modified: / 07-06-2007 / 12:46:42 / cg"
!

inspectSelection
    "open an inspector on the selected process"

    self selectedProcessesSend:#inspect
! !

!ProcessMonitorV2 methodsFor:'private queries'!

isApplicationProcess:aProcess
    ^ (self windowGroupOfProcess:aProcess) notNil.
!

windowGroupOfProcess:aProcess
    WindowGroup scheduledWindowGroups
	do:[:eachGroup |
	    (eachGroup process == aProcess) ifTrue:[
		eachGroup isModal ifTrue:[
		    ^ eachGroup previousGroup
		].
		^ eachGroup
	    ]
	].

    ^ nil
! !

!ProcessMonitorV2 methodsFor:'queries - table string'!

getActiveStringFor:aProcess running:isRunning
    |stateCharacter|

    isRunning ifTrue:[
	stateCharacter := '*'.
    ] ifFalse:[
	[
	    (Processor scheduledProcesses includes:aProcess) ifTrue:[
		stateCharacter := '+'
	    ] ifFalse:[
		stateCharacter := ''.
	    ].
	] valueUninterruptably.
    ].
    ^ stateCharacter.
!

getApplicationFor:aProcess
    |wg app|

    wg := self windowGroupOfProcess:aProcess.
    wg notNil ifTrue:[
	(app := wg application) notNil ifTrue:[
	    ^ app.
	].
    ].
    ^ nil.

    "Created: / 17-08-2011 / 11:12:13 / cg"
!

getApplicationStringFor:aProcess
    |app|

    (app := self getApplicationFor:aProcess) notNil ifTrue:[
	^ app class name.
    ].
    ^ ''.

    "Created: / 17-08-2011 / 10:58:50 / cg"
!

getCurrentSegmentStringFor:con
    | contextCount c sender|

    con notNil ifTrue:[
	contextCount := 1.
	c := con.
	[(sender := c sender) notNil] whileTrue:[
	    c := sender.
	    contextCount := contextCount + 1.
	].
	^ (((ObjectMemory addressOf:con) printStringRadix:16),
	   ' .. ',
	   ((ObjectMemory addressOf:c) printStringRadix:16)).
    ].
    ^ ''

    "Modified (format): / 17-08-2011 / 10:57:23 / cg"
!

getGroupStringFor:aProcess
    |gId|

    gId := aProcess processGroupId.
    ((gId == aProcess id) or:[gId isNil]) ifTrue:[
	"/ a group leader
	^ '-'.
    ] ifFalse:[
	^ gId.
    ].

    "Modified (format): / 17-08-2011 / 10:57:33 / cg"
!

getInstrumentationStringFor:aProcess
    ^ (InstrumentationContext forProcess:aProcess) isNil
	ifTrue:['']
	ifFalse:['Y']

    "Created: / 17-08-2011 / 11:04:14 / cg"
!

getPrioStringFor:aProcess
    |prioRange|

    Processor supportDynamicPriorities ifTrue:[
	(prioRange := aProcess priorityRange) isNil ifTrue:[
	    ^ aProcess priority asString.
	] ifFalse:[
	    ^ (aProcess priority asString,
		    ' [',
		    prioRange start printString,
		    '..',
		    prioRange stop printString,
		    ']').
	].
    ].
    ^ ''

    "Modified (format): / 17-08-2011 / 10:57:36 / cg"
!

getTotalStackStringFor:aProcess
    | tStackSize noOfSegs |

    aProcess id == 0 ifTrue:[
	^ 'unlimited'.
    ].
    ((tStackSize := aProcess totalStackSize) notNil
    and:[ (noOfSegs := aProcess numberOfStackSegments) notNil ]) ifTrue:[
	^ (tStackSize printString),' (',(noOfSegs printString),')'
    ].
    ^ ''

    "Modified: / 17-08-2011 / 10:56:17 / cg"
!

getWhereContextFor:con running:isRunning
    "retrieve a reasonable description of where the process is sitting around;
     that is not the last context before the context switch, because that would
     usually be too low level and non-descriptive; instead, walk up the sender chain to
     a higher level waiter, such as a semaphore wait, a shared queue wait etc."

    |c found skipping rs rc r sel|

    con notNil ifTrue:[
	c := con.
	found := false.
	isRunning ifFalse:[
	    "/ search for a semaphore-wait in the top 10 contexts
	    1 to:10 do:[:n |
		found ifFalse:[
		    c notNil ifTrue:[
			(c receiver class == Semaphore) ifTrue:[
			    (sel := c selector) == #wait ifTrue:[
				found := true.
			    ].
			    sel == #waitWithTimeout: ifTrue:[
				found := true.
			    ].
			    sel == #waitWithTimeoutMs: ifTrue:[
				found := true.
			    ].
			].
			c := c sender.
		    ]
		]
	    ].
	].
	found ifFalse:[
	    "/ search for a non-processor, non-process
	    "/ receiver in the top 10 contexts
	    c := con.
	    1 to:10 do:[:n |
		found ifFalse:[
		    c notNil ifTrue:[
			((r := c receiver) ~~ Processor and:[ r class ~~ Process ]) ifTrue:[
			    found := true.
			] ifFalse:[
			    c := c sender.
			]
		    ]
		]
	    ]
	].

	"/ skip, until an interesting context is found.
	"/ This skips intermediate contexts, which lead
	"/ to the sema-wait (for example, unwind blocks, delay-stuff etc.)
	found ifFalse:[
	    c := con
	].
	skipping := true.
	[ skipping ] whileTrue:[
	    skipping := false.
	    (c notNil and:[ (r := c receiver) == Delay or:[ r class == Delay ] ]) ifTrue:[
		c := c sender.
		skipping := true.
	    ].
	    (c notNil and:[ (r := c receiver) == Semaphore or:[ r class == Semaphore ] ]) ifTrue:[
		c := c sender.
		skipping := true.
	    ].
	    [
		c notNil
		    and:[ c receiver isBlock
		    and:[ ((sel := c selector) startsWith:'value')
			  or:[ sel = 'doWhile:'
			  or:[ sel = 'doUntil:'
			  or:[ sel = 'ensure:' ]]]]]
	    ] whileTrue:[
		c := c sender.
		skipping := true.
	    ].
	    [
		c notNil
		    and:[ c receiver == OperatingSystem
		    and:[ c selector == #unblockInterrupts ] ]
	    ] whileTrue:[
		c := c sender.
		skipping := true.
	    ].
	    [
		c notNil
		    and:[ c isBlockContext ]
	    ] whileTrue:[
		c := c home.
		skipping := true.
	    ].
	].
	c notNil ifTrue:[
	    sel := c selector.
	    sel isNil ifTrue:[
		sel := '* unknown *'
	    ].
	    r := c receiver.
	    rc := r class.
	    rs := rc name.
	    (rc == SharedQueue
	    or:[rc == RecursionLock]) ifTrue:[
		rs := rs , ' (', (r identityHash bitShift:-12) hexPrintString,') '.
	    ].
	    ^ (rs , '>>' , sel).
	]
    ].
    ^ ''

    "Created: / 28-02-2012 / 11:48:22 / cg"
!

getWhereStringFor:con running:isRunning
    "retrieve a reasonable description of where the process is sitting around;
     that is not the last context before the context switch, because that would
     usually be too low level and non-descriptive; instead, walk up the sender chain to
     a higher level waiter, such as a semaphore wait, a shared queue wait etc."

    |c found skipping rs rc r sel|

    con notNil ifTrue:[
	c := con.
	found := false.
	isRunning ifFalse:[
	    "/ search for a semaphore-wait in the top 10 contexts
	    1 to:10 do:[:n |
		found ifFalse:[
		    c notNil ifTrue:[
			(c receiver class == Semaphore) ifTrue:[
			    c selector == #wait ifTrue:[
				found := true.
			    ].
			    c selector == #waitWithTimeout: ifTrue:[
				found := true.
			    ].
			    c selector == #waitWithTimeoutMs: ifTrue:[
				found := true.
			    ].
		       ].
			c := c sender.
		    ]
		]
	    ].
	].
	found ifFalse:[
	    "/ search for a non-processor, non-process
	    "/ receiver in the top 10 contexts
	    c := con.
	    1 to:10 do:[:n |
		found ifFalse:[
		    c notNil ifTrue:[
			((r := c receiver) ~~ Processor and:[ r class ~~ Process ]) ifTrue:[
			    found := true.
			] ifFalse:[
			    c := c sender.
			]
		    ]
		]
	    ]
	].

	"/ skip, until an interesting context is found.
	"/ This skips intermediate contexts, which lead
	"/ to the sema-wait (for example, unwind blocks, delay-stuff etc.)
	found ifFalse:[
	    c := con
	].
	skipping := true.
	[ skipping ] whileTrue:[
	    skipping := false.
	    (c notNil and:[ c receiver == Delay or:[ c receiver class == Delay ] ]) ifTrue:[
		c := c sender.
		skipping := true.
	    ].
	    (c notNil and:[ c receiver == Semaphore or:[ c receiver class == Semaphore ] ]) ifTrue:[
		c := c sender.
		skipping := true.
	    ].
	    [
		c notNil
		    and:[ c receiver isBlock
		    and:[ (c selector startsWith:'value')
			  or:[ c selector = 'doWhile:'
			  or:[ c selector = 'doUntil:'
			  or:[ c selector = 'ensure:' ]]]]]
	    ] whileTrue:[
		c := c sender.
		skipping := true.
	    ].
	    [
		c notNil
		    and:[ c receiver == OperatingSystem and:[ c selector == #unblockInterrupts ] ]
	    ] whileTrue:[
		c := c sender.
		skipping := true.
	    ].
	    [
		c notNil and:[ c isBlockContext ]
	    ] whileTrue:[
		c := c home.
		skipping := true.
	    ].
	].
	c notNil ifTrue:[
	    sel := c selector.
	    sel isNil ifTrue:[
		sel := '* unknown *'
	    ].
	    r := c receiver.
	    rc := r class.
	    rs := rc name.
	    (rc == SharedQueue
	    or:[rc == RecursionLock]) ifTrue:[
		rs := rs , ' (', (r identityHash bitShift:-12) hexPrintString,') '.
	    ].
	    ^ (rs , '>>' , sel).
	]
    ].
    ^ ''

    "Modified: / 28-02-2012 / 11:43:30 / cg"
!

getWindowTitleFor:aProcess
    |wg topViews|

    wg := self windowGroupOfProcess:aProcess.
    wg notNil ifTrue:[
        (topViews := wg topViews) notEmptyOrNil ifTrue:[
            ^ '"',(topViews first label ? '<nil>'),'"'.
        ].
    ].
    ^ ''.

    "Created: / 17-08-2011 / 11:01:21 / cg"
! !

!ProcessMonitorV2 methodsFor:'sorting'!

sortProcessListBy:instanceName
    "method to sort the list of BugReport"

    | aSymbol isReverse cmpOp currentSortOrder|

    aSymbol := instanceName asSymbol.
    isReverse := false.
    currentSortOrder := self currentSortOrder value.
    currentSortOrder isEmpty ifTrue:[
	currentSortOrder at:#column put:aSymbol.
	currentSortOrder at:#reverse put:false.
    ] ifFalse:[
	(currentSortOrder at:#column) = aSymbol ifTrue:[
	    "/ same column like before - change sort order ifReverse is true
	    isReverse := currentSortOrder at:#reverse.
	    currentSortOrder at:#reverse put:(isReverse not).
	] ifFalse:[
	    "/ another column - remark column
	    currentSortOrder at:#column put:aSymbol.
	]
    ].
    (currentSortOrder at:#reverse) ifTrue:[
	cmpOp := #'>'
    ] ifFalse:[
	cmpOp := #'<'
    ].
    sortBlock := [:a :b |
	    |entry1 entry2|

	    entry1 := (a perform:aSymbol) ? 0.
	    entry2 := (b perform:aSymbol) ? 0.
	    entry1 = entry2 ifTrue:[
		(a idVal < 0 and:[b idVal < 0]) ifTrue:[
		    "/ two dead ones (take anything which remains constant)
		    a processName ~= b processName ifTrue:[
			a processName < b processName
		    ] ifFalse:[
			a processInstance identityHash < b processInstance identityHash
		    ]
		] ifFalse:[
		    a idVal < b idVal
		]
	    ] ifFalse:[
		entry1 perform:cmpOp with:entry2
	    ]
	].
   self viewedColumnsChanged.
! !

!ProcessMonitorV2 methodsFor:'update process'!

fillItemInformationIn:processItem
    |state stateColor running con aProcess|

    aProcess := processItem processInstance.
    aProcess isNil ifTrue:[
        ^ self.
    ].

    processItem processId:aProcess id.
    processItem idVal:aProcess id ? -1.

    processItem processGroup:(self getGroupStringFor:aProcess).
    processItem groupVal:(processItem processGroup isNumber ifTrue:[processItem processGroup] ifFalse:[-1]).

    processItem processStartTime:aProcess startTimestamp.
    processItem processName:aProcess name ? ''.

    state := aProcess state.
    running := (state == #run and:[aProcess == Processor interruptedProcess]).

    stateColor := (state == #run)
                        ifTrue:[ Color green darkened ]
                        ifFalse:[
                            (state == #debug or:[state == #stopped])
                                ifTrue:[ Color red ]
                                ifFalse:[ Color black ]].

    processItem processState:(state asString withColor:stateColor).
    processItem processActive:(self getActiveStringFor:aProcess running:running).

"/    processItem processBlocked:(aProcess interruptsDisabled).
    processItem prioVal:(aProcess priority).
    processItem processPrio:(self getPrioStringFor:aProcess).

    processItem processUsedStack:aProcess usedStackSize.
    processItem processTotalStack:(self getTotalStackStringFor:aProcess).

    con := aProcess suspendedContext.
    con isNil ifTrue:[
        aProcess == Processor activeProcess ifTrue:[
            con := thisContext
        ]
    ].
    showWhere value ifTrue:[
        processItem processWhere:(self getWhereStringFor:con running:running).
    ].
    processItem processCurrentSegment:(self getCurrentSegmentStringFor:con).
    processItem processSwitch:(aProcess numberOfStackBoundaryHits).
    showApplication value ifTrue:[
        processItem processApplication:(self getApplicationStringFor:aProcess)
    ].
    showWindowTitle value ifTrue:[
        processItem processWindowTitle:(self getWindowTitleFor:aProcess)
    ].
    showInstrumentation value ifTrue:[
        processItem processInstrumentation:(self getInstrumentationStringFor:aProcess)
    ].

    "Modified: / 17-08-2011 / 11:04:32 / cg"
!

fillItemInformationIn:processItem with:aProcess inArray:weakArrayWithProcesses atIndex:processInstanceIndexInWeakArray

    processItem weakArrayWithProcesses:weakArrayWithProcesses.
    processItem processInstanceIndexInWeakArray:processInstanceIndexInWeakArray.
    self fillItemInformationIn:processItem
!

startUpdateProcess
    updateBlock notNil ifTrue:[
        Processor addTimedBlock:updateBlock afterSeconds:updateDelay.
        Processor addTimedBlock:listUpdateBlock afterSeconds:listUpdateDelay.
    ] ifFalse:[
        "after a restart, updateProcess is a dead process"
        self assert:(updateProcess isNil or:[updateProcess isDead]).

        updateProcess := [
            [
                |id cnt myDelay|

                myDelay := Delay forSeconds:updateDelay.

                "
                 every updateDelay (0.5), we look which process runs;
                 every half second, the status is updated.
                 every listUpdateDelay (5s), the list of processes is
                 built up again
                "
                [true] whileTrue:[
                    myDelay delay:updateDelay * 1000.
                    ((listUpdateDelay // updateDelay) max:2) - 1 timesRepeat:[
                        myDelay wait.
                        self updateStatus:nil.
                    ].
                    myDelay wait.
                    self updateList.
                ]
            ] ifCurtailed:[
                updateProcess := nil
            ]
        ]  forkAt:(Processor userSchedulingPriority + 1).
        updateProcess name:'monitor [' ,
                           Processor activeProcess id printString ,
                           '] update'.
        "
         raise my own priority
        "
        Processor activeProcess priority:(Processor userSchedulingPriority + 2)
    ].
!

updateChangedItem:oldItem newItem:newItem atIndex:index
    | colIdx newValue |

    colIdx := 1.

    oldItem weakArrayWithProcesses:newItem weakArrayWithProcesses.
    oldItem processInstanceIndexInWeakArray:newItem processInstanceIndexInWeakArray.

    "/ ID

    oldItem processId ~= (newValue := newItem processId) ifTrue:[
	oldItem processId:newValue.
	processTable invalidateRowAt:index colAt:colIdx.
    ].

    #(
	( showGroup     processGroup        processGroup: )
	( true          processName         processName: )
	( showInstrumentation     processInstrumentation        processInstrumentation: )
	( true          processActive       processActive: )
	( showState     processState        processState: )
	( showPrio      processPrio         processPrio: )
	( showUsedStack processUsedStack    processUsedStack: )
	( showTotalStack processTotalStack  processTotalStack: )
	( showCurrentSegment processCurrentSegment processCurrentSegment: )
	( showSwitch    processSwitch       processSwitch: )
	( showWhere     processWhere        processWhere: )
	( showApplication     processApplication        processApplication: )
	( showWindowTitle     processWindowTitle        processWindowTitle: )

    ) do:[:eachAspect |
	|showHolder showHolderValue colValueGetter colValueSetter|

	showHolder := eachAspect at:1.
	colValueGetter := eachAspect at:2.
	colValueSetter := eachAspect at:3.

	showHolderValue := (showHolder == true) or:[ (self perform:showHolder) value ].
	showHolderValue ifTrue:[
	    colIdx := colIdx + 1.
	    (oldItem perform:colValueGetter) ~= (newValue := (newItem perform:colValueGetter)) ifTrue:[
		oldItem perform:colValueSetter with:newValue.
		processTable invalidateRowAt:index colAt:colIdx.
	    ].
	].
    ].

"/    "/ GROUP
"/    self showGroup value ifTrue:[
"/        colIdx := colIdx + 1.
"/        oldItem processGroup ~= (newValue := newItem processGroup) ifTrue:[
"/            oldItem processGroup:newValue.
"/            processTable invalidateRowAt:index colAt:colIdx.
"/        ].
"/    ].

"/    "/ NAME
"/    colIdx := colIdx + 1.
"/    oldItem processName ~= (newValue := newItem processName) ifTrue:[
"/        oldItem processName:newValue.
"/        processTable invalidateRowAt:index colAt:colIdx.
"/    ].

"/    "/ ACTIVE
"/    colIdx := colIdx + 1.
"/    oldItem processActive ~= (newValue := newItem processActive) ifTrue:[
"/        oldItem processActive:newValue.
"/        "/ (processTable columnAt:colIdx).
"/        processTable invalidateRowAt:index colAt:colIdx.
"/    ].

"/    "/ STATE
"/    showState value ifTrue:[
"/        colIdx := colIdx + 1.
"/        (oldItem processState sameStringAndEmphasisAs: (newValue := newItem processState)) ifFalse:[
"/            oldItem processState:newValue.
"/            processTable invalidateRowAt:index colAt:colIdx.
"/        ].
"/    ].

"/    "/ PRIO
"/    showPrio value ifTrue:[
"/        colIdx := colIdx + 1.
"/        oldItem processPrio ~= (newValue := newItem processPrio) ifTrue:[
"/            oldItem processPrio:newValue.
"/            processTable invalidateRowAt:index colAt:colIdx.
"/        ].
"/    ].

"/    "/ USED STACK
"/    showUsedStack value ifTrue:[
"/        colIdx := colIdx + 1.
"/        oldItem processUsedStack ~= (newValue := newItem processUsedStack) ifTrue:[
"/            oldItem processUsedStack:newValue.
"/            processTable invalidateRowAt:index colAt:colIdx.
"/        ].
"/    ].

"/    "/ TOTAL STACK
"/    showTotalStack value ifTrue:[
"/        colIdx := colIdx + 1.
"/        oldItem processTotalStack ~= (newValue := newItem processTotalStack) ifTrue:[
"/            oldItem processTotalStack:newValue.
"/            processTable invalidateRowAt:index colAt:colIdx.
"/        ].
"/    ].

"/    "/ CURRENT SEGMENT
"/    showCurrentSegment value ifTrue:[
"/        colIdx := colIdx + 1.
"/        oldItem processCurrentSegment ~= (newValue := newItem processCurrentSegment) ifTrue:[
"/            oldItem processCurrentSegment:newValue.
"/            processTable invalidateRowAt:index colAt:colIdx.
"/        ].
"/    ].

"/    "/ Switch
"/    showSwitch value ifTrue:[
"/        colIdx := colIdx + 1.
"/        oldItem processSwitch ~= (newValue := newItem processSwitch) ifTrue:[
"/            oldItem processSwitch:newValue.
"/            processTable invalidateRowAt:index colAt:colIdx.
"/        ].
"/    ].

"/    "/ WHERE
"/    showWhere value ifTrue:[
"/        colIdx := colIdx + 1.
"/        oldItem processWhere ~= (newValue := newItem processWhere) ifTrue:[
"/            oldItem processWhere:newValue.
"/            processTable invalidateRowAt:index colAt:colIdx.
"/        ].
"/    ].

    "Modified: / 17-08-2011 / 11:47:01 / cg"
!

updateList
    "recompute the list of processes"
    
    |newList|

    processTable shown ifTrue:[
        newList := self getProcessList.
        visibleBlock notNil ifTrue:[
            newList := newList select:visibleBlock
        ].
        self updateStatus:newList.
    ].
    updateBlock notNil ifTrue:[
        Processor removeTimedBlock:listUpdateBlock.
        Processor addTimedBlock:listUpdateBlock afterSeconds:listUpdateDelay
    ].
!

updateStatus:newProcessList
    |startTime endTime deltaT|

    startTime := Timestamp now.
    updateSema critical:[
        self updateTable:newProcessList.
    ].

    endTime := Timestamp now.

    lastUpdateTimestamp notNil ifTrue:[
        |timeDelta newInterruptCount newTimerActionCount n nPerSecond s|

        timeDelta := (endTime - lastUpdateTimestamp) asMilliseconds / 1000.0.
        
        "/ update the interrupt counts
        newInterruptCount := Processor interruptCounter.
        newTimerActionCount := Processor timedActionCounter.
        lastInterruptCount notNil ifTrue:[
            "/ attention - these are modulu counters.
            newInterruptCount >= lastInterruptCount ifTrue:[
                n := newInterruptCount-lastInterruptCount.
                n == 0 ifTrue:[
                    "/ the common case
                    s := '0'
                ] ifFalse:[
                    nPerSecond := n / timeDelta. 
                    s := (nPerSecond asInteger "asFixedPoint:1") printString
                ].    
                self interruptCountHolder value:s
            ].    
        ].
        lastTimerActionCount notNil ifTrue:[
            "/ attention - these are modulu counters.
            newTimerActionCount >= lastTimerActionCount ifTrue:[
                n := newTimerActionCount-lastTimerActionCount.
                n == 0 ifTrue:[
                    "/ the common case
                    s := '0'
                ] ifFalse:[
                    nPerSecond := n / timeDelta.
                    s := (nPerSecond asInteger "asFixedPoint:1") printString
                ].    
                self timerActionCountHolder value:s
            ].    
        ].
        
        lastInterruptCount := newInterruptCount.
        lastTimerActionCount := newTimerActionCount.
    ].
    lastUpdateTimestamp := endTime.
    
    "/ a check, in case the computation took longer than 20%
    "/ of the delay time. Then increase the update interval.
    "/ This is to avoid that the processMonitor creates too much overhead
    "/ (in case we have many processes)
    deltaT := (endTime millisecondDeltaFrom:startTime) / 1000.0.
    "/ Transcript show:deltaT; show:' ' ; showCR:(self scaledUpdateContentsDelayTime / 10.0).
    deltaT > (updateDelay / 5) ifTrue:[
        "/ the update took longer than 20% - make delay longer, to reduce cpu load.
        updateDelay := updateDelay * 2.
        self updateContentsDelayTimeHolder value:updateDelay.
        "/ Transcript show:'+++ '; showCR:self scaledUpdateContentsDelayTime.
    ].
    
    updateBlock notNil ifTrue:[
        Processor removeTimedBlock:updateBlock.
        Processor addTimedBlock:updateBlock afterSeconds:updateDelay.
    ]
!

updateTable:newProcessList
    |oldSelection newList sel diff weakProcessList showDead|

    processTable shown ifFalse:[^ self].

    showDead := self showDeadHolder value.
    
    "/ Transcript showCR:('update the table', Timestamp now printString, 'with new list:', newProcessList notNil asString).
    sel := self selectedProcesses value.
    sel notNil ifTrue:[
        oldSelection := OrderedCollection new.
        sel do:[:proItem|
            proItem processInstance notNil ifTrue:[
                oldSelection add:(proItem processInstance)
            ].
        ].
    ].
    
    newList := OrderedCollection new.

    "/ Transcript showCR:'oldSelection on catch in updateTable: ', (oldSelection isEmptyOrNil ifTrue:['nil'] ifFalse:[oldSelection first printString]).
    newProcessList isNil ifTrue:[
        processList do:[:oldItem |
            | newItem process|
            (showDead
             or:[ 
                (process := oldItem processInstance) notNil
                 and:[process isDead not]]
            ) ifTrue:[
                newItem := oldItem copy.
                self fillItemInformationIn:newItem.
                newList add:newItem.
            ]
        ].
    ] ifFalse:[
        "/ remove dead processes if not shown
        weakProcessList := WeakArray withAll:newProcessList.
        weakProcessList keysAndValuesDo:[:indexInWeakArray :procOrNilOrZero |
            "/ in a weakarray, dead entries are 0
            (procOrNilOrZero notNil and:[procOrNilOrZero class ~~ SmallInteger]) ifTrue:[
                (procOrNilOrZero isDead not or:[showDead]) ifTrue:[
                    | processItem |
                    processItem := ProcessItem new.
                    self fillItemInformationIn:processItem with:procOrNilOrZero inArray:weakProcessList atIndex:indexInWeakArray.
                    newList add:processItem.
                ]
            ]
        ].
    ].
    newList sort:self sortBlock.
    newList doWithIndex:[:newItem :index|
        | oldItem |
        oldItem := processList at:index ifAbsent:nil.
        oldItem isNil ifTrue:[
            processList add:newItem beforeIndex:index
        ] ifFalse:[
            self updateChangedItem:oldItem newItem:newItem atIndex:index
        ]
    ].
    diff := processList size - newList size.
    diff > 0 ifTrue:[
        processList removeLast:diff
    ].
"/            Transcript showCR:'oldSelection on set in updateTable: ', (oldSelection isEmptyOrNil ifTrue:['nil'] ifFalse:[oldSelection first printString]).
    self changeSelectionToProcesses:oldSelection.
! !

!ProcessMonitorV2::ProcessItem methodsFor:'accessing'!

groupVal
    "return the value of the instance variable 'groupVal' (automatically generated)"

    ^ groupVal
!

groupVal:something
    "set the value of the instance variable 'groupVal' (automatically generated)"

    groupVal := something.
!

idVal
    "return the value of the instance variable 'idVal' (automatically generated)"

    ^ idVal
!

idVal:something
    "set the value of the instance variable 'idVal' (automatically generated)"

    idVal := something.
!

prioVal
    "return the value of the instance variable 'prioVal' (automatically generated)"

    ^ prioVal
!

prioVal:something
    "set the value of the instance variable 'prioVal' (automatically generated)"

    prioVal := something.
!

processActive
    "return the value of the instance variable 'processActive' (automatically generated)"

    ^ processActive
!

processActive:something
    "set the value of the instance variable 'processActive' (automatically generated)"

    processActive := something.
!

processApplication
    ^ processApplication
!

processApplication:something
    processApplication := something.
!

processBlocked
    ^ processBlocked

    "Created: / 18-07-2010 / 23:52:26 / cg"
!

processBlocked:aBoolean
    processBlocked := aBoolean.

    "Created: / 18-07-2010 / 23:52:41 / cg"
!

processCurrentSegment
    "return the value of the instance variable 'processCurrentSegment' (automatically generated)"

    ^ processCurrentSegment
!

processCurrentSegment:something
    "set the value of the instance variable 'processCurrentSegment' (automatically generated)"

    processCurrentSegment := something.
!

processGroup
    "return the value of the instance variable 'processGroup' (automatically generated)"

    ^ processGroup
!

processGroup:something
    "set the value of the instance variable 'processGroup' (automatically generated)"

    processGroup := something.
!

processId
    "return the value of the instance variable 'processId' (automatically generated)"

    ^ processId
!

processId:something
    "set the value of the instance variable 'processId' (automatically generated)"

    processId := something.
!

processInstance
    "return the value of the instance variable 'processInstance' (automatically generated)"

    |procOrNilOrZero|

    procOrNilOrZero := weakArrayWithProcesses at:processInstanceIndexInWeakArray.
    procOrNilOrZero class == SmallInteger ifTrue:[^ nil].
    ^ procOrNilOrZero
!

processInstance:something
    "set the value of the instance variable 'processInstance' (automatically generated)"

    processInstance := something.
!

processInstanceIndexInWeakArray
    "return the value of the instance variable 'processInstanceIndexInWeakArray' (automatically generated)"

    ^ processInstanceIndexInWeakArray
!

processInstanceIndexInWeakArray:something
    "set the value of the instance variable 'processInstanceIndexInWeakArray' (automatically generated)"

    processInstanceIndexInWeakArray := something.
!

processInstrumentation
    ^ processInstrumentation
!

processInstrumentation:something
    processInstrumentation := something.
!

processName
    "return the value of the instance variable 'processName' (automatically generated)"

    ^ processName
!

processName:something
    "set the value of the instance variable 'processName' (automatically generated)"

    processName := something.
!

processPrio
    "return the value of the instance variable 'processPrio' (automatically generated)"

    ^ processPrio
!

processPrio:something
    processPrio := something.
!

processStartTime
    "return the value of the instance variable 'startTime' (automatically generated)"

    ^ startTimestamp
!

processStartTime:aTimestamp
    "set the value of the instance variable 'startTime' (automatically generated)"

    startTimestamp := aTimestamp
!

processState
    ^ processState
!

processState:something
    processState := something.
!

processSwitch
    ^ processSwitch
!

processSwitch:something
    processSwitch := something.
!

processTotalStack
    ^ processTotalStack
!

processTotalStack:something
    processTotalStack := something.
!

processUsedStack
    ^ processUsedStack
!

processUsedStack:something
    processUsedStack := something.
!

processWhere
    ^ processWhere
!

processWhere:something
    processWhere := something.
!

processWindowTitle
    ^ processWindowTitle
!

processWindowTitle:something
    processWindowTitle := something.
!

weakArrayWithProcesses
    ^ weakArrayWithProcesses
!

weakArrayWithProcesses:something
    weakArrayWithProcesses := something.
! !

!ProcessMonitorV2::ProcessItem methodsFor:'printing'!

printOn:aStream
    (self processName ? '') printOn:aStream.
    aStream nextPut:$[.
    (self processId ? '') printOn:aStream.
    aStream nextPut:$].
! !

!ProcessMonitorV2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

