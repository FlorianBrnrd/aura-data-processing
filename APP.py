import io
import os
from pathlib import Path
from zipfile import ZipFile

import streamlit as st
import pandas as pd
import CORE as funcs



##############################
#    PROCESS USER INPUT      #
##############################


def app_zipfile_handler(input_file):
    """
    Input: .zip files uploaded through stream.file_uploader() -> bytes-like
    Output:  dictionnary {filename : filedata}
    """
    files_dict = {}
    channels = []

    zip_file = ZipFile(input_file)

    for file in zip_file.infolist():

        file = file.filename
        name = Path(file).name

        if file.startswith('.') or file.startswith('_') or file.endswith(os.sep):
            continue

        if name.endswith('.csv'):
            files_dict[name] = pd.read_csv(zip_file.open(file))

        if name == 'Analysis_Settings.txt':
            settings_file = zip_file.open(file)
            channels = funcs.get_channels_from_settings_file(settings_file)

    return files_dict, channels    


def app_filename_handler(input_files):
    """
    Input: .csv files + .txt file uploaded through stream.file_uploader() -> bytes-like
    Output:  dictionnary {filename : filedata}
    """
    files_dict = {}
    channels = []

    for file in input_files:

        if file.name.endswith('.csv'):
            files_dict[file.name] = pd.read_csv(file)

        if file.name == 'Analysis_Settings.txt':
            channels = funcs.get_channels_from_settings_file(file)

    return files_dict, channels



def process_file_input(exp_ID, input_format, input_data):

    # create source dir to store files being processed
    #funcs.create_directory(exp_ID)

    # Process data based on user-input
    if input_format == '.zip Folder':
        files_dict, channels = app_zipfile_handler(input_data)
    elif input_format == '.csv Files':
        files_dict, channels = app_filename_handler(input_data)
    else:
        st.error('Files could not be processed - check input and retry')
        st.stop()

    # Terminate if no files detected
    if not files_dict:
        st.error('Files could not be processed - check input and retry')
        st.stop()

    # Process files attributes 
    files_attributes = funcs.build_files_attributes_dict(files_dict, channels_list=channels)
    return files_attributes, channels



######################
#   PROCESS OUTPUT   #
######################


def output_result(exp_ID, out_path):
    
    # Add output files into a zip folder
    result_filename = f"{exp_ID}.zip"
    with ZipFile(result_filename, mode="w") as archive:
        for file_path in out_path.iterdir():
            # add files to zip folder
            archive.write(file_path, arcname=file_path.name)
            # clean files once added to zip folder
            os.remove(file_path)

    # remove directory to free space 
    os.removedirs(out_path)

    # download zipped folder containing output files
    with open(result_filename, "rb") as fp:
        download = st.download_button(label='Download', data=fp, file_name=result_filename, mime="application/zip", type="primary")

    # remove zip folder to free space
    os.remove(result_filename)
    return



def download_file(filename):
    
    with open(filename, "rb") as filedata:
        download = st.download_button(label='Download', data=filedata, file_name=filename, mime="application/vnd.openxmlformats-officedocument", type="primary")
    
    # remove file from server
    os.remove(filename)
    return



##############################
#    WEB APP USER INPUT      #
##############################



def get_input_experiment_ID():

    st.subheader('Experiment name', anchor=False)

    col1, col2 = st.columns([3,3])
    with col1:
        identifier = st.text_input('Provide an experiment name *(no whitespace)* :')

    return identifier


def get_input_configuration():
    
    st.subheader('Input format', anchor=False)
    input_format = st.radio("Choose desired input format:", [".csv Files", ".zip Folder"], horizontal=True, label_visibility="visible")

    if input_format == '.zip Folder':
        st.info('Input a single **.zip folder** containing **all** files output by the **AURA macro**.')

    elif input_format == '.csv Files':
        st.info('Input all the **.csv files** along with the **Analysis_Settings.txt** file output by the **AURA macro**')
    
    else:
        st.error('An error happened - please verify your files and try again')
    
    return input_format


def get_uploaded_files(input_format):

    """ 
    Configure file_uploader based on user-defined input format
    """

    st.subheader('Input Files', anchor=False)

    if input_format == '.zip Folder':
        uploaded_files = st.file_uploader('Choose .zip folder to process', type='zip', accept_multiple_files=False)
    elif input_format == '.csv Files':
        uploaded_files = st.file_uploader('Choose .xls files to process', type=['csv', 'txt'], accept_multiple_files=True)
    else:
        uploaded_files = None
    
    return uploaded_files




######################
#      WEB APP UI    #
######################



def app_settings():

    st.set_page_config(layout="wide", page_title='AURA Data Processing', page_icon='🔬')

    hide_streamlit_style = """
                <style>
                #MainMenu {visibility: hidden;}
                footer {visibility: hidden;}
                .css-1d391kg {padding-top: 3rem; padding-bottom: 1rem}
                .css-18e3th9 {padding-top: 3rem; padding-bottom: 1rem}
                header[data-testid="stHeader"] {background: none}
                </style>
                """

    st.markdown(hide_streamlit_style, unsafe_allow_html=True)
    return


def sidebar_howto():

    with st.sidebar:
        st.write('# **How to :blue[use] ?**')
        with st.expander('See explanations', expanded=False):
            st.write('**1. Provide an experiment name**')
            st.write('**2. Choose desired input format**')
            st.write('**3. Upload your files accordingly**')
            st.write('**4. Click on "Process files" to run the script**')
            st.write('**5. Follow script progression**')
            st.write('**6. Click on "Download" to get your results**')
        st.divider()
    return


def app_header():
    # Main header
    st.header(':blue[AURA Data Processing]', anchor=False, divider='grey')
    return



###########################
#       WEB APP MAIN      #
###########################



def aura_data_processor():

    uploaded_files = None
    
    # set app settings
    app_settings()

    # Show infos in sidebar
    sidebar_howto()

    # Main header
    st.header(':blue[AURA Data Processing]', anchor=False, divider='grey')

    # Retrieve experiment ID
    exp_ID = get_input_experiment_ID()

    # Retrieve usser input configuration
    input_format = get_input_configuration()

    # file uploader
    uploaded_files = get_uploaded_files(input_format)

 
    placeholder = st.empty()
    placeholder.button('Process files', disabled=True, key=12)

    if uploaded_files and exp_ID:
        
        process = placeholder.button('Process files', disabled=False, key=21, type="primary")

        if process:
            
            st.subheader('Progress', anchor=False)

            ## PROCESSING FILES AND FORMATTING OUTPUT FILE ##
            files_attributes, channels = process_file_input(exp_ID, input_format, input_data=uploaded_files)
            funcs.process(exp_ID, files_attributes)
            
            ## DOWNLOAD FILE ##
            st.subheader('Results', anchor=False)
            download_file(f'{exp_ID}.xlsx')
            
             
    return

        
if __name__ == '__main__':
    aura_data_processor()
