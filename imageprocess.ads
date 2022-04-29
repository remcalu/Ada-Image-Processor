-- Name:                    Remus Calugarescu
-- Example Program Call:    gnatmake -Wall imagepgm.adb imageprocess.adb image.adb && ./image

package imageprocess is

   -- Type definition for a histogram array
   type histogram is array(1 .. 256) of integer;

   -- Type definition for a probability density function
   type pdf is array (1 .. 256) of float;

   -- Type definition for the cumulative histogram
   type histogramCum is array(1 .. 256) of float;

   -- Record definition for any given pgm file
   type arrTwoDims is array(integer range <>, integer range <>) of integer;
   type pgmFile(sizeRows : integer; sizeCols : integer) is
      record
         imagePVal : string(1 .. 2);
         imageRows : integer;
         imageCols : integer;
         imageMaxVal : integer;
         imagePixels : arrTwoDims(1 .. sizeRows, 1 .. sizeCols);
      end record;

   -- Subprogram definition that performs an image inversion
   procedure imageINV(pgmFileObj : in out pgmFile);

   -- Subprogram definition that performs a logarithmic transformation
   procedure imageLOG(pgmFileObj : in out pgmFile);

   -- Subprogram definition that performs contrast stretching
   procedure imageSTRETCH(pgmFileObj : in out pgmFile; iMin : in integer; iMax : in integer);
   
   -- Subprogram definition that generates a histogram of an image, returning the histogram as a 1d array
   function makeHIST(pgmFileObj : in pgmFile) return histogram;

   -- Subprogram definition that performs a histogram equalization
   procedure histEQUAL(pgmFileObj : in out pgmFile);

end imageprocess;