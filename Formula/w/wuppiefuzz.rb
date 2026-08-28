class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.7.0/source.tar.gz"
  sha256 "4982dd9b1c1ea9424a58b8c88b373f59c096c78da6396069d9aa3fa77a57120a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e8037ccfb5cfa779c6de770cc8c05eeab1b0bc79489e423b5f1fd01ec25894ea"
    sha256 cellar: :any, arm64_sequoia: "47252a24acf6212b48e89956320ebb5341479d30120aec133debc9d399c00ed8"
    sha256 cellar: :any, arm64_sonoma:  "99b248c1b5fd94d3e76169a3c45be180dab6ca587264d61f972a9f7432790c31"
    sha256 cellar: :any, arm64_linux:   "ce21391de125a70fb388e8196134480ecc170afd93481afd91215b277706f0f2"
    sha256 cellar: :any, x86_64_linux:  "9b7093dfd3f75f4b6317ffabac3529a3d22dfee29f8f9336aab9da00dc9417e4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "z3"

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    rm ".cargo/config.toml" # macOS `-stack_size` flag breaks proc-macro linking
    ENV["Z3_LIBRARY_PATH_OVERRIDE"] = formula_opt_lib("z3")
    ENV["Z3_SYS_Z3_HEADER"] = formula_opt_include("z3")/"z3.h"
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: ["std"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wuppiefuzz version")

    (testpath/"openapi.yaml").write <<~YAML
      openapi: 3.0.0
    YAML

    output = shell_output("#{bin}/wuppiefuzz fuzz openapi.yaml 2>&1", 1)
    assert_match "Error: Error parsing OpenAPI-file at openapi.yaml", output
  end
end
