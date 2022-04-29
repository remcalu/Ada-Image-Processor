with Ada.Text_IO; use Ada.Text_IO;
with Ada.integer_Text_IO; use Ada.integer_Text_IO;
with Ada.Task_Identification;  use Ada.Task_Identification;

package body imagepgm is

   -- Subprogram body that takes a filename and returns a record representing the image
   function readPGM(inputFileName : in string) return pgmFile is
      inFp : file_type;
      filePVal : string(1 .. 2);
      fileValOther : integer := 0;
      fileCols : integer := 0;
      fileRows : integer := 0;
      fileMaxVal : integer := 0;
      iteration : integer := 0;
   begin
      open(inFp, in_file, inputFileName);

      -- Looping the first time to get number of rows and columns and verifying the input file
      put_line("Verifying that the input file is of the correct format...");
      begin
         -- Looping through the input file
         while not end_of_file(inFp) and iteration /= 4 loop
            iteration := iteration + 1;

            -- When on the first iteration, get the P value
            case iteration is
               when 1 => 
                  -- Reading the first line and getting it as a string, checking if the file is P2
                  get(inFp, filePVal);
                  if filePVal /= "P2" then
                     put_line("ERROR: Incorrect magic value, needs to be P2");
                     put_line("Exiting program");
                     close(inFp);
                     abort_task(current_task);
                  end if;
               when others =>
                  -- Reading all other lines as an integer
                  get(inFp, fileValOther);
            end case;

            -- When on the 2nd iteration get the number of columns, when on the 3rd iteration get the number of rows, when on the 4rd iteration get the max value of each datapoint
            case iteration is
               when 1 =>
                  null;
               when 2 =>
                  -- Parsing the second line, first number that appears and checking if its between 0 and 500 (constraints set up by prof)
                  fileCols := fileValOther;
                  if fileCols > 500 or fileCols < 0 then
                     put_line("ERROR: Number of rows must be between 0 and 500 inclusive");
                     put_line("Exiting program");
                     close(inFp);
                     abort_task(current_task);
                  end if;
               when 3 =>
                  -- Parsing the second line, second number that appears and checking if its between 0 and 500 (constraints set up by prof)
                  fileRows := fileValOther;
                  if fileRows > 500 or fileRows < 0 then
                     put_line("ERROR: Number of rows must be between 0 and 500 inclusive");
                     put_line("Exiting program");
                     close(inFp);
                     abort_task(current_task);
                  end if;
               when 4 =>
                  -- Parsing the third line, ensuring that the pixel value is greater than 0 as a negative max value makes no sense
                  fileMaxVal := fileValOther;
                  if fileMaxVal < 0 then
                     put_line("ERROR: Maximum pixel value must be greater than 0");
                     put_line("Exiting program");
                     close(inFp);
                     abort_task(current_task);
                  end if;
               when others =>
                  null;
            end case;
         end loop;
      exception
         -- Using exception handling to deal with end of file
         when end_error =>
            null;
         when data_error =>
            put_line("ERROR: Inconsistencies found when reading header values file");
            put_line("Exiting program");
            abort_task(current_task);
      end;

      -- Looping 2nd time to populate the 2d array
      declare
         pgmFileObj : pgmFile(fileRows, fileCols);
         curRow : integer := 1;
         curCol : integer := 1;
      begin
         -- Assigning values to the pgm file record
         pgmFileObj.imagePVal := filePVal;
         pgmFileObj.imageCols := fileCols;
         pgmFileObj.imageRows := fileRows;
         pgmFileObj.imageMaxVal := fileMaxVal;
         begin
            -- Looping through the input file
            while not end_of_file(inFp) and curRow <= fileRows loop

               -- Resetting the column and incrementing the row once finished scanning a line
               if curCol > fileCols then
                  curCol := 1;
                  curRow := curRow + 1;
               end if;
               
               get(inFp, fileValOther);

               -- Verifying that the current pixel is between 0 and the maximum pixel value specified inclusive
               if fileValOther < 0 or fileValOther > fileMaxVal then
                  put_line("ERROR: Encountered a pixel that has a value less than 0 or greater than the max pixel value");
                  put_line("Exiting program");
                  close(inFp);
                  abort_task(current_task);
               end if;
               pgmFileObj.imagePixels(curRow, curCol) := fileValOther;

               curCol := curCol + 1;
            end loop;
         exception
            -- Using exception handling to deal with end of file
            when end_error =>
               null;
            when data_error =>
               put_line("ERROR: Inconsistencies found when reading pixel values from file");
               put_line("Exiting program");
               abort_task(current_task);
         end;
         put_line("Input file has been successfully verified");
         put_line("");
         close(inFp);
         return(pgmFileObj);
      end;
   end readPGM;

   -- Subprogram body that takes an input a record representing an image, then write the image to file as P2 PGM format
   procedure writePGM(outputFileName : in string; pgmFileObj : in pgmFile) is
      outFp : file_type;
      curRow : integer := 1;
      curCol : integer := 1;
   begin
      -- Creating file and setting new file pointer
      create(outFp, out_file, outputFileName);
      set_output(outFp);

      -- Printing meta data of image
      put_line(pgmFileObj.imagePVal);
      put(pgmFileObj.imageCols, Width => 0);
      put(" ");
      put(pgmFileObj.imageRows, Width => 0);
      put_line("");
      put(pgmFileObj.imageMaxVal, Width => 0);
      put_line("");

      -- Printing pixel data of image
      while curRow <= pgmFileObj.imageRows loop
         -- Resetting the column and incrementing the row once finished scanning a line
         if curCol > pgmFileObj.imageCols then
               curCol := 1;
               curRow := curRow + 1;
               put_line(" ");
         end if;

         -- Exiting to not go out of bounds
         exit when curRow > pgmFileObj.imageRows;

         -- Outputting pixel data in desired format
         put(pgmFileObj.imagePixels(curRow, curCol), Width => 0);
         if curCol < pgmFileObj.imageCols then
               put(" ");
         end if;

         curCol := curCol + 1;
      end loop;
      set_output(standard_output);
      close(outFp);
   end writePGM;

end imagepgm;
