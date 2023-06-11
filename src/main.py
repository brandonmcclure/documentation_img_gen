from PIL import Image, ImageDraw, ImageFont
import gradio as gr
import os
import logging

def gen_img(computerName,userName):
    currentDir = os.path.dirname(__file__)
    logging.info(f'currentdir: {currentDir}')
    advanced_img_path = os.path.join(currentDir, "lib/Windows10_RemoteDesktopConnection_Advanced01_Blank.png")
    logging.info(f'advanced_img_path: {advanced_img_path}')
    simple_img_path = os.path.join(currentDir, "lib/Windows10_RemoteDesktopConnection_Simple_Blank.png")
    logging.info(f'simple_img_path: {simple_img_path}')
    advanced_img = Image.open(advanced_img_path)
    simple_img = Image.open(simple_img_path)
    advanced_draw = ImageDraw.Draw(advanced_img)
    simple_draw = ImageDraw.Draw(simple_img)
    # font = ImageFont.truetype(<font-file>, <font-size>)
    font = ImageFont.truetype("arial.ttf", 16)
    # draw.text((x, y),"Sample Text",(r,g,b))
    advanced_draw.text((148, 187),computerName,(0,0,0),font=font)
    advanced_draw.text((148, 218),userName,(0,0,0),font=font)
    simple_draw.text((83, 119),computerName,(0,0,0),font=font)
    simple_draw.text((83, 148),userName,(0,0,0),font=font)
    return advanced_img, simple_img

logging.basicConfig(level=logging.INFO, format='%(asctime)s || %(levelname)s || %(name)s.%(funcName)s:%(lineno)d || %(message)s')
with gr.Blocks() as grBlock:
    gr_qa = gr.State([])
    gr.Markdown(
        """
        # Documentation img gen

        This application is designed to help me build documentation for non technical users. I often need to write documentation on how to remote into a given Windows Server. I want to include the server name, but sometimes the server name changes. 

        This app allows you to generate an image of a Windows 10 Remote Desktop Connection window with your specified computer name and username so that it matches your domain/environment.
        """)
    with gr.Row():
        computerName = gr.Textbox(label="Computer name", value="myPC@example.com")
        userName = gr.Textbox(label="User name", value="example\\myUser")
    with gr.Row():
        out_simple = gr.Image(label='Show Options',shape=(200, 200))
        out_advanced = gr.Image(label='Show simple',shape=(200, 200))
    with gr.Row():
        btn = gr.Button("Generate image")
        btn.click(fn=gen_img, inputs=[computerName,userName], outputs=[out_simple,out_advanced])

grBlock.launch(server_name="0.0.0.0", share=False)   