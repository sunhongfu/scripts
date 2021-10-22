classdef PathManager
    %PathManager Summary of this class goes here
    %
    %   Detailed explanation goes here
    
    properties (SetAccess = public)
        
        source_code_pathway ;
        root_data_pathway = '~/working_files/imageData/source_data/' ;
        output_data_pathway = '~/working_files/imageData/output_data/' ;
        subject_directories ;
        
        dicomBatchFilePaths = '/Users/ethan/working_files/mrProcessor/matlab/@SPMwrapper/SPM_batch_files/' ; 
        atlasFilePaths = '/Users/ethan/working_files/mrProcessor/matlab/@BrainSegmentation/Atlases/' ;
        
        pathToFile ;
        
        stack_subdir = '/' ; 
        B1_mapping_subdir = '/B1Mapping' ;
        FGRE_1_subdir = '/FGRE_1' ;
        FGRE_2_subdir = '/FGRE_2' ;
        Fiesta_1_suddir = '/Fiesta_1' ;
        Fiesta_2_suddir = '/Fiesta_2' ;
        ME_SPGR_subdir = '/SPGR_ME_QSM' ;
        SPGR_1_subdir = '/SPGR_1' ;
        SPGR_2_subdir = '/SPGR_2' ;
        Phase_Contrast_3D_subdir = '/Phase_Contrast' ;
        Phase_Contrast_3D_hr_subdir = '/Phase_Contrast_HR' ;
        Phase_Contrast_4D_subdir = '/Phase_Contrast_CINE' ;
        DSC_Perfusion = '/DSC_Perfusion' ;
        DCE_Perfusion = '/DCE_Perfusion' ;
        DESPOT1_subdir = '/DESPOT1' ; 
        DESPOT2_subdir = '/DESPOT2' ; 
        qMT_subdir = '/qMT' ; 
        
        ASL_RAW_subdir = '/ASL_RAW' ;
        ASL_M0_subdir = '/ASL_M0' ;
        ASL_CBF_subdir = '/ASL_CBF' ;
        DTI_subdir = '/DTI' ;
        FLAIR_subdir = '/FLAIR' ;
        TOF_subdir = '/TOF' ;
        MTR_subdir = '/MTR';
        T1anat_subdir = '/T1anat' ;
        
        QSM_BOLD_subdir = '/QSM_BOLD' ; 
        COLD_subdir = '/COLD' ; 
        
        montage_subdir = '/montage_dir' ; 
        
        Microscopy_subdir = '/stack1' ;
        
        AcknowledgeFileName
        
        SeimensRaw_subdir = '/output' ;
        
        workMachine = 'WORK' ;
        miniServer = 'MINI' ;
        laptop = 'LAPTOP' ; 
        melLinuxBox = 'MELsLinuxBox' ; 
        machine
        
    end
    
    properties (SetAccess = private)
        
    end
    
    methods (Static)
        
    end
    
    methods (Access = public)
        
        function obj = PathManager( MachineType )
           
            obj.source_code_pathway = [ cd '/' ] ;
            obj.machine = MachineType ;
            
            if( strcmp( MachineType, obj.workMachine ) )
                obj.root_data_pathway = '/home/ethan/working_files/imageData/source_data/' ;
                obj.output_data_pathway = '/home/ethan/working_files/imageData/output_data/' ;
                obj.dicomBatchFilePaths = '/home/ethan/working_files/mrProcessor/matlab/@SPMwrapper/SPM_batch_files/' ; 
                obj.atlasFilePaths = '/home/ethan/working_files/mrProcessor/matlab/@BrainSegmentation/Atlases/' ;
            elseif( strcmp( MachineType, obj.miniServer ) )
                obj.root_data_pathway = '~/Desktop/root_data/' ;
            elseif( strcmp( MachineType, obj.laptop ) ) 
                obj.root_data_pathway = '/Users/ethan/working_files/imageData/source_data/' ;
                obj.output_data_pathway = '/Users/ethan/working_files/imageData/output_data/' ;
            elseif( strcmp( MachineType, obj.melLinuxBox ) ) 
                obj.root_data_pathway = '/Users/ethan/working_files/imageData/source_data/' ;
                obj.output_data_pathway = '/Users/ethan/working_files/imageData/output_data/' ;
            else
                disp( 'Machine Type Not Recognized' ) ;
            end
            
        end
        
    end
    
    methods (Access = private)
        
    end
    
end

% Helper Functions
