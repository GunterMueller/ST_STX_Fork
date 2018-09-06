![PetitParser](http://scg.unibe.ch/files/c0/gidr6vlrj4aw5k22a3y9fajle0qui0/petitparser-small.png)


# PetitParser and PetitCompiler for Smalltalk/X

## PetitParser 

*Grammars for programming languages are traditionally specified statically. 
They are hard to compose and reuse due to ambiguities that inevitably arise. 
**PetitParser** combines ideas from scannerless parsing, parser combinators, 
parsing expression grammars and packrat parsers to model grammars and parsers 
as objects that can be reconfigured dynamically.*

For more details on PetitParser itself refer to [PetitParser homepage](http://scg.unibe.ch/research/helvetia/petitparser)

## PetitCompiler

**PetitCompiler** compiles regular PetitParser grammars into an equivalent top-down 
parser implemented in Smalltalk. The compiled parser is significantly faster than
PetitParser based one. 

### Documentation 

For more information on how to use PetitCompiler refer to [wiki](https://bitbucket.org/janvrany/stx-goodies-petitparser/wiki/Home)

# Installation

See [installation notes](https://bitbucket.org/janvrany/stx-goodies-petitparser/wiki/Installation) on [wiki](https://bitbucket.org/janvrany/stx-goodies-petitparser/wiki/Home)

# License

The MIT License, see [LICENSE](https://bitbucket.org/janvrany/stx-goodies-petitparser/src/default/LICENSE.txt?at=default&fileviewer=file-view-default).

