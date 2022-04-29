with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package body imageprocess is

   -- Subprogram definition that performs an image inversion
   procedure imageINV(pgmFileObj : in out pgmFile) is
      calculatedVal : integer := 0;
   begin
      -- Transforming values
      for curRow in 1 .. pgmFileObj.imageRows loop
         for curCol in 1 .. pgmFileObj.imageCols loop
            calculatedVal := Abs(255 - pgmFileObj.imagePixels(curRow, curCol));

            -- Ensuring that all values are within the correct bounds
            if calculatedVal < 0 then
               calculatedVal := 0;
            elsif calculatedVal > pgmFileObj.imageMaxVal then
               calculatedVal := pgmFileObj.imageMaxVal;
            end if;

            pgmFileObj.imagePixels(curRow, curCol) := calculatedVal;
         end loop;
      end loop;
   end imageINV;

   -- Subprogram definition that performs a logarithmic transformation
   procedure imageLOG(pgmFileObj : in out pgmFile) is
      calculatedVal : integer := 0;
   begin
      -- Transforming values
      for curRow in 1 .. pgmFileObj.imageRows loop
         for curCol in 1 .. pgmFileObj.imageCols loop
            calculatedVal := integer(log(float(pgmFileObj.imagePixels(curRow, curCol))) * (255.0/log(255.0)));
            
            -- Ensuring that all values are within the correct bounds
            if calculatedVal < 0 then
               calculatedVal := 0;
            elsif calculatedVal > pgmFileObj.imageMaxVal then
               calculatedVal := pgmFileObj.imageMaxVal;
            end if;

            pgmFileObj.imagePixels(curRow, curCol) := calculatedVal;
         end loop;
      end loop;
   end imageLOG;

   -- Subprogram definition that performs contrast stretching
   procedure imageSTRETCH(pgmFileObj : in out pgmFile; iMin : in integer; iMax : in integer) is
      calculatedVal : integer := 0;
   begin
      -- Transforming values
      for curRow in 1 .. pgmFileObj.imageRows loop
         for curCol in 1 .. pgmFileObj.imageCols loop
            calculatedVal := integer(255 * ((pgmFileObj.imagePixels(curRow, curCol)) - (iMin))/((iMax) - (iMin)));

            -- Ensuring that all values are within the correct bounds
            if calculatedVal < 0 then
               calculatedVal := 0;
            elsif calculatedVal > pgmFileObj.imageMaxVal then
               calculatedVal := pgmFileObj.imageMaxVal;
            end if;
            
            pgmFileObj.imagePixels(curRow, curCol) := calculatedVal;
         end loop;
      end loop;
   end imageSTRETCH;

   -- Subprogram definition that generates a histogram
   function makeHIST(pgmFileObj : in pgmFile) return histogram is
      curIndex : integer := 0;
      curHistogram : histogram; 
   begin
      -- Initializing the whole histogram to 0
      for counter in 1 .. 256 loop
         curHistogram(counter) := 0;
      end loop;

      -- Populating the histogram
      for curRow in 1 .. pgmFileObj.imageRows loop
         for curCol in 1 .. pgmFileObj.imageCols loop
            curIndex := pgmFileObj.imagePixels(curRow, curCol) + 1;
            curHistogram(curIndex) := curHistogram(curIndex) + 1;
         end loop;
      end loop;
      return(curHistogram);
   end makeHIST;

   -- Subprogram definition that performs a histogram equalization
   procedure histEQUAL(pgmFileObj : in out pgmFile) is
      calculatedVal : integer := 0;
      curPdf : pdf;
      curHistogramCum : histogramCum;
      curHistogram : constant histogram := makeHIST(pgmFileObj); 
   begin
      -- Calculating the probability density function
      for counter in 1 .. 256 loop
         curPdf(counter) := float(curHistogram(counter)) / float(pgmFileObj.imageRows * pgmFileObj.imageCols);
      end loop;

      -- Calculating the cumulative histogram
      for counter in 1 .. 256 loop
         case counter is
            when 1 => 
               curHistogramCum(counter) := curPdf(counter);
            when others =>
               curHistogramCum(counter) := curHistogramCum(counter-1) + curPdf(counter);
         end case;
      end loop;

      -- Performing the multiplication on the cumulative histogram
      for counter in 1 .. 256 loop
         curHistogramCum(counter) := float(integer(255.0 * curHistogramCum(counter)));
      end loop;

      -- Modifying the pixel array to use the cumulative histogram values
      for curRow in 1 .. pgmFileObj.imageRows loop
         for curCol in 1 .. pgmFileObj.imageCols loop
            calculatedVal := Integer(curHistogramCum(pgmFileObj.imagePixels(curRow, curCol)));
            
            -- Ensuring that all values are within the correct bounds
            if calculatedVal < 0 then
               calculatedVal := 0;
            elsif calculatedVal > pgmFileObj.imageMaxVal then
               calculatedVal := pgmFileObj.imageMaxVal;
            end if;

            pgmFileObj.imagePixels(curRow, curCol) := calculatedVal;
         end loop;
      end loop;
   end histEQUAL;

end imageprocess;
