class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-4.10.0.tgz"
  sha256 "fd23ebde8769f9c2b57b2a6db95262234388f0740a224d97993898f9bdc10ec1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f515f2546f52f54a7d785e90ea4fd84acf15f8c873082e4a9796263074bccc4e"
    sha256 cellar: :any,                 arm64_sequoia: "f515f2546f52f54a7d785e90ea4fd84acf15f8c873082e4a9796263074bccc4e"
    sha256 cellar: :any,                 arm64_sonoma:  "f515f2546f52f54a7d785e90ea4fd84acf15f8c873082e4a9796263074bccc4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7358e6667b88605fff07267216a8bd43a604315636e974b5c893d61e15315883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b1f2007c9dc5de82d740e2c6e6c73dea2a0a547dba15db5cb07e2d3a571dfd"
  end

  depends_on "esbuild" # replaces the bundled copy
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end

    node_modules = libexec/"lib/node_modules/neonctl/node_modules"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Remove bundled esbuild to use the `esbuild` formula from PATH; delete the
    # whole module so neonctl falls back to PATH. Symlinks first to avoid dangling.
    node_modules.glob("**/.bin/esbuild").each { |bin| rm(bin) }
    node_modules.glob("**/{esbuild,@esbuild}").select(&:directory?).each { |dir| rm_r(dir) }
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)

    # `neonctl dev` bundles the function with esbuild and serves it, exercising
    # the `esbuild` dependency. Keep the source in its own dir: `dev` watches the
    # source's directory and restarts on any change, so the log must live outside it.
    (testpath/"neon").mkpath
    (testpath/"neon/index.ts").write <<~TS
      export default async () => new Response("Hello, Homebrew!");
    TS
    port = free_port
    log = testpath/"dev.log"
    pid = spawn bin/"neonctl", "dev", "--source", testpath/"neon/index.ts", "--port", port.to_s,
                "--config-dir", testpath/"config", "--analytics", "false",
                out: log.to_s, err: log.to_s
    begin
      Timeout.timeout(60) do
        loop do
          contents = log.read if log.exist?
          break if contents&.include?("localhost:#{port}")

          refute_match "bundle failed", contents.to_s
          sleep 0.5
        end
      end
      assert_match "Hello, Homebrew!",
                   shell_output("curl --silent --retry 5 --retry-connrefused --retry-all-errors " \
                                "127.0.0.1:#{port}/")
    ensure
      begin
        Process.kill("TERM", pid)
        Process.wait(pid)
      rescue Errno::ESRCH, Errno::ECHILD
        nil
      end
    end
  end
end
