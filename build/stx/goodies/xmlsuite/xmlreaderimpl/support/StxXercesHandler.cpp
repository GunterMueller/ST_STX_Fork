#include <xercesc/util/XMLString.hpp>
#include "StxXercesHandler.hpp"
#include "StxXercesHandlerCallbacks.h"
#include "StxXercesUtils.hpp"




StxXercesHandler::StxXercesHandler(OBJ reader) {
	XERCES_PRIM_ENTER;
  	stx_reader_refcell = (OBJ*)malloc(sizeof ( OBJ*) );
  	*stx_reader_refcell = reader;
  	__ADD_REFCELL_CPP(stx_reader_refcell);    
  	XERCES_PRIM_LEAVE;  
}

StxXercesHandler::~StxXercesHandler() {
	XERCES_PRIM_ENTER;
	__REMOVE_REFCELL_CPP ( stx_reader_refcell );
	free ( stx_reader_refcell );
	XERCES_PRIM_LEAVE;
}

// -----------------------------------------------------------------------
//  Handlers for the SAX ContentHandler interface
// -----------------------------------------------------------------------

void StxXercesHandler::startElement(const XMLCh* const uri, 
									const XMLCh* const localname, 
    								const XMLCh* const qname, 
    								const Attributes& attrs) {
    XERCES_PRIM_ENTER;
	StxXercesStartElement(stx_reader_refcell, XMLString::transcode(uri), XMLString::transcode(localname), XMLString::transcode(qname), (StxXercesAttributes)&attrs);
	XERCES_PRIM_LEAVE;				
}
    
void StxXercesHandler::endElement(const XMLCh* const uri, 
					              const XMLCh* const localname, 
            					  const XMLCh* const qname) {
	XERCES_PRIM_ENTER;						       
	StxXercesEndElement(stx_reader_refcell, XMLString::transcode(uri), XMLString::transcode(localname), XMLString::transcode(qname));      
    XERCES_PRIM_LEAVE;
            					  	
}
    
void StxXercesHandler::startDocument() {
	XERCES_PRIM_ENTER;						       
	StxXercesStartDocument(stx_reader_refcell);      
    XERCES_PRIM_LEAVE;
}
    
void StxXercesHandler::endDocument() {
	XERCES_PRIM_ENTER;						       
	StxXercesEndDocument(stx_reader_refcell);      
    XERCES_PRIM_LEAVE;
}
   
void StxXercesHandler::characters(const XMLCh* const chars, 
						          const unsigned int length) {
	XERCES_PRIM_ENTER;						       
	StxXercesCharacters(stx_reader_refcell,XMLString::transcode(chars));      
    XERCES_PRIM_LEAVE;
}
   
void StxXercesHandler::ignorableWhitespace(const XMLCh* const chars, 
									       const unsigned int length) {
	XERCES_PRIM_ENTER;						       
	StxXercesIgnorableWhitespace(stx_reader_refcell,XMLString::transcode(chars));      
    XERCES_PRIM_LEAVE;
									    
}
   
void StxXercesHandler::comment(const XMLCh* const chars, 
							   const unsigned int length) {
	XERCES_PRIM_ENTER;						       
	StxXercesComment(stx_reader_refcell,XMLString::transcode(chars));      
    XERCES_PRIM_LEAVE;
							   	
}
   
void StxXercesHandler::processingInstruction(const XMLCh* const target, 
											 const XMLCh* const data) {
}
   
void StxXercesHandler::startPrefixMapping(const XMLCh* const prefix, 
										  const XMLCh* const uri) {
	XERCES_PRIM_ENTER;						       
	StxXercesStartPrefixMapping(stx_reader_refcell,XMLString::transcode(prefix), XMLString::transcode(uri));      
    XERCES_PRIM_LEAVE;										  	
}
   
void StxXercesHandler::endPrefixMapping(const XMLCh* const prefix) {
	XERCES_PRIM_ENTER;						       
	StxXercesEndPrefixMapping(stx_reader_refcell,XMLString::transcode(prefix));      
    XERCES_PRIM_LEAVE;
	
}

// -----------------------------------------------------------------------
//  Implementation of the SAX EntityResolver interface
// -----------------------------------------------------------------------

  
InputSource* StxXercesHandler::resolveEntity(const XMLCh* const publicId, 
        const XMLCh* const systemId) {
}

// -----------------------------------------------------------------------
//  Handlers for the SAX ErrorHandler interface
// -----------------------------------------------------------------------
void StxXercesHandler::warning(const SAXParseException& exc) {
	XERCES_PRIM_DEBUG(("WARNING: %s\n", XMLString::transcode(exc.getMessage())));
}

void StxXercesHandler::error(const SAXParseException& exc) {
}

void StxXercesHandler::fatalError(const SAXParseException& exc) {
}

void StxXercesHandler::resetErrors() {
}

// -----------------------------------------------------------------------
//  Handlers for the PSVIHandler interface
// -----------------------------------------------------------------------
void StxXercesHandler::handleAttributesPSVI(const XMLCh* const localName, 
        const XMLCh* const uri, 
        PSVIAttributeList* attributesPSVI) {
    XERCES_PRIM_ENTER;						       
	//StxXercesStartHandleAttributesPSVI(stx_reader_refcell,XMLString::transcode(localName), XMLString::transcode(uri), (StxXercesPSVIAttributeList*)attributesPSVI);      
    XERCES_PRIM_LEAVE;										  	
        	
}

void StxXercesHandler::handleElementPSVI(const XMLCh* const localName, 
        const XMLCh* const uri, 
        PSVIElement* elementPSVI) {	
	XERCES_PRIM_ENTER;						       
	StxXercesStartHandleElementPSVI(stx_reader_refcell,XMLString::transcode(localName), XMLString::transcode(uri), (StxXercesPSVIElement*)elementPSVI);      
    XERCES_PRIM_LEAVE;										  	

}

void StxXercesHandler::handlePartialElementPSVI(const XMLCh* const localName, 
        const XMLCh* const uri, 
        PSVIElement* elementPSVI) {
	XERCES_PRIM_ENTER;						       
	//StxXercesStartHandlePartialElementPSVI(stx_reader_refcell,XMLString::transcode(localName), XMLString::transcode(uri), (StxXercesPSVIElement*)elementPSVI);      
    XERCES_PRIM_LEAVE;										  	
     
}

// -----------------------------------------------------------------------
//  Implementation of the SAX DTDHandler interface
// -----------------------------------------------------------------------
void StxXercesHandler::notationDecl(const XMLCh* const name, 
    const XMLCh* const publicId, 
    const XMLCh* const systemId) {
}

void StxXercesHandler::unparsedEntityDecl(const XMLCh* const name, 
        const XMLCh* const publicId, 
        const XMLCh* const systemId, 
        const XMLCh* const notationName) {
}
    
    
