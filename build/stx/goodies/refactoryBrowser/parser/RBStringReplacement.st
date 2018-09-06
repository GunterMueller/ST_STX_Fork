"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

Object subclass:#RBStringReplacement
	instanceVariableNames:'startPosition stopPosition string'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-AST-Nodes'
!

RBStringReplacement comment:'RBStringReplacement represents replacing source in the original method with a different string. These are used when reformatting code after a parse tree change has been made. Depending on the change, it may be possible to minimally change the parse tree without needing to format it.Instance Variables:	startPosition	<Integer>	the start position in the original source	stopPosition	<Integer>	the end position in the original source	string	<String>	replaces everything from the startPosition to the endPosition with this string'
!

!RBStringReplacement class methodsFor:'documentation'!

documentation
"
    RBStringReplacement represents replacing source in the original method with a different string. 
    These are used when reformatting code after a parse tree change has been made. 
    Depending on the change, it may be possible to minimally change the parse tree without needing to format it.

    Instance Variables:
        startPosition   <Integer>       the start position in the original source
        stopPosition    <Integer>       the end position in the original source
        string  <String>        replaces everything from the startPosition to the endPosition with this string
"
! !

!RBStringReplacement class methodsFor:'instance creation'!

replaceFrom: startInteger to: stopInteger with: aString 
	^(self new)
		startPosition: startInteger;
		stopPosition: stopInteger;
		string: aString;
		yourself
! !

!RBStringReplacement methodsFor:'accessing'!

startPosition
	^startPosition
!

stopPosition
	^stopPosition
!

string
	^string
! !

!RBStringReplacement methodsFor:'initialize-release'!

startPosition: anInteger 
	startPosition := anInteger
!

stopPosition: anInteger 
	stopPosition := anInteger
!

string: aString 
	string := aString
! !

!RBStringReplacement class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBStringReplacement.st,v 1.1 2014-03-04 23:34:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBStringReplacement.st,v 1.1 2014-03-04 23:34:58 cg Exp $'
! !

