class Sl < Formula
  desc "Prints a steam locomotive if you type sl instead of ls"
  homepage "https://github.com/mtoyoda/sl"
  url "https://github.com/mtoyoda/sl/archive/refs/tags/5.02.tar.gz"
  sha256 "1e5996757f879c81f202a18ad8e982195cf51c41727d3fea4af01fdcbbb5563a"
  license "MIT"
  head "https://github.com/mtoyoda/sl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "154511be7a41ffedfc392b2be2134fc6e5a0a7de8a34c27cc00b41dce1f6cd38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c867d7c636940322cd83ce8edc47d04be3b67293194fecc6ffafcba71a464bc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6689964bcfe1c68de131e77999ea19ceadcb28e304d453f6136db063a9ece0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d4212674cc9cc1628689d014efd992a03ab913f44b0a0411c6eb65f8e25bf95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8ab2f34483a0a595350f949b1a0a4386b3836ce624245365c7bce6664bb283a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7370b30c455573e2e8183282ee3c65c98fc1d211cec020bec193484144344788"
    sha256 cellar: :any_skip_relocation, ventura:        "8b15e6fced6896f40152c7fa8950be193da18999f32cd487293bd0db339b5088"
    sha256 cellar: :any_skip_relocation, monterey:       "128d4b542acd951da4edebc83f18d51c2ee3a9ef941e3e369648b977ee2d0771"
    sha256 cellar: :any_skip_relocation, big_sur:        "0300afadf35bb67efe622add3f7a928bf123dd855e37376e278052b4787e65d4"
    sha256 cellar: :any_skip_relocation, catalina:       "31b8e67d984635b74aec3a5b47b6145789ed9c09d065751cac862eec1386502d"
    sha256 cellar: :any_skip_relocation, mojave:         "e489648bcc7eff8f065855dcc891eb55f3793a5ff464d96726e313a1bc74d00f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "627b0b5f8027f876466d03038da7dd0d75804cccc3bbcf45f0fe9c91199be3c3"
    sha256 cellar: :any_skip_relocation, sierra:         "afd30cb3a99d238a8ac52810834244d5f47fc2ff597db9ad61012bd2014395b9"
    sha256 cellar: :any_skip_relocation, el_capitan:     "f186cb86f4d48929aa671434dbd6be0a861069608098a30dc952697bcca85972"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "036507954ad40e929a63e30e6feb092a7bf142a6d08c15bdb9d43ac34feeb0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2afd20ebfe0276c9b39a77ef22611e8815eb936c3c21abb31cfd8f097f161476"
  end

  uses_from_macos "ncurses"

  conflicts_with "sapling", because: "both install `sl` binaries"

  def install
    system "make", "-e"
    bin.install "sl"
    man1.install "sl.1"
  end

  test do
    system bin/"sl", "-c"
  end
end
