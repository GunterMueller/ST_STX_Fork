"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#SortTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!

!SortTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	mb (mb@sixtyfour)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SortTests methodsFor:'helpers'!

checkSort:data
     |mergeSorted quickSorted definitivelySorted|

     definitivelySorted := self goodSort:(data copy).

     mergeSorted := data copy mergeSort.
     self assert:(mergeSorted isSorted).
     self assert:(mergeSorted = definitivelySorted).

     quickSorted := data copy quickSort.
     self assert:(quickSorted isSorted).
     self assert:(quickSorted = definitivelySorted).
!

goodSort:data
     |tree|

     tree := BinaryTree withAll:data.
     ^ tree asArray
! !

!SortTests methodsFor:'tests'!

test01_smallArrays
     self checkSort: #(1 16 7 98 3 19 4 0).
     self checkSort: #(1 16 7 98 9 3 19 4 0).

     self checkSort: #(1 16 7 98 7 1 3 19 4 0).
     self checkSort: #(1 16 7 98 7 1 3 19 4 0).
!

test02_largeArrays
     |data|

     data := (1 to:22581) collect:[:i | Random nextInteger] as:Array.

     self checkSort: data.
! !

!SortTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

