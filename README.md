# sirius-profinder

### Helps you to annotate untargeted MFE items of LC-MS using annotation of SIRIUS based on LC-MS/MS.

<img src= "https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white"/>

-----------

This is an early stage developmennt code that uses R programming that incorporates an algorithm for comparing annotations similarities between the molecular feature extraction of identified compounds from compound prediction in [SIRIUS](https://bio.informatik.uni-jena.de/software/sirius/) software and molecular features obtained through untargeted feature extraction processing in [Agilent MassHunter ProFinder](https://www.agilent.com/cs/library/usermanuals/public/G3835-90027_Profinder_QuickStart.pdf).

![alt text](https://github.com/CreMoProduction/sirius-profinder/blob/main/SIRIUS%202.svg)
-----------

# How to run?
1. Open in RStudio
2. Specify an input folder in the `folder_path` variable. 
3. Place listed below files in the input folder: 
`compound_identifications.tsv
canopus_compound_summary.tsv
*.cef
*.csv
`
4. Modify `rt_diff` to setup the RT range or leave it by default 0.15 min.
5. Run code
6. Find an output .csv file in the input directory

Note! It automatically downloads and installs all required R packages while running
