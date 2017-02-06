using Soup;
using Greens.Website;
using Greens.Gui;
using Greens;
using Mx;

int main(string[] args)
{
  var app = new Mx.Application(ref args, "Greens Role Change Form", 0);
  var window = app.create_window();
  window.clutter_stage.set_size (500, 300);
  
  var role_form = new Greens.Gui.Form();
  window.child = role_form;
  
  window.clutter_stage.show ();
  app.run ();
  
  return 0;
}