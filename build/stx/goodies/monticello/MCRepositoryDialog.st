"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCDialog subclass:#MCRepositoryDialog
	instanceVariableNames:'repositoryTypeHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!


!MCRepositoryDialog class methodsFor:'interface specs'!

contentSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:MCRepositoryDialog andSelector:#contentSpec
     MCRepositoryDialog new openInterface:#contentSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: contentSpec
        window: 
       (WindowSpec
          label: 'Content Spec'
          name: 'Content Spec'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 580 300)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Type:'
              name: 'TypeLabel'
              layout: (LayoutFrame 0 0 15 0 100 0 35 0)
              translateLabel: true
            )
           (PopUpListSpec
              label: 'PopUp List'
              name: 'PopUpList1'
              layout: (LayoutFrame 100 0 12 0 0 1 37 0)
              tabable: true
              model: repositoryTypeHolder
              menu: 
             (Array
                'HTTP' 'Local'
              )
            )
           (SubCanvasSpec
              name: 'Info'
              layout: (LayoutFrame 0 0 45 0 0 1 0 1)
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              createNewBuilder: false
            )
           )
         
        )
      )
! !

!MCRepositoryDialog methodsFor:'accessing'!

defaultTitle
    "superclass MCDialog says that I am responsible to implement this method"

    ^ 'Monticello Repository'

    "Created: / 13-10-2010 / 15:01:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCRepositoryDialog methodsFor:'aspects'!

repositoryTypeHolder
    <resource: #uiAspect>

    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept it in the browser."
    "*** (and replace this comment by something more useful ;-)"

    repositoryTypeHolder isNil ifTrue:[
        repositoryTypeHolder := ValueHolder with:'HTTP'.
"/ if your app needs to be notified of changes, uncomment one of the lines below:
"/       repositoryTypeHolder addDependent:self.
"/       repositoryTypeHolder onChangeSend:#repositoryTypeHolderChanged to:self.
    ].
    ^ repositoryTypeHolder.

    "Modified: / 13-10-2010 / 15:17:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCRepositoryDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepositoryDialog.st,v 1.2 2012-09-11 21:13:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepositoryDialog.st,v 1.2 2012-09-11 21:13:56 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '�Id: MCRepositoryDialog.st 19 2010-10-14 10:51:48Z vranyj1 �'
! !
