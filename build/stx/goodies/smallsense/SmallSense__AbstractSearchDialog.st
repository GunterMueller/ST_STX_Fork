"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany
Copyright (C) 2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

AbstractListDialog subclass:#AbstractSearchDialog
	instanceVariableNames:'recentlySearchedPatterns recentlySearchedObjectPOs processor'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

AbstractSearchDialog class instanceVariableNames:'recentlySearchedPatterns'

"
 The following class instance variables are inherited by this class:

	SmallSense::AbstractListDialog - 
	SmallSense::AbstractDIalog - 
	SimpleDialog - 
	ApplicationModel - ClassResources
	Model - 
	Object - 
"
!

!AbstractSearchDialog class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany
Copyright (C) 2015 Jan Vrany

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

!AbstractSearchDialog class methodsFor:'accessing'!

recentlySearchedPatterns
    recentlySearchedPatterns isNil ifTrue:[
        recentlySearchedPatterns := OrderedSet new.
    ].
    ^ recentlySearchedPatterns

    "Created: / 28-04-2014 / 23:13:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchDialog class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == SmallSense::AbstractSearchDialog.
! !

!AbstractSearchDialog class methodsFor:'remembering'!

rememberSearchPattern: pattern
    self recentlySearchedPatterns add: pattern

    "Created: / 11-01-2015 / 06:16:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchDialog methodsFor:'accessing'!

processor
    ^ processor
!

processor:aAbstractSearchProcessor
    processor := aAbstractSearchProcessor.
! !

!AbstractSearchDialog methodsFor:'accessing - private'!

matchingObjectForString:aString
    "Creates a new object from given string. Called only when
     #canCreateMatchingObjectFromString: returns true"

    ^ self shouldNotImplement

    "Created: / 10-01-2015 / 10:24:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchDialog methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == accept ifTrue:[
        accept value ifTrue:[
            self updateAcceptedValue.
            self class rememberSearchPattern: self pattern.
            matchingObjectsMultiselect ifTrue:[
                self processor rememberSearchObjectPOs: matchingObjectsSelectionHolder value.
            ] ifFalse:[
                self processor rememberSearchObjectPO: matchingObjectsSelectionHolder value.
            ].
        ].
        ^ self.
    ].  
    super update:something with:aParameter from:changedObject

    "Created: / 08-12-2014 / 02:36:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-01-2015 / 06:18:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchDialog methodsFor:'change & update-background'!

updateMatchingIgnorePattern

    "/ Show recent searches rather than all items (there may be a lot...)
    self enqueueDelayedUpdateMatchingObjectPOs: processor recentlySearchedObjectPOs.
    self updateMatchingLabelToRecentSearches

    "Created: / 12-12-2014 / 23:39:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2015 / 08:58:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchDialog methodsFor:'change & update-delayed'!

delayedUpdateMatchingObjectPOs: matchingPOsArg
    self updateMatchingLabelToNormal.
    super delayedUpdateMatchingObjectPOs: matchingPOsArg

    "Created: / 27-05-2015 / 15:58:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchDialog methodsFor:'hooks'!

commonPostBuild
"/    self updateMatching.
"/    recentlySearchedPatterns notEmptyOrNil ifTrue:[
"/        matchPatternView contents: self recentlySearchedPatterns last.
"/        matchPatternView selectAll.
"/    ].
    recentlySearchedObjectPOs notEmptyOrNil ifTrue:[
        self enqueueDelayedUpdateMatchingObjectPOs: recentlySearchedObjectPOs asArray reverse.
        self updateMatchingLabelToRecentSearches.
    ].
    super commonPostBuild

    "Created: / 25-11-2014 / 13:23:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2015 / 08:58:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchDialog methodsFor:'queries'!

canSelect: selection
    "raise an error: must be redefined in concrete subclass(es)"

    ^ (selection isKindOf: PO) and:[ selection isSmallSensePluggablePO not or:[ selection subject ~~ processor ] ]

    "Created: / 10-01-2015 / 10:23:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchDialog methodsFor:'searching'!

matchingObjectPOsForPattern: pattern
    self updateMatchingLabelToSearching.
    ^ processor matchingObjectPOsForPattern: pattern filter: filter inEnvironment: self environment

    "Created: / 13-12-2014 / 08:33:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-05-2015 / 15:57:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractSearchDialog class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

