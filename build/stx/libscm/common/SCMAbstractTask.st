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
"{ Package: 'stx:libscm/common' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SCMAbstractTask
	instanceVariableNames:'packages classes temporaryWorkingCopy temporaryWorkingCopyRoot'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX-Tasks'
!

!SCMAbstractTask class methodsFor:'documentation'!

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

!SCMAbstractTask class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SCMAbstractTask methodsFor:'accessing'!

branch

    ^self workingCopy branch

    "Created: / 23-03-2009 / 17:16:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

classes
    ^ classes
!

classes:aCollection"<Collection[Class]>"
    | packageNames |

    self 
        assert: (aCollection allSatisfy: [:e|e isBehavior])
        message: 'All elements should be classes'.

    packageNames := packages collect:[:each | each name ].
    self
        assert: (aCollection allSatisfy: [:e| packageNames includes: e package] )
        message: 'All classes should belongs to one of my packages'.

    classes := aCollection.

    "Modified: / 16-06-2009 / 20:56:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 21-02-2014 / 22:52:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package
    self error: 'Should no longer be sent'.
    ^ packages

    "Modified: / 21-02-2014 / 22:49:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package:aSCMAbstractPackageModel
    self packages: (SCMCommonPackageModelGroup with: aSCMAbstractPackageModel)

    "Modified: / 26-02-2014 / 22:47:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packages
    ^ packages

    "Created: / 22-02-2014 / 23:46:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packages:aSCMCommonPackageModelGroup
    packages := aSCMCommonPackageModelGroup.
    temporaryWorkingCopy := aSCMCommonPackageModelGroup temporaryWorkingCopy.
    temporaryWorkingCopyRoot := aSCMCommonPackageModelGroup temporaryWorkingCopyRoot.

    "Created: / 26-02-2014 / 22:46:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repository

    ^self temporaryWorkingCopy repository

    "Created: / 23-03-2009 / 11:24:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-09-2015 / 01:15:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

temporaryWorkingCopy
    ^ temporaryWorkingCopy
!

temporaryWorkingCopy: wc
    temporaryWorkingCopy := wc.
    temporaryWorkingCopyRoot := wc root.

    "Created: / 12-01-2013 / 13:57:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2014 / 23:58:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

temporaryWorkingCopyRoot
    ^ temporaryWorkingCopyRoot

    "Created: / 14-11-2012 / 23:51:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2014 / 23:57:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopy
    <resource: #obsolete>

    self breakPoint: #jv. 
    ^self temporaryWorkingCopy

    "Created: / 14-11-2012 / 23:51:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2013 / 13:57:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopy: wc

    <resource: #obsolete>

    self breakPoint: #jv.
    self temporaryWorkingCopy: wc

    "Created: / 11-01-2013 / 19:34:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2013 / 13:57:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopyRoot
   <resource: #obsolete>

    self breakPoint: #jv. 
    ^self temporaryWorkingCopyRoot

    "Created: / 11-01-2013 / 19:32:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-01-2013 / 13:56:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractTask methodsFor:'executing'!

do
    "
        Perform whole task
    "            

    ^ self subclassResponsibility

    "Modified: / 23-03-2009 / 11:16:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SCMAbstractTask methodsFor:'executing - private'!

do: aBlock
    
    ^packages notNil ifTrue:[
        | names |

        names := packages collect:[ :e | e name ].
        SCMCompatModeQuery
            answer: names
            do: aBlock
    ] ifFalse:[
        aBlock value.
    ]

    "Created: / 15-07-2009 / 20:07:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2014 / 15:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractTask methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    packages := #()
    "/ classes := nil.
    "/ temporaryWorkingCopy := nil.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 21-02-2014 / 22:51:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractTask methodsFor:'notification'!

notify: aString

    self notify: aString progress: nil

    "Created: / 29-05-2009 / 16:51:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

notify: aString progress: aNumberOrNil

    aNumberOrNil isNil ifTrue:[
        ActivityNotification notify: aString
    ] ifFalse:[
        ProgressNotification newException
                messageText:aString;
                parameter: aNumberOrNil;
                raiseRequest.
    ]

    "Created: / 29-05-2009 / 16:51:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 30-06-2013 / 12:45:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractTask class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

