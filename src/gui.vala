using Mx;
using Greens.Website;

namespace Greens
{
  namespace Gui
  {
  
    //Because the Vala version of Mx does not have Dialog, have to make our own
    public class LoginDialog : Mx.Frame
    {
      private Mx.Entry username_entry = null;
      private Mx.Entry userpass_entry = null;
      private Form parent = null;
      
      public LoginDialog(Form parent)
      {
        this.parent = parent;
        
        Mx.Table table = new Mx.Table();
        child = table;
        table.add_actor_with_properties(new Label.with_text("Username:"), 0, 0, "y-fill", false);
        username_entry = new Mx.Entry();
        table.add_actor_with_properties(username_entry, 0, 1, "y-fill", false);
        
        table.add_actor_with_properties(new Label.with_text("Password:"), 1, 0, "y-fill", false);
        userpass_entry = new Mx.Entry();
        table.add_actor_with_properties(userpass_entry, 1, 1, "y-fill", false);
        
        var button = new Mx.Button.with_label("Login");
        button.clicked.connect(() => {
          parent.user_login(username_entry.text, userpass_entry.text);
        });
        table.add_actor_with_properties(button, 2, 1, "y-fill", false);
      }
    }
    
    
    public class Form : Mx.Frame
    {
      private RoleChangeForm websiteform;
      private Mx.ComboBox change_for_combo;
      private Mx.Entry change_for_name_entry;
      private Mx.Entry role_name_entry;
      private Mx.Entry new_person_name;
      private Mx.Entry old_person_name;
      
      
      public Form()
      {
        if(!is_authenticated()) {
          set_child(new LoginDialog(this));
        } else {
          websiteform = new RoleChangeForm();
          set_child(create_form());
        }
      }
      
      private int submitter_details_section(Table table, int pos)
      {
        var heading_label = new Label.with_text("<b><i>Form Submitter Details</i></b>");
        heading_label.clutter_text.use_markup = true;
        table.add_actor_with_properties(heading_label, pos, 0, "y-fill", false);
        var name_label = new Label.with_text("<b>Name: </b>");
        name_label.clutter_text.use_markup = true;
        table.add_actor_with_properties(name_label, pos+1, 0, "y-fill", false);
        table.add_actor_with_properties(new Label.with_text(websiteform.user_name), pos+1, 1, "y-fill", false);
        var email_label = new Label.with_text("<b>Email: </b>");
        email_label.clutter_text.use_markup = true;
        table.add_actor_with_properties(email_label, pos+2, 0, "y-fill", false);
        table.add_actor_with_properties(new Label.with_text(websiteform.user_email), pos+2, 1, "y-fill", false);
        
        return pos + 3;
      }
      
      
      private int general_info(Table table, int pos)
      {
        var heading_label = new Label.with_text("<b><i>General Information</i></b>");
        heading_label.clutter_text.use_markup = true;
        table.add_actor_with_properties(heading_label, pos, 0, "y-fill", false);
        
        var name_label = new Label.with_text("<b>This change is for:</b>");
        name_label.clutter_text.use_markup = true;
        table.add_actor_with_properties(name_label, pos+1, 0, "y-fill", false);

        change_for_combo = new Mx.ComboBox();
        change_for_combo.append_text("None");
        change_for_combo.append_text("Branch");
        change_for_combo.append_text("Province");
        change_for_combo.append_text("Network");
        change_for_combo.index = 0; //which one is selected 0 being the 1st added
        change_for_combo.notify["index"].connect (() => {
          if(change_for_combo.index == 0) {
            stdout.printf("Please select a valid option\n");
          } else {
            stdout.printf ("Selected continent: %s\n", change_for_combo.active_text);
            if(change_for_combo.active_text == "Branch") {
              change_for_name_entry.text = websiteform.user_branch;
            } else if(change_for_combo.active_text == "Province") {
              change_for_name_entry.text = websiteform.user_province;
            } else if(change_for_combo.active_text == "Network") {
              change_for_name_entry.text = "";
            }
          }
        });
        table.add_actor_with_properties(change_for_combo, pos+1, 1, "y-fill", false);
        
        var name_for_label = new Label.with_text("<b>Name of Branch/Province/Network:</b>");
        name_for_label.clutter_text.use_markup = true;
        table.add_actor_with_properties(name_for_label, pos+2, 0, "y-fill", false);
        change_for_name_entry = new Mx.Entry();
        table.add_actor_with_properties(change_for_name_entry, pos+2, 1, "y-fill", false);
        
        
        var role_name_label = new Label.with_text("<b>Name of Role:</b>");
        role_name_label.clutter_text.use_markup = true;
        table.add_actor_with_properties(role_name_label, pos+3, 0, "y-fill", false);
        role_name_entry = new Mx.Entry();
        table.add_actor_with_properties(role_name_entry, pos+3, 1, "y-fill", false);
        
        return pos + 4;
      }
      
      private Clutter.Actor create_form()
      {
        var table = new Table();
        int pos = submitter_details_section(table, 0);
        pos = general_info(table, pos);
        return table;
      }
      
      public void user_login(string username, string password)
      {
        login(username, password);
        websiteform = new RoleChangeForm();
        set_child(create_form());
      }
    }
  }
}