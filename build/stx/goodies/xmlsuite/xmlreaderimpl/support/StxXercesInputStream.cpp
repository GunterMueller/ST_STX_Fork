/*
 * StxXercesInputStream.cpp
 *
 *  Created on: Dec 8, 2008
 *      Author: honza
 */

#include "string.h"
#include "assert.h"
#include "StxXercesInputStream.hpp"

#define CHUNK_SIZE 4096
#define MIN(a,b) (a < b ? a : b)

StxXercesInputStream::StxXercesInputStream(OBJ stx_stream) {
 
  stx_stream_refcell = (OBJ*)malloc(sizeof ( OBJ*) );
  *stx_stream_refcell = stx_stream;
  __ADD_REFCELL_CPP(stx_stream_refcell);

  /* Create buffer (instance of ByteArray) */
  stx_buffer_refcell = (OBJ*)malloc(sizeof ( OBJ*) );
  *stx_buffer_refcell = __BYTEARRAY_UNINITIALIZED_NEW_INT_CPP(CHUNK_SIZE);  
  __ADD_REFCELL_CPP(stx_buffer_refcell);


  /* Create nextBytes:into: symbol */
  stx_symbol_refcell = (OBJ*)malloc(sizeof ( OBJ*) );
  *stx_symbol_refcell = __MKSYMBOL_CPP("nextBytes:into:");
  __ADD_REFCELL_CPP(stx_symbol_refcell);

  
}

StxXercesInputStream::~StxXercesInputStream() {  
  __REMOVE_REFCELL_CPP ( stx_stream_refcell );
  free ( stx_stream_refcell );
  
  /* Free buffer */
  __REMOVE_REFCELL_CPP ( stx_buffer_refcell );
  free ( stx_buffer_refcell );

  /* Free nextBytes:into: symbol */
  __REMOVE_REFCELL_CPP ( stx_symbol_refcell );
  free ( stx_symbol_refcell );
}

unsigned int StxXercesInputStream::curPos() const {
  //TODO
  return 0;
}


unsigned int StxXercesInputStream::readBytes(XMLByte* const toFill, const unsigned int maxToRead) {  
  OBJ bytesRead;
  bytesRead = __SSEND2_CPP(*stx_stream_refcell, *stx_symbol_refcell, 0, __MKINT_CPP(MIN(CHUNK_SIZE, maxToRead)), *stx_buffer_refcell);
  strncpy((char*)toFill, (char*)(__ByteArrayInstPtr(*stx_buffer_refcell)->ba_element), __intVal(bytesRead));  
  return __intVal(bytesRead);
}

// takto implementovana by mela postacovat
const XMLCh* StxXercesInputStream::getContentType() const {
  return 0;
}
