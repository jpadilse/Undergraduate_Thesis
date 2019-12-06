#!/usr/bin/env python2.7
# Script: FormatBibTeX.py
# Author: Juan Felipe Padilla Sepulveda
# Date: 5 December 2019
"""
FormatBibTeX - formats BibTeX to conform to my conventions
"""
import sys
def ParseLine( line ) :
  """ Split line into LHS and RHS about ´=´
  """
  if -1 != line.find( ´=´ ) :
    # Handle case where there is a URL : I assume first ´=´ belongs to BibTeX
    vParts = line.strip().split( ´=´ )
    lhs = vParts[ 0 ]
    rhs = ´=´.join( vParts[ 1: ] ) # Pull full RHS back together
    vRet = [ lhs.strip(), rhs.strip() ]
  else :
    vRet = line.strip()
  return( vRet )
  
def CalcSize( item ) :
  """ Computes the size of the LHS before the ´=´
  """
  nSize = 0 ;
  if 2 == len( item ) :
    nSize = len( item[ 0 ] )
  return( nSize )
  
# Process the input
if __name__ == ´__main__´ :
  if 1 == len( sys.argv ) : 
    vLines = sys.stdin
  elif 2 == len( sys.argv ) :
    szInFile = sys.argv[ 1 ]
    vLines = open( szInFile, ´r´ )
  else : 
    raise SyntaxWarning
  
  # Process lines
  #vLines = open( ´C:\Users\jpadi\Downloads\thesis.bib´, ´r´ )
  vLines = open( szInFile, ´r´)
  vParsed = [ ]
  for line in vLines :
    vParsed.append( ParseLine( line ) )
    vSizeLHS = map( CalcSize, vParsed )
    nMaxLHS = max( vSizeLHS )
    
  vLines.close()
  
  # Nice Output
  
  cSpace  = ´ ´
  nIndent = 2
  for ( ix, item ) in enumerate( vParsed ) :
    if 0 == vSizeLHS[ ix ] :
      print item 
    else :
      print nIndent * cSpace + item[ 0 ] + ( nMaxLHS - vSizeLHS[ ix ] ) * 
        cSpace + ´ = ´ + item[ 1 ]
