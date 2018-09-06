"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

ComponentSpec subclass:#CompositeSpecCollection
	instanceVariableNames:'collection compositeSpec'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!CompositeSpecCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!CompositeSpecCollection class methodsFor:'queries'!

supportsSubComponents
    ^ true

    "Created: 3.3.1997 / 14:41:25 / cg"
! !

!CompositeSpecCollection methodsFor:'accessing'!

collection
    "return collection"

    ^ collection

    "Created: 3.3.1997 / 14:41:25 / cg"
!

collection:something
    "set collection"

    collection := something.

    "Created: 3.3.1997 / 14:41:25 / cg"
!

compositeSpec
    "return compositeSpec"

    ^ compositeSpec

    "Created: 14.2.1997 / 13:59:18 / cg"
!

compositeSpec:something
    "set compositeSpec"

    compositeSpec := something.

    "Created: 14.2.1997 / 13:59:18 / cg"
! !

!CompositeSpecCollection methodsFor:'building'!

buildSubViewsFor:aBuilder in:v
    collection notNil ifTrue:[
        collection do:[:element |
            element buildViewWithLayoutFor:aBuilder in:v.
        ]
    ].
    ^ nil

    "Created: 3.3.1997 / 14:41:26 / cg"
    "Modified: 3.3.1997 / 18:51:04 / cg"
!

buildViewFor:aBuilder in:v
    |newView|

    newView := compositeSpec buildViewFor:aBuilder in:v.
    self buildSubViewsFor:aBuilder in:newView.
    ^ newView

    "Modified: 3.3.1997 / 15:43:17 / cg"
!

buildViewWithLayoutFor:aBuilder in:v
    |newView|

    newView := compositeSpec buildViewWithLayoutFor:aBuilder in:v.
    self buildSubViewsFor:aBuilder in:newView.
    ^ newView

    "Modified: 3.3.1997 / 15:43:40 / cg"
!

createViewFor:aBuilder in:aView
    ^ compositeSpec createViewFor:aBuilder in:aView.

    "Created: 3.3.1997 / 14:43:24 / cg"
! !

!CompositeSpecCollection methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "initialize my values from a specArray"

    2 to:aSpecArray size by:2 do:[:i | 
        self perform:(aSpecArray at:i) with:(aSpecArray at:i+1)
    ].

    collection notNil ifTrue:[
        collection := collection collect:[:element | element decodeAsLiteralArray].
    ].
    compositeSpec := compositeSpec decodeAsLiteralArray.

    "Created: 3.3.1997 / 14:41:26 / cg"
    "Modified: 26.3.1997 / 15:09:30 / cg"
!

literalArrayEncoding
    |coll|

    collection notNil ifTrue:[
        coll := OrderedCollection new.
        collection do:[:aSubComponent |
            coll add:aSubComponent literalArrayEncoding
        ].
        coll := coll asArray.
    ].
    ^ Array with:self class name
            with:#collection:
            with:coll
            with:#compositeSpec:
            with:(compositeSpec literalArrayEncoding)

    "Created: 3.3.1997 / 14:41:26 / cg"
    "Modified: 26.3.1997 / 15:08:04 / cg"
! !

!CompositeSpecCollection methodsFor:'enumerating'!

do:aBlock
    collection do:aBlock

    "Created: 3.3.1997 / 14:41:26 / cg"
! !

!CompositeSpecCollection methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    compositeSpec := CompositeSpec new fromView:aView callBack:aBlock.
    self fromViews:aView subViews callBack:aBlock.

    "Created: 3.3.1997 / 14:41:26 / cg"
    "Modified: 3.3.1997 / 22:48:27 / cg"
!

fromViews:aCollectionOfViews callBack:aBlock
    |subSpecs subs|

    aCollectionOfViews notNil ifTrue:[
        subs := aCollectionOfViews reject:[:aSubView | (aSubView isKindOf:MenuView) ].

        subSpecs := subs collect:[:aSubView | 
                                        |newSpec|

                                        newSpec := UISpecification fromView:aSubView callBack:aBlock.
                                        newSpec
                                 ].
        collection := subSpecs.
    ].

    "Modified: 28.2.1997 / 23:47:13 / cg"
    "Created: 3.3.1997 / 14:41:26 / cg"
! !

!CompositeSpecCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/CompositeSpecCollection.st,v 1.9 2013-06-04 10:13:34 cg Exp $'
! !

