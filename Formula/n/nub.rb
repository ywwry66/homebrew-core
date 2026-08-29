class Nub < Formula
  desc "Fast TypeScript runtime and package manager that augments Node"
  homepage "https://nubjs.com"
  url "https://github.com/nubjs/nub/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f9d9d2e2be64aab0c0c5a0b672f40434973776eac4f8544173cc36246c321992"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb833993318751e217b3423277271f507bd6c3c00d3981b39fbf4215375d77c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "470ed43b0231f7849cb0dfbdea694b2e4503f0814c7154a6b3d7c9c8b12a6638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1ca74aa17b8e1af37786cb1aa070af38fd36fb3e941b5c9be1a0b14571bbb79"
    sha256 cellar: :any,                 arm64_linux:   "7074f9a1ee3e8b6c3b91e63e5939469ac84d80450b80b377e6cc14950cd91f84"
    sha256 cellar: :any,                 x86_64_linux:  "71697561cf14a32ce6b94ea2ee37c178fd038b9c1d989e77f00ddb7645fcd020"
  end

  depends_on "cmake" => :build
  depends_on "node" => [:build, :test]
  depends_on "rust" => :build

  def install
    # `runtime` has no package.json, so npm resolves up to the repository root
    # either way. Install there, where package-lock.json pins the versions.
    system "npm", "install", *std_npm_args(prefix: false)

    # The `embed-runtime` feature tars `runtime` into the binary, and the tree that
    # binary extracts at runtime has no parent node_modules to resolve through. Copy
    # in the packages that tree loads: the transpile helpers and the web API
    # polyfills. Without them the build still succeeds, but the binary fails to run
    # any file that needs a helper and silently drops Temporal, URLPattern and
    # Float16Array on Node versions that lack them natively.
    %w[
      @js-temporal/polyfill
      @oxc-project/runtime
      @petamoriken/float16
      jsbi
      urlpattern-polyfill
    ].each do |dep|
      (buildpath/"runtime/node_modules"/dep).dirname.mkpath
      cp_r buildpath/"node_modules"/dep, buildpath/"runtime/node_modules"/dep
    end

    cd "crates/nub-native" do
      system "cargo", "build", "--release", "--lib"
    end
    mkdir_p "runtime/addons"
    cp shared_library("target/release/libnub_native"), "runtime/addons/nub-native.node"

    system "cargo", "install", *std_cargo_args(path: "crates/nub-cli", features: ["embed-runtime"])
    bin.install_symlink bin/"nub" => "nubx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nub --version")
    assert_match "Usage: nub nubx", shell_output("#{bin}/nubx --help")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-app",
        "version": "1.0.0"
      }
    JSON

    # Transpile a file that pulls a helper out of the vendored runtime node_modules.
    # Legacy decorators are down-levelled on every Node version, so this covers the
    # embedded runtime whichever Node is on PATH.
    (testpath/"tsconfig.json").write <<~JSON
      {"compilerOptions": {"experimentalDecorators": true, "emitDecoratorMetadata": true}}
    JSON
    (testpath/"decorated.ts").write <<~TYPESCRIPT
      function log(target: any, key: string, descriptor: PropertyDescriptor) { return descriptor; }
      class Greeter { @log greet(): string { return "hello nub"; } }
      console.log(new Greeter().greet());
    TYPESCRIPT
    assert_equal "hello nub", shell_output("#{bin}/nub decorated.ts").strip

    system bin/"nub", "config", "set", "registry", "https://registry.npmjs.org"
    assert_match "https://registry.npmjs.org", shell_output("#{bin}/nub config get registry")
  end
end
