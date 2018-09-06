"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg3' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libwidg3
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libwidg3 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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
    Package documentation:

    This library contains special (less used) gui components (widgets).
    Some of them are exotic and experimental.

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libwidg3 class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
	#'stx:libbasic'    "LibraryDefinition - superclass of stx_libwidg3 "
	#'stx:libui'    "NamedSpec - superclass of BarChartWidgetSpec "
	#'stx:libview'    "GraphicsContext - superclass of DigitalClockView "
	#'stx:libview2'    "DisplayObject - superclass of BarChart3DWidget::Label "
	#'stx:libwidg'    "DialogBox - superclass of ActionWaitBox "
	#'stx:libwidg2'    "ImageView - superclass of ColorBulletIndicator "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
	#'stx:libbasic2'    "TimeDuration - referenced by ClockView>>timeShown "
    )
! !

!stx_libwidg3 class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBWIDG3_BASE
LIB_BASE=$(LIBWIDG3_BASE)
'
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libwidg3 class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
	"<className> or (<className> attributes...) in load order"
	AbstractChart
	ActionWaitBox
	AnimatedLabel
	BarChart3DWidget
	BarChartWidget
	BarChartWidgetSpec
	ChartDescription
	ChartDescriptionSpec
	ClockView
	ColorBulletIndicator
	DigitalClockView
	DigitalLedDisplay
	(GraniteBox autoload)
	MeterClackCounter
	MeterClackCounterSpec
	MeterWidget
	MeterWidgetSpec
	PieChartWidget
	PieChartWidgetSpec
	RoundProgressIndicator
	SimpleFunctionGraphView
	VUMeter
	(WoodenBox autoload)
	(WoodenMenu autoload)
	#'stx_libwidg3'
	BarChart
	ChartKey
	PieChart
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libwidg3 class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:47:42 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Special Widgets'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1999\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:19:30 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libwidg3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/stx_libwidg3.st,v 1.46 2017-02-22 15:39:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/stx_libwidg3.st,v 1.46 2017-02-22 15:39:37 cg Exp $'
! !

