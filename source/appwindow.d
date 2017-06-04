module appwindow;

import std.experimental.logger;

import gtk.ApplicationWindow,
  gtk.Builder,
  gtk.HeaderBar,
  gtk.Label,
  gtk.ScrolledWindow;

class AppWindow: gtk.ApplicationWindow.ApplicationWindow
{

public:

    this(gtk.Application.Application application)
    {
        super(application);

        Builder builder = new Builder();
        if(!builder.addFromResource("/org/example/gtkdapp/ui/MainWindow.ui"))
        {
            critical("Window resource cannot be found");
            return;
        }
        HeaderBar headerBar = cast(HeaderBar) builder.getObject("headerBar");
        ScrolledWindow windowContent = cast(ScrolledWindow) builder.getObject("windowContent");
        this.setTitlebar(headerBar);
        this.add(windowContent);
    }
}
