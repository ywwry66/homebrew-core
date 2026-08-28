class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.6.2.tgz"
  sha256 "0b5b9c1898398233a81054b18aaa71bdc5362d62ef06457030fa641048a5a2f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c92860c3fa969805ede059a3f26680147151a30ca725646f3346fccfb9fce188"
    sha256 cellar: :any,                 arm64_sequoia: "c92860c3fa969805ede059a3f26680147151a30ca725646f3346fccfb9fce188"
    sha256 cellar: :any,                 arm64_sonoma:  "c92860c3fa969805ede059a3f26680147151a30ca725646f3346fccfb9fce188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45b18424bc8d3423e7443e7910c3de9809687cc17baf01ef92829b587084a903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bf67b172b9e8d1973eb3f4ad22eedb67f8f791ea2507b9488ae42a2541cb2ab"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
