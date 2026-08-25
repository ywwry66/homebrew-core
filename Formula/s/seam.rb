class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.34.0.tgz"
  sha256 "4798d9685cd95377095c88fd4c21b7e2022d96dfe385cd87949f4967463f2c98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "238eece39902ba27391fa4fd1029f05c9c96262f38f7265653d654e90ca75bff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e013ae041ec824a9e34b8393ea4d3a56d6157284002cdba8548c78c4c1214b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dca82ba7d710555401aae6c87825fcfb94deaccfe98dc57cc874d253ddb5a98"
    sha256 cellar: :any_skip_relocation, sonoma:        "716575408ef968c2dfa0b49a1229fee6cb52156132e8a2ad412f4bc89fccb753"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5265f3c0dbf4ba29406479bc6686f766ecb1b32cbeb6c96c87c4d49d936a3de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d0a570462b8d6928bd4857c666705747fa20b75a0dbe321b6c7c732af400f80"
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
