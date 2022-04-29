-- Name:                    Remus Calugarescu
-- Example Program Call:    gnatmake -Wall imagepgm.adb imageprocess.adb image.adb && ./image

with imageprocess; use imageprocess;

package imagepgm is

   -- Subprogram definition that takes a filename and returns a record representing the image
   function readPGM(inputFileName : in string) return pgmFile;

   -- Subprogram definition that takes an input a record representing an image, then write the image to file as P2 PGM format
   procedure writePGM(outputFileName : in string; pgmFileObj : in pgmFile);
    
end imagepgm;