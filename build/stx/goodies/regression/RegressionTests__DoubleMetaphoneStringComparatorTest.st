"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#DoubleMetaphoneStringComparatorTest
	instanceVariableNames:'dmsc'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

DoubleMetaphoneStringComparatorTest comment:'Tests for the DoubleMetaphoneStringComparator class.'
!


!DoubleMetaphoneStringComparatorTest methodsFor:'running'!

setUp

	dmsc := PhoneticStringUtilities::DoubleMetaphoneStringComparator new
! !

!DoubleMetaphoneStringComparatorTest methodsFor:'tests'!

testKeyMidStringFrom
	dmsc inputKey: 'A string of characters'.

	self should: [ (dmsc keyMidString: 3 from: 0) = ' A ' ].
	self should: [ (dmsc keyMidString: 5 from: 7) = 'NG OF' ].
	self should: [ (dmsc keyMidString: 4 from: 21) = 'RS  ' ].
!

testPerformInitialProcessing1
	dmsc inputKey: 'gneiss'.
	self should: [ dmsc inputKey = 'GNEISS' ].

	self should: [ dmsc startIndex = 1 ].
	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ (dmsc inputKey at: dmsc startIndex) = $G ].

	dmsc performInitialProcessing.

	self should: [ dmsc startIndex = 2 ].
	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ (dmsc inputKey at: dmsc startIndex) = $N ].
!

testPerformInitialProcessing2
	dmsc inputKey: 'zneiss'.
	self should: [ dmsc inputKey = 'ZNEISS' ].

	self should: [ dmsc startIndex = 1 ].
	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ (dmsc inputKey at: dmsc startIndex) = $Z ].

	dmsc performInitialProcessing.

	self should: [ dmsc startIndex = 1 ].
	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ (dmsc inputKey at: dmsc startIndex) = $Z ].
!

testPerformInitialProcessing3
	dmsc inputKey: 'xAvIeR'.
	self should: [ dmsc inputKey = 'XAVIER' ].

	self should: [ dmsc startIndex = 1 ].
	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ (dmsc inputKey at: dmsc startIndex) = $X ].

	dmsc performInitialProcessing.

	self should: [ dmsc startIndex = 2 ].
	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ (dmsc inputKey at: dmsc startIndex) = $A ].
!

testPerformInitialProcessing4
	dmsc inputKey: 'etaoinshrdlu'.
	self should: [ dmsc inputKey = 'ETAOINSHRDLU' ].

	self should: [ dmsc startIndex = 1 ].
	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ (dmsc inputKey at: dmsc startIndex) = $E ].

	dmsc performInitialProcessing.

	self should: [ dmsc startIndex = 2 ].
	self should: [ dmsc primaryTranslation = 'A' ].
	self should: [ dmsc secondaryTranslation = 'A' ].
	self should: [ (dmsc inputKey at: dmsc startIndex) = $T ].
!

testProcessB1
	dmsc inputKey: 'b'.
	self should: [ dmsc inputKey = 'B' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].

	dmsc processB.

	self should: [ dmsc primaryTranslation = 'P' ].
	self should: [ dmsc secondaryTranslation = 'P' ].
	self should: [ dmsc skipCount = 0 ]
!

testProcessB2
	dmsc inputKey: 'bb'.
	self should: [ dmsc inputKey = 'BB' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].

	dmsc processB.

	self should: [ dmsc primaryTranslation = 'P' ].
	self should: [ dmsc secondaryTranslation = 'P' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCedille
	dmsc inputKey: ''.
	self should: [ dmsc inputKey = '' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].

	dmsc processCedille.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
!

testProcessCi1
	dmsc inputKey: 'zzachxx'.
	self should: [ dmsc inputKey = 'ZZACHXX' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 2 ]
!

testProcessCii1
	dmsc inputKey: 'caesarian'.
	self should: [ dmsc inputKey = 'CAESARIAN' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	self should: [ dmsc currentIndex = 1 ].

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCiii1
	dmsc inputKey: 'chianti'.
	self should: [ dmsc inputKey = 'CHIANTI' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	self should: [ dmsc currentIndex = 1 ].

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCiva1
	dmsc inputKey: 'michael'.
	self should: [ dmsc inputKey = 'MICHAEL' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCivb1
	dmsc inputKey: 'character'.
	self should: [ dmsc inputKey = 'CHARACTER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	self should: [ dmsc currentIndex = 1 ].

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCivb2
	dmsc inputKey: 'chymerae'.
	self should: [ dmsc inputKey = 'CHYMERAE' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	self should: [ dmsc currentIndex = 1 ].

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCivc1
	dmsc inputKey: 'chymerae'.
	self should: [ dmsc inputKey = 'CHYMERAE' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	self should: [ dmsc currentIndex = 1 ].

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCivc2
	dmsc inputKey: 'orchestral'.
	self should: [ dmsc inputKey = 'ORCHESTRAL' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCivc3
	dmsc inputKey: 'mchugh'.
	self should: [ dmsc inputKey = 'MCHUGH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCivc4
	dmsc inputKey: 'xchugh'.
	self should: [ dmsc inputKey = 'XCHUGH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCivc5
	dmsc inputKey: 'chugh'.
	self should: [ dmsc inputKey = 'CHUGH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCix1
	dmsc inputKey: 'macgregor'.
	self should: [ dmsc inputKey = 'MACGREGOR' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCix2
	dmsc inputKey: 'zzzzcizzz'.
	self should: [ dmsc inputKey = 'ZZZZCIZZZ' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 5.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCv1
	dmsc inputKey: 'czarina'.
	self should: [ dmsc inputKey = 'CZARINA' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCvi1
	dmsc inputKey: 'focaccia'.
	self should: [ dmsc inputKey = 'FOCACCIA' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 5.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 2 ]
!

testProcessCvii11
	dmsc inputKey: 'accept'.
	self should: [ dmsc inputKey = 'ACCEPT' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'KS' ].
	self should: [ dmsc secondaryTranslation = 'KS' ].
	self should: [ dmsc skipCount = 2 ]
!

testProcessCvii12
	dmsc inputKey: 'succeed'.
	self should: [ dmsc inputKey = 'SUCCEED' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'KS' ].
	self should: [ dmsc secondaryTranslation = 'KS' ].
	self should: [ dmsc skipCount = 2 ]
!

testProcessCvii2
	dmsc inputKey: 'accord'.
	self should: [ dmsc inputKey = 'ACCORD' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 2 ]
!

testProcessCviii1
	dmsc inputKey: 'trucking'.
	self should: [ dmsc inputKey = 'TRUCKING' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCviii2
	dmsc inputKey: 'acquire'.
	self should: [ dmsc inputKey = 'ACQUIRE' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCviii3
	dmsc inputKey: 'macgregor'.
	self should: [ dmsc inputKey = 'MACGREGOR' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ]
!

testProcessCx1
	dmsc inputKey: 'abcdefg'.
	self should: [ dmsc inputKey = 'ABCDEFG' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 0 ]
!

testProcessCx1a
	dmsc inputKey: 'abcdefg'.
	self should: [ dmsc inputKey = 'ABCDEFG' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processC.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 0 ]
!

testProcessD1
	dmsc inputKey: 'edge'.
	self should: [ dmsc inputKey = 'EDGE' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processD.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessD2
	dmsc inputKey: 'edgar'.
	self should: [ dmsc inputKey = 'EDGAR' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processD.

	self should: [ dmsc primaryTranslation = 'TK' ].
	self should: [ dmsc secondaryTranslation = 'TK' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessD3
	dmsc inputKey: 'ludt'.
	self should: [ dmsc inputKey = 'LUDT' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processD.

	self should: [ dmsc primaryTranslation = 'T' ].
	self should: [ dmsc secondaryTranslation = 'T' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessD4
	dmsc inputKey: 'lud'.
	self should: [ dmsc inputKey = 'LUD' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processD.

	self should: [ dmsc primaryTranslation = 'T' ].
	self should: [ dmsc secondaryTranslation = 'T' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessF1

	dmsc inputKey: 'felt'.
	self should: [ dmsc inputKey = 'FELT' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processF.

	self should: [ dmsc primaryTranslation = 'F' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessF2
	dmsc inputKey: 'affenpinscher'.
	self should: [ dmsc inputKey = 'AFFENPINSCHER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processF.

	self should: [ dmsc primaryTranslation = 'F' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessG
	dmsc inputKey: 'bgh'.
	self should: [ dmsc inputKey = 'BGH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessG1
	dmsc inputKey: 'ghi'.
	self should: [ dmsc inputKey = 'GHI' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessG2
	dmsc inputKey: 'ghr'.
	self should: [ dmsc inputKey = 'GHR' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessG3
	dmsc inputKey: 'hugh'.
	self should: [ dmsc inputKey = 'HUGH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processG.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessG4
	dmsc inputKey: 'bough'.
	self should: [ dmsc inputKey = 'BOUGH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processG.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessG5
	dmsc inputKey: 'laugh'.
	self should: [ dmsc inputKey = 'LAUGH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'F' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessG6
	dmsc inputKey: 'McLaughlin'.
	self should: [ dmsc inputKey = 'MCLAUGHLIN' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 6.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'F' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessG7
	dmsc inputKey: 'cough'.
	self should: [ dmsc inputKey = 'COUGH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'F' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessG8
	dmsc inputKey: 'langh'.
	self should: [ dmsc inputKey = 'LANGH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessG9
	dmsc inputKey: 'agneiss'.
	self should: [ dmsc inputKey = 'AGNEISS' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'KN' ].
	self should: [ dmsc secondaryTranslation = 'N' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGa1
	dmsc inputKey: 'nignd'.
	self should: [ dmsc inputKey = 'NIGND' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'N' ].
	self should: [ dmsc secondaryTranslation = 'KN' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGa2
	dmsc inputKey: 'cagney'.
	self should: [ dmsc inputKey = 'CAGNEY' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'KN' ].
	self should: [ dmsc secondaryTranslation = 'KN' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGa3
	dmsc inputKey: 'tagliaro'.
	self should: [ dmsc inputKey = 'TAGLIARO' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'KL' ].
	self should: [ dmsc secondaryTranslation = 'L' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGa4
	dmsc inputKey: 'GY'.
	self should: [ dmsc inputKey = 'GY' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGa5
	dmsc inputKey: 'GES'.
	self should: [ dmsc inputKey = 'GES' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGa6
	dmsc inputKey: 'GEP'.
	self should: [ dmsc inputKey = 'GEP' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGa7
	dmsc inputKey: 'GEB'.
	self should: [ dmsc inputKey = 'GEB' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGa8
	dmsc inputKey: 'GEL'.
	self should: [ dmsc inputKey = 'GEL' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGa9
	dmsc inputKey: 'GEY'.
	self should: [ dmsc inputKey = 'GEY' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGb2
	dmsc inputKey: 'gil'.
	self should: [ dmsc inputKey = 'GIL' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGb3
	dmsc inputKey: 'gin'.
	self should: [ dmsc inputKey = 'GIN' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGb4
	dmsc inputKey: 'gei'.
	self should: [ dmsc inputKey = 'GEI' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGb4a
	dmsc inputKey: 'gie'.
	self should: [ dmsc inputKey = 'GIE' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGb5
	dmsc inputKey: 'ger'.
	self should: [ dmsc inputKey = 'GER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGb6
	dmsc inputKey: 'nger'.
	self should: [ dmsc inputKey = 'NGER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGb7
	dmsc inputKey: 'danger'.
	self should: [ dmsc inputKey = 'DANGER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGb8
	dmsc inputKey: 'biaggi'.
	self should: [ dmsc inputKey = 'BIAGGI' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGb9
	dmsc inputKey: 'von biaggi'.
	self should: [ dmsc inputKey = 'VON BIAGGI' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 8.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGc1
	dmsc inputKey: 'biagier'.
	self should: [ dmsc inputKey = 'BIAGIER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGc2
	dmsc inputKey: 'bigger'.
	self should: [ dmsc inputKey = 'BIGGER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessGc3
	dmsc inputKey: 'grass'.
	self should: [ dmsc inputKey = 'GRASS' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processG.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessH
	dmsc inputKey: 'Hannah'.
	self should: [ dmsc inputKey = 'HANNAH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processH.

	self should: [ dmsc primaryTranslation = 'H' ].
	self should: [ dmsc secondaryTranslation = 'H' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessH2
	dmsc inputKey: 'aha'.
	self should: [ dmsc inputKey = 'AHA' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processH.

	self should: [ dmsc primaryTranslation = 'H' ].
	self should: [ dmsc secondaryTranslation = 'H' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessH3
	dmsc inputKey: 'doah'.
	self should: [ dmsc inputKey = 'DOAH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processH.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessJ
	dmsc inputKey: 'jose'.
	self should: [ dmsc inputKey = 'JOSE' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processJ.

	self should: [ dmsc primaryTranslation = 'H' ].
	self should: [ dmsc secondaryTranslation = 'H' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessJ1
	dmsc inputKey: 'san jacinto'.
	self should: [ dmsc inputKey = 'SAN JACINTO' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processJ.

	self should: [ dmsc primaryTranslation = 'H' ].
	self should: [ dmsc secondaryTranslation = 'H' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessJ2
	dmsc inputKey: 'Jankelowicz'.
	self should: [ dmsc inputKey = 'JANKELOWICZ' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processJ.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = 'A' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessJ3
	dmsc inputKey: 'bajador'.
	self should: [ dmsc inputKey = 'BAJADOR' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processJ.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = 'H' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessJ4
	dmsc inputKey: 'borj'.
	self should: [ dmsc inputKey = 'BORJ' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processJ.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = ' ' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessJ5
	dmsc inputKey: 'bjl'.
	self should: [ dmsc inputKey = 'BJL' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processJ.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessJ6
	dmsc inputKey: 'bjC'.
	self should: [ dmsc inputKey = 'BJC' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processJ.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessJ7
	dmsc inputKey: 'bjj'.
	self should: [ dmsc inputKey = 'BJJ' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processJ.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessK
	dmsc inputKey: 'talk'.
	self should: [ dmsc inputKey = 'TALK' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processK.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessK1
	dmsc inputKey: 'talkk'.
	self should: [ dmsc inputKey = 'TALKK' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processK.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessL
	dmsc inputKey: 'llamma'.
	self should: [ dmsc inputKey = 'LLAMMA' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processL.

	self should: [ dmsc primaryTranslation = 'L' ].
	self should: [ dmsc secondaryTranslation = 'L' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessL1
	dmsc inputKey: 'camilla'.
	self should: [ dmsc inputKey = 'CAMILLA' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 5.

	dmsc processL.

	self should: [ dmsc primaryTranslation = 'L' ].
	self should: [ dmsc secondaryTranslation = ' ' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessL2
	dmsc inputKey: 'cabrillo'.
	self should: [ dmsc inputKey = 'CABRILLO' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 6.

	dmsc processL.

	self should: [ dmsc primaryTranslation = 'L' ].
	self should: [ dmsc secondaryTranslation = ' ' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessL3
	dmsc inputKey: 'lisa'.
	self should: [ dmsc inputKey = 'LISA' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processL.

	self should: [ dmsc primaryTranslation = 'L' ].
	self should: [ dmsc secondaryTranslation = 'L' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessM
	dmsc inputKey: 'dumb'.
	self should: [ dmsc inputKey = 'DUMB' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processM.

	self should: [ dmsc primaryTranslation = 'M' ].
	self should: [ dmsc secondaryTranslation = 'M' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessM1
	dmsc inputKey: 'thumb'.
	self should: [ dmsc inputKey = 'THUMB' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processM.

	self should: [ dmsc primaryTranslation = 'M' ].
	self should: [ dmsc secondaryTranslation = 'M' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessM2
	dmsc inputKey: 'mmum'.
	self should: [ dmsc inputKey = 'MMUM' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processM.

	self should: [ dmsc primaryTranslation = 'M' ].
	self should: [ dmsc secondaryTranslation = 'M' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessM3
	dmsc inputKey: 'mom'.
	self should: [ dmsc inputKey = 'MOM' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processM.

	self should: [ dmsc primaryTranslation = 'M' ].
	self should: [ dmsc secondaryTranslation = 'M' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessN
	dmsc inputKey: 'tin'.
	self should: [ dmsc inputKey = 'TIN' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processN.

	self should: [ dmsc primaryTranslation = 'N' ].
	self should: [ dmsc secondaryTranslation = 'N' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessN1
	dmsc inputKey: 'TINN'.
	self should: [ dmsc inputKey = 'TINN' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processN.

	self should: [ dmsc primaryTranslation = 'N' ].
	self should: [ dmsc secondaryTranslation = 'N' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessNtilde
	dmsc inputKey: 'Naa'.
	self should: [ dmsc inputKey = 'NAA' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processNtilde.

	self should: [ dmsc primaryTranslation = 'N' ].
	self should: [ dmsc secondaryTranslation = 'N' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessP
	dmsc inputKey: 'phone'.
	self should: [ dmsc inputKey = 'PHONE' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processP.

	self should: [ dmsc primaryTranslation = 'F' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessP1
	dmsc inputKey: 'campbell'.
	self should: [ dmsc inputKey = 'CAMPBELL' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 4.

	dmsc processP.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessP2
	dmsc inputKey: 'peanut'.
	self should: [ dmsc inputKey = 'PEANUT' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processP.

	self should: [ dmsc primaryTranslation = 'P' ].
	self should: [ dmsc secondaryTranslation = 'P' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessQ
	dmsc inputKey: 'quiet'.
	self should: [ dmsc inputKey = 'QUIET' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processQ.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessQ1
	dmsc inputKey: 'qquiet'.
	self should: [ dmsc inputKey = 'QQUIET' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processQ.

	self should: [ dmsc primaryTranslation = 'K' ].
	self should: [ dmsc secondaryTranslation = 'K' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessR
	dmsc inputKey: 'rogier'.
	self should: [ dmsc inputKey = 'ROGIER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 6.

	dmsc processR.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = 'R' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessR1
	dmsc inputKey: 'hochmeier'.
	self should: [ dmsc inputKey = 'HOCHMEIER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 9.

	dmsc processR.

	self should: [ dmsc primaryTranslation = 'R' ].
	self should: [ dmsc secondaryTranslation = 'R' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessR2
	dmsc inputKey: 'french'.
	self should: [ dmsc inputKey = 'FRENCH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processR.

	self should: [ dmsc primaryTranslation = 'R' ].
	self should: [ dmsc secondaryTranslation = 'R' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessR3
	dmsc inputKey: 'frrench'.
	self should: [ dmsc inputKey = 'FRRENCH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processR.

	self should: [ dmsc primaryTranslation = 'R' ].
	self should: [ dmsc secondaryTranslation = 'R' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessS
	dmsc inputKey: 'island'.
	self should: [ dmsc inputKey = 'ISLAND' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processS.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessS1
	dmsc inputKey: 'isle'.
	self should: [ dmsc inputKey = 'ISLE' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 2.

	dmsc processS.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessS2
	dmsc inputKey: 'carlisle'.
	self should: [ dmsc inputKey = 'CARLISLE' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 6.

	dmsc processS.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessS3
	dmsc inputKey: 'carlysle'.
	self should: [ dmsc inputKey = 'CARLYSLE' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 6.

	dmsc processS.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessS4
	dmsc inputKey: 'sugar'.
	self should: [ dmsc inputKey = 'SUGAR' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessS5
	dmsc inputKey: 'sheim'.
	self should: [ dmsc inputKey = 'SHEIM' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessS6
	dmsc inputKey: 'shook'.
	self should: [ dmsc inputKey = 'SHOOK' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessS7
	dmsc inputKey: 'sio'.
	self should: [ dmsc inputKey = 'SIO' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessS8
	dmsc inputKey: 'sian'.
	self should: [ dmsc inputKey = 'SIAN' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessS9
	dmsc inputKey: 'siowitz'.
	self should: [ dmsc inputKey = 'SIOWITZ' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessSa1
	dmsc inputKey: 'smith'.
	self should: [ dmsc inputKey = 'SMITH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessSa2
	dmsc inputKey: 'snider'.
	self should: [ dmsc inputKey = 'SNIDER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessSa3
	dmsc inputKey: 'szan'.
	self should: [ dmsc inputKey = 'SZAN' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessSa4
	dmsc inputKey: 'school'.
	self should: [ dmsc inputKey = 'SCHOOL' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'SK' ].
	self should: [ dmsc secondaryTranslation = 'SK' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessSa5
	dmsc inputKey: 'schenker'.
	self should: [ dmsc inputKey = 'SCHENKER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'SK' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessSa6
	dmsc inputKey: 'schank'.
	self should: [ dmsc inputKey = 'SCHANK' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessSa7
	dmsc inputKey: 'schbnk'.
	self should: [ dmsc inputKey = 'SCHBNK' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessSa8
	dmsc inputKey: 'schwnk'.
	self should: [ dmsc inputKey = 'SCHWNK' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessSa9
	dmsc inputKey: 'scewnk'.
	self should: [ dmsc inputKey = 'SCEWNK' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessSb1
	dmsc inputKey: 'scawnk'.
	self should: [ dmsc inputKey = 'SCAWNK' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'SK' ].
	self should: [ dmsc secondaryTranslation = 'SK' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessSb2
	dmsc inputKey: 'resnais'.
	self should: [ dmsc inputKey = 'RESNAIS' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 7.

	dmsc processS.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessSb3
	dmsc inputKey: 'resnas'.
	self should: [ dmsc inputKey = 'RESNAS' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 6.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessSb4
	dmsc inputKey: 'resnass'.
	self should: [ dmsc inputKey = 'RESNASS' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 6.

	dmsc processS.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessT1
	dmsc inputKey: 'action'.
	self should: [ dmsc inputKey = 'ACTION' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processT.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessT2
	dmsc inputKey: 'actia'.
	self should: [ dmsc inputKey = 'ACTIA' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processT.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessT3
	dmsc inputKey: 'actch'.
	self should: [ dmsc inputKey = 'ACTCH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processT.

	self should: [ dmsc primaryTranslation = 'X' ].
	self should: [ dmsc secondaryTranslation = 'X' ].
	self should: [ dmsc skipCount = 2 ].
!

testProcessT4
	dmsc inputKey: 'thomas'.
	self should: [ dmsc inputKey = 'THOMAS' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processT.

	self should: [ dmsc primaryTranslation = 'T' ].
	self should: [ dmsc secondaryTranslation = 'T' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessT5
	dmsc inputKey: 'thames'.
	self should: [ dmsc inputKey = 'THAMES' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processT.

	self should: [ dmsc primaryTranslation = 'T' ].
	self should: [ dmsc secondaryTranslation = 'T' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessT6
	dmsc inputKey: 'von thrapp'.
	self should: [ dmsc inputKey = 'VON THRAPP' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 5.

	dmsc processT.

	self should: [ dmsc primaryTranslation = 'T' ].
	self should: [ dmsc secondaryTranslation = 'T' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessT7
	dmsc inputKey: 'schrthop'.
	self should: [ dmsc inputKey = 'SCHRTHOP' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 5.

	dmsc processT.

	self should: [ dmsc primaryTranslation = 'T' ].
	self should: [ dmsc secondaryTranslation = 'T' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessT8
	dmsc inputKey: 'thrap'.
	self should: [ dmsc inputKey = 'THRAP' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processT.

	self should: [ dmsc primaryTranslation = '0' ].
	self should: [ dmsc secondaryTranslation = 'T' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessT9
	dmsc inputKey: 'ttrump'.
	self should: [ dmsc inputKey = 'TTRUMP' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processT.

	self should: [ dmsc primaryTranslation = 'T' ].
	self should: [ dmsc secondaryTranslation = 'T' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessTa1
	dmsc inputKey: 'trump'.
	self should: [ dmsc inputKey = 'TRUMP' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processT.

	self should: [ dmsc primaryTranslation = 'T' ].
	self should: [ dmsc secondaryTranslation = 'T' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessV
	dmsc inputKey: 'violet'.
	self should: [ dmsc inputKey = 'VIOLET' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processV.

	self should: [ dmsc primaryTranslation = 'F' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessV1
	dmsc inputKey: 'vviolet'.
	self should: [ dmsc inputKey = 'VVIOLET' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processV.

	self should: [ dmsc primaryTranslation = 'F' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessW
	dmsc inputKey: 'wreath'.
	self should: [ dmsc inputKey = 'WREATH' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processW.

	self should: [ dmsc primaryTranslation = 'R' ].
	self should: [ dmsc secondaryTranslation = 'R' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessW1
	dmsc inputKey: 'water'.
	self should: [ dmsc inputKey = 'WATER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processW.

	self should: [ dmsc primaryTranslation = 'A' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessW2
	dmsc inputKey: 'whether'.
	self should: [ dmsc inputKey = 'WHETHER' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processW.

	self should: [ dmsc primaryTranslation = 'A' ].
	self should: [ dmsc secondaryTranslation = 'A' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessW3
	dmsc inputKey: 'Arnow'.
	self should: [ dmsc inputKey = 'ARNOW' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 5.

	dmsc processW.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessW4
	dmsc inputKey: 'belewski'.
	self should: [ dmsc inputKey = 'BELEWSKI' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 5.

	dmsc processW.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessW5
	dmsc inputKey: 'schewell'.
	self should: [ dmsc inputKey = 'SCHEWELL' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 5.

	dmsc processW.

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = 'F' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessW6
	dmsc inputKey: 'filipowicz'.
	self should: [ dmsc inputKey = 'FILIPOWICZ' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 7.

	dmsc processW.

	self should: [ dmsc primaryTranslation = 'TS' ].
	self should: [ dmsc secondaryTranslation = 'FX' ].
	self should: [ dmsc skipCount = 3 ].
!

testProcessX
	dmsc inputKey: 'breaux'.
	self should: [ dmsc inputKey = 'BREAUX' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 6.

	dmsc processX.

	self should: [ dmsc primaryTranslation = 'KS' ].
	self should: [ dmsc secondaryTranslation = 'KS' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessX1
	dmsc inputKey: 'bordoux'.
	self should: [ dmsc inputKey = 'BORDOUX' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 7.

	dmsc processX.

	self should: [ dmsc primaryTranslation = 'KS' ].
	self should: [ dmsc secondaryTranslation = 'KS' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessX2
	dmsc inputKey: 'shoroxx'.
	self should: [ dmsc inputKey = 'SHOROXX' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 6.

	dmsc processX.

	self should: [ dmsc primaryTranslation = 'KS' ].
	self should: [ dmsc secondaryTranslation = 'KS' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessZ
	dmsc inputKey: 'zhao'.
	self should: [ dmsc inputKey = 'ZHAO' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processZ.

	self should: [ dmsc primaryTranslation = 'J' ].
	self should: [ dmsc secondaryTranslation = 'J' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessZ1
	dmsc inputKey: 'pizza'.
	self should: [ dmsc inputKey = 'PIZZA' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 3.

	dmsc processZ.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'TS' ].
	self should: [ dmsc skipCount = 1 ].
!

testProcessZ2
	dmsc inputKey: 'wkicz'.
	self should: [ dmsc inputKey = 'WKICZ' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 5.

	dmsc processZ.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'TS' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessZ3
	dmsc inputKey: 'zoo'.
	self should: [ dmsc inputKey = 'ZOO' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processZ.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 0 ].
!

testProcessZ4
	dmsc inputKey: 'zzyxx'.
	self should: [ dmsc inputKey = 'ZZYXX' ].

	self should: [ dmsc primaryTranslation = '' ].
	self should: [ dmsc secondaryTranslation = '' ].
	self should: [ dmsc skipCount = 0 ].
	dmsc currentIndex: 1.

	dmsc processZ.

	self should: [ dmsc primaryTranslation = 'S' ].
	self should: [ dmsc secondaryTranslation = 'S' ].
	self should: [ dmsc skipCount = 1 ].
! !

!DoubleMetaphoneStringComparatorTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

