class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "ec2cd213f36b4fee1e73f8da528a8e19344d1013d4a1af5005f66bc44f0b93fc"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94dfdfdad58ffd5a2afecbfd7190abf9eb7cee51d9c3479a0848d531380e62c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94dfdfdad58ffd5a2afecbfd7190abf9eb7cee51d9c3479a0848d531380e62c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94dfdfdad58ffd5a2afecbfd7190abf9eb7cee51d9c3479a0848d531380e62c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "77021f454ddc46b4247f27f1df7259e25ad3503e737c3cab323d2fc21969a899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "999aaeb750b97bc77d6fd965c8611d96c915eaea7fe6e662ae38f0b6894c0020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e961714b3a59a54dd58ecb612e56040573ebd456d718c17ee2409ee325fc9b"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    path = testpath/"school.sql"
    path.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = shell_output("sqlite3 test.db < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names

    assert_match "terminal not cursor addressable", shell_output("#{bin}/lazysql test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/lazysql -version 2>&1")
  end
end
