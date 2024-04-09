%% Get the UNI, DSR and R1 image and show them using spm_check_registration
disp([datestr(now) ' - Get the UNI, DSR and R1 image and show them using spm_check_registration'])

P = char({MP2RAGE.filenameScaledUNI MP2RAGE.filenameDSR MP2RAGE.filenamecalcR1_1DLUT MP2RAGE.filenamecalcR1_2DLUT});
spm_check_registration(P)
spm_orthviews('Interp',0)
set_windowlevels([1 2],[-.5 .5])
set_windowlevels([3 4],[0.5 1.5])

XYZVentricle = [-8  9   25];
XYZCaudate = [-8  9   15];
spm_orthviews('Reposition',XYZVentricle)
spm_orthviews('BB',[-50 -50 -50; 50 50 50])

global st
for i = 1:size(P,1)
    st.vols{i}.display = 'Filenames';
end
spm_orthviews('redraw')

pause(2)

global st
for i = 1:size(P,1)
    st.vols{i}.display = 'Intensities';
end
spm_orthviews('redraw')

spmfig = gcf;
spmfig.Position(1) =1;
disp([datestr(now) ' - Done'])

%% Visualise the 2D lookup procedure for a noisy CSF voxel (purple) and a voxel in the caudate nucleus (orange)
disp([datestr(now) ' - Visualise the 2D lookup procedure for a noisy CSF voxel (purple) and a voxel in the caudate nucleus (orange)'])

spm_orthviews('Reposition',XYZCaudate)
plot_2DLUT_procedure([MP2RAGE.UNIvector MP2RAGE.DSRvector],'image',MP2RAGE.T1vector,'euclidean',scalevec);

f=gcf;
f.Position(1) =spmfig.Position(3)+1;

pause(5)


spm_orthviews('Reposition',XYZVentricle)
plot_2DLUT_procedure([MP2RAGE.UNIvector MP2RAGE.DSRvector],'image',MP2RAGE.T1vector,'euclidean',scalevec,f,2);
figure(f)
legend({'' '' '' '' 'Caudate' '' '' '' '' 'Ventricle'})
disp([datestr(now) ' - Done'])