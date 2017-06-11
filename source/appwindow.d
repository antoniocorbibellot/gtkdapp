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

    createActionsFor (application);
    //connectMenuActions (builder);
    //(cast(ImageMenuItem) builder.getObject("mQuit")).addOnActivate ((mi) {close;});
  }

  private void createActionsFor (gtk.Application.Application application) {
    foreach (a; ["quit", "about"]) {
       SimpleAction sa = new SimpleAction(a, null);
       sa.addOnActivate( (V, sa) { std.stdio.writefln ("in app's-%s-action.", sa.getName); onMenuSelection (sa); });
       application.addAction (sa);
    }
  }
  
  private void onMenuSelection (SimpleAction sa)
  {
    AppWindow aw = this;
    
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
            setTransientFor (aw);
		}
	}

    void onDialogResponse(int response, Dialog dlg) {
		if (response == GtkResponseType.CANCEL)
			dlg.destroy();
	}
    
    string action = sa.getName;

    std.stdio.writefln ("in CB, Action: [%s]", action);
    
    switch (action)
      {
      case "about":
        GtkDAbout dlg = new GtkDAbout();
        dlg.addOnResponse(&onDialogResponse);
        dlg.showAll();
        break;
      case "quit":
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
}
