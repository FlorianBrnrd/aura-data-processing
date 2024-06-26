import streamlit as st


def contact_form():

    form = f"""
    <form action="https://formsubmit.co/bf9c8fb7efdaa2d6e6c39f85c65ed26c" method="POST"> 
        <input type="text" name="name" required placeholder="Your name">
        <input type="email" name="email" required placeholder="Email Address">
        <input type="hidden" name="_subject" value="AURA web-app - Contact form">
        <textarea name="message" required placeholder="Message"></textarea>
        <input type="text" name="_honey" style="display:none">
        <input type="hidden" name="_template" value="basic">
        <button type="submit" class=button>Submit</button>
    </form>
    """

    st.markdown(form, unsafe_allow_html=True)


def get_css(file_name):
    with open(file_name) as css:
        st.markdown(f'<style>{css.read()}</style>', unsafe_allow_html=True)
    return


def contact_page():

    st.write('### **If you have questions, :blue[contact us] directly:**')
    get_css('src/templates/style.css')
    contact_form()
    return
