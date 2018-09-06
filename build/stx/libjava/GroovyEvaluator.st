"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Object subclass:#GroovyEvaluator
	instanceVariableNames:'requestor source'
	classVariableNames:'WorkspaceShell'
	poolDictionaries:''
	category:'Languages-Groovy-Compiler'
!

!GroovyEvaluator class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!GroovyEvaluator class methodsFor:'evaluating'!

evaluate: source in: context receiver: receiver  notifying: requestor logged: log ifFail: failblock
    ^self new evaluate: source in: context receiver: receiver  notifying: requestor logged: log ifFail: failblock

    "Created: / 13-04-2012 / 17:24:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluate: source notifying: requestor 
    ^self new evaluate: source notifying: requestor

    "Created: / 18-02-2014 / 23:48:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyEvaluator class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!GroovyEvaluator class methodsFor:'utilities'!

flushWorkspaceBinding

    WorkspaceBinding := nil

    "Created: / 02-12-2011 / 23:23:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flushWorkspaceShell

    WorkspaceShell := nil

    "Created: / 02-09-2013 / 01:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyEvaluator methodsFor:'accessing'!

currentNameSpace: ns
    ns notNil ifTrue:[
        self error:'Smalltalk namespaces not supported by Groovy'
    ].

    "Created: / 01-08-2012 / 11:18:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentNamespace: ns
    self currentNameSpace: ns

    "Created: / 07-04-2012 / 09:26:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyEvaluator methodsFor:'compiler interface'!

evaluate:src
    | result |

    result := self evaluate:src in: nil receiver: nil notifying: nil logged: false ifFail: [self error:'Evaluation failed'].
    ^result.

    "Created: / 02-09-2011 / 10:24:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluate: sourceObj in: context receiver: receiver notifying: requestorObj logged: logged ifFail: fail 
    | shell bindings result isForWorkspace 
      groovyShellClass groovyBindingClass class |

    JavaVM booted ifFalse: [
        Java initialize.
        Error handle:[:ex |
            "/ no working JVM
            ^ Parser
                evaluate: sourceObj in: context receiver: receiver notifying: requestorObj logged: logged ifFail: fail 
        ] do:[
            JavaVM initializeVM.
        ].
    ].

    requestor := requestorObj.
    source := sourceObj.
    bindings := Dictionary new.
    isForWorkspace := requestor notNil and: [ requestor isKindOf: Workspace ].

    groovyShellClass := JAVA stx libjava groovy GroovyShell.
    groovyShellClass isNil ifTrue:[
        "/ no groovy
        ^ Parser
            evaluate: sourceObj in: context receiver: receiver notifying: requestorObj logged: logged ifFail: fail 
    ].
    groovyBindingClass := JavaVM classForName: 'groovy.lang.Binding'.

    shell := groovyShellClass new.

    isForWorkspace ifTrue: [
        Workspace workspaceVariables keysAndValuesDo:[:name :binding |
            bindings at: name put: (Array with: binding with: binding).
        ]
    ].
    bindings at: 'this' put: (Array with: receiver with: [ :v | "ignored" ]).
    bindings at: 'self' put: (bindings at: 'this').
    receiver notNil ifTrue:[
        | instvars |

        instvars := receiver class allInstVarNames.
        instvars withIndexDo:[:name :index|
            "/ Skip _lockWord_ - should be hidden...
            (name ~~ #_lockWord_) ifTrue:[
                bindings at: name put: (Array with: [ receiver instVarAt: index ] with: [ :v | receiver instVarAt: index put: v ])
            ].
        ].
    ].

    context notNil ifTrue:[
        | pc |

        bindings at: 'thisContext' put: (Array with: context with: [ :v | "ignored" ]).
        pc := context pc.
        context method localVariableTable do:[:entry|
            (pc between: entry startPC and: entry endPC) ifTrue:[
                bindings at: entry name put: (Array with: [ context at: entry slot + 1 ] with: [ :v | context at: entry slot + 1 put: v])
            ].
        ].
    ].

    class := receiver class theNonMetaclass.
    class isJavaClass ifTrue:[
        "/ Import all classes used by the receriver's class.
        class constantPool do:[:each|
            (each isJavaRef and:[each isJavaClassRef]) ifTrue:[
                | className |

                className := each javaClassName.
                className notNil ifTrue:[
                    shell addClassImport: className "asDottedJavaClassName. <-- not necessay, already dotted"
                ]
            ]
        ]
    ].

    result := self evaluate: source shell: shell bindings: bindings.    
    isForWorkspace ifTrue:[ 
        "/ Special hack to add newly created variables - bindings cannot handle this. 
        shell getContext getVariables keysAndValuesDo:[:name :value|
            Workspace workspaceVariables at: (Java as_ST_String: name) ifAbsentPut: [ (value class javaUnwrap: value) asValue ].
        ]
    ].
    ^result class javaUnwrap: result.

    "Created: / 17-08-2011 / 08:54:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-09-2016 / 12:04:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

evaluate:src notifying: requestorObj
    ^ self evaluate:src in: nil receiver: nil notifying: requestorObj logged: false ifFail: [self error:'Evaluation failed'].

    "Created: / 18-02-2014 / 23:48:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

moreSharedPools: pools

    "Ignored for Java"

    "Created: / 16-08-2011 / 10:15:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyEvaluator methodsFor:'compiler interface-private'!

evaluate: code shell: shell bindings: bindings
    "Evaluates `code` using given Groovy `shell`. Bind variables from
     bindings to shell's internal context. 

     `bindings` is a dictionary mapping variable names to pair { setter . getter }.
      Setters/getters are value models, i.e., they should respond to #value and #value:"

    |  result context |

    [
        context := shell getContext.
        bindings keysAndValuesDo:[:name :pair | 
            | value jvalue |

            value := pair first value.
            jvalue := value notNil 
                        ifTrue:[value class isJavaPrimitiveType ifTrue:[ value class javaWrapperClass javaWrap: value ] ifFalse:[ value ]]
                        ifFalse:[nil].
            context setVariable: name to: jvalue.
        ].
        [
            result := shell 
                        perform: #'evaluate(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;'
                        with: (Java as_String: code string)
                        with: (Java as_String: '$do$It$')
        ] ensure: [ 
            bindings keysAndValuesDo:[:name :pair | 
                | value |

                value := context getVariable: name.
                "/ Update variable if it has been changed during
                "/ evaluation
                value ~~ pair first value ifTrue:[ 
                    pair second value: (value class javaUnwrap: value).
                ].
            ].
        ].
    ] on: JAVA org codehaus groovy control CompilationFailedException do:[:ex|
        self syntaxError: ex.    
    ].

    ^ result class javaUnwrap: result.

    "Created: / 19-02-2014 / 09:13:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-04-2015 / 21:00:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyEvaluator methodsFor:'error reporting'!

syntaxError: exception
    | error cause |

    error := exception getErrorCollector getError: 0.
    cause := error getCause.
    self syntaxError: exception cause: cause.

    "Created: / 21-08-2012 / 14:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxError:message cause: cause
    "Notify requestor of an error - if there is no requestor
     put it on the transcript. Requestor is typically the CodeView
     in which the accept/doIt was triggered, or the PositionableStream
     which does the fileIn. The requestor may decide how to highlight the
     error (and/or to abort the compile).
     Return the result passed back by the requestor."

    | sourceStream startCol endCol |

    (Smalltalk isInitialized not and:[Smalltalk isStandAloneDebug]) ifTrue:[
        "/ error during startup, but sometimes we expect an error and want to supress it
        (Smalltalk at:#Parser) parseWarningSignal query ~~ #ignore ifTrue:[
            thisContext fullPrintAll.
        ].
    ].

    "/ backward compatibility - will vanish eventually (use a handler, Luke)

    sourceStream := source string readStream.
    cause getLine - 1 timesRepeat:[ sourceStream nextLine ].
    startCol := sourceStream position - 1 + cause getStartColumn.
    endCol := sourceStream position - 1 + cause getEndColumn.

    (requestor notNil and:[requestor isTextView]) ifTrue:[
        requestor error: cause getOriginalMessage position: startCol to: endCol from: self.
        ^ self
    ].
    ParseError isHandled ifTrue:[
        ParseError new
            errorMessage: cause getOriginalMessage startPosition:startCol endPosition:endCol;
            parameter:self;
            lineNumber:cause getLine;
            raiseRequest.
    ].

    "Created: / 21-08-2012 / 17:10:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyEvaluator class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/GroovyEvaluator.st,v 1.7 2015-03-20 12:07:59 vrany Exp $'
!

version_SVN
    ^ 'Id'
! !

