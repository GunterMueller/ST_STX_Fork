"
 COPYRIGHT (c) 2003 by eXept Software AG
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

NoteBookView subclass:#TabControl
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Layout'
!

!TabControl class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    implements a tabControl - that is a NoteBook with a subCanvas.
    (it is more specific than a NoteBook, which allows for an arbitrary
    view to be used; here, a subCanvas is created right from the start).

    [author:]
        Claus Gittinger

    [see also:]
        NoteBook TabView
"
!

examples
"
    tabs at top ( default )
                                                                                [exBegin]                                      
    |specs spec1 spec2 spec3 top tab|

    ' In a real world app, these would be provided by Spec-methods...' .
    spec1 :=
        #(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Unlabeled Canvas' 
                        #bounds: #(#Rectangle 800 600 1000 800 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#TextEditorSpec 
                                        #layout: #(#LayoutFrame 2 0 2 0 -2 1 -29 1 ) 
                                        #name: #text 
                                        #model: #testHolder 
                                        #tabRequiresControl: true ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame 5 0 -27 1 105 0 -2 1 ) 
                                        #name: #parse 
                                        #model: #parse 
                                        #label: 'Parse' 
                                        #defaultable: true ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame 110 0 -27 1 210 0 -2 1 ) 
                                        #name: #parseAndInspect 
                                        #model: #parseAndInspect 
                                        #label: 'Parse and Inspect' 
                                        #defaultable: true ) ) ) ).

    spec2 :=
        #(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Unlabeled Canvas' 
                        #bounds: #(#Rectangle 576 432 776 632 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#TextEditorSpec 
                                        #layout: #(#LayoutFrame 2 0 2 0 -2 1 -2 1 ) 
                                        #name: #text 
                                        #model: #scannerHolder 
                                        #tabRequiresControl: true ) ) ) ).

    spec3 :=
        #(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Unlabeled Canvas' 
                        #bounds: #(#Rectangle 800 600 1000 800 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#LabelSpec 
                                        #layout: #(#AlignmentOrigin -5 0.4 5 0 1 0 ) 
                                        #name: #Label2 
                                        #label: 'Scanner class:' ) 
                                #(#InputFieldSpec 
                                        #layout: #(#LayoutFrame 6 0.4 5 0 -36 1 27 0 ) 
                                        #name: #scannerClassName 
                                        #model: #scannerClassNameHolder 
                                        #type: #string ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -32 1 5 0 -10 1 27 0 ) 
                                        #name: #findScannerClassButton 
                                        #model: #findScannerClass 
                                        #label: '...' 
                                        #defaultable: true ) 
                                #(#LabelSpec 
                                        #layout: #(#AlignmentOrigin -5 0.4 35 0 1 0 ) 
                                        #name: #Label3 
                                        #label: 'Parser class:' ) 
                                #(#InputFieldSpec 
                                        #layout: #(#LayoutFrame 6 0.4 35 0 -36 1 57 0 ) 
                                        #name: #parserClassName 
                                        #model: #parserClassNameHolder 
                                        #type: #string ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -32 1 35 0 -10 1 57 0 ) 
                                        #name: #findParserClassButton 
                                        #model: #findParserClass 
                                        #label: '...' 
                                        #defaultable: true ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -50 0.333333 122 0 50 0.333333 144 0 ) 
                                        #name: #compileLALR1 
                                        #model: #compileLALR1 
                                        #label: 'Compile LALR(1)' 
                                        #isDefault: true 
                                        #defaultable: true ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -50 0.666666 122 0 50 0.666666 144 0 ) 
                                        #name: #compileLR1 
                                        #model: #compileLR1 
                                        #label: 'Compile LR(1)' 
                                        #isDefault: false 
                                        #defaultable: true ) 
                                #(#DividerSpec 
                                        #layout: #(#LayoutFrame 5 0 150 0 -5 1 152 0 ) 
                                        #name: #Divider1 ) 
                                #(#LabelSpec 
                                        #layout: #(#Point 10 155 ) 
                                        #name: #Label4 
                                        #label: 'Messages:' ) 
                                #(#TextEditorSpec 
                                        #layout: #(#LayoutFrame 10 0 177 0 -10 1 -10 1 ) 
                                        #name: #conflicts 
                                        #model: #conflictHolder 
                                        #tabRequiresControl: true ) 
                                #(#CheckBoxSpec 
                                        #layout: #(#LayoutFrame 5 0.5 60 0 205 0.5 79 0 ) 
                                        #name: #generateDefinitionComments 
                                        #model: #generateDefinitionCommentsHolder 
                                        #label: 'Generate definition comments' ) 
                                #(#CheckBoxSpec 
                                        #layout: #(#LayoutFrame 5 0.5 80 0 205 0.5 103 0 ) 
                                        #name: #generateSymbolComments 
                                        #model: #generateSymbolCommentsHolder 
                                        #label: 'Generate symbol comments' ) 
                                #(#CheckBoxSpec 
                                        #layout: #(#LayoutFrame 5 0.5 100 0 205 0.5 123 0 ) 
                                        #name: #generateItemSetComments 
                                        #model: #generateItemSetCommentsHolder 
                                        #label: 'Generate item set comments' ) 
                                #(#CheckBoxSpec 
                                        #layout: #(#LayoutFrame -205 0.5 80 0 -5 0.5 103 0 ) 
                                        #name: #allowUnicode 
                                        #model: #allowUnicodeHolder 
                                        #label: 'Allow Unicode Characters' ) 
                                #(#CheckBoxSpec 
                                        #layout: #(#LayoutFrame -205 0.5 60 0 -5 0.5 83 0 ) 
                                        #name: #ignoreCase 
                                        #model: #ignoreCaseHolder 
                                        #label: 'Ignore Case' ) ) ) ).

    specs := Array with:spec1 with:spec2 with:spec3.

    top  := StandardSystemView extent:400@300.
    tab := TabControl origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:top.
    tab list:#( 'Foo' 'Bar' 'Baz' ).
    tab action:[:index | 
        tab 
            client:(ApplicationModel new)
            spec:(specs at:index).
    ].
    top open.
                                                                                [exEnd]
"
! !

!TabControl methodsFor:'canvas access'!

client:anApplication spec:anUISpec
    canvas client:anApplication spec:anUISpec
!

client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder
    canvas client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder
!

client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder withMenu:withMenuBoolean
    canvas client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder withMenu:withMenuBoolean
! !

!TabControl methodsFor:'initialization'!

initialize
    canvas := SubCanvas in:self.
    super initialize
! !

!TabControl class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/TabControl.st,v 1.2 2006-03-13 19:27:30 cg Exp $'
! !

