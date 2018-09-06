"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

ClassCategoryReader subclass:#MethodCategoriesReader
	instanceVariableNames:'methodSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!MethodCategoriesReader class methodsFor:'instance creation'!

class:aClass selector:aSelector
    "return a new MethodCategoriesReader to read categories for 
     aClasses method named aSelector"

    ^ self new class:aClass selector:aSelector
! !

!MethodCategoriesReader methodsFor:'fileIn'!

fileInFrom:aStream notifying:requestor passChunk:passChunk single:oneChunkOnly silent:beSilent
    "read method category-chunks from the input stream, aStream.
     Since ST/X only supports one category, only the first category is stored."

    |aString isFirst m category ignore|

    isFirst := true.
    [true] whileTrue:[
        aStream atEnd ifTrue:[^self].
        aString := aStream nextChunk.
        aStream skipSeparators.
        aString size == 0 ifTrue:[^self].

        isFirst ifTrue:[
            m := myClass compiledMethodAt:methodSelector.
            m isNil ifTrue:[
                Transcript showCR:'no method: ' , myClass name , '>>' , methodSelector.
            ] ifFalse:[
                category := aString asSymbol.
                ignore := false.
                m category notEmptyOrNil ifTrue:[
                    UserPreferences current ignorePublicPrivateCategories ifTrue:[
                        ( #( public private ) includes:category) ifTrue:[
                            ignore := true.
                        ].
                    ].
                ].
                ignore ifFalse:[
                    m category:category.
                ].
            ].
            isFirst := false.
        ].
    ]

    "Modified: / 23-09-2011 / 19:54:30 / cg"
! !

!MethodCategoriesReader methodsFor:'private'!

class:aClass selector:aSymbol
    myClass := aClass.
    methodSelector := aSymbol.
! !

!MethodCategoriesReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__MethodCategoriesReader.st,v 1.3 2011-10-01 11:09:45 vrany Exp $'
!

version_SVN
    ^ '§Id: Dolphin__MethodCategoriesReader.st,v 1.1 2011/07/05 18:09:55 cg Exp §'
! !
