"{ Package: 'stx:libdb/nosql/goods' }"

KKClassDescriptor subclass:#KKVariableClassDescriptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKVariableClassDescriptor comment:''
!


!KKVariableClassDescriptor methodsFor:'as yet unclassified'!

newInstanceFromStream: aStream
	^ self instanceClass basicNew: (aStream contents size - (self fixedSize)) / self varyingSize.
! !

!KKVariableClassDescriptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKVariableClassDescriptor.st,v 1.3 2013-03-31 12:07:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKVariableClassDescriptor.st,v 1.3 2013-03-31 12:07:14 cg Exp $'
! !

