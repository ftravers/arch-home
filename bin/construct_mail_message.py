#!/usr/bin/python
#
# Samples:
#
# Just send an html email (no binary attachment)
#
#     construct_mail_message.py -t $to -f $from -s "$subject" -m $html -o $out
#
# Send html email AND binary attachment
#
#     construct_mail_message.py -t $to -f $from -s "$subject" -m $html -e $encoded -o $out
#
# The encoded param above should be base64 encoded like so:
#
#     base64 "image.jpg" > $encoded

from optparse import OptionParser
import os, sys 

parser = OptionParser()

parser.add_option ("-t", "--to", action="store", type="string", dest="to", help="to email address")
parser.add_option ("-f", "--from", action="store", type="string", dest="fr", help="from email address")
parser.add_option ("-s", "--subject", action="store", type="string", dest="subject", help="email subject")
parser.add_option ("-m", "--html", action="store",  type="string", dest="html_file", help="html message body")
parser.add_option ("-e", "--encoded", action="store",  type="string", dest="encoded_file", help="base 64 encoded binary file to attach")
parser.add_option ("-o", "--outfile", action="store",  type="string", dest="out_file", help="file to store constructed mail message in")

(ops, args) = parser.parse_args()

boundary = os.popen('uuidgen').read().strip()
start_boundary = "--" + boundary + "\n"

def buildMessage(ops,boundary):
    msg =  mailHeader(ops)
    msg += "Content-Type: multipart/mixed; boundary=" + boundary + "\n\n"
    msg += htmlMessage(ops, boundary) + "\n\n"
    msg += binary(ops, boundary) + "\n"
    msg += "--" + boundary + "--\n" 
    return msg
    
def mailHeader(ops):
    msg =  "To: " + ops.to + "\n"
    msg += "From: " + ops.fr + "\n"
    msg += "Subject: " + ops.subject + "\n"
    msg += "MIME-Version: 1.0\n"
    return msg

def htmlMessage(ops, boundary):
    body = open(ops.html_file).read()
    htmlMessage = "Content-type: text/html; charset=utf-8\n\n" + body
    return start_boundary + htmlMessage

def binary(ops, boundary):
    if not ops.encoded_file:
        return ""
    ct = 'Content-Type: application/octet-stream; name="' + ops.encoded_file + '"\n'
    en = 'Content-Transfer-Encoding: base64\n'
    cd = 'Content-Disposition: inline; filename="' + ops.encoded_file + '"\n\n'
    encoded = open(ops.encoded_file).read().strip()
    return start_boundary + ct + en + cd + encoded

msg = buildMessage(ops, boundary)
f = open(ops.out_file, 'w')
f.write (msg)

