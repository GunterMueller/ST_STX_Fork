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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

HierarchicalItem subclass:#ClassNameItem
	instanceVariableNames:'revisionInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-Support'
!

!ClassNameItem class methodsFor:'documentation'!

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
    This is not yet finished (work in progress) - do not use.

    [author:]
        Pierre Schwarz (ps@exept.de)

    [see also:]

    [instance variables:]

    [class variables:]
"

! !

!ClassNameItem class methodsFor:'image specs'!

icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self icon inspect
     ImageEditor openOnClass:self andSelector:#icon
    "

    <resource: #image>

    ^Icon
        constantNamed:#'ClassNameItem icon'
        ifAbsentPut:[(Depth8Image new) width: 20; height: 20; photometric:(#palette); bitsPerSample:(#(8 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0L@@ HB@ HB@ HB@ HB@@@@@@@C@0@B@@@@@@@@@@@@@@H@@@@@@@LC@@H@@PDA@PDA@PD@@ @@@@@@@0L@@ @A@PD@
@@@@@@@@@@@@@@@C@0@B@@DA@P@D@ PBA@HD@ P@@@LC@@H@@@DA@@HD@ PBA@HD@ @@@0L@@ @E@@D@A@HD@@@@@@HD@@@C@0@B@@@E@@@BA@H@@ P@A@H@
@@LC@@H@@@@E@@PBA@HD@ PBA@@@@0L@@ @@@@@@@ PBA@HD@ PB@@@C@0@B@@P@@@@D@ PBA@HD@ P@@@LC@@H@@ P@@@@@@@@@@@@@@@@@@0L@@ @D@ @@
@@@@@@@@@@@@@@@C@0@B@@HD@ PBA@HD@@H@@@@@@@LC@@H@A@HD@ PBA@H@@ @@@@@@@0L@@ @@@@@@@@@@@@@B@@@@@@@C@0@B@ HB@ HB@ HB@ H@@@@@
@@@C@@HB@ HB@ HB@ HB@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 119 124 119 248 252 0 119 124 0 168 168 168 248 252 248]; mask:((Depth1Image new) width: 20; height: 20; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??>O??>O??>O??>O??????????????????????????????????????>O??>O??>O??>O??>O_?>OO?>O') ; yourself); yourself]
! !

!ClassNameItem methodsFor:'accessing'!

needsChildren

    ^false


!

revisionInfo
    "return the value of the instance variable 'revisionInfo' (automatically generated)"

    ^ revisionInfo
!

revisionInfo:something
    "set the value of the instance variable 'revisionInfo' (automatically generated)"

    revisionInfo := something.
! !

!ClassNameItem methodsFor:'protocol'!

hasChildren
"a name class items has no childs

<return: Boolean>
"
     ^false

!

icon

    ^self class icon



!

label

    | aStream user recordType fileName date time rev pkgDir clsName cvsRoot theText|
    aStream := WriteStream on:String new.
    user := revisionInfo at:#user ifAbsent:'?'.
    recordType := revisionInfo at:#cvsRecordType ifAbsent:'?'.
    fileName := revisionInfo at:#fileName ifAbsent:'?'.
    date := revisionInfo at:#date ifAbsent:'?'.
    time := revisionInfo at:#time ifAbsent:'?'.
    rev := revisionInfo at:#revision ifAbsent:'?'.
    pkgDir := revisionInfo at:#directory ifAbsent:'?'.
    clsName := revisionInfo at:#className ifAbsent:'?'.
    cvsRoot := revisionInfo at:#cvsRoot ifAbsent:'?'.

    ^(Text string:fileName emphasis:#bold),
        (Text string:(String with:Character cr)),
        (Text string:recordType),
        (Text string:' '),
        (Text string:(date printString paddedTo:5)),
        (Text string:' '),
        (Text string:(time printString paddedTo:5)),
        (Text string:' '),
        (Text string:(user printString paddedTo:10)),
        (Text string:(String with:Character tab)),
        (Text string:(rev decimalPaddedTo:8 and:3 at:$. withLeft:(Character space) right:nil)),
        (Text string:(String with:Character tab)),
        (Text string:(pkgDir paddedTo:20))        
!

middleButtonMenu
"returns the middleButtonMenu or nil if no menu is defined

<return: nil>
"
    ^ nil


! !

!ClassNameItem class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/ClassNameItem.st,v 1.3 2000/02/18 14:08:58 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

