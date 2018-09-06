"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

NoteBookView subclass:#TabView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!TabView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    implements the tabs-view component of a noteBook.
    May also be used on its own (without a surrounding noteBook).

    The functionality is basically the same as provided by a
    PopUpList or SelectionInListView, in that a valueHolder
    gets a value assigned corresponding to the selected tab
    from a list of possible tabs.

    [author:]
	Claus Atzkern

    [see also:]
	NoteBookView
	SelectionInListView PopUpList ValueHolder TabWidget
"

!

examples
"
    tabs at top of a view
                                                                                [exBegin]
    |top tab|

    top := StandardSystemView new label:'tabs at bottom'; extent:250@100.
    tab := TabView origin:(0.0 @ 0.0) corner:(1.0 @ 0.0)in:top.
    tab direction:#top.
    tab list:#( 'Foo' 'Bar' 'Baz' ).
    tab action:[:anIndex| Transcript showCR:anIndex ].
    tab bottomInset:(tab preferredExtent y negated).
    top open.
                                                                                [exEnd]

    tabs at bottom a view
                                                                                [exBegin]                                      
    |top tab|

    top := StandardSystemView new label:'tabs at bottom'; extent:250@100.
    tab := TabView origin:(0.0 @ 1.0) corner:(1.0 @ 1.0)in:top.
    tab direction:#bottom.
    tab list:#( 'Foo' 'Bar' 'Baz' ).
    tab action:[:anIndex| Transcript showCR:anIndex ].
    tab topInset:(tab preferredExtent y negated).
    top open.
                                                                                [exEnd]

    tabs at right of a view
                                                                                [exBegin]                                      
    |top tab|

    top := StandardSystemView new label:'tabs at right'; extent:100@250.
    tab := TabView origin:1.0 @ 0.0 corner:1.0 @ 1.0 in:top.

    tab direction:#right.
    tab list:#( 'Foo' 'Bar' 'Baz' ).
    tab action:[:aName|Transcript showCR:aName].
    tab leftInset:(tab preferredExtent x negated).
    top open.
                                                                                [exEnd]

    tabs at left of a view
                                                                                [exBegin]                                      
    |top tab view inset|

    top := StandardSystemView new label:'tabs at left'; extent:100@250.
    tab := TabView origin:0.0 @ 0.0 corner:0.0 @ 1.0 in:top.

    tab direction:#left.
    tab list:#( 'Foo' 'Bar' 'Baz' ).
    tab action:[:aName|Transcript showCR:aName].
    tab rightInset:(tab preferredExtent x negated).
    top open.
                                                                                [exEnd]

    using icons and text
                                                                                [exBegin]
    |top tab view list|

    top := StandardSystemView new label:'using icons, text, ..'; extent:300@100.
    tab := TabView origin:0.0 @ 0.0 corner:1.0 @ 0.0 in:top.
    list := OrderedCollection new.
    list add:( LabelAndIcon icon:(ToolbarIconLibrary workspace24x24Icon2) string:'Workspace' ).
    list add:( ToolbarIconLibrary workspace24x24Icon2 ).
    list add:( 'Workspace' ).
    list add:( 'Workspace' allBold ).

    tab list:list.
    tab hasScrollButtons:true.
    tab action:[:indexOrNil| Transcript showCR:indexOrNil ].
    tab bottomInset:(tab preferredExtent y negated).
    top open.
                                                                                [exEnd]
"
! !

!TabView methodsFor:'initialization'!

initStyle
    "setup style attributes
    "

    super initStyle.
    tabModus := true.


! !

!TabView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/TabView.st,v 1.48 2010-05-11 11:43:14 ca Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg2/TabView.st,v 1.48 2010-05-11 11:43:14 ca Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

