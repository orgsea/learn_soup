using Soup;
using Soup.Form;

namespace Greens
{
    /**
     * Simplist way to check for login this is to connect to the website, download html, 
     * and check to see if a css class has been set in the body tag.
     * 
     */
    bool is_authenticated()
    {
        var session = new Soup.SessionSync ();
        var message = new Soup.Message("GET", "https://my.greens.org.nz");
        var cookie_jar = new Soup.CookieJarText(COOKIE_JAR_FILENAME, true);
        cookie_jar.attach(session);
 
        session.send_message (message);
    
        int64 size = message.response_body.length;
    
        string html_str = (string)message.response_body.data;
        //stdout.printf(html_str);
        return !html_str.contains("not-logged-in");
    }


    bool login(string username, string password)
    {
        var session = new Soup.SessionSync ();
        var message = Soup.Form.request_new( "POST", 
                                             GREENS_LOGIN_URI,
                                             "destination", GREENS_DESTINATION_NODE,
                                             "name", username, 
                                             "pass", password,
                                             "remember_me", "1",
                                             "form_id", "user_login",
                                             //"op", "Log in",
                                             null);
                                         
        var cookie_jar = new Soup.CookieJarText(COOKIE_JAR_FILENAME, false);  
        cookie_jar.attach(session);
    
    
        session.send_message (message);
    
        int64 size = message.response_body.length;
    
        string html_str = (string)message.response_body.data;
        //stdout.printf(html_str);
        return !html_str.contains("not-logged-in");
    }
}
