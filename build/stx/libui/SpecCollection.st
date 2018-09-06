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
"{ Package: 'stx:libui' }"

ComponentSpec subclass:#SpecCollection
	instanceVariableNames:'collection'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!SpecCollection class methodsFor:'documentation'!

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
    Not normally used by applications.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!SpecCollection class methodsFor:'queries'!

supportsSubComponents
    "answer whether instances of the spec class support sub components"

    ^ true


! !

!SpecCollection methodsFor:'accessing'!

collection
    "return collection"

    ^ collection
!

collection:something
    "set collection"

    collection := something.
! !

!SpecCollection methodsFor:'building'!

buildSubViewsFor:aBuilder in:aView
    |views crs|

    crs := OrderedCollection new.

    collection notNil ifTrue:[
        views := collection collect:[:element |
            |v|

            "/
            "/ can only be nil, if class in a spec is not
            "/ found.
            "/
            element notNil ifTrue:[
                v := element buildViewWithLayoutFor:aBuilder in:aView.

                element class isLayoutContainer ifTrue:[
                    crs add:(element->v)
                ]
            ].
            v
        ]
    ].
    crs do:[:el|(el key) setLayoutsInLayoutContainer:(el value)].
    ^ views

    "Modified: / 26.10.1997 / 12:55:26 / cg"
!

buildViewFor:aBuilder in:v
    ^ self buildSubViewsFor:aBuilder in:v.
!

buildViewWithLayoutFor:aBuilder in:aView
    "redefined to suppress the postCreateView for the specCollection itself
     (there is no component for it); instead, it will be called for each individual
     component in the specCollection"

    self buildSubViewsFor:aBuilder in:aView.
    ^ aView
! !

!SpecCollection methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    self basicFromLiteralArrayEncoding:aSpecArray.

    collection := collection collect:[:element | element decodeAsLiteralArray].

    "Modified: / 30.1.2000 / 01:16:02 / cg"
!

literalArrayEncoding
    |coll|

    coll := collection 
                collect:[:aSubComponent |
                    aSubComponent literalArrayEncoding
                ].
    ^ Array with:self class name
            with:#collection:
            with:coll asArray

    "Modified: / 29.1.2000 / 23:04:51 / cg"
! !

!SpecCollection methodsFor:'enumerating'!

do:aBlock
    collection do:aBlock


! !

!SpecCollection methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    <resource: #obsolete>

    self fromViews:aView subViews callBack:aBlock.
!

fromViews:aCollectionOfViews callBack:aBlock
    |subSpecs subs|

    aCollectionOfViews notNil ifTrue:[
        subs := aCollectionOfViews reject:[:aSubView | (aSubView isKindOf:MenuView) ].
        subSpecs := OrderedCollection new.
        subs do:[:aSubView|
                |newSpec|

                newSpec := UISpecification fromView:aSubView callBack:aBlock.
                newSpec notNil ifTrue:[
                    subSpecs add:newSpec
                ]
        ].
        collection := subSpecs.
    ].

    "Modified: 28.2.1997 / 23:47:13 / cg"
! !

!SpecCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/SpecCollection.st,v 1.25 2013-06-04 09:39:10 cg Exp $'
! !

