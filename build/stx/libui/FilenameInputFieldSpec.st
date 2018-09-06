"
 COPYRIGHT (c) 2000 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

InputFieldSpec subclass:#FilenameInputFieldSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!FilenameInputFieldSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    Not normally used by applications.

    Like an inputField, but knows that a fileName is to be entered;
    supports automatic path-completion on TAB.

    [author:]
        Claus Gittinger

    [see also:]
        InputFieldSpec
        UIBuilder
        UIPainter
"
! !

!FilenameInputFieldSpec class methodsFor:'image specs'!

icon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self icon inspect
     ImageEditor openOnClass:self andSelector:#icon"
    
    ^ Icon constantNamed:#'FilenameInputFieldSpec class icon'
        ifAbsentPut:[
            (Depth2Image new)
                width:18;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#( 2 ));
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@@PUUUUU0A????>@G????8@P@@@@!!AJ***2@D%UUUH@RUUQT QIUTURDD%UEUH@RPEPD AMUUUR@D@@@@H0_???? #*****A@@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 127 127 127 170 170 170 ];
                mask:((ImageMask new)
                            width:18;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'_?>@???@???@???@???@???@???@???@???@???@???@???@???@???@???@_?>@');
                            yourself);
                yourself
        ]
! !

!FilenameInputFieldSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:inst channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:inst channel:aChannel.

    env at:#fieldAttributesVisible put:false.
!

commonReplacementClasses
    "used by the UIPainter's 'replace-by' function"

    ^ Array     
        with:ComboBoxSpec
        with:LabelSpec
        with:TextEditorSpec
        with:InputFieldSpec

    "Created: / 12-01-2008 / 23:42:52 / cg"
! !

!FilenameInputFieldSpec methodsFor:'queries'!

userFriendlyName
    "answer a good noticeable name of the widget for the GUI Painter and the documentation"

    ^'FilenameEntryField'
!

viewClass
    "return the corresponding view class of the spec"

    self class == FilenameInputFieldSpec ifTrue:[
        ^ FilenameEditField
    ].
    ^ super viewClass
! !

!FilenameInputFieldSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/FilenameInputFieldSpec.st,v 1.7 2014-05-23 09:32:45 stefan Exp $'
! !

