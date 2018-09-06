"
 COPYRIGHT (c) 1990 by Claus Gittinger
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





"{ Package: 'stx:clients/LogicTool' }"

"{ NameSpace: Demos }"

LogicObject subclass:#SubCircuit
	instanceVariableNames:'inputs outputs gates connections'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-LogicTool-Objects'
!

!SubCircuit class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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
    a sub circuit (macro)

    [author:]
        Claus Gittinger (spring 90)
"





! !

!SubCircuit class methodsFor:'instance creation'!

createFrom:aBunchOfObjects
    ^ self new createFrom:aBunchOfObjects
! !

!SubCircuit class methodsFor:'specification'!

genericName
    ^ 'sub'
!

numberOfInputs
    ^ 0
!

numberOfOutputs
    ^ 0
! !

!SubCircuit methodsFor:'drawing'!

drawIn:aView offset:anOffset
    |xpos ypos w h|

    xpos := origin x + anOffset x.
    ypos := origin y + anOffset y.
    w := frame width.
    h := frame height.
    aView clearRectangleX:xpos y:ypos width:w height:h.
    aView paint:(Color black).
    aView displayRectangleX:(xpos + 8)
		       y:(ypos + 8)
		   width:(w - 16)
		  height:(h - 16).
    self inputPinsDo:[:aPoint |
	aView displayLineFromX:(aPoint x) y:(aPoint y)
			   toX:(aPoint x + 7) y:(aPoint y)
    ].
    self outputPinsDo:[:aPoint |
	aView displayLineFromX:(aPoint x - 7) y:(aPoint y)
			   toX:(aPoint x) y:(aPoint y)
    ].
    self name notNil ifTrue:[
	aView displayString:name x:xpos y:(ypos + h + (aView font ascent))
    ]
! !

!SubCircuit methodsFor:'frame computation'!

recomputeFrame
    |max nPixel|

    origin isNil ifFalse:[
	max := (self numberOfInputs) max:(self numberOfOutputs).
	nPixel := (max + 1) * 16.
	(nPixel < 64) ifTrue:[nPixel := 64].
	frame := Rectangle origin:origin
			   extent:(64 @ nPixel)
    ]
! !

!SubCircuit methodsFor:'instance creation'!

createFrom:aBunchOfObjects
    inputs := OrderedCollection new.
    outputs := OrderedCollection new.
    gates := OrderedCollection new.
    connections := OrderedCollection new.
    aBunchOfObjects do:[:anObject |
	(anObject isKindOf:Connection) ifTrue:[
	    connections add:anObject
	] ifFalse:[
	    (anObject isKindOf:Input) ifTrue:[
		inputs add:anObject
	    ] ifFalse:[
		(anObject isKindOf:Output) ifTrue:[
		    outputs add:anObject
		] ifFalse:[
		    gates add:anObject
		]
	    ]
	]
    ].
    self numberOfInputs:(inputs size).
    self numberOfOutputs:(outputs size).
    self recomputeFrame
! !

!SubCircuit methodsFor:'misc'!

height
    ^ frame height
!

width
    ^ 64
! !

!SubCircuit methodsFor:'simulation'!

evaluate
    |oldValue newValue|

    "first, pass all input values down into inner inputs"
    1 to:(self numberOfInputs) do:[:index |
	(inputs at:index) state:(inputValues at:index)
    ].
    "then, propagate the signals"
    connections do:[:aConnection |
	aConnection propagate
    ].
    "evaluate all gates"
    gates do:[:aGate |
	aGate evaluate
    ].
    "pass output values up from inner outputs"
    changed := false.
    1 to:(self numberOfOutputs) do:[:index |
	oldValue := outputValues at:index.
	newValue := (outputs at:index) value.
	outputValues at:index put:newValue.
	(oldValue ~~ newValue) ifTrue:[
	    changed := true
	]
    ]
! !

!SubCircuit class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/LogicTool/SubCirc.st,v 1.7 2000-12-28 14:55:14 cg Exp $'
! !
