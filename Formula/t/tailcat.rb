class Tailcat < Formula
  desc "Netcat-like tool over Tailscale's data plane, without its control plane"
  homepage "https://github.com/tailscale/tailcat"
  url "https://github.com/tailscale/tailcat/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f3e87753aa45f8be249a2708a4220748fd8613f9ea0d0435a48ffedf8d724247"
  license "BSD-3-Clause"
  head "https://github.com/tailscale/tailcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "386b6b41303e70f6f0cc6d435b4b91ac1ad7a5cef9ff315b3c31b269d6a86fa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cda9e2a3ad892217702ae774b9534af447e4f02d68681541c67c57186a1a272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68ffc0a6963ba301e252e36a98c3cab0ef063b28b0d5f770a3acc10781e6bdd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3d0c14524beb67b05b607cc489b3b030d205e4a00b8072b082af323a45cd2f7"
    sha256 cellar: :any,                 x86_64_linux:  "5de470295fd11bc9b491ab0cfc3f621b9282474466d69f1ea8f133cabcefc699"
  end

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
