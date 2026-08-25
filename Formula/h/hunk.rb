class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://github.com/modem-dev/hunk/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "b39d419b9927ed45b6c12f22f53bd2d8d7fa0833b47729223371f1055e4f029e"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "4e5d62c63c57fa3b7389afd26fe9c8d6592a5e1093c4d600f9f690ecf8fe8fd7"
    sha256                               arm64_sequoia: "4e5d62c63c57fa3b7389afd26fe9c8d6592a5e1093c4d600f9f690ecf8fe8fd7"
    sha256                               arm64_sonoma:  "4e5d62c63c57fa3b7389afd26fe9c8d6592a5e1093c4d600f9f690ecf8fe8fd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fce88018c5ab2e16fb2e3fa8136fdcf371eb0848bb86a41057e36d90b00cf99b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1a4b39d28f8008969e36053d9e30d7230bfd65c4637fab4e82a8d9666df0562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a59168f73f2e856720ff5075ad39e6883a69a19ebc22fd02ee1996deaede56b2"
  end

  depends_on "bun" => :build
  depends_on "node" => :build

  def install
    # --ignore-scripts skips simple-git-hooks postinstall (fails on extracted tarball, not a git repo)
    # and bun's postinstall (needed by bun build --compile), so we re-run bun's postinstall manually
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    Dir.chdir("node_modules/bun") { system "node", "install.js" }

    # Build the standalone binary (bun build --compile embeds the Bun runtime)
    system "bun", "run", "build:bin"

    # Install the compiled binary and bundled skills
    libexec.install "dist/hunk" => "hunk"
    libexec.install "skills"
    (bin/"hunk").write_env_script libexec/"hunk", HUNK_INSTALL_SOURCE: "homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hunk --version")

    help_output = shell_output("#{bin}/hunk --help")
    assert_match("hunk diff", help_output)
    assert_match("hunk skill path", help_output)

    skill_path = shell_output("#{bin}/hunk skill path").strip
    assert_match(/SKILL\.md\z/, skill_path)
    assert_path_exists skill_path, "hunk skill path did not resolve to a bundled skill file: #{skill_path}"
  end
end
