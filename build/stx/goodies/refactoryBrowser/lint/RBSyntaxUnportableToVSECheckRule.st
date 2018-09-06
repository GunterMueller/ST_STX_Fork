"{ Encoding: utf8 }"

"
 Copyright (C) 2015 Claus Gittinger
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBParseTreeLintRule subclass:#RBSyntaxUnportableToVSECheckRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-VSE'
!

!RBSyntaxUnportableToVSECheckRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2015 Claus Gittinger
"
! !

!RBSyntaxUnportableToVSECheckRule class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^#( vse )
! !

!RBSyntaxUnportableToVSECheckRule methodsFor:'accessing'!

group
        ^ 'VSE Portability Issues'
!

name
    ^ 'Syntactic constructs not supported by VSE'
!

rationale
        ^ 'Checks for syntactic constructs which are not avaliable in VSE Smalltalk.
<P>
These are:
<li>thisContext
<li>Brace array constructor "{ ... }"
<p>
This is only of interest, if you plan to port the code to a VSE (Visual Smalltalk Enterprise) system.'
! !

!RBSyntaxUnportableToVSECheckRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
            matchesAnyOf: #(
                    'thisContext'                           "/ does not exist at all in VSE

                    '{ `@.arrayExpressionStatements }'      "/ does not exist at all in VSE
            )
            do: [ :node :answer | node ]
! !

!RBSyntaxUnportableToVSECheckRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

