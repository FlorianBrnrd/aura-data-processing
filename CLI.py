import argparse
import logging
import glob
import os

from pathlib import Path

import CORE as funcs
import pandas as pd


def parse_args():
    
    """ Parse arguments from command line """

    parser = argparse.ArgumentParser(description='Process the .xls files output by the AURA macro', add_help=True)

    main_group = parser.add_argument_group('Main options')

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




########################
#   PROCESSING FILES   #
########################

def cli_filename_handler(input_folder):
    """
    Input: path to folder containing .csv files and .txt files 
    Output:  dictionnary {filename : filedata}
    """
    files_dict = {}
    channels = []


    input_folder = Path(input_folder)
    input_csv_files = [f for f in glob.glob("*.csv", root_dir=f'{input_folder}{os.sep}')]
    files_dict = {file:pd.read_csv(os.path.join(input_folder, file)) for file in input_csv_files}

    #
    settings_file = os.path.join(input_folder, 'Analysis_Settings.txt')
    with open(settings_file) as file:
        channels = funcs.get_channels_from_settings_file(file)

    return files_dict, channels














def cli_aura_data_processor(input_folder, output_folder, template_file=None):

    logging.warning('##### PROCESS STARTED')

    # TODO: fix log and remove print
    logging.warning('##### Retrieving .xls files in input folder')
    logging.info(f'input folder: {input_folder}')
    files_dict, channels = cli_filename_handler(input_folder)
    print(files_dict)
    logging.warning('- Step complete [1/4]')


    # TODO: fix log and remove print
    logging.warning('##### Parsing files names')
    files_attributes = funcs.build_files_attributes_dict(files_dict, channels_list=channels)
    print(files_attributes)
    logging.warning('- Step complete [2/4]')


    logging.warning('##### Processing and merging files')
#merge_files(files_dict, output_folder=output_folder)
    logging.warning('- Step complete [3/4]')

    logging.warning('##### Appending results and saving .xlsx files in output folder')
#add_analyse(files_dict, output_folder=output_folder)
    logging.warning('- Step complete [4/4]')

    logging.warning('##### PROCESS COMPLETED')

    return


def wrapper_cli_aura_data_processor():

    # get arguments from command line
    args = parse_args()
    
    input_folder = args.input          # Folder containing input files
    output_folder = args.output        # Folder to store output files

    # set verbosity & logging settings
    args.verbose = 40 - (10*args.verbose) if args.verbose > 0 else 0
    logging.basicConfig(level=args.verbose, format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')

    # create the output folder if not found
    output_folder_path = Path(output_folder)
    if not output_folder_path.exists():
        funcs.create_directory(output_folder_path)

    # main function processing files
    cli_aura_data_processor(input_folder=input_folder, output_folder=output_folder)

    return


if __name__ == '__main__':
    
    wrapper_cli_aura_data_processor()
