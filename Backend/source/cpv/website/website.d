module cpv.website.website;

import vibe.http.router : URLRouter;

interface IWebsite {
  void Start();
  void Stop();

  void RegisterURLs(URLRouter router);
}
