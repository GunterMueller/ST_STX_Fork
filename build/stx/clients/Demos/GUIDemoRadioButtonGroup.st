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

GUIDemoApplication subclass:#GUIDemoRadioButtonGroup
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoRadioButtonGroup class methodsFor:'documentation'!

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
    RadioButtonGroups control the interaction between RadioButtons
    turning off other button(s) when one of the group is pressed.
    To group some buttons (and have one-on behavior) use:

    [author:]
        Claus Atzkern

    [start with:]
        GUIDemoRadioButtonGroup open
        GUIDemo open
"


! !

!GUIDemoRadioButtonGroup class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoRadioButtonGroup andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoRadioButtonGroup new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoRadioButtonGroup open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'SelectionInTree'
          name: 'SelectionInTree'
          min: (Point 10 10)
          max: (Point 1160 870)
          bounds: (Rectangle 16 52 316 352)
        )
        component: 
       (SpecCollection
          collection: (
           (RadioButtonSpec
              label: 'Button 1'
              name: 'button 1'
              layout: (LayoutFrame 86 0.0 67 0 209 0 89 0)
              model: radioGroup
              isTriggerOnDown: true
              lampColor: (Color 100.0 0.0 0.0)
              select: button1
            )
           (RadioButtonSpec
              label: 'Button 2'
              name: 'button 2'
              layout: (LayoutFrame 86 0.0 115 0 209 0 137 0)
              model: radioGroup
              isTriggerOnDown: true
              lampColor: (Color 0.0 86.9993 0.0)
              select: button2
            )
           (RadioButtonSpec
              label: 'Button 3'
              name: 'button 3'
              layout: (LayoutFrame 86 0.0 163 0 209 0 185 0)
              model: radioGroup
              isTriggerOnDown: true
              lampColor: (Color 0.0 0.0 100.0)
              select: button3
            )
           (RadioButtonSpec
              label: 'Button 4'
              name: 'button 4'
              layout: (LayoutFrame 86 0.0 211 0 209 0 233 0)
              model: radioGroup
              isTriggerOnDown: true
              select: button4
            )
           )
         
        )
      )
! !

!GUIDemoRadioButtonGroup methodsFor:'aspects'!

radioGroup
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#radioGroup) isNil ifTrue:[
        builder aspectAt:#radioGroup put:(holder :=  RadioButtonGroup new).
        holder addDependent:self.
    ].
    ^ holder
! !

!GUIDemoRadioButtonGroup methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "radiogroup might change
    "
    |model|

    model := self radioGroup.

    changedObject == model ifFalse:[
        ^ super update:something with:aParameter from:changedObject
    ].
    self showCR:'radio group changed to: ', model value.

! !

!GUIDemoRadioButtonGroup class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoRadioButtonGroup.st,v 1.7 2003-09-26 07:56:26 cg Exp $'
! !
