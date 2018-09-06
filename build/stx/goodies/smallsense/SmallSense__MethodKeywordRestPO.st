"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

MethodPO subclass:#MethodKeywordRestPO
	instanceVariableNames:'keywords'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-PO'
!

!MethodKeywordRestPO class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!MethodKeywordRestPO class methodsFor:'accessing'!

icon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self icon inspect
     ImageEditor openOnClass:self andSelector:#icon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SmallSense::MethodKeywordRestPO icon'
        ifAbsentPut:[(Depth1Image new) width:13; height:11; bits:(ByteArray fromPackedString:'@@H@@@@@@@@@@@@@@@P@@@@E@@@@@0@a') ; colorMapFromArray:#[0 0 0 255 255 255]; mask:((Depth1Image new) width:13; height:11; bits:(ByteArray fromPackedString:'@@\@A0@G@@\@A0@GY&]&Y0@G@@\@A0@a') ; yourself); yourself]
! !

!MethodKeywordRestPO methodsFor:'accessing'!

icon
    ^ self class icon
!

keywords
    ^ keywords
!

keywords:something
    keywords := something.
!

label

    label isNil ifTrue:[
        label := keywords.
    ].
    ^ label

    "Created: / 08-04-2014 / 21:08:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToCompleteForLanguage: language

    "/ This PO is only valid for Smalltalk language...
    self assert: language isSmalltalk.

    ^ String 
        fromStringCollection: (keywords tokensBasedOn: $:)
        separatedBy: ':  '.

    "Created: / 08-04-2014 / 21:10:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodKeywordRestPO methodsFor:'initialization'!

initializeWithClasses: anArray"Of Classes" selector: aSymbol prefix: aString 
    selector := aSymbol.
    classes := anArray.
    keywords := (aSymbol copyFrom: aString size + 1)

    "Created: / 20-05-2014 / 10:44:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodKeywordRestPO class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

