#ifndef STXXERCESHANDLERCALLBACKS_H_
#define STXXERCESHANDLERCALLBACKS_H_


#include "stc.h" 
#include "StxXercesUtils.hpp"

/* Following C functions are declared in primitive
 * functions section in XMLv2__XercesCXMLReader.st.
 * This simplifies their code, because we can use
 * all stc features like @symbol. Moreover, we don't
 * need to wrap all St/X value creation/extraction function
 * into C++ one (see StxCPPUtils.hpp for wrapped ones)
 */

EXTERN_C void StxXercesStartDocument(OBJ* handler_ref);
EXTERN_C void StxXercesEndDocument(OBJ* handler_ref);

EXTERN_C void StxXercesStartElement(OBJ* handler_ref, char* uri, char* localname, char* qname, StxXercesAttributes attrs);
EXTERN_C void StxXercesEndElement(OBJ* handler_ref, char* uri, char* localname, char* qname);

EXTERN_C void StxXercesCharacters(OBJ* handler_ref, char* characters);
EXTERN_C void StxXercesIgnorableWhitespace(OBJ* handler_ref, char* characters);
EXTERN_C void StxXercesComment(OBJ* handler_ref, char* characters);

EXTERN_C void StxXercesStartPrefixMapping(OBJ* handler_ref, char* prefix, char* uri);
EXTERN_C void StxXercesEndPrefixMapping(OBJ* handler_ref, char* prefix);

EXTERN_C void StxXercesStartHandleElementPSVI(OBJ* handler_ref,char* localname, char* uri, StxXercesPSVIElement elementPSVI);

#endif /*STXXERCESHANDLERCALLBACKS_H_*/
