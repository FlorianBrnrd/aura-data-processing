import streamlit as st
import src.processing as processing


##############################
#       APP INTERFACE        #
##############################


def sidebar_howto():

    with st.sidebar:
        st.write('# **How to :blue[use] ?**')
        with st.expander('See explanations', expanded=False):
            st.write('**1. Provide an experiment name**')
            st.write('**2. Select analysis column**')
            st.write('**3. Choose desired input format**')
            st.write('**4. Upload your files accordingly**')
            st.write('**5. Click on "Process files" to run the script**')
            st.write('**6. Follow script progression**')
            st.write('**7. Click on "Download" to get your results**')
    return


##############################
#         USER INPUT         #
##############################


def get_input_experiment_name():

    cols = st.columns([3, 3])
    with cols[0]:
        experiment_name = st.text_input('**Experiment :blue[name]:** *(no whitespace)*')

    return experiment_name


def get_input_configuration():

    input_format = st.radio("**Input :blue[format]:**", [".csv Files", ".zip Folder"],
                            horizontal=True, label_visibility="visible")

    if input_format == '.zip Folder':

        helper_zip = """
        Upload a **single** .zip folder containing **every** file output by the **AURA macro**:
        * Analysis_settings.txt file
        * Individual .csv files containing channel's data \n
        (Preferred method when analyzing a large number of files)
        """

        st.info(helper_zip)

    elif input_format == '.csv Files':

        helper_csv = """
        Upload **each** file output by the **AURA macro**:
        * Analysis_settings.txt file
        * Individual .csv files containing channel's data \n
        """

        st.info(helper_csv)

    else:
        st.error('An error happened - please verify your files and try again')

    return input_format


def get_analysis_column():

    analysis_col = st.radio("**Perform :blue[analysis] on:**", ["Dot count", "Area"],
                            horizontal=True, label_visibility="visible")

    if analysis_col == 'Dot count':
        return 'Count'
    elif analysis_col == 'Area':
        return 'Area'
    else:
        return None


def get_uploaded_files(input_format):
    """ Configure file_uploader based on user-defined input format """

    if input_format == '.zip Folder':
        return st.file_uploader('**Choose :blue[.zip folder] to process**', type='zip',
                                accept_multiple_files=False)

    elif input_format == '.csv Files':
        return st.file_uploader('**Choose :blue[.csv files] to process**', type=['csv', 'txt'],
                                accept_multiple_files=True)

    else:
        return None


###########################
#       WEB APP MAIN      #
###########################


def aura_data_processor():

    # Show infos in sidebar
    sidebar_howto()

    # Main header
    st.header(':blue[AURA Data Processing]', anchor=False, divider='grey')

    st.subheader('Parameters', anchor=False)

    # Retrieve experiment ID
    experiment_name = get_input_experiment_name()

    # Analysis column
    analysis_col = get_analysis_column()

    # Retrieve user input configuration
    input_format = get_input_configuration()

    # file uploader
    st.subheader('Input files', anchor=False)
    uploaded_files = get_uploaded_files(input_format)

    placeholder = st.empty()
    placeholder.button('Process files', disabled=True, key=12)

    if uploaded_files and experiment_name and analysis_col:

        process = placeholder.button('Process files', disabled=False, key=21, type="primary")

        if process:
            st.subheader('Progress', anchor=False)
            processing.process_aura_files(experiment_name, input_format, uploaded_files, analysis_col)

    return


if __name__ == '__main__':
    aura_data_processor()
