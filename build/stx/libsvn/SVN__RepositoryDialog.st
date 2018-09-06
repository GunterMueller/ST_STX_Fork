"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2016 Jan Vrany

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

Dialog subclass:#RepositoryDialog
	instanceVariableNames:'packageHolder urlHolder branchHolder branchList
		branchSelectionEnabled'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Configuration'
!

!RepositoryDialog class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG
 Copyright (c) 2016 Jan Vrany

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

!RepositoryDialog class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:SVN::RepositoryDialog    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#Package
'* matches any path sequence'

#URL
'Repository url. Following variables are expanded\ %p - full package name (ex: ''stx/goodies/libsvn'')'

)
! !

!RepositoryDialog class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::RepositoryDialog andSelector:#contentSpec
     SVN::RepositoryDialog new openInterface:#contentSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: contentSpec
        window: 
       (WindowSpec
          label: 'Repository configuration'
          name: 'Repository configuration'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 647 345)
        )
        component: 
       (SpecCollection
          collection: (
           (VerticalPanelViewSpec
              name: 'Panel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              horizontalLayout: fit
              verticalLayout: center
              component: 
             (SpecCollection
                collection: (
                 (TransparentBoxSpec
                    name: 'PackageBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Package:'
                          name: 'PackageLabel'
                          layout: (LayoutFrame 0 0 0 0 120 0 0 1)
                          translateLabel: true
                          adjust: right
                        )
                       (InputFieldSpec
                          name: 'Package'
                          layout: (LayoutFrame 120 0 4 0 -105 1 -1 1)
                          activeHelpKey: URL
                          enableChannel: svnEnabledAspect
                          model: packageHolder
                          immediateAccept: true
                          acceptOnReturn: true
                          acceptOnTab: true
                          acceptOnLostFocus: true
                          modifiedChannel: modifiedChannel
                          acceptOnPointerLeave: true
                          valueChangeCallBackSelector: validate
                        )
                       (ActionButtonSpec
                          label: 'Select'
                          name: 'SelectPackageButton'
                          layout: (LayoutFrame -100 1 3 0 0 1 28 0)
                          translateLabel: true
                          model: selectPackage
                          initiallyDisabled: true
                        )
                       )
                     
                    )
                    extent: (Point 647 30)
                  )
                 (TransparentBoxSpec
                    name: 'URLBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (ComboBoxSpec
                          name: 'ComboBox2'
                          layout: (LayoutFrame 120 0 4 0 -105 1 -1 1)
                          activeHelpKey: URL
                          enableChannel: svnEnabledAspect
                          model: urlHolder
                          immediateAccept: true
                          acceptOnReturn: true
                          acceptOnTab: true
                          acceptOnLostFocus: true
                          modifiedChannel: modifiedChannel
                          acceptOnPointerLeave: true
                          valueChangeCallBackSelector: validate
                          comboList: urlSuggestions
                        )
                       (LabelSpec
                          label: 'Repository URL:'
                          name: 'URLLabel'
                          layout: (LayoutFrame 0 0 0 0 120 0 0 1)
                          translateLabel: true
                          adjust: right
                        )
                       (ActionButtonSpec
                          label: 'Variables...'
                          name: 'SelectVariableButton'
                          layout: (LayoutFrame -100 1 3 0 0 1 28 0)
                          translateLabel: true
                          model: selectVariable
                          initiallyDisabled: true
                        )
                       )
                     
                    )
                    extent: (Point 647 30)
                  )
                 (TransparentBoxSpec
                    name: 'BranchBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Branch:'
                          name: 'BranchLabel'
                          layout: (LayoutFrame 0 0 0 0 120 0 30 0)
                          visibilityChannel: branchSelectionEnabled
                          translateLabel: true
                          adjust: right
                        )
                       (ComboBoxSpec
                          name: 'ComboBox1'
                          layout: (LayoutFrame 120 0 3 0 -105 1 28 0)
                          activeHelpKey: URL
                          enableChannel: branchSelectionEnabled
                          model: branchHolder
                          type: string
                          immediateAccept: false
                          acceptOnReturn: true
                          acceptOnTab: true
                          acceptOnLostFocus: true
                          acceptOnPointerLeave: true
                          comboList: branchList
                          isFilenameBox: false
                        )
                       (ActionButtonSpec
                          label: 'Get branches'
                          name: 'BranchesButton'
                          layout: (LayoutFrame -100 1 3 0 0 1 28 0)
                          translateLabel: true
                          model: getBranches
                          enableChannel: branchSelectionEnabled
                        )
                       )
                     
                    )
                    extent: (Point 647 30)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!RepositoryDialog class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!RepositoryDialog methodsFor:'accessing'!

branch

    ^self branchHolder value

    "Created: / 10-03-2010 / 09:01:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package

    ^self packageHolder value

    "Created: / 16-08-2009 / 17:19:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

url

    ^self urlHolder value

    "Created: / 16-08-2009 / 17:02:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryDialog methodsFor:'accessing - defaults'!

defaultModel

    ^Configuration::Repository new

    "Created: / 16-08-2009 / 16:02:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 09-03-2010 / 22:46:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTitle

    ^'Repository configuration'

    "Created: / 03-10-2008 / 13:58:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 16:12:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryDialog methodsFor:'actions'!

doAccept
    self acceptEnabled ifFalse:[
        ^ self
    ].
    (self model)
        package:self package;
        url:self url;
        branch: self branch.
    super doAccept.

    "Created: / 16-08-2009 / 17:02:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-03-2010 / 09:01:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getBranches

    self showProgressWhile:
    [| pkg pattern replacements url repo placeholders |
    ActivityNotification notify:'Getting list of branches...'.
    pkg := packageHolder value asSymbol.  
    pattern := PackagePattern for: pkg.
    placeholders := Configuration variableValuesForPackage:pkg.    
    pattern match: pkg into: placeholders.        
    url := urlHolder value expandPlaceholdersWith: placeholders.
    (url includesSubString: '%(BRANCH)') ifFalse:[
        url := url , '/%(BRANCH)'.
    ].
    repo := Repository package: pkg asSymbol url: url.
    branchList value: (repo branches collect:[:e|e asString]).
    branchHolder value isNilOrEmptyCollection 
        ifTrue:[branchHolder value: repo trunk]]

    "Modified: / 20-01-2016 / 23:46:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectPackage
    <resource: #uiCallback>

    "automatically generated by UIPainter..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."
    "*** (and replace this comment by something more useful ;-)"

    "action to be defined here..."

    Transcript showCR:self class name, ': action for selectPackage ...'.
!

selectVariable
    <resource: #uiCallback>

    "automatically generated by UIPainter..."

    "*** the code below performs no action"
    "*** (except for some feedback on the Transcript)"
    "*** Please change as required and accept in the browser."
    "*** (and replace this comment by something more useful ;-)"

    "action to be defined here..."

    Transcript showCR:self class name, ': action for selectVariable ...'.
! !

!RepositoryDialog methodsFor:'aspects'!

branchHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    branchHolder isNil ifTrue:[
        branchHolder := ValueHolder with: self model branch.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       branchHolder addDependent:self.
"/       branchHolder onChangeSend:#branchHolderChanged to:self.
    ].
    ^ branchHolder.

    "Modified: / 22-03-2010 / 13:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branchList
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    branchList isNil ifTrue:[
        branchList := ValueHolder new.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       branchList addDependent:self.
"/       branchList onChangeSend:#branchListChanged to:self.
    ].
    ^ branchList.
!

branchSelectionEnabled

    branchSelectionEnabled isNil ifTrue:[
        branchSelectionEnabled := BlockValue
            with:
                [:packageHolder :urlHolder|
                packageHolder isNilOrEmptyCollection not and:
                [urlHolder isNilOrEmptyCollection not and:
                [((packageHolder value ? '') includes:$*) not or:
                    [(urlHolder value ? '' indexOfSubCollection: '%(BRANCH)') ~~ 0]]]]
            argument: self packageHolder
            argument: self urlHolder
            
    ].
    ^ branchSelectionEnabled.

    "Modified: / 22-03-2011 / 22:52:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    packageHolder isNil ifTrue:[
        packageHolder := ValueHolder with: self model package.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       packageHolder addDependent:self.
"/       packageHolder onChangeSend:#packageHolderChanged to:self.
    ].
    ^ packageHolder.

    "Modified: / 09-03-2010 / 19:24:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

urlHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    urlHolder isNil ifTrue:[
        urlHolder := ValueHolder with: self model url .
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       urlHolder addDependent:self.
"/       urlHolder onChangeSend:#urlHolderChanged to:self.
    ].
    ^ urlHolder.

    "Modified: / 09-03-2010 / 19:24:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

urlSuggestions
    <resource: #uiAspect>

    | urls |
    urls := Set with: 'https://swing.fit.cvut.cz/svn/%(PATH)'.
    SVN::Configuration configurations do:
        [:config|
        config repositories do:
            [:repo|
            urls add: repo url]].
    ^urls asArray

    "Created: / 24-06-2010 / 14:36:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RepositoryDialog methodsFor:'hooks'!

postOpenWith: aUIBuilder

    self validate

    "Created: / 10-03-2010 / 14:42:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RepositoryDialog methodsFor:'validation'!

validate
    |url|

    [
        url := self url.
        url 
            ifNil:[ ^ self acceptEnabled:false ]
            ifNotNil:[
                (#('file' 'http' 'https' 'svn' 'svn+ssh') anySatisfy:[:e|url startsWith: e])
                ifFalse:[
                    ^ self acceptEnabled:false
                ] ifTrue:[
                    "/self urlHolder setValue:url printString
                ]
            ].
        self acceptEnabled:true.
    ] on: Smalltalk::Error do:[:ex|ex pass. self acceptEnabled:false ].

    "Created: / 16-08-2009 / 16:25:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-04-2011 / 14:39:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RepositoryDialog class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__RepositoryDialog.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !

