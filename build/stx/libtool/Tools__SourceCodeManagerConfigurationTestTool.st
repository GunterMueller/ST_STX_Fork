"
 COPYRIGHT (c) 2006 by eXept Software AG
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

ApplicationModel subclass:#SourceCodeManagerConfigurationTestTool
	instanceVariableNames:'resultView packageView'
	classVariableNames:''
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

!SourceCodeManagerConfigurationTestTool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SourceCodeManagerConfigurationTestTool class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::SourceCodeManagerConfigurationTestTool andSelector:#windowSpec
     Tools::SourceCodeManagerConfigurationTestTool new openInterface:#windowSpec
     Tools::SourceCodeManagerConfigurationTestTool open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Source Code Management Configuration Test Tool'
          name: 'Source Code Management Configuration Test Tool'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 579 382)
        )
        component: 
       (SpecCollection
          collection: (
           (ViewSpec
              name: 'Box1'
              layout: (LayoutFrame 3 0 3 0 -3 1 -30 1)
              component: 
             (SpecCollection
                collection: (
                 (LabelSpec
                    label: 'Enter package name and press test'
                    name: 'Label1'
                    layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                    translateLabel: true
                    adjust: left
                  )
                 (InputFieldSpec
                    name: 'Package'
                    layout: (LayoutFrame 0 0 30 0 -60 1 55 0)
                    model: packageHolder
                    immediateAccept: false
                    acceptOnLeave: false
                    acceptOnReturn: true
                    acceptOnTab: false
                    acceptOnPointerLeave: false
                    acceptIfUnchanged: true
                    valueChangeCallBackSelector: doTest
                    postBuildCallback: postBuildPackageView:
                  )
                 (ActionButtonSpec
                    label: 'Test'
                    name: 'Button2'
                    layout: (LayoutFrame -59 1 30 0 0 1 55 0)
                    translateLabel: true
                    model: doTest
                  )
                 (TextEditorSpec
                    name: 'Result'
                    layout: (LayoutFrame 0 0 70 0 0 1 0 1)
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    hasKeyboardFocusInitially: false
                    viewClassName: 'TextCollector'
                    postBuildCallback: postBuildResultView:
                  )
                 )
               
              )
            )
           (ActionButtonSpec
              label: 'Close'
              name: 'Button1'
              layout: (LayoutFrame 3 0 -27 1 -3 1 0 1)
              translateLabel: true
              model: doClose
            )
           )
         
        )
      )
! !

!SourceCodeManagerConfigurationTestTool methodsFor:'actions'!

doClose
    <resource: #uiCallback>

    self closeRequest

    "Modified: / 10-10-2011 / 19:16:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doTest
    <resource: #uiCallback>
    |pkg mgr line|

    packageView isNil ifTrue:[
        ^ self
    ].
    pkg := packageView contents.
    pkg ifNil:[^ self].
    mgr := AbstractSourceCodeManager managerForPackage:pkg.
    line := '%1 -> %2, %3' 
                bindWith:pkg
                with:mgr managerTypeNameShort
                with:(mgr repositoryNameForPackage:pkg).
    resultView showCR:line

    "Modified: / 11-10-2011 / 08:58:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeManagerConfigurationTestTool methodsFor:'aspects'!

packageHolder

    ^ValueHolder new

    "Created: / 11-10-2011 / 09:00:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeManagerConfigurationTestTool methodsFor:'callbacks'!

postBuildPackageView: aView

    packageView := aView

    "Created: / 11-10-2011 / 08:57:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildResultView: aView

    resultView := aView

    "Created: / 10-10-2011 / 19:21:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SourceCodeManagerConfigurationTestTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__SourceCodeManagerConfigurationTestTool.st,v 1.3 2014-02-05 18:59:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__SourceCodeManagerConfigurationTestTool.st,v 1.3 2014-02-05 18:59:26 cg Exp $'
! !

