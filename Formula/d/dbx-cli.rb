class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.72.tar.gz"
  sha256 "b598161f76fa39090a8771ef501f1763841e127686c8e988ade1db68c1b2abe1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6f1432524ef87baac5061919e4261c90055005c6c08599117e4fadbdc780b74d"
    sha256 cellar: :any, arm64_sequoia: "f1c11549001fccf0f383aa7fb2963e3033134138b73952d9681dc465c252d2fc"
    sha256 cellar: :any, arm64_sonoma:  "e64051b30c378bda63350974a4e4df227a4d5c81363d4423e62e2b60d7488908"
    sha256 cellar: :any, sonoma:        "329fe3a9f7856c0362ef289a541c027d169e3d08fc645120db645aeeeff3cae6"
    sha256 cellar: :any, arm64_linux:   "d74fece57469d01be1e38efb45429345beb9694f6af22efbbd8552e575090936"
    sha256 cellar: :any, x86_64_linux:  "6773c75bb26a714eece27df870bd748d2d4394252be18dca90fee0e2d4c1181c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end
