"
 Copyright (C) 2014 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBParseTreeLintRule subclass:#RBFileStreamPossiblyNotClosedRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Experimental Rules'
!

!RBFileStreamPossiblyNotClosedRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2014 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
!

documentation
"
    UNFINIHSED, but somewhat working.
    TODO: also check for ifCurtailed, valueNowOrOnUnwindDo: and valueOnUnwindDo:
"
! !

!RBFileStreamPossiblyNotClosedRule methodsFor:'accessing'!

group
        ^ 'Possible Bugs'
!

name
        ^ 'Filestream is opened but possibly not closed (missing ensure action)'
!

rationale
        ^ 'Methods which open a file stream should be prepared for being aborted,
and protect against that by an ensure block.
<P>
This is an unfinished lint rule under construction.'
! !

!RBFileStreamPossiblyNotClosedRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher 
                matchesAnyOf: #(
                        '  `@.statements1 .
                           `var := `@expr1 asFilename readStream.  
                           `@.statements2'

                        '  `@.statements1 .
                           `var := FileStream oldFileNamed: `@expr1.  
                           `@.statements2'

                        '  `@.statements1 .
                           `var := FileStream oldFileNamed: `@expr1 in: `@expr2.  
                           `@.statements2'

                        '  `@.statements1 .
                           `var := FileStream open: `@expr1 withMode: `@expr2.  
                           `@.statements2'

                        '  `@.statements1 .
                           `var := FileStream newFileNamed: `@expr1 .  
                           `@.statements2'

                        '  `@.statements1 .
                           `var := FileStream newFileNamed: `@expr1 in: `@expr2.  
                           `@.statements2'
                         )
                do: [ :node :answer |
                    |msgs searcher|

                    msgs := node topNode sentMessages.
                    ((msgs includes:#close) not 
                    or:[(msgs includesAny:#(ensure: ifCurtailed: #valueOnUnwindDo: #valueNowOrOnUnwindDo:)) not])
                    ifTrue:[
                        "/ definitely no unwind protection or close in here
                        node
                    ] ifFalse:[
                        searcher := ParseTreeSearcher new.
                        searcher
                            matchesAnyOf:#(
                                '  `@.statements1 .
                                   `var := `@expr1 asFilename readStream.  
                                   [
                                      `@.statements2
                                   ] ensure: [
                                      `@.statements3.
                                      var close.
                                      `@.statements4
                                   ].
                                  `@.statements5'
                            )
                            do:[:aNode :answer | true ].

                            (searcher executeTree:node topNode initialAnswer:false) ifFalse:[
                                node
                            ] ifTrue:[
                                answer
                            ].
                    ].
                ]
! !

!RBFileStreamPossiblyNotClosedRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

