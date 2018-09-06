"{ Package: 'stx:libscm/git' }"

AbstractSourceCodeManagementSettingsAppl subclass:#GitSourceCodeManagementSettingsAppl2
	instanceVariableNames:'defaultLogo'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-StX-Interface'
!


!GitSourceCodeManagementSettingsAppl2 class methodsFor:'image specs'!

defaultIcon
    ^ self defaultIcon2

    "Created: / 22-12-2011 / 13:47:11 / cg"
!

defaultIcon1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon1 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GitSourceCodeManagementSettingsAppl class defaultIcon1'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CT5MST5MP@5MST5MST@MST5MST5MP@@@CT5MST5MP@5MST5MST@MST5MST5MP@@@CT5MST5MP@5MST5
MST@MST5MST5@@@@@CT5MST5MP@5MST5MST@MST5MST5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@M#X@@@@@@CX6@@@@@@@6M#X@@@@@@@@@M#X@@@@@@CX6@@@@@@@6M#X@@@@@@CX6M#X6M @6M#X6M#X@M#X6M#X6M @@
@CX6M#X6M @6M#X6M#X@M#X6M#X6M @@@@@@M#X@@@@@@CX6@@@@@@@6M#X@@@@@@@@@M#X@@@@@@CX6@@@@@@@6M#X@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[143 136 136 208 208 208 192 192 184 176 176 176 175 168 168 176 168 168 191 184 184 191 176 176 159 152 144 160 160 160 239 232 224 192 184 184 159 152 160 207 192 200 207 200 200 144 144 144 224 224 224 160 152 160 127 120 120 144 144 136 128 128 128 111 104 104 207 200 208 239 232 240 95 88 88 96 96 96 79 72 80 112 112 120 192 192 200 223 208 208 111 104 96 80 80 80 64 64 64 223 216 216 128 120 128 31 24 24 32 32 24 79 72 64 64 56 56 47 40 40 240 240 240 239 224 224 63 48 48 191 184 176 112 112 104 64 64 56 63 56 56 48 48 48 48 40 48 127 112 120 160 160 168 208 200 208 224 224 216 192 0 0 0 128 0]; mask:((Depth1Image new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@_/78_/78@@@@@@@@@@@@FCA FCA _/78_/78FCA FCA @@@@@@@@@@@@@@@@@@@@@@@@') ; yourself); yourself]
!

defaultIcon2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self defaultIcon2 inspect
     ImageEditor openOnClass:self andSelector:#defaultIcon2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'GitSourceCodeManagementSettingsAppl2 defaultIcon2'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CP4MCP4@CP4MCP4@CP4MCP4@@@@@@@@@C 8NC 8@C 8NC 8@
C 8NC 8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,B@@@@@@,B@@@@@@,B@@@@@@@@@@@@@@,BB0,@
@@,BB0,@@@,BB0,@@@@@@@@@@ HB@ H@@ HB@ H@@ HB@ H@@@@@@@@@B0,BB0H@B0,BB0H@B0,BB0H@@@@@@@@@B0,BB0@@B0,BB0@@B0,BB0@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@HB@TEC0@@@@@@@@@@@@@@@@@@@@@@@@THB@ HAP@@@@@@@@@@@@@@@@@@@@@@@P H@@<@@@T@@@@@@@@@CP4@@@@@
@@@@AP,E@@@@@@@@@@@@@@@@CP4@@@@@@@TEB@\HA @@BP@@@@@@@@@@CP4@@@@@@@@EA0 E@@@IBP$@@@@@@@@@CP4@@@@@@@@@APP@@@$C@00I@@@MCP4M
CP4MCP4M@@@@@@@@@@@JBP$I@@@MCP4MCP4MCP4M@@@I@@<@@@@IBP@@@@@@@@@@CP4@@@@@@@@@BP$IBP$I@@@@@@@@@@@@CP4@@@@@@@@@@@(IBP$@@@@@
@@@@@@@@CP4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CP4@@@@@') ; colorMapFromArray:#[0 0 0 0 64 0 0 128 0 32 32 32 32 64 32 32 96 32 32 128 32 32 128 64 32 160 64 64 64 64 96 96 96 96 192 128 128 128 128 192 0 0 209 87 87 255 255 255]; mask:((Depth1Image new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@>>>@>>>@@@@@@@@@XXX@^^^@>>>@<<<@LLL@@@@A<@@C<@@GR@0G@@0_$@0ON@0F_O?@OO?JL@0G<@0C8@0@@@0') ; yourself); yourself]
!

defaultLogo
    ^ GitIconLibrary gitLogo1

    "Created: / 04-10-2012 / 19:01:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSourceCodeManagementSettingsAppl2 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:GitSourceCodeManagementSettingsAppl2 andSelector:#windowSpec
     GitSourceCodeManagementSettingsAppl2 new openInterface:#windowSpec
     GitSourceCodeManagementSettingsAppl2 open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'SubVersion Settings'
          name: 'SubVersion Settings'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 695 627)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: ' Git Settings'
              name: 'GitSettingsTitle'
              layout: (LayoutFrame 0 0 0 0 0 1 66 0)
              style: (FontDescription helvetica medium roman 18 #'iso10646-1')
              backgroundColor: (Color 100.0 100.0 100.0)
              translateLabel: true
              adjust: left
            )
           (LabelSpec
              label: 'Logo'
              name: 'GitLogo'
              layout: (LayoutFrame -157 1 0 0 0 1 66 0)
              hasCharacterOrientedLabel: false
              backgroundColor: (Color 100.0 100.0 100.0)
              translateLabel: true
              labelChannel: defaultLogo
            )
           (CheckBoxSpec
              label: 'Show in Menus'
              name: 'CheckBox1'
              layout: (LayoutFrame 0 0 73 0 0 1 95 0)
              activeHelpKey: shownInBrowserMenus
              model: shownInBrowserMenusHolder
              translateLabel: true
            )
           )
         
        )
      )
! !

!GitSourceCodeManagementSettingsAppl2 class methodsFor:'queries'!

managerClass
    "backlink to my manager class (needed by the settings app)"

    ^ GitSourceCodeManager2

    "Created: / 19-04-2011 / 12:46:52 / cg"
    "Modified: / 02-10-2012 / 14:30:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSourceCodeManagementSettingsAppl2 methodsFor:'aspects'!

initialListOfModules
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
! !

!GitSourceCodeManagementSettingsAppl2 methodsFor:'protocol'!

basicReadSettings
    self shownInBrowserMenusHolder value:GitSourceCodeManager2 shownInBrowserMenus.

    "Modified: / 06-10-2012 / 17:18:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicSaveSettings
    GitSourceCodeManager2 shownInBrowserMenus:self shownInBrowserMenusHolder value

    "Modified: / 06-10-2012 / 17:18:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

helpFilename
    "subclasses must return the relative name of a helpFile
     in the doc/online/<language>/help directory.
     Or nil, if no help is available."

    ^ self shouldImplement
! !

!GitSourceCodeManagementSettingsAppl2 methodsFor:'queries'!

hasUnsavedChanges

    (GitSourceCodeManager2 shownInBrowserMenus ~= self shownInBrowserMenusHolder value)
        ifTrue:[^ true].

    ^ false

    "Modified: / 14-11-2012 / 19:23:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitSourceCodeManagementSettingsAppl2 class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
