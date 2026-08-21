class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.3.0.tgz"
  sha256 "47f19d656b69800cdd430bdc097d86b714f54dc372ce18f1518ebeab69815325"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33b4c9ad8bfed9566b27114a5f29abe9cdf41f6b4c44791dff7a6f2d59fa0c7c"
    sha256 cellar: :any,                 arm64_sequoia: "33b4c9ad8bfed9566b27114a5f29abe9cdf41f6b4c44791dff7a6f2d59fa0c7c"
    sha256 cellar: :any,                 arm64_sonoma:  "33b4c9ad8bfed9566b27114a5f29abe9cdf41f6b4c44791dff7a6f2d59fa0c7c"
    sha256 cellar: :any,                 sonoma:        "a3a8e2dd9171b53a0d90ad2bb1f389c6b0a6eaf16a3f9526692a0f1745bc5f22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9a191410c339c7c94d7d096d4f9383cc7ba29fc3177f90cd22317196ba83234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a294181fef49dc953f665516c4c76ccdd722019a4004b48e8eb7f1c0fc66b1d"
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
