"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1992 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

VariablePanel subclass:#VariableHorizontalPanel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Layout'
!

!VariableHorizontalPanel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    This class is only here for backward compatibility;
    all functionality is now in VariablePanel. Its orientation can now
    be changed dynamically.

    A View to separate its subviews horizontally by a movable bar
    to adjust the size-ratios.
    The bar-handle is either an exposed knob (knobStyle == #motif)
    or the forms defined in Scroller (knobStyle ~~ #motif)
    or nothing.

    The subvies dimensions MUST be given as relative sizes;
    typically creation is done as:

        p := VariableHorizontalPanel in:superView.
        v1 := <someViewClass> origin:0.0 @ 0.0
                              corner:0.5 @ 1.0
                                  in:p.
        v2 := <someViewClass> origin:0.5 @ 0.0
                              corner:0.8 @ 1.0
                                  in:p.
        v3 := <someViewClass> origin:0.8 @ 0.0
                              corner:1.0 @ 1.0
                                  in:p.

    See examples.

    [author:]
        Claus Gittinger
"
!

examples
"
   VariableHorizontalPanel is simply setting its orientation
   to #horizontal. See more examples there.

   dummy example: 2 views side-by-side
                                                                        [exBegin]
        |top p v1 v2|

        top := StandardSystemView new.
        top extent:300@200.

        p := VariableHorizontalPanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.

        v1 := View 
                 origin:0.0 @ 0.0
                 corner:0.5 @ 1.0
                 in:p.
        v1 viewBackground:Color red.

        v2 := View 
                 origin:0.5 @ 0.0
                 corner:1.0 @ 1.0
                 in:p.
        v2 viewBackground:Color green.

        top open
                                                                        [exEnd]


   concrete example: a selectionInListView and a TextView side-by-side
   (not useful - need scrollBars; see next example)
                                                                        [exBegin]
        |top p v1 v2|

        top := StandardSystemView new.
        top extent:400@300.

        p := VariableHorizontalPanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.

        v1 := SelectionInListView 
                 origin:0.0 @ 0.0
                 corner:0.5 @ 1.0
                 in:p.
        v1 list:('/etc' asFilename directoryContents).
        v1 useIndex:false.
        v1 action:[:name | v2 contents:('/etc/' , name) 
                                asFilename contentsOfEntireFile
                  ].

        v2 := TextView 
                 origin:0.5 @ 0.0
                 corner:1.0 @ 1.0
                 in:p.

        top open
                                                                        [exEnd]


    better - with scrollBars (but that's another story ... see ScrollableView examples for more):
                                                                        [exBegin]
        |top p v1 v2|

        top := StandardSystemView new.
        top extent:400@300.

        p := VariableHorizontalPanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.

        v1 := ScrollableView for:SelectionInListView 
                 origin:0.0 @ 0.0
                 corner:0.5 @ 1.0
                 in:p.
        v1 list:('/etc' asFilename directoryContents).
        v1 useIndex:false.
        v1 action:[:name | v2 contents:('/etc/' , name) 
                                asFilename contentsOfEntireFile
                  ].

        v2 := ScrollableView for:TextView 
                 origin:0.5 @ 0.0
                 corner:1.0 @ 1.0
                 in:p.

        top open
                                                                        [exEnd]


   another stupid example: 3-views side-by-side
                                                                        [exBegin]
        |top p v1 v2 v3|

        top := StandardSystemView new.
        top extent:550@200.

        p := VariableHorizontalPanel 
                 origin:0.0 @ 0.0
                 corner:1.0 @ 1.0
                 in:top.

        v1 := SelectionInListView 
                 origin:0.0 @ 0.0
                 corner:0.3 @ 1.0
                 in:p.
        v1 level:-1.
        v1 list:#('one' 'two' 'three' nil 'dont expect' 'something' 'to happen here').

        v2 := EditTextView 
                 origin:0.3 @ 0.0
                 corner:0.6 @ 1.0
                 in:p.
        v2 contents:'nonScrollable\EditTextView' withCRs.

        v3 := ScrollableView 
                 for:TextView 
                 origin:0.6 @ 0.0 
                 corner:1.0 @ 1.0
                 in:p.
        v3 contents:'scrollable\TextView\\(read only)\\\\\\\\\\\\\\\\\concratulations !!\you managed\to scroll down' withCRs.
        top open
                                                                        [exEnd]
"
! !

!VariableHorizontalPanel methodsFor:'initialization'!

initialize
    orientation := #horizontal.
    super initialize.

    "Modified: 7.3.1996 / 14:08:35 / cg"
! !

!VariableHorizontalPanel class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

