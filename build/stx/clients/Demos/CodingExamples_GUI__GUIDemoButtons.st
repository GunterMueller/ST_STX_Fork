"
 COPYRIGHT (c) 2015 by eXept Software AG
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

GUIDemoApplication subclass:#GUIDemoButtons
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoButtons class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015 by eXept Software AG
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
    Buttons can be configured to either behave traditionally, with a callback action,
    or with a model, which gets a value: message.

    [author:]
        Claus Gittinger

    [start with:]
        GUIDemoButtons open
        GUIDemo open
"
! !

!GUIDemoButtons class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoButtons andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoButtons new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoButtons open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Buttons'
         name: 'Buttons'
         min: (Point 10 10)
         max: (Point 1160 870)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (ActionButtonSpec
             label: 'Button 1 (callback)'
             name: 'ActionButton1'
             layout: (LayoutFrame 30 0.0 67 0 210 0 89 0)
             translateLabel: true
             model: button1Pressed
             isTriggerOnDown: true
           )
          (ButtonSpec
             label: 'Button 2 (model)'
             name: 'ModelButton2'
             layout: (LayoutFrame 30 0.0 115 0 210 0 137 0)
             translateLabel: true
             model: button2Model
             isTriggerOnDown: true
           )
          (UpDownButtonSpec
             name: 'UpDownButton1'
             layout: (LayoutFrame 121 0 178 0 166 0 200 0)
             translateLabel: true
             orientation: horizontal
           )
          (UpDownButtonSpec
             name: 'UpDownButton2'
             layout: (LayoutFrame 181 0 176 0 213 0 209 0)
             translateLabel: true
           )
          (LabelSpec
             label: 'Spin Buttons:'
             name: 'Label1'
             layout: (LayoutFrame 9 0 176 0 118 0 198 0)
             translateLabel: true
             adjust: left
           )
          )
        
       )
     )
! !

!GUIDemoButtons methodsFor:'callbacks'!

button1Pressed
    Transcript showCR:'button1 pressed'
!

button2ModelValueChanged
    Transcript show:'button2Model value now: '; showCR:self button2Model value
! !

!GUIDemoButtons methodsFor:'models'!

button2Model
    |model|

    (model := builder bindingAt:#button2Model) isNil ifTrue:[
        builder aspectAt:#button2Model put:(model := TriggerValue with:false).
        model onChangeSend:#button2ModelValueChanged to:self.
    ].
    ^ model
! !

!GUIDemoButtons class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoButtons.st,v 1.1 2015-10-04 10:20:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/CodingExamples_GUI__GUIDemoButtons.st,v 1.1 2015-10-04 10:20:48 cg Exp $'
! !

