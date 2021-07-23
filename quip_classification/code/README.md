# Quip Classification

Code modified from [GitHub](https://github.com/SBU-BMI/quip_classification).

Every WSI is stored in svs files in the `data` folder. 

The tile extraction code extracts tiles from WSI. Instead of writing one png for every tile, the ADIOS version writes one variable for every tile. 

All the data is written into one file data.0 

**Example WSI file size and tile file sizes**

SVS filesize: [53M, 40M, 69M, 55M, 51M, 69M, 54M, 25M, 47M, 67M, 40M, 33M]

Number of tiles: [130, 100, 240, 190, 192, 480, 121, 49, 130, 144, 121, 56]

Size of tile images (2.1GB total): [132M, 149M, 250M, 299M, 60M, 260M, 89M, 81M, 131M, 357M, 202M, 143M] 

Size of tile BP file (5.1GB total): [256M, 506M, 342M, 308M, 1.3G, 137M, 371M, 364M, 130M, 634M, 509M, 306M]

ADIOS needs to store the data in numpy arrays and store metadata which increases the size of the tile files.

On the classification side, the ADIOS version reads the bp file to create batches for the ML algorithm.
