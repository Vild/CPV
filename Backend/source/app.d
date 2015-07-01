import cpv.manager;
import cpv.websitemanager;

shared static this() {
	Manager manager = new Manager(6545);
	WebsiteManager websites = new WebsiteManager();

	manager.Start();
	websites.Add(new TestWebsite(), "/test", 8181);
}

import cpv.website.website;
import vibe.http.server;
class TestWebsite : IWebsite {
  override void Start() {
	}
  override void Stop() {
	}

	void index(HTTPServerRequest req, HTTPServerResponse res) {
		res.writeBody("<center><h1>This is TestWebsite! fullURL:"~req.fullURL.toString~"</h1></center>", "text/html; charset=UTF-8");
	}

	override void RegisterURLs(URLRouter router) {
		router.any("*", &index);
	}
}
