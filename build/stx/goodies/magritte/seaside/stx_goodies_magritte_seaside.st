"{ Package: 'stx:goodies/magritte/seaside' }"

LibraryDefinition subclass:#stx_goodies_magritte_seaside
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_magritte_seaside class methodsFor:'description'!

preRequisites
    ^ #(
        #'stx:goodies/magritte'    "Magritte::MAObject - superclass of Magritte::MAColumn "
        #'stx:goodies/webServer/comanche/seaside2_5b4'    "WAPresenter - superclass of Magritte::MATimeSelectorComponent "
        #'stx:libbasic'    "Object - superclass of Magritte::MATableComponent "
        #'stx:libview'    "Color - referenced by Magritte::MAColorComponent>>form "
    )
! !

!stx_goodies_magritte_seaside class methodsFor:'description - contents'!

classNamesAndAttributes
    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'Magritte::MAColumn'
        #'Magritte::MAComponent'
        #'Magritte::MAComponentDecoration'
        #'Magritte::MAComponentRenderer'
        #'Magritte::MAExampleEditor'
        #'Magritte::MAFileModelHandler'
        #'stx_goodies_magritte_seaside'
        #'Magritte::MAActionColumn'
        #'Magritte::MAColorChooser'
        #'Magritte::MAContainerDecoration'
        #'Magritte::MACssRenderer'
        #'Magritte::MADescribedColumn'
        #'Magritte::MADescriptionComponent'
        #'Magritte::MADescriptionEditor'
        #'Magritte::MAReport'
        #'Magritte::MATableRenderer'
        #'Magritte::MAValidationDecoration'
        #'Magritte::MACommandColumn'
        #'Magritte::MAContainerComponent'
        #'Magritte::MADescribedComponentColumn'
        #'Magritte::MADescribedScalarColumn'
        #'Magritte::MAElementComponent'
        #'Magritte::MAFormDecoration'
        #'Magritte::MAReportComponent'
        #'Magritte::MASelectionColumn'
        #'Magritte::MASwitchDecoration'
        #'Magritte::MAToggleColumn'
        #'Magritte::MACheckboxColumn'
        #'Magritte::MACheckboxComponent'
        #'Magritte::MAColorComponent'
        #'Magritte::MAFileUploadComponent'
        #'Magritte::MAIndexedCommandColumn'
        #'Magritte::MAOptionComponent'
        #'Magritte::MAOptionboxColumn'
        #'Magritte::MARangeComponent'
        #'Magritte::MARelationComponent'
        #'Magritte::MATableComponent'
        #'Magritte::MATextAreaComponent'
        #'Magritte::MATextInputComponent'
        #'Magritte::MATextPasswordComponent'
        #'Magritte::MAUndefinedComponent'
        #'Magritte::MADateInputComponent'
        #'Magritte::MAMultipleSelectionComponent'
        #'Magritte::MAOneToManyComponent'
        #'Magritte::MAOneToOneComponent'
        #'Magritte::MASingleSelectionComponent'
        #'Magritte::MATimeInputComponent'
        #'Magritte::MATimeStampInputComponent'
        #'Magritte::MAVerifiedPasswordComponent'
        #'Magritte::MACheckboxGroupComponent'
        #'Magritte::MADateSelectorComponent'
        #'Magritte::MAExternalEditorComponent'
        #'Magritte::MAInternalEditorComponent'
        #'Magritte::MAListCompositonComponent'
        #'Magritte::MAMultiselectListComponent'
        #'Magritte::MAOneToManyScalarComponent'
        #'Magritte::MARadioGroupComponent'
        #'Magritte::MASelectListComponent'
        #'Magritte::MATimeSelectorComponent'
    )
!

extensionMethodNames
    ^ #(
        #'Magritte::MAContainer' asComponentOn:
        #'Magritte::MAContainer' componentRenderer
        #'Magritte::MAContainer' componentRenderer:
        #'Magritte::MADescription' componentClass
        #'Magritte::MADescription' componentClass:
        #'Magritte::MADescription' cssClass:
        #'Magritte::MADescription' cssClasses
        #'Magritte::MADescription' cssClasses:
        #'Magritte::MADescription' reportColumnClass
        #'Magritte::MADescription' reportColumnClass:
        #'Magritte::MAElementDescription' checkboxLabel
        #'Magritte::MAElementDescription' checkboxLabel:
        #'Magritte::MAExternalFileModel' urlFor:
        #'Magritte::MAFileModel' renderOn:
        #'Magritte::MAFileModel' urlFor:
        #'Magritte::MAFileModel' urlOn:
        #'Magritte::MAMultipleErrors' renderOn:
        Object asComponent
        Symbol fixTemps
        WAComponent isMagritteContainer
        'Magritte::MABooleanDescription class' defaultComponentClasses
        'Magritte::MAClassDescription class' defaultComponentClasses
        'Magritte::MAColorDescription class' defaultComponentClasses
        'Magritte::MAContainer class' defaultComponentClasses
        'Magritte::MAContainer class' defaultComponentRenderer
        'Magritte::MADateDescription class' defaultComponentClasses
        'Magritte::MADescription class' defaultComponentClass
        'Magritte::MADescription class' defaultComponentClasses
        'Magritte::MADescription class' defaultCssClasses
        'Magritte::MADescription class' defaultReportColumnClass
        'Magritte::MADescription class' defaultReportColumnClasses
        'Magritte::MADescription class' descriptionComponentClass
        'Magritte::MADescription class' descriptionReportColumnClass
        'Magritte::MADescription class' grouping
        'Magritte::MADurationDescription class' defaultComponentClasses
        'Magritte::MAFileDescription class' defaultComponentClasses
        'Magritte::MAMemoDescription class' defaultComponentClasses
        'Magritte::MAMultipleOptionDescription class' defaultComponentClasses
        'Magritte::MANumberDescription class' defaultComponentClasses
        'Magritte::MAPasswordDescription class' defaultComponentClasses
        'Magritte::MASingleOptionDescription class' defaultComponentClasses
        'Magritte::MAStringDescription class' defaultComponentClasses
        'Magritte::MATableDescription class' defaultComponentClasses
        'Magritte::MATimeDescription class' defaultComponentClasses
        'Magritte::MATimeStampDescription class' defaultComponentClasses
        'Magritte::MAToManyRelationDescription class' defaultComponentClasses
        'Magritte::MAToManyScalarRelationDescription class' defaultComponentClasses
        'Magritte::MAToManyScalarRelationDescription class' defaultReportColumnClasses
        'Magritte::MAToOneRelationDescription class' defaultComponentClasses
        'Magritte::MATokenDescription class' defaultComponentClasses
    )
! !

!stx_goodies_magritte_seaside class methodsFor:'description - project information'!

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

!stx_goodies_magritte_seaside class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/stx_goodies_magritte_seaside.st,v 1.1 2009-07-29 15:41:23 cg Exp $'
! !
