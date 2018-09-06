"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractPresenter subclass:#VDBVariableObjectPresenter
	instanceVariableNames:'varobj'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Presentation'
!

!VDBVariableObjectPresenter class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBVariableObjectPresenter class methodsFor:'menu specs'!

contextMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBVariableObjectPresenter andSelector:#contextMenu
     (Menu new fromLiteralArrayEncoding:(VDBVariableObjectPresenter contextMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Copy Value'
            itemValue: doCopyValue
            isVisible: true
          )
         (MenuItem
            label: 'Copy Expression'
            itemValue: doCopyPath
            isVisible: true
          )
         )
        nil
        nil
      )
! !

!VDBVariableObjectPresenter methodsFor:'accessing'!

label
    ^ varobj parentIsDynamic 
        ifTrue:[ varobj expression ] 
        ifFalse:[ varobj path ]

    "Created: / 27-02-2015 / 15:57:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2018 / 22:53:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subject
    "Return an instance of GDB object that this presenter displays."

    ^ varobj

    "Modified: / 05-02-2018 / 13:08:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tooltip
    ^ self valueString

    "Created: / 29-07-2018 / 21:35:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

value
    ^ varobj value

    "Created: / 02-06-2017 / 07:32:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-01-2018 / 22:49:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

valueString
    ^ varobj value

    "Created: / 11-06-2017 / 23:25:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2018 / 00:55:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

varobj
    ^ varobj

    "Created: / 28-01-2018 / 22:45:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectPresenter methodsFor:'initialization'!

setVarobj:aGDBVariable 
    varobj := aGDBVariable

    "Created: / 27-02-2015 / 16:00:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectPresenter methodsFor:'menu'!

contextMenuStX: aMenu
    "Adds a Smalltalk/X debugging menu items to the context menu."

    <menuextension: #contextMenu>

    (varobj type endsWith: 'OBJ') ifTrue:[ 
        | path |

        path := varobj path.
        aMenu addItem: (
            (MenuItem label: (self class classResources string: 'Inspect - *(%1)' with: path)
                 itemValue: #doInspectOBJ)
                 receiver: self
        ).
        aMenu addSeparator.
    ].

    "Created: / 10-02-2018 / 23:06:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectPresenter methodsFor:'menu actions'!

doCopyPath
    self doCopy: varobj path.

    "Created: / 05-02-2018 / 22:32:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCopyValue
    self doCopy: varobj value.

    "Created: / 16-01-2018 / 23:28:56 / jv"
    "Modified: / 28-01-2018 / 22:55:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doDoubleClick
    self doInspectOBJ

    "Created: / 19-02-2018 / 16:10:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doInspectOBJ
    | dup |

    dup := varobj duplicate.
    dup visualizer: 'lambda val: instance_create(val)'.
    dup inspect.

    "Created: / 10-02-2018 / 23:17:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-02-2018 / 14:59:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectPresenter methodsFor:'private'!

fetchChildren
    ^ varobj children collect:[ :each | self class new setVarobj:each; parent:self;yourself ]

    "Created: / 28-01-2018 / 22:46:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectPresenter methodsFor:'protocol-queries'!

hasChildren
    ^ varobj hasChildren

    "Created: / 28-01-2018 / 22:49:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectPresenter methodsFor:'testing'!

isVariablePresenter
    ^ true

    "Created: / 02-06-2017 / 00:05:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBVariableObjectPresenter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

