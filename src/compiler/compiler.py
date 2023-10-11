from pyswip import Prolog
import os
from pathlib import Path

class compiler_main():
   if __name__ == '__main__':
    filename = input("Enter code file name : ")
    os.chdir('..')
    os.chdir('../data')
    #Reading the file to split the code into strings to pass it to the prolog.
    fileread = open(filename,'r').read()
    fileread = fileread.replace('{','\'{\'')
    fileread = fileread.replace('}','\'}\'')
    fileread = fileread.replace('(','\'(\'')
    fileread = fileread.replace(')','\')\'')
    tokenlist =fileread.split()
    tokens =  ', '.join(map(str, tokenlist))
    finalist = '[' + tokens + ']'
    #Created the query to pass it to the prolog to generate the intermediate code.
    query = "program(P," + finalist + ",[])."
    prolog = Prolog()
    os.chdir('..')
    os.chdir('src/compiler')
    prolog.consult('parse_tree.pl')
    output = list(prolog.query(query))
    otp = str(output[0])
    otp = otp[7:len(otp)-2]
    icfilename = filename[0:-5]
    os.chdir('..')
    os.chdir('..')
    os.chdir('data')
    #Created a file to save the intermediate code.
    f=open(icfilename+".ic","w")
    f.write(otp)
    f.close()
