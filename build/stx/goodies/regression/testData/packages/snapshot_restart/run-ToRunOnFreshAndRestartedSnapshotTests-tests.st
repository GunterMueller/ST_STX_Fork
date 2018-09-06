Smalltalk beHeadless: true.
Smalltalk packagePath: (Smalltalk packagePath copyWith: (OperatingSystem pathOfSTXExecutable asFilename directory directory directory directory pathName)).

(Smalltalk at: #TestCase) isNil ifTrue:[
    Smalltalk loadPackage: 'stx:goodies/sunit'.
].

Smalltalk fileInClass: #'RegressionTests::SnapshotRestartTests' package: 'stx:goodies/regression'.

[
    Stdout nextPutAll:((Smalltalk at: #'RegressionTests::SnapshotRestartTests::ToRunOnFreshAndRestartedSnapshotTests') buildSuite run) printString.
    Stdout nextPutLine:' ### HERE ### '.
] on: Error do: [:ex|
    Stdout nextPutLine:'**** ERROR WHEN RUNNING TESTS ****'.
    ex suspendedContext fullPrintAllOn: Stdout.
].

Smalltalk addImageStartBlock: [
  [
    Stdout nextPutAll: ((Smalltalk at: #'RegressionTests::SnapshotRestartTests::ToRunOnFreshAndRestartedSnapshotTests') buildSuite run) printString.
    Stdout nextPutLine:' ### HERE ### ' .
    ] on: Error do: [:ex|
	Stdout nextPutLine:'**** ERROR WHEN RUNNING TESTS ****'.
	ex suspendedContext fullPrintAllOn: Stdout.
    ].
    Smalltalk exit: 0.
].
ObjectMemory snapShotOn:'restart.img' setImageName: false.
Smalltalk exit: 0.
