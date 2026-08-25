class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://github.com/protonpass/pass-cli/archive/refs/tags/2.3.3.tar.gz"
  sha256 "a064b89fc4fb5d2db47a99e46e1782b7672dc1078e2ecbb881d0910c01947611"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "38a6fa2eb26adc431cf0e61cb5ef9ed3d9b498e6ded13693976af4f9c2c61da7"
    sha256 cellar: :any, arm64_sequoia: "a6d52f9747b9316f3e00b5c0cd03d69109bbdb4aa83cb22d6c8d8e34bac1d23a"
    sha256 cellar: :any, arm64_sonoma:  "c817d8e5de79dc347620e0bcdb3806a169520d19e56d7cbb5d41f6e7e52553ec"
    sha256 cellar: :any, sonoma:        "d11daf4c337ccbd8a8e40c88b0700ab2d8f56bfac367077129e004cc326c6075"
    sha256 cellar: :any, arm64_linux:   "f819202a61dcad8a907a37c805e048bc3fcaabb44164a2b624a2cbb0803b9b60"
    sha256 cellar: :any, x86_64_linux:  "118336f0c80d347450c1242a180fd7444524480845ea55d2bee3f2a44d0c8f3b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  # Upstream does not currently accept external contributions.
  # Increase the recursion limit required to compile pass-cli 2.3.3.
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    ENV["PROTON_PASS_KEY_PROVIDER"] = "fs"
    output_log = testpath/"output.log"
    pid = spawn bin/"pass-cli", "login", [:out, :err] => output_log.to_s
    sleep 5
    assert_match "Waiting for authentication to complete", output_log.read
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/pass-cli/src/main.rs b/pass-cli/src/main.rs
index 43cff31..55c8597 100644
--- a/pass-cli/src/main.rs
+++ b/pass-cli/src/main.rs
@@ -1,3 +1,4 @@
+#![recursion_limit = "256"]
 /*
  *  Copyright (c) 2026 Proton AG
  *  This file is part of Proton AG and Proton Pass.
