class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/1.2.1.tar.gz"
  sha256 "1b4cebc76127d1557cf63a1aa8493506d434321bb55e2b09e65d4f88b8c5707e"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "562be2ebdaf6315497a755bc7cc30c12d5dc35dcce96aa93a7973ae834d0fb32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "562be2ebdaf6315497a755bc7cc30c12d5dc35dcce96aa93a7973ae834d0fb32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "562be2ebdaf6315497a755bc7cc30c12d5dc35dcce96aa93a7973ae834d0fb32"
    sha256 cellar: :any_skip_relocation, sonoma:        "38366cc604649dc120268f74f3650b1b3dd26324e070e013fa5edd2daca40dfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd6eb504a3e2a059f75c96fc1475cc8e7cea3651646aa6ce106e097c33c511e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ae8a3e706530f47f0ef95ae4f28182dfc7886655c9c1111690199418fc5f321"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end
