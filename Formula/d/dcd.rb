class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.16.7",
      revision: "97ab969f42829605df76048100c4c22d21e338df"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "c6dddfeebc08d614a5bc73c376b362d8c61607e8b4fd5ccaa05357d6e322363a"
    sha256               arm64_sequoia: "c10ec5dc66e7a727d95b65d3ace12886ec3fd0123887ef41aa1c1215f2d90268"
    sha256               arm64_sonoma:  "4cdf88e325d2e5575ce777cc32f52d9dbcb565ccff0195233e7583a5de99578e"
    sha256 cellar: :any, arm64_linux:   "b901382e57a359d9c7ed135267b3130001228eb418dc641c5c8561cffa20ecfb"
    sha256 cellar: :any, x86_64_linux:  "b7a9096350e21a686c9d489a87da4c8bf3916f4159157ce395560704fb79f5b2"
  end

  depends_on "ldc" => :build

  def install
    system "make", "ldc"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = spawn bin/"dcd-server", "-p", port.to_s
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system bin/"dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
