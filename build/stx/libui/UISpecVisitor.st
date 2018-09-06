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
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

Object subclass:#UISpecVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!UISpecVisitor class methodsFor:'documentation'!

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

!UISpecVisitor methodsFor:'visiting'!

visit:anObject 
    "visit anObject (visitor pattern).
     The object should call back one of my visitXXXX methods."

    ^ anObject acceptUISpecVisitor:self
!

visitActionButtonSpec:aSpec
    "dispatched back from the visited ActionButtonSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitArbitraryComponentSpec:aSpec
    "dispatched back from the visited ActionButtonSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec

    "Created: / 17-07-2017 / 10:16:26 / cg"
!

visitArrowButtonSpec:aSpec
    "dispatched back from the visited ActionButtonSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec

    "Created: / 17-07-2017 / 10:16:07 / cg"
!

visitCheckBoxSpec:aSpec 
    "dispatched back from the visited CheckBoxSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitCheckToggleSpec:aSpec 
    "dispatched back from the visited CheckToggleSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitColorMenuSpec:aSpec 
    "dispatched back from the visited ColorMenuSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitComboBoxSpec:aSpec 
    "dispatched back from the visited ComboBoxSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitComboListSpec:aSpec 
    "dispatched back from the visited ComboListSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitDataSetSpec:aSpec 
    "dispatched back from the visited DataSetSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitDividerSpec:aSpec 
    "dispatched back from the visited DividerSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitFileSelectionTreeSpec:aSpec 
    "dispatched back from the visited FileSelectionTreeSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitFramedBoxSpec:aSpec 
    "dispatched back from the visited CheckToggleSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec

    "Created: / 17-07-2017 / 10:16:38 / cg"
!

visitFullSpec:aSpec 
    "dispatched back from the visited FullSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitHTMLViewSpec:aSpec 
    "dispatched back from the visited HTMLViewSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitHierarchicalListViewSpec:aSpec 
    "dispatched back from the visited HierarchicalListViewSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitHorizontalPanelViewSpec:aSpec 
    "dispatched back from the visited HorizontalPanelViewSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitInputFieldSpec:aSpec 
    "dispatched back from the visited InputFieldSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitLabelSpec:aSpec 
    "dispatched back from the visited LabelSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitListModelViewSpec:aSpec 
    "dispatched back from the visited ListModelViewSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitMenuPanelSpec:aSpec 
    "dispatched back from the visited MenuPanel (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitMeterClackCounterSpec:aSpec 
    "dispatched back from the visited MenuPanel (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitNoteBookSpec:aSpec 
    "dispatched back from the visited NoteBookSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitNoteBookViewSpec:aSpec 
    "dispatched back from the visited NoteBookSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec

    "Created: / 17-07-2017 / 10:16:57 / cg"
!

visitPopUpListSpec:aSpec 
    "dispatched back from the visited NoteBookSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec

    "Created: / 17-07-2017 / 10:17:03 / cg"
!

visitProgressIndicatorSpec:aSpec 
    "dispatched back from the visited MenuPanel (visitor pattern)"

    ^ self visitUISpecification:aSpec

    "Created: / 17-07-2017 / 10:17:09 / cg"
!

visitRadioButtonSpec:aSpec 
    "dispatched back from the visited RadioButtonSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitSelectionInListModelViewSpec:aSpec 
    "dispatched back from the visited SelectionInListModelSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitSelectionInTreeViewSpec:aSpec 
    "dispatched back from the visited SelectionInTreeViewSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitSequenceViewSpec:aSpec 
    "dispatched back from the visited SequenceViewSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitSubCanvasSpec:aSpec 
    "dispatched back from the visited SubCanvas (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitTabViewSpec:aSpec 
    "dispatched back from the visited UpDownButtonSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec

    "Created: / 17-07-2017 / 10:17:17 / cg"
!

visitTextEditorSpec:aSpec 
    "dispatched back from the visited TextEditorSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitToggleSpec:aSpec 
    "dispatched back from the visited ToggleSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitTriggerBoxSpec:aSpec 
    "dispatched back from the visited TriggerBoxSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitUISpecification:aUISpecification
    self subclassResponsibility
!

visitUISubSpecification:aUISpecification
    "dispatched back from the visited UISubSpecification-object (visitor pattern)"

    ^ self visitUISpecification:aUISpecification
!

visitUpDownButtonSpec:aSpec 
    "dispatched back from the visited UpDownButtonSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitVerticalPanelViewSpec:aSpec 
    "dispatched back from the visited VerticalPanelViewSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitViewSpec:aSpec 
    "dispatched back from the visited ViewSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
!

visitWindowSpec:aSpec 
    "dispatched back from the visited WindowSpec (visitor pattern)"

    ^ self visitUISpecification:aSpec
! !

!UISpecVisitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/UISpecVisitor.st,v 1.9 2017-07-17 09:45:31 cg Exp $'
! !

