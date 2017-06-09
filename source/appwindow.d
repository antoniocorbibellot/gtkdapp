module appwindow;

import std.experimental.logger,
  std.path;

import gtk.ApplicationWindow,
  gtk.Builder,
  gtk.HeaderBar,
  gtk.Label,
  gtk.ScrolledWindow,
  gtk.Box,
  gtk.ImageMenuItem,
  gtk.MenuItem,
  gtk.Main,
  gtk.MessageDialog,
  gtk.AboutDialog,
  gtk.Dialog;

/////////////
// Actions //
/////////////
import gio.Menu;
import gio.SimpleAction;
import glib.Variant;
import glib.VariantType;
////////////////////////////////////

import constants;

string pkgdatadir = DATADIR;

class AppWindow: gtk.ApplicationWindow.ApplicationWindow
{

public:

  this(gtk.Application.Application application)
  {
    super(application);
    theApp = application;

    Builder builder = new Builder();
    if(!builder.addFromFile(buildPath(pkgdatadir,"ui/MainWindow.ui")))
      {
        critical("Window ui-file cannot be found");
        return;
      }
    HeaderBar headerBar = cast(HeaderBar) builder.getObject("headerBar");
    Box windowContent = cast(Box) builder.getObject("windowContent");
    this.setTitlebar(headerBar);
    this.add(windowContent);

    createActions (application);
    connectMenuActions (builder);
    //(cast(ImageMenuItem) builder.getObject("mQuit")).addOnActivate ((mi) {close;});
  }

  private void createActions (gtk.Application.Application application) {
    SimpleAction saNormal = new SimpleAction("quit", null);
    saNormal.addOnActivate(delegate(Variant, SimpleAction) { std.stdio.writefln ("in action-quit."); close; });
    application.addAction (saNormal);
  }
  
  private void connectMenuActions (Builder b) {
    ImageMenuItem imi;

    // Quit
    imi = cast(ImageMenuItem) b.getObject("mQuit");
    //imi.setActionName("app.quit");

    //std.stdio.writefln ("in Connect, Action: [%s]" , imi.getActionName);

    //imi.setSensitive (true);
    //imi.addOnActivate(&onMenuActivate);
  }

  private void onMenuActivate(MenuItem menuItem)
  {
    class GtkDAbout : AboutDialog {
		this() {
			string[] names;
			names ~= "Antonio Corbi (binding/wrapping/proxying/decorating for D)";
			names ~= "www.gtk.org (base C library)";

			setAuthors( names );
			setDocumenters( names );
			setArtists( names );
			setLicense("License is LGPL");
			setWebsite("http://www.dlsi.ua.es");
		}
	}

    void onDialogResponse(int response, Dialog dlg) {
		if (response == GtkResponseType.CANCEL)
			dlg.destroy();
	}
    
    string action = menuItem.getActionName();

    std.stdio.writefln ("in CB, Action: [%s]", action);
    
    switch (action)
      {
      case "help.about":
        GtkDAbout dlg = new GtkDAbout();
        dlg.addOnResponse(&onDialogResponse);
        dlg.showAll();
        break;
      case "app.quit":
        close;
        break;
      default:
        MessageDialog d = new MessageDialog(
                                            this,
                                            GtkDialogFlags.MODAL,
                                            MessageType.INFO,
                                            ButtonsType.OK,
                                            "You pressed menu item "~action);
        d.run();
        d.destroy();
        break;
      }

  }
private:
  gtk.Application.Application theApp;
}
