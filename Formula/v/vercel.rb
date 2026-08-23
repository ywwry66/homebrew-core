class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.4.0.tgz"
  sha256 "7dc107d9f932365817fe237d5f4dfb027621bd63f09f4b6752d08165367e83fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eebec74efb5bf011c7a384973b01018ec20c75a2db6aba073cda2ece5460ec60"
    sha256 cellar: :any,                 arm64_sequoia: "eebec74efb5bf011c7a384973b01018ec20c75a2db6aba073cda2ece5460ec60"
    sha256 cellar: :any,                 arm64_sonoma:  "eebec74efb5bf011c7a384973b01018ec20c75a2db6aba073cda2ece5460ec60"
    sha256 cellar: :any,                 sonoma:        "9174be93a213eddafef9b90200cabba901f0f94e7c0aae4719730d644af335b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eae6f321bc300ddbc5b2b5b3e6c4fdb77d4f50e96dd0d858e2b018ae9005448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08db84dd84aadc7eb9fad702b93c21b20a159ff07f8bcd318cfb30b6fd8e3ae8"
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
