#ifndef STXXERCESUTIL_H_
#define STXXERCESUTIL_H_

#include "StxCPPUtils.h"

#define XERCES_PRIM_DEBUG( text ) printf ("XERCES [debug] "); printf text;
#define XERCES_PRIM_ENTER \
  XERCES_PRIM_DEBUG(( "Entering: %s\n", __PRETTY_FUNCTION__ ))

#define XERCES_PRIM_LEAVE \
  XERCES_PRIM_DEBUG(( "Leaving:  %s\n", __PRETTY_FUNCTION__ ))



EXTERN_C void StxXercesParse(OBJ handler, OBJ input_source);
EXTERN_C int StxXercesInitialize();
EXTERN_C int StxXercesTerminate();


/* C interface to Attributes class */

typedef void* StxXercesAttributes;

EXTERN_C unsigned int StxXercesAttributesGetLength(StxXercesAttributes attrs);
EXTERN_C char* StxXercesAttributesGetUri(StxXercesAttributes attrs, unsigned int index);
EXTERN_C char* StxXercesAttributesGetLocalName(StxXercesAttributes attrs, unsigned int index);
EXTERN_C char* StxXercesAttributesGetQName(StxXercesAttributes attrs, unsigned int index);
EXTERN_C char* StxXercesAttributesGetValue(StxXercesAttributes attrs, unsigned int index);


/* C interface to PSVI */

typedef void* StxXercesPSVIElement;
  
#endif
