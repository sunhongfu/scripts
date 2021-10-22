/************************************************************************** 
  
                        Mask Filling Algorithm
 
                                    Created by M Ethan MacDonald
 
   This mex function has the utility of filling in the whole in a mask, and 
 performs advanced smoothing around the outside edges of ray cast masks.
 
   The only inputs to be concerned is the mask, a 3D volume of values either 
 1 or 0. The other input is the required number of adjacent unmasked voxels; 
 It would be good to select voxels on the order of 3 or 9. The output is the 
 new mask.
 
   The algorithm will fill in points in the mask until there are no more voxels 
 with less empty adjacent voxles.
 
 Example Syntax:
 
    [ OutputMask ] = MaskFilling( OldMask, numAdjacentEmptyVoxels ) ;
 
*/

/* include some nessisary headers */
#include "mex.h"
#include "matrix.h"

#include <math.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define DEBUG_MASK_FILLING

class Mask_Filling {
    
public:
    Mask_Filling(){
        maxNumPasses = 50 ;
        newPtsFound = true ;
    }
    ~Mask_Filling(){}
  
    double * Mask ;
    double * OutputMask ;
    int threshold ;
    int dims[3] ;
    
    int numPtsInMask ;
    int numPtsAddedThisPass ;
    int passCount ;
    int maxNumPasses ;
    int numTotalPtsFilled ;
    bool newPtsFound ;
    
    void fillmask( void ) {
        
#ifdef DEBUG_MASK_FILLING
    printf( "DEBUG_MASK_FILLING: starting mask filling process\n" ) ;
    printf( "DEBUG_MASK_FILLING: \n"
            " dims = [ %i %i %i ] ", dims[0], dims[1], dims[2] ) ;
            
#endif
        init_output() ;

#ifdef DEBUG_MASK_FILLING
    printf( "DEBUG_MASK_FILLING: finished initializing the mask\n" ) ;
#endif
        passCount = -1 ;
        while( passCount < maxNumPasses && newPtsFound ) {
            passCount++ ;
            
            check_all_pts_in_mask() ;
            
#ifdef DEBUG_MASK_FILLING
    printf( "DEBUG_MASK_FILLING: pass %i / %i, numPtsAddedThisPass = %i\n",
        passCount, maxNumPasses, numPtsAddedThisPass ) ;
#endif

            if( numPtsAddedThisPass == 0 ) 
                newPtsFound = false ;
            
            numPtsAddedThisPass = 0 ;
            
        }

#ifdef DEBUG_MASK_FILLING
    printf( "DEBUG_MASK_FILLING: finishing mask filling process\n" ) ;
#endif

    }
    
    void init_output( void ) {
    
        for( int zCount = 0 ; zCount < dims[2] ; zCount++ ) {
        for( int yCount = 0 ; yCount < dims[1] ; yCount++ ) {
        for( int xCount = 0 ; xCount < dims[0] ; xCount++ ) {
            
            OutputMask[(xCount)+dims[0]*(yCount)+dims[0]*dims[1]*(zCount)] = 
                    Mask[(xCount)+dims[0]*(yCount)+dims[0]*dims[1]*(zCount)] ;
            
        } } } 
    }
    
    void check_all_pts_in_mask( void ) {
        
        for( int zCount = 0 ; zCount < dims[2] ; zCount++ ) {
        for( int yCount = 0 ; yCount < dims[1] ; yCount++ ) {
        for( int xCount = 0 ; xCount < dims[0] ; xCount++ ) {
            
            if( OutputMask[(xCount)+dims[0]*(yCount)+dims[0]*dims[1]*(zCount)] == 0.0 ) {
            
            //printf( "getting here\n" ) ; 
                
            if( zCount < dims[2]-1 && zCount > 1 &&
                yCount < dims[1]-1 && yCount > 1 &&
                xCount < dims[0]-1 && xCount > 1 ) {
                
            //printf( "getting here again\n" ) ; 
            
                int sum_of_adjacent = 
                    OutputMask[(xCount  )+dims[0]*(yCount  )+dims[0]*dims[1]*(zCount+1)]
                  //+ Mask[(xCount  )+dims[0]*(yCount  )+dims[0]*dims[1]*(zCount  )
                  + OutputMask[(xCount  )+dims[0]*(yCount  )+dims[0]*dims[1]*(zCount-1)]
                  + OutputMask[(xCount  )+dims[0]*(yCount+1)+dims[0]*dims[1]*(zCount+1)]
                  + OutputMask[(xCount  )+dims[0]*(yCount+1)+dims[0]*dims[1]*(zCount  )]
                  + OutputMask[(xCount  )+dims[0]*(yCount+1)+dims[0]*dims[1]*(zCount-1)]
                  + OutputMask[(xCount  )+dims[0]*(yCount-1)+dims[0]*dims[1]*(zCount+1)]
                  + OutputMask[(xCount  )+dims[0]*(yCount-1)+dims[0]*dims[1]*(zCount  )]
                  + OutputMask[(xCount  )+dims[0]*(yCount-1)+dims[0]*dims[1]*(zCount-1)]
                  + OutputMask[(xCount+1)+dims[0]*(yCount  )+dims[0]*dims[1]*(zCount+1)]
                  + OutputMask[(xCount+1)+dims[0]*(yCount  )+dims[0]*dims[1]*(zCount  )]
                  + OutputMask[(xCount+1)+dims[0]*(yCount  )+dims[0]*dims[1]*(zCount-1)]
                  + OutputMask[(xCount+1)+dims[0]*(yCount+1)+dims[0]*dims[1]*(zCount+1)]
                  + OutputMask[(xCount+1)+dims[0]*(yCount+1)+dims[0]*dims[1]*(zCount  )]
                  + OutputMask[(xCount+1)+dims[0]*(yCount+1)+dims[0]*dims[1]*(zCount-1)]
                  + OutputMask[(xCount+1)+dims[0]*(yCount-1)+dims[0]*dims[1]*(zCount+1)]
                  + OutputMask[(xCount+1)+dims[0]*(yCount-1)+dims[0]*dims[1]*(zCount  )]
                  + OutputMask[(xCount+1)+dims[0]*(yCount-1)+dims[0]*dims[1]*(zCount-1)]
                  + OutputMask[(xCount-1)+dims[0]*(yCount  )+dims[0]*dims[1]*(zCount+1)]
                  + OutputMask[(xCount-1)+dims[0]*(yCount  )+dims[0]*dims[1]*(zCount  )]
                  + OutputMask[(xCount-1)+dims[0]*(yCount  )+dims[0]*dims[1]*(zCount-1)]
                  + OutputMask[(xCount-1)+dims[0]*(yCount+1)+dims[0]*dims[1]*(zCount+1)]
                  + OutputMask[(xCount-1)+dims[0]*(yCount+1)+dims[0]*dims[1]*(zCount  )]
                  + OutputMask[(xCount-1)+dims[0]*(yCount+1)+dims[0]*dims[1]*(zCount-1)]
                  + OutputMask[(xCount-1)+dims[0]*(yCount-1)+dims[0]*dims[1]*(zCount+1)]
                  + OutputMask[(xCount-1)+dims[0]*(yCount-1)+dims[0]*dims[1]*(zCount  )]
                  + OutputMask[(xCount-1)+dims[0]*(yCount-1)+dims[0]*dims[1]*(zCount-1)] ;
                    
                //if( sum_of_adjacent != 0 ) 
                //    printf( "sum_of_adjacent = %i\n", sum_of_adjacent ) ;
                
                if( sum_of_adjacent > threshold ) {
                    OutputMask[(xCount)+dims[0]*(yCount)+dims[0]*dims[1]*(zCount)] = 1.0 ;
                    numPtsAddedThisPass++ ;
                }
                
            } }
            
        } } } 
        
    }
};

/* run the mex file opperations */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
    
#ifdef DEBUG_MASK_FILLING
    printf( "DEBUG_MASK_FILLING: starting function\n" ) ;
#endif
    
    double * mask ;
    mask = mxGetPr ( prhs[0] ) ;
    mwSize * ImageDim = (mwSize *) mxGetDimensions( prhs[0] ) ;
    int dimensions[3] ;
    dimensions[0] = ( int ) ImageDim[0] ;
    dimensions[1] = ( int ) ImageDim[1] ;
    dimensions[2] = ( int ) ImageDim[2] ; 
    
    double * Threshold ;
    Threshold = mxGetPr ( prhs[1] ) ;
    
    
#ifdef DEBUG_MASK_FILLING
    printf( "DEBUG_MASK_FILLING: read back inputs\n"
            "\t threshold = %i \n"
            "\t dimensions = %i %i %i \n",
            (int)Threshold[0], 
            (int)dimensions[0], (int)dimensions[1], (int)dimensions[2] ) ;
#endif
    
    Mask_Filling mf ;
    
    mwSize ndims = 3 ;
    const int dims[] = { dimensions[0], dimensions[1], dimensions[2] } ;   
    plhs[ 0 ] = mxCreateNumericArray( ndims, dims, mxDOUBLE_CLASS, mxREAL ) ;
    mf.OutputMask = mxGetPr( plhs[ 0 ] ) ;
     
    mf.Mask = mask ;
    mf.threshold = Threshold[0] ;
    mf.dims[0] = (double)dimensions[0] ;
    mf.dims[1] = (double)dimensions[1] ;
    mf.dims[2] = (double)dimensions[2] ;
    
    mf.fillmask();
    
#ifdef DEBUG_MASK_FILLING    
    printf( "DEBUG_MASK_FILLING: number of points filled in = %i\n", 
            mf.numTotalPtsFilled ) ;
#endif    
    
}
