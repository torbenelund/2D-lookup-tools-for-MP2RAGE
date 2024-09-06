# 2D-lookup-tools-for-MP2RAGE
Matlab tools for dealing with non-bijective MP2RAGE transfer curves

These matlab functions can be used to translate values in a unified MP2RAGE image into $T_1$ and $R_1$ maps despite non-bijective behavior of the MP2RAGE to $T_1$ transfer curve. The method is an extention to the 1D lookup table (1D-LUT) described in [Ref 1]. The method which is described in [Ref 2] involves the creation of a second contrast based on the two RAGE image acquisitions in the MP2RAGE acquisition. The second contrast is referred to DSR (Difference Sum Ratio) and is simply derived as $$I_{DSR}=\frac{|I_1|-|I_2|}{2(|I_1|+|I_2|)}$$

Using Bloch simulations the expected value of $I_{DSR}$ can be derived based on $T_1$ and the sequence parameters, and my minimising the (weighted) distance to the $I_{UNI},I_{DSR}$ curve a $T_1$ value can be found for any pair of measured $I_{UNI},I_{DSR}$

As seen in the figure below it is now possible to find the correct $R_1$ value, even in situations where one UNI value corresponds to two $R_1$ values. This is done by taking into account the second contrast, DSR, which also, in some situations have two $R_1$ values corresponding to one DSR value. By calculating the shortest (possibly weighted) distance bewteen a measured pair of (UNI,DSR) values and theoretical values in 2D-LUT a $R_1$ value can be derived for each (UNI,DSR) pair and an $R_1$-map can be created.

<img width="992" alt="image" src="https://github.com/torbenelund/2D-lookup-tools-for-MP2RAGE/blob/main/figures/2D-LUT-Procedure.png">
<img width="992" alt="image" src="https://github.com/torbenelund/2D-lookup-tools-for-MP2RAGE/blob/main/figures/2D-LUT-Procedure.png">

## Installation:
Add the entire 2D-lookup-tools-for-MP2RAGE directory to your matlabpath with subdirectories, and make sure you have the required software installed.

## Usage:
Start with the examples: VisualiseB1EffectsExample.m, Simple2DLUTConversionExample.m and DisplayConvertedImagesAndExplain2DLUTExample.m in that order. Or simply run the AllExamplesWithExplanation.m example to run them all. The script ScriptUsedToCreateFiguresInThePaper.m cannot be executed on the example dataset, but illustrates how the figures in [Ref 2] were created. The functions required for the method introduced in [Ref 2] are all located in the func directory. In the SPM_and_CAT12_wrappers directory a number of wrappers to the SPM12 and CAT12 software has been included. These wrappers are used e.g. to project out local curvature from the $R_1$-surfaces.
The animated GIF illustrates the effect of performing this correction.

![CurcatureCorrectionMovie](https://github.com/torbenelund/2D-lookup-tools-for-MP2RAGE/assets/28807460/32e7a0d3-4fe7-483c-aab9-cc72974fc722)

## References:
1. Marques JP, Kober T, Krueger G, Van Der Zwaag W, Van De Moortele PF, Gruetter R. MP2RAGE, a self bias-field corrected sequence for improved segmentation and $T_1$-mapping at high field. NeuroImage. 2010 Jan;49(2):1271–81. 

2. Ruijters L, Lund TE, Vinding MS. Tolerating B1+-inhomogeneity in MP2RAGE-based $R_1$-mapping by calculating second contrast that permits previously problematic sequence parameters. Submitted to Magnetic Resonance in Medicine. Preprint avialable on bioRXiv: https://www.biorxiv.org/content/10.1101/2024.04.10.588855v1

## If you use it, please cite the paper:

Ruijters L, Lund TE, Vinding MS. Tolerating B1+-inhomogeneity in MP2RAGE-based $R_1$-mapping by calculating second contrast that permits previously problematic sequence parameters. Submitted to Magnetic Resonance in Medicine. Preprint avialable on bioRXiv: https://www.biorxiv.org/content/10.1101/2024.04.10.588855v1

## Required software:
José P. Marques' MP2RAGE related scripts: https://github.com/JosePMarques/MP2RAGE-related-scripts

SPM12: https://github.com/spm/spm12
