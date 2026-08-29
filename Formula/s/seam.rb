class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.36.0.tgz"
  sha256 "698d8406b45229a4c6a75e5bcc804a5037cca92157bb44fdf6ab1e6f0e71303e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a746b6c7c6be92182344f46b14a53fe342255ef46d607c962b12ccb1549bedd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac4a9c1c7ec3f2bb08d8932facd4ce0d5944ead38eefea1536b99ad26a901d5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55a50eac96d04f21cd81a74679818266efe93b340f7a3fb99c5318c399bbcfc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c6758b4a5ea719edfae2325ed37799196df4d433f5966117222867bb917770a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5e6ffac8afd730964959b31a82fe6b44b7f2f20d52c77f68ee05c8729c0baa2"
  end

  depends_on "node"

  def install
    # Optional dependencies include `@anthropic-ai` packages
    # which uses proprietary license.
    (libexec/"seam").install buildpath.children
    cd libexec/"seam" do
      system "npm", "install", "--omit=optional", "--omit=dev", *std_npm_args(prefix: false)
      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable bin/"seam",
                                         "completion",
                                         "--loader",
                                         base_name: "seam"
  end

  test do
    output = shell_output("#{bin}/seam workspaces list 2>&1", 1)
    assert_includes output, "seam login"
    assert_match version.to_s, shell_output("#{bin}/seam --version")
    refute_path_exists libexec/"seam/node_modules/@anthropic-ai"
  end
end
