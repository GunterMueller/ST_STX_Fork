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

Tools::ChangeSetDiffTool subclass:#MergeBrowser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Browsers-Diff'
!

!MergeBrowser class methodsFor:'documentation'!

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

!MergeBrowser class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SVN::MergeBrowser andSelector:#windowSpec
     SVN::MergeBrowser new openInterface:#windowSpec
     SVN::MergeBrowser open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Diff Browser'
          name: 'Diff Browser'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 908 676)
          menu: mainMenu
        )
        component: 
       (SpecCollection
          collection: (
           (VariableVerticalPanelSpec
              name: 'Panel'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              showHandle: true
              component: 
             (SpecCollection
                collection: (
                 (SubCanvasSpec
                    name: 'NavigatorPanel'
                    hasHorizontalScrollBar: false
                    hasVerticalScrollBar: false
                    specHolder: navigatorPanelSpecHolder
                    createNewBuilder: false
                  )
                 (SubCanvasSpec
                    name: 'DiffView'
                    majorKey: #'SVN::MergeViewApp'
                    minorKey: #'diffSpec_Merge'
                    specHolder: diffPanelSpecAspect
                    subAspectHolders: 
                   (Array

                     (SubChannelInfoSpec
                        subAspect: diffHolder
                        aspect: singleSelectionHolder
                      )
                    )
                    createNewApplication: true
                    createNewBuilder: true
                  )
                 )
               
              )
              handles: (Any 0.3 1.0)
            )
           )
         
        )
      )

    "Modified: / 23-11-2009 / 19:51:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeBrowser class methodsFor:'menu specs'!

listMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SVN::MergeBrowser andSelector:#listMenu
     (Menu new fromLiteralArrayEncoding:(SVN::MergeBrowser listMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Resolve using A'
            itemValue: resolveUsingVersionA
            nameKey: ResolveUsingA
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' versionA16x16 'Resolve using A')
          )
         (MenuItem
            label: 'Resolve using B'
            itemValue: resolveUsingVersionB
            nameKey: ResolveUsingB
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' versionB16x16 'Resolve using B')
          )
         (MenuItem
            label: 'Resolve using Base'
            itemValue: resolveUsingVersionBase
            nameKey: ResolveUsingBase
            translateLabel: true
            labelImage: (ResourceRetriever #'SVN::IconLibrary' versionBase16x16 'Resolve using Base')
          )
         (MenuItem
            label: '-'
          )
         (MenuItem
            enabled: hasSelection
            label: 'Inspect'
            itemValue: listMenuInspect
            translateLabel: true
          )
         )
        nil
        nil
      )
!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SVN::MergeBrowser andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(SVN::MergeBrowser mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Change Set'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Browse merge changeset'
                  itemValue: browseMergeChangeset
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Merge'
            translateLabel: true
            submenuChannel: listMenu
          )
         )
        nil
        nil
      )
! !

!MergeBrowser class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!MergeBrowser class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #diffsetHolder
      ).

! !

!MergeBrowser methodsFor:'accessing'!

mergeChangeSet

    ^self diffsetHolder value resolution

    "Created: / 25-11-2009 / 10:21:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2009 / 08:44:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeBrowser methodsFor:'aspects'!

diffListEntryLabelGeneratorAspect

    ^[:diff|
    diff merged 
        ifFalse:[diff name asText allBold colorizeAllWith: Color red]
        ifTrue:[diff name]]

    "Created: / 24-11-2009 / 10:02:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeBrowser methodsFor:'change & update'!

updateListMenu

    "Created: / 25-11-2009 / 10:05:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeBrowser methodsFor:'menu actions'!

browseMergeChangeset


    Tools::ChangeSetBrowser new
        changeset: self mergeChangeSet;
        open

    "Modified: / 25-11-2009 / 10:30:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolveUsingVersionA

    self selection do:
        [:diff|diff versionMerged: diff versionA copy]

    "Modified: / 25-11-2009 / 10:01:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolveUsingVersionB

    self selection do:
        [:diff|diff versionMerged: diff versionB copy]

    "Modified: / 25-11-2009 / 10:01:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolveUsingVersionBase

    self selection do:
        [:diff|diff versionMerged: diff versionBase copy]

    "Modified: / 25-11-2009 / 10:01:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MergeBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__MergeBrowser.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
