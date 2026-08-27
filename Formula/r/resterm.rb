class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "49749f45cf6c5182b238b9c527d6e5e2aa65bd087c3425da9a9de72f6e9b0a18"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd532504d4ea765907c7734354c25923566702f82673d71cae0b2b436b7d3598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd532504d4ea765907c7734354c25923566702f82673d71cae0b2b436b7d3598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd532504d4ea765907c7734354c25923566702f82673d71cae0b2b436b7d3598"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b2e58f0a775ab989b2e01c0a3d8550716cbbeb2683334d7d4b79a5c275b2675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74646ca755a872cd349205134840cd2e41077dc7cd20afe84976aeb3500fc838"
    sha256 cellar: :any,                 x86_64_linux:  "3d4a305bc5a5923a8cbd4852130fe1ce64aeae5bb034cdae004ee9c0e49d2a8a"
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
