"{ Package: 'stx:libjava' }"

!

!(Java classForName:'java.util.Collection') methodsFor:'* instance *'!

anElement
    "return any element from the collection, 
     report an error if there is none"

    self do: [:each | ^ each].
    Smalltalk::Collection emptyCollectionSignal raise.
! !
!(Java classForName:'java.util.Collection') methodsFor:'* instance *'!

collect:aBlock
    "for each element in the receiver, evaluate the argument, aBlock
     and return a new collection with the results"

    |newCollection|

    newCollection := self species new.
    self do:[:element | newCollection add:(aBlock value:element)].
    ^ newCollection

    "
     #(1 2 3 4) collect:[:n | n * 2]  
    "
! !
!(Java classForName:'java.util.Collection') methodsFor:'* instance *'!

detect:aBlock
    "evaluate the argument, aBlock for each element in the receiver until
     the block returns true; in this case return the element which caused
     the true evaluation.
     If none of the evaluations returns true, report an error"

    ^ self detect:aBlock ifNone:[self errorNotFound]

    "
     #(1 2 3 4) detect:[:n | n odd]   
     #(2 4 6 8) detect:[:n | n odd]  
    "
! !
!(Java classForName:'java.util.Collection') methodsFor:'* instance *'!

detect:aOneArgBlock ifNone:exceptionBlock
    "evaluate the argument, aBlock for each element in the receiver until
     the block returns true; in this case return the element which caused
     the true evaluation.
     If none of the evaluations returns true, return the result of the
     evaluation of the exceptionBlock"

    self do:[:each | 
        (aOneArgBlock value:each) ifTrue:[^ each].
    ].
    ^ exceptionBlock value

    "
     #(1 2 3 4) detect:[:n | n odd] ifNone:['sorry']    
     #(2 4 6 8) detect:[:n | n odd] ifNone:['sorry']     
    "

    "Modified: / 13-09-2006 / 11:17:42 / cg"
! !
!(Java classForName:'java.util.Collection') methodsFor:'* instance *'!

do: aBlock
    "Iterate over collection evaluating given block with each element"

    | iterator |

    iterator := self iterator.
    [ iterator hasNext ] whileTrue:[
        aBlock value: iterator next.
    ].
! !
!(Java classForName:'java.util.Collection') methodsFor:'* instance *'!

do:aBlock separatedBy:betweenBlock
    "evaluate the argument, aBlock for each element.
     Between elements (i.e. after each except for the last),
     evaluate betweenBlock.
     This is a utility helper for collection printers
     (for example, to print a space between elements)."

"/ could do the more hackish:
"/
"/    |b|
"/
"/    b := [ b := betweenBlock ].
"/    self do:[:element |
"/        b value.
"/        aBlock value:element
"/    ].
"/
"/ but that creates a block, whereas the following does not.

    |first|

    first := true.
    self do:[:element |
        first ifTrue:[
            first := false
        ] ifFalse:[
            betweenBlock value.
        ].
        aBlock value:element
    ].

    "
     #(1 2 3 4) do:[:el | Transcript show:el]
                separatedBy:[ Transcript show:'-']

     (Dictionary with:(1->'one') with:(2->'two'))
         do:[:el | Transcript showCR:el printString]
         separatedBy:[ Transcript showCR:'----']

     (Dictionary with:(1->'one') with:(2->'two'))
        associations
         do:[:el | Transcript showCR:el printString]
         separatedBy:[ Transcript showCR:'----']

    "

    "Modified: / 11.2.2000 / 11:23:15 / cg"
! !
!(Java classForName:'java.util.Collection') methodsFor:'* instance *'!

inject:thisValue into:binaryBlock
    "starting with thisValue for value, pass this value and each element
     to binaryBlock, replacing value with the result returned from the block
     in the next iteration.

     See also: #fold: #reduce:"

    |nextValue|

    nextValue := thisValue.
    self do: [:each | nextValue := binaryBlock value:nextValue value:each].
    ^ nextValue

    "sum up the elements of a collection:

     #(1 2 3 4) inject:0 into:[:accu :element | accu + element]   
     (1 to:10) inject:0 into:[:accu :element | accu + element]     

     find the minimum:

     |coll|
     coll := #(1 99 -15 20 100).
     coll inject:(coll first) into:[:minSoFar :element | minSoFar min:element]
    "

    "Modified: 23.4.1996 / 13:47:06 / cg"
! !
!(Java classForName:'java.util.Collection') methodsFor:'* instance *'!

reject:aBlock
    "return a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to false"

    ^ self select:[:element | (aBlock value:element) not]

    "
     #(1 2 3 4) reject:[:e | e odd]   
     (1 to:10) reject:[:e | e even]     
    "
! !
!(Java classForName:'java.util.Collection') methodsFor:'* instance *'!

select:aBlock
    "return a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to true.
     See also: #removeAllFoundIn: and #removeAllSuchThat:"

    |newCollection|

    newCollection := self species new.
    self do:[:each |
        (aBlock value:each) ifTrue:[newCollection add:each].
    ].
    ^ newCollection

    "
     #(1 2 3 4) select:[:e | e odd]   
     (1 to:10) select:[:e | e even]     
    "

    "Modified: / 07-08-2010 / 16:26:40 / cg"
! !
