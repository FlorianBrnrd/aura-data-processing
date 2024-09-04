import argparse
import logging
import glob
import os

from pathlib import Path
import pandas as pd

import src.core as core
import src.parsing as parsing
import src.formatting as formatting
import src.copositivity as copositivity


########################
#      USER INPUT      #
########################


def parse_args():
    """ Parse arguments from command line """

    parser = argparse.ArgumentParser(description='Process the .xls files output by the AURA macro', add_help=True)

    main_group = parser.add_argument_group('Main options')

    main_group.add_argument('-n', '--name',
                            required=True,
                            metavar='EXPERIMENT_NAME',
                            help='Experiment name')

    main_group.add_argument('-a', '--analysis',
                            required=True,
                            choices=['Count', 'Area'],
                            default='Count',
                            metavar='ANALYSIS_TYPE',
                            help='Analysis type')

    main_group.add_argument('-i', '--input',
                            required=True,
                            metavar='INPUT_FOLDER',
                            help='Path to input folder containing .xls files')

    main_group.add_argument('-o', '--output',
                            required=True,
                            metavar='OUTPUT_FOLDER',
                            help='Path to output folder')

    main_group.add_argument('-v', '--verbose',
                            action='count',
                            default=1,
                            help='Verbose output')

    args = parser.parse_args()

    return args


def cli_filename_handler(input_folder):
    """
    Input: path to folder containing .csv files and .txt files
    Output:  dictionnary {filename : filedata}
    """

    input_folder = Path(input_folder)
    input_csv_files = [f for f in glob.glob("*.csv", root_dir=f'{input_folder}{os.sep}')]
    files_dict = {file: pd.read_csv(os.path.join(input_folder, file)) for file in input_csv_files}

    settings_file = os.path.join(input_folder, 'Analysis_Settings.txt')
    with open(settings_file) as file:
        channels = core.get_channels_from_settings_file(file)

    return files_dict, channels


########################
#   MAIN FUNCTIONS     #
########################


def cli_aura_data_processor(experiment_name, input_folder, output_folder, analysis_column):
    # logging.info(f'input folder: {input_folder}')

    logging.warning('##### PROCESS STARTED')
    files_dict, channels = cli_filename_handler(input_folder)
    files_attributes = core.build_files_attributes_dict(files_dict, channels_list=channels)

    # Create output file
    writer, filename = core.create_xlsx_file(experiment_name, output_folder=output_folder)

    logging.warning('##### MERGING CHANNEL DATA')
    sheets, data, file_channels, skipped = core.merge_image_channels(files_attributes=files_attributes, channels_dict=channels,
                                                            writer=writer, file_name=filename)

    logging.warning('##### DETERMINING TEMPLATES TO USE')
    # Determine if we add co-positivity_analysis
    n_channels = max([len(i) for i in file_channels.values()])
    add_copositivity = True if 1 < n_channels < 6 else False
    logging.warning(f'##### FOUND {n_channels} CHANNELS TO USE')

    # get templates
    summary_template, sheet_template = core.get_templates(n_channels=n_channels, analysis_type=analysis_column.lower())

    logging.warning('##### PARSING')
    analysis_end = parsing.main_parsing(writer=writer, filename=filename, sheets=sheets, file_channels=file_channels,
                                        add_copositivity=add_copositivity, progress_bar=False,
                                        sheet_template=sheet_template, summary_template=summary_template,
                                        analysis_type=analysis_column)

    ### COPOSITIVITE
    if add_copositivity:
        logging.warning('##### COMPUTING CO-POSITIVITY')
        copositivity.parse_copositivity_template(writer=writer, filename=filename, sheets=sheets,
                                                 file_channels=file_channels, analysis_end=analysis_end,
                                                 progress_bar=True, template_file=sheet_template,
                                                 analysis_type=analysis_column)

        copositivity.parse_copositivity_summary(writer=writer, filename=filename, summary_template=summary_template,
                                                n_channels=n_channels, file_channels=file_channels)

    logging.warning('##### FORMATTING')
    formatting.format_file(writer=writer, filename=filename, sheets=sheets, n_channels=len(channels),
                           progress_bar=False)

    logging.warning('##### PROCESS COMPLETED')

    return


def wrapper_cli_aura_data_processor():
    # get arguments from command line
    args = parse_args()

    experiment_name = args.name      # Experiment name (default: results)
    analysis_type = args.analysis    # analysis type
    input_folder = args.input        # Folder containing input files
    output_folder = args.output      # Folder to store output files

    # set verbosity & logging settings
    args.verbose = 40 - (10 * args.verbose) if args.verbose > 0 else 0
    logging.basicConfig(level=args.verbose, format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')

    # create the output folder if not found
    output_folder_path = Path(output_folder)
    if not output_folder_path.exists():
        core.create_directory(output_folder_path)

    # main function processing files
    cli_aura_data_processor(experiment_name=experiment_name, input_folder=input_folder,
                            output_folder=output_folder, analysis_column=analysis_type)

    return


if __name__ == '__main__':
    wrapper_cli_aura_data_processor()
