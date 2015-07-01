module cpv.manager;

import vibe.http.router : URLRouter;
import vibe.http.server : HTTPServerSettings, HTTPListener, listenHTTP;
import vibe.web.rest : registerRestInterface;

import cpv.protocol.pingimpl;

class Manager {
public:
  this(ushort port) {
    this.router = new URLRouter();
    this.settings = new HTTPServerSettings();
    this.settings.port = port;
    register();
  }

  void Start() {
  	listener = listenHTTP(settings, router);
  }

  void Stop() {
    listener.stopListening();
  }

private:
	URLRouter router;
  HTTPServerSettings settings;
  HTTPListener listener;

  void register() {
    router.registerRestInterface(new Ping());
  }
}
