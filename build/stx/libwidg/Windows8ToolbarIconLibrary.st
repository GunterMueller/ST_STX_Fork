"
 COPYRIGHT (c) 2013 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

VistaToolbarIconLibrary subclass:#Windows8ToolbarIconLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!Windows8ToolbarIconLibrary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by eXept Software AG
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
    ToolbarIconLibrary := Windows8ToolbarIconLibrary

    This is a style specific icon library for a windows8 look.

    Never access this iconlibrary directly from an application -
    always use ToolbarIconLibrary, which is an alias to one of the style specific
    icon libs.

    Notice and Warning:
        only redefine existing icons here; never add ionly to here.
        For every icon-method here, there MUST be a corresponding (albeit
        possibly ugly) icon-method in GenericToolBarIcon.
"
! !

!Windows8ToolbarIconLibrary class methodsFor:'image specs'!

downArrowEnteredIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self downArrowEnteredIcon inspect
     ImageEditor openOnClass:self andSelector:#downArrowEnteredIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'Windows8ToolbarIconLibrary downArrowEnteredIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:15;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@HH@1 C.@G0@N@@P@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 240 240 240 0 0 0 ];
                mask:((ImageMask new)
                            width:15;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@D@@P@A@@DHHP1!!C.DG0PNA@PD@@P@A@@D@@P@a');
                            yourself);
                yourself
        ]
!

downArrowPassiveIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self downArrowPassiveIcon inspect
     ImageEditor openOnClass:self andSelector:#downArrowPassiveIcon
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'Windows8ToolbarIconLibrary downArrowPassiveIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:15;
                height:14;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@@@@@@HH@1 C.@G0@N@@P@@@@@@@@@@@@@a');
                colorMapFromArray:#[ 240 240 240 96 96 96 ];
                mask:((ImageMask new)
                            width:15;
                            height:14;
                            bits:(ByteArray 
                                        fromPackedString:'@@D@@P@A@@DHHP1!!C.DG0PNA@PD@@P@A@@D@@P@a');
                            yourself);
                yourself
        ]
! !

!Windows8ToolbarIconLibrary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

