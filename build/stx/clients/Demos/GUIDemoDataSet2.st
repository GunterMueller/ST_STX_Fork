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

GUIDemoApplication subclass:#GUIDemoDataSet2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

Object subclass:#Row
	instanceVariableNames:'endOfTitle endOfSubTitle title subTitle text editText toggle
		choices bgColor fgColor'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CodingExamples_GUI::GUIDemoDataSet2
!

!GUIDemoDataSet2 class methodsFor:'documentation'!

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


! !

!GUIDemoDataSet2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoDataSet2 andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoDataSet2 new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoDataSet2 open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'DataSetView Example 2'
              #layout: #(#LayoutFrame 82 0 206 0 691 0 655 0)
              #label: 'DataSetView Example 2'
              #min: #(#Point 10 10)
              #max: #(#Point 1280 1024)
              #bounds: #(#Rectangle 82 206 692 656)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#DataSetSpec
                    #name: 'Table1'
                    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                    #hasHorizontalScrollBar: false
                    #hasVerticalScrollBar: true
                    #dataList: #dataList
                    #has3Dsepartors: true
                    #has3Dseparators: true
                    #columnHolder: #tableColumns
                    #selectRowOnDefault: false
                    #multipleSelectOk: true
                )
              )
          )
      )
! !

!GUIDemoDataSet2 class methodsFor:'tableColumns specs'!

tableColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:CodingExamples_GUI::GUIDemoDataSet2 andSelector:#tableColumns
    "

    <resource: #tableColumns>


    ^ #(
        #(#DataSetColumnSpec
           #rendererType: #rowSelector
           #showSelectionHighLighted: false
       )
        #(#DataSetColumnSpec
           #label: #labelTitle
           #translateLabel: true
           #labelBackgroundColor: #(#Color 0.0 0.0 100.0)
           #labelForegroundColor: #(#Color 0.0 100.0 0.0)
           #labelFont: #(#FontDescription #clean #bold #oblique 12)
           #labelAlignment: #left
           #labelActionSelector: #pressedLabel1
           #backgroundColor: #(#Color 0.0 100.0 0.0)
           #foregroundColor: #(#Color 0.0 0.0 100.0)
           #model: #title
           #canSelect: false
           #rowSeparatorSelector: #endOfTitle
           #showSelectionHighLighted: false
       )
        #(#DataSetColumnSpec
           #label: #labelSubTitle
           #translateLabel: true
           #labelBackgroundColor: #(#Color 100.0 0.0 0.0)
           #labelForegroundColor: #(#Color 100.0 100.0 0.0)
           #labelFont: #(#FontDescription #clean #bold #oblique 18)
           #labelAlignment: #left
           #backgroundColor: #(#Color 100.0 100.0 0.0)
           #foregroundColor: #(#Color 100.0 0.0 0.0)
           #model: #subTitle
           #canSelect: false
           #rowSeparatorSelector: #endOfSubTitle
           #showSelectionHighLighted: false
       )
        #(#DataSetColumnSpec
           #label: 
            #('Text'
               'No Editor'
           )
           #labelFont: #(#FontDescription #lucida #bold #roman 18)
           #columnAlignment: #center
           #model: #text
           #backgroundSelector: #bgColor
           #foregroundSelector: #fgColor
           #showColSeparator: false
       )
        #(#DataSetColumnSpec
           #label: 
            #('Text'
               'With Editor'
           )
           #labelFont: #(#FontDescription #courier #bold #roman 14)
           #labelAlignment: #left
           #editorType: #ComboBox
           #rendererType: #ComboBox
           #choices: #choices
           #model: #editText
           #backgroundSelector: #bgColor
           #foregroundSelector: #fgColor
       )
        #(#DataSetColumnSpec
           #label: 'Toggle'
           #labelFont: #(#FontDescription #helvetica #bold #roman 14)
           #editorType: #CheckToggle
           #rendererType: #CheckToggle
           #backgroundColor: #(#Color 0.0 0.0 100.0)
           #foregroundColor: #(#Color 100.0 49.9992 49.9992)
           #model: #toggle
           #showSelectionHighLighted: false
       )
     )
! !

!GUIDemoDataSet2 methodsFor:'accessing labels'!

labelSubTitle
    ^ Array with:'Title'
            with:(LabelAndIcon icon:(Icon downRightIcon) string:'SubTitle')
!

labelTitle
    ^ Array with:'Title'
            with:(Icon downRightIcon)
! !

!GUIDemoDataSet2 methodsFor:'actions'!

pressedLabel1
    self showCR:'Press Action on Label at Column 1'
! !

!GUIDemoDataSet2 methodsFor:'aspects'!

dataList
    |list|

    (list := builder bindingAt:#dataList) isNil ifTrue:[
        list :=  List new.
        1 to:1000 do:[:i| list add:(Row new index:i) ].
        builder aspectAt:#dataList put:list.
    ].
    ^ list.
! !

!GUIDemoDataSet2::Row methodsFor:'accessing'!

editText
    ^ editText

!

editText:aValue
    editText := aValue
!

subTitle
    ^ subTitle
!

text
    ^ text

!

title
    ^ title
!

toggle
    ^ toggle

!

toggle:aValue
    toggle := aValue
! !

!GUIDemoDataSet2::Row methodsFor:'accessing look'!

bgColor
    ^ bgColor
!

endOfSubTitle
    ^ endOfSubTitle
!

endOfTitle
    ^ endOfTitle
!

fgColor
    ^ fgColor
! !

!GUIDemoDataSet2::Row methodsFor:'accessing menu'!

choices
    ^ choices
! !

!GUIDemoDataSet2::Row methodsFor:'instance creation'!

index:anIndex
    |i|

    endOfTitle    := anIndex \\ 8 == 0.
    endOfSubTitle := anIndex \\ 4 == 0.

    anIndex odd ifTrue:[
        fgColor := Color blue.
        bgColor := Color yellow.
        toggle  := false.
    ] ifFalse:[
        toggle := true
    ].

    (anIndex + 7) \\ 8 == 0 ifTrue:[
        title := Array with:'Title'
                       with:(LabelAndIcon icon:(Icon downRightIcon) string:'Sub-Title')
    ].
    (anIndex + 3) \\ 4 == 0 ifTrue:[
        subTitle := Array with:'Sub-Title'
                with:(LabelAndIcon icon:(Icon downRightIcon) string:'Columns')
    ].
    i := anIndex \\ 6.

              i == 0 ifTrue:[
        text := Array with:'LabelAndIcon'
                      with:(LabelAndIcon icon:(Icon copyIcon) string:'LabelAndIcon').
    ]ifFalse:[i == 1 ifTrue:[
        text := Array with:'Icon'
                      with:(Icon deleteIcon)
    ]ifFalse:[i == 2 ifTrue:[
        text := #( 'Array:' 'Text' )
    ]ifFalse:[i == 3 ifTrue:[
        text := 'Text'
    ]ifFalse:[i == 4 ifTrue:[
        text := 'Text'
    ]ifFalse:[
        text := Array with:(Icon saveIcon)
                      with:(Icon loadIcon)
    ]]]]].

    editText := 'EditText'.

    (anIndex // 4) odd ifTrue:[
        choices := #( 'foo' 'bar' 'baz' )
    ] ifFalse:[
        editText := Array with:'Array:' with:'Text'
    ].

! !

!GUIDemoDataSet2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoDataSet2.st,v 1.3 2001-12-08 13:42:26 cg Exp $'
! !
