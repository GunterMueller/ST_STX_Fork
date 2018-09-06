# SmallSense

*Developer's productivity plugin for Smalltalk/X IDE.*

## About

**SmallSense** is a set of tools that speed up development and make
Smalltalk programming even more fun. Features:

* **Code-completion** -- a fast code completion system for Smalltalk using both static and runtime type inference.
* **Syntax-driven editing** -- a nice little feature that helps you with editing and formatting the code, all syntax- and formater-preferences aware!
* **Instant static analysis** -- to detect & fix common errors and code smells as you type

There are many more features already on the TODO list :-) Besides, *SmallSense*
provides (limited) support for Java anf Groovy as well (to be used together with
[STX:LIBJAVA](1))

## Installation

### Stock Smalltalk/X (aka official version)

Following instructruction are for stock Smalltalk/X 6.2.5 as downloaded from
[eXept]. 

**1. Remove old SmallSense:** remove directory `/stx/goodies/smallsense`. Smalltalk/X may come with it's own version/fork of SmallSense. 

**2. Check out SmallSense:** 

    hg clone https://bitbucket.org/janvrany/stx-goodies-smallsense stx/goodies/smallsense
    
**3. Compile it (optional):**

On UNIX: 

    make -C /stx/goodies/smallsense -f Makefile.init
    
On Windows: 

    cd stx\goodies\smallsense && bmake
    
**4. Load it:** to load it into an IDE, evaluate:

    Smalltalk loadPackage:'stx:goodies/smallsense'
    
You may want to add the above to your startup script (`$HOME/.smalltalk/p_$USER.rc) so SmallSense will be loaded automatically when you start Smalltalk/X. You may also want to turn on [method swizzling](4) there. 

### Smalltalk/X jv-branch

There's no need to install SmallSense into [Smalltalk/X jv-branch](3) as it is 
loaded automatically when you start Smalltalk/X. 


## Configuration

After installing and loading SmallSense, you may want to configure it. To do so,
open system settings and go to *Tools* ⊳ *SmallSense*.


## Authors

Developers:

* Jan Vraný <jan . vrany [a] fit.cvut.cz>

Contributors:

* Jakub Zelenka (first version of code completion, type inference and syntax-error tolerant Smalltalk parser)

## License

The SmallSense is available under GNU Lesser General Public License.
Please find full text of the license in file license.txt.
For other licensing options, please contact the SmallSense author at
jan.vrany { at } fit.cvut.cz.

[1]: https://swing.fit.cvut.cz/projects/stx-libjava
[2]: ftp://exept.de/download/stx/
[3]: https://swing.fit.cvut.cz/projects/stx-jv
[4]: https://bitbucket.org/janvrany/stx-goodies-smallsense/wiki/Swizzling.md




