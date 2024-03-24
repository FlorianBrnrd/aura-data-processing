# standard libraries
import os
import glob
import logging
import io
import re
from copy import copy
from pathlib import Path

# third-party libraries
import streamlit as st
import pandas as pd
import openpyxl
from openpyxl.utils import get_column_letter
from openpyxl.worksheet.dimensions import ColumnDimension, DimensionHolder
from pydantic.v1.utils import deep_update











def create_directory(directory_path):
    out_path = Path(f'{directory_path}/')
    if not out_path.exists():
        os.makedirs(out_path, exist_ok=True)
    return














####################
# processing files #
####################


def get_channels_from_settings_file(uploaded_file):
    # TODO: add description string

    channels = []
    
    for line in uploaded_file:

        if type(line) is bytes:
            line = line.decode('utf-8')

        if line.startswith('Channel'):
            match = re.match(r'(Channel [\d]: )(.+)$', line)
            chanel = str(match.group(2))
            channels.append(chanel)

    return channels



    
    

    

# Input: a {filename : filedata} dictionnary
def build_files_attributes_dict(files_dict, channels_list):
    
    files_attributes = {}

    for filename, filedata in files_dict.items():

        # use regex to process file names
        matches = re.match(r'^(.+)_(\d)_(.+).csv$', filename)
        sample = str(matches.group(1))
        image = str(matches.group(2))
        channel = str(matches.group(3))

        # make dictionnary from values
        file_dict = {sample: {image: {channel: filedata}}}

        # update main dictionnary
        files_attributes = deep_update(files_attributes, file_dict)

    return files_attributes






