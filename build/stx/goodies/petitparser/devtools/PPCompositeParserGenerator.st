"{ Package: 'stx:goodies/petitparser/devtools' }"

Object subclass:#PPCompositeParserGenerator
	instanceVariableNames:'productions klass changeset'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Utils'
!


!PPCompositeParserGenerator methodsFor:'accessing'!

changeset
    ^ changeset
!

klass
    ^ klass
!

klass:something
    klass := something.
!

productions
    ^ productions
!

productions:something
    productions := something.
! !

!PPCompositeParserGenerator methodsFor:'generating'!

generate
    | instvars classchange |

    changeset := ChangeSet fromStream: Dart::Parser definition readStream.
    classchange := changeset anElement.
    classchange setupFromSource.

    instvars := productions keys.
    instvars add: classchange instanceVariableNames.
    classchange instanceVariableNames: (instvars asSortedCollection  asStringWith:' ').


    productions do:[:p|
        | method |

        method := MethodDefinitionChange new
            class: klass;
            selector: p name asSymbol;
            source: (PPPrinter print: p);
            category: 'grammar';
            yourself.
        changeset add: method.            
    ].

    "Created: / 10-01-2013 / 12:57:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-01-2013 / 09:52:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCompositeParserGenerator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/PPCompositeParserGenerator.st,v 1.2 2013-01-11 09:57:49 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/devtools/PPCompositeParserGenerator.st,v 1.2 2013-01-11 09:57:49 vrany Exp $'
! !
