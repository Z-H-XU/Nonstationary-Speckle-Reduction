FANS
Date released 31/07/2013, version 1.0.
Functions for Matlab for the denoising of a SAR image corrupted
by multiplicative speckle noise with the technique described in 
"Fast Adaptive Nonlocal SAR Despeckling", written by
D. Cozzolino, S. Parrilli, G. Scarpa, G. Poggi and L. Verdoliva,
Geoscience and Remote Sensing Letters, in press, 2013.
Please refer to this paper for a more detailed description of the algorithm.

-------------------------------------------------------------------
 Copyright
-------------------------------------------------------------------

Copyright (c) 2013 Image Processing Research Group of University Federico II of Naples ('GRIP-UNINA').
All rights reserved.
This work should only be used for nonprofit purposes.

By downloading and/or using any of these files, you implicitly agree to all the
terms of the license, as specified in the document LICENSE.txt
(included in this package) and online at
http://www.grip.unina.it/download/LICENSE_CLOSED.txt

-------------------------------------------------------------------
 Installation
-------------------------------------------------------------------

Unzip the archive and add the folder to the search path of MATLAB.

-------------------------------------------------------------------
 Contents
-------------------------------------------------------------------

The package comprises the function "FANS".
For help on how to use this script, you can e.g. use "help FANS".

-------------------------------------------------------------------
 Requirements
-------------------------------------------------------------------

All the functions and scripts were tested on MATLAB 2011b,
the operation is not guaranteed with older version of MATLAB.
The software uses the OpenCV library (http://opencv.org/), all
necessary files are included in the archive.

The version for Windows 64 bit requires Microsoft
Visual C++ 2010 Redistributable Package (x64). It can be
downloaded from: 
	http://www.microsoft.com/download/details.aspx?id=14632
	
The version for Windows 32 bit requires Microsoft
Visual C++ 2010 Redistributable Package (x86). It can be
downloaded from:
	http://www.microsoft.com/download/details.aspx?id=5555

-------------------------------------------------------------------
 Execution times
-------------------------------------------------------------------

Execution times were evaluated on two different computers:
Machine 1: Intel(R) Core(TM) 2 Q9550 2,83Ghz 32bit; 3Gb Memory
Machine 2: Intel(R) Core(TM) i7-2600 3,40Ghz 64bit; 8Gb Memory

dim.    |  Mac. 1 |  Mac. 2 |
256x256 |   4 sec |   2 sec |
512x512 |  16 sec |   8 sec |

-------------------------------------------------------------------
 Feedback
-------------------------------------------------------------------

If you have any comment, suggestion, or question, please do
contact Luisa Verdoliva at verdoliv@unina.it
For other information you can see http://www.grip.unina.it/
