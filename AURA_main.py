import streamlit as st
from streamlit_option_menu import option_menu
from aura_data_processing import aura_data_processor
from homepage import display_informations

def navigation_bar():

    styles_settings = {'icon': {"color": "#223170"},
                       'nav-link': {"--hover-color": "#edf0fa"},
                       'nav-link-selected': {'background-color': '#edf0fa', "color": '#1a62c7'}}

    with st.sidebar:

        st.markdown('<div style="font-size: 24px; color:#1a62c7"><b>Navigation:<b></div>', unsafe_allow_html=True)

        page = option_menu('', menu_icon='',
                           options=['Homepage', 'AURA data processing'],
                           icons=['house-fill', 'caret-right-fill'],
                           styles=styles_settings)
    return page


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


def main():

    # general settings
    app_settings()

    # choose page to show
    page = navigation_bar()
    st.sidebar.divider()

    # display selected page
    if page == 'Homepage':
        display_informations()

    elif page == 'AURA data processing':
        aura_data_processor()

    return


if __name__ == '__main__':
    main()
