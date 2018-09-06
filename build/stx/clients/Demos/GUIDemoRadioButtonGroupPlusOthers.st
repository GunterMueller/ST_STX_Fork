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

ApplicationModel subclass:#GUIDemoRadioButtonGroupPlusOthers
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoRadioButtonGroupPlusOthers class methodsFor:'documentation'!

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
    However, a radioButtonGroup is nothing more than a valueHolder,
    holding the the active button - therefore, we can attach other
    components (which also operate on such a thing) to the same
    valueHolder. Thats what this demo does.

    [author:]
        Claus Gittinger

    [start with:]
        GUIDemoRadioButtonGroupPlusOthers open
        GUIDemo open
"



! !

!GUIDemoRadioButtonGroupPlusOthers class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoRadioButtonGroupPlusOthers andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoRadioButtonGroupPlusOthers new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoRadioButtonGroupPlusOthers open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'GUIDemo'
          name: 'GUIDemo'
          min: (Point 10 10)
          max: (Point 1024 768)
          bounds: (Rectangle 16 52 538 526)
          forceRecursiveBackground: true
        )
        component: 
       (SpecCollection
          collection: (
           (RadioButtonSpec
              label: 'eins'
              name: 'radioButton1'
              layout: (LayoutFrame 168 0.0 40 0 291 0 62 0)
              model: group1
              isTriggerOnDown: true
              select: 1
            )
           (RadioButtonSpec
              label: 'zwei'
              name: 'radioButton2'
              layout: (LayoutFrame 168 0.0 70 0 291 0 92 0)
              model: group1
              isTriggerOnDown: true
              select: 2
            )
           (RadioButtonSpec
              label: 'drei'
              name: 'radioButton3'
              layout: (LayoutFrame 168 0.0 100 0 291 0 122 0)
              model: group1
              isTriggerOnDown: true
              select: 3
            )
           (InputFieldSpec
              name: 'inputField1'
              layout: (LayoutFrame 5 0 43 0 72 0 65 0)
              model: group1
              type: number
              immediateAccept: false
              acceptOnLeave: true
              acceptOnPointerLeave: false
            )
           (SequenceViewSpec
              name: 'sequenceView1'
              layout: (LayoutFrame 5 0 186 0 210 0 280 0)
              model: group1
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              useIndex: true
              sequenceList: 
             ('one'
                'two' 'three'
              )
            )
           (PopUpListSpec
              label: 'invalid'
              name: 'popUpList1'
              layout: (LayoutFrame 5 0 72 0 73 0 93 0)
              tabable: true
              model: group1
              menu: 
             ('un'
                'deux' 'trois'
              )
              useIndex: true
            )
           (TabViewSpec
              name: 'tabView1'
              layout: (LayoutFrame 5 0 135 0 145 0 171 0)
              model: group1
              menu: 
             ('uno'
                'due' 'tre'
              )
              useIndex: true
            )
           (InputFieldSpec
              name: 'valueDisplay'
              layout: (LayoutFrame 5 0 406 0 200 0 428 0)
              model: group1
              isReadOnly: true
              type: smalltalkObject
              immediateAccept: false
              acceptOnReturn: false
              acceptOnTab: false
              acceptOnPointerLeave: false
            )
           (LabelSpec
              label: 'Multiple widgets - same value holder'
              name: 'label1'
              layout: (LayoutFrame 0 0.0 9 0 0 1.0 31 0)
              style: (FontDescription helvetica bold roman 12)
            )
           (LabelSpec
              label: 'The holders current value:'
              name: 'label2'
              layout: (LayoutFrame 5 0 379 0 201 0 401 0)
              adjust: left
            )
           (MenuPanelSpec
              name: 'ToolBar1'
              layout: (LayoutFrame 5 0.0 323 0 210 0 355 0)
              menu: radioMenu
              textDefault: true
            )
           (LabelSpec
              label: 'a MenuPanel'
              name: 'Label1'
              layout: (LayoutFrame 231 0 329 0 436 0 351 0)
              translateLabel: true
              adjust: left
            )
           )
         
        )
      )
! !

!GUIDemoRadioButtonGroupPlusOthers class methodsFor:'menu specs'!

radioMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoRadioButtonGroupPlusOthers andSelector:#radioMenu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoRadioButtonGroupPlusOthers radioMenu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'eins'
                #translateLabel: true
                #choice: #group1
                #choiceValue: 1
            )
             #(#MenuItem
                #label: 'zwei'
                #translateLabel: true
                #choice: #group1
                #choiceValue: 2
            )
             #(#MenuItem
                #label: 'drei'
                #translateLabel: true
                #choice: #group1
                #choiceValue: 3
            )
          ) nil
          nil
      )
! !

!GUIDemoRadioButtonGroupPlusOthers methodsFor:'aspects'!

group1
    "automatically generated by UIPainter ..."

    |holder|

    (holder := builder bindingAt:#group1) isNil ifTrue:[
        builder aspectAt:#group1 put:(holder :=  RadioButtonGroup new).
        holder addDependent:self.
    ].
    ^ holder



! !

!GUIDemoRadioButtonGroupPlusOthers class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoRadioButtonGroupPlusOthers.st,v 1.7 2003-09-26 07:56:21 cg Exp $'
! !
