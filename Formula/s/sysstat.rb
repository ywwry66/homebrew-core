class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https://sysstat.github.io/"
  url "https://github.com/sysstat/sysstat/archive/refs/tags/v12.8.0.tar.gz"
  sha256 "8aa2054c56c941ab30e1b14ad2e0076a7e6d6bf01f50e22d954885b8a7f9a679"
  license "GPL-2.0-or-later"
  head "https://github.com/sysstat/sysstat.git", branch: "master"

  bottle do
    sha256 arm64_linux:  "3043eefebf552d698f327d67e02fd1c5e712dc098dca13504977101a02965d58"
    sha256 x86_64_linux: "78ff08b5505015157b91169a5363cbbdaa455c7c1dcafedb1c79e58305b25dc3"
  end

  depends_on :linux

  def install
    system "./configure",
           "--disable-file-attr", # Fix install: cannot change ownership
           "--disable-automated-sar-reporting",
           "--prefix=#{prefix}",
           "conf_dir=#{etc}/sysconfig",
           "sa_dir=#{var}/log/sa"
    system "make", "install"
  end

  test do
    assert_match("PID", shell_output("#{bin}/pidstat"))
    assert_match("avg-cpu", shell_output("#{bin}/iostat"))
  end
end
