"{ Package: 'stx:goodies/magritte/tests' }"

LibraryDefinition subclass:#stx_goodies_magritte_tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_magritte_tests class methodsFor:'description'!

preRequisites
    ^ #(
        #'stx:goodies/magritte'    "Magritte::MAStringDescription - referenced by Magritte::MAMockAddress class>>descriptionPlace "
        #'stx:goodies/sunit'    "TestCase - superclass of Magritte::MAContainerTest "
        #'stx:libbasic'    "Object - superclass of Magritte::MANullAccessorTest "
        #'stx:libview'    "Color - referenced by Magritte::MAColorDescriptionTest>>includedInstance "
    )
! !

!stx_goodies_magritte_tests class methodsFor:'description - contents'!

classNamesAndAttributes
    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'Magritte::MAAccessorMock'
        #'Magritte::MAAdaptiveModelTest'
        #'Magritte::MAConditionTest'
        #'Magritte::MADescriptionBuilderTest'
        #'Magritte::MADynamicObjectTest'
        #'Magritte::MAExtensionsTest'
        #'Magritte::MAFileModelTest'
        #'Magritte::MAMockAddress'
        #'Magritte::MAObjectTest'
        #'Magritte::MATableModelTest'
        #'stx_goodies_magritte_tests'
        #'Magritte::MAAccessorTest'
        #'Magritte::MADescriptionTest'
        #'Magritte::MAExternalFileModelTest'
        #'Magritte::MAMementoTest'
        #'Magritte::MAMemoryFileModelTest'
        #'Magritte::MACachedMementoTest'
        #'Magritte::MAContainerTest'
        #'Magritte::MADelegatorAccessorTest'
        #'Magritte::MADictionaryAccessorTest'
        #'Magritte::MAElementDescriptionTest'
        #'Magritte::MAIdentityAccessorTest'
        #'Magritte::MANullAccessorTest'
        #'Magritte::MAPluggableAccessorTest'
        #'Magritte::MASelectorAccessorTest'
        #'Magritte::MAStraitMementoTest'
        #'Magritte::MAVariableAccessorTest'
        #'Magritte::MABooleanDescriptionTest'
        #'Magritte::MAChainAccessorTest'
        #'Magritte::MACheckedMementoTest'
        #'Magritte::MAClassDescriptionTest'
        #'Magritte::MAColorDescriptionTest'
        #'Magritte::MAFileDescriptionTest'
        #'Magritte::MAMagnitudeDescriptionTest'
        #'Magritte::MAPriorityContainerTest'
        #'Magritte::MAReferenceDescriptionTest'
        #'Magritte::MAStringDescriptionTest'
        #'Magritte::MADateDescriptionTest'
        #'Magritte::MADurationDescriptionTest'
        #'Magritte::MAMemoDescriptionTest'
        #'Magritte::MANumberDescriptionTest'
        #'Magritte::MAOptionDescriptionTest'
        #'Magritte::MAPasswordDescriptionTest'
        #'Magritte::MARelationDescriptionTest'
        #'Magritte::MASymbolDescriptionTest'
        #'Magritte::MATableDescriptionTest'
        #'Magritte::MATimeDescriptionTest'
        #'Magritte::MATimeStampDescriptionTest'
        #'Magritte::MATokenDescriptionTest'
        #'Magritte::MAMultipleOptionDescriptionTest'
        #'Magritte::MASingleOptionDescriptionTest'
        #'Magritte::MAToManyRelationDescriptionTest'
        #'Magritte::MAToOneRelationDescriptionTest'
        #'Magritte::MAToManyScalarRelationDescriptionTest'
    )
!

extensionMethodNames
    ^ #(
    )
! !

!stx_goodies_magritte_tests class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2009\nCopyright eXept Software AG 1998-2009'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_magritte_tests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/stx_goodies_magritte_tests.st,v 1.3 2014-09-23 20:31:57 vrany Exp $'
! !

