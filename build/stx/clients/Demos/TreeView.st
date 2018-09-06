"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

"{ NameSpace: Smalltalk }"

ObjectView subclass:#TreeView
	instanceVariableNames:'topNode xIndent fgColor bgColor maxY maxX assoc'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Trees'
!

!TreeView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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

    subclasses should redefine:
           #childrenOf:anObject do:aBlock
           #textFor:anObject
           #colorFor:anObject

    [see also:]
        ClassTreeView WindowTreeView
        ObjectView DisplayObject

    [author:]
        Claus Gittinger - written spring 91
"
! !

!TreeView class methodsFor:'startup'!

open 
    |topView v|

    topView := StandardSystemView 
                    label:'Tree hierarchy'
                    icon:(Image fromFile:'Demo.icon' resolution:100).
    v  := HVScrollableView for:self in:topView.
    v origin:(0 @ 0) extent:(1.0 @ 1.0).
    topView open

    "ClassTreeView open"
    "WindowTreeView open"

    "Modified: / 27-06-2017 / 12:05:09 / mawalch"
! !

!TreeView methodsFor:'accessing'!

topNode
    ^ topNode
!

topNode:aNode
    topNode := aNode.
    realized ifTrue:[
        self updateTree.
    ].
! !

!TreeView methodsFor:'drawing'!

showSelected:anObject
    "show an object as selected"

    |fg bg|

    styleSheet is3D ifTrue:[
        fg := anObject foreground.

        anObject foreground:Color red.
        anObject drawIn:self.
        anObject foreground:fg
    ] ifFalse:[
        fg := anObject foreground.
        bg := anObject background.

        anObject foreground:bg background:fg.
        anObject drawIn:self.
        anObject foreground:fg background:bg.
    ]
! !

!TreeView methodsFor:'event handling'!

keyPress:key x:x y:y
    key == $z ifTrue:[
        self zoomIn:1.5.
        selection notNil ifTrue:[
            self makeVisible:selection
        ]
    ].
    key == $Z ifTrue:[
        self zoomOut:1.5.
        selection notNil ifTrue:[
            self makeVisible:selection
        ]
    ].

    "Modified: 27.4.1996 / 10:09:38 / cg"
!

mouseWheelZoom:amount
    "CTRL-wheel action"

    |mul|

    mul := 1.2.

    amount > 0 ifTrue:[
        self zoomIn:mul.
    ] ifFalse:[
        self zoomOut:mul.
    ].
! !

!TreeView methodsFor:'generating the class-tree picture'!

addChildrenToTreeFrom:anElement xPos:xPos yPos:yPos
    |newObject yNext|

    newObject := self addElementToTree:anElement xPos:xPos yPos:yPos.
    yNext := yPos + newObject frame height.

    self childrenOf:anElement do:[:aChild |
        yNext := self addChildrenToTreeFrom:aChild
                                       xPos:(xPos + xIndent)
                                       yPos:yNext
    ].
    ^ yNext
!

addElementToTree:anElement xPos:xPos yPos:yPos
    |newObject oldMaxX oldMaxY|

    newObject := DrawText new.
    newObject text:(self textFor:anElement).
    newObject origin:(xPos @ yPos).
    newObject 
        foreground:(self colorFor:anElement) 
        background:(self bgColorFor:anElement).
    newObject fillPattern:1.

    maxY := maxY max:(yPos + newObject height).
    maxX := maxX max:(xPos + newObject width).
    self add:newObject.
    assoc at:newObject put:anElement.
    ^ newObject
!

bgColorFor:anElement
    ^ bgColor
!

childrenOf:anElement do:aBlock
    "should be redefined for your type of elements"

    ^ nil
!

colorFor:anElement
    ^ Black
!

generateTree
    assoc isNil ifTrue:[
        assoc := IdentityDictionary new.
        self removeAll.
        maxX := 0.
        maxY := 0.
        self withWaitCursorDo:[
            self addChildrenToTreeFrom:topNode 
                                  xPos:(self horizontalPixelPerMillimeter:5) rounded asInteger
                                  yPos:(self verticalPixelPerMillimeter:5) rounded asInteger.
        ].
    ].
!

textFor:anElement
    "should return a string representing the element"

    ^ anElement printString
!

updateTree
    assoc := nil.
    self generateTree.
! !

!TreeView methodsFor:'initialization'!

initialize
    super initialize.

    xIndent := (self horizontalPixelPerMillimeter:10) rounded asInteger.
    pressAction := [:aPoint | self click:aPoint].
    fgColor := Black.
    bgColor := White.
    maxX := maxY := 0.
"/    self updateTree.
!

initializeMiddleButtonMenu
    "to be redefined in subclasses"
!

mapped
    super mapped.
    self generateTree.
    self changed:#sizeOfContents.
!

realize
    super realize.
"/    self generateTree
! !

!TreeView methodsFor:'queries'!

heightOfContents
    "sent by scrollbar to query contents size"

    ^ maxY
!

widthOfContents
    "sent by scrollbar to query contents size"

    ^ maxX
! !

!TreeView methodsFor:'support'!

elementForObject:anObject
    "return the draw-element which associates anObject"

    assoc isNil ifTrue:[
        self generateTree
    ].
    ^ assoc keyAtValue:anObject ifAbsent:nil
!

objectForElement:anElement
    "return the object associatioed to the draw-element"

    ^ assoc at:anElement ifAbsent:nil
!

withSelectedElementDo:aBlock
    selection isNil ifFalse:[
        aBlock value:(self objectForElement:selection)
    ]
! !

!TreeView methodsFor:'user interaction'!

click:aPoint
    |anObject|

    anObject := self findObjectAt:aPoint.
    (anObject ~~ selection) ifTrue:[
        self unselect.
        anObject notNil ifTrue:[
            self select:anObject
        ]
    ]
!

selectNode:aNode
    |element|

    element := self elementForObject:aNode.
    self select:element
! !

!TreeView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/TreeView.st,v 1.19 2017-06-27 10:10:02 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/TreeView.st,v 1.19 2017-06-27 10:10:02 mawalch Exp $'
! !

