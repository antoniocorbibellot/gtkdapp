import std.string,
  std.path,
  std.stdio;

import gio.Resource,
  gtk.Main;

import app,
  constants;

string pkgdatadir = DATADIR;

void main (string[] args)
{
    writeln("A GtkD test");

    auto resource = Resource.load(buildPath(pkgdatadir,
                                            "org.example.GtkDApp.gresource"));
    Resource.register(resource);

    Main.init(args);
    auto app = new GtkDApp();
    app.run(args);
}
