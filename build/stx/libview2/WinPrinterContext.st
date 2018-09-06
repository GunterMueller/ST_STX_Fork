"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

PrinterContext subclass:#WinPrinterContext
	instanceVariableNames:'deviceFonts hatch supportsColor title'
	classVariableNames:'PostScriptBlackWhite'
	poolDictionaries:''
	category:'Interface-Printing'
!

WinPrinterContext subclass:#WinPrinterGraphicContext
	instanceVariableNames:'fontScale printPageNumbers pageNumberFormat pageCounter
		needsEndOfPage titleFont width height'
	classVariableNames:''
	poolDictionaries:''
	privateIn:WinPrinterContext
!

!WinPrinterContext primitiveDefinitions!
%{
#undef INT
#define INT WIN_INT
#undef Array
#define Array WIN_Array
#undef Number
#define Number WIN_Number
#undef Method
#define Method WIN_Method
#undef Point
#define Point WIN_Point
#undef Rectangle
/* #define Rectangle WIN_Rectangle */
#undef True
#define True WIN_True
#undef False
#define False WIN_False
#undef Block
#define Block WIN_Block
#undef Context
#define Context WIN_Context
#undef Date
#define Date WIN_Date
#undef Time
#define Time WIN_Time
#undef Delay
#define Delay WIN_Delay
#undef Signal
#define Signal WIN_Signal
#undef Set
#define Set WIN_Set
#undef Process
#define Process WIN_Process
#undef Processor
#define Processor WIN_Processor
#undef Message
#define Message WIN_Message
#undef String
#define String WIN_String
#undef Character
#define Character WIN_Character

#include <stdio.h>
#include <errno.h>

#ifdef __BORLANDC__
# define NOATOM
# define NOGDICAPMASKS
# define NOMETAFILE
# define NOMINMAX
# define NOOPENFILE
# define NOSOUND
# define NOWH
# define NOCOMM
# define NOKANJI
# define NOCRYPT
# define NOMCX
# define WIN32_LEAN_AND_MEAN
# include <windows.h>
# include <shellapi.h>
# include <sys\timeb.h>
# include <dir.h>
#else
# define _USERENTRY /**/
# define NOATOM
# define NOGDICAPMASKS
# define NOMETAFILE
# define NOMINMAX
# define NOOPENFILE
# define NOSOUND
# define NOWH
# define NOCOMM
# define NOKANJI
# define NOCRYPT
# define NOMCX
# define WIN32_LEAN_AND_MEAN
# include <windows.h>
# include <sys\timeb.h>
#endif

#include <process.h>

#ifdef __DEF_Array
# undef Array
# define Array __DEF_Array
#endif
#ifdef __DEF_Number
# undef Number
# define Number __DEF_Number
#endif
#ifdef __DEF_Method
# undef Method
# define Method __DEF_Method
#endif
#ifdef __DEF_Point
# undef Point
# define Point __DEF_Point
#endif
#ifdef __DEF_Rectangle
# undef Rectangle
# define Rectangle __DEF_Rectangle
#else
# undef Rectangle
#endif
#ifdef __DEF_Block
# undef Block
# define Block __DEF_Block
#endif
#ifdef __DEF_Context
# undef Context
# define Context __DEF_Context
#endif
#ifdef __DEF_Date
# undef Date
# define Date __DEF_Date
#endif
#ifdef __DEF_Time
# undef Time
# define Time __DEF_Time
#endif
# ifdef __DEF_Set
#  undef Set
#  define Set __DEF_Set
# endif
# ifdef __DEF_Signal
#  undef Signal
#  define Signal __DEF_Signal
# endif
# ifdef __DEF_Delay
#  undef Delay
#  define Delay __DEF_Delay
# endif
# ifdef __DEF_Process
#  undef Process
#  define Process __DEF_Process
# endif
# ifdef __DEF_Processor
#  undef Processor
#  define Processor __DEF_Processor
# endif
# ifdef __DEF_Message
#  undef Message
#  define Message __DEF_Message
# endif
# ifdef __DEF_String
#  undef String
#  define String __DEF_String
# endif
# ifdef __DEF_Character
#  undef Character
#  define Character __DEF_Character
# endif

#undef INT
#define INT STX_INT
#undef UINT
#define UINT STX_UINT

/*
 * some defines - tired of typing ...
 */
#define _HANDLEVal(o)        (HANDLE)(__MKCP(o))
#define _HBITMAPVAL(o)       (HBITMAP)(__MKCP(o))
#define _HWNDVal(o)          (HWND)(__MKCP(o))
#define _HPALETTEVal(o)      (HPALETTE)(__MKCP(o))
#define _HCURSORVal(o)       (HCURSOR)(__MKCP(o))
#define _HGDIOBJVal(o)       (HGDIOBJ)(__MKCP(o))
#define _LOGPALETTEVal(o)    (LOGPALETTE *)(__MKCP(o))
#define _COLORREFVal(o)      (COLORREF)(__MKCP(o))

#define WIDECHAR unsigned short

#define WIN32PADDING 32

#ifdef DEBUG
# define DPRINTF(x)              /* printf  x */
# define DFPRINTF(x)             /* fprintf x */
#else
# define DPRINTF(x)              /* */
# define DFPRINTF(x)             /* */
#endif

typedef int (*intf)(int);
typedef INT (*INTF)(INT);

/* PS_JOIN_MASK is missing from the mingw32 headers */
#ifndef PS_JOIN_MASK
# define PS_JOIN_MASK (PS_JOIN_BEVEL|PS_JOIN_MITER|PS_JOIN_ROUND)
#endif
%}
! !

!WinPrinterContext class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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
    I am the mediator between the smalltalk printing protocol
    (which is the same as the graphics drawing protocol) and the
    windows printer.
    When you open a printer, you will typically talk to me.

    [author:]
	Felix Madrid (fm@exept.de)
"
! !

!WinPrinterContext class methodsFor:'instance creation'!

fromPrinterInfo: aPrinterInfo
    | printerContext printerDevice hDC|

    hDC := aPrinterInfo createDC.
    hDC = 0 ifTrue: [ ^self error: 'Error while opening printer.' ].

    printerContext := self new.

    printerDevice := printerContext.
"/    printerDevice := WinPrinter on: aPrinterInfo.
"/    printerDevice printerDC:hDC.

    printerContext printerInfo: aPrinterInfo.
    printerContext setDevice:printerDevice id:nil gcId:hDC.
    printerContext initExtent.
    ^printerContext

    "Created: / 03-08-2006 / 12:53:52 / fm"
    "Modified: / 04-08-2006 / 12:55:01 / fm"
    "Modified: / 16-04-2007 / 12:36:26 / cg"
!

newPrinter

    | printer printerInfo|

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].
    printer := self fromPrinterInfo: printerInfo.
    ^ printer
!

openGraphicContext
    ^ self openGraphicContextWithoutDialog:false
!

openGraphicContextWithoutDialog:withoutDialog
    ^ self openGraphicContextWithoutDialog:withoutDialog jobName:nil
!

openGraphicContextWithoutDialog:withoutDialog jobName:jobName
    |printerInfo gc|

    printerInfo := PrintingDialog getPrinterInfoWithoutDialog:withoutDialog.
    printerInfo isNil ifTrue:[^ nil].
    gc := WinPrinterGraphicContext fromPrinterInfo:printerInfo.

    gc notNil ifTrue:[
	gc startPrintJob:jobName
    ].
    ^ gc
! !

!WinPrinterContext class methodsFor:'accessing'!

getPrinterInformation:printerNameString
    " Answer the printer information for the printer named printerNameString.  If no name is specified,
      answer the information for the default printer."

    |h|

    h := OperatingSystem openPrinter:printerNameString.
    ^ OperatingSystem
	getDocumentProperties:nil
	hPrinter:h
	pDeviceName:printerNameString.

    "Created: / 27-07-2006 / 10:22:32 / fm"
    "Modified: / 01-08-2006 / 16:01:44 / fm"
    "Modified: / 10-10-2006 / 18:57:45 / cg"
!

getPrinterInformationString: printerNameString
	" Answer the printer information string from the WIN.INI file
	for the printer named printerNameString.  If no name is specified,
	answer the information for the default printer. "
    | printerInfo result |
    printerInfo := ( String new: 80 ).
    result := OperatingSystem primGetProfileString: 'windows'
	keyName:  'device'
	default: ( printerNameString isNil ifTrue: [ '' ] ifFalse: [ printerNameString ] )
	returnedString: printerInfo
	size: printerInfo size.
    ^result > 0
	ifTrue: [printerInfo copyFrom: 1 to: result]
	ifFalse: ['']
!

named: aName
    "Answer a new instance of Printer which represents
     the printer named aName as specified in the host
     Control Panel."

    aName isNil ifTrue: [ ^self default ].
    ^self new printerInfoWithName: aName

    "Created: / 27-07-2006 / 17:51:27 / fm"
    "Modified: / 02-08-2006 / 17:26:29 / fm"
    "Modified: / 10-10-2006 / 17:33:29 / cg"
!

postScriptBlackWhite
    "Returns true if the postscript is b&w or returns false if the postscript is color"

    ^ PostScriptBlackWhite ? false
!

postScriptBlackWhite: aBoolean

    PostScriptBlackWhite := aBoolean
! !

!WinPrinterContext class methodsFor:'not supported yet'!

printAdvancedLines: pairOfPointsArray
    "Opens a print dialog and prints the given lines"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Advanced Lines'.
	printer foreground:Color red background:Color white.
	pairOfPointsArray
	    do:[:pairOfPointsAndContext |
		 |pairOfPoints|
		 pairOfPoints := pairOfPointsAndContext at:1.
		 printer
		    lineWidth: (pairOfPointsAndContext at:2);
		    lineStyle: (pairOfPointsAndContext at:3);
		    capStyle: (pairOfPointsAndContext at:4);
		    joinStyle: (pairOfPointsAndContext at:5);
		    foreground: (pairOfPointsAndContext at:6);

		    displayAdvanceLineFrom: (pairOfPoints at:1)  to: (pairOfPoints at:2).
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext printAdvancedLines:
	(Array with: (Array with: (Array with:10@10 with:1000@5000) with: 3 with:#dashed with: #butt with: #miter with: Color green)
	       with: (Array with: (Array with:10@10 with:3500@2000) with: 2 with:#solid  with: #butt with: #miter with: Color yellow)
	       with: (Array with: (Array with:1000@800 with:6000@5000) with: 8 with:#dashed  with: #butt with: #miter with: Color black)
	       with: (Array with: (Array with:2000@2800 with:2000@5000) with: 1 with:#dashed  with: #butt with: #miter with: Color red)
	)
    "

    "Created: / 07-08-2006 / 12:09:48 / fm"
    "Modified: / 07-08-2006 / 14:11:17 / fm"
    "Modified: / 16-04-2007 / 15:37:41 / cg"
! !

!WinPrinterContext class methodsFor:'testing'!

computeScaleForPrinter:aPrinter
    ^ Point x:(aPrinter pixelsPerInchOfScreenWidth / Screen current horizontalPixelPerInch)
	    y:(aPrinter pixelsPerInchOfScreenHeight / Screen current verticalPixelPerInch)
!

testPrintingDo:anOneArgBlock

    "Opens a print dialog and invokes the action with the printer"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.

    printer startPrintJob: 'Testing'.
    anOneArgBlock value:printer.
    printer endPrintJob.


"
self testPrintingDo:[:aPrinter| |icon|
    aPrinter scale:(self computeScaleForPrinter:aPrinter).

    aPrinter displayLineFrom:10@10   to:100@10.
    aPrinter displayLineFrom:100@10  to:100@100.
    aPrinter displayLineFrom:100@100 to:10@100.
    aPrinter displayLineFrom:10@100  to:10@10.

    icon := XPToolbarIconLibrary eraseXP28x28Icon.
    icon displayOn:aPrinter x:10 y:10.

].

self testPrintingDo:[:aPrinter| |scale|
    scale := self computeScaleForPrinter:aPrinter.
    aPrinter scale:(1 * scale).

    aPrinter  font:(Font family:'Arial' face:'medium' size:8).
    aPrinter displayLineFrom:8@16 to:100@16.
    aPrinter displayLineFrom:8@16 to:8@128.

    'hallo' displayOn:aPrinter x:8 y:16.
    aPrinter scale:(2 * scale).
    'hallo' displayOn:aPrinter x:4 y:32.

    aPrinter scale:(4 * scale).
    'hallo' displayOn:aPrinter x:2 y:32.
].
"
! !

!WinPrinterContext class methodsFor:'testing & examples'!

fillCircles: arrayOfPointsAndRadiusWithContextArray
    "Opens a print dialog and prints the given circles"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Fill Circles'.
	arrayOfPointsAndRadiusWithContextArray
	    do:[:pointsAndRadiusWithContextArray |
		printer foreground:(pointsAndRadiusWithContextArray at:3).
		printer fillCircle:(pointsAndRadiusWithContextArray at:1)
			radius:(pointsAndRadiusWithContextArray at:2).
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext fillCircles:
	(Array with: (Array with: 800@800 with: 600 with:Color red)
	       with: (Array with: 1500@1500 with: 1000 with:Color blue)
	       with: (Array with: 4000@2500 with: 2000 with:Color gray))
    "

    "Created: / 07-08-2006 / 11:46:52 / fm"
    "Modified: / 16-04-2007 / 15:37:34 / cg"
!

fillHatchCircles: arrayOfPointsAndRadiusWithContextArray
    "Opens a print dialog and prints the given circles"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Fill Hatch Circles'.
	arrayOfPointsAndRadiusWithContextArray
	    do:[:pointsAndRadiusWithContextArray |
		| point radius color hatch|
		point := (pointsAndRadiusWithContextArray at:1).
		radius := (pointsAndRadiusWithContextArray at:2).
		color := (pointsAndRadiusWithContextArray at:3).
		hatch := (pointsAndRadiusWithContextArray at:4).
		printer foreground: color;
			hatch: hatch.
		printer fillCircle:point
			radius:radius.
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext fillHatchCircles:
	(Array with: (Array with: 800@800 with: 600 with:Color red with: #diagonalCross)
	       with: (Array with: 1500@1500 with: 1000 with:Color blue with: #vertical)
	       with: (Array with: 4000@2500 with: 2000 with:Color gray with: #bDiagonal))
    "

    "Created: / 07-08-2006 / 11:46:52 / fm"
    "Modified: / 16-04-2007 / 15:37:34 / cg"
!

fillHatchPolygons: polygonsWithContextArray
    "Opens a print dialog and prints the given polygons"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Fill Hatch Polygons'.
	polygonsWithContextArray
	    do:[:polygonWithContextArray |
		 |aPolygon color hatch|
		 aPolygon := polygonWithContextArray at: 1.
		 color := (polygonWithContextArray at: 2).
		 hatch := (polygonWithContextArray at: 3).
		 printer foreground: color;
			 hatch: hatch.
		 aPolygon displayFilledOn: printer.
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext fillHatchPolygons:
	(Array with: (Array with: (Polygon vertices:(
				Array
				    with:100@100
				    with:600@1000
				    with:3500@4000
				    with:100@4000
				    with:100@100))
			    with: Color red
			    with: #cross)
		with: (Array with: (Polygon vertices:(
				Array
				    with:1000@1000
				    with:1000@2000
				    with:2000@1000))
			     with: Color blue
			     with: #none)
    )
    "

    "Created: / 07-08-2006 / 12:09:48 / fm"
    "Modified: / 07-08-2006 / 14:11:17 / fm"
    "Modified: / 16-04-2007 / 15:37:43 / cg"
!

fillHatchRectangles: rectanglesWithHatch
    "Opens a print dialog and prints the given rectangles"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Fill Hatch Rectangles'.
	printer foreground:Color blue background:Color white.
	rectanglesWithHatch
	    do:[:rectangleWithHatch |
		|rectangle hatch|
		rectangle := rectangleWithHatch at: 1.
		hatch := rectangleWithHatch at: 2.
		printer hatch: hatch.
		printer fillRectangleX: rectangle origin x
			y: rectangle origin y
			width: rectangle width
			height: rectangle height.
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext fillHatchRectangles:
	(Array with: (Array with: (Rectangle left:20 top:20 width:400 height:600) with: #horizontal)
	       with: (Array with: (Rectangle left:500 top:700 width:600 height:400) with: #vertical)
	       with: (Array with: (Rectangle left:800 top:1000 width:1600 height:2000) with: #cross)
	       with: (Array with: (Rectangle left:1040 top:1240 width:3000 height:3000) with: #bDiagonal)
	)
    "

    "Created: / 07-08-2006 / 11:40:48 / fm"
    "Modified: / 16-04-2007 / 15:37:46 / cg"
!

fillPolygons: polygonsWithContextArray
    "Opens a print dialog and prints the given polygons"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Fill Polygons'.
	polygonsWithContextArray
	    do:[:polygonWithContextArray |
		 |aPolygon|
		 aPolygon := polygonWithContextArray at: 1.
		 printer foreground:(polygonWithContextArray at: 2).
		 aPolygon displayFilledOn: printer.
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext fillPolygons:
	(Array with: (Array with: (Polygon vertices:(
				Array
				    with:100@100
				    with:600@1000
				    with:3500@4000
				    with:100@4000
				    with:100@100))
			    with: Color red)
		with: (Array with: (Polygon vertices:(
				Array
				    with:1000@1000
				    with:1000@2000
				    with:2000@1000))
			     with: Color blue)
    )
    "

    "Created: / 07-08-2006 / 12:09:48 / fm"
    "Modified: / 07-08-2006 / 14:11:17 / fm"
    "Modified: / 16-04-2007 / 15:37:43 / cg"
!

fillRectangles: rectangles
    "Opens a print dialog and prints the given rectangles"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Fill Rectangles'.
	printer foreground:Color blue background:Color white.
	rectangles
	    do:[:rectangle |
		printer fillRectangleX: rectangle origin x
			y: rectangle origin y
			width: rectangle width
			height: rectangle height.
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext fillRectangles:
	(Array with: (Rectangle left:20 top:20 width:400 height:600)
	       with: (Rectangle left:500 top:700 width:600 height:400)
	       with: (Rectangle left:800 top:1000 width:1600 height:2000)
	       with: (Rectangle left:1040 top:1240 width:3000 height:3000)
	)
    "

    "Created: / 07-08-2006 / 11:40:48 / fm"
    "Modified: / 16-04-2007 / 15:37:46 / cg"
!

print: aString font: aFont title: aTitle
    "Open a print dialog to allow printing of the given string
     using the given title & font."

    self print: aString font: aFont title: aTitle wordWrap: false

   "
    WinPrinterContext print: 'Holaaaa!! (from:  WinPrinterContext>>print:aString font:aFont title:aTitle)' font: nil title: 'Printing Test'
    WinPrinterContext print: (WinPrinterContext class sourceCodeAt:#'print:font:title:wordWrap:') font: nil title: 'Printing Test String'
    WinPrinterContext print: (WinPrinterContext class sourceCodeAt:#'print:font:title:wordWrap:') font: (Font family:'Arial' face:'medium' size:8) title: 'Printing Test String'
   "

    "Created: / 27-07-2006 / 17:52:33 / fm"
    "Modified: / 03-08-2006 / 18:52:31 / fm"
    "Modified: / 16-04-2007 / 13:54:40 / cg"
!

print: aString font: aFont title: aTitle wordWrap: wordWrap
    "Open a print dialog to allow printing of the given string
     using the given title & font."

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer
	    print: aString
	    font: aFont
	    title: aTitle
	    wordWrap: wordWrap
	    marginsRect: nil
    ] forkAt: 3

    "
     WinPrinterContext print: 'Holaaaa!! (from:  PrinterContext>>print:aString font:aFont title:aTitle)' font: nil title: 'Printing Test' wordWrap: true
     WinPrinterContext print: (WinPrinterContext class sourceCodeAt:#'print:font:title:wordWrap:') font:nil title:'Printing Test String' wordWrap:true
     WinPrinterContext print: (WinPrinterContext class sourceCodeAt:#'print:font:title:wordWrap:') font: (Font family:'Arial' face:'medium' size:8) title: 'Printing Test String' wordWrap: true
    "

    "Created: / 03-08-2006 / 18:51:53 / fm"
    "Modified: / 16-04-2007 / 15:37:31 / cg"
!

printCircles: arrayOfPointsAndRadius
    "Opens a print dialog and prints the given circles"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Circles'.
	printer foreground:Color green background:Color white.
	arrayOfPointsAndRadius
	    do:[:pointAndRadius |
		printer displayCircle:(pointAndRadius at:1)
			radius:(pointAndRadius at:2).
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext printCircles:
	(Array with: (Array with: 800@800 with: 600)
	       with: (Array with: 1500@1500 with: 1000)
	       with: (Array with: 4000@2500 with: 2000))
    "

    "Created: / 07-08-2006 / 11:46:52 / fm"
    "Modified: / 16-04-2007 / 15:37:34 / cg"
!

printCirclesIn: rectangles
    "Opens a print dialog and prints the given circles"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Circles In Rectangles'.
	rectangles
	   do:[:rectangle |
	       printer displayCircleIn: rectangle.
	   ].
       printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext printCirclesIn:
	(Array with: (Rectangle left:20 top:20 width:400 height:600)
	       with: (Rectangle left:40 top:40 width:600 height:400)
	)
    "

    "Created: / 07-08-2006 / 11:48:46 / fm"
    "Modified: / 16-04-2007 / 15:37:38 / cg"
!

printImage: anImage
    "Opens a print dialog and prints the given image"

    self printImage: anImage magnification:1.

    "
     WinPrinterContext printImage: (Image fromFile:'C:\vsw311\pavheadr.gif').
     WinPrinterContext printImage: XPToolbarIconLibrary help32x32Icon.
     WinPrinterContext printImage: XPToolbarIconLibrary eraseXP28x28Icon.
     WinPrinterContext printImage: XPToolbarIconLibrary saveImageBlack22x22Icon.
     WinPrinterContext printImage: XPToolbarIconLibrary changesBrowser18x22Icon.
    "

    "Created: / 07-08-2006 / 11:46:52 / fm"
    "Modified: / 16-04-2007 / 15:37:34 / cg"
!

printImage:anImage magnification:factor
    "Opens a print dialog and prints the given image"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Image'.
	printer background:Color white.
	(anImage magnifiedBy:factor) displayOn:printer x:0 y:0.
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext printImage: (Image fromFile:'C:\vsw311\pavheadr.gif').
     WinPrinterContext printImage: XPToolbarIconLibrary help32x32Icon.
     WinPrinterContext printImage: XPToolbarIconLibrary eraseXP28x28Icon.
     WinPrinterContext printImage: XPToolbarIconLibrary saveImageBlack22x22Icon.
     WinPrinterContext printImage: XPToolbarIconLibrary changesBrowser18x22Icon.
    "

    "Created: / 07-08-2006 / 11:46:52 / fm"
    "Modified: / 16-04-2007 / 15:37:34 / cg"
!

printLines: pairOfPointsWithContextArray
    "Opens a print dialog and prints the given lines"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Lines'.
	pairOfPointsWithContextArray
	    do:[:pairOfPointsAndContext |
		 |pairOfPoints|
		 pairOfPoints := pairOfPointsAndContext at: 1.
		 printer
		    foreground:(pairOfPointsAndContext at:2);
		    lineWidth: (pairOfPointsAndContext at:3);
		    lineStyle: (pairOfPointsAndContext at:4);
		    displayLineFrom: (pairOfPoints at:1)  to: (pairOfPoints at:2).
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext printLines:
	(Array with: (Array with:(Array with:10@10 with:1000@5000) with: Color red with:4 with: #solid)
	       with: (Array with:(Array with:10@10 with:3500@2000) with: Color blue with:1 with: #dashed)
	       with: (Array with:(Array with:1000@800 with:6000@5000) with: Color black with: 1 with:#dotted)
	       with: (Array with: (Array with:2000@2800 with:2000@5000) with: Color green with:8 with: nil))
    "

    "Created: / 07-08-2006 / 12:09:48 / fm"
    "Modified: / 07-08-2006 / 14:11:17 / fm"
    "Modified: / 16-04-2007 / 15:37:41 / cg"
!

printPoints: aCollectionOfPoints
    "Opens a print dialog and prints the given points"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Points'.
	aCollectionOfPoints do:[:each |
	    printer displayPointX: each x y: each y.
	].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext printPoints:
	(Array with: (10 @ 10)
	       with: (500 @ 700)
	       with: (900 @ 1000)
	       with: (1500 @ 1700)
	       with: (2100 @ 2000)
	       with: (2500 @ 2700)
	)
    "
!

printPolygons: polygons
    "Opens a print dialog and prints the given polygons"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Polygons'.
	printer foreground:Color black background:Color white.
	polygons
	    do:[:aPolygon |
		 aPolygon displayStrokedOn: printer.
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext printPolygons:
	(Array with: (Polygon vertices:(
				Array
				    with:100@100
				    with:600@1000
				    with:3500@4000
				    with:100@4000
				    with:100@100))
		with: (Polygon vertices:(
				Array
				    with:1000@1000
				    with:1000@2000
				    with:2000@1000)))
    "

    "Created: / 07-08-2006 / 12:09:48 / fm"
    "Modified: / 07-08-2006 / 14:11:17 / fm"
    "Modified: / 16-04-2007 / 15:37:43 / cg"
!

printPolylines: evenCollectionOfPoints
    "Opens a print dialog and prints the given rectangles"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Polylines'.
	printer displayPolylines:evenCollectionOfPoints.
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext printPolylines:
	(Array with: (10 @ 10)
	       with: (500 @ 700)
	       with: (900 @ 1000)
	       with: (1500 @ 1700)
	       with: (2100 @ 2000)
	       with: (2500 @ 2700)
	)
    "

    "Created: / 07-08-2006 / 11:40:48 / fm"
    "Modified: / 16-04-2007 / 15:37:46 / cg"
!

printRectangles: rectanglesWithContextArray
    "Opens a print dialog and prints the given rectangles"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Rectangles'.
	printer foreground:Color red background:Color white.
	rectanglesWithContextArray do:[:rectangleWithContextArray |
	    |rectangle|
	    rectangle := rectangleWithContextArray at: 1.
	    printer
		foreground:(rectangleWithContextArray at:2);
		lineWidth: (rectangleWithContextArray at:3);
		lineStyle: (rectangleWithContextArray at:4);
		displayRectangleX: rectangle origin x
			y: rectangle origin y
			width: rectangle width
			height: rectangle height.
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext printRectangles:
	(Array with: (Array with: (Rectangle left:30 top:10 width:400 height:600) with: Color red with:4 with: #solid)
	       with: (Array with: (Rectangle left:100 top:140 width:700 height:800) with: Color blue with:1 with: #dashed)
	       with: (Array with: (Rectangle left:800 top:1500 width:2600 height:3400) with: Color green with:1 with: #dotted)
	       with: (Array with: (Rectangle left:1000 top:1200 width:1400 height:1600) with: Color gray with:8 with: #dashed)
	       with: (Array with: (Rectangle left:2600 top:1200 width:1400 height:1600) with: Color darkGray with:1 with: #dashDotDot)
	)
    "

    "Created: / 07-08-2006 / 11:40:48 / fm"
    "Modified: / 16-04-2007 / 15:37:46 / cg"
!

printStrings: stringAndPositionsArray
    "Opens a print dialog and prints the given strings"

    | printerInfo printer |

    printerInfo := PrintingDialog getPrinterInfo.
    printerInfo isNil ifTrue:[^self].

    printer := self fromPrinterInfo: printerInfo.
    [
	printer startPrintJob: 'Strings with Position'.
	printer foreground:Color black background:Color white.
	stringAndPositionsArray
	    do:[:pairOfPointsAndPosition |
		 printer displayString:(pairOfPointsAndPosition at: 1)
			    x:(pairOfPointsAndPosition at: 2) x
			    y:(pairOfPointsAndPosition at: 2) y
	    ].
	printer endPrintJob.
    ] forkAt: 3

    "
     WinPrinterContext printStrings:
	(Array with: (Array with:'Testing printing with standard method' with:10@10)
	       with: (Array with:'Another test string to print' with:80@200))
    "

    "Created: / 07-08-2006 / 12:09:48 / fm"
    "Modified: / 07-08-2006 / 14:11:17 / fm"
    "Modified: / 16-04-2007 / 15:37:49 / cg"
! !

!WinPrinterContext methodsFor:'accessing'!

depth
    ^ 24
!

deviceColors

    ^#()
!

deviceFonts

    deviceFonts isNil ifTrue:[deviceFonts := CachingRegistry new cacheSize:10.].
    ^deviceFonts
!

getCharHeight
    "Private - answer the height of the font selected in the receiver's
     device context."

    |textMetrics answer|


    textMetrics := Win32OperatingSystem::TextMetricsStructure new.
"/    (OperatingSystem getTextMetrics:gcId lpMetrics:textMetrics) ifFalse:[ ^ self error ].
"/    Transcript showCR: 'CHAR HEIGHT PRIM ******* ', '   ',  (textMetrics tmHeight + textMetrics tmExternalLeading) printString.
"/    Transcript showCR: 'CHAR HEIGHT DEVICE ***** ', '   ', (self font heightOf:'PQWEXCZ' on:self device) printString.
    answer := (self font heightOf:'PQWEXCZ' on:self device).
"/    answer := textMetrics tmHeight + textMetrics tmExternalLeading.
    ^answer

    "Created: / 02-08-2006 / 17:47:20 / fm"
    "Modified: / 03-08-2006 / 10:09:01 / fm"
    "Modified: / 10-10-2006 / 18:15:17 / cg"
!

getLogicalPixelSizeX
    ^ printerInfo printQuality ? 600
!

getLogicalPixelSizeY
    ^ printerInfo printQuality ? 600
!

numberOfColorBitsPerPixel
    ^ OperatingSystem getDeviceCaps:self gcId index:12 "Bitspixel"

    "Created: / 03-08-2006 / 09:58:18 / fm"
    "Modified: / 10-10-2006 / 18:15:40 / cg"
!

physicalOffsetX
    ^ OperatingSystem getDeviceCaps:self gcId index:112 "PhysicalOffsetX"

    "Created: / 01-08-2006 / 16:28:34 / fm"
    "Modified: / 16-04-2007 / 12:52:06 / cg"
!

physicalOffsetY
    ^ OperatingSystem getDeviceCaps:self gcId index:113 "PhysicalOffsetY"

    "Created: / 01-08-2006 / 16:28:34 / fm"
    "Modified: / 16-04-2007 / 12:52:01 / cg"
!

pixelsPerInchOfScreenHeight
    ^ OperatingSystem getDeviceCaps:self gcId index:90 "Logpixelsy"

    "Created: / 01-08-2006 / 16:29:16 / fm"
!

pixelsPerInchOfScreenWidth
    ^ OperatingSystem getDeviceCaps:self gcId index:88 "Logpixelsx"

    "Created: / 01-08-2006 / 16:28:34 / fm"
!

printerHeightArea
    ^ (OperatingSystem getDeviceCaps:self gcId index:10)

    "Modified: / 10-10-2006 / 18:18:31 / cg"
!

printerPhysicalHeight
    ^ OperatingSystem getDeviceCaps:self gcId "deviceContext" index:111 "PhysicalHeight"

    "Created: / 01-08-2006 / 16:14:08 / fm"
!

printerPhysicalWidth
    ^ OperatingSystem getDeviceCaps:self gcId "deviceContext" index:110 "PhysicalWidth"

    "Created: / 01-08-2006 / 16:14:08 / fm"
!

printerWidthArea
    ^ OperatingSystem getDeviceCaps:self gcId "deviceContext" index:8 "Horzres"

    "Created: / 01-08-2006 / 16:14:08 / fm"
!

supportedImageFormats
    "return an array with supported image formats; each array entry
     is another array, consisting of depth and bitsPerPixel values."

    |info|

    info := IdentityDictionary new.
    info at:#depth put:self depth.
    info at:#bitsPerPixel put:self depth.
    info at:#padding put:32.
    ^ Array with:info

    "
     Disply supportedImageFormats
    "

    "Modified: / 10.9.1998 / 23:14:05 / cg"
!

visualType
    ^ #TrueColor
! !

!WinPrinterContext methodsFor:'color stuff'!

colorScaledRed:r scaledGreen:g scaledBlue:b
    "allocate a color with rgb values (0..16rFFFF) - return the color index
     (i.e. colorID)"

%{  /* NOCONTEXT */
    int id, ir, ig, ib;

    if (__bothSmallInteger(r, g) && __isSmallInteger(b)) {
	ir = (__intVal(r) >> 8) & 0xff;
	ig = (__intVal(g) >> 8) & 0xff;
	ib = (__intVal(b) >> 8) & 0xff;

	id = RGB( ir, ig, ib);

	RETURN ( __MKSMALLINT(id) );
    }
%}.
    self primitiveFailed.
    ^ nil
!

setBackground:bgColorIndex in:aDC
    "set background color to be drawn with"

%{  /* NOCONTEXT */

    HDC hDC;

    if (__isExternalAddressLike(aDC)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	COLORREF bg, oldBg;

	oldBg = GetBkColor(hDC);

	bg = __intVal(bgColorIndex) & 0xffffff;
/*        bg = (COLORREF)st2RGB(__intVal(bgColorIndex),gcData);         */

	if (bg != oldBg) {
	    SetBkColor(hDC, bg);
	}

	RETURN (self);
    }
%}
!

setBackgroundColor:color in:aGCId
    "set background color to be drawn with"

    |colorId deviceColor|

    (color isOnDevice:self) ifTrue:[
	colorId := color colorId.
    ] ifFalse:[
	deviceColor := color onDevice:self.
	deviceColor notNil ifTrue:[
	    colorId := deviceColor colorId.
	]
    ].
    colorId isNil ifTrue:[
	'DeviceWorkstation [warning]: could not set bg color' infoPrintCR.
    ] ifFalse:[
	self setBackground:colorId in:aGCId.
    ]
!

setForeground:fgColorIndex background:bgColorIndex in:aDC
    "set foreground and background colors to be drawn with"

%{  /* NOCONTEXT */

    if (__isExternalAddressLike(aDC)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	COLORREF fg, bg, oldFg, oldBg;

/*        fg = (COLORREF)st2RGB(__intVal(fgColorIndex),gcData);    */
	fg = __intVal(fgColorIndex) & 0xffffff;
/*        bg = (COLORREF)st2RGB(__intVal(bgColorIndex),gcData);    */
	bg = __intVal(bgColorIndex) & 0xffffff;

	oldFg = GetTextColor(hDC);
	oldBg = GetBkColor(hDC);

	if ((fg != oldFg) || (bg != oldBg)) {
	    /* Pen only depends upon fg-color */
	    if (fg != oldFg) {
		SetTextColor(hDC, fg);
	    }
	    if (bg != oldBg) {
		SetBkColor(hDC, bg);
	    }
	}
	RETURN (self);
    }
%}
!

setForeground:fgColorIndex in:aDC
    "set foreground color to be drawn with"

%{  /* NOCONTEXT */

    HDC hDC;

    if (__isExternalAddressLike(aDC)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	COLORREF fg, oldFg;

	oldFg = GetTextColor(hDC);

	fg = __intVal(fgColorIndex) & 0xffffff;
/*        fg = (COLORREF)st2RGB(__intVal(fgColorIndex),gcData);         */

	if (fg != oldFg) {
	    SetTextColor(hDC, fg);
	}

	RETURN (self);
    }
%}
!

setForegroundColor:color in:aGCId
    "set the foreground color to be drawn with"

    |colorId deviceColor|

    (color isOnDevice:self) ifTrue:[
	colorId := color colorId.
    ] ifFalse:[
	deviceColor := color onDevice:self.
	deviceColor notNil ifTrue:[
	    colorId := deviceColor colorId.
	]
    ].
    colorId isNil ifTrue:[
	'DeviceWorkstation [warning]: could not set fg color' infoPrintCR.
    ] ifFalse:[
	self setForeground:colorId in:aGCId.
    ]
! !

!WinPrinterContext methodsFor:'context stuff'!

getPenFor:aDC
    "set line attributes"

    | lineWidthObj lineStyleObj capStyleObj joinStyleObj |

	lineWidthObj := self lineWidth.
	lineStyleObj := self lineStyle.
	 capStyleObj := self capStyle.
	joinStyleObj := self joinStyle.

%{  /* NOCONTEXT */

    if (__isExternalAddressLike(aDC)
     && __isSmallInteger(lineWidthObj)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	COLORREF fgColor;
	HANDLE hPen, prevPen;
	int lineStyleInt, capStyleInt, joinStyleInt, lineWidth;

	lineWidth= __intVal(lineWidthObj);

	if (lineStyleObj == @symbol(solid)) {
	    lineStyleInt= PS_SOLID;
	} else if (lineStyleObj == @symbol(dashed)) {
	    lineStyleInt= PS_DASH;
	} else if (lineStyleObj == @symbol(dotted)) {
	    lineStyleInt= PS_DOT;
	} else if (lineStyleObj == @symbol(dashDot)) {
	    lineStyleInt= PS_DASHDOT;
	} else if (lineStyleObj == @symbol(dashDotDot)) {
	    lineStyleInt= PS_DASHDOTDOT;
	} else
	    lineStyleInt= PS_SOLID;

	if (capStyleObj == @symbol(round)) {
	    capStyleInt= PS_ENDCAP_ROUND;
	} else if (capStyleObj == @symbol(square)) {
	    capStyleInt= PS_ENDCAP_SQUARE;
	} else if (capStyleObj == @symbol(flat)) {
	    capStyleInt= PS_ENDCAP_FLAT;
	} else
	    capStyleInt= PS_ENDCAP_FLAT;

	if (joinStyleObj == @symbol(bevel)) {
	    joinStyleInt= PS_JOIN_BEVEL;
	} else if (joinStyleObj== @symbol(miter)) {
	    joinStyleInt= PS_JOIN_MITER;
	} else if (joinStyleObj == @symbol(round)) {
	    joinStyleInt= PS_JOIN_ROUND;
	} else
	    joinStyleInt= PS_JOIN_MITER;


	fgColor = GetTextColor(hDC);

	hPen = CreatePen(lineStyleInt | capStyleInt | joinStyleInt, lineWidth, fgColor);
	prevPen = SelectObject(hDC, hPen);


	RETURN (self);
    }
%}.
    self primitiveFailed
!

getPenForContext
    "set line attributes"

   | gcId  lineWidthObj lineStyleObj capStyleObj joinStyleObj |

   gcId := self gcId.
	lineWidthObj := self lineWidth.
	lineStyleObj := self lineStyle.
	 capStyleObj := self capStyle.
	joinStyleObj := self joinStyle.

%{  /* NOCONTEXT */

    if (__isExternalAddressLike(gcId)
     && __isSmallInteger(lineWidthObj) ) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(gcId));
	COLORREF fgColor;
	HANDLE hPen;
	int lineStyleInt, capStyleInt, joinStyleInt, lineWidth;

	lineWidth= lineWidthObj;

	if (lineStyleObj == @symbol(solid)) {
	    lineStyleInt= PS_SOLID;
	} else if (lineStyleObj == @symbol(dashed)) {
	    lineStyleInt= PS_DASH;
	} else if (lineStyleObj == @symbol(dotted)) {
	    lineStyleInt= PS_DOT;
	} else if (lineStyleObj == @symbol(dashDot)) {
	    lineStyleInt= PS_DASHDOT;
	} else if (lineStyleObj == @symbol(dashDotDot)) {
	    lineStyleInt= PS_DASHDOTDOT;
	} else
	    lineStyleInt= PS_SOLID;

	if (capStyleObj == @symbol(round)) {
	    capStyleInt= PS_ENDCAP_ROUND;
	} else if (capStyleObj == @symbol(square)) {
	    capStyleInt= PS_ENDCAP_SQUARE;
	} else if (capStyleObj == @symbol(flat)) {
	    capStyleInt= PS_ENDCAP_FLAT;
	} else
	    capStyleInt= PS_ENDCAP_FLAT;

	if (joinStyleObj == @symbol(bevel)) {
	    joinStyleInt= PS_JOIN_BEVEL;
	} else if (joinStyleObj == @symbol(miter)) {
	    joinStyleInt= PS_JOIN_MITER;
	} else if (joinStyleObj== @symbol(round)) {
	    joinStyleInt= PS_JOIN_ROUND;
	} else
	    joinStyleInt= PS_JOIN_MITER;


	fgColor = GetTextColor(hDC);

	hPen = CreatePen(lineStyleInt | capStyleInt | joinStyleInt, lineWidth, fgColor);

	RETURN (self);
    }
%}.
    self primitiveFailed
!

hatch

    "The hatch style will define a hatched brush between these patterns:

       #none
       #horizontal              -----       HS_HORIZONTAL = 0
       #vertical                |||||       HS_VERTICAL = 1
       #fDiagonal               \\\\\       HS_FDIAGONAL = 2
       #bDiagonal               /////       HS_BDIAGONAL = 3
       #cross                   +++++       HS_CROSS = 4
       #diagonalCross           xxxxx       HS_DIAGCROSS = 5
    "

    hatch isNil ifTrue:[^#none].
    ^ hatch
!

hatch: aSymbol

    "The hatch style will define a hatched brush between these patterns:

       #none
       #horizontal              -----       HS_HORIZONTAL = 0
       #vertical                |||||       HS_VERTICAL = 1
       #fDiagonal               \\\\\       HS_FDIAGONAL = 2
       #bDiagonal               /////       HS_BDIAGONAL = 3
       #cross                   +++++       HS_CROSS = 4
       #diagonalCross           xxxxx       HS_DIAGCROSS = 5
    "

    hatch := aSymbol
!

noClipIn:aWindowId gc:aDC
    "disable clipping rectangle"

%{  /* NOCONTEXT */

    if (__isExternalAddressLike(aDC)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));

	SelectClipRgn(hDC, NULL);
	RETURN (self);
    }
%}
!

platformName
    "used by #fillRoundRectangleX ...."
    ^ Smalltalk platformName asUppercase
!

setBitmapMask:aBitmapId in:aDC
    "set or clear the drawing mask - a bitmap mask using current fg/bg"

%{  /* NOCONTEXT */

    if (__isExternalAddressLike(aDC)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	HBITMAP oldM;

/*        oldM = gcData->hMask;
	if (__isExternalAddress(aBitmapId))
	    gcData->hMask = _HBITMAPVAL(aBitmapId);
	else
	    gcData->hMask = 0;

	if (oldM != gcData->hMask) {
	  FLUSH_CACHED_DC(gcData);
	    CPRINTF(("masks set to %x\n",gcData->hMask));
	}                                                     */
	RETURN (self);
    }
%}
!

setClipX:clipX y:clipY width:clipWidth height:clipHeight in:ignoredDrawableId gc:aDC
    "clip to a rectangle"

"
      p--w---
      |     |
      h     |  the clipping rectangle
      |     |
      -------
	  where p = ( clipX, clipY ), w = clipWidth, h = clipHeight
"

%{  /* NOCONTEXT */

    if (__isExternalAddressLike(aDC)
     && __bothSmallInteger(clipX, clipY)
     && __bothSmallInteger(clipWidth, clipHeight) ) {
	HANDLE hDC;
	int cX, cY, cW, cH;
	POINT ptOrg;


	hDC = (HANDLE)(__externalAddressVal(aDC));

	GetViewportOrgEx(hDC,&ptOrg);

	// set the clip rectangle
	// and offset the rectangle by the viewport origin

	cX = __intVal(clipX) + ptOrg.x;
	cY = __intVal(clipY) + ptOrg.y;
	cW = __intVal(clipWidth)+ ptOrg.x;
	cH = __intVal(clipHeight)+ ptOrg.y;

	{
	    HRGN region = CreateRectRgn(cX, cY, cX + cW, cY + cH);

	    if (region == NULL ) {
		console_fprintf(stderr, "WinWorkstat [warning]: clipping region creation failed\n");
	    } else {
		if (SelectClipRgn(hDC, region) == ERROR ) {
		    console_fprintf(stderr, "WinWorkstat [warning]: select clipping region failed\n");
		}
		DeleteObject(region);
	    }
	}
	RETURN (self);
    }
%}.
    self primitiveFailed
!

setDashes:dashList dashOffset:offset in:aGCId
    "set line attributes"

%{  /* NOCONTEXT */

    if (__isExternalAddressLike(aGCId)) {
	DPRINTF(("WinWorkstat [warning]: dashes not (yet) implemented\n"));
    }
%}
!

setLineWidth:aNumber style:lineStyle cap:capStyle join:joinStyle in:aDC
    "set line attributes"

%{  /* NOCONTEXT */

    HDC hDC;

    if (__isExternalAddressLike(aDC)
     && __isSmallInteger(aNumber)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	int style;

	if (lineStyle == @symbol(solid)) {
	    style = PS_SOLID;
	} else if (lineStyle == @symbol(dashed)) {
	    style= PS_DASH;
	} else if (lineStyle == @symbol(dotted)) {
	    style= PS_DOT;
	} else if (lineStyle == @symbol(dashDot)) {
	    style= PS_DASHDOT;
	} else if (lineStyle == @symbol(dashDotDot)) {
	    style= PS_DASHDOTDOT;
	} else
	    style= PS_SOLID;

	if (capStyle == @symbol(round)) {
	    style = PS_ENDCAP_ROUND;
	} else if (capStyle == @symbol(square)) {
	    style = PS_ENDCAP_SQUARE;
	} else if (capStyle == @symbol(flat)) {
	    style = PS_ENDCAP_FLAT;
	} else
	    style = PS_ENDCAP_FLAT;

	if (joinStyle == @symbol(bevel)) {
	    style = PS_JOIN_BEVEL;
	} else if (joinStyle == @symbol(miter)) {
	    style = PS_JOIN_MITER;
	} else if (joinStyle == @symbol(round)) {
	    style = PS_JOIN_ROUND;
	} else
	    style = PS_JOIN_MITER;


	RETURN (self);
    }
%}.
    self primitiveFailed
!

setMaskOriginX:orgX y:orgY in:aDC
    "set the mask origin"

%{  /* NOCONTEXT */

    if (__isExternalAddress(aDC)
     && __bothSmallInteger(orgX,orgY)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	int oX, oY, maskOrgX, maskOrgY;

	oX = __intVal(orgX);
	oY = __intVal(orgY);
	if ((oX != maskOrgX)
	 || (oY != maskOrgY)) {
	    maskOrgX = __intVal(orgX);
	    maskOrgY = __intVal(orgY);;
	}
	RETURN (self);
    }
%}
!

setViewportOrg: aPoint

    "Sets the viewport origin (LOGICAL point (0,0)) of the device context"

    ^ OperatingSystem
	    setViewportOrg: self gcId "deviceContext"
	    x: aPoint x
	    y: aPoint y
	    oldOrigin: nil

    "Created: / 01-08-2006 / 16:14:08 / fm"
! !

!WinPrinterContext methodsFor:'drawing'!

displayArcX:x y:y width:width height:height from:startAngle angle:angle in:ignoredDrawableId with:aDC
    "draw an arc. If any of x,y, w or h is not an integer, an error is triggered.
     The angles may be floats or integer - they are given in degrees."

     | lineWidthObj lineStyleObj |

     lineWidthObj := self lineWidth.
     lineStyleObj := self lineStyle.
%{
    int __x, __y, w, h;
    float angle1, angle2;
    double f;

    if (__isSmallInteger(startAngle))
	angle1 = (float)(__intVal(startAngle));
    else if (__isFloat(startAngle)) {
	angle1 = (float) __floatVal(startAngle);
    } else if (__isShortFloat(startAngle)) {
	angle1 = __shortFloatVal(startAngle);
    } else goto bad;

    if (__isSmallInteger(angle))
	angle2 = (float)(__intVal(angle));
    else if (__isFloat(angle)) {
	angle2 = (float) __floatVal(angle);
    } else if (__isShortFloat(angle)) {
	angle2 = __shortFloatVal(angle);
    } else goto bad;

    if (angle2 <= 0) {
	RETURN (self);
    }

    if (__isExternalAddressLike(aDC)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height))
     {
	POINT p;
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	DWORD clr = 0 /* 0xFFFFFFFF */;
	HANDLE prevPen, hPen;
	double xB, yB, xE, yE, xR, yR;
	COLORREF fgColor;
	OBJ lStyleSymbol;
	int lStyleInt;
	int lw;

	lw= __intVal(lineWidthObj);
	lStyleSymbol= lineStyleObj;

	/*  PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT
	    only works with lineWidth = 1  */

	if (lStyleSymbol == @symbol(solid)) {
	    lStyleInt= PS_SOLID;
	} else if (lStyleSymbol == @symbol(dashed)) {
	    lStyleInt= PS_DASH;
	} else if (lStyleSymbol == @symbol(dotted)) {
	    lStyleInt= PS_DOT;
	} else if (lStyleSymbol == @symbol(dashDot)) {
	    lStyleInt= PS_DASHDOT;
	} else if (lStyleSymbol == @symbol(dashDotDot)) {
	    lStyleInt= PS_DASHDOTDOT;
	} else if (lStyleSymbol == @symbol(insideFrame)) {
	    lStyleInt= PS_INSIDEFRAME;
	} else
	    lStyleInt= PS_SOLID;

	fgColor = GetTextColor(hDC);
	hPen = CreatePen(lStyleInt, lw, fgColor);

	w = __intVal(width);
	h = __intVal(height);
	__x = __intVal(x);
	__y = __intVal(y);

	    xR = w / 2;
	    yR = h / 2;
	    if (angle2 - angle1 >= 360) {
		xB = xE = __x + xR + 0.5;
		yB = yE = __y /*+ yR + 0.5*/;
	    } else {
		double sin(), cos();
		float rad1, rad2;

		if (angle1 <= 180)
		  angle1 = 180 - angle1;
		else
		  angle1 = 360 + 180 - angle1;
		angle2 = angle1 - angle2;
		/* sigh - compute the intersections ... */
		rad1 = (angle1 * 3.14159265359) / 180.0;
		rad2 = (angle2 * 3.14159265359) / 180.0;
		xB = cos(rad1) * xR;
		yB = sin(rad1) * yR;
		xE = cos(rad2) * xR;
		yE = sin(rad2) * yR;
		xB = __x + xR - xB + 0.5;
		yB = __y + yR - yB + 0.5;
		xE = __x + xR - xE + 0.5;
		yE = __y + yR - yE + 0.5;
	    }
	    prevPen = SelectObject(hDC, hPen);
	    DPRINTF(("Arc x=%d y=%d w=%d h=%d xB=%d xE=%d yB=%d yE=%d a1=%f a2=%f\n",__x,__y,w,h,(int)xB,(int)xE,(int)yB,(int)yE,angle1,angle2));
	    Arc(hDC,
		__x, __y,
		__x + w, __y + h,
		(int)xB, (int)yB,
		(int)xE, (int)yE);

	    SelectObject(hDC, prevPen);
	    DeleteObject(hPen);

	RETURN ( self );
    }
    bad: ;
%}.
    self primitiveFailed

    "Created: / 07-08-2006 / 10:40:27 / fm"
    "Modified: / 07-08-2006 / 14:44:21 / fm"
!

displayLineFromX:x0 y:y0 toX:x1 y:y1 in:ignoredDrawableId with:aDC
    "draw a line. If the coordinates are not integers, an error is triggered."

     | lineWidthObj lineStyleObj |

     lineWidthObj := self lineWidth.
     lineStyleObj := self lineStyle.

%{ 
    if (__isExternalAddressLike(aDC)
     && __bothSmallInteger(x0, y0)
     && __bothSmallInteger(x1, y1)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	COLORREF fgColor;
	HANDLE prevPen, hPen;
	int __x1 = __intVal(x1), __y1 = __intVal(y1);
	OBJ lStyleSymbol;
	int lStyleInt;
	int lw;

/*      DPRINTF(("displayLine: %d/%d -> %d/%d\n",
		    __intVal(x0), __intVal(y0),
		    __x1, __y1));
*/

	lw= __intVal(lineWidthObj);
	lStyleSymbol= lineStyleObj;

	/*  PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT
	    only works with lineWidth = 1  */

	if (lStyleSymbol == @symbol(solid)) {
	    lStyleInt= PS_SOLID;
	} else if (lStyleSymbol == @symbol(dashed)) {
	    lStyleInt= PS_DASH;
	} else if (lStyleSymbol == @symbol(dotted)) {
	    lStyleInt= PS_DOT;
	} else if (lStyleSymbol == @symbol(dashDot)) {
	    lStyleInt= PS_DASHDOT;
	} else if (lStyleSymbol == @symbol(dashDotDot)) {
	    lStyleInt= PS_DASHDOTDOT;
	} else if (lStyleSymbol == @symbol(insideFrame)) {
	    lStyleInt= PS_INSIDEFRAME;
	} else
	    lStyleInt= PS_SOLID;

	fgColor = GetTextColor(hDC);
	hPen = CreatePen(lStyleInt, lw, fgColor);
	prevPen = SelectObject(hDC, hPen);
	MoveToEx(hDC, __intVal(x0), __intVal(y0), NULL);
	LineTo(hDC, __x1, __y1);
	/*
	 * end-point ...
	 */
	// LineTo(hDC, __x1+1, __y1);

	SelectObject(hDC, prevPen);
	DeleteObject(hPen);

	RETURN ( self );
    }
%}
!

displayPointX:px y:py in:ignoredDrawableId with:aDC
    "draw a point. If x/y are not integers, an error is triggered."

%{  /* NOCONTEXT */
    if (__isExternalAddressLike(aDC)
     && __bothSmallInteger(px, py)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	POINT p;
	COLORREF fgColor;

	int __x = __intVal(px), __y = __intVal(py);

	fgColor = GetTextColor(hDC);
	SetPixelV(hDC, __x, __y, fgColor);

	RETURN ( self );
    }
%}
!

displayPolygon:aPolygon in:aDrawableId with:aDC
    "draw a polygon, the argument aPolygon is a Collection of individual points,
     which define the polygon.
     If any coordinate is not integer, an error is triggered."

    | numberOfPoints lineWidthObj lineStyleObj |

     lineWidthObj := self lineWidth.
     lineStyleObj := self lineStyle.

    numberOfPoints := aPolygon size.
%{
    OBJ point, px, py;
    int i, num;

    if (__isExternalAddressLike(aDC)
     /* && __isExternalAddress(aDrawableId) */
     && __isSmallInteger(numberOfPoints)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	POINT p;
	DWORD clr = 0 /* 0xFFFFFFFF */;
	HANDLE prevPen, hPen;
	int lw;
	COLORREF fgColor;
	OBJ lStyleSymbol;
	int lStyleInt;

	lw= __intVal(lineWidthObj);
	lStyleSymbol= lineStyleObj;

	/*  PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT
	    only works with lineWidth = 1  */

	if (lStyleSymbol == @symbol(solid)) {
	    lStyleInt= PS_SOLID;
	} else if (lStyleSymbol == @symbol(dashed)) {
	    lStyleInt= PS_DASH;
	} else if (lStyleSymbol == @symbol(dotted)) {
	    lStyleInt= PS_DOT;
	} else if (lStyleSymbol == @symbol(dashDot)) {
	    lStyleInt= PS_DASHDOT;
	} else if (lStyleSymbol == @symbol(dashDotDot)) {
	    lStyleInt= PS_DASHDOTDOT;
	} else if (lStyleSymbol == @symbol(insideFrame)) {
	    lStyleInt= PS_INSIDEFRAME;
	} else
	    lStyleInt= PS_SOLID;

	num = __intVal(numberOfPoints);

	for (i=0; i<num; i++) {
	    point = __AT_(aPolygon, __MKSMALLINT(i+1));
	    if (! __isPoint(point)) goto fail;
	    px = _point_X(point);
	    py = _point_Y(point);
	    if (! __bothSmallInteger(px, py)) {
		goto fail;
	    }
	}

	fgColor = GetTextColor(hDC);

	hPen = CreatePen(lStyleInt, lw, fgColor);
	prevPen = SelectObject(hDC, hPen);

	for (i=0; i<num; i++) {
	    point = __AT_(aPolygon, __MKSMALLINT(i+1));
	    px = _point_X(point);
	    py = _point_Y(point);
	    p.x = __intVal(px);
	    p.y = __intVal(py);
	    if (i == 0) {
		MoveToEx(hDC, p.x, p.y, NULL);
	    } else {
		if (i == (num-1)) {
		    PolylineTo(hDC, &p, 1);
		} else {
		    LineTo(hDC, p.x, p.y);
#ifdef PRE_04_JUN_04
		    /*
		     * end-point ...
		     */
		    LineTo(hDC, p.x+1, p.y);
#endif
		}
	    }
	}
	SelectObject(hDC, prevPen);
	DeleteObject(hPen);


	RETURN ( self );
    }
fail: ;
%}

    "Created: / 07-08-2006 / 14:46:55 / fm"
!

displayPolylines:arrayOfPoints

    self device displayPolylines:arrayOfPoints in:nil with:self gcId
!

displayPolylines:aPolyline in:ignoredDrawableId with:aDC
    "draw a polyline, the argument aPolyline is a collection of individual points,
     which define the lines (p1/p2 pairs); must be even in size.
     If any coordinate is not integer, an error is triggered."

    |numberOfPoints lineWidthObj lineStyleObj capStyleObj joinStyleObj |

    numberOfPoints := aPolyline size.

 	lineWidthObj := self lineWidth.
	lineStyleObj := self lineStyle.
	
%{
    OBJ point, px, py;
    int i, num;

    if (__isExternalAddressLike(aDC)
     && __isSmallInteger(numberOfPoints)) {

	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	POINT p;
	HANDLE prevPen, hPen;
	COLORREF fgColor;
	int lw;
	OBJ lStyleSymbol;
	int lStyleInt;

	lw= __intVal(lineWidthObj);
	lStyleSymbol= lineStyleObj;

	/*  PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT
	    only works with lineWidth = 1  */

	if (lStyleSymbol == @symbol(solid)) {
	    lStyleInt= PS_SOLID;
	} else if (lStyleSymbol == @symbol(dashed)) {
	    lStyleInt= PS_DASH;
	} else if (lStyleSymbol == @symbol(dotted)) {
	    lStyleInt= PS_DOT;
	} else if (lStyleSymbol == @symbol(dashDot)) {
	    lStyleInt= PS_DASHDOT;
	} else if (lStyleSymbol == @symbol(dashDotDot)) {
	    lStyleInt= PS_DASHDOTDOT;
	} else if (lStyleSymbol == @symbol(insideFrame)) {
	    lStyleInt= PS_INSIDEFRAME;
	} else
	    lStyleInt= PS_SOLID;

	fgColor = GetTextColor(hDC);

	num = __intVal(numberOfPoints);

	for (i=0; i<num; i++) {
	    point = __AT_(aPolyline, __MKSMALLINT(i+1));
	    if (! __isPoint(point)) goto fail;
	    px = _point_X(point);
	    py = _point_Y(point);
	    if (! __bothSmallInteger(px, py)) {
		goto fail;
	    }
	}

	hPen = CreatePen(lStyleInt, lw, fgColor);
	prevPen = SelectObject(hDC, hPen);

	for (i=0; i<num; i++) {
	    point = __AT_(aPolyline, __MKSMALLINT(i+1));
	    px = _point_X(point);
	    py = _point_Y(point);
	    p.x = __intVal(px);
	    p.y = __intVal(py);
	    DPRINTF(("printing point"));
	    DPRINTF(("displayPolygon: no pen\n"));

	    if ((i & 1) == 0) {
		MoveToEx(hDC, p.x, p.y, NULL);
	    } else {
		LineTo(hDC, p.x, p.y);
		/*
		 * end-point ...
		 */
		LineTo(hDC, p.x+1, p.y);
	    }
	}
	SelectObject(hDC, prevPen);
	DeleteObject(hPen);
	RETURN ( self );
    }
fail: ;
%}
!

displayRectangleX:x y:y width:width height:height in:ignoredDrawableId with:aDC
    "draw a rectangle. If the coordinates are not integers, an error is triggered."

    | lineWidthObj lineStyleObj |

    lineWidthObj := self lineWidth.
	lineStyleObj := self lineStyle.


%{
    int w, h;
    int xL, yT;
    if (__isExternalAddressLike(aDC)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height)) {

	xL = __intVal(x);
	yT = __intVal(y);
	w = __intVal(width);
	h = __intVal(height);

	DPRINTF(("displayRectangle: %d/%d -> %d/%d\n", xL, yT, w, h));

	if ((w >= 0) && (h >= 0)) {
	    HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	    COLORREF fgColor;
	    HANDLE prevPen, hPen;
	    OBJ lStyleSymbol;
	    int lStyleInt;
	    int lw;

	    lw= __intVal(lineWidthObj);
	    lStyleSymbol= lineStyleObj;

	    /*  PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT
		only works with lineWidth = 1  */

	    if (lStyleSymbol == @symbol(solid)) {
		lStyleInt= PS_SOLID;
	    } else if (lStyleSymbol == @symbol(dashed)) {
		lStyleInt= PS_DASH;
	    } else if (lStyleSymbol == @symbol(dotted)) {
		lStyleInt= PS_DOT;
	    } else if (lStyleSymbol == @symbol(dashDot)) {
		lStyleInt= PS_DASHDOT;
	    } else if (lStyleSymbol == @symbol(dashDotDot)) {
		lStyleInt= PS_DASHDOTDOT;
	    } else if (lStyleSymbol == @symbol(insideFrame)) {
		lStyleInt= PS_INSIDEFRAME;
	    } else
		lStyleInt= PS_SOLID;

	    fgColor = GetTextColor(hDC);
	    hPen = CreatePen(lStyleInt, lw, fgColor);

	    prevPen = SelectObject(hDC, hPen);
	    MoveToEx(hDC, xL, yT, NULL);
	    LineTo(hDC, xL+w, yT);       // to top-right
	    LineTo(hDC, xL+w, yT+h);     // to bot-right
	    MoveToEx(hDC, xL, yT, NULL); // back to top-left
	    LineTo(hDC, xL, yT+h);       // to bot-left
	    // LineTo(hDC, xL+w+1, yT+h);   // move pen one pixel more
	    LineTo(hDC, xL+w,   yT+h);   // move pen one pixel more

	    SelectObject(hDC, prevPen);
	    DeleteObject(hPen);

	}
	RETURN ( self );
    }
%}.
    self primitiveFailed

    "Created: / 28-07-2006 / 20:18:25 / fm"
!

displayRoundRectangleX:left y:top width:width height:height wCorner:wCorn hCorner:hCorn
    |right bottom wC hC wHalf hHalf|

    right := left + width-1.
    bottom := top + height-1.

    wC := wCorn.
    hC := hCorn.

    self scale = 1 ifTrue:[
	wHalf := wC // 2.
	hHalf := hC // 2.
    ] ifFalse:[
	wHalf := wC / 2.
	hHalf := hC / 2.
    ].

    "top left arc"
    self displayArcX:left y:top width:wC height:hC from:90 angle:90.

    "top right arc"
    self displayArcX:(right - wC) y:top width:wC height:hC from:0 angle:90.

    "bottom right arc"
    self displayArcX:(right - wC) y:(bottom - hC) width:wC height:hC from:270 angle:90.

    "bottom left arc"
    self displayArcX:left y:(bottom - hC) width:wC height:hC from:180 angle:90.

    "top line"
    self displayLineFromX:(left + wHalf) y:top toX:(right - wHalf+1) y:top.

    "left line"
    self displayLineFromX:left y:(top + hHalf - 1) toX:left y:(bottom - hHalf).

    "bottom line"
    self displayLineFromX:(left + wHalf-1) y:bottom
		      toX:(right - wHalf ) y:bottom.

    "right line"
    self displayLineFromX:right y:(top + hHalf) toX:right y:(bottom - hHalf).


    "
     |v|

     (v := View new) extent:200@200; openAndWait.
     v displayRoundRectangleX:10 y:10 width:100 height:100 wCorner:20 hCorner:20
    "
!

displayString:aString from:index1 to:index2 x:x y:y in:aDrawableId with:aGCId
    "draw a sub-string - draw foreground only.
     If the coordinates are not integers, retry with rounded."

    self
	displayString:aString
	from:index1
	to:index2
	x:x
	y:y
	in:aDrawableId
	with:aGCId
	opaque:false
!

displayString:aString from:index1 to:index2 x:x y:y in:ignoredDrawableId with:aDC opaque:opaque
    "draw a sub-string - if opaque is false, draw foreground only; otherwise, draw both
     foreground and background characters.
     If the coordinates are not integers, an error is triggered."

%{  /* NOCONTEXT */
    unsigned char *cp;
    OBJ cls;
    int  i1, i2, l, n;
    int nInstBytes;

    if (__isExternalAddressLike(aDC)
     && __isNonNilObject(aString)
     && __bothSmallInteger(index1, index2)
     && __bothSmallInteger(x, y))
    {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	int pX, pY;
	COLORREF fgColor;

	pX = __intVal(x);
	pY = __intVal(y);

	if (opaque == true) {
	    SetBkMode(hDC, OPAQUE);
	} else {
	    SetBkMode(hDC, TRANSPARENT);
	}
	fgColor = GetTextColor(hDC);
	SetTextColor(hDC, fgColor);
	SetBkColor(hDC, 0xFFFFFFFF);

	cls = __qClass(aString);

	i1 = __intVal(index1) - 1;
	if (i1 >= 0) {
	    i2 = __intVal(index2) - 1;
	    if (i2 < i1) {
		goto ret;
	    }

	    cp = __stringVal(aString);
	    l = i2 - i1 + 1;

	    if ((cls == @global(String)) || (cls == @global(Symbol))) {
		n = __stringSize(aString);
		if (i2 < n) {
		    cp += i1;
		    DPRINTF(("string1: %s pos=%d/%d l=%d hDC=%x\n", cp, pX, pY,l,hDC));

		    if (l > 32767) {
			l = 32767;
		    }
		    if (! TextOut(hDC, pX, pY, (char *)cp, l)) {
			DFPRINTF((stderr, "WinPrinter [warning]: Textout failed. %d\n", GetLastError()));
		    }
		    goto ret;
		}
	    }

	    nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	    cp += nInstBytes;
	    n = __byteArraySize(aString) - nInstBytes;

	    if (__isBytes(aString)) {
		if (i2 < n) {
		    cp += i1;
		    DPRINTF(("string: %s pos=%d/%d\n", cp, pX, pY));
		    if (l > 32767) {
			l = 32767;
		    }
		    if (! TextOut(hDC, pX, pY, (char *)cp, l)) {
			DFPRINTF((stderr, "WinPrinter [warning]: Textout failed. %d\n", GetLastError()));
		    }
		    goto ret;
		}
	    }

	    /* Unicode */
	    if (__isWords(aString)) {
		n = n / 2;
		if (i2 < n) {
		    WIDECHAR *w_cp = (WIDECHAR *)cp;

		    w_cp += i1;

		    if (! TextOutW(hDC, pX, pY, w_cp, l)) {
			DFPRINTF((stderr, "WinPrinter [warning]: TextoutW failed. %d\n", GetLastError()));
		    }
		    goto ret;
		}
	    }
	}
ret:
	RETURN ( self );
    }
%}.
    self primitiveFailed

    "Created: / 28-07-2006 / 20:35:19 / fm"
!

displayString:aString from:index1 to:index2 x:x y:y in:ignoredDrawableId with:aDC opaque:opaque fontAscent:fontAscent
    "draw a sub-string - if opaque is false, draw foreground only; otherwise, draw both
     foreground and background characters.
     If the coordinates are not integers, an error is triggered."

%{  /* NOCONTEXT */
    unsigned char *cp;
    OBJ cls;
    int  i1, i2, l, n;
    int nInstBytes;

    if (__isExternalAddressLike(aDC)
     && __isNonNilObject(aString)
     && __bothSmallInteger(index1, index2)
     && __bothSmallInteger(x, y))
    {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	int pX, pY;
	COLORREF fgColor;

	pX = __intVal(x);
	pY = __intVal(y);
	pY -= __intVal(fontAscent);

	if (opaque == true) {
	    SetBkMode(hDC, OPAQUE);
	} else {
	    SetBkMode(hDC, TRANSPARENT);
	}
	fgColor = GetTextColor(hDC);
	SetTextColor(hDC, fgColor);
	SetBkColor(hDC, 0xFFFFFFFF);

	cls = __qClass(aString);

	i1 = __intVal(index1) - 1;
	if (i1 >= 0) {
	    i2 = __intVal(index2) - 1;
	    if (i2 < i1) {
		goto ret;
	    }

	    cp = __stringVal(aString);
	    l = i2 - i1 + 1;

	    if ((cls == @global(String)) || (cls == @global(Symbol))) {
		n = __stringSize(aString);
		if (i2 < n) {
		    cp += i1;
		    DPRINTF(("string1: %s pos=%d/%d l=%d hDC=%x\n", cp, pX, pY,l,hDC));

		    if (l > 32767) {
			l = 32767;
		    }
		    if (! TextOut(hDC, pX, pY, (char *)cp, l)) {
			DFPRINTF((stderr, "WinPrinter [warning]: Textout failed. %d\n", GetLastError()));
		    }
		    goto ret;
		}
	    }

	    nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	    cp += nInstBytes;
	    n = __byteArraySize(aString) - nInstBytes;

	    if (__isBytes(aString)) {
		if (i2 < n) {
		    cp += i1;
		    DPRINTF(("string: %s pos=%d/%d\n", cp, pX, pY));
		    if (l > 32767) {
			l = 32767;
		    }
		    if (! TextOut(hDC, pX, pY, (char *)cp, l)) {
			DFPRINTF((stderr, "WinPrinter [warning]: Textout failed. %d\n", GetLastError()));
		    }
		    goto ret;
		}
	    }

	    /* Unicode */
	    if (__isWords(aString)) {
		n = n / 2;
		if (i2 < n) {
		    WIDECHAR *w_cp = (WIDECHAR *)cp;

		    w_cp += i1;

		    if (! TextOutW(hDC, pX, pY, w_cp, l)) {
			DFPRINTF((stderr, "WinPrinter [warning]: TextoutW failed. %d\n", GetLastError()));
		    }
		    goto ret;
		}
	    }
	}
ret:
	RETURN ( self );
    }
%}.
    self primitiveFailed

    "Created: / 28-07-2006 / 20:35:19 / fm"
!

displayString:aString x:x y:y in:aDrawableId with:aDC
    "draw a string - draw foreground only.
     If the coordinates are not integers, retry with rounded."

    self
	displayString:aString
	x:x
	y:y
	in:aDrawableId
	with:aDC
	opaque:false
!

displayString:aString x:x y:y in:aDrawableId with:aDC opaque:opaque
    "draw a string"

    self displayString:aString
		  from:1
		    to:aString size
		     x:x
		     y:y
		     in:aDrawableId
		     with:aDC
		     opaque:opaque
!

fillArcX:x y:y width:width height:height from:startAngle angle:angle
	       in:ignoredDrawableId with:aDC
    "fill an arc. If any coordinate is not integer, an error is triggered.
     The angles may be floats or integer - they are given in degrees."

    | hatchSymbol |

    hatchSymbol := self hatch.

%{
    int __x, __y, w, h;
    float angle1, angle2;

    if (__isSmallInteger(startAngle))
	angle1 = (float)(__intVal(startAngle));
    else if (__isFloat(startAngle)) {
	angle1 = __floatVal(startAngle);
    } else if (__isShortFloat(startAngle)) {
	angle1 = __shortFloatVal(startAngle);
    } else goto bad;

    if (__isSmallInteger(angle))
	angle2 = (float)(__intVal(angle));
    else if (__isFloat(angle)) {
	angle2 = __floatVal(angle);
    } else if (__isShortFloat(angle)) {
	angle2 = __shortFloatVal(angle);
    } else goto bad;

    if (angle2 <= 0) {
	RETURN (self);
    }

    if (__isExternalAddressLike(aDC)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height))
     {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	HBRUSH hBrush, prevBrush;
	HPEN prevPen = 0;
	COLORREF fgColor;
	int hatch, hasHatch;

	w = __intVal(width);
	h = __intVal(height);
	__x = __intVal(x);
	__y = __intVal(y);

	fgColor = GetTextColor(hDC);

	hasHatch= 1;

	if (hatchSymbol == @symbol(none)) {
	    hasHatch= 0;
	} else if (hatchSymbol == @symbol(horizontal)) {
	    hatch= HS_HORIZONTAL;
	} else if (hatchSymbol == @symbol(vertical)) {
	    hatch= HS_VERTICAL;
	} else if (hatchSymbol == @symbol(cross)) {
	    hatch= HS_CROSS;
	} else if (hatchSymbol == @symbol(bDiagonal)) {
	    hatch= HS_BDIAGONAL;
	} else if (hatchSymbol == @symbol(fDiagonal)) {
	    hatch= HS_FDIAGONAL;
	} else if (hatchSymbol == @symbol(diagonalCross)) {
	    hatch= HS_DIAGCROSS;
	} else
	    hasHatch= 0;

	if (hasHatch) {
	    hBrush = CreateHatchBrush(hatch, fgColor);
	} else {
	    hBrush = CreateSolidBrush(fgColor);
	}

	prevBrush = SelectObject(hDC, hBrush);
	if (hBrush == 0) {
	    DPRINTF(("fillArc: no brush\n"));
	} else {
	    HPEN hPen = 0;

	    if (0 /* __isWinNT */) {
		fgColor = GetTextColor(hDC);
		hPen = CreatePen(PS_SOLID, 1, fgColor);
		prevPen = SelectObject(hDC, hPen);
		if (hPen == 0) {
		    DPRINTF(("fillArc: no pen\n"));
		    goto failpen;
		}
	    } else {
		prevPen = SelectObject(hDC, GetStockObject(NULL_PEN));
		w++;
		h++;
	    }

	    {
		double xB, yB, xE, yE, xR, yR;

		xR = w / 2;
		yR = h / 2;
		if (angle2 - angle1 >= 360) {
		    xB = xE = __x + xR + 0.5;
		    yB = yE = __y /*+ yR + 0.5*/;
		} else {
		    double sin(), cos();
		    float rad1, rad2;

		    if (angle1 <= 180)
			angle1 = 180 - angle1;
		    else
			angle1 = 360 + 180 - angle1;
		    angle2 = angle1 - angle2;
		    /* sigh - compute the intersections ... */
		    rad1 = (angle1 * 3.14159265359) / 180.0;
		    rad2 = (angle2 * 3.14159265359) / 180.0;
		    xB = cos(rad1) * xR;
		    yB = sin(rad1) * yR;
		    xE = cos(rad2) * xR;
		    yE = sin(rad2) * yR;
		    xB = __x + xR - xB + 0.5;
		    yB = __y + yR - yB + 0.5;
		    xE = __x + xR - xE + 0.5;
		    yE = __y + yR - yE + 0.5;
		}
		DPRINTF(("fillArc x=%d y=%d w=%d h=%d xB=%d xE=%d yB=%d yE=%d a1=%f a2=%f\n",__x,__y,w,h,(int)xB,(int)xE,(int)yB,(int)yE,angle1,angle2));

		Pie(hDC,
		    __x, __y,
		    __x + w + 1, __y + h + 1,
		    (int)xB, (int)yB,
		    (int)xE, (int)yE);

		if (hPen) {
		    DeleteObject(hPen);
		}
	    }
failpen:
	    if (prevPen) SelectObject(hDC, prevPen);
	    DeleteObject(hPen);

	    SelectObject(hDC, prevBrush);
	    DeleteObject(hBrush);
	}
	RETURN ( self );
    }
    bad: ;
%}.
    self primitiveFailed
!

fillPolygon:aPolygon in:ignoredDrawableId with:aGCId
    "fill a polygon given by its points.
     If any coordinate is not integer, an error is triggered."

    |numberOfPoints|

    numberOfPoints := aPolygon size.
    self
	primFillPolygon:aPolygon n:numberOfPoints
	in:ignoredDrawableId with:aGCId
!

fillRectangleX:x y:y width:width height:height in:ignoredDrawableId with:aDC
    "fill a rectangle. If any coordinate is not integer, an error is triggered."

    |hatchSymbol|

    hatchSymbol := self hatch.

%{  /* NOCONTEXT */

    int w, h;
    if (__isExternalAddressLike(aDC)
     && __bothSmallInteger(x, y)
     && __bothSmallInteger(width, height)) {
	w = __intVal(width);
	h = __intVal(height);

	if ((w >= 0) && (h >= 0)) {
	    HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	    HBRUSH hBrush, prevBrush;
	    RECT rct;
	    COLORREF fgColor;
	    int hatch, hasHatch;

	    fgColor = GetTextColor(hDC);
	    hasHatch= 1;

	    if (hatchSymbol == @symbol(none)) {
		hasHatch= 0;
	    } else if (hatchSymbol == @symbol(horizontal)) {
		hatch= HS_HORIZONTAL;
	    } else if (hatchSymbol == @symbol(vertical)) {
		hatch= HS_VERTICAL;
	    } else if (hatchSymbol == @symbol(cross)) {
		hatch= HS_CROSS;
	    } else if (hatchSymbol == @symbol(bDiagonal)) {
		hatch= HS_BDIAGONAL;
	    } else if (hatchSymbol == @symbol(fDiagonal)) {
		hatch= HS_FDIAGONAL;
	    } else if (hatchSymbol == @symbol(diagonalCross)) {
		hatch= HS_DIAGCROSS;
	    } else
		hasHatch= 0;

	    if (hasHatch) {
		hBrush = CreateHatchBrush(hatch, fgColor);
	    } else {
		hBrush = CreateSolidBrush(fgColor);
	    }

	    rct.left = __intVal(x);
	    rct.top  = __intVal(y);
	    rct.right  = rct.left + w; // + 1;
	    rct.bottom = rct.top  + h; // + 1;

	   prevBrush = SelectObject(hDC, hBrush);
	   FillRect(hDC, &rct, hBrush);
	   SelectObject(hDC, prevBrush);
	   DeleteObject(hBrush);

	}
    }
    RETURN ( self );


%}
!

primFillPolygon:aPolygon n:numberOfPoints in:ignoredDrawableId with:aDC

    |hatchSymbol|

    hatchSymbol := self hatch.

%{
    OBJ point, px, py;
    int i, num;

    if (__isExternalAddressLike(aDC)
     && __isSmallInteger(numberOfPoints)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	POINT p;
	HBRUSH hBrush, prevBrush;
	COLORREF fgColor;
	int hatch, hasHatch;

	num = __intVal(numberOfPoints);
	if (num < 3) {
	    RETURN ( self );
	}
	for (i=0; i<num; i++) {
	    point = __AT_(aPolygon, __MKSMALLINT(i+1));
	    if (! __isPoint(point)) goto fail;
	    px = _point_X(point);
	    py = _point_Y(point);
	    if (! __bothSmallInteger(px, py))
		goto fail;
	}

	fgColor = GetTextColor(hDC);
	hasHatch= 1;

	if (hatchSymbol == @symbol(none)) {
	    hasHatch= 0;
	} else if (hatchSymbol == @symbol(horizontal)) {
	    hatch= HS_HORIZONTAL;
	} else if (hatchSymbol == @symbol(vertical)) {
	    hatch= HS_VERTICAL;
	} else if (hatchSymbol == @symbol(cross)) {
	    hatch= HS_CROSS;
	} else if (hatchSymbol == @symbol(bDiagonal)) {
	    hatch= HS_BDIAGONAL;
	} else if (hatchSymbol == @symbol(fDiagonal)) {
	    hatch= HS_FDIAGONAL;
	} else if (hatchSymbol == @symbol(diagonalCross)) {
	    hatch= HS_DIAGCROSS;
	} else
	    hasHatch= 0;

	if (hasHatch) {
	    hBrush = CreateHatchBrush(hatch, fgColor);
	} else {
	    hBrush = CreateSolidBrush(fgColor);
	}

	if (hBrush == 0) {
	    DPRINTF(("fillPolygon: no brush\n"));
	} else {
	    HPEN prevPen;

	    prevBrush = SelectObject(hDC, hBrush);
	    prevPen = SelectObject(hDC, GetStockObject(NULL_PEN));

	    BeginPath(hDC);

	    for (i=0; i<num; i++) {
		point = __AT_(aPolygon, __MKSMALLINT(i+1));
		px = _point_X(point);
		py = _point_Y(point);
		if (i == 0) {
		    MoveToEx(hDC, __intVal(px), __intVal(py), NULL);
		} else {
		    if (i == (num-1)) {
			p.x = __intVal(px);
			p.y = __intVal(py);
			PolylineTo(hDC, &p, 1);
		    } else {
			LineTo(hDC, __intVal(px), __intVal(py));
		    }
		}
	    }

	    EndPath(hDC);
	    FillPath(hDC);
	    SelectObject(hDC, prevPen);
	    SelectObject(hDC, prevBrush);
	    DeleteObject(hBrush);
	}
	RETURN ( self );

fail: ;
    }
%}
!

scaleTest_displayString:aString x:x y:y
    "draw a string at the coordinate x/y -
     draw foreground-pixels only (in current paint-color),
     leaving background as-is. If the transformation involves scaling,
     the fonts point-size is scaled as appropriate."

    |id pX pY fontUsed sz s fontsEncoding|

    "hook for non-strings (i.e. attributed text)"
    (aString isString not
    or:[aString isText]) ifTrue:[
	^ aString displayOn:self x:x y:y
    ].

    self gcId isNil ifTrue:[
	self initGC
    ].

    fontUsed := self font.
    self transformation notNil ifTrue:[
	pX := self transformation applyToX:x.
	pY := self transformation applyToY:y.
	self transformation noScale ifFalse:[
	    sz := self font size.
	    sz isNil ifTrue:[
		"/ oops - not a real font; use original font
		fontUsed := self font.
	    ] ifFalse:[ |yS|
		yS := self pixelsPerInchOfScreenHeight / Screen current verticalPixelPerInch.
		yS := self scale y / yS.
		fontUsed := self font size:(sz * yS) rounded.
	    ]
	]
    ] ifFalse:[
	pX := x.
	pY := y.
    ].
    pX := pX rounded.
    pY := pY rounded.

    s := aString.
    fontUsed := fontUsed onDevice:self device.
    fontsEncoding := fontUsed encoding.
    (self characterEncoding ~~ fontsEncoding) ifTrue:[
	[
	    s := CharacterEncoder encodeString:s from:self characterEncoding into:fontsEncoding.
	] on:CharacterEncoderError do:[:ex|
	    "substitute a default value for codes that cannot be represented
	     in the new character set"
	    ex proceedWith:ex defaultValue.
	].
    ].

    id := fontUsed fontId.
    id isNil ifTrue:[
	"hook for alien fonts"
	fontUsed displayString:s x:x y:y in:self
    ] ifFalse:[
	self deviceFont ~~ fontUsed ifTrue:[
	    self device setFont:id in:self gcId.
	    self deviceFont: fontUsed
	].
	self device displayString:s x:pX y:pY in:self drawableId with:self gcId
    ]

    "Modified: 1.7.1997 / 17:08:35 / cg"
! !

!WinPrinterContext methodsFor:'drawing bitmaps'!

bitsBlue
    "return the number of valid bits in the red component."

"/    bitsRed isNil ifTrue:[
"/        "/ not a truecolor display
"/        ^ bitsPerRGB
"/    ].
"/    ^ bitsRed

     ^Display bitsBlue
!

bitsGreen
    "return the number of valid bits in the red component."

"/    bitsRed isNil ifTrue:[
"/        "/ not a truecolor display
"/        ^ bitsPerRGB
"/    ].
"/    ^ bitsRed

     ^Display bitsGreen
!

bitsRed
    "return the number of valid bits in the red component."

"/    bitsRed isNil ifTrue:[
"/        "/ not a truecolor display
"/        ^ bitsPerRGB
"/    ].
"/    ^ bitsRed

     ^Display bitsRed
!

compressColorMapImage: image
    "calculates a new color map for the image, using only used colors"

    |depth newColorMap newImage oldImage usedColors oldToNew oldBits newBits tmpBits|

    oldImage := image.
    depth := oldImage depth.

    oldImage photometric ~~ #palette ifTrue:[
	Transcript showCR:'Compress colorMap: Only palette images have colormaps.'.
	^ image
    ].

    usedColors := oldImage realUsedColors.
    usedColors size == (1 bitShift:depth) ifTrue:[
	Transcript showCR:'Compress colorMap: All colors are used - no compression.'.
	^ image
    ].
    usedColors size == oldImage colorMap size ifTrue:[
	Transcript showCR:'Compress colorMap: Colormap already compressed - no compression.'.
	^ image
    ].

	"/ translation table
	oldToNew := ByteArray new:(1 bitShift:depth).
	newColorMap := usedColors asArray.
	newColorMap sort:self sortBlockForColors.

	oldImage colorMap asArray keysAndValuesDo:[:oldIdx :clr |
	    |newPixel|

	    (usedColors includes:clr) ifTrue:[
		newPixel := newColorMap indexOf:clr.
		oldToNew at:oldIdx put:newPixel-1.
	    ]
	].

	oldBits := oldImage bits.
	newBits := ByteArray new:(oldBits size).
	depth ~~ 8 ifTrue:[
	    "/ expand/compress can only handle 8bits
	    tmpBits := ByteArray uninitializedNew:(oldImage width*oldImage height).
	    oldBits
		expandPixels:depth
		width:oldImage width
		height:oldImage height
		into:tmpBits
		mapping:oldToNew.
	    tmpBits
		compressPixels:depth
		width:oldImage width
		height:oldImage height
		into:newBits
		mapping:nil
	] ifFalse:[
	    oldBits
		expandPixels:depth
		width:oldImage width
		height:oldImage height
		into:newBits
		mapping:oldToNew.
	].

	newImage := oldImage species new
			width:oldImage width
			height:oldImage height
			depth:depth
			fromArray:newBits.

	newImage colorMap:newColorMap.
	newImage fileName:oldImage fileName.
	newImage mask:(oldImage mask copy).

	^ newImage

    "Created: / 28.7.1998 / 20:03:11 / cg"
    "Modified: / 15.9.1998 / 17:53:32 / cg"
!

copyFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId
		width:w height:h
    "do a bit-blt; copy bits from the rectangle defined by
     srcX/srcY and w/h from the sourceId drawable to the rectangle
     below dstX/dstY in the destId drawable. Trigger an error if any
     argument is not integer."

     | function |

     function := self function.

%{
    int     dstGcOwnerThreadID;
    HWND    dstGcHWIN;
    HBITMAP dstGcHBITMAP;

    if (! __isExternalAddressLike(srcGCId)
     || ! __isExternalAddressLike(dstGCId)) {
	goto fail;
    }

    if (__bothSmallInteger(w, h)
     && __bothSmallInteger(srcX, srcY)
     && __bothSmallInteger(dstX, dstY)) {
	HANDLE srcDC = (HANDLE)(__externalAddressVal(srcGCId));
	HANDLE dstDC = (HANDLE)(__externalAddressVal(dstGCId));

	int fun;
	OBJ aFunctionSymbol;
	int src_fg, src_bg, dst_fg, dst_bg;
	char buf[5];

//          fun = dstGcData->bitbltrop2;

	aFunctionSymbol= function;

	if (aFunctionSymbol == @symbol(copy)) {
	    fun = SRCCOPY /* R2_COPYPEN */ ;
/*            bfun = BITBLT_COPY;                                          */
	} else if (aFunctionSymbol == @symbol(copyInverted)) {
	    fun = NOTSRCCOPY /* R2_NOTCOPYPEN */;
/*            bfun = BITBLT_COPYINVERTED;                                  */
	} else if (aFunctionSymbol == @symbol(xor)) {
	    fun = SRCINVERT /* R2_XORPEN */;
/*            bfun = BITBLT_XOR;                                           */
	} else if (aFunctionSymbol == @symbol(and)) {
	    fun = SRCAND /* R2_MASKPEN */ ;
/*            bfun = BITBLT_AND;                                           */
	} else if (aFunctionSymbol == @symbol(or)) {
	    fun = MERGECOPY /* R2_MERGEPEN */ ;
/*            bfun = BITBLT_OR;                                            */
	}

    // convert 123 to string [buf]
    // itoa(fun, buf, 10);

    //        console_printf(" ", buf);

/*
#if 0
	switch (fun) {
	  case BITBLT_COPY:
	    console_printf("BITBLT_COPY\n");
	    break;
	  case BITBLT_COPYINVERTED:
	    console_printf("BITBLT_COPYINVERTED\n");
	    break;
	  case BITBLT_XOR:
	    console_printf("BITBLT_XOR\n");
	    break;
	  case BITBLT_AND:
	    console_printf("BITBLT_AND\n");
	    break;
	  case BITBLT_OR:
	    console_printf("BITBLT_OR\n");
	    break;
	}
#endif
*/

//          fun = dstGcData->bitbltrop2;

	if (0 /* fun == BITBLT_COPY */) {
	    src_fg = dst_fg = 0xFFFFFF;
	    src_bg = dst_bg = 0x000000;
	} else {
	    src_fg = GetTextColor(srcDC) /* srcGcData->fgColor */;
	    src_bg = GetBkColor(dstDC) /* srcGcData->bgColor */;
	    dst_fg = GetTextColor(srcDC) /* dstGcData->fgColor */;
	    dst_bg = GetBkColor(dstDC) /* dstGcData->bgColor */;
	}

	SetBkColor(dstDC, dst_fg);
	SetTextColor(dstDC, dst_bg);

	SetBkColor(srcDC, src_fg);
	SetTextColor(srcDC, src_bg);

/*
	CPRINTF(("bitblt src f:%x b:%x",GetTextColor(srcDC),GetBkColor(srcDC)));
	CPRINTF(("dst f:%x b:%x\n",GetTextColor(dstDC),GetBkColor(dstDC)));
*/
	if (BitBlt(dstDC,
	     __intVal(dstX), __intVal(dstY),
	     __intVal(w), __intVal(h),
	     srcDC,
	     __intVal(srcX), __intVal(srcY),
	     fun)
	   == 0
	  ) {
	    console_fprintf(stderr, "WinWorkstation [info]: ERROR in BitBlt\n");
	}

/*
	if (dstGcData != srcGcData) {
	    SetBkColor(dstDC, dstGcData->bgColor);
	    SetTextColor(dstDC, dstGcData->fgColor);
	}
	SetBkColor(srcDC, srcGcData->bgColor);
	SetTextColor(srcDC, srcGcData->fgColor);
*/

/*
	if (srcGcData != dstGcData) {
	    _releaseDC(srcGcData);
	}
	_releaseDC(dstGcData);
*/
	RETURN ( self );
    }

 fail: ;
%}.
    self primitiveFailed.
    ^ nil
!

copyFromPixmapId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt from a pix- or bitmap.
     Here, fall back into copyFromId:, which should also work.
     Subclasses may redefine this for more performance or if required"

    ^ self copyFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
!

copyPlaneFromId:sourceId x:srcX y:srcY gc:srcDCId to:destId x:dstX y:dstY gc:dstDCId
		width:w height:h
    "do a bit-blt, but only copy the low-bit plane;
     copy bits from the rectangle defined by
     srcX/srcY and w/h from the sourceId drawable to the rectangle
     below dstX/dstY in the destId drawable. Trigger an error if any
     argument is not integer."

    ^ self
	copyFromId:sourceId
		 x:srcX y:srcY gc:srcDCId
		to:destId x:dstX y:dstY gc:dstDCId
	     width:w height:h
!

copyPlaneFromPixmapId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
    "do a bit-blt from a pix- or bitmap, using the low-bit plane of the source only.
     Here, fall back into copyPlaneFromId:, which should also work.
     Subclasses may redefine this for more performance or if required"

    ^ self copyPlaneFromId:sourceId x:srcX y:srcY gc:srcGCId to:destId x:dstX y:dstY gc:dstGCId width:w height:h
!

createBitmapFromArray:anArray width:w height:h
    |bitmapId|


    bitmapId := self primCreateBitmapFromArray:anArray width:w height:h.

    bitmapId isNil ifTrue:[
	'WINWORKSTATION: cannot create bitmap' errorPrintCR.
    ].
    ^ bitmapId
!

createPixmapWidth:w height:h depth:d
    "allocate a pixmap on the Xserver, the contents is undefined
     (i.e. random). Return a bitmap id or nil"

%{
    HANDLE newBitmapHandle;
    HANDLE rootDC = CreateDC("DISPLAY", NULL, NULL, NULL);

    /*console_printf("CreateBitmap Color\n");*/
    if (__bothSmallInteger(w, h) && __isSmallInteger(d) /*&& ISCONNECTED */) {
	if (__intVal(d) == 1) {
	    newBitmapHandle = CreateBitmap(__intVal(w), __intVal(h) , 1, 1, NULL);
	} else {
#if 0
	    if (__intVal(d) != __depth) {
		console_printf("invalid depth\n");
		RETURN (nil);
	    }
#endif
	    newBitmapHandle = CreateCompatibleBitmap(rootDC, __intVal(w), __intVal(h) );
	}

	if (newBitmapHandle) {
	    RETURN ( __MKEXTERNALADDRESS(newBitmapHandle));
	}
/*
	DPRINTF(("empty bitmap handle = %x\n", newBitmapHandle));
*/
    }
    RETURN (nil);
%}
!

destroyPixmap:aDrawableId

%{  /* NOCONTEXT */
    if (__isExternalAddress(aDrawableId) /* && ISCONNECTED */ ) {
	HANDLE bitmapHandle = _HANDLEVal(aDrawableId);

	if (bitmapHandle) {
	    DeleteObject(bitmapHandle);
	/*    _DeleteObject(bitmapHandle, __LINE__);    */
	}
    }
%}
!

displayDeviceForm:aForm x:x y:y

    |sortedImage formMask bitsWithTransparency redVector greenVector blueVector|

    sortedImage := aForm.

    "Image 16 bits"
    aForm depth = 16 ifTrue:[
	bitsWithTransparency := aForm bits.
    ].
    "Image 24 and 32 bits"
    aForm depth >= 24 ifTrue:[
	|bestFormat|
	bestFormat := aForm bestSupportedImageFormatFor: Display.
	bitsWithTransparency := aForm rgbImageBitsOn: Display bestFormat: bestFormat.
    ].
    "Image up to 8 bits"
    aForm depth <= 8 ifTrue:[
	aForm depth < 8 ifTrue:[
	    sortedImage := aForm asImageWithDepth: 8.
	].
"/        sortedImage := self sortColorMapImage: aForm.
	sortedImage := self compressColorMapImage: sortedImage.

	formMask := sortedImage mask.
	formMask isNil
	    ifTrue:[bitsWithTransparency := sortedImage bits ]
	    ifFalse:[
		|bitsWithTransparencySize|
		formMask := formMask asImageWithDepth: sortedImage depth.
		bitsWithTransparency := sortedImage bits copy.
		bitsWithTransparencySize := bitsWithTransparency size.
		formMask bits doWithIndex:[:maskBit :index |
		    bitsWithTransparencySize >= index ifTrue:[
			maskBit == 0 ifTrue:[bitsWithTransparency at: index put: 255 "60" "bitClearAt: index"].
"/                    maskBit == 1 ifTrue:[bitsWithTransparency at: index put: (bitsWithTransparency at: index)].
		    ].
		].
	].

	redVector := sortedImage colorMap redVector.
	greenVector := sortedImage colorMap greenVector.
	blueVector := sortedImage colorMap blueVector.
    ].

    self
	 drawBits: bitsWithTransparency
	redVector: redVector
      greenVector: greenVector
       blueVector: blueVector
     bitsPerPixel: sortedImage bitsPerPixel
	    depth: sortedImage depth
	    width: sortedImage width
	   height: sortedImage height
	     into: self id
		x: x
		y: y
	    width: sortedImage width
	   height: sortedImage height
	     with: self gcId.
!

drawBits:imageBits bitsPerPixel:bitsPerPixel depth:imageDepth padding:padd
			  width:imageWidth height:imageHeight
			      x:srcx y:srcy
			   into:ignoredDrawableId
			      x:dstx y:dsty
			  width:w height:h
			   with:aGCId

    "draw a bitImage which has depth id, width iw and height ih into
     the drawable. draw a region of w/h pixels from srcx/srcy to dstx/dsty.
     Individual source pixels have bitsPerPixel bits, allowing to draw
     depth and pixel-units to be different.
     It has to be checked elsewhere, that the server can do it with the given
     depth - otherwise, primitive failure will be signalled.
     Also it is assumed, that the colormap is setup correctly and the
     colors are allocated - otherwise the colors may be wrong."

    "
     sorry; I had to separate it into 2 methods, since XPutImage needs
     an unlimited stack, and thus cannot send primitiveFailed
    "
    (self primDrawBits:imageBits bitsPerPixel:bitsPerPixel depth:imageDepth padding:padd
					width:imageWidth height:imageHeight
					     x:srcx y:srcy
					  into:ignoredDrawableId
					     x:(dstx rounded) y:(dsty rounded)
					 width:w height:h
					  with:aGCId)
    ifFalse:[
	"
	 also happens, if a segmentation violation occurs in the
	 XPutImage ...
	"
	self primitiveFailed
    ].
!

drawBits:imageBits redVector:redVector greenVector:greenVector blueVector:blueVector bitsPerPixel:bitsPerPixel depth:imageDepth
			      width:imageWidth height:imageHeight
			       into:ignoredDrawableId
				  x:dstx y:dsty
			      width:w height:h
			       with:aGCId

    "draw a bitImage which has depth id, width iw and height ih into
     the drawable. draw a region of w/h pixels from srcx/srcy to dstx/dsty.
     Individual source pixels have bitsPerPixel bits, allowing to draw
     depth and pixel-units to be different.
     It has to be checked elsewhere, that the server can do it with the given
     depth - otherwise, primitive failure will be signalled.
     Also it is assumed, that the colormap is setup correctly and the
     colors are allocated - otherwise the colors may be wrong."

    "
     sorry; I had to separate it into 2 methods, since XPutImage needs
     an unlimited stack, and thus cannot send primitiveFailed
    "
    (self primDrawBits:imageBits redVector:redVector greenVector:greenVector blueVector:blueVector bitsPerPixel:bitsPerPixel depth:imageDepth
			      width:imageWidth height:imageHeight
			       into:ignoredDrawableId
				  x:(dstx rounded) y:(dsty rounded)
			      width:w height:h
			       with:aGCId)
    ifFalse:[
	self primitiveFailed
    ].
!

primCreateBitmapFromArray:anArray width:w height:h
%{

    HBITMAP newBitmapHandle;
    int b_width, b_height, bytesPerRowST, bytesPerRowWN, padding;
    int row, col;
    unsigned char *cp, *bPits;
    unsigned char *b_bits = 0;
    int index;
    OBJ num;
    unsigned char *allocatedBits = 0;
    unsigned char fastBits[10000];

    if (__bothSmallInteger(w, h)
     && __isNonNilObject(anArray)) {
	OBJ cls = __qClass(anArray);

	b_width = __intVal(w);
	b_height = __intVal(h);
	bytesPerRowST = (b_width + 7) / 8;
	bytesPerRowWN = ((b_width + 15) / 16) * 2;
	padding = bytesPerRowWN - bytesPerRowST;

	if ((padding == 0) && (cls == @global(ByteArray))) {
	    b_bits = __ByteArrayInstPtr(anArray)->ba_element;
	    cp = 0;
	} else {
	    int nBytes = b_height * bytesPerRowWN;

	    if (nBytes < sizeof(fastBits)) {
		cp = b_bits = fastBits;
	    } else {
		cp = b_bits = allocatedBits = (unsigned char *) malloc(nBytes);
		if (! cp) goto fail;
	    }
	}
	if (cp) {
	    if (__qIsArrayLike(anArray)) {
		OBJ *op;

		index = 1;
		op = &(__ArrayInstPtr(anArray)->a_element[index - 1]);
		for (row = b_height; row; row--) {
		    for (col = bytesPerRowST; col; col--) {
			num = *op++;
			if (! __isSmallInteger(num))
			    goto fail;
			*cp++ = __intVal(num);
		    }
		    cp += padding;
		}
	    } else if (__qIsByteArrayLike(anArray)) {
		unsigned char *pBits;

		pBits = __ByteArrayInstPtr(anArray)->ba_element;
		for (row = b_height; row; row--) {
		    for (col = bytesPerRowST; col; col--) {
			*cp++ = ( *pBits++ /*^ 0xFF*/ );
		    }
		    cp += padding;
		}
	    } else {
		goto fail;
	    }
	}
/*
	CPRINTF(("create bitmap ...\n"));
*/
	newBitmapHandle = CreateBitmap(b_width, b_height, 1, 1, b_bits );

	if (newBitmapHandle ) {
/*
	    DDPRINTF(("returning bitmap %x ...\n", newBitmapHandle));
*/
	    if (allocatedBits) {
		free(allocatedBits);
	    }
	    RETURN ( __MKEXTERNALADDRESS(newBitmapHandle));
	}
    }
fail: ;
/*
    DDPRINTF(("create bitmap FAILED!!!\n"));
*/
    if (allocatedBits) {
/*
	CPRINTF(("freeing up bitmap bits ...\n"));
*/
	free(allocatedBits);
    }
/*
    CPRINTF(("returning nil ...\n"));
*/
    RETURN ( nil );
%}
!

primDrawBits:imageBits bitsPerPixel:bitsPerPixel depth:imageDepth padding:padd
			      width:imageWidth height:imageHeight
				  x:srcx y:srcy
			       into:ignoredDrawableId
				  x:dstx y:dsty
			      width:w height:h
			       with:aGCId

    "since XPutImage may allocate huge amount of stack space
     (some implementations use alloca), this must run with unlimited stack."

    | drawableId |

    drawableId := self drawableId.
%{
    unsigned char fastBits[10000];
    unsigned char *b_bits = 0;
    unsigned char *allocatedBits = 0;
    unsigned char *__imageBits = 0;

    if (__isByteArray(imageBits)) {
	__imageBits = __ByteArrayInstPtr(imageBits)->ba_element;
    } else if (__isExternalBytesLike(imageBits)) {
	__imageBits = (unsigned char *)(__externalBytesAddress(imageBits));
    }

    if (/* ISCONNECTED
     && */ __isExternalAddressLike(aGCId)
     && __bothSmallInteger(srcx, srcy)
     && __bothSmallInteger(dstx, dsty)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(imageWidth, imageHeight)
     && __bothSmallInteger(imageDepth, bitsPerPixel)
     && __isSmallInteger(padd)
     && __imageBits)
     {
	struct
	{
	  BITMAPINFOHEADER bmiHeader;
	  DWORD r;
	  DWORD g;
	  DWORD b;
	} bitmap;

	HANDLE hDC = (HANDLE)(__externalAddressVal(aGCId));
	HBITMAP hBitmap = _HBITMAPVAL(drawableId);

/*
	DDPRINTF(("hDC = %x\n", hDC));
*/
	if (__intVal(padd) != WIN32PADDING) {
	    int row, col;
	    unsigned char *cp;
	    unsigned char *pBits;
	    int b_width, b_height, bytesPerRowST, bytesPerRowWN, padding, nBytes;
	    int bi = __intVal(bitsPerPixel);

	    b_width = __intVal(w);
	    b_height = __intVal(h);
	    bytesPerRowST = (b_width * bi + (__intVal(padd)-1)) / __intVal(padd);
	    bytesPerRowWN = (b_width * bi + (WIN32PADDING-1)) / WIN32PADDING * (WIN32PADDING/8);
	    padding = bytesPerRowWN - bytesPerRowST;
	    nBytes = b_height * bytesPerRowWN;
	    /*console_printf("padd %d bs %d bw %d p %d\n",__intVal(padd),bytesPerRowST,bytesPerRowWN,padding);*/
	    if (padding) {
		if (nBytes < sizeof(fastBits)) {
		    cp = b_bits = fastBits;
		} else {
		    cp = b_bits = allocatedBits = (unsigned char *) malloc(nBytes);
		}
		if (cp) {
		    pBits = __imageBits;
		    for (row = b_height; row; row--) {
			for (col = bytesPerRowST; col; col--) {
			    *cp++ = *pBits++;
			}
			cp += padding;
		    }
		} else
		    goto fail;
	    }
	}

	if (b_bits == 0) {
	    b_bits = __imageBits;
	}

	bitmap.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	bitmap.bmiHeader.biPlanes = 1;
	if (__intVal(imageDepth) == 24) {
	    /*bitmap.bmiHeader.biCompression = BI_BITFIELDS;
	    bitmap.r = 0xff0000;
	    bitmap.g = 0x00ff00;
	    bitmap.b = 0x0000ff;*/
	    bitmap.bmiHeader.biCompression = BI_RGB;
	} else if (__intVal(imageDepth) == 16) {
	    /*bitmap.bmiHeader.biCompression = BI_RGB;
	    bitmap.bmiHeader.biCompression = BI_BITFIELDS;
	    bitmap.b = 0x001f;
	    bitmap.g = 0x07e0;
	    bitmap.r = 0xf800;*/
	    bitmap.b = 0;
	    bitmap.g = 0;
	    bitmap.r = 0;
	    bitmap.bmiHeader.biCompression = BI_RGB;
	}
	bitmap.bmiHeader.biSizeImage = 0;
	bitmap.bmiHeader.biXPelsPerMeter = 0;
	bitmap.bmiHeader.biYPelsPerMeter = 0;
	bitmap.bmiHeader.biClrUsed = 0;
	bitmap.bmiHeader.biClrImportant = 0;
	bitmap.bmiHeader.biWidth = __intVal(imageWidth);
	bitmap.bmiHeader.biHeight = -(__intVal(imageHeight));
	bitmap.bmiHeader.biBitCount = __intVal(bitsPerPixel);
	/*console_printf("drawBits depth:%d bitsPerPixel:%d IW%d W:%d H:%d\n",__intVal(imageDepth),bitmap.bmiHeader.biBitCount,bitmap.bmiHeader.biWidth,__intVal(w),bitmap.bmiHeader.biHeight);*/

	SetDIBitsToDevice(hDC,__intVal(dstx),__intVal(dsty),
			      __intVal(w), __intVal(h),
			      __intVal(srcx), __intVal(srcy),
			      0,__intVal(h),
			      (void *)b_bits,
			      (BITMAPINFO*)&bitmap,DIB_RGB_COLORS);

/*
	SetDIBits(hDC,hBitmap,
			      0,__intVal(h),
			      (void *)b_bits,
			      (BITMAPINFO*)&bitmap,DIB_RGB_COLORS);
*/
/*
	StretchDIBits(hDC,
		      __intVal(dstx),(__intVal(dsty)),            //  x & y coord of destination upper-left corner
		      __intVal(w), __intVal(h),                 // width & height of destination rectangle
		      __intVal(srcx), __intVal(srcy),           // x & y coord of source upper-left corner
		      __intVal(w), __intVal(h),                 // width & height of source rectangle
		      (void *)b_bits,                           // bitmap bits
		      (BITMAPINFO*)&bitmap,                     // bitmap data
		      DIB_RGB_COLORS,                           // usage options
		      SRCCOPY                                   // raster operation code
	);
*/
	if (allocatedBits) {
	    free(allocatedBits);
	}
/*
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
*/
	RETURN ( true );
    }

fail: ;
/*
    PRINTF(("create temp bitmap FAILED!!!\n"));
*/
    if (allocatedBits) {
/*
	PRINTF(("freeing up temp bitmap bits ...\n"));
*/
	free(allocatedBits);
    }
/*
#ifndef CACHE_LAST_DC
    if (hDC) {
	_releaseDC(gcData);
    }
#endif
*/
%}
.
    ^ false
!

primDrawBits:imageBits redVector:redVector greenVector:greenVector blueVector:blueVector bitsPerPixel:bitsPerPixel depth:imageDepth
			      width:imageWidth height:imageHeight
			       into:ignoredDrawableId
				  x:dstx y:dsty
			      width:w height:h
			       with:aGCId

    "since XPutImage may allocate huge amount of stack space
     (some implementations use alloca), this must run with unlimited stack."

    | drawableId |

    drawableId := self drawableId.

%{
    unsigned char fastBits[10000];
    unsigned char *b_bits = 0;
    unsigned char *allocatedBits = 0;
    unsigned char *__imageBits = 0;
    unsigned char *__redVector = 0;
    unsigned char *__greenVector = 0;
    unsigned char *__blueVector = 0;
    int padd = 8;

    if (__isByteArray(imageBits)) {
	__imageBits = __ByteArrayInstPtr(imageBits)->ba_element;
    } else if (__isExternalBytesLike(imageBits)) {
	__imageBits = (unsigned char *)(__externalBytesAddress(imageBits));
    }

    if (__isByteArray(redVector)) {
	__redVector = __ByteArrayInstPtr(redVector)->ba_element;
    } else if (__isExternalBytesLike(redVector)) {
	__redVector = (unsigned char *)(__externalBytesAddress(redVector));
    }

    if (__isByteArray(greenVector)) {
	__greenVector = __ByteArrayInstPtr(greenVector)->ba_element;
    } else if (__isExternalBytesLike(greenVector)) {
	__greenVector = (unsigned char *)(__externalBytesAddress(greenVector));
    }

    if (__isByteArray(blueVector)) {
	__blueVector = __ByteArrayInstPtr(blueVector)->ba_element;
    } else if (__isExternalBytesLike(blueVector)) {
	__blueVector = (unsigned char *)(__externalBytesAddress(blueVector));
    }

    if (/* ISCONNECTED
     && */ __isExternalAddressLike(aGCId)
//     && __bothSmallInteger(srcx, srcy)
     && __bothSmallInteger(dstx, dsty)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(imageWidth, imageHeight)
     && __bothSmallInteger(imageDepth, bitsPerPixel)
     && __imageBits)
     {
	struct
	{
	  BITMAPINFOHEADER bmiHeader;
	  RGBQUAD bmiColors[256];
	} bitmap;

	HANDLE hDC = (HANDLE)(__externalAddressVal(aGCId));
	HBITMAP hBitmap = _HBITMAPVAL(drawableId);
	int col;
/*
	DDPRINTF(("hDC = %x\n", hDC));
*/

	if (padd != WIN32PADDING) {

	    int row, col;
	    unsigned char *cp;
	    unsigned char *pBits;
	    int b_width, b_height, bytesPerRowST, bytesPerRowWN, padding, nBytes;
	    int bi = __intVal(bitsPerPixel);

//            console_fprintf(stderr, "Non WIN32PADDING");

	    b_width = __intVal(w);
	    b_height = __intVal(h);
	    bytesPerRowST = (b_width * bi + (padd - 1 )) / padd;
	    bytesPerRowWN = (b_width * bi + (WIN32PADDING-1)) / WIN32PADDING * (WIN32PADDING/8);
	    padding = bytesPerRowWN - bytesPerRowST;
	    nBytes = b_height * bytesPerRowWN;
	    /*console_printf("padd %d bs %d bw %d p %d\n",__intVal(padd),bytesPerRowST,bytesPerRowWN,padding);*/
	    if (padding) {
		if (nBytes < sizeof(fastBits)) {
		    cp = b_bits = fastBits;
		} else {
		    cp = b_bits = allocatedBits = (unsigned char *) malloc(nBytes);
		}
		if (cp) {
		    pBits = __imageBits;
		    for (row = b_height; row; row--) {
			for (col = bytesPerRowST; col; col--) {
			    *cp++ = *pBits++;
			}
			cp += padding;
		    }
		} else
		    goto fail;
	    }
	}

	if (b_bits == 0) {
	    b_bits = __imageBits;
	}

	bitmap.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	bitmap.bmiHeader.biPlanes = 1;
	bitmap.bmiHeader.biCompression = BI_RGB;
	bitmap.bmiHeader.biSizeImage = 0;
	bitmap.bmiHeader.biXPelsPerMeter = 0;
	bitmap.bmiHeader.biYPelsPerMeter = 0;
	bitmap.bmiHeader.biClrUsed = 0;
	bitmap.bmiHeader.biClrImportant = 0;
	bitmap.bmiHeader.biWidth = __intVal(imageWidth);
	bitmap.bmiHeader.biHeight = -(__intVal(imageHeight));
	bitmap.bmiHeader.biBitCount = __intVal(bitsPerPixel);
	/*console_printf("drawBits depth:%d bitsPerPixel:%d IW%d W:%d H:%d\n",__intVal(imageDepth),bitmap.bmiHeader.biBitCount,bitmap.bmiHeader.biWidth,__intVal(w),bitmap.bmiHeader.biHeight);*/

	if (__intVal(imageDepth) <= 8) {
	    for(col=0;col<256;col++)
	     {
	      bitmap.bmiColors[col].rgbBlue = __blueVector[col];    // Microsoft idea: change rgbBlue to rgbRed
	      bitmap.bmiColors[col].rgbGreen = __greenVector[col];
	      bitmap.bmiColors[col].rgbRed = __redVector[col];         // Microsoft idea: change rgbRed to rgbBlue
	      bitmap.bmiColors[col].rgbReserved = 0;

	    }
	}

	bitmap.bmiColors[255].rgbBlue=255;
	bitmap.bmiColors[255].rgbGreen=255;
	bitmap.bmiColors[255].rgbRed =255;

	SetDIBitsToDevice(hDC,__intVal(dstx),__intVal(dsty),
			      __intVal(w), __intVal(h),
			      0, 0, /* __intVal(srcx), __intVal(srcy),    */
			      0,__intVal(h),
			      (void *)b_bits,
			      (BITMAPINFO*)&bitmap,DIB_RGB_COLORS);
/*
	SetDIBits(hDC,hBitmap,
			      0,__intVal(h),
			      (void *)b_bits,
			      (BITMAPINFO*)&bitmap,DIB_RGB_COLORS);
*/
/*
	StretchDIBits(hDC,
		      __intVal(dstx),(__intVal(dsty)),            //  x & y coord of destination upper-left corner
		      __intVal(w), __intVal(h),                 // width & height of destination rectangle
		      __intVal(srcx), __intVal(srcy),           // x & y coord of source upper-left corner
		      __intVal(w), __intVal(h),                 // width & height of source rectangle
		      (void *)b_bits,                           // bitmap bits
		      (BITMAPINFO*)&bitmap,                     // bitmap data
		      DIB_RGB_COLORS,                           // usage options
		      SRCCOPY                                   // raster operation code
	);
*/
	if (allocatedBits) {
	    free(allocatedBits);
	}
/*
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
*/
	RETURN ( true );
    }

fail: ;
/*
    PRINTF(("create temp bitmap FAILED!!!\n"));
*/
    if (allocatedBits) {
/*
	PRINTF(("freeing up temp bitmap bits ...\n"));
*/
	free(allocatedBits);
    }
/*
#ifndef CACHE_LAST_DC
    if (hDC) {
	_releaseDC(gcData);
    }
#endif
*/
%}
.
    ^ false
!

setFunction:aFunctionSymbol in:aGCId
    "set alu function to be drawn with"

    Transcript showCR: aFunctionSymbol printString.
    self function: aFunctionSymbol.

"/%{  /* NOCONTEXT */
"/
"/    if (__isExternalAddress(aGCId)) {
"/        struct gcData *gcData = _GCDATA(aGCId);
"/        int fun = -1;
"/        int bfun = -1;
"/
"/        if (aFunctionSymbol == @symbol(copy)) {
"/            fun = R2_COPYPEN;
"/            bfun = BITBLT_COPY;
"/        } else if (aFunctionSymbol == @symbol(copyInverted)) {
"/            fun = R2_NOTCOPYPEN;
"/            bfun = BITBLT_COPYINVERTED;
"/        } else if (aFunctionSymbol == @symbol(xor)) {
"/            fun = R2_XORPEN;
"/            bfun = BITBLT_XOR;
"/        } else if (aFunctionSymbol == @symbol(and)) {
"/            fun = R2_MASKPEN;
"/            bfun = BITBLT_AND;
"/        } else if (aFunctionSymbol == @symbol(or)) {
"/            fun = R2_MERGEPEN;
"/            bfun = BITBLT_OR;
"/        }
"/
"/        if (fun
!

setGraphicsExposures:aBoolean in:aGCId
    "set or clear the graphics exposures flag"
!

shiftBlue
    "return the number of valid bits in the red component."

"/    bitsRed isNil ifTrue:[
"/        "/ not a truecolor display
"/        ^ bitsPerRGB
"/    ].
"/    ^ bitsRed

     ^Display shiftBlue
!

shiftGreen
    "return the number of valid bits in the red component."

"/    bitsRed isNil ifTrue:[
"/        "/ not a truecolor display
"/        ^ bitsPerRGB
"/    ].
"/    ^ bitsRed

     ^Display shiftGreen
!

shiftRed
    "return the number of valid bits in the red component."

"/    bitsRed isNil ifTrue:[
"/        "/ not a truecolor display
"/        ^ bitsPerRGB
"/    ].
"/    ^ bitsRed

     ^Display shiftRed
!

sortBlockForColors

    ^ [:a :b |
	    a redByte == b redByte ifTrue:[
		a greenByte == b greenByte ifTrue:[
		    a blueByte < b blueByte
		] ifFalse:[
		    a greenByte < b greenByte
		]
	    ] ifFalse:[
		a redByte < b redByte
	    ]
      ].
!

sortColorMapImage: image
    "calculates a new color map for the image, sorting colors"

    |sortBlock depth newColorMap newImage oldImage usedColors oldToNew oldBits newBits tmpBits|

    sortBlock := self sortBlockForColors.
    oldImage := image.
    depth := oldImage depth.

    oldImage photometric ~~ #palette ifTrue:[
	Transcript showCR:'Compress colorMap: Only palette images have colormaps.'.
	^ image
    ].

    usedColors := oldImage realColorMap.


	"/ translation table
	oldToNew := ByteArray new:(1 bitShift:depth).
	newColorMap := usedColors asArray.
	newColorMap sort:sortBlock.

	oldImage colorMap asArray keysAndValuesDo:[:oldIdx :clr |
	    |newPixel|

	    (usedColors includes:clr) ifTrue:[
		newPixel := newColorMap indexOf:clr.
		oldToNew at:oldIdx put:newPixel-1.
	    ]
	].

	oldBits := oldImage bits.
	newBits := ByteArray new:(oldBits size).
	depth ~~ 8 ifTrue:[
	    "/ expand/compress can only handle 8bits
	    tmpBits := ByteArray uninitializedNew:(oldImage width*oldImage height).
	    oldBits
		expandPixels:depth
		width:oldImage width
		height:oldImage height
		into:tmpBits
		mapping:oldToNew.
	    tmpBits
		compressPixels:depth
		width:oldImage width
		height:oldImage height
		into:newBits
		mapping:nil
	] ifFalse:[
	    oldBits
		expandPixels:depth
		width:oldImage width
		height:oldImage height
		into:newBits
		mapping:oldToNew.
	].

	newImage := oldImage species new
			width:oldImage width
			height:oldImage height
			depth:depth
			fromArray:newBits.

	newImage colorMap:newColorMap.
	newImage fileName:oldImage fileName.
	newImage mask:(oldImage mask copy).

	^newImage
!

transparencyTest_primDrawBits:imageBits redVector:redVector greenVector:greenVector blueVector:blueVector bitsPerPixel:bitsPerPixel depth:imageDepth
			      width:imageWidth height:imageHeight
			       into:ignoredDrawableId
				  x:dstx y:dsty
			      width:w height:h
			       with:aGCId

    "since XPutImage may allocate huge amount of stack space
     (some implementations use alloca), this must run with unlimited stack."

    | drawableId |

    drawableId := self drawableId.

%{
    unsigned char fastBits[10000];
    unsigned char *b_bits = 0;
    unsigned char *allocatedBits = 0;
    unsigned char *__imageBits = 0;
    unsigned char *__redVector = 0;
    unsigned char *__greenVector = 0;
    unsigned char *__blueVector = 0;
    int padd = 8;

    if (__isByteArray(imageBits)) {
	__imageBits = __ByteArrayInstPtr(imageBits)->ba_element;
    } else if (__isExternalBytesLike(imageBits)) {
	__imageBits = (unsigned char *)(__externalBytesAddress(imageBits));
    }

    if (__isByteArray(redVector)) {
	__redVector = __ByteArrayInstPtr(redVector)->ba_element;
    } else if (__isExternalBytesLike(redVector)) {
	__redVector = (unsigned char *)(__externalBytesAddress(redVector));
    }

    if (__isByteArray(greenVector)) {
	__greenVector = __ByteArrayInstPtr(greenVector)->ba_element;
    } else if (__isExternalBytesLike(greenVector)) {
	__greenVector = (unsigned char *)(__externalBytesAddress(greenVector));
    }

    if (__isByteArray(blueVector)) {
	__blueVector = __ByteArrayInstPtr(blueVector)->ba_element;
    } else if (__isExternalBytesLike(blueVector)) {
	__blueVector = (unsigned char *)(__externalBytesAddress(blueVector));
    }

    if (/* ISCONNECTED
     && */ __isExternalAddressLike(aGCId)
//     && __bothSmallInteger(srcx, srcy)
     && __bothSmallInteger(dstx, dsty)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(imageWidth, imageHeight)
     && __bothSmallInteger(imageDepth, bitsPerPixel)
     && __imageBits)
     {
	struct
	{
	  BITMAPINFOHEADER bmiHeader;
	  RGBQUAD bmiColors[256];
	} bitmap;

	HANDLE hDC = (HANDLE)(__externalAddressVal(aGCId));
	HBITMAP hBitmap = _HBITMAPVAL(drawableId);
	int col;
/*
	DDPRINTF(("hDC = %x\n", hDC));
*/

	if (padd != WIN32PADDING) {

	    int row, col;
	    unsigned char *cp;
	    unsigned char *pBits;
	    int b_width, b_height, bytesPerRowST, bytesPerRowWN, padding, nBytes;
	    int bi = __intVal(bitsPerPixel);

//            console_fprintf(stderr, "Non WIN32PADDING");

	    b_width = __intVal(w);
	    b_height = __intVal(h);
	    bytesPerRowST = (b_width * bi + (padd - 1 )) / padd;
	    bytesPerRowWN = (b_width * bi + (WIN32PADDING-1)) / WIN32PADDING * (WIN32PADDING/8);
	    padding = bytesPerRowWN - bytesPerRowST;
	    nBytes = b_height * bytesPerRowWN;
	    /*console_printf("padd %d bs %d bw %d p %d\n",__intVal(padd),bytesPerRowST,bytesPerRowWN,padding);*/
	    if (padding) {
		if (nBytes < sizeof(fastBits)) {
		    cp = b_bits = fastBits;
		} else {
		    cp = b_bits = allocatedBits = (unsigned char *) malloc(nBytes);
		}
		if (cp) {
		    pBits = __imageBits;
		    for (row = b_height; row; row--) {
			for (col = bytesPerRowST; col; col--) {
			    *cp++ = *pBits++;
			}
			cp += padding;
		    }
		} else
		    goto fail;
	    }
	}

	if (b_bits == 0) {
	    b_bits = __imageBits;
	}

	bitmap.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	bitmap.bmiHeader.biPlanes = 1;
	bitmap.bmiHeader.biCompression = BI_RGB;
	bitmap.bmiHeader.biSizeImage = 0;
	bitmap.bmiHeader.biXPelsPerMeter = 0;
	bitmap.bmiHeader.biYPelsPerMeter = 0;
	bitmap.bmiHeader.biClrUsed = 0;
	bitmap.bmiHeader.biClrImportant = 0;
	bitmap.bmiHeader.biWidth = __intVal(imageWidth);
	bitmap.bmiHeader.biHeight = -(__intVal(imageHeight));
	bitmap.bmiHeader.biBitCount = __intVal(bitsPerPixel);
	/*console_printf("drawBits depth:%d bitsPerPixel:%d IW%d W:%d H:%d\n",__intVal(imageDepth),bitmap.bmiHeader.biBitCount,bitmap.bmiHeader.biWidth,__intVal(w),bitmap.bmiHeader.biHeight);*/

	if (__intVal(imageDepth) <= 8) {
	    for(col=0;col<256;col++)
	     {
	      bitmap.bmiColors[col].rgbBlue = 0;
	      bitmap.bmiColors[col].rgbGreen = 0;
	      bitmap.bmiColors[col].rgbRed = 0;
	      bitmap.bmiColors[col].rgbReserved = 0;

	    }
	}

	bitmap.bmiColors[255].rgbBlue=255;
	bitmap.bmiColors[255].rgbGreen=255;
	bitmap.bmiColors[255].rgbRed =255;
	bitmap.bmiColors[255].rgbReserved = 0;
	StretchDIBits(hDC,
		      __intVal(dstx),(__intVal(dsty)),            //  x & y coord of destination upper-left corner
		      __intVal(w), __intVal(h),                 // width & height of destination rectangle
		      0, 0,  /* __intVal(srcx), __intVal(srcy),    */   // x & y coord of source upper-left corner
		      __intVal(w), __intVal(h),                 // width & height of source rectangle
		      (void *)b_bits,                           // bitmap bits
		      (BITMAPINFO*)&bitmap,                     // bitmap data
		      DIB_RGB_COLORS,                           // usage options
		      SRCAND                                   // raster operation code
	);
/*
	if (__intVal(imageDepth) <= 8) {
	    for(col=0;col<256;col++)
	     {
	      bitmap.bmiColors[col].rgbBlue = __blueVector[col];    // Microsoft idea: change rgbBlue to rgbRed
	      bitmap.bmiColors[col].rgbGreen = __greenVector[col];
	      bitmap.bmiColors[col].rgbRed = __redVector[col];         // Microsoft idea: change rgbRed to rgbBlue
	      bitmap.bmiColors[col].rgbReserved = 0;

	    }
	}

	bitmap.bmiColors[255].rgbBlue=0;
	bitmap.bmiColors[255].rgbGreen=0;
	bitmap.bmiColors[255].rgbRed =0;
	bitmap.bmiColors[255].rgbReserved = 0;
	StretchDIBits(hDC,
		      __intVal(dstx),(__intVal(dsty)),            //  x & y coord of destination upper-left corner
		      __intVal(w), __intVal(h),                 // width & height of destination rectangle
		      0, 0,                                     // x & y coord of source upper-left corner
		      __intVal(w), __intVal(h),                 // width & height of source rectangle
		      (void *)b_bits,                           // bitmap bits
		      (BITMAPINFO*)&bitmap,                     // bitmap data
		      DIB_RGB_COLORS,                           // usage options
		      SRCPAINT                                  // raster operation code
	);
 */
/*
	SetDIBitsToDevice(hDC,__intVal(dstx),__intVal(dsty),
			      __intVal(w), __intVal(h),
			      0, 0,
			      0,__intVal(h),
			      (void *)b_bits,
			      (BITMAPINFO*)&bitmap,DIB_RGB_COLORS);
*/
/*
	SetDIBits(hDC,hBitmap,
			      0,__intVal(h),
			      (void *)b_bits,
			      (BITMAPINFO*)&bitmap,DIB_RGB_COLORS);
*/
/*
	StretchDIBits(hDC,
		      __intVal(dstx),(__intVal(dsty)),            //  x & y coord of destination upper-left corner
		      __intVal(w), __intVal(h),                 // width & height of destination rectangle
		      __intVal(srcx), __intVal(srcy),           // x & y coord of source upper-left corner
		      __intVal(w), __intVal(h),                 // width & height of source rectangle
		      (void *)b_bits,                           // bitmap bits
		      (BITMAPINFO*)&bitmap,                     // bitmap data
		      DIB_RGB_COLORS,                           // usage options
		      SRCCOPY                                   // raster operation code
	);
*/
	if (allocatedBits) {
	    free(allocatedBits);
	}
/*
#ifndef CACHE_LAST_DC
	_releaseDC(gcData);
#endif
*/
	RETURN ( true );
    }

fail: ;
/*
    PRINTF(("create temp bitmap FAILED!!!\n"));
*/
    if (allocatedBits) {
/*
	PRINTF(("freeing up temp bitmap bits ...\n"));
*/
	free(allocatedBits);
    }
/*
#ifndef CACHE_LAST_DC
    if (hDC) {
	_releaseDC(gcData);
    }
#endif
*/
%}
.
    ^ false
! !

!WinPrinterContext methodsFor:'font stuff'!

createFontFor:aFontName
    "a basic method for font allocation; this method allows
     any font to be acquired (even those not conforming to
     standard naming conventions, such as cursor, fixed or k14)"

%{
    HGDIOBJ hFont;
    char *fn;

    if (__isStringLike(aFontName)) {
	fn = __stringVal(aFontName);
	if ((strcmp(fn, "fixed") == 0) || (strcmp(fn, "ANSI_FIXED_FONT") == 0)) {
	    hFont = GetStockObject(ANSI_FIXED_FONT);
	} else if ((strcmp(fn, "variable") == 0) || (strcmp(fn, "ANSI_VAR_FONT") == 0)) {
	    hFont = GetStockObject(ANSI_VAR_FONT);
	} else if ((strcmp(fn, "system") == 0) || (strcmp(fn, "SYSTEM_FONT") == 0)) {
	    hFont = GetStockObject(SYSTEM_FONT);
	} else if ((strcmp(fn, "systemFixed") == 0) || (strcmp(fn, "SYSTEM_FIXED_FONT") == 0)) {
	    hFont = GetStockObject(SYSTEM_FIXED_FONT);
	} else if ((strcmp(fn, "deviceDefault") == 0) || (strcmp(fn, "DEVICE_DEFAULT_FONT") == 0)) {
	    hFont = GetStockObject(DEVICE_DEFAULT_FONT);
	} else {
	    hFont = GetStockObject(ANSI_FIXED_FONT);
	}
	if (hFont) {
	    DPRINTF(("createFontFor:%s -> %x\n", fn, hFont));
	    RETURN ( __MKEXTERNALADDRESS(hFont) );
	}
    }
%}.
    ^ nil
!

fontMetricsOf:fontId
    "return a fonts metrics info object"

    |rawData info|

    rawData := Array new:15.
    (self primFontMetricsOf:fontId hdc:self gcId intoArray:rawData) isNil ifTrue:[
	self primitiveFailed.
	^ self
    ].

    rawData at:11 put:#'ms-ansi'.

    info := DeviceWorkstation::DeviceFontMetrics new.
    info
      ascent:(rawData at:1)
      descent:(rawData at:2)
      maxAscent:(rawData at:3)
      maxDescent:(rawData at:4)
      minWidth:(rawData at:5)
      maxWidth:(rawData at:6)
      avgWidth:(rawData at:7)
      minCode:(rawData at:8)
      maxCode:16rFFFF "(rawData at:9)"
      direction:nil
      encoding:(rawData at:11).


    ^ info
!

getDefaultFontWithEncoding:encoding
    "return a default font id - used when class Font cannot
     find anything usable"

     ^ self createFontFor:'fixed'
!

getFontWithFamily:familyString face:faceString style:styleString size:sizeArg encoding:encodingSym
    "try to get the specified font, return id.
     If not available, try next smaller font.
     If no font fits, return nil"

    ^ self
	getFontWithFamily:familyString
	face:faceString
	style:styleString
	size:sizeArg
	sizeUnit:#pt
	encoding:encodingSym
!

getFontWithFamily:familyString face:faceString
	    style:styleArgString size:sizeArgOrNil sizeUnit:sizeUnit encoding:encodingSym

    "try to get the specified font, if not available, try the next smaller
     font."

    |styleString theName theId xlatedStyle id spacing|

    self assert:(sizeUnit == #pt).

    styleString := styleArgString.

    "special: if face is nil, allow access to X-fonts"
    faceString isNil ifTrue:[
	sizeArgOrNil notNil ifTrue:[
	    theName := familyString , '-' , sizeArgOrNil printString
	] ifFalse:[
	    theName := familyString
	].
	theName notNil ifTrue:[
	    theId := self createFontFor:theName.
	].
	theId isNil ifTrue:[
	    theId := self getDefaultFontWithEncoding:encodingSym
	].
	^ theId
    ].

    "/ spacing other than 'normal' is contained as last component
    "/ in style
    styleString notNil ifTrue:[
	((styleString endsWith:'-narrow')
	 or:[styleString endsWith:'-semicondensed']) ifTrue:[
	    |i|
	    i := styleString lastIndexOf:$-.
	    spacing := styleString copyFrom:(i+1).
	    styleString := styleString copyTo:(i-1).
	] ifFalse:[
	    spacing := 'normal'.
	].
    ].

    xlatedStyle := styleString.
    xlatedStyle notNil ifTrue:[
	xlatedStyle := xlatedStyle first asString
    ].

    id := self
	    getFontWithFoundry:'*'
	    family:familyString asLowercase
	    weight:faceString
	    slant:styleString "/ xlatedStyle
	    spacing:spacing
	    pixelSize:nil
	    size:sizeArgOrNil
	    registry:'*'
	    encoding:encodingSym.

    id isNil ifTrue:[
	(encodingSym notNil and:[encodingSym ~= '*']) ifTrue:[
	    "/ too stupid: encodings come in both cases
	    "/
	    id := self
		    getFontWithFoundry:'*'
		    family:familyString asLowercase
		    weight:faceString
		    slant:styleString "/ xlatedStyle
		    spacing:spacing
		    pixelSize:nil
		    size:sizeArgOrNil
		    registry:'*'
		    encoding:encodingSym asUppercase.
	    id isNil ifTrue:[
		id := self
			getFontWithFoundry:'*'
			family:familyString asLowercase
			weight:faceString
			slant:styleString "/ xlatedStyle
			spacing:spacing
			pixelSize:nil
			size:sizeArgOrNil
			registry:'*'
			encoding:encodingSym asLowercase.

		id isNil ifTrue:[
		    id := self
			    getFontWithFoundry:'*'
			    family:familyString asLowercase
			    weight:faceString asLowercase
			    slant:styleString asLowercase
			    spacing:spacing
			    pixelSize:nil
			    size:sizeArgOrNil
			    registry:'*'
			    encoding:encodingSym asLowercase.
		]
	    ]
	]
    ].
    ^ id

    "Modified: 24.2.1996 / 22:37:24 / cg"
    "Modified: 4.7.1996 / 11:38:47 / stefan"
!

getFontWithFoundry:foundry family:family weight:weight
	      slant:slant spacing:spc pixelSize:pixelSize size:pointSize
	      registry:registry encoding:encodingArg

    "get the specified font, if not available, return nil.
     For now, this is a poor (incomplete) emulation of the X code ...
     Individual attributes can be left empty (i.e. '') or nil to match any.

     foundry:   'adobe', 'misc', 'dec', 'schumacher' ... usually '*'
     family:    'helvetica' 'courier' 'times' ...
     weight:    'bold' 'medium' 'demi' ...
     slant:     'r(oman)' 'i(talic)' 'o(blique)'
     spacing:   'narrow' 'normal' semicondensed' ... usually '*'
     pixelSize: 16,18 ... usually left empty
     size:      size in point (1/72th of an inch)
     registry:  iso8859, sgi ... '*'
     encoding:  vendor specific encoding (usually '*')
    "

    "
     Windows-NT/95 allows the creation of a font with the following parameters

	nHeight
	nWidth
	nEscapement
	nOrientation
	fnWeight        FW_DONTCARE, FW_NORMAL, FW_MEDIUM, FW_BOLD, ...
	fdwItalic       TRUE or FALSE
	fdwUnderline    TRUE or FALSE
	fdwStrikeOut    TRUE or FALSE
	fdwCharSet      ANSI_CHARSET, UNICODE_, SYMBOL_, SHIFTJIS_,...
	fdwOutputPrecision      DEFAULT, STRING, CHAR, ...
	fdwClipPrecision        DEFAULT, CHAR, STROKE, MASK, ...
	fdwQuality      DEFAULT, DRAFT, or PROOF.
	fdwPitchAndFamily
		DEFAULT, FIXED or VARIABLE pitch
		DECORATIVE, DONTCASE, MODERN, ROMAN, SCRIPT, or SWISS.
	lpszFace
		Typeface Name

      These two above descriptions will be matched as follows:

	foundry   - ignored
	family    - mapped to type face name.
	weight    - mapped to fnWeight
	slant     - used for style
	spacing   - NOT USED INITIALLY
	pixelSize - NOT USED INITIALLY
	size      - mapped to nHeight
	registry  - NOT USED INITIALLY
	encoding  - mapped to fdwCharSet
     "

    |logSize encoding|

    encoding := encodingArg asSymbol.

    pixelSize notNil ifTrue:[
	logSize := pixelSize
    ] ifFalse:[
	logSize := (pointSize * (self getLogicalPixelSizeY) / 72.0) rounded.
    ].
%{
    HGDIOBJ hFont;
    int  nHeight, nWidth, nEscapement, nOrientation;
    char* work;
    char* work2;
    DWORD fnWeight;
    DWORD fdwItalic;
    DWORD fdwUnderline;
    DWORD fdwStrikeOut;
    DWORD fdwCharSet;
    DWORD fdwOutputPrecision;
    DWORD fdwClipPrecision;
    DWORD fdwQuality;
    DWORD fdwPitchAndFamily;
    static char faceName[256];

/* INITIALIZE */
    strcpy( faceName, "NULL" );
    nHeight   = 0;
    nWidth   = 0;
    nEscapement = 0;
    nOrientation = 0;
    fnWeight = FW_NORMAL;
    fdwItalic = FALSE;
    fdwUnderline = FALSE;
    fdwStrikeOut = FALSE;
    fdwOutputPrecision = OUT_DEFAULT_PRECIS;
    fdwClipPrecision   = CLIP_DEFAULT_PRECIS;
    fdwQuality         = DEFAULT_QUALITY;
    fdwPitchAndFamily  = FF_DONTCARE;

    fdwCharSet   = ANSI_CHARSET;
    if ((encoding == @symbol('ms-ansi'))) {
	fdwCharSet   = ANSI_CHARSET;
    } else if (encoding == @symbol('ms-default')
	       || encoding == @symbol(*)) {
	fdwCharSet   = DEFAULT_CHARSET;
    } else if ((encoding == @symbol('ms-symbol'))
	    || (encoding == @symbol('misc-fontspecific'))) {
	fdwCharSet   = SYMBOL_CHARSET;
    } else if ((encoding == @symbol('ms-shiftjis'))
	    || (encoding == @symbol('jisx0208.1983-0'))){
	fdwCharSet   = SHIFTJIS_CHARSET;
    } else if ((encoding == @symbol('ms-gb2312'))
	    || (encoding == @symbol('gb2312.1980-0'))) {
	fdwCharSet   = GB2312_CHARSET;
    } else if ((encoding == @symbol('ms-hangeul'))
	    || (encoding == @symbol('ksc5601.1987-0'))) {
	fdwCharSet   = HANGEUL_CHARSET;
    } else if ((encoding == @symbol('ms-chinesebig5'))
	    || (encoding == @symbol('big5'))) {
	fdwCharSet   = CHINESEBIG5_CHARSET;
    } else if (encoding == @symbol('ms-oem')) {
	fdwCharSet   = OEM_CHARSET;
    } else if (encoding == @symbol('ms-johab')) {
	fdwCharSet   = JOHAB_CHARSET;
    } else if ((encoding == @symbol('ms-hebrew'))
	    || (encoding == @symbol('ms-cp1255'))) {
	fdwCharSet   = HEBREW_CHARSET;
    } else if ((encoding == @symbol('ms-arabic'))
	    || (encoding == @symbol('ms-cp1256'))) {
	fdwCharSet   = ARABIC_CHARSET;
    } else if ((encoding == @symbol('ms-greek'))
	    || (encoding == @symbol('ms-cp1253'))) {
	fdwCharSet   = GREEK_CHARSET;
    } else if ((encoding == @symbol('ms-turkish'))
	    || (encoding == @symbol('ms-cp1254'))) {
	fdwCharSet   = TURKISH_CHARSET;
    } else if ((encoding == @symbol('ms-russian'))
	    || (encoding == @symbol('ms-cp1251'))) {
	fdwCharSet   = RUSSIAN_CHARSET;
    } else if ((encoding == @symbol('ms-easteurope'))
	    || (encoding == @symbol('ms-cp1250'))) {
	fdwCharSet   = EASTEUROPE_CHARSET;
    } else if ((encoding == @symbol('ms-baltic'))
	    || (encoding == @symbol('ms-cp1257'))) {
	fdwCharSet   = BALTIC_CHARSET;
    } else if ((encoding == @symbol('ms-vietnamese'))) {
	fdwCharSet   = VIETNAMESE_CHARSET;
    } else if ((encoding == @symbol('ms-thai'))) {
	fdwCharSet   = THAI_CHARSET;
    } else if ((encoding == @symbol('ms-mac'))) {
	fdwCharSet   = MAC_CHARSET;
#ifdef UNICODE_CHARSET
    } else if ((encoding == @symbol('ms-unicode'))) {
	fdwCharSet   = UNICODE_CHARSET;
#endif
    }

    if ( __isString( family ) ) {
	work = __stringVal( family );
	if (strcmp( work, "nil" ) != 0 ) {
	    strncpy( faceName, work, sizeof(faceName)-1 );
	}
    }

    /* Q: should we allow those ? (they make ST/X programs less portable to X */
    if( __isString( weight ) ) {
	work = __stringVal( weight );
	if (strcmp( work, "bold" ) == 0 ) {
	    fnWeight = FW_BOLD;
	} else if (strcmp( work, "medium" ) == 0 ) {
	    fnWeight = FW_MEDIUM;
	} else if (strcmp( work, "normal" ) == 0 ) {
	    fnWeight = FW_NORMAL;
	} else if (strcmp( work, "light" ) == 0 ) {
	    fnWeight = FW_LIGHT;
	} else if (strcmp( work, "demi" ) == 0 ) {
	    fnWeight = FW_LIGHT;
	} else if (strcmp( work, "heavy" ) == 0 ) {
	    fnWeight = FW_HEAVY;
	} else if (strcmp( work, "extraBold" ) == 0 ) {
	    fnWeight = FW_EXTRABOLD;
	} else if (strcmp( work, "semiBold" ) == 0 ) {
	    fnWeight = FW_SEMIBOLD;
	} else if (strcmp( work, "thin" ) == 0 ) {
	    fnWeight = FW_THIN;
	} else if (strcmp( work, "extraLight" ) == 0 ) {
	    fnWeight = FW_EXTRALIGHT;
	}
    } else if (__isSmallInteger(weight)) {
	fnWeight = __intVal(weight);
    }

    if(__isSmallInteger( logSize )) {
	nHeight = __intVal( logSize );
    }

    if (__isString(slant)) {
	work2 = __stringVal( slant );
	work  = __stringVal( slant );

	if (strncmp(work2, "italic", 6) == 0)  {
	    fdwItalic = TRUE;
	    if ( work2[6] == '-' )
		strncpy( work, &work2[7], ( strlen( work2) - 7) );
	} else {
	    if (strncmp(work2, "oblique", 7) == 0)  {
		fdwItalic = TRUE;
		if ( work2[7] == '-' )
		    strncpy( work, &work2[8], ( strlen( work2) - 8) );
	    }
	}
	if (strncmp( work, "underline", 9 ) == 0 ) {
	    fdwUnderline = TRUE;
	    if( work[10] == '-' )
		strncpy( work2, &work[11], ( strlen( work ) - 10 ) );
	}
	if (strncmp( work2, "strikeOut", 9 ) == 0 ) {
	    fdwStrikeOut = TRUE;
	}
    }

    DPRINTF(("CreateFont face:%s h=%d w=%d wght=%d\n",
		faceName, nHeight, nWidth, fnWeight));

    hFont = CreateFont( -nHeight,   /* character height - not cell height */
			nWidth,
			nEscapement,
			nOrientation,
			fnWeight,
			fdwItalic,
			fdwUnderline,
			fdwStrikeOut,
			fdwCharSet,
			fdwOutputPrecision,
			fdwClipPrecision,
			fdwQuality,
			fdwPitchAndFamily,
			faceName );

    if (hFont != NULL) {
	DPRINTF(("createFont: %x\n", hFont));
/*
    #ifdef COUNT_RESOURCES
	__cnt_font++;
	RES1PRINTF(("CreateFont %d\n", __cnt_font));
    #endif
*/
	RETURN ( __MKEXTERNALADDRESS(hFont) );
    }

    DPRINTF(("***** ERROR createFontWithFoundry failed ERROR *****\n" ));
%}.
    ^ nil

    "
     Display getFontWithFoundry:'*'
			 family:'courier'
			 weight:'medium'
			  slant:'r'
			spacing:nil
		      pixelSize:nil
			   size:13
		       registry:'iso8859'
		       encoding:'*'
    "

    "new NT Version: 20.2.1997 / 22:33:29 / dq"
!

primFontMetricsOf:fontId hdc:aDC intoArray:rawData
    "evaluate aBlock, passing a fonts metrics as arguments.
     fill passed array as:
      ascent     -> (data at:1)
      descent    -> (data at:2)
      maxAscent  -> (data at:3)
      maxDescent -> (data at:4)
      minWidth   -> (data at:5)
      maxWidth   -> (data at:6)
      avgWidth   -> (data at:7).
      minChar    -> (data at:8).
      maxChar    -> (data at:9).
      defaultChar-> (data at:10).
      charSet    -> (data at:11).
"

%{

    if (__isExternalAddress(fontId)
     && __isExternalAddressLike(aDC)
     && __isArray(rawData)
     && (__arraySize(rawData) >= 11)) {
	SIZE size;
	int avgWidth;
	HGDIOBJ hFont;
	HGDIOBJ prevFont;
	TEXTMETRIC tmet;
	static char *s = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	static int len;
	OBJ t;
	HANDLE hDC;

	hFont = _HGDIOBJVal(fontId);
	hDC = (HANDLE)(__externalAddressVal(aDC));

	/*
	 * temporarily set this font in the tmpDC (root-) context
	 */

	prevFont = SelectObject(hDC, hFont);

	GetTextMetricsW(hDC, &tmet);
	if (len == 0) {
	    len = strlen(s);
	}
#if 0
	GetTextExtentPoint32(hDC, s, len, &size);
	avgWidth = (size.cx / (len / 2) + 1) / 2;
#else
	avgWidth = tmet.tmAveCharWidth;
#endif

	__ArrayInstPtr(rawData)->a_element[0] = __MKSMALLINT(tmet.tmAscent);        /* ascent     -> (data at:1) */
	__ArrayInstPtr(rawData)->a_element[1] = __MKSMALLINT(tmet.tmDescent);       /* descent    -> (data at:2) */
	__ArrayInstPtr(rawData)->a_element[2] = __MKSMALLINT(tmet.tmAscent);        /* maxAscent  -> (data at:3) */
	__ArrayInstPtr(rawData)->a_element[3] = __MKSMALLINT(tmet.tmDescent);       /* maxDescent -> (data at:4) */
	__ArrayInstPtr(rawData)->a_element[4] = __MKSMALLINT(avgWidth);             /* minWidth   -> (data at:5) */
	__ArrayInstPtr(rawData)->a_element[5] = __MKSMALLINT(tmet.tmMaxCharWidth);  /* maxWidth   -> (data at:6) */
	__ArrayInstPtr(rawData)->a_element[6] = __MKSMALLINT(avgWidth);             /* avgWidth   -> (data at:7) */
	__ArrayInstPtr(rawData)->a_element[7] = __MKSMALLINT(tmet.tmFirstChar);     /* min        -> (data at:8) */
	__ArrayInstPtr(rawData)->a_element[8] = __MKSMALLINT(tmet.tmLastChar);      /* max        -> (data at:9) */
	__ArrayInstPtr(rawData)->a_element[9] = __MKSMALLINT(tmet.tmDefaultChar);   /* default    -> (data at:10) */
#if 0
	t = __charSetSymbolFor(tmet.tmCharSet);
	__ArrayInstPtr(rawData)->a_element[10]= t; __STORE(rawData, t);             /* charSet    -> (data at:11) */
#endif

	DPRINTF(("textMetrics h=%x  avgAsc=%d avgDesc=%d minW=%d maxW=%d avgW=%d\n",
		    hFont, tmet.tmAscent, tmet.tmDescent, avgWidth, tmet.tmMaxCharWidth,
		    tmet.tmAveCharWidth));

	SelectObject(hDC, prevFont);
	RETURN (self);
    }
    RETURN (nil);
%}
!

releaseFont:aFontId

%{  /* NOCONTEXT */
    if (__isExternalAddress(aFontId)) {
	HGDIOBJ hFont = _HGDIOBJVal(aFontId);

	if (hFont) {
	   DPRINTF(("ReleaseFont: %x\n", hFont));
	   DeleteObject(hFont);
	}
    }
%}
!

setFont:aFontId in:aDC
    "set font to be drawn in"

%{  /* NOCONTEXT */

    if (__isExternalAddressLike(aDC)
     && __isExternalAddress(aFontId))
    {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	HGDIOBJ prevFont, hFont;

	hFont = _HGDIOBJVal(aFontId);
	prevFont = SelectObject(hDC, hFont);

	RETURN ( self );
    }
%}.
    self primitiveFailed

    "Created: / 04-08-2006 / 12:32:53 / fm"
!

widthOf:aString from:index1 to:index2 inFont:aFontId
   | gcId |

   gcId :=self gcId.

%{  /* NOCONTEXT */
    unsigned char *cp;
    int len, n, i1, i2, l;
    OBJ cls;
    int nInstBytes;

    if (__bothSmallInteger(index1, index2)
     && __isExternalAddress(aFontId)
     && __isExternalAddressLike(gcId)
     && __isNonNilObject(aString)) {
	HGDIOBJ hFont,prevFont;
	HANDLE hDC;
	SIZE tsize;

#ifndef PRE_22_FEP_2007
#       define N_QUICK_CHARS    1024
	unsigned short quickWchars[N_QUICK_CHARS];
	unsigned short *wcharPtr;
	int mustFree = 0;
	int i;
#endif

	hFont = _HGDIOBJVal(aFontId);
	hDC = (HANDLE)(__externalAddressVal(gcId));

	prevFont = SelectObject(hDC, hFont);

	i1 = __intVal(index1) - 1;
	cls = __qClass(aString);

	if (i1 >= 0) {
	    i2 = __intVal(index2) - 1;
	    if (i2 < i1) {
		RETURN ( __MKSMALLINT( 0 ) );
	    }

	    cp = (char *) __stringVal(aString);
	    l = i2 - i1 + 1;

	    if ((cls == @global(String)) || (cls == @global(Symbol))) {
		n = __stringSize(aString);
    commonWidthChars:
		if (i2 < n) {
		    cp += i1;

#ifdef PRE_22_FEP_2007
		    GetTextExtentPoint32(hDC, cp, l, &tsize);
#else
		    if (l <= N_QUICK_CHARS) {
			wcharPtr = quickWchars;
			mustFree = 0;
		    } else {
			wcharPtr = malloc(sizeof(short)*l);
			if (! wcharPtr) RETURN (__MKSMALLINT(0));
			mustFree = 1;
		    }
		    for (i=0; i<l; i++) wcharPtr[i] = ((unsigned char *)cp)[i];
		    GetTextExtentPoint32W(hDC, wcharPtr, l, &tsize);
		    if (mustFree) free(wcharPtr);
#endif

#ifdef SUPERDEBUG
		    if (__debug__) {
			char buf[80];

			GetTextFace(hDC,80,buf);
			console_printf("font1 %x %s >%s< l=%d dx=%d\n",hFont,buf,cp,l,tsize.cx);
		    }
#endif
		    SelectObject(hDC, prevFont);
		    RETURN ( __MKSMALLINT(tsize.cx) );
		}
		RETURN (__MKSMALLINT(0));
	    }

	    nInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	    cp += nInstBytes;
	    n = __byteArraySize(aString) - nInstBytes;

	    if (__isBytes(aString)) {
		goto commonWidthChars;
	    }

	    /* Unicode */
	    if (__isWords(aString)) {
		n = n / 2;
		if (i2 < n) {
		    WIDECHAR *w_cp = (WIDECHAR *)cp;

		    w_cp += i1;

		    GetTextExtentPoint32W(hDC, w_cp, l, &tsize);
		    SelectObject(hDC, prevFont);
		    RETURN ( __MKSMALLINT(tsize.cx) );
		}
		RETURN (__MKSMALLINT(0));
	    }
	}
    }
%}.
    self primitiveFailed.
    ^ 0
!

widthOf:aString inFont:aFontId
    "return the width in pixels of a string in a specific font"

    ^ self widthOf:aString from:1 to:(aString size) inFont:aFontId
! !

!WinPrinterContext methodsFor:'initialization & release'!

createDC
    "Private - Create a device context for the receiver"

    self gcId: printerInfo createDC

    "Created: / 27-07-2006 / 10:21:05 / fm"
    "Modified: / 02-08-2006 / 17:30:47 / fm"
    "Modified: / 10-10-2006 / 18:14:28 / cg"
!

deleteDC
    "Private - Delete a device context for the receiver"

    OperatingSystem deletePrinterDC: self gcId.
!

destroy
    "Destroy the GC."

    |id|

    id := self gcId.
    id notNil ifTrue:[
	self gcId: nil.
	self deleteDC.
    ].
"/    Lobby unregister:self.
!

destroyGC:aDC
%{
    if (__isExternalAddressLike(aDC)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));

	DeleteDC(hDC);

/*
#ifdef CACHE_LAST_DC
	if (lastGcData == gcData) {
	    _releaseDC(gcData);
	}
#endif
*/

    }
%}
!

executor
    |aCopy|

    aCopy := WinWorkstation::PrinterDeviceContextHandle basicNew.
    aCopy setDevice:self device id:nil gcId:self gcId.
    ^ aCopy

    "Created: / 16-04-2007 / 12:39:02 / cg"
!

initialize
    super initialize.
"/    deviceForms := Registry new.
"/    deviceColors := Registry new.
    deviceFonts := CachingRegistry new cacheSize:10.
!

releaseDC
    "Private - Delete and clear the device context of the receiver."

    self deleteDC.
"/    device close.
    self gcId: nil.
    self releaseDeviceFonts
!

releaseDeviceFonts
    deviceFonts isEmptyOrNil ifFalse:[
	deviceFonts do:[:afont |
	    afont releaseFromDevice.
	].
    ].
    deviceFonts := CachingRegistry new cacheSize:10.
! !

!WinPrinterContext methodsFor:'non standard methods'!

stringWidthOf:aString at:index
    "Return the width of aString up to index
     when written using the current font; expand tabs out
     to 4 spaces for calculations"

    |answer str size spaceWidth|

    index <= 0 ifTrue:[ ^ 0 ].
    str := index >= aString size ifTrue:[ aString ] ifFalse:[ aString copyFrom:1 to:index ].
    true "self font isNil" ifTrue:[
	"if font not set yet, calculate based on default font"
	"/            extString := str asExternalString.
	size := Win32OperatingSystem::WinPointStructure new.
	(OperatingSystem
	    getTextExtentPoint:self gcId
	    string:str
	    size:size) ifFalse:[ ^ self error ].
	answer := size x.
"/        Transcript showCR: 'FROM PRIM ******* ', str, '   ',  answer printString.
"/        Transcript showCR: 'FROM DEVICE ***** ', str, '   ',(self font widthOf:str on:self device) printString.
	#TODO.
    ] ifFalse:[
	answer := self font widthOf:str on:self device
    ].
    index > aString size ifTrue:[
	spaceWidth := self font widthOf:Character space on:self device.
	answer := answer + ((index - aString size) * spaceWidth)
    ].
    ^ answer.

    "Created: / 03-08-2006 / 10:27:20 / fm"
    "Modified: / 04-08-2006 / 12:27:26 / fm"
    "Modified: / 10-10-2006 / 18:20:43 / cg"
! !

!WinPrinterContext methodsFor:'not supported yet'!

displayAdvanceLineFrom:point1 to:point2
    "draw a line"

    self displayAdvanceLineFromX:(point1 x) y:(point1 y)
		      toX:(point2 x) y:(point2 y)
!

displayAdvanceLineFromX:x0 y:y0 toX:x1 y:y1
    "draw a line (with current paint-color); apply transformation if nonNil"

    |pX0 pY0 pX1 pY1 easy fgId bgId|

    self gcId isNil ifTrue:[
	self initGC
    ].

    self lineStyle == #doubleDashed ifTrue:[
	"
	 if bgPaint or paint is not a real color, we have to do it the hard way ...
	"
	easy := true.
	self paint isColor ifFalse:[
	    easy := false
	] ifTrue:[
	    fgId := self paint colorId.
	    fgId isNil ifTrue:[
		easy := false
	    ]
	].
	self bgPaint isColor ifFalse:[
	    easy := false
	] ifTrue:[
	    bgId := self bgPaint colorId.
	    bgId isNil ifTrue:[
		easy := false
	    ]
	].

	easy ifTrue:[
	    ((self foreground ~~ self paint) or:[self background ~~ self bgPaint]) ifTrue:[
		self device setForeground:fgId background:bgId in:self gcId.
		self foreground: self paint.
		self background: self bgPaint.
	    ].
	] ifFalse:[
	    'DeviceGraphicsContext [warning]: cannot draw dashes with dithered colors' errorPrintCR
	].
    ].

    self transformation notNil ifTrue:[
	pX0 := self transformation applyToX:x0.
	pY0 := self transformation applyToY:y0.
	pX1 := self transformation applyToX:x1.
	pY1 := self transformation applyToY:y1.
    ] ifFalse:[
	pX0 := x0.
	pY0 := y0.
	pX1 := x1.
	pY1 := y1
    ].

    pX0 := pX0 rounded.
    pY0 := pY0 rounded.
    pX1 := pX1 rounded.
    pY1 := pY1 rounded.

    self device displayAdvanceLineFromX:pX0 y:pY0 toX:pX1 y:pY1 in:self drawableId with:self gcId

    "Modified: 10.1.1997 / 17:46:32 / cg"
!

displayAdvanceLineFromX:x0 y:y0 toX:x1 y:y1 in:ignoredDrawableId with:aDC
    "draw a line. If the coordinates are not integers, an error is triggered."

    self getPenForMyContext.

%{  /* NOCONTEXT */
    if (__isExternalAddressLike(aDC)
     && __bothSmallInteger(x0, y0)
     && __bothSmallInteger(x1, y1)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	COLORREF fgColor;
	int __x1 = __intVal(x1), __y1 = __intVal(y1);


/*      DPRINTF(("displayLine: %d/%d -> %d/%d\n",
		    __intVal(x0), __intVal(y0),
		    __x1, __y1));
*/

/*        fgColor = GetTextColor(hDC);
 *        hPen = CreatePen(PS_SOLID, 1, fgColor);
 */

	MoveToEx(hDC, __intVal(x0), __intVal(y0), NULL);

	LineTo(hDC, __x1, __y1);

	/*
	 * end-point ...
	 */
	LineTo(hDC, __x1+1, __y1);



	RETURN ( self );
    }
%}
!

gcForBitmap:aDrawableId

%{  /* NOCONTEXT */

    if (__isExternalAddress(aDrawableId)){
	BITMAP bitmap;
	HBITMAP hBitmap = _HBITMAPVAL(aDrawableId);
	HBITMAP memBM;
	HANDLE compatibleDC, rootDC, hdcScreen;
   //     HANDLE printerDC = (HANDLE)(__externalAddressVal(__INST(gcId)));

	if (! hBitmap) {
	    RETURN (nil);
	}

	if (GetObject(hBitmap, sizeof(bitmap), &bitmap)) {
/*
	    DDPRINTF(("bitmap info:%d\n", bitmap.bmBitsPixel));
*/
	} else {
/*
	    DPRINTF(("noinfo returned for bitmap\n"));
*/
	    /* mhmh - can this happen ? */
	    bitmap.bmBitsPixel = 1;
	}
/*
	gcData->hBitmap = hBitmap;
	gcData->bitmapColorBitCount = bitmap.bmBitsPixel;
*/

	rootDC  = CreateDC("DISPLAY", NULL, NULL, NULL);
	compatibleDC = CreateCompatibleDC(rootDC);
	SelectObject(compatibleDC, hBitmap);

   //     hdcScreen= CreateDC("NULL", NULL, NULL, NULL);
   //       compatibleDC =  rootDC;
   //     compatibleDC = CreateCompatibleDC(printerDC);
   //     compatibleDC = CreateCompatibleDC(0);

   //     memBM = CreateCompatibleBitmap ( compatibleDC, bitmap.bmWidth, bitmap.bmHeight );
   //     SelectObject ( compatibleDC, memBM );

	RETURN (__MKEXTERNALADDRESS(compatibleDC));

/*
	RETURN ( __MKEXTERNALADDRESS(gcData) );
*/
    }
    RETURN (nil);
%}
!

getPenForMyContext
    "Get a pen for my context"

    |maskOriginX maskOriginY gcId lineWidthObj lineStyleObj capStyleObj joinStyleObj maskObj |


    self maskOrigin isNil ifFalse:[
	maskOriginX := self maskOrigin x.
	maskOriginY := self maskOrigin y.
    ].

    		gcId := self gcId.
	lineWidthObj := self lineWidth.
	lineStyleObj := self lineStyle.
	 capStyleObj := self capStyle.
	joinStyleObj := self joinStyle.
         maskObj := self mask.

%{
    HPEN hPen = 0;
    HPEN prevPen;
    LOGBRUSH Brush;
    COLORREF fgColor;
    HANDLE hDC = (HANDLE)(__externalAddressVal(gcId));
    int lStyle, bkMode, hMask, maskOrgX, maskOrgY;
    OBJ lineStyle, capStyle, joinStyle;
    int style;
    int lw;
    int BK_TRANSPARENT;

    BK_TRANSPARENT = 1;

    lw= __intVal(lineWidthObj);
/*    fgColor = __intVal(__INST(foreground)) & 0xffffff;     */

    fgColor = GetTextColor(hDC);
    lineStyle=lineStyleObj;
    capStyle=capStyleObj;
    joinStyle=joinStyleObj;
    hMask= __intVal(maskObj);
    maskOrgX=__intVal(maskOriginX);
    maskOrgY=__intVal(maskOriginY);

    if (lineStyle == @symbol(solid)) {
	style = PS_SOLID;
    } else if (lineStyle == @symbol(dashed)) {
	style= PS_DASH;
    } else if (lineStyle == @symbol(dotted)) {
	style= PS_DOT;
    } else if (lineStyle == @symbol(dashDot)) {
	style= PS_DASHDOT;
    } else if (lineStyle == @symbol(dashDotDot)) {
	style= PS_DASHDOTDOT;
    } else
	style= PS_SOLID;
    lStyle &= ~PS_STYLE_MASK;
    lStyle |= style;


    if (capStyle == @symbol(round)) {
	style = PS_ENDCAP_ROUND;
    } else if (capStyle == @symbol(square)) {
	style = PS_ENDCAP_SQUARE;
    } else if (capStyle == @symbol(flat)) {
	style = PS_ENDCAP_FLAT;
    } else
	style = PS_ENDCAP_FLAT;
    lStyle &= ~PS_ENDCAP_MASK;
    lStyle |= style;

    if (joinStyle == @symbol(bevel)) {
	style = PS_JOIN_BEVEL;
    } else if (joinStyle == @symbol(miter)) {
	style = PS_JOIN_MITER;
    } else if (joinStyle == @symbol(round)) {
	style = PS_JOIN_ROUND;
    } else
	style = PS_JOIN_MITER;
    lStyle &= ~PS_JOIN_MASK;
    lStyle |= style;


    if (((lStyle & PS_STYLE_MASK) == PS_SOLID)
     && (hMask == 0)
     && (lw /* lineWidth */ <= 1)) {
	if (fgColor == 0 /* BlackPixel */ ) {
	    hPen = GetStockObject(BLACK_PEN);
	    prevPen = SelectObject(hDC, hPen);
	    RETURN( __MKEXTERNALADDRESS(hPen) );
	}
	if (fgColor == 1 /* WhitePixel */) {
	    hPen = GetStockObject(WHITE_PEN);
	    prevPen = SelectObject(hDC, hPen);
	    RETURN( __MKEXTERNALADDRESS(hPen) );
	}
    }

    hPen = (HPEN) 0;

    if (0 /* __isWinNT */) {

	if (lw == 0) {
	    lw = 1;
	}
	/*
	 * NT supports masked drawing with any lineStyle,
	 * and also non-solid lines with any lineWidth.
	 */
	if (hMask) {
	    Brush.lbStyle = BS_PATTERN;
	    Brush.lbHatch = (DWORD)hMask;
	    Brush.lbColor = fgColor;
	} else {

#ifndef PRE_07_APR_04

	    hPen = CreatePen((lStyle & PS_STYLE_MASK), lw, fgColor);

/*            RESPRINTF(("CreatePen %x %d(%d) %x %x\n",
 *                       lStyle,
 *                       lw, __INST(lineWidth),
 *                       fgColor, hMask));
 */

	    SetBkMode(hDC, TRANSPARENT);
	    bkMode = BK_TRANSPARENT;

#else
	    Brush.lbStyle = BS_SOLID;
	    Brush.lbHatch = 0;
	    Brush.lbColor = fgColor;
#endif
	}

	if (! hPen)
	{
	    hPen = ExtCreatePen(PS_GEOMETRIC | lStyle,
			    lw, /* lineWidth, */
			    &Brush,
			    0, 0);

/*            RESPRINTF(("ExtCreatePen1 %x %d(%d) %x %x\n",
 *                       lStyle,
 *                       lw, __INST(lineWidth),
 *                       fgColor, hMask));
 */
	    if (hMask) {
		SetBrushOrgEx(hDC, maskOrgX, maskOrgY, 0);
	    }
	}
    } else {
	/*
	 * W95 only supports masked drawing with SOLID lines
	 * also, we should use COSMETIC pens if possible
	 * with non-solid lineStyles.
	 */
	if ((lStyle & PS_STYLE_MASK) == PS_SOLID) {
	    int ps = PS_GEOMETRIC;

	    if (hMask) {
		Brush.lbStyle = BS_PATTERN;
		Brush.lbHatch = (DWORD)hMask;
		Brush.lbColor = fgColor;
	    } else {
		Brush.lbStyle = BS_SOLID;
		Brush.lbHatch = 0;
		Brush.lbColor = fgColor;
		if (lw /* lineWidth */ <= 1) {
		    ps = PS_COSMETIC;
		}
	    }

	    hPen = ExtCreatePen(ps | lStyle,
				lw, /* lineWidth */
				&Brush,
				0, 0);

/*            RESPRINTF(("ExtCreatePen1 %x %d %x %x\n",
 *                           lStyle,
 *                           lw,
 *                           fgColor, hMask));
 */
	    if (hMask) {
		SetBrushOrgEx(hDC, maskOrgX, maskOrgY, 0);
	    }
	} else {

	    if (lw == 1) {
		lw = 0;
	    }

	    /*
	     * dashes only supported with lineWidth 0
	     */

	    hPen = CreatePen((lStyle & PS_STYLE_MASK),
			     lw,
			     fgColor);

/*            RESPRINTF(("CreatePen %x %d %x\n",
 *                               (lStyle & PS_STYLE_MASK),
 *                               lw,
 *                               fgColor));
 */
	    //
	    // CG: wrong; must set to opaque, if doubleDashed
	    //
	    SetBkMode(hDC, TRANSPARENT);
	    bkMode = BK_TRANSPARENT;
	}
    }

    prevPen = SelectObject(hDC, hPen);
    RETURN (__MKEXTERNALADDRESS(hPen));

%}
!

xprimDrawBits:imageBits bitsPerPixel:bitsPerPixel depth:imageDepth padding:padd width:imageWidth height:imageHeight
				  x:srcx y:srcy
			       into:ignoredDrawableId
				  x:dstx y:dsty
			      width:w height:h
			       with:aDC

    "since XPutImage may allocate huge amount of stack space
     (some implementations use alloca), this must run with unlimited stack."

%{
    unsigned char fastBits[10000];
    unsigned char *b_bits = 0;
    unsigned char *allocatedBits = 0;
    unsigned char *__imageBits = 0;

    if (__isByteArray(imageBits)) {
	__imageBits = __ByteArrayInstPtr(imageBits)->ba_element;
    } else if (__isExternalBytesLike(imageBits)) {
	__imageBits = (unsigned char *)(__externalBytesAddress(imageBits));
    }

    if (/* ISCONNECTED
     && */  __isExternalAddressLike(aDC)
     && __bothSmallInteger(srcx, srcy)
     && __bothSmallInteger(dstx, dsty)
     && __bothSmallInteger(w, h)
     && __bothSmallInteger(imageWidth, imageHeight)
     && __bothSmallInteger(imageDepth, bitsPerPixel)
     && __isSmallInteger(padd)
     && __imageBits)
     {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	struct
	{
	  BITMAPINFOHEADER bmiHeader;
	  DWORD r;
	  DWORD g;
	  DWORD b;
	} bitmap;

	if (__intVal(padd) != WIN32PADDING) {
	    int row, col;
	    unsigned char *cp;
	    unsigned char *pBits;
	    int b_width, b_height, bytesPerRowST, bytesPerRowWN, padding, nBytes;
	    int bi = __intVal(bitsPerPixel);

	    b_width = __intVal(w);
	    b_height = __intVal(h);
	    bytesPerRowST = (b_width * bi + (__intVal(padd)-1)) / __intVal(padd);
	    bytesPerRowWN = (b_width * bi + (WIN32PADDING-1)) / WIN32PADDING * (WIN32PADDING/8);
	    padding = bytesPerRowWN - bytesPerRowST;
	    nBytes = b_height * bytesPerRowWN;
	    /*console_printf("padd %d bs %d bw %d p %d\n",__intVal(padd),bytesPerRowST,bytesPerRowWN,padding);*/
	    if (padding) {
		if (nBytes < sizeof(fastBits)) {
		    cp = b_bits = fastBits;
		} else {
		    cp = b_bits = allocatedBits = (unsigned char *) malloc(nBytes);
		}
		if (cp) {
		    pBits = __imageBits;
		    for (row = b_height; row; row--) {
			for (col = bytesPerRowST; col; col--) {
			    *cp++ = *pBits++;
			}
			cp += padding;
		    }
		} else
		    goto fail;
	    }
	}

	if (b_bits == 0) {
	    b_bits = __imageBits;
	}

	bitmap.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	bitmap.bmiHeader.biPlanes = 1;
	if (__intVal(imageDepth) == 24) {
	    /*bitmap.bmiHeader.biCompression = BI_BITFIELDS;
	    bitmap.r = 0xff0000;
	    bitmap.g = 0x00ff00;
	    bitmap.b = 0x0000ff;*/
	    bitmap.bmiHeader.biCompression = BI_RGB;
	} else if (__intVal(imageDepth) == 16) {
	    /*bitmap.bmiHeader.biCompression = BI_RGB;
	    bitmap.bmiHeader.biCompression = BI_BITFIELDS;
	    bitmap.b = 0x001f;
	    bitmap.g = 0x07e0;
	    bitmap.r = 0xf800;*/
	    bitmap.b = 0;
	    bitmap.g = 0;
	    bitmap.r = 0;
	    bitmap.bmiHeader.biCompression = BI_RGB;
	}
	bitmap.bmiHeader.biSizeImage = 0;
	bitmap.bmiHeader.biXPelsPerMeter = 0;
	bitmap.bmiHeader.biYPelsPerMeter = 0;
	bitmap.bmiHeader.biClrUsed = 0;
	bitmap.bmiHeader.biClrImportant = 0;
	bitmap.bmiHeader.biWidth = __intVal(imageWidth);
	bitmap.bmiHeader.biHeight = -(__intVal(imageHeight));
	bitmap.bmiHeader.biBitCount = __intVal(bitsPerPixel);
	/*console_printf("drawBits depth:%d bitsPerPixel:%d IW%d W:%d H:%d\n",__intVal(imageDepth),bitmap.bmiHeader.biBitCount,bitmap.bmiHeader.biWidth,__intVal(w),bitmap.bmiHeader.biHeight);*/
	SetDIBitsToDevice(hDC,__intVal(dstx),__intVal(dsty),
			      __intVal(w), __intVal(h),
			      __intVal(srcx), __intVal(srcy),
			      0,__intVal(h),
			      (void *)b_bits,
			      (BITMAPINFO*)&bitmap,DIB_RGB_COLORS);
	if (allocatedBits) {
	    free(allocatedBits);
	}
	RETURN ( true );
    }

fail: ;
/*
    PRINTF(("create temp bitmap FAILED!!!\n"));
*/
    if (allocatedBits) {
/*
	PRINTF(("freeing up temp bitmap bits ...\n"));
*/
	free(allocatedBits);
    }
%}
.
    ^ false
!

xxxdisplayLineFromX:x0 y:y0 toX:x1 y:y1 in:ignoredDrawableId with:aDC
    "draw a line. If the coordinates are not integers, an error is triggered."

    |penHandle|

    penHandle := self getPenForMyContext.

%{  /* NOCONTEXT */
    if (__isExternalAddressLike(aDC)
     && __isExternalAddressLike(penHandle)
     && __bothSmallInteger(x0, y0)
     && __bothSmallInteger(x1, y1)) {
	HANDLE hDC = (HANDLE)(__externalAddressVal(aDC));
	HANDLE hPen = (HANDLE)(__externalAddressVal(penHandle));
	COLORREF fgColor;
	HANDLE prevPen;
	int __x1 = __intVal(x1), __y1 = __intVal(y1);


/*      DPRINTF(("displayLine: %d/%d -> %d/%d\n",
		    __intVal(x0), __intVal(y0),
		    __x1, __y1));
*/

/*        fgColor = GetTextColor(hDC);
 *        hPen = CreatePen(PS_SOLID, 1, fgColor);
 */

	prevPen = SelectObject(hDC, hPen);

	MoveToEx(hDC, __intVal(x0), __intVal(y0), NULL);

	LineTo(hDC, __x1, __y1);

	/*
	 * end-point ...
	 */
	LineTo(hDC, __x1+1, __y1);

	SelectObject(hDC, prevPen);


	RETURN ( self );
    }
%}
! !

!WinPrinterContext methodsFor:'printing process'!

endPage
    "Informs device that we are finished writing to a page."

    (OperatingSystem endPage:self gcId) > 0 ifFalse:[
	self error
    ]

    "Created: / 27-07-2006 / 18:20:48 / fm"
    "Modified: / 01-08-2006 / 16:01:34 / fm"
    "Modified: / 10-10-2006 / 18:14:44 / cg"
!

endPrintJobWithoutRelease
    "End the print job.  Everything drawn between startPrintJob
     and endPrintJob will become one entry in the print queue."

    |result|

    self endPage.
    result := OperatingSystem endDoc:self gcId.
    jobid := nil.
    result >= 0 ifFalse:[ self error ]

    "Created: / 27-07-2006 / 18:21:04 / fm"
    "Modified: / 01-08-2006 / 16:01:38 / fm"
    "Modified: / 10-10-2006 / 18:50:43 / cg"
!

getSupportsColor

    | retVal info |

    info := (self class getPrinterInformationString: self name) asUppercase.
    (info includesSubString: ',PSCRIPT,')
	ifTrue: [
	    retVal := self class postScriptBlackWhite not.
"/            retVal := (DAPASX::DapasSystemInfo getYesNoInfoApp: 'Printer' profile: 'PostScriptBlackWhite') not.
	]
	ifFalse: [
	    retVal := (info includesSubString: 'PDF')
		ifTrue: [true]
		ifFalse: [self numberOfColorBitsPerPixel > 1].
    ].

    ^retVal
!

startPage
    "Starts a page."

    (OperatingSystem startPage:self gcId) > 0 ifFalse:[
	^ self error
    ].

    "Created: / 27-07-2006 / 18:25:55 / fm"
    "Modified: / 28-07-2006 / 18:19:04 / fm"
    "Modified: / 10-10-2006 / 18:19:02 / cg"
!

startPrintJob:aString fileName:aFileName
    "Start a print job, using aString as the job title; everything
     drawn between startPrintJob and endPrintJob will become
     one entry in the print queue."

    |docInfoStruct nameAddress fileNameAddress|

    self gcId isNil ifTrue:[
	self buildPrinter
    ].
    abort := false.
    title := aString ? 'Smalltalk/X'.
    nameAddress := title asExternalBytes unprotectFromGC.
    aFileName isNil ifFalse:[
	fileNameAddress := aFileName pathName asExternalBytes unprotectFromGC
    ].
    docInfoStruct := Win32OperatingSystem::DocInfoStructure new.
    docInfoStruct
	cbSize:docInfoStruct sizeInBytes;
	lpszDocName:nameAddress address.
    fileNameAddress isNil ifFalse:[
	docInfoStruct lpszOutput:fileNameAddress address
    ].
    jobid := OperatingSystem startDoc:self gcId docInfo:docInfoStruct.
    jobid > 0 ifFalse:[
	jobid = -1 ifTrue:[
	    abort := true.
	    ^ nil
	].
"/        ^ self error
	OpenError raiseErrorString:'Cannot create printer job'.
    ].
    self startPage

    "Created: / 27-07-2006 / 18:19:31 / fm"
    "Modified: / 03-08-2006 / 15:11:19 / fm"
    "Modified: / 10-10-2006 / 18:20:01 / cg"
    "Modified: / 07-04-2011 / 12:03:50 / sr"
! !

!WinPrinterContext methodsFor:'queries'!

hasGrayscales
    "return true, if this workstation supports grayscales
     (also true for color displays)"

    ^ true
!

isOpen

    ^ self gcId notNil
!

isPersistentInSnapshot
    "return true, if resources on this device are to be made
     persistent in a snapshot image."

    ^ false
!

supportsColor

    supportsColor isNil ifTrue:[supportsColor := self getSupportsColor].
    ^supportsColor
!

supportsGraphics
    ^(OperatingSystem getDeviceCaps: self gcId index: 2 "Technology") ~= 4

    "Created: / 03-08-2006 / 10:07:43 / fm"
    "Modified: / 16-04-2007 / 12:44:03 / cg"
!

supportsVariableHeightFonts

    ^ false
!

supportsXftFonts

    ^ false
! !

!WinPrinterContext methodsFor:'registration'!

registerFont:aFont
    deviceFonts register:aFont.
!

unregisterFont:aFont
    deviceFonts unregister:aFont.
! !

!WinPrinterContext::WinPrinterGraphicContext class methodsFor:'documentation'!

documentation
"
    The class is simular to the PSGraphicsContext. It implements a
    'what you see is what you get' interface - all is scaled dependent
    on the current screen resolution

    supports margin, clipping ...
"
!

examples
"
										[exBegin]
    |gc font|

    gc := WinPrinterContext openGraphicContext.
    gc isNil ifTrue:[^ self ].

    [
	gc startPrintJob:'Test'.
	gc paint:(Color black).
	gc displayLineFromX:10 y:40 toX:100 y:40.
	font := (Font family:'helvetica' face:'roman' style:'bold' size:16) onDevice:(gc device).

	gc font:font.
	gc paint:(Color red).
	gc displayString:'hallo' x:10 y:(40 + font ascent).

	gc paint:(Color black).
	gc displayLineFromX:10 y:(40 + font height) toX:100 y:(40 + font height).
    ] ensure:[
	gc close.
    ].
										[exEnd]

"
! !

!WinPrinterContext::WinPrinterGraphicContext methodsFor:'accessing dimensions'!

bottomMargin
    "return the papers bottom margin measured in pixels"

    ^ 50
!

extent
    ^ width @ height
!

height
    ^ height
!

leftMargin
    "return the papers left margin measured in pixels"

    ^ 50
!

rightMargin
    "return the papers right margin measured in pixels"

    ^ 50
!

topMargin
    "return the papers top margin measured in pixels"

    ^ 50
!

width
    ^ width
! !

!WinPrinterContext::WinPrinterGraphicContext methodsFor:'accessing-hooks'!

pageCounter
    "answer the current page number"

    pageCounter ~~ 0 ifTrue:[^ pageCounter].
    ^ 1
!

pageNumberFormat:aFormatString
    "set the pageNumber format - the default is 'page %1'"

    pageNumberFormat := aFormatString ? ''
!

printPageNumbers:aBoolean
    "enable/disable printing of page numbers - the default is on"

    printPageNumbers := aBoolean.
! !

!WinPrinterContext::WinPrinterGraphicContext methodsFor:'accessing-transformation'!

clippingRectangle:aRectangle
    |tranlate extent lft rgt top bot|

    tranlate := self translation negated asPoint.
    extent   := self extent.

    lft := tranlate x.
    top := tranlate y.
    rgt := lft + extent x.
    bot := top + extent y.

    aRectangle notNil ifTrue:[
	lft := lft max:aRectangle left.
	top := top max:aRectangle top.
	rgt := rgt min:aRectangle right.
	bot := bot min:aRectangle bottom.
    ].
    super clippingRectangle:(Rectangle left:lft top:top right:rgt bottom:bot).
!

scale
    "answer the scale excluding the fontScale factor"

    ^ super scale / fontScale
!

scale:aScale
    "set the scale and add the fontScale factor"

    super scale:(fontScale * (aScale ? 1.0)).
!

scale:scale translation:aPoint
    self
	translation:aPoint;
	scale:scale.
!

transformation
    "answer the transformation excluding the fontScale factor"

    ^ WindowingTransformation scale:(self scale)
			translation:(self translation).
!

transformation:aTransformation
    "set the transformation and add the fontScale factor"

    |s t|

    aTransformation notNil ifTrue:[
	s := aTransformation scale.
	t := aTransformation translation.
    ].
    self scale:s.
    self translation:t.
!

translateBy:aTranslation
    "set the translation and add the fontScale factor"

    aTranslation isNil ifTrue:[^ self].
    self translation:( self translation + (self scale * aTranslation)).
!

translation
    "answer the translation excluding the fontScale factor"

    |margin trans|

    margin := Point x:(self leftMargin) y:(self topMargin).
    trans  := (super translation / fontScale) rounded.

    ^ trans - margin
!

translation:aTranslation
    "set the translation and add the fontScale factor"

    |trans|

    trans := Point x:(self leftMargin) y:(self topMargin).

    aTranslation notNil ifTrue:[
	trans := trans + aTranslation.
    ].

    super translation:((trans * fontScale) rounded).
! !

!WinPrinterContext::WinPrinterGraphicContext methodsFor:'drawing strings'!

displayOpaqueString:aString from:index1 to:index2 x:x y:y
    self displayString:aString from:index1 to:index2 x:x y:y.
!

displayOpaqueString:aString x:x y:y
    |end|

    end := aString size.

    end ~~ 0 ifTrue:[
	self displayOpaqueString:aString from:1 to:end x:x y:y.
    ].
!

displayString:aString from:index1 to:index2 x:x y:y
    "setup the special scale for strings before drawing"

    |tscale fscale yFont xFont|

    index2 < index1 ifTrue:[^ self].

    self transformation isNil ifTrue:[
	self initTransformation.
    ].
    tscale := self transformation scale.
    fscale := tscale / fontScale.

    xFont := x * fontScale x.
    yFont := (y - self font ascent) * fontScale y.    "/ MM_TEXT - Ursprung liegt oben links

    self transformation scale:fscale.

    super displayString:aString from:index1 to:index2
		x:xFont truncated
		y:yFont truncated.

    self transformation scale:tscale.
!

displayString:aString x:x y:y
    |end|

    end := aString size.

    end ~~ 0 ifTrue:[
	self displayString:aString from:1 to:end x:x y:y.
    ].
!

displayString:aString x:x y:y angle:drawAngle opaque:opaque
    "angles other than 0 is not yet supported"

    |angle|

    angle := drawAngle.

    angle >= 360 ifTrue:[
	angle := angle - (((angle // 360)) * 360)
    ] ifFalse:[
	angle < 0 ifTrue:[
	    angle := angle - (((angle // 360)) * 360).
	    angle := angle + 360.
	    angle >= 360 ifTrue:[
		angle := angle - (((angle // 360)) * 360)
	    ]
	].
    ].
    angle == 0 ifTrue:[
	super displayString:aString x:x y:y angle:drawAngle opaque:opaque.
    ].
! !

!WinPrinterContext::WinPrinterGraphicContext methodsFor:'font stuff'!

fontMetricsOf:fontId
    "after retrieving the metrics, we have to scale the information"

    |metrics|

    metrics := super fontMetricsOf:fontId.
    metrics isNil ifTrue:[^ nil ].

    metrics ascent:((metrics ascent / fontScale y) rounded)
	    descent:((metrics descent / fontScale y) rounded + 1)
	    maxAscent:((metrics maxAscent / fontScale y) rounded)
	    maxDescent:((metrics maxDescent / fontScale y) rounded + 1)
	    minWidth:((metrics minWidth / fontScale x) rounded)
	    maxWidth:((metrics maxWidth / fontScale x) rounded)
	    avgWidth:((metrics averageWidth / fontScale x) rounded).

    ^ metrics
!

getFontWithFoundry:foundry family:family weight:weight
	      slant:slant spacing:spc pixelSize:pixelSize size:pointSize
	      registry:registry encoding:encoding

    "compute the pixels dependent on the Screen current resolution"

    |psize|

    psize := pixelSize.

    psize isNil ifTrue:[
	psize := (pointSize * (self getLogicalPixelSizeY) / (Screen current getLogicalPixelSizeY)) rounded.
    ].

    ^ super getFontWithFoundry:foundry family:family weight:weight
	      slant:slant spacing:spc pixelSize:psize size:pointSize
	      registry:registry encoding:encoding
!

titleFont
    "answer the font used for displaying page numbers..."

    titleFont isNil ifTrue:[
	titleFont := Font family:'helvetica' face:'medium' style:'roman' size:10.
	titleFont := titleFont onDevice:(self device).
    ].
    ^ titleFont
!

titleFont:aFont
    "set the font used for displaying page numbers..."

    (aFont notNil and:[aFont ~= titleFont]) ifTrue:[
	titleFont := aFont onDevice:(self device).
    ].
!

widthOf:aString from:index1 to:index2 inFont:aFontId
    "after retrieving the width, we have to scale the width"

    |w|

    w := super widthOf:aString from:index1 to:index2 inFont:aFontId.
    w := (w / fontScale x) rounded.
    ^ w
! !

!WinPrinterContext::WinPrinterGraphicContext methodsFor:'initialization & release'!

close
    "compatible with PSGraphicsContext"

    self endPrintJob.
!

initExtent
    "scale the extent"

    fontScale := self resolution / Screen current resolution.

    width  := (self printerWidthArea / fontScale x) rounded.
    width  := width - self leftMargin - self rightMargin.

    height := (self printerHeightArea / fontScale y) rounded.
    height := height - self topMargin - self bottomMargin.

    self initTransformation.
!

initTransformation
    |margin|

    self transformation isNil ifTrue:[
	margin := Point x:(self leftMargin) y:(self topMargin).

	self transformation: (WindowingTransformation scale:fontScale
					    translation:(margin * fontScale)).
    ].
!

initialize
    super initialize.

    device := nil.      "super initialize did set it to Screen current"

    pageCounter    := 0.
    needsEndOfPage := false.
    printPageNumbers := true.

    Language == #de ifTrue:[ pageNumberFormat := 'Seite %1' ]
		   ifFalse:[ pageNumberFormat := 'page %1'  ].
! !

!WinPrinterContext::WinPrinterGraphicContext methodsFor:'printing process'!

displayTitleDo:aNoneArgAction

    |oldClip oldTrans oldFont|

    oldClip := self clipingRectangleOrNil.
    oldClip notNil ifTrue:[ self deviceClippingBounds:nil ].

    oldTrans := self translation.
    oldFont  := self font.

    self  font:(self titleFont).
    self  translation:0.

    aNoneArgAction value.

    self translation:oldTrans.
    oldFont notNil ifTrue:[ self font:oldFont ].
    oldClip notNil ifTrue:[ self deviceClippingBounds:oldClip ].
!

endPage
    "ends the current page
     if the current page is already closed by endPage, the request will be ignored"

    |s|

    needsEndOfPage ifFalse:[
	^ self
    ].
    needsEndOfPage := false.

    printPageNumbers == true ifTrue:[
	self displayTitleDo:[
	    self displayString:title
                 x:(self extent x - (self font widthOf:title)) // 2
                 y:(self extent y + (self font ascent)).

	    s := pageNumberFormat bindWith:pageCounter.
	    self displayString:s
			     x:(self extent x - (self font widthOf:s))
			     y:(self extent y + (self font ascent)).
	]
    ].
    super endPage.
!

startPage
    "starts a new page
     if the current page is not closed by endPage, a endPage is forward to the device"

    needsEndOfPage ifTrue:[
	self endPage.
    ].
    super startPage.
    needsEndOfPage := true.
    pageCounter := pageCounter + 1.
! !

!WinPrinterContext::WinPrinterGraphicContext methodsFor:'queries'!

pixelPerInch
    ^ Point x:(self pixelsPerInchOfScreenWidth)
	    y:(self pixelsPerInchOfScreenHeight).
!

resolution
    ^ self pixelPerInch
! !

!WinPrinterContext class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
