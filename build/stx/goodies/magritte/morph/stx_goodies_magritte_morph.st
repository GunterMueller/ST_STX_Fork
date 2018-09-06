"{ Package: 'stx:goodies/magritte/morph' }"

LibraryDefinition subclass:#stx_goodies_magritte_morph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_magritte_morph class methodsFor:'description'!

preRequisites
    ^ #(
        #'stx:goodies/magritte'    "Magritte::MASingleOptionDescription - referenced by Magritte::MADescription class>>descriptionMorphClass "
        #'stx:libbasic'    "Object - superclass of Magritte::MAMultiSelectListMorph "
        #'stx:libcompat'    "SystemWindow - referenced by Magritte::MADescriptionMorph>>windowMorph "
        #'stx:libview'    "Color - referenced by Magritte::MADescriptionMorph>>rectangleMorph "
        #'stx:libview2'    "Model - superclass of Magritte::MASilentContainerMorph "
        #'stx:libview3'    "RectangleMorph - referenced by Magritte::MADescriptionMorph>>rectangleMorph "
    )
! !

!stx_goodies_magritte_morph class methodsFor:'description - contents'!

classNamesAndAttributes
    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'Magritte::MADescriptionMorph'
        #'stx_goodies_magritte_morph'
        #'Magritte::MAContainerMorph'
        #'Magritte::MAElementMorph'
        #'Magritte::MACheckboxMorph'
        #'Magritte::MAFileMorph'
        #'Magritte::MAListMorph'
        #'Magritte::MAMemoMorph'
        #'Magritte::MASilentContainerMorph'
        #'Magritte::MAMultiSelectListMorph'
        #'Magritte::MASingleSelectListMorph'
        #'Magritte::MATextMorph'
        #'Magritte::MAPasswordMorph'
    )
!

extensionMethodNames
    ^ #(
        #'Magritte::MAContainer' asMorphOn:
        #'Magritte::MADescription' morphClass
        #'Magritte::MADescription' morphClass:
        #'Magritte::MADescription' morphColor
        #'Magritte::MADescription' morphColor:
        Object asMorph
        'Magritte::MABooleanDescription class' defaultMorphClasses
        'Magritte::MAContainer class' defaultMorphClasses
        'Magritte::MADescription class' defaultMorphClass
        'Magritte::MADescription class' defaultMorphClasses
        'Magritte::MADescription class' defaultMorphColor
        'Magritte::MADescription class' descriptionMorphClass
        'Magritte::MAElementDescription class' defaultMorphClasses
        'Magritte::MAFileDescription class' defaultMorphClasses
        'Magritte::MAMemoDescription class' defaultMorphClasses
        'Magritte::MAMultipleOptionDescription class' defaultMorphClasses
        'Magritte::MAPasswordDescription class' defaultMorphClasses
        'Magritte::MASingleOptionDescription class' defaultMorphClasses
    )
! !

!stx_goodies_magritte_morph class methodsFor:'description - project information'!

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

!stx_goodies_magritte_morph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/stx_goodies_magritte_morph.st,v 1.1 2009-07-29 17:59:04 cg Exp $'
! !
