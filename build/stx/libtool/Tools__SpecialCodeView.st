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

"{ NameSpace: Tools }"

ApplicationModel subclass:#SpecialCodeView
	instanceVariableNames:'displayMode'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!SpecialCodeView class methodsFor:'documentation'!

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
! !

!SpecialCodeView class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SpecialCodeView andSelector:#windowSpec
     SpecialCodeView new openInterface:#windowSpec
     SpecialCodeView open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'SpecialCodeView'
          #name: 'SpecialCodeView'
          #min: #(#Point 10 10)
          #bounds: #(#Rectangle 12 22 312 322)
        )
        #component: 
       #(#SpecCollection
          #collection: #()
        )
      )
! !

!SpecialCodeView class methodsFor:'documentation'!

version
    ^ '$Id: Tools__SpecialCodeView.st 8083 2013-01-14 11:48:37Z vranyj1 $'
!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/Tools_SpecialCodeView.st,v 1.3 2010/05/07 12:27:43 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__SpecialCodeView.st 8083 2013-01-14 11:48:37Z vranyj1 $'
! !

