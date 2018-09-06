"{ Package: 'stx:libcompat' }"

Object subclass:#ChangeList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!


!ChangeList class methodsFor:'*monticello'!

recent: charCount on: origChangesFile 
	"Opens a changeList on the end of the specified changes log file"
	| changeList end changesFile |
	changesFile _ origChangesFile readOnlyCopy.
	end _ changesFile size.
	Cursor read
		showWhile: [changeList _ self new
						scanFile: changesFile
						from: (0 max: end - charCount)
						to: end].
	changesFile close.
	^changeList
!

recentLogOn: origChangesFile startingFrom: initialPos 
	"Prompt with a menu of how far back to go when browsing a changes file."

	| end banners positions pos chunk i changesFile |
	changesFile _ origChangesFile readOnlyCopy.
	banners _ OrderedCollection new.
	positions _ OrderedCollection new.
	end _ changesFile size.
	pos _ initialPos.
	[pos = 0
		or: [banners size > 20]]
		whileFalse: [changesFile position: pos.
			chunk _ changesFile nextChunk.
			i _ chunk indexOfSubCollection: 'priorSource: ' startingAt: 1.
			i > 0
				ifTrue: [positions addLast: pos.
					banners
						addLast: (chunk copyFrom: 5 to: i - 2).
					pos _ Number
								readFrom: (chunk copyFrom: i + 13 to: chunk size)]
				ifFalse: [pos _ 0]].
	changesFile close.
	banners size == 0 ifTrue: [^self recent: end on: origChangesFile].

	pos _ (SelectionMenu labelList: banners selections: positions)
				startUpWithCaption: 'Browse as far back as...'.
	pos == nil
		ifTrue: [^ self].
	^self recent: end - pos on: origChangesFile
! !

!ChangeList methodsFor:'*monticello'!

changeTo: changeSubset
	| newList newChangeList |

	newChangeList _ OrderedCollection new.
	newList _ OrderedCollection new.

	1 to: changeList size do:
		[:i | (changeSubset includes: (changeList at: i)) ifTrue:
			[newChangeList add: (changeList at: i).
			newList add: (list at: i)]].
	newChangeList size < changeList size
		ifTrue:
			[changeList _ newChangeList.
			list _ newList.
			listIndex _ 0.
			listSelections _ Array new: list size withAll: false].
	self changed: #list

	
! !

!ChangeList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/ChangeList.st,v 1.2 2006-11-22 17:08:21 cg Exp $'
! !
