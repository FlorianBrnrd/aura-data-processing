# AURA Data Processing

----

This repository contains the source code for the companion web-app of the following paper:

## AURA: Automated Universal RNAscope®️ Analysis for high-throughput applications.

### Authors

- Jean Descarpentrie <sup>1,2*</sup>
- [Florian Bernard <sup>3*</sup>](https://www.github.com/FlorianBrnrd)
- Wilfried Souleyreau <sup>4*</sup>
- Lucie Brisson <sup>4</sup>
- Thomas Mathivet <sup>4</sup>
- Ioannis S. Pateras <sup>5</sup>
- Océane C. B. Martin <sup>6</sup>
- [Teresa Frisan <sup>1,2**</sup>](https://www.umu.se/en/research/groups/teresa-frisan/)


<sup>1</sup> Department of Molecular Biology, Umeå University, 90187 Umeå, Sweden.\
<sup>2</sup> Umeå Centre for Microbial Research (UCMR), Umeå University, 90187 Umeå, Sweden. \
<sup>3</sup> University of Bordeaux, INSERM, U1212, Nucleic Acids: Natural and Artificial Regulations Laboratory, 33000 Bordeaux, France.\
<sup>4</sup> University of Bordeaux, INSERM, U1312 BRIC, Tumor and Vascular Biology Laboratory, 33600 Pessac, France.\
<sup>5</sup> 2nd Department of Pathology, “Attikon” University Hospital, Medical School, National and Kapodistrian University of Athens, 124 62 Athens, Greece.\
<sup>6</sup> University of Bordeaux, CNRS, IBGC, UMR 5095, 33000 Bordeaux, France.

Lead contact: Jean Descarpentrie \
Technical contact: Wilfried Souleyreau  

*Equal contributions \
**Correspondence: Teresa Frisan


&nbsp;

---------
## AURA

AURA is a universal tool for automated RNAscope analysis for high-throughput applications.

It comes as a FIJI macro (```AURA_macro_v1.1.ijm```) that you can directly download from the folder named ```AURA``` present in this repository.
This macro was developed by Jean Descarpentrie and Wilfried Souleyreau, for any questions contact them directly.

&nbsp;

---------

## Companion Web-application  [![Streamlit App](https://static.streamlit.io/badges/streamlit_badge_black_white.svg)](https://aura-data-processing.streamlit.app)

The web-app provides an out-of-the-box solution for processing the files obtained after running the AURA macro on your images, without the need to set up and run a python script on your local machine.
Once results are downloaded, files uploaded to the app and generated by the script are automatically removed.

The web-app is written in python and uses the streamlit library. It is deployed via the streamlit community cloud and accessible at: \
https://aura-data-processing.streamlit.app.

### Running the web-app locally

If desired, the web-app can be executing locally. To do so, clone/download this repository on your local machine,
install the python libraries listed in ```requirements.txt``` and run the app by executing the following command in your terminal:

```
streamlit run AURA_main.py
```

For more details on how to execute a streamlit app locally, see Streamlit documentation at: https://docs.streamlit.io/.



&ensp;

---
## CLI version of the script

Additionally, we provide a Command Line Interface (CLI) version of the web-app for processing your files locally.
In your terminal, execute the following file: ```CLI_aura_data_processor.py```.

### Pre-requisites
The script was developed in python 3.12.2\
The following python libraries needs to be installed in your local environment when running the script:

- openpyxl 3.1.3
- pandas 2.2.1
- pydantic 2.6.4
- XlsxWriter 3.2.0

### Running the script

Clone or download the **entire** repository on your local machine. Inside the repository folder, you can run the script as following:

```
python3 CLI_aura_data_processing.py [-h] -i [INPUT_FOLDER] -o [OUTPUT_FOLDER] -a [Area | Count]
```

Results will be saved in the OUTPUT_FOLDER you indicated.
Arguments to pass to the script are the following: 
```
python3 CLI_aura_data_processing.py -h

Main options:
  -i, --input       Input folder containing .xls files
  -a, --analysis    Perform analysis on 'Count' or 'Area' data column
  -o, --output      Output folder
  
optional arguments:
  -h, --help        Show this help message and exit
  -v, --verbose     Verbose output
```


&ensp;

---
## License

The source code is licensed under the MIT License.