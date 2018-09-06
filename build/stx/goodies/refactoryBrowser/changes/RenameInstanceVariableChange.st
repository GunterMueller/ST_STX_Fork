"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

RenameVariableChange subclass:#RenameInstanceVariableChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!RenameInstanceVariableChange methodsFor:'private'!

addNewVariable
    | index |

    index := self changeClass instVarNames indexOf: oldName.    
    (AddInstanceVariableChange add: newName at: index to: self changeClass) execute

    "Modified: / 31-01-2014 / 01:59:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

copyOldValuesToNewVariable
        | newIndex oldIndex |

        Smalltalk isSmalltalkX ifTrue:[^ self].

        oldIndex := self changeClass allInstVarNames indexOf: oldName asString.
        newIndex := self changeClass allInstVarNames indexOf: newName asString.
        self changeClass withAllSubclasses do: 
                        [:each | 
                        each allInstances 
                                do: [:inst | inst instVarAt: newIndex put: (inst instVarAt: oldIndex)]]
!

removeOldVariable
	(RemoveInstanceVariableChange remove: oldName from: self changeClass) 
		execute
! !

!RenameInstanceVariableChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/RenameInstanceVariableChange.st,v 1.5 2014-01-31 02:08:21 vrany Exp $'
! !

