function CBIG_ArealMSHBM_generate_ini_params_Schaefer(seed_mesh, targ_mesh, resolution, out_dir)

% CBIG_ArealMSHBM_generate_ini_params_Schaefer(seed_mesh, targ_mesh, resolution, out_dir)
%
% This script will generate initialization parameters which are initialized by Schaefer2018 
% parcellations in a given surface space <mesh>.
%
% Input:
%   - seed_mesh:
%     The resolution of seed regions, e.g. 'fsaverage3' or 'fs_LR_900'. 
%     If the data is in fsaverage surface (e.g. fsaverage5/6), the 
%     seed_mesh should be defined by fsaverage surface in the same 
%     resolution as the data space, or lower resolution, e.g. fsaverage3/4. 
%     We also allow the data in fs_LR_32k, the only available seed_mesh is 
%     fs_LR_900, which is generated by CBIG lab.
%
%   - targ_mesh:
%     The surface space of fMRI data, e.g. 'fsaverage5' or 'fs_LR_32k'.
%     The data is allowed to be in either fsaverage space (e.g. 
%     fsaverage4/5/6, fsaverage) or fs_LR_32k. Note that fs_LR_164k is not
%     available.
%
%   - resolution: (string)
%     The resolution of the Schaefer2018 parcellation. For example, '400'.
%
%   - out_dir:
%     The clustering algoritm will be performed on the averaged profiles
%     saved in the following files:
%     For data in fsaverage space:
%     <out_dir>/profiles/avg_profile/lh_<targ_mesh>_roi<seed_mesh>_avg_profile.nii.gz
%     <out_dir>/profiles/avg_profile/rh_<targ_mesh>_roi<seed_mesh>_avg_profile.nii.gz
%     For data in fs_LR_32k space:
%     <out_dir>/profiles/avg_profile/<targ_mesh>_roi<seed_mesh>_avg_profile.nii.gz
%     
%     The initialization parameters will be saved in:
%     <out_dir>/group/group.mat
%
% Example:
%   CBIG_ArealMSHBM_generate_ini_params_Schaefer('fsaverage3', 'fsaverage6', '400', out_dir)
%
% Written by Ru(by) Kong and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

if(~isempty(strfind(targ_mesh, 'fsaverage')))
    lh_group_labels = CBIG_read_annotation(fullfile(getenv('CBIG_CODE_DIR'), 'stable_projects',...
     'brain_parcellation', 'Schaefer2018_LocalGlobal', 'Parcellations', 'Parcellations_Kong2022_17network_order',...
      'FreeSurfer5.3', targ_mesh, ['lh.Schaefer2018_' resolution 'Parcels_Kong2022_17Networks_order.annot']));
    rh_group_labels = CBIG_read_annotation(fullfile(getenv('CBIG_CODE_DIR'), 'stable_projects',...
    'brain_parcellation', 'Schaefer2018_LocalGlobal', 'Parcellations', 'Parcellations_Kong2022_17network_order',...
     'FreeSurfer5.3', targ_mesh, ['rh.Schaefer2018_' resolution 'Parcels_Kong2022_17Networks_order.annot']));
    lh_labels = lh_group_labels - 1;
    rh_labels = rh_group_labels - 1;
elseif(~isempty(strfind(targ_mesh, 'fs_LR')))
    group_labels = ft_read_cifti(fullfile(getenv('CBIG_CODE_DIR'), 'stable_projects',...
     'brain_parcellation', 'Schaefer2018_LocalGlobal', 'Parcellations', 'Parcellations_Kong2022_17network_order',...
      'fs_LR_32k', ['Schaefer2018_' resolution 'Parcels_Kong2022_17Networks_order.dscalar.nii']));
    lh_labels = group_labels.dscalar(1:32492);
    rh_labels = group_labels.dscalar(32493:end);
    rh_labels(rh_labels~=0) = rh_labels(rh_labels~=0) - max(lh_labels);
end
CBIG_ArealMSHBM_generate_ini_params(seed_mesh, targ_mesh, lh_labels, rh_labels, out_dir);
end


