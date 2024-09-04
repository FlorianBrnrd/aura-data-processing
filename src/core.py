import os
import re
from pathlib import Path

import streamlit as st
import pandas as pd
from pydantic.v1.utils import deep_update


def create_directory(directory_path: [Path | str]) -> None:
    """ Creates a directory if it does not exist """
    out_path = Path(f'{directory_path}/')
    if not out_path.exists():
        os.makedirs(out_path, exist_ok=True)


def create_xlsx_file(filename: str, output_folder: str = '.') -> tuple[pd.ExcelWriter, str]:
    """ Creates an .xlsx file that can be manipulated """
    file_name = os.path.join(output_folder, f"{filename}.xlsx")
    writer = pd.ExcelWriter(file_name, engine='openpyxl')
    return writer, file_name


def get_channels_from_settings_file(uploaded_file: st.file_uploader) -> dict[str, str]:
    """ Parse channels present in settings file and returns it as a list """

    channels = {}

    for line in uploaded_file:

        if type(line) is bytes:
            line = line.decode('utf-8', 'backslashreplace')

        if line.startswith('Channel'):
            match = re.match(r'Channel (\d+): (.+)$', line)
            channel_number = int(match.group(1)) if match else None
            channel = str(match.group(2)).strip() if match else None
            channels[channel] = f'Channel {channel_number} (C{channel_number})'

    return channels


def get_templates(n_channels, analysis_type):

    if 1 < n_channels < 6:
        summary_template = f'templates/{analysis_type}/template_summary_{analysis_type}_{n_channels}channels.xlsx'
        sheet_template = f'templates/{analysis_type}/template_sheet_{analysis_type}_{n_channels}channels.xlsx'
    else:
        summary_template = f'templates/{analysis_type}/template_summary_{analysis_type}.xlsx'
        sheet_template = f'templates/{analysis_type}/template_sheet_{analysis_type}.xlsx'

    return summary_template, sheet_template


def build_files_attributes_dict(files_dict: dict[str, pd.DataFrame], channels_list: dict, error_space: st.empty = None,
                                progress_bar=None) -> dict:
    """ Input: a {filename : filedata} dictionary"""

    # generate progress bar
    samples = len(files_dict)
    count = 0

    if progress_bar:
        progress_bar.progress(count, text=f"Processing input files: [{count}/{samples}]")

    # processing files
    errors = []
    files_attributes = {}
    for filename, filedata in files_dict.items():

        # use regex to process file names
        matches = re.match(r'^(.+)_(.+).csv$', filename)
        sample = str(matches.group(1)) if matches else None
        channel = str(matches.group(2)) if matches else None

        if channel not in channels_list.keys():
            errors.append((filename, channel))

        # make dictionary from values
        file_dict: dict[str, dict[str, pd.DataFrame]] = {sample: {channel: filedata}}

        # update main dictionary
        files_attributes = deep_update(files_attributes, file_dict)

        # updating progress bar
        count += 1
        if progress_bar:
            progress_bar.progress(count/samples, text=f'Processing input files: [{count}/{samples}]')

    if errors and error_space:
        error_string = [f'Found unknown channel [**{channel}**] in file: **{filename}**\n\n'
                        for (filename, channel) in errors]
        error_string = ''.join(error_string)
        settings_channels = '| '.join(channels_list)
        settings_channels = f'File **Analysis_settings.txt** specify the following channels: {settings_channels}'
        string = error_string + settings_channels
        error_space.error(string)
    else:
        # add log output for CLI
        ...

    return files_attributes


def merge_image_channels(files_attributes, channels_dict, writer, file_name, progress_bar=None, column_name='Count'):
    """ For each image sample, merge corresponding channels together """

    skipped = []

    # generate progress bar
    samples = len(files_attributes)
    i = 0
    if progress_bar:
        progress_bar: st.progress = st.progress(0, text=f"Merging image channels: [{i}/{samples}]")

    # initialize variables
    counter = 3
    sheets = []
    data = {}
    file_channels = {}
    column_name = 'Total Area' if column_name == 'Area' else column_name

    # create summary sheet in first position
    workbook = writer.book
    workbook.create_sheet('summary')
    summary_sheet = writer.sheets['summary']

    # Loop over samples
    for sample, channels_per_image in files_attributes.items():

        # store separate channel dataframes in list
        image_dfs = []
        channel_count = 0
        for channel, filedata in channels_per_image.items():
            channel_count += 1
            df_length = len(filedata)
            slices = [f'Slice_{i}' for i in range(1, df_length+1)]
            filedata['Slice'] = slices
            filedata = filedata.set_index('Slice')[[column_name]]
            filedata.columns = [channel]
            image_dfs.append(filedata)

        # concat dataframes from same sample+channel, reorder columns based on names and store in dictionary
        df = pd.concat(image_dfs, axis=1)

        # reindex columns
        c = []
        for key, value in channels_dict.items():
            if key in df.columns:
                c.append(key)
        df = df.reindex(c, axis=1)

        # updating progress bar
        if progress_bar:
            i += 1
            progress_bar.progress(i/samples, text=f'Merging image channels: [{i}/{samples}]')

        # do not write files with only one channel
        if channel_count < 2:
            skipped.append(f'{sample}_{channel}.csv')
            continue

        data[sample] = df
        file_channels[sample] = {channels_dict[col]: col for col in df.columns}
        sheets.append(sample)

        # write dataframe in a separate sheet (one per channel)
        df.to_excel(writer, sheet_name=sample, startrow=2, startcol=6, index=True, header=True, na_rep='NaN')

        # write filename to summary file and increment counter for next iteration
        summary_sheet[f"A{counter}"] = sample
        counter = counter + 1

    # save file
    workbook.save(file_name)

    return sheets, data, file_channels, skipped
