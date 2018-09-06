"
 COPYRIGHT (c) 1997 by eXept Software AG
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
"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GUIDemoCalculator
	instanceVariableNames:'firstOperand currentOperand lastOperand op'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-Misc'
!

!GUIDemoCalculator class methodsFor:'documentation'!

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
    Simple example, how a dumb calculator
    can be built using the UIPainter.

    [author:]
        Claus Gittinger

    [start with:]
        GUIDemoCalculator open
"
! !

!GUIDemoCalculator class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoCalculator andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoCalculator new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoCalculator open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'Calculator'
              #layout: #(#LayoutFrame 49 0 120 0 283 0 421 0)
              #label: 'Calculator'
              #min: #(#Point 235 302)
              #max: #(#Point 235 302)
              #bounds: #(#Rectangle 49 120 284 422)
              #backgroundColor: #(#Color 74.9996 74.9996 100.0)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#ArbitraryComponentSpec
                    #name: 'ledDisplay'
                    #layout: #(#LayoutFrame 5 0.0 5 0 -5 1.0 54 0)
                    #model: #ledValue
                    #component: #DigitalLedDisplay
                    #hasBorder: false
                )
                 #(#VerticalPanelViewSpec
                    #name: 'verticalPanelView1'
                    #layout: #(#LayoutFrame 4 0 73 0 232 0 298 0)
                    #component: 
                     #(#SpecCollection
                        #collection: 
                         #(
                           #(#HorizontalPanelViewSpec
                              #name: 'horizontalPanelView1'
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#ActionButtonSpec
                                        #name: 'actionButton1'
                                        #label: '1'
                                        #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                                        #model: #number:
                                        #actionValue: '1'
                                        #extent: #(#Point 52 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'actionButton2'
                                        #label: '2'
                                        #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                                        #model: #number:
                                        #actionValue: '2'
                                        #extent: #(#Point 52 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'actionButton3'
                                        #label: '3'
                                        #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                                        #model: #number:
                                        #actionValue: '3'
                                        #extent: #(#Point 52 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'divideButton'
                                        #label: '/'
                                        #backgroundColor: #(#Color 100.0 74.9996 74.9996)
                                        #model: #op:
                                        #actionValue: '/'
                                        #extent: #(#Point 52 51)
                                    )
                                  )
                              )
                              #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                              #horizontalLayout: #fitSpace
                              #verticalLayout: #fit
                              #horizontalSpace: 4
                              #verticalSpace: 3
                              #extent: #(#Point 228 51)
                          )
                           #(#HorizontalPanelViewSpec
                              #name: 'horizontalPanelView2'
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#ActionButtonSpec
                                        #name: 'actionButton5'
                                        #label: '4'
                                        #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                                        #model: #number:
                                        #actionValue: '4'
                                        #extent: #(#Point 52 52)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'actionButton6'
                                        #label: '5'
                                        #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                                        #model: #number:
                                        #actionValue: '5'
                                        #extent: #(#Point 52 52)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'actionButton7'
                                        #label: '6'
                                        #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                                        #model: #number:
                                        #actionValue: '6'
                                        #extent: #(#Point 52 52)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'multiplyButton'
                                        #label: '*'
                                        #backgroundColor: #(#Color 100.0 74.9996 74.9996)
                                        #model: #op:
                                        #actionValue: '*'
                                        #extent: #(#Point 52 52)
                                    )
                                  )
                              )
                              #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                              #horizontalLayout: #fitSpace
                              #verticalLayout: #fit
                              #horizontalSpace: 4
                              #verticalSpace: 3
                              #extent: #(#Point 228 52)
                          )
                           #(#HorizontalPanelViewSpec
                              #name: 'horizontalPanelView3'
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#ActionButtonSpec
                                        #name: 'actionButton9'
                                        #label: '7'
                                        #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                                        #model: #number:
                                        #actionValue: '7'
                                        #extent: #(#Point 52 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'actionButton10'
                                        #label: '8'
                                        #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                                        #model: #number:
                                        #actionValue: '8'
                                        #extent: #(#Point 52 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'actionButton11'
                                        #label: '9'
                                        #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                                        #model: #number:
                                        #actionValue: '9'
                                        #extent: #(#Point 52 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'subtractButton'
                                        #label: '-'
                                        #backgroundColor: #(#Color 100.0 74.9996 74.9996)
                                        #model: #op:
                                        #actionValue: '-'
                                        #extent: #(#Point 52 51)
                                    )
                                  )
                              )
                              #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                              #horizontalLayout: #fitSpace
                              #verticalLayout: #fit
                              #horizontalSpace: 4
                              #verticalSpace: 3
                              #extent: #(#Point 228 51)
                          )
                           #(#HorizontalPanelViewSpec
                              #name: 'horizontalPanelView4'
                              #component: 
                               #(#SpecCollection
                                  #collection: 
                                   #(
                                     #(#ActionButtonSpec
                                        #name: 'clearButton'
                                        #label: 'CLR'
                                        #foregroundColor: #(#Color 100.0 100.0 100.0)
                                        #backgroundColor: #(#Color 49.9992 0.0 0.0)
                                        #model: #clear
                                        #actionValue: ''
                                        #extent: #(#Point 52 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'actionButton14'
                                        #label: '0'
                                        #backgroundColor: #(#Color 49.9992 49.9992 100.0)
                                        #model: #number:
                                        #actionValue: '0'
                                        #extent: #(#Point 52 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'resultButton'
                                        #label: '='
                                        #model: #result
                                        #extent: #(#Point 52 51)
                                    )
                                     #(#ActionButtonSpec
                                        #name: 'addButton'
                                        #label: '+'
                                        #backgroundColor: #(#Color 100.0 74.9996 74.9996)
                                        #model: #op:
                                        #actionValue: '+'
                                        #extent: #(#Point 52 51)
                                    )
                                  )
                              )
                              #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                              #horizontalLayout: #fitSpace
                              #verticalLayout: #fit
                              #horizontalSpace: 4
                              #verticalSpace: 3
                              #extent: #(#Point 228 51)
                          )
                        )
                    )
                    #backgroundColor: #(#Color 74.9996 74.9996 100.0)
                    #horizontalLayout: #fit
                    #verticalLayout: #fitSpace
                    #horizontalSpace: 3
                    #verticalSpace: 4
                )
              )
          )
      )

    "Modified: / 18.11.1998 / 18:35:12 / cg"
! !

!GUIDemoCalculator methodsFor:'actions'!

clear
    "the clear-button was pressed"

    currentOperand := firstOperand := op := nil.
    self ledValue value:0.
!

number:anArgument
    "a digit-button was pressed"

    currentOperand isNil ifTrue:[
        currentOperand := 0.
    ].
    currentOperand := (currentOperand * 10) 
                      + (Integer fromString:anArgument).
    self ledValue value:currentOperand.
!

op:anArgument
    "an operator-button was pressed"

    |oldOp|

    (oldOp := op) notNil ifTrue:[
        self result
    ].

    op := anArgument.

    firstOperand := currentOperand.
    currentOperand := nil.
!

result
    "the result-button was pressed"

    |rslt|

    op isNil ifTrue:[ ^ self].

    firstOperand isNil ifTrue:[
        firstOperand := 0.
    ].
    currentOperand isNil ifTrue:[
        currentOperand := lastOperand.
    ].
    Number divisionByZeroSignal handle:[:ex |
        self ledValue value:'Error'
    ] do:[
        rslt := firstOperand perform:(op asSymbol) with:currentOperand.
        lastOperand := currentOperand.
        currentOperand := rslt.
        self ledValue value:rslt
    ].
    op := nil.
! !

!GUIDemoCalculator methodsFor:'aspects'!

ledValue
    |holder|

    (holder := builder bindingAt:#ledValue) isNil ifTrue:[
        builder aspectAt:#ledValue put:(holder :=  ValueHolder new).
    ].
    ^ holder

    "Created: / 25-10-1997 / 19:23:29 / cg"
! !

!GUIDemoCalculator methodsFor:'initialization'!

postBuildWith:aBuilder
    "callback after gui-setup; adjust the led-view's numberOfDigitsx"

    |led|

    led := (aBuilder componentAt:#ledDisplay) scrolledView.
    led numberOfDigits:16.
! !

!GUIDemoCalculator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoCalculator.st,v 1.7 2011-03-03 16:54:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoCalculator.st,v 1.7 2011-03-03 16:54:28 cg Exp $'
! !
