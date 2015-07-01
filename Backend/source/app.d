import vibe.http.router : URLRouter;
import vibe.http.server : HTTPServerSettings, listenHTTP;
import vibe.web.rest : registerRestInterface;

import cpv.protocol.pingimpl;

shared static this() {
	URLRouter router = new URLRouter();
	router.registerRestInterface(new Ping());

	HTTPServerSettings settings = new HTTPServerSettings();
	settings.port = 6545;
	listenHTTP(settings, router);
}
