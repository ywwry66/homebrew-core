class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.15.1.tar.gz"
  sha256 "d4b63edad52e9c17cae5cdde1ca68a7d6c9b6786f901b3c7fa40e7f8a6d0de5a"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0627f33fff8eb931e1bde36ad6fdf9a09840f985c5b4905d574f85ce7a2f32d8"
  end

  uses_from_macos "zsh"

  allow_network_access! :test

  def install
    prefix.install Dir["*"]
    man1.install_symlink prefix/"doc/zinit.1"
  end

  def caveats
    <<~EOS
      To activate zinit, add the following to your ~/.zshrc:
        source #{opt_prefix}/zinit.zsh
    EOS
  end

  test do
    system "zsh", "-c", "source #{opt_prefix}/zinit.zsh && zinit load zsh-users/zsh-autosuggestions"
  end
end
