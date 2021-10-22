/************************************************************************** 
  
                        Brain Extractor
 
                                    Created by M Ethan MacDonald
 
   This mex function has the utility of brain extraction. The method is similiar
 to that described by S Smith, FSL, 2002, and Gobbi, VTK, 2012. A seed 
 is dropped in the volume and a sphere is drawn around it, the program then 
 casts rays to the edge of the brain volume.
 
   This file has a class that will return one of 4 mask types, including: 
 the seed point, the sphere contour, and the brain contour and the brain 
 mask.
 
 Example Syntax:
 
    [ SeedMask, InnerSphereContour, BrainContour, BrainMask ] = 
          BrainExtractor( ImageVol, Seed, Dimensions, numAngles, 
          innerSphereSize, gradientThreshold, 7x7_ray_filter_kernel, 
          maxRayLength, rayResolution ) ;
 
*/

/* include some nessisary headers */
#include "mex.h"
#include "matrix.h"

#include <math.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define DEBUG_BRAIN_EXTRACTION

class Brain_Extractor {
    
public:
    Brain_Extractor(){}
    ~Brain_Extractor(){}
  
    double * ImageData ;
    void AddVolume( double * Vol ) {
        ImageData = Vol ;
        
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: sizeof(ImageData) = %i\n", sizeof(*ImageData) ) ;
#endif

    }
    
    int * Seed ;
    void SetSeed( int * seed ) {
        Seed = seed ;
    }
    
    int * Dimensions ;
    void SetDimensions( int * dimensions ) {
        Dimensions = dimensions ;
    }
    
    int * numAnglesPhiTheta ;
    double * PhiDirections ;
    double * ThetaDirections ;
    void SetNumAngles( int * numAngles ) {
        
        numAnglesPhiTheta = numAngles ;        
        PhiDirections = new double[numAnglesPhiTheta[0]] ;
        ThetaDirections = new double[numAnglesPhiTheta[1]] ;
        
        // populate Angle Directions
        for( int phiCount = 0 ; phiCount < numAnglesPhiTheta[0] ; phiCount++ ) {
            PhiDirections[phiCount] = (double) (phiCount+1) / 
            	(double) numAnglesPhiTheta[0] * 180 ; //3.1415 ;
            
#ifdef DEBUG_BRAIN_EXTRACTION
            //printf( "DEBUG_BRAIN_EXTRATION: PhiDirections[%i] = %f\n", 
            //       phiCount, PhiDirections[phiCount] ) ;
#endif
        }
        for( int thetaCount = 0 ; thetaCount < numAnglesPhiTheta[1] ; thetaCount++ ) {
            ThetaDirections[thetaCount] = (double) (thetaCount+1) / 
            	(double) numAnglesPhiTheta[1] * 360 ; //2*3.1415 ;                 
            
#ifdef DEBUG_BRAIN_EXTRACTION
            //printf( "DEBUG_BRAIN_EXTRATION: thetaDirections[%i] = %f\n", 
            //       thetaCount, ThetaDirections[thetaCount] ) ;
#endif
        }    
    }
    
    int innerSphereSize ;
    void SetInnerSphereSize( int sphereSize ) {
        innerSphereSize = sphereSize ;
    }
    
    int maxRayLength ;
    void SetMaxRayLength( int rayLength ) {
        maxRayLength = rayLength ;
    }
    
    double rayResolution ;
    void SetRayResolution( double res ) {
        rayResolution = res ;
    }
    
    double gradThreshold ;
    void SetGradThreshold( double thres ) {
        gradThreshold = thres ;
    }
    
    int erosion_level ;
    void SetErosionLevel( int level ) {
        erosion_level = level ;
    }
    
    //double avgSigInSphere = 0 ;
    
    bool * seed_mask ;
    bool * inner_sphere_contour_mask ;
    bool * brain_contour_mask ;
    bool * brain_mask ;
    bool * eroded_brain_mask ;
    
    void seedMask( void ) {
        
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: seedMask starting\n" ) ;
#endif
        //mask = new bool[Dimensions[0]*Dimensions[1]*Dimensions[2]] ;
        memset( seed_mask, false, sizeof(seed_mask) ) ;
        
        for( int zCount = 0 ; zCount < Dimensions[2] ; zCount++ ) {
        for( int yCount = 0 ; yCount < Dimensions[1] ; yCount++ ) {
        for( int xCount = 0 ; xCount < Dimensions[0] ; xCount++ ) {
                    
            if( xCount == Seed[0] && yCount == Seed[1] 
             && zCount == Seed[2] ) {

#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRACTION: seedMask found seed location\n" ) ;
    //printf( "DEBUG_BRAIN_EXTRACTION: seed location - x:%i y:%i z:%i\n",
    //        xCount, yCount, zCount ) ;
#endif
                seed_mask[xCount+yCount*Dimensions[0]
                        +zCount*Dimensions[0]*Dimensions[1]] = true ;           
            } else {
                seed_mask[xCount+yCount*Dimensions[0]
                        +zCount*Dimensions[0]*Dimensions[1]] = false ;      
            }
            
        }}}
         
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: seedMask completed\n" ) ;
#endif
        //return mask ;
    }
    
    void sphereCountour( void ) {
        
        int spherePixelCount = 0 ;
        
        //mask = new bool[Dimensions[0]*Dimensions[1]*Dimensions[2]] ;
        memset( inner_sphere_contour_mask, false, sizeof(inner_sphere_contour_mask) ) ;
        
        for( int phiCount = 0 ; phiCount < numAnglesPhiTheta[0] ; phiCount++ ) {
        for( int thetaCount = 0 ; thetaCount < numAnglesPhiTheta[1] ; thetaCount++ ) {
        
            int xPos = floor( ((double)innerSphereSize)*rayResolution 
                             * sin( PhiDirections[phiCount] ) 
                             * cos( ThetaDirections[thetaCount] ) ) + Seed[0] ;
            int yPos = floor( ((double)innerSphereSize)*rayResolution 
                             * sin( PhiDirections[phiCount] ) 
                             * sin( ThetaDirections[thetaCount] ) ) + Seed[1] ;
            int zPos = floor( ((double)innerSphereSize)*rayResolution 
                             * cos( PhiDirections[phiCount] ) )     + Seed[2] ;
            
#ifdef DEBUG_BRAIN_EXTRACTION
        //printf( "DEBUG_BRAIN_EXTRATION: xPos = %i, yPos = %i, zPos = %i\n",
        //    xPos, yPos, zPos ) ;
#endif
            if( xPos >= 0 && xPos < Dimensions[0]
               && yPos >= 0 && yPos < Dimensions[1] 
               && zPos >= 0 && zPos < Dimensions[2] ) {

                inner_sphere_contour_mask[xPos+yPos*Dimensions[0]
                     + zPos*Dimensions[0]*Dimensions[1]] = true ;
            }
        }} 
    }
    
    double * filter ;
    
    void countourBrain( void ) {
        
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: contourBrain starting\n" ) ;
    //int debugCounter = 0 ;
    //printf( "DEBUG_BRAIN_EXTRACTOR: row major size of rayProfiles = %i\n",
    //         numAnglesPhiTheta[0]*numAnglesPhiTheta[1] 
    //             * (int)(maxRayLength/rayResolution) ) ;
#endif
        //mask = new bool[Dimensions[0]*Dimensions[1]*Dimensions[2]] ;
        memset( brain_contour_mask, false, sizeof(brain_contour_mask) ) ;
        
        int rayCount = -1 ;
        double * rayProfiles = ( double * ) 
            malloc( sizeof(double) * numAnglesPhiTheta[0]*numAnglesPhiTheta[1] 
                 * (int)(maxRayLength/rayResolution) ) ;
     
        for( int phiCount = 0 ; phiCount < numAnglesPhiTheta[0] ; phiCount++ ) {
        for( int thetaCount = 0 ; thetaCount < numAnglesPhiTheta[1] ; thetaCount++ ) {

#ifdef DEBUG_BRAIN_EXTRACTION
        //printf( "DEBUG_BRAIN_EXTRACTION: PhiDirection[%i] = %f, ThetaDirection[%i] = %f,\n", 
        //    phiCount, PhiDirections[phiCount], thetaCount, ThetaDirections[thetaCount] ) ;
#endif

            rayCount++ ;
            for( int radiusCount = 0 ; radiusCount < (int)(maxRayLength/rayResolution) ; 
                radiusCount++ ) {

#ifdef DEBUG_BRAIN_EXTRACTION
        //printf( "radiusCount = %i\n", radiusCount ) ;
        //if( phiCount == 1 && thetaCount == 1 ) 
        //    printf( "DEBUG_BRAIN_EXTRATION: rayCount = %i, radiusCount = %i\n",
        //        rayCount, radiusCount ) ;
#endif

                    
                int xPos = floor( (double)radiusCount*rayResolution 
                           * sin( PhiDirections[phiCount] ) 
                           * cos( ThetaDirections[thetaCount] ) ) + Seed[0] ;
                int yPos = floor( (double)radiusCount*rayResolution 
                           * sin( PhiDirections[phiCount] ) 
                           * sin( ThetaDirections[thetaCount] ) ) + Seed[1] ;
                int zPos = floor( (double)radiusCount*rayResolution 
                           * cos( PhiDirections[phiCount] ) )     + Seed[2] ;
                
#ifdef DEBUG_BRAIN_EXTRACTION
        //printf( "DEBUG_BRAIN_EXTRATION: xPos = %i, yPos = %i, zPos = %i\n",
        //    xPos, yPos, zPos ) ;
        //    printf( "rayCount = %i\n", rayCount ) ;
        //debugCounter++ ;
#endif

                if( xPos >= 0 && xPos < Dimensions[0]
                   && yPos >= 0 && yPos < Dimensions[1] 
                   && zPos >= 0 && zPos < Dimensions[2] ) {
                
                        rayProfiles[rayCount
                            *(int)(maxRayLength/rayResolution)
                            +radiusCount] =
                                ImageData[xPos+yPos*Dimensions[0]+zPos
                                *Dimensions[0]*Dimensions[1]] ;

                
#ifdef DEBUG_BRAIN_EXTRACTION
        //printf( "DEBUG_BRAIN_EXTRACTION: profile count = %i\n", 
        //    rayCount *(int)(maxRayLength/rayResolution) +radiusCount ) ;
        //if( phiCount == 175 )
        //   printf( "DEBUG_BRAIN_EXTRATION: rayProfiles[%i] = %f\n",
        //        radiusCount, rayProfiles[rayCount
        //                    *(int)(maxRayLength/rayResolution)
        //                    +radiusCount] ) ;
#endif 
                }
                
            }
        }}
   
#ifdef DEBUG_BRAIN_EXTRACTION
    //sleep(1);
    //printf( "DEBUG_BRAIN_EXTRATION: debugCounter = %i\n", debugCounter ) ;
    //printf( "DEBUG_BRAIN_EXTRATION: contourBrain: completed extracting rays\n" ) ;
#endif

        rayCount = -1 ;
        double rayLength = 0 ;
        bool ptFound = false ;
        for( int phiCount = 0 ; phiCount < numAnglesPhiTheta[0] ; phiCount++ ) {
        for( int thetaCount = 0 ; thetaCount < numAnglesPhiTheta[1] ; thetaCount++ ) {
                
            rayCount++ ;
            rayLength = 0 ;
            ptFound = false ;
            for( int radiusCount = innerSphereSize ; radiusCount < maxRayLength/rayResolution ;
                radiusCount++ ) {

#ifdef DEBUG_BRAIN_EXTRACTION
        //if( rayCount == 1 )
        //    printf( "DEBUG_BRAIN_EXTRATION: gradient[%i][%i] = %f\n",
        //        rayCount, radiusCount, gradient[rayCount][radiusCount] ) ;
#endif  
                if( ptFound == false 
                            && rayProfiles[rayCount
                            * ( int )( maxRayLength / rayResolution )
                            + radiusCount ] < gradThreshold ) {

                    ptFound = true ;
                    rayLength = ( (double) radiusCount ) * rayResolution ;
                    
#ifdef DEBUG_BRAIN_EXTRACTION
        //printf( "DEBUG_BRAIN_EXTRATION: setting new rayLength = %f\n",
        //       rayLength ) ;
#endif

                }
            }    

            if( ptFound == true ) {
 
                int xPos = floor( rayLength * sin( PhiDirections[phiCount] ) 
                                 * cos( ThetaDirections[thetaCount] ) ) + Seed[0] ;
                int yPos = floor( rayLength * sin( PhiDirections[phiCount] ) 
                                 * sin( ThetaDirections[thetaCount] ) ) + Seed[1] ;
                int zPos = floor( rayLength * cos( PhiDirections[phiCount] ) ) 
                                 + Seed[2] ;

#ifdef DEBUG_BRAIN_EXTRACTION
        //printf( "DEBUG_BRAIN_EXTRATION: counture point found\n" ) ;
        //printf( "DEBUGxPos = %i, yPos = %i, zPos = %i\n",
        //    xPos, yPos, zPos ) ;
        //printf( "rayLength = %f\n", rayLength ) ;
#endif
                if( xPos > 0 && xPos < Dimensions[0]
                   && yPos > 0 && yPos < Dimensions[1] 
                   && zPos > 0 && zPos < Dimensions[2] ) {
    
                    brain_contour_mask[xPos+yPos*Dimensions[0]
                            +zPos*Dimensions[0]*Dimensions[1]] = true ;
                    
#ifdef DEBUG_BRAIN_EXTRACTION
        //printf( "DEBUG_BRAIN_EXTRATION: Setting Brain Contour true : "
        //    "xPos = %i, yPos = %i, zPos = %i\n",
        //    xPos, yPos, zPos ) ;
        //printf( "DEBUG_BRAIN_EXTRATION: rayLength = %f\n", rayLength ) ;
#endif
                }
            }

        }} 
        free( rayProfiles ) ;
        
        //return mask ;
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: contourBrain completed\n" ) ;
#endif

    }
    
///////////////////////////////////////////////////////////////////////////
    // Mask Brain
    
    
    void maskBrain( void ) {
        
#ifdef DEBUG_BRAIN_EXTRACTION
    int debugCounter = 0 ;
    //printf( "DEBUG_BRAIN_EXTRATION: maskBrain started\n" ) ;
#endif
        //mask = new bool[Dimensions[0]*Dimensions[1]*Dimensions[2]] ;
        memset( brain_mask, false, sizeof(brain_mask) ) ;
        
        int rayCount = -1 ;
        //bool lastPointInVol[numAnglesPhiTheta[0]][numAnglesPhiTheta[1]] ;
        bool * lastPointInVol = (bool *) malloc( sizeof(bool) * 
                numAnglesPhiTheta[0]*numAnglesPhiTheta[1] ) ;
        //memset( lastPointInVol, false, sizeof(lastPointInVol) ) ;
        memset( lastPointInVol, true, sizeof(bool) 
                 * numAnglesPhiTheta[0]*numAnglesPhiTheta[1] ) ;
        
        //bool rayLengthFound[numAnglesPhiTheta[0]][numAnglesPhiTheta[1]] ;
        bool * rayLengthFound = (bool *) malloc( sizeof(bool) * 
                numAnglesPhiTheta[0]*numAnglesPhiTheta[1] ) ;
        //memset( rayLengthFound, false, sizeof(lastPointInVol) ) ;
        memset( rayLengthFound, false, sizeof(bool) 
                 * numAnglesPhiTheta[0]*numAnglesPhiTheta[1] ) ;
        
        //int lastPointInVolLength[numAnglesPhiTheta[0]][numAnglesPhiTheta[1]] ;
        int * lastPointInVolLength = (int *) malloc( sizeof(int) * 
                numAnglesPhiTheta[0]*numAnglesPhiTheta[1] ) ;
        //memset( lastPointInVolLength, -1.0, sizeof(lastPointInVolLength) ) ;
        memset( lastPointInVolLength, -1, sizeof(int)
                 * numAnglesPhiTheta[0]*numAnglesPhiTheta[1] ) ;
        
        float * rayProfiles = ( float * ) 
            malloc( sizeof(float) * numAnglesPhiTheta[0]*numAnglesPhiTheta[1] 
                 * maxRayLength ) ;
        memset( rayProfiles, -1.0, sizeof(float) 
                 * numAnglesPhiTheta[0]*numAnglesPhiTheta[1] 
                 * maxRayLength ) ;
  
        //float rayLength[numAnglesPhiTheta[0]][numAnglesPhiTheta[1]] ;
        float * rayLength = (float *) malloc( sizeof(float) * 
                numAnglesPhiTheta[0]*numAnglesPhiTheta[1] ) ;
        memset( rayLength, 0.0, sizeof(float) * 
                numAnglesPhiTheta[0]*numAnglesPhiTheta[1] ) ;
               
        //float filteredRayLength[numAnglesPhiTheta[0]][numAnglesPhiTheta[1]] ;
        float * filteredRayLength = (float *) malloc( sizeof(float) * 
                numAnglesPhiTheta[0]*numAnglesPhiTheta[1] ) ;
        memset( filteredRayLength, 0.0, sizeof(float) *
                numAnglesPhiTheta[0]*numAnglesPhiTheta[1] ) ;

        int angleCount = -1 ;
        for( int phiCount = 0 ; phiCount < numAnglesPhiTheta[0] ; phiCount++ ) {
        for( int thetaCount = 0 ; thetaCount < numAnglesPhiTheta[1] ; thetaCount++ ) {
            angleCount++ ;
                
            rayCount++ ;
            int largestLength = 0 ;
            for( int radiusCount = 0 ; radiusCount < maxRayLength ;
                radiusCount++ ) {
                        
                int xPos = floor( (float)radiusCount*rayResolution 
                                 * sin( PhiDirections[phiCount] ) 
                                 * cos( ThetaDirections[thetaCount] ) ) +Seed[0] ;
                int yPos = floor( (float)radiusCount*rayResolution 
                                 * sin( PhiDirections[phiCount] ) 
                                 * sin( ThetaDirections[thetaCount] ) ) +Seed[1] ;
                int zPos = floor( (float)radiusCount*rayResolution
                                 * cos( PhiDirections[phiCount] ) )     +Seed[2] ;

                if(   xPos > 0 && xPos < Dimensions[0]
                   && yPos > 0 && yPos < Dimensions[1] 
                   && zPos > 0 && zPos < Dimensions[2] ) {
                    
                    rayProfiles[rayCount*maxRayLength
                        +radiusCount] = ImageData[xPos+yPos*Dimensions[0]+zPos
                            *Dimensions[0]*Dimensions[1]] ;

                    if( largestLength <= pow( 
                            pow( xPos-Seed[0], 2 ) 
                          + pow( yPos-Seed[1], 2 ) 
                          + pow( zPos-Seed[2], 2 ), 0.5 ) ) {
                            
                        largestLength = pow( 
                            pow( xPos-Seed[0], 2 ) 
                          + pow( yPos-Seed[1], 2 ) 
                          + pow( zPos-Seed[2], 2 ), 0.5 ) ;
                    }
                } else {
                    if( lastPointInVol[rayCount] == true ) {
                        
                        lastPointInVol[rayCount] = false ;
                        lastPointInVolLength[rayCount] = 
                            (int)(largestLength/rayResolution) ;
                        //rayLength[rayCount] = 
                        //  (int)(lastPointInVolLength[rayCount]) ;
                        
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRACTION: rayCount = %i, largestLength = %i,\n",
    //    rayCount, largestLength ) ;
#endif
                    }
                }
            }
                
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRACTION: rayProfile[rayCount]
#endif
        }}
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: complete ray extraction\n" ) ;
    //printf( "DEBUG_BRAIN_EXTRATION: rayResolution = %f\n", rayResolution ) ;
#endif

        rayCount = -1 ;

        bool ptFound = false ;
               
        for( int phiCount = 0 ; phiCount < numAnglesPhiTheta[0] ; phiCount++ ) {
        for( int thetaCount = 0 ; thetaCount < numAnglesPhiTheta[1] ; thetaCount++ ) {
            
            rayCount++ ;
            ptFound = false ;
            rayLength[rayCount] = 0 ;
            
            for( int radiusCount = 0 ; radiusCount < maxRayLength ;
                radiusCount++ ) {
                
                if( ptFound == false 
                            && rayProfiles[rayCount*maxRayLength
                                +radiusCount] < gradThreshold 
                            && radiusCount >= innerSphereSize ) {
                    
                    ptFound = true ;
                    rayLength[rayCount] = ((float)radiusCount);//*rayResolution ;
                    rayLengthFound[rayCount] = true ;
                    
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: rayLength[%i] = %f\n", 
    //    rayCount, rayLength[rayCount] ) ;
#endif
                } 
            }
            
            if( ptFound == false ) {
                if( lastPointInVol[rayCount] ) {
                    rayLength[rayCount] = innerSphereSize  ;
                } else {
                    rayLength[rayCount] = lastPointInVolLength[rayCount] ;
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: rayCount = %i, rayLength = %i,\n",
    //        rayCount, rayLength[rayCount] ) ;
#endif
                }
            }
            
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: rayLength[ %i ][ %i ] = %f\n",
    //    phiCount, thetaCount, rayLength[rayCount] ) ;
#endif

        }}
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: set up filter for ray lengths\n" ) ;
#endif

        // Filter the ray lengths
        int filterSize = 7 ;
//         float filter[7][7] = { // task - replace with equation when time permits
//                                 {0.0019, 0.0110, 0.0310, 0.0439, 0.0310, 0.0110, 0.0019},
//                                 {0.0110, 0.0622, 0.1762, 0.2494, 0.1762, 0.0622, 0.0110},
//                                 {0.0310, 0.1762, 0.4994, 0.7066, 0.4994, 0.1762, 0.0310},
//                                 {0.0439, 0.2494, 0.7066, 1.0000, 0.7066, 0.2494, 0.0439},
//                                 {0.0310, 0.1762, 0.4994, 0.7066, 0.4994, 0.1762, 0.0310},
//                                 {0.0110, 0.0622, 0.1762, 0.2494, 0.1762, 0.0622, 0.0110},
//                                 {0.0019, 0.0110, 0.0310, 0.0439, 0.0310, 0.0110, 0.0019},
//                               } ;
//         float filterSum = 8.9992 ;

//         float filter[7][7] = { // task - replace with equation when time permits
//                                 {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
//                                 {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
//                                 {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
//                                 {0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0},
//                                 {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
//                                 {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
//                                 {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
//                               } ;
//         float filterSum = 1.0 ;


#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: filter ray lengths\n" ) ;
#endif

        rayCount = -1 ;
        for( int phiCount = 0 ; phiCount < numAnglesPhiTheta[0] ; phiCount++ ) {
        for( int thetaCount = 0 ; thetaCount < numAnglesPhiTheta[1] ; thetaCount++ ) {
            
            rayCount++ ;
            
            float totalSum = 0 ;
            int displacedPhiCount = 0 ;
            int displacedThetaCount = 0 ;
            int filterCount = 0 ;
            float filterSum = 0 ;
            
            for( int filterDirX = 0 ; filterDirX < filterSize ; filterDirX++ ) {
            for( int filterDirY = 0 ; filterDirY < filterSize ; filterDirY++ ) {
                
#ifdef DEBUG_BRAIN_EXTRACTION            
                //printf( "DEBUG_BRAIN_EXTRACTION:  phiCount - (filterSize-1)/2-1 + filterDirX = %i \n",  
                //        phiCount - (filterSize-1)/2-1 + filterDirX ) ;
                //printf( "DEBUG_BRAIN_EXTRACTION:  thetaCount - (filterSize-1)/2-1 + filterDirY = %i \n",  
                //        thetaCount - (filterSize-1)/2-1 + filterDirY ) ;
#endif                
                if( phiCount - (filterSize-1)/2 + filterDirX < 0 ) {
                    displacedPhiCount = phiCount - (filterSize-1)/2 + filterDirX + numAnglesPhiTheta[0] ;
                    
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: ray filter loop, pt 1\n" ) ;
#endif
                }
                if( phiCount + (filterSize-1)/2 + filterDirX >= numAnglesPhiTheta[0] ) {
                    displacedPhiCount = phiCount - (filterSize-1)/2 + filterDirX - numAnglesPhiTheta[0];
                    
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: ray filter loop, pt 2\n" ) ;
#endif
                }
                if( phiCount - (filterSize-1)/2 + filterDirX >= 0 && phiCount + (filterSize-1)/2 + filterDirX < numAnglesPhiTheta[0] ) {
                    displacedPhiCount = phiCount - (filterSize-1)/2 + filterDirX  ;
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: ray filter loop, pt 3\n" ) ;
#endif
                }
                    
                if( thetaCount - (filterSize-1)/2 + filterDirY < 0 ) {
                    displacedThetaCount = thetaCount - (filterSize-1)/2 + filterDirY + numAnglesPhiTheta[1] ;
                    
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: ray filter loop, pt 4\n" ) ;
#endif
                }
                if( thetaCount + (filterSize-1)/2 + filterDirY >= numAnglesPhiTheta[1] ) {
                    displacedThetaCount = thetaCount - (filterSize-1)/2 + filterDirY - numAnglesPhiTheta[1]  ;
                    
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: ray filter loop, pt 5\n" ) ;
#endif
                }
                if( thetaCount - (filterSize-1)/2 + filterDirY >= 0 && thetaCount + (filterSize-1)/2 + filterDirY < numAnglesPhiTheta[1] ) {
                    displacedThetaCount = thetaCount - (filterSize-1)/2 + filterDirY ;
                    
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: ray filter loop, pt 6\n" ) ;
#endif
                }
                
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: displacedPhiCount = %i, displayceThetaCount = %i,\n",
    //        displacedPhiCount, displacedThetaCount ) ;
#endif
//                 if( rayLengthFound[displacedPhiCount +
//                             numAnglesPhiTheta[0]*displacedThetaCount] == true ) {
//     
//                     totalSum += ((float)rayLength[displacedPhiCount + 
//                             numAnglesPhiTheta[0]*displacedThetaCount])
//                                 * filter[filterCount] ;
// 
//                     filterSum += filter[filterCount] ;
//                 }
                if( rayLengthFound[displacedPhiCount *
                            numAnglesPhiTheta[1]+displacedThetaCount] == true ) {
    
                    totalSum += ((float)rayLength[displacedPhiCount * 
                            numAnglesPhiTheta[1]+displacedThetaCount])
                                * filter[filterCount] ;

                    filterSum += filter[filterCount] ;
                }

                filterCount++ ;
//                 if( rayLengthFound[displacedPhiCount * 
//                             numAnglesPhiTheta[1]+displacedThetaCount] ) {
//     
//                     totalSum += ((float)rayLength[displacedPhiCount * 
//                             numAnglesPhiTheta[1]+displacedThetaCount])
//                                 * filter[filterCount] ;
//                     filterCount++ ;
//                     filterSum += filter[filterCount] ;
// 
//                 }
            }}
            
            if( filterSum > 0.0 ) {
                filteredRayLength[rayCount] = totalSum / filterSum ;
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: ray is filtered\n" ) ;
#endif
            } else {
                filteredRayLength[rayCount] = rayLength[rayCount] ;
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: ray is not filtered\n" ) ;
#endif
            }
            
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: filteredRayLength[ %i ][ %i ] = %f\n",
    //    phiCount, thetaCount, filteredRayLength[phiCount][thetaCount] ) ;
#endif

        }}
        
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: creating mask from filtered rayLengths\n" ) ;
#endif

        // Create mask from Rays Lengths
        rayCount = -1 ;
        for( int phiCount = 0 ; phiCount < numAnglesPhiTheta[0] ; phiCount++ ) {
        for( int thetaCount = 0 ; thetaCount < numAnglesPhiTheta[1] ; thetaCount++ ) {

            rayCount++ ;

            for( int radiusCount = 0 ; 
                radiusCount < filteredRayLength[rayCount] ;
                //radiusCount < rayLength[rayCount] ;
                radiusCount++ ) {

                int xPos = floor( ((double)radiusCount )*rayResolution 
                             * sin( PhiDirections[phiCount] ) 
                             * cos( ThetaDirections[thetaCount] ) ) +Seed[0] ;
                int yPos = floor( ((double)radiusCount )*rayResolution 
                             * sin( PhiDirections[phiCount] ) 
                             * sin( ThetaDirections[thetaCount] ) ) +Seed[1] ;
                int zPos = floor( ((double)radiusCount )*rayResolution 
                             * cos( PhiDirections[phiCount] )  )    +Seed[2] ;

#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: new ray trace\n" ) ;
#endif
                if( xPos > 0 && xPos < Dimensions[0]
                   && yPos > 0 && yPos < Dimensions[1] 
                   && zPos > 0 && zPos < Dimensions[2] ) {

                    brain_mask[xPos+yPos*Dimensions[0]
                            +zPos*Dimensions[0]*Dimensions[1]] = true ;
                }
            }

#ifdef DEBUG_BRAIN_EXTRACTION
    //debugCounter++ ;
    //printf( "DEBUG_BRAIN_EXTRATION: ray missed\n" ) ;
#endif
        }}

        // Calculated Eroded Mask
        rayCount = - 1 ;
        for( int phiCount = 0 ; phiCount < numAnglesPhiTheta[0] ; phiCount++ ) {
        for( int thetaCount = 0 ; thetaCount < numAnglesPhiTheta[1] ; thetaCount++ ) {

            rayCount++ ;
            for( int radiusCount = 0 ; 
                radiusCount < (filteredRayLength[rayCount] - erosion_level) ;
                radiusCount++ ) {

                int xPos = floor( ((double)radiusCount)*rayResolution 
                             * sin( PhiDirections[phiCount] ) 
                             * cos( ThetaDirections[thetaCount] ) ) +Seed[0] ;
                int yPos = floor( ((double)radiusCount)*rayResolution 
                             * sin( PhiDirections[phiCount] ) 
                             * sin( ThetaDirections[thetaCount] ) ) +Seed[1] ;
                int zPos = floor( ((double)radiusCount)*rayResolution 
                             * cos( PhiDirections[phiCount] )  )    +Seed[2] ;

#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: new ray trace\n" ) ;
#endif
                if( xPos > 0 && xPos < Dimensions[0]
                   && yPos > 0 && yPos < Dimensions[1] 
                   && zPos > 0 && zPos < Dimensions[2] ) {

                    eroded_brain_mask[xPos+yPos*Dimensions[0]
                            +zPos*Dimensions[0]*Dimensions[1]] = true ;
                }
            }
                
#ifdef DEBUG_BRAIN_EXTRACTION
    //debugCounter++ ;
    //printf( "DEBUG_BRAIN_EXTRATION: ray missed\n" ) ;
#endif
        }}
              
        free( rayProfiles ) ;
        free( lastPointInVol ) ;
        free( filteredRayLength ) ;
        free( rayLength ) ;
        free( lastPointInVolLength ) ;

        //return mask ;
        
#ifdef DEBUG_BRAIN_EXTRACTION
    //printf( "DEBUG_BRAIN_EXTRATION: total number of missed arrays = %i\n", 
    //        debugCounter ) ;
    //printf( "DEBUG_BRAIN_EXTRATION: maskBrain completed\n" ) ;
#endif

    }
};


/* run the mex file opperations */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
    
#ifdef DEBUG_BRAIN_EXTRACTION
    printf( "DEBUG_BRAIN_EXTRATION: starting function\n" ) ;
#endif
    
    double * image_volume ;
    image_volume = mxGetPr ( prhs[0] ) ;
    
    double * seed ;
    seed = mxGetPr ( prhs[1] ) ;
    
    double * dimensions ;
    dimensions = mxGetPr ( prhs[2] ) ;
    
    double * num_angles ;
    num_angles = mxGetPr( prhs[3] ) ;
    
    double * inner_sphere_size ;
    inner_sphere_size = mxGetPr( prhs[4] ) ;
    
    double * gradient_threshold ;
    gradient_threshold = mxGetPr( prhs[5] ) ;
    
    double * ray_filter_kernel ;
    ray_filter_kernel = mxGetPr( prhs[6] ) ;
    double filter_sum=0 ;  
    for( int i=0; i<49; i++ ){filter_sum+=ray_filter_kernel[i];} 
    
    double * max_ray_length ;
    max_ray_length = mxGetPr( prhs[7] ) ;
    
    double * ray_resolution ;
    ray_resolution = mxGetPr( prhs[8] ) ;
    
    double * erosion_level ;
    erosion_level = mxGetPr( prhs[9] ) ;
    
#ifdef DEBUG_BRAIN_EXTRACTION
    printf( "DEBUG_BRAIN_EXTRATION: read back inputs\n"
            "\t seed = %i %i %i \n"
            "\t dimensions = %i %i %i \n"
            "\t num_angles = %i %i \n"
            "\t inner_sphere_size = %i \n"
            "\t gradient_threshold = %i \n"
            "\t max_ray_length = %i \n"
            "\t ray_resolution = %f \n"
            "\t erosion_level = %i \n",
            (int)seed[0], (int)seed[1], (int)seed[2], 
            (int)dimensions[0], (int)dimensions[1], (int)dimensions[2],
            (int)num_angles[0], (int)num_angles[1], 
            (int)inner_sphere_size[0], (int)gradient_threshold[0],
            (int)max_ray_length[0], ray_resolution[0], (int)erosion_level[0] ) ;
#endif
    
    Brain_Extractor be ;
    
    mwSize ndims = 3 ;
    const int dims[] = { dimensions[0], dimensions[1], dimensions[2] } ;   
    plhs[ 0 ] = mxCreateLogicalArray( ndims, dims ) ;
    be.seed_mask = mxGetLogicals( plhs[ 0 ] ) ;
     
    plhs[ 1 ] = mxCreateLogicalArray( ndims, dims ) ;
    be.inner_sphere_contour_mask = mxGetLogicals( plhs[ 1 ] ) ;
    
    plhs[ 2 ] = mxCreateLogicalArray( ndims, dims ) ;
    be.brain_contour_mask = mxGetLogicals( plhs[ 2 ] ) ;
      
    plhs[ 3 ] = mxCreateLogicalArray( ndims, dims ) ;
    be.brain_mask = mxGetLogicals( plhs[ 3 ] ) ;
    
    plhs[ 4 ] = mxCreateLogicalArray( ndims, dims ) ;
    be.eroded_brain_mask = mxGetLogicals( plhs[ 4 ] ) ;
    
    be.AddVolume( image_volume ) ;
    int Seed[3] ;
    Seed[0] = seed[0] ;
    Seed[1] = seed[1] ;
    Seed[2] = seed[2] ;
    int Dimensions[3] ;
    Dimensions[0] = (int) dimensions[0] ;
    Dimensions[1] = (int) dimensions[1] ;
    Dimensions[2] = (int) dimensions[2] ;
    be.SetDimensions( Dimensions ) ;
    int Num_Angles[2] ;
    Num_Angles[0] = (int) num_angles[0] ;
    Num_Angles[1] = (int) num_angles[1] ;
    be.SetNumAngles( Num_Angles ) ;
    be.SetInnerSphereSize( (int) inner_sphere_size[0] ) ;
    be.SetSeed( Seed ) ;
    be.filter = ray_filter_kernel ;
    be.SetMaxRayLength( (int) max_ray_length[0] ) ;
    be.SetRayResolution( ray_resolution[0] ) ;
    be.SetGradThreshold( gradient_threshold[0] ) ;
    be.SetErosionLevel( (int)erosion_level[0] ) ;
    
    be.seedMask() ;
    be.sphereCountour() ;
    be.countourBrain() ;
    be.maskBrain() ;
    
#ifdef DEBUG_BRAIN_EXTRACTION    
    int count1 = 0 ;
    int count2 = 0 ;
    int count3 = 0 ;
    int count4 = 0 ;
    for( int xCount = 0 ; xCount < Dimensions[0] ; xCount++ ) {
    for( int yCount = 0 ; yCount < Dimensions[1] ; yCount++ ) {
    for( int zCount = 0 ; zCount < Dimensions[2] ; zCount++ ) {
        if( be.seed_mask[xCount+yCount*Dimensions[0]
                +zCount*Dimensions[0]*Dimensions[1]] == true )
            count1++ ;
        if( be.inner_sphere_contour_mask[xCount+yCount*Dimensions[0]
                +zCount*Dimensions[0]*Dimensions[1]] == true )
            count2++ ;
        if( be.brain_contour_mask[xCount+yCount*Dimensions[0]
                +zCount*Dimensions[0]*Dimensions[1]] == true )
            count3++ ;
        if( be.brain_mask[xCount+yCount*Dimensions[0]
                +zCount*Dimensions[0]*Dimensions[1]] == true )
            count4++ ;
        //mask[xCount+yCount*Dimensions[0]
        //        +zCount*Dimensions[0]*Dimensions[1]] = true ;
    }}}
    printf( "DEBUG_BRAIN_EXTRATION: number of mask values selected = %i, %i, %i, %i,\n", 
            count1, count2, count3, count4 ) ; 
    printf( "DEBUG_BRAIN_EXTRATION: finishing function\n" ) ; 
#endif    
    
    //return;
}
