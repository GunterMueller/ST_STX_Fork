"
 COPYRIGHT (c) 1992 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
"{ Package: 'stx:clients/Demos' }"

TreeView subclass:#TreeGraphView
	instanceVariableNames:'selectionHolder childPositionStrategy verticalLayout'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Trees'
!

Object subclass:#ChildPositionStrategy
	instanceVariableNames:'xIndent ySpace'
	classVariableNames:''
	poolDictionaries:''
	privateIn:TreeGraphView
!

TreeGraphView::ChildPositionStrategy subclass:#ChildrenBelowIndented
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TreeGraphView
!

TreeGraphView::ChildPositionStrategy subclass:#ChildrenToTheRight
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TreeGraphView
!

!TreeGraphView class methodsFor:'documentation'!

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

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"


!

documentation
"
    This is one of the oldest demo views in ST/X;
    many features which are now awailable were not at the time this was
    written. It definitely needs a facelift...

    a frameworkClass for tree display;
    used by classTreeView and directoryTreeView.

    subclasses should redefine:
           #childrenOf:anObject do:aBlock
           #textFor:anObject


    [see also:]
        ClassTreeGraphView
        ObjectView DisplayObject

    [author:]
        Claus Gittinger - written Sep 92
"
! !

!TreeGraphView class methodsFor:'queries - plugin'!

aspectSelectors
    ^ #( selectionHolder )

    "Created: / 10.2.2000 / 12:25:42 / cg"
! !

!TreeGraphView methodsFor:'accessing'!

verticalLayout:something
    verticalLayout := something.
! !

!TreeGraphView methodsFor:'accessing-channels'!

selectionHolder
    selectionHolder isNil ifTrue:[
        selectionHolder := ValueHolder new
    ].
    ^ selectionHolder

    "Modified: / 10.2.2000 / 00:53:58 / cg"
!

selectionHolder:aValueHolder
    selectionHolder := aValueHolder

    "Created: / 10.2.2000 / 00:53:25 / cg"
! !

!TreeGraphView methodsFor:'generating the class-tree picture'!

addChildrenToTreeFrom:anElement father:father xPos:xPos yPos:yPos first:isFirst
    |newObject yNext subPos nextPos subX subY subFirst anyChildren|

    newObject := self addElementToTree:anElement xPos:xPos yPos:yPos.
    father notNil ifTrue:[
        self addLineFrom:father to:newObject
    ].

    subPos := childPositionStrategy positionOfFirstChildUnder:newObject.

    subX := subPos x. "/ xPos + (newObject frame width) + xIndent.
    subY := subPos y. "/ yPos.

    yNext := subY.
    subFirst := true.
    anyChildren := false.
    self childrenOf:anElement do:[:aChild |
        yNext := self addChildrenToTreeFrom:aChild
                                     father:newObject
                                       xPos:subX
                                       yPos:yNext
                                      first:subFirst.
        subFirst := false.
        anyChildren := true.
    ].
    anyChildren ifFalse:[
        nextPos := childPositionStrategy positionOfNextChildUnder:newObject.
        yNext := nextPos y. "/ yPos + (newObject frame height) + 8
    ].
    ^ yNext
!

addChildrenToTreeFrom:anElement xPos:xPos yPos:yPos
    self addChildrenToTreeFrom:anElement father:nil xPos:xPos yPos:yPos first:true
!

addElementToTree:anElement xPos:xPos yPos:yPos
    |textObject rect fgColor bgColor rectOrg rectCorn|

    fgColor := self colorFor:anElement.
    bgColor := self bgColorFor:anElement.

    textObject := DrawText new.
    textObject setFont:self font.
    textObject text:(self textFor:anElement).
    textObject origin:(xPos @ yPos).
    textObject foreground:fgColor background:bgColor.
    textObject fillPattern:nil.
    assoc at:textObject put:anElement.

    styleSheet is3D ifTrue:[
        rect := DrawRectangle3D new.
        rect level:2.
        rect foreground:fgColor background:bgColor.
        rect fillPattern:bgColor.
        textObject background:bgColor.
    ] ifFalse:[
        rect := DrawRectangle new.
        rect foreground:fgColor background:White.
    ].

    rectOrg := textObject origin - (4 @ 2).
    rectCorn := textObject corner + (4 @ 2).

    rect origin:rectOrg corner:rectCorn.

    self add:rect.
    self add:textObject.

    maxX := maxX max:(rectCorn x).
    maxY := maxY max:(rectCorn y).

    ^ textObject
!

addLineFrom:superObject to:object
    childPositionStrategy 
        lineSegmentsFrom:superObject to:object 
        do:[:p1 :p2 |
            |line|

            line := DrawLine new.
            line origin:p1 corner:p2.
            line foreground:Black background:White.
            self add:line.
        ].
!

bgColorFor:element
    ^ Color grey
! !

!TreeGraphView methodsFor:'initialization'!

initialize
    super initialize.

    self viewBackground:(View defaultViewBackgroundColor).
    doublePressAction := [:p | self doubleClickAt:p].

    childPositionStrategy := ChildrenToTheRight new.
    childPositionStrategy xIndent:xIndent.
    childPositionStrategy ySpace:8.

"/    childPositionStrategy := ChildrenBelowIndented new.
"/    childPositionStrategy xIndent:xIndent + 40.
"/    childPositionStrategy ySpace:8.
! !

!TreeGraphView methodsFor:'misc'!

findObjectLabelled:pattern
    "find an object with the given label"

    contents do:[:el |
        |text|

        el isTextObject ifTrue:[
            text := el perform:#text ifNotUnderstood:nil.
            text notNil ifTrue:[
                text isStringCollection ifTrue:[
                    text := text asStringWith:Character cr
                ].
                (pattern match:text) ifTrue:[
                    ^ el
                ]
            ]
        ]
    ].
    ^ nil
!

makeVisible:anElement
    |pos|

    pos := (anElement origin * self scale) - (self extent // 2).
    pos := (pos x max:0) @ (pos y max:0).

    self scrollTo:pos rounded.
!

setSelectionHolderFor:anObjectOrCollection
    selectionHolder value:(self objectForElement:anObjectOrCollection)

    "Created: / 10.2.2000 / 01:45:45 / cg"
    "Modified: / 10.2.2000 / 01:46:43 / cg"
! !

!TreeGraphView methodsFor:'user interaction'!

doubleClick:anObject
    "double click on some object"

!

doubleClickAt:aPoint
    "double click at some point"

    |obj|

    obj := self findObjectAt:aPoint.
    obj notNil ifTrue:[
        "/ ignore line- and rectangle elements
        (obj isKindOf:DrawText) ifTrue:[
            self doubleClick:obj
        ]
    ]
!

select:anObject
    "dont allow selection of line- or rectangle elements"

    (anObject isKindOf:DrawText) ifTrue:[
        super select:anObject.
        selectionHolder notNil ifTrue:[
            self setSelectionHolderFor:anObject
        ]
    ]

    "Modified: / 10.2.2000 / 01:45:29 / cg"
! !

!TreeGraphView::ChildPositionStrategy methodsFor:'accessing'!

xIndent
    "return the value of the instance variable 'xIndent' (automatically generated)"

    ^ xIndent
!

xIndent:something
    "set the value of the instance variable 'xIndent' (automatically generated)"

    xIndent := something.
!

ySpace
    "return the value of the instance variable 'ySpace' (automatically generated)"

    ^ ySpace
!

ySpace:something
    "set the value of the instance variable 'ySpace' (automatically generated)"

    ySpace := something.
! !

!TreeGraphView::ChildPositionStrategy methodsFor:'connecting'!

lineSegmentsFrom:node1 to:node2 do:aBlock
    self subclassResponsibility.
! !

!TreeGraphView::ChildPositionStrategy methodsFor:'positioning'!

positionOfFirstChildUnder:newObject
    self subclassResponsibility.
!

positionOfNextChildUnder:newObject
    self subclassResponsibility.
! !

!TreeGraphView::ChildrenBelowIndented class methodsFor:'documentation'!

documentation
"
    generates an indented list:

    ---
        ---
        ---
            ---
            ---
        ---
        ---

"
! !

!TreeGraphView::ChildrenBelowIndented methodsFor:'connecting'!

lineSegmentsFrom:node1 to:node2 do:aBlock
    |x1 y1 x2 y2 frame1 frame2|

    frame1 := node1 frame.
    frame2 := node2 frame.

    x1 := frame2 left - 8.
    y1 := frame1 bottom.
    
    x2 := x1.
    y2 := frame2 leftCenter y rounded.
    aBlock value:(x1 @ y1) value:(x2 @ y2).

    x1 := x2.
    y1 := y2.

    x2 := frame2 left.
    y2 := y1.
    aBlock value:(x1 @ y1) value:(x2 @ y2).
! !

!TreeGraphView::ChildrenBelowIndented methodsFor:'positioning'!

positionOfFirstChildUnder:parent
    |parentPos parentX parentY subX subY|

    parentPos := parent frame origin.
    parentX := parentPos x.
    parentY := parentPos y.

    subX := parentX + xIndent.
    subY := parentY + (parent frame height) + ySpace.

    ^ subX @ subY
!

positionOfNextChildUnder:aNode
    |nodePos nodeX nodeY nextX nextY|

    nodePos := aNode frame origin.
    nodeX := nodePos x.
    nodeY := nodePos y.

    nextX := nodeX.
    nextY := nodeY + (aNode frame height) + ySpace.

    ^ nextX @ nextY
! !

!TreeGraphView::ChildrenToTheRight class methodsFor:'documentation'!

documentation
"
    generates a tree to the right

    ---
     |---*......*-----*
     |          |
     |          |---*......*-----*
     |     
     |
     |---*......*-----*

"
! !

!TreeGraphView::ChildrenToTheRight methodsFor:'connecting'!

lineSegmentsFrom:node1 to:node2 do:aBlock
    |x1 y1 x2 y2 xh frame1 frame2|

    frame1 := node1 frame.
    frame2 := node2 frame.

    x1 := frame1 right + 2.
    y1 := (frame1 top) + (frame1 height // 2).

    x2 := frame2 left - 2.
    y2 := (frame2 top) + (frame2 height // 2).
    xh := x1 + ((x2 - x1) // 2).

    y1 == y2 ifTrue:[
        aBlock value:(x1 @ y1) value:(x2 @ y1).
    ] ifFalse:[
        aBlock value:(x1 @ y1) value:(xh @ y1).
        aBlock value:(xh @ y1) value:(xh @ y2).
        aBlock value:(xh @ y2) value:(x2 @ y2).
    ].
! !

!TreeGraphView::ChildrenToTheRight methodsFor:'positioning'!

positionOfFirstChildUnder:parent
    |parentPos parentX parentY subX subY|

    parentPos := parent frame origin.
    parentX := parentPos x.
    parentY := parentPos y.

    subX := parentX + (parent frame width) + xIndent.
    subY := parentY.

    ^ subX @ subY
!

positionOfNextChildUnder:aNode
    |nodePos nodeX nodeY nextX nextY|

    nodePos := aNode frame origin.
    nodeX := nodePos x.
    nodeY := nodePos y.

    nextX := nodeX.
    nextY := nodeY + (aNode frame height) + ySpace.

    ^ nextX @ nextY
! !

!TreeGraphView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/TreeGraphView.st,v 1.18 2009-10-02 12:47:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/TreeGraphView.st,v 1.18 2009-10-02 12:47:38 cg Exp $'
! !
