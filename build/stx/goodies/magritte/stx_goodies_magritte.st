"{ Package: 'stx:goodies/magritte' }"

LibraryDefinition subclass:#stx_goodies_magritte
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_magritte class methodsFor:'description'!

preRequisites
    ^ #(
        #'stx:libbasic'    "Exception - superclass of Magritte::MAConflictError "
        #'stx:libbasic2'    "UUID - referenced by Magritte::MACompatibility class>>uuid "
        #'stx:libview'    "Color - referenced by Magritte::MAColorDescription>>kind "
        #'stx:libwidg'    "PopUpMenu - referenced by Magritte::MACompatibility class>>choose:from: "
    )
! !

!stx_goodies_magritte class methodsFor:'description - contents'!

classNamesAndAttributes
    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'Magritte::MAAdaptiveModel'
        #'Magritte::MACompatibility'
        #'Magritte::MADescriptionBuilder'
        #'Magritte::MAError'
        #'Magritte::MAFileModel'
        #'Magritte::MAObject'
        #'Magritte::MAProxyObject'
        #'Magritte::MASortBlock'
        #'Magritte::MATableModel'
        #'Magritte::MAValueHolder'
        #'Magritte::MAVisitor'
        #'stx_goodies_magritte'
        #'Magritte::MAAccessor'
        #'Magritte::MACondition'
        #'Magritte::MADescription'
        #'Magritte::MADescriptionHolder'
        #'Magritte::MADynamicObject'
        #'Magritte::MAExternalFileModel'
        #'Magritte::MAGraphVisitor'
        #'Magritte::MAMemento'
        #'Magritte::MAMemoryFileModel'
        #'Magritte::MANamedBuilder'
        #'Magritte::MAPropertyError'
        #'Magritte::MAReadError'
        #'Magritte::MAStreamingVisitor'
        #'Magritte::MAValidationError'
        #'Magritte::MAWriteError'
        #'Magritte::MACachedMemento'
        #'Magritte::MAConditionError'
        #'Magritte::MAConflictError'
        #'Magritte::MAConjunctiveCondition'
        #'Magritte::MAContainer'
        #'Magritte::MADelegatorAccessor'
        #'Magritte::MADictionaryAccessor'
        #'Magritte::MAElementDescription'
        #'Magritte::MAIdentityAccessor'
        #'Magritte::MAKindError'
        #'Magritte::MAMultipleErrors'
        #'Magritte::MANegationCondition'
        #'Magritte::MANullAccessor'
        #'Magritte::MAPluggableAccessor'
        #'Magritte::MAPluggableCondition'
        #'Magritte::MARangeError'
        #'Magritte::MAReader'
        #'Magritte::MARequiredError'
        #'Magritte::MASelectorAccessor'
        #'Magritte::MAStraitMemento'
        #'Magritte::MAValidatorVisitor'
        #'Magritte::MAVariableAccessor'
        #'Magritte::MAWriter'
        #'Magritte::MABooleanDescription'
        #'Magritte::MAChainAccessor'
        #'Magritte::MACheckedMemento'
        #'Magritte::MAClassDescription'
        #'Magritte::MAColorDescription'
        #'Magritte::MAFileDescription'
        #'Magritte::MAMagnitudeDescription'
        #'Magritte::MAPriorityContainer'
        #'Magritte::MAReferenceDescription'
        #'Magritte::MAStringDescription'
        #'Magritte::MAStringReader'
        #'Magritte::MAStringWriter'
        #'Magritte::MADateDescription'
        #'Magritte::MADurationDescription'
        #'Magritte::MAMemoDescription'
        #'Magritte::MANumberDescription'
        #'Magritte::MAOptionDescription'
        #'Magritte::MAPasswordDescription'
        #'Magritte::MARelationDescription'
        #'Magritte::MASymbolDescription'
        #'Magritte::MATableDescription'
        #'Magritte::MATimeDescription'
        #'Magritte::MATimeStampDescription'
        #'Magritte::MATokenDescription'
        #'Magritte::MAMultipleOptionDescription'
        #'Magritte::MASingleOptionDescription'
        #'Magritte::MAToManyRelationDescription'
        #'Magritte::MAToOneRelationDescription'
        #'Magritte::MAToManyScalarRelationDescription'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are pairwise elements, consisting of class-name and selector."

    ^ #(
        Integer asFileSize
        Object basicDescription
        Object description
        Object initializeMagritte
        Object isDescription
        Object mementoClass
        Object readUsing:
        Object write:using:
        UndefinedObject asAccessor
        UndefinedObject label
        'Object class' description
        ArrayedCollection copyWithAll:
        Block asDynamicObject
        BlockContext asDynamicObject
        Class descriptionContainer
        Class label
        Collection asMultilineString
        Collection copyWithAll:
        Collection copyWithoutFirst:
        SequenceableCollection asAccessor
        SequenceableCollection moveDown:
        SequenceableCollection moveUp:
        SequenceableCollection reduce:
        String lines
        String matches:
        Symbol asAccessor
        Symbol isDescriptionDefinition
        Symbol isDescriptionExtension:
        Symbol isDescriptionSelector
        Object asComponent
        Symbol fixTemps
    )
! !

!stx_goodies_magritte class methodsFor:'description - project information'!

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

!stx_goodies_magritte class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/stx_goodies_magritte.st,v 1.4 2014-09-23 20:24:32 vrany Exp $'
! !

