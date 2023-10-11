from pyswip import Prolog
import os

class runtime_main():
   if __name__ == '__main__':
    #Provide the file name of intermediate code to execute it.
    filename = input("Enter code file name : ")
    os.chdir('..')
    os.chdir('../data')
    fileread = open(filename,'r').read()
    prolog = Prolog()
    os.chdir('..')
    os.chdir('src/runtime')
    prolog.consult('parseval.pl')
    # Create a query to execute the intermediate code in prolog with the static inputs.
    query = "program_eval("+fileread+",9,3,Z)"
    output = list(prolog.query(query))
    mid_output = str(output[-1])
    final_output = str(mid_output.split(",")[-1])[1:-1]
    # Print the final output after the execution of the program.
    print(final_output)
