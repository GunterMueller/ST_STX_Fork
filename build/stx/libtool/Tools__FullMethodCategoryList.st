"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

MethodCategoryList subclass:#FullMethodCategoryList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!FullMethodCategoryList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    embeddable application displaying the classes as listed by
    the inputGenerator.
    Provides an outputGenerator, which enumerates the classes and
    their protocols (method-categories) in the selected classes.

    [author:]
	Claus Gittinger (cg@exept.de)
"


! !

!FullMethodCategoryList methodsFor:'generators'!

makeGenerator
    "return a generator which enumerates the methods from the selected protocol;
     that generator generates 4-element elements (includes the class and protocol), 
     in order to make the consumers only depend on one input 
     (i.e. to pass multiple-class and multiple-protocol info
      without a need for another classHolder/protocolHolder in the methodList)."

    ^ Iterator on:[:whatToDo |
                        |protocols all packages theProtocol|

                        protocols := self selectedProtocols value ? #().

                        all := protocols includes:(self class nameListEntryForALL).
                        packages := packageFilter value value.

                        protocols size > 0 ifTrue:[
                            protocols size == 1 ifTrue:[
                                theProtocol := protocols first.
                                environment allClassesDo:[:eachClass |
                                    eachClass instAndClassSelectorsAndMethodsDo:[:sel :eachMethod |
                                        |cat|

                                        cat := eachMethod category.
                                        (all 
                                        or:[theProtocol = cat]) ifTrue:[
                                            (packages isNil
                                            or:[packages includes:eachMethod package])
                                            ifTrue:[
                                                whatToDo value:eachClass value:cat value:sel value:eachMethod.
                                            ].
                                        ].
                                    ].
                                ]
                            ] ifFalse:[
                                environment allClassesDo:[:eachClass |
                                    eachClass instAndClassSelectorsAndMethodsDo:[:sel :eachMethod |
                                        |cat|

                                        cat := eachMethod category.
                                        (all 
                                        or:[protocols includes:cat]) ifTrue:[
                                            (packages isNil
                                            or:[packages includes:eachMethod package])
                                            ifTrue:[
                                                whatToDo value:eachClass value:cat value:sel value:eachMethod.
                                            ].
                                        ].
                                    ].
                                ]
                            ]
                        ]
                  ]
! !

!FullMethodCategoryList methodsFor:'private'!

listOfMethodCategories
    |categories|

    categories := Set new.

    categories addAll:MethodCategoryCache new allMethodCategories.    

    categories := categories asOrderedCollection sort.
    categories addFirst:(self class nameListEntryForALL).
    ^ categories
! !

!FullMethodCategoryList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools_FullMethodCategoryList.st,v 1.6 2013-09-05 10:46:11 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__FullMethodCategoryList.st 8083 2013-01-14 11:48:37Z vranyj1 $'
! !

