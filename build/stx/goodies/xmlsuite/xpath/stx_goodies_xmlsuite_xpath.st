"{ Package: 'stx:goodies/xmlsuite/xpath' }"

LibraryDefinition subclass:#stx_goodies_xmlsuite_xpath
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_xmlsuite_xpath class methodsFor:'description'!

preRequisites
    ^ #(
        #'cvut:fel/perseus/core'    "Perseus::ASTNode - superclass of XMLv2::XPathAxisPrecedingSibling "
        #'stx:goodies/smaCC'    "SmaCC::SmaCCParser - superclass of XMLv2::XPathParser "
        #'stx:goodies/sunit'    "TestCase - superclass of XMLv2::XPathExpressionOptimizerTests "
        #'stx:goodies/xml/vw'    "XML::Document - referenced by XMLv2::XPathVWDocumentAdaptor class>>documentClass "
        #'stx:goodies/xmlsuite/core'    "XMLv2::XMLReader - superclass of XMLv2::XPathDOMAdaptorXMLReader "
        #'stx:libbasic'    "Object - superclass of XMLv2::XPathDOM3DocumentAdaptor "
        #'stx:libbasic2'    "List - referenced by XMLv2::XPathExprTreeNode>>subnodes "
    )

    "Modified: / 01-12-2008 / 16:13:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!stx_goodies_xmlsuite_xpath class methodsFor:'description - contents'!

classNamesAndAttributes
    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'XMLv2::XPathASTNode'
        #'XMLv2::XPathContext'
        #'XMLv2::XPathCoverageMonitor'
        #'XMLv2::XPathDOMAdaptorXMLReader'
        #'XMLv2::XPathDocumentAdaptor'
        #'XMLv2::XPathDocumentAdaptorFactory'
        #'XMLv2::XPathDocumentAdaptorReleasedError'
        #'XMLv2::XPathDocumentAdaptorTests'
        #'XMLv2::XPathDocumentNotFoundError'
        #'XMLv2::XPathDocumentProvider'
        #'XMLv2::XPathExprTreeNode'
        #'XMLv2::XPathExpression'
        #'XMLv2::XPathExpressionOptimizer'
        #'XMLv2::XPathExpressionOptimizerTests'
        #'XMLv2::XPathInvalidNodeIdError'
        #'XMLv2::XPathLocationPath'
        #'XMLv2::XPathLocationStep'
        #'XMLv2::XPathNode'
        #'XMLv2::XPathNodePosition'
        #'XMLv2::XPathNodePositionComparator'
        #'XMLv2::XPathNodeSet'
        #'XMLv2::XPathNodeTypeTest'
        #'XMLv2::XPathParser'
        #'XMLv2::XPathProcessor'
        #'XMLv2::XPathScanner'
        #'XMLv2::XPathTests'
        #'stx_goodies_xmlsuite_xpath'
        #'XMLv2::XPathAxis'
        #'XMLv2::XPathDOM3DocumentAdaptor'
        #'XMLv2::XPathDOM3DocumentAdaptorTests'
        #'XMLv2::XPathElementNode'
        #'XMLv2::XPathNodeTest'
        #'XMLv2::XPathPredicate'
        #'XMLv2::XPathRootNode'
        #'XMLv2::XPathSimpleDocumentProvider'
        #'XMLv2::XPathVWDocumentAdaptor'
        #'XMLv2::XPathAxisAncestor'
        #'XMLv2::XPathAxisAncestorOrSelf'
        #'XMLv2::XPathAxisAttribute'
        #'XMLv2::XPathAxisChild'
        #'XMLv2::XPathAxisDescendant'
        #'XMLv2::XPathAxisDescendantOrSelf'
        #'XMLv2::XPathAxisFollowing'
        #'XMLv2::XPathAxisFollowingSibling'
        #'XMLv2::XPathAxisParent'
        #'XMLv2::XPathAxisPreceding'
        #'XMLv2::XPathAxisPrecedingSibling'
        #'XMLv2::XPathAxisSelf'
        #'XMLv2::XPathKindTest'
        #'XMLv2::XPathNameTest'
        #'XMLv2::XPathAnyKindTest'
        #'XMLv2::XPathAttributeTest'
        #'XMLv2::XPathCommentTest'
        #'XMLv2::XPathDocumentTest'
        #'XMLv2::XPathElementTest'
        #'XMLv2::XPathProcessingInstructionTest'
        #'XMLv2::XPathTextTest'
    )
!

extensionMethodNames
    ^ #(
    )
! !

!stx_goodies_xmlsuite_xpath class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2008\nCopyright eXept Software AG 1998-2008'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_xmlsuite_xpath class methodsFor:'documentation'!

version
    ^'$Id$'
! !
