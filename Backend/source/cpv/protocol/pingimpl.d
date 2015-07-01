module cpv.protocol.pingimpl;

import cpv.protocol.ping;

class Ping : IPing {
  string Ping(string data) {
    return "Pong: "~data;
  }
}
