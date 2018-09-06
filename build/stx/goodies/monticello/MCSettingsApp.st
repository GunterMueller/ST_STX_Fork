"{ Package: 'stx:goodies/monticello' }"

AbstractSettingsApplication subclass:#MCSettingsApp
	instanceVariableNames:'mcRepositories selectedRepositoryHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!


!MCSettingsApp class methodsFor:'help specs'!

flyByHelpSpec

    <resource: #help>
    
    ^self helpSpec

    "Created: / 26-05-2008 / 14:25:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:MCSettingsApp    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#addRepository
'Add another monticello repository to the list'

#makePrimaryRepository
'Checkin from the browser will go into this repository by default'

#primaryRepository
'Checkin from the browser will go into this repository by default'

#removeRepository
'Remove the selected repository from the list'

)

    "Modified: / 03-12-2011 / 11:35:51 / cg"
! !

!MCSettingsApp class methodsFor:'image specs'!

defaultIcon
    "/ ^ self repositoryIcon.
    ^ self squeakRepositoryIcon24x24

    "Created: / 26-05-2008 / 14:55:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-09-2010 / 14:02:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2012 / 10:34:53 / cg"
!

repositoryIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'MCSettingsApp class repositoryIcon'
        ifAbsentPut:[(Depth8Image new) width: 22; height: 22; photometric:(#palette); bitsPerSample:(#(8 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@A@PHB@0P@@@@@@@@@@@@@@@@@@@HEA \HA $JB0HD@@@@@@@@@@@@@@HLA04NC0HD@@L@@ P@@@@@@@@@@@@ED@ NDP@@@@@@@@@D@@@@@@@@
@@@BA \FAPP@@@@@@@@@@@P@@@@@@@@@AQ@RC0@@@@@@@@@@@@@@@@@@@@@@@@TGA!!DD@@@@@@@@@@@@@@@@@@@D@PDIA08OA@@@@@@@@@@@@@@@@@@@AP S
A0XIBPXGC0P@@@@@@@@@@@@@@@@ECAPLBPXOAP@@@@@@EQX@@@@@@@@@@@TIE@XOAP@@@@@@EQ\XE @@@@@@@@@@AP$OAP@@@@@@FQ\ZE!! V@@@@@@@@@@@E
F0@@@@@@EQ\ZF!!(VFAX@@@@@@@@@@@@@@@@ZEQ\VE!!(ZF!!XWF @@@@@@@@@@@@@@@@@@@A\ZE!!(@@@@@@@@@@@@@@@@@@@@@@@@XE!!XZ@@@@@@@@@@@@@@@@
@@@@@@@@EQ(V@@@@@@@@@@@@@@@@@@@@@@@@EQ\VE @@@@@@@@@@@@@@@@@@@@@@EQ VE @@@@@@@@@@@@@@F @@@@@WEQ VE!!(@@@@@@@@@@@@@@@@@E!!\W
EQXVE @@@@@@@@@@@@@@@@@@@@@@@A(Z@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 32 64 0 0 64 0 32 32 0 0 32 0 32 96 32 96 192 128 192 224 192 160 224 160 32 128 64 64 96 64 64 96 32 32 160 64 160 224 192 64 160 96 32 128 32 224 224 224 64 128 64 160 192 160 224 224 192 32 160 96 160 160 160 64 64 64 96 96 96 128 128 128 192 192 192 32 32 32 32 64 32]; mask:((ImageMask new) width: 22; height: 22; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@O8@@?>@A??@A?C C<@0C8@PC8@@??@@??F@_>O@O<_ G8?0C1?8A#?<@C?<@@_@H@_@L@?@GC>@C?>@A?<@@_0@') ; yourself); yourself]

    "Created: / 26-05-2008 / 14:55:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-09-2010 / 14:02:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-11-2011 / 15:46:41 / cg"
    "Created: / 15-01-2012 / 10:34:23 / cg"
!

squeakIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self squeakIcon inspect
     ImageEditor openOnClass:self andSelector:#squeakIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::ConfigurationApp class squeakIcon'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 18; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DB@0@@@@@@@@@@@@@@A@TF@@@@@@@@@@\@@ D@@@@@@@@@@@@C
@ @F@@@@@@@@@@ @@@H@@@@@@@@@@@@B@@@F@@@@@@@@@@$@@@@J@@@@@@@@@@H@@@@F@@@@@@@@@@,@@@@@@@@@@@@@@@@@@@@K@@@@@@@@@@0@@@@@@@@@
@@@@@@@@@@@K@@@@@@@@@@DM@@@@@04@@@@@CP@@@@,A@@@@@@@@@@@N@@@@C0<M@@@OC04@@@,@@@@@@@@@@@@K@@@@C1@Q@@@ODAD@@AH@@@@@@@@@@@@@
@@@@DQLM@@@QC04@@@@@@@@@@@@@B@@@@@ @@@@@@P@@@@@@B@@@@@@@@@@KB0@@@@@F@@@QC0<Q@@@@@@@@@@@@@@@@@@@KB0,@@@@QC0<Q@@@@B0,KB0@@
@@@@@@@@@@@K@@@@@0@@@@@KB0@@@@,@@@@@@@@@B0@@@@@@@@@@@@@@@@,K@@@K@@@@@@X@@@@@@@@@@@@@@@@@@@@@B0@@') ; colorMapFromArray:#[164 164 164 232 232 232 102 102 102 233 233 233 236 236 236 143 143 143 161 161 161 110 110 110 190 190 190 163 163 163 97 97 97 169 169 169 124 124 124 185 185 185 155 155 155 0 0 0 255 255 255 139 139 139 118 118 118 4 4 4]; mask:((Depth1Image new) width: 24; height: 18; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@C @8B0A(BPAHBHBHB@@HB@@HCFDXAGNPAGNP@GN@G0 <LI9CC18<DX!!"I @YB@@D') ; yourself); yourself]
!

squeakRepositoryIcon24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self squeakRepositoryIcon24x24 inspect
     ImageEditor openOnClass:self andSelector:#squeakRepositoryIcon24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::ConfigurationApp class squeakRepositoryIcon24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DB@0@@@@@@@@@@@@@@A@TF@@@@@@@@@@\@@ D@@@@@@@@@@@@C
@ @F@@@@@@@@@@ @@@H@@@@@@@@@@@@B@@@F@@@@@@@@@@$@@@@J@@@@@@@@@@H@@@@F@@@@@@@@@@,@@@@@@@@@@@@@@@@@@@@K@@@@@@@@@@0@@@@@@@@@
@@@@@@@@@@@K@@@@@@@@@@DM@@@@@04@@@@@CP@@@@,A@@@@@@@@@@@N@@@@C0<M@@@OC04@@@,@@@@@@@@@@@@K@@@@C1@Q@@@ODAD@@AH@@@@@@@@@@@@@
@@@@DQLM@@@QC04@@@@@@@@@@@@@B@@ZF!!\W@@@@@P@@@@@@B@@@@@@@@@@KB1\ZF!!(ZE0@QC0<Q@@@@@@@@@@@@@@@@E!!(ZB0,@@A\QC0<Q@@@@B0,KB0@@
@@@@E1 W@@@K@@@@@0@@@@@KB0@@@@,@@A\WF!!$ZF0@@G@@@@@@@@@@@@@,K@@@K@@@WFQ(W@@@\GA0@@@@@@@@@@@@@B0@@@@@@E2@@@A0_G18\@@@@@@@@
@@@@@@@@@@@@@@@@GA0]GA0\@@@@@@@@@@@@@@@@@@@\@@@@@@@\G@@@@@@@@@@@@@@@@@@@@@@@GA0\GA0\C0@@@@@@@@@@@@@@@@@@@@@@@A4\GA0O@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[164 164 164 232 232 232 102 102 102 233 233 233 236 236 236 143 143 143 161 161 161 110 110 110 190 190 190 163 163 163 97 97 97 169 169 169 124 124 124 185 185 185 155 155 155 0 0 0 255 255 255 139 139 139 118 118 118 4 4 4 229 229 229 214 214 214 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 64 64 64 96 96 96 128 128 128 32 32 32 32 64 32]; mask:((Depth1Image new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@C @8B0A(BPAHBHBHB@@HB@@HCFDXAGNPAGNP@GN@G8 <O=9CG38<GX!!"_$@YON@DF_@@@?@@HL@@G<@@C8@@@@@@') ; yourself); yourself]
!

svnIcon
    "^ IconLibrary svn_wizban"
    ^nil

    "Created: / 24-05-2008 / 01:44:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-09-2010 / 14:02:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCSettingsApp class methodsFor:'interface opening'!

open    

    | settingsApp |

    settingsApp := SettingsDialog new.
    settingsApp addApplClass:self fullName
                withName:'Monticello'.
    settingsApp showRoot: false.
    settingsApp selectedItem value:
        (settingsApp applicationList root children anyOne).
    settingsApp open.

    "Created: / 26-05-2008 / 12:17:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-04-2012 / 11:17:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCSettingsApp class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MCSettingsApp andSelector:#windowSpec
     MCSettingsApp new openInterface:#windowSpec
     MCSettingsApp open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Monticello Settings'
          name: 'Monticello Settings'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 647 627)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: ' Monticello Settings'
              name: 'Title'
              layout: (LayoutFrame 0 0 0 0 0 1 66 0)
              style: (FontDescription helvetica medium roman 18 #'iso10646-1')
              backgroundColor: (Color 100.0 100.0 100.0)
              translateLabel: true
              adjust: left
            )
           (LabelSpec
              label: 'Icon'
              name: 'Icon'
              layout: (LayoutFrame -75 1 0 0 0 1 66 0)
              initiallyInvisible: true
              hasCharacterOrientedLabel: false
              backgroundColor: (Color 100.0 100.0 100.0)
              translateLabel: true
            )
           (VerticalPanelViewSpec
              name: 'Controls'
              layout: (LayoutFrame 0 0 70 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: topFit
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (HorizontalPanelViewSpec
                    name: 'EnabledAndResetPanel'
                    horizontalLayout: rightSpaceFit
                    verticalLayout: fit
                    horizontalSpace: 0
                    verticalSpace: 3
                    component: 
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Show in Browser Menus'
                          name: 'Enabled'
                          model: mcEnabled
                          translateLabel: true
                          useDefaultExtent: true
                        )
                       (ActionButtonSpec
                          label: 'Flush caches'
                          name: 'ResetCachedRepositoriesButton'
                          translateLabel: true
                          model: flushCaches
                          enableChannel: mcEnabled
                          useDefaultExtent: true
                        )
                       )
                     
                    )
                    useDefaultExtent: true
                  )
                 (ViewSpec
                    name: 'Box1'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Primary Repository: '
                          name: 'Label2'
                          layout: (LayoutFrame 7 0 0 0 150 0 22 0)
                          activeHelpKey: primaryRepository
                          translateLabel: true
                          adjust: left
                        )
                       (LabelSpec
                          name: 'Label3'
                          layout: (LayoutFrame 150 0 0 0 0 1 22 0)
                          activeHelpKey: primaryRepository
                          translateLabel: true
                          labelChannel: mcPrimaryRepository
                          adjust: left
                        )
                       )
                     
                    )
                    extent: (Point 647 24)
                  )
                 (FramedBoxSpec
                    label: 'Repositories'
                    name: 'Repositories'
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (VerticalPanelViewSpec
                          name: 'RepositoryConfigurations'
                          layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                          horizontalLayout: fit
                          verticalLayout: bottomFit
                          horizontalSpace: 3
                          verticalSpace: 3
                          component: 
                         (SpecCollection
                            collection: (
                             (ViewSpec
                                name: 'RepositoryConfigurationListBox'
                                model: mcRepositories
                                component: 
                               (SpecCollection
                                  collection: (
                                   (SelectionInListModelViewSpec
                                      name: 'RepositoryList'
                                      layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                                      enableChannel: mcEnabled
                                      model: selectedRepositoryHolder
                                      hasHorizontalScrollBar: true
                                      hasVerticalScrollBar: true
                                      listModel: mcRepositories
                                      useIndex: false
                                      highlightMode: line
                                    )
                                   )
                                 
                                )
                                extent: (Point 613 437)
                              )
                             (HorizontalPanelViewSpec
                                name: 'AddRemovePanel'
                                horizontalLayout: fit
                                verticalLayout: center
                                horizontalSpace: 3
                                verticalSpace: 3
                                component: 
                               (SpecCollection
                                  collection: (
                                   (ActionButtonSpec
                                      label: 'Add Repository...'
                                      name: 'AddConfigurationAction'
                                      activeHelpKey: addRepository
                                      translateLabel: true
                                      model: addRepositoryAction
                                      enableChannel: mcEnabled
                                      extent: (Point 151 25)
                                    )
                                   (ActionButtonSpec
                                      label: 'Remove Repository...'
                                      name: 'RemoveConfigurationAction'
                                      activeHelpKey: removeRepository
                                      translateLabel: true
                                      model: removeRepositoryAction
                                      enableChannel: mcEnabledAndRepositorySelectedHolder
                                      extent: (Point 151 25)
                                    )
                                   (LabelSpec
                                      name: 'Label1'
                                      translateLabel: true
                                      extent: (Point 151 22)
                                    )
                                   (ActionButtonSpec
                                      label: 'Define as Primary'
                                      name: 'Button1'
                                      activeHelpKey: makePrimaryRepository
                                      translateLabel: true
                                      model: defineAsPrimaryRepositoryAction
                                      enableChannel: mcEnabledAndRepositorySelectedHolder
                                      extent: (Point 151 25)
                                    )
                                   )
                                 
                                )
                                extent: (Point 613 30)
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                    extent: (Point 647 503)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!MCSettingsApp class methodsFor:'queries'!

managerTypeName

    ^ 'Monticello'

    "Created: / 21-07-2011 / 11:47:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCSettingsApp methodsFor:'accessing'!

repositoryConfiguration

    ^self selectedRepositoryHolder value

    "Created: / 26-05-2008 / 12:04:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-09-2011 / 11:55:22 / cg"
!

repositoryConfiguration: anObject

    self selectedRepositoryHolder value: anObject

    "Created: / 26-05-2008 / 12:12:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-09-2011 / 11:55:24 / cg"
!

repositoryConfigurationList

    ^self mcRepositories value

    "Created: / 26-05-2008 / 12:05:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-09-2011 / 11:50:53 / cg"
!

repositoryManager

    ^RepositoryManager current

    "Created: / 26-05-2008 / 10:46:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

workingCopyBase

    ^self workingCopyBaseAspect value

    "Created: / 26-05-2008 / 13:15:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MCSettingsApp methodsFor:'actions'!

addRepositoryAction
    | dialog class codeHolder repo lastInput asking |

    class := Dialog 
            choose:'Select repository type' 
            fromList:#('HTTP Repository' 'FTP Repository' 'Local Repository')
            values:(Array 
                        with: MCHttpRepository 
                        with: MCFtpRepository 
                        with: MCDirectoryRepository)
            lines:5 cancel:[^self].

    codeHolder := ValueHolder new.

    asking := true.
    [asking] whileTrue:[
        class == MCDirectoryRepository ifTrue:[
            |dir|
            dir := Dialog requestDirectoryName:'MC Repository Directory'.
            dir isEmptyOrNil ifTrue:[^ self].
            repo := MCDirectoryRepository directory:dir.
        ] ifFalse:[
            dialog := Dialog 
                    forRequestText:'Please Fill in Data:' 
                    lines:10 columns:60 
                    initialAnswer: (lastInput ? class creationTemplate)  
                    model:codeHolder.
            dialog open.
            dialog accepted ifFalse:[^self].
            lastInput := codeHolder value.
            repo := Compiler evaluate: codeHolder value.
        ].

        repo isValid ifTrue:[
            asking := false
        ] ifFalse:[
            |answer|

            repo class == MCDirectoryRepository ifTrue:[
                answer := Dialog confirmWithCancel:'Invalid repository. Create?'.
                answer == nil ifTrue:[
                    ^ self
                ].
                answer == true ifTrue:[
                    repo directory asFilename recursiveMakeDirectory
                ].
                asking := false
            ] ifFalse:[
                answer := Dialog confirmWithCancel:'Invalid repository. Try again?'.
                answer == nil ifTrue:[
                    ^ self
                ].
                answer == false ifTrue:[
                    asking := false
                ].
            ]
        ].
    ].
    self mcRepositories value add: repo.
    self mcRepositories changed:#value.
    self updateModifiedChannel

    "Created: / 26-05-2008 / 12:04:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 17:24:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 01-12-2011 / 20:31:10 / cg"
    "Modified: / 04-04-2012 / 11:14:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defineAsPrimaryRepositoryAction
    self mcPrimaryRepository value:(self selectedRepositoryHolder value)

    "Created: / 01-12-2011 / 20:33:16 / cg"
!

flushCaches
    <resource: #uiCallback>

    "automatically generated by UIPainter..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."
    "*** (and replace this comment by something more useful ;-)"

    "action to be defined here..."

    Transcript showCR:self class name, ': action for flushCaches ...'.
!

removeRepositoryAction
    self repositoryConfiguration notNil ifTrue:[ 
        self mcRepositories value remove: self repositoryConfiguration.
        self mcRepositories changed:#value.
        self updateModifiedChannel
    ].

    "Created: / 26-05-2008 / 12:04:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 01-12-2011 / 20:50:08 / cg"
    "Modified: / 04-04-2012 / 11:15:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCSettingsApp methodsFor:'aspects'!

mcEnabled
    ^self settingsAspectFor: #mcEnabled default:false

    "Created: / 16-09-2010 / 14:14:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2011 / 20:08:10 / cg"
!

mcEnabledAndRepositorySelectedHolder
    ^ BlockValue
        with:[:v | self mcEnabled value and:[ v notNil ]]
        argument:(self selectedRepositoryHolder)

    "Created: / 01-12-2011 / 19:58:57 / cg"
!

mcPrimaryRepository

    ^self settingsAspectFor: #mcPrimaryRepository default:nil

    "Created: / 16-09-2010 / 14:14:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 01-12-2011 / 20:06:36 / cg"
!

mcRepositories
    "return/create the 'mcRepositories' value holder (automatically generated)"

    mcRepositories isNil ifTrue:[
        mcRepositories := ValueHolder new.
    ].
    ^ mcRepositories
!

selectedRepositoryHolder
    selectedRepositoryHolder isNil ifTrue:[
        selectedRepositoryHolder := nil asValue.
    ].
    ^ selectedRepositoryHolder

    "Created: / 01-12-2011 / 20:19:36 / cg"
! !

!MCSettingsApp methodsFor:'helpers'!

settingsAspectFor:settingName default:default
    |holder|

    self createBuilder.

    (holder := builder bindingAt:settingName) isNil ifTrue:[
        holder := (currentUserPrefs at:settingName asSymbol ifAbsent:default) asValue.
        builder aspectAt:settingName put:holder.
        holder onChangeSend:#updateModifiedChannel to:self.
    ].
    ^ holder.

    "Created: / 25-05-2009 / 18:43:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 01-12-2011 / 20:07:59 / cg"
! !

!MCSettingsApp methodsFor:'protocol'!

basicReadSettings

    self mcRepositories value: MCRepositoryGroup default repositories copy.

    "/ special case, because default value of false is not ok here !!
    (currentUserPrefs includesKey:#mcPrimaryRepository) ifTrue:[
        self
            readAspects: #(mcPrimaryRepository)
            from:currentUserPrefs.
    ].

    self
        readAspects: #(mcEnabled)
        from:currentUserPrefs.

    "Modified: / 01-12-2011 / 20:26:23 / cg"
    "Modified: / 04-04-2012 / 11:11:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicSaveSettings

    self
        writeAspects: #(mcEnabled mcPrimaryRepository)
        to:currentUserPrefs.

    MCRepositoryGroup default repositories: self mcRepositories value copy

    "Created: / 19-04-2008 / 09:42:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-05-2009 / 19:06:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 01-12-2011 / 20:06:01 / cg"
    "Modified: / 04-04-2012 / 11:24:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

helpFilename
    "subclasses must return the relative name of a helpFile
     in the doc/online/<language>/help directory.
     Or nil, if no help is available."

    ^nil

    "Created: / 19-04-2008 / 09:42:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-05-2008 / 13:12:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MCSettingsApp methodsFor:'queries'!

hasUnsavedChanges

    self mcRepositories value = MCRepositoryGroup default repositories ifFalse:[^true].

    "/ special case, because default value of false is not ok here !!
    (currentUserPrefs includesKey:#mcPrimaryRepository) ifTrue:[
        (self
            hasChangedAspectIn: #(mcPrimaryRepository)
            asComparedTo:currentUserPrefs) ifTrue:[^ true].
    ] ifFalse:[
        self mcRepositories value notNil ifTrue:[
            self mcRepositories value ~= MCRepositoryGroup default repositories ifTrue:[
                ^ true
            ]
        ]
    ].
    ^ self
        hasChangedAspectIn: #(mcEnabled)
        asComparedTo:currentUserPrefs

    "Created: / 28-05-2008 / 07:33:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:07:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-04-2012 / 11:12:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-07-2012 / 15:50:53 / cg"
! !

!MCSettingsApp class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSettingsApp.st,v 1.14 2014-03-01 09:40:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSettingsApp.st,v 1.14 2014-03-01 09:40:15 cg Exp $'
!

version_SVN
    ^ '$Id: MCSettingsApp.st,v 1.14 2014-03-01 09:40:15 cg Exp $'
! !

