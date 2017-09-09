import weechat as w
import pynotify

pynotify.init('My Application Name')
w.register("test_python", "FlashCode", "1.0", "GPL3", "Test script", "", "")

def my_print_cb(data, buffer, date, tags, displayed, highlight, prefix, message):
    if highlight == "1":
        name = w.buffer_get_string(buffer, "name")
        notif = pynotify.Notification(prefix + "@" + name, message)
        notif.show()
    return w.WEECHAT_RC_OK

hook = w.hook_print("", "", "", 1, "my_print_cb", "")
