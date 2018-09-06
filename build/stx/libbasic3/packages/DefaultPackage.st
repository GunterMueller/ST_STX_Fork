"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

Package subclass:#DefaultPackage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Package'
!

!DefaultPackage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!DefaultPackage methodsFor:'changes'!

classChange:classChange
    | newClass |
    newClass := (Smalltalk classNamed:classChange className).
    newClass ifNil:[
        self error:'The class named ', newClass name,
            'does not exist!! It is expected to exist from a class change!!'
    ].

    self addedClass:newClass.
    self changed:#classChange: with:classChange
!

classDefinitionChange:aClassDefinitionChange 
    | newClass |
    newClass := (Smalltalk classNamed:aClassDefinitionChange className).
    newClass ifNil:[
        self error:'The class named ', newClass name,
            'does not exist!! It is expected to exist from a class redefinition action!!'
    ].

    self addedClass:newClass.
    self changed:#classDefinitionChange: with:aClassDefinitionChange
!

classInstVarDefinitionChange:aClassInstVarDefinitionChange 

    | newClass |
    newClass := (Smalltalk classNamed:aClassInstVarDefinitionChange className).
    newClass ifNil:[
        self error:'The class named ', newClass name,
            'does not exist!! It is expected to exist from a class redefinition action!!'
    ].

    self addedClass:newClass.
    self changed:#classDefinitionChange: with:aClassInstVarDefinitionChange
!

classRemoveChange:aClassRemoveChange

    self removedClassNamed:aClassRemoveChange className.
    self changed:#classRemoveChange: with:aClassRemoveChange
!

methodChanged:aMethodChange
    "a method as changed. The receiver must be responsible for all changes to the image
    so if it is not. make sure it does now!!"
    |aMethodName aClassName aMethod |
    aMethodName := aMethodChange selector.
    aClassName := aMethodChange className asSymbol.
    aMethod := (Smalltalk classNamed:aClassName) compiledMethodAt:aMethodName.

    self addedMethod:aMethod.
    self changed:#methodChanged: with:aMethodChange
!

methodRemoveChange:aMethodRemoveChange 

    self removedMethodNamed:aMethodRemoveChange selector forClassNamed:aMethodRemoveChange className.
    self changed:#methodRemoveChange: with:aMethodRemoveChange
! !

!DefaultPackage methodsFor:'queries'!

isDependentOnClassChange:classChange
    "checks to see if the receiver is affected by the change. returns a boolean
    "
    ^ classChange changeClass package == name
"/    ^ (super isDependentOnClassChange:classChange) not
!

isDependentOnClassDefinitionChange:aClassDefinitionChange 
    ^ aClassDefinitionChange changeClass package == name "and:[
        (super isDependentOnClassDefinitionChange:aClassDefinitionChange) not
    ]                                                      "

!

isDependentOnClassInstVarDefinitionChange:aClassInstVarDefinitionChange 
    ^ aClassInstVarDefinitionChange changeClass package == name

"/    ^ (super isDependentOnClassInstVarDefinitionChange:aClassInstVarDefinitionChange) not
!

isDependentOnClassRemoveChange:aClassRemoveChange
    | classBeingRemoved |
    classBeingRemoved := ClassRemoveChange::ClassBeingRemovedQuery query.
    ^ classBeingRemoved package == name
    
"/    ^ (super isDependentOnClassRemoveChange:aClassRemoveChange)
!

isDependentOnClassRenameChange:classChange

    ^ classChange changeClass package == name
"/    ^ (super isDependentOnClassRenameChange:classChange) not
!

isDependentOnMethodCategoryChange:aMethodRemoveChange 
    ^ (super isDependentOnMethodCategoryChange:aMethodRemoveChange)
!

isDependentOnMethodCategoryRenameChange:aMethodRemoveChange 
    ^ (super isDependentOnMethodCategoryRenameChange:aMethodRemoveChange)
!

isDependentOnMethodChange:aMethodChange
    ^ (super isDependentOnMethodChange:aMethodChange) not
!

isDependentOnMethodRemoveChange:aMethodRemoveChange 
    ^ (super isDependentOnMethodRemoveChange:aMethodRemoveChange) not
! !

!DefaultPackage class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/DefaultPackage.st,v 1.2 2006-01-10 09:29:41 cg Exp $'
! !
