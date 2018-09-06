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
"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoSliders
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoSliders class methodsFor:'documentation'!

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
    shows usage of sliders, progress indicator and thumb wheels. 
    All widgets in thie example are dealing with the same model
    (= valueHolder).
    Notice, the inputField, which is connected to the valueHolder
    via a typeConverter - transparently converting the valueHolder's
    numeric value to a string and vice versa.

    [author:]
        Claus Atzkern

    [start with:]
        GUIDemoSliders open
        GUIDemo open
"
! !

!GUIDemoSliders class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoSliders andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoSliders new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoSliders open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Sliders'
          #name: 'Sliders'
          #min: #(#Point 10 10)
          #max: #(#Point 1160 870)
          #bounds: #(#Rectangle 13 23 318 303)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SliderSpec
              #name: 'Slider Horizontal'
              #layout: #(#LayoutFrame 38 0 27 0 144 0 45 0)
              #model: #percentHolder
              #orientation: #horizontal
              #step: 1
            )
           #(#ProgressIndicatorSpec
              #name: 'ProgressIndicator'
              #layout: #(#LayoutFrame 38 0 66 0 144 0 84 0)
              #model: #percentHolder
            )
           #(#ThumbWheelSpec
              #name: 'ThumbWheel Horizontal'
              #layout: #(#LayoutFrame 38 0 105 0 144 0 120 0)
              #model: #percentHolder
              #orientation: #horizontal
              #step: 1
            )
           #(#SliderSpec
              #name: 'Slider Vertical'
              #layout: #(#LayoutFrame 168 0 27 0 186 0 120 0)
              #model: #percentHolder
              #step: 1
            )
           #(#ThumbWheelSpec
              #name: 'ThumbWheel Vertical'
              #layout: #(#LayoutFrame 203 0 27 0 218 0 120 0)
              #model: #percentHolder
              #step: 1
            )
           #(#LabelSpec
              #label: 'Percent:'
              #name: 'Percent'
              #layout: #(#AlignmentOrigin 99 0 170 0 1 1)
              #resizeForLabel: true
            )
           #(#InputFieldSpec
              #name: 'inputField1'
              #layout: #(#LayoutFrame 103 0 146 0 218 0 168 0)
              #model: #percentHolder
              #type: #number
              #acceptOnPointerLeave: false
            )
           #(#UpDownButtonSpec
              #name: 'UpDownButton2'
              #layout: #(#LayoutFrame 196 0 146 0 218 0 168 0)
              #model: #percentHolder
              #step: 1
              #min: 0
              #max: 100
            )
           )
         
        )
      )
! !

!GUIDemoSliders methodsFor:'aspects'!

percentHolder
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#percentHolder) isNil ifTrue:[
        builder aspectAt:#percentHolder put:(holder :=  ValueHolder new).
    ].
    ^ holder
! !

!GUIDemoSliders class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoSliders.st,v 1.8 2013-03-14 00:20:16 cg Exp $'
! !

