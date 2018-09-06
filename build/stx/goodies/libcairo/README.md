# Cairo for Smalltalk/X

**stx:goodies/libcairo** is a Smalltalk/X package providing integration of [Cairo graphics library][1]. 
It contains a drop-in replacement for native GC ([DeviceGraphicsContext][5]) to switch 
rendering of some or all windows to Cairo. 

## Features

* Full access to Cairo API
* Full support for icons with alpha channel
* Full support for transparency (alpha) for all drawing operations (lines, rectangles)
* Full and correct support for arbitrary transformation
* Almost-pixel identical results on Windows and Linux (X11)
* Ready for Quartz (Mac OS X) and Wayland (X11 seems to be phasing out)
* **Integrates with Smalltalk/X so complete application can be rendered using Cairo**

## Screenshot

![Launcher](https://bitbucket.org/janvrany/stx-goodies-libcairo/wiki/screenshot_013.png)

## Starting Points

**For the impatient**
Following code will install [CairoGraphicsContext][6] as graphics 
device's default graphics context so new windows will be rendered using Cairo:

    Screen current graphicsContextClass: CairoGraphicsContext.

To revert back to standard rendering, evaluate: 

    Screen current graphicsContextClass: Screen current class graphicsContextClass

For more defailts, see:

* [Wiki][7]
* [Examples][8] in particular

## Supported versions of Smalltalk/X

**stx:goodies/libcairo** is available for [Smalltalk/X "jv branch"][2], both
**Windows and Linux**, 32bit and 64bit. 

Should you need Cairo on any other version of Smalltalk/X, please contact the author by email. 

## Author

Jan Vrany `<jan.vrany [at] fit.cvut.cz>`

## License

![CC-BY-NC](https://i.creativecommons.org/l/by-nc/4.0/88x31.png)

This software is licensed under [Creative Commons Attribution-NonCommercial 4.0 International License][3]. You may find a full license text in `LICENSE.txt`.

In short, you are free to:

* **Share** — copy and redistribute the material in any medium or format,
* **Adapt** — remix, transform, and build upon the material,

under the following terms: 

* **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made, 
* **NonCommercial** — You may not use the software for commercial purposes.

For permissions beyond the scope of this license see [Licensing][4].

[1]: http://www.cairographics.org
[2]: https://swing.fit.cvut.cz/projects/stx-jv/
[3]: http://creativecommons.org/licenses/by-nc/4.0/
[4]: https://bitbucket.org/janvrany/stx-goodies-libcairo/wiki/Licensing
[5]: http://swing.fit.cvut.cz/hg/stx.libview/file/jv/DeviceGraphicsContext.st
[6]: https://bitbucket.org/janvrany/stx-goodies-libcairo/src/default/CairoGraphicsContext.st
[7]: https://bitbucket.org/janvrany/stx-goodies-libcairo/wiki/Home
[8]: https://bitbucket.org/janvrany/stx-goodies-libcairo/wiki/examples/Examples
