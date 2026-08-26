class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "114bc52eb1087ff99bba8a6900d35c24543b9feecf5db42798df3813f9de51af"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3528188d5efe7340308957bc1664654ba4ab7f4ee660838e4f8b111f65fc62ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3528188d5efe7340308957bc1664654ba4ab7f4ee660838e4f8b111f65fc62ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3528188d5efe7340308957bc1664654ba4ab7f4ee660838e4f8b111f65fc62ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a905a13d5fb13c536ab72c528b7feb6674346ea97c3fadd06ffa48405e1aadb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83dbbe6dbf4b1a533a5189c85e8c442338acbf0b59db955d3c20bf76ded64cae"
    sha256 cellar: :any,                 x86_64_linux:  "3cdd61da67842d9ff221b38a8e1dad284a1063f42a6cd885d02956d59cbea57b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
