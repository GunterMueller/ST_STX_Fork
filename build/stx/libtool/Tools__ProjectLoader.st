"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

SimpleDialog subclass:#ProjectLoader
	instanceVariableNames:'projectList'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools'
!

!ProjectLoader class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
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

!ProjectLoader class methodsFor:'initialization'!

initialize
    | item |

    item := (MenuItem label:(self resources string:'Load Project from Web...'))
                nameKey:'LoadProject';
                value:[(Smalltalk at: self fullName asSymbol) open].

    NewLauncher
        addMenuItem: item
        from: nil
        in: 'menu.file'
        position: #(#after #fileBrowser)
        space: true.

    "
        self initialize 
    "

    "Created: / 22-11-2008 / 09:58:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-11-2008 / 10:00:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProjectLoader class methodsFor:'accessing'!

projectSites

    ^UserPreferences current at:#projectLoaderProjectSites ifAbsent:#()

    "Created: / 22-11-2008 / 09:13:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-11-2008 / 10:13:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProjectLoader class methodsFor:'defaults'!

defaultProjectFile
    ^ Filename homeDirectory / '.smalltalk' / 'projects.rc'

    "Created: / 26-11-2008 / 10:15:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 31-07-2013 / 12:44:52 / cg"
!

defaultProjects

    ^#(
        "/ cvut projects
        (
                'CellStore'
                ('cvut:fel/cellstore/core')
        )

        (
                'Perseus'
                ('cvut:fel/perseus/core'
                 'cvut:fel/perseus/core_ui'
                 'cvut:fel/perseus/smallscript'
                 'cvut:fel/perseus/pascal'
                 'stx:goodies/xmlsuite/xquery')
        )

        (
                'IZAR'
                ('cvut:fel/izar')
        )

        "/ exept projects
        (
                'expecco'
                ('exept:expecco/application')
        )
        (
                'expeccoNET'
                ('expeccoNET:server')
        )

        "/ private projects
        (
                'scheme'
                ('cg:hdm/scheme2013')
        )
)

    "Created: / 26-11-2008 / 10:06:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 31-07-2013 / 12:40:49 / cg"
! !

!ProjectLoader class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::ProjectLoader andSelector:#windowSpec
     Tools::ProjectLoader new openInterface:#windowSpec
     Tools::ProjectLoader open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Select project'
         name: 'Select project'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 402 301)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'Main'
             layout: (LayoutFrame 3 0 3 0 -3 1 -3 1)
             horizontalLayout: fitSpace
             verticalLayout: bottomSpaceFit
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (SelectionInListModelViewSpec
                   name: 'ProjectList'
                   model: projectSelectionHolder
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   listModel: projectNamesHolder
                   highlightMode: line
                   doubleClickSelector: doAccept
                   extent: (Point 390 237)
                 )
                (ActionButtonSpec
                   label: 'Update list from network'
                   name: 'Update'
                   translateLabel: true
                   model: doUpdateFromNetwork
                   useDefaultExtent: true
                 )
                (HorizontalPanelViewSpec
                   name: 'ButtonPanel'
                   horizontalLayout: fit
                   verticalLayout: fitSpace
                   horizontalSpace: 3
                   verticalSpace: 3
                   reverseOrderIfOKAtLeft: true
                   component: 
                  (SpecCollection
                     collection: (
                      (ActionButtonSpec
                         label: 'Cancel'
                         name: 'CancelButton'
                         translateLabel: true
                         model: doCancel
                         useDefaultExtent: true
                       )
                      (ActionButtonSpec
                         label: 'Load'
                         name: 'LoadButton'
                         translateLabel: true
                         model: doAccept
                         enableChannel: canDoAcceptHolder
                         useDefaultExtent: true
                       )
                      )
                    
                   )
                   useDefaultExtent: true
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!ProjectLoader class methodsFor:'load & save'!

loadProjects
    |projectFile projects|

    projectFile := self defaultProjectFile.
    projectFile exists ifFalse:[
        ^ self defaultProjects
    ].
    projects := Compiler 
        evaluate:projectFile contents asString
        ifFail:[ 
            Dialog information:(self resources 
                                    stringWithCRs:'Syntax error in "%1".\Showing default projects.' 
                                    with:projectFile pathName).
            self defaultProjects 
        ].

    projects isEmptyOrNil ifTrue:[
        Dialog information:(self resources 
                                stringWithCRs:'Projects file "%1" is empty.\Showing default projects.' 
                                with:projectFile pathName).
        projects := self defaultProjects.
    ].
    ^ projects

    "
        self projectList"

    "Created: / 22-11-2008 / 09:41:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-11-2008 / 10:17:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

saveProjects:projects 
    |projectFile|

    projectFile := self defaultProjectFile.
    projectFile writeStream nextPutAll:projects storeString

    "Created: / 26-11-2008 / 10:07:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProjectLoader methodsFor:'actions'!

doAccept
    |packages|

    self canDoAcceptHolder value ifFalse:[
        ^ self
    ].
    packages := (projectList at:self projectSelectionHolder value) second.
    packages do:[:pkg | 
        Smalltalk loadPackage:pkg
    ].
    super doAccept.

    "Created: / 22-11-2008 / 09:55:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 31-07-2013 / 12:51:54 / cg"
!

doUpdateFromNetwork
    <resource: #uiCallback>

    | sites projects newProjects |

    projects := self class loadProjects asOrderedCollection.
    sites := self class projectSites.
    sites isEmpty ifTrue:[
        Dialog information:'No project sites defined (see ProjectLoader>>projectSites).'.
    ] ifFalse:[
        sites do:[:site|
            | siteUrl response |

            siteUrl := site asURL.
            Transcript showCR:'asking ',siteUrl asString,'...'.
            response := HTTPInterface get: siteUrl path fromHost: siteUrl host.
            newProjects := Compiler evaluate: response data ifFail:[#()].
            newProjects do:[:newPrj|
                | oldPrj |
                oldPrj := projects 
                            detect:[:oldPrj|oldPrj first = newPrj first] 
                            ifNone:[projects add: newPrj].
                oldPrj at:2 put: newPrj second.
            ]
        ].
    ].

    projects isEmpty ifTrue:[
        Dialog information:'No projects found in web.'.
        ^ self
    ].

    projects := projects asArray.
    projectList := projects.
    self class saveProjects: projects.
    self projectListChanged

    "
        Tools::ProjectLoadDialog new doUpdateFromNetwork
    "

    "Modified: / 26-11-2008 / 10:28:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (comment): / 31-07-2013 / 12:51:48 / cg"
! !

!ProjectLoader methodsFor:'aspects'!

canDoAcceptHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#canDoAcceptHolder) isNil ifTrue:[
        holder := false asValue.
        builder aspectAt:#canDoAcceptHolder put:holder.
    ].
    ^ holder.

    "Created: / 22-11-2008 / 09:51:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (comment): / 31-07-2013 / 12:52:12 / cg"
!

projectNamesHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#projectNamesHolder) isNil ifTrue:[
        holder := #() asValue.
        builder aspectAt:#projectNamesHolder put:holder.
    ].
    ^ holder.

    "Created: / 22-11-2008 / 08:59:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (comment): / 31-07-2013 / 12:52:21 / cg"
!

projectSelectionHolder
    <resource: #uiAspect>

    |holder|

    (holder := builder bindingAt:#projectSelectionHolder) isNil ifTrue:[
        holder := ValueHolder new.
        builder aspectAt:#projectSelectionHolder put:holder.
        holder onChangeSend:#projectSelectionHolderChanged to:self.
    ].
    ^ holder.

    "Created: / 22-11-2008 / 08:59:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 31-07-2013 / 18:00:28 / cg"
! !

!ProjectLoader methodsFor:'change & update'!

projectListChanged

    self projectNamesHolder value:
        (projectList collect:[:prj |
            |name origin|

            name := prj first.
            origin := prj second first.
            '%1 %2' 
                bindWith:prj first
                with:(('(%1)' bindWith:origin) withColor:Color gray)
        ])

    "Created: / 22-11-2008 / 09:52:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 31-07-2013 / 12:48:34 / cg"
!

projectSelectionHolderChanged

    | selection |
    selection := self projectSelectionHolder value.

    self canDoAcceptHolder value:
        (selection notNil and:[selection ~= 0])

    "Created: / 22-11-2008 / 09:52:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProjectLoader methodsFor:'hooks'!

commonPostOpen

    projectList := self class loadProjects.
    self projectListChanged

    "Created: / 22-11-2008 / 09:43:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-11-2008 / 10:16:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ProjectLoader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


ProjectLoader initialize!
