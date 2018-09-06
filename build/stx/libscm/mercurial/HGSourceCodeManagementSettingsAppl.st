"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

AbstractSourceCodeManagementSettingsAppl subclass:#HGSourceCodeManagementSettingsAppl
	instanceVariableNames:'defaultLogo hgCommand hgAvailable hgDiff2Command hgDiff3Command
		hgAutopush hgUseSharedRepositories infoPanel hgrcAspect hgEnabled'
	classVariableNames:'IgnoreCheckUsername IgnoreCheckMenuLayout'
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Interface'
!

!HGSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGSourceCodeManagementSettingsAppl class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    IgnoreCheckUsername := false.
    IgnoreCheckMenuLayout := false.

    "Modified: / 18-02-2014 / 11:46:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManagementSettingsAppl class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:HGSourceCodeManagementSettingsAppl    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#hgUseSharedRepositories
'When unchecked (default), a regular clones are used. When checked, a shared repositories are used to create a temporary working copy. See `hg help share` for details on shared working copies.'

)
! !

!HGSourceCodeManagementSettingsAppl class methodsFor:'image specs'!

defaultIcon
    <resource: #programImage>

    ^ self defaultIcon3

    "Created: / 22-12-2011 / 13:47:11 / cg"
!

defaultIcon1
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon1
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'MercurialSourceCodeManagementSettingsAppl class defaultIcon1'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHCA@PEA D@@@@@@@@@@@@@@@@@@@@GA@ HB@ HB@$C
B @@@@@@@@@@@@@@@@,IB@ HB@ HB@ LA@4@@@@@@@@@@@@@C LLB@ HB@ HB@ HB@<P@@@@@@@@@@@@BPPHB@ HB@ HB@ HBADR@@@@@@@@@@@@D0$HB@ H
B@ HB@ HB@ SA@@@@@@@@@@@@APLB@ HB@ HB@ HB@ IEP@@@@@VA@LW@Q OC@ HB@ HB@ HB@ LFPD@@@DLBP\Q@@@ZF0 LB@ HB@ HB@ IF@X@@A0HA!!4^
@@@SF!!<_@@$HB@ HB@0FH@L@@BDI@AHC@@@@HP@O@BHIB@ HB@LFH0H@@@@ABQ0@@@@@@@@!!A@@DB@ HCA0OI@8@@@@@@@@@@A\@@@@@@@XDB@ HBP8%I D@
@@@@@@@BA@$D@P@@@@8IB@ LC P''C0@@@@@@@@DIB@ HBQ0@@@8LA@XA@Q<Y@0@@@@@@@@PLB@ DA@@@@@PCB" JC2T[@@@@@@@@@@PLB@PPBP@@@@P)JB$I
J!!HA@@@@@@@@@B,LBQXCKB,@A XACQP-F0L@@@@@@@@@@@(RK"T,D0@@BA,/LCD@L @@@@@@@@@@@@@@@ $!!@@@@@QTTC@ 3@@@@@@@@@@@@@@@@@@@@@@@@
@CP\L0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 143 136 136 208 208 208 192 192 184 176 176 176 175 168 168 176 168 168 191 184 184 191 176 176 159 152 144 160 160 160 239 232 224 192 184 184 159 152 160 207 192 200 207 200 200 144 144 144 224 224 224 160 152 160 127 120 120 144 144 136 128 128 128 111 104 104 207 200 208 239 232 240 95 88 88 96 96 96 79 72 80 112 112 120 192 192 200 223 208 208 111 104 96 80 80 80 64 64 64 223 216 216 128 120 128 31 24 24 32 32 24 79 72 64 64 56 56 47 40 40 240 240 240 239 224 224 63 48 48 191 184 176 112 112 104 64 64 56 63 56 56 48 48 48 48 40 48 127 112 120 160 160 168 208 200 208 224 224 216 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@G>@@O? @_?0@??8@??8@??<@??<O??>__?>_O?>_G?>NA?>@P_>A<_<C>_<C>_8C>_8C>?0C<? @8?@@@\@@@@@');
                            yourself);
                yourself
        ]
!

defaultIcon2
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon2 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon2
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:'MercurialSourceCodeManagementSettingsAppl class defaultIcon2'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHCA@PEA D@@@@@@@@@@@@@@@@@@@@GA@ HB@ HB@$C
B @@@@@@@@@@@@@@@@,IB@ HB@ HB@ LA@4@@@@@@@@@@@@@C LLB@ HB@ HB@ HB@<P@@@@@@@@@@@@BPPHB@ HB@ HB@ HBADR@@@@@@@@@@@@D0$HB@ H
B@ HB@ HB@ SA@@@@@@@@@@@@APLB@ HB@ HB@ HB@ IEP@@@@@VA@LW@Q OC@ HB@ HB@ HB@ LFPD@@@DLBP\Q@@@ZF0 LB@ HB@ HB@ IF@X@@A0HA!!4^
@@@SF!!<_@@$HB@ HB@0FH@L@@BDI@AH:N#\7HP@O@BHIB@ HB@LFH0H@@@@ABS\:N#(:M0@!!A@@DB@ HCA0OI@8@@@@@M#(:@A\@@C\@@@XDB@ HBP8%I D@
@@@@M3 7A@$D@P@@@@8IB@ LC P''C0@@@C\7N#$:N0 HHA0@@@8LA@XA@Q<Y@0@@@@@7NS(7B@  HB@@@@PCB" JC2T[@@@@@@@@M34LBB@<OAP @@P)JB$I
J!!HA@@@@@@@@@B,LHB@YHB@ A XACQP-F0L@@@@@@@@ @@(RK"T H@@@BA,/LCD@L @@@@@@@@@@HB@ HB@ MP@@@QTTC@ 3@@@@@@@@@@@@@A$ HB@5@@@@
@CP\L0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 143 136 136 208 208 208 192 192 184 176 176 176 175 168 168 176 168 168 191 184 184 191 176 176 159 152 144 160 160 160 239 232 224 192 184 184 159 152 160 207 192 200 207 200 200 144 144 144 224 224 224 160 152 160 127 120 120 144 144 136 128 128 128 111 104 104 207 200 208 239 232 240 95 88 88 96 96 96 79 72 80 112 112 120 192 192 200 223 208 208 111 104 96 80 80 80 64 64 64 223 216 216 128 120 128 31 24 24 32 32 24 79 72 64 64 56 56 47 40 40 240 240 240 239 224 224 63 48 48 191 184 176 112 112 104 64 64 56 63 56 56 48 48 48 48 40 48 127 112 120 160 160 168 208 200 208 224 224 216 0 0 0 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 32 32 32 32 64 32 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@G>@@O? @_?0@??8@??8@??<@??<O??>__?>_O?>_??>O=?>GR_>G<_<_>_<O>_8G?_8C??0K<? G<?@C8\@@@@@');
                            yourself);
                yourself
        ]
!

defaultIcon3
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self defaultIcon3 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon3
     Icon flushCachedIcons"
    
    ^ Icon constantNamed:'HGSourceCodeManagementSettingsAppl defaultIcon3'
        ifAbsentPut:[
            (Depth8Image new)
                width:24;
                height:24;
                photometric:(#palette);
                bitsPerSample:(#[ 8 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PHCA@PEA D@@@@@@@@@@@@@@@@@@@@GA@ HB@ HB@$C
B @@@@@@@@@@@@@@@@,IB@ HB@ HB@ LA@4@@@@@@@@@@@@@C LLB@ HB@ HB@ HB@<N@@@@@@@@@@@@BPPHB@ HB@ HB@ HBADR@@@@@@@@@@@@D0$HB@ H
B@ HB@ HB@ SA@@@@@@@@@@@@APLB@ HB@ HB@ HB@ IEP@@@@@VA@LW@Q OC@ HB@ HB@ HB@ LFPD@@@DLBP\Q@@@ZF0 LB@ HB@ HB@ IF@X@@A0HA!!4^
@@@SF!!<_@@$HB@ HB@0FH@L@@BDI@AH:N#\7HP@O@BHIB@ HB@LFH0H@@@@ABS\:N#(:M0@!!A@@DB@ HCA0OI@8@@@@@M#(:@A\@@C\@@@XDB@ HBP8%I D@
@@@@M3 7A@$D@P@@@@8IB@ LDA@''C0@@@C\7N#$:N0 HOA0@@@8LA@XADA@Y@0@@@@@7NS(7B@ <OC0@@@PCB" JDA@[@@@@@@@@M4@LBC0?O38<@@P)DA@P
DA@PDA@@@@@@@B,LOC0=OC0<A XADA@PDA@PDA@@@@@<@@(RK"T<O@@@BA,/LCD@DA@@@@@@@@@@OC0<OC0<MP@@@QTTC@ 3DA@@@@@@@@@@@C4<OC05@@@@
@CP\L0@@DA@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                colorMapFromArray:#[ 174 169 169 255 255 255 233 233 230 216 216 216 213 209 209 214 209 209 232 229 229 229 223 223 191 187 181 197 197 197 255 255 255 233 230 230 194 189 194 247 244 245 251 250 250 177 177 177 131 0 0 194 189 194 155 149 149 175 175 169 157 157 157 136 128 128 251 251 251 255 255 255 117 108 108 118 118 118 97 89 98 139 139 147 240 240 242 255 255 255 137 128 118 98 98 98 79 79 79 255 255 255 156 149 156 38 30 30 39 39 30 97 89 79 79 69 69 58 49 49 255 255 255 255 255 255 77 59 59 229 226 223 137 137 128 79 79 69 77 69 69 59 59 59 59 49 59 154 140 147 199 199 204 251 251 251 255 255 255 0 0 0 0 64 0 32 96 32 96 192 128 32 128 64 32 160 64 32 128 32 64 64 64 96 96 96 128 128 128 32 32 32 32 64 32 ];
                mask:((ImageMask new)
                            width:24;
                            height:24;
                            bits:(ByteArray 
                                        fromPackedString:'@@@@@@@@@G>@@O? @_?0@??8@??8@??<@??<O??>__?>_O?>_??>O=?>GR_>G<_<_>_<O>_8G?_>C??>K<?0G<?0C8\0@@@@');
                            yourself);
                yourself
        ]
!

defaultLogo
    ^ HGIconLibrary hgLogo2

    "Created: / 04-10-2012 / 19:01:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2012 / 23:12:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManagementSettingsAppl class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HGSourceCodeManagementSettingsAppl andSelector:#windowSpec
     HGSourceCodeManagementSettingsAppl new openInterface:#windowSpec
     HGSourceCodeManagementSettingsAppl open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Mercurial Settings'
         name: 'Mercurial Settings'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 695 627)
       )
       component: 
      (SpecCollection
         collection: (
          (LabelSpec
             label: ' Mercurial Settings'
             name: 'MercurialSettingsTitle'
             layout: (LayoutFrame 0 0 0 0 0 1 66 0)
             style: (FontDescription helvetica medium roman 18 #'iso10646-1' nil nil)
             backgroundColor: (Color 100.0 100.0 100.0)
             translateLabel: true
             adjust: left
           )
          (LabelSpec
             label: 'Logo'
             name: 'MercurialLogo'
             layout: (LayoutFrame -71 1 -1 0 4 1 65 0)
             hasCharacterOrientedLabel: false
             backgroundColor: (Color 100.0 100.0 100.0)
             translateLabel: true
             labelChannel: defaultLogo
           )
          (ViewSpec
             name: 'OuterPanel'
             layout: (LayoutFrame 0 0 67 0 0 1 0 1)
             component: 
            (SpecCollection
               collection: (
                (SubCanvasSpec
                   name: 'InfoPanel'
                   layout: (LayoutFrame 0 0 0 0 0 1 40 0)
                   level: 0
                   initiallyInvisible: true
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   clientKey: infoPanel
                   createNewBuilder: false
                 )
                (ViewSpec
                   name: 'InnerPanel'
                   layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                   component: 
                  (SpecCollection
                     collection: (
                      (CheckBoxSpec
                         label: 'Show in Menus'
                         name: 'CheckBox1'
                         layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                         activeHelpKey: shownInBrowserMenus
                         enableChannel: hgAvailable
                         model: hgEnabled
                         translateLabel: true
                       )
                      (ViewSpec
                         name: 'Settings'
                         layout: (LayoutFrame 0 0 40 0 0 1 0 1)
                         component: 
                        (SpecCollection
                           collection: (
                            (VerticalPanelViewSpec
                               name: 'GeneralSettingsPanel'
                               layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                               horizontalLayout: fit
                               verticalLayout: top
                               horizontalSpace: 3
                               verticalSpace: 3
                               component: 
                              (SpecCollection
                                 collection: (
                                  (ViewSpec
                                     name: 'Panel1'
                                     component: 
                                    (SpecCollection
                                       collection: (
                                        (LabelSpec
                                           label: '''hg'' command:'
                                           name: 'CommandLabel'
                                           layout: (LayoutFrame 5 0 0 0 120 0 30 0)
                                           translateLabel: true
                                           adjust: left
                                         )
                                        (FilenameInputFieldSpec
                                           name: 'HGCommand'
                                           layout: (LayoutFrame 125 0 0 0 -100 1 0 1)
                                           model: hgCommand
                                           immediateAccept: true
                                           acceptOnPointerLeave: true
                                           emptyFieldReplacementText: 'Autodetect'
                                         )
                                        (ActionButtonSpec
                                           label: 'Test'
                                           name: 'HGCommandTest'
                                           layout: (LayoutFrame -100 1 0 0 -8 1 0 1)
                                           visibilityChannel: false
                                           translateLabel: true
                                           model: doTestHGCommand
                                         )
                                        (ActionButtonSpec
                                           label: 'Browse'
                                           name: 'BrowseButton'
                                           layout: (LayoutFrame -100 1 0 0 -8 1 0 1)
                                           translateLabel: true
                                           model: doSelectHGCommand
                                         )
                                        )
                                      
                                     )
                                     extent: (Point 695 25)
                                   )
                                  (ViewSpec
                                     name: 'Spacer1'
                                     extent: (Point 695 15)
                                   )
                                  (CheckBoxSpec
                                     label: 'Automatically push changes to upstream repository'
                                     name: 'CheckBox2'
                                     model: hgAutopush
                                     translateLabel: true
                                     extent: (Point 695 22)
                                   )
                                  (CheckBoxSpec
                                     label: 'Use shared repositories (EXPERIMENTAL)'
                                     name: 'CheckBox3'
                                     activeHelpKey: hgUseSharedRepositories
                                     model: hgUseSharedRepositories
                                     translateLabel: true
                                     extent: (Point 695 22)
                                   )
                                  (ViewSpec
                                     name: 'Spacer2'
                                     extent: (Point 695 14)
                                   )
                                  (ViewSpec
                                     name: 'SettingsFile'
                                     component: 
                                    (SpecCollection
                                       collection: (
                                        (LabelSpec
                                           label: 'Mercurial user configuration file:'
                                           name: 'Label1'
                                           layout: (LayoutFrame 25 0 -1 0 0 1 24 0)
                                           translateLabel: true
                                           adjust: left
                                         )
                                        (LinkButtonSpec
                                           label: 'LinkButton'
                                           name: 'EditPreferences'
                                           layout: (LayoutFrame 25 0 28 0 -100 1 58 0)
                                           foregroundColor: (Color 0.0 0.0 100.0)
                                           translateLabel: true
                                           labelChannel: hgrcAspect
                                           adjust: left
                                           model: doEditHGRC
                                         )
                                        (ActionButtonSpec
                                           label: 'Edit'
                                           name: 'Button1'
                                           layout: (LayoutFrame -106 1 -17 0.5 -6 1 8 0.5)
                                           translateLabel: true
                                           model: doEditHGRC
                                         )
                                        )
                                      
                                     )
                                     extent: (Point 695 92)
                                   )
                                  )
                                
                               )
                             )
                            )
                          
                         )
                       )
                      )
                    
                   )
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!HGSourceCodeManagementSettingsAppl class methodsFor:'queries'!

managerClass
    "backlink to my manager class (needed by the settings app)"

    ^ HGSourceCodeManager

    "Created: / 19-04-2011 / 12:46:52 / cg"
    "Modified: / 13-11-2012 / 22:15:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManagementSettingsAppl methodsFor:'actions'!

doCheckSettings
    "Perform some sanity check on current configuration"
    | savedHgCommand |
    self doCheckCommand ifFalse:[ ^ self ].
    savedHgCommand := UserPreferences current hgCommand.
    [
        UserPreferences current hgCommand: hgCommand value asNilIfEmpty.
        self doCheckUsername ifFalse:[ ^ self ].
        self doCheckMenuLayout ifFalse:[ ^ self ].    
    ] ensure:[
        UserPreferences current hgCommand: savedHgCommand.
    ].
    self infoPanel hide.

    "Created: / 18-02-2014 / 10:04:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-04-2016 / 10:22:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doEditHGRC
    <resource: #uiCallback>

    | hgrc editor |

    hgrc := self hgrcAspect value asString string asFilename.
    hgrc exists ifFalse:[ 
        hgrc writingFileDo:[ :s |
            s nextPutAll: HGConfig userConfigFileTemplate
        ].
    ].
    editor := WorkspaceApplication new.
    editor open.
    editor enqueueDelayedAction:[
        editor loadFile: hgrc.
        editor syntaxHolder value: nil.
    ]

    "Modified: / 18-02-2014 / 10:43:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doInstallHG
    OperatingSystem openApplicationForDocument: 'https://www.mercurial-scm.org/downloads' operation: #open

    "Created: / 23-04-2016 / 20:31:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSelectHGCommand
    | guess executable |

    guess := self hgCommand value asNilIfEmpty.
    guess isNil ifTrue:[
        guess := HGCommand hgCommand
    ].
    [ guess notNil and:[ (guess := guess asFilename) exists not ] ] whileTrue:[ 
        | p |

        p := guess directory.
        (p notNil and:[ p pathName = guess pathName ]) ifTrue:[ 
            p := nil.
        ].
        guess := p.
    ].
    guess isNil ifTrue:[ 
        guess := HGCommand hgCommand.
    ].
    executable := Dialog requestFileName:(resources string:'Select hg command') default: guess ifFail:[ ^ self ].
    self infoPanel hide. 
    (executable includes: Character space) ifTrue:[ 
        executable := '"' , executable , '"'.
    ].
    self hgCommand value: executable

    "Created: / 21-02-2014 / 10:13:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-04-2016 / 21:35:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-06-2016 / 21:55:05 / jv"
!

doTestHGCommand

    self hgCommand value isEmptyOrNil ifTrue:[
        self doTestHGCommand: HGCommand hgCommand
    ] ifFalse:[
        self doTestHGCommand: self hgCommand value
    ]

    "Created: / 19-11-2012 / 21:32:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2013 / 04:59:14 / jv"
!

doTestHGCommand: command
    | version versionString |
    (OperatingSystem canExecuteCommand: command) ifFalse:[
        Dialog warn: 'Cannot execute hg command.\\Make sure Metcurial is installed and PATH is set up correctly' withCRs.
        ^self.
    ].

    [
        versionString := OperatingSystem getCommandOutputFrom:('"%1" --version' bindWith:command).
        version := (HGCommandParser on: versionString) parseCommandVersion.

        (HGCommand hgVersionIsSupported:version) ifTrue:[
            Dialog information: ('Installed Mercurial version is OK.\\Reported version: ', versionString) withCRs.
        ] ifFalse:[
            Dialog warn: ('Installed Mercurial is not (yet) supported.\\Reported version: ', versionString) withCRs.
        ].
    ] on: HGCommandError do:[
        Dialog warn: 'Failed to read ''',command,' --version'''.
        ^self
    ].

    "Created: / 19-11-2012 / 21:32:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2013 / 05:12:39 / jv"
! !

!HGSourceCodeManagementSettingsAppl methodsFor:'actions-checks'!

doCheckCommand
    "Check `hg` command. Return true if `hg` command exists
     and of supported version, false otherwise."

    | command |

    command := self hgCommand value.
    command isEmptyOrNil ifTrue:[         
        command := OperatingSystem pathOfCommand:'hg'.
        command isNil ifTrue:[ 
            self infoPanel 
                reset;
                beWarning;
                message: (resources string:'Cannot find path to `hg` command');
                addButtonWithLabel: (self resources string:'Browse') action: [ self doSelectHGCommand ];
                addButtonWithLabel: (self resources string:'Install') action: [ self doInstallHG ];
                show. 
            self hgAvailable value: false.
            ^ false                
        ].
    ].
    [
        HGCommand hgCommandValidate: command 
    ] on: HGInvalidVersionError do:[:ex | 
        self infoPanel 
            reset;
            beWarning;
            message: (resources string:'Unssuported Mercurial version %1' with: (ex parameter asStringWith: $.));
            addButtonWithLabel: (self resources string:'Browse') action: [self infoPanel hide. self doSelectHGCommand ];
            show.            
        self hgAvailable value: false.
        ^ false                            
    ] on: HGCommandError do:[:ex |
        self infoPanel 
            reset;
            beWarning;
            message: (resources string:ex description);
            addButtonWithLabel: (self resources string:'Browse') action: [self infoPanel hide. self doSelectHGCommand ];
            show.            
        self hgAvailable value: false.
        ^ false                            
    ].
    self hgAvailable value: true.
    ^ true.

    "Created: / 21-02-2014 / 09:58:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2016 / 22:23:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCheckMenuLayout
    "Check if browser SCM menu layouyt is not #old. Return true, if yes,
     false otherwise. As a sideffect, show message in info panel"

    IgnoreCheckUsername ifTrue:[ ^ true ].
    (UserPreferences current sourceCodeManagementMenuLayout = #old) ifTrue:[ 
        self infoPanel 
            reset;
            beWarning;
            message: (resources string:'SCM menu layout in set to ''old'' which does not support HG');
            addButtonWithLabel: (self resources string:'Use ''Compact''') action: [
                UserPreferences current sourceCodeManagementMenuLayout: #compact.
                (Dialog confirm: (resources string: 'Settings changed to ''Compact''\\Save settings?') withCRs) ifTrue:[ 
                    SettingsDialog saveSettingsWithoutAskingForFile
                ].
                self doCheckCommand
            ];
            addButtonWithLabel: (self resources string:'Use ''Inline''') action: [
                UserPreferences current sourceCodeManagementMenuLayout: #inline.
                (Dialog confirm: (resources string: 'Settings changed to ''Compact''\\Save settings?') withCRs) ifTrue:[ 
                    SettingsDialog saveSettingsWithoutAskingForFile
                ].
                self doCheckCommand
            ];
            addButtonWithLabel: (resources string:'Ignore') action: [IgnoreCheckUsername := true.  self infoPanel hide.];
            show.
        ^ false
    ].
    ^ true.

    "Created: / 18-02-2014 / 11:46:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2014 / 10:32:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCheckUsername
    "Check if username is configured. Return true, if yes,
     false otherwise. As a sideffect, show message in info panel"

    | username |

    IgnoreCheckUsername ifTrue:[ ^ true ].
    username := HGConfig userConfig ui_username.
    "/ Check for lazy users which only uncomment the line and
    "/ does not bother with filling in proper values. See
    "/ HGConfig userConfigFileTemplate          
    (username isNil or:[username = 'FirstName LastName <Email>']) ifTrue:[ 
        self infoPanel 
            reset;
            beWarning;
            message: (resources string:'Commit author signature not configured');
            addButtonWithLabel: (self resources string:'Edit') action: [self doEditHGRC. self doCheckMenuLayout];
            addButtonWithLabel: (resources string:'Ignore') action: [IgnoreCheckUsername := true. self doCheckMenuLayout];
            show.
        ^ false
    ].
    ^ true.

    "Created: / 18-02-2014 / 11:30:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManagementSettingsAppl methodsFor:'aspects'!

hgAutopush

    hgAutopush isNil ifTrue:[
        hgAutopush := self settingsAspectFor: #hgAutopush
    ].
    ^ hgAutopush

    "Created: / 10-12-2012 / 02:38:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgCommand

    hgCommand isNil ifTrue:[
        hgCommand := self settingsAspectFor: #hgCommand.
        hgCommand onChangeSend: #doCheckSettings to: self.
    ].
    ^ hgCommand

    "Modified: / 23-04-2016 / 22:19:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgDiff2Command

    hgDiff2Command isNil ifTrue:[
        hgDiff2Command := self settingsAspectFor: #hgDiff2Command
    ].
    ^ hgDiff2Command

    "Created: / 19-11-2012 / 21:30:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgDiff3Command

    hgDiff3Command isNil ifTrue:[
        hgDiff3Command := self settingsAspectFor: #hgDiff3Command
    ].
    ^ hgDiff3Command

    "Created: / 19-11-2012 / 21:30:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgEnabled
    hgEnabled isNil ifTrue:[
        hgEnabled := PluggableAdaptor on: self shownInBrowserMenusHolder
            getter:[ :enabled | enabled value and:[ self hgAvailable value] ]
            setter:[ :enabled :value| enabled value: value ]
    ].
    ^ hgEnabled

    "Created: / 21-02-2014 / 10:37:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2016 / 22:40:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgUseSharedRepositories

    hgUseSharedRepositories isNil ifTrue:[
        hgUseSharedRepositories := self settingsAspectFor: #hgUseSharedRepositories
    ].
    ^ hgUseSharedRepositories

    "Created: / 25-08-2015 / 02:06:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgrcAspect
    <resource: #uiAspect>

    hgrcAspect isNil ifTrue:[
        | hgrc |

        hgrc := HGConfig userConfigFile asString asText.
        hgrc actionForAll:[ self doEditHGRC ].
        hgrcAspect := hgrc asValue.
    ].
    ^ hgrcAspect.

    "Modified: / 18-02-2014 / 10:40:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoPanel
    infoPanel isNil ifTrue:[
        infoPanel := Tools::InlineMessageDialog new
    ].
    ^ infoPanel

    "Created: / 09-02-2012 / 19:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2014 / 10:02:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

settings
    ^#(hgCommand hgAutopush hgUseSharedRepositories)

    "Created: / 10-12-2012 / 02:40:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2015 / 02:07:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shownInBrowserMenusHolder
    shownInBrowserMenusHolder isNil ifTrue:[
        shownInBrowserMenusHolder := true asValue.
        shownInBrowserMenusHolder onChangeSend:#updateModifiedChannel to:self.
        shownInBrowserMenusHolder onChangeSend:#doCheckSettings to:self.
    ].
    ^ shownInBrowserMenusHolder.

    "Created: / 18-02-2014 / 10:05:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManagementSettingsAppl methodsFor:'aspects-queries'!

hgAvailable
    hgAvailable isNil ifTrue:[
        hgAvailable := ValueHolder new.
        hgAvailable onChangeSend: #changed to: self shownInBrowserMenusHolder.
    ].
    ^ hgAvailable

    "Modified: / 23-04-2016 / 22:43:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManagementSettingsAppl methodsFor:'help'!

editorHelpRelativeWikiURL
    "the relative URL of the dialog-description in the Wiki"

    ^ 'Settings_HGSourceCodeManagerSettings'
! !

!HGSourceCodeManagementSettingsAppl methodsFor:'helpers'!

settingsAspectFor: settingName

    |holder|

    self createBuilder.

    (holder := builder bindingAt:settingName) isNil ifTrue:[
        holder := (currentUserPrefs perform: settingName asSymbol) asValue.
        holder onChangeSend:#updateModifiedChannel to:self.
        builder aspectAt:settingName put:holder
    ].
    ^ holder.

    "Created: / 25-05-2009 / 18:43:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-12-2011 / 15:13:37 / cg"
! !

!HGSourceCodeManagementSettingsAppl methodsFor:'hooks'!

commonPostOpen
    self doCheckSettings

    "Created: / 18-02-2014 / 10:05:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManagementSettingsAppl methodsFor:'protocol'!

basicReadSettings
    self shownInBrowserMenusHolder value:HGSourceCodeManager shownInBrowserMenus.
    self hgAvailable value: HGCommand isAvailable.
    self readAspects:self settings from:currentUserPrefs

    "Modified: / 23-04-2016 / 22:23:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicSaveSettings
    HGSourceCodeManager shownInBrowserMenus:self shownInBrowserMenusHolder value.
    self writeAspects: self settings to: currentUserPrefs

    "Modified: / 10-12-2012 / 02:40:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

help
    |filename|

    filename := self helpFilename.
    filename isNil ifTrue:[
        self warn:(self resources string:'Sorry - no Help available here.').
        ^ self.
    ].
    self withWaitCursorDo:[
        | file |

        file := (HTMLDocumentView helpFileFor: filename) asFilename.
        file isNil ifTrue:[
            file := (Smalltalk getPackageDirectoryForPackage: self class package) / 'docs' / 'output' / 'html' / 'settings.html'.
        ].
        file exists ifTrue:[
            HTMLDocumentView openDocumentation: file.
        ] ifFalse:[
            self warn:'Missing help file: doc/online/<language>/help/' , filename,'\\You can download missing files from "www.exept.de".' withCRs.
        ]


    ].

    "Created: / 22-01-2013 / 20:39:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

helpFilename
    "subclasses must return the relative name of a helpFile
     in the doc/online/<language>/help directory.
     Or nil, if no help is available."

    ^'HG/settings.html'.

    "
        HGSourceCodeManagementSettingsAppl basicNew help
    "

    "Modified (comment): / 22-01-2013 / 20:37:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManagementSettingsAppl methodsFor:'queries'!

hasUnsavedChanges

    (HGSourceCodeManager shownInBrowserMenus ~= self shownInBrowserMenusHolder value)
        ifTrue:[^ true].

    ^ self hasChangedAspectIn:self settings asComparedTo: currentUserPrefs

    "Modified: / 10-12-2012 / 02:40:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGSourceCodeManagementSettingsAppl class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


HGSourceCodeManagementSettingsAppl initialize!
