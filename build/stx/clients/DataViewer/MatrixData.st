"{ NameSpace: TDV }"

Data subclass:#MatrixData
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Data'
!


!MatrixData class methodsFor:'instance creation'!

name:aName
"generates an instance of SimulationData (the instances initialize method will be called) and sets the name"

    ^ self new name:aName
!

new
"generate an instance of SimulationData and call the instances initialize method
"
    ^super basicNew initialize
! !

!MatrixData methodsFor:'accessing Y values'!

yValuesInto:anArray
"returns the y values in the array. The argument anArray is used to store the y values in.
The functionYblock is obligated to return the array used.
"
    ^functionYblock value:anArray

    "Modified: / 5.11.1998 / 12:35:29 / ps"
! !

!MatrixData class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/MatrixData.st,v 1.4 1999-04-23 15:22:53 cg Exp $'
! !
