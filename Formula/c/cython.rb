class Cython < Formula
  include Language::Python::Virtualenv

  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
  sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  license "Apache-2.0"
  head "https://github.com/cython/cython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "358494dd438b6caf95b5825447aa441fcdc200e4b008560ab52fa20c1376b232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff7e747126e3ed1b3e734d98d9713e0ae0f88d164d2f06178a91dd7cc6aaa7ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e9f7ba23b698b4f593357836e2a2d2b04cf8b2943bbb838afad96ec5db0cf31"
    sha256 cellar: :any_skip_relocation, sonoma:        "08d82f2422d40e30eb4a7e9891782a11c7b3a894b8a32136496fb858272d1605"
    sha256 cellar: :any,                 arm64_linux:   "8a5a6e2b7834c29101c6bad445eebeeccd19ce4982d64aa3b52c80ce409323c7"
    sha256 cellar: :any,                 x86_64_linux:  "61acb557900d8dc288d94fa0646cfff0ae83c78dd17b5e05c4218da71f593970"
  end

  depends_on "python@3.14"

  # https://github.com/cython/cython/issues/5976
  pypi_packages extra_packages: "setuptools"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    phrase = "You are using Homebrew"
    (testpath/"example.pyx").write "print '#{phrase}'"

    system bin/"cythonize", "--inplace", "example.pyx"
    assert_match phrase, shell_output("#{libexec}/bin/python -c 'import example'")
  end
end
