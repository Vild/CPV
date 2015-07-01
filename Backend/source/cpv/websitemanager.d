module cpv.websitemanager;

import vibe.http.router : URLRouter;
import vibe.http.server : HTTPServerSettings, HTTPListener, HTTPServerRequest, HTTPServerResponse, HTTPServerErrorInfo, listenHTTP;
import vibe.web.rest : registerRestInterface;

import cpv.website.website;

class WebsiteManager {
public:

  void Add(IWebsite website, string prefix, ushort port) {
    portController p = null;
    if (auto _ = port in ports)
      p = *_;
    else
      p = registerNewPort(port);

    p.AddWebsite(website, prefix);
  }

  void Remove(IWebsite website, string prefix, ushort port) {
    portController p = null;
    if (auto _ = port in ports)
      p = *_;
    else
      p = registerNewPort(port);

    p.AddWebsite(website, prefix);
  }


private:
  portController[ushort] ports;

  class portController {
  public:
    this(ushort port) {
      this.port = port;
      this.router = new URLRouter();
      this.router.any("/", &index);
      this.settings = new HTTPServerSettings();
      this.settings.port = port;
      this.settings.errorPageHandler = &onError;
      this.listener = listenHTTP(settings, router);
    }

    void AddWebsite(IWebsite website, string prefix) {
      URLRouter router = new URLRouter(prefix);
      website.RegisterURLs(router);
      this.router.any("*", router);
      websites[prefix] = website;
      website.Start();
    }

    void RemoveWebsite(IWebsite website, string prefix) {
      website.Stop();
      websites.remove(prefix);
      reworkRouter();
    }

    @property ref URLRouter Router() { return router; }
    @property ref HTTPServerSettings Settings() { return settings; }
    @property ref HTTPListener Listener() { return listener; }
    @property ref IWebsite[string] Websites() { return websites; }

  private:
    ushort port;
  	URLRouter router;
    HTTPServerSettings settings;
    HTTPListener listener;
    IWebsite[string] websites;

    void reworkRouter() {
      router = new URLRouter();
      router.any("/", &index);
      foreach (string prefix, IWebsite website; websites) {
        auto r = new URLRouter(prefix);
        website.RegisterURLs(r);
        router.any("*", r);
      }
      settings = new HTTPServerSettings();
      settings.port = port;
      settings.errorPageHandler = &onError;
      listener.stopListening();
      listener = listenHTTP(settings, router);
    }
  }

  portController registerNewPort(ushort port) {
    ports[port] = new portController(port);
    return ports[port];
  }

  void index(HTTPServerRequest req, HTTPServerResponse res) {
    res.writeBody("<center><h1>This is a CPV hosting server.</h1></center>", "text/html; charset=UTF-8");
  }

  void onError(HTTPServerRequest req, HTTPServerResponse res, HTTPServerErrorInfo error) {
    import std.format;
    import vibe.http.status;
    res.writeBody(format("<center><h1>%s - %s</h1>\n\n<h2>%s</h2>\n\n<p>Internal error information:\n%s</p></center>", error.code, httpStatusText(error.code), error.message, error.debugMessage), "text/html; charset=UTF-8");
	}
}
