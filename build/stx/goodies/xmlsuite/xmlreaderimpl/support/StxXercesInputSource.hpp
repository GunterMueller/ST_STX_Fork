/*
 * StxXercesInputSource.h
 *
 *  Created on: Dec 8, 2008
 *      Author: honza
 */

#ifndef STXINPUTSOURCE_H_
#define STXINPUTSOURCE_H_

#include "StxCPPUtils.h"
#include "StxXercesInputStream.hpp"
#include <xercesc/sax/InputSource.hpp>



class StxXercesInputSource : public xercesc_2_8::InputSource {

protected:
  StxXercesInputStream* input_stream;
  
public:
  StxXercesInputSource(OBJ stx_stream);

  virtual ~StxXercesInputSource();

  BinInputStream* makeStream() const;
};

#endif /* MYINPUTSOURCE_H_ */
