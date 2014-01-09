meegpipe
========

_meegpipe_ is a collection of MATLAB tools for building advanced processing
pipelines for high density physiological recordings. It is especially
suited for the processing of high-density [EEG][eeg] and [MEG][meg],
but can also handle other modalities such as [ECG][ecg], temperature,
[actigraphy][acti], light exposure, etc.


[gg]: https://groups.google.com/forum/#!forum/meegpipe
[ggh]: http://germangh.com
[eeg]: http://en.wikipedia.org/wiki/Electroencephalography
[meg]: http://en.wikipedia.org/wiki/Magnetoencephalography
[ecg]: http://en.wikipedia.org/wiki/Electrocardiography
[acti]: http://en.wikipedia.org/wiki/Actigraphy

In the documentation below I often assume a Linux-like system (e.g. use of
frontslashes, `~` to denote home directory, etc). However, _meegpipe_ should
also run under Windows. If you are using Windows, some of the commands that
appear below might need minor modifications like replacing `~` by your home
directory name.


## Pre-requisites

If you are working at somerengrid (our lab's private computing grid), then all the
pre-requisites are already there and you can go directly to the installation instructions.
Otherwise, you will have to install the requirements below.


### Fieldtrip and EEGLAB

[Fieldtrip][ftrip] and [EEGLAB][eeglab] are required mostly for input/output
of data from/to various data formats, and for plotting. Please __do not__ add
Fieldtrip and EEGLAB to your MATLAB search path. Instead simply edit
[+meegpipe/meegpipe.ini][meegpipecfg] to include the paths to the root
directories of Fieldtrip and EEGLAB on your system.

[meegpipecfg]: http://github.com/germangh/meegpipe/blob/master/%2Bmeegpipe/meegpipe.ini
[ftrip]: http://fieldtrip.fcdonders.nl/
[eeglab]: http://sccn.ucsd.edu/eeglab/
[fileio]: http://fieldtrip.fcdonders.nl/development/fileio
[matlab-package]: http://www.mathworks.nl/help/matlab/matlab_oop/scoping-classes-with-packages.html

### Python

A. Kenneth Reitz has written an excellent guide on
[how to install Python][python-install]. _meegpipe_ requires a Python 2.x
interpreter, where x is ideally at least 7.

[python]: http://python.org
[python-install]: http://docs.python-guide.org/en/latest/starting/installation/

If your OS is Linux-based (that includes Mac OS X) chances are that Python is
already installed on your system. In that case, open a terminal and ensure that
you have the required version of Python:

	python --version


On Mac OS X you may also need to install [XCode][xcode].

[xcode]: https://developer.apple.com/xcode/


### easy_install and pip

See the [Python installation guide][python-install] for instructions on how to
install __easy_install__ and __pip__ on your system.

[easy_install]: https://pypi.python.org/pypi/setuptools#installation-instructions
[pip]: https://pypi.python.org/pypi/pip


### Python development tools (Linux only)

If your Linux distro uses the [yum package manager][yum] run:

    sudo yum install python-devel

If your Linux distro uses [apt-get][apt-get] to manage packages then run instead:

    sudo apt-get install python-dev

[yum]: http://yum.baseurl.org/
[apt-get]: http://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_basic_package_management_operations

### Remark

The [Remark][remark] python library is required for generating HTML reports.
To install Remark in Mac OS X and Linux run from the command line:

[remark]: http://kaba.hilvi.org/remark/remark.htm

    sudo pip install remark

In Windows, open a terminal and run:

    easy_install pillow
    pip install remark


### Inkscape

[Inkscape][inkscape] is required for generating the thumbnail images that
are embedded in the data processing reports. To install on Linux run:

    sudo yum install inkscape

or

    sudo apt-get install inkscape

For Windows and Mac OS X you can use the installation packages available at
[Inkscape's web page][inkscape].

[inkscape]: http://en.dev.inkscape.org/download/
[pygments]: http://pygments.org/
[markdown]: http://freewisdom.org/projects/python-markdown/
[pil]: http://www.pythonware.com/products/pil/


### Optional dependencies

You are encouraged to install a few [additional components][optional] that can
considerably enhance _meegpipe_'s functionality. In particular, it is
strongly recommended that you use [Google Chrome][gc] to inspect the HTML
reports generated by _meegpipe_.


[optional]: https://github.com/meegpipe/meegpipe/blob/master/optional.md
[gc]: www.google.com/chrome

## Installation

Get the code in [.zip format](https://github.com/meegpipe/meegpipe/archive/master.zip)
and extract it to a local directory (below I will assume that you used
directory `~/meegpipe`). Once this is done you should edit the configuration of
_meegpipe_ by defining the locations of the third-party MATLAB dependencies
(Fieldtrip and EEGLAB) on your system. Do this by following the
 instructions in [~/meegpipe/+meegpipe/meegpipe.ini][ini].

## Basic usage

Before anything else you will have to add _meegpipe_ and its dependencies
to your MATLAB search path:

``````matlab
restoredefaultpath;
addpath(genpath('~/meegpipe'));
meegpipe.initialize;
````

The commands above will ensure that your MATLAB search path contains __only__
the MATLAB sources that are needed for _meegpipe_ to run.
Namely, _meegpipe_ itself, and a subset of Fieldtrip and EEGLAB. The
`restoredefaultpath` command is important to ensure that other toolboxes do
not interfere with _meegpipe_. On the other hand, _meegpipe_ components are
all encapsulated in [MATLAB packages][matlab-pkg], which should prevent
_meegpipe_ interfering with other toolboxes. Thus it should be relatively
 safe for you to add the three lines above to your MATLAB [startup][startup]
 function so that you don't need to type them every time you start MATLAB.

[startup]: http://www.mathworks.nl/help/matlab/ref/startup.html
[eeglab]: http://sccn.ucsd.edu/eeglab/
[ftrip]: http://fieldtrip.fcdonders.nl/
[ini]: http://github.com/meegpipe/meegpipe/blob/master/%2Bmeegpipe/meegpipe.ini
[matlab-pkg]: http://www.mathworks.nl/help/matlab/matlab_oop/scoping-classes-with-packages.html


### Data import

````matlab
import physioset.import.*;
% Import from an .mff file
data = import(mff, 'myfile.mff');
% Import from an EDF+ file
data = import(edfplus, 'myfile.edf');
% Import MATLAB built-in numerics
data = import(matrix, randn(10,10000));
````
All data importer classes implement an `import()` method, which always
produces a [physioset][physioset] object. For more information and a list
of available data importers see the [documentation][import-docs].


[import-docs]: ./+physioset/+import/README.md
[physioset]: https://github.com/meegpipe/meegpipe/blob/master/%2Bphysioset/%40physioset/README.md




### Data processing nodes


````matlab
import meegpipe.*;
import physioset.import.matrix;

data = import(matrix, randn(10,10000));

% Detrend using a 10th order polynomial
myNode1 = node.detrend.new('PolyOrder', 10);
run(myNode1, data);

% Filter data using a tfilter (temporal filter) node
% First build a band-pass filter object
myFilter = filter.bpfilt('Fp', [0.1 0.3]);
% And then use it to construct the node
myNode2 = node.tfilter.new('Filter', myFilter);
run(myNode2, data);
````

For more information and a list of available processing nodes, see the
[documenation][nodes-docs].

[wiki-ref]: http://en.wikipedia.org/wiki/Reference_(computer_science)
[nodes-docs]: ./+meegpipe/+node/README.md


### Processing reports

One of the great features of _meegpipe_ is that it generates comprehensive
HTML reports for every data processing task. In the example above, you
should have got a warning saying something like:

> <strong>Warning</strong>: A new session was created in folder 'session_1' <br>
> In session.session>session.instance at 82 <br>
>  In pset.generate_data at 35 <br>
>  In matrix.import at 62 <br>

This means that _meegpipe_ just created a directory `session_1`, which will be
used to store, among other things, the data processing reports. Namely, you can
find a node's HTML report under:

    session_1/[DATA].meegpipe/[NODE]_[USR]_[SYS]/remark/index.htm

where

* __DATA__ is a string identifying the processed [physioset][physioset]. Use
 method `get_name()` to find out the name of a [physioset][physioset] object.

* __NODE__ is a string identifying the _processing node_. It is a combination of
 the node name (which can be obtained using method `get_name()`) and a hash code that
 summarizes the node configuration.

* __USR__ is just the name of the user that ran command `run()`.

* __SYS__ is a string identifying the operating system and MATLAB version (e.g. _PCWIN64-R2011b_).


__NOTE for Windows 8 users__: For some unknown reason neither Firefox nor
Google Chrome are able to display local .svg files, when running under
Windows 8. Whenever trying to do so, both browsers attempt to download the
file and thus the file is not displayed. Read the
[document on known issues and limitations][issues] for ways to overcome
this problem.
[issues]: ./issues.md


### Pipelines

A _pipeline_ is just a concatenation of nodes. With the exception of
[physioset_import][node-physioset_import] nodes, all other node classes always
take a [physioset][physioset] as input.

[node-physioset_import]: https://github.com/meegpipe/meegpipe/blob/master/%2Bmeegpipe/%2Bnode/%2Bphysioset_import/%40physioset_import/physioset_import.m

````matlab
import meegpipe.*;
import physioset.import.*;
myNode1  = node.physioset_import.new('Importer', mff);
myFilter = filter.bpfilt('Fp', [0.1 0.3]);
myNode2  = node.tfilter.new('Filter', myFilter);
myPipe   = node.pipeline.new('NodeList', {myNode1, myNode2});

% Will read from .mff file, and band-pass filter the data it contains
data = run(myPipe, 'myfile.mff');

````

### Data export

````matlab
% Create a random EEG physioset
mySensors = sensors.eeg.from_template('egi256');
mySensors = subset(mySensors, 1:10:256);
myImporter = physioset.import.matrix('Sensors', mySensors);
data = import(myImporter, randn(26, 2000));
% Export to EEGLAB
myEEGLABStr = eeglab(data);
% Export to Fieldtrip
myFTripStr = fieldtrip(data);
````

## More information

See the practical [tutorials](http://github.com/meegpipe/meegpipe/tree/master/tutorials)
for some typical use cases of _meegpipe_. A high-level description of the API components
can be found in the [documentation][doc-main], which is still work
in progress.

[doc-main]: https://github.com/meegpipe/meegpipe/blob/master/%2Bmeegpipe/README.md

## Attribution

For convenience, _meegpipe_ ships together with code from third-parties.
You can find a comprehensive list [here][attribution].

[attribution]: https://github.com/meegpipe/meegpipe/blob/master/attribution.md



## License

Any code that is not part of any of the bundled third-party dependencies
(see [the list][attribution]), is released under the
[Creative Commons Attribution-NonCommercial-ShareAlike licence](http://creativecommons.org/licenses/by-nc-sa/3.0/).
