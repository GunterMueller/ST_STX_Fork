"{ Package: 'stx:goodies/monticello' }"

PackageInfo subclass:#MCMockPackageInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Mocks'
!


!MCMockPackageInfo class methodsFor:'as yet unclassified'!

initialize
	[self new register] on: MessageNotUnderstood do: []
! !

!MCMockPackageInfo methodsFor:'as yet unclassified'!

classNames
	^ #(	MCMockClassA
		 	MCMockASubclass
			MCMockClassB
			MCMockClassD
			MCMockClassE
			MCMockClassF
			MCMockClassG
			MCMockClassH
			MCMockClassI
		)
!

classes
	^ self classNames 
		select: [:name | Smalltalk hasClassNamed: name]
		thenCollect: [:name | Smalltalk at: name]
!

extensionMethods
	^ Array with: (MethodReference new 
					setStandardClass: MCSnapshotTest 
					methodSymbol: #mockClassExtension)
!

includesClass: aClass
	^self classes includes: aClass
!

includesSystemCategory: categoryName
	^self systemCategories anySatisfy: [:cat | cat sameAs: categoryName]
!

packageName
	^ 'MonticelloMocks'
!

systemCategories
	^ Array with: 'Monticello-Mocks'
! !

!MCMockPackageInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMockPackageInfo.st,v 1.4 2012-09-11 21:24:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMockPackageInfo.st,v 1.4 2012-09-11 21:24:30 cg Exp $'
!

version_SVN
    ^ '§Id: MCMockPackageInfo.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !

MCMockPackageInfo initialize!
