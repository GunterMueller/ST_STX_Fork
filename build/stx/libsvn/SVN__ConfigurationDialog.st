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

Dialog subclass:#ConfigurationDialog
        instanceVariableNames:'configurationHolder repositoryIndexHolder repositoryListHolder
                nameHolder repositorySelectedHolder'
        classVariableNames:''
        poolDictionaries:''
        category:'SVN-UI-Configuration'
!

!ConfigurationDialog class methodsFor:'documentation'!

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

!ConfigurationDialog class methodsFor:'instance creation'!

on: config

    ^self new 
        configuration: config;
        yourself

    "Created: / 09-03-2010 / 13:33:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurationDialog class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::ConfigurationDialog andSelector:#contentSpec
     SVN::ConfigurationDialog new openInterface:#contentSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: contentSpec
        window: 
       (WindowSpec
          label: 'Content Spec'
          name: 'Content Spec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 653 371)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Name:'
              name: 'ProfileNameLabel'
              layout: (LayoutFrame 0 0 0 0 60 0 30 0)
              translateLabel: true
              adjust: left
            )
           (InputFieldSpec
              name: 'ProfileName'
              layout: (LayoutFrame 60 0 5 0 0 1 25 0)
              model: nameHolder
              immediateAccept: true
              acceptOnReturn: true
              acceptOnTab: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: true
            )
           (DividerSpec
              name: 'Separator'
              layout: (LayoutFrame 0 0 30 0 0 1 35 0)
            )
           (TransparentBoxSpec
              name: 'Box'
              layout: (LayoutFrame 0 0 36 0 0 1 0 1)
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Repository Settings:'
                    name: 'RepositorySettingsLabel'
                    layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                    translateLabel: true
                    adjust: left
                  )
                 (DataSetSpec
                    name: 'RepositoryTable'
                    layout: (LayoutFrame 0 0 30 0 -100 1 0 1)
                    model: repositoryIndexHolder
                    menu: buttonMenu
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    dataList: repositoryListHolder
                    doubleClickSelector: doRepositoryEdit
                    columns: 
                   (Array
                      
                     (DataSetColumnSpec
                        label: 'Package'
                        labelAlignment: left
                        labelButtonType: Button
                        width: 0.3
                        model: package
                        canSelect: false
                        showRowSeparator: false
                        showColSeparator: false
                      ) 
                     (DataSetColumnSpec
                        label: 'URL'
                        labelAlignment: left
                        labelButtonType: Button
                        model: url
                        canSelect: false
                        showRowSeparator: false
                        showColSeparator: false
                      )
                    )
                  )
                 (VerticalPanelViewSpec
                    name: 'Buttons1'
                    layout: (LayoutFrame -95 1 30 0 -5 1 0 0.7)
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
                          model: doRepositoryAdd
                          extent: (Point 90 22)
                        )
                       (ActionButtonSpec
                          label: 'Remove'
                          name: 'ButtonRemove'
                          translateLabel: true
                          model: doRepositoryRemove
                          enableChannel: repositorySelectedHolder
                          extent: (Point 90 22)
                        )
                       (ActionButtonSpec
                          label: 'Edit'
                          name: 'ButtonEdit'
                          translateLabel: true
                          model: doRepositoryEdit
                          enableChannel: repositorySelectedHolder
                          extent: (Point 90 22)
                        )
                       (ActionButtonSpec
                          label: 'Move up'
                          name: 'ButtonModeUp'
                          translateLabel: true
                          model: doRepositoryMoveUp
                          enableChannel: repositorySelectedHolder
                          extent: (Point 90 22)
                        )
                       (ActionButtonSpec
                          label: 'Move down'
                          name: 'ButtonModeDown'
                          translateLabel: true
                          model: doRepositoryMoveDown
                          enableChannel: repositorySelectedHolder
                          extent: (Point 90 22)
                        )
                       )
                     
                    )
                  )
                 (VerticalPanelViewSpec
                    name: 'Buttons2'
                    layout: (LayoutFrame -95 1 0 0.7 -5 1 0 1)
                    horizontalLayout: fit
                    verticalLayout: bottom
                    horizontalSpace: 5
                    verticalSpace: 3
                    component: 
                   (SpecCollection
                      collection: (
                       (ActionButtonSpec
                          label: 'Snapshot'
                          name: 'Button2'
                          translateLabel: true
                          model: doSnapshot
                          extent: (Point 90 22)
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

!ConfigurationDialog class methodsFor:'menu specs'!

buttonMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SVN::ConfigurationDialog andSelector:#buttonMenu
     (Menu new fromLiteralArrayEncoding:(SVN::ConfigurationDialog buttonMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Add'
            itemValue: doRepositoryAdd
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' iconPlus 'Add')
          )
         (MenuItem
            enabled: repositorySelectedHolder
            label: 'Remove'
            itemValue: doRepositoryRemove
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' iconMinus 'Remove')
          )
         (MenuItem
            enabled: repositorySelectedHolder
            label: 'Edit'
            itemValue: doRepositoryEdit
            translateLabel: true
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: repositorySelectedHolder
            label: 'Move up'
            itemValue: doRepositoryMoveUp
            translateLabel: true
          )
         (MenuItem
            enabled: repositorySelectedHolder
            label: 'Move down'
            itemValue: doRepositoryMoveDown
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!ConfigurationDialog class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!ConfigurationDialog methodsFor:'accessing'!

configuration
    "return the value in 'configurationHolder'"

    ^ self configurationHolder value
!

configuration: newValue
    "set the value in 'configurationHolder'"

    self configurationHolder value: newValue
!

defaultTitle

    ^'Edit Profile'

    "Created: / 09-03-2010 / 13:19:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

model

    ^self configuration

    "Created: / 10-03-2010 / 08:58:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurationDialog methodsFor:'actions'!

doAccept
    self acceptEnabled ifFalse:[^ self].
    (self configuration)
        name:self nameHolder value;
        repositories: self repositoryListHolder asArray.
    super doAccept.

    "Created: / 10-03-2010 / 10:57:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRepositoryAdd

    | repository |
    repository := SVN::Configuration newRepository.
    (self doRepositoryEdit: repository) ifTrue:
        [self repositoryListHolder add: repository]

    "Created: / 10-03-2010 / 15:15:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRepositoryEdit

    | index repository |
    (index := repositoryIndexHolder value) ifNil:[^self].
    repository := repositoryListHolder at: index.
    self doRepositoryEdit: repository

    "Created: / 10-03-2010 / 15:15:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRepositoryEdit: repository

    ^RepositoryDialog openOn: repository

    "Created: / 10-03-2010 / 15:15:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRepositoryMoveDown
    <resource: #uiCallback>

    | idx |
    idx := repositoryIndexHolder value.
    idx == repositoryIndexHolder size ifTrue:[^self].
    repositoryListHolder swap: idx  with: idx + 1.
    repositoryIndexHolder value: idx + 1

    "Created: / 10-03-2010 / 15:15:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRepositoryMoveUp
    <resource: #uiCallback>

    | idx |
    idx := repositoryIndexHolder value.
    idx == 1 ifTrue:[^self].
    repositoryListHolder swap: idx - 1 with: idx.
    repositoryIndexHolder value: idx - 1

    "Created: / 10-03-2010 / 15:15:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRepositoryRemove

    | index repository |
    (index := repositoryIndexHolder value) ifNil:[^self].
    repository := repositoryListHolder removeIndex: index.

    "Created: / 10-03-2010 / 15:15:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSnapshot
    <resource: #uiCallback>

    | configs current |
    configs := RepositoryManager current repositories 
                select: [:repo|repo workingCopy branchOrNil notNil]
                thenCollect: [:repo|repo configuration].
    configs := configs asSortedCollection:[:a :b|a package < b package].
    current := self repositoryListHolder value.
    configs reverseDo:
        [:new| | old |
        old := current detect:[:each|each package = new package] ifNone:[nil].
        old ifNotNil:[current remove: old].
        current addFirst: new].

    "Modified: / 24-03-2010 / 22:58:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurationDialog methodsFor:'aspects'!

acceptEnabledHolder
    |holder|

    (holder := builder bindingAt:#acceptEnabledHolder) isNil ifTrue:[
        holder := true asValue.
        builder aspectAt:#acceptEnabledHolder put:holder.
    ].
    ^ holder.

    "Created: / 09-03-2010 / 13:37:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

configurationHolder
    "return/create the valueHolder 'configurationHolder'"

    configurationHolder isNil ifTrue:[
        configurationHolder := ValueHolder with: UserPreferences current svnCurrentConfiguration
    ].
    ^ configurationHolder

    "Modified: / 09-03-2010 / 20:32:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

configurationHolder:aConfiguration
    configurationHolder := aConfiguration.
!

nameHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    nameHolder isNil ifTrue:[
        nameHolder := self configuration name asValue.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       nameHolder addDependent:self.
"/       nameHolder onChangeSend:#nameHolderChanged to:self.
    ].
    ^ nameHolder.

    "Modified: / 10-03-2010 / 10:57:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryIndexHolder
    "return/create the valueHolder 'repositoryIndexHolder'"

    repositoryIndexHolder isNil ifTrue:[
        repositoryIndexHolder := ValueHolder with:nil "defaultValue here".        
    ].
    ^ repositoryIndexHolder

    "Modified: / 10-03-2010 / 15:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryListHolder
    <resource: #uiAspect>

    repositoryListHolder isNil ifTrue:[
        repositoryListHolder := self configuration repositories deepCopy asList.
    ].
    ^ repositoryListHolder.

    "Modified: / 10-03-2010 / 11:27:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositorySelectedHolder
    "return/create the valueHolder 'repositorySelectedHolder'"

    repositorySelectedHolder isNil ifTrue:[
        repositorySelectedHolder := 
            BlockValue 
                with:[:model|model value notNil and:[model value ~= 0]]
                argument: self repositoryIndexHolder
    ].
    ^ repositorySelectedHolder

    "Modified: / 10-03-2010 / 15:32:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subtitleHolder

    ^self nameHolder

    "Created: / 09-03-2010 / 13:20:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-03-2010 / 11:25:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurationDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__ConfigurationDialog.st 384 2011-10-12 11:01:11Z vranyj1 §'
! !
