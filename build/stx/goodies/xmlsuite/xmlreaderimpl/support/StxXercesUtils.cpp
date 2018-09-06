#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/util/XMLString.hpp>
#include <xercesc/parsers/SAX2XMLReaderImpl.hpp>
#include <xercesc/sax2/Attributes.hpp>
#include "StxXercesUtils.hpp"
#include "StxXercesHandler.hpp"
#include "StxXercesInputSource.hpp"


void StxXercesParse(OBJ handler, OBJ stream) {
  XERCES_PRIM_ENTER;
  StxXercesHandler* xerces_handler = new StxXercesHandler(handler);
  XERCES_PRIM_DEBUG(("xerces_handler_created"));
  StxXercesInputSource* xerces_input_source = new StxXercesInputSource(stream);
  SAX2XMLReaderImpl* xerces_parser = new SAX2XMLReaderImpl();
  try {
    xerces_parser->setContentHandler(xerces_handler);
    xerces_parser->setErrorHandler(xerces_handler);
    xerces_parser->setPSVIHandler(xerces_handler);
    xerces_parser->parse(*xerces_input_source);
    xerces_parser->setFeature(XMLUni::fgSAX2CoreValidation, true);
  } catch (...) {
    printf("XERCES [error]: Unknown exception\n");
  }
  delete xerces_handler;
  delete xerces_input_source;
  delete xerces_parser;
  XERCES_PRIM_LEAVE;
}


int StxXercesInitialize() {
  XERCES_PRIM_ENTER;
  try {
    XMLPlatformUtils::Initialize();
    return 1;
  } catch (const XMLException& ex) {
    printf("XERCES [error] Failed to initialize platform: %s\n",
	   XMLString::transcode(ex.getMessage()));
    return 0;
  }      
}

int StxXercesTerminate() {
  XERCES_PRIM_ENTER
  XMLPlatformUtils::Terminate();
  return 1;
}


unsigned int StxXercesAttributesGetLength(StxXercesAttributes attrs) {
	Attributes* attrs_obj = (Attributes*)attrs;
	return attrs_obj->getLength();
}

char* StxXercesAttributesGetUri(StxXercesAttributes attrs, unsigned int index) {
	Attributes* attrs_obj = (Attributes*)attrs;
	return XMLString::transcode( attrs_obj->getURI(index) );
}
char* StxXercesAttributesGetLocalName(StxXercesAttributes attrs, unsigned int index) {
	Attributes* attrs_obj = (Attributes*)attrs;
	return XMLString::transcode( attrs_obj->getLocalName(index) );
}
char* StxXercesAttributesGetQName(StxXercesAttributes attrs, unsigned int index) {
	Attributes* attrs_obj = (Attributes*)attrs;
	return XMLString::transcode( attrs_obj->getQName(index) );
}
char* StxXercesAttributesGetValue(StxXercesAttributes attrs, unsigned int index) {
	Attributes* attrs_obj = (Attributes*)attrs;
	return XMLString::transcode( attrs_obj->getValue(index) );
}






