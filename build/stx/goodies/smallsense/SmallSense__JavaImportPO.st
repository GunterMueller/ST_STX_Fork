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

PO subclass:#JavaImportPO
	instanceVariableNames:'klass import icon'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Java-Interface-PO'
!

!JavaImportPO class methodsFor:'documentation'!

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

!JavaImportPO class methodsFor:'image specs'!

packageIcon
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
        constantNamed:'Expecco::JIClassTree::PackagePO icon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@AT@@@@@@@@@@@@@@0XFA XOA XFA L@@@@@@@$E@ HME TB@ 4I@@@@@@@H@ @AB!!XB
@@DJB@@@@@@@C@HA@P\V@ DAA00@@@@@@@,MB \TE04JA1PK@@@@@ATOE!!XVE1\WE!!XVC1T@@@@@D@TB@ 4WAPHBCQ@@@@@@@@8B@@DJE H@@P(N@@@@@@@Q
@ DAA1XB@PDGDP@@@@@@D04JA1PVCP(GEAL@@@@@@@PRD!!HRC1HRD!!HD@@@@@@@@@@@@@AT@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[249 241 187 237 209 166 229 201 161 191 130 49 197 131 50 219 191 158 193 122 45 215 185 152 191 117 42 193 119 43 215 184 151 183 109 40 187 113 42 206 171 139 169 96 35 147 85 31 174 99 37 165 92 34 160 89 33 162 89 34 199 160 130 113 60 23 158 112 88 121 79 64]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@B@G?0_?A?<G?0_?C?>G?0_?A?<G?0_?@B@@@@b') ; yourself); yourself]

    "Created: / 20-10-2013 / 00:34:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaImportPO methodsFor:'accessing'!

icon

    icon isNil ifTrue:[
        icon := klass notNil 
                    ifTrue:[SystemBrowser iconForClass: klass]
                    ifFalse:[self class packageIcon].
    ].
    ^icon

    "Created: / 20-10-2013 / 00:32:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

import
    ^ import
!

import:aString
    import := aString.

    "Modified: / 20-05-2014 / 11:43:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

klass
    ^ klass
!

klass:something
    klass := something.
!

label
    ^ import

    "Created: / 20-05-2014 / 11:31:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringAlreadyWritten
    "Answers a string already written in the textview"    

    ^ context wordBeforeCursorConsisitingOfCharactersMatching:
        [:c | c isAlphaNumeric or:['$_.' includes: c] ]

    "Created: / 20-10-2013 / 00:19:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToCompleteForLanguage: aProgrammingLanguage
    "Answers a string to complete"

    ^ import , ';'.

    "Created: / 20-10-2013 / 00:39:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2014 / 10:10:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaImportPO class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

