import sys, os, datetime

  
# Reading data back
def loadJSON(fileName):
  import json
  with open(fileName, 'r') as f:
       vagas = json.load(f) 
  #     vagas = json.dumps(vagasud, sort_keys=True) 
  return vagas


def loadTemplate(templateFileName, outFileName, vagas):
  # Template
  from mako.template import Template
  mytemplate = Template(filename=templateFileName)
  mytemplaterendered = mytemplate.render(vagas=vagas, now=datetime.datetime.now())
  if sys.version_info.major < 3:
    mytemplaterendered = str(mytemplaterendered.encode("utf-8").strip())
  else:
    mytemplaterendered = str(mytemplaterendered.strip())

  with open(outFileName, 'w') as f:
       f.write(mytemplaterendered)

  return mytemplaterendered

#import premailer
#p = premailer.Premailer(mytemplaterendered)
#mytemplaterendered = p.transform()     

# Send Mail
def sendMail(mail_smtp_host, mail_smtp_port, gmail_user, gmail_pwd, to, subject, text, attachs=None):
    import smtplib
    # python2
    if sys.version_info.major < 3:
      from email.MIMEMultipart import MIMEMultipart
      from email.MIMEBase import MIMEBase
      from email.MIMEText import MIMEText
      from email import Encoders
    else:
      # python3
      from email.mime.multipart import MIMEMultipart
      from email.mime.base import MIMEBase
      from email.mime.text import MIMEText
      from email import encoders

    try:
       msg = MIMEMultipart()
       msg['From'] = gmail_user
       msg['To'] = to
       msg['Subject'] = subject
       msg.attach(MIMEText(text))
       if attachs:
          for attach in attachs:
            extension = attach.split(".")[-1]
            content = open(attach, 'rb').read()
            part = MIMEText(content, extension, 'utf-8')
            part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(attach))
  #          part = MIMEBase('application', 'octet-stream')
  #          part.set_payload(open(attach, 'rb').read())
  #          Encoders.encode_base64(part)
  #          part.add_header('Content-Disposition', 'inline; filename="%s"' % os.path.basename(attach))
            msg.attach(part)
       mailServer = smtplib.SMTP(mail_smtp_host,mail_smtp_port)
       mailServer.ehlo()
       mailServer.starttls()
       mailServer.ehlo()
       mailServer.login(gmail_user, gmail_pwd)
       mailServer.sendmail(gmail_user, to, msg.as_string())
       mailServer.close()
       print ('%s - Successfully sent the mail to %s' % (datetime.datetime.now(), to))
    except Exception as e:
       print ("%s - failed to send mail %s" % (datetime.datetime.now(), str(e)) )

def parseArguments():
  import argparse
  parser = argparse.ArgumentParser(description='Send Mail')
  parser.add_argument('--smtp_host', required=True, help='SMTP Host')
  parser.add_argument('--smtp_port', required=True, help='SMTP Port')
  parser.add_argument('--from', required=True, help='From mail')
  parser.add_argument('--pass', required=True, help='Password')
  parser.add_argument('--to', required=True, help='To Mail')
  parser.add_argument('--subject', required=True, help='Subject')
  text= 'Check out the attachment with Vacancies of SENAC in %s' % datetime.datetime.now()
  parser.add_argument('--text', default=text, help='Text message')
  parser.add_argument('--json', required=True, help='Json FileName')
  return vars(parser.parse_args())

def main():
  args  = parseArguments()
  vagas = loadJSON(args['json'])
  email = loadTemplate('email-template.mako', 'email.html', vagas)
  for to in args['to'].split(","):
    sendMail(args['smtp_host'], args['smtp_port'], args['from'], args['pass'], to, args['subject'], args['text'], [args['json'],"email.html"] )

if __name__ == "__main__":
    main()