module app;

import std.stdio;
import std.experimental.logger;

import gio.Application : GApplication = Application;
import gtk.Application;

import appwindow;

class GtkDApp : Application
{

public:

    this()
    {
        ApplicationFlags flags = ApplicationFlags.FLAGS_NONE;
        super("org.example.GtkDApp", flags);
        this.addOnActivate(&onAppActivate);
        this.window = null;
    }

private:

    AppWindow window;

    void onAppActivate(GApplication app)
    {
        trace("Activate App Signal");
        if (app.getIsRegistered())
          trace("App is registered");
        else
          trace("App is NOT registered");

        if (!app.getIsRemote())
        {
            this.window = new AppWindow(this);
        }

        this.window.present();
    }
}

