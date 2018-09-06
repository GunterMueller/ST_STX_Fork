"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

Tools::BrowserList subclass:#MCBrowserList
	instanceVariableNames:'listHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!


!MCBrowserList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MCBrowserList andSelector:#windowSpec
     MCBrowserList new openInterface:#windowSpec
     MCBrowserList open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'MC Browser List'
          name: 'MC Browser List'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (SelectionInListModelViewSpec
              name: 'SelectionInListModelView1'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: selectionHolder
              menu: menuHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: listHolder
              useIndex: false
              highlightMode: line
            )
           )
         
        )
      )
! !

!MCBrowserList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #inGeneratorHolder
        #outGeneratorHolder
        #menuHolder
        #selectionHolder
      ).

    "Modified: / 17-09-2010 / 11:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCBrowserList class methodsFor:'queries'!

isAbstract
    ^ self == MCBrowserList
! !

!MCBrowserList methodsFor:'aspects'!

listHolder
    "return/create the 'listHolder' value holder (automatically generated)"

    listHolder isNil ifTrue:[
        listHolder := ValueHolder new.
    ].
    ^ listHolder
! !

!MCBrowserList methodsFor:'queries'!

supportsSearch

    ^false

    "Created: / 04-08-2011 / 19:04:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCBrowserList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCBrowserList.st,v 1.5 2015-02-01 14:14:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCBrowserList.st,v 1.5 2015-02-01 14:14:45 cg Exp $'
!

version_SVN
    ^ '$Id: MCBrowserList.st,v 1.5 2015-02-01 14:14:45 cg Exp $'
! !

