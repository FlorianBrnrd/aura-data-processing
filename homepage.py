import streamlit as st

def show_title():
    txt = '<span style="color:#1a62c7">AURA: Automated Universal RNAscope®️ Analysis for high-throughput applications</span>'
    txt2 = ('Jean Descarpentrie <sup>1,2*</sup>, Florian Bernard <sup>3*</sup>, Wilfried Souleyreau <sup>4*</sup>, '
            'Lucie Brisson <sup>4</sup>, Thomas Mathivet <sup>4</sup>, Ioannis S. Pateras <sup>5</sup>, '
            'Océane C. B. Martin <sup>6</sup>, Teresa Frisan <sup>1,2**</sup>.')

    legend_html = f'<span style="font-size:140%;"><b>{txt}</b></span><br><span style="font-size:110%;">{txt2}</span>'
    st.markdown(legend_html, unsafe_allow_html=True)


def show_affiliations():

    st.markdown('<span style="font-size:80%;line-height: 5px"><sup>1</sup> Department of Molecular Biology, Umeå University, 90187 Umeå, Sweden.<br>'
                '<sup>2</sup> Umeå Centre for Microbial Research (UCMR), Umeå University, 90187 Umeå, Sweden.<br>'
                '<sup>3</sup> University of Bordeaux, INSERM, U1212, Nucleic Acids: Natural and Artificial Regulations Laboratory, 33000 Bordeaux, France.<br>'
                '<sup>4</sup> University of Bordeaux, INSERM, U1312 BRIC, Tumor and Vascular Biology Laboratory, 33600 Pessac, France.<br>'
                '<sup>5</sup> Molecular Carcinogenesis Group, Department of Histology and Embryology, School of Medicine, National and Kapodistrian University of Athens, 11527 Athens, Greece.<br>'
                '<sup>6</sup> University of Bordeaux, CNRS, IBGC, UMR 5095, 33000 Bordeaux, France.<br>'
                '<sup>*</sup> Equal contributions<br>'
                '<sup>**</sup> Correspondence: Teresa Frisan<br>'
                'Lead contact: Jean Descapentrie<br>'
                'Technical contact: Wilfried Souleyreau</span>',
                unsafe_allow_html=True)

    return


def show_abstract():

    st.markdown('<span style="font-size:130%;color:#1a62c7"><br><b>Abstract:</b></span>', unsafe_allow_html=True)

    abstract = ("Fluorescence-based in-situ hybridization methods such as RNAscope®1 technology enable highly sensitive "
                "and specific visualization of individual RNA molecules (identified as a fluorescent speck) "
                "within intact cells, thereby enabling precise spatial and cellular localization of RNA transcripts. "
                "However, manual analysis of images is time-consuming. Here, we present a tool to facilitate "
                "high-throughput applications. The protocol seamlessly integrates automated processes, "
                "offering a universal solution for efficient RNAscope® analysis in various biological contexts..")

    abstract_html = f'<span style="font-size:100%;">{abstract}</span>'
    st.markdown(abstract_html, unsafe_allow_html=True)


def display_informations():

    show_title()

    show_affiliations()

    show_abstract()


if __name__ == '__main__':
    display_informations()
