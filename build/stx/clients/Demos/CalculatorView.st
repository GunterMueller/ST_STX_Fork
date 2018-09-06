"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1989-93 by Claus Gittinger
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

"{ NameSpace: Demos }"

StandardSystemView subclass:#CalculatorView
	instanceVariableNames:'prevOperand thisOperand operator displayView base hexDigitButtons
		nonOctalButtons state'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Goodies'
!

CalculatorView comment:'
 a simple (and stupid) demo calculator

 start with:
       CalculatorView open

 written spring/summer 89 by claus
'
!

!CalculatorView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989-93 by Claus Gittinger
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
    one of the oldest view examples in ST/X.
    Today, things could be written differently ... (still works, though)
    (see a modern version in CodingExamples_GUI::GUIDemoCalculator, which was
     created using the GUI builder)

    [see also:]
        Panel Button

    [start with:]
        CalculatorView open
"
! !

!CalculatorView class methodsFor:'instance creation'!

new
    "create a new instance; define its icon and windowLabel"

    ^ super new
        label:'Calculator';
        icon:(Image fromFile:'bitmaps/Calc.xbm');
        yourself

    "Modified: 23.4.1996 / 21:21:43 / cg"
! !

!CalculatorView class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:41:36 / cg"
! !

!CalculatorView methodsFor:'button actions'!

baseKey:value
    "one of the radix buttons was pressed"

    base := value.
    base == 16 ifFalse:[
        hexDigitButtons do:[:butt | butt disable]
    ] ifTrue:[
        hexDigitButtons do:[:butt | butt enable]
    ].
    base == 8 ifTrue:[
        nonOctalButtons do:[:butt | butt disable]
    ] ifFalse:[
        nonOctalButtons do:[:butt | butt enable]
    ].
    self updateDisplay

    "Modified: 23.4.1996 / 21:22:08 / cg"
!

clearKey
    "the clear button was pressed"

    thisOperand := 0.
    state := nil.
    self updateDisplay

    "Modified: 23.4.1996 / 21:22:17 / cg"
!

eqKey
    "the result button was pressed"

    |result sel op|

    state := nil.
    ((operator == #//) and: [thisOperand = 0]) ifTrue: [
        self opError
    ] ifFalse: [
        sel := operator.
        op := thisOperand.
        (operator == #'<<') ifTrue:[
            sel := #bitShift:.
        ] ifFalse:[
            (operator == #'>>') ifTrue:[
                sel := #bitShift:.
                op := op negated.
            ]
        ].

        result := prevOperand perform:sel with:op.
        prevOperand := thisOperand.
        thisOperand := result.
        self updateDisplay
    ]

    "Modified: 23.4.1996 / 21:22:22 / cg"
    "Modified: 5.7.1996 / 09:48:08 / stefan"
!

numKey:value
    "a numeric button was pressed"

    state := nil.
    (value < base) ifTrue: [
        thisOperand := (thisOperand * base) + value.
        self updateDisplay
    ]

    "Modified: 23.4.1996 / 21:22:29 / cg"
!

offKey
    "the power-off button was pressed"

    displayView := nil.
    self destroy

    "Modified: 23.4.1996 / 21:22:35 / cg"
!

opKey:selector
    "an operator button was pressed"

    state == #gotOperator ifTrue:[^ self].
    prevOperand := thisOperand.
    operator := selector.
    thisOperand := 0.
    state := #gotOperator.

    "Modified: 23.4.1996 / 21:22:41 / cg"
! !

!CalculatorView methodsFor:'events'!

keyPress:key x:x y:y
    "handle keyboard input"

    (key isCharacter and:[key isDigitRadix:base]) ifTrue:[
        ^ self numKey:key digitValue
    ].

    (#($+ $- $* $/) includes:key) ifTrue:[
        key == $/ ifTrue:[
            ^ self opKey:#//
        ].
        ^ self opKey:(key asSymbol)
    ].

    key == $= ifTrue:[
        ^ self eqKey
    ].

    key == #BackSpace ifTrue:[
        ^ self clearKey
    ].

    "Modified: 5.7.1996 / 09:51:58 / stefan"
! !

!CalculatorView methodsFor:'initialization'!

createButtonsFromProto:prototype separatedBy:space
    "given a prototype button (for its size),
     create all buttons and define their actionBlocks"

    |x y ext w h theFont g|

    ext := prototype extent.
    w := prototype widthIncludingBorder.
    h := prototype heightIncludingBorder.
    theFont := prototype font.

    x := space.
    y := space + h + space + h + space.
    (Button origin:(x @ y) extent:ext in:self)
      sizeFixed:true;
           font:theFont;
           label:'OFF';
          action:[self offKey].

    x := x + w + space + w + space + w + space.
    (Button origin:(x @ y) extent:ext in:self)
      sizeFixed:true;
            font:theFont;
           label:'CLR';
          action:[self clearKey].

    g := RadioButtonGroup new.

    x := space.
    y := y + h + space.

    #(10 16 8)
    with:#('DEC' 'HEX' 'OCT')
    do:[:base :lbl |
        |b|

        b := (RadioButton origin:(x @ y) extent:ext in:self) font:theFont;
                     sizeFixed:true;
                         label:lbl;
                        action:[self baseKey:base];
                      yourself.

        base == 10 ifTrue:[
            b toggleNoAction   "/ initially on
        ].

        g add:b.
        x := x + w + space.
    ].

    (Button origin:(x @ y) extent:ext in:self) font:theFont;
                     sizeFixed:true;
                         label:' = ';
                        action:[self eqKey].

    x := space.
    y := y + h + space.

    #(+ - * //) 
    with:#(' + ' ' - ' ' * ' ' / ')
    do:[:op :lbl |
        (Button origin:(x @ y) extent:ext in:self) font:theFont;
           sizeFixed:true;
               label:lbl; 
              action:[self opKey:op].
       x := x + w + space.
    ].

    x := space.
    y := y + h + space.

    #(<< >>) 
    with:#('<<' '>>')
    do:[:op :lbl |
        (Button origin:(x @ y) extent:ext in:self) font:theFont;
           sizeFixed:true;
               label:lbl; 
              action:[self opKey:op].
       x := x + w + space.
    ].

    hexDigitButtons := OrderedCollection new.
    nonOctalButtons := OrderedCollection new.

    x := space.
    y := y + h + space + h + space.

    #(12 13 14 15) do:[:num | 
        hexDigitButtons add:((Button origin:(x @ y) extent:ext in:self) font:theFont;
                              sizeFixed:true;
                                  label:' ' , (num printStringRadix:16) asUppercase , ' '; 
                                 action:[self numKey:num];
                               yourself).
        x := x + w + space.
    ].

    x := space.
    y := y + h + space.

    #(8 9) do:[:num |
        nonOctalButtons add:((Button origin:(x @ y) extent:ext in:self) font:theFont;
                              sizeFixed:true;
                                  label:' ' , num printString , ' '; 
                                 action:[self numKey:num];
                               yourself).
        x := x + w + space.
    ].

    #(10 11) do:[:num | 
        hexDigitButtons add:((Button origin:(x @ y) extent:ext in:self) font:theFont;
                              sizeFixed:true;
                                  label:' ' , (num printStringRadix:16) asUppercase , ' '; 
                                 action:[self numKey:num];
                               yourself).
        x := x + w + space.
    ].

    x := space.
    y := y + h + space.

    #(4 5 6 7) do:[:num |
        (Button origin:(x @ y) extent:ext in:self) font:theFont;
           sizeFixed:true;
               label:' ' , num printString , ' '; 
              action:[self numKey:num].
        x := x + w + space.
    ].

    x := space.
    y := y + h + space.

    #(0 1 2 3) do:[:num |
        (Button origin:(x @ y) extent:ext in:self) font:theFont;
           sizeFixed:true;
               label:' ' , num printString , ' '; 
              action:[self numKey:num].
        x := x + w + space.
    ].

    "Modified: 23.4.1996 / 21:23:17 / cg"
!

createDisplayWidth:w height:h font:font space:space
    "create a label to display the current value"

    |x y|

    x := space.
    y := space.
    displayView := Label origin:(x @ y) extent:(w @ h) in: self.
    displayView sizeFixed:true.
    displayView backgroundColor:(Color white).
    displayView level:-1.
    displayView label:'0'.
    displayView font:font.
    displayView adjust:#right

    "Modified: 23.4.1996 / 21:23:30 / cg"
!

initialize
    "initialize the view; setup fonts etc."

    |w h butt ext space buttonFont displayFont|

    super initialize.

    state := nil.
    space := 5.

    buttonFont := Font family:'helvetica' face:'bold' style:'roman' size:12.
    buttonFont isNil ifTrue: [
        buttonFont := self font
    ].
    displayFont := Font family:'helvetica' face:'bold' style:'roman' size:18.
    displayFont isNil ifTrue: [
        displayFont := self font
    ].

    "create a prototype (dummy) button to get minimum dimensions"
    butt := Button new.
    butt font:buttonFont.
    butt label:'WWW'.
    ext := butt extent.

    "make the button square"
    ext x:((ext x) max: (ext y)).
    ext y:(ext x).
    butt extent:ext.

    w := butt widthIncludingBorder.
    h := butt heightIncludingBorder.

    self createButtonsFromProto:butt separatedBy:space.
    self createDisplayWidth:((4 * w) + (3 * space))
                      height: ext y
                      font:displayFont space:space.

    self extent:(((4 * w) + (5 * space)) @ ((11 * h) + (12 * space))).
    self minExtent:(self extent).
    self maxExtent:(self extent).

    thisOperand := 0.
    prevOperand := 0.
    operator := #+.
    base := 10.

    "silently set to base10"
    self baseKey:10

    "CalculatorView open"

    "Modified: 23.4.1996 / 21:23:56 / cg"
!

opError
    "an error occurred"

    thisOperand := 0.
    displayView label:'Error'

    "Modified: 23.4.1996 / 21:24:04 / cg"
!

updateDisplay
    "update the value display"

    |label|

    base == 10 ifTrue:[
        label := thisOperand printString.
    ] ifFalse:[
        "/ only Integers do understand #printStringRadix:
        thisOperand isInteger ifTrue:[
            label := thisOperand printStringRadix:base
        ] ifFalse:[
            ^ self opError
        ]
    ].
        
    displayView label:label

    "Modified: 23.4.1996 / 21:24:12 / cg"
    "Modified: 5.7.1996 / 09:37:41 / stefan"
! !

!CalculatorView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/CalculatorView.st,v 1.17 2016-01-12 19:21:16 mawalch Exp $'
! !

