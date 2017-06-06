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
  gtk.Main;

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

        (cast(ImageMenuItem) builder.getObject("mQuit")).addOnActivate ((mi) {close;});
    }
}
