-- Name:                    Remus Calugarescu
-- Example Program Call:    gnatmake -Wall imagepgm.adb imageprocess.adb image.adb && ./image

with imagepgm; use imagepgm;
with imageprocess; use imageprocess;
with Ada.Text_IO; use Ada.Text_IO;

procedure image is

   -- Function to check if a certain file exists
   function fileExists(fileName : in string) return boolean is
      fp : file_type;
      status : boolean := TRUE;
   begin
      begin
         open(fp, in_file, fileName);
         close(fp);
      exception
         when name_error => 
            status := FALSE;
      end;
      return status;
   end fileExists;

   -- Function to get the file name choice from the user
   function getFilename(mode : in string) return string is
      line : string (1 .. 1000);
      last : natural := 0;
      lineConfirm : string (1 .. 1000);
      lastConfirm : natural := 0;
      valid : boolean := FALSE;
   begin
      -- Modes r and w exist, where r is for reading, w is for writing
      if mode = "r" then
         put_line("┏┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┓");
         put_line("┋  Welcome to an Ada basic image processing program  ┋");
         put_line("┗┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┛");
         put_line("Start by entering the name of a .PGM file that is located in the current directory");

         -- Looping until a file that exists is entered as the input file
         while valid = FALSE loop
            get_line(line, last);

            -- Checking if the file exists
            if fileExists(line(1 .. last)) then
               valid := TRUE;
            else 
               put_line("");
               put_line("ERROR: File doesn't exist, enter the name of a file that exists");
            end if;
         end loop;
         put_line("");

      elsif mode = "w" then
         put_line("Enter the name of the output file for the modified .PGM file");

         -- Looping until a file that doesn't exist is entered as the output file, or if the user chooses to overwrite the output file
         while valid = FALSE loop
            get_line(line, last);
            put_line("");

            -- Checking if the file exists
            if fileExists(line(1 .. last)) then
               put_line("ERROR: File already exists, overwrite? Enter Y for yes, or anything else for no");
               get_line(lineConfirm, lastConfirm);
               put_line("");

               -- Giving the user the option to overwrite the output file, or to enter a new name of a file that doesn't exist
               if lineConfirm(1 .. lastConfirm) = "Y" then
                  valid := TRUE;
               else
                  put_line("Enter the name of the output file for the modified .PGM file");
               end if;

            else 
               valid := TRUE;
            end if;
         end loop;
      end if;

      return line(1 .. last);
   end getFilename;

   -- Function to get the image processing choice from the user
   function getOperationChoice return string is
      line : string (1 .. 1000);
      last : natural := 0;
      valid : boolean := FALSE;
   begin
      put_line("There are several image processing options that are listed below, select by typing in either A, B, C, or D");
      put_line("(A) Performs an image inversion");
      put_line("(B) Performs a logarithmic transformation");
      put_line("(C) Performs a contrast stretch");
      put_line("(D) Performs a histogram equalization");

      -- Looping until valid input is received (A, B, C, or D)
      while valid = FALSE loop
         get_line(line, last);
         put_line("");

         -- Checking if if the user entered A, B, C, or D
         if line(1 .. last) = "A" or line(1 .. last) = "B" or line(1 .. last) = "C" or line(1 .. last) = "D" then
            valid := TRUE;
         else 
            put_line("ERROR: Enter either A, B, C, or D");
         end if;
      end loop;
      return line(1 .. last);
   end getOperationChoice;

   -- Function to get the iMin value
   function getImin return integer is
      line : string (1 .. 1000);
      last : natural := 0;
   begin
      put_line("Enter an iMin value to be used for contrast stretching using imageSTRETCH");
      get_line(line, last);
      put_line("");
      return integer'Value(line(1 .. last));
   end getImin;

   -- Function to get the iMax value
   function getImax return integer is
      line : string (1 .. 1000);
      last : natural := 0;
   begin
      put_line("Enter an iMax value to be used for contrast stretching using imageSTRETCH");
      get_line(line, last);
      put_line("");
      return integer'Value(line(1 .. last));
   end getImax;

   -- Main procedure
   inputFileName : constant string := getFilename("r");
   inputOperationChoice : constant string := getOperationChoice;
   outputFileName : constant string := getFilename("w");
   pgmFileObj : pgmFile := readPGM(inputFileName);
begin

   -- Selecting the correct transformation to perform
   if inputOperationChoice = "A" then
      imageINV(pgmFileObj);
   elsif inputOperationChoice = "B" then
      imageLOG(pgmFileObj);
   elsif inputOperationChoice = "C" then
      -- Getting the iMin and iMax if contrast stretching is chosen
      declare
         iMin : constant integer := getImin;
         iMax : constant integer := getImax;
      begin
         imageSTRETCH(pgmFileObj, iMin, iMax);
      end;
   elsif inputOperationChoice = "D" then
      histEQUAL(pgmFileObj);
   end if;

   -- Writing data to PGM file
   writePGM(outputFileName, pgmFileObj);
   put_line("Finished processing the file, check your output file for the results");

end image;
