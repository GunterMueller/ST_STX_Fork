"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

SimpleDialog subclass:#UIListEditor
	instanceVariableNames:'informationLabel listTextHolder useSymbolsHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-UIPainter'
!

!UIListEditor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!UIListEditor class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:UIListEditor    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#useSymbols
'Store list elements as symbols'

)
! !

!UIListEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UIListEditor andSelector:#windowSpec
     UIListEditor new openInterface:#windowSpec
     UIListEditor open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Edit List'
          name: 'Edit List'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 354 422)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              name: 'Label1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 28 0)
              translateLabel: true
              labelChannel: informationLabel
            )
           (TextEditorSpec
              name: 'TextEditor1'
              layout: (LayoutFrame 0 0 30 0 0 1 -63 1)
              model: listTextHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              viewClassName: ''
            )
           (CheckBoxSpec
              label: 'Use Symbols'
              name: 'CheckBox1'
              layout: (LayoutFrame 5 0 368 0 141 0 390 0)
              activeHelpKey: useSymbols
              model: useSymbolsHolder
              translateLabel: true
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0 -33 1 0 1 0 1)
              horizontalLayout: fitSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button1'
                    translateLabel: true
                    model: doCancel
                    extent: (Point 172 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button2'
                    translateLabel: true
                    model: doAccept
                    isDefault: true
                    extent: (Point 173 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!UIListEditor methodsFor:'accessing'!

informationLabel
    ^ informationLabel
!

informationLabel:something
    informationLabel := something.
!

list
    "answer the list as an array"

    |list|

    list := self listTextHolder value asStringCollection asArray.
    self useSymbolsHolder value ifTrue:[
        list := list collect:[:e| e asSymbol].
    ].

    ^ list
!

list:anArray
    self listTextHolder value:anArray asStringCollection asString.
!

useSymbols:aBoolean
    self useSymbolsHolder value:aBoolean
! !

!UIListEditor methodsFor:'aspects'!

listTextHolder
    <resource: #uiAspect>

    listTextHolder isNil ifTrue:[
        listTextHolder := '' asValue.
    ].
    ^ listTextHolder.
!

useSymbolsHolder
    <resource: #uiAspect>

    useSymbolsHolder isNil ifTrue:[
        useSymbolsHolder := false asValue.
    ].
    ^ useSymbolsHolder.
! !

!UIListEditor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
