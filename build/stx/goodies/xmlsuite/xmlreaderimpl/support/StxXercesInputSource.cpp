/*
 * StxXercesInputSource.cpp
 *
 *  Created on: Dec 8, 2008
 *      Author: honza
 */

#include "StxXercesInputStream.hpp"
#include "StxXercesInputSource.hpp"

OBJ  xerces_stx_StxInputSource_new(OBJ st_stream) {  
  return __MKEXTERNALADDRESS_CPP(new StxXercesInputSource(st_stream));
}

void xerces_stx_StxInputSource_delete(OBJ stx_input_source_address) {
    
  delete (StxXercesInputSource*)__externalAddressVal(stx_input_source_address);
}




StxXercesInputSource::StxXercesInputSource(OBJ stx_stream) {
  input_stream = new StxXercesInputStream(stx_stream);
}

StxXercesInputSource::~StxXercesInputSource() {
  //delete input_stream;
  input_stream = 0;
}

BinInputStream* StxXercesInputSource::makeStream() const {  
  return input_stream;
}
