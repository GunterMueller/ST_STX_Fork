"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2016 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

AbstractJavaCompletionEngine subclass:#JavaCompletionEngine
	instanceVariableNames:'completionNode completionScope'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Java'
!

!JavaCompletionEngine class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2016 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!JavaCompletionEngine methodsFor:'completion-individual'!

addFieldsForTypeBinding:binding
    | current |

    current := binding.        
    [ current notNil ] whileTrue:[  
        current fields do:[:fbinding | 
            result add: (PO forFieldBinding: fbinding )
        ].  
        current := current superclass.
    ].

    "Created: / 13-08-2014 / 21:39:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-08-2014 / 09:06:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMethodsForReceiver: maybeReceiverToken startingWith: prefix    
    ^ self addMethodsStartingWith: prefix

    "Created: / 03-10-2013 / 17:46:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMethodsForTypeBinding: binding
    | current seen |

    current := binding.        
    seen := Set new.
    [ current notNil ] whileTrue:[  
        current methods do:[:mbinding |
            mbinding isConstructor ifFalse:[
                | selector |

                selector := mbinding selector , mbinding signature.
                (seen includes: selector) ifFalse:[
                    result add: (PO forMethodBinding: mbinding).
                    seen add: selector.
                ].
            ].
        ].  
        current := current superclass.
    ].

    "Created: / 13-08-2014 / 21:39:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-08-2014 / 22:54:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addVariablesInScope: scope
    ((scope kind == JAVA org eclipse jdt internal compiler lookup Scope METHOD_SCOPE) or:[
    scope kind == JAVA org eclipse jdt internal compiler lookup Scope BLOCK_SCOPE]) ifTrue:[ 
        1 to: scope localIndex do:[:i | 
            result add: (PO forLocalVariableBinding: (scope locals at:i) ) 
        ].
        self addVariablesInScope: (scope instVarNamed: #parent). "/ !!?!! Why 'scope parent' does not work?
    ].

    scope kind == JAVA org eclipse jdt internal compiler lookup Scope CLASS_SCOPE ifTrue:[ 
        | type |

        type := scope referenceType.
        type notNil ifTrue:[ 
            self addFieldsForTypeBinding: type binding.  
        ].
    ].

    "Created: / 12-08-2014 / 10:41:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-08-2014 / 09:08:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompletionEngine methodsFor:'completion-nodes'!

completeOnFieldType: node
    node type acceptCompletionEngine: self

    "Created: / 13-08-2014 / 21:04:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeOnQualifiedNameReference: node
    | binding |

    binding := node binding.
    (binding notNil and:[binding problemId ~~ JAVA org eclipse jdt internal compiler lookup ProblemReasons NoError]) ifTrue:[
        binding := binding type.
        binding notNil ifTrue:[ 
            self addMethodsForTypeBinding: binding.
            self addFieldsForTypeBinding: binding.  
        ].
    ].

    "Created: / 13-08-2014 / 21:32:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-08-2014 / 11:13:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeOnSingleNameReference: node
    self addVariablesInScope: completionScope.
    self addClassesStartingWith: node token.

    "Created: / 13-08-2014 / 21:05:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeOnSingleTypeReference: node
    self addClassesStartingWith: node token

    "Created: / 13-08-2014 / 21:05:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompletionEngine methodsFor:'completion-private'!

complete
    
    | position source rslt problemReporter parser tree searcher resolver  |

    position := textView characterPositionOfCursor.

    source := JAVA stx libjava tools Source new.
    source setContents: textView list asStringWithoutEmphasis.
    rslt := JAVA org eclipse jdt internal compiler CompilationResult
                new: source _: 1 _: 1 _: 1000.  
    problemReporter := JAVA org eclipse jdt internal compiler problem ProblemReporter
                new: JAVA org eclipse jdt internal compiler DefaultErrorHandlingPolicies proceedWithAllProblems
                  _: JAVA stx libjava tools parser Parser defaultCompilerOptions   
                  _: JAVA stx libjava tools parser Parser defaultProblemFactory.

    parser := JAVA org eclipse jdt internal codeassist complete CompletionParser 
                new: problemReporter _: true.
    [
        tree := parser dietParse: source _: rslt _: position - 1"Java is 0-based" - 1"cursor is actualy one fter the end of token".
    ] on: JAVA org eclipse jdt internal codeassist complete InvalidCursorLocation do:[:icl |
        ^ result
    ].
    searcher := JAVA org eclipse jdt core dom NodeSearcher new: position - 1"Java is 0-based" - 1"cursor is actualy one fter the end of token".
    "/ Used to be
    "/ 
    "/     tree traverse: searcher  _: tree scope.
    "/ 
    "/ But when a scope is nil, then there are two matching methods
    "/ (traverse(...,CompilationUnitScope) and
    "/ (traverse(...,BlockScope).
    "/ Use perform to explicitly select the correct one.
    tree perform: #'traverse(Lorg/eclipse/jdt/internal/compiler/ASTVisitor;Lorg/eclipse/jdt/internal/compiler/lookup/CompilationUnitScope;)V'
         with: searcher    
         with: tree scope.
    (searcher found notNil and:[searcher found isKindOf: JAVA org eclipse jdt internal compiler ast AbstractMethodDeclaration]) ifTrue:[ 
        parser parseBlockStatements: searcher found _: tree.
    ].


    "
    (SmallSense::ParseTreeInspector new node:tree source: codeView list asString) open
    "

    resolver := (Java classForName: 'stx.libjava.tools.environment.Resolver') new: problemReporter.
    [ 
        resolver resolve: tree.
    ] on: JAVA org eclipse jdt internal codeassist complete CompletionNodeFound do:[:ex |  
        completionNode := ex astNode.
        completionScope := ex scope.
    ].

    context node: completionNode position: position.

    (completionNode isNil or:[completionScope isNil]) ifTrue:[
        result := JavaCompletionEngineSimple new complete: context.
    ] ifFalse:[
        completionNode acceptCompletionEngine: self.
    ].

    ^ result

    "Created: / 02-10-2013 / 13:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-04-2016 / 09:25:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCompletionEngine class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

