/*
 * StxXercesInputStream.hpp
 *
 *  Created on: Dec 8, 2008
 *      Author: Jan Kurs
 */

#ifndef STXINPUTSTREAM_H_
#define STXINPUTSTREAM_H_


#include "StxCPPUtils.h"
#include <xercesc/util/BinInputStream.hpp>



XERCES_CPP_NAMESPACE_USE

class StxXercesInputStream: public BinInputStream {

protected:
  OBJ* stx_stream_refcell;
  OBJ* stx_buffer_refcell;
  OBJ* stx_symbol_refcell;
public:
  
  StxXercesInputStream(OBJ stx_stream);

  virtual ~StxXercesInputStream();
  
  virtual unsigned int curPos() const;
  virtual unsigned int readBytes(XMLByte* const toFill, const unsigned int maxToRead);
  virtual const XMLCh* getContentType() const;
};


#endif /* STXINPUTSTREAM_H_ */

