import gi

gi.require_version('Mx', '1.0')

from gi.repository import Mx

app, _ = Mx.Application.new([], "app", 0)
window = app.create_window()
window.get_clutter_stage().set_size (500, 300);
dialog = Mx.Dialog()
button = Mx.Button()
dialog.add_actor(button)
def hide(arg):
	arg.hide()
	dialog.hide()

button.connect('clicked', hide)

dialog.set_parent(window.get_clutter_stage())
dialog.show()
window.get_clutter_stage().show()

app.run()

