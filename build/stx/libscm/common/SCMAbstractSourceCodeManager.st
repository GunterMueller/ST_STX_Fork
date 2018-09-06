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

AbstractSourceCodeManager subclass:#SCMAbstractSourceCodeManager
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Common-StX'
!

SCMAbstractSourceCodeManager class instanceVariableNames:'registry uuid'

"
 No other class instance variables are inherited by this class.
"
!

!SCMAbstractSourceCodeManager class methodsFor:'documentation'!

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
!

documentation
"
    A base abstract class for all stx:libscm based source code managers

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SCMAbstractSourceCodeManager class methodsFor:'* As yet uncategorized *'!

savePreferencesOn:aFileStream

    "Created: / 18-10-2012 / 15:53:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractSourceCodeManager class methodsFor:'accessing'!

repositoryNameForPackage:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

temporaryWorkingCopyDirectory
    "Return a directory for temporary working copies"

    ^ UserPreferences current 
        at:(self nameWithoutPrefix,'.temporaryWCDirectory') 
        ifAbsent: [ Filename tempDirectory ]

    "Created: / 14-11-2012 / 22:54:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

temporaryWorkingCopyDirectory: directory
    "Sets a directory for temporary working copies"

    ^ UserPreferences current 
        at:(self nameWithoutPrefix,'.temporaryWCDirectory') 
        put: directory asString

    "Created: / 14-11-2012 / 23:24:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

utilities

    ^SCMCommonSourceCodeManagerUtilities forManager: self.

    "Created: / 06-10-2012 / 18:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2012 / 22:49:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractSourceCodeManager class methodsFor:'accessing-classes'!

commitDialogClass
    "Answer a dialog class to be used for commits"

    ^ self subclassResponsibility

    "Modified (comment): / 14-11-2012 / 00:56:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractSourceCodeManager class methodsFor:'private'!

pathInRepositoryFrom:containerPath forPackage:packageID
    "Return fake path, since it is required by sooo many methods.
     Whole bstractSourceCodeManaher code is too tightly bound to CVS
     and passes strings all around. Sigh."

    ^(packageID copyReplaceAll: $: with:$/) , '/' , containerPath

    "Created: / 13-10-2011 / 11:32:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 20-11-2012 / 10:23:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractSourceCodeManager class methodsFor:'testing'!

isAbstract
    ^ self == SCMAbstractSourceCodeManager

    "Created: / 13-11-2012 / 23:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractSourceCodeManager class methodsFor:'utilities'!

ensureVersionMethodInClass: aClass package: pkg
    "Ensures that there is a version method given class and return
     that method. If it is already present, calling this method is 
     noop. If not, a new version method is compiled"

    | cls selector |

    cls := aClass theMetaclass.
    selector := self nameOfVersionMethodInClasses.
    (cls includesSelector:selector) ifFalse:[
        cls compile:(cls versionMethodTemplateForSourceCodeManager:self)
            classified:'documentation'.
        (cls compiledMethodAt:selector) setPackage: pkg
    ].
    ^(cls compiledMethodAt:selector)

    "Created: / 26-11-2012 / 13:02:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SCMAbstractSourceCodeManager class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id::                                                                                                                        §'
! !

