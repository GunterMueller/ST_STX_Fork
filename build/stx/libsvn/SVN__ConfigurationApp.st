"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

AbstractSettingsApplication subclass:#ConfigurationApp
	instanceVariableNames:'currentProfileHolder availableProfilesHolder svnConfigurations2
		svnCurrentConfiguration configurationSelectedHolder
		newConfigurationCount svnCommand'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Configuration'
!

!ConfigurationApp class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
! !

!ConfigurationApp class methodsFor:'help specs'!

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
     UIHelpTool openOnClass:SVN::SettingsApp    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#shownInBrowserMenus
'If checked, the Systembrowser includes operations for me in its SCM menus.'

#Package
''

)

    "Modified: / 26-05-2008 / 14:24:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 11-01-2012 / 15:42:09 / cg"
! !

!ConfigurationApp class methodsFor:'image specs'!

defaultIcon
    ^ self svnRepositoryIcon24x24
"/    ^SVN::IconLibrary svn_wizban2 magnifiedTo: 24@24

    "Created: / 26-05-2008 / 14:55:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 15-01-2012 / 10:16:06 / cg"
!

svnIcon
    ^ IconLibrary svn_wizban

    "Created: / 24-05-2008 / 01:44:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnIcon16x16
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self svnIcon16x16 inspect
     ImageEditor openOnClass:self andSelector:#svnIcon16x16
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::ConfigurationApp svnIcon16x16'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
B0,KB0,KB0,KB0,KB0,KB0,VQ%1+[WQ5]WU/[*?$8 ,JK4I[Z7E4\7BR8/+:88(KB"<0R&M*6_+:9I%(X4(.B0\/JDGK>/+] GM3Z5,.K ,GL+_3?/*J[7Q-
\VMJLB8KB;?9?/X>VE1^YF>G*L&?B0/>?/;:(J>=5N+:?/;>? ,K?/;>?/;>?/;:>./6?/8KB7J?>./R+8](R343O_[>B0-2\$,7H" -K"8.K#O:? ,ITR8.
K"8.K#@(O-'':>+<KBS@.K"80LC@4(O+63D@(B0&DK"8.LFCT>/OHJ2 .K ,ISZW4>/+HUBD0K"8.K"8KB0,KB0,KB0,KB0,KB0,KB0@a') ; colorMapFromArray:#[108 123 153 104 127 155 106 126 161 108 127 162 103 128 168 97 130 169 113 128 158 112 131 154 116 131 149 119 130 155 116 131 162 112 135 164 115 134 170 116 135 158 125 133 152 124 135 160 125 137 150 120 138 162 114 139 180 114 142 176 122 141 165 121 141 177 118 142 184 120 144 173 131 143 156 128 143 174 121 145 186 125 145 181 133 144 169 123 147 189 117 149 189 135 146 171 126 150 179 127 151 193 131 151 187 125 153 187 143 151 159 136 151 182 141 152 165 134 153 177 129 153 195 123 156 196 126 155 202 128 156 191 135 154 191 130 155 197 127 156 204 125 158 198 132 156 198 121 159 205 137 156 193 131 159 194 142 157 188 135 159 201 140 159 196 138 161 191 152 160 168 152 159 180 146 161 180 142 161 198 138 162 204 146 161 192 136 164 199 132 165 205 141 165 194 147 166 190 142 166 209 151 166 197 145 168 198 147 167 204 142 169 205 156 168 181 163 167 182 151 170 194 146 170 212 148 171 201 151 170 207 155 170 202 158 170 196 157 172 191 154 174 211 148 176 211 168 174 176 153 176 206 156 176 200 166 174 194 152 176 219 164 175 202 161 176 208 162 177 197 152 180 216 159 178 216 157 180 211 161 180 205 164 179 211 172 180 189 166 181 200 169 181 194 161 181 218 160 183 214 164 183 208 166 182 214 177 181 197 171 182 209 166 185 210 168 184 216 177 184 205 170 185 218 174 186 200 164 188 218 172 187 206 168 188 213 175 186 213 172 187 219 177 188 215 171 190 215 167 191 221 174 189 221 184 190 192 179 191 204 176 192 211 183 190 212 180 192 206 173 193 218 166 194 231 187 192 207 182 194 221 176 196 221 181 196 216 185 196 210 187 195 216 180 196 228 178 197 236 174 198 242 192 197 200 180 199 225 193 198 201 196 198 195 184 200 220 188 200 227 189 201 215 187 202 222 185 204 229 198 203 205 205 202 207 196 203 225 190 205 225 198 206 214 200 205 220 189 208 234 196 207 234 208 206 210 200 208 216 197 209 223 195 210 230 207 209 206 204 210 212 202 209 231 211 209 213 209 211 208 200 212 226 209 210 220 212 211 202 206 212 214 210 212 209 194 214 239 213 212 203 205 213 221 198 214 234 203 215 229 215 213 217 201 216 236 210 214 230 216 215 206 207 215 236 206 218 233 217 217 228 215 220 223 206 221 241 215 219 235 220 220 211 218 220 217 212 221 229 210 222 236 214 221 243 219 223 239 214 226 240 217 225 246 225 227 223 219 228 236 222 228 230 217 229 243 224 229 232 229 229 219 224 228 244 227 229 226 221 229 251 225 230 233 216 232 252 226 230 246 220 232 246 223 232 240 227 231 247 228 232 248 222 234 248 229 234 237 235 234 224 226 235 243 233 233 244 230 234 250 225 237 252 235 237 234 229 238 246 236 236 247 223 240 246 232 238 240 239 236 241 231 239 248 239 239 229 232 240 249 238 239 249 233 241 250 236 241 244 230 242 255 239 242 238 240 241 252 234 243 251 242 243 253 236 245 253 239 245 247 237 246 255 244 244 255 248 247 237 248 246 250 243 248 251 241 249 255 250 247 252 244 249 252 238 251 252 247 249 246 245 250 253 248 250 247 252 249 254 246 251 254 240 253 254 253 251 255 247 253 255 242 255 255 251 253 250 254 252 255 248 254 255 255 253 251 255 253 255 249 255 255 254 255 252]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'??????????????????????????????????????????<b') ; yourself); yourself]
!

svnRepositoryIcon24x24
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self svnRepositoryIcon24x24 inspect
     ImageEditor openOnClass:self andSelector:#svnRepositoryIcon24x24
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'SVN::ConfigurationApp svnRepositoryIcon24x24'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 24; photometric:(#palette); bitsPerSample:(#[8]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@PDA@PDA@PDA@PDA@PDA@P@@@@@@@@@@@PEGBX0L#$:N#(4L4%ZVDD@@@@@@@@@@@LPF2T0M#$8MTIXX&IYP@P@@@@@@@@@@@LPDQ8+K5Y"
X%)DK",^C0P@@@@@@@@@@@DPCA)OX&IWOS 8LBTOC0P@@@@@@@@@@@DRR%9#X$@4NSH6J18QC0P@@@@@@@@@@DE#XVM FBP&I204O4!!NUTD@@@@@@@@@@DU#
X6M"Q$%KUE1"X6M#X4D@@@@@@@@@@DU*Z&5-X6M#X6I"WVA#X4D@@@@@@@@@@F5*Z&)*[T$?K!!<WD1] X4D@@@@@@@@@Y&)*M1<UB64NC0<OC1M"X4D@@@@@
@@@@[VU-C0<OC0<ODP0XU&I"S@D@@@@@@F5-Z&9*Z@<OZQDQEDY"XE@YC@D@@@@@@@A-[&)-C0=)ZV%TX%9MCP0OC0D@@@@@@@@@[V\ Q6%,[F-)B!!DOC0<O
C0D@@@@@@@@@@@DAZV%/ZV%)@PDA@PDA@PD@@@@@@@A)@@@@@@A)ZP@@@@@@@@@@@@@@@@@@@@@@ZV%)ZV%)Y@@@@@@@@@@@@@@@@@@@@@@@@F=)ZV%$@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[108 123 153 112 131 154 119 130 155 116 131 162 112 135 164 118 142 184 128 143 174 121 145 186 123 147 189 117 149 189 127 151 193 131 151 187 129 153 195 128 156 191 130 155 197 127 156 204 125 158 198 132 156 198 137 156 193 131 159 194 142 157 188 138 161 191 142 161 198 146 161 192 136 164 199 141 165 194 147 166 190 142 166 209 142 169 205 156 168 181 146 170 212 148 171 201 155 170 202 157 172 191 148 176 211 156 176 200 161 176 208 159 178 216 157 180 211 164 179 211 172 180 189 166 181 200 169 181 194 160 183 214 164 183 208 177 181 197 166 185 210 177 184 205 170 185 218 174 186 200 164 188 218 172 187 206 168 188 213 175 186 213 172 187 219 177 188 215 171 190 215 167 191 221 174 189 221 184 190 192 179 191 204 181 196 216 178 197 236 180 199 225 184 200 220 205 202 207 190 205 225 208 206 210 197 209 223 207 209 206 200 212 226 194 214 239 198 214 234 206 218 233 210 222 236 219 228 236 217 229 243 220 232 246 223 232 240 228 232 248 222 234 248 229 234 237 233 233 244 225 237 252 229 238 246 232 238 240 231 239 248 233 241 250 234 243 251 242 243 253 236 245 253 239 245 247 243 248 251 241 249 255 246 251 254 240 253 254 247 253 255 254 252 255 248 254 255 254 255 252 0 0 0 96 192 128 0 64 0 32 64 32 32 128 32 64 64 64 32 160 64 128 128 128 32 32 32 32 96 32 32 128 64 96 96 96]; mask:((Depth1Image new) width: 24; height: 24; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@C??0C??0C??0C??0C??0C??0C??0C??0C??0C??0G??0G??0_??0O??0G??0C??0HL@@G<@@C8@@@@@@') ; yourself); yourself]
! !

!ConfigurationApp class methodsFor:'interface opening'!

open    

    | settingsApp |

    settingsApp := SettingsDialog new.
    settingsApp addApplClass:self fullName
                withName:'Subversion'.
    settingsApp showRoot: false.
    settingsApp selectedItem value:
        (settingsApp applicationList root children anyOne).
    settingsApp open.

    "Created: / 26-05-2008 / 12:17:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-02-2010 / 17:07:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurationApp class methodsFor:'interface specs'!

basicTabSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::ConfigurationApp andSelector:#basicTabSpec
     SVN::ConfigurationApp new openInterface:#basicTabSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: basicTabSpec
        window: 
       (WindowSpec
          label: 'Basic Settings'
          name: 'Basic Settings'
          bounds: (Rectangle 0 0 632 489)
        )
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
                    name: 'RepositorySettings'
                    initiallyInvisible: true
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Repositories:'
                          name: 'CurrentProfileLabel'
                          layout: (LayoutFrame 0 0 0 0 120 0 30 0)
                          translateLabel: true
                          adjust: leftRight
                          useDynamicPreferredWidth: true
                          usePreferredWidth: true
                        )
                       (ComboListSpec
                          name: 'CurrentConfiguration'
                          layout: (LayoutFrame 120 0 3 0 -2 1 29 0)
                          model: svnCurrentConfiguration
                          comboList: svnConfigurations2
                          useIndex: false
                        )
                       (LabelSpec
                          label: 'Working Copy:'
                          name: 'WorkingCopyBaseLabel'
                          layout: (LayoutFrame 0 0 60 0 120 0 90 0)
                          initiallyInvisible: true
                          translateLabel: true
                          adjust: leftRight
                        )
                       (FilenameInputFieldSpec
                          name: 'WorkingCopyBase'
                          layout: (LayoutFrame 120 0 63 0 0 1 88 0)
                          initiallyInvisible: true
                          initiallyDisabled: true
                          enableChannel: svnEnabled
                          model: workingCopyBaseAspect
                          modifiedChannel: modifiedChannel
                          acceptOnPointerLeave: false
                          viewClassName: 'FilenameWidgetWithHistory'
                          postBuildCallback: postBuildWorkingCopyField:
                        )
                       (ActionButtonSpec
                          label: 'Edit'
                          name: 'ButtonEdit'
                          layout: (LayoutFrame -100 1 32 0 0 1 54 0)
                          translateLabel: true
                          model: doConfigurationEditCurrent
                        )
                       )
                     
                    )
                    extent: (Point 611 90)
                  )
                 (ViewSpec
                    name: 'RepositorySettingsConfigButtonOnly'
                    component: 
                   (SpecCollection
                      collection: (
                       (ActionButtonSpec
                          label: 'Configure Repositories'
                          name: 'Button1'
                          layout: (LayoutFrame 5 0 5 0 -5 1 -5 1)
                          translateLabel: true
                          model: doConfigurationEditCurrent
                          enableChannel: svnEnabled
                        )
                       )
                     
                    )
                    extent: (Point 632 35)
                  )
                 (FramedBoxSpec
                    label: 'SubVersion'
                    name: 'SubVersionSettings'
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Command:'
                          name: 'SVNCommandLabel'
                          layout: (LayoutFrame 0 0 0 0 80 0 30 0)
                          translateLabel: true
                          adjust: left
                        )
                       (FilenameInputFieldSpec
                          name: 'SVNCommand'
                          layout: (LayoutFrame 80 0 3 0 -50 1 28 0)
                          enableChannel: svnEnabled
                          model: svnCommand
                          acceptOnPointerLeave: true
                          emptyFieldReplacementText: 'Autodetect'
                        )
                       (ActionButtonSpec
                          label: 'Test'
                          name: 'SVNCommandTest'
                          layout: (LayoutFrame -50 1 3 0 0 1 28 0)
                          translateLabel: true
                          model: doTestSVNCommand
                          enableChannel: svnEnabled
                        )
                       )
                     
                    )
                    extent: (Point 632 80)
                    useDynamicPreferredHeight: true
                    usePreferredHeight: true
                  )
                 (FramedBoxSpec
                    label: 'External Tools'
                    name: 'ToolsSettings'
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Diff2:'
                          name: 'Label1'
                          layout: (LayoutFrame 0 0 0 0 80 0 30 0)
                          translateLabel: true
                          adjust: left
                        )
                       (FilenameInputFieldSpec
                          name: 'FilenameEntryField1'
                          layout: (LayoutFrame 80 0 3 0 0 1 28 0)
                          enableChannel: svnEnabled
                          model: svnDiff2Command
                          acceptOnPointerLeave: true
                        )
                       (LabelSpec
                          label: 'Diff3:'
                          name: 'Label2'
                          layout: (LayoutFrame 0 0 30 0 80 0 0 1.0)
                          translateLabel: true
                          adjust: left
                        )
                       (FilenameInputFieldSpec
                          name: 'FilenameEntryField2'
                          layout: (LayoutFrame 80 0 33 0 0 1 58 0)
                          enableChannel: svnEnabled
                          model: svnDiff3Command
                          acceptOnPointerLeave: true
                        )
                       )
                     
                    )
                    extent: (Point 632 95)
                  )
                 (FramedBoxSpec
                    label: 'Debugging'
                    name: 'DebugSettings'
                    labelPosition: topLeft
                    translateLabel: true
                    component: 
                   (SpecCollection
                      collection: (
                       (VerticalPanelViewSpec
                          name: 'VerticalPanel1'
                          layout: (LayoutFrame 0 0 0 0 0 1 0 1)
                          horizontalLayout: fit
                          verticalLayout: top
                          horizontalSpace: 3
                          verticalSpace: 3
                          component: 
                         (SpecCollection
                            collection: (
                             (CheckBoxSpec
                                label: 'Verbose (Traces svn commands to Transcript)'
                                name: 'Verbose'
                                enableChannel: svnEnabled
                                model: svnVerbose
                                translateLabel: true
                                useDefaultExtent: true
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                    extent: (Point 632 60)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

profilesTabSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::ConfigurationApp andSelector:#profilesTabSpec
     SVN::ConfigurationApp new openInterface:#profilesTabSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: profilesTabSpec
        window: 
       (WindowSpec
          label: 'Profiles'
          name: 'Profiles'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 782 552)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Current profile:'
              name: 'CurrentProfileLabel'
              layout: (LayoutFrame 0 0 0 0 102 0 30 0)
              translateLabel: true
              adjust: leftRight
              useDynamicPreferredWidth: true
              usePreferredWidth: true
            )
           (ComboListSpec
              name: 'CurrentConfiguration'
              layout: (LayoutFrame 103 0 3 0 0 1 28 0)
              enableChannel: svnEnabled
              model: svnCurrentConfiguration
              comboList: svnConfigurations2
              useIndex: false
            )
           (DividerSpec
              name: 'Separator1'
              layout: (LayoutFrame 0 0 30 0 0 1 35 0)
            )
           (LabelSpec
              label: 'Available profiles:'
              name: 'AvailableProfiles'
              layout: (LayoutFrame 0 0 35 0 0 1 65 0)
              translateLabel: true
              adjust: left
            )
           (SelectionInListModelViewSpec
              name: 'ProfileList'
              layout: (LayoutFrame 0 0 65 0 -100 1 0 1)
              enableChannel: svnEnabled
              model: selectedProfileIndexHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: svnConfigurations2
              highlightMode: line
              doubleClickSelector: doConfigurationEdit
            )
           (VerticalPanelViewSpec
              name: 'Buttons1'
              layout: (LayoutFrame -95 1 65 0 0 1 0 0.7)
              horizontalLayout: fit
              verticalLayout: top
              horizontalSpace: 5
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Add'
                    name: 'ButtonAdd'
                    translateLabel: true
                    model: doConfigurationAdd
                    enableChannel: svnEnabled
                    extent: (Point 95 22)
                  )
                 (ActionButtonSpec
                    label: 'Remove'
                    name: 'ButtonRemove'
                    translateLabel: true
                    model: doConfigurationRemove
                    enableChannel: configurationSelectedHolder
                    extent: (Point 95 22)
                  )
                 (ActionButtonSpec
                    label: 'Edit'
                    name: 'ButtonEdit'
                    translateLabel: true
                    model: doConfigurationEdit
                    enableChannel: configurationSelectedHolder
                    extent: (Point 95 22)
                  )
                 )
               
              )
            )
           (VerticalPanelViewSpec
              name: 'Buttons2'
              layout: (LayoutFrame -95 1 0 0.7 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: bottom
              horizontalSpace: 5
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Export'
                    name: 'Button2'
                    translateLabel: true
                    model: doConfigurationExport
                    enableChannel: configurationSelectedHolder
                    extent: (Point 95 22)
                  )
                 (ActionButtonSpec
                    label: 'Import'
                    name: 'Button3'
                    translateLabel: true
                    model: doConfigurationImport
                    enableChannel: svnEnabled
                    extent: (Point 95 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::ConfigurationApp andSelector:#windowSpec
     SVN::ConfigurationApp new openInterface:#windowSpec
     SVN::ConfigurationApp open
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
              label: ' Subversion Settings'
              name: 'SubVersionSettingsTitle'
              layout: (LayoutFrame 0 0 0 0 0 1 66 0)
              style: (FontDescription helvetica medium roman 18 #'iso10646-1')
              backgroundColor: (Color 100.0 100.0 100.0)
              translateLabel: true
              adjust: left
            )
           (LabelSpec
              label: 'Icon'
              name: 'SubVersionIcon'
              layout: (LayoutFrame -75 1 0 0 0 1 66 0)
              hasCharacterOrientedLabel: false
              backgroundColor: (Color 100.0 100.0 100.0)
              translateLabel: true
              labelChannel: svnIcon
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
                    name: 'SVNEnabledAndResetPanel'
                    horizontalLayout: rightSpaceFit
                    verticalLayout: fit
                    horizontalSpace: 0
                    verticalSpace: 3
                    component: 
                   (SpecCollection
                      collection: (
                       (CheckBoxSpec
                          label: 'Enable SubVersion Manager'
                          name: 'Enabled'
                          model: svnEnabled
                          translateLabel: true
                          extent: (Point 521 30)
activeHelpKey: shownInBrowserMenus
                        )
                       (ActionButtonSpec
                          label: 'Reset cached repositories'
                          name: 'ResetCachedRepositoriesButton'
                          translateLabel: true
                          model: resetCachedRepositories
                          enableChannel: svnEnabled
                          extent: (Point 175 30)
                        )
                       )
                     
                    )
                    extent: (Point 695 30)
                  )
                 (NoteBookViewSpec
                    name: 'NoteBook'
                    menu: tabList
                    useDefaultExtent: true
                  )
                 )
               
              )
            )
           )
         
        )
      )

    "Modified (format): / 11-01-2012 / 15:42:32 / cg"
! !

!ConfigurationApp class methodsFor:'list specs'!

tabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass: self andSelector:#tabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'Settings'
          minorKey: basicTabSpec
          createNewBuilder: false
        )
       (TabItem
          label: 'Profiles'
          minorKey: profilesTabSpec
          createNewBuilder: false
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]
! !

!ConfigurationApp class methodsFor:'queries'!

managerTypeName

    ^(Smalltalk at:#SVNSourceCodeManager) managerTypeName

    "Created: / 07-07-2011 / 23:13:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2012 / 19:11:50 / cg"
! !

!ConfigurationApp class methodsFor:'tableColumns specs'!

configurationListColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:SVN::SettingsApp andSelector:#configurationListColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         activeHelpKey: ''
         labelButtonType: Button
         rendererType: rowSelector
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'Package'
         labelAlignment: left
         activeHelpKey: ''
         labelButtonType: Button
         model: package
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      (DataSetColumnSpec
         label: 'URL'
         labelAlignment: left
         activeHelpKey: ''
         labelButtonType: Button
         model: urlString
         canSelect: false
         showRowSeparator: false
         showColSeparator: false
       )
      )

    "Modified: / 16-08-2009 / 17:28:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ConfigurationApp methodsFor:'accessing'!

repositoryConfiguration

    ^ self repositoryConfigurationAspect value

    "Created: / 26-05-2008 / 12:04:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 19-08-2011 / 12:57:10 / cg"
!

repositoryConfiguration: anObject

    self repositoryConfigurationAspect value: anObject

    "Created: / 26-05-2008 / 12:12:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repositoryConfigurationList

    ^self repositoryConfigurationListAspect value

    "Created: / 26-05-2008 / 12:05:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repositoryManager

    ^RepositoryManager current

    "Created: / 26-05-2008 / 10:46:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectedConfiguration

    | index config |
    (index := self selectedProfileIndexHolder value) ifNil:[^self].
    config := self svnConfigurations2 value at: index.
    ^config

    "Created: / 25-03-2010 / 16:44:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopyBase

    ^self workingCopyBaseAspect value

    "Created: / 26-05-2008 / 13:15:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ConfigurationApp methodsFor:'actions'!

doConfigurationAdd
    <resource: #uiCallback>
    |config|

    config := SVN::Configuration new.
    config name:((newConfigurationCount == 0) 
                ifTrue:[ '<new profile>' ]
                ifFalse:[ '<new profile %1>' bindWith:newConfigurationCount ]).
    (self doConfigurationEdit:config) ifTrue:[
        self doConfigurationAdd:config.
        newConfigurationCount := newConfigurationCount + 1.
    ].

    "Modified: / 26-03-2010 / 20:34:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doConfigurationAdd:config 
    self svnConfigurations2 
        value:(self svnConfigurations2 value copyWith:config).
    self selectedProfileIndexHolder value:self svnConfigurations2 value size.
    self updateModifiedChannel.

    "Modified: / 26-03-2010 / 20:38:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doConfigurationEdit

    | config |

    (config := self selectedConfiguration) ifNil:[^self].
    self doConfigurationEdit: config.

    "Modified: / 25-03-2010 / 16:45:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doConfigurationEdit:config
    | configToEdit |

    configToEdit := config deepCopy.

    ^ (ConfigurationDialog openOn:configToEdit) ifTrue:[
        config name: configToEdit name.
        config repositories: configToEdit repositories.

"/        self svnCurrentConfiguration value:(svnConfigurations2 value 
"/                    detect:[:c | c name = self svnCurrentConfiguration value name ]).
        self updateModifiedChannel.
        true
    ] ifFalse:[ 
        false 
    ]

    "Created: / 25-03-2010 / 08:28:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-10-2012 / 16:18:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doConfigurationEditCurrent

    self doConfigurationEdit: self svnCurrentConfiguration value

    "Modified: / 17-02-2012 / 01:18:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doConfigurationExport

    | config name s |
    config := self selectedConfiguration.
    name := (Smalltalk::Dialog 
                requestFileName:'Enter a filename' 
                default: (config name) , '.rc'
                ifFail:[^self]) asFilename.
    [s := name writeStream.
     config literalArrayEncoding storeOn: s]
        ensure:[s close].

    "Modified: / 26-03-2010 / 20:22:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doConfigurationImport

    | config name |
    config := self selectedConfiguration.
    name := (Smalltalk::Dialog 
                requestFileName:'Enter a filename' 
                pattern: '*.rc').
    name isNilOrEmptyCollection ifTrue:[^self].
    name := name asFilename.
    [
        config := Compiler evaluate: name contents asString.
        config := config decodeAsLiteralArray.
        (config isKindOf: SVN::Configuration) ifFalse:
            [self error:'File does not contain serialized SVN configuration'].
        self doConfigurationAdd: config.
    ] on: Smalltalk::Error do:
    [:ex|
        Smalltalk::Dialog warn: 
            ('Failed to read profile from %1' bindWith: name asString).
        ex pass.
    ]

    "Modified: / 26-03-2010 / 20:36:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doConfigurationRemove

    | config |

    (config := self selectedConfiguration) ifNil:[^self].
    self svnConfigurations2 value: (self svnConfigurations2 value copyWithout: config).
    self updateModifiedChannel.

    "Modified: / 26-03-2010 / 20:39:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doTestSVNCommand

    self svnCommand value isEmptyOrNil ifTrue:[
        self doTestSVNCommand: SVN::Command executable
    ] ifFalse:[
        self doTestSVNCommand: self svnCommand value
    ]

    "Modified: / 12-03-2012 / 11:34:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doTestSVNCommand: command
    | versionString |
    (OperatingSystem canExecuteCommand: command) ifFalse:[        
        Dialog warn: 'Cannot execute svn command.\\Make sure SubVersion is installed and PATH is set up correctly' withCRs.
        ^self.
    ].

    versionString := OperatingSystem getCommandOutputFrom:command, ' --version'.
    versionString isEmptyOrNil ifTrue:[
        Dialog warn: 'Failed to execute ''',command,' --version'''.
        ^self
    ].

    (versionString includesString: '1.7.') ifTrue:[
        Dialog warn: ('Installed Subversion version seems to be 1.7.x.\Subversion 1.7.x is not (yet) supported - it may or may not work.\\Reported version: ', versionString) withCRs.
    ] ifFalse:[
        Dialog information: ('Subversion command seems work\\Reported version: ', versionString) withCRs.
    ]

    "Created: / 12-03-2012 / 11:34:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildWorkingCopyField: aView

    aView 
        directoriesOnly: true;
        historyList: Smalltalk packagePath

    "Modified: / 27-11-2009 / 13:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resetCachedRepositories

    RepositoryManager reset

    "Created: / 20-03-2009 / 10:30:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2009 / 22:53:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ConfigurationApp methodsFor:'aspects'!

aspects
    ^ #( #svnEnabled #svnVerbose  svnCommand svnDiff2Command  svnDiff3Command)

    "Modified: / 18-10-2012 / 16:18:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

configurationSelectedHolder
    "return/create the valueHolder 'repositorySelectedHolder'"

    configurationSelectedHolder isNil ifTrue:[
        configurationSelectedHolder := 
            BlockValue 
                with:[:model|model value notNil and:[model value ~= 0]]
                argument: self selectedProfileIndexHolder
    ].
    ^ configurationSelectedHolder

    "Created: / 25-03-2010 / 08:27:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedProfileIndexHolder

    |holder|

    (holder := builder bindingAt:#selectedProfileIndexHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#selectedProfileIndexHolder put:holder.
    ].
    ^ holder.

    "Created: / 09-03-2010 / 13:30:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnCommand

    svnCommand isNil ifTrue:[
        svnCommand := self settingsAspectFor: #svnCommand
    ].
    ^ svnCommand

    "Modified: / 17-02-2012 / 01:32:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 12-03-2012 / 11:20:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnConfigurations2
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    svnConfigurations2 isNil ifTrue:[
        svnConfigurations2 := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       svnConfigurations2 addDependent:self.
"/       svnConfigurations2 onChangeSend:#svnConfigurations2Changed to:self.
    ].
    ^ svnConfigurations2.
!

svnCurrentConfiguration
    ^self settingsAspectFor: #svnCurrentConfiguration

    "Modified: / 31-03-2011 / 14:01:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnDiff2Command

    ^self settingsAspectFor: #svnDiff2Command

    "Modified: / 17-02-2012 / 01:32:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnDiff3Command

    ^self settingsAspectFor: #svnDiff3Command

    "Modified: / 17-02-2012 / 01:32:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnEnabled

    ^self settingsAspectFor: #svnEnabled

    "Created: / 25-05-2009 / 18:48:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnIcon

    ^self class svnIcon

    "Created: / 24-05-2008 / 01:44:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnVerbose

    ^self settingsAspectFor: #svnVerbose

    "Created: / 25-05-2009 / 19:10:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

tabList
    "Generated by the TabListEditor"

    |list|

    (list := builder bindingAt:#tabList) isNil ifTrue:[
        builder aspectAt:#tabList put:(list := self class tabList).
    ].
    ^ list
!

workingCopyBaseAspect

    |holder|

    (holder := builder bindingAt:#workingCopyBaseAspect) ifNil:[
        holder := self repositoryManager workingCopyBase asValue.
        holder onChangeSend:#updateModifiedChannel to:self.
        builder aspectAt:#workingCopyBaseAspect put: holder
    ].
    ^ holder.

    "Created: / 26-05-2008 / 10:41:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-05-2009 / 18:50:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ConfigurationApp methodsFor:'helpers'!

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

!ConfigurationApp methodsFor:'initialization'!

initialize

    super initialize.
    newConfigurationCount := 1.

    "Created: / 25-03-2010 / 08:31:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurationApp methodsFor:'protocol'!

basicReadSettings

    | configurations current |

    self readAspects: self aspects from:currentUserPrefs.
    self readConfigurations.

    "Created: / 19-04-2008 / 09:42:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-05-2009 / 19:05:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-10-2012 / 12:32:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicSaveSettings

    | configurations current |

    self writeAspects: self aspects to:currentUserPrefs.

    configurations := self svnConfigurations2 value asArray.
    current := self svnCurrentConfiguration value.
    self assert: (configurations includesIdentical: current).

    SVN::Configuration configurations: configurations.
    SVN::Configuration current: current.

    self readConfigurations.
    self resetCachedRepositories

    "Created: / 19-04-2008 / 09:42:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-05-2009 / 19:06:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-10-2012 / 12:32:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

helpFilename
    "return the name of a helpFile in the doc/online/<language>/help directory.
     Or nil, if no help is available."

    ^ 'Launcher/svnSetup.html'

    "Created: / 19-04-2008 / 09:42:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-05-2008 / 13:12:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-12-2011 / 14:02:05 / cg"
!

readConfigurations

    | configurations current |

    configurations := SVN::Configuration configurations deepCopy asList.
    current := configurations 
        detect:[:e|e name = Configuration current name] 
        ifNone:[self error:'Internal inconsistency'].

    self svnConfigurations2 value: configurations.
    self svnCurrentConfiguration value: current.

    "Created: / 22-10-2012 / 12:32:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurationApp methodsFor:'queries'!

hasUnsavedChanges

    | currentConfs editedConfs |
    currentConfs := SVN::Configuration configurations.
    editedConfs := svnConfigurations2 value.

    currentConfs size ~~ editedConfs size ifTrue:[ ^ true ].
    currentConfs with: editedConfs do:[:current :edited|
        self assert: current ~~ edited.
        current = edited ifFalse:[ ^ true ].
    ].

    ^ self 
        hasChangedAspectIn:self aspects 
        asComparedTo:currentUserPrefs

    "Created: / 28-05-2008 / 07:33:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:07:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-11-2011 / 15:25:06 / cg"
    "Modified: / 29-03-2012 / 14:26:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurationApp class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN

    ^ '§Id: SVN__ConfigurationApp.st 372 2011-09-29 10:47:58Z vranyj1 §'
! !
