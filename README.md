# Smalltalk/X jv-branch build tool

This tools allows anyone to rebuild [Smalltalk/X jv-branch][1] from (almost) scratch. It fetches sources
from various repositories, put them together and compile the whole thing. For those without an access to
**stc** and **librun** sources, it automatically downloads latest pre-build versions from [SWING CI server][2].

## A quick quide for the impatient

In shell, execute:
    
    hg clone https://bitbucket.org/janvrany/stx-goodies-builder-rake stx-jv
    cd stx-jv
    rake

Go out for a short or long walk, depending on your internet connection and CPU power. Once `rake` finishes, you have compiled [Smalltalk/X jv-branch][1]yourself. Have fun!

## Usage

For more details on usage please see [wiki][3].

## Disclaimer

The internals of these build scripts are mess...emh...convoluted. A lot of hacks accumulated over years.
We aim to clean that up, if time allows. For now, it does its job. 

## Contributing

Anyone wishing to help is welcomed! If you encounter a problem. please 
fill in a report to [Smalltalk/X jv-branch bug tracker][4]. 

To contribute,  either

* fork the [repository on BitBucket][5] and [send a pull request][6]. 
* send a patch to [stx-jv@googlegroups.com][7].

## License

Copyright (c) 2010-now Jan Vrany <jan.vrany (a) fit.cvut.cz>

This software is licensed under "MIT license". You may find a full license text in `LICENSE.txt`.

[1]: https://swing.fit.cvut.cz/projects/stx-jv/
[2]: https://swing.fit.cvut.cz/jenkins
[3]: https://swing.fit.cvut.cz/projects/stx-jv/wiki/Documentation/BuildingStXWithRakefiles
[4]: https://swing.fit.cvut.cz/projects/stx-jv/newticket
[5]: https://bitbucket.org/janvrany/stx-goodies-builder-rake
[6]: https://www.atlassian.com/git/tutorials/making-a-pull-request/
[7]: https://groups.google.com/forum/#!forum/stx-jv