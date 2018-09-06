"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

ResourcePack subclass:#ViewStyle
	instanceVariableNames:'name is3D viewGrey'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!ViewStyle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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
    instances of this class keep all view-style specific information.
    The current viewStyle is kept in Views-classvariable called 'StyleSheet'
    and is instantiated with 'View defaultStyle:aStyleSymbol', which reads
    a stylesheet from a file '<aStyleSymbol>.style' (usually in the 'resources'
    directory.

    [see also:]
	View
	( Configuration & Customization :html: custom/TOP.html#VIEWSTYLE )

    [author:]
	Claus Gittinger
"
! !

!ViewStyle class methodsFor:'instance creation'!

fromFile:aFileNameArg
    "get the preferences definitions from a file"

    |aFileName prefs failed nm nmInStyles dir path baseName|

    aFileName := aFileNameArg asFilename.
    (aFileName hasSuffix:'style') ifTrue:[
        baseName := aFileName withoutSuffix baseName.
        nm := aFileName.
    ] ifFalse:[
        baseName := aFileName baseName.
        nm := aFileName withSuffix:'style'.
    ].
    nm isAbsolute ifFalse:[
        nmInStyles := 'styles' asFilename / nm
    ].

    prefs := self new.
    prefs at:#name put:baseName. 

    nmInStyles notNil ifTrue:[
        path := Smalltalk getResourceFileName:nmInStyles forPackage:'stx:libview'.
    ].
    path isNil ifTrue:[
        path := Smalltalk getResourceFileName:nm forPackage:'stx:libview'.
    ].
    path notNil ifTrue:[
        dir := path asFilename directory pathName.
    ].
    failed := (prefs readFromFile:nm directory:dir) isNil.
    prefs at:#fileReadFailed put:failed. 
    ^ prefs

    "
     ViewStyle fromFile:'motif'  
     ViewStyle fromFile:'motif.style'  
     ViewStyle fromFile:'normal.style' 
     ViewStyle fromFile:'iris.style'
     ViewStyle fromFile:'iris.style' asFilename
    "

    "Modified: / 10.12.1999 / 16:05:30 / cg"
! !

!ViewStyle class methodsFor:'constants'!

adwaita
    ^ #Adwaita

    "Created: / 24-11-2016 / 17:54:58 / cg"
!

macosx_yosemite
    ^ #'macosx_yosemite'

    "Created: / 24-11-2016 / 17:55:46 / cg"
!

msWindows8
    ^ #mswindows8
!

msWindowsVista
    ^ #mswindowsVista
!

msWindowsXP
    ^ #mswindowsXP
!

normal
    ^ #normal
! !

!ViewStyle methodsFor:'accessing'!

at:key
    ^ self at: key default: nil for: thisContext sender receiver

    "Modified: / 10-09-1995 / 10:59:38 / claus"
    "Modified: / 19-07-2016 / 21:41:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at:key default:default
    ^ self at: key default: default for: thisContext sender receiver

    "Created: / 14-10-1997 / 00:21:15 / cg"
    "Modified: / 15-09-1998 / 21:47:13 / cg"
    "Modified: / 19-07-2016 / 21:41:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

at:key default:default for: class
    "Retrieve a style resource (color, image, string...) for given key and
     view `class`. If not found, `default` is returned.

     Resource `key` is either a simple key (for example 'foo') or
     compound key (for example 'bar.foo'). Resource is looked up
     as follows:

     1. key '<class name>.foo' is looked up, if it exists
        then its value is returned.
     2. key 'bar.foo' is looked up, if it exists then
        then its value is returned (only if key is compound)
     3. key 'foo' is looked up,  if it exists then
        then its value is returned
     4. `default` value is returned.

    This has been added to support fine-grained resource (mainly color) specification
    allowing (easy) customization per widget class (in a somewhat predictable) way.
    All that while being backward compatible.
    "

    | i key1 key2 key3 |

    i := key indexOf: $..
    i ~~ 0 ifTrue:[ 
        key3 := (key copyFrom: i + 1).
        key2 := key.
    ] ifFalse:[ 
        key3 := key.
        key2 := nil.
    ].
    key1 := class class theNonMetaclass name , '.' , key3.

    (self includesKey:key1) ifTrue:[
        ^ (super at:key1 ifAbsent:default) value
    ].
    (key2 notNil and:[self includesKey:key2]) ifTrue:[
        ^ (super at:key2 ifAbsent:default) value
    ].
    (self includesKey:key3) ifTrue:[
        ^ (super at:key3 ifAbsent:default) value
    ].
    ^ default value.

    "Created: / 19-07-2016 / 22:21:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

colorAt: key
    ^ self colorAt: key default: nil for: thisContext sender receiver

    "Modified: / 19-07-2016 / 21:32:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

colorAt:key default:default
    ^ self colorAt:key default:default for: thisContext sender receiver

    "Modified (format): / 19-07-2016 / 21:36:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

colorAt:key default:default for:class
    "retrieve a color resource - also acquire a device color
     to avoid repeated color allocations later"

    |value device deviceColor|

    device := Display.

    value := self at:key default:default for: class.
    value isInteger ifTrue:[
        value := Color rgbValue:value
    ].
    (value notNil and:[device notNil]) ifTrue:[
        deviceColor := value onDevice:device.
        deviceColor notNil ifTrue:[^ deviceColor].
    ].
    ^ value

    "Created: / 19-07-2016 / 21:32:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-07-2016 / 22:40:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doesNotUnderstand:aMessage
    ^ self at:(aMessage selector) default:nil
!

fontAt:key
   ^ self fontAt: key default: nil for: thisContext sender receiver.
!

fontAt:key default:default
    ^ self fontAt:key default:default for: thisContext sender receiver

    "Modified: / 19-07-2016 / 22:42:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fontAt:key default:default for: class
    "retrieve a font resource - also acquire a device font
     to avoid repeated font allocations later"

    ^ self deviceResourceAt:key default:default for: class

    "Created: / 19-07-2016 / 22:42:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

is3D
    is3D isNil ifTrue:[
	is3D := self at:#is3D default:false.
    ].
    ^ is3D
!

name
    name isNil ifTrue:[
	name := self at:#name default:'noname'.
    ].
    ^ name
!

viewGrey
    viewGrey isNil ifTrue:[
        viewGrey := self at:#viewGrey default:nil.
    ].
    ^ viewGrey
! !

!ViewStyle methodsFor:'error handling'!

nonexistingFileRead
    "here, a non-existing stylesheet is treated as an error"

    fileReadFailed := true.
    ^ self

    "Created: 6.9.1997 / 11:40:16 / cg"
! !

!ViewStyle methodsFor:'private'!

deviceResourceAt:key default:default for: class
    "retrieve a resource - also acquire a device version
     for the default display, to avoid repeated allocations later"

    |aResource deviceResource device|

    device := Display.

    aResource := self at:key default:default for: class.
    (aResource notNil and:[device notNil]) ifTrue:[
        deviceResource := aResource onDevice:device.
        deviceResource notNil ifTrue:[^ deviceResource].
    ].
    ^ aResource

    "Created: / 19-07-2016 / 22:41:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ViewStyle methodsFor:'queries'!

isWindowsStyle
    "answer true if this is a MS-Windows style.
     XXX Currently we simply check the name"

    |nm|

    nm := name ? self name.

    ^ nm == #win95 
    or:[nm == #win98
    or:[nm == #winXP
    or:[nm == #winVista ]]]
!

isWindowsVistaStyle
    ^ (name ? self name) == #winVista

    "Modified (format): / 19-11-2016 / 15:49:48 / cg"
!

isWindowsXPStyle
    "answer true if this is a MS-Windows-XP (or later) style.
     XXX Currently we simply check the name"

    |nm|

    nm := name ? self name.

    ^ nm == #winXP 
    or:[nm == #winVista]
! !

!ViewStyle methodsFor:'special'!

newDerivedStyle
    "create and return a new style, which inherits from
     the receiver, but possibly overrides individual entries.
     This may be useful to give a single button some different
     look (in the future - read the comment in SimpleView>>viewStyle:)"

    ^ self class new
        superPack:self; 
        at:#is3D put:(self is3D);
        at:viewGrey put:(self viewGrey);
        yourself

    "
     |panel b1 b2 newStyle|

     panel := HorizontalPanelView new.
     panel add:(b1 := Button label:'oldStyle').
     panel add:(b2 := Button label:'newStyle').
     newStyle := b1 styleSheet newDerivedStyle.
     newStyle at:'button.activeBackgroundColor' put:Color blue.
     b2 styleSheet:newStyle.        

     panel open
    "
! !

!ViewStyle class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

