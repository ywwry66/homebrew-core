class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.31.1.tgz"
  sha256 "64e10917dd3b0961427fa5920f3f617711f0ab5b2c7e2be0d696842e3233503d"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "2de34fe52fa2e7e798b03cc69fd31f5496b48cb00ecf7cc1f062bdaea832c1d5"
    sha256               arm64_sequoia: "8d379420eba9ea8dda07712be04d62de1421555cbd21a753316b81e117ef41fd"
    sha256               arm64_sonoma:  "62a6e10f572779da5d156e57e1b9c2ebe74a5c16779c90e2a4c749efb8a6e89a"
    sha256               sonoma:        "d491e79f387f7110e10df9c4a126bda16034805985a7c3397e380dc86b117cd5"
    sha256 cellar: :any, arm64_linux:   "6f92b075ab2cdb55553ab37a09192c66e06078779754604023bd25d145108fcc"
    sha256 cellar: :any, x86_64_linux:  "d8f65e620be68d65653a58039ece212a3eb9396832f706f70b5ca7d60dc3181b"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "ripgrep"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.2.tgz"
    sha256 "1b1524d914331bd01312729e31a828192d53af84e113dacb6e36afabb6c21a6d"

    livecheck do
      url :url
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove ripgrep pre-built binaries
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    rm_r(node_modules.glob("@vscode/ripgrep-*"))
    rm_r(node_modules/"@vscode/ripgrep") # keeping separate from previous rm_r to fail if missing

    # Remove Electron-only sharp fork with x86_64-only pre-built binaries
    rm_r(node_modules/"@janhapke")

    # Replace node-pty pre-built binaries
    cd node_modules/"node-pty" do
      rm_r(["prebuilds", "third_party"])
      system "npm", "run", "install"
    end

    # Replace sharp pre-built binaries
    rm_r(node_modules.glob("@img/sharp-*"))
    resource("node-gyp").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"node-gyp")
      ENV.append_path "NODE_PATH", buildpath/"node-gyp/lib/node_modules"
    end
    cd node_modules/"sharp" do
      ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")

      # help letta.js find source-built sharp
      sharp = Pathname.pwd.glob("src/build/Release/sharp-*.node").first
      (node_modules/"@img"/sharp.basename(".node")).install_symlink sharp => "sharp.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Pinned agents: (none)", output
  end
end
