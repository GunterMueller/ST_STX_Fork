"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

InfoBox subclass:#AboutBox
	instanceVariableNames:''
	classVariableNames:'DefaultGreen'
	poolDictionaries:''
	category:'Views-DialogBoxes'
!

!AboutBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    A box specialized to show the ST/X about-information (also usable for Applications).
    As a speciality, this box automatically closes if left
    alone for a while.

    Can be subclasses for your own aboutBoxes; to do so, redefine
    #defaultIcon and #aboutText.

    examples:
        AboutBox new open

        AboutBox new showAtPointer
"
!

examples
"
                                                                [exBegin]
    |box|

    box := AboutBox new.
    box autoHideAfter:10 with:[].
    box showAtCenter
                                                                [exEnd]

                                                                [exBegin]
    |box|

    box := AboutBox title:'About me'.
    box image:((Smalltalk 
                    bitmapFromFileNamed:'gifImages/claus.gif' 
                    inPackage:'stx:goodies') 
                magnifiedTo:100@100).
    box label:'Example'.
    box autoHideAfter:10 with:[].
    box showAtPointer.
                                                                [exEnd]
"
! !

!AboutBox class methodsFor:'defaults'!

aboutText
    "return a string to be shown in the box.
     Can be redefined in custom subclasses."

    |paddedLabelWith distributor expiration machine info resources|

    resources := self classResources.

    paddedLabelWith := 
        [:label :value |
            (((resources string:label) , ' ') paddedTo:20 with:$.) , ' ' , value
        ].

    distributor := Smalltalk distributorString.
    distributor notEmpty ifTrue:[
        distributor := paddedLabelWith value:'Distributor' value:distributor
    ].
    expiration := Smalltalk expirationTime.
    expiration notNil ifTrue:[
        expiration := paddedLabelWith value:'Expires' value:expiration
    ] ifFalse:[
        expiration := ''.
    ].
    machine := OperatingSystem getHostName.
    info := OperatingSystem getSystemInfo.
    (info includesKey:#machine) ifTrue:[
        machine := machine , ' (' , (info at:#machine) , ')'
    ].

    ^
'Smalltalk/X

' , (paddedLabelWith value:'Version' value:Smalltalk versionString) ,
                      ' (' , Smalltalk versionDate printString , ')
', distributor, '
', expiration , '
' , (paddedLabelWith value:'Release ID' value:Smalltalk releaseIdentification) , '
' , (paddedLabelWith value:'Configuration' value:Smalltalk configuration) , ' (' , (ExternalAddress pointerSize * 8) printString,'bit)
' , (paddedLabelWith value:'Running on' value:machine) , '
' , (paddedLabelWith value:'Started at' value:Smalltalk imageStartTime printString) , '

' , Smalltalk copyrightString , '

'

    "Modified: / 06-09-1996 / 10:11:08 / stefan"
    "Modified: / 16-04-2007 / 16:17:34 / cg"
!

defaultGreen
    "return the boxes default green color (eXept green)."

    DefaultGreen notNil ifTrue:[^ DefaultGreen].
    ^ Color red:0 green:80 blue:20
!

defaultIcon
    "return a Smalltalk/X icon.
     Can be redefined in custom subclasses."

    <resource: #programImage>

    ^ Icon stxIconTransparent3.
!

defaultLabel
    "return the boxes default window title."

    ^ 'About...'

    "Modified: 23.4.1996 / 17:09:48 / cg"
    "Created: 23.4.1996 / 17:11:46 / cg"
! !

!AboutBox class methodsFor:'image specs'!

stxIconTemplate
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self stxIconTemplate inspect
     ImageEditor openOnClass:self andSelector:#stxIconTemplate
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'AboutBox class stxIconTemplate'
        ifAbsentPut:[(Depth1Image width:48 height:48) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@')
            colorMapFromArray:#[0 0 0]
            mask:((ImageMask width:48 height:48) bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G@@@A @@O @@C@@@O @@F@@@O @@L@@@O0@@\@@@O0@@8@@@G0@A0@@@G8@C @@@C8@G@@@@C<@N@@
@@A<@\@@@@A>@8@@@@@>A0@@@@@_C @@@@@_G @@@@@O/@@@@@@O>@@@@@@G<@@@@@@G8@@@@@@C8@@@@@@G8@@@@@@O<@@@@@@_<@@@@@@>^@@@@@A<N@@@
@@C8O@@@@@O0G @@@@_ C @@@@?@A0@@@A>@A0@@@C<@@8@@@O8@@\@@@_0@@L@@@? @@N@@@? @@F@@@?@@@C@@@^@@@A@@@@@@@@ @@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@'); yourself); yourself]
! !

!AboutBox methodsFor:'initialization'!

initialize
    "setup the box; change all of my components viewBackground to some darkish grey."

    |dark green lbl|

    super initialize.

"/    self label:'About ...'.

    green := self class defaultGreen.    
    dark := Color grey:20.
    device hasColors ifFalse:[
        device hasGrayscales ifTrue:[
            green := Color brightness:(green brightness).    
            dark := Color brightness:(dark brightness).    
        ] ifFalse:[
            green := self whiteColor.
            dark := self blackColor.
        ]
    ].

    self withAllSubViewsDo:[:s | s viewBackground:dark].

    self image:(self class defaultIcon).
    (lbl := self formLabel) viewBackground:dark.
    lbl foregroundColor:green backgroundColor:dark.
    (lbl := self textLabel) viewBackground:dark.
    lbl foregroundColor:self whiteColor backgroundColor:dark.

    self title:(self class aboutText).
    self okText:(resources string:'Close').

    "Modified: / 12.6.1998 / 11:48:23 / cg"
! !

!AboutBox methodsFor:'show & hide'!

show
    "show the box.
     Redefined to automatically hide myself after some time"

    self autoHideAfter:15 with:[].
    super showAtCenter.

    "
     AboutBox new show
    "

    "Modified: 23.4.1996 / 17:10:03 / cg"
    "Modified: 6.9.1996 / 09:47:10 / stefan"
! !

!AboutBox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

