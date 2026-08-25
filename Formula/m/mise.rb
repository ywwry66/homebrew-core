class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.8.13.tar.gz"
  sha256 "934e5ce1aef28d9e04aef21ec4f3c1275342e76f3d66195b356f541338eed095"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f0cd9ad2952c6392d76b373f9259bc2add62e4237b3b16c095b706c270c17b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd4118bc407c852bef8ec04b2016e6e86bf40c41e7b7a294e94fc8fb776f38a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db787dfff47f7822ae5e76d75a5ed2d2d7eea950147d7c7ba213d1d457883d28"
    sha256 cellar: :any_skip_relocation, sonoma:        "a12d67be1b9d74033c2efd5773712d8a49863474493c3dcc9196aef305f0045b"
    sha256 cellar: :any,                 arm64_linux:   "399285d2868a54aea22f52c72255b617dd095002908fd8570d15293c6e13048f"
    sha256 cellar: :any,                 x86_64_linux:  "7751a2cb8dce9da4487bc8fda231e3c080970e75ab2dcbfaaa87f201335de181"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
