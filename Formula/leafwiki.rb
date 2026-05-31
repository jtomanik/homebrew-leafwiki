class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.2d6239f.1"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.2d6239f.1/leafwiki-0.11.0-dev.2d6239f.1-darwin-arm64.tar.gz"
    sha256 "1884aed09fd981c99be737f885ed6c49fdf9ced9cd343185cca6c90ece012229"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.2d6239f.1/leafwiki-0.11.0-dev.2d6239f.1-darwin-amd64.tar.gz"
    sha256 "96cbbb329a649830b4cc43201ffd64322f5548ca34b7015a1cb4983549d05f59"
  end

  def install
    inreplace "run-mcp.sh", "leafwiki-mcp-stdio", "leafwiki-local-mcp"

    bin.install "leafwiki"
    bin.install "leafwiki-local-mcp"
    bin.install "run-mcp.sh"
  end

  test do
    assert_match "LeafWiki", shell_output("#{bin}/leafwiki --help 2>&1")
    assert_match "leafwiki-mcp-stdio bridges", shell_output("#{bin}/leafwiki-local-mcp --help 2>&1")
    assert_match "leafwiki-local-mcp", shell_output("#{bin}/run-mcp.sh --dry-run --api-key test 2>&1")
  end
end
