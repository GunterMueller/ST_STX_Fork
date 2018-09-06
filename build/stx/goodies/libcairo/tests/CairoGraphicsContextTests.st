"{ Package: 'stx:goodies/libcairo/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#CairoGraphicsContextTests
	instanceVariableNames:'cairoify view'
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Tests'
!


!CairoGraphicsContextTests methodsFor:'private'!

performTest
    cairoify := true.
    [
        self setUpView.
        self performTestDrawingView: view.
    ] ensure: [ 
        self tearDownView.
    ].
    cairoify := false.
    [
        self setUpView.
        self performTestDrawingView: view.
    ] ensure: [ 
        self tearDownView.
    ].
    cairoify := nil.

    "Created: / 26-02-2016 / 22:01:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-03-2016 / 22:55:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

performTestDrawingView: aView
    aView topView label: 'Native - ', self name.
    aView paint: Color black on: Color white.
    aView backgroundColor: Color white.  
    aView clear.          
    cairoify ifTrue:[ 
        aView cairoify.
    ].
    self perform: testSelector sunitAsSymbol with: aView.

    "Created: / 01-03-2016 / 13:03:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 22:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContextTests methodsFor:'running'!

setUpView
    | top |
    self assert: Display notNil.
    top := StandardSystemView new.
    top label: self name.
    top origin: 10@10 extent: (32 * 8) @ (32 * 8).       
    view := SimpleView origin: 0.0 @ 0.0 corner: 1.0 @ 1.0 in: top.
    top openAndWait.

    "Created: / 31-03-2016 / 22:20:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDownView
    view notNil ifTrue:[ 
        view topView close.
    ].

    "Created: / 31-03-2016 / 22:20:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContextTests methodsFor:'tests'!

test_clip_01
    self assert: (view colorAtX: 5 y: 5) = Color white.

    view paint: Color red.
    view fillRectangleX: 0 y:0 width: 20 height: 20.
    self assert: (view colorAtX: 10 y: 10) = Color red.

    view clippingBounds: (5 @ 5 extent: 10 @ 10).
    view paint: Color blue.
    view fillRectangleX: 0 y:0 width: 20 height: 20.
    self assert: (view colorAtX: 3 y: 3) = Color red.
    self assert: (view colorAtX: 10 y: 10) = Color blue.
    self assert: (view colorAtX: 18 y: 18) = Color red.
    self assert: view clippingBounds = (5@5 corner: 15@15).

    view clippingBounds: nil.
    view paint: Color yellow.
    view fillRectangleX: 0 y:0 width: 40 height: 40.

    self assert: (view colorAtX: 10 y: 10) = Color yellow.
    self assert: (view colorAtX: 30 y: 30) = Color yellow.

    "Created: / 27-03-2016 / 00:01:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_clip_02
    self assert: (view colorAtX: 5 y: 5) = Color white.

    view transformation: (WindowingTransformation translation: 100@100).

    view paint: Color red.
    view fillRectangleX: 0 y:0 width: 20 height: 20.
    self assert: (view colorAtX: 10 y: 10) = Color white.
    self assert: (view colorAtX: 100 y: 100) = Color red.

    view clippingBounds: (5 @ 5 extent: 10 @ 10).
    view paint: Color blue.
    view fillRectangleX: 0 y:0 width: 20 height: 20.
    self assert: (view colorAtX: 3 y: 3) = Color white.
    self assert: (view colorAtX: 103 y: 103) = Color red.
    self assert: (view colorAtX: 10 y: 10) = Color white.
    self assert: (view colorAtX: 110 y: 110) = Color blue.
    self assert: (view colorAtX: 18 y: 18) = Color white.
    self assert: (view colorAtX: 118 y: 118) = Color red.                     

    view clippingBounds: nil.
    view paint: Color yellow.
    view fillRectangleX: 0 y:0 width: 40 height: 40.

    self assert: (view colorAtX: 10 y: 10) = Color white.
    self assert: (view colorAtX: 110 y: 110) = Color yellow.
    self assert: (view colorAtX: 130 y: 130) = Color yellow.

    "Created: / 27-03-2016 / 00:10:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_infrastructure_01
    self assert: (view colorAtX:5 y:5) = Color white.
    view fillRectangleX: 1 y: 1 width: 10 height: 10.
    self assert: (view colorAtX:5 y:5) = Color black.

    "Created: / 16-03-2016 / 18:34:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_resize_01
    self assert: (view colorAtX: 0 y:0) = Color white.
    view paint: Color red.
    view fillRectangleX: 0 y: 0 width: view width height: view height.
    self assert: (view colorAtX:  0 y:  0) = Color red.
    self assert: (view colorAtX:  view width - 1 y:  view height - 1) = Color red.
    view topView extent: view extent + (100 @ 100).
    Delay waitForSeconds: 1.
    view fillRectangleX: 0 y: 0 width: view width height: view height.
    self assert: (view colorAtX:  0 y:  0) = Color red.
    self assert: (view colorAtX:  view width - 1 y:  view height - 1) = Color red.

    "Created: / 29-03-2016 / 23:41:47 / jv"
    "Modified: / 02-04-2016 / 15:37:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-04-2016 / 16:10:39 / jv"
!

test_subview_moved_01
    "
     https://bitbucket.org/janvrany/stx-goodies-libcairo/issues/2"
    
    | top2  view2  view3  bbB  bbA |

    top2 := StandardSystemView new.
    top2 label:self name.
    top2 origin:10 @ 10 extent:(32 * 8) @ (32 * 8).
    view2 := SimpleView 
            origin:0.0 @ 0.0
            corner:1.0 @ 1.0
            in:top2.
    view3 := SimpleView 
            origin:0.0 @ 0.0
            corner:1.0 @ 1.0
            in:view2.
    top2 openAndWait.
    [
        | dGC  cGC |

        dGC := view2 instVarNamed:#gc.
        cGC := CairoGraphicsContext onDeviceGraphicsContext:dGC.
        view2 instVarNamed:#gc put:cGC.
        view2 clear.
        view3 clear.
        bbB := (cGC instVarNamed:#cr) clipBounds.
        view3 layout:(LayoutFrame origin:0.0 @ 0.5 corner:1.0 @ 1.0).
        view2 paint:Color blue.
         "
         view3 flash.
        "
        view2 
            fillRectangleX:0
            y:0
            width:view2 width
            height:view2 height.
        self assert:(view2 colorAtX:5 y:5) = Color blue.
    ] ensure:[ top2 close. ].

    "Created: / 25-03-2016 / 19:10:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2016 / 22:32:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-04-2016 / 16:06:05 / jv"
! !

!CairoGraphicsContextTests methodsFor:'tests - issues'!

test_issue001_01
    "
    https://bitbucket.org/janvrany/stx-goodies-libcairo/issues/1
    "
    self assert: (view colorAtX: 0 y:0) = Color white.
    view displayRectangleX: 0 y: 0 width: view width height: view height.
    self assert: (view colorAtX:  0 y:  0) = Color black.
    self assert: (view colorAtX:  view width - 1 y:  view height - 1) = Color black.

    "Created: / 16-03-2016 / 18:46:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue001_02b
    "
    https://bitbucket.org/janvrany/stx-goodies-libcairo/issues/1
    "
    self assert: (view colorAtX: 0 y:0) = Color white.
    view displayLineFromX: 0 y: view height - 1 toX: view width - 2 y: view height - 1.
    0 to: view width - 3 do:[:x |  
        self assert: (view colorAtX:  x y: view height - 1) = Color black.
    ].
    self assert: (view colorAtX:  view width - 1 y: view height - 1) = Color white.

    "Created: / 16-03-2016 / 19:24:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2016 / 23:24:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue001_02l
    "
    https://bitbucket.org/janvrany/stx-goodies-libcairo/issues/1
    "
    self assert: (view colorAtX: 0 y:0) = Color white.
    view displayLineFromX: 0 y: 0 toX: 0 y: view height - 2.
    0 to: view height - 3 do:[:y |  
        self assert: (view colorAtX: 0 y: y) = Color black.
    ].
    self assert: (view colorAtX: 0 y: view height - 1) = Color white.

    "Created: / 16-03-2016 / 19:26:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2016 / 23:24:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue001_02r
    "
    https://bitbucket.org/janvrany/stx-goodies-libcairo/issues/1
    "
    self assert: (view colorAtX: 0 y:0) = Color white.
    view displayLineFromX: view width - 1 y: 0 toX: view width - 1 y: view height - 2.
    0 to: view height - 3 do:[:y |  
        self assert: (view colorAtX: view width - 1 y: y) = Color black.
    ].
    self assert: (view colorAtX: view width - 1 y: view height - 1) = Color white.

    "Created: / 16-03-2016 / 19:27:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2016 / 23:24:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue001_02t
    "
    https://bitbucket.org/janvrany/stx-goodies-libcairo/issues/1
    "
    self assert: (view colorAtX: 0 y:0) = Color white.
    view displayLineFromX: 0 y: 0 toX: view width - 2 y: 0.
    0 to: view width - 3 do:[:x |  
        self assert: (view colorAtX: x y:  0) = Color black.
    ].
    self assert: (view colorAtX:  view width - 1 y: 0) = Color white.

    "Created: / 16-03-2016 / 19:24:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2016 / 23:25:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue001_03
    "
    https://bitbucket.org/janvrany/stx-goodies-libcairo/issues/1
    "
    self assert: (view colorAtX: 0 y:0) = Color white.
    view displayRectangleX: 0 y: 0 width: 10 height: 10.
    self assert: (view colorAtX:  0 y:  0) = Color black.
    self assert: (view colorAtX:  9 y:  9) = Color black.

    "Created: / 16-03-2016 / 19:30:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContextTests methodsFor:'tests - manual'!

manual_01
    "
    CairoGraphicsContextTests new manual_01
    "

    |top textView text |

    top := StandardSystemView new.
    top extent:300@200.

    textView := EditTextView new.
    textView cairoify.
    textView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
    top addSubView:textView.

    text := 'Hello ' asText , 'World!!' asText allBold.
    text allUnderwaved.
    textView contents: text.

    top open.

    "Created: / 04-04-2016 / 18:45:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

manual_02
    "
    CairoGraphicsContextTests new manual_02
    "

    |top textView |

    top := StandardSystemView new.
    top extent:300@25.

    textView := EditField new.
    textView cairoify.
    textView origin:0.0 @ 0.0 corner:1.0 @ 1.0.
    top addSubView:textView.



    top open.

    "Created: / 05-04-2016 / 09:02:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-04-2016 / 13:04:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContextTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

