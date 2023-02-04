# Ada Image Processor

## Author
Remus Calugarescu

## Last Major Modification
April 28, 2022

## Purpose
Mainly as an exercise for using Ada, this program takes a matrix of pixel values between 0 and 255, each number represents a pixel and its shade with 0 being white, and 255 being black. Images can then be generated through this system through the PGM (Portable Gray Map) file format.

## Installing dependencies
First you must have gnat installed, you can do so by running
~~~~
sudo apt install gnat-8 -y
~~~~

## Input and output files
An input file must be formatted in the following way, excluding any text that is surrounded by brackets. An output file will be formatted in the same way as an input file
~~~~
P2    (Magic identifier, P2 is ASCII, P5 is Binary)
24 7  (Columns and Rows)
255   (Maximum shade value)
0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
0  3  3  3  3  0  0  7  7  7  7  0  0 11 11 11 11  0  0 15 15 15 15  0
0  3  0  0  0  0  0  7  0  0  0  0  0 11  0  0  0  0  0 15  0  0 15  0
0  3  3  3  0  0  0  7  7  7  0  0  0 11 11 11  0  0  0 15 15 15 15  0
0  3  0  0  0  0  0  7  0  0  0  0  0 11  0  0  0  0  0 15  0  0  0  0
0  3  0  0  0  0  0  7  7  7  7  0  0 11 11 11 11  0  0 15  0  0  0  0
0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
~~~~

## Running the program
After running the following commands, you may view the output in the file that you chose in while running the program.
~~~~
1. gnatmake -Wall imagepgm.adb imageprocess.adb image.adb 
2. ./image
~~~~

## Output example
This output is based off of testFiles/imageTest2.pgm, the PGM files were converted to PNG through [ImageJ](https://imagej.nih.gov/ij/download.html)
![Image Transformation Examples](https://i.imgur.com/9h4SvzK.png)
