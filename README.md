This repository contains all the code related to SER-502 projects


Installation and Project Setup:

1) Install the version 3.8.9 of the Python.

2) Set the environment variables for scripts and python folders.

3) Install pip install pyswip for intergrating with prolog using below command.

pip install pyswip

4) Go to Compiler folder in src and run the below command that will ask for the file .namp that will generate the .ic file.

C:\Users\nchintap\Documents\GitHub\SER502-Spring2022-Team5\src\compiler> python compiler.py
Enter code file name: factorial.namp

5) Go to the runtime folder in src and run the below command that will ask for the file .ic that will give the output.

C:\Users\nchintap\Documents\GitHub\SER502-Spring2022-Team5\src\runtime> python runtime.py

Enter code file namp: factorial.ic

6) data folder contains few sample exmaples with .ic files with respective .nampfiles for testing.

7) If any new program should be written make sure we are space(indentation)  for each word or sentence for the lexer to generate the tokens properly.
