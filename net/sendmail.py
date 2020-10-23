import smtplib, ssl, socket, time
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

sender_email = "your@qq.com"
receiver_email = "target@qq.com"
password = ""
last_ipv4 = ""
last_ipv6 = ""

def DoSendMail():
    global last_ipv4, last_ipv6
# Create the plain-text and HTML version of your message
    ipv4 = "<unknown>"
    ipv6 = "<unknown>"
    try:
        ipv6 = [[(s.connect(('2400:3200::1', 53)), s.getsockname()[0], s.close()) for s in [socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)]]][0][0][1]
    except Exception as e:
        ipv6 = f'<failed to get {str(e)}>'

    try:
        ipv4 = [[(s.connect(('223.5.5.5', 53)), s.getsockname()[0], s.close()) for s in [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]]][0][0][1]
    except Exception as e:
        ipv4 = f'<failed to get {str(e)}>'
# Check if changed
    changed = False
    if ipv4 != last_ipv4:
        changed = True
    if ipv6 != last_ipv6:
        changed = True
    if not changed:
        print('nothing to send this time')
        return

    message = MIMEMultipart("alternative")
    message["Subject"] = "my ip"
    message["From"] = sender_email
    message["To"] = receiver_email

    text = f"""\
    ipv4: {ipv4},
    ipv6: {ipv6}
    """
    html = """\
    <html>
      <body>
        <p>Hi,<br>
           How are you?<br>
           <a href="http://www.realpython.com">Real Python</a>
           has many great tutorials.
        </p>
      </body>
    </html>
    """

# Turn these into plain/html MIMEText objects
    part1 = MIMEText(text, "plain")
#part2 = MIMEText(html, "html")

# Add HTML/plain-text parts to MIMEMultipart message
# The email client will try to render the last part first
    message.attach(part1)
#message.attach(part2)

# Create secure connection with server and send email
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL("smtp.qq.com", 465, context=context) as server:
        server.login(sender_email, password)
        server.sendmail(
            sender_email, receiver_email, message.as_string()
        )
    # sleep for half an hour
    print('sent one mail')

def Main():
    while True:
        DoSendMail()
        time.sleep(60*30)

if __name__ == '__main__':
    Main()
