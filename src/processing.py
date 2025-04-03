import os
from pathlib import Path
from typing import IO, Tuple, Dict, List, Any
from zipfile import ZipFile

import streamlit as st
import pandas as pd
from pandas import DataFrame

import src.core as core
import src.parsing as parsing
import src.formatting as formatting
import src.copositivity as copositivity


##############################
#    PROCESS USER INPUT      #
##############################


def app_zipfile_handler(input_file: IO[bytes]) -> tuple[dict[str, DataFrame], dict[str, str]]:
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
            channels = core.get_channels_from_settings_file(settings_file)

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
            channels = core.get_channels_from_settings_file(file)

    return files_dict, channels


def process_file_input(input_format, input_data, error_space):

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
    progress_bar = st.empty()
    files_attributes = core.build_files_attributes_dict(files_dict, channels_list=channels, error_space=error_space,
                                                        progress_bar=progress_bar)
    return files_attributes, channels


######################
#   PROCESS OUTPUT   #
######################


def output_result(experiment_name, out_path):
    # Add output files into a zip folder
    result_filename = f"{experiment_name}.zip"
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
        st.download_button(label='Download', data=fp, file_name=result_filename, mime="application/zip", type="primary")

    # remove zip folder to free space
    os.remove(result_filename)
    return


def download_file(filename):
    st.subheader('Results', anchor=False)
    # add warning to open file with libreoffice
    st.info('*The resulting file **must be opened** using the open-source software **LibreOffice**.  \nObtain the latest version for your system at www.libreoffice.org*')

    with open(filename, "rb") as filedata:
        st.download_button(label='Download', data=filedata, file_name=filename,
                           mime="application/vnd.openxmlformats-officedocument", type="primary")

    # remove file from server
    os.remove(filename)
    return


#####################
#        MAIN       #
#####################


def process_aura_files(experiment_name: str, input_format: str, uploaded_files: st.file_uploader, analysis_column):
    ######################
    ### PROCESSING

    # Process user input
    error_space = st.empty()
    files_attributes, channels = process_file_input(input_format=input_format, input_data=uploaded_files,
                                                    error_space=error_space)

    # Create output file
    writer, filename = core.create_xlsx_file(experiment_name, output_folder='.')

    # Merge AURA tables
    sheets, data, file_channels, skipped = core.merge_image_channels(files_attributes, channels, writer, filename,
                                                            progress_bar=True, column_name=analysis_column)

    # Determine if we add co-positivity_analysis
    n_channels = max([len(i) for i in file_channels.values()])
    add_copositivity = True if 1 < n_channels <= 6 else False

    # get templates
    summary_template, sheet_template = core.get_templates(n_channels=n_channels, analysis_type=analysis_column.lower())

    ######################
    ### PARSING TEMPLATES
    analysis_end = parsing.main_parsing(writer=writer, filename=filename, sheets=sheets, file_channels=file_channels,
                                        add_copositivity=add_copositivity, progress_bar=True,
                                        sheet_template=sheet_template, summary_template=summary_template,
                                        analysis_type=analysis_column)

    #####################
    ### COPOSITIVITE
    if add_copositivity:
        copositivity.parse_copositivity_template(writer=writer, filename=filename, sheets=sheets,
                                                 file_channels=file_channels, analysis_end=analysis_end,
                                                 progress_bar=True, template_file=sheet_template,
                                                 analysis_type=analysis_column)

        copositivity.parse_copositivity_summary(writer=writer, filename=filename, summary_template=summary_template,
                                                n_channels=n_channels, file_channels=file_channels)

    #####################
    ### FORMATTING
    formatting.format_file(writer=writer, filename=filename, sheets=sheets, n_channels=len(channels),
                           progress_bar=True)

    if skipped:
        with st.expander('**Warning: potentially missing channels for the following files**', expanded=True):

            st.write("*:red[The following samples appear to be missing one or more channels according to the "
                     "input settings file.]*  \n*:red[Make sure files names were not altered and that every files "
                     "output by the AURA macro were used as input.]*  \n*:red[Review the resulting file and reprocess "
                     "data if necessary. If you think you have encountered a bug, please contact us.]*")

            for file in skipped:
                st.markdown("- " + file)



    #####################
    ## DOWNLOAD RESULTS
    download_file(f'{experiment_name}.xlsx')
    return


def process_generic_files(experiment_name, input_format, uploaded_files):
    return
