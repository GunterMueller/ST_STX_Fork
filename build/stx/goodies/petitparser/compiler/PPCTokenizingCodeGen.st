"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCCodeGen subclass:#PPCTokenizingCodeGen
	instanceVariableNames:'rememberStrategy errorStrategy'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Compiler-Codegen'
!


!PPCTokenizingCodeGen methodsFor:'code generation'!

codeScannerRememberTo: variableName 
    self codeAssign: 'scanner remember' to: variableName.
    self codeDot.
!

codeScannerRestoreFrom: variableName 
    self code: 'scanner restore: ', variableName.
    self codeDot.
                    
!

remember: node to: variableName 
    ^ self codeScannerRememberTo: variableName
!

restore: node from: mementoName
    ^ self codeScannerRestoreFrom: mementoName
! !

!PPCTokenizingCodeGen methodsFor:'initialization'!

initialize
    super initialize.
! !

!PPCTokenizingCodeGen class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

