class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "bda1335674e3e0fc7f2cc34f3b5aeffc0cf9144e639f82636103eba4427674fd"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9b75c10f3f3cc618ea1f2b173ab77c3e43e855c9fbe8f585d90547bd7e4dda7a"
    sha256 cellar: :any, arm64_sequoia: "0677172b241f814dfe08838b30d589ef0e6b7e02ea192072266c02801bffb262"
    sha256 cellar: :any, arm64_sonoma:  "a7b41ef4cb47eecccbd0b601d5a676e6a00a8f013edf94297bee218da78f418e"
    sha256 cellar: :any, sonoma:        "0680f1c1a394dcc8a8da45541455316e11aecf40d4a118e03c3876166e93cdfa"
    sha256 cellar: :any, arm64_linux:   "1407b3c062987e33acec4793f4404b01ad906200199fcb6826c16ca9c2b87db2"
    sha256 cellar: :any, x86_64_linux:  "49032aa6e84f448dfd93f148a15e98c5a9458281698d25bf93d281a443f635b4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli")
  end

  test do
    assert_match "sem #{version}", shell_output("#{bin}/sem --version")

    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")
    PYTHON
    system "git", "init"
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "init"

    inreplace "hello.py", "hello", "hello world"
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "update"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end
