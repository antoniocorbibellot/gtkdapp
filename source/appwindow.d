module appwindow;

import std.experimental.logger;

import gtk.ApplicationWindow;
import gtk.Builder;
import gtk.HeaderBar;
import gtk.Label;

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
        HeaderBar headerBar = cast(HeaderBar)builder.getObject("headerBar");
        Label windowContent = cast(Label)builder.getObject("windowContent");
        this.setTitlebar(headerBar);
        this.add(windowContent);
    }
}
