"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#BayesClassifierTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Support'
!

!BayesClassifierTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!BayesClassifierTest methodsFor:'tests'!

test02_dehyphenate
    "This is a demonstration testCase - it is meant to be removed eventually.
     This testCase will PASS.
     Double click on the TestCase class or open a TestRunner to see me checking...
     - please add more methods like this..."

    |b s l|

    s := '    
1 2 3 4
5 6 7 8-
9 10 11 12
'.
    b := BayesClassifier new.
    l := b dehyphenate:s asCollectionOfLines.
    self assert:(l asArray = #('1 2 3 4' '5 6 7 8-' '9 10 11 12')).

    s := '    
a b c d
e f g h-
i j k l
'.
    b := BayesClassifier new.
    l := b dehyphenate:s asCollectionOfLines.
    self assert:(l asArray = #('a b c d' 'e f g hi j k l')).


    s := '    
a b c d
e f g h -
i j k l
'.
    b := BayesClassifier new.
    l := b dehyphenate:s asCollectionOfLines.
    self assert:(l asArray = #('a b c d' 'e f g h -' 'i j k l')).
    "
     self run:#test02_dehyphenate
     self new test02_dehyphenate
    "
!

test03_extractWords
    |b s|

    s := '    
Sieh dir z.B. mal an, was in Deutschland an Rechtsbeugung los ist. Da bekommt in systemrelevanten Verfahren in der Regel der Richter vor dem Prozess mitgeteilt (vom Präsidenten oder seinem Vize), wie das Verfahren ausgehen soll. Und wenn danach Rechtsbeugung erwiesen ist, so darf man das Gericht noch nicht einmal verklagen, sondern muss den Einzelrichter bzw. Senat verklagen, der das Urteil ausgesprochen hat. Und wo muss man den Richter verklagen? An demselben Gericht das ihm zuvor die Anordnung zur Rechtsbeugung erteilt hat. Da ein und dasselbe Gericht das die Rechtsbeugung begangen hat, darüber entscheidet ob es Rechtsbeugung begangen hat, sind in der BRD noch nicht einmal die primitivsten Grundsätze der Gewaltenteilung gegeben. 
Und dann natürlich immer wieder die Wahlfälschungen. Hier geht es zu wie in einer Bananenrepublik. Nur ein Beispiel von vielen
http://www.welt.de/politik/deutschland/article150236737/Schueler-zaehlten-falsch...
Und die Pressezensur wird auch immer schlimmer. Wer anderer Meinung ist möge mir bitte einmal ein regierungskritisches Massenmedium nennen, egal ob Fernsehsender, Radiosender, Zeitschrift ...
Und dann natürlich die Vernichtung der im Grundgesetz garantierten Rechte auf das Postgeheimnis und Fernmeldegeheimnis. Seit die Regierung bei mir rumschnüffelt, ist mein Rechner echt langsam geworden.
https://de.wikipedia.org/wiki/Fernmeldegeheimnis
O.k. ist besser als von Islamisten ermordet zu werden, aber ich bin kein Islamist und stehe bei niemandem in Verdacht einer zu sein - also was soll diese Überwachung?!! Ach so, ich habe mal geschrieben wie lächerlich der Vergewaltigungsvorwurf gegen Julian Assange ist, ja dann natürlich ...
'.
    b := BayesClassifier new.
    b classify:s.

    "
     self run:#test1
     self new test1
    "
!

test06_classify
    |b|

    b := BayesClassifier new.
    "/teach it positive phrases
    b classify:'amazing, awesome movie!!!! Yeah!!!!' asCategory: 'positive'.
    b classify:'Sweet, this is incredibly, amazing, perfect, great!!!!' asCategory: 'positive'.

    "/teach it a negative phrase
    b classify:'terrible, shitty thing. Damn. Sucks!!!!' asCategory: 'negative'.

    "/teach it a neutral phrase
    b classify:'I dont really know what to make of this.' asCategory: 'neutral'.

    "/now test it to see that it correctly categorizes a new document
    self assert:(b classify:'awesome, cool, amazing!!!! Yay.')= 'positive'.
!

xtest04_classify
    |b s|

    s := '    
Sieh dir z.B. mal an, was in Deutschland an Rechtsbeugung los ist. Da bekommt in systemrelevanten Verfahren in der Regel der Richter vor dem Prozess mitgeteilt (vom Präsidenten oder seinem Vize), wie das Verfahren ausgehen soll. Und wenn danach Rechtsbeugung erwiesen ist, so darf man das Gericht noch nicht einmal verklagen, sondern muss den Einzelrichter bzw. Senat verklagen, der das Urteil ausgesprochen hat. Und wo muss man den Richter verklagen? An demselben Gericht das ihm zuvor die Anordnung zur Rechtsbeugung erteilt hat. Da ein und dasselbe Gericht das die Rechtsbeugung begangen hat, darüber entscheidet ob es Rechtsbeugung begangen hat, sind in der BRD noch nicht einmal die primitivsten Grundsätze der Gewaltenteilung gegeben. 
Und dann natürlich immer wieder die Wahlfälschungen. Hier geht es zu wie in einer Bananenrepublik. Nur ein Beispiel von vielen
http://www.welt.de/politik/deutschland/article150236737/Schueler-zaehlten-falsch...
Und die Pressezensur wird auch immer schlimmer. Wer anderer Meinung ist möge mir bitte einmal ein regierungskritisches Massenmedium nennen, egal ob Fernsehsender, Radiosender, Zeitschrift ...
Und dann natürlich die Vernichtung der im Grundgesetz garantierten Rechte auf das Postgeheimnis und Fernmeldegeheimnis. Seit die Regierung bei mir rumschnüffelt, ist mein Rechner echt langsam geworden.
https://de.wikipedia.org/wiki/Fernmeldegeheimnis
O.k. ist besser als von Islamisten ermordet zu werden, aber ich bin kein Islamist und stehe bei niemandem in Verdacht einer zu sein - also was soll diese Überwachung?!! Ach so, ich habe mal geschrieben wie lächerlich der Vergewaltigungsvorwurf gegen Julian Assange ist, ja dann natürlich ...
'.
    b := BayesClassifier new.
    b classify:s.

    "
     self run:#test1
     self new test1
    "
! !

!BayesClassifierTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

