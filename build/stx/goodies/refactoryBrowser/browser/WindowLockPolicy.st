"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

CodeModelLockPolicy subclass:#WindowLockPolicy
	instanceVariableNames:'codeTool'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Browser'
!

WindowLockPolicy comment:'WindowLockPolicy is a CodeModelLockPolicy that unlocks the model only when its screen is the topmost window of it type.

On unix machines this policy is slow. It asks the Screen for an ordering of its windows, and on unix machines the primitive that returns this information is slow, but on OS/2 and Windows it is quite usable.
'
!


!WindowLockPolicy methodsFor:'accessing'!

getWindowHandle
	| possibleWindows |
	possibleWindows := Screen default stackedWindows select: [:each | (each respondsTo: #model)
					and: [each model class = codeTool class and: [each model navigator == codeTool navigator]]].
	possibleWindows isEmpty ifTrue: [^self].
	WindowHandleCache := possibleWindows last key
!

isLocked
	WindowHandleCache isNil ifTrue: [self getWindowHandle].
	^codeTool builder isNil or: [codeTool builder window isNil or: [codeTool builder window key ~~ WindowHandleCache]]
! !

!WindowLockPolicy methodsFor:'initialize-release'!

on: aCodeTool
	codeTool := aCodeTool
! !

!WindowLockPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/WindowLockPolicy.st,v 1.5 2003-09-23 10:45:20 cg Exp $'
! !
