# sirius-profinder
[![forthebadge](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNDYuODQzNzcyODg4MTgzNiIgaGVpZ2h0PSIzNSIgdmlld0JveD0iMCAwIDI0Ni44NDM3NzI4ODgxODM2IDM1Ij48cmVjdCB3aWR0aD0iOTQuNjI1MDA3NjI5Mzk0NTMiIGhlaWdodD0iMzUiIGZpbGw9IiM0YTkwZTIiLz48cmVjdCB4PSI5NC42MjUwMDc2MjkzOTQ1MyIgd2lkdGg9IjE1Mi4yMTg3NjUyNTg3ODkwNiIgaGVpZ2h0PSIzNSIgZmlsbD0iIzdlZDMyMSIvPjx0ZXh0IHg9IjQ3LjMxMjUwMzgxNDY5NzI2NiIgeT0iMjEuNSIgZm9udC1zaXplPSIxMiIgZm9udC1mYW1pbHk9IidSb2JvdG8nLCBzYW5zLXNlcmlmIiBmaWxsPSIjRkZGRkZGIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBsZXR0ZXItc3BhY2luZz0iMiI+TEMtTVMvTVM8L3RleHQ+PHRleHQgeD0iMTcwLjczNDM5MDI1ODc4OTA2IiB5PSIyMS41IiBmb250LXNpemU9IjEyIiBmb250LWZhbWlseT0iJ01vbnRzZXJyYXQnLCBzYW5zLXNlcmlmIiBmaWxsPSIjRkZGRkZGIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBmb250LXdlaWdodD0iOTAwIiBsZXR0ZXItc3BhY2luZz0iMiI+TUVUQUJPTE9NSUNTPC90ZXh0Pjwvc3ZnPg==)](https://forthebadge.com)
###Helps you to annotate untargeted MFE items of LC-MS using annotation of SIRIUS based on LC-MS/MS.
-------


This is an early stage developmennt code that uses R programming that incorporates an algorithm for comparing annotations similarities between the molecular feature extraction of identified compounds from compound prediction in [SIRIUS](https://bio.informatik.uni-jena.de/software/sirius/) software and molecular features obtained through untargeted feature extraction processing in [Agilent MassHunter ProFinder](https://www.agilent.com/cs/library/usermanuals/public/G3835-90027_Profinder_QuickStart.pdf).
<img src= "https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white"/> **powered**
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