using Soup;
using Soup.Form;
using Html;
using Xml;
using Xml.XPath;

namespace Greens
{
  namespace Website
  {
    public class RoleChangeForm
    {
      private string _name;
      private string _email;
      private string _branch;
      private string _province;

      public string user_name {
        get { return _name;}
      }


      public string user_email {
        get { return _email;}
      }

      public string user_branch {
        get { return _branch; }
      }


      public string user_province {
        get { return _province; }
      }

      private Soup.Session session;
      

      public RoleChangeForm()
      {
        
        session = new Soup.SessionSync ();
        var cookie_jar = new Soup.CookieJarText(COOKIE_JAR_FILENAME, true);
        cookie_jar.attach(session);
        
        fetch_user_info();
      }
      
      private string get_node_input_value(string xpath, Context ctx)
      {
        unowned Xml.XPath.Object obj = ctx.eval_expression(xpath);
        if(obj==null) {
          print("failed to evaluate xpath\n");
          
          return "";
        }
        Xml.Node* node = null;
        if ( obj.nodesetval != null && obj.nodesetval->item(0) != null ) {
                node = obj.nodesetval->item(0);
        } else {
                print("failed to find the expected node\n");
                
                return "";
        }
      
        Xml.Attr* attr = node->properties;
        while(attr != null) {
          if(attr->name == "value") {
            return attr->children->content.strip();
          }
          
          attr = attr->next;
        }
        
        return "";
      }
      
      private string get_node_content(string xpath, Context ctx)
      {
        unowned Xml.XPath.Object obj = ctx.eval_expression(xpath);
        if(obj==null) {
          print("failed to evaluate xpath\n");
          
          return "";
        }
        Xml.Node* node = null;
        if ( obj.nodesetval != null && obj.nodesetval->item(0) != null ) {
                node = obj.nodesetval->item(0);
        } else {
                print("failed to find the expected node\n");
                
                return "";
        }
        
        return node->content.strip();
      }
      
      
      
      
      void fetch_user_name_email_branch_and_province()
      {
        var message = new Soup.Message("GET", GREENS_USER_PROFILE_URI);
        session.send_message (message);
        
        int size = (int)message.response_body.length;
        
        char[] html_char_str = (char[])message.response_body.data;
        
        //Html.ParserOption.RECOVER | Html.ParserOption.NOWARNING are 
        //essential otherwise parse will fail since html on this page have errors in it
        var doc = Html.Doc.read_memory(html_char_str,
                                       size,
                                       "/",
                                       "utf-8",
                                       Html.ParserOption.RECOVER | 
                                       Html.ParserOption.NOWARNING );
        
        if(doc == null) {
          stdout.printf("Error parsing document");
          return;
        }
        
        
        var ctx = new Xml.XPath.Context(doc);
        if(ctx == null) {
          stdout.printf("Error creating xpath context");
        }
        
        _branch = get_node_input_value(
                      GREENS_USER_BRANCH_XPATH,
                      ctx );
                      
        _province = get_node_input_value(
                      GREENS_USER_PROVINCE_XPATH,
                      ctx );
                      
        _email = get_node_input_value(
                      GREENS_USER_EMAIL_XPATH,
                      ctx );
        _name = "%s %s".printf(get_node_input_value(
                                                GREENS_USER_FIRSTNAME_XPATH,
                                                ctx ),
                               get_node_input_value(
                                                GREENS_USER_LASTNAME_XPATH,
                                                ctx)
                              );
      }
      
      
      private void fetch_user_info()
      {
        fetch_user_name_email_branch_and_province();
      }
    }
  }
}