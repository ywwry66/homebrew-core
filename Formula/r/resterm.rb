class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "ab147a547b094e61fb75d9fe92f08dc48200915c099ed2018bc8b8e773af97ba"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "665f71ff272dc3e9564d6300171f4f23b09a91eadd76c3a92b64e4e8a4cf4f1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "665f71ff272dc3e9564d6300171f4f23b09a91eadd76c3a92b64e4e8a4cf4f1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "665f71ff272dc3e9564d6300171f4f23b09a91eadd76c3a92b64e4e8a4cf4f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1c043da93b77740a7679d8f52ac5384c89a83920f55e4db7cf979ff70709e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b42f43b82cc29854e0d7b0a0e9c75fa5c6ef380b36b29e5bb34ff4ec1a9e237c"
    sha256 cellar: :any,                 x86_64_linux:  "5d11904cc9cc7dda6c4d5e609b5e7139724860508f664b3d4f9d04ecfcf60c5f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
