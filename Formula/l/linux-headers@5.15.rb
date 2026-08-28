class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.219.tar.gz"
  sha256 "1f80cc61909fb7f331e6518f9749b853de0a41c711006b839ac6f52c7f3b429a"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7f37fbd7b1e024b091a430b42227cc9bfce83e5327c019fc9e41697b94e2384a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "43da7d6d190fdd08b96b3edbde059265e1ca6a211dc0b91f261da44b65586f99"
  end

  keg_only :versioned_formula

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
