"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

Object subclass:#ClassOrganizer
	instanceVariableNames:'globalComment categoryArray categoryStops elementArray class
		categories'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Support'
!

!ClassOrganizer class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    in contrast to other smalltalks, ST/X does not keep the
    method <-> category associations in the class (as organization),
    but instead keeps the category as an instance variable of methods.

    For compatibility with (fileOut-) files which include a class organization
    message, 'aClass organization' returns an instance of this class, which
    implements the category change functionality.
    Also, some PD code seems to use & define methods for ClassOrganizers 
    - having this (somewhat dummy) class around helps to fileIn that code.

    Notice, that instances of ClassOrganizer are NOT used in the current ST/X
    system; all of this is pure compatibility mimicri.


    This is an additional goody class; therefore:

    THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
    OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
    SUCH DAMAGE.

    [author:]
        Claus Gittinger
"
! !

!ClassOrganizer class methodsFor:'instance creation'!

for:aClass
    "create & return a new instance of myself, to organize aClass"

    ^ super new class:aClass

    "Modified: / 31.10.2001 / 08:58:49 / cg"
! !

!ClassOrganizer class methodsFor:'defaults'!

defaultProtocol 
    ^ 'as yet unspecified'
! !


!ClassOrganizer methodsFor:'accessing'!

addCategory:aCategory
    "ignored."


    "
     Number organization addCategory:'foo'. 
    "

    "Created: / 17.4.1998 / 14:42:16 / cg"
!

addCategory:aCategory before:symbolOrNil
    "ignored."
!

categories
    "return a collection of my classes method-categorySymbols"

    |set|

    categoryArray isNil ifTrue:[
        set := IdentitySet new.
        class methodDictionary keysAndValuesDo:[:sel :m |
            set add:m category
        ].
        categoryArray := set asArray sort
    ].
    ^ categoryArray

    "
     SmallInteger organization categories 
    "

    "Modified: / 20.6.1998 / 12:26:49 / cg"
!

categoryOfElement:aSelectorSymbol
    "return the category for the method specified by aSelectorSymbol.
     Return nil, if there is no such method."

    |m|

    m := class compiledMethodAt:aSelectorSymbol.
    m isNil ifTrue:[^ nil].
    ^ m category

    "
     Number organization categoryOfElement:#foo. 
     Object organization categoryOfElement:#==   
    "
!

classComment
    "return the classes comment"

    ^ class comment

    "
     Number organization classComment  
    "
!

elements
    "return a collection of my classes selectors"

    |set|

    elementArray isNil ifTrue:[
        set := IdentitySet new.
        class methodDictionary keysAndValuesDo:[:sel :m |
            set add:sel
        ].
        elementArray := set asArray
    ].
    ^ elementArray

    "
     SmallInteger organization elements 
    "

    "Modified: / 20.6.1998 / 12:27:23 / cg"
!

listAtCategoryNamed:aCategorySymbol
    "return a collection of selectors whose methods are categorized
     as aCategorySymbol"

    |list|

    list := OrderedCollection new.
    class methodDictionary keysAndValuesDo:[:sel :mthd |
        mthd category == aCategorySymbol ifTrue:[list add:sel]
    ].
    ^ list asOrderedCollection

    "
     SmallInteger organization listAtCategoryNamed:#arithmetic 
    "
!

removeCategory:aCategory
    "remove a categories assignments - dummy here "

    "Modified: / 3.2.2000 / 23:49:27 / cg"
! !

!ClassOrganizer methodsFor:'change & update'!

update:something with:parameter from:changedObject
    changedObject == class ifTrue:[
        something == #methodTrap ifFalse:[
            categoryArray := elementArray := categories := nil
        ]
    ].

    "Created: / 20.6.1998 / 12:28:37 / cg"
    "Modified: / 20.6.1998 / 12:30:14 / cg"
! !

!ClassOrganizer methodsFor:'changing'!

changeFromString:organizationString
    "take category<->selector associations from aString, and change
     the categories of those methods. 
     Only required when filing in ST-80 code, which changes the categorization
     this way."

    |a category m|

    "
     (mis(use) parser for the scanning
    "
    a := Compiler evaluate:'#(' , organizationString , ')'.
    (a isMemberOf:Array) ifFalse:[^ self error:'malformed argument'].
    a do:[:row |
        category := row at:1.
        2 to:row size do:[:idx |
            |selector|

            selector := row at:idx.
            m := class compiledMethodAt:selector.
            m isNil ifTrue:[
                Transcript showCR:'no method for ' , selector , ' in ', class name
            ] ifFalse:[
                m category:category.
            ]
        ]
    ].

    "
     TestClass 
        organization
            changeFromString:'( ''category1'' #foo1 #foo2 foo3)
                              ( ''category2'' #bar1 #bar2)'
    "
!

classify:aSelector under:aCategory
    "change the category of the method stored under aSelector
     to aCategory."

    |m list|

    class isNil ifTrue:[
        "/ sigh used without a class ...
        categories isNil ifTrue:[
            categories := Dictionary new.
        ].
        list := categories at:aCategory ifAbsent:nil.
        list isNil ifTrue:[
            list := OrderedCollection new.
            categories at:aCategory put:list.
        ].
        list add:aSelector.
        ^ self.
    ].

    m := class compiledMethodAt:aSelector.
    m notNil ifTrue:[
        m category:aCategory
    ].

    "Created: 20.6.1997 / 18:01:18 / cg"
    "Modified: 20.6.1997 / 18:09:37 / cg"
! !

!ClassOrganizer methodsFor:'printing & storing'!

printOn:aStream
    |coll|

    class notNil ifTrue:[
        coll := IdentityDictionary new.
        class methodDictionary keysAndValuesDo:[:sel :mthd |
            |cat list|

            cat := mthd category.
            list := coll at:cat ifAbsent:[].
            list isNil ifTrue:[
                coll at:cat put:(list := OrderedCollection new).
            ].
            list add:sel
        ].
    ] ifFalse:[
        coll := categories
    ].
    coll notNil ifTrue:[
        coll keysAndValuesDo:[:category :list |
            aStream nextPut:$(.
            aStream nextPutAll:category asString storeString.
            list do:[:selector |
                aStream space.
                selector storeOn:aStream
            ].
            aStream nextPut:$).
            aStream cr
        ]
    ]

    "
     Number organization printString
    "

    "Modified: / 30.10.2001 / 17:58:50 / cg"
! !

!ClassOrganizer methodsFor:'private access'!

class:aClass
    "set the class"

    class := aClass.
    aClass addDependent:self.

    "
     ClassOrganizer organization
    "

    "Modified: / 20.6.1998 / 12:29:16 / cg"
! !

!ClassOrganizer class methodsFor:'documentation'!

version
    ^ '$Header: ClassOrganizer.st 1909 2012-03-31 00:14:49Z vranyj1 $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: ClassOrganizer.st 1909 2012-03-31 00:14:49Z vranyj1 §'
! !

