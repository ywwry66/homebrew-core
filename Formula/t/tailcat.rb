class Tailcat < Formula
  desc "Netcat-like tool over Tailscale's data plane, without its control plane"
  homepage "https://github.com/tailscale/tailcat"
  url "https://github.com/tailscale/tailcat/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "945dede9269f908fa409fdd204a657bd6e5db13f7c009cc5443dfbcfbbebb7b8"
  license "BSD-3-Clause"
  head "https://github.com/tailscale/tailcat.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/tailcat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tailcat --version")

    derpmap_url = "--derpmap-url=none" # ensure no external network access
    addr_file = testpath/"addr"
    server_stdout = testpath/"server_stdout"
    server_log = testpath/"server_log"
    payload = "hello from homebrew"

    server_pid = fork do
      ENV["TS_DEBUG_TAILCAT_LOCAL_DERP"] = "1"
      ENV["TAILCAT_ADDR_FILE"] = addr_file.to_s
      exec bin/"tailcat", "--key=new", derpmap_url,
           out: server_stdout.to_s, err: server_log.to_s
    end

    blob = nil
    60.times do
      blob = addr_file.read.chomp if addr_file.exist?
      break unless blob.to_s.empty?

      sleep 0.5
    end
    refute_empty blob.to_s, "timed out waiting for the server address"

    pipe_output("#{bin}/tailcat --key=new #{derpmap_url} #{blob}", payload, 0)

    Process.wait(server_pid)
    assert_predicate $CHILD_STATUS, :success?, "server exited #{$CHILD_STATUS}: #{server_log.read}"
    assert_equal payload, server_stdout.read
  end
end
