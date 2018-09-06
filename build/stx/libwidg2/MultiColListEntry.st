"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

ListEntry subclass:#MultiColListEntry
	instanceVariableNames:'strings tabSpec'
	classVariableNames:'DefaultTabSpec'
	poolDictionaries:''
	category:'Views-Support'
!

!MultiColListEntry class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    Instances of MultiColListEntry can be used in place of strings
    as entries of the list in a ListView or SelectionInListView.
    They allow data to be presented in table (or any other) form.
    See example here and in TabulatorSpecs documentation.
    Notice, that each entry can have its own tabulator specification;
    although, usually all share a single spec.
    Also, notice that each column may align different; making these
    perfect elements to present table data.

    MultiColListEntry and TabulatorSpec were originally created to
    support nice tabular display of file-lists in the FileBrowser
    (see its long list); you may find many other uses ...

    [author:]
        Claus Gittinger
"
!

examples
"
     putting multiColListEntries into a ListView (instead of strings)
                                                                        [exBegin]
        |v e myList tabs|

        myList := OrderedCollection new.

        tabs := TabulatorSpecification new.
        tabs unit:#inch.
        tabs positions:#(0 3 4).
        tabs align:#(left #center #left).

        e := MultiColListEntry fromString:'left centered left'.
        e tabulatorSpecification:tabs.
        myList add:e.

        e := MultiColListEntry fromString:'| | |'.
        e tabulatorSpecification:tabs.
        myList add:e.
        myList add:''.

        e := MultiColListEntry fromString:'hello hallo salut'.
        e tabulatorSpecification:tabs.
        myList add:e.

        e := MultiColListEntry 
                 fromString:'good morning,guten Morgen,bon jour'
                 separatedBy:$,.
        e tabulatorSpecification:tabs.
        myList add:e.

        e := MultiColListEntry new.
        e colAt:1 put:'good bye'.
        e colAt:2 put:'auf Wiedersehen'.
        e colAt:3 put:'au revoir '.
        e tabulatorSpecification:tabs.
        myList add:e.

        v := ListView new.
        v setList:myList expandTabs:false.
        v extent:500@100.
        v open
                                                                        [exEnd]



     many multiColListEntries in a scrollable ListView
                                                                        [exBegin]
        |v l e myList tabs|

        myList := OrderedCollection new.

        tabs := TabulatorSpecification new.
        tabs unit:#cm.
        tabs positions:#(1 3 5).
        tabs align:#(#right #center #left).

        1 to:100 do:[:i|
            e := MultiColListEntry new.
            e colAt:1 put:i printString.
            e colAt:2 put:i squared printString.
            e colAt:3 put:i sqrt  printString.
            e tabulatorSpecification:tabs.
            myList add:e.
        ].
        l := ListView new.
        l setList:myList expandTabs:false.
        v := ScrollableView forView:l.
        v extent:300@200.
        v open
                                                                        [exEnd]



     like above, but uses nicer decimal alignments
                                                                        [exBegin]
        |v l e myList tabs|

        myList := OrderedCollection new.
        
        tabs := TabulatorSpecification new.
        tabs unit:#cm.
        tabs positions:#(1 3 6 9 12).
        tabs align:#(#right #decimal #decimal #decimal #decimal).

        1 to:100 do:[:i|
            e := MultiColListEntry new.
            e colAt:1 put:i printString.
            e colAt:2 put:i log printString.
            e colAt:3 put:i sqrt  printString.
            e colAt:4 put:i sin  printString.
            e colAt:5 put:i cos  printString.
            e tabulatorSpecification:tabs.
            myList add:e.
        ].
        l := ListView new.
        l setList:myList expandTabs:false.
        v := ScrollableView forView:l.
        v extent:600@200.
        v open
                                                                        [exEnd]



     specifying tabs in inches
                                                                        [exBegin]
        |v l e myList tabs|

        myList := OrderedCollection new.

        tabs := TabulatorSpecification new.
        tabs unit:#inch.
        tabs positions:#(0 2 3.5 4 6 8 10 12).

        e := MultiColListEntry new.
        e colAt:1 put:'2'.
        e colAt:2 put:'3.5'.
        e colAt:3 put:'4'.
        e colAt:4 put:'6'.
        e colAt:5 put:'8'.
        e colAt:6 put:'10'.
        e colAt:7 put:'12'.
        e tabulatorSpecification:tabs.
        myList add:e.

        myList add:((MultiColListEntry fromString:'| | | | | | |')
                         tabulatorSpecification:tabs).
        myList add:((MultiColListEntry fromString:'xxx xxx xxx xxx xxx xxx xxx')
                         tabulatorSpecification:tabs).

        l := ListView new.
        l setList:myList expandTabs:false.
        v := HVScrollableView forView:l.
        v extent:600@200.
        v open
                                                                        [exEnd]


     if you have the columns available as a collection, 
     setup can be done easier
                                                                        [exBegin]
        |v l e myList tabs|

        myList := OrderedCollection new.

        tabs := TabulatorSpecification new.
        tabs unit:#inch.
        tabs positions:#(0 2 3.5 4 6 8 10 12).

        e := MultiColListEntry new.
        e strings:#('2' '3.5' '4' '6' '8' '10' '12').
        e tabulatorSpecification:tabs.
        myList add:e.

        l := ListView new.
        l setList:myList expandTabs:false.
        v := HVScrollableView forView:l.
        v extent:600@200.
        v open
                                                                        [exEnd]


     using icons instead of strings:
                                                                        [exBegin]
        |v l e myList tabs i1 i2 i3|

        myList := OrderedCollection new.

        tabs := TabulatorSpecification new.
        tabs unit:#cm.
        tabs positions:#(1 3 5).
        tabs align:#(#left #left #left).

        i1 := Image fromFile:'bitmaps/xpmBitmaps/document_images/small_dir.xpm'.
        i2 := Image fromFile:'bitmaps/xpmBitmaps/document_images/small_file.xpm'.
        i3 := Image fromFile:'bitmaps/xpmBitmaps/document_images/small_file_binary.xpm'.

        1 to:100 do:[:i|
            e := MultiColListEntry new.
            i odd ifTrue:[
                e colAt:1 put:i1.
            ] ifFalse:[
                e colAt:1 put:i2
            ].
            e colAt:2 put:i printString.
            e colAt:3 put:i3.
            e tabulatorSpecification:tabs.
            myList add:e.
        ].
        l := SelectionInListView new.
        l setList:myList expandTabs:false.
        v := ScrollableView forView:l.
        v extent:300@200.
        v open
                                                                        [exEnd]



    concrete example, show /etc/passwd in a table:
                                                                        [exBegin]

        |v l s myList line e htabs tabs fingerEntry|

        tabs := TabulatorSpecification new.
        tabs unit:#inch.
        tabs positions:#(0    2      3.5  4.5   5    8    11).
        tabs align:    #(left left right right left left left).

        htabs := TabulatorSpecification new.
        htabs unit:#inch.
        htabs positions:#(0    2      3.5      4.5    5    8    11).
        htabs align:    #(left center center center left left left).

        myList := OrderedCollection new.

        e := MultiColListEntry 
                    fromString:'login-name:password:uid:gid:finger-entry:home-dir:shell' 
                    separatedBy:$:.
        e tabulatorSpecification:htabs.
        myList add:e.
        myList add:''.

        s := '/etc/passwd' asFilename readStream.
        [s atEnd] whileFalse:[
            line := s nextLine.
            e := MultiColListEntry 
                        fromString:line
                        separatedBy:$:.
            fingerEntry := e colAt:5.
            e colAt:5 put:(fingerEntry asCollectionOfSubstringsSeparatedBy:$,) first.
            e tabulatorSpecification:tabs.
            myList add:e.
        ].
        s close.
        
        l := ListView new.
        l setList:myList expandTabs:false.
        v := HVScrollableView forView:l.
        v extent:600@200.
        v open
                                                                        [exEnd]

    a (dynamic) menu with aligned columns:
                                                                        [exBegin]
    |menu item l tabSpec n1 n2 n3 n4|

    menu := Menu new.

    tabSpec := TabulatorSpecification new.
    tabSpec unit:#inch.
    tabSpec positions:#(0     1.5     ).
    tabSpec align:    #(#left #right).

    n1 := 123456.
    n2 := 123.
    n3 := 11111.
    n4 := 9876.

    l := MultiColListEntry fromStrings:#('N1:' '') tabulatorSpecification:tabSpec.
    l colAt:2 put:n1 printString.
    item := MenuItem new.
    item label:l.
    menu addItem:item.

    l := MultiColListEntry fromStrings:#('N2:' '') tabulatorSpecification:tabSpec.
    l colAt:2 put:n2 printString.
    item := MenuItem new.
    item label:l.
    menu addItem:item.

    l := MultiColListEntry fromStrings:#('N3:' '') tabulatorSpecification:tabSpec.
    l colAt:2 put:n3 printString.
    item := MenuItem new.
    item label:l.
    menu addItem:item.

    l := MultiColListEntry fromStrings:#('N4:' '') tabulatorSpecification:tabSpec.
    l colAt:2 put:n4 printString.
    item := MenuItem new.
    item label:l.
    menu addItem:item.

    menu showAtPointer.
                                                                        [exEnd]

"
! !

!MultiColListEntry class methodsFor:'instance creation'!

fromString:aString
    "create and return a new listEntry with columns taken
     from the words of aString. Assumes that columns are
     separated by spaces in the string"

    ^ self fromString:aString separatedBy:(Character space)

    "
     self fromString:'hello world a b' 
    "
!

fromString:aString separatedBy:separatorCharacter
    "create and return a new listEntry with columns taken
     from the words of aString. Assumes that columns are
     separated by separatorCharacter in the string"

    |subStrings|

    subStrings := aString asCollectionOfSubstringsSeparatedBy:separatorCharacter.
    ^ self fromStrings:subStrings

    "
     self fromString:'hello:world:a:b' separatedBy:$:
    "
!

fromString:aString separatedBy:separatorCharacter tabulatorSpecification:aTabSpec
    "create and return a new listEntry with columns taken
     from the words of aString. Assumes that columns are
     separated by separatorCharacter in the string"

    |e|

    e := self fromString:aString separatedBy:separatorCharacter.
    e tabulatorSpecification:aTabSpec.
    ^ e

    "
     |tabSpec|

     tabSpec := TabulatorSpecification new.
     tabSpec unit:#inch.
     tabSpec positions:#(0     1.5     ).
     tabSpec align:    #(#left #right).

     self fromString:'hello world a b' separatedBy:(Character space) tabulatorSpecification:tabSpec
    "
!

fromStrings:aCollectionOfStrings
    "create and return a new listEntry with columns taken
     from the given aStrings."

    |idx e|

    e := self new.
    idx := 1.
    aCollectionOfStrings do:[:sub |
        e colAt:idx put:sub.
        idx := idx + 1.
    ].
    ^ e

    "
     self fromStrings:#('hello' 'world')
    "
!

fromStrings:aCollectionOfStrings tabulatorSpecification:aTabSpec
    "create and return a new listEntry with columns taken
     from the given aStrings."

    ^ (self fromStrings:aCollectionOfStrings) tabulatorSpecification:aTabSpec

    "
     |tabSpec|

     tabSpec := TabulatorSpecification new.
     tabSpec unit:#inch.
     tabSpec positions:#(0     1.5     ).
     tabSpec align:    #(#left #right).

     self fromStrings:#('hello' 'world') tabulatorSpecification:tabSpec
    "
!

new:numberOfColumns
    "create and return a new listEntry with numberOfColumns empty columns"

    |e|

    e := self new.
    1 to:numberOfColumns do:[:i |
        e colAt:i put:''.
    ].
    ^ e

    "Modified: 30.8.1995 / 16:33:53 / claus"
!

new:numberOfColumns tabulatorSpecification:aTabSpec
    "create and return a new listEntry with numberOfColumns empty columns
     and the given tab-specification"

    ^ (self new:numberOfColumns) tabulatorSpecification:aTabSpec

    "Modified: 30.8.1995 / 16:34:23 / claus"
! !

!MultiColListEntry methodsFor:'accessing'!

colAt:index
    "return the substring at column index"

    index > strings size ifTrue:[^ nil].
    ^ strings at:index
!

colAt:index put:aString
    "replace the substring at column index"

    strings isNil ifTrue:[
        strings := OrderedCollection new:index
    ].
    strings ensureSizeAtLeast:index.
    strings at:index put:aString
!

strings:aCollectionOfStrings
    "replace all substrings"

    strings := OrderedCollection withAll:aCollectionOfStrings. 
!

tabulatorSpecification:aTabSpec
    "set the tabulator spec"

    tabSpec := aTabSpec
! !

!MultiColListEntry methodsFor:'converting'!

asString
    "return the receiver as a string with embedded tabs"

    |s sub tab 
     nSub "{ Class: SmallInteger }"|

    s := ''.
    tab := Character tab asString.
    nSub := strings size.
    1 to:nSub do:[:subStringIndex |
        sub := strings at:subStringIndex.
        sub notNil ifTrue:[
            sub isString ifTrue:[
                s := s , sub.
            ]
        ].
        subStringIndex == nSub ifFalse:[
            s := s , tab
        ]
    ].

    ^ s

    "Created: 24.11.1995 / 18:54:27 / cg"
    "Modified: 17.4.1997 / 03:21:13 / cg"
! !

!MultiColListEntry methodsFor:'defaults'!

defaultTabSpec
    "the default tabulators are 1 inch apart"
    
    |spec|

    spec := DefaultTabSpec.
    spec isNil ifTrue:[
        spec := TabulatorSpecification new.
        spec unit:#inch.
        spec positions:(0 to:20).
        spec align:#left.
        DefaultTabSpec := spec.
    ].
    ^ spec.

    "Created: 17.11.1995 / 12:23:29 / cg"
    "Modified: 17.11.1995 / 12:24:20 / cg"
! !

!MultiColListEntry methodsFor:'drawing'!

displayOn:aGC x:x y:y opaque:opaque
    "display the receiver on a GC"

    |xPos spec tabPos prevString y0|

    spec := tabSpec.
    spec isNil ifTrue:[
        spec := self defaultTabSpec
    ].
    xPos := x.
    prevString := ''.

    aGC font:aGC deviceFont.

    y0 := y - aGC font ascent.

    strings keysAndValuesDo:[:index :subString |
        |item|

        subString notNil ifTrue:[
            "
             find next tab
            "
            tabPos := spec positionOfTab:index forString:subString on:aGC.
            tabPos isNil ifTrue:[
                "
                 no tab - just continue where we are ...
                "
                xPos := xPos + (prevString widthOn:aGC). "/ not: (aGC font widthOf:prevString) -- could be text or image
            ] ifFalse:[
                xPos := tabPos + x.
            ].
            subString isString ifTrue:[
                opaque ifTrue:[    
                    aGC displayOpaqueString:subString x:xPos y:y.
                ] ifFalse:[    
                    aGC displayString:subString x:xPos y:y.
                ].    
            ] ifFalse:[
                item := subString.
                item isImage ifTrue:[
                    strings at:index put:(item := item onDevice:aGC device)
                ].
                item displayOn:aGC x:xPos y:y0
            ].
            prevString := subString.
        ]
    ].

    "Modified: 19.4.1997 / 09:54:56 / cg"
! !

!MultiColListEntry methodsFor:'queries'!

heightOn:aGC
    "return the height of the receiver when displayed in aGC"

    |hMax|

    hMax := 0.
    strings keysAndValuesDo:[:index :subString |
        |h|

        subString notNil ifTrue:[
            h := subString heightOn:aGC.
            hMax := hMax max:h.
        ]
    ].
    ^ hMax

    "Created: 15.4.1997 / 09:39:07 / cg"
!

widthOn:aGC
    "return the width of the receiver when displayed in aGC"

    |xPos xMax tabPos prevLen|

    "just to make certain:
     do not assume, that the last col is the rightmost one ...
    "
    xPos := 0.
    xMax := 0.
    prevLen := 0.
    strings keysAndValuesDo:[:index :subString |
        |w|

        subString notNil ifTrue:[
            "
             find next tab
            "
            tabPos := tabSpec positionOfTab:index forString:subString on:aGC.
            tabPos isNil ifTrue:[
                "
                 no tab - just continue where we are ...
                "
                xPos := xPos + prevLen.
            ] ifFalse:[
                xPos := tabPos.
            ].
            w := prevLen := subString widthOn:aGC. "/ aGC font widthOf:subString.
            xMax := xMax max:(xPos + w).
        ]
    ].
    xMax isInteger ifFalse:[
        ^ xMax truncated + 1
    ].
    ^ xMax

    "Created: 12.5.1996 / 20:38:38 / cg"
    "Modified: 17.4.1997 / 12:52:00 / cg"
! !

!MultiColListEntry class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

