"
 COPYRIGHT (c) 2005 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

SimpleDialog subclass:#CheckinInfoDialog
	instanceVariableNames:'descriptionHolder logMessageHolder isStableHolder tagHolder
		quickCheckInHolder quickCheckInVisibleHolder allowEmptyLogMessage
		warningMessageHolder logHistory logHistoryHeadLineSelectionHolder
		validateConsistencyHolder validateConsistencyVisibleHolder
		checkinReasonHolder validateConsistencyEnabledHolder
		quickCheckInEnabledHolder'
	classVariableNames:'RecentlyUsedTags LastReason'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!CheckinInfoDialog class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    checkin-dialog.
    used to be private in SourceCodeManagerUtilites.
    moved to libtool because libbasic3 should not contain code inheriting from GUI classes.

    [author:]

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!CheckinInfoDialog class methodsFor:'constants'!

possibleReasons
    ^ #(reasonBugfix reasonDocumentation reasonFeature reasonRefactoring
        reasonOther reasonUIEnhancement reasonTuning reasonQuality)

    "Created: / 31-03-2016 / 17:53:16 / cg"
!

reasonBugfix
    ^ #reasonBugfix
!

reasonDocumentation
    ^ #reasonDocumentation
!

reasonFeature
    ^ #reasonFeature
!

reasonOther
    ^ #reasonOther
!

reasonQuality
    ^ #reasonQuality

    "Created: / 31-03-2016 / 17:53:57 / cg"
!

reasonRefactoring
    ^ #reasonRefactoring
!

reasonTuning
    ^ #reasonTuning

    "Created: / 31-03-2016 / 17:53:26 / cg"
!

reasonUIEnhancement
    ^ #reasonUIEnhancement
! !

!CheckinInfoDialog class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:Tools::CheckinInfoDialog    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#logMessage
'This message is added as a check-in log message. 
It can later be retrieved via the browser''s revision info menu function'

#markAsStable
'Mark this as a stable version (i.e. give it a "stable" tag)'

#quickCheckin
'Only checkin classes which have been created or changed during this session'

#tag
'Mark this version with a symbolic tag (combo list gives list of recently used tags)'

#validateConsistency
'Perform some consistency checks before checking in. 
Especially checks the correctness of the ProjectDefinition vs. the actual set of classes in the image'

#checkinReason
'Adds a keyword to the checkin info, to allow automatic generation of revision information from the log later'

#checkinReasonDocumentation
'Only documentation, comments etc. were added/changed.\Tells others, that there is no need to test/verify/review the changes'

#checkinReasonBugfix
'Some bug was fixed.\Please describe what was changed and\if possible, add a bug identifier (issue-ID) to the checkin info'

#checkinReasonFeature
'A new feature was added.\Please describe what was changed and\if possible, add a requirement identifier (issue-ID) to the checkin info'

#checkinReasonRefactoring
'The code was refactored/improved for better structure or maintainability'

#checkinReasonUIEnhancement
'Some enhancement in a UI which makes it look better or easier to use\(but does not add new functionality).\Please describe in detail what you did in the checkin info'

#checkinReasonQuality
'The change enhanced the quality of the product (debuggability, testability, robustness, etc.)\Use this for test-cases.'

#checkinReasonTuning
'The change enhances the performance.\Be especially careful to always add test cases,\because statistically, many errors are introduced by "optimizations".'

#checkinReasonOther
'Some other change, which does not fit into one of the above.\Please describe in detail what you did in the checkin info'

)

    "Modified: / 31-03-2016 / 18:01:42 / cg"
! !

!CheckinInfoDialog class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::CheckinInfoDialog andSelector:#windowSpec
     Tools::CheckinInfoDialog new openInterface:#windowSpec
     Tools::CheckinInfoDialog open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Enter Log Message'
         name: 'Enter Log Message'
         min: (Point 538 387)
         bounds: (Rectangle 0 0 592 558)
       )
       component: 
      (SpecCollection
         collection: (
          (HorizontalPanelViewSpec
             name: 'HorizontalPanel2'
             layout: (LayoutFrame 0 0.0 0 0 0 1.0 32 0)
             horizontalLayout: left
             verticalLayout: center
             horizontalSpace: 0
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (LabelSpec
                   label: 'Enter checkIn log-message for:'
                   name: 'Label1'
                   translateLabel: true
                   resizeForLabel: true
                   useDefaultExtent: true
                 )
                (LabelSpec
                   name: 'Label2'
                   translateLabel: true
                   labelChannel: descriptionHolder
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          (LabelSpec
             label: 'Previous Log Messages:'
             name: 'Label5'
             layout: (LayoutFrame 0 0 37 0 220 0 67 0)
             translateLabel: true
             adjust: right
           )
          (ComboListSpec
             name: 'ComboList1'
             layout: (LayoutFrame 220 0.0 37 0 0 1.0 67 0)
             model: logHistoryHeadLineSelectionHolder
             comboList: logHistoryHeadLines
             useIndex: true
           )
          (TextEditorSpec
             name: 'TextEditor1'
             layout: (LayoutFrame 2 0.0 70 0 -2 1 -300 1)
             activeHelpKey: logMessage
             model: logMessageHolder
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             hasKeyboardFocusInitially: false
           )
          (LabelSpec
             name: 'Label4'
             layout: (LayoutFrame 0 0.0 -293 1 0 1.0 -271 1)
             translateLabel: true
             labelChannel: warningMessageHolder
           )
          (CheckBoxSpec
             label: 'Quick Checkin (Only Classes in ChangeSet)'
             name: 'CheckInChangedOnlyCheckbox'
             layout: (LayoutFrame 3 0 -268 1 -3 1 -246 1)
             activeHelpKey: quickCheckin
             visibilityChannel: quickCheckInVisibleHolder
             enableChannel: quickCheckInEnabledHolder
             model: quickCheckInHolder
             translateLabel: true
           )
          (CheckBoxSpec
             label: 'Validate Package Consistency'
             name: 'CheckBox1'
             layout: (LayoutFrame 3 0 -241 1 -3 1 -219 1)
             activeHelpKey: validateConsistency
             visibilityChannel: validateConsistencyVisibleHolder
             enableChannel: validateConsistencyEnabledHolder
             model: validateConsistencyHolder
             translateLabel: true
           )
          (CheckBoxSpec
             label: 'Mark as Stable'
             name: 'MarkStableCheckBox'
             layout: (LayoutFrame 3 0 -214 1 -3 1 -192 1)
             activeHelpKey: markAsStable
             model: isStableHolder
             translateLabel: true
           )
          (LabelSpec
             label: 'Tag:'
             name: 'Label3'
             layout: (LayoutFrame -40 0.5 -213 1 0 0.5 -191 1)
             activeHelpKey: tag
             translateLabel: true
             adjust: right
           )
          (ComboBoxSpec
             name: 'ComboBox1'
             layout: (LayoutFrame 0 0.5 -214 1 -3 1 -192 1)
             activeHelpKey: tag
             enableChannel: notMarkAsStableHolder
             model: tagHolder
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnLostFocus: true
             acceptOnPointerLeave: false
             comboList: recentTagsList
           )
          (LabelSpec
             label: 'Reason for Checkin:'
             name: 'Label6'
             layout: (LayoutOrigin 2 0 -179 1)
             activeHelpKey: checkinReason
             translateLabel: true
             resizeForLabel: true
             adjust: right
           )
          (RadioButtonSpec
             label: 'Bugfix'
             name: 'RadioButton1'
             layout: (LayoutFrame 20 0.0 -151 1 300 0 -129 1)
             activeHelpKey: checkinReasonBugfix
             translateLabel: true
             model: checkinReasonHolder
             isTriggerOnDown: true
             select: reasonBugfix
           )
          (RadioButtonSpec
             label: 'Feature / Enhancement'
             name: 'RadioButton2'
             layout: (LayoutFrame 20 0 -127 1 -279 1 -105 1)
             activeHelpKey: checkinReasonFeature
             translateLabel: true
             model: checkinReasonHolder
             isTriggerOnDown: true
             select: reasonFeature
           )
          (RadioButtonSpec
             label: 'Refactoring / Code Cleanup'
             name: 'RadioButton3'
             layout: (LayoutFrame 9 0.5 -151 1 0 1 -129 1)
             activeHelpKey: checkinReasonRefactoring
             translateLabel: true
             model: checkinReasonHolder
             isTriggerOnDown: true
             select: reasonRefactoring
           )
          (RadioButtonSpec
             label: 'UI Enhancement / Beautification'
             name: 'RadioButton6'
             layout: (LayoutFrame 20 0 -103 1 -279 1 -81 1)
             activeHelpKey: checkinReasonUIEnhancement
             translateLabel: true
             model: checkinReasonHolder
             isTriggerOnDown: true
             select: reasonUIEnhancement
           )
          (RadioButtonSpec
             label: 'Documentation / Comment Only'
             name: 'RadioButton5'
             layout: (LayoutFrame 9 0.5 -103 1 0 1 -81 1)
             activeHelpKey: checkinReasonDocumentation
             translateLabel: true
             model: checkinReasonHolder
             isTriggerOnDown: true
             select: reasonDocumentation
           )
          (RadioButtonSpec
             label: 'Tuning'
             name: 'RadioButton4a'
             layout: (LayoutFrame 20 0 -79 1 -279 1 -57 1)
             activeHelpKey: checkinReasonTuning
             translateLabel: true
             model: checkinReasonHolder
             isTriggerOnDown: true
             select: reasonTuning
           )
          (RadioButtonSpec
             label: 'Quality (Debuggability / Testability)'
             name: 'RadioButton4'
             layout: (LayoutFrame 9 0.5 -127 1 0 1 -105 1)
             activeHelpKey: checkinReasonQuality
             translateLabel: true
             model: checkinReasonHolder
             isTriggerOnDown: true
             select: reasonQuality
           )
          (RadioButtonSpec
             label: 'None of the Above'
             name: 'RadioButton7'
             layout: (LayoutFrame 9 0.5 -79 1 0 1 -57 1)
             activeHelpKey: checkinReasonOther
             translateLabel: true
             model: checkinReasonHolder
             isTriggerOnDown: true
             select: reasonOther
           )
          (HorizontalPanelViewSpec
             name: 'ButtonPanel1'
             layout: (LayoutFrame 0 0.0 -40 1 -16 1.0 0 1.0)
             horizontalLayout: fitSpace
             verticalLayout: center
             horizontalSpace: 3
             verticalSpace: 2
             reverseOrderIfOKAtLeft: true
             component: 
            (SpecCollection
               collection: (
                (ActionButtonSpec
                   label: 'Cancel'
                   name: 'Button2'
                   translateLabel: true
                   model: doCancel
                   extent: (Point 282 35)
                   usePreferredHeight: true
                 )
                (ActionButtonSpec
                   label: 'OK'
                   name: 'Button1'
                   translateLabel: true
                   model: doAccept
                   extent: (Point 282 35)
                   usePreferredHeight: true
                 )
                )
              
             )
             keepSpaceForOSXResizeHandleH: true
           )
          )
        
       )
     )
! !

!CheckinInfoDialog class methodsFor:'opening'!

getCheckinInfoFor:aString initialAnswer:initialAnswer
    ^ self 
        getCheckinInfoFor:aString 
        initialAnswer:initialAnswer 
        withQuickOption:false

    "
      self getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Modified (format): / 12-03-2012 / 12:38:48 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswer withQuickOption:withQuickOption
    ^ self
        getCheckinInfoFor:aClassNameOrPackageNameString 
        initialAnswer:initialAnswer 
        withQuickOption:withQuickOption
        logHistory:#()

    "
     self getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Modified: / 12-03-2012 / 12:39:00 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswer withQuickOption:withQuickOption logHistory:logHistoryArg
    ^  self     
        getCheckinInfoFor:aClassNameOrPackageNameString 
        initialAnswer:initialAnswer 
        withQuickOption:withQuickOption 
        logHistory:logHistoryArg 
        withValidateConsistencyOption:false

    "
     self getCheckinInfoFor:'hello' initialAnswer:'bla'
     self getCheckinInfoFor:'hello' initialAnswer:'bla' withQuickOption:true
     self getCheckinInfoFor:'hello' initialAnswer:'bla' withQuickOption:true logHistory:nil withConsistencyCheckOption:true
    "

    "Created: / 12-03-2012 / 12:36:26 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswer 
                withQuickOption:withQuickOption 
                logHistory:logHistoryArg 
                withValidateConsistencyOption:withValidateConsistencyOption
    ^ self
        getCheckinInfoFor:aClassNameOrPackageNameString 
        initialAnswer:initialAnswer 
        withQuickOption:withQuickOption 
        logHistory:logHistoryArg 
        withValidateConsistencyOption:withValidateConsistencyOption
        initialReason:(LastReason ? self reasonBugfix)

    "
     self getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Created: / 12-03-2012 / 12:36:26 / cg"
!

getCheckinInfoFor:aClassNameOrPackageNameString initialAnswer:initialAnswer 
            withQuickOption:withQuickOption 
            logHistory:logHistoryArg 
            withValidateConsistencyOption:withValidateConsistencyOption
            initialReason:defaultReason

    |dialog warnMessage|

    warnMessage := nil.
    [
        dialog := self new.
        dialog 
            description:aClassNameOrPackageNameString; 
            logMessage:initialAnswer;
            withQuickOption:withQuickOption;
            withValidateConsistencyOption:withValidateConsistencyOption;
            logHistory:logHistoryArg;
            checkinReason:defaultReason.

        dialog warningMessageHolder value:warnMessage.
        dialog open.
        dialog accepted ifFalse:[ ^ nil ].
    ] doUntil:[
        |stopAsking|

        stopAsking := dialog allowEmptyLogMessage 
                      or:[ (dialog logMessage) withoutSeparators notEmptyOrNil ].
        stopAsking ifFalse:[
            warnMessage := (self resources string:'Please enter a description of your changes!!') 
                                withColor:Color red.
        ].
        stopAsking
    ].
    LastReason := dialog checkinReason.
    ^ dialog    


    "
     self getCheckinInfoFor:'hello' initialAnswer:'bla'
    "

    "Created: / 12-03-2012 / 12:36:26 / cg"
! !

!CheckinInfoDialog methodsFor:'accessing'!

allowEmptyLogMessage
    ^ allowEmptyLogMessage ? false

    "Created: / 06-07-2010 / 11:23:18 / cg"
!

allowEmptyLogMessage:aBoolean 
    allowEmptyLogMessage := aBoolean

    "Created: / 06-07-2010 / 11:23:31 / cg"
!

checkinReason
    "returns one of: #(reasonBugfix reasonFeature reasonRefactoring reasonDocumentation reasonOther)"

    ^ self checkinReasonHolder value
!

checkinReason:aSymbolicReason
    self assert:( self class possibleReasons includes:aSymbolicReason).
    self checkinReasonHolder value:aSymbolicReason

    "Modified: / 31-03-2016 / 17:58:45 / cg"
!

description
    ^ self descriptionHolder value
!

description:aString
    self descriptionHolder value:aString allBold
!

isStable
    ^ self isStableHolder value
!

isStable:aBoolean
    self isStableHolder value:aBoolean
!

logHistory:something
    logHistory := something.
!

logMessage
    ^ self logMessageHolder value ? ''
!

logMessage:aString
    self logMessageHolder value:aString
!

quickCheckIn
    ^ self quickCheckInHolder value
!

quickCheckIn:aBoolean
    self quickCheckInHolder value:aBoolean
!

tag
    ^ (self tagHolder value ? '') withoutSeparators
!

tag:aStringOrNil
    self tagHolder value:aStringOrNil

    "Modified: / 12-09-2006 / 12:03:50 / cg"
!

tagIt
    ^ self tag notEmptyOrNil

    "Created: / 12-09-2006 / 13:06:49 / cg"
!

validateConsistency
    ^ self validateConsistencyHolder value
!

withQuickOption:aBoolean
    self quickCheckInEnabledHolder value:aBoolean
    "/ self quickCheckInVisibleHolder value:aBoolean
!

withValidateConsistencyOption:aBoolean
    self validateConsistencyEnabledHolder value:aBoolean
    "/ self validateConsistencyVisibleHolder value:aBoolean
! !

!CheckinInfoDialog methodsFor:'aspects'!

checkinReasonHolder
    checkinReasonHolder isNil ifTrue:[
        checkinReasonHolder := (LastReason ? self class reasonBugfix) asValue.
    ].
    ^ checkinReasonHolder
!

descriptionHolder
    descriptionHolder isNil ifTrue:[
        descriptionHolder := ValueHolder new.
    ].
    ^ descriptionHolder
!

isStableHolder
    isStableHolder isNil ifTrue:[
        isStableHolder := false asValue.
    ].
    ^ isStableHolder.

    "Modified: / 16-01-2007 / 16:00:26 / cg"
!

logHistoryHeadLineSelectionHolder
    logHistoryHeadLineSelectionHolder isNil ifTrue:[
        logHistoryHeadLineSelectionHolder := nil asValue.
        logHistoryHeadLineSelectionHolder 
            onChangeEvaluate:
                [
                    self logMessageHolder value:(logHistory at:logHistoryHeadLineSelectionHolder value)
                ].
    ].
    ^ logHistoryHeadLineSelectionHolder

    "Created: / 12-03-2012 / 12:40:36 / cg"
!

logHistoryHeadLines
    ^ (logHistory ? #())
        collect:[:msg |
            msg withoutLeadingSeparators asCollectionOfLines first , '...'
        ]

    "Created: / 12-03-2012 / 12:39:35 / cg"
!

logMessageHolder
    logMessageHolder isNil ifTrue:[
        logMessageHolder := '' asValue.
    ].
    ^ logMessageHolder.

    "Modified: / 12-03-2012 / 12:34:13 / cg"
!

notMarkAsStableHolder
    ^ BlockValue forLogicalNot:self isStableHolder
!

quickCheckInEnabledHolder
    quickCheckInEnabledHolder isNil ifTrue:[
        quickCheckInEnabledHolder := false asValue.
    ].
    ^ quickCheckInEnabledHolder
!

quickCheckInHolder
    quickCheckInHolder isNil ifTrue:[
        quickCheckInHolder := true asValue.
    ].
    ^ quickCheckInHolder
!

quickCheckInVisibleHolder
    quickCheckInVisibleHolder isNil ifTrue:[
        quickCheckInVisibleHolder := true asValue.
    ].
    ^ quickCheckInVisibleHolder
!

recentTagsList
    ^ [ CVSSourceCodeManager recentTags ]
!

tagHolder
    tagHolder isNil ifTrue:[
        tagHolder := ("CVSSourceCodeManager recentTag ?" '') asValue.
    ].
    ^ tagHolder
!

validateConsistencyEnabledHolder
    validateConsistencyEnabledHolder isNil ifTrue:[
        validateConsistencyEnabledHolder := false asValue.
    ].
    ^ validateConsistencyEnabledHolder
!

validateConsistencyHolder
    validateConsistencyHolder isNil ifTrue:[
        validateConsistencyHolder := true asValue.
    ].
    ^ validateConsistencyHolder
!

validateConsistencyVisibleHolder
    validateConsistencyVisibleHolder isNil ifTrue:[
        validateConsistencyVisibleHolder := true asValue.
    ].
    ^ validateConsistencyVisibleHolder
!

warningMessageHolder
    warningMessageHolder isNil ifTrue:[
        warningMessageHolder := nil asValue.
    ].
    ^ warningMessageHolder.

    "Created: / 06-07-2010 / 11:30:29 / cg"
! !

!CheckinInfoDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

