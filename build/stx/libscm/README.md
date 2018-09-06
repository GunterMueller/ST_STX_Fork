# Mercurial support for Smalltalk/X

**stx:libscm** is a new source code management library for [Smalltalk/X][1]. Currently only [Mercurial][2] is supported
but its design allow for other source code management systems to by plugged in if required.

The Mercurial support consist of:

* low-level Mercurial API allowing to query and manipulate Mercurial repositories
* Integration into Smalltalk/X IDE allowing to commit, branch or merge Smalltalk/X packages directly within Smalltalk/x IDE. 

## Installation

1.  **Install Mercurial command line client.** 
    
    See [Mercurial wiki page](http://mercurial.selenic.com/wiki/Download) for details 
    how to install Mercurial on your machine. 

2.  **Download and run an installer script**
   
    Download [`HGInstaller.st`](https://bitbucket.org/janvrany/stx-libscm/raw/default/mercurial/HGInstaller.st) script and run it as:

    `stx --execute HGInstaller.st`

**NOTE**: Smalltalk/X *jv-branch* has Mercurial support already included,
so there's no need to install it explicitly.

See [installation instruction](https://bitbucket.org/janvrany/stx-libscm/wiki/Installation) for more details.

## Supported version

**stx:libscm** works - to some extent - on three Smalltalk/X versions

- [Smalltalk/X "jv branch"][6] - fully "supported" (i.e, all features should work, this is where libscm development takes place)
- Smalltalk/X "eXept HEAD" - should work, though not regularly tested. If not, please file in a bugreport here. 
- [Smalltalk/X 6.2.2][1] - generally not supported. The last version working on 6.2.2 was released as [1.0][7], which allows basic commit. If you need more recent version running on 6.2.2 (or any other older version), please contact the autor. 


For more detauls see [release notes](https://bitbucket.org/janvrany/stx-libscm/wiki/ReleaseNotes.md).

## More Information

- [Wiki][4]
- [User guide][5] (always incomplete :-)

## Support

As the stx:libscm comes free of charge, it comes with no warranty or whatsoever. For (commercial) support please 
contact the author.

## Author

Jan Vrany `<jan.vrany [at] fit.cvut.cz>`


[1]: http://www.exept.de/en/products/smalltalk-x.html
[2]: http://mercurial.selenic.com/
[3]: http://www.exept.de/en/products/smalltalkx/download
[4]: https://bitbucket.org/janvrany/stx-libscm/wiki/Home
[5]: http://swing.fit.cvut.cz/projects/stx/doc/online/english/help/HG/
[6]: https://swing.fit.cvut.cz/projects/stx-jv/
[7]: https://bitbucket.org/janvrany/stx-libscm/src/1.0