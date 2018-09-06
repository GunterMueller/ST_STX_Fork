"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCDialog subclass:#MCCommitDialog
	instanceVariableNames:'workingCopyHolder repositoryHolder versionNameHolder
		messageHolder messageView versionNameFinderProcess
		includeExtrasForSTX clearChangeSet'
	classVariableNames:'LastRepository DefaultForIncludeSTXExtras
		DefaultForClearChangeSet'
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!


!MCCommitDialog class methodsFor:'help specs'!

flyByHelpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:MCCommitDialog    
    "

    <resource: #help>

    ^ super flyByHelpSpec addPairsFrom:#(

#commitMessage
'A log message describing this version (your changes)'

#includeExtrasForSTX
'When checked, include extra support files (makefiles) needed to build a binary class library under ST/X.
If this is not checked, only the plain code is saved which is needed to load the package as bytecode.
Notice, that those files are not strictly required - they can easily be recreated by loading the package,
and then recreating the support files from the system browser on the target system.
Turn this off, if this package is meant to be transported to or shared with other Smalltalk dialects.
(however, this is transparent to other Smalltalk dialects - these will simply ignore these additional definitions)

When unchecked, project definition class and version_XX methods are ommited (i.e., not present in .mcz).
This may be desirable when commiting Smalltalk/X changes back to Squeak / Pharo upstream repository
(and maintainer does not want these in the code even though it does not hurt)'

#clearChangeSet
'Clear the internal changeset after the Monticello commit'

#repository
'A repository or the name of a directory where the generated package file is to be stored'

#versionName
'The name of the version (will also be the name of the generated package file)'

)

    "Modified: / 24-04-2015 / 08:39:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCCommitDialog class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MCCommitDialog andSelector:#contentSpec
     MCCommitDialog new openInterface:#contentSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: contentSpec
        window: 
       (WindowSpec
          label: 'Commit Dialog'
          name: 'Commit Dialog'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 555 303)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Repository:'
              name: 'Label1'
              layout: (LayoutFrame 3 0 4 0 94 0 26 0)
              activeHelpKey: repository
              translateLabel: true
              adjust: left
            )
           (ComboListSpec
              name: 'RepositoryList'
              layout: (LayoutFrame 101 0 0 0 0 1 25 0)
              activeHelpKey: repository
              model: repositoryHolder
              comboList: repositoryList
              useIndex: false
            )
           (LabelSpec
              label: 'Version:'
              name: 'Label2'
              layout: (LayoutFrame 3 0 30 0 94 0 52 0)
              activeHelpKey: versionName
              translateLabel: true
              adjust: left
            )
           (InputFieldSpec
              name: 'VersionName'
              layout: (LayoutFrame 101 0 30 0 0 1 55 0)
              activeHelpKey: versionName
              model: versionNameHolder
              immediateAccept: true
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnPointerLeave: true
            )
           (CheckBoxSpec
              label: 'Include ST/X Support Files'
              name: 'CheckBox1'
              layout: (LayoutFrame 96 0 63 0 232 1 85 0)
              activeHelpKey: includeExtrasForSTX
              model: includeExtrasForSTX
              translateLabel: true
            )
           (CheckBoxSpec
              label: 'Clear Change Set'
              name: 'CheckBox2'
              layout: (LayoutFrame 96 0 90 0 232 1 112 0)
              activeHelpKey: clearChangeSet
              model: clearChangeSet
              translateLabel: true
            )
           (TextEditorSpec
              name: 'CommitMessage'
              layout: (LayoutFrame 0 0 120 0 0 1 0 1)
              activeHelpKey: commitMessage
              model: messageHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              hasKeyboardFocusInitially: false
              postBuildCallback: postBuildMessageView:
            )
           )
         
        )
      )
! !

!MCCommitDialog methodsFor:'accessing'!

workingCopy: aMCWorkingCopy

    ^self workingCopyHolder value: aMCWorkingCopy

    "Created: / 14-09-2010 / 23:43:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCCommitDialog methodsFor:'accessing - defaults'!

defaultTitle
    "superclass MCDialog says that I am responsible to implement this method"

    ^ 'Monticello Commit'

    "Modified: / 14-09-2010 / 23:00:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2011 / 15:44:08 / cg"
! !

!MCCommitDialog methodsFor:'actions'!

doAccept
    self acceptEnabled ifFalse:[^self].

    self withWaitCursorDo:[
        |workingCopy version repository clearChangeSet
         newVersionString stxPackageID defClass|

        workingCopy := self workingCopyHolder value.
        repository := self repositoryHolder value.
        LastRepository := repository.
        DefaultForIncludeSTXExtras := clearChangeSet := self clearChangeSet value.

        [
            version := workingCopy newVersion
        ] on: MCVersionNameAndMessageRequest do:[:n | 
            n resume: (Array with: self versionNameHolder value 
                             with: messageView contents asText string)
        ].

        stxPackageID := version package name.
        defClass := ProjectDefinition definitionClassForPackage:stxPackageID.
        newVersionString := MCSourceCodeManager revisionStringForVersion:version.

        "/ update all project classes version_MC
        defClass allClasses do:[:cls |
            MCSourceCodeManager 
                updateVersionMethod:(MCSourceCodeManager nameOfVersionMethodInClasses) 
                of:cls 
                for:newVersionString.
        ].

        "/ update the project definition classes version_MC
        MCSourceCodeManager 
            updateVersionMethod:(MCSourceCodeManager nameOfVersionMethodInClasses) 
            of:defClass 
            for:newVersionString.
        MCSourceCodeManager 
            updateVersionMethod:(MCSourceCodeManager nameOfVersionMethodForExtensions) 
            of:defClass 
            for:newVersionString.

        "/ sigh: make a new snapshot (now with updated version methods)
        version snapshot:version package snapshot.
        version cachable:false. "/ force new a write (otherwise, the mcz is not rewritten)
        version snapshot options includeExtrasForSTX:(DefaultForIncludeSTXExtras := self includeExtrasForSTX value).
        repository storeVersion: version.

        clearChangeSet ifTrue:[
            ChangeSet current condenseChangesForPackage:stxPackageID
        ].
    ].
    super doAccept.

    "Created: / 15-09-2010 / 14:07:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-07-2012 / 16:33:56 / cg"
    "Modified: / 07-09-2015 / 15:27:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCCommitDialog methodsFor:'aspects'!

clearChangeSet
    clearChangeSet isNil ifTrue:[
        clearChangeSet := (DefaultForClearChangeSet ? true) asValue.
    ].
    ^ clearChangeSet
!

includeExtrasForSTX
    includeExtrasForSTX isNil ifTrue:[
        includeExtrasForSTX := (DefaultForIncludeSTXExtras ? true) asValue.
    ].
    ^ includeExtrasForSTX
!

messageHolder
    "return/create the 'messageHolder' value holder (automatically generated)"

    messageHolder isNil ifTrue:[
        messageHolder := ValueHolder with: ('Commit message' asText colorizeAllWith: Color gray).
        messageHolder addDependent:self.
    ].
    ^ messageHolder

    "Modified: / 15-09-2010 / 13:58:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messageHolder:something
    "set the 'messageHolder' value holder (automatically generated)"

    |oldValue newValue|

    messageHolder notNil ifTrue:[
        oldValue := messageHolder value.
        messageHolder removeDependent:self.
    ].
    messageHolder := something.
    messageHolder notNil ifTrue:[
        messageHolder addDependent:self.
    ].
    newValue := messageHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:messageHolder.
    ].
!

repositoryActionList
    "to determine which action to take when the repository selection is
     changed (especially for the add xxx entries)"

    ^
      (Array new: MCRepositoryGroup default repositories size)
      , (Array 
            with:nil
            with:#addRepository
            with:#addDirectoryRepository
        ) 
!

repositoryHolder
    "return/create the 'repositoryHolder' value holder (automatically generated)"

    |initial|

    repositoryHolder isNil ifTrue:[
        repositoryHolder := ValueHolder new.
        initial := LastRepository.
        initial isNil ifTrue:[
            initial := UserPreferences current at:#mcPrimaryRepository ifAbsent:nil.
        ].
        repositoryHolder value:initial.
        repositoryHolder addDependent:self.
    ].
    ^ repositoryHolder

    "Modified: / 24-07-2012 / 16:32:01 / cg"
!

repositoryHolder:something
    "set the 'repositoryHolder' value holder (automatically generated)"

    |oldValue newValue|

    repositoryHolder notNil ifTrue:[
        oldValue := repositoryHolder value.
        repositoryHolder removeDependent:self.
    ].
    repositoryHolder := something.
    repositoryHolder notNil ifTrue:[
        repositoryHolder addDependent:self.
    ].
    newValue := repositoryHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:repositoryHolder.
    ].
!

repositoryList

    ^[
      MCRepositoryGroup default repositories
      , (Array 
            with:nil
            with:(resources string:'Open MC Repository Dialog...')
            with:(resources string:'Add Directory Repository...')
        ) 
     ]

    "Created: / 14-09-2010 / 23:16:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2012 / 11:39:42 / cg"
!

versionNameHolder
    "return/create the 'versionNameHolder' value holder (automatically generated)"

    versionNameHolder isNil ifTrue:[
        versionNameHolder := ValueHolder new.
        versionNameHolder addDependent:self.
    ].
    ^ versionNameHolder
!

versionNameHolder:something
    "set the 'versionNameHolder' value holder (automatically generated)"

    |oldValue newValue|

    versionNameHolder notNil ifTrue:[
        oldValue := versionNameHolder value.
        versionNameHolder removeDependent:self.
    ].
    versionNameHolder := something.
    versionNameHolder notNil ifTrue:[
        versionNameHolder addDependent:self.
    ].
    newValue := versionNameHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:versionNameHolder.
    ].
!

workingCopyHolder
    "return/create the 'workingCopyHolder' value holder (automatically generated)"

    workingCopyHolder isNil ifTrue:[
        workingCopyHolder := ValueHolder new.
        workingCopyHolder addDependent:self.
    ].
    ^ workingCopyHolder
!

workingCopyHolder:something
    "set the 'workingCopyHolder' value holder (automatically generated)"

    |oldValue newValue|

    workingCopyHolder notNil ifTrue:[
        oldValue := workingCopyHolder value.
        workingCopyHolder removeDependent:self.
    ].
    workingCopyHolder := something.
    workingCopyHolder notNil ifTrue:[
        workingCopyHolder addDependent:self.
    ].
    newValue := workingCopyHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:workingCopyHolder.
    ].
! !

!MCCommitDialog methodsFor:'change & update'!

addDirectoryRepository
    |dir repo|

    dir := Dialog requestDirectoryName:'Choose a Repository Directory'.
    dir isEmptyOrNil ifTrue:[^ self].
    repo := MCDirectoryRepository directory:dir.
    MCRepositoryGroup default addRepository:repo.

    self repositoryHolder 
        value:repo
        withoutNotifying:self.
!

addRepository
    MCSettingsApp open.
    self repositoryHolder 
        value:(self repositoryList value first)
        withoutNotifying:self.
!

findUniqueVersionNumber
    | wc versionName |

    self versionNameHolder value:('One Moment, please...' colorizeAllWith:Color grey).

    wc := self workingCopyHolder value.
    self assert:wc notNil.

    self subtitle: wc package name.
    versionName := wc uniqueVersionName.
    self 
        enqueueMessage:#updateVersionNumberTo:
        for:self
        arguments: { versionName }

    "Created: / 31-08-2012 / 11:49:56 / cg"
!

messageChanged

    "/ self halt

    "Created: / 15-09-2010 / 10:04:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryChanged
    |selIndex action|

    selIndex := self repositoryList value indexOf:self repositoryHolder value.
    action := self repositoryActionList at:selIndex.
    action notNil ifTrue:[ 
        self perform:action.
    ].
    self updateAcceptEnabled

    "Created: / 15-09-2010 / 14:02:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2012 / 12:01:02 / cg"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == workingCopyHolder ifTrue:[
         self workingCopyChanged.
         ^ self.
    ].

    changedObject == messageHolder ifTrue:[
         self messageChanged.
         ^ self.
    ].
    changedObject == repositoryHolder ifTrue:[
         self repositoryChanged.
         ^ self.
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 15-09-2010 / 14:02:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAcceptEnabled
    | enabled |

    enabled := true.
    enabled := enabled and:[self workingCopyHolder value notNil].
    enabled := enabled and:[self repositoryHolder value notNil].
    self acceptEnabledHolder value: enabled.

    "Created: / 15-09-2010 / 14:01:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2012 / 11:59:09 / cg"
!

updateVersionNumberTo:versionName
    self versionNameHolder value: versionName.
    self updateAcceptEnabled

    "Created: / 31-08-2012 / 11:54:15 / cg"
!

workingCopyChanged
    |p|

    self window isNil ifTrue:[
        versionNameFinderProcess isNil ifTrue:[
            versionNameFinderProcess :=
                [
                    self findUniqueVersionNumber.
                ] fork.
        ].
        ^ self.
    ].

    (self workingCopyHolder value) notNil ifTrue:[
        (p := versionNameFinderProcess) notNil ifTrue:[
            versionNameFinderProcess := nil.
            p terminateAndWait.
        ].
        self findUniqueVersionNumber.
    ].

    "Created: / 15-09-2010 / 09:30:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-09-2010 / 14:01:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2012 / 11:53:32 / cg"
! !

!MCCommitDialog methodsFor:'hooks'!

postBuildMessageView: aView

    messageView := aView scrolledView

    "Created: / 15-09-2010 / 13:56:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCCommitDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCCommitDialog.st,v 1.13 2015-02-25 00:12:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCCommitDialog.st,v 1.13 2015-02-25 00:12:38 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_MC
    ^ '$stx:goodies/monticello-cg.3 4e70fe70-f030-11e1-ac62-001f3bda2d09 2012-08-27T12:16:46 cg$'
!

version_SVN
    ^ '$Id: MCCommitDialog.st,v 1.13 2015-02-25 00:12:38 cg Exp $'
! !

