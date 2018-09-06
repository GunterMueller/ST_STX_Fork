"{ Package: 'stx:libdb/nosql/goods/tests' }"

KKAbstractDBTest subclass:#KKSlowDBTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!

KKSlowDBTest comment:'Tests that take a long time so you may not want to run them very often.'
!


!KKSlowDBTest methodsFor:'test commit collection'!

testStoreLargeCollection
        "Try to put a large collection into GOODS"

        | array |
        array := (1 to: 1024*1024) asOrderedCollection.
        dbOne root: Dictionary new.
        dbOne commit.
        dbOne root at: 'oc' put: array.
        dbOne commit.

"
 Time millisecondsToRun:[ self run: #testStoreLargeCollection ] 
 MessageTally spyOn:[ self run: #testStoreLargeCollection ] 
"
! !

!KKSlowDBTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKSlowDBTest.st,v 1.3 2013-03-31 23:34:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKSlowDBTest.st,v 1.3 2013-03-31 23:34:51 cg Exp $'
! !

