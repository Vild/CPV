import vibe.http.router : URLRouter;
import vibe.http.server : HTTPServerSettings, listenHTTP;
import vibe.web.rest : RestInterfaceClient;
import vibe.web.web : registerWebInterface, render;

import cpv.protocol.ping;
import vibe.core.log;

RestInterfaceClient!IPing client;
shared static this() {
	client = new RestInterfaceClient!IPing("http://127.0.0.1:6545/");

	URLRouter router = new URLRouter();
	router.registerWebInterface(new WebFrontend());

	HTTPServerSettings settings = new HTTPServerSettings();
	settings.port = 8080;
	listenHTTP(settings, router);
}

class WebFrontend {
public:
	void index() {
		string pong = client.Ping("Test data");
		render!("index.dt", pong);
	}
}
