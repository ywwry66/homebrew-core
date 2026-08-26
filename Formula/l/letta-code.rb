class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.32.tgz"
  sha256 "37dfc4d0dfb471ffdf43e7e40114854dbf126fcfa4b838584cff967984ce617a"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "6608271eb2c0269a45713bd35a13f9e28a7fd28993a49cbe270ddb78c72f7a55"
    sha256               arm64_sequoia: "e9baa5c449580410653eeb25a813a32e29b9073e3251e42c6933734ae3c4ed68"
    sha256               arm64_sonoma:  "161e277c0c54b37b06fa26a9dc7fb50d3ba08c6650515cae0f979a43c8b7d037"
    sha256               sonoma:        "5fb3726d7ae91005ed73a8f03072507cfe5d55552c06fb8afdb280ae36e40c02"
    sha256 cellar: :any, arm64_linux:   "0c17373f1b1249d6557901ee3b844202a5270acfd3f081e4f04065506130afcb"
    sha256 cellar: :any, x86_64_linux:  "61b7031a592b0cc44fc694f334b0856b70dd78831de37781c16d2c2c7974b006"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"

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
