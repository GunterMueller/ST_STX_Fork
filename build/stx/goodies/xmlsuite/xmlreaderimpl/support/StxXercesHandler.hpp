#ifndef XERCES_STXHANDLER_H_
#define XERCES_STXHANDLER_H_

#include <xercesc/sax2/DefaultHandler.hpp>
#include <xercesc/sax/InputSource.hpp>
#include <xercesc/framework/psvi/PSVIHandler.hpp>
#include <xercesc/framework/psvi/PSVIAttributeList.hpp>
#include <xercesc/framework/psvi/PSVIElement.hpp>



#include "StxCPPUtils.h"

XERCES_CPP_NAMESPACE_USE


class StxXercesHandler: public DefaultHandler, public PSVIHandler {
protected:
  OBJ* stx_reader_refcell;
  //char* string_buffer;
  //int string_buffer_len

public:
  StxXercesHandler(OBJ st_handler);
  virtual ~StxXercesHandler();
  
    // -----------------------------------------------------------------------
    //  Handlers for the SAX ContentHandler interface
    // -----------------------------------------------------------------------
    void startElement(const XMLCh* const uri, const XMLCh* const localname, const XMLCh* const qname, const Attributes& attrs);
    void endElement(const XMLCh* const uri, const XMLCh* const localname, const XMLCh* const qname);
    void startDocument();
    void endDocument();
    void characters(const XMLCh* const chars, const unsigned int length);
    void ignorableWhitespace(const XMLCh* const chars, const unsigned int length);
    void comment(const XMLCh* const chars, const unsigned int length);
    void processingInstruction(const XMLCh* const target, const XMLCh* const data);
    void startPrefixMapping(const XMLCh* const prefix, const XMLCh* const uri);
  void endPrefixMapping(const XMLCh* const prefix);


    // -----------------------------------------------------------------------
    //  Implementation of the SAX EntityResolver interface
    // -----------------------------------------------------------------------

    InputSource* resolveEntity(const XMLCh* const publicId, const XMLCh* const systemId);

    // -----------------------------------------------------------------------
    //  Handlers for the SAX ErrorHandler interface
    // -----------------------------------------------------------------------
	void warning(const SAXParseException& exc);
    void error(const SAXParseException& exc);
    void fatalError(const SAXParseException& exc);
    void resetErrors();
    
    // -----------------------------------------------------------------------
    //  Handlers for the PSVIHandler interface
    // -----------------------------------------------------------------------
	void handleAttributesPSVI(const XMLCh* const localName, const XMLCh* const uri, PSVIAttributeList* psviAttributes);
	void handleElementPSVI(const XMLCh* const localName, const XMLCh* const uri, PSVIElement* elementInfo);
	void handlePartialElementPSVI(const XMLCh* const localName, const XMLCh* const uri, PSVIElement* elementInfo);


    // -----------------------------------------------------------------------
    //  Implementation of the SAX DTDHandler interface
    // -----------------------------------------------------------------------
    void notationDecl (const XMLCh* const name, const XMLCh* const publicId, const XMLCh* const systemId);
    void unparsedEntityDecl (const XMLCh* const name, const XMLCh* const publicId, const XMLCh* const systemId, const XMLCh* const notationName);
};    
    

#endif
